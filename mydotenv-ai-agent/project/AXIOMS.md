# mydotenv axioms

Settled decisions. Follow them without asking whether to do otherwise, do not
argue with them, and cite them when they shape an answer or a change. Only the
owner changes an axiom.

## A1. The terminal is macOS Terminal.app
Do not suggest another terminal emulator; the user declined that.
- Scope: every key binding in `tmux/` and `nvim/`, and any advice about the
  terminal.
- Decided: by 2026-10-02 (recorded in the initial commit), owner.

## A2. Neovim plugins use the built-in `vim.pack`
Each plugin is declared next to the code that uses it.
- Scope: `nvim/`.
- Decided: by 2026-10-02 (recorded in the initial commit), owner.
