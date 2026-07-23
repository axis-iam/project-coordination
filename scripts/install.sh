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
source_skill="$repo_dir/skill/project-coordination"
destination="$target/.agents/skills/project-coordination"

if [ ! -f "$source_skill/SKILL.md" ]; then
  printf '%s\n' "Skill source is missing: $source_skill" >&2
  exit 1
fi
if [ -e "$destination" ] && [ "$update" != "true" ]; then
  printf '%s\n' "Existing skill found. Re-run with --update: $destination" >&2
  exit 1
fi
if [ ! -e "$destination" ] && [ "$update" = "true" ]; then
  printf '%s\n' "Cannot update because the skill is not installed: $destination" >&2
  exit 1
fi

existing_profile="$destination/references/project-profile.md"
if [ "$update" = "true" ] && [ -f "$existing_profile" ]; then
  if [ -z "$architecture" ]; then
    architecture="$(sed -n 's/^- Architecture: //p' "$existing_profile" | head -n 1)"
  fi
  if [ -z "$workflow" ]; then
    workflow="$(sed -n 's/^- Workflow profile: //p' "$existing_profile" | head -n 1)"
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

mkdir -p "$target/.agents/skills"
if [ "$update" = "true" ]; then
  cp -R "$source_skill/." "$destination/"
else
  cp -R "$source_skill" "$destination"
fi

mkdir -p "$target/docs"
index="$target/docs/PROJECT_TASKS.md"
if [ ! -e "$index" ]; then
  cp "$destination/assets/PROJECT_TASKS.md" "$index"
  printf '%s\n' "Created task index: $index"
else
  printf '%s\n' "Preserved existing task index: $index"
fi

root_agents="$target/AGENTS.md"
if [ ! -e "$root_agents" ]; then
  cp "$destination/assets/AGENTS.root.md" "$root_agents"
  printf '%s\n' "Created root instructions: $root_agents"
else
  printf '%s\n' "Preserved existing root instructions: $root_agents"
fi

chmod +x "$destination/scripts/refresh-project-profile.sh"
"$destination/scripts/refresh-project-profile.sh" "$target" --architecture "$architecture" --workflow "$workflow"

if [ "$update" = "true" ]; then
  printf '%s\n' "Updated project-coordination at $destination"
else
  printf '%s\n' "Installed project-coordination at $destination"
fi
printf '%s\n' "Next: review $root_agents and use \$project-coordination for cross-component work."
