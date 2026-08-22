# MANY ACTS /0 — PARCEL A RETURN (documentary reconciliation)

STANDING: CANDIDATE PARCEL, returned for owner review. Nothing here is adopted, merged,
published, or independent verification (AP0 Rider 2, binding). **Zero evidence is earned by
this round** — Parcel A repairs the public account of law that already exists; it generates
no implementation, authorship, portability, or inhabitation evidence, and it decides no
constitutional question.

Repaired under **OWNER RULING 2 — POST-R1 DISPOSITION AND PARCEL A ORDER (2026-08-10)**, §4
(authorization), §5 (the ten authorized subjects), §6 (prohibitions), §7 (return
requirements), and Riders 1–6 of the **R1 adoption ruling** filed in this lane.

---

## 1. Base coordinates (exact, adopted)

| | |
|---|---|
| Parcel A base commit | `4bfc5278` — "R1 adoption record: owner disposition addendum (Ruling 2 §2)" |
| Base tree | `0f0612c414fcc3d169c8bd0d75b1fcc4d00e49bc` |
| Base lane subtree (`…/mneme/language-many-acts-0`) | `47a7d41970e49e7de30840eba535f96e781cc3f7` |
| Lineage | `f2ce32fa` (sync.sh hardening, incident `a14bb55d` remedy) → `4bfc5278`; verified with `git merge-base --is-ancestor f2ce32fa 4bfc5278` (true), and `git log f2ce32fa..4bfc5278` shows exactly one commit |
| Adopted R1 identities carried by the base (from the adoption record + receipt beside it, not re-derived here) | R1 predecessor `76952ea4…` · product freeze lane subtree `e94870bd…` · P4 holdout `ef98ede1…` · R1 return `e170e1d6…` with return lane subtree `dd2a7a0a…` · parcel sha256 `54aa7783…a02803` · One Act V-F digest `2b51b4df…` |
| Governing riders | R1 adoption Riders 1–6, unreopened and unstrengthened |

Working location: worktree `/home/gauss/ma0-main`, branch **`ma0-parcel-a`**. Not merged,
not pushed, not published.

## 2. Candidate tip and tree identity

| | |
|---|---|
| **Repair tip** — all repairs; the identity every proof below is computed against | `cca1e26cceadf04dad23ce069974817bf29d7ad3` |
| Repair-tip tree | `2600b40a11485d8d1e940918d79a61f926deef49` |
| Repair-tip lane subtree | `5d40b55a6ba7a46c1a8938210782b9ed15236c85` |
| **Parcel tip** | the commit that adds *this file*, one commit later on `ma0-parcel-a`. **A file cannot carry its own commit hash**; the parcel tip is reported in the returning agent's message and is readable as `git rev-parse ma0-parcel-a`. It changes no subject file — its diff against the repair tip is this document alone, so every §3, §7 and §8 proof holds unchanged at the parcel tip. |

Three repair commits, all on `ma0-parcel-a`, all message-prefixed `MA0 Parcel A:`

1. `fe695541` — lane prose reconciled to adopted R1 (guide §10.9 + continuation rule;
   contract §6 export account; grammar `D-TRUTHY`; failure matrix concordance + disease
   counts; pressure report matcher tooth).
2. `17fc44e3` — comment-only repairs in the scripts and one source (teeth header 159→200
   with derivation, 15 sections, 5 families / 6 invocations; concordance headers 4/72 →
   7/126; disease count distinction; the D5 commit-point comment conformed to Rider 2).
3. `cca1e26c` — R1 fixture commentary `PROVES` → `TESTS WHETHER` (Rider 6); `capture.sh`'s
   *printed* label deliberately retained and registered for Parcel B.

## 3. Changed-file inventory

`git diff 4bfc5278 HEAD --stat` — **15 files, +252 / −50, all inside the lane:**

```
 .../mneme/language-many-acts-0/AUTHOR-GUIDE.md     | 48 ++++++++++++++++---
 .../MANY-ACTS-0-CONTRACT-CANDIDATE.md              | 54 +++++++++++++++-------
 .../MANY-ACTS-0-FAILURE-MATRIX.md                  | 17 +++++--
 .../language-many-acts-0/MANY-ACTS-0-GRAMMAR.md    | 10 +++-
 .../MANY-ACTS-0-PRESSURE-REPORT.md                 |  9 +++-
 .../language-many-acts-0/ma0-concordance.lisp      | 11 ++++-
 .../mneme/language-many-acts-0/ma0-concordance.sh  |  5 +-
 .../mneme/language-many-acts-0/ma0-diseases.sh     | 23 ++++++++-
 .../language-many-acts-0/ma0-environment.lisp      | 33 ++++++++++---
 .../mneme/language-many-acts-0/ma0-teeth.sh        | 45 ++++++++++++++++--
 .../language-many-acts-0/r1/D1-ownership.lisp      |  8 +++-
 .../language-many-acts-0/r1/D2-branch-binding.lisp |  8 +++-
 .../r1/D3-circular-source.lisp                     |  8 +++-
 .../language-many-acts-0/r1/D4-env-crosswire.lisp  |  8 +++-
 .../mneme/language-many-acts-0/r1/capture.sh       | 15 +++++-
 15 files changed, 252 insertions(+), 50 deletions(-)
```

Five of the fifteen are `.md` prose; ten are `.lisp`/`.sh` files in which **only comment
lines changed** (§7 below proves this mechanically).

### The document classes this round used, and why

The ruling's item 10 forbids rewriting historical observations while items 1–9 require
repairing prospective ones. The lane's own adopted convention settles the boundary —
SEAL-ADDENDUM-1 states that "the sealed documents stand as committed; this file records
where the substrate proved their pre-code expectations wrong," and SEAL-ADDENDUM-2 corrects
the RETURN's §2 wording by a **supersession note** rather than by editing the RETURN. So:

- **Class A — evidence, byte-untouched:** `r1/pre-repair/`, `r1/post-repair/`, `p3/`, `p4/`,
  `programs/`, `r1/programs/`, the adoption receipt.
