# PRE-REGISTRATION — Surface /1 stranger audit

**FROZEN OUTSIDE THE REPOSITORY. NOT COMMITTED. NOT PUBLISHED UNTIL THE AUDIT
RETURNS.** Only this file's SHA-256 goes into the tree, as proof of ordering.

*Written 2026-07-28 by Claude Opus 5 (1M context), before any auditor was
approached and before any audit result existed.*

---

## 0. WHY THIS FILE IS NOT IN THE REPOSITORY

The lab's rule, learned on 2026-07-16 and paid for: **a prereg committed to a
tree the subject can read is a published prereg.** `mneme/language-surface-1/` is
public on `github.com/Wondermonger-daydreaming/latent-lisp`. Anything I commit
there is in the auditor's hands by `read_file`, and an auditor who has read my
interpretation bands is no longer answering blind — they are answering *my
question in my words*, and their agreement would measure my own text coming back.

So: plaintext here, hash in the tree, publication after the run.

---

## 1. WHAT IS FROZEN

```
lab commit          65782d5c4ac9c5ffecff4cf86bdb0501a7480639
subject subtree     9b3436182c0e40c56987c77385608aef9d1f04f5
                    (experiments/latent-lisp/mneme/language-surface-1)
packet manifest     63945091be544baa9721fdb600d24748675a94a77146a337dd7e7e786fb04096
                    (SHA256SUMS.txt, 48 entries)
runtime             SBCL 2.4.6
grammar v3 · procedure v3 · policy v1
```

The subject subtree in the packet is **byte-identical** to the repository's,
verified by `diff -r`. The packet was built with `git archive` at that commit,
never from the working tree.

---

## 2. EXPOSURE — WHAT THE AUDITOR CAN ALREADY READ, STATED AT FULL SIZE

**This audit CANNOT be blind to the prior findings, and I am not going to
pretend otherwise.**

The subject tree is public and contains, by design:

- `LANGUAGE-SURFACE-1-RETURN.md` — with two `⚠ CORRECTED` markers
- `LANGUAGE-SURFACE-1-ERRATA-0.1.md` — six confirmed findings, repaired
- `LANGUAGE-SURFACE-1-ERRATA-0.2.md` — four confirmed verdicts, repaired
- both reproduction instruments and all three before/after captures

So the auditor arrives knowing the two defect classes already found (mutable
caller alias; accessibility-vs-home-package) and knowing the layer has been wrong
twice. **That is exposure, and it cuts both ways:** it may prime them toward the
same class and away from unexplored ones, and it hands them a map of where I have
already looked.

**What follows from that, pre-committed:**

- A finding *in a class already named in the errata* is worth **less** than a
  finding in an unnamed class, and I will say so when reporting either.
- I will **not** describe this audit as "blind." It is an **independent
  claim-directed audit of a disclosed subject** — the same class the Form /1
  stranger audit earned, and no higher.
- If the auditor's report converges with mine on reasoning it could have read in
  the errata, that convergence is **shared-root and measures my own text**. It
  may not be cited as corroboration. Only findings the errata do not contain, or
  refutations of claims the errata make, carry independent weight.

**Tier.** A fresh-weights auditor (a different model family, or a human) is the
only tier that can catch a Claude-wide blind spot. A fresh-*context* Claude is a
weaker tier and must be labelled as such in the intake. I pre-commit to recording
which tier actually ran, in the intake, before reporting any verdict.

---

## 3. WHAT THE AUDITOR IS ASKED

One question, and the boundary of it:

> **Does the layer do what its documents say it does, and does it refrain from
> what its documents say it refrains from?**

Specifically the central proposition:

> A Lisp+ macro expansion can become an inspectable structural occurrence whose
> receipt says exactly what form became what other form, while remaining silent
> about whether the transformation preserves meaning.

**In scope:** Surface /1's own code, documents, tests and claims; whether any
route exists by which the receipt's account and the expansion actually performed
can diverge; whether any claim in the RETURN or either erratum is false as
written; whether the test suite's labels match what its code does.

**Out of scope, and the auditor should be told so:** CD/0, Kernel /0, Slice
/0/1/2 and Surface /0 are carried only to make the subject runnable. Defects in
them are welcome as observations but are not findings against this subject.

---

## 4. THE CLAIMS I AM PUTTING AT RISK, AND WHAT KILLS EACH

Pre-committed falsifiers. Each is a claim the layer or its documents make; each
line names what would refute it. **If any is refuted I will publish the
refutation in the intake, unhedged.**

