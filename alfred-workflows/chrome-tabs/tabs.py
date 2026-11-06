#!/usr/bin/python3
"""Alfred Script Filter: list the open tabs of every Chrome window.

Chrome only exposes live tabs through its AppleScript dictionary, so this asks
it via JXA (one bulk Apple Event per property, not one per tab). Alfred does the
fuzzy filtering (alfredfiltersresults), so this runs once per session and emits
everything. Items stay in Chrome's order: windows front to back, tabs left to
right. Each carries the window and tab ids that focus.js uses to switch to it.

Chrome is never launched: if it is not running there is nothing to list.

A window's profile (avatar icon, subtitle label) comes from its on-screen title,
read through System Events, because the AppleScript window name omits it. That read
is fragile (permissions, a slow System Events, titles changing between the two
queries), but a window never changes profile, so each profile is remembered per
Chrome window id once it is certain (window-profiles.json in the workflow cache
folder) and reused whenever a later read fails. The cache is dropped when Chrome
quits, since window ids do not survive a restart.

TABS_JSON=<file> replaces the Chrome query with a saved JSON dump, and
TABS_AX=<file> the on-screen titles with a JSON list (null simulates a failed read),
for testing; alfred_workflow_cache=<dir> moves the cache.
"""
import json
import os
import re
import subprocess
import sys
from urllib.parse import urlparse

CHROME = os.path.expanduser("~/Library/Application Support/Google/Chrome")
CACHE_DIR = os.environ.get("alfred_workflow_cache") or os.path.expanduser("~/Library/Caches/com.moliva.chrome-tabs")
CACHE_FILE = os.path.join(CACHE_DIR, "window-profiles.json")
ERROR_FILE = os.path.join(CACHE_DIR, "titles-error.txt")

LIST_JXA = """
const wins = Application("Google Chrome").windows;
const ids = wins.id(), names = wins.name(), modes = wins.mode();
const active = wins.activeTabIndex();
const tabIds = wins.tabs.id(), titles = wins.tabs.title(), urls = wins.tabs.url();
JSON.stringify(ids.map((id, i) => ({
  id, name: names[i], mode: modes[i], active: active[i],
  tabs: tabIds[i].map((t, j) => ({id: t, title: titles[i][j], url: urls[i][j]})),
})));
"""


TITLES_JXA = """
JSON.stringify(Application("System Events").processes.byName("Google Chrome").windows.name());
"""

TITLE_RE = re.compile(r"^(.*) [-–] Google Chrome(?: [-–] (.+))?$")
MEMORY_NOTE_RE = re.compile(r" [-–] High memory usage [-–] [\d.,]+ ?[KMGT]?B$")


def chrome_running():
    return subprocess.run(["/usr/bin/pgrep", "-x", "Google Chrome"], capture_output=True).returncode == 0


def load_cache():
    try:
        with open(CACHE_FILE, encoding="utf-8") as f:
            data = json.load(f)
        return data if isinstance(data, dict) else {}
    except (OSError, ValueError):
        return {}


def store_cache(new, old):
    if new == old:
        return
    try:
        os.makedirs(CACHE_DIR, exist_ok=True)
        tmp = CACHE_FILE + ".tmp"
        with open(tmp, "w", encoding="utf-8") as f:
            json.dump(new, f)
        os.replace(tmp, CACHE_FILE)
    except OSError:
        pass  # the cache only makes things sturdier; never fail the listing over it


def note_error(error):
    """Keep the last reason window titles could not be read, for troubleshooting."""
    try:
        if error:
            os.makedirs(CACHE_DIR, exist_ok=True)
            with open(ERROR_FILE, "w", encoding="utf-8") as f:
                f.write(error + "\n")
        elif os.path.exists(ERROR_FILE):
            os.remove(ERROR_FILE)
    except OSError:
        pass


def remember_profiles(windows, error):
    """A window keeps its profile, and its Chrome window id, for as long as it is open.
    Remember each profile once it is certain, and reuse it whenever the title read
    fails or cannot be paired. Entries for closed windows are dropped."""
    old = load_cache()
    fresh = {}
    for window in windows:
        wid = str(window["id"])
        if window.get("certain"):
            fresh[wid] = window["profile_name"]
        elif wid in old:
            window["profile_name"] = fresh[wid] = old[wid]
        elif error and not window.get("profile_name") and window.get("mode") != "incognito":
            window["profile_unknown"] = True
    store_cache(fresh, old)
    note_error(error)


def fetch_windows():
    dump = os.environ.get("TABS_JSON")
    if dump:
        with open(dump, encoding="utf-8") as f:
            windows = json.load(f)
    else:
        if not chrome_running():
            store_cache({}, load_cache())  # window ids do not survive a Chrome restart
            return []
        result = subprocess.run(
            ["/usr/bin/osascript", "-l", "JavaScript", "-e", LIST_JXA],
            capture_output=True,
            text=True,
            timeout=15,
        )
        if result.returncode != 0:
            raise RuntimeError(result.stderr.strip() or "osascript failed")
        windows = json.loads(result.stdout)
    titles, error = screen_titles()
    attach_screen_titles(windows, titles)
    remember_profiles(windows, error)
    return windows


