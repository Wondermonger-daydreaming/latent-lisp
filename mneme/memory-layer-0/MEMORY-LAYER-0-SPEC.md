# MEMORY LAYER /0 — NORMATIVE SPEC (candidate)

*The promotion rule, the two lane-local discriminants, and the explicit
non-implications. Written by TABULARIUS (Claude Opus 5, subagent), 2026-08-20,
under `MEMORY-LAYER-0-WORK-ORDER.md` and its AMENDMENT 1.*

**STANDING: CANDIDATE.** Not adopted, not accepted, not frozen, not audited, not
registered on any floor. Nothing in this lane is independent verification. The
lane is capability-**disciplined** and never capability-**secure**.

**THIS DOCUMENT IS AT ROUND R4.1b (2026-08-21).** R4.1b amends §6b, adds **§6c**
(every lane struct is reader-proof), rewrites **§8/Materialize** (the
recompute-from-store contract, `ML0-MAT-2/3/4`, and the cross-store refusal), and
amends §8/Consolidate and §11. It follows a **cross-family** review of R4.1 by a
Codex worker (SCRUTATOR) that returned a **blocking** verdict; the findings and
the repair are recorded in the RETURN's R4.1b section. **The review is not a
stranger's acceptance and no stranger audit has been done.**

⚑ **R4.1c (release correction, 2026-08-21) — NO PRODUCTION LOGIC OR DURABLE SEMANTICS CHANGED; Lisp source received prose/reporting-only edits at chair closeout. (SCRIBA-III's bounded subpass, before closeout, was documents-only.)** Three passes: the consolidation proof's shipped state is **35 checks**
(§8 of the proof is **eight** checks, `[028]`–`[035]`) wherever this document
states it currently; the construction-boundary prose is narrowed (construction
privacy is **defense in depth, not the soundness boundary** — §6b/§6c and
§8/Materialize); and **R4.1-F3 (cross-journal materialization) is an OPEN
governance item**, not "future work", with its own parked question
(`notes/2026-08-21-ml0-cross-journal-materialization-question-for-sol.md`). **Two
open governance dispositions now stand**: §5.A's failed-write variance and
R4.1-F3.

⚑ **R5 (2026-08-21) — BOTH DISPOSITIONS ARE RULED, AND ONE OF THEM CHANGED THE
CODE.** Sol amended **work-order §5.A** to the retained-frame semantics **and
required a pre-append dry decode** (disposition B, WORK-ORDER AMENDMENT 2):
§8/Write gains **step (4b)** and the new requirement **`ML0-WR-8`**, the failed-write
wording is **amended** (it was deliberately unamended for four rounds precisely
because it had not been ruled on), and the post-append residue is now **host fault
only**, measured at `ml0-controls` **TOOTHs 11, 12, 13** — **13 controls, 13 caught,
0 missed.** Sol also ruled **R4.1-F3 → disposition A** (AMENDMENT 3): same-store-only
durable consolidation, `ML0-MAT-3` kept, **Architecture 0.1 D4 unamended**, and
**Memory Layer /1 RESERVED** (`MEMORY-LAYER-1-RESERVED-CHARTER.md`, not built).
**ZERO open governance dispositions stand.** Still unchanged, by instruction: D6
`PARTIAL`, demonstration D4 `SHOWN-AS-AMENDED`, package privacy = defense in depth,
and **same-family execution is not independent audit**. The lane is **NOT
registered**; the registration ruling is Sol's and has not been made.

---

## 0. What this lane is, in one paragraph

After One Act, durable runtime bytes exist (capability /2's journal) and durable
world bytes exist (the effect adapter's files) — but **the LANGUAGE's durable
account of its own act does not**. One Act /1's RETURN names that absence F-1 and
grades its own third demonstration PARTIAL because of it. Memory Layer /0 builds
the narrowest provenance-bearing **write / retrieve / consolidate** path that
closes F-1 **without letting the account impersonate the event it describes**.

---

## 1. The law, non-negotiable

```text
ISSUED(evidence, act)        ⇏ OCCURRED(act)
DURABLE(evidence)            ⇏ OCCURRED(act)
RETRIEVED(memory-account)    ⇏ CURRENT-IMAGE-EVIDENCE(memory-account)
RETRIEVED(memory-account)    ⇏ AUTHORIZED-TO-CONTINUE(act)
```

**The RED disease in one sentence: evidence-present is treated as
occurrence-present.**

---

## 2. THE PINNED PROPOSITION (work order AMENDMENT 1.3)

`:occurred` warrants **exactly** this and nothing else — the constant
`+ML0-OCCURRED-PROPOSITION+` carries it verbatim in code, and the specimen prints
it into its own transcript:

> **the governed protected effect associated with canonical act identity A
> crossed/applied and is present in the declared journal/world universe under its
> derived external-request identity**

**It does NOT mean "`perform` was invoked."** A lawful refusal is itself an
execution event — something genuinely happened in the language — whose *protected
deed* did not occur. Reading `:occurred` as "an act was attempted" would make
every refusal an occurrence and would quietly turn this lane into a duplicate of
the execution axis.

**Occurrence-standing is the later reader's EPISTEMIC STANDING toward this
precisely named proposition.** It is not a fifth outcome axis: Architecture 0.1's
four axes describe an outcome held by a live actor; this describes what a reader
who was not there is entitled to say afterwards.

---

## 3. Governing law, and exactly which clause is carried across

The adopted constitutional law is **L15 — Witness separation**
(`architecture/LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md:1553-1555`):

> A process's unaided account of its own history is asserted testimony.
> Observational standing requires a distinct, inspectable witnessing mechanism.

Its operational ancestors are written for the **adapter/provider boundary**, not
for a memory layer reading its own lane's durable bytes. They are cited as
governing precedent **whose reasoning transfers**, never as automatically binding
here. The clause carried across in each case:

| Requirement | Clause carried across | Where it lands in this lane |
|---|---|---|
| **AP-JRN-1** | *"A self-written adapter narrative remains asserted."* | `:lane-self-report` — including **every account this lane writes** — may corroborate and may provide provenance, and may never be the sole occurrence basis. |
| **AP-REC-1** | the four-part warrant for settling no-effect: **domain completeness + authority over the identity + a distinct inspectable witness + a record binding witness-mechanism / evidence-identity / procedure-identity / origin / validation-standing** | `ml0-nonoccurrence-warranted-p`, and the required fields of a `:scoped-negative-observation` source. |
| **AP-CAN-6** | a settled label resting on self-report is **`adapter-truth-minting`** | the species leg of the promotion rule: no self-report and no issuance testimony can produce `:occurred`. |

**What is NOT carried across, said plainly:** AP-REC-1's `:not-found` machinery
concerns a provider domain an adapter queries. This lane's negative reading is
about a *world ledger* it reads directly. The shape transfers; the jurisdiction
does not, and no artifact of this lane may cite AP0 as binding on it.

**Adopted vocabulary used instead of new coinages** — Retrieve is **evidence
replay** (Architecture 0.1 **D6** replay triad), never execution replay and never
output reproduction. Consolidation obeys **D4** verbatim: *"cross-journal merges
are receipt-bearing transformations, never timestamp sorts."* Authority obeys
**D5/DK-3**: a record that authority existed is not authority.

---

## 4. THE GAP THIS LANE FILLS, flagged rather than silently amended

Architecture 0.1's four adopted outcome axes — execution, manifestation, external
effect, interpretation — are axes **of an outcome**, held by a live actor. They
**do not cover**:

- **(a) occurrence standing** — a later reader's warranted reading of whether the
  pinned proposition holds;
- **(b) issuance standing** — whether a language-level evidence account was
  minted.

This lane mints exactly those two, **lane-locally**, and flags the gap. It adds
no fifth axis and amends no adopted document.

The **world/effect** question reuses the adopted external-effect axis
determinacies (`:determinate / :bounded / :indeterminate`) **verbatim**, carried
as a *scoped observation of* capability /2's fold-derived standing — never the
standing itself, never collapsed into the act outcome.

---

## 5. The semantic object

One canonical, language-level, durable **`memory-account`** of ONE act. All
durable values are CD/0 (nine families only). Durable frames ride the adopted
**ten-field envelope**, with honest values:

```
capture-boundary   boundary:memory-accounting   (not a kernel transition)
capture-mechanism  witness:lane-self-report     (this lane witnessed nothing)
origin             origin:self-reported         (origin:observed is UNMINTABLE
                                                  here, in code — §7)
recorder-principal principal:memorylayer0       (who wrote the row)
subject-principal  principal:<the actor>        (whose act it is ABOUT)
```

The six questions of the commission, independently answerable:

| # | Question | Field(s) |
|---|---|---|
| 1 | which act? | `act-id` (re-derived, byte-compared), `act-id-hex`, `subject-seat`, `subject-attempt` |
| 2 | occurrence standing? | `occurrence-standing` + `occurrence-scope` |
| 3 | issuance standing? | `issuance-standing` + `issuance-scope` — **a separate field, never folded into 2** |
| 4 | world/effect? | `effect-observation` (a scoped reading of the adopted axis, **stamped `:caller-asserted`** — see below) |
| 5 | why may it say this? | `sources` — one typed row each |
| 6 | how derived? | `derivation` + `predecessors` — **set by the entry point, never by an argument (R4.1)**: `ml0-write` writes `:direct-write` with no predecessors, always; `ml0-materialize-consolidation` writes `:consolidation` with the carrier's predecessors |

Plus one field that is **not** on either standing axis: `record-coverage` (§6).

**⚠ R4 — QUESTION 4 IS ANSWERED BY TESTIMONY, AND THE ACCOUNT NOW SAYS SO.** This
slice has **no world-reading door on the effect axis**: every field of an
`effect-observation` arrives from the caller's argument list, and nothing reads a
world. Until 2026-08-20 that reading sat in the durable bytes beside door-read
provenance with nothing marking it, so a commission question was answered out of
caller testimony that looked exactly like an observation. Every effect observation
now carries `provenance = :caller-asserted`, **in the type and in the durable
bytes**; the mark is not a constructor parameter (a caller that could set
`:door-read` would have exactly the field-filling power this lane's repairs exist
to remove), and bytes claiming any other provenance are **refused** at `ML0-RB-5`
rather than best-effort decoded. When a world-reading door for this axis is built
it will stamp its own value through an internal constructor, the way the five
observation doors do.

**⚠ R4 — AND `record-coverage` IS NOW DOOR-PRODUCED (R4.1e wording: the door is the SUPPORTED producer — not exposed through the exported, supported API; Common Lisp package privacy is not a capability boundary — an internal constructor remains callable through package-internal access — and BOA closes the supported SBCL `#S` route, not every possible call).** It is the one axis on which
this lane declares itself *competent* — competent over its own store and over
nothing else — and until 2026-08-20 the finding was a **caller keyword** carrying
a **caller-built `:looked` scope**, with **no code anywhere that ever scanned the
account store**. `ml0-observe-record-coverage` is that scan: it walks the whole
validated prefix of this lane's own store, opens every account frame through
`ml0-retrieve`, and answers on what it found — reporting `:not-examined` under a
`:could-not-look` scope when the prefix is not `:valid`, because *I could not
look* and *I looked and it is not there* are different sentences. A caller
supplying `:record-coverage` or `:record-coverage-scope` is **refused** at
`ML0-BND-10`; `ML0-BND-4` and `ML0-BND-5` are gone, and their absence is the
repair rather than an omission — the same move `ML0-BND-3` made on the issuance
axis. The difference between an assertion and an observation is not a field a
caller fills in; it is a door the exported, supported API gives no way to impersonate
(R4.1e wording: not exposed through the exported, supported API; Common Lisp package privacy is not a capability boundary — an internal constructor remains callable through package-internal access — and BOA closes the supported SBCL `#S` route, not every possible call).

**Account identity** is content-derived (a digest of the whole canonical body) in
the **existing** kernel /0 domain **`:claim`** — an account is a *claim about* an
act, not the act and not a receipt of one. `make-identity`'s own law forbids a
host-derived name. Because the identity digests the whole body, **distinct
provenance produces a distinct identity by construction**, which is what makes
consolidation's "never deduplicate distinct provenance" a fact about the
identities rather than a promise about the code.

**Five identity species, never conflated:** act identity · attempt/process
identity · evidence identity (which **does not exist** publicly — §8) · account
identity · principal identity.

---

## 6. The two axes, and the field that is on neither

### Occurrence standing — `:occurred | :nonoccurred | :unresolved | :contradicted`

- `:occurred` **only** via the promotion rule (§7).
- `:nonoccurred` **only** with the AP-REC-1-shaped four-part warrant, scope
  declared, and `:could-not-look` kept distinct from looked-and-absent.
- `:unresolved` is **the lawful default and is never a defect.**
- `:contradicted` may be emitted **by consolidation only**, requires
  **commensurable** warrants (§9), and preserves both. ⚑ **R4.1: and it now has a
  durable route.** Until 2026-08-21 consolidation could *compute* `:contradicted`
  and had nowhere to put it — the documented durable route (`make-ml0-bundle
  :sources` → `ml0-write`) refused it at `ML0-WR-6` — so the standing was
  reachable in memory and unreachable in bytes.
  `ml0-materialize-consolidation` writes it **as computed** and a fresh process
  reads it back (`RED-CONSOLIDATION-AFTER.txt` §7, checks [023]–[027]). The
  clashing pair there is still **modelled**, not naturally arising — §9's limit is
  unchanged.

### Issuance standing — `:issued-in-writing-image | :unresolved`

**Exactly two members, and the shortness is the point** (AMENDMENT 1.1).

Core /0's issuance registry is a per-image hash table with **no durable
footprint** (`core0.lisp:830-836`), so in any image but the issuing one
`core0-evidence-current-image-issued-p` answers **false for every possible
input**. A predicate that is false universally is not an absence warrant.

**A scope does not repair that.** This lane shipped `:not-issued-in-scope` for
part of its own build and then **struck it**: the account store never observes
Core /0's registry at all, so no declaration of the store's boundaries can confer
observational competence over a thing outside it. Scope narrows a claim a looker
was competent to make; it cannot manufacture the competence. The struck member is
recorded here rather than quietly deleted, because the tempting move was to keep
the word `not-issued` and make it safe with an adjective, and the adjective could
not do it.

`:issued-in-writing-image` is **provenanced testimony by the writing process**,
from the live predicate, in the image that minted — and it is *named for its own
boundary* so no later reader can quote it flat as "issued".

### Record coverage — a separate field with a separate vocabulary

`:issuance-record-present-in-account-store | :no-issuance-record-in-account-store
| :not-examined`

*"No issuance record is present in THIS store"* is a true, checkable, **competent**
statement: the account store is the universe of the look and this lane is
authoritative over it. What it may never be read as is a statement about Core
/0's registry — which is why it lives on its own field rather than as a shy
spelling of `not-issued`.

---

## 6a. THE PUBLIC SURFACE CARRIES NO MUTANT SEAM — added 2026-08-20, R4

*The lane plants six defects and kills them, and until 2026-08-20 it drove them
through a `&key defect` parameter compiled into **ten exported production
functions** — including `ml0-species-may-warrant-occurrence-p`,
`ml0-occurrence-warranted-p`, `ml0-write`, `ml0-retrieve` and `ml0-consolidate`.
The guarantee that the seam was "production NIL, controls only" was **a
docstring**. A cross-family (GPT/Codex) adversarial reader flipped the crown
predicate with one keyword, in a fresh image loaded through the canonical
`load.lisp`.*

**§I-f, verbatim: prompts guide; code enforces.** The seam is not narrowed,
asserted-NIL, or stripped at a gate; it is **removed from every production
arglist**. The six defects live in `ml0-mutant-overlay.lisp`, which
`+ml0-lane-sources+` does not name, `load.lisp` does not load, and no consumer
reaches; each installs itself by **redefining** a production function with a
wrapper that **delegates** to the saved production definition, so no production
body is duplicated and the mutant is dynamic rather than global.

**The property, checkable in one line, and checked by a gate:** in an image
loaded through `load.lisp`, **no external function of this lane carries a `defect`
or `defect-payload` parameter** — read out of the *compiled lambda lists* by
`sb-introspect`, not out of the source text by grep (`ml0-block-proof` F1, and
`ml0-selftest` §K, which runs it **with the overlay loaded** and still finds
none). And the cure is proved to be a **relocation, not an amputation**: the six
mutants still kill (`ml0-mutants` 6/6), and `ml0-block-proof` F1c loads the
overlay after every other probe and shows the same collapse still firing.

## 6b. TESTIMONY vs VALIDATED OBSERVATION — added 2026-08-20, repair round

*The chair's disposition of 2026-08-20 blocked this lane because §7's rule, as
built, inspected caller-supplied fields. This section is the semantic content of
the cure; §7's leg table carries it into the rule.*

**A source row is one of two kinds of thing, and the kind is durable:**

| standing | who may mint it | may it warrant occurrence? |
|---|---|---|
| `:VALIDATED-BY-DOOR` | **a production door of this lane, through the exported, supported API** (R4.1e: not exposed through the exported, supported API; Common Lisp package privacy is not a capability boundary — an internal constructor remains callable through package-internal access — and BOA closes the supported SBCL `#S` route, not every possible call), on a row whose every field it derived from the substrate it read. The constructor carrying this stamp is INTERNAL, unexported, **and BOA — see §6c** | yes, subject to the other eight legs |
| `:ASSERTED-TESTIMONY` | anyone, through the public `make-ml0-source` | **never**, however complete its fields |
| `:STORED-ASSERTION` | **readback, always** — carrying the bytes' own claim separately as `recorded-validation` | only by INHERITING a recorded door validation, as testimony, never as a fresh look |

**THE FIVE PRODUCTION DOORS** — `ml0-observe-journal`, `-world`,
`-reconciliation`, `-absence`, `-issuance` — obey four rules: they READ their
owning substrate through its public readers; they DERIVE every field from what
they read rather than accepting it; they BIND the act identity; and they are the
only callers that STAMP through the exported, supported API (R4.1e wording: not exposed through the exported, supported API; Common Lisp package privacy is not a capability boundary — an internal constructor remains callable through package-internal access — and BOA closes the supported SBCL `#S` route, not every possible call).

**⚠ TESTIMONY IS NOT A WEAKER OBSERVATION. IT IS A DIFFERENT KIND OF THING.** A
memory layer must be able to record *"this is what was said"* durably and
faithfully, and must never be able to promote it. The blocked build had one
category where there needed to be two.

**⚠ AND A DOOR ESTABLISHES ONLY WHAT IT READ.** Hand a door a world and it reports
the truth about *that* world, recording which world by its digests. No door
authenticates a substrate's provenance; this lane remains
capability-**disciplined**, never capability-**secure**.

## 6c. EVERY LANE STRUCT IS READER-PROOF — added 2026-08-21, round R4.1b

*This section exists because the sentence it replaces was false for four rounds.*

Every argument this lane has made since R2 has at some point rested on the form
`(:constructor %make-X)` — *"the constructor is INTERNAL, so a caller cannot
assert one of these."* **That is not what the form does.** It suppresses the
conventional `MAKE-X` function; it does **not** suppress Common Lisp's `#S`
structure reader, which builds a structure from a literal and chooses every slot.
An exported structure type was therefore publicly instantiable by anyone who could
type its name — `ML0-ACCOUNT` with `:standing-authority :validated-retrieval`,
`ML0-SOURCE` with `:validation-standing :validated-by-door`, both minted from
outside the package. **Measured before it was repaired**: `RED-HASH-S-BEFORE.txt`,
five struct types, five `CONSTRUCTED`.

**THE PROPERTY, NORMATIVE, AND IT HOLDS OF EVERY LANE STRUCT WITHOUT EXCEPTION:**
each of the ten internal constructors in `ml0.lisp` is declared **BOA** —
`(:constructor %make-X (&key slot …))`. SBCL's `#S` reader requires a structure's
**default keyword constructor**; a BOA constructor is not that constructor, even
when its lambda list is `(&key …)` and it therefore accepts exactly the same
arguments in exactly the same way. A `#S` literal naming any of these types is a
**`READER-ERROR`**.

The ten: `ml0-scope` · `ml0-source` · `ml0-subject` · `ml0-observation` ·
`ml0-effect-observation` · `ml0-bundle` · `ml0-account` · `ml0-store-scope` ·
`ml0-record-coverage-observation` · `ml0-consolidation`.

**Nothing else about the code changed.** Every internal call site already passed
keywords; the one slot with a non-nil default — `provenance :caller-asserted` on
`ml0-effect-observation` — carries that default into the BOA lambda list. The
**public** constructors `make-ml0-scope`, `make-ml0-source`,
`make-ml0-effect-observation` and `make-ml0-bundle` are untouched exported
functions and still normalize everything they are handed to non-warranting
testimony. What is gone is the **literal** as a door.

⚠ **A NEW LANE STRUCT MUST BE DECLARED BOA.** A plain `(:constructor %make-X)`
re-opens this route on the very next struct anyone adds — and **check `[029]` is the
coverage gate that notices**: it enumerates every structure class in the lane package
automatically and asserts `#S` is refused for each (teeth-checked against a planted
keyword-constructor struct, which makes it FAIL). No manual registration protects a
future struct; `[029]` does. (R4.1c correction: an earlier version of this paragraph
told maintainers to add new types to `[028]`, which is only the five-type sample.)

**Checked, not merely stated:** `ml0-consolidation-proof.lisp` `[028]` is the
five-type sample (account, source, observation, bundle, carrier → `READER-ERROR`);
`[029]` is the enumeration over every lane structure (10 at R4.1c). The AFTER capture
is `RED-HASH-S-AFTER.txt` (five `ERROR SIMPLE-READER-ERROR`).

## 7. THE PROMOTION RULE — one public function, NINE legs (was eight before the 2026-08-20 repair round)

`ml0-occurrence-warranted-p` (with `ml0-occurrence-conjuncts` exposing the legs
individually, so a refusal can **name which conjunct answered**).

`:occurred` requires ALL NINE, together, **of one source**:

| # | Leg | Requirement id |
|---|---|---|
| **0** | **validation** — the row is door-validated, or carries a recorded door validation. **Every other leg reads a field; this one asks whether anyone looked.** | `ML0-PROMOTE-0` |
| 1 | **species** — a species that may warrant occurrence | `ML0-PROMOTE-1` |
| 2 | **attestation** — the source attests `:frontier-crossed-for-this-identity` | `ML0-PROMOTE-2` |
| 3 | **subject identity** — byte-equal to the act identity re-derived for this account | `ML0-PROMOTE-3` |
| 4 | **acquisition route** — inside the closed ratchet set | `ML0-PROMOTE-4` |
| 5 | **declared scope** — present, status `:looked`, non-empty universe and interval | `ML0-PROMOTE-5` |
| 6 | **frontier/sequence relation** — declared, non-empty | `ML0-PROMOTE-6` |
| 7 | **canonical payload** — a 64-hex digest of the bytes read | `ML0-PROMOTE-7` |
| 8 | **provenance** — producer + recorder principals + the origin the source's own bytes carried | `ML0-PROMOTE-8` |

**⚠ THE BLOCKED BUILD HAD ONLY LEGS 1–8, AND ALL EIGHT WERE FIELDS A CALLER COULD
FILL.** That is exactly why a forged row minted `:occurred` for an act whose
derived standing was `:ABSENT`. Leg 0 is the repair.

**Not one of legs 1–8 is a fact about an evidence object.** A `core0-evidence`
account, its digest, its receipt, or a report describing it fails leg 1 **even
when a caller has filled every other field perfectly** — which is exactly the
single-delta shape the crown negative presents.

### The source species table

| Species | May warrant | Forbidden to warrant |
|---|---|---|
| `:kernel-mediated-journal` — cap2 frames (`origin/observed`, `principal:kernel-store`), read via the public fold over the **validated prefix** | occurrence (one leg) | — |
| `:world-bytes` — the world's own files: ledger row + digests | occurrence (one leg) | — |
| `:reconciliation-conjunction` — `act1-reconciliation-closes-seat-p`, a joint reading of world **and** journal | occurrence | — |
| `:lane-self-report` — ANY `origin/self-reported` narrative, **including this lane's own accounts** | corroboration, provenance | **sole occurrence basis** |
| `:core0-issuance-testimony` — a Core /0 evidence account, its digest, its receipt, or a report describing it | issuance testimony (in the issuing image only) | **occurrence, in any direction, ever** |
| `:scoped-negative-observation` — a look across a declared universe that found the subject absent | nonoccurrence (scoped) | unscoped nonoccurrence |
| `:account-reconstruction` — successful validation of durable account bytes | account integrity | origin upgrade, occurrence, issuance |

**Why the first three may:** each inspects facts that **would not become true
merely because an evidence object was minted**. `%make-core0-evidence` writes a
struct in the image and `%issue-core0-evidence` writes a hash table; neither
touches a journal frame or a world byte. That dissociation is **measured** — in
the consumed lane's preserved artifact
(`language-act-1/RED-PROOF-HOST-FAULT-BEFORE.txt`: `EVIDENCE-ISSUED : T` with
`JOURNAL-FRAMES-MOVED : NIL` and `WORLD-BYTE-UNCHANGED : T`), and again in this
lane's own transcripts.

### ⚑ Leg 8 was found by building, not by design

The eighth leg (**attestation**) does not appear in the work order. It was found
while building the contradiction row: a `:world-bytes` source built from a lookup
that **found no row** satisfied every other leg and warranted `:occurred`. An
admitted species reading admitted bytes and finding **nothing** is the sharpest
possible false positive, because every provenance field is honest. The species
leg says *what kind of thing was read*; only the attestation says *whether the
reading was positive*. It is recorded here as a finding of the build rather than
as an original intention.

### The origin ratchet

`:live-query | :reconstructed`, taken verbatim in shape from capability /0
(`receipts.lisp:25-33`). **`:observed` is not a member, on purpose**, and passing
it is refused in code by an `ecase` rather than documented and hoped for.
Successful validation of a reconstructed account **upgrades nothing**: retrieval
copies every source's route through unchanged and its own retrieval origin is
always `:reconstructed`.

### The origin gate

`origin/observed` is **unmintable by this lane, in code**: the gate sits on the
only identifier constructor the lane uses. A source's `origin-as-read` field
records what the bytes carried as a CD/0 **string**, never as an identifier — a
report *about* a field, not a claim *of* it.

---

## 8. The operations

### Write

1. **Re-derive the act identity** from the declared fixture row alone, through
   One Act /1's public **non-performing** seam (`make-act1-record :register nil`),
   and compare byte-for-byte against the bundle's claim. Mismatch refuses
   **pre-mutation**.
2. Every source must be about **this** act; a crossed source refuses
   pre-mutation, whatever its species.
3. The promotion rule computes the occurrence standing **from the sources**. No
   supported public call asserts a standing to it (R4.1e wording: it reads rows; the
   rows' stamps are not exposed through the exported, supported API; Common Lisp package privacy is not a capability boundary — an internal constructor remains callable through package-internal access — and BOA closes the supported SBCL `#S` route, not every possible call).
4. Body → content-derived identity → ten-field envelope.
4b. **THE DRY DECODE (R5, required by §5.A as amended — AMENDMENT 2).** Before the
   append, the **exact** canonical event is encoded (`encode-pjs0`, the same
   canonicalization `append-event` performs), decoded back (`decode-pjs0`,
   **`:canonical` required**), run through **the exact account decoder**
   (`%ml0-decode-account-event`, inherited-warrant route — the route `ml0-retrieve`
   takes), and the identity it yields is compared to the identity just minted.
   Any failure refuses at **`ML0-WR-8`** (`ml0-account-encoding-refused`)
   **pre-mutation**; the decoder's own `ML0-RB-*` refusals are re-signalled under
   WR-8 with their requirement id named. Internal (`%ml0-dry-decode`); it touches
   no store and adds no exported name.
5. **The append** — the first and only durable mutation of the call.
6. **Read it back** through `validate-journal`, which re-reads the bytes from
   disk.

7. **The identity check (`ML0-WR-5`)** — the account read back must carry the
   identity just written.

**⚑ R4.1 — THE ARGLIST, AND WHAT LEFT IT.** `ml0-write` takes
**`(store bundle &key recording-process)`** and nothing else. `:derivation` and
`:predecessors` are **gone**: until 2026-08-21 a caller could pass
`:derivation :consolidation` and any list of predecessors as ordinary keyword
arguments, so **lineage was caller-selected** while the standing that rode with it
was whatever the direct-write rule made of a bundle the testimony channel had
already downgraded. This function now writes `:direct-write` with **no
predecessors, always**; a derived account is written only by
`ml0-materialize-consolidation` over a carrier (below).

**`ML0-WR-2` IS WITHDRAWN, AND THE WITHDRAWAL IS THE REPAIR.** That requirement
validated a caller-supplied derivation against the closed vocabulary. A
requirement that polices a word the caller can no longer say is not a
requirement — the argument is gone, so the check is gone with it. **Nothing else
in the write requirement set changes**: `ML0-WR-1`, `-3`, `-4`, `-5`, `-6`, `-7`
stand exactly as they were. **R5 ADDS ONE: `ML0-WR-8`**, the pre-append dry
decode of step (4b), condition type `ml0-account-encoding-refused` — the only
addition to the write requirement set since R4.

**Steps (5)–(7) are now ONE shared internal function**
(`%ml0-append-body-and-read-back`), used by the direct route and the derived route
alike, so the two cannot drift and the failed-write semantics below are **identical
on both**.

**⚠ R4 — WHAT A FAILED WRITE LEAVES BEHIND, STATED HONESTLY.** Until 2026-08-20
this section and `ml0-write`'s own docstring said *failed writes are observably
non-mutating over the whole declared store*, flatly. **That was false, and the
falsehood was structural**: steps 6 and 7 run *after* the append, both can refuse,
and an append-only store has no rollback. The true semantics, in two sentences:

- A refusal from steps **1–5** leaves the declared store **byte-unchanged**, and
  the store-scope instrument that measures it is shown able to see a lawful write
  before its stillness is trusted (`ml0-controls` TOOTH 7, four refusal paths).
- A refusal from the **readback** (`ML0-RB-*`) or from **`ML0-WR-5`** happens with
  the frame **already appended**. The frame is **retained as evidence** — it is
  what was actually written — and **no account is returned**, so nothing
  downstream can read a standing off it. A caller comparing store scopes across
  such a call **will** see the store change.

The lane was **not** restructured so that nothing can refuse after the append;
that fork and its reason are in the RETURN's R4 section. The distinction is
**measured, not narrated**: `ml0-controls` TOOTH 11 forces a post-append refusal
and prints the store scope on both sides. The trigger is unreachable through any
ordinary input — PJ0's `append-event` verifies the frame chain itself and refuses
a damaged store *before* writing — which is why the control synthesises it and
says so.

> ⚑ **§5.A AS AMENDED — AMENDMENT 2 (Sol, 2026-08-21). THIS IS THE GOVERNING
> CONTRACT; the R4 variance is CLOSED, not carried.** Governing text, verbatim:
>
> > Every refusal raised before `append-event` is observably non-mutating over the
> > whole declared store. Once `append-event` succeeds, a subsequent readback or
> > identity refusal returns no account and neither retracts nor rewrites durable
> > bytes. Any surviving bytes acquire no standing merely by surviving: they are
> > judged only through Journal /0 validation and Memory Layer /0 retrieval. Append
> > success, serialization success, and evidence or certificate issuance are never
> > evidence that the represented act occurred.
>
> **Required structure:** the pre-append dry decode of step (4b) — *"A decoder or
> identity refusal must therefore occur before mutation. The designed post-append
> refusal residue should be host fault only."* **Prohibited:** *"Do not add
> rollback, truncation, tombstones, or supersession. Do not reopen or edit Journal
> /0."* None was added; Journal /0 was not touched.
>
> **⇒ THE POST-APPEND RESIDUE IS HOST FAULT ONLY.** Every refusal this lane can
> raise about its own frame — a non-canonical encoding, a decoder refusal, an
> identity disagreement — now fires **before** the append. What remains is the
> bytes changing under the process between append and readback, which no
> pre-append check can anticipate. **MEASURED:** `ml0-controls` **TOOTH 12**
> (planted rendering-version fault) and **TOOTH 13** (planted identity fault) each
> show the fault refused at `ML0-WR-8` with the whole store **byte-unchanged**,
> **and** the same planted fault reaching the append when the dry decode is
> skipped through a named control seam — so the gate is **seen to fire** rather
> than assumed. **TOOTH 11** now models the host-fault residue: no account, no
> retraction, store grown, frame still validating. `ml0-controls`: **13 controls,
> 13 caught, 0 missed.** Entered at WORK-ORDER AMENDMENT 2; recorded in the
> RETURN's **R5** section.

**The issuance-only branch, chosen and public:** a bundle whose only positive
source is issuance testimony is **stored**, under the typed public discriminant
`ml0-account-issuance-only-p`, with occurrence `:unresolved`. It is not refused,
because a lane that refused to remember *"evidence was issued for this act"*
would lose a true fact in order to avoid a false one. The false one is prevented
by the promotion rule, which is where it belongs.

**A bundle may not contradict itself (`ML0-WR-6`).** One bundle carrying both a
qualifying positive warrant and a **commensurable** scoped negative is refused
pre-mutation. `:contradicted` is reserved to consolidation, so a write cannot say
it; and a confident `:occurred` over one's own contradicting warrant would make
the same source set answer two different ways depending on which door it entered.
A caller holding both writes them separately and consolidates — which is the only
lawful route to `:contradicted`. **Incommensurable** disagreement inside one
bundle is ordinary bookkeeping and is not refused.

**Write never** performs the act, issues or promotes Core /0 evidence, authorizes
a capability, or infers occurrence from a successful serialization.

### Retrieve — *evidence replay*

Deterministic validate + fold + decode of one durable account, in a genuinely
fresh process. Returns a `memory-account` **and nothing else**. Refusals are typed
and **total**: a torn tail, an interior corruption, an unsupported rendering
version, a missing field, a source/account identity disagreement, or a
body/event-id disagreement produce a typed refusal and **no account** — because a
plausible partial account is exactly the shape a reader would trust.

Reading performs nothing, mints nothing, and acquires nothing. **Reading an old
account does not make the archive-reader the same being as the original actor.**

**⚠ R4 — THE RAW ROUTE, AND WHY THE ACCOUNT NOW DECLARES ITS OWN AUTHORITY.**
`ml0-account-from-event` decodes a **caller-held** frame with no journal
validation whatever. R3 called that result *"explicitly inert"* — and that was
prose. The rows were inert; the **standings were not**. The decoder read
`occurrence-standing` off the caller's own bytes, checked it only against the
four-word vocabulary, and installed it, so `ml0-account-occurred-p` answered **T**
for a frame whose rows warranted nothing. The two internal checks that looked like
defences (`RB-10`'s act identity, `RB-11`'s body digest) are **internal-consistency
checks**: they prove the frame agrees with itself, never that `:occurred` follows
from anything.

Every account therefore now carries two more fields:

| field | values | meaning |
|---|---|---|
| `standing-authority` | `:validated-retrieval` \| `:raw-decode` | which route produced the standings |
| `carried-standings` | plist | what the **bytes** claimed, preserved verbatim |

On the **raw** route the occurrence standing is **re-derived** from the decoded
rows by the promotion rule (which, over `:stored-assertion` rows, can only reach
`:unresolved`), issuance is `:unresolved`, and coverage is `:not-examined`.
Nothing is erased: the bytes' own claim sits in `carried-standings`, beside the
lane's own answer. **A caller that wants the bytes' word can still have it; what
it cannot have is that word wearing the authoritative reader's clothes.**

**And `RB-11` no longer skips.** It used to run only when the frame carried an
event-id of this lane's `w-`/`c-` shape, so a frame this lane does not recognize
reached the authoritative type **with the check silently not made** — an
absence-without-an-adequacy-warrant at the readback boundary: *no disagreement
found* where the truth was *nothing was compared*. Such a frame is now refused.

### Consolidate — ⚑ AMENDED R4.1: THE RESULT IS A TYPED CARRIER

Deterministic, **effect-free** (it appends nothing and opens no store).

**`(ml0-consolidate accounts)` returns ONE value: an `ml0-consolidation`.** Until
2026-08-21 it returned five bare values and the spec pointed the caller at
`ml0-write :derivation :consolidation` — **a route that could not carry the
result.** `make-ml0-bundle :sources` is the public *testimony* channel and
(correctly) normalizes every inherited row to non-warranting testimony, so a
computed `:OCCURRED` was written back as `:UNRESOLVED`, and a lawfully computed
`:CONTRADICTED` was refused at `ML0-WR-6` — the direct-write self-contradiction
rule, applied to a derivation it was never about. This was **measured before it
was repaired**: `RED-CONSOLIDATION-BEFORE.txt`, 7 checks, 4 failures, exit 1.

**ADMITTED INPUTS.** At least one `ml0-account` (`ML0-CON-1`), each of whose
`ml0-account-standing-authority` is **`:validated-retrieval`** (`ML0-CON-3`) — i.e.
obtained from `ml0-retrieve`, or returned by a write, which reads its own frame
back through `ml0-retrieve`. A **`:raw-decode`** account is **refused**: its
standings were re-derived from rows that warrant nothing, and a caller-held frame
may not vote. The authority gate runs **before** the act-identity comparison,
because an unvalidated account's act identity is itself only a claim.

**ONE ACT (`ML0-CON-2`)**, refused before any output is produced.

**ONE SUBJECT CARRIER (`ML0-CON-4`).** Inputs that share an act but not a
`subject-seat` / `subject-attempt` / **`subject-principal`** are **refused**. Seat
and attempt are inputs to the act identity and so follow from `CON-2`; the subject
principal is **not**, so it is *checked* rather than taken from whichever input
sorted first. §5's law is the reason: `subject-principal` is *"whose act it is
ABOUT"*. A derived account has ONE subject and this lane will not pick one.

**THE CARRIER'S FIELDS**, all read-only, all computed here: `act-id` ·
`act-id-hex` · `subject-seat` · `subject-attempt` · `subject-principal` ·
`occurrence-standing` + `occurrence-scope` · `issuance-standing` +
`issuance-scope` · `record-coverage` + `record-coverage-scope` · `sources` (the
exact union, deterministic order) · `predecessors` · `inputs` (deduped,
content-ordered) · `clash` (the `(positive . negative)` pair when
`:contradicted`).

**THE CONSTRUCTOR IS INTERNAL AND BOA** (`%make-ml0-consolidation (&key …)`),
the same move the observation doors made on the row constructor, and since R4.1b
the same move made on **all ten** lane structs — §6c. ⚑ **R4.1b CORRECTS WHAT
THIS PARAGRAPH USED TO CLAIM.** It said *"the only way to hold a carrier is to
have called `ml0-consolidate` over validated accounts"*, and that was **false**:
the `#S` reader built one from a literal, with every slot chosen.

⚑ **R4.1c — THE NARROWER FACTS, IN PLACE OF ANY "ONLY WAY" CLAIM.** (1) **No
constructor is exported.** (2) The supported SBCL `#S` **default-constructor**
route is refused because all ten of the lane's structures use **BOA**
constructors. (3) **Construction privacy is defense in depth, not the soundness
boundary** — Common Lisp package privacy is not a capability boundary, and this
spec rests no argument on it. What carries the weight is §8/Materialize:
materialization treats a presented carrier as an **untrusted request**,
re-retrieves its input identities from the target store, and writes the
recomputed body. ⚠ **A carrier is not an account** — it has no identity and no
frame, and holding one proves nothing durable.

⚠ **AND A CARRIER'S LISTS ARE NOT FROZEN.** `:read-only t` makes a slot
non-setfable; it does not freeze the cons cells `ml0-consolidation-sources` and
`ml0-consolidation-predecessors` hand back. `rplaca` through those exported
readers rewrote a lawful carrier's occurrence basis while its computed `:OCCURRED`
still stood (`RED-CARRIER-BEFORE.txt`: `WRITTEN standing=:OCCURRED
warranting-rows=0`). **The carrier is inspectable, not trustworthy**, and this
spec no longer asks any reader to treat it as evidence of anything.

The fold laws are unchanged:

- **Ordering:** lexicographic by content-derived account identity. No clock, no
  arrival order, no caller order.
- **Exact duplicates:** same account identity ⇒ one record.
- **Distinct provenance is never collapsed** — by construction, since it produces
  a distinct identity.
- **`:occurred` only** where a qualifying basis **survives validation and is
  named**; the rule is re-run over the union of sources, never inherited from the
  inputs' standings.
- **Contradiction preserved explicitly.** No last-write-wins, no majority vote.
- **Cross-act refused before any output.**
- **/0 never** compacts, forgets, tombstones, GCs, or erases provenance.

### Materialize — ⚑ NEW R4.1, REWRITTEN R4.1b: THE ONLY DURABLE ROUTE, AND IT RE-READS THE STORE

`(ml0-materialize-consolidation store consolidation &key recording-process)`
writes **ONE derived account** and returns it **read back from the store**.
Anything that is not an `ml0-consolidation` carrier is refused at **`ML0-MAT-1`**.

⚑ **R4.1b — WHAT IT TAKES FROM THE CARRIER IS THE INPUT IDENTITIES, AND NOTHING
ELSE.** Until 2026-08-21 this section read *"what it takes from the carrier,
unchanged: the subject carrier, the folded standings and their scopes, the exact
source union … the predecessor identities."* **That was the defect.** A carrier is
a data object a caller holds; a data object can be copied, and its list cells can
be rewritten through the very readers that make it inspectable. Trusting it made
`ml0-materialize-consolidation` a caller-selectable route to a durable standing —
measured, `RED-CARRIER-BEFORE.txt`.

**THE CONTRACT, NORMATIVE.** Given a carrier, materialization:

1. takes the **identities** of `ml0-consolidation-inputs`, and nothing else from
   the object;
2. **re-retrieves each input from the TARGET `store`** through `ml0-retrieve` —
   the validated chain, inherited warrants and all;
3. **re-runs `ml0-consolidate`** over what the store actually returned;
4. builds the canonical account body that **each** carrier — presented and
   recomputed — would produce, and compares their **digests**;
5. writes the **RECOMPUTED** body, never the presented one.

**`ML0-MAT-2` — A DISAGREEING CARRIER IS REFUSED, NEVER CORRECTED.** If the two
digests differ, the carrier is stale or altered and materialization refuses,
naming both digests. **It does not quietly write the recomputed body in place of
the presented one**: a caller holding a carrier that disagrees with the store is
holding something it should be told about, and silently substituting the right
answer would hide exactly the event this requirement exists to surface.

**`ML0-MAT-3` — EVERY PREDECESSOR MUST BE RETRIEVABLE FROM THE TARGET STORE, SO
CROSS-STORE MATERIALIZATION IS REFUSED.** A carrier computed over accounts of
store A cannot be materialized into store B. Before R4.1b it could
(`RED-CARRIER-BEFORE.txt`: `PROBE-3 cross-store -> WRITTEN into foreign store`).
A derived account whose predecessors the reading store cannot produce is a
**lineage claim the store cannot check**, and this lane's argument throughout is
that a reader checks rather than trusts. ⚠ **The cost is disclosed, not hidden:
this NARROWS the cross-journal consolidation case named by Architecture 0.1's
D4** (builder fork R4.1-F3). Two stores' accounts of one act may still be
consolidated *in memory* — `ml0-consolidate` is effect-free and knows nothing of
stores — but the result cannot be made durable in either.

⚑ **RULED — DISPOSITION A (Sol, 2026-08-21; WORK-ORDER AMENDMENT 3).** R4.1c
correctly refused to call this "future work" and left it OPEN as a governance
item; it is now **answered by the one who could answer it**. Sol accepts
same-store-only durable consolidation for Memory Layer /0: **`ML0-MAT-3` stays** —
every predecessor must be retrievable from the destination store — and effect-free
consolidation across stores *"may compute, but /0 shall not materialize that
result durably."* **This does not amend Architecture 0.1 D4**: *"cross-journal
merges are receipt-bearing transformations, never timestamp sorts"* remains binding
on any future implementation. **Memory Layer /1 is RESERVED** for receipt-bearing
cross-journal materialization and the standing of foreign warrants — source-store
identity, predecessor receipts, offline verification limits, and what a destination
may honestly conclude without reopening the source store. The charter is recorded
at `MEMORY-LAYER-1-RESERVED-CHARTER.md`; **`/1` was not built in this pass and the
charter opens no lane.**

**`ML0-MAT-4` — THE SUBJECT PRINCIPAL IS STRIPPED EXACTLY ONCE.** A validated
account renders its subject principal as `principal:<name>`, while
`ml0-account-body` wraps a **bare** name. Feeding the rendered form straight back
in doubled the prefix on every materialization
(`principal:principal:actus-memoratus`), so a derived account could never be
re-consolidated with its own input — it failed `ML0-CON-4`, the one-subject rule,
against its own ancestor. `%ml0-bare-principal` (internal) strips exactly one
`principal:` and **refuses any other shape** at `ML0-MAT-4`. It does not loop,
trim or normalize: the only shape this lane writes is the one shape it strips.

**Nothing here recomputes a standing FROM A CALLER'S FIELDS and nothing here
accepts one from a caller.** The standings written are those the store's own
validated inputs fold to, computed inside this call.

**WHAT IT DOES NOT DO:** it does not re-run the direct-write promotion rule (a
derived standing was computed by consolidation over the union and is written **as
computed**, `:contradicted` included); it does not apply `ML0-WR-6` (that refusal
belongs to a single bundle — a contradiction *between* accounts is the thing
consolidation exists to record); it reads no world and no act journal (the effect
observation is the null `not-read`); it performs nothing, issues nothing,
authorizes nothing.

**WHAT IT SHARES WITH WRITE:** the append-and-readback tail
(`%ml0-append-body-and-read-back`), so the failed-write semantics are **identical
on both routes** — and that now includes the **step (4b) dry decode**: the derived
route's frame is encoded, decoded and identity-compared before its append exactly
as the direct route's is, refusing at `ML0-WR-8` pre-mutation. **§5.A as amended
(AMENDMENT 2) governs both routes in the same words**, because it governs the one
function they share; the residue on both is **host fault only**.

**MEASURED:** `RED-CONSOLIDATION-AFTER.txt`, **35 checks**, 0 failures, exit 0 —
including a **fresh-process** retrieval of the derived account (`:occurred` /
`:consolidation`), byte-identical derived content under reversed input order, the
modelled `:contradicted` case surviving materialization and a second fresh
process, and (§8, R4.1b; **eight checks, `[028]`–`[035]`**) the routes above: the `#S`
refusal sampled `[028]` and enumerated over every lane structure `[029]`, a
rewritten source list `[030]` and a rewritten predecessor list `[031]` each
refused at `ML0-MAT-2`, a
`copy-structure`'d carrier materializing identical content `[032]`, the principal
un-doubled `[033]`, a derived account re-consolidating with its own input
`[034]`, and the foreign store refused at `ML0-MAT-3` `[035]`.

⚑ **AND ONE PJ0 FACT THE PROBE MEASURED RATHER THAN ASSUMED (check [016]).** Two
materializations of **byte-identical derived content** land on **ONE frame**:
because the account identity digests the whole body, `append-event` is idempotent
on event identity (PJ-APP-1..3). The chair's first draft of that check expected
**two** frames and was corrected by the measurement — recorded because a
prediction that lost to its own instrument is worth more than a check that never
had one.

---

## 9. COMMENSURABILITY (work order AMENDMENT 1.5)

`:contradicted` requires **commensurable** warrants: the same proposition over a
**compatible declared scope** and a **compatible frontier/sequence interval**.
Same act identity plus opposite keywords is **insufficient**.

The test is executable, not rhetorical (`ml0-warrants-commensurable-p`): the two
sources must name the same act identity, declare the **same scope universe**, and
declare the **same observation interval** — both of which are required fields of
every source, so neither can be silently absent.

**Non-comparable observations are preserved without last-write-wins, and their
combination is `:unresolved` or plural — not contradictory.** Two honest looks at
different universes, or at different points in a sequence, are *expected* to
differ; calling their difference a contradiction would manufacture a conflict out
of ordinary bookkeeping.

**⚠ SUPERSEDED AND SHARPENED, 2026-08-20 REPAIR ROUND: `:contradicted` is now
UNREACHABLE in this slice.** A row warrants only if a door validated it, and two
correct doors reading one universe over one interval agree — so no commensurable
clash between *warranting* rows can arise. The standing remains in the vocabulary
and in the consolidation logic, reachable only by a future second witnessing
mechanism over one universe. **`observation-interval` is not the sole
machine-readable frontier/sequence relation** — `attests` is the finding and
`frontier-relation` its narration; commensurability compares the interval and the
scope and deliberately not the finding, which would make the concept collapse.
See the RETURN §R3b for the full answer and the disclosed deviation.

**⚠ An honest limit, stated rather than implied.** Two *correct* looks at one
universe over one interval agree by construction. A commensurable clash therefore
means **one of them is wrong** — and the specimen cannot produce that state by
honest reading alone. The `:contradicted` row is exercised with a **constructed**
disagreement (a forced attestation, modelling a mistaken or tampered observation),
and both the code and the transcript say so. What is demonstrated is that the
layer *preserves* such a clash rather than resolving it; what is **not**
demonstrated is a clash arising naturally.

---

## 10. Explicit non-implications

A public reader of this lane may **never** conclude:

- **that an act occurred**, from an issued evidence object, its digest, its
  receipt, or any report describing it;
- **that an act occurred**, from any account this lane wrote (they are all
  `origin/self-reported`);
- **that evidence was not issued**, from anything at all — the axis has no
  negative member;
- **that a retrieved account is current-image evidence**, or confers continuation
  authority;
- **that a successful validation upgrades** a reconstructed source to an
  observation;
- **that a `:could-not-look` is an absence**;
- **that an account's durability** exceeds the journal store's own declared
  ceiling: an fsync-barrier host-contract belief on Linux ext4, never power loss,
  never adversarial tampering, never a storage-stack proof.

---

## 11. Known holes, carried openly

1. **No public evidence identity or content digest exists.** Core /0's
   `%core0-issuance-content` is internal, and exporting it would trip this
   commission's second stop condition. An issuance source's coordinate is
   therefore a **caller-side projection** over public readers, and the record
   says `basis: caller-supplied-projection` in its own durable bytes. It is not
   an evidence identity and two evidence accounts with the same projection are
   not thereby the same account.
2. **`:contradicted` is not naturally reachable** in this slice — §9. ⚑ **R4.1
   SPLITS THIS HOLE IN TWO, AND ONLY ONE HALF CLOSED.** *Reachable through the
   carrier:* when consolidation lawfully computes `:contradicted`, it is now
   written and read back durably, across a process boundary
   (`RED-CONSOLIDATION-AFTER.txt` [023]–[027]) — before R4.1 it could be computed
   and had nowhere to go. *Still unreachable from two correct production doors:*
   two correct doors reading one universe over one interval agree by
   construction, so the clash in that probe is **MODELLED** — a real absence
   door's row re-copied onto the positive row's universe and interval through the
   lane's **internal** row constructor, from inside the lane package, which no
   caller outside it can do. What is demonstrated is that the layer *preserves and
   durably records* such a clash; what is **not** demonstrated is a clash arising
   naturally. ⚑ **R4.1b — ONE CLAUSE ABOVE WAS FALSE WHEN IT WAS WRITTEN.**
   *"through the lane's internal row constructor … which no caller outside it
   can do"*: until the BOA cure (§6c) an outside caller COULD build that row,
   from a `#S` literal. ⚑ R4.1e wording, replacing "it is true now": what holds now is
   the narrower statement — the modelled row's door stamp is not exposed through the exported, supported API; Common Lisp package privacy is not a capability boundary — an internal constructor remains callable through package-internal access — and BOA closes the supported SBCL `#S` route, not every possible call. The hole itself does not move — a clash
   arising naturally from two correct doors is still not demonstrated.
3. **D4's predicted condition name is not what happens.** See the RETURN §4:
   Core /0 refuses a memory account **earlier** than its issuance check, at the
   type boundary. The invariant is proved; the condition name is recorded, not
   forced.
4. **Same-family hands throughout.** Builder and chair are one lineage. Nothing
   here is independent verification and no stranger has reviewed this lane. ⚠ R4
   AMENDS THIS ONE, AND THE AMENDMENT IS THE ROUND'S BIGGEST FACT: a **cross-family**
   reader (a GPT/Codex worker) found in one pass what three same-family rounds and
   two chair dispositions did not — the mutant seam on the public arglists. It was
   an audit of the code, not an execution-level reverification, and it is still not
   a stranger's *acceptance*; but it is the first non-Claude eye on this lane and
   the finding it returned was the blocker. ⚑ **R4.1b — IT HAPPENED A SECOND
   TIME, AND THIS ONE EXECUTED.** A Codex worker (SCRUTATOR) reviewed R4.1
   **statically and by running the lane**, returned *"R4.1 is blocked on the
   stated design rule"*, and its two blockers were the `#S` reader (§6c) and
   the mutable carrier (§8/Materialize). **Two rounds, two blockers, both found
   by the only non-Claude eyes that have looked.** Still not a stranger's
   acceptance: a reviewer commissioned by the chair, reading the chair's tree,
   is an outside of *weights* and not an outside of *interest*. **The stranger
   audit is OWED.**
5. **A post-append refusal mutates the store** — §8/Write. Disclosed semantics,
   not a cured defect. ⚑ **R4.1: this is an OPEN GOVERNANCE VARIANCE against
   work-order §5.A, not a settled reading of it** — see the pointer in §8/Write,
   the RETURN's R4.1 section, and the parked question
   `notes/2026-08-21-ml0-failed-write-variance-question-for-sol.md`. It now
   applies to **both** durable routes, since `ml0-materialize-consolidation`
   shares the same append-and-readback tail.
   ⚑ **R5 — RULED AND NARROWED, NOT CURED.** §5.A is amended to the retained-frame
   semantics (AMENDMENT 2), so this is **no longer a variance**; and the pre-append
   dry decode (step (4b), `ML0-WR-8`) moves **every refusal this lane can raise about
   its own frame** to before the append. **The residue is host fault only.** It is
   not zero: a host fault between append and readback still leaves a frame with no
   account returned and no retraction performed — which is now the **governing**
   semantics rather than an unruled deviation. Measured at TOOTHs 11–13.
6. **The effect axis has no door.** Question 4 is answered by caller testimony,
   now marked as such in the type and in the bytes, but marked testimony is still
   testimony.
7. **The record-coverage door reads THIS store and nothing else**, which is the
   whole of its competence — and its `:issuance-record-present` finding means *an
   account in this store carries `:issued-in-writing-image` for this act*, never
   anything about Core /0's registry.
8. **The overlay's three re-expressed mutants** are one remove further out than
   the seams they replace (`:drop-scope`, `:origin-upgrade-on-readback`,
   `:retain-live-evidence`) — disclosed in the overlay's own header and in the
   RETURN's R4 section.
9. **⚑ R4.1 — A GATE OF THIS LANE WAS FOUND DISARMED WHILE GREEN.** When
   `ml0-consolidate`'s return type changed, one conjunct of `ml0-red-proof`'s
   crown tooth began comparing a keyword against a struct: it **could not be
   false**, the gate went on exiting 0 and printing *the tooth bites*, and nothing
   failed. It was found by **diffing a preserved transcript against a live one**,
   never by an exit code. Repaired, and the conjunct is now shown load-bearing
   (the two arms disagree on it). The class is the lab's *absence needs a
   warrant*: **a gate never seen to fire is untested, not passing.** The lane-wide
   sweep that followed enumerated **29** `ml0-consolidate` call sites outside
   `ml0.lisp` across 8 files and found no second instance — a sweep's result, not
   a proof of absence.
10. **⚑ R4.1 — THE SPECIMEN TRANSCRIPT IS NOT A WITNESS TO THE R4.1 SPECIMEN
   REPAIR.** `RUN-SPECIMEN.txt` is byte-for-byte its R4 capture (sha256
   `39849f99…`) while the specimen's durable payload **did** change; the
   transcript prints no D6 account identity, so a reader comparing transcript
   digests across the two rounds would conclude nothing moved. A determinism twin
   is evidence about **one build against itself**, never about a build against its
   predecessor.

---

*— TABULARIUS (Claude Opus 5, subagent), 2026-08-20. CANDIDATE.*
*R4 amendments — OBTURATOR (Claude Opus 5, subagent), 2026-08-20. CANDIDATE.*
*R4.1 amendments (§5, §6, §8/Write, §8/Consolidate, §8/Materialize, §11) — SCRIBA
(Claude Opus 5, 1M context), 2026-08-21. The failed-write wording of §8 is
**deliberately unamended**: it is the subject of an OPEN governance variance and
rewriting it here would close by editing what has not been closed by ruling.
CANDIDATE.* *(R5 note: since closed BY RULING — Sol disposition B, AMENDMENT 2; §8's
failed-write wording now carries the amended contract.)*

*R4.1b amendments (header, §6b, **§6c new**, §8/Consolidate, **§8/Materialize
rewritten**, §11 holes 2 and 4) — SCRIBA-II (Claude Opus 5, 1M context),
2026-08-21, after SCRUTATOR's cross-family review. The failed-write wording of §8
remains **deliberately unamended** for the same reason. CANDIDATE.*

*R5 amendment (header, §8/Write step (4b) + `ML0-WR-8` + the amended §5.A contract,
§8/Materialize's shared-tail paragraph, §8/Materialize's `ML0-MAT-3` disposition,
§11 hole 5) — SCRIBA-IV (Claude Opus 5, 1M context), 2026-08-21, entering Sol's two
dispositions. **The failed-write wording of §8 is amended HERE FOR THE FIRST TIME,
and only because it was ruled on**: three prior officers left it deliberately
unamended so as not to close by editing what had not been closed by ruling. No
production logic changed in this documents pass; the code narrowing it describes was
made by the chair at `eaad89b5`. CANDIDATE · NOT REGISTERED · stranger audit OWED.*
