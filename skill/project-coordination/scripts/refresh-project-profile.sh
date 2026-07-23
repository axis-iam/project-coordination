#!/usr/bin/env bash
set -euo pipefail

target="."
architecture=""
workflow=""

usage() {
  printf '%s\n' "Usage: refresh-project-profile.sh [target] [--architecture monorepo|multi-repo] [--workflow compact|standard|complex]"
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
    --help|-h)
      usage
      exit 0
      ;;
    *)
      target="$1"
      shift
      ;;
  esac
done

case "$architecture" in
  ""|monorepo|multi-repo) ;;
  *) printf '%s\n' "Invalid architecture: $architecture" >&2; exit 1 ;;
esac
case "$workflow" in
  ""|compact|standard|complex) ;;
  *) printf '%s\n' "Invalid workflow profile: $workflow" >&2; exit 1 ;;
esac

target="$(cd "$target" && pwd)"
profile="$target/docs/PROJECT_PROFILE.md"
mkdir -p "$target/docs"

if [ -z "$architecture" ] && [ -f "$profile" ]; then
  architecture="$(sed -n 's/^- Architecture: //p' "$profile" | head -n 1)"
fi
if [ -z "$workflow" ] && [ -f "$profile" ]; then
  workflow="$(sed -n 's/^- Workflow profile: //p' "$profile" | head -n 1)"
fi

git_roots="$({
  cd "$target"
  if [ -e .git ]; then
    printf '%s\n' '.'
  fi
  find . \
    -mindepth 2 \
    \( -type d \( -name node_modules -o -name .pnpm-store -o -name vendor \) -prune \) -o \
    \( -name .git -type d -print -prune \) -o \
    \( -name .git -type f -print \) 2>/dev/null | sed 's#^\./##; s#/.git$##' | sort -u
} || true)"

manifest_rows="$({
  cd "$target"
  find . \
    \( -type d \( -name .git -o -name node_modules -o -name .pnpm-store -o -name vendor \) -prune \) -o \
    -type f \( -name pom.xml -o -name build.gradle -o -name build.gradle.kts -o -name package.json -o -name go.mod -o -name pyproject.toml -o -name Cargo.toml \) -print 2>/dev/null | sed 's#^\./##' | sort -u
} || true)"

{
  printf '%s\n\n' '# Project Profile'
  printf '%s\n\n' 'This file is generated from the installed project. Refresh it after repository or component-manifest changes.'
  printf '%s\n' "- Project name: $(basename "$target")"
  printf '%s\n' "- Architecture: ${architecture:-detected-later}"
  printf '%s\n\n' "- Workflow profile: ${workflow:-detected-later}"
  printf '%s\n\n' 'Commands, ownership, and product constraints are discovered from local `AGENTS.md` or `CLAUDE.md`, manifests, and project docs when a task needs them. Do not maintain duplicate command lists here.'
  printf '%s\n\n' '## Detected Git Roots'
  if [ -n "$git_roots" ]; then
    while IFS= read -r root; do
      printf '%s\n' "- \`$root\`"
    done <<EOF
$git_roots
EOF
  else
    printf '%s\n' '- No Git root detected.'
  fi
  printf '\n'
  printf '%s\n\n' '## Candidate Component Manifests'
  if [ -n "$manifest_rows" ]; then
    while IFS= read -r manifest; do
      printf '%s\n' "- \`$manifest\`"
    done <<EOF
$manifest_rows
EOF
  else
    printf '%s\n' '- No supported component manifest detected.'
  fi
} > "$profile"

printf '%s\n' "Updated $profile"
