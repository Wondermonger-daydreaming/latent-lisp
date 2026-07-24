# CENSUS-SLICE-1.md — public-surface census of Language Slice /1

*Produced for LANGUAGE-SLICES-0-1-SYNTHESIS by CENSOR-SECUNDUS (Claude Opus 4.8, 1M context), 2026-07-24.*
*Every file under `experiments/latent-lisp/mneme/language-slice-1/` read as FROZEN CLOSED EVIDENCE; nothing edited.*
*Package: `lisp-plus-slice1` (`slice1.lisp`). Standings below are CENSOR-SECUNDUS PROPOSALS for the chair, not closure law.*

---

## 0. Count line (headline — verify these first)

| Quantity | Exact count | Source / method |
|---|---|---|
| **Exported symbols** | **69** — VERIFIED | `slice1.lisp:42-88` defpackage `:export`; extracted `#:` tokens, counted 69. Matches API brief's `do-external-symbols` figure (`LANGUAGE-SLICE-1-API.md:8`). |
| **Condition types** | **8** (1 base + 7 leaves) | base `slice1-condition` (`slice1.lisp:105`) + 7-family `macrolet` (`slice1.lisp:118-127`): malformed-structured-proposition, pattern-used-as-ground, schema-construction-error, schema-registration-conflict, schema-not-found, unbound-conclusion-variable, derivation-refused. All 8 exported. |
| **Substrate teeth** | **T1–T17** (17 named) | `slice1-selftest.lisp` — labels T1..T17 present (grep-confirmed unique set). |
| **Multiplicity teeth** | **M1–M12** (12 named) | `slice1-selftest.lisp` (added by CHARTER-DELTA-2). |
| **Selftest leaf-assertion tally** | **50 passed / 0 failed** | Final run, custodian's hand — `LANGUAGE-SLICE-1-CLOSURE.md:84`, `LANGUAGE-SLICE-1-API.md:549-551`. (29 named teeth × sub-assertions; 54 `(ok/fires)` call-sites in source, of which two pairs are mutually-exclusive success/refuse branches — 50 execute. Traced, compressed.) |
| **de-praemissis specimen** | **12/12** behaviors + ablation epitaph | `de-praemissis/RUN-RECEIPT.txt` ("12/12 behaviors demonstrated"). |
| **de-admissione-datorum specimen** | **14/14** behaviors + ablation epitaph | `de-admissione-datorum/RUN-RECEIPT.txt` ("14/14 behaviors demonstrated"). |
| **public smoke SMOKE-1** | **9/9 / 0 failed** | `SMOKE-1-RECEIPT.txt` ("9/9, 0 failed", EXIT 0). |
| **repaired multiplicity** | **3 cases** (A grant+plural · B ambiguous-by-declaration · C grant, ceiling held) | `de-admissione-datorum/MULTIPLICITY-REPAIRED.lisp`, CLOSURE:87. |
| **Unexercised readers (all)** | **30** (grep-confirmed zero-consumer across the 3 shipped programs) | see §1A. |
| **"Deliberate introspection surface" (the 22)** | **22** — VERIFIED, exact list in §1A | = 30 unexercised readers − 5 `-p` type-predicates − 3 `slice1-condition-*` base readers. |

