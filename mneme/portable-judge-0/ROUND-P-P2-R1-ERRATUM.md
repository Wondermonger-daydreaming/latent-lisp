# PortJ/0 — ROUND P **P2-R1 ERRATUM** (the bounded documentary repair ordered by OWNER RULING 5 §1)

**CANDIDATE — NOT adopted, NOT merged, NOT published, NOT closed. 2026-08-10. Chair: Claude
Fable 5. Second repair hand: RECENSOR-II (Claude Opus).**

> **THE CEILING, FIRST.** Owner Ruling 5 §1, verbatim:
>
> > **Round P remains open, candidate, unadopted, unpublished, and earns zero evidence.**
>
> Nothing below adopts the bank, makes any vector scorable, activates the Act Oracle envelope,
> establishes portability, or earns evidence. **This erratum corrects documentary statements
> about documents. It corrects no number of the counting ruling, because the owner verified the
> mathematics independently and it passed.**

**WHAT THIS DOCUMENT IS.** Owner Ruling 5 §1 ordered: *"Preserve commit `846b79c8` and this
submitted parcel unchanged. Produce a successor containing only these repairs."* This erratum is
that successor for corrections **2–6** as they fall in documents that are **not** reissued;
correction **1** (the missing bundle) is discharged in the P2-R1 parcel and reported in §7 below;
and a **full successor of one document** — `ROUND-P-REPAIR-RETURN-P2R1.md` — carries every
correction whose locus lies inside `ROUND-P-REPAIR-RETURN.md` applied in place.

**WHAT IT IS NOT.** It is not a reissue of `VECTOR-CLASSIFICATION-CANDIDATE-P2.md`,
`ROUND-P-RETURN-P2.md`, or `PROTOCOL-CHARTER-CROSSREF-P2.md`. **Those three are not edited, not
withdrawn, and not forked.** They stand as the submitted parcel's text; their defective
self-descriptions are corrected *here*, by redline, so that the corrected reading is a matter of
record without the audited bytes moving. **Commit `846b79c8` and parcel
`40e49c0fb5e5d157c5c294caf9e6e8d8719e21c0e33b97a96815d527e551ff1c` (99,403 bytes) are preserved
unchanged, as ordered.**

**Citation convention.** Every BEFORE quotation is verbatim from the file **as committed at
`846b79c8`** (verified: the four working-tree files are byte-identical to their committed blobs
`f6f26bfc`, `4796e6b0`, `dffc398c`, `40aa6b29`). Line numbers are the committed line numbers.

**Short names.** **VC-P2** = `VECTOR-CLASSIFICATION-CANDIDATE-P2.md`; **RPR** =
`ROUND-P-REPAIR-RETURN.md`; **RPR-P2R1** = its successor, `ROUND-P-REPAIR-RETURN-P2R1.md`;
**RET-P2** = `ROUND-P-RETURN-P2.md`; **CROSSREF** = `PROTOCOL-CHARTER-CROSSREF-P2.md`.

---

## 0. The six corrections, and where each one landed

| Ruling 5 §1 item | Loci found | Corrected in |
|---:|---|---|
| **1** restore the missing bundle | the P2 parcel carried `REPLAY.txt` step 1 for `round-p-p2.bundle`; no bundle, no manifest line | the **P2-R1 parcel** (`reconstruction/round-p-p2.bundle` + `BUNDLE-PROOF.txt`); reported §7 |
| **2** unresolved-item arithmetic | **RPR §5** (line 165) | **RPR-P2R1 §5** · redline §2 |
| **3** the repair's self-counts | **VC-P2 §P2.0** (line 48) · **CROSSREF §3** (lines 117, 141) · **RPR §3** (line 71) | **RPR-P2R1 §3** for its own locus · redlines §3 for the rest |
| **4** carry-forward description | **RPR §2** (line 45) · **VC-P2 §P2.0** (lines 48–50) | **RPR-P2R1 §2** · redline §4 |
| **5** the false *"never a bare `156`"* | **RPR §3** (lines 77–78) · **VC-P2 §P2.1** (lines 211–213) | **RPR-P2R1 §3** · redline §5 |
| **6** historical status captures | **RPR §4.3** (lines 156–158) · **RET-P2 §3** (line 192) · **RPR §5/§7** (lines 242, 267) | **RPR-P2R1 §4.3, §5, §7** · redline §6 |

**One locus was found that the ruling does not name.** It is reported in §4.3 below, not repaired
beyond being enumerated: **VC-P2 §7.1 contains a modified table row** (P1 line 701 → P2 line
1062), so §7 is not among the sections carried wholly unaltered either. It was found by running
the diff the ruling ordered rather than by reading the claim.

