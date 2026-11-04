# Expathio — Business Simulation

**Status:** IN DISCUSSION  
**Document type:** Business simulation specification  
**Project:** Expathio

---

## 1. Purpose

This document defines how simulated organizations operate, evolve and interact with their environments within Expathio.

The objective is to create business environments that behave coherently, generate their own activities and preserve organizational continuity independently of participant interaction.

The simulated company must not behave like a static collection of screens, records and predefined exercises.

It must operate as an interconnected business environment where customers have needs, employees have responsibilities, departments perform activities and decisions produce consequences.

The simulation should create situations that require participants to investigate, communicate, make decisions and perform meaningful professional work.

## 2. Fundamental Principles

The business simulation must follow these principles. The project-wide design principles are in `00-VISION.md`, section 8; the list below applies them to the simulation.

### 2.1 Organizational independence

The company must continue operating even when no human participant is active.

Its customers, employees, operations and business processes should continue evolving according to the simulation rules.

### 2.2 Causal consistency

Events must have understandable causes and consequences.

A marketing campaign can increase demand. Increased demand can reduce inventory. Reduced inventory can delay orders. Delayed orders can generate customer complaints.

The simulation should preserve these relationships.

### 2.3 Persistent state

The company must retain its relevant operational and historical state.

Customers should remember previous experiences. Orders should preserve their history. Employees should retain relevant work records. Business decisions should remain traceable.

### 2.4 Controlled unpredictability

The organization should produce unexpected situations, but unpredictability must not mean arbitrary behavior.

Randomness should operate within coherent business rules and contextual constraints.

### 2.5 Interconnected operations

Departments should depend on one another.

Business processes must cross departmental boundaries when appropriate.

### 2.6 Progressive complexity

The simulation should begin with a manageable set of processes and gradually evolve toward more sophisticated organizational behavior.

---

## 3. Initial Business Environment

The first organization simulated by Expathio will be a fictional streetwear fashion brand operating primarily through B2C e-commerce, with two physical stores (`docs/decisions/0017-physical-stores-in-first-release.md`).

The company will have a recognizable identity, products, collections, customers, suppliers, employees and business objectives.

Its commercial operation will provide the initial foundation for the simulation.

The organization should have realistic business needs involving sales, inventory, marketing, logistics, customer service, finance, management and technology.

Detailed company identity, catalog, pricing and business rules will be defined separately.

## 4. Organizational Structure

The company should be modeled as a collection of interconnected departments with distinct responsibilities.

The initial conceptual departments are listed below. The reference list for the initial organization is defined in `08-COMPANY.md`.

### 4.1 Executive Management

Responsible for the overall direction of the organization.

Activities may include:

- Defining business objectives.
- Evaluating performance.
- Making strategic decisions.
- Prioritizing investments.
- Resolving departmental conflicts.
- Approving important initiatives.

### 4.2 Technology

Responsible for the systems and technical infrastructure that support the business.

Activities may include:

- Application development.
- System maintenance.
- Integrations.
- Infrastructure management.
- Security.
- Data management.
- Technical incident resolution.

### 4.3 Marketing

Responsible for positioning, communication and demand generation.

Activities may include:

- Campaign planning.
- Content creation.
- Brand positioning.
- Customer acquisition.
- Campaign performance analysis.
- Market research.

### 4.4 Product and Design

Responsible for the products and collections offered by the company.

Activities may include:

- Product development.
- Collection planning.
- Design decisions.
- Product specifications.
- Product launches.
- Product performance analysis.

### 4.5 Commercial and Sales

Responsible for commercial performance.

Activities may include:

- Sales monitoring.
- Conversion analysis.
- Commercial initiatives.
- Pricing recommendations.
- Revenue objectives.
- Customer purchasing behavior analysis.

### 4.6 Operations and Logistics

Responsible for physical product movement and order fulfillment.

Activities may include:

- Inventory control.
- Order separation.
- Packaging.
- Shipping.
- Supplier coordination.
- Delivery monitoring.
- Returns processing.

### 4.7 Finance

Responsible for the organization's financial health.

Activities may include:

- Revenue monitoring.
- Expense management.
- Payment reconciliation.
- Refund processing.
- Cash flow.
- Financial reporting.
- Budget control.

### 4.8 Customer Service

Responsible for customer relationships and after-sales activities.

Activities may include:

- Customer inquiries.
- Complaints.
- Exchanges.
- Returns.
- Refund requests.
- Delivery problems.
- Product-related questions.
- Customer satisfaction monitoring.

The final structure may evolve as the organization becomes more sophisticated.

Departments should not be treated as isolated systems. Their responsibilities and interactions must be represented through business processes.

## 5. Customers and Market Behavior

Customers are a fundamental part of the simulation.

They should not exist only as records created when a participant manually registers an order.

The simulated market must generate customer activity independently.

### 5.1 Customer Profiles

Each customer should have a structured profile containing relevant characteristics such as:

- Identity.
- Demographic attributes where appropriate.
- Purchasing preferences.
- Product interests.
- Budget or spending capacity.
- Purchase history.
- Interaction history.
- Satisfaction history.
- Brand loyalty.
- Communication preferences.

