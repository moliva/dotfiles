# Linear Search

Open Linear issues, searches and new issues from Alfred.

```
ln abc-123           → open issue ABC-123
ln 123               → open issue 123 in your default team
ln redis eviction    → search, or create an issue titled "redis eviction"
ln new fix login     → new issue in your default team, assigned to you
ln mine              → your assigned issues
ln inbox             → inbox
ln team              → your default team's active issues (ln team KEY for another team)
ln cycle             → your default team's current cycle (ln cycle KEY for another team)
ln projects          → all projects
ln proj redis        → projects whose name contains "redis" (needs an API key)
ln                   → open any of them
```

| Target | Aliases |
| --- | --- |
| Search | `s`, `search`, `i`, `issue`, `issues` |
| New Issue | `n`, `new`, `create` |
| My Issues | `my`, `mine` |
| Inbox | `in`, `inbox` |
| Team Issues | `t`, `team` |
| Current Cycle | `cy`, `cycle` |
| Projects | `pj`, `proj`, `project`, `projects` |

| Key | Action |
| --- | --- |
| `↩` | Open in browser |
| `⌘↩` | Copy URL |
| `⇥` | Autocomplete the target name |

Keyword, workspace and default team are set in Alfred Preferences → Workflows → Linear Search → Configure
Workflow. The workspace is the slug after `linear.app/` in your Linear URLs. Without a default team, new issues,
bare issue numbers, `team` and `cycle` need an explicit team key.

Project search by name goes through the Linear API, so it needs a personal API key (Linear → Settings →
Security & access → Personal API keys) in the same Configure Workflow screen. Alfred stores it in the
git-ignored `prefs.plist`. Without a key, `ln proj NAME` just opens the projects list.

Add a target by adding a line to `types` in `ln-search.sh` and a matching case in `item`.
