# Expathio

Expathio is a platform that simulates a living company. People enter the company, take on a professional role, and do work that has consequences for the business, which keeps running whether or not they are online.

The first simulated company is **MONUMENT**, a streetwear brand with an online store and two physical stores. Participants may work in areas such as operations, customer service, sales analysis and finance.

## Status

Expathio is a personal learning and experimentation project. It is not a commercial product or a startup at this stage, although that possibility is not ruled out for the future. There is no application code yet; the project is in its documentation and planning phase.

## Intent

- Let people experience real professional work: responsibilities, deadlines, customers, and problems that come from other departments.
- Keep the organization active on its own, with customers, orders, incidents and events, without waiting for a participant to act.
- Grow from one company to several, without redesigning the platform.

## Planned technology

These choices are approved and recorded in [`docs/decisions/`](docs/decisions/). Nothing is implemented yet.

- **Language:** TypeScript, for both backend and frontend.
- **Backend:** NestJS, with Drizzle ORM and PostgreSQL.
- **Frontend:** React, built with Vite, with TanStack Query.
- **Background work and login:** pg-boss for background jobs, better-auth for login.
- **Testing:** Vitest for business rules and integration tests, Playwright for browser flows.
- **Local development:** Docker, running PostgreSQL on the developer's Windows computer.
- **Hosting:** a single phone running Linux (postmarketOS), reached only over a private network. Real participant data is not allowed there until the hosting decision for that phase is made.

## Documentation

All project documentation is in [`docs/`](docs/). Start with:

- [`docs/CURRENT_STATE.md`](docs/CURRENT_STATE.md): what exists, what is in progress and what is open.
- [`docs/00-VISION.md`](docs/00-VISION.md): what Expathio is and why it exists.
- [`docs/GLOSSARY.md`](docs/GLOSSARY.md): definitions of the terms used across the documents.
