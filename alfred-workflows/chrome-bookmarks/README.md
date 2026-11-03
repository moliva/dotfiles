# Chrome Bookmarks

Search bookmarks from every Chrome profile in one list, and open each in the profile it came from.

```
bm grafana           → bookmarks matching "grafana" in any profile
bm work grafana      → only those from the profile named "work"
bm infra             → matches folder names too
```

Each result shows its provenance: the icon is the source profile's avatar, and the subtitle reads
`[profile]  Folder › Subfolder  ·  host`. Alfred matches on title, profile name, folder path, host and URL.

| Key | Action |
| --- | --- |
| `↩` | Open in the bookmark's own Chrome profile |
| `⌘↩` | Copy URL |
| `⌥` | Show the full URL |
| `⌘C` / `⌘L` | Copy URL / show it in Large Type |

There is no sync step: `bookmarks.py` reads each profile's `Bookmarks` file and profile names from Chrome's
`Local State` on every run, and Alfred caches the list for 60 seconds. `javascript:` bookmarklets are skipped.

Keyword and profiles are set in Alfred Preferences → Workflows → Chrome Bookmarks → Configure Workflow. Profiles
takes a comma-separated list of profile directories or names (`Default,Profile 2`); empty searches all.

Needs `/usr/bin/python3` (Xcode Command Line Tools); the script uses only the standard library.
