// Mounts the login routes on the Express application, but only the allowed ones
// (see auth-routes.ts). Other paths under /api/auth get a 404.

import type { NestExpressApplication } from "@nestjs/platform-express";
import type { NextFunction, Request, Response } from "express";
import { toNodeHandler } from "better-auth/node";
import type { Auth } from "./auth.js";
import { isAllowedAuthRoute } from "./auth-routes.js";

export function mountAuthRoutes(app: NestExpressApplication, auth: Auth): void {
  const handler = toNodeHandler(auth);

  app.use("/api/auth", (request: Request, response: Response, next: NextFunction) => {
    if (!isAllowedAuthRoute(request.method, request.path)) {
      response.status(404).json({ error: "not_found" });
      return;
    }
    Promise.resolve(handler(request, response)).catch(next);
  });
}
