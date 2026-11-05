# 0020 — Release History and Versioning

**Status:** APPROVED  
**Date:** 2026-11-05  
**Approved by:** Project owner (accepted the recommendation of the Architecture and Quality session on 2026-11-05)

---

## Context

`05-TECHNICAL-ARCHITECTURE.md`, section 16, lists "release history" as something the project should support. No approved decision defines how releases are recorded. ADR 0016 defines rollback at the level of direction, and its steps are to be written in Phase 1.

The repository is public and is on GitHub (ADR 0012). The project has one person and no pull requests (ADR 0015). Continuous integration is deferred (ADR 0016).

## Alternatives

1. **Git tags only.** Each production release gets a tag, such as `v0.1.0`. Cost R$ 0. Very low maintenance. Records exactly which code was released, but not what changed.
2. **Git tags and a `CHANGELOG.md` file in the repository.** The same as 1, plus a short English entry per release describing what changed. Cost R$ 0. Low maintenance.
3. **Automatic changelog tool** (for example, release-please or changesets). Generates the list from commit messages. Needs a new library and a fixed commit format, and works best with continuous integration. Not adopted now; requires owner approval if proposed later.
4. **Deployment log on the phone**, written by the deployment script. Records date, version, applied migrations and health-check result. It is operational history, not release history. Cost R$ 0.

## Decision

1. **Tags.** Each version that goes to the phone has a Git tag in the form `vMAJOR.MINOR.PATCH` (semantic versioning). The project stays at `0.x.y` until Phase 5 is complete. The first complete version is `1.0.0`, at the end of Phase 5 (`06-ROADMAP.md`).
2. **Changelog.** The repository has a `CHANGELOG.md` file at the root. It has one short entry per tag, in English, written by the owner before the tag is created.
3. **GitHub Releases.** Each tag also gets a GitHub Release, with its notes copied from `CHANGELOG.md`. Publishing a release is an action visible to everyone, so the owner approves each one.
4. **Deployment log.** The deployment script writes a log on the phone with date, version, applied migrations and health-check result. The log must not contain personal data or secrets (`CLAUDE.md`, section 11).
5. **Tag check before deployment.** The deployment script should check that the version being deployed has a tag and that the working tree is clean. This is a detail of the deployment script, to be specified in Phase 1 by the Infrastructure and Operations session. It is not decided here.

## Rationale

- Tags give an exact link between a version and its code, which supports rollback (ADR 0016).
- A changelog keeps the history readable without a new tool, and writing it is a learning step for the owner.
- GitHub Releases add a public page with no extra cost, using the existing repository.
- Numbering below 1.0.0 signals that the product is still in development, as its phases show.

## Consequences

- Cost: R$ 0 per month.
- Maintenance: a few minutes per release to write the changelog entry, create the tag and, if approved, the GitHub Release.
- Discipline: no tag without a changelog entry. The deployment check in item 5 enforces this in Phase 1.
- Automatic changelog tools (alternative 3) require a new ADR and owner approval.
- The phone's deployment log (item 4) is part of the Phase 1 deployment script.
