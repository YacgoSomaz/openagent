Implemented a contributor-facing local validation note in [README.md](/home/runner/work/openagent/openagent/README.md) with the exact command `pwsh -NoProfile -File tests/Test-AiWorkflow.ps1` and the expected success output `AI delivery-loop contract passed.`. I also tightened the existing contract validator in [scripts/Test-AiWorkflow.ps1](/home/runner/work/openagent/openagent/scripts/Test-AiWorkflow.ps1) so the documentation requirement is enforced by test.

Files changed: [README.md](/home/runner/work/openagent/openagent/README.md), [scripts/Test-AiWorkflow.ps1](/home/runner/work/openagent/openagent/scripts/Test-AiWorkflow.ps1)

Checks run:
- `pwsh -NoProfile -File tests/Test-AiWorkflow.ps1` -> passed
- Result: `AI delivery-loop contract passed.`

Remaining risks / `needs-human` conditions:
- No `needs-human` condition identified.
- Residual risk is limited to future documentation drift if the validation command or success text changes without updating the README and contract test together.