# Round-three landing manifest

This tranche is patch-oriented. Do **not** blindly replace the landed README, because its provenance block is landing-side evidence not present in Sol's canonical copy.

## Add

- `src/provenance.lisp`
- `storms/tampered-receipt.lisp`
- `storms/real-council-process.lisp`
- `specimens/de-characteristica.lisp`
- `protocols/carrier-attestation.md`
- `essays/characteristica-as-ir.md`
- `run-all.sh`
- `mutations/test-custody-overclaim.sh`

## Modify

- `src/package.lisp` — export provenance and custody API.
- `leibnitiana.asd` — load `src/provenance.lisp` after `src/core.lisp`.

## Append, preserving landing provenance

Append `README-ROUND3-APPEND.md` above the landing provenance block, or at the designated landing-side insertion point. Do not replace the whole README.

## Outside-audit packet

The top-level `COLD-READ-OUTSIDER-BRIEF.md`, `COLD-READ-RESULT-TEMPLATE.md`, and `AFTER-UNBLIND.md` are intended for a fresh reader. `AFTER-UNBLIND.md` must be withheld until the first report is frozen.
