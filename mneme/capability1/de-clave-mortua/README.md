# de-clave-mortua — the inhabited dead-key specimen

*Latin gloss:* **de clave mortua** — "concerning the dead key": a live
capability that was truthfully minted, verifiably worked, and died with its
process — leaving behind a complete, current, truthful public record that
opens nothing.

Specimen of the **Capability /1 candidate**: not audited, not adopted, not
frozen, no floor; all greens are same-family self-consistency. Not
"Vertical Specimen /0". Substrates (capability0, journal0) are themselves
candidates; nothing here inherits a guarantee.

> A receipt may explain why a key was minted; it is not the key, and its
> description cannot forge one.

Three processes, following the de-teste-occiso / de-potestate-revocata
mechanics:

| process | file | role |
|---|---|---|
| ORCHESTRATOR | `run-specimen.lisp` | supervises, relays and renumbers stage verdicts, digests and preserves artifacts, performs the cross-life receipt comparison; **never mints, presents, or derives authority itself** |
| PRIMA VITA | `stage-first-life.lisp` | separate `sbcl --script` process: explicit bootstrap → grant (ordinal 1) → `:authorized` at P → **MINT** (opaque key, EQ-recognized by its context) → successful presentation → the key's complete PUBLIC record preserved (authorization receipt bytes · minting receipt bytes · printed form) → **exits; the key dies with it** |
| REDIVIVUS | `stage-restart.lisp` | genuinely new process; admissible inputs: durable store bytes + the preserved public record + declared configuration (`specimen-common.lisp`) only. Re-derives the same authorization (`origin :reconstructed`, L10); **exhibits the dead key unobtainable by every route the surviving record affords this restart — four attempts, each refused ([016]-[019] of `RUN-SPECIMEN.txt`)**: preserved authorization receipt refused, preserved minting receipt refused, an internal-constructor mimic built from the receipt's public fields refused (all `cap1-unrecognized-object`), the printed form reader-rejected; then **freshly mints a NEW key** (new public + occurrence identities, same grant g-001) that presents successfully |

The sharpened point of this specimen (vs. de-potestate-revocata): the
journal never advances, so the preserved record is **still current and
still truthful** at the restart — and the key is dead anyway. Staleness is
not what kills a key; process death is. What survives is testimony;
what works is only what a living process freshly mints. Boundary:
in-process, non-adversarial opaqueness by EQ-recognition; see
`SPECIMEN-RETURN.md`'s Honest limits.

Negative control: a restart aborted mid-run by a planted fault
(`DE_CLAVE_DIE=1`) — no signal, no SIGKILL — exits 3 with no `RESULT:`
sentinel, detected by the orchestrator as exactly that pair.

## Run (from the latent-lisp root; SBCL 2.4.6)

```
sbcl --script mneme/capability1/de-clave-mortua/run-specimen.lisp
```

Exit 0 iff all checks pass (29 checks this build). Deterministic: fixed
store nonce (declared PJ-META-1 deviation, `specimen-common.lisp`), both
lives' query identities declared charge, no pids/timestamps/paths printed;
`RUN-SPECIMEN.txt` and `RUN-SPECIMEN-SECOND.txt` are byte-identical (shas
in `RUN-EXITCODES.txt`).

## Preserved artifacts (tracked; digests for all but `ARTIFACT-MANIFEST.txt` in `ARTIFACT-SHA256SUMS.txt`)

`ARTIFACT-EVENTS.pj0` (the 1-frame journal: the grant — neither life's
mints or presentations moved it), `ARTIFACT-JOURNAL-META.pjs` (+ `.sha256`
sidecar), `ARTIFACT-AUTH-RECEIPT.pjs` (the prefix-P authorization, still
current at the restart), `ARTIFACT-MINT-RECEIPT.pjs` (the dead key's
complete public description), `ARTIFACT-MINT-RECEIPT-2.pjs` (the restart's
fresh key: different identities, same grant), `ARTIFACT-DEAD-KEY-PRINT.txt`
(the printed form), `ARTIFACT-MANIFEST.txt`.

— CLAVIGER-II (Claude Fable 5 subagent), 2026-07-29
