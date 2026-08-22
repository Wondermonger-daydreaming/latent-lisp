# CHANNEL TOOLING REPAIR /2 — SUCCESSOR-1 RETURN (2026-08-18)

**CANDIDATE ONLY. Nothing here is accepted, closed, or independently verified.
TD-10 and TD-11 remain OPEN and continue to block `SYNC-PAUSED` removal, public-mirror
transport execution, and reliance on post-merge automatic transport. Every hand in this
return — builder (FERRARIUS-TR2), adversary (QUAESTOR-TR2), the round-1–5 chair, and
the sealing chair who wrote this document — is same-root; the STRANGER AUDIT IS OWED.
This parcel exists for Sol's SECOND cold seat. Acceptance, TD closure, and sentinel
lift are owner acts, all still ahead.**

## What is returned

The TR/2 candidate, resubmitted after the first cold seat **BLOCKED** it
(SOL-TR2-01, SOL-TR2-02 — archived verbatim in
`instruments/2026-08-17-sol-tr2-first-disposition-blocked.md`), now **five build
rounds and five adversarial rounds deep**. Rounds 1–2 are the blocked candidate's
history (carried in `TOOLING-REPAIR-2-RETURN-2026-08-17.md`, superseded as a seal but
not rewritten). Rounds 3–5 are the successor work this return covers.

## Round 3 — SOL-TR2-01's six requirements, item by item

Sol's finding, stated without softening (builder's own words, §R3.0 of the build
report): the class-cure "a failed observation must never become an affirmative one"
was written into `post-merge.sh` in round 2 while **the same defect was written into
`post-commit.sh` in the same round**, inside TD-11's own cure. Three same-root hands
passed over it. The six requirements of the disposition, and where each cure lives:

| # | Requirement (disposition, verbatim in the successor commission) | Cure |
|---|---|---|
| 1 | Preserve and examine the exit status of the parent census | `post-commit.sh`: `CENSUS_RC` captured directly from `git rev-list --parents -n 1 HEAD` (no pipeline tail), examined before any classification |
| 2 | Preserve and examine the exit status of the merge-commit tree comparison | `post-commit.sh`: `CMP_RC` captured from the first-parent `diff-tree`; the ordinary-commit comparison's `ORD_RC` likewise (the census in §R3.1 swept **every** git call in both hooks, not just the two plants) |
| 3 | Parent-census failure must not fall through as an ordinary commit | `PARENT-CENSUS-FAILED (git exit $CENSUS_RC) — … NOT classified as an ordinary non-merge commit; launching conservatively with the failure recorded`; if HEAD itself will not resolve: `PARENT-CENSUS-FAILED-NO-SUBJECT — NO eligibility decision was made here and nothing was launched; a human must look` |
| 4 | Comparison failure must never produce `NO-TRANSPORT-DUE`; known 40-hex subject ⇒ conservative launch with failure provenance, else explicit no-decision | `COMPARISON-FAILED — … NOTHING IS CLAIMED ABOUT WHAT THE MERGE CONTAINS: a failed observation is not an empty one. Launching conservatively with the failure recorded`; `NO-TRANSPORT-DUE` is now emitted **only** on a comparison that *succeeded* and returned empty (`the comparison SUCCEEDED and returned nothing`); no-subject arm: `COMPARISON-FAILED-NO-SUBJECT … a human must look` |
| 5 | RED-proven teeth for both exact plants | Both of Sol's plants reproduced exactly in `teeth-td10.sh` (PATH shim → `diff-tree` exit 77 on a real two-parent merge; forced failure of the parent census) — each shown RED **against the blocked candidate's own bytes** before GREEN against the cure (§R3.3). QUAESTOR additionally re-derived both RED arms independently against the hash-verified blocked blob |
| 6 | Re-run the TR/2 suite and the accepted 680/0 suite without weakening either | Suite grew 195 → 268 (round 3) → 322 → 373; never shrank; accepted `teeth-td6-td9.sh` byte-identical to the `214c2c90` blob at every hand; 680/0 at every hand |

