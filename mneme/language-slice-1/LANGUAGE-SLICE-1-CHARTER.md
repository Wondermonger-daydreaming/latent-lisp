# LANGUAGE SLICE /1 CHARTER — Structured Proposition and Derived Judgment /0

*2026-07-23, first sitting. Authorized by owner ruling; constituted from
INVENTORY-1 evidence. Slice /0 is a frozen dependency. Every normative
"must/cannot/never" below either names its live enforcement path or carries
`[DO]` = DESIGN-OBLIGATION, awaiting implementation. At charter stage nearly all
are `[DO]`; the founding specimen converts them or they die.*

**Governing question:** can Lisp+ make the internal anatomy of a derived claim
explicit enough that missing, mismatched, refuted, inaccessible, and
receiver-relative premises become mechanically visible before the conclusion is
granted?

**Claim ceiling (binding):** Slice /1 enforces premises that have been
*declared*. Lawful: prevent a conclusion while a required declared premise is
missing, mismatched, refuted, inaccessible, or bound to the wrong receiver,
purpose, artifact, or version. Unlawful: any claim of inferring real-world
proposition definitions or discovering undeclared premises.

---

## §1. Structured propositions — canonical data in NORMAL FORM, not a new record type

**Decision (answers INVENTORY Q1+Q2).** A structured proposition is **canonical
data**: a proper list

```lisp
(:predicate <keyword>
 (<role-keyword> <value>) ...)
```

where each role is a keyword, each value is boundary-lawful (keyword / non-empty
string / integer / proper list thereof), roles are unique, and role pairs are
**sorted by role-keyword name at construction**. A Slice /1 constructor (working
name `proposition`; public name earned per §12) validates and normalizes;
duplicate roles or non-boundary values refuse with a typed condition `[DO]`.