Customer profiles should influence behavior rather than merely provide descriptive information.

### 5.2 Customer Intentions

Customers should have different motivations and intentions.

Examples include:

- Discovering new products.
- Looking for specific items.
- Waiting for a product restock.
- Comparing prices.
- Searching for promotions.
- Making spontaneous purchases.
- Abandoning a cart.
- Asking questions before purchasing.
- Requesting exchanges.
- Reporting problems.
- Complaining about previous experiences.

These intentions should emerge from customer characteristics, business conditions and previous interactions.

### 5.3 Customer Memory

Customer behavior should be influenced by previous experiences.

Examples:

- A customer who received a defective product may become more cautious.
- A customer who received excellent support may become more loyal.
- A customer who experienced repeated delivery problems may stop purchasing.
- A customer who frequently buys a particular product category may be more interested in new collections.

Customer history must influence future interactions and decisions.

### 5.4 Complaints and Dissatisfaction

Complaints are an essential part of the simulation.

They must not be treated as secondary or optional events.

Customers may complain about:

- Product quality.
- Incorrect orders.
- Delivery delays.
- Damaged packaging.
- Payment problems.
- Poor customer service.
- Difficult return processes.
- Misleading product descriptions.
- Differences between expectations and actual products.

A complaint should generate an operational case with a history, status, responsible department and expected resolution.

The quality of the resolution should influence the customer's future relationship with the company.

Unresolved or poorly handled complaints may lead to repeated dissatisfaction, negative reviews, lost customers or other business consequences.

## 6. Core Business Processes

The initial organization should simulate interconnected commercial processes.

### 6.1 Product Lifecycle

Products should move through a lifecycle involving development, registration, availability, sales and eventual discontinuation.

Relevant activities may include:

- Product creation.
- Product specification.
- Pricing.
- Collection assignment.
- Inventory registration.
- Product publication.
- Sales monitoring.
- Restocking.
- Discontinuation.

### 6.2 Sales and Orders

The company should generate and process orders through its e-commerce operation and through its physical stores. A store sale is an order with the store as its point of sale. Online and store orders are recorded in the same order list.

The order lifecycle may involve:

1. Product discovery.
2. Shopping cart.
3. Checkout.
4. Payment processing.
5. Order confirmation.
6. Order preparation.
7. Shipment.
8. Delivery.
9. Possible after-sales interaction.

Orders must preserve their status and historical transitions.

### 6.3 Inventory

Inventory must reflect the actual operational state of products.

Relevant events include:

- Stock reservations.
- Stock reductions.
- Restocking.
- Inventory discrepancies.
- Damaged products.
- Returned items.
- Stock shortages.

Inventory changes must affect sales availability and operational decisions.

Stock is tracked per location: the online store and each physical store have their own stock levels (`docs/decisions/0017-physical-stores-in-first-release.md`).

### 6.4 Logistics

Logistics should connect orders, inventory, shipping and customer experience.

Relevant situations include:

- Preparation delays.
- Shipping delays.
- Lost shipments.
- Damaged packages.
- Incorrect deliveries.
- Delivery confirmation.
- Return shipments.

Logistics problems should have consequences for customer satisfaction and business performance.

### 6.5 Customer Service and After-Sales

Customer service should handle cases generated by actual business interactions.

Cases should have:

- Customer reference.
- Related order or product when applicable.
- Reason for contact.
- Priority.
- Responsible employee or department.
- Status.
- Interaction history.
- Resolution.
- Customer satisfaction outcome.

The simulation should support situations where a resolution requires cooperation between multiple departments.

### 6.6 Financial Operations

Financial records should reflect the company's business activity.

Relevant operations include:

- Sales revenue.
- Payment fees.
- Operational expenses.
- Supplier payments.
- Refunds.
- Shipping costs.
- Marketing expenses.
- Payroll.
- Financial adjustments.

Financial information should be consistent with the underlying operational records.

## 7. Business Events

The organization should be driven by events that represent meaningful changes or occurrences.

Events may originate from:

- Customer behavior.
- Employee actions.
- Business processes.
- External market conditions.
- Scheduled activities.
- Unexpected operational situations.
- Participant decisions.

Examples include:

- A new order is placed.
- A customer submits a complaint.
- A product reaches a stock threshold.
- A delivery is delayed.
- A campaign exceeds its expected demand.
- A supplier fails to deliver.
- An employee identifies a recurring problem.
- A system integration becomes unavailable.

Events should be recorded and should trigger the appropriate processes or notifications.

The simulation must distinguish between events that merely record something that happened and events that require an action.

## 8. Interdepartmental Dependencies

The departments must influence one another through explicit business relationships.

Examples:

**Marketing and Operations**

A successful campaign increases demand and may create inventory or fulfillment constraints.

**Sales and Finance**

Sales activity affects revenue, payment reconciliation and financial reporting.

**Operations and Customer Service**

Delivery problems generate customer inquiries and complaints.

**Technology and Business Operations**

System failures can affect orders, payments, inventory and customer experience.

**Product and Marketing**

New collections and product specifications influence campaigns and customer demand.

