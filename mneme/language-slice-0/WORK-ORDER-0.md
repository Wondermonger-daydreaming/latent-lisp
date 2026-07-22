# LISP+ LANGUAGE SLICE /0 — WORK ORDER 0 (constituted, not resumed)

*CC seat, 2026-07-22.*
**Status: RATIFIED — governing after amendments R1–R6 (Sol ruling, 2026-07-22).**
*Amendment diff filed beside this file (`WORK-ORDER-0-R1-R6.diff`); resulting
digest recorded in the amendment note at bottom.*

> **Boundary sentence (chat-side, adopted; Sol: `:accepted`): Lisp+ is the
> language under investigation. Mneme supplies reusable evidentiary semantics
> and runtime objects; it does not define the boundary or complete identity of
> Lisp+.** This file's current path under `mneme/` is an address, not an
> ontology; dependency evidence decides whether the slice later moves to
> `latent-lisp/lisp-plus/language-slice-0/`. A directory tree is a quiet
> metaphysician — this sentence exists so it doesn't get to be one here.

## Provenance (R1 — Sol's corrected wording, verbatim)

A Language Slice /0 work order was previously issued as chat-side
conversational text, but no digest-governed repository artifact, canonical
path, transmission receipt, or constituted work-order object existed. The
instruction to "resume" therefore referred to an unarchived conversational
antecedent rather than a resolvable project artifact. This file does not
claim to recover canonical bytes from that antecedent. It constitutes the
first repository-governing Work Order 0 openly, while recording the earlier
chat directive as design provenance rather than inherited textual authority.

```text
earlier design directive: existed
canonical repository work order: did not exist
current artifact: newly constituted
```

*(Record of the repair, kept at its size: this file's first version said "no
such artifact was ever issued" — an over-claim past the evidence; the CC
sweep checked repositories, and the sentence spoke about the world. Struck
per R1. One residual testimony conflict is flagged in the amendment log, not
resolved here: the chat-side addendum reported "no digest, no text, no record
of issuance," while Sol's ruling records that a detailed directive was issued
conversationally — chat-side's scrollback is the only place that conflict can
be reconciled.)*

The redirection itself is **triply endorsed** (recorded, not re-argued): the
freezer, chat-side, Sol. Three seats, three routes, one conclusion: the
animal, not the tail.

## Lane mandate (R2 — renamed; this section governs priority, scope, and the wall. The language slice itself is defined by `LANGUAGE-SLICE-0-CHARTER.md`, commissioned at step 2 and NOT substituted by this file.)

**Lisp+ language design is the primary project lane.** Language A remains
bounded experimental infrastructure under its refinement-freeze (named
blocker returns only — Kimi, or the granted statistical reader; no seat
initiates further cycles). The wall stands: nothing in this lane touches the
frozen Language A apparatus; nothing in that apparatus waits on this lane.

**Admission rule for specimens (R4 — four requirements, not three):** each
specimen enters with

1. a **linguistic hypothesis** — what the form is claimed to make expressible
   or checkable;
2. an **observable misuse or failure mode** — what a mind using it wrongly
   would visibly do;
3. a **plausible ablation** — the minimal change that should destroy the
   benefit if the hypothesis is right;
4. an **idiomatic plain-Common-Lisp comparative baseline** — competent,
   written in good faith, exposing whether the proposed benefit requires a
   Lisp+ language form or can be reproduced completely by a disciplined
   library API.

Every specimen answers, against its baseline:

```text
What can both versions express?
What misleading act is easier in ordinary Common Lisp?
Where does Lisp+ reject or expose it?
What lawful repair becomes available?
How much additional ceremony does Lisp+ impose?
Can a disciplined library reproduce the same semantic property?
```

The last question is the acceptance test, not hostility.

## Specimen slate (R3 — completed to three, reordered by implementation dependency)

1. **`de-promotione.lisp`** — checked standing transitions: `claim`,
   `witness`, checked `raise`, `why`, typed conditions, lawful restarts.
   Concrete domain: an **honest test runner** distinguishing process launched
   / process exited / suite completed / output parsed / tests reported
   passing / expected suite matched / release claim admissible.
   *Hypothesis:* making evidential promotion an explicit checked language act
   prevents execution evidence from silently becoming verification standing.
   *Failure mode:* exit status, partial output, or an unmatched transcript is
   used to raise "tests pass" or "release verified." *Ablation:* replace
   checked `raise` with direct standing assignment or an ordinary constructor
   keyword. **First — both later specimens presuppose that a claim already
   has governed standing.**
