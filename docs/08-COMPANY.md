# Expathio — Initial Organization

**Status:** IN DISCUSSION  
**Document type:** Organization specification  
**Project:** Expathio

---

## 1. Purpose

This document defines the first simulated organization: its identity, its departments, the roles participants can occupy in the first version, the tools each role receives, and the vacancies participants apply to.

The organization is fictional. Its identity and catalog are chosen to keep the first version simple, and they can be changed without affecting the rules in this document.

## 2. Company Identity

- **Name:** MONUMENT.
- **Business:** a streetwear fashion brand (`02-BUSINESS-SIMULATION.md`, section 3). It sells primarily online to individual customers, and it has two physical stores at the start of the simulation.
- **Logo:** the name itself, written in a stylized typeface. The typeface is chosen in the company's visual specification, not in `09-DESIGN-SYSTEM.md`, which covers only the Expathio interface.
- **Market:** a single country and a single currency, shown as US dollars (USD) in the simulation.

## 3. Catalog and Pricing

The catalog has three categories.

| Category | Example products | List price range |
|---|---|---|
| Apparel (Vestuário) | T-shirts, hoodies, jackets, trousers | USD 25 to 250 |
| Footwear (Calçados) | Sneakers, boots, slides | USD 60 to 260 |
| Accessories (Acessórios) | Caps, bags, belts, socks | USD 15 to 120 |

Pricing rules for the first version:

- Each product has one fixed list price. Prices do not change during the simulation.
- The simulation does not apply discounts or promotions in the first version.
- Refunds and exchanges follow the rules in `02-BUSINESS-SIMULATION.md`.

Each product has a stock level for the online store and for each physical store. The Operations Assistant uses these levels to decide replenishment (section 5). Sales in the physical stores are recorded in the same order list as online orders.

## 4. Departments in the First Version

The organization has eight departments (`02-BUSINESS-SIMULATION.md`, section 4). In the first version, only four have participant roles. The others are run by simulated agents.

| Department | Participant role in version 1 | Notes |
|---|---|---|
| Operations and Logistics | Operations Assistant | Inventory, fulfillment and delivery |
| Customer Service | Customer Service Representative | Cases and refund or exchange requests |
| Commercial and Sales | Sales Support Assistant | Orders and sales reporting |
| Finance | Finance Assistant | Payments and refunds |
| Executive Management | None | Simulated by a manager agent |
| Technology | None | Simulated; the development workflow is deferred (`docs/decisions/0002-developer-workflow.md`) |
| Marketing | None | Simulated; deferred to a later phase |
| Product and Design | None | Simulated; deferred to a later phase |

## 5. Tools by Role

Every participant role receives these common tools:

- **Task board:** tasks assigned to the role.
- **Internal messages:** asynchronous, with no real-time chat.
- **Organization documents:** announcements and reference material.
- **Session summary:** the events since the participant's last session (`docs/decisions/0008-participation-sessions.md`).

Role-specific tools:

| Role | Tools |
|---|---|
| Operations Assistant | Inventory (view and replenishment requests); fulfillment queue (packing and shipping); delivery tracking |
| Customer Service Representative | Case queue with each customer's contact history; refund or exchange requests, sent to Finance |
| Sales Support Assistant | Order list; sales dashboard (read-only) |
| Finance Assistant | Payment and refund ledger; revenue report |

Each tool shows only the data its role may see and act on (`01-PRODUCT.md`, section 3.5).

## 6. Access Rules

- A role can change only the records it owns. Other records are read-only.
- Sales dashboards are read-only for every role.
- No tool connects to an external service in the first version (`docs/decisions/0009-first-version-tools-and-roles.md`).

### 6.1 Permissions by Role (APPROVED)

Status: APPROVED by the owner on 2026-11-06. The refund row follows `docs/decisions/0025-refund-decision-by-financial-analyst.md`. The backend enforces these rules (`CLAUDE.md`, section 10; `docs/decisions/0024-phase-1-business-roles-loaded.md`).

Key: **Change** = can create and modify records of this type. **Read** = can view, cannot change. **Request** = can send a request that another role decides. **—** = no access.

