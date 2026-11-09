// Business access rules for the four first-version business roles.
//
// Source of truth: docs/08-COMPANY.md, section 6.1 (approved 2026-11-06).
// Role titles: docs/decisions/0027-first-version-role-titles.md.
// Shared by the backend and, later, the frontend (docs/decisions/0019, section 5).
//
// This file holds data and pure functions only. It does not touch the database
// or the network. The backend enforces these rules on every request.

export const ROLE_KEYS = [
  "operations_assistant",
  "customer_service_representative",
  "sales_support_assistant",
  "finance_assistant",
] as const;

export type RoleKey = (typeof ROLE_KEYS)[number];

// The records that the permission table (section 6.1) talks about.
export const RESOURCES = [
  "stock_levels",
  "orders",
  "fulfillment_and_deliveries",
  "customer_cases",
  "customer_contact_history",
  "refund_or_exchange_requests",
  "payment_and_refund_ledger",
  "revenue_report",
  "sales_dashboard",
  "own_task_board_items",
  "internal_messages",
  "organization_documents",
  "session_summary",
] as const;

export type Resource = (typeof RESOURCES)[number];

// What a role may do with a resource, as written in section 6.1:
// - "change": can create and modify records of this type.
// - "read": can view, cannot change.
// - "request": can send a request that another role decides.
// - "decide": can view, and approve or reject requests from another role.
// - "none": no access.
export type Access = "change" | "read" | "request" | "decide" | "none";

// The actions the backend checks. Each one maps to the access levels that allow it.
export type Action = "read" | "change" | "request" | "decide";

export interface PermissionEntry {
  readonly access: Access;
  // True when the rule in section 6.1 limits the role to its own records
  // (for example, "own cases"). Record-level checks are built with the tool that owns the record.
  readonly ownRecordsOnly: boolean;
}

export interface RoleDefinition {
  readonly key: RoleKey;
  readonly title: string;
  readonly description: string;
  readonly permissions: Readonly<Record<Resource, PermissionEntry>>;
}

const none: PermissionEntry = { access: "none", ownRecordsOnly: false };
const entry = (access: Access, ownRecordsOnly = false): PermissionEntry => ({ access, ownRecordsOnly });

// Common tools that every role receives (section 5 and the common table in section 6.1).
const COMMON_PERMISSIONS = {
  own_task_board_items: entry("change", true),
  internal_messages: entry("change"),
  organization_documents: entry("read"),
  session_summary: entry("read"),
} as const;

const NO_BUSINESS_TOOLS = {
  stock_levels: none,
  orders: none,
  fulfillment_and_deliveries: none,
  customer_cases: none,
  customer_contact_history: none,
  refund_or_exchange_requests: none,
  payment_and_refund_ledger: none,
  revenue_report: none,
  sales_dashboard: entry("read"),
} as const;

export const ROLE_DEFINITIONS: Readonly<Record<RoleKey, RoleDefinition>> = {
  operations_assistant: {
    key: "operations_assistant",
    title: "Operations Assistant",
    description: "Stock levels, replenishment requests, fulfillment queue and deliveries.",
    permissions: {
      ...NO_BUSINESS_TOOLS,
      stock_levels: entry("change"),
      orders: entry("read"),
      fulfillment_and_deliveries: entry("change"),
      ...COMMON_PERMISSIONS,
    },
  },
  customer_service_representative: {
    key: "customer_service_representative",
    title: "Customer Service Representative",
    description: "Customer cases and contact history. Sends refund or exchange requests to Finance.",
    permissions: {
      ...NO_BUSINESS_TOOLS,
      orders: entry("read", true),
      customer_cases: entry("change", true),
      customer_contact_history: entry("read"),
      refund_or_exchange_requests: entry("request"),
      ...COMMON_PERMISSIONS,
    },
  },
  sales_support_assistant: {
    key: "sales_support_assistant",
    title: "Sales Support Assistant",
    description: "Order list and the read-only sales dashboard.",
    permissions: {
      ...NO_BUSINESS_TOOLS,
      orders: entry("read"),
      ...COMMON_PERMISSIONS,
    },
  },
  finance_assistant: {
    key: "finance_assistant",
    title: "Finance Assistant",
    description: "Payment and refund ledger, revenue report, and decisions on refund or exchange requests.",
    permissions: {
      ...NO_BUSINESS_TOOLS,
      orders: entry("read"),
      refund_or_exchange_requests: entry("decide"),
      payment_and_refund_ledger: entry("change"),
      revenue_report: entry("change"),
      ...COMMON_PERMISSIONS,
    },
  },
};

// Whether an access level allows an action.
// "read" is included in "change" and "decide", because both can also view the record.
export function accessAllows(access: Access, action: Action): boolean {
  switch (action) {
    case "read":
      return access === "read" || access === "change" || access === "decide";
    case "change":
      return access === "change";
    case "request":
      return access === "request";
    case "decide":
      return access === "decide";
  }
}

export function permissionFor(role: RoleKey, resource: Resource): PermissionEntry {
  return ROLE_DEFINITIONS[role].permissions[resource];
}

export function roleAllows(role: RoleKey, resource: Resource, action: Action): boolean {
  return accessAllows(permissionFor(role, resource).access, action);
}

export function isRoleKey(value: unknown): value is RoleKey {
  return typeof value === "string" && (ROLE_KEYS as readonly string[]).includes(value);
}
