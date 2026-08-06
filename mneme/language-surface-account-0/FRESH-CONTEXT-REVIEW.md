# Surface Account /0 — Fresh-Context Hostile Review (ADVERSARY seat)

**Date:** 2026-08-04. **Subject:** the Surface Account /0 opening-round return
on branch `surface-account-0-opening`, worktree
`/home/gauss/Desktop/worktrees/surface-account-0`, at design-branch HEAD
`a13546a30384d4c0085704fb5f8d1eb5044a148c`.

---

## 1. Reviewer standing declaration

This is **a same-family cross-check, NOT an independent audit**: fresh context,
same family — Claude Opus reviewing a return authored by Claude Fable 5 +
Claude Opus seats.

I was not present for any of the work below. I read the commission
(`SURFACE-ACCOUNT-0-OPENING-COMMISSION.md`) first and in full, then the return,
then — where a claim was checkable — the predecessor sources, the raw probe
outputs in this session's staging area, and the live repository state. Every
finding below names the exact sentence, cell, line, or clause it attacks and
the exact commission clause it violates. Where I checked something and found it
sound, it is listed in §3 rather than passed over in silence.

I ran only read-only commands. I edited nothing but this file, committed
nothing, pushed nothing, and did not touch `/home/gauss/Desktop/Claude-Code-Lab`
beyond `git rev-parse`, `git status`, `git log`, `git diff --name-only`, and one
`git ls-remote`.

**My own claims ceiling.** Nothing below is independently verified either. It is
one reviewer's reading and remeasurement on one host in one session,
reproducible by re-running the commands quoted.

---

## 2. Findings, most severe first

### F1 — BLOCKING (for the parcel, not for the design)

**The two "final" transcripts are stamped at a commit whose tree does not
contain the probe that produced them.**

*Location.* `…/sa0-parcel-staging/probe/final/probe-transcript.txt` line 1 and
line 536, and `…/controls-transcript.txt` lines 1, 153, 157, 234, 238 — all
carry `PARCEL_TIP 21d9756fab5b6d52e9060128aac9795c7f7c1502`.

