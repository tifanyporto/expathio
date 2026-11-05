# 0019 — Phase 1 Source Code Layout

**Status:** APPROVED  
**Date:** 2026-11-05  
**Approved by:** Project owner

---

## Context

Phase 1 needs folders for the application code. The layout was open in `docs/CURRENT_STATE.md` and `docs/SESSION-STRUCTURE.md`, section 7. It blocks the start of the Platform Engineering and Frontend Engineering sessions.

Approved decisions ADR 0010, 0012, 0013, 0014, 0015 and 0016 fix the language, the frameworks, the test tools, the deployment process and the production host. They do not fix how the folders are arranged.

## Alternatives

1. **One project, one folder per side.** Chosen. One `package.json` and one lock file at the root. Backend in `server/`, frontend in `web/`, code shared by both in `shared/`. Cost R$ 0 per month. Low maintenance.
2. **Workspaces monorepo** (`apps/api`, `apps/web`, `packages/shared`). Cost R$ 0. Stronger package boundaries, but more configuration files and a build order to maintain. Separate deployment, its main benefit, is not needed while the production host runs both sides in one process.
3. **Backend and frontend as separate packages in one folder, without a shared folder.** Cost R$ 0. Shared types would be copied or imported across folders by long paths. This weakens the reason for TypeScript in ADR 0012. Discarded.

## Decision

1. The repository root holds one package with one `package.json` and one lock file.
2. Folders:
   - `server/`: NestJS backend, with modules per domain, the Drizzle schema, migrations and the background worker entry point.
   - `web/`: React and Vite frontend.
   - `shared/`: types and business rules used by both sides.
   - `ops/`: deployment and environment scripts, owned by Infrastructure and Operations.
3. In production, the NestJS server also serves the built frontend files. The phone runs one process.
4. Code in `shared/` is imported with relative paths. No path aliases.
5. Rules:
   - `shared/` does not import from `server/` or `web/`.
   - A change to `shared/` or to an API contract requires written agreement from the Platform Engineering and Frontend Engineering sessions (`docs/SESSION-STRUCTURE.md`, sections 3.4 and 3.5).
   - Each session changes only the folder it owns, plus `shared/` under the rule above.

## Rationale

- One deployable unit matches the production phone and avoids unused separation.
- One lock file and one set of commands fit the maintenance budget of one person (`docs/06-ROADMAP.md`, section 1).
- `shared/` is the single source of truth for permissions, states and contracts, as ADR 0012 requires.
- A later move to workspaces is possible if independent deployment or a second developer is needed.

## Consequences

- One `package.json` and one lock file for the whole repository, with pinned versions (ADR 0013, ADR 0014).
- The whole package uses ES modules (ESM). Relative imports need explicit file extensions. The convention is set in the Phase 1 TypeScript configuration.
- Production installs omit development dependencies. The exact steps belong to the deployment script (ADR 0016).
- Blocking wrong imports between folders by a lint rule needs a new tool and owner approval. Not adopted now.
- Cost: R$ 0 per month.
- Revisit this decision if the frontend must be released without the backend, or if a second developer works on one side only.
