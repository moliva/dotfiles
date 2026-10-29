#!/bin/bash
# Alfred script filter: "argo <instance> <app>" → Argo CD URL.
# Prints Alfred's JSON result format. ARGO_INSTANCES and ARGO_APP_NAMESPACE come from the workflow configuration.
# ARGO_INSTANCES holds whitespace-separated "aliases=host" entries, e.g. "prod,production=argocd.example.com";
# the first one is the default.

instances=(${ARGO_INSTANCES:-})
app_ns="${ARGO_APP_NAMESPACE:-argocd}"

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

# item <instance entry> <query> [search] — "search" skips the open-app result
item() {
  local aliases host name
  aliases="${1%%=*}"
  host="${1#*=}"
  host="${host%/}"
  [[ "$host" == http* ]] || host="https://${host}"
  name="${aliases%%,*}"
  if [ -z "$2" ]; then
    add "Argo CD ${name}" "${host}/applications" "${name} "
    return
  fi
  add "${name}: search $2" "${host}/applications?search=$(urlencode "$2")" "${name} $2"
  [ -z "$3" ] && [[ "$2" != *" "* ]] && add "${name}: open $2" "${host}/applications/${app_ns}/$2" "${name} $2"
}

print() {
  local joined
  joined=$(IFS=,; printf '%s' "${items[*]}")
  printf '{"items":[%s]}\n' "$joined"
}

if [ ${#instances[@]} -eq 0 ]; then
  printf '{"items":[{"title":"Set your Argo CD instances in Configure Workflow","valid":false}]}\n'
  exit 0
fi

q="$1"
q="${q#"${q%%[![:space:]]*}"}"
first=$(printf '%s' "${q%% *}" | tr '[:upper:]' '[:lower:]')
rest=""
[[ "$q" == *" "* ]] && rest="${q#* }"
rest="${rest#"${rest%%[![:space:]]*}"}"

# "argo stg social" → only staging
for inst in "${instances[@]}"; do
  if [[ ",${inst%%=*}," == *",$first,"* ]]; then
    item "$inst" "$rest"
    print
    exit 0
  fi
done

if [ -z "$q" ]; then
  for inst in "${instances[@]}"; do
    item "$inst" ""
  done
  print
  exit 0
fi

# "argo st" → staging first; "argo social" → search social in the default instance, then the others
if [[ "$q" != *" "* ]]; then
  for inst in "${instances[@]}"; do
    [[ ",${inst%%=*}" == *",$first"* ]] && item "$inst" ""
  done
fi
item "${instances[0]}" "$q"
for inst in "${instances[@]:1}"; do
  item "$inst" "$q" search
done
print