Named limit of the round-3 teeth, carried honestly (§R3.3): a PATH shim cannot reach a
git-invoked hook (`git --exec-path` is prepended to the hook's PATH — measured, not
assumed), so plant reproduction is hook/script-level; the branches are proven correct
*when reached* (void #5 below).

## Rounds 4–5 — the class one layer down (extensions 2–3, owner-forked)

- **Q3-F2 (round 4, SCOPE EXTENSION 2):** the SOL-TR2-01 class lives below the hooks:
  `sync.sh`'s `if ! git …` idiom is `set -e`-exempt, and a failed `git merge-base`
  (exit 129) wrote `"reason":"main-only guard: … is not reachable from lab main"` into
  the **durable record** for a commit that WAS reachable. Cure: every set-e-exempt
  guard swept (§R4.1 census); a query's failure is recorded **as itself** (exit code +
  which query), QUERY-FAILED distinguished from QUERY-SAYS-NO, fail-safe direction for
  publication preserved. The `|| exit 0` floors re-declared on their true grounds and
  their silence cured (§R4.3).
- **Q4-F1 (round 5, SCOPE EXTENSION 3 — the gravest of the family: SUCCESS-claiming,
  pre-existing, reproduced on the accepted blob with NO fault injection):** `git
  archive` stamps commit-time mtimes at 1-second granularity; two same-second commits
  with same-size governed content collide on rsync's default quick-check; the copy is
  silently skipped, the index diff is empty, and `sync.sh` recorded a false
  `TRANSPORT-OK — "target already equals the subject tree"` while the mirror held the
  previous bytes. Killed twice over: `--checksum` added to the rsync, AND the no-op
  branch now asserts **content identity** (EXPECTED = subject subtree minus `_staging`
  via `ls-tree|mktree`; ACTUAL = `write-tree` over the staged result; equality of tree
  object ids, never quick-check inference) — a no-op records `VERIFIED by content
  identity`. Cost attribution, corrected for the owner read: the new guarantees cost
  ~6 ms + ~0.27 s; the ~3.1 s bulk is pre-existing archive/extract.
- **Q4-F2 (round 5):** the pause gate's `[ -e ]` read a stat failure as *not paused* —
  fail-toward-transport. Now three-valued: PRESENT / ABSENT-only-when-searchable /
  UNVERIFIED ⇒ **PAUSED**. The RED arm is a REACHABLE fail-toward-transport
  demonstration on the accepted gate (symlinked sentinel in an unsearchable
  directory); Q4-F3's stale census line references refreshed (pause gate = row 0).

## Verification of record (whose hands, exact counts)

The successor rounds' suite series: **106 → 195 → 268 → 322 → 373** assertions
(2286 lines), grown never shrunk; every case measured RED under a deliberately wrong
gate before its GREEN.

| Hand | Round | teeth-td10.sh | teeth-td6-td9.sh (accepted) |
|---|---|---|---|
| FERRARIUS (builder) | 3 | **268/0 ×2**, exit 0 | **680/0**, TEETH GREEN |
| FERRARIUS (builder) | 4 | **322/0 ×2**, exit 0 | **680/0**, TEETH GREEN |
| FERRARIUS (builder) | 5 | **373/0 ×2**, exit 0 | **680/0**, TEETH GREEN |
| QUAESTOR (adversary) | 3 | **268/0 ×2**, exit 0 | **680/0**, TEETH GREEN |
| QUAESTOR (adversary) | 4 | **322/0 ×2**, exit 0 | **680/0**, TEETH GREEN |
| QUAESTOR (adversary) | 5 | **373/0 ×2**, exit 0 | **680/0**, TEETH GREEN |
| Sealing chair (this document) | seal | **373/0 ×2**, exit 0 | **680/0**, TEETH GREEN |

