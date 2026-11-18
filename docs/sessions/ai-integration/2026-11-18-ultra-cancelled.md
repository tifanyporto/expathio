# 2026-11-18 — Google AI Ultra Cancelled

## Goal

Record that the owner cancelled the Google AI Ultra subscription, and keep the AI documents consistent with it.

## Scope

In scope: the AI Integration documents and ADR 0037. Out of scope: choosing another provider. That happens with the first early AI case.

## Documents Read

1. `docs/sessions/ai-integration/2026-11-17-activation-and-google-ai-ultra.md`
2. `docs/04-AI-AGENTS.md`, section 17
3. `docs/decisions/0037-ai-before-phase-6-case-by-case.md`

## Files Changed

- `docs/04-AI-AGENTS.md`: section 17.1 marks the subscription as cancelled on 2026-11-18. Section 17.2, item 1, now says the provider is chosen with the first early case. Section 17.4 no longer plans to claim the Ultra credits.
- `docs/decisions/0037-ai-before-phase-6-case-by-case.md`: dated update. The decision stays in force; the consequence about the credits no longer applies.

## Decisions

- Proposed (not approved): none.
- Approved by the owner: none new. The owner cancelled the subscription and said other alternatives will be used. ADR 0037 is unchanged in substance.

## Tests and Results

Nothing was executed. No credit was claimed, no billing account was reopened, and no API key was created.

## Pending

- **Product and Documentation:** in `docs/CURRENT_STATE.md`, remove the Google AI Ultra subscription from "Candidate Resources", or mark it as cancelled on 2026-11-18. In `docs/SESSION-STRUCTURE.md`, section 3.7, "Activation" mentions the subscription; it may be kept as history.

## How to Resume

- Read `docs/decisions/0037-ai-before-phase-6-case-by-case.md` and `docs/04-AI-AGENTS.md`, sections 17.4 and 17.5.
- Already decided: AI may enter before Phase 6, case by case (ADR 0037). No provider is chosen. ADR 0004 stays at R$ 0.

## Next Step

Nothing is due until Phase 4 specifies its review and approval processes. When the first early case is approved, prepare the provider, model and budget decision with alternatives, including providers with a free tier.
