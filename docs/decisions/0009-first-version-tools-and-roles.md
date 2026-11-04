# 0009 — First-Version Roles and Tools

**Status:** APPROVED  
**Date:** 2026-11-03  
**Approved by:** Project owner

---

## Context

The first version needs a set of participant roles and tools that supports a complete business cycle (`06-ROADMAP.md`, Phase 3) without the cost and complexity of the full organization.

## Alternatives

1. **Four participant roles, simulated tools only** (Operations, Customer Service, Sales, Finance). Covers the purchase-to-refund cycle.
2. **Eight roles, one per department.** Wider coverage, but more tools to build before the cycle works.
3. **Include a simulated development workflow in the first version.** Closer to the vision, but depends on the deferred workflow decision (`0002`).

## Decision

The first version has four participant roles: Operations Coordinator, Customer Service Specialist, Sales Analyst and Financial Analyst. Each receives the tools listed in `08-COMPANY.md`, section 3. Common tools are shared by all roles. The sales dashboard is read-only. Technology, Marketing, Product and Design, and Executive roles are deferred.

## Rationale

Four roles cover the purchase, fulfillment, support and refund cycle, which is enough to demonstrate interdepartmental consequences (`06-ROADMAP.md`, Phase 3). Deferring the others keeps the first version within the time and cost limits.

## Consequences

- `08-COMPANY.md` is the reference for roles and tools.
- `01-PRODUCT.md` section 3.5 points to it.
- The development workflow decision must be revisited before a Technology role is added.
