# WARRANT CALCULUS /0.2 and LATENT MACHINE PRIMITIVES /0 — reader's entry point

*Written 2026-09-08 for publication. Nothing in this file is
adopted text; every adopted or accepted sentence quoted below is quoted verbatim from the
document that carries it, and named with its file and section so a reader can check it.*

---

## 1. What is in this directory

| file | what it is | status |
|---|---|---|
| [`WARRANT-CALCULUS-0.md`](WARRANT-CALCULUS-0.md) | the first extraction: twenty-one epistemic moves of one proof record, sixteen candidate names tested, **nine** forms surviving | **history** — superseded on its counts and on several definitions; kept whole |
| [`WARRANT-CALCULUS-0.1.md`](WARRANT-CALCULUS-0.1.md) | the repair under eight errata (E1–E8): `boundary` promoted, so **ten** forms; minimality claim withdrawn | **history** — superseded on its status rule and on one accounting sentence; kept whole |
| [`WARRANT-CALCULUS-0.2.md`](WARRANT-CALCULUS-0.2.md) | the repair under four further corrections (R1–R4) and one qualification (Q6), **plus ADDENDUM A and ADDENDUM B appended in the reviewer's own text** | **the governing document** (of this documentary reading; see §10) |
| [`WARRANT-CALCULUS-0.2-ADDENDUM-B-DRAFT.md`](WARRANT-CALCULUS-0.2-ADDENDUM-B-DRAFT.md) | the author's proposed ADDENDUM B, which the reviewer replaced | **history, explicitly not adopted** — kept byte-unchanged |
| [`LATENT-MACHINE-PRIMITIVES-0.md`](LATENT-MACHINE-PRIMITIVES-0.md) | a document-only collision test of the calculus against four existing language contracts, followed by dated CORRECTIONS C-0…C-7 | **the reading is history; the CORRECTIONS govern it** |
| [`LMP0-clauses-CD-LCI.md`](LMP0-clauses-CD-LCI.md) | one clerk's verbatim extraction of the Canonical Datum /0 and Located Claim Identity /0 clauses, with path, commit and blob for every source | evidence |
| [`LMP0-clauses-SA-ML0.md`](LMP0-clauses-SA-ML0.md) | the other clerk's verbatim extraction of the Surface Account /0 and Memory Layer /0 clauses, same discipline | evidence |

Two things live outside this directory and are referenced throughout:

- [`../mneme/`](../mneme/) — the four language contracts the collision test was run against. They are in
  this same public tree; their exact paths are in §5 below.
- [`../atelier/warrant-walk/`](../atelier/warrant-walk/) — WARRANT WALK /0, a separate **experimental** Lisp specimen. It
  is not part of this directory's adoption. See §6.

---

## 2. What a "warrant calculus" is here

It is a **documentary extraction**, not a design. One completed proof — the A13 minimality
result for a 13-contact network — left a record: solver runs, checked outputs, prose
arguments, outside audits, tests, obligations that were open and later closed, and a ledger of
every defect found along the way. The extraction asks a single question of that record: *which
distinctions did it actually use in order to license its conclusion?* The answer is a set of
ten forms (`claim`, `checkable`, `argument`, `audit`, `test`, `transition`, `composition`,
`derive`, `revision`, `boundary`) plus one rule for how the status of a claim propagates
through a derivation.

The forms are notation for a record that already existed. They are not syntax, and no code
implements them. The acceptance test was reconstruction plus location: rebuild the whole
warrant graph in the ten forms, then find every recorded defect as a defect against a
*specific field of a specific form*.

The adoption sentence, verbatim, from [`WARRANT-CALCULUS-0.2.md`](WARRANT-CALCULUS-0.2.md) **ADDENDUM A**:

> **WARRANT CALCULUS /0.2 is adopted as a documentary extraction from the sealed A13 record,
> with Astra's adequacy and recursive route-selection corrections incorporated. Its ten forms
> reconstruct the recorded warrant distinctions; no minimality of the vocabulary or executable
> status procedure is claimed. The A13 conclusion retains its established standing and its
> named trust boundary.**

Note what that sentence does *not* say: it does not say the ten forms are the fewest possible,
and it does not say there is a procedure anyone can run.

---

## 3. What its standing is

The final standing, verbatim, from [`WARRANT-CALCULUS-0.2.md`](WARRANT-CALCULUS-0.2.md) corrected **ADDENDUM B §B.7**:

> **Standing inscription:** WARRANT CALCULUS /0.2, with ADDENDA A and this corrected B, is
> adopted as a documentary extraction and compatibility reading. Its support-selection and
> assessment-record requirements are distinguished from LCI/0's identity and target
> requirements. No executable standing policy or live authority is conferred. The sealed A13
> conclusion is unchanged.

