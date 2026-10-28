#!/bin/bash
# Alfred script filter: "dd <type> <query>" → Datadog search URL.
# Prints Alfred's JSON result format. DD_HOST and DD_APM_ENV come from the workflow configuration.

host="${DD_HOST:-app.datadoghq.com}"
apm_env="${DD_APM_ENV:-prod}"

# name|title|aliases|path (query is appended URL-encoded)
types=(
  "monitors|Monitors|m mon mons monitor monitors|/monitors/manage?q="
  "apm|APM Services|a apm s svc service services|/apm/services?env=${apm_env}&query="
  "dashboards|Dashboards|d db dash dashboard dashboards|/dashboard/lists?q="
  "logs|Logs|l log logs|/logs?query="
  "traces|Traces|t trace traces spans|/apm/traces?query="
)

urlencode() {
  local LC_ALL=C s="$1" out="" c i
  for ((i = 0; i < ${#s}; i++)); do
    c="${s:i:1}"
    case "$c" in
      [a-zA-Z0-9.~_-]) out+="$c" ;;
      *) out+=$(printf '%%%02X' "'$c") ;;
    esac
  done
  printf '%s' "$out"
}

json() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  printf '"%s"' "$s"
}

items=()

# item <type entry> <query>
item() {
  local name title aliases path url label
  IFS='|' read -r name title aliases path <<<"$1"
  url="https://${host}${path}$(urlencode "$2")"
  if [ -n "$2" ]; then label="${title}: $2"; else label="Open ${title}"; fi
  items+=("{\"title\":$(json "$label"),\"subtitle\":$(json "$url"),\"arg\":$(json "$url"),\"autocomplete\":$(json "$name $2"),\"text\":{\"copy\":$(json "$url")},\"mods\":{\"cmd\":{\"subtitle\":\"Copy URL\",\"arg\":$(json "$url")}}}")
}

q="$1"
q="${q#"${q%%[![:space:]]*}"}"
first=$(printf '%s' "${q%% *}" | tr '[:upper:]' '[:lower:]')
rest=""
[[ "$q" == *" "* ]] && rest="${q#* }"
rest="${rest#"${rest%%[![:space:]]*}"}"

# "dd mon foo" → only monitors
for t in "${types[@]}"; do
  IFS='|' read -r _ _ aliases _ <<<"$t"
  if [[ " $aliases " == *" $first "* ]]; then
    item "$t" "$rest"
    printf '{"items":[%s]}\n' "${items[0]}"
    exit 0
  fi
done

# "dd moni" → monitors first (empty search); "dd foo" → search foo in every type
if [ -n "$q" ] && [[ "$q" != *" "* ]]; then
  for t in "${types[@]}"; do
    IFS='|' read -r name _ _ _ <<<"$t"
    [[ "$name" == "$first"* ]] && item "$t" ""
  done
fi
for t in "${types[@]}"; do
  item "$t" "$q"
done

joined=$(IFS=,; printf '%s' "${items[*]}")
printf '{"items":[%s]}\n' "$joined"
