> **HISTORICAL RECORD — committed 2026-08-19 by owner instruction (housekeeping charge).**
> This is the four-agent advisory assessment of the tree as it stood at `ef4097a8…`
> (2026-08-02), preserved verbatim. Its recommendations were adjudicated by the owner's
> Integration Baseline /0 ruling (`RULING-integration-baseline-0-owner-ruling-and-work-order-2026-08-02.md`)
> and IB0 was built and CLOSED 2026-08-03; several facts below (mirror mechanics, README
> front doors, floors, scratch litter, custody) were changed by that arc and its successors.
> Read `architecture/ARCHITECTURE-0-STATUS.md` (Addendum 14 onward) for current state.
> Nothing in this document is current direction.

# Lisp+ / Mneme Project-State Assessment — 2026-08-02

*Prepared by PRAETOR (Claude Fable 5), synthesizing three same-day evidence sweeps —
TOPOS (identity/topology/late returns), TALLY (census/reading/drift), PROBE (executable
health, ~92 commands) — plus PRAETOR's own spot-verification against the live tree.
Uncommitted report; the only repository write of this commission.*

Evidence tags: **OBSERVED** (this commission ran the command / read the bytes — by an
evidence agent or by PRAETOR directly), **DERIVED** (computed from observations),
**REPORTED** (= REPORTED-BY-EXISTING-ARTIFACT; an artifact says so, unverified),
**RECOMMENDED**, **UNKNOWN**. Where PRAETOR independently re-verified an agent claim it
is marked OBSERVED (PRAETOR).

---

## 0. Executive verdict

- **Inspected state:** all substantive findings were gathered against subject tree
  `experiments/latent-lisp` = **`ef4097a869364d1150905d43f103df689cf04dff`** (the bytes at
  `c414152f`, whose last subject commit is `3cd53351`, 2026-07-30). At report time lab HEAD
  is **`df1c0db5`** (a tools-only checkpoint descendant of the restoration commit
  **`910315b5`**), and the subject subtree at HEAD is **byte-identical** to the inspected
  state (`git rev-parse HEAD:experiments/latent-lisp` = `ef4097a8…` — OBSERVED (PRAETOR)).
  Mid-assessment, lab Stop-hook checkpoints (`e02d298c`, `410433b4`) committed PROBE's
  in-flight suite output over banked evidence and the auto-sync published it; `910315b5`
  restored every tracked subject file byte-for-byte (§1.3, §6.6).
- **Lab main vs public mirror:** content-identical for all tracked bytes except two
  deliberately excluded `_staging/` drafts; mirror tip `9bb311d6…938` = `auto-sync: lab 910315b5`.
  The mirror additionally carries **61 untracked scratch directories** published from the
  working tree (§6.6) and, on unmerged branches, the only surviving copy of the 706-file
  Language-A tranche-B campaign (§6.4).
- **One-sentence honest description:** Lisp+/Mneme is an adopted five-spec constitution with
  nineteen green-but-ungated candidate implementation packages arranged in two nearly
  disjoint stacks joined at one un-ruled seam, plus a fossil MVP the README still calls the
  front door — a research ladder of high local rigor that is not yet one runnable language.
- **Strongest earned claim:** every implementation lane passes its own declared gates from
  current sources today (0 semantic failures across ~92 commands), two implementations pass
  adopted frozen vector sets as independently seeded CL code (journal0 89/0; adapter0 107/0,
  Rider 1 ruled SATISFIED), and real cross-language differentials run green (LCI/0: 2,295
  requests/implementation, 0 mismatches).
- **Most serious weakness:** nothing aggregates — 12 of 19 principal packages sit on no
  floor, there is no ASDF system, CI, or install path for any mneme lane, and the only
  Stack-A↔Stack-B integration point (Surface /2) is the one lane closed without an owner
  ruling.
- **Selected primary milestone:** **Option C — the First Coherent Runnable Release**
  (one ASDF system, one aggregate floor covering all lanes, one root entrypoint, one
  end-to-end demonstration, one current claim ceiling) — §13.
- **Parallel lane:** **Custody & Archive Integrity** (Language-A tranche-B bundle rescue;
  freezer copies of the two unfrozen parcels; scratch-dir disposition) — §13.
- **Explicitly deferred:** stranger primitive-minimization audit (promotion gate, cheaper
  after consolidation); second implementation; live provider adapter; Mneme memory
  integration; any new Slice/Form/Surface.
- **Confidence:** high on repository facts (three independent sweeps + spot-verification);
  the major unknown is **owner intent on Surface /2's standing** — the sole integration
  seam's closure exists only as chair prose (§6.2, Decision D1).

---

## 1. Inspection boundary and repository identity

**OBSERVED** (TOPOS §1, re-verified in part by PRAETOR):

| fact | value |
|---|---|
| lab repo root / branch | `/home/gauss/Desktop/Claude-Code-Lab`, `main`, one worktree, no linked worktrees |
| HEAD at evidence-gathering start | `c414152f` (tree `377f8241`) |
| HEAD at report time (PRAETOR) | `df1c0db5` — sequence: `c414152f` → `94dc825b` (hook: tools) → `e02d298c` (hook: 3 subject files) → `410433b4` (hook: 20 subject files) → `910315b5` (chair restore) → `df1c0db5` (hook: tools) |
| subject subtree hash | `ef4097a869364d1150905d43f103df689cf04dff` at `c414152f`, `94dc825b`, and HEAD — **byte-identical across the whole episode** (OBSERVED (PRAETOR): `git diff --name-only e02d298c^ HEAD -- experiments/latent-lisp` → 0 files) |
| tracked files under subject tree | 4,565 |
| lab remote | `github.com/Wondermonger-daydreaming/Claude-Code-Lab`; fetch succeeded 2026-08-02 ~15:13; no freshness caveat |
| local branches | 12, **all merged into main**; `git branch --no-merged main` empty — no local branch carries unpublished latent-lisp work |
| tags | one (`v0.13-provenance-loop`, unrelated); no Lisp+/Mneme milestone is tagged |
| last subject commit | `3cd53351`, 2026-07-30 18:47 — the tree had been frozen ~3 days; no work in flight |
| stash / root `_staging/` | one unrelated 2026-05-31 stash; 6 pre-existing untracked root `_staging/` entries, untouched |

**1.1 Commit window 2026-07-24 → 07-30 (OBSERVED, TOPOS §1.9):** 347 commits on main,
139 touching the subject tree — the entire implementation era: Core /0 closed and
owner-accepted (`1aba6619`); Slice /2, Surface /0, Forms /0–/2, Surface /1 (three errata +
stranger audit + Evidence Addendum 0.1); journal0, capability0/1/2, adapter0 (+ Erratum
0.1), Vertical Specimen /0 (+ closure ruling `72b2c973`), Language Surface /2 (+ two
errata, chair-closed at `3cd53351`).

**1.2 Mirror relation (OBSERVED):** mirror publishes the lab **working directory** via
`rsync -a --delete` (excluding `.git/`, `_staging/`); its commit messages record when a
sync ran, never what content equals. Current tip `9bb311d6d5416a34939f694ada77e806595ac938`
= `auto-sync: lab 910315b5` (OBSERVED (PRAETOR): `git ls-remote` + `.sync.log`).
`verify-sync.sh` exits 1 today on **28 empty directories** under `mneme/vertical0/runs/*/exec/`
— a comparator false positive (git cannot represent empty dirs); **zero byte differences,
zero mirror-only files** (TOPOS §1.10.1). The only tracked lab bytes absent from the mirror:
`experiments/latent-lisp/_staging/{AP0-PLAN-DRAFT-F.md, pj0/PJ0-PLAN-DRAFT-F.md}` — excluded
by design.

**1.3 The mid-assessment publication incident (OBSERVED; §6.6 for disposition).** During
PROBE's floor runs, the lab's `session-checkpoint` Stop hook committed in-flight suite
output: `e02d298c` shrank `language-surface-1/errata-0.3/teeth/SUMMARY.txt` from 54 lines
to 18 and truncated two transcripts; `410433b4` committed 20 more mid-run teeth files. The
post-commit auto-sync published that state, plus 61 untracked `scratch-*` run directories,
to the public mirror (`7f72ab7 → 7dc75bd`). The chair restored all tracked subject files to
pre-session bytes at `910315b5`; the mirror re-synced to `9bb311d`. **OBSERVED (PRAETOR):**
restored `SUMMARY.txt` is 54 lines, sha256 identical to `3cd53351`'s copy; all 43 case rows
present. The 61 scratch dirs remain in the working tree and on the mirror; a copy exists
only in the session scratchpad (`…/scratchpad/tree-collateral/`, **ephemeral /tmp**). This
episode is treated as live risk evidence (§11 R1) and a decision item (§14 D7/D8).

---

## 2. Structural census

Synthesis of TALLY Part 1 (all OBSERVED by TALLY unless marked):

- **Volume:** 4,565 tracked files, 643 MB. `canonical-datum/` alone is 562 MB (87%).
  575 `.lisp`, 725 `.md`, 118 `.py`, 34 `.sh`, **4 `.asd` (none for any mneme layer)**,
  1,283 frozen `.pj0` spec vectors. The tree is 86% non-source by file count.
- **Packages:** 19 principal packages under `mneme/` + `canonical-datum/` exporting
  **1,463 symbols** (210 `defpackage` forms tree-wide including specimens/probes).
