# SPEC DEFICIT REGISTER — Many Acts /0 public packet (CANDIDATE)

**STANDING: CANDIDATE — not adopted; owner disposition pending.** Date: 2026-08-10.
**ERRATUM-1 APPLIED 2026-08-12** (PS/0 Parcel 1, D-6 — disclosed corrections only,
enumerated in `SPEC-DEFICIT-REGISTER-ERRATUM-1.md`; this in-place successor's
candidate-successor status is discharged on parcel acceptance per D-3).

**Prepared against the R1 CANDIDATE base of Many Acts /0**: parcel sha256
`54aa7783c494d8f32baa3c10eecd48590b88b13f07f0de6c8724831807a02803`; patch base commit
`76952ea4f278d269f98f158555e412a095a3da6f`; R1 freeze lane subtree
`e94870bd9091e67f68e9cf238a6c5d0dcf302a05`. **The base is itself NOT owner-adopted.**
*[ERRATUM-1 (2026-08-12): the preceding sentence was true at this register's commit
(`12388ff9`, 2026-08-10 14:14:49 −03) and was superseded seventy minutes later — the
base was **ADOPTED WITH RIDERS** by the MA0 R1 adoption (`2b69c18c`, 15:24:31 −03).
The original wording stands above as documentary history; any citation must carry
this correction.]*

**NAMING COLLISION (first use, per campaign law).** "PJ0" already denotes the **ADOPTED
Process Journal /0** (`mneme/architecture/process-journal-0/`). This campaign is **Portable
Judge /0**, directory `portable-judge-0/`, short form **PortJ/0**; final designation
**pending owner ratification**.

**Inherited vocabulary rider (AP0 adoption Rider 2).** The two prohibited phrases — the
"independently ..." pair barred in the base lane — are used nowhere in this document except in
this sentence, which names the prohibition, and may not be introduced by any citation of it.
A registered deficit is a statement about the public texts; it is never evidence of
independent review, in either direction.

---

## 0. What this register is, and the question it answers

The Portable Judge /0 campaign asks whether a clean-room implementer, given only the frozen
public packet, can build a judge whose observable judgments conform. **That question has a
prior half nobody can answer by running anything: are the public texts sufficient?**

This register is the honest answer. Each entry names a **normative behavior** — something a
conforming implementation must do, or must not do — that is **presently recoverable only
from implementation source, from construction lore, or from a document outside the packet.**

**The register is not softened.** An empty register would itself be a suspicious claim: it
would say either that a 1,700-line evaluator and its four predecessors were fully described
by four markdown files, or that nobody looked. What follows is the search and its yield.

### 0.1 The search performed (shown, not claimed)

| Read as **public law** | Read as **implementation** (only after the law was enumerated) |
|---|---|
| `MANY-ACTS-0-GRAMMAR.md` (161 lines) | `ma0-structures.lisp` (354) |
| `MANY-ACTS-0-CONTRACT-CANDIDATE.md` (131) | `ma0-validate.lisp` (678) |
| `MANY-ACTS-0-FAILURE-MATRIX.md` (72) | `ma0-eval.lisp` (317) |
| `AUTHOR-GUIDE.md` (347) | `ma0-environment.lisp` (379) |
| `MANY-ACTS-0-RETURN.md` (130), `MANY-ACTS-0-R1-RETURN.md` (84) | `ma0-compose.lisp` (479) |
| `language-act-0/ADOPTION-RECORD-2026-08-08.md` (55) | `language-act-0/package.lisp`, `act0.lisp` (1,716) |
| `canon/CANONICAL-SPEC-v0-DRAFT.md` (248) | `canonical-datum/schema/cd0-fixtures.schema.json` |
| `architecture/LISP-PLUS-KERNEL-0-SPEC.md` §2.1, §4 | `language-many-acts-0/package.lisp` |

Mechanical sweeps run against the lane: the refusal-code extraction (`grep` over the five
`ma0-*.lisp` sources for `ma0-refuse` code literals) yielding **30** distinct codes, plus
`MA0-ENV-STALE` signalled by a bare `error` form (**31 total**); a `git ls-files` sweep for
One Act /0's normative documents; a `grep` for `F-GUIDE-2` across the repository.

### 0.2 Prior work absorbed

**SD-01 … SD-12 were found and drafted by LEGIST** (`PROTOCOL-CANDIDATE.md` §13) and are
carried here **verbatim in substance**, with source locations and cure classes added, so that
one consolidated register exists rather than two partial ones. **SD-13 … SD-28 are new in
this pass.** Where this register sharpens a LEGIST entry, the sharpening is marked.

### 0.3 Cure classes

| Class | Meaning |
|---|---|
| **A — public-doc amendment** | The fact is settled; a public text is missing it or contradicts another. Fix by editing a public document. No design decision required. |
| **B — new normative sentence** | The behavior is currently a *consequence of the implementation*, not a decision anyone recorded. Someone must decide, then write it. J2 cannot be scored on it until then. |
| **C — deliberately non-normative** | The silence is correct. J2 is free to differ, and the comparator must exclude the observable. Must be *written down as free*, or it will be scored by accident. |

### 0.4 Severity

**S1 — blocking**: a clean-room J2 cannot produce a conforming observation at all.
**S2 — divergence-generating**: J2 will produce *an* answer, and it will differ for reasons
that are the spec's fault, not the implementer's.
**S3 — hygiene**: a reader is misled; conformance is reachable anyway.

---

## 1. The register

### SD-13 — One Act /0 has **no public specification in the published tree** *(NEW)*

**Behavior.** Everything the constituent act does: the seven arms' semantics, the frame
sequence F1–F5, the agreement gate and its verdicts, the correspondence verdict, the
classification `classify-act-frames`, the seat-consumption law, the identity law
(`ACT-IDENTITY-TAKEN`/`ACT-9b`), the mint-refusal path, the `unpaired-f1` shape. Many Acts /0
is defined *on top of* all of it and cites it constantly ("the adopted lane's own decision",
"One Act's own row A", "the adopted law-chain").

