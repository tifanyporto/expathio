# 2026-11-17 — Phone Check and Operations Scripts

**Status of this record:** steps 1 to 5 done as far as possible without changes to the phone; pending items below.

## Goal

1. Check the production phone, read-only.
2. Write the Q-007 proposal (PostgreSQL and Node.js versions for the phone and Docker).
3. Write and test, on a local container, the procedure that creates the two database roles of ADR 0032.
4. Write the deployment script, health check and rollback documentation (ADR 0016, Q-009), tested on a local target.
5. Prepare the home computer.

## Scope

In scope: function Infrastructure and Operations (`docs/SESSION-STRUCTURE.md`, section 3.3). Branch `phase-1-dev-environment`.

Out of scope: any change to the phone (each change needs the owner's approval for that step), application code, the containers `expathio-postgres` and `expathio-postgres-dev`.

## Documents Read

`CLAUDE.md`; `docs/CURRENT_STATE.md`; ADRs 0011, 0015, 0016, 0018; ADR 0031 (from branch `docs/phase-1-completion-criteria`); ADR 0032 with amendments 1 and 2 (from branch `docs/arch-database-proposal`); `docs/OPEN-QUESTIONS.md` (Q-007, Q-009); `docs/SESSION-STRUCTURE.md`, section 3.3; the previous record `2026-11-09-local-dev-environment.md`; `ops/`.

**Found:** ADRs 0031 and 0032 are approved but exist only on their own branches. They are not on `main` nor on `phase-1-dev-environment`. Handoff to Product and Documentation (merge or record in `CURRENT_STATE.md`).

## Machine Used

This session ran on the **home computer**, not on the computer of the 2026-11-09 record. Real output:

- Docker Desktop installed per user (client 29.9.2). The engine was **not running**: `failed to connect to the docker API`. The containers `expathio-postgres` and `expathio-postgres-dev` belong to the other computer and could not be seen here.
- Node.js `v22.17.0` (the project pins major 24 in `ops/.nvmrc`).
- Tailscale installed and connected.

## Step 1 — Phone Check (read-only)

**Access.** The phone answers SSH on the home network and on Tailscale (`OpenSSH_10.6`, same server on both). The key of the home computer is not accepted; the login needs the phone password. The owner typed the password in a terminal tab; the session never saw or typed it. The commands were sent as one read-only script (`cat`, `ls`, `apk info`, `apk search`, `systemctl list-units`, `df`, `tailscale status`). The first attempt failed with `syntax error: unexpected "("` because Windows PowerShell strips quotes passed to `ssh`; the second attempt sent the same script encoded in base64 and ran completely.

Network names and addresses are not written here (ADR 0018).

**Results (real output, 2026-11-17):**

| Item | Result |
|---|---|
| Operating system | `PRETTY_NAME="Nura edge"`, `ID=nura`, `ID_LIKE=alpine`, support URL on the postmarketOS GitLab. Package sources: postmarketOS main and its systemd extra repository, Alpine edge main, community and testing. A rolling (edge) line, with systemd. |
| Kernel | `6.19.6-pipa` |
| PostgreSQL installed | **No.** `apk info` lists no `postgresql` package; `postgres` and `psql` not found; `/var/lib/postgresql` does not exist. |
| Node.js installed | **No.** `node: not found`; no `nodejs` package. |
| Versions in the local package index | `postgresql16-16.15-r0`, `postgresql17-17.11-r0`, `postgresql18-18.6-r0`, `nodejs-24.22.1-r1`, `nodejs-current-26.12.1-r2`. The index was not refreshed; the versions are those of the last update on the phone. |
| Device renamed to `expathio` (ADR 0018) | **No.** The host name and the Tailscale name are still the old project's name. The splash screen "Expathio Server" is a separate service (`expathio-standby.service`, "screen off, splash on the power button"), set up by the owner. |
| Old project removed (ADR 0018) | **Partly verified.** Running services are system services, Tailscale, SSH and `expathio-standby`. `/opt` and `/srv` are empty. `/home/user` holds only `.config`, `.profile`, `.ssh`, `.tmux.conf`. No database. Not checked: other users, `/etc` contents, systemd timers, `/etc/crontabs/root` (exists; content not read). |
| Daily backup off the device (ADR 0011) | **Not in place.** `/etc/periodic/daily/` is empty and there is no backup service. Systemd timers were not listed. There is no database yet, so there is nothing to back up today. |
| Storage | Root 102.7 GB, 2.6 GB used (3%). |
| Up time | 27 min at the time of the check. |

**Device model.** "pipa" is the code name of a Xiaomi tablet, not of the POCO F3 ("alioth"). The model (`/proc/device-tree/model`) was not read. **The owner confirmed on 2026-11-17 that the device is the POCO F3.**

## Step 2 — Q-007

Proposal written in `docs/OPEN-QUESTIONS.md`, entry Q-007, with alternatives and impacts (commit `3582d6c`). Support dates come from secondary sources and were not checked on the official sites.

**Owner answer (2026-11-17): PostgreSQL 18.6 and Node.js 24.** Recorded in the entry; the entry stays open until the owner closes it. Applied: `ops/docker-compose.yml` pins `postgres:18.6` (commit `8352062`). Consequence on the other computer: the next `docker compose up -d` there recreates `expathio-postgres-dev` with 18.6 and keeps the data volume (same major version). Not run by this session.

## Step 3 — Database roles (ADR 0032)

Files: `ops/db-roles/create-roles.sh` (the procedure, POSIX shell, runs on the phone or in a container), `ops/db-roles/test-roles.ps1` (test), `ops/db-roles/README.md` (how to run, on the computer and on the phone). `ops/.gitattributes` keeps LF line endings for `.sh`. Commit `8352062`.

The procedure creates `expathio_owner` and `expathio_app` with login, no superuser, no BYPASSRLS, no CREATEDB/CREATEROLE; makes sure the app role is not a member of the owner; grants CONNECT on the database, and USAGE/CREATE on schema `public` to the owner and USAGE to the app. Passwords are read inside psql with `\getenv`, so they never appear in the process list or the output. Table grants and RLS policies stay in the migrations (ADR 0032, decision 7). Safe to run again.

Test (real output, home computer, throwaway container `expathio-roles-test`, image `postgres:18.6`, server `18.6 (Debian 18.6-1.pgdg13+2)`): **15 of 15 checks passed**, container removed. Two earlier runs failed because of defects in the test script, not in the procedure: PowerShell 5.1 stopped on an expected error; booleans print as `true`/`false` in PostgreSQL 18; and the image trusts `127.0.0.1` without a password, so the first password checks were not real. The test now connects through the container's network address; the wrong-password check fails as it should.

Not run: on `expathio-postgres-dev` (not on this computer) and on the phone.

## Step 4 — Deployment, health check, rollback (ADR 0016, Q-009)

Files in `ops/deploy/`: `deploy.ps1` (Windows; actions Deploy, Rollback, Status), `remote.sh` (target side), `targets/phone.target.example` (real target files are git-ignored), `README.md` (steps, failure table, rollback, one-time phone setup), `test/` (stand-in target and test). Commit `4b2a823`.

Test (real output): `ops/deploy/test/test-deploy.ps1` against a local Docker stand-in (Alpine `3.25.0_alpha20260805`, i.e. edge, Node `v24.22.3`, SSH with a throwaway key on 127.0.0.1:2222): **16 of 16 checks passed** on the first run; container, image and key removed.

Not covered: the `git archive` path, password login, `systemctl`, real PostgreSQL migration, backup and restore. The install/migrate/start commands in the phone example are placeholders until Platform Engineering defines them.

Q-009: answer written in the entry (IN DISCUSSION), pointing to `ops/deploy/README.md`.

## Step 5 — Home computer

Docker Desktop is installed and was started by the session with the owner's approval; the engine answers (29.9.2). No Docker install guide is needed. `ops/check-local.ps1` (real output): Node `v22.17.0` FAIL (expected 24); Docker engine OK; compose file, container and port FAIL because `ops/.env` and `expathio-postgres-dev` do not exist here.

`ops/local-setup.md` now has section 1b (install Node.js 24 from nodejs.org, with the license read and accepted by the owner) and a note on the home computer. `ops/.env.example` has the two role password lines.

## Pending

- Owner: close Q-007 and Q-009 when satisfied.
- Owner (home computer): install Node.js 24 (`ops/local-setup.md`, 1b). Approve creating `ops/.env` and the container here (sections 3 and 4), then run `ops/db-roles` on it.
- Platform Engineering: the real install, migration, start and health commands for `ops/deploy/targets/phone.target.example`.
- Phone, each step approved by the owner: install `postgresql18` and `nodejs`; create the database and the roles; `shared/app.env`; the user service; first deployment.
- Owner (change on the phone, needs approval per step): rename the device to `expathio` (ADR 0018).
- Backup off the device: design after Q-007, before any data that matters is stored (ADR 0011).
- Handoff to Product and Documentation: ADRs 0031 and 0032 not on `main`.
