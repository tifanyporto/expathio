# 2026-11-04 — Phase 0 Practices

## Goal

Close the Phase 0 items of `06-ROADMAP.md` that concern the development environment and repository practices, and prepare the testing and deployment strategy and a risk register for approval.

## Scope

- In scope: development environment (Docker, Windows computer, POCO F3 as production); branch and commit practices; explanation of the testing, deployment and risk items.
- Out of scope: repository creation (`git init`), installing Docker, any code, the PostgreSQL version check on the device (owned by the session that configures the device).

## Documents Read

1. `CLAUDE.md`.
2. `docs/CURRENT_STATE.md`.
3. `docs/06-ROADMAP.md`, section 3 (Phase 0).
4. `docs/sessions/architecture-and-quality/2026-11-03-technical-choices.md`.

## Files Changed

- `docs/decisions/0015-development-environment-and-repository.md`: created, status APPROVED.
- `CLAUDE.md`, section 7: branch policy marked as approved, with the no-pull-request rule.
- `docs/CURRENT_STATE.md`: ADR 0015 added to approved decisions; testing and deployment strategy and risk register added to open items.
- `docs/decisions/0016-testing-and-deployment-strategy.md`: created, status APPROVED.
- `docs/05-TECHNICAL-ARCHITECTURE.md`: section 21 added, the technical risk register (format and initial ten risks).
- `docs/sessions/architecture-and-quality/2026-11-04-phase-0-practices.md`: this record.

## Decisions

- Approved by the owner: ADR 0015. Docker for local PostgreSQL; production on the POCO F3; code written only on the Windows computer; one branch per significant task named `tipo/descricao-curta`; no pull requests.
- Approved by the owner (session 2026-11-04, after the plain-language explanation): ADR 0016. Three test levels with Vitest and Playwright; tests run manually before each merge; continuous integration deferred; scripted deployment with a health check and a rollback copy, built in Phase 1.
- Approved by the owner: risk register format (risk, impact, probability, action) as section 21 of `05-TECHNICAL-ARCHITECTURE.md`, with the ten initial risks listed there.

## Tests and Results

Nothing was executed. There is no application code.

## Pending

- Verification of the PostgreSQL version on the phone against the Docker version (owned by the device session).
- Phase 0 exit criterion "Development environment is ready" is not met until Docker Desktop and WSL2 are installed on the Windows computer (owner's action).
- Rollback procedure: to be defined with the deployment script in Phase 1.
- Installation of Docker Desktop and WSL2 on the Windows computer (owner's action, before Phase 1).
- Repository creation: `git init` and the first commit only when the owner asks.

## How to Resume

Read in this order:

1. `CLAUDE.md`.
2. `docs/CURRENT_STATE.md`.
3. `docs/decisions/0015-development-environment-and-repository.md`.
4. This record.

Starting point: Phase 0 practice items are approved. Remaining Phase 0 work is the owner's Docker and WSL2 installation and the device-session PostgreSQL and Node.js check.

Do not re-ask the branch policy, the Docker decision, the testing strategy or the risk register format. They are approved in ADR 0015, ADR 0016 and `05`, section 21.

## Next Step

Repository creation (`git init`) and the first commit, only when the owner asks. Phase 1 starts after Phase 0 exit criteria are met.
