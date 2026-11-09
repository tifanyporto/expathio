// Seed: loads MONUMENT, the four roles, their permission rows, the test accounts and their
// memberships. Safe to run more than once (every insert skips rows that already exist).
//
// The command-line entry point is server/db/run-seed.ts.

import { eq } from "drizzle-orm";
import type { Auth } from "../auth/auth.js";
import type { Database } from "./database.js";
import * as schema from "./schema.js";
import {
  TEST_ACCOUNTS,
  membershipRows,
  organizationRow,
  rolePermissionRows,
  roleRows,
} from "./seed-data.js";

export async function seed(db: Database, auth: Auth, testPassword: string): Promise<void> {
  const organization = organizationRow();
  await db.insert(schema.organizations).values(organization).onConflictDoNothing();
  await db.insert(schema.roles).values(roleRows()).onConflictDoNothing();
  await db.insert(schema.rolePermissions).values(rolePermissionRows()).onConflictDoNothing();

  for (const account of TEST_ACCOUNTS) {
    const existing = await db.select({ id: schema.user.id }).from(schema.user).where(eq(schema.user.email, account.email));
    if (existing.length === 0) {
      // Server-side call to the library. It is not exposed over HTTP (auth-routes.ts).
      await auth.api.signUpEmail({
        body: { email: account.email, password: testPassword, name: account.name },
      });
    }
  }

  for (const row of membershipRows(organization.id)) {
    const [found] = await db.select({ id: schema.user.id }).from(schema.user).where(eq(schema.user.email, row.email));
    if (!found) {
      throw new Error(`Test account ${row.email} was not created; seed stopped.`);
    }
    await db
      .insert(schema.memberships)
      .values({
        id: `${row.organizationId}:${row.roleKey}`,
        organizationId: row.organizationId,
        userId: found.id,
        roleKey: row.roleKey,
      })
      .onConflictDoNothing();
  }
}

