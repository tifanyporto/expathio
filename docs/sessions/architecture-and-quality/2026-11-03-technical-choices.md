# 2026-11-03 — Technical Choices

## Goal

Present the technical choices needed for Phase 1, as recommendations for the owner to approve. Record the scalability foundations as an approved decision, and take the owner's planned host (a POCO F3 phone) into account.

## Scope

- In scope: options and recommendations for the stack and hosting; ADR 0010 (scalability foundations); CURRENT_STATE updates.
- Out of scope: any code, any installation, any choice the owner has not approved.

## Documents Read

1. `CLAUDE.md`.
2. `docs/CURRENT_STATE.md`.
3. `docs/05-TECHNICAL-ARCHITECTURE.md` (full).
4. `docs/sessions/product-and-documentation/2026-11-03-company-definition.md`.
5. `docs/decisions/0009-first-version-tools-and-roles.md` (format reference).

## Files Changed

- `docs/05-TECHNICAL-ARCHITECTURE.md`: removed "Simulation time model" from open decisions in section 19, because ADR 0001 already decides it.
- `docs/decisions/0010-scalability-foundations.md`: created, status APPROVED.
- `docs/decisions/0011-initial-host.md`: created, status APPROVED.
- `docs/decisions/0012-initial-technology-direction.md`: created, status APPROVED (TypeScript, web application, native desktop only if ever needed, public repository, self-hosted login library).
- `docs/decisions/0013-backend-framework-and-orm.md`: created, status APPROVED (NestJS 12, Drizzle 0.45, stable releases only).
- `docs/decisions/0014-remaining-stack-tools.md`: created, status APPROVED (pg-boss, better-auth, Vitest 5.1.0, Playwright, React 19.3.1, Vite 8.3.5, TanStack Query 5.105.3; versions from the npm registry on 2026-11-03).
- `docs/CURRENT_STATE.md`: ADRs 0012 to 0014 added; the stack is decided except the PostgreSQL and Node.js versions on postmarketOS.
- `docs/CURRENT_STATE.md`: added ADR 0010 to approved decisions; added the technical stack (not approved) and the POCO F3 host (assessment pending) to open items.
- `docs/sessions/architecture-and-quality/2026-11-03-technical-choices.md`: this record.

## Decisions

- Proposed (not approved): the technical stack in the conversation (TypeScript, NestJS, PostgreSQL, Drizzle, React with Vite, pg-boss, Vitest and Playwright). Hosting on a POCO F3 phone is the owner's intent and has not been assessed.
- Approved by the owner: ADR 0010, four scalability foundations (data isolation by organization, stateless application instances, file storage behind an abstraction, idempotent background operations). ADR 0011, initial host: POCO F3 running postmarketOS through Phase 3, with the four conditions in that ADR.

## Tests and Results

Nothing was executed. There is no application code.

## Pending

- Owner approval of the stack and of each structural choice in `05`, section 19. Each approved choice needs its own ADR.
- Checking PostgreSQL and Node.js versions on the postmarketOS device (`apk policy postgresql nodejs`). Owned by the session that configures the device, not by the documentation work. Not run here.
- Hosting on a POCO F3 phone running postmarketOS (Linux, no Android apps). The owner reports the device is fully functional and has run 24 hours a day on power in a previous project. Still to decide: whether this becomes an ADR (proposed conditions: config-driven DB and storage paths, daily backup off the device, private access only, no real participant data before the Phase 4 hosting decision). Earlier risk list: The earlier assessment assumed Android; that no longer applies. Risks to assess: device support level in postmarketOS (Wi-Fi, battery reporting, suspend behavior); keeping the device awake and plugged in continuously; charge limit support; heat and battery wear; network exposure (home connection, dynamic address); SSH and firewall hardening; backups kept off the device; physical loss or theft; LGPD obligations once real participant data is stored.
- Repository visibility (public or private).
- Application type: web or desktop.
- Hosting and backup are needed before any real participant uses the platform.

## How to Resume

Read in this order:

1. `CLAUDE.md`.
2. `docs/CURRENT_STATE.md`.
3. This record.
4. `docs/05-TECHNICAL-ARCHITECTURE.md`, section 19, and `docs/decisions/0010-scalability-foundations.md`.

Starting point: the owner's answers on the stack, the application type, the repository visibility and the POCO F3 hosting.

Do not re-ask the four scalability foundations. They are approved in ADR 0010.

## Next Step

Assess the POCO F3 as a host with the owner, present the options (keep everything on the phone for early phases, or a different host), and then decide the stack.
