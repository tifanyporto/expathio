// Which login endpoints are reachable over HTTP in Phase 1.
//
// better-auth provides many endpoints (sign-up, password reset, social login...).
// Phase 1 only needs sign-in, sign-out and reading the current session (docs/06-ROADMAP.md,
// section 4, item 4). Everything else is refused, so that public sign-up and password
// recovery stay closed until their own decisions exist (docs/decisions/0022, 0028).

export interface AllowedRoute {
  readonly method: "GET" | "POST";
  readonly path: string;
}

export const ALLOWED_AUTH_ROUTES: readonly AllowedRoute[] = [
  { method: "POST", path: "/sign-in/email" },
  { method: "POST", path: "/sign-out" },
  { method: "GET", path: "/get-session" },
];

// `path` is the part after /api/auth, for example "/sign-in/email". Trailing slashes are ignored.
export function isAllowedAuthRoute(method: string, path: string): boolean {
  const normalizedPath = path.length > 1 && path.endsWith("/") ? path.slice(0, -1) : path;
  return ALLOWED_AUTH_ROUTES.some((route) => route.method === method && route.path === normalizedPath);
}
