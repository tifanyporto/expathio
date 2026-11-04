# 0012 — Initial Technology Direction

**Status:** APPROVED  
**Date:** 2026-11-03  
**Approved by:** Project owner

---

## Context

Phase 1 needs a language, an application type and a repository setup before implementation starts (`05-TECHNICAL-ARCHITECTURE.md`, section 19). The owner reviewed the recommended stack and gave decisions on the main points.

The initial host is the POCO F3 running postmarketOS (`docs/decisions/0011-initial-host.md`), so the chosen tools must run on Linux ARM64.

## Alternatives

**Language**
1. TypeScript for the backend and the frontend. Chosen.
2. Python for the backend, with TypeScript only in the frontend. Viable, but splits the codebase into two languages, and shared types between frontend and backend would have to be maintained by hand.
3. Two services, TypeScript for the platform and Python for AI. Deferred. Viable later if AI needs demand it, but it adds a second process to run and maintain.

**Application type**
1. Web application, with a layout designed for computers. Chosen.
2. Desktop application. Deferred. If it ever happens, it will be native, not packaged with Electron.

**Repository**
1. Public. Chosen.
2. Private. Discarded by the owner's choice.

**Login**
1. Self-hosted authentication library, storing account data in our own database. Chosen.
2. Managed authentication service. Discarded, because account data would be held by a third party.

## Decision

1. **Language.** TypeScript is used for the backend and the frontend. Python is not used in the first phases.
2. **Application type.** The product is a web application, designed for computer use, as stated in `03-USER-EXPERIENCE.md`, section 6.5.
3. **Desktop, if ever needed.** Any future desktop version will be native. Electron is excluded. Packaged web wrappers are not the default option.
4. **Repository.** The code repository is public. No secret, `.env` file, API key or personal data is ever committed (`CLAUDE.md`, section 7 and section 11).
5. **Login.** Authentication uses a self-hosted library, and account data stays in the project's database.

Other items from the recommended stack (framework, ORM, background jobs, testing tools) are not decided by this ADR. They will be confirmed after checking their current versions and maintenance status.

## Rationale

- TypeScript lets the backend and the frontend share types for permissions, task states and events, which reduces errors in the rules.
- The AI integration in the current design is a layer that calls provider APIs. Official SDKs exist for TypeScript, so Python is not needed for that layer.
- A web application runs on the POCO F3 host and reaches participants through a browser, without installing anything.
- Keeping account data in the project's own database fits the LGPD requirement in `01-PRODUCT.md`, section 12.
- A public repository is a visibility choice for the owner. It does not change the rule that secrets and personal data stay out of it.

## Consequences

- Adding Python later requires a new ADR, a clear interface between the two parts, and an assessment of the extra maintenance.
- The public repository makes the code visible. Before the first commit, the project needs a `.gitignore` that excludes secrets, `.env` files and local data. This is part of Phase 1.
- A future desktop version would be a separate project with its own native toolchain. It is out of scope for the first releases.
- The login library must be selected and its current maintenance status checked before implementation.
