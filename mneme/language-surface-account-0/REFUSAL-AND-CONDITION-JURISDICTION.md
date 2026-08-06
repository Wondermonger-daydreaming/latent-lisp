# Surface Account /0 — Refusal and Condition Jurisdiction

**Author:** Claude Fable 5 (JURIST seat); measurements by CARTOGRAPHER /
FABER (Claude Opus 5). Same-family cross-checks, not an independent audit.
**Date:** 2026-08-04. Design document only.

This document is the complete jurisdiction law for the recommended
native-composite lineage (`ARCHITECTURE-DOCKET.md` §6), and — where marked
— for the conditional /1 mint contract. **Nothing retries.** Any door, any
species, any outcome, ever.

---

## 1. The three species, kept distinct

| Species | What it is | Composite treatment |
|---|---|---|
| 1. Account protocol refusals | The account layer (or its native delegate acting as the account machine) declines the work under its own declared law | The account-domain outcome: retained, typed, inspectable; signalled (where signalling applies) as `account-protocol-refused` |
| 2. Account integrity alarms | The account layer detects that its own invariants moved | Signalled as `account-integrity-alarm` — **a separate public condition species; an integrity alarm is NEVER an `account-protocol-refused` condition** (R1 adjudication, Section B) |
| 3. Macro-owned and host conditions | The head macro itself, or the host, signals | **Escape unchanged, in original species. No account is minted. No substitute refusal appears.** |

The two Account condition species may share one optional public base
(`account-condition`, with shared `code`/`detail` readers — contract I.2)
so a caller may *deliberately* handle both; nothing else unifies them, and
a handler for protocol refusals can never accidentally swallow an
integrity alarm.

Control 7 proved the natives already hold this line (S1: the
`LISP-PLUS-SURFACE0:SURFACE-SYNTAX-REFUSED` condition escaped in original
species through both the plain and TRY doors; no substitute refusal, no
completion fact — controls transcript, `CONTROL 7` block, S1 planted arm,
the named check line `C7 planted: the condition escapes in its ORIGINAL
SPECIES`). The composite conserves it.

## 2. Refusal ownership — three exact tables (rewritten in R2, adjudication Section C)

The R1 single mixed enumeration is replaced by the three ruled tables. Two
laws govern all three: **native passthrough refusals are account-domain but
provider-owned** (the composite retains and projects them; it never
re-mints, re-codes, or wraps them), and **derived standing is assigned per
code, never inferred from phase alone** — `:perform` hosts both
pre-invocation and post-invocation meanings.

### Table 1 — /0 Account-constructed refusal codes (R3.1: DOOR-1 OWNERSHIP RESTORED)

Constructed by the composite itself. All are `pre-invocation` — no
delegation occurred. **The R3.1 owner adjudication REJECTS R3's
uncommissioned consolidation of every Door-1 failure into
`head-not-in-manifest` and RESTORES the R2 Account-owned Door-1 codes and
ownership** (the R3 consolidation paragraph that stood here is withdrawn;
the corrected spelling `head-not-in-manifest` is kept): **Door 1 validates
form shape, operation membership, and exact `EQ` manifest membership. Only
occurrence-tag validation moves to the selected native delegate**, which
returns its exact provider-owned refusal unchanged. No claim that
form-shape or operation validation reaches a delegate through the
composite survives anywhere in this lane.

The retainable /0 composite-refusal code set is **exactly five** — the
four Door-1 codes plus Door 2's:

| Code (Account-owned, `("code" …)` family) | Producer | Phase | Derived standing | Retainable branch-5 record? |
|---|---|---|---|---|
| `source-form-not-a-call` | Door 1 (precedence 1) | `:request` | `pre-invocation` | yes |
| `source-form-head-not-a-symbol` | Door 1 (precedence 2) | `:request` | `pre-invocation` | yes |
| `head-not-in-manifest` (same-print-name foreign symbol; unrelated host macro; any non-member head — `EQ` keying) | Door 1 (precedence 3) | `:request` | `pre-invocation` | yes |
| `operation-not-declared` | Door 1 (precedence 4) | `:request` | `pre-invocation` | yes |
| `wrong-request-species` (Door 2 admits only the sealed composite request) | Door 2 | `:perform` (a request rejected by Door 2 is phase `:perform` — R3-C lock) | `pre-invocation` | yes |

