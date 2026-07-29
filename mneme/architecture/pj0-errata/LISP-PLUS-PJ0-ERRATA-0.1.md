# LISP-PLUS-PJ0-ERRATA-0.1

**Status:** PUBLISHED 2026-07-29 under the owner's D-2 adjudication charge —
adjudicate divergence D-2 only, verify the conflict directly, publish a narrow
erratum, and stop. This erratum RIDES BESIDE the sealed
`LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md` (Kernel /0 errata precedent): spec bytes
unedited, `SHA256SUMS.txt` in `process-journal-0/` untouched.
**Amends:** exactly ONE sentence of PJ0 §5.10 ("Records"). Nothing else.
**Date:** 2026-07-29
**Author:** Claude Fable 5 (chair), executing the D-2 charge; the divergence was
found, named, and exhibited by the journal0 build (RESTITUTOR lane,
`mneme/journal0/JOURNAL-0-COMPARISON.md` D-2), per PJ-SYN-3's stop-and-name duty.
**Unchanged inventory:** the frozen §24-normative fixture corpus (every byte);
`PJ0-FIXTURE-REGISTRY.sexp`; the reference tool; the Journal /0 implementation
(`mneme/journal0/`, including its D-2 divergence note, which this erratum
discharges on the spec side without editing); CD/0 (`CANONICAL-DATUM-SPEC.md`)
— §14.3 remains exactly what it was, in its own jurisdiction; Kernel /0;
PJ-SYN-2 and PJ-SYN-3; all adoption records.
**What publishing this proves:** nothing beyond the ordering clause. No audit
is opened, no conformance claim is upgraded, journal0 remains a candidate with
the same caps its RETURN states.

---

## 1. The defect

PJ0 §5.10 reads:

> Records use `(rec (KEY VALUE) ...)`, where each key is an identifier. Keys
> are unique and appear in Canonical Datum /0 identifier order. `(rec)` is the
> empty record.

The phrase **"Canonical Datum /0 identifier order"** is ambiguous, and the only
order CD/0 actually defines for record fields — §14.3 canonical field ordering
— contradicts the frozen normative corpus:

- **CD/0 §14.3** orders record fields by unsigned lexicographic comparison of
  the keys' canonical **encoded ValueBytes**. Identifier encoding (CD/0 §15.8)
  is length-prefixed: `22 UVAR(ns_count) [UVAR(len) octets]* UVAR(path_count)
  [UVAR(len) octets]*`. The length octet is therefore compared **before** any
  segment text.
- For the two metadata keys `(id "pj0" "cd0-version")` and
  `(id "pj0" "store-id")`, the encoded bytes share the prefix
  `22 01 03 "pj0" 01` and then differ at the path-segment length octet:
  **11 vs 8**. Since 8 < 11, §14.3 sorts **`store-id` first**.
- **Every frozen positive vector** renders **`cd0-version` first** — plain
  segment-text order. (Exhibit: `fixtures/positive/synced-demo/JOURNAL-META.pjs`
  renders cd0-version, creation-procedure, declared-durability, format-version,
  genesis-digest, store-id, store-nonce, witness-policy.)

The two readings are irreconcilable, and the corpus order is **forced**: the
corpus is §24-normative and PJ-SYN-2's byte-identity gate is anchored to it, so
under the §14.3 reading no implementation could ever pass the gate.

Two independent implementations following the two reasonable readings of §5.10
would emit different journal bytes. That is a wire-format defect, hence this
erratum.

**Verification (re-performed at publication, not inherited):** the §14.3
arithmetic, the §15.8 encoding layout, the frozen fixture bytes, the reference
generator's source (`tools/pj0_vector_tool.py`, `Rec.__init__`:
`sorted(pairs, key=lambda kv: kv[0].segments)`), and journal0's `PJS0-KEY<`
were each read or executed directly this session. The executable exhibit is
`erratum-1-d2-examples.lisp` beside this file (13 checks; see §4).

## 2. The erratum (normative)

In PJ0 §5.10, the sentence

> Keys are unique and appear in Canonical Datum /0 identifier order.

is replaced by:

> Keys are unique and appear in **PJ-S/0 record-key order**, defined over the
> keys' segment lists. For a key `(id s1 … sn)` the segment list is the strings
> `s1 … sn` in rendering order. Two keys compare as follows:
>
> 1. Compare segments pairwise from the first position. Two segments compare
>    by **unsigned lexicographic comparison of their UTF-8 octet sequences**:
>    the first differing octet, taken numerically from 0 to 255, decides; if
>    one octet sequence is an exact prefix of the other, the shorter segment
>    sorts first.
> 2. The first position whose segments differ decides the key order.
> 3. If every shared position compares equal, the key with **fewer segments
>    sorts first**.
> 4. Equal segment lists denote the same key; a repeated key is a duplicate
>    and MUST be refused.
>
> No locale, Unicode collation, case folding, normalization, or host string
> comparison participates. An encoder MUST emit keys in this order; a decoder
> MUST verify strict increase and MUST refuse input whose keys compare equal
> or decreasing (canonicality per PJ-SYN-2).
>
> This order is intentionally **not** CD/0 §14.3 canonical field ordering.
> §14.3 compares the keys' length-prefixed encoded ValueBytes, under which
> `(id "pj0" "store-id")` would sort before `(id "pj0" "cd0-version")` because
> the varint length octet (8 vs 11) differs before any text octet. The frozen
> §24-normative corpus renders the order defined here. CD/0 §14.3 continues to
> govern CD/0 canonical **binary** record encoding in CD/0's own jurisdiction;
> PJ-S/0 text does not embed that binary form. Identifier **equality** and
> duplicate detection remain CD/0's (§PJ-SYN-3 posture unchanged).

No other sentence of §5.10 or of any other section changes.

## 3. Provenance of each clause (charged at its true size)

- **Segment-text order, not encoded-ValueBytes order** (clause 1–2 as applied
  to the discriminating pair): **corpus-forced.** The frozen bytes decide it;
  this erratum records, it does not choose.
- **Differing segment counts and segment-list prefix** (clause 3) and the
  general elementwise rule beyond the corpus's exercised shapes: the corpus
  never exercises these (every frozen record key is a two-segment
  `(id NS PATH)`), so the corpus does not force them. They are fixed here to
  match the **reference generator that produced the corpus** —
  `pj0_vector_tool.py` sorts by the Python tuple of segment strings, whose
  semantics are exactly elementwise comparison with a shorter prefix tuple
  first (Python compares strings by code point; UTF-8 octet order coincides
  with code-point order, so the octet phrasing above is equivalent) — and to
  match journal0's implemented `PJS0-KEY<`, which took the same reading
  independently of this erratum. Normative force for these clauses begins with
  this erratum, not with the corpus.
- **Refuse-on-disorder** (decoder duty): already PJ-SYN-2; restated, not new.

## 4. Executable examples

`erratum-1-d2-examples.lisp` (beside this file; standalone, no dependencies)
implements both orders and exhibits, from the latent-lisp root:

```
sbcl --script mneme/architecture/pj0-errata/erratum-1-d2-examples.lisp
```

- **E01–E04** — the discriminating pair: corpus order puts `cd0-version`
  first; §14.3 puts `store-id` first; the first differing encoded octet is
  the length prefix (11 vs 8) after the shared prefix `22 01 03 "pj0" 01`.
- **E05–E07** — differing segment counts: `(id "pj0" "a" "b")` sorts before
  `(id "pj0" "c")` (elementwise decision beats length); `(id "pj0")` sorts
  before `(id "pj0" "x")` (segment-list prefix first).
- **E08–E09** — segment octet-prefix: `(id "pj0" "store")` sorts before
  `(id "pj0" "store-id")` — and §14.3 **agrees** on this pair (5 < 8), showing
  the two orders diverge only where encoded-length order opposes text order.
- **E10–E13** — the frozen `synced-demo` metadata bytes: file order equals the
  erratum's order, differs from §14.3 order, and under §14.3 the first key
  would have been `store-id`.

Published run: 13 checks, 0 failures, exit 0. Teeth: a planted mutant flipping
clause 3 (`<` → `>` on segment count) fails E06/E07 and exits 1 — the gate can
fire (mutant kept out of the tree; reproduce with the sed shown in the
publication commit's session, or by hand).

## 5. Effect on standing records

- `mneme/journal0/` D-2 notes (COMPARISON §5, RETURN, pjs0.lisp comment):
  **discharged on the spec side, files unedited.** Their text says "flagged
  for a future spec erratum" / "the spec was not repaired from this lane" —
  both statements remain true as written and now have their referent.
- PJ0 spec file and `process-journal-0/SHA256SUMS.txt`: **byte-identical**
  before and after this publication.
- Frozen corpus, registry, reference transcript: **byte-identical.**
- Gates at publication: erratum examples 13/0; journal0 vector gate
  (`journal0-vectors.lisp`) 89/0; journal0 selftest 66/0; repository floor
  (`mneme/verify-all.sh`) green — recorded in the publication commit message.

— Claude Fable 5
