# PORTABLE JUDGE /0 — VECTOR CLASSIFICATION (CANDIDATE)

**CANDIDATE — not adopted; owner disposition pending.** 2026-08-10.
Prepared against the **R1 candidate base** (parcel sha256 `54aa7783c494d8f32baa3c10eecd48590b88b13f07f0de6c8724831807a02803`,
patch base commit `76952ea4f278d269f98f158555e412a095a3da6f`, R1 freeze lane subtree
`e94870bd9091e67f68e9cf238a6c5d0dcf302a05`). **The base is NOT owner-adopted.** This is a
candidate document about a candidate lane, against a candidate base.

> **NAMING COLLISION (first use).** The directory `portable-judge-0/` and the campaign name
> "Portable Judge /0" are **not** `PJ0`. Bare **"PJ0" is reserved for the ADOPTED Process
> Journal /0** (`mneme/architecture/process-journal-0/`, Erratum 0.1 adjudicated `aa36d581`).
> No abbreviation of this campaign to "PJ0" is authorized. The campaign designation itself is
> **pending owner ratification**; "Portable Judge /0" is used here as a working handle.

**Counting law.** Every count below carries the command that produced it. Where a count is
derived rather than executed, it is labelled **static count, not executed**. Nothing in this
document was obtained by running the lane.

---

## 0. Scope, method, and what "counted" means here

**Scope.** The Many Acts /0 lane (`mneme/language-many-acts-0/`) and the One Act /0 adopted
substrate it composes over (`mneme/language-act-0/`).

**Method.** All counts are **static** — derived by reading and mechanically counting call
sites, expectation lists, and enumerated tables in the sources. **No harness was executed.**
The lane's runners spawn sub-images, write scratch trees under `$TMPDIR`, and (in the
disease and teeth paths) mutate replicas of the sources; none of that is safely
side-effect-free for a census seat, so the selftest was **not run**. Where a static
derivation happens to land on a number the R1 parcel seal also reports, that agreement is
noted as **corroboration, not as a re-run**.

**The one place the static derivation is exact.** `ma0-selftest-suite.lisp` reaches
**200** by construction, and the derivation is exhibited in §1 below rung by rung. The R1
parcel seal independently reports `selftest 200/0 ×2 byte-identical`. Two roads, one number.
**This is not a re-verification of the seal** — it is one reading agreeing with one prior
run.

**Where the static derivation does NOT match a reported number, it is reported as a
mismatch and not reconciled by force.** See §5.

---

## 1. The lane suite — `ma0-selftest-suite.lisp`, 200 checks, derived

```
grep -c '(ma0-check ' ma0-selftest-suite.lisp                  →  53   (call SITES, not checks)
grep -c '(%ma0-expect-refusal' ma0-selftest-suite.lisp         →  42
grep -c 'directory "W-V-' ma0-selftest-suite.lisp              →  37   (§1 family)
grep -c 'directory "R1/D2' ma0-selftest-suite.lisp             →   5   (§2b family)
```

53 call sites expand to 200 checks because six of them sit inside `dolist` loops over
enumerated tables. The expansion, per rung:

| Rung | Where | Checks | How derived |
|---|---:|---:|---|
| §1 baseline accept | `%ma0-validator-witnesses` | 2 | two literal `ma0-check` sites (`W-V-BASELINE` ×2) |
| §1 typed refusals | `%ma0-validator-witnesses` | 37 | `grep -c 'directory "W-V-'` — each `%ma0-expect-refusal` yields exactly 1 check on every branch |
| §2 footprint | `%ma0-footprint-witness` | 2 | two literal sites |
| §2 immutability | `%ma0-immutability-witness` | 11 | 4 literal + `dolist` over 7 readers (`ma0-program-name … ma0-environment-store-id`) |
| §2b R1/D1 own | `%ma0-r1-own-witnesses` | 10 | 1 contrast + 5 structure + 2 direction + 1 byte-vector + 1 budget tooth |
| §2b R1/D1 source | `%ma0-r1-source-ownership` | 4 | literal sites |
| §2b R1/D2 branch | `%ma0-r1-branch-fixtures` | 6 | 5 `%ma0-expect-refusal` + 1 green control |
| §2b R1/D3 tree | `%ma0-r1-tree-fixtures` | 6 | 4 `expect` + 2 `expect-ok` |
| §2b R1/D5 generation | `%ma0-r1-generation-witnesses` | 9 | 3 teeth + 3 source-gate + 3 runtime |
| §3 grep gates | `%ma0-grep-gates` | 23 | 2 teeth + `dolist` over 16 `+ma0-lane-sources+` + 1 tooth + `dolist` over 4 W-GENERIC files |
| §4/§5 scenarios | `%ma0-suite` | 90 | 11 scenarios × 2 fixed checks + 68 expectation strings |
| **TOTAL** | | **200** | |

Scenario expansion, counted by script (quoted-string count inside each `'( … )`
expectation list, `%ma0-scenario-checks` adding 2 fixed checks — exit code, declared end):

```
p1 15(+2)=17 · p2-alpha 9(+2)=11 · p2-beta 12(+2)=14 · w-branch-one 5(+2)=7 ·
w-branch-exact 3(+2)=5 · w-derive-ne-perform 3(+2)=5 · w-auth-unfilled 3(+2)=5 ·
w-order-store 5(+2)=7 · w-no-erase 8(+2)=10 · w-error-propagates 3(+2)=5 ·
w-error-uncaught 2(+2)=4                                              → 90
```

