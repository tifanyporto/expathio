# 0027 — First-Version Role Titles

**Status:** APPROVED  
**Date:** 2026-11-06  
**Approved by:** Project owner

---

## Context

ADR 0009 names the four participant roles of the first version: Operations Coordinator, Customer Service Specialist, Sales Analyst and Financial Analyst.

The platform is aimed at beginners (`01-PRODUCT.md`, section 2), and `08-COMPANY.md`, section 7, states that no role requires prior experience. The titles "Coordinator", "Specialist", and "Analyst" suggest an experience level that the roles do not require.

## Alternatives

1. **Keep the current titles.** Discarded: they suggest a level of experience the roles do not ask for.
2. **Assistant-level titles, with "Customer Support Agent" and "Sales Assistant".** Considered first. A search of public job postings showed that "Sales Assistant" is mostly a UK term, and that "Customer Service Representative" is the most common title for the work (Medallia cites 58% of customer service postings on Indeed).
3. **Assistant-level titles, with the most common forms found in postings.** Chosen.

## Decision

The four roles are renamed. Their responsibilities, tools and permissions do not change.

| Previous title | New title |
|---|---|
| Operations Coordinator | Operations Assistant |
| Customer Service Specialist | Customer Service Representative |
| Sales Analyst | Sales Support Assistant |
| Financial Analyst | Finance Assistant |

The titles are used in the product in English (`CLAUDE.md`, section 9).

## Rationale

- Each new title is common in public entry-level postings for similar work. The search covered job boards and recruiter sites, not LinkedIn directly.
- "Assistant" and "Representative" signal a role that starts with support, without an experience level.
- "Sales Support Assistant" matches the work: order monitoring and sales reports, not store sales.

## Consequences

- `docs/decisions/0009-first-version-tools-and-roles.md` and `docs/decisions/0024-phase-1-business-roles-loaded.md` use the new titles. The roles and tools in them are unchanged.
- `docs/08-COMPANY.md` uses the new titles in all sections.
- The file name of `docs/decisions/0025-refund-decision-by-financial-analyst.md` keeps its original name, to avoid breaking links. The heading and text use the new title.
- The seed data for Phase 1 (ADR 0024) uses the new titles.
- Cost: R$ 0 per month.
