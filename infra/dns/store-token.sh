#!/bin/sh
# Stores the Cloudflare credentials used for DNS automation on the host:
# the zone ID and an API token limited to editing the DNS records of that zone.
# Run as root from a terminal. Both values are typed or pasted at the prompts;
# the token is never echoed, never passed on a command line and never logged.
#
# The values are checked against the Cloudflare API before being saved to
# /etc/expathio/cloudflare.env (owner root, mode 600).
set -eu

FILE=/etc/expathio/cloudflare.env
API=https://api.cloudflare.com/client/v4
die() { echo "store-token.sh: $*" >&2; exit 1; }

[ "$(id -u)" = 0 ] || die "must run as root"
command -v curl >/dev/null || die "missing command: curl (apk add curl)"
[ -t 0 ] || die "standard input is not a terminal (run it over 'ssh -t'), so the token could not be hidden"

printf 'Zone ID (32 characters, from the domain Overview page): '
read -r zone
case $zone in
	''|*[!0-9a-f]*) die "the zone ID must be 32 lowercase hexadecimal characters" ;;
esac
[ "${#zone}" -eq 32 ] || die "the zone ID must be 32 characters long"

# Echo is turned off before the prompt, and restored on any exit, including an
# interruption (the signal trap makes the shell leave through the EXIT trap).
trap 'stty echo 2>/dev/null || true' EXIT
trap 'exit 130' INT TERM HUP
stty -echo || die "cannot turn off terminal echo; nothing was saved"
printf 'API token (input is hidden): '
read -r token
stty echo 2>/dev/null || true
trap - INT TERM HUP
echo
case $token in
	'') die "no token given" ;;
	*[!A-Za-z0-9_-]*) die "the token contains unexpected characters; copy it again" ;;
esac

# Calls the API with the token passed on standard input, not on the command line.
api() {
	printf 'header = "Authorization: Bearer %s"\n' "$token" \
		| curl --disable --silent --show-error --max-time 20 --config - "$API/$1"
}

echo "checking the token..."
api user/tokens/verify | grep -q '"status": *"active"' \
	|| die "Cloudflare does not report this token as active"
api "zones/$zone/dns_records?per_page=1" | grep -q '"success": *true' \
	|| die "the token cannot read the DNS records of this zone; check the zone ID and the token's zone"

mkdir -p /etc/expathio
chmod 700 /etc/expathio
( umask 077; printf 'CF_Token=%s\nCF_Zone_ID=%s\n' "$token" "$zone" > "$FILE.new" )
mv "$FILE.new" "$FILE"
echo "the token is active and can read the zone's DNS records; saved to $FILE"
