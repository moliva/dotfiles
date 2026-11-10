# Chrome Tabs

Search the tabs open in every Chrome window, and jump to one.

```
tb grafana           → open tabs matching "grafana", in any window
tb window 2          → every tab in the second window
tb work inbox        → matches the profile name too, when Chrome shows it in the window title
tb pull 4821         → matches words anywhere in the URL, not just the title
```

Results come in Chrome's order: windows front to back, tabs left to right. The subtitle reads
`[Window 2 · profile]  host`, and `▶` marks the tab that is active in its window. Incognito windows show as
`[Incognito]`. Alfred matches on title, window label, host and URL. Alfred only matches query words against
the start of whole words, so the URL is also fed in broken into its parts (path segments, query keys and values,
split again on `-`/`_`, percent-decoded) and without its scheme: `tb pull 4821`, `tb backend` or a pasted
`tb github.com/acme/backend` all find `https://github.com/acme/backend-3/pull/4821`.

| Key | Action |
| --- | --- |
| `↩` | Switch to the tab and raise its window |
| `⌘↩` | Copy URL |
| `⌘C` / `⌘L` | Copy URL / show it in Large Type |

Tabs are read live from Chrome on every run (no caching), so the list is always current. If Chrome is not
running the workflow says so and does not launch it.

How it works: `tabs.py` asks Chrome for its windows and tabs through its AppleScript interface (JXA, one bulk
query), and `focus.js` activates a tab by window id and tab id, so it still lands on the right tab if tabs moved
between listing and selecting. If the tab was closed in the meantime you get a notification.

**Profiles.** Chrome's AppleScript interface does not say which profile a window belongs to, and its window
name leaves the profile out. The on-screen title does include it (`<tab> - Google Chrome - <profile>`, shown once
you use several profiles), so `tabs.py` also reads the window titles through System Events and pairs each with its
AppleScript window by the active tab's title (same-titled windows pair in order). The profile's avatar becomes the
icon, as in Chrome Bookmarks, and its name goes in the subtitle. Chrome's `Account (profile name)` labels and its
`- High memory usage - 849 MB` and `- Pinned` title notes are handled. Windows are paired on the active tab's full
title, because Chrome truncates the AppleScript window name in the middle (`…`). A profile without an avatar file gets the
workflow icon. If a window's title has no profile (a single-profile Chrome), you just get `Window N`.

Reading titles is the fragile part (permissions, a slow System Events, titles changing between the two queries), but
a window never changes profile. So once a window's profile is certain (an exact title match that no other window's
title contradicts), `tabs.py` remembers it by Chrome window id in `window-profiles.json` in the workflow's cache
folder, and reuses it whenever a later read fails or can't be paired. Entries for closed windows are dropped, and the
whole cache is cleared when Chrome quits, since window ids don't survive a restart. Windows that were never certain
(for example two same-titled `New Tab` windows on different profiles) show `· profile unknown` while titles can't be
read, rather than silently losing it; the last reason is in `titles-error.txt` next to the cache.

**First run.** macOS asks whether Alfred may control Google Chrome and System Events (System Settings → Privacy &
Security → Automation). Allow both. Reading window titles also needs Alfred in Accessibility, which it usually
already has.

Keyword is set in Alfred Preferences → Workflows → Chrome Tabs → Configure Workflow.

Needs `/usr/bin/python3` (Xcode Command Line Tools); the script uses only the standard library.

Testing without Chrome: `TABS_JSON=dump.json /usr/bin/python3 tabs.py` reads windows from a JSON file shaped like
the query result (`[{id, name, mode, active, tabs: [{id, title, url}]}]`), and `TABS_AX=titles.json` supplies the
on-screen window titles as a JSON list of strings.
