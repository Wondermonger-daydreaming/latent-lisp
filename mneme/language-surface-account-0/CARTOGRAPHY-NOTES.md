# Surface Account /0 — Opening Cartography: method, counts, and limits

**Surveyor:** CARTOGRAPHER (Claude Opus 5, 1M context).
**Measured:** 2026-08-04, on host `gauss-VJFE69F11X-B0221H`.
**Implementation:** `SBCL 2.4.6` (`(lisp-implementation-type)` = `"SBCL"`,
`(lisp-implementation-version)` = `"2.4.6"`, printed by the measuring image itself).
**OS:** `Linux gauss-VJFE69F11X-B0221H 7.0.0-28-generic #28~24.04.1-Ubuntu SMP
PREEMPT_DYNAMIC Wed Jul 1 15:50:57 UTC 2 x86_64 x86_64 x86_64 GNU/Linux`.
**Workplace:** worktree `/home/gauss/Desktop/worktrees/surface-account-0`, branch
`surface-account-0-opening`, subject root `experiments/latent-lisp/`.

Companion documents in this directory: `OPENING-BASE-AND-CUSTODY.md` and
`PREDECESSOR-IDENTITIES.md` (WARDEN, custody). This document covers **only** the
API cartography and answers only for it.

**Nothing in this document is independently verified.** It is one surveyor's
measurement on one host in one session, reproducible by re-running the commands
quoted below. No expectation from the commission was copied into a findings cell:
every value here was read out of command output first and compared to the
commission afterwards.

---

## 1. Deliverables written by this survey

| File | Rows (excl. header) | Columns |
|---|---|---|
| `PROVIDER-API-MATRIX.tsv` | 178 | 13 |
| `READER-PROVENANCE-MATRIX.tsv` | 85 *(73 at first survey; 12 `request-stored` rows added R0 post-review — see the §10 amendment)* | 7 |
| `SEVEN-HEAD-MANIFEST-CANDIDATE.tsv` | 7 | 11 |

All three are tab-separated with a header row. No cell is empty; absence is
written as an explicit word (`unavailable`, `not-applicable`,
`not-a-nullary-declaration`, `no additional observation`).

---

## 2. The load path — the documented one, unmodified

