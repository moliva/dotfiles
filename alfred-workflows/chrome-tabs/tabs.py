#!/usr/bin/python3
"""Alfred Script Filter: list the open tabs of every Chrome window.

Chrome only exposes live tabs through its AppleScript dictionary, so this asks
it via JXA (one bulk Apple Event per property, not one per tab). Alfred does the
fuzzy filtering (alfredfiltersresults), so this runs once per session and emits
everything. Items stay in Chrome's order: windows front to back, tabs left to
right. Each carries the window and tab ids that focus.js uses to switch to it.

Chrome is never launched: if it is not running there is nothing to list.

A window's profile (avatar icon, subtitle label) comes from its on-screen title,
read through System Events, because the AppleScript window name omits it.

TABS_JSON=<file> replaces the Chrome query with a saved JSON dump, and
TABS_AX=<file> the on-screen titles with a JSON list, for testing.
"""
import json
import os
import re
import subprocess
import sys
from urllib.parse import urlparse

CHROME = os.path.expanduser("~/Library/Application Support/Google/Chrome")

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


def chrome_running():
    return subprocess.run(["/usr/bin/pgrep", "-x", "Google Chrome"], capture_output=True).returncode == 0


def fetch_windows():
    dump = os.environ.get("TABS_JSON")
    if dump:
        with open(dump, encoding="utf-8") as f:
            windows = json.load(f)
        attach_screen_titles(windows, screen_titles())
        return windows
    if not chrome_running():
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
    attach_screen_titles(windows, screen_titles())
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
    without it (or on any failure) there are no titles and no profile is shown."""
    dump = os.environ.get("TABS_AX")
    if dump:
        with open(dump, encoding="utf-8") as f:
            return json.load(f)
    try:
        result = subprocess.run(
            ["/usr/bin/osascript", "-l", "JavaScript", "-e", TITLES_JXA],
            capture_output=True,
            text=True,
            timeout=5,
        )
        return json.loads(result.stdout) if result.returncode == 0 else []
    except (OSError, subprocess.SubprocessError, ValueError):
        return []


def attach_screen_titles(windows, titles):
    """Pair each AppleScript window with its on-screen title: the first unused one
    whose text before ' - Google Chrome' is the window's name (the active tab's
    title). Chrome may append notes there ('- High memory usage - 849 MB'), so an
    exact match is preferred and a 'name - …' prefix match is the fallback.
    Same-titled windows pair in order."""
    parsed = [TITLE_RE.match(title or "") for title in titles]
    used = set()
    for window in windows:
        name = window.get("name") or ""
        for exact in (True, False):
            hit = next(
                (
                    i
                    for i, match in enumerate(parsed)
                    if match
                    and i not in used
                    and (match.group(1) == name if exact else match.group(1).startswith(name + " - "))
                ),
                None,
            )
            if hit is not None:
                used.add(hit)
                window["profile_name"] = parsed[hit].group(2)
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
