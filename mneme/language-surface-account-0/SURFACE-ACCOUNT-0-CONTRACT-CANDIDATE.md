# Surface Account /0 — Contract Candidate

**For the recommended lineage:** `NATIVE-COMPOSITE SUCCESSOR LAW RECOMMENDED`
(`ARCHITECTURE-DOCKET.md` §6): a native-delegating composite front door
implemented in a future governed round (Part I), plus the complete
conditional contract for the Account-owned mint that the governed Surface
Account /1 successor would implement for new heads (Part II). Nothing in
this document is implemented. Every name is a proposal, not a pre-authorized
export.

**Author:** Claude Fable 5 (JURIST seat). Measurement seats: CARTOGRAPHER,
FABER, WARDEN (Claude Opus 5). Same-family cross-checks, not an independent
audit. **R1 amendments** per the owner adjudication
(`OWNER-ADJUDICATION-R0-AND-R1-COMMISSION.md` — Sections A, B, C, D and
Locked Rulings 2, 5, 6); **R2 amendments** per
`OWNER-ADJUDICATION-R1-AND-R2-COMMISSION.md` (Sections A, B, C, D, F —
the CD/0 schema is now authoritative in
`CD0-INSPECTION-RECORD-SCHEMA.md`); **R3 amendments** per
`OWNER-ADJUDICATION-R2-AND-R3-COMMISSION.md`; **R3.1 amendments** per
`OWNER-ADJUDICATION-R3-AND-R3.1-COMMISSION.md` (Door-1 ownership RESTORED;
detail totality; exact identity law); per-change record in
`R1-AMENDMENT-LOG.md` (R1, R2, R3, and R3.1 sections).

**Claims ceiling.** This is a contract *candidate* returned for owner review.
It claims design completeness relative to the commission's checklist and
nothing else.

## I.0 The pure-projection law (adopted verbatim from the R1 adjudication, Section A)

> - Door 1 may construct one sealed composite routing request.
> - Door 2 delegates exactly once and returns the exact native receipt plus
>   expanded host form.
> - A try door returns the exact native retained refusal, or a sealed
>   composite pre-delegation refusal where delegation never occurred.
> - The composite mints no completed receipt, occurrence, expansion-account
>   identity, or competing native-domain identity.

**What the composite DOES construct, said explicitly:** sealed composite
**routing requests** (Door 1) and sealed composite **pre-delegation refusal
records** (any door, where delegation never occurred). These are the
composite's only artifacts. The unqualified sentence "the composite mints
nothing" is **deleted from this contract** — it was one word too strong: the
composite constructs the two artifact kinds above; what it never does is
mint a completed receipt, an occurrence, an expansion-account identity, or
any identity in a native domain.

---

# PART I — The composite front door (the /0 production candidate)

## I.1 Closed manifest law

**Content.** Exactly the seven unique head keys of
`SEVEN-HEAD-MANIFEST-CANDIDATE.tsv`, with the three provenance roles carried
as three separate columns on every row, never merged:

| Role | Rows 1–5 | Rows 6–7 |
|---|---|---|
| Head/macro owner | `LISP-PLUS-SURFACE0` | `LISP-PLUS-SURFACE2` |
| Native observer / codec dependency | `LISP-PLUS-SURFACE1` (public API only) | `LISP-PLUS-SURFACE2` (same package as owner — a measured asymmetry the manifest states rather than flattens; `CARTOGRAPHY-NOTES.md` §11) |
| Account-owned authority | the manifest, routing law, and projection schema proposed here — none exists in the accepted tree today | same |

**Proposed manifest identity and version — none exists today.** The manifest
is a new Account-owned authority. Proposal: a CD/0-style identifier datum
with domain `lisp-plus-surface-account`, path `(manifest)`, and **version 1**;
the composite's projection schema likewise carries
`(schema account-inspection-record)` **version 1**. Both are minted (as
declarations, not receipts) by the production round, and **they never
move** (R3-C): a governed successor **introduces its own distinct
declarations** with their own identities and versions — it does not move,
increment, or rebind /0's. No identity or version value in this paragraph
exists yet; they are named so the production round has an exact target and
so lifecycle step 5 has something to fail closed against.

**Routing is an explicit closed table.** The seven rows are a compile-time
constant; head resolution is an `ECASE`-equivalent over the seven exact
symbols (stored as symbols at load time; membership tested by `EQ`, so a
same-print-name foreign symbol fails — the Control 1 shape). There is no
registry, callback, method addition, package scan, `defgeneric` seam, or
"accept any macro" fallback. A duplicate key found at manifest construction
is an integrity alarm, not first-row-wins (Control 3 shape).

**Version binding without pretence.** The manifest binds, per row, the
*inspected* predecessor versions (S1 `4/4/1`, S2 `3/3/1`) as
**observer/codec-machinery versions of the delegate** — never as versions of
the five Surface /0 macro definitions, and never as evidence that a native
engine mints the composite's projection. Surface /0's macro-language-version
**absence is a stored fact of the manifest** (an explicit
`:no-macro-language-version-declared` standing on rows 1–5, and on rows 6–7
for the head definitions themselves), not an empty cell. Consequence,
carried as a claim limitation everywhere: **the composite cannot claim that
rechecking any module version detects later redefinition of a head macro**
(Control 6; `REFUSAL-AND-CONDITION-JURISDICTION.md` §5).

## I.2 The public surface — two action doors, two try doors, one inspector, two condition species

Proposed names (package name itself a proposal: `LISP-PLUS-SURFACE-ACCOUNT`):

