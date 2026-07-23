#!/usr/bin/env bash
set -euo pipefail

target="${1:-.}"
target="$(cd "$target" && pwd)"
skill="$target/.agents/skills/project-coordination"

for path in "$skill/SKILL.md" "$skill/references/project-profile.md" "$skill/scripts/refresh-project-profile.sh" "$target/docs/PROJECT_TASKS.md"; do
  if [ ! -f "$path" ]; then
    printf '%s\n' "Missing required installation file: $path" >&2
    exit 1
  fi
done

printf '%s\n' "Valid installation: $target"
