# mydotenv overview

This repository stores personal dotfiles for tmux and Neovim. The goal is a
shareable, self-contained configuration: every config file lives inside this
repository, so the whole setup can be cloned and reused on another machine.

The project is at an early stage: the tmux config is imported as-is, the
Neovim config is written from scratch, and each folder has an `install.sh`
that points the tool at this repository. The terminal is macOS Terminal.app.

## Parts
- `tmux/`: tmux configuration, its installer, and the Russian-layout key
  mirror.
- `nvim/`: Neovim configuration in Lua, the project-search script, the
  `vim.pack` lockfile, and the installer.
- `assets/`: local previews of third-party images; git-ignored, not part of
  the shared config.
- `mydotenv-ai-agent/`: agent rules, checklists, project description, and
  skills.

File-level map: `project/NAVIGATION.md`.

## Stack
tmux with plugins via TPM; Neovim configured in Lua with plugins via the
built-in `vim.pack`; Bash scripts.

External tools, installed with Homebrew: `tmux`, `neovim` (0.12+, for the
built-in `vim.pack`), `ripgrep`, `fzf`, `git`, and `jq` (optional, formats
JSON with `gq`).
Language servers for Neovim, also from Homebrew, one per language:
`vtsls`, `pyright`, `jdtls`.

## How it runs
Each tool folder has an `install.sh` that points the tool at this
repository: `tmux/install.sh` and `nvim/install.sh`. What each one does is
in `project/NAVIGATION.md`. There is no build or test suite; the checks are
listed in `skills/feature-delivery/SKILL.md`.
