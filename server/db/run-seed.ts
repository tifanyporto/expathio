// Command-line entry point for the seed. Run after migrations, with these variables set:
// DATABASE_URL, AUTH_SECRET and TEST_ACCOUNT_PASSWORD (at least 12 characters).
//
//   node dist/server/db/run-seed.js
//
// NOT RUN YET: it needs the PostgreSQL driver (see server/db/database.ts, entry Q-018).

import { createAuth } from "../auth/auth.js";
import { loadConfig } from "../config/config.js";
import { createDatabase } from "./database.js";
import { seed } from "./seed.js";

async function main(): Promise<void> {
  const config = loadConfig(process.env);
  const testPassword = process.env.TEST_ACCOUNT_PASSWORD;
  if (!testPassword || testPassword.length < 12) {
    throw new Error("TEST_ACCOUNT_PASSWORD is required and must have at least 12 characters.");
  }
  const db = createDatabase(config.databaseUrl);
  const auth = createAuth(db, { secret: config.authSecret, baseUrl: config.baseUrl });
  await seed(db, auth, testPassword);
  console.log("Seed finished: MONUMENT, four roles, their permissions and four test accounts.");
}

main().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});
