# 2026-11-05 — Phase 1 Code Layout

## Goal

Choose the folder layout for the Phase 1 application code. The layout is open in `docs/CURRENT_STATE.md` (section Open) and in `docs/SESSION-STRUCTURE.md` (section 7), and it blocks the start of the Platform Engineering and Frontend Engineering sessions.

This session decides and documents the options. It does not create folders or code.

## Scope

- In scope: three layout options, their cost, maintenance, fit with the Platform and Frontend sessions; a recommendation; a decision record (ADR) proposal, later approved and filed as ADR 0019; the owner's pending decisions.
- Added after owner approval on 2026-11-05: `docs/decisions/0019-phase-1-code-layout.md`, status APPROVED.
- Added on 2026-11-05 at the owner's request: `docs/05-TECHNICAL-ARCHITECTURE.md`, section 19 (rewritten into "Decided" and "Still open") and section 21 (three risks from ADR 0019). Section 16 was compared with ADR 0016; the owner chose option 1, and a status note was added to section 16. The ADRs were not changed.
- Out of scope: creating any folder or code; the Phase 1 test folder details (to be fixed by the sessions that write the tests); the PostgreSQL and Node.js version check on the phone (Infrastructure and Operations); the better-auth compatibility check with NestJS 12 (Platform Engineering, ADR 0014).

## Documents Read

1. `CLAUDE.md` (sections 1 to 14).
2. `docs/CURRENT_STATE.md`.
3. `docs/SESSION-STRUCTURE.md`, sections 1 to 7.
4. `docs/sessions/architecture-and-quality/2026-11-04-phase-0-practices.md` (last record of this function).
5. `docs/sessions/TEMPLATE.md`.
6. `docs/decisions/0010-scalability-foundations.md`.
7. `docs/decisions/0012-initial-technology-direction.md`.
8. `docs/decisions/0013-backend-framework-and-orm.md`.
9. `docs/decisions/0014-remaining-stack-tools.md`.
10. `docs/decisions/0015-development-environment-and-repository.md`.
11. `docs/decisions/0016-testing-and-deployment-strategy.md`.
12. `docs/05-TECHNICAL-ARCHITECTURE.md`, all sections (section 5 and sections 3, 8, 16 and 21 were the most relevant).
13. `docs/decisions/0011-initial-host.md` and `docs/decisions/0018-dedicated-production-phone.md` (checked for section 19).

Git: `git pull` returned "Already up to date". Branch `docs/phase-1-code-layout` was created from `main` (commit `50cc0df`). No commit was made.

## Constraints Taken From Approved Decisions

- **One language.** TypeScript for backend and frontend, so that rules and types can be shared (ADR 0012).
- **Two sides, one product.** Backend in NestJS 12 with Drizzle (ADR 0013). Frontend in React 19, Vite 8 and TanStack Query (ADR 0014). The product is a web application (ADR 0012).
- **Shared types and rules.** ADR 0012 gives shared types for permissions, task states and events as a reason for TypeScript. The layout must make sharing easy and safe.
- **Stateless instances and file storage behind an abstraction** (ADR 0010). The layout must not assume one fixed machine path for files.
- **Three test levels** (ADR 0016): unit (Vitest), integration with PostgreSQL in Docker (Vitest), browser flows (Playwright). Migrations are files that ship with each schema change.
- **Deployment copies the tested version to the phone** and runs migrations, restart and a health check (ADR 0016). The phone runs only deployed versions, and nothing is developed there (ADR 0015).
- **Background jobs** use pg-boss inside PostgreSQL (ADR 0014). Separate worker processes are a future configuration (ADR 0010), not a Phase 1 need.
- **Public repository, no secrets** (ADR 0012). Environment files stay out of the repository.
- **Stable versions and pinned locks** (ADR 0013, ADR 0014). One lock file per installable package.
- **Maintenance first.** One person, 5 to 10 hours per week (`docs/06-ROADMAP.md`, section 1). Every extra config file, build step or package boundary costs time that comes from the same budget.