---

## 1. Correction 1 in one line, so the reader is not left hunting

`round-p-p2.bundle` **exists, is manifested, and is proven** in the P2-R1 parcel. Its proof —
creation with exit code shown, `git bundle verify`, a fetch into a repository that did **not**
contain `846b79c8`, and a byte-comparison of `git diff 846b79c8^ 846b79c8` against `p2.patch` —
is the full transcript at `reconstruction/BUNDLE-PROOF.txt`. **One limit is stated at its true
size in §7 and is not smoothed:** the bundle carries a **prerequisite**, so the empty-repository
form of the ruling's sentence is discharged **partially**, for a physical reason that is measured
rather than asserted.

---

## 2. CORRECTION 2 — the unresolved-item arithmetic

**Ruling 5 §1 item 2.** *"Replace 'Seventeen remain open' with: …"*

**Locus: `ROUND-P-REPAIR-RETURN.md` §5, line 165.**

**BEFORE** (verbatim, lines 162–165):

> **Ruling item 6:** *"preserve every remaining unresolved item as unresolved, including NOF
> activation and all Parcel-B-dependent law."* The audit parcel's `UNRESOLVED.md` carried **22
> items in 8 groups**. **Owner Ruling 3 §2 resolved four of them and ordered a fifth's
> cross-reference half repaired. Seventeen remain open, and nothing else was touched.**

**AFTER** (the owner's replacement sentence, verbatim, in place of the bolded final sentence):

> **Ruling item 6:** *"preserve every remaining unresolved item as unresolved, including NOF
> activation and all Parcel-B-dependent law."* The audit parcel's `UNRESOLVED.md` carried **22
> items in 8 groups**. **Owner Ruling 3 fully closed U-1, U-3, U-4, and U-21; discharged the
> counting half of U-2; and ordered and discharged the cross-reference half of U-19. Eighteen
> numbered items retain open residue: U-2, U-5–U-20, and U-22.** Nothing else was touched.

**The count checked against the document's own list, not against the sentence.** RPR §5's
STILL-OPEN enumeration names, in order: U-2 (second half) · U-5 · U-6 · U-7 · U-8 · U-9 · U-10 ·
U-11 · U-12 · U-13 · U-14 · U-15 · U-16 · U-17 · U-18 · U-19 (residual) · U-20 · U-22 — **1 + 16
+ 1 = 18 items, every one of them present in the frozen text.** The owner's own words apply:
*"The underlying eighteen are already present; none was lost."* The defect was in the **tally
sentence only**; the list beneath it was right. The arithmetic that produced "seventeen" is
recoverable and worth naming so it is not repeated: **U-2 was counted once as *resolved* (its
counting half) and then not counted again as *open* (its instrument half)** — a single item
living on both sides of the ledger, subtracted from the open column but still standing in it.

---

## 3. CORRECTION 3 — the self-counts

**Ruling 5 §1 item 3.** *"'Six changes' → **seven required items**; 'Three further owner-licensed
sentences' → **five further listed text units**; the cross-reference check covers **seven listed
text units total**: H, G, N, P, I, D, and the final unlettered clause."*

### 3.1 "Six changes" → seven required items

**Locus: `VECTOR-CLASSIFICATION-CANDIDATE-P2.md` §P2.0, lines 48–50.**

**BEFORE** (verbatim):

> **Six changes, each traceable to a numbered item of the ruling's "Required P repair"; nothing
> else in this document moved.** Every carried section below (§0–§3, §6–§8, and the whole of
> §4.1) is the `-P1` text unaltered.

**AFTER** (this sentence also carries correction 4 — see §4.2; the count half only, here):

> **Seven required items, each traceable to a numbered item of the ruling's "Required P
> repair."**

**Why seven.** The table that immediately follows the sentence has **seven numbered rows** —
items 1 through 7 of Owner Ruling 3 §2's "Required P repair" — and RPR §1's own item-by-item
table likewise runs **1 to 7**. The word "six" was never true of either table; it is a count of
the ruling's items that stopped one short of the table printed under it.

### 3.2 "Three further owner-licensed sentences" → five further listed text units

**Locus: `PROTOCOL-CHARTER-CROSSREF-P2.md` §3, line 117.**

**BEFORE** (verbatim):

> **Three further owner-licensed sentences, checked the same way — all present in both documents
> and identical after the same normalization:**

**AFTER:**

> **Five further listed text units, checked the same way — all present in both documents and
> identical after the same normalization:**

**Verified against the document's actual lettering, as ordered.** The table under that sentence
has **five rows**, lettered and labelled exactly as the ruling describes:

| # | Row label as printed in CROSSREF §3 | Charter | Protocol |
|---:|---|---|---|
| 1 | **N** — *must never be shortened to "an independent Lisp+ implementation exists."* | 1.PL.4 | §1.1 |
| 2 | **P** — *PortJ-F/0 cannot open until the predecessor stack's normative law is publicly sufficient.* | 1.PF.2 | §1.2 |
| 3 | **I** — *PortJ-L/0 is an intermediate theorem, not a permanent decision…* | 1.PF.3 | §1.2 |
| 4 | **D** — *does not constitute a second implementation of the complete Lisp+ judge or Mneme runtime.* | 1.PL.6 | §1 |
| 5 | **—** *(printed with an em-dash in the label column, i.e. **unlettered**)* — *without invention, oracle mediation, or consultation of implementation source in at least twenty-eight registered places.* | 1.PF.2 | §1.1 |

With **H** and **G** from the table above it, the check covers **seven listed text units: H, G,
N, P, I, D, and the final unlettered clause** — the ruling's enumeration confirmed row for row
against the file's own bytes. **The fifth row is genuinely unlettered in the source**; the ruling
describes it precisely.

### 3.3 A third instance of the same undercount, in the same check

**Locus: `PROTOCOL-CHARTER-CROSSREF-P2.md` §3, line 141.**

**BEFORE** (verbatim):

> **Honest limit of this check.** It verifies the **five sentences named above**, no others.

**AFTER:**

> **Honest limit of this check.** It verifies the **seven listed text units named above** (H, G,
> N, P, I, D, and the final unlettered clause), no others.

*Reported because it is the same defect the ruling names, at a second locus inside the same
check: the honest-limit sentence undercounts the check's own coverage in the same direction (2
lettered + 3 assumed further = 5, where the table prints 2 + 5 = 7). The limit stated is
narrower than the work actually done, so the error runs toward under-claiming; it is corrected
for accuracy, not because the check over-reached.*