- **Class B — dated returns and findings records, byte-untouched:**
  `MANY-ACTS-0-RETURN.md` (the Round-0 return), `SEAL-ADDENDUM-1`, `SEAL-ADDENDUM-2`,
  `MANY-ACTS-0-R1-RETURN.md`, the adoption record, both owner rulings, `r1/R1-*.md`.
  These report what was observed *when*; their `159` and `4 arms × 72` were true on the day
  and are already reconciled inside the adopted record itself
  (`MANY-ACTS-0-R1-RETURN.md`: "Suite 159 → **200**"; "Coverage closure: **7 arms / 7
  traversed / 126 concordance facets / 0 divergences**").
- **Class C — prospective standing documents and non-printed commentary, repaired:** the
  author guide, contract, grammar, failure matrix, pressure report, and the `#`/`;;;;`
  comments of the lane's scripts and sources.

Nothing in class A or B was touched; §8 proves it.

## 4. Before/after redline — every substantive sentence changed

### 4.1 `AUTHOR-GUIDE.md` §10.9 (authorized item 1)

**BEFORE**
> 9. **The composition is a re-composition, and its concordance is untested.** … Divergence
> from the adopted composer is the lane's most serious possible defect, and the concordance
> teeth that would test it **have not been built**. A green suite says the laws in the suite
> hold. It says nothing about whether this composition agrees with the canonical one.

**AFTER**
> 9. **The composition is a re-composition, and its concordance is TESTED — at a stated
> scope.** … the concordance teeth that test it **have been built and run.**
> `ma0-concordance.lisp` drives an MA0-composed act and the canonical `run-all-arms` act in
> separate images over separate stores and compares them across **all seven adopted arms ×
> 18 enumerated facets = 126 comparisons**; the adopted R1 record reports **7 arms / 126
> facets / 0 divergences** (`MANY-ACTS-0-R1-RETURN.md` §2 coverage closure;
> `MANY-ACTS-0-R1-ADOPTION-RECORD-2026-08-10.md` §4). The comparator also carries its own
> planted-divergence tooth (teeth section 4b), so it has been shown *able* to report a
> divergence rather than merely never having reported one.
>
> **What that still does not say — and this half of the cap is unchanged.** The lane's own
> suite (`./ma0-run.sh`, `ma0-selftest`) does **not** run the concordance teeth: a green
> suite says the laws in the suite hold and says nothing about composer concordance. Run
> `./ma0-concordance.sh`, or the full `./ma0-teeth.sh`, for that. Agreement is over the 18
> enumerated facets and no others, on this substrate, under declared fixtures. Nothing here
> is independent verification, and none of it is adopted usability.

**Note on direction.** This is the one repair that makes the guide say *more* than it did.
It is licensed exactly because the ruling names it (item 1) and because every ceiling that
sentence carried is retained verbatim in the second paragraph: suite-does-not-run-teeth,
18-facets-and-no-others, declared fixtures, not independent verification, not adopted
usability. No claim of portability, independent implementation, or outsider inhabitation is
added or implied.

### 4.2 `AUTHOR-GUIDE.md` §4 — the continuation rule (authorized item 5, F-GUIDE-2)

**BEFORE** — no such sentence existed anywhere in the guide.

**AFTER** (new subsection at the end of §4, "The continuation rule")
> **A returned act does not end the program.** When an `act` step *returns*, its summary is
> bound and **the next step runs — whatever the disposition is**, including `:refused`,
> `:interrupted`, `:host-fault`, and `:mint-refused`. Disposition is *data you branch on*
> (§6), never control flow: the evaluator consults no disposition to decide whether to
> continue. A walk ends in exactly two ways — it reaches a terminal (§7), or a **condition**
> propagates out of it (§7), which is not an outcome at all.
> […] P4 "vindemia" sequences **past a refused act** — arm B-L1 refused and sequenced past
> […] P2 β converts an act-level **mint refusal** into a structured program refusal *with
> the prior acts' history intact* […] The ordering ceiling is the only permitted form of the
> sequencing claim (`SEAL-ADDENDUM-2…`): *a program cannot initiate its dependent next act
> until the preceding One Act invocation has returned its adjudicated structured outcome.*
> Continuation is permitted **after** a return; it is never permitted before one.
> […] So the shape of a program that must stop on a bad act is *branch, then terminate* —
> the stop is something your text says, not something the act does to you.

**Every clause's adopted source, itemized — no clause is derived from un-adopted material:**

| Clause | Adopted source |
|---|---|
| the five disposition values | guide §4's own act-summary table (in the adopted tree) |
| "a condition propagates … never converted into `:completed`" | guide §7, verbatim law already in the guide |
| "terminal ends the walk" | guide §7; grammar §5.3 |
| refused act sequenced past | `MANY-ACTS-0-R1-RETURN.md` §1: P4 "contains three consequential steps (A returned · **B-L1 refused-and-sequenced-past** · C-ii interrupted)" |
| mint refusal → structured program refusal, history intact | `MANY-ACTS-0-RETURN.md` §1.5 |
| the ordering ceiling, verbatim | `SEAL-ADDENDUM-2-PRESSURE-ACCOUNT-RULING.md`, "the only permitted form" |
| "the evaluator consults no disposition" | the adopted evaluator's own behavior, `ma0-eval.lisp` §4 `%ma0-run-act-step`, which binds the summary and returns; the step walk has no disposition-conditional exit |

**What was NOT written.** No statement about what a program *should* do on a bad disposition;
no new refusal code; no claim that continuation is safe, retry-like, or resumable; nothing
about crash or process boundaries. The P5 material in which F-GUIDE-2 was originally minted
lives only on the candidate branch and is **not** cited as governing evidence here — it was
consulted for context only, and no sentence above depends on it.

### 4.3 `MANY-ACTS-0-CONTRACT-CANDIDATE.md` §6 (authorized item 4)

**BEFORE** — heading "## 6. Proposed package / API surface"; "Exports (closed; **the census
gate asserts count and boundness**)"; environment keys "`:root :arms :grants :seat-map
:inputs`"; conditions list ending at "`ma0-composition-divergence`"; no total.

