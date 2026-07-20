# OpenAgent Maintainer Runbook

This runbook describes the maintainer-facing operating loop for the checked-in
OpenAgent GitHub workflows.

## 1. Label bootstrap

Run the bootstrap workflow first so the repository has the labels the delivery
loop expects. This label bootstrap step prepares the label set before any Tech
Lead, Developer, Reviewer, or merge-gate workflow is dispatched.

## 2. Dispatch the Tech Lead

Start from a trusted parent Issue that contains the feature request. The Tech
Lead workflow reads repository context, breaks the request into scoped child
Issues, and dispatches Developer runs against those smaller tasks.

## 3. Hand off to the Developer

Each Developer run should address one scoped child Issue only. The Developer
workflow works on a `feature/issue-<number>-<slug>` branch, implements the
change, runs the relevant checks, and opens the corresponding pull request for
review.

## 4. Read the Reviewer output

The Reviewer workflow comments on pull request correctness, regression risk,
and test coverage gaps without changing code. Treat Reviewer output as review
input for the PR, not as a merge approval on its own.

## 5. Enforce the explicit merge gate

Merging stays manual in this bootstrap version. Use the merge gate only after
required CI checks pass, the review state is acceptable, and the maintainer is
ready to confirm the merge. The merge workflow then verifies checks, merges the
PR, closes linked Issues, and deletes the feature branch.

## 6. Validate the contract locally

Before changing the workflows or repository guidance, run:

```powershell
pwsh -NoProfile -File tests/Test-AiWorkflow.ps1
```

The expected result is a successful exit and this output:

```text
AI delivery-loop contract passed.
```
