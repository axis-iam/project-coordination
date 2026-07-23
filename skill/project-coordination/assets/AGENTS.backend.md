# Backend Instructions

- Own API, domain behavior, persistence, migrations, and server-side authorization.
- Read the nearest contract, decision, and task document before changing public behavior.
- Derive the focused build, test, formatter, and integration commands from the local build manifest; record the commands actually used in the task execution record.
- Use the installed `validation-harness` skill before non-trivial implementation and prove runtime behavior when the completion claim crosses a real service or persistence boundary.
- Use the installed `api-contract-sync` skill when a public API, schema, event, generated client, frontend consumer, mock, or SDK contract changes.
- Run the task's declared `code-quality-audit` changed-file profile and classify findings before handoff.
- Escalate to the installed `project-coordination` skill when a migration, security boundary, SDK behavior, or frontend-visible behavior requires dependency sequencing or a new execution session.
- Keep error behavior explicit. Do not add speculative fallback behavior to conceal missing context or failed authorization.
