#!/bin/bash
# $1 = URL; $action, $win and $tab come from the script filter's variables.
if [ "$action" = "copy" ]; then
  printf '%s' "$1" | pbcopy
  exit 0
fi
if ! error=$(/usr/bin/osascript -l JavaScript focus.js "$win" "$tab" 2>&1); then
  msg=${error//\"/\'}
  /usr/bin/osascript -e "display notification \"${msg##*Error: }\" with title \"Chrome Tabs\""
  exit 1
fi
