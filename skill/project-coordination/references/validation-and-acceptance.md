# Validation And Acceptance

Use the installed `validation-harness` skill before implementation and when reviewing completion evidence. Treat its declared harness, implementation state, validation evidence, lane matrix, and blocked-gate rules as the validation source of truth; do not redefine them in this coordination reference.

When the task declares a quality audit, verify that the execution session ran the selected changed-file profile and classified each relevant finding. Scanner output is heuristic review input; it neither proves a defect nor replaces compiler, test, runtime, or end-to-end evidence.

Acceptance belongs to the coordination session, not the execution session that implemented the task. Before accepting, verify that changed files match the declared scope, the execution record includes commands or flows and results, the decisive harness evidence supports the requested completion claim, formatter or generator changes have before/after snapshots, dependencies and consumer contracts are reconciled, and remaining risks are explicit. Append `assets/acceptance-record-template.md` to the canonical task with the result. Commit or merge only with the user's authorization and the project's ownership policy.
