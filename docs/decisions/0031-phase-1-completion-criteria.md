# 0031 — Phase 1 Completion: Local Environment and Deployment Script

**Status:** APPROVED  
**Date:** 2026-11-17  
**Approved by:** Project owner

---

## Context

`06-ROADMAP.md`, section 4, lists the Phase 1 scope and exit criteria. Two items concern the environment: "Project initialization and development and test environments, reproducible on the development computer" (scope item 1) and "Application runs consistently" (exit criteria). Neither names the production phone.

The production phone (POCO F3) is the host through Phase 3 (ADR 0011). Phase 1 deploys to it only through the deployment script defined in ADR 0016, which is built in Phase 1. Access to the phone is only available at the owner's home, so its configuration cannot be a precondition for the team to advance.

## Alternatives

1. **Phase 1 ends only when the application runs on the phone.** Proves the production path early. Discarded: it makes Phase 1 depend on a device that is not always reachable, and it blocks work on the database and the backend, which do not need the phone.
2. **Phase 1 ends with a reproducible local environment and a tested deployment script, with the phone configured later.** Chosen. The script and its documentation are part of Phase 1. The first run against the phone happens when the owner has access and approves each step.
3. **Phase 1 ends with the local environment only, with the deployment script built in a later phase.** Discarded: ADR 0016 places the script in Phase 1, and the rollback steps are a known gap until it exists.

## Decision

1. Phase 1 is complete when:
   - the development environment is reproducible on the development computer (`06-ROADMAP.md`, section 4, item 1);
   - the deployment script and its documentation exist and have been tested against a local target, with the health check and rollback steps described in ADR 0016;
   - the other Phase 1 exit criteria in `06-ROADMAP.md` are met.
2. Running the application on the production phone is not a condition for completing Phase 1. The first deployment to the phone happens later, when the owner has access and approves each step.
3. Q-007 (the PostgreSQL and Node.js versions on the phone) must still be decided before the Phase 1 development setup is finished, as recorded in `docs/OPEN-QUESTIONS.md`.

## Rationale

- The criteria match what Phase 1 must prove: that the platform foundation works and can be reproduced. A running phone is not required for that.
- The owner's access to the phone depends on location. Phase 1 should not wait for it.
- ADR 0011 and ADR 0016 remain in force. This decision only states that the phone is not a precondition for finishing Phase 1.

## Consequences

- The deployment script is tested against a local target first. Its first run against the phone is a separate, owner-approved step.
- The rollback steps are written when the script is built, as ADR 0016 requires.
- Cost: R$ 0 per month. Maintenance: the script and its documentation.
- This decision does not decide where development happens when the owner is away from the development computer. That question remains open with the owner.
