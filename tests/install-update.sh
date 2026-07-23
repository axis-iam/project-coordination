#!/usr/bin/env bash
set -euo pipefail

repository_root="$(cd "$(dirname "$0")/.." && pwd)"
test_root="$(mktemp -d /tmp/project-coordination-test.XXXXXX)"

cleanup() {
  find "$test_root" -depth -delete
}
trap cleanup EXIT

assert_file() {
  test -f "$1" || { printf '%s\n' "Expected file is missing: $1" >&2; exit 1; }
}

assert_not_file() {
  test ! -e "$1" || { printf '%s\n' "Unexpected file exists: $1" >&2; exit 1; }
}

assert_contains() {
  grep -Fq -- "$2" "$1" || { printf '%s\n' "Expected text is missing from $1: $2" >&2; exit 1; }
}

assert_not_contains() {
  if grep -Fq -- "$2" "$1"; then
    printf '%s\n' "Unexpected text in $1: $2" >&2
    exit 1
  fi
}

target="$test_root/target"
mkdir -p "$target/backend" "$target/frontend" "$target/worktree-like"
git -C "$target" init -q
git -C "$target/backend" init -q
printf '%s\n' 'gitdir: ../.git/worktrees/example' > "$target/worktree-like/.git"
printf '%s\n' 'existing Codex instructions' > "$target/AGENTS.md"
printf '%s\n' 'existing Claude instructions' > "$target/CLAUDE.md"
printf '%s\n' 'root backend marker' > "$target/backend/build.gradle"
printf '%s\n' '{"scripts":{"build":"vite build"}}' > "$target/frontend/package.json"

"$repository_root/scripts/install.sh" "$target" --architecture multi-repo --workflow standard
"$repository_root/scripts/validate-install.sh" "$target"

claude_runtime_reference="$target/.claude/skills/validation-harness/references/runtime-smoke.md"
mv "$claude_runtime_reference" "$test_root/runtime-smoke.md"
if "$repository_root/scripts/validate-install.sh" "$target" >/dev/null 2>&1; then
  printf '%s\n' 'Installation validation should fail when a Claude payload file is missing.' >&2
  exit 1
fi
mv "$test_root/runtime-smoke.md" "$claude_runtime_reference"

profile="$target/docs/PROJECT_PROFILE.md"
index="$target/docs/PROJECT_TASKS.md"
codex_coordination="$target/.agents/skills/project-coordination/SKILL.md"
codex_triage="$target/.agents/skills/workstream-triage/SKILL.md"
codex_validation="$target/.agents/skills/validation-harness/SKILL.md"
codex_contract="$target/.agents/skills/api-contract-sync/SKILL.md"
codex_audit="$target/.agents/skills/code-quality-audit/SKILL.md"
claude_coordination="$target/.claude/skills/project-coordination/SKILL.md"
claude_triage="$target/.claude/skills/workstream-triage/SKILL.md"
claude_validation="$target/.claude/skills/validation-harness/SKILL.md"
claude_contract="$target/.claude/skills/api-contract-sync/SKILL.md"
claude_audit="$target/.claude/skills/code-quality-audit/SKILL.md"
for path in \
  "$profile" \
  "$index" \
  "$codex_coordination" \
  "$codex_triage" \
  "$codex_validation" \
  "$codex_contract" \
  "$codex_audit" \
  "$claude_coordination" \
  "$claude_triage" \
  "$claude_validation" \
  "$claude_contract" \
  "$claude_audit"; do
  assert_file "$path"
done
assert_contains "$profile" '- Architecture: multi-repo'
assert_contains "$profile" '- Workflow profile: standard'
assert_contains "$profile" 'AGENTS.md` or `CLAUDE.md'
assert_contains "$profile" '- `backend`'
assert_contains "$profile" '- `worktree-like`'
assert_contains "$profile" '- `frontend/package.json`'
assert_contains "$index" '- Status: inactive'
assert_contains "$index" '- Supporting Blockers: None'
assert_contains "$target/AGENTS.md" 'existing Codex instructions'
assert_contains "$target/CLAUDE.md" 'existing Claude instructions'

printf '%s\n' 'class Quality { void run() { try { call(); } catch (Exception error) { throw error; } } }' > "$target/backend/Quality.java"
scan_output="$test_root/scan.json"
python3 "$target/.agents/skills/code-quality-audit/scripts/scan_code_quality.py" \
  --root "$target/backend" --profile backend-java --format json > "$scan_output"
assert_contains "$scan_output" 'broad-catch-java'

printf '%s\n' 'user task marker' >> "$index"
printf '%s\n' 'stale Codex coordination' >> "$codex_coordination"
printf '%s\n' 'stale Codex validation' >> "$codex_validation"
printf '%s\n' 'stale Codex audit' >> "$codex_audit"
printf '%s\n' 'stale Claude contract' >> "$claude_contract"
printf '%s\n' 'stale Claude triage' >> "$claude_triage"
stale_codex_file="$target/.agents/skills/project-coordination/references/obsolete-managed-file.md"
stale_claude_file="$target/.claude/skills/api-contract-sync/references/obsolete-managed-file.md"
printf '%s\n' 'obsolete Codex managed file' > "$stale_codex_file"
printf '%s\n' 'obsolete Claude managed file' > "$stale_claude_file"

if "$repository_root/scripts/install.sh" "$target" --architecture multi-repo --workflow standard; then
  printf '%s\n' 'A second install without --update should fail.' >&2
  exit 1
