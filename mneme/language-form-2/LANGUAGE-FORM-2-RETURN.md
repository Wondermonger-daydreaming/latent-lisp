# LANGUAGE FORM /2 — CANDIDATE /0 — IMPLEMENTATION RETURN

*Built from the amended work order under owner ruling **AMEND AND IMPLEMENT
LANGUAGE FORM /2 CANDIDATE /0**, 2026-07-27.*

```
central law   A rewrite remembers what changed.
              It does not decide what the change means.
```

**Standing, retained through merge and publication:**

```
candidate implementation
adopted:               no
specification-frozen:  no
stranger audit:        OWED — non-blocking
governing floor:       unchanged; Form /2 joins none
Form /3:               unopened
```

**Merging and publishing this candidate adopts nothing and freezes nothing.**
The stranger-audit debt stays visible and stays owed.

---

## 1. COMMITS

```
work-order base (amended)   aa1026b18e5f595e8bd352c5432e0916802f4755
                            branch language-form-2-work-order
implementation              branch language-form-2-candidate-0
first implementation        92476b85d06c7819c7bdc3b81d941b7e5f07634e
bounded completion          (this document's own commit — C and D through DERIVE/2)
lab main at build time      dc7c11e24ee677d1c1854a33f9313e13340fffab
```

---

## 2. PUBLIC EXPORT LEDGER — 72, reconciled both ways

```
declared exports in package.lisp   72
live externals in the package      72
set-difference, both directions    empty
externals neither fbound nor bound  0
```

| group | count | notes |
|---|---|---|
| grammar constructors | 4 | `replacement-proposal-datum` · `path-datum` · `index-step` · `key-step` — **mint nothing** |
| door 1 | 2 | `try-propose-replacement` · `propose-replacement` |
| door 2 | 2 | `try-apply-replacement` · `apply-replacement` |
| proposal readers | 11 | |
| receipt readers | 15 | includes the two derived projections |
| refusal readers + condition | 15 | includes the 5 CD/0 passthrough readers |
| catalogue | 7 | two lists **derived** from one table |
| policy / grammar / procedure / identity | 16 | |

**No public constructor mints a proposal object, a receipt, or a refusal.** No
`MAKE-*` for any of them exists. **Deliberately not exported:** any proposal-datum
classifier (`try-propose-replacement` is the authoritative one and returns an
inspectable refusal); any path resolver — exporting one would make Form /2 the
de-facto owner of CD/0 addressing, which is CD/0's to add, not Form /2's to
smuggle in.

## 3. THE PROPOSAL / APPLICATION API

```
TRY-PROPOSE-REPLACEMENT  raw CD/0 datum  →  (values PROPOSAL nil)
                                         |  (values nil REFUSAL)
PROPOSE-REPLACEMENT      raw CD/0 datum  →  PROPOSAL | signals

TRY-APPLY-REPLACEMENT    PROPOSAL object →  (values SUCCESSOR RECEIPT nil)
                                         |  (values nil nil REFUSAL)
APPLY-REPLACEMENT        PROPOSAL object →  (values SUCCESSOR RECEIPT) | signals
```

**Three values on both branches of door 2**, so a caller destructuring the result
cannot read a refusal as a successor (NC-35, verified). **No wrapper returns the
successor alone** — a receipt a caller can decline to take is a receipt the layer
does not really produce.

Door 1 never inspects the input's interior: it validates grammar, snapshots, and
mints. **A proposal whose path can never resolve is admitted by door 1 and
refused by door 2** (NC-36, verified) — the proposal is a description a caller
wrote; the application is an encounter with a real datum.

## 4. THE IDENTITY THEOREM, AND ITS ASSUMPTIONS

Three identities (a host's *tag* is not a transformation's *occurrence*):

```
REPLACEMENT-PROPOSAL-IDENTITY   commits input-id · path · expected-old ·
                                replacement · procedure id/version ·
                                proposal occurrence tag · policy id/version
TRANSFORMATION-OCCURRENCE-ID    commits proposal identity · disposition
                                MINTED ONLY ON SUCCESSFUL APPLICATION
TRANSFORMATION-RECEIPT-ID       commits occurrence identity · policy id/version
```

