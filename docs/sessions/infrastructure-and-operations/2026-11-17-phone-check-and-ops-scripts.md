# 2026-11-17 — Phone Check and Operations Scripts

**Status of this record:** in progress. Sections are updated as each step ends.

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

**Open point — device model.** "pipa" is the code name of a Xiaomi tablet, not of the POCO F3 ("alioth"). The model (`/proc/device-tree/model`) was not read. The owner must confirm which device this is before the hosting records (ADR 0011, 0018) are taken as accurate.

## Step 2 — Q-007

Proposal written in `docs/OPEN-QUESTIONS.md`, entry Q-007: PostgreSQL 18 (phone `postgresql18` 18.6, Docker pin moved from 18.4 to 18.6) and Node.js 24 (phone `nodejs` 24.22.1), with alternatives and impacts. The entry stays IN DISCUSSION. Support dates come from secondary sources and were not checked on the official sites.

## Pending

- Owner: answer Q-007.
- Owner: confirm the device model.
- Owner (change on the phone, needs approval per step): rename the device to `expathio` (ADR 0018).
- Backup off the device: design after Q-007, before any data that matters is stored (ADR 0011).
- Handoff to Product and Documentation: ADRs 0031 and 0032 not on `main`.
