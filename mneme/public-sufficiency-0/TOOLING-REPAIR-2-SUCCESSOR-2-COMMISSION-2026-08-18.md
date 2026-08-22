# CHANNEL TOOLING REPAIR /2 — SUCCESSOR-2 COMMISSION (2026-08-18, after the second cold seat)

**The TR/2 successor-1 candidate is BLOCKED — narrowly, with credit preserved — by
the cold seat's second disposition (SOL-TR2-03; archived verbatim:
`corpus/voices/received/2026-08-18-sol-tr2-second-disposition-blocked.md`). NOT
ACCEPTABLE FOR OWNER ACCEPTANCE. No TD closes. Credit stands where the disposition
grants it — and credit is not acceptance:**

- **SOL-TR2-01 CURED** (Sol's independent replay: `diff-tree` exit 77 → conservative
  launch, no `NO-TRANSPORT-DUE`, durable `via=post-commit-comparison-failed`; parent
  census exit 78 → no ordinary-commit fallthrough, durable
  `via=post-commit-parent-census-failed`).
- **SOL-TR2-02 CURED** (sidecar + 27-entry manifest verify; bundle zero-prerequisite,
  verifies from an empty initialized repository, clones cold, ten subject files
  byte-identical).
- The `--checksum` + content-identity cures are **conservative and RETAINED** — their
  GREEN and mismatch controls passed cold.

## What the cold seat caught (the shape of the miss)

**SOL-TR2-03 — TREE ARCHIVE TIME ≠ COMMIT TIME; the Q4-F1 RED arm is
nondeterministic and did not bite cold.** Production materializes the subject with
`git archive "$LAB_COMMIT:$SUBDIR"`. That object expression resolves to a **tree**,
not a commit — and a tree carries no timestamp, so git stamps the archive's entries
with the **invocation wall-clock**, not the commit time. The round-5 report, the
teeth's comments, and the successor-1 return all attributed the collision to
*same-second commits*; the actually-possible collision is *two subtree-archive
invocations within one wall-clock second*. And the shipped tooth compared two
back-to-back **offline** source archives — it never observed the boundary rsync
actually sees (destination left by transport 1 vs source materialized for
transport 2). Cold: `teeth-td10.sh` 365/8 — five failures are the explicitly named
root/permission void (uncharged), **three are Q4-F1**: the collision precondition
passed by luck, the accepted `sync.sh` transported correctly, no false no-op or false
`TRANSPORT-OK` reproduced. The return's "deterministic / commit-time / 373/0
cold-verifiable" account was too strong.

**Chair verification of the premise (before this commission was filed; §I-f):**
reproduced on this machine, git 2.43.0, scratch repo, 2026-08-18 — `HEAD:sub`
cat-file type = `tree`; commit time `1785542400`; subtree archive calls 1.2 s apart
stamped mtimes `1787078786` / `1787078788` (≈ `now`); whole-commit archive stamped
`1785542400` exactly. Sol measured the same shape under Git 2.51.1 (values in the
archived disposition). The premise holds across both versions.

## Successor-2 requirements (the disposition's seven, verbatim, binding)

> 1. Preserve the SOL-TR2-01 classifier cures and the self-rooted bundle cure
>    unchanged.
> 2. Preserve "--checksum" plus content-identity verification.
> 3. Add an append-only correction distinguishing whole-commit archive timestamps
>    from "<commit>:<subdir>" tree-archive timestamps; correct current code comments
>    and return language without silently rewriting historical reports.
> 4. Replace Q4-F1's tooth with one that observes the actual rsync boundary:
>    destination after transport 1 versus source materialized for transport 2. It may
>    declare the collision precondition only when "(size,mtime)" are equal while
>    bytes differ.
> 5. Against the accepted blob, prove the stale mirror, false no-op, and durable
>    false "TRANSPORT-OK". If the required no-fault reproduction cannot be made
>    deterministic, stop and present an owner fork to amend that requirement—do not
>    count the RED arm green.
> 6. Make root-inapplicable permission plants explicit SKIPs rather than assertion
>    failures, while retaining ordinary-user coverage.
> 7. Re-run, seal a new self-rooted zero-prerequisite parcel, and return it cold.

Reading notes, binding on the builder:

- **Item 3 is append-only in both directions**: comments in the live code and the
  *successor-2* return state the corrected mechanism; the round-5 build report, the
  QUAESTOR reports, and the successor-1 return are historical evidence and are
  corrected by visible addendum/strike, never edited silently.
- **Item 4 defines the only legal collision declaration**: `(size,mtime)` equal AND
  bytes differ, measured at the true boundary (post-transport-1 destination vs
  materialized transport-2 source). An offline archive-vs-archive comparison may
  exist as a *diagnostic*, never as the RED-arm precondition.
- **Item 5 carries an explicit STOP**: the no-fault RED proof must be deterministic
  against the accepted blob (stale mirror + false no-op + durable false
  `TRANSPORT-OK`, all three observed). If wall-clock same-second collision cannot be
  forced deterministically without fault injection, the builder STOPS and the chair
  presents the owner fork (amend the no-fault requirement vs accept a
  controlled-clock arm vs other) — a nondeterministic arm that "happened to pass" is
  exactly what SOL-TR2-03 charges.
- **Item 6 is three-state semantics** (TR/0 precedent: PASS/FAIL/UNAVAILABLE): under
  a non-root user the root-only plants report **SKIP with the reason**, count neither
  passed nor failed, and the summary line carries the SKIP count visibly; ordinary-
  user coverage stays.

## Carried unchanged

All caps of the TR/2 commission + extensions 1–3 and the successor-1 chain: no live
merge · no sentinel change (sha `9b741ed1ac721dca…` start and end, mtime untouched) ·
no mirror contact · no TD-6/TD-9 action · no lab_state/legacy-custody ground ·
builders commit nothing · accepted `teeth-td6-td9.sh` byte-untouched and re-run 680/0
· `transport-record.sh` / `transport-supervisor.sh` byte-untouched (named future
lane) · teeth-td10.sh grows or corrects visibly, never silently shrinks · candidate
standing only · a NEW cold-seat pass on the successor-2 parcel before any owner
acceptance · TD-10 and TD-11 OPEN and blocking sentinel lift, transport execution,
and auto-transport reliance throughout. The successor-1 parcel
(`tr2-successor1-2026-08-18.tar.gz`, sha `d27f4e1d…992d`) is historical evidence —
superseded as a seal, not rewritten.

## Chain

TR/2 commission `7086947a` → rounds 1–2 → cold seat 1 BLOCKED (SOL-TR2-01/02) →
successor-1 commission → rounds 3–5 (extensions 2–3) → sealing session: return
`47675a29`, parcel `d27f4e1d…992d` → **cold seat 2 BLOCKED — narrowly (SOL-TR2-03;
01/02 CURED, credit preserved)** → this successor-2 commission. No predecessor
document is rewritten.

*— recorded by the chair, Claude Fable 5 (1M context), 2026-08-18, the SOL-TR2-03
premise verified by the chair's own hands before filing.*
