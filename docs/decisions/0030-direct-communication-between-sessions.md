# 0030 — Direct Communication Between Sessions Without Prior Approval

**Status:** APPROVED  
**Date:** 2026-11-09  
**Approved by:** Project owner  
**Supersedes:** ADR 0029, decision point 2 (owner approval of the first direct message)

---

## Context

ADR 0029 allowed direct messages between sessions. It required the owner to approve that form of communication the first time, and after that it became the default. The owner has since decided that direct communication between sessions is permitted and recommended, without that first approval. The owner also decided that the project continues without asking the owner, except for decisions that depend on the owner.

The rules for this are in `CLAUDE.md`, sections 2, 7 and 14.

## Alternatives

1. **Keep the first-approval step from ADR 0029.** The owner stays in the loop for every new form of communication. Discarded: the owner asked for direct communication to be the default, and the first-approval step only delays it.
2. **Allow direct messages with no record.** Fast, but the owner loses sight of cross-function requests. Discarded: each request still needs a record.
3. **Allow direct messages, record each request in the sending session's record, and send the owner only the decisions that depend on the owner.** Chosen.

## Decision

1. A session may, and is encouraged to, request something from another session by direct message. No prior approval is needed.
2. Each request is recorded in the sending session's record under `docs/sessions/<function>/`.
3. The owner is consulted only for business rules, visual decisions, and external dependencies that depend on the owner's approval (`CLAUDE.md`, section 2).
4. Direct messages do not replace documents. Decisions go to `docs/decisions/`, and questions for another function go to `docs/OPEN-QUESTIONS.md`.
5. Only the owner closes entries in `docs/OPEN-QUESTIONS.md`.
6. Decision point 2 of ADR 0029 is superseded by this decision. The other points of ADR 0029 remain in force.

## Rationale

- Requests between functions move faster when the sessions can speak directly, and the owner's time is kept for decisions that need the owner.
- The record of each request keeps the work traceable without a first-approval step.
- Documents and the owner's closure of entries keep the same authority as before.

## Consequences

- Sessions must record each outgoing request in their own record.
- A session that receives a request answers in its own function's scope, or routes it on.
- Cost: R$ 0 per month. Maintenance effort is a convention.
