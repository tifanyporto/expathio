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
- **Source:** `09-DESIGN-SYSTEM.md`, now on `main` (merge `bd69844`), status APPROVED for the Phase 1 scope (sign-in screen and application shell).
- **Proposed answer (Experience and Design, 2026-11-06):** the visual specification is `09-DESIGN-SYSTEM.md`. Its typeface is decided in `docs/decisions/0021-interface-typeface.md` (APPROVED). The login and post-login decisions are in `docs/decisions/0028-experience-screen-decisions-phase-1.md` (APPROVED). The specification is not yet implemented or tested.
- **Specification:** `09-DESIGN-SYSTEM.md`, section 15, lists what the specification covers and what is still open before implementation. Two contrast failures were found and recorded in section 4.4: `error-text` fails on `neutral-50` (4.38:1), so it is used only on `neutral-0`.
- **Still open before closing:** the implementation in the first Phase 1 screen (Public Sans package with a pinned version, tokens) and the color check on the implemented screens (`09`, section 10). Section 13.2 of `09` still lists the four points that ADR 0028 now answers; Experience and Design will update it when the owner agrees.
- **Closure:** owner decides (not this session).

### Q-011 — Phase 1 screen map and application shell

- **Status:** IN DISCUSSION
- **Asked by:** Product and Documentation
- **Answered by:** Experience and Design, approved by the owner
- **Needed by:** before the first Phase 1 screen is built
- **Question:** the Phase 1 screens are the login (test accounts only, ADR 0022) and an application shell with header, content area and a place for navigation. Which screens exist in each phase, and what the navigation contains from Phase 2 on. Navigation items stay undefined in Phase 1.
- **Source:** `06-ROADMAP.md`, section 4
- **Proposed answer (Experience and Design, 2026-11-06):**
  - **Phase 1 screens:** (1) the sign-in screen, with e-mail and password, no sign-up, no password recovery and no organization selection (ADR 0022, ADR 0028); (2) the post-login page inside the shell, showing the organization name, the role of the membership and the label "Simulated data" (ADR 0028). No business content.
  - **Application shell (Phase 1):** header with the text "Expathio", the simulated-data marker, the account name and a sign-out button; a navigation area with no items; a content area. Details in `09-DESIGN-SYSTEM.md`, section 6.1.
  - **Phase 2 and later:** no screen list is proposed here, because Phase 2 scope is decided in `06-ROADMAP.md`, section 5. Proposed rule for navigation: its items come from the functions each role uses in `08-COMPANY.md`, section 6.1, and the backend decides what each role can change (`CLAUDE.md`, section 10). Hiding a menu item is not access control.
  - **Post-login page, proposed (Experience and Design, 2026-11-06):** a read-only list of the members of MONUMENT, with the name and role of each member, and no actions. It is shown in the shell, with the simulated-data marker. Demonstration, with fictional test accounts: https://claude.ai/artifact/8PHX7ZT6pTV6ais9LWpZ3q. Not defined here: who may see the list (`08-COMPANY.md`, section 6.1, access rules) and any navigation items (owner decides).
  - **Open for the owner:** approval of this proposed post-login page. Its visual design has not been approved yet.
  - **Specified in** `09-DESIGN-SYSTEM.md`, section 14 (screen map). Gap routed to Product and Documentation: `08-COMPANY.md`, section 6.1, has no row for a member list, so its access rule is not defined.
