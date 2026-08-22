# MANY ACTS /0 — PRESSURE REPORT (pre-code)

STANDING: standing in this lane attaches to immutable object identities and explicit
dispositions, never merely to filenames, directories, or descent from an adopted commit
(Owner Ruling 6 §3 B1; rule and coordinates in `MANY-ACTS-0-STANDING.md`). This file's path
confers no standing on its bytes in either direction. Nothing produced here is independent
verification (AP0 adoption Rider 2, binding): the phrases "independently verified" and
"independently validated" may not appear in any artifact of this lane.

Chair/author: Claude Fable 5, 2026-08-09, under the owner's opening commission
"MANY ACTS /0 — PHASE A+B". Programs were designed BEFORE grammar; the grammar document
admits only constructs a pressure below forces.

## 0. The hypothesis under test (verbatim from the commission)

> A finite Lisp+ program can be represented as inspectable data and evaluated using only
> the adopted One Act /0 operation and existing public language surfaces, while preserving
> explicit authority, structured outcomes, durable per-act history, derive ≠ perform, and
> the prohibition on blind retry.

Counterfactual: if the authoring evaluator must contain special knowledge of every program
it runs, or if adding a genuinely new program requires editing the evaluator, Lisp+ has not
crossed from specimen to productive language.

## 1. The substrate, as verified (not assumed)

- One Act /0's exported operation surface is the act's **first half plus parts**: `run-act`
  (exported) executes L0..~L18 over a fixture from the exported `*act-fixture-table*`;
  the composer (`finish-act`: F2–F5 + agreement) is **internal**, as are the fixture
  constructor, `setup-run`, `append-lane-frame`, `journal-opening-authority`,
  `outcome-fields`, `agreement-row-for`, and the dispatch-context readers.
- Every ingredient of the composer's law-chain IS exported or public elsewhere:
  `build-f1..f5`, `lane-envelope`, `frame-event-id`, `agreement-gate`,
  `correspondence-verdict`, `classify-act-frames` (One Act); `append-event`, `find-event`,
  `decode-pjs0`, `record-field`, prefix readers (Journal /0); `make-grant-event`,
  `declare-bootstrap-authority`, `query-live-authority`, `datum=` (Capability /0);
  `make-minting-context` (Capability /1); `declare-uncertain-effect`,
  `reconcile-uncertain-effect`, `world-ledger-lookup` (Capability /2); evidence readers and
  `outcome-kind` (Core /0); `validated-store-events`, `derive-seat-outcome`, the
  seat-outcome readers (Surface /2). The five run-state specials (`*run-root* *store*
  *worlds* *bootstrap* *minting-context*`) are exported.
- The dedup/ordering **law** is store-derived (`act-8-prefix-scan`, `seat-consumption-scan`
  — pure reads of the validated prefix); the unexported host tables are declared
  conveniences. A fresh image per program run makes the convenience state irrelevant while
  the store law stays fully in force.
- The constituent-act inventory at /0 is CLOSED: the seven adopted arms
  (A · B-L1 · B-L2 · B-R · C-i · C-ii · D), each consuming its runtime seat once per store.
- "Derive" in the adopted vocabulary is the read-side family (`derive-seat-outcome`,
  `derive-effect-standing`, …); "perform" is the frontier door. No function named `derive`
  exists in Core /0 — the two-door annotation in the README's directory tree refers to the
  request/perform split, and MA0 takes the read-side family as its derive-ops.

**Consequence accepted and declared:** the MA0 evaluator must OWN a small act-completion
routine composed exclusively of exported operations, honoring `finish-act`'s law-chain
(BIND-6 seat check → J-4b term join → F2 → C-arm F3-before-reconcile → F4 → readback →
agreement → O-8 refuse-on-disagree), with **divergence teeth** comparing its composition
against the canonical `run-all-arms` ground truth. This is a re-composition from public
parts, not a use of internals, and it is the largest single risk this candidate carries;
the failure matrix pins it.

## 2. The five pressures, and which program carries each

| # | Pressure (commission §2) | Carried by |
|---|---|---|
| 1 | derive → inspect outcome → conditionally perform; success is never evidentiary | P1 |
| 2 | uncertain effect → refuse dependent action and blind replay until lawful continuation | P2 |
| 3 | authority revoked between acts; later act refuses without erasing earlier history | P2 |
| 4 | a domain materially unlike the canonical specimens | P1 (program level — capped, §4) |
| 5 | prior act's structured result used as later data, never as authority/evidence | P1 |

Briefs: `P1-EDITIO-BRIEF.md`, `P2-CUSTODIA-BRIEF.md` (beside this file).

## 3. What each pressure forces (smallest construct), and what is reused

