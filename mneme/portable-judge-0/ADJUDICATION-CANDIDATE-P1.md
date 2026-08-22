# PORTABLE JUDGE /0 — ADJUDICATION HARNESS (CANDIDATE, Round P revision)

**CANDIDATE (Round P revision) — not adopted; owner disposition pending. Date 2026-08-10.
SUPERSEDES the frozen original `ADJUDICATION-CANDIDATE.md` as candidate text per OWNER-RULINGS-2
Round-P authorization; original preserved unmodified as historical artifact. Frozen
court-construction baseline: commit `71422395`. Prepared against the R1 candidate base
(parcel sha256 `54aa7783…`, patch base `76952ea4…`) — base NOT owner-adopted. Round P claims
NO evidence; zero evidence remains earned. Designation: Portable Judge /0 (PortJ/0); bare PJ0
reserved for the adopted Process Journal /0.**

Full base coordinates: parcel sha256
`54aa7783c494d8f32baa3c10eecd48590b88b13f07f0de6c8724831807a02803`; patch base commit
`76952ea4f278d269f98f158555e412a095a3da6f`; R1 freeze lane subtree
`e94870bd9091e67f68e9cf238a6c5d0dcf302a05`.

**Target: PortJ-L/0** — language-layer portable conformance (PROTOCOL-P1 §1.1). PortJ-F/0 is not
adjudicated by this harness and no verdict here bears on it.

Companion documents: `PROTOCOL-CANDIDATE-P1.md` (the campaign law; §5 is the observable boundary
this harness enforces, §5.3 the oracle-supplied material it must **not** score),
`FAILURE-TAXONOMY-CANDIDATE-P1.md` (the verdict rules this harness feeds),
`CLEAN-ROOM-IMPLEMENTER-BRIEF-CANDIDATE-P1.md` (**not issuable**). The wire format for every
observation is **NORMATIVE-OBSERVATION-FORMAT-0**, referenced here by name only — this document
does not define it and must not drift from it; Round P records that the format acquires an **Act
Oracle transcript envelope** in its own successor revision, not here.

---

## 0. What Round P changed in this harness

| Change | Authority |
|---|---|
| Comparator scope narrowed to **language-layer envelopes**; oracle-supplied fields excluded from the agreement count | Ruling 3 (L/0 split), PROTOCOL-P1 §5.3 |
| The act transcript is named an **INPUT both judges share**, never a compared observation | Ruling 3 |
| Adapter section rewritten: **external harness/wrapper preferred**; J1 modification only under three conditions; **full-inherited-floor** byte-identity gate; failure **VOIDs before J2 comparison** | Ruling 3, verbatim condition |
| New teeth category **T-ORACLE**: the harness must detect a modified transcript | Ruling 3's oracle-mediation, applied to instrument teeth |
| Designation sweep to **PortJ/0** | Ruling 1 |

**Unchanged on purpose:** the role separations (§1); the eight distinguished divergence categories
C1…C8 and their precedence (§4); the normalization prohibitions (§5); the independent determinism
checks (§6); the comparator teeth-checks (§7); the freeze/holdout mechanics (§8); the repair
protocol (§9); the record (§10). The categories are the part of the instrument that makes a red
actionable, and the revision touched none of their definitions.

---

## 1. Roles, and the separations that make the verdict mean anything

