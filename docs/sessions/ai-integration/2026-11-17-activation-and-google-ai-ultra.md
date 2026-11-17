# 2026-11-17 — Activation and Google AI Ultra

## Goal

The owner subscribed to Google AI Ultra for one year and asked whether a session was dedicated to it. This session became the AI Integration function and recorded the subscription as a candidate provider resource for the platform's agents.

## Scope

In scope:

- Activation of the AI Integration function (`docs/SESSION-STRUCTURE.md`, section 4.2), approved by the owner on 2026-11-17.
- Recording what the subscription offers and what must be resolved before it is used.

Out of scope:

- Any API call, account configuration or API key. ADR 0004 keeps the AI budget at R$ 0.
- Moving AI earlier than Phase 6. ADR 0003 is unchanged.
- Changes to documents owned by other functions. These are listed under "Pending".

## Documents Read

1. `CLAUDE.md`
2. `docs/SESSION-STRUCTURE.md`
3. `docs/CURRENT_STATE.md`
4. `docs/04-AI-AGENTS.md`
5. `docs/decisions/0002-developer-workflow.md`, `0003-ai-timing-and-scope.md`, `0004-ai-budget.md`
6. `docs/05-TECHNICAL-ARCHITECTURE.md`, sections 9 and 22 (search for provider and model)
7. Public sources on the Google AI Ultra developer benefits (Google blog, Google One help, press coverage).

## Files Changed

- `docs/04-AI-AGENTS.md`: new section 17, "Candidate Provider Resources", with status PROPOSED.
- `docs/sessions/ai-integration/2026-11-17-activation-and-google-ai-ultra.md`: this record. The folder is new.

## Decisions

- Proposed (not approved):
  - Google AI Ultra credits as a candidate resource for the Phase 6 agents (`04-AI-AGENTS.md`, section 17).
- Approved by the owner:
  - 2026-11-17: the AI Integration function is active from now, before Phase 6. The owner stated the subscription is meant for the platform's agents, and that use does not need to start now.

## Tests and Results

Nothing was executed.

## Pending

- **Product and Documentation:** update `docs/SESSION-STRUCTURE.md` to move AI Integration from "planned" to "active", with the limits of early activation: no code and no AI calls before a budget decision replaces ADR 0004. Add the `ai-integration` folder to the list in section 2 and update the table in section 6.
- **Product and Documentation:** add the Google AI Ultra subscription to `docs/CURRENT_STATE.md` as a candidate resource, with its end date (around 2027-11).
- **Architecture and Quality:** when a provider decision is prepared, consider adding the subscription end date and the overage risk to the risk register (`05-TECHNICAL-ARCHITECTURE.md`, section 21), and mention the candidate in the open decision on AI providers (section 22).
- **Owner:** verify in the Google account the real monthly credit amount and whether unused credits carry over (`04-AI-AGENTS.md`, section 17.2, items 1 and 3). No action is needed until AI use is planned.
- **Inconsistency to report:** `CLAUDE.md`, section 14, cites `docs/decisions/0029-direct-messages-between-sessions.md` and allows direct messages between sessions. On `main` (commit `bd69844`) that ADR does not exist, and `docs/SESSION-STRUCTURE.md`, section 2, still says sessions do not message each other. ADR 0029 exists on other branches, not merged yet.

## How to Resume

- Read `CLAUDE.md`, `docs/CURRENT_STATE.md`, `docs/SESSION-STRUCTURE.md` (section 4.2) and `docs/04-AI-AGENTS.md` (sections 14 to 17).
- Starting point: `docs/04-AI-AGENTS.md`, section 17.2.
- Already decided: the function is active; the subscription is for the platform's agents, not for development tools; use does not start now.
- Do not change ADR 0003 or ADR 0004 without a new decision approved by the owner.

## Next Step

No AI work is due until Phase 6, or until the owner asks to use the credits earlier. In the meantime, the useful preparation is to answer the open questions in `04-AI-AGENTS.md`, section 16, starting with "Which roles genuinely require AI?", when the owner wants it.