**Where it lives.** `experiments/latent-lisp/mneme/language-act-0/` contains, as documents,
**only** `ADOPTION-RECORD-2026-08-08.md` and `CLOSURE-TRANSCRIPT-2026-08-08.txt` — plus
`act0.lisp` (1,716 lines), `act0-gates.lisp` (1,106), `act0-fixtures.lisp` and `package.lisp`.
`git ls-files` places `ONE-ACT-0-CONTRACT-CANDIDATE.md`, `ONE-ACT-0-FAILURE-MATRIX.md`,
`ONE-ACT-0-IDENTITY-TABLE.md`, `ONE-ACT-0-SPECIMEN.md`, and `ONE-ACT-0-TEST-PLAN.md` in
**`_staging/oneact-candidate/`** at the repository root — outside `experiments/latent-lisp/`,
therefore outside the mirrored subject tree, therefore **not in the published packet at all**.
*[ERRATUM-1 (2026-08-12): the `language-act-0/` enumeration in the preceding paragraph is
incomplete — `git ls-files` returns **ten** tracked files, not the six named; the four
omitted (`act0-load-witnesses.lisp`, `act0-load-witnesses.sh`, `act0-loader-disease.sh`,
`act0-selftest.lisp`) are the sole carriers of the comment-only law C4-01…C4-11
(authentication dossier §A.5), so the incomplete enumeration UNDERSTATED the deficit.
Separately and later, PS/0 Parcel 1 (D-5) adds `rulings/` — five byte-preserved owner-ruling
copies plus a provenance sidecar — a disclosed post-register addition, which publishes
rulings, not the specification, and cures nothing in this entry.]*
`act0/package.lisp` cites that contract by section (§0.3, §0.4, §2.3, §7.1, §10, §13, §19.2–5)
from inside a file that ships without it.

**Why the public docs underdetermine it.** They do not underdetermine it; they do not
contain it. Every MA0 statement about act behavior is a *citation of an absent document*.

**Consequence for PortJ/0.** This is what makes the Act Oracle Interface (PROTOCOL §3)
necessary rather than merely convenient: J2 cannot implement the act layer because the act
layer is not published. The AOI is therefore **not only a scoping choice — it is forced by a
publication gap**, and the campaign's claim wording should say so.

**Cure class: A** (publish the One Act /0 normative set into the lane, or into the packet)
**— or an explicit, written declaration that the act layer is out of scope for any
conformance claim.** **Severity: S1.**

**DISPOSITION (ERRATUM-1, 2026-08-12, per PUBLIC SUFFICIENCY /0 — OPENING DISPOSITION
INSTRUMENT /0, D-1/D-2, commit `575db52f`): "SD-13 — DISPOSED BY SCOPED EXCLUSION, NOT
CURED BY PUBLICATION."** The owner ruled the second cure branch: for all purposes of
PS/0 and PortJ-L/0 conformance, the One Act /0 act layer is explicitly excluded from the
observable boundary, and the Act Oracle Interface is its declared, ruled boundary rather
than an expedient (PortJ-F/0 unaffected; Owner Ruling 3's oracle expiry intact). This
disposition is **never** evidence of act-layer public sufficiency — the ruling says the
excluded proposition is not inside the theorem being tested, not that the deficit
vanished. No artifact may state "SD-13 cured."

---

### SD-01 — No published refusal-code table; the codes' datatype is unstated *(LEGIST; sharpened)*

**Behavior.** Every lane refusal carries a **code**, readable through the exported
`ma0-refusal-code`. The **complete set, mechanically extracted** from the five lane sources:

```
ACT-12 · ACT-ORDER-1 · BIND-6 · MA0-AUTH-1 · MA0-ENV-ARM · MA0-ENV-ARMS ·
MA0-ENV-DATA · MA0-ENV-GRANT · MA0-ENV-INPUT · MA0-ENV-REVOKE · MA0-ENV-ROOT ·
MA0-ENV-SEAT · MA0-ENV-STALE · MA0-ENV-VOID · MA0-FRAME · MA0-OWN-BOUND ·
MA0-RUN-1 · MA0-RUN-2 · O-8 · V-ARM · V-AUTH · V-BIND · V-DATA · V-FIELD ·
V-PATTERN · V-PKG · V-READ · V-RES-AUTH · V-RETRY · V-SHAPE · V-TERM
```

**31 codes.** None of the public texts publishes this list.

**Source.** `ma0-structures.lisp` §1 (`ma0-refuse`, the `code` initarg); the literals are
scattered across `ma0-validate.lisp`, `ma0-eval.lisp`, `ma0-environment.lisp`,
`ma0-compose.lisp`; `MA0-ENV-STALE` is signalled by a direct `error` form in
`ma0-environment.lisp` `%ma0-check-environment-current`.

**Two sharpenings this pass adds.**
1. **The datatype differs from the program-level one.** A condition code is a **string**
   (`"V-SHAPE"`); a program's `ma0-result-refusal-code` is a **keyword** (`:unexpected`,
   AUTHOR-GUIDE §7). The public texts use the same word, "code", for both and never
   distinguish the types. An observation format that got this wrong would compare a keyword
   to a string and call it agreement.
2. **`V-ATOMS` is a published law with no observable.** GRAMMAR §2 names **V-ATOMS** as one of
   the validator's laws; **no refusal in the lane carries that code** — atom refusals surface
   as `V-PKG` or `V-DATA`. A J2 that emitted `V-ATOMS` would be following the published law
   and diverging from the implementation.
   *[ERRATUM-2 (2026-08-12): this sharpening was CURED before this erratum, by Parcel B item
   B5 (owner-disposed, executed `3af17e51`, accepted per Owner Ruling 6A): GRAMMAR §2 now
   marks V-ATOMS as **UMBRELLA — never emitted** and classifies every validator name as
   OBSERVABLE or UMBRELLA. The sharpening stands above as documentary history of what this
   register found on 2026-08-10; it is no longer a live deficit. SD-01's remaining substance
   (unpublished code table; datatype) is unaffected by this note — the datatype half was
   separately ruled at PS/0 Cluster Sitting 1, Disposition 4, and its cure rides Parcel 2.]*

