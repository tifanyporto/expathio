# 2026-11-06 — Visual Specification Options

## Goal

Prepare the visual specification of the Expathio platform (`09-DESIGN-SYSTEM.md`) so that the Frontend Engineering session does not have to invent the look of the first Phase 1 screen. This session is the first one under the Experience and Design function. It produces the list of what the specification needs, the options for colors and typography, and a recommendation. The specification itself is written only after the owner chooses an option.

In a later part of the same session, the owner approved the specification for the Phase 1 scope: the sign-in screen and the application shell (section "Owner's decisions, Phase 1 scope").

## Scope

In scope:

- Reading the design and experience documents.
- Listing what the first Phase 1 screen needs, and what is decided and what is not.
- Proposing options for the palette and the typography, with cost, maintenance and generic-look risk.
- Listing what depends on the owner.
- Writing the specification in `docs/09-DESIGN-SYSTEM.md` after the owner's choices, limited to the Phase 1 scope.

Out of scope:

- Any code, component or design file.
- Changes to `docs/CURRENT_STATE.md`. Its "Visual specification" item is owned by Product and Documentation.
- Navigation items. Product defined them as Phase 2 work.
- Branch and commit: work is on branch `design/especificacao-visual`. Nothing was committed or pushed.

## Documents Read

1. `CLAUDE.md` (sections 2, 6, 9, 12 and 14, plus the rest of the file).
2. `docs/CURRENT_STATE.md`.
3. `docs/SESSION-STRUCTURE.md`, sections 2, 3.6, 5 and 6.
4. `docs/09-DESIGN-SYSTEM.md`.
5. `docs/03-USER-EXPERIENCE.md`, sections 1, 2, 6, 6.5 and 17.
6. `docs/08-COMPANY.md`, sections 1 to 3.
7. `docs/06-ROADMAP.md`, section 4 (Phase 1 scope), as updated by Product on 2026-11-06 (`origin/main`, commit `6ce4a16`).
8. `docs/00-VISION.md`, section 8 (design principles).
9. `docs/sessions/TEMPLATE.md`.
10. `docs/decisions/0015-development-environment-and-repository.md` (branch rule, first lines only).
11. Product decisions, read from `origin/main`: `docs/decisions/0022-phase-1-test-accounts-only.md`, `0023-phase-1-direct-membership.md`, `0024-phase-1-business-roles-loaded.md`, `0026-vacancy-application-in-phase-2.md`, and `docs/sessions/product-and-documentation/2026-11-06-phase-1-test-accounts.md`.
12. `docs/decisions/0021-interface-typeface.md` (this function's decision).

Git: the branch `design/especificacao-visual` was fast-forwarded to `origin/main` (`6ce4a16`) with `git merge --ff-only origin/main`. No merge commit was created. Uncommitted changes in this function's files were kept. Before the fast-forward, the branch was at `0753e1a`.

## Files Changed

- `docs/sessions/experience-and-design/2026-11-06-visual-specification-options.md`: this record (new; updated in place as the owner decided).
- `docs/09-DESIGN-SYSTEM.md`: first written as the specification for Option B; then rewritten for the approved direction ("brand in points"); then rewritten for the Phase 1 scope (sign-in screen and application shell). Status: APPROVED, 2026-11-06.
- `docs/decisions/0021-interface-typeface.md`: new, APPROVED 2026-11-06 (typeface decision).

Not changed: `docs/CURRENT_STATE.md`, `docs/03-USER-EXPERIENCE.md`, `docs/06-ROADMAP.md`, code folders.

Outside the repository: visual comparison and demonstration pages were published as private artifacts (scratchpad source files, not project files): https://claude.ai/artifact/T9ndJuYZGzfBvx6H29XyCy, https://claude.ai/artifact/FpeSQcWnerMUQ9L7EhQQ1j, https://claude.ai/artifact/7pQbhodoxEdpDaFMBSC6Yo, https://claude.ai/artifact/B3QmgrAW7DK1oEL5sVAiCE.

## What the First Phase 1 Screen Needs

Product confirmed the Phase 1 screens on 2026-11-06 (`06-ROADMAP.md`, section 4; ADRs 0022 and 0023). The first screen is a sign-in screen with test accounts. The application shell follows it: header, content area and a reserved place for navigation. Navigation items are not defined in Phase 1.

The gap analysis below is the one that was done before the owner's decisions. Its "Not decided" column has been answered in the "Owner's decisions" section.

| Need | Decided | Not decided (before the owner's decisions) |
|---|---|---|
| Platform | Desktop-first. Smartphone is not in the first release (`03`, 6.5; `09`, 3). | Minimum window width the layout must support. |
| Language of the interface | English (`CLAUDE.md`, 9). | Whether a Portuguese version will exist later. |
| Brand color | Purple, in points (owner, 2026-11-06). | Exact values (now set in `09`, section 4). |
| Visual rules | `CLAUDE.md`, 12. | Shadows, corner radius and border values (now set in `09`). |
| Typography | Public Sans (`0021`). | Type scale (now set in `09`, section 5). |
| Color palette | Tone scales and status colors (`09`, section 4.2). | Dark mode (decided: not in Phase 1). |
| Spacing and layout | Spacing scale and shell (`09`, section 6). | Density (decided: comfortable). |
| Button, form field, notice | Set in `09`, section 7. | Confirmation by the owner. |
| Table | Not in Phase 1. | Specified in Phase 2. |
| Navigation | Reserved place in the shell. Items in Phase 2. | Items and states (Phase 2, per Product). |
| Icons | None in Phase 1. | Icon set decided later, if needed (must be free). |
| Accessibility | WCAG 2.2 AA (owner, 2026-11-06). | Confirmed. |

## Decisions

### Proposed options (first round, superseded by the owner's choices)

Three options for the palette and typography. All three use fonts under the SIL Open Font License (OFL), free to use, so the monthly cost is R$ 0 for each.

- **Option A — Operational purple:** IBM Plex Sans with Plex Mono for codes. Recommended at the time; not chosen.
- **Option B — Ink and one accent:** one sans-serif family, purple only for brand and primary action. **Chosen by the owner.**
- **Option C — Paper and ledger:** serif headings and warm off-white surfaces. Not chosen. The owner found the warm background yellow on screen.

Notes that applied to every option, and still apply:

- Fonts are self-hosted (stored with the project, served by the application). Loading from Google Fonts or another CDN sends each visitor's address to that company (`CLAUDE.md`, 11).
- A font package is a new dependency. It needs owner approval (`CLAUDE.md`, 2). Approved (see below).
- The operating system's own fonts were considered and not recommended: each computer shows a different font.

### Owner's decisions, first round (2026-11-06)

- **Option B chosen.** Reason from the owner: it looked good on both screens tested; Option C looked yellow.
- **Interface direction:** modern, refined and pleasant, with personality. Not rigid or square. The earlier spec (2 px corners, no shadows) was replaced.
- **Color consistency** across devices is the main requirement. Technical terms explained to the owner: color management (gerenciamento de cor) and color space (espaço de cor). The web standard is sRGB. Screens differ in calibration, profile, brightness and night mode, so identical rendering cannot be guaranteed. The interface controls: sRGB only, named tones from a fixed scale, no meaning carried by a small difference in tone.
- **Brand in points** ("marca em pontos"): purple for actions, selection, focus, links and the brand mark; large surfaces neutral; a light purple band for highlights, never a dark purple surface. The owner chose this after seeing the demonstration with both levels.
- **Public Sans approved as a dependency.** Installation is done by Frontend Engineering, with a pinned version recorded in its own session record.
- **Font hosting confirmed:** self-hosted. Recorded in `docs/decisions/0021-interface-typeface.md`.

### Owner's decisions, Phase 1 scope (2026-11-06, second round)

Product's confirmation (`docs/sessions/product-and-documentation/2026-11-06-phase-1-test-accounts.md`, `origin/main`):

- First Phase 1 screen: sign-in with test accounts. No sign-up and no organization selection.
- Application shell for computer screens: header, content area, and a place for navigation. Navigation items are not defined in Phase 1; they are specified in Phase 2.
- Specify in Phase 1 only the sign-in and the shell. Mark navigation as "to be defined in Phase 2".

The owner's answers to the items of the first pending list (items 2 to 10 of the list, plus the review):

1. Option B: done.
2. Purple in points replaces the earlier "purple as primary brand color" wording: accepted (section 2 of `09`).
3. Public Sans as a dependency: approved.
4. Dark mode: **not in Phase 1** (recommended, accepted).
5. Accessibility target: **WCAG 2.2 AA** (recommended, accepted).
6. Density: **comfortable** (accepted). Compact would be a separate decision.
7. First screen: **sign-in and application shell**, as Product described.
8. Status colors: **confirmed for now** (section 4.2 of `09`).
9. Icons: **none in Phase 1**, text labels only (recommended, accepted).
10. Specification status: **APPROVED** (`09`, status line), for the Phase 1 scope.
11. Review on two screens: **done, accepted**.

Decisions the specification now records in `09`: section 2 (scope and status), 6.1 (application shell), 7.9 (sign-in screen), 13.1 (decided items).

Open points recorded in `09`, section 13.2, which Product must answer before implementation:

- Sign-in identifier (the specification assumes email).
- Page shown after sign-in, its title and content.
- Password recovery (not defined for Phase 1).
- Expathio logo (text is used until one is defined).

Routed to other functions (not done here):

- **Product and Documentation:** `docs/08-COMPANY.md`, section 2, refers to a MONUMENT visual specification that does not exist. Owner and location to be decided.
- **Product and Documentation:** `docs/CURRENT_STATE.md`, "Visual specification" open item. Update when the specification is approved; this approval makes it applicable.
- **Frontend Engineering:** install Public Sans with a pinned version in the first screen, and record it in its own session record.

### Owner's decisions, sign-in demonstration (2026-11-06, third round)

Demonstration published as a private artifact, page `tela-entrada-casca.html` (scratchpad, not a project file): https://claude.ai/artifact/71bzpg7utQgKEZFKNqMPpy. It shows the sign-in screen in three states and the shell after sign-in. Versions 1 to 4.

- Labels: "(required)" removed. The owner found it unnecessary. `09`, section 7.2, now says labels contain only the field name.
- Error state: the red border on the input fields was removed. Input borders stay `color-border-control`. The error is shown by the notice and the field text.
- Notice: the 2 px red left border was replaced by a 1 px `color-border` border.
- Error text: a lighter red, `#CC4438` (token `error-text`), for text only. Contrast 4.71:1 on white. The owner approved it. Recorded in `09`, section 4.2 and 4.4.
- Post-login page: specified in `09`, section 7.10, following ADR 0028 (organization name, role, simulated-data label, no business content).
- The owner approved the two sign-in states (default and after a failed attempt), in the words "Está ótimo".
- **Not approved:** the application shell (screen 2) and the post-login page in the demonstration. The owner has not reviewed them. `09`, section 6.1 and 7.10, stay pending visual review. Its content comes from ADR 0028, which is approved.

Changes to `09`: sections 4.2, 4.4, 7.2, 7.4, 7.9, new 7.10, 13.1 (item 10) and 13.2 (items 1 to 3 answered by ADR 0028).

## Tests and Results

No code and no tests were run. Checks that were executed:

- WCAG contrast ratios computed with a node script (python is not installed on this machine) for every text and control color in `09`, section 4.4. Two earlier results drove changes:
  - The planned field border `#DDE0E6` gives 1.3:1 on white, below the 3:1 WCAG asks for control boundaries. The specification uses `#7C768C` (neutral-500, 4.3:1) for control borders, and keeps `#E2DFE9` only for decorative dividers.
  - The planned lilac focus color gives 1.3:1 on white, so focus uses `purple-600`.
- Branch fast-forward to `origin/main` (`6ce4a16`) with `git merge --ff-only`. No commit created.
- Owner review of the demonstration on two screens: accepted.
- Not run: visual check of the implemented screens (there is no code yet).

## Pending

This function's own pending items:

- Expathio logo: open. Routed to Q-016 in `docs/OPEN-QUESTIONS.md`. Text "Expathio" is used until then (ADR 0028).
- `docs/CURRENT_STATE.md` visual specification item: routed to Q-017 in `docs/OPEN-QUESTIONS.md` (Product and Documentation).
- Remaining in this function: none beyond the open points above. The specification and ADR 0021 are APPROVED.

For other functions (routed, not done here): see "Routed to other functions" above.

## How to Resume

Read in order:

1. `CLAUDE.md`, sections 2, 9 and 12.
2. This record, sections "Owner's decisions" (both rounds).
3. `docs/09-DESIGN-SYSTEM.md`, sections 2, 7.9 and 13.
4. `docs/06-ROADMAP.md`, section 4, and ADRs 0022 and 0023 (Product).

Already decided, do not ask again: desktop-first; Option B (Public Sans, neutral surfaces, purple in points); English interface; WCAG 2.2 AA; comfortable density; no dark mode in Phase 1; no icons in Phase 1; sign-in and shell as the Phase 1 surfaces; navigation items in Phase 2; self-hosted fonts.

Do not change: `docs/CURRENT_STATE.md` and `docs/06-ROADMAP.md` (Product and Documentation); code folders (Phase 1 layout is ADR 0019).

## Next Step

The owner answers the open points in `09`, section 13.2, after Product answers the sign-in identifier, the page after sign-in, and password recovery. The owner decides when to commit the branch `design/especificacao-visual`; nothing is committed yet. When the owner asks for a commit, the message is in English, in the imperative (`CLAUDE.md`, 7).
