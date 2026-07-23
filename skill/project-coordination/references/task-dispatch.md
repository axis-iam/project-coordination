# Task Dispatch

Create a task document when the process threshold in `SKILL.md` is met. Use `assets/task-template.md`; keep irrelevant sections short rather than deleting them.

Before dispatching:

1. Confirm the task owner and writable Git roots from the project profile and local `AGENTS.md` files.
2. Identify the source-of-truth decision, plan, contract, or existing task.
3. Declare user-provided inputs and external gates before implementation details.
4. Declare a validation harness that can prove the intended behavior.
5. Define the session policy: coordination session, fresh execution session, acceptance session, and commit authority.
6. Define the execution-record location.
7. Update the owning `docs/PROJECT_TASKS.md` index. Create a child index only when an independent repository first owns an executable task.

Generate handoff prompts in the current chat from the task document. Do not create a second prompt document as a competing source of truth.

Require the handoff to state that it is for a fresh execution session, plus the target repository, branch or worktree, dependency status, validation harness, external gate, execution-record requirement, and commit authority. Do not dispatch downstream implementation when its hard prerequisite remains unresolved.