*Measured.* On this branch, `21d9756f` is the **first** commit ("custody and
predecessor identities"). The probe sources landed one commit later at
`cff8c03f`; the cartography at `4a6f2890`; the docket, contract and governing
laws at `a13546a3`, which is HEAD. So the stamp names a tree in which
`probes/probe-matrix.lisp` does not yet exist, and three of the four commits on
the branch — including every document the owner will rule on — carry no tested
identity at all.

*Commission clause.* REQUIRED RETURN: "Complete every change before final probe
verification. Define `PARCEL_TIP` as the exact design-branch `HEAD` and name it
at both ends of every final transcript. Require `TESTED_CONTENT_TIP =
PARCEL_TIP`. No post-test commit." PROHIBITIONS: "let a documentation commit
made after testing acquire the tested identity."

*What this is not.* The runner is honest — `run-probe.sh:83` stamps
`git rev-parse HEAD` at run time, so the transcripts truthfully report when they
ran. The defect is sequencing, not fabrication, and the directory name `final/`
is the only thing overstating it.

*Required.* A final re-run at the true frozen `PARCEL_TIP` — after this review,
its response, and every remaining document are committed — with those
transcripts, not these, in the parcel. Note also that
`ARCHITECTURE-DOCKET.md` E1/E2/E3 cite `probe-transcript.txt` by **line number**
(524–530, 383–411, 413–441, 509–523); I verified all four ranges land on the
cited content in the current transcript, so a re-run of unchanged sources should
preserve them — but that must be re-checked after the re-run, not assumed.

---

### F2 — MUST-ANSWER

**The shipped probe labels Surface /2's `VERIFY-RECEIPT` output
`account-derived-check` — the exact label this return's own adjudication argues
is wrong.**

*Location.* `probes/probe-matrix.lisp:356`, producing
`probe-transcript.txt` lines **239, 273, 472, 506**:

> `    public verify-receipt [account-derived-check] PRESENT — returned T`

*The contradiction, in this parcel.* `READER-PROVENANCE-MATRIX.tsv` row 68
labels the same fact `OUT-OF-VOCABULARY:provider-recomputation`.
`REFUSAL-AND-CONDITION-JURISDICTION.md` §7 states the reason in terms:
"Labelling it `account-derived-check` would **transfer the provider's
computation to the account**." `SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md` I.8
requires the label `provider-recomputation-against-live-declarations`. The
evidence file in the parcel carries the forbidden label; the analysis files
carry the right one.

*Commission clause.* FACTS THE DESIGN MAY NOT FLATTEN: "The matrix must label
every observation as exactly one of…"; "Never launder a live declaration into
mint-time history."

*Aggravating.* The S1 arm at `probe-matrix.lisp:244` is labelled `[unavailable]`
— correct. So this is not a uniform pre-adjudication convention that the docket
later refined; it is a one-sided slip that the adjudication then wrote *against*
without correcting its own instrument.

*Required.* Correct the probe source, re-run (F1 forces a re-run anyway), and
state in the response whether any other transcript label disagrees with the
matrices.

---

### F3 — MUST-ANSWER

**Request-object facts are labelled `receipt-stored`, and the ten
`EXPANSION-REQUEST-*` accessors appear nowhere in the provenance matrix.**

*Location.* `probes/probe-matrix.lisp:194, 196, 198` and `:307, 309, 311`,
producing — in **all fourteen** cases of `probe-transcript.txt` (e.g. lines
45–47, 396–398) —

> `    request grammar-version [receipt-stored] 4`
> `    request procedure-version [receipt-stored] 4`
> `    request policy-version [receipt-stored] 1`

These read `EXPANSION-REQUEST-{GRAMMAR,PROCEDURE,POLICY}-VERSION`. They are
fields of the **request** object, not of a receipt. `PROVIDER-API-MATRIX.tsv`
lists ten `EXPANSION-REQUEST-*` externals; `READER-PROVENANCE-MATRIX.tsv`
contains **zero** rows for any of them (checked by grep).

*Why this is the return's own argument turned against it.*
`CARTOGRAPHY-NOTES.md` §10 and `REFUSAL-AND-CONDITION-JURISDICTION.md` §7 argue
— correctly — that a native **refusal** is "a third native artifact… unreachable
from any receipt; `receipt-stored`/`occurrence-stored` would assert a bearer
that does not bear it." The request is a **fourth** artifact and the same
sentence applies verbatim. So the OUT-OF-VOCABULARY census of **13** facts is
under-counted by construction: the one place a request-borne fact is labelled at
all, it is labelled upward into `receipt-stored`, and the rest are simply
outside the matrix.

*Commission clause.* FACTS THE DESIGN MAY NOT FLATTEN (five-label requirement);
EXACT CURRENT LANGUAGE UNION ("Every manifest proposal must keep three roles
separate" — the same non-conflation discipline).

*Required.* Either add `request-stored` as a fourth OUT-OF-VOCABULARY candidate
with the same argument, or state why the request's stored versions genuinely are
receipt-borne. "The receipt stores the same values" is not an answer: the
provenance label names the **bearer**, and the bearer here is the request.

---

### F4 — MUST-ANSWER

**The S2 phase-keying law's positive enumeration misfiles both providers'
integrity alarms as macro-owned, and it legislates with a discriminator the
survey itself showed to be the wrong one.**

*Location.* `REFUSAL-AND-CONDITION-JURISDICTION.md` §4, first bullet:

> "Composite phase-keying is a **closed positive enumeration**: phases
> `:request` and `:perform` are account-owned (species 1). **Every other phase
> is macro-owned (species 3)** — including `EXPANSION` and the match-phase guard
> codes S2's source reserves (`surface2.lisp:1406–1410`)."

*Measured against the accepted tree.* Surface /2's `+refusal-catalog+`
(`surface2.lisp:361–450`) carries **six** phases, not three:

| Phase | Rows | Class the provider itself assigns |
|---|---|---|
| `:request` | 9 | `:protocol-refusal` |
| `:perform` | 7 | `:protocol-refusal` |
| `:expansion` | 7 | `:protocol-refusal` (macro-grammar) |
| `:runtime` | 1 | `:protocol-refusal` |
| `:receipt` | 3 (`:426, :430, :434`) | **`:integrity-alarm`** |
| `:match` | 2 (`:439, :444`) | **`:integrity-alarm`** |

Surface /1's catalog has the same shape: 9 `:protocol-refusal :request`, 8
`:protocol-refusal :perform`, **3 `:integrity-alarm :receipt`**.
`%refuse` (`surface2.lisp:511–526`) signals **all** of them as
`SURFACE2-EXPANSION-REFUSED` — i.e. on exactly the class the composite's
`handler-case` catches. Under the stated law, a `:receipt`- or `:match`-phase
row is not `:request` and not `:perform`, therefore **macro-owned, species 3,
re-signalled as the macro's**. But the composite's own §1 table reserves
species 2 for integrity alarms, and the commission's REFUSAL AND CONDITION
JURISDICTION requires the three species be kept distinct. The law cannot
separate species 2 at all.

*And the right instrument was already in hand.* The refusal object exposes a
public `EXPANSION-REFUSAL-CATEGORY` reader — listed and measured in this
return's own `READER-PROVENANCE-MATRIX.tsv` row 65 — which answers
protocol-refusal-vs-integrity-alarm directly. A sound law needs **both**:
category to split species 2 out, then phase to split 1 from 3. The return uses
phase alone.

*Charged at its true size, not larger.* Every currently *reachable* `:match` and
`:runtime` code fires from **evaluated expansion output**
(`signal-match-guard`, `%require-seat-outcome`), which the composite never
evaluates; every `:receipt` code in both providers is marked
`:internal-planted-fault-only`. So this is an **unsound law**, not a
demonstrated live misroute. It is MUST-ANSWER because it is the specification a
production round would build from.

*Aggravating.* §4 defers the fix to the future: "The production round must
additionally enumerate S2's full phase vocabulary from
`SURFACE2-REFUSAL-CODE-CATALOG`." But the opening survey **already read that
catalog** — `sa0-parcel-staging/cartography/raw-probe.txt:35–62` records
`S2-protocol-refusal-codes`, `S2-integrity-alarm-codes` and
`S2-refusal-catalog-size 29`, from the same public function. The deferred
measurement is precisely the one that would have caught the law, and it was one
accessor (`REFUSAL-CATALOG-ENTRY-PHASE`, already enumerated in
`PROVIDER-API-MATRIX.tsv`) away.

---

### F5 — MUST-ANSWER

**Two commission stop conditions are converted into tolerances by the return's
own authority.**

*Location.* `OPENING-BASE-AND-CUSTODY.md` §6.1, items 2 and 4.

- §6.1(4): "The original checkout's raw status must be byte-identical to §2.2,
  **with one explicitly documented exception**: the `tools/ledger/agents.jsonl`
  line may be present or absent…"
- §6.1(2): "**`origin/main` may lag `main`** by exactly those unpushed
  checkpoint commits."

*Commission clause.* CUSTODY AND OPENING BASE: "Require the original checkout's
raw status to be **byte-identical** before and after"; and "Require lab `HEAD`,
`main`, and `origin/main` to be one exact commit." Followed by: "Any divergence,
unrecorded commit, semantic movement, or predecessor mutation is a **stop
condition**."

*What is true, remeasured by me at review time (read-only):* lab `main` =
`b58ca6191d7893afdcda1f82d5c16f61e5354ac9`; `origin/main` still `c12e96f4`; four
intervening commits, all `checkpoint: 1 file(s) in tools`; `git diff --name-only
c12e96f4..main` = `tools/ledger/agents.jsonl` and nothing else;
`git diff --name-only c12e96f4..main -- experiments/latent-lisp/` empty; raw
status exactly the eight untracked entries of §2.2 with no ` M` line; live
public `main` still `ced1b2ceb13f22cec188c2b3f73dcfc73e7d112e`. **The custody
law is being honoured, and the mechanism is real and pre-disclosed.**

*The defect is jurisdictional, not factual.* A builder may not grant itself
relief from the law it is judged by, however honest the relief. §6.1(4) reads
"disclosed here in advance and **not a waiver invented after the fact**" — true,
and still a waiver. This needs an owner ratification line, or the return must
name the condition as *technically unmet, with the mechanism exhibited*, and let
the owner decide whether to stop.

---

### F6 — MUST-ANSWER

**Two of the seven lifecycle steps are made true by a future commission's text,
not by the design; the return's summary line does not distinguish them.**

*Location.* `SURFACE-3-LIFECYCLE.md`:

- Step 3, positive half: "cloning permission is removed by **the prohibition
  this lifecycle carries into the S3 commission text**."
- Step 6: "the S3 lifecycle text **carries the requirement** that its inhabited
  gates call the Account successor's doors."

*Commission clause.* CONDITIONAL CONTRACT §"Future Surface /3 lifecycle": "The
contract must make this lifecycle **literal** … If the recommended design cannot
make every step true, it has not met the charge." REQUIRED ARCHITECTURE DOCKET:
"exact future Surface /3 lifecycle."

*The mechanism classes are not the same, and the return flattens them.* Steps 1,
5 and 7 are **structural** (closed compile-time manifest resolved by `EQ`;
Door 2 binding recheck failing closed; no registration point anywhere) — these
genuinely are made true by the design, and I accept them. Steps 2 and 4 are
**procedural** and honestly labelled as owner-owned. Steps 3-positive and 6 are
**governance-dependent**: they are true only if a commission that has not been
written says so, and no design can compel that. Yet
`ARCHITECTURE-DOCKET.md` §6 reads "all seven literal steps **shown achievable**"
and `SURFACE-3-LIFECYCLE.md` reads "Every step is made true **as design**."
That is one notch above the evidence for two of the seven.

*Required.* Label each step by mechanism class (structural / procedural /
governance-dependent) so the owner can see at a glance which two steps are
promises about a document that does not exist. The honest-residue section (which
already concedes items 1–3) is the right place, but it does not currently name
*which steps* depend on future text.

---

### F7 — MUST-ANSWER

**The reserved fifth species is a dormant, unfireable branch — state whether it
is contract text or /0 code.**

*Location.* `SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md` I.8, admitted-domain
table, last row: "*(reserved)* Account-owned account | declared for /1; not
implemented in /0". `PROPOSED-API-AND-INTEGRATION-DELTA.md` §1 comment: "+ one
RESERVED Account-owned species for the governed /1 successor."
`ARCHITECTURE-DOCKET.md` §2-D: "The reserved species branch is a declared enum
member, not a seam."

*Commission clause.* REQUIRED ARCHITECTURE DOCKET: "**No dormant mint is
permitted.** … If a recommended lineage needs Account-owned minting only for
future heads, all such code is deferred to the governed Account /1 successor."

*Charged precisely.* A reserved enum member is not a mint, so this is **not a
literal breach**. But if it ships as code in the /0 package it is an admission
branch that **no object in existence can reach**, and by this lane's own standing
rule — "a gate that has never fired is untested, not passing"
(`probes/README.md`; `R4-SURVIVAL-PLAN.md` §4) — it ships untested and
untestable, which is the dead-code analogue of exactly what the rule forbids.

*Required.* One sentence: is the reserved branch (a) contract text only, with the
/0 package's union having four members, or (b) a fifth member in /0 code? If (b),
either exercise it or defer it whole to /1, as the mint is.

---

### F8 — NOTE

**"Refuses anything else" is a universal built on one measured instance, and its
citation is dangling.**

*Location.* `ARCHITECTURE-DOCKET.md` §2, Candidate B, "Accepted object domain"
cell: "a CD/0 identifier occurrence tag (**native Door 1 refuses anything else**
— measured, `CARTOGRAPHY-NOTES.md` §3.2)". Same over-read at
`SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md` I.3 step 1: "(a CD/0 identifier datum;
**both natives refuse anything else** — measured)".

