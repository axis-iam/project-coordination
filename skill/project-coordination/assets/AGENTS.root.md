# Project Instructions

## Coordination

- Use `$project-coordination` for workstream triage, cross-component task dispatch, dependency sequencing, acceptance, and release readiness.
- For tracked `standard` or `complex` work, keep coordination, fresh execution, and acceptance in separate sessions. The coordinator dispatches and accepts; the execution session implements and records evidence.
- Treat `docs/PROJECT_TASKS.md` as the task index. Use `docs/tasks/` for executable tracked work.
- Keep accepted decisions in `docs/decisions/`, plans in `docs/plans/`, and reusable guidance in `docs/guides/` when those directories are needed.
- Do not claim completion without recorded validation evidence.
- Do not dispatch downstream work before its hard prerequisite is accepted.
- Do not modify an unknown dirty worktree or commit without explicit authorization.

## Local Instructions

Read the nearest child `AGENTS.md` before modifying a component. Add project-specific ownership, commands, product constraints, and safety invariants here or in child instruction files; do not duplicate the complete coordination workflow.