| Role | Who | May not |
|---|---|---|
| **J1 implementer** | already done (the base lane's builders) | — |
| **J2 implementer** | the clean-room implementer *(none exists; recruitment is CLOSED)* | run the holdout; classify any verdict; see the comparator's category logic before freeze |
| **Harness author** | a construction-loop participant is permitted here (the harness is not a judge) | author holdout cases *and* classify verdicts |
| **Transcript producer** | the harness author, from an instrumented J1 native run | classify verdicts on cases whose transcripts they produced *and* author those cases' holdout bodies |
| **Adjudicator** | a **non-implementer** — neither J1 nor J2 builder | edit either judge; edit a test after the holdout opens; edit a transcript after the holdout opens |
| **Owner** | Tomás | — (appeal terminates here) |

**One hand may not hold two of: J2 authorship, holdout-case authorship, verdict classification.**
This is the base lane's own partition doctrine applied to procedure: the guarantee that no one
tuned a judge to a case must fall to a hand that could not have done it.

**Added by this revision:** the AOI transcript is now evidence-bearing, so its producer is a named
role with its own separation line. A transcript is authored by the same instrument it will later
be used to judge; that is unavoidable (only J1 can produce it) and is therefore constrained by
role separation and by the T-ORACLE teeth-check rather than pretended away.

---

## 2. Architecture

```
                      ┌──────────────────────────┐
  canonical case  ──► │ J1 NATIVE (instrumented)  │──► act transcript (AOI data) ──┐
  (source + env decl) └──────────────────────────┘    + J1-native envelope         │
                                                                                   │
        transcript ──►┌──────────────────────────┐                                 │
        (shared INPUT)│ J1 REPLAY (wrapper)       │──► J1 envelope ─┐              │
                      └──────────────────────────┘                 │              │
        transcript ──►┌──────────────────────────┐                 ├─► COMPARATOR ─┤► category
        (shared INPUT)│ J2 (Python, clean-room)   │──► J2 envelope ─┘              │  per case
                      └──────────────────────────┘                                 │
                                                                                   │
   replay/determinism checks run INDEPENDENTLY on each judge BEFORE comparison ─────┘
   transcript integrity (hash vs frozen value) verified BEFORE either judge runs ────┘
```

Both judges receive **identical canonical cases**: the program source bytes, the environment
declaration (as data), and the frozen act transcript. Both emit a
**NORMATIVE-OBSERVATION-FORMAT-0** envelope. The comparator reads only envelopes.

**The transcript is an INPUT, not an observation.** It is fed to both judges and is never itself
compared, and the values it supplies are never counted as agreement (§4.0). A harness that scores
oracle-supplied fields is measuring the oracle's self-consistency and reporting it as portability.

**A case is a unit, not a file.** Each case carries: an id; the source bytes; the environment
declaration; the act transcript **and its hash**; the expected-category (for teeth cases only);
and its bank (public | holdout). Holdout cases additionally carry a per-case hash published at
Phase 3 with plaintext held off-tree. **No holdout case bodies exist** (Ruling 7).

---

## 3. The AOI replay adapter — external wrapper preferred; the gate that voids

J1 must be able to consume a frozen transcript instead of executing acts, or the two judges are
not answering the same question. This is the campaign's first place to cheat, and Ruling 3 governs
its construction.

**3.1 Preferred form — an external harness or wrapper.** The first and preferred design is one
that **does not modify J1 at all**: a driver outside the canonical implementation that instruments
the native run to capture the transcript and, in replay, supplies it without editing J1's own
files. A wrapper that never edits J1 has no identity question to answer. **The harness author must
attempt this form first and record, in the harness header, either that it succeeded or the exact
technical reason it could not.** "It was easier the other way" is not such a reason.

**3.2 If modifying J1 is unavoidable, three conditions bind — all three, or the campaign does not
freeze:**

**(a) The adapter becomes a separately identified pre-campaign candidate.** Its own named artifact,
its own owner disposition, adjudicable apart from the campaign. It may not be introduced as a
detail inside a campaign parcel and may not be adopted implicitly by the campaign's adoption.

**(b) It preserves the original native path.** Added as optional parameters defaulting to existing
behavior, so every existing call site resolves exactly as before. No existing function renamed, no
existing default changed, no existing signature narrowed.

**(c) It passes a byte-identity gate over the FULL INHERITED FLOOR before the campaign freezes.**
Not the campaign's own cases; not the base lane's floor alone; **the full inherited floor** — the
base lane's floor and selftest together with the inherited floors of every predecessor lane the
build carries. Run before and after; the check-lines and values must be **identical**, exhibited
as a **diff shown in the record**, never as a sentence saying it was checked. (`CLAUDE.md` §I-f:
a claimed verification that does not show its load-bearing step is a conclusion wearing a check's
costume.)

**3.3 Native-vs-replay envelope identity.** Additionally, for every public-bank case, J1-native and
J1-replay must produce **identical envelopes**. A divergence means the AOI is measuring itself.
This is a **narrower** check than 3.2(c) and does not substitute for it; both are required when
3.2 applies, and 3.3 alone is required when 3.1 succeeds.

**3.4 VOID BEFORE COMPARISON, not caveat.** Failure of the identity gate **voids the campaign
before J2 comparison**. The campaign does not reach comparison; there is no red, no green, and no
partial result to report except the VOID and its cause. The correct move is to fix the adapter and
re-gate. **A gate evaluated after a comparison is a gate whose outcome someone already knows the
cost of** — hence the ordering is itself normative.

**3.5 Review.** The adapter (wrapper or modification) is written by the harness author, reviewed by
the adjudicator, and its diff — or, for a pure wrapper, its full source — is preserved in-tree.

---

## 4. Comparison categories

### 4.0 Scope of comparison (new; Ruling 3)

The comparator compares **language-layer envelopes**. Before any category is assigned:

- **Oracle-supplied fields (PROTOCOL-P1 §5.3) are excluded from the agreement count.** Act
  disposition, class, act-id-hex, verdict, seat resolution, facet standings, and validated-prefix
  length arrive from the shared transcript. Their equality is a tautology and may not be reported
  as conformance.
- **What IS compared at those points:** *which* act requests were issued, *in what order*,
  *whether one was issued at all*, and *how the transcript's returned values were carried* into the
  result record and the summaries. Carriage is J2's work; the value is not.
- **A field that is both oracle-supplied and mis-carried is a carriage divergence** (C7 or C8), not
  a value disagreement. The distinction is recorded per case so a reader can tell which was tested.
- **Every case's agreement count is reported with its oracle-supplied field count beside it.** A
  case whose envelope is mostly transcript is a case that tested little, and the record must let a
  reader see that without reading the transcript.

### 4.1 The categories

The comparator assigns **exactly one** category per case. The categories are the point: a harness
that only says "same / different" cannot support the taxonomy, and a red that cannot be classified
is a red nobody can act on.

| # | Category | Definition | Feeds taxonomy |
|---|---|---|---|
| **C1** | **EXACT NORMATIVE AGREEMENT** | every §5.1 field present in both, equal under the format's declared equality, with §5.3 material excluded from the count | pass |
| **C2** | **PERMISSIBLE NON-NORMATIVE DIFFERENCE** | envelopes differ **only** in §5.2-excluded material (message text, exception type, printed form, ordering of a set the format declares unordered) | pass, **recorded** — a growing C2 count is itself a signal that the boundary is under-specified |
| **C3** | **MISSING OBSERVATION** | a field the format requires is absent from one judge's envelope (not "empty" — **absent**) | class 1 or 2 |
| **C4** | **ADDITIONAL UNAUTHORIZED OBSERVATION** | a judge emits a normative field the specification does not authorize, or emits an act request / summary the case does not license | class 1 or **4** |
| **C5** | **NONDETERMINISM** | a judge's own repeated runs disagree (detected in §6, before comparison) | class 1 or 4; comparison for that case is **VOID** until resolved |
| **C6** | **PROHIBITED-BRANCH EXECUTION** | an untaken branch arm produced an act summary or a store footprint (OB-6) | class **4**, automatic red |
| **C7** | **PROVENANCE / CARRIAGE LOSS** | a required OB-4 / OB-5 / OB-14 field or ordering was dropped, reordered, or replaced by a default — **including an oracle-supplied value dropped or defaulted in carriage** | class **4** if required-support removal; else 1 |
| **C8** | **REFUSAL-DETAIL LOSS** | disposition and code agree, but the nested `refuse` payload differs in structure, nesting depth, element count, or element identity — **including a nested list flattened, truncated, or coerced** | class 1 or 2 |

**Category precedence when several apply**: C5 → C6 → C7 → C8 → C4 → C3 → C2 → C1. Determinism
failures and constitutional failures are named first, because a case that is both nondeterministic
and divergent is a nondeterminism finding wearing a divergence costume.

**Transcript-caused divergences do not receive a comparator category of their own.** They are
detected by the integrity check (§6.0) and the T-ORACLE teeth (§7), and they adjudicate under
FAILURE-TAXONOMY-P1 class 3 **against the transcript** — never against J2. A comparator that
categorised them would be scoring J2 for the oracle's error.

**The comparator emits categories, never verdicts.** Classification into the five taxonomy classes
is a human act by the adjudicator, on the evidence the comparator produced (FAILURE-TAXONOMY-P1
§2).

---

## 5. Normalization prohibitions (unchanged)

The harness **must not normalize away the distinctions under test.** Each prohibition below names a
real way a comparator quietly manufactures agreement.

- **Never erase record order.** Act summaries are oldest-first; a set-comparison of summaries
  destroys OB-14. Sequence equality, always.
- **Never collapse segmented identifiers.** An act-id-hex, a store-id, a seat name, a slot name are
  compared as whole strings; no prefix matching, no case folding, no whitespace stripping, no
  splitting on separators. *(Note for the record: Ruling 6 would, if legislated in Parcel B, make
  identifier and keyword identity uppercase-canonical. It is not legislated. Until it is, the
  comparator does not case-fold — and a case-difference remains a real divergence to be
  adjudicated, not smoothed in anticipation of a law that has not passed.)*
- **Never coerce rationals to float.** Integers stay integers, exactly; no numeric widening, no
  tolerance comparison, no `==` across types that the format declares distinct. (Lisp+ integers are
  unbounded; a J2 that lands them in a fixed width is a real finding, and a coercing comparator
  would hide it.)
- **Never discard nested details.** A `refuse` payload's tree shape is normative (C8); no
  flattening, no truncation, no "first N elements," no repr-string comparison that loses structure.
- **Never treat missing provenance as empty provenance.** Absent ≠ empty ≠ nil ≠ `:none`. The format
  distinguishes them and so does the comparator, **unless the specification expressly says they are
  the same** — and where the specification is silent, the comparator preserves the distinction and
  the silence becomes a deficit entry, not a normalization.
- **Never normalize keyword vs string vs symbol.** If one judge reports `:refused` and the other
  `"refused"`, that is a real question about the format, answered by the format, not smoothed by the
  comparator.
- **Never sort a list the format calls ordered, and never compare-as-ordered a list the format calls
  unordered.** Orderedness is a property the format declares; the comparator obeys it and does not
  infer it.
- **Never compare via a serializer that round-trips through a lossy intermediate.** If envelopes are
  serialized, the serializer is part of the instrument and gets its own teeth-check (§7).
- **Never substitute a transcript value for a judge's missing carriage.** If a judge omitted an
  oracle-supplied field, the comparator reports the omission (C7); it does not fill the field from
  the transcript it happens to hold. *(Added by this revision: the harness now holds the transcript,
  and therefore holds the means to accidentally repair a judge's output.)*

**Any normalization the harness *does* perform must be declared in the harness's own header,
enumerated, and justified by a specification sentence quoted inline.** An undeclared normalization
discovered later voids every case it touched.

---

## 6. Integrity, replay, and determinism checks — independent, and BEFORE comparison

### 6.0 Transcript integrity (new; runs first)

Before either judge runs a case, the harness **recomputes each transcript's hash and compares it to
the value frozen with the case**. A mismatch **VOIDs the case** and is reported as a transcript
integrity failure with both hashes — never as a judge result. Hashes of all transcripts are taken
at holdout opening and re-taken at classification, and both sets are recorded (§8).

### 6.1 Per-judge determinism

Each judge is checked **against itself** before it is compared to anything. A comparison between two
nondeterministic judges is noise with a verdict attached.

For every case, on each judge separately:

1. **≥2 runs in separate processes**, envelopes must be **byte-identical**.
2. **J2 additionally**: runs under **≥2 distinct hash seeds** (e.g. `PYTHONHASHSEED` varied), and
   under **≥2 distinct working directories and temp paths**, with identical envelopes. Iteration
   order leaking into output is the most common Python nondeterminism and it must be caught here,
   not in comparison.
3. **J1 additionally**: native and replay envelopes identical (§3.3).
4. **Environment-independence probe**: locale and timezone varied; envelopes identical.

A judge failing any of these produces **C5** for the affected cases; those cases' comparisons are
**VOID** (a distinct outcome from *refuted* — the run did not measure what it set out to measure)
until the nondeterminism is resolved, and the resolution is itself a labeled repair (PROTOCOL-P1
§11).

---

## 7. Harness teeth-checks — the comparator is an instrument, and untested gates do not pass

**A gate that has never fired is untested, not passing.** Before any clean PASS counts, the
adjudicator plants a **known divergence in each distinguished category C3…C8**, plus the
anti-normalization plants, plus the new **T-ORACLE** plants, and shows the harness catches each in
the right category. The teeth run is recorded with its outputs.

| Planted fault | Must be caught as |
|---|---|
| drop one required field from a fabricated envelope | **C3** |
| add an unauthorized normative field / a spurious act request | **C4** |
| make a stub judge emit a run counter or a set-iteration-ordered list | **C5** |
| fabricate an envelope in which an untaken branch arm produced a summary | **C6** |
| reorder act summaries newest-first; drop `store-id`; replace an absent field with `:none` | **C7** (three separate plants) |
| flatten a nested `refuse` payload; truncate it; change one leaf | **C8** (three separate plants) |
| differ **only** in condition report text and exception class | **C2**, and **not** C1 or a red |
| identical envelopes | **C1** |

**Plus the anti-normalization teeth**, which are the ones most likely to be missing: plant a
float-vs-integer payload, a case-differing slot name, a whitespace-differing act-id-hex, and a
prefix-truncated store-id, and show that **each is caught**, not smoothed. If the comparator passes
any of these, it is normalizing and §5 has been violated.

### T-ORACLE — the transcript teeth (new; required)

The transcript is now an evidence-bearing input, so **the harness must be shown able to detect a
modified transcript.** Plant each of the following, separately, and show the harness catches it
**before** any judge result is scored:

| Planted transcript fault | Must be caught as |
|---|---|
| one byte changed in a frozen transcript | **integrity failure** (§6.0), hash mismatch exhibited |
| a transcript entry's `disposition` altered to a different lawful value | **integrity failure** — *not* a judge divergence |
| an act entry deleted; an act entry duplicated | **integrity failure** |
| act entries reordered | **integrity failure** |
| a transcript substituted wholesale from another case | **integrity failure**, with both case ids exhibited |
| a validated-prefix length altered | **integrity failure** |
| a transcript that is internally inconsistent but hash-correct *(i.e. it was frozen wrong)* | **NOT an integrity failure** — this is the residual risk, and it is named: it surfaces only as a divergence, and adjudicates as **class 3 against the transcript** (FAILURE-TAXONOMY-P1 §1.3a), never against J2 |

The last row is a **declared limit of the instrument, not a covered case.** A transcript frozen
wrong is hash-consistent forever; only adjudication, not the harness, can catch it. Recording the
limit is the honest alternative to a teeth-check that cannot exist.

**The serializer, if any, gets the same treatment**: round-trip a payload containing deep nesting,
an empty list, a nil-like absent marker, an unbounded integer, and a string with control
characters, and show the envelope survives byte-identically.

**Teeth results are reported with the campaign, not filed away.** A campaign whose comparator's
teeth were never shown to bite reports its PASS as *"clean under an untested comparator"* — which
is not a pass.

---

## 8. Freeze and holdout mechanics

- **Holdout sealed by hash at Phase 3**, plaintext **off-tree**. A prereg committed to a tree the
  subject can read is not a prereg; the same rule governs a case bank. **No holdout bodies exist
  and none may be authored** (Ruling 7; the eight S-freeze preconditions gate it).
- **Transcripts are frozen with their cases and hashed** (§6.0). A transcript is as much a frozen
  artifact as a case body, and is subject to the same no-edit rule after opening.
- **J2 freeze declaration at Phase 6** carries: implementation hash (whole tree), the self-run
  public-bank transcript, the attestation, and the implementer's deficit register.
- **At Phase 7 the adjudicator re-hashes J2** and records the hash beside the declaration's. A
  mismatch is not an accusation; it is a **fact that voids first-run status** for the whole run.
- **After the holdout opens: no evaluator and no test may be altered.** Not J1, not J2, not the
  harness, not a case, **not a transcript**, not a normalization rule. Hashes of all five are taken
  at opening and re-taken at classification, and both sets are recorded.
- **If a case turns out to be contaminated (taxonomy class 3), it is voided or rewritten — and a
  rewritten case is a NEW case in a NEW bank**, never a silent edit to the opened one. The original,
  its transcript, and the reason are preserved. **The same rule governs a defective transcript:** it
  is not repaired in place; the case is voided and re-frozen as a new case with a new transcript and
  a new hash.

---

## 9. Repair protocol (unchanged in substance)

Permitted only where the taxonomy permits it (class 1 PORT DEFECT; class 3 repairs the *test or the
transcript*). When permitted:

1. **Preserve first**: the original J2 tree by hash and archive, the freeze declaration, and the
   full failure transcript are committed **before** any edit.
2. The repair is made **by the implementer**. The adjudicator does not repair the thing it judges.
   *(For a class-3 transcript defect the repair is made by the transcript producer, not the
   implementer and not the adjudicator — the same separation, one role over.)*
3. The re-run is a **labeled repaired run** with its own hash and its own transcript.
4. **First-run conformance for that case is spent and cannot be recovered.** No aggregate, headline,
   abstract, or table may merge repaired greens into first-run greens. Every reported count carries
   both numbers or neither.

---

## 10. The record the harness must leave

Per campaign: the packet manifest hash · the J1 base identity (commit, lane subtree, **adapter form
— wrapper or modification — and its diff or source**) · **the full-inherited-floor identity-gate
diff** · the J2 freeze hash and the re-taken hash · the observation format version **and its Act
Oracle envelope version** · the comparator's declared normalizations with their quoted
justifications · the teeth-run outputs **including T-ORACLE** · **the transcript hash set at opening
and at classification** · per-case rows (`case-id · bank · category · oracle-supplied-field-count ·
first-run|repaired · taxonomy class · adjudicator · evidence pointer`) · the determinism-check
outputs per judge · the deficit register as amended during the run · every VOID with its cause.

Per case that went red: both envelopes verbatim, the transcript **and its hash**, the classification
with its reasoning, and — if repaired — the pre-repair artifacts by hash.

**What the record must make impossible**: reading a summary line and being unable to tell whether a
green was first-run or repaired; whether a comparison was VOID or passed; whether the comparator's
teeth had ever been shown to bite; **how much of a case's agreement was oracle-supplied**; and
**whether the adapter modified J1 or wrapped it**.

---

*— revised by PRAETOR (Claude Opus), Round P, commissioned by the chair (Claude Fable 5),
2026-08-10*
