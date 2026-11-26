# Architecture

Technical specification of the Expathio platform and of the services it runs.

## 1. Host platform

Expathio runs on a single self-hosted machine: a smartphone repurposed as a
server. It boots Linux directly; no Android system is installed.

| Item | Specification |
|---|---|
| Device | Xiaomi POCO F3 (device tree model `Xiaomi POCO F3`, code name `alioth`) |
| SoC / CPU | Qualcomm SM8250, 8 cores, aarch64 |
| Memory | 6 GB RAM (about 5.4 GiB usable), plus compressed swap in RAM (zram) |
| Storage | Internal UFS flash; ext4 root filesystem of about 100 GB |
| Operating system | Nura, the distribution formerly named postmarketOS: edge channel, systemd variant. It is based on Alpine Linux edge and uses the `apk` package manager. Package and file names still carry the `postmarketos` name. |
| Kernel | Linux 6.19, the distribution's mainline-based kernel for Qualcomm SM8250 |
| Init system | systemd |
| Android | Not present. The root filesystem lives in the partition that used to hold Android user data, and the Android system partitions are empty. The bootloader and firmware partitions are kept, because the device needs them to boot. |
| Connectivity | Wi-Fi |

## 2. Network and access model

- **Firewall.** nftables with a default-drop policy on inbound traffic
  (`inet filter` table, `input` chain). A service is reachable from a network
  only if a rule accepts it on that interface.
- **Private network.** The host is a member of a Tailscale network, a
  WireGuard-based private network. A firewall rule accepts traffic that
  arrives on the Tailscale interface, so the members of that network can reach
  services that listen on all addresses.
- **Administration.** Over SSH. A restriction table
  ([`infra/host/`](../infra/host/README.md)) drops SSH from any source that is
  not local: it is accepted from the private network, from USB networking, and
  on other interfaces from private IPv4 ranges and link-local IPv6 only. The
  same table closes two ports that the distribution opens for desktop
  applications and limits DNS to the same local sources.
- **Mail exposure.** The mail ports are closed to every network except the
  private one. Inbound SMTP (TCP port 25) is the only mail port meant to be
  public, and it is opened by an optional firewall rule (section 3.6).

## 3. Mail service

Self-hosted mail for the project domain (`expathio.com`). Configuration and
tooling live in [`infra/email/`](../infra/email/README.md).

### 3.1 Components

| Component | Role |
|---|---|
| Postfix 3.11 | SMTP server: receives mail for the domain, accepts authenticated submission from users, hands local mail to Dovecot. |
| Dovecot 2.4.5 or newer | Mailbox storage, IMAP server, LMTP delivery agent and authentication backend for Postfix (SASL). |
| `expathio-mail` | Command-line tool that creates, removes and lists accounts and changes passwords. |
| systemd units | `postfix.service` and `dovecot.service`, provided by this repository (the Alpine packages ship none). |

### 3.2 Mail flows

```
Receive:  sender's server --25--> Postfix --LMTP (unix socket)--> Dovecot --> Maildir
          or, where inbound port 25 is blocked (section 3.6):
          sender's server --25--> inbound relay --alternate port--> Postfix --> ...
Send:     mail client --587/465, authenticated--> Postfix --> relay host --25--> recipient's server
Read:     mail client --993 (IMAP over TLS)--> Dovecot
```

Mail between two local accounts never leaves the host: Postfix delivers it
straight to Dovecot. The relay leg of the send flow exists only after a relay
host is configured (section 3.7); until then, mail for other domains is refused.

### 3.3 Listeners

Postfix and Dovecot listen on all addresses, IPv4 and IPv6. The firewall
decides which networks can reach each port.

| Port | Service | Protocol | Authentication | Reachable from |
|---|---|---|---|---|
| 25 | Postfix | SMTP, opportunistic STARTTLS | None (server to server) | Private network; the internet when the optional firewall rule is loaded |
| 587 | Postfix | Submission, STARTTLS required | SASL (PLAIN or LOGIN) | Private network |
| 465 | Postfix | Submission, implicit TLS | SASL (PLAIN or LOGIN) | Private network |
| 993 | Dovecot | IMAP, implicit TLS | Password | Private network |
| 143 | — | Plain IMAP is disabled | — | — |

The distribution's default firewall rules also accept all traffic on the
loopback and USB network interfaces, so the host itself and a computer
attached by cable reach the same ports.

Postfix talks to Dovecot over two unix sockets inside the Postfix spool
directory: `private/dovecot-lmtp` (delivery) and `private/auth` (SASL).

### 3.4 Accounts and storage

- **Accounts.** Virtual users in a flat file, `/etc/dovecot/users`
  (owner `root`, group `dovecot`, mode 640). The login name is the full mail
  address. Passwords are stored as bcrypt hashes (`BLF-CRYPT`).
- **Recipient validation.** Postfix accepts mail only for account addresses,
  listed in `/etc/postfix/vmailbox` (which `expathio-mail` regenerates from
  the account file), and for aliases listed in `/etc/postfix/virtual`
  (maintained by hand, for example `postmaster`). Mail for any other address
  in the domain is rejected during the SMTP session (`550 5.1.1`).
