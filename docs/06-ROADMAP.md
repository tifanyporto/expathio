# Expathio — Product and Development Roadmap

**Status:** IN DISCUSSION  
**Document type:** Roadmap  
**Project:** Expathio

---

## 1. Purpose

This document defines the proposed development roadmap for Expathio.

The roadmap organizes the project into progressive phases, establishing priorities, expected outcomes, and conditions for moving forward.

The objective is to build Expathio incrementally while preserving its long-term vision.

Planning assumption: 5 to 10 hours per week of project time. Phase durations should be read with this assumption.

The project should prioritize a functional and coherent experience over a large number of incomplete features.

Each phase should produce something that can be demonstrated, tested, and evaluated.

## 2. Roadmap Principles

Development should follow these principles. The project-wide design principles are in `00-VISION.md`, section 8; the list below applies them to development.

- **Incremental delivery:** Each phase should produce a meaningful result.
- **Vertical development:** Whenever possible, implement complete workflows rather than disconnected technical components.
- **Validation before expansion:** Validate important assumptions before adding complexity.
- **Realistic scope:** Prioritize what can be implemented and maintained with available resources.
- **Technical learning:** Use development challenges as opportunities to understand real engineering concepts.
- **Controlled costs:** Avoid infrastructure and AI expenses that are unnecessary for the current stage.
- **Quality over quantity:** A small number of coherent processes is better than many disconnected features.
- **Documentation:** Important decisions, implementation status, and architectural changes must be recorded.

## 3. Phase 0 — Product Definition and Technical Preparation

### Objective

Establish a clear understanding of the product before committing to implementation decisions.

### Activities

- Complete the foundational product documentation.
- Define the initial simulated organization.
- Identify its business model and organizational structure.
- Define the initial organization, its departments and its roles in `08-COMPANY.md`.
- Identify the initial business workflows.
- Establish the initial simulation principles.
- Evaluate technical alternatives.
- Define the development environment.
- Establish repository and version control practices.
- Define the initial testing and deployment strategy.
- Identify major cost and infrastructure constraints.

### Expected Outcome

A sufficiently defined product and technical direction to begin implementation without relying on unresolved assumptions for every decision.

### Exit Criteria

- Core product vision is documented.
- Initial organization is defined.
- Initial workflows are understood.
- Architectural direction is established.
- Major technical risks are identified.
- Development environment is ready.

## 4. Phase 1 — Platform Foundation

### Objective

Build the foundation required to create and access organizations.

Scope approved by the owner on 2026-11-06. Accounts are test accounts only (`docs/decisions/0022-phase-1-test-accounts-only.md`). Membership is a direct link (`docs/decisions/0023-phase-1-direct-membership.md`). The four business roles are loaded as data (`docs/decisions/0024-phase-1-business-roles-loaded.md`).

### Scope

1. Project initialization and development and test environments, reproducible on the development computer.
2. Backend foundation, with database integration and migrations.
3. Frontend foundation, with the initial layout for computer screens.
4. Authentication: login and logout, with test accounts.
5. Basic user management: account data for test accounts.
6. A fixed initial organization, MONUMENT. Creating organizations is a future step (see `01-PRODUCT.md`, section 10).
7. Organization membership: a direct link between an account, the organization and a role.
8. Basic role and permission structure: the four business roles from `08-COMPANY.md`, section 5, with the permissions in section 6.1.
9. Data isolation by organization from the start (`docs/decisions/0010-scalability-foundations.md`).

Item 3 is read as the initial layout for computer screens, confirmed by the owner on 2026-11-06. The application is a web application (`docs/decisions/0012-initial-technology-direction.md`).

### Technical Focus

- Application structure.
- API design.
- Relational data modeling.
- Database migrations.
- Authentication and authorization.
- Input validation.
- Automated testing.
- Development workflow.

### Expected Outcome

A functional platform where a user can authenticate, access an organization, and have an identity and membership within it.

### Exit Criteria

- Application runs consistently.
- User authentication works.
- Organizational membership is persisted.
- Basic access restrictions are enforced.
- Data is scoped to its organization from the start.
- Automated tests cover essential functionality.
- Development setup is reproducible.

## 5. Phase 2 — First Functional Organization

### Objective

Create the first simulated organization with a coherent business structure.

### Scope

- Initial fashion brand identity.
- Organizational structure.
- Departments.
- Professional roles.
- Employee records.
- Initial customer records.
- Product catalog.
- Basic inventory.
- Basic organizational information.
- Initial participant role assignment, through vacancies: participants apply to predefined vacancies, and an accepted application assigns the role (`docs/decisions/0026-vacancy-application-in-phase-2.md`).

### Expected Outcome

A participant can enter an organization that has a recognizable business identity, departments, employees, customers, and products.

