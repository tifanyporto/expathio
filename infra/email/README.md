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
again. To use a certificate from a certificate authority, replace those two
files and restart both services.

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

## Sending mail to other domains

The server does not deliver directly to other mail servers; it hands that mail
to a relay host on the submission port. `install.sh` does not configure the
relay. Until `relayhost` is set in Postfix, mail addressed to other domains is
refused at submission time with `550 5.4.4`.

To enable it, set the Postfix parameters for your relay provider: `relayhost`
and the SASL client settings (`smtp_sasl_auth_enable`,
`smtp_sasl_password_maps`, `smtp_sasl_security_options`), and
`smtp_tls_security_level = encrypt` to require TLS towards the relay. Then run
`install.sh` again: it removes the refusal when a relay host is set, and it
keeps an `smtp_tls_security_level` that is already set.

## Files

| File | Installed as | Purpose |
|---|---|---|
| `install.sh` | run on the host | Installs and configures Postfix, Dovecot, the account tool and the systemd units |
| `dovecot.conf` | `/etc/dovecot/dovecot.conf` | Mailboxes, accounts, IMAP, sockets for Postfix |
| `dovecot.service`, `postfix.service` | `/etc/systemd/system/` | systemd units (the Alpine packages ship none) |
| `expathio-mail` | `/usr/local/bin/expathio-mail` | Account management |
| `test.sh` | run on the host | End-to-end tests |
| `60_smtp.nft` | `/etc/nftables.d/60_smtp.nft` (optional) | Opens port 25 for inbound mail |
