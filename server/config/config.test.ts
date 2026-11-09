// Tests for reading settings from environment variables. A missing or invalid value must stop the start.

import { describe, expect, it } from "vitest";
import { ConfigError, loadConfig, parsePort } from "./config.js";

const VALID_SECRET = "x".repeat(32);

describe("loadConfig", () => {
  it("reads the required values and builds a default base address", () => {
    const config = loadConfig({ DATABASE_URL: "postgres://localhost/db", AUTH_SECRET: VALID_SECRET });
    expect(config.port).toBe(3000);
    expect(config.baseUrl).toBe("http://localhost:3000");
  });

  it("stops when DATABASE_URL is missing", () => {
    expect(() => loadConfig({ AUTH_SECRET: VALID_SECRET })).toThrow(ConfigError);
  });

  it("stops when AUTH_SECRET is shorter than 32 characters", () => {
    expect(() => loadConfig({ DATABASE_URL: "postgres://localhost/db", AUTH_SECRET: "short" })).toThrow(
      /at least 32/,
    );
  });
});

describe("parsePort", () => {
  it("accepts a port between 1 and 65535", () => {
    expect(parsePort("8080")).toBe(8080);
  });

  it("refuses values that are not a port", () => {
    expect(() => parsePort("0")).toThrow(ConfigError);
    expect(() => parsePort("70000")).toThrow(ConfigError);
    expect(() => parsePort("abc")).toThrow(ConfigError);
  });
});
