# 0028 — Phase 1 Login and Post-Login Screen Decisions

**Status:** APPROVED  
**Date:** 2026-11-06  
**Approved by:** Project owner

---

## Context

The Experience and Design session needs four product answers to specify the first Phase 1 screen (`09-DESIGN-SYSTEM.md`, section 13.2). Phase 1 uses test accounts only (ADR 0022) and a fixed organization (`06-ROADMAP.md`, section 4).

## Alternatives

1. **Login identifier.** E-mail (chosen), or a username. E-mail is the usual identifier in the login library chosen in ADR 0014, and test accounts use fictional addresses. A username would need a new rule with no benefit in Phase 1.
2. **Page after login.** Chosen: a simple page with the organization name (MONUMENT), the role of the membership, and a label that the data is simulated (`CLAUDE.md`, section 11). No business content, because the business tools start in Phase 2 or later. Alternative: an empty page with no organization data. Discarded: Phase 1 must show that the user has access to an organization and a membership in it (`06-ROADMAP.md`, section 4).
3. **Password recovery.** Not in Phase 1 (chosen). Test accounts are created and reset by the owner or the test setup. Recovery is decided with the privacy rules before real accounts exist (`01-PRODUCT.md`, section 12; Phase 4).
4. **Expathio name.** The text "Expathio" is used in place of a logo until a logo decision is made (chosen). A logo is not defined anywhere in the documents.

## Decision

1. The login identifier is an e-mail address. Test accounts use fictional addresses.
2. The page after login shows: the organization name, the role of the membership, and a clear label that the data is simulated. It has no business content in Phase 1.
3. There is no password recovery in Phase 1.
4. The product name shown in the interface is the text "Expathio" until a logo is approved.

## Rationale

- Each answer matches an approved decision: test accounts (ADR 0022), direct membership (ADR 0023), and the Phase 1 scope (`06`, section 4).
- Nothing in the screen depends on real personal data.

## Consequences

- The Experience and Design session can specify the login screen and the post-login page without waiting for a logo.
- Password recovery is a new feature for Phase 4 and needs its own decision then.
- Cost: R$ 0 per month.
