# de-teste-occiso — PROVENANCE

*Every file this hand opened, this life, in building the restart specimen.
Filed per `mneme/journal0/ALLOWED-SOURCES.md` standing note 4. Class B reads:
**zero**.*

**Hand:** SUPERSTES (Claude Fable 5 subagent), 2026-07-29.
**Host:** Linux 7.0.0-28-generic x86_64 · SBCL **2.4.6**, verified live
through the wrapper (`(lisp-implementation-version)` executed via
`sbcl --script` before any specimen CL ran — the SBCL-wrapper operation-check
scar).

---

## Class A — read (with the extent actually read)

### The substrate this specimen exercises (`mneme/journal0/`)

| file | extent read |
|---|---|
| `ALLOWED-SOURCES.md` | whole file (the fence, read first) |
| `README.md` | whole file |
| `JOURNAL-0-COMPARISON.md` | whole file |
| `RUN-EXITCODES.txt` | whole file |
| `package.lisp` | whole file (the public surface) |
| `load.lisp` | whole file |
| `salvage.lisp` | whole file (113 lines) |
| `writer.lisp` | lines 1–402 (whole file: store surface, §9 append, §10/§11) |
| `fold.lisp` | lines 1–180 and 215–310 of 401 (fold source, projection, joint report, seat resolution head, `reconstruct`, `merge-journals` docstring); plus a `defun`/`defstruct` name index over the whole file |
| `meta.lisp` | lines 125–171 (`build-metadata-record`, `render-metadata-octets`) |
| `journal0-vectors.lisp` | lines 1–215, 840–880, 960–990 of 983 (check machinery, scratch and fixture plumbing, negative-control-10 child pattern, final result block); plus greps for `run-program` / `RESULT:` |
| `journal0-selftest.lisp` | lines 40–120, 260–360, 400–430, 470–510 of 682 (event construction, writer/idempotency/lock patterns, torn-store pattern, `derive-seat-resolution` and `reconstruct` patterns); plus a grep index of `append-event` call sites |
| `RUN-VECTORS.txt` | first 8 lines (load-noise shape) |
| `RUN-SELFTEST.txt` | first 6 lines (load-noise shape) |

### Governing specification (`mneme/architecture/process-journal-0/`)

| file | extent read |
|---|---|
| `LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md` | the section-heading index (whole-file grep) plus, verbatim: **§1** the crash-window matrix incl. PJ-CW-1..4 (lines 46–66) · **§9–§11** append protocol, receipts, durability, locking (312–410) · **§15** witness separation and epistemic origin (507–530) · **§19** reconstruction receipts (585–612) · **§29–§33** deterministic crash fixtures, the randomized SIGKILL harness's ten MUSTs, the reference transcript, conformance classes, cross-language verification (826–910) · **Annex B** crash-window expected-state table (1062–1077) |

### Other

| file | extent read |
|---|---|
| `mneme/kernel0/load.lisp` | grep of lines 1–60 (whether the loader prints, for capture determinism) |

**Not opened, though Class A and available:** `PJ0-PRESEAL-REPAIRS.md`,
`PJ0-ADOPTION-RECORD.md`, the FABLE review, `REVIEW-NOTES-scar-trace.md`, the
Kernel /0 spec and Errata, the Canonical Datum spec, the fixture registry and
fixture tree, `PJ0-REFERENCE-TRANSCRIPT.md`, `PJ0-MUTATION-SCORECARD.md`. The
specimen consumes the journal0 store as a *public API* and needed none of
them; R-PJ-0/1/2/3 reach this hand only through the inline citations already
carried in the journal0 sources.

---

## Class B — forbidden before the first sealed transcript

**Zero reads.** Specifically never opened, in whole or in part, by any means
(Read, `cat`, `sed`, `grep`, `head`, `tail`, or subprocess):

- `mneme/architecture/process-journal-0/tools/pj0_vector_tool.py`
- `mneme/architecture/process-journal-0/tools/pj0_kill9_harness.py` — **the
  reference writer-under-kill control flow.** This specimen's kill protocol
  was written from §30's ten MUST clauses and §1/Annex B alone. It is
  therefore an independently seeded kill harness, and its §30 coverage is
  partial by construction (see `SPECIMEN-RETURN.md` §4).
- anything under `atelier/kw-0/` (specimen/src, hb0, next/ss0, the `_staging`
  twins)
- `mneme/architecture/process-journal-0/REVIEW-HOSTILE-byte-crash.md`
- the withheld reference-author drafts (`SOL-PJ0-PLAN.md`,
  `PJ0-PLAN-DRAFT-F.md`, `PJ0-PLAN-CONCORDANCE.md`, `_staging/pj0/…`)

## Boot-document exposure (harness-is-exposure rule)

This hand booted wearing `CLAUDE.md` and the lab `MEMORY.md`. Both name the
kw-0 arc's existence and closure and the journal0 lane's results; neither
contains PJ0 frame grammar, validation control flow, or kill-harness logic.
The task charge itself named the §1 windows, the §30 harness's existence, the
`RUN-EXITCODES.txt` recipe, and negative control 10's child-process pattern —
all Class A pointers, recorded here as exposure.

*— SUPERSTES (Claude Fable 5 subagent), 2026-07-29*
