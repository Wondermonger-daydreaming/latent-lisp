# CENSUS-REPORT — S1/S2 overclaim + pin sweep

Date: Tue Sep 15 01:40:02 PM -03 2026 (`date` run at task start)
Scope: whole repo `/home/gauss/Desktop/Claude-Code-Lab` (excl. `.git/`, scratchpad) + MEMORY detail-files dir
`/home/gauss/.claude/projects/-home-gauss-Desktop-Claude-Code-Lab/memory/`.
Full tables: `overclaim-census.md` (task 1), `pin-census.md` (task 2), `manifest-check.txt` (task 3), all in this dir.
Read-only throughout; no repo files touched; no judgment offered on whether the candidate correction is right.

## Task 1 — Overclaim census

8 literal patterns searched (`cannot do this`, `outside the package cannot`, `caller outside the package`,
`package privacy`, `internal row constructor`, `future work, deliberately`, `cross-journal case to future
work`, `R4.1-F3`): **556 raw hits, 152 unique files.** `internal row constructor` and `cross-journal case to
future work` (as one phrase) matched **zero** files — nobody uses that exact wording anywhere in the tree.

Bucket = document TYPE, not whether the hit repeats the overclaim as true (checked separately, see below).

| Bucket | Unique files |
|---|---|
| LIVE-SUMMARY | 9 |
| NORMATIVE-CONTRACT | 1 (`MEMORY-LAYER-0-SPEC.md`) |
| SOURCE | 3 (`ml0-consolidation-proof.lisp`, `ml0.lisp`, + `toaster-benchmark/probe-bypass.lisp`, a related probe) |
| HISTORICAL-TESTIMONY | 123 |
| OFF-TOPIC (coincidental phrase match, unrelated to S1/S2) | 16 |
| MEMORY dir (searched separately) | 1 file (`ml0-arc-detail.md`), 2 of 8 patterns hit |
| **Total unique files, repo + MEMORY** | **153** |

