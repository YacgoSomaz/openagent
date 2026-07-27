# Dependency and partition examples

## Login feature

```text
Wave 1
  contract: session API, shared types, security requirements

Wave 2 (parallel after contract)
  backend-1: session service and token validation
  backend-2: login endpoint and rate limiting
  frontend-1: login form and client validation
  frontend-2: authenticated navigation state

Wave 3 (parallel after implementation)
  reviewer: correctness and maintainability
  security: auth, secret, cookie, and abuse review
  verifier: unit, integration, and end-to-end tests

Wave 4
  director: integration, combined verification, PR decision
```

Do not run both backend workers concurrently if they must edit the same service,
schema migration, dependency lockfile, or shared route registration. Move the
shared edit into the contract wave or assign it to one owner.

## Cross-cutting refactor

Partition by package only after an explorer maps imports and identifies a stable
compatibility contract. Refactor leaf packages in parallel, then update shared
entry points and lockfiles in a serialized integration task.

## Bug with unknown cause

Start parallel read-only hypotheses rather than parallel writers:

- one explorer traces the request path;
- one verifier reproduces and minimizes the failure;
- one reviewer checks recent diffs and likely regressions.

The director selects the best-supported cause and assigns one implementation
worker. After the fix, use a separate verifier for regression evidence.

## Small change

For a typo, one-file configuration edit, or obvious local fix, work directly in
the main thread. Parallelism is justified only when the user explicitly requests
it or independent investigation materially reduces uncertainty.