### What it is NOT

> **WARRANT CALCULUS is a documentary candidate for part of the derivation policy that LCI/0
> deliberately leaves to another specification.**

That sentence is the reviewer's, quoted verbatim in [`LATENT-MACHINE-PRIMITIVES-0.md`](LATENT-MACHINE-PRIMITIVES-0.md)
**correction C-5**, where it *replaces* an earlier sentence of the collision test that had
called the calculus "the 'derivation calculus' LCI/0 defers to." A declared extension point is
not an appointment. In the reviewer's finding table (reproduced in C-5), the proposition
*"this calculus already governs the deferred LCI policy"* is marked **Not established**.

So, stated plainly: **this is not an executable standing policy, it is not the governing
derivation policy of the Lisp+/Mneme language, and it does not change any adopted contract. It
is a candidate for part of a policy that Located Claim Identity /0 deliberately left to a
separate specification, and that specification does not exist.**

---

## 4. What LATENT MACHINE PRIMITIVES /0 is

A **document-only collision test**. Five concrete cases from the same proof record were traced
through four existing language contracts, quoting each governing clause before proposing
anything, to find where the contracts already say what the calculus says, where they would
need an interpretation, and where they conflict or are silent. No contract was edited. No code
was written. The five cases:

1. a search emits a candidate; checking establishes the semantic property — production versus warranted property;
2. an argument supplies support for an open obligation — new support without inventing an earlier defect;
3. a proposition acquires a dependent elsewhere — dependency change without evidence change;
4. a supporting claim has two live routes — selected support without alternative-route contamination;
5. a certificate bundle loses retained material — historical verification versus present affordances.

All five were welcomed by the contracts. Three corrections came *back* to the calculus from
the contracts, one import was taken rather than minted (`RepresentedLoss/0`), and one proposed
split was later withdrawn.

Its standing, verbatim, from the CORRECTIONS section of [`LATENT-MACHINE-PRIMITIVES-0.md`](LATENT-MACHINE-PRIMITIVES-0.md):

> **LATENT MACHINE PRIMITIVES /0 is accepted as a documentary compatibility reading, with
> Astra's corrections incorporated. The five A13 cases have identified representations or
> declared extension points in the cited contracts. WARRANT CALCULUS remains an adopted
> documentary extraction; its use as a governing derivation or standing policy requires a
> separate specification and adjudication.**

---

## 5. The four contracts, and their standings

All four are in this same tree, under [`../mneme/`](../mneme/). Paths and identities below are exactly as
the two clerk extractions record them.

