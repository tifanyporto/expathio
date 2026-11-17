# First Business Cycle of MONUMENT

**Status:** PROPOSED  
**Document type:** Scenario specification  
**Project:** Expathio  
**Owner of this document:** Product and Documentation

---

## 1. Purpose

This document describes the first complete business loop of MONUMENT, as verifiable steps. The owner's direction (2026-11-17) is: open one physical store, buy materials, send them to an outsourced manufacturer, receive the finished goods and sell them. Then the loop repeats, and the company grows only when the money from sales allows it.

This is a specification for later phases. It does not change the Phase 1 scope, which is still awaiting the owner's choice between option A and option B in `docs/OPEN-QUESTIONS.md`. The roadmap places business workflows in Phase 3 (`06-ROADMAP.md`, section 6).

Roles are as proposed in `docs/08-COMPANY.md`, section 10.9: Operations Assistant, Customer Service Representative and Finance Assistant. Purchase approval is not part of the first version (owner, 2026-11-17).

## 2. Starting state

- Organization: MONUMENT, with one physical store and one online location. Each location has its own stock (`docs/decisions/0017-physical-stores-in-first-release.md`).
- Stock: zero.
- Cash: the owner's initial capital is recorded as a single entry at the start. How capital enters the system is an open point (section 7).
- Suppliers: one fabric and trim supplier, and one outsourced manufacturer. All fictional.

## 3. Entities involved

Supplier; supplier terms; product; variant (size and color); SKU; purchase order; goods receipt; stock movement; manufacturing order; finished-goods receipt; customer; sale order; payment; ledger entry (cash); payable; receivable; customer case (from step 9).

## 4. Steps

| # | Role | Action | Effect on state | Must not |
|---|---|---|---|---|
| 1 | Operations | Registers the fabric supplier and its terms | Supplier record | Create a purchase order without a supplier |
| 2 | Operations | Registers a product, its variants and a SKU | SKU with zero stock and no cost yet | Sell or receive a SKU that has no variant |
| 3 | Operations | Creates a purchase order for fabric | Purchase order in state *draft*, then *sent* | Move stock or cash |
| 4 | Operations | Records the receipt of the fabric | Goods receipt against the open purchase order; stock movement in; purchase order becomes *received* or *partially received*; a payable is created | Accept a receipt without an open purchase order |
| 5 | Finance | Registers the payment to the supplier | Cash ledger entry out; payable becomes *paid* | Pay more than the payable amount |
| 6 | Operations | Sends fabric to the manufacturer | Manufacturing order in state *sent*; stock movement out (fabric, not finished goods) | Send more fabric than is in stock |
| 7 | Operations | Records the return of finished goods | Finished-goods receipt against the manufacturing order; stock movement in, at accumulated cost; manufacturing order becomes *received* | Create finished stock without a manufacturing order |
| 8 | Operations | Registers the first sale at the store | Sale order in state *created*, stock reserved; then *paid* (cash ledger entry in, receivable settled); then *fulfilled* (stock consumed) | Sell with zero available stock |
| 9 | Customer Service | Opens a case for an exchange request | Case; exchange request sent to Finance | Change stock or cash by itself |
| 10 | Finance | Approves or rejects the exchange (ADR 0025) | If approved, a return movement in and a refund ledger entry out; if rejected, the case is closed with a reason | Refund without an approval |

Step 8 is the first sale. The owner will confirm later whether the sale is made by Operations at the counter (section 7).

## 5. State rules

- **Purchase order:** *draft* → *sent* → *partially received* or *received* → *closed*. It can be *cancelled* from *draft* or *sent*.
- **Goods receipt:** can only refer to an open purchase order. A quantity above the ordered amount is recorded as a divergence, not as a silent change.
- **Stock movement:** append-only. The stock level is the sum of movements. It can never be negative.
- **Manufacturing order:** *sent* → *received*. Finished goods enter stock only when received.
- **Sale order:** *created* (stock reserved) → *paid* → *fulfilled* (stock consumed). Cancelling a sale releases the reservation.
- **Payable and receivable:** created by the source document (purchase receipt or sale). Cash moves only at payment.

## 6. Invariants (must always hold)

- I1. Stock is never negative.
- I2. Cash changes only through a payment or refund ledger entry.
- I3. Every stock movement and every ledger entry links to its origin document.
- I4. A receipt without an open purchase order is rejected.
- I5. A message, comment or note changes no stock and no cash.
- I6. Repeating the same action with the same key creates one effect only.
- I7. A sale with no available stock is rejected.
- I8. The cost of finished goods is the accumulated cost of the materials and the manufacturing fee (simplified; see section 7).

## 7. Open points for the owner

1. Who sells at the counter in the first version: Operations, or another role?
2. How the initial capital enters the system (owner input, or a fixed amount).
3. When revenue is recognized: at sale, at payment, or at fulfillment.
4. Product cost: simple accumulation of purchase and manufacturing costs (proposed), or a full bill of materials. The full version is a later phase.
5. Whether the manufacturing order needs its own entity in the first version, or only a record of material out and finished goods in.

## 8. Acceptance scenarios

These checks describe what a test must verify. They are not tests yet.

1. **Full cycle:** run steps 1 to 8 and check the stock and the cash after each step against the expected values.
2. **Divergence:** a receipt with two units fewer than ordered records a divergence and leaves the stock at the received quantity.
3. **Sale without stock:** a sale for a SKU with zero available stock is rejected, and no reservation, stock or cash change occurs.
4. **Duplicate action:** the same receipt submitted twice with the same key creates one stock movement.
5. **Message without effect:** a message saying a purchase was made changes no stock and no cash (invariant I5).

## 9. Phase mapping

Not decided. The roadmap places this loop in Phase 3. The owner has still to choose between option A (Phase 1 stays a foundation) and option B (a minimal version of the loop enters Phase 1). Until then, this document is the reference for the architecture.
