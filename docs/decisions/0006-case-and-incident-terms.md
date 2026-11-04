# 0006 — Case and Incident Terms

**Status:** APPROVED  
**Date:** 2026-11-03  
**Approved by:** Project owner

---

## Context

The documents used several words for overlapping ideas: "task", "case", "issue", "incident". `04-AI-AGENTS.md` (section 12) used "issue", while `02-BUSINESS-SIMULATION.md` (sections 5.4 and 6.5) used "case" for customer problems.

## Alternatives

1. **Case and incident.** Case for customer-related work; incident for unplanned operational problems. Both may create tasks.
2. **Task only.** Everything is a task. Fewer terms, but customer and operational work become indistinguishable.
3. **Issue.** A single term for both. Vague.

## Decision

Use **case** for customer-related work followed to resolution, and **incident** for unplanned operational problems. A task remains a work item assigned to a role or department.

## Rationale

The two situations have different owners, timelines and resolution paths. Separate terms keep the simulation readable and make the customer experience distinct from operations.

## Consequences

- `GLOSSARY.md` records the definitions.
- `04-AI-AGENTS.md` section 12 uses "case, task or incident".
