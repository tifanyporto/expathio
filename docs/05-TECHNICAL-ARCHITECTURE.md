# Expathio — Technical Architecture

**Status:** IN DISCUSSION  
**Document type:** Technical architecture  
**Project:** Expathio

---

## 1. Purpose

This document defines the technical principles and architectural direction of Expathio.

The architecture must support a persistent, evolving, multi-organization simulation platform in which human participants and autonomous agents interact with business processes, organizational data, and one another.

The system must be technically realistic without introducing unnecessary complexity.

The initial architecture should prioritize simplicity, maintainability, low operating costs, and the ability to evolve as the product grows.

Technology choices should support the product vision rather than dictate it.

## 2. Architectural Principles

Expathio should follow these principles. The project-wide design principles are in `00-VISION.md`, section 8; the list below applies them to the architecture.

- **Simplicity first:** Prefer the simplest architecture that satisfies current requirements.
- **Modularity:** Organize the system around clear business domains and responsibilities.
- **Persistent state:** Organizational data, events, decisions, and history must survive application restarts.
- **Consistency:** Business operations must preserve valid organizational state.
- **Extensibility:** The architecture should support new organizations, departments, roles, and simulation capabilities.
- **Cost awareness:** Infrastructure and AI usage must remain economically sustainable.
- **Observability:** Important system operations must be measurable and traceable.
- **Security by design:** Access to organizational information and operations must respect permissions and isolation.
- **Controlled autonomy:** Automated processes and AI agents must operate within explicit boundaries.
- **Incremental evolution:** Architectural complexity should increase only when justified by actual requirements.

## 3. Initial Architecture Strategy

The initial implementation should favor a **modular monolith**.

The application may run as a single deployable system while maintaining clear internal boundaries between business domains.

This approach provides:

- Simpler development and deployment.
- Lower infrastructure costs.
- Easier local development.
- Fewer distributed-system failure points.
- Clear separation of responsibilities.
- The possibility of extracting independent services later when justified.

The architecture should not begin with microservices simply because the simulated organization contains multiple departments or autonomous agents.

Business-domain separation does not require infrastructure-level separation.

### 3.1. Logical Components

The initial system may contain the following logical components:

- **Application Interface:** The participant-facing desktop experience.
- **Application API:** Handles requests, authentication, authorization, and application operations.
- **Business Domain Modules:** Implement organizational rules and workflows.
- **Simulation Engine:** Coordinates business events, scheduled activities, and autonomous behavior.
- **Agent Runtime:** Executes employee, manager, and customer agent behavior.
- **Background Workers:** Process asynchronous operations and scheduled jobs.
- **Persistence Layer:** Stores organizational state, user information, events, and history.
- **AI Integration Layer:** Provides controlled access to external AI models and providers.

These are logical responsibilities, not necessarily separate applications or servers.

## 4. Business Domain Organization

The codebase should be organized around business responsibilities rather than only technical categories.

Potential domains include:

- Identity and Access Management.
- Organizations and Membership.
- Departments and Roles.
- Employees and Agents.
- Customers and Customer Relationships.
- Products and Catalog.
- Sales and Orders.
- Inventory.
- Logistics and Fulfillment.
- Finance.
- Tasks and Workflows.
- Communication.
- Events and Simulation.
- Career Progression.
- Performance and Rewards.
- Audit and Organizational History.

Each domain should own its relevant business rules and expose well-defined operations to other domains.

For example, the inventory domain should be responsible for inventory changes. Other domains should not directly modify inventory data while bypassing its business rules.

The initial implementation does not need every domain to exist as an independent module from day one.

Domains should be introduced as the corresponding functionality becomes necessary.

The table below relates each domain to the roadmap phase in which it is first needed (see `06-ROADMAP.md`).

| Domain | First needed in |
|---|---|
| Identity and Access Management | Phase 1 |
| Organizations and Membership | Phase 1 |
| Departments and Roles | Phase 2 |
| Employees and Agents | Phase 2 (deterministic); Phase 6 (AI) |
| Customers and Customer Relationships | Phase 2 |
| Products and Catalog | Phase 2 |
| Inventory | Phase 2 |
| Sales and Orders | Phase 3 |
| Logistics and Fulfillment | Phase 3 |
| Finance | Phase 3 |
| Tasks and Workflows | Phase 4 |
| Communication | Phase 4 |
| Events and Simulation | Phase 5 |
| Audit and Organizational History | Phase 3 (first recorded transitions) |
| Career Progression | Phase 7 |
| Performance and Rewards | Phase 7 |

