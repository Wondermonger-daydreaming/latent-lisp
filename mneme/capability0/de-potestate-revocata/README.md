# de-potestate-revocata — the inhabited live-authority specimen

*Latin gloss:* **de potestate revocata** — "concerning the revoked power":
an authority that verifiably existed, was durably exercised, was durably
withdrawn, and whose historical receipt survives intact — as evidence, not
as a key.

Specimen of the **Capability /0 candidate**: not audited, not adopted, not
frozen, no floor; all greens are same-family self-consistency. Not
"Vertical Specimen /0".

> History may prove that authority once existed; only the validated present
> prefix can say whether it remains live.

Three processes, following the de-teste-occiso mechanics:

| process | file | role |
|---|---|---|
| ORCHESTRATOR | `run-specimen.lisp` | supervises, relays and renumbers stage verdicts, digests and preserves artifacts; **never derives authority itself** |
| PRIMA VITA | `stage-first-life.lisp` | separate `sbcl --script` process: explicit bootstrap → grant (ordinal 1) → `:authorized` receipt at P, preserved as canonical bytes → unrelated event (still authorized; receipt detectably not-current) → revocation (governed refusal naming g-001 + r-001) → **exits; its memory dies** |
| REDIVIVUS | `stage-restart.lisp` | genuinely new process; admissible inputs: durable store bytes + preserved receipt bytes + declared configuration (`specimen-common.lisp`) only. Reconstructs the identical refusal (`origin :reconstructed`), verifies the old receipt still truthful about P, and gets `cap0-stale-receipt` when presenting it as present authority |

Negative control: a restart aborted mid-run by a planted fault
(`DE_POTESTATE_DIE=1`) — no signal, no SIGKILL — exits 3 with no `RESULT:`
sentinel, detected by the orchestrator as exactly that pair.

## Run (from the latent-lisp root; SBCL 2.4.6)

```
sbcl --script mneme/capability0/de-potestate-revocata/run-specimen.lisp
```

Exit 0 iff all checks pass (24 checks this build). Deterministic: fixed
store nonce (declared PJ-META-1 deviation, `specimen-common.lisp`), no
pids/timestamps/paths printed; `RUN-SPECIMEN.txt` and
`RUN-SPECIMEN-SECOND.txt` are byte-identical (shas in `RUN-EXITCODES.txt`).

## Preserved artifacts (tracked; digests in `ARTIFACT-SHA256SUMS.txt`)

`ARTIFACT-EVENTS.pj0` (the 3-frame journal: grant · unrelated ·
revocation), `ARTIFACT-JOURNAL-META.pjs` (+ `.sha256` sidecar),
`ARTIFACT-RECEIPT-AT-P.pjs` (the prefix-P authorization receipt, canonical
PJ-S/0 bytes, byte-identical across the restart), `ARTIFACT-MANIFEST.txt`.

— CLAVIGER (Claude Fable 5 subagent), 2026-07-29