The canonical clean-checkout load command was **read first**
(`mneme/load-lisp-plus.sh`, and `lisp-plus.asd`'s header), then run as
documented, from the subject root:

```
$ bash mneme/load-lisp-plus.sh
== toolchain: SBCL 2.4.6 (supported: 2.4.6/Linux; nothing else tested) ==
...
== lisp-plus loaded: 19 principal packages ==
== load transcript is clean: 0 warnings, 0 redefinitions, 0 undefined variables ==
== LOAD OK. Loading is not adoption. ==
```

The three measuring runs then reproduced **exactly that script's own sbcl
invocation** — the same four `--eval` forms, in the same order — and appended
`--load <probe>`:

```
$ sbcl --noinform --non-interactive \
    --eval '(require :asdf)' \
    --eval '(require :sb-posix)' \
    --eval "(asdf:initialize-source-registry '(:source-registry (:directory \"$ROOT\") :inherit-configuration))" \
    --eval '(asdf:load-system "lisp-plus")' \
    --load <probe.lisp>
```

where `$ROOT` is the worktree's `experiments/latent-lisp`. Nothing was loaded
into any long-lived image; every measurement ran in a **fresh child SBCL** that
exited immediately after printing. Nothing was written into any predecessor
directory. **No predecessor file was edited, at any point, for any reason.**

**Operation-check first (a standing lab scar: the `sbcl` on PATH may be a
wrapper).** Before trusting any longer run, a trivial invocation printed the
implementation identity through the same binary that would do the measuring:

```
$ sbcl --noinform --non-interactive \
    --eval '(progn (princ (lisp-implementation-type)) (princ " ") (princ (lisp-implementation-version)) (terpri))'
SBCL 2.4.6
```

`load-lisp-plus.sh` performs the same check internally and fails closed on any
version other than 2.4.6; it passed.

---

## 3. What was enumerated, and what was not

`do-external-symbols` was run on **exactly two packages** —
`LISP-PLUS-SURFACE1` and `LISP-PLUS-SURFACE2` — as the commission's opening
discovery authorises. No other package was enumerated, listed, or scanned. No
`::` access appears anywhere in any probe file. No `:use` of a provider package
occurs anywhere. No MOP was used.

Three narrow things were done that are **not** enumeration and are named here
so they are challengeable rather than buried:

1. **Seven targeted `find-symbol` calls** on the seven commissioned head names
   (five in `LISP-PLUS-SURFACE0`, two in `LISP-PLUS-SURFACE2`), each by exact
   name, to record export status and `macro-function` non-nil. This reads seven
   named symbols; it does not enumerate `LISP-PLUS-SURFACE0`.
2. **`LISP-PLUS-CD0:MAKE-IDENTIFIER-DATUM`**, a qualified external symbol of a
   third package, was called to build the occurrence tags the providers'
   request doors require. Both providers refuse a string tag
   (`:OCCURRENCE-TAG-NOT-IDENTIFIER`, measured), so a receipt cannot be minted
   without it; the providers' own self-tests build tags exactly this way.
3. **`sb-introspect:function-lambda-list`** was used to read lambda lists.
   This is implementation reflection, not provider API, and it is why the
   matrix carries **two** arglist columns — see §6.

---

## 4. The counts

Measured in one image, printed by the measuring code itself:

| Quantity | Measured |
|---|---|
| `LISP-PLUS-SURFACE1` external symbols | **80** |
| `LISP-PLUS-SURFACE2` external symbols | **98** |
| Shared **print-names** | **54** |
| Shared print-names that are the **same symbol** (`EQ`) | **0** |
| `LISP-PLUS-SURFACE1`-only print-names | 26 |
| `LISP-PLUS-SURFACE2`-only print-names | 44 |
| External symbols whose home package ≠ exporting package | **0** (both packages) |

**The commission's "54 shared exported print-names" is confirmed by independent
count.** The zero on the `EQ` row is the operative fact: *fifty-four shared
names, zero shared identities.* Neither package imports or inherits a single
external symbol; each owns all of its own.

Kinds, determined by observation (`macro-function`, `fboundp`, `find-class`,
`typep … 'generic-function`, `typep … 'structure-class`, `subtypep … 'condition`,
`boundp`/`constantp`) and corroborated against `surface1.lisp` / `surface2.lisp`:

| Kind | Surface /1 | Surface /2 |
|---|---|---|
| function | 78 | 92 |
| generic-function | 1 | 1 |
| macro | 0 | 2 |
| condition-type | 1 | 2 |
| struct-class (exported type name) | 0 | 1 |
| variable / constant / deftype | 0 | 0 |

Docstrings are present on **9 of 80** Surface /1 externals and **17 of 98**
Surface /2 externals.

---

## 5. The commission's expectation table, remeasured

| Property | Commission said | **Measured** | Agreement |
|---|---|---|---|
| Closed heads, Surface /1 | 5 | 5 (`KNOWN-SURFACE-CONSTRUCTS`, all namespace `LISP-PLUS-SURFACE0`) | agrees |
| Closed heads, Surface /2 | 2 | 2 (`KNOWN-SURFACE2-CONSTRUCTS`) | agrees |
| Grammar/procedure/policy, Surface /1 | `4 / 4 / 1` | **`4 / 4 / 1`** | agrees |
| Grammar/procedure/policy, Surface /2 | `3 / 3 / 1` | **`3 / 3 / 1`** | agrees |
| Operations | `:macroexpand-1`, `:macroexpand`, same both | `(:MACROEXPAND-1 :MACROEXPAND)` both | agrees |
| Public `verify-receipt` | S1 absent, S2 present | absent from S1's 80; present in S2's 98 | agrees |
| S1 keeps upstream refusal category/code/stage | yes | `EXPANSION-REFUSAL-UPSTREAM-{CATEGORY,CODE,STAGE}` present in S1, **absent** in S2 | agrees |
| Neither exposes a receipt-stored grammar identity | yes | no `…-RECEIPT-GRAMMAR-IDENTITY` in either package | agrees |
| Native receipt identities inhabit different domains | yes | S1 segments `:receipt`/`:occurrence`/`:request` under `lisp-plus-surface1`; S2 segments `:surface2-receipt`/`:surface2-occurrence`/`:surface2-request` under `lisp-plus-surface2` | agrees |
| `…-RECEIPT-PROCEDURE/POLICY-IDENTITY` ignore the receipt | yes | **confirmed twice** — see §7 | agrees |

Nothing in the commission's fact table was contradicted.

---

## 6. `arglist-if-publicly-documented` — why there are two columns

The requested column is `arglist-if-publicly-documented`. Only 26 of the 178
external symbols carry a docstring, so filling that column with an
`sb-introspect` reading would have quietly renamed an *image observation* into
a *published contract*. The matrix therefore carries both:

- **`arglist-if-publicly-documented`** — the lambda list **only** where the
  symbol also carries a docstring; otherwise the explicit
  `unavailable-no-public-docstring`.
- **`arglist-observed-in-image`** — the lambda list as read by
  `sb-introspect:function-lambda-list` in the loaded child, always populated.

**Traced, and the contested step is shown.** `sb-introspect`'s *second* value
was `NIL` for every symbol in this tree, which naively reads as "lambda list
unknown". Probing one known case showed the primary value is nonetheless
correct:

```
PROBE1 ll=(LISP-PLUS-SURFACE2::BINDING &BODY LISP-PLUS-SURFACE2::BODY) known=NIL
PROBE2 fdef-ll=(LISP-PLUS-SURFACE2::BINDING &BODY LISP-PLUS-SURFACE2::BODY)
```

so the primary value is used and the second value is ignored. The first run of
the enumerator gated on that second value and printed `()` for all 178 symbols;
that run was discarded, not repaired in prose.

---

## 7. The identity trap — shown, not asserted

The commission states that in **both** providers
`expansion-receipt-procedure-identity` and `expansion-receipt-policy-identity`
ignore the receipt and consult the live provider declaration. This survey
confirmed it two independent ways.

**(a) Source, read directly:**

```
surface1.lisp:1073  (defun expansion-receipt-procedure-identity (r)
surface1.lisp:1074    (declare (ignore r)) (expansion-procedure-identity))
surface1.lisp:1075  (defun expansion-receipt-policy-identity (r)
surface1.lisp:1076    (declare (ignore r)) (expansion-policy-identity))

surface2.lisp:786   (defun expansion-receipt-procedure-identity (r)
surface2.lisp:787     (declare (ignore r)) (surface2-procedure-identity))
surface2.lisp:788   (defun expansion-receipt-policy-identity (r)
surface2.lisp:789     (declare (ignore r)) (surface2-policy-identity))
```

**(b) Experiment, through the public API only, with a contrast arm.** A
genuinely receipt-stored field must reject a non-receipt. A live-declaration
reader will not. Each accessor was called on `NIL`, on `42`, and on the string
`"not-a-receipt"`:

| Call | Outcome (all three arguments) |
|---|---|
| `S1:EXPANSION-RECEIPT-PROCEDURE-IDENTITY` | **returned the live S1 procedure identity** |
| `S1:EXPANSION-RECEIPT-POLICY-IDENTITY` | **returned the live S1 policy identity** |
| `S1:EXPANSION-RECEIPT-PROCEDURE-VERSION` | `SIMPLE-TYPE-ERROR` |
| `S2:EXPANSION-RECEIPT-PROCEDURE-IDENTITY` | **returned the live S2 procedure identity** |
| `S2:EXPANSION-RECEIPT-POLICY-IDENTITY` | **returned the live S2 policy identity** |
| `S2:EXPANSION-RECEIPT-PROCEDURE-VERSION` | `SIMPLE-TYPE-ERROR` |

The version accessors are real struct readers; the identity readers are not
readers at all. This is why every such cell in
`READER-PROVENANCE-MATRIX.tsv` is labelled `provider-current-declaration`
and never `receipt-stored`.

**No provider file was redefined to test this**, and no dynamic redefinition was
attempted: the public API exposes no way to move a provider's declaration, and
reaching a private definition would require `::`, which is forbidden. The
non-receipt-argument experiment is the substitute, and it is decisive for the
same reason — it isolates the argument as causally irrelevant.

---

## 8. Cross-application teeth — the finding the commission did not name

Every one of the 54 shared print-names that is a one-argument reader was applied
to **the other provider's** object of the corresponding sort (receipt to
receipt, occurrence to occurrence, request to request, refusal to refusal,
catalog entry to catalog entry, identity to identity), in both directions. 108
cross-applications:

| Outcome | Count |
|---|---|
| `TYPE-ERROR` — misuse caught | **72** |
| accepted the foreign object without error | **26** |
| — of which: a predicate correctly answering `NIL` (safe by design) | 8 |
| — of which: **returned a substantive, plausible, wrong value** | **18** |
| not a one-argument reader, not tested | 10 |
| *total cross-applications attempted* | *108* |

The 18 substantive silent successes fall on **9 distinct print-names**, each
exercised in both directions:

| Print-name | Why it does not fail |
|---|---|
| `EXPANSION-RECEIPT-PROCEDURE-IDENTITY` | ignores its argument; returns the **reader's own** live declaration |
| `EXPANSION-RECEIPT-POLICY-IDENTITY` | same |
| `REFUSAL-CATALOG-ENTRY-CODE` / `-CLASS` / `-PHASE` / `-REACHABILITY` / `-NOTE` | untyped positional list accessors (`first`…`fifth`) in **both** providers — catalog entries are plain lists, not structs |
| `IDENTITY-OCTETS`, `RENDER-IDENTITY-HEX` | thin CD/0 delegates; provider-agnostic by construction |

This is the sharpest operational consequence of "shared print-name ≠ shared
identity": **an adapter that relies on type errors to catch a provider mix-up
gets an error in 72 of the 98 one-argument cross-applications, a correct `NIL`
in 8, and a silent wrong answer in 18.** The two identity readers are the worst of them — cross the
providers and the answer is not merely wrong, it is *fluent*: S1's accessor on
an S2 receipt returns S1's own current procedure identity, with no signal.

