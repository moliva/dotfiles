#!/bin/bash
# Alfred script filter: "ln <type> <query>" → Linear URL.
# Prints Alfred's JSON result format. LINEAR_WORKSPACE and LINEAR_TEAM come from the workflow configuration.

base="https://linear.app/${LINEAR_WORKSPACE:-}"
base="${base%/}"
team=$(printf '%s' "${LINEAR_TEAM:-}" | tr '[:lower:]' '[:upper:]')

# name|title|aliases
types=(
  "search|Search|s search i issue issues"
  "new|New Issue|n new create"
  "mine|My Issues|my mine"
  "inbox|Inbox|in inbox"
  "team|Team Issues|t team"
  "cycle|Current Cycle|cy cycle"
  "projects|Projects|pj proj project projects"
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

# add <title> <url> <autocomplete>
add() {
  items+=("{\"title\":$(json "$1"),\"subtitle\":$(json "$2"),\"arg\":$(json "$2"),\"autocomplete\":$(json "$3"),\"text\":{\"copy\":$(json "$2")},\"mods\":{\"cmd\":{\"subtitle\":\"Copy URL\",\"arg\":$(json "$2")}}}")
}

# team_key <query> → the query if it looks like a team key, else the configured team
team_key() {
  if [[ "$1" =~ ^[A-Za-z][A-Za-z0-9]*$ ]]; then
    printf '%s' "$1" | tr '[:lower:]' '[:upper:]'
  else
    printf '%s' "$team"
  fi
}

# item <type entry> <query>
item() {
  local name title aliases key
  IFS='|' read -r name title aliases <<<"$1"
  case "$name" in
    search)
      if [ -n "$2" ]; then add "Search: $2" "${base}/search?q=$(urlencode "$2")" "search $2"
      else add "Search" "${base}/search" "search "; fi ;;
    new)
      [ -z "$team" ] && return
      if [ -n "$2" ]; then add "New ${team} issue: $2" "${base}/team/${team}/new?assignee=me&title=$(urlencode "$2")" "new $2"
      else add "New ${team} issue" "${base}/team/${team}/new?assignee=me" "new "; fi ;;
    mine) add "$title" "${base}/my-issues/assigned" "mine" ;;
    inbox) add "$title" "${base}/inbox" "inbox" ;;
    team)
      key=$(team_key "$2")
      [ -z "$key" ] && return
      add "${key} issues" "${base}/team/${key}/active" "team $2" ;;
    cycle)
      key=$(team_key "$2")
      [ -z "$key" ] && return
      add "${key} current cycle" "${base}/team/${key}/cycle/active" "cycle $2" ;;
    projects)
      if [ -n "$2" ] && [ -n "${LINEAR_API_KEY:-}" ]; then project_items "$2"
      else add "$title" "${base}/projects/all" "projects"; fi ;;
  esac
}

# "ln proj redis" → projects whose name contains "redis", via the Linear API
project_items() {
  local body resp n i name url status
  body="{\"query\":\"query(\$q: String!) { projects(first: 9, filter: {name: {containsIgnoreCase: \$q}}) { nodes { name url status { name } } } }\",\"variables\":{\"q\":$(json "$1")}}"
  resp=$(curl -sS --max-time 3 -H "Authorization: ${LINEAR_API_KEY}" -H 'Content-Type: application/json' -d "$body" https://api.linear.app/graphql 2>/dev/null)
  n=$(printf '%s' "$resp" | plutil -extract data.projects.nodes raw -o - - 2>/dev/null)
  if ! [[ "$n" =~ ^[0-9]+$ ]]; then
    add "Couldn't search projects (check the API key)" "${base}/projects/all" "projects $1"
    return
  fi
  if [ "$n" -eq 0 ]; then
    add "No projects match: $1" "${base}/projects/all" "projects $1"
    return
  fi
  for ((i = 0; i < n; i++)); do
    name=$(printf '%s' "$resp" | plutil -extract "data.projects.nodes.$i.name" raw -o - -)
    url=$(printf '%s' "$resp" | plutil -extract "data.projects.nodes.$i.url" raw -o - -)
    status=$(printf '%s' "$resp" | plutil -extract "data.projects.nodes.$i.status.name" raw -o - - 2>/dev/null)
    add "${name}${status:+ · $status}" "$url" "projects ${name}"
  done
}

# "ln abc-123" or "ln 123" → open the issue directly
issue_item() {
  local id
  if [[ "$1" =~ ^[A-Za-z][A-Za-z0-9]*-[0-9]+$ ]]; then
    id=$(printf '%s' "$1" | tr '[:lower:]' '[:upper:]')
  elif [[ "$1" =~ ^[0-9]+$ ]] && [ -n "$team" ]; then
    id="${team}-$1"
  else
    return
  fi
  add "Open ${id}" "${base}/issue/${id}" "$1"
}

print() {
  local joined
  joined=$(IFS=,; printf '%s' "${items[*]}")
  printf '{"items":[%s]}\n' "$joined"
}

q="$1"
q="${q#"${q%%[![:space:]]*}"}"
first=$(printf '%s' "${q%% *}" | tr '[:upper:]' '[:lower:]')
rest=""
[[ "$q" == *" "* ]] && rest="${q#* }"
rest="${rest#"${rest%%[![:space:]]*}"}"

# "ln new fix login" → only a new issue
for t in "${types[@]}"; do
  IFS='|' read -r name _ aliases <<<"$t"
  if [[ " $aliases " == *" $first "* ]]; then
    [ "$name" = search ] && issue_item "$rest"
    item "$t" "$rest"
    print
    exit 0
  fi
done

issue_item "$q"
# "ln cyc" → cycle first; "ln foo" → search foo, or create an issue titled foo
if [ -n "$q" ] && [[ "$q" != *" "* ]]; then
  for t in "${types[@]}"; do
    IFS='|' read -r name _ _ <<<"$t"
    [[ "$name" == "$first"* ]] && item "$t" ""
  done
fi
if [ -n "$q" ]; then
  item "${types[0]}" "$q"
  item "${types[1]}" "$q"
else
  for t in "${types[@]}"; do
    item "$t" ""
  done
fi
print
