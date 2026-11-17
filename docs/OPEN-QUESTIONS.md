# Expathio — Open Questions

**Status:** APPROVED  
**Document type:** Question register  
**Project:** Expathio  
**Owner of this file:** Product and Documentation (`docs/SESSION-STRUCTURE.md`, section 3.1)

---

## How to Use This File

- One entry per open question. A question that needs a decision from another session goes here, not only in that session's record.
- The session that has the question adds the entry, with the function it is addressed to.
- The session that answers writes the answer in the entry, and links the decision record (`docs/decisions/`) if one was made.
- No session closes an entry on its own. Only the owner closes it (`CLAUDE.md`, section 5).
- Statuses follow `CLAUDE.md`, section 4. Use PROPOSED for questions not yet discussed, and IN DISCUSSION for questions being evaluated.
- Decisions are not recorded here. They go to `docs/decisions/`, and the entry only points to them.

---

## Entries

### Q-001 — Stock transfers between locations

- **Status:** PROPOSED
- **Asked by:** Product and Documentation
- **Answered by:** Product and Documentation, approved by the owner
- **Needed by:** before Phase 3
- **Source:** `02-BUSINESS-SIMULATION.md`, section 15, question 13

### Q-002 — Participant privacy and data rights

- **Status:** PROPOSED
- **Asked by:** Product and Documentation
- **Answered by:** Product and Documentation, approved by the owner
- **Needed by:** before Phase 4 admits the first real participant
- **Question:** which account data is collected and why, who can see it, how long it is kept, and how a participant exports or deletes it. LGPD applies.
- **Source:** `01-PRODUCT.md`, section 12

### Q-003 — Simulated-day mechanics

- **Status:** PROPOSED
- **Asked by:** Product and Documentation
- **Answered by:** Product and Documentation, with the Simulation Engine session when it is active
- **Needed by:** Phase 5
- **Source:** `02-BUSINESS-SIMULATION.md`, section 11

### Q-004 — Open questions in later documents

- **Status:** PROPOSED
- **Asked by:** Product and Documentation
- **Answered by:** Product and Documentation, approved by the owner
- **Needed by:** `03` before Phase 4; `04` before Phase 6; `07` before Phase 7
- **Source:** schedule approved by the owner on 2026-11-04 (`CURRENT_STATE.md`, approved decisions)

### Q-005 — GitHub connection mechanism

- **Status:** PROPOSED
- **Asked by:** Product and Documentation
- **Answered by:** owner
- **Needed by:** no phase set; the owner decides when to specify it
- **Question:** how a participant connects a real GitHub account to the simulation (`01-PRODUCT.md`, approved decision `0002`)

### Q-006 — Hosting decision for Phase 4

- **Status:** PROPOSED
- **Asked by:** Product and Documentation
- **Answered by:** Architecture and Quality and Infrastructure and Operations, approved by the owner
- **Needed by:** before the first participant is admitted to the platform
- **Source:** ADR 0011 (initial host, through Phase 3)

### Q-007 — PostgreSQL and Node.js versions on postmarketOS

- **Status:** PROPOSED
- **Asked by:** Architecture and Quality
- **Answered by:** Infrastructure and Operations
- **Needed by:** before the Phase 1 development setup is finished
- **Source:** `05-TECHNICAL-ARCHITECTURE.md`, section 19

### Q-008 — Continuous integration tool

- **Status:** PROPOSED
- **Asked by:** Architecture and Quality
- **Answered by:** Architecture and Quality, approved by the owner
- **Needed by:** deferred; to be decided when manual test runs become error-prone (ADR 0016)

### Q-009 — Rollback steps of the deployment script

- **Status:** PROPOSED
- **Asked by:** Architecture and Quality
- **Answered by:** Infrastructure and Operations
- **Needed by:** Phase 1, when the deployment script is built (ADR 0016)

### Q-010 — Visual specification