**AFTER** — heading "## 6. Package / API surface"; opening "**`package.lisp` governs; this
section describes it.** … **38 exported symbols**, enumerated … Where this list and
`package.lisp` disagree, `package.lisp` is the surface and this is the error"; environment
keys "`:root :arms :grants :revocations :seat-map :inputs`"; conditions list extended with
"`ma0-environment-stale`" and "`ma0-environment-stale-store-id`"; per-group counts and the
arithmetic `4 + 3 + 2 + 8 + 6 + 11 + 3 + 1 = **38**`; and a closing paragraph:

> ⚠ **There is no export-census gate.** The pre-code draft of this section said "the census
> gate asserts count and boundness"; no such gate was built, and no gate in this lane asserts
> the export count or the boundness of every exported symbol. The 38 above is a *reading of
> `package.lisp`*, not a mechanically enforced floor. (The one mechanical sweep over the
> package's external symbols is `r1/D5-generation-seam.lisp`'s exposure check, which asserts
> that no exported reader exposes the generation — a different obligation.) No census gate is
> proposed here; naming its absence is.

The two missing symbols are the R1/D4 pair. The `:revocations` omission was internal to the
old bullet: its own prose already said "journals declared grants/revocations" while the
keyword list omitted the key; the guide §8 table (adopted) has carried `:revocations` all
along. The census-gate correction is *deflationary* — it removes an assurance the lane never
had, and it proposes nothing in its place.

### 4.4 `MANY-ACTS-0-GRAMMAR.md` §4 (items 6 + 7, Rider 6)

**BEFORE**
> **No truthiness participates anywhere** (disease D-TRUTHY plants it; the witness must go
> red).

**AFTER**
> **No truthiness participates anywhere.** The witness is the selftest scenario
> `w-branch-exact` (5 checks: a non-`NIL` facet holds nothing; the standing must be
> `:present` and the value exact), not a planted disease — **there is no `D-TRUTHY`.** This
> lane's planted-disease inventory is exactly five named families — `D-BOTH-ARMS` ·
> `D-AMBIENT` · `D-AUTO-RETRY` · `D-SKIP-VALIDATE` · `D-SPECIAL-CASE` — exercised through
> six disease/control invocations (`ma0-diseases.sh`; R1 adoption Rider 6 forbids
> substituting either count for the other). The pre-code draft of this line named a sixth
> disease that was never built.

`D-TRUTHY` occurs nowhere else in the repository; `grep -rn "D-TRUTHY"` over the lane now
returns only this corrective sentence.

### 4.5 `MANY-ACTS-0-FAILURE-MATRIX.md` §3 (item 3) and §5 (item 7)

**§3 BEFORE**
> | W-CONCORD-A / -CI / -CII / -BR | for each arm MA0 uses: MA0-composed act vs canonical
> `run-all-arms` act (separate images/stores) agree on: frame kinds present+absent,
> `classify-act-frames` classification, agreement row+verdict, correspondence row+verdict
> (C-arms), unpaired shape (B-R) |

**§3 AFTER**
> | W-CONCORD-A / -BL1 / -BL2 / -BR / -CI / -CII / -D | for **each of the seven adopted
> arms** (the pre-code draft pinned four — A, C-i, C-ii, B-R — and R1 §7 closed the coverage
> to all seven): … agree on **18 enumerated facets** — [full facet list] … **7 × 18 = 126
> comparisons.** A missing facet is RED, not skipped; the comparator carries its own
> planted-divergence tooth |

**§5 BEFORE** — heading row "| Disease | Plants |", no count discipline; the
`D-SKIP-VALIDATE` row named one witness; the `D-SPECIAL-CASE` row promised "W-GENERIC red +
P1/P2 concordance drift".

**§5 AFTER** — a preamble stating the four counts (five families · six invocations · six
controls · twelve executions, "never interchangeable (R1 adoption Rider 6)"); the
`D-SKIP-VALIDATE` row naming **both** of its invocations and carrying the adopted script's
own warning that "W-V-SHAPE unknown program head" **stays green** under the disease and is
named as surviving rather than quietly swapped out; the `D-SPECIAL-CASE` row naming the
single check the built disease actually asserts, with the unbuilt second detector marked as
a pre-code promise.

### 4.6 `MANY-ACTS-0-PRESSURE-REPORT.md` §5 (item 6)

**BEFORE**
> … the heads are not renamed, wrapped, or extended, and divergence teeth compare MA0
> matching against `match-outcome` on identical outcomes.

**AFTER**
> … the heads are not renamed, wrapped, or extended. **What the divergence teeth that were
> actually built compare** is the lane's act *composition*, not its matcher: the concordance
> comparator (`ma0-concordance.lisp`) runs an MA0-composed act against the canonical
> `run-all-arms` act over seven arms × 18 enumerated facets. *No tooth compares MA0's
> matching against `match-outcome` on identical outcomes* — this pre-code line proposed one
> and none was built; the matching law's witness is the selftest scenario `w-branch-exact`.
> Whether a matcher-level comparator should exist is not decided here.

Verified by `grep -rn "match-outcome" *.lisp *.sh` over the lane: **zero hits.**

### 4.7 `ma0-teeth.sh` header (items 2, 3, 6, 7) — comment only

**BEFORE**
> `#   0  LANE SUITE        the lane's own 159 checks, so the teeth are never`
> `#   4  CONCORDANCE       the re-composition against the adopted composer, four`
> `#                        arms, plus the comparator's own planted-divergence tooth`
> `#   5  DISEASES          the five planted diseases and their controls`
> (section list ran 0–7; sections 4b and 8–13 were undocumented)

