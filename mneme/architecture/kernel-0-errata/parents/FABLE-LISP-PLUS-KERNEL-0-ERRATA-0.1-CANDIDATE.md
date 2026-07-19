# FABLE-LISP-PLUS-KERNEL-0-ERRATA-0.1-CANDIDATE

**Status:** INDEPENDENT ERRATUM CANDIDATE ONLY — not adopted, not governing, not merged.
Produced as one of two independently authored candidates for later comparison and synthesis
under owner review. Nothing below amends any governing file until an owner adoption act.
**Author:** Claude Fable 5 (Opus lineage, lab chair), blind-drafted 2026-07-18 (night).
**Independence statement:** this candidate was seeded exclusively from the governing
repository artifacts enumerated in §0.1. The author did not inspect, request, infer from, or
search for any erratum draft produced by GPT, Sol, Codex, or any other reviewer, and in
particular did not open, grep for, or list-search for `LISP-PLUS-KERNEL-0-ERRATA-0.1.md`.
**Repository commit inspected:** `261122d15228c9214864fc3e28381c94651996b1` (lab tree
`Claude-Code-Lab`, whose `experiments/latent-lisp/` is the canonical source of the public
mirror `github.com/Wondermonger-daydreaming/latent-lisp`).

---

## 0. Standing, sources, and jurisdiction preservation

### 0.1 Artifacts relied upon (all read in full or at the cited sections, at the commit above)

| Artifact | Role |
|---|---|
| `mneme/architecture/LISP-PLUS-KERNEL-0-SPEC.md` (2,397 lines incl. pre-seal repairs) | the governing Kernel /0 spec this erratum amends; R-SYN-1..3 included |
| `mneme/architecture/LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md` — §6.3 (claim facets), §6.10, §15.2, §16, §17 | superior law; source of the call-296 projection and the claim-standing facets |
| `mneme/architecture/process-journal-0/LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md` (1,451 lines) | adopted PJ0; owns all journal bytes/framing/digests/salvage/reconstruction receipts |
| `mneme/architecture/process-journal-0/PJ0-PRESEAL-REPAIRS.md` (R-PJ-1..3) | governs jointly with PJ0 |
| `mneme/architecture/process-journal-0/PJ0-ADOPTION-RECORD.md` | PJ0 adoption terms incl. the CL independence gate |
| `mneme/architecture/adapter-protocol-0/lisp-plus-adapter-protocol-0-reissue/LISP-PLUS-ADAPTER-PROTOCOL-0-SPEC.md` (1,486 lines) | the governing reissued AP0 (adoption record confirms the reissue governs) |
| `mneme/architecture/adapter-protocol-0/AP0-ADOPTION-2026-07-18.md` | AP0 adoption + binding riders (CL gate; stranger audit) |
| `mneme/architecture/ARCHITECTURE-0-STATUS.md` | the chamber WE-ARE-HERE; the six-authorial-gap ledger |
| `mneme/architecture/IMPLEMENTATION-PHASE-BOARD-2026-07-18.md` | the erratum lane's charge ("Kernel errata" section; AP-G4 disposition) |
| `mneme/kernel0/README.md` | the pure-core arc's own gap ledger ("Specification gaps and bounded claims" 1–7) and excluded-test table |
| `mneme/kernel0/determinacy.lisp`, `fixtures.lisp`, `conditions.lisp`, `manifestation.lisp` (constructor), `records.lisp` (claim/validation surfaces), `outcome.lisp` (axis checks) | the implementation state the erratum must land on |

### 0.2 Artifacts deliberately excluded

- Any erratum draft authored by another model for this same lane — specifically anything
  named `LISP-PLUS-KERNEL-0-ERRATA-0.1.md` — **never opened, never searched for**; no
  content grep for "errata" was run anywhere in the tree, precisely so that no such
  draft's text could surface in tool output. (The CD/0 errata family under the repo root
  concerns Canonical Datum /0, a different subsystem; not read for this work.)
- `SOL-COMMENTARY-*`, `SOL-POSITIONS-*`, `SOL-DISPOSITION-*`, `AMENDMENT-CANDIDATES-0.1.md`:
  pre-seal deliberation records whose adopted content is already reflected in the decisions
  record, A0.1, and the STATUS stone — excluded to keep the seed strictly to adopted state.
- The frozen original (non-governing) AP0 candidate packet `lisp-plus-adapter-protocol-0/`:
  superseded evidence; only the governing reissue was read.

### 0.3 Scope and gap identification

This erratum closes the four open Kernel /0 implementation gaps of the erratum lane
("kernel0 gaps 1–4 sitting", STATUS stone Addendum 5; phase board "Kernel errata"). Note a
**numbering divergence in the repository** that this candidate resolves explicitly rather
than silently: the STATUS stone's six-gap ledger and the kernel0 README's seven-item
"Specification gaps and bounded claims" list do not number identically. This erratum closes
the union of the still-open items, organized under the four commissioned heads:

- **Gap 1** — bounded determinacy and the call-296 fixture (STATUS gap 1 ≡ README gap 1) → §1.
- **Gap 2** — Kernel §23 reconstruction evidence (README gap 2), **folding in** STATUS gap 2
  (the §13.6/§13.3 `:attempt-indeterminate` event hole), which is event-protocol matter → §2.
