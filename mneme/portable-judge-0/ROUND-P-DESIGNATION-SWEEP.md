# ROUND P — DESIGNATION SWEEP (audit report)

**This is an audit report, not a successor document.** It supersedes nothing, adopts nothing,
and carries no candidate law. Date 2026-08-10 (clock read: `date -u` → `Mon Aug 10 18:03:44
UTC 2026`). Frozen court-construction baseline: commit `71422395`. Round P claims **no
evidence**; zero evidence remains earned.

Designation used throughout: **Portable Judge /0**, short form **PortJ/0**, directory
`portable-judge-0/`, targets **PortJ-L/0** and **PortJ-F/0** (Ruling 1, Ruling 3).

---

## 0. Scope: the sweep set

Nine Round-P successor files existed at sweep time. **None is UNSWEPT-AT-WRITING.**

```
cd experiments/latent-lisp/mneme/
FILES=$(ls portable-judge-0/*-P1.md LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-CANDIDATE-P1.md)
```

| # | File | Author-crew |
|---:|---|---|
| 1 | `LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-CANDIDATE-P1.md` *(in `mneme/`, one level up)* | LATTICER |
| 2 | `portable-judge-0/DG0-SKETCH-CANDIDATE-P1.md` | LATTICER |
| 3 | `portable-judge-0/LM0-PREREGISTRATION-SKELETON-CANDIDATE-P1.md` | LATTICER |
| 4 | `portable-judge-0/PROTOCOL-CANDIDATE-P1.md` | PRAETOR |
| 5 | `portable-judge-0/ADJUDICATION-CANDIDATE-P1.md` | PRAETOR |
| 6 | `portable-judge-0/FAILURE-TAXONOMY-CANDIDATE-P1.md` | PRAETOR |
| 7 | `portable-judge-0/CLEAN-ROOM-IMPLEMENTER-BRIEF-CANDIDATE-P1.md` | PRAETOR |
| 8 | `portable-judge-0/NORMATIVE-OBSERVATION-FORMAT-0-CANDIDATE-P1.md` | SIGNATOR |
| 9 | `portable-judge-0/VECTOR-CLASSIFICATION-CANDIDATE-P1.md` | SIGNATOR |

⚠ **One scoping note, stated because a later re-run will otherwise disagree with this
report.** The charter successor does **not** live in `portable-judge-0/`; it sits in
`mneme/`. A sweep written as `grep … portable-judge-0/*-P1.md` **silently misses the charter**
— nine files become eight and the miss looks like a clean set. The sweep set above is
explicit for that reason.

**A word on what this sweep can and cannot decide.** Every check below is a **grep**, and a
grep cannot distinguish **use** from **mention**. A sentence that *retires* a token contains
that token. Three of the four checks turned on exactly this distinction, and each hit was
adjudicated by reading the line rather than by trusting the count. Where the adjudication is
a judgment rather than a mechanical fact, it is labelled as one.

---

## 1. Check (a) — `PJ/0-portable` must be zero

**Command and raw result:**

```
grep -Fn 'PJ/0-portable' $FILES
grep -Fo 'PJ/0-portable' $FILES | wc -l      →  11
```

```
portable-judge-0/DG0-SKETCH-CANDIDATE-P1.md:17
LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-CANDIDATE-P1.md:251
LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-CANDIDATE-P1.md:944
LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-CANDIDATE-P1.md:1032
LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-CANDIDATE-P1.md:1126
portable-judge-0/VECTOR-CLASSIFICATION-CANDIDATE-P1.md:14
portable-judge-0/LM0-PREREGISTRATION-SKELETON-CANDIDATE-P1.md:20
portable-judge-0/LM0-PREREGISTRATION-SKELETON-CANDIDATE-P1.md:248
portable-judge-0/PROTOCOL-CANDIDATE-P1.md:21
portable-judge-0/NORMATIVE-OBSERVATION-FORMAT-0-CANDIDATE-P1.md:21
portable-judge-0/NORMATIVE-OBSERVATION-FORMAT-0-CANDIDATE-P1.md:86
```

Per-file counts (`grep -Fc`):

