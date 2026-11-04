# Expathio — Project Vision

**Status:** IN DISCUSSION  
**Document type:** Product vision  
**Project:** Expathio

---

## 1. What is Expathio?

Expathio is a platform built around the simulation of a living business environment.

Its purpose is to allow people to experience professional work by entering a virtual organization, assuming roles, taking responsibility for activities, collaborating with other participants and interacting with an environment that operates independently of them.

Unlike traditional educational platforms, Expathio is not centered around courses, lessons, isolated exercises or predefined learning paths.

The central element is the simulated organization itself.

Participants do not simply complete exercises designed to teach a profession. They become part of a business environment where work emerges from operational needs, business events, organizational objectives and interactions between people and simulated employees.

The company continues operating even when participants are absent. Its customers have needs, its departments have responsibilities, its employees perform activities and its operations generate events that require attention.

The participant enters this environment and becomes part of its ongoing activity.

Expathio is currently a personal learning and experimentation project. It is not a commercial product at this stage, although that possibility is not ruled out in the future.

## 2. Core Vision

Create a persistent and dynamic virtual organization where people can experience the complexity, responsibilities and interactions of real professional environments.

The long-term vision is to make Expathio a platform where different organizations, industries, departments and professional roles can exist and evolve.

The initial experience will be based on one fictional company, but the platform must not be conceptually restricted to that company or industry.

Expathio should eventually support different business environments and professional experiences without requiring the entire platform to be redesigned.

## 3. Core Philosophy

The fundamental principle behind Expathio is:

**The organization exists independently of the participant.**

The participant is not the center of the simulated world. They are one of its members.

This distinction is essential.

A conventional educational simulation often waits for the user to perform an action before producing the next event.

Expathio should work differently.

The organization must have its own operational activity, objectives, internal relationships, customers, events and evolving circumstances.

Examples:

- Customers purchase products without waiting for a participant to initiate a sale.
- Customers complain about defective products, delayed deliveries or poor experiences.
- Inventory changes as orders are processed.
- Departments identify operational problems.
- Employees create tasks and communicate with other departments.
- Business decisions affect future operations.
- Marketing campaigns influence customer behavior.
- Operational failures can create consequences across multiple departments.

The participant enters an already existing environment and influences its direction through their actions.

## 4. Professional Experience

Expathio aims to provide practical professional experiences across different organizational roles.

Participants should be able to assume positions in different departments.

The roles listed below are illustrative. The reference list of roles for the initial organization will be defined in `08-COMPANY.md`.

Examples include:

- Software Development
- Product Management
- Marketing
- Design
- Finance
- Sales
- Customer Service
- Operations
- Logistics
- Management

Each role should have its own responsibilities, tools, workflows, permissions, objectives and deliverables.

The experience should reflect the actual nature of the selected role.

For example, a software developer should work with real source code, Git, branches, pull requests, reviews, automated tests and deployment processes.

In the long term, developer participants may work with real code and repositories, not only simulated ones. This is not part of the initial release.

A marketing professional should work with campaigns, positioning, performance indicators, content and commercial objectives.

An operations professional should deal with inventory, orders, suppliers, logistics and operational constraints.

The objective is not to reproduce every aspect of a real company immediately, but to build a coherent environment in which professional activities have meaning and consequences.

## 5. A Living Business Environment

The simulated organization must operate through interconnected business processes.

Its departments should not behave as isolated modules.

A decision or event in one department may affect several others.

For example:

1. A marketing campaign increases demand for a particular product.
2. Sales volume increases.
3. Inventory decreases faster than expected.
4. The logistics department identifies a shortage.
5. The commercial department faces delivery constraints.
6. Customers begin reporting delays.
7. Customer service receives complaints.
8. Management must decide how to respond.

This interconnected behavior is fundamental to the Expathio experience.

The platform should simulate not only successful operations but also uncertainty, mistakes, bottlenecks, conflicts, unexpected events and business consequences.

