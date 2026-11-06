# 0026 — Vacancy Application Flow Is Built in Phase 2

**Status:** APPROVED  
**Date:** 2026-11-06  
**Approved by:** Project owner

---

## Context

ADR 0005 decides that participants apply to predefined vacancies. ADR 0023 decides that Phase 1 memberships are direct links, and that the vacancy flow is not part of Phase 1.

The vacancy flow needs vacancies, application states and an acceptance step. Those depend on the organization's departments and roles, which are created in Phase 2 (`06-ROADMAP.md`, section 5). Phase 2 scope already includes "initial participant role assignment".

## Alternatives

1. **Phase 2: vacancies, applications and acceptance.** Chosen. Applications fill the roles that Phase 2 creates, and the role assignment in the Phase 2 scope is done through them.
2. **Phase 4: with the participant workspace.** Discarded: a participant would start working without an official way to enter the organization. The Phase 4 scope is the workspace, not hiring.
3. **Phase 3: with the business workflows.** Discarded: Phase 3 is about orders, stock and delivery. Hiring has no place in that cycle.

## Decision

1. In Phase 2, the organization has vacancies, one for each participant role, as `08-COMPANY.md`, section 7 describes.
2. A participant applies to an open vacancy. The application is accepted or rejected, and an accepted application creates the membership with its role.
3. The direct link from ADR 0023 stays available for test accounts.
4. ADR 0005 stays as it is. This ADR fixes only the phase.

## Rationale

- The first release's acceptance scenario 1 ("a participant applies to an open vacancy, and is assigned to the role when the application is accepted") needs this flow. Building it in Phase 2 lets it be tested before the workspace exists.
- Phase 2 creates the roles, so the vacancies have something to point to.
- Phase 4 stays the workspace phase, as the roadmap defines it.

## Consequences

- Phase 2 gains: vacancies, applications, and acceptance or rejection of applications.
- The Phase 2 scope in `06-ROADMAP.md`, section 5, is updated to list these items.
- Cost: R$ 0 per month. Maintenance: one more set of tables and rules, covered by the Phase 2 tests.