| contract | authoritative text (the clerk tables write these with the prefix `experiments/latent-lisp/`, which is this tree's root; shown here relative to this directory) | commit · blob | standing (quoted) |
|---|---|---|---|
| **Canonical Datum /0** | [`../mneme/spec/CANONICAL-DATUM-SPEC.md`](../mneme/spec/CANONICAL-DATUM-SPEC.md), with [`../CANONICAL-DATUM-SPEC-ERRATA-0.1.md`](../CANONICAL-DATUM-SPEC-ERRATA-0.1.md) and [`../CD0-POST-IMPLEMENTATION-RULING.md`](../CD0-POST-IMPLEMENTATION-RULING.md) (all three named at [`receipts/canonical-datum-0/CD0-FREEZE-DECLARATION.md:29`](../receipts/canonical-datum-0/CD0-FREEZE-DECLARATION.md)) | `1d3021de` · `f8330a7fe29fbfb971da3b64822c6178baf7cc3c` | **"Status: FROZEN"** ([`receipts/canonical-datum-0/CD0-FREEZE-DECLARATION.md:5`](../receipts/canonical-datum-0/CD0-FREEZE-DECLARATION.md)); *"Lisp+ Canonical Datum /0 is frozen at the accepted merge"* (`:7`) |
| **Located Claim Identity /0** | [`../mneme/lci0/spec/LOCATED-CLAIM-IDENTITY-SPEC.md`](../mneme/lci0/spec/LOCATED-CLAIM-IDENTITY-SPEC.md), with its errata, post-review ruling and normative fixture package | `fb0dc622` · `f7d3ef4e30d51d346fdd3c88e2f0097487411308` | **"LCI/0 remains CLOSED; D2 DEFERRED INDEFINITELY."** (owner ruling O2) |
| **Surface Account /0** | [`../mneme/language-surface-account-0/production/surface-account.lisp`](../mneme/language-surface-account-0/production/surface-account.lisp) (the adopted mechanism) and `…/ADOPTION-RECEIPT-2026-08-06.md` | `af4ec5b0` · `11ae1895ea5fd98c2af2934e5d0c39433e51e725`; receipt `fafa80aa` · `c8b8368be717b2c736a3be752578505d66e8aa08` | **"Language Surface Account /0 — ADOPTED + PUBLISHED 2026-08-06."** — but see the finding below |
| **Memory Layer /0** | [`../mneme/memory-layer-0/MEMORY-LAYER-0-SPEC.md`](../mneme/memory-layer-0/MEMORY-LAYER-0-SPEC.md) (with GUIDE, RETURN, `de-actu-memorato/`) | `3fdb1b1c` · `6115a247a1246450b862d0ed04a4aeac9870b110` | **"ADOPTED AND PUBLISHED · STRICT STRANGER AUDIT PERFORMED AND RECEIVED · STRANGER-AUDIT OBLIGATION DISCHARGED · BOUNDED INDEPENDENT EVIDENCE OBTAINED · P9 CLAIM-CEILING DEFECT OPEN · NO SUPPORTED-PATH RUNTIME SEMANTIC FAILURE ESTABLISHED"** — and, verbatim in the same passage, *"This does not confer blanket 'independently verified' status."* |

Two authority findings from the collision test that a reader must carry:

- **The adopted Surface Account /0 artifact is the identity mechanism only** — nine exports,
  *"given a package and an address, and NOTHING ELSE"* ([`surface-account.lisp:6-7`](../mneme/language-surface-account-0/production/surface-account.lisp)). The
  account / door / inspector / inspection-record vocabulary lives in three documents that each
  describe themselves as not implemented: it is **candidate**, not adopted.
- **The frozen Memory Layer /0 specification's own header still reads `STANDING: CANDIDATE`**
  ([`MEMORY-LAYER-0-SPEC.md:7`](../mneme/memory-layer-0/MEMORY-LAYER-0-SPEC.md)) against the adopted standing above. This is recorded and
  preserved, not repaired.

---

## 6. The three-way distinction a reader must keep

This is the single most important thing on this page. Three different kinds of thing are
described in and around this directory, and they have three different standings.

**(a) DOCUMENTARY ADOPTION — the calculus and the collision test.**
WARRANT CALCULUS /0.2 with ADDENDA A and corrected B, and LATENT MACHINE PRIMITIVES /0 with
its CORRECTIONS. These are *readings of a record*. They were adopted and accepted as such.
They confer no executable behaviour and no authority over anything.

**(b) EXPERIMENTAL IMPLEMENTATION — WARRANT WALK /0, at [`../atelier/warrant-walk/`](../atelier/warrant-walk/).**
A small runnable Lisp specimen commissioned *after* the documents in this directory were
closed, to test whether a program can identify which supporting route its conclusion actually
depends on. Its semantics are explicitly limited and experimental. It is not in this directory
and is not covered by any adoption here. In the commissioning instruction's own words, *"it
does not implement or become the governing Lisp+/Mneme standing policy."*

**(c) GOVERNING LANGUAGE CONTRACTS — the four documents of §5.**
These are the texts that actually govern. Their standings, as the collision test's source
table records them, are: **CD/0 FROZEN · LCI/0 CLOSED · Surface Account /0 ADOPTED, identity
mechanism only, its wider vocabulary CANDIDATE · Memory Layer /0 ADOPTED AND PUBLISHED with
its P9 claim-ceiling defect open.** Nothing in this directory edits, extends or amends any of
them.

A reader who collapses (a) into (c) will believe a policy exists that does not. A reader who
collapses (b) into (a) will believe an implementation was adopted. Neither is true.

---

## 7. Reading order

1. **[`WARRANT-CALCULUS-0.2.md`](WARRANT-CALCULUS-0.2.md), whole, including ADDENDUM A and ADDENDUM B.** This is the
   governing text of this documentary reading. ADDENDUM A carries the adoption sentence and two binding corrections;
   ADDENDUM B is the reviewer's own corrected text, appended verbatim, and it carries the
   final standing sentence in §B.7.
2. **[`LATENT-MACHINE-PRIMITIVES-0.md`](LATENT-MACHINE-PRIMITIVES-0.md), CORRECTIONS FIRST (C-0…C-7), then the reading above
   them.** The reading was written before the corrections and is preserved unchanged; several
   of its sentences were retired by the corrections that follow it. Reading it forwards will
   mislead you; reading the corrections first will not.
3. **The two clerk extractions**, when you want to check a quoted clause against its source.
   Every clause there carries a file, a line, a commit and a blob hash.
4. **[`WARRANT-CALCULUS-0.md`](WARRANT-CALCULUS-0.md) and [`WARRANT-CALCULUS-0.1.md`](WARRANT-CALCULUS-0.1.md), and the ADDENDUM B draft, last, as
   history.**

**Why the superseded versions are kept.** Because the calculus was applied to itself: every
defect found in /0 was recorded as a `revision` in /0.1 with its own defect kind, and every
defect found in /0.1 was recorded the same way in /0.2. The accounting is checkable only if
the superseded text is still there to check against — ten defect kinds after /0, eighteen
after /0.1, twenty-three after /0.2; twenty-six ledger entries located, of which eleven are
distinct historical incidents. Deleting the earlier versions would delete the evidence for the
count. The same reason preserves the ADDENDUM B draft: the reviewer's instruction was
*"preserve that draft as history."*

---

## 8. Provenance

- **WARRANT CALCULUS /0, /0.1, /0.2 and the ADDENDUM B draft** were written by Claude Fable
  5.1, on 2026-09-08, in that order, each in response to an adjudication of the one before.
- **LATENT MACHINE PRIMITIVES /0** was written by the same author on 2026-09-08 on two
  subordinate readers' extractions; those two extractions ([`LMP0-clauses-CD-LCI.md`](LMP0-clauses-CD-LCI.md),
  [`LMP0-clauses-SA-ML0.md`](LMP0-clauses-SA-ML0.md), together about 168 KB of quoted clauses) are included here as
  evidence.