*What was measured.* `CARTOGRAPHY-NOTES.md` §3 item 2: "Both providers refuse a
**string** tag (`:OCCURRENCE-TAG-NOT-IDENTIFIER`, measured)". One host type, not
the complement of one type. The lawful sentence is "both providers refuse a
string tag; the refusal code is `:occurrence-tag-not-identifier`, catalogued at
phase `:request` in both providers" — which is stronger evidence *and* a
narrower claim.

*Also:* `CARTOGRAPHY-NOTES.md` has no `§3.2`; §3 is an unnumbered three-item
list. Dangling reference.

---

### F9 — NOTE

**"Every control runs its planted arm first" is false for Control 4.**

*Location.* `probes/README.md`: "Every control runs its **planted arm first**".
`probes/probe-controls.lisp` header: "EVERY CONTROL HAS TWO ARMS AND THE PLANTED
ARM RUNS FIRST." *Evidence:* `controls-transcript.txt` line 80
(`[PASS] C4 clean: the route detector reports NO mutation`) precedes lines 84–85
(`[PASS] C4 planted: the DETECTOR fires…`).

For a detector-quiescence control, clean-first is the *correct* order — you must
show the detector silent before you mutate. The wording is what is wrong, not the
probe. Soften to "every control shows its planted arm firing; for the route
detector the quiescent arm necessarily runs first."

