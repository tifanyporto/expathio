# Expathio — AI Agents

**Status:** IN DISCUSSION  
**Document type:** AI agents specification  
**Project:** Expathio

---

## 1. Purpose

This document defines the role of artificial intelligence agents within Expathio.

AI agents are part of the simulated organization's workforce and social environment.

They represent employees, managers, customers, and other actors capable of interpreting situations, making decisions, communicating, and influencing organizational activity.

The objective is to create a believable organization in which participants interact with entities that have their own responsibilities, interests, priorities, and behavioral patterns.

AI should contribute to organizational intelligence and autonomy without becoming the foundation of every system operation.

## 2. Core Principles

The AI architecture must follow these principles. The project-wide design principles are in `00-VISION.md`, section 8; the list below applies them to AI agents.

- **Purposeful autonomy:** Agents should act independently when their responsibilities require it.
- **Organizational coherence:** Agent behavior must respect the organization's structure, rules, processes, and current state.
- **Persistent identity:** Important agents should maintain consistent identities, responsibilities, and relevant historical context.
- **Bounded authority:** Agents must operate within explicitly defined permissions and responsibilities.
- **Selective intelligence:** AI should be used when interpretation, reasoning, planning, or natural communication provides meaningful value.
- **Cost awareness:** The system must avoid unnecessary AI calls and uncontrolled agent activity.
- **Observable behavior:** Important agent decisions and actions should be traceable.
- **Human participation:** AI agents should support a meaningful environment, not make the participant irrelevant.

## 3. Agent Categories

Expathio may contain different categories of agents.

### 3.1. Employee Agents

Employee agents represent people working within the organization.

They may have:

- A professional identity.
- A position and department.
- Defined responsibilities.
- Skills and knowledge.
- Goals and priorities.
- Working relationships.
- Behavioral characteristics.
- Historical experiences.
- Decision-making permissions.

Their behavior should reflect their organizational position.

An operations employee should not behave like a financial manager, and a marketing specialist should not have unrestricted authority over inventory or financial decisions.

### 3.2. Manager Agents

Manager agents coordinate work and make decisions within their areas of responsibility.

Possible responsibilities include:

- Assigning activities.
- Prioritizing work.
- Reviewing deliverables.
- Providing feedback.
- Coordinating employees.
- Escalating problems.
- Making departmental decisions.
- Monitoring performance.
- Identifying operational risks.

Managers should consider organizational objectives, available resources, deadlines, and employee responsibilities.

Their decisions should have consequences and remain consistent with company policies.

### 3.3. Customer Agents

Customer agents represent people interacting with the organization's products and services.

Customers are particularly important because they generate external demand and introduce unpredictable business situations.

They may have:

- Personal preferences.
- Purchasing power and budget constraints.
- Product interests.
- Purchase intentions.
- Expectations.
- Previous interactions.
- Satisfaction levels.
- Behavioral tendencies.
- Individual circumstances.

Customer behavior should not be limited to predefined purchase requests.

Customers may independently:

- Discover products.
- Compare alternatives.
- Purchase products.
- Abandon purchases.
- Ask questions.
- Request assistance.
- Complain about problems.
- Request exchanges or refunds.
- Express dissatisfaction.
- Return to the company.
- Recommend or criticize the brand.

Complaints and dissatisfaction are essential parts of the customer experience simulation.

Customers should not exist exclusively to generate sales. Their behavior should reflect varied motivations and experiences.

### 3.4. External Actors

The organization may interact with external entities such as:

- Suppliers.
- Business partners.
- Service providers.
- Logistics companies.
- Market representatives.
- Other organizations.

These actors may initially be represented through deterministic processes or simplified simulations.

More sophisticated AI behavior can be introduced when it provides meaningful value.

## 4. Agent Intelligence Model

Not every simulated entity requires an AI model.

Expathio should use different levels of behavioral complexity depending on the entity's purpose.

### 4.1. Deterministic Behavior

Deterministic logic handles predictable processes and operations.

Examples:

- Updating inventory after a confirmed sale.
- Calculating order totals.
- Applying company policies.
- Checking payment status.
- Changing task status.
- Enforcing permissions.
- Applying predefined workflow transitions.

These operations should not depend on AI interpretation.

### 4.2. Probabilistic Behavior

Probabilistic logic introduces variation and uncertainty without requiring language models.

Examples:

