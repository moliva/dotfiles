#!/bin/bash
# Alfred script filter: "inc <number|page>" → incident.io URL.
# Prints Alfred's JSON result format. INCIDENT_ORG comes from the workflow configuration.

base="https://app.incident.io/${INCIDENT_ORG:-}"
base="${base%/}"

# name|title|aliases|path
types=(
  "incidents|Incidents|i inc incident incidents|/incidents"
  "oncall|On-call Schedules|o oncall on-call schedule schedules|/on-call/schedules"
  "escalations|Escalations|e esc escalation escalations|/on-call/escalations"
  "alerts|Alerts|a alert alerts|/alerts"
)

json() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  printf '"%s"' "$s"
}

items=()

# add <title> <url> <autocomplete>
add() {
  items+=("{\"title\":$(json "$1"),\"subtitle\":$(json "$2"),\"arg\":$(json "$2"),\"autocomplete\":$(json "$3"),\"text\":{\"copy\":$(json "$2")},\"mods\":{\"cmd\":{\"subtitle\":\"Copy URL\",\"arg\":$(json "$2")}}}")
}

# item <type entry>
item() {
  local name title aliases path
  IFS='|' read -r name title aliases path <<<"$1"
  add "$title" "${base}${path}" "$name"
}

print() {
  local joined
  joined=$(IFS=,; printf '%s' "${items[*]}")
  printf '{"items":[%s]}\n' "$joined"
}

q="$1"
q="${q#"${q%%[![:space:]]*}"}"
q="${q%"${q##*[![:space:]]}"}"
lower=$(printf '%s' "$q" | tr '[:upper:]' '[:lower:]')

# "inc 186" or "inc INC-186" → open the incident
num="${lower#inc-}"
if [[ "$num" =~ ^[0-9]+$ ]]; then
  add "Open INC-${num}" "${base}/incidents/${num}" "$q"
  print
  exit 0
fi

for t in "${types[@]}"; do
  IFS='|' read -r name _ aliases _ <<<"$t"
  if [[ " $aliases " == *" $lower "* ]]; then
    item "$t"
    print
    exit 0
  fi
done

# "inc on" → on-call first, then the rest
for t in "${types[@]}"; do
  IFS='|' read -r name _ _ _ <<<"$t"
  [ -n "$lower" ] && [[ "$name" == "$lower"* ]] && item "$t"
done
for t in "${types[@]}"; do
  IFS='|' read -r name _ _ _ <<<"$t"
  [ -n "$lower" ] && [[ "$name" == "$lower"* ]] && continue
  item "$t"
done
print
