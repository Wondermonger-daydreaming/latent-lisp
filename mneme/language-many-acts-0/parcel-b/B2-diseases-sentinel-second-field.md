# PARCEL B — ITEM B2: `ma0-diseases.sh` PRINTS A FALSE CONTROL COUNT

STANDING: CANDIDATE PARCEL. Nothing here is adopted, accepted, or independent verification
(AP0 adoption Rider 2, binding). **Zero evidence is earned by this item.** The repair below
corrects a printed number; it produces no new witness, no new law about the language, and no
claim about anything the diseases demonstrate.

Jurisdiction: OWNER RULING 5 (2026-08-10) §3. This is item 2 of 8.

---

## 1. THE DEFECT

`experiments/latent-lisp/mneme/language-many-acts-0/ma0-diseases.sh:299–303` (pre-repair):

```
# D-SKIP-VALIDATE is exhibited on two witnesses; the DISEASE count is five.
DISEASE_COUNT=5
if [ "$FAILED" -eq 0 ] && [ "$DETECTED" -eq "$PAIRS" ] && [ "$CONTROLS" -eq "$PAIRS" ]; then
  echo "ma0-diseases: $DISEASE_COUNT diseases detected, $DISEASE_COUNT controls clean"
  echo "  ($PAIRS disease/control PAIRS: D-SKIP-VALIDATE is exhibited on BOTH of its witnesses)"
```

The second field of the sentinel is printed from `DISEASE_COUNT` — the **family** constant —
while the thing it names is the **control** count, which is one per invocation and therefore
`$PAIRS` = 6. The script's own header said so, `ma0-diseases.sh:70–78` (pre-repair):

> ```
> # Sentinel: ma0-diseases: 5 diseases detected, 5 controls clean
> #           ( <PAIRS> disease/control PAIRS: D-SKIP-VALIDATE is exhibited on BOTH
> #             of its witnesses )
> #   ⚠ The sentinel's FIRST number is the family count (5) and is exact.  Its
> #   SECOND number is printed from the same family constant, so it reads "5
> #   controls clean" while SIX control arms in fact ran clean; the parenthetical
> #   line beneath it carries the invocation count.  Correcting the printed second
> #   number would change this script's runtime OUTPUT, which Parcel A may not do,
> #   so it is left exactly as it prints and is registered for Parcel B.
> ```

and the same admission is carried prospectively in
`MANY-ACTS-0-FAILURE-MATRIX.md:65–68`:

> Its second sentinel field currently
> reuses `DISEASE_COUNT` and therefore prints `5 controls clean` although six controls ran;
> that runtime-output defect is deferred to Parcel B.

The handoff entry, `MANY-ACTS-0-PARCEL-A-RETURN.md:707–712`:

> **Gap:** correcting it changes the script's runtime output, which Parcel A may not
> do. … the teeth regex is `^ma0-diseases: [0-9]+ diseases detected, [0-9]+
> controls clean$`, so no adopted gate would break — the obstacle is the no-runtime-change
> rule alone. Needs an owner decision that a printed sentinel may be made accurate.

The defect conflates exactly the two counts R1 adoption **Rider 6** forbids conflating
(`MANY-ACTS-0-R1-ADOPTION-OWNER-RULING-2026-08-10.md:174–178`):

> The disease inventory must continue distinguishing:
> * five named diseases;
> * six disease invocations/pairs.
> Neither count should be silently substituted for the other.

The printed sentinel was substituting one for the other, silently, in the lane's own output.

---

## 2. THE PROPOSED RULING

Candidate text, for adoption verbatim, amendment, or strike:

> **MANY ACTS /0 — PRINTED-SENTINEL ACCURACY (owner ruling, 2026-08-__).**
>
> 1. A sentinel field that prints a **false count of what the run actually did** may be
>    corrected, and the correction is a repair rather than a change of behaviour: no witness
>    is added, removed, weakened, or strengthened, and no law of the language moves.
> 2. The corrected field must print the **counted quantity itself** — the variable the run
>    incremented — never a constant that happens to agree. A constant that agrees today is a
>    false sentinel waiting for the next invocation to be added.
> 3. Historical transcripts that recorded the old output are **never regenerated**. They
>    remain the true record of what the tool printed when they were taken. A tool's current
>    output and a frozen capture of its former output are permitted to differ; that
>    divergence is the ordinary shape of a repaired instrument, not a defect in the evidence.
> 4. Prospective documentation that *describes* the old output is corrected in the same
>    commit as the code. A prose copy of a fixed defect is a fossil, and fossils are what
>    reading-audits wave through.
>
> This ruling governs printed **counts of the run's own arms**. It does not govern printed
> **labels or vocabulary** — see item B3, which is left open.