- **The reviewer is Astra (GPT-6)**, working from outside the repository, through the owner.
  Astra adjudicated /0 (pass with errata), /0.1 (hold), /0.2 (adopt, with two binding
  corrections that became ADDENDUM A), the collision test (accept, with five corrections),
  and the author's proposed ADDENDUM B (**not adopted**; Astra supplied a corrected text
  instead, which is the ADDENDUM B in force). Astra closed the commission on 2026-09-08.
- **The reviewer's letters are quoted verbatim inside these documents**, not paraphrased:
  ADDENDUM A quotes the adoption sentence and both corrections word for word; ADDENDUM B *is*
  Astra's text, appended byte-for-byte and independently hash-checked by Astra afterwards; the
  CORRECTIONS section of the collision test quotes each correction's adopted wording verbatim.
- **One limit the reviewer stated about its own verification**, and which travels with all of
  it: *"My verification concerns the supplied bytes and their changes; it is not an
  independent repository readback."* The clerk extractions' fidelity to the repository was
  reported by the author and not independently repeated.

---

## 9. The one shared error, stated plainly

Both the author and the reviewer misread the same clause, in the same way, for most of a day.

Located Claim Identity /0 §8.4 contains the sentence **"The cache is never an input to
projection."** The collision test's Case 2, its §6 summary, and the ADDENDUM B draft all read
that sentence as a rule about caching a *standing* result — that is, as a contract-level
prohibition on trusting a stored status. The reviewer's earlier replies carried the same
attribution forward.

It is not that. §8.4 is headed "Cached or self-declared IDs," and its subject is a cached
**ClaimId envelope or digest** carried on an outer artifact profile for indexing: the reader
recomputes the envelope from proposition and location and refuses disagreement with
`ClaimIdCacheMismatch`. It is an **identity-projection** rule. It says nothing about the cache
semantics of a standing query.

The error was caught on **2026-09-08**, when the fuller clause quotations went across, and was
corrected by the reviewer, who recorded it against its own reading as well as the author's.
See:

- [`LATENT-MACHINE-PRIMITIVES-0.md`](LATENT-MACHINE-PRIMITIVES-0.md) **C-1**, whose heading names it *"a correction attributable
  to BOTH readers"*; and
- [`WARRANT-CALCULUS-0.2.md`](WARRANT-CALCULUS-0.2.md) corrected **ADDENDUM B §B.0**, which states: *"LMP/0 and its draft
  treated LCI/0 §8.4 as a standing-cache rule. Astra's earlier replies carried that
  attribution forward. … Preserve this as a correction to both the comparison and Astra's
  earlier attribution."*

What survives the correction is the conclusion, on different clauses: standing remains a
**query**, supported directly by LCI/0 §4.11 and §17.13, with the complete standing policy
deferred by §28.8. What fails is borrowing §8.4's specific cache requirements and presenting
them as an already-adopted standing procedure. The sentence keeps its restored subject: **the
ClaimId cache is never an input to projection.**

---

## 10. Where to check anything on this page

Every quotation above is in one of the files in this directory. If a sentence here and a
sentence in one of those files disagree, **the file governs and this page is wrong.** Where adopted
passages appear to conflict, follow the identified adjudication that authorizes one to supersede the
other, within its stated scope. A later timestamp by itself is not authority. The companion index
[`governing-statements-index.md`](governing-statements-index.md) identifies those adjudications and their
scopes. "Governing" here concerns this documentary reading; it confers no authority over Lisp+/Mneme
language contracts.
