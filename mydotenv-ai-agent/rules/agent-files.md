# Agent files

- `AGENTS.md` is the canonical agent entry point. `CLAUDE.md` must remain a
  symlink to it so Codex and Claude receive identical guidance. Edit
  `AGENTS.md`, never `CLAUDE.md`. If `CLAUDE.md` ever becomes a regular
  file, restore the link from the repository root:

  ```bash
  ln -sf AGENTS.md CLAUDE.md
  ```

- Read `.agent-best-practices/AGENTS.md` before changing anything.
- `.agent-best-practices` is a local symlink to the shared guidance
  directory. Its target differs on every machine, so it is git-ignored:
  never commit it or write its target path into tracked files. If the link
  is missing, read `~/.agent-best-practices/AGENTS.md` instead (the guidance
  installer creates that link on every machine), or recreate the local link
  from it:

  ```bash
  ln -sfn ~/.agent-best-practices .agent-best-practices
  ```
