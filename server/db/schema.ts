// Database schema (Drizzle ORM, PostgreSQL).
//
// Tables are split in two groups:
// 1. Login tables (user, session, account, verification). better-auth needs these
//    exact table and column names. Account data lives in our own database (ADR 0014).
// 2. Organization tables (organizations, roles, memberships). Every business table
//    carries an organization_id, and queries filter by it (ADR 0010).
//
// Migrations are generated from this file with drizzle-kit (see server/drizzle.config.ts).

import { sql } from "drizzle-orm";
import {
  boolean,
  index,
  pgTable,
  text,
  timestamp,
  uniqueIndex,
} from "drizzle-orm/pg-core";

// ---- Login tables (better-auth) ------------------------------------------

export const user = pgTable("user", {
  id: text("id").primaryKey(),
  name: text("name").notNull(),
  // Login identifier (docs/decisions/0028, decision 1).
  email: text("email").notNull().unique(),
  emailVerified: boolean("email_verified").notNull().default(false),
  image: text("image"),
  createdAt: timestamp("created_at").notNull().default(sql`now()`),
  updatedAt: timestamp("updated_at").notNull().default(sql`now()`),
});

export const session = pgTable(
  "session",
  {
    id: text("id").primaryKey(),
    expiresAt: timestamp("expires_at").notNull(),
    token: text("token").notNull().unique(),
    createdAt: timestamp("created_at").notNull().default(sql`now()`),
    updatedAt: timestamp("updated_at").notNull().default(sql`now()`),
    ipAddress: text("ip_address"),
    userAgent: text("user_agent"),
    userId: text("user_id")
      .notNull()
      .references(() => user.id, { onDelete: "cascade" }),
  },
  (table) => [index("session_user_id_idx").on(table.userId)],
);

export const account = pgTable(
  "account",
  {
    id: text("id").primaryKey(),
    accountId: text("account_id").notNull(),
    providerId: text("provider_id").notNull(),
    userId: text("user_id")
      .notNull()
      .references(() => user.id, { onDelete: "cascade" }),
    accessToken: text("access_token"),
    refreshToken: text("refresh_token"),
    idToken: text("id_token"),
    accessTokenExpiresAt: timestamp("access_token_expires_at"),
    refreshTokenExpiresAt: timestamp("refresh_token_expires_at"),
    scope: text("scope"),
    // Password hash for the e-mail and password login (never the password itself).
    password: text("password"),
    createdAt: timestamp("created_at").notNull().default(sql`now()`),
    updatedAt: timestamp("updated_at").notNull().default(sql`now()`),
  },
  (table) => [index("account_user_id_idx").on(table.userId)],
);

export const verification = pgTable(
  "verification",
  {
    id: text("id").primaryKey(),
    identifier: text("identifier").notNull(),
    value: text("value").notNull(),
    expiresAt: timestamp("expires_at").notNull(),
    createdAt: timestamp("created_at").notNull().default(sql`now()`),
    updatedAt: timestamp("updated_at").notNull().default(sql`now()`),
  },
  (table) => [index("verification_identifier_idx").on(table.identifier)],
);

// ---- Organization tables --------------------------------------------------

export const organizations = pgTable("organizations", {
  id: text("id").primaryKey(),
  name: text("name").notNull(),
  simulated: boolean("simulated").notNull().default(true),
  createdAt: timestamp("created_at").notNull().default(sql`now()`),
});

// Business role catalog. A role is reference data shared by every organization,
// so this table has no organization_id. Its rows come from shared/access-rules.ts.
export const roles = pgTable("roles", {
  key: text("key").primaryKey(),
  title: text("title").notNull(),
  description: text("description").notNull(),
});

// The permission rows of each role (docs/08-COMPANY.md, section 6.1).
// Also loaded from shared/access-rules.ts by the seed (docs/decisions/0024).
export const rolePermissions = pgTable(
  "role_permissions",
  {
    roleKey: text("role_key")
      .notNull()
      .references(() => roles.key),
    resource: text("resource").notNull(),
    access: text("access").notNull(),
    ownRecordsOnly: boolean("own_records_only").notNull(),
  },
  (table) => [uniqueIndex("role_permissions_role_resource_uniq").on(table.roleKey, table.resource)],
);

// Direct link between an account, an organization and a role (docs/decisions/0023).
// The unique indexes enforce "one occupant per role" (ADR 0007) and one role per account in an organization.
export const memberships = pgTable(
  "memberships",
  {
    id: text("id").primaryKey(),
    organizationId: text("organization_id")
      .notNull()
      .references(() => organizations.id),
    userId: text("user_id")
      .notNull()
      .references(() => user.id, { onDelete: "cascade" }),
    roleKey: text("role_key")
      .notNull()
      .references(() => roles.key),
    createdAt: timestamp("created_at").notNull().default(sql`now()`),
  },
  (table) => [
    uniqueIndex("memberships_org_user_uniq").on(table.organizationId, table.userId),
    uniqueIndex("memberships_org_role_uniq").on(table.organizationId, table.roleKey),
    index("memberships_user_id_idx").on(table.userId),
  ],
);