- Customer purchasing frequency.
- Product preferences.
- Purchase abandonment probability.
- Randomized demand fluctuations.
- Customer return likelihood.
- Event occurrence probability.
- Employee activity scheduling.

Probabilistic behavior should be constrained by business context and persistent state.

Randomness should create variation, not arbitrary or incoherent outcomes.

### 4.3. AI-Driven Behavior

AI should be used when an entity needs capabilities such as:

- Interpreting natural language.
- Reasoning about ambiguous situations.
- Planning actions.
- Evaluating alternatives.
- Producing contextual communication.
- Understanding complaints.
- Making decisions that require judgment.
- Adapting behavior to relevant historical context.

Examples:

- A manager evaluating a complex deliverable.
- A customer explaining dissatisfaction in natural language.
- An employee proposing a solution to an unexpected problem.
- A department manager deciding how to respond to an operational incident.

AI decisions must remain constrained by organizational rules, permissions, and available information.

## 5. Agent Autonomy

Agents should have a degree of independence.

However, autonomy does not mean unrestricted execution.

Each agent should operate within defined boundaries.

These boundaries may include:

- Organizational role.
- Department.
- Assigned responsibilities.
- Available resources.
- Decision-making authority.
- Access permissions.
- Business rules.
- Operational limits.
- Escalation requirements.

An agent should be able to identify situations requiring action, determine whether it has authority to act, and escalate decisions beyond its permissions.

### Autonomy Levels

Different agents may operate with different autonomy levels:

**Level 1 — Reactive**

The agent responds to explicit events or requests.

**Level 2 — Contextual**

The agent evaluates its current situation and selects an appropriate response.

**Level 3 — Proactive**

The agent identifies opportunities or problems and initiates actions within its authority.

**Level 4 — Strategic**

The agent evaluates longer-term objectives, plans activities, and coordinates decisions across multiple responsibilities. Level 4 is outside the scope of the first AI-enabled version.

These levels represent behavioral capabilities, not necessarily separate AI models.

A single agent may use different autonomy levels depending on the situation.

## 6. Goals, Needs, and Motivations

Important agents should have motivations that influence their behavior.

Employee motivations may include:

- Completing assigned responsibilities.
- Meeting departmental objectives.
- Improving performance.
- Avoiding operational problems.
- Gaining recognition.
- Protecting their professional reputation.
- Achieving career progression.

Customer motivations may include:

- Finding suitable products.
- Staying within budget.
- Receiving products on time.
- Solving problems.
- Obtaining good service.
- Feeling satisfied with purchases.

Motivations should influence decisions without making agents excessively predictable.

Agents should be able to prioritize competing objectives when appropriate.

## 7. Memory and Identity

Important agents should maintain persistent identities.

Their relevant history may include:

- Previous interactions.
- Decisions made.
- Current responsibilities.
- Ongoing objectives.
- Important relationships.
- Previous problems.
- Relevant preferences.
- Outstanding commitments.

Memory should be selective and structured.

The system should not rely on sending an agent's entire interaction history to an AI model every time it acts.

Relevant context should be retrieved according to the current situation.

### Memory Categories

Conceptually, agent memory may include:

- **Identity:** Who the agent is and what role they occupy.
- **Working context:** Current responsibilities and active situations.
- **Episodic history:** Important previous events and interactions.
- **Preferences:** Stable behavioral tendencies and preferences.
- **Organizational knowledge:** Policies, procedures, and relevant business information.

Not every agent needs every memory category.

Memory should be proportional to the entity's importance and expected complexity.

## 8. Agent Interactions

Agents should interact through meaningful organizational relationships.

Examples include:

- Employees communicating with managers.
- Departments requesting information from one another.
- Managers assigning responsibilities.
- Customers contacting customer service.
- Employees escalating problems.
- Managers negotiating priorities.
- External actors communicating with company departments.

Interactions should have a purpose and, when relevant, produce persistent records.

The system should avoid generating conversations simply to make the organization appear active.

Communication should contribute to decisions, coordination, or business outcomes.

## 9. Decision-Making and Permissions

Agents must not have unrestricted access to organizational state.

Each agent should have clearly defined permissions.

Examples:

- A customer can place an order but cannot modify company inventory directly.
- A customer service employee can handle certain complaints but may require approval for exceptional refunds.
- A marketing manager can approve campaigns within an assigned budget.
- A financial manager can review financial information but should not automatically control every operational department.
- An employee can update assigned work but cannot arbitrarily rewrite historical records.