## 6. Artificial Intelligence

Artificial intelligence will be an important part of Expathio, but it should not be used indiscriminately.

The platform should combine:

- Conventional business logic.
- Deterministic processes.
- Probabilistic behavior.
- Event-driven interactions.
- Structured memory and historical records.
- AI agents for tasks that genuinely benefit from reasoning, interpretation and decision-making.

Not every simulated customer or employee needs an independent AI model.

The use of AI should be selective, purposeful and economically sustainable.

AI agents should operate within defined responsibilities, permissions and constraints.

Their actions must be traceable, and their decisions should have meaningful consequences within the organization.

The goal is to create believable and useful organizational behavior, not simply to maximize the number of AI agents.

## 7. Initial Business Environment

The first simulated organization will be a fictional fashion and streetwear brand operating primarily through B2C e-commerce.

This environment was chosen because it provides a rich business context involving:

- Product development and collections.
- Digital commerce.
- Marketing and customer acquisition.
- Sales and conversion.
- Inventory management.
- Order processing.
- Logistics and delivery.
- Customer relationships.
- Exchanges, returns and refunds.
- Financial management.
- Technology and internal systems.

The initial company should be commercially realistic and technologically dependent without being a technology company itself.

This provides opportunities to simulate interactions between business operations and technology.

The company identity, name, catalog, organizational structure and detailed business rules will be defined in `08-COMPANY.md`.

## 8. Design Principles

The following principles should guide product and technical decisions.

### 8.1 Organizational coherence

Business processes, employee responsibilities, customer behavior and system interactions must make sense together.

### 8.2 Persistent activity

The organization should continue generating relevant activity independently of participant interaction.

### 8.3 Meaningful consequences

Actions and decisions should affect the organization and its future state.

### 8.4 Professional realism

Activities should reflect real responsibilities, constraints, tools and workflows when the difference is observable to the participant. Simplifications that do not change decisions or consequences are acceptable.

### 8.5 Interconnected departments

The organization must be modeled as a connected system rather than a collection of unrelated features.

### 8.6 Controlled autonomy

Simulated employees and customers should have meaningful autonomy within defined boundaries.

### 8.7 Economic sustainability

The platform must be designed with careful consideration of infrastructure, computation and AI costs.

### 8.8 Progressive complexity

The project should evolve incrementally. Initial implementations must be useful without requiring the entire envisioned organization to exist from the beginning.

### 8.9 Extensibility

The platform should be capable of supporting additional companies, industries, roles and business models in the future.

### 8.10 Real professional deliverables

Where applicable, participants should produce tangible outputs such as code, documents, campaigns, reports, decisions and operational results.

## 9. Long-Term Direction

Expathio should evolve beyond a single simulated company.

The long-term platform may support:

- Multiple organizations and industries.
- Different organizational structures.
- Diverse professional roles.
- Multiple simultaneous participants.
- Collaboration between participants.
- Autonomous simulated employees.
- Persistent customer relationships.
- Complex business scenarios.
- Real development and deployment workflows.
- Organizational history and performance indicators.

These are long-term possibilities, not commitments for the initial release.

## 10. Scope and Non-Goals

Expathio is not intended to be:

- A conventional online course platform.
- A collection of disconnected professional exercises.
- A chatbot pretending to be an entire company.
- A system where every simulated entity requires an AI model.
- A simplistic help-desk simulator.
- A technology-only company simulation.
- A platform that requires expensive infrastructure to provide its initial experience.

The project should prioritize the quality and coherence of the simulated organization over the number of features.

## 11. Guiding Question

When evaluating a new feature, architectural decision or product direction, ask:

**Does this make the simulated organization more coherent, alive, useful or professionally meaningful?**

If not, its relevance to Expathio should be questioned.

---

_This document defines the initial vision of Expathio. Detailed product requirements, business rules, user journeys, AI behavior and technical decisions belong in their respective documents._