Two further disjointness measurements, in the same spirit:

- `(subtypep 'LISP-PLUS-SURFACE2:SURFACE2-EXPANSION-REFUSED
  'LISP-PLUS-SURFACE1:EXPANSION-REFUSED)` → `NIL`, and a `handler-case` for the
  Surface /1 condition did **not** catch a Surface /2 refusal.
  (`SURFACE2-NOT-AN-OUTCOME` *is* a subtype of `SURFACE2-EXPANSION-REFUSED`.)
- `LISP-PLUS-SURFACE2:VERIFY-RECEIPT` on a genuine Surface /1 receipt
  **signalled** `SURFACE2-EXPANSION-REFUSED`. It did not return a verdict. There
  is no cross-provider verification and none may be inferred.

---

## 9. Two same-name readers whose **values** differ in type

`EXPANSION-RECEIPT-DISPOSITION` is one of the 54 shared print-names. On a
receipt minted this session:

- Surface /1 returned the **keyword** `:MACROEXPANDED-ONE-STEP`
- Surface /2 returned the **string** `"expanded-once"`

Same print-name, same argument position, different value *type*. Any projection
that treats `disposition` as one column across both providers is normalising two
domains into one and must say so.

A second shape divergence: `KNOWN-SURFACE-CONSTRUCTS` (S1) returns entry objects
read through `SURFACE-CONSTRUCT-ENTRY-NAME` / `-NAMESPACE` / `-IDENTITY`, while
`KNOWN-SURFACE2-CONSTRUCTS` (S2) returns bare `(namespace name)` lists and S2
exports no construct-entry accessors at all.

---

## 10. The provenance vocabulary — extended by owner ruling (Locked Ruling 5)

The commission's original vocabulary was five labels: `receipt-stored`,
`occurrence-stored`, `provider-current-declaration`,
`account-derived-check`, `unavailable`. **The R1 owner adjudication (Locked
Ruling 5) extends it with five first-class labels** — `request-stored`,
`refusal-record-stored`, `condition-stored-reference`,
`provider-recomputation`, `provider-derived-projection` — and the matrix
now carries them bare. *Historical note, kept once as the ruling directs:
these labels originated in this survey as `OUT-OF-VOCABULARY:` flags,
raised rather than force a false five-label fit; the fresh-context review
(F3) then showed the flagged census under-counted by construction; the
owner's ruling settles the vocabulary.*

