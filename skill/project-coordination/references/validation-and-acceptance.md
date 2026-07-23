# Validation And Acceptance

Declare the narrowest reproducible harness before implementation. Re-run the same harness after implementation and record the result.

Use both axes in every execution record:

| Axis | Values |
| --- | --- |
| Implementation State | `DESIGN_ONLY`, `CONTRACT_ONLY`, `STUB_ONLY`, `IMPLEMENTED` |
| Validation Evidence | `UNVERIFIED`, `TOOLING_PASS`, `RUNTIME_PASS`, `E2E_PASS`, `BLOCKED` |

Only `IMPLEMENTED` with `RUNTIME_PASS` or `E2E_PASS` can be reported as externally complete. A build, formatter, typecheck, mock, static scan, or task-document update is not enough by itself.

For multi-component work, record each lane independently. A backend API pass does not prove SDK or browser behavior. For security or authorization work, include meaningful negative cases. For external gates, record exactly what is missing and do not downgrade the conclusion to a pass.

Acceptance belongs to the coordination session, not the execution session that implemented the task. Before accepting, verify that changed files match the declared scope, the execution record includes commands or flows and results, formatter or generator changes have before/after snapshots, dependencies and consumer contracts are reconciled, and remaining risks are explicit. Commit or merge only with the user's authorization and the project's ownership policy.
