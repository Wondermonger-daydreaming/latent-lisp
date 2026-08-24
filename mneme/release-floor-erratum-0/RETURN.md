# RELEASE FLOOR ERRATUM /0 — RETURN

*LECTOR, 2026-08-23. Commissioned by Sol I's exit-2 ruling
(`corpus/voices/received/2026-08-23-sol-i-exit2-ruling-floor-erratum-work-order.md`), executed against the
work order in this directory. **This is a returned candidate. It binds nothing.** Sol and the owner bind
transport separately; nothing here was pushed to any remote and `tools/latent-lisp/SYNC-PAUSED` was not
touched.*

> Three honest speakers distinguished their refusals; one integer erased the distinctions at the boundary.
> Now repair the reader. — LUCERNA, entered by Sol I

---

## 1. THE EXACT CANDIDATE

| item | value |
|---|---|
| **repair commit** (the seven cures land here) | `d8b147ede953f24d09658c04c3dbe84ea24566b7` |
| **evidence commit** (the tree the full floor measured) | `79ceeadab8dc6ae188fcc8cc3a3d179fbed41e76` |
| evidence commit tree | `3748d6884d402fcea5a9dc38722776b54a1db209` |
| **subject tree** (`HEAD:experiments/latent-lisp`) | `c37461a1a41f00ee9f538ef3ac4680a055825d65` |
| `verify-release.sh` blob, **before** | `c6f398acdff5c679fad45ca8135db9c711763bc6` |
| `verify-release.sh` blob, **after** | `012b33413903c4d7a64256645bcae73a32a20cba` |
| `verify-release.sh` file sha256, after | `f8b5af5477579ec835f8a9d921e26798aee98f3ce897d78e7ecfb1e25d945ad7` |
| diff size | 357 insertions, 71 deletions, 1 file |

**Why two commit ids, and why that is not a fudge.** `d8b147ed` is the commit that changed the subject —
it is the only commit in this arc that touches `mneme/verify-release.sh`. `79ceeada` adds the phase-2
teeth transcripts (receipts, all inside `release-floor-erratum-0/`) and is the tree the full floor actually
measured, so it is the honest name for "what was run". The two are interchangeable *as to the subject*, and
that is checkable in one command:

```
$ git diff d8b147ed 79ceeada -- experiments/latent-lisp/mneme/verify-release.sh
(empty)
```

**The pre-repair blob is the same blob the sealed baseline ran.**
`afc532b3:…/verify-release.sh` == `966d7ed5:…/verify-release.sh` == `c6f398ac…`. The script I repaired is
byte-for-byte the script that produced the baseline transcript the projection is diffed against.

Receipts committed after `79ceeada` (this RETURN, the evidence directory) touch nothing outside
`release-floor-erratum-0/` and cannot change floor behaviour.

---

## 2. THE COMPLETE DIFF

`evidence/verify-release.OLD-to-NEW.diff` (sha256 `d46ba442d6237231d02ce2ca1f8ad7e0821bfe537a106f7db2686bdd11e60ea8`),
i.e. `git diff 966d7ed5 79ceeada -- mneme/verify-release.sh`. `bash -n` was run clean after every edit, and
once more on the final file.

### The seven cures, and where each lives

**Cure 1 — the generic `rc == 2` exemption is gone.** The classifier is now:

```bash
    if [ "$rc" -ne 0 ]; then
      status="FAIL"
    elif [ "$expect" != "-" ] && ! grep -qF -- "$expect" "$log"; then
      status="FAIL"
    else
      status="PASS"
    fi
```

`BLOCKED-EXTERNAL-INPUT` is now **structurally unsettable** for an executable row — no branch assigns it.
The counter `N_BLOCKED`, its reporting arm and its terminal conjunct are **deliberately retained**: if a
future edit reintroduces a blocking path, the terminal conjunction refuses instead of quietly passing. This
is the only place where I kept something the ruling could have been read as deleting; I judged a dead
guard-rail cheaper than a live re-entry. **Stated as a judgment call, not as instruction.**

No replacement external-input protocol was invented. Sol I's four requirements for a future one are quoted
verbatim into the script's header, marked as *not built here*.

**The ten leaf refusers were not touched.** `git diff` shows exactly one changed file.

