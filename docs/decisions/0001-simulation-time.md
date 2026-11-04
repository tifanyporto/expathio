# 0001 — Simulation Time

**Status:** APPROVED  
**Date:** 2026-11-03  
**Approved by:** Project owner

---

## Context

The simulation needs a clock. The choice affects operating cost, how absence is handled, how progression is measured, and how events are ordered. The question was open in `02-BUSINESS-SIMULATION.md` (section 11), `05-TECHNICAL-ARCHITECTURE.md` (section 7.1) and `01-PRODUCT.md` (section 11, question 5).

## Alternatives

1. **Simulated days (discrete).** The organization advances in steps, one simulated day per cycle. Cheap to run, easy to audit, easy to pause.
2. **Continuous real time.** The simulation follows the wall clock. More realistic, but requires constant processing.
3. **Event-driven.** No clock; time advances when something happens. Hard to explain to participants.

## Decision

The organization advances in simulated days. Each organization has one shared timeline.

## Rationale

Simulated days keep costs predictable and fit the free-tier constraint. They make it possible to replay and audit what happened on each day. A shared timeline keeps the organization coherent, because all departments act on the same state.

## Consequences

- `02-BUSINESS-SIMULATION.md` section 11 and `05-TECHNICAL-ARCHITECTURE.md` section 7.1 now refer to this decision.
- The mechanics, such as how many events occur per day, still need to be specified in `02`.
- Absence (`03-USER-EXPERIENCE.md`, section 12) is measured in simulated days.