**The Door-1 precedence law (R3.2 — one ordered validation, exactly one
refusal).** A presented object can carry several Door-1 defects at once (a
non-cons is also headless; a non-symbol head is also unmanifested; either
can accompany an undeclared operation). Door 1 validates in **one fixed
order** and produces **exactly the first failing check's code**, stopping
there — never two refusals, never an unordered choice:

> **1.** `source-form-not-a-call` → **2.** `source-form-head-not-a-symbol`
> → **3.** `head-not-in-manifest` → **4.** `operation-not-declared`

Ruled on the merits as the structural order: each later predicate is
well-defined only once the earlier one passes (a head's symbolhood is a
question about a cons; manifest membership is a question about a symbol
head), and the form-independent operation check runs last so the
form-structural chain stays contiguous and the refusal always names the
deepest structural defect first. Contract I.3 carries the same law.

**Account-owned validation codes that are condition signals only (never
branch-5 records)** — the inspector's admission code plus the three
detail-validation codes of the R3.1 DETAIL TOTALITY disposition:

| Code | Producer | Category / phase | Derived standing | What it catches |
|---|---|---|---|---|
| `not-an-admitted-account-object` | inspector | protocol-refusal / `:request` | `pre-invocation` | object outside the five-species union |
| `native-detail-not-string` | inspector (Account field validation) | protocol-refusal / `:request` | `pre-invocation` | a native detail value that is not a string (excludes `NIL` — **`NIL` encodes as `standing/measured-nil`**, it is never a validation failure) |
| `native-detail-not-cd0-scalar-string` | inspector (Account field validation) | protocol-refusal / `:request` | `pre-invocation` | a host string CD/0 cannot represent as a scalar string datum |
| `detail-string-exceeds-ceiling` | inspector (Account field validation) | protocol-refusal / `:request` | `pre-invocation` | a representable scalar string above 1024 payload octets |

All three detail codes produce **no inspection record**; actual condition
signalling remains a mandatory **production** tooth
(`R4-SURVIVAL-PLAN.md` §4(h5) family) — R3.1 carries only unmistakably
non-production validators and witnesses.

**The ownership rulings, locked (R3-C, re-affirmed with the R3.1 Door-1
restoration):**

1. **/0 Door 1 does not prevalidate the occurrence tag** — and ONLY
   occurrence-tag validation is the delegate's.
2. **The delegate validates the tag and returns the exact provider-owned
   refusal unchanged** (`:occurrence-tag-not-identifier`, table 2).
3. **Native passthrough refusals are provider-owned, Account-domain
   outcomes: the exact native object is returned unchanged — never
   Account-owned.**
4. **A request rejected by Door 2 is phase `:perform` — including the /1
   `wrong-request-species` and `incompatible-account-version` cases.**

Beyond Door 1's restored jurisdiction (form shape, operation membership,
manifest membership) and the Account's own field validation above,
everything else — tag validation, term representability, ceilings,
reconstruction — is the delegate's jurisdiction (table 2), reaching the
caller as the exact provider-owned native object, unchanged.

### Table 2 — exact native passthrough refusal outcomes

**Every row of this table is: provider-owned, an Account-domain outcome,
the exact native object returned unchanged — never Account-owned**
(R3.1-C, verbatim standing for every request/perform native row). Every
measured native `:protocol-refusal` code at phases `:request`/`:perform`,
from the survey's own catalog read (`cartography/raw-probe.txt`,
corroborated against catalog source), with the exact derived standing
**per code**:

**Surface /1 — 9 `:request` codes, all `pre-invocation`:**
`:source-form-not-a-call`, `:source-form-head-not-a-symbol`,
`:operation-not-declared`, `:occurrence-tag-not-identifier`,
`:source-term-unrepresentable`, `:source-term-shared-structure`,
`:source-depth-exceeded`, `:source-nodes-exceeded`,
`:source-term-octets-exceeded`.

**Surface /1 — 8 `:perform` codes, split by meaning (never by phase
alone):**

