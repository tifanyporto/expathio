# 2026-11-17 — Phase 1 Database Architecture Proposal

## Goal

Propose the database architecture of Phase 1: entities, organization ownership, keys and constraints, permissions as data, test-account seed, migrations, tests on PostgreSQL in Docker (ADR 0016), and what is left out. Evaluate the draft schema on `feat/phase-1-backend-foundation` as one option. Write no application code.

Later the same day the owner reviewed the proposal (relayed by Product and Documentation). The owner asked for Alternative B (row-level security), membership history, test accounts on the phone and an updated diagram, and then approved Alternative B (Q-026) and answered Q-041 (one organization at a time). This session did not write any decision record yet.

## Scope

**In scope:** the proposal document, alternatives with cost, a visible demonstration of the entities, open questions registered with their destination function, this record.

**Out of scope:** any change to the draft schema or to branch `feat/phase-1-backend-foundation`; writing decision records in `docs/decisions/` (not yet asked for); Q-007 (PostgreSQL version on the phone), which is an input only; the deployment script; application code; the stock design by location (ADR 0017), which Product is reviewing with the store count.

## Documents Read

In order:

1. `CLAUDE.md` (at `C:\expathio\CLAUDE.md`, outside the worktree).
2. `docs/CURRENT_STATE.md`.
3. `docs/05-TECHNICAL-ARCHITECTURE.md` (read in full).
4. `docs/06-ROADMAP.md`, section 4 (Phase 1), and its section headings.
5. `docs/08-COMPANY.md`, sections 5 and 6.1.
6. `docs/02-BUSINESS-SIMULATION.md`, section 3.
7. ADR 0010, 0013, 0014, 0016, 0019, 0022, 0023, 0024, 0027, read in full. ADR 0007, 0009, 0011 and 0028 were not opened; they are used only as cited in the other documents.
8. `docs/SESSION-STRUCTURE.md`, section 3.2.
9. `docs/OPEN-QUESTIONS.md` (all entries).
10. Draft on `origin/feat/phase-1-backend-foundation`: `server/db/schema.ts` and `server/db/migrations/0000_phase1_foundation.sql` (read with `git show`; not checked out).
11. `docs/sessions/TEMPLATE.md`.

Later passes: the proposal file, the diagram, the register entries Q-026 to Q-034 and Q-041, and the status lines in `05` and `CURRENT_STATE.md`.

Not read: `docs/decisions/0011` and `0018` in full, the Platform Engineering session record, `docs/GLOSSARY.md`.

## Files Changed

| File | Change |
|---|---|
| `docs/database/phase-1-database-architecture.md` | New, revised three times. Status APPROVED by the owner on 2026-11-17 (Alternative B). Membership rule changed to one active membership per account at a time, in one organization (Q-041). Section 14 now holds the decision and the list of decision records needed. |
| `docs/database/phase-1-entities.svg` | Revised: layout fixed in an earlier pass; membership index text now "one active membership per account"; header says APPROVED. |
| `docs/OPEN-QUESTIONS.md` | Q-026 status APPROVED with the owner's answer. Q-041 status APPROVED with the owner's answer. Q-027, Q-028, Q-030, Q-031, Q-032 and Q-034 carry the owner's answers. Q-029 and Q-033 remain open (Product). Entries are closed only by the owner's answer as recorded here. Q-012 keeps its input note. Q-015 is not used. |
| `docs/CURRENT_STATE.md` | Line under "In Progress" now says APPROVED on 2026-11-17, decision record pending. |
| `docs/05-TECHNICAL-ARCHITECTURE.md` | Line under section 19.2 now says APPROVED, decision record pending. |
| `docs/decisions/0032-phase-1-database-architecture.md` | New. Decision record ADR 0032, status APPROVED, approved by the owner on 2026-11-17 (Q-026). |
| `docs/decisions/0033-membership-history-and-one-active-organization.md` | New. Decision record ADR 0033, status APPROVED. Business text from `docs/08-COMPANY.md`, section 10.6, commit `56c5e56` (branch `docs/company-revision-proposal`). |
| `docs/sessions/architecture-and-quality/2026-11-17-phase-1-database-architecture.md` | This record. |

No file under `server/`, `web/`, `shared/` or `ops/` was changed. The only files created in `docs/decisions/` are ADR 0032 and ADR 0033.

## Decisions

- Approved by the owner on 2026-11-17 (Q-026): Alternative B. Shared schema with `organization_id`; row-level security in PostgreSQL with two database roles (`expathio_owner` for migrations, `expathio_app` for the application); per-transaction context (`app.organization_id`, `app.user_id`, `app.role_key`); fail-closed policies; keys, backend rules and tests on top (`docs/database/phase-1-database-architecture.md`, sections 5, 7, 13, 14).
- Owner answers, recorded (Q-041, Q-027 and Q-032 are part of the membership rule):
  - One account is in one organization at a time. A change of organization ends the active row in the earlier organization, which stays in the history. Two active organizations at once are not accepted. Enforced by a partial unique index on `(user_id) WHERE ended_at IS NULL`.
  - One active occupant per role per organization (ADR 0007), by a partial unique index on `(organization_id, role_key) WHERE ended_at IS NULL`.
  - Membership history is kept from Phase 1 (Q-032).
