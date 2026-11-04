# 2026-11-04 — Session Folders and Phase Gates

## Goal

Organize `docs/sessions/` by session function, as the owner asked, and state the phase gates proposed for the open questions in plain terms, so the owner can confirm or change them.

## Scope

- In scope: the folder structure of `docs/sessions/`; references to the moved records; the wording of the session-record rule in `CLAUDE.md` and `docs/SESSION-STRUCTURE.md`; an explanation of the phase gates.
- Out of scope: changing the content of the moved records; setting new phase gates without the owner's confirmation; creating folders for sessions that are not active.

## Documents Read

1. `CLAUDE.md`, sections 3, 13 and 14.
2. `docs/SESSION-STRUCTURE.md`, sections 2 and 3.
3. `docs/sessions/TEMPLATE.md`.
4. A search of the repository for references to `docs/sessions/`.

## Files Changed

- `docs/sessions/product-and-documentation/`: created. Holds the records of the documentation function:
  - `2026-11-03-documentation-review.md`
  - `2026-11-03-company-definition.md`
  - `2026-11-04-session-structure.md`
  - `2026-11-04-physical-stores-and-doc-audit.md`
  - `2026-11-04-session-folders-and-phase-gates.md` (this record)
- `docs/sessions/architecture-and-quality/`: created. Holds:
  - `2026-11-03-technical-choices.md`
  - `2026-11-04-phase-0-practices.md`. Phase 0 practices (repository, branches, testing and deployment strategy, risk register) are architecture and quality work. The Docker and WSL2 setup is owned by Infrastructure and Operations, but this record documents the decisions, not the installation.
- `docs/sessions/TEMPLATE.md`: stays at the root of `docs/sessions/`.
- `CLAUDE.md`: section 3 and section 13, step 3, now say records go in the folder of the session's function. The rule text was written by the owner; only the path references changed.
- `docs/SESSION-STRUCTURE.md`: section 2 gives the folder rule and the list of folder names.
- `README.md`: the description of `docs/sessions/` mentions one folder per function.
- Internal references between records were updated to the new paths.

## Decisions

- Approved by the owner: one folder per session function under `docs/sessions/`, with the function names as folder names. The owner's request was for folders by session; the names follow `docs/SESSION-STRUCTURE.md`.
- Approved by the owner on 2026-11-04: the phase gates in the next section, as proposed.

## Phase Gates Proposed

Each gate is the phase by which the open questions must be answered. None is confirmed by the owner yet.

| Open item | Where it is | Must be resolved | Why |
|---|---|---|---|
| Stock transfers between locations | `02`, section 15, question 13 | Before Phase 3 | Phase 3 creates orders and updates stock. Without a rule for moving stock, the stock levels in each location can be wrong. |
| Visual specification | `09` | Before the first screen in Phase 1 | The first screen needs colors, type and components. Without them, Frontend would invent the look. |
| Participant privacy and data rights | `01`, section 12 | Before Phase 4 admits the first real participant | Real people's data must be protected (LGPD) before they use the platform. ADR 0011 already forbids real participant data before then. |
| Participant experience questions | `03`, section 16 | Before the participant workspace is built (Phase 4) | These questions decide what the workspace shows and how participants communicate. |
| AI questions | `04`, section 16 | Before AI Integration starts (Phase 6) | AI is outside the first release (ADR 0003). |
| Progression questions | `07`, section 18 | Before Progression and Rewards starts (Phase 7) | Progression needs meaningful work to evaluate first. |
| Simulated-day mechanics | `02`, section 11 | Phase 5 | How many events happen per simulated day belongs to the simulation engine. |
| GitHub connection mechanism | `CURRENT_STATE.md` | No phase set | The owner decides when to specify it. |

## Tests and Results

Nothing was executed. There is no application code. Checks made by reading the repository:

- A search for `docs/sessions/` found only the expected references. The one remaining reference to `docs/sessions/TEMPLATE.md` is correct, because the template stays at the root.
- Two references in `docs/SESSION-STRUCTURE.md` were missing backticks after the first edit; they were corrected.

## Pending

- Owner decision on stock transfers between locations, before Phase 3 design starts.
- Visual specification, privacy definitions and the GitHub connection mechanism, each at its gate in the table above.

## Continuation: Gates Approved and Standard Prompt

- Owner confirmed all phase gates in the table above.
- `docs/CURRENT_STATE.md`: gates recorded as approved; the standard session prompt is kept by the owner, outside the project.
- A standard prompt document was first created in `docs/SESSION-PROMPTS.md` and then removed. The owner asked for it to be kept outside the project, so that sessions do not read it and get confused. It is written in Portuguese for the owner, in a file outside the repository.
- Documentation status: complete for the current stage, Phase 0. Every item still open is assigned to a phase gate above. No open inconsistencies.

## How to Resume

Read in this order:

1. `CLAUDE.md`, sections 3, 13 and 14.
2. `docs/SESSION-STRUCTURE.md`, section 2.
3. `docs/CURRENT_STATE.md`, section "Open".
4. This record.

Starting point: the owner's confirmation of the phase gates.

Already decided, do not ask again: records are grouped by session function (this record); physical stores are in the first release (ADR 0017).

## Next Step

The owner confirms or changes the phase gates. Once confirmed, the gates are recorded in the open-questions sections and `docs/CURRENT_STATE.md` as approved, and the documentation function can declare the documentation complete.
