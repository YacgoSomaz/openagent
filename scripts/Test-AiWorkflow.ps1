param(
    [Parameter(Mandatory = $true)]
    [string]$RepositoryRoot
)

$ErrorActionPreference = 'Stop'

function Assert-Contains {
    param(
        [string]$Path,
        [string]$Pattern,
        [string]$Description
    )

    $content = Get-Content -Raw -LiteralPath $Path
    if ($content -notmatch $Pattern) {
        throw "$Description is missing from $Path"
    }
}

function Assert-NotContains {
    param(
        [string]$Path,
        [string]$Pattern,
        [string]$Description
    )

    $content = Get-Content -Raw -LiteralPath $Path
    if ($content -match $Pattern) {
        throw "$Description must not appear in $Path"
    }
}

$requiredFiles = @(
    'AGENTS.md',
    '.github/workflows/ai-bootstrap.yml',
    '.github/workflows/ai-tech-lead.yml',
    '.github/workflows/ai-developer.yml',
    '.github/workflows/ai-reviewer.yml',
    '.github/workflows/ai-merge.yml',
    '.github/workflows/ai-workflow-validation.yml',
    '.github/codex/newapi-config.toml',
    '.github/codex/prompts/tech-lead.md',
    '.github/codex/prompts/developer.md',
    '.github/codex/prompts/reviewer.md'
)

foreach ($relativePath in $requiredFiles) {
    $path = Join-Path $RepositoryRoot $relativePath
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Required AI delivery-loop file is missing: $relativePath"
    }
}

$workflowRoot = Join-Path $RepositoryRoot '.github/workflows'
Assert-Contains (Join-Path $workflowRoot 'ai-tech-lead.yml') 'codex exec' 'Tech Lead Codex CLI invocation'
Assert-Contains (Join-Path $workflowRoot 'ai-developer.yml') 'codex exec' 'Developer Codex CLI invocation'
Assert-Contains (Join-Path $workflowRoot 'ai-developer.yml') 'feature/issue-' 'Developer feature-branch convention'
Assert-Contains (Join-Path $workflowRoot 'ai-developer.yml') 'draft: false' 'Automatic Reviewer handoff'
Assert-Contains (Join-Path $workflowRoot 'ai-reviewer.yml') 'codex exec' 'Reviewer Codex CLI invocation'
Assert-Contains (Join-Path $workflowRoot 'ai-reviewer.yml') 'gh label create "ai:reviewed"' 'Reviewer label bootstrap'
foreach ($workflowName in @('ai-tech-lead.yml', 'ai-developer.yml', 'ai-reviewer.yml')) {
    $workflowPath = Join-Path $workflowRoot $workflowName
    Assert-Contains $workflowPath 'Configure New API provider' "New API provider setup for $workflowName"
    Assert-Contains $workflowPath 'NEWAPI_API_KEY' "New API secret reference for $workflowName"
    Assert-Contains $workflowPath '@openai/codex@0.144.6' "Pinned Codex CLI for $workflowName"
    Assert-Contains $workflowPath 'CODEX_HOME:' "Runner-level Codex home for $workflowName"
    Assert-NotContains $workflowPath 'openai-api-key:' "OpenAI-only action authentication for $workflowName"
    Assert-NotContains $workflowPath 'openai/codex-action@v1' "OpenAI-only Codex action wrapper for $workflowName"
    Assert-NotContains $workflowPath 'start-deepseek-responses-adapter' "Removed DeepSeek adapter for $workflowName"
}
Assert-Contains (Join-Path $RepositoryRoot '.github/codex/newapi-config.toml') 'model_provider = "newapi"' 'New API provider selection'
Assert-Contains (Join-Path $RepositoryRoot '.github/codex/newapi-config.toml') 'wire_api = "responses"' 'Responses API protocol'
Assert-Contains (Join-Path $RepositoryRoot '.github/codex/newapi-config.toml') 'env_key = "NEWAPI_API_KEY"' 'New API environment-key isolation'
Assert-Contains (Join-Path $workflowRoot 'ai-merge.yml') 'confirm_merge' 'Explicit merge confirmation gate'
Assert-Contains (Join-Path $workflowRoot 'ai-merge.yml') '--delete-branch' 'Feature-branch cleanup'
Assert-Contains (Join-Path $RepositoryRoot 'AGENTS.md') 'Test-AiWorkflow.ps1' 'Workflow verification command'
Assert-Contains (Join-Path $RepositoryRoot '.github/codex/prompts/tech-lead.md') 'untrusted data' 'Prompt-injection boundary'
Assert-Contains (Join-Path $RepositoryRoot '.github/codex/prompts/tech-lead.md') '--ref "\$GITHUB_REF_NAME"' 'Developer dispatch on the current workflow branch'

Write-Host 'AI delivery-loop contract passed.'
exit 0
