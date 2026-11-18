# 2026-11-17 — AI Integration Handoff

## Goal

Apply the handoff from the AI Integration session (`docs/sessions/ai-integration/2026-11-17-activation-and-google-ai-ultra.md`, "Pending") to the documents owned by Product and Documentation: the activation of AI Integration, ADR 0037, the Phase 4 early AI candidate and the Google AI Ultra subscription.

## Scope

In scope:

- `docs/SESSION-STRUCTURE.md`: AI Integration from planned to active, folder list, build order table.
- `docs/06-ROADMAP.md`, section 7 (Phase 4): the simulated manager as a possible early AI case.
- `docs/CURRENT_STATE.md`: ADR 0037, the subscription as a candidate resource, and the inconsistency on direct messages.

Added later in the session, after the owner's answer: alignment of `SESSION-STRUCTURE.md`, sections 1, 2 and 5, with ADRs 0029 and 0030.

Out of scope:

- Any change to ADR 0003, ADR 0004, ADR 0037 or `04-AI-AGENTS.md`.
- Merging other branches.

## Documents Read

1. `CLAUDE.md`
2. `docs/CURRENT_STATE.md`
3. `docs/SESSION-STRUCTURE.md`
4. `docs/sessions/product-and-documentation/2026-11-06-phase-1-test-accounts.md`
5. `docs/decisions/0037-ai-before-phase-6-case-by-case.md`
6. `docs/sessions/ai-integration/2026-11-17-activation-and-google-ai-ultra.md`
7. `docs/04-AI-AGENTS.md`, section 17
8. `docs/06-ROADMAP.md`, section 7
9. `docs/decisions/0007-first-version-participant-rules.md`
10. ADRs 0029 and 0030 on branch `origin/docs/adr-0030-direct-communication`; diffs of `CURRENT_STATE.md`, `SESSION-STRUCTURE.md` and `06-ROADMAP.md` on every unmerged remote branch.

## Files Changed

Branch `claude/ai-integration-handoff-624fb4`, created from `docs/ai-integration-activation` (`3f38fab`).

- `docs/SESSION-STRUCTURE.md`:
  - Section 2: `ai-integration` added to the list of function folders.
  - New section 3.7, AI Integration, active since 2026-11-17. Adds the early-activation limits (no AI call, API key, billing account or credit claim before a budget decision amends ADR 0004; one bounded early case at a time, approved by the owner), the responsibility for early cases (ADR 0037), the minimum AI layer agreed with Architecture and Quality, and its session folder. ADR 0037 is listed among its owned documents, as the AI Integration record proposed.
  - Section 4.2 kept as a pointer to section 3.7, so existing references to "section 4.2" still resolve and sections 4.3 and 4.4 keep their numbers.
  - Section 6: Phase 4 row mentions AI Integration if the early case is approved; Phase 6 row says "active since 2026-11-17".
  - Section 7: the owner's approval of 2026-11-17 recorded.
  - Sections 1, 2 and 5 aligned with ADRs 0029 and 0030: sessions may message each other directly without prior approval, each request is recorded in the sender's record, direct messages do not replace documents, and the owner is consulted only for decisions that depend on the owner.
- `docs/06-ROADMAP.md`, section 7: new subsection "Possible Early AI Case" (simulated manager for proposal approval, ADR 0007 item 4, ADR 0037).
- `docs/CURRENT_STATE.md`: ADR `0037` in "Approved Decisions"; new section "Candidate Resources" with the Google AI Ultra subscription; AI Integration noted under "Open" (session structure); inconsistency on direct messages between sessions, recorded and then marked resolved on 2026-11-17 after the owner's answer.
- `docs/sessions/product-and-documentation/2026-11-17-ai-integration-handoff.md`: this record.

Conflict check: no unmerged remote branch changes `SESSION-STRUCTURE.md`. `06-ROADMAP.md` changes on `docs/first-business-cycle` are in section 4 only. `CURRENT_STATE.md` changes on other branches add ADRs 0021, 0029 to 0033 after the `0028` line, so the new `0037` line will give a small merge conflict at that spot: keep all lines, in number order. The other edits to `CURRENT_STATE.md` are in places no other branch touches.

## Decisions

- Proposed (not approved): none.
- Approved by the owner (before this session, recorded here): 2026-11-17, AI Integration active before Phase 6; ADR 0037.
- Approved by the owner during this session, 2026-11-17: align `SESSION-STRUCTURE.md` with ADRs 0029 and 0030 now, without waiting for those ADRs to be merged into `main`.
- Taken by this session (`CLAUDE.md`, section 2, minor detail within scope): the AI Integration definition moves to section 3.7 with a pointer left in section 4.2; the subscription goes in a new "Candidate Resources" section of `CURRENT_STATE.md`, not under "Approved Decisions", because it is not a decision.

## Tests and Results

None. Documentation change only.

## Pending

- ADRs 0029 and 0030 are cited by `SESSION-STRUCTURE.md`, section 2, but are only on unmerged branches (such as `docs/adr-0030-direct-communication`). The links resolve once those branches are merged into `main`.
- **Owner:** merge order. `docs/ai-integration-activation` and this branch are not merged. On merge, `CURRENT_STATE.md` needs the small conflict resolution described above.
- **Owner (from AI Integration):** confirm the Ultra tier (5x or 20x). Not urgent.
- ADR 0003 belongs to Product and Documentation and is amended by ADR 0037, which AI Integration wrote. ADR 0037 is now listed under AI Integration's owned documents. ADR 0003 itself is unchanged.

## How to Resume

- Read `CLAUDE.md`, `docs/CURRENT_STATE.md`, this record, and `docs/SESSION-STRUCTURE.md`, sections 2 and 3.7.
- Starting point: merging this branch and the branches with ADRs 0029 and 0030 into `main`.
- Already decided: AI Integration is active (2026-11-17); ADR 0037 is approved; ADR 0004 stays at R$ 0; `SESSION-STRUCTURE.md` follows ADRs 0029 and 0030.
- Do not change ADR 0003, 0004 or 0037, or `04-AI-AGENTS.md`: they need an owner decision or belong to AI Integration.

## Next Step

The owner merges `docs/ai-integration-activation`, this branch and the branches with ADRs 0029 and 0030 into `main`, resolving the small conflict in `CURRENT_STATE.md` described above. No further action is due from this function until Phase 4 specifies the review and approval processes.
