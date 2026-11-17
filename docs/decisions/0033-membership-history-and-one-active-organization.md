# 0033 — Membership History and One Active Organization per Account

**Status:** APPROVED  
**Date:** 2026-11-17  
**Approved by:** Project owner (answers to Q-027, Q-032 and Q-041, recorded 2026-11-17)

---

## Context

ADR 0023 makes membership in Phase 1 a direct link between an account, an organization and a role. ADR 0007 says each role has one occupant at a time. The owner later answered three questions that the membership model needed:

- Q-027: can one account hold more than one role in one organization? Answer: one role at a time per account in one organization.
- Q-032: should membership history be kept from Phase 1? Answer: yes, with start and end dates, because history is the basis for promotions, changes of company and, later, the weight of each company in a career (`07-PROGRESSION-AND-REWARDS.md`).
- Q-041: can one account be active in two organizations at the same time? Answer: no. Changing organization ends the active membership in the earlier one, which stays in the history.

The business text of these rules is in `docs/08-COMPANY.md`, section 10.6, on branch `docs/company-revision-proposal`, commit `56c5e56` (read with `git show origin/docs/company-revision-proposal:docs/08-COMPANY.md`). That branch is not merged into `main` yet. Section 10 of that file is marked PROPOSED; section 10.6 records the owner's decisions. This record cites section 10.6 only.

The database design that stores these rules is in ADR 0032 and `docs/database/phase-1-database-architecture.md`, sections 7.3 and 14.

## Alternatives

1. **Current state only.** Each membership row is changed or deleted when the role or the organization changes. Advantages: simplest table. Disadvantages: no history for promotions or changes of company; history must be rebuilt later from other records, if at all. Cost: R$ 0. Impact: high, because the career rules of Phase 7 would have no source.
2. **History kept, several active organizations per account.** Advantages: flexible for a future multi-organization platform (Phase 8). Disadvantages: the rule of Q-041 would not be enforced; a single account could hold two organizations' roles at once, which the owner did not decide. Cost: R$ 0. Impact: medium.
3. **History kept, one active membership per account, one active occupant per role per organization.** Chosen by the owner. Advantages: matches the owner's answers; history supports careers; the database enforces the rules with partial unique indexes. Disadvantages: moving between organizations is a two-step change (end, then start), which the application must perform in one transaction. Cost: R$ 0. Impact: low to medium.

## Decision

1. **An account holds one role at a time in one organization** (Q-027). At most one active membership per account in one organization.
2. **An account belongs to one organization at a time** (Q-041). At most one active membership per account across all organizations. Changing organization ends the active membership in the previous organization. That membership stays in the history.
3. **Each role has one active occupant per organization** (ADR 0007).
4. **Membership history is kept from Phase 1** (Q-032). Each membership records a start date and, when it ends, an end date. Rows are ended, not deleted. Promotions and changes of company are read from this history.
5. **Enforcement.** The database has a partial unique index on the account for active rows, and a partial unique index on the organization and role for active rows, as described in ADR 0032 and the proposal, section 7.3. The application ends and starts memberships in one transaction.

## Rationale

- The owner's answers to Q-027, Q-032 and Q-041 are direct and recorded; option 3 is the only one that matches all three.
- Keeping the history from Phase 1 avoids rebuilding career data later. The owner named promotions and changes of company as its uses (`docs/08-COMPANY.md`, section 10.6).
- Enforcement in the database means the rule holds even if an application path is missed. It is tested in the Phase 1 test suite (ADR 0032).
- The rule is consistent with ADR 0007 (one occupant per role) and ADR 0023 (direct link). It does not change either.

## Consequences

- Membership rows are history. The application never deletes them. The foreign key from membership to account uses `ON DELETE RESTRICT`, so removing an account cannot erase its history by accident. Removal for personal-data rights needs its own rule before Phase 4 (Q-002).
- A role change, a departure or a change of organization each ends one membership and, if needed, starts another in one transaction.
- Phase 2 and later: business rules that read careers (Phase 7, `07-PROGRESSION-AND-REWARDS.md`) depend on this history. Any change to these rules needs a new decision record.
- The owner's answer means Product and Documentation's text in `08-COMPANY.md` (section 10.6) becomes the source of the business rule. When that branch is merged, this record and the text must still agree.
- Two active organizations at once is not supported. Phase 8 (multi-organization platform, `06-ROADMAP.md`) would need a new decision if the owner later allows it.
- Cost: R$ 0 per month. No change to Phase 1 scope other than the database rules in ADR 0032.
