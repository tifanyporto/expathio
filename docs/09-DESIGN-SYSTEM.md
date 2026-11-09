# Expathio — Visual Identity and Design System

**Status:** APPROVED for the sign-in screen (7.9). The application shell (6.1) and the post-login page (7.10) are specified, but their visual design is pending owner review  
**Approved by:** Project owner, 2026-11-06  
**Document type:** Design specification  
**Project:** Expathio

---

## 1. Purpose

This document defines the visual identity of the Expathio platform. It does not define the visual identity of the fictional company simulated inside it, which is defined in `08-COMPANY.md`. The two must not be confused in the interface (`03-USER-EXPERIENCE.md`, section 17).

## 2. Status, Direction and Scope

- **Status:** approved by the owner on 2026-11-06 as the specification for the Phase 1 scope below. Approval is not implementation: nothing here is built or tested yet (`CLAUDE.md`, section 4).
- **Direction (owner, 2026-11-06):**
  - A modern, refined and pleasant interface with personality. It is not rigid or square.
  - Strong consistency of color across screens and devices.
  - **Brand in points:** purple is used for actions, selection, focus, links and the brand mark. Large surfaces are neutral. A light purple band may be used for a highlight, but never a dark purple surface.
- **Phase 1 scope** (`06-ROADMAP.md`, section 4; `docs/decisions/0022-phase-1-test-accounts-only.md`). Two surfaces only:
  1. **Sign-in screen** for test accounts. There is no sign-up screen and no organization selection (section 7.9).
  2. **Application shell** for computer screens: a header, a content area, and a reserved place for navigation (section 6).
- **Navigation items are not defined in Phase 1.** They are specified in Phase 2, when the screens that need them exist. Phase 1 only reserves the place.
- **Not specified in Phase 1:** dark mode, icons, tables, the highlight band, and any tag variant other than the simulated-data marker. Each is specified when a Phase 2 screen needs it.
- **Owner review:** the visual demonstration was opened on two screens on 2026-11-06 and accepted.
- **Record:** `docs/sessions/experience-and-design/2026-11-06-visual-specification-options.md`.

The earlier version of this specification (2 px corners, no shadows, no purple on large surfaces as a hard rule) was replaced by this one, because the owner asked for a less rigid interface.

## 3. Visual Principles

- **Refined, not decorative.** Space, type and tone carry the design. Ornament is not used.
- **Personality through craft.** Typography with clear hierarchy, generous spacing, soft corners, one soft elevation for cards, and short movement.
- **Color is consistent, and never the only signal.** Every color is a named tone from a fixed scale. A state is always also shown by text or shape.
- **Desktop first.** Layout follows `03-USER-EXPERIENCE.md`, section 6.5.

Rules for every screen (`CLAUDE.md`, section 12):

- No decorative gradients, no glassmorphism, no heavy shadows.
- No icon without a function. Every icon has a text label or an accessible name.
- No marketing titles on operational screens.
- No button or action may look functional when it is not.
- Simulated data is identified on every screen (`CLAUDE.md`, section 11; `docs/decisions/0022-phase-1-test-accounts-only.md`).

## 4. Color

### 4.1 Color Management

Colors are defined in **sRGB**, the standard color space for the web. Screens differ in calibration, color profile, brightness and night mode, so two screens are never identical. The interface therefore follows three rules:

1. Use only the tones in this section. Never write a color code directly in a component.
2. Never convey information by a small difference between two tones. Pair color with text, shape or position.
3. Check contrast for every pair used (section 4.4), not only on one screen.

### 4.2 Tone Scales

Purple (brand):

| Token | Value | Token | Value |
|---|---|---|---|
| `purple-50` | `#F6F3FB` | `purple-600` | `#6A3FA6` |
| `purple-100` | `#ECE5F7` | `purple-700` | `#5A2D8F` |
| `purple-200` | `#DCCFEF` | `purple-800` | `#47226F` |
| `purple-300` | `#C3AEE3` | `purple-900` | `#331856` |
| `purple-400` | `#A385D3` | | |
| `purple-500` | `#7F58BB` | | |

