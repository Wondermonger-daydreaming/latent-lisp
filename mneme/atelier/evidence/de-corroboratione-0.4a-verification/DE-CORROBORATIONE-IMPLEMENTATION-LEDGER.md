# DE-CORROBORATIONE implementation ledger

## Lineage boundary

Fable-delivered candidate:

- 46,682 bytes; 888 LF lines
- SHA-256 `59786bcc799a4dd5126b21176f0e9db441fb643793a267a33aa4621f8faf9460`
- exact evidence filename: `de-corroboratione.FABLE-DELIVERED.lisp.txt`

Codex-verified successor:

- 80,456 bytes; 1,549 LF lines
- SHA-256 `0cce21d73aa105ea9c010f0ed58f257ab919d80b47b8ab7e26806a562cc67e01`
- implementation path: `mneme/atelier/hinges/de-corroboratione.lisp`

The `.lisp.txt` suffix prevents the atelier static checker from mistaking the
byte-preserved custody copy for a second executable package. Its bytes are
unchanged.

## Repository identities

- Branch: `codex/de-corroboratione-0.4a-verification`
- Starting commit: `5ae55d799c8f253926eaf91af9feda4a868e4fc8`
- Starting tree: `7bd80217af438061eb4c613afbb8682f0ce9dcb0`
- Verified implementation commit: `51fb24c79fdeceb851c69c20d121932d7b38d724`
- Verified implementation tree: `cbe27e1ae60967db0ffc5da5501751d4b9cc8c9e`

The evidence-only publication commit follows the verified implementation
commit. The pushed branch tip is reported in the final handoff; embedding a
commit's own hash inside that same commit would be self-referential.

## Surgical deviations from Fable's candidate

1. Declared Draft 0.4 + Erratum 0.4-A as the authority pair and retained the
   finite cooperative toy profile.
2. Replaced context-free numeric ordering admission with topology-first path
   skeletons, explicit ordering-use contexts, per-use admissibility, path-local
   closure, and use-bound precedence certificates.
3. Narrowed raw contradictory clocks to epistemic `:unknown` and reserved cycle
   failure for a certified local closure.
4. Added verifier-paper recomputation, mixed-use decomposition enforcement,
   and ordering anti-self-support enforcement.
5. Made Inkling sampling independence actually `:bounded-separate` while
   retaining inherited disqualification/unknown results.
6. Replaced the loose greedy upper interval in exact records with exact lower
   witnesses and exhaustive, checkable upper proof objects; bound both graph
   variants to construction digests.
7. Added adversarial validators for malformed graph identities, missing or bad
   lower/upper certificates, false exactness, and conflicting intervals.
8. Added explicit profile integrity, graph integrity, uptake, severity,
   selection, ceiling, replay, and anti-self-support condition coverage.
9. Added component-bound deterministic replay and required two full-process
   byte-identical successor runs.
10. Expanded the maximal toy receipt with graph snapshot and separately located
    witness, selector, and adjudicator profile classes.

No frozen authority document was copied into the repository or edited. No
existing tracked file other than the new hinge/evidence surfaces was changed.
