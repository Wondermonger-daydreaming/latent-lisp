# ADAPTER-0-PROVENANCE — every file opened during phase 1

**Fence:** `mneme/adapter0/ALLOWED-SOURCES.md` (commit `41df2330`,
sealed before any implementation code existed).  **Every path below is
Class A.  No Class B path was opened, read, grepped for content, or
unpacked at any point in this phase** — including during recon reads
whose results only listed Class B *pathnames* (permitted by the fence).

## Normative contracts read (in full or by cited section)

- `mneme/architecture/adapter-protocol-0/lisp-plus-adapter-protocol-0-reissue/LISP-PLUS-ADAPTER-PROTOCOL-0-SPEC.md` — read in full (the contract this lane is derived from)
- `mneme/adapter0/ALLOWED-SOURCES.md` — the fence itself
- `mneme/kernel0/manifestation.lisp` — the adopted status/absence-state algebra (reused via package exports)
- `mneme/kernel0/conditions.lisp` — shared condition initargs (reuse, not twinning)
- `mneme/kernel0/package.lisp` — public surface inventory

## Frozen fixtures read (all under the reissue root)

- `AP0-FIXTURE-REGISTRY.sexp` — the one arbitrating record
- `descriptors/FAKE-ADAPTER-DESCRIPTOR-0.pjs`
- `descriptors/FAKE-ADAPTER-DESCRIPTOR-LIMITED-ACK-0.pjs`
- `descriptors/FAKE-ABSENCE-MAPPING-TABLE-0.pjs`
- `scripts/SCRIPT-{PRESENT,EMPTY,INVALID,ABSENT,CANCEL,RECONCILE,W1,W2,W3,W4}.pjs` — all ten
- `vectors/positive/*.pjs` — all 48
- `vectors/adversarial/*.pjs` — all 33
- `vectors/mutants/MUT-01..MUT-20.pjs` — all 20

## Predecessor public surfaces read (packages + docs + gate patterns)

- `mneme/journal0/package.lisp`, `pjs0.lisp` (codec surface + datum
  representation), `writer.lisp` (append-event contract), `fold.lisp`
  (joint-structural-semantic-report), `load.lisp`, `RUN-EXITCODES.txt`
- `canonical-datum/common-lisp/package.lisp` (CD/0 public accessors)
- `mneme/capability2/package.lisp`, `load.lisp`, `attempt.lisp`,
  `authorize.lisp` (signatures), `events.lisp` (journal event envelope
  grammar), `capability2-selftest.lisp` (house harness pattern),
  `RUN-EXITCODES.txt`, `de-effectu-incerto/specimen-common.lisp`,
  `de-effectu-incerto/stage-first-life.lisp` (the /0→/1→/2 route as
  practiced), directory listings of capability0/ and capability1/
- `mneme/verify-all.sh` (invoked, not modified)

## Rulings and records consulted

- The mission charge (owner-authorized, 2026-07-30) with its naming
  adjudication and rider text (the riders quoted from `AP0-ADOPTION-2026-07-18.md` AS RELAYED IN THE CHARGE; per this ledger's own enumeration, the adoption file itself was not separately opened by this hand — censor N-1 clarification, chair-applied).

## What was executed but never read

- The predecessor regression suites (capability0/1/2, journal0,
  verify-all) were RUN and their outputs compared; their internal source
  files beyond those listed above were not consulted for this lane's
  design.
- Class B reference tools/transcripts: neither read nor executed.

*— CLAVIGER-IV (Claude Fable 5), 2026-07-30*
