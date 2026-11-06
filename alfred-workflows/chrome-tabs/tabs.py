#!/usr/bin/python3
"""Alfred Script Filter: list the open tabs of every Chrome window.

Chrome only exposes live tabs through its AppleScript dictionary, so this asks
it via JXA (one bulk Apple Event per property, not one per tab). Alfred does the
fuzzy filtering (alfredfiltersresults), so this runs once per session and emits
everything. Items stay in Chrome's order: windows front to back, tabs left to
right. Each carries the window and tab ids that focus.js uses to switch to it.

Chrome is never launched: if it is not running there is nothing to list.

TABS_JSON=<file> replaces the Chrome query with a saved JSON dump, for testing.
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


def chrome_running():
    return subprocess.run(["/usr/bin/pgrep", "-x", "Google Chrome"], capture_output=True).returncode == 0


def fetch_windows():
    dump = os.environ.get("TABS_JSON")
    if dump:
        with open(dump, encoding="utf-8") as f:
            return json.load(f)
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
    return json.loads(result.stdout)


def profiles():
    """Profile display name -> profile directory, from Chrome's Local State."""
    try:
        with open(os.path.join(CHROME, "Local State"), encoding="utf-8") as f:
            cache = json.load(f)["profile"]["info_cache"]
    except (OSError, ValueError, KeyError):
        return {}
    return {info.get("name") or directory: directory for directory, info in cache.items()}


def window_profile(window_name, known):
    """Chrome titles a window '<tab> - Google Chrome - <profile>' once several
    profiles exist. Returns (name, directory), or (None, None) if it is absent."""
    match = re.search(r"Google Chrome\s+[-–]\s+(.+)$", window_name or "")
    if match and match.group(1) in known:
        return match.group(1), known[match.group(1)]
    return None, None


def items(windows):
    known = profiles()
    for number, window in enumerate(windows, start=1):
        incognito = window.get("mode") == "incognito"
        profile, directory = window_profile(window.get("name"), known)
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
