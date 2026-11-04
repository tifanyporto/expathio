# 2026-11-04 — Physical Stores and Documentation Audit

## Goal

Answer whether the documentation is complete, then close the items within the documentation function that the audit found, starting with the owner's decision that physical stores are part of the first release.

## Scope

- In scope: the physical stores decision; the inconsistency between `02` and `08`; the open questions in `02`, `01`, `03`, `04` and `07`; the open inconsistencies and open items in `CURRENT_STATE`; the roadmap Phase 3 wording that depends on the store decision.
- Out of scope: the business mechanics of stock transfers between locations (recorded as open); any code; the standard session prompt and role assignment (waiting for the owner's declaration that the documentation is complete); the Docker and WSL2 installation (owner's action).

## Documents Read

1. `docs/02-BUSINESS-SIMULATION.md`, sections 3, 6.2 to 6.4, 8, 11 and 15.
2. `docs/01-PRODUCT.md`, sections 10 to 12.
3. `docs/03-USER-EXPERIENCE.md`, section 16.
4. `docs/04-AI-AGENTS.md`, section 16.
5. `docs/07-PROGRESSION-AND-REWARDS.md`, section 18.
6. `README.md`.
7. `docs/08-COMPANY.md`, full.
8. `docs/06-ROADMAP.md`, full.
9. `docs/decisions/TEMPLATE.md`.

## Files Changed

- `docs/decisions/0017-physical-stores-in-first-release.md`: created, status APPROVED.
- `docs/02-BUSINESS-SIMULATION.md`:
  - Section 3: the company is online-first with two physical stores.
  - Section 6.2: orders come from the online store and the physical stores, in one order list.
  - Section 6.3: stock is tracked per location.
  - Section 15: questions 1 to 3 annotated with their answers. Question 13 added: stock transfers between locations, not defined.
- `docs/06-ROADMAP.md`: Phase 3, the order step now says online or in a physical store.
- `docs/01-PRODUCT.md`:
  - Section 11, question 8 marked as decided.
  - Section 12: the privacy definitions must be done before Phase 4 admits the first real participant. Status: open.
- `docs/03-USER-EXPERIENCE.md`, `docs/04-AI-AGENTS.md`, `docs/07-PROGRESSION-AND-REWARDS.md`: each open-questions section now says the phase by which it must be resolved.
- `docs/CURRENT_STATE.md`: decision 0017 added; open inconsistencies recorded as resolved; open items updated with the phase gates.
- `docs/sessions/product-and-documentation/2026-11-04-physical-stores-and-doc-audit.md`: this record.

## Decisions

- Approved by the owner: ADR 0017. Physical stores are part of the first release. Stock is per location.
- Proposed (not approved): the phase gates added to the open-questions sections of `01`, `03`, `04` and `07`. Each gate is a documentation proposal. The owner has not confirmed them.
- Proposed (not approved): the first-release privacy definitions must be complete before Phase 4 admits the first real participant. The owner has not confirmed the timing.

## Tests and Results

Nothing was executed. There is no application code. Checks made by reading the documents:

- Searched `02` for "store", "physical" and "e-commerce": the only mentions were the company identity and the order process, which are now corrected.
- Searched all `docs/` for open questions, placeholders and inconsistency markers.

## Documentation Completeness

Not complete at the start of this session. The audit found:

1. The `02` and `08` disagreement on physical stores. Resolved by ADR 0017.
2. Stale questions in `02`, section 15. Resolved by inline annotations.
3. `CURRENT_STATE` stated there were no inconsistencies while the above existed. Corrected.
4. Open questions without a phase. Gated in `01`, `03`, `04` and `07`.
5. Privacy definitions required by `01`, section 12, not tracked. Now tracked as open, before Phase 4.

Still open for completeness, by phase:

- Stock transfers between locations (before Phase 3).
- Visual specification in `09` (before the first Phase 1 screen).
- Simulated-day mechanics in `02`, section 11 (Phase 5).
- GitHub connection mechanism (no phase set; owner decides).
- Phase 0 exit criterion "Development environment is ready": depends on the owner's Docker and WSL2 installation.

## Pending

- Owner confirmation of the phase gates and of the privacy timing.
- Owner decision on stock transfers between locations, when Phase 3 design starts.
- Owner declaration that the documentation is complete, after the items above are closed or explicitly deferred.

## How to Resume

Read in this order:

1. `CLAUDE.md`.
2. `docs/CURRENT_STATE.md`, sections "Open Inconsistencies" and "Open".
3. `docs/decisions/0017-physical-stores-in-first-release.md`.
4. This record.

Starting point: the owner's confirmation of the phase gates and privacy timing.

Already decided, do not ask again: physical stores are in the first release; stock is per location (ADR 0017).

## Next Step

The owner confirms the proposed phase gates and privacy timing, and decides whether stock transfers between locations are needed before Phase 3. After that, the documentation function can declare the documentation complete, and the standard session prompt can be prepared.
