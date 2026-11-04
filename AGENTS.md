# mydotenv

`AGENTS.md` is the agent entry point for this project;
`CLAUDE.md` is a symlink to it. Edit only this file, and keep it a pointer.

All agent files for this project live in `mydotenv-ai-agent/`.
Global rules come from the global agent and are already loaded.

Before any task, read the agent entry file in full:

@mydotenv-ai-agent/AGENTS.md

It imports every mandatory rule from `mydotenv-ai-agent/rules/` and lists the
checklists, the project axioms, and the local skills. Codex does not follow
`@` imports: read that file and every file in `mydotenv-ai-agent/rules/`
yourself before starting.

Default skill for feature, bug-fix, refactor, test, and documentation work
when no more specific skill applies:
`mydotenv-ai-agent/skills/feature-delivery/SKILL.md`.
