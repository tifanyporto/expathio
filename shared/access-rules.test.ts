// Business-rule tests for the permission table in docs/08-COMPANY.md, section 6.1.
// Each expectation below comes from that table, not from the code.

import { describe, expect, it } from "vitest";
import {
  RESOURCES,
  ROLE_DEFINITIONS,
  ROLE_KEYS,
  accessAllows,
  roleAllows,
  permissionFor,
  isRoleKey,
} from "./access-rules.js";

describe("business role catalog", () => {
  it("uses the four first-version titles from ADR 0027", () => {
    expect(ROLE_KEYS.map((key) => ROLE_DEFINITIONS[key].title)).toEqual([
      "Operations Assistant",
      "Customer Service Representative",
      "Sales Support Assistant",
      "Finance Assistant",
    ]);
  });

  it("defines a permission for every role and every resource", () => {
    for (const roleKey of ROLE_KEYS) {
      for (const resource of RESOURCES) {
        expect(permissionFor(roleKey, resource), `${roleKey} / ${resource}`).toBeDefined();
      }
    }
  });

  it("recognises only the four role keys", () => {
    expect(isRoleKey("finance_assistant")).toBe(true);
    expect(isRoleKey("admin")).toBe(false);
    expect(isRoleKey(undefined)).toBe(false);
  });
});

describe("Operations Assistant", () => {
  it("can change stock levels and fulfillment, and read orders", () => {
    expect(roleAllows("operations_assistant", "stock_levels", "change")).toBe(true);
    expect(roleAllows("operations_assistant", "fulfillment_and_deliveries", "change")).toBe(true);
    expect(roleAllows("operations_assistant", "orders", "read")).toBe(true);
    expect(roleAllows("operations_assistant", "orders", "change")).toBe(false);
  });

  it("has no access to customer cases or the payment ledger", () => {
    expect(roleAllows("operations_assistant", "customer_cases", "read")).toBe(false);
    expect(roleAllows("operations_assistant", "payment_and_refund_ledger", "read")).toBe(false);
  });
});

describe("Customer Service Representative", () => {
  it("changes only its own customer cases", () => {
    expect(roleAllows("customer_service_representative", "customer_cases", "change")).toBe(true);
    expect(permissionFor("customer_service_representative", "customer_cases").ownRecordsOnly).toBe(true);
  });

  it("sends refund and exchange requests but cannot decide them", () => {
    expect(roleAllows("customer_service_representative", "refund_or_exchange_requests", "request")).toBe(true);
    expect(roleAllows("customer_service_representative", "refund_or_exchange_requests", "decide")).toBe(false);
    expect(roleAllows("customer_service_representative", "refund_or_exchange_requests", "read")).toBe(false);
  });

  it("reads orders only for its own customers' cases", () => {
    expect(roleAllows("customer_service_representative", "orders", "read")).toBe(true);
    expect(permissionFor("customer_service_representative", "orders").ownRecordsOnly).toBe(true);
  });

  it("has no access to stock or the payment ledger", () => {
    expect(roleAllows("customer_service_representative", "stock_levels", "read")).toBe(false);
    expect(roleAllows("customer_service_representative", "payment_and_refund_ledger", "read")).toBe(false);
  });
});

describe("Sales Support Assistant", () => {
  it("reads orders and the sales dashboard, and changes no order", () => {
    expect(roleAllows("sales_support_assistant", "orders", "read")).toBe(true);
    expect(roleAllows("sales_support_assistant", "orders", "change")).toBe(false);
    expect(roleAllows("sales_support_assistant", "sales_dashboard", "read")).toBe(true);
  });

  it("cannot change any business record", () => {
    const businessResources = RESOURCES.filter(
      (resource) => !["own_task_board_items", "internal_messages"].includes(resource),
    );
    for (const resource of businessResources) {
      expect(roleAllows("sales_support_assistant", resource, "change"), resource).toBe(false);
    }
  });
});

describe("Finance Assistant", () => {
  it("decides refund and exchange requests", () => {
    expect(roleAllows("finance_assistant", "refund_or_exchange_requests", "decide")).toBe(true);
    expect(roleAllows("finance_assistant", "refund_or_exchange_requests", "read")).toBe(true);
  });

  it("changes the payment ledger and the revenue report", () => {
    expect(roleAllows("finance_assistant", "payment_and_refund_ledger", "change")).toBe(true);
    expect(roleAllows("finance_assistant", "revenue_report", "change")).toBe(true);
  });

  it("cannot change stock", () => {
    expect(roleAllows("finance_assistant", "stock_levels", "change")).toBe(false);
  });
});

describe("rules that apply to every role", () => {
  it("can change its own task-board items and send internal messages", () => {
    for (const roleKey of ROLE_KEYS) {
      expect(roleAllows(roleKey, "own_task_board_items", "change"), roleKey).toBe(true);
      expect(roleAllows(roleKey, "internal_messages", "change"), roleKey).toBe(true);
    }
  });

  it("reads the sales dashboard and organization documents, and never changes the dashboard", () => {
    for (const roleKey of ROLE_KEYS) {
      expect(roleAllows(roleKey, "sales_dashboard", "read"), roleKey).toBe(true);
      expect(roleAllows(roleKey, "sales_dashboard", "change"), roleKey).toBe(false);
      expect(roleAllows(roleKey, "organization_documents", "read"), roleKey).toBe(true);
    }
  });
});

describe("accessAllows", () => {
  it("treats change and decide as including read, and request as separate", () => {
    expect(accessAllows("change", "read")).toBe(true);
    expect(accessAllows("decide", "read")).toBe(true);
    expect(accessAllows("request", "read")).toBe(false);
    expect(accessAllows("read", "change")).toBe(false);
    expect(accessAllows("none", "read")).toBe(false);
  });
});