AI-generated decisions should be validated before affecting authoritative business state.

Sensitive or high-impact actions may require explicit approval.

## 10. Agent Execution and Scheduling

Agents should not need to remain continuously active.

Their activities should be triggered by relevant situations.

Possible triggers include:

- New organizational events.
- Incoming messages.
- Task assignments.
- Customer interactions.
- Scheduled business routines.
- Changes in relevant business indicators.
- Unresolved situations.
- Explicit requests from other agents or participants.

The system should evaluate whether an agent actually needs to act before invoking AI.

Multiple events may be consolidated when separate processing would provide no meaningful benefit.

The architecture should support controlled execution, scheduling, retries, and protection against duplicate actions.

## 11. Agent Coordination

Some situations require multiple agents to cooperate.

For example:

1. A customer reports receiving the wrong product.
2. Customer service analyzes the complaint.
3. Operations checks the fulfillment history.
4. Inventory verifies available stock.
5. A manager evaluates an exceptional refund or replacement.
6. Customer service communicates the resolution.

The system should preserve the relationships between these actions.

Agents should not independently invent organizational facts or assume that another department has completed an action without confirmation.

Shared business state must remain authoritative.

## 12. Failure and Escalation

Agents may encounter situations they cannot resolve.

Examples:

- Missing information.
- Conflicting instructions.
- Insufficient permissions.
- Unavailable resources.
- Ambiguous customer requests.
- Unexpected operational conditions.
- Conflicting departmental priorities.

In these situations, agents should be able to:

- Request clarification.
- Escalate to a manager.
- Create a case, a task or an incident, as appropriate.
- Wait for an external dependency.
- Report that they cannot proceed.

Agents should not fabricate successful outcomes to hide uncertainty or failure.

## 13. Observability and Accountability

Important agent actions should be recorded.

The system should make it possible to understand:

- Which agent acted.
- What triggered the action.
- What information was considered.
- Which decision was made.
- What action was requested.
- Whether the action succeeded.
- What organizational state changed.
- Whether human approval was required.

The objective is not to expose every internal reasoning detail of an AI model.

The objective is to maintain an understandable and auditable history of organizational decisions and actions.

## 14. Cost and Resource Management

AI execution must be economically sustainable.

The system should avoid:

- Running every agent continuously.
- Invoking AI for deterministic operations.
- Creating unnecessary agent-to-agent conversations.
- Sending excessive historical context.
- Generating large volumes of meaningless activity.
- Using expensive models for simple tasks.

Potential optimization strategies include:

- Event-driven execution.
- Scheduled activity windows.
- Context selection and summarization.
- Model selection based on task complexity.
- Deterministic simulation for routine behavior.
- Batching compatible operations.
- Execution limits and rate limiting.
- Prioritization of important events.

The system should make it possible to measure AI usage by agent, organization, event, and operation.

Cost limits should be considered part of the simulation design, not an afterthought.

## 15. Initial AI Implementation Strategy

This section describes the first AI-enabled version (Roadmap, Phase 6), not the first release of Expathio.

The first AI-enabled version should prioritize a small number of meaningful agents rather than attempting to simulate an entire workforce with sophisticated AI.

A possible initial structure includes:

- One executive or general management agent.
- A small number of departmental manager agents.
- A limited number of important employee agents.
- A customer population primarily driven by deterministic and probabilistic behavior.
- AI-driven customer interactions when natural language or contextual judgment is necessary.

The exact number of agents and their responsibilities should be determined during architecture and roadmap planning.

The initial goal is to validate coherent organizational behavior, not maximize the number of simulated people.

## 16. Open Questions

The following decisions require further exploration:

- Which roles genuinely require AI?
- Which roles can be represented through deterministic or probabilistic behavior?
- How should agents maintain and update their memories?
- How should agent autonomy be configured?
- Which decisions require human approval?
- How should agents coordinate across departments?
- How should conflicting goals be resolved?
- How should agents behave when the participant is absent?
- How should customer populations be generated and maintained?
- How should AI usage and costs be measured?
- Which model providers and models should be evaluated?
- How should the system prevent agents from inventing business facts?
- How should agent activity be paused, resumed, or limited?

These decisions must be resolved before AI Integration starts in Phase 6 (`docs/06-ROADMAP.md`, section 9). AI is outside the first release (`docs/decisions/0003-ai-timing-and-scope.md`). They should be validated against the available infrastructure, expected operating costs, and the desired level of organizational realism.
