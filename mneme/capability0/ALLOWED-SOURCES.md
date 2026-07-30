# capability0 — ALLOWED SOURCES (the exposure fence)

*Written up by CLAVIGER at lane close, 2026-07-29, recording the exposure
this hand actually incurred while designing. **Ordering is not proven:**
this file's mtime postdates the implementation and the gate runs, and the
lane carries no commit, so unlike journal0's fence (committed pre-coding at
`1fc1f305`) nothing here is sealed and no before-coding ordering is
claimed. Format precedent only: `mneme/journal0/ALLOWED-SOURCES.md`.*

**HONEST FRAME, stated first:** unlike journal0's fence, this file makes
**no independence-from-reference claim** — there is **no reference
implementation of Capability /0 anywhere**; this lane is the first. This
fence therefore documents **exposure** (what this hand read while
designing), it does not seal a blind protocol. There is no Class B here in
journal0's sense, because there is nothing capability-shaped to be blind
to.

## CLASS A — read while designing and building this lane

Normative specifications and adopted law:
- `mneme/architecture/LISP-PLUS-KERNEL-0-SPEC.md` — §11 (capability
  semantics, opaqueness, minting bridge, check, defensive scope,
  revocation, restoration), §19.5 (reserved capability verbs), §10 tail
  (UNC context around §11)
- `mneme/architecture/LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md` — §19
  design laws (read whole section; load-bearing here: L5, L8, L9, L10,
  L13, L15)
- `mneme/CONSTITUTION.md` — Clause 5 (authority ontology; the narrowed
  no-time-travel law)
- `mneme/architecture/IMPLEMENTATION-PHASE-BOARD-2026-07-18.md` — the
  live-capability item (the "durable record… is not live authority"
  sentence at line 89 and its surrounding list)

Journal /0 — as a LOADED DEPENDENCY and public API (this lane's substrate;
consumed through package exports only):
- `mneme/journal0/package.lisp` (the export list = the permitted surface)
- `mneme/journal0/load.lisp`, `mneme/journal0/README.md`
- `mneme/journal0/writer.lisp`, `mneme/journal0/reader.lisp` (lines 40–80),
  `mneme/journal0/pjs0.lisp` (identifier/record helpers + encode/decode),
  `mneme/journal0/fold.lisp`, `mneme/journal0/mutants.lisp` — read to learn
  the public surface's actual signatures and semantics and the house
  planted-mutant pattern. NOTE: reading a dependency's source is exposure
  to that dependency, and it is recorded here as such; capability0 still
  CALLS only exported symbols (the `:import-from` list in
  `mneme/capability0/package.lisp` is the exact consumed surface, plus
  package-qualified references to five additional exported symbols in the
  specimen: `store-id-string`, `validate-metadata-octets`,
  `render-metadata-octets`, `build-metadata-record`,
  `journal-store-durability`).
- `mneme/journal0/de-teste-occiso/{run-specimen.lisp,specimen-common.lisp,
  stage-recover.lisp}` — the specimen mechanics pattern (separate-process
  stages, CHECK/NOTE/RESULT relay, fixed-nonce determinism, artifact
  preservation), followed deliberately.
- `mneme/journal0/{ALLOWED-SOURCES.md,RUN-EXITCODES.txt}` — document
  patterns.

Kernel /0 — as a LOADED DEPENDENCY and public API:
- `mneme/kernel0/package.lisp` (the exported condition taxonomy),
  `mneme/kernel0/conditions.lisp` (lines 1–260: condition slots +
  `signal-kernel0` signature), `mneme/kernel0/load.lisp` (load order).

Owner's charge (the mission text of 2026-07-29) — the lane's requirements
document, including the recon-adjudicated naming and the laws/controls
lists.

## NOT consulted

- Any prior capability/authority implementation in any language (none is
  known to exist for this spec; none was sought).
- The Python PJ0 reference tool (never opened by this hand; irrelevant to
  this lane and fenced by journal0's own record).
- kw-0 / hb0 / ss0 journal machinery (not opened by this hand).
- `mneme/journal0/{sha256,meta,frame,conditions,salvage}.lisp`,
  `journal0-selftest.lisp`, `journal0-vectors.lisp` source — not opened;
  used only as black-box runnables through the load path and gates.

## Standing note

After any future sealed external review of this lane, post-exposure repairs
must be identified as post-exposure in the RETURN, per the journal0
precedent.

— CLAVIGER (Claude Fable 5 subagent), 2026-07-29
