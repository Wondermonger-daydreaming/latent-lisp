# journal0 — ALLOWED SOURCES (the independent-seeding boundary)

*Recorded by the chair BEFORE any implementation coding began, per the owner's
lane-opening charge of 2026-07-29 and R-PJ-3 / Kernel Errata 0.2 §7. This file
is the exposure fence for the first independently-seeded Common Lisp Mneme
journal store. Pattern precedent:
`language-slice-0/stranger-implementation-1/ALLOWED-SOURCES.md` and
`atelier/kw-0/hb0/HB0-PROVENANCE.md`.*

**Governing law (Kernel Errata 0.2 §7, verbatim):** the implementation *"MUST
NOT import, translate, mechanically port, embed, or line-by-line imitate the
Python generator, serializer, parser, validator, fake-adapter state machine,
or expected-result computation. Divergences adjudicate to specification
text."*

The boundary below binds every hand in this lane until the **first
independent conformance transcript is sealed**. After that seal, Class B may
be consulted for differential diagnosis only, and every post-exposure repair
must be identified as post-exposure in the return.

---

## CLASS A — READABLE BEFORE THE FIRST SEALED TRANSCRIPT

Normative specifications and adopted law:
- `mneme/architecture/LISP-PLUS-KERNEL-0-SPEC.md` (store boundary: §2.4, §3.2,
  §13, §14, §15.4, §19.9, §20.6, §25.5, §27.1)
- `mneme/architecture/kernel-0-errata/LISP-PLUS-KERNEL-0-ERRATA-0.2.md`
  (esp. §2 K0E-8..17, §4 structural-vs-semantic, §7 charge, §8 controls 10–14)
  + its adoption/disposition records
- `mneme/architecture/process-journal-0/LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md`
  (all 39 sections + Annexes A–F)
- `mneme/architecture/process-journal-0/PJ0-PRESEAL-REPAIRS.md` — **first-class
  governing text**: R-PJ-2 (PJ-READ-0, binary-mode I/O) exists ONLY here
- `mneme/architecture/process-journal-0/PJ0-ADOPTION-RECORD.md`
- `mneme/architecture/process-journal-0/LISP-PLUS-PROCESS-JOURNAL-0-FABLE-REVIEW.md`
- `mneme/architecture/process-journal-0/REVIEW-NOTES-scar-trace.md`
- `mneme/architecture/process-journal-0/{RELAY-TO-SOL-PJ0-ADOPTED,RELAY-TO-FABLE-PROCESS-JOURNAL-0,PROCESS-JOURNAL-0-AUTHORING-RECEIPT,README}.md`
- `mneme/architecture/LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md`
- `mneme/architecture/IMPLEMENTATION-PHASE-BOARD-2026-07-18.md`,
  `mneme/architecture/ARCHITECTURE-0-STATUS.md`

Frozen vectors, manifests, expected classifications (tests, not paths):
- the entire `mneme/architecture/process-journal-0/fixtures/` tree (raw bytes)
- `PJ0-FIXTURE-REGISTRY.sexp` · `fixtures/truncation/final-frame-every-byte/TRUNCATION-MANIFEST.sexp`
- `SHA256SUMS.txt` · `PJ0-MUTATION-SCORECARD.md` · `PJ0-REFERENCE-TRANSCRIPT.md`

Canonical Datum /0 — as a LOADED DEPENDENCY and public API:
- `canonical-datum/common-lisp/{package.lisp,lisp-plus-cd0.asd,README.md}` and
  the spec `mneme/spec/CANONICAL-DATUM-SPEC.md` + `CANONICAL-DATUM-SPEC-ERRATA-0.1.md`
- `canonical-datum/common-lisp/cd0.lisp` may be LOADED (it is the adopted
  implementation the store must call) and consulted for its public behavior;
  it is not PJ0 reference logic. The PJ-S/0 **text codec must still be written
  fresh** — CD/0's binary octets are not the payload bytes (PJ0 §5 bijection;
  PJ-SYN-3).
