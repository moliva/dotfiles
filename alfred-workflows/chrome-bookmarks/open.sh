#!/bin/bash
url="$1"
if [ "$action" = "copy" ]; then
  printf '%s' "$url" | pbcopy
  exit 0
fi
open -na "Google Chrome" --args --profile-directory="${profile:-Default}" "$url"
