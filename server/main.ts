// Application start. Reads settings, opens the database, creates the login instance,
// and starts the HTTP server on PORT.
//
// BLOCKED for now: createDatabase stops with an error until the PostgreSQL driver is approved
// (see server/db/database.ts and docs/OPEN-QUESTIONS.md, Q-018).

import "reflect-metadata";
import { NestFactory } from "@nestjs/core";
import type { NestExpressApplication } from "@nestjs/platform-express";
import { createAuth } from "./auth/auth.js";
import { mountAuthRoutes } from "./auth/mount-auth.js";
import { loadConfig } from "./config/config.js";
import { createDatabase } from "./db/database.js";
import { AppModule } from "./app.module.js";

async function bootstrap(): Promise<void> {
  const config = loadConfig(process.env);
  const db = createDatabase(config.databaseUrl);
  const auth = createAuth(db, { secret: config.authSecret, baseUrl: config.baseUrl });

  // bodyParser is off so that the login routes read their own request body.
  // JSON parsing is turned on below, for the application's own routes.
  const app = await NestFactory.create<NestExpressApplication>(AppModule.register({ config, db, auth }), {
    bodyParser: false,
  });
  mountAuthRoutes(app, auth);
  app.useBodyParser("json");

  await app.listen(config.port);
  console.log(`Expathio backend listening on port ${config.port}.`);
}

bootstrap().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});
