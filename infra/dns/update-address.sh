#!/bin/sh
# Dynamic DNS: keeps one A record pointing at the public IPv4 address of the
# connection the host is on. Run as root, normally by the systemd timer.
#
#   update-address.sh NAME        (for example mx.example.org)
#
# It asks a public service which address the host's connections come from,
# and changes the record only when that address differs from the last one it
# set. The record is read back from the zone at least once a day, so a manual
# change is corrected. It uses dns-record.sh from its own directory.
set -eu

STATE_DIR=/var/lib/expathio
WHOAMI=https://1.1.1.1/cdn-cgi/trace
die() { echo "update-address.sh: $*" >&2; exit 1; }

[ "$(id -u)" = 0 ] || die "must run as root"
[ $# -eq 1 ] || die "usage: update-address.sh NAME"
name=$1
case $name in ''|.*|*.|*..*|*[!a-z0-9.-]*) die "not a valid lowercase record name: $name" ;; esac
tool=$(cd "$(dirname "$0")" && pwd)/dns-record.sh
[ -r "$tool" ] || die "missing $tool"
state=$STATE_DIR/address-$name

trace=$(curl --disable --silent --show-error --ipv4 --max-time 15 "$WHOAMI") \
	|| die "could not reach $WHOAMI"
ip=$(printf '%s\n' "$trace" | sed -n 's/^ip=//p')
case $ip in
	''|*[!0-9.]*|.*|*.|*..*) die "could not learn the public IPv4 address" ;;
esac
# Four parts, each from 0 to 255.
old_ifs=$IFS; IFS=.
set -- $ip
IFS=$old_ifs
[ $# -eq 4 ] || die "not an IPv4 address: $ip"
for part in "$@"; do
	[ "${#part}" -le 3 ] && [ "$part" -le 255 ] || die "not an IPv4 address: $ip"
done

# Nothing to do when the address is the one set less than a day ago.
if [ -f "$state" ] && [ "$(cat "$state")" = "$ip" ] \
	&& [ -n "$(find "$state" -mmin -1440)" ]; then
	exit 0
fi

# IDs of the A records of this name that hold another address, and whether one
# already holds the current address.
records=$(sh "$tool" list) || die "could not list the DNS records"
stale=$(printf '%s\n' "$records" | N="$name" I="$ip" awk -F'\t' \
	'$2 == "A" && $3 == ENVIRON["N"] && $4 != ENVIRON["I"] { print $1 }')
if ! printf '%s\n' "$records" | N="$name" I="$ip" awk -F'\t' \
	'$2 == "A" && $3 == ENVIRON["N"] && $4 == ENVIRON["I"] { found = 1 } END { exit !found }'; then
	sh "$tool" add A "$name" "$ip" >/dev/null || die "could not add the record"
	echo "$name now points to $ip"
fi
for id in $stale; do
	sh "$tool" del "$id" >/dev/null || die "could not delete the old record $id"
done

mkdir -p "$STATE_DIR"
chmod 700 "$STATE_DIR"
printf '%s\n' "$ip" > "$state"
