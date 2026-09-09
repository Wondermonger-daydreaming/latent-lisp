*PUBLIC READER'S NOTE (prepended at publication, 2026-09-08). The body below the `---` rule is byte-identical to the lab source; see PROVENANCE.md for its blob hash and the strip recipe. Paths of the form `corpus/voices/received/originals/…` name the lab's private archive of the outside reviewer's (Astra's) letters; the operative text of every letter is quoted verbatim inside these documents. "The stone" = `../mneme/architecture/ARCHITECTURE-0-STATUS.md`, which is in this tree. "The report", "the parcel", "the cover", "the bridge", "the front door" and "the freezer" name lab working documents and the storage of the underlying SAT proofs, which are not published; the public account of that proof is `../shannon-synthesis-0/README.md`. Paths written `experiments/latent-lisp/…` are relative to this tree's root. Line 9's absolute path `/home/gauss/Desktop/Claude-Code-Lab/` should be read as "the lab repository root"; every path below it is relative to that root, and those under `experiments/latent-lisp/` are in this tree.*

---

# LMP/0 COLLISION TEST — READING RETURN: Language Surface Account /0 and Memory Layer /0

**Seat:** CLERK-SA-ML0 (Claude Fable 5.1). **Date of reading:** 2026-09-08.
**Charge:** identify the authoritative texts for two contracts and quote their governing
clauses verbatim, with file:line, so a later comparison can cite them. Nothing here is
interpretation beyond the tag "bears on (a)–(e)". Nothing was executed. No tracked file
was modified.

**Repo root for every path below:** `/home/gauss/Desktop/Claude-Code-Lab/`.
**Path prefix elided in the clause sections:** `experiments/latent-lisp/mneme/`.
Where a clause section writes `SA0-CONTRACT:24`, read
`experiments/latent-lisp/mneme/language-surface-account-0/SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md`
line 24. Short names are bound in SOURCES.

---

## SOURCES

Commit = `git log -1 --format='%h %ad' --date=short -- <path>`. Blob = `git hash-object <path>`
(working-tree blob; working tree is clean for all files listed — `git status --porcelain`
showed only two untracked `.drat` files in this same `_staging/` directory).

### Status quotations — the two governing sentences, verbatim from the stone

Stone: `architecture/ARCHITECTURE-0-STATUS.md` (commit `e94fea62 2026-09-01`, blob
`504be2204474bd657e5446bb503ee8a3fcd2613f`).

**Surface Account /0** — `ARCHITECTURE-0-STATUS.md:642-645`, inside **ADDENDUM 14 — 2026-08-19:
STATE REFRESH** (heading at line 608), item 4:

> 4. **Language Surface Account /0 — ADOPTED + PUBLISHED 2026-08-06.** Lab phase R0→R3.3.3,
>    production round R4→R4.3 accepted; adoption merge `6715d2c4`, receipt `fafa80aa`.
>    **Surface /3 remains SHUT.** Front doors: `mneme/language-surface-account-0/`
>    (`OWNER-RULING-R4-RETURN-AND-R4.3-COMMISSION.md` · `ADOPTION-RECEIPT-2026-08-06.md`).

**Memory Layer /0 — TERMINAL STANDING** — `ARCHITECTURE-0-STATUS.md:1396-1400`, inside
**ADDENDUM 24 (2026-09-01, evening): THE STRICT STRANGER AUDIT — performed, received,
obligation discharged; findings open** (heading at line 1367), item 6:

> 6. **TERMINAL STANDING (Sol II §V, quote exactly):** **ADOPTED AND PUBLISHED · STRICT STRANGER AUDIT PERFORMED AND RECEIVED ·
>    STRANGER-AUDIT OBLIGATION DISCHARGED · BOUNDED INDEPENDENT EVIDENCE OBTAINED · P9 CLAIM-CEILING DEFECT OPEN · NO SUPPORTED-PATH
>    RUNTIME SEMANTIC FAILURE ESTABLISHED.** The former sentence "STRANGER AUDIT OWED · NO INDEPENDENT VERIFICATION" is superseded
>    for current navigation and remains historical evidence of the pre-audit standing. This does not confer blanket "independently
>    verified" status.

Two earlier ML/0 status sentences exist in the same stone and are HISTORY, quoted here only
so a later reader does not mistake one of them for the standing:

- `ARCHITECTURE-0-STATUS.md:1097` (ADDENDUM 16 — POSTSCRIPT 8, 2026-08-21) — the carried floor
  status row at the registration act: **`ml0 | CANDIDATE-NOT-ADOPTED · REGISTERED · stranger audit owed · no independent verification`**
- `ARCHITECTURE-0-STATUS.md:1161` (ADDENDUM 18, 2026-08-22) —
  > **MEMORY LAYER `/0` — ADOPTED AND PUBLISHED · stranger audit owed · no independent verification**

### Table

| # | Path (under `experiments/latent-lisp/mneme/`) | Commit | Blob | Adoption status |
|---|---|---|---|---|
| S1 | `language-surface-account-0/ADOPTION-RECEIPT-2026-08-06.md` | `fafa80aa 2026-08-06` | `c8b8368be717b2c736a3be752578505d66e8aa08` | **ADOPTED authority** — the receipt named in the stone's own status sentence (`:645`, "receipt `fafa80aa`") |
| S2 | `language-surface-account-0/production/surface-account.lisp` | `af4ec5b0 2026-08-06` | `11ae1895ea5fd98c2af2934e5d0c39433e51e725` | **ADOPTED authority** (the adopted production source; its own header, `:12`, calls the mechanism "accepted and frozen as an executable contract") |
| S3 | `language-surface-account-0/production/package.lisp` | *(not separately queried; see note)* | *(not separately queried)* | **ADOPTED authority** — the nine-export public surface |
| S4 | `language-surface-account-0/SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md` | `1c86e3ff 2026-08-05` | `5f0881adbbddfe158b2e98654ccd276f5998ba32` | **CANDIDATE / PROPOSAL** — self-labelled "Contract Candidate"; `:24` "This is a contract *candidate* returned for owner review." Part II explicitly "implemented never in this round" (`:423`) |
| S5 | `language-surface-account-0/PROPOSED-API-AND-INTEGRATION-DELTA.md` | `1a58ca2c 2026-08-04` | `e3a774319f31497490da03dedf99935b97490cb4` | **PROPOSAL** — `:3` "Proposed, **NOT implemented**." |
| S6 | `language-surface-account-0/CD0-INSPECTION-RECORD-SCHEMA.md` | `d1ecbd96 2026-08-05` | `5c8f5272c8890e6d46a9524da3c247d4da0a0cf3` | **PROPOSAL, but authoritative-within-its-subject** — `:6` "**This file is the authoritative schema.**"; `:33` "**Standing.** Proposed design, not implemented; the schema binds the future production round." |
| S7 | `language-surface-account-0/READER-PROVENANCE-MATRIX.tsv` | `681c926d 2026-08-04` | `09e60e28342eb14b975c1a5ef00d58f51aa97667` | **MEASUREMENT RECORD** (85 data rows) cited as normative vocabulary by S4 (`:393-395`, "the ten-label vocabulary of `READER-PROVENANCE-MATRIX.tsv` (Locked Ruling 5)") |
| M1 | `memory-layer-0/MEMORY-LAYER-0-SPEC.md` | `3fdb1b1c 2026-08-21` | `6115a247a1246450b862d0ed04a4aeac9870b110` | **In-file header says CANDIDATE** (`:7`); **STONE SAYS ADOPTED AND PUBLISHED** (terminal standing above). See SILENCES §S-4 for the disclosed, ruled reason the frozen object's candidate-era headers were left in place. |
| M2 | `memory-layer-0/MEMORY-LAYER-0-GUIDE.md` | `3fdb1b1c 2026-08-21` | `21eb33f2ebfbce7fcc4beff13c10656c5a7e8a62` | same as M1 (`:6` "**STANDING: CANDIDATE.**") |
| M3 | `memory-layer-0/MEMORY-LAYER-0-RETURN.md` | `3fdb1b1c 2026-08-21` | `6209be12c4aaa430959e29e8e1f17b9de0019d83` | same as M1 (`:1` "RETURN (candidate, first slice)"; `:9-11` claim ceiling) |
| M4 | `memory-layer-0/MEMORY-LAYER-1-RESERVED-CHARTER.md` | `615f355a 2026-08-21` | `a346fc6d9e6206c19e9372ee525adaddfbe1cdf6` | **RESERVED — opens no lane.** `:4-5` "This file reserves a subject; it opens no lane, authorizes no build, and carries no standing." |
| M5 | `memory-layer-0/MEMORY-LAYER-0-WORK-ORDER.md` | `615f355a 2026-08-21` | `59d6876aa266d4e3685059c68d2d7252cc6c6be5` | **COMMISSION** (the work order + its three amendments, cited as governing by M1) |
| M6 | `memory-layer-0/de-actu-memorato/ARTIFACT-MANIFEST.txt` | `5489015f 2026-08-21` | `c3de9b029813dafa637e1ff980f42a23d993261b` | **SPECIMEN ARTIFACT RECORD**; carries the lane's governing sentence and its own standing line (`:4` "CANDIDATE. Not adopted, not audited, not frozen, not registered on any floor.") |
| M7 | `memory-layer-0/de-actu-memorato/run-specimen.lisp` | `a1b041e5 2026-08-20` | `6d96416e5ce77f2bc048bb4257a4d3afcab42c29` | specimen driver (listed, not quoted) |
| ST | `architecture/ARCHITECTURE-0-STATUS.md` | `e94fea62 2026-09-01` | `504be2204474bd657e5446bb503ee8a3fcd2613f` | the stone (status authority) |

