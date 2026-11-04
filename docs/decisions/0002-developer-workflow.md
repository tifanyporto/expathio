# 0002 — Developer Workflow in the First Version

**Status:** APPROVED  
**Date:** 2026-11-03  
**Approved by:** Project owner

---

## Context

Developer roles should eventually work with real code, Git, branches, pull requests and deployment (`00-VISION.md`, section 4). The question was how this works in the first version, and whether participants connect their real GitHub accounts.

## Alternatives

1. **Simulated workflow.** Commits, reviews and deployments happen inside Expathio. No external accounts.
2. **Real GitHub from the start.** Participants connect their GitHub accounts in the first version. Requires authorization, sandboxing and security work from the beginning.

## Decision

The first version uses a simulated development workflow. Connection to real GitHub repositories is a long-term goal.

## Rationale

Connecting real accounts requires authentication with an external service, isolation of code execution, and secure storage of tokens. These are significant risks for a first version that has no development team and a small weekly budget of time (`06-ROADMAP.md`, section 1).

## Consequences

- `00-VISION.md` section 4 states the long-term goal only.
- `01-PRODUCT.md` section 3.5 marks development environments and version control as long-term.
- The mechanism for GitHub connection is not defined and will need its own decision when the goal becomes a phase.