## Options

### Option A — One project, one folder per side (recommended)

Structure:

```
expathio/
  package.json          one package, one lock file
  package-lock.json
  tsconfig.json         base settings
  server/               NestJS backend: modules per domain, Drizzle schema, migrations, worker entry
  web/                  React and Vite frontend: index.html, src/
  shared/               types and rules used by both sides
  ops/                  deployment and environment scripts (Infrastructure and Operations)
  docs/
```

How it runs:
- Development: Vite serves `web/` and forwards API calls to the Nest server.
- Production: one build produces the server output and the web output. The Nest server also serves the web output, so the phone runs one process.

- Cost: R$ 0. No new tool or service.
- Maintenance: low. One package.json, one lock file, one set of build and test commands.
- Gains: simplest setup; the phone receives one artifact; `shared/` is imported with normal relative paths, with no path aliases; one command runs all tests.
- Losses: frontend and backend libraries share one dependency list, so a backend file could import a frontend library by mistake. This is controlled by review now and by a lint rule later (a new tool, which needs approval). Separate versioning and separate deployment are not possible without a later move.
- Platform Engineering fit: owns `server/` and the schema and migration files; contributes to `shared/` with the Frontend session.
- Frontend Engineering fit: owns `web/`; reads contracts and shared types from `shared/`.

### Option B — Workspaces monorepo (`apps/` and `packages/`)

Structure:

```
expathio/
  package.json          workspace root, one lock file
  apps/api/             NestJS backend, own package.json
  apps/web/             React and Vite frontend, own package.json
  packages/shared/      shared types and rules, own package.json
```

"Workspaces" is a built-in npm feature that links several packages inside one repository. No extra tool is needed.

- Cost: R$ 0.
- Maintenance: medium. Each package has its own configuration files. `packages/shared` must be built, or its TypeScript source must be consumed, before the other two packages use it, so the build order matters. Tests are configured per package.
- Gains: strict boundaries; a package cannot import another package's internals; matches the `apps/` and `packages/` names mentioned as common in `SESSION-STRUCTURE.md`, section 7.
- Losses: about twice the configuration files; more cases where a build step is forgotten; the benefit of separate deployment is not used, because the phone runs both sides in one process.
- Platform Engineering fit: owns `apps/api`; the shared package has a clear name, but ownership must still be agreed.
- Frontend Engineering fit: owns `apps/web`; imports `packages/shared` as a dependency.

### Option C — Backend and frontend as separate packages in one folder, no shared folder

Structure:

```
expathio/
  backend/              own package.json
  frontend/             own package.json
```

- Cost: R$ 0.
- Maintenance: high. Shared types would be either copied in both packages (two sources of truth, which ADR 0012 wants to avoid) or imported with long relative paths across folders (fragile, and it breaks the build of each side on its own).
- Gains: a clear split between the two sides, without a shared folder.
- Losses: the main reason for TypeScript in ADR 0012 (shared types) becomes harder. Two lock files, two sets of tests, two build pipelines to maintain.
- Platform Engineering and Frontend Engineering fit: workable, but each session would need to keep copies of the same types in sync by hand.
- Recommendation: not recommended. Listed because it matches the request's option (b).

## Comparison

| Point | A: one project | B: workspaces | C: two packages, no shared folder |
|---|---|---|---|
| Monthly cost | R$ 0 | R$ 0 | R$ 0 |
| Maintenance (one person) | Low | Medium | High |
| Config files to keep | 1 set | 3 sets + workspace root | 2 sets, plus manual type sync |
| Shared types and rules | Plain relative imports | Package import; build order matters | Copies or fragile cross-folder paths |
| Boundary between sides | Review now; lint rule later (needs approval) | Enforced by the package system | Enforced by folders only |
| Separate deployment | Not possible without a later move | Possible, not needed now | Possible, not needed now |
| Fit with Platform session | Owns `server/`; shared by agreement | Owns `apps/api` | Owns `backend/`; syncs types by hand |
| Fit with Frontend session | Owns `web/` | Owns `apps/web` | Owns `frontend/`; syncs types by hand |