```lisp
(account-request-expansion source-form operation occurrence-tag)
  => account-request                                  ; Door 1: constructs the
                                                      ; sealed routing request
(account-perform-expansion account-request)
  => native-receipt, expanded-host-form               ; Door 2: delegates exactly
                                                      ; once; returns the EXACT
                                                      ; native receipt (pure
                                                      ; projection law, I.0)
(account-try-request-expansion source-form operation occurrence-tag)
  => request-or-nil, refusal-or-nil                   ; refusal position: exact
                                                      ; native retained refusal,
                                                      ; or sealed composite
                                                      ; pre-delegation refusal
(account-try-perform-expansion account-request)
  => native-receipt-or-nil, expanded-form-or-nil, refusal-or-nil
(inspect-account object)
  => account-inspection-record                        ; the ONE inspector
(account-refusal-p object) => boolean                 ; Account-owned public
                                                      ; predicate for the
                                                      ; composite refusal species
(account-inspection-record-p object) => boolean       ; recognizes the EXACT
                                                      ; CD/0 schema of
                                                      ; CD0-INSPECTION-RECORD-
                                                      ; SCHEMA.md §7 — never a
                                                      ; wrapper species

;; Two public condition SPECIES, optionally beneath one base (R1 adjudication
;; Section B). An integrity alarm is NEVER an ACCOUNT-PROTOCOL-REFUSED
;; condition. Within Account-owned argument and constructor validation, no
;; raw host type error leaks (R2 Section C qualification: this claim covers
;; the Account layer's own validation only — never conditions owned by the
;; delegates, the head macros, or the host, which escape unchanged).
account-condition                                     ; base (optional, proposed)
account-protocol-refused                              ; species 1 signals
account-integrity-alarm                               ; species 2 signals
(account-condition-code condition)   => keyword
(account-condition-detail condition) => string        ; bounded; never a printed
                                                      ; host object
```

**Why this is the smallest sufficient surface.** (1) Action and inspection
must be separately named (commission, One-inspector terms): two action doors
are the commissioned minimum for the request/perform distinction. (2) The
try-variants are required because the native TRY doors exist and the
composite must offer refusal-as-value without teaching callers to catch
provider conditions through the composite — and because the S2
class-conflation (E4) means a composite caller *cannot safely build its own
try* out of `handler-case` without re-implementing the
category-first-then-phase law. (3) One inspector. (4) **Two condition
species, not one:** the R1 adjudication (Section B) rules that an integrity
alarm is never an `ACCOUNT-PROTOCOL-REFUSED` condition — a caller must be
able to handle refusals of its work without accidentally swallowing the
composite's own invariant failures; the optional shared base exists only so
a caller may deliberately handle both. (5) **One Account-owned public
predicate for the composite refusal species** (`account-refusal-p`) —
required by the adjudication because the composite pre-delegation refusal
is a first-class member of the inspector's admitted union and its admission
needs an exact public predicate like every other member's. **No predicates
are exported for the native species** — admission uses the *providers'*
public predicates internally; re-exporting admission judgments would
duplicate provider authority. `account-inspection-record-p` exists so
callers can type-gate the inspector's output without slot-probing. Nothing
else: no readers into native objects (the natives already export their
own), no convenience re-exports, no pretty printer as API.

## I.3 Door 1 law (`account-request-expansion`) — R3.1: DOOR-1 OWNERSHIP RESTORED

*(The R3.1 owner adjudication REJECTS R3's uncommissioned consolidation of
every Door-1 failure into `head-not-in-manifest`; the R3 text that stood
here is withdrawn, and the R2 Door-1 ownership is restored with the
corrected spelling kept.)*

1. **Door 1 validates form shape, operation membership, and exact `EQ`
   manifest membership — Account-owned, before any delegation — in ONE
   FIXED ORDER, producing EXACTLY ONE refusal: the first failing check's
   code, and validation stops there** (the R3.2 precedence law; a
   presented object can carry several of these defects at once, and the
   law says which single code wins):
   **(1)** `source-form-not-a-call` (not a cons);
   **(2)** `source-form-head-not-a-symbol` (cons whose head is not a
   symbol);
   **(3)** `head-not-in-manifest` (a symbol head not `EQ` to one of the
   seven manifest symbols — same-print-name foreign symbols and unrelated
   host macros included; the exact ruled spelling, kept);
   **(4)** `operation-not-declared` (operation outside
   {`:macroexpand-1`, `:macroexpand`} — the two declared operations of
   both delegates, measured equal, never assumed).
   The order is ruled on the merits as the structural order: each later
   predicate is well-defined only once the earlier one passes, and the
   form-independent operation check runs last so the refusal always names
   the deepest structural defect first (jurisdiction table 1 carries the
   same law).
2. **Only occurrence-tag validation is the delegate's** (R3-C ownership
   lock, re-affirmed by the R3.1 restoration): Door 1 does **not**
   prevalidate the tag; the selected native delegate validates it and
   returns its exact provider-owned refusal unchanged
   (`:occurrence-tag-not-identifier`, measured in both providers,
   catalogued at phase `:request`). **No claim that form-shape or
   operation validation reaches a delegate through the composite survives
   in this lane** — those validations are Door 1's own.
3. Delegate to **exactly one** native Door 1 — S1's `REQUEST-EXPANSION` for
   rows 1–5, S2's for rows 6–7 — exactly once. Never both; never a fallback.
4. Seal the result: the composite request carries {species tag, the native
   request object unchanged, the manifest row binding, manifest
   identity+version, schema version}. **No caller-owned cons tree is
   retained**: the source snapshot lives in the native request's canonical
   datum (receipt-stored law of the delegate), and the composite keeps no
   second copy of the caller's tree.

## I.4 Door 2 law (`account-perform-expansion`)

1. Require the exact composite request species (its own sealed type; a
   native request, a plist, `NIL`, or the wrong provider's wrapper is a
   typed `wrong-request-species` refusal — nothing else is "close enough").
