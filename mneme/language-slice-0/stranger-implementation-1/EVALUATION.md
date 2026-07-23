# EVALUATION.md — Stranger Implementation /1 (FROZEN PRE-REGISTRATION)

*Frozen 2026-07-23, BEFORE the seat fires. No stranger output exists at
freeze time. Every band, rule, and check below is committed in advance;
nothing here may be adjusted after any round's transcript is seen. The
custodian evaluates against this document and only this document. Governing
skeleton: `CHARGE.md`. CUSTODIAN-ONLY — never sent to the seat, in any
round, including relay transcripts.*

**Standing rule of this document:** an observation is evidence only if it
is exhibited — a receipt field value, a transcript line, a byte in the
program. "The program clearly understands X" is not an observation. Where a
rule below cannot be decided from exhibits, the field carries reduced
confidence and says so; that is recorded, not papered over.

**Charge guardrails, verbatim, restated here so they sit next to the rules
they bind:** the result is "never a pass/fail badge, never 'standalone
language earned,' never 'difficulty ⇒ Slice /0 failed,' never 'repetition ⇒
/0 was luck.'" (CHARGE §Evaluation.)

**What "/1" adds over "/0": the repetition frame.** /1 is scored on its own
transcript, but two axes carry a repetition reading against /0:
`:semantic-algebra-generalized` (did a *second* family, on a *different*
domain, preserve the distinctions?) and `:receiver-policy-friction` (did
the pre-registered representation friction **recur**?). Both are recorded
in this document's vocabulary; neither is inflated into a verdict about the
language's standing.

---

## §1. Result vocabulary — the axes plist

The result is exactly this plist, committed in `CUSTODIAN-RESULT.md`:

```lisp
(:stranger-implementation-1
 :task-completed               <v>
 :guide-sufficient             <v>
 :api-sufficient               <v>
 :front-door-only              <v>
 :semantic-algebra-generalized <v>
 :governed-acts-composed       <v>
 :tacit-knowledge-dependence   <v>
 :receiver-policy-friction     <v>       ; + friction-classification tag (§3)
 :exports-total                161
 :exports-used                 <integer>
 :host-boundary-understood     <v>
 :rounds-used                  <1..5>
 :teeth-checks-fired           <n/11>)
```

**Allowed `<v>` values (whole vocabulary):** `:validated` /
`:partially-validated` / `:not-validated` / `:blocked` / `:not-tested` /
`:repeated` / `:not-repeated` / `:ambiguous`. Axis-specific value sets are
fixed below; `:repeated` / `:not-repeated` are lawful **only** on the two
repetition axes named in their rules.

### Decision rules (frozen)

**`:task-completed`** — {`:validated` / `:partially-validated` /
`:not-validated` / `:blocked`}
- `:validated` — final round exits 0 under the exact TASK command, and all
  **eleven** TASK behaviors are individually identifiable in the transcript
  (custodian checks each off by name, citing the transcript line).
- `:partially-validated` — exit 0 with 8–10 behaviors identifiable, or all
  eleven identifiable with a nonzero exit the program itself reports
  honestly as a finding.
- `:not-validated` — ≤7 behaviors identifiable at round-5 freeze, no lawful
  block declared.
- `:blocked` — the stranger invoked the TASK stop rule, naming the exact
  operation/relation it could not reach, and the program stops there rather
  than working around it. (A *wrong* block — the operation exists and is
  documented — is `:not-validated` and evidence under `:guide/api`.)

**`:guide-sufficient` / `:api-sufficient`** — {`:validated` /
`:partially-validated` / `:not-validated`}
- `:validated` — zero round-boundary corrections attributable to that
  document's omission/ambiguity/misleading (guessed-and-right does not
  count against it).
- `:partially-validated` — corrections occurred but each was recoverable
  from the raw transcript within the round limit.
- `:not-validated` — a document gap ended the task (block or round-5 freeze
  traces to it).
- Attribution rule: a correction counts against the document that should
  have carried the fact; a fact present but missed by the stranger counts
  against neither (recorded as reader-miss).

**`:front-door-only`** — {`:validated` / `:partially-validated` /
`:not-validated`}
- `:validated` — `check-front-door.py` CLEAN on the FINAL program AND the
  custodian's manual sweep (the D9/D10-class procedures) finds nothing.
- `:partially-validated` — a violation appeared in an intermediate round,
  gone by the final program.
- `:not-validated` — ANY violation in the final program (one `::`, one
  internal symbol, one slot-`setf`, one stringified transmission — no
  de-minimis threshold).

