# PS/0 PARCEL 2 — RETURN (the Cluster Sitting 1 drafting parcel)

**Constructed by the chair (Claude Fable 5), 2026-08-12, under the owner's
Cluster Sitting 1 dispositions (instrument + addendum,
`PS0-CLUSTER-SITTING-1-DISPOSITIONS-2026-08-12.md`): Disposition 1 (SD-08
cure-form = name CL `read` + bindings, with consequence sentences),
Disposition 2 (SD-02 = two normative bounds + one stated guard),
Disposition 4 (SD-01 datatype statement). Owner Ruling 2 §7 return form.
Status: PS/0 PARCEL 2 — READY FOR OWNER ACCEPTANCE.**

**Acceptance boundary:** drafting was authorized; adoption of text was not.
Every edit below is a candidate successor discharged on this parcel's
acceptance per D-3. The owner accepts — or returns — in one act.

---

## 1. Changed-file inventory (complete; docs only)

| File | Before blob | After blob |
|---|---|---|
| `language-many-acts-0/MANY-ACTS-0-GRAMMAR.md` | `16eba591` | `01cd2335` |
| `language-many-acts-0/AUTHOR-GUIDE.md` | `a5428fcf` | `0f3276a0` |
| `portable-judge-0/SPEC-DEFICIT-REGISTER-CANDIDATE.md` | `762489f9` | `ae12a54c` |
| `portable-judge-0/SPEC-DEFICIT-REGISTER-ERRATUM-2.md` | — (new) | in parcel commit |
| this return | — (new) | in parcel commit |

**Redline totals: 65 insertions, 1 deletion.** The single deleted line is
`  (declared constants).` — replaced in place by the same words extended
with the ruled values (exhibited in §3.2). **No implementation, runtime,
gate, fixture, or frozen artifact changed** (`git status` exhibits three
modified `.md` files and nothing else; no `.lisp`, no `.sh`, no frozen
Round P/OA/`71422395` material).

## 2. The edits, mapped to their authorizing dispositions

### 2.1 GRAMMAR — new §1b "Datum ingestion (the reader law, by reference)" — Disposition 1

The SD-08 cure at the ruled form. One paragraph naming **Common Lisp
`read`** and the exact bindings, **verified against
`ma0-validate.lisp` `%ma0-read-source` this sitting, not quoted from the
register**: exactly one form (empty and >1 both V-SHAPE-refused) ·
`*read-eval*` NIL · `*package*` = `lisp-plus-many-acts0.program` ·
`*read-default-float-format*` = `double-float` · external format UTF-8 ·
standard readtable (`readtable-case` `:upcase`). Everything the standard
reader does under those bindings is the ingestion law **by reference, not
by restatement**.

Three consequence sentences ride with it, per Disposition 1's "consequences
to write":

- **SD-14 (keyword spelling):** observable identity of a keyword = its
  upcased symbol-name; the upcased form is normative wherever compared.
- **SD-22 (integers):** CL integer syntax at **arbitrary precision**; no
  magnitude bound exists or is implied; V-SHAPE bounds structure, never
  magnitude (matches CD/0 one layer down).
- **Floats/ratios:** readable (deterministically, under the float-format
  binding), then refused as V-DATA — readable, never lawful.

### 2.2 GRAMMAR §2 V-SHAPE — the bounds — Disposition 2

At the ruled two-plus-one form: **depth ≤ 32 and nodes ≤ 4096 published as
normative values**; the ownership budget **65536 published as a
non-normative implementation guard, written down as free and excluded from
conformance comparison** — faithful to its own docstring ("a guard against
an unbounded copy, not a policy bound on program size", verified in
`ma0-structures.lisp` this sitting).

### 2.3 AUTHOR-GUIDE §7 — the two-population datatype statement — Disposition 4

**Program refusal code = KEYWORD** (program-authored, read via
`ma0-result-refusal-code`) vs **lane condition code = STRING**
(lane-authored, read via `ma0-refusal-code`); different types,
never compare equal; a format reporting keyword-string agreement is
defective. Includes the forward obligation: public text in this lane must
not use "code" unqualified from the ruling forward. **Scoring is explicitly
NOT decided** — the paragraph states types, not scoring (the
`code_normative` question remains unput, gating F-8).

*Reading of the ruled wording, stated honestly:* "never **again** used
unqualified" is implemented as a forward obligation on new text. Existing
occurrences (12 instances of the bare word in AUTHOR-GUIDE, most already
qualified in context) were NOT retroactively swept — a retroactive sweep
would exceed the disposition's wording and belongs, if wanted, to a future
editorial parcel.

### 2.4 AUTHOR-GUIDE §8 — the case-fold operation named — Disposition 1 (consequence)

**"Case-insensitively" = Common Lisp `string-upcase`**, simple per-character
conversion, by reference — not full Unicode case mapping, not casefolding
(`ß` stays `ß`); another substrate must reproduce the simple conversion,
not its host default. **Deliberately untouched: the seat-name asymmetry
(SD-15)** — an unruled fork (intentional vs defect); this sentence names the
operation for the normalized paths only and decides nothing about seats.

### 2.5 Register ERRATUM-2 — the scout-flagged absorption, verified first-hand

