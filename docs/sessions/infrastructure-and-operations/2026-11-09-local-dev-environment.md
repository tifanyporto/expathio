# 2026-11-09 — Local Development Environment

## Goal

Make the Windows development environment reproducible, as ADR 0015 requires: a Docker setup for local PostgreSQL, the Node.js version to use locally, and a setup guide in `ops/` (ADR 0019) that the owner can follow step by step. Propose the local part of Q-007. The phone part stays open.

This session did not touch the production phone and did not change `server/`.

## Scope

**In scope (function: Infrastructure and Operations, `docs/SESSION-STRUCTURE.md`, section 3.3):**
- Local Docker setup for PostgreSQL on the Windows computer.
- Local Node.js version and its pin file.
- Setup guide and local check script in `ops/`.
- Q-007 entry in `docs/OPEN-QUESTIONS.md`, local part only.

**Out of scope (left out on purpose):**
- The phone: no commands on it, no configuration, no deployment script, no runbook. It is not reachable now (ADRs 0011 and 0018).
- Any change to `server/` (Platform Engineering works there in parallel) and to `web/`, `shared/`.
- Installing software. Docker Desktop is approved by ADR 0015 but the owner installs it; nothing else was installed.
- Changing or stopping the Windows PostgreSQL 16 service. That is the owner's decision.
- Status updates in `docs/CURRENT_STATE.md`. Owned by Product and Documentation (see Pending).

## Documents Read

1. `C:\expathio\CLAUDE.md` (outside the repository; git-ignored).
2. `docs/CURRENT_STATE.md`
3. `docs/06-ROADMAP.md`, section 4 (Phase 1 scope, item 1: reproducible environments).
4. `docs/decisions/0011-initial-host.md`
5. `docs/decisions/0015-development-environment-and-repository.md`
6. `docs/decisions/0016-testing-and-deployment-strategy.md`
7. `docs/decisions/0018-dedicated-production-phone.md`
8. `docs/decisions/0019-phase-1-code-layout.md`
9. `docs/OPEN-QUESTIONS.md`, entry Q-007
10. `docs/SESSION-STRUCTURE.md`, section 3.3
11. `docs/05-TECHNICAL-ARCHITECTURE.md`, section 19 (open technical decisions)
12. `docs/sessions/TEMPLATE.md`
13. `.gitignore` (to confirm `ops/.env` is ignored)

Also looked at the shared notes folder outside the repository. It holds notes from two other projects (not Expathio). They were not used and their content is not copied here.

## Environment Check (real output, 2026-11-09)

Commands were run on the Windows computer from the repository worktree.

| Item | Command | Result |
|---|---|---|
| Node.js | `node --version` | `v24.12.0` |
| npm | `npm --version` | `11.6.2` |
| psql client | `psql --version` | `psql (PostgreSQL) 16.13` |
| Docker | `docker version` | **not recognized**: Docker is not installed |
| Docker Compose | `docker compose version` | not run: no Docker |
| pnpm | `Get-Command pnpm` | not found |
| Git | `git` on PATH | `C:\Program Files\Git\cmd\git.exe` |
| WSL | `wsl --list --verbose` | Ubuntu, version 2, stopped |
| PostgreSQL server | `Get-Service` | `postgresql-x64-16`, **Running** (Windows install) |
| Port 5432 | `Test-NetConnection 127.0.0.1 -Port 5432` | **open** (used by the Windows PostgreSQL 16 service) |
| Port 5433 | `Test-NetConnection 127.0.0.1 -Port 5433` | closed (free for Docker) |

Findings:
- Docker is the missing piece. ADR 0015 requires it, and it has not been installed.
- A Windows PostgreSQL 16 server runs on port 5432. ADR 0015 rejected native PostgreSQL in favor of Docker, so this install is outside the decided setup. The Docker database therefore uses host port 5433.

## Files Changed

All files are new unless noted. The repository worktree is `claude/phase-1-dev-environment-d7811f`.

| File | What it is, in plain language |
|---|---|
| `ops/docker-compose.yml` | The recipe Docker Compose reads to start the local database: image `postgres:18.4`, host port 5433 (only this computer can reach it), a named volume that keeps data between restarts, and a health check that asks the database if it is ready. It reads the password from `ops/.env`, and stops with a clear message if the password is missing. |
| `ops/.env.example` | Template for the settings file. It contains the names of the database and user and the port, and an **empty** password line. It has no secret. |
| `ops/.nvmrc` | One line, `24`: the Node.js major version the project uses. Version managers read this file. |
| `ops/local-setup.md` | The guide for the owner, step by step: check Node, install Docker Desktop, create `ops/.env`, start the database, check the version, run the check script, stop or reset. Each step has the expected output and what to do on failure. |
| `ops/check-local.ps1` | A PowerShell script that checks Node's major version, the Docker engine, the Compose file, the container health and the port. It prints one line per check and exits with the number of failed checks. It never prints the password. |
| `ops/README.md` | Short index of the `ops/` folder. |
| `docs/OPEN-QUESTIONS.md` | Q-007 changed to IN DISCUSSION, with the local proposal and the owner-only phone part. The other entries are unchanged. |
| `docs/sessions/infrastructure-and-operations/2026-11-09-local-dev-environment.md` | This record. |

`ops/.env` is **not** created by this session. Git ignores it (`.gitignore`, line 2: `.env`). Checked with `git check-ignore`; the output is in "Tests and Results".

## Decisions