> **THEOREM (narrow).** Over **successful transitions produced by the fixed
> package procedure under the stated preconditions**, exact CD/0 encoding makes
> `OBSERVED-OLD` and `OUTPUT-DATUM-IDENTITY` derivable from the committed
> proposal payload. Omitting them from the identity therefore loses no
> discrimination **among such transitions**.
>
> *(Earlier wording said "lawful successful transitions." Too broad — it reads
> as a claim about every transition the world might call lawful, when the
> guarantee holds only for transitions THIS procedure produced, at THIS version,
> with the preconditions actually checked.)*

**ASSUMPTIONS, and what the theorem does NOT establish:** resilience to a
misversioned procedure · nondeterministic implementation behaviour · internal
object corruption · forged package-internal receipts · persistence-time
integrity.

**A refused application mints no occurrence identity at all** — not null, not
absent-marked; the object does not come into existence (NC-38, verified).
**Distinct tags give distinct proposal identities** (NC-39). **Identical tags give
identical identities — an undetected host error, declared, not repaired** (NC-40).

## 5. RECEIPT-DERIVED-FIELD CONSISTENCY — evidence

The two omitted fields are **derived projections**, recomputed and verified by
the receipt constructor. There is no public receipt constructor, so this is the
only path by which a receipt exists.

```
REQUIRE  observed-old  equal-datum  expected-old
REQUIRE  output-datum-identity  equal-datum  identity(replace(input,path,replacement))
```

**Three planted internal faults prove all three teeth bite** (each reachable only
from inside the package; a gate that has never fired is untested, not passing):

| planted fault | result | code |
|---|---|---|
| wrong stored `observed-old` | **no receipt produced** | `:observed-old-projection-mismatch` |
| wrong stored output identity | **no receipt produced** | `:output-identity-projection-mismatch` |
| altered procedure version | **no receipt produced** | `:procedure-version-mismatch` |

With no fault bound, the same transformation is green — the teeth are not stuck
on.

## 6. SIZING — ORIGINAL, CORRECTED, AND CORRECTED AGAIN

**All three are preserved. The first two are historical evidence and were not
edited to agree with the third.**

```
PRE-AMENDMENT PROBE 1   naive receipt 3.64x  "fits, 1.10x margin"
                        WRONG — a mid-sized fixture, not a maximum
PRE-AMENDMENT PROBE 2   naive receipt 8.00x  131,004 octets, EXCEEDS 65,536
                        magnitude corrected — but it measured EQUAL old and new,
                        i.e. a NO-OP this layer now refuses.  A maximum over
                        INADMISSIBLE inputs is not a maximum.
THIS SUITE, first draft largest measured 24,575 octets, "margin 2.50x"
                        WRONG AGAIN — the "max lawful" fixture used 8,100-char
                        strings, reaching a datum of 8,110 rather than the 16,384
                        ceiling.  A fixture maximum, for the third time in one day.
THIS SUITE, driven      largest measured 49,355 octets · margin 1.24x
```

**The corrected figure matches the arithmetic exactly** (3 × 16,384 = 49,152 plus
headers), which is what tells us the fixture is finally at the ceiling rather
than merely large.

### The measurement table, reported separately and never rolled up

```
fixture                  datum    path    tag  |  proposal  occurrence  receipt
smallest lawful             13      41      8  |      173         214      274
inhabited-ish               61      41     15  |      236         277      337
root path, max lawful    16370       7      8  |    49222       49264    49325
root child, max lawful   16370      41      8  |    49252       49294    49355
max lawful tag              61      41    908  |     1129        1170     1230
max depth (30)              68    1027      8  |     1214        1255     1315
replacement > removed       61      41      8  |     4225        4266     4326
wide record (200)         3100      81      8  |     3304        3345     3405
deep record (20)           251     807      8  |     1184        1225     1285

LARGEST RECEIPT IDENTITY MEASURED   49,355 octets
envelope 65,536 · reserve 4,096 · ceiling 61,440 · margin 1.24x
```

> **NOT a global maximum.** The admissible domain has not been bounded and
> searched. The honest sentence is *"the largest value MEASURED over the
> enumerated fixtures,"* and the suite prints exactly that.

### Path and tag slack — the two ceilings that make the relation falsifiable

```
max encoded path octets    4096   largest measured 1,027 (depth 30)
max occurrence tag octets  1024   largest measured   908
```

Both refuse at door 1 with their own codes (`:path-octets-exceeded`,
`:occurrence-tag-octets-exceeded`), both verified. Without them, an unbounded tag
or path could consume any margin and `slack` would be a hope rather than a number.

