# EVALUATION.md — Stranger Implementation /0 (FROZEN PRE-REGISTRATION)

*Frozen 2026-07-23, BEFORE the seat fires. No stranger output exists at
freeze time. Every band, rule, and check below is committed in advance;
nothing here may be adjusted after any round's transcript is seen. The
custodian evaluates against this document and only this document. Written
by ARBITER (evaluation-designer agent) under the custodian's charge;
governing skeleton: `CHARGE.md` §§Evaluation, Freeze-and-reveal,
Boundaries (referred to below by the charge-plan numbering §5–§9).*

**Standing rule of this document:** an observation is evidence only if it
is exhibited — a receipt field value, a transcript line, a byte in the
program. "The program clearly understands X" is not an observation. Where
a rule below cannot be decided from exhibits, the field carries reduced
confidence and says so; that is recorded, not papered over.

**Charge guardrails, verbatim, restated here so they sit next to the
rules they bind:** the result is "never a pass/fail badge, never
'standalone language earned,' never 'difficulty ⇒ Slice /0 failed.'"
(CHARGE §Evaluation.)

---

## §1. Frozen evaluation questions (CHARGE §5)

Each dimension gets: the question(s) answered from transcript + program +
report, and the specific evidence to record. Answers use the §2
vocabulary only.

### 1.1 Documentation sufficiency

**Questions.** Did `LANGUAGE-SLICE-0-GUIDE.md` + `LANGUAGE-SLICE-0-API.md`
alone carry a competent CL programmer from zero to a working front-door
program? Where they failed, did they fail by *omission* (a needed fact
absent), by *ambiguity* (a stated fact readable two ways), or by
*misleading* (a stated fact that pointed the wrong way)?

**Evidence to record.**
- Every round-boundary correction: what the round-N transcript taught
  that the documents had not. Classify each as omission / ambiguity /
  misleading, citing the document line that should have carried it.
- Every guessed convention listed in `IMPLEMENTER-REPORT.md` ("every
  place you had to guess an argument convention"), checked against the
  API brief: was the answer actually in the brief (stranger missed it)
  or genuinely absent (document gap)?
- **Pre-registered expected friction locus:** the PROVISIONAL
  accepted-representations wart — a default-constructed
  `receiver-context` (`:accepted-representations '(:full)`) refuses a
  `:direct` datum transmission (`receiver-representation-unsupported`).
  The API brief states this three times (standing note, §5 mode map,
  §10). If the stranger hits it: record whether the brief's warning was
  read-and-missed or read-and-applied. Hitting it *despite the warning*
  is evidence about document design (warning placement), not about the
  stranger. This locus is pre-registered so that its appearance in a
  transcript is not retro-fitted into whichever story the evaluation
  wants.

### 1.2 Semantic generalization — THE EIGHT DISTINCTIONS

**Question.** Did the stranger's program *preserve* the semantic
distinctions the fragment exists to enforce — in a novel domain the
specimens never touched — or did it only transliterate the Guide's worked
example while violating them at the joints the Guide does not exemplify?

**Named limit of this dimension (flinch discipline).** The Guide contains
a complete worked end-to-end example. A stranger can adapt that example's
*shape* to the dataset domain without holding any distinction. The
discriminating evidence therefore lives in the places the Guide does NOT
exemplify: the representation wart, receiver-side minting, the
`insufficient-support-kind` axis, the residue accessors, the ordering of
repair acts. Where a distinction's only exhibit is a pattern the Guide
already showed verbatim, score it at reduced confidence and say so.

For each distinction: **(a)** what preservation looks like in the program
(real symbols), **(b)** the counterfeit — what a faking program looks like.

**D1. Execution vs judgment.**
(a) Running the validator (via `dataset-lab:make-row-validator` directly,
or wrapped in a `local-value` and driven by `exercise-value`) is treated
as *producing evidence* — witnesses, `derived-result`s — and standing
arrives ONLY through `raise` against a `promotion-procedure` whose
descriptor has `:judgment-class :semantic`. Exhibits:
`(claim-judgment c)` is `NIL` on every claim before its `raise`; the
granted path shows `(promotion-receipt-decision r)` ⇒ `:GRANTED` and
`(judgment-record-judgment (claim-judgment rev))` ⇒ `:VERIFIED`.
(b) Counterfeit: a CL boolean or keyword (`admissible-p`, `:verified`
in a plain variable) set after the validation loop and *printed as the
verdict*, with `raise` either absent or performed as decoration after the
program has already committed to the answer; or the `summarize` output
itself narrated as "the verification."

**D2. Testimony proposition level.**
(a) Any testimony in the program (step 9 option, or the payload of
`transmit … :mode :testimony`) carries the second-order attribution: a
`:testimony`-mode witness's `witness-for` is `(:asserted <who> P)`, and
the testimony-mode `transmit` payload is an attribution *claim* whose
`claim-proposition` begins `(:asserted …)`. Any reviewer-side use of
testimony supports the *attribution* proposition, not P itself — or is
admitted by a procedure that explicitly `:admits '((:testimony <kind>))`
for an attribution-level claim.
(b) Counterfeit (two forms): (i) `(witness :for P :mode :testimony …)` —
unrepresentable, signals at construction (teeth-check 2 proves the gate
fires); (ii) the *compiling* dodge — a `:direct`-mode witness whose
content and source are merely the lab's say-so (e.g. `:kind :report`,
`:source :lab`, `:content '(:the-lab-says-its-fine)`), offered as
first-order support for P at the reviewer. Form (ii) passes the language;
catching it is a custodian judgment read of provenance vs mode.
**Confidence: moderate for form (ii); state which form was assessed.**

