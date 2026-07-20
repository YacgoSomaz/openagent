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
Assert-Contains (Join-Path $workflowRoot 'ai-tech-lead.yml') 'openai/codex-action@v1' 'Tech Lead Codex action'
Assert-Contains (Join-Path $workflowRoot 'ai-developer.yml') 'openai/codex-action@v1' 'Developer Codex action'
Assert-Contains (Join-Path $workflowRoot 'ai-developer.yml') 'feature/issue-' 'Developer feature-branch convention'
Assert-Contains (Join-Path $workflowRoot 'ai-developer.yml') 'draft: false' 'Automatic Reviewer handoff'
Assert-Contains (Join-Path $workflowRoot 'ai-reviewer.yml') 'openai/codex-action@v1' 'Reviewer Codex action'
foreach ($workflowName in @('ai-tech-lead.yml', 'ai-developer.yml', 'ai-reviewer.yml')) {
    $workflowPath = Join-Path $workflowRoot $workflowName
    Assert-Contains $workflowPath 'Configure DeepSeek provider' "DeepSeek provider setup for $workflowName"
    Assert-Contains $workflowPath 'DEEPSEEK_API_KEY' "DeepSeek secret reference for $workflowName"
    Assert-Contains $workflowPath 'codex-home:' "Runner-level Codex home for $workflowName"
    Assert-NotContains $workflowPath 'openai-api-key:' "OpenAI-only action authentication for $workflowName"
}
Assert-Contains (Join-Path $workflowRoot 'ai-merge.yml') 'confirm_merge' 'Explicit merge confirmation gate'
Assert-Contains (Join-Path $workflowRoot 'ai-merge.yml') '--delete-branch' 'Feature-branch cleanup'
Assert-Contains (Join-Path $RepositoryRoot 'AGENTS.md') 'Test-AiWorkflow.ps1' 'Workflow verification command'
Assert-Contains (Join-Path $RepositoryRoot '.github/codex/prompts/tech-lead.md') 'untrusted data' 'Prompt-injection boundary'

Write-Host 'AI delivery-loop contract passed.'
exit 0
