# PARCEL B — ITEM B6: NO MATCHER-LEVEL CONCORDANCE TOOTH EXISTS

STANDING: CANDIDATE PROPOSAL. Nothing here is adopted, accepted, or in force; nothing here
is independent verification (AP0 adoption Rider 2, binding). **This item proposes law and
implements nothing.** No comparator was built; building one is new work and new evidence,
neither of which Parcel B may produce without a ruling.

Jurisdiction: OWNER RULING 5 (2026-08-10) §3. This is item 6 of 8.

---

## 1. THE GAP

`MANY-ACTS-0-PRESSURE-REPORT.md:109–119`:

> ```
> - **Reusing `with-outcome`/`match-outcome` as program syntax** — those are in-image macro
>   heads in a CLOSED two-row construct table with no registration point. MA0's branch is
>   program-DATA validated by MA0's own closed pattern grammar whose matching law mirrors
>   Surface /2's (value match AND standing `:present`; absence keywords matchable; no
>   truthiness); the heads are not renamed, wrapped, or extended. **What the divergence teeth
>   that were actually built compare** is the lane's act *composition*, not its matcher: the
>   concordance comparator (`ma0-concordance.lisp`) runs an MA0-composed act against the
>   canonical `run-all-arms` act over seven arms × 18 enumerated facets. *No tooth compares
>   MA0's matching against `match-outcome` on identical outcomes* — this pre-code line
>   proposed one and none was built; the matching law's witness is the selftest scenario
>   `w-branch-exact`. Whether a matcher-level comparator should exist is not decided here.
> ```

The handoff entry, `MANY-ACTS-0-PARCEL-A-RETURN.md:733–736`:

> **B6 — No matcher-level concordance tooth exists.** `MANY-ACTS-0-PRESSURE-REPORT.md` §5
> proposed comparing MA0's matching against `match-outcome` on identical outcomes; none was
> built. Parcel A recorded the absence in the same sentence. **Gap:** building one is new work,
> and whether the matching law needs a comparator beyond `w-branch-exact` is a design decision.

**Exactly what is and is not covered today, stated precisely so the gap is not overcharged:**

- **Covered.** MA0's *composition* of an act is compared against the canonical
  `run-all-arms` composition over **7 arms × 18 facets = 126** enumerated comparisons, with a
  planted-divergence tooth that must fire (`ma0-teeth.sh` sections 4 and 4b; tallies
  `ma0-concordance: 7 arms, 126 facets, 0 divergences` and
  `ma0-concordance-tooth: 1 planted divergence, 1 detected`).
- **Covered.** MA0's *matching* is exercised by the lane's own selftest scenario
  `w-branch-exact` and by the disease `D-BOTH-ARMS`, whose named red check is
  `w-branch-one: summary-count=0` — i.e. the selection law is toothed.
- **NOT covered.** No instrument feeds **one identical outcome** to MA0's pattern matcher and
  to Surface /2's `match-outcome` and asserts the two agree. The claim that MA0's matching law
  *mirrors* Surface /2's is therefore a claim about a design intention supported by
  same-author reading, not by a comparator.

The absence is not a defect in anything adopted. It is a **hole with an accurate label on it**,
and this item asks whether to fill it, close it, or leave it labelled.

---

## 2. THE PROPOSED RULING — three options, none chosen

### OPTION 1 — BUILD A MATCHER-LEVEL COMPARATOR (specified here, unbuilt)

Candidate text:

> **MATCHER CONCORDANCE (owner ruling, 2026-08-__).** A matcher-level comparator is
> authorized as new work in a named round. Its contract:
>
> 1. **Input.** A finite, enumerated corpus of `(outcome, pattern)` pairs, mechanically
>    derived from the closed pattern grammar of `MANY-ACTS-0-GRAMMAR.md` §4 — every axis,
>    every pattern shape, both `:present` and absent standings, and the `:and` conjunction —
>    with the corpus size printed and never round-numbered.
> 2. **Comparison.** For each pair, MA0's matcher and Surface /2's `match-outcome` are each
>    asked whether the pattern holds, in separate images, and the two answers are compared.
>    A missing answer is RED, never skipped.
> 3. **Tooth.** The comparator carries a planted-divergence mode, on the model of
>    `MA0_CONCORD_PLANT_DIVERGENCE`, and its own tooth must be shown firing before any clean
>    run is quoted. A gate that has never fired is untested, not passing.
> 4. **Claim ceiling, pre-committed.** A green run earns exactly: *"On an enumerated corpus
>    of N (outcome, pattern) pairs, MA0's matcher and Surface /2's `match-outcome` returned
>    the same answer."* It does **not** earn "the matching law mirrors Surface /2",
>    "equivalent matchers", or any portability claim. A divergence is a **finding**, not a
>    defect to be cosmetized: it is preserved verbatim and reported.
> 5. **Standing.** The comparator is a new witness. It does not enter any adopted floor
>    until separately adopted.

**Consequence.** The one substantive assertion in §5 of the pressure report that rests on
reading rather than on a witness acquires one. Cost: it is genuine new work with a real
possibility of a red result — which is the point, and which is also why it must be
pre-committed before it is run, per point 4. Note the honest risk: the two matchers may
diverge on a corner the design never considered, and the ruling must be willing to hear that.

### OPTION 2 — RULE THAT NONE IS NEEDED, AND SAY WHY

Candidate text:

