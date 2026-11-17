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
   - the operational budget and the limit for each department, set by management after the capital is recorded and before operations start. Departments are identified only to attach limits: minimal scope, with no hierarchy or administrative functions (owner, 2026-11-17, Q-044);
   - queries for the available balance and for the committed amounts;
   - the budget exception flow: a request with justification, an evaluation by fixed rules of the simulated management, an approval or rejection, and the audit record of the decision (owner, 2026-11-17, Q-045). No AI in this flow.
2. Phase 1 does not include purchases, payments, sales or receivables. The check that blocks a purchase above a department's limit is Phase 3, when purchases exist (`06-ROADMAP.md`, section 6). The exception flow in Phase 1 is tested without purchases.
3. The shared cash balance is the only cash. A budget is a limit over that balance, not separate money.
4. The only approval flow in the first version is the budget exception. The simulated management is an internal business actor with authority limited by fixed rules, not a participant role and not an AI agent (owner, 2026-11-17, Q-048). Individual purchase approval is left for a later phase.
5. Owner and administrator supervision is a separate access, outside the business and participant roles, and every action is identified and recorded (owner, 2026-11-17, Q-047).
6. Budget periods are monthly. A month's budget does not carry over to the next month. Period exceptions are left for a later version (owner, 2026-11-17, Q-042).
7. Available amount for a department = monthly limit − realized spending − committed amounts. The company's cash balance stays single; the department budget is only a limit on its use (owner, 2026-11-17, Q-043).
8. An approved budget exception creates a commitment for the requested amount. When the purchase is made, the commitment becomes spending, so it is not counted twice. If the request is cancelled or expires, the commitment is released (owner, 2026-11-17, Q-049).
9. Only the owner grants or revokes the administrator role. The first version allows one owner and none or one additional administrator. An administrator cannot grant their own role or name other administrators (owner, 2026-11-17, Q-050).
10. The company's cash balance is a mandatory limit on a budget exception. An exception may exceed the department's available budget, but it can never commit money the company does not have available. Example: department available 500, company available 300, purchase requested 400, rejected even if management approves the departmental exception (owner, 2026-11-17, Q-051).
11. A commitment has a creation date and an expiry date. The default expiry is the last day of the budget month. A commitment is converted to spending when the purchase is made, released immediately when cancelled, and released when it expires at the end of the month without being realized (owner, 2026-11-17, Q-052).

## Rationale

- Phase 3 needs a financial base to be consistent: a balance, limits and commitments. Recording them in Phase 1 avoids building them under pressure later.
- The owner's note says Phase 1 must leave the company financially ready to operate.
- Keeping business workflows out of Phase 1 preserves ADR 0024.

## Consequences

- `06-ROADMAP.md`, section 4: scope items 10 and 11 and one exit criterion added.
- Architecture must include the financial entities and the budget exception flow in the Phase 1 database design. ADR 0032 must be amended, not replaced, in two steps:
  - Amendment 1 (approved 2026-11-17): capital contributions, cash ledger entries, budget limits, committed amounts and the departments that attach those limits.
  - Amendment 2 (proposed, awaiting owner approval): the budget exception flow, with internal actors, approval rules, exception requests, exception decisions, platform roles and supervision actions.
- The Platform Engineering schema draft on hold (`feat/phase-1-backend-foundation`) is replaced by the revised design, not extended.
- Cost: R$ 0 per month. Maintenance: the ledger and budget tables, and their tests.
- Management is simulated in the first version. Who acts as management when an exception is requested is an open point for the owner.

## Numbering note

ADRs 0034 and 0035 are reserved for the revision of store count and participant roles (`docs/08-COMPANY.md`, section 10.9), which is still awaiting the owner's approval.