Neutral (surfaces and text, with a slight purple tint so they sit with the brand):

| Token | Value | Token | Value |
|---|---|---|---|
| `neutral-0` | `#FFFFFF` | `neutral-500` | `#7C768C` |
| `neutral-50` | `#F7F6F9` | `neutral-600` | `#5F5870` |
| `neutral-100` | `#EFEDF3` | `neutral-700` | `#463F55` |
| `neutral-200` | `#E2DFE9` | `neutral-800` | `#2D2838` |
| `neutral-300` | `#CDC9D6` | `neutral-900` | `#1A1622` |
| `neutral-400` | `#A8A3B5` | | |

Status (each one is used with text, never alone). Values confirmed by the owner on 2026-11-06, for now:

| Token | Value | Use |
|---|---|---|
| `status-success` | `#1F7A4D` | Confirmed, paid, delivered |
| `status-warning` | `#8A5A00` | Needs attention, near a deadline |
| `status-error` | `#B3261E` | Failed, rejected, blocked |
| `status-info` | `#1D5FA8` | Neutral information |

Status tints for backgrounds: success `#DCF1E5` with text `#14532F`; warning `#FBF1DC` with text `#5C3B00`. Phase 1 uses only `status-error`.

Error text on the sign-in notice uses a lighter red, `error-text` `#CC4438`. It is for text only, never for borders or fills. Contrast 4.71:1 on `neutral-0`, but 4.38:1 on `neutral-50`, which fails. So `error-text` is used only on `neutral-0` (section 4.4). Approved by the owner on 2026-11-06 with the sign-in demonstration.

### 4.3 Semantic Tokens

Components use these names, which point to the tones above:

| Semantic token | Points to | Use |
|---|---|---|
| `color-page` | `neutral-50` | Background behind panels |
| `color-surface` | `neutral-0` | Panels, cards, tables, forms |
| `color-text` | `neutral-900` | Primary text |
| `color-text-muted` | `neutral-600` | Secondary text, labels, captions |
| `color-brand` | `purple-700` | Primary action, brand mark, links |
| `color-brand-hover` | `purple-800` | Primary action on hover |
| `color-brand-pressed` | `purple-900` | Primary action while pressed |
| `color-brand-soft` | `purple-100` | Selected item, highlight band |
| `color-brand-ink` | `purple-800` | Text on `color-brand-soft` |
| `color-focus` | `purple-600` | Focus ring |
| `color-border` | `neutral-200` | Decorative dividers only |
| `color-border-control` | `neutral-500` | Borders of fields and secondary buttons |

### 4.4 Contrast Check

Measured contrast ratios (WCAG 2.x). Text needs at least 4.5:1; control boundaries need at least 3:1.

| Pair | Ratio | Result |
|---|---|---|
| `neutral-900` on `neutral-0` | 17.8:1 | Pass |
| `neutral-900` on `neutral-50` | 16.5:1 | Pass |
| `neutral-600` on `neutral-0` | 6.7:1 | Pass |
| `neutral-600` on `neutral-50` | 6.3:1 | Pass |
| `neutral-0` on `purple-700` (primary button text) | 9.5:1 | Pass |
| `neutral-0` on `purple-800` (button hover) | 12.2:1 | Pass |
| `purple-700` on `neutral-0` (links) | 9.5:1 | Pass |
| `purple-800` on `purple-100` (selected item, highlight band) | 9.9:1 | Pass |
| `neutral-800` on `neutral-100` (tag) | 12.3:1 | Pass |
| `neutral-0` on `status-error` | 6.5:1 | Pass |
| `#CC4438` (`error-text`) on `neutral-0` | 4.71:1 | Pass (text only) |
| `#CC4438` (`error-text`) on `neutral-50` | 4.38:1 | Fail. Do not use on the page background |
| `neutral-500` (control border) on `neutral-50` | 4.0:1 | Pass (3:1 required) |
| `purple-600` (focus ring) on `neutral-0` | 7.3:1 | Pass (3:1 required) |
| `purple-600` (focus ring) on `neutral-50` | 6.8:1 | Pass (3:1 required) |
| `status-success` on `neutral-0` | 5.3:1 | Pass |
| `status-warning` on `neutral-0` | 5.9:1 | Pass |
| `status-info` on `neutral-0` | 6.5:1 | Pass |
| `#14532F` on `#DCF1E5` (success tag) | 7.7:1 | Pass |
| `#5C3B00` on `#FBF1DC` (warning tag) | 9.0:1 | Pass |
| `neutral-500` on `neutral-0` (control border) | 4.3:1 | Pass (3:1 required) |
| `neutral-400` on `neutral-0` | 2.5:1 | Fail for control borders. Decorative use only |

