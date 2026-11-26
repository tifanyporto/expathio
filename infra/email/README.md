# Mail server

Self-hosted mail for one domain: Postfix (SMTP) and Dovecot (IMAP, mailbox
storage). The design, ports and security model are specified in
[`docs/architecture.md`](../../docs/architecture.md), section 3.

After installation the server delivers mail between its own accounts, and
users read and send through the private network (IMAP on 993, submission on
587 or 465). Exchanging mail with the rest of the internet requires the extra
steps described at the end of this page.

## Requirements

- A host running Nura (formerly postmarketOS) **with systemd**, and root
  access to it. The scripts use `apk` and `systemctl`.
- Packages:

  ```sh
  apk add postfix dovecot dovecot-lmtpd openssl nftables
  ```

  Dovecot 2.4.5 or newer is required (`dovecot.conf` declares configuration
  version 2.4.5). Tested with Postfix 3.11 and Dovecot 2.4.5.
- An nftables firewall whose `inet filter` table has an `input` chain with
  **policy drop**, as the distribution provides. Postfix and Dovecot listen on
  all addresses, so this firewall is what keeps IMAP and submission off public
  networks. The installer stops if the policy is not `drop`.
- A private network for user access. The reference setup uses Tailscale. The
  `input` chain must accept traffic that arrives on the private network's
  interface; the installer does not add this rule. For Tailscale, save the
  following as `/etc/nftables.d/50_tailscale.nft` and load it with
  `sudo nft -f /etc/nftables.d/50_tailscale.nft`:

  ```
  table inet filter {
  	chain input {
  		iifname "tailscale0" accept comment "accept Tailscale"
  	}
  }
  ```

- For the test script only:

  ```sh
  apk add swaks perl-net-ssleay perl-authen-sasl tailscale
  ```

The commands on this page run `sudo` over SSH with a terminal (`ssh -t`), so
that `sudo` can ask for a password.

## Configuration

| Setting | Default | Where it is set |
|---|---|---|
| Mail domain | `expathio.com` | `MAIL_DOMAIN` environment variable of `install.sh` |
| SMTP host name (SMTP banner, name in the generated TLS certificate) | `mx.<domain>` | `MAIL_HOST` environment variable of `install.sh` |
| Mailbox root | `/var/mail/domains` | `dovecot.conf`, `install.sh` |
| Account file | `/etc/dovecot/users` | `dovecot.conf`, `expathio-mail` |
| TLS certificate and key | `/etc/ssl/mail/cert.pem`, `/etc/ssl/mail/key.pem` | `dovecot.conf`, `install.sh` |
| Maximum message size | 25 MB | `install.sh` (`message_size_limit`) |
| Interface opened for inbound SMTP | `wlan*` | `60_smtp.nft` |

The uid of the `vmail` system user differs between hosts; `install.sh` reads it
from the host and writes it into the installed `dovecot.conf`.

## Install

From a checkout of this repository, copy the directory to the host and run the
installer there. Replace `<user>` and `<host>` with your SSH account and the
host's name.

```sh
scp -r infra/email <user>@<host>:
ssh -t <user>@<host> 'cd ~/email && sudo sh install.sh'
```

To use another domain, pass it on the first run:

```sh
ssh -t <user>@<host> 'cd ~/email && sudo env MAIL_DOMAIN=example.org sh install.sh'
```

The installer checks the requirements, creates a self-signed TLS certificate
if there is none, writes the Dovecot and Postfix configuration, installs the
`expathio-mail` tool and the two systemd units, and enables and starts both
services. It exits with an error if either service is not running.

It can be run again at any time: it rewrites the configuration it manages
(the Postfix parameters and submission entries it sets, and `dovecot.conf`)
and restarts both services. On an installed host it keeps the domain and host
name already in use, and it refuses to change the domain while accounts exist.

## Accounts

Accounts are managed on the host, as root. Replace `expathio.com` with your
mail domain.

```sh
sudo expathio-mail add name@expathio.com      # asks for the password
sudo expathio-mail passwd name@expathio.com
sudo expathio-mail del name@expathio.com
sudo expathio-mail list
```

The address must be in the mail domain. Its local part may contain lowercase
letters, digits, `.`, `_` and `-`; it must start and end with a letter or
digit and must not contain `..`. For scripted use, pass the password in the
`EXPATHIO_MAIL_PASS` environment variable instead of typing it.