| File | count |
|---|---:|
| ADJUDICATION-P1 | 0 |
| CLEAN-ROOM-IMPLEMENTER-BRIEF-P1 | 0 |
| FAILURE-TAXONOMY-P1 | 0 |
| DG0-SKETCH-P1 | 1 |
| PROTOCOL-P1 | 1 |
| VECTOR-CLASSIFICATION-P1 | 1 |
| LM0-PREREGISTRATION-SKELETON-P1 | 2 |
| NORMATIVE-OBSERVATION-FORMAT-0-P1 | 2 |
| LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-P1 | 4 |
| **total** | **11** |

### VERDICT (a): **PASS on the substance — ZERO campaign USES. FAIL on a literal reading of "must be zero."**

All eleven occurrences were read individually. **Every one is a mention-in-retirement** — the
token appears only inside a sentence whose job is to retire it, enumerate it as unauthorized,
or record the sweep that removed it. **No file uses `PJ/0-portable` as a name for this
campaign anywhere.** Ruling 1's actual instruction — *"Retire `PJ/0-portable` from the
charter"* — is satisfied in all nine files.

The commissioned criterion said "must be zero," and the raw count is 11. **Reporting that as
a clean pass would be smoothing.** The honest statement is the two-part one above: the
substance passes, the stated criterion does not, and the gap is entirely the use/mention
distinction that a grep cannot see.

### FINDING a-1 — two literally false universals in the Charter successor *(reported; not touched)*

Two Charter-P1 sentences assert an absence that the same document contradicts:

| Line | Text | Problem |
|---:|---|---|
| 250–251 | *"Unauthorized forms, **which appear nowhere in this document**: `PJ0` (for this campaign), `PJ/0`, `PJ/0-portable`, …"* | the list **is** an appearance; `PJ/0-portable` additionally appears at 944, 1032, 1126 |
| 1126 | *"Designation sweep: `PJ/0-portable` → **PortJ/0**; **zero occurrences remain in this document**"* | four occurrences remain (251, 944, 1032, 1126 — the sentence counts itself) |

**Substantively harmless, procedurally not.** These are self-refuting-as-written claims of a
completed sweep, and a claim of a completed check is exactly the artifact class the lane's own
discipline says must exhibit its step or be marked compressed. **Not repaired here** — the
Charter successor is LATTICER's file and Round P's brief forbids touching another's work.
Routed to the chair as an editorial item for a later pass.

### FINDING a-2 — the lane already owns the correct idiom, and four files did not use it *(two of them were mine; corrected)*

The frozen `NORMATIVE-OBSERVATION-FORMAT-0-CANDIDATE.md` states the Rider-2 prohibition like
this:

> *"the two prohibited phrases … are used nowhere in this document **except in this sentence,
> which names the prohibition**, and may not be introduced by any citation of it."*

That is the precise idiom: **name the retired token once, visibly, rather than write a
self-refuting "appears nowhere" beside an appearance.** Two files already do the equivalent —
DG0-P1 (line 17) and LM0-P1 (line 20) both say *"appears nowhere **below**"*, which is
accurate because the mention sits in the header and "below" excludes it. PROTOCOL-P1 (line 21)
says *"is **retired**"* and asserts no universal at all, which is also clean.

