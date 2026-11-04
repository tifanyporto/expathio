# Expathio — Session Structure

**Status:** APPROVED  
**Document type:** Work organization  
**Project:** Expathio

---

## 1. Purpose

Expathio is built through working sessions. Each session has one function, like an employee responsible for one area of a company. A session acts only inside its function, records what it finds outside it, and passes that to the project owner. The owner decides scope and priorities.

This document maps the sessions needed to build the project, their responsibilities, limits, owned documents and dependencies. It follows the rule in `CLAUDE.md`, section 14.

The structure is kept small on purpose. A session is added only when a phase needs a specialty that no existing session covers.

## 2. Working Rules

- A session starts by reading `CLAUDE.md`, `docs/CURRENT_STATE.md`, its own function in this document, and the latest record in its function's folder under `docs/sessions/`.
- Records go in `docs/sessions/<function-folder>/`, one folder per function: product-and-documentation, architecture-and-quality, infrastructure-and-operations, platform-engineering, frontend-engineering and experience-and-design. A folder is created when its function becomes active.
- A session changes only the files listed under its own function.
- Work that belongs to another function is written as a handoff in the session record, under "Pending", with the target function named. The owner routes it.
- Sessions do not message each other. Information moves through documents, session records and the owner.
- Decisions are recorded by the function that owns the subject, and approved by the owner (`CLAUDE.md`, section 5).
- A session that finds a contradiction between documents records it in `docs/CURRENT_STATE.md` and asks the owner. It does not pick a side.

## 3. Sessions Active Now

### 3.1. Product and Documentation

**Role:** The product's written record. Keeps the vision, product rules, the simulated company's definition and the roadmap consistent.

**Responsibilities:**
- Keep the product documents accurate and in line with approved decisions.
- Prepare product choices for owner approval, with alternatives and a recommendation.
- Maintain the project state and the session index.
- Check that documents use the status convention in `CLAUDE.md`, section 4.

**Limits:**
- Does not choose technology, architecture or hosting.
- Does not write application code.
- Does not decide business or commercial questions. Those go to the owner (`docs/00-VISION.md`, `docs/01-PRODUCT.md`).

**Owned documents:**
- `docs/00-VISION.md`
- `docs/01-PRODUCT.md`
- `docs/02-BUSINESS-SIMULATION.md`
- `docs/06-ROADMAP.md`
- `docs/08-COMPANY.md`
- `docs/GLOSSARY.md`
- `docs/CURRENT_STATE.md`
- `docs/SESSION-STRUCTURE.md`
- `README.md`
- Product decision records (ADRs about the product, such as 0001 to 0009).

**Dependencies:**
- Architecture and Quality: when a product rule has a technical cost.
- Experience and Design: when a product rule affects screens.
- Owner: for every product decision.

### 3.2. Architecture and Quality

**Role:** Technical direction. Keeps the architecture coherent, records technical decisions, defines how the software is tested and deployed, and keeps the risk register.

**Responsibilities:**
- Maintain the technical architecture and the list of open technical decisions.
- Prepare technical options with cost (monthly and maintenance effort), as `CLAUDE.md`, section 8, requires.
- Write technical decision records (ADRs 0010 onward) after owner approval.
- Define testing standards and the test levels, and keep the risk register.
- Review that each area's work follows the approved architecture. This is a check of the documents, not of other sessions' code.

**Limits:**
- Does not implement features, modules, screens or deployment scripts.
- Does not add a technology, dependency or paid service without owner approval.

**Owned documents:**
- `docs/05-TECHNICAL-ARCHITECTURE.md`, including the risk register (section 21).
- `docs/decisions/` entries about technical subjects (ADRs 0010 onward).
- Testing and deployment standards (ADR 0016).

**Dependencies:**
- Platform Engineering, Frontend Engineering, Infrastructure and Operations: receive the standards and answer questions on them.
- Product and Documentation: for product rules that change architecture.

### 3.3. Infrastructure and Operations

**Role:** Keeps the environments working. Owns the Windows development setup, the local PostgreSQL in Docker, the POCO F3 phone as production host, backups, and the deployment process.

**Responsibilities:**
- Configure and verify the phone (postmarketOS, PostgreSQL and Node.js versions, private access, power, backup) following ADR 0011.
- Check that the PostgreSQL version in Docker matches the phone (ADR 0015).
- Build the deployment script and its health check (ADR 0016), in Phase 1.
- Keep the operational runbook: how to restart, restore a backup and roll back.

**Limits:**
- Does not write application features.
- Does not expose the phone to the public internet (ADR 0011).
- Does not run commands on the phone that change its configuration without the owner's approval for that step.