### 3.4 A fourth instance, in the repair return itself

**Locus: `ROUND-P-REPAIR-RETURN.md` §3, line 71** (derivations index, final row).

**BEFORE** (verbatim, the "Where derived" cell of the `licensed-sentence hashes` row):

> raw and normalized sha256 for the hypothesis and the green sentence, plus four further shared
> sentences

**AFTER:**

> raw and normalized sha256 for the hypothesis (H) and the green sentence (G), plus **five
> further listed text units** — **seven in total**

*Applied in place in `ROUND-P-REPAIR-RETURN-P2R1.md` §3.* Four wrong numbers were printed for one
five-row table across two documents ("three", "four", and twice "five" for the seven-unit total);
**the table itself was correct throughout, and no hash, no sentence, and no verification result
is affected by any of them.**

---

## 4. CORRECTION 4 — the carry-forward description

**Ruling 5 §1 item 4.** *"Do not claim §§0–3 or §6 were carried wholly unaltered: §3.3 contains
the ordered percentage correction, while §6 contains the ruled C-7/C-8 rows and severity-total
correction. Enumerate the actual modified loci and call only unaffected passages byte-identical."*

**The enumeration below was produced by diffing `-P1` against `-P2` line by line — not by reading
either document's claim about itself.** The replay is in §4.4.

### 4.1 Locus 1 — the repair return's supersession table

**Locus: `ROUND-P-REPAIR-RETURN.md` §2, line 45** (the `VECTOR-CLASSIFICATION-CANDIDATE-P2.md`
row, "Scope of the supersession" cell).

**BEFORE** (verbatim):

> **the counting axis only.** §§0–3 (method, classification, layer tagging), §4.1 (the 188 base),
> §4.3 (the static-reading caveat), §6 (contamination families and staleness S1–S6), §7 (the
> Ruling-6 both-worlds table and the two inverting reclassifications) and §8 (hidden-bank
> checklist) are the `-P1` text carried unaltered

**AFTER** (as applied in `ROUND-P-REPAIR-RETURN-P2R1.md` §2):