| Code | Derived standing | Why |
|---|---|---|
| `:not-a-known-surface-construct` | `pre-invocation` | head resolution fails before any macro invocation |
| `:construct-not-a-macro` | `pre-invocation` | the `MACRO-FUNCTION` presence check precedes invocation (`surface1.lisp:209–211`) |
| `:source-not-reconstructible` | `pre-invocation` | reconstruction precedes invocation (four upstream arms preserved distinctly) |
| `:expanded-term-unrepresentable` | `invoked-no-completion-account` | expansion happened; the result is outside the grammar |
| `:expanded-term-shared-structure` | `invoked-no-completion-account` | expansion happened — the STOP-cell code (E2; Locked Ruling 2) |
| `:expanded-depth-exceeded` | `invoked-no-completion-account` | expansion happened; result over the depth ceiling |
| `:expanded-nodes-exceeded` | `invoked-no-completion-account` | expansion happened; result over the node ceiling |
| `:expanded-term-octets-exceeded` | `invoked-no-completion-account` | expansion happened; result over the octet ceiling |

**Surface /2 — 9 `:request` codes, all `pre-invocation`:** the same nine
print-names as S1's request list (S2's own symbols; measured).

**Surface /2 — 7 `:perform` codes, split by meaning:**
`:not-a-known-surface2-construct` → `pre-invocation` (**and it is
`:protocol-refusal`/`:perform`, therefore account-domain — the R1
"impossible route ⇒ integrity alarm" exception is REMOVED**, §3);
`:source-not-reconstructible` → `pre-invocation`;
`:expanded-term-unrepresentable`, `:expanded-term-shared-structure`,
`:expanded-depth-exceeded`, `:expanded-nodes-exceeded`,
`:expanded-term-octets-exceeded` → `invoked-no-completion-account`.
*(S2 exports no `:construct-not-a-macro` — measured absence, recorded as
absence.)*

**Never passthrough (for completeness, so this enumeration is total over
both catalogs):** S2's 7 `:expansion` codes (`:non-exhaustive-match`,
`:duplicate-pattern`, `:unreachable-pattern`, `:pattern-not-in-grammar`,
`:match-var-not-a-symbol`, `:with-outcome-binding-malformed`,
`:facet-binding-malformed`) and 1 `:runtime` code (`:not-a-seat-outcome`)
are macro/host-owned — re-signalled unchanged (species 3, §4); both
providers' `:integrity-alarm` rows (S1: 3 `:receipt`; S2: 3 `:receipt` +
2 `:match`) are provider-owned alarms — re-signalled unchanged (§4 step 1).

### Table 3 — conditional future /1 Account-owned codes (returned, not implemented; R3-C: every row an exact named code — no grouped phrases)

All rows: **category `protocol-refusal`, owner = the /1 Account mint**,
except where noted. Door-2 rejections are phase `:perform` (R3-C lock 4).