**Cure 2 — the CWD speaks.** The old `( cd "$dir" 2>/dev/null && eval "$cmd" )` discarded the shell's own
diagnostic, so "never started" and "ran and disagreed" were one string over an empty log. Now the directory
is entered in a probe whose stderr is captured; on failure the row gets `GATE-CWD-ABSENT` (nothing there)
or `GATE-CWD-UNREADABLE` (there, could not be entered), and the log is written with the declared cwd, the
resolved path, the tree, the cd exit and **the shell's verbatim diagnostic**. Observed firing, tooth 5:

```
      -> GATE-CWD-ABSENT (exit 1)
...
      GATE-CWD-ABSENT: the declared working directory could not be entered.
        declared cwd : mneme/language-surface-1/errata-0.3
        resolved to  : /tmp/lector/teeth-clone/…/mneme/language-surface-1/errata-0.3
        cd exit      : 1
        shell said   : mneme/verify-release.sh: line 515: cd: …: No such file or directory
        The command was NEVER STARTED.
```

**Cure 3 — materialization from the committed object, failing closed.**
`git archive <subject tree> -- . :(exclude)… | tar -xf -`, under the file's existing `pipefail`, with
`PIPESTATUS` checked on both stages and the stderr of each preserved and printed. Any failure prints
`NO GATE RAN` and exits 1 **before `run_gate` is ever called**.

Prefix resolution, both topologies: `SUBJECT_PREFIX=$(git rev-parse --show-prefix)` — `experiments/latent-lisp/`
in the lab monorepo, empty in the public mirror — and the tree-ish is `HEAD:${SUBJECT_PREFIX%/}`, which
`git rev-parse` accepts as `HEAD:` for the empty case (verified live: it returns the root tree). **Scar worth
recording:** pathspecs are resolved relative to git's own working directory, so the first implementation
(`git -C "$ROOT" archive … -- .`) died with `fatal: pathspec '.' did not match any files` in the monorepo.
`archive` and `ls-tree` are therefore driven from `rev-parse --show-toplevel` while the tree-ish stays the
subject subtree; the pathspecs are then relative to the subject in both topologies. That failure was caught
by running it, not by reading it.

**Cure 4 — identity proven before mutation.** Path, mode and byte, against the committed tree, not a file
count. Expected manifest from `git ls-tree -r -z` (NUL-safe, C-sorted, the two declared exclusions filtered
— `ls-tree` refuses `:(exclude)` magic, so the filter is a `grep -v` on the two declared prefixes and is
printed in the transcript). Observed manifest from `find -type f` + `git hash-object --stdin-paths` (a git
blob oid *is* the sha1 of the content) plus a `[ -x ]` mode column. Guards: a NUL-count/line-count
comparison refuses any path containing a newline; any non-regular file in the copy is a failure. The two
corpus symlinks are created **only after** the identity check passes — that is what "before mutation"
means here. Observed on the evidence run:

```
   identity     : VERIFIED — 4637 entries match the committed tree in path, mode and byte
```

**Cure 5 — cleanliness probes carry their exit status.** Both probes capture `$?`. A failed probe sets
`CLEANLINESS-UNKNOWN` (and re-runs the command once, read-only, to print its diagnostic); the floor then
refuses to print `unchanged` and fails closed at the conjunction. A failed *initial* probe also poisons the
*after* comparison — the transcript says so in words rather than comparing two values one of which is a lie.

**Cure 6 — the lane table is derived.** `LANES_PRINTED` comes from the selected gate table by `awk`, in
first-appearance order. The invariant is then asserted, not assumed: every executed row's lane must be in
the printed set, and the printed lane totals must sum to `N`. Either violation prints
`!! LANE ACCOUNTING VIOLATED` and fails closed. The old hardcoded census had silently dropped `act1` and
`ml0` — **15 executed rows, in the two ADOPTED lanes** — and the projection of the sealed baseline records
that hole numerically: `lane gate sum|97` against 112 rows attempted.

**Cure 7 — PASS is conjunctive, and shows its work.** Eight conjuncts, each printed with its own verdict:

```
 TERMINAL CONJUNCTION — every line must read [ok] for PASS
   [ok ] committed-tree materialization succeeded and its identity was proven
   [ok ] exact authorized attempt count: attempted 112, profile full authorizes 112
   [ok ] every executable gate passed: 112 passed of 112 authorized
   [ok ] zero non-passing executable gates: 0
   [ok ] zero executable blocks: 0  (no branch can set this status since ERRATUM /0)
   [ok ] lane accounting: every executed row in exactly one printed lane, totals exact
   [ok ] caller's checkout unchanged across the run
   [ok ] cleanliness was actually OBSERVABLE (both git status probes succeeded)
```

