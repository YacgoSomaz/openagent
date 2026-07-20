Implemented behavior: added a new maintainer-focused runbook in [MAINTAINER-RUNBOOK.md](/home/runner/work/openagent/openagent/MAINTAINER-RUNBOOK.md) covering label bootstrap, Tech Lead dispatch, Developer handoff, Reviewer output, the explicit merge gate, and the required local validation command with its expected success output. I also updated [scripts/Test-AiWorkflow.ps1](/home/runner/work/openagent/openagent/scripts/Test-AiWorkflow.ps1) so the repository contract now enforces the presence and required content of that runbook.

Files changed: [MAINTAINER-RUNBOOK.md](/home/runner/work/openagent/openagent/MAINTAINER-RUNBOOK.md), [scripts/Test-AiWorkflow.ps1](/home/runner/work/openagent/openagent/scripts/Test-AiWorkflow.ps1)

Checks run with results:
- `pwsh -NoProfile -File tests/Test-AiWorkflow.ps1` -> passed
- Output: `AI delivery-loop contract passed.`

Remaining risks or `needs-human` conditions: no `needs-human` condition identified. Residual risk is limited to future documentation drift if workflow behavior changes without updating the runbook and the contract test together.