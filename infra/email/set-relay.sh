#!/bin/sh
# Configures the relay host (smarthost) that Postfix hands mail for other
# domains to, over authenticated submission with verified TLS.
# Run as root from a terminal. The host, port and user name are typed at the
# prompts; the password is never echoed, never passed on a command line and
# never logged.
#
# The credentials are checked against the relay before anything is changed.
#
#   set-relay.sh            configure or replace the relay
#   set-relay.sh --remove   remove the relay; external mail is refused again
set -eu

MAP=/etc/postfix/sasl_passwd
CAFILE=/etc/ssl/certs/ca-certificates.crt
die() { echo "set-relay.sh: $*" >&2; exit 1; }

[ "$(id -u)" = 0 ] || die "must run as root"
for c in postconf postmap postfix curl; do
	command -v "$c" >/dev/null || die "missing command: $c"
done
[ -n "$(postconf -h virtual_mailbox_domains)" ] || die "the mail server is not installed (run install.sh first)"
dbtype=$(postconf -h default_database_type)

# Makes Postfix use the configuration that was just written.
apply() {
	postfix check || die "the configuration was changed, but 'postfix check' failed; fix the error above, then run 'postfix reload'"
	postfix reload || die "the configuration was changed, but Postfix could not be reloaded (is it running?); the change takes effect when it starts"
}

if [ "${1:-}" = --remove ]; then
	# The refusal is written first, so external mail is never delivered directly.
	postconf -e "smtp_tls_security_level = may" \
		"default_transport = error:5.4.4 no relay host is configured for external mail"
	postconf -X relayhost smtp_sasl_auth_enable smtp_sasl_password_maps \
		smtp_sasl_security_options smtp_sasl_tls_security_options \
		smtp_tls_CAfile smtp_tls_servername smtp_tls_wrappermode
	rm -f "$MAP" "$MAP.$dbtype" "$MAP.new"
	apply
	echo "the relay was removed; mail for other domains is refused again"
	exit 0
fi
[ $# -eq 0 ] || die "usage: set-relay.sh [--remove]"
[ -r "$CAFILE" ] || die "missing certificate authority bundle: $CAFILE (apk add ca-certificates-bundle)"
[ -t 0 ] || die "standard input is not a terminal (run it over 'ssh -t'), so the password could not be hidden"

printf 'Relay host name (for example smtp.example.net): '
read -r host
case $host in
	''|.*|*.|*..*|*[!a-z0-9.-]*) die "not a valid lowercase host name: $host" ;;
esac

printf 'Port, 587 (STARTTLS) or 465 (implicit TLS) [587]: '
read -r port
port=${port:-587}
case $port in
	587) scheme=smtp wrapper=no ;;
	465) scheme=smtps wrapper=yes ;;
	*) die "the port must be 587 or 465" ;;
esac

printf 'User name at the relay (usually a full mail address): '
read -r user
case $user in
	'') die "no user name given" ;;
	*[!A-Za-z0-9@._+-]*) die "the user name contains unexpected characters" ;;
esac

# Echo is turned off before the prompt, and restored on any exit, including an
# interruption (the signal trap makes the shell leave through the EXIT trap).
trap 'stty echo 2>/dev/null || true' EXIT
trap 'exit 130' INT TERM HUP
stty -echo || die "cannot turn off terminal echo; nothing was changed"
printf 'Password (input is hidden): '
IFS= read -r pass
stty echo 2>/dev/null || true
trap - INT TERM HUP
echo
[ -n "$pass" ] || die "no password given"
case $pass in
	' '*|*' ') die "the password starts or ends with a space; Postfix cannot store that" ;;
esac
# Anything outside printable ASCII (tabs, control characters, a stray carriage
# return from a paste) would be stored wrongly or break the lookup table.
[ -z "$(printf '%s' "$pass" | LC_ALL=C tr -d ' -~')" ] \
	|| die "the password contains characters other than printable ASCII; copy it again"

# Logs in to the relay with the credentials passed on standard input, not on
# the command line, and sends only NOOP. TLS and the certificate are required,
# and so is the PLAIN mechanism, the one Postfix will use.
echo "checking the credentials at $host:$port..."
quoted=$(printf '%s' "$pass" | sed 's/[\\"]/\\&/g')
rc=0
trace=$(printf 'url = "%s://%s:%s"\nssl-reqd\ncacert = "%s"\nverbose\nlogin-options = "AUTH=PLAIN"\nrequest = "NOOP"\nuser = "%s:%s"\n' \
	"$scheme" "$host" "$port" "$CAFILE" "$user" "$quoted" \
	| curl --disable --silent --show-error --max-time 30 --output /dev/null --config - 2>&1) || rc=$?
# The trace holds the encoded credentials, so only curl's own error line is shown.
printf '%s\n' "$trace" | grep '^curl: ' >&2 || true
case $rc in
	0) ;;
	67) die "the relay refused the login (wrong user name or password, or it does not offer AUTH PLAIN); nothing was changed" ;;
	*) die "could not complete a verified TLS login at $host:$port (curl exit code $rc); nothing was changed" ;;
esac
# A server that offers no AUTH lets curl succeed without logging in.
printf '%s\n' "$trace" | grep -q '^< 235[ -]' \
	|| die "$host:$port did not ask for a login, so the credentials were not checked; nothing was changed"
unset trace quoted

( umask 077
  printf '[%s]:%s %s:%s\n' "$host" "$port" "$user" "$pass" > "$MAP.new"
  mv "$MAP.new" "$MAP"
  postmap "$dbtype:$MAP" )
chmod 600 "$MAP" "$MAP.$dbtype"

postconf -e "relayhost = [$host]:$port" \
	"smtp_sasl_auth_enable = yes" \
	"smtp_sasl_password_maps = $dbtype:$MAP" \
	"smtp_sasl_security_options = noanonymous" \
	"smtp_sasl_tls_security_options = noanonymous" \
	"smtp_tls_security_level = secure" \
	"smtp_tls_CAfile = $CAFILE" \
	"smtp_tls_servername = hostname" \
	"smtp_tls_wrappermode = $wrapper"
postconf -X default_transport
apply
echo "the relay accepted the credentials; mail for other domains now goes through [$host]:$port"