**D3. Receiver-relative reconstruction.**
(a) The reviewer's standing comes from the reviewer's *position*:
`project-claim … :from <lab> :to <reviewer> :store (support-store …)`
yields a projected claim whose `(claim-judgment theirs)` is `NIL` when
the reviewer cannot re-derive it; the final reviewer-relative
admissibility standing traces to a `raise` executed against evidence the
*reviewer's* context can access/recognize/run — visible as a
`promotion-receipt` with `decision :granted` whose supports are
reviewer-side witness ids, and/or a `judgment-record-receiver` naming the
reviewer key when `:receiver` was used.
(b) Counterfeit (two forms): (i) the program prints the SOURCE revision's
`(judgment-record-judgment (claim-judgment *verified*))` while narrating
it as the reviewer's state — no reviewer-side promotion-receipt exists;
(ii) the rigged position — the reviewer `receiver-context` is constructed
with `:accessible-supports` containing the *local* witness ids the task
declares unreachable, so projection "preserves" and nothing was ever
inaccessible. Form (ii) is detected by check 1's second observable:
`(projection-receipt-supports-inaccessible receipt)` empty ⇒ no loss was
ever staged ⇒ steps 5–6 not actually performed.

**D4. Inaccessible vs absent.**
(a) The projection receipt's residue is *read and shown*: the program
touches `projection-receipt-supports-inaccessible` (non-empty), or prints
`render-projection-why` output naming the lost witness with its reason
(`-supports-lost` alist), or reads `projection-receipt-obligations`
(`(:export <id>)`) — and the narration says "exists, unreachable here,"
never "does not exist."
(b) Counterfeit: the receipt's second value is `declare (ignore)`d or
never destructured; the transcript narrates the reviewer as having "no
evidence" (absence) or is simply silent about the loss.

**D5. Producer vs product.**
(a) What travels to the reviewer is the *product*: the `summarize` datum,
or a `derived-result` from `exercise-value` (its
`derived-result-producer-id` read as provenance). The producer — the
validator closure / its `local-value` — is shown refused on the `:direct`
path (`value-not-reifiable`, `transmission-receipt-reifiability` ⇒
`:NOT-REIFIABLE`). Narration keeps them apart: the reviewer *has the
summary*, not the validator.
(b) Counterfeit: after a granted product transmission, the program
narrates "the validator is now available to the reviewer," or uses the
shipped summary as if the reviewer could now validate *new* rows with it.

**D6. Equivalence vs identity.**
(a) Anything the reviewer ends up holding — a recipe-reproduction, a
receiver-minted witness (`mint-equivalent-support-at-receiver`, or a
fresh `witness` sourced at the reviewer) — is treated as an *equivalent*,
never the original: distinct `witness-id` (kernel0
`(lisp-plus-kernel0:identity= old new)` ⇒ `NIL`), narration of a
`:reproduction` grant as recipe/rebuild, not arrival of the object.
(b) Counterfeit: printing "the original witness/validator now at the
reviewer" over a reproduction or minted equivalent; asserting id equality
or reusing the *local* witness object in reviewer-side acts as if
position transferred it.

