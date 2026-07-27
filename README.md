# OpenAgent

> An event-driven AI development team built around Codex and GitHub.

OpenAgent explores a practical workflow in which a **Tech Lead AI** and several
specialist **Developer AIs** collaborate through GitHub Issues, pull requests,
comments, and CI events.

## Why

Coding agents are already capable of understanding repositories, implementing
features, running tests, and reviewing changes. The missing piece is a safe,
auditable workflow that turns a feature request into small tasks, reviewable
pull requests, and a controlled merge decision.

OpenAgent focuses on that orchestration layer rather than trying to build a new
foundation model or code editor.

Maintainer operating guidance lives in [MAINTAINER-RUNBOOK.md](MAINTAINER-RUNBOOK.md).

## Target workflow

```mermaid
flowchart LR
  Request["Feature request / parent Issue"] --> Lead["Tech Lead AI"]
  Lead --> Tasks["Linked child Issues"]
  Tasks --> Dev["Developer AI"]
  Dev --> PR["feature/&lt;issue&gt;-&lt;name&gt; branch + PR"]
  PR --> CI["CI and contract checks"]
  PR --> Review["Reviewer AI"]
  CI --> Gate{"All merge gates pass?"}
  Review --> Gate
  Gate -- "No" --> Repair["PR feedback / needs-human"]
  Repair --> Dev
  Gate -- "Yes" --> Merge["Tech Lead merge gate"]
  Merge --> Done["Close linked Issue and delete branch"]
```

All agent-to-agent handoffs are represented in GitHub through Issues, labels,
pull requests, review comments, and workflow events.

## Roles

| Role | Responsibilities |
| --- | --- |
| Tech Lead AI | Analyse requests and repository context, create and sequence Issues, review PRs, decide whether merge conditions are met, and report outcomes. |
| Developer AI | Implement one scoped Issue on an isolated branch, run the required checks, open a clear PR, and address review feedback. |
| Reviewer AI | Inspect the PR diff and test evidence for correctness, regressions, security concerns, and missing coverage. |
| GitHub Actions | Provide the event-driven execution environment, CI signals, and an auditable record of each transition. |

## Design principles

- **GitHub is the shared workspace.** Issues and PRs are the source of truth;
  agent state must not live only in a transient chat session.
- **Small, reviewable changes.** One Issue should normally produce one focused
  branch and pull request.
- **Least privilege.** Use separate bot identities for implementation and
  merge/review decisions, with only the permissions each workflow needs.
- **Tests decide, not prose.** A passing build, relevant tests, linting, and
  branch-protection rules are merge gates.
- **Bounded autonomy.** Automated repair attempts are limited. Sensitive or
  repeated failures are labelled `needs-human` instead of looping forever.

## Initial architecture

The first version will use:

- Codex for implementation, analysis, test execution, and code review.
- GitHub Actions to trigger repeatable workflows on Issues, PRs, and CI
  results.
- A GitHub App (preferred) or tightly scoped workflow token to create Issues,
  push branches, comment on PRs, and merge only approved changes.
- Repository guidance in `AGENTS.md`, plus issue and pull-request templates.

## Codex app prototype

The repository now includes the installable `$openagent-director` skill. It
turns the current Codex task into a technical director that builds a dependency
graph and launches direct subagents in parallel execution waves.

```mermaid
flowchart TB
  User["Natural-language request"] --> Director["Technical Director"]
  Director --> Contract["Wave 1: contracts and boundaries"]
  Contract --> Backend1["Wave 2: backend worker A"]
  Contract --> Backend2["Wave 2: backend worker B"]
  Contract --> Frontend1["Wave 2: frontend worker A"]
  Contract --> Frontend2["Wave 2: frontend worker B"]
  Backend1 --> Review["Wave 3: parallel review and verification"]
  Backend2 --> Review
  Frontend1 --> Review
  Frontend2 --> Review
  Review --> Integrate["Wave 4: director integration gate"]
  Integrate --> Director
```

The agent hierarchy remains two levels deep. Dependency waves determine when a
worker may start, so direct workers do not have to be peers in execution time.

When this repository is open in Codex, the repo-scoped skill and custom agents
are discovered automatically. To install them for every repository on Windows,
run:

```powershell
pwsh -NoProfile -File scripts/Install-OpenAgent.ps1
```

Restart Codex and invoke it explicitly for the first test:

```text
$openagent-director Add a small feature to this repository. Partition safe work
across parallel workers, wait for dependency waves, review the result, and run
the available verification.
```

Use `-WhatIf` to preview personal installation or `-Force` to update an existing
installation. The MVP keeps orchestration inside the active Codex task; durable
GitHub event state and cross-session recovery remain future MCP-service work.

## Bootstrap prerequisites

The checked-in workflows deliberately fail closed: a failing CI check or a
missing provider credential blocks merge rather than bypassing review.

1. Add `NEWAPI_API_KEY` as a GitHub Actions secret before running the Tech
   Lead, Developer, or Reviewer workflows. The configured New API relay has
   been verified against Codex's Responses API and function-calling flow.
2. Never commit API keys, paste them into Issues or pull requests, or store
   them in repository variables. Rotate any key that was accidentally exposed.
3. Keep provider credentials in GitHub Actions secrets, scope them to the
   Codex step, and retain validation tests. Do not weaken the existing Codex
   review gate to accommodate a provider.

## Local validation

Validate the checked-in workflow contract before opening a change with:

```powershell
pwsh -NoProfile -File tests/Test-AiWorkflow.ps1
```

On success, the validator prints:

```text
AI delivery-loop contract passed.
```

## Roadmap

- [x] Add repository guidance and contribution conventions.
- [x] Add Issue and pull-request templates plus a label-based state machine.
- [x] Implement a Tech Lead workflow that turns a feature Issue into linked,
      scoped tasks.
- [x] Implement a Developer workflow that creates a branch and PR.
- [x] Implement a read-only Reviewer workflow for PR feedback.
- [ ] Add CI-failure triage with a bounded automatic repair loop.
- [ ] Define branch protection and conservative auto-merge rules.
- [x] Add a Codex-native technical-director skill with dependency-aware parallel
      subagents.
- [ ] Add an MCP orchestration service for durable runs, worktree leases, and
      GitHub webhooks.

## Status

This repository is at the design/bootstrap stage. No autonomous merge behavior
is enabled yet.

## License

License selection is pending.
