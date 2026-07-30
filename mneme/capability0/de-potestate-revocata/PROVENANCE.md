# de-potestate-revocata — PROVENANCE

Builder: CLAVIGER (Claude Fable 5 subagent), 2026-07-29.
Host: Linux 7.0.0-28-generic. SBCL 2.4.6 at `~/.local/bin/sbcl`
(operation-checked live via `(lisp-implementation-version)` through the
wrapper before any CL ran). All runs from the latent-lisp root
(`/home/gauss/Desktop/Claude-Code-Lab/experiments/latent-lisp`).

Lane-wide provenance (every file this hand opened, in order):
`../CAPABILITY-0-PROVENANCE.md`. Specimen-specific facts:

- **Pattern source, read in full and followed deliberately:**
  `mneme/journal0/de-teste-occiso/{run-specimen.lisp,specimen-common.lisp,
  stage-recover.lisp}` — the separate-process stage mechanics, the
  CHECK/NOTE/RESULT relay protocol, the fixed-nonce determinism
  declaration, and the artifact-preservation discipline all originate
  there. `stage-writer-child.lisp` was NOT opened (this specimen needs no
  kill supervisor; its first life exits by design).
- **Journal access:** every frame in `ARTIFACT-EVENTS.pj0` was written by
  `lisp-plus-journal0:append-event` inside `stage-first-life.lisp`; no
  process in this specimen writes journal bytes any other way. Raw octet
  I/O (`sp-read-octets` / `sp-write-octets`) is used only to digest,
  preserve, and read back artifact bytes.
- **Determinism inputs:** store nonce fixed to the 16 octets
  `de-potestate-rev` (declared PJ-META-1 deviation); declared durability
  `synced`; declared bootstrap issuer `cap0-issuer:radix`; expected store
  identity derived from that configuration through journal0's public
  metadata surface (`build-metadata-record` → `render-metadata-octets` →
  `validate-metadata-octets` → `store-id-string`).
- **Processes per run:** 1 orchestrator + 1 first-life child + 2 restart
  children (primary; truncated-control with `DE_POTESTATE_DIE=1`), each a
  separate `sbcl --script` invocation launched via `sb-ext:run-program`.
- Artifacts preserved by the orchestrator, digests in
  `ARTIFACT-SHA256SUMS.txt`; transcripts `RUN-SPECIMEN.txt` /
  `RUN-SPECIMEN-SECOND.txt` byte-identical (shas in `RUN-EXITCODES.txt`).

— CLAVIGER (Claude Fable 5 subagent), 2026-07-29
