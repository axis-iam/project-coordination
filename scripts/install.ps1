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
$sourceSkill = Join-Path $repoRoot 'skill/project-coordination'
$destination = Join-Path $target '.agents/skills/project-coordination'

if (-not (Test-Path (Join-Path $sourceSkill 'SKILL.md'))) {
    throw "Skill source is missing: $sourceSkill"
}
$isInstalled = Test-Path $destination
if ($isInstalled -and -not $Update) {
    throw "Existing skill found. Re-run with -Update: $destination"
}
if (-not $isInstalled -and $Update) {
    throw "Cannot update because the skill is not installed: $destination"
}

$existingProfile = Join-Path $destination 'references/project-profile.md'
if ($Update -and (Test-Path $existingProfile)) {
    $existingContent = Get-Content $existingProfile
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

New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
if ($Update) {
    Copy-Item -Recurse -Force -Path (Join-Path $sourceSkill '*') -Destination $destination
} else {
    Copy-Item -Recurse -Path $sourceSkill -Destination $destination
}

$docs = Join-Path $target 'docs'
New-Item -ItemType Directory -Force -Path $docs | Out-Null
$index = Join-Path $docs 'PROJECT_TASKS.md'
if (-not (Test-Path $index)) {
    Copy-Item (Join-Path $destination 'assets/PROJECT_TASKS.md') $index
    Write-Output "Created task index: $index"
} else {
    Write-Output "Preserved existing task index: $index"
}

$rootAgents = Join-Path $target 'AGENTS.md'
if (-not (Test-Path $rootAgents)) {
    Copy-Item (Join-Path $destination 'assets/AGENTS.root.md') $rootAgents
    Write-Output "Created root instructions: $rootAgents"
} else {
    Write-Output "Preserved existing root instructions: $rootAgents"
}

$refreshScript = Join-Path $destination 'scripts/refresh-project-profile.ps1'
& $refreshScript -TargetPath $target -Architecture $Architecture -Workflow $Workflow

if ($Update) {
    Write-Output "Updated project-coordination at $destination"
} else {
    Write-Output "Installed project-coordination at $destination"
}
Write-Output "Next: review $rootAgents and use `$project-coordination for cross-component work."
