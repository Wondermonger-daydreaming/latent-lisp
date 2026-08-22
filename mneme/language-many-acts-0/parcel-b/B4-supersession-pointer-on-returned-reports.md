# PARCEL B — ITEM B4: MAY A RETURNED-AND-DISPOSED REPORT CARRY A SUPERSESSION POINTER?

STANDING: CANDIDATE PROPOSAL. Nothing here is adopted, accepted, or in force; nothing here
is independent verification (AP0 adoption Rider 2, binding). **This item proposes law and
implements nothing.**

Jurisdiction: OWNER RULING 5 (2026-08-10) §3. This is item 4 of 8.

---

## 1. THE GAP

Two returned reports carry numbers that were true when written and have since been
superseded by the adopted R1 record.

`MANY-ACTS-0-RETURN.md:25–27`:

> ```
>    `ma0-selftest: 159 checks, 0 failures` (two runs byte-identical; fault-plant flips it
>    red); `ma0-teeth: 9 sections attempted, 0 red` (chair-rerun serially, direct exit
>    capture); `ma0-p3-holdout: 11 checks, 0 failures`.
> ```

`MANY-ACTS-0-RETURN.md:56–58`:

> ```
>    (`ma0-complete-act`, public parts only) agrees with the canonical `run-all-arms`
>    composer on 4 arms × 18 facets = **72/72 comparisons, 0 divergences**, with a
>    planted-divergence tooth proving the comparator can bite …
> ```

`SEAL-ADDENDUM-1-SUBSTRATE-FINDINGS.md:57–60`:

> ```
> - Phase-5 selftest (159 checks) deliberately EXCLUDES: concordance teeth, the five
>   diseases, W-NO-BLIND-REPLAY, W-VF-UNCHANGED, W-ONEACT-GREEN, W-FLOOR-UNTOUCHED,
>   W-P3-HOLDOUT — built in Phase 7 (teeth hand) and Phase 6 (chair). A green 159 says
>   nothing about composer concordance; the suite header says so itself.
> ```

The adopted record supersedes both figures — `MANY-ACTS-0-R1-RETURN.md:14–18`:

> Coverage closure: **7 arms / 7 traversed / 126 concordance facets / 0 divergences**.
> Suite 159 → **200**, mechanically counted. Full floor: **15 sections / 15 green / 0 red**…

and Owner Ruling 2 §5 items 2–3 ordered exactly those replacements *where the artifact was
prospective*. Parcel A performed them there and stopped here, recording why
(`MANY-ACTS-0-PARCEL-A-RETURN.md:720–727`):

> Left byte-untouched under item 10 (they are the Round-0 return and the
> seal-time findings record; both numbers were true when written, and the adopted record
> already reconciles them — R1 return §2). **Gap:** whether a *supersession pointer* — a header
> line, with no body sentence altered — may be added to a returned-and-disposed report. That is
> a decision about the status of returns. The lane precedent cuts both ways: SEAL-ADDENDUM-2
> handled the same problem by writing the supersession note *elsewhere*, which is why nothing
> was added here.

The controlling instruction Parcel A obeyed is Owner Ruling 2 §5 item 10:

> Preserve every historical transcript, frozen report, and original evidentiary artifact
> byte-for-byte. Corrections to prospective documentation must not rewrite historical
> observations.

**The question this item asks is narrow and real:** item 10 forbids *rewriting* a historical
observation. Does *prepending a pointer that alters no observation* count as rewriting? The
lane has never said. It has only ever practised the cautious answer.

### 1.1 The precedent, quoted, because it cuts both ways

`SEAL-ADDENDUM-2-PRESSURE-ACCOUNT-RULING.md:3–7`:

> STANDING: CANDIDATE. Chair-recorded (Claude Fable 5, 2026-08-10) from the owner's R1
> MEMBRANE REPAIR ruling, §6. The sealed P1/P2 briefs remain intact as historical inputs;
> SEAL-ADDENDUM-1 remains the provenance record of their corrections.

and its own `## Supersession note` section, which corrects earlier phrasings *from outside
the documents it corrects*. That is the lane's practice: **supersession is written
elsewhere.** But note what it costs — a reader who opens `MANY-ACTS-0-RETURN.md` and reads
`159` is given no signal at all that a governing number exists, and the instrument that would
tell them is three documents away.

