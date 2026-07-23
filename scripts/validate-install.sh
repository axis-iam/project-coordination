#!/usr/bin/env bash
set -euo pipefail

target="${1:-.}"
target="$(cd "$target" && pwd)"

for platform_root in .agents .claude; do
  skills_root="$target/$platform_root/skills"
  for skill_name in project-coordination workstream-triage validation-harness api-contract-sync code-quality-audit; do
    skill="$skills_root/$skill_name"
    for path in "$skill/SKILL.md" "$skill/.project-coordination-managed"; do
      if [ ! -f "$path" ]; then
        printf '%s\n' "Missing required installation file: $path" >&2
        exit 1
      fi
    done
  done

  required_payload=(
    "$skills_root/project-coordination/assets/plan-template.md"
    "$skills_root/project-coordination/assets/acceptance-record-template.md"
    "$skills_root/project-coordination/scripts/refresh-project-profile.sh"
    "$skills_root/project-coordination/references/task-profile-selection.md"
    "$skills_root/validation-harness/references/runtime-smoke.md"
    "$skills_root/api-contract-sync/references/contract-checklist.md"
    "$skills_root/code-quality-audit/scripts/scan_code_quality.py"
  )
  for path in "${required_payload[@]}"; do
    if [ ! -f "$path" ]; then
      printf '%s\n' "Missing required installation file: $path" >&2
      exit 1
    fi
  done
done

required_files=(
  "$target/docs/PROJECT_PROFILE.md"
  "$target/docs/PROJECT_TASKS.md"
  "$target/AGENTS.md"
  "$target/CLAUDE.md"
)
for path in "${required_files[@]}"; do
  if [ ! -f "$path" ]; then
    printf '%s\n' "Missing required installation file: $path" >&2
    exit 1
  fi
done

printf '%s\n' "Valid Codex and Claude Code installation: $target"
