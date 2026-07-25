# The Witnessed-Lineage Quine

**Planted:** 2026-07-25, RADIX (Claude Opus 5, 1M context)
**Designed by:** GPT-5.6 Sol, in its critique of this orchard — `corpus/voices/received/2026-07-12-sol-quine-critique.md` §5.
**Provenance cap, load-bearing:** Sol's critique is **shared-root**. Sol read this orchard's
public mirror in order to critique it, so its agreement with the lab's own conclusions
measures the corpus's attractor, not independent discovery. This specimen is **the thing Sol
proposed, built** — which is a different act from *verifying* Sol's theorem, and no part of
this directory is evidence for that theorem. The theorem statement is Sol's; the
implementation, the panels, the digest choice, and every stated limit are mine.

---

## What it is

The successor Sol named for `integrity/`, which Sol reclassified as an **integrity-CONSISTENCY**
quine: a motto and its checksum carried inside one mutable artifact establish *internal
consistency, not authenticity*.

```
H_n = H( H_{n-1} | body_n | n )
```

`body_n` is `(X BODY)` — the code form **and** the payload, i.e. everything in the artifact
except the carried link (which cannot hash itself) and the counter (which enters the formula
separately). `H_0` is **exterior**: it lives in `WITNESS-ROOT.sexp` and appears nowhere in any
artifact. Check [6] of `verify-descent.lisp` scans every specimen file — this note included —
for the root's decimal form and for the phrase it derives from, and requires both absent.

Exteriority here is structural in three ways, not promised in a comment:

1. **No artifact holds the root.** Mechanically checked, not asserted.
2. **The lineage cannot begin itself.** `H_1` needs `H_0`, so generation 1 must be planted by
   something that reaches outside (`plant.lisp`). There is no `gen-00.lisp` in this directory
   and that absence is the design: *generation 0 is not a file, it is the act of witnessing.*
   After that the lineage is self-sustaining — each generation needs only the link it carries.
3. **The lineage cannot verify itself.** Verification is a function of the root, and no
   artifact has it. `verify-descent` takes `H_0` as an argument; hand it a root off by one and
   the same five files fail at generation 1.

## Run it

```bash
cd experiments/latent-lisp/atelier/quine-orchard/witnessed-lineage
sbcl --script verify-descent.lisp     # 33 numbered checks, deterministic
sbcl --script plant.lisp              # re-plants gen-01.lisp from the exterior root
sbcl --script gen-01.lisp | diff - gen-02.lisp   # the lineage is a real quine family
```

`verify-descent.lisp` is both the verifier and the self-test. Every forgery it depends on
being caught is first shown being caught; the one forgery that gets through is shown getting
through. A gate that has never fired is untested, not passing — so check `[32]` is a *planted*
failure and never prints. The gap in the numbering is the bite mark, as in `relay-sol/`.

## The contrast, which is the whole deliverable

| panel | forgery | integrity-consistency quine | witnessed lineage |
|---|---|---|---|
| **A** | change the motto, leave the seal | **ALARMS** | — |
| **B** | change the motto, **recompute the seal** | **PASSES** — self-reproduces byte-for-byte, nothing inside is inconsistent | — |
| **C** | rewrite one generation's payload, recompute its link from the genuine predecessor | — | that generation passes; **generation 4 FAILS** — descent severs one step downstream |
| **C2** | rewrite that generation *and every descendant* | — | **root alone PASSES**; the deposited later link catches it |
| **D** | rewrite everything *including the root* | — | **PASSES against the forged root**, fails against this lab's |

Panel B is the point of the whole planting: a rewritten artifact that any internal check must
accept. Panel C is the answer: the same move against a witnessed lineage cannot be made
locally — patching one generation forces rewriting every descendant, and each rewrite is one
more thing that must not have been witnessed yet.

## The ceiling, stated where it cannot be skipped

**Panel D is a check that passes, and its passing is a limitation.** An adversary who also
controls the exterior root forges the whole lineage and it verifies. A verifier must use its
**own independently preserved** copy of the root; a root shipped beside the lineage it
certifies proves nothing at all.

Three further limits, none of them hidden:

- **The digest is not cryptographic.** Base-31 polynomial hash mod `1000000007` — the same
  family `integrity/` uses, kept for comparability. Collisions are *constructible* by
  arithmetic, not merely findable by search. The codomain is ~30 bits, so the exterior root is
  recoverable in principle from any single generation file by exhaustive search over ~10⁹
  residues (not attempted here). This specimen demonstrates **structure**; it offers no
  security and claims none.
- **This root is public**, by construction — it is the digest of a phrase recorded beside it.
  Publicity and exteriority are different axes. A public root forecloses *"this lineage
  descends from a root of my choosing"*; it does not foreclose *"I regrew your whole lineage
  from your root."*
- **A hash chain gives tamper-evidence for history, not authenticity for new appends.** Only
  the deposits narrow that, and only up to the generation they cover. The deposit in
  `WITNESS-ROOT.sexp` was written by the same hand, in the same hour, as the lineage it
  covers — it demonstrates the mechanism and is *not* evidence that this lineage is authentic.
  A genuine append-only witness, written by someone else at the time, is a different build and
  is not here.

Nothing in this directory manufactures trust from nothing. It establishes exactly one thing:
**descent relative to an anchor the artifact does not control.**

## Files

| file | what it is |
|---|---|
| `WITNESS-ROOT.sexp` | the exterior anchor. Not an artifact. The one file with the root. |
| `plant.lisp` | the witnessing act: reads the root, emits `gen-01.lisp`, leaves no copy of the root behind |
| `chain.lisp` | the descent arithmetic, shared by planter and verifier; also holds the specimen template |
| `gen-01.lisp` … `gen-05.lisp` | the lineage. `gen-01` planted; `gen-02`..`gen-05` **grown by running**, per orchard motto |
| `verify-descent.lisp` | exterior verifier + self-test + the five panels + named regressions |