### 4.5 Where Purple Appears

Purple is used in these places, and only these:

- Primary action (one per screen or panel).
- Focus ring.
- Links.
- The brand mark.
- Current item in navigation and selected row in a table (specified in Phase 2).
- A highlight band with `color-brand-soft` for a notice or a call to attention (specified in Phase 2).

Purple is not used for: body text, large backgrounds of a page or a panel, status meaning, or decoration.

## 5. Typography

Typeface: **Public Sans** (approved, `docs/decisions/0021-interface-typeface.md`; SIL Open Font License, free). Fonts are stored in the project and served by the application. Loading from an external host is not used.

Fallback stack: `"Public Sans", "Segoe UI", Arial, sans-serif`.

Numbers in tables and amounts use **tabular figures** (`font-variant-numeric: tabular-nums`) so columns line up.

| Token | Size / line height | Weight | Use |
|---|---|---|---|
| `type-caption` | 12 px / 16 px | 400 | Captions, helper text |
| `type-label` | 12 px / 16 px | 600 | Form labels, table headers (letter-spacing 0.04 em) |
| `type-body` | 14 px / 20 px | 400 | Default interface text, table cells, buttons (weight 600) |
| `type-body-large` | 16 px / 24 px | 400 | Longer text, announcements, form input text |
| `type-heading-3` | 18 px / 24 px | 600 | Panel and section titles |
| `type-heading-2` | 20 px / 26 px | 600 | Page sections |
| `type-heading-1` | 28 px / 34 px | 700 | Page title (one per screen), tight letter-spacing (-0.01 em) |

Rules:

- Headings use `text-wrap: balance`.
- Running text is kept near 65 characters per line.
- Text is never smaller than 12 px.

## 6. Spacing, Layout, Shape, Motion

Spacing scale (base unit 4 px): `4 · 8 · 12 · 16 · 24 · 32 · 48` px. Every margin, padding and gap uses one of these.

### 6.1 Application Shell (Phase 1)

The shell is the frame that every signed-in screen uses. It has three regions:

- **Header** (full width, top): height 56 px, background `color-surface`, one bottom border `color-border`, horizontal padding 24 px. It contains, from left to right: the Expathio mark and the word "Expathio" as one lockup, 24 px high (section 11.1); the **simulated-data marker** (7.6), placed next to the name; and, on the right, the signed-in account name in `type-body` and the secondary button "Sign out" (7.1).
- **Navigation column** (left, below the header): reserved width 200 px, background `color-surface`, one right border `color-border`. **In Phase 1 this column has no items. Navigation items, their styles and their behavior are to be defined in Phase 2** (section 7.5).
- **Content area** (right of the navigation column, below the header): background `color-page`. It holds the page header (7.7) at the top and the page content below it. The content gutter is 28 px on desktop.

Rules for the shell:

- The shell is a layout for computer screens. It does not adapt to phone screens in Phase 1.
- Minimum supported window width: 1024 px. Narrower windows scroll horizontally only inside tables (Phase 2).
- Single-purpose forms: maximum width about 420 px.

### 6.2 Shape, Depth and Motion

Shape and depth:

- Corner radius: 10 px on controls (buttons, fields, notices); 16 px on cards and panels; full round on tags.
- Elevation: one soft level, used only on cards and panels. `0 1px 2px rgba(26,22,34,0.06), 0 6px 18px rgba(26,22,34,0.05)`. No other shadows. The shell header and navigation column have no elevation; they are separated by borders.
- Borders: 1 px.

