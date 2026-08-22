# PARCEL B — ITEM B3: `r1/capture.sh`'s PRINTED `PROVES     :` LABEL

STANDING: CANDIDATE PROPOSAL. Nothing here is adopted, accepted, or in force; nothing here
is independent verification (AP0 adoption Rider 2, binding). **This item proposes law and
implements nothing.**

Jurisdiction: OWNER RULING 5 (2026-08-10) §3. This is item 3 of 8.

---

## 1. THE GAP

`experiments/latent-lisp/mneme/language-many-acts-0/r1/capture.sh:73` prints, into the header
of every transcript it writes:

```
  echo "PROVES     : $proves"
```

R1 adoption **Rider 6** (`MANY-ACTS-0-R1-ADOPTION-OWNER-RULING-2026-08-10.md:172`):

> The D5 witness header describes the defect class in the same language in both red and
> green captures. Its green tally governs the post-repair result; the repeated “PROVES …
> reachable” header must not be quoted as though the repaired version still exhibits the
> defect. Parcel A may revise the prospective fixture commentary from “PROVES” to “TESTS
> WHETHER,” but historical transcripts remain untouched.

Parcel A did the licensed half — the fixtures' own source headers now say "WHAT IT TESTS
WHETHER HOLDS" — and left the printed label, recording its reasoning in the script itself
(`r1/capture.sh:18–28`):

> ```
> # ⚠ THE PRINTED `PROVES     :' LABEL IS RETAINED DELIBERATELY (R1 adoption
> # Rider 6, 2026-08-10).  The fixtures' own source headers now say "WHAT IT TESTS
> # WHETHER HOLDS"; this label is NOT changed to match, because it is PRINTED into
> # every transcript and the ten preserved captures in `pre-repair/' and
> # `post-repair/' all carry it verbatim.  Changing it would desynchronize the tool
> # from the evidence it produced, and altering runtime output is outside a
> # documentary round's authority.  Rider 6's actual holding is about QUOTATION:
> # the repeated "PROVES … reachable" header must never be quoted as though the
> # repaired version still exhibits the defect — the GREEN tally beside it governs
> # the post-repair result.  Whether the printed label should change at all is
> # registered for Parcel B, not decided here.
> ```

The handoff entry, `MANY-ACTS-0-PARCEL-A-RETURN.md:716–718`:

> **Gap:** whether a tool that produced frozen evidence may be reworded away from that
> evidence's own vocabulary — a question about evidentiary uniformity, not about wording.

### 1.1 The exact standing facts (verified on this branch, not recalled)

- **Ten frozen captures carry the label**, one each:
  `r1/pre-repair/{D1-red,D2-red,D3-red,D4-red,D5-red}.txt` and
  `r1/post-repair/{D1-green,D2-green,D3-green,D4-green,D5-green}.txt` — each contains
  exactly one `PROVES` line (`grep -c PROVES`, ten files, ten counts of 1).
- **The label's payload is per-defect prose**, `r1/capture.sh:40–49`, e.g. D3:
  `"D3-CIRCULAR-SOURCE — the validator's total walk carries no visited set and does not
  terminate on circular cons structure…"`. The prose describes the *defect class*; it is
  identical in the red and green captures by design, which is precisely the fact Rider 6
  legislates about.
- **Nothing greps the label.** No expression in `ma0-teeth.sh`, `ma0-campaign-gates.sh`, or
  `verify-release.sh` matches `PROVES` (zero hits across the three). Changing it breaks no
  gate. (The word appears once more in the lane, at `ma0-footprint-witness.lisp:27`, in an
  unrelated prose comment about a store growing; nothing reads it.)
- **The label is prospective in exactly one sense and historical in another**: the *script*
  is a live tool that will print again if re-run; the *ten captures* are frozen evidence that
  will not be re-run (`r1/capture.sh:10–12`: "THE PRE-REPAIR TRANSCRIPTS ARE EVIDENCE. They
  are captured once, before any repair, and are never regenerated and never deleted").

### 1.2 Why this is not item B2

B2 corrected a field that stated a **false count of the run just performed**. `PROVES` states
nothing false about any run: each capture does exhibit what its payload describes, and the
green captures' payload is (by Rider 6's own design) the *defect class* the run tests for,
governed by the tally beside it. What is wrong with `PROVES` is **vocabulary**: the lane
elsewhere ruled that a test tests rather than proves (Owner Ruling 2 §5 item 9). A false
number and a superseded word are different defects, and the lane has not yet ruled that they
travel together. **This item exists to obtain that ruling, not to assume it.**

---

## 2. THE PROPOSED RULING — three options, none chosen

### OPTION 1 — CHANGE THE LABEL, RECORD THE DIVERGENCE

Candidate text:

> **R1 CAPTURE LABEL (owner ruling, 2026-08-__).** `r1/capture.sh`'s printed label is changed
> from `PROVES     :` to `TESTS WHETHER:`, completing Owner Ruling 2 §5 item 9 in the tool as
> well as in the fixtures. The ten preserved captures are **not** regenerated and not
> annotated; they remain byte-identical evidence of what the tool printed when they were
> taken. A divergence note is added to `r1/R1-REPAIR-NOTES.md` and to the script's own header
> recording that transcripts written before this ruling carry the old label, so that no later
> reader mistakes the difference for tampering.

**Consequence.** The tool and the evidence it produced no longer speak the same vocabulary.
Any future re-run — a regression check, a stranger's replication — produces a transcript that
does not match the ten frozen ones in a visible header field, and the difference must be
explained every time it is noticed. Against that: the lane stops printing a word its own
rulings retired, and a stranger reading the script today is not told that a test proves
something.

