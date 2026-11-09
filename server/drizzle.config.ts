// Configuration for drizzle-kit, the tool that writes migration files from schema.ts.
// It only generates SQL files. It does not connect to the database.

import { defineConfig } from "drizzle-kit";

export default defineConfig({
  dialect: "postgresql",
  schema: "./server/db/schema.ts",
  out: "./server/db/migrations",
});
