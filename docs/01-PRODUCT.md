# Expathio — Product Definition

**Status:** IN DISCUSSION  
**Document type:** Product specification  
**Project:** Expathio

---

## 1. Product Overview

Expathio is a platform that provides access to persistent simulated business environments where participants can assume professional roles and take part in realistic organizational activities.

The product connects three fundamental elements:

1. A simulated organization with its own operations, objectives and internal dynamics.
2. Participants who enter the organization and assume responsibilities.
3. A simulation engine that keeps the organization active, generating events, interactions and operational demands.

The platform must provide the tools and interfaces necessary for participants to perform their roles while allowing the simulated organization to operate independently.

Expathio is not simply a visualization of a fictional company. It must provide an environment where meaningful work can actually happen.

## 2. Target Audience

Expathio is intended for people who want to experience professional environments through practical participation.

Potential audiences include:

- Students preparing to enter the job market.
- Professionals seeking experience in a different field.
- People transitioning between careers.
- Developers and other technology professionals.
- People interested in understanding how organizations operate.
- Professionals who want to practice responsibilities beyond their current position.

The platform should not assume that every participant has previous professional experience.

Its experience should be accessible to beginners while retaining enough depth to remain useful to experienced professionals.

## 3. Core Product Components

The product can initially be understood through six major components.

### 3.1 Organizations

An organization represents a simulated business environment.

Each organization should have its own:

- Identity and business model.
- Organizational structure.
- Departments and roles.
- Products or services.
- Customers and suppliers.
- Business rules.
- Operational processes.
- Employees and responsibilities.
- Historical records.
- Goals and performance indicators.

The platform should eventually support multiple organizations with different industries and operational characteristics.

### 3.2 Participants

Participants are real users who enter an organization and assume a professional position.

A participant should be able to:

- Explore available organizations.
- Understand the company's structure.
- Review available positions.
- Understand the responsibilities of a position.
- Join an organization in an assigned role.
- Access role-specific tools and information.
- Receive and manage work.
- Interact with other participants and simulated employees.
- Produce deliverables.
- Observe the consequences of their actions.

The participant should experience the organization as a member, rather than as an external observer.

### 3.3 Roles and Departments

Roles define what a participant or simulated employee is responsible for within the organization.

A role should describe:

- Responsibilities.
- Permissions.
- Objectives.
- Available tools.
- Relevant information.
- Expected deliverables.
- Reporting relationships.
- Interactions with other departments.

Departments organize related roles and responsibilities.

The system must support different organizational structures rather than assuming every company follows the same hierarchy.

### 3.4 Organizational Activity

The organization must generate and process activities independently of participant interaction.

Examples include:

- Operational tasks.
- Customer requests.
- Internal incidents.
- Business opportunities.
- Meetings.
- Reports.
- Approvals.
- Deadlines.
- Departmental requests.
- Unexpected events.

Activities should emerge from the organization's state, objectives and interactions.

The platform must avoid relying exclusively on manually created tasks or predefined scenarios.

### 3.5 Tools and Workspaces

Participants need interfaces and tools that correspond to their professional responsibilities.

Examples may include:

- Task management.
- Internal communication.
- Documentation.
- Dashboards and reports.
- Product and inventory management.
- Order management.
- Customer relationship management.
- Financial records.
- Development environments.
- Version control and deployment workflows.

Development environments and version control or deployment workflows are long-term possibilities, not part of the initial release.

Not every role should have access to every tool. The tools for each role in the first version are listed in `08-COMPANY.md`, section 5 (`docs/decisions/0009-first-version-tools-and-roles.md`).

The available workspace should reflect the participant's position and permissions.

### 3.6 Simulation Engine

The simulation engine is responsible for maintaining the organization's state and generating its ongoing activity.

It should coordinate:

- Business events.
- Customer behavior.
- Employee activity.
- Operational processes.
- Interdepartmental dependencies.
- Time progression.
- State changes.
- Consequences of decisions.

Its detailed behavior will be specified in `02-BUSINESS-SIMULATION.md`.

## 4. Participant Experience

The general participant journey should follow this conceptual sequence:

1. Discover Expathio.
2. Access the platform.
3. Explore available organizations.
4. Select an organization.
5. Explore its departments and available roles.
6. Review the responsibilities of a position.
7. Join the organization.
8. Access the appropriate workspace.
9. Receive and perform activities.
10. Collaborate with the organization.
11. Observe results and consequences.
12. Continue participating as the organization evolves.

This is an initial conceptual journey. Authentication, onboarding, selection rules and participation policies remain to be defined.

## 5. Work and Activities

Work should be a central part of the product experience.

Activities must have context and should be connected to real organizational needs.

A task should ideally provide:

- A clear objective.
- Relevant background information.
- A responsible role or department.
- Priority.
- Deadline or expected timeframe, when applicable.
- Dependencies.
- Required deliverables.
- Acceptance criteria, when applicable.
- Current status.
- Historical records.

Tasks should not exist merely to keep participants occupied.

