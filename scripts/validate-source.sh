#!/usr/bin/env bash
set -euo pipefail

repository_root="$(cd "$(dirname "$0")/.." && pwd)"
skill_directory="$repository_root/skill/project-coordination"

required_files=(
  "$skill_directory/SKILL.md"
  "$skill_directory/agents/openai.yaml"
  "$skill_directory/references/project-profile.md"
  "$skill_directory/references/triage.md"
  "$skill_directory/references/task-dispatch.md"
  "$skill_directory/references/session-lifecycle.md"
  "$skill_directory/references/validation-and-acceptance.md"
  "$skill_directory/assets/task-template.md"
  "$skill_directory/assets/execution-record-template.md"
  "$skill_directory/scripts/refresh-project-profile.sh"
)

for file in "${required_files[@]}"; do
  test -f "$file" || { printf '%s\n' "Missing required source file: $file" >&2; exit 1; }
done

grep -q '^name: project-coordination$' "$skill_directory/SKILL.md"
grep -q '^description:' "$skill_directory/SKILL.md"
grep -q 'allow_implicit_invocation: true' "$skill_directory/agents/openai.yaml"
bash -n "$repository_root/scripts/install.sh"
bash -n "$repository_root/scripts/validate-install.sh"
bash -n "$skill_directory/scripts/refresh-project-profile.sh"

printf '%s\n' 'Source validation passed.'
