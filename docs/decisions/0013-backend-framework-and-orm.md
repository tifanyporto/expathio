# 0013 — Backend Framework and ORM

**Status:** APPROVED  
**Date:** 2026-11-03  
**Approved by:** Project owner

---

## Context

ADR 0012 fixed the language (TypeScript), the application type (web) and the repository setup. The recommended backend framework and the database access library (ORM) were still open (`05-TECHNICAL-ARCHITECTURE.md`, section 19).

The owner confirmed NestJS and Drizzle. Before recording them, the current versions were checked against the npm registry on 2026-11-03.

## Alternatives

**Backend framework**
1. **NestJS.** Chosen. Its modules match the business domains in `05`, section 4.
2. **Fastify**, without a framework structure. Lighter, but the module organization would be written by hand.
3. **FastAPI (Python).** Discarded, because it would introduce a second language (ADR 0012).

**Database access (ORM)**
1. **Drizzle.** Chosen. Queries stay close to SQL, and migrations are explicit files.
2. **Prisma.** Viable, but its database engine is a native binary that needs a build for each platform. That adds maintenance on the POCO F3 (ARM64, Alpine).
3. **Kysely.** Viable, but offers less help with migrations and schema definition.

## Decision

1. **NestJS** is the backend framework.
2. **Drizzle ORM** is the database access library.
3. **Versions.** The project uses stable releases only. At the time of this decision:
   - NestJS: current major line 12 (`@nestjs/core` 12.3.2).
   - Drizzle ORM: stable line 0.45 (0.45.4, the npm `latest` tag). The 1.0 release candidates are not used until a stable 1.0 is published, which requires a new decision or a note in this ADR.
4. The exact versions are pinned in the project's dependency lock file when the project is created, and changes to major versions are recorded in an ADR.

## Rationale

- NestJS provides the module structure that the domain organization in `05` requires, with the least custom code.
- Drizzle keeps SQL visible and does not need a platform-specific native engine, which fits the POCO F3 host (`docs/decisions/0011-initial-host.md`).
- Stable releases reduce the risk of breaking changes during development.

## Consequences

- NestJS 12 moved all official packages to ESM (ECMAScript modules, the modern JavaScript module system). Any library that does not support ESM must be replaced or checked before adoption.
- Drizzle 0.45 will need a migration when 1.0 becomes stable. That change needs its own review.
- Choosing NestJS adds more code structure than a minimal framework. It is accepted because the domain modules justify it.
- The remaining stack items (background jobs, login library, frontend libraries and testing tools) are still to be approved, with their versions checked in the same way.
