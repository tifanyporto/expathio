// Organization membership and access checks. Pure functions: no database and no HTTP.
// The database layer loads the membership rows and passes them here.
//
// Isolation rule (docs/decisions/0010, item 1): a membership grants access only inside
// the organization it belongs to. A check always names the organization it is about.

import { roleAllows, type Action, type Resource, type RoleKey } from "../../shared/access-rules.js";

export interface MembershipRecord {
  readonly organizationId: string;
  readonly userId: string;
  readonly roleKey: RoleKey;
}

export class AccessDeniedError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "AccessDeniedError";
  }
}

// Returns the membership of a user in one organization, or undefined.
// Both the user and the organization must match, so a membership elsewhere never counts.
export function findMembership(
  memberships: readonly MembershipRecord[],
  userId: string,
  organizationId: string,
): MembershipRecord | undefined {
  return memberships.find((m) => m.userId === userId && m.organizationId === organizationId);
}

// Stops with AccessDeniedError unless the user's role in the organization allows the action.
// Returns the membership when the check passes, so the caller can use the role.
export function authorize(
  memberships: readonly MembershipRecord[],
  userId: string,
  organizationId: string,
  resource: Resource,
  action: Action,
): MembershipRecord {
  const membership = findMembership(memberships, userId, organizationId);
  if (!membership) {
    throw new AccessDeniedError("The user is not a member of this organization.");
  }
  if (!roleAllows(membership.roleKey, resource, action)) {
    throw new AccessDeniedError(`The role ${membership.roleKey} may not ${action} ${resource}.`);
  }
  return membership;
}
