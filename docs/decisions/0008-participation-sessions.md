# 0008 — Participation in Work Sessions

**Status:** APPROVED  
**Date:** 2026-11-03  
**Approved by:** Project owner

---

## Context

`01-PRODUCT.md` (section 11, question 6) asked whether participation is continuous or organized into work sessions. The answer affects notifications, absence and how the organization is presented to the participant.

## Alternatives

1. **Work sessions.** The participant enters, works on the tasks of the current simulated day, and leaves. The organization advances between sessions.
2. **Continuous participation.** The participant follows the organization at all times, with live notifications.

## Decision

Participation happens in work sessions.

## Rationale

Work sessions match simulated days (`0001-simulation-time.md`). They keep the experience focused, reduce the need for real-time infrastructure, and give absence a clear meaning: the time between sessions.

## Consequences

- Each session begins with a summary of the events since the last session (`03-USER-EXPERIENCE.md`, section 12).
- Real-time notifications are not required in the first version.