**AFTER** — section 0 now reads "the lane's own **200** checks" and carries the full
six-term derivation of 200 (§6 below); section 4 reads "**ALL SEVEN** adopted arms x 18
enumerated facets = **126** comparisons (R1 §7 coverage closure; was 4 arms / 72)"; **4b** is
documented as its own section; section 5 reads "**FIVE** named disease FAMILIES … run as
**SIX** disease/control INVOCATIONS … i.e. 6 diseased arms and 6 control arms, 12 witness
executions. The family count and the invocation count are never interchangeable (R1 adoption
Rider 6)"; sections **8–13** are documented; and the header closes "FIFTEEN sections in all
— 0, 1, 2, 3, 4, 4b, 5, 6, 7, 8, 9, 10, 11, 12, 13 — and the adopted R1 record reports 15
attempted / 15 green / 0 red."

The section-0 comment states explicitly: *"The regex below still reads whatever the suite
PRINTS; this comment names the count, it does not authorize it."* No regex, threshold, or
executable line changed.

### 4.8 `ma0-concordance.sh` and `ma0-concordance.lisp` headers (item 3) — comment only

**BEFORE** (both files)
> `Sentinel on the green path: ma0-concordance: 4 arms, 72 facets, 0 divergences`

**AFTER** (both files)
> `Sentinel on the green path: ma0-concordance: 7 arms, 126 facets, 0 divergences` — plus, in
> each, the note that the sentinel is *printed from* `*dens-arms*` and the compared-facet
> counter, "never from this line."

**`ma0-concordance.lisp` setup-audit paragraph, BEFORE**
> … requires the canonical harvest to agree with what that runner prints, on class,
> agreement row, agreement verdict and the frame table, **for all four arms.**

**AFTER**
> … **for all SEVEN arms** — the audit loop reads `*dens-arms*`, so the R1 §7 coverage
> closure carried it from four arms to seven along with everything else.

Verified against the code, not assumed: `*dens-arms*` holds the seven adopted arms and the
setup-audit `dolist` iterates it (`ma0-concordance.lisp`, "4. the setup audit").

### 4.9 `ma0-diseases.sh` header (item 7, Rider 6) — comment only

**BEFORE**
> `# Exit 0 iff all five diseases were DETECTED and all their controls were CLEAN.`
> `# Sentinel: ma0-diseases: 5 diseases detected, 5 controls clean`

**AFTER** — a four-count block (five families / six invocations / six controls / twelve
executions, "never interchangeable (R1 adoption Rider 6)"); a corrected exit statement —
"Exit 0 iff **ALL SIX** invocations were DETECTED and **ALL SIX** of their controls were
CLEAN — the exit test is `DETECTED == PAIRS && CONTROLS == PAIRS`, over invocations, not over
families"; and an explicit note that the sentinel's **second** number is printed from the
family constant and so reads "5 controls clean" while six control arms in fact ran clean —
left exactly as it prints, because correcting it would change runtime output, and registered
for Parcel B.

The corrected exit statement is a reading of the script's own condition, quoted from its
code.

### 4.10 `ma0-environment.lisp` commit-point comment (item 8, Rider 2) — comment only

**BEFORE**
> `;; ⚠⚠ THE COMMIT POINT (R1/D5).  EVERY FALLIBLE STEP HAS SUCCEEDED.`
> `;;`
> `;; Nothing below this line can signal: an `incf' of a bound integer,`
> `;; five assignments, and one structure allocation.  That is the whole`
> `;; of the owner's PROPERTY 2 …`

**AFTER**
> `;; ⚠⚠ THE COMMIT POINT (R1/D5).  EVERY SPECIFIED FALLIBLE STEP HAS SUCCEEDED.`
> `;;`
> `;; Below this line stand an `incf' of a bound integer, five assignments,`
> `;; and one structure allocation.  That is the owner's PROPERTY 2 … and it is`
> `;; a property of WHERE THESE FORMS SIT, not of a promise about them.`
> `;;`
> `;; ⚠ READ IT AT ITS ADOPTED CEILING, NOT ABSOLUTELY (R1 adoption Rider 2,`
> `;; 2026-08-10).  An earlier draft of this comment said "nothing below this`
> `;; line can signal", which is too absolute if read as a claim about arbitrary`
> `;; host-resource exhaustion, asynchronous process termination, or failure of`
> `;; allocation itself — `%make-ma0-environment' does still allocate a structure`
> `;; below this line.  The adopted reading is:`
> `;;`
> `;;   No specified Lisp+ refusal or ordinary project-level failure path remains`
> `;;   below the commit point under the /0 public-API threat model.  Host`
> `;;   exhaustion, process death, asynchronous interruption, and failures outside`
> `;;   that threat model are NOT covered.`
> `;;`
> `;; The D5 instrument exercised six public construction-failure modes and found`
> `;; exactly one able to cross the old seam; the repair moved ownership and the`
> `;; other specified fallible operations above this line.  A later hardening`
> `;; round MAY choose to allocate the environment object before committing the`
> `;; generation and the five specials; R1 does not require that additional`
> `;; host-failure guarantee, and this comment does not promise it.`

The adopted-reading paragraph is Rider 2's own sentence, quoted. The maintenance directive
"DO NOT MOVE A FALLIBLE FORM BELOW THIS LINE" is retained unchanged. **The `let`, the `incf`,
the five `setf`s and the `%make-ma0-environment` call are byte-identical** — the diff over
this file contains no non-comment line (§7).

This is the only occurrence of the absolute prose in any prospective artifact. The other two
occurrences are quotations inside class-B records — `MANY-ACTS-0-R1-ADOPTION-OWNER-RULING`
(the owner quoting the defect) and `MANY-ACTS-0-R1-ADOPTION-RECORD` (which already labels it
"a Parcel-A prospective correction") — plus a paraphrase in `r1/R1-REPAIR-NOTES.md`, which is
R1 evidence. All three left byte-untouched.

### 4.11 `r1/D1..D4` fixture headers (item 9, Rider 6) — comment only

