// Database connection entry point.
//
// BLOCKED: the PostgreSQL driver for Drizzle (the `pg` package) is not an approved
// dependency yet. Asked in docs/OPEN-QUESTIONS.md (Q-018). Until the owner decides,
// createDatabase stops with a clear error. Nothing is installed or guessed here.
//
// Once approved, this file creates a Drizzle client with drizzle-orm/node-postgres
// and returns it. Every other module only uses the `Database` type below.

import type { PgDatabase, PgQueryResultHKT } from "drizzle-orm/pg-core";
import * as schema from "./schema.js";

export type Database = PgDatabase<PgQueryResultHKT, typeof schema>;

export const DATABASE = Symbol("DATABASE");

export function createDatabase(_databaseUrl: string): Database {
  throw new Error(
    "The PostgreSQL driver is not approved yet, so the database cannot be created. " +
      "See docs/OPEN-QUESTIONS.md, entry Q-018.",
  );
}