Two smaller repairs made in passing, both stated: the header's status vocabulary and `HYGIENE` sections were
rewritten to match the new semantics (leaving a wrong vocabulary in place would be its own defect), and
`--help` no longer prints a hardcoded line range (`sed -n '2,60p'`) that the erratum's own header growth had
already invalidated — it now prints the leading comment block by structure.

---

## 3. THE [071]/[072] QUESTION, ANSWERED BY RUNNING IT

The work order asked me to check the two rows expected to block lab-side and to **stop and report** rather
than invent policy. Here is what is true, shown:

- Rows `[071] bash fail-open-witness.sh` and `[072] bash semantic-path-diff.sh` need historical commit
  `431fee16`. They are `writes=no`, so they read the **caller's checkout**, not the copy.
- In a **history-complete** checkout the commit is present and both rows **PASS**. Sealed baseline
  `kiln-afc532b3.transcript.txt`: `PASS (exit 0)` for both. This erratum's evidence run: `PASS (exit 0)` for
  both. The ordinary lab-side clean run is **112/112**, exactly as the work order predicted.
- The table does **not** mark them blockable; nothing declares them blockable anywhere. There was no
  "green-via-blocked" *policy* to replace, only an untyped integer. **No policy was invented.**

So Sol I §II required no accommodation, and none was built.

---

## 4. PRE-CURE CONTROLS (`pre-cure/`) — the laundering shown before the cure

| # | control | aggregator | scale | terminal line |
|---|---|---|---|---|
| A | a floor row's `python3` script absent | UNREPAIRED, 5 REAL rows | 5 | `FLOOR RESULT: PASS (5 … / 4 passed / 1 blocked)`, exit 0 |
| B | `subject-digest.sh` HARD FAIL over an absent manifest | UNREPAIRED, 5 REAL rows | 5 | `FLOOR RESULT: PASS (5 … / 4 passed / 1 blocked)`, exit 0 |
| **C** | **wild, unplanted**: rows [071]/[072] could not resolve `431fee16` in the nightly's history-free venue | **UNREPAIRED, unmodified, full table** | **112** | `FLOOR RESULT: PASS (112 … / 110 passed / 2 blocked)` |

**Which is which, said exactly, as instructed.** A and B are **reduced-table** demonstrations: the real
unrepaired aggregator with its `GATES` heredoc replaced by five rows taken verbatim from its own table.
`harness/mkvariant.sh` refuses any row not present verbatim in the source, and then *proves* the confinement
— it normalises both files (table body → one placeholder, the two `AUTHORIZED_GATES_*` → `<N>`) and refuses
unless the normalised files are byte-identical. The classifier, materializer, cleanliness probes, lane
accounting and terminal gate under test are therefore byte-identical to the full-table script. Both produced
a **genuine terminal `FLOOR RESULT: PASS` over a planted broken executable gate**, at aggregator exit 0. The
lane table even printed `PASS   atelier   1 gate(s), 0 passed, 1 BLOCKED-EXTERNAL-INPUT` — status PASS for a
lane in which nothing passed.

**C needed no plant and no reduction.** It is the lab's own nightly cron transcript from 03:53 UTC that
morning (`notes/floor-transcripts/nightly-2026-08-23-f5ba80c6.txt`, copied in verbatim), a full 112-row run
that reported two dead gates as blocked and closed green. `110 PASSED · 2 EXECUTABLE GATES DID NOT RUN` is
the same pair and the same arithmetic Sol I retro-described for the public-side ML0 floor at `9a56eabd…`
as **AGGREGATE INCOMPLETE**. The defect was live, in production, unplanted, the night before the repair.

---

## 5. THE TWELVE TEETH — before / after index

All twelve observed firing. Transcripts in `teeth/` (1–11) and `evidence/` (12); `teeth/SUMMARY.txt` is the
one-line-per-tooth roll.