> **MATCHER CONCORDANCE (owner ruling, 2026-08-__).** No matcher-level comparator is required
> at /0. MA0's matcher is **not** an implementation of Surface /2's matcher and is not
> claimed to be: it is an independent closed pattern grammar over program data whose law is
> stated in `MANY-ACTS-0-GRAMMAR.md` §4 and witnessed by the lane's own scenarios. The
> pressure report's sentence *"whose matching law mirrors Surface /2's"* is amended to remove
> the comparative claim, since a comparison that will never be run should not be asserted.

**Consequence.** Closes the item without new work and removes an unwitnessed comparative
claim — which is a real gain in documentary truthfulness. Cost: the lane gives up the
possibility of discovering a genuine divergence, and the two matchers may drift apart in
later versions with nothing watching.

### OPTION 3 — DEFER WITH A REGISTERED DEFICIT

Candidate text:

> **MATCHER CONCORDANCE (owner ruling, 2026-08-__).** The question is deferred. It is entered
> in the 28-place deficit register as a named item — *"no witness compares MA0's matching to
> Surface /2's `match-outcome` on identical outcomes; the 'mirrors' claim rests on reading"* —
> and the pressure report's sentence is annotated with the register entry so the absence is
> reachable from where the claim is made. No comparator is built and no claim is amended.

**Consequence.** Cheapest honest disposition; keeps the question alive where the lane already
keeps its open questions. Cost: the register grows by one and the comparative claim keeps
standing on reading in the meantime.

---

## 3. THE REDLINE (exact, per option — none applied)

### 3.1 OPTION 1

No redline to existing text is required by the ruling itself; the work is a new file
(proposed name `ma0-matcher-concordance.lisp`) plus a teeth section. For completeness, the
teeth insertion point and the expectation form it would take, if built:

BEFORE (`ma0-teeth.sh:205–208`):

```
# ---------------------------------------------------------------------------
section "4 CONCORDANCE" \
  "sbcl --script $LANE/ma0-concordance.lisp" \
  '^ma0-concordance: [0-9]+ arms, [0-9]+ facets, 0 divergences$'
```

AFTER (illustrative only — NOT proposed for application, since the script does not exist):

```
# ---------------------------------------------------------------------------
section "4 CONCORDANCE" \
  "sbcl --script $LANE/ma0-concordance.lisp" \
  '^ma0-concordance: [0-9]+ arms, [0-9]+ facets, 0 divergences$'

# 4c — MATCHER concordance (Parcel B item B6, owner ruling 2026-08-__).
section "4c MATCHER CONCORDANCE" \
  "sbcl --script $LANE/ma0-matcher-concordance.lisp" \
  '^ma0-matcher-concordance: [0-9]+ pairs, 0 divergences$'
```

*(A section 4d planted-divergence tooth on the model of 4b would be required by point 3 of
the ruling, and the teeth's own attempted/green counts would move from 15 to 17 — a change to
a number quoted in the adopted record, which is itself a reason this option must be a
deliberate round and not an afterthought.)*

### 3.2 OPTION 2

BEFORE (`MANY-ACTS-0-PRESSURE-REPORT.md:111–113`):

```
  program-DATA validated by MA0's own closed pattern grammar whose matching law mirrors
  Surface /2's (value match AND standing `:present`; absence keywords matchable; no
  truthiness); the heads are not renamed, wrapped, or extended.
```

AFTER:

```
  program-DATA validated by MA0's own closed pattern grammar, whose law is stated in
  MANY-ACTS-0-GRAMMAR.md §4 (value match AND standing `:present`; absence keywords
  matchable; no truthiness) and witnessed by this lane's own scenarios. It is designed after
  the same principles as Surface /2's matcher; no witness compares the two, and no
  equivalence between them is claimed. The heads are not renamed, wrapped, or extended.
```

BEFORE (`MANY-ACTS-0-PRESSURE-REPORT.md:117–119`):

```
  MA0's matching against `match-outcome` on identical outcomes* — this pre-code line
  proposed one and none was built; the matching law's witness is the selftest scenario
  `w-branch-exact`. Whether a matcher-level comparator should exist is not decided here.
```

AFTER:

```
  MA0's matching against `match-outcome` on identical outcomes* — this pre-code line
  proposed one and none was built; the matching law's witness is the selftest scenario
  `w-branch-exact`. Parcel B item B6 (owner ruling, 2026-08-__) decided that none is
  required at /0, and struck the comparative claim above rather than leave it unwitnessed.
```

### 3.3 OPTION 3

BEFORE (`MANY-ACTS-0-PRESSURE-REPORT.md:119`):

```
  `w-branch-exact`. Whether a matcher-level comparator should exist is not decided here.
```

AFTER:

```
  `w-branch-exact`. Whether a matcher-level comparator should exist is DEFERRED and
  registered as deficit-register item __ (Parcel B item B6, owner ruling 2026-08-__): the
  "mirrors Surface /2" claim above rests on reading, not on a witness, until that item is
  discharged.
```

---

## 4. IMPLEMENTATION STATUS

**PROPOSAL — AWAITING OWNER RULING. NOTHING IMPLEMENTED.**

No comparator was written. `ma0-teeth.sh` is byte-unchanged; the teeth remain 15 sections.
`MANY-ACTS-0-PRESSURE-REPORT.md` is byte-unchanged. **Zero evidence** was produced by this
item, and none could have been: every option except 2 and 3 *creates* evidence, which is
outside a parcel whose earned-evidence result is fixed at zero.

---

— drafted by CONDITOR (Claude Opus), Parcel B, commissioned by the chair (Claude Fable 5),
2026-08-10
