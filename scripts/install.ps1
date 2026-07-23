[CmdletBinding()]
param(
    [string]$TargetPath = (Get-Location).Path,
    [ValidateSet('monorepo', 'multi-repo')]
    [string]$Architecture,
    [ValidateSet('compact', 'standard', 'complex')]
    [string]$Workflow,
    [switch]$Update
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$target = (Resolve-Path $TargetPath).Path
$skillNames = @('project-coordination', 'workstream-triage', 'validation-harness', 'api-contract-sync', 'code-quality-audit')
$codexSkills = Join-Path $target '.agents/skills'
$claudeSkills = Join-Path $target '.claude/skills'
$coordinationDestination = Join-Path $codexSkills 'project-coordination'

foreach ($skillName in $skillNames) {
    $sourceSkill = Join-Path $repoRoot "skill/$skillName"
    if (-not (Test-Path (Join-Path $sourceSkill 'SKILL.md')) -or
        -not (Test-Path (Join-Path $sourceSkill '.project-coordination-managed'))) {
        throw "Managed skill source is incomplete: $sourceSkill"
    }
}

$isInstalled = Test-Path $coordinationDestination
if ($isInstalled -and -not $Update) {
    throw "Existing package found. Re-run with -Update: $coordinationDestination"
}
if (-not $isInstalled -and $Update) {
    throw "Cannot update because the package is not installed: $coordinationDestination"
}

foreach ($skillName in $skillNames) {
    foreach ($skillsRoot in @($codexSkills, $claudeSkills)) {
        $destination = Join-Path $skillsRoot $skillName
        if (-not (Test-Path $destination)) { continue }
        if (-not (Test-Path $destination -PathType Container)) {
            throw "Skill destination is not a directory: $destination"
        }
        $legacyCoordination = $Update -and
            $destination -eq $coordinationDestination -and
            (Test-Path (Join-Path $destination 'references/project-profile.md'))
        if (-not $legacyCoordination -and
            -not (Test-Path (Join-Path $destination '.project-coordination-managed'))) {
            throw "Refusing to overwrite an unmanaged skill: $destination"
        }
    }
}

$profile = Join-Path $target 'docs/PROJECT_PROFILE.md'
$legacyProfile = Join-Path $coordinationDestination 'references/project-profile.md'
$profileSource = $null
if (Test-Path $profile) {
    $profileSource = $profile
} elseif ($Update -and (Test-Path $legacyProfile)) {
    $profileSource = $legacyProfile
}
if ($profileSource) {
    $existingContent = Get-Content $profileSource
    if (-not $Architecture) {
        $architectureLine = $existingContent | Where-Object { $_ -match '^- Architecture: (.+)$' } | Select-Object -First 1
        if ($architectureLine -match '^- Architecture: (.+)$') { $Architecture = $Matches[1] }
    }
    if (-not $Workflow) {
        $workflowLine = $existingContent | Where-Object { $_ -match '^- Workflow profile: (.+)$' } | Select-Object -First 1
        if ($workflowLine -match '^- Workflow profile: (.+)$') { $Workflow = $Matches[1] }
    }
}
if (-not $Architecture) {
    $Architecture = Read-Host 'Architecture [monorepo/multi-repo]'
}
if (-not $Workflow) {
    $Workflow = Read-Host 'Workflow profile [compact/standard/complex]'
}
if ($Architecture -notin @('monorepo', 'multi-repo')) {
    throw 'Architecture must be monorepo or multi-repo.'
}
if ($Workflow -notin @('compact', 'standard', 'complex')) {
    throw 'Workflow profile must be compact, standard, or complex.'
}

$stagingRoot = Join-Path $target ('.project-coordination-install-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $stagingRoot | Out-Null
try {
    # Stage complete directories before replacing any managed installation. This
    # removes files retired by a package update without touching project-owned files.
    foreach ($platformName in @('.agents', '.claude')) {
        $stagedSkills = Join-Path $stagingRoot "$platformName/skills"
        New-Item -ItemType Directory -Force -Path $stagedSkills | Out-Null
        foreach ($skillName in $skillNames) {
            $sourceSkill = Join-Path $repoRoot "skill/$skillName"
            $stagedDestination = Join-Path $stagedSkills $skillName
            Copy-Item -Recurse -Force -LiteralPath $sourceSkill -Destination $stagedDestination
        }
    }

    foreach ($platform in @(
        @{ Name = '.agents'; SkillsRoot = $codexSkills },
        @{ Name = '.claude'; SkillsRoot = $claudeSkills }
    )) {
        New-Item -ItemType Directory -Force -Path $platform.SkillsRoot | Out-Null
        foreach ($skillName in $skillNames) {
            $destination = Join-Path $platform.SkillsRoot $skillName
            $stagedDestination = Join-Path (Join-Path $stagingRoot "$($platform.Name)/skills") $skillName
            if (Test-Path $destination) {
                Remove-Item -Recurse -Force -LiteralPath $destination
            }
            Move-Item -LiteralPath $stagedDestination -Destination $destination
        }
    }
} finally {
    if (Test-Path $stagingRoot) {
        Remove-Item -Recurse -Force -LiteralPath $stagingRoot
    }
}

$docs = Join-Path $target 'docs'
New-Item -ItemType Directory -Force -Path $docs | Out-Null
$index = Join-Path $docs 'PROJECT_TASKS.md'
if (-not (Test-Path $index)) {
    Copy-Item (Join-Path $coordinationDestination 'assets/PROJECT_TASKS.md') $index
    Write-Output "Created task index: $index"
} else {
    Write-Output "Preserved existing task index: $index"
}

foreach ($instructionName in @('AGENTS.md', 'CLAUDE.md')) {
    $instructionPath = Join-Path $target $instructionName
    if (-not (Test-Path $instructionPath)) {
        Copy-Item (Join-Path $coordinationDestination 'assets/AGENTS.root.md') $instructionPath
        Write-Output "Created project instructions: $instructionPath"
    } else {
        Write-Output "Preserved existing project instructions: $instructionPath"
    }
}

$refreshScript = Join-Path $coordinationDestination 'scripts/refresh-project-profile.ps1'
& $refreshScript -TargetPath $target -Architecture $Architecture -Workflow $Workflow

$action = if ($Update) { 'Updated' } else { 'Installed' }
Write-Output "$action Codex skills at $codexSkills"
Write-Output "$action Claude Code skills at $claudeSkills"
Write-Output "Next: review $(Join-Path $target 'AGENTS.md') and $(Join-Path $target 'CLAUDE.md')."