Motion:

- Color and background transitions: 150 ms, ease-out. No other animation in the first version.
- When the operating system asks for reduced motion, transitions are removed.

## 7. Components and States

Every interactive component has these states: **default, hover, pressed, focus, disabled**. Loading is added where an action waits for the server.

Focus (every interactive element): a 2 px outline in `color-focus`, offset 2 px. It must be visible on `color-surface` and `color-page`.

Phase 1 uses these components: button (7.1), form field (7.2), notice (7.4, sign-in error only), neutral tag (7.6, simulated-data marker only), page header (7.7), the shell (6.1) and the sign-in screen (7.9). The others are not used in Phase 1.

### 7.1 Button

- **Primary:** background `color-brand`, text `neutral-0`. One per screen or panel.
- **Secondary:** background `color-surface`, text `color-text`, border 1 px `color-border-control`.

| State | Primary | Secondary |
|---|---|---|
| Default | `color-brand` | Surface, control border |
| Hover | `color-brand-hover` | Background `neutral-50` |
| Pressed | `color-brand-pressed` | Background `neutral-100` |
| Focus | Focus outline | Focus outline |
| Disabled | Background `neutral-200`, text `color-text-muted` | Text `color-text-muted`, border `neutral-200` |
| Loading | Keeps its color, shows a text label such as "Signing in…", not clickable | Same |

Height 40 px (default). Horizontal padding 16 px. Label `type-body`, weight 600. Radius 10 px.

Buttons say what they do ("Sign in", "Sign out"), never "OK" or "Submit".

### 7.2 Form Field

- Label above the field, `type-label`.
- Field: `color-surface`, 1 px `color-border-control`, radius 10 px, height 40 px, padding 10 px 12 px, text `type-body-large`.
- Helper text below, `type-caption`, `color-text-muted`.
- Error text below, `type-caption`, in `status-error`, with the text saying what to correct. The field border does not change color: the error is shown by the text and by the notice (7.4), not by a red border.

| State | Field |
|---|---|
| Default | Border `color-border-control` |
| Hover | Border `color-text-muted` |
| Focus | Focus outline |
| Disabled | Background `neutral-50`, text `color-text-muted`, border `neutral-200` |
| Error | Border `color-border-control` (unchanged), error text below in `status-error` |

Labels contain only the field name. Phase 1 fields are all required, so no field is marked as required. A field that is optional says so in its label.

### 7.3 Table

Not used in Phase 1. Specified in Phase 2, when a screen with a table exists.

### 7.4 Notice

- Layout: `color-surface` background, 1 px `color-border` border, radius 10 px, padding 12 px 14 px. Error notices: title and text in `error-text` (`#CC4438`, section 4.2). Other status notices use the status color with its text.
- Phase 1 uses one notice: the sign-in failure notice, with `status-error`.
- Notices do not close on their own. The user dismisses them, or the next state replaces them.

The highlight band (`color-brand-soft` background) is not used in Phase 1.

### 7.5 Navigation

**Not defined in Phase 1.** Its place in the shell is set in section 6.1. Item styles, the current-item state, hover behavior and any icons are specified in Phase 2, when the screens that need navigation exist.

### 7.6 Tag

Small text labels. Radius full, padding 3 px 8 px, `type-label` size. Each tag always has its text.

Phase 1 uses one variant only, the **simulated-data marker**:

- Text: "Simulated data".
- Neutral: `neutral-100` background, `neutral-800` text (contrast 12.3:1).
- Shown in the shell header (6.1) and on the sign-in screen (7.9), so that every screen says the data is fictional.

Status tags (success, warning, brand) are specified in Phase 2.

### 7.7 Page Header

One per page: page title (`type-heading-1`), an optional line of description (`type-body`, `color-text-muted`), and the page's main action button on the right. The title is the screen's name, not a sentence.

### 7.8 Highlight Band

Not used in Phase 1. Specified in Phase 2.

### 7.9 Sign-in Screen (Phase 1 entry)

