#!/bin/bash
url="$1"
if [ "$action" = "copy" ]; then
  printf '%s' "$url" | pbcopy
  exit 0
fi
# Run the binary directly: a running Chrome takes the URL over its own single-instance channel and
# this process exits, which skips the Launch Services round trip that `open -na` adds (~150 ms).
# Backgrounded with its output detached, so Alfred does not wait on it.
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --profile-directory="${profile:-Default}" "$url" >/dev/null 2>&1 &