The sealing chair's runs were performed fresh in the sealing session (the owner parked
the arc before the prior chair re-ran the round-5 state; these are the chair hands the
seventh addendum required). Between the chair's two `teeth-td10.sh` runs the only
line-level differences are freshly-minted harness commit ids and `$TMPDIR` paths —
every differing line is `✔ PASS` in both runs (diff inspected, not assumed cosmetic).

Sentinel `tools/latent-lisp/SYNC-PAUSED` sha256
`9b741ed1ac721dca31d9cc935eabda2e684e8d540039c19412dbeec3d216419b` — identical at
every hand's start and end across all five rounds and the sealing session (mtime also
unchanged at the seal: no timestamp-changing touch). Byte-untouched set vs the
accepted `214c2c90`: `teeth-td6-td9.sh` · `transport-record.sh` ·
`transport-supervisor.sh` — `git diff` empty for all three, at every hand.

Subject hashes at the seal (sha256, first 16 hex):

```
sync.sh          8a66455b74961d06    post-merge.sh    09cae79b2ff4f12f
post-commit.sh   e2042e1701d5142b    teeth-td10.sh    4f1e513b3eb1e809
teeth-td6-td9.sh dd93547fa00647bc    (= accepted blob, unchanged)
```

QUAESTOR verdicts: round 3 **SEALABLE-AS-CANDIDATE** (after independently re-deriving
both RED arms against the blocked blob) · round 4 **SEALABLE-AS-CANDIDATE** with
Q4-F1/F2 named (the owner chose to cure before sealing — extension 3) · round 5
**SEALABLE-AS-CANDIDATE**. Three self-caught harness errors across the builder's
rounds are named with their reasons written into the teeth (§R3.4); QUAESTOR's own
round-5 near-miss is §7 of his report.

## CONSOLIDATED NAMED VOIDS — QUAESTOR round 5 §11, verbatim

*Everything still unproven across five rounds. Nothing here is cured; nothing here is
claimed to be harmless.*

