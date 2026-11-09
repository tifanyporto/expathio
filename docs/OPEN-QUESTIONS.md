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

- **Status:** IN DISCUSSION (local part proposed; phone part open and owner-only)
- **Asked by:** Architecture and Quality
- **Answered by:** Infrastructure and Operations
- **Needed by:** before the Phase 1 development setup is finished
- **Source:** `05-TECHNICAL-ARCHITECTURE.md`, section 19
- **Question:** which PostgreSQL and Node.js versions to use, so that the local computer and the phone match (ADR 0015).

**Local part — proposal from Infrastructure and Operations (2026-11-09), for owner approval:**

1. **PostgreSQL 18.4 in Docker** (`postgres:18.4`, file `ops/docker-compose.yml`). The current major line, supported until 2030 according to secondary sources. Alternative: PostgreSQL 17, supported until 2029. Cost R$ 0. The minor version must be checked on postgresql.org before the first image download, and the pin updated if a newer minor exists.
2. **Node.js 24** (file `ops/.nvmrc`). Already installed on the computer as v24.12.0. Secondary sources say Node 24 moves to maintenance in October 2026, and Node 26 starts its LTS line in October 2026. Alternative: Node 26 once it is confirmed as LTS on nodejs.org. Recommendation: keep 24 for Phase 1 and decide on 26 when Platform Engineering starts. Cost R$ 0.
3. **Docker Desktop** is already approved by ADR 0015. It is not a new tool, but the owner installs it (`ops/local-setup.md`, section 2).

Facts found on 2026-11-09 (real output, see the session record): Docker is **not installed**; Node v24.12.0; psql 16.13; a **Windows PostgreSQL 16 server** is running on port 5432. Expathio uses port 5433 for its Docker database, so the two do not clash. ADR 0015 chose Docker over native PostgreSQL. The owner decides whether the Windows PostgreSQL 16 service stays, is stopped or is removed. This session does not change it.

**Phone part — OWNER-ONLY, OPEN.** Not planned until the phone is reachable again (ADR 0011). When access returns, the owner (or the session with owner approval for each step) must check on the phone:

- the PostgreSQL major version (`SELECT version();`) and the Node.js version (`node --version`);
- whether the PostgreSQL major matches the Docker version (ADR 0015). A difference must be recorded and fixed before any production deployment.

**Owner decisions requested:** approve or change items 1 and 2 above (one line each is enough). The phone part waits for phone access.

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
