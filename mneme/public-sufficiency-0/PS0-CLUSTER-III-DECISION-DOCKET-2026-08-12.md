# PS/0 — CLUSTER III DECISION DOCKET (2026-08-12)

**Prepared by the chair (Claude Fable 5) under the D-7 lane's continuing
authorization and the owner's same-night instruction to prepare the next
forks. Decision-preparation ONLY: every fork below is the owner's; nothing
here rules anything. Sources: the LEGATUS dossier
(`_staging/pubsuff0-cluster1-s1-dossier.md`, SD-01 §, SD-23 §, precedents
§4) with every load-bearing quote re-verified first-hand this sitting —
`NORMATIVE-OBSERVATION-FORMAT-0-CANDIDATE-P1.md` §4.6.2 read directly;
CD/0 `CANONICAL-DATUM-SPEC.md` §10.4/§12.1/§12.3 read directly; Language-A
`CANONICAL-SPEC-v0-DRAFT.md` D-CANON-02 read directly. Append-only.**

---

## The sitting's three forks (mutually independent; each rulable now)

### FORK III-1 — `code_normative` + SD-01's vocabulary half (put together, because they are one question)

**The unput campaign-design question, now put:** *should code agreement be
part of the conformance theorem Portable Judge /0 eventually tests — and if
so, which code population, at which vocabulary?*

**What exists today (all verified):**
- The observation format (CANDIDATE, P1) **requires `code_normative:false`**
  at this version, states its reason in full (no published code set, no
  datatype, no environment family), excludes `code` from pass/fail, reports
  agreement as an advisory column, and pre-plans the `true` transition as a
  format-version bump. **A candidate format is currently deciding an S1's
  severity with no owner authority** — the sharpest structural oddity in the
  register (LEGATUS).
- Parcel 2 cured the **datatype** half (KEYWORD vs STRING, as confined).
- The 31-code condition list exists mechanically extracted but unpublished;
  `+ma0-grammar-version+` exists as the natural versioning hook and its own
  docstring says a rule change bumps it.

**Options (mutually exclusive; the register's own A/B/C, sharpened):**

| # | Option | Consequences |
|---|---|---|
| **A** | **Both populations normative: publish the closed 31-code condition table + score program refusal codes.** | Strongest theorem — every refusal vector at full information; the format's `code_normative` flips true at a version bump; **mints a versioning obligation** (any future code = breaking change, hooked on `+ma0-grammar-version+`); completes Cluster III at maximum law. Further owner act: the versioning rule. |
| **B** | **Program refusal codes normative (KEYWORD, program-authored); condition codes diagnostic, excluded IN WRITING.** | The author-facing half (what a program *emits* — the half SD-14's cure already governs) becomes fully scorable; the format's existing `false` for condition codes acquires authority it currently lacks; SD-01 leaves the S1 class **by ruling** (drops to S2-resolved); no closed-set versioning obligation minted mid-campaign. Further owner act: none. |
| **C** | **Publish the table as descriptive; codes normative of nothing (written exclusion).** | Weakest theorem — every negative vector scored on outcome kind only; the campaign stops testing its most information-dense field, **on purpose and citably** (which is what it currently does by accident). Further owner act: none. |

**Chair's recommendation: B** (carrying LEGATUS's loose hold honestly): it
ratifies the format's posture *with authority* instead of leaving a
candidate artifact to decide an S1's severity, makes the program-authored
half scorable, and avoids minting a versioning obligation mid-campaign.
**Stated defeater: if the owner's purpose is the STRONG conformance
theorem, A is the honest route** — it is the only option under which the
lane's own refusal boundary is tested at full strength.

### FORK III-2 — SD-23(a): string normalization policy

**The conflict, both sides verified verbatim:** CD/0 (**FROZEN**) —
*"CD/0 performs no Unicode normalization… The core codec never normalizes
silently… This rule is deliberate for testimony, names, source text, quoted
evidence, and any domain where normalization could erase a meaningful
distinction."* Versus D-CANON-02 (**DRAFT, REVISABLE-UNTIL-FROZEN**) — NFC,
with its own *"honest gap: the prototype does not yet enforce NFC (SBCL has
no in-tree normalizer)."* They govern different objects, so this is not an
inconsistency in the lab's law — it is a genuine fork with a real argument
each side. Concrete divergence if unruled: `"café"` as `e`+U+0301 — one
judge carries two scalars, an NFC judge emits U+00E9; payloads differ;
neither can cite a rule.

| # | Option | Consequences |
|---|---|---|
| **A** | **No normalization — strings carried as read, scalar-exact** (CD/0's frozen answer). | One sentence + a stated reason; zero implementation delta; every string-payload vector decidable; aligns MA0 with the frozen lane. |
| **B** | **NFC on ingestion** (D-CANON-02's answer). | Mints a normalization rule AND an implementation obligation — SBCL has no in-tree normalizer, so this imports a dependency or hand-written table + repair authorization + teeth; diverges from the frozen lane. |
| **C** | **Declare normalization non-normative (written exclusion).** | No rule; the comparator must then exclude normalization-sensitive comparisons — a real cost the observation format must be told about (comparator amendment owed). |

**Chair's recommendation: A** — the only zero-delta option; cites frozen
reasoning that applies with full force to program-authored payloads.

### FORK III-3 — SD-23(b): forbidden-scalar policy

| # | Option | Consequences |
|---|---|---|
| **i** | **All scalars the reader accepts are lawful** (ratify the implementation, in writing). | Zero delta; the existing behavior becomes citable. **Honest hazard, stated:** a MA0 string may then lawfully contain a lone surrogate or noncharacter — a real interop hazard for any downstream serializer; but the hazard is ALREADY the adopted behavior; ruling (i) changes nothing except citability. |
| **ii** | **CD/0's rule: surrogates forbidden; noncharacters permitted and preserved.** | Mints a refusal → a new code (interacts with FORK III-1's vocabulary) → teeth owed; small implementation delta. |
| **iii** | **Narrower profile (control characters refused too).** | Larger mint; more teeth; furthest from adopted behavior. |

**Chair's recommendation: i**, carrying the hazard disclosure verbatim.

---

## Interactions (so no choice surprises another)

- III-2 and III-3 are independent of SD-08's ruled by-reference form — CL
  `read` says nothing about normalization; these survive every ingestion
  branch as live decisions.
- III-3 options (ii)/(iii) mint codes; if chosen together with III-1(A)'s
  closed table, the table must be minted *after* the scalar ruling or
  versioned immediately.
- The two parentheses in the evidence drawer ("open set"/"closed set") are
  released with papers only under III-1(A) (closed condition set becomes
  ruled) — otherwise they stay held.

## Ceilings

This docket rules nothing and creates no evidence. Cures land only through
a future parcel at whatever forms the owner selects, returned under the §7
form, accepted in one act. The stranger audit remains OWED; nothing is
mirror-published.

*— filed 2026-08-12 by the chair; the decisions are the owner's.*
