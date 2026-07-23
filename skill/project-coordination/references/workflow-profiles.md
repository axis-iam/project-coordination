# Workflow Profiles

Use the profile in `project-profile.md` as the default level of process. Escalate when the actual risk is higher; reduce process for clearly local low-risk work.

## Compact

Use for a small project, a single repository, or a small backend and frontend pair.

- Make local changes directly when the owner, scope, and validation are obvious.
- Create a task document only for cross-component work, a decision, a risky change, or explicit tracking.
- Use one task branch or worktree for one writable repository.
- A tracked or handed-off task uses a fresh execution session and returns to coordination for acceptance.
- Keep the index concise; do not create empty plans or decision directories merely for taxonomy.

## Standard

Use when backend and frontend are independently developed or when an API contract requires sequencing.

- Record cross-component tasks in `docs/tasks/`.
- Identify the API contract owner before frontend or SDK implementation.
- Use a separate worktree for each concurrently modified Git root.
- Record focused build and behavior evidence in the execution record.
- The coordination session dispatches a fresh execution session, then independently accepts its result.

## Complex

Use when several repositories, SDKs, teams, sessions, external gates, migrations, or release checks are involved.

- Build a dependency graph before dispatching parallel work.
- Require per-repository worktree policies and execution records.
- Distinguish raw API, SDK, browser, and operational validation lanes.
- Audit accepted decisions for unfinished implementation stages before status or release conclusions.
- Treat credentials, third-party setup, DNS/TLS, callback URLs, and manual approvals as explicit external gates.
- Use one or more fresh execution sessions for implementation; keep the coordinator separate for dispatch and acceptance.