- **Concentration:** three non-language directories — `lci0/` (35 MB, 0 consumers),
  `architecture/` (14 MB, specs + frozen vectors), `vertical0/` (6.1 MB) — hold 81% of
  `mneme/`'s bytes.
- **Floors:** three aggregate runners with **zero overlap**, none invoking the others:
  `verify-all.sh` (self-described "the single CI floor", covers latent-mvp + atelier +
  language-a only), `verify-language-floor.sh` (11 floors through Surface /0),
  `verify-form-floor.sh` (Form /0 only). **12 of 19 principal packages are on no aggregate
  floor** — including every organ built in the 07-29/30 implementation era.
- **Run recipes:** 13 prose `RUN-EXITCODES.txt` files; three per-lane capture runners;
  three near-duplicate transcript reconcilers; two byte-similar `VERDICT-LIVENESS-SWEEP.sh`;
  two byte-similar stranger front-door checkers.
- **Working-directory conventions:** three incompatible relative-load roots coexist
  (tree root / own dir / lane parent); `MANIFEST.md:12-14` names this as a known trap.
- **CI / build / install:** **ABSENT** — no CI config, Makefile, or install path anywhere
  in the subject tree.
- **Authority records:** 6 canonical `mneme/RULING-*.md` (OBSERVED (PRAETOR): `ls`) plus
  **12 more ruling-class documents outside that naming convention**; no index of authority
  exists.
- **Non-reproducible committed evidence:** 15 files under `language-surface-1/` load paths
  that do not exist in the tree (`extract/`) or are session-scratchpad absolutes; 3 more
  hardcode `/home/gauss/…` (TALLY §1.13).
- **Consumer structure:** six packages have exactly one consumer; three have none
  (`form2`, `surface2`, `lci0`); `form1` exports 133 symbols of which **1** is consumed;
  `adapter0` exports 145 of which vertical0 uses ~10+22.
- **latent-mvp refinement (PRAETOR adjudication):** TALLY reported zero consumers anywhere.
  OBSERVED (PRAETOR): exactly **one** consumer exists — `atelier/monadologia/de-notione-completa.lisp`
  (a workshop specimen) calls `mneme.operator`/`mneme.client`. Within the mneme
  implementation lanes the orphan finding stands: zero edges in either direction with the
  kernel0-era stack.

**Census verdict (DERIVED):** the project is getting harder, not easier, to understand,
run, and extend — each lane raises the exported surface faster than the consumed surface,
and the aggregate-verification story has not kept pace with a single lane since 07-26.

---

## 3. Governing architecture and current dependency graph

**Governing documents (OBSERVED, TALLY §1.7; hypothesis A CONFIRMED):** Architecture 0.1
GOVERNS; Kernel /0 spec ADOPTED AND GOVERNS; Kernel Errata 0.2 ADOPTED (gaps 1–4 closed);
PJ0 ADOPTED with the binding gate (no conformance claim beyond self-consistency until an
independently-seeded CL implementation passes the full vector set — **paid by journal0**,
89/0 vectors, OBSERVED live by PROBE); AP0 ADOPTED with riders — **Rider 1 ruled SATISFIED
at `b7f70ed8`** (`RULING-adapter0-closure…` Part I), **Rider 2 still binding** (no
"independently verified/validated" language); CD/0 frozen with post-implementation ruling.
PJ0 Erratum 0.1 adjudicated (`aa36d581`). A parallel constitutional lineage
(`CONSTITUTION.md` v0.1/v0.4/v0.5 + `v0.1/ v0.2/ v0.3/`) survives unlabelled (§10 D18).

**The dependency graph as it actually is (OBSERVED edges, TALLY §1.4):**

```
                    lisp-plus-cd0 (89 exports — the only shared root)
                         │                                   │
                         ▼                                   ▼
                  lisp-plus-kernel0 (82)              lisp-plus-lci0 (64)
                     │           │                    [ISOLATED — 0 consumers,
        ┌────────────┘           └────────────┐        35 MB evidence, closed arc,
        ▼                                     ▼        "AUTHORIAL RULING REQUIRED"]
  STACK A — PROCESS/AUTHORITY          STACK B — EVIDENCE/CLAIMS/SYNTAX
  journal0 (105)                       slice0 (80)
     ▼                                    ▼
  capability0 (60)                     slice1 (74)
     ▼                                    ▼
  capability1 (46)                     slice2 (100) ◄── core0 (62)
     ▼                                    ▼
  capability2 (43) ──► adapter0 (145)  surface0 (10)
     │                     │              ▼
     └────────┬────────────┘           surface1 (80)
              ▼                           │
         vertical0 (21)                   │
              │                           │
              └────► surface2 (98) ◄──────┘
                     [THE ONLY Stack-A↔Stack-B EDGE:
                      7 journal0 + 1 capability2 imports, surface1 refs;
                      0 consumers; closed by chair prose, no owner ruling]

  FORM CHAIN (qualified refs into Stack B):
      cd0 ─► form0 (99) ─► form1 (133) ─► form2 (72, 0 consumers)

  ORPHAN: mneme/latent-mvp/ (mneme / mneme.client / mneme.operator)
      — 0 edges with the kernel0-era stack; 1 atelier-specimen consumer;
        still the README's "START HERE"
```

**DERIVED:** this is a **ladder, not a lattice** — six single-consumer links, three
terminal leaves, one seam. The July 18 phase board predicted a converging build; what
exists is two parallel builds that touched for the first time on the project's last working
day, in the one lane that has no owner disposition.

---

## 4. Multi-axis component status matrix

Normative / Implementation / Evidence / Integration standings use the commission §10
controlled vocabularies. All rows OBSERVED/DERIVED from the three sweeps unless tagged.

