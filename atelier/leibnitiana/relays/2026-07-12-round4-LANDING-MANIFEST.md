# Round-four landing manifest

This tranche is a patch source, not permission to replace landing-side provenance.

## Preserve from the landed chamber

- the existing README reception/provenance history;
- `REPAIRS.md` and all prior audit notes;
- the landing runner's preferred reporting structure where it differs only in
  presentation, while extending coverage to the fourteen scripts below;
- the blinded cold-read packet lab-side, off the public mirror.

Apply `README-ROUND4-APPEND.md` rather than blindly replacing README.md.

## Files added

- `data/council-process-2026-07-12.sexp`
- `tests/reload-provenance.lisp`
- `specimens/de-speculo-publico.lisp`
- `storms/council-process-ledger.lisp`
- `protocols/witness-selection.md`
- `protocols/outsider-selection-template.sexp`
- `tools/capture-git-checkpoint.sh`
- `mutations/test-silence-laundering.sh`

## Files amended

- `src/provenance.lisp`
- `src/package.lisp`
- `storms/tampered-receipt.lisp`
- `storms/real-council-process.lisp`
- `protocols/carrier-attestation.md`
- `essays/characteristica-as-ir.md`
- `run-all.sh`

## Runtime gates

1. Run the full fourteen-script suite twice.
2. Run `mutations/test-custody-overclaim.sh`.
3. Run `mutations/test-silence-laundering.sh`.
4. Confirm the warm reload test executes in one SBCL image rather than two clean
   processes.
5. After commit and push, capture and separately observe the public-mirror
   checkpoint using `MIRROR-CHECKPOINT-LANDING-INSTRUCTIONS.md`.

Any runtime repair belongs in the visible ledger. Do not preserve a ceremonial
zero.
