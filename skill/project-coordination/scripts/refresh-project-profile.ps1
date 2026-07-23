[CmdletBinding()]
param(
    [string]$TargetPath = (Get-Location).Path,
    [string]$Architecture,
    [string]$Workflow
)

$ErrorActionPreference = 'Stop'
$targetProject = (Resolve-Path $TargetPath).Path
$skillDirectory = Split-Path -Parent $PSScriptRoot
$profile = Join-Path $skillDirectory 'references/project-profile.md'

if ((-not $Architecture -or -not $Workflow) -and (Test-Path $profile)) {
    $existingContent = Get-Content $profile
    if (-not $Architecture) {
        $architectureLine = $existingContent | Where-Object { $_ -match '^- Architecture: (.+)$' } | Select-Object -First 1
        if ($architectureLine -match '^- Architecture: (.+)$') { $Architecture = $Matches[1] }
    }
    if (-not $Workflow) {
        $workflowLine = $existingContent | Where-Object { $_ -match '^- Workflow profile: (.+)$' } | Select-Object -First 1
        if ($workflowLine -match '^- Workflow profile: (.+)$') { $Workflow = $Matches[1] }
    }
}

if ($Architecture -notin @('monorepo', 'multi-repo')) {
    throw 'Architecture must be monorepo or multi-repo.'
}
if ($Workflow -notin @('compact', 'standard', 'complex')) {
    throw 'Workflow profile must be compact, standard, or complex.'
}

$excludedPath = '[\\/](\.git|node_modules|vendor|\.pnpm-store)[\\/]'
$gitRoots = @()
if (Test-Path (Join-Path $targetProject '.git')) { $gitRoots += '.' }
$gitRoots += Get-ChildItem -Path $targetProject -Recurse -Force -Filter '.git' -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch '[\\/](node_modules|vendor|\.pnpm-store)[\\/]' } |
    ForEach-Object {
        $markerParent = Split-Path -Parent $_.FullName
        if ([string]::IsNullOrWhiteSpace($markerParent)) { return }
        try {
            $relativeParent = [System.IO.Path]::GetRelativePath($targetProject, $markerParent)
        } catch {
            return
        }
        if ($relativeParent -ne '.') { $relativeParent }
    }
$gitRoots = @($gitRoots | Sort-Object -Unique)

$manifestNames = @('pom.xml', 'build.gradle', 'build.gradle.kts', 'package.json', 'go.mod', 'pyproject.toml', 'Cargo.toml')
$manifests = @(Get-ChildItem -Path $targetProject -File -Recurse -Force -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -in $manifestNames -and $_.FullName -notmatch $excludedPath } |
    ForEach-Object { [System.IO.Path]::GetRelativePath($targetProject, $_.FullName) } |
    Sort-Object -Unique)

$profileLines = @(
    '# Project Profile',
    '',
    'This file is generated from the installed project. Refresh it after repository or component-manifest changes.',
    '',
    "- Project name: $(Split-Path -Leaf $targetProject)",
    "- Architecture: $Architecture",
    "- Workflow profile: $Workflow",
    '',
    'Commands, ownership, and product constraints are discovered from local `AGENTS.md`, manifests, and project docs when a task needs them. Do not maintain duplicate command lists here.',
    '',
    '## Detected Git Roots',
    ''
)
if ($gitRoots.Count -eq 0) {
    $profileLines += '- No Git root detected.'
} else {
    $profileLines += $gitRoots | ForEach-Object { "- ``$_``" }
}
$profileLines += '', '## Candidate Component Manifests', ''
if ($manifests.Count -eq 0) {
    $profileLines += '- No supported component manifest detected.'
} else {
    $profileLines += $manifests | ForEach-Object { "- ``$_``" }
}

Set-Content -Path $profile -Value $profileLines -Encoding UTF8
Write-Output "Updated $profile"
