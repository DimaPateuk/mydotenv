# Repository

- Keep all config files inside this repository. Do not create or modify files
  in `$HOME` (`~/.tmux.conf`, `~/.config/nvim`, etc.) unless explicitly
  asked.
- Do not add other install scripts, symlink managers, or plugin managers
  until the user chooses an approach for that tool. Neovim plugins: axiom A2
  in `project/AXIOMS.md`.
- Keep configs portable: no secrets, tokens, or machine-specific absolute
  paths, since the repository is meant to be shared.
- Each tool gets its own top-level folder. Do not mix files of different
  tools. When adding a tool, run `checklists/new-tool.md`.
