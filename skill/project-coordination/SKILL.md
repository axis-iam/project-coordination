---
name: project-coordination
description: Coordinate installed software projects across backend, frontend, SDK, and auxiliary components. Use for multi-stage planning, cross-component task dispatch, fresh execution-session handoff, dependency sequencing, worktree assignment, independent acceptance, release readiness, or acting on a workstream established by workstream-triage. Do not use for a small local implementation or a quick read-only question that has no coordination impact.
---

# Project Coordination

Read `docs/PROJECT_PROFILE.md` first. Then read the nearest applicable project instruction file and only the project documents required by the requested mode. Treat the generated profile as discovery output, not as a substitute for source files.

## Select A Mode

| User intent | Read |
| --- | --- |
| Remaining work, next wave, continue, priority, schedule | Use the installed `workstream-triage` skill first; return here only when planning or dispatch is requested |
| Create or revise a multi-stage plan | `references/planning.md` and `references/document-taxonomy.md` |
| Create a handoff or split backend/frontend/auxiliary work | `references/task-dispatch.md` and `references/dependency-gates.md` |
| Coordinate a task across sessions, start implementation, or return for acceptance | `references/session-lifecycle.md` |
| Choose tests, prove a fix, run runtime smoke, or classify evidence | Use the installed `validation-harness` skill; return here for independent acceptance |
| Synchronize an API, event, schema, browser client, mock, generated client, or SDK contract | Use the installed `api-contract-sync` skill and read `references/contract-sequencing.md` for dispatch order |
| Assign branches or worktrees, or audit formatter changes | `references/worktree-policy.md` |
| Validate, accept, or close work | `references/validation-and-acceptance.md` |
| Decide release readiness | `references/release-readiness.md` |
| Create or classify project documentation | `references/document-taxonomy.md` |
| Select or revise a task's process level | `references/workflow-profiles.md` and `references/task-profile-selection.md` |

## Core Protocol

1. Discover project facts from the generated profile, repository manifests, the nearest `AGENTS.md` or `CLAUDE.md`, and source documents. Do not require the user to maintain commands or repository lists in a form.
2. Classify the current session as coordination, execution, or acceptance. Follow `references/session-lifecycle.md` before changing a tracked task's stage.
3. Use the configured workflow profile as a project default. Before tracked work, select the effective task profile from discovered facts and record any raise or reduction with its reason. Reduce only an explicitly local-only task.
4. For every tracked or handed-off task, the coordination session creates the canonical task and handoff, a fresh execution session implements it, and the coordination session independently accepts it. Do not perform all three roles in one session.
5. Treat accepted decisions, executable task documents, commit evidence, and validation evidence as separate facts. Do not infer one from another.
6. Identify hard prerequisites before dispatching downstream work. A frontend or SDK must not guess an unresolved backend contract.
7. Create or update `docs/PROJECT_TASKS.md` only as an index. Put executable work in `docs/tasks/` when a task record is warranted.
8. Use `assets/plan-template.md` for multi-stage direction and `assets/task-template.md` for executable work. Do not duplicate live task status inside a plan.
9. Require the installed `validation-harness` skill before non-trivial implementation and when reviewing evidence. Require `assets/execution-record-template.md` after implementation and `assets/acceptance-record-template.md` during independent acceptance.
10. Require the installed `api-contract-sync` skill when an accepted contract must be reconciled across producers, consumers, mocks, generated clients, or SDKs.
11. Declare the `code-quality-audit` skill requirement during dispatch. Use changed-file review according to `references/workflow-profiles.md`, and classify findings without treating them as proof of defects.
12. For concurrent or multi-repository work, assign one worktree per writable Git root. Treat read-only dependencies as pinned evidence, not writable workspaces.
13. Do not claim product completion from documentation, static inspection, formatting, mock-only evidence, or a successful build alone.
14. Do not commit, change remote state, or overwrite an existing project instruction file unless the user explicitly authorizes it.

## Process Threshold

Work directly in the current session only when the change is local, low-risk, and has a focused validation command. Create a task record and use a fresh execution session when any of these apply:

- Multiple components or repositories must change.
- A public API, schema, migration, security boundary, or SDK contract changes.
- Work is handed to another session or person.
- Runtime validation needs credentials, a third-party console, a callback URL, or another external input.
- The work implements or changes an accepted decision.

## Output Requirements

For workstream status, use the `workstream-triage` result as the controlling scope. For planning, produce the canonical plan and identify which stages are ready to become tasks. For dispatch, provide the task document contents and a chat handoff prompt for a new execution session. For acceptance, append an acceptance record and report implementation state, independently checked validation evidence, remaining risks, and any blocked external gate.

Use the installed companion skills for validation, contract sync, and code audit, plus project-local capability skills for implementation, local startup, or domain-specific work. This skill coordinates those capabilities; it does not replace them.

When establishing project instructions, copy and adapt `assets/AGENTS.root.md`, `assets/AGENTS.backend.md`, or `assets/AGENTS.frontend.md` only when the corresponding `AGENTS.md` or `CLAUDE.md` is missing or the user explicitly requests an update. Use `assets/decision-template.md` for a new durable product or architecture decision. Never overwrite an existing instruction or decision document implicitly.