## 5. Organizational State and Persistence

The organization is a persistent environment.

Its state must not depend on application memory or the lifetime of an individual AI conversation.

The system must persist information such as:

- Organizations.
- Participants and memberships.
- Employees and agents.
- Customers.
- Agent memory and customer profiles.
- Departments and roles.
- Products and inventory.
- Orders and transactions.
- Tasks and deliverables.
- Communications.
- Business events.
- Decisions and approvals.
- Career progression.
- Historical records.

A relational database is a strong candidate for the primary persistence layer.

The initial architecture should favor a database capable of supporting transactional operations, relationships, constraints, and structured queries.

### 5.1. Authoritative State

The database and business-domain rules must remain authoritative.

AI agents must not become the source of truth for business information.

An agent may propose a decision or request an operation, but the application must validate that operation before changing authoritative state.

For example:

1. A customer agent requests a product purchase.
2. The application validates product availability and business rules.
3. The order is created through the appropriate business operation.
4. Inventory is updated according to the transaction rules.
5. Relevant events are generated.
6. Other processes react to those events.

This separation is essential for consistency and reliability.

## 6. Event-Driven Internal Architecture

Events are fundamental to the Expathio simulation model.

A business event represents something that happened within the organization or its external environment.

Examples include:

- An order was created.
- A payment was confirmed.
- Inventory reached a critical level.
- A customer submitted a complaint.
- A task was completed.
- A deliverable was approved.
- An employee was promoted.
- A delivery was delayed.

Events allow different business domains to react to changes without requiring every domain to know the internal implementation of every other domain.

### 6.1. Event Responsibilities

The event architecture should support:

- Recording relevant business events.
- Identifying the event source.
- Associating events with organizations.
- Tracking event timestamps.
- Identifying affected entities.
- Processing events asynchronously when appropriate.
- Handling failures and retries.
- Preventing duplicate processing.
- Preserving relevant event history.
- Distinguishing events that only record something from events that require an action (see `02-BUSINESS-SIMULATION.md`, section 7).

### 6.2. Internal Events and External Messaging

The initial implementation should distinguish between internal domain events and messages exchanged through external infrastructure.

A modular monolith can use internal event handling before introducing a dedicated message broker.

A queue or message broker may become useful when the system requires independent workers, higher throughput, stronger isolation, or more advanced delivery guarantees.

The architecture should not introduce distributed messaging infrastructure without a concrete need.

## 7. Simulation Engine

The simulation engine coordinates the ongoing activity of organizations.

It is responsible for determining when business processes and simulated actors should perform work.

Potential responsibilities include:

- Scheduling recurring business activities.
- Evaluating pending events.
- Triggering customer behavior.
- Initiating employee activities.
- Advancing business processes.
- Detecting situations requiring attention.
- Coordinating background execution.
- Maintaining simulation continuity.

The simulation engine should be logically separated from the participant interface.

An organization should continue operating even when no participant is actively connected.

### 7.1. Simulation Time

The system should distinguish between real-world time and simulation time.

This distinction allows the organization to operate at a controlled pace.

The time model is decided: the organization advances in simulated days (`docs/decisions/0001-simulation-time.md`).

### 7.2. Controlled Execution

Simulation activity must have limits.

The system should avoid generating unlimited events or processing every simulated entity continuously.

Execution frequency and workload should consider:

- Organizational activity.
- Event importance.
- Agent autonomy.
- Available resources.
- AI usage limits.
- Current simulation configuration.

## 8. Background Processing

Some operations should not execute directly within a participant's request-response cycle.

Examples include:

- Processing organizational events.
- Executing scheduled activities.
- Generating reports.
- Running simulation routines.
- Invoking AI agents.
- Sending notifications.
- Processing external integrations.

These operations should be handled through background execution mechanisms.