## Recommendation

**Option A.**

Reasons:
1. The phone runs one process that serves the API and the web files. One artifact is deployed, so separate packages give no benefit now.
2. One person maintains everything. One lock file and one set of commands cost less time than two sets.
3. `shared/` gives the single source of truth for permissions and states that ADR 0012 asks for, with imports that need no configuration.
4. If a separate deployment or a separate worker process is needed later, the move to Option B is a folder move plus configuration. ADR 0010 allows a separate worker through configuration, and the same codebase can start a second entry point under Option A.

Trigger to revisit: a need to release the frontend without the backend, or a second developer working on one side only.

## Technical Notes for Option A (for the Phase 1 sessions)

- NestJS 12 and the other libraries in ADR 0013 and ADR 0014 are ES modules (ESM, the modern JavaScript module system). ESM applies to the whole package, so `"type": "module"` will apply to the server and web code. Relative imports in ESM need explicit file extensions (for example `./user.js` for a `.ts` file), so this convention must be set in the Phase 1 TypeScript configuration.
- Production install on the phone should omit development dependencies (`npm ci --omit=dev`). Web libraries are bundled into the web output at build time, so the phone does not need them at runtime. The exact deploy steps belong to the deployment script (Infrastructure and Operations, ADR 0016).
- Playwright browser tests run only on the Windows computer (ADR 0016), so the phone does not need browsers.
- The Node.js version on the phone must support ESM and NestJS 12. The check is pending (ADR 0014 consequences, `docs/CURRENT_STATE.md`).
- Test file placement (for example, tests next to the code, and browser flow tests in an `e2e/` folder) is a detail for Platform Engineering and Frontend Engineering to fix in Phase 1. It does not need a separate decision.

## Decision (APPROVED by the owner on 2026-11-05)

The decision was proposed in this session as a provisional ADR 0019, and the owner approved Option A on 2026-11-05. The approved record is `docs/decisions/0019-phase-1-code-layout.md`.

**Title:** Phase 1 source code layout

**Status:** APPROVED

**Context:** The Phase 1 folder layout is open. Approved decisions ADR 0010, 0012, 0013, 0014, 0015 and 0016 fix the language, the frameworks, the tests, the deployment and the single production host. They do not fix how the folders are arranged.

**Alternatives:** A (one project, folders `server/`, `web/`, `shared/`), B (workspaces with `apps/` and `packages/`), C (two packages in one folder, no shared folder). See the options above.

**Decision (proposed):** Option A. One package at the repository root. Backend code in `server/`, frontend code in `web/`, code shared by both in `shared/`, deployment scripts in `ops/`. The Nest server serves the built web files in production. Shared code is imported with relative paths.

**Rules proposed with the decision:**
1. `shared/` does not import from `server/` or `web/`.
2. A change to `shared/` or to an API contract needs written agreement from both the Platform Engineering and the Frontend Engineering sessions (`docs/SESSION-STRUCTURE.md`, sections 3.4 and 3.5).
3. Each session changes only the folder it owns, plus `shared/` under rule 2. `ops/` belongs to Infrastructure and Operations.

**Justification:** Lowest maintenance for one person. No extra cost. One deployable unit that matches the phone setup. Shared types without copies.

**Consequences:**
- One `package.json` and one lock file for the whole repository, pinned as ADR 0013 and ADR 0014 require.
- The whole package is ESM.
- A lint rule to block wrong imports between folders would need a new tool. Not proposed now; requires owner approval.
- Moving to Option B later is possible (see the revisit trigger).
- Cost: R$ 0 per month.

## Tests and Results

Nothing was executed. There is no application code. `git pull` returned "Already up to date". Branch `docs/phase-1-code-layout` was created from `main`. No commit and no push. Documents were checked by reading; no build or test exists to run.

## Documents Changed