def profiles():
    """Profile display name -> profile directory, from Chrome's Local State."""
    try:
        with open(os.path.join(CHROME, "Local State"), encoding="utf-8") as f:
            cache = json.load(f)["profile"]["info_cache"]
    except (OSError, ValueError, KeyError):
        return {}
    known = {info.get("name") or directory: directory for directory, info in cache.items()}
    for directory, info in cache.items():  # Chrome also labels windows by account name
        for key in (info.get("gaia_given_name"), info.get("gaia_name"), directory):
            if key:
                known.setdefault(key, directory)
    return known


def screen_titles():
    """Window titles as shown on screen, front to back. Unlike the AppleScript
    window name, these end in '- Google Chrome - <profile>'. Needs Accessibility;
    without it there are no titles. Returns (titles, error): error is None on success,
    otherwise why they are missing. Tried twice, since System Events can be slow to
    wake."""
    dump = os.environ.get("TABS_AX")
    if dump:
        with open(dump, encoding="utf-8") as f:
            data = json.load(f)
        return (data, None) if data is not None else ([], "stubbed failure")
    reason = "unknown"
    for _ in range(2):
        try:
            result = subprocess.run(
                ["/usr/bin/osascript", "-l", "JavaScript", "-e", TITLES_JXA],
                capture_output=True,
                text=True,
                timeout=10,
            )
        except subprocess.TimeoutExpired:
            reason = "timed out reading window titles"
            continue
        except OSError as error:
            return [], str(error)
        if result.returncode == 0:
            try:
                return json.loads(result.stdout), None
            except ValueError:
                reason = "unreadable window titles"
                continue
        reason = result.stderr.strip() or f"osascript exited {result.returncode}"
    return [], reason


def attach_screen_titles(windows, titles):
    """Pair each AppleScript window with its on-screen title: the first unused one
    whose text before ' - Google Chrome' is the window's name (the active tab's
    title). Chrome may append notes there ('- High memory usage - 849 MB'), so an
    exact match is preferred and a 'name - …' prefix match is the fallback.
    Same-titled windows pair in order. A pairing is marked certain only when it is an
    exact match and every on-screen title matching the window names the same profile,
    which is what makes it safe to remember."""
    parsed = [TITLE_RE.match(title or "") for title in titles]
    text = [MEMORY_NOTE_RE.sub("", m.group(1)) if m else "" for m in parsed]
    used = set()
    for window in windows:
        name = window.get("name") or ""
        for exact in (True, False):
            matches = [
                i
                for i, match in enumerate(parsed)
                if match and (text[i] == name if exact else text[i].startswith(name + " - "))
            ]
            free = [i for i in matches if i not in used]
            if not free:
                continue
            used.add(free[0])
            window["profile_name"] = parsed[free[0]].group(2)
            names = {parsed[i].group(2) for i in matches}
            window["certain"] = exact and len(names) == 1 and None not in names
            break


def window_profile(window, known):
    """(name, directory) of the window's profile, or (None, None) if unknown."""
    name = window.get("profile_name")
    if not name:
        return None, None
    if name in known:
        return name, known[name]
    # Chrome writes 'Account (profile name)' when accounts share a name
    match = re.match(r"^(.*) \((.+)\)$", name)
    for part in (match.groups()[::-1] if match else ()):
        if part in known:
            return name, known[part]
    return name, None


def items(windows):
    known = profiles()
    for number, window in enumerate(windows, start=1):
        incognito = window.get("mode") == "incognito"
        profile, directory = window_profile(window, known)
        label = "Incognito" if incognito else f"Window {number}"
        if profile:
            label += f" · {profile}"
        elif window.get("profile_unknown"):
            label += " · profile unknown"
        icon = {"path": "icon.png"}
        if directory:
            avatar = os.path.join(CHROME, directory, "Google Profile Picture.png")
            if os.path.isfile(avatar):
                icon = {"path": avatar}
        for position, tab in enumerate(window.get("tabs", []), start=1):
            url = tab.get("url") or ""
            title = tab.get("title") or url or "New Tab"
            host = urlparse(url).netloc or url
            marker = "▶ " if position == window.get("active") else ""
            yield {
                "title": title,
                "subtitle": f"{marker}[{label}]  {host}",
                "arg": url,
                "match": f"{title} {label} {host} {url}",
                "icon": icon,
                "quicklookurl": url,
                "text": {"copy": url, "largetype": url},
                "variables": {"win": str(window["id"]), "tab": str(tab["id"]), "action": "focus"},
                "mods": {
                    "cmd": {
                        "subtitle": f"Copy URL: {url}",
                        "arg": url,
                        "variables": {"win": str(window["id"]), "tab": str(tab["id"]), "action": "copy"},
                    },
                },
            }


def main():
    try:
        out = list(items(fetch_windows()))
    except Exception as error:  # surfaced as a result row: Alfred hides stderr
        out = [{"title": "Could not read Chrome tabs", "subtitle": str(error), "valid": False}]
    else:
        if not out:
            out = [{"title": "No open Chrome tabs", "subtitle": "Is Chrome running?", "valid": False}]
    json.dump({"items": out}, sys.stdout)


if __name__ == "__main__":
    main()
