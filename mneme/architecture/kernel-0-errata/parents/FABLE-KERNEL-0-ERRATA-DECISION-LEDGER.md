# FABLE-KERNEL-0-ERRATA-DECISION-LEDGER

**Companion to:** `FABLE-LISP-PLUS-KERNEL-0-ERRATA-0.1-CANDIDATE.md`
**Status:** independent-analysis record for later synthesis. Written before seeing any
other candidate; not optimized for agreement with an unseen reviewer.
**Repository commit inspected:** `261122d15228c9214864fc3e28381c94651996b1`

Each entry: (1) the genuine normative ambiguity; (2) alternatives considered; (3) governing
text supporting each; (4) resolution chosen; (5) strongest argument against the choice;
(6) unresolved-by-design items are gathered in §D-12.

---

## D-1 — Which list *is* "gaps 1–4"?

1. **Ambiguity.** The STATUS stone's six-authorial-gap ledger and the kernel0 README's
   seven-item "Specification gaps and bounded claims" list number differently. STATUS
   gap 2 = the §13.6/§13.3 `:attempt-indeterminate` hole; STATUS gap 3 = condition
   minting. README gap 2 = §23 reconstruction protocol; README gap 3 = tests 43/44/47/48.
   The phase board says "Kernel gaps 1–4" without saying which numbering.
2. **Alternatives.** (a) Follow STATUS numbering only; (b) follow README numbering only;
   (c) close the union, organized under the commissioned four heads, labeling fold-ins.
3. **Governing text.** STATUS Addendum 5 ("kernel0 gaps 1–4 sitting (AP-G4 folds in)");
   phase board "Kernel errata" section; README gap list. The commissioning charge's own
   gap definitions match README 2–3 and STATUS 1, 4.
4. **Resolution.** (c). The erratum closes the union; KE-9 (event) and KE-23/24
   (conditions) are explicitly labeled STATUS-gap fold-ins (§0.3 of the candidate).
5. **Against.** A stricter reading says an erratum should touch the minimum surface; the
   fold-ins could ride in a separate erratum. I judged one compact document better than
   two sequential seals over the same §13/§20 text, but a synthesis chair could split them.

## D-2 — Is a singleton `:bounded` alternatives set lawful?

1. **Ambiguity.** §7.3 requires "finite, non-empty, duplicate-free" — a singleton passes
   the letter. But §7.2 defines `:determinate` as evidence licensing exactly one value, so
   a singleton `:bounded` looks like either a mislabeled determinate or a dodge.
2. **Alternatives.** (a) Forbid singletons (require ≥2); (b) allow unconditionally, no
   assigned meaning; (c) allow with one defined meaning — eliminative narrowing without
   positive license — plus a no-silent-promotion law.