**Finance and Management**

Financial performance influences budgets, investments and strategic decisions.

These relationships should be modeled explicitly rather than simulated through disconnected narrative events.

## 9. Employee Activity

Simulated employees should have responsibilities within the organizational structure.

They may:

- Perform assigned activities.
- Monitor relevant indicators.
- Identify operational problems.
- Communicate with other departments.
- Create tasks.
- Escalate incidents.
- Recommend decisions.
- Participate in meetings.
- Produce reports and deliverables.

Employees should not generate meaningless activity simply to make the company appear busy.

Their actions must be related to their responsibilities and the organization's current needs.

The detailed behavior, autonomy, memory and capabilities of AI employees will be defined in `04-AI-AGENTS.md`.

## 10. Organizational Autonomy

The company must maintain a level of autonomous activity even when no human participant is present.

Autonomous activity may include:

- Processing scheduled business operations.
- Generating customer behavior.
- Updating operational state.
- Detecting relevant conditions.
- Creating internal tasks.
- Executing routine processes.
- Triggering notifications.
- Maintaining historical records.

Not every process requires AI. The levels of behavior (deterministic, probabilistic and AI-driven) are defined in `04-AI-AGENTS.md`, section 4.

Routine and predictable operations should preferably be handled by conventional application logic.

More complex activities may involve simulated employees or AI agents.

Autonomous behavior must respect organizational rules, permissions and operational constraints.

## 11. Time and Continuity

The organization should have a persistent history and a coherent sense of time.

Business events, transactions, employee activities and customer interactions must be associated with timestamps and historical records.

The simulation should eventually support:

- Daily business activity.
- Weekly operational cycles.
- Monthly financial periods.
- Campaign schedules.
- Delivery timelines.
- Employee work routines.
- Performance evaluations.
- Long-term business objectives.

The time progression model is decided: the organization advances in simulated days (`docs/decisions/0001-simulation-time.md`). This section is the primary reference for how that works. The mechanics, such as how many events occur per simulated day, remain to be specified here.

The simulation must avoid generating activity at a rate that makes the organization economically or operationally unrealistic.

## 12. Consequences and Business Outcomes

The simulation must preserve the consequences of relevant actions.

Examples:

- Poor inventory management can cause lost sales.
- Poor customer service can reduce customer loyalty.
- Successful marketing can increase revenue and operational pressure.
- Delayed deliveries can generate complaints.
- Poor financial decisions can restrict future investments.
- Technical failures can interrupt business operations.
- Good decisions can improve efficiency and customer satisfaction.

Outcomes should emerge from the organization's actual state and business rules.

The system should not arbitrarily declare an action successful or unsuccessful.

## 13. Historical Records and Auditability

Important business events and decisions must be traceable.

The organization should preserve relevant information about:

- Transactions.
- Orders.
- Inventory movements.
- Customer interactions.
- Complaints and resolutions.
- Employee activities.
- Decisions.
- Approvals.
- Operational incidents.
- Changes in business state.

Historical records should make it possible to understand how the organization reached its current state.

This is important for operational consistency, participant feedback, investigation and future simulation improvements. The audit model is defined in `05-TECHNICAL-ARCHITECTURE.md`, section 12.

## 14. Simulation Design Constraints

The simulation must be designed with realistic technical and economic constraints.

Initial development should prioritize:

- A limited number of business processes.
- Deterministic business rules.
- Structured data.
- Event-driven state transitions where appropriate.
- Controlled probabilistic behavior.
- Selective use of AI.
- Reusable simulation mechanisms.
- Observable and auditable operations.

The project must not assume that every customer, employee or business event requires an independent AI model.

The simulation should remain useful and coherent even when AI capabilities are unavailable.

## 15. Open Questions

The following decisions remain unresolved:

1. How should simulated time progress? **Answered:** in simulated days, with one shared timeline per organization (`docs/decisions/0001-simulation-time.md`).
2. Should the company continue operating at the same rate when no participant is present? **Partly answered:** the organization keeps advancing while no participant is connected (`06-ROADMAP.md`, section 14, scenario 5). The rate of activity is still open (questions 4 and 5).
3. Which business processes must exist in the first release? **Answered:** the business cycle in `06-ROADMAP.md`, section 6, plus the first-release workflows in section 14. Other workflows listed in section 6 of the roadmap are deferred.
4. How many simulated customers are necessary for an initial useful experience?
5. How should customer behavior be calibrated?
6. Which employee activities should be autonomous?
7. Which decisions require human approval?
8. How should external market conditions influence the simulation?
9. How should multiple participants affect the same business processes?
10. How should the organization recover from inconsistent or failed operations?
11. How should simulation events be replayed, corrected or investigated?
12. How should the system prevent repetitive or meaningless activity?
13. How is stock moved between locations (between the online store and the physical stores, or between physical stores)? Not defined. Required before Phase 3 (`docs/decisions/0017-physical-stores-in-first-release.md`).

These questions must be resolved progressively through product discovery, experimentation and technical design.

---

_This document establishes the conceptual business simulation model. Detailed user journeys, AI agent behavior, technical architecture and implementation priorities are specified separately._
