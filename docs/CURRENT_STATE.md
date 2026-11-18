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
- `0020` — Releases are recorded and versioned as defined in `docs/decisions/0020-release-history-and-versioning.md`.
- `0022` — Phase 1 uses test accounts only. No real person creates an account or signs in to the production phone before Phase 4.
- `0023` — In Phase 1, membership in the organization is a direct link created by the owner or the test setup. Vacancy applications (ADR 0005) are not part of Phase 1.
- `0024` — Phase 1 loads the four business roles from ADR 0009 as data, with no business behavior. Permissions are enforced by the backend.
- `0025` — Refund and exchange requests from Customer Service are approved or rejected by the Finance Assistant.
- `0026` — The vacancy application flow (ADR 0005) is built in Phase 2, not Phase 4.
- `0027` — The four first-version role titles are Operations Assistant, Customer Service Representative, Sales Support Assistant and Finance Assistant.
- `0028` — Phase 1 login uses e-mail, the post-login page shows the organization and role with a simulated-data label, there is no password recovery in Phase 1, and the text "Expathio" is used until a logo is approved.
- `0037` — AI may be used before Phase 6, case by case, in one bounded role at a time, with the owner's approval for each case. Amends `0003`. `0004` stays at R$ 0 until the first case is approved with its budget. First candidate: the simulated manager for proposal approval in Phase 4.

Other decisions recorded in the documents, added on 2026-11-06:

- Permissions by role for the first version are approved (`08-COMPANY.md`, section 6.1).
- The Phase 1 scope is approved, with nine items (`06-ROADMAP.md`, section 4).
- The process for adding a role, which may also add functions, is approved (`08-COMPANY.md`, section 9). Whether a role can be added without a code change is open for Architecture and Quality.

Other decisions recorded in the documents:

- The first release ends with Phase 5, and its acceptance scenarios are in `06-ROADMAP.md`, section 14.
- Smartphone and email are outside the first release (`03-USER-EXPERIENCE.md`, section 6.5).
- Formal performance reviews are outside the first release (`07-PROGRESSION-AND-REWARDS.md`, section 7).
- Collaboration between human participants belongs to Phase 8 (`06-ROADMAP.md`, Phase 4).
- Creating organizations is a future step (`01-PRODUCT.md`, section 10).
- Performance bonuses and profit-sharing are long-term goals (`07-PROGRESSION-AND-REWARDS.md`, section 9).
- Participant data is personal data (`01-PRODUCT.md`, section 12; `CLAUDE.md`, section 11).
- Planning assumption: 5 to 10 hours per week (`06-ROADMAP.md`, section 1).

## Candidate Resources

Resources available to the project but not in use. Using one needs a decision approved by the owner.

- **Google AI Ultra subscription** (owner, 2026-11-17, one year, ends around 2027-11). It grants monthly Google Cloud credits that can pay for the Gemini API. Each credit is valid for 12 months from its grant. Nothing has been claimed: claiming needs a Google Cloud billing account, and the owner's existing one stays closed. Credits are claimed only when the first early AI case is approved (ADR 0037), and any use needs an amendment to ADR 0004. The Ultra tier (5x or 20x) is not confirmed. Details: `04-AI-AGENTS.md`, section 17.

## Open

Open questions are listed in `docs/OPEN-QUESTIONS.md`, one entry per question, with the function it is addressed to. Do not repeat them here.

- **Standard session prompt and role assignment**: kept by the owner, outside the project, so that sessions do not read it. Not a project document.
- **Session structure**: the session map in `docs/SESSION-STRUCTURE.md` is APPROVED (2026-11-04), including the planned sessions for Phases 5 to 7 (section 4). The Phase 1 source code folder layout is set by ADR 0019. AI Integration is active since 2026-11-17, before Phase 6 (section 3.7; ADR 0037).

## Open Inconsistencies

Resolved on 2026-11-17:

- `CLAUDE.md`, section 14, and ADRs 0029 and 0030 (APPROVED on 2026-11-09) allow direct messages between sessions, while `SESSION-STRUCTURE.md`, section 2, said that sessions do not message each other and that the owner routes handoffs. The owner chose to align the document with the ADRs: sections 1, 2 and 5 of `SESSION-STRUCTURE.md` updated. ADRs 0029 and 0030 are still only on unmerged branches, such as `docs/adr-0030-direct-communication`, so the links resolve once those branches are merged into `main`.

Resolved on 2026-11-06:

- `docs/decisions/0009-first-version-tools-and-roles.md`, `01-PRODUCT.md`, section 3.5, and `docs/decisions/0024-phase-1-business-roles-loaded.md` pointed to `08-COMPANY.md`, section 3, for the role tools. The tools are in section 5. References corrected; no change to the decision itself.

- `06-ROADMAP.md`, section 4, puts login in Phase 1, while ADR 0011 and `01-PRODUCT.md`, section 12, restrict real participant data until Phase 4. Resolved by `docs/decisions/0022-phase-1-test-accounts-only.md`: Phase 1 uses test accounts only.

Resolved on 2026-11-04:

- `02-BUSINESS-SIMULATION.md` described online sales only, while `08-COMPANY.md` has two physical stores. Resolved by `docs/decisions/0017-physical-stores-in-first-release.md`; `02` sections 3, 6.2 and 6.3 updated.
- `02-BUSINESS-SIMULATION.md`, section 15, listed questions already answered in `docs/decisions/0001-simulation-time.md` and `06-ROADMAP.md`. Each answer is now noted inline.

Resolved on 2026-11-05:

- `docs/decisions/0016-testing-and-deployment-strategy.md` said the GitHub repository was "not yet created". The wording now states that it did not exist on 2026-11-04, when the decision was taken. The decision to defer CI is unchanged.
