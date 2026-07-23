# Task Dispatch

Create a task document when the process threshold in `SKILL.md` is met. Use `assets/task-template.md`; keep irrelevant sections short rather than deleting them.

Before dispatching:

1. Confirm the task owner, writable Git roots, and implementation components from the project profile and local `AGENTS.md` or `CLAUDE.md` files.
2. Use `references/task-profile-selection.md` with discovered facts. Record the project default, effective task profile, and controlling reason in the task document.
3. Identify the source-of-truth decision, plan, contract, or existing task.
4. Declare user-provided inputs and external gates before implementation details.
5. Use the installed `validation-harness` skill to declare a harness that can prove the intended behavior.
6. Declare whether `api-contract-sync` is required and name the authoritative contract plus affected consumers.
7. Declare whether the `code-quality-audit` skill is required, including its profile and changed-since revision.
8. Define the session policy: coordination session, fresh execution session, acceptance session, and commit authority.
9. Define the execution-record and acceptance-record locations.
10. Update the owning `docs/PROJECT_TASKS.md` index. Create a child index only when an independent repository first owns an executable task.

Generate handoff prompts in the current chat from the task document. Do not create a second prompt document as a competing source of truth.

Require the handoff to state that it is for a fresh execution session, plus the target repository, branch or worktree, dependency status, validation harness, external gate, execution-record requirement, and commit authority. Do not dispatch downstream implementation when its hard prerequisite remains unresolved.