Why normal form instead of a record type: normalization makes role-order
insensitivity **reduce to the frozen `proposition=`/`EQUAL` on normal forms** —
INVENTORY blocker B1 dissolves without touching Slice /0; and every structured
proposition **is** a lawful Slice /0 proposition (probe #C1), so it flows through
`claim` / `witness :for` / testimony `(:asserted S P)` / projection unchanged.
Backward compatibility is by construction, not by adapter. Atomic Slice /0
propositions remain lawful primitive propositions. No host symbol is ever
stringified — bare symbols still refuse at the frozen boundary gate
(`slice0.lisp:187-190`, live enforcement, already in force).

Equality: `structured-proposition=` ≙ `proposition=` on normal forms; defined in
Slice /1, never widening the frozen `proposition=` `[DO]`.

## §2. Primitive vs derived — relative to the judgment, not metaphysical

A proposition is **derived** in a given judgment attempt iff a Slice /1
derivation schema is invoked for it; **primitive** means only that no schema is
being invoked for that judgment. The same proposition form may be primitive in
one context (directly witnessed) and derived in another (schema-governed) — what
is fixed is that **a conclusion whose governing procedure declares a schema can
never be granted primitively** (§7, the S3 closure) `[DO]`.

## §3. Judgment schemas

A schema is a Slice /1 record `[DO]` carrying:

- **identity + version**: a kernel0 `make-identity` in a new domain `:schema`,
  plus an integer version (answers Q8 — reuse identity machinery; schema
  resolution is by EXACT (id, version); no auto-latest, ever);
- **conclusion pattern**: a structured proposition whose values may be variables;
- **required premise patterns**: a list of structured propositions with
  variables — **conjunctive in Slice /1** (disjunction/optionality deferred as
  non-goals until a specimen demands them);
- **judgment procedure**: the `promotion-procedure` that will govern the
  conclusion's grant (§7);
- **receiver-/purpose-relativity**: NOT special-cased — a receiver or purpose is
  simply a named argument (`(:receiver ?receiver)`, `(:purpose ?purpose)`)
  bound by the conclusion instance and flowing into premises by ordinary
  binding coherence (§4). This is the charter's central economy: 
  **receiver-relativity is enforced by binding, not by dedicated code paths**;
- **outcome table**: the declared result when a premise is missing / mismatched
  / refuted / inaccessible (§5 defaults; a schema may not weaken them, only
  document them).

No public macro named `judgment-schema` or `defjudgment` is pre-authorized; the
specimen earns the public constructor form and its name (§12).

## §4. Matching and binding — deterministic, finite, ground-vs-pattern only

**Decision (answers Q3).** Variables exist, unification does not.

- A **variable** is the canonical form `(:var <keyword>)` — bare `?x` symbols
  cannot cross the frozen boundary (INVENTORY #1), so the variable marker must
  itself be canonical data. Illustrative patterns in this charter write `?x`
  for readability only.
- Supports and judged premise claims are **ground** (no variables). Patterns
  (conclusion + premises) may contain variables. Matching is
  **pattern-against-ground** only: structural walk, exact canonical equality at
  every non-variable position, first-binding-then-consistency for variables.
  No var-var unification, no backtracking, no rule chaining (a premise is
  discharged by a support or an already-judged claim, never by recursively
  invoking another schema — chaining is a deferred non-goal).
- **Order of operations** `[DO]`: (1) bind conclusion variables from the
  requested conclusion instance (must ground every variable the premises use —
  a premise variable unbound by the conclusion and by every candidate match is
  a schema authoring error, refused at schema construction where detectable);
  (2) for each premise pattern, scan the supplied support set deterministically;
  (3) a candidate matches iff predicate and all ground positions agree and its
  variable positions are consistent with the accumulated bindings.
- **Ambiguity refusal** `[DO]`: if two candidates yield *different* consistent
  bindings for the same premise, the premise is `:ambiguous` and the derivation
  refuses with a structured ambiguity result. Traversal order NEVER selects a
  winner. (Two candidates yielding the *same* bindings are not ambiguous.)
- No implicit coercion: `1` ≠ `"1"` ≠ `:one`, everywhere.

## §5. Missing is not false — the closed status vocabulary

Exactly six premise statuses, each with an in-code definition `[DO]`:

| status | definition | effect on conclusion |
|---|---|---|
| `:satisfied` | a matching, admissible, accessible support/judged claim with consistent bindings | counts toward discharge |
| `:missing` | no candidate whose predicate matches the premise pattern | **blocks**; is NOT a refutation |
| `:mismatched` | predicate matches but a named argument conflicts with the bindings (wrong artifact / receiver / purpose / version / any role) | **blocks**; the exact conflicting roles are recorded |
| `:refuted` | a supplied record explicitly refutes the premise proposition | **blocks**; the refuting evidence stays represented — it is never revisionistically erased |
| `:inaccessible` | a matching support exists in the supplied store but is not accessible to the acting receiver-context (id-based, reusing `receiver-context` accessibility semantics) | **blocks**; recorded as residue, NOT as absent |
| `:ambiguous` | multiple incompatible consistent bindings (§4) | **blocks**; both candidates recorded |

`:missing` and `:inaccessible` block but never convert to "false."
`:mismatched` vs `:refuted` are distinguished in code with Slice /0's
typed-condition rigor (answers Q5): mismatch is a binding conflict; refutation is
represented counter-evidence. Refutation representation in Slice /1 is minimal:
a refuting record names the premise proposition it refutes (constructor-level,
canonical) — no negation logic, no `(:not …)` algebra (deferred).

## §6. Derivation receipts — every attempt, granted or refused

One receipt type, `derivation-receipt` `[DO]`, issued on EVERY derivation
attempt, carrying at least: schema id+version · conclusion instance · bindings ·
premises-considered · per-status premise lists (all six of §5) ·
decision (`:granted` / `:refused`) · strongest-lawful-result ·
repair-options (per unsatisfied premise: what would discharge it) ·
explanation (structured fields, renderer-derived). **Never compressed to a
boolean** — there is no `:all-premises-present` field, by charter law. It
registers ONE extractor in the frozen `*why-extractors*` registry exactly as
projection and transmission did (`slice0-projection.lisp:373` precedent) —
`why` stays the one uniform explanation act (answers Q5's registration half).

## §7. The governed act — a wrapping `derive`, and the S3 closure mechanism

**Decision (answers Q4+Q7).** `raise` is frozen (INVENTORY B2). Slice /1 adds a
new governed act (working name `derive`; public name earned) following the
`project-claim` precedent (`slice0-projection.lisp:311-317`: a Slice /0 act
wrapping `raise` internally). `derive` `[DO]`:

1. resolves the schema by exact (id, version);
2. binds conclusion arguments from the requested instance;
3. matches supports / already-judged premise claims (§4);
4. evaluates each required premise to one §5 status;
5. issues the derivation receipt (§6) — on every path;
6. grants only when every declared premise is `:satisfied` with coherent
   bindings — and the grant itself is still a Slice /0 promotion: `derive`
   drives the frozen `raise` on the conclusion claim with a
   **derivation-witness** minted from the receipt.

**The S3 closure mechanism** `[DO — the slice's load-bearing enforcement]`: the
conclusion's judgment procedure declares `:admits ((:derivation <schema-id>))` —
so the ONLY support shape the frozen `%procedure-admits-p` gate will admit for
the conclusion is the derivation itself. A generic content witness (the S3
bypass: "evidence-content" supporting an opaque admissibility token) is refused
by the *existing* Slice /0 admissibility gate, because it is not a
`(:derivation <schema-id>)` support. Slice /0's own machinery closes the hole
once the anatomy is declared — Slice /1 supplies the anatomy, not a new
enforcement regime. A derivation receipt attached as support for anything OTHER
than its own conclusion is inadmissible the same way (teeth plant, §11).

## §8. `why`

`why` on a derivation receipt (via the registry, §6) explains `[DO]`: which
schema (id+version) governed · which premises were satisfied · which premise was
missing · exact argument mismatches (role, expected binding, found value) ·
receiver/purpose mismatches specifically · inaccessible-vs-absent · refuting
support · ambiguous bindings (both candidates) · lawful repairs. The
human-readable renderer derives from structured fields — prose never carries a
fact absent from the receipt (Slice /0 discipline, inherited).

## §9. Projection

Structured propositions are canonical data, so projection carries their
arguments and the schema identity intact through the existing machinery (no
adaptation needed — INVENTORY #1). Charter law `[DO]`:

- a derived conclusion does NOT survive projection by status copy (Slice /0
  already reconstructs rather than copies; live enforcement);
- reconstruction at the target requires **re-derivation from premises lawful at
  the target**: `derive` at the target context, with the target's accessible
  supports;
- a receiver-bound premise cannot cross receivers **by binding coherence, not by
  special case**: `(:predicate :receiver-recognizes-signer (:receiver
  receiver-a) …)` simply fails to match a target conclusion binding
  `?receiver = receiver-b` — it lands `:mismatched` with the conflicting role
  named. This is §3's economy paying rent.

## §10. Transmission

A transmitted derivation receipt is **evidence that a derivation was performed**
— a product, at testimony level. It is not direct support for any premise, nor
for the conclusion at another receiver `[DO — enforced by §7's admissibility
key: a transported receipt is not a `(:derivation <id>)` support minted by the
receiving context's own derive]`. Producer/product and testimony-level
distinctions inherit from Slice /0 unchanged (live enforcement).

---

## §11. Founding specimen design — `de-praemissis/` (name provisional)

Domain: the S3 world reconstructed (artifact admissibility for a receiver and
deployment purpose), NOT copying the stranger's program. Primitive propositions:
digest-matches · signature-valid · receiver-recognizes-signer ·
provenance-admissible (receiver+purpose-bound). Packet: `HYPOTHESIS.md`,
`BASELINE.lisp` (disciplined idiomatic CL — the discipline stays convention),
`SPECIMEN.lisp`, `ABLATION.lisp`, `EXPECTED-FAILURES.md`, `RUN-RECEIPT.txt`.

Twelve required behaviors (frozen here; EXPECTED-FAILURES will pre-register
each): (1) digest-match alone cannot grant admissibility; (2) digest+signature
cannot grant; (3) a valid signature stays valid when recognition is missing;
(4) missing recognition produces a NAMED refusal, not generic failure;
(5) receiver A's recognition does not imply receiver B's; (6) `:staging`
provenance does not imply `:production`; (7) another artifact's premise cannot
discharge this artifact's schema; (8) an inaccessible recognition premise is
residue, not absent/false; (9) refuted provenance stays refuted and blocks;
(10) full coherent discharge grants; (11) `why` names all satisfied and
unsatisfied premises; (12) projection re-derives at the target, never copies.

**Founding ablation**: collapse structured proposition + schema back to one
opaque atomic proposition + generic evidence-content procedure; the ablation
MUST reproduce the S3 species (admissibility granted from digest+signature with
recognition never represented) with the rest of the program held as similar as
possible. **Cross-domain specimen** (Phase 4): scientific dataset admission —
schema-valid ≠ admissible-for-causal-analysis; fails with a NAMED missing
premise, preventing Slice /1 from becoming supply-chain policy in syntax.

## §11b. Teeth (all must fire before any closure)

Eleven plants: conclusion granted with one premise absent · wrong-artifact
premise accepted · wrong-receiver premise accepted · wrong-purpose premise
accepted · missing treated as false · inaccessible treated as absent · refuted
premise ignored · ambiguity resolved by traversal order · derivation receipt
copied as direct support for the conclusion · projection copying the source
conclusion without target re-derivation · opaque-proposition ablation
reproducing S3.

## §12. Public-language admission

Proposed public acts — **proposed, NOT admitted; names and division earned by
runnable specimen code only**:

```text
structured proposition construction   (working: proposition)
judgment-schema construction          (working: judgment-schema — name NOT final)
derived raise                         (working: derive)
derivation explanation                (via the existing why; render form TBD)
```

Admission test per form (from the ruling): makes anatomy inspectable · makes
premise omission rejectable · makes mismatch/inaccessibility explainable ·
enables a lawful repair · or is required to express the judgment without
internal constructors. No theorem-prover facade because it looks Lispy.

## §13. Non-goals (may not declare themselves prerequisites)

Complete logic programming · theorem proving · ontology construction ·
undeclared-premise discovery · dependent types · policy constitutions ·
probabilistic inference · distributed proof · host-level closure · cryptographic
security · process isolation · production qualification · disjunctive/optional
premises · rule chaining · negation algebra (each of the last three deferred
until a specimen demands it, with a recorded reason).

---

*Validation order and discipline: WORK-ORDER-1.md governs. No Slice /2 in this
work order. Slice /0 and the stranger series stay byte-frozen.*

— first sitting, Claude Fable 5 (CC seat), 2026-07-23