*Note on S3:* `production/package.lisp` was read but its commit/blob were not separately
queried in this sitting. Recorded as UNVERIFIED rather than guessed (see UNVERIFIED §U-1).

### `de-actu-memorato/` — complete file list (22 files, `ls`, 2026-09-08)

`ARTIFACT-ACCOUNT-INDEX.txt` · `ARTIFACT-ACCOUNT-META.pjs` · `ARTIFACT-ACCOUNT-META.pjs.sha256` ·
`ARTIFACT-ACCOUNTS-AFTER-WRITER.pj0` · `ARTIFACT-ACCOUNTS-FINAL.pj0` · `ARTIFACT-ACT-EVENTS.pj0` ·
`ARTIFACT-DEATH-EVENTS.pj0` · `ARTIFACT-DEATH-WORLD-CELLS.txt` · `ARTIFACT-DEATH-WORLD-LEDGER.txt` ·
`ARTIFACT-MANIFEST.txt` · `ARTIFACT-SHA256SUMS.txt` · `ARTIFACT-WORLD-CELLS.txt` ·
`ARTIFACT-WORLD-LEDGER.txt` · `run-specimen.lisp` · `RUN-SPECIMEN-SECOND.txt` · `RUN-SPECIMEN.txt` ·
`specimen-common.lisp` · `stage-damage.lisp` · `stage-death.lisp` · `stage-reader.lisp` ·
`stage-writer.lisp`

The one spec-like file in that directory is `ARTIFACT-MANIFEST.txt` (M6); it is quoted below.

### Short names used in the clause sections

`SA0-RECEIPT` = S1 · `SA0-PROD` = S2 · `SA0-PKG` = S3 · `SA0-CONTRACT` = S4 ·
`SA0-API-DELTA` = S5 · `SA0-CD0` = S6 · `SA0-MATRIX` = S7 ·
`ML0-SPEC` = M1 · `ML0-GUIDE` = M2 · `ML0-RETURN` = M3 · `ML1-CHARTER` = M4 ·
`ML0-MANIFEST` = M6.

---

## SURFACE ACCOUNT CLAUSES

> **Standing caveat carried into every quotation below.** The ADOPTED artifact
> (`SA0-PROD` + `SA0-PKG`) is the **identity mechanism only** — nine exports, listed at
> `SA0-PKG:34-47`: `initialize-image-identity` · `identity-ready-p` · `image-epoch-hex` ·
> `image-epoch-datum` · `epoch-gatherings` · `election-count` · `mint-performance-identifier` ·
> `performance-identifier-shape-p` · `lawful-counter-text-p`. The doors, the inspector,
> the manifest and the CD/0 inspection record are in `SA0-CONTRACT` / `SA0-API-DELTA` /
> `SA0-CD0`, all of which label themselves **not implemented**. Every clause tagged
> [CANDIDATE] below is a proposal, not adopted authority.

### (a) What may be SAID about an execution — observed vs asserted, "account" vs "authentication", claim ceilings

**[ADOPTED] `SA0-PROD:130-132`** — the lane's own claims ceiling, in the source:

> THE CLAIMS CEILING IS UNCHANGED AND UNIMPROVED BY THIS.  Sixteen OS-random
> octets buy IMPROBABLE COLLISION, never a uniqueness guarantee, and no
> cross-image uniqueness is claimed anywhere in this lane.

**[ADOPTED] `SA0-PROD:60-61`** — a presence fact is not a standing fact:

> ;;;; unbound, so "the package exists" NEVER means "this lane is loaded" —
> ;;;; and FBOUNDP alone never means "this is the public API" either

**[ADOPTED] `SA0-PROD:76-77`** — the support ceiling:

> ;;;; BOUNDARY: qualified external CD/0 symbols only; no other provider is
> ;;;; touched.  Supported: SBCL 2.4.6 on Linux, nothing else tested.

**[ADOPTED] `SA0-RECEIPT:55-60`** — the adopted round's own account-vs-authentication line:

> - The **forged-package residual** (nine external counterfeits + pre-interned carrier
>   satisfying the guard) is real and **non-blocking**: the readiness predicate
>   establishes API shape under ordinary image composition and is not a security or
>   provenance boundary. The source phrase "interned only by actually reading the
>   implementation" is interpreted under the **non-forging package precondition**; the
>   carrier is a completeness marker, not cryptographic attestation.

**[CANDIDATE] `SA0-CONTRACT:24-26`** — the document's own ceiling:

> **Claims ceiling.** This is a contract *candidate* returned for owner review.
> It claims design completeness relative to the commission's checklist and
> nothing else.

**[CANDIDATE] `SA0-CONTRACT:29-35`** — the pure-projection law (adopted verbatim from the R1
adjudication, Section A), which fixes what the composite may say:

> - Door 1 may construct one sealed composite routing request.
> - Door 2 delegates exactly once and returns the exact native receipt plus
>   expanded host form.
> - A try door returns the exact native retained refusal, or a sealed
>   composite pre-delegation refusal where delegation never occurred.
> - The composite mints no completed receipt, occurrence, expansion-account
>   identity, or competing native-domain identity.

**[CANDIDATE] `SA0-CONTRACT:37-46`** — the deletion of an over-strong sentence:

> **What the composite DOES construct, said explicitly:** sealed composite
> **routing requests** (Door 1) and sealed composite **pre-delegation refusal
> records** (any door, where delegation never occurred). These are the
> composite's only artifacts. The unqualified sentence "the composite mints
> nothing" is **deleted from this contract** — it was one word too strong: the
> composite constructs the two artifact kinds above; what it never does is
> mint a completed receipt, an occurrence, an expansion-account identity, or
> any identity in a native domain.

**[CANDIDATE] `SA0-CONTRACT:90-93`** — the limitation carried everywhere:

> Consequence,
> carried as a claim limitation everywhere: **the composite cannot claim that
> rechecking any module version detects later redefinition of a head macro**
> (Control 6; `REFUSAL-AND-CONDITION-JURISDICTION.md` §5).

**[CANDIDATE] `SA0-CONTRACT:252-258`** — what a composite record claims, and the stored absence:

> - Therefore the composite record claims: *this record describes an
>   invocation performed by the named native engine against this request,
>   identified by the native request/occurrence/receipt identities carried
>   unchanged.* The composite makes **no claim that these identities uniquely
>   name temporal invocations**, and its record schema carries an explicit
>   `temporal-uniqueness: not-claimed` standing field so the absence is a
>   stored fact, not a silence.

**[CANDIDATE] `SA0-CONTRACT:265-267`**:

> - The composite never writes "one occurrence" in any record. The commission's
>   phrase "on one occurrence" is satisfied per-record by *describing exactly
>   one delegated invocation*, not by claiming global temporal uniqueness.

**[CANDIDATE] `SA0-CONTRACT:397-398`** — the purity law's ceiling:

> **This earns only the named same-image stability
> claim** and nothing cross-image.

**[CANDIDATE] `SA0-CONTRACT:868-872`** — the forbidden sentence and the lawful one:

> 4. **The forbidden sentence:** "expansion accounts for all seven heads under
>    both operations" is false on E2 and may not appear in any artifact of
>    this lane. The lawful sentence is: *an account where the native machine
>    completes; a retained, inspectable refusal where it refuses.*

**[MEASUREMENT] `SA0-MATRIX`, last data rows** — verification is absent, and its absence
is measured, not inferred:

> BOTH (cross-provider) | can either provider's verifier authenticate the other's receipt? | LISP-PLUS-SURFACE2:VERIFY-RECEIPT on an S1 receipt | unavailable | no bearer -- no public accessor exists | yes -- it SIGNALLED SURFACE2-EXPANSION-REFUSED rather than returning a verdict | There is no cross-provider verification and none may be inferred. Surface /1 has no verifier at all.

> LISP-PLUS-SURFACE1 (Surface /1) | verifier output | (no public verifier exists) | unavailable | no bearer -- no public accessor exists | yes -- VERIFY-RECEIPT absent from the 80 external symbols | CONFIRMS the commission: Surface /1 has no public receipt verifier. An account wanting one must derive its own check and must not call it verification of the provider's minting.

### (b) Statuses and epistemic markers — who sets them, candidate vs adopted, arms travelling with summaries

**[PROPOSAL] `SA0-API-DELTA:3-6`** — the proposal marker in the first line of the document:

> **Parcel item 12.** Proposed, **NOT implemented**. Every name, row, and
> count below is a proposal for the future governed production round
> (`R4-SURVIVAL-PLAN.md`); nothing exists in the accepted tree, and this
> round creates none of it.

**[PROPOSAL] `SA0-API-DELTA:8-9`** — who authored, and what the authorship is not:

> **Author:** Claude Fable 5 (JURIST seat). Same-family cross-checks, not an
> independent audit.

**[PROPOSAL] `SA0-CD0:33-38`** — a document that is authoritative over its subject while
having no implementation standing:

> **Standing.** Proposed design, not implemented; the schema binds the future
> production round. The inspector's output is a **direct inert CD/0 record
> datum** — never a private Account wrapper, never a newly admitted semantic
> account object.

**[PROPOSAL] `SA0-CD0:5-8`** — precedence between documents:

> **This file is the authoritative schema.** Contract I.8b defers
> to it; where any prose elsewhere disagrees, these tables win.

**[CANDIDATE] `SA0-CONTRACT:370-372`** — the mandatory-standing law (absence is a value, never
a missing field):

> - **No optional field changes a branch schema**: every listed key always
>   present, every unlisted key never present; value-absence is a mandatory
>   `("standing" …)` identifier datum, never a missing field and never `NIL`.

**[CANDIDATE] `SA0-CONTRACT:769`** — the "absent" standing carried as a stored value:

> | Native antecedent construct identity — **a mandatory field, always present** (R2 Section F: "where publicly available" deleted from this fixed schema) | value is either the native identity datum carried unchanged from the delegate lane's public API, or the mandatory standing datum `("standing" "absent-no-public-antecedent")` | durable either way; absence is a stored standing, never a missing field |

**[CANDIDATE] `SA0-CONTRACT:860-866`** — the invoked-but-no-account standing:

> 2. **Invoked-no-completion-account standing:** where invocation occurred and
>    the result could not be represented (the STOP cells' shape — **ratified
>    as lawful current composite outcomes by owner adjudication Locked
>    Ruling 2**: both heads remain admitted and requestable; the native
>    retained refusal is the truthful outcome; no completed account exists
>    for either), the retained fact says so explicitly; it never implies
>    nothing happened (jurisdiction §6).

**[PROPOSAL] `SA0-CD0:230`** — a status vocabulary that is *condition-only* and may never
appear in a record:

> The inspector's validation codes (`not-an-admitted-account-object`, `native-detail-not-string`, `native-detail-not-cd0-scalar-string`, `detail-string-exceeds-ceiling`) are **condition codes only** — the inspector signals, it never returns a branch-5 record, so they never appear in this key.

**[ADOPTED] `SA0-RECEIPT:53-54`** — the ruling's own status label carried into the receipt:

> - The identity mechanism, `/0 → /2` inhabitance, and frozen R3.3.3 regressions are
>   **PASS — LOCKED**.

### (c) Provenance and lineage — what a record must carry, validated-by-door analogues

**[MEASUREMENT, normative by Locked Ruling 5] `SA0-MATRIX`** — the ten provenance labels and
their populations (counted from column 4 of the 85 data rows):

| label | rows |
|---|---|
| `receipt-stored` | 30 |
| `provider-current-declaration` | 16 |
| `request-stored` | 12 |
| `refusal-record-stored` | 9 |
| `unavailable` | 6 |
| `account-derived-check` | 6 |
| `occurrence-stored` | 2 |
| `condition-stored-reference` | 2 |
| `provider-recomputation` | 1 |
| `provider-derived-projection` | 1 |

**[MEASUREMENT] `SA0-MATRIX`, S1 procedure-identity row** — the live-declaration trap, named:

> LISP-PLUS-SURFACE1 (Surface /1) | procedure IDENTITY 'of the receipt' | LISP-PLUS-SURFACE1:EXPANSION-RECEIPT-PROCEDURE-IDENTITY | provider-current-declaration | the LIVE provider image at read time -- NOT any artifact | yes -- returned a value for NIL, 42 and "not-a-receipt" | THE TRAP. surface1.lisp:1073-1074 is (defun expansion-receipt-procedure-identity (r) (declare (ignore r)) (expansion-procedure-…

**[MEASUREMENT] `SA0-MATRIX`, request-stored rationale (repeated on the request rows)**:

> Row added R0 post-review (ADVERSARY F3, entered by JURIST): the request is its own bearer. A request is not a receipt and not an occurrence; labelling a request-borne fact receipt-stored would assert a bearer that does not bear it -- the same argument as the refusal-record rows.

**[MEASUREMENT] `SA0-MATRIX`, account-derived-check rationale**:

> This is an ACCOUNT-DERIVED CHECK over one stored value and one live declaration. It is not a provider fact

**[CANDIDATE] `SA0-CONTRACT:290-296`** — identity distinctness:

> ```text
> composite request identity  ≠  native occurrence identity  ≠  native receipt identity
> ```
>
> The composite mints **no identity in the native domains** and performs no
> cross-provider identity comparison (the domains are measured-disjoint;
> `READER-PROVENANCE-MATRIX.tsv` receipt-identity rows).

**[CANDIDATE] `SA0-CONTRACT:299-302`**:

> The composite record describes its own
> delegation; it must not claim identity with any *separately* invoked native
> occurrence (same law as the conditional mint, Part II.6).

**[CANDIDATE] `SA0-CONTRACT:756-759`** (Part II, the /1 mint — reserved, not built):

> **The new account
> describes its own invocation.** It must not claim identity with any
> separately invoked native Surface /1 or Surface /2 occurrence — even for an
> inherited head expanded to an `EQUAL` result; sameness of outcome is not
> sameness of occurrence, and no cross-domain identity comparison is licensed.

**[CANDIDATE] `SA0-CONTRACT:377-378`** — the inspector reads the artifact, never the live world:

> - The inspector reads **only the admitted artifact** — never any live
>   declaration; no `current-at-inspection` field exists in any branch.

**[CANDIDATE] `SA0-CONTRACT:778`** — mint-time storage as the repair of the live-declaration trap:

> | Account grammar/procedure/policy identities **and mint-time versions** | account-stored **at mint time** — the repair of the measured native trap (E6): identities are stored, not recomputed from live declarations | durable |

### (d) Obligations and dependencies — preconditions, what a consumer may rely on

**[ADOPTED] `SA0-PROD:58-74`** — the load-time precondition, and what a loader must guard on:

> ;;;; it.  Consequence (STRANGER's R4 finding): a load that fails AT the
> ;;;; initialization leaves the package present with those five exports
> ;;;; unbound, so "the package exists" NEVER means "this lane is loaded" —
> ;;;; and FBOUNDP alone never means "this is the public API" either (the
> ;;;; owner's R4.3 counterexample: nine INTERNAL fbound dummies satisfied
> ;;;; the R4.1 status-blind guard).  Every loader of this lane must
> ;;;; therefore guard on EXTERNAL-API completeness — every declared name
> ;;;; present with FIND-SYMBOL status :EXTERNAL and FBOUNDP, and the
> ;;;; identity carrier symbol present — repairing an incomplete package by
> ;;;; re-applying package.lisp BEFORE this file, and asserting the same
> ;;;; predicate after the load, as production/load.lisp and the umbrella's
> ;;;; SURFACE-ACCOUNT-API-COMPLETE-P row do (R4.3).  A fresh image gathers;
> ;;;; a reload observes (same epoch, counter continues); a recursive load
> ;;;; inside an unfinished initialization defers to its owner; a failed
> ;;;; image is terminal — and in a terminal image the five late exports
> ;;;; never become defined, which is exactly why the guarded loaders refuse
> ;;;; rather than certify.

**[ADOPTED] `SA0-PKG:11-20`** — the repair instrument and its fail-closed clause:

> ;;;; THIS FILE IS ALSO THE REPAIR INSTRUMENT (R4.3): when the loader's
> ;;;; completeness predicate finds the package present but INCOMPLETE (a
> ;;;; half-load, a pre-created namesake with internal or partial dummies, an
> ;;;; empty namesake package), production/load.lisp re-applies this
> ;;;; DEFPACKAGE before loading the implementation. […]
> ;;;; A genuine name conflict
> ;;;; (some package USING this one with a clashing accessible symbol)
> ;;;; signals and propagates: fail closed, never silent acceptance.

**[CANDIDATE] `SA0-CONTRACT:214-218`** — Door 2's dependency recheck, and what a difference means:

> 2. Recheck the manifest binding captured at Door 1 against the /0 manifest
>    declaration. **The /0 manifest is immutable** (adjudication Section C):
>    no lawful movement exists inside /0, so any observed difference is
>    evidence of corruption or tampering — an **integrity alarm**, never a
>    version-movement event.

**[CANDIDATE] `SA0-CONTRACT:222-228`** — exactly-once delegation, no fallback:

> 3. Delegate to the **matching** native `PERFORM-EXPANSION`, exactly once.
>    Never retry, never fall through, never invoke the other provider, never
>    substitute a caller procedure.
> 4. Return **the exact native receipt** and the expanded host form as the
>    delegate returned them (pure-projection law, I.0). Door 2 performs no
>    projection; the inspector is the only projection source, called
>    separately by the caller if wanted.

**[CANDIDATE] `SA0-CONTRACT:867`** — the global no-retry law:

> 3. **Nothing retries.** Any door, any species, any outcome.

**[CANDIDATE] `SA0-CONTRACT:319-326`** — the closed union and its immutability (what a consumer may rely on, forever):

> There is **no reserved sixth entry in this union, and there
> never will be** (R2 adjudication, Section B): the /0 inspector — its
> function identity, its schema, and this five-member domain — is
> **immutable**. A future /1 does not extend it; /1 introduces its **own
> distinct inspector** with its own schema and its own public
> package/function address (Part II.5b).

**[CANDIDATE] `SA0-CONTRACT:857-859`** — the cross-cutting dependency prohibition:

> 1. **Surface /0's no-version absence is preserved** as a stored explicit
>    absence everywhere a version column exists. No redefinition-detection
>    claim through module versions, ever (Control 6; jurisdiction §5).

**[PROPOSAL] `SA0-API-DELTA:133-141`** — floor arithmetic derived from rows, never asserted:

> **Floor arithmetic is derived from actual verify-release rows, never from
> internal self-test assertion counts** (adjudication Section G): the lane's
> self-test may hold hundreds of assertions behind one gate row, and an
> assertion does not become a release-floor row merely because it exists. A
> row is one gate invocation in `verify-release.sh`.

### (e) Retention, regeneration, materialization — what persists, hashes standing for objects, forged records

**[ADOPTED] `SA0-PROD:19-20, 30-32`** — the once-only gathering and the one constructor:

> ;;;;   * exactly one epoch gathering: sixteen octets from /dev/urandom, one
> ;;;;     lowercase-hex textual projection;

> ;;;;   * a mutex-linearizable allocator (counter starts 0, first allocation 1)
> ;;;;     and the ONE performance-identifier constructor
> ;;;;     ("performance" <epoch-hex> <counter-decimal>);

**[ADOPTED] `SA0-PROD:736-739`** (docstring of `epoch-gatherings`) — what persists across a reload:

> "How many epoch gatherings this image has performed through the
> initialization path.  Zero before initialization, one afterwards, forever.

**[ADOPTED] `SA0-PROD:69-70`** — regeneration semantics across loads:

> ;;;; SURFACE-ACCOUNT-API-COMPLETE-P row do (R4.3).  A fresh image gathers;
> ;;;; a reload observes (same epoch, counter continues); a recursive load

**[ADOPTED] `SA0-PROD:1167-1171`** (the canonical-alphabet comment) — one spelling per object,
because a second spelling is a second name for one thing:

> ;;; THE ALPHABET IS THEREFORE AN EXPLICIT SET OF ASCII CHARACTERS, and the test
> ;;; is membership in that set by FIND, which compares with EQL — exact character
> ;;; identity.  No DIGIT-CHAR-P, no Unicode numeric property, no locale-sensitive
> ;;; classification, and no PARSE-INTEGER-as-admission: parsing may only happen
> ;;; downstream, after the shape has already been admitted.

**[ADOPTED] `SA0-PROD:1194-1198`** (docstring of `lawful-counter-text-p`) — the two-spellings defect:

> R3 required only \"nonempty and every character a digit\", which admitted \"0\"
> (no allocation ever returns it — the first is 1) and admitted \"007\" (a second
> spelling of a counter that already has one, so two distinct identifier datums
> would name one allocation).

**[ADOPTED] `SA0-RECEIPT:55-60`** — forged-package handling (see (a); the forged carrier is
"a completeness marker, not cryptographic attestation").

**[CANDIDATE] `SA0-CONTRACT:279-285`** — what is sealed and what is deliberately inert:

> **The account-inspection-record is NOT a sealed semantic object.** The R1
> text that sealed it is **withdrawn** (R2 adjudication, Section A): the
> inspector's output is a **direct inert CD/0 record datum** — constructed
> through the accepted public CD/0 API, inert by CD/0's own immutability, and
> owned by no Account wrapper ontology.

**[CANDIDATE] `SA0-CONTRACT:202-207`** — no second copy of a caller's tree:

> 4. Seal the result: the composite request carries {species tag, the native
>    request object unchanged, the manifest row binding, manifest
>    identity+version, schema version}. **No caller-owned cons tree is
>    retained**

**[CANDIDATE] `SA0-CONTRACT:780`** — an explicit never-durable row, existing only to state the exclusion:

> | Macro-function anchor — **adopted for the /1 mint, unconditionally** (R2 Section F: "if adopted" deleted; the adoption was already adjudicated in jurisdiction §5) | image-local inspection state | **never durable, never in canonical data** — this row exists in the schema table only to state that exclusion; the anchor is not a canonical-record field |

**[PROPOSAL] `SA0-CD0:108`** — the ceiling that refuses rather than truncates:

> | `detail-string-exceeds-ceiling` | a representable scalar string above 1024 payload octets (1024 passes; 1025 refuses) — **never truncation**: a truncated detail would be a lossy datum, and no lossy datum is manufactured |

**[PROPOSAL] `SA0-CD0:44-49`** — the canonical key order, and the deletion of a "first field":

> **Key-order law.** CD/0's canonical record key sorting is **authoritative
> and exhaustive**: `make-record-datum` sorts entries by octet comparison of
> each key's encoded identifier ValueBytes and rejects duplicates
> (`cd0.lisp`, `%normalize-record-entries` — read this round). **No semantic
> field is "first"**; any earlier prose claiming a physical first field is
> deleted.

---

## MEMORY LAYER /0 CLAUSES

> **Standing caveat.** The stone's TERMINAL STANDING (SOURCES above) is ADOPTED AND
> PUBLISHED with P9 OPEN. The frozen object's own documents (`ML0-SPEC`, `ML0-GUIDE`,
> `ML0-RETURN`, `ML0-MANIFEST`) still carry candidate-era headers; ADDENDUM 18 item 4
> discloses this as deliberate (SILENCES §S-4). Quotations below are from the frozen
> object; their **standing** is the stone's sentence, not their own headers.

### (a) What may be SAID about an execution

**`ML0-SPEC:59-64`** — the law, non-negotiable:

> ```text
> ISSUED(evidence, act)        ⇏ OCCURRED(act)
> DURABLE(evidence)            ⇏ OCCURRED(act)
> RETRIEVED(memory-account)    ⇏ CURRENT-IMAGE-EVIDENCE(memory-account)
> RETRIEVED(memory-account)    ⇏ AUTHORIZED-TO-CONTINUE(act)
> ```

**`ML0-SPEC:66-67`**:

> **The RED disease in one sentence: evidence-present is treated as
> occurrence-present.**

**`ML0-SPEC:73-79`** — the pinned proposition, carried verbatim in code:

> `:occurred` warrants **exactly** this and nothing else — the constant
> `+ML0-OCCURRED-PROPOSITION+` carries it verbatim in code, and the specimen prints
> it into its own transcript:
>
> > **the governed protected effect associated with canonical act identity A
> > crossed/applied and is present in the declared journal/world universe under its
> > derived external-request identity**

**`ML0-SPEC:81-85`**:

> **It does NOT mean "`perform` was invoked."** A lawful refusal is itself an
> execution event — something genuinely happened in the language — whose *protected
> deed* did not occur. Reading `:occurred` as "an act was attempted" would make
> every refusal an occurrence and would quietly turn this lane into a duplicate of
> the execution axis.

**`ML0-SPEC:87-90`**:

> **Occurrence-standing is the later reader's EPISTEMIC STANDING toward this
> precisely named proposition.** It is not a fifth outcome axis: Architecture 0.1's
> four axes describe an outcome held by a live actor; this describes what a reader
> who was not there is entitled to say afterwards.

**`ML0-SPEC:99-100`** — the governing constitutional law carried across (L15, quoted by the
spec from `architecture/LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md:1553-1555`):

> > A process's unaided account of its own history is asserted testimony.
> > Observational standing requires a distinct, inspectable witnessing mechanism.

**`ML0-SPEC:109`**:

> | **AP-JRN-1** | *"A self-written adapter narrative remains asserted."* | `:lane-self-report` — including **every account this lane writes** — may corroborate and may provide provenance, and may never be the sole occurrence basis. |

**`ML0-SPEC:111`**:

> | **AP-CAN-6** | a settled label resting on self-report is **`adapter-truth-minting`** | the species leg of the promotion rule: no self-report and no issuance testimony can produce `:occurred`. |

**`ML0-SPEC:860-877`** — §10, Explicit non-implications (complete):

> A public reader of this lane may **never** conclude:
>
> - **that an act occurred**, from an issued evidence object, its digest, its
>   receipt, or any report describing it;
> - **that an act occurred**, from any account this lane wrote (they are all
>   `origin/self-reported`);
> - **that evidence was not issued**, from anything at all — the axis has no
>   negative member;
> - **that a retrieved account is current-image evidence**, or confers continuation
>   authority;
> - **that a successful validation upgrades** a reconstructed source to an
>   observation;
> - **that a `:could-not-look` is an absence**;
> - **that an account's durability** exceeds the journal store's own declared
>   ceiling: an fsync-barrier host-contract belief on Linux ext4, never power loss,
>   never adversarial tampering, never a storage-stack proof.

**`ML0-RETURN:7-11`** — the claim ceiling in front of everything else:

> **CLAIM CEILING, verbatim and in front of everything else:**
>
> > **candidate · not audited · not adopted · not frozen · not registered ·
> > same-family hands · planted-death only · capability-disciplined never
> > capability-secure · no independent verification**

*(Bears on (a) and (b). NOTE: this ceiling is the pre-adoption ceiling of the RETURN
document; the stone's TERMINAL STANDING supersedes the "not adopted / not registered /
no independent verification" clauses for current navigation — `ARCHITECTURE-0-STATUS.md:1398-1400`.)*

**`ML0-RETURN:736-737`** — the commission's sentence:

> > **The language can remember what its account is entitled to say — and can
> > durably remember that it is not entitled to say more.**

**`ML0-MANIFEST:2`** — the same sentence in the specimen's own manifest:

> governing sentence: the language can remember what its account is entitled to say - and can durably remember that it is not entitled to say more.

### (b) Statuses and epistemic markers — who sets them, and what travels with a summary

**`ML0-SPEC:7-9`** — the in-file standing (candidate-era; see the caveat above):

> **STANDING: CANDIDATE.** Not adopted, not accepted, not frozen, not audited, not
> registered on any floor. Nothing in this lane is independent verification. The
> lane is capability-**disciplined** and never capability-**secure**.

**`ML0-SPEC:221-236`** — the occurrence-standing vocabulary and who may set each member:

> ### Occurrence standing — `:occurred | :nonoccurred | :unresolved | :contradicted`
>
> - `:occurred` **only** via the promotion rule (§7).
> - `:nonoccurred` **only** with the AP-REC-1-shaped four-part warrant, scope
>   declared, and `:could-not-look` kept distinct from looked-and-absent.
> - `:unresolved` is **the lawful default and is never a defect.**
> - `:contradicted` may be emitted **by consolidation only**, requires
>   **commensurable** warrants (§9), and preserves both.

**`ML0-SPEC:238-258`** — the issuance axis, two members, and the struck one:

> ### Issuance standing — `:issued-in-writing-image | :unresolved`
>
> **Exactly two members, and the shortness is the point** (AMENDMENT 1.1).
> […]
> **A scope does not repair that.** This lane shipped `:not-issued-in-scope` for
> part of its own build and then **struck it**: the account store never observes
> Core /0's registry at all, so no declaration of the store's boundaries can confer
> observational competence over a thing outside it. Scope narrows a claim a looker
> was competent to make; it cannot manufacture the competence. […]
> `:issued-in-writing-image` is **provenanced testimony by the writing process**,
> from the live predicate, in the image that minted — and it is *named for its own
> boundary* so no later reader can quote it flat as "issued".

**`ML0-SPEC:260-269`** — the third field, with its own vocabulary:

> ### Record coverage — a separate field with a separate vocabulary
>
> `:issuance-record-present-in-account-store | :no-issuance-record-in-account-store
> | :not-examined`
>
> *"No issuance record is present in THIS store"* is a true, checkable, **competent**
> statement: the account store is the universe of the look and this lane is
> authoritative over it. What it may never be read as is a statement about Core
> /0's registry — which is why it lives on its own field rather than as a shy
> spelling of `not-issued`.

**`ML0-SPEC:307-313`** — the three validation standings, the durable kind-marker:

> **A source row is one of two kinds of thing, and the kind is durable:**
>
> | standing | who may mint it | may it warrant occurrence? |
> |---|---|---|
> | `:VALIDATED-BY-DOOR` | **a production door of this lane, through the exported, supported API** […] | yes, subject to the other eight legs |
> | `:ASSERTED-TESTIMONY` | anyone, through the public `make-ml0-source` | **never**, however complete its fields |
> | `:STORED-ASSERTION` | **readback, always** — carrying the bytes' own claim separately as `recorded-validation` | only by INHERITING a recorded door validation, as testimony, never as a fresh look |

**`ML0-SPEC:321-325`**:

> **⚠ TESTIMONY IS NOT A WEAKER OBSERVATION. IT IS A DIFFERENT KIND OF THING.** A
> memory layer must be able to record *"this is what was said"* durably and
> faithfully, and must never be able to promote it. The blocked build had one
> category where there needed to be two.

**`ML0-SPEC:193-197`** — `:not-examined` under `:could-not-look`, and why:

> `ml0-observe-record-coverage` is that scan: it walks the whole
> validated prefix of this lane's own store, opens every account frame through
> `ml0-retrieve`, and answers on what it found — reporting `:not-examined` under a
> `:could-not-look` scope when the prefix is not `:valid`, because *I could not
> look* and *I looked and it is not there* are different sentences.

**`ML0-SPEC:200-203`** — the difference is a door, not a field:

> The difference between an assertion and an observation is not a field a
> caller fills in; it is a door the exported, supported API gives no way to impersonate

**`ML0-SPEC:175-187`** — the caller-asserted stamp on the effect axis:

> **⚠ R4 — QUESTION 4 IS ANSWERED BY TESTIMONY, AND THE ACCOUNT NOW SAYS SO.** […]
> Every effect observation
> now carries `provenance = :caller-asserted`, **in the type and in the durable
> bytes**; the mark is not a constructor parameter (a caller that could set
> `:door-read` would have exactly the field-filling power this lane's repairs exist
> to remove), and bytes claiming any other provenance are **refused** at `ML0-RB-5`
> rather than best-effort decoded.

**`ML0-GUIDE:42-44`** — the three-row lawful-use table (who produces which standing):

> | say something durable about an act | `make-ml0-source` (public) | `:ASSERTED-TESTIMONY` — carried, retrievable, **can never warrant occurrence** |
> | establish that something happened | a **production door**: `ml0-observe-world`, `ml0-observe-journal`, `ml0-observe-reconciliation`, `ml0-observe-absence`, `ml0-observe-issuance` | `:VALIDATED-BY-DOOR` — the door READ the substrate and derived every field from it |
> | carry a past account's warrant into a new process | `ml0-retrieve` (never `ml0-account-from-event`) | `:INHERITED-FROM-VALIDATED-RECORD` — the store's frame chain verified first |

**`ML0-MANIFEST:4`** — the arms travelling with the artifact record:

> CANDIDATE. Not adopted, not audited, not frozen, not registered on any floor. Crash model: planted deterministic process death only (no SIGKILL, no power loss, no mid-instruction truncation). Capability-disciplined, never capability-secure.

**`ARCHITECTURE-0-STATUS.md:1392-1396`** — the arms the stone requires to travel with every summary:

> 5. **Explicit BLOCKED and NOT-TESTED arms, travelling with every summary:** P8 forged-record discriminator BLOCKED — PROBE HARNESS ·
>    P10 real-gate injected-failure arm NOT TESTED BY THE STRICT STRANGER · P3 direct act-journal/world-ledger measurement NOT TESTED ·
>    P5 direct-versus-derived mutation arm NOT TESTED. The Phase-C documents (deviation ledger, corrected register, NOT-TESTED ledger,
>    supplement return, seal) were never auditor-authored; the register above is the chair's.

### (c) Provenance and lineage — act journal, world ledger, succession, durable account of its own act

**`ML0-SPEC:48-55`** — what the lane is, in one paragraph:

> After One Act, durable runtime bytes exist (capability /2's journal) and durable
> world bytes exist (the effect adapter's files) — but **the LANGUAGE's durable
> account of its own act does not**. One Act /1's RETURN names that absence F-1 and
> grades its own third demonstration PARTIAL because of it. Memory Layer /0 builds
> the narrowest provenance-bearing **write / retrieve / consolidate** path that
> closes F-1 **without letting the account impersonate the event it describes**.

**`ML0-SPEC:153-160`** — the envelope's honest values:

> ```
> capture-boundary   boundary:memory-accounting   (not a kernel transition)
> capture-mechanism  witness:lane-self-report     (this lane witnessed nothing)
> origin             origin:self-reported         (origin:observed is UNMINTABLE
>                                                   here, in code — §7)
> recorder-principal principal:memorylayer0       (who wrote the row)
> subject-principal  principal:<the actor>        (whose act it is ABOUT)
> ```

**`ML0-SPEC:164-172`** — the six questions and the fields that answer them, independently:

> | # | Question | Field(s) |
> |---|---|---|
> | 1 | which act? | `act-id` (re-derived, byte-compared), `act-id-hex`, `subject-seat`, `subject-attempt` |
> | 2 | occurrence standing? | `occurrence-standing` + `occurrence-scope` |
> | 3 | issuance standing? | `issuance-standing` + `issuance-scope` — **a separate field, never folded into 2** |
> | 4 | world/effect? | `effect-observation` (a scoped reading of the adopted axis, **stamped `:caller-asserted`** — see below) |
> | 5 | why may it say this? | `sources` — one typed row each |
> | 6 | how derived? | `derivation` + `predecessors` — **set by the entry point, never by an argument (R4.1)**: `ml0-write` writes `:direct-write` with no predecessors, always; `ml0-materialize-consolidation` writes `:consolidation` with the carrier's predecessors |

**`ML0-SPEC:205-211`** — account identity is content-derived, in the `:claim` domain:

> **Account identity** is content-derived (a digest of the whole canonical body) in
> the **existing** kernel /0 domain **`:claim`** — an account is a *claim about* an
> act, not the act and not a receipt of one. `make-identity`'s own law forbids a
> host-derived name. Because the identity digests the whole body, **distinct
> provenance produces a distinct identity by construction**, which is what makes
> consolidation's "never deduplicate distinct provenance" a fact about the
> identities rather than a promise about the code.

**`ML0-SPEC:213-215`**:

> **Five identity species, never conflated:** act identity · attempt/process
> identity · evidence identity (which **does not exist** publicly — §8) · account
> identity · principal identity.

**`ML0-SPEC:315-319`** — the four rules of a door:

> **THE FIVE PRODUCTION DOORS** — `ml0-observe-journal`, `-world`,
> `-reconciliation`, `-absence`, `-issuance` — obey four rules: they READ their
> owning substrate through its public readers; they DERIVE every field from what
> they read rather than accepting it; they BIND the act identity; and they are the
> only callers that STAMP through the exported, supported API […]

**`ML0-SPEC:326-330`** — the door's own ceiling:

> **⚠ AND A DOOR ESTABLISHES ONLY WHAT IT READ.** Hand a door a world and it reports
> the truth about *that* world, recording which world by its digests. No door
> authenticates a substrate's provenance; this lane remains
> capability-**disciplined**, never capability-**secure**.

**`ML0-SPEC:384-397`** — the promotion rule, nine legs, of ONE source:

> `:occurred` requires ALL NINE, together, **of one source**:
>
> | # | Leg | Requirement id |
> |---|---|---|
> | **0** | **validation** — the row is door-validated, or carries a recorded door validation. **Every other leg reads a field; this one asks whether anyone looked.** | `ML0-PROMOTE-0` |
> | 1 | **species** — a species that may warrant occurrence | `ML0-PROMOTE-1` |
> | 2 | **attestation** — the source attests `:frontier-crossed-for-this-identity` | `ML0-PROMOTE-2` |
> | 3 | **subject identity** — byte-equal to the act identity re-derived for this account | `ML0-PROMOTE-3` |
> | 4 | **acquisition route** — inside the closed ratchet set | `ML0-PROMOTE-4` |
> | 5 | **declared scope** — present, status `:looked`, non-empty universe and interval | `ML0-PROMOTE-5` |
> | 6 | **frontier/sequence relation** — declared, non-empty | `ML0-PROMOTE-6` |
> | 7 | **canonical payload** — a 64-hex digest of the bytes read | `ML0-PROMOTE-7` |
> | 8 | **provenance** — producer + recorder principals + the origin the source's own bytes carried | `ML0-PROMOTE-8` |

**`ML0-SPEC:398-400`**:

> **⚠ THE BLOCKED BUILD HAD ONLY LEGS 1–8, AND ALL EIGHT WERE FIELDS A CALLER COULD
> FILL.** That is exactly why a forged row minted `:occurred` for an act whose
> derived standing was `:ABSENT`. Leg 0 is the repair.

**`ML0-SPEC:409-417`** — the source species table (the seven species, may/forbidden):

> | Species | May warrant | Forbidden to warrant |
> |---|---|---|
> | `:kernel-mediated-journal` — cap2 frames (`origin/observed`, `principal:kernel-store`), read via the public fold over the **validated prefix** | occurrence (one leg) | — |
> | `:world-bytes` — the world's own files: ledger row + digests | occurrence (one leg) | — |
> | `:reconciliation-conjunction` — `act1-reconciliation-closes-seat-p`, a joint reading of world **and** journal | occurrence | — |
> | `:lane-self-report` — ANY `origin/self-reported` narrative, **including this lane's own accounts** | corroboration, provenance | **sole occurrence basis** |
> | `:core0-issuance-testimony` — a Core /0 evidence account, its digest, its receipt, or a report describing it | issuance testimony (in the issuing image only) | **occurrence, in any direction, ever** |
> | `:scoped-negative-observation` — a look across a declared universe that found the subject absent | nonoccurrence (scoped) | unscoped nonoccurrence |
> | `:account-reconstruction` — successful validation of durable account bytes | account integrity | origin upgrade, occurrence, issuance |

**`ML0-SPEC:441-447`** — the origin ratchet:

> `:live-query | :reconstructed`, taken verbatim in shape from capability /0
> (`receipts.lisp:25-33`). **`:observed` is not a member, on purpose**, and passing
> it is refused in code by an `ecase` rather than documented and hoped for.
> Successful validation of a reconstructed account **upgrades nothing**: retrieval
> copies every source's route through unchanged and its own retrieval origin is
> always `:reconstructed`.

**`ML0-SPEC:450-453`** — the origin gate:

> `origin/observed` is **unmintable by this lane, in code**: the gate sits on the
> only identifier constructor the lane uses. A source's `origin-as-read` field
> records what the bytes carried as a CD/0 **string**, never as an identifier — a
> report *about* a field, not a claim *of* it.

**`ML0-MANIFEST:5-8`** — three jurisdictions, three stores, three digests:

> THREE JURISDICTIONS, three stores, three digests:
> act journal store id  : pj0-store:7f1f2f0efb634ee79b1b194239f3384b37eca11d817239045bb50bb648d2d0be
> account store id      : pj0-store:b98dc1256e2318b64ece791bd9d6537548a147299ec45bc28d4ceb00eb65169c
> (they are DIFFERENT stores in different directories with different nonces)

**`ML0-MANIFEST:15`** — the D3 state, a world row with no accounting process:

> DEATH-WORLD-LEDGER.txt: 68 octets  sha256 9b1373ae63cafeaef774978dd12ddf6a57c613e2bf0aade83373421f1ce3da24  (ONE applied row, made by a process that did not live to account for it - the state D3 answers)

### (d) Obligations and dependencies — preconditions, "supports", consolidation, rederivation, what a consumer may rely on

**`ML0-SPEC:119-122`** — the adopted vocabulary that binds this lane:

> **Adopted vocabulary used instead of new coinages** — Retrieve is **evidence
> replay** (Architecture 0.1 **D6** replay triad), never execution replay and never
> output reproduction. Consolidation obeys **D4** verbatim: *"cross-journal merges
> are receipt-bearing transformations, never timestamp sorts."* Authority obeys
> **D5/DK-3**: a record that authority existed is not authority.

**`ML0-SPEC:248-253`** — the precondition on any absence claim:

> the account store never observes
> Core /0's registry at all, so no declaration of the store's boundaries can confer
> observational competence over a thing outside it. Scope narrows a claim a looker
> was competent to make; it cannot manufacture the competence.

**`ML0-SPEC:461-470`** — Write step 1, re-derive and byte-compare:

> 1. **Re-derive the act identity** from the declared fixture row alone, through
>    One Act /1's public **non-performing** seam (`make-act1-record :register nil`),
>    and compare byte-for-byte against the bundle's claim. Mismatch refuses
>    **pre-mutation**.
> 2. Every source must be about **this** act; a crossed source refuses
>    pre-mutation, whatever its species.
> 3. The promotion rule computes the occurrence standing **from the sources**. No
>    supported public call asserts a standing to it […]

**`ML0-SPEC:566-572`** — the issuance-only branch, kept rather than refused:

> **The issuance-only branch, chosen and public:** a bundle whose only positive
> source is issuance testimony is **stored**, under the typed public discriminant
> `ml0-account-issuance-only-p`, with occurrence `:unresolved`. It is not refused,
> because a lane that refused to remember *"evidence was issued for this act"*
> would lose a true fact in order to avoid a false one. The false one is prevented
> by the promotion rule, which is where it belongs.

**`ML0-SPEC:573-579`** — `ML0-WR-6`, self-contradiction refused pre-mutation:

> **A bundle may not contradict itself (`ML0-WR-6`).** One bundle carrying both a
> qualifying positive warrant and a **commensurable** scoped negative is refused
> pre-mutation. `:contradicted` is reserved to consolidation, so a write cannot say
> it […] A caller holding both writes them separately and consolidates — which is the only
> lawful route to `:contradicted`.

**`ML0-SPEC:582-583`**:

> **Write never** performs the act, issues or promotes Core /0 evidence, authorizes
> a capability, or infers occurrence from a successful serialization.

**`ML0-SPEC:642-648`** — the consolidation admission gate, and why authority is checked first:

> At least one `ml0-account` (`ML0-CON-1`), each of whose
> `ml0-account-standing-authority` is **`:validated-retrieval`** (`ML0-CON-3`) — i.e.
> obtained from `ml0-retrieve`, or returned by a write, which reads its own frame
> back through `ml0-retrieve`. A **`:raw-decode`** account is **refused**: its
> standings were re-derived from rows that warrant nothing, and a caller-held frame
> may not vote. The authority gate runs **before** the act-identity comparison,
> because an unvalidated account's act identity is itself only a claim.

**`ML0-SPEC:652-658`** — `ML0-CON-4`, one subject:

> **ONE SUBJECT CARRIER (`ML0-CON-4`).** Inputs that share an act but not a
> `subject-seat` / `subject-attempt` / **`subject-principal`** are **refused**. […]
> A derived account has ONE subject and this lane will not pick one.

**`ML0-SPEC:695-705`** — the fold laws (what a consumer may rely on):

> - **Ordering:** lexicographic by content-derived account identity. No clock, no
>   arrival order, no caller order.
> - **Exact duplicates:** same account identity ⇒ one record.
> - **Distinct provenance is never collapsed** — by construction, since it produces
>   a distinct identity.
> - **`:occurred` only** where a qualifying basis **survives validation and is
>   named**; the rule is re-run over the union of sources, never inherited from the
>   inputs' standings.
> - **Contradiction preserved explicitly.** No last-write-wins, no majority vote.
> - **Cross-act refused before any output.**
> - **/0 never** compacts, forgets, tombstones, GCs, or erases provenance.

**`ML0-SPEC:740-751`** — `ML0-MAT-3`, the cross-store refusal, and the disclosed cost:

> **`ML0-MAT-3` — EVERY PREDECESSOR MUST BE RETRIEVABLE FROM THE TARGET STORE, SO
> CROSS-STORE MATERIALIZATION IS REFUSED.** A carrier computed over accounts of
> store A cannot be materialized into store B. […]
> A derived account whose predecessors the reading store cannot produce is a
> **lineage claim the store cannot check**, and this lane's argument throughout is
> that a reader checks rather than trusts. ⚠ **The cost is disclosed, not hidden:
> this NARROWS the cross-journal consolidation case named by Architecture 0.1's
> D4** (builder fork R4.1-F3).

**`ML0-SPEC:821-827`** — commensurability as a precondition on `:contradicted`:

> `:contradicted` requires **commensurable** warrants: the same proposition over a
> **compatible declared scope** and a **compatible frontier/sequence interval**.
> Same act identity plus opposite keywords is **insufficient**.
>
> The test is executable, not rhetorical (`ml0-warrants-commensurable-p`)

**`ML1-CHARTER:20-26`** — what /0 established that /1 inherits, and the boundary:

> **Governing law carried forward unamended:** Architecture 0.1 D4 — *cross-journal merges are
> receipt-bearing transformations, never timestamp sorts.* Memory Layer /0's `ML0-MAT-3` (every
> predecessor retrievable from the destination store) marks the boundary /1 would be built beyond.
>
> **What /0 already established that /1 inherits:** a carrier is an untrusted request; the store is the
> witness; `ISSUED(evidence, act) ⇏ OCCURRED(act)`; construction privacy is defense in depth, not the
> soundness boundary.

**`ML1-CHARTER:10-18`** — the four reserved questions (what a destination may honestly conclude):

> - **source-store identity**: what a derived account must durably say about the store its
>   predecessors came from;
> - **predecessor receipts**: what a destination carries per foreign predecessor (at minimum the
>   source store's identity, the predecessor's frame digest, and the validated-prefix status at
>   retrieval) so the lineage claim is checkable by something;
> - **offline verification limits**: what the destination can and cannot verify without the source
>   store present — it cannot re-read the source's bytes, and it must say so;
> - **what a destination may honestly conclude** about occurrence, issuance and coverage when the
>   warrants live in a store the reader cannot open.

**`ARCHITECTURE-0-STATUS.md:1172-1178`** (ADDENDUM 18 item 2) — the ceilings carried verbatim
at adoption:

> Ceilings carried
> verbatim: durable account survives its writer · occurrence requires its full admitted conjunction · warrant
> issuance cannot manufacture the warranted event · inadmissible evidence yields `:unresolved`, including
> when its conclusion is accidentally true · §5.A honest append-only failure semantics + mandatory pre-append
> dry decode · `/0` same-store only · receipt-bearing foreign lineage reserved to Memory Layer /1 · D6 PARTIAL
> · D4 SHOWN-AS-AMENDED · package privacy is defense in depth · same-family execution non-independent.

**`ARCHITECTURE-0-STATUS.md:1179-1180`** (ADDENDUM 18 item 3) — what the two words warrant:

> 3. **What the words warrant.** "Published" = public transport of the bound tracked bytes, not every semantic
>    claim those bytes contain. "Adopted" = the governance act. Neither discharges the stranger audit.

### (e) Retention, regeneration, materialization — process death, rederive-and-validate, hashes for objects, forged records

**`ML0-SPEC:538-544`** — §5.A as amended (AMENDMENT 2), the governing failure contract, verbatim:

> > Every refusal raised before `append-event` is observably non-mutating over the
> > whole declared store. Once `append-event` succeeds, a subsequent readback or
> > identity refusal returns no account and neither retracts nor rewrites durable
> > bytes. Any surviving bytes acquire no standing merely by surviving: they are
> > judged only through Journal /0 validation and Memory Layer /0 retrieval. Append
> > success, serialization success, and evidence or certificate issuance are never
> > evidence that the represented act occurred.

**`ML0-SPEC:546-550`** — required structure and prohibitions:

> > **Required structure:** the pre-append dry decode of step (4b) — *"A decoder or
> > identity refusal must therefore occur before mutation. The designed post-append
> > refusal residue should be host fault only."* **Prohibited:** *"Do not add
> > rollback, truncation, tombstones, or supersession. Do not reopen or edit Journal
> > /0."* None was added; Journal /0 was not touched.

**`ML0-SPEC:521-526`** — what a failed write leaves behind:

> - A refusal from the **readback** (`ML0-RB-*`) or from **`ML0-WR-5`** happens with
>   the frame **already appended**. The frame is **retained as evidence** — it is
>   what was actually written — and **no account is returned**, so nothing
>   downstream can read a standing off it. A caller comparing store scopes across
>   such a call **will** see the store change.

**`ML0-SPEC:471-478`** — step (4b), the pre-append dry decode:

> 4b. **THE DRY DECODE (R5, required by §5.A as amended — AMENDMENT 2).** Before the
>    append, the **exact** canonical event is encoded (`encode-pjs0`, the same
>    canonicalization `append-event` performs), decoded back (`decode-pjs0`,
>    **`:canonical` required**), run through **the exact account decoder**
>    (`%ml0-decode-account-event`, inherited-warrant route — the route `ml0-retrieve`
>    takes), and the identity it yields is compared to the identity just minted.
>    Any failure refuses at **`ML0-WR-8`** (`ml0-account-encoding-refused`)
>    **pre-mutation**

**`ML0-SPEC:587-594`** — Retrieve as evidence replay, and total refusal:

> Deterministic validate + fold + decode of one durable account, in a genuinely
> fresh process. Returns a `memory-account` **and nothing else**. Refusals are typed
> and **total**: a torn tail, an interior corruption, an unsupported rendering
> version, a missing field, a source/account identity disagreement, or a
> body/event-id disagreement produce a typed refusal and **no account** — because a
> plausible partial account is exactly the shape a reader would trust.
>
> Reading performs nothing, mints nothing, and acquires nothing. **Reading an old
> account does not make the archive-reader the same being as the original actor.**

**`ML0-SPEC:598-608`** — the raw route and internal-consistency checks (the forged-frame case):

> `ml0-account-from-event` decodes a **caller-held** frame with no journal
> validation whatever. R3 called that result *"explicitly inert"* — and that was
> prose. The rows were inert; the **standings were not**. The decoder read
> `occurrence-standing` off the caller's own bytes, checked it only against the
> four-word vocabulary, and installed it, so `ml0-account-occurred-p` answered **T**
> for a frame whose rows warranted nothing. The two internal checks that looked like
> defences (`RB-10`'s act identity, `RB-11`'s body digest) are **internal-consistency
> checks**: they prove the frame agrees with itself, never that `:occurred` follows
> from anything.

**`ML0-SPEC:610-620`** — the two new fields, and what a caller cannot have:

> | field | values | meaning |
> |---|---|---|
> | `standing-authority` | `:validated-retrieval` \| `:raw-decode` | which route produced the standings |
> | `carried-standings` | plist | what the **bytes** claimed, preserved verbatim |
>
> On the **raw** route the occurrence standing is **re-derived** from the decoded
> rows by the promotion rule […] Nothing is erased: the bytes' own claim sits in `carried-standings`, beside the
> lane's own answer. **A caller that wants the bytes' word can still have it; what
> it cannot have is that word wearing the authoritative reader's clothes.**

**`ML0-SPEC:622-627`** — `RB-11` no longer skips (the absence-without-a-warrant at the readback boundary):

> It used to run only when the frame carried an
> event-id of this lane's `w-`/`c-` shape, so a frame this lane does not recognize
> reached the authoritative type **with the check silently not made** — an
> absence-without-an-adequacy-warrant at the readback boundary: *no disagreement
> found* where the truth was *nothing was compared*. Such a frame is now refused.

**`ML0-SPEC:335-345`** — §6c, every lane struct is reader-proof (the `#S` forged-object route):

> Every argument this lane has made since R2 has at some point rested on the form
> `(:constructor %make-X)` — *"the constructor is INTERNAL, so a caller cannot
> assert one of these."* **That is not what the form does.** It suppresses the
> conventional `MAKE-X` function; it does **not** suppress Common Lisp's `#S`
> structure reader, which builds a structure from a literal and chooses every slot.
> An exported structure type was therefore publicly instantiable by anyone who could
> type its name — `ML0-ACCOUNT` with `:standing-authority :validated-retrieval`,
> `ML0-SOURCE` with `:validation-standing :validated-by-door`, both minted from
> outside the package. **Measured before it was repaired**: `RED-HASH-S-BEFORE.txt`,
> five struct types, five `CONSTRUCTED`.

**`ML0-SPEC:346-348`** — the BOA property, normative:

> **THE PROPERTY, NORMATIVE, AND IT HOLDS OF EVERY LANE STRUCT WITHOUT EXCEPTION:**
> each of the ten internal constructors in `ml0.lisp` is declared **BOA** —
> `(:constructor %make-X (&key slot …))`.

**`ML0-SPEC:675-682`** — R4.1c, the narrower facts, and the soundness boundary:

> ⚑ **R4.1c — THE NARROWER FACTS, IN PLACE OF ANY "ONLY WAY" CLAIM.** (1) **No
> constructor is exported.** (2) The supported SBCL `#S` **default-constructor**
> route is refused because all ten of the lane's structures use **BOA**
> constructors. (3) **Construction privacy is defense in depth, not the soundness
> boundary** — Common Lisp package privacy is not a capability boundary, and this
> spec rests no argument on it. What carries the weight is §8/Materialize:
> materialization treats a presented carrier as an **untrusted request**,
> re-retrieves its input identities from the target store, and writes the
> recomputed body. ⚠ **A carrier is not an account** — it has no identity and no
> frame, and holding one proves nothing durable.

**`ML0-SPEC:684-690`** — the carrier's mutable lists:

> ⚠ **AND A CARRIER'S LISTS ARE NOT FROZEN.** `:read-only t` makes a slot
> non-setfable; it does not freeze the cons cells `ml0-consolidation-sources` and
> `ml0-consolidation-predecessors` hand back. `rplaca` through those exported
> readers rewrote a lawful carrier's occurrence basis while its computed `:OCCURRED`
> still stood (`RED-CARRIER-BEFORE.txt`: `WRITTEN standing=:OCCURRED
> warranting-rows=0`). **The carrier is inspectable, not trustworthy**, and this
> spec no longer asks any reader to treat it as evidence of anything.

**`ML0-SPEC:723-732`** — the materialization contract, normative (rederive-and-validate):

> **THE CONTRACT, NORMATIVE.** Given a carrier, materialization:
>
> 1. takes the **identities** of `ml0-consolidation-inputs`, and nothing else from
>    the object;
> 2. **re-retrieves each input from the TARGET `store`** through `ml0-retrieve` —
>    the validated chain, inherited warrants and all;
> 3. **re-runs `ml0-consolidate`** over what the store actually returned;
> 4. builds the canonical account body that **each** carrier — presented and
>    recomputed — would produce, and compares their **digests**;
> 5. writes the **RECOMPUTED** body, never the presented one.

**`ML0-SPEC:733-739`** — `ML0-MAT-2`, refuse, never silently correct:

> **`ML0-MAT-2` — A DISAGREEING CARRIER IS REFUSED, NEVER CORRECTED.** If the two
> digests differ, the carrier is stale or altered and materialization refuses,
> naming both digests. **It does not quietly write the recomputed body in place of
> the presented one**: a caller holding a carrier that disagrees with the store is
> holding something it should be told about, and silently substituting the right
> answer would hide exactly the event this requirement exists to surface.

**`ML0-SPEC:777-779`**:

> **Nothing here recomputes a standing FROM A CALLER'S FIELDS and nothing here
> accepts one from a caller.** The standings written are those the store's own
> validated inputs fold to, computed inside this call.

**`ML0-SPEC:809-814`** — idempotence on event identity, measured against a wrong prediction:

> ⚑ **AND ONE PJ0 FACT THE PROBE MEASURED RATHER THAN ASSUMED (check [016]).** Two
> materializations of **byte-identical derived content** land on **ONE frame**:
> because the account identity digests the whole body, `append-event` is idempotent
> on event identity (PJ-APP-1..3).

**`ML0-RETURN:739-749`** — what stands, including the forged-certificate case:

> What stands, at candidate strength and no higher: a durable language-level account
> that survives its writer's death; that can be reconstructed by a process which
> inherits nothing; that says `occurred` **only** on a warrant a mint cannot
> manufacture; that remembers `evidence was issued` on a separate axis, named for
> its own boundary, without ever letting that fact become the other one; that says
> `unresolved` where the instrument that would settle it has no power to look; and
> that, presented with the exact artifact the repaired One Act /1 defect exposed —
> a genuine certificate for an act that never happened — writes it down, keeps it,
> and **refuses to call it an event**.
>
> **The certificate did not eat the event.**

**`ML0-MANIFEST:9-10, 16`** — the retention facts (prefix preserved, nothing rewritten;
byte-stability declared with its deviation):

> ACCOUNTS-AFTER-WRITER.pj0: 23792 octets  sha256 4ef1efaf236aa96a787b970efa15321c4ae2ad10ba44d46ce8bf0617636e7d06  (what the scriptor left)
> ACCOUNTS-FINAL.pj0: 72350 octets  sha256 d9d160f28deeda9e14703cd544ed700cb04369142f29ceaadfe03a6f2a42f700  (the SAME PREFIX byte-identically, plus the lector's appends - nothing rewritten)

> byte-stability: every file listed here is byte-identical across runs (fixed store nonces; declared PJ-META-1 deviation, see specimen-common.lisp)

---

## SILENCES

*Clauses where a text names its own limits, absences, or what it may not be quoted as.*

**S-1. Surface Account /0 — the adopted artifact does not contain the doors.**
`SA0-PKG:4-9` bounds the whole public surface at nine exports; `SA0-PROD:6-7` says the
file is "that mechanism given a package and an address, and NOTHING ELSE." `SA0-CONTRACT`
and `SA0-CD0`, which carry the account/inspector/manifest semantics, both say the design
is **not implemented** (`SA0-API-DELTA:3`; `SA0-CD0:33`). No clause anywhere in the
adopted artifact defines an "account of an execution."

**S-2. Surface Account /0 — no verifier exists, and none may be inferred.**
`SA0-MATRIX` (cross-provider rows, quoted in (a)): "There is no cross-provider verification
and none may be inferred. Surface /1 has no verifier at all." — and: "An account wanting one
must derive its own check and must not call it verification of the provider's minting."

**S-3. Surface Account /0 — the readiness predicate is not a provenance boundary.**
`SA0-RECEIPT:56-58`: "the readiness predicate establishes API shape under ordinary image
composition and is not a security or provenance boundary."

**S-4. Memory Layer /0 — the frozen object's candidate headers were deliberately left.**
`ARCHITECTURE-0-STATUS.md:1179-1182` (ADDENDUM 18 item 4):

> 4. **This addendum, the README rows and the floor's `ml0` carried row are administrative records
>    propagation** (Sol I §V) — not an ML/0 semantic repair, not a condition of the standing.
>    `package.lisp`'s candidate-era header and `FLOOR-RESULT.txt` inside the frozen object are left
>    as they are, disclosed here.

**S-5. Memory Layer /0 — the ten known holes, carried openly** (`ML0-SPEC:879`, the §11 heading; the section's ten numbered holes run to `:966`).
Headline sentences, verbatim:

- `ML0-SPEC:922-925` — "Still not a stranger's acceptance: a reviewer commissioned by the chair, reading the chair's tree, is an outside of *weights* and not an outside of *interest*. **The stranger audit is OWED.**" *(HISTORY as of `ARCHITECTURE-0-STATUS.md:1396-1400`; the obligation is discharged.)*
- `ML0-SPEC:940-942` — "**The effect axis has no door.** Question 4 is answered by caller testimony, now marked as such in the type and in the bytes, but marked testimony is still testimony."
- `ML0-SPEC:943-946` — "**The record-coverage door reads THIS store and nothing else**, which is the whole of its competence — and its `:issuance-record-present` finding means *an account in this store carries `:issued-in-writing-image` for this act*, never anything about Core /0's registry."
- `ML0-SPEC:951-961` — "**⚑ R4.1 — A GATE OF THIS LANE WAS FOUND DISARMED WHILE GREEN.** […] The class is the lab's *absence needs a warrant*: **a gate never seen to fire is untested, not passing.**"
- `ML0-SPEC:962-966` — "**⚑ R4.1 — THE SPECIMEN TRANSCRIPT IS NOT A WITNESS TO THE R4.1 SPECIMEN REPAIR.** […] A determinism twin is evidence about **one build against itself**, never about a build against its predecessor."
- `ML0-SPEC:881-888` — "**No public evidence identity or content digest exists.** […] It is not an evidence identity and two evidence accounts with the same projection are not thereby the same account."
- `ML0-SPEC:847-856` — "**⚠ An honest limit, stated rather than implied.** […] What is demonstrated is that the layer *preserves* such a clash rather than resolving it; what is **not** demonstrated is a clash arising naturally."

**S-6. Memory Layer /0 — the P9 defect, OPEN, disproving a shipped claim-ceiling comment.**
`ARCHITECTURE-0-STATUS.md:1382-1386` (ADDENDUM 24 item 4):

> 4. **The P9 claim-ceiling defect, OPEN:** `ml0-consolidation-proof.lisp:42` — "A caller outside the package cannot do this." — is
>    disproven: from `CL-USER`, `FIND-SYMBOL` + `SYMBOL-FUNCTION` on `%MAKE-ML0-SOURCE` constructs an `ML0-SOURCE` carrying
>    `:VALIDATED-BY-DOOR`. The narrower runtime result stands: all ten `#S` routes closed; durable materialization rederives and
>    validates. No supported-path runtime semantic failure is established.

**S-7. "Never 'independently verified'."**
`ARCHITECTURE-0-STATUS.md:1399-1400`: "This does not confer blanket \"independently
verified\" status." The permitted ceiling is the standing sentence quoted in SOURCES.

**S-8. Memory Layer /1 — reserved, carries no standing.**
`ML1-CHARTER:4-5`: "This file reserves a subject; it opens no lane, authorizes no build, and
carries no standing." And `ML0-SPEC:764-765`: "**`/1` was not built in this pass and the
charter opens no lane.**"

**S-9. What is NOT carried across from AP0.**
`ML0-SPEC:113-116`: "**What is NOT carried across, said plainly:** AP-REC-1's `:not-found`
machinery concerns a provider domain an adapter queries. This lane's negative reading is
about a *world ledger* it reads directly. The shape transfers; the jurisdiction does not,
and no artifact of this lane may cite AP0 as binding on it."

**S-10. Same-family authorship, stated in both lanes.**
`SA0-API-DELTA:8-9`: "Same-family cross-checks, not an independent audit." ·
`SA0-CONTRACT:11-12`: same sentence. · `ML0-SPEC:915-916` (hole 4): "Builder and chair are
one lineage. Nothing here is independent verification".

---

## UNVERIFIED

*Things this clerk did not establish, listed so nothing downstream banks them.*

**U-1.** `production/package.lisp` commit and blob were **not** queried. Its content was read
(quoted at `SA0-PKG:4-9, 11-20, 34-47`) but its identity line in SOURCES is blank rather
than guessed.

**U-2.** Nothing was executed. No SBCL, no self-test, no floor. Every count and every
"MEASURED" clause quoted above is quoted **as the text's own claim**, not as a fact this
clerk reproduced.

**U-3.** The Surface Account /0 status quote is from the stone's **ADDENDUM 14 state
refresh** (2026-08-19), which cites the adoption merge `6715d2c4` and receipt `fafa80aa`.
Neither the merge commit nor the published mirror tip named in `SA0-RECEIPT` was verified
in the repository during this sitting.

**U-4.** The `ML0-SPEC` header (`:7`) says CANDIDATE and the stone says ADOPTED AND
PUBLISHED. This clerk did **not** locate a clause inside the frozen ML/0 object that
carries the adopted standing; ADDENDUM 18 item 4 (S-4) explains the divergence as
disclosed and deliberate. A consumer must read the standing **from the stone**, never from
the object's own header. The precise scope of "left as they are" (whether it covers
`MEMORY-LAYER-0-SPEC.md`'s header specifically, or only `package.lisp` and
`FLOOR-RESULT.txt` as named) is **not established by the text quoted** — ADDENDUM 18 item 4
names only those two files.

**U-5.** `MEMORY-LAYER-0-WORK-ORDER.md` (M5) was listed with commit/blob but **not read or
quoted** in this sitting; its three amendments are known only through `ML0-SPEC`'s
citations of them.

**U-6.** `MEMORY-LAYER-0-RETURN.md` (200,950 octets) was read only at its head (`:1-108`)
and at `:725-790`. Clauses elsewhere in it are unread and may bear on (a)–(e).

**U-7.** `SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md` (52,047 octets) was read at `:1-100`,
`:180-420`, `:745-800`, `:840-875`, plus grep-located lines. `CD0-INSPECTION-RECORD-SCHEMA.md`
(26,542 octets) was read at `:1-60`, `:270-300`, `:350-400`. `READER-PROVENANCE-MATRIX.tsv`
was read at rows 1–40 and the last six rows, plus a full column-4 tally. Unread regions of
all three may bear on (a)–(e).

**U-8.** `de-actu-memorato/` was listed in full (22 files) and only `ARTIFACT-MANIFEST.txt`
was quoted. `run-specimen.lisp`, `specimen-common.lisp`, `stage-*.lisp` and the two
`RUN-SPECIMEN*.txt` transcripts were **not** read.

**U-9.** Every `FILE:LINE` citation in this document was checked mechanically after drafting:
the first quoted line of each block was located by content in the source file and the citation
corrected where it disagreed (42 citations corrected in one pass; the hand-arithmetic draft was
wrong on 29 of them, which is why the check was run rather than trusted). Citations name the line
of the **first quoted line**; end lines are the last quoted line and were not independently
re-measured. `ML0-SPEC` §11's heading is at `:879` per `grep -n "^## 11. Known holes"`.

---

*— CLERK-SA-ML0 (Claude Fable 5.1), 2026-09-08. Reading only: no execution, no tracked-file
modification, no commit.*
