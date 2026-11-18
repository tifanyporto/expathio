# Database roles (ADR 0032)

Procedure to create the two PostgreSQL roles that ADR 0032, decision 3, requires on every machine.

| Role | Used by | Can | Cannot |
|---|---|---|---|
| `expathio_owner` | Migrations and seed (the deployment script) | Log in, create and own tables in schema `public` | Be superuser, bypass row-level security, create databases or roles |
| `expathio_app` | The application, workers and tests | Log in, use schema `public`, use the tables that migrations grant to it | Create tables, act as the owner, bypass row-level security |

What this procedure does **not** do: create tables, grant table rights, or write row-level security policies. ADR 0032, decision 7, puts those in the migration files.

## Files

| File | What it does |
|---|---|
| `create-roles.sh` | Creates the two roles in one database, sets their attributes and the schema rights. Safe to run again. Runs on Linux (the phone, or inside a container). |
| `test-roles.ps1` | Runs `create-roles.sh` in a throwaway Docker container and checks 15 rules (see "Test"). Windows computer only. |

## Passwords

- Each machine has its own two passwords. They are different from each other and from the superuser password.
- Generate them on the computer, for example in PowerShell:
  `-join ((48..57)+(65..90)+(97..122) | Get-Random -Count 32 | % {[char]$_})`
- Local computer: keep them in `ops/.env` (ignored by Git), as `EXPATHIO_OWNER_PASSWORD` and `EXPATHIO_APP_PASSWORD`.
- Phone: kept in a file readable only by its owner, outside the repository. The deployment step that creates that file is described in `ops/deploy/README.md`.
- Never write a password on the command line, in a commit, in a session record or in chat.

## Run on the local computer (Docker)

Prerequisite: the container `expathio-postgres-dev` is running (`ops/local-setup.md`) and `ops/.env` holds the two passwords.

From the `ops/` folder, in PowerShell:

```powershell
docker cp .\db-roles\create-roles.sh expathio-postgres-dev:/tmp/create-roles.sh
docker compose exec -e PGUSER=expathio -e EXPATHIO_DB=expathio_dev -e EXPATHIO_OWNER_PASSWORD -e EXPATHIO_APP_PASSWORD postgres sh /tmp/create-roles.sh
```

`-e NAME` without a value passes the variable from the PowerShell session, so set the two passwords there first (`$env:EXPATHIO_OWNER_PASSWORD = '...'`), copying them from `ops/.env`. `PGUSER=expathio` is the image's superuser (`POSTGRES_USER` in `ops/.env`).

Status: this exact command has not been run yet on `expathio-postgres-dev` (that container is on the other computer). The script itself is tested by `test-roles.ps1`.

Expected: a table with both roles, `login` = `t` and the other columns `f`, then `OK: roles expathio_owner and expathio_app are set up in database expathio_dev.`

## Run on the phone

**Only after the owner approves each step.** Not done yet. Prerequisites: PostgreSQL 18 installed and started on the phone, and the database `expathio` created (separate approved steps).

1. Copy the script: `scp ops/db-roles/create-roles.sh user@<phone>:/tmp/` (the owner types the phone password).
2. Run it as the `postgres` system user. The owner types the passwords when asked, so they never appear in the shell history:
   ```sh
   read -rs EXPATHIO_OWNER_PASSWORD; read -rs EXPATHIO_APP_PASSWORD
   sudo -u postgres env EXPATHIO_DB=expathio EXPATHIO_OWNER_PASSWORD="$EXPATHIO_OWNER_PASSWORD" EXPATHIO_APP_PASSWORD="$EXPATHIO_APP_PASSWORD" sh /tmp/create-roles.sh
   rm /tmp/create-roles.sh
   ```
3. Check what to observe: the same table and `OK:` line as above.

## Test

From the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File .\ops\db-roles\test-roles.ps1
```

It starts a container named `expathio-roles-test` (image `postgres:18.6`, no port published), runs the procedure twice, checks the rules below, and removes the container. It never touches `expathio-postgres` or `expathio-postgres-dev`.

Checks: missing input refused without changes; first and second run succeed; role attributes; the app is not a member of the owner; each role logs in with its password over the network; a wrong password is refused; the app cannot create tables; the owner creates a table with forced row-level security; the app inserts in its organization; without context the app sees nothing; with context A it sees only A; it cannot write into another organization; the owner is also subject to row-level security.

Note: the PostgreSQL image trusts connections from `127.0.0.1` inside the container without a password. The test connects through the container's network address so the password is really checked.
