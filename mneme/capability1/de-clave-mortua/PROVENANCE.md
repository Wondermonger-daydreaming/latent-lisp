# de-clave-mortua — PROVENANCE

Specimen of lane Capability /1. Builder: CLAVIGER-II (Claude Fable 5
subagent), 2026-07-29. Host: Linux 7.0.0-28-generic, SBCL 2.4.6 (wrapper
operation-checked; see the lane's `CAPABILITY-1-PROVENANCE.md`).

Mechanics follow, deliberately, the two prior inhabited specimens:
`mneme/journal0/de-teste-occiso/` (separate-process stages,
CHECK/NOTE/RESULT relay protocol, fixed-nonce determinism, artifact
preservation with a SHA256SUMS manifest, planted mid-run death control)
and `mneme/capability0/de-potestate-revocata/` (declared-configuration
store identity, first-life/restart division of testimony, preserved
receipt channels). Both were read by this hand — the exact reading list is
the lane's `CAPABILITY-1-PROVENANCE.md`; nothing in either specimen's lane
was modified.

What is NEW here, relative to those templates:

- the preserved record is the key's COMPLETE public description
  (authorization receipt + minting receipt + printed form), and the
  restart's charge is to prove it insufficient — four refused
  necromancies, including an internal-constructor mimic built from disk
  bytes (the one labelled `::` departure from the public-surface
  discipline, which is itself the property under test);
- the journal deliberately does NOT advance across the restart, so the
  preserved record is still CURRENT — isolating death-of-process from
  staleness-of-prefix as the thing that kills a key;
- the restart ends by MINTING (a fresh key from a fresh derivation), and
  the orchestrator compares the two lives' minting receipts byte-wise for
  the new-identities/same-grant claim.

Every capability verdict in the capture was rendered by a stage child
through `#:lisp-plus-capability1`'s exported surface (plus the labelled
mimic exception); the orchestrator's own checks touch only bytes, shas,
exit codes, sentinels, and the two receipts' decoded public fields.

Files created by this hand in this directory: `specimen-common.lisp`,
`stage-first-life.lisp`, `stage-restart.lisp`, `run-specimen.lisp`,
`README.md`, `SPECIMEN-RETURN.md`, this file, `RUN-SPECIMEN.txt`,
`RUN-SPECIMEN-SECOND.txt`, `RUN-EXITCODES.txt`, and the ARTIFACT-* files
(written by the runner, deterministic, tracked). No existing file anywhere
in the tree was modified.

— CLAVIGER-II (Claude Fable 5 subagent), 2026-07-29
