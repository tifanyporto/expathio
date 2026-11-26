#!/bin/sh
# Lists, adds and deletes DNS records of the project's Cloudflare zone, with
# the credentials stored by store-token.sh. Run as root on the host.
#
#   dns-record.sh list
#   dns-record.sh add TYPE NAME CONTENT [PRIORITY]   (PRIORITY for MX only)
#   dns-record.sh del ID                             (ID as printed by "list")
#
# NAME is the full record name (for example mx.example.org). "add" does
# nothing when an identical record already exists. Records are created with
# automatic TTL and without Cloudflare's proxy. TXT content is given without
# the surrounding quotes.
set -eu

ENV=/etc/expathio/cloudflare.env
API=https://api.cloudflare.com/client/v4
die() { echo "dns-record.sh: $*" >&2; exit 1; }

[ "$(id -u)" = 0 ] || die "must run as root"
for c in curl jq; do
	command -v "$c" >/dev/null || die "missing command: $c (apk add $c)"
done
[ -r "$ENV" ] || die "no stored credentials: $ENV (run store-token.sh first)"
CF_Token= CF_Zone_ID=
. "$ENV"
[ -n "$CF_Token" ] && [ -n "$CF_Zone_ID" ] || die "$ENV is incomplete"

# api METHOD PATH [JSON-BODY]: the token is passed on standard input, not on the
# command line. Prints the response and fails when the API reports an error.
api() {
	out=$(printf 'header = "Authorization: Bearer %s"\n' "$CF_Token" \
		| curl --disable --silent --show-error --max-time 30 --config - \
			--request "$1" --header "Content-Type: application/json" \
			${3:+--data "$3"} "$API/zones/$CF_Zone_ID/$2") || die "request failed: $1 $2"
	[ "$(printf '%s' "$out" | jq -r '.success')" = true ] \
		|| die "the API refused $1 $2: $(printf '%s' "$out" | jq -c '.errors')"
	printf '%s\n' "$out"
}

# The request is kept out of pipelines, where its failure would go unnoticed.
records() {
	listing=$(api GET "dns_records?per_page=1000") || exit 1
	printf '%s\n' "$listing" \
		| jq -r '.result[] | [.id, .type, .name, .content, (.priority // "" | tostring)] | @tsv'
}

case ${1:-} in
list)
	[ $# -eq 1 ] || die "usage: dns-record.sh list"
	records
	;;
add)
	[ $# -eq 4 ] || [ $# -eq 5 ] || die "usage: dns-record.sh add TYPE NAME CONTENT [PRIORITY]"
	type=$2 name=$3 content=$4 prio=${5:-}
	case $type in A|AAAA|CNAME|MX|TXT) ;; *) die "unsupported record type: $type" ;; esac
	case $name in ''|.*|*.|*..*|*[!a-z0-9._-]*) die "not a valid lowercase record name: $name" ;; esac
	case $prio in *[!0-9]*) die "the priority must be a number" ;; esac
	[ "$type" = MX ] && [ -z "$prio" ] && die "an MX record needs a priority"
	[ "$type" != MX ] && [ -n "$prio" ] && die "only MX records take a priority"
	# Identical means same type, name, content and priority. Cloudflare stores
	# TXT content as quoted strings of at most 255 bytes and splits longer
	# ones, so TXT is compared with the quotes removed and the strings joined.
	listing=$(api GET "dns_records?per_page=1000") || exit 1
	if printf '%s\n' "$listing" | jq -e --arg t "$type" --arg n "$name" --arg c "$content" --arg p "$prio" '
		any(.result[];
			.type == $t and .name == $n and (.priority // "" | tostring) == $p
			and (if $t == "TXT"
				then (.content | sub("^\""; "") | sub("\"$"; "") | gsub("\"[ \t]*\""; "")) == $c
				else .content == $c end))' >/dev/null; then
		echo "already present: $type $name"
		exit 0
	fi
	# Cloudflare expects TXT content inside double quotes.
	[ "$type" = TXT ] && content="\"$content\""
	body=$(jq -n --arg t "$type" --arg n "$name" --arg c "$content" --arg p "$prio" \
		'{type: $t, name: $n, content: $c, ttl: 1, proxied: false}
		 + (if $p == "" then {} else {priority: ($p | tonumber)} end)')
	api POST dns_records "$body" >/dev/null
	echo "added: $type $name"
	;;
del)
	[ $# -eq 2 ] || die "usage: dns-record.sh del ID"
	case $2 in ''|*[!0-9a-f]*) die "not a record ID: $2" ;; esac
	api DELETE "dns_records/$2" >/dev/null
	echo "deleted: $2"
	;;
*)
	die "usage: dns-record.sh list | add TYPE NAME CONTENT [PRIORITY] | del ID"
	;;
esac
