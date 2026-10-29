# GitHub Search

Search GitHub from Alfred, scoped to your org.

```
gh repo api          → open myorg/api, or search repos for "api"
gh repo owner/name   → open any repo directly
gh pr fix login      → pull requests matching "fix login"
gh review            → open PRs waiting on your review
gh mine              → your open PRs
gh team              → open PRs waiting on your team's review
gh issue flaky       → issues matching "flaky"
gh code "fooBar"     → code search
gh commit revert     → commit search
gh api               → open myorg/api, or pick which kind of search
gh                   → open the org page, or any search without a query
```

| Search | Aliases |
| --- | --- |
| Repos | `r`, `repo`, `repos`, `repositories` |
| Pull Requests | `p`, `pr`, `prs`, `pull`, `pulls` |
| Review Requests | `rv`, `review`, `reviews` |
| My PRs | `my`, `mine` |
| Team Review Requests | `tm`, `team` |
| Issues | `i`, `issue`, `issues` |
| Code | `c`, `code` |
| Commits | `cm`, `commit`, `commits` |

Queries take GitHub search syntax, so `gh pr is:open label:bug` works.

| Key | Action |
| --- | --- |
| `↩` | Open in browser |
| `⌘↩` | Copy URL |
| `⇥` | Autocomplete the search name |

Keyword, org and team are set in Alfred Preferences → Workflows → GitHub Search → Configure Workflow. Leave the
org empty to search all of GitHub. The team is a slug within the org, or `org/team`; without one, `gh team`
is hidden.

Add a search by adding a line to `types` in `gh-search.sh`: name, title, aliases, GitHub's search `type`, and
qualifiers to prepend to the query.