**Owned documents:**
- `docs/runbooks/` (to be created when the first runbook is needed).
- Deployment and environment scripts, in a folder named `ops/` (to be created in Phase 1).
- Environment configuration templates, without secrets.

**Dependencies:**
- Architecture and Quality: for deployment standards and risk entries.
- Platform Engineering: for the migration and start commands the deployment runs.
- Owner: for any physical action on the phone or the Windows computer.

### 3.4. Platform Engineering

**Role:** Builds the server side: the backend application, the database schema and migrations, login, background jobs and the access rules that protect organization data.

**Responsibilities (from Phase 1):**
- Create the backend project with NestJS and Drizzle (ADR 0013).
- Design the database schema and its migrations.
- Implement login with better-auth and organization membership (ADR 0014).
- Enforce access rules and data isolation by organization (ADRs 0010 and the roadmap's Phase 1 exit criteria).
- Write unit and integration tests for the rules it implements (ADR 0016).
- Explain each part of the code to the owner, as `CLAUDE.md`, section 6, requires.

**Limits:**
- Does not build screens. Interfaces belong to Frontend Engineering.
- Does not change the deployment process or the phone configuration.
- Does not decide business rules. Those come from Product and Documentation.

**Owned documents:**
- Backend source code and tests (folder to be defined in Phase 1).
- Database schema and migration files.
- API contract documents, written with Frontend Engineering.
- Its own session records.

**Dependencies:**
- Architecture and Quality: standards and decisions.
- Frontend Engineering: API contracts, agreed in writing before each change.
- Infrastructure and Operations: runtime setup and migration commands.
- Product and Documentation: business rules.

### 3.5. Frontend Engineering

**Role:** Builds the web application the participant uses: the layout, navigation, forms and the data loading from the backend.

**Responsibilities (from Phase 1):**
- Create the frontend project with React and Vite, and data loading with TanStack Query (ADR 0014).
- Build the application layout and navigation following the approved visual direction.
- Connect screens to the API contracts.
- Write component tests and the browser flow tests for the screens it builds (Playwright, ADR 0014).
- Explain each part of the code to the owner.

**Limits:**
- Does not decide visual identity, colors or typography. Those belong to Experience and Design.
- Does not change business rules or enforce access rules in place of the backend. Hiding a button is not access control (`CLAUDE.md`, section 10).
- Does not change the API without agreement with Platform Engineering.

**Owned documents:**
- Frontend source code and tests (folder to be defined in Phase 1).
- Its own session records.

**Dependencies:**
- Experience and Design: tokens, layout and component rules.
- Platform Engineering: API contracts.
- Architecture and Quality: standards.

### 3.6. Experience and Design

**Role:** Defines how the product looks and behaves for participants: the interaction model, screen structure and the design system.

**Responsibilities:**
- Maintain the participant experience direction in `docs/03-USER-EXPERIENCE.md`.
- Define the visual system in `docs/09-DESIGN-SYSTEM.md`: colors, type, spacing, components, and their states.
- Check that screens follow the visual direction and avoid the generic patterns listed in `CLAUDE.md`, section 12.

**Limits:**
- Does not write code. Frontend Engineering implements the design.
- Does not decide product features. Those come from Product and Documentation.

**Owned documents:**
- `docs/03-USER-EXPERIENCE.md`
- `docs/09-DESIGN-SYSTEM.md`

**Dependencies:**
- Product and Documentation: for which features exist.
- Frontend Engineering: feasibility of each design element.

**Activation:** before the first screen is built in Phase 1. Until then the design direction in `docs/03` and `docs/09` remains a direction, not a specification.

## 4. Sessions Planned for Later Phases

These functions are planned but not active. Each is created only when its phase starts and the owner approves it. The entries below use the same structure as the active sessions, so the scope is fixed in advance. Details may change when the phase starts.

### 4.1. Simulation Engine

**Phase:** 5 (`06-ROADMAP.md`, section 8).

**Role:** Makes the organization run on its own. Owns the simulated day, scheduled processes, the generation of business events, and the rules that let the simulation continue while no participant is connected.

**Responsibilities:**
- Implement the simulated day cycle and the shared timeline (ADR 0001).
- Schedule and run background processes, with retries and idempotency (ADR 0010, `05`, section 8).
- Generate probabilistic customer and business activity within configured limits.
- Ensure processing the same simulated day twice does not duplicate events (`06-ROADMAP.md`, section 14).
- Record the activity history that participants see on return.

**Limits:**
- Does not decide the business rules of each department. Those come from Product and Documentation.
- Does not build screens for the history. That belongs to Frontend Engineering.
- Does not give simulated actors AI behavior. That belongs to AI Integration.

**Owned documents (planned):**
- Simulation mechanics sections of `docs/02-BUSINESS-SIMULATION.md`, with Product and Documentation as the approver of content.
- Simulation source code and tests (folder to be defined).

**Dependencies:**
- Platform Engineering: background job infrastructure and the database. May be merged into Platform Engineering if the scope stays small.
- Product and Documentation: business rules and simulation principles.
- Architecture and Quality: standards, and the risk register entries for simulation failures.

**Activation:** after the Phase 3 business workflows exist. Merging into Platform Engineering is the default if the work is small; the owner decides at activation.

### 4.2. AI Integration

**Phase:** 6 (`06-ROADMAP.md`, section 9).

**Role:** Adds AI-driven behavior to selected manager and employee roles, under bounded autonomy. Owns the AI layer that connects the application to model providers.

**Responsibilities:**
- Build the AI integration layer, with a model abstraction and context control (`05`, section 9).
- Define each agent's role and permissions before any agent acts (ADR 0003).
- Validate every AI action before it changes business state.
- Measure AI usage and cost, and enforce the budget (ADR 0004).
- Make AI failures non-blocking for essential operations (`05`, section 14).

**Limits:**
- Does not give agents autonomy level 4 (ADR 0003: out of scope).
- Does not spend money on AI without an approved budget change (ADR 0004).
- Does not run local language models (`CLAUDE.md`, section 8).

**Owned documents (planned):**
- `docs/04-AI-AGENTS.md`.
- AI integration source code and tests (folder to be defined).

**Dependencies:**
- Platform Engineering: the services and permissions AI actions use.
- Simulation Engine: the events agents react to.
- Product and Documentation: which roles get agents.
- Architecture and Quality: AI risks and cost controls.

**Activation:** after the Phase 5 simulation runs reliably. The owner must approve the AI provider and budget at that time (`CLAUDE.md`, section 2).

### 4.3. Progression and Rewards

**Phase:** 7 (`06-ROADMAP.md`, section 10).

**Role:** Designs and implements how participants progress: performance history, evaluations, promotions and fictional compensation.

**Responsibilities:**
- Define the performance evaluation criteria and make them traceable to observable results (ADR 0007).
- Record professional history, promotions and compensation changes.
- Implement role transitions within the rules of ADR 0007 (role changes after the first release).
- Keep progression understandable to the participant: each change must show its reason.

**Limits:**
- Does not define profit-sharing or real financial rewards. Those are long-term product decisions (`07-PROGRESSION-AND-REWARDS.md`, section 9).
- Does not start before meaningful work can be evaluated (`06-ROADMAP.md`, section 13).

**Owned documents (planned):**
- `docs/07-PROGRESSION-AND-REWARDS.md`.
- Progression source code and tests (folder to be defined).

**Dependencies:**
- Product and Documentation: progression rules and the product's reward model.
- Platform Engineering: persistence of history and roles.
- Simulation Engine: the events that feed evaluations.
- Experience and Design: how progression appears to the participant.

**Activation:** after Phase 6 is delivered, or earlier if the owner decides progression is needed first.

### 4.4. Phase 8 (Multiple Organizations)

Not mapped yet. The Phase 8 scope (`06-ROADMAP.md`, section 11) affects data isolation and platform structure, so it will be mapped when Phase 7 is complete, with the owner's decisions on multi-organization data.

## 5. Dependency Map

```
Product and Documentation
   |        |
   v        v
Architecture and Quality --> Platform Engineering --> Frontend Engineering
   |                              |                        ^
   v                              v                        |
Infrastructure and Operations   (API contracts)     Experience and Design
```

Reading the map: an arrow means "gives input to". Every arrow goes through documents or through the owner. No session writes into another session's area.

## 6. Build Order Against the Roadmap

| Roadmap phase | Sessions working |
|---|---|
| Phase 0 (now) | Product and Documentation; Architecture and Quality; Infrastructure and Operations |
| Phase 1 | Platform Engineering; Frontend Engineering; Experience and Design (before the first screen); the three active sessions above |
| Phase 2 | Product and Documentation (organization content); Platform Engineering; Frontend Engineering |
| Phase 3 | Product and Documentation (workflow rules); Platform Engineering; Frontend Engineering |
| Phase 4 | All active sessions; Experience and Design leads the workspace design |
| Phase 5 | Simulation Engine (new, or merged into Platform Engineering) |
| Phase 6 | AI Integration (new) |
| Phase 7 | Progression and Rewards (new) |

## 7. Decisions Taken on the Structure

Approved by the owner on 2026-11-04:

- The local Docker setup belongs to Infrastructure and Operations, since it owns the environments.
- Experience and Design is a separate session from Frontend Engineering, so the design is not approved by the session that builds it.

Still open, to be decided when Phase 1 starts and the repository is created:

- Where the source code folders live (`apps/` and `packages/` are common).
