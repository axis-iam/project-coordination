# <Task Title>

- Date: YYYY-MM-DD
- Owner: <backend|frontend|sdk|ops|coordination>
- Status: Planned | Dispatched | Implementing | Ready for Acceptance | Accepted | Blocked
- Implementation State: DESIGN_ONLY
- Validation Evidence: UNVERIFIED
- Priority: P0 | P1 | P2
- Task Type: feature | hotfix | contract | migration | security | smoke | docs
- Tracking Plan:
- Project Default Profile: compact | standard | complex
- Effective Task Profile: compact | standard | complex
- Selection Reason / Escalation Trigger:

## Session Policy

- Coordination session: Creates the task, resolves dependencies, and generates the handoff prompt.
- Execution session: A new session is required for this tracked task. It reads this document first, works only in declared scope, appends the execution record, and does not commit.
- Acceptance session: The coordination session independently reviews scope, diff, and validation evidence after execution.
- Commit authority: User authorization required.

## Background

## User-Visible Behavior

## Goals

## Non-Goals / Stub Boundary

## Source Of Truth

- Decision / plan / contract:

## Dependency Gates

## Worktree Policy

- Writable repository:
- Source checkout:
- Worktree path:
- Base ref:
- Task branch:
- Cleanup owner:

### Starting Snapshot

- HEAD:
- Branch:
- `git status --short`:
- `git diff --name-only`:
- `git diff --stat`:

Add one entry for every writable Git root. State `Not applicable` for a single local change with no separate worktree requirement.

## User-Provided Inputs / External Access Gate

Write `No external inputs required` when none are needed.

## Implementation Plan

## Validation Harness

- Before-change failure or expected behavior:
- Command or user flow:
- Expected signal:
- Negative cases:

## Quality Audit

- Required: yes | no
- Skill / profile:
- Changed-since revision:
- Finding disposition required in execution record: yes | no

## Acceptance Criteria

## Key Files

## Formatter / Generator Record

- Command:
- Timestamp:
- Before snapshot:
- After snapshot:
- Affected file count:
- Scope explanation:

## Execution Records

Append entries using `assets/execution-record-template.md`. Do not rewrite an earlier session's record.

## Acceptance Records

The coordination session appends an entry using `assets/acceptance-record-template.md`. The execution session must not fill this section for its own work.
