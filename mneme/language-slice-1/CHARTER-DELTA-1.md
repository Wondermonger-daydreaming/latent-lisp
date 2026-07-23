# CHARTER DELTA /1 — pre-code consistency repair

*2026-07-23, second sitting. Ordered by the owner after architectural acceptance
of the first-sitting charter. This delta SUPERSEDES the named charter clauses; the
charter + this delta together are the one executable reading the code receives.
No new architecture round: six seams, closed.*

---

## Δ1. Variable scope and ambiguity (supersedes charter §4's order-of-operations clause)

Slice /1 adopts the **bounded two-class model**:

1. **Conclusion variables** — occur in the conclusion pattern; fully bound by the
   requested ground conclusion before any premise matching. An unbound
   conclusion variable at derive time is a refusal (typed condition), not a
   search.
2. **Schema-local variables** — explicitly declared by the schema
   (`:locals (<kw>…)`), may occur ONLY in premise patterns, scoped to the whole
   derivation attempt. An undeclared variable appearing anywhere in the schema
   refuses at schema construction.

Matching stays finite pattern-against-ground. The evaluator enumerates finite
candidate **binding environments** (conclusion bindings × consistent
schema-local assignments over the supplied support set). No rule chaining, no
higher-order unification, no backtracking beyond that finite enumeration.

A derivation attempt is:
- **unambiguous** — exactly one coherent complete environment discharges all
  premises;
- **`:ambiguous`** — more than one distinct coherent complete environment
  discharges them (the schema supplies no discriminator in /1);
- **refused (non-ambiguous)** — no coherent complete environment exists; the
  per-premise assessments say why.

**Wrong bound arguments are `:mismatched`, never `:ambiguous`.** A candidate that
conflicts with conclusion bindings is a mismatched candidate, recorded as such.

Ambiguity is CONSTRUCTIBLE in this model (two schema-local assignments both
discharging — e.g. two distinct valid signatures under two keys) and substrate
test T6 must construct it. If the founding + transfer specimens end up needing
no schema-local variables, `:ambiguous` is REMOVED from the slice rather than
kept as scenery — that decision point is logged at specimen closure.

## Δ2. Structured premise assessment (supersedes charter §5's one-status-per-premise table and §6's bucket lists)

Each required premise yields a **`premise-assessment`** structured object:

```lisp
(:premise-pattern …          ; as declared
 :ground-instance …          ; pattern under the accepted/attempted bindings (or partial)
 :matching-accessible-supports (…)
 :matching-inaccessible-supports (…)
 :mismatched-candidates (…)   ; each with the conflicting roles named
 :refuting-supports (…)
 :binding-environments (…)    ; environments this premise admits
 :ambiguities (…)
 :disposition <one of the six>)
```

The six charter terms survive as **dispositions / derived views**, computed by
the conjunctive decision law (in code, this order):

1. at least one accessible admissible matching support is required for
   `:satisfied`;
2. a matching **inaccessible** support is residue — never converted to absent;
3. **mismatched candidates never defeat a lawful exact match** — they are
   recorded beside it;
4. an explicit **refuting support blocks** the premise under founding semantics
   even when positive support coexists — and BOTH remain visible in the
   assessment;
5. **ambiguity blocks** (Δ1);
6. `:missing` means no relevant candidate evidence of any class was found;
7. **no evidence class is erased** because another class determined the
   disposition.

No seventh public status (`:contested` etc.) unless specimen code forces it —
the structured assessment already preserves support+refutation while refusing.
The **derivation receipt carries the assessments themselves**, not six buckets
of premise names.

## Δ3. Versioned derivation admissibility key (supersedes charter §7's `(:derivation <schema-id>)`)

The support key is exactly as versioned as the schema. Executable shape:

- witness `:mode :derivation`, `:kind (:schema <name-keyword> <version-integer>)`
  — the `(mode kind)` pair the frozen `%procedure-admits-p` compares is
  `(:derivation (:schema <name> <version>))`, canonical and exact.
- The derivation witness additionally binds: the **exact conclusion
  proposition** (`witness :for` — enforced by the frozen proposition-match gate),
  **schema identity + version**, the **derivation-receipt identity** (fresh
  kernel identity per attempt, domain `:receipt`), and the **deriving
  receiver/context**.
- The schema **registry** resolves by exact `(name, version)`; registering a
  second, different schema under an already-registered `(name, version)`
  REFUSES (typed condition). **No auto-latest resolution exists anywhere.**

Teeth (substrate T10–T11 + specimen): a v1 derivation cannot satisfy a v2-keyed
procedure (kind mismatch at the frozen gate); a derivation for Q cannot support
P (the frozen `:for`/proposition-match gate); a same-name different schema
cannot enter the registry at the same version (registry refusal is the
enforcement — within one image the (name,version) key is unique).

**Acknowledged inherited boundary (not a new hole):** a same-image hand-built
witness forging `(:derivation (:schema …))` without a governed `derive` is
stratum-3 host-escape territory — exactly the escape surface Slice /0's closure
already names and excludes from claims. Slice /1 inherits that boundary
unchanged and claims nothing stronger.

## Δ4. Local derivation vs transported testimony (supersedes charter §10's prose)

Structural, not prose:

- A **local derivation witness** carries `:origin-context <ctx-id>` and is
  minted only by the governed `derive` path (enforcement: `derive` is the only
  Slice /1 code that constructs `:mode :derivation` witnesses; see Δ3's
  inherited-boundary note for same-image forgery).
