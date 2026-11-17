# First Business Cycle of MONUMENT

**Status:** PROPOSED  
**Document type:** Scenario specification  
**Project:** Expathio  
**Owner of this document:** Product and Documentation

---

## 1. Purpose

This document describes the first complete business loop of MONUMENT, as verifiable steps. The loop is: open one physical store, buy materials, send them to an outsourced manufacturer, receive the finished goods and sell them. The company grows only when the money from sales allows it.

Owner decisions, 2026-11-17:

- Phase 1 stays a foundation: option A. The business loop is in Phase 3 (`06-ROADMAP.md`, section 6).
- The counter seller is a simulated cashier, not a participant.
- The initial capital enters the system when the company is created, as a contribution from the founder or partners.
- The only approval flow in the first version is the budget exception (section 5). Individual purchase approval is left for a later phase.

Owner decisions on the open points (2026-11-17), recorded in section 7.

Roles are as proposed in `docs/08-COMPANY.md`, section 10.9: Operations Assistant, Customer Service Representative and Finance Assistant.

## 2. Starting state

- Organization: MONUMENT, with one physical store and one online location. Each location has its own stock (`docs/decisions/0017-physical-stores-in-first-release.md`).
- Cash: one shared balance for the whole company, recorded by a capital contribution entry at creation. The founder defines the amount (example: 50,000).
- Budgets: management sets a budget for each department during the initial setup, after the capital is recorded and before operations start. A budget is a limit over the shared balance, not separate cash.
- Stock: zero.
- Suppliers: one fabric and trim supplier, and one outsourced manufacturer. All fictional.

## 3. Entities involved

Capital contribution; cash balance; budget; budget exception request; supplier; supplier terms; product; variant (size and color); SKU; purchase order; goods receipt; stock movement; manufacturing order; finished-goods receipt; customer; sale order; payment; delivery; ledger entry (cash); payable; receivable; customer case.

## 4. Steps

| # | Role | Action | Effect on state | Must not |
|---|---|---|---|---|
| 0 | Founder (simulated) | Records the capital contribution at creation | Cash ledger entry in; shared balance increases | Be recorded more than once for the same contribution |
| 1 | Management (simulated) | Sets budgets by department, after step 0 and before step 2 | Budget limits recorded | Be set before the capital is recorded |
| 2 | Operations | Registers the fabric supplier and its terms | Supplier record | Create a purchase order without a supplier |
| 3 | Operations | Registers a product, its variants and a SKU | SKU with zero stock and no cost yet | Sell or receive a SKU that has no variant |
| 4 | Operations | Creates a purchase order for fabric | Purchase order in state *draft*, then *sent*; the budget is committed if within the limit | Move stock or cash; exceed the budget without an approved exception |
| 5 | Operations | Records the receipt of the fabric | Goods receipt against the open purchase order; stock movement in; purchase order *received* or *partially received*; a payable is created | Accept a receipt without an open purchase order |
| 6 | Finance | Pays the supplier | Cash ledger entry out; the shared balance decreases; payable becomes *paid*; budget use is recorded | Pay more than the payable amount |
| 7 | Operations | Sends fabric to the manufacturer | Manufacturing order in state *planned*, then *in progress*; stock movement out (fabric, not finished goods) | Send more fabric than is in stock |
| 8 | Operations | Records the return of finished goods | Finished-goods receipt against the manufacturing order; manufacturing order *completed*; stock movement in at accumulated cost | Create finished stock without a manufacturing order |
| 9 | Simulated cashier | Makes a sale at the store | Sale order *created*; stock reserved | Sell with zero available stock |
| 10 | Simulated cashier | Receives payment | Cash ledger entry in; sale order *paid*. For a deferred sale, a receivable is created instead, with a due date and payment status | Recognize revenue |
| 11 | Operations | Delivers the product to the customer | Sale order *delivered*; stock consumed; revenue recognized; for a deferred sale, the stock is consumed here, not at payment | Consume stock before delivery |
| 12 | Customer Service | Opens a case for an exchange request | Case; exchange request sent to Finance | Change stock or cash by itself |
| 13 | Finance | Approves or rejects the exchange (ADR 0025) | If approved, a return movement in and a refund ledger entry out; if rejected, the case is closed with a reason | Refund without an approval |

Steps 9 and 10 are performed by the simulated cashier. The participant does not make the sale. In Phase 3, sales are registered by the system from a simulated sale input. In Phase 5, a sale generator produces them automatically (section 7).