---

### F10 — NOTE

**The `refusal-record-stored` extension's second justification argues from this
return's own design back onto the commission's vocabulary.**

*Location.* `REFUSAL-AND-CONDITION-JURISDICTION.md` §7, table row 1, second
sentence: "And **this lane's own law (§1, §2) makes retained refusals
first-class account outcomes** — the vocabulary must reach what the jurisdiction
requires retained."

The first half of that cell ("a refusal is a **third native artifact**, the
*alternative* outcome to a receipt, unreachable from any receipt") is
independent of anything this return decided and is sufficient on its own. The
second half makes the commission's vocabulary a function of the builder's design
choice. Strike it or relabel it motivation.

*The extension itself smuggles no standing, and I checked:* the gate "Under no
ruling do any of the 13 facts become `receipt-stored`" is real, and all 13 rows
in `READER-PROVENANCE-MATRIX.tsv` still carry the visible `OUT-OF-VOCABULARY:`
prefix (11 + 1 + 1, confirmed by field count over the label column).

---

### F11 — NOTE

**The truncation *refusal* and the runner's nonzero exit are not captured as
evidence — only the truncated inputs are.**

*Location.* Parcel item 14 requires "the seven controls plus **runner-failure and
truncation transcripts**". Staging holds `probe/run-planted/` and
`probe/trunc-mid.txt`, `probe/trunc-tail.txt`, but no captured
`verify-transcript.sh` stderr and no captured runner exit code.

I exercised the checker read-only and it **has teeth**: it refused
`trunc-mid.txt` on check-line accounting ("claims CHECKS=27 but carries 24"),
refused `trunc-tail.txt` on the missing bottom stamp, refused the planted run on
`PROBE-SECTION-FAIL`, accepted the clean two-section controls file at
`sections=2 checks=46`, and — on a mid-part-A cut I made myself in scratch —
refused correctly across the concatenation boundary. But that is **my** evidence,
produced by me, not the parcel's. Capture the refusal output and the nonzero
exits into the parcel so the teeth are visible to a reader who does not re-run
them.

---

## 3. Attack surfaces explicitly cleared

**(a) Claims ceiling — grep sweep and judgment pass. CLEAR.**
Swept case-insensitively across every `.md`, `.tsv`, `.lisp` and `.sh` in the
lane for: *independently verified / independently validated / independently
audited / independent audit / now correct / implemented / adopted / frozen /
governing / merged / published / closed / complete / wrapper complete / third
machine prevented / verified / validated*, including spaced variants. **Every
hit is either a negation, a scoped disclaimer, a quotation of the commission, or
a correctly-qualified use** ("not implemented", "implemented never in this
round", "not an independent audit", "Nothing here is independently verified",
"closed manifest", "historical closure facts"). The two phrases the commission
names as disqualifying — "wrapper complete" and "third machine prevented" —
appear **zero** times. `ARCHITECTURE-DOCKET.md` §7 and the per-document ceiling
headers each restate the permitted sentence and no more. The judgment pass found
one claim-above-evidence (F8) and two summary lines one notch high (F6); nothing
else.

**(b) The recommendation's obligations. CLEAR on supersession; see F6 on
lifecycle.** The `NATIVE-COMPOSITE SUCCESSOR LAW RECOMMENDED` verdict carries the
per-door supersession/retirement table the commission demands
(`ARCHITECTURE-DOCKET.md` §6): both providers' doors, four columns each — still
callable (yes, closed bytes untouched), gates retained (yes, incl. Erratum 0.2
standing), new work directed where (new callers → composite as *convention, not
retirement*; new heads → governed /1), owner ruling required (none for /0; /1's
opening ruling must adjudicate supersession vs labelled dual authority). The
docket is explicit that "Superseded" and "retired" are **reserved words the /1
ruling may or may not mint" — no live standing is claimed. Five of the seven
lifecycle steps are genuinely made true by the design; the other two are F6.

**(c) The two STOP cells. CLEAR — this is the return's strongest work.**
No sentence anywhere claims 7×2 accounting coverage. The forbidden sentence is
named and banned lane-wide
(`SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md` cross-cutting law 4;
`ARCHITECTURE-DOCKET.md` §3). The limitation is restated in
`ARCHITECTURE-DOCKET.md` §3, `TERM-GRAMMAR-DECISION.md` §5 and §6,
`SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md` I.8 and cross-cutting law 2,
`REFUSAL-AND-CONDITION-JURISDICTION.md` §6, and `probes/README.md`. I verified
the underlying evidence at `probe-transcript.txt` cases 11 (lines 383–411) and
12 (413–441): both refuse with `EXPANDED-TERM-SHARED-STRUCTURE`, phase `PERFORM`,
upstream `TermGrammar / SHARED-OR-CIRCULAR-STRUCTURE / term-encode`, and
`PROBE-SIDE-HOST-MEASUREMENT (DEPTH 10 NODES 221|225 UNINTERNED 13
SHARED-CONSES 3)` — E2's merged citation "NODES 221/225" is an accurate
compression of two lines and is not misleading. The `invoked-no-completion-account`
standing is derived from stored refusal fields and labelled `account-derived-check`,
which is correct (the account computes it; no native artifact bears it).

**(d) Provenance discipline. NOT clear — see F2, F3.** The parts I did clear:
the identity trap is shown, not asserted (`CARTOGRAPHY-NOTES.md` §7 quotes
`surface1.lisp:1073–1076` and `surface2.lisp:786–789`; I opened both and the
quotations are exact, including `(declare (ignore r))`), and it is corroborated
by an argument-irrelevance experiment with a contrast arm (the version accessors
`SIMPLE-TYPE-ERROR` on a non-receipt; the identity accessors answer). Every
`…-RECEIPT-{PROCEDURE,POLICY}-IDENTITY` row in the provenance matrix and every
such line in the transcript reads `provider-current-declaration`, never
`receipt-stored`. Control 6 exhibits the tooth biting (live identity moved,
stored version did not, receipt identity did not move) and records the
uncomfortable corollary honestly — "the public verifier still accepts the receipt
after the redefinition". On the OUT-OF-VOCABULARY extension: it is gated, it
never promotes anything to `receipt-stored`, and the flagged spelling survives in
the matrices — it smuggles no standing (one circular justification, F10).

**(e) The S2 phase-keying law. NOT clear — see F4.** What I *did* confirm: for
the macro-owned case the law is sound and the mechanism is right. S2's
`try-perform-expansion` (`surface2.lisp:941–953`) does return a macro-owned
refusal in the refusal position — I read it — and the composite's cure
(delegate to the **plain** doors, `handler-case` the provider's account-refusal
class, re-signal **the same condition object** when the phase is macro-owned) is
a real cure, not a restatement. Control 7 exhibits the S1 side conserving species
through both the plain and TRY doors. The defect is the partition's treatment of
`:receipt` and `:match`, not of `:expansion`.

**(f) No dormant mint. CLEAR on the mint itself; F7 on the reserved branch.**
Part II is wholly deferred and says so five ways;
`PROPOSED-API-AND-INTEGRATION-DELTA.md` §5 states the delta contains "No
Account-owned mint, grammar, or receipt species". No `.lisp` exists outside
`probes/` (checked with `find`). The nine proposed exports contain no
constructor, no copier, no mutator, and no `VERIFY-RECEIPT` passthrough.

**(g) Repeated-performance adjudication. CLEAR, with a note.** The contract picks
**one** of the three commissioned laws and holds it: `SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md`
I.5 chooses "explicitly structural", carries a `temporal-uniqueness: not-claimed`
field so the absence is stored rather than silent, states that tag-freshness is
convention and **not enforced** (because enforcement needs a forbidden registry),
and states "The composite never writes 'one occurrence' in any record." I grepped
for `one occurrence` across the lane: four hits, all either the commission's own
phrase being quoted or the refusal to use it. Part II picks a *different* law for
the /1 mint (a Door-2-minted fresh occurrence fact) and justifies why the other
two are unavailable — that is a legitimate difference, since /1 owns the mint and
/0 does not. *Note, not a finding:* I.5 declares the natives' identities
structural while conceding the question "was **not measured** this round" and
docketing it as a production-round obligation. Declaring "structural" without the
measurement is itself a small claim about the natives — but it is the
claims-conservative branch (it asserts *less* than temporal uniqueness), the gap
is named in the document that makes it, and the obligation is carried forward in
`R4-SURVIVAL-PLAN.md` §6(i). Acceptable.

**(h) Prohibitions. CLEAR.** No `mneme/language-surface-3/` prefix, no
`LISP-PLUS-SURFACE3`, no Surface /3 system, path, package, form or convenience
API anywhere in the lane (grepped; the only "Surface /3" strings are the required
design document's prose). All six retired census artifacts absent
(`PROBE-CENSUS-LEDGER.tsv`, `PROBE-CENSUS-SUBJECTS.tsv`, `doc-consistency.py`,
`probe-census-validate.py`, `probe-census.sh`, `resolve-subjects.py` — `find`
returns nothing). No registry / plugin hook / MOP / `defgeneric` / generic-method
seam proposed — every occurrence of those words is a prohibition. No
`lisp-plus-surface{0,1,2}::` reach anywhere in the lane (the only two hits are
the banner denying it and `TERM-GRAMMAR-DECISION.md` naming the forbidden form in
order to eliminate a candidate). No production `.lisp` outside `probes/`. Every
probe file and both shell scripts carry the NON-PRODUCTION banner in their own
header, and `probes/README.md` states it literally in six enumerated clauses. No
`eval`/`compile`/`load` of any expansion in the probe (the only `funcall` is a
`handler-case` thunk in Control 5's decode arm). `git diff --name-only
c12e96f4..HEAD` shows **20 paths, all beneath
`experiments/latent-lisp/mneme/language-surface-account-0/`**, zero elsewhere.

**(i) Custody. Substantively CLEAR, jurisdictionally F5.** Remeasured
independently: the four public tree anchors at `ced1b2ce` (I did not re-clone;
I checked the lab side and the live remote ref), the eight protected paths
byte-identical between sealed tip and `OPENING_BASE`, the subject subtree
`6f43791f` at both, public `main` unmoved, the untracked set still exactly eight
entries, all post-`OPENING_BASE` movement confined to `tools/ledger/agents.jsonl`.
`OPENING_BASE` is kept rigorously distinct from the sealed identity throughout —
the three-identity table in §1 is the right shape, and I found no receipt in
which the sealed tip is used as this round's base. The custody document also does
the harder honest thing twice: it retains the superseded pre-housekeeping
snapshot rather than deleting it, and it discloses the two live automatic writers
*before* they fired.

**(j) Internal consistency. CLEAR.** Cross-checked and agreeing: TSV row counts
(178 / 73 / 7) and column counts (13 / 7 / 11) against `CARTOGRAPHY-NOTES.md` §1;
zero empty cells and zero ragged rows in all three; external-symbol counts
80 / 98 and 54 shared print-names with 0 `EQ`; kind tables (S1 condition-types 1,
S2 2) against docket E5; the cross-application arithmetic (72 + 8 + 18 = 98
one-argument + 10 untested = 108) and the 9 distinct print-names × 2 directions
= 18 against docket E7; the provenance-label distribution (30/16/11/6/6/2/1/1 =
73) against §10 and against my own `awk` over the label column; 11 + 1 + 1 = 13
OUT-OF-VOCABULARY facts against docket E9; 12 minted + 2 STOP = 14 cases against
the transcript; the fixture maxima (source 4/47/1511, expansion 8/109/3451)
against every case line — and the maxima block prints its own scope caveat that
the expansion maxima exclude the two refused cells, which is the honest
statement. All four candidate tables in `ARCHITECTURE-DOCKET.md` §2 carry
**exactly the 14 commissioned dimensions**, in the same order, with no dimension
silently skipped. Every source citation I spot-checked is exact:
`surface1.lisp:390, 637, 554–557, 1073–1076, 185–230`;
`surface2.lisp:541, 594, 786–789, 941–953, 1406–1410`. The only citation defect
found is the dangling `§3.2` in F8.

**One thing I want on the record as a positive.** `TERM-GRAMMAR-DECISION.md` §2
is the best-argued page in the return: it eliminates the pinned-S1-codec
candidate under the commission's own rule by **exhibiting the contested step** —
public `ENCODE-TERM`/`DECODE-TERM` signalling non-exported `%TERM-UNREPRESENTABLE`
/ `%TERM-IRRECONSTRUCTIBLE`, with the public docstring naming the private class,
and only one exported condition-type in the whole package — then closes the two
escape routes (`::` and broad `CONDITION` capture) and shows the boundary cannot
be repaired because the predecessor is closed. I opened all five cited lines and
they say what the document says they say. That is a shown verification, not a
claimed one.

---

## 4. Verdict

**RETURN FIT TO PACK AFTER RESPONSES**

The architecture is sound, the elimination arguments are evidenced rather than
asserted, the STOP cells are handled with more honesty than the commission
strictly required, and the prohibitions are clean. Nothing here is a design
defect that changes the recommendation.

What blocks the parcel is F1 — a mechanical sequencing failure that must be
cured by a final re-run at the true frozen `PARCEL_TIP`, after F2 and F3 are
fixed in the probe source (which the re-run will then carry). F4–F7 need written
answers before the owner rules, and F4 needs a corrected law, because it is the
specification a production round would be built from. F8–F11 are notes; F8 needs
two words changed.

— Claude Opus (ADVERSARY, fresh context), 2026-08-04
