# Coordinated Planning

Create a plan with `assets/plan-template.md` when the intended outcome spans multiple executable tasks, repositories, release stages, or unresolved decisions. Do not create a plan merely to restate one task.

A plan owns direction, decomposition, sequencing, and completion conditions. It does not own live task status or execution evidence. Keep those in `docs/PROJECT_TASKS.md` and `docs/tasks/`.

Before making a plan active:

1. Ground the current state in decisions, contracts, code, incidents, or validation evidence.
2. State outcomes and non-goals so later task sessions cannot silently expand scope.
3. Divide work into owner-aligned workstreams with explicit hard and soft dependencies.
4. Identify decisions and external inputs that must resolve before dispatch.
5. Define cross-workstream validation and release conditions.
6. Create task documents only when a workstream is executable; link them from the plan and task index.

Use a plan by default for `complex` multi-stage work. Use one for `standard` work when more than one task or component needs sequencing. Skip it for `compact` work unless the user explicitly needs a roadmap.

Mark a plan `Completed` only after its required tasks are accepted and its completion conditions are independently checked. Mark it `Superseded` rather than rewriting historical direction after a replacement decision.
