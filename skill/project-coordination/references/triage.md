# Workstream Triage

Read the root `docs/PROJECT_TASKS.md` first. Read only the task documents, plans, and decisions linked to the requested workstream. If a component owns its own index, read that index as well.

Build an evidence ledger before claiming what remains:

| Evidence source | Establishes |
| --- | --- |
| Accepted decision | Product or architecture constraint and required follow-up |
| Plan | Intended direction and sequencing candidate |
| Task document and execution record | Assigned work and recorded implementation state |
| Commit and validation evidence | What changed and what was actually verified |

For every candidate backlog item, check for a newer task record, accepted completion, replacement decision, or commit evidence. Classify it as active, blocked, completed, superseded, or uncertain. Do not repeat superseded historical work as remaining work.

Audit every accepted decision as `fully implemented`, `partially implemented`, `implementation pending`, or `customer-gated`. Add unfinished decision stages to the dependency graph even when a plan or task index forgot to repeat them. When a plan conflicts with an accepted decision, report the conflict and treat the accepted decision as authoritative until it is superseded.

For release readiness, include pending decision implementation, current blocking tasks, explicit exclusions, and fresh validation requirements. Historical smoke or pilot evidence is not proof of the current release state.
