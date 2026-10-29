# Argo CD Search

Search and open Argo CD applications from Alfred, across several Argo CD instances.

```
argo                   → pick an instance
argo stg               → open the staging instance
argo stg checkout      → search "checkout" in staging, or open the app named "checkout"
argo checkout          → search in the default instance, then in the others
```

| Key | Action |
| --- | --- |
| `↩` | Open in browser |
| `⌘↩` | Copy URL |
| `⇥` | Autocomplete the instance |

Instances are set in Alfred Preferences → Workflows → Argo CD Search → Configure Workflow, one per line as
`aliases=host`. Aliases are comma-separated, and the first instance is the default:

```
prod,production=argocd.example.com
stg,staging=argocd-staging.example.com
```

Direct app links use `/applications/<namespace>/<app>`; the namespace defaults to `argocd`.
