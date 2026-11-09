// Runtime settings read from environment variables.
// Secrets never live in the repository (CLAUDE.md, section 11). A missing value stops
// the start with a clear message instead of using a silent default (CLAUDE.md, section 10).

export interface AppConfig {
  readonly port: number;
  readonly databaseUrl: string;
  // Secret used by better-auth to sign session data. Required.
  readonly authSecret: string;
  // Public address of the application. better-auth uses it to build links.
  readonly baseUrl: string;
}

export class ConfigError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "ConfigError";
  }
}

export function loadConfig(env: NodeJS.ProcessEnv): AppConfig {
  const databaseUrl = requireValue(env, "DATABASE_URL");
  const authSecret = requireValue(env, "AUTH_SECRET");
  if (authSecret.length < 32) {
    throw new ConfigError("AUTH_SECRET must have at least 32 characters.");
  }

  const port = parsePort(env.PORT ?? "3000");
  const baseUrl = env.BASE_URL ?? `http://localhost:${port}`;

  return { port, databaseUrl, authSecret, baseUrl };
}

function requireValue(env: NodeJS.ProcessEnv, name: string): string {
  const value = env[name];
  if (value === undefined || value.trim() === "") {
    throw new ConfigError(`Environment variable ${name} is required.`);
  }
  return value.trim();
}

export function parsePort(raw: string): number {
  const port = Number(raw);
  if (!Number.isInteger(port) || port < 1 || port > 65535) {
    throw new ConfigError(`PORT must be an integer between 1 and 65535, received "${raw}".`);
  }
  return port;
}
