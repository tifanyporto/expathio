# 0029 — Direct Messages Between Sessions

**Status:** APPROVED, decision point 2 superseded by ADR 0030  
**Date:** 2026-11-09  
**Approved by:** Project owner

---

## Context

The project is worked on through several sessions, each with a function (`docs/SESSION-STRUCTURE.md`). Sessions do not talk to each other directly by default. Information moves through documents and through the owner (`CLAUDE.md`, section 14). In practice this makes a simple question wait for the owner to relay it, even when the answer is a document change in another function.

On 2026-11-09 the owner tested direct messages between two sessions, the Experience and Design session and the Product and Documentation session, and approved the rule recorded here. The rule was recorded as open question Q-020 in `docs/OPEN-QUESTIONS.md` and is already reflected in `CLAUDE.md`, section 14.

## Alternatives

1. **Documents and owner only.** Sessions never message each other. Every request passes through the owner. Simple and fully visible, but slow for requests the owner does not need to decide.
2. **Direct messages allowed without approval.** Sessions request things from each other freely. Fast, but the owner loses sight of cross-function work.
3. **Direct messages allowed after the owner's first approval, then the default.** Chosen. The owner approves the form of communication once. After that it is the default, unless the owner explicitly disapproves it. Every request is recorded in the sending session's record, so the owner can see it.

## Decision

1. A session may request something from another session by direct message.
2. The owner approves this form of communication the first time it is used. After that it is the default, unless the owner explicitly disapproves it.
3. Each request is recorded in the sending session's record (`docs/sessions/<function>/`), so the owner can trace it.
4. Direct messages do not replace documents. A decision goes to `docs/decisions/`, and a question for another function goes to `docs/OPEN-QUESTIONS.md`.
5. Direct messages do not change the authority of the owner. A session cannot approve a decision, change another function's document without the owner's request, or close an open question. Only the owner closes entries in `docs/OPEN-QUESTIONS.md`.

## Rationale

- The owner keeps control of decisions and of cross-function work, because every request is recorded.
- Requests that do not need a decision can be answered faster, without the owner relaying them.
- Documents remain the record of decisions, so direct messages do not become a second source of truth.

## Consequences

- Each session records its outgoing requests in its own record under `docs/sessions/`.
- A session that receives a request answers it in its own function's scope, or routes it to the owner.
- Cost: R$ 0 per month. Maintenance effort is a convention, not a tool.