The first screen the user sees. It is the only screen outside the shell.

- **Layout:** a single panel centered on the page, width 420 px, background `color-surface`, radius 16 px, the one soft elevation (6.2). The page behind it is `color-page`.
- **Content, from top to bottom:**
  1. The simulated-data marker (7.6).
  2. Page title, `type-heading-1`: "Sign in".
  3. Sign-in failure notice (7.4), only after a failed attempt. Text: "The email or password is not correct." It is shown above the fields.
  4. Field "Email", type email (7.2).
  5. Field "Password", type password (7.2).
  6. Primary button "Sign in", full width of the panel (7.1).
- **Not on this screen in Phase 1:** sign-up, organization selection, and any other account option. Product defined that Phase 1 uses test accounts only (ADR 0022) and one fixed organization (ADR 0023).
- **After a successful sign-in:** the user sees the post-login page inside the application shell (7.10).

### 7.10 Post-login Page (Phase 1)

Content defined by ADR 0028, `docs/decisions/0028-experience-screen-decisions-phase-1.md`. **Visual design not yet approved by the owner.** The layout shown in the demonstration (shell with this content) has not been reviewed.

- Shown inside the shell (6.1), in the content area.
- Page title: the organization name ("MONUMENT"), `type-heading-1`.
- Content: the role of the account's membership (for example "Operations Assistant"), `type-body`, and the simulated-data marker (7.6).
- No business content in Phase 1. The tools start in Phase 2 or later.

## 8. Icons

Not used in Phase 1. The owner chose text labels only for Phase 1 (section 13). When an icon set is needed in Phase 2, it must be free to use, and its license must be checked before it is added as a dependency (`CLAUDE.md`, section 2).

## 9. Accessibility

Target: **WCAG 2.2 level AA**, approved by the owner on 2026-11-06.

Checked in this specification:

- Text: at least 4.5:1 on every surface listed in section 4.4.
- Control boundaries: at least 3:1 (`neutral-500`, 4.3:1).
- Focus: visible on every surface (`purple-600`).
- Decorative dividers (`neutral-200`) carry no meaning and are exempt.

Still to check in implementation: keyboard order on the sign-in screen and the shell, screen-reader labels on every control, text resizing up to 200 %, and disabled-control behavior.

## 10. Verifying Color Across Screens

This checklist is for the owner, to be run when the first screens exist. It is not part of the code.

1. In Windows, Settings > System > Display, confirm the color profile of each screen. Turn off night light on both screens while comparing.
2. Open the same screen on both screens, full screen, and compare the primary button and the simulated-data marker.
3. If the difference is only in tone, the design still passes, because meaning is carried by text, shape and position. If a meaning depends only on tone, the design fails and must be changed.

The owner ran the demonstration on two screens on 2026-11-06 and found it acceptable. This checklist is still to be run on the implemented screens.

## 11. Logo and Company Identity

Two identities are kept apart (`03-USER-EXPERIENCE.md`, section 17): the Expathio identity, specified here, and the MONUMENT identity of the fictional company, which is not part of this specification.

### 11.1 Expathio Logo (approved, Q-016)

Status: **APPROVED by the owner on 2026-11-09.** The mark is the three-phase ring described below. Until this approval, the shell showed the text "Expathio" (6.1; `docs/decisions/0028-experience-screen-decisions-phase-1.md`).

Rules for the mark:

- **Form:** a mark and the word "Expathio" as one lockup, drawn as a vector image (SVG) so it stays sharp at any size. The source file is kept in the project.
- **Color:** tones of the purple scale only, as in the approved mark. Never on a dark purple surface. No gradient, shadow or effect.
- **Clear space:** at least the height of the letter "E" of the word, on every side.
- **Minimum size:** 24 px high in the shell header. The mark alone is not shown below 16 px.
- **Placement in Phase 1:** the shell header (6.1), at the left, in the place of the text "Expathio". The sign-in screen (7.9) has no brand element in Phase 1, so no logo is placed there.
- **Accessibility:** the logo has the accessible name "Expathio". The same name is also in the page text.
- **Not allowed:** the MONUMENT typeface or any MONUMENT mark in the Expathio interface.

