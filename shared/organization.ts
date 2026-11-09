// The fixed organization of Phase 1 (docs/06-ROADMAP.md, section 4, item 6).
// Creating organizations is a future step (docs/01-PRODUCT.md, section 10).

export const MONUMENT = {
  // Stable identifier used as the organization_id in every business table.
  id: "monument",
  name: "MONUMENT",
  // Every Phase 1 organization and account is simulated (docs/decisions/0022).
  simulated: true,
} as const;
