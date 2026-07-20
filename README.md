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

## Target workflow

```text
Feature request
  -> Tech Lead creates a plan and linked Issues
  -> Developer AI creates feature/<issue>-<name> and opens a PR
  -> CI and Reviewer AI validate the change
  -> Tech Lead merges eligible PRs and closes the linked Issue
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

## Roadmap

- [ ] Add repository guidance and contribution conventions.
- [ ] Add Issue and pull-request templates plus a label-based state machine.
- [ ] Implement a Tech Lead workflow that turns a feature Issue into linked,
      scoped tasks.
- [ ] Implement a Developer workflow that creates a branch and draft PR.
- [ ] Implement a read-only Reviewer workflow for PR feedback.
- [ ] Add CI-failure triage with a bounded automatic repair loop.
- [ ] Define branch protection and conservative auto-merge rules.

## Status

This repository is at the design/bootstrap stage. No autonomous merge behavior
is enabled yet.

## License

License selection is pending.
