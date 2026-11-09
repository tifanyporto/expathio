// Database connection entry point.
//
// Creates the Drizzle client on top of the `pg` driver (node-postgres), approved in
// docs/OPEN-QUESTIONS.md, entry Q-018. Every other module only uses the `Database` type.

import { drizzle, type NodePgDatabase } from "drizzle-orm/node-postgres";
import * as schema from "./schema.js";

export type Database = NodePgDatabase<typeof schema>;

export const DATABASE = Symbol("DATABASE");

export function createDatabase(databaseUrl: string): Database {
  if (databaseUrl.trim() === "") {
    throw new Error("DATABASE_URL is empty.");
  }
  return drizzle(databaseUrl, { schema });
}
