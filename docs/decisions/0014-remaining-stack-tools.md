# 0014 — Background Jobs, Login, Testing and Frontend Tools

**Status:** APPROVED  
**Date:** 2026-11-03  
**Approved by:** Project owner

---

## Context

ADR 0012 decided the language, the application type and the repository setup. ADR 0013 decided the backend framework (NestJS) and the database access library (Drizzle). The remaining tools in `05-TECHNICAL-ARCHITECTURE.md`, section 19, were recommended but not yet approved.

The owner confirmed the recommended tools. Versions were checked against the npm registry on 2026-11-03.

## Alternatives

Each alternative was considered in the earlier review of the stack. This ADR records the choice, not a new comparison.

- **Background jobs:** pg-boss, which uses the project's PostgreSQL database. A separate queue service was discarded, because it adds cost and maintenance (`05`, section 8).
- **Login:** a self-hosted library (better-auth), keeping account data in the project's database. A managed service was discarded (ADR 0012).
- **Testing:** Vitest for business rules and integration, and Playwright for flows in the browser.
- **Frontend:** React with Vite, and TanStack Query for loading and caching server data.

## Decision

| Area | Tool | Version (npm `latest`, 2026-11-03) |
|---|---|---|
| Background jobs | pg-boss | 12.38.0 |
| Login | better-auth | 1.7.15 |
| Unit and integration tests | Vitest | 5.1.0 |
| Browser flow tests | Playwright | 1.64.1 |
| Frontend library | React | 19.3.1 |
| Frontend build tool | Vite | 8.3.5 |
| Server data loading and cache | TanStack Query | 5.105.3 |

Rules that apply to all of them:

- Stable releases only. Pre-releases (alpha, beta, release candidate) are not used.
- Versions are pinned in the project's lock file when the project is created. Changes to a major version require a new ADR or a note in this one.

## Rationale

- pg-boss keeps the job queue inside PostgreSQL, which satisfies the idempotency and recovery requirements in `05`, section 8.1 without extra services.
- better-auth keeps account data in the project's database, as required by ADR 0012 and the LGPD requirement in `01-PRODUCT.md`, section 12.
- Vitest 5 and Playwright are the current stable versions. Vitest 4.1 (the previous major) remains a valid fallback if a dependency does not support Vitest 5.
- React, Vite and TanStack Query are current stable releases with broad support, which keeps the frontend maintainable.

## Consequences

- Vitest 5 is a major version. If a library in use does not support it yet, the project falls back to Vitest 4.1 and records that change.
- The frontend and backend use TypeScript throughout (ADR 0012).
- The PostgreSQL and Node.js versions available on the POCO F3 host (`docs/decisions/0011-initial-host.md`) are not yet verified. They must be checked before Phase 1 starts, because pg-boss, Drizzle and NestJS depend on them.
- Before implementation, the exact compatibility of better-auth with NestJS 12 must be confirmed.
