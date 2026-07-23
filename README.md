# Project Coordination

A repository-local coordination package for Codex and Claude Code. It installs five complementary skills into each target project:

| Skill | Responsibility |
| --- | --- |
| `workstream-triage` | Determine the current workstream from decisions, plans, the task index, and repository evidence; separate blockers, future work, and unresolved decisions without silently changing the primary workstream. |
| `project-coordination` | Turn approved direction into plans and executable tasks, hand work to a fresh execution session, and independently accept the result in the coordination session. |
| `validation-harness` | Declare the narrowest reproducible check before implementation, distinguish tooling/runtime/E2E evidence, and coordinate lane-based runtime smoke. |
| `api-contract-sync` | Align an authoritative API, schema, or event contract across producers, frontends, mocks, generated clients, documentation, and SDK consumers. |
| `code-quality-audit` | Review changed files for suspicious fallback, error masking, unsafe browser storage, loose typing, and unnecessary state synchronization. |

The package is installed per project and adapted from the detected repository structure. It is not a global personal skill and contains no IAM-specific product rules.

Project introduction: https://axis-iam.github.io/project-coordination/

## Install With An Agent

Clone this repository, then give Codex or Claude Code the following prompt. Replace the target path and, when known, provide the two choices at the bottom.

```text
Install the project-coordination package from this repository into:

<absolute-target-project-path>

Requirements:

1. Read this repository's README.md, all skill/*/SKILL.md files, and
   scripts/install.* before acting.
2. Inspect the target project's Git status, AGENTS.md, CLAUDE.md, docs/,
   .agents/skills/, and .claude/skills/. Do not modify business code.
3. Preserve existing AGENTS.md, CLAUDE.md, and docs/PROJECT_TASKS.md. Do not
   overwrite an unmanaged same-name skill. Use update mode only when I ask to
   update a package previously managed by this repository.
4. If I did not provide Architecture and Workflow profile, ask only:
   - Architecture: monorepo | multi-repo
   - Workflow profile: compact | standard | complex
5. Do not ask me for repository paths, components, build commands, or
   validation commands. Discover those from the target project.
6. Run the installer for the current operating system. Do not manually
   reimplement its file operations.
7. Run the repository's installation validation and inspect the generated
   docs/PROJECT_PROFILE.md.
8. Report created files, preserved files, detected Git roots and components,
   selected workflow profile, and unresolved conflicts.
9. Do not modify product-specific rules, business code, or create a Git commit.

Architecture: multi-repo
Workflow profile: standard
```

Omit the final two lines when the choices are not known. The agent should ask only those two questions.

## Manual Install

Run one installer command from this repository:

```bash
./scripts/install.sh /path/to/target-project
```

```powershell
.\scripts\install.ps1 -TargetPath C:\path\to\target-project
```

For non-interactive installation, provide both choices:

```bash
./scripts/install.sh /path/to/target-project --architecture multi-repo --workflow standard
```

```powershell
.\scripts\install.ps1 -TargetPath C:\path\to\target-project -Architecture multi-repo -Workflow standard
```

When values are omitted, the installer asks only:

1. `monorepo` or `multi-repo`
2. `compact`, `standard`, or `complex`

It discovers Git roots, component manifests, and candidate commands. It creates `docs/PROJECT_TASKS.md`, `AGENTS.md`, and `CLAUDE.md` only when each file is absent, then generates the shared `docs/PROJECT_PROFILE.md`.

The five skills are installed in both platform layouts:

```text
.agents/skills/                 # Codex
├── project-coordination/
├── workstream-triage/
├── validation-harness/
├── api-contract-sync/
└── code-quality-audit/

.claude/skills/                 # Claude Code
├── project-coordination/
├── workstream-triage/
├── validation-harness/
├── api-contract-sync/
└── code-quality-audit/
```

## Update

Update a managed installation while preserving the selected architecture, workflow profile, root instructions, and task index:

```bash
./scripts/install.sh /path/to/target-project --update
```

```powershell
.\scripts\install.ps1 -TargetPath C:\path\to\target-project -Update
```

Update mode cleanly replaces all five managed skill directories in both platform layouts, removing files retired by the package, and regenerates `docs/PROJECT_PROFILE.md`. It preserves the project-owned root instructions and task index, and refuses to overwrite an unmanaged same-name skill. Product-specific instructions and capability skills remain outside these managed directories.

## Workflow Profiles

| Profile | Use for | Default behavior |
| --- | --- | --- |
| `compact` | One small repository or a small backend and frontend | Work directly for explicitly local, low-risk changes. Once tracked or handed off, use the full session lifecycle. |
| `standard` | Backend and frontend that need contract sequencing | Track cross-component changes, use a fresh execution session, and return to coordination for acceptance. |
| `complex` | Multiple repositories, SDKs, concurrent sessions, or external gates | Require plans, dependency gates, per-repository worktrees, changed-file audits, execution records, and acceptance records. |

