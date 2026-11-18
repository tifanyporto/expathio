#!/bin/sh
# Creates the two database roles of ADR 0032 in one PostgreSQL database.
#
#   expathio_owner  owns the tables; runs migrations and the seed.
#   expathio_app    runs the application, workers and tests. Not the owner,
#                   not a superuser, no BYPASSRLS, so row-level security applies.
#
# Table grants and row-level security policies are NOT created here.
# ADR 0032, decision 7: they are written in the migration files.
#
# Safe to run again: an existing role keeps its password and only has its
# attributes set again. Nothing is deleted.
#
# Must run as a PostgreSQL superuser (on the phone: the "postgres" system user;
# in Docker: the user created by the image). Needs psql 15 or later (\getenv).
#
# Inputs (environment variables; never put them on the command line, never commit them):
#   EXPATHIO_DB              database that receives the grants (required)
#   EXPATHIO_OWNER_PASSWORD  password for expathio_owner (required)
#   EXPATHIO_APP_PASSWORD    password for expathio_app   (required)
#   PGHOST, PGPORT, PGUSER   optional, standard psql connection settings
#
# Usage: see ops/db-roles/README.md

set -eu

for var in EXPATHIO_DB EXPATHIO_OWNER_PASSWORD EXPATHIO_APP_PASSWORD; do
    eval "value=\${$var:-}"
    if [ -z "$value" ]; then
        echo "ERROR: $var is not set. Nothing was changed." >&2
        exit 2
    fi
done

if [ "$EXPATHIO_OWNER_PASSWORD" = "$EXPATHIO_APP_PASSWORD" ]; then
    echo "ERROR: the two passwords must be different. Nothing was changed." >&2
    exit 2
fi

# The SQL is read by psql from standard input. Passwords are read inside psql
# with \getenv, so they never appear in the process list or in this output.
# ON_ERROR_STOP makes psql stop at the first error; the single transaction
# means either everything is applied or nothing is.
psql -X -q -v ON_ERROR_STOP=1 --single-transaction -d "$EXPATHIO_DB" <<'SQL'
\getenv owner_pw EXPATHIO_OWNER_PASSWORD
\getenv app_pw EXPATHIO_APP_PASSWORD
\getenv db_name EXPATHIO_DB

-- 1. Create each role only if it does not exist yet.
SELECT format('CREATE ROLE expathio_owner LOGIN PASSWORD %L', :'owner_pw')
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'expathio_owner') \gexec

SELECT format('CREATE ROLE expathio_app LOGIN PASSWORD %L', :'app_pw')
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'expathio_app') \gexec

-- 2. Set the attributes every time, so a role changed by hand is put back.
ALTER ROLE expathio_owner LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT;
ALTER ROLE expathio_app   LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT;

-- 3. The application role must never act as the owner.
SELECT 'REVOKE expathio_owner FROM expathio_app'
WHERE pg_has_role('expathio_app', 'expathio_owner', 'MEMBER') \gexec

-- 4. Access to the database and to the public schema.
--    Only the owner may create objects; the app may only use them.
SELECT format('GRANT CONNECT, TEMPORARY ON DATABASE %I TO expathio_owner, expathio_app', :'db_name') \gexec
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
GRANT USAGE, CREATE ON SCHEMA public TO expathio_owner;
GRANT USAGE ON SCHEMA public TO expathio_app;

-- 5. Report (no passwords).
SELECT rolname, rolcanlogin AS login, rolsuper AS superuser, rolbypassrls AS bypassrls,
       rolcreatedb AS createdb, rolcreaterole AS createrole
FROM pg_roles WHERE rolname IN ('expathio_owner', 'expathio_app') ORDER BY rolname;
SQL

echo "OK: roles expathio_owner and expathio_app are set up in database $EXPATHIO_DB."
