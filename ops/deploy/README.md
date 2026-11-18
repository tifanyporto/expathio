# Deployment, health check and rollback (ADR 0016, Q-009)

The deployment sends one tested version from the Windows computer to the phone over the private network, and stops at the first failure. ADR 0031: this script is tested against a local target first; its first run on the phone is a separate step that the owner approves.

**Status:** IMPLEMENTED and TESTED against the local target (`test/test-deploy.ps1`, 16 checks, 2026-11-17). **Not run on the phone yet.** The install, migration and start commands of the real application are placeholders until Platform Engineering defines them.

## Files

| File | What it does |
|---|---|
| `deploy.ps1` | Runs on Windows. Packs the version, sends it with `scp`, and runs `remote.sh` on the target with `ssh`. Actions: `Deploy`, `Rollback`, `Status`. |
| `remote.sh` | Runs on the target. Does the steps in a fixed order (below) and keeps the previous version. |
| `targets/phone.target.example` | Template of the phone settings. Copy to `targets/phone.target`, which Git ignores (host and user names stay out of the repository, ADR 0018). |
| `test/test-deploy.ps1` | Local test: builds a stand-in for the phone (Alpine edge, SSH, Node.js) in Docker and runs every scenario. |
| `test/Dockerfile`, `test/entrypoint.sh`, `test/fixture-app/` | The stand-in and a minimal fixture app used only by the test. |

## How a deployment works

What `deploy.ps1 -Target phone -TestsPassed` does, in order. Any failure stops it.

1. **Checks before sending.** Refuses to run without `-TestsPassed` (the owner confirms the full test suite passed, ADR 0016 step 1). Refuses if the Git working tree has uncommitted changes.
2. **Package.** `git archive` of the current commit. Only files tracked by Git are included, so `.env` files never leave the computer. The release id is the UTC time plus the commit, for example `20261117T210503693Z-8352062`.
3. **Send.** One `scp` with the package, the target settings (without SSH settings) and `remote.sh`, into `/tmp` on the target.
4. **On the target** (`remote.sh deploy`):
   1. Unpack into `releases/<id>/` and link `shared/app.env` (the secrets of that machine) as `.env`.
   2. `INSTALL_CMD` (install dependencies).
   3. `PRE_MIGRATION_BACKUP_CMD`: a copy of the database in `backups/pre-<id>.dump`.
   4. `MIGRATE_CMD`, as `expathio_owner` (ADR 0032).
   5. Switch the `current` link to the new release and record the old one in `previous`.
   6. `RESTART_CMD` (the application runs as `expathio_app`).
   7. Health check: asks `HEALTH_URL` once a second, for up to `HEALTH_TIMEOUT` seconds. Success means an HTTP 2xx answer.
   8. Remove releases older than the last `KEEP_RELEASES`, never the live or the previous one.
   9. The temporary files in `/tmp` are deleted in every case.
5. **The owner** opens the private address and checks that the main pages load (ADR 0016, step 5).

If the target uses a password, it is asked twice (once by `scp`, once by `ssh`). The owner types it; the script never sees it.

## When something fails (rollback, Q-009)

The output says which step failed. What to do:

| Failed step | State after the failure | What to do |
|---|---|---|
| Before sending, sending, unpack, install | The live version and the database are untouched. | Fix the cause and deploy again. |
| Backup before migration | Nothing migrated; the live version is untouched. | Fix the backup (disk space, database access) and deploy again. Never skip it. |
| Migration | The **old version still runs**. The database **may be partly migrated**. | See "Database" below. Do not deploy again until the database state is known. |
| Restart or health check | The **new version is selected** but not healthy. The database is already migrated. | Run the code rollback (below). If the old code does not work with the new database, see "Database". |

### Code rollback

```powershell
.\ops\deploy\deploy.ps1 -Target phone -Action Rollback                    # back to the previous release
.\ops\deploy\deploy.ps1 -Target phone -Action Status                      # list releases
.\ops\deploy\deploy.ps1 -Target phone -Action Rollback -Release <id>      # back to a given release
```

It switches `current` back, restarts and runs the health check. It does **not** change the database.

What to observe: the last line is `OK: <id> is live and healthy (rolled back from <id>)`.

### Database

Drizzle does not generate reverse migrations (ADR 0032). There are two ways back, chosen by the owner case by case:

1. **Reverse migration written by hand.** Preferred when the migration only added things (a new table or column that the old code ignores). Often the old code works without any database change; check that first.
2. **Restore the copy taken before the migration** (`backups/pre-<id>.dump`). Everything written after the deployment is lost. **This deletes data and needs the owner's written confirmation for that case.** Steps, run on the phone with the application stopped:
   ```sh
   systemctl --user stop expathio
   pg_restore --clean --if-exists --no-owner --role=expathio_owner -d "$DATABASE_URL_OWNER" backups/pre-<id>.dump
   ```
   Then run the code rollback above.

The daily backup off the device (ADR 0011) is the last resort when the pre-migration copy is missing or damaged. It does not exist yet.

## One-time setup on the phone (not done; each step needs the owner's approval)

1. Install PostgreSQL 18 and Node.js 24 (Q-007, decided 2026-11-17).
2. Create the database and the two roles (`ops/db-roles/README.md`).
3. Create `BASE_DIR/shared/app.env`, readable only by the phone user (`chmod 600`), with `DATABASE_URL` (as `expathio_app`) and `DATABASE_URL_OWNER` (as `expathio_owner`).
4. Create the user service `expathio` (`systemctl --user`) and enable lingering so it runs without a login.
5. Copy `targets/phone.target.example` to `targets/phone.target` on the computer and fill it in.
6. Optional: an SSH key for the computer, so the password is not asked on every deployment.

## Test

From the repository root, with Docker Desktop running:

```powershell
powershell -ExecutionPolicy Bypass -File .\ops\deploy\test\test-deploy.ps1
```

Scenarios checked: refuses without `-TestsPassed`; deploys v1 and v2; keeps the previous release; takes the backup before migrating; a failed migration stops and leaves the live version unchanged; a failed health check stops and is reported; rollback returns to v2 and it is healthy; status shows the live release; no files left in `/tmp`; old releases removed.

Not covered by the test: the `git archive` path (the test deploys folders with `-SourceDir`), password login (the test uses a throwaway key), `systemctl`, and real PostgreSQL migrations and backups (the test uses stand-in commands).
