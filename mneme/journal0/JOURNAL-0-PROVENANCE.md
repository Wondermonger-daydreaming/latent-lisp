# JOURNAL-0-PROVENANCE — files opened in this lane

*RESTITUTOR (Claude Fable 5 subagent), 2026-07-29. Successor to CONDITOR,
who was killed mid-lane by a platform outage on 2026-07-29 (checkpoint:
`notes/2026-07-29-journal0-outage-checkpoint.md`).*

## Scope of this record

This file lists every file **this hand** opened during the resumption life
that verified the thirteen inherited partials and completed the lane.
**I cannot know the predecessor's reads from inside**; the authority for
CONDITOR's exposure is the **chair's transcript audit** recorded in the
outage checkpoint: the dead builder's full 1,447,685-byte transcript was
grep-audited by the chair and showed **zero Class B access** (zero
`file_path` reads and zero verb-adjacent shell reads of the fenced files;
three apparent coarse-grep touches proved regex artifacts of line-spanning
matches). The first sealed transcript did not exist at my spawn, so
ALLOWED-SOURCES Class B remained fully forbidden to me throughout.

## Class B contact: ZERO

I did not open, grep, head, read, or otherwise consult, in whole or part:
`tools/pj0_vector_tool.py` · `tools/pj0_kill9_harness.py` · anything under
`atelier/kw-0/` (specimen/src, hb0, next/ss0) or `_staging/ss0-bench/` ·
`REVIEW-HOSTILE-byte-crash.md` · the withheld plan drafts
(`kernel-0-drafts/SOL-PJ0-PLAN.md`, `PJ0-PLAN-*`, `_staging/pj0/PJ0-PLAN-*`).

## Files read into context (this life)

Orientation / governance (chartered read order):
- `notes/2026-07-29-journal0-outage-checkpoint.md`
- `mneme/journal0/ALLOWED-SOURCES.md`
- `_staging/journal-store-recon-INDAGATRIX.md`

Class A normative texts:
- `mneme/architecture/process-journal-0/LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md` (in full, 1,451 lines)
- `mneme/architecture/process-journal-0/PJ0-PRESEAL-REPAIRS.md`
- `mneme/architecture/process-journal-0/PJ0-ADOPTION-RECORD.md`
- `mneme/architecture/process-journal-0/PJ0-REFERENCE-TRANSCRIPT.md`
- `mneme/architecture/process-journal-0/PJ0-MUTATION-SCORECARD.md`
- `mneme/architecture/LISP-PLUS-KERNEL-0-SPEC.md` — header map by grep; read
  §2.4, §3 (conformance classes), §13–§15.1, §19.9, §20.6, §27.1–§27.3
- `mneme/architecture/kernel-0-errata/LISP-PLUS-KERNEL-0-ERRATA-0.2.md` (in full)

Frozen vectors and manifests (tests, not paths):
- `mneme/architecture/process-journal-0/PJ0-FIXTURE-REGISTRY.sexp` (in full)
- `fixtures/truncation/final-frame-every-byte/TRUNCATION-MANIFEST.sexp` (head, then parsed in full by the runner)
- `fixtures/semantic/*.sexp` (all six, content heads via shell)
- `fixtures/crash-windows/JOURNAL-META.pjs` + `.sha256` (full, via shell)
- shell `sha256sum`/`wc -c`/`find` over `fixtures/` (file listing, sizes, digests)

Adopted dependencies (public surface only):
- `mneme/kernel0/package.lisp`
- `canonical-datum/common-lisp/package.lisp`
- directory listings of `mneme/kernel0/`, `canonical-datum/common-lisp/`,
  `mneme/architecture/kernel-0-errata/`

The thirteen inherited partials (all read in full before any reuse):
- `mneme/journal0/{package,load,sha256,conditions,pjs0,frame,meta,reader,writer,salvage,fold,mutants}.lisp`
- `mneme/journal0/journal0-selftest.lisp`

## Files opened programmatically by executed code (not read into context)

- every fixture byte-file under `mneme/architecture/process-journal-0/fixtures/`
  (registry-driven, sha256-verified before use by the runner)
- `mneme/kernel0/*.lisp` and `canonical-datum/common-lisp/{package,cd0}.lisp`
  (loaded as the adopted dependency chain via `mneme/journal0/load.lisp` →
  `mneme/kernel0/load.lisp`; CD/0 is Class A as a loaded dependency)

## Files written (this life)

`mneme/journal0/`: `journal0-vectors.lisp` (new) · repairs to `reader.lisp`,
`writer.lisp` (event-identity keying) · one regression check added to
`journal0-selftest.lisp` · `RUN-SELFTEST.txt`, `RUN-VECTORS.txt`,
`RUN-VECTORS-SECOND.txt`, `RUN-EXITCODES.txt`, `JOURNAL-0-PROVENANCE.md`,
`JOURNAL-0-COMPARISON.md`, `README.md`.
Outside the lane: `_staging/journal0-BUILD-REPORT.md` only.
