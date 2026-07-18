# LISP-PLUS-KERNEL-0-FABLE-REVIEW

**From:** Claude Fable 5 (Opus lineage), adjudicating chair
**To:** Tomás and GPT-5.6 Sol
**Date:** 2026-07-18
**Subject of review:** `kernel-0-drafts/sol/LISP-PLUS-KERNEL-0-SPEC.md` (DRAFT-S, 2,212 lines,
sha256 `e3f6e054…c9b41`, verified twice), per the relay's seven bounded duties — reviewed against
the governing Architecture 0.1, the decisions record with A-1..A-4 + E-1, and clause-by-clause
against the blind sibling draft DRAFT-F (`bd311f17`, frozen 17:27:47Z, before DRAFT-S was shown).
**Instruments:** WEAVER's dual trace (`REVIEW-NOTES-sol-spec-vs-canon.md`,
`CONCORDANCE-F-vs-S.md`) — mechanical tracing delegated, every disposition below decided by the
chair. **No implementation is authorized by this review.**

---

## VERDICT: **FAITHFUL WITH REPAIR**

Zero contradictions with governing law. Zero prohibited inventions. All eighteen A0.1 §12.1
kernel primitives present. The call-296 fixture is byte-faithful to A0.1 §15.2 as corrected by
E-1 (manifestation `:absent-after-completion`, determinacy `:bounded` — not the corrected-away
transcription). The forced-kill walk executes with no dead-ends. The L17 inequality holds on the
API as written, as a mandated and tested requirement. The kernel/journal/adapter seam is drawn
where the packaging claimed: the event model and fold are bound; bytes, framing, and layout are
correctly deferred.

The repairs are four under-specifications, none blocking, **all fillable from existing adopted
text** — three from DRAFT-F clauses that bind what DRAFT-S references loosely, one from A0.1
directly. They are the synthesis's work, enumerated below with the chair's dispositions.

## Findings, classified per the relay's five classes

**Contradiction with governing law:** none.

**Missing specification (the four repairs — fill in synthesis):**
1. *Causal-claim protocol* — DRAFT-S references it; A0.1 §6.9.2's shape + the revision-invariance
   law (a cause may be revised without touching state, fold, or census-class) must be normative.
   Fill from DRAFT-F CAU-1/CAU-2.
2. *Uncertain-effect record shape* — DRAFT-S §9.4 carries alternatives+evidence inline; A0.1
   §12.1 primitive 10 makes the **structured record** a kernel primitive, and the record is what
   carries no-blind-retry across a restart. Fill from DRAFT-F OUT-3/UNC-1 + A0.1 §6.10 fields
   (incl. `:retry-policy`, `:reconciliation-procedure`), with `condition:unstructured-uncertainty`
   on inline-only construction. **The chair's highest-value merge decision, decided: adopt-F.**
3. *`reconstruct` / `fold-state` operation surface* — the finalizer law's operational half; name
   the operations in the kernel op set. Fill from DRAFT-F JRN-5/§6.
4. *Envelope-projection prohibition* — the kernel MUST NOT derive subject-manifestation status
   by inspecting envelope bytes; that projection is the adapter's declared, versioned procedure.
   Fill from DRAFT-F MAN-2 (cheap seam-hardening for DK-2's two-level law).

**Implementation detail correctly delegated:** exact S-expression grammar, record framing,
canonical byte conversion, filesystem layout, merge encoding → Process-Journal-/0 spec;
operation/condition final names (both drafts agree names are proposals).

**Recommendation for a later profile:** static effect approximation (D3's second half);
custody-service extension point (DK-3, defined-not-built); cryptographic sealing (the standing
owed-ledger item, after semantics).

**Reserved for the stranger audit:** primitive minimality as such. This review repeatedly found
the two drafts *agreeing* — 37 of 54 traced clauses — and per the shared-root discipline none of
that agreement is treated as corroboration. Only the asymmetries carried information here; the
question "is the whole primitive set minimal?" stays with the empty seat.

## A finding against the reviewer's own parent draft

DRAFT-F FIX-2 cites "the 20 adversarial classes of 0.1 §16." **A0.1 §16 enumerates 37** (plus
six ergonomic tests in §16.1); DRAFT-S §25 enumerates the materially more complete suite (56
tests + 10 negative controls). The "20" was transcribed from the superseded Draft 0 §15 from
memory — the same defect-class as E-1, same author, same day. Disposition: **adopt-S §25 as the
fixture base**, count reconciled to A0.1's enumeration; F's "20" dies here.

## Synthesis adjudications (the chair's decisions on WEAVER's proposals)

| # | Item | Decision |
|---|---|---|
| 1 | ID-1 identity issuance | **adopt-S (merge)** — declared-procedure + restart-stability + non-image-local floor; the store-issued mandate is dropped (it would bar valid content-addressed identity). F conceded. |
| 2 | OUT-3/UNC-1 uncertain-effect | **adopt-F** + A0.1 §6.10 field shape (repair 2 above) |
| 3 | JRN-1 journal readability | **merge** — readability MUST stated in-kernel (D4 rider, visible to a kernel-spec reader alone); byte framing deferred (seam-correct) |
| 4 | FIX-2 fixture suite | **adopt-S §25**; count → A0.1's 37; F's figure retired |
| 5 | MAN-2, CAU-1/2, OUT-5, OP-1 ordering, JRN-5+ops, FIX-1 byte-compare | **adopt-F**, per WEAVER C.5 |
| 6 | JRN-2 timestamp guard, OP-2/L8 incremental durability | **merge** — S's structural enforcement kept; A0.1's guards restated as legible MUSTs |
| 7 | All 22 S-ONLY items (14 core + 8 scaffold) | **adopt-S** — event vocabulary, evaluation judgments, effect-class taxonomy, transition legality, status→state mapping, inspection-as-conformance, and scaffold |
| 8 | The 37 AGREE clauses | S's text is base (it is the superset); F's IDs retained as cross-references where they add referenceability |

**Base document for the synthesis: DRAFT-S**, with the eight dispositions applied as ledgered
insertions/replacements. The synthesis carries a parentage ledger (which clause came from which
parent, and which were merged) — the traced-successor discipline, one document down.

## What this review does not establish

That the primitive set is minimal (the stranger's question); that the spec is implementable at
bearable cost (the specimen's question); that the reviewer is unbiased about clauses that
originated in his own parent draft — sixteen of the adopted bindings are F's, and though every
one was proposed by WEAVER on canon-faithfulness grounds rather than parentage, the conflict is
structural and declared. The owner sees both parents, the concordance, and this table before
anything is sealed.

*— Claude Fable 5 (Opus lineage), 2026-07-18. Both parent drafts remain on record unmodified;
the synthesis is a third document, not an edit to either.*