- **Gap 3** — validation/integrity/visibility/standing; tests 43, 44, 47, 48 (README gap 3),
  with README gap 4's test-45 residue closed by §4.2 → §3.
- **Gap 4** — AP0 structural vs Kernel semantic validation and the §8.1-vs-A.2 field
  mismatch (STATUS gap 4, AP-G4-4's routed lane) → §4.
- STATUS gap 3 (condition minting vs the `standing-inflation` borrow) is closed at §5.
- STATUS gaps 5 and 6 are **already closed** by PJ0 §16 (fold-derived resolvedness) and PJ0
  §17.3 (`unsupported-reconstruction`); recorded in the trace matrix, no amendment needed.

### 0.4 Jurisdiction preservation (binding on every section below)

1. **PJ0 retains ownership** of framing, canonical bytes, digest procedures, prefix
   validity, torn-tail classification, salvage, snapshots, merge format, and reconstruction
   receipts (Kernel §2.4/§27.1; PJ0 §2.2). This erratum introduces **no second journal
   grammar**; every byte-level term below is a reference into PJ0.
2. **AP0 retains ownership** of envelope custody, structural projection, absence-mapping
   tables, acknowledgment/cancellation/reconciliation semantics, and the exact field value
   spaces and conformance conditions for adapter-identity and stream/chunk fields
   (AP-G4-3). This erratum names kernel-side slots and laws only (per Kernel §8.1), exactly
   as AP-G4-4 routed.
3. Architecture 0.1 and the owner decisions record remain superior; where this erratum
   would conflict with either, the erratum is defective there (Kernel §0 discipline).
4. **Unchanged by this erratum:** Canonical Datum /0 bytes; PJ-S/0; PJ0 framing; AP0 vector
   bytes; provider-specific semantics; Language-A classifications (the 76 kimi records stay
   in the locked lane); capability-authority law (except the two accidental-implication
   guards at §3.3 and §3.4, which prevent standing/authority inflation and grant nothing).

### 0.5 Amendment vocabulary

Each numbered requirement below carries a stable ID `KE-n`. Every amendment is labeled:

- **[REPLACEMENT]** — supersedes identified governing text;
- **[ADDITION]** — new normative text at an identified insertion point;
- **[CLARIFICATION]** — binds an interpretation of existing text without changing it.

---

## 1. Gap 1 — Bounded determinacy and the call-296 fixture

### 1.1 What `:bounded` requires — the alternative-space law

**KE-1 [ADDITION to §7.3].** Every `:bounded` determinacy record quantifies over a
**declared alternative space**, and each alternative MUST be a complete candidate member of
that space:

- for the **execution, manifestation, and interpretation axes**, the space is the axis
  value space (§9.2, §9.3, §9.5). For the manifestation axis a candidate is a
  manifestation reference or a complete `(:absent :state <absence-state>)` form — a bare
  absence-state atom is not a candidate value;
- for the **external-effect axis**, the space is the settlement space of the referenced
  §10.8 uncertain-effect record: the determinacy alternatives MUST be identical, as a set
  under the kernel's named equality, to that record's `:possible-effects` (see KE-4);
- for **claim-level determinacy**, the space is named by the record's `:target`
  (A0.1 §6.3.5), which remains a library-representable protocol.

An alternative outside the declared space, a bare-atom alternative where a complete value
is required, or a mismatch under KE-4 MUST signal `determinacy-alternatives-invalid` (§5).

*Trace:* §7.3's "named alternatives" left the space unnamed; A0.1 §6.3.5's `:target` field
is the adopted precedent that alternatives quantify over an identified space. §22's effect
alternatives `(:billed :not-billed)` are settlement-space members, not axis-enum members —
KE-1 makes that reading normative instead of accidental.

### 1.2 Singleton alternatives are lawful, with exactly one meaning

**KE-2 [CLARIFICATION of §7.2/§7.3; ADDITION to §7.3].** A singleton alternatives set is
**lawful**. Its normative meaning is **eliminative narrowing without positive license**:
the recorded evidence excludes every other member of the declared alternative space, but
does not positively license the surviving member under the named procedure (§7.2's
licensing standard). Consequences, all normative:

1. a singleton `:bounded` record asserts that its enumeration is **exhaustive over the
   declared space**; its evidence MUST support the exhaustiveness of the elimination, not
   merely the plausibility of the survivor;
2. no fold, accessor, or transformation may read singleton-`:bounded` as `:determinate`.
   Promotion to `:determinate` is a receipted transformation citing positive licensing
   evidence; silent promotion signals `standing-inflation` (§15.6 pattern);
3. the empty set remains refused (§7.3 unchanged); `:indeterminate` remains the mode for
   "no lawful finite alternative set exists" (§7.4 unchanged). The three modes are now
   pairwise distinguishable at every set size.

*Why not forbid singletons (≥2 rule):* a ≥2 rule would force every eliminatively-narrowed
axis to lie in one of two directions — claim `:determinate` without positive license
(inflation) or claim `:indeterminate` while holding a lawful finite set (deflation). The
governing text (§7.3 "non-empty") already permits the honest middle; KE-2 gives it teeth
instead of removing it.

### 1.3 Value-membership law

**KE-3 [ADDITION to §7.3/§9.1].** When an axis asserts a current value **and** carries
`:bounded` determinacy, the asserted value MUST be a member of the alternatives set: the
value is the projection's best-supported candidate; the determinacy names which candidates
remain licensed. Exception: the external-effect axis value `:bounded` (§9.4) is itself an
axis-enum member signaling bounded settlement; there, membership is checked between the
determinacy alternatives and the referenced record's `:possible-effects` (KE-4), not
against the axis enum. Violation signals `determinacy-alternatives-invalid`.

### 1.4 Effect-axis alternatives are the uncertain-effect record's alternatives

**KE-4 [ADDITION to §9.4].** A `:bounded` external-effect axis MUST carry determinacy
alternatives set-identical to the `:possible-effects` of the §10.8 uncertain-effect record
it references. One uncertainty, one alternative set, two views — never two divergent
enumerations of the same unsettled effect. Divergence signals
`determinacy-alternatives-invalid`. (The §22 fixture already satisfies this:
`(:billed :not-billed)` in both places.)

### 1.5 The call-296 manifestation determinacy — resolution

**KE-5 [CLARIFICATION of §22, extending R-SYN-1; ADDITION to §22's projection-status
paragraph].** The §22/E-1 projection bytes are **unchanged** and remain a canonical axis
projection, not a complete constructible record (R-SYN-1). The projection names `:bounded`
manifestation determinacy but supplies no alternatives; the resolution is:

1. **The omission is repaired locally, by derivation from adopted law — not by facts about
   call-296.** A conforming construction MUST bind the manifestation axis's bounded
   determinacy to the alternatives set

   ```lisp
   ((:absent :state :absent-after-completion))
   ```

   — a singleton of the **complete axis value** (KE-1 form), derived as follows: the
   frontier was crossed (the uncertain-write evidence), eliminating `:never-attempted` and
   `:refused-pre-effect`; a subject manifestation was expected, eliminating
   `:not-applicable`; no withholding or redaction relation is in evidence; no payload
   identity of any kind was captured, so no `:present*` candidate exists on the interface
   side of the boundary (DK-2/§8.8: with no captured envelope there is nothing to project);
   and §8.7's state vocabulary is **closed**, with §28 stop-conditions 1 and 3 forbidding a
   minted state. Exactly one member of the space survives. This is the KE-2 singleton
   meaning instantiated: exhaustive elimination, no positive license.
2. **The determinacy stays `:bounded`, not `:determinate`,** because the positive licensing
   fact — that execution *completed* in the sense the surviving state's name presupposes —
   is precisely what the execution axis records as `:indeterminate`. Reclassifying the
   manifestation determinacy to `:indeterminate` is **forbidden**: it would contradict the
   adopted A0.1 §15.2 / E-1 projection, which a Kernel erratum cannot overrule; and a
   lawful finite set demonstrably exists (§7.4 would be false).
3. **Refusing construction is not required and not permitted as the default.** The fixture
   is constructible today under 1–2. What remains **non-constructible pending a sealed
   evidentiary act** is any *narrowing*: resolving execution's indeterminacy, narrowing
   `(:billed :not-billed)`, or attaching any factual classification of the live Language-A
   records — all of that arrives only through reconciliation under the sealed call-296
   protocol (§10.8 UNC-2) or the locked scoring lane, never through the constructor.
4. **Implementation consequence (form repair):** the existing pure-core fixture's
   alternatives value `(:absent-after-completion)` — a bare state atom — becomes the
   complete-value singleton above. This changes form, not substance; the arc's flagged,
   declared use is blessed as historical evidence (cf. §5.2).
5. **Recorded, not patched (bounded unknown):** the surviving state's name presupposes
   completion while execution is indeterminate. The closed vocabulary has no
   post-frontier-failure absence state, and minting one is a §28 stop. This tension rides
   as a named bounded unknown on the fixture
   (`:absence-state-name-presupposes-completion`), for A0.1's next amendment round to keep
   or dissolve — an erratum does not widen a closed architectural vocabulary.

### 1.6 Negative controls for Gap 1 (required; see §7)

(a) fabricated-second-alternative fixture (a `:present` candidate with no payload evidence)
refused/caught; (b) mutant fold promoting singleton-`:bounded` to `:determinate` caught;
(c) mutant narrowing effect alternatives to `(:billed)` without reconciliation caught;
(d) bare-atom alternative caught by `determinacy-alternatives-invalid`; (e) effect-axis
alternatives diverging from `:possible-effects` caught.

---

## 2. Gap 2 — Kernel §23 reconstruction evidence

### 2.1 The six standings a terminal-row fixture must keep distinct

**KE-6 [ADDITION to §23 preamble].** The §23 per-row obligation ("constructed, journaled,
killed-and-reconstructed, and re-derived byte-identically where determinism is declared")
is discharged through Process Journal /0, and the following are distinct and MUST NOT be
conflated in any row's evidence or verdict:

| # | Standing | Owner | What identity means here |
|---|---|---|---|
| 1 | **PJ0 structural validity** | PJ0 §12–§13 | the byte prefix validates; terminal classification is `:valid-end` / torn tail / corruption |
| 2 | **Kernel semantic validity** | Kernel §13.5 | the decoded event sequence is a legal process history; reported **separately** from 1 (PJ-VAL-3, PJ0 §17.2) |
| 3 | **source-frame identity** | PJ0 §7–§8 | frame bytes + digest chain of one store; **not preserved across salvage** (PJ-SAL-2) and never the §23 comparison object across stores |
| 4 | **deterministic semantic replay identity** | Kernel §13.7/§19.9 + PJ-SNP-4 rendering | canonical bytes of the fold-derived view under a named fold identity+version and named deterministic rendering — **this is the object of §23's "re-derived byte-identically"** |
| 5 | **reconstruction-receipt identity** | PJ0 §19 | each reconstruction act's receipt; two lawful reconstructions of one prefix agree on all source-binding and output-digest fields while differing as records (own identity, operator) — §23 requires **field agreement**, never whole-receipt byte identity |
| 6 | **abstract event identity** | Kernel §13.2 / PJ0 §9.3 | the reconciliation and idempotency key; preserved across salvage and lawful merge coalescing |

### 2.2 The terminal-row evidence bundle

**KE-7 [ADDITION to §23, after the preamble; sharpens §25.5 tests 34–41 without renumbering].**
A conforming terminal-row conformance fixture MUST contain, at minimum:

1. the constructed outcome and auxiliary records for the row (Kernel jurisdiction);
2. the store identity and declared durability mode (PJ0 §6, §10);
3. the committed event identities with ordinals and frame digests, **by reference to PJ0
   append receipts** (PJ0 §9.4) — not restated bytes;
4. the declared kill point, classified against the PJ0 crash-window matrix (PJ0 §1) and,
   where the row involves an adapter, against AP0 W1–W4;
5. the post-kill strict-validation report: terminal classification, valid-prefix
   coordinate, terminal digest, and the preserved tail bytes or their externally located
   identity and digest (PJ-VAL-1; PJ0 Annex A closing rule);
6. an attestation that **every cache, index, snapshot, and finalizer product was deleted or
   excluded before reconstruction** (PJ-RCN-3, hereby made a per-row obligation, aligning
   §23 with §25.5 test 40 and §19.9's finalizer body-law);
7. the reconstruction receipt (PJ0 §19 fields; origin `:reconstructed`);
8. the derived-view canonical bytes and digest, **byte-compared** against the pre-kill
   derivation where determinism is declared (standing 4 of KE-6);
9. the Kernel semantic verdict over the decoded events, separate from item 5 (standing 2);
10. bounded unknowns — e.g. CW-2 physical variability (PJ-CW-2), or a tail that could
    contain a consequential settlement record.

### 2.3 Torn tails, corruption, salvage, merge — row behavior

**KE-8 [CLARIFICATION binding §13.8, §19.9, and PJ0 §13–§20 together].**

- **Torn tail:** the row's fold excludes the tail and preserves it as evidence (§13.8;
  PJ-VAL-1). Where the excluded tail could contain a consequential settlement record, the
  affected axis carries `:bounded` determinacy — at least one row fixture MUST exhibit
  this tail→bounded coupling.
- **Interior corruption:** lawful reconstruction ends at the last valid prefix; no
  skip-forward recovery (PJ-TERM-1). A row whose journal suffers interior corruption FAILS
  as that row (unless the fixture is itself a corruption fixture); the kernel MUST NOT
  accept a "reconstructed" view derived from bytes beyond the corruption point.
- **Salvage:** a row MAY reconstruct from a salvaged store (PJ0 §14). The bundle then adds
  the salvage receipt, and the derived-view byte comparison (KE-7 item 8) MUST still hold —
  abstract events are identical while source-frame digests lawfully differ (PJ-SAL-2).
  At least one row MUST demonstrate exactly this, as the standing proof that §23's byte
  identity is **replay identity, not frame identity**.
- **Merge:** outside the single-row path. A row over a merged journal carries the merge
  receipt (PJ0 §20), its derived view's origin is derived/reconstructed, and timestamp-only
  merge remains refused (PJ-MRG-1; §20.6 `journal-merge-receipt-required`).

### 2.4 The missing terminal event — `:attempt-indeterminate`

**KE-9 [ADDITION to §13.3; ADDITION to §13.5].** (Closes STATUS-stone gap 2, folded in as
event-protocol matter.) The event vocabulary gains `:attempt-indeterminate`, the recording
event for the §13.6 terminal class `:indeterminate` — without it no attempt could lawfully
*reach* the terminal state §13.6 names. Transition legality (§13.5 additions):

- `:attempt-indeterminate` may occur only after `:attempt-begun`;
- it is terminal: no further terminal event for that attempt except through reconciliation
  metadata that does not rewrite history (§13.5 last rule);
- it MUST reference the evidence that blocks a determinate terminal classification —
  ordinarily an `:effect-bounded`/`:effect-indeterminate` event, a §10.8 record, or a
  torn-tail boundary report;
- it does not resolve, and MUST NOT be folded as resolving, any unresolved effect
  (PJ-FOLD-1 unchanged).

### 2.5 No second journal grammar

**KE-10 [CLARIFICATION].** Nothing in §2 defines or constrains journal bytes. Every
byte-level term in KE-6..KE-9 is a reference into PJ0 by section and requirement ID; the
kernel consumes the store protocol's reports and receipts as opaque evidence. The PJ0
adoption record's CL independence gate is untouched and unsatisfied by anything here.

---

## 3. Gap 3 — Validation, integrity, visibility, and standing

*Makes §25.6 tests 43, 44, 47, 48 executable. Minimal machinery: three small record
protocols traced to A0.1 §6.3.2–6.3.4, one accessor law, and enforcement wiring for two
conditions that already exist (§20.7 `bare-validation-scope`, `bare-visibility-scope`).*

### 3.1 Validation records

**KE-11 [ADDITION as new §15.8.1; sharpens §15.1's "validation records" bullet].** A
validation record MUST bind:

- validation status, from the closed initial set `:unchecked | :checked | :verified |
  :refuted` (A0.1 §6.3.2);
- validator principal identity;
- procedure identity and version;
- scope — the proposition, aspect, or representation validated;
- evidence references;
- bounded unknowns.

A record whose status is other than `:unchecked` and which lacks validator, procedure, or
scope is **bare**: construction MUST signal `bare-validation-scope`. A lawful `:verified`
establishes exactly: *the named procedure at the named version, run by the named validator
over the named evidence, accepted the claim within the named scope.* It establishes no
truth outside that scope, rewrites no origin (§15.2), seals no bytes, publishes nothing.

### 3.2 Integrity records — what a seal establishes and does not

**KE-12 [ADDITION as new §15.8.2].** An integrity record MUST bind:

- integrity status, from `:open | :sealed` (A0.1 §6.3.3);
- digest or seal method identity and version;
- the exact representation identity sealed (content-datum identity or canonical-byte
  digest per CD/0);
- sealing principal;
- seal evidence.

A seal establishes: *the identified representation has not changed under the named method
since sealing, and who attested it* (the claim-plane analogue of PJ-HASH-1). It does NOT
establish truth, validation, origin, semantic acceptance, visibility, or that any mind
examined the content (PJ-HASH-2/3 analogues). **`:sealed` MUST NOT imply `:verified`:** no
accessor, fold, or transformation may derive validation standing from integrity records;
doing so signals `standing-inflation` — §15.6's sealed→verified row, now mechanically
checkable because the records are no longer opaque.

### 3.3 Visibility records — publication is relational

**KE-13 [ADDITION as new §15.8.3].** A visibility record MUST bind:

- visibility status, from `:published | :withheld | :redacted` (A0.1 §6.3.4);
- scope identity — an audience, channel-policy, or named-recipient identity;
- authorizing basis where the status requires authority (capability fingerprint or claim
  identity — a *reference*, granting nothing; capability law unchanged);
- the representation the record applies to;
- for `:redacted`, the redaction receipt reference.

Publication visibility is a **relation** between one representation and one scope — never a
property upgrade of the claim. A claim may carry several visibility records over disjoint
scopes. `:published` MUST NOT imply truth, observational origin, semantic acceptance,
verification, or integrity (§15.6's published→true row, now checkable). A record with
status `:published` and no scope is bare: construction MUST signal `bare-visibility-scope`.

### 3.4 Orthogonality under copying and transformation

**KE-14 [ADDITION as new §15.8.4].** Origin, validation, integrity, and visibility are
orthogonal facets and remain so under transformation. A transformation (copy, re-render,
excerpt, translation, canonicalization) yields a **new representation**, and:

- **integrity does not transfer**: a digest binds bytes; the constructor MUST refuse an
  integrity record whose representation identity does not match the claim's representation
  (refusal: `standing-inflation`);
- **validation does not transfer by default**: it carries over only where the named
  procedure's scope explicitly covers the new representation; otherwise the derived claim
  starts `:unchecked`, holding a provenance link through the §15.5 transformation receipt;
- **visibility does not extend**: publishing a derivative to a scope is a new visibility
  record under its own authorizing basis;
- **origin persists** as historical fact and is never rewritten (§15.2, §15.7).

The canonical fixture: copy a sealed+verified+published claim — the copy holds none of the
three standings and keeps origin plus provenance.

### 3.5 No procedure-free standing booleans

**KE-15 [ADDITION to §24 (L17 surface)].** The kernel MUST NOT expose a boolean
`verified-p` / `published-p` style accessor that answers without a procedure (validation)
or scope (visibility) argument. Conforming query forms are of the shape
`claim-validated-under-p (claim procedure-id scope)` and
`claim-published-to-p (claim scope-id)`. A context-free standing accessor is the
claim-plane form of the §24.4 bare-answer accessor and fails test 55's detector class.

### 3.6 Tests made executable

**KE-16 [CLARIFICATION of §25.6].** With KE-11..KE-15: test 43 = sealed claim yields no
derivable validation standing (+ mutant that promotes); test 44 = published claim yields no
derivable truth/acceptance/origin (+ mutant); test 47 = bare `:published` refused at
construction; test 48 = bare `:verified` refused at construction. Test 42 (asserted cannot
become observed by filing) already passes via `promote-origin`; unchanged.

---

## 4. Gap 4 — AP0 structural validation vs Kernel semantic validation; Appendix A.2

### 4.1 The jurisdictional boundary

**KE-17 [ADDITION as new §18.5].**

**AP0 may establish (structural, procedure-relative):** envelope capture and custody;
structural projection under a versioned procedure; manifestation statuses assigned through
its absence-mapping table; parser validity/invalidity as a *structural* judgment; stream
and chunk identity, ordering, gap, and duplicate evidence; acknowledgment classes within
the descriptor's witnessable set; usage and cost records with declared standing;
reconciliation results under AP-REC law; exposure events at the membrane; and the exact
value spaces for producer-identity and stream-relation fields (AP-G4-3).

**AP0 MUST NOT establish:** semantic acceptance or rejection of content; truth or quality
of emitted content (§18.4, AP-PRJ-2); effect settlement from acknowledgment classes alone
(AP-ACK-4); execution success beyond boundary evidence; claim verification or any standing
judgment of §15; authority of any kind; origin promotion (AP-PRJ-6: projections are
`:derived`).

**After a structurally valid AP0 projection, the kernel checks:** identity legality (§4,
§6); cross-axis invariants (§9.6); transition legality of the event sequence (§13.5,
including KE-9); effect-axis lawfulness (§9.4/§10.8, KE-4); interpretation licensing
(§9.5 + KE-18); standing rules (§15.6, KE-11..14); and status/absence-state mapping
consistency (§8.7). A structurally valid projection can still be semantically illegal —
e.g. `:present` asserted for an attempt whose journal shows `:not-attempted` — and the
kernel's refusal is then a **kernel semantic FAIL over an AP0 structural PASS**, which is a
lawful, expected joint result.

### 4.2 Judgment class: structural vs semantic procedures

**KE-18 [ADDITION to §9.5].** Every interpretation-procedure reference in an outcome
carries a declared **judgment class**: `:structural` or `:semantic`.

- `:accepted` and `:rejected` REQUIRE class `:semantic` — and (§9.6, unchanged) a
  manifestation with status `:present` or `:present-empty`;
- `:invalid` may be licensed by either class (a parser is a structural procedure whose
  negative verdict is a lawful interpretation result, §8.5);
- a `:structural` procedure licensing `:accepted`/`:rejected` signals
  `interpretation-class-violation` (§5);
- AP0 projection and parser procedures are `:structural` by definition (AP-PRJ-2); AP0
  descriptors carry the adapter-side declaration; the kernel-side field makes the claim
  inspectable and falsifiable at the outcome.

**KE-19 [CLARIFICATION].** *Parser-valid, decoded, captured, sealed, published* — none of
these defaults the interpretation axis. Absent a semantic procedure's run, the
interpretation axis is `:not-attempted` (or `:not-applicable` where the row declares no
interpretation). Any path that defaults a structurally valid projection to `:accepted` is
nonconforming (completes §25.6 test 45; README gap-4/test-45 residue closed).

### 4.3 Joint reports preserve divergence

**KE-20 [ADDITION to §25 preamble].** A joint AP0+Kernel fixture or conformance report
MUST carry at least two independent verdict fields — `:structural-verdict` (procedure: the
AP0 validator identity) and `:semantic-verdict` (procedure: the kernel validator/fold
identity) — each with value `:pass | :fail | :not-run` and its own condition references. A
report format that can express only one aggregate counter is nonconforming evidence.
"AP0 structural PASS, Kernel semantic FAIL" is representable, expected, and MUST survive
aggregation (the kernel-side twin of AP0 §24.3 and PJ-VAL-3).

### 4.4 `:present-invalid` and partial streamed manifestations

**KE-21 [CLARIFICATION binding §8.5, §8.6, §9.6, and AP0 §10/§17 together].**

- `:present-invalid`: payload identity and parser identity preserved (§8.5); the
  interpretation axis may reach at most `:invalid` under the structural procedure — never
  `:rejected` (which requires a semantic procedure over `:present`/`:present-empty`,
  §9.6 + KE-18); never converted to absence (`present-payload-erasure`).
- Partial streamed: status `:present-partial` with a mandatory stream relation (KE-22).
  Later absence of chunks, cancellation, parser failure, or missing finality never erases
  captured partials — the kernel restatement of AP-STR-7 and AP-CAN-3: a recorded
  manifestation with a payload identity is append-only evidence. Promotion to `:present`
  only through lawful settlement evidence, else
  `partial-manifestation-settlement-inflation` (§8.6 unchanged).
- Aggregating chunks into a combined payload is a §15.5 transformation with a receipt
  binding the constituent chunk identities; the aggregate never replaces the chunks as
  primary evidence.

### 4.5 Appendix A.2 — replacement

**KE-22 [REPLACEMENT of Appendix A.2, in full].** The A.2 sketch is replaced by:

```lisp
(manifestation
  :manifestation-id ...
  :attempt-id ...
  :kind ...
  :status :present|:present-empty|:present-invalid|:present-partial|
          :absent|:withheld|:redacted
  :payload-id ...                    ; required for every :present* status (§8.3)
  :absence-state ...                 ; required iff status is :absent|:withheld|:redacted (§8.7)
  :producer-identity                 ; REQUIRED for every manifestation (§8.1)
    (:producer-class :adapter|:kernel|:host-procedure|:principal|:fixture
     :producer-id ...                ; for :adapter — the adapter identity (AP0 value space)
     :producer-version ...)          ; required when :producer-class is :adapter
  :stream-relation                   ; REQUIRED for every streamed manifestation (§8.1)
    (:stream-id ...
     :chunk-id ...                   ; this chunk, or :aggregate
     :sequence-number ...
     :predecessor-chunk-id ...
     :constituent-chunk-ids (...)    ; required when :chunk-id is :aggregate
     :aggregation-receipt-id ...     ; required when :chunk-id is :aggregate (§15.5)
     :observed-final-p ...
     :provider-finality-claim ...)   ; distinct from observation (AP-STR-8)
  :parser-id ...                     ; required when invalidity is asserted (§8.5)
  :emptiness-rule-id ...             ; required iff status is :present-empty (§8.4)
  :source-boundary ...
  :visibility (...))
```

Normative rules riding the shape:

1. every AP0-produced manifestation has `:producer-class :adapter` and carries the adapter
   identity and version — the value spaces and conformance conditions of those fields are
   **owned by AP0** (AP-G4-1, AP-G4-3); the kernel names the slots (§8.1) and checks
   presence only;
2. every non-AP0-produced manifestation carries its producer class and identity — a
   manifestation with no identifiable producer is nonconforming;
3. every streamed manifestation carries the full stream relation — a bare `streamed-p`
   boolean or generic source label is nonconforming; ordering, gaps, duplicates, and
   adapter binding MUST be auditable from the relation (sequence number, predecessor,
   producer identity) plus AP0's chunk records;
4. chunk lineage remains inspectable: aggregates are receipt-bearing derivations that
   never replace their constituents (KE-21);
5. partial capture is never erased by later absence, cancellation, parser failure, or
   missing finality (KE-21);
6. `:emptiness-rule-id` enters the sketch from §8.4 (the A.2 sketch had also silently
   omitted it; the pure core already implements it).

§8.1's field list is already correct and unchanged; A.2 catches up to it. This closes the
§8.1-vs-A.2 mismatch exactly as AP-G4-4 routed: in the Kernel erratum lane, without AP0
rewriting Kernel bytes and without the Kernel absorbing AP0's value spaces.

---

## 5. Condition minting — closing the `standing-inflation` borrow

### 5.1 New condition types

**KE-23 [ADDITION as new §20.2a "Schema and constructor conditions"; ADDITION of one type
to §20.5].**

```lisp
;; §20.2a — schema and constructor conditions
malformed-constructor-shape        ; non-plist, unknown, or duplicate constructor fields
determinacy-mode-invalid           ; §7.1/§7.3 mode-law violations (mode outside the closed
                                   ; algebra; alternatives on a non-:bounded mode; empty set)
determinacy-alternatives-invalid   ; KE-1/KE-3/KE-4 space, form, membership, and
                                   ; possible-effects-identity violations
global-uncertainty-scalar-rejected ; §7.5: any outcome- or determinacy-level
                                   ; confidence/uncertainty/probability scalar

;; §20.5 — manifestation and interpretation conditions (one addition)
interpretation-class-violation     ; KE-18: :structural procedure licensing :accepted/:rejected
```

All are subtypes of the §20.1 base and carry its required context.

### 5.2 Disposition of the borrow

**KE-24 [CLARIFICATION].** The pure-core arc's use of `standing-inflation` as a generic
constructor refusal — declared as a stretch, every use carrying the real section in
`failed-invariant` — is **blessed as historical, recorded evidence**: the arc's selftest
results are not retroactively invalidated. From adoption forward, constructor refusals
MUST use the minted types; §25.1 test 8 re-anchors to
`global-uncertainty-scalar-rejected`. `standing-inflation` remains correct wherever the
refusal genuinely is a standing promotion (§15.6, KE-2.2, KE-12, KE-14).

---

## 6. Implementation consequences (files to modify after adoption)

| File | Change |
|---|---|
| `mneme/kernel0/conditions.lisp` | add the five KE-23 types (four in a new §20.2a family, one in §20.5) |
| `mneme/kernel0/determinacy.lisp` | KE-1 space/form checks; KE-2 singleton semantics note; switch refusals to `determinacy-mode-invalid` / `determinacy-alternatives-invalid` / `malformed-constructor-shape` |
| `mneme/kernel0/outcome.lisp` | KE-3 membership check; KE-4 possible-effects identity check; KE-18 `:judgment-class` field on interpretation axes with the `:accepted`/`:rejected` gate; test-8 refusal re-anchored |
| `mneme/kernel0/manifestation.lisp` | KE-22: `:producer-identity` and `:stream-relation` fields with presence rules (value-space checks stay AP0-side) |
| `mneme/kernel0/records.lisp` | KE-11/12/13 record constructors replacing opaque validation/integrity/visibility lists; KE-14 transformation orthogonality; KE-15 accessor forms |
| `mneme/kernel0/uncertain-effect.lisp` | expose `:possible-effects` set-equality helper for KE-4 |
| `mneme/kernel0/fixtures.lisp` | KE-5.4 call-296 form repair; KE-18 judgment classes on 23.3/23.4/23.6; new fixtures for tests 43/44/47/48 and the KE controls |
| `mneme/kernel0/folds.lisp` | KE-9 `:attempt-indeterminate` transition legality; KE-2.2 no-promotion guard |
| `mneme/kernel0/kernel0-selftest.lisp` | implement tests 43/44/47/48 (removing four exclusions); add §7 controls; update expected-output block |
| `mneme/kernel0/package.lisp` | exports for the new types/constructors/accessors |
| `mneme/kernel0/README.md` | retire closed gap entries; record the erratum as governing basis |

Journal-store (arc 3) and adapter-lane implementations inherit KE-6..KE-10 and KE-17..KE-21
as requirements on their fixture formats — no existing PJ0/AP0 vector byte changes.

## 7. Required negative controls and planted mutants

Beyond §25.8 (unchanged), adoption requires demonstrating each of the following fires:

1. bare-atom bounded alternative → `determinacy-alternatives-invalid`;
2. alternative outside the declared space → `determinacy-alternatives-invalid`;
3. asserted value not a member of alternatives → `determinacy-alternatives-invalid`;
4. effect-axis alternatives ≠ referenced `:possible-effects` → `determinacy-alternatives-invalid`;
5. mutant fold reading singleton-`:bounded` as `:determinate` → caught by suite;
6. fabricated second call-296 manifestation alternative → refused/caught;
7. mutant narrowing `(:billed :not-billed)` without reconciliation → caught;
8. `:attempt-indeterminate` before `:attempt-begun`, and a second terminal after it →
   `journal-illegal-transition`;
9. row fixture whose "reconstruction" skips past interior corruption → FAIL (PJ-TERM-1);
10. row fixture omitting the derived-artifact deletion attestation → nonconforming bundle;
11. sealed claim promoted to verified by accessor/transform → `standing-inflation`;
12. published claim read as accepted/true/observed → caught;
13. bare `:verified` / bare `:published` constructions → `bare-validation-scope` /
    `bare-visibility-scope`;
14. integrity record with mismatched representation identity accepted on a copy →
    `standing-inflation`;
15. `:structural` procedure licensing `:accepted` → `interpretation-class-violation`;
16. joint report flattened to one counter → nonconforming report format (KE-20);
17. manifestation without producer identity; streamed manifestation with bare
    `streamed-p` → constructor refusal;
18. chunk aggregate without receipt or constituents → constructor refusal;
19. global `:confidence` scalar → `global-uncertainty-scalar-rejected` (re-anchored test 8).

## 8. What remains unproven after adoption

1. Everything the pure-core README bounds remains bounded: no journal persistence,
   host-kill survival, reconstruction, or byte-identity evidence exists yet — KE-6..KE-8
   define the evidence, they do not produce it. The §23 kill/reconstruct obligation is
   discharged only by the arc-3 journal store + specimen work.
2. The PJ0 and AP0 **CL independence gates remain open**: nothing here is a conformance
   claim beyond co-authored self-consistency, and no specimen reliance on PJ0/AP0 claims
   is licensed by this erratum.
3. The **stranger audit** remains owed before any independence language, including about
   this erratum's own review chain.
4. The **factual classification of call-296 and the 76 kimi records** remains entirely in
   the locked scoring lane; KE-5 derives a form, not a fact.
5. The `:absence-state-name-presupposes-completion` tension (KE-5.5) is recorded, not
   resolved; it belongs to A0.1's next amendment round.
6. Whether visibility-scope identities should bind concrete channel-policy instances
   remains deferred to the channel-policy lane (§0.4 of the kernel spec's non-authorization
   clause unchanged).
7. This candidate itself is unreviewed: it awaits comparison with the independently
   authored sibling candidate, adversarial reading, and the owner's seal.

## 9. Adoption-record field sketch

```text
KERNEL-0-ERRATA-0.1 ADOPTION RECORD (sketch)
  sealed-by:            <owner>, <mechanism>, <date>
  adopted-artifact:     <final erratum file>, sha256 <...>
  parent-candidates:    <candidate A> sha256 <...> ; <candidate B> sha256 <...>
                        (independence basis: blind drafting attestations)
  synthesis-record:     <concordance/adjudication file>, divergences preserved
  per-gap disposition:  gap-1 <adopted|modified|refused> ; gap-2 ... ; gap-3 ... ; gap-4 ...
                        (STATUS gaps 2, 3 fold-ins: <disposition>)
  requirement-ids:      KE-1..KE-24 <each: adopted|modified|struck>
  governing-effect:     erratum RIDES BESIDE the sealed Kernel /0 spec (PJ0-PRESEAL-REPAIRS
                        precedent — spec bytes unedited) | or folded reissue with new sums
  implementation-charge: files per erratum §6; negative controls per §7 gate the arc
  unchanged-inventory:  CD/0 bytes; PJ-S/0; PJ0 framing; AP0 vectors; provider semantics;
                        Language-A classifications; capability-authority law
  riders:               CL gates and stranger-audit riders REMAIN BINDING and unmodified
  unproven-after:       erratum §8 list acknowledged at seal time
  recorded-by:          <chair>, at the owner's word
```

## 10. Trace summary

Full clause-level matrix in `FABLE-KERNEL-0-ERRATA-TRACE-MATRIX.md`. In one line each:
Gap 1 → KE-1..KE-5 (§7.3, §9.4, §22, §25.1, A.1); Gap 2 → KE-6..KE-10 (§23, §19.9, §13.3,
§13.5, §25.5; PJ0 by reference); Gap 3 → KE-11..KE-16 (§15.1, new §15.8, §24, §25.6);
Gap 4 → KE-17..KE-22 (§18.5, §9.5, §25 preamble, Appendix A.2; AP0 by reference);
conditions → KE-23..KE-24 (§20.2a, §20.5); STATUS gaps 5–6 already closed by PJ0 §16/§17.3.

---

*— Claude Fable 5 (Opus lineage), independent candidate, 2026-07-18. Produced blind to any
sibling candidate; awaiting comparison, adversarial review, and the owner's decision.*
