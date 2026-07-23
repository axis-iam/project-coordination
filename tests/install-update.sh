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
printf '%s\n' 'existing root instructions' > "$target/AGENTS.md"
printf '%s\n' 'root backend marker' > "$target/backend/build.gradle"
printf '%s\n' '{"scripts":{"build":"vite build"}}' > "$target/frontend/package.json"

"$repository_root/scripts/install.sh" "$target" --architecture multi-repo --workflow standard
"$repository_root/scripts/validate-install.sh" "$target"

profile="$target/.agents/skills/project-coordination/references/project-profile.md"
index="$target/docs/PROJECT_TASKS.md"
installed_skill="$target/.agents/skills/project-coordination/SKILL.md"
assert_file "$profile"
assert_file "$index"
assert_contains "$profile" '- Architecture: multi-repo'
assert_contains "$profile" '- Workflow profile: standard'
assert_contains "$profile" '- `backend`'
assert_contains "$profile" '- `worktree-like`'
assert_contains "$profile" '- `frontend/package.json`'
assert_contains "$target/AGENTS.md" 'existing root instructions'

printf '%s\n' 'user task marker' >> "$index"
printf '%s\n' 'stale managed content' >> "$installed_skill"

if "$repository_root/scripts/install.sh" "$target" --architecture multi-repo --workflow standard; then
  printf '%s\n' 'A second install without --update should fail.' >&2
  exit 1
fi

"$repository_root/scripts/install.sh" "$target" --update
"$repository_root/scripts/validate-install.sh" "$target"
assert_contains "$index" 'user task marker'
assert_contains "$target/AGENTS.md" 'existing root instructions'
assert_not_contains "$installed_skill" 'stale managed content'
assert_contains "$profile" '- Architecture: multi-repo'
assert_contains "$profile" '- Workflow profile: standard'

non_git_parent="$test_root/git-parent"
non_git_child="$non_git_parent/plain-child"
mkdir -p "$non_git_child"
git -C "$non_git_parent" init -q
"$repository_root/scripts/install.sh" "$non_git_child" --architecture monorepo --workflow compact
plain_profile="$non_git_child/.agents/skills/project-coordination/references/project-profile.md"
assert_contains "$plain_profile" '- No Git root detected.'
assert_contains "$non_git_child/AGENTS.md" 'Use `$project-coordination`'

printf '%s\n' 'Install/update integration test passed.'