- **Mailboxes.** Maildir format at
  `/var/mail/domains/<domain>/<user>/Maildir`, owned by the system user and
  group `vmail`, mode 700. Each mailbox gets the folders Drafts, Sent, Junk
  and Trash.
- **Message size.** Up to 25 MB per message.

### 3.5 Security model

- **No open relay.** On port 25, Postfix relays only for the host itself
  (loopback). From any other client it accepts mail only for the hosted
  domain and for the host's own `localhost` name.
- **Authentication only over TLS.** Passwords are never accepted on an
  unencrypted connection: port 587 requires STARTTLS before `AUTH` is offered,
  port 465 and port 993 use implicit TLS, and Dovecot refuses cleartext logins.
- **Sender ownership.** An authenticated user can use only their own address
  as the envelope sender (`reject_sender_login_mismatch`). The `From:` header
  is not checked.
- **User access over the private network.** IMAP and submission are not opened
  to the internet. Clients reach them through the Tailscale network.
- **Least exposure.** The only mail port meant to face the internet is 25, and
  only after the optional rule is loaded.
- **TLS certificate.** The installer generates a self-signed certificate, valid
  for 365 days and not renewed automatically, when none is present. Clients
  warn about it until it is replaced. `infra/email/issue-certificate.sh`
  replaces it with a Let's Encrypt certificate for the SMTP host name,
  validated through DNS and renewed by a daily systemd timer.

### 3.6 Receiving mail from the internet

Receiving from other mail servers requires three things outside the default
installation:

1. DNS: an `MX` record for the domain that points to the SMTP host name
   (`mx.<domain>` by default), and an `A` record (and `AAAA`, if IPv6 is used)
   for that name with the public address through which the host is reached.
2. TCP port 25 reaching the host (for example, a port forward on the router in
   front of it).
3. The firewall rule in `infra/email/60_smtp.nft`, which accepts port 25 on the
   Wi-Fi interface for both IPv4 and IPv6.

When the host is offline, sending servers keep the message and retry, as SMTP
requires.

**Inbound relay.** Some internet providers block inbound connections to port
25 in their own network, where no router setting can open it. Other mail
servers deliver only to port 25, so the domain's `MX` record then points to a
mail service that accepts the mail on port 25 and forwards each message to the
host on another port. The router forwards that port to the host's port 25, so
Postfix and the firewall rule are the same as for direct delivery. The
mailboxes stay on the host: the relay handles mail in transit and queues it
while the host is unreachable. Postfix sees the relay as the client of every
inbound connection, so checks based on the sending server's address cannot be
done on the host. The reference deployment receives mail this way, on external
port 2525.

### 3.7 Sending mail to other domains

The host does not deliver directly to other mail servers. Outbound mail for
other domains is handed to a relay host (smarthost) on the submission port,
which performs the final delivery. This design suits networks where outbound
port 25 is blocked, which is common on residential connections.

The relay is configured by `infra/email/set-relay.sh`, which works with any
provider of authenticated SMTP submission. Postfix authenticates to the relay
with a user name and password kept in `/etc/postfix/sasl_passwd` (readable by
root only), and it uses the relay only over TLS with a certificate that is
valid for the relay's host name (`smtp_tls_security_level = secure`).

While no relay host is set, Postfix refuses mail for other domains at
submission time with `550 5.4.4`, so nothing waits in the queue for a delivery
that cannot happen.

For recipients to accept the mail as coming from the domain, the domain's DNS
needs the records that the relay provider specifies: usually an SPF record
that authorizes the relay and DKIM records for the keys the relay signs with.

### 3.8 Limits

- One mail domain per installation.
- No spam or virus filtering.
- No webmail; any IMAP client can be used.
- Mail is stored only on the host. Copies are made by pulling an archive from
  another machine (`expathio-mail-backup`); the archives are full copies and
  are not encrypted.

## 4. DNS and certificate automation

The domain's DNS is hosted at Cloudflare. Tooling lives in
[`infra/dns/`](../infra/dns/README.md).

- **Credentials.** An API token limited to editing the DNS records of the
  domain's zone, stored with the zone ID in `/etc/expathio/cloudflare.env`
  (owner `root`, mode 600). The scripts pass the token to `curl` on standard
  input, never on a command line.
- **Dynamic DNS.** The host's connection has a public IPv4 address that can
  change. A systemd timer runs `update-address.sh` one minute after boot and
  every five minutes: it learns the current public address from a public
  service and keeps the `A` record of the SMTP host name at that address. It
  calls the DNS API only when the address changed or once a day.
- **TLS certificate.** `infra/email/issue-certificate.sh` obtains a Let's
  Encrypt certificate for the SMTP host name with the `acme.sh` client. The
  name is validated through a DNS record (DNS-01), so no inbound port is
  involved. The record is created and removed by the DNS record tool, and the
  certificate client never receives the API token. A daily systemd timer
  renews the certificate and reloads Postfix and Dovecot.