3. **Governing text.** §7.2 ("licenses exactly one current axis value under the named
   procedure" — *licensing* is procedure-relative and positive); §7.3 ("non-empty");
   §7.4 (`:indeterminate` = no lawful finite set); A0.1 §17 matrix row "uncertain write":
   manifestation "bounded or absent-so-far" (adopted text contemplating bounded
   manifestation for exactly this case).
4. **Resolution.** (c) = KE-2. Elimination-to-one without positive license is a real and
   distinct epistemic state; the closed trichotomy should be able to say it.
5. **Against.** (a)'s case is strong: KE-2 legalizes a "cowardly determinate" — an
   implementation can park on singleton-bounded forever to avoid committing. Mitigations
   chosen: the exhaustiveness burden on evidence, the no-promotion mutant, and the
   membership law. A synthesis chair preferring (a) must then re-solve call-296, where a
   ≥2 rule forces either an invented second alternative (worse) or non-constructibility.

## D-3 — What space do bounded alternatives quantify over?

1. **Ambiguity.** §7.3 says "named alternatives" but never names the space. §22's effect
   alternatives `(:billed :not-billed)` are not effect-axis enum members; the pure-core
   fixture's manifestation alternative `(:absent-after-completion)` is a bare state atom,
   not an axis value.
2. **Alternatives.** (a) Alternatives are always axis-enum members; (b) always free atoms;
   (c) per-axis: complete axis values for execution/manifestation/interpretation, the
   §10.8 record's `:possible-effects` settlement space for effects, `:target`-named
   spaces for claims.
3. **Governing text.** §9.3 (manifestation-axis value = reference or `(:absent :state s)`);
   §9.4 + §10.8 (effect `:bounded` MUST reference the structured record; the record carries
   `:possible-effects`); A0.1 §6.3.5 (claim determinacy carries `:target` — the adopted
   precedent that alternatives quantify over an identified space); §22 bytes (effect
   alternatives are settlement atoms — (a) would render the sealed fixture ill-formed).
4. **Resolution.** (c) = KE-1, with KE-4 requiring effect-axis alternatives to be
   set-identical to the referenced `:possible-effects`.
5. **Against.** (c) is the most machinery; (b) is simpler and maximally permissive. But (b)
   makes the alternatives uninspectable (no membership check possible) and lets the two
   enumerations of one uncertainty drift apart — the exact defect class KE-4 kills.

## D-4 — Call-296: repair locally, refuse, reclassify, or hold non-constructible?

1. **Ambiguity.** §22/E-1 names `:bounded` manifestation determinacy with no alternatives;
   §7.3 requires them; the charge forbids inventing call-296 facts to satisfy a
   constructor.
2. **Alternatives.** (a) Local repair by *derivation from adopted law* (closed §8.7
   vocabulary + frontier-crossed evidence ⇒ exhaustive singleton); (b) refuse
   construction / hold the fixture non-constructible pending a sealed evidentiary act;
   (c) reclassify the manifestation determinacy to `:indeterminate`; (d) bless the
   existing bare-atom singleton as-is.
3. **Governing text.** §8.7 (closed state set + normative status/state mapping); §28 stops
   1 and 3 (no new axis value; no absence state that is a diagnosis); §7.4 (indeterminate
   = *no lawful finite set* — false here, a set derivably exists); A0.1 §15.2 + E-1
   (the projection is sealed; `:bounded` is its byte); R-SYN-1 (projection ≠ constructible
   record; the enclosing structure carries what the projection omits); DK-2/§8.8 (no
   captured envelope ⇒ nothing to project ⇒ no `:present*` candidate).
4. **Resolution.** (a) = KE-5, with the bare-atom → complete-value form repair, plus a
   recorded bounded unknown for the completion-presupposition tension. The derivation uses
   no fact about call-296 beyond what the adopted projection itself asserts (frontier
   crossed, nothing captured); everything factual stays locked.
5. **Against.** The strongest objection: "the closed vocabulary forced the singleton" is
   itself an inference, and if A0.1 later mints a post-frontier-failure absence state the
   singleton retroactively becomes an under-enumeration. Answer: that is precisely why the
   tension is recorded as a bounded unknown rather than dissolved, and why the determinacy
   stays `:bounded`; under a future vocabulary amendment the alternatives set is re-derived
   and the record superseded lawfully. (c) was rejected because a Kernel erratum cannot
   overrule a sealed A0.1 byte; (b) was rejected because it would un-construct a fixture
   the adopted spec (§25.1 test 7, R-SYN-1) requires implementations to construct.

## D-5 — What does §23's "re-derived byte-identically" compare?

1. **Ambiguity.** §23 binds a per-row "byte-compare where determinism is declared" without
   saying which bytes: journal frames, derived views, or receipts.
2. **Alternatives.** (a) Source-frame bytes; (b) derived-view canonical bytes under the
   named fold + rendering; (c) whole reconstruction receipts.
3. **Governing text.** PJ-SAL-2 (salvage regenerates frame digests — frame identity is
   *lawfully broken* across stores, so (a) is unsatisfiable exactly where reconstruction
   matters most); PJ-SNP-4 (byte comparison only under a named deterministic rendering);
   PJ0 §19 (receipts carry operator/act-scoped fields — (c) can never be byte-identical
   across two lawful runs); Kernel §19.9 (finalizer-loss test byte-compares the
   *re-derived summary*).
4. **Resolution.** (b) = KE-6 standing 4, with receipt comparison defined as field
   agreement on source-binding + output-digest fields (standing 5), and a mandatory
   salvage row proving replay-identity ≠ frame-identity (KE-8).
5. **Against.** None found with textual support; (a) and (c) each contradict an adopted
   PJ0 requirement. Recorded mainly so the synthesis can check the sibling candidate
   chose a compatible object.

## D-6 — Folding in `:attempt-indeterminate` (STATUS gap 2)

1. **Ambiguity.** §13.6 lists terminal class `:indeterminate`; §13.3 has no event that
   records reaching it (unlike `:attempt-refused/-failed/-completed/-cancelled`). Is adding
   an event within an erratum's reach, and is an event even needed (could the fold derive
   terminal-indeterminate from `:effect-indeterminate` alone)?