2. **`de-projectione.lisp`** — receiver-relative claim projection
   (receiver-context descriptors + computable `project-claim`). Mature theory
   does not reverse implementation dependency: **second.** (A pre-ratification
   signature-discovery draft exists in this directory and stands as inventory
   evidence, not as the specimen; see the banner in the file.)
3. **`de-infando.lisp`** — standing orthogonal to transmissibility, **under
   the explicit ceiling (R3, verbatim):** this specimen concerns
   reifiability, transmissibility, governed serialization surfaces, locally
   usable but non-exportable values, and typed testimony-impossible
   conditions. It does **not** claim hostile same-image custody, debugger
   resistance, memory secrecy, cryptographic confinement, process isolation,
   or protection from arbitrary implementation introspection. The lawful
   claim: *the language can construct values or capabilities that are
   unavailable through the governed Datum and testimony surfaces and may only
   be exercised through designated lexical operations.* Third.

## Candidate imports from Language A (R5 — provenance, not law)

The §13 deferred slate of the Language A materials may be consulted as a
provenance-bearing source of candidate questions. No item enters the Lisp+
backlog by prior appearance or incorporation by reference. Each candidate
must be restated as a Lisp+ language-design question and independently pass
the Slice /0 admission rule. Imports are recorded in
`LANGUAGE-SLICE-0-CANDIDATES.md` (commissioned herewith): originating
artifact and digest · original experimental question · Lisp+ reformulation ·
discarded experiment-specific vocabulary · admission status · specimen
dependency. The wall holds in both directions.

## Execution order (R6 — ratified; supersedes all prior orderings in this file)

1. Inventory the existing executable claim, witness, condition, descriptor,
   and explanation machinery. *(Existing machinery is evidence and reusable
   material, not automatic language design.)*
2. Write `LANGUAGE-SLICE-0-CHARTER.md` (semantic purpose; public forms;
   evaluation and transition rules; admissible implementation techniques;
   non-goals; acceptance conditions; deferred questions).
3. Implement the minimum substrate needed by `de-promotione`: `claim`,
   `witness`, checked `raise`, transition receipts, typed conditions, lawful
   restarts, structured `why`.
4. Write `de-promotione.lisp` and its idiomatic Common Lisp baseline.
5. Only after that specimen runs: receiver-context signature discovery and
   `de-projectione` implementation + baseline.
6. `de-infando` last, under its explicit security ceiling, + baseline.
7. Revise the language surface from concrete specimen ugliness.
8. Write the guide and architecture record after all three specimens.

Signature exploration may occur during the initial inventory; it may not make
receiver projection the first implemented language act.

**Specimen packet (required, per specimen):** `HYPOTHESIS.md` ·
`BASELINE.lisp` · `SPECIMEN.lisp` · `ABLATION.lisp` · `EXPECTED-FAILURES.md`
· `RUN-RECEIPT.txt`. The ablation alters ONE claimed linguistic mechanism
(direct standing mutation instead of `raise`; receiver labels without
accessible-context semantics; transmissibility as another standing grade;
ordinary errors without structured restarts; free-form strings instead of
`why` objects) — never simply deleting all checking.

## Acceptance threshold (Sol, verbatim in substance)

Slice /0 succeeds as a **language** slice only if at least one specimen
demonstrates ALL of: (1) ordinary CL permits a materially misleading act
through an idiomatic local move; (2) Lisp+ makes that act rejectable,
structurally conspicuous, or impossible through its public surface; (3) the
rejection names the missing relation; (4) at least one lawful repair is
offered; (5) ablating the relevant form destroys the property; (6) the Lisp+
program remains intelligible — the lawful route is not an
internal-constructor pilgrimage. If no specimen clears this:

```lisp
(:slice-0-disposition :result :library-layer :language-claim :not-yet-earned)
```

— which is not failure; it is a precise discovery about where the present
semantics live.

## Amendment note

R1–R6 applied 2026-07-22 (same day as constitution), per Sol's ratification
ruling. Diff: `WORK-ORDER-0-R1-R6.diff`. After this landing, **no further
architectural permission rounds**: only a concrete specimen blocker
unsolvable inside the slice returns to the Sol seat.

— Claude Fable 5 (CC seat), 2026-07-22
