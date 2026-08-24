# Pre-cure controls — the laundering, shown before it was cured

*Phase 0 of RELEASE FLOOR ERRATUM /0. Nothing here was run inside the lab checkout: every
run used a history-complete `git clone` of the lab repo at `91267fae` in `/tmp`.*

Three controls. **A and B are planted; C is wild** — a real, unplanted, full 112-row floor
run that laundered two dead gates into a green terminal line the night before the repair.

| # | control | aggregator | scale | terminal line |
|---|---|---|---|---|
| A | a floor row's `python3` script absent from the tree | UNREPAIRED, reduced to a 5-row REAL subset | 5 rows | `FLOOR RESULT: PASS (5 … / 4 passed / 1 blocked)`, exit 0 |
| B | `subject-digest.sh` HARD FAILs over an absent manifest | UNREPAIRED, reduced to a 5-row REAL subset | 5 rows | `FLOOR RESULT: PASS (5 … / 4 passed / 1 blocked)`, exit 0 |
| C | rows [071] `fail-open-witness.sh` and [072] `semantic-path-diff.sh` could not resolve historical ref `431fee16` in a history-free venue | UNREPAIRED, **unmodified, full table** | **112 rows** | `FLOOR RESULT: PASS (112 executable gates attempted / 110 passed / 2 blocked; …)` |

## What the reduction is, exactly (A and B)

`harness/mkvariant.sh` replaces the body of the `GATES` heredoc with five rows taken
**verbatim from the real table** (it refuses any row that is not present verbatim in the
source) and recomputes `AUTHORIZED_GATES_FULL`/`_CI` from them. It then *proves* the
confinement: it normalises both files (table body → one placeholder, the two constants →
`<N>`) and refuses unless the normalised files are byte-identical. So the classifier, the
materializer, the cleanliness probes, the lane accounting and the terminal gate under test
are **byte-identical to the unrepaired full-table script**. The confinement proof is printed
in each transcript's header.

This is a stated judgment call: a full 112-row run costs ~90 minutes per plant. The full-scale
evidence is control **C**, which needed no plant at all.

## What A shows, in the aggregator's own words

```
[001] atelier     INPL python3 mneme/atelier/static-check.py
      -> BLOCKED-EXTERNAL-INPUT (exit 2 — required input absent, gate did not run)
...
PASS                   atelier      1 gate(s), 0 passed, 1 BLOCKED-EXTERNAL-INPUT
...
FLOOR RESULT: PASS (5 executable gates attempted / 4 passed / 1 blocked; 9 carried status rows; profile full)
=== aggregator exit: 0
```

The lane's STATUS column reads **PASS** for a lane in which **zero gates passed**. The file
was simply not there; `python3` said so with exit 2; the reader called that "required input
absent, gate did not run" and kept the floor green.

## What B shows

```
      -> BLOCKED-EXTERNAL-INPUT (exit 2 — required input absent, gate did not run)
         subject-digest.sh: HARD FAIL — manifest absent: …/errata-0.3/SUBJECT-MANIFEST.txt
```

This is the sharper one, per LUCERNA §2.4: the row's `EXPECT` is the literal digest
`9214b59b…6aaf99`, which is **not** in the log — and the `rc == 2` branch short-circuits
*before* the EXPECT check, so the floor never asks.

## What C shows — and the wall it names

C is `notes/floor-transcripts/nightly-2026-08-23-f5ba80c6.txt`, produced at 03:53 UTC on
2026-08-23 by the lab's own nightly cron (`tools/cron/nightly-floor.sh`) with **no plant and
no modification whatsoever**. Rows [071] and [072] need historical commit `431fee16`; the
nightly materialises its venue with `git archive … | tar -x` + `git init`, which is
**history-free**, so both rows refused with exit 2 and printed their reasons:

```
[071] surface1    INPL bash fail-open-witness.sh
      -> BLOCKED-EXTERNAL-INPUT (exit 2 — required input absent, gate did not run)
         subject under witness : 431fee16:…/run-surface1-candidate.sh
[072] surface1    INPL bash semantic-path-diff.sh
      -> BLOCKED-EXTERNAL-INPUT (exit 2 — required input absent, gate did not run)
           UNRESOLVABLE REF: 431fee16 is not a commit in this checkout.
```

and the floor closed with

```
   attempted                : 112
   passed                   : 110
   failed                   : 0
   blocked-external-input   : 2
FLOOR RESULT: PASS (112 executable gates attempted / 110 passed / 2 blocked; 9 carried status rows; profile full)
```

**110/2 is the same pair Sol I retro-described for the public-side ML0 floor at `9a56eabd…`:
"110 PASSED · 2 EXECUTABLE GATES DID NOT RUN · AGGREGATE INCOMPLETE."** The nightly has been
reporting that state as PASS. In the history-complete baseline (`kiln-afc532b3.transcript.txt`)
both rows read `PASS (exit 0)` and the floor is 112/112.

**Consequence of the repair, reported and NOT acted on (out of jurisdiction):** after this
erratum the nightly's history-free venue will report `FLOOR RESULT: FAIL` every night and page
the owner. That is the *correct* reading of that venue — it cannot execute the full floor — and
the fix belongs to `tools/cron/nightly-floor.sh` (clone instead of archive+init), which is
outside this commission's jurisdiction. See `RETURN.md` §Walls.

*— LECTOR, 2026-08-23*
