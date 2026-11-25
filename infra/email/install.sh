#!/bin/sh
# Installs and configures the Expathio mail server (Postfix + Dovecot) on the host.
# Run as root from the directory that holds these files.
#
# Settings (environment variables):
#   MAIL_DOMAIN   mail domain                  (default: expathio.com)
#   MAIL_HOST     SMTP host name, used in TLS  (default: mx.$MAIL_DOMAIN)
#
# It can be run again: it rewrites the configuration it manages and restarts
# both services. On a host that is already installed, the domain and host name
# default to the ones in use, so they do not have to be passed again.
set -eu
cd "$(dirname "$0")"

die() { echo "install.sh: $*" >&2; exit 1; }

echo "== checking requirements"
[ "$(id -u)" = 0 ] || die "must run as root"
for c in postconf postmap doveadm doveconf openssl nft systemctl; do
	command -v "$c" >/dev/null || die "missing command: $c (see the Requirements section of README.md)"
done

# Domain already configured on this host, if any (empty on a fresh installation).
current=$(postconf -h virtual_mailbox_domains)
case $current in ''|*[!a-z0-9.-]*) current= ;; esac
if [ -n "$current" ]; then
	DOMAIN=${MAIL_DOMAIN:-$current}
	if [ "$DOMAIN" = "$current" ]; then
		HOST=${MAIL_HOST:-$(postconf -h myhostname)}
	else
		HOST=${MAIL_HOST:-mx.$DOMAIN}
	fi
else
	DOMAIN=${MAIL_DOMAIN:-expathio.com}
	HOST=${MAIL_HOST:-mx.$DOMAIN}
fi
for name in "$DOMAIN" "$HOST"; do
	case $name in
		''|.*|*.|*..*|*[!a-z0-9.-]*) die "not a valid lowercase host or domain name: $name" ;;
	esac
done
if [ -n "$current" ] && [ "$DOMAIN" != "$current" ] && [ -s /etc/dovecot/users ]; then
	die "this host serves '$current' and has accounts; remove them before changing the domain"
fi
id vmail >/dev/null 2>&1 || die "user 'vmail' not found (the Alpine postfix package creates it)"
getent group dovecot >/dev/null || die "group 'dovecot' not found"
# Postfix and Dovecot listen on every interface. A default-drop firewall is what
# keeps IMAP and submission reachable only through the private network.
nft list chain inet filter input 2>/dev/null | grep -q 'policy drop' \
	|| die "firewall is not default-drop (inet filter input); refusing to expose mail ports"

echo "== TLS certificate"
mkdir -p /etc/ssl/mail
if [ ! -s /etc/ssl/mail/key.pem ] || [ ! -s /etc/ssl/mail/cert.pem ]; then
	echo "generating a self-signed certificate for $HOST"
	openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -nodes -days 365 \
		-subj "/CN=$HOST" -addext "subjectAltName=DNS:$HOST,DNS:$(hostname)" \
		-keyout /etc/ssl/mail/key.pem -out /etc/ssl/mail/cert.pem
fi
chmod 600 /etc/ssl/mail/key.pem

echo "== dovecot"
# The postfix package creates the "vmail" user in the "postdrop" group;
# mailboxes use a dedicated "vmail" group instead.
getent group vmail >/dev/null || addgroup -S vmail
VMAIL_UID=$(id -u vmail)
sed -e "s/^first_valid_uid = .*/first_valid_uid = $VMAIL_UID/" \
	-e "s/^last_valid_uid = .*/last_valid_uid = $VMAIL_UID/" \
	-e "s/^  postmaster_address = .*/  postmaster_address = postmaster@$DOMAIN/" \
	dovecot.conf > /etc/dovecot/dovecot.conf.new
[ -f /etc/dovecot/users ] || : > /etc/dovecot/users
chown root:dovecot /etc/dovecot/users
chmod 640 /etc/dovecot/users
mkdir -p /var/mail/domains
chown vmail:vmail /var/mail/domains
chmod 750 /var/mail/domains
# The new file replaces the live one only after Dovecot accepts it.
if ! doveconf -n -c /etc/dovecot/dovecot.conf.new >/dev/null; then
	rm -f /etc/dovecot/dovecot.conf.new
	die "dovecot configuration is invalid"
