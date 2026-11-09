// Tests for the login routes that are reachable over HTTP (docs/decisions/0022, 0028).
// Public sign-up and password recovery must stay closed in Phase 1.

import { describe, expect, it } from "vitest";
import { isAllowedAuthRoute } from "./auth-routes.js";

describe("isAllowedAuthRoute", () => {
  it("allows sign-in, sign-out and reading the session", () => {
    expect(isAllowedAuthRoute("POST", "/sign-in/email")).toBe(true);
    expect(isAllowedAuthRoute("POST", "/sign-out")).toBe(true);
    expect(isAllowedAuthRoute("GET", "/get-session")).toBe(true);
  });

  it("ignores a trailing slash", () => {
    expect(isAllowedAuthRoute("POST", "/sign-out/")).toBe(true);
  });

  it("refuses public sign-up", () => {
    expect(isAllowedAuthRoute("POST", "/sign-up/email")).toBe(false);
  });

  it("refuses password recovery and other login methods", () => {
    expect(isAllowedAuthRoute("POST", "/request-password-reset")).toBe(false);
    expect(isAllowedAuthRoute("POST", "/reset-password")).toBe(false);
    expect(isAllowedAuthRoute("GET", "/callback/google")).toBe(false);
  });

  it("refuses an allowed path with the wrong method", () => {
    expect(isAllowedAuthRoute("GET", "/sign-in/email")).toBe(false);
    expect(isAllowedAuthRoute("POST", "/get-session")).toBe(false);
  });
});
