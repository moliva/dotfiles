#!/bin/sh
# Compile emoji-search as a universal binary. Pass --data to also refresh emojis.tsv first.
set -e
cd "$(dirname "$0")"
[ "$1" = "--data" ] && /usr/bin/python3 -I build_index.py
swiftc -O -target arm64-apple-macos12 search.swift -o /tmp/emoji-search-arm64
swiftc -O -target x86_64-apple-macos12 search.swift -o /tmp/emoji-search-x86_64
lipo -create /tmp/emoji-search-arm64 /tmp/emoji-search-x86_64 -output emoji-search
rm -f /tmp/emoji-search-arm64 /tmp/emoji-search-x86_64
echo "built $(pwd)/emoji-search"
