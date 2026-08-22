# TOOLING REPAIR /1 — PREFLIGHT / LIVE-STATE REPORT (2026-08-13)

**Commission step 2: re-authentication of the starting repository. All
values measured this sitting, on disk / via read-only API.**

## Repository

- Branch: `many-acts-0-candidate`.
- Commission starting HEAD: `c4c8e9a50761aaf36b3e910406e7e56363c2bd81`.
- Delta from the instruction's inspected HEAD `a0ba3ce5…8f7c`: exactly
  `2ad8936f` + `c4c8e9a5`, both checkpoint commits touching only
  `tools/ledger/agents.jsonl` (LICTOR provenance rows) — the expected
  ledger/autosync class. **Consequential state UNCHANGED; no stop
  condition fired.** (Commission opening then added `dd7e411e`, three
  files: archived readback, commission instrument, staged inspection
  report.)
- Tracked tree otherwise clean (`git diff --check` clean); pre-existing
  untracked `_staging/` material preserved untouched.

## Canonical scripts vs installed hooks (the TD-8 fact, re-verified)

- Canonical: `tools/latent-lisp/{sync.sh, post-commit.sh, post-merge.sh,
  install-hook.sh, verify-sync.sh}`; `post-merge.sh` carries
  `--commit "$FULL"` (the 2026-08-02 fix).
- Installed: `.git/hooks/post-commit` = two-line delegator to the
  canonical script (current); `.git/hooks/post-merge` = **STALE full copy**
  (mtime 2026-07-19), message-only invocation, no `--commit` — diff
  against canonical is non-empty (rc=1). `install-hook.sh` installs only
  `post-commit`; nothing refreshes `post-merge`.
- `tools/latent-lisp/.sync.log`: host-local, gitignored
  (`tools/latent-lisp/.gitignore:1`), ~501 KB, live.

## Mirror (read-only remeasure — the TD-6 live fact)

Full table in `TOOLING-REPAIR-1-TD6-OWNER-FORK-2026-08-13.md` §1. Summary:
`main` **unprotected** (404), **zero rulesets**, **zero deploy keys**, sole
collaborator = owner account, and the lab host's authenticated principal
IS the owner account (`admin:true, push:true`) — no distinct sync
principal exists. Mirror last pushed `2026-08-10T19:36:16Z`; 29 branches.

## Docket identities

Second series defined solely in
`TOOLING-DEFECT-DOCKET-2026-08-12.md` (latest docket commit `3815a777`);
TD-1..TD-5 CLOSED WHOLE at `5153f211`, untouched by this commission.
TD-6..TD-9 at commission start: **DEFINED-UNREPAIRED** (per the
2026-08-13 state inspection, parcel seal `966d9727…b7021`, authenticated
by Sol's documentary readback — ceiling: parcel bytes only, live repo not
independently remeasured by Sol).

## Surgery-window safety measure

`tools/latent-lisp/SYNC-PAUSED` sentinel created at surgery start (reason
text inside): while transport scripts are under edit, an unrelated
commit (e.g. hermes autosync cron) must not execute a half-edited
`sync.sh`. Removed at integration; its presence/removal is recorded in the
integration commit.

*— chair, 2026-08-13.*