| component | role | authority | normative | implementation | evidence | integration | public/repo | consumers | open debts | disposition |
|---|---|---|---|---|---|---|---|---|---|---|
| Canonical Datum /0 | value/wire substrate | CD0 freeze + post-impl ruling | **ADOPTED** | PRESENT-PASSING (2,633 CL assertions; Py 71 / CL 68+3 N/A) | DIFFERENTIAL (CL↔Py, 467 req PASS) | SHARED SUBSTRATE (17 consumer dirs) | published | nearly all | none blocking | keep; root of the release |
| LCI/0 | located claim identity | LCI0 spec + POST-REVIEW-RULING | ADOPTED spec; conformance **blocked pending authorial closure** (lane's own README) | PRESENT-PASSING (comparator 2,295/impl, 0 mismatches; 49 unit tests OK) | DIFFERENTIAL + **4 preserved law FAILs awaiting ruling** | ISOLATED (0 consumers) | published; audit re-derivation impossible on host (external packet absent) | none | **"AUTHORIAL RULING REQUIRED" unanswered 18 days**; README.md:382 calls the arc "closed" | rule on the 4 violations (D2); otherwise dormant |
| Architecture 0.1 | constitution | decisions record | **GOVERNING** | n/a | n/a | n/a | published | all lanes | DK-1 channel policy still `-DRAFT`; `:redacted` rider unanswered | keep; pay the two riders eventually |
| Kernel /0 spec + Errata 0.2 | semantic core spec | adoption records | **ADOPTED/GOVERNING** | n/a | n/a | n/a | published | kernel0 | Addendum-7 carry-forwards (typed transfer, K0E-28a, …) | keep |
| kernel0 impl | pure core | spec above | CANDIDATE | PRESENT-PASSING (33/0, 59 mutants killed) | SAME-IMPLEMENTATION SELFTEST | SHARED SUBSTRATE (9 dirs) | published | 9 dirs | README count stale (29/0) | keep; onto unified floor |
| PJ0 spec / journal0 | durable journal | PJ0 adoption + Erratum 0.1 | spec **ADOPTED**; impl CANDIDATE | PRESENT-PASSING (66/0, 89/0 vectors, SIGKILL specimen) | **INDEPENDENTLY SEEDED IMPLEMENTATION** (vs frozen PJ0 vectors; REPORTED seeding) | SHARED SUBSTRATE (5 dirs) | published | cap0/1/2, surface2, vertical0 | §32.5 FULL not claimed (non-blocking); no owner ruling on impl | keep; onto unified floor |
| Capability /0 | live authority | — (no dedicated ruling) | CANDIDATE (by default) | PRESENT-PASSING (28/0, 36/0, 24/0) | SAME-IMPLEMENTATION SELFTEST | CONSUMED (cap1, vertical0) | published | 2 | no owner acceptance exists (hypothesis C revised) | fold into release; docket if owner wants parity |
| Capability /1 | opaque minting | **RULING `ab7df5bb`** (closure, accepted at `4d673c23`) | **ACCEPTED** (candidate) | PRESENT-PASSING (30/0, 27/0, 29/0) | SAME-IMPLEMENTATION SELFTEST | CONSUMED BY ONE (vertical0) | published | 1 | stranger audit owed | keep |
| Capability /2 | effect frontier | **RULING `57eac026`** (acceptance) | **ACCEPTED** (candidate) | PRESENT-PASSING (29/0, 27/0, 29/0) | SAME-IMPLEMENTATION SELFTEST | CONSUMED (surface2, vertical0) | published | 2 | C019 named non-blocking | keep |
| AP0 / adapter0 | membrane | AP0 adoption + **RULING `31f9ba90`** (Rider 1 SATISFIED) | spec ADOPTED; impl **ACCEPTED** (candidate) | PRESENT-PASSING (7 gates: 39/107/21/24/4/24/18 + specimen 12) | **INDEPENDENTLY SEEDED IMPLEMENTATION** (frozen AP0 vector set; REPORTED seeding) + CLOSED UNDER NAMED CEILING (Rider 2) | CONSUMED BY ONE (vertical0; 10+22 of 145 exports) | published; Erratum 0.1 (ketiv/qere) | 1 | Rider 2 promotion language; stranger audit owed | keep |
| Language Core /0 | derive/perform doors | CORE-0-OWNER-ACCEPTANCE | **ACCEPTED** (candidate) | PRESENT-PASSING (29+73, 5 specimens green) | SAME-FAMILY (one model family, per its own closure) | CONSUMED (slice2, surface0) | published | 2 | stranger audit owed | keep |
| Slices /0 /1 /2 | evidential promotion chain | closures + design rulings | CANDIDATE (closed lanes) | PRESENT-PASSING (all selftests/smokes green) | slice0 has **two stranger front-door implementations** (7/7 each); else self-consistency | SHARED within Stack B | published | 5–6 dirs each | slice1 `admissible` undefined as general contract; audits owed | keep |
| Forms /0 /1 /2 | program-holding chain | form0/form1 owner-rulings files; **no Form /2 ruling** | CANDIDATE; Form /2 **CANDIDATE-BY-DEFAULT, never ruled** | PRESENT-PASSING (152/0, 210/0, 86/0 + sweeps forced 210/210, 86/86) | NEGATIVE-CONTROLLED (liveness sweeps with fired controls) — connectedness only | single-consumer chain; form2 terminal (0 consumers) | published | form0→form1→form2→∅ | **D20:** Form /1 RETURN still says "Not merged" (false since `6970dcbd`); obligation specimens frozen by `3cc6308e` | keep; sign standing (D1) |
| Surfaces /0 /1 | macroexpansion honesty; expansion receipts | closures; Surface /1 stranger audit + Errata 0.3 + Addendum 0.1 | CANDIDATE | PRESENT-PASSING (38/0; 139/139 + teeth 43/43 BITES live) | Surface /1: **STRANGER AUDITED** (defects found → repaired → gate green) — the strongest evidence tier in the project | surface1 → surface2 only | published | 1 | **evidence freshness:** banked teeth transcripts predate Addendum 0.1's stricter binding (§7.3); 15 committed probe files unrunnable | keep; refresh evidence in release |
| **Surface /2** | **the only Stack-A↔Stack-B seam** | opened by `72b2c973` §5; **closed by chair prose only** | **CANDIDATE; owner standing UNKNOWN** (no ruling file — OBSERVED (PRAETOR)) | PRESENT-PASSING (29/0, 38/0, 18/0, binder 15/0) | SAME-IMPLEMENTATION SELFTEST (its RETURN says so itself) | **THE seam**; 0 consumers | published; CLOSED PERMANENTLY per `3cd53351` | 0 | no signed instrument; no freezer copy | **sign standing (D1); do not reopen code** |
| Vertical Specimen /0 | four-death latent machine | **RULING `72b2c973`** — ACCEPTED as published candidate, 5 limits docketed non-blocking | **ACCEPTED** (candidate) | PRESENT-PASSING (controls 37/0, mutation 71/0 bilateral, reconstruction 31/0; census digest `706f7e1e…` reproduces live) | NEGATIVE-CONTROLLED + SIGKILL-crash-model-only ceiling | CONSUMED BY ONE (surface2, read-only) | published | 1 | no freezer copy; gates litter ~70 scratch dirs/run | keep; the release's end-to-end demo core |
| Language-A | empirical source lane | owner-locked scoring rulings pending | CANDIDATE (emission BANKED 295/312 — REPORTED) | lab tree: 3 files; **706-file tranche-B exists ONLY on unmerged mirror branches** (`fa4ab18f` et al.) | ASSERTED (lab-side) | ISOLATED | **custody emergency** — single-copy on remote branches; local worktree gone (`~/Codex-Lab` absent, exit 2) | verify-all floor #6 | rescue copy owed; PR #1 open unadjudicated | **parallel lane: bundle rescue (D6)** |
| Mneme memory integration | provenance write/retrieve/consolidate | Architecture 0.1 names it | **UNOPENED** (no lane exists) | ABSENT | — | — | — | — | — | LATER (after release) |
| latent-mvp | v0/v1 kernel | RECEIVED.md-era frame | **SUPERSEDED (de facto); unlabelled** | PRESENT-PASSING (verify-all 6/6) | SAME-IMPLEMENTATION | **LEGACY/FOSSIL** (0 mneme edges; 1 atelier consumer) | **still the README front door** | 1 | D6/D17 drift | fossil-mark (D5) |
| package/release/CI layer | installability | — | **ABSENT** | ABSENT | — | — | — | — | the release IS this layer | **build (primary milestone)** |
| stranger primitive-minimization audit | reserved promotion gate | ARCHITECTURE-0-STATUS:82-85 | UNOPENED (seat empty) | ABSENT | — | — | — | — | debt now spans ≥9 lanes, uncounted anywhere | LATER; after release (§12 D) |
| second/cross-impl conformance lane | independence | PJ0/AP0 gates (partially paid) | PARTIAL | journal0+adapter0 paid the CL gates; no second full core | INDEPENDENTLY SEEDED (per-organ) | — | — | — | "independently seeded under shared normative infra" ceiling | LATER/CONDITIONAL |

---

## 5. The runnable end-to-end Lisp+ path

**Answering commission §11 directly.**

1. **What is Lisp+ today?** An SBCL-2.4.6-only Common Lisp construction consisting of an
   adopted specification constitution (Architecture 0.1; Kernel /0 + Errata 0.2; PJ0; AP0;
   CD/0) and nineteen candidate implementation packages in two nearly disjoint stacks — a
   process/authority stack (journal0 → capability0/1/2 → adapter0 → vertical0) and an
   evidence/claims stack (core0/slices → surfaces, plus the form chain) — every lane green
   on its own gates today, none adopted, none on a shared floor, joined at exactly one
   candidate seam (surface2). It is a specification-driven research ladder, not yet a
   language a stranger can install and run.

2. **What is Mneme?** By the sealed decision (`ARCHITECTURE-0-STATUS.md:23`,
   `LISP-PLUS-ARCHITECTURE-DECISIONS-0.1.md:180`): the language is **Lisp+**; **Mneme is its
   memory-and-continuity layer**. As implemented, "mneme/" is the directory holding the
   entire construction, the promised memory layer (provenance-bearing write, retrieval,
   consolidation, deletion, restart) **does not exist as a lane**, and the README inverts
   the sealed relation (README.md:21 "Mneme (working name 'Lisp+')" — drift D5).

3. **Canonical implementation stack:** `cd0` → `kernel0` → Stack A and Stack B as drawn in
   §3. `latent-mvp` is not part of it (OBSERVED: zero mneme-lane edges).

4. **One complete executable path** (datum → process identity → durable journal → live
   capability → effect frontier → adapter → derive/perform → slice/form/surface → forced
   interruption → reconstruction → inspection)? **NO — not as one path.** Two artifacts
   jointly cover it with a gap:
   - `mneme/vertical0/` covers datum → identity → journal → capability → frontier →
     adapter → **four forced SIGKILLs** → reconstruction → inspection, live and
     reproducibly (reconstruction digest `706f7e1e582e06cce14ba44428b7c0705bd6480a8dcbd5ebf5a9a85874cdd05a`
     re-derived on this host — OBSERVED, PROBE #79).
   - `mneme/language-surface-2/surface2-inhabited.lisp` (18/0) re-expresses vertical0's
     census (`vertical0/program/census.lisp:49-108`) through the surface layer, read-only.

5. **Exact files for the partial path:** `vertical0/program/{package,census}.lisp`,
   `vertical0/{controls/run-integration-controls,mutants/run-mutation-gate,reconstruction/run-reconstruction-gate}.lisp`,
   `vertical0/harness/repeatability.sh`; then `language-surface-2/surface2{,-inhabited}.lisp`.

6. **First missing integration seam (DERIVED, load-bearing):** **no executable exists in
   which a Stack-B language operation — core0's derive/perform doors, or any slice/form/
   surface operation — executes against a Stack-A journal-backed, capability-gated process.**
   vertical0 never imports core0 or any slice; surface2's Stack-A contact is 7 journal0
   symbols + 1 capability2 symbol used for read-only re-expression of a *completed* run.
   The derive/perform doors of the language have never opened onto the durable process
   substrate. That is the seam.

7. **Can a programmer use it without reaching into internals?** **NO.** No ASDF system,
   three incompatible working-directory conventions, 13 prose run-recipes, 1,463 exports
   with no curated public story (TALLY §1.5).

8. **Can a new contributor install and run the coherent path from the root README?** **NO.**
   The README's quickstart works exactly as printed (OBSERVED, PROBE #89–92) — but it
   routes to `latent-mvp` and `verify-all.sh`, i.e. **exercises the fossil stratum and none
   of the current language** (README.md:40, :248-249, :387).

9. **Can an independent implementer determine the semantics from the governing documents?**
   **Substantially YES — the project's strongest property.** Adopted specs + frozen vector
   corpora (1,282 PJ0 frames; 206 AP0 vectors) have twice been implemented to green by
   independently seeded CL code (journal0 89/0; adapter0 107/0), under the honest ceiling
   "independently seeded under shared normative infrastructure."

10. **Strongest earned public claim:** see §0 and §17.

11. **Attractive unearned claims:** "independently verified/validated" (Rider 2 forbids);
    any adoption of implementations; portability beyond SBCL 2.4.6/Linux; power-loss or
    non-SIGKILL crash models; live-provider conformance; "one coherent usable language."

12. **Actual product-facing front door today: NONE.** The README nominates a fossil; the
    real stack has no door. Creating the door is the selected milestone.

---

## 6. Late returns, unpublished branches, and public-mirror reconciliation

Synthesis of TOPOS Part 2; parcel identities pinned by byte-comparison, not date.

**6.1 Vertical Specimen /0 — RECONCILED, one custody gap.** Published at `56377a32`;
**owner ruling exists** (`mneme/RULING-vertical0-closure-language-surface-2-2026-07-30.md`,
commit `72b2c973`): ACCEPTED as published candidate; five limits docketed non-blocking;
occupied-target interpretation provisional; Surface /2 opened by §5. Parcel r2
(`3bc86e4e…`) supersedes r1 in packaging only (r1's manifest included its own hash — can
never verify); **parcel payload pins to `56377a32` and therefore does not contain its own
acceptance addendum**. Consumed read-only by Surface /2. **No freezer copy exists.**

**6.2 Language Surface /2 — RECONCILED, one standing gap.** Published `0786e845`; Erratum
0.1 (`821b92af`); Erratum 0.2 (`cb022e27`); documentation-only closure `3cd53351`
("lane CLOSED PERMANENTLY"). Four gates 15/0 · 29/0 · 38/0 · 18/0, all re-run green this
session (OBSERVED, PROBE #72–75). Current parcel `surface2-return-2026-07-30-final.zip`
(`9f043d0c…`) pins to `3cd53351`; **r3 is superseded**. **No `mneme/RULING-surface2-*.md`
exists** (OBSERVED (PRAETOR): `ls`); closure rests on chair prose citing a spoken owner
authorization (`SURFACE-2-RETURN.md:236, :270`). Every comparable lane closure has a signed
instrument; this one — the only integration seam — does not. **No freezer copy exists.**
UNKNOWN: whether the owner's authorization covered closure at Erratum 0.2 or only 0.1
(both addenda cite it).

**6.3 Form /2 chain — RECONCILED.** Candidate `92476b85` → `683d83dd`, merged at
`03ea471c` (a merge commit — the /2-acceptance hash in circulating summaries is
`57eac026`, which is **Capability** /2). **No Form /2 ruling exists**; the adjacent ruling
`3cc6308e` decides the obligation abstraction only (Outcome B: Language Obligation /0 NOT
opened; both specimens frozen as published). Form /2 is CANDIDATE-BY-DEFAULT.

**6.4 Language-A tranche-B — THE custody finding.** The 706-file campaign
(`codex/language-a-tranche-b-prereg-freeze-and-lineage-search`, tip `fa4ab18f`, "BANKED at
295/312") plus 9 sibling branches (330/259/254/… files) exist **only as unmerged
public-mirror branches**. The producing worktree (`~/Codex-Lab/wt-language-a`) **no longer
exists on this host** (exit 2 — the 07-20 migration). The lab tree holds 3 language-a
files. An open, unadjudicated **PR #1** sits on the mirror. **Single point of failure: one
GitHub branch set** (survivable under `rsync --delete` only because the sync targets main).

**6.5 LCI/0 algebraic-law audit — agent disagreement ADJUDICATED.** TALLY reported the
harness not found (its D30/U1); TOPOS documented it in full and PROBE executed its tests.
**PRAETOR rules for TOPOS/PROBE from the live tree:** `mneme/lci0/audit/` exists (30 files,
landed `bedb279b`, 2026-07-15) and `evidence/final-status.txt` reads — OBSERVED (PRAETOR):
`AUDIT COMPLETE — MINIMIZED LAW VIOLATIONS PRESERVED; AUTHORIAL RULING REQUIRED`.
84 PASS / 4 FAIL laws (`LCI0-CROSS-004`, `LCI0-SCOPE-015`, `LCI0-TEMP-022`,
`LCI0-TEMP-028`), 6 minimized witnesses (4 implementation-defect, 2
cross-language-divergence). **No authorial ruling exists; the debt is 18 days old.** The
audit is **not re-derivable on this host** (external packet ZIP absent — PROBE §5.2,
unittest exit 1, errors=5, all FileNotFoundError on `/tmp/lci0-law-audit-*`). The evidence
itself records `"cross_language_agreement_is_independent_corroboration": false`.

**6.6 Session-event reconciliation (OBSERVED (PRAETOR)).** As §1.3: checkpoint commits
`e02d298c` + `410433b4` committed PROBE's mid-flight output over banked Surface /1 teeth
evidence; auto-sync published it (mirror `7f72ab7 → 7dc75bd`); chair restore `910315b5`
returned every tracked subject byte to the pre-session state (0-file diff; SUMMARY.txt
54 lines, sha256-identical to `3cd53351`); mirror now at `9bb311d` (= lab `910315b5`
content). **Residue:** 61 untracked `scratch-*` dirs under `mneme/vertical0/runs/` remain
in the working tree and on the public mirror; their only off-tree copy is in the ephemeral
session scratchpad. Disposition is an owner decision (D7).

**6.7 Cleared:** no candidate described in any RETURN is missing from main (52 path refs
across 6 rulings + 68 RETURN/CLOSURE docs, zero dangling); no local branch carries
unpublished subject work; `surface1-errata-0.3` branch fully merged and its parcels frozen;
the LCI/0 mirror branch is a stale pointer (0 files differ from mirror main).

---

## 7. Executable health check

Full command log: PROBE's report (~92 commands, each with cwd/exit). Summary, with the
session-event correction applied:

**7.1 Everything declared runs green from current sources.** OBSERVED (PROBE): SBCL wrapper
operation-checked first (2.4.6). All three aggregate floors pass (`verify-all.sh` 6/6 —
run 3×, two captures byte-identical, sha256 `2f54c64c…`; language floor 11 floors/654
checks; form floor 3/199). Every implementation-era lane green: kernel0 33/0 (+59 mutants
killed), journal0 66/0 + 89/0 vectors + live-SIGKILL specimen, capability0/1/2 (all
selftests/controls/specimens, counts exactly matching committed `RUN-EXITCODES.txt`),
adapter0 all 7 gates + specimen, core0 + 5 specimens, slices 0/1/2 (+ two stranger
front-door selftests 7/7), forms 0/1/2 (+ liveness sweeps forcing 210/210 and 86/86 with
negative controls that themselves fired), surfaces 0/1/2 (teeth 43/43 BITES live),
vertical0 three of four gates (five-life SIGKILL campaign deliberately not re-run;
repeatability comparator green; reconstruction digest reproduces). CD/0 and LCI/0
cross-language differentials green (467 req; 2,295/impl, 0 mismatches). The README
quickstart block works verbatim. **Zero semantic failures anywhere in the Lisp lanes.**

**7.2 Exactly two nonzero exits, neither a semantic defect:**
- `errata-0.3/addendum-0.1/semantic-path-diff.sh` → exit 1: hardcoded base `431fee16`
  flags the *later* de-vadimonio files as "scope violation" — release-engineering drift,
  the instrument cannot distinguish "the addendum moved" from "the repo moved on."
- LCI/0 `test_law_audit.py` → exit 1 (5 errors): external audit packet absent from host
  (§6.5).

**7.3 The teeth-evidence finding, stated precisely (both truths).** PROBE's observation
that the committed `SUMMARY.txt` held 19 of 43 rows described the **mid-session clobbered
state its own runs produced** (checkpoint `e02d298c`), not the banked state: the restored/
banked `SUMMARY.txt` is 54 lines with **all 43 rows** (OBSERVED (PRAETOR)). What survives
the restoration is the deeper finding: **the banked `OUT-T4…T7` transcripts predate
Evidence Addendum 0.1** — they print the old "ABSENT means that instrument does not yet
print the binding" paragraph (OBSERVED (PRAETOR): present in restored `OUT-T4a…`), while
today's runner prints "ALL SIX ARE REQUIRED TO BIND. ABSENT is a FAILURE." Re-running the
gate today regenerates transcripts **different from the banked ones, in the safe direction
(code stricter than its committed evidence)**. This is an evidence-freshness defect, not a
soundness defect; it belongs in the release's evidence-refresh scope (§13).

**7.4 Determinism.** Directly evidenced: verify-all byte-identical across runs; every
transcript-writing runner except two rewrote tracked outputs byte-identically; vertical0
repeatability comparator green. The two exceptions: the teeth transcripts (§7.3) and
`VERDICT-LIVENESS-SWEEP-RUN.txt` (embeds timestamps/mktemp paths — structurally
non-byte-reproducible; captured in a since-deleted worktree; verdict and subject sha256
reproduce exactly).

**7.5 Hygiene.** Running the two vertical0 gates deposits ~70 untracked scratch dirs under
`runs/` — neither cleaned nor gitignored — which the working-tree-publishing mirror then
ships (this is exactly how the 61 dirs reached the public mirror).

---

## 8. Evidence quality and present claim ceiling

**The evidence pyramid, best tier first (DERIVED):**

1. **Stranger-audited, repaired, live-verified:** Surface /1 (audit found defects → Errata
   0.3 repaired nine findings → teeth bite 43/43 live today). One lane.
2. **Independently seeded CL implementations against adopted frozen vector sets:** journal0
   (PJ0, 89/0) and adapter0 (AP0, 107/0; Rider 1 ruled SATISFIED; Rider 2 caps the
   language). Seeding independence is REPORTED by provenance documents; no execution can
   establish it.
3. **Cross-language differential:** CD/0 and LCI/0 (2,295 req/impl, 0 mismatches) — with
   the lane's own caveat recorded in its evidence: cross-language agreement is **not**
   independent corroboration (shared normative infrastructure).
4. **Negative-controlled self-consistency:** vertical0 (bilateral mutation gate 11+9,
   controls, reconstruction digest), form sweeps (fired negative controls), slice0's two
   stranger front-door implementations.
5. **Same-implementation selftest:** everything else — the bulk.

**A property worth naming (OBSERVED, PROBE #11):** the floors self-limit in their own
stdout — "SELF-CONSISTENCY CERTIFICATION, never independent conformance," "the stranger
audit is OWED," "a receipt is an ACCOUNT, not an AUTHENTICATION." The overclaiming in this
project lives in the *narrative* documents, not in the executable ones (§10).

**Present claim ceiling** — see §17 for the two required paragraphs. Binding caps in
force: AP0 Rider 2 (no "independently verified/validated"); PJ0 §32.5 FULL not claimed;
every RETURN's "not audited · not adopted · not frozen · not on a governing floor";
vertical0 SIGKILL-crash-model-only, no universal occupied-target law; LCI/0 conformance
blocked pending authorial closure; verdict-liveness = connectedness, never predicate
soundness; stranger-audit debt open on ≥9 lanes and counted nowhere.

---

## 9. Architecture, usability, and maintainability assessment

Per commission §12 vocabulary:

| dimension | verdict | evidence |
|---|---|---|
| canonical value & wire semantics | **WORKING** | CD/0 adopted, differential green, 17 consumer dirs |
| claim identity & standing | **PARTIAL** | LCI/0 built+isolated; 4 preserved law FAILs unruled; 0 consumers |
| ordinary vs consequential evaluation | **WORKING** (as candidates) | core0 two-doors accepted; slices/forms green |
| process durability & restart | **WORKING** (candidate) | journal0 + de-teste-occiso live SIGKILL; vertical0 reconstruction |
| capability mint/revoke/restore | **WORKING** (candidate) | capability0/1/2 green; /1 /2 owner-accepted |
| effect-frontier safety | **WORKING** (candidate) | capability2 + de-effectu-incerto |
| adapter ambiguity & reconciliation | **WORKING** (candidate, fake-boundary only) | adapter0 7 gates; ketiv/qere erratum |
| derive/perform separation | **WORKING** in Stack B; **MISSING across stacks** | §5 Q6 — the seam |
| surface ergonomics | **PARTIAL** | surfaces exist; no unified entry; 1,463 exports uncurated |
| error/condition usability | **PARTIAL** | per-lane conditions; no cross-lane condition story assessed as unified |
| package layering | **PARTIAL / DUPLICATED** | ladder of single-consumer links; 3 packages 0 consumers; form1 133 exports/1 consumed |
| host-Lisp leakage | **PARTIAL** | SBCL-only by declared law; hardcoded host paths in 3 committed files |
| replay & reconstruction | **WORKING** (candidate) | vertical0 digest reproduces live |
| independent conformance | **PARTIAL** | two organ-level seeded gates paid; no second core; ceiling language enforced |
| negative-control quality | **WORKING** | fired controls throughout (PROBE #7) |
| portability beyond SBCL 2.4.6 | **MISSING** | no other implementation ever tested; version hardcoded in banners |
| ASDF / installability | **MISSING** | 0 mneme `.asd`; three cwd conventions |
| CI & release engineering | **MISSING** | no CI, no Makefile, no tags, no release artifact |
| documentation coherence | **PARTIAL→failing at project level** | 20 of 33 drift findings in the five first-read docs (§10) |
| newcomer usability | **MISSING** | README routes to the fossil; MANIFEST 100% latent-mvp |
| evidence archive size/maintainability | **PARTIAL** | 643 MB, 87% generated corpora; 3 dirs = 81% of mneme bytes; unrunnable committed probes |
| real empirical contact | **PARTIAL** | Language-A emission banked (REPORTED) but custody-stranded; scoring owner-locked |
| second non-isomorphic application without new constitutional machinery | **PARTIAL — trending yes** | de-vadimonio landed as second obligation inhabitant *without* opening a new layer (Outcome B held); but each new lane still mints a new package + private gates |

**The ruling the commission asked for on slices/forms/surfaces (DERIVED):** the sequence is
**a genuine research ladder that has produced real semantic knowledge and now needs
consolidation** — with the form chain drifting toward application-local candidates
(form1: 133 exports, 1 consumed; form2: 0 consumers) and with integration cost beginning
to exceed benefit at the margins (three floors, zero overlap; every lane a private harness).
It is not yet a proliferating-abstraction pathology: the obligation ruling (`3cc6308e`)
proves the project can *decline* an abstraction, and Surface /2 proves the stacks can
touch. But the next rung added before consolidation would be.

---

## 10. Documentation and roadmap drift ledger

TALLY's D1–D33 stand as filed (spot-verified where load-bearing — PRAETOR re-read
README.md:40/:214-216, `ARCHITECTURE-0-STATUS.md:3`, Form /1 RETURN :530/:1253, and the
ruling roster). Finalized ledger, compressed to what misleads and adding this session's
findings:

**Phase-ordering poison (fix first — these actively mislead planning):**
| file | statement | truth | severity |
|---|---|---|---|
| `README.md:214-216` | Vertical Specimen /0 "deliberately unopened"; AP0 rider standing "remains the owner's adjudication" | built+ruled (`72b2c973`); Rider 1 SATISFIED (`31f9ba90`) | HIGH — this commission's own orientation was misled by it |
| `README.md:96-99` | status stone = "ball with the owner … no kernel implementation before the decisions record" | 12 days and ~10 lanes stale | HIGH |
| `README.md:40, :387` | "START HERE" = `latent-mvp/kernel.lisp` | orphan stratum, 0 mneme edges | HIGH |
| `ARCHITECTURE-0-STATUS.md` | header "Updated 2026-07-18"; ends at Addendum 13; "no successor lane commissioned" | 13 addenda through 07-30; Surface /2 opened by ruling and closed after last write; omits Forms /0–/2, Surface /1 arc, journal0, PJ0 Erratum 0.1 | HIGH — the WE-ARE-HERE stone is one lane behind and self-dated wrong |
| `README.md:429-430` vs `:21` | name "genuinely open" / "Mneme (working name 'Lisp+')" | name SEALED, inverted relation (`ARCHITECTURE-0-STATUS.md:23`) | HIGH |
| `mneme/ROADMAP.md`, `mneme/MANIFEST.md` | present as current direction / stranger index | describe the pre-architecture project; 100% latent-mvp | HIGH |
| `mneme/verify-all.sh:3` | "the single CI floor" | covers none of the language; two sibling floors exist | HIGH |
| `README.md:382` vs `mneme/lci0/README.md` | LCI/0 "closed arc … merged" | lane's own page: "conformance remains blocked pending authorial closure" | HIGH |

**Standing gaps (authority, not prose):** Surface /2 closed with no ruling file (D22);
Form /2 never ruled; Capability /0 has no acceptance instrument (hypothesis C revised);
LCI/0 "AUTHORIAL RULING REQUIRED" 18 days unanswered; 12 of 18 ruling-class documents sit
outside the advertised `RULING-*` convention with no authority index; stranger-audit debt
counted as "FOUR lanes" in the status stone, actually ≥9 (D13).

**Stale-label class (the defect Errata 0.3 was built to catch, recurring):**
`LANGUAGE-FORM-1-RETURN.md:530, :1253` still say "Not merged" (merged at `6970dcbd`) —
OBSERVED (PRAETOR). `IMPLEMENTATION-PHASE-BOARD` NEXT-list: 4 of 5 items done.
`RECEIVED.md`/`PENDING-APPLICATION.md` assert a governance frame six owner rulings have
overtaken. Kernel0 "selftest 29/0" (README:371) vs live 33/0.

**Evidence-freshness class (new, this session):** banked Surface /1 teeth transcripts
predate Evidence Addendum 0.1's stricter binding (§7.3); `semantic-path-diff.sh` frozen at
base `431fee16`; sweep transcript pinned to a deleted worktree path; 15 committed probe
files unrunnable from a clean checkout (D26); two committed LCI/0 documents show a
differential invocation that cannot run as written (PROBE §5.3).

**Repair set (RECOMMENDED, after the owner chooses the phase — do not edit now):** the
release milestone's documentation deliverable supersedes README/MANIFEST/ROADMAP front
doors in one pass; the status stone gets its missing addenda + a corrected header; the
authority index is created; the two false Form /1 lines get an erratum note; ROADMAP.md and
MANIFEST.md are superseded-marked rather than silently rewritten.

---

## 11. Principal risks

Ranked by (probability × consequence × immediacy), each with evidence and one mitigation:

**R1 — The mirror publishes the working tree, and lab hooks commit mid-flight state.**
Probability: demonstrated (fired twice during this assessment). Consequence: moderate-high
(banked audit evidence overwritten in committed history until manually restored; 61
mid-run scratch dirs now public; a half-written edit becomes the public face). Reversible:
yes, with vigilance — this time it was caught same-day. Evidence: `e02d298c`, `410433b4`,
`910315b5`, mirror `7f72ab7→7dc75bd→…→9bb311d` (§1.3, OBSERVED (PRAETOR)).
*Mitigation:* change `sync.sh` to publish from `git archive HEAD` (committed tree) instead
of the working directory (D8); until then, never let a push/sync be routine while any
suite or builder is live.

**R2 — Language-A tranche-B is single-copy on remote branches.** Probability of loss: low
per-day, but irreversibility is total (706 files; producing worktree already gone in the
07-20 migration; nobody noticed for 13 days). Evidence: §6.4. *Mitigation:* the parallel
custody lane — `git bundle` the ten `codex/language-a-*` branches into `~/freezer` now (D6).

**R3 — Everything green, nothing gated.** 12/19 packages on no aggregate floor; a
regression in journal0 or adapter0 today would be caught only by someone hand-running the
right recipe. Evidence: TALLY §1.5a; the three floors' own headers. *Mitigation:* the
primary milestone's unified floor.

**R4 — Candidate accretion without adoption or retirement; the empty stranger seat becomes
ceremonial.** 11 lane RETURNs, ~all candidate; audit debt ≥9 lanes, counted nowhere; each
new lane widens the gap. Evidence: §4 matrix; D13. *Mitigation:* consolidation freezes the
target surface; then a single audit-debt ledger and the one reserved audit against the
*release*, not nine against lanes.

**R5 — The only integration seam is the least-governed artifact.** Surface /2: no ruling,
no freezer copy, 0 consumers, chair-closed "PERMANENTLY." If its closure is ever disputed,
the two stacks' only join is in question. Evidence: §6.2. *Mitigation:* D1 (a
one-page signed standing instrument; no code reopening).

**R6 — Narrative drift misleads planners (it already misled this commission's charge).**
Hypothesis E arrived three days stale; the README told readers Vertical /0 was unopened.
Evidence: §10. *Mitigation:* the release's single front-door rewrite; adopt the
form-floor's own lesson (no hard-coded governance sentences in runners).

**R7 — Evidence freshness silently decays under active development.** Banked transcripts
weaker than current code (safe direction this time — no guarantee next time); committed
evidence unrunnable from clean checkouts. Evidence: §7.3, D26–D27. *Mitigation:* the
release's evidence-refresh pass, and a rule that any code change re-captures the
transcripts it invalidates.

**R8 — Same-family greens mistaken for assurance downstream.** The executables self-limit;
summaries and future READMEs may not. Evidence: LCI/0's own
`cross_language_agreement_is_independent_corroboration: false`; Rider 2. *Mitigation:*
carry the permitted-formulation blocks verbatim into the release claim ceiling.

**R9 — Ephemeral collateral.** The only copy of the 61 scratch dirs' archive is in
`/tmp` (session scratchpad) — gone on reboot. Evidence: §1.3. *Mitigation:* D7 decides
disposition now; if "delete," nothing is lost that the gates cannot regenerate.

Named-but-not-elevated: premature live-provider work (nobody is proposing it — F is
DEFERRED); over-generalizing from two specimens (the obligation ruling already guards
this); cryptography/distribution (absent from every current charge).

---

## 12. Strategic option comparison

| opt | milestone | creates | resolves bottleneck | prereqs paid? | major risk | size | increases | verdict |
|---|---|---|---|---|---|---|---|---|
| A | Close Vertical /0 | — | — | **already done** (`72b2c973`) | — | — | — | **DECLINED — already paid**; only the freezer copy remains (parallel lane) |
| B | Accept/repair/defer/decline Surface /2 | a signed standing | the R5 governance gap | yes | none | S | governance clarity | **Fold into docket D1** — it is a signature, not a milestone |
| **C** | **First coherent runnable release** | one ASDF system, one floor over all 19 packages, one entrypoint, one e2e demo, one claim ceiling | R3 (nothing gated), R6 (front-door drift), §5 Q7/Q8 (unusability), and makes D/E affordable | **yes** — all lanes green, closures done, tree frozen, no in-flight work | scope creep into semantic changes (guarded by hard exclusions) | **M** | implementation integration + usability, strongly | **NEXT — selected** |
| D | Stranger primitive-minimization audit | the reserved promotion evidence | the empty-seat debt | **no** — auditing 3 cwd conventions, no install path, 15 unrunnable probes, 19 uncurated packages multiplies auditor cost and shrinks meaning | audit of a moving/unconsolidated target | L | evidence standing | **LATER — immediately after C**; C's exit gate is D's entry condition |
| E | Second independently seeded implementation | true independence | same-family ceiling | no (needs a stable, named semantic surface to implement against) | enormous scope | XL | semantic knowledge + independence | LATER/CONDITIONAL (after C, likely after D) |
| F | Real provider adapter | live-boundary contact | — | no — fake boundary not yet consolidated; §14 named risk | premature live effects | L | empirical contact | **DEFERRED** |
| G | Mneme memory integration | the language's namesake layer | the "Mneme is a directory name" gap | partially (journal0 exists) | building the flagship layer on an unconsolidated stack | XL | semantic knowledge | LATER — first post-release language lane candidate, alongside the §5 Q6 seam |
| H | Language-A scoring/publication | empirical results | — | **no — owner-locked** (null-semantics ruling first; scoring materials deliberately out-of-repo) | cannot start | M | empirical contact | BLOCKED by owner locks; only its **custody rescue** is actionable → parallel lane |
| I | CI/portability/packaging/docs alone | infrastructure | R3 partially | yes | infrastructure without an integration target | M | usability | **SUBSUMED into C** (C is I plus the integration demo and claim ceiling) |
| J | New Slice/Form/Surface/obligation/codata | another rung | none | — | exactly R4 | M–L | artifact volume mostly | **DECLINED for now** — the ladder needs a spine before another rung |
| K | Deletion/supersession pass | less mass | R6 partially | yes | deleting history the evidence chain cites | M | maintainability | PARTIAL — C includes supersession-*marking* (not deletion); a true deletion pass is LATER and needs its own charge |

---

## 13. Recommended next phase

### PRIMARY MILESTONE — Option C: the First Coherent Lisp+ Runnable Release ("Release /0")

**Problem statement.** Nineteen green candidate packages, two stacks, three partial floors,
zero install story: the project cannot currently be run, audited, or extended as one thing
by anyone who did not build it. Every future milestone the project cares about (stranger
audit, second implementation, memory integration, empirical use) is priced up or blocked by
this.

**Why now.** The tree is frozen (last subject commit 07-30), every lane is green from
current sources *today* (a state that decays — §7.3 shows evidence already aging), all
closure debts of the implementation era are either paid or reduced to signatures (D1), and
no in-flight work exists to collide with. Consolidation of a moving target is rework;
consolidation of a frozen green target is packaging.

**Scope (deliverables).**
1. **One ASDF system family** (`lisp-plus.asd` at the subject-tree root or `mneme/`):
   `lisp-plus` (cd0 + kernel0 + Stack A + Stack B + surface2), with per-lane subsystems;
   loads on SBCL 2.4.6 from a clean checkout with one documented command. No code semantics
   changed — `load`-order and pathname normalization only (the three cwd conventions
   resolved by the system definitions, not by editing gate logic).
2. **One aggregate floor** (`mneme/verify-release.sh` or an ASDF test-op) that runs every
   lane's selftest+controls+specimen (the ~40 entrypoints PROBE enumerated), with the
   existing three floors invoked or subsumed, and every existing self-limiting banner
   preserved verbatim.
3. **One root entrypoint + demonstration:** a single documented runner executing the
   end-to-end demonstration that exists — the vertical0 gates (controls, mutation,
   reconstruction) followed by surface2-inhabited — from one command, writing scratch to
   `/tmp` or a gitignored dir (fixes the 70-dirs-per-run littering at its source).
4. **One front-door rewrite:** README + MANIFEST successor + status-stone addenda + the
   authority index (all 18 ruling-class documents, one page). ROADMAP.md and the phase
   board marked SUPERSEDED with pointers, not deleted. The sealed name applied consistently
   per D4.
5. **One current claim ceiling document,** carrying verbatim: Rider 2's forbidden list, the
   adapter0 permitted formulation, PJ0 §32.5, vertical0's SIGKILL-only ceiling, the
   connectedness-not-soundness cap, and the stranger-audit debt ledger (the first honest
   count of the ≥9 lanes).
6. **Evidence-refresh pass, strictly mechanical:** re-capture the Surface /1 teeth
   transcripts under the current (stricter) runner; fix `semantic-path-diff.sh`'s base
   handling; note-or-quarantine the 15 unrunnable probe files (marked historical, not
   deleted).

**Explicit exclusions (stop conditions if approached):** no change to any lane's semantic
code or gate logic beyond pathname/load mechanics; no new Slice/Form/Surface; no reopening
of Obligation /0, adopted specs, or any closed lane's internals; no building of the §5 Q6
seam (that is a *language design* act for a post-release lane); no live-provider code; no
deletion of history; no promotion language beyond the ceiling document.

**Inputs:** the frozen tree at `ef4097a8…`; PROBE's entrypoint enumeration; this report's
§3 graph and §10 repair set; owner answers to D1–D8.

**Dependency graph:** D4 (name) → deliverable 1 naming; D1 (Surface /2 signature) and D5
(latent-mvp fossil-mark) → deliverable 4; D7 (scratch dirs) → deliverable 3's scratch-path
fix; everything else independent. Deliverables 1–3 can begin immediately; 4–5 land last.

**Roles.** Builder: one hand (this is integration, and the hardest guarantee — "nothing
semantic changed" — must fall to one hand, not a committee). Reviewer: a fresh-context
reviewer whose sole charge is the byte-diff discipline — verify that every `.lisp` diff is
load-mechanics only, and that every pre-existing gate still reports its exact prior counts.

**Executable exit gate:** on a clean clone of the public mirror, on this host: (1) one
documented command loads `lisp-plus` via ASDF, exit 0; (2) one documented command runs the
unified floor — every lane's gates, all pre-existing counts unchanged, exit 0; (3) one
documented command runs the end-to-end demonstration, exit 0, reconstruction digest
`706f7e1e…` reproduced, zero tracked-file dirt and zero untracked litter after the run;
(4) `verify-sync.sh` (with its empty-dir fix, D8-adjacent) exits 0.

**Claim ceiling of the milestone itself:** a release is a *packaging act* — it creates no
new semantic standing; every lane remains exactly the candidate/accepted thing its ruling
says; the release may claim only "one command loads and verifies the whole construction on
SBCL 2.4.6, self-consistency only."

**What follows if it succeeds:** the stranger primitive-minimization audit (Option D) is
commissioned against the release — one target, one entrypoint, one claim ceiling — and
becomes the promotion gate the architecture always reserved for it.

### PARALLEL LANE — Custody & Archive Integrity (S)

**Scope:** (1) `git bundle` all ten `codex/language-a-*` mirror branches (+ PR #1's head)
into `~/freezer/language-a-tranche-b-2026-08/` with sidecars (D6); (2) freezer copies of
`vertical0-return-2026-07-30-r2.zip` and `surface2-return-2026-07-30-final.zip` with
sidecars; (3) execute the owner's D7 disposition of the 61 scratch dirs; (4) durable copy
of the session's `tree-collateral` archive out of `/tmp` if the owner wants it kept.
**Why it cannot block or contaminate:** it touches `~/freezer`, `~/Downloads`, mirror
*branches*, and untracked litter only — zero contact with any tracked mneme source file
the release lane will handle; it requires no code, no semantics, no review coupling.
**Exit:** each bundle/parcel verifies against its sidecar from a fresh read.

---

## 14. Owner decision docket

Eight decisions. "Before/after": what may proceed before the decision vs what must wait.

**D1 — Sign the missing standing instruments for Surface /2 and Form /2?** (YES/NO)
YES: a one-page `RULING-surface2-form2-standing-2026-08.md` recording, retroactively and
verbatim, what each lane's standing is (candidate; Surface /2 closed at Erratum 0.2 per the
authorization the RETURN cites; Form /2 candidate-by-default, its specimens frozen by
`3cc6308e`). NO: the seam's closure remains chair-asserted testimony indefinitely (R5).
*Recommendation: YES.* Before: everything except release deliverable 4's standing table.
Must not proceed before: any public narrative calling Surface /2 "closed by ruling."

**D2 — Dispose of the LCI/0 audit's four preserved law violations.** (adjudicate now /
commission an adjudication draft for signature / declare lane dormant-as-is)
The lane's own evidence has demanded an authorial ruling for 18 days. Dormancy without a
ruling leaves README.md:382's "closed arc" claim permanently false. *Recommendation:
commission the adjudication draft (bounded: 4 laws, 6 witnesses); owner signs or amends.*
Before: everything (LCI/0 has 0 consumers). Must not wait on it: nothing in the release.

**D3 — Approve Release /0 (Option C) as the primary milestone?** (YES/NO)
YES: §13 executes. NO: name an alternative from §12 — the report's evidence says every
other option is either paid, blocked, premature, or priced up by C's absence.
*Recommendation: YES.*

**D4 — Affirm the sealed naming for the release surface?** (affirm / reopen)
Sealed: the language is **Lisp+**, Mneme its memory layer (`ARCHITECTURE-0-STATUS.md:23`).
The README currently inverts it and calls it open. The ASDF system must bear a name.
*Recommendation: affirm; system `lisp-plus`; README repaired to match.* Before: release
deliverables 2–3. Must not proceed before: deliverable 1 (the system name) and 4.

**D5 — Fossil-mark `latent-mvp`?** (fossil-mark / keep as front door)
Fossil-mark = a header + README removal of "START HERE," directory retained untouched,
verify-all retained as its historical floor. *Recommendation: fossil-mark.* Before:
everything except the README rewrite.

**D6 — Language-A tranche-B custody.** (bundle-archive now, adopt later / adopt into lab
tree now / declare deliberately unadopted)
Bundle-archive is reversible, small, and removes the single-point-of-failure today;
adoption (706 files) deserves its own considered act; "deliberately unadopted" without a
bundle accepts the loss risk in writing. *Recommendation: bundle-archive now (parallel
lane); adoption decision deferred to the Language-A scoring era.* Also: close or comment
mirror PR #1 while there.

**D7 — The 61 published scratch directories.** (delete from working tree + re-sync mirror /
keep) Plus: gitignore `mneme/vertical0/runs/scratch-*` (or accept the release fixing scratch
paths at the source). *Recommendation: delete + re-sync; the gates regenerate them at
will; the /tmp archive may then be discarded.* Must not proceed before deciding: any
mirror-facing statement that the published tree is intentional.

**D8 — Change `sync.sh` to publish the committed tree (`git archive HEAD`) instead of the
working directory?** (YES / NO / defer to release)
YES eliminates R1's publication half structurally (the hook-commit half remains, but
hook commits are local and restorable — this session proved both the failure and the
recovery). NO keeps a mirror that publishes half-written state whenever a sync fires
mid-run. *Recommendation: YES, executed inside the release lane's tooling pass, together
with the `verify-sync.sh` empty-directory fix.* Before: D7's one-time re-sync. Must not
proceed before: none (independent of all language work).

---

## 15. Three-horizon roadmap

- **NOW:** Release /0 (§13 primary) + Custody & Archive Integrity (parallel). Docket D1–D8
  answered; D1/D2 signatures land whenever ready (non-blocking).
- **NEXT (justified only after NOW closes):** the stranger primitive-minimization and
  integration audit, commissioned against the release artifact (the reserved seat, at last
  pointed at one target); the LCI/0 adjudication consequences if D2 finds implementation
  defects; a bounded deletion/supersession pass over the marked fossils if the owner wants
  the mass down.
- **LATER / CONDITIONAL:**
  - the §5 Q6 seam — derive/perform over a journal-backed process — as the first
    post-release *language* lane (condition: release floor green + audit returned);
  - Mneme memory integration (Option G; condition: the seam exists — memory writes are
    exactly derive/perform-over-durability);
  - second independently seeded implementation (condition: audit-stabilized semantic
    surface);
  - Language-A scoring/publication (condition: the owner's sealed null-semantics ruling —
    owner-locked, not project-blocked);
  - real provider adapter (condition: all of the above; the fake boundary is consolidated
    and audited first);
  - Surface Account /0 / Surface /3 (named-not-opened; condition: a post-release charge
    that survives the R4 test).

---

## 16. Files that should later be updated, superseded, archived, or linked

(No edits performed. Grouped by act.)

**Update (release deliverable 4):** `README.md` (D1–D8 drift items); 
`mneme/architecture/ARCHITECTURE-0-STATUS.md` (header date; addenda for Forms /0–/2,
Surface /1 arc, journal0, PJ0 Erratum 0.1, Surface /2, and this assessment);
`mneme/verify-all.sh:3` header claim (or subsume the script).

**Supersede-mark (retain, label, point forward):** `mneme/ROADMAP.md`; `mneme/MANIFEST.md`;
`mneme/architecture/IMPLEMENTATION-PHASE-BOARD-2026-07-18.md`; `mneme/RECEIVED.md`;
`mneme/PENDING-APPLICATION.md`; `mneme/CONSTITUTION.md` + v0.4/v0.5 drafts + `v0.1/ v0.2/
v0.3/` (one lineage banner); `latent-mvp/` (fossil header per D5).

**Create:** the authority index (18 ruling-class documents, §2); the release claim-ceiling
document; `RULING-surface2-form2-standing` (D1); the LCI/0 violations adjudication (D2);
the stranger-audit debt ledger (first honest count).

**Erratum-note (do not silently edit):** `LANGUAGE-FORM-1-RETURN.md:530, :1253`
("Not merged" — false since `6970dcbd`).

**Archive / custody (parallel lane):** freezer copies of `vertical0-return-2026-07-30-r2.zip`
and `surface2-return-2026-07-30-final.zip` (+ sidecars); git bundles of the ten
`codex/language-a-*` mirror branches; owner disposition of the 61
`mneme/vertical0/runs/scratch-*` dirs (working tree + mirror) and of the ephemeral
`/tmp` collateral archive; retention statement for `~/Downloads` parcels (custodial vs
transient).

**Tooling (D8):** `tools/latent-lisp/sync.sh` (publish committed tree);
`tools/latent-lisp/verify-sync.sh` (empty-directory benign class);
`mneme/language-surface-1/errata-0.3/addendum-0.1/semantic-path-diff.sh` (stale base);
quarantine-mark the 15 unrunnable audit-probe files (historical evidence, not runnable
instruments).

---

## 17. Final claim ceiling

**After the present work, Lisp+ may honestly claim:** that it is governed by an adopted,
internally consistent specification constitution (Architecture 0.1; Kernel /0 with Errata
0.2; Process Journal /0; Adapter Protocol /0; Canonical Datum /0) whose semantics have
twice been implemented to green by independently seeded Common Lisp code against frozen
adopted vector sets (journal0: 89/0 PJ0 vectors; adapter0: the complete frozen AP0 gate,
Rider 1 ruled satisfied, at declared deterministic fake-adapter scope); that every one of
its nineteen candidate implementation packages passes its own declared gates from current
sources on SBCL 2.4.6/Linux today, with zero semantic failures across ~92 verification
commands, fired negative controls, bilateral mutation gates, and byte-reproducible
transcripts where designed; that one vertical specimen demonstrably survives four forced
SIGKILL deaths with capability-gated effects and a byte-reproducible reconstruction; that
one lane (Surface /1) has survived a genuine stranger audit through repair to a live
43/43 planted-fault gate; and that its cross-language differential harnesses (CD/0, LCI/0)
run green at 467 and 2,295 requests per implementation respectively, with zero
cross-mismatches, under the recorded caveat that such agreement is not independent
corroboration.

**Lisp+ may not yet honestly claim:** to be independently verified or independently
validated (AP0 Rider 2 forbids the words, and the reserved stranger
primitive-minimization audit has never been commissioned); to have any adopted
implementation (every implementation is a candidate or accepted-candidate; adoption
attaches to specifications only); to be one coherent runnable language (no ASDF system, no
CI, no install path, no unified floor — twelve of nineteen packages are gated by nothing
but hand-run recipes); to have connected its language operations to its process substrate
(the derive/perform doors have never opened onto a journal-backed process; the two stacks
touch only in a read-only re-expression); to survive anything but SIGKILL on this one
SBCL/Linux host (no power-loss, no cross-platform, no second host ever tested); to have a
functioning memory layer worthy of the name Mneme; or to have earned, from cross-language
agreement or same-family review, anything beyond self-consistency under shared normative
infrastructure — a ceiling its own evidence files state in so many words.

---

## Appendix A. Commands run and exit codes

**PRAETOR (this synthesis session, all cwd `/home/gauss/Desktop/Claude-Code-Lab` unless
noted, all exit 0 unless noted):**
1. `git rev-parse HEAD` · `git log --oneline -12` — HEAD `df1c0db5`; sequence incl. `910315b5` restore.
2. `git diff --name-only e02d298c^ HEAD -- experiments/latent-lisp | wc -l` → **0**.
3. `git status --short` — 6 root `_staging/` + 61 `scratch-*` untracked; `ls -d …/runs/scratch-* | wc -l` → 61.
4. `tail -6 tools/latent-lisp/.sync.log` — `dc2cba7..9bb311d`, `auto-sync: lab 910315b5`, published.
5. `git show {HEAD,3cd53351}:…/teeth/SUMMARY.txt | {wc -l, sha256sum}` — 54 lines, digests equal (`efe83d21…`).
6. `git rev-parse 'HEAD:experiments/latent-lisp'` = `'c414152f:…'` = `ef4097a8…`.
7. `ls experiments/latent-lisp/mneme/RULING-*.md` — six files; **no surface2/form2/capability0 ruling**.
8. `git log -1 --format=%s` for `ab7df5bb`, `57eac026`, `72b2c973`, `0786e845` — titles as cited in §6.
9. `sed -n` reads: `ARCHITECTURE-0-STATUS.md:3`; `README.md:214-216,40`; `LANGUAGE-FORM-1-RETURN.md:530,1253`.
10. `grep -rl "mneme\.client\|mneme\.operator" --include='*.lisp' . | grep -v latent-mvp` (cwd subject tree) → 1 file (`atelier/monadologia/de-notione-completa.lisp`).
11. `cat mneme/lci0/audit/evidence/final-status.txt` — "AUTHORIAL RULING REQUIRED".
12. `ls ~/Downloads/{vertical0-return-…-r2,surface2-return-…-final}.zip`; `ls ~/freezer` — parcels present; freezer lacks both lanes.
13. `grep -cE "^T[0-9]" …/teeth/SUMMARY.txt` → 43; `grep -c "ABSENT means…" OUT-T4a…` → 1; `grep -c "ALL SIX ARE REQUIRED" OUT-T4a…` → 0.
14. mirror clone: `git fetch origin`; `git ls-remote origin refs/heads/main` → `9bb311d6…938`.
15. `grep -n -i "capability /0\|capability0" mneme/RULING-capability1-arc-closure-…md` — regression/substrate mentions only.
16. `find /home/gauss … "*scratch*"`; `ls <scratchpad>/tree-collateral/` — collateral archive located in ephemeral scratchpad.

**REPORTED-BY-EXISTING-ARTIFACT (with attribution):**
- **TOPOS** Appendix A: 61 command groups, all exit 0 except `verify-sync.sh` → **1**
  (adjudicated false positive), `git check-ignore` → 1 (correct), `ls -d ~/Codex-Lab` → **2**
  (absent). Includes fetches, parcel sha256 sweeps (all sidecars verified), parcel-to-commit
  byte pinning, mirror-branch diffs.
- **PROBE** §3: ~92 commands. All Lisp-lane floors exit 0 (counts in §7.1). Nonzero exits:
  `semantic-path-diff.sh` → **1** (stale base `431fee16`); LCI/0 `test_law_audit.py` → **1**
  (5 × FileNotFoundError, external packet absent). Determinism: `verify-all.sh` 3 runs,
  two captures sha256-identical (`2f54c64c…`).
- **TALLY:** census counts (`git ls-files`, `du`, grep sweeps) — no suites executed by TALLY.

## Appendix B. Files and rulings consulted

Directly by PRAETOR: `mneme/RULING-*` roster (ls) and `RULING-capability1-arc-closure…`
(grep); `SURFACE-2-RETURN.md` closure lines; `ARCHITECTURE-0-STATUS.md:3`;
`README.md:40, 214-216`; `LANGUAGE-FORM-1-RETURN.md:530, 1253`;
`mneme/lci0/audit/evidence/final-status.txt`; `tools/latent-lisp/.sync.log`;
teeth `SUMMARY.txt` + `OUT-T4a…` (banked); `atelier/monadologia/de-notione-completa.lisp:51-65`.
Via the three evidence reports (their Appendices B): all six root rulings (full or head);
all 11 lane RETURNs + 7 specimen returns + 8 closures; the governing spec set and adoption
records; the three floors + MANIFEST + ROADMAP + phase board; lci0 spec/audit/evidence
files; sync tooling; the 2026-07-30 handoff; parcel packaging notes (r2/final).

## Appendix C. Unresolved facts and exact settling checks

1. **Surface /2's owner authorization scope** (Erratum 0.1 only, or 0.2?): settled only by
   the owner's word → D1's instrument should state it.
2. **Form /2 standing** (candidate-by-default presumed): settled by D1.
3. **LCI/0's four preserved law violations** — defect vs over-strict law vs superseded:
   settled by the D2 adjudication; note the audit is not re-derivable on this host
   (packet ZIP `LCI0-ALGEBRAIC-LAW-AUDIT-PACKET-ERRATA-0.1.zip` absent — locate it or rule
   the archived evidence stands).
4. **Whether adapter0/journal0 seeding independence is material** — REPORTED by provenance
   docs; no execution can establish it; settled only by the reserved stranger audit (LATER).
5. **Why the banked teeth transcripts predate Evidence Addendum 0.1** while the code
   enforces it: `git log --follow` on `teeth/OUT-T4a…` vs the addendum's landing commit;
   then the release's evidence-refresh recaptures them.
6. **Whether `surface2-erratum-binder.lisp` belongs on Surface /2's declared gate table**
   (present, green 15/0, absent from the RETURN's three-gate table): read
   `ERRATUM-0.1-BINDER.md` against the RETURN; cosmetic either way.
7. **Mirror PR #1** (who opened it, what it asks): GitHub API query; then merge/close under D6.
8. **`~/Downloads` retention policy** (custodial vs transient): owner statement; the
   parallel lane's freezer copies remove the acute exposure.
9. **The two undated `SHA256SUMS*.txt` in `mneme/architecture/`** — which covers which
   adoption: diff each against the Architecture 0 vs 0.1 file lists.
10. **`:redacted` enum rider and DK-1 channel-policy draft** (two unpaid Fable riders):
    owner/Sol disposition; the channel-policy question intersects D8.
11. **Whether the 07-20 migration's loss of `~/Codex-Lab` was ever noticed/ruled**: owner's
    word; mooted operationally by D6's bundles.

---

*Commission complete per §20: identity recorded; late returns reconciled; every major lane
carries a multi-axis status; the end-to-end path's first missing seam is named; floors
sampled (by PROBE) and adjudicated; stale narratives ledgered; claim ceiling stated; one
primary milestone and one nonblocking parallel lane selected; eight owner decisions
docketed; no implementation or repair performed. — PRAETOR (Claude Fable 5), 2026-08-02.*