2. Recheck the manifest binding captured at Door 1 against the /0 manifest
   declaration. **The /0 manifest is immutable** (adjudication Section C):
   no lawful movement exists inside /0, so any observed difference is
   evidence of corruption or tampering — an **integrity alarm**, never a
   version-movement event. This recheck is *not* the /0→/1 mechanism;
   version separation between /0 and /1 lives in the coexistence law
   (II.1b), where a /0 request presented to a */1* door fails **before
   invocation** as `incompatible-account-version` or
   `wrong-request-species`.
3. Delegate to the **matching** native `PERFORM-EXPANSION`, exactly once.
   Never retry, never fall through, never invoke the other provider, never
   substitute a caller procedure.
4. Return **the exact native receipt** and the expanded host form as the
   delegate returned them (pure-projection law, I.0). Door 2 performs no
   projection; the inspector is the only projection source, called
   separately by the caller if wanted.
5. Condition jurisdiction per `REFUSAL-AND-CONDITION-JURISDICTION.md` §4
   (as amended and ratified by adjudication Section B):
   **category first** — a caught provider refusal with category
   `:integrity-alarm` has its original condition re-signalled unchanged;
   **then phase, for `:protocol-refusal` rows only** — `:request`/`:perform`
   are the account-domain refusal outcome; `:expansion`, `:runtime`, and
   anything unanticipated re-signal the original condition unchanged.
   Macro-owned and unexpected host conditions escape unchanged in their
   original species.

## I.5 Repeated-performance adjudication (the delegating lineage)

The commission requires every performing lineage to adjudicate repeated
performance of one request, and, where it delegates to a native engine,
forbids upgrading native identities to unique temporal claims.

**The chosen law: explicitly structural, with the limitation stated.**

- Whether a native engine refuses a second `PERFORM-EXPANSION` of one native
  request was **not measured this round**. The production round must measure
  it (a named differential-gate obligation in `R4-SURVIVAL-PLAN.md` §6); the
  contract does not guess it.
- Therefore the composite record claims: *this record describes an
  invocation performed by the named native engine against this request,
  identified by the native request/occurrence/receipt identities carried
  unchanged.* The composite makes **no claim that these identities uniquely
  name temporal invocations**, and its record schema carries an explicit
  `temporal-uniqueness: not-claimed` standing field so the absence is a
  stored fact, not a silence.
- The caller-supplied occurrence tag is the caller's instrument for
  distinguishing invocations: distinct tags yield distinguishable claims.
  The composite **documents this as convention and does not enforce tag
  freshness** — enforcement would require a registry of seen tags, and a
  registry is forbidden by the closed-manifest law. This is stated in the
  public contract text so no caller can read enforcement into it.
- The composite never writes "one occurrence" in any record. The commission's
  phrase "on one occurrence" is satisfied per-record by *describing exactly
  one delegated invocation*, not by claiming global temporal uniqueness.

## I.6 Sealed semantic objects — and what is deliberately NOT one (R2 Section A)

**Sealed semantic objects** (private constructors, read-only slots, no
public copiers, no public mutation, no alternate construction path — the
Control 4 discipline): the composite **routing request** and the composite
**pre-delegation refusal record**. Native objects inside them are carried
by reference, unchanged, and are already sealed by their providers. The
same ontology lawfully applies to the future /1 sealed semantic objects
(Part II.4).

**The account-inspection-record is NOT a sealed semantic object.** The R1
text that sealed it is **withdrawn** (R2 adjudication, Section A): the
inspector's output is a **direct inert CD/0 record datum** — constructed
through the accepted public CD/0 API, inert by CD/0's own immutability, and
owned by no Account wrapper ontology. There is no private constructor to
hide and no slot to make read-only: `CD0-INSPECTION-RECORD-SCHEMA.md` is
its whole being. The inspector never returns a mutable native container
where the native API offers an inert datum instead.

## I.7 Identity distinctness

```text
composite request identity  ≠  native occurrence identity  ≠  native receipt identity
```

The composite mints **no identity in the native domains** and performs no
cross-provider identity comparison (the domains are measured-disjoint;
`READER-PROVENANCE-MATRIX.tsv` receipt-identity rows). The composite request
is identified image-locally by object identity plus its stored bindings; if
the production round finds it needs a durable composite-request identifier,
that identifier must live in a new `lisp-plus-surface-account` domain and
never impersonate a native one. The composite record describes its own
delegation; it must not claim identity with any *separately* invoked native
occurrence (same law as the conditional mint, Part II.6).

## I.8 The one inspector (`inspect-account`)