| Exact code | Category | Phase | Owner | Derived standing |
|---|---|---|---|---|
| `incompatible-account-version` (a /0 request at a /1 door — coexistence law, contract II.1b) | protocol-refusal | `:perform` (Door 2 rejection) | /1 Account | `pre-invocation` |
| `wrong-request-species` (same boundary, other detection) | protocol-refusal | `:perform` (Door 2 rejection) | /1 Account | `pre-invocation` |
| `head-not-in-manifest` | protocol-refusal | `:request` | /1 Account | `pre-invocation` |
| `source-form-not-a-call` | protocol-refusal | `:request` | /1 Account | `pre-invocation` |
| `source-form-head-not-a-symbol` | protocol-refusal | `:request` | /1 Account | `pre-invocation` |
| `operation-not-declared` | protocol-refusal | `:request` | /1 Account | `pre-invocation` |
| `occurrence-tag-not-identifier` | protocol-refusal | `:request` | /1 Account | `pre-invocation` |
| `source-term-unrepresentable` | protocol-refusal | `:request` | /1 Account | `pre-invocation` |
| `source-term-shared-structure` | protocol-refusal | `:request` | /1 Account | `pre-invocation` |
| `source-depth-exceeded` | protocol-refusal | `:request` | /1 Account | `pre-invocation` |
| `source-nodes-exceeded` | protocol-refusal | `:request` | /1 Account | `pre-invocation` |
| `source-term-octets-exceeded` | protocol-refusal | `:request` | /1 Account | `pre-invocation` |
| `detail-string-exceeds-ceiling` | protocol-refusal | `:request` | /1 Account | `pre-invocation` |
| `source-not-reconstructible` (decode-by-lookup arms, distinct upstream reasons preserved) | protocol-refusal | `:perform` | /1 Account | `pre-invocation` |
| `construct-not-a-macro` (absent macro function at invocation time) | protocol-refusal | `:perform` | /1 Account | `pre-invocation` |
| `expanded-p-nil` (`MACROEXPAND*` reports no expansion — refusal, never an account for an unchanged form) | protocol-refusal | `:perform` | /1 Account | `pre-invocation` |
| `expanded-term-unrepresentable` | protocol-refusal | `:perform` | /1 Account | `invoked-no-completion-account` |
| `expanded-term-shared-structure` | protocol-refusal | `:perform` | /1 Account | `invoked-no-completion-account` |
| `expanded-depth-exceeded` | protocol-refusal | `:perform` | /1 Account | `invoked-no-completion-account` |
| `expanded-nodes-exceeded` | protocol-refusal | `:perform` | /1 Account | `invoked-no-completion-account` |
| `expanded-term-octets-exceeded` | protocol-refusal | `:perform` | /1 Account | `invoked-no-completion-account` |
| `not-an-admitted-account-object` (the /1 inspector's admission refusal) | protocol-refusal | `:request` | /1 Account | `pre-invocation` |
| `native-detail-not-string` (R3.1 detail totality — `NIL` is never this: `NIL` encodes as `standing/measured-nil`) | protocol-refusal | `:request` | /1 Account | `pre-invocation` |
| `native-detail-not-cd0-scalar-string` | protocol-refusal | `:request` | /1 Account | `pre-invocation` |
| `detail-string-exceeds-ceiling` | protocol-refusal | `:request` | /1 Account | `pre-invocation` |
| `manifest-key-collision` | **integrity-alarm** | `:request` | /1 Account | `not-applicable` |
| `captured-manifest-binding-mismatch` | **integrity-alarm** | `:perform` | /1 Account | `not-applicable` |
| `delegated-artifact-species-mismatch` | **integrity-alarm** | `:perform` | /1 Account | `not-applicable` |
| `inspection-schema-projection-mismatch` | **integrity-alarm** | `:request` | /1 Account | `not-applicable` |

*(The R3 closing sentence that summarized the /1 integrity alarms as
"§3's families" is DELETED per R3.1-C — no "families"; the four exact rows
above are the enumeration.)*

**Door-2 precedence, bound (R3.1-C):** at the /1 Door 2, **an object
recognized as an Account /0 request draws `incompatible-account-version`;
every other object not satisfying the exact /1 request predicate draws
`wrong-request-species`** — both phase `:perform`, Account-owned,
`pre-invocation`. Recognition of a /0 request precedes the generic species
test, so a /0 request is never mislabelled as a mere foreign object. **Two
future contract teeth (specified here for the probe seat; exercised by the
/1 round's own gates):** (t-precedence-1) present a genuine /0 composite
request to the /1 Door 2 and require exactly
`incompatible-account-version`, phase `:perform`; (t-precedence-2) present
a non-request object (a plist mimicking request fields) and require
exactly `wrong-request-species`, phase `:perform` — and never the
reverse assignment.

## 3. Integrity alarms — the full enumeration

- **manifest collision** — a duplicate key at manifest construction
  (Control 3: detected, signalled, no first-row-wins);
- **captured-binding movement** — Door 2 finds the manifest
  identity/version, or an adopted macro-function anchor, differs from what
  Door 1 captured;
- **identity mismatch** — a delegated artifact's species fails its
  provider's own public predicate. *(The R1 second arm — "a native refusal
  code arrives on a path the route law says cannot produce it" — is
  REMOVED per the R2 adjudication, Section C: the impossible-route
  exception is dead. A native `:protocol-refusal`/`:perform` refusal such
  as `:not-a-known-surface2-construct` is an account-domain passthrough
  outcome (§2 table 2) no matter what the route law predicted; the
  composite does not get to reclassify a provider's lawful refusal as its
  own alarm because it believed the route impossible.)*;
- **schema projection mismatch** — the inspector's projection of an admitted
  object does not satisfy its own fixed schema.

Alarms are the composite's own failures of invariant, not accounts and not
refusals of the caller's work; they signal `account-integrity-alarm` — the
separate species, never `account-protocol-refused` — and mint nothing.

Note on the manifest recheck (R1 adjudication, Section C): the /0 manifest
is **immutable**, so the `captured-binding-movement` alarm inside /0
detects corruption or tampering only — there is no lawful movement to
detect: /0 declarations never move (R3.1-C); /1 introduces distinct
declarations.
/0→/1 version separation is the coexistence law's jurisdiction (contract
II.1b): a /0 request presented to a /1 door fails **before invocation** as
`incompatible-account-version` or `wrong-request-species` — a protocol
refusal of that door, not an alarm and not a mutation reaching back into
/0.

