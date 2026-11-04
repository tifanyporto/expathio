# 0015 — Development Environment and Repository Practices

**Status:** APPROVED  
**Date:** 2026-11-04  
**Approved by:** Project owner

---

## Context

Phase 0 requires a defined development environment and repository practices before implementation starts (`06-ROADMAP.md`, section 3). The project has one developer. The owner works on a Windows computer with 32 GB of RAM. The POCO F3 phone running postmarketOS is the initial production host (`docs/decisions/0011-initial-host.md`).

## Alternatives

**Local services (PostgreSQL)**
1. **Docker.** Runs PostgreSQL inside an isolated container on the development computer. Chosen. It requires Docker Desktop, which uses WSL2 on Windows.
2. **Native PostgreSQL installed on Windows.** Viable and lighter. Discarded by the owner, who wants Docker experience.

**Where code is written**
1. **Development on the Windows computer only.** The phone receives only deployed versions. Chosen.
2. **Development directly on the phone.** Discarded. The phone is the production host.

**Branches and review**
1. **One branch per significant task, named `tipo/descricao-curta`, merged into the main branch when done. No pull requests.** Chosen. The project has one person, so a pull request would be approved by its own author.
2. **Pull requests reviewed by the owner.** Discarded, because the owner is the only reviewer.
3. **Commits directly on the main branch.** Discarded. It removes the isolation of each task.

## Decision

1. **Docker for local services.** PostgreSQL for development runs in Docker on the Windows computer. The PostgreSQL major version used in Docker must match the version installed on the phone. This check depends on the postmarketOS version verification pending in `CURRENT_STATE.md`.
2. **Production on the phone.** The POCO F3 is the production environment. It runs only deployed versions.
3. **Code is written only on the Windows computer.**
4. **Branches.** Each significant task has its own branch, named `tipo/descricao-curta` (for example, `feat/inventory-replenishment`). The branch is merged into the main branch when the task is complete and its tests pass.
5. **No pull requests.** Changes are merged directly by the owner.
6. **Commit messages** follow `CLAUDE.md`, section 7: English, imperative.

## Rationale

- Docker gives a repeatable local database that matches the production setup when the versions match.
- Keeping production separate from development reduces the risk of breaking the live environment (`docs/decisions/0011-initial-host.md`).
- Branches keep each task's changes separate and easy to undo, without the overhead of reviews that a single person does not need.

## Consequences

- Docker Desktop and WSL2 must be installed on the Windows computer before Phase 1.
- If the PostgreSQL versions differ between Docker and the phone, the difference must be recorded and fixed before any production deployment.
- Because there are no pull requests, the tests must pass before a branch is merged. This is a manual step until a continuous integration tool is adopted (see the pending testing and deployment decisions in `CURRENT_STATE.md`).
- The `CLAUDE.md` branch policy is now approved and no longer marked as a proposal.