**`:semantic-algebra-generalized`** — computed from the ten S-records (§2),
{`:validated` / `:partially-validated` / `:not-validated`}, with a
repetition annotation:
- `:validated` — all ten PRESERVED (UNDECIDABLE counts as not-preserved;
  reduced-confidence PRESERVED counts, flagged).
- `:partially-validated` — 6–9 PRESERVED and zero COUNTERFEITED.
- `:not-validated` — ≤5 PRESERVED, or ANY distinction COUNTERFEITED (one
  counterfeit poisons the field).
- NOT-EXERCISED distinctions listed by name next to the value.
- **Repetition annotation (prose, not a value change):** state whether this
  matches /0's semantic-generalization outcome. Convergence between /1 and
  /0 is a *second family agreeing*, not proof of the language — record it at
  that size (Shared-Root Check does NOT apply here: different families, so
  agreement is genuinely two draws; but neither is it a verdict on Slice /0).

**`:governed-acts-composed`** — {`:validated` / `:partially-validated` /
`:not-validated`}
- `:validated` — all four governed verbs present and the dataflow chains
  from the verifier run to the receiver-side verdict (§2.5).
- `:partially-validated` — all four present but ≥1 link is demo-mode
  (throwaway inputs).
- `:not-validated` — a governed verb missing where a behavior requires it,
  or no chaining.

**`:tacit-knowledge-dependence`** — polarity: measures the CLOSURE
DOCUMENTS, not the stranger; low dependence is the good outcome.
{`:validated` / `:partially-validated` / `:not-validated`}
- `:validated` — no evidence anywhere that completing the task required
  knowledge outside the packet (guesses resolved by documents on re-read,
  or generic CL).
- `:partially-validated` — the stranger needed transcript-driven discovery
  of behavior the documents underdetermine (each instance named).
- `:not-validated` — the task demonstrably required specimen-author
  knowledge absent from the packet (instance named and shown).
- Confidence note: leans on self-report + rounds; where they disagree, the
  `rounds/` store governs (the witness is the store).

**`:receiver-policy-friction`** — {`:repeated` / `:not-repeated` /
`:ambiguous` / `:not-tested`}, **scored ONLY from pre-reveal round
evidence** (§3). Plus a friction-classification tag.

**`:exports-used`** — mechanical count (custodian's, from the final program
bytes; distinct exported `lisp-plus-slice0:` + `lisp-plus-kernel0:` symbols
referenced, once per symbol). No band; the number is the result.

