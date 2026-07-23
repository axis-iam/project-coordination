# Project Coordination

`project-coordination` is a repository-local Codex skill for coordinating delivery work across backend, frontend, SDK, and auxiliary components. It is designed to be installed into a project and adapted from the project's detected structure, not installed as a personal global skill.

Project introduction: https://axis-iam.github.io/project-coordination/

## Install With Codex

Use this prompt from a Codex session that can access this cloned repository and the target project:

```text
Install the project-coordination skill from this repository into:

<absolute-target-project-path>

Requirements:

1. Read this repository's README.md, skill/project-coordination/SKILL.md,
   and scripts/install.* before acting.
2. Inspect the target project's Git status, AGENTS.md, docs/, and
   .agents/skills/. Do not modify business code.
3. Preserve existing AGENTS.md and docs/PROJECT_TASKS.md. Do not overwrite an
   existing project-coordination installation unless I explicitly request an update.
4. If I did not provide Architecture and Workflow profile, ask only:
   - Architecture: monorepo | multi-repo
   - Workflow profile: compact | standard | complex
5. Do not ask me for repository paths, build commands, or validation commands.
   Discover those from the target project.
6. Run the installer for the current operating system. Do not manually
   reimplement its file operations.
7. Run the repository's validation after installation and inspect the generated
   project-profile.md.
8. Report created files, preserved files, detected Git roots and components,
   selected workflow profile, and unresolved conflicts.
9. Do not create a Git commit.
```

Provide the two choices in the prompt when they are already known:

```text
Architecture: multi-repo
Workflow profile: standard
```

## Manual Install

Clone this repository, then run one installer command from the clone:

```bash
./scripts/install.sh /path/to/target-project
```

PowerShell is also supported:

```powershell
.\scripts\install.ps1 -TargetPath C:\path\to\target-project
```

The installer asks only for:

1. `monorepo` or `multi-repo`
2. `compact`, `standard`, or `complex`

It then discovers Git roots and component manifests, installs the skill at `.agents/skills/project-coordination/`, creates `docs/PROJECT_TASKS.md` only when it does not already exist, and creates a root `AGENTS.md` only when one is absent. It never overwrites existing project instructions or task indexes.

## Update

Update an existing installation while preserving its selected architecture, workflow profile, root `AGENTS.md`, and task index:

```bash
./scripts/install.sh /path/to/target-project --update
```

```powershell
.\scripts\install.ps1 -TargetPath C:\path\to\target-project -Update
```

An update refreshes managed skill files and regenerates the detected project profile. It does not delete stale files from an older version, and it preserves the target project's root `AGENTS.md` and task index. Keep product-specific instructions and capability skills outside the installed `project-coordination` directory.

## Workflow Profiles

| Profile | Use for | Default behavior |
| --- | --- | --- |
| `compact` | One small repository or a small backend and frontend | Work directly for local changes; use task documents only for cross-component, risky, or explicitly tracked work. |
| `standard` | Backend and frontend that need contract sequencing | Create task records for cross-component changes and keep the API contract owner explicit. |
| `complex` | Multiple repositories, SDKs, concurrent sessions, or external gates | Require dependency gates, per-repository worktrees, execution records, and acceptance evidence. |

## Session Model

Tracked `standard` and `complex` work uses a three-stage lifecycle:

```text
Coordination session -> fresh execution session -> coordination acceptance session
```

The coordination session creates the canonical task document, dependency gates, worktree policy, validation harness, and handoff prompt. The fresh execution session implements only that task, runs its harness, and appends an execution record without committing. The coordination session then independently reviews the diff and evidence before accepting; commit authority remains with the user.

`compact` local low-risk work may stay in one session. Once work is tracked, handed off, cross-component, security-sensitive, externally gated, or multi-repository, use the three-stage lifecycle.

## After Installation

Use the skill for questions such as:

```text
Use $project-coordination to identify the current workstream.
Use $project-coordination to prepare a backend and frontend handoff.
Use $project-coordination to accept this cross-repository task.
```

The generated project profile is at:

```text
.agents/skills/project-coordination/references/project-profile.md
```

Refresh it after repositories or component manifests change:

```bash
.agents/skills/project-coordination/scripts/refresh-project-profile.sh .
```

## What This Repository Includes

The main skill absorbs reusable coordination behavior: workstream triage, task dispatch, dependency gates, validation evidence, and release readiness. Its assets include task, decision, execution-record, root, backend, and frontend `AGENTS.md` templates.

It deliberately does not include product-specific skills such as a local stack launcher, domain onboarding, service ports, authentication models, or product boundaries. Keep those in the installed project as separate capability skills and project documentation.

Markdown guidance files are not Codex command rules. This repository does not install a default `.rules` policy because command approval policy is organization-specific. Use real `.rules` files only for executable-command policy; keep coordination and coding guidance in `AGENTS.md`, the skill, and project docs.