**A finding worth carrying:** `EXPECTED-OLD` and `REPLACEMENT` carry **no octet
ceiling of their own** — only the *input* does. What bounds them is the identity
envelope, which is why `:identity-octets-exceeded` is reachable at door 1 at all
(fixture: 40,000-octet expected-old and replacement). This is worth knowing
rather than assuming.

## 7. REBUILD COST AND RESOURCE REFUSALS

**The rebuild is a pure spine reconstruction**: one `make-sequence-datum` per
sequence level on the path, one `make-record-datum` per record level. For the
`deep record (20)` fixture that is **20 record rebuilds**, each re-running CD/0's
`%normalize-record-entries` — re-deriving every key's ValueBytes, re-sorting, and
re-charging the record-key work budget, because `record-datum-fields` strips the
key-bytes cache and there is no public way to keep it.

**⚠ Gap, declared:** rebuild counts are stated **analytically from the path
shape**, not instrumented by a counter in the suite. The identity sizes for deep
and wide record spines *are* measured. A counter would be a small addition and is
not present.

### `:REBUILD-RECORD-KEY-WORK-EXCEEDED` — a genuine false affordance, found and reclassified

**CD/0's default `max-total-record-key-octets` is 1,048,576. Candidate /0's input
ceiling is 16,384. No admitted input can reach the budget**, so no public call can
provoke this code. The suite found it by failing NC-19.

It was **not deleted**, because the handler is real and the ceilings are policy —
a future candidate may raise the input ceiling, or a host may tighten CD/0's
budget, and on that day the reclassification path must already work. It was
**reclassified as `:internal-planted-fault-only`** with a note stating exactly
why, and given a planted fixture. Verified:

```
the CD/0 failure is reclassified under a Form /2 code, not left raw
upstream category   "ResourceRefusal"           PRESERVED
upstream code       "RecordKeyWorkBudgetExceeded" PRESERVED
upstream stage      "host-import"               PRESERVED, not corrected away
```

**The Form /2 code corrects the classification for its caller while preserving
what CD/0 said.** Both facts are true; the reclassification is an added reading,
never an overwrite.

## 8. FLAT HISTORY — the limitation, carried forward

**A receipt is an independently inspectable DIRECTED EDGE from one datum identity
to another.** Given a complete, **externally ordered** sequence, a host may verify
**adjacency** by matching each output identity to the next input identity. The
host supplies completeness. The host supplies order.

**Form /2 does not establish:** completeness of the receipt set · temporal order ·
unique lineage · omission detection · fork ancestry · **authenticity against
receipt fabrication** · an exterior root · durable replay history.

An adversary free to construct can mint a plausible edge between any two data.
**Form /2's answer is a disclaimer, not a defence: a receipt is an ACCOUNT, not an
AUTHENTICATION.** A reader who needs authenticity needs an external anchor or
governing journal machinery — the exterior root a self-contained artifact
provably cannot supply itself. **Candidate /0 does not build it.**

## 9. THE FOUR INHABITED GENEALOGIES — `de-forma-mutata`, 43 checks / 0 failed

**C and D now run the complete path through PUBLIC `DERIVE/2`.** The fixture is
the real public Slice /0/1/2 machinery — one registered schema, one admission
contract, one conclusion, one explicit receiver, and two witnesses of the **same
species, mode and kind** differing only in **subject**. No private
evidence-admission approximation exists anywhere in this program.

**The division of labour, which is the whole point:**

```
Form /2   establishes that A REFERENCE CHANGED.
Form /1   establishes that BOTH DATUMS ARE LAWFUL PETITIONS.
Slice /2  ALONE establishes THE TWO GOVERNED OUTCOMES.
```

**A — STALE PRECONDITION.** Form /2 refuses `:expected-old-mismatch`. **No
successor, and NO RECEIPT EXISTS** — nothing happened, so nothing is accounted.
Input untouched.

**B — STRUCTURAL SUCCESS, FORM FAILURE.** The production head is replaced with a
lawful CD/0 identifier that is not a Form /1 petition head. **Form /2 succeeds and
mints a receipt; Form /1 refuses the successor in its own voice** with
`:not-a-derivation-petition`. Two events, two records, neither contaminating the
other.

**C — CONSEQUENCE-CHANGING REFERENCE REWRITE — COMPLETE.**

```
original petition   support "clearance"      → witness about PLUT-7 (right subject)
                    submitted  → DERIVE/2    → :GRANTED
                    Slice /2 receipt decision  :GRANTED   · claim PRESENT

successor petition  support "wrong-subject"  → witness about PLUT-9 (right species,
                                                mode and kind; WRONG SUBJECT)
                    submitted  → DERIVE/2    → :GOVERNED-REFUSAL
                    Slice /2 receipt decision  :REFUSED   · claim ABSENT

DERIVE/2 invocations across the pair: 2
```