The initial implementation may use a lightweight worker process and a database-backed job mechanism.

A dedicated queue infrastructure can be evaluated later.

### 8.1. Reliability

Background operations should account for:

- Retries.
- Execution timeouts.
- Duplicate delivery.
- Idempotency.
- Failed jobs.
- Partial failures.
- Execution limits.
- Recovery after restarts.

A failed operation should not silently leave the organization in an inconsistent state.

## 9. AI Integration Architecture

AI providers should be accessed through a dedicated integration layer.

Business domains should not depend directly on a specific model provider.

The integration layer should handle:

- Provider communication.
- Model selection.
- Prompt and context construction.
- Structured output validation.
- Timeouts.
- Retries.
- Usage measurement.
- Cost tracking.
- Error handling.
- Execution limits.

AI responses should be treated as external input, not automatically trusted instructions.

Every AI-generated action that affects business state must pass through the appropriate application validation and authorization rules.

### 9.1. Model Abstraction

The system should make it possible to evaluate different models and providers without rewriting business logic.

Model selection should depend on the task.

Simple classification or extraction should not require the same model capabilities as complex planning or contextual decision-making.

### 9.2. Context Management

Agents should receive only the information relevant to their current activity.

The application should retrieve relevant organizational state and agent memory rather than sending complete historical conversations by default.

### 9.3. Cost Controls

AI execution should support:

- Per-organization usage tracking.
- Per-agent usage tracking.
- Per-operation usage tracking.
- Configurable limits.
- Execution prioritization.
- Model selection by complexity.
- Usage reporting.

The architecture must allow AI activity to be limited or temporarily disabled without stopping essential deterministic business processes.

## 10. Multi-Tenancy and Data Isolation

Expathio is intended to support multiple organizations.

The architecture must account for organizational data isolation from the beginning.

Participants may belong to different organizations and may occupy different roles within each one.

The system must ensure that:

- Participants can only access authorized organizations.
- Organizational data is isolated.
- Roles determine permissions.
- Agent access respects organizational boundaries.
- Cross-organization access is explicitly authorized.
- Background jobs preserve organization context.
- AI context does not accidentally mix information from different organizations.

The initial implementation may use a shared database with organization-scoped records and appropriate access controls.

The exact data isolation strategy should be validated before implementation.

## 11. Authentication and Authorization

Authentication establishes who is accessing the platform.

Authorization determines what that identity can do.

These responsibilities should remain distinct.

The permission model should consider:

- Platform-level permissions.
- Organization membership.
- Department membership.
- Professional role.
- Specific resource permissions.
- Agent permissions.
- Approval authority.

The system should follow the principle of least privilege.

A participant should only access the information and operations necessary for their responsibilities.

Authorization must be enforced by the backend, not only by hiding interface elements.

## 12. Auditability and Historical Records

Expathio requires a reliable history of important organizational activity.

The architecture should support recording:

- Business state changes.
- Important decisions.
- Task transitions.
- Approvals and rejections.
- Financial operations.
- Agent actions.
- Participant actions.
- Permission changes.
- Simulation events.

Audit records should identify the actor, operation, relevant entity, timestamp, and outcome whenever applicable.

Historical records should not be casually overwritten.

The system should distinguish between current business state and the historical record of how that state evolved.

This history should support investigation, debugging, accountability, and participant feedback.

## 13. Desktop-First Application Experience

The primary participant experience is desktop-based.

The application interface should be designed for computer use, with sufficient space for complex workflows, information, documents, and operational tools.

Smartphone usage is intentionally restricted to lightweight communication and information exchange, such as email, messages, and notifications. This is a future consideration and is not part of the initial release.

The mobile experience should not attempt to reproduce the complete desktop workstation. The primary definition of the desktop experience is in `03-USER-EXPERIENCE.md`, section 6.5.

This distinction should influence interface design and the prioritization of frontend functionality.

## 14. Security and Operational Reliability

Security must be considered across the entire application.

Important concerns include:

- Authentication and session management.
- Authorization and access boundaries.
- Input validation.
- Protection against common web vulnerabilities.
- Secure handling of secrets.
- API rate limiting.
- AI prompt injection and untrusted content.
- Protection against unauthorized agent actions.
- Database access controls.
- Backup and recovery.
- Dependency security.

