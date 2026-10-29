# Solana Explorer

Open Solana transactions, accounts, tokens and blocks from Alfred. The type is guessed from what you paste.

```
sol <signature>        → transaction
sol <address>          → account, or token as the second result
sol <slot>             → block
sol token <mint>       → force a type
sol                    → open the explorer
```

| Type | Aliases |
| --- | --- |
| Transaction | `t`, `tx`, `txn`, `transaction` |
| Account | `a`, `acc`, `account`, `address`, `wallet` |
| Token | `tok`, `token`, `mint` |
| Block | `b`, `block`, `slot` |

| Key | Action |
| --- | --- |
| `↩` | Open in browser |
| `⌘↩` | Copy URL |

The explorer (default `https://solscan.io`) and cluster (empty for mainnet, or e.g. `devnet`) are set in Alfred
Preferences → Workflows → Solana Explorer → Configure Workflow. Any explorer with Solscan-style `/tx/`,
`/account/`, `/token/` and `/block/` paths works.