---

## 2. THE PROPOSED RULING — three options, none chosen

### OPTION 1 — NO POINTER, EVER (codify the current practice)

Candidate text:

> **STATUS OF RETURNED REPORTS (owner ruling, 2026-08-__).** A report that has been returned
> and disposed is closed testimony. It is never edited, annotated, prefixed, suffixed, or
> otherwise touched — not to correct it, not to point at its correction. Supersession is
> recorded only in the superseding instrument and in the lane's supersession registry (if
> one exists). A reader's route from a stale figure to its governing correction is the
> registry, never the stale document itself.

**Consequence.** Maximum evidentiary integrity: every returned report is exactly the bytes
its author committed, and no later hand has ever been inside it. Cost, stated plainly: a
reader holding `MANY-ACTS-0-RETURN.md` reads `159 checks` and `4 arms × 72` with no signal,
and the lane accepts that a stale number in a closed report may be quoted onward by someone
who never finds the registry. This is the status quo, made law.

### OPTION 2 — A HEADER POINTER, IN ONE FIXED FORM, MECHANICALLY CONSTRAINED

Candidate text:

> **SUPERSESSION POINTERS ON RETURNED REPORTS (owner ruling, 2026-08-__).** A returned and
> disposed report may carry **one** supersession pointer, subject to every condition below;
> a pointer failing any condition is void and must be removed.
>
> 1. **Placement.** Immediately after the document's title line, before any other content.
> 2. **Form.** A fenced block beginning `SUPERSESSION POINTER (added <date>, Parcel <x>):`,
>    naming (a) the superseded figure or statement verbatim, (b) the governing instrument
>    with its exact citation, and (c) nothing else.
> 3. **Non-alteration.** No sentence, number, table cell, or byte of the report's body may
>    change. The pointer asserts nothing about the body's truth *when written* — a superseded
>    figure that was true when observed remains a true historical observation.
> 4. **Mechanical proof.** The commit adding a pointer must exhibit the body's SHA-256 before
>    and after, proven equal, with the pointer block excluded by exact line range. A pointer
>    added without that proof is void.
> 5. **Once.** A document may carry at most one pointer block. A second supersession extends
>    the existing block; it never adds another.
>
> This ruling does **not** license correcting, updating, or improving any returned report.
> It licenses one immovable signpost and nothing else.

**Consequence.** Readers stop being misled by stale figures in the document that carries them.
Cost: the lane concedes that a closed report's bytes may change after disposal — and the
concession, however tightly fenced, is the kind that later hands widen. Condition 4 exists
precisely because a prose promise of non-alteration is the weakest form of that guarantee;
if this option is adopted, the hash proof should be enforced by a check, not by discipline.

### OPTION 3 — AN EXTERNAL SUPERSESSION REGISTRY, NO DOCUMENT TOUCHED

Candidate text:

> **LANE SUPERSESSION REGISTRY (owner ruling, 2026-08-__).** No returned report is touched.
> A single lane file, `MANY-ACTS-0-SUPERSESSIONS.md`, is created and maintained as the
> lane's index of superseded statements: for each, the artifact, the exact locus, the
> statement verbatim, the governing instrument, and the correcting figure. The registry is
> append-only. Every future round that supersedes a figure files it there in the same commit
> that supersedes it.

**Consequence.** All of Option 1's integrity plus a route a reader can actually find, and it
generalises: `159`, `4 arms × 72`, the pre-B2 disease sentinel (item B2 §3.5), and every
future supersession live in one place. Cost: it is one more artifact to keep true, and a
registry that falls behind is worse than none — it converts "I did not know" into "the index
said otherwise." If this option is chosen, the registry needs an owner-visible rule that
filing is part of the superseding commit, not a follow-up.

---

## 3. THE REDLINE (exact, per option — none applied)

### 3.1 OPTION 1

No file changes. For the record, the two loci that stay exactly as they are:
`MANY-ACTS-0-RETURN.md:25` (`159 checks`), `MANY-ACTS-0-RETURN.md:57` (`4 arms × 18 facets =
72/72`), `SEAL-ADDENDUM-1-SUBSTRATE-FINDINGS.md:57` (`Phase-5 selftest (159 checks)`).

### 3.2 OPTION 2

BEFORE (`MANY-ACTS-0-RETURN.md:1–3`):

