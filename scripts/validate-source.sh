#!/usr/bin/env bash
set -euo pipefail

repository_root="$(cd "$(dirname "$0")/.." && pwd)"
coordination_skill="$repository_root/skill/project-coordination"
triage_skill="$repository_root/skill/workstream-triage"
validation_skill="$repository_root/skill/validation-harness"
contract_skill="$repository_root/skill/api-contract-sync"
audit_skill="$repository_root/skill/code-quality-audit"

required_files=(
  "$coordination_skill/SKILL.md"
  "$coordination_skill/.project-coordination-managed"
  "$coordination_skill/agents/openai.yaml"
  "$coordination_skill/references/contract-sequencing.md"
  "$coordination_skill/references/dependency-gates.md"
  "$coordination_skill/references/document-taxonomy.md"
  "$coordination_skill/references/planning.md"
  "$coordination_skill/references/release-readiness.md"
  "$coordination_skill/references/task-dispatch.md"
  "$coordination_skill/references/session-lifecycle.md"
  "$coordination_skill/references/task-profile-selection.md"
  "$coordination_skill/references/validation-and-acceptance.md"
  "$coordination_skill/references/workflow-profiles.md"
  "$coordination_skill/references/worktree-policy.md"
  "$coordination_skill/assets/AGENTS.root.md"
  "$coordination_skill/assets/AGENTS.backend.md"
  "$coordination_skill/assets/AGENTS.frontend.md"
  "$coordination_skill/assets/PROJECT_TASKS.md"
  "$coordination_skill/assets/decision-template.md"
  "$coordination_skill/assets/plan-template.md"
  "$coordination_skill/assets/task-template.md"
  "$coordination_skill/assets/execution-record-template.md"
  "$coordination_skill/assets/acceptance-record-template.md"
  "$coordination_skill/scripts/refresh-project-profile.sh"
  "$coordination_skill/scripts/refresh-project-profile.ps1"
  "$triage_skill/SKILL.md"
  "$triage_skill/.project-coordination-managed"
  "$triage_skill/agents/openai.yaml"
  "$validation_skill/SKILL.md"
  "$validation_skill/.project-coordination-managed"
  "$validation_skill/agents/openai.yaml"
  "$validation_skill/references/runtime-smoke.md"
  "$contract_skill/SKILL.md"
  "$contract_skill/.project-coordination-managed"
  "$contract_skill/agents/openai.yaml"
  "$contract_skill/references/contract-checklist.md"
  "$audit_skill/SKILL.md"
  "$audit_skill/.project-coordination-managed"
  "$audit_skill/agents/openai.yaml"
  "$audit_skill/references/defensive-fallback-discipline.md"
  "$audit_skill/scripts/scan_code_quality.py"
  "$audit_skill/tests/test_scan_code_quality.py"
)

for file in "${required_files[@]}"; do
  test -f "$file" || { printf '%s\n' "Missing required source file: $file" >&2; exit 1; }
done

for skill_name in project-coordination workstream-triage validation-harness api-contract-sync code-quality-audit; do
  skill_directory="$repository_root/skill/$skill_name"
  grep -q "^name: $skill_name$" "$skill_directory/SKILL.md"
  grep -q '^description:' "$skill_directory/SKILL.md"
  grep -q 'allow_implicit_invocation: true' "$skill_directory/agents/openai.yaml"
done

if rg -q 'references/triage\.md|references/project-profile\.md' "$coordination_skill"; then
  printf '%s\n' 'Coordination skill contains a stale triage or project-profile reference.' >&2
  exit 1
fi

if rg -qi 'iam-java|axis-iam|iam-server|iam-portal|iam-admin|31443|32443|25432|26379' \
  "$repository_root/skill"; then
  printf '%s\n' 'Reusable skills contain IAM-specific content.' >&2
  exit 1
fi
if rg -q 'TODO|\[TODO' "$validation_skill" "$contract_skill"; then
  printf '%s\n' 'Reusable validation or contract skills contain initializer placeholders.' >&2
  exit 1
fi

bash -n "$repository_root/scripts/install.sh"
bash -n "$repository_root/scripts/validate-install.sh"
bash -n "$coordination_skill/scripts/refresh-project-profile.sh"
python3 -c 'from pathlib import Path; import sys; compile(Path(sys.argv[1]).read_text(encoding="utf-8"), sys.argv[1], "exec")' \
  "$audit_skill/scripts/scan_code_quality.py"
if command -v node >/dev/null 2>&1; then
  node --check "$repository_root/site/script.js"
fi

printf '%s\n' 'Source validation passed.'
