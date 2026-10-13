#!/usr/bin/env python3
"""Build emojis.tsv, the search index used by emoji-search.

Merges, per emoji:
  - the Unicode CLDR name and keywords (via emojibase-data)
  - shortcodes from GitHub, Slack (iamcal), Discord/JoyPixels, CLDR and emojibase
  - GitHub gemoji aliases and tags
  - group/subgroup names (e.g. "food drink", "animal mammal")

Run it again to pick up a new Unicode/emojibase release:
    /usr/bin/python3 build_index.py [emojibase-version]

Columns (tab separated, one emoji per line, in Unicode order):
  emoji, display name, names|, shortcodes|, keywords|, categories|, skins (tone1..tone5, comma separated)
Search columns are pre-normalized: lowercase, ascii-folded, words separated by single spaces.
"""

import json
import os
import re
import sys
import unicodedata
import urllib.request

EMOJIBASE_VERSION = sys.argv[1] if len(sys.argv) > 1 else "17.0.0"
EMOJIBASE = f"https://cdn.jsdelivr.net/npm/emojibase-data@{EMOJIBASE_VERSION}/en"
GEMOJI = "https://raw.githubusercontent.com/github/gemoji/master/db/emoji.json"
SHORTCODE_SETS = ["github", "iamcal", "joypixels", "emojibase", "cldr"]
COMPONENT_GROUP = 2  # skin tone / hair swatches


def fetch(url):
    with urllib.request.urlopen(url, timeout=30) as resp:
        return json.load(resp)


def norm(text):
    text = unicodedata.normalize("NFKD", text)
    text = "".join(c for c in text if not unicodedata.combining(c)).lower()
    text = text.replace("’", "").replace("'", "")
    return re.sub(r"[^a-z0-9+]+", " ", text).strip()


def uniq(items):
    seen, out = set(), []
    for item in items:
        if item and item not in seen:
            seen.add(item)
            out.append(item)
    return out


def strip_vs(emoji):
    return emoji.replace("️", "")


def main():
    data = fetch(f"{EMOJIBASE}/data.json")
    messages = fetch(f"{EMOJIBASE}/messages.json")
    shortcodes = {name: fetch(f"{EMOJIBASE}/shortcodes/{name}.json") for name in SHORTCODE_SETS}
    gemoji = {strip_vs(e["emoji"]): e for e in fetch(GEMOJI)}

    groups = {g["order"]: g["message"] for g in messages["groups"]}
    subgroups = {g["order"]: g["message"] for g in messages["subgroups"]}

    rows = []
    for entry in sorted(data, key=lambda e: e.get("order", 1e9)):
        if "group" not in entry or entry["group"] == COMPONENT_GROUP:
            continue

        hexcode = entry["hexcode"]
        codes = []
        for name in SHORTCODE_SETS:
            value = shortcodes[name].get(hexcode, [])
            codes += [value] if isinstance(value, str) else value

        gem = gemoji.get(strip_vs(entry["emoji"]), {})
        codes += gem.get("aliases", [])
        keywords = entry.get("tags", []) + gem.get("tags", [])

        names = [entry["label"]]
        if gem.get("description"):
            names.append(gem["description"])

        names = uniq(norm(n) for n in names)
        codes = uniq(norm(c) for c in codes)
        keywords = [k for k in uniq(norm(k) for k in keywords) if k not in names]
        categories = uniq([norm(groups.get(entry["group"], "")), norm(subgroups.get(entry.get("subgroup"), ""))])

        skins = [""] * 5
        for skin in entry.get("skins", []):
            tone = skin["tone"]
            if isinstance(tone, list):
                if len(set(tone)) != 1:
                    continue
                tone = tone[0]
            if not skins[tone - 1]:
                skins[tone - 1] = skin["emoji"]

        rows.append([
            entry["emoji"],
            entry["label"],
            "|".join(names),
            "|".join(codes),
            "|".join(keywords),
            "|".join(categories),
            ",".join(skins) if any(skins) else "",
        ])

    out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "emojis.tsv")
    with open(out, "w", encoding="utf-8") as f:
        for row in rows:
            f.write("\t".join(c.replace("\t", " ") for c in row) + "\n")
    print(f"wrote {len(rows)} emojis to {out} (emojibase {EMOJIBASE_VERSION})")


if __name__ == "__main__":
    main()
