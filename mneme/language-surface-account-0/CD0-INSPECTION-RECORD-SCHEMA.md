# Surface Account /0 — The CD/0 Inspection-Record Schema (exact, authoritative)

**Seat:** JURIST (Claude Fable 5), R2 sitting; **R3-normalized per the R3
adjudication Section R3-A** (schema made TOTAL over everything the five
predicates admit; predicate comparison law made fully exact; teeth
specified). **This file is the authoritative schema.** Contract I.8b defers
to it; where any prose elsewhere disagrees, these tables win. It is written
so the probe seat can build the required **non-production schema witness
from these tables alone** (§8 states exactly what the witness proves).

**The two-stage total decision law (R3.1 owner disposition — DETAIL
TOTALITY; this replaces R3's "every admitted object unconditionally yields
a record", which was one stage too strong: the provider predicates admit
objects carrying detail values the Account cannot necessarily encode):**

> 1. **Species admission** uses the five exact public predicates.
> 2. **Projection** returns either:
>    - **one exact successful CD/0 inspection record**; or
>    - **one typed Account protocol refusal from Account field
>      validation.**
>
> **No raw host or CD/0 condition may escape Account-owned validation.**

The decision is total — every admitted object reaches exactly one of the
two outcomes — and the refusal branches (§5) still encode *every* admitted
native category/phase/code, including S2 `:protocol-refusal`/`:expansion`
refusal objects and S2 `:integrity-alarm` refusal objects (the two classes
the R2 tables left unencodable). Jurisdiction governs *routing of live
outcomes*; the schema encodes *artifacts*; Account field validation
(the detail union below) decides which of the two stage-2 outcomes an
admitted artifact draws.

**Standing.** Proposed design, not implemented; the schema binds the future
production round. The inspector's output is a **direct inert CD/0 record
datum** — never a private Account wrapper, never a newly admitted semantic
account object. Everything below uses only the accepted public
`LISP-PLUS-CD0` API (`canonical-datum/common-lisp/package.lisp` export
list): the nine datum families, `make-identifier-datum` /
`make-string-datum` / `make-integer-datum` / `make-record-entry` /
`make-record-datum`, `datum-p`, `equal-datum`, `encode-exact` /
`canonical-octets` / `decode-exact`.

**Key-order law.** CD/0's canonical record key sorting is **authoritative
and exhaustive**: `make-record-datum` sorts entries by octet comparison of
each key's encoded identifier ValueBytes and rejects duplicates
(`cd0.lisp`, `%normalize-record-entries` — read this round). **No semantic
field is "first"**; any earlier prose claiming a physical first field is
deleted. A field's position is whatever the canonical key order yields.

---

## §1 Identifier-datum conventions (every schema identifier, with namespace/path)

All Account-schema identifier datums use **namespace = `("lisp-plus-surface-account")`**
(one segment). Path families:

| Family | Path shape | Used for |
|---|---|---|
| record keys | `("key" "<field-name>")` | every record key in envelope and branch bodies |
| schema identity | `("schema" "account-inspection-record")` | the schema-identity value |
| species | `("species" "<species-name>")` | the five branch species values |
| standings | `("standing" "<standing-name>")` | every standing / absence / not-applicable value |
| Account enums | `("code" "<code-name>")`, `("phase" "<phase-name>")` | Account-owned composite refusal codes and phases |
| native keywords | `("keyword" "<SYMBOL-NAME>")` | every native keyword value carried by rendering (operation, category, code, phase, S1 disposition, keyword-valued upstream fields) — `<SYMBOL-NAME>` is the keyword's `SYMBOL-NAME`, verbatim |
| manifest | `("manifest")` | the /0 manifest identity (contract I.1) |

Ownership is structural: Account-owned enumerations never use the
`"keyword"` family; native keyword values never use `"code"`/`"phase"`/
`"standing"`/`"species"`.

## §2 Value-encoding law (every enum, keyword, integer, string, code, category, phase, disposition, standing)