## 5. State rules

- **Purchase order:** *draft* → *sent* → *partially received* or *received* → *closed*. It can be *cancelled* from *draft* or *sent*.
- **Goods receipt:** can only refer to an open purchase order. A quantity above the ordered amount is recorded as a divergence, not as a silent change.
- **Stock movement:** append-only. The stock level is the sum of movements. It can never be negative.
- **Manufacturing order:** *planned* → *in progress* → *completed*, or *cancelled*. It holds the planned quantity, the quantity actually produced, the estimated cost and the due date. Finished goods enter stock only when completed.
- **Sale order:** *created* (stock reserved) → *paid* (or *deferred*) → *delivered*. Revenue is recognized at *delivered*. Cancelling a sale releases the reservation.
- **Deferred sale (configurable):** a sale can be marked as deferred. The sale is registered normally, the stock is consumed at delivery, the amount does not enter cash immediately, and a receivable is created with a due date and payment status. Installments and credit checks are not part of the first version.
- **Payable and receivable:** created by the source document (purchase receipt or sale). Cash moves only at payment.
- **Budget:** a limit over the shared balance, per department. When a purchase would exceed the limit, the system blocks it. The management can grant an exceptional approval for that purchase. This is the only approval step in the first version.

## 6. Invariants (must always hold)

- I1. Stock is never negative.
- I2. Cash changes only through a payment, refund or capital contribution ledger entry.
- I3. Every stock movement and every ledger entry links to its origin document.
- I4. A receipt without an open purchase order is rejected.
- I5. A message, comment or note changes no stock and no cash.
- I6. Repeating the same action with the same key creates one effect only.
- I7. A sale with no available stock is rejected.
- I8. Revenue is recognized only at delivery, not at sale or payment.
- I9. The shared balance equals the sum of the cash ledger entries.
- I10. A purchase above the department's budget limit is blocked unless an exceptional approval exists for it.
- I11. Cost of finished goods is the accumulated cost of materials, outsourced labor, labels, packaging and acquisition freight. The simplified model is used first; a full bill of materials is a later phase.

## 7. Decisions on the open points (owner, 2026-11-17)

1. **Budgets:** management defines them during the initial setup, after the capital is recorded and before operations start. When a limit is reached, the system blocks new purchases above it, but allows an exceptional approval request. The employee cannot spend freely; management can authorize exceptions.
2. **Sales generation:** split in two. Phase 3 implements the registration of sales: the system receives a simulated sale and updates stock and finance. Phase 5 implements the engine that generates sales automatically, with frequency, volume and customer behavior.
3. **Deferred payment:** yes, as a configurable mode. The sale is registered normally, stock goes out at delivery, and a receivable is created. No installments and no credit analysis in the first version.
4. **Manufacturing order:** confirmed for Phase 3, not Phase 1. In Phase 3 it allows creating an order, registering materials and costs, following progress, and completing production with finished goods entering stock.

## 8. Acceptance scenarios

These checks describe what a test must verify. They are not tests yet.

1. **Full cycle:** run steps 0 to 11 and check the shared balance, stock and revenue after each step against the expected values.
2. **Divergence:** a receipt with two units fewer than ordered records a divergence and leaves the stock at the received quantity.
3. **Sale without stock:** a sale for a SKU with zero available stock is rejected, and no reservation, stock, cash or revenue change occurs.
4. **Revenue timing:** a paid sale that is not yet delivered creates cash but no revenue (invariant I8).
5. **Deferred sale:** a deferred sale consumes stock at delivery, creates a receivable, and changes cash only when the receivable is paid.
6. **Budget limit:** a purchase above the department's limit is blocked; the same purchase passes after an exceptional approval.
7. **Duplicate action:** the same receipt submitted twice with the same key creates one stock movement.
8. **Message without effect:** a message saying a purchase was made changes no stock and no cash (invariant I5).

## 9. Phase mapping

- **Phase 1 (structure):** the company is created with its initial capital and contributions, the cash and bank entry, the operational budget, the department limits, and queries for the available balance and the committed amounts (owner, 2026-11-17; ADR 0036).
- **Phase 3 (operation):** sales registration, purchase orders with budget checks, receipts, payables and receivables, manufacturing orders, and the cycle in steps 2 to 13.
- **Phase 5 (automation):** the engine that generates sales and the customer behavior that drives them.