> ⚠ **STALE-RECEIPT FLAG (exactness note):** `de-admissione-datorum/RUN-RECEIPT.txt` records
> `slice1-selftest.lisp : 31 passed, 0 failed`. That is a **pre-CHARTER-DELTA-2 fossil** — it was
> generated before M1–M12 were added and T6 revised. The authoritative final figure is **50**
> (CLOSURE, custodian's hand, same sitting). Not a defect; a timestamp-ordering artifact. The prose
> copy of the old count survives in that receipt (the FIGURES.md-corpse pattern, §I-f corollary 4).

---

## 1. Export table (all 69)

Legend for **exercised-by**: which of the **three shipped programs** reference the symbol —
`SMOKE` (`SMOKE-1.lisp`), `PRAEM` (`de-praemissis/SPECIMEN.lisp`), `ADMIS`
(`de-admissione-datorum/SPECIMEN.lisp`). "unexercised" = zero consumers among those three
(the symbol may still be fired by `slice1-selftest.lisp` or called internally by the substrate —
noted where load-bearing). Method: per-symbol word-boundary grep across the three files.

### 1A. The verified 22 "deliberate introspection surface" readers (labeling CONFIRMED)

The API brief's wart 3 (`LANGUAGE-SLICE-1-API.md:64-71`) states a live usage scan found **22 readers
with zero shipped-program consumers**, documented as *"introspection surface — no consumer among the
three shipped programs yet"*; the CLOSURE (`LANGUAGE-SLICE-1-CLOSURE.md:71-75`) repeats "The **22**
unexercised readers … ship as **deliberate introspection surface**, so labeled in the API brief."

**Labeling CONFIRMED and the exact 22 reproduced.** My grep found **30** zero-consumer readers total;
the "22" is exactly that set restricted to **struct field accessors**, i.e. 30 minus the 5 `-p` type
predicates minus the 3 `slice1-condition-*` base readers. The "~30" hedge in the same API paragraph
("~30 of the readers below are deliberate but unexercised") is *also* verified — it is the full 30.

The exact 22 (all `defun` accessors; file:line):

| # | Reader | file:line | Struct |
|---|---|---|---|
| 1 | `proposition-pattern-normal-form` | `slice1.lisp:295` | pattern |
| 2 | `proposition-pattern-variables` | `slice1.lisp:301` | pattern |
| 3 | `judgment-schema-name` | `slice1.lisp:414` | schema |
| 4 | `judgment-schema-version` | `slice1.lisp:415` | schema |
| 5 | `judgment-schema-identity` | `slice1.lisp:416` | schema (wart 2; internally called by `%grant-derivation` `:919`) |
| 6 | `judgment-schema-conclusion` | `slice1.lisp:417` | schema |
| 7 | `judgment-schema-premises` | `slice1.lisp:419` | schema |
| 8 | `judgment-schema-locals` | `slice1.lisp:420` | schema |
| 9 | `judgment-schema-conclusion-variables` | `slice1.lisp:426` | schema |
| 10 | `judgment-schema-unique-locals` | `slice1.lisp:421` | schema |
| 11 | `refutation-refutes` | auto (`defstruct` `slice1.lisp:560`) | refutation |
| 12 | `refutation-source` | auto (`slice1.lisp:560`) | refutation |
| 13 | `refutation-id` | auto (`slice1.lisp:560`) | refutation |
| 14 | `premise-assessment-ground-instance` | `slice1.lisp:600` | premise-assessment |
| 15 | `premise-assessment-binding-environments` | `slice1.lisp:604` | premise-assessment |
| 16 | `premise-assessment-ambiguities` | `slice1.lisp:606` | premise-assessment |
| 17 | `derivation-receipt-schema-name` | `slice1.lisp:642` | receipt |
| 18 | `derivation-receipt-schema-version` | `slice1.lisp:643` | receipt |
| 19 | `derivation-receipt-conclusion` | `slice1.lisp:647` | receipt |
| 20 | `derivation-receipt-bindings` | `slice1.lisp:648` | receipt |
| 21 | `derivation-receipt-repair-options` | `slice1.lisp:651` | receipt |
| 22 | `derivation-receipt-origin-context` | `slice1.lisp:646` | receipt |

**8 further readers are ALSO unexercised by the three programs but are NOT in the 22** — the closure
is silent on their standing (see the AUTHORIAL-STANDING-UNRESOLVED rows in §1B):
- 5 type predicates: `proposition-pattern-p` (`:279`), `judgment-schema-p` (`:397`), `refutation-p`
  (`:560`), `premise-assessment-p` (`:577`), `derivation-receipt-p` (`:619`) — all auto-generated by
  `defstruct`. (`derivation-receipt-p` and `refutation-p` ARE called internally by `why`/`derive`.)
- 3 condition base readers: `slice1-condition-failed-invariant` (`:107`),
  `slice1-condition-offending-field` (`:109`), `slice1-condition-offending-value` (`:111`).

### 1B. Full 69-row table

Standing vocabulary (proposed): OLF = ordinary language form · CLF = consequential language form ·
S→K = surface-to-kernel elaboration form · MCE = Mneme continuity-evidentiary operation · IDO =
inspection-debugging operation · LIB = library convenience · DIS = deliberate introspection surface
(the 22) · RES = implementation residue · UNRESOLVED = AUTHORIAL-STANDING-UNRESOLVED. (No row earned
"Kernel-0 protocol operation" — kernel0 primitives are slice0/kernel0 exports, not slice1's — nor
"historical compatibility residue"; the historical `MULTIPLICITY.lisp` is a specimen file, not an
export.)

| # | Export | file:line | Behavior (per code/tests/specimens) | Exercised-by | Proposed standing |
|---|---|---|---|---|---|
| 1 | `proposition` | `:251` | Constructor: validate `(:predicate KW (role val)…)`, refuse dup roles / raw `(:var…)` / non-boundary values, sort roles by `STRING<`, deep-copy values → canonical slice0 normal-form list. Idempotent. | SMOKE PRAEM ADMIS | **OLF** |
| 2 | `structured-proposition=` | `:266` | `EQUAL` on normal forms; role-order-insensitive. | SMOKE (`SMOKE-1.lisp:141,145,146`) | **LIB** |
| 3 | `normal-form-p` | `:262` | Predicate: `(equal x (proposition x))`, errors swallowed. | SMOKE | **LIB** |
| 4 | `proposition-pattern` | `:285` | Constructor: like `proposition` but admits `(:var KW)` at any value position and collects vars; a distinct struct that can never stand as ground. | SMOKE PRAEM ADMIS | **OLF** |
| 5 | `proposition-pattern-p` | auto `:279` | Type predicate. | unexercised (internal: none) | **UNRESOLVED** (see Q1) |
| 6 | `proposition-pattern-normal-form` | `:295` | `copy-tree` of the pattern's normal form (vars kept). | unexercised | **DIS** (of the 22) |
| 7 | `proposition-pattern-variables` | `:301` | fresh list of the pattern's var keywords. | unexercised | **DIS** |
| 8 | `judgment-schema` | `:435` | Constructor: versioned schema (name KW, version int≥0, conclusion+premises patterns, locals, unique-locals); mints durable identity + admit-kind; typed refusals for undeclared/duplicate/bad-unique vars. | SMOKE PRAEM ADMIS | **OLF** |
| 9 | `judgment-schema-p` | auto `:397` | Type predicate. | unexercised | **UNRESOLVED** (Q1) |
| 10 | `judgment-schema-name` | `:414` | keyword name. | unexercised | **DIS** |
| 11 | `judgment-schema-version` | `:415` | integer version. | unexercised | **DIS** |
| 12 | `judgment-schema-identity` | `:416` | kernel0 durable identity in the **`:procedure`** domain (`"procedure:schema/NAME/VER"`) — **wart 2** (`:procedure` has no `:schema` domain). Internally load-bearing (`%grant-derivation:919`, `%build-conclusion-procedure`). | unexercised by programs | **DIS** (the 22) / behavior is S→K |
| 13 | `judgment-schema-conclusion` | `:417` | the conclusion `proposition-pattern`. | unexercised | **DIS** |
| 14 | `judgment-schema-premises` | `:419` | fresh (`copy-list`) list of premise patterns. | unexercised | **DIS** |
| 15 | `judgment-schema-locals` | `:420` | fresh list of declared locals. | unexercised | **DIS** |
| 16 | `judgment-schema-conclusion-variables` | `:426` | fresh list of conclusion vars. | unexercised | **DIS** |
| 17 | `judgment-schema-unique-locals` | `:421` | fresh list of uniqueness-bearing locals (CHARTER-DELTA-2). | unexercised | **DIS** |
| 18 | `judgment-schema-admit-kind` | `:418` | encoded derivation key keyword `:|DERIVATION/NAME/VER|` — **wart 1**; the front-door transport-probe key. v1≠v2 (`EQ`⇒NIL). | SMOKE PRAEM ADMIS | **S→K** |
| 19 | `register-schema` | `:521` | store under exact `(name,version)`; identical re-register OK; different-body-under-taken-key refuses `schema-registration-conflict`; no auto-latest. | SMOKE PRAEM ADMIS | **OLF** |
| 20 | `resolve-schema` | `:543` | resolve by exact `(name,version)`; absent ⇒ typed `schema-not-found`. | SMOKE PRAEM ADMIS | **OLF** |
| 21 | `clear-schema-registry` | `:552` | empty the per-image registry (image hygiene / test reset). | SMOKE PRAEM ADMIS | **LIB** |
| 22 | `refutation` | `:565` | Constructor: name the exact GROUND proposition refuted (normalized+validated); minimal, no negation algebra; a matching refutation BLOCKS its premise beside positive support. | PRAEM ADMIS | **OLF** |
| 23 | `refutation-p` | auto `:560` | Type predicate. Internally used by `derive:960`. | unexercised by programs | **UNRESOLVED** (Q1) |
| 24 | `refutation-refutes` | auto `:560` | normal-form ground proposition refuted. | unexercised | **DIS** |
| 25 | `refutation-source` | auto `:560` | source tag. | unexercised | **DIS** |
| 26 | `refutation-id` | auto `:560` | durable `:receipt` identity. | unexercised | **DIS** |
| 27 | `premise-assessment` | type `:577` | The per-premise structured object (Δ2): 8 fields + disposition. | SMOKE PRAEM ADMIS | **IDO** |
| 28 | `premise-assessment-p` | auto `:577` | Type predicate. | unexercised | **UNRESOLVED** (Q1) |
| 29 | `premise-assessment-premise-pattern` | `:598` | `copy-tree` of the premise pattern's normal form. | SMOKE PRAEM ADMIS | **IDO** |
| 30 | `premise-assessment-ground-instance` | `:600` | pattern under accepted bindings (unbound vars kept). | unexercised | **DIS** |
| 31 | `premise-assessment-matching-accessible-supports` | `:608` | `copy-list` of accessible matched witnesses. | PRAEM ADMIS | **IDO** |
| 32 | `premise-assessment-matching-inaccessible-supports` | `:610` | matched witnesses the receiver cannot reach (residue). | PRAEM ADMIS | **IDO** |
| 33 | `premise-assessment-mismatched-candidates` | `:602` | `(witness . conflicting-roles)` conses. | SMOKE PRAEM ADMIS | **IDO** |
| 34 | `premise-assessment-refuting-supports` | `:612` | refutations naming this premise. | PRAEM ADMIS | **IDO** |
| 35 | `premise-assessment-binding-environments` | `:604` | distinct schema-local deltas this premise admits. | unexercised | **DIS** |
| 36 | `premise-assessment-ambiguities` | `:606` | `(local surviving-values)` when `:ambiguous`, else `()`. | unexercised | **DIS** |
| 37 | `premise-assessment-disposition` | `:597` | one of the six terms (satisfied/missing/mismatched/refuted/inaccessible/ambiguous). | SMOKE PRAEM ADMIS | **IDO** |
| 38 | `derivation-receipt` | type `:619` | Record issued on EVERY `derive` attempt; 13 slots; never a boolean "all-present" summary. | SMOKE PRAEM ADMIS | **MCE** |
| 39 | `derivation-receipt-p` | auto `:619` | Type predicate. Internally used by `why:1062`, `transported-testimony:1029`, `render-derivation-why:1069`. | unexercised by programs | **UNRESOLVED** (Q1) |
| 40 | `derivation-receipt-schema-name` | `:642` | requested schema name (scalar). | unexercised | **DIS** |
| 41 | `derivation-receipt-schema-version` | `:643` | requested version (scalar). | unexercised | **DIS** |
| 42 | `derivation-receipt-conclusion` | `:647` | `copy-tree` ground conclusion (normal form). | unexercised | **DIS** |
| 43 | `derivation-receipt-bindings` | `:648` | `copy-tree` first complete environment (alist), or nil when refused. | unexercised | **DIS** |
| 44 | `derivation-receipt-assessments` | `:653` | `copy-list` of `premise-assessment`s (one per premise). | SMOKE PRAEM ADMIS | **MCE** |
| 45 | `derivation-receipt-decision` | `:644` | `:granted` \| `:refused` (scalar). | SMOKE PRAEM ADMIS | **MCE** |
| 46 | `derivation-receipt-strongest-lawful-result` | `:649` | `:verified`, or `(:blocked-on PRED DISPOSITION)`. | PRAEM | **MCE** |
| 47 | `derivation-receipt-repair-options` | `:651` | `(premise-pattern . repair-form)` per unsatisfied premise. | unexercised | **DIS** |
| 48 | `derivation-receipt-identity` | `:645` | fresh `:receipt` identity per attempt (distinct across re-derivations). | SMOKE PRAEM ADMIS | **MCE** |
| 49 | `derivation-receipt-origin-context` | `:646` | deriving context-id, or nil (scalar). | unexercised | **DIS** |
| 50 | `derivation-receipt-complete-binding-environments` | `:658` | `copy-tree` of ALL complete coherent environments (Δ2). | SMOKE | **MCE** |
| 51 | `derivation-receipt-uniqueness-conflicts` | `:660` | `(local sorted-values carrying-envs)…` (Δ2). | SMOKE | **MCE** |
| 52 | `derivation-receipt-multiply-supported-p` | `:662` | derived VIEW: `t` iff >1 complete environment (NOT a status, NOT a scalar strength). | SMOKE | **MCE** |
| 53 | `derive` | `:946` | **The governed act.** Resolve schema by exact key; bind conclusion vars from ground conclusion; assess each premise over supports relative to receiver; **issue a receipt on every path**; on full coherent discharge (a complete env, no declared-uniqueness conflict, no refutation) mint a derivation witness and drive frozen `raise` → `(values claim receipt)`; else SIGNAL `derivation-refused` carrying the receipt. | SMOKE PRAEM ADMIS | **CLF** |
| 54 | `transported-testimony` | `:1023` | Δ4: turn a (transmitted) receipt into a `:mode :testimony :kind :derivation-report` witness `:for (:asserted CTX-A (:predicate :derived …))`; evidence-THAT a derivation occurred; refused by frozen gate for derivation-keyed conclusions. | SMOKE PRAEM ADMIS | **S→K** |
| 55 | `why` | `:1059` | Façade: a `derivation-receipt` explains itself (returns self); else delegates to `lisp-plus-slice0:why` — one uniform door. | SMOKE PRAEM ADMIS | **IDO** |
| 56 | `render-derivation-why` | `:1066` | Print decision/schema/plurality/uniqueness/per-premise dispositions/repairs — strictly from the receipt's own fields. | SMOKE PRAEM ADMIS | **IDO** |
| 57 | `slice1-condition` | `:105` | Abstract base condition (signal a leaf, not this); carries failed-invariant/offending-field/offending-value/receipt. | SMOKE PRAEM ADMIS (as type in `handler-case`/`slice1-condition-receipt`) | **CLF** (refusal surface) |
| 58 | `slice1-condition-failed-invariant` | `:107` | non-empty invariant string. | unexercised | **UNRESOLVED** (Q2) |
| 59 | `slice1-condition-offending-field` | `:109` | field key at fault. | unexercised | **UNRESOLVED** (Q2) |
| 60 | `slice1-condition-offending-value` | `:111` | offending value. | unexercised | **UNRESOLVED** (Q2) |
| 61 | `slice1-condition-receipt` | `:112` | the refused attempt's receipt (on `derivation-refused`; nil elsewhere). | SMOKE PRAEM ADMIS | **IDO** |
| 62 | `malformed-structured-proposition` | family `:121` | typed refusal: bad shape/vocabulary, dup role, raw `(:var…)` in ground. | unexercised by programs; **selftest T2,T3** | **CLF** (refusal surface) |
| 63 | `pattern-used-as-ground` | family `:122` | typed refusal: a pattern where ground data required. | unexercised by programs; selftest | **CLF** |
| 64 | `schema-construction-error` | family `:123` | typed refusal at schema build (undeclared/dup var, bad unique-local, wrong type). | unexercised by programs; **selftest M8** | **CLF** |
| 65 | `schema-registration-conflict` | family `:124` | typed refusal: different schema under a taken `(name,version)`. | unexercised by programs; selftest | **CLF** |
| 66 | `schema-not-found` | family `:125` | typed refusal: no schema at `(name,version)`. | unexercised by programs; selftest | **CLF** |
| 67 | `unbound-conclusion-variable` | family `:126` | typed refusal: conclusion doesn't ground every conclusion var. | unexercised by programs; selftest | **CLF** |
| 68 | `derivation-refused` | family `:127` | typed refusal: a derivation that did not fully discharge — **carries the receipt**. | SMOKE PRAEM ADMIS | **CLF** |
| 69 | `signal-slice1` | `:129` | The one live signalling path: contract-check (failed-invariant non-empty string; type ⊑ slice1-condition) then `error`. "call directly only when extending the layer." | unexercised | **UNRESOLVED** (Q3) |

### 1C. AUTHORIAL-STANDING-UNRESOLVED — the exact questions

- **Q1 — the 5 exported `-p` type predicates** (`proposition-pattern-p`, `judgment-schema-p`,
  `refutation-p`, `premise-assessment-p`, `derivation-receipt-p`). *Exact question:* The closure
  classifies the **22 field readers** as "deliberate introspection surface" but is **silent on the 5
  auto-generated type predicates**, which are equally unexercised by the three programs (though
  `refutation-p` and `derivation-receipt-p` are load-bearing INTERNALLY). Do they share the
  introspection-surface standing, or are they **library convenience** (idiomatic type guards the
  language intends consumers to use), or **implementation residue** (defstruct spillover nobody meant
  to export)? The synthesis must pick one — the "~30 vs 22" gap in the API brief left it open.
- **Q2 — the 3 `slice1-condition-*` base readers** (`-failed-invariant`, `-offending-field`,
  `-offending-value`). *Exact question:* These are the diagnostic accessors on a *caught* condition,
  yet no shipped program reads them (programs pull `slice1-condition-receipt` off `derivation-refused`
  instead). Are they **inspection-debugging surface** the language promises for condition handlers, or
  do they fall under the same unexercised-introspection caveat as the 22 — and if so why did the
  closure's count exclude them?
- **Q3 — `signal-slice1`.** *Exact question:* The sole live signalling path is exported, but the API
  says "programs normally *receive* conditions … call this directly only when extending the layer."
  Should the language's one signalling primitive be **public surface** at all (an extension point), or
  is exporting it **implementation residue** that widens the attack surface of the condition contract
  with no consumer? (If public, its standing is "deliberate extension surface"; if not, deprecate.)

---

## 2. The governed forms (the four constitutive forms)

The CLOSURE (`LANGUAGE-SLICE-1-CLOSURE.md:61-62`) names the four **constitutive** governed forms:
`proposition · proposition-pattern · judgment-schema · derive` — "constitutive in both domains and the
smoke." All smallest legal examples below are lifted from `SMOKE-1.lisp` (the warrant program).

### 2a. `proposition` — construct a GROUND structured proposition (`slice1.lisp:251`)
Validates `(:predicate KW (role val)…)`, refuses duplicate roles / raw `(:var…)` / non-boundary
values, sorts role pairs by `STRING<` on role name, deep-copies values. Output is canonical slice0
normal-form data (a list), idempotent (its output is a lawful input).

Smallest legal example — `SMOKE-1.lisp:137`:
```lisp
(np '(:predicate :entry-complete (:entry "entry-88") (:checklist "CL-full")))
;; where (defun np (form) (lisp-plus-slice1:proposition form))   ; SMOKE-1.lisp:28
;; => (:PREDICATE :ENTRY-COMPLETE (:CHECKLIST "CL-full") (:ENTRY "entry-88"))  ; roles sorted
```

### 2b. `proposition-pattern` — construct a PATTERN (`slice1.lisp:285`)
Like `proposition` but admits `(:var KW)` at any value position (vars collected). A **distinct struct**
that can never stand as a ground claim/support/refutation; legal only inside a schema's
conclusion/premise slots.

Smallest legal example — `SMOKE-1.lisp:71-73`:
```lisp
(pp '(:predicate :entry-signed-off
      (:entry (:var :entry)) (:reviewer (:var :reviewer)) (:purpose (:var :purpose))))
;; where (defun pp (form) (lisp-plus-slice1:proposition-pattern form))   ; SMOKE-1.lisp:29
```

### 2c. `judgment-schema` — a versioned derivation schema (`slice1.lisp:435`)
Builds a schema (name KW · version int≥0 · conclusion pattern · premise patterns · `:locals` ·
`:unique-locals`). Conclusion variables are implicit; schema-locals may occur ONLY in premise patterns.
Mints the durable identity (`:procedure` domain, wart 2) and admit-kind (encoded keyword, wart 1).
Typed refusals (`schema-construction-error`) for non-keyword name, bad version, non-pattern
conclusion/premise, a local in the conclusion, an undeclared premise variable, a bad unique-local.

Smallest legal example — the founding schema, `SMOKE-1.lisp:68-84` (Schema 1, non-unique local):
```lisp
(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :notebook-signoff :version 1
  :conclusion (pp '(:predicate :entry-signed-off
                    (:entry (:var :entry)) (:reviewer (:var :reviewer)) (:purpose (:var :purpose))))
  :premises
  (list (pp '(:predicate :entry-complete    (:entry (:var :entry)) (:checklist (:var :checklist))))
        (pp '(:predicate :results-reproduced (:entry (:var :entry)) (:replicate (:var :replicate))))
        (pp '(:predicate :reviewer-qualified (:reviewer (:var :reviewer)) (:competency (:var :competency))))
        (pp '(:predicate :purpose-permitted  (:entry (:var :entry)) (:reviewer (:var :reviewer))
                                             (:purpose (:var :purpose)))))
  :locals '(:checklist :replicate :competency)))
```

### 2d. `derive` — the governed derived-judgment act (`slice1.lisp:946`)
Resolve schema by exact `(name,version)`; bind conclusion vars from the **ground** conclusion; assess
each declared premise over `supports` (slice0 `witness`es + slice1 `refutation`s) relative to the
acting `receiver`; **issue a receipt on every path** (`slice1.lisp:979-999`). GRANT iff a schema has
premises AND ≥1 complete coherent environment exists AND no refutation AND no declared-uniqueness
conflict (`slice1.lisp:977-978`) → mint witness + drive frozen `raise` to `:verified`; else SIGNAL
`derivation-refused` carrying the receipt. Six premise dispositions (charter §5;
`LANGUAGE-SLICE-1-API.md:346-355`): `:satisfied :missing :mismatched :refuted :inaccessible :ambiguous`.

Smallest legal example — `SMOKE-1.lisp:55-57` (inside `run-derive`):
```lisp
(lisp-plus-slice1:derive :schema-name schema-name :schema-version 1
                         :conclusion conclusion :supports supports :receiver receiver)
;; => (values granted-claim receipt) on grant; signals derivation-refused (carrying receipt) on refusal
```

---

## 3. The multiplicity ruling as executable semantics (CHARTER-DELTA-2)

Adopted verbatim (`CHARTER-DELTA-2.md:12-19`), superseding CHARTER-DELTA-1 Δ1's ambiguity clause and
Errata 3's threaded refuse-on-plurality:
```lisp
(:slice-1-multiplicity
 :complete-environment-semantics :existential
 :default-multiple-complete-environments :grant-and-preserve-all
 :ambiguity :only-from-declared-uniqueness-constraint
 :implicit-domain-discriminator :forbidden
 :environment-selection-by-order :forbidden)
```
> **Plurality is evidence. Ambiguity begins only where the schema has declared that a choice matters.**
> (`CHARTER-DELTA-2.md:21-22`)

**Operational meaning** (`CHARTER-DELTA-2.md:32-44`; implemented `slice1.lisp:946-1014`,
`%assess-and-enumerate:768`, `%uniqueness-conflicts:703`):

- The evaluator **enumerates ALL complete binding environments** across premises (finite,
  deterministic, pattern-against-ground) instead of refusing at the first premise-local plurality
  (`CHARTER-DELTA-2.md:57-63`; `derive` computes `complete-envs` and preserves them all in the receipt
  `slice1.lisp:983`). A premise-local plurality on a **non-unique** local is NOT a refusal anywhere.
- **`:ambiguous` arises ONLY when** the schema declares ≥1 `:unique-locals`, AND >1 distinct value for
  a uniqueness-bearing local survives across otherwise-complete coherent environments, AND no declared
  discriminator resolves it — **and in Slice /1 there ARE no discriminators** (no comparator/predicate/
  host callback may be installed; `CHARTER-DELTA-2.md:54-55`). "plurality is evidence; ambiguity only by
  declaration" = *the receipt keeps every complete environment as positive evidence, and only a
  schema-author's explicit `:unique-locals` declaration can convert a surviving multiplicity into a
  refusal.*

**The three cases as executable semantics** (`CHARTER-DELTA-2.md:76-89`; run in
`de-admissione-datorum/MULTIPLICITY-REPAIRED.lisp`, teeth M1–M12; verified CLOSURE:87):

- **Case A** — redundant sufficiency, non-unique local: **GRANT**; both environments preserved in the
  receipt; premise `:satisfied`; no canonical environment selected.
  (`derivation-receipt-complete-binding-environments` length 2; `derivation-receipt-multiply-supported-p`
  ⇒ T; `derivation-receipt-uniqueness-conflicts` ⇒ NIL — `LANGUAGE-SLICE-1-API.md:357-361`.)
- **Case B** — explicit uniqueness conflict: the material distinction becomes **anatomy** (an
  `:authority` role, `:unique-locals (:authority)`; SMOKE Schema 2 `SMOKE-1.lisp:87-105`) ⇒ **REFUSE
  `:ambiguous`**; both environments still preserved; the receipt names `?authority` as the conflict;
  certificate/local plurality itself is NOT the conflict.
- **Case C** — hidden incompatibility stays hidden: original schema, no authority role, no uniqueness ⇒
  **GRANT** with both environments + the explicit statement that the language cannot enforce an
  incompatibility absent from declared anatomy. **Case C is the claim ceiling made executable**
  (`CHARTER-DELTA-2.md:88-89`): declared anatomy can be enforced; undeclared domain distinctions cannot
  be divined. (Tooth M10: prose-incompatible names "vendor" vs "self-signed" NOT inferred ⇒ GRANT.)

`:unique-locals` — the one bounded schema field (default `()`): every unique local ∈ `:locals`;
conclusion variables may NOT be listed; duplicates/unknowns refuse; immutable + defensively copied;
**no comparator callback may be installed** (`CHARTER-DELTA-2.md:47-55`). Decision stays binary
granted/refused; the derived VIEW `derivation-receipt-multiply-supported-p` is permitted; **no seventh
premise status** (`CHARTER-DELTA-2.md:73-74`).

---

## 4. Slice-0 integration points (the seam the synthesis MUST preserve)

Slice /1 adds **no new enforcement regime** — it supplies *anatomy* that the FROZEN slice0/kernel0
machinery then enforces (charter §7). Slice /0 remained byte-frozen throughout (CLOSURE:5). Five touch
points:

1. **Promotion (raise).** `%build-conclusion-procedure` (`slice1.lisp:880-899`) builds the conclusion's
   judgment procedure via `lisp-plus-slice0:promotion-procedure` + `lisp-plus-kernel0:make-procedure-descriptor`
   + `lisp-plus-kernel0:make-identity :procedure`, declaring `:admits ((:derivation <admit-kind>))`.
   **This is the S3 closure:** the ONLY support shape the frozen `%procedure-admits-p` gate will admit
   for the conclusion is the derivation key itself — a generic content witness is refused by *existing*
   slice0 machinery. `%grant-derivation` (`slice1.lisp:910-944`) then mints a `lisp-plus-slice0:witness
   :mode :derivation :kind <admit-kind> :procedure <schema-identity>`, makes a `lisp-plus-slice0:claim`,
   and drives the frozen `lisp-plus-slice0:raise … :to :verified :per procedure :considering (list
   dwitness) :receiver ctx-id`. A real slice0 `:verified` promotion, not a slice1 side channel.

2. **Projection (re-derivation, not copy).** Structured propositions ARE canonical slice0 data
   (charter §1, §9), so they flow through projection unchanged. Charter law: a derived conclusion does
   NOT survive projection by status copy — reconstruction at a target requires **re-derivation from
   premises lawful at the target** (`derive` at the target with the target's accessible supports); a
   receiver-bound premise fails to cross by **binding coherence** (`?receiver=A` won't match
   `?receiver=B` → `:mismatched`), not by special case. Verified: SMOKE behavior 8 ("re-derives over its
   own lawful premises; receipt identities distinct — no copy"), de-praemissis behavior 12,
   de-admissione behavior 12.

3. **Testimony (transport, Δ4).** `transported-testimony` (`slice1.lisp:1023-1043`) wraps a receipt as a
   `lisp-plus-slice0:witness :mode :testimony :kind :derivation-report :for (:asserted CTX-A
   (:predicate :derived …))`. It is evidence-THAT a derivation occurred and **cannot masquerade as a
   local derivation** — offered to a derivation-keyed conclusion procedure at another receiver, the
   frozen `raise` refuses it with `wrong-proposition-support` (its `:for` is the attribution, not the
   conclusion). Verified: SMOKE behavior 9, de-admissione behaviors 13–14.

4. **`why` (the one uniform door) + the SOLE licensed `::`.** `why` (`slice1.lisp:1059-1064`) returns a
   `derivation-receipt` as its own explanation, else delegates to `lisp-plus-slice0:why`. To keep `why`
   uniform, slice1 registers ONE extractor into the frozen registry via **the single licensed internal
   access in all of Slice /1** — `lisp-plus-slice0::*why-extractors*` (`slice1.lisp:1056-1057`),
   receipted in `SLICE0-DEFECT-RECEIPT-1.md` because the frozen slice0 package exports no public
   registration point. Registration is **idempotent** (guarded `find` on the symbol `'derivation-receipt-p`,
   `EQ`-stable across reloads): the extractor list grows to exactly 3 total (projection, transmission,
   derivation) and stays there. **No other internal slice0 access is taken** (static audit: zero `::`
   across all specimen/smoke programs; the licensed seam only in substrate/selftest — CLOSURE:89).

5. **Identity/key elaboration onto frozen kernel0 domains (the two warts).** kernel0's identity-domain
   list is frozen with no `:schema`, so a schema's durable identity is minted in **`:procedure`**
   (`"procedure:schema/NAME/VER"`, wart 2, `judgment-schema-identity`); and the frozen
   `witness`/`promotion-procedure` require `:kind` to be a keyword, so the `(:derivation (:schema NAME
   VER))` key is encoded as one interned keyword `:|DERIVATION/NAME/VER|` (wart 1,
   `judgment-schema-admit-kind`). Both preserve exactness + versioning (v1≠v2). **The synthesis must
   preserve these encodings byte-for-byte** — they are the load-bearing bridge from slice1 anatomy to
   frozen slice0/kernel0 primitives, and a naive "clean up the warts" would break the S3 closure and
   the transport gate.

**Seam summary for the chair:** the integration is a *one-way, minimal, receipted* dependency — slice1
reads slice0's PUBLIC surface (`claim`, `witness`, `receiver-context`, `raise`, `promotion-procedure`,
`why`, `witness-p`, `witness-id`, `receiver-context-context-id`) + kernel0 (`make-identity`,
`make-procedure-descriptor`, `identity-key`), and takes exactly **one** internal `::` (the why-extractor
push), receipted. Guarantees hold for **well-formed programs on the single-colon surface**; the
same-image hand-built derivation witness that skips `derive` is the acknowledged **stratum-3 host
escape** (Δ3), inherited from slice0 unchanged, repair refused on principle (AUDIT-1-CLOSURE). Preserve:
(a) the single receipted `::`, (b) the S3 admits-key closure, (c) the two identity/key encodings, (d)
projection-by-re-derivation, (e) testimony's non-masquerade gate.

---

*Census complete. 69 exports enumerated; 22 introspection-surface readers reproduced exactly and the
API/closure labeling confirmed; 8 further unexercised readers surfaced as AUTHORIAL-STANDING-UNRESOLVED
(Q1–Q3); one stale selftest tally (31 vs final 50) flagged. Cited to file:line throughout. Where a
tally was compressed (the 50-pass leaf count), it is marked "traced, compressed."*

— CENSOR-SECUNDUS (Claude Opus 4.8, 1M context), 2026-07-24
