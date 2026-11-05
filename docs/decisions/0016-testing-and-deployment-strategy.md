# 0016 — Testing and Deployment Strategy

**Status:** APPROVED  
**Date:** 2026-11-04  
**Approved by:** Project owner

---

## Context

`06-ROADMAP.md`, section 3, requires an initial testing and deployment strategy before implementation starts. `05-TECHNICAL-ARCHITECTURE.md`, section 16, asks for automated tests, migrations, deployment validation and rollback, but does not choose how. The tools are already approved in ADR 0014 (Vitest, Playwright). ADR 0015 fixes the environment: code is written on the Windows computer, PostgreSQL runs in Docker there, and the POCO F3 phone is production.

The project has one person. There are no pull requests (ADR 0015), so nothing reviews a change except the tests and the owner's own check.

## Alternatives

**Automated testing on each change (continuous integration, CI)**
1. **Adopt CI now (for example, GitHub Actions).** Runs tests on every push. Discarded for now: it adds a service to set up and maintain before any code exists, and it needs the repository on GitHub, which did not exist when this decision was taken on 2026-11-04.
2. **Defer CI; run tests manually before merging a branch.** Chosen. Revisit when the number of features makes manual runs error-prone.

**Deployment**
1. **Automated deployment pipeline.** Discarded for now: it needs CI and more infrastructure than a single phone.
2. **Manual copy of files and restart.** Discarded: undocumented steps are error-prone and are not reproducible (`05`, section 16).
3. **Scripted deployment run from the Windows computer over private access.** Chosen. A single script performs fixed steps in a fixed order and stops on the first failure.

## Decision

### Testing levels

| Level | What it checks | Tool | Runs against |
|---|---|---|---|
| Business rule (unit) | One rule in isolation, for example "stock never goes negative" | Vitest 5.1.0 | No database |
| Integration | A rule working with the real database, for example "saving an order writes to PostgreSQL" | Vitest 5.1.0 | PostgreSQL in Docker (ADR 0015) |
| Flow | A participant action from start to end in the browser, for example "log in, create an order, see it in the list" | Playwright 1.64.1 | Running application |

Rules:

- Every business rule has at least one unit test (`CLAUDE.md`, section 10).
- Every full process has at least one flow test. Flow tests are written from the acceptance scenarios in `06-ROADMAP.md`, section 14.
- Each database schema change ships with a migration file, and integration tests run against a database with all migrations applied.
- Participant data is never used in tests (`CLAUDE.md`, section 11). Tests use fictional data created by the tests themselves.

### When tests run

- Before a branch is merged into the main branch, the owner runs all three levels on the Windows computer. Merging with failing tests is not allowed.
- Continuous integration is deferred. It is a later decision, to be recorded in a new ADR when adopted.

### Deployment

1. The owner runs the full test suite on the Windows computer. Failing tests stop the process.
2. The owner runs the deployment script. It copies the tested version to the phone over private access (ADR 0011).
3. The script applies database migrations, then restarts the application.
4. The script checks that the application answers on its health address. If the check fails, the script stops and reports the error.
5. The owner opens the private address and confirms the main pages load.

Rollback: the previous version is kept on the phone next to the new one. Rolling back means restarting the previous version and reversing the migration, or restoring the daily backup (ADR 0011). Rollback steps are written in the deployment script's documentation when the script is built in Phase 1.

### Environments

- **Development:** Windows computer, Docker PostgreSQL. Test data only.
- **Production:** POCO F3 phone. Runs only deployed versions. No development tools on it.

The deployment script and its documentation are built in Phase 1, not now.

## Rationale

- Three levels separate the speed of rule tests from the realism of database and browser tests, without a large setup.
- Deferring CI removes a service and a repository dependency that the single owner does not need yet, while keeping the rule that nothing unverified is merged.
- A short scripted deployment with a health check and a stop-on-failure rule covers the "controlled process" in `05`, section 16, at a cost of zero.

## Consequences

- Each test level needs its own setup in Phase 1: Vitest configuration, a Docker database with migrations, and Playwright installed with its browsers.
- The owner must run the tests manually before each merge. This is a discipline cost that CI would remove later.
- Migrations become a required artifact for each schema change.
- Deployment depends on private access to the phone being working (ADR 0011). If it is not, deployment is blocked.
- The rollback procedure is a known gap until the deployment script exists.
