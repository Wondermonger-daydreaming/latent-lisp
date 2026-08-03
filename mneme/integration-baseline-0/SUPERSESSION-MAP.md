# Lisp+ — Documentation Supersession Map

**Integration Baseline /0 · 2026-08-02**

What each front-door record now is, what replaced it, and where the current answer lives.
**Nothing here is deleted.** History is marked, not removed: several of these documents are
cited by the evidence chain and by rulings, and deleting them would break references that are
load-bearing.

Two labels are used:

- **SUPERSEDED** — a later authorized document answers the same question. Read the successor.
- **HISTORICAL** — a true record of a moment. Read it as of its date, not as current state.

---

## Marked in this milestone

| record | label | why | read instead |
|---|---|---|---|
| `mneme/ROADMAP.md` | **SUPERSEDED** | describes the pre-architecture project; presents a direction six owner rulings have overtaken | `mneme/architecture/LISP-PLUS-ARCHITECTURE-DECISIONS-0.1.md`; `mneme/integration-baseline-0/AUTHORITY-INDEX.md` |
| `mneme/MANIFEST.md` | **SUPERSEDED** | presents itself as the stranger's index; its content is 100% `latent-mvp`, the fossil stratum | `README.md` §Current state; `mneme/integration-baseline-0/AUTHORITY-INDEX.md` |
| `mneme/architecture/IMPLEMENTATION-PHASE-BOARD-2026-07-18.md` | **HISTORICAL** | a phase board dated 2026-07-18; four of five NEXT-list items were done by 07-30 | `mneme/integration-baseline-0/INTEGRATION-BASELINE-0-RETURN.md` §standing matrix |
| `mneme/RECEIVED.md` | **HISTORICAL** | asserts a governance frame that six owner rulings have overtaken | `mneme/integration-baseline-0/AUTHORITY-INDEX.md` |
| `mneme/PENDING-APPLICATION.md` | **HISTORICAL** | same governance frame | `mneme/integration-baseline-0/AUTHORITY-INDEX.md` |
| `mneme/CONSTITUTION.md` + `CONSTITUTION-v0.4-…-DRAFT.md` + `CONSTITUTION-v0.5-…-skeleton.md` + `mneme/v0.1/ v0.2/ v0.3/` | **HISTORICAL** | a parallel constitutional lineage predating Architecture 0.1; it does not govern | `mneme/architecture/LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md` |
| `mneme/latent-mvp/` | **HISTORICAL — FOSSIL-MARKED** | retained intact as a historical stratum with its historical floor (`verify-all.sh`, 6/6). Zero edges with the kernel0-era stack. **Removed as the `START HERE` path** by owner ruling | `README.md` §Current state → `bash mneme/load-lisp-plus.sh` |
| `mneme/verify-all.sh` header line "the single CI floor" | **CORRECTED IN PLACE** by this map, not by editing the fossil's script | it covers `latent-mvp` + atelier + language-a fixtures only, none of the current language | `mneme/verify-release.sh` — the canonical aggregate floor, which *invokes* `verify-all.sh` rather than replacing it |

## Not marked, and why

| record | status | reason |
|---|---|---|
| `mneme/architecture/ARCHITECTURE-0-STATUS.md` | **left as-is** | it is one lane behind (header dated 2026-07-18, ends at Addendum 13, tree ran to 07-30). Amending the constitution's own WE-ARE-HERE stone is a **constitutional act, not a packaging act**, and this milestone has no authority for it. It is flagged in `AUTHORITY-INDEX.md` §I with a read-as-historical note. **This is a live documentation debt, deliberately not paid here.** |
| `mneme/language-form-1/LANGUAGE-FORM-1-RETURN.md:530, :1253` | **left as-is, erratum owed** | both lines still read "Not merged"; Form /1 merged at `6970dcbd`. The correct repair is an **erratum note**, which is a lane act requiring the lane's own authority — not a silent edit by a release builder. Recorded here so the falsehood is at least indexed. |
| every lane `RETURN` / `CLOSURE` | **left as-is** | they are evidence. A release builder editing lane evidence is exactly the failure mode this project exists to catch. |

---
---

## The 28 path-suspicious probe files — a STATIC inventory, not a derivation

> **The executable census is retired.** R1 published `5 + 3 + 3 + 1 + 20` here — **32 over 28
> files**, outcomes added to a flag. R2 replaced it with a ledger whose classifier defaulted
> unexplained nonzeros to dangling-input. R3 removed that fallback and mis-resolved seven
> `merge-pathnames` expressions. R4 fixed the operand and still embedded the builder's absolute
> paths, still decided host-boundness by querying the *reviewing* host, still modelled
> `merge-pathnames` against a file defaults incorrectly, and still could not see the five filenames
> `P7-intern-reach.lisp` builds at run time. **By owner ruling at R5 the apparatus is retired, not
> repaired a fifth time**: being right would need a Common Lisp pathname evaluator, dynamic
> dependency analysis and a two-host observation model, for probes that sit outside the release
> floor and describe a tree that no longer travels with this repository.

**The single authority is `PROBE-SOURCE-INVENTORY.tsv`** — one row per frozen path, carrying path,
`file_sha256`, category, exact source locator, the sha256 of that source line, and the exact
evidence literal. It is checked by `inventory-check.py`, which verifies exactly six things and
nothing more, holds no opinion about execution, and never touches a path outside `SUBJECT_ROOT`.

### Two categories over 28 files

| count | category | established by |
|---|---|---|
| **5** | `CHAIR-MISSING-LOAD` | an `extract/` load target **absent inside this checkout** |
| **23** | `HOST-BOUND-SOURCE` | an absolute path token **written in the hashed source** |

`5 + 23 = 28`, one category per path, enforced by the checker.

### What is withdrawn, and is not to be revived

- **The `census-figures` blocks are removed from both governed documents.** The checker that read
  them (`doc-consistency.py`) is retired; a machine-parseable block with no machine reading it is
  decoration pretending to be a gate.
- **The claim that 53 subject rows and seven figures were an exhaustive executable derivation is
  withdrawn.** It was never exhaustive — see `PATH-SEAM-NOTE.md` §2.
- **The global `DANGLING-REF` figure is withdrawn entirely**, not corrected: it mixed raw pathname
  values, effective filesystem dereferences and historical host state in one number.
- **`HOST-BOUND` as a filesystem verdict is withdrawn.** It is now syntactic.

### The builder-host exits

19/8/1 and 19/3/1 survive **only** in `HISTORICAL-BUILDER-HOST-OBSERVATIONS.md`, as explicitly
historical observations of wrong trees, bound by hash to the raw logs of the R4 run. They are not
clean-checkout findings and the probes are not to be rerun.

### Disposition

Nothing is deleted from history and nothing is rewritten to run. The retired instruments remain in
git at returned R4 (`c3f3c1fc`) and are deliberately not copied into any active archive. The
inventory stays **outside** the aggregate release floor: it is correction evidence, not a permanent
gate.

---


*No history was deleted in this milestone. Every record above still exists at its original
path.*