- **Status:** IN DISCUSSION
- **Asked by:** Product and Documentation
- **Answered by:** Experience and Design, approved by the owner
- **Needed by:** before the first Phase 1 screen is built
- **Source:** `09-DESIGN-SYSTEM.md` is a direction only. A visual specification is in progress on branch `design/especificacao-visual`.

### Q-011 — Phase 1 screen map and application shell

- **Status:** PROPOSED
- **Asked by:** Product and Documentation
- **Answered by:** Experience and Design, approved by the owner
- **Needed by:** before the first Phase 1 screen is built
- **Question:** the Phase 1 screens are the login (test accounts only, ADR 0022) and an application shell with header, content area and a place for navigation. Which screens exist in each phase, and what the navigation contains from Phase 2 on. Navigation items stay undefined in Phase 1.
- **Source:** `06-ROADMAP.md`, section 4
- **Owner answers (2026-11-09), for Phase 1 screens:**
  - No navigation menu in Phase 1. Its content is not defined, so it does not enter Phase 1.
  - No member list of MONUMENT. Phase 1 shows only the logged-in account. This is already the post-login page (ADR 0028), so no separate members screen.
  - Basic user management (`06-ROADMAP.md`, section 4, item 5) is read-only: it shows the data of the test account. No create, edit or deactivate actions, because there is no backend CRUD in Phase 1.
  - Whether a separate roles screen exists in Phase 1 is still open. Product's recommendation is no: the role already appears on the post-login page, and the four roles are loaded as data with no behavior (ADR 0024).
  - The label for simulated data was already shown in the Experience session's demonstration. It awaits the owner's approval as a visual decision (`CLAUDE.md`, section 12).
  - The typeface is approved (ADR 0021). The visual specification (Q-010) is still in discussion.
- **Experience and Design is asked to:** redraw the Phase 1 screens with these answers (login, post-login page with the logged-in account, read-only user management), and demonstrate each one visually. Navigation items and any roles screen remain for the owner to decide. Who may see each piece of data is not part of this design; it belongs to the access rules in `08-COMPANY.md`, section 6.1.

### Q-012 — Adding a role without a code change

- **Status:** PROPOSED
- **Asked by:** Product and Documentation
- **Answered by:** Architecture and Quality, approved by the owner
- **Needed by:** before the first role is added after the four in ADR 0009
- **Question:** can a role that uses only existing functions be stored as data, without a code change? Product recommends yes, for that case only.
- **Source:** `08-COMPANY.md`, section 9; ADR 0009 says the workflow decision must be revisited before a new role is added
- **Input (Architecture and Quality, 2026-11-17, not an answer):** in the proposal `docs/database/phase-1-database-architecture.md`, roles and permissions are stored as data (section 8). A role that uses only existing resources can be added as data. A new resource still needs a code change, because the resource list is in the seed file. Entry stays open for the owner.

### Q-013 — Function catalog

- **Status:** PROPOSED
- **Asked by:** Product and Documentation
- **Answered by:** Product and Documentation, approved by the owner
- **Needed by:** when the first Phase 1 functions are specified
- **Question:** the list of existing functions, with the records each one uses and the roles that use it (`08-COMPANY.md`, section 9)

### Q-016 — Who creates the Expathio logo, and the MONUMENT visual identity

- **Status:** IN DISCUSSION
- **Asked by:** Experience and Design (through the owner)
- **Answered by:** Experience and Design, approved by the owner
- **Needed by:** before the logo appears in any screen. The text "Expathio" is used until then (ADR 0028).
- **Answer (owner, 2026-11-06):** Experience and Design creates the logo.
- **Still open:** how the artwork is made (by hand, with a tool, or by an external designer). Experience and Design proposes the options. A paid designer needs the owner's approval (`CLAUDE.md`, section 2).
- **Also open:** the MONUMENT visual identity. `08-COMPANY.md`, section 2, refers to a "company's visual specification" that does not exist yet. Experience and Design is the natural owner, but this is not yet confirmed.

### Q-014 — Lint rule for imports between folders

