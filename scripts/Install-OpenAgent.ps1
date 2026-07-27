[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$InstallRoot = $env:USERPROFILE,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($InstallRoot)) {
    throw 'InstallRoot must not be empty.'
}

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$sourceSkill = Join-Path $repositoryRoot '.agents\skills\openagent-director'
$sourceAgents = Join-Path $repositoryRoot '.codex\agents'
$resolvedRoot = [System.IO.Path]::GetFullPath($InstallRoot)
$skillParent = Join-Path $resolvedRoot '.agents\skills'
$agentParent = Join-Path $resolvedRoot '.codex\agents'
$skillDestination = Join-Path $skillParent 'openagent-director'

if (-not (Test-Path -LiteralPath $sourceSkill -PathType Container)) {
    throw "OpenAgent skill source is missing: $sourceSkill"
}

if (-not (Test-Path -LiteralPath $sourceAgents -PathType Container)) {
    throw "OpenAgent agent source is missing: $sourceAgents"
}

function Install-Directory {
    param(
        [string]$Source,
        [string]$Destination,
        [string]$Label
    )

    if ((Test-Path -LiteralPath $Destination) -and -not $Force) {
        throw "$Label already exists at $Destination. Re-run with -Force to update it."
    }

    if ($PSCmdlet.ShouldProcess($Destination, "Install $Label")) {
        New-Item -ItemType Directory -Force -Path $Destination | Out-Null
        Get-ChildItem -LiteralPath $Source -Force |
            Copy-Item -Destination $Destination -Recurse -Force
    }
}

Install-Directory -Source $sourceSkill -Destination $skillDestination -Label 'OpenAgent skill'

New-Item -ItemType Directory -Force -Path $agentParent -WhatIf:$WhatIfPreference | Out-Null
foreach ($agentFile in Get-ChildItem -LiteralPath $sourceAgents -Filter 'openagent-*.toml' -File) {
    $destination = Join-Path $agentParent $agentFile.Name
    if ((Test-Path -LiteralPath $destination) -and -not $Force) {
        throw "OpenAgent agent already exists at $destination. Re-run with -Force to update it."
    }

    if ($PSCmdlet.ShouldProcess($destination, 'Install OpenAgent custom agent')) {
        Copy-Item -LiteralPath $agentFile.FullName -Destination $destination -Force
    }
}

if ($WhatIfPreference) {
    Write-Host "OpenAgent installation preview completed for $resolvedRoot"
} else {
    Write-Host "OpenAgent installed under $resolvedRoot"
    Write-Host 'Restart Codex, then invoke: $openagent-director <your feature request>'
}