**Admitted domain — an explicit closed tagged union of EXACTLY FIVE
members** (adjudication Section A; this replaces the R0 "four plus one
reserved" enumeration):

| # | Species | Admission (exact public predicate) |
|---|---|---|
| 1 | S1 receipt | `LISP-PLUS-SURFACE1:EXPANSION-RECEIPT-P` |
| 2 | S1 retained refusal | `LISP-PLUS-SURFACE1:EXPANSION-REFUSAL-P` |
| 3 | S2 receipt | `LISP-PLUS-SURFACE2:EXPANSION-RECEIPT-P` |
| 4 | S2 retained refusal | `LISP-PLUS-SURFACE2:EXPANSION-REFUSAL-P` |
| 5 | Composite pre-delegation/protocol refusal | `account-refusal-p` — the Account-owned public predicate (I.2) |

Every member is reachable by objects that exist in /0 — including member 5,
which Door 1's pre-delegation refusals produce — so no branch ships
unfireable. There is **no reserved sixth entry in this union, and there
never will be** (R2 adjudication, Section B): the /0 inspector — its
function identity, its schema, and this five-member domain — is
**immutable**. A future /1 does not extend it; /1 introduces its **own
distinct inspector** with its own schema and its own public
package/function address (Part II.5b).

Predicates are the admission instrument because duck typing is
**demonstrably unsafe here**: 18 of 108 cross-applications silently returned
substantive wrong values (E7), and the 8 correctly-`NIL` predicates were the
only shared print-names safe by design. Admission never uses class-name
strings, shared print-names, slot probing, or plists.

**Not admitted** (typed refusal `:not-an-admitted-account-object` via
`account-protocol-refused`; within this Account-owned argument validation,
never a raw host type error — R2 Section C qualification): requests
(native or composite), occurrences, `SEAT-OUTCOME` objects, `NIL`, ordinary
values, field-mimicking plists, **and the inspector's own output**. The R0
idempotent self-admission clause is **withdrawn** (adjudication Section A):
the inspector returns a fixed-schema inert CD/0 record, not a re-admitted
semantic account species, and admitting its own output would have created a
hidden sixth branch. Byte-stability is guaranteed by repeated inspection of
the *same admitted artifact* (purity law below), which is the only
idempotence claim this contract makes.

**Why refusals are in the domain.** The two STOP cells (E2; **ratified as
lawful current composite outcomes by owner adjudication Locked Ruling 2**)
make the retained refusal the lawful account-domain outcome for two of the
fourteen current cells. An inspector that admits only receipts would render
the composite's own account of those cells uninspectable — the smaller
domain would be *less* truthful, not more.

### I.8b The complete fixed schema, per branch — AUTHORITATIVE TABLES IN `CD0-INSPECTION-RECORD-SCHEMA.md`

**The exact, implementation-determinate schema lives in
`CD0-INSPECTION-RECORD-SCHEMA.md` (R2 adjudication, Section A), and that
file wins over any prose here.** It specifies: every identifier-datum key
with namespace/path (§1); the value-encoding law for every enum, keyword,
integer, string, code, category, phase, disposition, and standing value,
including the mandatory encoding of not-applicable/absent standing (§2);
the four-key common envelope and nested branch-body record (§3); the exact
key set for each of the five branches — 18/18/9/6/6 keys (§§4–5); the
schema identity and version datums (§3); the 1024-octet detail-string
ceiling and its refusal behavior (§2); and which native CD/0 datums pass
through unchanged (§6).

The laws this contract adds around those tables:

- **The output is a direct inert CD/0 record datum** — never a private
  Account wrapper, never a newly admitted semantic account object (I.6).
- **No optional field changes a branch schema**: every listed key always
  present, every unlisted key never present; value-absence is a mandatory
  `("standing" …)` identifier datum, never a missing field and never `NIL`.
- **CD/0 canonical key sorting is authoritative** — record entries sort by
  octet comparison of encoded key ValueBytes (`cd0.lisp`
  `%normalize-record-entries`, read this round); **no semantic field is
  "first"** (the R1 "(first field)" prose is deleted).
- The inspector reads **only the admitted artifact** — never any live
  declaration; no `current-at-inspection` field exists in any branch.
- S1's disposition stays in its keyword vocabulary, S2's in its string
  vocabulary, in separate typed branches — no common disposition column
  (E7); S1's upstream fields exist only in the S1-refusal branch (S2's
  absence is schema-level); per-code derived standing comes from
  jurisdiction table 2, never inferred from phase alone.
- Native opaque identities pass through unchanged; equality within their
  own domain is the only licensed operation on them; provenance per field
  uses the ten-label vocabulary of `READER-PROVENANCE-MATRIX.tsv` (Locked
  Ruling 5).

**Purity law.** The inspector must not expand, replay, decode into a
caller-owned host tree, call any provider request/perform/verify door,
consult a live macro definition, **read any live provider declaration**,
enumerate a package, perform ambient search, or mutate anything. Repeated
inspection of one unchanged object in one image yields **byte-identical
canonical data** despite changes to printer variables, `*PACKAGE*`, and
readtable — achieved structurally: the record is built from the admitted
artifact's inert data and octet encodings, never from the printer and never
from ambient state. **This earns only the named same-image stability
claim** and nothing cross-image.

## I.9 Complete request schema (composite layer)

**Composite routing request** (the one artifact Door 1 constructs — I.0):
{`species-tag`; `native-request` (unchanged, by reference);
`manifest-identity`; `manifest-version`; `schema-version`; `head-key` (the
manifest row); `operation`; `occurrence-tag` (as passed to the delegate);
`macro-function-anchor` — a fixed, always-present field whose value is the
captured anchor or the constant `:anchor-not-captured`
(`REFUSAL-AND-CONDITION-JURISDICTION.md` §5; image-local either way, never
projected into any durable record)}. Provenance per field: manifest facts
are Account-owned declarations; native-request facts are the delegate's,
carried unchanged.

**Refusal artifacts (account-domain outcomes) — two kinds, never merged**
(pure-projection law, I.0): a refusal position holds either **the exact
native retained refusal object, unchanged** (inspected via branches 2/4),
or **the sealed composite pre-delegation refusal** (inspected via
branch 5; schema in I.8b). The R0 wrapper record that carried "the retained
native refusal where one exists" inside a composite refusal record is
**withdrawn** — the composite wraps nothing.

---

# PART II — Conditional contract: the Account-owned mint (for the governed /1 successor; returned now, implemented never in this round)

The recommended lineage contains an Account-owned mint **only in the
governed successor**. Per the no-dormant-mint rule, none of the following is
implemented in Account /0: it would serve no current head that the natives
do not already serve end-to-end (`ARCHITECTURE-DOCKET.md` §5). It is
returned as the complete contract the /1 commission would govern.

## II.1 Closed manifest