**The result is 25 classified TSV rows — never "25 atomic facts"** (the
ruling's own phrasing): several rows group accessor families (version
trios, datum/identity pairs), so a row is a classification of what an
accessor family reads, not a world-fact count. The `measured-this-session`
column preserves, per row, **which rows were value-exercised and which
merely enumerate public accessors.**

| Label | Rows | What it names |
|---|---|---|
| `refusal-record-stored` | 9 | Fields frozen in a **native refusal record** — a third native artifact. A refusal is not a receipt and not an occurrence: it is the *alternative* outcome, unreachable from a receipt. Surface /1's upstream category/code/stage live here. |
| `request-stored` | 12 | Fields frozen in a **native request record** — a fourth native artifact, read by the ten `EXPANSION-REQUEST-*` externals each provider exports. *(Added R0 post-review — see the amendment note.)* |
| `condition-stored-reference` | 2 | `EXPANSION-CONDITION-REFUSAL`, both providers: **the carrying relation is borne by the condition, not the refusal record** (the ruling's own adjudication; these two rows moved out of `refusal-record-stored`, which is why that count is 9, not the R0 flag's 11). |
| `provider-recomputation` | 1 | `LISP-PLUS-SURFACE2:VERIFY-RECEIPT`'s output — authoritative standing per Locked Ruling 6: *bounded re-derivation of stored source-form and expanded-form identity projections from stored datums; independent of live grammar/procedure/policy declarations.* Its continued `T` after redefinition (Control 6) demonstrates that declaration-independence. Not authentication. |
| `provider-derived-projection` | 1 | `LISP-PLUS-SURFACE2:DERIVE-SEAT-OUTCOME` and the `SEAT-OUTCOME-*` readers, derived from caller-supplied events rather than from an expansion artifact. |

The matrix also carries a `bearer` column naming, for every row, the exact
artifact (or live image) the value is read from, so the provenance label
can be checked rather than trusted.

Distribution over all 85 rows: `receipt-stored` 30,
`provider-current-declaration` 16, `request-stored` 12,
`refusal-record-stored` 9, `account-derived-check` 6, `unavailable` 6,
`occurrence-stored` 2, `condition-stored-reference` 2, and one each of
`provider-recomputation` and `provider-derived-projection`.

**Amendment, R0 post-review (2026-08-04).** The fresh-context review
(`FRESH-CONTEXT-REVIEW.md` F3) caught that the first survey's census was
under-counted **by construction**: the request-borne facts were outside the
matrix entirely, and the one place the shipped probe labelled a request-borne
fact at all, it labelled it upward into `receipt-stored` — the exact laundering
this section argues against, applied to a fourth artifact instead of the third.
Cure applied: twelve `request-stored` rows added (six per provider — the
version trio and the datum/identity pair grouped, the predicate excluded as an
admission instrument rather than a fact), the probe's six request-field labels
corrected at source, one further self-caught label defect fixed in the same
pass (the probe's disposition line read the **receipt** accessor while its
label said `occurrence-stored`; label corrected to match the bearer actually
read), and every citation of the 13-fact census updated to 25. *Entered by
JURIST (Claude Fable 5) at the chair's direction, in CARTOGRAPHER's document;
the original count was the surveyor's honest read of the rows it had — the
defect was structural (missing rows), not observational (wrong cells).*

---

## 11. The seven heads

All seven were confirmed in a loaded child image: `find-symbol` status
`:EXTERNAL` in the stated package, and `macro-function` non-nil.

| Head key | Owner | `macro-function` | Lambda list (observed) |
|---|---|---|---|
| `LISP-PLUS-SURFACE0:DEFINE-JUDGMENT-SCHEMA` | Surface /0 | non-nil | `(VARIABLE &BODY BODY)` |
| `LISP-PLUS-SURFACE0:DEFINE-ADMISSION-CONTRACT` | Surface /0 | non-nil | `(VARIABLE &BODY BODY)` |
| `LISP-PLUS-SURFACE0:DEFINE-SLICE2-SCHEMA` | Surface /0 | non-nil | `(VARIABLE &BODY BODY)` |
| `LISP-PLUS-SURFACE0:DERIVE-CASE` | Surface /0 | non-nil | `((CLAIM RECEIPT) OPERATION &BODY ARMS)` |
| `LISP-PLUS-SURFACE0:DERIVE/2-CASE` | Surface /0 | non-nil | `((CLAIM RECEIPT DERIVATION-BASIS) OPERATION &BODY ARMS)` |
| `LISP-PLUS-SURFACE2:WITH-OUTCOME` | Surface /2 | non-nil | `(BINDING &BODY BODY)` |
| `LISP-PLUS-SURFACE2:MATCH-OUTCOME` | Surface /2 | non-nil | `(VAR &BODY CLAUSES)` |