| Source value kind | CD/0 encoding |
|---|---|
| integer (stored versions, schema version, sizes) | integer datum |
| string (S2 disposition; detail; string-valued upstream fields) | string datum, scalar-verbatim |
| native keyword (operation, category, native code, native phase, S1 disposition, keyword-valued upstream fields) | identifier datum, path `("keyword" "<SYMBOL-NAME>")` |
| Account-owned enum (composite refusal code, composite phase) | identifier datum, path `("code" …)` / `("phase" …)` |
| standing / absence / not-applicable (mandatory encoding — never a missing field, never CL `NIL`) | identifier datum, path `("standing" "<name>")` |
| native CD/0 datum (identities, source/expanded datums, contexts, tags) | **passes through unchanged** — the very datum value, byte-equal under `canonical-octets` to the native original (§6). *Species erratum (measured by the schema witness, probe seat): the native identity values — receipt/request/occurrence/source/expanded identities and both refusal identities, twelve keys across §§4–5 — are CD/0 **bytes datums**, not identifier datums as this document first wrote; the occurrence tag and construct identity are identifier datums as written. Pass-through and byte-equality are unaffected (proved).* |

**Standing names (closed set):** `"not-claimed"`, `"pre-invocation"`,
`"invoked-no-completion-account"`, `"measured-nil"`,
`"unavailable-no-public-accessor"`, `"no-public-verifier"`,
`"public-verifier-exists-output-not-carried"`,
`"absent-no-public-antecedent"`, `"not-applicable"`.

**Species names (closed set of five):** `"s1-receipt"`, `"s1-refusal"`,
`"s2-receipt"`, `"s2-refusal"`, `"composite-refusal"`.

**The detail union and its validation codes (R3.1 DETAIL TOTALITY).** For
successful native-refusal records, the mandatory `detail` key is the
**closed union**:

    scalar CD/0 string datum of at most 1024 payload octets
  | standing/measured-nil

`NIL` **encodes as `("standing" "measured-nil")`** — it is never a
validation failure. Every other inadmissible detail value draws exactly one
of the three Account-owned validation codes, each **category
protocol-refusal, phase `:request`, owner Account, derived standing
`pre-invocation`, producing NO inspection record** (jurisdiction table 1):

| Code | Catches |
|---|---|
| `native-detail-not-string` | a non-`NIL`, non-string detail value (e.g. the integer `42`) |
| `native-detail-not-cd0-scalar-string` | a host string CD/0 cannot represent as a scalar string datum |
| `detail-string-exceeds-ceiling` | a representable scalar string above 1024 payload octets (1024 passes; 1025 refuses) — **never truncation**: a truncated detail would be a lossy datum, and no lossy datum is manufactured |

Actual Account *condition signalling* remains a mandatory **production**
tooth (`R4-SURVIVAL-PLAN.md` §4(h5) family); R3.1 implements only
unmistakably non-production validators and witnesses.

## §3 The common envelope (one record datum, exactly four keys)

| Key (path `("key" …)`) | Value datum |
|---|---|
| `"schema-identity"` | identifier, path `("schema" "account-inspection-record")` |
| `"schema-version"` | integer datum `1` |
| `"species"` | identifier, path `("species" "<one of the five>")` |
| `"body"` | record datum — the branch body (§4–§5), exact key set per species |

No other envelope key exists. No optional key exists anywhere in this
schema: **a branch's key set is exact — every listed key always present,
every unlisted key never present** — and value-absence is carried by a
mandatory `("standing" …)` identifier, never by omitting the key.

## §4 Branch bodies — receipt branches (exact key sets)

### §4.1 `"s1-receipt"` body — exactly 18 keys