`del` removes the account only. The mail stays in
`/var/mail/domains/<domain>/<name>/`; delete that directory to remove it.
Otherwise an account created later with the same name sees the old mail.

The address `postmaster@<domain>` is required by the SMTP standard (RFC 5321)
and is used by Dovecot as the sender of rejection notices. Point it to a real
account by adding a line to `/etc/postfix/virtual` and rebuilding the table:

```sh
echo 'postmaster@expathio.com name@expathio.com' | sudo tee -a /etc/postfix/virtual
sudo postmap lmdb:/etc/postfix/virtual
```

## Mail client settings

The device must be connected to the same private network as the host.

| | Server | Port | Security | User name |
|---|---|---|---|---|
| Incoming (IMAP) | the host's name on the private network | 993 | SSL/TLS | full mail address |
| Outgoing (SMTP) | the same | 587 | STARTTLS | full mail address |
| Outgoing (SMTP), alternative | the same | 465 | SSL/TLS | full mail address |

The installer generates a self-signed certificate for `MAIL_HOST` and the
host's own host name, valid for 365 days, so mail clients show a certificate
warning. The installer does not renew it: to get a new one, delete
`/etc/ssl/mail/cert.pem` and `/etc/ssl/mail/key.pem` and run `install.sh`
again.

### Certificate from Let's Encrypt

`issue-certificate.sh` replaces the self-signed certificate with one from
Let's Encrypt for `MAIL_HOST`. It proves ownership of the name through DNS, so
no inbound port is needed. It requires the `acme.sh` package (`apk add
acme.sh`) and the DNS tools of [`infra/dns/`](../dns/README.md) on the host,
with their credentials stored: the script creates and removes the validation
record with `dns-record.sh`, so the certificate client never handles the DNS
API token. The first run creates an account at Let's Encrypt, without an
e-mail address, which means accepting its subscriber agreement.

```sh
ssh -t <user>@<host> 'sudo sh ~/email/issue-certificate.sh --staging'   # rehearsal, installs nothing
ssh -t <user>@<host> 'sudo sh ~/email/issue-certificate.sh'
```

The second command installs the certificate and key in `/etc/ssl/mail/`,
keeps the self-signed pair beside them (`*.self-signed`), and reloads Postfix
and Dovecot. To renew automatically, install the script and the timer (the
dynamic DNS installation in `infra/dns/` puts `dns-record.sh` in the same
directory, where the renewal looks for it):

```sh
ssh -t <user>@<host> 'sudo install -D -m 644 ~/email/issue-certificate.sh /usr/local/lib/expathio/issue-certificate.sh && sudo install -m 644 ~/email/expathio-certificate.service ~/email/expathio-certificate.timer /etc/systemd/system/ && sudo systemctl daemon-reload && sudo systemctl enable --now expathio-certificate.timer'
```

The certificate names `MAIL_HOST` only. A mail client that reaches the server
by another name, such as the host's name on the private network, still shows
a name mismatch warning.

## Tests

```sh
ssh -t <user>@<host> 'cd ~/email && sudo sh test.sh'
```

The script exercises the server end to end and exits with status 1 if any test
fails. It covers delivery on port 25, rejection of unknown recipients and of
relay attempts, authenticated submission on 587 and 465, the rejection cases
(wrong password, no login, sender address that is not the login), that `AUTH`
is not offered before STARTTLS, the refusal of external mail while no relay
host is set, the presence of each message in the mailbox, the mailbox
permissions, and IMAP login.

It needs Tailscale running on the host, because it connects to the host's own
Tailscale address. That connection does not pass through the firewall, so
also check from another device on the private network that port 993 answers.

It has side effects: it creates the accounts `test1@<domain>` and
`test2@<domain>`, stores their random passwords in
`/root/mail-test-credentials`, and delivers test messages to those mailboxes.
The names `test1` and `test2` are reserved for the script: if such an account
already exists, its password is replaced, and the cleanup deletes the account
and its mailbox. Remove all of that with:

```sh
ssh -t <user>@<host> 'cd ~/email && sudo sh test.sh --cleanup'
```

## Receiving mail from the internet

Not enabled by the installer. It needs:

1. DNS: an `MX` record for the domain that points to the SMTP host name
   (`mx.<domain>` by default), and an `A` record (and `AAAA`, if IPv6 is used)
   for that name with the public address through which the host is reached.
2. TCP port 25 reaching the host, for example through a port forward on the
   router in front of it.
