# Expathio — Current State

**Status:** IN DISCUSSION  
**Document type:** Project state  
**Project:** Expathio

---

## Implemented

Nothing. There is no application code yet.

## In Progress

- Refinement of the documentation. The initial organization in `08-COMPANY.md` is complete: identity, catalog, roles, tools and vacancies.

## Planned

- Start of Phase 1 of the roadmap.

## Approved Decisions

Recorded in `docs/decisions/`:

- `0001` — Simulation time advances in simulated days, with one shared timeline per organization.
- `0002` — The first version uses a simulated developer workflow. Real GitHub connection is long-term.
- `0003` — AI enters in Phase 6. Level 4 autonomy is out of scope.
- `0004` — The monthly budget for AI calls is R$ 0 for now.
- `0005` — Participants apply to predefined vacancies.
- `0006` — Customer work is a "case"; operational problems are "incidents".
- `0007` — One occupant per role; role changes after the first version; feedback through observable results; participants may propose actions, with manager approval; departure hands the role to the simulation.
- `0008` — Participation happens in work sessions.
- `0009` — Four participant roles in the first version, with the tools listed in `08-COMPANY.md`.
- `0010` — Four scalability foundations from the first implementation: data isolation by organization, stateless application instances, file storage behind an abstraction, idempotent background operations.
- `0011` — The initial host is a POCO F3 running postmarketOS, through Phase 3, with configurable paths, daily backup off the device, private access only, and no real participant data before the Phase 4 hosting decision.
- `0012` — TypeScript for backend and frontend; web application; future desktop, if any, native and not Electron; public repository; self-hosted login library with account data in our own database.
- `0013` — NestJS as the backend framework and Drizzle ORM for database access, both on stable releases (NestJS 12, Drizzle 0.45).
- `0014` — pg-boss for background jobs, better-auth for login, Vitest and Playwright for testing, React with Vite and TanStack Query for the frontend, all on stable releases.
- `0015` — Docker for local PostgreSQL on the Windows computer; code written only there; the POCO F3 is production; one branch per significant task named `tipo/descricao-curta`; no pull requests.
- `0016` — Three test levels (business rules, integration with PostgreSQL in Docker, browser flows); tests must pass before each merge; continuous integration deferred; scripted deployment to the phone with a health check and a rollback copy.
- `0017` — The first release includes the online store and the two physical stores of MONUMENT. Stock is tracked per location.
- `0018` — The production phone is dedicated to Expathio. The old project is removed after a backup, and the device is renamed `expathio`.
- `0019` — Phase 1 source code is one package at the repository root, with `server/`, `web/`, `shared/` and `ops/`.

Other decisions recorded in the documents:

- The first release ends with Phase 5, and its acceptance scenarios are in `06-ROADMAP.md`, section 14.
- Smartphone and email are outside the first release (`03-USER-EXPERIENCE.md`, section 6.5).
- Formal performance reviews are outside the first release (`07-PROGRESSION-AND-REWARDS.md`, section 7).
- Collaboration between human participants belongs to Phase 8 (`06-ROADMAP.md`, Phase 4).
- Creating organizations is a future step (`01-PRODUCT.md`, section 10).
- Performance bonuses and profit-sharing are long-term goals (`07-PROGRESSION-AND-REWARDS.md`, section 9).
- Participant data is personal data (`01-PRODUCT.md`, section 12; `CLAUDE.md`, section 11).
- Planning assumption: 5 to 10 hours per week (`06-ROADMAP.md`, section 1).

## Open

- **GitHub connection mechanism**: long-term, not yet defined. No phase set yet; the owner decides when to specify it.
- **Stock transfers between locations**: not defined (`02-BUSINESS-SIMULATION.md`, section 15, question 13). Required before Phase 3.
- **Participant privacy and data rights**: not defined (`01-PRODUCT.md`, section 12). Required before Phase 4 admits the first real participant.
- **Visual specification**: `09-DESIGN-SYSTEM.md` is a direction only. Required before the first screen in Phase 1.
- **Open questions by phase** (approved by the owner on 2026-11-04): `03` before Phase 4; `04` before Phase 6; `07` before Phase 7. Simulated-day mechanics (`02`, section 11) are specified in Phase 5. Stock transfers between locations (`02`, question 13) are decided before Phase 3. Visual specification (`09`) is done before the first Phase 1 screen. Participant privacy (`01`, section 12) is done before Phase 4 admits the first real participant. The GitHub connection has no phase yet.
- **Technical stack**: language, application type, repository and login approach are decided in ADR 0012. Backend framework and ORM are decided in ADR 0013. Background jobs, login, testing and frontend tools are decided in ADR 0014. Still open: the PostgreSQL and Node.js versions available on postmarketOS. Checking them belongs to the session that configures the device, not to the documentation work. See `05-TECHNICAL-ARCHITECTURE.md`, section 19.
- **Hosting decision for Phase 4**: required before the first participant is admitted. The initial host is decided in ADR 0011.
- **Continuous integration tool**: deferred. Tests are run manually before each merge (ADR 0016). To be decided when the number of features makes manual runs error-prone.
- **Rollback procedure**: the deployment script does not exist yet. Its rollback steps are defined in Phase 1 (ADR 0016).
- **Session structure**: the session map in `docs/SESSION-STRUCTURE.md` is APPROVED (2026-11-04), including the planned sessions for Phases 5 to 7 (section 4). The Phase 1 source code folder layout is set by ADR 0019.
- **Standard session prompt and role assignment**: kept by the owner, outside the project, so that sessions do not read it. Not a project document.
- **Visual specifications**: the palette and design tokens in `09-DESIGN-SYSTEM.md` are a direction, not a final specification.

## Open Inconsistencies

Resolved on 2026-11-04:

- `02-BUSINESS-SIMULATION.md` described online sales only, while `08-COMPANY.md` has two physical stores. Resolved by `docs/decisions/0017-physical-stores-in-first-release.md`; `02` sections 3, 6.2 and 6.3 updated.
- `02-BUSINESS-SIMULATION.md`, section 15, listed questions already answered in `docs/decisions/0001-simulation-time.md` and `06-ROADMAP.md`. Each answer is now noted inline.

None open at this time.
