// GET /api/me: the signed-in account, with its memberships in organizations.
// The post-login page (docs/decisions/0028, decision 2) reads this.
//
// Data isolation: the query returns only the memberships of the signed-in account.
// Nothing here lists other accounts or other organizations' members.

import { Controller, Get, Inject, Req, UnauthorizedException } from "@nestjs/common";
import { eq } from "drizzle-orm";
import { fromNodeHeaders } from "better-auth/node";
import type { Request } from "express";
import { AUTH_INSTANCE } from "../auth/tokens.js";
import type { Auth } from "../auth/auth.js";
import { DATABASE, type Database } from "../db/database.js";
import * as schema from "../db/schema.js";

export interface MeResponse {
  readonly account: { readonly id: string; readonly name: string; readonly email: string };
  readonly memberships: readonly {
    readonly organization: { readonly id: string; readonly name: string };
    readonly role: { readonly key: string; readonly title: string };
  }[];
  // Every Phase 1 account is a test account, so the interface must label the data as simulated.
  readonly simulated: true;
}

@Controller("api/me")
export class MeController {
  constructor(
    @Inject(AUTH_INSTANCE) private readonly auth: Auth,
    @Inject(DATABASE) private readonly db: Database,
  ) {}

  @Get()
  async me(@Req() request: Request): Promise<MeResponse> {
    const session = await this.auth.api.getSession({ headers: fromNodeHeaders(request.headers) });
    if (!session) {
      throw new UnauthorizedException("Sign in is required.");
    }

    const rows = await this.db
      .select({
        organizationId: schema.organizations.id,
        organizationName: schema.organizations.name,
        roleKey: schema.roles.key,
        roleTitle: schema.roles.title,
      })
      .from(schema.memberships)
      .innerJoin(schema.organizations, eq(schema.memberships.organizationId, schema.organizations.id))
      .innerJoin(schema.roles, eq(schema.memberships.roleKey, schema.roles.key))
      .where(eq(schema.memberships.userId, session.user.id));

    return {
      account: { id: session.user.id, name: session.user.name, email: session.user.email },
      memberships: rows.map((row) => ({
        organization: { id: row.organizationId, name: row.organizationName },
        role: { key: row.roleKey, title: row.roleTitle },
      })),
      simulated: true,
    };
  }
}
