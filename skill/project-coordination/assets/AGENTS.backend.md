# Backend Instructions

- Own API, domain behavior, persistence, migrations, and server-side authorization.
- Read the nearest contract, decision, and task document before changing public behavior.
- Derive the focused build, test, formatter, and integration commands from the local build manifest; record the commands actually used in the task execution record.
- Escalate to `$project-coordination` when a public contract, migration, security boundary, SDK behavior, or frontend-visible behavior changes.
- Keep error behavior explicit. Do not add speculative fallback behavior to conceal missing context or failed authorization.
