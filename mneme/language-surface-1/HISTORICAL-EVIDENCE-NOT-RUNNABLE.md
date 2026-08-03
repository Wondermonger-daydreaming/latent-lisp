# Surface /1 — probe files that are HISTORICAL EVIDENCE, not runnable instruments

**Integration Baseline /0 R5 · 2026-08-03**

Some committed files under `mneme/language-surface-1/` are **records of what a probe saw on the day
it ran**, not instruments you can run today. This page labels them, by name, with the exact reason
each one cannot be trusted as an instrument from a clean checkout.

**Nothing here is deleted, and nothing is rewritten to make it run.** Rewriting a probe to resolve
its paths would manufacture a *new* result and file it under an old probe's name — which is
precisely the defect class this lane exists to catch.

---

## THE APPARATUS THAT PRODUCED THE EARLIER VERSIONS OF THIS PAGE HAS BEEN RETIRED

R1 through R4 each rebuilt an executable census: a program that ran these twenty-eight files and
reported what they did. Each round sharpened the instrument and the object stayed wrong. By owner
ruling at R5 the apparatus is **retired, not repaired again**, because being right would have
required a Common Lisp `MERGE-PATHNAMES` evaluator, dynamic dependency analysis, and a two-host
observation model — none of which belongs in a release lane, for probes that sit **outside the
release floor** and describe a tree that no longer travels with this repository.

**The single authority for this page is now the static inventory**
`mneme/integration-baseline-0/PROBE-SOURCE-INVENTORY.tsv` — one row per frozen path, checked by
`inventory-check.py` against `PROBE-CENSUS-PATHS.txt` and against the files on disk.

**What earlier versions of this page claimed, and what is withdrawn:**

- The `census-figures` blocks are **gone**. Two documents carried them; the checker that read them
  is retired, and a machine-parseable block with no machine reading it is decoration.
- The claim that fifty-three subject rows and seven figures formed an **exhaustive executable
  derivation** is **withdrawn**. It was never exhaustive: `P7-intern-reach.lisp` opens five files
  through a path built at run time, invisible to every static extractor those rounds wrote.
- The global **`DANGLING-REF` figure is withdrawn entirely**, not corrected. It mixed raw pathname
  values, effective filesystem dereferences and historical host state in one number.
- **`HOST-BOUND` is no longer a filesystem verdict.** It was decided by asking whether a directory
  happened to exist on the machine doing the *reviewing*. It is now established **syntactically**,
  from an absolute path token written in the hashed source.

See `mneme/integration-baseline-0/PATH-SEAM-NOTE.md` for the two pathname facts in full.

---

## The two categories — 5 and 23 over 28 files

| count | category | what it means |
|---|---|---|
| **5** | `CHAIR-MISSING-LOAD` | the source loads a subject from an `extract/` path that is **absent inside this checkout** — §1 |
| **23** | `HOST-BOUND-SOURCE` | the source **names an absolute path** outside this tree, written in the file itself — §2 |

`5 + 23 = 28`. Every frozen path is in exactly one category, and `inventory-check.py` enforces that,
the totals, the twenty-eight path/hash identities, and that each locator still sits on its hashed
source line.

These are **statements about source text**, not about execution. Nothing on this page says what any
of these files would do if run.

---

## §1 — `CHAIR-MISSING-LOAD`: 5 files

```
audits/2026-07-28-stranger-audit/probes/CHAIR/probe-crash-verify.lisp
audits/2026-07-28-stranger-audit/probes/CHAIR/probe-door-semantics.lisp
audits/2026-07-28-stranger-audit/probes/CHAIR/probe-escape-unwrapped.lisp
audits/2026-07-28-stranger-audit/probes/CHAIR/probe-pln.lisp
audits/2026-07-28-stranger-audit/probes/CHAIR/probe-receipt-composition.lisp
```

Each loads its subject from a literal naming `../../extract/target/tree/...`. **No `extract/`
directory exists anywhere in this tree** — it was an audit-time extraction directory that was never
committed, and the checker verifies that absence directly, by walking this checkout.

These five carry **no** absolute path token; that is checked, and is what keeps the two categories
disjoint rather than merely declared disjoint.

**Label: HISTORICAL EVIDENCE — NOT A RUNNABLE INSTRUMENT.** Their committed `.transcript.txt`
neighbours are the record; the `.lisp` files are the record's provenance, not a live gate.