**Headline finding: no LIVE-SUMMARY, NORMATIVE-CONTRACT, or MEMORY document currently asserts S1 or S2 as
true.** Every one of the 9 LIVE-SUMMARY hits (`ARCHITECTURE-0-STATUS.md`, `LMP0-clauses-SA-ML0.md`,
`MEMORY-LAYER-0-{GUIDE,RETURN,WORK-ORDER}.md`, `verify-release.sh`'s embedded ledger row,
`docs/operational-protocols.md`, the 09-14 readiness brief, the 08-21 session-handoff) either cites the
**correct** rule ("package privacy is not a capability boundary … BOA closes the supported `#S` route, not
every possible call") or explicitly marks P9/S1 **FAIL/disproven** and the cross-journal case **OPEN
governance item**, never "future work." The SPEC (`MEMORY-LAYER-0-SPEC.md:189,203,311,319,347,366,469,667,676,678,902,904`)
states the same correct rule throughout — verbatim excerpts in `overclaim-census.md` §"SPEC's own current
wording."

**The two exact false sentences stand asserted-as-true in exactly 3 places each, all SOURCE-tier:**
- S1 (`"A caller outside the package cannot do this."`): the live `ml0-consolidation-proof.lisp:42`, plus its
  two frozen audit-packet copies (`_staging/2026-09-01-ml0-stranger-audit-ingress-0/{packet,packet-0.1}/ENVELOPE-B/lane/ml0-consolidation-proof.lisp:42`).
  Three more hits quote it in backticks as testimony (Sol II's received returns) — those are HISTORICAL, not assertions.
- S2 (`"narrows the cross-journal case to future work, deliberately (fork R4.1-F3)."`): the live `ml0.lisp:3002`,
  plus the same two frozen packet copies. **No other document repeats this exact sentence anywhere** — the
  closest is `_staging/r41c-scriba-iii-report.md:141`, which quotes the OLD wording only to show the correction
  applied to `RETURN.md:2108` ("→" arrow, explicit supersession record).

OFF-TOPIC set (16 files) is coincidental phrase overlap with unrelated corpus: Spinoza's *Collected Works*,
conversation archives, `corpus/voices/2026-07-06-r4-*`, `sibling-meeting-battery.md`, an LMArena prompt
capture, `basin/`, a detokenize-meditation note, two playground pieces, and — importantly — three files that
use "package privacy" language about a **different lane** entirely (Language Slice /0's `::` ablation
`CENSUS-SLICE-0.md`/`DISPOSITION.md`, latent-mvp's `V1-CLOSURE-TRACE-LEDGER`, and Public Sufficiency /0's
`act0.lisp` unexported-condition finding). None of these 16 is about Memory Layer /0's S1/S2.

## Task 2 — Pin census

Computed at HEAD: `ml0-consolidation-proof.lisp` sha256 `6e83648eaada…bd4b`; `ml0.lisp` sha256
`784bc7f6e6d0…c4c6df`; `FILE-MANIFEST.txt` sha256 `3029ecba285e…5b13`.

| Pin | Hits | Type |
|---|---|---|
| H1 (`ml0-consolidation-proof.lisp` sha256, full+12-char prefix, identical set) | 8 | 8 MANIFEST-RECORD, 0 prose |
| H2 (`ml0.lisp` sha256) | 9 | 9 MANIFEST-RECORD, 0 prose |
| HM (`FILE-MANIFEST.txt` sha256) | 12 | 5 MANIFEST-RECORD, 7 prose |
| Lane tree OID `9458616a438f…` (`git rev-parse HEAD:mneme/memory-layer-0`) | 12 | all prose, in 09-01 stranger-audit-ingress packets + received letters |
| latent-lisp subtree OID `e148d8a5344c…` (whole `experiments/latent-lisp`, pinned at the 09-09 README-supersession crossing) | 34 | all prose, in `_staging/2026-09-09-*`, `_staging/2026-09-11-a13-r3-reconciliation-0/*`, `corpus/voices/received/originals/2026-09-{09,11,14}-*`, `notes/2026-09-09-session-handoff-cut-from-the-commit.md` |

**MANIFEST-RECORD** = a text file (`SHA256SUMS`, `*.sha256`, `CARGO-MANIFEST.txt`, `FILE-MANIFEST.txt` itself,
`AUDITOR-CHECKOUT-MANIFEST-*.txt`) whose row format is directly checkable by `sha256sum -c` — but is itself
just text, not a script. **Zero executable scripts** (`.sh`/`.py`/`.lisp` under `experiments/latent-lisp/` or
`tools/`) reference `FILE-MANIFEST.txt` by name or check these two files' hashes specifically.
`rg -n "sha256sum -c" experiments/latent-lisp tools --glob '*.sh' --glob '*.py'` → 15 hits, all in
`tools/parcel/`, `tools/stranger-harness/`, `tools/latent-lisp/dry-run-cargo*.sh` — each checks a *different*,
generically-named `SHA256SUMS` for a different parcel/cargo payload, never this lane's `FILE-MANIFEST.txt`.
`verify-release.sh` (the lane's own live floor script) builds its own `git ls-tree`-derived manifest at run
time and never reads `FILE-MANIFEST.txt` — confirmed zero occurrences of that string in the script.

**Consequence for the candidate correction:** editing either file's comment bytes will (a) change H1/H2 and
invalidate 2 of `FILE-MANIFEST.txt`'s 61 rows, (b) change `FILE-MANIFEST.txt`'s own hash (HM) and thus every
HM pin, (c) change the lane tree OID `9458616a438f…` and thus every one of its 12 citations, and (d) change
the whole-subtree OID `e148d8a5344c…` and thus every one of its 34 citations across three separate
Astra-commissioned crossings (09-09 README-supersession, 09-11 a13-r3-reconciliation, 09-14 WARRANT SESSION
readiness). None of these pins is re-verified by a standing script; every one is a point-in-time prose/table
record from a past ferry or audit.

## Task 3 — FILE-MANIFEST.txt generation + live verification

Header (verbatim): *"Every file of the lane, with its sha256. Generated by code, not typed... Produced by
`find` over the WHOLE lane (this file itself excluded, since a manifest may never include its own hash) and
verified with `sha256sum -c` before it was committed."* **No literal `find` command line is shown** — only
that prose description. Regenerated 2026-08-21 in round R5; header states "61 entries"; counted independently:
`grep -cE '^[0-9a-f]{64}  '` → **61**, matching. Header explicitly lists `ml0-consolidation-proof.lisp` as
**UNCHANGED** in R5 (so S1 predates R5 unmodified).

Live check, read-only, run from the lane dir today:
```
$ cd experiments/latent-lisp/mneme/memory-layer-0
$ date  →  Tue Sep 15 01:46:49 PM -03 2026
$ grep -E '^[0-9a-f]{64}  ' FILE-MANIFEST.txt | sha256sum -c --quiet -
$ echo EXIT=$?  →  EXIT=0
```
**Result: the manifest currently verifies exactly (exit 0, no FAILED lines)** — all 61 listed files match
their recorded sha256, including both target files as they stand today (overclaims and all). Full transcript
+ header quote in `manifest-check.txt`.

## Files in this dir
- `overclaim-census.md` — full 152(+1)-row table, per-bucket, SPEC/RETURN/GUIDE/ARCHITECTURE-0-STATUS
  verbatim cross-journal wording, and the S1/S2 asserted-vs-quoted breakdown.
- `pin-census.md` — full hash/OID pin tables with file:line + type.
- `manifest-check.txt` — header quote, row count, and the read-only verification transcript.