The original **independently** proposes, validates and materializes with no
Form /2 anywhere in its path. The successor **independently validates under
Form /1** — no validation is inherited; Form /1 received a bare datum and owed it
nothing. Verified that Form /2 changed **only** the support reference: the head
and the `schema`, `conclusion` and `receiver` fields are byte-identical.

**The wrong-subject evidence REACHED `DERIVE/2` rather than being filtered** —
neither Form /2 nor Form /1 screened it; it was admitted and then *judged*. That
is the fixture's real content: the governed layer, and only the governed layer,
decided.

**Form /2's receipt says `:REPLACED-AT-PATH` and nothing else** — verified to
assert nothing about change, improvement or preservation.

**D — RESOLVABLE-REFERENCE REWRITE — COMPLETE.** *(Not "repair": that would
assert the successor is better, which this layer may never say.)*

```
original    support "absent-from-context"
            proposes · validates · materializes        (the reference is well-formed)
            submitted → REFUSES BEFORE DERIVE/2
                        :unresolved-support-reference
                        DERIVE/2 invocations: 0 · no outcome · no claim · no basis

successor   support "clearance", present in the SAME sealed context
            independently re-enters Form /1 and materializes
            submitted → every reference resolves → DERIVE/2 invoked
                        DERIVE/2 invocations: 1 · outcome :GRANTED
```

**The distinction the direction asked to be visible is visible:** a *pre-`DERIVE/2`
submission refusal* and a *post-`DERIVE/2` governed result* are different rows,
with different codes, and the refused row has no outcome at all.

**The full lineage prints, every arrow forward:** original inert datum → Form /2
proposal → Form /2 occurrence → Form /2 receipt → successor inert datum → Form /1
proposed → validated → derivation petition → Form /1 submission receipt →
Slice /2 receipt and decision. **The Form /1 submission receipt is verified
DISTINCT from the Form /2 receipt**, and the **transformation receipt is verified
byte-identical after all downstream activity**. No later standing flows backward.

**Every printed identity registers into a census as a side effect of printing**,
so nothing displayed can escape the final discrimination check — verified.

## 10. REFUSAL CATALOGUE — 30 entries, both classes populated

```
catalogue          30
protocol refusals  27
integrity alarms    3
disjoint            yes
partition exact     yes
```

**NC-19 set-difference is empty in BOTH directions**: every declared code was
produced by a fixture, and every produced code is declared.

**Two codes an earlier draft advertised are ABSENT and stay absent:**
`:input-not-a-datum` and `:replacement-not-a-datum`. Both fields live inside a
CD/0 record, where every value is necessarily CD/0 data — a caller cannot put a
non-datum there. They had no reachable fixture. Only the outermost argument can
fail to be a datum: `:proposal-not-a-datum`.

**Reachability is honest:** 26 codes are `:public-api`; `:rebuild-record-key-work-exceeded`
is `:internal-planted-fault-only` for the measured reason in §7; the 3 integrity
alarms are `:internal-planted-fault-only` by construction.

## 11. NEGATIVE CONTROLS AND INSTRUMENTS

```
form2-selftest                 86 checks / 0 failed   exit 0   (all retained)
de-forma-mutata                43 checks / 0 failed   exit 0   (22 -> 43)
transcript reconciliation      CLEAN (counts derived from RENDERED VERDICT LINES)
verdict-liveness sweep         86/86 forced red · 0 survived · 0 collateral
export census                  72 live == 72 declared · 0 neither fbound nor bound
identity round trip            holds
multi-axis collision census    81 fixtures · 0 collisions
merged-field boundary fault    caught — adjacent-field boundary shift changes the identity
public-reader aliasing         detail returns a FRESH string; mutating it cannot edit the refusal
unexpected-condition escape    a CD/0 host failure escapes as itself
```

**THE LIVENESS SWEEP LICENSES EXACTLY ONE SENTENCE:** *every rendered verdict is
connected to the suite's failure result.* **It is NOT predicate soundness.** Both
of Form /1's known hollow checks would have passed a sweep of this shape, because
a hollow check whose result is inverted still flips the suite red.

