# 0024 — Phase 1 Loads the Four Business Roles

**Status:** APPROVED  
**Date:** 2026-11-06  
**Approved by:** Project owner

---

## Context

`06-ROADMAP.md`, section 4, requires a "basic role and permission structure" in Phase 1.

ADR 0009 decides that the first version has four participant roles, with the tools listed in `08-COMPANY.md`, section 5: Operations Coordinator, Customer Service Specialist, Sales Analyst and Financial Analyst.

ADR 0023 decides that Phase 1 memberships are direct links, so each link needs a role to point to.

## Alternatives

1. **Load the four business roles now, with no behavior.** Chosen. The roles exist as data, with their names and permissions. The tools and business workflows that use them are built in later phases.
2. **Only the role and permission structure, with no business roles.** Discarded: permissions could only be tested with invented roles, which would not match the real model in `08-COMPANY.md`.
3. **Full behavior for the four roles now.** Discarded: it belongs to Phases 2 and 3, where departments and workflows exist.

## Decision

1. In Phase 1, the four roles from ADR 0009 are loaded as data: name, description and the permissions defined for each.
2. The roles carry no business behavior in Phase 1. No tool or workflow is tied to them until the phase that needs it.
3. Permissions are enforced by the backend, as `CLAUDE.md`, section 10, requires. Hiding a role's screens is not access control.

## Rationale

- Permission rules can be tested against the real role model, not against placeholders.
- The Phase 1 exit criterion "basic access restrictions are enforced" is tested with the actual roles.
- Loading data without behavior adds no business logic to Phase 1.

## Consequences

- Phase 1 includes the seed data for the four roles, tied to the fixed organization (ADR 0023).
- The exact permissions for each role are not defined here. They must be listed in `08-COMPANY.md` or in a later decision before the Platform Engineering session writes the permission rules.
- Cost: R$ 0 per month.