- `docs/sessions/architecture-and-quality/2026-11-05-phase-1-code-layout.md`: created by this session, then updated.
- `docs/decisions/0019-phase-1-code-layout.md`: created by this session, status APPROVED (2026-11-05).
- `docs/decisions/0020-release-history-and-versioning.md`: created by this session, status APPROVED (2026-11-05).
- `docs/05-TECHNICAL-ARCHITECTURE.md`: section 19 rewritten (19.1 Decided with ADR numbers; 19.2 Still open); three rows added to section 21 (risk register) for ADR 0019. Section 16: status note added (owner chose option 1: CI and code review deferred, per ADR 0016 and ADR 0015).
- Branch `docs/phase-1-code-layout` was created from `main`. No commit.

## Decisions

- Proposed (not approved): none remaining.
- Approved by the owner on 2026-11-05:
  - Option A (one project with `server/`, `web/`, `shared/` and `ops/`). Recorded as `docs/decisions/0019-phase-1-code-layout.md`.
  - The three rules for `shared/` and API contracts.
  - The start order: Platform Engineering first, then Frontend Engineering with Experience and Design.
- Approved by the owner on 2026-11-05 (section 16): option 1. The status note in section 16 of `05-TECHNICAL-ARCHITECTURE.md` describes CI and code review as deferred. ADR 0015 and ADR 0016 are unchanged.
- Approved by the owner on 2026-11-05: GitHub Actions (CI) stays deferred until the project has code. Revisit when the first tests exist (likely end of Phase 1 or start of Phase 2). CI cannot deploy to the phone, which is on a private network (ADR 0011), so deployment stays with the script. Any adoption needs a new ADR and owner approval.
- Approved by the owner on 2026-11-05 (release history): accepted the recommendation. Tags `vMAJOR.MINOR.PATCH`, `0.x` until Phase 5, `1.0.0` at the end of Phase 5; `CHANGELOG.md` at the root; a GitHub Release per tag, approved for each one; deployment log written by the script. Recorded as `docs/decisions/0020-release-history-and-versioning.md`, status APPROVED.
- Left to Phase 1 (not decided here): the tag check inside the deployment script, to be specified by Infrastructure and Operations.
- Not adopted: a lint tool to block wrong imports between folders. Needs owner approval when it is proposed. A plain-language explanation was given in the session on 2026-11-05.

## Lint: Explanation and Options (no decision, nothing installed)

**What a lint is.** A lint is a program that reads source code without running it and reports problems: unused variables, risky patterns, or rules the project sets. The best-known one for TypeScript is ESLint. A lint can be told a rule such as "files in `web/` may not import from `server/`". Then the check happens automatically, not only by reading the code.

**Options to block wrong imports between `server/`, `web/` and `shared/`:**

| Option | What it is | Cost | Maintenance |
|---|---|---|---|
| 1. No tool | The rules of ADR 0019 are checked by reading the code before each merge. | R$ 0 | None technical. Depends on attention, which fails silently when the project grows. |
| 2. ESLint with the `no-restricted-imports` rule | ESLint is an open-source lint program. The rule lists the forbidden import paths. Needs one new library and one configuration file. | R$ 0 | Low to medium. Keep ESLint and its TypeScript plugin updated; one more step in the test run. Needs owner approval because it is a new dependency. |
| 3. ESLint with a boundaries plugin (for example `eslint-plugin-boundaries`) | Same ESLint, with a plugin that names each folder as a zone and decides which zones may import which. Clearer rules when there are many folders. | R$ 0 | Medium. One more library to keep updated and a more detailed configuration. Needs owner approval. |
| 4. TypeScript project references | A built-in TypeScript feature. Each folder is a separate project declared as a dependency of another. The compiler refuses an import that is not declared. No new library. | R$ 0 | Medium to high. Configuration is more involved and error messages can be hard to read. Behaviour to be checked before any decision. |
| 5. dependency-cruiser | An open-source tool that reads the imports, checks them against rules in a configuration file, and can draw a diagram of the dependencies. | R$ 0 | Low to medium. One new library and one configuration file. The diagram helps learning. Needs owner approval. |

The options are not compared as a recommendation. The owner decides.