```
# MANY ACTS /0 — CANDIDATE RETURN

STANDING: CANDIDATE. Nothing here is adopted, accepted, or on a governing floor; nothing
```

AFTER:

```
# MANY ACTS /0 — CANDIDATE RETURN

> SUPERSESSION POINTER (added 2026-08-__, Parcel B item B4):
> This report's `ma0-selftest: 159 checks, 0 failures` (§1 item 1) and its
> `4 arms × 18 facets = 72/72 comparisons, 0 divergences` (§1 item 7) are Round-0
> observations, true when made. They are superseded for all prospective use by the adopted
> R1 record: suite **200 checks**, coverage **7 arms / 7 traversed / 126 facets / 0
> divergences** (`MANY-ACTS-0-R1-RETURN.md` §2; R1 adoption ruling, 2026-08-10). No sentence
> of this report has been altered.

STANDING: CANDIDATE. Nothing here is adopted, accepted, or on a governing floor; nothing
```

BEFORE (`SEAL-ADDENDUM-1-SUBSTRATE-FINDINGS.md:1–3`):

```
# MANY ACTS /0 — SEAL ADDENDUM 1: substrate findings (post-seal, pre-freeze)

STANDING: CANDIDATE. This addendum was written AFTER the pre-code seal (`9e52b7e1`) and
```

AFTER:

```
# MANY ACTS /0 — SEAL ADDENDUM 1: substrate findings (post-seal, pre-freeze)

> SUPERSESSION POINTER (added 2026-08-__, Parcel B item B4):
> The `Phase-5 selftest (159 checks)` of this file's exclusions list is a pre-freeze
> observation, true when made. The adopted suite count is **200**
> (`MANY-ACTS-0-R1-RETURN.md` §2). The exclusions the sentence records are unaffected. No
> sentence of this addendum has been altered.

STANDING: CANDIDATE. This addendum was written AFTER the pre-code seal (`9e52b7e1`) and
```

### 3.3 OPTION 3

No existing file changes. One new file, `MANY-ACTS-0-SUPERSESSIONS.md`, whose initial body is
the ruling text of §2 Option 3 plus this table:

| Artifact | Locus | Statement as written | Governing instrument | Governing figure |
|---|---|---|---|---|
| `MANY-ACTS-0-RETURN.md` | §1 item 1, line 25 | `ma0-selftest: 159 checks, 0 failures` | `MANY-ACTS-0-R1-RETURN.md` §2; R1 adoption ruling 2026-08-10 | 200 checks |
| `MANY-ACTS-0-RETURN.md` | §1 item 7, line 57 | `4 arms × 18 facets = 72/72 comparisons` | same | 7 arms × 18 = 126 |
| `MANY-ACTS-0-RETURN.md` | §1 item 1, line 26 | `ma0-teeth: 9 sections attempted, 0 red` | same | 15 sections / 15 green / 0 red |
| `SEAL-ADDENDUM-1-SUBSTRATE-FINDINGS.md` | line 57 | `Phase-5 selftest (159 checks)` | same | 200 checks |
| `ma0-diseases.sh` (pre-B2 output) | sentinel | `5 diseases detected, 5 controls clean` | Parcel B item B2 | `5 diseases detected, 6 controls clean` |

*(The last row is filed here only as an illustration of the registry's reach; whether it is
entered depends on Option 3 being chosen at all.)*

---

## 4. IMPLEMENTATION STATUS

**PROPOSAL — AWAITING OWNER RULING. NOTHING IMPLEMENTED.**

`MANY-ACTS-0-RETURN.md` and `SEAL-ADDENDUM-1-SUBSTRATE-FINDINGS.md` are byte-unchanged on
this branch. No supersession registry was created — creating one *is* Option 3, and creating
it "just in case" would be adopting an option by building it, which is the smuggling this
parcel exists to refuse.

One observation the drafter records without acting on it: item B2's repair (§3.5 of that
file) produced precisely the same species of problem — historical records that correctly
report a superseded output — and was handled by Option 1's logic (leave them, explain
elsewhere). Whatever the owner rules here should govern that case too, and B2's §3.5 table is
written so it can be moved into a registry without alteration if Option 3 is chosen.

---

— drafted by CONDITOR (Claude Opus), Parcel B, commissioned by the chair (Claude Fable 5),
2026-08-10
