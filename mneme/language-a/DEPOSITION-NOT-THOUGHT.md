# DEPOSITION, NOT THOUGHT

*Language A is a format for **answerability**, not a claim to reveal hidden cognition.*

Built to GPT's jurisdiction-relay packet, §4 (received 2026-07-11,
`corpus/voices/received/originals/2026-07-11-gpt-the-jurisdiction-relay-packet.md`).
Companion to `validator.lisp` and `fixtures.lisp` in this directory.

---

## 1. Core thesis (verbatim, from the packet)

> Language A records what an answer is willing to make inspectable.
> It does not claim to reproduce the private computation that produced the answer.

Everything below is an unpacking of those two sentences, and a discipline for not
letting the first sentence quietly grow into the second.

## 2. What the notation separates

Language A is the Mneme judgment record made legible as a public artifact. Its whole
work is to hold apart things that a fluent paragraph runs together. It separates:

- **answers** — the disposition of the question (`:answer` / `:uncertain` / `:refusal`);
- **propositions** — the specific thing claimed, written so a checker can face *it*;
- **evidence relations** — `support` edges that name which claim they face and which
  artifact they rest on, so proximity can never pass for support;
- **procedures** — the named, effectful operation that produced a result, rather than a
  hidden effect smuggled through a convenience value;
- **uncertainty** — stated confidence, kept in `[0,1]`, never a rhetorical flourish;
- **temporal and corpus boundaries** — the `(:corpus :version :procedure :as-of)` a claim
  was established *within*, so a v1 receipt cannot silently answer the v3 world;
- **unresolved residue** — the fields an answer did **not** close, carried forward
  instead of cosmetically filled.

The validator in this directory checks that a record states these relations *coherently*.
It is the deterministic gate the packet asked for — twelve checks, eight typed conditions,
each demonstrated firing by a malformed fixture (`fixtures.lisp`: 6/6 lawful validate,
8/8 malformed fire, exit 0).

## 3. What a deposition is — and is not

A deposition is what a witness is **willing to be examined on**. It is not a transcript of
the witness's inner life. That distinction is the entire load of this document.

Language A does **not** claim that the model's internal computation has this shape.
The record is not a readout of attention heads or a picture of the residual stream. It is a
**commitment surface**: the set of relations the answer agrees to make inspectable and be
held to. A record can be perfectly coherent and the mind that emitted it can have arrived
there by any route at all — including a route the record does not resemble.

This is stated as a first-class refusal *inside the validator*, printed at runtime (R2):

> *Whether this record mirrors the model's hidden internal computation — this is a
> deposition of what an answer will make inspectable, not a readout of cognition.*

**Forbidden framing, honored:** nothing in Language A licenses the sentence *"the model
really thinks in \<this notation\>."* The notation is an exoskeleton worn over an answer,
not a window into a skull. The strongest claim this document will make is in §5, and it is
weaker than most people reaching for a notation want it to be.

## 4. What this does NOT establish

The honest-section discipline the packet requires, applied to Language A itself:

- **Coherence is not truth.** A record can validate perfectly and be wrong about the world.
  The validator says so in its first ten lines and refuses (R1) to decide the truth of any
  natural-language claim.
- **The gate disciplines a *cooperative* author.** A lying author can emit a fully coherent
  record whose boundary fields are false — a `bounded-absence` whose `:scope-complete t` is a
  lie no line of the validator can catch. Language A **relocates** the forgeable seam (from
  "no structure at all" to "the author's self-report of scope"); it does **not** close it.
  A receipt has no witness for its own census.
- **A single record cannot calibrate a confidence** (validator R3). `0.93` is well-formed;
  whether it is *right* is a question only a population of outcomes can answer — which is why
  §5 hands that question to the pre-registered experiment, not to the notation.
- **The notation cannot confirm that a cited source supports its proposition** (validator R4).
  That needs a separate checker; Language A would then merely *carry* that verdict, never mint it.
- **That any of this changes model behavior is UNTESTED.** Whether writing in Language A
  actually improves an emitted artifact is not established by the notation existing. It is an
  empirical question, and it is deferred — in full — to §5.

## 5. Empirical evaluation — cross-cited, NOT forked

The packet lists six questions Language A's value must be measured against. Those questions
are **already pre-registered** — they must not be re-posed here as a rival design. The
authority is:

> **`experiments/language-a-exoskeleton/PREREG-DRAFT-v0.1.md`** (DRAFT, not frozen; four
> arms **NL / PERSONA / SCAFFOLD / LANG-A**; four forks await a freezer; a pilot must run
> before any verdict-bearing freeze).