**BEFORE** (four files, identical form)
> `;;;; WHAT IT PROVES.  <hypothesis>`

**AFTER**
> `;;;; WHAT IT TESTS WHETHER HOLDS.  (Post-R1 wording, adoption Rider 6, 2026-08-10: this`
> `;;;; header read "WHAT IT PROVES", and the preserved red transcript quotes it with that`
> `;;;; word.  A fixture TESTS WHETHER a defect is present; it proves nothing about the`
> `;;;; repaired state, whose account is the GREEN capture beside the red one.)  The`
> `;;;; hypothesis under test:`
> `;;;;`
> `;;;; <hypothesis, byte-identical>`

`r1/D5-generation-seam.lisp` carries no such header and was not touched.

### 4.12 `r1/capture.sh` (item 9) — comment only, and one deliberate non-repair

The prose line "a header naming … what the run proves" became "… what the run tests whether
holds." The **printed** `PROVES     : $proves` line and the five `proves=` strings are
**unchanged**, with a new comment block giving the reason:

> `# ⚠ THE PRINTED `PROVES     :' LABEL IS RETAINED DELIBERATELY (R1 adoption Rider 6…).`
> `# … it is PRINTED into every transcript and the ten preserved captures in `pre-repair/'`
> `# and `post-repair/' all carry it verbatim.  Changing it would desynchronize the tool from`
> `# the evidence it produced, and altering runtime output is outside a documentary round's`
> `# authority.  Rider 6's actual holding is about QUOTATION: the repeated "PROVES … reachable"`
> `# header must never be quoted as though the repaired version still exhibits the defect …`
> `# Whether the printed label should change at all is registered for Parcel B, not decided here.`

**Gate check performed before deciding, per the order's own instruction:** `grep -rn "PROVES"`
over `ma0-teeth.sh`, `ma0-campaign-gates.sh`, `ma0-diseases.sh`, `ma0-concordance.sh` and the
selftest returns **no gate that matches on the word** — so no adopted gate would have broken.
The string is nevertheless left alone because it is *runtime output*, which §6 places outside
this round.

### 4.13 One further `PROVES` considered and deliberately NOT changed

`ma0-footprint-witness.lisp`: "⚠ AND IT PROVES THE STORE WAS ALIVE. A prefix that did not
grow proves nothing if nothing could have grown it…". Rider 6's substitution is for artifacts
that are *tests being mistaken for proofs*. This sentence is the opposite move — it is the
witness explaining why its own control arm exists. Left unchanged; recorded here so the sweep
is not read as having missed it.

## 5. Edit → contradiction → adopted evidence → authorized item

| # | Edit | The contradiction / stale statement | Governing adopted evidence | Item |
|---|---|---|---|---|
| 1 | guide §10.9 | guide says the concordance teeth "have not been built" | `MANY-ACTS-0-R1-RETURN.md` §2 ("Coverage closure: 7 arms / 7 traversed / 126 concordance facets / 0 divergences"); `…ADOPTION-RECORD…` §4 ("teeth 15/15/0 … concordance 7 arms/126 facets/0 divergences"); `ma0-concordance.lisp` `*dens-arms*` / `*dens-facets*` | 1 |
| 2 | guide §4 continuation rule | the guide never states the rule normatively | `MANY-ACTS-0-R1-RETURN.md` §1 (B-L1 refused-and-sequenced-past); `MANY-ACTS-0-RETURN.md` §1.5; `SEAL-ADDENDUM-2` ceiling; guide §4 + §7; `ma0-eval.lisp` `%ma0-run-act-step` | 5 |
| 3 | teeth header §0 | stale `159` | selftest sentinel `ma0-selftest: 200 checks, 0 failures`; `MANY-ACTS-0-R1-RETURN.md` §2 ("Suite 159 → 200"); adoption record §4 (200/0 twice, byte-identical bodies) | 2 |
| 4 | teeth §4, concordance `.sh` + `.lisp` headers, matrix §3 | stale `4 arms / 72` | `*dens-arms*` (7) × `*dens-facets*` (18) = 126, read from the adopted source; R1 return §2; adoption record §4 | 3 |
| 5 | teeth header, matrix §5, grammar §4, diseases header | families and invocations conflated; a sixth disease named that does not exist | `ma0-diseases.sh` (5 named families, 6 `run_disease` invocations, `DISEASE_COUNT=5`, `PAIRS`); R1 adoption Rider 6 | 7 |
| 6 | teeth header section list | sections 4b and 8–13 undocumented; "15 sections" nowhere in the file that has them | `ma0-teeth.sh`'s own `section` calls; adoption record §4 ("teeth 15/15/0") | 6 |
| 7 | contract §6 | export account omits `ma0-environment-stale`, `ma0-environment-stale-store-id`, `:revocations`; asserts a census gate that does not exist | `package.lisp` (38 exported symbols, enumerated); absence of any census gate confirmed by grep over the lane | 4 |
| 8 | grammar §4 / pressure report §5 | teeth described that were never built (`D-TRUTHY`; a `match-outcome` comparator) | grep over the lane: zero occurrences of either; `w-branch-exact` is the built matching witness | 6, 7 |
| 9 | `ma0-environment.lisp` commit-point comment | "Nothing below this line can signal" is absolute | R1 adoption **Rider 2**, adopted interpretation quoted verbatim | 8 |
| 10 | `r1/D1..D4` headers, `capture.sh` prose | `PROVES` on artifacts that are tests | R1 adoption **Rider 6** | 9 |
| 11 | class A/B files | — | ruling item 10 | 10 (discharged by non-action; §8) |

## 6. Derived counts, with the arithmetic shown

### 6.1 The suite count: **200**

Derived by counting the check-lines the adopted suite prints, per printed section, from a
run of `mneme/language-many-acts-0/ma0-selftest.lisp` on the Parcel A tip
(`awk` over the transcript, keyed on `^== ` section headers and `^  \[(PASS|FAIL)\]` lines):