> **the counting axis, plus six further loci the ruling ordered or licensed.** **Modified:** the
> title line and header block; **§3.3** (the ordered `43%`→`47.8%` correction, plus an appended
> `[P2]` retired-figure note); **§4.2** (heading, removal table and net-bank totals replaced by
> the ruled account); the **§5 heading**; **§6 SEVERITY 2** (the ruled C-7 and C-8 rows) with an
> appended severity-total note at the end of the SEVERITY 3 block; and **§7.1** (one table row
> gains an appended `[P2]` sentence). **Added without altering any carried line:** §P2.0–§P2.2,
> §5.4, §9, `[P2]` notes in §5, §5.1, §5.2, §5.3, and the second signature line. **Byte-identical
> passages** — and only these are called byte-identical — are enumerated in §2.1 of this return.

### 4.2 Locus 2 — the document's own claim about itself

**Locus: `VECTOR-CLASSIFICATION-CANDIDATE-P2.md` §P2.0, lines 49–50** (the second half of the
sentence redlined in §3.1 above).

**BEFORE** (verbatim):

> Every carried section below (§0–§3, §6–§8, and the whole of §4.1) is the `-P1` text unaltered.

**AFTER:**

> The carried sections are `-P1` text; the loci this repair modified are §3.3, §4.2, the §5
> heading, §6's SEVERITY 2 rows, and one row of §7.1, together with the title and header. **Only
> the passages enumerated in the P2-R1 erratum §4.3 are byte-identical.**

### 4.3 The actual modified loci, enumerated — and the byte-identical passages, named as such

**Thirteen replacements (existing text altered) and eleven insertions (nothing altered), against
`-P1`:**

| # | `-P1` lines | `-P2` lines | Section | What changed | Ordered by |
|---:|---|---|---|---|---|
| 1 | 1 | 1 | title | *"Round P revision"* → *"Round P **repair** revision — P2"* | successor identity |
| 2 | 3–9 | 3–29 | header block | header restated for the repair; ceiling and designation carried | successor identity |
| 3 | 390–391 | 595–597 | **§3.3** | *"the lane's flagship scenario bank is 43 % language-layer"* → *"…is 43 of 90 = 47.8 % LANG"* | **Ruling 3 §2 item 3** |
| 4 | 488–513 *(6 ops)* | 705–764 | **§4.2** | heading retitled `[P2 · RULED]`; the 26-removal table and the `162`/`161` net totals replaced by the ruled `188−19−9−4` account and the per-bank re-tally | **Ruling 3 §2 items 1, 2** |
| 5 | 543 | 794 | **§5 heading** | *"— **[P2] ALL THREE NOW RULED**"* appended | Ruling 3 §2 items 1–4 |
| 6 | 656–657 | 1010–1011 | **§6 SEVERITY 2** | the **C-7** row (4 → **9**, with all nine lines named) and the **C-8** row (3 → **4**, lines 867/888/889/901) rewritten to the ruled magnitudes | **Ruling 3 §2 item 2** |
| 7 | 701 | 1062 | **§7.1** | the `C-7 · C-8 · C-9 · C-10 · C-11` row gains an appended `[P2]` sentence recording that the ruling changed the magnitudes and **not** the families' status | **not named in Ruling 5 §1 item 4 — see the note below** |

| # | `-P2` lines | Section | Inserted |
|---:|---|---|---|
| 1 | 43–227 | **§P2.0 · §P2.1 · §P2.2** | the whole ruled-membership block |
| 2 | 603–613 | §3.3 | `[P2]` retired-figure note (the `43%` retirement + attribution) |
| 3 | 800–815 | §5 preamble | `[P2]` ruled note |
| 4 | 817–821 | §5.1 | `[P2]` ruled note |
| 5 | 859–866 | §5.1 tail | `[P2]` ruled note |
| 6 | 868–874 | §5.2 | `[P2]` ruled note |
| 7 | 898–911 | §5.3 | `[P2]` ruled note |
| 8 | 933–985 | **§5.4** | the retirement of `149`, new subsection |
| 9 | 1026–1032 | §6, end of SEVERITY 3 | `[P2]` **severity-total** note (10 → 16) |
| 10 | 1158–1170 | **§9** | closing, new section |
| 11 | 1174–1175 | signature | the RECENSOR signature line |

**Byte-identical passages — and only these may be called byte-identical.** Fourteen maximal
blocks, **766 of `-P1`'s 799 line-slots** (33 `-P1` lines were altered; none was deleted):

