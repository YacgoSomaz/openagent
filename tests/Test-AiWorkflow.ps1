$ErrorActionPreference = 'Stop'

# User journey: a repository maintainer can validate the AI delivery-loop
# configuration before it is merged or enabled in GitHub.
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$validator = Join-Path $repositoryRoot 'scripts\Test-AiWorkflow.ps1'

if (-not (Test-Path -LiteralPath $validator)) {
    throw "Missing workflow validator: $validator"
}

& $validator -RepositoryRoot $repositoryRoot

if ($LASTEXITCODE -ne 0) {
    throw "AI workflow validation failed with exit code $LASTEXITCODE"
}