- `mneme/kernel0/` — the adopted Kernel /0 pure core (class A; contains no
  journal I/O; `load.lisp` is the CD/0 load-order precedent; its fold is the
  §12-step-16 semantic partner, Errata §8 controls 10–14)

## CLASS B — FORBIDDEN BEFORE THE FIRST SEALED TRANSCRIPT

The reference implementation (the core prohibition):
- `mneme/architecture/process-journal-0/tools/pj0_vector_tool.py` (2,299
  lines — generator, PJ-S/0 codec, validator, all six mutants, registry
  authoring; the single most forbidden file in the tree)
- `mneme/architecture/process-journal-0/tools/pj0_kill9_harness.py` (58 lines
  — reference writer-under-kill control flow; §30's ten MUST clauses in the
  spec fully specify a fresh reimplementation)

Prior journal machinery, CL and Python (the underrated hazard — some of it
answers this lane's exact questions in this lane's exact language):
- `atelier/kw-0/specimen/src/` — ALL files (esp. `kw-common.lisp`, a
  self-described "PJ0-subset" CL journal exporting `validate-prefix`,
  `fold-state`, `classify-recovery`; also `kw-reconstruct.lisp`,
  `kw-baseline.lisp`, `kw-runner.lisp`, `kw-oracle.lisp`, `folder.py`,
  `harness.py`, `f6v3.py`, shell runners)
- `atelier/kw-0/hb0/` — `hb0-control.lisp`, `hb0-reader2.py`,
  `hb0-harness.py`, `kw-oracle.lisp`
- `atelier/kw-0/next/ss0/substrate/` and `.../ss0/bench/teeth/` — all `.lisp`
  and `.py` (framed append-only log with prefix reader and planted defective
  readers), incl. `_staging/ss0-bench/teeth/` twins

Quarantined review (adopted in standing, but it quotes reference internals
and recites 12 unfrozen mutants WITH their expected classifications):
- `mneme/architecture/process-journal-0/REVIEW-HOSTILE-byte-crash.md` — its
  binding conclusions are available via `PJ0-PRESEAL-REPAIRS.md` and the
  FABLE-REVIEW, which state the same law without the internals.

Withheld as reference-author reasoning (content a strict subset of the sealed
spec; the builder loses nothing):
- `architecture/kernel-0-drafts/SOL-PJ0-PLAN.md`, `PJ0-PLAN-DRAFT-F.md`,
  `PJ0-PLAN-CONCORDANCE.md`, `_staging/pj0/PJ0-PLAN-DRAFT-F.md`

## STANDING NOTES, BINDING ON THE GATE'S DESIGN

1. **The registry's `expected-error` strings are the Python tool's vocabulary**
   (one is a verbatim CPython codec message no CL implementation can emit).
   The gate is defined over `expected-status` + `expected-valid-frames` + a
   mapped §23 condition CATEGORY — never `expected-error` string equality.
   This is the first "divergences adjudicate to spec text" application, and
   it is a property of the frozen artefact, not of any implementation.
2. **The crash-window fixtures are NOT in the registry** (9 files under
   `fixtures/crash-windows/`; expected states live in §29, Annex B, and the
   reference transcript). `cw2-full-unacknowledged.pj0` and
   `cw3-full-synced-receipt-lost.pj0` are byte-identical by design — the
   CW-2/CW-3 distinction is scenario metadata, never derivable from bytes.
3. **Boot-document exposure**: every agent in this lane boots wearing
   CLAUDE.md + MEMORY.md, which name the kw-0 arc's existence and closure but
   contain no PJ0 algorithm text, frame grammar, or validation control flow.
   Enumerated here per the harness-is-exposure rule.
4. Every hand in this lane must file its actual reads in
   `JOURNAL-0-PROVENANCE.md` before the transcript is sealed; the chair
   verifies the builder's read-set against its transcript.

*— Claude Fable 5 (lab chair), 2026-07-29, before any implementation coding.*
