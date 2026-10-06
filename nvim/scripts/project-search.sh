#!/usr/bin/env bash
# Feeds the Neovim project search pickers. Prints results that respect
# .gitignore first, then results from gitignored files dimmed, so one search
# shows both. Hidden files are included; the .git directory is not.
# Text matches from gitignored files are capped: in a project with
# node_modules a short query matches millions of lines there.
#
#   project-search.sh files         list files
#   project-search.sh grep QUERY    search file contents for QUERY as plain text
#
# A text QUERY may end with " -- FILTER...", like VS Code's files to include
# and exclude: *.ts or *.{ts,tsx} (extension), *test* (name), !dist or
# !*.spec.ts (exclude). A plain name such as src selects a folder at any depth;
# a path such as src/utils is taken from the project root.
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

# Appends the rg --iglob arguments for one filter to grep_flags.
add_filter() {
  local filter="$1"
  case "$filter" in
    '!'* | *'*'* | *'?'* | *'['* | *'{'*)
      grep_flags+=(--iglob "$filter")
      return
      ;;
  esac
  filter="${filter%/}"
  grep_flags+=(--iglob "$filter")
  if [[ "$filter" == */* ]]; then
    grep_flags+=(--iglob "$filter/**")
    return
  fi
  grep_flags+=(--iglob "**/$filter/**")
}

search_text() {
  local query="$1" text filters="" filter
  text="$query"
  if [[ "$query" == *" --"* ]]; then
    text="${query%% --*}"
    filters="${query#* --}"
  fi
  text="${text%"${text##*[! ]}"}"
  if [[ -z "$text" ]]; then
    return 0
  fi
  # add_filter appends to this local array (bash functions see callers' locals).
  local -a grep_flags=(--column --line-number --no-heading --smart-case --fixed-strings
    --max-columns=300 --max-columns-preview)
  # read -a splits on spaces without expanding globs such as *.ts.
  local -a tokens=()
  read -r -a tokens <<< "$filters" || true
  for filter in ${tokens[@]+"${tokens[@]}"}; do
    add_filter "$filter"
  done
  grep_flags+=(--field-match-separator="$sep" -e "$text")

  respected="$(mktemp)"
  trap 'rm -f "$respected"' EXIT
  list_files > "$respected" || true
  # A filter naming an ignored folder makes rg search it despite .gitignore,
  # so both passes sort lines by the respected-file list, not by rg's ignores.
  rg "${grep_flags[@]}" "${rg_common[@]}" --color=always \
    | keep_lines respected "" "" \
    || true
  rg "${grep_flags[@]}" "${rg_common[@]}" --no-ignore --color=never \
    | keep_lines ignored "$dim" "$reset" \
    | head -n "$ignored_match_limit" \
    || true
}

sep=$'\x1f'

# Reads rg lines with fields split by $sep and prints, rejoined with ":", those
# whose file is (respected) or is not (ignored) listed in $respected.
keep_lines() {
  awk -F "$sep" -v want="$1" -v prefix="$2" -v suffix="$3" '
    NR == FNR { respected[$0] = 1; next }
    { path = $1; gsub(/\033\[[0-9;]*m/, "", path) }
    want == "respected" && !(path in respected) { next }
    want == "ignored" && (path in respected) { next }
    {
      text = substr($0, length($1) + length($2) + length($3) + 4)
      print prefix $1 ":" $2 ":" $3 ":" text suffix
    }' "$respected" -
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
