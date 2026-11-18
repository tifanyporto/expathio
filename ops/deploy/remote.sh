#!/bin/sh
# Runs ON THE TARGET (the phone, or the local test container). Started by
# ops/deploy/deploy.ps1 and ops/deploy/rollback.ps1; not meant to be run by hand,
# except "status".
#
#   sh expathio-<upload>-remote.sh deploy   <upload>                 install, back up, migrate, switch, restart, health check
#   sh expathio-<upload>-remote.sh rollback <upload> [release-id]    switch back to the previous (or given) release
#   sh expathio-<upload>-remote.sh status   <upload>                 list releases and show which one is live
#
# <upload> identifies the files sent next to this script. For a deploy it is also the release id.
# Settings come from expathio-<upload>.conf (a copy of the target file, without SSH settings).
# Layout on the target (ADR 0016: the previous version is kept next to the new one):
#   $BASE_DIR/releases/<release-id>/   one folder per deployed version
#   $BASE_DIR/current  -> releases/<id> the live version (a symbolic link)
#   $BASE_DIR/previous                 text file: the release that was live before
#   $BASE_DIR/shared/app.env           secrets for this machine (created by the owner, never deployed)
#   $BASE_DIR/backups/                 database copies taken before each migration

set -eu

MODE=${1:-}
ID=${2:-}
ARG=${3:-}
SELF_DIR=$(dirname "$0")

log()  { echo "[expathio] $*"; }
fail() {
    echo "[expathio] FAILED: $*" >&2
    echo "[expathio] See ops/deploy/README.md, section \"When something fails\"." >&2
    exit 1
}

[ -n "$ID" ] || fail "upload id missing"
CONF="$SELF_DIR/expathio-$ID.conf"
[ -f "$CONF" ] || fail "settings file $CONF not found"
# shellcheck disable=SC1090
. "$CONF"

: "${BASE_DIR:?BASE_DIR is not set in the target file}"
: "${HEALTH_URL:?HEALTH_URL is not set in the target file}"
HEALTH_TIMEOUT=${HEALTH_TIMEOUT:-30}
KEEP_RELEASES=${KEEP_RELEASES:-3}
export BASE_DIR

health_check() {
    log "health check: $HEALTH_URL (up to ${HEALTH_TIMEOUT}s)"
    waited=0
    while [ "$waited" -lt "$HEALTH_TIMEOUT" ]; do
        if body=$(wget -q -T 3 -O - "$HEALTH_URL" 2>/dev/null); then
            log "health check passed: $body"
            return 0
        fi
        sleep 1
        waited=$((waited + 1))
    done
    return 1
}

# Runs one configured command inside a release folder. An empty command is skipped.
run_step() {
    name=$1; dir=$2; cmd=$3
    if [ -z "$cmd" ]; then
        log "$name: not configured, skipped"
        return 0
    fi
    log "$name: $cmd"
    (cd "$dir" && sh -c "$cmd") || return 1
}

switch_to() {
    # ln -sfn replaces the link in one step; the live folder is never half-written.
    ln -sfn "releases/$1" "$BASE_DIR/current"
}

live_release() { basename "$(readlink "$BASE_DIR/current" 2>/dev/null)" 2>/dev/null || true; }

prune() {
    keep_cur=$(live_release)
    keep_prev=$(cat "$BASE_DIR/previous" 2>/dev/null || true)
    ls -1 "$BASE_DIR/releases" | sort -r | tail -n +$((KEEP_RELEASES + 1)) | while read -r old; do
        if [ "$old" != "$keep_cur" ] && [ "$old" != "$keep_prev" ]; then
            log "removing old release $old"
            rm -rf "${BASE_DIR:?}/releases/$old"
        fi
    done
}

cleanup_upload() { rm -f "$SELF_DIR/expathio-$ID.tar.gz" "$SELF_DIR/expathio-$ID.conf" "$SELF_DIR/expathio-$ID-remote.sh"; }

trap cleanup_upload EXIT

case "$MODE" in
deploy)
    REL="$BASE_DIR/releases/$ID"
    mkdir -p "$BASE_DIR/releases" "$BASE_DIR/shared" "$BASE_DIR/backups"
    [ -e "$REL" ] && fail "release $ID already exists"

    PREV=$(live_release)
    log "live now: ${PREV:-none}; deploying: $ID"

    mkdir "$REL"
    tar -xzf "$SELF_DIR/expathio-$ID.tar.gz" -C "$REL" || fail "could not unpack the package"
    if [ -f "$BASE_DIR/shared/app.env" ]; then
        ln -s "$BASE_DIR/shared/app.env" "$REL/.env"
    fi

    run_step install "$REL" "${INSTALL_CMD:-}" || fail "install step; the live version ($PREV) was not touched"

    BACKUP_FILE="$BASE_DIR/backups/pre-$ID.dump"
    export BACKUP_FILE
    run_step backup "$REL" "${PRE_MIGRATION_BACKUP_CMD:-}" || fail "backup before migration; nothing was migrated; the live version ($PREV) was not touched"

    run_step migrate "$REL" "${MIGRATE_CMD:-}" || fail "migration; the live version ($PREV) still runs; the database may be partly migrated; backup: $BACKUP_FILE"

    switch_to "$ID"
    printf '%s\n' "$PREV" > "$BASE_DIR/previous"
    log "switched live version to $ID"

    run_step restart "$BASE_DIR/current" "${RESTART_CMD:-}" || fail "restart; $ID is selected but may not be running; roll back with rollback.ps1"
    health_check || fail "health check; $ID is live but not healthy; roll back with rollback.ps1"

    prune
    log "OK: $ID is live and healthy (previous: ${PREV:-none})"
    ;;
rollback)
    CUR=$(live_release)
    TARGET=$ARG
    [ -n "$TARGET" ] || TARGET=$(cat "$BASE_DIR/previous" 2>/dev/null || true)
    [ -n "$TARGET" ] || fail "no previous release recorded; give a release id (see: status)"
    [ -d "$BASE_DIR/releases/$TARGET" ] || fail "release $TARGET does not exist on the target"
    [ "$TARGET" != "$CUR" ] || fail "release $TARGET is already live"

    log "rolling back: $CUR -> $TARGET (code only; the database is not changed)"
    switch_to "$TARGET"
    printf '%s\n' "$CUR" > "$BASE_DIR/previous"
    run_step restart "$BASE_DIR/current" "${RESTART_CMD:-}" || fail "restart after rollback"
    health_check || fail "health check after rollback; $TARGET is live but not healthy"
    log "OK: $TARGET is live and healthy (rolled back from $CUR)"
    ;;
status)
    log "base: $BASE_DIR"
    log "live: $(live_release)"
    log "previous: $(cat "$BASE_DIR/previous" 2>/dev/null || echo none)"
    log "releases:"; ls -1 "$BASE_DIR/releases" 2>/dev/null | sort -r | sed 's/^/  /'
    log "backups:";  ls -1 "$BASE_DIR/backups"  2>/dev/null | sort -r | sed 's/^/  /'
    ;;
*)
    fail "usage: remote.sh deploy <upload> | rollback <upload> [release-id] | status <upload>"
    ;;
esac