## 4. The S2 phase-keying law (the measured conflation, and its mechanical cure)

**The fact (E4, Control 7 "MEASURED ASYMMETRY, REPORTED NOT SMOOTHED"):**
S1 separates macro-owned from account-domain **by class**
(`LISP-PLUS-SURFACE0:SURFACE-SYNTAX-REFUSED` vs
`LISP-PLUS-SURFACE1:EXPANSION-REFUSED`). S2 uses **one class for both** —
`LISP-PLUS-SURFACE2:SURFACE2-EXPANSION-REFUSED` — and **among S2's
`:protocol-refusal` catalog rows, and only among those rows, the `phase`
field is the only separator** between macro-owned and account-domain
(measured: a macro-grammar refusal carried phase `EXPANSION`, code
`NON-EXHAUSTIVE-MATCH`); the `:integrity-alarm` rows are separated by the
`category` field, which is why phase alone cannot key the species. S2's own
`try-perform-expansion` returns the macro-owned refusal **in the refusal
position** (`surface2.lisp:941–953`).

**The law, as amended after the fresh-context review (F4) and RATIFIED by
the R1 owner adjudication (Section B, verbatim partition): key on the
public `category` reader first, then on `phase`. Phase alone cannot separate
the three species — both providers' catalogs carry integrity-alarm rows
whose phases (`:receipt`, `:match`) a phase-only partition would misfile as
macro-owned.** The first version of this section legislated phase-only and
deferred the catalog enumeration to the production round; the review pointed
out the survey had already made that measurement, and the source confirms
it. Enumerated **now** (survey read `cartography/raw-probe.txt:35–62` in the
staging evidence; class/phase pairs re-counted from the catalog source in
`surface1.lisp` / `surface2.lisp` this session):

| Provider | Catalog size | `:protocol-refusal` rows by phase | `:integrity-alarm` rows by phase |
|---|---|---|---|
| Surface /1 | 20 | 9 `:request`, 8 `:perform` | 3 `:receipt` (`:SOURCE-IDENTITY-PROJECTION-MISMATCH`, `:EXPANDED-IDENTITY-PROJECTION-MISMATCH`, `:PROCEDURE-VERSION-MISMATCH`) |
| Surface /2 | 29 | 9 `:request`, 7 `:perform`, 7 `:expansion`, 1 `:runtime` | 3 `:receipt`, 2 `:match` (`:RECEIPT-NOT-MINTED`, the two projection mismatches, `:PROJECTION-WITHOUT-SETTLED-EXECUTION`, `:NO-EVIDENCE-CLASS`) |

The keying law, in order:

1. **Category first.** Read the refusal's public
   `EXPANSION-REFUSAL-CATEGORY` (present and measured in both providers —
   `READER-PROVENANCE-MATRIX.tsv` refusal rows). `:integrity-alarm` ⇒ a
   **provider-owned integrity alarm**: the provider reporting movement of
   *its own* invariants. The composite conserves it — the original
   condition object is re-signalled unchanged; it is never returned in the
   refusal position, never converted into a composite refusal, and never
   absorbed into the composite's own species-2 alarms (§3), which remain
   the composite's failures of *its* invariants. The two alarm families
   share a species number and nothing else; the canonical projection labels
   the bearer.
