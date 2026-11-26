#!/bin/sh
# Obtains a TLS certificate for the mail host name from Let's Encrypt and
# installs it for Postfix and Dovecot, replacing the self-signed one.
# Run as root. Ownership of the name is proved through DNS, so no inbound port
# is needed. The DNS record is created and removed with infra/dns/dns-record.sh
# and the credentials stored by infra/dns/store-token.sh; the certificate
# client (acme.sh) never handles the DNS API token.
#
# The first run creates an account at Let's Encrypt (no e-mail address is
# given), which means accepting its subscriber agreement.
#
#   issue-certificate.sh             issue, install and reload the services
#   issue-certificate.sh --staging   rehearse against the staging service;
#                                    nothing is installed
#   issue-certificate.sh --renew     renew when due (run by the systemd timer)
set -eu

STATE=/etc/expathio/acme
CERT=/etc/ssl/mail/cert.pem
KEY=/etc/ssl/mail/key.pem
die() { echo "issue-certificate.sh: $*" >&2; exit 1; }

[ "$(id -u)" = 0 ] || die "must run as root"
command -v acme.sh >/dev/null || die "missing command: acme.sh (apk add acme.sh)"
for c in postconf openssl systemctl; do
	command -v "$c" >/dev/null || die "missing command: $c"
done
host=$(postconf -h myhostname)
case $host in ''|.*|*.|*..*|*[!a-z0-9.-]*) die "not a valid host name in Postfix: $host" ;; esac

# The DNS record tool: beside this script, in the repository layout, or where
# the dynamic DNS installation puts it.
here=$(cd "$(dirname "$0")" && pwd)
EXPATHIO_DNS_TOOL=
for t in "$here/dns-record.sh" "$here/../dns/dns-record.sh" /usr/local/lib/expathio/dns-record.sh; do
	if [ -r "$t" ]; then EXPATHIO_DNS_TOOL=$t; break; fi
done
[ -n "$EXPATHIO_DNS_TOOL" ] || die "dns-record.sh not found (see infra/dns/README.md)"
export EXPATHIO_DNS_TOOL

# acme HOME ARGS...: everything acme.sh keeps (account key, certificates)
# stays in HOME, readable by root only. The DNS hook is written there on every
# run, so a renewal started by the timer finds it.
acme() {
	home=$1; shift
	( umask 077; mkdir -p "$home/dnsapi" )
	cat > "$home/dnsapi/dns_expathio.sh" <<'HOOK'
#!/usr/bin/env sh
# acme.sh DNS hook: the challenge record is created and removed with
# dns-record.sh, which reads the API credentials itself.
dns_expathio_add() {
	sh "$EXPATHIO_DNS_TOOL" add TXT "$1" "$2"
}
dns_expathio_rm() {
	_expathio_ids=$(sh "$EXPATHIO_DNS_TOOL" list) || return 1
	_expathio_ids=$(printf '%s\n' "$_expathio_ids" | N="$1" C="\"$2\"" awk -F'\t' \
		'$2 == "TXT" && $3 == ENVIRON["N"] && $4 == ENVIRON["C"] { print $1 }')
	for _expathio_id in $_expathio_ids; do
		sh "$EXPATHIO_DNS_TOOL" del "$_expathio_id" || return 1
	done
}
HOOK
	acme.sh --home "$home" --config-home "$home" --cert-home "$home/certs" "$@"
}

case ${1:-} in
--staging)
	[ $# -eq 1 ] || die "usage: issue-certificate.sh [--staging | --renew]"
	trap 'rm -rf "$STATE-staging"' EXIT
	trap 'exit 130' INT TERM HUP
	acme "$STATE-staging" --issue --staging --dns dns_expathio -d "$host" \
		|| die "the staging service did not issue a certificate for $host"
	echo "the staging service issued a certificate for $host; nothing was installed"
	;;
--renew)
	[ $# -eq 1 ] || die "usage: issue-certificate.sh [--staging | --renew]"
	[ -d "$STATE" ] || die "no certificate was issued yet (run issue-certificate.sh first)"
	acme "$STATE" --cron
	;;
'')
	# Certificates kept for another host name would be renewed too and
	# installed over this one, so they are dropped first.
	for d in "$STATE"/certs/*/; do
		[ -d "$d" ] || continue
		case $(basename "$d") in "$host"|"${host}_ecc") ;; *) rm -rf "$d" ;; esac
	done
	rc=0
	acme "$STATE" --issue --server letsencrypt --dns dns_expathio -d "$host" || rc=$?
	# 2 means the certificate on file is still valid and was not renewed.
	[ "$rc" = 0 ] || [ "$rc" = 2 ] || die "Let's Encrypt did not issue a certificate for $host"
	# Keeps the certificate being replaced, once, the first time.
	[ -f "$CERT.self-signed" ] || cp -p "$CERT" "$CERT.self-signed"
	[ -f "$KEY.self-signed" ] || cp -p "$KEY" "$KEY.self-signed"
	acme "$STATE" --install-cert -d "$host" \
		--key-file "$KEY" --fullchain-file "$CERT" \
		--reloadcmd "systemctl reload postfix dovecot" \
		|| die "the certificate was issued, but installing it or reloading Postfix and Dovecot failed"
	chmod 600 "$KEY"
	echo "installed a certificate for $host:"
	openssl x509 -in "$CERT" -noout -issuer -enddate
	;;
*)
	die "usage: issue-certificate.sh [--staging | --renew]"
	;;
esac
