# capability1 — ALLOWED SOURCES (the exposure fence)

*Written up by CLAVIGER-II at lane close, 2026-07-29, recording the
exposure this hand actually incurred while designing. **Ordering is not
proven:** this file's mtime postdates the implementation and the gate
runs, and the lane carries no commit at write time, so unlike journal0's
fence (committed pre-coding at `1fc1f305`) nothing here is sealed and no
before-coding ordering is claimed. Format precedent:
`mneme/capability0/ALLOWED-SOURCES.md`, which carries the same honest
frame.*

**HONEST FRAME, stated first:** this file makes **no
independence-from-reference claim** — there is **no reference
implementation of a Kernel /0 §11.3 minting bridge or §11.2 opaque
capability object anywhere**; this lane is the first. This fence therefore
documents **exposure** (what this hand read while designing), it does not
seal a blind protocol. There is no Class B here in journal0's sense,
because there is nothing capability1-shaped to be blind to.

## CLASS A — read while designing and building this lane

Normative specifications and adopted law:
- `mneme/architecture/LISP-PLUS-KERNEL-0-SPEC.md` — §11 whole (11.1
  CAP-1 field law, 11.2 opaqueness — the MUST this slice exists to
  satisfy, 11.3 CAP-2 minting bridge, 11.4 check, 11.5 defensive scope,
  11.6 revocation, 11.7 restoration), §19.5 (reserved capability verbs).

Capability /0 — as a LOADED DEPENDENCY, public API, and design template
(this lane's immediate substrate; consumed through package exports only,
with the exact surfaces itemized below):
- `mneme/capability0/package.lisp` (the export list = the permitted
  surface), `load.lisp`, `README.md`, `CAPABILITY-0-RETURN.md`,
  `ALLOWED-SOURCES.md`, `CAPABILITY-0-PROVENANCE.md`, `RUN-EXITCODES.txt`.
- `mneme/capability0/{conditions,schema,fold,receipts,query,mutants}.lisp`
  — full files, read to learn the public surface's actual signatures and
  semantics, the condition-home adjudication style, and the house
  planted-mutant pattern. NOTE: reading a dependency's source is exposure
  to that dependency, recorded here as such; capability1 still CALLS only
  exported symbols. The consumed surface is: the `:import-from` lists in
  `mneme/capability1/package.lisp`, plus package-qualified references to
  these additional EXPORTED symbols in the suites/specimen:
  `lisp-plus-capability0:cap0-stale-receipt-receipt-terminal-ordinal`,
  `…-present-terminal-ordinal`,
  `lisp-plus-capability0:cap0-bootstrap-store-mismatch-expected`;
  `lisp-plus-journal0:{store-id-string, validate-metadata-octets,
  render-metadata-octets, build-metadata-record, journal-store-durability}`;
  `lisp-plus-kernel0:{signal-kernel0, journal-prefix-invalid}`;
  `lisp-plus-cd0:{record-datum-p, make-record-entry, make-record-datum,
  make-string-datum, make-integer-datum, string-datum-value,
  integer-datum-value}`.
- `mneme/capability0/capability0-selftest.lisp` (head + mutant/gate tail),
  `capability0-controls.lisp` (head, torn-tail block, corruption block,
  gate tail) — harness patterns.
- `mneme/capability0/de-potestate-revocata/*` — the specimen mechanics
  pattern (separate-process stages, CHECK/NOTE/RESULT relay, fixed-nonce
  determinism, declared-config store identity, artifact preservation),
  followed deliberately; all four lisp files + all four documents.

Journal /0 and Kernel /0 — as LOADED DEPENDENCIES and public API:
- `mneme/journal0/package.lisp` (export list), `mneme/kernel0/package.lisp`
  (condition/record exports, by grep).

Canonical Datum /0 — as a LOADED DEPENDENCY and public API:
- `canonical-datum/common-lisp/package.lisp` (export list),
  `canonical-datum/common-lisp/cd0.lisp` lines 704–795 + constructor greps
  (defensive-accessor semantics and identifier budget bounds — the basis
  of the §11.5 codec-copy design).

Owner's charge (the mission text of 2026-07-29) — the lane's requirements
document, including the chair-verified naming, the inhabited vertical, the
thirteen controls, the three named mutants, and the censor pre-emption
list.

## NOT consulted

- Any prior capability-object/minting implementation in any language (none
  is known to exist for this spec; none was sought).
- The Python PJ0 reference tool (never opened by this hand).
- kw-0 / hb0 / ss0 journal machinery (not opened by this hand).
- `mneme/journal0/*.lisp` implementation sources (writer, reader, fold,
  pjs0, mutants, …) — NOT opened this life; used as black-box runnables
  through the load path and gates. (capability0's fence records ITS hand's
  exposure to them; this hand's is zero.)
- `mneme/kernel0/*.lisp` beyond `package.lisp` — loaded via the chain,
  not read.
- journal0's and capability0's committed test suites as source beyond the
  line ranges named in `CAPABILITY-1-PROVENANCE.md`.

## Standing note

After any future sealed external review of this lane, post-exposure
repairs must be identified as post-exposure in the RETURN, per the
journal0 precedent.

— CLAVIGER-II (Claude Fable 5 subagent), 2026-07-29