2. **Phase second, protocol rows only.** For `:protocol-refusal`: phases
   `:request` and `:perform` are account-domain outcomes (species 1 —
   **provider-owned**, the exact native object returned unchanged, never
   Account-owned; R3.2 ownership sweep). **Every other
   phase — `:expansion`, `:runtime`, and anything unanticipated — is
   macro/host-owned (species 3)**, and the original condition object is
   re-signalled. Positive enumeration, everything-else-out, so an
   unanticipated phase can never be silently absorbed as an account
   refusal.
3. **Reachability, charged at its true size** (the review's measurement,
   accepted and recorded): every currently *reachable* `:match` and
   `:runtime` code fires from **evaluated** expansion output, which the
   composite never evaluates; every `:receipt`-phase integrity code in both
   providers is marked internal-planted-fault-only. The first version's
   misfiling was therefore an **unsound specification, not a demonstrated
   live misroute** — repaired here precisely because the production round
   would otherwise build it into code. That round must exercise the
   category branch with a planted arm (a gate that has never fired is
   untested, not passing).

- **Mechanism (the delegation consequence, unchanged by the amendment):**
  the composite does **not** delegate to the native TRY doors — S2's TRY
  door would hand it macro-owned refusals as values, already stripped of
  their signalling context. The composite delegates to the **plain** native
  doors and builds its own try-semantics: `handler-case` on exactly the
  provider's refusal condition class
  (`LISP-PLUS-SURFACE1:EXPANSION-REFUSED` for S1;
  `SURFACE2-EXPANSION-REFUSED` for S2); on catching, apply the keying law
  above — category, then phase; return account-domain protocol refusals
  (provider-owned, the exact native object unchanged — never Account-owned)
  as the refusal value; **re-signal the very same condition object** — the
  original, not a reconstruction — for provider integrity alarms and for
  macro/host-owned rows, so conservation of species is literal. S1
  macro-owned conditions (`SURFACE-SYNTAX-REFUSED`, any host condition) are
  simply never handled and escape naturally. Catalog-entry accessors are
  used **only on entries obtained from the same provider's own catalog
  function**, since they are untyped positional list readers in the
  measured silent-cross-application hazard set (E7).
- The composite's refusal position therefore contains **account-domain
  protocol refusals only**, on both providers — the S2 conflation ends at
  the composite boundary without one native byte moving, and provider
  integrity alarms pass through it undisguised.

## 5. Absent macro function, and the redefinition claim-limitation

**Absent at invocation time → typed pre-invocation refusal.** S1 already
carries this natively: `:construct-not-a-macro`, phase `:perform`,
"the resolved symbol has no macro function in this image"
(`surface1.lisp:209–211`; catalog marks it reachable in a stub image). The
composite surfaces it as a species-1 pre-invocation refusal. For the /1
mint, Door 2 performs its own `MACRO-FUNCTION` presence check before
invocation and refuses with its own typed code.

**Redefined after Door 1 → a claim limitation, not a detection claim.**
Surface /0 declares no macro-language version; S1's `4/4/1` versions its
observer machinery, not the five macro definitions (measured;
`CARTOGRAPHY-NOTES.md` §11); Control 6 proved stored versions retain
historical standing while live identities move. Therefore **redefinition of
a head macro between Door 1 and Door 2 is undetectable through the accepted
module-version declarations, and the contract says so on the face of the
record** (the explicit absence standing, `SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md`
Part II.5).

**The image-local `MACRO-FUNCTION` anchor — adjudicated: ADOPTED for the /1
mint, optional for the composite, image-local only.** Door 1 captures the
head's `MACRO-FUNCTION` object; Door 2 compares by `EQ` before invocation;
inequality is the `captured-binding-movement` integrity alarm. Justification:
it converts an undetectable redefinition into a detectable same-image alarm
at zero durable cost. Limits, stated so the anchor cannot inflate: it
detects rebinding of the macro-function cell only, not behavioural change
inside a closure; it is meaningful only within one image; and it is
**image-local inspection state only — it must never enter canonical durable
data or acquire cross-image standing.** For the /0 composite it is optional
because Door 1→Door 2 delegation is typically immediate; if adopted, same
law.

## 6. Three remaining adjudications

