#!/usr/bin/python3
"""Alfred Script Filter: list bookmarks from every Chrome profile.

Alfred does the fuzzy filtering (alfredfiltersresults), so this runs once per
session and emits everything. Each item carries its source profile, shown via
the profile avatar icon and a subtitle prefix, and opens in that profile.
"""
import json
import os
import sys
from urllib.parse import urlparse

CHROME = os.path.expanduser("~/Library/Application Support/Google/Chrome")
ROOT_LABELS = {"bookmark_bar": "Bookmarks bar", "other": "Other", "synced": "Mobile"}
SKIP_SCHEMES = ("javascript:", "chrome:", "data:")


def profiles():
    try:
        with open(os.path.join(CHROME, "Local State"), encoding="utf-8") as f:
            cache = json.load(f)["profile"]["info_cache"]
    except (OSError, ValueError, KeyError):
        cache = {}
    only = {p.strip() for p in os.environ.get("profiles", "").split(",") if p.strip()}
    for directory, info in cache.items():
        name = info.get("name") or directory
        if only and directory not in only and name not in only:
            continue
        path = os.path.join(CHROME, directory)
        if os.path.isfile(os.path.join(path, "Bookmarks")):
            yield directory, name, path


def walk(node, trail):
    if node.get("type") == "url":
        yield node, trail
        return
    for child in node.get("children", []):
        sub = trail + [child["name"]] if child.get("type") == "folder" else trail
        yield from walk(child, sub)


def items():
    for directory, name, path in profiles():
        try:
            with open(os.path.join(path, "Bookmarks"), encoding="utf-8") as f:
                roots = json.load(f).get("roots", {})
        except (OSError, ValueError):
            continue
        avatar = os.path.join(path, "Google Profile Picture.png")
        icon = {"path": avatar} if os.path.isfile(avatar) else {"path": "icon.png"}
        for root_key, root in roots.items():
            if not isinstance(root, dict):
                continue
            base = [ROOT_LABELS.get(root_key, root.get("name", root_key))]
            for node, trail in walk(root, base):
                url = node.get("url", "")
                if not url or url.startswith(SKIP_SCHEMES):
                    continue
                title = node.get("name") or url
                folder = " › ".join(trail)
                host = urlparse(url).netloc or url
                yield {
                    "uid": f"{directory}:{node.get('guid') or node.get('id')}",
                    "title": title,
                    "subtitle": f"[{name}]  {folder}  ·  {host}",
                    "arg": url,
                    "match": f"{title} {name} {folder} {host} {url}",
                    "icon": icon,
                    "quicklookurl": url,
                    "text": {"copy": url, "largetype": url},
                    "variables": {"profile": directory, "action": "open"},
                    "mods": {
                        "cmd": {
                            "subtitle": f"Copy URL: {url}",
                            "arg": url,
                            "variables": {"profile": directory, "action": "copy"},
                        },
                        "alt": {
                            "subtitle": f"Open in {name} — {url}",
                            "arg": url,
                            "variables": {"profile": directory, "action": "open"},
                        },
                    },
                }


def main():
    out = list(items())
    if not out:
        out = [{"title": "No Chrome bookmarks found", "subtitle": CHROME, "valid": False}]
    json.dump({"cache": {"seconds": 60, "loosereload": True}, "items": out}, sys.stdout)


if __name__ == "__main__":
    main()