At this stage, the organization may still have limited autonomous activity.

### Exit Criteria

- Organization data is persistent.
- Departments and roles are connected.
- Products and inventory can be managed.
- Employees and customers have identifiable records.
- Participants can occupy a defined role.
- Organizational permissions are respected.

## 6. Phase 3 — First Complete Business Workflows

### Objective

Make the organization operational through a small number of interconnected business processes.

### Scope

Prioritize a complete initial business cycle:

1. A customer discovers a product.
2. The customer expresses purchase intent.
3. An order is created, online or in one of the physical stores (`docs/decisions/0017-physical-stores-in-first-release.md`).
4. Inventory is validated and updated.
5. The order enters fulfillment.
6. Delivery status changes.
7. The customer receives the product.
8. The customer may express satisfaction or dissatisfaction.
9. Customer service handles relevant requests.
10. Business information reflects the outcome.

Additional workflows may include:

- Product availability.
- Stock replenishment.
- Basic financial records.
- Customer complaints.
- Returns and exchanges.
- Operational task creation.

### Technical Focus

- Business rules.
- Transaction management.
- Domain boundaries.
- Internal events.
- Data consistency.
- Idempotency.
- Workflow state transitions.
- Audit history.

### Expected Outcome

The organization can execute at least one complete business cycle, producing meaningful changes across multiple departments.

### Exit Criteria

- Business workflows can execute from beginning to end.
- Business rules prevent invalid operations.
- Related departments respond to relevant changes.
- Important state transitions are recorded.
- Failures do not silently corrupt organizational state.

## 7. Phase 4 — Participant Work Environment

### Objective

Transform the platform from an organization management foundation into an environment where participants perform professional work.

### Scope

- Desktop-first participant workspace.
- Role-specific overview.
- Task management.
- Assignment and prioritization.
- Deliverables.
- Review and approval processes.
- Internal communication.
- Organizational announcements.
- Notifications.
- Work history.
- Basic collaboration mechanisms between participants and simulated actors. Collaboration between human participants belongs to Phase 8.

### Expected Outcome

A participant can perform meaningful professional responsibilities within the organization.

Activities should be connected to actual business needs rather than generic exercises.

### Exit Criteria

- Participants can access role-relevant information.
- Tasks have context and clear objectives.
- Deliverables can be submitted and reviewed.
- Feedback is recorded.
- Participants can understand the impact of their work.
- Participants can observe the consequences of business activity.
- Important communication is persistent and accessible.

## 8. Phase 5 — Simulation Engine and Organizational Continuity

### Objective

Make the organization capable of operating independently of participant activity.

### Scope

- Business event generation.
- Scheduled processes.
- Background workers.
- Simulation time model.
- Customer behavior.
- Probabilistic activity.
- Autonomous routine operations.
- Event processing.
- Failure handling.
- Simulation execution limits.
- Organizational activity history.

### Technical Focus

- Asynchronous processing.
- Scheduling.
- Event-driven architecture.
- Job execution.
- Retries and idempotency.
- Concurrency control.
- Observability.
- Recovery after failures.

### Expected Outcome

The organization continues evolving even when no participant is connected.

Business events occur, processes advance, customers behave according to their circumstances, and departments respond to relevant situations.

### Exit Criteria

- Simulation activity can occur independently of the user interface.
- Organizational state persists across restarts.
- Scheduled operations execute reliably.
- Duplicate processing is controlled.
- Failed operations can be identified and recovered.
- Simulation activity respects configured limits.
- After an absence, a participant can list the events that affected their responsibilities since their last session.

## 9. Phase 6 — AI-Powered Employees and Customers

### Objective

Introduce AI capabilities that make important organizational actors more contextual, adaptive, and autonomous.

### Scope

- AI integration layer.
- Initial AI-powered manager agents.
- Selected employee agents.
- Natural language communication.
- Contextual decision-making.
- Customer complaint interpretation.
- Agent memory.
- Bounded autonomy.
- Agent permissions.
- Decision validation.
- AI usage measurement.
- Cost controls.

### Implementation Strategy

AI should be introduced selectively.

The initial system should continue using deterministic and probabilistic logic for routine business operations.

AI should focus on situations where interpretation, reasoning, planning, or contextual communication adds meaningful value.

### Expected Outcome

The organization contains a small number of agents capable of making contextual decisions and interacting naturally with participants and other organizational actors.

### Exit Criteria

- AI agents have defined roles and permissions.
- AI actions are validated before affecting business state.
- Agent context is relevant and controlled.
- Important decisions are traceable.
- AI failures do not compromise essential business operations.
- Usage and costs can be measured.
- AI activity respects operational limits.

## 10. Phase 7 — Career Progression and Organizational Recognition

### Objective

Allow participants to develop a professional trajectory within the simulated organization.

### Scope

