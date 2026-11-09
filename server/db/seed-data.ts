// Seed data for Phase 1, as plain values. No database access here, so the rows can be
// tested without PostgreSQL (docs/decisions/0024: the four roles are loaded as data).
//
// All accounts are test accounts with fictional e-mail addresses in the reserved
// ".test" domain (CLAUDE.md, section 11; docs/decisions/0022). Their passwords are not
// stored here: the seed reads them from the TEST_ACCOUNT_PASSWORD environment variable.

import { RESOURCES, ROLE_DEFINITIONS, ROLE_KEYS, type RoleKey } from "../../shared/access-rules.js";
import { MONUMENT } from "../../shared/organization.js";

export interface TestAccount {
  readonly email: string;
  readonly name: string;
  readonly roleKey: RoleKey;
}

// One test account per business role. The name says it is simulated.
export const TEST_ACCOUNTS: readonly TestAccount[] = [
  { email: "operations.assistant@expathio.test", name: "Test Operations Assistant", roleKey: "operations_assistant" },
  {
    email: "customer.service@expathio.test",
    name: "Test Customer Service Representative",
    roleKey: "customer_service_representative",
  },
  {
    email: "sales.support@expathio.test",
    name: "Test Sales Support Assistant",
    roleKey: "sales_support_assistant",
  },
  { email: "finance.assistant@expathio.test", name: "Test Finance Assistant", roleKey: "finance_assistant" },
];

export interface RoleRow {
  readonly key: RoleKey;
  readonly title: string;
  readonly description: string;
}

export interface RolePermissionRow {
  readonly roleKey: RoleKey;
  readonly resource: string;
  readonly access: string;
  readonly ownRecordsOnly: boolean;
}

export interface MembershipRow {
  readonly organizationId: string;
  readonly email: string;
  readonly roleKey: RoleKey;
}

export function organizationRow() {
  return { id: MONUMENT.id, name: MONUMENT.name, simulated: MONUMENT.simulated };
}

export function roleRows(): RoleRow[] {
  return ROLE_KEYS.map((key) => ({
    key,
    title: ROLE_DEFINITIONS[key].title,
    description: ROLE_DEFINITIONS[key].description,
  }));
}

// One row per role and resource, so every role has a complete, explicit permission set.
export function rolePermissionRows(): RolePermissionRow[] {
  return ROLE_KEYS.flatMap((roleKey) =>
    RESOURCES.map((resource) => {
      const permission = ROLE_DEFINITIONS[roleKey].permissions[resource];
      return { roleKey, resource, access: permission.access, ownRecordsOnly: permission.ownRecordsOnly };
    }),
  );
}

export function membershipRows(organizationId: string): MembershipRow[] {
  return TEST_ACCOUNTS.map((account) => ({ organizationId, email: account.email, roleKey: account.roleKey }));
}
