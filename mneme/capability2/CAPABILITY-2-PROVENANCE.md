# CAPABILITY-2-PROVENANCE — every file this hand opened

Builder: CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30, one
sitting. Working root: `experiments/latent-lisp/`; all sbcl runs from
there through the `~/.local/bin/sbcl` wrapper (SBCL 2.4.6,
operation-checked live; output not transcript-preserved).

## Created (the lane; nothing outside it except the build report in `_staging/`)

- `mneme/capability2/package.lisp`
- `mneme/capability2/load.lisp`
- `mneme/capability2/conditions.lisp`
- `mneme/capability2/world.lisp`
- `mneme/capability2/events.lisp`
- `mneme/capability2/rehydrate.lisp`
- `mneme/capability2/authorize.lisp`
- `mneme/capability2/attempt.lisp`
- `mneme/capability2/reconcile.lisp`
- `mneme/capability2/mutants.lisp`
- `mneme/capability2/capability2-selftest.lisp`
- `mneme/capability2/capability2-controls.lisp`
- `mneme/capability2/README.md` · `ALLOWED-SOURCES.md` ·
  `CAPABILITY-2-PROVENANCE.md` · `CAPABILITY-2-RETURN.md` ·
  `RUN-EXITCODES.txt`
- `mneme/capability2/RUN-SELFTEST.txt` + `-SECOND` ·
  `RUN-CONTROLS.txt` + `-SECOND` (captured suite output)
- `mneme/capability2/de-effectu-incerto/`: `README.md` ·
  `PROVENANCE.md` · `SPECIMEN-RETURN.md` · `specimen-common.lisp` ·
  `stage-first-life.lisp` · `stage-restart.lisp` · `run-specimen.lisp` ·
  `RUN-SPECIMEN.txt` + `-SECOND` · `RUN-EXITCODES.txt` · the
  `ARTIFACT-*` files + `ARTIFACT-SHA256SUMS.txt` +
  `ARTIFACT-MANIFEST.txt` (written by the runner)
- `_staging/capability2-BUILD-REPORT.md` (repo root `_staging/`;
  unmirrored pointer — `_staging/` is excluded from the public sync)

Scratch directories (`scratch-selftest/`, `scratch-controls/`,
`scratch-smoke/`, and the specimen's `scratch-*`) are created and
deleted by the runners; a failed run may leave them for inspection.

## Opened for reading (spec/precedent — the governing list, with why)

- `mneme/architecture/LISP-PLUS-KERNEL-0-SPEC.md` (§9–§11 in full;
  §14; §19 headings; §0.4; section map).
- `mneme/architecture/adapter-protocol-0/lisp-plus-adapter-protocol-0-reissue/LISP-PLUS-ADAPTER-PROTOCOL-0-SPEC.md`
  (ack semantics; crash windows W1–W4; AP-CON-1; AP-ACK-*; AP-CRASH-*;
  AP-DSP-*; AP-FAKE-3) and `AP0-PLAN-CONCORDANCE.md`,
  `AP0-PLAN-DRAFT-S.md` (grep hits for the ack ladder location).
- `mneme/architecture/process-journal-0/fixtures/crash-windows/cw3-full-synced-receipt-lost.pj0`
  (the effect-event byte grammar).
- `mneme/architecture/IMPLEMENTATION-PHASE-BOARD-2026-07-18.md`
  (interruption points; grep region).
- `mneme/kernel0/package.lisp` · `uncertain-effect.lisp` ·
  `folds.lisp` (event struct, payload conventions,
  `+kernel0-event-types+`, `check-retry-safety`,
  `%reconciliation-resolves-effect-p`) · `records.lisp`
  (reconciliation-receipt + list validators, grep regions) ·
  `determinacy.lisp` (make-determinacy, `%reference-list`) ·
  `identity.lisp` (domains, make-identity) · `outcome.lisp`
  (make-effect-axis) · `conditions.lisp` (signal-kernel0 region).
- `mneme/journal0/package.lisp` · `fold.lisp` · `writer.lisp` (grep
  regions: append-event, find-event).
- `mneme/capability0/schema.lisp` (bootstrap + event constructors) ·
  grep of `query.lisp`/`receipts.lisp` signatures ·
  `RUN-EXITCODES.txt` region via capability1's README.
- `mneme/capability1/` — `package.lisp`, `README.md`,
  `CAPABILITY-1-RETURN.md`, `load.lisp`, `conditions.lisp`,
  `context.lisp`, `object.lisp`, `mint.lisp`, `present.lisp`,
  `mutants.lisp`, `RUN-EXITCODES.txt`,
  `de-clave-mortua/specimen-common.lisp`, `.../run-specimen.lisp`,
  `.../stage-first-life.lisp`.
- `canonical-datum/common-lisp/package.lisp` (export names).
- `mneme/` directory listings; `mneme/architecture/` listing.

## Regression artifacts exercised, unmodified

`mneme/capability1/` suites + `de-clave-mortua` specimen (transcript
diffed byte-identical against the committed `RUN-SPECIMEN.txt`;
`ARTIFACT-SHA256SUMS.txt` re-verified, 7 OK — that specimen's
deterministic ARTIFACT files are byte-identically rewritten by its own
runner); `mneme/capability0/` suites + `de-potestate-revocata` specimen
(same discipline, 4 OK); `mneme/journal0/` selftest + vectors;
`mneme/verify-all.sh`.

— CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30
