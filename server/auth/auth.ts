// Login setup with better-auth (docs/decisions/0014).
//
// - E-mail and password login (docs/decisions/0028). Account data is stored in our
//   own database through the Drizzle adapter (see server/db/schema.ts).
// - Public sign-up is blocked at the HTTP layer (see server/auth/auth-routes.ts).
//   Test accounts are created by the seed, which calls the library on the server side
//   (docs/decisions/0022).
// - No password recovery in Phase 1 (docs/decisions/0028, decision 3).

import { betterAuth } from "better-auth";
import { drizzleAdapter } from "better-auth/adapters/drizzle";
import type { Database } from "../db/database.js";
import * as schema from "../db/schema.js";

export interface AuthSettings {
  readonly secret: string;
  readonly baseUrl: string;
}

export function createAuth(db: Database, settings: AuthSettings) {
  return betterAuth({
    secret: settings.secret,
    baseURL: settings.baseUrl,
    basePath: "/api/auth",
    database: drizzleAdapter(db, {
      provider: "pg",
      schema: {
        user: schema.user,
        session: schema.session,
        account: schema.account,
        verification: schema.verification,
      },
    }),
    emailAndPassword: {
      enabled: true,
      // Kept enabled so the seed can create test accounts on the server side.
      // The HTTP routes for sign-up are not exposed (auth-routes.ts).
      disableSignUp: false,
      autoSignIn: false,
      requireEmailVerification: false,
    },
  });
}

export type Auth = ReturnType<typeof createAuth>;
