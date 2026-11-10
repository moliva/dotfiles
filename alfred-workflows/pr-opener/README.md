# GitHub PR Opener

Open GitHub pull requests from a short reference, a link, or whatever is on the clipboard.

```
pr api#123            → open PR 123 in the default org's api repo
pr myorg/api#123      → open PR 123 in myorg/api
pr <PR or issue URL>  → open it (issue links are rewritten to the PR URL)
pr                    → open every reference found on the clipboard
```

The text can hold several references, for example a pasted chat message; each one gets a row.

| Key | Action |
| --- | --- |
| `↩` | Open in browser |
| `⌘↩` | Copy URL |
| `⌘C` | Copy URL |
| `⌘Y` | Quick Look the PR |

The hotkey trigger is unbound; set one in Alfred to open the references found in the current selection.

Set the default org (used for bare `repo#123`) in Alfred Preferences → Workflows → GitHub PR Opener →
Configure Workflow. Alfred keeps it in `prefs.plist`, which git ignores.
