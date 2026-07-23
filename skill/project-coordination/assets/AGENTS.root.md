# Project Instructions

## Coordination

- Use the installed `workstream-triage` skill before answering status, remaining-work, next-wave, continue, prioritization, or release questions.
- Use the installed `project-coordination` skill for planning, cross-component task dispatch, dependency sequencing, acceptance, and release readiness.
- Use the installed `validation-harness` skill before non-trivial implementation, when proving a fix, and for runtime or browser smoke. Match completion claims to the recorded evidence depth.
- Use the installed `api-contract-sync` skill when an API, schema, event, mock, generated client, frontend consumer, or SDK contract changes.
- For every tracked or handed-off task, keep coordination, fresh execution, and acceptance in separate sessions. The coordinator dispatches and accepts; the execution session implements and records evidence.
- Treat the installed workflow profile as a project default. Select and record an effective task profile before dispatching; raise or reduce it only from discovered task facts.
- Treat `docs/PROJECT_TASKS.md` as the task index. Use `docs/tasks/` for executable tracked work.
- Keep accepted decisions in `docs/decisions/`, plans in `docs/plans/`, and reusable guidance in `docs/guides/` when those directories are needed.
- Use the installed `code-quality-audit` skill at the task's declared quality gate. Treat scanner findings as review candidates, not proof of defects.
- Do not claim completion without recorded validation evidence from the declared harness.
- Do not dispatch downstream work before its hard prerequisite is accepted.
- Do not modify an unknown dirty worktree or commit without explicit authorization.

## Local Instructions

Read the nearest child `AGENTS.md` or `CLAUDE.md` before modifying a component. Add project-specific ownership, commands, product constraints, and safety invariants here or in child instruction files; do not duplicate the complete coordination workflow.