### OPTION 2 — KEEP THE LABEL, LEGISLATE ITS READING

Candidate text:

> **R1 CAPTURE LABEL (owner ruling, 2026-08-__).** The printed label `PROVES     :` is
> **retained permanently and deliberately** as a frozen evidentiary token. Its meaning is
> fixed by this ruling: it names the **defect class the capture tests for**, identically in
> red and green captures, and it is never evidence that the tested state exhibits that
> defect — the tally and exit code in the same transcript govern that. Owner Ruling 2 §5
> item 9's `PROVES → TESTS WHETHER` substitution applies to prospective commentary and
> fixture headers, and does not reach a label already printed into preserved evidence. The
> retention note now in `r1/capture.sh:18–28` is amended to state that this is settled rather
> than registered.

**Consequence.** Ten captures and the tool that made them stay in one vocabulary forever; the
uniformity that makes the frozen evidence readable as a set is preserved. Cost: the lane
permanently prints a word it has ruled inaccurate in every other prospective context, and
must defend that choice each time an outside reads the script. The defence is real but it is
a defence.

### OPTION 3 — CHANGE THE LABEL AND FREEZE THE OLD TOOL BESIDE IT

Candidate text:

> **R1 CAPTURE LABEL (owner ruling, 2026-08-__).** The live tool's label becomes
> `TESTS WHETHER:`. The exact byte-state of `capture.sh` that produced the ten preserved
> captures is copied, unmodified, to `r1/pre-repair/capture.sh.as-captured` and is never
> edited, so the evidence and its instrument stay paired even though the live tool has moved
> on. The captures themselves are untouched.

**Consequence.** Both goods are had — current vocabulary and a recoverable pairing between
evidence and the instrument that produced it — at the cost of a second copy of a script in
the tree, which is a small maintenance liability and a mild invitation to future confusion
about which copy is live. This option is the drafter's note that the dilemma is not actually
binary; it is not a recommendation, and the choice remains the owner's.

---

## 3. THE REDLINE (exact, per option — none applied)

### 3.1 OPTION 1

BEFORE (`r1/capture.sh:73`):

```
  echo "PROVES     : $proves"
```

AFTER:

```
  echo "TESTS WHETHER: $proves"
```

BEFORE (`r1/capture.sh:18–28`) — the whole retention paragraph, as quoted in §1.

AFTER:

```
# ⚠ THE PRINTED LABEL WAS CHANGED FROM `PROVES     :' TO `TESTS WHETHER:' BY
# PARCEL B ITEM B3 (owner ruling, 2026-08-__), completing Owner Ruling 2 §5 item 9
# in the tool as well as in the fixture headers.  THE TEN PRESERVED CAPTURES IN
# `pre-repair/' AND `post-repair/' STILL CARRY THE OLD LABEL AND ARE NEVER
# REGENERATED.  A transcript whose header says `PROVES' was written before this
# ruling; the difference is the repair, not tampering.  Rider 6's holding is
# unchanged and still governs QUOTATION: the header names the DEFECT CLASS the
# capture tests for, identically in red and green captures, and the tally beside
# it governs the post-repair result.
```

BEFORE (`r1/capture.sh:3–5`):

```
# capture.sh — run one defect witness in a fresh image and write its transcript
# with a header naming the command, the UTC clock, and what the run tests whether
# holds.
```

AFTER: unchanged (this text was already conformed by Parcel A and is correct under Option 1).

### 3.2 OPTION 2

BEFORE (`r1/capture.sh:27–28`):

```
# post-repair result.  Whether the printed label should change at all is
# registered for Parcel B, not decided here.
```

AFTER:

```
# post-repair result.  PARCEL B ITEM B3 DECIDED IT: the label is RETAINED
# permanently as a frozen evidentiary token (owner ruling, 2026-08-__).  Owner
# Ruling 2 §5 item 9's `PROVES -> TESTS WHETHER' substitution governs prospective
# commentary and fixture headers and does NOT reach a label already printed into
# preserved evidence.  This is settled, not deferred.
```

No other line changes; `capture.sh:73` is untouched; no capture is touched.

### 3.3 OPTION 3

The Option-1 redline of §3.1, plus one new file — `r1/pre-repair/capture.sh.as-captured`,
byte-identical to `capture.sh` as of this branch's tip — plus, in `r1/R1-REPAIR-NOTES.md`, the
sentence:

```
The instrument that produced the ten preserved captures is preserved beside them as
`pre-repair/capture.sh.as-captured'; the live `capture.sh' has since been reworded by Parcel
B item B3 and is NOT the script those transcripts came from.
```

---

## 4. IMPLEMENTATION STATUS

**PROPOSAL — AWAITING OWNER RULING. NOTHING IMPLEMENTED.**

`r1/capture.sh` is byte-unchanged on this branch. The ten preserved captures in
`r1/pre-repair/` and `r1/post-repair/` are byte-unchanged and were opened read-only.

**The caution the commission asked be stated plainly, stated without a choice being made:**
any change to the printed label diverges the tool's output from ten frozen historical
captures that carry the label verbatim. That divergence is not repaired by any subsequent
action short of regenerating the captures, which is forbidden. Option 1 accepts the
divergence and documents it; Option 2 avoids it by keeping a retired word; Option 3 buys the
pairing back with a second copy of the script. **CONDITOR does not choose among them and
records no preference.**

---

— drafted by CONDITOR (Claude Opus), Parcel B, commissioned by the chair (Claude Fable 5),
2026-08-10
