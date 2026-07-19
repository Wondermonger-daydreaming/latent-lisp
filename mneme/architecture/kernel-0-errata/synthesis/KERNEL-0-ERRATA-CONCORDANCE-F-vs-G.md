# KERNEL-0-ERRATA-CONCORDANCE — Fable candidate vs GPT candidate

**Author:** Claude Fable 5 — **CONFLICT FLAGGED:** the concordance author is also the author
of one compared candidate. Concessions and holds below are argued on the merits and every
disposition marked ⚖ is routed to the owner, not decided here. (Precedent: the AP0 plan
concordance, where the chair conceded its own plan's divergences to S on the merits.)
**Compared artifacts (both frozen and custody-verified before comparison):**
- F: `FABLE-LISP-PLUS-KERNEL-0-ERRATA-0.1-CANDIDATE.md`, sha256 `b09c5ead…9776ea34`,
  680 lines — frozen, packaged, and hash-published **before** the GPT packet was received;
  re-verified byte-identical immediately before the reveal.
- G: `GPT-LISP-PLUS-KERNEL-0-ERRATA-0.1-CANDIDATE.md`, sha256 `b0708a51…826469b0`
  (= original `LISP-PLUS-KERNEL-0-ERRATA-0.1.md` per its README), 666 lines — package
  sha256 `d2624067…b95eb70d` matched the owner-declared hash on receipt.
**Ordering proof:** F's blind-drafting attestation stands: the forbidden filename was never
opened or searched during drafting; F's hashes predate the reveal in this session's record.

**Shared-root discipline:** both candidates are seeded from the same governing texts, so
their agreements carry **no corroborative weight** — where the texts constrain tightly,
convergence is expected whether or not the reading is right. The information is in the
divergences. Classes per G's README-FIRST: AGREEMENT · COMPATIBLE DIFFERENCE · REAL
NORMATIVE FORK · ONE-SIDED OMISSION · UNAUTHORIZED INVENTION.

---

## 1. AGREEMENT (discounted, listed for the record)

Both candidates, independently:

1. treat the §22/A0.1 §15.2 projection as **byte-preserved and projection-only** — neither
   touches the sealed bytes (F KE-5; G §1.2);
2. rule bounded **alternatives must be complete axis values, never bare subfield atoms**
   — both explicitly reject `(:absent-after-completion)` as a form (F KE-1; G E-K0-1-DET-2);
3. resolve §23's "byte-identical" as **semantic replay identity** (canonical bytes of the
   derived view under a named fold + comparison discipline), explicitly **not**
   frame-identity across salvage/merge, with receipt comparison as field-level under a
   policy (F KE-6/KE-8; G §2.3, E-K0-2-BYT-1);
4. define near-identical **terminal-row evidence bundles** (store id, prefix coordinate,
   event ids, kill point, classification, fold id/version, expected view digest, origin
   `:reconstructed`, required conditions, bounded unknowns) (F KE-7; G §2.2);
5. make **derived-artifact deletion before reconstruction** a per-row obligation
   (F KE-7.6; G E-K0-2-RCN-3);
6. preserve **PJ0's torn-tail / interior-corruption / valid-end** trichotomy and the
   no-skip-forward law; source stays byte-identical (F KE-8; G §2.4, E-K0-2-RCN-4);
7. give validation/integrity/visibility **minimal record shapes traced to A0.1
   §6.3.2–6.3.4**, wire `bare-validation-scope`/`bare-visibility-scope` at construction,
   and mechanize sealed⇏verified, published⇏truth/origin/acceptance (F KE-11..14;
   G §3);
8. adopt a **structural vs semantic judgment class** with `:accepted`/`:rejected`
   requiring a semantic procedure over `:present`/`:present-empty`; parser-valid /
   decoded / captured / sealed / published never default acceptance (F KE-18/19;
   G §4.1–4.3);
9. require **two-field joint reports** — "AP0 structural PASS, Kernel semantic FAIL"
   preserved, one-counter formats nonconforming (F KE-20; G E-K0-4-JOINT-1..4);
