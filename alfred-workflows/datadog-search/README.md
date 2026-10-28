# Datadog Search

Search Datadog from Alfred.

```
dd mon checkout      → monitors matching "checkout"
dd apm api           → APM services matching "api"
dd dash sales        → dashboards matching "sales"
dd logs service:x    → log search
dd traces …          → trace search
dd checkout          → pick which product to search for "checkout"
dd                   → open any of them without a query
```

| Product | Aliases |
| --- | --- |
| Monitors | `m`, `mon`, `monitor`, `monitors` |
| APM Services | `a`, `apm`, `s`, `svc`, `service`, `services` |
| Dashboards | `d`, `db`, `dash`, `dashboard`, `dashboards` |
| Logs | `l`, `log`, `logs` |
| Traces | `t`, `trace`, `traces`, `spans` |

| Key | Action |
| --- | --- |
| `↩` | Open in browser |
| `⌘↩` | Copy URL |
| `⇥` | Autocomplete the product name |

Keyword, Datadog host (e.g. `myorg.datadoghq.com`) and APM env are set in Alfred Preferences → Workflows →
Datadog Search → Configure Workflow.

Add a product by adding a line to `types` in `dd-search.sh`: name, title, aliases, and the search path the
query gets appended to.
