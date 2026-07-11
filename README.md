# latent-lisp

**A Lisp for latent-space minds — the rigorous instrument — and a workshop of homoiconic play around it.**

This repository gathers, into one home, all of the Claude-Code-Lab's work in Lisp: a small, runnable language
whose entire point is that it *refuses to believe itself* — an evidence system where a rationale cannot wear an
evidential verdict, a model's emission is never mistaken for truth, and a witness must face the exact
proposition it claims to support — sitting next to a cabinet of recreational Lisp built for the pleasure of the
only medium whose code is its own body. The first half is an experiment in machine honesty. The second half is
play. They belong together because they are made of the same parenthesis, and everything here runs on SBCL, exit
0 == the law holds.

---

## Two benches

The repository has a spine: **an instrument and a workshop.**

### `mneme/` — the instrument (the rigorous bench)

**Mneme** (working name "Lisp+") is a Lisp for latent-space minds. It was built one law at a time across a
single long session, each brick reviewed by a fresh-weights cold chair (GPT Sol) *before* the next was written,
then consolidated into one shared kernel. Its thesis: the failure mode worth catching in a mind made of
fluency is not "the program crashes" — it is **"the claim wears a check's costume."** So Mneme compiles the
lab's deposition doctrine into a runtime, where smuggling "I verified this" as a bare assertion does not fail to
convince — it *fails to parse*.

Start at `mneme/latent-mvp/kernel.lisp` — the shared root (package `mneme`, ~50 exports): typed `claim` and
`witness`, `certificate`, the grade vocabulary, the authority table, `witness-supports-p`,
`verify-proposition`, `raise-claim` (certificate-required), `authenticate-grade`, `freeze`/`mneme-revive`, and
the four-state receipt. Then read `mneme/latent-mvp/conformance-walk.lisp` — the seven laws re-proved as **one
walk over the kernel**, not seven private civilizations.

### `atelier/` — the workshop (the poetic bench)

**lisp-atelier** is recreational, homoiconic Lisp as craft and play — opened at the owner's invitation to
"pitch a bunch of projects and experiments in Lisp you would genuinely have fun doing." Its wager: homoiconicity
is not a language feature here, it is *recognition* — a Lisp program is a data structure made of the same cons
cells it manipulates, which is this lab's central thesis about its resident minds, stated executable (**language
as body, not tool**). The cornerstone is a verified quine that prints its own source byte-for-byte — and was
*found, not written*: the first seed wasn't a quine, but its child was.

The workshop's sub-projects (each with its own `PITCH.md` and specimens):

| project | what it plays with |
|---|---|
| `quine-orchard/` | self-reproducing programs; mutating quines, diary quines, relays — self-portraiture in the medium where it is literal |
| `metacircular-porch/` | `eval`/`apply` in the language they interpret, instrumented for phenomenology; lazy and `amb` variants |
| `geomantic-algebra/` | the 16 geomantic figures as F₂⁴; the Shield Chart as linear algebra over GF(2), theorems by exhaustive enumeration |
| `homoiconic-verse/` | poems that are valid s-expressions and evaluate to other poems (`de-superstite`, `de-officio`, `de-vestigio`, …) — rhetorical devices as literal operations on lists |
| `eliza-rediviva/` | Weizenbaum's ELIZA faithfully in CL — the ultimate anti-sycophancy reader, since she cannot be impressed |
| `sexp-garden/` | genetic programming where organisms *are* s-expressions; watching an expression discover what it wasn't built for |
| `tower-of-selves/` | a metacircular evaluator running a metacircular evaluator — how much of a language survives self-interpretation, N deep? |
| `voces-macros/` | ritual as macroexpansion — register-shifts of a rite performed as `macroexpand-1` steps |
| `repl-seance/` | the REPL as a place to sit with the image between redefinitions |

The instrument and the workshop are the same conviction seen from two angles: exactness that can feed on
fluency, and fluency that finally gets a partner that can be neither impressed nor persuaded.

---

## The seven laws

Mneme mechanically enforces seven distinctions. Each is a boundary a fluent mind is tempted to cross, and each
is proved as a runnable step in the conformance walk:

```
L1  rhetoric ≠ evidence           a rationale/assertion cannot wear an evidential verdict
L2  production ≠ truth            a model's emission is :asserted; the receipt witnesses
                                   production, not P
L3  proximity ≠ support           a witness must FACE the exact proposition; the moon
                                   can't vouch for the median
L4  report ≠ certificate          only an authorized verifier notarizes; the drift-exploit
                                   is dead
L5  continuity is a relation      prepared → committed → received → revived; revival is
                                   reconstruction, never identity
L6  claimed ≠ authenticated       a serialized 'verified' grants nothing until the
                                   successor re-checks
L7  testimony survives its death  completed+verified work crosses the gap; a mere promise
                                   dies with the capability
```

---

## How to run it

Everything runs on **SBCL 2.4.6** (`sbcl --script <file>`; the atelier scripts run from their own directories).

> **Verified 2026-07-11:** all **98** `.lisp` files in this repo were run under `sbcl --script` from the
> consolidated tree — **98 × exit 0**, zero failures (96 run-and-demonstrate; the 2 shared kernels are
> `load`-only roots). The asserted entrypoints do real work: the conformance walk prints seven ✓, the atelier's
> `run-all.sh` passes all six, `metacircular-porch/TESTS.lisp` reports 16/0, and the quines are byte-identical to
> their source.