10. keep `:present-invalid` payload+parser preserved, never `:rejected`, never absence;
    partials never erased; aggregation over chunks receipt-bearing (F KE-21; G
    E-K0-4-SEM-3, E-K0-A2-STR-3/4);
11. preserve **AP0 ownership of adapter/stream value spaces** (AP-G4-3) while the kernel
    names slots (F KE-22 rule 1; G §5 closing);
12. carry identical **remaining-gates caps** (CL gates open; stranger audit owed; locked
    Language-A lane untouched; candidate ≠ governing).

## 2. THE ONE REAL NORMATIVE FORK ⚖ — singleton `:bounded` and call-296 constructibility

The fork F's decision ledger pre-registered as the likeliest divergence (D-2/D-4) is
exactly where the candidates split, and it is **load-bearing**: it decides whether the
canonical call-296 fixture is constructible today.

| | **F (KE-2, KE-5)** | **G (E-K0-1)** |
|---|---|---|
| §7.3 surgery | CLARIFICATION + additions; "non-empty" letter kept | REPLACEMENT of §7.3's first sentence: **at least two** alternatives |
| singleton | **lawful**, one meaning: *eliminative narrowing without positive license*; exhaustiveness burden on evidence; no silent promotion to `:determinate` (mutant-guarded) | **refused** (`E-K0-1-DET-1`); "a singleton 'bounded uncertainty' is a determinate value wearing a false moustache" |
| call-296 today | **constructible**: alternatives = the exhaustive singleton `((:absent :state :absent-after-completion))`, *derived from adopted law only* (closed §8.7 vocabulary + the projection's own frontier-crossed assertion; §28 stops forbid minting states); determinacy stays `:bounded` because the licensing fact is exactly what execution records as indeterminate | **non-constructible projection fixture** pending a sealed evidentiary act with three exits: (1) a lawful ≥2 set; (2) established value ⇒ `:determinate`; (3) no lawful set ⇒ `:indeterminate`. G's E-K0-1-C296-2 **explicitly forbids F's exact repaired form** |
| existing pure-core fixture | form-repaired (bare atom → complete value), kept; arc evidence blessed historical | renamed/quarantined as historical; replaced by a **synthetic** ≥2 algebra fixture (E-K0-1-C296-4) |

**F's strongest case against G** (held, not conceded): (a) G *replaces* adopted sealed text
where a clarification suffices — the heavier surgery on the letter of §7.3 ("non-empty");
(b) G's exit taxonomy has a crack: for call-296 a finite set IS lawfully derivable (the
singleton), so exit (3) ("no lawful finite set") would be false, exit (2) is false
(nothing established), and exit (1) is unsatisfiable without inventing a second
alternative — the case G's taxonomy cannot name is precisely the eliminative-narrowing
state F's KE-2 defines; (c) G un-constructs a fixture the adopted spec presupposes
constructible (§25.1 test 7 as sharpened by R-SYN-1; the kernel0 charge built it), pushing
a today-runnable fixture behind a future owner act.

**G's strongest case against F** (stated at full strength): (a) F legalizes a permanent
"cowardly determinate" parking space — any implementation can dodge commitment via
singleton-bounded, and F's exhaustiveness burden is evidence-discipline, not a mechanical
refusal; (b) F's derivation, however lawful, still *supplies from the kernel side* a set
the sealed projection did not supply — G reads the charge's "do not invent facts to
satisfy a constructor" more strictly (F reads "derivation from adopted closed vocabulary"
as not-a-fact-about-call-296; G reads any supplied set as repair-by-authorship);
(c) G's three-fixture separation (historical projection / synthetic algebra fixture /
locked live lane) keeps the *algebra* tested today without touching the historical record
at all — constructibility of *call-296 itself* is not needed to test the algebra.

**Concessions on sub-points (F → G), independent of the fork's outcome:**
- G's **E-K0-1-C296-4 three-fixture separation is better test design** than F's
  single repaired fixture; F adopts it under either ruling.