- Other owner answers, recorded: test accounts and reference data on the phone (Q-031); permissions change only through the versioned file until Phase 2 (Q-034); "own" means assigned to the occupant (Q-028); customer visibility accepted as a provisional rule (Q-030).
- Not changed: the action vocabulary (`read`, `change`, `request`, `decide`) waits for Product's proposal (Q-029). Glossary terms wait for approval (Q-033).
- Choices made by this session without owner input (listed so they can be changed):
  - Branch name: see "Git" below.
  - Resource names are proposals; the messages case is part of Q-029.
  - Location of the test-account seed: `server/db/seed/`, and the Docker Compose file in `ops/`, which is Infrastructure's folder (ADR 0019).
  - Creating the two database roles: proposed for Infrastructure and Operations with Platform Engineering, not decided.
  - How RLS policies are written (schema declaration or custom SQL migration): left to the Platform Engineering session.

## Decision records

- **Record 1, architecture: ADR 0032, written 2026-11-17** at `docs/decisions/0032-phase-1-database-architecture.md`. Isolation with row-level security, database roles, context, permissions as data, migrations, tests, test accounts on the phone.
- **Record 2, business rule: ADR 0033, written 2026-11-17** at `docs/decisions/0033-membership-history-and-one-active-organization.md`. Membership history, one active membership per account at a time, one active occupant per role per organization. Business text: `docs/08-COMPANY.md`, section 10.6, commit `56c5e56` on branch `docs/company-revision-proposal` (not merged into `main`; read with `git show`). Sources: Q-027, Q-032, Q-041.

## Readiness

Records 1 and 2 are written. Implementation waits for two inputs: Q-007 (PostgreSQL version on the phone, which fixes the Docker image) and the procedure to create the two database roles (Infrastructure and Operations). Q-029 blocks only the permission seed rows.

## Tests and Results

No tests were run. This session wrote documents only, and there is no application code or database to test. The RLS design has not been run against PostgreSQL; the policies in section 5.4 are an approved design, and the tests in section 11.2 are the proof still to come. The migration of the draft was not generated or executed.

## Pending

For the owner:

- Nothing needed on the records: ADR 0032 and ADR 0033 are written.
- Q-041 and Q-026: answered and recorded; the owner closes the entries if the register convention requires it.

For Product and Documentation:

- **Q-027, Q-028:** merge the membership text of `08-COMPANY.md`, section 10.6 (commit `56c5e56`, branch `docs/company-revision-proposal`), which ADR 0033 cites; and confirm the "own" meaning in the roadmap or company text.
- **Q-029:** propose more natural action names.
- **Q-030:** confirm the provisional customer visibility rule in `08-COMPANY.md`.
- **Q-033:** approve or change the glossary terms (proposal section 3).

For other functions (inputs, not decided here):

- **Q-007** (Infrastructure and Operations): PostgreSQL and Node.js versions on the phone. The Docker image version depends on it. Also needs the creation of the two database roles on the phone and on the development computer.
- **Q-006**: hosting for Phase 4; decides the Phase 4 database cost.
- **Q-009**: rollback steps. Drizzle has no down migrations (proposal, section 10.3).
- **Q-002**: personal data rules, which affect the account removal rule in proposal section 7.4.
- **ADR 0017** (stock by location): Product reviews the store count and roles; not designed here.

Pending in the Platform Engineering branch: the draft schema needs the changes in proposal section 12 and a regenerated migration. This is not done here. ADR 0032 is written, so the rebuild can start; the Platform Engineering session is asked to do it.

## Git

- Local branch: `claude/arch-database-proposal-60270d` (the worktree's branch).
- Remote branch: the brief named `arch-database-proposal`. `CLAUDE.md`, section 7, requires the form `tipo/descricao-curta`, so the push uses `docs/arch-database-proposal`. The name is a choice of this session and can be renamed by the owner.
- Commit messages in English, imperative, with no co-author line (`CLAUDE.md`, section 7).
- Not merged into `main`.

## How to Resume

Read in this order:

1. `CLAUDE.md`, sections 2, 5, 7 and 8.
2. `docs/database/phase-1-database-architecture.md`, sections 0, 1 and 14 (revision notes, summary, decision and decision records).
3. `docs/OPEN-QUESTIONS.md`, entries Q-026 to Q-034 and Q-041.
4. This record, "Decision records" and "Pending".

Starting point: ADR 0032 and ADR 0033 are written. Next: the Platform Engineering rebuild, and Product's merge of `08-COMPANY.md`, section 10.6.

Already decided by the owner: Alternative B (Q-026), one organization at a time (Q-041), membership history (Q-032), test accounts on the phone (Q-031), permissions changed only through the file until Phase 2 (Q-034). Not to be asked again: whether the four roles and their titles are loaded as data (ADR 0024 and 0027), and whether Phase 1 uses test accounts only (ADR 0022).

Must not be changed: the draft schema and branch `feat/phase-1-backend-foundation`, until the Platform Engineering session rebuilds it from ADR 0032.

## Next Step

1. Done: ADR 0032 is written.
2. Done: ADR 0033 is written from `docs/08-COMPANY.md`, section 10.6 (commit `56c5e56`).
3. Platform Engineering is asked, through a direct message, to rebuild the draft as section 12 of the proposal describes, from ADR 0032.
