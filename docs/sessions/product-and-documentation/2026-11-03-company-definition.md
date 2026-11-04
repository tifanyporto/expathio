# 2026-11-03 — Company Definition

## Goal

Close the two open items in `08-COMPANY.md` that were blocking a complete organization definition: company identity and vacancies. Also finalize role titles, which were marked provisional.

## Scope

- In scope: company name, brand, business description, catalog and pricing (simple, placeholder level), vacancies per role, final role titles, and the matching status entries.
- Out of scope: GitHub connection mechanism, Phase 1 technical choices, simulated-day mechanics, AI questions, visual specifications. These are the next items, not this session.

## Documents Read

1. `CLAUDE.md`.
2. `docs/CURRENT_STATE.md`.
3. `docs/sessions/product-and-documentation/2026-11-03-documentation-review.md`.
4. `docs/08-COMPANY.md`.
5. `docs/decisions/0005-admission-model.md`, `0007-first-version-participant-rules.md`, `0009-first-version-tools-and-roles.md` (checked through the references in `08`).
6. `docs/02-BUSINESS-SIMULATION.md` (department names in section 4, checked by search).

## Files Changed

- `docs/08-COMPANY.md`: rewritten. Adds sections for company identity (2), catalog and pricing (3) and vacancies with one description per role (7). Role titles are final. The pending list was removed. Section 6 (access rules) now points to `0009` instead of `0004`, which was an incorrect reference.
- `docs/CURRENT_STATE.md`: company identity, vacancies and final role titles removed from the open list. The "Planned" entry for completing `08` was removed.
- `docs/sessions/product-and-documentation/2026-11-03-company-definition.md`: this record.

## Decisions

- Proposed (not approved): none.
- Approved by the owner: the company identity (MONUMENT, streetwear, online plus two stores) and the catalog categories were confirmed. Prices and currency were not confirmed and remain placeholders. Vacancies were proposed by Claude and not yet confirmed by the owner. None of these are structural decisions, so none has an ADR.

Placeholder values chosen in this session (the owner can change any of them):

- Company name: MONUMENT, a streetwear brand. The name is the logo, in a stylized typeface chosen later.
- Business: sells primarily online, with two physical stores at the start. Store sales use the same order list.
- Currency: US dollars (USD), single market.
- Catalog: three categories (Apparel, Footwear, Accessories), each product with a fixed price, no discounts in version 1. Stock is tracked per location.
- Vacancies: one per participant role, because each role has one occupant (`0007`). This is a consequence of an approved decision, not a new one.
- Vacancies reopen when an occupant leaves. This follows from `0005` and `0007`, but the owner should confirm it.

## Tests and Results

Nothing was executed. There is no application code. The only check was a search for department names across `docs/`. All eight names match `02-BUSINESS-SIMULATION.md`, section 4.

## Pending

- Confirm the vacancies and their descriptions in `08-COMPANY.md`, section 7.
- Confirm the prices and currency (USD) in `08-COMPANY.md`, section 3.
- Confirm that a vacancy reopens when its occupant leaves (section 7 of `08`).
- Remaining open items (not part of this session): GitHub connection mechanism; technical choices for Phase 1 (`05-TECHNICAL-ARCHITECTURE.md`, section 19); simulated-day mechanics (`02`, section 11); AI and progression questions (`04` section 16, `07` section 18); the Phase 0 activities in `06-ROADMAP.md`; visual specifications in `09-DESIGN-SYSTEM.md`; the branch policy in `CLAUDE.md` section 7; review of `README.md`.

## How to Resume

Read in this order:

1. `CLAUDE.md`.
2. `docs/CURRENT_STATE.md`.
3. This record.
4. `docs/08-COMPANY.md`, if the work touches the organization.

Starting point: the owner's review of the placeholder values above. Do not re-ask the vacancy count per role, which follows from `0007`.

Do not change the structure of `08-COMPANY.md`. Its sections are referenced by `01`, `0009` and `CURRENT_STATE`.

## Next Step

Confirm the placeholders in `08-COMPANY.md`. Then choose the next open item. Suggested order: Phase 0 activities and the technical choices needed for Phase 1, since they block the start of implementation.
