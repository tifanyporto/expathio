# 2026-11-03 — Documentation Review

## Goal

Review the project documentation as a set, find inconsistencies, redundancies, gaps, ambiguities and viability issues, then apply the corrections the owner approved, one document at a time. Close the open decisions that the review identified.

## Scope

- In scope: all files in `docs/`, `README.md` and `CLAUDE.md`.
- Out of scope: application code (none exists yet), Git operations (none requested), any file the owner did not approve for change.
- Work was done in the owner's order, with questions asked whenever a decision belonged to the owner.

## Documents Read

- `CLAUDE.md` (several versions; the current one is the owner's, edited in this session).
- `docs/00-VISION.md` through `docs/07-PROGRESSION-AND-REWARDS.md`.
- `docs/CURRENT_STATE.md` (empty at the start).
- `README.md` (empty at the start).

## Files Changed

**Created**

- `docs/GLOSSARY.md`: definitions of terms used across the documents.
- `docs/08-COMPANY.md`: the first simulated organization (departments, roles, tools, access rules, pending items).
- `docs/09-DESIGN-SYSTEM.md`: the Expathio visual identity, moved from `03` §17.
- `docs/decisions/TEMPLATE.md`, `docs/decisions/0001` to `0009`.
- `docs/sessions/TEMPLATE.md`.
- `README.md`.
- `docs/CURRENT_STATE.md`, written in full.

**Changed**

- `CLAUDE.md`: §3 (session scope), §4 (status names in English), §8 and §9 (language), §11 (personal data), §12 (visual direction points to `03`), §13 (session records).
- `docs/00-VISION.md`: status, personal project note, long-term GitHub goal, roles reference, principle wording, removal of mechanisms and open questions.
- `docs/01-PRODUCT.md`: status, open questions answered inline, privacy section (§12), tools note (§3.5), principle pointer.
- `docs/02-BUSINESS-SIMULATION.md`: status, departments reference, time model, pointers to `04`, `05` and `00`.
- `docs/03-USER-EXPERIENCE.md`: status block, admission decided, reduced open questions, visual direction moved to `09`, smartphone out of scope.
- `docs/04-AI-AGENTS.md`: status block, section 15 scope, level 4 out of scope, "case, task or incident" wording, principle pointer.
- `docs/05-TECHNICAL-ARCHITECTURE.md`: status block, persistence list, event distinction, domain-to-phase table, time model decided, smartphone out of scope, pointers.
- `docs/06-ROADMAP.md`: status block, Phase 0 and Phase 1 criteria, Phase 3 criterion moved to Phase 4, Phase 4 collaboration scope, first release ends with Phase 5, acceptance scenarios, capacity assumption, testable Phase 5 criterion.
- `docs/07-PROGRESSION-AND-REWARDS.md`: status block, bonuses long-term, formal reviews out of first release, principle pointer.

## Decisions

**Approved by the owner** (recorded in `docs/decisions/`):

- `0001` simulation time: simulated days, one shared timeline per organization.
- `0002` developer workflow: simulated in the first version; real GitHub is long-term.
- `0003` AI timing: Phase 6; autonomy level 4 out of scope.
- `0004` AI budget: R$ 0 for now.
- `0005` admission: applications to predefined vacancies.
- `0006` terms: "case" for customer work, "incident" for operational problems.
- `0007` participant rules: one occupant per role; role changes after version 1; feedback through observable results; proposals need manager approval; departure hands the role to the simulation.
- `0008` participation in work sessions.
- `0009` four participant roles in version 1 (Operations Coordinator, Customer Service Specialist, Sales Analyst, Financial Analyst), with the tools in `08-COMPANY.md`.

**Approved earlier in the session and applied** (no ADR yet):

- Product language is English; internal documents are English unless the owner asks otherwise.
- Participants are real people, so their data is personal data (`01` §12).
- Formal performance reviews are outside the first release.
- Smartphone and email are outside the first release.
- Collaboration between human participants belongs to Phase 8.
- Creating organizations is a future step.
- Bonuses and profit-sharing are long-term.
- Planning assumption: 5 to 10 hours per week.

**Proposed, not approved:**

- Branch per significant task (`CLAUDE.md`, section 7).

## Tests and Results

No application code exists, so no tests were run. Document consistency was checked by searching for Portuguese status terms (none remain in `docs/`) and for references to documents that do not exist (`08-COMPANY.md` now exists).

Not re-read in full after the last round of edits. Edits were targeted, and each was confirmed by the editing tool.

## Pending

- **Company identity**: name, brand and catalog (`08-COMPANY.md`, section 7).
- **Vacancies**: number and description per role (`08-COMPANY.md`, section 5).
- **Final role titles** (`08-COMPANY.md`, section 2). Provisional.
- **GitHub connection mechanism**: long-term, not defined.
- **Visual specifications**: the palette in `09-DESIGN-SYSTEM.md` is a direction, not a specification.
- **Branch policy** in `CLAUDE.md`, section 7: proposed, awaiting approval.
- **README**: short, written in this session. Owner has not reviewed it.

## How to Resume

Read in this order:

1. `CLAUDE.md`.
2. `docs/CURRENT_STATE.md`. It lists the approved decisions and what is open.
3. This record.
4. The document relevant to the new task. For organization work: `08-COMPANY.md`. For the roadmap: `06-ROADMAP.md`.

Starting point for the next session: the open item the owner chooses. If the owner has no preference, the next natural item is the company identity in `08-COMPANY.md`, section 7.

Do not re-ask decided items. Every decision above has an ADR or an inline "Decided" note in the document it affects.

## Next Step

Decide the next task: company identity, vacancies, or Phase 1 planning. Each is a separate session if the owner wants it that way.
