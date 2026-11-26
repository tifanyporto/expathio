# Expathio

Expathio is a personal project to build a digital space of one's own: a single,
personal and functional environment that brings together aspects of its
creator's life, interests, activities, information and experiences.

Technology is the main instrument for building it, not necessarily its only
purpose. The project is born from the wish for an environment that keeps pace
with real life, with its changes, needs and interests, and that makes it
possible to centralize information, integrate services and develop tools that
make sense in everyday life.

It is meant to evolve organically, starting with essential functionality and
gaining new features as real needs appear. It is not intended to be just
another productivity app or a collection of tools, but a digital environment
with an identity of its own that reflects the person who uses it.

Expathio will be developed initially in English, with a modular architecture,
a desktop-first approach and a focus on autonomy, personalization and
integration.

In essence, Expathio is a personal space under constant construction: an
extension of the life of the person who uses it, with technology as the main
tool to connect, organize and turn ideas into functional experiences.

## Components

| Component | What it does | Where |
|---|---|---|
| Mail server | Self-hosted mail for the project domain (`expathio.com`): SMTP, IMAP and mailbox storage. Exchanging mail with other domains needs the extra setup described in its instructions. | [`infra/email/`](infra/email/README.md) |
| Host firewall | Restrictions on top of the distribution's default firewall: SSH only from local sources, unused ports closed. | [`infra/host/`](infra/host/README.md) |

## Platform

Expathio is self-hosted on a repurposed smartphone that runs plain Linux, with
no Android system.

| | |
|---|---|
| Device | Xiaomi POCO F3 (Qualcomm SM8250, 8 cores, aarch64, 6 GB RAM, UFS storage) |
| Operating system | Nura (formerly postmarketOS), edge channel, on an Alpine Linux base, with a mainline-based Linux kernel |
| Init system | systemd |
| Network | Wi-Fi, with a default-drop nftables firewall |
| Remote access | SSH, and Tailscale (a WireGuard-based private network) |

The full technical description is in [`docs/architecture.md`](docs/architecture.md).

## Design

Expathio's interface is meant to be clean and intimate: warm paper, a single
violet, generous space and plain wording. The colours, typography, components
and voice are specified in [`docs/design.md`](docs/design.md).

## Running it

Each component has its own instructions:

- Mail server: [`infra/email/README.md`](infra/email/README.md) covers the
  requirements, installation, account management and tests.
- Host firewall: [`infra/host/README.md`](infra/host/README.md) covers the
  installation and removal of the restrictions.

## Repository layout

```
README.md              this file
docs/architecture.md   technical specification of the platform and its services
docs/design.md         visual identity and interface rules
infra/email/           mail server: configuration, installer, account tool, tests
infra/host/            host firewall restrictions
```
