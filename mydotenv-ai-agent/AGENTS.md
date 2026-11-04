# mydotenv agent

Personal dotfiles for tmux and Neovim: a shareable, self-contained
configuration that can be cloned and reused on another machine. Full
description: `project/OVERVIEW.md`.

This file is read through the root `AGENTS.md`; it is not a separate entry
point. In every agent file, paths that start with `rules/`, `checklists/`,
`project/`, or `skills/` are relative to this folder; all other paths are
relative to the repository root.

## Rules

Every file in `rules/` is mandatory in every task. Do not change, bypass, or
weaken a rule. When a task conflicts with a rule, stop and ask the user.

@rules/agent-files.md

@rules/repository.md

@rules/keybindings.md

## Checklists

| Checklist | Run when | Mandatory |
|---|---|---|
| `checklists/new-tool.md` | adding the configuration of a new tool | yes |

Before reporting a task as done, run every mandatory checklist whose
situation applies, and say which ones you ran.

## Project description and axioms

`project/` describes the project and is kept up to date:

- `project/OVERVIEW.md`: what the project is, its parts, and how it runs.
- `project/AXIOMS.md`: settled decisions. Follow them without asking whether
  to do otherwise, do not argue with them, and do not suggest alternatives
  unless the user asks. When an answer, plan, or change relies on an axiom,
  say so and cite it, for example "per axiom A2 in project/AXIOMS.md, ...".
- `project/NAVIGATION.md`: which module owns what.

Read `project/` before changing code. Only the owner changes an axiom.

## Skills

- `skills/feature-delivery/SKILL.md`: the default for feature, bug-fix,
  refactor, test, and documentation work when no more specific skill
  applies. It keeps `project/` up to date.