- **Proposed (not approved):**
  - PostgreSQL **18.4** in Docker, for local development. Alternative: 17.
  - Node.js **24** locally. Alternative: 26, once confirmed as LTS on nodejs.org.
  - Docker host port **5433**, because the Windows PostgreSQL 16 service uses 5432. This is a local detail, decided here, and reported.
  - The setup guide is written in **English**, as internal documentation (`CLAUDE.md`, section 9). A Portuguese version can be made if the owner wants one.
- **Approved by the owner:** none in this session. Q-007 is waiting for the owner's answer.
- **Already approved and used as they are:** Docker Desktop and WSL 2 (ADR 0015), the folder `ops/` and the owner of its guides (ADR 0019 and `SESSION-STRUCTURE.md`, section 3.3), PostgreSQL in Docker with its major version matching the phone (ADR 0015).

## Tests and Results

What was run, with the actual result.

1. **`powershell -ExecutionPolicy Bypass -File .\ops\check-local.ps1`** — exit code **4**. Output:
   ```
   [OK  ] Node.js major version - found v24.12.0, expected major 24
   [FAIL] Docker engine - docker is not installed (ops/local-setup.md, section 2)
   [FAIL] Compose file - skipped: Docker engine not available
   [FAIL] PostgreSQL container health - skipped: Docker engine not available
   [FAIL] PostgreSQL port - 127.0.0.1:5433
   Summary: 4 check(s) failed.
   ```
   The script works. Its failures are correct for this computer: Docker is not installed and the container does not exist yet. **The Docker part is not verified.**

2. **`docker version`** — not recognized as a command. Docker is not installed.

3. **`docker compose config --quiet`** — not run: no Docker. **The compose file has not been validated by Docker.**

4. **Structure check of `docker-compose.yml`** with `node` (text search for `image: postgres:18.4` and the port default `5433`): both found. This is only a text check. A YAML parser was not run: PyYAML is not installed in Python, and no package was installed to check it.

5. **`git check-ignore -v ops/.env ops/.env.example`** — output:
   ```
   .gitignore:2:.env	ops/.env
   .gitignore:4:!.env.example	ops/.env.example
   ```
   `ops/.env` is ignored. `ops/.env.example` is tracked on purpose.

6. **Port 5433** — closed before Docker starts (expected).

**Not verified (all depend on Docker being installed):** the image `postgres:18.4` exists and downloads; the container starts; the health check passes; `psql` connects on 5433 and reports the version; `docker compose config` accepts the file. The guide says these steps are for the owner to run. Nothing here is declared working.

Version facts come from web search (secondary sources, not the official sites). PostgreSQL: 18.6 and 17.11 were the latest minors named by secondary sources as of October 2026; the postgresql.org versioning page was not opened. Node: Node 24 maintenance from October 2026 and Node 26 LTS from October 2026, per secondary sources; nodejs.org was not opened. Both must be checked on the official sites before the owner approves.

## Pending

- **Owner (needs a physical action):** install Docker Desktop with WSL 2, following `ops/local-setup.md`, section 2. Then run the guide and `check-local.ps1`, and send the output.
- **Owner decision (Q-007):** approve or change PostgreSQL 18.4 and Node 24 for the local computer.
- **Owner decision (not in Q-007):** the Windows PostgreSQL 16 service on port 5432. Keep it, stop it, or remove it. ADR 0015 chose Docker, and the Expathio database does not use this service. This session did not change it.
- **Phone part of Q-007 — OWNER-ONLY, OPEN.** Not planned now. When phone access returns: check the PostgreSQL major and Node.js version on the phone, and whether the PostgreSQL major matches Docker (ADR 0015). The phone is not touched in this session (ADRs 0011, 0018).
- **Pinning the exact PostgreSQL minor:** check the latest minor on postgresql.org before the first download, and update `ops/docker-compose.yml` if needed.
- **Handoff to Product and Documentation:** `docs/CURRENT_STATE.md` should say that the local environment is proposed here and Q-007 is in discussion. Not edited by this session (owned by Product and Documentation).
- **Handoff to Architecture and Quality:** `docs/05-TECHNICAL-ARCHITECTURE.md`, section 19.1, still says the phone's PostgreSQL version "is not yet checked". Still true; no change here.
- **Phase 1 deployment script and runbook (ADR 0016):** not started. They depend on the phone and on the Platform Engineering start/migration commands.
- **Language of the guide:** English was chosen; the owner may want Portuguese. Question to the owner.

## How to Resume

Read in this order:

1. `C:\expathio\CLAUDE.md`, `docs/CURRENT_STATE.md`.
2. This record.
3. `ops/local-setup.md` (the guide the owner follows).
4. `docs/OPEN-QUESTIONS.md`, entry Q-007.

Starting point: the owner installs Docker Desktop and runs the guide. Then the session runs `ops/check-local.ps1` again and records the output here. Until then, the Docker part is unverified.

Already decided, do not ask again: Docker for local PostgreSQL (ADR 0015); the phone is production and is out of reach (ADR 0011, 0018); no secrets in the repository; the folder `ops/` belongs to this function (ADR 0019).

Do not change: `server/` (Platform Engineering works there), the phone, the Windows PostgreSQL 16 service.

## Next Step

1. The owner installs Docker Desktop (guide, section 2), creates `ops/.env` (section 3), and runs `docker compose up -d` (section 4). Then the owner sends the output of `docker compose ps`, `psql ... "SELECT version();"` (section 5) and `check-local.ps1`.
2. The owner answers Q-007 (approve PostgreSQL 18.4 and Node 24, or choose other versions).
3. After that, this session re-runs the checks and records the real results. It then checks the official version pages and updates the pin if needed.
