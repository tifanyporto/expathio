# ops/

Deployment and environment files for Expathio, owned by the Infrastructure and Operations session (`docs/SESSION-STRUCTURE.md`, section 3.3; ADR 0019).

Start with [`local-setup.md`](local-setup.md) to set up the Windows development computer.

| File | Purpose |
|---|---|
| `local-setup.md` | Step-by-step guide for the local development environment. |
| `docker-compose.yml` | Local PostgreSQL in Docker (ADR 0015). |
| `.env.example` | Template for `ops/.env`. Contains no secret. Copy it to `.env` and never commit `.env`. |
| `.nvmrc` | Node.js major version used by the project (`24`). |
| `check-local.ps1` | Local checks (Node, Docker, Compose file, container health, port). |

Not in this folder yet: the phone deployment script and runbook (ADR 0016). They wait for owner access to the phone.
