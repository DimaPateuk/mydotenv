#!/usr/bin/env bash
# Mirrors tmux key bindings onto the Russian (ЙЦУКЕН) keyboard layout: every
# binding on a Latin key is also bound to the Cyrillic letter on the same
# physical key, e.g. prefix z (zoom) also works as prefix я.
# tmux.conf runs this last, after its own bindings and plugins are loaded.
set -euo pipefail

# Latin keys as `tmux list-keys` prints them, paired by position with russian.
latin=(
  q w e r t y u i o p '[' ']' a s d f g h j k l '\;' "\\'" z x c v b n m , .
  Q W E R T Y U I O P '\{' '\}' A S D F G H J K L : '\"' Z X C V B N M '<' '>'
)
russian=(
  й ц у к е н г ш щ з х ъ ф ы в а п р о л д ж э я ч с м и т ь б ю
  Й Ц У К Е Н Г Ш Щ З Х Ъ Ф Ы В А П Р О Л Д Ж Э Я Ч С М И Т Ь Б Ю
)

if (( ${#latin[@]} != ${#russian[@]} )); then
  echo "russian-layout.sh: latin and russian key lists differ in length" >&2
  exit 1
fi

russian_for() {
  local i
  for i in "${!latin[@]}"; do
    if [[ "${latin[$i]}" == "$1" ]]; then
      printf '%s' "${russian[$i]}"
      return 0
    fi
  done
  return 1
}

bindings="$(mktemp)"
trap 'rm -f "$bindings"' EXIT

binding_re='^(bind-key +(-r +)?-T +[^ ]+ +)([^ ]+)( .*)$'
tmux list-keys | while IFS= read -r line; do
  if [[ ! "$line" =~ $binding_re ]]; then
    continue
  fi
  head="${BASH_REMATCH[1]}"
  key="${BASH_REMATCH[3]}"
  command="${BASH_REMATCH[4]}"
  # Skip named keys such as C-o or MouseDown1Pane before the slower lookup.
  if (( ${#key} > 2 )); then
    continue
  fi
  if ! russian_key="$(russian_for "$key")"; then
    continue
  fi
  printf '%s%s%s\n' "$head" "$russian_key" "$command"
done > "$bindings"

tmux source-file "$bindings"