| `-P1` lines | `-P2` lines | lines | sha256[16] of the block |
|---|---|---:|---|
| 10–22 | 30–42 | 13 | `2eba8b3c74557cb5` |
| 23–389 | 228–594 | 367 | `4d387d7d23bccc13` |
| 392–396 | 598–602 | 5 | `cc480568184ce4ad` |
| 397–487 | 614–704 | 91 | `6c815a47f5b207f8` |
| 514–542 | 765–793 | 29 | `b48bd41b4b704cd8` |
| 544–548 | 795–799 | 5 | `5af00cf9a6c27317` |
| 550–586 | 822–858 | 37 | `1dff942f8476cc13` |
| 588–610 | 875–897 | 23 | `aa1700a7dcc31a4d` |
| 611–631 | 912–932 | 21 | `97fc54b09b5bc5c7` |
| 632–655 | 986–1009 | 24 | `f6e00a3382f840f7` |
| 658–671 | 1012–1025 | 14 | `06c8c35a80520146` |
| 672–700 | 1033–1061 | 29 | `27e0f82abac1c2fb` |
| 702–796 | 1063–1157 | 95 | `29066fc33e681086` |
| 797–799 | 1171–1173 | 3 | `ce73d8b813d3daa9` |

In section terms, the passages carried byte-identical are: **§P.0 · §0 · §1 · §2 with §2.1–§2.4 ·
§3 preamble · §3.0 · §3.1 · §3.2 · §3.4 · §3.5 · §4 preamble · §4.1 · §4.3 · §5.1–§5.3 base text
· §6 preamble · SEVERITY 1 · SEVERITY 3's own rows · the Staleness subsection · §7 preamble ·
§7.2 · §7.3 · §8's body** (`-P1` 742–793 = `-P2` 1103–1154), **and the naming-collision
blockquote and counting-law paragraph of the header region.** Sections that received an insertion
(§5, §5.1, §5.2, §5.3, §6) are **not** byte-identical as sections even though no carried line in
them was altered — the distinction is kept because collapsing it is how the original claim went
wrong.

> **THE LOCUS THE RULING DOES NOT NAME, REPORTED AND NOT IMPROVISED ON.** Ruling 5 §1 item 4
> names **§3.3** and **§6** as the counter-examples to "carried wholly unaltered." The diff finds
> a **third**: **§7.1, `-P1` line 701 → `-P2` line 1062.** The `-P1` row read:
>
> > | **C-7 · C-8 · C-9 · C-10 · C-11** substrate magnitudes | **REMAIN CONTAMINATED REGARDLESS.** These are the SUBSTRATE-DEP class; their cure is **[SD-13]** — a public One Act /0 specification — and they belong to **PortJ-F/0**, which is not open. Ruling 6 moves none of them. | REMAIN CONTAMINATED. |
>
> and `-P2` appends to it:
>
> > **[P2] Owner Ruling 3 §2 changed C-7's magnitude (4 → 9) and C-8's (3 → 4); it changed
> > neither family's STATUS. Both remain contaminated in both worlds, and the ruled counts are
> > not a step toward their cure.**
>
> **The addition is conservative** — it records that the ruling moved magnitudes and not status,
> which is the anti-inflation reading, and it changes no verdict in the both-worlds table. **It
> is nonetheless a modification of `-P1` text inside §7**, so both the RPR §2 claim and the
> VC-P2 §P2.0 claim were wrong about §7 as well as about §3.3 and §6. It is enumerated here at
> the size the diff gives it. **No further disposition is proposed; the erratum records, it does
> not legislate.**

### 4.4 Replay — how the enumeration above was produced

```
cd experiments/latent-lisp/mneme/portable-judge-0
python3 - <<'PY'
import difflib, hashlib
a = open('VECTOR-CLASSIFICATION-CANDIDATE-P1.md', encoding='utf-8').read().split('\n')
b = open('VECTOR-CLASSIFICATION-CANDIDATE-P2.md', encoding='utf-8').read().split('\n')
sm = difflib.SequenceMatcher(None, a, b, autojunk=False)
for i, j, n in sm.get_matching_blocks():
    if n >= 3:
        h = hashlib.sha256('\n'.join(a[i:i+n]).encode()).hexdigest()[:16]
        print(f"IDENTICAL  P1 {i+1}-{i+n}  ==  P2 {j+1}-{j+n}  ({n} lines)  {h}")
for tag, i1, i2, j1, j2 in sm.get_opcodes():
    if tag != 'equal':
        print(f"{tag.upper():8s}  P1 {i1+1}-{i2}  ->  P2 {j1+1}-{j2}")
print("matched line-slots:", sum(n for _, _, n in sm.get_matching_blocks()),
      "of", len(a))
PY
```

Obtained: **14 identical blocks ≥3 lines · 13 REPLACE ops · 11 INSERT ops · 0 DELETE ops ·
766 matched line-slots of 799.**

