Implemented behavior: `README.md` now includes a minimal discoverability link to the maintainer operations runbook, and the workflow contract test now asserts that the README keeps linking to `MAINTAINER-RUNBOOK.md`.

Files changed: [README.md](/home/runner/work/openagent/openagent/README.md), [scripts/Test-AiWorkflow.ps1](/home/runner/work/openagent/openagent/scripts/Test-AiWorkflow.ps1)

Checks run:
- `pwsh -NoProfile -File tests/Test-AiWorkflow.ps1` — passed (`AI delivery-loop contract passed.`)

Remaining risks / `needs-human` conditions: none identified. The change is documentation-only and stays within the scoped issue.