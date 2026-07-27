# Worker task contract

Give every worker a self-contained contract. Do not depend on hidden context.

```yaml
run_id: "oa-YYYYMMDD-short-name"
task_id: "backend-session-endpoint"
role: "implementer | reviewer | verifier | explorer"
objective: "One observable outcome"
dependencies: []
worktree: "Absolute path, or shared-read-only"
branch: "feature/<run-id>-<task-id>"
read_scope:
  - "Relevant paths and interfaces"
write_scope:
  - "Exclusive files or directories; empty for read-only work"
acceptance_criteria:
  - "Behavior that must be true"
verification:
  - "Exact command or inspection"
constraints:
  - "Repository rules, compatibility, and forbidden actions"
deliverables:
  - "Patch/commit, findings, tests, or design contract"
```

Append these worker instructions:

- Work only inside the assigned worktree and write scope.
- Do not delegate or coordinate directly with other workers.
- Do not change shared contracts without returning a blocking proposal.
- Preserve unrelated and pre-existing changes.
- Run the assigned verification before reporting completion.
- Do not merge, rebase, push, delete branches, or modify GitHub state unless
  the contract explicitly authorizes it.

Require this result schema:

```yaml
status: "completed | blocked | failed"
summary: "What changed or what was learned"
files_changed: []
verification:
  - command: "Exact command"
    result: "passed | failed | not-run"
    evidence: "Concise output or reason"
risks: []
handoff: "Anything a dependent task must know"
commit: "Optional commit SHA"
```

For reviewers, replace `files_changed` with findings ordered by severity. Each
finding must include a file, tight line range, impact, and proposed correction.
