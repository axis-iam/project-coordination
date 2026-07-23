#!/usr/bin/env bash
set -euo pipefail

target=""
architecture=""
workflow=""
update="false"

usage() {
  printf '%s\n' "Usage: install.sh [target] [--architecture monorepo|multi-repo] [--workflow compact|standard|complex] [--update]"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --architecture)
      architecture="${2:-}"
      shift 2
      ;;
    --workflow)
      workflow="${2:-}"
      shift 2
      ;;
    --update)
      update="true"
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      if [ -n "$target" ]; then
        usage >&2
        exit 1
      fi
      target="$1"
      shift
      ;;
  esac
done

target="${target:-$PWD}"
target="$(cd "$target" && pwd)"
repo_dir="$(cd "$(dirname "$0")/.." && pwd)"
skill_names=(project-coordination workstream-triage validation-harness api-contract-sync code-quality-audit)
codex_skills="$target/.agents/skills"
claude_skills="$target/.claude/skills"
coordination_destination="$codex_skills/project-coordination"

for skill_name in "${skill_names[@]}"; do
  source_skill="$repo_dir/skill/$skill_name"
  if [ ! -f "$source_skill/SKILL.md" ] || [ ! -f "$source_skill/.project-coordination-managed" ]; then
    printf '%s\n' "Managed skill source is incomplete: $source_skill" >&2
    exit 1
  fi
done

if [ -e "$coordination_destination" ] && [ "$update" != "true" ]; then
  printf '%s\n' "Existing package found. Re-run with --update: $coordination_destination" >&2
  exit 1
fi
if [ ! -e "$coordination_destination" ] && [ "$update" = "true" ]; then
  printf '%s\n' "Cannot update because the package is not installed: $coordination_destination" >&2
  exit 1
fi

for skill_name in "${skill_names[@]}"; do
  for skills_root in "$codex_skills" "$claude_skills"; do
    destination="$skills_root/$skill_name"
    if [ ! -e "$destination" ]; then
      continue
    fi
    if [ ! -d "$destination" ]; then
      printf '%s\n' "Skill destination is not a directory: $destination" >&2
      exit 1
    fi
    if [ "$destination" = "$coordination_destination" ] && \
      [ "$update" = "true" ] && \
      [ -f "$destination/references/project-profile.md" ]; then
      continue
    fi
    if [ ! -f "$destination/.project-coordination-managed" ]; then
      printf '%s\n' "Refusing to overwrite an unmanaged skill: $destination" >&2
      exit 1
    fi
  done
done

profile="$target/docs/PROJECT_PROFILE.md"
legacy_profile="$coordination_destination/references/project-profile.md"
profile_source=""
if [ -f "$profile" ]; then
  profile_source="$profile"
elif [ "$update" = "true" ] && [ -f "$legacy_profile" ]; then
  profile_source="$legacy_profile"
fi
if [ -n "$profile_source" ]; then
  if [ -z "$architecture" ]; then
    architecture="$(sed -n 's/^- Architecture: //p' "$profile_source" | head -n 1)"
  fi
  if [ -z "$workflow" ]; then
    workflow="$(sed -n 's/^- Workflow profile: //p' "$profile_source" | head -n 1)"
  fi
fi

if [ -z "$architecture" ]; then
  printf '%s' 'Architecture [monorepo/multi-repo]: '
  read -r architecture
fi
if [ -z "$workflow" ]; then
  printf '%s' 'Workflow profile [compact/standard/complex]: '
  read -r workflow
fi

case "$architecture" in
  monorepo|multi-repo) ;;
  *) printf '%s\n' "Architecture must be monorepo or multi-repo." >&2; exit 1 ;;
esac
case "$workflow" in
  compact|standard|complex) ;;
  *) printf '%s\n' "Workflow profile must be compact, standard, or complex." >&2; exit 1 ;;
esac

staging_root="$(mktemp -d "$target/.project-coordination-install.XXXXXX")"
cleanup_staging() {
  if [ -d "$staging_root" ]; then
    find "$staging_root" -depth -delete
  fi
}
trap cleanup_staging EXIT

# Stage complete directories before replacing any managed installation. This
# removes files retired by a package update without touching project-owned files.
for platform_root in .agents .claude; do
  staged_skills="$staging_root/$platform_root/skills"
  mkdir -p "$staged_skills"
  for skill_name in "${skill_names[@]}"; do
    cp -R "$repo_dir/skill/$skill_name" "$staged_skills/$skill_name"
  done
done

for platform_root in .agents .claude; do
  skills_root="$target/$platform_root/skills"
  mkdir -p "$skills_root"
  for skill_name in "${skill_names[@]}"; do
    destination="$skills_root/$skill_name"
    staged_destination="$staging_root/$platform_root/skills/$skill_name"
    if [ -e "$destination" ]; then
      find "$destination" -depth -delete
    fi
    mv "$staged_destination" "$destination"
  done
done

mkdir -p "$target/docs"
index="$target/docs/PROJECT_TASKS.md"
if [ ! -e "$index" ]; then
  cp "$coordination_destination/assets/PROJECT_TASKS.md" "$index"
  printf '%s\n' "Created task index: $index"
else
  printf '%s\n' "Preserved existing task index: $index"
fi

for instruction_name in AGENTS.md CLAUDE.md; do
  instruction_path="$target/$instruction_name"
  if [ ! -e "$instruction_path" ]; then
    cp "$coordination_destination/assets/AGENTS.root.md" "$instruction_path"
    printf '%s\n' "Created project instructions: $instruction_path"
  else
    printf '%s\n' "Preserved existing project instructions: $instruction_path"
  fi
done

chmod +x \
  "$codex_skills/project-coordination/scripts/refresh-project-profile.sh" \
  "$claude_skills/project-coordination/scripts/refresh-project-profile.sh" \
  "$codex_skills/code-quality-audit/scripts/scan_code_quality.py" \
  "$claude_skills/code-quality-audit/scripts/scan_code_quality.py"
"$codex_skills/project-coordination/scripts/refresh-project-profile.sh" \
  "$target" --architecture "$architecture" --workflow "$workflow"

action="Installed"
if [ "$update" = "true" ]; then
  action="Updated"
fi
printf '%s\n' "$action Codex skills at $codex_skills"
printf '%s\n' "$action Claude Code skills at $claude_skills"
printf '%s\n' "Next: review $target/AGENTS.md and $target/CLAUDE.md."
