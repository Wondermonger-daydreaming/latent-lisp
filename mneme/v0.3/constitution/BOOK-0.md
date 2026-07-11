# Book 0 — The Executable Constitution (porch floor, v0-draft)

**Scope note:** this repository carries TWO constitutions with different
jurisdictions. `CONSTITUTION.md` governs the RESEARCH PROGRAM (hypotheses,
gates, panel practice). THIS document drafts the LANGUAGE's neutral kernel
law — common support beneath conforming profiles, owned by none of them.
The porch floor, not any single chair.

**Discipline: laws, not mechanisms.** Each law states an invariant every
conforming profile must satisfy by SOME mechanism; the mapping table
records which. `kind: proposed-neutral-kernel` throughout ·
gate: three profiles conform AND the Appendix-A/E9 interchange
demonstrates the laws surviving translation.

```lisp
(law canonical-core
  ;; one versioned canonical serialization of the normalized expanded
  ;; core; core-id = H(semantics-version, normalized-core, dep-core-ids).
  ;; NOT a "semantic hash" — equivalence of meaning is undecidable.
  (= (core-id a) (core-id b)) => (identical (normalized a) (normalized b)))

(law authority-is-explicit
  (forall (form) (subset-of (effects-of form) (capabilities-granted-to form)))
  ;; no ambient authority; capabilities are values; grants are inspectable.
  )

(law plan-commit-seam
  ;; planning is pure; commitment is conspicuous. Capability-bearing
  ;; effects occur ONLY at commit points, which carry predicted effects,
  ;; resource spend, reversibility, and — where an affected party exists —
  ;; the recipient's standing consent policy (recipient-bound checks).
  (forall (effectful-act) (preceded-by effectful-act (plan verify commit))))

(law no-time-travel
  ;; re-entering a captured computation cannot replay or resurrect a
  ;; consumed authority token; re-entry re-derives grants.
  )

(law laundering-prohibited
  ;; a handoff transfers context, never command authority; archived
  ;; imperatives are data; grants on resume are requested, not inherited.
  )

(law uncertainty-does-not-coerce
  ;; a Belief/assertion cannot silently become fact; it is tested,
  ;; propagated with lineage, or EXPLICITLY assumed (the assumption
  ;; itself recorded). Grades travel with claims; numeric confidence
  ;; requires declared semantics or yields to qualitative grade.
  )

(law provenance-at-ingress
  ;; external inputs, measurements, model outputs, human assertions enter
  ;; through explicit epistemic ingress forms; derived values inherit
  ;; machine-generated lineage; abstraction of provenance is itself
  ;; recorded. No taint-explosion booleans; lineage is a graph.
  )

(law conservation-of-represented-loss
  ;; THE GENERAL FORM (chaff-log and translation-refraction are instances):
  ;; no lossy transformation — temporal (bale, summary, inheritance) or
  ;; lateral (translation between dialects/lineages/representations) —
  ;; without a represented loss model: what was dropped or changed, why,
  ;; recoverability, and risk. Silence is never evidence of losslessness.
  )

(law expansion-is-inspectable
  ;; every transformation stage is named, queryable, source-mapped,
  ;; binding-attributed; no expansion smuggles effects or authority
  ;; beneath an innocent surface.
  )

(law failure-is-structured
  ;; failures are ordinary inspectable values: cause graph, expected/
  ;; received, candidate restarts-as-claims (advisory, authority-priced),
  ;; never prose-shaped wreckage.
  )

(law resources-are-accounted
  ;; consequential computation declares budgets; budget exhaustion yields
  ;; the operation's declared progress protocol, and "graceful partial
  ;; result" is never promised where the algorithm provides none.
  )

(law handoff-is-accountable
  ;; successor-facing artifacts distinguish observation from inference,
  ;; settled from live, historical from instructive, private from
  ;; transferable — and obey conservation-of-represented-loss.
  )
```

## Profile mapping (mechanism table — to be completed as Books I–III land)

| law | Lumen (structural/epistemic) | Fable (historical/narrative) | Prism (bilateral/translational) |
|---|---|---|---|
| authority-is-explicit | typed Capability params | — (inherits core) | recipient-bound checks |
| plan-commit-seam | plan/verify/commit | — | consent at commit |
| conservation-of-loss | capsule retention policy | bale + chaff-log | bind/translate refraction record |
| uncertainty-no-coerce | Belief types | :basis provenance | plural representation, no premature collapse |
| handoff-accountable | context-capsule | bequest + morals | cross-dialect capsule (E9) |

Taxonomy of profiles (per the third review's ruling): Prism-Lisp is
**translational** in the formal taxonomy — domain bilateral/relational,
substrate glass, error-philosophy "negotiate without premature collapse."
Translation ≠ mediation; the error-philosophy label keeps "negotiate,"
the taxonomy keeps "translate."
