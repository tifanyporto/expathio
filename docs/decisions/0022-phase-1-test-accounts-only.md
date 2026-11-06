# 0022 — Phase 1 Uses Test Accounts Only

**Status:** APPROVED  
**Date:** 2026-11-06  
**Approved by:** Project owner

---

## Context

`06-ROADMAP.md`, section 4, puts authentication and basic user management in Phase 1. Login needs accounts, and accounts hold personal data.

Two approved decisions limit real data. ADR 0011 allows no real participant data before the Phase 4 hosting decision. `01-PRODUCT.md`, section 12, requires account data rules (what is collected, who sees it, how long it is kept, export and deletion) before Phase 4 admits the first real participant. The two sources do not conflict on their own, but the Phase 1 scope in `06` would put real accounts on the production phone unless this is stated.

## Alternatives

1. **Test accounts only in Phase 1.** Chosen. Accounts are created by the project owner or by the test suite, with fictional data. No real person signs up in Phase 1. Cost R$ 0. Keeps the Phase 4 privacy work where it was planned.
2. **Define the account data rules now.** Discarded for now: it adds privacy work before any screen exists, and the rules depend on decisions not yet taken (see `01`, section 12).
3. **Real accounts on the development computer only.** Discarded: real data would sit on the development machine, which is not the place for personal data (ADR 0015).

## Decision

1. In Phase 1, every account is a test account. Test accounts use fictional data and are created by the owner or by automated tests.
2. No real person is asked to create an account or sign in to the production phone during Phase 1.
3. The privacy rules in `01-PRODUCT.md`, section 12, remain required before Phase 4, as already recorded.

## Rationale

- Login can be built and tested without collecting personal data, so Phase 1 stays on schedule.
- ADR 0011 and `01`, section 12, are respected without being changed.
- Test accounts follow `CLAUDE.md`, section 11.

## Consequences

- The Phase 1 exit criterion "user authentication works" is proven with test accounts.
- Opening the platform to real participants is blocked until the Phase 4 privacy rules and hosting decision exist.
- Test accounts must be clearly marked as simulated in the interface (`CLAUDE.md`, section 11).
- Cost: R$ 0 per month.
