# Alfred workflows

Each directory is an Alfred workflow, linked into Alfred's preferences folder by `scripts/symlink.sh`
(`workflows/user.workflow.<name>`). Scripts are plain bash, so there is nothing to build except where a
workflow's README says otherwise.

| Workflow | Keyword | What it does |
| --- | --- | --- |
| [Argo CD Search](argocd-search/) | `argo` | Search and open Argo CD apps across instances |
| [Datadog Search](datadog-search/) | `dd` | Search monitors, APM services, dashboards, logs and traces |
| [Emoji Search](emoji-search/) | `;` | Search and paste emoji |
| [GitHub Search](github-search/) | `gh` | Open repos; search PRs, review requests, issues, code and commits |
| [incident.io](incident-io/) | `inc` | Open incidents by number, on-call schedules, escalations and alerts |
| [Linear Search](linear-search/) | `ln` | Open issues, search, create issues, find projects |
| [Solana Explorer](solana-explorer/) | `sol` | Open transactions, accounts, tokens and blocks |

Org-, team- and account-specific values (hosts, org slugs, API keys) are workflow configuration, set in Alfred
Preferences → Workflows → <workflow> → Configure Workflow. Alfred keeps them in each workflow's `prefs.plist`,
which git ignores.

## Ideas

- **Package registries** (`pkg`): `pkg npm zod`, `pkg crate tokio`, `pkg go cobra`, maybe docs.rs and
  pkg.go.dev docs. Would replace the `npm`, `crates` and `gopackage` web searches.
- **Notion search** (`nt`): no reliable search URL. Options are the Notion API (internal-integration token;
  only sees pages shared with it), typing into the desktop app's ⌘P search, or opening the web app and
  sending ⌘K (timing-dependent).
