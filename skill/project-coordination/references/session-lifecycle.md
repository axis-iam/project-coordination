# Session Lifecycle

Use three roles for every tracked or handed-off task. An untracked `compact` local-only task may implement and verify in one session.

| Stage | Owner | Required output | Exit gate |
| --- | --- | --- | --- |
| Plan and dispatch | Coordination session | Canonical task document, dependency decision, worktree policy, validation harness, external-gate status, and a handoff prompt | Task status is `Dispatched` |
| Implement | Fresh execution session | Scoped code or documentation changes and an execution record | Task status is `Ready for Acceptance` or `Blocked` |
| Accept | Coordination session | Independent diff, scope, dependency, and validation review | Task status is `Accepted` or returned as `Blocked` / `Implementing` |

The coordination session owns global context: decisions, sequencing, task scope, dispatch, cross-component reconciliation, and acceptance. It may inspect code and evidence, but it must not quietly become the feature implementation session for a tracked task.

The execution session starts with a fresh context. It must read the canonical task document before editing, work only in the declared repositories and worktrees, follow the declared harness, and append the execution record. It must not expand scope, invent unresolved contracts, dispatch downstream work, or commit unless the task and user explicitly grant that authority.

The acceptance step returns to a coordination session after implementation. Do not accept solely because the execution session reports success. Independently inspect the declared scope and worktree state, read the execution record, verify the required evidence, and confirm hard prerequisites and consumer contracts are reconciled.

Do not claim that an external session has been created merely by writing a handoff prompt. The coordinator produces the prompt; the user or execution environment starts the fresh session.

For a `compact` local-only change, one session may implement and verify directly. Once the change becomes tracked, cross-component, security-sensitive, externally gated, or handed off, reselect the effective task profile and move to this lifecycle rather than continuing in the same implementation context.