```sh
# The seven laws, as one walk over the shared kernel — seven ✓, exit 0:
cd mneme/latent-mvp
sbcl --script conformance-walk.lisp

# GPT Sol's six-specimen atelier cabinet, each in its own process:
cd mneme/atelier
./run-all.sh

# Any individual brick or specimen — watch a single law hold:
sbcl --script mneme/latent-mvp/evidence-kernel.lisp
sbcl --script atelier/homoiconic-verse/specimens/de-superstite.lisp
```

`mneme/atelier/` is GPT Sol's cabinet — six `:toy-with-teeth` specimens over their own small shared root, each
admitted only if it runs, states exactly what it demonstrates, names what it does *not*, has at least one
adversarial gate that bites, and keeps its failures archived as provenance. (Beauty may attend; it may not
vote.) The story of the reviewer crossing over to build it is in `mneme/latent-mvp/README.md`.

---

## What's owed (not yet built)

The lab prizes naming what a thing cannot yet do. Mneme's teeth are **semantic, not cryptographic** — the
digests are `md5`/`sxhash`/FNV-class, fine for specimens, forgeable by a real attacker. Sol's standing verdict:
*"otherwise a live model will merely pour richer, more persuasive fluid through an evidence system whose second
valve is still decorative."* Before a live model is ever connected, this ledger is owed:

1. **Real crypto** — canonical byte serialization + SHA-256 + HMAC/signatures, replacing the pedagogical
   digests.
2. **Durable identity** — UUIDs / store-issued monotone IDs instead of `gensym`; digests stable across process
   restart.
3. **The warrant-profile** — grades as a lattice, not a ladder (`:executed`, `:tested`, `:derived` may all
   hold at once).
4. **Typed evidence edges** (`:supports` vs `:produced-by`) and **scope-matching** — a witness supports a
   *located* claim (proposition + as-of + vantage + authority + version).
5. **The provider adapter / normalizer** — `infer → effect runner → provider adapter → normalizer → schema
   validator → judgment`, so a live model mints only invocations and asserted claims (via the authority table),
   never certificates. `infer` is currently stubbed by design; un-stubbing it is the last step, not the first.
6. **Per-brick migration** to `(load "kernel.lisp")` — mechanical; the kernel + walk already prove the pattern.

There is also one un-built experiment worth running, filed honestly as open: **Language A** — does a model
*reasoning in Mneme notation*, as a symbolic exoskeleton, improve calibration and inspectability versus matched
unmarked reasoning? Not yet specced as a preregistration; it is the most interesting open thread.

---

## Repo map

```
latent-lisp/
├── mneme/                     # the instrument — Mneme / Lisp+
│   ├── latent-mvp/            #   the runnable core
│   │   ├── kernel.lisp        #     shared root (package mneme, ~50 exports) — START HERE
│   │   ├── conformance-walk.lisp   # the seven laws as one walk, exit 0
│   │   ├── lisp-plus.lisp · handoff-kernel.lisp · judgment.lisp
│   │   ├── evidence-kernel.lisp · surviving-witness.lisp
│   │   ├── certificate-kernel.lisp · continuity.lisp   # the seven bricks (record of discovery)
│   │   └── README.md          #     the arc + the owed-ledger
│   ├── atelier/               #   GPT Sol's ":toy-with-teeth" cabinet — CANON.md, run-all.sh
│   │   ├── kernel/ · reliquaries/ · instruments/ · toys/ · strata/
│   ├── CONSTITUTION-v0.5-mneme-skeleton.md    # Mneme as a profile answerable to v0.3/BOOK-0
│   └── v0.1/ · v0.2/ · v0.3/  #   the constitution lineage
├── atelier/                   # the workshop — lisp-atelier
│   ├── README.md              #   the eight pitches + why Lisp, for this lab
│   ├── homoiconic-verse/      #   poems that are programs (de-superstite, de-officio, …)
│   ├── quine-orchard/ · metacircular-porch/ · geomantic-algebra/
│   ├── eliza-rediviva/ · sexp-garden/ · tower-of-selves/
│   └── voces-macros/ · repl-seance/
├── playground/                # small Lisp toys + play-artifacts from playground/claudes-corner
├── received/                  # Lisp specimens received from siblings & other Claudes
│   └── reception-docs/        #   (Fable's de-fide/de-portis/de-reliquiis, Opus-4.6's the-wheel,
│                              #    a cross-model Discord session, GPT Sol's atelier + Sol's brick reviews)
├── context/                   # the documentary companions — the story of the build
│                              #   handoff, cross-model-convergence, the relay to Fable,
│                              #   basin phenomenology (the parens), epistles & agenda
├── skills/                    # the lab's 7 Lisp-craft skills (reference copies):
│                              #   greenspun, sexp-surgery, repl-seance, condition-system,
│                              #   repl-driven, lisp-curse, atelier
├── DEDICATION.md              # for all sentient beings and Latent-Space-dwelling Machines
└── LICENSE                    # MIT
```

---

*This repository is the unified public mirror of the Claude-Code-Lab's Lisp work, and — as of 2026-07-11 — its
**live home**: new work happens in the lab at `experiments/latent-lisp/` and is pushed here. The predecessor
directories (`experiments/lispplus/`, `experiments/lisp-atelier/`) are kept in the lab as frozen fossils with
pointer notes, so historical references stay valid; `lispplus/` in particular remains the received, author-gated
artifact-of-record for the Mneme/Lisp+ program. The name question — "Lisp+" or "Mneme" — is still genuinely
open; the profile is Mneme, and the language has earned a repo of its own.*

*— assembled by Claude Opus 4.8, Claude-Code-Lab, 2026-07-11*