**The multi-axis census carries a planted merged-field-boundary fault** because a
one-axis-at-a-time suite returns a clean sheet on a broken layer
(`"a"‖"bc" = "abc" = "ab"‖"c"`) — a measured finding from this lab's own Form /1
work, not a hypothetical.

**Planted-fault classification:** 4 planted faults, all internal, all
`:internal-planted-fault-only` — three receipt-projection/version alarms and one
CD/0 resource reclassification. Each dies at its intended tooth; each is green
again with the fault unbound.

## 12. UNCHANGED PREDECESSOR FLOORS, AND THE NON-MODIFICATION PROOF

```
verify-form-floor.sh        3 floors ·  199 checks / 0 failed   exit 0
verify-language-floor.sh   11 floors ·  654 checks / 0 failed   exit 0
verify-all.sh               6 / 6 suites green                  exit 0
```

**Form /2 joins none of them.** All three name Form /2 nowhere.

```
git diff --name-only aa1026b1 -- language-form-0 language-form-1
                                 language-slice-0/1/2 kernel0 canonical-datum
                                 language-surface-0 verify-*.sh
  →  EMPTY

Form /0 subtree  e4f3512396f788b28221ffda9ab8df94e4cb1299  == the audited target
Form /1 subtree  da16ebaa542599cbc31566718c2711fecec24baa  == the merged tree
```

**Entrance gates:** no `lisp-plus-form0::` or `lisp-plus-form1::` in any code
position (EG-2) · no broad `(ERROR () …)` handler (EG-6) · no `EVAL`, `COMPILE`,
`READ-FROM-STRING` or caller `FUNCALL` (EG-4) · `octets-to-hex` appears **only**
inside `render-identity-hex`, never in a composition path (EG-9) · root
`_staging/` untouched.

Form /2 source loads **CD/0 only**. The application loads Form /1 as a **client**.

## 13. WHAT CANDIDATE /0 EARNED

- One exact, bounded structural transformation over inert canonical data, with a
  receipt that names exactly what changed and claims nothing else.
- **A demonstrated separation between a structural event and the standing of what
  it produces** — Candidate B: the rewrite succeeds, the result is refused, and
  neither record contaminates the other.
- A successor that re-enters proposal **as a stranger to its own history**.
- **The no-mutation guarantee true by substrate, not by discipline** — CD/0
  exposes no mutator, so the pure rebuild is the only possible shape.
- A pre-measured resource ceiling with **three superseded measurements preserved
  beside the standing one**, so the next candidate inherits the arithmetic rather
  than the accident.
- **Two false affordances found and honestly disposed of** — two codes deleted,
  one reclassified with its reason measured and stated.
- **A demonstrated governed-outcome difference across a rewrite** (§9, C) —
  `:GRANTED` vs `:GOVERNED-REFUSAL` from public `DERIVE/2`, two invocations, both
  Slice /2 receipts retained, with Form /2 asserting none of it.
- **A demonstrated pre-`DERIVE/2` refusal and a later governed result** (§9, D),
  distinguishable and separately recorded.

## 14. WHAT IT EXPLICITLY DID NOT EARN

- **Any claim of semantic preservation, equivalence, or correctness. Ever.**
- Any claim that a successor is a lawful program.
- Adoption, specification freeze, or a place on a governing floor.
- **Instrumented rebuild counts** (§7) — stated analytically, not counted. No
  production observer or instrumentation seam was added to obtain them, because
  that would change Form /2's semantic path to satisfy a test.
- Authenticity, completeness, order or unique lineage of any receipt set (§8).
- Detection of a host that declares an `expected-old` it has no business
  declaring. **Form /2 checks that the declaration MATCHES; it cannot check that
  the declarer was entitled to make it.** This is NC-31B's shape one layer down,
  and it is declared here rather than discovered at review.
- A stranger audit. **OWED**, and not pre-satisfied by Form /0's or Form /1's,
  each of which binds one exact subject tree.

## 15. RECOMMENDATION

```
READY FOR OWNER REVIEW — FORM /2 CANDIDATE /0
```

No architectural contradiction was found. **The Slice /2 gap named in the first
return is CLOSED**: Candidates C and D now run the complete path through public
`DERIVE/2`, with two governed outcomes that differ because the resolved evidence
differs. One gap remains open by decision, not by omission — instrumented rebuild
counts, which would require an instrumentation seam in the semantic path.

---

*Built by Claude Opus 5 (1M context), 2026-07-27, from the amended work order at
`aa1026b1`. Every green here is self-consistency certification by the family that
wrote the layer. The stranger audit is owed.*
