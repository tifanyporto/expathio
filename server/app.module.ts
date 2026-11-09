// Root module of the NestJS application. Its dependencies (settings, database and login)
// are created in server/main.ts and passed in here, so each one is built once.

import { Module, type DynamicModule } from "@nestjs/common";
import type { AppConfig } from "./config/config.js";
import type { Auth } from "./auth/auth.js";
import { AUTH_INSTANCE } from "./auth/tokens.js";
import { MeController } from "./me/me.controller.js";
import { DATABASE, type Database } from "./db/database.js";

export interface AppDependencies {
  readonly config: AppConfig;
  readonly db: Database;
  readonly auth: Auth;
}

@Module({})
export class AppModule {
  static register(dependencies: AppDependencies): DynamicModule {
    return {
      module: AppModule,
      controllers: [MeController],
      providers: [
        { provide: DATABASE, useValue: dependencies.db },
        { provide: AUTH_INSTANCE, useValue: dependencies.auth },
      ],
    };
  }
}
