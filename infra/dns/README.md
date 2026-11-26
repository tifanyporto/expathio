# DNS tools

Scripts that manage the DNS records of the project domain on the host. The
domain's DNS is hosted at Cloudflare, and the scripts use its API. Their role
in the platform is described in
[`docs/architecture.md`](../../docs/architecture.md), section 4.

| File | Installed as | Purpose |
|---|---|---|
| `store-token.sh` | run on the host | Stores the API credentials after checking them |
| `dns-record.sh` | run on the host; `/usr/local/lib/expathio/` for the timer | Lists, adds and deletes records |
| `update-address.sh` | `/usr/local/lib/expathio/` | Dynamic DNS: keeps one `A` record at the host's public IPv4 address |
| `expathio-address.service`, `expathio-address.timer` | `/etc/systemd/system/` | Run `update-address.sh` every five minutes |

## Requirements

- A host running Nura (formerly postmarketOS) with systemd, and root access.
- Packages: `apk add curl jq`.
- A Cloudflare API token that can do one thing only: edit the DNS records of
  the domain's zone (permission "Zone / DNS / Edit", limited to that zone),
  and the zone ID, shown on the domain's overview page.

The commands on this page run `sudo` over SSH with a terminal (`ssh -t`).
Replace `<user>` and `<host>` with your SSH account and the host's name.

## Store the credentials

```sh
scp -r infra/dns <user>@<host>:
ssh -t <user>@<host> 'sudo sh ~/dns/store-token.sh'
```

The script asks for the zone ID and the token. The token is not shown while it
is typed or pasted, is never passed on a command line and is never logged. The
script checks with the API that the token is active and can read the zone's
records, and only then writes `/etc/expathio/cloudflare.env` (readable by root
only). It refuses to run without a terminal, because the token could not be
hidden.

## Manage records

```sh
ssh -t <user>@<host> 'sudo sh ~/dns/dns-record.sh list'
ssh -t <user>@<host> 'sudo sh ~/dns/dns-record.sh add TXT example.org "v=spf1 -all"'
ssh -t <user>@<host> 'sudo sh ~/dns/dns-record.sh add MX example.org mx.example.org 10'
ssh -t <user>@<host> 'sudo sh ~/dns/dns-record.sh del <id>'
```

- `list` prints one record per line: ID, type, name, content and priority,
  separated by tabs.
- `add` takes the full record name. It supports `A`, `AAAA`, `CNAME`, `MX` and
  `TXT`, creates records with automatic TTL and without Cloudflare's proxy,
  and does nothing when an identical record already exists. TXT content is
  given without the surrounding quotes.
- `del` takes the ID printed by `list`.

## Dynamic DNS

For a host behind a connection whose public address changes.
`update-address.sh NAME` asks a public service (`1.1.1.1/cdn-cgi/trace`) which
IPv4 address the host's connections come from and makes the `A` record `NAME`
hold exactly that address: it adds the record when it is missing and deletes
`A` records of that name with another address. It calls the API only when the
address changed or once a day, and it changes nothing when a request fails.

Install it with the timer:

```sh
ssh -t <user>@<host> 'sudo install -d /usr/local/lib/expathio && sudo install -m 644 ~/dns/dns-record.sh ~/dns/update-address.sh /usr/local/lib/expathio/ && sudo install -m 644 ~/dns/expathio-address.service ~/dns/expathio-address.timer /etc/systemd/system/ && sudo systemctl daemon-reload && sudo systemctl enable --now expathio-address.timer'
```

The record name is set in `expathio-address.service` (`mx.expathio.com`);
change it there for another domain. The timer runs the update one minute after
boot and then every five minutes.

```sh
systemctl list-timers expathio-address.timer     # last and next run
journalctl -u expathio-address.service           # what each run did
```

## Remove

```sh
ssh -t <user>@<host> 'sudo systemctl disable --now expathio-address.timer && sudo rm /etc/systemd/system/expathio-address.service /etc/systemd/system/expathio-address.timer /usr/local/lib/expathio/dns-record.sh /usr/local/lib/expathio/update-address.sh && sudo systemctl daemon-reload'
ssh -t <user>@<host> 'sudo rm -r /etc/expathio/cloudflare.env /var/lib/expathio'
```

Records already created stay in the zone. Revoke the token in the Cloudflare
dashboard when it is no longer needed.

The mail server's certificate renewal
([`infra/email/issue-certificate.sh`](../email/README.md)) uses
`dns-record.sh` and the stored credentials. If it is installed, removing them
makes the daily renewal fail; disable `expathio-certificate.timer` first, or
keep `dns-record.sh` and the credentials.
