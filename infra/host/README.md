# Host firewall

Restrictions added on top of the distribution's default nftables rules. The
access model they implement is specified in
[`docs/architecture.md`](../../docs/architecture.md), section 2.

`05_restrict.nft` leaves the distribution's files untouched. It adds a separate
table whose chain runs before the distribution's `inet filter` chain and drops:

- SSH (TCP 22) and DNS (TCP/UDP 53) from any source that is not local. They
  stay reachable from the private network (Tailscale), from USB networking,
  and on other interfaces from private IPv4 ranges and link-local IPv6 only.
- TCP 24727 and TCP/UDP 53317, which the distribution opens for desktop
  applications (AusweisApp2, LocalSend) that a server does not run.

## Requirements

- A host running Nura (formerly postmarketOS) with nftables, where
  `/etc/nftables.nft` includes `/etc/nftables.d/*.nft` (the distribution
  default).
- Working SSH access over Tailscale or from a local IPv4 address, because
  SSH from public addresses stops working when the file is loaded.

## Install

Replace `<user>` and `<host>` with your SSH account and the host's name.

```sh
scp infra/host/05_restrict.nft <user>@<host>:
ssh -t <user>@<host> 'sudo install -m 644 ~/05_restrict.nft /etc/nftables.d/ && sudo nft -c -f /etc/nftables.nft && sudo nft -f /etc/nftables.d/05_restrict.nft'
```

The second command installs the file, checks that the whole boot-time
configuration still validates (`nft -c` changes nothing), and then loads the
file into the running firewall. If the check fails, nothing is loaded: delete
`/etc/nftables.d/05_restrict.nft` so that the next boot is not affected.

Load the file with `nft -f` as shown. On this distribution,
`systemctl reload nftables` flushes the whole ruleset first, which also removes
rules that other software, such as Tailscale, added at runtime.

The file can be loaded again at any time, and it is loaded at every boot.

From the local network, connect to the host's IPv4 address. Its global IPv6
address does not accept SSH.

## Remove

```sh
ssh -t <user>@<host> 'sudo nft delete table inet expathio_restrict && sudo rm /etc/nftables.d/05_restrict.nft'
```