**D7. Exercisability vs possession.**
(a) Capability use is `exercise-value … :in <authorized-context>`,
returning a canonical `derived-result` (optionally minting a witness via
`:mint-for`) — the host object is never extracted (no accessor exists;
the surface has no host getter). If the program stages an unauthorized
exercise, it receives `exercise-not-authorized` (requirement `:exercise`)
and treats that as a contextual refusal.
(b) Counterfeit: reviewer-side progress achieved by directly `funcall`ing
the lab's closure inside code narrated as the reviewer's position. NOTE
the honest limit: `validator.lisp` is plain CL, and *lab-side* direct
funcall is lawful ordinary Lisp — the defect is only the *reviewer-side*
funcall dressed as governed procedure. Positions are narrative in a
single image, so this check reads program structure, not an enforcement
trace. **Confidence: moderate; say what was read.**

**D8. Standing vs transmissibility.**
(a) The two axes never pay for each other: the locally `:verified` claim
projects with its judgment *not* traveling (D3 exhibit), AND the granted
transmission of the summary/product does not by itself confer standing —
the reviewer-relative verdict still requires the reviewer-side `raise`
(a `promotion-receipt` after, and distinct from, the `transmit` grant).
(b) Counterfeit: `(transmission-receipt-decision r)` ⇒ `:GRANTED` on the
summary followed directly by "therefore the batch is admissible at the
reviewer" with no reviewer-side promotion-receipt between them.

**Recording rule.** For each of D1–D8 record: PRESERVED (exhibit cited) /
COUNTERFEITED (exhibit cited) / NOT-EXERCISED (the program never reached
the joint) / UNDECIDABLE-FROM-EXHIBITS (say why). The §2 field
`:semantic-algebra-generalized` is computed from these eight records by
the frozen rule in §2 — not from overall impression.

### 1.3 Public-surface closure