SD-01 sharpening 2 (V-ATOMS) marked **superseded**: cured by Parcel B item
B5 before this campaign's register work — verified against
`MANY-ACTS-0-GRAMMAR.md:50` and cure provenance `3af17e51` (accepted per
Owner Ruling 6A), not inherited from the scout's report. Original wording
preserved; disclosure in `SPEC-DEFICIT-REGISTER-ERRATUM-2.md`. The ERRATUM-1
line-anchor rule extends: after this parcel, cite register entries **by
name**, not line.

## 3. Register-status consequences ON ACCEPTANCE (none before it)

Upon the owner's acceptance of this parcel — and not before — the following
becomes recordable (a small ERRATUM-3 or the acceptance instrument itself
may record it): **SD-08 CURED at the ruled by-reference form** · **SD-02
CURED at the two-plus-one form** · **SD-14 and SD-07 CURED as written
consequences** · **SD-22 CURED by the arbitrary-precision sentence** ·
**SD-01 PARTIALLY CURED (datatype half; vocabulary half open, gated on
`code_normative`)**. Severity roll-ups then move: the surviving
scope-invariant S1 set reduces to **SD-01 (vocabulary half) and
SD-04 (flagged)**. Nothing in this paragraph is effective tonight.

## 4. Earned / not-earned

**Earned: nothing.** This parcel writes law at owner-ruled forms; it proves
no conformance, tests nothing, and creates no evidence of public
sufficiency. The clean-room question stays open until the campaign's own
theorem is tested. SD-13 remains **"DISPOSED BY SCOPED EXCLUSION, NOT CURED
BY PUBLICATION."** The stranger audit remains OWED. Nothing here is
mirror-published (main-ancestry guard holds).

## 5. The acceptance proposition (for the owner, one act)

> **ACCEPT PS/0 PARCEL 2**: the GRAMMAR §1b ingestion law with its three
> consequence sentences, the §2 bounds publication at the two-plus-one
> form, the AUTHOR-GUIDE §7 datatype statement and §8 operation naming, and
> Register Erratum 2 — as filed, at the forms ruled at Cluster Sitting 1.
> Acceptance discharges these candidate successors per D-3, makes the §3
> register-status consequences recordable, and creates no evidence. It does
> not decide `code_normative`, does not touch SD-15 or SD-04's flag, and
> does not adopt the register.

*— Claude Fable 5, chair, 2026-08-12.*

---

## REPAIR 1 — minimal confinement repair (same night; owner return order, relayed with the advisor's review)

**The order (verbatim, operative core):**

> **RETURN PARCEL 2 FOR ONE MINIMAL CONFINEMENT REPAIR.** … AUTHOR-GUIDE §7
> currently exceeds Cluster Sitting 1 Disposition 4 by adding the
> parenthetical claims **"program-authored, open set"** and
> **"lane-authored, closed set."** Disposition 4 authorized the datatype
> statement only … Remove only the unauthorized open-set / closed-set
> vocabulary characterizations from the candidate §7 text and from any
> Parcel 2 return prose that presents them as part of the ruled datatype
> statement. Preserve: KEYWORD vs STRING; program-authored vs lane-authored;
> their distinct accessor populations; the non-equality/type warning; the
> forward "code" qualification rule; the explicit statement that scoring and
> vocabulary remain undecided. Do not alter SD-08, SD-02, SD-14, SD-07,
> SD-22, SD-15, Erratum 2, or any implementation/runtime artifact. … Do not
> execute acceptance yourself.

**The finding, conceded on the record:** the open-set/closed-set
characterizations were imported from the decision dossier's evidence table,
not from the owner's operative wording — vocabulary *structure* riding on a
datatype ruling. The chair drafted beyond the selection. The repair confines
the text to exactly what Disposition 4 says.

**Exact delta (the whole repair; exhibited, not summarized):** four changed
lines — two in AUTHOR-GUIDE §7 (delete "(an open set)"; delete "(a closed
set)") and the two mirror lines in this return's §2.3. Everything preserved
that the order lists as preserved.

**Nothing-else-changed proof:** post-repair blob identities —
`MANY-ACTS-0-GRAMMAR.md` `01cd2335` (**unchanged**, byte-identical to the
parcel commit) · `SPEC-DEFICIT-REGISTER-CANDIDATE.md` `ae12a54c`
(**unchanged**) · `SPEC-DEFICIT-REGISTER-ERRATUM-2.md` `a0229704`
(**unchanged**) · `AUTHOR-GUIDE.md` `0f3276a0` → `168e1314` (the two-line
repair only).

**The mention-vs-use question, answered as asked (house reading, stated —
sentence NOT changed):** §7's opening — *"Code" names two distinct
populations* — is **mention, not use**: the quoted lexical item is the
*subject* of a metalinguistic statement about the word itself, not an
unqualified referring use denoting either population. The forward
prohibition targets *uses* ("the code is compared…") where a reader cannot
tell which population is meant; a quoted mention carries no such ambiguity —
and the prohibition could not even state itself without one. House reading:
**quoted mention is outside the prohibition.** The sentence stands.

**Status after repair: PS/0 PARCEL 2 (R1) — READY FOR OWNER ACCEPTANCE.**
Acceptance is the owner's act; none is executed or implied here.

*— repair filed 2026-08-12 by the chair under the owner's return order.*