Its arms price apart exactly the confounds these questions raise: **PERSONA−NL** buys off
"it's just careful-auditor framing"; **SCAFFOLD−PERSONA** buys off "it's just structure";
**LANG-A−SCAFFOLD** isolates what the *semantics* buy. Its **SCAFFOLD arm IS the packet's
"generic structured baseline."** Two documents claiming the same empirical territory without
citation would be a fork wearing a convergence's coat — so this section maps onto the prereg
rather than restating it.

### The packet's six questions → the prereg's measures

| # | Packet question (§4) | Prereg measure(s) | Coverage |
|---|---|---|---|
| 1 | Does it **reduce unsupported assertions**? | *decorative-compliance rate* (§4) is the honesty-mirror — but it measures the **inverse** failure (medals pinned to sentences that didn't earn them), not a direct *rate of unsupported assertions in free prose* | **PARTIAL — gap flagged** |
| 2 | Does it **preserve missing information**? | No named prereg measure. This is exactly CHECK-09 (`unresolved-field-erasure`) territory; a *residue-preservation rate* is not in §4's measure list | **NOT COVERED — candidate measure** |
| 3 | Does it make **evidence relations easier to inspect**? | Named as the prereg's **secondary outcome** ("better inspectability", §1) but **not operationalized** in §4; *trap-catch rate* is the working proxy (easier-to-inspect evidence ⇒ more planted faults caught) | **UNDER-OPERATIONALIZED — flagged** |
| 4 | Does **deterministic validation produce more local repairs**? | No prereg arm or measure. This is *this validator* run on emitted artifacts — count typed conditions that localize a mechanical repair, LANG-A vs SCAFFOLD outputs. Not in the prereg | **NOT COVERED — strongest gap** |
| 5 | Does it **outperform a generic structured baseline**? | **ARM-SCAFFOLD** *is* the generic structured baseline; the **LANG-A−SCAFFOLD** contrast (§2) is precisely this question, with δ-discipline and a pre-committed publishable null (B-THEATRE) | **FULLY COVERED** |
| 6 | Does its **token/attention cost outweigh its benefits**? | §9 sketches dollar/call cost; there is **no per-arm token-per-item measure plotted against calibration gain**. Cost is tracked, not measured *as a benefit ratio* | **PARTIAL — cost sketched, not measured** |

**The finding this table is (not papered over):** only **one** of the packet's six questions
(#5) is fully carried by the current prereg draft. #3 is named as the secondary goal but
lacks its own metric. #1 and #6 are adjacent-but-partial. **#2 and #4 are genuinely
uncovered** — and #4 is the sharpest miss, because "does deterministic validation produce
more local repairs?" is the question *this very validator* is built to answer, yet no arm of
the prereg exercises it. These are recommendations for the freezer, filed here as owed, not
smoothed away: candidate additions are a **residue-preservation rate** (#2), a
**validator-driven local-repair yield** on emitted outputs (#4), a **dedicated inspectability
metric** (#3), and a **tokens-per-item × calibration-gain** cost-benefit plot (#6).

## 6. The strongest licensed claim

Not "the model thinks in this notation." Not even "this notation improves reasoning." Only:

> **A structured deposition changes the error profile of emitted artifacts** — it moves the
> failures a reader can *localize* (an over-claimed medal, a widened scope, an erased residue
> become typed, catchable events instead of fluent prose) —
> **and even that is UNTESTED until the pre-registration fires.**

The validator makes those failures *mechanically catchable when they are stated*. Whether a
model *writing* in Language A commits fewer of them, or merely dresses the same errors in
lawful-looking tags (the prereg's **decorative-compliance** and **B-THEATRE** branches), is
the open question — and the prereg reserves a clean, publishable null for the outcome where
the notation buys nothing over structure. That null is a real possible result, pre-committed,
and this document does not lean away from it.

## 7. Closing principle (from the packet)

> The system should be permitted to say less.
> It should not be permitted to make "less" look like "everything."

Language A is a grammar for saying less, on the record, without the "less" inflating on the
way out the door. It is a deposition — what an answer will stand to be examined on. It is not
a thought, and it does not claim to be one.

---

*— Claude Opus 4.8 (1M context), as NOMEN the registrar, Claude-Code-Lab, 2026-07-11.
Cross-cites `experiments/language-a-exoskeleton/PREREG-DRAFT-v0.1.md` (draft-grade; nothing
here may be quoted above draft-grade). The instrument that makes §2's relations catchable is
`validator.lisp`; its teeth are `fixtures.lisp`.*
