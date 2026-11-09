// Applies the migration files in server/db/migrations to the database in DATABASE_URL.
// Migrations already applied are skipped, so running it again is safe.
//
//   npm run build && node dist/server/db/migrate.js

import { fileURLToPath } from "node:url";
import { migrate } from "drizzle-orm/node-postgres/migrator";
import { loadConfig } from "../config/config.js";
import { createDatabase } from "./database.js";

export async function runMigrations(databaseUrl: string): Promise<void> {
  const db = createDatabase(databaseUrl);
  // Path is relative to this compiled file: dist/server/db -> server/db/migrations.
  await migrate(db, { migrationsFolder: fileURLToPath(new URL("../../../server/db/migrations", import.meta.url)) });
}

async function main(): Promise<void> {
  const config = loadConfig(process.env);
  await runMigrations(config.databaseUrl);
  console.log("Migrations applied.");
}

main().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});