| Key | Value datum | Native pass-through? |
|---|---|---|
| `"receipt-identity"` | **bytes datum** *(erratum: was misnamed "identifier datum"; measured by the schema witness)* | **yes — unchanged** |
| `"request-identity"` | **bytes datum** *(erratum, measured)* | yes |
| `"occurrence-identity"` | **bytes datum** *(erratum, measured)* | yes |
| `"occurrence-tag"` | identifier datum (read via the occurrence — the only public route, measured; NOT in the erratum set — measured as an identifier datum) | yes |
| `"source-datum"` | record datum | yes |
| `"source-identity"` | **bytes datum** *(erratum, measured)* | yes |
| `"expanded-datum"` | record datum | yes |
| `"expanded-identity"` | **bytes datum** *(erratum, measured)* | yes |
| `"construct-identity"` | identifier datum (NOT in the erratum set — measured as an identifier datum) | yes |
| `"expansion-context"` | record datum | yes |
| `"operation"` | identifier `("keyword" "MACROEXPAND-1")` or `("keyword" "MACROEXPAND")` | no — rendered |
| `"disposition"` | identifier `("keyword" "<S1 keyword name>")` — **the S1 vocabulary is exactly two names** (verified against `surface1.lisp:884–885` this round; R3.1-A deletes the invented `MACROEXPANDED-TO-FIXPOINT` from the R3 table): `"MACROEXPANDED-ONE-STEP"`, `"MACROEXPANDED-REPEATEDLY"`. **Exact operation/disposition pairings, predicate-enforced (§7):** `MACROEXPAND-1` → `MACROEXPANDED-ONE-STEP`; `MACROEXPAND` → `MACROEXPANDED-REPEATEDLY` | no — rendered (S1 keyword domain) |
| `"stored-grammar-version"` | integer datum | no — value copied |
| `"stored-procedure-version"` | integer datum | no |
| `"stored-policy-version"` | integer datum | no |
| `"grammar-identity-standing"` | identifier `("standing" "unavailable-no-public-accessor")` (constant) | — |
| `"verifier-availability"` | identifier `("standing" "no-public-verifier")` (constant) | — |
| `"temporal-uniqueness-standing"` | identifier `("standing" "not-claimed")` (constant) | — |

### §4.2 `"s2-receipt"` body — exactly 18 keys

As §4.1 with exactly three differences: `"disposition"` is a **string
datum** — S2's vocabulary is exactly two strings (verified against
`surface2.lisp:272–273`): `"expanded-once"`, `"expanded-to-fixpoint"`,
verbatim, with the **exact operation/disposition pairings,
predicate-enforced (§7)**: `MACROEXPAND-1` → `"expanded-once"`;
`MACROEXPAND` → `"expanded-to-fixpoint"`; the three stored versions carry
S2's values; `"verifier-availability"` is the constant identifier
`("standing" "public-verifier-exists-output-not-carried")` (the pure
inspector **omits S2 verifier output entirely**; `VERIFY-RECEIPT`'s
standing is Locked Ruling 6's and lives in the provenance matrix, not in
this record).

## §5 Branch bodies — refusal branches (exact key sets)

### §5.1 `"s1-refusal"` body — exactly 9 keys

