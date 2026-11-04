# 0018 — The production phone is dedicated to Expathio

**Status:** APPROVED

## Context

The POCO F3 phone that hosts Expathio (ADR 0011) was already running a Linux setup for another personal project, which the owner has abandoned. That setup includes services that start at boot, a database, project files, a terminal session and a device name on the private network that still refers to the old project. The owner has a backup of the old project on the Windows computer.

Expathio needs a clean host so that its setup can be built from scratch, with every component known and documented.

## Alternatives

1. Keep the old project on the phone and run Expathio beside it. Rejected: old services and data could interfere with Expathio, and the phone's state would be unknown.
2. Remove the old project and everything that refers to it, then rebuild the phone for Expathio. Chosen.
3. Move Expathio to a different host. Not considered now: ADR 0011 keeps the phone as the host through Phase 3, and no other host has been approved.

## Decision

- The phone is dedicated to Expathio. Nothing from the old project remains on it after cleanup.
- Before removal, every item is listed and the old project's data is backed up to the Windows computer. Removal happens item by item, each one approved by the owner.
- The device name on the private network changes from the old project's name to `expathio`. The address used for remote access changes with it.
- The fixed wallpaper (lock screen or home screen image) changes to the Expathio name.

## Justification

- A host with only known components is easier to restore, document and back up (ADR 0011 requires daily backup off the device).
- Leftover services or data from another project would create risks that the Expathio runbook would have to cover.
- The owner has confirmed that all items on the phone belong to the abandoned project.

## Consequences

- The remote access command used by the Infrastructure and Operations session changes after the device rename. Its records must use the new name.
- The cleanup must be recorded in `docs/sessions/infrastructure-and-operations/`, with the list of removed items and the check that followed each removal.
- The Infrastructure and Operations session carries out the cleanup, step by step, with owner approval for each change on the phone (`docs/SESSION-STRUCTURE.md`, section 3.3).
- Network names, IP addresses and user names of the device stay out of the repository (`CLAUDE.md`, section 11).
- ADR 0011 remains valid. This decision adds the cleanup and the dedication of the device.