| # | Sol §IV item | pre-cure | post-cure (observed) | transcript |
|---|---|---|---|---|
| 1 | missing Python gate | **control A**: `BLOCKED` → floor PASS | `[001] -> FAIL (exit 2)` → floor FAIL | `teeth/01-…` |
| 2 | argparse exit 2 | — | `[002] -> FAIL (exit 2)` → floor FAIL | `teeth/02-…` |
| 3 | bash syntax exit 2 | — | `[003] -> FAIL (exit 2)` → floor FAIL | `teeth/03-…` |
| 4 | hard-refuser, manifest removed | **control B**: `BLOCKED` → floor PASS | `[003] -> FAIL (exit 2)`, log carries `HARD FAIL — manifest absent` | `teeth/04-…` |
| 5 | declared CWD absent | — | `GATE-CWD-ABSENT`, log nonempty, names the directory and the shell's own error | `teeth/05-…` |
| 6 | archive/extraction failure | — | `NO GATE RAN`; **zero `[0xx]` row lines in the whole transcript** | `teeth/06-…` |
| 7 | incomplete materialization | — | identity check names the one missing path *before* gates: `< mneme/kernel0/kernel0-selftest.lisp 100644 0b4dca6f…`, expected 4623 / observed 4622 | `teeth/07-…` |
| 8 | initial `git status` fails | — | `git before   : CLEANLINESS-UNKNOWN — the probe itself failed (exit 128)` → floor FAIL | `teeth/08-…` |
| 9 | final `git status` fails | — | **all five gates PASS and the floor still FAILs** on the observability conjunct | `teeth/09-…` |
| 10 | synthetic extra lane | — | `PASS  erratum0-synthetic  1 gate(s), 1 passed`; `6 + 0 unaccounted == 6 attempted` | `teeth/10-…` |
| 11 | planted lane omission | — | `LANE ACCOUNTING VIOLATED` twice (uncovered row **and** short sum) → floor FAIL | `teeth/11-…` |
| 12 | ordinary clean control | baseline 112/112 | **112/112, eight `[ok]`, EXIT 0** | `evidence/FULL-FLOOR-79ceeada.transcript.txt` |

Teeth 1 and 4 are pre-cure controls A and B **re-fired against the repaired reader**: same plant, same venue,
same command — `BLOCKED` → green becomes `FAIL (exit 2)` → red.

### Judgment calls in the teeth, stated loudly

1. **Teeth 1–11 used the reduced authorized table** (five real rows; tooth 10 adds a sixth in a synthetic
   lane, allowed by an explicit `MKVARIANT_ALLOW_SYNTHETIC=1` that prints `!! SYNTHETIC ROW` in the
   transcript). Reason: eleven ninety-minute floors to observe eleven classifier decisions is not evidence,
   it is ceremony. The confinement proof is printed in each transcript's header. Tooth 12 is a genuine full
   112-row run.
2. **Tooth 11's subject is a mutated copy of the repaired script** — one added `grep -v '^kernel0$'` in the
   lane derivation. An invariant cannot be seen to fire unless the thing it guards is broken. The plant's
   full `diff` is printed in the transcript before the run.
3. **Cleanliness and materialization teeth use PATH-shadowed wrappers**, and each wrapper's complete source
   is copied into its own transcript:
   - tooth 6: a `git` wrapper that `exec`s the real git for every verb **except** `archive`, which exits 1;
   - tooth 7: a `tar` wrapper that runs the real `tar`, **exits 0**, and then deletes one file from the
     `-C` destination — so extraction "succeeded" and the copy is silently short by one file;
   - teeth 8/9: a `git` wrapper that counts `status` invocations in a file and fails the 1st (tooth 8) or
     the 2nd (tooth 9) only, passing every other verb and every other call through to the real git.
4. Every tooth ran against the **real repaired `verify-release.sh`**, never a reimplementation, in a
   history-complete clone detached at the candidate. The plant tree was restored between teeth and the
   restoration was asserted, not assumed.

---

## 6. FULL-FLOOR EVIDENCE (Sol §V)

**Venue.** A standalone `git clone` of the lab repo into `/tmp/lector/evidence-clone`, detached at
`79ceeada`. History-complete: **6807 commits reachable from HEAD**, and `git cat-file -t 431fee16` answers
`commit` — the two historical-ref rows can actually run here.

**Identity capture came first** (`evidence/IDENTITY-CAPTURE-79ceeada.txt`), before any other command in the
clone, per the 08-22 erratum. Start and end:

```
HEAD          : 79ceeadab8dc6ae188fcc8cc3a3d179fbed41e76      HEAD-END      : 79ceeada…  (same)
HEAD tree     : 3748d6884d402fcea5a9dc38722776b54a1db209      HEAD tree END : 3748d688…  (same)
subject tree  : c37461a1a41f00ee9f538ef3ac4680a055825d65      subject tree  : c37461a1…  (same)
porcelain     : 0 entr(y|ies)                                 PORCELAIN-END : 0 entr(y|ies)
```

**Quiescence held.** Nothing was written into the measured checkout during the run; drafts lived in `/tmp`
and receipts landed in the lab checkout between runs, never mid-run. The transcript carries its `EXIT` line
(`EXIT 0`), so its verdict is not ⊥.

**Terminal line, verbatim:**

```
FLOOR RESULT: PASS (112 executable gates attempted / 112 passed / 0 blocked; 9 carried status rows; profile full)
```

### The canonical semantic projection, and its diff

`harness/projection.py` extracts row number · lane · tree · command identity · status · exit · lane order ·
lane totals · carried statuses · terminal counts, in a form stable across both floor wordings. Applied to
the sealed baseline `notes/census-2026-08-22/kiln/kiln-afc532b3.transcript.txt`
(`HEAD-START afc532b3222fc34d2e1bae9c2c8752d9b609f72c`, `PORCELAIN-START 0`, 112/112 — the transcript Sol
named, found and used) and to this run. **The complete diff is 32 lines and contains exactly three facts:**

```
 ## LANEORDER
-…|act0|vertical0|cd0|lci0|atelier|release
+…|act0|act1|ml0|vertical0|cd0|lci0|release|atelier

 ## LANES
+act1|6|6|0|0
+ml0|9|9|0|0
-atelier|1|1|0|0        (moved: the derived order is the table's own)
+atelier|1|1|0|0

 ## TOTALS-CHECK
-lane gate sum|97
+lane gate sum|112
```

- **The `## ROWS` section is byte-identical**: all 112 rows, same numbers, same lanes, same trees, same
  command identities, same statuses, same exit codes.
- **The `## CARRIED` section is byte-identical**: nine carried rows, unchanged.
- **The `## TERMINAL` counts are byte-identical**: attempted 112, passed 112, failed 0, blocked 0, 9 carried
  rows and every `of which` sub-count.
- The only differences are `act1` and `ml0` **appearing** and the lane order following the table — i.e.
  **lane-table completeness**, exactly one of the three changes Sol adjudicated in advance. `97 → 112` is the
  hole closing.

`evidence/prose.diff` enumerates the wording deltas separately, and they are only: the new materialization /
identity / exclusions lines, the `lane accounting :` line, the two `act1`/`ml0` lane rows, the
"structurally zero" paragraph, the rewritten exit-0 doctrine paragraph, the `TERMINAL CONJUNCTION` block —
plus the baseline's own kiln-wrapper preamble, which is not floor output at all. All within
**floor wording · lane-table completeness · terminal doctrine**.

**One post-repair full floor was run.** It was quiescent and no tooth exposed another mechanism, so per Sol
I §V no second ceremony was manufactured.

### Artifact index and hashes

| file | sha256 |
|---|---|
| `evidence/FULL-FLOOR-79ceeada.transcript.txt` | `5406580f28fe88f9b5783a11c48d2b5e802b0cc6f1accde1a5db1fcac96b40c3` |
| `evidence/IDENTITY-CAPTURE-79ceeada.txt` | `b4cce844f40b39bf0a33007134bfda97bd56ed9764be169f2dc94a0ae8c54365` |
| `evidence/projection-baseline-afc532b3.txt` | `da6c0b1e13df28d587faba00be6b307d6afbc21d3bebedad61aecafd3c11452d` |
| `evidence/projection-candidate-79ceeada.txt` | `7935ba305fd8a56d2b8e1ae8d678b17b40cfee5b9649e3e0e4793290bf91d6f3` |
| `evidence/projection.diff` | `8ea33aff88296d5c8c63e31bc9adf80cc77ae5e7c3da64f4b85bbe6c465ef398` |
| `evidence/prose.diff` | `f2b454158a6823dfd380bdd3c45e11be58216fb373f7fc20277af0678a1d31ac` |
| `evidence/verify-release.OLD-to-NEW.diff` | `d46ba442d6237231d02ce2ca1f8ad7e0821bfe537a106f7db2686bdd11e60ea8` |