2. **Alternatives.** (a) Add `:attempt-indeterminate` with §13.5 legality; (b) rule the
   fold derives the terminal class from effect events without a dedicated event; (c) leave
   open.
3. **Governing text.** §13.3 (the four sibling terminal events establish the pattern:
   terminal classes are event-recorded); §13.5 ("a terminal attempt cannot receive a
   second terminal event" presupposes terminality is event-borne); §13.7 (fold-derived
   state needs events to fold); PJ-FOLD-1 (nothing resolves by inference).
4. **Resolution.** (a) = KE-9. (b) would make one terminal class inference-derived while
   the other five are event-recorded — an asymmetry inviting exactly the silent
   classification drift §13 exists to prevent.
5. **Against.** Vocabulary additions are the most invention-shaped move an erratum can
   make; §28 stop 1 warns against new *axis values* (this is an event, not an axis value,
   so the stop does not bite, but the smell is adjacent). Mitigation: the event is the
   unique minimal closure of an adopted asymmetry, and it carries a MUST-reference to the
   evidence blocking determinate classification.

## D-7 — Minimal record shapes for validation/integrity/visibility (Gap 3)

1. **Ambiguity.** §15.1 lists the record kinds; nothing in Kernel /0 says what fields make
   a validation/integrity/visibility record non-bare, so tests 43/44/47/48 are
   unimplementable (the pure core's records are opaque lists).
2. **Alternatives.** (a) Import LCI/0's field-rich claim representation into the kernel;
   (b) mint minimal shapes traced to A0.1 §6.3.2–6.3.4; (c) leave records opaque and
   implement the tests as documentation-only.
3. **Governing text.** §2.2 (the field-rich representation *belongs to the LCI/0 library*
   "unless a later authorial act moves a smaller representation into the kernel" — this
   erratum is exactly such an act, at minimal size); A0.1 §6.3.2 ("Validation names
   validator identity, scope, method, evidence, and version. Bare `:verified` is an
   oversized certificate"); §6.3.3 (seal attests under a declared method; "does not make
   content true"); §6.3.4 (visibility relational + scoped; "Bare `:published` is as
   oversized as bare `:verified`"); §20.7 (the two bare-* conditions already exist,
   waiting for enforcement surfaces).
4. **Resolution.** (b) = KE-11..KE-16: three small shapes, an orthogonality-under-
   transformation law, and a no-procedure-free-boolean accessor rule. Every field traces
   to an A0.1 sentence; nothing new is invented.
5. **Against.** (a)-leaning reviewers will note duplication risk with LCI/0. Answer: the
   kernel shapes carry only what the four tests need to *refuse bareness and block
   inflation*; LCI/0 keeps the rich representation, and §2.2's escape clause was written
   for precisely this move.

## D-8 — Where is the structural/semantic judgment class declared?

1. **Ambiguity.** Gap 4 needs "parser-valid ⇒ not semantically accepted" to be mechanical,
   which needs procedures to bear a class — but Kernel /0 has no procedure registry;
   `ProcedureId` is just an identity domain.
2. **Alternatives.** (a) Create a kernel procedure registry with class metadata; (b) carry
   the class at the reference site (a `:judgment-class` field on the interpretation axis),
   with AP0 descriptors carrying the adapter-side declaration; (c) infer the class from
   the procedure's identity domain (`:parser` ⇒ structural).
3. **Governing text.** §9.5 (every non-trivial interpretation names its procedure —
   the reference site already exists); AP-PRJ-2 (projections structural by law); AP0 §3.2
   (descriptors declare projection procedures); §26.1 (kernel owns protocols, not
   registries of domain content); 23.6 fixture (parser procedure lawfully licensing
   `:invalid` — so class cannot be inferred from *use*).
4. **Resolution.** (b) = KE-18. A registry (a) is standing machinery the kernel's
   minimality discipline resists; inference (c) breaks on rubrics and validators whose
   domain names don't wear their class.
5. **Against.** Reference-site declaration is self-reported — a lying declarant can mark a
   parser `:semantic`. True; but the declaration is then an inspectable, falsifiable
   *claim* in the record (the lab's preferred failure mode), the AP0 descriptor gives a
   second, independent declaration to check against, and control 15 plants the lie.

## D-9 — Condition minting vs blessing the `standing-inflation` borrow

1. **Ambiguity.** STATUS gap 3 asks for a chair disposition: bless the borrow or mint
   types.
2. **Alternatives.** (a) Bless permanently; (b) mint types, retroactively invalidating the
   arc's evidence; (c) mint forward, bless the arc's uses as historical.
3. **Governing text.** §20.1 (typed conditions are the conformance surface; generic
   refusal is nonconforming — the borrow is *within* the letter since `standing-inflation`
   is typed, but the type misnames the defect class for constructor-shape errors);
   the README's own declaration ("declared stretch, every use carries the real section").
4. **Resolution.** (c) = KE-23/KE-24.
5. **Against.** (a) is cheaper and the borrow was honest. But a schema violation is not a
   standing promotion, and letting one type absorb both classes would make control 11
   (real standing inflation) and control 1 (schema error) indistinguishable by type —
   weakening exactly the tests Gap 3 adds.

## D-10 — Joint-report shape: how far may the Kernel erratum reach into AP0's §24.3?

1. **Ambiguity.** AP0 §24.3 already states joint jurisdiction from the adapter side. Does
   the kernel erratum restate, extend, or stay silent?
2. **Alternatives.** (a) Silent (AP0's clause suffices); (b) kernel-side twin rule with a
   required two-verdict report shape (KE-20); (c) full joint-report record schema owned by
   the kernel.
3. **Governing text.** AP0 §24.3 (separate steps; no silent reclassification); PJ-VAL-3
   (structural and semantic standings reported separately); AP-G4-4 (the kernel lane
   handles the kernel side); the charge's "preserve divergence rather than flattening the
   joint result into one green counter".
4. **Resolution.** (b). (a) leaves the kernel side of the seam unpoliced — a kernel-side
   harness could still flatten; (c) would trespass on AP0's fixture formats.
5. **Against.** KE-20 constrains *report formats*, which some will read as tooling, not
   semantics. I judged it semantics: a report format that cannot express divergence is a
   standing-inflation machine (the counter *is* the claim).

## D-11 — A.2 replacement: how much structure for the stream relation?

1. **Ambiguity.** §8.1 requires "sequence/chunk relation for streams"; the charge forbids
   both a bare `streamed-p` boolean and wholesale import of AP0's chunk record.
2. **Alternatives.** (a) A single `:stream-id` reference into AP0 records; (b) the KE-22
   sub-record (stream/chunk/sequence/predecessor/aggregate/finality slots, value spaces
   AP0-owned); (c) full AP0 §10.2 chunk record embedded in the kernel.
3. **Governing text.** §8.1 (the kernel names the fields); AP-G4-1/2/3 (adapter identity +
   stream relation mandatory; AP0 owns value spaces); AP-STR-1..8 (ordering, gaps,
   duplicates, finality-vs-observation must stay auditable); AP-STR-8 (finality claim ≠
   observation — hence two slots, not one).
4. **Resolution.** (b), plus `:emptiness-rule-id` (a second A.2 omission against §8.4,
   already implemented in the pure core — repaired while the appendix is open).
5. **Against.** (a) is leaner and avoids any field drift against AP0. But (a) makes the
   kernel-side record unable to *say* which chunk it is without dereferencing an AP0
   store — the manifestation record would not be self-describing at inspection time
   (§21.1), and the auditability requirement in the charge would rest entirely outside
   the kernel record.

## D-12 — Held explicitly unresolved (no patch by invention)

1. **The completion-presupposition tension** in `:absent-after-completion` under
   indeterminate execution (KE-5.5): a closed-vocabulary limit; A0.1's to amend or keep.
2. **Factual classification** of call-296 and the 76 kimi records: locked lane; nothing
   in the erratum narrows `(:billed :not-billed)` or the execution axis.
3. **Concrete channel-policy binding for visibility scopes** (KE-13 names scope
   identities; which scopes exist stays with the channel-policy lane and owner acts).
4. **The multiple-unresolved-occupancy lossy summary** (STATUS gap 6): PJ0 §17.3's
   conservative `unsupported-reconstruction` stands; no summary format is proposed.
5. **Whether the erratum should ride beside the spec (PJ0-PRESEAL-REPAIRS precedent) or
   fold into a reissue with new sums**: an owner's-choice field in the adoption-record
   sketch, deliberately not pre-decided here.
6. **LCI/0 boundary pressure** from KE-11..13 (see D-7): if the library round finds the
   kernel shapes drifting toward LCI/0's rich representation, the right fix is shrinking
   the kernel shapes, not growing them — flagged for the stranger audit's
   primitive-minimization eye.

---

*— Claude Fable 5, blind, 2026-07-18. This ledger records where I actually hesitated;
if the sibling candidate diverges at these points, the divergences are the synthesis.*