- **`expanded-p = NIL` → refusal, not a completed account.** If
  `MACROEXPAND-1`/`MACROEXPAND` reports no expansion occurred, no account
  exists for an unchanged form; the /1 mint refuses with its own typed code.
  (For the composite this cell is native jurisdiction; whether either native
  Door 2 can reach it for a manifest head was not measured this round — a
  named production-round measurement obligation, not guessed here.)
- **Pre-invocation refusal ≠ post-invocation accounting failure.** Different
  facts, distinguished **per code by §2 table 2 — never inferred from phase
  alone** (R2 Section C: `:perform` hosts both meanings —
  `:construct-not-a-macro` and `:source-not-reconstructible` are
  pre-invocation at `:perform`, while every `:expanded-*` code is
  `invoked-no-completion-account`: the expansion *happened* and could not
  be represented, the STOP cells' exact shape, E2/Locked Ruling 2). The
  retained fact must never imply that nothing happened. The standing is
  derived per-code from stored refusal fields and labelled
  `account-derived-check`. *(The STOP cells' standing is now ratified:
  owner adjudication Locked Ruling 2 confirms both heads remain admitted
  and requestable, the native retained refusal with
  `invoked-no-completion-account` standing is the truthful outcome, and no
  completed account exists for either.)*
- **Nothing retries.** Restated because every path above ends in exactly one
  of: artifact, retained refusal, alarm, or an escaped original condition —
  and none of those is an invitation.

## 7. The provenance vocabulary — extension ADOPTED by owner ruling (Locked Ruling 5)

**Standing: RULED.** The R1 owner adjudication (Locked Ruling 5) extends
the provenance vocabulary with five first-class labels:

    request-stored
    refusal-record-stored
    condition-stored-reference
    provider-recomputation
    provider-derived-projection

The `OUT-OF-VOCABULARY:` prefixes are accordingly **dropped from the
matrices** — the labels are approved vocabulary now, not flags.
*Historical note, kept once as the ruling directs: these labels originated
in R0 as `OUT-OF-VOCABULARY:` flags raised by CARTOGRAPHER rather than
force a false five-label fit; the fresh-context review (F3) then showed the
census under-counted by construction (request-borne facts outside the
matrix; one request trio labelled upward into `receipt-stored`), and the
R0 response corrected it; the owner's ruling now settles the vocabulary.*

The labels, as ruled and as applied in `READER-PROVENANCE-MATRIX.tsv`:

| Label | Rows | Names |
|---|---|---|
| `request-stored` | 12 | fields frozen in a native request record — a fourth native artifact; the ten `EXPANSION-REQUEST-*` externals per provider read it |
| `refusal-record-stored` | 9 | fields frozen in a retained native refusal record — a third native artifact; S1's upstream category/code/stage live here |
| `condition-stored-reference` | 2 | **`EXPANSION-CONDITION-REFUSAL`, both providers: the carrying relation is borne by the condition, not the refusal record** (the ruling's own adjudication — these two rows move from `refusal-record-stored` to this label, which is why that count is 9, not R0's 11) |
| `provider-recomputation` | 1 | `LISP-PLUS-SURFACE2:VERIFY-RECEIPT` output — authoritative standing per Locked Ruling 6: *bounded re-derivation of stored source-form and expanded-form identity projections from stored datums; independent of live grammar/procedure/policy declarations.* Its continued `T` after redefinition (Control 6) demonstrates that declaration-independence. Not receipt-stored (not stored anywhere), not account-derived (the provider computes it), not a declaration (it is a computation over an artifact's stored datums). Not authentication. |
| `provider-derived-projection` | 1 | `DERIVE-SEAT-OUTCOME` / `SEAT-OUTCOME-*` — derived by the provider from caller-supplied events; not an expansion artifact at all |

**Census phrasing, per the ruling: these are 25 classified TSV rows, never
"25 atomic facts"** — several rows group accessor families (the version
trios, the datum/identity pairs), and a row is a classification of what an
accessor family reads, not an enumeration unit of world-facts. The matrix
preserves, per row, **which rows were value-exercised this session and
which merely enumerate public accessors** (the `measured-this-session`
column carries exactly that distinction).

— Claude Fable 5 (JURIST, Surface Account /0 opening round), 2026-08-04
