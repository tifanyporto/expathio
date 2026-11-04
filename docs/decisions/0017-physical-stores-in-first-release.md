# 0017 — Physical Stores in the First Release

**Status:** APPROVED  
**Date:** 2026-11-04  
**Approved by:** Project owner

---

## Context

The simulated company MONUMENT is defined in `08-COMPANY.md` with two physical stores and a stock level per location. `02-BUSINESS-SIMULATION.md` describes sales and orders only through the e-commerce operation (sections 3 and 6.2). The two documents disagreed, and the decision on whether physical stores belong to the first release was open.

## Alternatives

1. **Online sales only in the first release.** Simpler: one stock level and one sales channel. Stores would be added in a later phase. Discarded: it removes the company identity the owner defined, and `08-COMPANY.md` would need to change.
2. **Online and two physical stores in the first release.** Each store has its own stock level, and store sales enter the same order list as online orders. Chosen. It adds one dimension to inventory (location), but no new department or role.

## Decision

The first release includes the online store and the two physical stores of MONUMENT. Store sales are orders recorded in the same order list, with the store as the point of sale. Stock is tracked per location.

## Rationale

- It matches the company already defined in `08-COMPANY.md` and the owner's choice.
- Per-location stock is a small addition to the inventory rules already planned (`02`, section 6.3). It does not add a department or a role.
- The owner chose this explicitly on 2026-11-04.

## Consequences

- `02-BUSINESS-SIMULATION.md`: sections 3, 6.2 and 6.3 updated to cover store sales and per-location stock.
- `06-ROADMAP.md`, Phase 3: the order step now says the order is created online or in a physical store.
- Transfers of stock between locations are not defined. They are recorded as an open question in `02`, section 15.
- The data model must store the location of each order and each stock level. This is a requirement for Phase 2 and Phase 3 technical design, in `05-TECHNICAL-ARCHITECTURE.md`.
- No change in cost, infrastructure or technology.
