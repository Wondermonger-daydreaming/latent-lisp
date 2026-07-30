# ALLOWED-SOURCES — Capability /2 exposure fence

**Written at lane close, and it says so:** this file DOCUMENTS the
exposure of the hand that built `mneme/capability2/`; it makes no
pre-coding ordering claim (the capability1 precedent). The builder is a
Claude Fable 5 subagent whose boot context carries the lab's CLAUDE.md /
MEMORY.md; those are exposure too, and are named here as such.

## Consumed executable surfaces (through public package exports only)

- `#:lisp-plus-capability1` — mint/present surface + `cap1-*` conditions
  (the `:import-from` list in `package.lisp` is the exact set).
- `#:lisp-plus-capability0` — schema/query/receipt surface (exact set in
  `package.lisp`).
- `#:lisp-plus-journal0` — store, codec, report, metadata, digest
  surface (exact set in `package.lisp`).
- `#:lisp-plus-kernel0` — conditions, §10.8/§14.2 constructors, identity
  and axis constructors, `make-kernel0-event`, `check-retry-safety`
  (exact set in `package.lisp`), plus a small number of
  package-qualified references to other EXPORTED kernel0 symbols in the
  suites (`kernel0-event-extension-p`, `uncertain-effect-p`,
  `reconciliation-receipt-p`, condition names in handler clauses).
- `lisp-plus-cd0` — package-qualified references to EXPORTED datum
  constructors/accessors only (`make-record-datum`, `make-record-entry`,
  `make-string-datum`, `make-integer-datum`, `make-sequence-datum`,
  `make-unit-datum`, `record-datum-p`, `identifier-datum-p`,
  `sequence-datum-p`, `sequence-datum-elements`, `integer-datum-value`,
  `string-datum-value`).

No substrate file was modified. No internal (unexported) symbol of any
substrate is referenced anywhere in this lane.

## Read (specification and precedent; no code copied from these into the lane except as noted)

- `mneme/architecture/LISP-PLUS-KERNEL-0-SPEC.md` — §9, §10, §11, §12
  headings, §14, §19 (reserved verbs), §0.4.
- `mneme/architecture/adapter-protocol-0/lisp-plus-adapter-protocol-0-reissue/LISP-PLUS-ADAPTER-PROTOCOL-0-SPEC.md`
  — acknowledgment semantics (§9), dispatch (AP-DSP-*), crash windows
  (§11), AP-CON-1, AP-ACK-1..4, AP-CRASH-1..4, AP-FAKE-3.
- `mneme/architecture/adapter-protocol-0/AP0-PLAN-CONCORDANCE.md`
  (located the ack ladder).
- `mneme/architecture/process-journal-0/fixtures/crash-windows/cw3-full-synced-receipt-lost.pj0`
  — the effect-event byte grammar this lane's `events.lisp` copies.
- `mneme/architecture/IMPLEMENTATION-PHASE-BOARD-2026-07-18.md` — the
  four interruption points.
- `mneme/kernel0/` — `package.lisp`, `uncertain-effect.lisp`,
  `folds.lisp` (the fold this lane consumes; read to learn its payload
  conventions and `+kernel0-event-types+`), `records.lisp`
  (reconciliation-receipt constructor contract), `determinacy.lisp`
  (determinacy contract), `identity.lisp` (domains), `outcome.lisp`
  (effect-axis contract), `conditions.lisp` (`signal-kernel0` contract).
- `mneme/journal0/` — `package.lisp`, `fold.lisp` (the named projection
  gap this lane's rehydration closes for its own shapes), `writer.lisp`
  (append-event contract).
- `mneme/capability0/` — `schema.lisp`, `README.md` region,
  `RUN-EXITCODES.txt` (regression expectations).
- `mneme/capability1/` — every file (the lane layout, condition,
  mutant, suite, and specimen idioms this lane follows), including
  `de-clave-mortua/` (the stage-relay protocol copied into this lane's
  specimen).
- `canonical-datum/common-lisp/package.lisp` (export names only).
- Owner charge text for this lane (mission brief), including the recon
  naming adjudication and the reserved/occupied name list.
- `mneme/RULING-capability1-arc-closure-2026-07-30.md` — **constitutive
  by relay**: its §"The next seam — NAMED, not opened" is the source of
  this lane's governing sentence and of the vertical the RETURN §1
  reports; its content reached this hand as relayed charge text, and
  the file itself was not opened (listed under "Not consulted" with the
  grep evidence).

## Not consulted

- The Python PJ0 reference tool; any `_staging/` material; any prior
  Capability /2 or Vertical Specimen **implementation** (no prior
  Capability /2 implementation exists —
  `grep -rln "capability2\|Capability /2\|de-effectu-incerto"` over
  `experiments/latent-lisp`, run at repair time excluding this lane's
  own files, returns exactly one hit:
  `mneme/RULING-capability1-arc-closure-2026-07-30.md` §"The next seam —
  NAMED, not opened", which names Capability /2, states this lane's
  governing sentence, and sketches the vertical the RETURN §1 reports.
  **That document is prior Capability /2 material and it is the source
  of both.** It reached this hand only as relayed charge text; the file
  itself was not opened. The earlier `grep -rl capability2` offered in
  the first issue of this fence cannot match "Capability /2" and was no
  evidence of absence); the closed lanes' internals beyond their public
  docs (`core0` was not opened; its occupied verbs were known from the
  charge text).

— CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30