| Pressure | Smallest construct forced | Existing public surface reused |
|---|---|---|
| explicit input | program `:input` declaration + environment-supplied values | — |
| source-as-data | S-expression program form + closed validator | CD/0-style plain data; no new codec |
| derive ops | `derive` step binding a seat-outcome | Surface /2 `validated-store-events` + `derive-seat-outcome` |
| perform ops | `act` step invoking one adopted arm | One Act `run-act` + the public composition |
| inspect/branch | `branch` over closed outcome patterns, exact matching, mandatory `otherwise` | Surface /2 seat-outcome readers + its closed axis-value sets (this lane's own closed matching law, informed by similar principles and claiming no equivalence — see §5; heads NOT reused) |
| untaken arm never executes | single-selected-clause evaluation law + journal-footprint witness | Journal /0 prefix reads as the witness |
| carry value forward | `bind` + `(ref IDENT)` value expressions | — |
| result-as-data-not-authority | `(field OUTCOME AXIS)` extraction into ordinary values; validator refuses outcome refs in authority position | Capability /1's recognition-not-fields law (already enforced upstream) |
| refusal ≠ error | `refuse` terminal producing a structured program result | vocabulary follows One Act's refusal discipline |
| structured final output | immutable program-result object with ordered act summaries | — |

## 4. Honest caps discovered during design (stated now, repeated in the RETURN)

1. **Constituent-act domain is fixed at /0.** The adopted operation exposes exactly seven
   sealed arms of the scriba/inscribere specimen; no public fixture constructor exists.
   Pressure 4's domain variation therefore lives at the PROGRAM level (inputs, decision
   structure, carried data, refusal policy — a causal skeleton no single fixture run has),
   while every consequential frontier crossing at /0 remains a specimen-shaped inscription.
   Act-level domain variation requires a future lane with an adopted fixture-authoring
   door; MA0 does not claim it. (This is judged inside the commission's intent — the
   evaluator is generic over programs; it is the ACT INVENTORY that is sealed — and it is
   exactly the kind of limit §6's claim ceiling exists to state.)
2. **Same-arm-twice in one store is refused by the adopted lane** (identity + seat
   consumption). MA0 inherits this as a language property: a program cannot invoke the
   same constituent act twice, which is aligned with the no-blind-retry law and stated in
   the author guide.
3. **One program per image** is the /0 runner law (convenience-table hygiene + the
   commission's same-image-only orchestration). No crash-resume; each completed
   constituent act remains durably journaled under One Act regardless.

## 5. Tempting constructs deliberately NOT admitted

- **A `retry` or `resume` step** — pressure 2 exists to prove refusal, not recovery;
  admitting retry would counterfeit Core /0's restart discipline at program level.
- **Reusing `with-outcome`/`match-outcome` as program syntax** — those are in-image macro
  heads in a CLOSED two-row construct table with no registration point. MA0's branch is
  program-DATA validated by MA0's own closed pattern grammar, whose law is stated in
  MANY-ACTS-0-GRAMMAR.md §4 (value match AND standing `:present`; absence keywords
  matchable; no truthiness) and witnessed by this lane's own scenarios. The design was
  informed by similar principles; no agreement or equivalence with Surface /2's matcher is
  claimed (owner ruling, Parcel B item B6, 2026-08-10: the unwitnessed comparative phrase
  that once stood here has been removed). The heads are not renamed, wrapped, or extended.
  **What the divergence teeth
  that were actually built compare** is the lane's act *composition*, not its matcher: the
  concordance comparator (`ma0-concordance.lisp`) runs an MA0-composed act against the
  canonical `run-all-arms` act over seven arms × 18 enumerated facets. *No tooth compares
  MA0's matching against `match-outcome` on identical outcomes* — this pre-code line
  proposed one and none was built; the matching law's witness is the selftest scenario
  `w-branch-exact`. Whether a matcher-level comparator should exist is not decided here.
- **A general `let`/nested scopes/shadowing** — P1/P2 need only define-once sequential
  binding; shadowing is refused statically.
- **Value computation (arithmetic, string ops, host calls)** — nothing in P1/P2 needs it;
  value-exprs stay literal | ref | field.
- **An `assert`/`expect` step** — outcome inspection belongs to `branch`; a boolean assert
  would smuggle truthiness back in.
- **Program-level uncertainty resolution** (calling `reconcile-uncertain-effect` as a
  step) — the lawful continuation stays outside the program at /0; a program that meets
  uncertainty refuses (structured), it does not adjudicate.
- **Authority literals in source** — source names SLOTS only; the environment owns every
  live object (§ CONTRACT, source/environment/authority separation).

## 6. Why ordinary direct Common Lisp is insufficient (summary; expanded in the briefs)

Direct CL can call every public function P1/P2 call — as an opaque host program whose
control flow, bindings, and refusal policy live in compiled code, inspectable only as
source text for humans, with `EVAL`-grade expressive power and no claim ceiling. What the
hypothesis requires and CL-as-host cannot supply: (i) a CLOSED, validated, finite program
representation a validator can refuse BEFORE any consequential act (invalid source must
have zero journal footprint); (ii) machine-inspectable program structure (which acts, what
order, which branches, what the untaken arm was) as data, so that "the untaken arm did not
execute" is a checkable claim about a program object, not a reading of host code; (iii) a
program-level claim ceiling enforced by construction (no eval, no closures, no ambient
authority, no retry) rather than by reviewer discipline. The evaluator is the instrument
that makes those three properties LAWS of every program instead of virtues of two
hand-written ones.