fi
chmod 644 /etc/dovecot/dovecot.conf.new
mv /etc/dovecot/dovecot.conf.new /etc/dovecot/dovecot.conf

echo "== postfix: main.cf"
postconf -e \
	"compatibility_level = 3.11" \
	"myhostname = $HOST" \
	"mydomain = $DOMAIN" \
	'myorigin = $mydomain' \
	"mydestination = localhost" \
	"inet_interfaces = all" \
	"inet_protocols = all" \
	"mynetworks = 127.0.0.0/8 [::1]/128" \
	'smtpd_banner = $myhostname ESMTP' \
	"alias_maps = lmdb:/etc/postfix/aliases" \
	"alias_database = lmdb:/etc/postfix/aliases" \
	"virtual_mailbox_domains = $DOMAIN" \
	"virtual_mailbox_maps = lmdb:/etc/postfix/vmailbox" \
	"virtual_alias_maps = lmdb:/etc/postfix/virtual" \
	"virtual_transport = lmtp:unix:private/dovecot-lmtp" \
	"smtpd_sasl_type = dovecot" \
	"smtpd_sasl_path = private/auth" \
	"smtpd_sasl_auth_enable = no" \
	"smtpd_sender_login_maps = lmdb:/etc/postfix/sender_login" \
	"smtpd_tls_cert_file = /etc/ssl/mail/cert.pem" \
	"smtpd_tls_key_file = /etc/ssl/mail/key.pem" \
	"smtpd_tls_security_level = may" \
	"smtpd_relay_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination" \
	"smtpd_helo_required = yes" \
	"disable_vrfy_command = yes" \
	"message_size_limit = 26214400"

# Outbound TLS is opportunistic unless a level is already set in main.cf
# (for example "encrypt" towards a relay host); an existing value is kept.
[ -n "$(postconf -n smtp_tls_security_level)" ] || postconf -e "smtp_tls_security_level = may"

# Mail for other domains needs a relay host (see README.md). Without one it is
# refused immediately instead of being queued for a delivery that cannot happen.
if [ -z "$(postconf -h relayhost)" ]; then
	postconf -e "default_transport = error:5.4.4 no relay host is configured for external mail"
else
	postconf -X default_transport
fi

echo "== postfix: authenticated submission (587 and 465)"
for port in 587 465; do
	postconf -M "$port/inet=$port inet n - n - - smtpd"
	postconf -P \
		"$port/inet/syslog_name=postfix/submission" \
		"$port/inet/smtpd_sasl_auth_enable=yes" \
		"$port/inet/smtpd_tls_auth_only=yes" \
		"$port/inet/smtpd_client_restrictions=permit_sasl_authenticated,reject" \
		"$port/inet/smtpd_sender_restrictions=reject_sender_login_mismatch" \
		"$port/inet/smtpd_relay_restrictions=permit_sasl_authenticated,reject"
done
postconf -P "587/inet/smtpd_tls_security_level=encrypt"
postconf -P "465/inet/smtpd_tls_wrappermode=yes"

echo "== postfix: lookup tables"
mkdir -p /usr/local/bin
install -m 755 expathio-mail /usr/local/bin/expathio-mail
cut -d: -f1 /etc/dovecot/users | awk '{print $1 " OK"}' > /etc/postfix/vmailbox
cut -d: -f1 /etc/dovecot/users | awk '{print $1 " " $1}' > /etc/postfix/sender_login
[ -f /etc/postfix/virtual ] || : > /etc/postfix/virtual
postmap lmdb:/etc/postfix/vmailbox lmdb:/etc/postfix/sender_login lmdb:/etc/postfix/virtual
newaliases

echo "== services"
install -m 644 dovecot.service postfix.service /etc/systemd/system/
systemctl daemon-reload
postfix check
systemctl enable dovecot postfix >/dev/null || die "could not enable the dovecot and postfix units"
systemctl restart dovecot
systemctl restart postfix
sleep 2
systemctl is-active --quiet dovecot || die "dovecot is not running (journalctl -u dovecot)"
systemctl is-active --quiet postfix || die "postfix is not running (journalctl -u postfix)"
echo "dovecot and postfix are running; mail domain: $DOMAIN, host: $HOST"