The /1 manifest contains the seven /0 heads **plus the exact new heads**,
each row carrying the three provenance roles separately. **The /1 manifest
is a distinct declaration with its own identity and version — it does not
move, replace, or invalidate the immutable /0 manifest** (adjudication
Section C; the coexistence law in II.1b is the whole of the /0→/1
version mechanism). Routing remains an explicit closed table/`ECASE`; no registry,
callback, method addition, package scan, or arbitrary macro fallback —
permanently (lifecycle step 7). The manifest binds the inspected predecessor
versions for the seven inherited rows **without pretending the native
engines mint the new accounts**: for new heads, the observer/codec-dependency
column reads the Account's own grammar, and for inherited heads it continues
to name the native delegate (if /1's ruling keeps dual authority) or the
Account mint (if /1's ruling supersedes — an owner decision docketed in
`ARCHITECTURE-DOCKET.md` §2-D, not made here).

## II.1b The versioned coexistence law (/0 ↔ /1) — adjudication Section C, adopted in full

**The /0 manifest is immutable. A later /1 manifest does not move the live
/0 declaration.** The six clauses:

1. **/0 requests remain /0 requests** and are accepted only by the /0
   Door 2.
2. **/1 introduces a distinct manifest identity/version and a distinct
   request species** of its own.
3. **Presenting a /0 request to a /1 door fails before invocation** as
   `incompatible-account-version` or `wrong-request-species` — a typed
   protocol refusal at /1's Door 2, **phase `:perform`** (R3-C lock 4: a
   request rejected by Door 2 is phase `:perform`), derived standing
   `pre-invocation`.
4. **A /0 request presented to the unchanged /0 door may remain valid under
   /0's closed law.** Nothing in /1's existence invalidates it there.
5. **Any canonical-front-door supersession is an explicit owner adoption
   ruling** — never mutable registration, never silent rebinding.
6. **/1 must still adjudicate explicit supersession versus visibly labelled
   dual authority** (the docketed decision, `ARCHITECTURE-DOCKET.md` §2-D).

Every R0 claim that a later /1 manifest could automatically invalidate a
live /0 request inside /0 is **withdrawn and replaced by this law**
(R3.1-C retires the "manifest movement" ontology itself: /0 declarations
never move; /1 introduces distinct declarations) — the
failure-closed boundary is /1's door refusing foreign species/versions
before invocation, not a mutation reaching back into /0.

## II.2 Two action doors and one inspector — at /1's OWN distinct address

The commission's proposed shape is adopted, **in /1's own distinct public
package** (name proposal: `LISP-PLUS-SURFACE-ACCOUNT-1`) — the R2
adjudication (Section B) requires /1 to introduce its own public
package/function address, request species, Door 2, and inspector schema,
and resolves the naming discrepancy by giving **each version one exact
address**:

| Version | Inspector's one exact address |
|---|---|
| /0 | `LISP-PLUS-SURFACE-ACCOUNT:INSPECT-ACCOUNT` (I.2) |
| /1 | `LISP-PLUS-SURFACE-ACCOUNT-1:INSPECT-EXPANSION` (this section) |

```lisp
;; all in LISP-PLUS-SURFACE-ACCOUNT-1 (proposal):
(request-expansion source-form operation occurrence-tag) => expansion-request
(perform-expansion request) => expansion-account, expanded-host-form
(try-request-expansion ...) => request-or-nil, refusal-or-nil
(try-perform-expansion ...) => account-or-nil, expanded-form-or-nil, refusal-or-nil
(inspect-expansion object) => canonical-cd0-record   ; /1's OWN inspector
```

**Door 1** validates the closed protocol, routes the exact head via the /1
manifest, **snapshots the whole source into inert canonical data under the
Account-owned grammar** (`TERM-GRAMMAR-DECISION.md`), binds manifest and
Account versions into the request, and retains no caller-owned cons tree.

**Door 2** requires the exact request species; **reconstructs a fresh
private form from the canonical snapshot** (decode by lookup, never
`INTERN`); **round-trips it before invocation** (re-encode must equal the
stored datum — the S1 `:source-not-reconstructible` jurisprudence at
`surface1.lisp:185–230` is the inherited standard, including the
home-package and round-trip-mismatch arms); rechecks captured bindings;
invokes **exactly one** selected operation — `MACROEXPAND-1` or
`MACROEXPAND` — in the null lexical environment; never retries, never falls
through, never invokes a native observer, never uses a caller procedure.

## II.3 Repeated performance (the minting lineage)

