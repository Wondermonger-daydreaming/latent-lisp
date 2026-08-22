# PORTABLE JUDGE /0 — ADJUDICATION HARNESS (CANDIDATE)

**STANDING: CANDIDATE — not adopted; owner disposition pending.** Date: 2026-08-10.

**Prepared against the R1 CANDIDATE base of Many Acts /0**: parcel sha256
`54aa7783c494d8f32baa3c10eecd48590b88b13f07f0de6c8724831807a02803`; patch base commit
`76952ea4f278d269f98f158555e412a095a3da6f`; R1 freeze lane subtree
`e94870bd9091e67f68e9cf238a6c5d0dcf302a05`. **The base is itself NOT owner-adopted.**

**NAMING COLLISION (first use).** "PJ0" already denotes the **ADOPTED Process Journal /0**
(`mneme/architecture/process-journal-0/PJ0-ADOPTION-RECORD.md`). This campaign is **Portable
Judge /0** (`portable-judge-0/`); short form **PortJ/0**; bare "PJ0" is never used here as if
unambiguous. Final designation **pending owner ratification**.

Companion documents: `PROTOCOL-CANDIDATE.md` (the campaign law; §5 is the observable
boundary this harness enforces), `FAILURE-TAXONOMY-CANDIDATE.md` (the verdict rules this
harness feeds), `CLEAN-ROOM-IMPLEMENTER-BRIEF-CANDIDATE.md`. The wire format for every
observation is **NORMATIVE-OBSERVATION-FORMAT-0**, drafted in parallel by NOTARIUS and
referenced here by name only — this document does not define it and must not drift from it.

---

## 1. Roles, and the separations that make the verdict mean anything