| Key | Value datum |
|---|---|
| `"refusal-identity"` | native **bytes datum** — pass-through *(erratum: was misnamed "identifier datum"; measured by the schema witness — applies to §5.2's `"refusal-identity"` too, via "encodings exactly as §5.1")* |
| `"category"` | identifier `("keyword" "<name>")` — measured `"PROTOCOL-REFUSAL"`, `"INTEGRITY-ALARM"` vocabulary |
| `"code"` | identifier `("keyword" "<native code name>")` (native code vocabulary, jurisdiction table 2) |
| `"phase"` | identifier `("keyword" "<native phase name>")` |
| `"detail"` | **the exact two-member union (R3.2 reconciliation — this cell now matches the ruled law, §2):** scalar CD/0 string datum of ≤ 1024 payload octets **\|** identifier `("standing" "measured-nil")` (the mandatory encoding of a measured native `NIL` detail). A complete record with either member satisfies the predicate (§7 clause 7). |
| `"upstream-category"` | closed union, **exactly three members and no other** (R3.1-A): identifier `("standing" "measured-nil")` \| native keyword identifier `("keyword" …)` \| scalar string datum. **No other `("standing" …)` value is lawful in an upstream key** — `not-applicable`, `unavailable-no-public-accessor`, and every other standing name fail §7 conformance here. |
| `"upstream-code"` | same closed three-member union, same no-other-standing law |
| `"upstream-stage"` | same closed three-member union, same no-other-standing law |
| `"derived-standing"` | identifier `("standing" …)` — **total, per code (R3-A)**: `"pre-invocation"` or `"invoked-no-completion-account"` where actually derived (jurisdiction table 2), `"not-applicable"` for every admitted provider-owned artifact outside the Account pre/invoked partition (S1's three `:integrity-alarm`/`:receipt` rows). Never inferred from phase alone. |

The three-species union on the upstream keys is closed and structurally
discriminated (datum family + path head); the value-exercised variant this
round is `("standing" "measured-nil")` (measured `NIL` on native protocol
refusals) and string values on the STOP-cell refusals (`"TermGrammar"`,
`"SHARED-OR-CIRCULAR-STRUCTURE"`, `"term-encode"`).

**§5.1-T The total admitted S1 value enumeration (R3-A).** Everything
`LISP-PLUS-SURFACE1:EXPANSION-REFUSAL-P` admits, encodable, with exact
derived standing (category/phase from the measured 20-row catalog):

| Category / phase | Codes | `derived-standing` |
|---|---|---|
| `PROTOCOL-REFUSAL` / `REQUEST` | `SOURCE-FORM-NOT-A-CALL`, `SOURCE-FORM-HEAD-NOT-A-SYMBOL`, `OPERATION-NOT-DECLARED`, `OCCURRENCE-TAG-NOT-IDENTIFIER`, `SOURCE-TERM-UNREPRESENTABLE`, `SOURCE-TERM-SHARED-STRUCTURE`, `SOURCE-DEPTH-EXCEEDED`, `SOURCE-NODES-EXCEEDED`, `SOURCE-TERM-OCTETS-EXCEEDED` | `"pre-invocation"` (all nine) |
| `PROTOCOL-REFUSAL` / `PERFORM` | `NOT-A-KNOWN-SURFACE-CONSTRUCT`, `CONSTRUCT-NOT-A-MACRO`, `SOURCE-NOT-RECONSTRUCTIBLE` | `"pre-invocation"` |
| `PROTOCOL-REFUSAL` / `PERFORM` | `EXPANDED-TERM-UNREPRESENTABLE`, `EXPANDED-TERM-SHARED-STRUCTURE`, `EXPANDED-DEPTH-EXCEEDED`, `EXPANDED-NODES-EXCEEDED`, `EXPANDED-TERM-OCTETS-EXCEEDED` | `"invoked-no-completion-account"` |
| `INTEGRITY-ALARM` / `RECEIPT` | `SOURCE-IDENTITY-PROJECTION-MISMATCH`, `EXPANDED-IDENTITY-PROJECTION-MISMATCH`, `PROCEDURE-VERSION-MISMATCH` | `"not-applicable"` (admitted provider-owned artifacts outside the Account pre/invoked partition) |

### §5.2 `"s2-refusal"` body — exactly 6 keys

`"refusal-identity"`, `"category"`, `"code"`, `"phase"`, `"detail"`,
`"derived-standing"` — encodings exactly as §5.1, **including the exact
two-member detail union** (scalar string ≤1024 payload octets |
`("standing" "measured-nil")` — R3.2 reconciliation) and the total
derived-standing law. **No upstream keys exist in this branch's schema**
(S2's measured absence is schema-level).

**§5.2-T The total admitted S2 value enumeration (R3-A).** Everything
`LISP-PLUS-SURFACE2:EXPANSION-REFUSAL-P` admits, encodable — **including
the two classes the R2 tables left unencodable: `:protocol-refusal`/
`:expansion` refusal objects and `:integrity-alarm` refusal objects** —
with exact derived standing (category/phase from the measured 29-row
catalog):

| Category / phase | Codes | `derived-standing` |
|---|---|---|
| `PROTOCOL-REFUSAL` / `REQUEST` | the same nine request print-names as §5.1-T (S2's own symbols; measured) | `"pre-invocation"` (all nine) |
| `PROTOCOL-REFUSAL` / `PERFORM` | `NOT-A-KNOWN-SURFACE2-CONSTRUCT`, `SOURCE-NOT-RECONSTRUCTIBLE` | `"pre-invocation"` |
| `PROTOCOL-REFUSAL` / `PERFORM` | `EXPANDED-TERM-UNREPRESENTABLE`, `EXPANDED-TERM-SHARED-STRUCTURE`, `EXPANDED-DEPTH-EXCEEDED`, `EXPANDED-NODES-EXCEEDED`, `EXPANDED-TERM-OCTETS-EXCEEDED` | `"invoked-no-completion-account"` |
| `PROTOCOL-REFUSAL` / `EXPANSION` | `NON-EXHAUSTIVE-MATCH`, `DUPLICATE-PATTERN`, `UNREACHABLE-PATTERN`, `PATTERN-NOT-IN-GRAMMAR`, `MATCH-VAR-NOT-A-SYMBOL`, `WITH-OUTCOME-BINDING-MALFORMED`, `FACET-BINDING-MALFORMED` | `"not-applicable"` (provider-owned, outside the Account pre/invoked partition — encodable as retained artifacts even though, as live outcomes, the jurisdiction re-signals them) |
| `PROTOCOL-REFUSAL` / `RUNTIME` | `NOT-A-SEAT-OUTCOME` | `"not-applicable"` |
| `INTEGRITY-ALARM` / `RECEIPT` | `RECEIPT-NOT-MINTED`, `SOURCE-IDENTITY-PROJECTION-MISMATCH`, `EXPANDED-IDENTITY-PROJECTION-MISMATCH` | `"not-applicable"` |
| `INTEGRITY-ALARM` / `MATCH` | `PROJECTION-WITHOUT-SETTLED-EXECUTION`, `NO-EVIDENCE-CLASS` | `"not-applicable"` |

### §5.3 `"composite-refusal"` body — exactly 6 keys

| Key | Value datum |
|---|---|
| `"refusal-code"` | identifier `("code" "<name>")` — the **closed FIVE-code set** of retainable composite refusals (R3.1 owner disposition — Door-1 ownership RESTORED; the R3 two-code consolidation is rejected and withdrawn; the corrected spelling `head-not-in-manifest` is kept): `("code" "source-form-not-a-call")`, `("code" "source-form-head-not-a-symbol")`, `("code" "head-not-in-manifest")`, `("code" "operation-not-declared")` (all Door 1), or `("code" "wrong-request-species")` (Door 2). The inspector's validation codes (`not-an-admitted-account-object`, `native-detail-not-string`, `native-detail-not-cd0-scalar-string`, `detail-string-exceeds-ceiling`) are **condition codes only** — the inspector signals, it never returns a branch-5 record, so they never appear in this key. |
| `"phase"` | identifier — exactly `("phase" "request")` for the four Door-1 codes; exactly `("phase" "perform")` for `wrong-request-species` (a request rejected by Door 2 is phase `:perform` — R3-C lock) |
| `"detail"` | scalar CD/0 string datum of ≤ 1024 payload octets **only** — the composite AUTHORS its own detail, so the union's `("standing" "measured-nil")` member is unreachable in this branch (there is no measured native `NIL` to encode; R3.2: per-branch exactness, stated rather than silently narrowed). |
| `"manifest-identity"` | identifier `("manifest")` — the /0 manifest identity, Account-owned (contract I.1) |
| `"manifest-version"` | integer datum |
| `"derived-standing"` | identifier `("standing" "pre-invocation")` (constant — a pre-delegation refusal is always pre-invocation) |

## §6 Native pass-through law

The following values are carried as **the identical CD/0 datum values the
native public accessors return**, unchanged: all native identity datums
(receipt/request/occurrence/refusal/source/expanded/construct), the
occurrence tag, the source datum, the expanded datum, and the expansion
context. The witness check is `canonical-octets` equality (and
`equal-datum`) between the native original and the value inside the
inspection record. No native datum is re-encoded through any other grammar,
normalized, or copied through a printed representation.

## §7 The predicate — the full-exactness comparison law (R3-A)

`account-inspection-record-p` (if the production round keeps it) recognizes
**the exact CD/0 schema**, comparing — for the envelope and for every
branch-body entry — **the complete key identifier datum**, never a name
fragment:

1. **exact namespace** — every schema identifier's namespace is exactly
   `("lisp-plus-surface-account")`, one segment, verbatim;
2. **exact path head, exact path length, and exact segments** — e.g. a key
   is exactly `("key" "<field-name>")`: two segments, head `"key"`, the
   field name from the branch's closed key set; an extra segment, a wrong
   head, or a wrong length fails conformance;
3. **exact schema identity and version** — the `"schema-identity"` value
   is `equal-datum` to the identifier `("schema"
   "account-inspection-record")` and `"schema-version"` to integer `1`;
4. **exact branch species** — the `"species"` value is one of the five
   closed species identifiers, and the body's key set is exactly that
   species' set;
5. **exact enum, standing, category, phase, disposition, and code
   values** — every enum-valued entry is checked against its closed set:
   standings against §2's closed standing names (and, in upstream keys,
   against the three-member union's `measured-nil`-only standing law);
   composite codes against §5.3's five-code set with the per-code phase
   pairing; native category/phase/code renderings against the enumerated
   admitted vocabularies of §§5.1-T/5.2-T; operations against the two
   declared names; an **unknown enum or code fails conformance** — closed
   sets, no pass-anything cell.

Additionally, per R3.1-A, the predicate enforces for successful records:

6. **/0 manifest version exactly `1`** — branch 5's `"manifest-version"`
   is `equal-datum` to integer `1`; version `2` fails conformance;
7. **the detail union and ceiling exactly (R3.2 reconciliation)** — in
   the native refusal branches (§§5.1, 5.2) `detail` is exactly the
   two-member union: a scalar CD/0 string datum of ≤1024 payload octets
   OR the `("standing" "measured-nil")` identifier — **a complete record
   with either member satisfies the predicate**; in branch 5 (§5.3) it is
   the scalar string member only (Account-authored; the standing member
   unreachable there); 1024 passes, 1025 fails;
8. **exact provider `(code, category, phase)` TRIPLES** — catalogue
   comparison is by complete triples from §§5.1-T/5.2-T, never by
   code-name sets: a known code name under a drifted category or phase
   fails conformance;
9. **exact derived standing per triple** — the `derived-standing` value
   must equal the triple's ruled standing, never merely a lawful standing
   name;
10. **exact operation/disposition pairings** —
    S1: `MACROEXPAND-1` → `MACROEXPANDED-ONE-STEP`,
    `MACROEXPAND` → `MACROEXPANDED-REPEATEDLY`;
    S2: `MACROEXPAND-1` → `"expanded-once"`,
    `MACROEXPAND` → `"expanded-to-fixpoint"` — a crossed pairing fails
    conformance.

It recognizes **no wrapper species** — there is none to recognize.

## §8 What the non-production schema witness proves (built from this file alone)

For **one genuinely lawful constructed instance of every current branch**
(five instances), through the accepted public CD/0 API only:

1. `datum-p` holds on the whole record;
2. `encode-exact` → `decode-exact` round-trips to an `equal-datum` record;
3. canonical re-encoding equality: `canonical-octets` of the decoded record
   equals `canonical-octets` of the original;
4. the exact key set: envelope exactly §3's four keys; body exactly the
   branch's key set (18/18/9/6/6), no more, no fewer — read back via
   `record-datum-size` / `record-datum-key-at`;
5. the exact value-datum species per key (family checks per §§2, 4, 5;
   for §5.1's upstream keys, the `("standing" "measured-nil")` variant);
6. **non-re-admission, at the honest R3 scope — the OWNER DISPOSITION OF
   THE R2 VOID, stated as ruled:** the actual `account-refusal-p` and
   typed `:not-an-admitted-account-object` behavior **cannot be executed
   before the prohibited production package exists**. The **four
   native-predicate non-admission measurements** (the record fails all
   four native admission predicates) are **accepted for this contract
   round**; the **actual Account-predicate and typed-condition tooth is
   moved into the mandatory production gate** (`R4-SURVIVAL-PLAN.md`
   §4(h5)). **No claim that the Account-side tooth already passed is made
   here or anywhere in this lane.**

**§8-P The two S1 STOP cells as POSITIVE records (R3.1-A).** The witness
constructs lawful `"s1-refusal"` records from **BOTH locked S1 STOP cells**
(`DERIVE-CASE` and `DERIVE/2-CASE` under `:macroexpand` — Locked Ruling 2),
using their **actual three string-valued upstream fields** (measured:
`"TermGrammar"` / `"SHARED-OR-CIRCULAR-STRUCTURE"` / `"term-encode"`),
code `EXPANDED-TERM-SHARED-STRUCTURE`, category `PROTOCOL-REFUSAL`, phase
`PERFORM`, derived standing `("standing" "invoked-no-completion-account")`
— each passing proofs 1–5 and **required to satisfy
`account-inspection-record-p`** (§7, at the non-production-validator
scope).

**§8-T The conformance teeth (R3 set + the R3.1-A adversarial list,
reproduced exactly; built and run by the probe seat).** Each refusal tooth
constructs a near-record (or presents a deviant native value) deviating in
exactly one respect and proves the §7 comparison law — or the two-stage
detail validation — refuses it with its exact code and **no raw host
escape**; each positive tooth must construct a lawful fixed-schema record:

*The R3 structural teeth (retained):* wrong **namespace** (e.g.
`("lisp-plus-surface-account-x")`); wrong **path head** (`("kee"
"detail")`); **extra path segment** (`("key" "detail" "surplus")`); wrong
**schema identity**; wrong **schema version**; wrong **species**;
**unknown enum value** and **unknown code** (outside §5.3's five-code set
/ the enumerated native vocabularies); the two
**formerly-unencodable-class positive encodings** (a lawful `"s2-refusal"`
record for a `PROTOCOL-REFUSAL`/`EXPANSION` object and one for an
`INTEGRITY-ALARM` object, `derived-standing`
`("standing" "not-applicable")`, passing proofs 1–5).

*The R3.1-A adversarial list (verbatim from the ruling):*

- **both actual S1 STOP cells** (positive — §8-P);
- **S2 public detail `NIL`** (positive: encodes as
  `("standing" "measured-nil")`, never a validation failure — **and, per
  the R3.2 return, this arm constructs the COMPLETE fixed-schema record**
  with `detail` = `("standing" "measured-nil")` **and proves the record
  satisfies the predicate** — a datum-level check alone is insufficient);
- **S2 public detail integer `42`** (refuses: `native-detail-not-string`);
- **S2 public detail at 1024 and 1025 payload octets** (1024 encodes —
  **as a COMPLETE record satisfying the predicate, per the R3.2 return**;
  1025 refuses: `detail-string-exceeds-ceiling`);
- **a host string containing a non-CD/0 scalar** (refuses:
  `native-detail-not-cd0-scalar-string`);
- **overlong composite detail** (branch 5; refuses:
  `detail-string-exceeds-ceiling`);
- **manifest version `2`** (fails §7 clause 6);
- **invented S1 and S2 dispositions** (fail §7 clause 5 — including the
  deleted `MACROEXPANDED-TO-FIXPOINT`, which is now an *invented* S1
  name);
- **both wrong operation/disposition pairings** (S1 `MACROEXPAND-1` with
  `MACROEXPANDED-REPEATEDLY`; S2 `MACROEXPAND` with `"expanded-once"` —
  fail §7 clause 10);
- **every unlawful upstream standing** (each §2 standing name other than
  `measured-nil` placed in an upstream key — fails the three-member union
  law);
- **provider category or phase drift with an unchanged code name** (fails
  §7 clause 8 — triple comparison, never code-name sets).

— Claude Fable 5 (JURIST, Surface Account /0 opening round; R2 sitting,
R3-normalized, R3.1 repairs), 2026-08-04
