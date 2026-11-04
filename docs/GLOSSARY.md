# Expathio — Glossary

**Status:** IN DISCUSSION  
**Document type:** Glossary  
**Project:** Expathio

---

Terms used across the project documents. Where a term is defined elsewhere, the source is given.

## Platform, Organization, Simulation

- **Platform:** the shared environment that provides accounts, organization access, roles, permissions and interfaces (`01-PRODUCT.md`, section 8).
- **Organization:** a specific simulated business, with its structure, departments, employees, customers, processes and data (`01-PRODUCT.md`, section 8).
- **Simulation:** the mechanisms that keep the organization active, generate events and evolve its state (`01-PRODUCT.md`, section 8).

## People and Roles

- **Participant:** a real person who enters an organization and assumes a role.
- **Role:** a professional position with responsibilities, permissions, tools and deliverables (`01-PRODUCT.md`, section 3.3).
- **Department:** a group of related roles.
- **Employee agent:** a simulated employee, whose behavior may be deterministic, probabilistic or AI-driven (`04-AI-AGENTS.md`, section 3.1).
- **Manager agent:** a simulated employee who coordinates work within a department (`04-AI-AGENTS.md`, section 3.2).
- **Customer agent:** a simulated customer who buys, asks questions or complains (`04-AI-AGENTS.md`, section 3.3).

## Work

- **Activity:** any unit of organizational work or movement. Broader than a task.
- **Task:** a work item assigned to a role or department, with an objective, context and expected deliverables (`01-PRODUCT.md`, section 5).
- **Case:** a customer-related task followed from report to resolution, such as a complaint, return or refund (`02-BUSINESS-SIMULATION.md`, sections 5.4 and 6.5). Name approved (`docs/decisions/0006-case-and-incident-terms.md`).
- **Incident:** an unplanned operational problem that affects the organization and may create tasks (`01-PRODUCT.md`, section 3.4). Name approved (`docs/decisions/0006-case-and-incident-terms.md`).
- **Deliverable:** a tangible output, such as a report, code, a campaign or a decision (`03-USER-EXPERIENCE.md`, section 8).
- **Notification:** a message that tells a participant about an event relevant to their role (`03-USER-EXPERIENCE.md`, section 10).

## Events and Time

- **Event:** a recorded change in the organization or its environment. Some events only record; others require an action (`02-BUSINESS-SIMULATION.md`, section 7).
- **Simulation time:** the organization's own clock, distinct from real time (`05-TECHNICAL-ARCHITECTURE.md`, section 7.1). The time model is open (`02-BUSINESS-SIMULATION.md`, section 11).

## Behavior

- **Deterministic logic:** fixed rules that do not depend on AI, such as updating inventory after a sale (`04-AI-AGENTS.md`, section 4.1).
- **Probabilistic behavior:** variation within business rules, without AI (`04-AI-AGENTS.md`, section 4.2).
- **AI-driven behavior:** reasoning, interpretation or natural language handled by an AI model (`04-AI-AGENTS.md`, section 4.3).

## Data

- **Simulated data:** fictional characters, customers, products and business records.
- **Participant data:** account and participation data of real people. It is personal data (`01-PRODUCT.md`, section 12).