- Performance history.
- Professional experience.
- Recognition mechanisms.
- Career milestones.
- Performance evaluations.
- Fictional compensation.
- Bonuses and rewards.
- Promotions.
- Increased responsibilities.
- Role transitions.
- Professional history.

### Expected Outcome

Participants can build a career within the organization.

Their contributions, experience, performance, and accumulated responsibilities influence their professional progression.

### Exit Criteria

- Professional history is persistent.
- Performance evaluations have contextual criteria.
- Experience and performance both influence progression.
- Promotions reflect organizational circumstances.
- Compensation changes are recorded.
- Participants can understand why they progressed or received recognition.

## 11. Phase 8 — Expansion and Multi-Organization Platform

### Objective

Evolve Expathio from a single simulated organization into a platform supporting multiple organizations and richer participation models.

### Potential Scope

- Multiple organizations.
- Different industries.
- Additional business models.
- New departments and professional roles.
- Organization configuration.
- More advanced agent behavior.
- Multiple human participants per organization.
- Cross-department collaboration.
- Organization-specific policies.
- More advanced career paths.
- Expanded reporting and analytics.
- Advanced simulation scenarios.

### Expected Outcome

Expathio becomes a flexible platform capable of supporting different organizational environments rather than depending on the initial fashion brand.

### Exit Criteria

- Multiple organizations can operate independently.
- Organizational data remains isolated.
- Different business models can be represented.
- Participants can have different roles across organizations.
- Core simulation capabilities can be reused.
- Additional organizations do not require rebuilding the platform foundation.

## 12. Cross-Phase Engineering Practices

Some engineering practices should be introduced progressively throughout development rather than postponed until the end.

### Testing

- Unit tests for business rules.
- Integration tests for domain interactions.
- Workflow tests for complete business processes.
- Permission and security tests.
- Failure and recovery tests.

### CI/CD

- Automated validation on code changes.
- Consistent build processes.
- Database migration validation.
- Controlled deployments.
- Release history.
- Rollback planning.

### Observability

- Structured logs.
- Error tracking.
- Background job monitoring.
- Database performance monitoring.
- Simulation execution metrics.
- AI usage and cost tracking.

### Documentation

- Architecture decisions.
- Domain documentation.
- API contracts.
- Current implementation state.
- Development session handoffs.
- Known limitations.

The level of sophistication should match the current size and complexity of the project.

## 13. Scope Management

The roadmap is a strategic sequence, not a commitment to implement every feature exactly as described.

Phases may overlap when justified.

Some capabilities may be postponed, simplified, or removed after validation.

The project should avoid:

- Implementing advanced AI before reliable business workflows exist.
- Building multiple organizations before the first one works.
- Introducing distributed infrastructure without a demonstrated need.
- Developing complex rewards before meaningful work can be evaluated.
- Simulating large populations without a clear business purpose.
- Expanding the interface before understanding participant workflows.

## 14. Definition of a Successful Initial Release

The first meaningful release of Expathio should demonstrate the central product concept. It ends with Phase 5. AI capabilities (Phase 6) are not part of it.

A participant should be able to:

1. Access the platform from a computer.
2. Join the initial simulated organization.
3. Assume a professional role.
4. Receive contextual responsibilities.
5. Interact with organizational processes.
6. Produce meaningful work.
7. Communicate with coworkers.
8. Observe the consequences of decisions.
9. Return after an absence and understand what happened.

Meanwhile, the organization should:

- Maintain persistent state.
- Execute its core business workflows.
- Generate relevant events.
- Operate independently of participant presence.
- Preserve important history.
- Remain within controlled infrastructure and AI costs.

The first release does not need a large workforce, advanced AI autonomy, multiple industries, or a complex reward economy.

It needs to prove that a simulated organization can function coherently and provide a meaningful professional experience.

### Acceptance Scenarios

The first release is complete when all of the following can be demonstrated:

1. A participant applies to an open vacancy, and is assigned to the role when the application is accepted.
2. The participant opens the workspace and sees the tasks assigned to their role.
3. The participant completes a task, and the result is recorded in the organization's history.
4. An action in one department changes the state of another. For example, a sale reduces stock, and a stock shortage creates an incident for operations.
5. Simulated days advance while no participant is connected, and each day's events are recorded.
6. A participant who was absent for at least one simulated day returns to a list of the events that affected their responsibilities.
7. Restarting the application does not lose the organization's state or history.
8. Processing the same simulated day twice does not duplicate its events.

## 15. Roadmap Guiding Principle

Build the smallest coherent organization that demonstrates the Expathio vision.

Expand only when the current version works reliably and the next layer of complexity has a clear purpose.

The objective is not to build the largest possible simulation.

The objective is to build an organization that feels alive, behaves coherently, and gives participants meaningful work to do.