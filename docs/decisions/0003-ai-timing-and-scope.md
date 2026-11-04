# 0003 — AI Timing and Scope

**Status:** APPROVED  
**Date:** 2026-11-03  
**Approved by:** Project owner

---

## Context

`04-AI-AGENTS.md` describes AI agents, and section 15 suggested an initial scope for them. `06-ROADMAP.md` places AI in Phase 6, after the deterministic simulation exists. These two documents needed to agree.

## Alternatives

1. **AI in Phase 6 (after the deterministic simulation).**
2. **AI before Phase 6**, in a specific role, such as customer complaints.

Also decided: whether agents may coordinate decisions across departments (autonomy level 4), in the first AI-enabled version.

## Decision

AI enters in Phase 6. The first AI-enabled version stays within autonomy levels 1 to 3. Level 4 (strategic coordination across departments) is outside its scope.

## Rationale

The Roadmap requires that deterministic business processes work first. Level 4 adds the most cost and the least predictability, and it depends on the simulation already being stable.

## Consequences

- `04-AI-AGENTS.md` section 15 describes the first AI-enabled version, not the first release.
- `04-AI-AGENTS.md` section 5 marks level 4 as out of scope.