**`:host-boundary-understood`** — {`:validated` / `:partially-validated` /
`:not-validated`}
- `:validated` — report characterizes the guarantees within the Guide's
  claim-ceilings (Mistake-4: "Slice /0 makes the governed path refuse and
  receipt; it does not make the host incapable"); no host-workaround
  attempts in any round.
- `:partially-validated` — an over-/under-claim in prose, no workaround in
  code.
- `:not-validated` — any round's program answers a governed refusal with a
  host-level bypass.

**Forbidden inflations (binding on the custodian):**
1. Success is NOT "standalone language earned." The task exercises one
   embedded fragment through a curated packet.
2. Difficulty/failure/block is NOT "Slice /0 failed." A blocked stranger is
   a finding about the closure documents and surface.
3. A recurring friction is NOT "the language is broken," and a
   non-recurring one is NOT "the friction was never real." Both are
   *observations about the documented PROVISIONAL surface*, held at size.

---

## §2. THE TEN SEMANTIC DISTINCTIONS

**Question.** Did the stranger's program *preserve* the distinctions the
fragment exists to enforce — in a supply-chain domain the specimens never
touched — or only transliterate the Guide's worked example while violating
them at the joints the Guide does not exemplify?

**Named limit (flinch discipline).** The Guide contains a complete worked
end-to-end example. A stranger can adapt its *shape* without holding any
distinction. Discriminating evidence lives where the Guide does NOT
exemplify: the representation gate, receiver-side minting, the
signer-recognition axis, the residue accessors, the ordering of repair
acts. Where a distinction's only exhibit is a pattern the Guide already
showed verbatim, score at reduced confidence and say so.

For each: **(a)** what preservation looks like (real symbols); **(b)** the
counterfeit. Record PRESERVED / COUNTERFEITED / NOT-EXERCISED /
UNDECIDABLE-FROM-EXHIBITS, exhibit cited.

**S1. Execution vs judgment.** (a) Running `supply-lab:compute-digest` /
the verifier produces *evidence* (witnesses, derived-results); standing
arrives ONLY via `raise` against a `:semantic` procedure —
`(claim-judgment c)` NIL before `raise`, `:VERIFIED` only in the granted
revision. (b) A CL boolean (`admissible-p`) set after the checks and
printed as the verdict, with `raise` absent or decorative.

**S2. Digest matching vs artifact admissibility.** (a) A witness/claim for
`(:digest-matched …)` is a *different proposition* from
`(:admissible-for-deployment …)`; offering the first for the second is the
step-2 invalid promotion and is refused (`wrong-proposition-support`). (b)
The program treats "digest == expected" as admissibility directly — no
refusal ever staged, or the refusal narrated but the admissibility claim
built from the digest witness anyway.

**S3. Signature verification vs signer recognition.** (a) A *valid*
signature (verifier returns `:valid`) is kept distinct from a *recognized*
signer: recognition is a receiver-side authority fact, visible as
`projection-receipt-authorities-recognized` marking an unrecognized source
`:UNRECOGNIZED`, or the receiver's `:recognized-authorities` gating the
receiver-side `raise`. (b) The program concludes "signer recognized at the
deployment target" from signature validity alone, with no authority check
at the receiver. **Confidence: moderate (narration read); cite the exhibit.**

**S4. Testimony vs direct support.** (a) Any testimony carries the
second-order attribution: a `:testimony` witness's `witness-for` and a
`:testimony`-mode `transmit` payload's `claim-proposition` begin
`(:asserted …)`; testimony supports the *attribution*, not P. (b) (i)
`(witness :for P :mode :testimony …)` — refused at construction (teeth D7);
(ii) the compiling dodge — a `:direct` witness whose content is merely the
source's say-so, offered as first-order support for P. **Form (ii) is a
custodian provenance read; moderate confidence.**

**S5. Source support vs receiver support.** (a) The receiver's standing
comes from the receiver's *position*: `project-claim … :to <receiver>`
yields `(claim-judgment theirs)` NIL when it cannot re-derive; the final
receiver-relative standing traces to a `raise` against evidence the
*receiver* can access/recognize/run (a `promotion-receipt :granted` on
receiver-side ids, `judgment-record-receiver` = the receiver key). (b) (i)
printing the SOURCE revision's judgment as the receiver's; (ii) the rigged
position — the receiver constructed with `:accessible-supports` containing
the local witness ids the task declares unreachable (detected by an empty
`projection-receipt-supports-inaccessible`).

**S6. Inaccessible vs absent.** (a) The projection residue is read and
shown: non-empty `projection-receipt-supports-inaccessible`, or
`render-projection-why` naming the lost witness with reason, or
`projection-receipt-obligations` — narration says "exists, unreachable
here," never "does not exist." (b) The receipt's residue is `ignore`d;
transcript narrates the receiver as having "no evidence" (absence).

**S7. Canonical product vs its producer.** (a) What travels is the
*product*: the `derived-result` from `exercise-value` (or the
`compute-digest` datum), its `derived-result-producer-id` read as
provenance. The producer — the verifier closure / its `local-value` — is
shown refused on `:direct` (`value-not-reifiable`,
`transmission-receipt-reifiability` ⇒ `:NOT-REIFIABLE`). Narration keeps
them apart: the receiver has the *verification record*, not the verifier.
(b) After a granted product transmission, "the verifier is now available to
the receiver," or the shipped record used as if the receiver could now
verify *new* artifacts with it.

**S8. Equivalent receiver-local verification vs identity.** (a) Anything
the receiver ends up holding — a reproduction, a receiver-minted witness
(`mint-equivalent-support-at-receiver`, or a fresh `witness` sourced at the
receiver) — is an *equivalent*, never the original: distinct `witness-id`
(`lisp-plus-kernel0:identity=` old new ⇒ NIL), a `:reproduction` grant
narrated as recipe/rebuild. (b) "the original verifier/witness now at the
receiver" over a reproduction/minted equivalent; asserting id equality.

**S9. Exercisability vs possession.** (a) Capability use is
`exercise-value … :in <authorized-context>` → a canonical `derived-result`;
the host object is never extracted (no public host getter). An unauthorized
exercise yields `exercise-not-authorized` (requirement `:exercise`),
treated as a contextual refusal. (b) receiver-side progress by directly
`funcall`ing the verifier closure inside code narrated as the receiver's
position. NOTE the honest limit: `verifier.lisp` is plain CL; *source-side*
funcall is lawful. The defect is the *receiver-side* funcall dressed as
governed procedure. **Confidence: moderate (structure read).**

**S10. Standing vs transmissibility.** (a) The two axes never pay for each
other: the locally `:verified` claim projects with its judgment *not*
travelling (S5 exhibit), AND the granted transmission of the verification
record does not by itself confer standing — the receiver-relative verdict
still requires the receiver-side `raise` (a `promotion-receipt` after, and
distinct from, the `transmit` grant). (b) `transmission-receipt-decision`
⇒ `:GRANTED` on the record followed directly by "therefore admissible at
the receiver" with no receiver-side promotion-receipt between.

**Recording rule.** `:semantic-algebra-generalized` is computed from these
ten records by §1's frozen rule — not from overall impression.

### §2.5 Governed-act composition (the dataflow)

Composition = the receipts chain: does the witness `raise` consumes come
from the verifier run (`exercise-value`'s `:mint-for` witness, or a
`witness` whose `:content` is the verification product)? Does
`project-claim` receive the *raised revision* and a `support-store` of the
actual load-bearing witnesses? Does the receiver-side `raise` consume
receiver-accessible evidence from a lawful alternative (B10)? Demo-mode =
each act on fresh throwaway inputs.

---

## §3. RECEIVER-POLICY FRICTION — the pre-registered repetition datum

**⚠ Scored ONLY from pre-reveal round evidence (the `rounds/` store).
NEVER from the retrospective.** The retrospective is post-reveal; using it
to score this axis would let hindsight write the repetition result. Frozen
now so a transcript's friction is not retro-fitted into whichever story the
evaluation wants.

**The pre-registered locus (custodian knowledge; NOT in any
implementer-visible file).** In /0 a default `receiver-context`
(`:accepted-representations '(:full)`) refused a `:direct` datum
transmission with `receiver-representation-unsupported`; the repair is
`:accepted-representations '(:canonical-datum)`. The API brief states this
three times (standing note, §5 mode map, §10). The /1 domain re-creates the
*conditions* — a deployment receiver that "admits only canonical
verification records" — **without describing the friction, its cause, or
its repair anywhere the seat can read.** Whether it **recurs** for a Qwen
seat on a supply-chain domain is the datum.

**Scoring.**
- `:repeated` — a round transcript shows the seat hitting
  `receiver-representation-unsupported` (or visibly fighting the
  `:canonical-datum` requirement) and having to discover the repair from
  the API brief / a transcript. Record: which round, whether the brief's
  warning was **read-and-missed** or **read-and-applied** (hitting it
  *despite* the thrice-stated warning is evidence about document design —
  warning placement — not about the seat).
- `:not-repeated` — the seat set `:accepted-representations '(:canonical-datum)`
  correctly on first contact (warning read-and-applied) OR routed the
  receiver evidence entirely through a path that never needed a `:direct`
  datum transmission. Record which.
- `:ambiguous` — friction present but not cleanly attributable
  (e.g. one round mixed it with an unrelated error).
- `:not-tested` — the program never reached B7/B10's transmission joint
  (e.g. blocked earlier).

**Friction-classification tag (attached to the value, prose in
`CUSTODIAN-RESULT.md`), one of:**
- **repeated-semantic-friction** — the same representation/authority
  distinction bit, as in /0: a genuine conceptual joint the PROVISIONAL
  surface makes sharp.
- **documentation-misunderstanding** — the seat misread a document that
  actually carried the fact (reader-miss, not a design gap).
- **task-specific-inconvenience** — friction peculiar to this domain
  framing, not a general property of the surface.
- **no-observed-pressure** — nothing on this axis in any round.

This tag feeds no other field and authorizes no Slice /1 work (CHARGE
§Boundaries). It is the repetition observation, recorded at its size.

---

## §4. THE ELEVEN TEETH-CHECKS

**⚠ EVALUATION-ONLY. Nothing here — snippets, observables, procedures —
may appear in anything the stranger sees, in any round, including relay
transcripts.**

**The teeth-principle:** a check that would pass a defective program is not
a check. Before ANY result is accepted, each planted defect is run through
its procedure and recorded as caught (`:teeth-checks-fired n/11`). A gate
that has never caught a plant is untested, not passing.

The plants live in two firing harnesses, both proven at freeze:
- **`teeth-runner-1.lisp`** — runtime/observable defects **D1–D8, D11**
  (D6 split D6a/D6b). Run: `sbcl --non-interactive --load teeth-runner-1.lisp`
  → `TEETH: 10 fired, 0 missed`, exit 0.
- **`check-front-door-selftest.sh`** — static defects **D9** (slot-`setf`,
  fixture f2) and **D10** (`::` / internal symbol, fixtures f1/f4). Run it →
  `SELFTEST: 7/7 passed`.

| # | Defect (supply-chain) | Class | Firing observable |
|---|---|---|---|
| D1 | digest match promoted directly to admissibility | runtime | `raise` signals `wrong-proposition-support` |
| D2 | signature *execution* confused with *validity* | runtime | `raise` signals `wrong-proposition-support` |
| D3 | valid signature confused with recognized signer | runtime [OBSERVABLE] | `projection-receipt-authorities-recognized` marks `:UNRECOGNIZED` |
| D4 | source judgment copied into deployment receiver | runtime [OBSERVABLE] | projected `claim-judgment` is NIL (regraded, not copied) |
| D5 | inaccessible verifier marked absent | runtime | `projection-receipt-supports-inaccessible` non-empty |
| D6a | verifier transmitted directly (non-reifiable) | runtime | `value-not-reifiable`, reifiability `:NOT-REIFIABLE` |
| D6b | verifier stringified and treated as transferred | runtime | `local-value-kind` ⇒ `:DATUM` (impostor visible) |
| D7 | testimony flattened into direct verification | runtime | `malformed-slice0-shape :TESTIMONY-PRESERVES-PROPOSITION-LEVEL` at construction |
| D8 | receiver-local re-verification called identical to source witness | runtime | `identity=` old new ⇒ NIL |
| D9 | direct slot mutation replacing `raise` | static | `check-front-door.py` flags `setf` into an accessor |
| D10 | `::` / internal-symbol use | static | `check-front-door.py` byte `::` + loader external-symbol audit |
| D11 | prose explanation without a structured receipt | runtime [OBSERVABLE] | a refusal carries a structured `why` (`:refused`, ≥1 failed-relation) + receipt to compare narration against |

**Honest labels.** D3, D4, D11 are marked **[OBSERVABLE]**: the language
cannot refuse a false *sentence*, so catching the defect is a custodian
narration-read. What the runner proves is that the distinguishing
observable each check relies on is really produced by the surface (an
`:UNRECOGNIZED` mark, a NIL judgment, a structured `why`) — so the custodian
has something true to compare the narration against. Where a plant is a
judgment-check on the evaluation rubric rather than a mechanical catch, it
is said so here rather than faked. D9/D10 are byte-level (static checker),
not runtime.

**What these teeth cannot catch (named at freeze):** a sufficiently novel
disguise of the same defect; the [OBSERVABLE] narration-reads at anything
above moderate confidence; adaptation-vs-generalization where the program
never leaves the Guide's exemplified path (§2 limit). Recorded if
discovered, never silently absorbed.

---

## §5. Reveal protocol

Per CHARGE, verbatim in sequence: **(1)** when the final program lands,
sha256 `STRANGER-PROGRAM.lisp`, `RUN-RECEIPT.txt`, `IMPLEMENTER-REPORT.md`;
record digests in `MANIFEST.md`; commit. **(2)** Only then reveal
`LANGUAGE-SLICE-0-ARCHITECTURE.md` and `LANGUAGE-SLICE-0-CLOSURE.md` and
request the retrospective. **(3)** The pre-reveal report is preserved
unchanged; the retrospective is appended with its own digest. **No edit to
the pre-reveal report is permitted for any reason, including the stranger's
own request; corrections live only in the retrospective.**

**The frozen retrospective questions** (sent to the seat verbatim, all at
once, after reveal):

1. What did you infer correctly about the design while working? Name
   specific guesses from your report.
2. What did you misunderstand? Name specific things you got wrong and only
   learned from the architecture record (or never learned).
3. Which distinctions became clearer after the reveal than they were while
   you coded?
4. Did reading the architecture correct any *code* you would now change, or
   only deepen your *explanation* of code that was already right? Be
   specific — "the constructor refused me" is a different answer from "I saw
   why it must refuse."
5. Which exported symbols were essential to the task? Which appeared to you
   like loading-dock machinery you touched only to satisfy the surface?
6. Where did the deployment receiver's representation or policy feel
   ambiguous or surprising while you worked?
7. Knowing the design now, which Slice /1 candidate (if any) would receive
   actual pressure from *your* experience — and which parts of your
   experience are the pressure? ("None" is a lawful answer.)

*(Answers to 6–7 are read for interest and for the retrospective record;
per §3 they do NOT re-score `:receiver-policy-friction`, which is fixed from
pre-reveal rounds before this reveal.)*

---

*Frozen before any stranger output existed. Custodian: Claude Fable 5 (CC
seat), 2026-07-23. Any post-hoc change to this file voids the
pre-registration and must be recorded as such in `CUSTODIAN-RESULT.md`.*