The system should also account for operational failures.

Examples include:

- Database unavailability.
- AI provider outages.
- Worker crashes.
- Failed background jobs.
- Network interruptions.
- Invalid agent responses.
- External service failures.

Failure in an optional AI capability should not automatically make essential business operations unavailable.

## 15. Observability and Monitoring

The architecture should make it possible to understand what the system is doing.

Observability should cover:

- Application errors.
- API performance.
- Database performance.
- Background job execution.
- Event processing.
- Simulation activity.
- AI latency and usage.
- Failed operations.
- Resource consumption.

Important operations should have enough contextual information to be traced across their execution.

Logging should be structured and should avoid exposing sensitive information.

Metrics and traces can be introduced progressively according to operational needs.

## 16. Development, Testing, and Deployment

Expathio should follow a professional software development lifecycle.

The project should support:

- Version control.
- Consistent development environments.
- Automated tests.
- Code review practices.
- Database migration management.
- CI/CD pipelines.
- Deployment validation.
- Environment configuration.
- Rollback strategies.
- Release history.

Development, testing, and production environments should be logically separated.

Changes to the system should be reproducible and traceable.

Deployment should be treated as a controlled process rather than a manual sequence of undocumented actions.

**Status note (2026-11-05):** Continuous integration and code review are deferred. Tests run by hand before each merge, and there are no pull requests, as decided in ADR 0016 and ADR 0015. Release history (for example, version tags) is not yet defined; it is expected to be set in Phase 1 together with the deployment script.

## 17. Infrastructure and Cost Constraints

The initial infrastructure should prioritize low fixed costs.

The architecture should be capable of beginning with local development and a minimal hosted environment when deployment becomes necessary.

Potential infrastructure components include:

- Application hosting.
- Relational database.
- Background worker.
- Scheduled execution.
- File storage.
- Monitoring.
- External AI provider.

These components do not necessarily need independent infrastructure during the initial stage.

The architecture should avoid requiring continuously running expensive services before the product demonstrates a need for them.

The initial cost target is as close to zero as reasonably possible.

Future infrastructure decisions should consider a possible operating budget of approximately R$100–R$200 per month, while recognizing that sustained AI usage and increased simulation activity may exceed this amount.

Cost projections must be based on realistic workload assumptions rather than optimistic estimates.

## 18. Evolution Strategy

The architecture should evolve in response to demonstrated requirements.

Potential future changes include:

- Separating background workers from the main application.
- Introducing a dedicated message broker.
- Scaling simulation execution independently.
- Extracting specific domains into services.
- Introducing caching.
- Improving database partitioning or indexing.
- Supporting more advanced event processing.
- Introducing dedicated AI orchestration infrastructure.

These are possible evolution paths, not initial implementation requirements.

Every increase in architectural complexity should have a clear justification.

## 19. Open Technical Decisions

### 19.1. Decided

| Area | Decision | Record |
|---|---|---|
| Backend language and framework | TypeScript; NestJS 12 | ADR 0012, ADR 0013 |
| Frontend framework | React 19, Vite 8, TanStack Query 5, for a web application | ADR 0012, ADR 0014 |
| Primary database | PostgreSQL, in Docker on the Windows computer. The phone's version must match and is not yet checked | ADR 0014, ADR 0015 |
| Database access | Drizzle ORM 0.45 | ADR 0013 |
| Background job mechanism | pg-boss 12.38.0, using the PostgreSQL database | ADR 0014 |
| Authentication strategy | better-auth 1.7.15, self-hosted, account data in the project's database | ADR 0012, ADR 0014 |
| Testing strategy | Three levels: business rules, integration with PostgreSQL in Docker, browser flows; tests pass before each merge | ADR 0014, ADR 0016 |
| Source code layout | One package with `server/`, `web/`, `shared/` and `ops/` | ADR 0019 |
| Initial host | POCO F3 running postmarketOS, through Phase 3 | ADR 0011, ADR 0018 |
| Initial deployment | Script copies the tested version to the phone, applies migrations, restarts, runs a health check; one process serves the API and the web files | ADR 0016, ADR 0019 |
| Backup (part of the item) | Daily backup kept off the device | ADR 0011 |