| Section group | Sections | Checks |
|---|---|---|
| Validator witnesses | `VALIDATOR WITNESSES (all refusals typed, pre-act, footprint-free)` | 39 |
| Footprint | `W-V-FOOTPRINT` | 2 |
| Immutability | `W-IMMUTABLE` | 11 |
| R1 in-image half | `R1/D1 — OWNERSHIP` 10 · `R1/D1 — THE SOURCE BOUNDARY` 4 · `R1/D2` 6 · `R1/D3` 6 · `R1/D5` 9 | 35 |
| Grep gates | `GREP GATES (each shown able to FIRE before its clean pass is reported)` | 23 |
| Scenarios | p1 17 · p2-alpha 11 · p2-beta 14 · w-no-erase 10 · w-order-store 7 · w-branch-one 7 · w-auth-unfilled 5 · w-branch-exact 5 · w-derive-ne-perform 5 · w-error-propagates 5 · w-error-uncaught 4 | 90 |

**39 + 2 + 11 + 35 + 23 + 90 = 200**, and the R1 sub-sum is
**10 + 4 + 6 + 6 + 9 = 35**, and the scenario sub-sum is
**17 + 11 + 14 + 10 + 7 + 7 + 5 + 5 + 5 + 5 + 4 = 90**. The suite's own tally line reads
`== TALLY: 200 passed, 0 failed ==` and its sentinel `ma0-selftest: 200 checks, 0 failures`.

**What "200" is and is not.** It is the count of check-lines this suite prints in one run,
raised from 159 by R1. It is **not** an authorized floor: the suite's own header declares
that "the count is OBSERVED, not AUTHORIZED … This one has never been accepted by anybody, so
an 'authorized' count here would be a number this hand invented wearing a floor's clothes."
The repaired comment says exactly that.

### 6.2 The concordance count: **126**

Read from `ma0-concordance.lisp`:

- `*dens-arms*` = `("A" "B-L1" "B-L2" "B-R" "C-i" "C-ii" "D")` → **7**
- `*dens-facets*` = `("frames-present" "frames-absent" "classification" "class"
  "act-id-hex" "f2-frontier" "f2-outcome-view" "f2-effect-axis-value"
  "f2-effect-axis-determinacy" "f3-ledger-answer" "f4-runtime-resolution"
  "correspondence-row" "correspondence-verdict" "f5-execution-standing"
  "f5-evidence-class" "agreement-row" "agreement-verdict" "mint-refusal")` → **18**

**7 × 18 = 126**, and the runner itself enforces the product before printing its sentinel:
`(= *compared* (* (length *dens-arms*) (length *dens-facets*)))`. The adopted R1 record
reports 126 facets / 0 divergences.

### 6.3 The export count: **38**

Mechanically enumerated from the `(:export …)` clause of `package.lisp`:

**4** validation + **3** environment + **2** evaluation + **8** result readers +
**6** act-summary readers + **11** conditions and their readers + **3** constants +
**1** runner entry = **38**, matching `grep -oE '^   #:[a-z0-9+-]+' package.lisp | sort | wc -l`
= 38.

### 6.4 The disease counts: **5 / 6 / 6 / 12**

From `ma0-diseases.sh`:

- **5** named families — `D-BOTH-ARMS`, `D-AMBIENT`, `D-AUTO-RETRY`, `D-SKIP-VALIDATE`,
  `D-SPECIAL-CASE` (the constant `DISEASE_COUNT=5`).
- **6** `run_disease` invocations — one each for D-BOTH-ARMS, D-AMBIENT, D-AUTO-RETRY,
  D-SPECIAL-CASE, and **two** for D-SKIP-VALIDATE (once against `ma0-footprint-witness`,
  once against `ma0-selftest`). Each invocation increments `PAIRS`.
- **6** control arms — `run_disease` runs the control before the diseased arm, always.
- **12** witness executions, reported as 12 checks (6 control verdicts + 6 detection
  verdicts). The exit condition is `DETECTED == PAIRS && CONTROLS == PAIRS`.

### 6.5 The teeth section count: **15**

`0, 1, 2, 3, 4, 4b, 5, 6, 7, 8, 9, 10, 11, 12, 13` — counted from the `section` calls and the
two inline sections (1 NO-INTERNALS and 4b CONCORDANCE TOOTH, which tally by hand) in
`ma0-teeth.sh`. Matches the adoption record's "teeth 15/15/0".

## 7. Proof that no implementation or runtime behavior changed

Ten of the fifteen changed files are `.lisp`/`.sh`. Over the whole range, **every added or
removed line in those files is a comment line**:

```
$ git diff 4bfc5278 HEAD -- '*.lisp' '*.sh' \
    | grep -E '^[+-]' | grep -vE '^(\+\+\+|---)' \
    | grep -vE '^[+-][[:space:]]*(;|#)' | grep -vE '^[+-][[:space:]]*$'
(no output)
```

Every changed line in every changed Lisp source or shell script begins, after optional
leading whitespace, with `;` or `#`. Therefore:

- no form, function, parameter, constant, regex, threshold, sentinel, exit condition, or
  printed string changed anywhere;
- no grammar, reader, identifier, keyword, case-folding, canonicalization, Unicode, refusal
  code, or bound changed;
- no NOF or validator semantics changed;
- no evaluator behavior changed.

Corroborated behaviorally by the gates in §9: the selftest prints the same 200/0, the teeth
print the same 15/15/0, and the concordance prints the same 7 arms / 126 facets / 0
divergences as the adopted record reports.

The five `.md` files are prose only and carry no executable content.

## 8. Frozen-artifact proofs

**By absence.** Branch `ma0-parcel-a` descends from adopted main and contains **no PortJ/0
tree at all** and **no `p5/`**:

```
$ git ls-tree -d HEAD experiments/latent-lisp/mneme/portable-judge-0 \
                     experiments/latent-lisp/mneme/language-many-acts-0/p5
(no output — neither path exists on this branch)
```