The /1 mint must choose one of the three commissioned laws. **This contract
chooses the freshness arm — and, per the R1 adjudication (Section D: "a
merely asserted 'fresh fact minted by Door 2' is not a mechanism"), now
specifies the mechanism and its testable properties instead of asserting
the fact.**

**The chosen exact law (R2 adjudication, Section D — one of the three
permitted arms): a LINEARIZABLE Account-owned allocator.** The R1 text
"per-image monotonic performance counter, incremented on every Door 2
invocation" is upgraded — the adjudication is right that an ordinary
unsynchronized `INCF` is **not** an unconditional freshness mechanism (two
threads can read-modify-write the same value), and the R1 T1 claim held
only under single-threaded execution, which it did not say.

**The allocator law (R3-B-normalized):**

0. **"One image" is defined** (R3-B, verbatim scope): **one running Lisp
   image/process.** All allocator scope-words below mean exactly this.
1. **One initialization per image — and state SURVIVES package/source
   reload.** The allocator state, the image-epoch datum, and the counter
   initialize **once** per running image, on first initialization, and a
   re-load of the package or its source **must not reset the counter and
   must not gather a new epoch** — the state persists across reload, and
   counter progression continues monotonically through it. *(This
   REVERSES the R2 reload paragraph, which had reload re-initializing
   both — the R3 adjudication rules the opposite, and the R2 text is
   withdrawn.)* A **new image** initializes new state; **no cross-image
   uniqueness guarantee exists.**
2. **Linearizability, stated conventionally (R3.1-B — the R3 phrasing
   "every allocation returns an integer strictly greater than every
   integer previously returned … under arbitrary thread interleaving" is
   DELETED as the stronger, false completion-return-order claim; return
   order under arbitrary scheduling need not be monotonic):**

   > **there exists one increasing total order of allocations that
   > respects non-overlapping call order.**

   Implemented by synchronization (a lock or an atomic compare-and-swap
   loop; the /1 round chooses the primitive, the law is the linearizable
   contract, and the implementation must document which primitive
   discharges it). **Unsynchronized `INCF` may occur only inside the
   explicitly labelled negative tooth** — never in any clean-path
   constructor, and (R3.1-B) the redundant `ALLOCATOR-OBSERVATION`
   bare-`INCF` arm is deleted: the deterministic barrier-based planted
   negative tooth already proves the defect.
2b. **The once-only initialization law (rewritten in R3.3 per the owner's
   R3.3-A ruling — the R3.2 statement was returned: on SBCL 2.4.6 a
   delayed `DEFGLOBAL` defining-form initializer can erase an
   already-CAS-installed mutex, because CAS serializes CAS against CAS,
   not an earlier defining form's delayed write against a later CAS
   publication; the same class threatens every separately published `NIL`
   or `0` state cell).** The law, true under arbitrary concurrent
   first-load interleaving:

   1. **There is one stable bootstrap carrier or equivalent atomic state
      machine, whose installation cannot be undone by any delayed
      defining-form initializer.**
   2. **Exactly one winner** gathers the epoch and constructs the
      complete state.
   3. **Epoch octets, epoch text, allocator synchronization, counter
      state, and the ready state are built privately and coherently
      published** — no observer can see a mixture assembled from two
      initialization attempts.
   4. **Concurrent non-winners wait or retry through the documented
      synchronization and return only after observing the winner's
      complete ready state.**
   5. **No first-load, reload, or re-entry path gathers a second epoch,
      resets the counter, replaces either synchronization object, or
      republishes readiness.**
   6. **Initialization failure may not publish a half-state or a false
      ready state.**

   **Rejected repairs, by name (the ruling's own list):** changing
   `DEFGLOBAL` to `DEFVAR`; adding a second check around the same
   vulnerable cells; repeating the `DEFGLOBAL`-then-CAS pattern with more
   commentary. No cell carrying live once-only state may remain
   vulnerable to a delayed unbound-to-bound definition write after
   election/publication. **Prefer one coherent state object and one
   publication point over a constellation of independently initialized
   globals**; a different design must prove why late writes cannot split
   or erase the state.

   **The implementation choice is the probe seat's — and it must be
   NAMED there**, with the exact SBCL version and the ordering argument
   from the actual SBCL operation: **"atomic" is not an incense word;
   identify the place, the competing writes, and the ordering relation.**
   The schedule-pinned hostile teeth (the stale-definition overwrite
   tooth; the genuine recursive-load tooth) are likewise the probe
   seat's; the eight-thread contention arm is retained only as a broad
   contention control, never as proof of the once-only law.

2c. **True re-entry, defined operationally (R3.3-A; and the R3.2
   mislabel corrected: the later top-level `(load …)` of the identity
   source is a SEQUENTIAL RELOAD — law 1's reload case — and is NOT
   re-entrant; no statement in this lane may call it that):** a genuine
   re-entry is a **same-thread recursive `LOAD` of the identity source
   triggered while the outer load's initialization is still in progress,
   before ready publication.** The law:
   - it must **not self-deadlock** on the outer thread's synchronization;
   - it must **not gather, publish, reset, or allocate a second state**;
   - if detected as **owner re-entry**, it may take an explicitly
     documented probe-local deferred path — **but it may not claim that
     initialization is ready**;
   - **the outermost initialization owns the sole transition to ready**;
   - **a concurrent non-owner never takes that shortcut** — it waits for
     and then observes the complete winning state.
3. **The ONE exact shared representation, bound exactly (R3.1-B)** — both
   the freshness witness and the allocator witness must construct it
   through **the SAME constructor**, never two parallel builders:
   - the **image-epoch/entropy CD/0 datum**: **exactly 16 octets of
     actual OS-random entropy** (R3.2: drawn whole from the operating
     system's random source — **never time, PID, address, or any derived
     padding**; the R3.1 witness's eight-random-plus-padding construction
     is rejected and no padded octet counts as entropy), gathered once at
     first (synchronized) initialization;
   - its **canonical epoch-hex projection**: **exactly 32 lowercase
     hexadecimal digits** — the one and only textual projection;
   - the **stored counter initializes at `0`; the first allocation is
     `1`**;
   - the **performance identifier datum**: namespace
     `("lisp-plus-surface-account")`, exact path
     `("performance" <epoch-hex> <counter-decimal>)`, where — **the R3.3-C
     normative text, verbatim:** *`<counter-decimal>` is one or more
     **ASCII** characters from `0123456789`, the first character is from
     `123456789`, and therefore zero, signs, leading zeroes, non-ASCII
     digits, and every other character are excluded* (the R3.2 phrase
     "canonical unsigned decimal with no leading zero" is replaced — on
     the parcel's SBCL runtime `DIGIT-CHAR-P` admits non-ASCII decimals
     such as U+0661, U+06F1, U+0967, U+FF11, i.e. multiple textual
     spellings where the constructor requires one);
   - **the counter-text predicate is explicit ASCII membership** —
     character-by-character membership in `0123456789` with the first in
     `123456789`; **rejected by name as admission predicates:**
     `DIGIT-CHAR-P`, Unicode numeric properties, locale-sensitive
     classification, and `PARSE-INTEGER`-as-admission. Parsing, if
     retained downstream, may occur **only after** exact shape admission.
     Every character is restricted, not only the first (a mixed spelling
     with an ASCII first character and a non-ASCII later digit is
     unlawful);
   - the **shape predicate rejects**: short or long epoch text, uppercase
     hex, counter text `"0"` (zero — no allocation is numbered 0),
     negative text, leading-zero decimal, non-ASCII digit characters at
     any position, and every other non-`0123456789` character. *(The
     epoch hexadecimal predicate is LOCKED as accepted — exact lowercase
     ASCII `0123456789abcdef` — and is not touched by this amendment.)*
   It is stored in the occurrence object. The request identity does
   **not** include it (a request is performable many times; its identity
   is stable across performances).

**The image-epoch datum — the weaker true claim:** the R1 phrase
"load-time unique seed" remains **replaced**. The epoch is an
**image-epoch/entropy datum** with **no cross-image uniqueness
guarantee** — two images' epochs are distinct only as far as entropy makes
collision improbable, and improbable is not a guarantee. Its exact encoded
position is the `<epoch-hex>` path segment. **Reload behavior (R3-B):**
the epoch is NOT re-gathered on package/source reload — it persists with
the allocator state for the life of the running image; only a **new
image** gathers a new epoch.

**The injective, domain-separated identity construction — the NORMATIVE
identity definition (R3.1-B; the unnamed "/1 identity projection" is
retired):** an occurrence identity and an account identity are each,
normatively:

> **a CD/0 bytes datum containing `canonical-octets` of the exact,
> domain-separated identity basis record.**

**A digest alternative does not inherit mathematical injectivity and may
not be substituted while the injectivity claim remains.** The basis
records — CD/0 record datums with exact fixed keys:

- **occurrence identity basis** — record with exactly three entries:
  `("key" "identity-domain")` → identifier
  `("identity" "occurrence")` (the domain separator);
  `("key" "request-identity")` → the request identity;
  `("key" "performance")` → **the complete performance identifier datum**;
- **account identity basis** — record with exactly three entries:
  `("key" "identity-domain")` → identifier `("identity" "account")`;
  `("key" "occurrence-identity")` → the occurrence identity;
  `("key" "expanded-identity")` → the expanded-form identity.

**Injectivity, argued structurally:** CD/0's canonical encoding is exact
and injective on datums (distinct datums have distinct canonical octets),
and the performance datum occupies its own fixed key in the occurrence
basis — so, holding the other entries fixed, distinct performance datums
yield distinct basis records, distinct canonical octets, and distinct
occurrence identities; the account basis inherits the distinction through
its occurrence-identity entry. **Domain separation:** the two
`("identity" …)` separator values make an occurrence basis and an account
basis unequal as datums regardless of their other entries — the two
identity families cannot collide.

**The five proofs (R3-B, verbatim — the witnesses build to exactly
these):**

1. **synchronized concurrent allocations are distinct;**
2. **request identity is stable;**
3. **occurrence and account identities differ when performance differs;**
4. **package reload preserves epoch and counter progression;**
5. **a new image may differ observationally, without a uniqueness claim.**

**Claims ceiling for the mechanism:** claimed and testable are
linearizable same-image freshness (proofs 1 and 3), reload persistence
(proof 4), and observed cross-image difference (proof 5, an observation
about entropy, never a uniqueness guarantee). **No cross-image temporal
uniqueness is claimed** — two images' counters coincide by construction
and only the epoch segment separates them, without guarantee.

**Why this arm and not the alternatives:** (i) provable single-use requests
require mutable spent-state on a sealed read-only object or a seen
registry — the first breaks sealing, the second is a forbidden registry;
(ii) the permitted explicitly-structural law would make repeated
performances of one request yield indistinguishable temporal claims — lawful
if disclaimed, but it surrenders the one accounting property a *mint* is
uniquely positioned to provide, and the adjudication itself lists "potential
fresh temporal occurrence identity" among Candidate C's genuine benefits;
(iii) the specified mechanism provides distinguishability by construction
with no registry and no request mutation. Under this law the request is
explicitly multi-performable; each performance yields a distinct occurrence
and account; and no account claims to be "the" occurrence of its request.

**Probe coverage:** the mechanism arm carries a probe obligation (the
structural arm would not): the unified freshness/allocator witnesses build
to the five proofs above **through the same performance-datum
constructor**, with the unsynchronized-`INCF` counter appearing only in
the labelled negative tooth (shown actually losing allocations under
contention), and with **proof 4's package-reload persistence** as the new
R3 witness arm. Flagged to the probe seat in this round's report.

## II.4 Sealed objects and identity distinctness

Requests, occurrences, accounts, refusals, and manifest descriptors are
sealed semantic objects: private constructors, read-only slots, no public
copiers, no public mutation or alternate-mint path.

```text
request identity ≠ expansion occurrence identity ≠ completed account identity
```

All three live in the `lisp-plus-surface-account` domain. **The new account
describes its own invocation.** It must not claim identity with any
separately invoked native Surface /1 or Surface /2 occurrence — even for an
inherited head expanded to an `EQUAL` result; sameness of outcome is not
sameness of occurrence, and no cross-domain identity comparison is licensed.

## II.5 Account inspection record (complete schema, per-field provenance)

| Field | Provenance | Standing |
|---|---|---|
| Account schema identity/version | Account-owned declaration | durable |
| Manifest identity/version | Account-owned declaration, bound at Door 1 | durable, receipt-stored-equivalent (stored in the account at mint) |
| Language-module identity | Account-owned manifest row binding | durable |
| Exact head key + Account construct identity | account-stored (minted at Door 1) | durable |
| Native antecedent construct identity — **a mandatory field, always present** (R2 Section F: "where publicly available" deleted from this fixed schema) | value is either the native identity datum carried unchanged from the delegate lane's public API, or the mandatory standing datum `("standing" "absent-no-public-antecedent")` | durable either way; absence is a stored standing, never a missing field |
| Explicit absence standing where a module declares no version | account-stored absence fact (`:no-macro-language-version-declared` — Surface /0's absence preserved, never backfilled from S1's `4/4/1`) | durable |
| Request / occurrence / account identities | account-stored | durable |
| Occurrence tag | account-stored (caller-supplied, snapshotted) | durable |
| Performance datum (image-epoch + counter — the II.3 freshness mechanism) | account-stored (minted by Door 2; an **injective component of the occurrence identity basis record**, II.3 — never "folded into" an unspecified projection) | durable as a datum; its epoch segment is image-scoped in meaning, and no cross-image uniqueness is claimed |
| Source datum + source identity | account-stored (Door 1 snapshot, Account grammar) | durable |
| Expanded datum + expanded identity | account-stored (Door 2, Account grammar) | durable |
| Operation | account-stored | durable |
| Expansion context + disposition | account-stored | durable |
| Account grammar/procedure/policy identities **and mint-time versions** | account-stored **at mint time** — the repair of the measured native trap (E6): identities are stored, not recomputed from live declarations | durable |
| Module bindings used by the manifest | account-stored | durable |
| Macro-function anchor — **adopted for the /1 mint, unconditionally** (R2 Section F: "if adopted" deleted; the adoption was already adjudicated in jurisdiction §5) | image-local inspection state | **never durable, never in canonical data** — this row exists in the schema table only to state that exclusion; the anchor is not a canonical-record field |

Not exposed, ever: macro functions, packages, lexical environments, source
locations, compiled functions, conditions as opaque host objects, mutable
caller containers.

**Complete /1 request schema:** {request identity (Account domain); manifest
identity+version; schema version; exact head key + Account construct
identity; operation; occurrence tag (snapshotted); source datum + source
identity (Door 1 snapshot under the Account grammar); Account
grammar/procedure/policy identities and versions at request time (stored,
not recomputed); image-local macro-function anchor (never durable)}. All
fields account-stored except the anchor; sealed; read-only.

**Complete /1 retained-refusal schema (R3-C: every key ALWAYS present;
absence via mandatory standing datums, never conditional key presence):**
{refusal identity (Account domain); category (exact, jurisdiction
table 3); code (exact named code, jurisdiction table 3); phase
(`:request`/`:perform`, per code); bounded detail string (never a printed
host object); **occurrence-tag** — always present, value = the snapshotted
tag or the mandatory standing datum `("standing" "not-applicable")` where
the refusal preceded any tag snapshot; **request-identity** — always
present, value = the request identity or `("standing" "not-applicable")`
where no request species was ever admitted (e.g. `wrong-request-species`
on a foreign object); derived standing (per code, jurisdiction table 3,
labelled `account-derived-check`); Account version bindings at refusal
time (stored)}. Retained refusals are sealed objects in the inspector's
domain.
The domain is not made smaller than this: the STOP-cell evidence (E2)
already shows refusals carrying load-bearing facts (invocation occurred;
exact cause), so a refusal-less or field-poorer schema would be less
truthful, not more — the same argument as Part I.8.

### II.5b The /1 inspector — DISTINCT, with its own separately enumerated branches

**Rewritten in R2 (adjudication Section B): the R1 sentence "the /1
inspector is the same one inspector as Part I.8, its closed union extended
by schema version movement" is DELETED and disavowed.** The /0 inspector —
its function identity (`LISP-PLUS-SURFACE-ACCOUNT:INSPECT-ACCOUNT`), its
schema (`CD0-INSPECTION-RECORD-SCHEMA.md`, identity
`("schema" "account-inspection-record")` version 1), and its five-member
input domain — is **immutable, forever**. Nothing extends it, nothing moves
its schema version, nothing enlarges its union.

The /1 successor introduces its **own distinct inspector** at its own
address (`LISP-PLUS-SURFACE-ACCOUNT-1:INSPECT-EXPANSION`, II.2), with its
own schema identity/version and its own admitted domain, whose branches are
**separately enumerated**:

| /1 branch | Species | Admission |
|---|---|---|
| Account-owned **completed account** | the /1 mint's completed-account artifact | an Account-owned public predicate of the /1 package |
| Account-owned **retained refusal** | the /1 mint's retained-refusal artifact | a distinct Account-owned public predicate of the /1 package |

Whether the /1 inspector's domain also admits the four native species
(so one /1 call can inspect anything) or delegates those to the standing /0
inspector is a **/1-commission decision**, docketed — but under **labelled
dual authority both inspector addresses remain explicit and public**, and
**any canonical alias, supersession, or rebinding of one address over the
other requires a later owner adoption ruling — it cannot occur through
registration or implication** (Section B, carried verbatim). Each /1 branch
carries its own complete fixed schema (the completed-account schema is
II.5's table; the retained-refusal schema is above), under the /1 schema
version. Both must be exercised by the /1 round's own gates before either
ships.

## II.6 What Part II is not

Not implemented in this round; not a dormant mint (nothing of it exists in
/0 code); not a claim that the /1 commission is bound to open — only that if
it opens, this is the returned contract shape it governs, amends, or
rejects.

---

# Cross-cutting laws (both parts)

1. **Surface /0's no-version absence is preserved** as a stored explicit
   absence everywhere a version column exists. No redefinition-detection
   claim through module versions, ever (Control 6; jurisdiction §5).
2. **Invoked-no-completion-account standing:** where invocation occurred and
   the result could not be represented (the STOP cells' shape — **ratified
   as lawful current composite outcomes by owner adjudication Locked
   Ruling 2**: both heads remain admitted and requestable; the native
   retained refusal is the truthful outcome; no completed account exists
   for either), the retained fact says so explicitly; it never implies
   nothing happened (jurisdiction §6).
3. **Nothing retries.** Any door, any species, any outcome.
4. **The forbidden sentence:** "expansion accounts for all seven heads under
   both operations" is false on E2 and may not appear in any artifact of
   this lane. The lawful sentence is: *an account where the native machine
   completes; a retained, inspectable refusal where it refuses.*

— Claude Fable 5 (JURIST, Surface Account /0 opening round), 2026-08-04