---

## 5. CORRECTION 5 — the false *"never a bare `156`"* claim

**Ruling 5 §1 item 5.** *"Remove the false 'never a bare `156`' claim. Bare shorthand occurrences
exist later in the documents. State instead that the governing membership declaration is
disambiguated by `188−19−9−4`, with later shorthand referring back to it."*

### 5.1 Locus 1 — the repair return

**Locus: `ROUND-P-REPAIR-RETURN.md` §3, lines 76–78.**

**BEFORE** (verbatim):

> This is why every successor writes **exact membership 156 (188 − 19 − 9 − 4)** at first use and
> never a bare `156`.

**AFTER** (as applied in `ROUND-P-REPAIR-RETURN-P2R1.md` §3):

> This is why the **governing membership declaration** in each successor reads **exact membership
> 156 (188 − 19 − 9 − 4)**: the decomposition is what fixes the interpretation and both
> magnitudes, and therefore the membership. **Later occurrences of the bare numeral are
> shorthand referring back to that declaration, not independent claims** — they carry the
> disambiguation by reference, not by repetition.

### 5.2 Locus 2 — the classification document

**Locus: `VECTOR-CLASSIFICATION-CANDIDATE-P2.md` §P2.1, lines 211–213.**

**BEFORE** (verbatim):

> **This is why every citation of the number in this document reads *exact membership
> 156 (188 − 19 − 9 − 4)* and never a bare `156`.**

**AFTER:**

> **This is why the governing declaration of the number in this document reads *exact membership
> 156 (188 − 19 − 9 − 4)*; later bare occurrences of the numeral are shorthand referring back to
> that declaration.**

### 5.3 The claim was false, and here is the evidence rather than the concession

Counted, not asserted (`grep -n '156'` over the three documents as committed at `846b79c8`).
**Bare occurrences exist in all three:**

| Document | Bare-shorthand occurrences (line numbers) |
|---|---|
| **VC-P2** | 184 (*"which is what makes **156** a"*), 219 (*"156 is the size of a candidate list"*), 730 (*"every one of the 156"*), 744 (*"`-P2` at 156"*), 751 (*"= 156"*), 953 (*"`156` is a set"*), 982 (*"does not make 156 adopted, does not make any of the 156"*) |
| **RPR** | 235 (*"It is not inside the 156"*) |
| **RET-P2** | 41 (*"The exact membership is 156"*), 56, 65, 174, 187 |

*(Line 999 of VC-P2 also contains the string `156` — `ma0-eval.lisp:40,156,160,300` — which is a
source line number, not the cardinality; it is excluded from the table above rather than counted
to inflate the finding.)*

**Why the false claim mattered enough to rule on.** The disambiguation is real: a bare `156` is
reachable under `(I-3, C-8=4)` and under `(I-4, C-8=3)` with **different membership**, and the
documents say so. What the documents cannot honestly say is that they **never** print the bare
numeral — a claim of a textual universal, falsified by the text's own body, in the same paragraph
that argues the number must not travel undisambiguated. **The owner's formulation is stronger
than the false one**: it makes the governing declaration do the work, and lets the shorthand be
shorthand.

---

## 6. CORRECTION 6 — the historical status captures

**Ruling 5 §1 item 6.** *"Label 'No commit was made and nothing was pushed' explicitly as
RECENSOR's pre-commit handoff capture. Likewise mark the Parcel-A/B table as the state at
`846b79c8`; Ruling 4 has since superseded that procedural status. **Do not rewrite the historical
command output.**"*

**The instruction's own constraint governs every redline in this section: nothing is altered
inside a command block. Labels are added beside them.**

### 6.1 The push-state capture

**Locus: `ROUND-P-REPAIR-RETURN.md` §4.3, lines 149–158.**

**BEFORE** (verbatim; the command block and its output are shown here only to fix the locus —
**they are not changed**):

> ```
> $ git status --porcelain -- experiments/latent-lisp/mneme/portable-judge-0/
> ?? experiments/latent-lisp/mneme/portable-judge-0/PROTOCOL-CHARTER-CROSSREF-P2.md
> ?? experiments/latent-lisp/mneme/portable-judge-0/ROUND-P-RETURN-P2.md
> ?? experiments/latent-lisp/mneme/portable-judge-0/VECTOR-CLASSIFICATION-CANDIDATE-P2.md
> ```
>
> **Four new untracked files and not one modification.** *(This return is the fourth; it is
> created last, so it appears in the tree alongside the three above.)* No commit was made and
> nothing was pushed — the chair commits.