| Record | Operations Assistant | Customer Service Representative | Sales Support Assistant | Finance Assistant |
|---|---|---|---|---|
| Stock levels (per location) | Change (replenishment requests) | — | — | — |
| Orders | Read | Read (only the customer's own orders, for a case) | Read | Read |
| Fulfillment queue and deliveries | Change | — | — | — |
| Customer cases | — | Change (own cases) | — | — |
| Customer contact history | — | Read | — | — |
| Refund or exchange requests | — | Request (sent to Finance) | — | Read; approves or rejects (ADR 0025) |
| Payment and refund ledger | — | — | — | Change |
| Revenue report | — | — | — | Change |
| Sales dashboard | Read | Read | Read | Read |

Common to all roles:

| Record | Access |
|---|---|
| Own tasks on the task board | Change (status and notes) |
| Internal messages | Send and read, for their own role |
| Organization documents | Read |
| Session summary | Read, for their own role |

Refund and exchange requests are approved or rejected by the Finance Assistant (`docs/decisions/0025-refund-decision-by-financial-analyst.md`).

## 7. Vacancies

Participants apply to predefined vacancies (`docs/decisions/0005-admission-model.md`). Each participant role has one occupant (`docs/decisions/0007-first-version-participant-rules.md`), so each role has one vacancy at a time. When a role is filled, its vacancy closes. When the occupant leaves, the role returns to the simulation and a new vacancy opens.

Every vacancy reports to the simulated manager agent of its department.

### 7.1 Operations Assistant

- **Responsibilities:** keep stock levels in line with orders, send replenishment requests, prioritize the fulfillment queue, and track each delivery until it reaches the customer.
- **Experience:** none required. Warehouse or logistics routines are a plus.

### 7.2 Customer Service Representative

- **Responsibilities:** answer customer cases, review each customer's contact history, and send refund or exchange requests to Finance when a case needs one.
- **Experience:** none required. Clear written communication is the main skill.

### 7.3 Sales Support Assistant

- **Responsibilities:** monitor the order list, analyze the sales dashboard, and report orders at risk to the manager.
- **Experience:** none required. Spreadsheet skills are a plus.

### 7.4 Finance Assistant

- **Responsibilities:** keep the payment and refund ledger accurate, prepare the revenue report, and review refund requests from Customer Service.
- **Experience:** none required. Basic accounting concepts are a plus.

## 8. Out of Scope for the First Version

- Marketing, Product and Design roles.
- Development tools for Technology roles.
- Executive roles held by participants.
- Connection to external services of any kind.
- Discounts, promotions and changing prices.

## 9. Adding a Role (APPROVED)

Status: APPROVED by the owner on 2026-11-06. The open technical question at the end of this section is for Architecture and Quality, not yet decided.

A role is a set of functions. A function is a capability of the platform, such as the inventory view or the refund request. Adding a role means choosing its functions. Some functions may already exist; others may need to be built first.

There are two kinds of addition:

- **A. Role from existing functions.** Every function the role needs already exists. The addition is a configuration: name, department, responsibilities, functions and permissions (section 6.1). Owner approval is required.
- **B. Role that needs new functions.** At least one function does not exist yet. Each new function is a feature and follows the phase process: Product defines what it does and which records it uses; Architecture and Quality assess the technical impact; Platform and Frontend Engineering build it with tests; it is activated in the phase that needs it. The role is added after its functions exist.

Steps for both kinds:

1. **Role card.** Name, department, responsibilities, functions, permissions, and experience required (none, for entry roles).
2. **Department fit.** The department exists in section 4, or is added first, with its effect on `02-BUSINESS-SIMULATION.md`, section 4, reviewed.
3. **Function check.** Each function is in the function catalog, or is a new function to be specified first (kind B).
4. **Permission matrix.** The role is added to section 6.1.
5. **Owner approval.** The owner approves the role card and its permissions. No role is added without approval.
6. **Decision record.** If the addition changes an approved decision, such as ADR 0009, a new ADR records it.
7. **Tests.** The role's permissions are tested (ADR 0024).
8. **Activation.** The role appears only in the phase that needs it.

Rules:

- Roles and functions are added by the owner. Participants and AI agents cannot add them.
- Permissions are enforced by the backend, not by hiding a role's screens (`CLAUDE.md`, section 10).
- A function is reused across roles wherever possible. It is not built for one role only unless the owner decides so.

Open technical question for Architecture and Quality: functions are built in code, so a kind B addition requires a code change. Whether a kind A addition can be made without a code change (roles stored as data) is still open. Product recommends it, but only for kind A. The decision belongs to Architecture and Quality, in a new ADR, after owner approval.

The function catalog (the list of existing functions, with the records each one uses and the roles that use it) does not exist yet. It is created when the first Phase 1 functions are specified.

## 10. Revision Proposal for a Newly Founded Company (PROPOSED)

Status: PROPOSED. Nothing in this section changes sections 1 to 9 until the owner approves it. Owner approval is required because it changes approved decisions (`docs/decisions/0009-first-version-tools-and-roles.md`, `0017-physical-stores-in-first-release.md`, `0027-first-version-role-titles.md`).

### 10.1 Context

MONUMENT is being founded now, in the simulation's first state. The owner decided that the first physical store opens alone: one physical store instead of two. The owner also asked whether the four participant roles fit a newly founded company with one store.

### 10.2 Store count

Alternatives:

1. **Keep two stores.** No change. The current decision stays in force.
2. **One physical store, online store kept.** Chosen by the owner for the first opening (this proposal assumes it).

Consequence: the stock model does not change. Stock is still tracked per location (`02`, section 6.3), and there are two locations: the online store and the physical store. Only the number of physical stores changes. The data model must still allow more than one physical store, because the owner may open more later.

Documents that would change if approved: `02-BUSINESS-SIMULATION.md`, section 3 (two stores); this document, section 2 (two stores); `docs/CURRENT_STATE.md`, approved decision `0017`. Decision `0017` needs a new ADR that replaces the store count.

### 10.3 Participant roles

Alternatives:

1. **Keep four roles** (Operations Assistant, Customer Service Representative, Sales Support Assistant, Finance Assistant). Smallest change. Sales Support's order monitoring and sales dashboard are separate from Operations, although one store makes that split small.
2. **Three roles: merge Sales Support into Operations.** Order monitoring and "orders at risk" go to the Operations Assistant. The sales dashboard becomes part of the Finance Assistant's revenue report. Fewer roles to fill, which suits a newly founded company. Changes the permission matrix in section 6.1 (approved), so it needs a new approval.
3. **Four roles plus a store role.** Adds a role for store staff. Not recommended for Phase 1, because store operations (sales at the counter, store stock) are not in the Phase 1 scope or the Phase 3 workflows.

Recommendation: option 2 for the first version, so the platform starts with the functions a newly founded company uses most. Option 2 needs the function catalog (`docs/OPEN-QUESTIONS.md`, Q-013) to be built with the new role list in mind. Adding roles later stays possible under section 9.

### 10.4 What a newly founded company needs first

The owner asked which functions matter most at founding. The Product proposal, for the owner to confirm:

- Stock per location, and replenishment requests (Operations).
- Orders from both channels, in one list (Operations, with Finance for payment).
- Customer cases and refund or exchange requests (Customer Service, decided by Finance under ADR 0025).
- Payment and refund ledger, and a revenue report (Finance).
- Monitoring of orders at risk (Operations under option 2).

Marketing, Product and Design, Technology and Executive Management remain simulated (section 4), as they are now.

### 10.5 Decisions the owner needs to make

1. Store count: one physical store (proposal) or two.
2. Role set: option 1, 2 or 3 in section 10.3.
3. Whether the revised roles change the approved permission matrix (section 6.1). If option 2 is chosen, the matrix is revised and approved again.

Open question: `docs/OPEN-QUESTIONS.md`, Q-040.

### 10.6 Membership history (decided by the owner, 2026-11-17)

These rules are owner decisions and are recorded here so that the membership model and the career rules (`07-PROGRESSION-AND-REWARDS.md`) refer to the same text:

- An account holds one role at a time in one organization.
- An account belongs to one organization at a time. Changing organization ends the active membership, and the previous membership stays in the history.
- Each role has one active occupant per organization (`docs/decisions/0007-first-version-participant-rules.md`).
- Membership history is kept from Phase 1. It records the start and end date of each membership, and it is the basis for promotions, changes of company and, later, the weight of each company in a career.

Source: owner answers to Q-027, Q-032 and Q-041 (`docs/OPEN-QUESTIONS.md`).

### 10.7 Direction for the first version (owner, 2026-11-17)

The owner accepted the following reading for the founding stage. It is a direction, not yet a formal decision: the formal decisions on roles and stores stay open in Q-040.

- **Production:** outsourced to contract manufacturers. No in-house production role in the first version.
- **Product and Design:** stays simulated (section 4).
- **Physical space and people (hiring, payroll):** outside the first version for now.
- **Purchasing:** inside Operations, not a separate role.

The owner also noted that MONUMENT is expected to grow. Departments and roles that are left out now may be needed later. When the company grows, the role set must be reviewed under section 9.