No outer tarball was cut; the chair parcels.

---

## 7. WALLS — reported, not routed around

**W-1. The lab's nightly floor cron will now go RED every night, and it is right to.**
`tools/cron/nightly-floor.sh` materialises its venue with `git archive "$H:experiments/latent-lisp" | tar -x`
followed by `git init` — **history-free by construction**. Rows [071]/[072] cannot resolve `431fee16` there,
so under the corrected semantics that venue produces `FLOOR RESULT: FAIL` and the cron pages the owner. The
*state* it is reporting has not changed since 2026-08-22; only the honesty of the report has. Sol I already
named that state: **AGGREGATE INCOMPLETE, never PASS**. The fix is a one-line venue change (clone instead of
archive+init), and `tools/cron/` is **outside this commission's jurisdiction**, so I did not touch it.
*This is the highest-priority follow-up in this return: the pager fires at 03:30 UTC.*

**W-2. The floor now refuses to run outside a git checkout, and that is a venue narrowing.**
Cure 3 requires a committed subject object; a tree with none has nothing to copy and no identity to prove.
So a history-free `git archive` export — the shape of the 2026-08-22 stranger-audit venue — is no longer a
venue this floor will execute in *at all*; it fails closed at preflight with a named message instead of
running and laundering. I believe this is the ruling's intent (a floor that cannot say which bytes it
measured measures nothing), and it is consonant with Sol's venue-preflight amendment, but it is a **real
narrowing of where the floor can be run** and a stranger's sandbox must now be a real checkout. Flagged for
Sol rather than softened.

**W-3. A materialization asymmetry the ruling did not address.**
`writes=yes` rows now run against the **committed** bytes while `writes=no` rows still run in the **working
tree**. In a clean checkout at HEAD these are the same bytes and nothing changes. In a *dirty* checkout they
are not, and one floor would be measuring two different subjects. Making the read-only rows also read the
copy is a much larger change with its own consequences (several rows read repository *history*, which the
copy does not have — see [071]/[072]), so I did **not** do it. Recorded as a live seam, not repaired.

**W-4. A pre-existing stale consumer, not caused by this erratum.**
`mneme/language-many-acts-0/ma0-campaign-gates.sh:266` asserts
`FLOOR RESULT: PASS (77 executable gates attempted / 77 passed / 0 blocked`. The CI profile has authorized
**82** since ML/0's registration. That gate was already stale before I arrived; my change does not alter the
terminal line's format. MA/0 scripts are not floor rows. Noted for the docket; untouched.

**No cure was stopped.** All seven landed; nothing in the ruling interacted badly enough to abandon a cure.
The one place I went beyond the letter — retaining the dead `N_BLOCKED` guard rather than deleting the
vocabulary entirely — is declared in §2, cure 1.

---

## 8. WHAT THIS RETURN DOES NOT DO

- It **adopts nothing, publishes nothing, transports nothing.** No push to any remote; the
  `tools/latent-lisp/SYNC-PAUSED` sentinel was not touched and remains raised.
- It does **not** reopen One Act /0, One Act /1 or Memory Layer /0. Their binding lab-side transcripts
  recorded every executable row as `PASS (exit 0)` with zero blocked rows; the defective branch was not
  traversed in those runs. **Memory Layer /0 remains: ADOPTED AND PUBLISHED · stranger audit owed · no
  independent verification.**
- It touched **no** frozen lane byte: ML0's 61 files, Act1's 38 files, the adopted Surface Account object and
  the ten leaf refusers are all unchanged. One file changed in the subject: `mneme/verify-release.sh`.
- It does **not** repair Vertical /0 finding #2, Surface Account finding #3 or Slice /2 finding #9 — separate
  commissions.
- It is **self-consistency work by the same family**: I repaired the reader and I ran the reader. The
  **stranger audit remains OWED**, and a green floor here is not independent verification of anything.
- The transitive closure LUCERNA left **UNSWEPT** is still unswept — say *unswept*, not *clean*.

---

*— LECTOR (Claude Fable 5, 1M context), 2026-08-23. Every claim above has an artifact in this directory;
where a step is compressed, it says so.*
