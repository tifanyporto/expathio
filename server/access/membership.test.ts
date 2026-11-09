// Tests for organization membership and data isolation (docs/decisions/0010, 0023, 0024).
// These tests use in-memory membership rows. The database loads the same shape of rows in production.

import { describe, expect, it } from "vitest";
import { AccessDeniedError, authorize, findMembership, type MembershipRecord } from "./membership.js";

const MEMBERSHIPS: MembershipRecord[] = [
  { organizationId: "monument", userId: "user-ops", roleKey: "operations_assistant" },
  { organizationId: "monument", userId: "user-finance", roleKey: "finance_assistant" },
  // A second organization, used only to prove isolation. Phase 1 has one fixed organization.
  { organizationId: "other-org", userId: "user-ops", roleKey: "finance_assistant" },
];

describe("findMembership", () => {
  it("finds the membership of a user in the organization", () => {
    expect(findMembership(MEMBERSHIPS, "user-ops", "monument")?.roleKey).toBe("operations_assistant");
  });

  it("returns nothing for a user with no membership in the organization", () => {
    expect(findMembership(MEMBERSHIPS, "user-stranger", "monument")).toBeUndefined();
  });

  it("does not let a membership in one organization count in another", () => {
    expect(findMembership([MEMBERSHIPS[0]!], "user-ops", "other-org")).toBeUndefined();
  });
});

describe("authorize", () => {
  it("allows an action the role's permission table grants", () => {
    const membership = authorize(MEMBERSHIPS, "user-ops", "monument", "stock_levels", "change");
    expect(membership.roleKey).toBe("operations_assistant");
  });

  it("denies an action the role's permission table does not grant", () => {
    expect(() => authorize(MEMBERSHIPS, "user-ops", "monument", "payment_and_refund_ledger", "change")).toThrow(
      AccessDeniedError,
    );
  });

  it("denies a user who is not a member of the organization", () => {
    expect(() => authorize(MEMBERSHIPS, "user-stranger", "monument", "orders", "read")).toThrow(AccessDeniedError);
  });

  it("never grants access in an organization where the user has no membership, even with a role elsewhere", () => {
    // user-finance can decide refunds in monument, but has no membership in other-org.
    expect(() =>
      authorize(MEMBERSHIPS, "user-finance", "other-org", "refund_or_exchange_requests", "decide"),
    ).toThrow(AccessDeniedError);
  });

  it("applies the role of the organization being checked", () => {
    // user-ops is a Finance Assistant in other-org, so the ledger is allowed there and not in monument.
    expect(authorize(MEMBERSHIPS, "user-ops", "other-org", "payment_and_refund_ledger", "change").roleKey).toBe(
      "finance_assistant",
    );
    expect(() => authorize(MEMBERSHIPS, "user-ops", "monument", "payment_and_refund_ledger", "change")).toThrow(
      AccessDeniedError,
    );
  });
});