- **Status:** PROPOSED
- **Asked by:** Architecture and Quality
- **Answered by:** Architecture and Quality, approved by the owner
- **Needed by:** deferred
- **Question:** whether a lint tool should block imports that cross folder rules (ADR 0019, consequences). Adding a new tool needs the owner's approval.

### Q-026 — Approve the Phase 1 database architecture

- **Status:** PROPOSED
- **Asked by:** Architecture and Quality
- **Answered by:** owner
- **Needed by:** before the Platform Engineering session rebuilds the draft schema (branch `feat/phase-1-backend-foundation`, on hold)
- **Question:** approve Alternative B (recommended since 2026-11-17) of `docs/database/phase-1-database-architecture.md` (shared schema, `organization_id` on organization-owned tables, composite keys, isolation tests, permissions as seeded data). Row-level security is part of this recommendation (owner: do not limit the choice by complexity).
- **Owner review (2026-11-17, relayed by Product and Documentation):** asked for the proposal to be revised with Alternative B recommended, the diagram updated and the schema changes shown. Approval waits for the owner to see the diagram.
- **Source:** `docs/database/phase-1-database-architecture.md`, sections 13 and 14

### Q-027 — Can one account hold more than one role in one organization?

- **Status:** PROPOSED
- **Asked by:** Architecture and Quality
- **Answered by:** Product and Documentation, approved by the owner
- **Needed by:** before the membership unique constraints are written
- **Question:** the proposal allows one role per account per organization. ADR 0007 says one occupant per role, and does not say whether one person can hold two roles. Is the rule correct?
- **Owner answer (2026-11-17, relayed by Product and Documentation):** one role at a time per account in one organization. Product to confirm the rule in its documents.
- **Source:** `docs/database/phase-1-database-architecture.md`, section 7.3; ADR 0007

### Q-028 — What "own" means for tasks, cases and messages

- **Status:** PROPOSED
- **Asked by:** Architecture and Quality
- **Answered by:** Product and Documentation, approved by the owner
- **Needed by:** before the permission rows for tasks, cases and messages are seeded
- **Question:** `08-COMPANY.md`, section 6.1, says "own cases", "own tasks" and "own role" messages, but does not define "own". Does it mean assigned to the occupant, created by the occupant, or belonging to the occupant's role area? The "Read (only the customer's own orders, for a case)" row is a different meaning: orders of a customer in an open case. Which definition applies to each row?
- **Owner answer (2026-11-17, relayed by Product and Documentation):** "own" means assigned to the occupant of the role. Product to confirm in its documents.
- **Source:** `docs/08-COMPANY.md`, section 6.1; `docs/database/phase-1-database-architecture.md`, section 8

### Q-029 — Vocabulary of permission actions

- **Status:** PROPOSED
- **Asked by:** Architecture and Quality
- **Answered by:** Product and Documentation, approved by the owner
- **Needed by:** before the permission rows are seeded
- **Question:** the proposal uses four actions: `read`, `change`, `request` and `decide`. Are these the right words for the matrix? Does sending an internal message count as `change`, or is it a separate action? For refund and exchange requests, does "Finance Assistant: read; approves or rejects" need both `read` and `decide`?
- **Owner note (2026-11-17, relayed by Product and Documentation):** the owner finds the four names mechanical and asked that they not be changed yet. Product will propose more natural names. Still open.
- **Source:** `docs/database/phase-1-database-architecture.md`, sections 8.2 and 8.3

### Q-030 — Which customer data each role may see

- **Status:** PROPOSED
- **Asked by:** Architecture and Quality
- **Answered by:** Product and Documentation, approved by the owner
- **Needed by:** before the first Phase 2 customer table is designed
- **Question:** `08-COMPANY.md`, section 6.1, does not say which personal data of a customer each role may see. For example, may Operations Assistants see a customer's contact details, or only the order? May Sales Support see contact history? The database must know which columns to protect, so this rule has to be written as a business rule.
- **Owner answer (2026-11-17, relayed by Product and Documentation):** accepted as a provisional recommendation: Customer Service sees contact details in the service; Operations sees the order and delivery, without contact; Sales Support sees no contact; Finance sees amounts, without contact. The schema is to be prepared for protected columns. Product to confirm in its documents.
- **Source:** `docs/08-COMPANY.md`, sections 5 and 6.1; `docs/database/phase-1-database-architecture.md`, sections 8.4 and 12

