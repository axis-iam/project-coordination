---
name: project-coordination
description: Coordinate installed software projects across backend, frontend, SDK, and auxiliary components. Use for remaining-work triage, cross-component task dispatch, dependency sequencing, worktree assignment, acceptance, release readiness, or reconciling task and decision evidence. Do not use for a small local implementation or a quick read-only question that has no coordination impact.
---

# Project Coordination

Read `references/project-profile.md` first. Then read the nearest applicable `AGENTS.md` and only the project documents required by the requested mode. Treat the generated profile as discovery output, not as a substitute for source files.

## Select A Mode

| User intent | Read |
| --- | --- |
| Remaining work, next wave, continue, priority | `references/triage.md` |
| Create a handoff or split backend/frontend/auxiliary work | `references/task-dispatch.md` and `references/dependency-gates.md` |
| Coordinate a task across sessions, start implementation, or return for acceptance | `references/session-lifecycle.md` |
| Change an API, event, schema, browser client, or SDK contract | `references/contract-sequencing.md` |
| Assign branches or worktrees, or audit formatter changes | `references/worktree-policy.md` |
| Validate, accept, or close work | `references/validation-and-acceptance.md` |
| Decide release readiness | `references/release-readiness.md` |
| Create or classify project documentation | `references/document-taxonomy.md` |
| Unsure how much process to use | `references/workflow-profiles.md` |

## Core Protocol

1. Discover project facts from the generated profile, repository manifests, `AGENTS.md`, and source documents. Do not require the user to maintain commands or repository lists in a form.
2. Classify the current session as coordination, execution, or acceptance. Follow `references/session-lifecycle.md` before changing a tracked task's stage.
3. Use the configured workflow profile as a default, then reduce process only for a clearly local low-risk change.
4. For a tracked `standard` or `complex` task, the coordination session creates the canonical task and handoff, a fresh execution session implements it, and the coordination session independently accepts it. Do not perform all three roles in one session.
5. Treat accepted decisions, executable task documents, commit evidence, and validation evidence as separate facts. Do not infer one from another.
6. Identify hard prerequisites before dispatching downstream work. A frontend or SDK must not guess an unresolved backend contract.
7. Create or update `docs/PROJECT_TASKS.md` only as an index. Put executable work in `docs/tasks/` when a task record is warranted.
8. For each task record, use `assets/task-template.md` and `assets/execution-record-template.md`. Require an execution record and a declared validation harness before claiming completion.
9. For concurrent or multi-repository work, assign one worktree per writable Git root. Treat read-only dependencies as pinned evidence, not writable workspaces.
10. Do not claim product completion from documentation, static inspection, formatting, mock-only evidence, or a successful build alone.
11. Do not commit, change remote state, or overwrite an existing project instruction file unless the user explicitly authorizes it.

## Process Threshold

Work directly in the current session only when the change is local, low-risk, and has a focused validation command. Create a task record and use a fresh execution session when any of these apply:

- Multiple components or repositories must change.
- A public API, schema, migration, security boundary, or SDK contract changes.
- Work is handed to another session or person.
- Runtime validation needs credentials, a third-party console, a callback URL, or another external input.
- The work implements or changes an accepted decision.

## Output Requirements

For triage, report the active workstream, evidence source, dependencies, and next action. For dispatch, provide the task document contents and a chat handoff prompt for a new execution session. For acceptance, report implementation state, independently checked validation evidence, remaining risks, and any blocked external gate.

Use the project-local capability skills for implementation, local startup, code audit, or domain-specific work. This skill coordinates those capabilities; it does not replace them.

When establishing project instructions, copy and adapt `assets/AGENTS.root.md`, `assets/AGENTS.backend.md`, or `assets/AGENTS.frontend.md` only when the corresponding file is missing or the user explicitly requests an update. Use `assets/decision-template.md` for a new durable product or architecture decision. Never overwrite an existing instruction or decision document implicitly.
