#!/usr/bin/env bash
# Makes Neovim load its config from this folder by turning the Neovim config
# directory (~/.config/nvim) into a symlink to it. A symlink rather than a stub
# init.lua, because the Lua modules under lua/ and lazy.nvim resolve from the
# config directory itself.
# The repository path is resolved from this script's location, so the
# repository can be cloned anywhere. Rerun the script after moving it.
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
target="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

if [[ ! -f "$script_dir/init.lua" ]]; then
  echo "error: $script_dir/init.lua not found" >&2
  exit 1
fi

if [[ -d "$target" && "$(cd "$target" && pwd -P)" == "$script_dir" ]]; then
  echo "$target already points to $script_dir"
  exit 0
fi

if [[ -e "$target" || -L "$target" ]]; then
  stamp="$(date +%Y%m%d%H%M%S)"
  backup="$target.backup.$stamp"
  n=1
  while [[ -e "$backup" || -L "$backup" ]]; do
    backup="$target.backup.$stamp-$n"
    n=$((n + 1))
  done
  mv "$target" "$backup"
  echo "moved existing $target to $backup"
fi

mkdir -p "$(dirname "$target")"
ln -s "$script_dir" "$target"
echo "$target now points to $script_dir"
echo "restart Neovim to load it"