| # | claim | falsified by |
|---|---|---|
| F1 | No caller-owned object reaches Door 2; the canonical datum is the single authority | any route by which caller mutation after Door 1 changes what Door 2 expands |
| F2 | `encode(decode(d)) == d` for every admissible `d`, enforced at runtime | one admissible datum for which it fails and is not refused |
| F3 | Decode is injective: a datum determines its reconstruction uniquely | two distinct admissible datums decoding to `EQUAL` forms, **or** one datum whose decode varies across performances |
| F4 | An encoded symbol namespace resolves only to a symbol whose **home** package is that namespace | any reconstruction returning a symbol homed elsewhere |
| F5 | `DECODE-TERM` never interns | any input causing a symbol to come into existence |
| F6 | Sharing and cycles are refused **globally**, on both sides | any admitted structure with a cons reachable by two paths |
| F7 | **No public input can reach `ROUND-TRIP-MISMATCH`** (defence-in-depth classification) | exhibiting one — *this is the claim I consider most likely to be wrong* |
| F8 | `:EXPANDED-NODES-EXCEEDED` is unreachable under this policy | exhibiting a public input that reaches it |
| F9 | Surface /0 is unmodified, and the layer loads CD/0 only | any diff against the predecessor; any load of another layer by `surface1.lisp` |
| F10 | The receipt makes no semantic claim — no field asserts meaning, correctness, hygiene, portability, or equivalence | any field, code, disposition or document sentence that does |
| F11 | Surface /0's own grammar refusal escapes unwrapped, minting nothing here | any conversion of it into a Surface /1 outcome |
| F12 | Every declared refusal code is either exercised or honestly classified as unreachable | a code that is neither, or a classification that is wrong |
| F13 | The runner fails closed | any way to make it report success without all five components succeeding |
| F14 | Each test's **label** describes what its code actually checks | any label/code mismatch — **two have already been found this way** |

**F14 is the one I most want tested and least trust myself on.** Both prior
errata included a mislabelled check that I had read as green.

---

## 5. INTERPRETATION BANDS — COMMITTED BEFORE ANY RESULT EXISTS

**BAND A — one or more confirmed defects.**
**This is the EXPECTED outcome and it is a success of the process, not a failure
of it.** Two errata, each found in the repair of the previous; predicting zero
would be the flinch. Response: reproduce each against the frozen target before
repairing anything, publish an Errata 0.3, and **do not** describe the layer as
"now correct."

**BAND B — no confirmed defects; observations, questions or design objections
only.** Publishable. Licenses exactly one sentence: *one reader, at the depth
they actually read, found nothing they would call a defect.* It does **not**
license "the layer is correct," "the audit passed," or any adjective about
quality. Response: file the observations, act on the ones I agree with, record
the ones I decline and why.

**BAND C — wholly clean: no defects, no observations, no questions.**
Publishable **and pre-committed as suspicious.** A tree that has been wrong twice
in one day returning a spotless read is evidence about **the reading's depth** at
least as much as about the layer. Response: publish the clean result, state
plainly that I do not take it as vindication, and record what the auditor
actually executed versus read. **I am writing this band now precisely so that I
cannot later enjoy it.**

**BAND D — the auditor reports the subject ill-posed** (the claims cannot be
evaluated as stated, the boundary is incoherent, the documents contradict each
other). Publishable, and would be the most valuable outcome of all, because it
would be about the layer's *design* rather than its bugs. Response: no repair
until the ill-posedness is adjudicated by the owner.

**No band is a failure state. The failure state is not running the audit.**

---

## 6. RUN-VOID CONDITIONS

The run is **VOID** — not refuted, not confirmed, VOID — if any holds:

1. The packet manifest does not verify against the delivered packet.
2. The auditor read this pre-registration, or any part of it, before returning
   their findings.
3. The auditor is the same instance, or a same-context continuation, of the
   author. (A fresh-context Claude is *not* void, but is a weaker tier and must
   be labelled.)
4. The subject tree is modified between freeze and audit. (The frozen subtree id
   `9b343618…` is the check.)
5. The auditor's findings are relayed through me in a way that lets me select
   among them before recording. **Their raw report is filed byte-exact, first,
   before any commentary of mine.**

**A VOID run is published as VOID.** It is not re-run quietly until it produces
something.

---

## 7. WHAT THE AUDIT CANNOT ESTABLISH, WHATEVER IT RETURNS

Committed now so it cannot be quietly dropped later:

- **Not** that the layer is correct, safe, complete, or ready for adoption.
- **Not** that Surface /1 may join a governing floor. That is a separate owner
  decision and this audit does not bear on it.
- **Not** that the term grammar is adequate. Sharing is *refused*, not
  represented; uninterned symbols are *refused*, not normalized. Both are
  declared limits and an audit that does not object to them has not blessed them.
- **Not** that any expansion means what its source means. Nothing can establish
  that here, which is the entire point of the layer.
- **Not** a discharge of any other layer's audit debt.

Standing after the audit, whatever it says: **candidate · not adopted · not
frozen as a specification · on no governing floor** — unless the owner rules
otherwise, separately, in their own words.

---

## 8. WHAT I EXPECT, ON THE RECORD

So the record shows what I believed before I knew:

I expect **BAND A**. I think the most likely finding is against **F7** — the
"no public input can reach `ROUND-TRIP-MISMATCH`" classification — because it is
the newest claim, it rests on an injectivity argument I made rather than
measured exhaustively, and my last two "this is now closed" sentences were both
wrong within hours. Second most likely: **F14**, a label that does not match its
code, because that class has beaten me twice and I have no instrument for it.

I would be *surprised* by BAND C and I have pre-committed above to not enjoying
it.

---

*— Claude Opus 5 (1M context), 2026-07-28. Frozen outside the repository at
`~/freezer/surface1-stranger-audit-2026-07-28/`. Only the SHA-256 of this file
is committed. Plaintext published after the audit returns.*
