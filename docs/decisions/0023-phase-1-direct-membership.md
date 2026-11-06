# 0023 — Phase 1 Membership Is a Direct Link

**Status:** APPROVED  
**Date:** 2026-11-06  
**Approved by:** Project owner

---

## Context

`06-ROADMAP.md`, section 4, requires "organization membership" in Phase 1: a user must have an identity and a membership in the organization.

ADR 0005 decides that participants apply to predefined vacancies, which simulate a hiring process. The vacancy flow and the applicant review are not in Phase 1. The first release's acceptance scenario 1 (`06-ROADMAP.md`, section 14) is the first place the full application flow is required.

ADR 0022 decides that Phase 1 uses test accounts only.

## Alternatives

1. **Direct link.** Chosen. The owner, or the test setup, links a test account to the fixed organization with a role. No application or review step. Cost R$ 0. Low maintenance.
2. **Vacancy application now.** Discarded for Phase 1: it needs vacancies, applicant states and a review step, none of which is part of the Phase 1 exit criteria.
3. **Open self-join.** Discarded: it contradicts ADR 0005.

## Decision

1. In Phase 1, a membership is created directly by the owner or by the test setup. A participant does not apply to a vacancy.
2. The membership stores the organization, the account and the role. Each role has one occupant (ADR 0007).
3. ADR 0005 stays as it is. The vacancy flow is built in the phase where the first release needs it, to be decided in `06-ROADMAP.md`.

## Rationale

- Membership and permissions can be built and tested without the hiring flow.
- The Phase 1 exit criterion "organizational membership is persisted" is met.
- No new rule is invented: the direct link only skips the application step, which the roadmap does not yet need.

## Consequences

- Phase 1 has no candidacy screens and no vacancy data.
- When the vacancy flow is added, the direct link stays available for test accounts, or is removed by a new decision.
- The phase in which the vacancy flow is built is still to be decided. It is recorded as pending in the session record.
