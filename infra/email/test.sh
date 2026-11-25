#!/bin/sh
# End-to-end tests for the Expathio mail server. Run as root on the host.
#
# Side effects: creates the accounts test1@<domain> and test2@<domain>, stores
# their random passwords in /root/mail-test-credentials (mode 600) and delivers
# a few test messages to those two mailboxes.
#
#   sh test.sh             run the tests (exit status 1 if any test fails)
#   sh test.sh --cleanup   remove the test accounts, their mailboxes and the
#                          credentials file
#
# The account names test1 and test2 are reserved for this script: an existing
# account with one of those names gets a new password, and --cleanup deletes it.
set -u

die() { echo "test.sh: $*" >&2; exit 2; }
need() {
	for c in "$@"; do
		command -v "$c" >/dev/null || die "missing command: $c (see the Requirements section of README.md)"
	done
}
[ "$(id -u)" = 0 ] || die "must run as root"
need postconf expathio-mail

DOMAIN=$(postconf -h virtual_mailbox_domains)
CRED=/root/mail-test-credentials
BOXES=/var/mail/domains/$DOMAIN
A1=test1@$DOMAIN
A2=test2@$DOMAIN

has_account() { expathio-mail list | grep -qxF "$1"; }

if [ "${1:-}" = "--cleanup" ]; then
	for a in "$A1" "$A2"; do
		if has_account "$a"; then expathio-mail del "$a"; fi
	done
	rm -rf "$BOXES/test1" "$BOXES/test2"
	rm -f "$CRED"
	echo "test accounts, mailboxes and credentials removed"
	exit 0
fi

need swaks tailscale openssl timeout

# The tests connect to the host's Tailscale address so that the server sees a
# client that is not in mynetworks (loopback is trusted and would hide relay
# mistakes).
ADDR=$(tailscale ip -4 2>/dev/null | head -n 1)
[ -n "$ADDR" ] || die "no Tailscale IPv4 address; is Tailscale up?"

if [ ! -s "$CRED" ]; then
	( umask 077; { echo "P1=$(openssl rand -hex 16)"; echo "P2=$(openssl rand -hex 16)"; } > "$CRED" )
fi
. "$CRED"
# Always sync the passwords, so a lost credentials file cannot cause false failures.
for pair in "$A1:$P1" "$A2:$P2"; do
	a=${pair%%:*}
	if has_account "$a"; then action=passwd; else action=add; fi
	EXPATHIO_MAIL_PASS=${pair#*:} expathio-mail "$action" "$a" >/dev/null || die "could not prepare $a"
done

RUN=$(date +%s)
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; fails=$((fails + 1)); }
skip() { echo "SKIP  $1"; }
# expect <transcript> <extended regex> <description>
expect() { if printf '%s\n' "$1" | grep -qE "$2"; then pass "$3"; else fail "$3"; fi; }
sw() { swaks --timeout 15 --server "$ADDR" "$@" 2>&1; }
# Authenticated session; the password goes through the environment, not the command line.
sw_auth() { user=$1; pw=$2; shift 2; SWAKS_OPT_auth_password=$pw sw --auth PLAIN --auth-user "$user" "$@"; }
QUEUED='250 2\.0\.0 Ok: queued'

echo "## port 25 (server to server)"
o=$(sw --from sender@example.org --to "$A1" --header "Subject: t1-$RUN" --body one)
expect "$o" "$QUEUED" "accepts mail for an existing account"
o=$(sw --from sender@example.org --to "nobody-$RUN@$DOMAIN")
expect "$o" '^<\*\* 550 5\.1\.1' "rejects an unknown recipient (550 5.1.1)"
o=$(sw --from sender@example.org --to someone@example.net)
expect "$o" '^<\*\* 554 5\.7\.1 .*Relay access denied' "refuses to relay for an unauthenticated client"

echo "## ports 587 and 465 (authenticated submission)"
o=$(sw_auth "$A1" "$P1" --port 587 --tls --from "$A1" --to "$A2" --header "Subject: t4-$RUN" --body four)
expect "$o" "$QUEUED" "587: STARTTLS with the right password"
o=$(sw_auth "$A2" "$P2" --port 465 --tlsc --from "$A2" --to "$A1" --header "Subject: t5-$RUN" --body five)
expect "$o" "$QUEUED" "465: implicit TLS with the right password"
o=$(sw_auth "$A1" wrong-password --port 587 --tls --from "$A1" --to "$A2")
expect "$o" '^<~\* 535 ' "587: rejects a wrong password (535)"
o=$(sw --port 587 --tls --from "$A1" --to "$A2")
expect "$o" '^<~\* 554 5\.7\.1 ' "587: rejects a client that does not log in (554)"
o=$(sw_auth "$A1" "$P1" --port 587 --tls --from "$A2" --to "$A1")
expect "$o" '^<~\* 553 5\.7\.1 ' "587: rejects a sender address that is not the login (553)"
o=$(sw --port 587 --quit-after EHLO)
if printf '%s\n' "$o" | grep -q '^<-  250' && ! printf '%s\n' "$o" | grep -q '^<-  250[- ]AUTH'; then
	pass "587: AUTH is not offered before STARTTLS"
else
	fail "587: AUTH is not offered before STARTTLS"
fi
if [ -z "$(postconf -h relayhost)" ]; then
	o=$(sw_auth "$A1" "$P1" --port 587 --tls --from "$A1" --to someone@example.net)
	expect "$o" '^<~\* 550 5\.4\.4 ' "587: refuses external mail while no relay host is set (550 5.4.4)"
else
	skip "external mail check (a relay host is configured; nothing is sent to it by this script)"
fi

echo "## delivery to the mailboxes"
# delivered <mailbox> <subject>: waits up to 15 s for the message file.
delivered() {
	i=0
	while [ "$i" -lt 15 ]; do
		grep -rqs "^Subject: $2\$" "$BOXES/$1/Maildir/new" "$BOXES/$1/Maildir/cur" && return 0
		sleep 1; i=$((i + 1))
	done
	return 1
}
for t in "test1:t1-$RUN" "test2:t4-$RUN" "test1:t5-$RUN"; do
	if delivered "${t%%:*}" "${t#*:}"; then pass "message ${t#*:} is in the ${t%%:*} mailbox"
	else fail "message ${t#*:} is in the ${t%%:*} mailbox"; fi
done
owner=$(stat -c '%U:%G %a' "$BOXES/test1/Maildir" 2>/dev/null)
if [ "$owner" = "vmail:vmail 700" ]; then pass "mailbox is private to vmail (vmail:vmail 700)"
else fail "mailbox is private to vmail (got: $owner)"; fi

echo "## port 993 (IMAP over TLS)"
imap() {
	{ printf 'a LOGIN "%s" "%s"\r\n' "$1" "$2"; sleep 1; printf 'b STATUS INBOX (MESSAGES)\r\nc LOGOUT\r\n'; sleep 2; } \
		| timeout 20 openssl s_client -quiet -connect "$ADDR:993" 2>/dev/null | tr -d '\r'
}
o=$(imap "$A1" "$P1")
expect "$o" '^a OK ' "IMAP login with the right password"
expect "$o" '^\* STATUS INBOX \(MESSAGES [1-9]' "IMAP sees the delivered messages"
o=$(imap "$A1" wrong-password)
expect "$o" '^a NO ' "IMAP rejects a wrong password"

echo
if [ "$fails" -eq 0 ]; then echo "all tests passed"; else echo "$fails test(s) failed"; exit 1; fi