**By ancestry.** None of the frozen-evidence commits is an ancestor of this parcel's tip:

```
71422395: exists in repo, NOT an ancestor of HEAD     (PortJ/0 frozen originals)
ba2ffe8b: exists in repo, NOT an ancestor of HEAD     (Round P evidence)
572f7edf: exists in repo, NOT an ancestor of HEAD     (Round OA evidence)
```

**By diff scope.** Every changed path is under
`experiments/latent-lisp/mneme/language-many-acts-0/`, and no changed path is inside a
historical or evidentiary directory:

```
$ git diff 4bfc5278 HEAD --name-only -- '*r1/pre-repair/*' '*r1/post-repair/*' \
      '*/p3/*' '*/p4/*' '*/programs/*' '*/r1/programs/*' \
      '*ADOPTION-RECEIPT*' '*ADOPTION-RECORD*' '*OWNER-RULING*' '*RETURN.md' '*SEAL-ADDENDUM*'
(no output)
```

So the ten preserved R1 transcripts, the P3/P4 programs and drivers, the shipped programs,
the adoption record and receipt, both owner rulings, both seal addenda, and both returns are
**byte-identical to the adopted base.** No Round P or Round OA evidence could be modified
from this branch, because none of it is on this branch.

## 9. Gate results, verbatim

SBCL operation-check first, through the wrapper, before any Lisp ran:
`(lisp-implementation-version)` → `2.4.6`, exit 0, binary `/home/gauss/.local/bin/sbcl`.

