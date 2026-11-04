# 0011 — Initial Host

**Status:** APPROVED  
**Date:** 2026-11-03  
**Approved by:** Project owner

---

## Context

The first phases of Expathio need a place to run the database and the application. No real participant uses the platform before Phase 4 (`06-ROADMAP.md`).

The owner has a POCO F3 phone running postmarketOS, a Linux distribution without Android apps. The owner reports that the device is fully functional and has run 24 hours a day on power in a previous project. This report was not verified by Claude.

## Alternatives

1. **POCO F3 running postmarketOS as the initial host**, under the conditions below. Chosen for the first phases.
2. **The owner's development computer** for the database and the application. Most reliable, but the computer must stay on and the platform stops when it is off.
3. **A paid virtual server.** Estimated at R$ 30 to 60 per month, not verified. Reliable, and within the budget of R$ 100 to 200 per month mentioned in `05-TECHNICAL-ARCHITECTURE.md`, section 17. Not needed while there are no real participants.

## Decision

The POCO F3 running postmarketOS hosts the database and the application through Phase 3, under these conditions:

1. **Configurable paths.** The database address and the file storage location come from environment variables, so moving to another host is a configuration change (`docs/decisions/0010-scalability-foundations.md`, decision 3).
2. **Daily backup off the device.** The backup is copied to a computer or another location outside the phone.
3. **Private access only.** The device is reachable only through a private network, such as Tailscale, with no port open to the internet.
4. **No real participant data** before the hosting decision for Phase 4. That decision must be recorded in a new ADR before the first participant is admitted.

## Rationale

The option has no extra cost, and the owner has experience with the device. It is enough for development and for demonstrations without real users. Keeping the paths configurable means the move to another host, when needed, does not require rewriting the code.

## Consequences

- Availability depends on the home power supply and internet connection.
- The phone's storage is a single point of failure until the backup is in place. Backup is a prerequisite for storing any data that matters.
- The device is not suitable for load testing.
- Maintenance (operating system updates, service restarts, backups) is the owner's responsibility.
- Before Phase 4, this decision must be reviewed. The choice may remain, but only with a new ADR that accepts the risks for real participant data.