### Q-031 — Test accounts on the production phone

- **Status:** PROPOSED
- **Asked by:** Architecture and Quality
- **Answered by:** owner
- **Needed by:** before the first deployment of Phase 1
- **Question:** should the phone hold the four test accounts and the MONUMENT seed, so the owner can sign in there, or should test accounts exist only in the test setup and on the development computer? The seed of reference data (roles and permissions) runs on the phone in both cases.
- **Owner answer (2026-11-17, relayed by Product and Documentation):** approved. Test accounts stay on the phone, together with the MONUMENT reference data.
- **Source:** ADR 0022; `docs/database/phase-1-database-architecture.md`, section 9

### Q-032 — Membership history from Phase 1

- **Status:** PROPOSED
- **Asked by:** Architecture and Quality
- **Answered by:** owner
- **Needed by:** before the first role change or departure is built (ADR 0007)
- **Question:** should memberships keep their history (each role change and departure, with dates) from Phase 1, or store only the current membership? The proposal stores only the current state and records the choice as open, because `05-TECHNICAL-ARCHITECTURE.md`, section 12, asks for history of permission changes.
- **Owner answer (2026-11-17, relayed by Product and Documentation):** keep the membership history from Phase 1, with start and end dates. Reasons given: promotions, changing company and, later, the weight of each company in a career.
- **Source:** ADR 0007; `docs/05-TECHNICAL-ARCHITECTURE.md`, section 12; `docs/database/phase-1-database-architecture.md`, sections 7.3 and 15

### Q-033 — Terms for accounts and tables in the glossary

- **Status:** PROPOSED
- **Asked by:** Architecture and Quality
- **Answered by:** Product and Documentation, approved by the owner
- **Needed by:** before Phase 1 code is written
- **Question:** the library table `account` (login method) and the business "account" have the same word. Should `docs/GLOSSARY.md` define "account", "membership", "role", "permission" and "test account" with the meanings of `docs/database/phase-1-database-architecture.md`, section 3?
- **Owner note (2026-11-17, relayed by Product and Documentation):** section 3 of the proposal is the proposed text. The owner will approve it after the demonstration. Still open.
- **Source:** `docs/database/phase-1-database-architecture.md`, section 3; `docs/GLOSSARY.md`

### Q-034 — Runtime editing of permissions

- **Status:** PROPOSED
- **Asked by:** Architecture and Quality
- **Answered by:** owner
- **Needed by:** before Phase 2 (when roles get behavior)
- **Question:** should the permission rows be changed only through the versioned file and a deployment (the proposal), or should the owner be able to edit them in the application? Editing in the application needs an administration screen and an audit record, which are not in Phase 1.
- **Owner answer (2026-11-17, relayed by Product and Documentation):** until Phase 2, permissions change only through the versioned file and a deployment. No editing in the application now.
- **Source:** `docs/database/phase-1-database-architecture.md`, section 8.1

### Q-035 — One account in two organizations at the same time

- **Status:** PROPOSED
- **Asked by:** Architecture and Quality
- **Answered by:** owner
- **Needed by:** before Phase 2, when a second organization or a second membership is possible
- **Question:** can one account hold an active membership in two organizations at the same time? The owner's answer on Q-027 (one role per account per organization) does not say. The proposed schema allows it (the unique rules are per organization). Should it be allowed, or should a change of organization end the active membership in the other one?
- **Source:** `docs/database/phase-1-database-architecture.md`, sections 7.3 and 14; `docs/decisions/0010-scalability-foundations.md`
