#!/bin/sh
# Installs the throwaway public key given by the test, then runs the SSH server.
set -eu
: "${AUTHORIZED_KEY:?AUTHORIZED_KEY is required}"
install -d -m 700 -o deploy -g deploy /home/deploy/.ssh
printf '%s\n' "$AUTHORIZED_KEY" > /home/deploy/.ssh/authorized_keys
chown deploy:deploy /home/deploy/.ssh/authorized_keys
chmod 600 /home/deploy/.ssh/authorized_keys
exec /usr/sbin/sshd -D -e