**Cure class: B** (decide the code vocabulary and its type, then publish a law→family→code
table). **Severity: S1** if codes are scored; **S2** if excluded (as
`NORMATIVE-OBSERVATION-FORMAT-0` §4.6.2 does, with `code_normative:false`).

**STATUS (ERRATUM-3, 2026-08-12): PARTIALLY CURED-BY-PARCEL-2 — the DATATYPE half only**
(AUTHOR-GUIDE §7 as confined by Repair 1: program refusal code = KEYWORD, program-authored;
lane condition code = STRING, lane-authored; distinct accessors; never compare equal;
forward qualification rule — PS/0 Cluster Sitting 1 Disposition 4; accepted; discharged per
D-3). **The VOCABULARY half remains OPEN** — whether either population is scored, and at
which vocabulary, is gated on the unput `code_normative` campaign-design question
(Cluster III). The open-set/closed-set characterizations were expressly NOT ruled.

**STATUS (ERRATUM-4, 2026-08-12): FULLY CURED.** The vocabulary/scoring half was ruled at
Cluster Sitting 2 Disposition III-1(B) and drafted by Parcel 3 (AUTHOR-GUIDE §7 scoring
paragraph, accepted; discharged per D-3): **program refusal codes are normative
conformance observables** (compared at the upcased-keyword identity; normative-as-output
does NOT constitutionally close the program-code vocabulary); **lane condition codes are
diagnostic only, excluded from conformance comparison as written law.** With the Parcel-2
datatype half, SD-01 is cured whole and leaves the S1 class.

---

### SD-02 — Declared bounds are declared but their **values** are not published *(LEGIST)*

**Behavior.** `+ma0-max-source-depth+` = **32**, `+ma0-max-source-nodes+` = **4096**,
`+ma0-max-owned-nodes+` = **65536**.

**Source.** `ma0-structures.lisp` §2 and §2c. None is exported (CONTRACT §6 exports only
`+ma0-grammar-version+`, `+ma0-arms+`, `+ma0-axes+`).

**Why underdetermined.** GRAMMAR §2 V-SHAPE says depth and length are *"finite and bounded
(declared constants)"* — a promise that constants exist, not a statement of what they are.
Two judges with different bounds accept and refuse **different programs**, and every boundary
case in a hidden vector bank becomes unanswerable.

**Cure class: A** (publish the three values; they are already decided). **Severity: S1** for
any boundary case, **S3** otherwise.

**STATUS (ERRATUM-3, 2026-08-12): CURED-BY-PARCEL-2** at the owner-ruled two-plus-one form
(GRAMMAR §2 V-SHAPE: 32 and 4096 normative; 65536 published as a non-normative
implementation guard, written down as free — PS/0 Cluster Sitting 1 Disposition 2;
accepted; discharged per D-3).

---

### SD-14 — Keyword identity: the source spelling and the observable spelling differ *(NEW)*

**Behavior.** A program authored `(refuse (:code :earth-entry-quarantined) …)`; the observed
refusal code is `:EARTH-ENTRY-QUARANTINED`. Ingestion upcases; the observable identity of a
keyword is its **upcased symbol-name**, not its source spelling.

