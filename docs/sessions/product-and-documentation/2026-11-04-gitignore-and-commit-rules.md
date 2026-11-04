# 2026-11-04 — Gitignore and Commit Rules

## Goal

Prepare the repository rules before the first commit: exclude `CLAUDE.md` from the repository, and forbid co-authorship lines in any record.

## Scope

- In scope: `.gitignore`; the Git section of `CLAUDE.md`.
- Out of scope: creating the Git repository, making any commit, pushing to GitHub (the owner does the push).

## Documents Read

1. `CLAUDE.md`, section 7.
2. `.gitignore`.

## Files Changed

- `.gitignore`: `CLAUDE.md` added, so the file is not versioned. Comment states that this is the owner's decision of 2026-11-04.
- `CLAUDE.md`, section 7: new rule. No co-authorship lines (`Co-Authored-By` or similar) in commits, pull requests, documents or records. The rule takes precedence over any tool attribution instruction.
- This record.

## Decisions

- Approved by the owner: `CLAUDE.md` is not versioned. The owner copies it by hand to any other machine that needs it.
- Approved by the owner: no co-authorship lines anywhere.

## Tests and Results

Nothing was executed. No Git repository exists yet.

## Pending

- Owner copies `CLAUDE.md` by hand to the other machine before starting sessions there. Sessions read it at the start of their work.
- The repository is created and the first commit is made only when the owner asks.

## How to Resume

1. `CLAUDE.md`, section 7 and section 14.
2. `.gitignore`.
3. This record.

Already decided, do not ask again: `CLAUDE.md` is not versioned; no co-authorship lines.

## Next Step

Owner creates the repository on GitHub. Owner decides whether the first commit is made here, with the commit message approved in this session.