3. The firewall rule in `60_smtp.nft`, loaded once:

   ```sh
   ssh -t <user>@<host> 'sudo install -m 644 ~/email/60_smtp.nft /etc/nftables.d/ && sudo nft -f /etc/nftables.d/60_smtp.nft'
   ```

   The rule accepts port 25 on the Wi-Fi interface for IPv4 **and** IPv6. On a
   host with a global IPv6 address, SMTP becomes reachable over IPv6 as soon as
   the rule is loaded, whatever the router does for IPv4. The rule is added to
   the existing `inet filter` / `input` chain and is loaded again at boot from
   `/etc/nftables.d/`.

   Load the file with `nft -f` as shown. On this distribution,
   `systemctl reload nftables` flushes the whole ruleset first, which also
   removes rules that other software, such as Tailscale, added at runtime.

Remove the test accounts before exposing port 25.

To close the port again, delete `/etc/nftables.d/60_smtp.nft` on the host and
remove the rule from the running firewall by its handle:

```sh
sudo rm /etc/nftables.d/60_smtp.nft
sudo nft -a list chain inet filter input | grep 'inbound mail'   # ends with "# handle N"
sudo nft delete rule inet filter input handle N
```

### If the provider blocks inbound port 25

Some internet providers block inbound connections to port 25 before they reach
the router. Other mail servers deliver only to port 25, so in that case mail
has to come in through an inbound relay: a mail service that accepts mail for
the domain on port 25 and forwards each message to this server on another
port. The mailboxes stay on this server; the relay handles mail in transit and
holds it while the server is unreachable.

1. On the router, forward a high external port (for example 2525) to port 25
   of the host. Step 3 above is still needed.
2. DNS: an `A` record for the SMTP host name with the public address of the
   connection. On a connection whose address changes, keep it current with the
   dynamic DNS tool in [`infra/dns/`](../dns/README.md).
3. At the relay service, set this server as the destination of the domain's
   mail: the SMTP host name and the external port.
4. DNS: point the domain's `MX` record at the relay service, after step 3.

The server then sees the relay as the client of every inbound connection.

## Sending mail to other domains

The server does not deliver directly to other mail servers; it hands that mail
to a relay host (smarthost) on the submission port. Until a relay is
configured, mail addressed to other domains is refused at submission time with
`550 5.4.4`.

Any provider that offers authenticated SMTP submission (port 587 with STARTTLS
or port 465 with implicit TLS) and allows sending from your own domain can be
used. Create the account there and publish the DNS records the provider asks
for (usually SPF and DKIM). Then, with the files already on the host (see
Install), run `set-relay.sh` from a terminal:

```sh
ssh -t <user>@<host> 'sudo sh ~/email/set-relay.sh'
```

It asks for the relay's host name, port, user name and password; the password
is not shown while it is typed. The script logs in to the relay once to check
the credentials and changes nothing if that fails. Then it stores the
credentials in `/etc/postfix/sasl_passwd` (readable by root only) and points
Postfix at the relay. Postfix talks to the relay only over TLS and only if the
relay's certificate is valid for its host name
(`smtp_tls_security_level = secure`).

Run the script again to replace the relay or its password. To go back to
refusing external mail:

```sh
ssh -t <user>@<host> 'sudo sh ~/email/set-relay.sh --remove'
```

## Files

| File | Installed as | Purpose |
|---|---|---|
| `install.sh` | run on the host | Installs and configures Postfix, Dovecot, the account tool and the systemd units |
| `dovecot.conf` | `/etc/dovecot/dovecot.conf` | Mailboxes, accounts, IMAP, sockets for Postfix |
| `dovecot.service`, `postfix.service` | `/etc/systemd/system/` | systemd units (the Alpine packages ship none) |
| `expathio-mail` | `/usr/local/bin/expathio-mail` | Account management |
| `test.sh` | run on the host | End-to-end tests |
| `set-relay.sh` | run on the host (optional) | Configures or removes the relay host for mail to other domains |
| `issue-certificate.sh` | run on the host (optional); `/usr/local/lib/expathio/` for renewal | Obtains and renews a Let's Encrypt certificate for the mail host name |
| `expathio-certificate.service`, `expathio-certificate.timer` | `/etc/systemd/system/` (optional) | Daily renewal check |
| `60_smtp.nft` | `/etc/nftables.d/60_smtp.nft` (optional) | Opens port 25 for inbound mail |