## Section 16 Compared With ADR 0016 (divergences, not changed)

Section 16 of `05-TECHNICAL-ARCHITECTURE.md` lists what the project "should support". ADR 0016 is the approved decision. The comparison:

1. **CI/CD pipelines.** Section 16 lists them as supported. ADR 0016 defers continuous integration: tests run by hand before each merge. **Divergence.**
2. **Code review practices.** Section 16 lists them. ADR 0015 has no pull requests, and the owner merges alone. **Divergence.**
3. **Release history.** Section 16 lists it. ADR 0016 does not define how releases are recorded, for example tags. **Gap, not a contradiction.**
4. **Rollback strategies.** Section 16 lists them. ADR 0016 defines the direction (keep the previous version, reverse the migration or restore the backup), and the steps are to be written in Phase 1. **Consistent, with the steps pending.**
5. Automated tests, migrations, deployment validation, environment configuration, separate environments and a controlled deployment process match ADR 0015 and ADR 0016. **Consistent.**

Per the owner's instruction, the ADR is not rewritten. Question for the owner: should section 16 follow ADR 0016 (CI deferred, no code review) with a note, or should ADR 0016 be revisited?

## Pending

Routed to Product and Documentation (owner of `CURRENT_STATE.md` and `SESSION-STRUCTURE.md`):
- Update `docs/SESSION-STRUCTURE.md`, section 7: the layout question is closed by ADR 0019.
- Update `docs/CURRENT_STATE.md`: add ADR 0019 to Approved Decisions and remove the layout item from Open.

Owner's action:
- Install Docker Desktop and WSL2 on the Windows computer (ADR 0015). Required before Phase 1 starts.

Outdated statement to route (not changed here, the ADR is not rewritten):
- ADR 0016 (Consequences, and the CI rationale) says the repository "is not yet created" on GitHub. The owner confirmed on 2026-11-05 that the repository already exists on GitHub. Check the remote: `origin` points to the public repository, and its `main` branch exists there. Product and Documentation should record this in the "Open Inconsistencies" section of `CURRENT_STATE.md`, and the owner decides whether ADR 0016 needs a note.
- Effect on the open options: GitHub Releases (see the release question) becomes available once the owner approves it. Continuous integration (GitHub Actions) is technically possible now, but it stays deferred under ADR 0016 for the other reasons given there (one person, cost of setup and maintenance). This is for the owner to revisit.

Other sessions (not blocking the layout):
- Infrastructure and Operations: check the PostgreSQL and Node.js versions on the phone against Docker (ADR 0011, ADR 0014).
- Platform Engineering: confirm better-auth compatibility with NestJS 12 before implementing login (ADR 0014).
- Platform Engineering and Frontend Engineering: decide where tests live inside the folders, in Phase 1.

Owner's decision:
- Lint tool to block wrong imports between folders. Options and costs are in "Lint: Explanation and Options". Nothing was installed. The owner decides later; any option needs approval because it adds a library, except option 4, which is built into TypeScript.
- Section 16 divergences (CI/CD and code review): resolved by option 1 (see "Decisions"). Release history: resolved by ADR 0020. Its deployment tag check is a Phase 1 item.

## How to Resume

Read in this order:
1. `CLAUDE.md`, section 14.
2. `docs/CURRENT_STATE.md`, section Open.
3. `docs/decisions/0012-initial-technology-direction.md` and `docs/decisions/0016-testing-and-deployment-strategy.md`.
4. This record, section "Decision", and `docs/decisions/0019-phase-1-code-layout.md`.

Starting point: ADR 0019 is APPROVED (Option A). Do not re-ask the layout, the shared-folder rules or the start order. Do not re-ask the language, framework, ORM, test tools, branch policy or deployment strategy: they are approved in ADR 0012 to ADR 0016.

## Next Step

Route the `CURRENT_STATE.md` and `SESSION-STRUCTURE.md` updates to Product and Documentation. Then start the Platform Engineering session, once the owner has installed Docker Desktop and WSL2.