The owner chose option A on 2026-11-06 (Q-016). Experience and Design draws the mark. The options were:

- **A.** Experience and Design draws the mark in a free vector editor. Cost R$ 0 per month. Recommended.
- **B.** An external designer. Cost not known. Needs the owner's approval before any contact, and the contract must transfer the rights of the files to the project.
- **C.** No mark. The text "Expathio" stays the product name. Cost R$ 0.

Drafts were shown as visible screens in the shell header, as `CLAUDE.md`, section 12 requires. The owner has chosen one direction for now.

**Approved mark (owner, 2026-11-09).** The mark is the three-phase ring: an open ring made of three arcs, with a gap between each arc. The input arc is the lightest purple, the process arc is the middle purple, and the output arc is the deepest purple. The owner asked that these values be kept for the rest of the visual identity work, so later work uses the values below.

The owner approved the purple version on 2026-11-09. The mark uses tones of one hue, and each arc is a different step of the purple scale. The order of the arcs on the ring carries the meaning as well as the tone.

| Part | Token | Hex | Contrast on `neutral-0` |
|---|---|---|---|
| Input arc | `purple-400` | `#A385D3` | 3.06:1 (graphic, at the 3:1 minimum) |
| Process arc | `purple-600` | `#6A3FA6` | 7.31:1 (graphic, 3:1 required) |
| Output arc | `purple-900` | `#331856` | 14.94:1 (graphic, 3:1 required) |

Points recorded at approval:

- **The lightest tone is at the minimum.** `purple-400` gives 3.06:1, which passes the 3:1 rule for graphics with no margin. The owner kept it.
- **Tone is not the only signal.** Section 4 says color is never the only signal. In the mark, position on the ring carries the order of the stages.
- **One color rule.** The owner confirmed that tones of one hue satisfy the one-color rule. The rules above now say "tones of the purple scale".
- **Legibility at 16 px** has not been checked on a real screen.

Geometry, on a 24-unit grid: circle of radius 8 centered at (12, 12), stroke width 2.2, round caps. Arcs run clockwise from the positive x-axis: input from 90° to 190°, process from 210° to 310°, output from 330° to 70°.

```svg
<svg viewBox="0 0 24 24"><path d="M12 20 A8 8 0 0 1 4.12 10.61" fill="none" stroke="#A385D3" stroke-width="2.2" stroke-linecap="round"/><path d="M5.07 8 A8 8 0 0 1 17.14 5.87" fill="none" stroke="#6A3FA6" stroke-width="2.2" stroke-linecap="round"/><path d="M18.93 8 A8 8 0 0 1 14.74 19.52" fill="none" stroke="#331856" stroke-width="2.2" stroke-linecap="round"/></svg>
```

### 11.2 MONUMENT Identity (proposal, Q-016)

Not specified here. Proposed: a separate document, owned by Experience and Design, that defines the fictional company's logo, typeface and colors, linked from `08-COMPANY.md`, section 2. It stays out of the Expathio interface. The owner confirms the owner and the location of that document. Today `08-COMPANY.md`, section 2, refers to a company visual specification that does not exist (section 13.3).

## 12. Implementation Notes

For Frontend Engineering, when this specification is approved:

- Tokens are defined once, as named values, and read by every component.
- No component uses a raw color value.
- A change to a tone is first recorded here.
- Public Sans is added as a dependency in the first screen, with a pinned version recorded in that session's record (`docs/decisions/0021-interface-typeface.md`).
- Dark mode is not built in Phase 1.

## 13. Decisions and Open Points

### 13.1 Decided by the owner on 2026-11-06

