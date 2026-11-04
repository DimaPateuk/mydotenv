---
name: feature-delivery
description: Default skill for feature, bug-fix, refactor, test, and documentation work in mydotenv when no more specific skill applies. Reads the rules and the project description first, delivers the smallest verified change, and keeps project/ (overview, axioms, navigation) up to date in the same task.
---

# Feature Delivery

The default local skill for mydotenv. A more specific applicable skill takes
precedence.

## Required context

Before changing anything, read in full:

1. `../../AGENTS.md` and every file in `../../rules/`.
2. `../../project/OVERVIEW.md`, `../../project/AXIOMS.md`, and
   `../../project/NAVIGATION.md`.

Then locate the owner module with search and targeted reads. The config
files and scripts are the source of truth; `project/` is the map.

## Workflow

1. Restate the request as requirements. Note which rules and axioms apply.
2. Find the owner module in `NAVIGATION.md`.
3. Make the smallest change that satisfies the request.
4. Run the mandatory checklists from `../../AGENTS.md` whose situation
   applies.
5. Run targeted checks first, then broader ones, from the repository root:
   - `bash -n <file>` for every changed `*.sh` file;
   - `nvim --headless "+qa"` with `nvim/install.sh` applied: Neovim loads
     the config and prints no errors;
   - `tmux source-file -n tmux/tmux.conf` inside a running tmux: tmux
     parses the config without running it and prints no errors.
6. Inspect the diff for unrelated changes.
7. Keep `../../project/` current, in the same task:
   - `OVERVIEW.md` when the purpose, the main parts, the stack, or how the
     project runs changed. Keep it a short current description, not a
     history.
   - `AXIOMS.md` when the user settled a decision during the task: add it as
     the next numbered axiom with its scope and date.
   - `NAVIGATION.md` when a meaningful module or domain owner was added,
     removed, or moved.
   Even when nothing above changed, reread `OVERVIEW.md` and fix anything
   it now gets wrong.

## Final report

Report what changed and in which files, the verification results, skipped
checks and why, which axioms the work followed, which `project/` files were
updated, and any real remaining risk.
