# 0037 — AI Before Phase 6, Case by Case

**Status:** APPROVED  
**Date:** 2026-11-17  
**Approved by:** Project owner

---

## Context

ADR 0003 places AI in Phase 6. At the time, the alternative of AI before Phase 6 in a specific role was not chosen.

On 2026-11-17 the owner subscribed to Google AI Ultra for one year. The subscription includes monthly Google Cloud credits that can pay for the Gemini API. Each credit is valid for 12 months, and the subscription ends around 2027-11 (`04-AI-AGENTS.md`, section 17.1). Phase 6 is not expected before then.

Some features planned before Phase 6 need judgment over free text. One example is the simulated manager that approves participant proposals (ADR 0007, item 4). It belongs to the review and approval processes of Phase 4 (`06-ROADMAP.md`, section 7).

This record amends ADR 0003. It does not replace it.

## Alternatives

1. **Keep ADR 0003 as it is.** AI only in Phase 6, and earlier phases use deterministic rules. Costs R$ 0 and is the simplest option. The downside is that features that need judgment stay limited until Phase 6, and the Ultra credits go unused.
2. **AI before Phase 6, case by case.** Phase 6 remains the AI phase. An earlier phase may use AI in one bounded role, with the owner's approval for each case. Costs R$ 0 per month in real charges while the credits cover usage, plus a one-time USD 5 prepayment when the first case is implemented. The downside is that the first case must build a minimum AI layer.
3. **Move all AI earlier.** Not chosen, because Phase 6 depends on a stable deterministic simulation (Phase 5).

## Decision

Phase 6 remains the phase for AI-powered employees and customers. Before Phase 6, AI may be used in one bounded role when a phase offers the opportunity, with the owner's approval for each case and the conditions below.

Conditions for each early case:

- The feature works without AI. If the model fails or the budget is reached, a deterministic rule takes over or the item waits for a human.
- Autonomy levels 1 or 2 only (`04-AI-AGENTS.md`, section 5).
- The backend validates the AI result before it changes business state.
- Each AI action is recorded with its trigger, input, result and cost.
- Only fictional data is sent to the model.
- The budget for the case is approved before implementation, in an amendment to ADR 0004.

## Rationale

Keeping Phase 6 as the main AI phase preserves the order of the roadmap: deterministic processes come first. Allowing bounded cases earlier lets features such as proposal approval use AI where fixed rules fall short, and gives the Ultra credits a use before they expire. The conditions keep each case reversible and keep essential operations independent of AI.

## Consequences

- The AI Integration function is responsible for implementing AI in the product, in Phase 6 and in each early case.
- The first candidate is the simulated manager for proposal approval, evaluated when Phase 4 specifies its review and approval processes (`04-AI-AGENTS.md`, section 17.4).
- ADR 0004 stays at R$ 0 until the first case is approved together with its budget.
- The Ultra credits are claimed only when the first case is approved and ready to be implemented.
- `06-ROADMAP.md`, section 7 (Phase 4), should mention the simulated manager as a possible AI case. Product and Documentation updates it.
- `docs/CURRENT_STATE.md` should list this decision. Product and Documentation updates it.
- ADR numbers 0034 and 0035 are reserved on other branches for the store and role revision. This record uses 0037.