The seven head keys were asserted unique in code (`total=7 unique=7 ok=YES`).

**A structural asymmetry the manifest must not flatten.** For the first five
rows the head owner (`LISP-PLUS-SURFACE0`) and the native observer
(`LISP-PLUS-SURFACE1`) are **different packages**, and the five print-names are
**not** external symbols of either provider (measured). For the last two, owner
and observer are **the same package**: `WITH-OUTCOME` and `MATCH-OUTCOME` appear
in `PROVIDER-API-MATRIX.tsv` as Surface /2 externals in their own right. They are
not external symbols of `LISP-PLUS-SURFACE1` (measured).

**Version standing, preserved as an absence.** Surface /0 declares no
macro-language version. Surface /1's `4 / 4 / 1` versions its **observer/codec
machinery**; it does not version-bind the five Surface /0 macro definitions, and
this survey found nothing that would let a later redefinition of a Surface /0
macro be detected by rechecking a Surface /1 procedure binding. Surface /2's
`3 / 3 / 1` likewise versions its own observer/codec machinery; its two heads are
declared in `KNOWN-SURFACE2-CONSTRUCTS`, but no macro-language version is
declared for the head definitions themselves. Every row of the manifest candidate
carries this in its `version-standing` column, and `account-owned-authority`
reads `proposed, none exists in accepted tree` on all seven — because none does.

---

## 12. What could not be determined, and why

- **Whether a provider's declaration can move at runtime.** Not tested. The
  public API exposes no mutator, and reaching a private definition would require
  `::`. The identity trap was therefore established by source reading plus the
  irrelevant-argument experiment (§7), not by redefinition. *An account that
  wants to claim "the declaration did not move between minting and inspection"
  cannot get that from either provider's public surface.*
- **The internal grammar of any native identity.** The hex renderings quoted
  here are diagnostic only — the providers' own source says so of
  `RENDER-IDENTITY-HEX` — and were used solely to observe that the two providers'
  domain segments differ. No identity was decoded, normalised, or
  reverse-engineered, and none should be.
- **Whether any of the 26 silent cross-applications is *reachable* in a
  realistic account.** Reachability is a design question about an architecture
  that does not exist yet. This survey establishes only that the type system
  will not stop it.
- **`account-derived-check` rows are mostly unpopulated by measurement**, because
  there is no account. Where a check was computable today (procedure version
  stored vs live, operation vs declared operations) it was run and recorded; the
  manifest-membership check has no manifest to run against and is marked
  `not measured -- no account manifest exists yet`.
- **Docstring text was not harvested**, only presence.
- **Nothing here speaks to conformance, adoption, standing, or correctness.**
  Loading is not adoption; enumeration is not endorsement; a measured API is not
  a governed one.

---

## 13. Reproduction

Raw outputs, probe sources, and the TSV builders are in this session's staging
area (not in the tree):

```
<staging>/cartography/enumerate.lisp     -> raw-enumeration.txt   (178 SYM rows, counts, head checks)
<staging>/cartography/probe.lisp         -> raw-probe.txt         (declarations, identities, the trap, receipts)
<staging>/cartography/probe2.lisp        -> raw-probe2.txt        (refusal shapes, condition disjointness)
<staging>/cartography/probe3.lisp        -> raw-probe3.txt        (108 cross-applications)
<staging>/cartography/build_tsv.py, build_tsv2.py  -> the three TSVs
```

Every cell in the three TSVs derives from one of those four raw files or from a
quoted line of `surface1.lisp` / `surface2.lisp`. Where a claim is compressed
rather than shown, it says so.

— CARTOGRAPHER, opening survey, Surface Account /0
— Claude Opus 5 (1M context), 2026-08-04