### 19.2. Still open

- **CI/CD tooling.** Deferred until the project has code, as confirmed by the owner on 2026-11-05 (ADR 0016). Tests are run by hand before each merge. CI cannot reach the phone, so deployment stays with the script (ADR 0011).
- **Monitoring and observability tooling.** Not decided. Section 15 lists what should be observed.
- **File storage.** The abstraction is decided (ADR 0010: business code does not depend on local paths). The storage location and its technology are not.
- **AI providers and model selection.** Not decided. AI starts in Phase 6 (ADR 0003), with a monthly budget of R$ 0 (ADR 0004).
- **Event processing strategy.** Background jobs are decided (ADR 0014) and idempotency is required (ADR 0010). How business events are recorded and routed is not decided.
- **Hosting provider for Phase 4.** Not decided. Required before the first participant is admitted (ADR 0011).
- **Backup and recovery.** The daily off-device backup is decided (ADR 0011). The restore procedure, retention period and a tested restore are not.
- **Deployment topology beyond the initial phone.** Not decided. Running more than one application instance or separate worker processes needs a new decision (ADR 0010, ADR 0019).

Technology selection should consider developer productivity, ecosystem maturity, operational cost, maintainability, and the learning objectives of the project.

## 20. Architectural Guiding Principle

Expathio should not attempt to simulate a large distributed enterprise infrastructure before it needs one.

It should begin as a well-structured application with clear business boundaries, reliable persistence, controlled asynchronous execution, and selective AI integration.

The system should become more sophisticated as organizational complexity and real operational requirements increase.

## 21. Technical Risk Register

The risk register lists technical risks that could damage data, availability, cost or schedule. It is reviewed at the end of each phase and whenever a risk materializes.

Format: each risk has an impact and a probability, rated low, medium or high, and an action that reduces the risk.

| Risk | Impact | Probability | Action |
|---|---|---|---|
| The phone loses power, network or stops responding | High | Medium | Keep it plugged in; test restart and recovery steps before Phase 1 ends; check status after each deployment |
| Data is lost without a usable backup | High | Medium | Daily backup kept off the device (ADR 0011); test a restore before real use |
| Real participant data is stored before the hosting decision | High | Low | Block it by process: no participant data before the Phase 4 hosting decision (ADR 0011) |
| Private access to the phone is exposed to the public internet | High | Low | Private access only (ADR 0011); no open ports; SSH key login only |
| A change breaks the production phone | High | Medium | Tests must pass before merge; deployment script stops on failed health check; keep previous version for rollback (ADR 0016) |
| PostgreSQL or Node.js versions differ between Docker and the phone | Medium | Medium | Verify versions before Phase 1; align them or record the difference (ADR 0015) |
| better-auth is not confirmed compatible with NestJS 12 | Medium | Medium | Confirm compatibility before implementing login (ADR 0014) |
| A library makes a breaking change or stops being maintained (Drizzle, NestJS, Vitest 5) | Medium | Low | Lock versions; upgrade only through a deliberate change; fall back to Vitest 4.1 if needed (ADR 0014) |
| Phone battery wears out or overheats under continuous use | Medium | Medium | Use a charge limit if postmarketOS supports it; monitor temperature; plan battery replacement |
| Development time is shorter than planned (5 to 10 hours a week) | Medium | High | Keep phases small; finish each phase's exit criteria before starting the next |
| Wrong import between `server/`, `web/` and `shared/` (ADR 0019) | Medium | Medium | Follow the import rules in ADR 0019; check imports in review before each merge; a lint rule is an open option that needs owner approval |
| ESM (modern JavaScript module system) configuration breaks the build or the server start (ADR 0019) | Medium | Medium | Set the module and import conventions in the Phase 1 TypeScript configuration; run build and start before each merge (ADR 0016) |
| Development dependencies are installed on the production phone (ADR 0019) | Medium | Medium | The deployment script installs production dependencies only (`npm ci --omit=dev`) and checks it as a deployment step (ADR 0016) |

The goal is to build an architecture capable of supporting a living simulated organization without making the infrastructure more complicated than the organization itself.
