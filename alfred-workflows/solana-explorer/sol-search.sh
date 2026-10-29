#!/bin/bash
# Alfred script filter: "sol <type> <query>" → Solana explorer URL.
# Prints Alfred's JSON result format. SOL_EXPLORER and SOL_CLUSTER come from the workflow configuration.

explorer="${SOL_EXPLORER:-https://solscan.io}"
explorer="${explorer%/}"
suffix=""
[ -n "${SOL_CLUSTER:-}" ] && suffix="?cluster=${SOL_CLUSTER}"

# name|title|aliases|path (query is appended)
types=(
  "tx|Transaction|t tx txn transaction|/tx/"
  "account|Account|a acc account address wallet|/account/"
  "token|Token|tok token mint|/token/"
  "block|Block|b block slot|/block/"
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

# item <type entry> <query>
item() {
  local name title aliases path
  IFS='|' read -r name title aliases path <<<"$1"
  if [ -n "$2" ]; then add "${title}: $2" "${explorer}${path}$2${suffix}" "$name $2"
  else add "$title" "${explorer}${suffix}" "$name "; fi
}

# entry <name> → that type's entry
entry() {
  local t
  for t in "${types[@]}"; do
    [[ "$t" == "$1|"* ]] && printf '%s' "$t"
  done
}

print() {
  local joined
  joined=$(IFS=,; printf '%s' "${items[*]}")
  printf '{"items":[%s]}\n' "$joined"
}

q="$1"
q="${q#"${q%%[![:space:]]*}"}"
q="${q%"${q##*[![:space:]]}"}"
first=$(printf '%s' "${q%% *}" | tr '[:upper:]' '[:lower:]')
rest=""
[[ "$q" == *" "* ]] && rest="${q#* }"
rest="${rest#"${rest%%[![:space:]]*}"}"

# "sol token <mint>" → only tokens
for t in "${types[@]}"; do
  IFS='|' read -r name _ aliases _ <<<"$t"
  if [[ " $aliases " == *" $first "* ]]; then
    item "$t" "$rest"
    print
    exit 0
  fi
done

# Signatures are 64–88 base58 chars, addresses 32–44, slots are numbers
if [[ "$q" =~ ^[1-9A-HJ-NP-Za-km-z]+$ ]] && [ ${#q} -ge 64 ] && [ ${#q} -le 88 ]; then
  item "$(entry tx)" "$q"
elif [[ "$q" =~ ^[1-9A-HJ-NP-Za-km-z]+$ ]] && [ ${#q} -ge 32 ] && [ ${#q} -le 44 ]; then
  item "$(entry account)" "$q"
  item "$(entry token)" "$q"
elif [[ "$q" =~ ^[0-9]+$ ]]; then
  item "$(entry block)" "$q"
else
  for t in "${types[@]}"; do
    IFS='|' read -r name _ _ _ <<<"$t"
    [ -n "$q" ] && [[ "$name" == "$first"* ]] && item "$t" ""
  done
  [ ${#items[@]} -eq 0 ] && for t in "${types[@]}"; do item "$t" ""; done
fi
print
