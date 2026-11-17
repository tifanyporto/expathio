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
- Purchase approval exists in the product, but is left for later.

Roles are as proposed in `docs/08-COMPANY.md`, section 10.9: Operations Assistant, Customer Service Representative and Finance Assistant.

## 2. Starting state

- Organization: MONUMENT, with one physical store and one online location. Each location has its own stock (`docs/decisions/0017-physical-stores-in-first-release.md`).
- Cash: one shared balance for the whole company, recorded by a capital contribution entry at creation. The founder defines the amount (example: 50,000).
- Budgets: management allocates part of the balance to each department (purchasing, rent, marketing and others). A budget is a view of the shared balance, not separate cash.
- Stock: zero.
- Suppliers: one fabric and trim supplier, and one outsourced manufacturer. All fictional.

## 3. Entities involved

Capital contribution; cash balance; budget; supplier; supplier terms; product; variant (size and color); SKU; purchase order; goods receipt; stock movement; manufacturing order; finished-goods receipt; customer; sale order; payment; delivery; ledger entry (cash); payable; receivable; customer case.

## 4. Steps

| # | Role | Action | Effect on state | Must not |
|---|---|---|---|---|
| 0 | Founder (simulated) | Records the capital contribution at creation | Cash ledger entry in; shared balance increases | Be recorded more than once for the same contribution |
| 1 | Management (simulated) | Sets budgets by department | Budget allocation (a view over the shared balance) | Exceed the shared balance without a decision |
| 2 | Operations | Registers the fabric supplier and its terms | Supplier record | Create a purchase order without a supplier |
| 3 | Operations | Registers a product, its variants and a SKU | SKU with zero stock and no cost yet | Sell or receive a SKU that has no variant |
| 4 | Operations | Creates a purchase order for fabric | Purchase order in state *draft*, then *sent*; the budget is committed | Move stock or cash |
| 5 | Operations | Records the receipt of the fabric | Goods receipt against the open purchase order; stock movement in; purchase order *received* or *partially received*; a payable is created | Accept a receipt without an open purchase order |
| 6 | Finance | Pays the supplier | Cash ledger entry out; the shared balance decreases; payable becomes *paid*; budget use is recorded | Pay more than the payable amount |
| 7 | Operations | Sends fabric to the manufacturer | Manufacturing order in state *planned*, then *in progress*; stock movement out (fabric, not finished goods) | Send more fabric than is in stock |
| 8 | Operations | Records the return of finished goods | Finished-goods receipt against the manufacturing order; manufacturing order *completed*; stock movement in at accumulated cost | Create finished stock without a manufacturing order |
| 9 | Simulated cashier | Makes a sale at the store | Sale order *created*; stock reserved | Sell with zero available stock |
| 10 | Simulated cashier | Receives payment | Cash ledger entry in (or a receivable, if the payment is deferred); sale order *paid* | Recognize revenue |
| 11 | Operations | Delivers the product to the customer | Sale order *delivered*; stock consumed; revenue recognized | Consume stock before delivery |
| 12 | Customer Service | Opens a case for an exchange request | Case; exchange request sent to Finance | Change stock or cash by itself |
| 13 | Finance | Approves or rejects the exchange (ADR 0025) | If approved, a return movement in and a refund ledger entry out; if rejected, the case is closed with a reason | Refund without an approval |

Steps 9 and 10 are performed by the simulated cashier. The participant does not make the sale. Who generates the sale, and when, is an open point (section 7).

## 5. State rules

- **Purchase order:** *draft* → *sent* → *partially received* or *received* → *closed*. It can be *cancelled* from *draft* or *sent*.
- **Goods receipt:** can only refer to an open purchase order. A quantity above the ordered amount is recorded as a divergence, not as a silent change.
- **Stock movement:** append-only. The stock level is the sum of movements. It can never be negative.
- **Manufacturing order:** *planned* → *in progress* → *completed*, or *cancelled*. It holds the planned quantity, the quantity actually produced, the estimated cost and the due date. Finished goods enter stock only when completed.
- **Sale order:** *created* (stock reserved) → *paid* → *delivered*. Revenue is recognized at *delivered*. Cancelling a sale releases the reservation.
- **Payable and receivable:** created by the source document (purchase receipt or sale). Cash moves only at payment.
- **Budget:** a view over the shared balance. It records commitments (purchase orders not yet paid) and use (payments). The shared balance is the only cash.

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
- I10. Cost of finished goods is the accumulated cost of materials, outsourced labor, labels, packaging and acquisition freight. The simplified model is used first; a full bill of materials is a later phase.

## 7. Open points for the owner

1. **Budgets:** should a budget block a purchase when it is used up, or only warn? Who sets the amounts, and when?
2. **Simulated sales:** the simulated cashier needs a generator of sales. Is this the Simulation Engine (Phase 5), or a simple rule in Phase 3?
3. **Deferred payment:** can a customer pay later, creating a receivable at the store? If yes, the receivable enters the cycle in step 10.
4. **Manufacturing order in the first version:** the simplified entity in the owner's note is accepted as the proposal. Confirm that it is needed in Phase 3, not Phase 1.

## 8. Acceptance scenarios

These checks describe what a test must verify. They are not tests yet.

1. **Full cycle:** run steps 0 to 11 and check the shared balance, stock and revenue after each step against the expected values.
2. **Divergence:** a receipt with two units fewer than ordered records a divergence and leaves the stock at the received quantity.
3. **Sale without stock:** a sale for a SKU with zero available stock is rejected, and no reservation, stock, cash or revenue change occurs.
4. **Revenue timing:** a paid sale that is not yet delivered creates cash but no revenue (invariant I8).
5. **Duplicate action:** the same receipt submitted twice with the same key creates one stock movement.
6. **Message without effect:** a message saying a purchase was made changes no stock and no cash (invariant I5).

## 9. Phase mapping

The loop belongs to Phase 3 (`06-ROADMAP.md`, section 6). Phase 1 is the foundation (option A, owner decision 2026-11-17). Budgets, the shared balance and the capital contribution are not in the current roadmap; they need a scope decision before Phase 3.
