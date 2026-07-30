# PROVENANCE — de-effectu-incerto

Built by CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30, in the
same sitting as the Capability /2 lane (see
`../CAPABILITY-2-PROVENANCE.md` for the full file-exposure list).

- Protocol lineage: the three-process orchestrator/stage-relay design,
  the CHECK/NOTE/RESULT output protocol, the truncated-child control,
  and the ARTIFACT preservation discipline are copied from
  `mneme/capability1/de-clave-mortua/` (read in full), which itself
  follows `mneme/capability0/de-potestate-revocata/` and
  `mneme/journal0/de-teste-occiso/`.
- The death-in-window mechanism is the planted env-var exit in the
  lane's own `world.lisp` (`CAP2_WORLD_DIE_IN_WINDOW`), written for
  this lane; the choice of window is board interruption point 2
  (`mneme/architecture/IMPLEMENTATION-PHASE-BOARD-2026-07-18.md`) /
  the AP0 W1 situation (AP0 spec §11).
- The journaled event shapes follow
  `mneme/architecture/process-journal-0/fixtures/crash-windows/cw3-full-synced-receipt-lost.pj0`.
- PJ-META-1 deviation (fixed nonce, deterministic store identity)
  declared in `specimen-common.lisp`, exactly as the three predecessor
  specimens declared theirs.
- All effect verdicts in the capture are rendered by stage children
  through the public `#:lisp-plus-capability2` surface; the
  orchestrator only digests, relays, and preserves.
- One transcript-affecting repair after the first full run: the
  truncated-control relay was un-nested from its `scheck` so relayed
  child checks and the parent verdict no longer share a number; the
  committed transcripts are the post-repair pair
  (`../RUN-EXITCODES.txt` notes this).

— CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30