The selected profile is only a project default. Before dispatching tracked work, the coordinator derives and records an effective task profile from writable Git roots, components, handoff, contract, security, migration, external-gate, release, and multi-wave facts. A local task in a complex project can reduce to `compact`; a public contract or external gate in a compact project raises to `standard` or `complex`.

## Session Model

Tracked work follows the package's central lifecycle:

```text
Coordination session -> fresh execution session -> coordination acceptance
```

The coordination session anchors the active workstream, creates the canonical task, resolves dependency gates, invokes `validation-harness` to define evidence, declares contract-sync and audit requirements, and produces a handoff prompt. The fresh execution session implements only that task, runs the declared checks, and appends an execution record without committing. The coordination session then independently reviews the diff and evidence and appends an acceptance record. Commit authority remains with the user.

Only an untracked `compact` local-only task may remain in one session. Once work is tracked, handed off, cross-component, security-sensitive, externally gated, or multi-repository, reselect the effective task profile and use the full lifecycle.

## Use After Installation

Codex uses `$skill-name`; Claude Code uses `/skill-name`:

| Intent | Codex | Claude Code |
| --- | --- | --- |
| Confirm current work | `Use $workstream-triage to identify the active workstream.` | `/workstream-triage identify the active workstream.` |
| Plan or dispatch | `Use $project-coordination to plan and dispatch this work.` | `/project-coordination plan and dispatch this work.` |
| Define or run validation | `Use $validation-harness to prove this change.` | `/validation-harness prove this change.` |
| Synchronize a contract | `Use $api-contract-sync to align this API change.` | `/api-contract-sync align this API change.` |
| Accept implementation | `Use $project-coordination to accept this task.` | `/project-coordination accept this task.` |
| Audit changed code | `Use $code-quality-audit to review changed files since HEAD.` | `/code-quality-audit review changed files since HEAD.` |

Read-only status queries do not mutate `docs/PROJECT_TASKS.md`. The triage skill updates the active-workstream fields only when the user asks to establish or change the coordination state.

The generated project profile is shared by both agents:

```text
docs/PROJECT_PROFILE.md
```

Refresh it after repository roots or component manifests change:

```bash
.agents/skills/project-coordination/scripts/refresh-project-profile.sh .
```

```powershell
.\.agents\skills\project-coordination\scripts\refresh-project-profile.ps1 -TargetPath .
```

The equivalent scripts under `.claude/skills/` produce the same shared profile.

## Document Model

```text
Decision -> Plan -> Task -> Execution Record -> Acceptance Record
                 +-> docs/PROJECT_TASKS.md index and active workstream
```

- Decisions preserve durable product or architecture choices.
- Plans sequence multi-stage direction without duplicating live task status.
- Tasks are canonical executable handoffs for fresh sessions.
- Execution records preserve implementation and validation evidence.
- Acceptance records preserve the coordinator's independent conclusion.

Templates for all five document types, the task index, and root/backend/frontend instructions are bundled under each installed `project-coordination/assets/` directory. Installation creates only the missing root instruction files and task index; plans and other records are created when the workflow requires them.

## Quality Audit

The scanner supports Java, Kotlin, TypeScript, JavaScript, Go, and Python. It includes owner-specific profiles, changed-file scanning, severity gates, baselines, JSON output, and focused rule selection.

```bash
python3 .agents/skills/code-quality-audit/scripts/scan_code_quality.py --root . --profile backend-java --changed-since HEAD
```

```powershell
python .\.agents\skills\code-quality-audit\scripts\scan_code_quality.py --root . --profile backend-java --changed-since HEAD
```

Findings are heuristic review candidates, not confirmed defects. Runtime behavior still requires compiler, test, integration, browser, or end-to-end evidence.

## Project-Specific Boundaries

This repository provides coordination, workstream control, validation discipline, cross-surface contract synchronization, and changed-file review. The reusable runtime-smoke method is part of `validation-harness`, but concrete service startup remains project-local.

It deliberately excludes product boundaries, domain onboarding, service topology, local stack launchers, ports, authentication models, project-specific API conventions, and language/framework coding rules. Keep those in the target project's `AGENTS.md`, `CLAUDE.md`, documentation, or separate capability skills.

The package does not install `.rules` or `.claude/rules/`. Rule discovery and command-permission behavior differ by agent and organization, and those files are project-specific. Installing this package does not make an existing rule file cross-platform or guarantee that either agent auto-loads another platform's rules.
