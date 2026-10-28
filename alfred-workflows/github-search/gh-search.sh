#!/bin/bash
# Alfred script filter: "gh <type> <query>" → GitHub search URL.
# Prints Alfred's JSON result format. GH_ORG comes from the workflow configuration (empty searches all of GitHub).

org="${GH_ORG:-}"
scope=""
[ -n "$org" ] && scope="org:${org} "

# name|title|aliases|search type|qualifiers (prepended to the query)
types=(
  "repos|Repos|r repo repos repositories|repositories|"
  "prs|Pull Requests|p pr prs pull pulls|pullrequests|is:pr "
  "review|Review Requests|rv review reviews|pullrequests|is:pr is:open review-requested:@me "
  "mine|My PRs|my mine|pullrequests|is:pr is:open author:@me "
  "issues|Issues|i issue issues|issues|is:issue "
  "code|Code|c code|code|"
  "commits|Commits|cm commit commits|commits|"
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

# item <type entry> <query>
item() {
  local name title aliases kind quals label
  IFS='|' read -r name title aliases kind quals <<<"$1"
  if [ -n "$2" ]; then label="${title}: $2"; else label="${title}"; fi
  add "$label" "https://github.com/search?q=$(urlencode "${scope}${quals}$2")&type=${kind}" "$name $2"
}

# "gh repo api" → open the repo directly, before the search result
repo_item() {
  if [ -z "$1" ]; then
    add "Open ${org:-GitHub}" "https://github.com/${org}" "repos "
  elif [[ "$1" != *" "* ]]; then
    if [[ "$1" == */* ]]; then
      add "Open $1" "https://github.com/$1" "repos $1"
    elif [ -n "$org" ]; then
      add "Open ${org}/$1" "https://github.com/${org}/$1" "repos $1"
    fi
  fi
}

q="$1"
q="${q#"${q%%[![:space:]]*}"}"
first=$(printf '%s' "${q%% *}" | tr '[:upper:]' '[:lower:]')
rest=""
[[ "$q" == *" "* ]] && rest="${q#* }"
rest="${rest#"${rest%%[![:space:]]*}"}"

# "gh pr foo" → only pull requests
for t in "${types[@]}"; do
  IFS='|' read -r name _ aliases _ _ <<<"$t"
  if [[ " $aliases " == *" $first "* ]]; then
    [ "$name" = repos ] && repo_item "$rest"
    item "$t" "$rest"
    joined=$(IFS=,; printf '%s' "${items[*]}")
    printf '{"items":[%s]}\n' "$joined"
    exit 0
  fi
done

# "gh rev" → review first (no query); "gh foo" → search foo in every type
if [ -n "$q" ] && [[ "$q" != *" "* ]]; then
  for t in "${types[@]}"; do
    IFS='|' read -r name _ _ _ _ <<<"$t"
    [[ "$name" == "$first"* ]] && item "$t" ""
  done
fi
repo_item "$q"
for t in "${types[@]}"; do
  item "$t" "$q"
done

joined=$(IFS=,; printf '%s' "${items[*]}")
printf '{"items":[%s]}\n' "$joined"