The conditional `PLANTED FAULT` check (fires only under `MA0_SELFTEST_PLANT_FAULT=1`, and
turns the run RED by design) is **outside the 200** — correctly, since it exists to make the
instrument fail, not to pass.

**⚠ The lane suite's count is OBSERVED, NOT AUTHORIZED** — the suite's own header says so,
and refuses to assert a frozen number on the ground that no one has accepted one. One Act /0
takes the opposite discipline (173, asserted, fail-closed on 172 or 174). For a conformance
bank this asymmetry matters: **an observed count cannot detect a silently lost vector.** A
Portable Judge bank must be authorized, not observed.

---

## 2. THE CLASSIFICATION

Categories, as commissioned. **Only 1–4 may score a J2.**

| # | Category | Portable? |
|---|---|---|
| 1 | normative semantic vector | **YES** |
| 2 | disease witness (inherited red-by-design; the conserved quantity) | **YES** (as a conserved obligation, not as a check-count) |
| 3 | adversarial / hostile semantic vector | **YES** |
| 4 | metamorphic vector | **YES** |
| 5 | implementation-specific regression test (protects J1's CL machinery) | no — J2 never required to pass |
| 6 | loader / harness test (CL plumbing) | no |
| 7 | construction-only diagnostic | no |

### 2.1 Many Acts /0 — `ma0-selftest-suite.lisp` (200)

| Bank | n | Cat | Reason |
|---|---:|:--:|---|
| §1 `W-V-BASELINE` accept ×2 | 2 | **1** | source→accept at the observable boundary; without it every red witness is vacuous |
| §1 `W-V-SHAPE` (5) | 5 | **1** | 4 portable (unknown head · missing clause · two forms in one file · bare ident as value); **1 contaminated** (dotted pair) |
| §1 `W-V-READ` (1) | 1 | **1**⚠ | `#.` is CL read syntax; law is real, the *vector* is host-specific |
| §1 `W-V-DATA` (4) | 4 | **1**⚠ | vector / character / float / pathname — all four expressed in CL read syntax over CL types |
| §1 `W-V-PKG` (2) | 2 | **1**⚠ | symbol home-package + uninterned symbol: CL package system, no portable analogue |
| §1 `W-V-BIND` (3) | 3 | **1** | use-before-define · duplicate definition · no shadowing across arms — pure law |
| §1 `W-V-FIELD` (4) | 4 | **1** | binding-class discipline — pure law |
| §1 `W-V-AUTH` (4) | 4 | **1** | authority-position closure — pure law |
| §1 `W-V-ARM` (2) | 2 | **1** | closed arm vocabulary; once-per-text — pure law |
| §1 `W-V-PATTERN` (6) | 6 | **1** | closed axes, mandatory `otherwise`, duplicate/canonicalized clauses — pure law |
| §1 `W-V-TERM` (3) | 3 | **1** | terminal discipline — pure law |
| §1 `W-V-RETRY` (3) | 3 | **1** | closed-world head refusal — pure law |
| §2 `W-V-FOOTPRINT` (2) | 2 | **1**⚠ | law is normative (invalid source ⇒ no effect); *assertion* is a POSIX directory listing |
| §2 `W-IMMUTABLE` copy semantics (4) | 4 | **1**⚠ | law is declared (readers hand out fresh copies); vector assumes a mutable-cons host and `eq` identity |
| §2 `W-IMMUTABLE` `(setf reader)` probes (7) | 7 | **5** | `fboundp` of a `(setf f)` function name — zero portable meaning |
| §2b R1/D1 ownership (10) | 10 | **5** | `%ma0-own`, `copy-tree` contrast, symbol `eq`-sharing, byte-vector `aref` — J1's deep-copy primitive |
| §2b R1/D1 source boundary (4) | 4 | **5** | `(setf (char s 0) …)` on returned strings — host memory model |
| §2b R1/D2 branch binding (6) | 6 | **1** | path-sensitive binding + the sealed define-once law + the V-TERM vacuity witness — **all pure validator law, the cleanest portable block in §2b** |
| §2b R1/D3 tree (6) | 6 | **5** | **inputs are pre-read host object graphs** (`program-form` builds forms and calls `ma0-validate` on a *form*, not a file). A text-parsing J2 cannot construct a circular or shared cons. See §4-GAP-3. |
| §2b R1/D5 teeth (3) | 3 | **7** | they test the *detector*, not the law |
| §2b R1/D5 source gate (3) | 3 | **6** | greps over this lane's own `.lisp` files |
| §2b R1/D5 runtime (3) | 3 | **5** | `*ma0-environment-generation*` is package-internal and exposed by nothing — by design |
| §3 no-internals teeth (2) | 2 | **7** | tooth for a grep |
| §3 `NO-INTERNALS` file passes (16) | 16 | **6** | `<predecessor>::` grep over 16 enumerated CL sources |
| §3 W-GENERIC tooth (1) | 1 | **7** | tooth for a grep |
| §3 `W-GENERIC` file passes (4) | 4 | **6** | grep for program names in CL evaluator sources. *A J2's sources are a different language; the law ("no dispatch on program identity") is real but must be re-expressed behaviourally to bind J2 — see §4-GAP-6.* |
| §4/§5 sub-image scenarios (90) | 90 | **1**⚠ | the core portable bank — and the most contaminated. See §3. |

**Suite totals by category:** cat 1 = **141** · cat 5 = **30** · cat 6 = **20** · cat 7 = **6** · cat 2/3/4 = 0.
(141+30+20+6 = 197; the remaining 3 are the §2b R1/D5 runtime block already counted under cat 5 — recomputed: cat 5 = 7+10+4+6+3 = **30**, cat 6 = 3+16+4 = **23**, cat 7 = 3+2+1 = **6**; 141+30+23+6 = **200** ✓.)

### 2.2 Many Acts /0 — the teeth half (outside the suite)

`ma0-teeth.sh` runs **15 sections**. Derivation:

```
grep -c 'section "' ma0-teeth.sh              →  13   (function-call form)
grep -n 'ATTEMPTED=$((ATTEMPTED' ma0-teeth.sh →   3   (1 inside section(); 2 inline)
```
13 `section` calls + inline **§1 NO-INTERNALS** + inline **§4b CONCORDANCE TOOTH** = **15**.
Corroborates `MANY-ACTS-0-R1-RETURN.md`: *"Full floor: 15 sections / 15 green / 0 red"* and
the parcel seal's `teeth 15/15/0`.

| Section | Content | Cat | Note |
|---|---|:--:|---|
| 0 LANE SUITE | re-runs the 200 | — | wrapper; header still says "the lane's own **159** checks" (**stale**, see §5-S1) |
| 1 NO-INTERNALS | 10 files (`DENS_FILES`) + 2 teeth | **6**/7 | grep over CL sources |
| 2 W-NO-BLIND-REPLAY | 7 `dens-check` sites | **3** | hostile re-invocation of a consumed arm |
| 3 W-V-FOOTPRINT (program level) | 5 `dens-check` sites | **3** | invalid program against a LIVE store |
| 4 CONCORDANCE | 7 arms × 18 facets = **126** | **5** | see below |
| 4b CONCORDANCE TOOTH | 1 planted divergence | **7** | tooth |
| 5 DISEASES | 5 diseases / **6** pairs | **2** | see below |
| 6 CAMPAIGN GATES | V-F digest · One Act green · floor untouched · reduced floor | **6** | repo-state gates |
| 7 W-RES-NOT-AUTH | 13 `dens-check` sites | **3** | result object forced into authority position |
| 8–11 R1/D1–D4 | 10 · 9 · 5 · 4 `probe` sites | **5** | repaired-defect regressions on J1 machinery |
| 12 R1 SEVEN-ARM COVERAGE | 7 arms harvested | **6** | transcript harvest |
| 13 R1/D5 GENERATION SEAM | 18 `probe` sites | **5** | package-internal counter |

Counts:
```
grep -oE '\(dens-check ' ma0-no-blind-replay.lisp | wc -l   →  7
grep -oE '\(dens-check ' ma0-footprint-witness.lisp | wc -l →  5
grep -oE '\(dens-check ' ma0-res-not-auth.lisp | wc -l      → 13
grep -oE '\(dens-check ' ma0-concordance.lisp | wc -l       → 17
grep -oE '\(probe ' r1/D{1,2,3,4,5}-*.lisp | wc -l          → 10 · 9 · 5 · 4 · 18
grep -c 'run_disease "' ma0-diseases.sh                     →  6
```

**⚠ The r1/ `probe` site counts do NOT equal the reported "closed" counts** and are not
forced to: `ma0-D1-ownership: 6 owned` vs 10 sites; `ma0-D3-circular-source: 6 closed` vs 5
sites; `ma0-D5-generation-seam: 43 closed` vs 18 sites. Loops and multi-assert probes
account for the spread. **Static site counts, not executed** — the reported numbers stand on
the R1 return's runs, not on this reading.

**CONCORDANCE (126) is category 5, and this is the ruling most likely to be argued with.**
It compares MA0's re-composition against One Act /0's *internal canonical composer*
(`run-all-arms`), both in CL, on 18 enumerated facets:

```
sed -n '126,133p' ma0-concordance.lisp   →  *dens-facets*, 18 entries, enumerated
*dens-arms* = 7   →  7 × 18 = 126        (corroborates R1-RETURN "126 concordance facets")
```

It is a **differential test against a privileged reference implementation**, not a
specification test. A J2 that does not reimplement One Act /0's composer has nothing to be
concordant *with*. Facets like `f3-ledger-answer`, `f4-runtime-resolution`,
`correspondence-row` are One Act internals surfaced through public readers — spec-owned
nowhere in the four public law docs. **Excluded from the portable bank.** (Also note the file
header still advertises `4 arms, 72 facets` — **stale**, §5-S2.)

**DISEASES are category 2 — the conserved quantity.** 5 named diseases, **6** disease/control
pairs (`D-SKIP-VALIDATE` is exhibited on both of its witnesses; `ma0-diseases.sh:278`
says so explicitly). These are inherited red-by-design and must survive the crossing as
*obligations*: for each disease, a J2 that plants the analogous defect must go RED at the
named check, and its restored control must stay GREEN. **The plants themselves are CL source
mutations and do not travel; the obligations do.**

| Disease | Plants | Portable obligation |
|---|---|---|
| D-BOTH-ARMS | every branch arm evaluated | exactly-one-arm selection |
| D-AMBIENT | unoccupied slot filled from a dynamic variable | no ambient authority fallback |
| D-AUTO-RETRY | uncertain/refused act re-invoked blind | no blind replay |
| D-SKIP-VALIDATE | atom scan + step check skipped | invalid source has zero footprint |
| D-SPECIAL-CASE | evaluator dispatches on a program NAME | generic evaluation |

### 2.3 Many Acts /0 — holdout programs

| Path | What | Cat | Count |
|---|---|:--:|---|
| `p3/p3-peregrinatio.lisp` + `run-p3.lisp` | third-domain holdout, authored post-freeze against the guide alone | **1** | 11/0 (parcel seal; **not re-derived here**) |
| `p4/p4-vindemia.lisp` + `run-p4.lisp` | harvest-aggregate holdout | **1** | 11/0 (parcel seal) |
| `p5/p5-xenobiological-quarantine.lisp` + `run-p5.lisp` + `p5-FIRST-RUN.txt` | **a FOURTH holdout, present in the tree, NOT in the R1 parcel seal's number set** | **1** | not sealed — see §5-S4 |
| `programs/p1-editio.lisp`, `programs/p2-custodia.lisp` | the two scored scenarios | **1** | their oracle is the suite's expectation strings — **private test bodies** |

**W-P3-HOLDOUT is the single best-designed portable instrument in the lane** (failure matrix
§4): a program authored against the author guide alone, which must run without evaluator or
grammar change *or its failure is preserved verbatim*. That is exactly a Portable Judge
vector's shape. It should be the template.

### 2.4 One Act /0 substrate

```
grep -o '(check ' act0-gates.lisp | wc -l           → 80
grep -o '(check-eq ' act0-gates.lisp | wc -l        →  1
grep -o '(check ' act0-load-witnesses.lisp | wc -l  → 43
grep -cE '^\(defun gate-' act0-gates.lisp           → 19
```
**88 static check sites** in `act0-gates.lisp` (including `check-identifier-vector` and
`namespace-absence-check`), expanding through 15 `dolist`/`loop` forms to the **authorized
173**. The count is **AUTHORIZED, not observed** — `act0-selftest.lisp` asserts 173 and
fails closed on 172 or 174.

| Bank | Cat | Reason |
|---|:--:|---|
| `gate-16-vectors` (7 sites, incl. `check-identifier-vector`) | **1**⚠ | identifier vectors with `expect-len`/`expect-sha` — spec-owned *if* the digest is spec'd; it is not, publicly |
| `gate-13-lexis-teeth` (5), `gate-l0-teeth` (5) | **1** | lexis law |
| `gate-14-*` (derivation exhibit 1, cold recomputation 1, contrast pairs 4, branch tooth 2) | **1**/**4** | *cold recomputation is the lane's one genuine metamorphic vector* — recompute and require identity |
| `gate-3` seven arms + `run-all-arms` (2 sites) + `assert-unpaired-shape` (7) | **1** | the seven-arm contract order and their shapes |
| `gate-4-agreement-teeth` (9), `gate-7-ordering-teeth` (2) | **1** | agreement + ordering law |
| `gate-6-binding-teeth` (6), `gate-19-binding-consumption` (5) | **1** | binding/seat-consumption law |
| `gate-5-retry-teeth` (3) | **3** | adversarial: retry attempts |
| `gate-15-dispatcher-tooth` (3), `gate-20-ap0-collide` (5) | **3** | adversarial; GATE-20's plant is permanent in the store and **must remain last** |
| `gate-17-environment` (4), `gate-f-store` (1), `gate-8-journal-purity` (1) | **6**/1 | store/env plumbing (6); journal purity is law (1) |
| `gate-16-journal-teeth` (3), `gate-13-inject-layer-2` (4), `nc-39-independent-teeth` (4) | **3** | adversarial injections |
| `act0-load-witnesses.lisp/.sh` (43 sites, **6 cases**: w1-empty-package … w6-repeat-forced) | **6** | pure ASDF/loader plumbing. **Never portable.** |
| `act0-loader-disease.sh` (3 diseases, 4 `run_disease` invocations) | **2** | loader-shaped diseases — cat 2 but **loader-scoped**, so they bind only a J2 that has a loader |
| `act0-fixtures.lisp` | **7** | the seven sealed specimen arms as construction fixtures |

**One Act /0 has NO public prose law document.** `find`/`grep` over the whole tree for a
One Act CONTRACT/GRAMMAR/SPEC returns nothing; `mneme/language-act-0/` holds
`ADOPTION-RECORD-2026-08-08.md`, `CLOSURE-TRANSCRIPT-2026-08-08.txt`, and **implementation
sources only**. Requirement IDs the MA0 docs cite (`ACT-9b`, `BIND-6`, `J-4b`, `O-8`) appear
in **four MA0 files and nowhere else**:

```
grep -rln 'ACT-9b\|BIND-6\|J-4b' --include='*.md' experiments/latent-lisp/
  → MANY-ACTS-0-CONTRACT-CANDIDATE.md · MANY-ACTS-0-RETURN.md ·
    r1/R1-REPAIR-NOTES.md · MANY-ACTS-0-PRESSURE-REPORT.md
```

**This is the single largest structural obstacle to Portable Judge /0.** Every One Act /0
category-1 vector above is *classifiable* as normative but **not yet expressible**, because
its normative content lives only in Lisp. See §6.

---

## 3. ORACLE CONTAMINATION — every category 1–4 vector under suspicion

A vector is contaminated when passing it requires a CL representation, symbol identity, host
condition object, print syntax, or an undocumented substrate magnitude. Ranked by severity.

### SEVERITY 1 — the vector's oracle IS a CL artifact

| # | Vector(s) | n | Reason |
|---|---|---:|---|
| **C-1** | **Identifier case semantics, everywhere** | all IDENT vectors | `ma0-eval.lisp:40,156,160,300` match names via `(symbol-name ident)`. The CL reader has already up-cased `editor-grant` → `"EDITOR-GRANT"`. AUTHOR-GUIDE §8 presents the consequence — *"matched case-insensitively"* — **as a designed rule**. `grep -n 'string-equal\|char-equal\|equalp' ma0-environment.lisp ma0-eval.lisp ma0-structures.lisp` → **no hits**: no explicit case-folding exists. **The law's identifier case behaviour is an unexamined readtable inheritance.** A case-preserving J2 fails vectors nobody meant to write. |
| **C-2** | Scenario expectations naming CL condition classes | 4 | `refused type=LISP-PLUS-MANY-ACTS0:MA0-AUTHORITY-SLOT-UNFILLED`, `…:MA0-COMPOSITION-DIVERGENCE`, `propagated type=LISP-PLUS-LANGUAGE-ACT0:ACT-IDENTITY-TAKEN`, `PROPAGATED LISP-PLUS-LANGUAGE-ACT0:ACT-IDENTITY-TAKEN`. **The oracle is a package-qualified CL class name.** Portable content = the refusal *code* (`MA0-AUTH-1`, `ACT-ORDER-1`) and the requirement id (`ACT-9b`) — never the class. |
| **C-3** | `value=(:ANNOUNCED "codex-sangallensis" :SETTLED)` and every `:UPCASED` keyword in the 90 | ~40 | the oracle is a **printed CL form**. Up-cased keywords are a readtable artifact; the parenthesised rendering is `princ`/`format ~s` output. Nothing normative fixes this notation. |
| **C-4** | §1 `W-V-DATA` ×4, `W-V-PKG` ×2, `W-V-READ` ×1, `W-V-SHAPE` dotted-pair ×1 | 8 | expressed in CL read syntax (`#(1 2 3)`, `#\a`, `1.5`, `#p"…"`, `cl:list`, `#:sneaky`, `#.(+ 1 2)`, `(result . 1)`) over CL types. The *laws* (closed atom vocabulary; no host objects; no read-eval) are portable; **these particular vectors are not.** |
| **C-5** | `§2b` R1/D3 tree fixtures | 6 | inputs are **pre-read host object graphs**, entering through `ma0-validate`'s form arm. A text-parsing J2 has no such entry point. |
| **C-6** | `W-IMMUTABLE` copy-semantics ×4 + `(setf …)` probes ×7 | 11 | mutable-cons host, `eq` identity, `fboundp` of `(setf f)`. |

### SEVERITY 2 — substrate-coupled magnitudes with no public derivation

| # | Vector(s) | n | Reason |
|---|---|---:|---|
| **C-7** | `prefix-frames=8` · `=21` · `=22` · `earlier-frame-rows=10` | 4 | One Act /0 journal-frame counts. **Nothing in the four public law docs derives these.** A J2 not reimplementing One Act cannot produce them. |
| **C-8** | `hexlen=64` (×3) | 3 | AUTHOR-GUIDE §4 says "the 64-character act-identity digest segment" — the *length* is documented, **the digest algorithm is not**. Length is portable; identity is not. |
| **C-9** | `store-id-length=74` | 1 | store-id encoding is nowhere public. |
| **C-10** | `classification=:ACT-REPORTED`, `classification revocata=:BINDING-DECLARED-UNPAIRED` | 2 | `classify-act-frames` vocabulary — **undocumented in every public doc**. |
| **C-11** | One Act `gate-16-vectors` `expect-sha` | ≤7 | identifier vectors pinned by sha with no published digest spec. |

### SEVERITY 3 — filesystem/POSIX shape

| # | Vector(s) | n | Reason |
|---|---|---:|---|
| **C-12** | `W-V-FOOTPRINT` (suite, 2) and program-level (teeth §3, 5) | 7 | "no footprint" asserted as a **POSIX directory listing** (`%ma0-directory-entries`, `.lisp` in filenames, no subdirectories). The law is normative; the observation is filesystem-shaped and must be re-expressed as *effect absence* in the observation format. |
| **C-13** | `run-VOID` on a process-killing environment variable (AUTHOR-GUIDE §8) | — | POSIX env-var semantics as a law surface. |

### Contamination totals

**Severity-1 hard-blocked category-1 vectors:** C-2 (4) + C-4 (8) + C-5 (6) + C-6 (11) = **29**
(C-1 and C-3 are pervasive rather than countable — they contaminate *ranges*, not items).
**Severity-2 blocked:** C-7 (4) + C-8 (3) + C-9 (1) + C-10 (2) = **10**.

---

## 4. THE PORTABLE-BANK CANDIDATE SIZE

Categories 1–4 only, Many Acts /0 lane + its One Act /0 substrate.

| Source | Cat 1 | Cat 2 | Cat 3 | Cat 4 |
|---|---:|---:|---:|---:|
| MA0 suite (`ma0-selftest-suite.lisp`) | 141 | — | — | — |
| MA0 teeth: no-blind-replay · footprint · res-not-auth | — | — | 25 | — |
| MA0 diseases (`ma0-diseases.sh`) | — | 6 pairs / 5 diseases | — | — |
| MA0 holdouts p3 · p4 (sealed) | 22 | — | — | — |
| MA0 holdout p5 (unsealed, present) | *unknown* | — | — | — |
| MA0 twin-run byte-identity (contract §5) | — | — | — | 1 obligation |
| One Act /0 gates (of 173 authorized) | ~120 est. | — | ~15 est. | 1 (`gate-14-cold-recomputation`) |
| One Act /0 loader diseases | — | 3 diseases / 4 invocations | — | — |

### The number, three ways — and only the third is honest

1. **GROSS (categories 1–4, everything counted):** 141 + 25 + 22 + ~135 (One Act) = **≈ 323 checks**, plus 9 disease pairs and 2 metamorphic obligations.
2. **MA0-ONLY GROSS:** 141 + 25 + 22 = **188 checks**, + 6 disease pairs, + 1 metamorphic obligation.
3. **MA0-ONLY NET, after removing severity-1/2 hard-blocked:** 188 − 29 − 10 = **149 checks.**

> ### ⇒ **PORTABLE-BANK CANDIDATE SIZE: 149 checks (Many Acts /0), + 6 disease obligations, + 1 metamorphic obligation.**
>
> **Three riders, all binding.**
>
> **(i) NOT ONE OF THE 149 IS SCORABLE TODAY.** Every one of them is asserted today as a
> stdout line-match against CL-printed values. All 149 require re-expression through
> `NORMATIVE-OBSERVATION-FORMAT-0` before they can bind a J2. The 149 is a count of
> *candidates for translation*, not of ready vectors.
>
> **(ii) The One Act /0 contribution (~135) is EXCLUDED from the headline** because its
> normative content has no public prose statement (§2.4). Including it would be counting
> vectors whose specification does not exist.
>
> **(iii) C-1 (identifier case) is unresolved and touches an unknown fraction of the 149.**
> Until the packet declares identifier case semantics normatively, that fraction is a
> standing liability, not a subtractable number.

---

## 5. RECONCILIATION AGAINST THE COMMISSION'S QUOTED NUMBERS

The commission quoted: **selftest 38 · inhabited 12 · graph 9 · hostile 110 · disease 8/8 ·
loader witnesses 14/10/8/12 · battery 13/13.**

**FINDING: all seven belong to a DIFFERENT LANE — `mneme/language-surface-account-0/`
(Surface Account /0, ADOPTED 2026-08-06). Not one of them refers to Many Acts /0 or One Act
/0.** They appear as a **contiguous block** in
`language-surface-account-0/ADOPTION-RECEIPT-2026-08-06.md`, lines 36–43.

```
grep -n 'surface-account' experiments/latent-lisp/mneme/verify-release.sh
  193 … surface-account-selftest.lisp   | surface-account-selftest: 38 checks, 0 failures
  194 … surface-account-inhabited.lisp  | surface-account-inhabited: 12 checks, 0 failures
  195 … surface-account-graph-gate.sh   | surface-account-graph-gate: 9 checks passed, 0 failed
  196 … run-hostile-profiles.sh         | …: 7 roles + 4 loader cases, 110 checks, 0 failures
  197 … surface-account-disease.sh      | …: 8 diseases detected, 8 controls clean
```

| Quoted | Actual referent | Verdict |
|---|---|---|
| **selftest 38** | `surface-account-selftest: 38 checks, 0 failures` (verify-release.sh:193; receipt "production self-test **38/38**") | **Surface Account /0.** No Many Acts bank has 38. MA0's suite = 200; One Act = 173. |
| **inhabited 12** | `surface-account-inhabited: 12 checks, 0 failures` (:194) | **Surface Account /0.** *No "inhabited" bank exists in Many Acts /0 or One Act /0 at all.* |
| **graph 9** | `surface-account-graph-gate: 9 checks passed, 0 failed` (:195) | **Surface Account /0** (ASDF/umbrella graph gate). MA0 is explicitly **outside** the umbrella (contract §3) — it *cannot* have a graph gate. |
| **hostile 110** | `surface-account-hostile-profiles: 7 roles + 4 loader cases, 110 checks` (:196) | **Surface Account /0.** MA0's adversarial banks are `W-NO-BLIND-REPLAY` (7), `W-V-FOOTPRINT` program-level (5), `W-RES-NOT-AUTH` (13) = **25**, not 110. |
| **disease 8/8** | `surface-account-disease: 8 diseases detected, 8 controls clean` (:197) | **Surface Account /0.** MA0's disease bank is **5 diseases / 6 pairs**; One Act's loader-disease bank is **3 diseases**. Neither is 8. |
| **loader witnesses 14/10/8/12** | Surface Account /0 R4.3 loader-finality witness cases (`R4/R4-RETURN.md:72`: "44 `[Lnnn]` checks: internal-dummies 14, partial-external 10, empty-package 8, repeat-after-repair 12") | **Surface Account /0.** One Act /0's loader witnesses are **6 cases** (`w1-empty-package … w6-repeat-forced`, `act0-load-witnesses.sh:43`), sentinel `6/6 cases green, tooth caught` — a **different shape entirely**. The name-collision on "empty-package" is coincidental. |
| **battery 13/13** | "frozen R3.3.3 battery: **13/13 profiles accepted**, `SURFACE-ACCOUNT-0-PROBE-PASS`" (adoption receipt:43) | **Surface Account /0.** **No current Many Acts /0 or One Act /0 bank corresponds — number unverified for this campaign.** |

**Consequence.** The commission's Phase-0 sketch was drawn from the Surface Account /0
adoption receipt, not from the Many Acts /0 lane. **No forced correspondence has been
constructed.** The actual banks are enumerated in §1–§2.4.

### Staleness and gaps found while counting (each verified, none repaired)

- **S1.** `ma0-teeth.sh:15` still calls the suite *"the lane's own **159** checks"*. Actual: **200**. `MANY-ACTS-0-R1-RETURN.md:44` records the transition (*"Suite 159 → 200, mechanically counted"*); the teeth header was not updated.
- **S2.** `ma0-concordance.lisp:97` advertises the sentinel `ma0-concordance: **4 arms, 72 facets**, 0 divergences`; the file's own `*dens-arms*` (7) × `*dens-facets*` (18) = **126**, and R1-RETURN reports 7/126. **The example sentinel in the header is a pre-R1 fossil.**
- **S3.** `AUTHOR-GUIDE.md` §10.9 states *"the concordance teeth that would test it **have not been built**"* and *"A green suite … says nothing about whether this composition agrees with the canonical one."* **They have been built** (`ma0-teeth.sh` §4, §4b; 126 facets, 0 divergences per R1-RETURN). **This is the most consequential staleness found: the guide is the packet's front door, and it understates the lane's evidence.**
- **S4.** `p5/` (xenobiological quarantine) exists with a `p5-FIRST-RUN.txt`, and is **absent from the R1 parcel seal's number set** (which names P3 11/0 and P4 11/0 only). A fourth holdout is in the tree without a sealed count.
- **S5.** `:absence-keyword-fired` appears in `ma0-driver.lisp:210` and **nowhere else** — the absence-keyword matching law (`:absent-from-evidence` / `:malformed-in-evidence`, published axis values, `ma0-structures.lisp:102`) is **exercised by a driver scenario but asserted by no expectation string.** A published law with zero scoring coverage.
- **S6.** Empty `:authority-slots` is refused by the validator (`ma0-validate.lisp:632-638`, *"with at least one slot"*) and **no public vector covers it** (`grep -c 'at least one slot' ma0-selftest-suite.lisp` → 0).

---

## 6. HIDDEN-BANK COVERAGE REQUIREMENTS (category checklist)

For each category: **does the lane's law have the feature** (verified, not assumed), and
**do the public vectors already cover it** (if yes, the hidden bank must go *beyond*, not
duplicate).

Legend — Law: ✅ present · ⚠ partial · ❌ absent (hidden bank must NOT invent it).
Public: **covered** / **thin** / **NONE**.

| # | Category | Law? | Public? | Hidden-bank requirement |
|---|---|:--:|---|---|
| 1 | **valid grants** | ✅ `:grants '((:slot S :arm A))`, AUTHOR-GUIDE §8 | covered (p1, p2α, p2β) | multi-slot; slot granted for the wrong arm; grant + revocation on the same arm; a slot declared but never granted **and never used** |
| 2 | **valid refusals** | ✅ `(refuse (:code KEYWORD) VEXPR?)` → `:refused`, orderly, runner exit 0 | covered (p2α, p2β) | refusal from *inside* a branch arm; refusal with no payload; refusal whose code collides with a grammar keyword |
| 3 | **malformed forms** | ✅ V-SHAPE | covered (5 vectors) | **decontaminated** re-expression of the dotted-pair vector; zero forms in a file; whitespace/comment-only file; truncated form |
| 4 | **invalid authority** | ✅ V-AUTH / V-RES-AUTH | covered (4 vectors) | slot name colliding with a binding name; slot in `(:seat …)` position; act-result in slot position at depth |
| 5 | **inadequate evidence** | ⚠ — the axes are `:execution`/`:provenance`/`:evidence-class`; "inadequate" is not a law term | thin | express as *specific* axis combinations, never as the word "inadequate" |
| 5b | **stale evidence** | ⚠ ✅ but **package-internal** — `*ma0-environment-generation*` (R1/D5); no public reader | NONE (public) | **the stale-environment refusal is observable at the boundary** (both entry points refuse before any act/journal/world mutation) — a portable vector must assert the *refusal*, never the counter |
| 5c | **inaccessible evidence** | ✅ absence keyword `:absent-from-evidence` (`ma0-structures.lisp:102`) | **NONE — S5** | mandatory: an absence-keyword atom that HOLDS, and one that does not |
| 5d | **malformed-in-evidence** | ✅ absence keyword `:malformed-in-evidence` | **NONE — S5** | mandatory, same shape |
| 5e | **fabricated evidence** | ❌ **NOT A LAW TERM** — `grep -ci 'fabricat' ma0-validate.lisp ma0-eval.lisp` → 0/0 | n/a | **DO NOT AUTHOR.** The nearest real law is `W-RES-NOT-AUTH` (a result object forced into authority position) — already cat 3 |
| 6 | **nested refusal detail** | ✅ `refuse` payload is a VEXPR, so `(list …)` nests | thin (`refusal-detail="marcus"` only, flat) | nested `(list (list …))` payload; payload containing every LITERAL type |
| 7 | **ordered summaries** | ✅ `-act-summaries` ordered oldest-first, AUTHOR-GUIDE §8 | covered (p1 1, p2α 2, p2β 3) | 4+ summaries; ordering preserved across a branch; ordering after a mid-program refusal |
| 8 | **support + provenance preservation** | **support ❌ / provenance ✅** — `grep -ci 'support' ma0-validate.lisp ma0-structures.lisp` → **0/0**. "Support" is a **Language-A** concept, not an MA0 one. `:provenance ∈ {:live :derived-recovery :none}` is real | provenance: thin (`:NONE` only, observed) | provenance vectors **only**; **DO NOT AUTHOR "support" vectors** — they would test a law this lane does not have |
| 9 | **unsupported-support disappearance** | ❌ **NOT IN THIS LANE'S LAW** (same reason as 8) | n/a | **DO NOT AUTHOR.** Flag to the owner if the commission intends to import it |
| 10 | **prohibited-branch nonexecution** | ✅ W-BRANCH-ONE; D-BOTH-ARMS is its planted disease | covered (`w-branch-one`: `summary-count=0`, `prefix-frames-before=after`, `frame amissa :F1 present=NIL`) | untaken arm containing an `act` on an arm used *nowhere else*; three-way branch, middle clause selected; nested branch inside a selected arm |
| 11 | **replay stability** | ✅ contract §5, *"two-run byte-identical stable-output obligation"* | covered as a **process obligation**, not as a vector | make it a **vector**: same program + same declared environment, two runs, identical normative observation |
| 12 | **Unicode edge cases** | ✅ sources read `:external-format :utf-8` (`ma0-validate.lisp:73`); STRING admitted with **no character-set restriction** | **NONE** | mandatory: non-ASCII in `:name`, in a `(result "…")` payload, in a seat name, in a `:code` keyword; combining marks; astral-plane (>BMP); NFC/NFD pair as a **metamorphic** vector; a non-ASCII IDENT (interacts with **C-1**) |
| 13 | **big integers** | ✅ **PRESENT AND UNBOUNDED.** `ma0-validate.lisp:176` admits `((integerp node))` with **no magnitude test**; the only declared bounds are `+ma0-max-source-depth+ 32` and `+ma0-max-source-nodes+ 4096` (`ma0-structures.lisp:117,121`) — node counts, not value sizes | **NONE** | mandatory: an integer far beyond 64-bit as an `:input` and as a `result` payload; large negative; `0` |
| 13b | **rationals** | ❌ **REFUSED.** `ma0-validate.lisp:148` names *ratio* explicitly in the refused list; `LITERAL := STRING \| INTEGER \| KEYWORD` | covered by `W-V-DATA` float only | a **refusal** vector for a rational — never an acceptance vector. **Do not assume the law has rationals: it does not.** |
| 14 | **record ordering** | ✅ W-ORDER-STORE (ordering guard derived from the store's validated prefix) + ordered summaries | covered (`w-order-store`: `prefix-frames=8` → refusal → `prefix-frames-after=8`) | **the existing vector is C-7-contaminated** (frame magnitudes); re-express as *ordering preserved*, not *count equals 8* |
| 15 | **identifier distinctions** | ✅ …and **the case rule is an artifact, not a design** (C-1) | **thin and unsafe** | mandatory: names differing only in case; only in a hyphen; a name that is a prefix of another; a name colliding with a grammar head; a name colliding with an arm string. **Every one must be adjudicated against a normative case rule the packet does not yet state.** |
| 16 | **empty / boundary cases** | ✅ `:input ()` empty allowed; `:authority-slots (IDENT+)` requires ≥1 (`ma0-validate.lisp:632-638`); depth 32 / nodes 4096 declared | **thin — S6** | mandatory: empty `:authority-slots` refusal (**zero public coverage**); depth exactly 32 vs 33 **as source text**; node count exactly 4096 vs 4097 **as source text** (the existing bound vectors are C-5-contaminated pre-read forms); single-step program; `branch` with exactly one clause + `otherwise` |
| 17 | **metamorphic pairs** | ✅ the *property* exists (whitespace, comments, clause-atom order canonicalization, `(:and A B)` ≡ `(:and B A)`) | **NONE — no metamorphic vector exists anywhere in the MA0 bank** (One Act's `gate-14-cold-recomputation` is the only metamorphic instrument in either lane) | **mandatory and highest-value.** Whitespace/comment reformatting ⇒ identical observation; `:and` atom reorder ⇒ identical selection (note: *duplicate* reordered conjunctions are refused, so the pair must use a single clause); integer written with leading `+`; program renamed ⇒ only `program-name` differs. **Metamorphic vectors are the least contaminable class available** — they compare a J2 to *itself*, so they carry no CL oracle at all. |

**Two prohibitions the curator must carry:** categories **5e**, **8 (support)**, and **9**
name laws **this lane does not have**. Authoring vectors for them would convict a correct J2.
Verified by grep, not assumed.

**One structural requirement.** Every hidden vector must state its expected observation in
`NORMATIVE-OBSERVATION-FORMAT-0` terms, never as a CL-printed line. A hidden bank authored
in the public bank's idiom would inherit **C-1 through C-13 wholesale** and would be a
conformance bank that convicts innocent implementations — the exact failure this campaign
exists to prevent.

---

*— drafted by CENSITOR (Claude Opus), commissioned by the chair (Claude Fable 5), 2026-08-10*
