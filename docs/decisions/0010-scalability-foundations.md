# 0010 — Scalability Foundations

**Status:** APPROVED  
**Date:** 2026-11-03  
**Approved by:** Project owner

---

## Context

Expathio is meant to support many organizations and many participants over time (`05-TECHNICAL-ARCHITECTURE.md`, sections 2 and 10). The first version will be small, and the architecture should not add infrastructure for a scale that does not exist yet (`05`, sections 18 and 20).

Some architectural choices are cheap to make at the start and costly to change later. The owner asked which of them should be fixed now.

## Alternatives

1. **Design for large scale from the start**: distributed services, message brokers, data sharding. Rejected: adds complexity and cost without a current need (`05`, section 3).
2. **Adopt a few low-cost foundations now, and scale later through configuration and new decisions.** Chosen.
3. **Ignore scale until it is needed.** Rejected: isolation of data, statelessness and file storage are hard to retrofit once the code depends on them.

## Decision

The following foundations apply from the first implementation:

1. **Data isolation by organization.** Every table that holds business data includes an organization identifier. Every query filters by it. Domain rules enforce this, and tests check it.
2. **Stateless application instances.** An application instance keeps no state that another instance cannot read. Sessions and files live in shared storage. In-memory caches are optional and never the only copy of anything.
3. **External file storage behind an abstraction.** Business code does not depend on local disk paths. The storage location is a configuration value, so files can move to shared storage without changing business code.
4. **Idempotent background operations.** Repeating a background operation produces the same result and no duplicate effect. For example, a retried job must not create a second order or move stock twice.

## Rationale

Each foundation costs little now and avoids a rewrite later. None of them adds a new service, broker or infrastructure component, so they fit the modular monolith (`05`, section 3).

Together they make a later increase in capacity mainly a question of configuration: more application instances, a shared database with read replicas, and separate worker processes.

## Consequences

- Tests must cover organization isolation and the idempotency of background operations, in addition to business rules.
- The file storage abstraction adds a small layer of code in the first implementation.
- This ADR does not design for a specific number of users. Scaling beyond one application instance, or a change of database topology, requires a new decision.
- The hosting choice does not change these rules. Any host must support them.
