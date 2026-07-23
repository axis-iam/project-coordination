# Document Taxonomy

Use `docs/PROJECT_TASKS.md` as an index, not as the full task record.

Create these directories only when their document type is needed:

| Path | Purpose |
| --- | --- |
| `docs/tasks/` | Executable work with scope, dependencies, validation, and an execution record |
| `docs/decisions/` | Accepted or proposed durable product and architecture decisions |
| `docs/plans/` | Direction, sequencing, and multi-stage planning that is not yet executable work |
| `docs/guides/` | Reusable development, integration, operation, or troubleshooting guidance |

Do not create new `docs/prompts/` files. Generate handoff prompts from the canonical task document in the current conversation. Treat an existing `docs/prompts/` directory as historical archive only.

Use `docs/fixtures/` only for reusable protocol examples or validation inputs when the project has a real need. It is not a workflow document category.

Create a component-level `docs/PROJECT_TASKS.md` lazily when an independent Git repository owns executable tasks. Keep the root index as the cross-component entry point and link to the owning component record instead of duplicating its body.
