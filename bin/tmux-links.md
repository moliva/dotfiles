# tmux-links

Hint-jump over the links in a tmux pane. Press `prefix u` (Ctrl-a, then u), type the hint shown on a link, and it opens.

## What it finds

- **OSC 8 hyperlinks**: the link target, not the visible text. Programs that emit terminal hyperlinks show up even when the text is not a URL.
- **Plain `http(s)` URLs** in the text, including ones wrapped across lines. Trailing punctuation (`.`, `,`, `)` and similar) is dropped from the URL.
- **Not `file:` links**: they are skipped on purpose.
- **Only what is on screen.** In copy mode it is the part you have scrolled to.

If the pane has nothing openable, a four-second message says so and nothing else happens.

## Keys

| Key | What it does |
| --- | --- |
| Letters of a hint | Types the hint. Once it matches a whole hint, the link opens with `open`. |
| Shift on the final letter | Copies the link target to the clipboard (`pbcopy`) instead of opening it. |
| Backspace | Undoes the last typed letter. |
| Esc or Ctrl-C | Cancels and returns to the pane. |
| Anything else | Ignored. |

Shift only matters on the key that completes the hint. For a two-letter hint, Shift on the first letter does nothing.

## Hint letters

Hints use this order:

```
fjdkslaghrueiwoqptyvmcnxbz
```

It starts with the home row under the main fingers, alternating hands (`fjdksla`), then the home-row stretch keys (`gh`), then the top row near home, and the bottom row last. The first letters are the ones you type most, so they go to the most likely links.

- Up to 26 links get one-letter hints.
- The shortest hints go to the bottom-most links, which are usually the newest output.
- With more than 26 links, hints become two letters. The last letters of the alphabet (`z`, `b`, `x`, ...) become the first letter of those, so they are the least used keys.
- Each hint is drawn on the first cell of its link. As you type, links that no longer match dim.

## Dependencies

| Dependency | Why it is needed | Installed by |
| --- | --- | --- |
| [Bun](https://bun.sh) | Runs the script (`#!/usr/bin/env bun`) and uses Bun-only APIs (`Bun.spawn`, `Bun.stringWidth`), so Node is not a substitute. | `scripts/brew.sh` (`brew install bun`) |
| tmux 3.2 or newer | Opens the hint overlay with `display-popup`, which needs 3.2+. | `scripts/brew.sh` (`brew install tmux`) |
| `open` and `pbcopy` | Open links and copy link targets. | Ships with macOS, nothing to install |

On a new machine, `scripts/install.sh` runs `scripts/brew.sh`, which installs Bun and tmux. If you set things up by hand, run `brew install bun tmux`.

## Setup

- `tmux/tmux.conf.symlink` binds it: `bind u run-shell "tmux-links launch '#{pane_id}'"`.
- `bin/` is on `PATH` (set in `zsh/zshrc.symlink`), so the binding finds `tmux-links`.
- macOS only in practice: it opens links with `open` and copies with `pbcopy`.

## Changing the keys

Edit `ALPHABET` in `bin/tmux-links`. Only letters are accepted as hint keys, so any other character is ignored. Keep the most comfortable keys first and the least comfortable last, since the last ones become prefixes once there are more than 26 links.