1. **Typeface:** Public Sans, approved as a dependency (`docs/decisions/0021-interface-typeface.md`).
2. **Font hosting:** files stored in the project and served by the application. Confirmed by the owner. Loading from Google Fonts would send each visitor's address to Google.
3. **Dark mode:** not in Phase 1.
4. **Accessibility target:** WCAG 2.2 AA.
5. **Interface density:** comfortable, as used in this specification. A compact density would be a separate decision.
6. **Icons:** none in Phase 1. Navigation uses text.
7. **Status colors:** values in section 4.2, confirmed for now.
8. **Phase 1 screens:** the sign-in screen (7.9) and the application shell (6.1) only. Navigation items are defined in Phase 2.
9. **Direction:** the refined direction with brand in points (section 2) is approved.
10. **Sign-in demonstration:** approved by the owner. Labels without "required"; input borders stay neutral in the error state; error notice with a 1 px border and error text in `error-text` (`#CC4438`).

### 13.2 Open points to clarify before implementation

These are not decided. They belong to Product, unless noted.

1. **Sign-in identifier.** Answered by ADR 0028: e-mail address (7.9).
2. **Page after sign-in.** Answered by ADR 0028: organization name, role and simulated-data label (7.10).
3. **Password recovery.** Answered by ADR 0028: not in Phase 1, not shown.
4. **Expathio logo.** Approved by the owner on 2026-11-09 (section 11.1). The MONUMENT identity is still open in `docs/OPEN-QUESTIONS.md`, Q-016.

### 13.3 Routed to other functions

- **MONUMENT company visual specification.** `08-COMPANY.md`, section 2, refers to a document that does not exist, and no owner is assigned. Proposed as a separate document in section 11.2 (Q-016). Routed to Product and Documentation to correct the reference in `08`.
- **`docs/CURRENT_STATE.md`, "Visual specification" open item.** Routed to Product and Documentation, to update when this specification is approved.

### 13.4 Not blocking this specification

The implementation of Public Sans, the simulated-data marker and the status colors is done by Frontend Engineering in the first screen. Those steps are not part of this document.

## 14. Screen Map (Q-011)

Status: **PROPOSED, IN DISCUSSION.** The screens of Phase 1 are listed below. Screens from Phase 2 on are not defined here. They come from `06-ROADMAP.md`, section 5, and `08-COMPANY.md`, section 6.1.

| # | Screen | Phase | Where it appears | Specified in | Status |
|---|---|---|---|---|---|
| 1 | Sign in | 1 | Outside the shell | 7.9 | Approved by the owner, 2026-11-06 |
| 2 | Post-login page: organization, role, simulated-data marker | 1 | Content area of the shell | 7.10 | Content per ADR 0028. Visual design not approved |
| — | Application shell | 1 | Every signed-in screen | 6.1 | Specified. Visual design not approved |
| — | Member list of the organization | 1, proposed | Content area of the shell | Q-011 only | Proposed, not approved. Not in 7.10 |
| — | Navigation items | 2 and later | Navigation column | 7.5 | Not defined in Phase 1 |

Rules:

- Phase 1 has no sign-up, no password recovery and no organization selection (ADR 0022, ADR 0023, ADR 0028).
- The member list is not part of Phase 1 until the owner approves it. If approved, section 7.10 is updated to match.
- The member list needs an access rule before it is built. `08-COMPANY.md`, section 6.1, has no row for the list today. Routed to Product and Documentation.
- Navigation items are a Phase 2 decision (7.5). Hiding a navigation item is not access control (`CLAUDE.md`, section 10).

## 15. Specification Completeness (Q-010)

Status: this section lists what this specification covers and what is still open before implementation. It does not close Q-010. The owner decides that.

**Covered:** tones and tokens (4), typography (5), spacing, shell and layout (6), the components used in Phase 1 (7.1, 7.2, 7.4, 7.6, 7.7, 7.9, 7.10), accessibility target (9), color check method (10), logo rules (11.1).

**Open before implementation:**

- Keyboard order and screen-reader labels on the sign-in screen and the shell (9).
- Text resizing up to 200 % (9).
- Disabled-control behavior (9).
- Color check on the implemented screens (10).
- Owner approval of the visual design of the shell (6.1) and the post-login page (7.10).
- Owner approval of `#CC4438` as a tone in the scale. Section 4.2 currently allows it as a text-only exception.
- Public Sans package, with a pinned version recorded in the session that installs it (12).