fi

"$repository_root/scripts/install.sh" "$target" --update
"$repository_root/scripts/validate-install.sh" "$target"
assert_contains "$index" 'user task marker'
assert_contains "$target/AGENTS.md" 'existing Codex instructions'
assert_contains "$target/CLAUDE.md" 'existing Claude instructions'
assert_not_contains "$codex_coordination" 'stale Codex coordination'
assert_not_contains "$codex_validation" 'stale Codex validation'
assert_not_contains "$codex_audit" 'stale Codex audit'
assert_not_contains "$claude_contract" 'stale Claude contract'
assert_not_contains "$claude_triage" 'stale Claude triage'
assert_not_file "$stale_codex_file"
assert_not_file "$stale_claude_file"
assert_contains "$profile" '- Architecture: multi-repo'
assert_contains "$profile" '- Workflow profile: standard'

non_git_parent="$test_root/git-parent"
non_git_child="$non_git_parent/plain-child"
mkdir -p "$non_git_child"
git -C "$non_git_parent" init -q
"$repository_root/scripts/install.sh" "$non_git_child" --architecture monorepo --workflow compact
plain_profile="$non_git_child/docs/PROJECT_PROFILE.md"
assert_contains "$plain_profile" '- No Git root detected.'
assert_contains "$non_git_child/AGENTS.md" 'workstream-triage'
assert_contains "$non_git_child/CLAUDE.md" 'workstream-triage'
assert_file "$non_git_child/.claude/skills/workstream-triage/SKILL.md"
assert_file "$non_git_child/.agents/skills/validation-harness/references/runtime-smoke.md"
assert_file "$non_git_child/.claude/skills/api-contract-sync/references/contract-checklist.md"

conflict_target="$test_root/conflict-target"
mkdir -p "$conflict_target/.claude/skills/workstream-triage"
printf '%s\n' 'existing Claude triage skill' > "$conflict_target/.claude/skills/workstream-triage/SKILL.md"
if "$repository_root/scripts/install.sh" "$conflict_target" --architecture monorepo --workflow compact; then
  printf '%s\n' 'Install should fail before changing a target with a conflicting Claude skill.' >&2
  exit 1
fi
if [ -e "$conflict_target/.agents/skills/project-coordination" ]; then
  printf '%s\n' 'Conflict preflight created a partial Codex installation.' >&2
  exit 1
fi
assert_contains "$conflict_target/.claude/skills/workstream-triage/SKILL.md" 'existing Claude triage skill'

unmanaged_coordination="$test_root/unmanaged-coordination"
mkdir -p "$unmanaged_coordination/.agents/skills/project-coordination"
printf '%s\n' 'unmanaged coordination skill' \
  > "$unmanaged_coordination/.agents/skills/project-coordination/SKILL.md"
if "$repository_root/scripts/install.sh" "$unmanaged_coordination" --update; then
  printf '%s\n' 'Update should refuse an unmanaged coordination skill that is not a legacy installation.' >&2
  exit 1
fi
assert_contains "$unmanaged_coordination/.agents/skills/project-coordination/SKILL.md" 'unmanaged coordination skill'
assert_not_file "$unmanaged_coordination/docs/PROJECT_PROFILE.md"

legacy_target="$test_root/legacy-target"
mkdir -p "$legacy_target/.agents/skills/project-coordination/references"
printf '%s\n' 'legacy coordination skill' > "$legacy_target/.agents/skills/project-coordination/SKILL.md"
printf '%s\n' '- Architecture: multi-repo' '- Workflow profile: complex' \
  > "$legacy_target/.agents/skills/project-coordination/references/project-profile.md"
"$repository_root/scripts/install.sh" "$legacy_target" --update
"$repository_root/scripts/validate-install.sh" "$legacy_target"
assert_contains "$legacy_target/docs/PROJECT_PROFILE.md" '- Architecture: multi-repo'
assert_contains "$legacy_target/docs/PROJECT_PROFILE.md" '- Workflow profile: complex'
assert_file "$legacy_target/.agents/skills/project-coordination/.project-coordination-managed"
assert_file "$legacy_target/.claude/skills/project-coordination/.project-coordination-managed"
assert_not_file "$legacy_target/.agents/skills/project-coordination/references/project-profile.md"

upgrade_conflict="$test_root/upgrade-conflict"
mkdir -p \
  "$upgrade_conflict/.agents/skills/project-coordination/references" \
  "$upgrade_conflict/.agents/skills/code-quality-audit"
printf '%s\n' 'existing coordination skill' > "$upgrade_conflict/.agents/skills/project-coordination/SKILL.md"
printf '%s\n' '- Architecture: monorepo' '- Workflow profile: compact' \
  > "$upgrade_conflict/.agents/skills/project-coordination/references/project-profile.md"
printf '%s\n' 'unmanaged audit skill' > "$upgrade_conflict/.agents/skills/code-quality-audit/SKILL.md"
if "$repository_root/scripts/install.sh" "$upgrade_conflict" --update; then
  printf '%s\n' 'Update should refuse to overwrite an unmanaged audit skill.' >&2
  exit 1
fi
assert_contains "$upgrade_conflict/.agents/skills/project-coordination/SKILL.md" 'existing coordination skill'
assert_contains "$upgrade_conflict/.agents/skills/code-quality-audit/SKILL.md" 'unmanaged audit skill'

printf '%s\n' 'Codex/Claude install and update integration test passed.'
