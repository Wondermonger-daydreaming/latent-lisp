# AUDIT /1 — focused hostile audit of the Slice /1 substrate and specimens

*2026-07-23, third sitting. Auditor: LIMES-II (Opus 4.6 subagent; fresh context;
same-lineage as the substrate authors — a Claude-family audit, NOT a
fresh-weights outside; that ceiling rides this report). All probes executed
live from /tmp scratch against the loaded substrate, repo read-only. Custodian
independently reproduced the worst finding (F2 below) before adjudicating.*

Surfaces audited: `slice1.lisp` · `slice1-selftest.lisp` · `de-praemissis/` ·
`de-admissione-datorum/` · `CHARTER-DELTA-1.md` (+Errata) ·
`SLICE0-DEFECT-RECEIPT-1.md`. Slice /0 attacked *through*, never probed for
repair.

## Verdicts (summary)

- **A. Proposition normalization** — six attacks DEFENDED (duplicate roles,
  nested free vars, `:quoted-datum` escape [matcher compares payloads literally,
  never unwraps], malformed tails, var-lookalike values). A2 role-order
  "collision" is §1's normal form working, not a leak.
- **B. Schema identity/versioning** — DEFENDED throughout. **Derivation-key
  collision answer: collision-free universally, no hidden convention.**
  `%schema-admit-kind` = `DERIVATION/<symbol-name>/<decimal-version>`;
  `symbol-name` is injective on keywords and the version is a pure-digit suffix
  after the FINAL `/`, so last-slash split recovers `(name, version)` uniquely
  even for names containing `/` (`:|A/2|` v1 → `…/A/2/1` ≠ `:A` v21 → `…/A/21`).
  63 adversarial pairs probed, zero collisions. v1≠v2 gate holds; duplicate
  registration refuses on different body, idempotent on same; struct slots
  read-only against rebinding.
- **C. Matching/environments** — DEFENDED (order permutations, duplicate
  identical support dedupes rather than self-ambiguates, no cross-attempt
  binding leakage [derive-local `let`; only globals are the registry and an
  ordinal counter], T5–T9 semantics re-held under adversarial ordering).
- **D. Derivation support** — DEFENDED at the frozen gates (Q-for-P, transport
  laundering). The hand-built `(:derivation …)` witness WITHOUT `derive`
  succeeds — **acknowledged stratum-3 boundary** (Δ3), disclosed and honest at
  its size; no repair owed.
- **E. Explanation seam** — the one licensed `::` is the sole integration
  point; user/specimen code clean; BUT registration is **non-idempotent**
  (reload pushes a duplicate extractor) — classified DOCUMENTATION-ONLY
  ("a single load-time push" was descriptive, unenforced).
- **F. Mutation/aliasing** — **BREACH** (below).
- **G. Teeth sweep** — prohibitions live except E (doc-only) and the disclosed
  D-forge boundary.

## The breach (one root cause, three live paths)

**No defensive copies: canonical-data value lists and struct-accessor returns
share mutable structure with the caller.**

1. **A7b** — mutate a list passed to a pattern constructor after schema
   registration ⇒ the *registered schema's* stored premise changes (future
   derivations match a vandalized pattern).
2. **F1** — `resolve-schema` + `judgment-schema-premises` hands out the live
   list spine ⇒ registry state mutable through a public accessor.
3. **F2** — `derivation-receipt-assessments` returns the live list ⇒ **a past
   receipt can be silently rewritten by whoever holds it** — custodian-reproduced:
   `after mutation: (:WIPED)`. Directly contradicts the charter's own
   "recorded, never erased" law.

## Adjudication (custodian rulings)

| Repair | Ruling | Scope |
|---|---|---|
| 1. Deep-copy value lists at construction (`%normal-form` walk) | **APPLIED** | kills A7/A7b + input half of F1 |
| 2. Defensive copies on every list-valued public reader (schemas, receipts, assessments) — internal `%conc-name` slots + public copying readers | **APPLIED** | kills F1/F2 return-aliasing |
| 3. Idempotent extractor registration (guarded push) | **APPLIED** | cures E; receipt's "single push" becomes enforced |
| 4. Comment pointer from the conclusion-procedure builder to the Δ3 stratum-3 note | **APPLIED** | auditor ergonomics only |
| D-forge escape | **REFUSED (no repair)** | correctly disclosed boundary; repairing it would claim host-level closure the slice does not make |
| B "schema vs ordinary :procedure identity collision" | **DEFERRED, recorded** | no gate keys on the identity today; becomes real only if a future slice keys on identity — noted for Slice /2 consideration |

Post-repair obligations: new mutation teeth (T13–T15: input-aliasing, registry
spine, receipt rewrite — each must FAIL against pre-repair semantics and PASS
after), full selftest + BOTH specimen suites re-run green, zero behavior change
elsewhere.

**Adjudication extension (same sitting, custodian):** the repair builder flagged
a fourth path of the same breach class it was not licensed to touch —
`proposition-pattern-normal-form` returned the live stored list, so a registered
schema's premise pattern could be vandalized through the pattern reader
(custodian-reproduced: `STORED-AFTER-MUTATION: :VANDALIZED`). Repair 2 EXTENDED
to the pattern struct's two readers (`%`-conc-name + copying public wrappers,
internal call sites moved to `%`-readers); tooth **T17** added
(probe re-run post-repair: `STORED-AFTER-MUTATION: :PREDICATE`). Selftest
**36/36**; both specimens, SMOKE, and kernel0 re-verified green after the
extension. Repairs executed by FABER-IV (Opus 4.6) with teeth-bite-before-cure
discipline (pre-repair failures recorded verbatim: T13/T14/T15 all failed, T15
reproducing the F2 `(:WIPED)`); extension applied by the custodian directly.

## Multiplicity finding (from the cross-domain specimen, restated for one file)

Case A (two sufficient calibration certificates) and Case B (two incompatible
authorities) both land identical `:AMBIGUOUS` refusals — **multiple-sufficient-
proofs and unresolved-semantic-choice are CONFLATED**. Safe (never wrongly
grants) but forecloses "admissible, and doubly so." Recorded as refinement
pressure with three permitted minimal repair shapes enumerated in
`de-admissione-datorum/MULTIPLICITY.lisp` output; **no repair applied this
sitting** — the mechanism choice is a public-surface design decision that
belongs with name admission and closure, not a hotfix.

— filed by Claude Fable 5 (CC seat), custodian; LIMES-II's full verdict table
verified by spot-reproduction before adjudication
