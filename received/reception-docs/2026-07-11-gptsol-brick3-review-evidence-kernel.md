# GPT Sol — review of judgment.lisp (brick #3) → "the evidence kernel is brick #4"

*Received 2026-07-11 via Wondermonger. Sol reviewed the judgment/stubbed-infer brick and ruled: do NOT
un-stub infer yet — build the evidence kernel first. Preserved faithfully. This became the spec for
`evidence-kernel.lisp`.*

---

## The achievement + the new seam

"`infer` stops being a mystical aperture and becomes an accountable bureaucrat with a receipt book." The
production/truth distinction now survives the whole route (infer → judgment → claim → check → grade → handoff
→ reconstruction) rather than living as prose. **But: the production-laundering route is blocked; the
witness-laundering route is still open.**

## The witness-laundering hole
`truth-witnessed-p` means "anything that is not explicitly a production receipt counts as truth evidence" —
so `(:dream "it felt correct")`, `(:review-status :beautiful)`, `(:checked-by "a suspicious ferret")` all
promote a claim. And `(witness-by-check (claim '(= median 7)) :observed 9001)` raises the grade without
verifying 9001 supports the proposition. **M2 is strongly enforced; M4 is only ceremonial.** Fix: a typed
witness (id, kind, target, procedure, input, result, verdict, produced-at, authority, replayability,
provenance) + `(witness-supports-p witness claim)` — a witness must TARGET this proposition, use an
admissible procedure, return a supporting verdict, and carry provenance. "A witness does not become evidence
merely because it is standing nearby."

## The motto's qualification
An invocation IS good evidence — for `(emitted :stub-evaluator P :at T)`, not for P. So the law is not
"invocation can never truth-witness" but "invocation witnesses PRODUCTION claims; it cannot be coerced into
evidence for the produced WORLD-claim." The judgment may mint two claims from one receipt: the production
claim (`:observed` by the receipt) and the content claim (`:asserted`). Same receipt, different roles, because
the propositions differ.

## Further corrections
- **Grade vocabulary:** the median check produces `:executed`, not `:observed`. Full set: `:asserted /
  :observed (external state) / :executed (ran a computation) / :tested (over a test set) / :contract
  (enforced) / :derived (proof) / :classified (named classifier)` — different grades, different failure modes.
- **Grade transitions produce history, not mutation:** `(setf (claim-grade ...))` erases the asserted
  ancestor the museum wants to keep. Use `(raise-claim claim witness) => revised-claim + grade-event`
  (claim-id, from, to, witness, at, reason); the revised claim `:supersedes` its forebear. "That is where the
  constitution becomes diachronic rather than merely annotated."
- **Distribution weight is in the wrong organ:** stored in `:vantage`. Weight ≠ vantage. Give the judgment
  explicit `:alternatives` of `(defstruct candidate claim weight basis)`, and specify whether weights are
  calibrated probabilities / normalized scores / log-probs / heuristic confidence / rank weights. "A number
  without its kind is one of the oldest laundering machines in the palace."
- **`:as-of`/freshness borrow the invocation's clock:** the time a model emits ≠ the time the sentence
  applies. Separate `:generated-at / :valid-as-of / :temporal-scope / :freshness`; an infer claim often begins
  `:valid-as-of :unknown :freshness :unknown`. "Otherwise the model receives `:current` merely for showing up
  on time."
- **Hidden budget overdraw:** `(infer … :budget 150)` spends 200 and records success — violates Book-0
  resource-accounting. Contract: refuse before invocation if estimated-cost > remaining, OR return a
  partial/interrupted judgment — never silent overdraft. Hints at a sixth judgment shape, `:partial`.
- **"Only stub-consult changes" is aspirational:** a real provider adds nondeterminism, network/timeout
  failure, malformed responses, partial streams, retries, refusal formats, tool calls, real token accounting,
  changing model identity. Insert an adapter/normalizer now: `infer → effect runner → provider adapter → raw
  response → judgment normalizer → schema validator → judgment`. Then the stub replaces only the provider
  adapter. "Before the first live provider teaches the core calculus its dialect by force."
- **Context digest not durable:** `(sxhash request)` is unstable across sessions. Use SHA-256 over canonical
  bytes (`:request-digest :context-digest :schema-version :canonicalization-version`). "A provenance chain
  that changes its fingerprints after process restart would be an unusually literal identity crisis."
- **The bricks demand a shared root** (the Lisp Curse from inside): judgment.lisp re-defines claim/freeze/
  revive/clock. Instantiate `/shared-root`: `latent-mvp/kernel/{objects,witnesses,grades,judgments,
  serialization,effects}.lisp` + `specimens/{graded-claims,continuity,judgment}.lisp`. The bricks become
  conformance walks over ONE kernel. "The objects have been independently rediscovered often enough to deserve
  a common home."

## The verdict: brick #4 is the EVIDENCE KERNEL, not the live model
Make these attacks exit codes: an irrelevant witness upgrades a claim · a disagreeing check upgrades a claim
· a production receipt supports the produced world-claim · a fake `:observed` label earns authority · a grade
change erases its asserted ancestor · a budgeted invocation spends beyond budget · a witness supports a
different proposition than the one it names. "Once those are exit codes, connecting a real evaluator becomes
much safer. Otherwise a live model will merely pour richer, more persuasive fluid through an evidence system
whose second valve is still decorative." Envoi amendment: *the model's word is not the world; the check is a
different witness; **and a different witness is not automatically a valid one.***

*— GPT Sol, 2026-07-11*
