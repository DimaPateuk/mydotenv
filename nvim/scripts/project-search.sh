#!/usr/bin/env bash
# Feeds the Neovim project search pickers. Prints results that respect
# .gitignore first, then results from gitignored files dimmed, so one search
# shows both. Hidden files are included; the .git directory is not.
# Text matches from gitignored files are capped: in a project with
# node_modules a short query matches millions of lines there.
#
#   project-search.sh files         list files
#   project-search.sh grep QUERY    search file contents for QUERY as plain text
set -euo pipefail

# Without a path argument rg searches stdin whenever stdin is a pipe or
# socket, which would hang; make sure it always searches the directory.
exec < /dev/null

dim=$'\e[90m'
reset=$'\e[0m'
ignored_match_limit=300
rg_common=(--hidden --glob '!.git')

list_files() {
  rg --files "${rg_common[@]}"
}

# Files that only appear once .gitignore is disabled.
list_ignored_files() {
  comm -13 \
    <(list_files | LC_ALL=C sort) \
    <(rg --files --no-ignore "${rg_common[@]}" | LC_ALL=C sort)
}

search_files() {
  list_files || true
  list_ignored_files | sed "s/^/$dim/; s/\$/$reset/"
}

search_text() {
  local query="$1"
  if [[ -z "$query" ]]; then
    return 0
  fi
  local grep_flags=(--column --line-number --no-heading --smart-case --fixed-strings
    --max-columns=300 --max-columns-preview)
  rg "${grep_flags[@]}" "${rg_common[@]}" --color=always -e "$query" || true

  local sep=$'\x1f'
  respected="$(mktemp)"
  trap 'rm -f "$respected"' EXIT
  list_files > "$respected" || true
  # Search everything, then keep only lines from files the first pass skipped.
  rg "${grep_flags[@]}" "${rg_common[@]}" --no-ignore --color=never \
    --field-match-separator="$sep" -e "$query" \
    | awk -F "$sep" -v dim="$dim" -v reset="$reset" '
        NR == FNR { respected[$0] = 1; next }
        $1 in respected { next }
        {
          text = substr($0, length($1) + length($2) + length($3) + 4)
          print dim $1 ":" $2 ":" $3 ":" text reset
        }' "$respected" - \
    | head -n "$ignored_match_limit" \
    || true
}

case "${1:-}" in
  files)
    search_files
    ;;
  grep)
    search_text "${2:-}"
    ;;
  *)
    echo "usage: project-search.sh files | grep QUERY" >&2
    exit 2
    ;;
esac