**The distinction §2(4) draws is the whole legislative content of this item**, and it is why
B2 can be implemented while B3 cannot: `5 controls clean` was a **false statement of fact
about the run just performed**; `PROVES` (B3) is a **superseded word for a true statement**.
The owner may of course reject that distinction, in which case this item reverts to
proposal-only and the branch commit implementing it should be reverted.

**Alternative the owner may prefer instead (Option 2):** *leave the output exactly as it
prints, forever, and delete the second field entirely* —
`ma0-diseases: 5 diseases detected` plus the parenthetical invocation line. Consequence: no
field can ever be false again because no field carries the ambiguous quantity; cost: the
teeth regex must change in the same commit (it requires the `, N controls clean` tail), and a
gate that has been green across the whole campaign changes shape for a cosmetic reason.
**Option 3:** *print both counts explicitly* —
`ma0-diseases: 5 disease families detected over 6 invocations, 6 controls clean`.
Consequence: unambiguous, but it changes the sentinel's *shape*, so the teeth regex changes
too, and every document quoting the sentinel form (not merely its numbers) becomes stale.
The implemented repair below is Option 1 because it is the only one of the three that leaves
every existing gate expression valid unchanged.

---

## 3. THE REDLINE

### 3.1 `ma0-diseases.sh` — the printed sentinel (runtime output changes)

BEFORE (lines 299–303):

```
# D-SKIP-VALIDATE is exhibited on two witnesses; the DISEASE count is five.
DISEASE_COUNT=5
if [ "$FAILED" -eq 0 ] && [ "$DETECTED" -eq "$PAIRS" ] && [ "$CONTROLS" -eq "$PAIRS" ]; then
  echo "ma0-diseases: $DISEASE_COUNT diseases detected, $DISEASE_COUNT controls clean"
```

AFTER:

```
# D-SKIP-VALIDATE is exhibited on two witnesses; the DISEASE FAMILY count is five
# (a constant), and the CONTROL count is one per INVOCATION — counted, never
# assumed, and printed from the counter the run incremented (Parcel B item B2;
# R1 adoption Rider 6 forbids substituting either count for the other).
DISEASE_COUNT=5
if [ "$FAILED" -eq 0 ] && [ "$DETECTED" -eq "$PAIRS" ] && [ "$CONTROLS" -eq "$PAIRS" ]; then
  echo "ma0-diseases: $DISEASE_COUNT diseases detected, $CONTROLS controls clean"
```

`$CONTROLS` is incremented once per green control arm (line 145) and the surrounding
condition has already established `CONTROLS == PAIRS`, so the printed number is both counted
and guaranteed to equal the invocation count. The FAILED branch (line 306) already printed
`$CONTROLS` and is unchanged.

### 3.2 `ma0-diseases.sh` — the header's sentinel description

BEFORE (lines 70–78):

```
# Sentinel: ma0-diseases: 5 diseases detected, 5 controls clean
#           ( <PAIRS> disease/control PAIRS: D-SKIP-VALIDATE is exhibited on BOTH
#             of its witnesses )
#   ⚠ The sentinel's FIRST number is the family count (5) and is exact.  Its
#   SECOND number is printed from the same family constant, so it reads "5
#   controls clean" while SIX control arms in fact ran clean; the parenthetical
#   line beneath it carries the invocation count.  Correcting the printed second
#   number would change this script's runtime OUTPUT, which Parcel A may not do,
#   so it is left exactly as it prints and is registered for Parcel B.
```

AFTER:

```
# Sentinel: ma0-diseases: 5 diseases detected, 6 controls clean
#           ( <PAIRS> disease/control PAIRS: D-SKIP-VALIDATE is exhibited on BOTH
#             of its witnesses )
#   ⚠ THE TWO NUMBERS ARE DIFFERENT QUANTITIES.  The FIRST is the disease FAMILY
#   count (5, a constant).  The SECOND is the count of CONTROL ARMS that ran
#   clean — one per INVOCATION, so 6 — and it is printed from the counter the run
#   incremented, not from the family constant.  Until Parcel B item B2 it was
#   printed from `DISEASE_COUNT' and therefore read "5 controls clean" while six
#   control arms had in fact run clean.  The ten frozen R1 captures and every
#   transcript taken before that repair record the old output and are NEVER
#   regenerated: a repaired instrument and a frozen capture of its former output
#   are permitted to differ.
```

### 3.3 `MANY-ACTS-0-FAILURE-MATRIX.md` — the prospective description of the defect

BEFORE (lines 64–68):

```
twelve reported checks. `ma0-diseases.sh` reports the family count in the sentinel’s first
field and `$PAIRS` on the following parenthetical line. Its second sentinel field currently
reuses `DISEASE_COUNT` and therefore prints `5 controls clean` although six controls ran;
that runtime-output defect is deferred to Parcel B.
```

AFTER:

```
twelve reported checks. `ma0-diseases.sh` reports the family count in the sentinel’s first
field, the count of clean CONTROL ARMS in its second field, and `$PAIRS` on the following
parenthetical line, so a green run prints `5 diseases detected, 6 controls clean`. Until
Parcel B item B2 the second field reused `DISEASE_COUNT` and therefore printed
`5 controls clean` although six controls ran; transcripts taken before that repair record
the old output and are not regenerated.
```

### 3.4 The teeth expectation — EXAMINED, NO CHANGE REQUIRED

`ma0-teeth.sh:241–242`:

```
    "bash $LANE/ma0-diseases.sh" \
    '^ma0-diseases: [0-9]+ diseases detected, [0-9]+ controls clean$'
```

Both fields are `[0-9]+`; the repaired sentinel `ma0-diseases: 5 diseases detected, 6
controls clean` matches the unchanged expression. **No teeth edit is part of this repair**,
and the post-fix teeth run in §4 is the proof rather than the promise. `verify-release.sh`
carries no MA0 disease expectation (its only `controls clean` line, `:197`, is Surface
Account /0's `8/8`).

### 3.5 Deliberately NOT touched (historical records of the old output)

Each of these correctly records what the tool printed when the record was made. Under §2(3)
of the proposed ruling they are never rewritten, and Parcel B did not touch them:

| File | Line | Text left standing |
|---|---|---|
| `MANY-ACTS-0-R1-ADOPTION-RECEIPT-2026-08-10.txt` | 35 | `diseases 5 detected / 5 controls clean;` |
| `MANY-ACTS-0-R1-ADOPTION-RECORD-2026-08-10.md` | 35 | `(diseases 5/5 controls clean; …` |
| `MANY-ACTS-0-PARCEL-A-RETURN.md` | 309, 593, 710 | the quoted header, the teeth tally line, the handoff entry |
| `MANY-ACTS-0-PARCEL-A-REPAIR-RETURN.md` | 79, 200, 219 | the defect account and the teeth tally line |
| `MANY-ACTS-0-RETURN.md`, `MANY-ACTS-0-R1-RETURN.md` | — | returned reports, untouched under item 10 of Owner Ruling 2 §5 |

---

## 4. IMPLEMENTATION STATUS

**IMPLEMENTED ON THE BRANCH, RED-FIRST.** Candidate only; not adopted, not merged, not
pushed.

The evidence sits beside this file in `parcel-b/b2-witness/`:

| Capture | File | What it shows |
|---|---|---|
| RED (pre-repair) | `b2-witness/RED-pre-fix-diseases.txt` | the unrepaired script's own full run, ending in the **false** sentinel `ma0-diseases: 5 diseases detected, 5 controls clean` above a parenthetical naming **6** pairs, with six control arms visibly `[PASS]` in the body |
| GREEN (post-repair) | `b2-witness/GREEN-post-fix-diseases.txt` | the identical run after the redline of §3.1, ending in `ma0-diseases: 5 diseases detected, 6 controls clean` |

The red capture was taken **before** any edit to the script, from this branch, with the SBCL
operation-check performed first through the wrapper — `(lisp-implementation-version)` →
`2.4.6`, exit 0, binary `/home/gauss/.local/bin/sbcl`. Gate tallies for the whole serial
re-run are in `PARCEL-B-RETURN.md` §3 and are not restated here.

**What this repair does not earn.** Nothing. The diseases still detect exactly what they
detected before; the six control arms were already running and already clean, and were
already visible as `[PASS]` lines in every prior transcript. The only thing that changed is
that the summary line now states the number the run actually produced. No count in this lane
was *raised* by this repair, no witness was added, and the five-families/six-invocations
distinction of Rider 6 is now enforced by the print statement instead of by a comment asking
the reader to forgive it.

---

— drafted and implemented by CONDITOR (Claude Opus), Parcel B, commissioned by the chair
(Claude Fable 5), 2026-08-10