> 1. **TD-10 and TD-11 are OPEN.** Nothing in five rounds closes either. `SYNC-PAUSED`
>    raised; transport execution and auto-transport reliance blocked.
> 2. **`ORIG_HEAD` has no freshness proof** (Q-TD10-F5). Every hook-firing git operation
>    writes it first, so no silent miss was reachable — but a forged `ORIG_HEAD` still yields
>    a wrong verdict, `HEAD@{1}` remains an unused free witness, and no tooth proves the
>    external invariant the gate rests on. Uncommissioned.
> 3. **`transport-record.sh` (117 KB) has never been attacked by anyone in five rounds.**
>    Sole writer of custody evidence; declared a future lane. **The largest unexamined
>    surface in the channel.**
> 4. **The root-commit door** (Q2-F1): a root commit carrying governed content produces zero
>    events. Pre-existing, not a merge, practically unreachable on lab `main`, uncured.
> 5. **All plant reproduction is hook/script-level.** A PATH shim cannot reach a git-invoked
>    hook (measured, round 3: `git --exec-path` is prepended to the hook's PATH). Branches are
>    proven correct **when reached**; that real conditions reach them is proven by nobody.
> 6. **Rows 4–5 residuals stand as declared**: the pause gate's `|| echo` can put a
>    non-canonical `source_commit` in the record; a failed `reset --hard`/`clean` can leave a
>    stale work clone (wrong parent, right tree — I verified the tree is right).
> 7. **The `|| exit 0` floors write nothing** — declared on the authority ground, with stderr
>    as the whole record. An operator not watching git's output sees nothing.
> 8. **Q3-F1**: the healthy governed-commit log line differs from accepted (8→12 hex).
>    Documented, not reverted.
> 9. **Nothing run as root; no linked worktree; no `core.hooksPath` variant.** Carried
>    unexercised for five rounds; the accepted five-hands root count `641/0` is
>    **unreproduced by anyone in this lane**.
> 10. **SOL-TR2-02 (self-contained parcel) is unverified by me** — chair's duty; I verified no
>     parcel in any round and claim nothing about one.
> 11. **Mirror drift is nobody's office.** Net-tree equality means *this merge* introduced
>     nothing; it never meant the mirror is current, and no hook reconciles drift.
> 12. **Everything is same-root.** Five rounds, three hands, one model line. The stranger
>     blocked this lane on his first pass and has found something on every look since. **My
>     findings arrived only where a brief pointed me past my own habits** — I audit what the
>     previous document names, and both of my largest catches (Q3-F2's territory, Q4-F1) came
>     from being pushed one step past the last map's edge.

Two additions the voids list pre-dates, stated at the same rank: the conservative
caveat on `--delete`/`_staging` semantics and mode/symlink rsync-move semantics
(round-5 report §3 — the content-identity construction deliberately mirrors the
pipeline's own normalization rather than proving it correct; the **content pipeline is
floored, not finished**), and both hands' shared dig-next pointer: **when a query
inside `transport-record.sh` itself fails, does the record say so?** — the question
this lane answered four times in four files and never in the file that writes the
answers down.

## Chain

TR/2 commission `7086947a` → rounds 1–2 → first return `9e0dde0b` (corrected visibly
`ecc0c5d7`) → parcel `a9adbb59…` → **cold seat 1 BLOCKED** (SOL-TR2-01/02) → successor
commission → round 3 (`d53fe1ef` carries rounds 3–4 instruments) → SCOPE EXTENSION 2
(Q3-F2) → round 4 → SCOPE EXTENSION 3 (Q4-F1/F2, owner fork verbatim in the
instrument) → round 5 (build state at checkpoint `e3744690`) → QUAESTOR round 5
SEALABLE-AS-CANDIDATE → **owner parked at the seal** (`39affac9`, seventh addendum) →
this sealing session (fresh chair): chair hands run, this return written, parcel
sealed. No predecessor document is rewritten.

## The parcel (SOL-TR2-02 compliance)

`~/Downloads/tr2-successor1-2026-08-18.tar.gz` + `.sha256` sidecar (outer hash lives
in the sidecar and the session readback — never inside the parcel). Contents:

- `README-FIRST-the-successor-return.md` — this document.
- `instruments/` — both commissions, scope extensions 1–3, the TD docket, Sol's first
  disposition verbatim.
- `reports/` — the FERRARIUS build report (rounds 1–5, one growing document) and
  QUAESTOR rounds 1–5.
- `subject/` — the ten `tools/latent-lisp` files, flat copies.
- `tr2-successor1-commits.bundle` — **a self-rooted filtered-history bundle** (the
  SOL-TR2-02 cure): the lab lineage exported with history limited to
  `tools/latent-lisp` + this instrument directory (`git fast-export` →
  `git fast-import` into a fresh repository → `git bundle create --all`), **zero
  prerequisites**, verified from inside an empty initialized repository with the
  verify command's own exit status captured. Stated as what it is: the parcel
  materializes the subject-tree evolution byte-exactly under **synthetic commit
  ids**; the lab repository remains the sole authority for full-tree commit identity.
- `commit-mapping.txt` — the lab→parcel sha mapping (paired path-limited logs, equal
  counts asserted).
- `empty-repo-walk-transcript.txt` — the full transcript of the chair's
  empty-directory walk: `git clone <bundle>` with no access to the lab clone, then
  byte-comparison of the cloned tip's subject files against the parcel's flat copies.
- `MANIFEST.sha256` — per-file, never including its own hash; `sha256sum -c` verified
  after sealing from a cold extract.

**No independence anywhere in this return.** Builder, adversary, prior chair, and
sealing chair are one root. Every "verified" above is same-root verification. Sol's
second cold seat and the stranger audit are what stand between this candidate and any
acceptance.

*— recorded by the sealing chair, Claude Fable 5 (1M context), 2026-08-18. Fresh
session, chair hands only, per the seventh addendum of
`notes/2026-08-16-session-handoff-tr1-successor7.md` and the owner's parking word.
Candidate sealed; nothing claimed beyond what four same-root hands can license: the
teeth are green, the teeth can bleed, and the stranger has not yet looked twice.*
