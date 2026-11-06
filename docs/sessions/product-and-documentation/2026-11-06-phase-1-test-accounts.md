# 2026-11-06 — Phase 1 Test Accounts

## Goal

Start the Phase 1 scope definition. Resolve the conflict between login in Phase 1 (`06-ROADMAP.md`, section 4) and the restriction on real participant data (ADR 0011, `01-PRODUCT.md`, section 12).

## Scope

In scope: the decision on real accounts in Phase 1, and recording it.

Also covered later in the same session, all approved by the owner on 2026-11-06: membership by direct link (ADR 0023), the four business roles loaded as data (ADR 0024), the refund decision (ADR 0025), the permission matrix (`08`, section 6.1), and the Phase 1 scope of nine items (`06`, section 4). Still out of scope: the phase for the vacancy flow (ADR 0005).

## Documents Read

1. `CLAUDE.md`
2. `docs/SESSION-STRUCTURE.md`, sections 2 and 3.1
3. `docs/06-ROADMAP.md`
4. `docs/01-PRODUCT.md`
5. `docs/CURRENT_STATE.md`
6. `docs/decisions/0019-phase-1-code-layout.md` (format reference)
7. `docs/sessions/TEMPLATE.md`

## Files Changed

Worktree `C:\expathio-product`, branch `docs/phase-1-scope`, created from `main` (0753e1a). Not committed.

- `docs/decisions/0022-phase-1-test-accounts-only.md`: new, APPROVED 2026-11-06.
- `docs/CURRENT_STATE.md`: decision `0022` added to Approved Decisions; inconsistency resolved on 2026-11-06 added to Open Inconsistencies.
- `docs/decisions/0023-phase-1-direct-membership.md`: new, APPROVED 2026-11-06.
- `docs/decisions/0024-phase-1-business-roles-loaded.md`: new, APPROVED 2026-11-06.
- `docs/CURRENT_STATE.md`: decisions `0023` and `0024` added to Approved Decisions; open inconsistency on section references in `08` added.
- `docs/decisions/0025-refund-decision-by-financial-analyst.md`: new, APPROVED 2026-11-06.
- `docs/06-ROADMAP.md`: section 4, Phase 1 scope replaced by the nine approved items. Original twelve-item list removed. Section 5, Phase 2 scope: vacancy flow added (ADR 0026).
- `docs/decisions/0026-vacancy-application-in-phase-2.md`: new, APPROVED 2026-11-06.
- `docs/08-COMPANY.md`: new section 6.1, "Permissions by Role", placed inside section 6 (Access Rules), before Vacancies. Refund row references ADR 0025. Section marked APPROVED by the owner on 2026-11-06.
- `docs/sessions/product-and-documentation/2026-11-06-phase-1-test-accounts.md`: this record.

- `docs/decisions/0027-first-version-role-titles.md`: new, APPROVED 2026-11-06. Renames the four roles in `08` (all sections), ADR 0009, ADR 0024, ADR 0025 and this record. Roles, tools and permissions unchanged.

## Decisions

- Proposed (not approved): none.
- Approved by the owner on 2026-11-06, not an ADR: Phase 1 scope of nine items, recorded in `06-ROADMAP.md`, section 4; "desktop application layout" means computer-screen layout (ADR 0012 says web application).
- Approved by the owner: vacancy flow in Phase 2 (ADR 0026, 2026-11-06). First-version role titles renamed (ADR 0027, 2026-11-06).
- Approved by the owner: Phase 1 uses test accounts only (ADR 0022, 2026-11-06). Phase 1 membership is a direct link, not a vacancy application (ADR 0023, 2026-11-06). Phase 1 loads the four business roles as data, with no behavior (ADR 0024, 2026-11-06). Refund and exchange requests are approved or rejected by the Finance Assistant (ADR 0025, 2026-11-06). The permission matrix in `08`, section 6.1, is approved (2026-11-06).

## Tests and Results

None. This is a documentation change. No code was executed.

## Pending

- Process for adding roles: approved by the owner on 2026-11-06, `08-COMPANY.md`, section 9. The owner said on 2026-11-06 that the four roles stay and that adding roles is core to the platform. A role is a set of functions. Adding a role may need new functions, which are features built through the phases. Architecture and Quality must decide whether a role with existing functions can be added without a code change (ADR to be proposed).
- Function catalog: not created yet. Pending until the first Phase 1 functions are specified (Q-013 in `docs/OPEN-QUESTIONS.md`).
- Login and post-login decisions for the Experience and Design session: approved by the owner on 2026-11-06, recorded in ADR 0028 (e-mail login, post-login page with organization and role, no password recovery in Phase 1, "Expathio" text until a logo). Logo ownership: the owner decided on 2026-11-06 that Experience and Design creates the logo. The method of making the artwork and the MONUMENT visual identity remain open as Q-016 in `OPEN-QUESTIONS.md`.
- Question register: `docs/OPEN-QUESTIONS.md` created (APPROVED by the owner, 2026-11-06), with 14 entries carried over from `CURRENT_STATE.md` and this session. `SESSION-STRUCTURE.md`, section 2, and `CURRENT_STATE.md` ("Open") updated to point to it.
- Permissions for each of the four roles: approved in `08-COMPANY.md`, section 6.1, on 2026-11-06. The Platform Engineering session may now write the access rules from it (ADR 0024).
- Vacancy flow phase decided: Phase 2 (ADR 0026, 2026-11-06).
- Section references to `08` corrected (tools are in section 5, not section 3) in ADR 0009, `01`, section 3.5, and ADR 0024. Recorded as resolved in `CURRENT_STATE.md`. The ADR 0009 text changed only in the reference, not in the decision.
- Phase 1 scope approved (nine items, 2026-11-06), recorded in `06-ROADMAP.md`, section 4.
- Wording "desktop application layout" confirmed as computer-screen layout (2026-11-06).
- The registry index `docs/decisions/` has an untracked file `0021-interface-typeface.md` from another working tree (Experience and Design). ADR 0022 does not collide with it.
- Commit and push of branch `docs/phase-1-scope`: only when the owner asks.

## How to Resume

Read in order: `CLAUDE.md`, `docs/CURRENT_STATE.md`, this record, `docs/06-ROADMAP.md` section 4, ADR 0022.

Starting point: Phase 1 scope in `06`, section 4, awaiting the owner's answers to the pending decisions above.

Already decided, do not ask again: real accounts are excluded from Phase 1 (ADR 0022); Phase 1 is a platform foundation with no business workflows.

Do not change: ADR 0011 (initial host) or the privacy rules in `01`, section 12. Both stay as they are until Phase 4.

## Next Step

Ask the owner the vacancy phase (ADR 0005). Then the Platform Engineering session can start from `06`, section 4, and `08`, section 6.1. The Experience and Design session can map the Phase 1 screens from the same scope.