**Disclosure, and it is a correction to this auditor's own work.** My two deliverables
originally carried the same false universal the Charter carries (*"appears nowhere in this
document"*). The first sweep run caught it. **I corrected my own two files before the final
run** — `NORMATIVE-OBSERVATION-FORMAT-0-CANDIDATE-P1.md` §0.1 and
`VECTOR-CLASSIFICATION-CANDIDATE-P1.md` collision note now use the use/mention idiom
explicitly — and the counts in the table above are **post-correction**. A notary who finds his
own seal crooked says so in the register; the counts (1 and 2) did not change, only the
sentences that describe them.

---

## 2. Check (b) — bare `PJ0` outside the reserving collision notes

**Command** (word-boundary, excluding `PortJ`, `PortJ/0`, hyphenated forms):

```
grep -nE '(^|[^a-zA-Z/-])PJ0([^0-9a-zA-Z-]|$)' $FILES
```

**Thirteen hits. Every one adjudicated:**

| # | File : line | Context | Verdict |
|---:|---|---|---|
| 1 | PROTOCOL-P1 : 8 | required header — *"bare PJ0 reserved for the adopted Process Journal /0"* | **LAWFUL** — reserving |
| 2 | PROTOCOL-P1 : 22 | *"`PJ0` and `PJ/0` are **unauthorized** here and remain reserved for the adopted Process Journal…"* | **LAWFUL** — reserving |
| 3 | CLEAN-ROOM-BRIEF-P1 : 8 | required header, same sentence | **LAWFUL** — reserving |
| 4 | ADJUDICATION-P1 : 8 | required header, same sentence | **LAWFUL** — reserving |
| 5 | FAILURE-TAXONOMY-P1 : 8 | required header, same sentence | **LAWFUL** — reserving |
| 6 | VECTOR-CLASSIFICATION-P1 : 8 | required header, same sentence | **LAWFUL** — reserving |
| 7 | VECTOR-CLASSIFICATION-P1 : 11 | *"NAMING COLLISION (the reserving note). The bare token **PJ0 denotes the ADOPTED Process Journal /0** … and nothing else."* | **LAWFUL** — the collision note itself |
| 8 | CHARTER-P1 : 248 | *"**Collision note:** the bare token `PJ0` is reserved for the adopted **Process Journal /0**…"* | **LAWFUL** — reserving |
| 9 | CHARTER-P1 : 250 | *"Unauthorized forms … : `PJ0` (for this campaign), …"* | **LAWFUL** — reserving; the qualifier *"(for this campaign)"* makes this one accurate, unlike its `PJ/0-portable` neighbour (Finding a-1) |
| 10 | CHARTER-P1 : 1029 | *"`PJ0` used for **this** campaign — the bare token is reserved for the adopted **Process Journal…**"* | **LAWFUL** — reserving |
| 11 | CHARTER-P1 : 1037 | *"**15.4 The reserved token.** The bare token `PJ0` denotes the adopted Process Journal /0…"* | **LAWFUL** — the reservation article |
| 12 | NORMATIVE-OBSERVATION-FORMAT-0-P1 : 9 | required header, same sentence | **LAWFUL** — reserving |
| 13 | NORMATIVE-OBSERVATION-FORMAT-0-P1 : 91 | §0.1 — *"The bare token **PJ0 is reserved for the adopted Process Journal /0** … this paragraph is the only place the reserved token appears here, and it appears in order to reserve it."* | **LAWFUL** — reserving, and self-accounting |

### VERDICT (b): **PASS — 13 hits, 13 lawful, 0 unlawful.**

**Not one occurrence of bare `PJ0` denotes this campaign in any Round-P successor file.**
Every hit is either the required header's reserving clause or an explicit collision/reservation
note. Ruling 1's reservation holds across the whole sweep set.

**One observation, not a defect.** DG0-SKETCH-P1 and LM0-PREREGISTRATION-SKELETON-P1 return
**zero** hits — they state the reservation without writing the token (*"the bare token
reserved for the adopted Process Journal /0 appears nowhere below"*). That is the strongest
possible form of compliance and is worth naming as the pattern a future round should copy: a
reservation that does not have to spend the token to make itself.

---

## 3. Check (c) — the forbidden shortened claim must be zero

**Command:**

```
grep -Fin 'independent Lisp+ implementation exists' $FILES
```

**Four hits:**

| File : line | Text |
|---|---|
| CLEAN-ROOM-BRIEF-P1 : 328 | *"**It will never be shortened to "an independent Lisp+ implementation exists."** Not in an abstract, …"* |
| PROTOCOL-P1 : 105 | *"**It must never be shortened to "an independent Lisp+ implementation exists."**"* |
| PROTOCOL-P1 : 673 | *"…sentence must never be shortened to "an independent Lisp+ implementation exists."**"* |
| CHARTER-P1 : 278 | *"…shortened to "an independent Lisp+ implementation exists."** Nor to "a second Lisp+ …"* |

A wider net was also cast, to catch paraphrase rather than the exact string:

```
grep -inE 'independent(ly)? [A-Za-z+ ]{0,20}implementation' $FILES
```

Five additional hits, all read: CLEAN-ROOM-BRIEF-P1:39 (*quoting the original brief's
"a second, independent implementation of a small language's judge" **in order to reject it***
— *"**That** …"*), CHARTER-P1:290 (a historical record of what a **superseded** lattice node
asserted), CHARTER-P1:545 and :568 (both **denials**: *"Not an independent implementation"*,
*"P5 does not become independent implementation"*). **No assertive use in any file.**

### VERDICT (c): **PASS — 4 exact hits + 5 near-paraphrase hits, 9 lawful, 0 assertive uses.**

Every occurrence of the forbidden sentence sits inside a **prohibition or a denial**, and in
three of the four exact cases the sentence is a **verbatim quotation of Ruling 3's own
instruction** (*"It must never be shortened to…"*). Unlike check (a), **this idiom is not
avoidable**: a document that carries the prohibition must state what is prohibited, and Ruling
3 stated it in those words. **The mention/use gap here is a feature of the ruling, not a
lapse by the drafters.**

⚠ **Standing warning for whoever automates this check.** A naive downstream
`grep -q 'independent Lisp+ implementation exists' && fail` gate — the obvious thing to build
— **turns red on four correct files** and would have to be either abandoned or wrongly
"fixed" by deleting the prohibition. The gate that would actually work must exclude
quotation-and-denial contexts, which means it is a **reading**, not a grep. Recorded because a
gate that cannot be built honestly should be known to be unbuildable before someone builds it
badly. (Related, and already the lane's law: **a gate that has never fired is untested, not
passing** — a code-shortening gate must be planted-and-caught before it is trusted, and this
one's plant is hard to distinguish from its own passing case.)

---

## 4. Check (d) — every `-P1` file must cite the frozen baseline `71422395`

**Command:**

```
grep -Fc '71422395' $FILES
```

| File | count |
|---|---:|
| LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-P1 | 2 |
| DG0-SKETCH-P1 | 2 |
| LM0-PREREGISTRATION-SKELETON-P1 | 2 |
| PROTOCOL-P1 | 1 |
| ADJUDICATION-P1 | 1 |
| FAILURE-TAXONOMY-P1 | 1 |
| CLEAN-ROOM-IMPLEMENTER-BRIEF-P1 | 1 |
| NORMATIVE-OBSERVATION-FORMAT-0-P1 | 1 |
| VECTOR-CLASSIFICATION-P1 | 1 |

### VERDICT (d): **PASS — 9 of 9 files cite `71422395`. Zero misses.**

`OWNER-RULINGS-2`'s freeze clarification requires that *"every later document identifies
`71422395` as the frozen baseline rather than silently treating the latest branch head as the
original parcel."* Every Round-P successor does.

**What this check does NOT establish, said plainly.** It establishes that the string is
present, and nothing more. It does **not** verify that any file's *characterization* of
`71422395` is correct, that the commit exists with that abbreviation, that the frozen artifacts
under it are byte-identical, or that ancestry was preserved. **This is a citation-presence
check, not a provenance check.** The provenance claims remain chair-reported, exactly as
`OWNER-RULINGS-2` records for the exported parcel.

---

## 5. Roll-up

| Check | Criterion as commissioned | Raw | Adjudicated | Verdict |
|---|---|---:|---|---|
| **(a)** `PJ/0-portable` | must be zero | 11 | 11 mention-in-retirement · **0 campaign uses** | **substance PASS · literal criterion FAIL** |
| **(b)** bare `PJ0` outside reserving notes | list every hit with verdict | 13 | 13 reserving · **0 unlawful** | **PASS** |
| **(c)** forbidden shortened claim | must be zero | 4 exact (+5 paraphrase) | all quotation-in-prohibition or denial · **0 assertive uses** | **PASS**, and the criterion is **unmeetable as a literal grep** — see the standing warning |
| **(d)** `71422395` citation | every `-P1` file must cite | 9/9 | presence only | **PASS**, scope-limited |

**Three items routed to the chair, none repaired here:**

1. **Finding a-1** — two literally false universals in `LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-CANDIDATE-P1.md` (lines 250, 1126). Editorial; another crew's file.
2. **The §3 standing warning** — check (c) cannot be automated as a plain grep without turning red on four correct files.
3. **The §0 scoping note** — the charter successor lives in `mneme/`, not `portable-judge-0/`; any re-run of this sweep that globs only the campaign directory will silently drop it.

**One correction to this auditor's own deliverables is disclosed in Finding a-2** and was made
before the final run.

**Nothing in this report adopts anything, and no evidence is claimed. Zero evidence remains
earned.**

---

*— swept and reported by SIGNATOR (Claude Opus), Round P, commissioned by the chair
(Claude Fable 5), 2026-08-10*
