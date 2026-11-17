# 0036 — Phase 1 Financial Structure: Initial Capital and Budgets

**Status:** APPROVED  
**Date:** 2026-11-17  
**Approved by:** Project owner

---

## Context

The owner decided that the first business loop of MONUMENT starts with a shared cash balance, funded by the founder or partners, and that each department works within a budget set by management (`docs/scenarios/first-business-cycle.md`, sections 2 and 7). The roadmap's Phase 1 scope (`06-ROADMAP.md`, section 4) did not include capital or budgets. Phase 3 needs them to run purchases, payments and receivables consistently.

Phase 1 was otherwise defined as a foundation with no business behavior (ADR 0024). This decision adds financial structure to Phase 1 without adding business workflows.

## Alternatives

1. **Keep capital and budgets for Phase 3.** Phase 1 stays limited to login, organization, membership, roles and data isolation. Discarded: Phase 3 would start without a financial base, and purchases and payments would have nothing consistent to check against.
2. **Add capital, contributions, cash entry, budgets and queries to Phase 1.** Chosen. The company is financially ready to operate before any business workflow exists. The data is recorded and queried, but no purchase, sale or payment runs in Phase 1.
3. **Add the whole cash workflow (purchases, payments, receivables) to Phase 1.** Discarded: it moves business workflows into Phase 1, which contradicts ADR 0024 and delays the foundation.

## Decision

1. Phase 1 includes:
   - the record of the initial capital and of later contributions, with the entry in the company's bank account;
   - the operational budget and the limit for each department, set by management after the capital is recorded and before operations start;
   - queries for the available balance and for the committed amounts.
2. Phase 1 does not include purchases, payments, sales, receivables or any budget check on a purchase. These are Phase 3 (`06-ROADMAP.md`, section 6).
3. The shared cash balance is the only cash. A budget is a limit over that balance, not separate money.
4. The only approval flow in the first version is the budget exception: a purchase above a department's limit is blocked, and the employee can request an exception that management approves or rejects. Individual purchase approval is left for a later phase.

## Rationale

- Phase 3 needs a financial base to be consistent: a balance, limits and commitments. Recording them in Phase 1 avoids building them under pressure later.
- The owner's note says Phase 1 must leave the company financially ready to operate.
- Keeping business workflows out of Phase 1 preserves ADR 0024.

## Consequences

- `06-ROADMAP.md`, section 4: scope items 10 and 11 and one exit criterion added.
- Architecture must include the financial entities (capital contribution, cash ledger, budget, commitment) in the Phase 1 database design. ADR 0032 is approved for the design as it stood before this decision, so it must be amended (not replaced) to cover these entities. Architecture proposes the amendment; the owner approves it.
- The Platform Engineering schema draft on hold (`feat/phase-1-backend-foundation`) is replaced by the revised design, not extended.
- Cost: R$ 0 per month. Maintenance: the ledger and budget tables, and their tests.
- Management is simulated in the first version. Who acts as management when an exception is requested is an open point for the owner.

## Numbering note

ADRs 0034 and 0035 are reserved for the revision of store count and participant roles (`docs/08-COMPANY.md`, section 10.9), which is still awaiting the owner's approval.
