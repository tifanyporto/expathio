# Local development setup (Windows computer)

**Status:** PROPOSED — waiting for the owner to run the steps and report the output  
**Owner of this file:** Infrastructure and Operations  
**Applies to:** the Windows development computer only (ADR 0015). The production phone is covered by a separate guide, when access returns.

This guide sets up the local development environment in a repeatable way:

- **Node.js** runs the application code.
- **Docker Desktop** runs PostgreSQL in a container, so the database is the same on every run.
- **PostgreSQL** is the database. The container version is pinned in `ops/docker-compose.yml`.

Each step says what to run, what you should see, and what to do if it fails. Run the commands in **PowerShell**, in the folder shown.

---

## 0. What is already on the computer (checked on 2026-11-09)

Checked by the Infrastructure and Operations session, with real output:

| Item | Found | Note |
|---|---|---|
| Node.js | v24.12.0 | Installed in `C:\Program Files\nodejs`. The project uses Node 24 (`ops/.nvmrc`). |
| npm | 11.6.2 | Comes with Node.js. |
| psql (PostgreSQL client tools) | 16.13 | Command-line client only. Not the server used by the project. |
| PostgreSQL server (Windows) | Service `postgresql-x64-16`, running | Listens on port **5432**. It is a separate install and is **not** used by Expathio. |
| Docker | **not installed** | Must be installed in step 2. |
| WSL 2 | Ubuntu distribution installed, version 2 | Docker Desktop uses WSL 2. |
| Git | installed | Used for the repository. |

Because the Windows PostgreSQL service already uses port 5432, the Docker database uses port **5433**. Nothing in this guide stops or changes the Windows PostgreSQL service.

---

## 1. Check Node.js

Open PowerShell and run:

```powershell
node --version
```

**Expected:** a line starting with `v24.` (the check on 2026-11-09 printed `v24.12.0`).

If it shows another major version, stop here and tell the session. Do not install another Node.js yet.

---

## 2. Install Docker Desktop

Docker Desktop is the program that runs containers on Windows. ADR 0015 already approved it.

1. Download Docker Desktop for Windows from the official site (docker.com). Read what it asks before you accept anything.
2. Run the installer. Keep the option **Use WSL 2 instead of Hyper-V** selected.
3. Restart the computer when the installer asks.
4. Open Docker Desktop and wait until it shows that the engine is running (usually a green status at the bottom left).
5. Accept only the Docker terms that appear on the screen. Do not sign in if you do not want an account; the local setup does not need one.

Check it in PowerShell:

```powershell
docker version
docker compose version
```

**Expected:** both commands print a version number, with a `Server` section in `docker version`.

If `docker` is not found, close PowerShell and open it again, so the new program path is loaded.

If `docker version` shows an error about the engine, open Docker Desktop and wait for it to finish starting.

---

## 3. Create your local settings file

The file `ops/.env` holds the database password. Git ignores it, so it is never committed.

1. Open the `ops` folder in the repository.
2. Copy `.env.example` to a new file named `.env` in the same folder.
3. Open `.env` in a text editor. Put a long random password after `POSTGRES_PASSWORD=`. Do not share it, and do not put it in any file that Git tracks.

Example of the shape (do **not** use this value):

```text
POSTGRES_PASSWORD=<your own long password>
```

Keep the other values as they are.

---

## 4. Start the database

From the `ops` folder:

```powershell
cd ops
docker compose up -d
```

The first run downloads the PostgreSQL image. It may take a few minutes.

Check that the container is healthy:

```powershell
docker compose ps
```

**Expected:** the `STATUS` column shows `Up ... (healthy)` for `expathio-postgres-dev`. Wait up to one minute. If it still shows `starting`, wait and run the command again.

**If it says the port is already allocated:** another program uses port 5433. Change `POSTGRES_HOST_PORT` in `ops/.env` to another free number, such as `5434`, and run `docker compose up -d` again.

**If it says `Set POSTGRES_PASSWORD in ops/.env`:** the `.env` file is missing or the password line is empty (step 3).

---

## 5. Check the database version

Use the `psql` client that is already installed. Run:

```powershell
psql -h 127.0.0.1 -p 5433 -U expathio -d expathio_dev -c "SELECT version();"
```

- `psql` asks for the password. Type the password from `ops/.env`. The screen shows nothing while you type; this is normal.
- **Expected:** one row whose text starts with `PostgreSQL 18.4`.

Do not use port 5432 here. That is the Windows PostgreSQL 16 service.

---

## 6. Run the local check script

From the repository root (the folder that contains `ops/`):

```powershell
powershell -ExecutionPolicy Bypass -File .\ops\check-local.ps1
```

The script checks Node.js, Docker, the Compose file, the container health and the port. It prints one line per check, and it ends with a summary. It does not print the password.

---

## 7. Stop or reset the database

Stop the database and keep its data:

```powershell
cd ops
docker compose down
```

Start it again later with `docker compose up -d`.

**Reset (deletes all local development data in this database):**

```powershell
cd ops
docker compose down -v
```

Use reset only when you want an empty database. The command asks for no confirmation, so make sure you are in the `ops` folder before running it.

---

## Files in this folder

| File | What it is |
|---|---|
| `local-setup.md` | This guide. |
| `docker-compose.yml` | Recipe for Docker Compose: which PostgreSQL image to run, the port, the data volume and the health check. |
| `.env.example` | Template for `ops/.env`. It has no password. |
| `.nvmrc` | The Node.js major version the project uses (`24`). Read by version managers such as nvm. |
| `check-local.ps1` | Script that runs the checks in section 6. |
| `README.md` | Short index of this folder. |

## Terms used

- **Container:** an isolated program package that runs on the computer, with its own copy of the software it needs.
- **Docker Compose:** the tool that starts containers from a recipe file (`docker-compose.yml`).
- **Volume:** storage managed by Docker that keeps the database data after the container stops.
- **Port:** a numbered door on the computer. Each service listens on one port. The database here uses 5433.
- **psql:** the command-line program to talk to PostgreSQL.