They should represent actual needs, opportunities or responsibilities within the simulated organization.

The platform should support both structured activities and less predictable situations that require participants to investigate, communicate and make decisions.

## 6. Interaction and Collaboration

Expathio should support interactions between:

- Participants.
- Simulated employees.
- Customers.
- Departments.
- External business entities.

Communication should happen in appropriate organizational contexts.

Examples include:

- Direct messages.
- Departmental communication.
- Task-related discussions.
- Meetings.
- Approval requests.
- Internal announcements.
- Operational notifications.

The interaction model should eventually allow multiple participants to collaborate within the same organization.

The exact communication tools and real-time requirements remain open.

## 7. Feedback and Professional Development

The platform should make the consequences of participant actions observable.

Examples include:

- Whether a deliverable meets its requirements.
- Whether a task was completed successfully.
- Whether a decision improved or worsened an operational situation.
- Whether another department was affected.
- Whether a customer issue was resolved.
- Whether a business objective was achieved.

Expathio may eventually provide structured feedback, performance history, reputation, skill progression or other development mechanisms.

However, these mechanisms should not turn the platform into a conventional gamified course.

The initial priority is meaningful work and coherent organizational behavior.

## 8. Product Boundaries

The product should distinguish between three related but different responsibilities:

### Platform

The shared environment that provides user accounts, organization access, roles, permissions, interfaces and platform-level services.

### Organization

The specific simulated business, including its structure, departments, employees, customers, processes and business data.

### Simulation

The mechanisms that maintain activity, generate events, process interactions and evolve the organization's state.

These boundaries should remain conceptually clear even if the first implementation uses a relatively simple technical structure.

## 9. Initial Product Scope

The initial product should prioritize a single organization and a limited set of interconnected workflows.

The first implementation should demonstrate that:

- A participant can enter an organization.
- A participant can assume a defined role.
- The organization has a coherent structure.
- Role-specific activities can be performed.
- Business events can occur independently.
- Departments can affect one another.
- Actions produce observable consequences.
- Organizational state and history are preserved.

The exact first departments, roles and workflows will be defined in `08-COMPANY.md`.

The product will initially be available in English. Translations are planned for the future.

## 10. Future Capabilities

Potential future capabilities include:

- Multiple organizations.
- Multiple participants in the same organization.
- Organization creation and customization.
- Different industries and business models.
- Advanced organizational hierarchies.
- Autonomous simulated employees.
- Persistent customer relationships.
- Advanced analytics and reporting.
- Collaborative projects.
- Professional portfolios based on actual deliverables.
- More complex organizational scenarios.

These capabilities are not requirements for the initial release.

## 11. Open Product Questions

This section is the single list of open product questions. Other documents should refer to it rather than restate these questions.

The following questions remain unresolved and must be discussed before implementation:

1. Can participants join an organization freely, or must they apply for positions? **Decided:** participants apply to predefined vacancies, which simulate a hiring process (`docs/decisions/0005-admission-model.md`).
2. Can multiple participants occupy the same role? **Decided:** not in the first version, where each role has one occupant (`docs/decisions/0007-first-version-participant-rules.md`).
3. Can a participant change departments or positions? **Decided:** yes, after the first version (`docs/decisions/0007-first-version-participant-rules.md`).
4. Can participants create their own organizations in the future? **Decided:** not in the first version. Creation is a later step (see section 10).
5. Will organizations have a shared timeline or individual time progression? **Decided:** each organization has one shared timeline, advancing in simulated days (`docs/decisions/0001-simulation-time.md`).
6. Will participation be continuous or organized into work sessions? **Decided:** work sessions (`docs/decisions/0008-participation-sessions.md`).
7. How will participants receive feedback? **Decided:** through observable results of their work. No formal evaluation in the first version (`docs/decisions/0007-first-version-participant-rules.md`).
8. Will there be formal evaluations or only observable outcomes? **Decided:** only observable outcomes in the first release. Formal evaluations are outside it (`docs/CURRENT_STATE.md`, section "Other decisions").
9. How much freedom should participants have to make decisions outside predefined tasks? **Decided:** participants may propose actions. Proposals need approval from the simulated manager before they affect the organization (`docs/decisions/0007-first-version-participant-rules.md`).
10. What happens to a role when its participant leaves the organization? **Decided:** the simulation takes over the role's activities until the next occupant (`docs/decisions/0007-first-version-participant-rules.md`).

These questions should not be resolved through assumptions. They require explicit product decisions.

## 12. Participant Data and Privacy

Participants are real people, and the platform stores their account data and participation records. Before the first release, the following must be defined: which account data is collected and why, who can see it, how long it is kept, and how a participant can export or delete their data. This must be defined before Phase 4 admits the first real participant (`docs/06-ROADMAP.md`, section 7). Status: open, not yet discussed.

Compliance with Brazilian data protection law (LGPD) is a product requirement.

---

_This document describes the product's conceptual structure. Business behavior, user journeys, AI agent responsibilities and technical implementation are detailed in their respective documents._