**AFTER** (as applied in `ROUND-P-REPAIR-RETURN-P2R1.md` §4.3 — **command block byte-identical**,
label added to the prose that follows it):

> **Four new untracked files and not one modification.** *(This return is the fourth; it is
> created last, so it appears in the tree alongside the three above.)*
>
> **[P2-R1 LABEL — HISTORICAL CAPTURE, NOT A CURRENT STATE.]** The sentence *"No commit was made
> and nothing was pushed — the chair commits"* is **RECENSOR's pre-commit handoff capture**: it
> records the working tree at the moment the repair hand finished and handed off, **before** the
> chair committed. **The chair subsequently committed the four files as `846b79c8`.** The command
> output above is the historical record of that moment and is **not** rewritten.

### 6.2 The Parcel-A/B status

**Locus (table): `ROUND-P-RETURN-P2.md` §3, line 192** (final rows of "Owner dispositions to
date").

**BEFORE** (verbatim, the Parcel A row):

> | **Parcel A** *(separate; not bundled with this repair, by order)* | fit with bounded repair; not yet mergeable; **Parcel B remains closed until it returns and is accepted** | Owner Ruling 3 §4 |

**AFTER** (recorded here; **RET-P2 is not reissued**, so this label lives in the erratum):

> **[P2-R1 LABEL — STATE AT `846b79c8`, PROCEDURALLY SUPERSEDED.]** The whole of RET-P2 §3
> ("Owner dispositions to date") is **the disposition board as it stood at commit `846b79c8`**,
> and the Parcel A row is accurate **as of that commit only**. **Owner Ruling 4 has since
> superseded that procedural status: Parcel A was ACCEPTED and integrated at merge `b40bfc33`,
> and Owner Ruling 5 §3 authorized Parcel B to convene** (jurisdiction restricted to the eight
> enumerated handoff items). **Nothing in the counting dispositions of that table is affected** —
> C-7, C-8, the cardinality, the scenario-bank statement and the zero-evidence row stand exactly
> as ruled.

**Two further statements of the same superseded procedural status, inside the reissued document:**

| Locus | BEFORE (verbatim) | AFTER (in `ROUND-P-REPAIR-RETURN-P2R1.md`) |
|---|---|---|
| **RPR §5**, line 242 | *"**Parcel B is closed until the Parcel A bounded repair returns and is accepted** (Owner Ruling 3 §4), and this repair is independent of it by order."* | same sentence, followed by **[P2-R1 LABEL — state at `846b79c8`]**: Parcel A returned and was accepted (Ruling 4; merge `b40bfc33`), and **Ruling 5 §3 authorized Parcel B to convene**, restricted to the eight enumerated handoff items. **The substantive point is untouched: Ruling 6 remains unadopted candidate law, and every Parcel-B-dependent item stays open.** |
| **RPR §7**, line 267 | *"**Not bundled with Parcel A**, by order; **Parcel B stays closed** until Parcel A's bounded repair returns and is accepted."* | same sentence, followed by **[P2-R1 LABEL — state at `846b79c8`]**: the non-bundling order still binds (Ruling 5 §3: *"P2 and B must not be bundled"*); the "Parcel B stays closed" half is superseded — B is authorized to convene. |

**One further capture in the same class, labelled for the same reason.** RPR §7's closing line
*"Awaiting owner disposition of this repair"* was true when written and has been overtaken:
**Owner Ruling 5 §1 disposed of it as FIT WITH BOUNDED REPAIR — not yet accepted or closed.** The
successor labels it rather than deleting it, so the sequence of dispositions stays legible.
*(This label is the one item in §6 not named in the ruling's sentence; it is the same defect-class
the ruling is correcting — a status capture that a later ruling overtook — and leaving it silent
in a document dated after Ruling 5 would print a new untruth. Reported, not enlarged.)*

---

## 7. CORRECTION 1 — the bundle, and the one limit that is not smoothed

**Ruling 5 §1 item 1.** *"`REPLAY.txt` commands verification of `round-p-p2.bundle`, but the
archive contains no bundle and manifests none. Include and manifest a bundle sufficient to fetch
and verify `846b79c8` in an empty repository, then prove its parent diff equals `p2.patch`."*

**The defect is confirmed, and its cause is named.** The P2 parcel's `reconstruction/REPLAY.txt`
step 1 reads *"git bundle verify round-p-p2.bundle"*; the archive contains
`FROZEN-INTACT-PROOF.txt`, `IDENTITIES.txt`, `MANIFEST.sha256`, four artifacts, `REPLAY.txt` and
`p2.patch` — **eight manifest lines, no bundle.** The chair has stated that its packing script
swallowed the bundle step in a `2>/dev/null ||` chain that failed both branches unchecked. **A
suppressed exit code is how an artifact goes missing while every visible check stays green** —
which is why the P2-R1 parcel's bundle proof shows **every** command's exit status and suppresses
no stream.

**Discharged in the P2-R1 parcel:**

| What | Where | Result |
|---|---|---|
| the bundle exists | `reconstruction/round-p-p2.bundle` | 57,397 bytes, sha256 `8383656a…` — **manifested**, and the manifest line is grep-verified present before sealing |
| creation is shown, not claimed | `reconstruction/BUNDLE-PROOF.txt` | `git bundle create` with **exit code printed**, no stderr suppression |
| the bundle carries `846b79c8` | same | `git bundle list-heads` → `846b79c8… refs/heads/round-p-p2` |
| it fetches into a repository that did **not** contain `846b79c8` | same | receiving repo built from the parent commit only; `git cat-file -e 846b79c8` **fails** there before the fetch and succeeds after |
| **its parent diff equals `p2.patch`** | same | `git diff 846b79c8^ 846b79c8` in the receiving repo, **byte-compared** to `p2.patch` (`cmp`, exit 0) |
| `p2.patch` itself is not a re-typed copy | same | regenerated from git and **byte-identical** to the P2 parcel's copy (sha256 `b51f97d1…`) |

**THE LIMIT, STATED AT ITS TRUE SIZE.** The bundle carries a **prerequisite** — its parent
`8e49b5d3…` — so in a **genuinely empty** repository `git bundle verify` reports the missing
prerequisite and the fetch cannot complete. **The empty-repository form of the ruling's sentence
is therefore discharged partially, and it is not claimed as discharged in full.** The reason is
physical and measured, not argued:

```
$ git archive 846b79c8 | wc -c            → 1,334,374,400     (the commit's tree, uncompressed)
$ git rev-list --objects --no-walk 846b79c8 | awk '{print $1}' \
      | git pack-objects --stdout | wc -c → 690,061,673       (that snapshot, packed)
$ echo 846b79c8 | git pack-objects --revs --stdout | wc -c
                                          → 729,097,441       (full history, packed)
```

A bundle with **no** prerequisite must carry the commit's entire tree, because the commit's hash
commits to it — and this commit's tree is the whole lab repository, including multi-megabyte
PDFs, tarballs and generated corpora. **A self-contained bundle for `846b79c8` is ≈0.69 GB**; the
P2 parcel under audit is 99,403 bytes. Shipping a 0.69 GB documentary parcel is not a repair, and
silently shipping a 57 KB bundle while quoting the ruling's sentence back would be worse.
**So: the bundle is included, manifested, and proven to the strongest form the object permits,
and the residual gap is put in front of the owner rather than papered over.** Whether to accept
the prerequisite-bearing bundle, to order the self-contained one at its true size, or to strike
the bundle step from `REPLAY` is the owner's disposition; **RECENSOR-II proposes none of the
three.**

---

## 8. What this erratum does not do

- **It changes no semantics of the counting ruling.** C-7 = 9 · C-8 = 4 · exact membership 156 =
  188 − 19 − 9 − 4 · layers 99/41/16 · `149` retired · `43 of 90 = 47.8 % LANG` — all stand
  exactly as ruled and as the owner independently verified. **No correction here touches a
  number of the mathematics.**
- **It resolves no unresolved item.** The eighteen retaining open residue (U-2, U-5–U-20, U-22)
  are exactly as open after this erratum as before it. NOF activation stays unactivated; every
  Parcel-B-dependent item stays candidate.
- **It edits nothing that was audited.** `846b79c8`, the four P2 documents, the eleven `ba2ffe8b`
  Round-P artifacts, the thirteen frozen court originals and parcel `40e49c0f…` are all
  byte-unchanged — proofs in the P2-R1 parcel's `FROZEN-INTACT-PROOF.txt` and `BUNDLE-PROOF.txt`.
- **It runs no harness, authors no vector, builds no gate, and touches no lane.**
- **It earns nothing.** **Zero PortJ/0 evidence.** Round P remains **open, candidate, unadopted,
  unpublished**.

---

*— repaired by RECENSOR-II (Claude Opus), P2-R1, commissioned by the chair (Claude Fable 5), 2026-08-10*
