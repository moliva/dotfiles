# Chrome Tabs

Search the tabs open in every Chrome window, and jump to one.

```
tb grafana           → open tabs matching "grafana", in any window
tb window 2          → every tab in the second window
tb work inbox        → matches the profile name too, when Chrome shows it in the window title
```

Results come in Chrome's order: windows front to back, tabs left to right. The subtitle reads
`[Window 2 · profile]  host`, and `▶` marks the tab that is active in its window. Incognito windows show as
`[Incognito]`. Alfred matches on title, window label, host and URL.

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
`- High memory usage - 849 MB` title notes are handled. A profile without an avatar file gets the
workflow icon. If the titles can't be read, or a window's title has no profile, you just get `Window N`.

**First run.** macOS asks whether Alfred may control Google Chrome and System Events (System Settings → Privacy &
Security → Automation). Allow both. Reading window titles also needs Alfred in Accessibility, which it usually
already has.

Keyword is set in Alfred Preferences → Workflows → Chrome Tabs → Configure Workflow.

Needs `/usr/bin/python3` (Xcode Command Line Tools); the script uses only the standard library.

Testing without Chrome: `TABS_JSON=dump.json /usr/bin/python3 tabs.py` reads windows from a JSON file shaped like
the query result (`[{id, name, mode, active, tabs: [{id, title, url}]}]`), and `TABS_AX=titles.json` supplies the
on-screen window titles as a JSON list of strings.
