# 0021 — Typeface for the Expathio Interface

**Status:** APPROVED  
**Date:** 2026-11-06  
**Approved by:** Project owner

---

## Context

The visual specification in `09-DESIGN-SYSTEM.md` needs one typeface for the platform interface before the first Phase 1 screen is built. The owner compared three typeface options, shown on the same layout, and chose the one the specification now uses. The owner then approved the typeface as a dependency of the project on 2026-11-06.

Other typefaces were compared and set aside: IBM Plex Sans, Source Sans 3 and Atkinson Hyperlegible. Their comparison is in `docs/sessions/experience-and-design/2026-11-06-visual-specification-options.md`.

Font files are a dependency. `CLAUDE.md`, section 2, requires owner approval for any dependency, and section 8 requires the monthly cost and maintenance effort to be stated.

## Alternatives

1. **Public Sans, stored with the project and served by the application.** Chosen. The typeface is under the SIL Open Font License, which allows free use, including in a commercial product. Cost R$ 0 per month. Maintenance is low: one family, one package to update when needed.
2. **Public Sans loaded from an external font host (for example Google Fonts).** Cost R$ 0. Lower effort to install. Discarded: each visitor's browser sends its address to the external host, which conflicts with the privacy stance of `CLAUDE.md`, section 11.
3. **The operating system's own fonts (system font stack).** Cost R$ 0 and no dependency. Discarded: each computer shows a different typeface, which weakens the consistency the owner asked for (`09-DESIGN-SYSTEM.md`, section 3).
4. **Other open typefaces (IBM Plex Sans, Source Sans 3, Atkinson Hyperlegible).** Cost R$ 0 each. Set aside by the owner in the comparison. IBM Plex Sans needs a second family for code, which adds maintenance.

## Decision

1. The platform interface uses **Public Sans** as its only typeface, with the fallback stack `"Public Sans", "Segoe UI", Arial, sans-serif`.
2. The font files are a dependency of the project. Frontend Engineering adds the package when it implements the first screen, with a pinned version recorded in its own session record. This decision approves the typeface, not a specific package version.
3. The font files are stored in the project and served by the application. No visitor's browser loads fonts from an external host.
4. Numbers in tables use tabular figures, so columns line up.
5. The typeface is used for the Expathio interface only. It is not the MONUMENT company's typeface, which `08-COMPANY.md`, section 2, keeps outside this specification.

## Rationale

- Public Sans is neutral and modern, which fits the owner's request for a refined interface without a rigid look. It has a range of weights, so headings and labels can be separated by weight alone.
- A free typeface keeps the monthly cost at R$ 0, as `CLAUDE.md`, section 8, requires.
- Storing the files with the project removes the privacy issue of external hosting.
- A single family keeps the number of dependencies and the maintenance effort low.

## Consequences

- Frontend Engineering adds one font package and a short setup in the first screen. Installation is not done in this decision.
- Any change to the typeface is a new decision, recorded here or in a new ADR.
- The typeface must be checked for legibility of the interface's numbers and of the Portuguese characters if the product ever gets a Portuguese version. Public Sans supports the Latin characters used in Portuguese.
- The text sizes in `09-DESIGN-SYSTEM.md`, section 5, are measured against this typeface.

## Open Points

- Self-hosting is confirmed by the owner on 2026-11-06. The approval of the package covers it, as decision point 3 states.
- Dark mode, accessibility target, interface density, icon set and status color values are not part of this decision. They stay open in `09-DESIGN-SYSTEM.md`, section 13.
