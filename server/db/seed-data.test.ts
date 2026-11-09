// Tests for the seed data: the four roles, their permission rows and the test accounts.
// Business rule: every Phase 1 account is a test account with a fictional e-mail (docs/decisions/0022).

import { describe, expect, it } from "vitest";
import { RESOURCES, ROLE_KEYS } from "../../shared/access-rules.js";
import { MONUMENT } from "../../shared/organization.js";
import { TEST_ACCOUNTS, membershipRows, organizationRow, rolePermissionRows, roleRows } from "./seed-data.js";

describe("seed data", () => {
  it("creates MONUMENT as the simulated organization", () => {
    expect(organizationRow()).toEqual({ id: "monument", name: "MONUMENT", simulated: true });
    expect(MONUMENT.id).toBe("monument");
  });

  it("loads the four roles as data", () => {
    expect(roleRows().map((row) => row.key)).toEqual(ROLE_KEYS);
  });

  it("loads one permission row per role and resource", () => {
    expect(rolePermissionRows()).toHaveLength(ROLE_KEYS.length * RESOURCES.length);
  });

  it("uses fictional test accounts only, in the reserved .test domain", () => {
    for (const account of TEST_ACCOUNTS) {
      expect(account.email.endsWith("@expathio.test")).toBe(true);
    }
  });

  it("creates one test account per role, with distinct e-mail addresses", () => {
    expect(TEST_ACCOUNTS.map((account) => account.roleKey).sort()).toEqual([...ROLE_KEYS].sort());
    expect(new Set(TEST_ACCOUNTS.map((account) => account.email)).size).toBe(TEST_ACCOUNTS.length);
  });

  it("links every test account to MONUMENT", () => {
    const rows = membershipRows("monument");
    expect(rows).toHaveLength(TEST_ACCOUNTS.length);
    for (const row of rows) {
      expect(row.organizationId).toBe("monument");
    }
  });
});