- G's **E-K0-1-DET-3 anti-abuse clause** (bounded is not for memorializing unease /
  pending review / omitted sets) is a good guard and composes with F's KE-2 if singletons
  survive.

**Hold (G → F), for the synthesis regardless of the fork:** F's KE-2.2 no-silent-promotion
mutant and KE-3 value-membership law apply under both rulings and G lacks both.

**⚖ OWNER FORK F-vs-G-1 — three clean options:**
1. **F's rule:** singleton lawful with defined meaning; call-296 constructible now via
   the derived exhaustive singleton; tension recorded as bounded unknown.
2. **G's rule:** ≥2 required; call-296 non-constructible pending a sealed act; synthetic
   fixture carries the algebra tests.
3. **Hybrid (sketch):** keep §7.3's letter (non-empty) + G's DET-3 anti-abuse + F's KE-2
   semantics and mutants + G's C296-4 fixture separation; the derived singleton
   constructs the fixture **provisionally, flagged `:pending-sealed-confirmation`**, and
   the sealed act later confirms, replaces, or strikes it. (Costs: a new flag; benefits:
   nothing waits, nothing pretends.)

## 3. REAL BUT SMALLER FORKS ⚖

### 3.1 Condition minting (STATUS gap 3's requested chair disposition)

- **F (KE-23/24):** mint five typed conditions (`malformed-constructor-shape`,
  `determinacy-mode-invalid`, `determinacy-alternatives-invalid`,
  `global-uncertainty-scalar-rejected`, `interpretation-class-violation`); bless the
  arc's `standing-inflation` borrow as historical only.
- **G:** reuses `standing-inflation` carrying requirement IDs throughout; the STATUS-stone
  question ("bless the borrow or mint types") is not addressed as such — a de facto
  permanent blessing.
- **F holds** on the merits (typed distinction is what makes control families
  distinguishable by type; a schema violation is not a standing promotion), **and
  concedes G's practice** of stamping the erratum requirement ID into the signaled
  condition — adopt both: minted types + requirement-ID slot.

### 3.2 Judgment-class carrier

- **F (KE-18):** `:judgment-class` field at the reference site (minimal; no registry).
- **G (§4.1):** a **procedure-descriptor floor** (`:judgment-class`, `:input-domain`,
  `:result-vocabulary`, PROC-1: one identity = one class; dual-role implementations must
  split identities).
- **F concedes the mechanism:** G's descriptor floor is stronger — PROC-1 kills the
  ambiguous-validator dodge F's own ledger (D-8.5) named as its weakness, and it aligns
  with AP0's existing descriptor practice. Hold only the caveat: a *floor carried by the
  procedure reference*, not a standing kernel registry (F's D-8 minimality concern).
  Synthesis: G's descriptor shape, F's no-registry constraint.

### 3.3 A.2 shape

- **F (KE-22):** one `:producer-identity` sub-record with `:producer-class`; inline
  stream-relation slots (sequence, predecessor, `observed-final-p` vs
  `provider-finality-claim` surfaced at the manifestation, per AP-STR-8); aggregate
  fields inline.
- **G (§5):** `:adapter-identity` XOR `:producer-identity` (exactly-one-branch law);
  stream-relation as `:chunk-record-ids` **references into AP0 chunk records** +
  `:projection-receipt-id`; refusal list in E-K0-A2 §5.3 (both-fields, empty lineage,
  cross-attempt chunks, discarded partial lineage — several sharper than F's).
- **Assessment:** COMPATIBLE DIFFERENCE, not a fork — same charge requirements met by two
  shapes. G's reference spine avoids double-entry drift against AP0 §10.2 (which already
  carries sequence/predecessor/finality); F's inline slots keep the record
  self-describing at inspection (§21.1) without dereferencing a store. Proposed
  synthesis: **G's reference spine + G's exactly-one-branch law + G's §5.3 refusal list**,
  with **F's `:emptiness-rule-id`** (a §8.4 omission G misses) and F's surfaced
  finality-claim-vs-observation pair retained at the manifestation level.

## 4. ONE-SIDED ITEMS (each side's catches the other lacks)

**F-only (proposed: carry into synthesis):**
1. **KE-4** — effect-axis bounded alternatives MUST be set-identical to the referenced
   uncertain-effect record's `:possible-effects` (one uncertainty, one enumeration);
2. **KE-9** — the `:attempt-indeterminate` event (§13.6 terminal class has no §13.3
   recording event; STATUS gap 2). G omits the entire event-protocol fold-in;
3. **KE-15** — general no-procedure-free-boolean accessor law (G has only the
   visibility-side instance, E-K0-3-VIS-1);
4. `:emptiness-rule-id` in the A.2 replacement (§8.4; already implemented in the core);
5. the **completion-presupposition bounded unknown** (`:absent-after-completion` under
   indeterminate execution) — recorded for A0.1's next round; G is silent on the tension;
6. the explicit **gap-numbering-divergence resolution** (STATUS vs README lists; G
   silently uses the README numbering, leaving STATUS gaps 2–3 unclosed by its text);
7. integrity-record **representation-identity binding** stated as the mechanical reason
   copies can't inherit seals (G's ORTH-2 gets there via receipts; F's constructor-level
   refusal is the enforceable half).