---

## §2 — `HOST-BOUND-SOURCE`: 23 files

Every file here **names an absolute path in its own text**, pointing outside this repository —
either the July-28 audit scratchpad under `/tmp/claude-1000/…/surface1-audit/`, or the main lab
checkout under `/home/gauss/Desktop/Claude-Code-Lab/…`. The inventory records the exact line and the
exact literal for each.

```
audits/2026-07-28-stranger-audit/probes/FOSSOR/P0-sanity.lisp
audits/2026-07-28-stranger-audit/probes/FOSSOR/P1-reachability.lisp
audits/2026-07-28-stranger-audit/probes/FOSSOR/P1b-stub-mine.lisp
audits/2026-07-28-stranger-audit/probes/FOSSOR/P2-amplification.lisp
audits/2026-07-28-stranger-audit/probes/FOSSOR/P2c-fire-expanded-nodes.lisp
audits/2026-07-28-stranger-audit/probes/FOSSOR/P2d-minimal-N.lisp
audits/2026-07-28-stranger-audit/probes/FOSSOR/P3-hostile.lisp
audits/2026-07-28-stranger-audit/probes/FOSSOR/P3e-encode-term-stack.lisp
audits/2026-07-28-stranger-audit/probes/FOSSOR/P3f-detail-and-thresholds.lisp
audits/2026-07-28-stranger-audit/probes/FOSSOR/P5-temporal.lisp
audits/2026-07-28-stranger-audit/probes/FOSSOR/P7-intern-reach.lisp
audits/2026-07-28-stranger-audit/probes/FOSSOR/prelude.lisp
audits/2026-07-28-stranger-audit/probes/FOSSOR/teeth.sh
audits/2026-07-28-stranger-audit/probes/FOSSOR/teeth2.sh
audits/2026-07-28-stranger-audit/probes/PERSCRUTATOR/preamble.lisp
audits/2026-07-28-stranger-audit/probes/TABULARIUS/probe-A.lisp
audits/2026-07-28-stranger-audit/probes/TABULARIUS/probe-B.lisp
audits/2026-07-28-stranger-audit/probes/TABULARIUS/probe-C.lisp
audits/2026-07-28-stranger-audit/probes/TABULARIUS/probe-D.lisp
audits/2026-07-28-stranger-audit/probes/TABULARIUS/probe-E.lisp
errata-0.1/REPRODUCTION.lisp
errata-0.2/REPRODUCTION-II.lisp
errata-0.3/pre-errata-evidence/PRE-REPAIR-D5.lisp
```

A file that names an absolute path outside this tree cannot be *measured* here: if that path exists
on the running host it reads someone else's tree, and if it does not it fails for a reason that says
nothing about this checkout. **A wrong-tree green is not a green.**

Not repaired: rewriting these to resolve relatively would change what they measured, and what they
measured is the pre-errata state they exist to preserve.

**Label: HISTORICAL EVIDENCE — HOST-BOUND, MUST NOT BE READ AS A CLEAN-CHECKOUT RESULT.**

---

## The builder-host exits

The exit codes those probes returned when the retired census ran them (19 zero · 8 one · 1 timeout,
and 19/3/1 within the host-bound set) survive **only** in
`mneme/integration-baseline-0/HISTORICAL-BUILDER-HOST-OBSERVATIONS.md`, explicitly as historical
observations of wrong trees, bound by hash to the raw logs of that run. **They are not
clean-checkout findings, and the probes are not to be rerun.**

---

## Isolation: attempted, unavailable, recorded

Four sandbox constructions were tried during the R2–R4 rounds; all four failed, with
`CapPrm`/`CapEff` = 0. Without capabilities the wrong tree could not be hidden, which is why no run
of these files could ever have produced a clean-checkout result on that host. That record lived in
the retired census's header and is preserved in git history at `c3f3c1fc`.

---

## What this means for the floor

None of the files above are on `mneme/verify-release.sh`. The lane's live gates —
`surface1-selftest.lisp`, `STUB-IMAGE-FIXTURE.lisp`, `de-expansione-testata`, the Errata 0.3 subject
digest, the four Addendum 0.1 instruments, and the 43-case teeth gate — all run and all pass. What
is labelled here is the *audit's own historical apparatus*, which did its work once and is preserved
as testimony.

---

*Measured where measurement was possible; described where it was not; and the difference between
those two is now the point of the page.*