- **Transmitting a derivation receipt** produces a DISTINCT support object:
  `:mode :testimony`, `:kind :derivation-report`, `:for` the canonical
  proposition *"context A derived P under schema S/v"* — executable shape
  `(:predicate :derived (:context <a>) (:schema <name>) (:version <v>)
  (:conclusion <p>))` — `:content` the receipt (or canonical derivative).
- **Live enforcement path:** a conclusion procedure keyed
  `(:derivation (:schema <name> <v>))` refuses a `(:testimony
  :derivation-report)` support at the frozen `%procedure-admits-p` gate — the
  same mechanism that closes S3 closes receipt-transport laundering. Target
  verification therefore requires a target-context `derive` over target-lawful
  premises; source and target derivations carry distinct receipt identities
  even when their conclusion propositions are equal (fresh identity per
  attempt, Δ3).

Teeth: substrate T12 + specimen behavior 12.

## Δ5. Ground vs pattern construction (supersedes charter §1's single-constructor reading)

Two validation paths (names still subject to §12 admission):

- **`proposition`** — GROUND: refuses any `(:var …)` form anywhere (typed
  condition); usable by claims and supports; always boundary-lawful canonical
  data in normal form.
- **`proposition-pattern`** — PATTERN: may contain only declared variables
  (conclusion vars + schema `:locals`); valid only inside schema conclusion and
  premise patterns; **cannot** be a claim proposition or witness target
  (constructor-level refusal).

**Variable-form reservation:** `(:var <keyword>)` is reserved GLOBALLY within
Slice /1 proposition syntax. The explicit literal escape is
**`(:quoted-datum <form>)`**: a ground node whose payload is literal data —
`(:quoted-datum (:var :x))` is lawful ground data; the matcher compares
`:quoted-datum` payloads literally (var-shaped payloads included) and never
interprets inside them. Ordinary canonical data can never acquire variable
meaning accidentally: ground refuses raw `(:var …)`, patterns interpret it,
`(:quoted-datum …)` quotes it.

**Normal-form comparator, frozen:** keyword roles only · duplicate roles refuse
before normalization completes · role ordering by deterministic code-point
`STRING<` on `SYMBOL-NAME` · normalization idempotent (normalize∘normalize =
normalize, tested) · source role order never changes proposition identity after
normalization.

## Δ6. Pre-specimen substrate teeth (new; before de-praemissis)

Twelve tests, all must fire/pass in a substrate selftest:

- T1 role-order normalization ⇒ equal structured propositions
- T2 duplicate roles refuse
- T3 ground propositions refuse free/undeclared `(:var …)` (and
  `(:quoted-datum (:var :x))` is accepted as literal)
- T4 pattern variables bind deterministically
- T5 wrong artifact/receiver/purpose ⇒ `:mismatched`, not `:ambiguous`
- T6 the ambiguity branch CONSTRUCTIBLE and fires (or `:ambiguous` is removed)
- T7 an exact accessible match is not defeated by irrelevant mismatched
  candidates
- T8 accessible support + refuting support ⇒ both preserved, premise refused
- T9 inaccessible exact support ⇒ residue, not missing
- T10 schema v1 cannot satisfy v2
- T11 derivation for Q cannot support P
- T12 transmitted receipt becomes testimony and cannot masquerade as a local
  derivation

## Execution order after this delta (binding)

1. minimum normal-form `proposition` + `proposition-pattern` constructors;
2. schema identity/version + exact registry resolution;
3. finite matching + structured premise assessments;
4. derivation receipts;
5. governed `derive` through frozen Slice /0 `raise`;
6. one `why` extractor registration;
7. substrate teeth (T1–T12);
8. `de-praemissis`;
9. S3 ablation reproduction;
10. only then: which provisional names earn export.

No rule chaining, optional premises, disjunction, negation logic, theorem
proving, or policy machinery.

— second sitting, Claude Fable 5 (CC seat), 2026-07-23

---

## Errata (post-implementation, 2026-07-23 — code-forced readings, custodian-adjudicated)

1. **Δ3 kind shape**: the frozen `witness` and `promotion-procedure` constructors
   require `:kind` to be a KEYWORD, so the literal list kind
   `(:schema <name> <version>)` is unconstructible. Implemented as a
   deterministic interned keyword `:|DERIVATION/<NAME>/<VER>|` — exactness and
   versioning preserved (distinct keyword per version; T10 proves v1 ≠ v2).
2. **Charter §3 `:schema` identity domain**: kernel0's identity-domain list is
   frozen and has no `:schema`. Charter clause was in error against
   INVENTORY-1. Schema identity is minted in the `:procedure` domain with a
   `schema/NAME/VER`-encoded name (a schema IS a derivation procedure).
3. **Δ1 enumeration scope**: implementation threads accepted schema-local
   bindings premise-by-premise; a premise whose surviving candidates bind a
   fresh local to >1 value is `:ambiguous` immediately — later premises do NOT
   disambiguate earlier multiplicity. STRICTER than Δ1's global enumeration
   (refuses more, never wrongly grants). Founding semantics; revisit only if a
   specimen demands global enumeration, with a recorded reason.
4. **Δ4 testimony `:for`**: implemented as Slice /0's own testimony discipline —
   `(:asserted <context-a> (:predicate :derived (:schema …) (:version …)
   (:conclusion …)))` — the flat Δ4 sketch adapted to the frozen
   `(:asserted S Q)` gate. The transport-laundering hole is closed FIRST by the
   frozen proposition-match gate (`WRONG-PROPOSITION-SUPPORT`), with the
   admits-gate refusal proven independently (T10/T11) — the true gate is
   reported, not the assumed one.