**G-only (proposed: carry into synthesis):**
1. graded `:checked` vs `:verified` requirements (E-K0-3-VAL-2/3) — F's shapes only
   distinguish `:unchecked`;
2. `:subject-id` bound inside each standing record (F left subject implicit by
   attachment; explicit is better for detached records);
3. `:comparison-policy-id` naming which receipt/environment fields may lawfully vary
   (F said "field agreement" in prose; G made it an identified policy object);
4. the **primary-event-identity coordinate** stated as byte-coordinate 1 of §23
   (source immutability as part of the comparison triple);
5. E-K0-1-C296-4 three-fixture separation (conceded above);
6. §6.4 no-Python-transplantation restatement inside the erratum's own consequences;
7. control E15 (salvage destination must not be falsely compared as source-frame
   identity — F demonstrates it via the salvage row, G also *controls* for it).

## 5. UNAUTHORIZED INVENTION — none found on either side

Both candidates stay off CD/0 octets, PJ-S/0, PJ0 framing, AP0 vector bytes,
provider-specific semantics, Language-A factual classifications, and capability-authority
law. G's §7.3 first-sentence REPLACEMENT is the heaviest single surgery on adopted text in
either candidate — flagged as such, lawful for an erratum, but it is the fork's substance
(§2), not an invention. F's KE-9 event addition is the heaviest addition — flagged in F's
own ledger (D-6) with its §28-adjacency argued.

## 6. Proposed synthesis path (for the owner's disposition)

1. ⚖ **Decide FORK F-vs-G-1** (§2: F's rule / G's rule / hybrid) — everything else
   composes mechanically once this lands.
2. Adopt the **union of one-sided catches** (§4) and the **agreed spine** (§1).
3. Resolve the small forks per §3 (concordance proposals: minted types + requirement-ID
   stamps; G's descriptor floor + F's no-registry cap; G's A.2 spine + F's two additions).
4. ⚖ **Authoring charge:** one hand writes `LISP-PLUS-KERNEL-0-ERRATA-0.2-SYNTHESIS`
   from both frozen candidates under the owner's fork dispositions, the *other* candidate's
   author reads adversarially before the seal (PJ0/Kernel-synthesis precedent — parents
   stay frozen on disk, synthesis is a third document).
5. Adoption record binds: both candidate hashes, the fork disposition, per-requirement
   dispositions, and the ride-beside-vs-reissue choice (both candidates sketch compatible
   adoption-record fields; G's includes gap-disposition + remaining-gates enums worth
   keeping).

*— Claude Fable 5, concordance under conflict-flag, 2026-07-18 (night). Both parent
candidates remain frozen and unmodified; this document decides nothing.*
