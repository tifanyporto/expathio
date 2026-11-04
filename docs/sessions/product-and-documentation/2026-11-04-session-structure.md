# 2026-11-04 — Session Structure

## Goal

Organize project work into sessions with defined functions, each limited to its own scope, and record the rule that enforces this in `CLAUDE.md`.

## Scope

- In scope: a session responsibility rule in `CLAUDE.md`; a map of the sessions needed to build Expathio, in `docs/SESSION-STRUCTURE.md`.
- Out of scope: running any task assigned to a mapped session; changing any document other than the two above; creating the source code folders; creating the repository.

## Documents Read

1. `CLAUDE.md`.
2. `docs/CURRENT_STATE.md`.
3. `docs/06-ROADMAP.md` (full), for phase order and exit criteria.
4. `docs/sessions/TEMPLATE.md`.
5. `docs/sessions/architecture-and-quality/2026-11-04-phase-0-practices.md`, the previous record.

## Files Changed

- `CLAUDE.md`: added a reference to the session function in section 3, and a new section 14, "Responsabilidade por sessão". The section sets the rule: a session acts only in its own scope, records dependencies on other areas and passes them to the owner without executing them, and changes only the documents under its function.
- `docs/SESSION-STRUCTURE.md`: created, status IN DISCUSSION. Maps six active sessions (Product and Documentation; Architecture and Quality; Infrastructure and Operations; Platform Engineering; Frontend Engineering; Experience and Design), three later sessions (Simulation Engine, AI Integration, Progression and Rewards), a dependency map, a build order against the roadmap, and two open questions.
- `docs/CURRENT_STATE.md`: open items updated (see below).
- `docs/sessions/product-and-documentation/2026-11-04-session-structure.md`: this record.

## Decisions

- Proposed (not approved): the six active sessions and the three later sessions in `docs/SESSION-STRUCTURE.md`. Activation of each session requires owner approval.
- Proposed (not approved): Infrastructure and Operations also handles the local Docker setup (open question 1 in `docs/SESSION-STRUCTURE.md`, section 7).
- Proposed (not approved): Experience and Design is a separate session from Frontend Engineering (open question 2).
- Approved by the owner: the session responsibility rule in `CLAUDE.md`, section 14.

## Tests and Results

Nothing was executed. There is no application code.

## Pending

- Owner decisions on the two open questions in `docs/SESSION-STRUCTURE.md`, section 7.
- Owner approval of the session map.
- Location of source code folders (`apps/`, `packages/` or other), to be decided when the repository is created in Phase 1.
- The session map's section 4 lists later sessions that are not created yet. They are created only when their phase starts.

## Continuation: Owner Approval

The owner approved the session map on 2026-11-04 and asked that the planned sessions be documented in the same detail as the active ones.

Files changed in this continuation:

- `docs/SESSION-STRUCTURE.md`: status changed to APPROVED. Section 4 now gives full entries for Simulation Engine (Phase 5), AI Integration (Phase 6), and Progression and Rewards (Phase 7), plus a note on Phase 8. Section 7 records the two decisions taken on the open questions, following the recommendations.
- `docs/CURRENT_STATE.md`: session structure marked APPROVED. Added a pending item for the standard session prompt and role assignment.
- This record.

Decided by the owner: the two structure questions (Docker setup under Infrastructure and Operations; Experience and Design as a separate session).

Pending from the owner: the owner will say when the documentation is complete. The next item is then a standard prompt to start each session and assign it a role. The GitHub repository is created by the owner. Not started, because the owner has not yet declared the documentation complete.

Open: where the source code folders live. Decide when Phase 1 starts.

## How to Resume

Read in this order:

1. `CLAUDE.md`, including section 14.
2. `docs/CURRENT_STATE.md`.
3. `docs/SESSION-STRUCTURE.md`.
4. This record.

Starting point: the owner's answers to the two open questions, and approval or changes to the session map.

Already decided, do not ask again: the session responsibility rule (`CLAUDE.md`, section 14).

Do not change: `CLAUDE.md`, section 14, without owner request. It is the rule every session follows.

## Next Step

Owner answers the open questions in `docs/SESSION-STRUCTURE.md`, section 7. After that, the map is approved or revised, and this record is updated. Phase 0 work continues in the Infrastructure and Operations function (phone and Docker verification) and the Architecture and Quality function (none pending). Product and Documentation remains with the remaining Phase 0 items: the Docker and WSL2 installation is the owner's action.