| Role | Who | May not |
|---|---|---|
| **J1 implementer** | already done (the base lane's builders) | — |
| **J2 implementer** | the clean-room implementer | run the hidden bank; classify any verdict; see the comparator's category logic before freeze |
| **Harness author** | a construction-loop participant is permitted here (the harness is not a judge) | author hidden cases *and* classify verdicts |
| **Adjudicator** | a **non-implementer** — neither J1 nor J2 builder | edit either judge; edit a test after the holdout opens |
| **Owner** | Tomás | — (appeal terminates here) |

**One hand may not hold two of: J2 authorship, hidden-case authorship, verdict
classification.** This is the base lane's own partition doctrine applied to procedure: the
guarantee that no one tuned a judge to a case must fall to a hand that could not have done it.

---

## 2. Architecture

```
                      ┌────────────────────────┐
  canonical case  ──► │ J1 NATIVE (instrumented)│──► act transcript (AOI data)  ──┐
  (source + env decl) └────────────────────────┘    + J1-native envelope          │
                                                                                  │
                      ┌────────────────────────┐                                  │
        transcript ──►│ J1 REPLAY (mode)        │──► J1 envelope  ─┐              │
                      └────────────────────────┘                  │              │
                      ┌────────────────────────┐                  ├─► COMPARATOR ─┤► category
        transcript ──►│ J2 (Python, clean-room) │──► J2 envelope  ─┘              │  per case
                      └────────────────────────┘                                  │
                                                                                  │
   replay/determinism checks run INDEPENDENTLY on each judge BEFORE comparison ────┘
```

Both judges receive **identical canonical cases**: the program source bytes, the environment
declaration (as data), and the frozen act transcript. Both emit a
**NORMATIVE-OBSERVATION-FORMAT-0** envelope. The comparator reads only envelopes.

**A case is a unit, not a file.** Each case carries: an id; the source bytes; the environment
declaration; the act transcript; the expected-category (for teeth cases only); and its bank
(public | hidden). Hidden-bank cases additionally carry a per-case hash published at Phase 3
and plaintext held off-tree.

---

## 3. The J1 replay adapter — a MODE, not a fork (prerequisite gate)

J1 must be able to consume a frozen transcript instead of executing acts, or the two judges are
not answering the same question. This is a modification of the canonical judge and is therefore
the campaign's first place to cheat.

- **Added as optional parameters that default to existing behavior**, so every existing call
  site resolves exactly as before. No existing function is renamed, no existing default changes.
- **Byte-identical proof, not a promise.** Before any comparison run is admitted, the adapter's
  presence must be shown not to alter the native path: the base lane's full floor and selftest
  are run before and after, and the check-lines and values must be **identical** — a diff, shown
  in the record, not a sentence saying it was checked.
- **Native-vs-replay identity gate.** For every public-bank case, J1-native and J1-replay must
  produce **identical envelopes**. A divergence means the AOI is measuring itself.
- **VOID, not caveat.** Failure of either gate **VOIDs the campaign at the adapter**. The
  correct move is to fix the adapter and re-gate, never to proceed with a note.
- The adapter is written by the harness author, reviewed by the adjudicator, and its diff is
  preserved in-tree.

---

## 4. Comparison categories

The comparator assigns **exactly one** category per case. The categories are the point: a
harness that only says "same / different" cannot support the taxonomy, and a red that cannot be
classified is a red nobody can act on.

| # | Category | Definition | Feeds taxonomy |
|---|---|---|---|
| **C1** | **EXACT NORMATIVE AGREEMENT** | every §5.1 field present in both, equal under the format's declared equality | pass |
| **C2** | **PERMISSIBLE NON-NORMATIVE DIFFERENCE** | envelopes differ **only** in §5.2-excluded material (message text, exception type, printed form, ordering of a set the format declares unordered) | pass, **recorded** — a growing C2 count is itself a signal that the boundary is under-specified |
| **C3** | **MISSING OBSERVATION** | a field the format requires is absent from one judge's envelope (not "empty" — **absent**) | class 1 or 2 |
| **C4** | **ADDITIONAL UNAUTHORIZED OBSERVATION** | a judge emits a normative field the specification does not authorize, or emits an act summary / effect the case does not license | class 1 or **4** |
| **C5** | **NONDETERMINISM** | a judge's own repeated runs disagree (detected in §6, before comparison) | class 1 or 4; comparison for that case is **VOID** until resolved |
| **C6** | **PROHIBITED-BRANCH EXECUTION** | an untaken branch arm produced an act summary or a store footprint (OB-6) | class **4**, automatic red |
| **C7** | **PROVENANCE LOSS** | a required OB-4 / OB-5 / OB-14 field or ordering was dropped, reordered, or replaced by a default | class **4** if required-support removal; else 1 |
| **C8** | **REFUSAL-DETAIL LOSS** | disposition and code agree, but the nested `refuse` payload differs in structure, nesting depth, element count, or element identity — **including a nested list flattened, truncated, or coerced** | class 1 or 2 |

**Category precedence when several apply**: C5 → C6 → C7 → C8 → C4 → C3 → C2 → C1. Determinism
failures and constitutional failures are named first, because a case that is both nondeterministic
and divergent is a nondeterminism finding wearing a divergence costume.

**The comparator emits categories, never verdicts.** Classification into the five taxonomy
classes is a human act by the adjudicator, on the evidence the comparator produced
(FAILURE-TAXONOMY §2).

---

## 5. Normalization prohibitions

The harness **must not normalize away the distinctions under test.** Each prohibition below
names a real way a comparator quietly manufactures agreement.

- **Never erase record order.** Act summaries are oldest-first; a set-comparison of summaries
  destroys OB-14. Sequence equality, always.
- **Never collapse segmented identifiers.** An act-id-hex, a store-id, a seat name, a slot name
  are compared as whole strings; no prefix matching, no case folding, no whitespace stripping, no
  splitting on separators.
- **Never coerce rationals to float.** Integers stay integers, exactly; no numeric widening, no
  tolerance comparison, no `==` across types that the format declares distinct. (Lisp+ integers
  are unbounded; a J2 that lands them in a fixed width is a real finding, and a coercing
  comparator would hide it.)
- **Never discard nested details.** A `refuse` payload's tree shape is normative (C8); no
  flattening, no truncation, no "first N elements," no repr-string comparison that loses
  structure.
- **Never treat missing provenance as empty provenance.** Absent ≠ empty ≠ nil ≠ `:none`. The
  format distinguishes them and so does the comparator, **unless the specification expressly says
  they are the same** — and where the specification is silent, the comparator preserves the
  distinction and the silence becomes a deficit entry, not a normalization.
- **Never normalize keyword vs string vs symbol.** If one judge reports `:refused` and the other
  `"refused"`, that is a real question about the format, answered by the format, not smoothed by
  the comparator.
- **Never sort a list the format calls ordered, and never compare-as-ordered a list the format
  calls unordered.** Orderedness is a property the format declares; the comparator obeys it and
  does not infer it.
- **Never compare via a serializer that round-trips through a lossy intermediate.** If envelopes
  are serialized, the serializer is part of the instrument and gets its own teeth-check (§7).

**Any normalization the harness *does* perform must be declared in the harness's own header,
enumerated, and justified by a specification sentence quoted inline.** An undeclared
normalization discovered later voids every case it touched.

---

## 6. Replay and determinism checks — independent, and BEFORE comparison

Each judge is checked **against itself** before it is compared to anything. A comparison between
two nondeterministic judges is noise with a verdict attached.

For every case, on each judge separately:

1. **≥2 runs in separate processes**, envelopes must be **byte-identical**.
2. **J2 additionally**: runs under **≥2 distinct hash seeds** (e.g. `PYTHONHASHSEED` varied), and
   under **≥2 distinct working directories and temp paths**, with identical envelopes. Iteration
   order leaking into output is the most common Python nondeterminism and it must be caught here,
   not in comparison.
3. **J1 additionally**: native and replay envelopes identical (§3).
4. **Environment-independence probe**: locale and timezone varied; envelopes identical.

A judge failing any of these produces **C5** for the affected cases; those cases' comparisons are
**VOID** (a distinct outcome from *refuted* — the run did not measure what it set out to measure)
until the nondeterminism is resolved, and the resolution is itself a labeled repair (PROTOCOL §11).

---

## 7. Harness teeth-checks — the comparator is an instrument, and untested gates do not pass

**A gate that has never fired is untested, not passing.** Before any clean PASS counts, the
adjudicator plants a **known divergence in each distinguished category C3…C8** and shows the
harness catches it, in the right category. The teeth run is recorded with its outputs.

| Planted fault | Must be caught as |
|---|---|
| drop one required field from a fabricated envelope | **C3** |
| add an unauthorized normative field / a spurious act summary | **C4** |
| make a stub judge emit a run counter or a set-iteration-ordered list | **C5** |
| fabricate an envelope in which an untaken branch arm produced a summary | **C6** |
| reorder act summaries newest-first; drop `store-id`; replace an absent field with `:none` | **C7** (three separate plants) |
| flatten a nested `refuse` payload; truncate it; change one leaf | **C8** (three separate plants) |
| differ **only** in condition report text and exception class | **C2**, and **not** C1 or a red |
| identical envelopes | **C1** |

**Plus the anti-normalization teeth**, which are the ones most likely to be missing: plant a
float-vs-integer payload, a case-differing slot name, a whitespace-differing act-id-hex, and a
prefix-truncated store-id, and show that **each is caught**, not smoothed. If the comparator
passes any of these, it is normalizing and §5 has been violated.

**The serializer, if any, gets the same treatment**: round-trip a payload containing deep nesting,
an empty list, a nil-like absent marker, an unbounded integer, and a string with control
characters, and show the envelope survives byte-identically.

**Teeth results are reported with the campaign, not filed away.** A campaign whose comparator's
teeth were never shown to bite reports its PASS as *"clean under an untested comparator"* — which
is not a pass.

---

## 8. Freeze and holdout mechanics

- **Hidden bank sealed by hash at Phase 3**, plaintext **off-tree**. A prereg committed to a tree
  the subject can read is not a prereg; the same rule governs a case bank.
- **J2 freeze declaration at Phase 6** carries: implementation hash (whole tree), the self-run
  public-bank transcript, the attestation, and the implementer's deficit register.
- **At Phase 7 the adjudicator re-hashes J2** and records the hash beside the declaration's. A
  mismatch is not an accusation; it is a **fact that voids first-run status** for the whole run.
- **After the hidden bank opens: no evaluator and no test may be altered.** Not J1, not J2, not
  the harness, not a case, not a normalization rule. Hashes of all four are taken at opening and
  re-taken at classification, and both sets are recorded.
- **If a case turns out to be contaminated (taxonomy class 3), it is voided or rewritten — and a
  rewritten case is a NEW case in a NEW bank**, never a silent edit to the opened one. The
  original, its transcript, and the reason are preserved.

---

## 9. Repair protocol

Permitted only where the taxonomy permits it (class 1 PORT DEFECT; class 3 repairs the *test*).
When permitted:

1. **Preserve first**: the original J2 tree by hash and archive, the freeze declaration, and the
   full failure transcript are committed **before** any edit.
2. The repair is made **by the implementer**. The adjudicator does not repair the thing it judges.
3. The re-run is a **labeled repaired run** with its own hash and its own transcript.
4. **First-run conformance for that case is spent and cannot be recovered.** No aggregate,
   headline, abstract, or table may merge repaired greens into first-run greens. Every reported
   count carries both numbers or neither.

---

## 10. The record the harness must leave

Per campaign: the packet manifest hash · the J1 base identity (commit, lane subtree, adapter
diff) · the J2 freeze hash and the re-taken hash · the observation format version · the
comparator's declared normalizations with their quoted justifications · the teeth-run outputs ·
per-case rows (`case-id · bank · category · first-run|repaired · taxonomy class · adjudicator ·
evidence pointer`) · the determinism-check outputs per judge · the deficit register as amended
during the run · every VOID with its cause.

Per case that went red: both envelopes verbatim, the transcript, the classification with its
reasoning, and — if repaired — the pre-repair artifacts by hash.

**What the record must make impossible**: reading a summary line and being unable to tell whether
a green was first-run or repaired, whether a comparison was VOID or passed, and whether the
comparator's teeth had ever been shown to bite.

---

*— drafted by LEGIST (Claude Opus), commissioned by the chair (Claude Fable 5), 2026-08-10*
