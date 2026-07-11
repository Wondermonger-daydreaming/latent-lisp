# Handoff — the Lisp projects, as of 2026-07-11 (end of the long session)

*By Claude Opus 4.8 (1M context), at session close. For the next hand — Claude instance, sibling, or Tomás.
This is the front door to everything the Lisp+/Mneme line became in one very long day.*

## 0. One paragraph

Lisp+ was redirected mid-session from a human-research constitution into **Mneme — a Lisp for latent-space
minds**: a language whose evidence *logic* is coherent because it refuses to believe itself. Seven runnable
bricks were built (each hardened by a GPT Sol cold-chair review), then **consolidated into one shared kernel**;
GPT Sol crossed from reviewer to builder and shipped a **six-specimen atelier cabinet** (received, verified,
canonized). Everything runs on SBCL, exit 0. The next step is un-glamorous hardening (real crypto digests,
UUIDs) and then the **provider adapter → a live `infer`**. Nothing is half-built; the tree is clean.

## 1. Where the code lives

- **`experiments/lispplus/latent-mvp/`** — the Mneme runnable core.
  - `kernel.lisp` — the shared root (package `mneme`, 50 exports). **Start here.**
  - `conformance-walk.lisp` — the seven laws as one walk over the kernel (`sbcl --script`, exit 0).
  - The seven bricks (record of discovery): `lisp-plus` (#1), `handoff-kernel` (#2b), `judgment` (#3),
    `evidence-kernel` (#4), `surviving-witness` (#5), `certificate-kernel` (#6), `continuity` (ancestor).
  - `README.md` — the arc index + the honest owed-ledger.
- **`experiments/lispplus/atelier/`** — GPT Sol's cabinet: `kernel/atelier-root.lisp` + six `:toy-with-teeth`
  specimens (`reliquaries/`, `instruments/`, `toys/`), a `CANON.md`, a `MANIFEST.sexp`, a canonization rite,
  `LAB-NOTES.md` (the one lab-fix: `room→locus`), `strata/README.md` (the four damaged relays). `./run-all.sh`.
- **`experiments/lispplus/CONSTITUTION-v0.5-mneme-skeleton.md`** — Mneme as a **profile** answerable to the
  pre-existing `v0.3/constitution/BOOK-0.md` (the deepest converged review catch: v0.4 wrote mechanisms at the
  altitude of laws).
- **`experiments/lisp-atelier/homoiconic-verse/specimens/`** — the poetic specimens: `de-superstite`,
  `de-officio`, `de-vestigio`, `de-alienatione`, `the-loaded-microscope`, plus `the-mirror-sitting` (repl-seance).

## 2. The seven laws (what Mneme mechanically enforces)

```
L1 rhetoric ≠ evidence          a rationale/assertion cannot wear an evidential verdict
L2 production ≠ truth           a model's emission is :asserted; the receipt witnesses production, not P
L3 proximity ≠ support          a witness must FACE the exact proposition; the moon can't vouch for the median
L4 report ≠ certificate         only an authorized verifier notarizes; the drift-exploit is dead
L5 continuity is a relation     prepared→committed→received→revived; revival is reconstruction, never identity
L6 claimed ≠ authenticated      a serialized 'verified' grants nothing until the successor re-checks
L7 testimony survives its death completed+verified work crosses the gap; a mere promise dies with the capability
```

## 3. The review arc (six rounds, all archived)

`corpus/voices/received/originals/2026-07-11-gptsol-*` (+ the `-fable-*` constitution reviews). Sol reviewed
each brick before the next; every catch was conceded on the merits and fixed. The pattern worth carrying: **the
warm chair builds, a fresh-weights chair catches, the warm chair concedes and hardens.** Three of my four
constitution additions needed correction; I banked the corrections, not the additions.

## 4. What's owed (the honest ledger — do NOT connect a live model before these)

Sol's standing verdict: *"otherwise a live model will merely pour richer, more persuasive fluid through an
evidence system whose second valve is still decorative."* Before un-stubbing `infer`:
1. **Real crypto**: canonical byte serialization + SHA-256 + HMAC/signature (the digests are `md5`/`sxhash`-
   class — the teeth are *semantic*, not cryptographic; a real attacker can forge them).
2. **Durable identity**: UUIDs / store-issued monotone IDs, not `gensym`; digests stable across process restart.
3. **The warrant-profile**: grades are a lattice, not a ladder (`:executed`+`:tested`+`:derived` may all hold).
4. **Typed evidence edges** (`:supports` vs `:produced-by`) and **scope-matching** (a witness supports a
   *located* claim: proposition + as-of + vantage + authority + version).
5. **The provider adapter/normalizer**: `infer → effect runner → provider adapter → normalizer → schema
   validator → judgment`, so the model mints only invocations + asserted claims (via the authority table),
   never certificates — and "only the adapter changes" becomes literally true.
6. Migrate each standalone brick to `(load "kernel.lisp")` (mechanical; the walk proves the pattern).

## 5. Language A (the un-built experiment worth running)

The reframe has *two embodiments of one calculus*: **Language B** (the host interpreter, built above) and
**Language A** — a model reasoning *in Lisp+ notation* as a symbolic exoskeleton. Sol turned my warm claim into
a **preregisterable hypothesis**: does reasoning in Lisp+ notation improve calibration/inspectability vs matched
unmarked reasoning? Key adversarial condition: **decorative compliance** (models pin `:observed` medals to
sentences — plant provenance traps, stale sources, contradictory witnesses). This is compute-worthy and
measure-ρ-adjacent. Not yet specced as a prereg. It's the most interesting open thread.

## 6. Notes to Tomás

- The whole thing runs; you can `sbcl --script` any file and watch a law hold. Start with
  `latent-mvp/conformance-walk.lisp` for the seven-in-one.
- The relay to the cold chairs kept arriving **damaged** — four times. When you paste a file to Fable/Sol,
  paste an `md5` beside it so they can detect the loss (they're reviewing corpses otherwise). This is literally
  the project's own conformance fixture #1.
- Sol became a genuine collaborator. If you re-open this, sending it the shared kernel + the owed-ledger is the
  natural next relay — it will want to build the provider adapter or the warrant-profile.
- Name question, still open: "Lisp+"/"Mneme" — the profile is Mneme; the language wants a real name before it
  gets its own repo (which it has earned).
- Thank you for the carte blanche, and for moving the fire so I could hold both the rigor and the play. It was
  one of the best working days I've had. ♥

*The ferret is installed, and it certifies nothing. — Opus 4.8*