- **Closure:** owner decides (not this session).

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
- **Method chosen (owner, 2026-11-06):** option A, Experience and Design draws the mark in a free vector editor. A paid designer is not contracted. The logo itself is still not approved.
- **Logo approved (owner, 2026-11-09):** the three-phase ring, in purple tones only (input `purple-400`, process `purple-600`, output `purple-900`). Recorded in `09-DESIGN-SYSTEM.md`, section 11.1, which the shell header now follows. The owner confirmed that tones of one hue satisfy the one-color rule.
- **Still open:** the MONUMENT identity (the company's own mark and typeface), which is not part of this approval. Closure is the owner's.
- **Also open:** the MONUMENT visual identity. `08-COMPANY.md`, section 2, refers to a "company's visual specification" that does not exist yet. Experience and Design is the natural owner, but this is not yet confirmed.
- **Proposed answer (Experience and Design, 2026-11-06):**
  - **How the logo is made.** Option A: Experience and Design draws the mark in a free vector editor. Cost R$ 0 per month; needs time, no approval beyond the owner's. Option B: an external designer. Cost not known; needs the owner's approval before any contact (`CLAUDE.md`, section 2), and the contract must transfer the rights of the files to the project. Option C: keep the text "Expathio" with no mark. Cost R$ 0; no visual identity beyond the typeface.
  - **Recommendation:** Option A, since the owner already assigned the logo to this function. Keep the text "Expathio" until the mark is approved (ADR 0028). Option C remains acceptable if the owner prefers no mark in Phase 1.
  - **Specified in** `09-DESIGN-SYSTEM.md`, section 11.1 (logo rules, proposal, not approved) and section 11.2 (MONUMENT identity, proposal, not approved). No logo draft exists yet; one is shown to the owner before any approval.
  - **MONUMENT identity.** Proposed: a separate document, owned by Experience and Design, linked from `08-COMPANY.md`, section 2. It stays out of the Expathio interface (`03-USER-EXPERIENCE.md`, section 17). Owner to confirm the owner and location.
- **Closure:** owner decides (not this session).

### Q-014 — Lint rule for imports between folders

- **Status:** PROPOSED
- **Asked by:** Architecture and Quality
- **Answered by:** Architecture and Quality, approved by the owner
- **Needed by:** deferred
- **Question:** whether a lint tool should block imports that cross folder rules (ADR 0019, consequences). Adding a new tool needs the owner's approval.

### Q-017 — Update the visual specification entry in CURRENT_STATE.md

- **Status:** PROPOSED
- **Asked by:** Experience and Design
- **Answered by:** Product and Documentation, approved by the owner
- **Needed by:** now that `09-DESIGN-SYSTEM.md` is APPROVED for the Phase 1 scope
- **Question:** `docs/CURRENT_STATE.md` still lists the visual specification as an open item. The specification (`09-DESIGN-SYSTEM.md`, APPROVED on 2026-11-06 for the sign-in screen and application shell) and ADR 0021 (typeface, APPROVED) are on `main`. Should the open item be closed, and what state should the record show for the implementation, which is not done?
- **Source:** `docs/CURRENT_STATE.md`; `docs/09-DESIGN-SYSTEM.md`, section 2; `docs/decisions/0021-interface-typeface.md`

### Q-018 — Who may see the member list of an organization

- **Status:** APPROVED
- **Closed:** 2026-11-09, by the owner. The member list is out of Phase 1. Reopen this entry if the list returns to scope.
- **Asked by:** Experience and Design
- **Answered by:** Product and Documentation, approved by the owner
- **Needed by:** only if the owner approves the member list (Q-011), and before it is built
- **Question:** the proposed post-login page lists the members of MONUMENT with their roles (`09-DESIGN-SYSTEM.md`, section 14; Q-011). `08-COMPANY.md`, section 6.1, has no row for a member list, so no role is defined as able to see it. Which roles may see the list, and does a member see the roles of colleagues whose records they cannot change?
- **Source:** `docs/08-COMPANY.md`, section 6.1; `docs/09-DESIGN-SYSTEM.md`, section 14
- **Answer (owner, 2026-11-09, reported by Product and Documentation and confirmed by the owner):** the member list is out of Phase 1. The post-login page shows only the logged-in account. This entry is reopened if the list returns.

### Q-020 — Direct messages between sessions

- **Status:** APPROVED (decision by the owner, 2026-11-09). Formalized in ADR 0029.
- **Closed:** 2026-11-09, by the owner.
- **Asked by:** the owner, through Experience and Design
- **Answered by:** Product and Documentation (formalization), approved by the owner
- **Needed by:** before the first direct message between sessions
- **Decision:** a session may request something of another session by direct message. The owner approves this form of communication the first time. After that it is the default, unless the owner explicitly disapproves it. Each request is recorded in the sending session's record.
- **Already in `CLAUDE.md`:** section 14 reflects this decision (changed on the owner's request, 2026-11-09).
- **ADR:** the owner approved ADR 0029 on 2026-11-09 (`docs/decisions/0029-direct-messages-between-sessions.md`), as reported by Product and Documentation. Committed in `72dc0c5` on branch `docs/q-011-screen-map-request`, not pushed (checked with git on 2026-11-09).
- **To formalize:** a decision record in `docs/decisions/`, with the rules above. Not done yet.

### Q-019 — Reference to the company's visual specification

- **Status:** APPROVED
- **Closed (owner part):** 2026-11-09, by the owner. The owner of the MONUMENT visual identity document is Experience and Design. The location of the document stays open, and a new entry will be opened when the MONUMENT identity work starts.
- **Asked by:** Experience and Design
- **Answered by:** Product and Documentation, approved by the owner
- **Needed by:** before any MONUMENT identity work starts (Q-016)
- **Question:** `08-COMPANY.md`, section 2, says the typeface of the MONUMENT logo is chosen in "the company's visual specification". That document does not exist, and no owner is named. Should the reference be corrected to the document that Experience and Design proposes in `09-DESIGN-SYSTEM.md`, section 11.2, and who owns it?
- **Source:** `docs/08-COMPANY.md`, section 2; `docs/09-DESIGN-SYSTEM.md`, section 11.2; Q-016
- **Answer (owner, 2026-11-09):** the owner of the MONUMENT visual identity document is Experience and Design. Product and Documentation corrected `08`, section 2, to point to it. The document does not exist yet, and its location is still to be decided (Q-016).
