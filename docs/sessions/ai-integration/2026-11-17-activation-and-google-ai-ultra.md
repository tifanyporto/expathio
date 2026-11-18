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

- `docs/04-AI-AGENTS.md`: new section 17, "Candidate Provider Resources", with status PROPOSED: the subscription's terms as read from Google's pages, the points to resolve, the cost controls available, and the proposal in section 17.4.
- `docs/decisions/0037-ai-before-phase-6-case-by-case.md`: new decision record, amending ADR 0003.
- `docs/sessions/ai-integration/2026-11-17-activation-and-google-ai-ultra.md`: this record. The folder is new.

## Decisions

- Proposed (not approved):
  - Google AI Ultra credits as a candidate resource for the Phase 6 agents (`04-AI-AGENTS.md`, section 17).
  - None open. The subscription terms in `04-AI-AGENTS.md`, sections 17.1 to 17.3, are reference information, not decisions.
  - An earlier draft of section 17.4 recommended claiming the credits now for preparation experiments. The owner redirected: this function implements AI in the product, in Phase 6 or earlier when an opportunity arises. The draft was replaced.
- Approved by the owner:
  - 2026-11-17: the AI Integration function is active from now, before Phase 6. The owner stated the subscription is meant for the platform's agents, and that use does not need to start now.
  - 2026-11-17: AI may enter before Phase 6, case by case, in one bounded role, with the owner's approval for each case (ADR 0037, amending ADR 0003). This function implements AI in the product, in Phase 6 and in each early case. First candidate: the simulated manager for proposal approval, in Phase 4. Credits are claimed only when the first case is approved.

## Tests and Results

Nothing was executed. Correction: earlier in the session, the owner was told that monthly credits probably expire each month. Google's FAQ says each credit is valid for 12 months. The owner checked the developer profile: claiming the credit requires a Google Cloud billing account. The owner's existing billing account is closed and has no linked projects. It was not reopened, and the credit was not claimed.

## Pending

- **Product and Documentation:** update `docs/SESSION-STRUCTURE.md` to move AI Integration from "planned" to "active", with the limits of early activation: no code and no AI calls before a budget decision replaces ADR 0004. Add the `ai-integration` folder to the list in section 2 and update the table in section 6.
- **Product and Documentation:** add the Google AI Ultra subscription to `docs/CURRENT_STATE.md` as a candidate resource, with its end date (around 2027-11).
- **Architecture and Quality:** when a provider decision is prepared, consider adding the subscription end date and the overage risk to the risk register (`05-TECHNICAL-ARCHITECTURE.md`, section 21), and mention the candidate in the open decision on AI providers (section 22).
- **Owner:** confirm the Ultra tier (5x with USD 40 per month, or 20x with USD 100 per month). Not urgent.
- **Product and Documentation:** mention the simulated manager as a possible AI case in `06-ROADMAP.md`, section 7 (Phase 4), and list ADR 0037 in `docs/CURRENT_STATE.md`. ADR 0003 belongs to that function; ADR 0037 was written by this function because the subject is AI. If that function prefers to own it, it may take it over.
- **Architecture and Quality, when the first case is approved:** agree the minimum AI layer in `04-AI-AGENTS.md`, section 17.5.
- **Inconsistency to report:** `CLAUDE.md`, section 14, cites `docs/decisions/0029-direct-messages-between-sessions.md` and allows direct messages between sessions. On `main` (commit `bd69844`) that ADR does not exist, and `docs/SESSION-STRUCTURE.md`, section 2, still says sessions do not message each other. ADR 0029 exists on other branches, not merged yet.

## How to Resume

- Read `CLAUDE.md`, `docs/CURRENT_STATE.md`, `docs/SESSION-STRUCTURE.md` (section 4.2) and `docs/04-AI-AGENTS.md` (sections 14 to 17).
- Starting point: `docs/decisions/0037-ai-before-phase-6-case-by-case.md` and `docs/04-AI-AGENTS.md`, section 17.4.
- Already decided: the function is active; the subscription is for the platform's agents, not for development tools; use does not start now.
- Do not change ADR 0003 or ADR 0004 without a new decision approved by the owner.

## Next Step

Nothing is due until Phase 4 specifies the review and approval processes, where the first early case (the simulated manager) is evaluated.
