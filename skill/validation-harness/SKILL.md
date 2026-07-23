---
name: validation-harness
description: Define, run, and record the narrowest reproducible validation surface for non-trivial software changes. Use before implementation, when choosing tests, when proving a fix or feature, when reviewing completion evidence, when runtime or browser smoke is requested, or when deciding whether build-, mock-, tooling-, runtime-, or end-to-end evidence supports a completion claim.
---

# Validation Harness

Read `docs/PROJECT_PROFILE.md`, the nearest applicable `AGENTS.md` or `CLAUDE.md`, and the active task document when one exists. Discover commands and runtime topology from the project; do not require the user to maintain them in the profile.

## Declare The Harness Before Editing

Record these facts before changing production code:

1. Behavior or contract being proved.
2. Narrowest command, script, request, or user flow that exercises it.
3. Fixture, account, seed data, service, browser, or external input required.
4. Expected pass signal and, for a defect, the expected pre-fix failure.
5. Meaningful negative cases for security, permissions, tenancy, validation, lifecycle, and destructive behavior when applicable.
6. Where commands, results, and remaining gaps will be recorded.

Prefer the fastest closed loop that can falsify the intended behavior. Do not substitute a broad build for a focused behavioral check, but do not stop at a narrow mock when the completion claim crosses a real boundary.

## Select Evidence Depth

| Evidence depth | Typical surfaces | What it can establish |
| --- | --- | --- |
| Tooling | formatter, linter, compiler, typecheck, unit test, static scan, fake server, mock | Local structure or isolated behavior |
| Runtime | integration test, real process, real database path, actual package consumer, live endpoint | Behavior on the owning runtime surface |
| End to end | cross-service request, browser user flow, SDK against a real API, external integration | Behavior across all required consumer boundaries |

When an `api-contract-sync` ledger exists, treat its authoritative source and affected-consumer list as validation inputs. If a contract change lacks that inventory, report the missing sync requirement instead of guessing the consumers. Use the installed `code-quality-audit` skill when the task declares a changed-file quality gate.

## Record Both Axes

Every tracked execution and acceptance record must state:

| Axis | Values |
| --- | --- |
| Implementation State | `DESIGN_ONLY`, `CONTRACT_ONLY`, `STUB_ONLY`, `IMPLEMENTED` |
| Validation Evidence | `UNVERIFIED`, `TOOLING_PASS`, `RUNTIME_PASS`, `E2E_PASS`, `BLOCKED` |

Only real product behavior with `IMPLEMENTED + RUNTIME_PASS` or `IMPLEMENTED + E2E_PASS` may be described externally as complete. A design, generated type, placeholder, mock-only flow, successful build, or timestamp proves only its stated surface. Documentation-only work may be accepted as documentation without implying runtime behavior.

When validation is blocked, record the missing environment, credential, account, service, decision, or external approval and the exact next command or flow. Do not weaken the expected behavior to obtain a pass.

## Execute And Record

1. Capture the starting failure or baseline when feasible.
2. Implement only the declared task scope.
3. Re-run the same harness after the change.
4. Expand to runtime or end-to-end checks when the user-visible claim crosses those boundaries.
5. Record each component or consumer lane independently; one lane passing does not imply another passed.
6. Append evidence to the canonical task's execution record. The execution session does not accept its own work.
7. During acceptance, independently inspect the diff, rerun or verify the decisive harness, and confirm that the evidence depth matches the completion claim.

For live service, SDK, browser, or external-integration smoke, read `references/runtime-smoke.md` before running or reporting the harness.

## Output

Report the declared harness, commands or flows executed, observed results, both state axes, lane-specific gaps, and the next reproducible action. Never report a stronger conclusion than the evidence supports.