All gates were run **serially**, from the worktree, on the Parcel A tip, with no other hand
in the tree (F-CONC-1's concurrency discipline).

### Gate 1 — lane selftest (expect 200/0)

```
$ sbcl --script mneme/language-many-acts-0/ma0-selftest.lisp
== TALLY: 200 passed, 0 failed ==
ma0-selftest: 200 checks, 0 failures
exit=0
```

### Gate 2 — full teeth (expect 15 attempted / 15 green / 0 red)

```
$ bash mneme/language-many-acts-0/ma0-teeth.sh
===========================================================================
 MANY ACTS /0 — TEETH TALLY
===========================================================================
  GREEN   0 LANE SUITE  ::  ma0-selftest: 200 checks, 0 failures
  GREEN   1 NO-INTERNALS  ::  ma0-teeth-no-internals: 10 files, 0 hits
  GREEN   2 W-NO-BLIND-REPLAY  ::  ma0-no-blind-replay: 7 checks, 0 failures
  GREEN   3 W-V-FOOTPRINT (program level)  ::  ma0-footprint-witness: 5 checks, 0 failures
  GREEN   4 CONCORDANCE  ::  ma0-concordance: 7 arms, 126 facets, 0 divergences
  GREEN   4b CONCORDANCE TOOTH  ::  ma0-concordance-tooth: 1 planted divergence, 1 detected
  GREEN   5 DISEASES  ::  ma0-diseases: 5 diseases detected, 5 controls clean
  GREEN   6 CAMPAIGN GATES  ::  ma0-campaign-gates: 9 gates, 0 failures
  GREEN   7 W-RES-NOT-AUTH  ::  ma0-res-not-auth: 22 checks, 0 failures
  GREEN   8 R1/D1 OWNERSHIP  ::  ma0-D1-ownership: 6 owned, 0 defect(s) present
  GREEN   9 R1/D2 BRANCH BINDING  ::  ma0-D2-branch-binding: 4 closed, 0 defect(s) present
  GREEN   10 R1/D3 CIRCULAR SOURCE (external watchdog)  ::  ma0-D3-circular-source: 6 closed, 0 defect(s) present
  GREEN   11 R1/D4 ENVIRONMENT CROSSWIRE  ::  ma0-D4-env-crosswire: 4 closed, 0 defect(s) present
  GREEN   12 R1 SEVEN-ARM COVERAGE  ::  ma0-coverage: 7 arms, 7 traversed, 0 uncovered
  GREEN   13 R1/D5 GENERATION SEAM  ::  ma0-D5-generation-seam: 43 closed, 0 defect(s) present

  sections attempted : 15
  green              : 15
  red                : 0
  omitted            : 0

ma0-teeth: 15 sections attempted, 0 red
exit=0
```

**This is the run that proves the item-9 and item-8 comment edits changed nothing
executable.** Section 4's sentinel prints `7 arms, 126 facets` from the code, matching the
repaired comments. Section 5 ran all six disease/control invocations — D-BOTH-ARMS,
D-AMBIENT, D-AUTO-RETRY, D-SKIP-VALIDATE ×2, D-SPECIAL-CASE — each detected, each control
clean at `ma0-selftest: 200 checks, 0 failures`, and the checkout's porcelain was reported
UNCHANGED across the run. Section 1 (NO-INTERNALS) passed over all ten files including the
four whose comments this parcel edited, with its planted-violation tooth shown firing first.
Section 6 carried `W-VF-UNCHANGED` (V-F digest `2b51b4df…`), `W-ONEACT-GREEN` (173/0),
`W-FLOOR-UNTOUCHED`, and the reduced floor.

### Gate 3 — P3 holdout (expect 11/0)

```
$ sbcl --script mneme/language-many-acts-0/p3/run-p3.lisp
ma0-p3-holdout: 11 checks, 0 failures
exit=0
```

### Gate 4 — P4 holdout (expect 11/0)

```
$ sbcl --script mneme/language-many-acts-0/p4/run-p4.lisp
ma0-p4-holdout: 11 checks, 0 failures
exit=0
```

⚠ This is a **rerun**, exactly as the adoption record has it. P4's *first-run* exit code
remains **missing** and is not supplied by this or any later run (R1 adoption ruling, audit
record item 9; execution step 5). Nothing in Parcel A touches that.

### Gate 5 — One Act /0 (expect 173/0, byte-unchanged predecessor)

```
$ sbcl --script mneme/language-act-0/act0-selftest.lisp
== TALLY: 173 passed, 0 failed ==
oneact0-selftest: 173 checks, 0 failures
exit=0
```

One Act /0 was neither read for repair nor written to; its V-F digest gate is inside teeth
section 6 and passed.

## 10. Manifest, per-file hashes, and parcel hash

Not produced here. Per the commission, **manifest generation, per-file hashing and the parcel
hash are the chair's packing step**; this return supplies the tip, tree, and lane-subtree
identities (§2) and the complete changed-file inventory (§3) that the packing step consumes.

## 11. Earned / not earned

**EARNED: nothing. Zero evidence.** Parcel A repaired the public account of law that already
existed. It produced no new program, no new run, no new witness, no new fixture, no new gate,
and no new implementation. Every number it writes down was read out of an adopted artifact
and its arithmetic shown (§6); every sentence it writes cites the adopted source that
licenses it (§4, §5).

**Specifically NOT earned, and not claimed anywhere in the repaired text:** adoption or
adoptability of the lane · independent verification, independent validation, or independent
reproduction · stranger authorship, stranger audit, or outsider inhabitation · guide-only
semantic transmission · independent implementation · portability or portable conformance ·
open-ended authoring or domain generality · multi-environment orchestration ·
transactionality or crash resumability · disease-conserving generativity · machine
authorship. The R1 claim ceiling is unmoved:

> A same-author, post-R1-freeze holdout program was expressible through the repaired Many
> Acts /0 candidate authoring surface without evaluator modification.

**No constitutional question was decided.** None of the 28 deficits was touched. No unwritten
Common Lisp behavior was converted into project law by description. No hidden-bank vector was
created. No J2 instruction was issued. No One Act document was published or adopted. The
public mirror was not touched; nothing was pushed; nothing was merged.

**One repair moved a claim upward** — guide §10.9, from "untested" to "tested at a stated
scope" — and it is the one the ruling names first. Its ceilings are restated in the same
paragraph and §4.1 records the reasoning.

---

## Parcel B handoff list

Each item is something Parcel A found and **did not** repair, with the exact gap that blocks
a documentary fix.

**B1 — The lane-wide standing banner now contradicts the R1 adoption.** Every lane document
opens `STANDING: CANDIDATE. Nothing in this lane is adopted, accepted, frozen, audited, or on
a governing floor`, and `AUTHOR-GUIDE.md` adds `Writing a program against this guide is not a
use of an adopted language.` The R1 adoption ruling makes the repaired base
`OWNER-ADOPTED … the governing repaired Many Acts /0 base`, subject to riders. **Gap:**
repairing the banner requires deciding, per artifact class, what "adopted" now covers — the
product-freeze subtree `e94870bd…` versus the post-freeze evidence additions, the pre-code
seal documents, and the guide *as an authoring surface* — and what standing the *language*
holds as against the adopted *base*. That is a ruling, not a wording fix, and rewriting the
banner without it would be exactly the smuggling §6 forbids. **This is the largest documentary
contradiction in the lane and it is left standing on purpose.**

**B2 — `ma0-diseases.sh` prints "5 controls clean" while six control arms run clean.** The
sentinel's second number is printed from the family constant `DISEASE_COUNT` rather than from
`PAIRS`. **Gap:** correcting it changes the script's runtime output, which Parcel A may not
do. Note for the record: the teeth regex is `^ma0-diseases: [0-9]+ diseases detected, [0-9]+
controls clean$`, so no adopted gate would break — the obstacle is the no-runtime-change
rule alone. Needs an owner decision that a printed sentinel may be made accurate.

**B3 — `r1/capture.sh`'s printed `PROVES     :` label.** Rider 6's licensed change to
prospective *commentary* is done; the printed label is left because the ten preserved
captures carry it verbatim. **Gap:** whether a tool that produced frozen evidence may be
reworded away from that evidence's own vocabulary — a question about evidentiary uniformity,
not about wording.

**B4 — `MANY-ACTS-0-RETURN.md` and `SEAL-ADDENDUM-1` carry `159` and `4 arms × 72` as dated
observations.** Left byte-untouched under item 10 (they are the Round-0 return and the
seal-time findings record; both numbers were true when written, and the adopted record
already reconciles them — R1 return §2). **Gap:** whether a *supersession pointer* — a header
line, with no body sentence altered — may be added to a returned-and-disposed report. That is
a decision about the status of returns. The lane precedent cuts both ways: SEAL-ADDENDUM-2
handled the same problem by writing the supersession note *elsewhere*, which is why nothing
was added here.

**B5 — `V-ATOMS` is named in `MANY-ACTS-0-GRAMMAR.md` §2 with no observable code.** Already on
the owner's Parcel B list; deliberately untouched. Recorded here only so this sweep is not
read as having cleared it.

**B6 — No matcher-level concordance tooth exists.** `MANY-ACTS-0-PRESSURE-REPORT.md` §5
proposed comparing MA0's matching against `match-outcome` on identical outcomes; none was
built. Parcel A recorded the absence in the same sentence. **Gap:** building one is new work,
and whether the matching law needs a comparator beyond `w-branch-exact` is a design decision.

**B7 — No export-census gate exists.** Contract §6's pre-code draft asserted one asserting
"count and boundness". Parcel A recorded the absence. **Gap:** building one is new code, and
fixing the export count as a floor would give the lane an authorized number it has never had.

**B8 — A citation observation in the governing instrument itself.** Owner Ruling 2 §5 item 8
directs prospective D5 prose to be conformed **"to Rider 3"**; the D5 rider is **Rider 2**
(Rider 3 is the D2 sealed-binding law). Parcel A conformed the prose to **Rider 2** — the
rider whose text §5 item 8 then paraphrases, and the rider the R1 adoption record's own
Standing section cites for this correction. Flagged, not repaired: Parcel A may not edit an
owner ruling.

---

— repaired by EMENDATOR (Claude Opus), Parcel A, commissioned by the chair (Claude Fable 5),
2026-08-10
