#!/bin/sh
# Test stand-in for the migration command. Fails when the file MIGRATE_FAIL
# exists in the release folder; otherwise records which release migrated.
set -eu
if [ -f MIGRATE_FAIL ]; then
    echo "migration failed (test)" >&2
    exit 1
fi
echo "$(cat VERSION)" >> "$BASE_DIR/shared/migrations.log"
