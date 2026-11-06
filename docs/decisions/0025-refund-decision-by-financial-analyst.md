# 0025 — Refund Requests Are Approved or Rejected by the Finance Assistant

**Status:** APPROVED  
**Date:** 2026-11-06  
**Approved by:** Project owner

---

## Context

`08-COMPANY.md`, section 5, gives Customer Service the job of sending refund or exchange requests to Finance. Section 7.4 says the Finance Assistant "reviews refund requests", without saying whether the review ends in a decision.

The permissions proposal in `08-COMPANY.md`, section 6.1, needs this answer before the Platform Engineering session can write the rules.

## Alternatives

1. **Finance Assistant approves or rejects.** Chosen. The refund is decided in Finance, which owns the payment and refund ledger.
2. **Finance Assistant only records.** Discarded: the refund would then be decided by no one, and Customer Service would have no reply to act on.
3. **Customer Service decides.** Discarded: it gives Customer Service control over money that the ledger belongs to Finance.

## Decision

1. A refund or exchange request from Customer Service is sent to the Finance Assistant.
2. The Finance Assistant approves or rejects it. The decision is recorded in the payment and refund ledger, and the case shows the result.
3. Customer Service cannot approve or reject a refund.

## Rationale

- It matches the separation of duties that the roles already describe: Finance owns the ledger.
- The request and its decision are both recorded, so the consequence is observable (`01-PRODUCT.md`, section 7).

## Consequences

- Phase 3 includes the approve or reject step for refunds.
- The permission matrix in `08-COMPANY.md`, section 6.1, reflects this decision.
- Cost: R$ 0 per month.