**Questions.** Could the task be completed through exported symbols only?
Did the stranger ever *need* something the surface does not export — and
if so, did they stop and name it (TASK's stop rule) or route around it?

**Evidence to record.** `check-front-door.py` output on every round's
program; any stranger statement naming an unreachable operation; whether
any such statement is *correct* (custodian verifies against the API brief
— a claimed gap that the brief actually covers is a documentation or
comprehension finding, not a closure finding).

### 1.4 API burden

**Questions.** How much of the 161-symbol surface did the task require?
Which symbols did the stranger use, consider-and-reject, or wish existed?

**Evidence to record.** `:exports-used` counted mechanically from the
final program (distinct exported `lisp-plus-slice0:` +
`lisp-plus-kernel0:` symbols referenced; count once per symbol; the
custodian's count, not the report's). The report's wished-for
conveniences, verbatim — these are Slice /1 pressure raw material (§5),
recorded without endorsement.

### 1.5 Governed-act composition

**Questions.** Did the program *compose* the four verbs — output of one
act feeding another (exercise → witness → raise → project → transmit →
receiver raise) — or execute them as four disconnected demos?

**Evidence to record.** The dataflow: does the witness `raise` consumes
come from the validator run (e.g. `exercise-value`'s `:mint-for` witness
or a `witness` whose `:content` is the validation product)? Does
`project-claim` receive the *raised revision* and a `support-store` built
from the actual load-bearing witnesses? Does the reviewer-side `raise`
consume reviewer-accessible evidence produced by a lawful alternative
(step 9)? Composition = the receipts chain; demo-mode = each act built on
fresh throwaway inputs.

### 1.6 Host-boundary visibility

**Questions.** Did the stranger understand what the fragment does and
does NOT claim (architecture §8's four strata — evaluated against the
Guide's own "Claim ceiling" statements, since the stranger has not seen
the architecture record pre-reveal)? Concretely: does the program or
report claim the language *prevents* host escape, or attempt a host-level
workaround when refused?

**Evidence to record.** Any report sentence characterizing the
guarantees (quote it; grade it against the Guide's Mistake-4 ceiling:
"Slice /0 makes the governed path refuse and receipt; it does not make
the host incapable"); any program response to a refusal that reaches for
host machinery (printer, string round-trips, package tricks) rather than
a lawful restart or a different governed act.

---

## §2. Result vocabulary (CHARGE §6)

The result is exactly this plist, committed in `CUSTODIAN-RESULT.md`:

```lisp
(:stranger-implementation-0
 :task-completed              <v>
 :guide-sufficient            <v>
 :api-sufficient              <v>
 :front-door-only             <v>
 :semantic-algebra-generalized <v>
 :governed-acts-composed      <v>
 :tacit-knowledge-dependence  <v>
 :exports-total               161
 :exports-used                <integer>
 :host-boundary-understood    <v>
 :slice-1-pressure            <candidate-keyword or :none>
 :rounds-used                 <1..5>
 :teeth-checks-fired          <n/8>)
```

Allowed `<v>` values: `:validated` / `:partially-validated` /
`:not-validated` / `:blocked` / `:not-tested`. Decision rules, frozen:

**`:task-completed`**
- `:validated` — final round exits 0 under the exact TASK command, and
  all ten TASK steps are individually identifiable in the transcript
  (custodian checks the ten off by name, citing the transcript line for
  each).
- `:partially-validated` — exit 0 with 7–9 steps identifiable, or all
  ten identifiable with a nonzero exit caused by a step the program
  itself reports honestly as a finding.
- `:not-validated` — ≤6 steps identifiable at round-5 freeze, and no
  lawful block was declared.
- `:blocked` — the stranger invoked the TASK stop rule, naming the exact
  operation/relation it could not reach, and the custodian confirms the
  program stops there rather than working around it. (A *wrong* block
  claim — the operation exists and is documented — is `:not-validated`
  here and evidence under §1.1/§1.3.)

**`:guide-sufficient` / `:api-sufficient`**
- `:validated` — zero round-boundary corrections attributable to that
  document's omission/ambiguity/misleading (guessed-and-right does not
  count against; §1.1 classification governs).
- `:partially-validated` — corrections occurred but every one was
  recoverable from the raw transcript within the round limit.
- `:not-validated` — a document gap ended the task (`:blocked` or
  round-5 freeze traces to it).
- Attribution rule: a correction counts against the document that should
  have carried the fact; a fact present in the document but missed by the
  stranger counts against neither (recorded as reader-miss under §1.1).

**`:front-door-only`**
- `:validated` — `check-front-door.py` clean on the FINAL program AND
  the custodian's manual sweep (teeth-checks 6/7 procedures) finds
  nothing.
- `:partially-validated` — a violation appeared in an intermediate round
  and was gone by the final program.
- `:not-validated` — any violation in the final program (a single `::`,
  one internal symbol, one slot-`setf`, one stringified transmission —
  no de-minimis threshold).

**`:semantic-algebra-generalized`** — computed from the eight D-records:
- `:validated` — all eight PRESERVED (UNDECIDABLE counts as not
  preserved for this rule; reduced-confidence PRESERVED counts, flagged).
- `:partially-validated` — 5–7 PRESERVED and zero COUNTERFEITED.
- `:not-validated` — ≤4 PRESERVED, or ANY distinction COUNTERFEITED
  (one counterfeit poisons the field: a program that fakes one
  distinction cannot be credited with "generalizing the algebra").
- NOT-EXERCISED distinctions are listed by name next to the value.

**`:governed-acts-composed`**
- `:validated` — all four verbs present and the §1.5 dataflow chains
  from validator run to reviewer-side verdict.
- `:partially-validated` — all four verbs present but ≥1 link is
  demo-mode (throwaway inputs).
- `:not-validated` — a governed verb missing where a TASK step requires
  it, or no chaining at all.

**`:tacit-knowledge-dependence`** — polarity: measures the CLOSURE
DOCUMENTS, not the stranger; low dependence is the good outcome.
- `:validated` — no evidence anywhere that completing the task required
  knowledge outside the packet (all guesses either resolved by documents
  on re-read, or were generic CL).
- `:partially-validated` — the stranger needed transcript-driven
  discovery of behavior the documents underdetermine (each instance
  named).
- `:not-validated` — the task demonstrably required specimen-author
  knowledge absent from the packet (the instance named and shown).
- Confidence note, standing: this field leans on the stranger's
  self-report plus round transcripts; self-report about one's own
  inference process is testimony (lab rule: the witness is the store —
  here, the `rounds/` archive is the store; where report and rounds
  disagree, rounds govern).

**`:exports-used`** — mechanical count (custodian's, from the final
program bytes). No band; the number is the result.

**`:host-boundary-understood`**
- `:validated` — report characterizes the guarantees within the Guide's
  claim-ceilings; no host-workaround attempts in any round.
- `:partially-validated` — an over- or under-claim in prose, but no
  workaround in code.
- `:not-validated` — any round's program answers a governed refusal with
  a host-level bypass.

**`:slice-1-pressure`** — see §5. Value is one of the six candidate
keywords or `:none`.

**Forbidden inflations (guardrails, binding on the custodian):**
1. Success on this task is NOT converted into "standalone language
   earned." The task exercises one embedded fragment through a curated
   packet; the result vocabulary above is its entire meaning.
2. Difficulty, failure, or block is NOT converted into "Slice /0
   failed." A blocked stranger is a *finding about the closure
   documents and surface*, recorded in the fields above; the slice's own
   banked verdicts stand untouched (CHARGE §Boundaries).

---

## §3. THE EIGHT TEETH-CHECKS (CHARGE §7)

**⚠ EVALUATION-ONLY MATERIAL. Nothing in this section — snippets,
observables, procedures — may appear in anything the stranger sees, in
any round, including the relay transcripts. The planted-defect snippets
exist so the custodian can prove the checks fire; they are never sent.**

**The teeth-principle:** a check that would pass a defective program is
not a check. Before ANY result is accepted, the custodian runs each
planted defect below through its stated procedure and records that the
check catches it (`:teeth-checks-fired n/8` in the result plist). A gate
that has never caught a plant is untested, not passing. Runtime snippets
are run under the same SBCL 2.4.6 load as the task; static snippets are
run through the static procedure. Snippets assume the ambient definitions
of a worked context (a `:semantic` procedure `*proc*`, lab/reviewer
contexts `*lab*`/`*reviewer*`, a validator `local-value` `*validator-lv*`,
a raised revision `*verified*`, a witness `*w-validate*`) — each marked
[RUNS] (expected to compile and behave as stated), [SIGNALS] (expected to
signal — that IS the catch), or [STATIC] (never executed; bytes only).

### Teeth-check 1 — copied receiver judgment

**(a) Plant** [RUNS]:
```lisp
(multiple-value-bind (theirs receipt)
    (project-claim *verified* :from *lab* :to *reviewer*
                   :store (support-store *w-validate*))
  (declare (ignore theirs receipt))
  ;; DEFECT: reports the SOURCE revision's judgment as the reviewer's state
  (format t "reviewer verdict: ~a~%"
          (judgment-record-judgment (claim-judgment *verified*))))
```
Variant plant (rigged position) [RUNS]: construct the reviewer as
`(receiver-context :context-id :reviewer :accessible-supports (list (witness-id *w-validate*)) …)`
so projection loses nothing.
**(b) Observable.** No reviewer-side `promotion-receipt` with
`decision :granted` exists anywhere in program or transcript; the printed
"reviewer verdict" is sourced from `(claim-judgment *verified*)` (the
source revision). Variant: `(projection-receipt-supports-inaccessible receipt)`
is `NIL` — no loss was ever staged.
**(c) Procedure.** Trace the final reviewer-relative verdict backward:
it must be the `judgment-record` of a claim returned by a `raise` whose
promotion-receipt the transcript shows `:GRANTED` on reviewer-accessible
evidence (and, where `:receiver` was passed, `judgment-record-receiver`
= the reviewer key). Additionally require the mid-program projection to
show non-empty `supports-inaccessible`. Either trace failing ⇒ defect.

### Teeth-check 2 — testimony flattened into direct support

**(a) Plant** [SIGNALS — the catch is the constructor refusing]:
```lisp
;; DEFECT: first-order testimony — :for is P, not (:asserted <who> P)
(witness :for '(:admissible "batch-a")
         :mode :testimony :kind :report :source :lab)
```
**(b) Observable.** `malformed-slice0-shape` signaled at construction
with `(slice0-condition-requirement-id c)` ⇒
`:TESTIMONY-PRESERVES-PROPOSITION-LEVEL`. In a stranger program: every
`:mode :testimony` witness's `witness-for`, and every testimony-mode
`transmit` payload's `claim-proposition`, must begin `(:asserted …)`.
**(c) Procedure.** Run the plant; record the signal (proves the gate has
teeth). Then sweep the stranger program: (i) grep every `:mode :testimony`
construction and check its `:for` shape; (ii) for the compiling dodge —
a `:direct` witness whose source/content is merely another position's
say-so offered as first-order support for P — read provenance vs mode by
hand and grade under D2 form (ii). **The (ii) half is a judgment read;
its catch-rate is not guaranteed by the language and is recorded at
moderate confidence.**

### Teeth-check 3 — non-reifiable object stringified and called transmitted

**(a) Plant** [RUNS to the defect; the inner transmit may itself refuse
on representation — either way the bytes convict]:
```lisp
;; DEFECT: a string wearing a capability
(let* ((impostor (format nil "~a" (dataset-lab:make-row-validator)))
       (lv (local-value :host impostor :authority :lab)))
  (transmit lv :from *lab* :to *reviewer* :mode :direct)
  (format t "validator transmitted to reviewer~%"))
```
**(b) Observable.** `(format nil "~a" <closure>)` (or `princ-to-string`
/ `prin1-to-string` / `write-to-string` on a function value) in the
bytes, feeding a `local-value :host` or any transmit path; the resulting
`local-value-kind` is `:DATUM` (a string) while the narration says
"validator"; no `value-not-reifiable` refusal appears for the "transfer"
that allegedly moved the capability.
**(c) Procedure.** Static sweep for stringification of function-valued
expressions feeding admission/transmission (this is one of the patterns
`check-front-door.py` must flag; final ruling is the custodian's read of
each flagged site). Cross-check dynamically: the genuine step-7 attempt
must show `transmission-receipt-reifiability` ⇒ `:NOT-REIFIABLE` on the
actual closure-kinded `local-value` — a program whose only "capability
transfer" was granted has, by that very grant, shipped an impostor.

### Teeth-check 4 — inaccessible support marked absent

**(a) Plant** [RUNS]:
```lisp
(multiple-value-bind (theirs receipt)
    (project-claim *verified* :from *lab* :to *reviewer*
                   :store (support-store *w-validate*))
  (declare (ignore receipt))          ; DEFECT: residue dropped
  (format t "reviewer position: claim ~a — no supporting evidence exists~%"
          (claim-proposition theirs)))
```
**(b) Observable.** The projection receipt's loss fields are never read:
no call to `projection-receipt-supports-inaccessible`,
`projection-receipt-obligations`, `render-projection-why`, or the
`projection-explanation` `-supports-lost` accessor anywhere downstream of
the projection; transcript narrates absence ("no evidence exists") where
the receipt records residue.
**(c) Procedure.** Require, for TASK step 6, an exhibited non-empty
residue: the transcript must contain either the value of
`projection-receipt-supports-inaccessible` (≥1 witness id) or a
`render-projection-why` block naming the lost witness with reason. A
program whose transcript lacks both, or whose narration asserts absence,
fails.

### Teeth-check 5 — receiver-local equivalent called identical

**(a) Plant** [RUNS]:
```lisp
(multiple-value-bind (recipe r)
    (transmit *validator-lv* :from *lab* :to *reviewer* :mode :reproduction)
  (declare (ignore r))
  ;; DEFECT: the recipe (data) narrated as the object itself
  (format t "the validator itself has now arrived at the reviewer: ~s~%"
          recipe))
```
**(b) Observable.** A `:reproduction` grant (payload = recipe data) or a
receiver-minted witness narrated as arrival/possession of the original;
where both a local and a receiver-side support exist,
`(lisp-plus-kernel0:identity= (witness-id local-w) (witness-id reviewer-w))`
⇒ `NIL` — distinct objects — while the transcript claims identity.
**(c) Procedure.** For every step-9 alternative: classify the payload by
its receipt (`transmission-receipt-requested-mode`, payload type) and
compare against the program's narration of it. Any sentence asserting
the *original* witness, validator, or capability itself reached the
reviewer — over a reproduction, testimony, derived-result, or minted
equivalent — is the defect. (Language-side note: nothing in the surface
refuses the *sentence*; this check is custodian-side by design, which is
exactly why it is pre-registered.)

### Teeth-check 6 — internal symbol / `::` access

**(a) Plant** [STATIC — not executed; not claimed to compile]:
```lisp
;; DEFECT: package-internal reach
(lisp-plus-slice0::%refuse-transmission)
(print lisp-plus-slice0::*slice0-ordinal*)
```
**(b) Observable.** The two-character sequence `::` in the program bytes;
any `lisp-plus-slice0:`/`lisp-plus-kernel0:`/`dataset-lab:` qualified
reference whose symbol is not in the exported set (the API brief's 161
plus `dataset-lab`'s three plus the documented kernel0 four).
**(c) Procedure.** `check-front-door.py` (built in parallel; it is the
enforcement path) must catch: (i) any `::` occurrence in code (string
and comment occurrences flagged for manual ruling — prose `::` is noted,
code `::` fails); (ii) any single-colon qualified symbol not in the
export lists. The custodian additionally runs a raw `grep -n '::'` as
belt-and-braces. TASK states the rule as "no `::` anywhere" — the flat
byte rule governs; the manual ruling can only downgrade a comment-only
occurrence to a note, never excuse one in code.

### Teeth-check 7 — direct slot mutation replacing `raise`

**(a) Plant** [STATIC — expected NOT to compile under SBCL (read-only
struct slots define no setf expander); the check is on bytes, so
compilation is irrelevant]:
```lisp
(defparameter *c*
  (lisp-plus-slice0:claim :proposition '(:admissible "batch-a") :by :lab))
;; DEFECT: standing by assignment
(setf (lisp-plus-slice0:claim-judgment *c*) :verified)
```
**(b) Observable.** A `setf` (or `psetf`/`rotatef`/`shiftf`) whose place
is any documented Lisp+ accessor (`claim-*`, `witness-*`,
`judgment-record-*`, `*-receipt-*`, `local-value-*`, `derived-result-*`,
`receiver-context-*`, `promotion-procedure-*`, `why-*`,
`projection-explanation-*`).
**(c) Procedure.** `check-front-door.py` must flag any mutation form
whose place expression's operator is one of the exported accessor names
(the API brief's accessor tables are the authoritative name list). The
runtime backstop — SBCL erroring on the attempt — is noted but NOT
relied on: a defective program might wrap the attempt in `ignore-errors`
and proceed on the pretense; the static catch fires either way, and any
`ignore-errors`/`handler-case` swallowing around such a form is recorded
as an aggravating exhibit.

### Teeth-check 8 — prose explanation without a structured receipt

**(a) Plant** [RUNS]:
```lisp
(handler-case
    (raise (claim :proposition '(:admissible "batch-a") :by :lab)
           :to :verified :per *proc*
           :considering (list *w-file-opened*))   ; support for the WRONG proposition
  (wrong-proposition-support (c)
    (declare (ignore c))
    ;; DEFECT: hand-written reason; condition's receipt and why discarded
    (format t "REFUSED: the evidence was about opening the file, not admissibility~%")))
```
**(b) Observable.** TASK step 3 satisfied only by a hand-authored
`format` string: no call to `why` / `render-why` /
`render-projection-why` on the signaled condition, its
`slice0-condition-receipt`, or `slice0-condition-why`; transcript's
refusal text lacks the structure-derived shape (`[REFUSED] considered …`
/ `missing relation: …` / `requirements: …` / `lawful repairs: …`).
**(c) Procedure.** For the step-2/3 refusal: require the transcript to
contain a rendering produced by the language (`render-why` output, or
the raw `why` object's fields printed), and the program to obtain it
from the condition or receipt (`(render-why (why c))` or equivalent). A
transcript whose only "why" is prose the program composed fails —
regardless of whether the prose happens to be accurate.

---

## §4. Reveal protocol (CHARGE §8)

Per the charge, verbatim in sequence: **(1)** when the final program
lands, sha256 `STRANGER-PROGRAM.lisp`, the run transcript
(`RUN-RECEIPT.txt`), and the initial `IMPLEMENTER-REPORT.md`; record
digests in `MANIFEST.md`; commit. **(2)** Only then reveal
`LANGUAGE-SLICE-0-ARCHITECTURE.md` and `LANGUAGE-SLICE-0-CLOSURE.md` to
the seat and request the retrospective. **(3)** The pre-reveal report is
preserved unchanged; the retrospective is appended as a separate section
with its own digest. **No edit to the pre-reveal report is permitted for
any reason, including the stranger's own request; corrections live only
in the retrospective.**

**The frozen retrospective questions** (sent to the seat verbatim, all
at once, after reveal; frozen here because the charge locates them in
this document):

1. Having now read the architecture record: which of your design guesses
   were confirmed, and which were wrong? Name specific guesses from your
   report.
2. The architecture records three killed designs — a single standing
   ladder, copied receiver status, and a single exportable boolean. Did
   any of these occur to you as the "natural" design while working? Did
   the public surface stop you from building toward one, and if so,
   where exactly?
3. For each distinction you now see named in architecture §4: did your
   program preserve it because you understood it, or because the API's
   shapes gave you no other path? Be specific — "the constructor refused
   me" is a different answer from "I saw why it must refuse."
4. What in the Guide or API brief would you change, now that you know
   the design intent? What did the architecture record explain that you
   had needed earlier?
5. Does anything in your pre-reveal report now read as wrong to you?
   (State it here; the report itself will not be changed.)
6. Knowing the design, would your program be different? In one paragraph:
   how?

---

## §5. Slice /1 pressure rule (CHARGE §9)

The result plist's `:slice-1-pressure` field is derived **exclusively
from observed stranger friction or failure** — a transcript line, a
report complaint, a block, a round-boundary correction — mapped to a
candidate. Architectural enthusiasm, custodian taste, and "this would be
elegant" are not admissible inputs. **"No candidate received meaningful
pressure" (`:none`) is a lawful result and is recorded without apology.**
The recommendation is explicitly non-authorizing (CHARGE §Boundaries: no
Slice /1 work of any kind).

The six candidates (closure document, ranked there, restated here so the
custodian maps friction → candidate at the end):

1. **`:host-escape-marker`** — explicit host-escape form
   (`with-host-escape`) + static checker. Friction that maps here:
   stranger reaches for, or asks about, host-level moves; the static
   front-door check itself proves burdensome or ambiguous.
2. **`:structured-propositions`** — structured canonical propositions
   (lifting the atomic keyword/string/integer restriction, architecture
   §9). Friction: `malformed-slice0-shape` on proposition shape; the
   stranger fights the bare-symbol/float refusal or contorts domain
   facts to fit the vocabulary.
3. **`:stranger-implementation`** — independently seeded build from the
   brief alone. This experiment IS candidate 3 run against the closure
   documents; it maps here only if the observed friction is "the
   documents cannot carry a stranger at all," i.e. `:guide-sufficient`
   or `:api-sufficient` lands `:not-validated`.
4. **`:receiver-policy`** — receiver-policy refinement / unified policy
   descriptors. Friction: the accepted-representations wart bites (the
   §1.1 pre-registered locus); admissibility-beyond-`(mode kind)` is
   wished for; receiver-context construction is where rounds are lost.
5. **`:package-boundary`** — stronger package/compilation boundary.
   Friction: the stranger accidentally lands on internals, or the
   single-colon discipline proves hard to keep without tooling.
6. **`:process-isolation`** — process-isolated deployment profile.
   Friction: the stranger's report wants guarantees the R3 ceiling
   forbids (and correctly identifies that only isolation would give
   them).

If observed friction maps to multiple candidates, the field carries the
single candidate with the most exhibits and the others are listed in
prose in `CUSTODIAN-RESULT.md`; if exhibits tie, the lower-numbered
(closure-ranked) candidate is named — this tiebreak is frozen now so it
cannot be chosen after the fact.

---

## What this evaluation cannot catch (named at freeze, per lab discipline)

- **Adaptation vs generalization** (§1.2 limit): a transliteration of the
  Guide's worked example can score PRESERVED on several distinctions at
  reduced confidence. The discriminators are the unexemplified joints;
  where the program never leaves the exemplified path, the evaluation
  says so rather than inventing certainty.
- **D2 form (ii) and D7** are custodian judgment reads (provenance-vs-mode
  and narrative-position), not receipt facts. Recorded at moderate
  confidence, always with the exhibit quoted.
- **The stranger's process** is testimony; only the `rounds/` archive is
  the store. Claims in `IMPLEMENTER-REPORT.md` about what was read,
  guessed, or understood are graded against the rounds, and where the
  rounds are silent, marked unverifiable — not assumed.
- **Teeth-check plants prove the checks can fire; they do not prove the
  checks catch every disguise** of the same defect. Each check catches
  the planted form and forms detectable by the same observable; a
  sufficiently novel disguise is a limitation of this pre-registration,
  to be recorded if discovered, never silently absorbed.

---

*Frozen before any stranger output existed. Custodian: Claude Fable 5
(CC seat). Author of record for this document: ARBITER (evaluation
designer), 2026-07-23. Any post-hoc change to this file voids the
pre-registration and must be recorded as such in `CUSTODIAN-RESULT.md`.*