**Source.** `ma0-validate.lisp` §2 `%ma0-read-source` (standard reader, `*read-eval*` nil,
`*package*` bound to the program namespace — but **no** `readtable-case` statement, so the
standard `:upcase` applies); observable in the P5 first-run transcript
(`language-many-acts-0/p5/p5-FIRST-RUN.txt`: *"PREDICTED refusal code
:earth-entry-quarantined got :EARTH-ENTRY-QUARANTINED"*).

**Why underdetermined.** Every public example writes keywords in lowercase
(`:unexpected`, `:absent`, `:settled`). No public text says the observable form is upcased,
nor which form is normative. On a case-sensitive substrate, J2 has a 50/50 guess that will
diverge on **every** program-authored refusal code.

**Relation to SD-08.** SD-08 names the general problem (Common Lisp `read` as the unwritten
ingestion law). This entry is its sharpest single consequence and the one most likely to
appear in *every* case rather than in edge cases.

**Cure class: B** (declare which spelling is normative — the source form, the upcased
symbol-name, or a case-folding rule). **Severity: S2**, and pervasive.

**STATUS (ERRATUM-3, 2026-08-12): CURED-BY-PARCEL-2** — GRAMMAR §1b's consequence sentence:
the upcased symbol-name is the normative form wherever compared (accepted; discharged per D-3).

---

### SD-15 — Seat names resolve **case-sensitively** while slot and input names do not *(NEW)*

**Behavior.** Slot names and input names are matched through `%ma0-name-key`, which is
`(string-upcase (string designator))`. Seat names are matched with a bare
`(assoc declared-name seat-map :test #'string=)` — **no normalization**. So
`(:seat "S-Entry")` against a seat map declaring `"s-entry"` is an environment refusal, while
`editor-grant` against `"EDITOR-GRANT"` is a match.

**Source.** `ma0-environment.lisp` `%ma0-name-key`, `%ma0-slot-occupied-p`,
`%ma0-input-value` (normalized) vs `%ma0-resolve-seat` (not).

**Why underdetermined.** AUTHOR-GUIDE §8 says *"Slot and input names are matched
case-insensitively against the source's identifiers"* — an accurate positive statement whose
**omission of seats is the whole content** and is invisible to a reader who is not looking
for it. A J2 that normalizes all three (the obvious reading) diverges.

**Cure class: A** (state the asymmetry) **or B** (decide it is a defect and unify). This is a
fork, not an editorial fix: the asymmetry may be intentional (a seat name is a *declared
string*, not an identifier) or may be an oversight. **Severity: S2.**

---

### SD-07 — The case-normalization rule itself is source-only *(LEGIST; sharpened)*

**Behavior.** `%ma0-name-key` = `string-upcase` of the string designator.

**Source.** `ma0-structures.lisp` §2b.

**Why underdetermined.** "Case-insensitively" underdetermines *upcase vs downcase vs full
Unicode case folding*, and these differ for non-ASCII names (Turkish dotless i, ß/SS, final
sigma). Common Lisp `string-upcase` is *simple, per-character* case conversion; Python's
`str.upper()` is **full** case mapping (`"ß".upper() == "SS"`), and `str.casefold()` differs
from both. **A J2 in the recommended substrate diverges on the first non-ASCII slot name.**
There is no rule against non-ASCII identifiers anywhere in the law.

**Cure class: B** (declare simple ASCII upcase and refuse non-ASCII name characters, or
declare a Unicode operation by name). **Severity: S2.**

**STATUS (ERRATUM-3, 2026-08-12): CURED-BY-PARCEL-2** — AUTHOR-GUIDE §8 names the operation:
CL `string-upcase`, simple per-character conversion, by reference (accepted; discharged per
D-3). Seat-name asymmetry (SD-15) deliberately untouched.

---

### SD-08 — The datum-ingestion rule is Common Lisp `read`, and it is nowhere written *(LEGIST — the central risk)*

**Behavior.** Token grammar, symbol upcasing, keyword syntax, integer syntax (radix, `#x`,
sign), string escaping, character syntax, comment syntax, dotted-pair detection, `#(`,
`#.`, package markers — all inherited from `read`.

**Source.** `ma0-validate.lisp` §2 `%ma0-read-source`.

**Why underdetermined.** The packet states four things about ingestion (one form; `*read-eval*`
NIL; read into the program namespace; UTF-8) and then leans on an unnamed 1,000-page standard
for everything else. LEGIST's recorded prediction stands and is endorsed here: **if this
campaign returns a class-2 verdict, SD-08 is the most likely site.**

**One addition this pass makes.** `%ma0-read-source` also binds
`*read-default-float-format*` to `double-float` — a binding that exists only to make float
*reading* deterministic before V-DATA refuses the float. So floats are read and then refused,
rather than being unreadable; the refusal code is `V-DATA`, unpublished (SD-01). A ratio
(`1/2`) takes the same path. The public `LITERAL` production implies both refusals but names
neither.

**Cure class: B** (a written datum-ingestion grammar, substrate-neutral). **Severity: S1.**

**STATUS (ERRATUM-3, 2026-08-12): CURED-BY-PARCEL-2** at the owner-ruled by-reference form
(GRAMMAR §1b: CL `read` + the exact bindings; PS/0 Cluster Sitting 1 Disposition 1; parcel
accepted, successors discharged per D-3). A cure of the public texts, never evidence a
clean-room implementation would succeed.

---

### SD-16 — `(field X AXIS)` over a non-present facet yields the **standing keyword** *(NEW; sharpens LEGIST's OB-8)*

**Behavior.** If the facet's standing is not `:present`, `field` evaluates to the **standing
keyword itself** (`:absent-from-evidence` / `:malformed-in-evidence`) as an ordinary program
value, which can then flow into a `result` or `refuse` payload.

**Source.** `ma0-eval.lisp` §2, the `FIELD` branch: *"The TYPED ABSENCE is carried, never
filled in… this branch does not fire today; it exists so that a widened axis set cannot
silently start substituting NIL for an absence."*

**Why underdetermined.** GRAMMAR §4 and AUTHOR-GUIDE §6 define the two absence keywords for
**matching** only. No public text says what `field` *projects* for a non-present facet.
LEGIST's OB-8 states the behavior correctly — **but states it as law, and it is not law: it
is a reading of the implementation.** This entry records that.

**Consequence for the value domain.** It widens the observable value domain from {string,
integer, keyword, sequence} to include absence keywords appearing as values. Currently
unreachable (Surface /2 reports `:present` for all three closed axes), so this is a
**latent** deficit that becomes live the moment an axis is widened.

**Cure class: B** (state the projection rule) **or C** (declare unreachable at /0 and
excluded). **Severity: S3 today; S1 on any axis widening.**

---

### SD-17 — `ma0-complete-act` is exported with an undocumented return shape *(NEW)*

**Behavior.** It returns a plist with exactly these keys:
`:class · :row · :verdict · :standing · :evidence-class · :correspondence · :act-id-hex`.

**Source.** `ma0-compose.lisp`, the final form of `ma0-complete-act`.

**Why underdetermined.** CONTRACT §6 exports it — *"the public composition; exported so teeth
can drive it directly"* — and the AUTHOR-GUIDE never mentions it. An exported entry point
whose return value is undescribed is a public API with a private contract. It also carries
`&key verbose`, undocumented, which writes to `*standard-output*`.

**Cure class: A** (document the return shape) **or B** (de-export it and give the teeth an
internal route). **Severity: S3** for PortJ/0 (the campaign compares `ma0-run-program`
outcomes), **S2** for anyone who takes CONTRACT §6 as the surface to implement.

---

### SD-18 — The agreement-verdict vocabulary is unpublished, and an invariant is unstated *(NEW)*

**Behavior.** `ma0-act-summary-verdict` is *"the agreement verdict string"* (AUTHOR-GUIDE §4)
with **no enumeration**. In the implementation the only value that can survive into a
returned summary is `"agree"`: law O-8 refuses with `ma0-composition-divergence` on any other
(`ma0-compose.lisp`: `(unless (string= verdict "agree") …)`).

**Why underdetermined.** Two facts are missing, and the second is the interesting one:
(a) the verdict vocabulary; (b) **the invariant that follows from O-8** — a program result
can never carry a non-`"agree"` verdict, because a non-agree verdict aborts the act with a
condition. A J2 given a hidden case with a disagreeing verdict must produce a *condition*,
not a summary. That is derivable from `ma0-compose.lisp` and from nothing public.

**Cure class: B** (publish the vocabulary and the O-8 consequence). **Severity: S2.**

---

### SD-19 — `act-id-hex` nullability is stated for the wrong field *(NEW)*

**Behavior.** AUTHOR-GUIDE §4 documents `NIL` for **`verdict`** ("or `NIL` on a mint-refused
act") and gives `act-id-hex` as "the 64-character act-identity digest segment", unqualified.
The structure definition says otherwise: `(act-id-hex nil :read-only t) ; the 64-char digest
segment, **or NIL**`.

**Source.** `ma0-structures.lisp` §3, `ma0-act-summary`.

**Why underdetermined.** The conditions under which `act-id-hex` is absent are stated
nowhere. For an observation format this is exactly the missing-vs-empty question: a J2 that
emits an empty string where J1 emits absence diverges, and neither can cite a rule.

**Cure class: A** (state nullability per disposition for **both** fields). **Severity: S2.**

---

### SD-06 — `ma0-environment-stale` is exported but absent from the "closed" export list *(LEGIST)*

**Behavior.** The lane exports `ma0-environment-stale` and
`ma0-environment-stale-store-id`. CONTRACT §6, headed *"Exports (closed; the census gate
asserts count and boundness)"*, lists seven condition types and does not include it. The
AUTHOR-GUIDE does not mention it at all.

**Source.** `language-many-acts-0/package.lisp` export list; `ma0-structures.lisp` §1.

**Cure class: A** (amend CONTRACT §6). **Severity: S3** — but see SD-25, which is the same
omission at the level of *law* rather than *list*, and is not S3.

**STATUS (ERRATUM-1, 2026-08-12): CURED-BY-PARCEL-A.** CONTRACT §6 now lists
`ma0-environment-stale` and `ma0-environment-stale-store-id` with a disclosure that they
entered with the R1/D4 repair (verified at `MANY-ACTS-0-CONTRACT-CANDIDATE.md:86-111`).
Parcel A accepted by Owner Ruling 4; candidate-successor status DISCHARGED per D-3.

---

### SD-25 — The single-active-environment law appears only in a return document *(NEW)*

**Behavior.** An `ma0-environment` is stamped with a private monotonic **generation** at the
moment `make-ma0-environment` reassigns One Act /0's five run-state specials. Presenting an
environment of an older generation to `ma0-run-program` or `ma0-complete-act` signals
`ma0-environment-stale` **before anything is written**. This is a hard runtime law with an
observable outcome.

**Source.** `ma0-structures.lisp` §3 (`generation` slot, `*ma0-environment-generation*`);
`ma0-environment.lisp` `%ma0-check-environment-current`; gated twice in `ma0-eval.lisp`
(door and act step) and once in `ma0-compose.lisp`.

**Why underdetermined.** AUTHOR-GUIDE §10's cap list — the guide's own inventory of what a
programmer must know — has **nine caps and none of them is this one**. Cap 3 says "One
program per image" and explains the collision as *"the second run's act is refused by the
adopted lane"* — which describes the **pre-R1** behavior. R1 replaced that mechanism, and
only `MANY-ACTS-0-R1-RETURN.md` §2/§5 records it, in prose about a repair rather than as a
rule. A programmer reading the guide learns a mechanism that is no longer the one that fires.

**Cure class: A** (add the cap to AUTHOR-GUIDE §10 and correct cap 3) **+ A** (SD-06's list).
**Severity: S2.**

---

### SD-20 — `:revocations` is missing from the contract's environment signature *(NEW)*

**Behavior.** `make-ma0-environment` accepts `:root :arms :grants :revocations :seat-map
:inputs`. CONTRACT §6 lists `(:root :arms :grants :seat-map :inputs)` — five of six.
AUTHOR-GUIDE §8 documents all six.

**Source.** `ma0-environment.lisp` `make-ma0-environment` lambda list.

**Cure class: A.** **Severity: S3** (the guide is right; the contract is stale) — but it is
the second place where CONTRACT §6's "closed" surface disagrees with the code, and a closed
surface that two normative documents describe differently is not closed.

**STATUS (ERRATUM-1, 2026-08-12): CURED-BY-PARCEL-A.** CONTRACT's environment signature now
includes `:revocations`, with a disclosure of the prior omission (verified at
`MANY-ACTS-0-CONTRACT-CANDIDATE.md:88-97`). Parcel A accepted by Owner Ruling 4;
candidate-successor status DISCHARGED per D-3.

---

### SD-21 — One authority slot may carry grants for **several** arms *(NEW)*

**Behavior.** Occupancy is an alist `slot-name → list-of-arms`. Two grant plans naming the
same slot with different arms are lawful and accumulate; the same slot+arm twice is refused.
`%ma0-slot-occupied-p` tests slot **and** arm.

**Source.** `ma0-environment.lisp` `%ma0-check-grants`, `%ma0-slot-occupied-p`.

**Why underdetermined.** AUTHOR-GUIDE §3 and §8 read as one slot ↔ one grant
(*"journal one Capability /0 grant for that arm's seat; record the slot as occupied for it"*).
The many-arms-per-slot shape is not stated, and the *pairing* rule — that occupancy is checked
against `(slot, arm)`, not slot alone — is what actually decides whether an act begins.

**Cure class: A.** **Severity: S2** for any case with a shared slot.

---

### SD-22 — Integer magnitude and the numeric tower are unlegislated *(NEW)*

**Behavior.** The atom check is `(integerp node)` — unbounded. `+ma0-max-source-nodes+` and
`+ma0-max-source-depth+` bound *structure*, not *magnitude*. A 10,000-digit integer is a
lawful literal.

**Source.** `ma0-validate.lisp` §3 `atom-check`; §2c `%ma0-own` shares numbers as immutable.

**Why underdetermined.** `LITERAL := STRING | INTEGER | KEYWORD` names a type without a range,
and no public text says integers are arbitrary-precision. A J2 on a substrate with fixed-width
integers (or one that reaches for a fixed-width type because nothing said otherwise) silently
truncates. Contrast Canonical Datum /0, which pins integers as unbounded decimal strings
`^(?:0|-?[1-9][0-9]*)$` in its own fixture schema — the lab has already decided this question
one layer down and Many Acts /0 does not cite that decision.

**Cure class: B** (declare arbitrary precision, or declare a bound). **Severity: S2.**

**STATUS (ERRATUM-3, 2026-08-12): CURED-BY-PARCEL-2** — GRAMMAR §1b: CL integer syntax at
arbitrary precision; V-SHAPE bounds constrain structure, never magnitude (accepted;
discharged per D-3).

---

### SD-23 — String content policy: no normalization, no forbidden-scalar rule *(NEW)*

**Behavior.** Sources are read with external format `:utf-8`. Any character the reader accepts
inside a string literal becomes part of a string value and can flow into a result payload.
There is no normalization pass, no restriction on control characters, no restriction on
surrogates or noncharacters.

**Source.** `ma0-validate.lisp` §2 `%ma0-read-source` (`:external-format :utf-8`); no other
string policy exists in the lane.

**Why underdetermined.** Contrast, again, one layer down: Canonical Datum /0's failure
vocabulary contains `InvalidUTF8` and `ForbiddenUnicodeScalar`, and the Language-A canonical
spec's D-CANON-02 chose **NFC** while recording as an *"honest gap"* that the prototype does
not enforce it. Many Acts /0 inherits neither decision and states none of its own. Two judges
that normalize differently produce different strings for the same source file.

**Cure class: B** (declare a normalization form and a scalar policy, or declare explicitly
that strings are carried as opaque octets). **Severity: S2.**

**STATUS (ERRATUM-4, 2026-08-12): CURED-BY-PARCEL-3** at the owner-ruled III-2/III-3 forms
(GRAMMAR §1b strings bullet: character-exact identity per the admitted reader; no Unicode
normalization — CD/0's non-normalization rationale adopted, CD/0's scalar repertoire
expressly NOT; reader-admitted repertoire with the serialization hazard disclosed in the
law text; PS/0 Cluster Sitting 2, accepted; discharged per D-3). The owner's
anti-ambiguity pin travels: historical "scalar-exact" shorthand in the frozen sitting
record does not narrow the repertoire.

---

### SD-24 — VOID is a typed condition, and the guide describes it as a status *(NEW)*

**Behavior.** `make-ma0-environment` runs One Act /0's environment pre-flight first; if it
signals, MA0 refuses with `ma0-environment-refused`, code `MA0-ENV-VOID`, and **no store is
created**.

**Source.** `ma0-environment.lisp`, the `handler-case` around
`lisp-plus-language-act0:w-env-preflight`.

**Why underdetermined.** AUTHOR-GUIDE §8 says *"the run is VOID — no store is created, and a
void is not a failure of your program"* without saying it arrives as a **condition of a named
type with a named code**, i.e. that a caller must handle it exactly as it handles any other
environment refusal. A J2 might reasonably model VOID as a third *outcome disposition* rather
than a condition. (`NORMATIVE-OBSERVATION-FORMAT-0` §4.6 gives it its own outcome kind for
exactly this reason — a **format decision**, not a reading of the law.)

**Cure class: A.** **Severity: S3.**

---

### SD-12 — The "already-read form" door forfeits guarantees the guide does not mention *(LEGIST; sharpened)*

**Behavior.** `ma0-validate` accepts a pathname **or an already-read form**. On the form path
the lane's reader never runs, so `*read-eval*` was never bound to NIL and `*package*` was
never bound to the program namespace. **V-READ is not a property of the validator; it is a
property of the lane's reader.** What remains on the form path is V-PKG, which refuses foreign
homed symbols after the fact.

**Source.** `ma0-validate.lisp` `ma0-validate` (`(if (pathnamep source) (%ma0-read-source
source) source)`), and §2's own docstring: *"THE BINDINGS ARE THE LAW, NOT A CONVENTION."*

**Sharpening.** A `#.` in a form read by the *caller* has **already been evaluated** before
`ma0-validate` sees anything. The failure-matrix witness `W-V-READ` is therefore a witness
about one of the two doors. The guide names the second door and states none of this.

**Cure class: A** (state the forfeit) **or B** (refuse the form path). **Severity: S2.**

---

### SD-03 — No arm → runtime-seat table *(LEGIST; = the lane's own F-GUIDE-1)*

Already registered publicly as **F-GUIDE-1** (`MANY-ACTS-0-RETURN.md` §3): the AUTHOR-GUIDE
lacks the mapping, and an author must call an exported fixture reader — which a non-CL J2
cannot call. The P5 packet closed it *for one test* with a one-table addendum
(`notes/2026-08-10-p5-sol-inhabitation-protocol.md`), which is **not** in the lane and **not**
in the packet.

**Cure class: A** (fold the addendum table into the guide). **Severity: S1** without the AOI;
**S3** with it.

---

### SD-28 — The arm → disposition/class mapping is public **only** in the P5 packet addendum *(NEW)*

**Behavior.** `A → :returned/:a` · `B-L1 → :refused/:b` · `B-L2 → :refused/:b` ·
`B-R → :mint-refused/:unpaired-f1` · `C-i → :interrupted/:c-i` · `C-ii → :interrupted/:c-ii` ·
`D → :host-fault/:d`.

**Where it lives.** `notes/2026-08-10-p5-sol-inhabitation-protocol.md`, "Guide addendum
content", extracted live from the exported fixture table for the P5 test. **Not** in the lane;
**not** in the packet.

**Why underdetermined.** AUTHOR-GUIDE §4 publishes the *vocabularies* of `disposition` and
`class` and never says which arm yields which. A program that branches on
`(:disposition :refused)` cannot be written from the guide alone, and the worked example in
`NORMATIVE-OBSERVATION-FORMAT-0` §6 has to cite a notes file to fill two cells.

**Distinct from SD-03** (which is about *seats*) and from **SD-04** (which is about *derived
facets*). Three separate tables, all needed to author, none in the guide.

**Cure class: A.** **Severity: S1** without the AOI.

---

### SD-04 — The derived-facet table covers three situations of many *(LEGIST)*

AUTHOR-GUIDE §6 publishes derived facets for exactly three: untouched seat, completed **A**,
completed **C-i**. `B-L1`, `B-L2`, `B-R`, `C-ii`, `D` are unpublished. Any hidden case
touching them is unanswerable from public law.

**Cure class: A.** **Severity: S1** for such cases.

**STATUS (ERRATUM-5, 2026-08-12): AOI-RELIEF READING ADOPTED by owner disposition** —
classified **S3 under the AOI-mediated PS/0 / PortJ-L/0 boundary** (the AOI supplies the
three closed derived facets with their standings; no clean-room guess occurs inside that
theorem). **NOT CURED**: the derivation law for the five arm-situations remains
unpublished, and the deficit remains **live for any oracle-free boundary** (PortJ-F-style),
which must discharge it before relying on derived facets. The flag carried since the
Opening Disposition Instrument is **DISPOSED as a severity/scope ambiguity** — no
undocumented distinction from the analogous AOI-relieved deficits is adopted. Moved to
Cluster II / deferred S3; Surface /2 extraction NOT opened.

---

### SD-05 — Public law contradicts itself about the concordance teeth *(LEGIST)*

AUTHOR-GUIDE §10 cap 9: the concordance teeth *"**have not been built**"*.
`MANY-ACTS-0-R1-RETURN.md` §2: *"7 arms / 7 traversed / 126 concordance facets / 0
divergences"*. Both are in the packet. The packet must declare which governs, and the base
lane should carry an erratum.

**Cure class: A.** **Severity: S3** for conformance, **S1** for the packet's credibility —
a clean-room implementer who notices a self-contradiction in the law reasonably stops.

**STATUS (ERRATUM-1, 2026-08-12): CURED-BY-PARCEL-A.** AUTHOR-GUIDE §10 cap 9 now states
the concordance teeth *"have been built and run"* (verified at `AUTHOR-GUIDE.md:377-381`);
the self-contradiction is resolved. Parcel A was accepted by Owner Ruling 4;
candidate-successor status DISCHARGED per D-3 (acceptance discharges).

---

### SD-09 — `+ma0-axes+` is exported without a published shape *(LEGIST)*

Its structure (`((:outcome :execution :provenance :evidence-class) (:act-result :disposition
:class))`) is source-only; the per-axis value tables and the two absence keywords are
**not exported at all**, though the values themselves are published in GRAMMAR §4 and
AUTHOR-GUIDE §6.

**Source.** `ma0-structures.lisp` §2.

**Cure class: A.** **Severity: S3.**

---

### SD-10 — `store-id`'s true semantics are published in the wrong document *(LEGIST)*

R1-F5: content-derived; two environments from identical declarations carry the same string;
**cannot discriminate two stores**. AUTHOR-GUIDE §8 lists `-store-id` with no caveat.

**Cure class: A.** **Severity: S2** for anyone using it as an identity — which the guide
invites.

---

### SD-11 — Printed representations are unlegislated *(LEGIST)*

R1/D5 hid the environment's interior behind `print-unreadable-object` after the default
printer exposed the live store, bootstrap authority, and minting context to any `~s`. Whether
*any* printed form is observable is stated nowhere. PortJ/0 excludes them by harness decision.

**Cure class: C** (declare printed forms non-normative and excluded from comparison) — and it
must be *written*, because an unwritten exclusion is scored by accident.
**Severity: S3.**

---

### SD-26 — The act-identity digest's governing specification is never cited *(NEW)*

**Behavior.** `act-id-hex` is the **last segment** of a Journal /0 segmented identifier
(`(idf (list +lane-stem+ "act" digest))`), read through the exported `identifier-segments`.
Its derivation is governed by Process Journal /0 and Canonical Datum /0 — both **adopted and
published** (`architecture/process-journal-0/`, `canonical-datum/`).

**Source.** `ma0-compose.lisp` `%ma0-act-id-hex`.

**Why underdetermined.** Not because the governing specs are secret — because **no Many Acts
/0 document cites them.** A clean-room implementer reading the packet has no pointer from
"the 64-character act-identity digest segment" to the two specifications that define what
those characters are. One cross-reference sentence closes it.

**Cure class: A.** **Severity: S3** under the AOI (the digest is supplied); **S1** for
anyone attempting the substrate layer.

---

### SD-27 — There is no branch-selection observable *(NEW; an observability gap, not a hidden behavior)*

**Behavior.** Nothing public — and nothing in the implementation — records *which clause a
branch selected*. The law's guarantee is a consequence: exactly one arm runs, and the untaken
arm leaves *"no journal footprint and no act summary"* (FAILURE-MATRIX W-BRANCH-ONE). The only
evidence of selection is the acts that happened and the terminal that was reached.

**Why it belongs in this register.** Because the *temptation* is to invent one. An observation
format with a `selected_clause` field would look more rigorous and would score J2 against a
fiction: J2 could implement branch selection perfectly and still "diverge" on a field the
subject language does not have. `NORMATIVE-OBSERVATION-FORMAT-0` §4.8 therefore defines no such
field and plants the temptation as a divergence category (PD-12).

**Cure class: C** (declare the indirect witness sufficient at /0, in writing) — **or**, if a
direct witness is wanted, that is *grammar growth* and belongs to a future lane, not to a
format.
**Severity: S3**, with a standing warning that the cure must not be to invent the observable.

---

## 2. Roll-up

**28 entries** (SD-01 … SD-28). By **primary** cure class: **A (public-doc amendment) — 18** ·
**B (new normative sentence) — 8** · **C (deliberately non-normative) — 2**. By **primary**
severity: **S1 — 7** · **S2 — 11** · **S3 — 10**.

*(Counted over the entries above; four entries name an alternative class as well as a primary
— SD-12, SD-15, SD-16, SD-17 — and are counted once, under the primary. Several entries carry
a conditional severity, e.g. "S1 without the Act Oracle Interface, S3 with it"; those are
counted at their primary. **The counts are a shape, not a score** — a single S1 is enough to
make a clean-room conformance claim unsafe, and three of the seven are unpublished tables.)*

**Disposition status as of ERRATUM-1 (2026-08-12; arithmetic shown, recounted after the
edits above):** 28 entries = **1** DISPOSED BY SCOPED EXCLUSION, NOT CURED BY PUBLICATION
(SD-13) + **3** CURED-BY-PARCEL-A, discharged per D-3 (SD-05, SD-06, SD-20) + **24** with no
disposition recorded in this register (1 + 3 + 24 = 28).

**Disposition status as of ERRATUM-3 (2026-08-12, upon Parcel 2 (R1) acceptance; recounted):**
28 = **1** SD-13 (excluded, not cured) + **3** CURED-BY-PARCEL-A + **5** CURED-BY-PARCEL-2
(SD-08, SD-02, SD-14, SD-07, SD-22) + **1** PARTIALLY CURED (SD-01, datatype half) + **1**
FLAGGED-PRESERVED (SD-04) + **3** AOI-relieved (SD-03, SD-28, SD-26) + **8** open S2
(SD-15, SD-18, SD-19, SD-25, SD-21, SD-12, SD-10, SD-23) + **6** open S3 (SD-16, SD-17,
SD-24, SD-09, SD-11, SD-27) — 1+3+5+1+1+3+8+6 = 28 ✓. **Surviving scope-invariant S1 set:
SD-01 (vocabulary half) + SD-04 (flagged).** Full disclosure:
`SPEC-DEFICIT-REGISTER-ERRATUM-3.md`.

**Disposition status as of ERRATUM-4 (2026-08-12, upon Parcel 3 (R1) acceptance; recounted):**
28 = **1** SD-13 (excluded, not cured) + **3** CURED-BY-PARCEL-A + **5** CURED-BY-PARCEL-2
+ **1** FULLY CURED BY PARCELS 2+3 (SD-01) + **1** CURED-BY-PARCEL-3 (SD-23) + **1**
FLAGGED-PRESERVED (SD-04) + **3** AOI-relieved + **7** open S2 (SD-15, SD-18, SD-19,
SD-25, SD-21, SD-12, SD-10) + **6** open S3 — 1+3+5+1+1+1+3+7+6 = 28 ✓. **Surviving
scope-invariant S1 set: SD-04 (flagged) — exactly one.** Full disclosure:
`SPEC-DEFICIT-REGISTER-ERRATUM-4.md`.

**Disposition status as of ERRATUM-5 (2026-08-12, upon the owner's SD-04 disposition;
recounted):** 28 = **1** SD-13 (excluded, not cured) + **3** CURED-BY-PARCEL-A + **5**
CURED-BY-PARCEL-2 + **1** FULLY CURED BY PARCELS 2+3 (SD-01) + **1** CURED-BY-PARCEL-3
(SD-23) + **4** AOI-relieved (SD-03, SD-28, SD-26, SD-04★ — ★not cured; live outside an
AOI-supplied boundary) + **7** open S2 + **6** open S3 — 1+3+5+1+1+4+7+6 = 28 ✓.
**Surviving scope-invariant S1 set: EMPTY — zero.** Full disclosure:
`SPEC-DEFICIT-REGISTER-ERRATUM-5.md`.

The shape counts in the opening roll-up paragraph of this
section (A=18 / B=8 / C=2; S1=7 / S2=11 / S3=10) describe the register **as drafted,
2026-08-10**, and stand as documentary history. Severity movements ruled by the Opening
Disposition Instrument /0 on this register's own conditionals (SD-03, SD-26, SD-28, and
SD-04's flag) are recorded in that instrument and the campaign census — they are
deliberately NOT re-scored here, because re-scoring is outside D-6's authorized erratum
scope.

### The three most serious

1. **SD-13 — One Act /0 has no public specification in the published tree.** The constituent
   act's entire semantics live in `_staging/oneact-candidate/` at the repo root, outside the
   mirrored subject tree, while the lane's own sources cite that contract by section number.
   This is not an underdetermination; it is an absence, and it is the reason the Act Oracle
   Interface is *forced* rather than merely chosen.
2. **SD-08 — the datum-ingestion rule is Common Lisp `read`, unwritten.** The packet says
   "one form," "`*read-eval*` NIL," "the program namespace," "UTF-8," and then delegates the
   entire token grammar to an unnamed standard. Its sharpest consequence, **SD-14**, is not an
   edge case: it fires on *every* program-authored refusal code, because the source says
   `:unexpected` and the observable says `UNEXPECTED`.
3. **SD-01 — no published refusal-code table, and the codes' datatype is unstated.** Thirty-one
   codes exist; zero are published as a set; a condition code is a **string** while a program
   refusal code is a **keyword**, and the public texts call both "code". The register's own
   sharpest small finding sits here: **`V-ATOMS` is a published law with no observable code**,
   so a J2 that followed the published law would diverge from the implementation by obeying it.

### What this register cannot tell you

It cannot tell you that the list is complete. It is the yield of one pass by one reader over
four public documents and five implementation files, with the predecessor lanes read only at
their boundaries. Two known blind spots, named rather than left implicit:

- **The predecessor stack was not audited.** Surface /2's derivation law, Capability /0//1//2,
  and Journal /0 were read only where Many Acts /0 touches them. Their own public-text
  sufficiency is unexamined here.
- **`act0.lisp` (1,716 lines) and `act0-gates.lisp` (1,106) were not read line by line.** SD-13
  says their *specification* is unpublished; it does not enumerate what that specification
  would have to contain. That enumeration is a separate commission.

**An entry appearing here is a claim about the public texts, not an accusation about the
implementation.** Every behavior registered above is, as far as this pass can tell, correct,
deliberate, and well-commented in its source. The defect is that the comment is in the source.

---

*— drafted by NOTARIUS (Claude Opus), commissioned by the chair (Claude Fable 5), 2026-08-10*
