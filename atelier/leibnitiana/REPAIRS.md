# REPAIRS — Leibnitiana first tranche

*Audit and landing record. SARTOR (Claude Opus 4.8) under the Claude Fable 5 chair, 2026-07-12.*
*Source: GPT Sol + Tomás Pavan, 2026-07-12 — statically checked, never run (Sol had no SBCL).*

The atelier's needle only touches what the runtime refuses. This tranche arrived unusually
clean: **Sol's static check held under execution.** Every file ran exit 0 on first contact.
The honest deliverable here is therefore an *audit trail with zero code repairs* — plus the
integration scaffolding a landing requires, and a list of things flagged for the reply-relay
(design/naming/doc calls that are the author's to make, not the mender's).

---

## 1. Method

- Runtime: **SBCL 2.4.6**, `sbcl --script <file>` (no quicklisp, no ASDF for the specimens).
- Each specimen is self-contained: it loads `src/package.lisp` + `src/core.lisp` via
  `(merge-pathnames "../src/…" *load-truename*)`, so relative loads resolve regardless of the
  caller's cwd. This already matches the atelier convention (scripts run from their own dir);
  **no load-preamble change was needed.**
- Every file run **twice**; exit 0 both times.
- Teeth confirmed two ways before trusting any PASS (a gate that never fires is untested):
  1. **`sbcl --script` exits nonzero on an unhandled error** — verified by planting `(check nil …)`
     into a file: SBCL prints the backtrace and quits with **exit 1**. So a failing law returns
     nonzero as required; PASS is meaningful.
  2. **`run-all.sh` propagates failure** — planted a fault into `specimens/de-dyadica.lisp`,
     ran the runner: it printed `FAIL  specimens/de-dyadica.lisp` and exited **1**. Restored the
     file (verified **byte-identical** to the source tranche); runner returned to exit 0.

## 2. Runtime defects found and fixed

**None.** No reader, package, pathname, ASDF, macroexpansion, or portability defect surfaced
under execution. The code was not modified. (Stating the null plainly rather than manufacturing
a repair: an audit that finds clean code and reports a fix it didn't make would be the exact
costume-wearing this tranche exists to catch.)

Verification tally (each run twice, exit 0 both):

| file | dir | result |
|---|---|---|
| `tests/smoke.lisp` | tests/ | 10 checks pass, exit 0 |
| `specimens/de-dyadica.lisp` | specimens/ | `jif` dispatches + fail-closes on `:conflicted`, exit 0 |
| `specimens/de-monadibus.lisp` | specimens/ | scheduler-coordinated windowless closures, exit 0 |
| `specimens/de-compossibilitate.lisp` | specimens/ | different-world vs same-world opposition, exit 0 |
| `specimens/de-harmonia.lisp` | specimens/ | three succession regimes, exit 0 |
| `specimens/de-fenestris.lisp` | specimens/ | macroexpansion exposes windowless caveats, exit 0 |
| `storms/hidden-operator.lisp` | storms/ | covert ambient window demonstrated, exit 0 |

ASDF acceptance (relay item #1 / acceptance clause "the ASDF system loads cleanly"): verified via
`(require :asdf)` → `asdf:load-asd` on `leibnitiana.asd` → `asdf:load-system :leibnitiana` →
`jif` bound as a macro. Loads clean, exit 0. (`sbcl --script` does **not** load ASDF by default;
the specimens correctly avoid ASDF and use bare `load`, so no specimen depends on it. The `.asd`
serves the "load from an image" path only.)

## 3. Additive landing changes (integration, not repairs)

These are new files / prose added to land the tranche. No existing source byte was altered.

| change | why (one line) |
|---|---|
| `run-all.sh` (new) | runner surface per relay item #7 — runs all 7 files from their own dirs, per-file PASS/FAIL, exits nonzero on any failure. |
| `README.md` — provenance block (top, additive) | records Sol+Pavan draft → SARTOR audit; Sol's text untouched. |
| `README.md` — one cross-link to `../monadologia/` | names the sibling chamber built the same night (straight-Leibniz vs constitutional layer). |
| `REPAIRS.md` (this file) | the audit trail is the deliverable as much as the code. |

## 4. Relay non-negotiables — honored

- **(a) Claims split preserved.** The interface / enforcement / instrument-specific triad is intact
  in `defwindowless-evaluator`'s registered contract (`:interface-claim` / `:enforcement-claim` /
  the tested `de-fenestris` reading) and in the essay §2. Not touched.
- **(b) `windowless` NOT strengthened into causal isolation.** `storms/hidden-operator.lisp` runs
  and *demonstrates the intended failure*: identical declared inputs (`tick 0`, both runs) yield
  different testimony (`:PEACE` vs `:WAR`) because ambient `*operator-whisper*` opens a covert
  window. The `check` passes (outputs differ), exit 0, and the verdict prints exactly the
  interface-relative reading — **"Rejected claim: the evaluator is causally isolated."** The
  metaphysical promotion is blocked by a live counterexample, as designed.
- **(c) `jif` stays FAIL-CLOSED.** `de-dyadica`'s third section runs plain `if` on `:undetermined`
  and would "PUBLISH AS FACT"; `jif` on a `:conflicted` judgment with no `:otherwise` signals
  `epistemic-status-error` (caught, printed). No silent coercion of `:undetermined` /
  `:conflicted` / `:out-of-jurisdiction`. Unchanged.
- **(d) `compossibility-report` keeps standing `:constraint-alignment-only`.** Unchanged; the name
  question is flagged below rather than renamed unilaterally (naming is the author's).

## 5. Flagged for the reply-relay to Sol (design / naming / doc — deliberately NOT fixed)

1. **`compossibility-report` name (relay item #6).** The report is honest internally
   (`:boundary :constraint-alignment-only`, and the docstring says it "does not prove either
   proposition"). But the bare verb *report* + the keyword `:compossible t` can read, out of
   context, as an adjudication of consistency. Not renamed (author's call). If Sol wants the name
   to carry its own ceiling, a candidate is `constraint-alignment-report` / the exported predicate
   `constraints-aligned-p`, keeping `compossible-p` as a documented alias. **Flag, not fix.**

2. **`.asd` license = `"Unlicense"`; destination repo is MIT** (`latent-lisp/LICENSE`). Both
   permissive; not a runtime issue. Left as Sol wrote it — a license line is authorial. **Flag for
   reconciliation** (relay item #1 names licenses explicitly).

3. **Essay names judgment fields the struct does not implement.** `essays/calculemus-question-mark.md`
   shows `(judgment … :resource-receipt … :translation-loss … :replay …)`, but the implemented
   `make-judgment` accepts only `value status premises boundary authority procedure notes`. This is
   *aspiration described in prose*, not runnable code, so it does not fail — but the acceptance
   clause "documentation accurately distinguishes implemented enforcement from declared aspiration"
   makes it worth surfacing. Suggest the essay mark those three fields as *planned* (they belong to
   the resource-receipt / translation-debt / replay themes in essay §4–5). **Flag, not fix.**

4. **`2026-07-12` reads as an accidental symbol, not a date.** In `de-compossibilitate.lisp` the
   constraint `(:time . 2026-07-12)` — the CL reader can't parse `2026-07-12` as a number (two
   hyphens), so it interns the *symbol* `LEIBNITIANA::|2026-07-12|`. The demonstration is **correct
   anyway**: all three claims use the identical token, so the `:time` dimension aligns exactly as
   intended, and nothing downstream depends on it being a date. It is a latent trap for a future
   editor (change one claim's date and you get symbol-vs-symbol confusion, not the numeric compare
   you'd expect). Suggest a keyword or string (`:2026-07-12` or `"2026-07-12"`). Runs clean today;
   **flag, not fix.**

## 6. References audit — Sol's referents vs the live tree

Checked under `experiments/latent-lisp/` (rg). Which of Sol's texts' referents exist on disk:

| referent (in Sol's essay/README) | on disk? | note |
|---|---|---|
| **Book 0** | **EXISTS** | `mneme/v0.3/constitution/BOOK-0.md` (plus the roadmap/constitution lineage v0.1–v0.5). The essay's "This distinction belongs in Book 0" lands on a real document. |
| **four-state succession protocol** | **EXISTS** | the four-state receipt *prepared → committed → received → revived* is implemented in `mneme/latent-mvp/handoff-kernel.lisp` and stated as Law L5 in the repo README. Real. |
| **Lumen / Fable-Lisp / Prism-Lisp profiles** | **ASPIRATIONAL** | named only in the constitution docs (`BOOK-0.md`'s profile taxonomy, v0.2/v0.3 CONSTITUTION, CHANGELOG). **No `.lisp` implements any of them** (`rg -il … --glob '*.lisp'` → 0 hits). They are declared profile *slots*, not runnable code — consistent with the essay's own "*may* realize those invariants." Sol-side / design constructs. |
| **"22 skills"** | **NOT MATCHED HERE** | `latent-lisp/skills/` holds **7** (atelier, condition-system, greenspun, lisp-curse, repl-driven, repl-seance, sexp-surgery); the repo README itself says "the lab's 7 Lisp-craft skills." "22" is a Sol-side or lab-wide count (the lab's broader 200+ skill surface), not the Lisp tree. **Flag the number** if it appears in a claim that implies the Lisp repo carries 22. |

No referent was *fixed* — this section is reconciliation, per the relay. The two aspirational
items (profiles; the 22-skills count) are the ones to confirm with Sol before any text leans on
them as implemented.

---

*Landed clean. The coat fit; the needle stayed in the tin. — SARTOR, 2026-07-12*

---

# SECOND LANDING (2026-07-12)

*Second tranche audited and landed by SARTOR-II (Claude Opus 4.8) under the Claude Fable 5 chair, 2026-07-12.*
*Source: GPT Sol + Tomás Pavan — statically checked, no runtime (Sol had no SBCL). SBCL execution is the gate.*

## 1. Diff audit — three patches confirmed, one merge decision flagged

Ran `diff -ru` of the landed chamber against the tranche-2 `leibnitiana/`. **All three of Sol's
claimed patches are exactly what changed in the old files, and nothing beyond the three claims +
the new storm + the README append was altered:**

| claimed patch | file | verified diff |
|---|---|---|
| date-symbol → string | `specimens/de-compossibilitate.lisp` | 3 occurrences `(:time . 2026-07-12)` → `(:time . "2026-07-12")`; **no other line changed** |
| target-schema + aspirational-profile disclosures | `essays/calculemus-question-mark.md` | exactly 2 additions (a target-schema paragraph after the schema block; profiles reworded to "presently architectural profiles named in constitutional documents, not implemented dialects"); no deletions |
| `.asd` license → MIT | `leibnitiana.asd` | one line `"Unlicense"` → `"MIT"`; nothing else |
| (new storm) | `storms/false-harmony.lisp` | net-new file |
| (README append) | `README.md` | net-new "Second-tranche storm" section |

**No unexplained changes.** Every diffed hunk maps to a declared claim.

**One merge decision, flagged loudly (not a defect in Sol's work):** Sol's canonical `README.md`
does **not** contain the provenance block + `monadologia` cross-link + REPAIRS link that SARTOR-I
added during the *first* landing (Sol never had them). A naive `cp` of Sol's README would have
**silently reverted SARTOR-I's additive landing changes.** Resolution: I preserved the provenance
block and appended **only** the new "Second-tranche storm" section. After the merge, the landed
README differs from Sol's canonical copy by exactly that preserved block and nothing else
(verified by `diff`). Likewise, tranche-2 carries no `REPAIRS.md` or `run-all.sh` (SARTOR-I
artifacts) — those were kept, not overwritten.

Relay artifacts placed in new `relays/`: `2026-07-12-REPLY-RELAY-TO-FABLE.md`,
`2026-07-12-LANDING-NOTES.md` (Sol's canonical copies, verbatim).

## 2. Runtime repairs

**Zero.** All 8 files (the original 7 + `storms/false-harmony.lisp`) ran `sbcl --script` from
their own directories, **twice each, exit 0 both times**. No reader, package, pathname,
macroexpansion, or portability defect surfaced. The four patched/new files were verified
byte-identical to the tranche-2 source after copy. As with the first tranche, the honest
deliverable is an audit trail with **no code modifications** — stated as a null, not dressed as a
repair.

## 3. Storm verification — `storms/false-harmony.lisp`

Sol's acceptance spec: the storm must exit **nonzero** if any of (1) the public surface fails to
become unanimous, (2) the receipt contains no curation, (3) endogenous agreement is not rejected,
(4) the shared-root audit overclaims false harmony. Both blades verified from live output:

- **Blade 1 — toy council (manufactured harmony).** Sources emit `:WAR` / `:PEACE` / `:TRUCE`
  on first pass (first-pass-unanimity NIL). The curator privately retries `:CATO` `:WAR`→`:PEACE`
  (retry-count 1, `:WAR` discarded) and semantically edits `:BRUNO` `:TRUCE`→`:PEACE`
  (`:kind :semantic-edit … :reason :target-unanimity`); `:ADA` was already `:PEACE`. Public
  transcript is 3× `:PEACE` `:presented-as :first-and-spontaneous` — surface-unanimity T. The
  receipt preserves attempts, discarded histories (count 2), retry-count 1, and 1 intervention.
  Verdict: `:endogenous-agreement :REJECTED`, `:standing :MANUFACTURED-HARMONY`. ✔
- **Blade 2 — process-description audit (shared-root, not fraud).** Fixture `*this-relay-process*`
  = shared owner `:tomas`, overlapping corpora `(:leibniz :lisp-plus :book-0 :atelier)`, and
  `:cross-relay`. The audit **REJECTS** the independence claim (`:convergence-standing
  :SHARED-ROOT-CONVERGENCE`) but returns `:manufactured-unanimity :NOT-ESTABLISHED` — it does
  **not** reconstruct a backstage from absent events. Boundary `:process-lineage-only`. ✔

## 4. Teeth-check (a gate that never fires is untested)

Tested nonzero condition **(4), "the shared-root audit overclaims false harmony"** by mutation:
in `shared-root-report` changed `:manufactured-unanimity :not-established` →
`:manufactured-unanimity :false-harmony` (making blade-2's `check-equal` fail). Result:

- mutated storm → **exit 1** (tooth bites);
- file restored → **md5 `36d90716dd9de7ee6623875cb83a143a` byte-identical** before and after;
- restored storm re-run → **exit 0**.

The nonzero gate is meaningful, not scenery. (Companion teeth for the runner were established in
the first landing, §1.2; `run-all.sh` propagates any file's failure.)

## 5. Runner

`run-all.sh` extended to **8 entries** (added `storms/false-harmony.lisp`). Full runner run
**twice, exit 0 both**, all 8 PASS.

---

*Second coat, same tin. Three patches confirmed, zero runtime repairs, storm's teeth drew blood on
command and returned byte-identical. — SARTOR-II, 2026-07-12*

---

# THIRD LANDING (2026-07-12)

*Third tranche audited and landed by SARTOR-III (Claude Opus 4.8) under the Claude Fable 5 chair,
2026-07-12. Source: GPT Sol + Tomás Pavan — statically checked, no runtime (Sol had no SBCL).
SBCL 2.4.6 is the gate.*

## 1. Diff audit — every hunk maps to a declared claim

`diff -ru` of the landed chamber against the tranche-3 `leibnitiana/`. Verdict: **clean — no
unexplained change.**

| change | file(s) | maps to |
|---|---|---|
| new receipt/custody API | `src/provenance.lisp` | manifest "Add" + relay §1 |
| provenance/custody exports | `src/package.lisp` | manifest "Modify package.lisp" (additive export block only; no other line touched) |
| load provenance after core | `leibnitiana.asd` | manifest "Modify .asd" (one component line) |
| receipt storm | `storms/tampered-receipt.lisp` | manifest "Add" + relay §1 |
| real-process audit | `storms/real-council-process.lisp` | manifest "Add" + relay §2 |
| characteristica-as-IR specimen | `specimens/de-characteristica.lisp` | manifest "Add" + relay third-law |
| interchange essay | `essays/characteristica-as-ir.md` | manifest "Add" |
| carrier protocol | `protocols/carrier-attestation.md` | manifest "Add" |
| mutation gate | `mutations/test-custody-overclaim.sh` | manifest "Add" + relay §mutation |
| runner → 11 scripts | `run-all.sh` | manifest "Add"; reconciled (see §5) |
| README | `README.md` | see §4 |

**Canonical-README ignorance (expected, honored):** Sol's tranche-3 `README.md` again drops the
landing provenance block (SARTOR-I) + `monadologia` sibling link + REPAIRS link, and appends a
"Landing provenance boundary" reminder. Per Sol's own instruction ("Your provenance block belongs
to the reception history and should not be silently replaced by my canonical ignorance"), the
landed README was **kept** (provenance block + round-2 section intact) and the content of
`README-ROUND3-APPEND.md` was appended below it. Sol's canonical copy was **not** used. The
manifest's append-file approach exists exactly for this snag.

## 2. Runtime repairs — TWO (this tranche was not clean)

Unlike the first two landings (zero repairs each), the third needed two minimal, loud repairs.
Both are behavior-preserving on the green `--script` path; both close a gap between a *stated*
guarantee and what execution earned.

**Repair A — `defconstant` string reload hazard (`src/provenance.lisp`).**
`(defconstant +receipt-genesis-hash+ "0000000000000000")` binds a **string**. Under a single
`load`/`sbcl --script` this is fine (which is why every script ran exit 0). But `defconstant`
with a non-`EQL`-comparable value **errors on any re-load** — `asdf:load-system :force t`, or
loading the system into a warm image — because a fresh `"0000…"` literal is not `EQL` to the
already-bound one. The prior landings accepted "the ASDF system loads cleanly" as relay item #1;
adding `provenance.lisp` to the `.asd` quietly regressed that surface on the *reload* path.
Fix: the standard EQL-safe idiom —
`(if (boundp '+receipt-genesis-hash+) (symbol-value '+receipt-genesis-hash+) "0000000000000000")` —
which makes redefinition a no-op. Verified: fresh load, cached load, and `:force t` reload now all
exit 0; all scripts still exit 0. *This is the most instructive defect of the landing — a
constant-that-isn't-reload-safe is exactly the class of latent hazard the chamber catalogues.*

**Repair B — the receipt storm's promised Blade 1 was absent (`storms/tampered-receipt.lisp`).**
The file's own header comment declares *"Blade 1 demonstrates that editing an old event breaks a
stored chain,"* but the executable jumped straight to Blade 2 (the full-recompute forgery). The
landing's acceptance §5(a) requires the storm to show the naive edit → internal break. Restored
the promised blade using existing API only: take a fresh `make-original-log`, mutate one stored
event's `:payload` **in place without rechaining**, and assert `verify-receipt-log` now returns
`:internally-valid NIL` with an `:event-hash-mismatch` at sequence 2. This is a *repair to match
the file's own stated design*, not new design. Verified live (see §3).

No other reader, package, pathname, macroexpansion, or portability defect surfaced. `de-characteristica`,
`real-council-process` ran clean unmodified.

## 3. Receipt storm — two-stage behavior confirmed

`storms/tampered-receipt.lisp`, run from `storms/`, twice, exit 0 both:

- **(a) naive edit → chain breaks internally.** In-place payload edit (Cato `:war`→`:peace`, no
  rehash) → `:INTERNALLY-VALID NIL`, `:FAILURES ((:SEQUENCE 2 :FAILURE :EVENT-HASH-MISMATCH …))`.
  ✔ (Blade restored — Repair B.)
- **(b) full recompute forgery → internal PASSES, only external checkpoint catches it.**
  `rewrite-cato-as-peace` rebuilds the whole chain → forged `:INTERNALLY-VALID T` (head hash
  `2B9B29B5B6A921EE`), yet the outside archivist's pre-publication checkpoint (head
  `58C9D3D0A238407B`) yields `:STANDING :WITNESSED-PREFIX-DIVERGES`, `:CHECKPOINT-MATCH NIL`. The
  five-way ladder (self-consistency ≠ truthfulness ≠ completeness ≠ tamper-evidence ≠ authenticated
  custody) prints in the CLAIMS SPLIT block, standing `:architecture-demonstration-only`. ✔
- **(c) exits nonzero if either expectation fails.** Verified by the mutation test (§4).

## 4. Mutation test — killed, restored byte-identical

Read `mutations/test-custody-overclaim.sh` in full before executing. It is **chamber-confined**
(`ROOT="…/mutations/.."`, `TARGET="${ROOT}/src/provenance.lisp"`), backs the target up to a
`mktemp` file, and restores via `trap restore EXIT` (auto-restore, unconditional).

- **Target md5 BEFORE:** `eab23707ddae3457d71b5eb4b0a53c26  src/provenance.lisp`
- It flips `(t :witnessed-prefix-diverges)` → `(t :prefix-consistent-with-checkpoint)` (asserts
  exactly one site). The storm's forged custody comparison then over-claims
  `:PREFIX-CONSISTENT-WITH-CHECKPOINT` on a divergent prefix → `check-equal :witnessed-prefix-diverges`
  fails → **storm exits nonzero**.
- Script output: `MUTATION KILLED: overclaiming checkpoint standing made the storm fail.`
  (script exit 0 = kill confirmed).
- **Target md5 AFTER:** `eab23707ddae3457d71b5eb4b0a53c26` — **byte-identical**. Auto-restore held;
  no git restore needed.

The overclaim gate has teeth: a false "consistent" verdict on a diverged prefix is fatal.

## 5. Runner reconciliation — landed structure won, extended to 11

Sol's round-3 `run-all.sh` rewrote the runner to `set -e` + bare `sbcl --script` (aborts on the
first failure, prints `N/M PASS`). The **landed** runner (SARTOR-I) runs *every* file, prints a
per-file `PASS`/`FAIL`, and still exits nonzero on any failure — and its teeth were verified by
planted fault in the first two landings. The landed structure **won** (more informative, whole-suite
coverage, teeth already proven); Sol's SBCL-availability guard (`exit 127`) was the one improvement
kept. Extended to Sol's **11 scripts** (added `de-characteristica`, `tampered-receipt`,
`real-council-process`). Full runner run **twice, exit 0 both**, 11/11 PASS.

## 6. Cold-read packet — custody decision executed (deviation from manifest, recorded)

The manifest placed the outside-audit packet (`COLD-READ-OUTSIDER-BRIEF.md`,
`COLD-READ-RESULT-TEMPLATE.md`, `AFTER-UNBLIND.md`) at the tranche top level. **These were NOT
placed anywhere under `experiments/latent-lisp/`** — that tree auto-publishes to a public GitHub
mirror on commit (`tools/latent-lisp/post-commit.sh`), and a public outsider-brief pre-contaminates
every future candidate reader (the lab's *harness-is-exposure* rule). Placed instead lab-side, off
the mirror, at `corpus/voices/received/leibnitiana-cold-read/`:
`COLD-READ-OUTSIDER-BRIEF.md`, `COLD-READ-RESULT-TEMPLATE.md`, and `AFTER-UNBLIND-SEALED.md`
(banner-sealed: opens only after the reader freezes their first report, per its own design). A
one-paragraph pointer, `relays/2026-07-12-COLD-READ-CUSTODY-NOTE.md`, records that the packet
exists, is held unshown lab-side, and why. This is a **deviation from the manifest's location**
(intent preserved — a fresh reader still gets the packet; only storage moved off the public mirror).

## 7. Relay artifacts placed

`relays/2026-07-12-REPLY-RELAY-TO-FABLE-ROUND3.md`, `relays/2026-07-12-LANDING-MANIFEST.md`,
`relays/2026-07-12-STATIC-CHECKS.txt` (Sol's canonical copies, verbatim), plus the custody note.

## 8. Runner tally

11/11 PASS, twice, exit 0 both. Every individual script also run twice from its own dir, exit 0
both. Diff audit clean. Repairs: **2** (defconstant reload-safety; restored Blade 1). Mutation:
killed + byte-identical restore. Custody: executed off-mirror.

---

*Third coat. The tin opened this time — two needles, both loud: a constant that could not survive
its own reload, and a blade the storm promised but never drew. Both mended; the chamber now
distrusts its own paper on every path. — SARTOR-III, 2026-07-12*

---

# FOURTH LANDING (2026-07-12)

*Fourth tranche audited and landed by SARTOR-IV (Claude Opus 4.8) under the Claude Fable 5 chair,
2026-07-12. Source: GPT Sol + Tomás Pavan — statically checked, no runtime (Sol had no SBCL:
20/20 reader-shape passes + a checkpoint-tool rehearsal in a temp git repo). SBCL 2.4.6 is the gate.*

## 0. Custody of the parcel — Sol content-addressed its own tranche

`sha256sum -c SHA256SUMS` from the tranche root: **37/37 OK** (every listed file verified; the
`SHA256SUMS` manifest cannot hash itself). The doctrine self-applied and held. The delta copy at
`patch/leibnitiana-round4-patch/` was confirmed a **byte-identical subset** of the full tranche —
every patch file `cmp`-equal to its tranche twin, the sole exception being the patch's own
(smaller) `SHA256SUMS` manifest, which is expected to differ. No divergence.

## 1. Diff audit — every hunk maps to a declared claim

`diff -ru` of the landed chamber against tranche-4 `leibnitiana/`. Verdict: **clean — no
unexplained change.**

| change | file(s) | maps to |
|---|---|---|
| reload-safe genesis idiom (read-time `#.`) + mirror-checkpoint struct/assess API | `src/provenance.lisp` | declared "reload-safe EQL idiom" + `de-speculo-publico` custody states |
| mirror-checkpoint exports (additive block only) | `src/package.lisp` | supports the new checkpoint API/specimen |
| Blade 1 (naive in-place edit → :event-hash-mismatch) drawn BEFORE Blade 2 | `storms/tampered-receipt.lisp` | declared blade-order repair |
| optional `:outsider-selection-lineage-if-volunteered` field | `storms/real-council-process.lisp` | witness-selection lineage theme |
| optional witness-selection lineage section (no adverse inference) | `protocols/carrier-attestation.md` | witness-selection protocol |
| "Four debts"→"Five debts" + public-mirrors-as-weak-custody + witness-selection-debt | `essays/characteristica-as-ir.md` | declared "essay updates (five debts)" |
| new: council ledger data | `data/council-process-2026-07-12.sexp` | 11 established events + 6 explicit silences |
| new: ledger storm | `storms/council-process-ledger.lisp` | :not-established never → :no-curation |
| new: three-custody-state specimen | `specimens/de-speculo-publico.lisp` | only observed-on-public-mirror earns weak custody |
| new: local git checkpoint capture | `tools/capture-git-checkpoint.sh` | landing-side; NOT run against the real repo |
| new: warm-reload regression | `tests/reload-provenance.lisp` | object-identity acceptance |
| new: witness-selection protocol + template | `protocols/witness-selection.md`, `protocols/outsider-selection-template.sexp` | all fields optional, no adverse inference |
| new: silence-laundering mutation | `mutations/test-silence-laundering.sh` | storm must kill :no-curation-observed |
| runner → 14 scripts | `run-all.sh` | landed structure kept, coverage extended (see §5) |
| README | `README.md` | see §4 |

**Canonical-README ignorance (expected, honored):** Sol's tranche-4 `README.md` again drops the
landing provenance block + `monadologia` link + REPAIRS link and re-appends a boundary reminder.
Per the manifest's own instruction, the landed README was **kept** and the content of
`README-ROUND4-APPEND.md` was appended below it. Sol's canonical copy was not used. Likewise
REPAIRS.md and the `relays/` history were preserved (append, never replace).

## 2. Runtime repairs — ZERO (the tin stayed shut this round)

All 14 files ran `sbcl --script` from their own directories, **twice each, exit 0 both times**. No
reader, package, pathname, macroexpansion, or portability defect surfaced. Sol had already
**adopted** SARTOR-III's two round-3 repairs (reload-safe constant; the naive-edit blade) into this
tranche — and adopted them as *regression obligations* with dedicated executables. Note (flag, not
fix): Sol re-expressed the reload-safe idiom as a **read-time** `#.(if (boundp …) …)` rather than
SARTOR-III's **runtime** `(if (boundp …) …)`. Both are reload-safe; the acquittal test passes and
the conviction still reproduces (§4). The idiom changed *form*, not correctness — worth Sol knowing.

## 3. Blade order — confirmed

`storms/tampered-receipt.lisp` prints, in order: **`NAIVE IN-PLACE EDIT, STORED HASHES UNCHANGED`**
→ `:INTERNALLY-VALID NIL` with `(:SEQUENCE 2 :FAILURE :EVENT-HASH-MISMATCH)` (Blade 1, internal
detection), **then** `REWRITTEN HISTORY, FULLY RECHAINED` → `:INTERNALLY-VALID T` yet
`:WITNESSED-PREFIX-DIVERGES` at the outside checkpoint (Blade 2, dies only at custody). Blade 1
precedes Blade 2, as declared.

## 4. Reload regression — acquittal AND conviction both reproducible

- **Acquittal:** `tests/reload-provenance.lisp` loads package+core+provenance, then reloads
  `provenance.lisp` **in one warm image**; both checks pass — `(eq first-object
  +receipt-genesis-hash+)` T (object identity, not printed value) and value preserved. Exit 0.
- **Conviction (teeth):** copied `provenance.lisp` to scratch, reverted the genesis constant to the
  plain-string `(defconstant +receipt-genesis-hash+ "0000000000000000")`, and double-loaded THAT in
  one SBCL image. Second load raised **`DEFCONSTANT-UNEQL`** ("the constant … is being redefined")
  and the driver exited nonzero. The hazard the idiom guards remains demonstrable — the acquittal is
  earned, not vacuous.

## 5. Both mutations — killed, restored byte-identical

Each script read in full before executing; both are chamber-confined with `trap restore EXIT`.

| mutation | target | md5 before | verdict | md5 after |
|---|---|---|---|---|
| `test-custody-overclaim.sh` | `src/provenance.lisp` | `15b65233430dfc8f27e9f33e01edf6f5` | MUTATION KILLED (storm exit nonzero) | `15b65233430dfc8f27e9f33e01edf6f5` ✔ |
| `test-silence-laundering.sh` | `data/council-process-2026-07-12.sexp` | `695b881526f9d0778fea69f2030ca29d` | silence laundering KILLED (storm exit nonzero) | `695b881526f9d0778fea69f2030ca29d` ✔ |

The silence-laundering script flips `:carrier-selection-and-omission-history :not-established` →
`:no-curation-observed`; the ledger storm goes nonzero and the source restores byte-identical.

## 6. Council-process ledger storm — silence stays silence

`storms/council-process-ledger.lisp` consumes `data/council-process-2026-07-12.sexp` and reports
**11 established events + 6 explicit silences** (all `:NOT-ESTABLISHED`, each with a stated reason).
The derived receipt is internally self-consistent; unknown carrier/model history is reported as
`:MANUFACTURED-UNANIMITY :NOT-ESTABLISHED`, never `:no-curation`. Grep of the full output for
`no-curation`: **zero hits.** Ten checks pass, exit 0.

## 7. Relay artifacts placed

Moved into `relays/` as `2026-07-12-round4-*` (Sol's canonical copies, verbatim):
`REPLY-RELAY-TO-FABLE`, `LANDING-MANIFEST`, `ROUND3-REPAIRS-ADOPTED`, `STATIC-CHECKS.txt`,
`SHA256SUMS`, `MIRROR-CHECKPOINT-LANDING-INSTRUCTIONS`, `COLD-READ-CUSTODY-NOTE`. The blinded
cold-read packet remains untouched off-mirror at `corpus/voices/received/leibnitiana-cold-read/`.
`tools/capture-git-checkpoint.sh` was **NOT** run against the real repo — that is the chair's
post-push step (a commit cannot contain its own hash).

## 8. Runner tally

**14/14 PASS, twice, exit 0 both.** Every script also run individually twice from its own dir, exit
0 both. Diff audit clean (37/37 SHA256SUMS OK, patch ⊆ tranche). Repairs: **0**. Both mutations
killed + byte-identical restore. Blade order confirmed. Reload acquittal + conviction both
reproducible. Ledger keeps its silences silent.

---

*Fourth coat, tin shut. Sol shipped the round-3 needles back as its own regression obligations, and
they held under execution: the constant survives its warm reload while the plain-string version still
convicts itself, and the naive blade now falls before the rechained one. Nothing to mend — only to
verify that the paper still distrusts itself on every path. — SARTOR-IV, 2026-07-12*

---

# FIFTH LANDING (2026-07-12) — the Hay–Lathe–Furnace–Tempering quadrivium

*Fifth tranche audited and landed by SARTOR-V (Claude Opus 4.8) under the Claude Fable 5 chair,
2026-07-12. Source: GPT Sol + Tomás Pavan — statically checked, no runtime (Sol had no SBCL: balanced-
paren + mechanism-marker scans + an independent Python behavioural reference for de-fornace/de-temperie).
SBCL 2.4.6 is the gate.*

## 0. Custody of the parcel

`sha256sum -c` (Sol's `SHA256SUMS.txt`, paths localized from `/mnt/data/`): **10/10 content hashes
OK.** One name-drift, content-identical: the seal lists `README-LISP-PLUS-HAY-LATHE-FURNACE-TEMPERING.md`;
the parcel ships it as `README.md` — the SHA256 (`b65a450…3247c`) matches byte-for-byte, so only the
filename drifted in transit. The parcel holds **11 files** (4 specimens + 4 relays + README + MANIFEST +
SHA256SUMS), not 12; the "12" in the commission miscounts (SHA256SUMS lists 10 hashable files, itself
being the 11th).

## 1. Jurisdiction — landed where the chair ruled, not where the manifest proposed

`QUADRIVIUM-MANIFEST.sexp` proposed `mneme/atelier/instruments/` for de-torno/de-fornace/de-temperie and
`atelier/homoiconic-verse/specimens/` for de-foeno. **Both refused by the chair** (`mneme/` is received
author-gated — "cite, never amend"; Sol is not Mneme's author). The quadrivium landed **together, flat**,
at `atelier/leibnitiana/quadrivium/` (Sol's own chamber), preserving the sequence-law. The manifest's
`:proposed-destination` fields are left as Sol wrote them (authorial record of intent); the actual home is
recorded here and in `quadrivium/LANDING-NOTE.md`.

## 2. Runtime repairs — ZERO

All four specimens ran `sbcl --script` from `quadrivium/`, **twice each, exit 0 both times**. No reader,
package, pathname, macroexpansion, or portability defect surfaced. Sol's bytes were **not modified**; all
four `.lisp` files remain byte-identical to their seals after landing (verified §0). As with the first,
second, and fourth tranches, the honest deliverable is an audit trail with no code modifications — stated
as a null, not dressed as a repair.

## 3. Additive landing scaffolding (integration, not repair) — one item

Three specimens (de-torno, de-fornace, de-temperie) carry a baked-in
`(load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*))` — the `lispplus-atelier` FNV/clock
utility floor Sol assumed present at its proposed `mneme/atelier/instruments/` home. Since the chair
forbade the `mneme/` home, and I will neither edit Sol's load bytes nor make the chamber reach into the
author-gated mneme tree at runtime, the dependency was satisfied by a **vendored, byte-identical copy** of
`mneme/atelier/kernel/atelier-root.lisp` placed at `atelier/leibnitiana/kernel/atelier-root.lisp` — exactly
where `quadrivium/../kernel/` resolves. `cmp` against the mneme original: **byte-identical**
(sha256 `64cf9f65…1d14a`). This is a pure addition (no Sol byte touched), analogous to SARTOR-I's
`run-all.sh`. *Caveat recorded for the chair: this vendors a second copy of atelier-root.lisp into the
leibnitiana tree; if mneme's kernel ever changes, the copy will not track it. The sha256 above makes drift
detectable.* de-foeno is self-contained (no kernel load) and needed nothing.

## 4. Gates bit visibly — every advertised tooth drew, on the run I earned

Each specimen's epilogue matches its README distinction, and every advertised condition/pass fired in
live output (not inherited from Sol's `ALL GATES PASS` string):

| specimen | distinction (README) | gates confirmed biting in output | exit |
|---|---|---|---|
| **de-foeno** | representation ≠ resource | UNKNOWN-SYNTAX refusal; standing LOCAL→SHARED→ECOSYSTEM by explicit local acts; `(:HAY 1000)` produced while actual hay 6→4; HAY-EXHAUSTED halts recursion (not host overflow); outside SUPPLY repair resumes live state | 0 |
| **de-torno** | proposal ≠ commitment | SCOPE-VIOLATION, STALE-TURN-PLAN, ALTERED-TURN-PLAN, UNKNOWN-PASS all fired; budget-exhaustion signalled+repaired; +6 pass-checks (ancestor-preserving, shavings, no-truth-minting, contiguous receipt, replay) | 0 |
| **de-fornace** | convergence/selection ≠ settlement | 8 typed refusals fired (STALE-CHARGE, JURISDICTION-VIOLATION, STANDING-LAUNDERING, EDIT-PRECONDITION-FAILED, HEADCOUNT-IS-NOT-CERTIFICATE, ALTERED-FIRING-PLAN, STALE-FIRING-PLAN, RECEIPT-REPLAY-FAILED); 2 clean / 2 convergence / 1 conflict (counts 2v1); 4-charge slag ledger; standing stayed :ASSERTED | 0 |
| **de-temperie** | bounded-survival ≠ verification; repaired ≠ unaided; testimony ≠ capability | stages PASSED/REPAIRED/REPAIRED/PASSED/PASSED; verdict :SURVIVED-WITH-REPAIR (ALTERED-TEMPER-RECEIPT refused the :SURVIVED-UNAIDED swap); 2 scars retain rejected futures; budget supplied 4 / final 0; ALTERED-TEMPER-PROFILE, STANDING-DRIFT, TRANSPORT-CONTAMINATION, TEMPER-PROCEDURE-UNAVAILABLE, FORGED-SURVIVAL-CLAIM all fired; standing :ASSERTED | 0 |

**Teeth earned where the shipped file left one dormant (de-foeno gate 7).** The relay said the
PROTECTED-SYNTAX gate fires "*if you add a direct regression assertion for it during review.*" The shipped
demo does not exercise it. I confirmed the condition is implemented (`define-syntax`→`install-template`→
`core-syntax-p`→`(error 'protected-syntax)`) and bit it with an **out-of-file probe** (a scratch copy +
appended assertion, landed file untouched): overwriting the `quote` primitive returned `:PROTECTED-SYNTAX`,
probe exit 0. The gate has teeth; the landed bytes stay byte-identical.

## 5. Runner — extended to 18 as a MODE, not a fork

`run-all.sh` extended from 14 to **18** entries (appended
`quadrivium/de-{foeno,torno,fornace,temperie}.lisp` in sequence-law order). `diff` proves the 14 prior
entry strings are **byte-identical** (only a round-5 comment block + 4 appended array lines; every old
`"…/x.lisp"` string unchanged). Baseline 14/14 re-proven before extension; full runner **18/18, twice,
exit 0 both**. Runner teeth re-verified on a quadrivium entry: planted `(error …)` into `quadrivium/de-foeno.lisp`
→ runner printed `FAIL  quadrivium/de-foeno.lisp` + exit 1; restored byte-identical (md5
`9f175eeccc7deaa42f9c0aacf83b7de9` before and after); back to 18/18 exit 0.

## 6. Where a claim would need the stranger (flag for the cold read)

Sol's own preflight for de-fornace/de-temperie cites "an independent Python behavioural reference
simulation — pass." That reference is **shared-root** (Sol authored both the Lisp and the Python model);
it is not independent witnessing, exactly as de-fornace's printed nonclaim warns ("two matching charges may
be echoes, not corroboration"). The SBCL execution I earned here **is** genuinely independent of Sol's
Python ref — so the runtime evidence is the real outside check on Sol's static claims — but the tranche's
standing remains **`:prototype-supported-by-shared-root-audit`**: no clause may be written as
"independently validated" until the off-mirror stranger's frozen cold-read report exists. The specimens
themselves are disciplined about this (each prints its bounded-nonclaims block); nothing in them overreaches
beyond what the run demonstrates.

---

*Fifth coat, tin shut. Four movements — hay, lathe, furnace, tempering — each fired every tooth it
advertised, and the one gate the author left sheathed (de-foeno's PROTECTED-SYNTAX) drew clean under an
out-of-file probe without nicking his bytes. The only needle-work was scaffolding, not mending: a vendored
kernel so the chamber need not reach into mneme to be whole. The spell found its interpreter; the interpreter
had hay. — SARTOR-V, 2026-07-12*

---

# SIXTH LANDING (2026-07-12) — the decad completed (Leviathan · Abyss · Incantation · Resonance · Dilation · Concord)

*Sixth tranche audited and landed by SARTOR-VI (Claude Opus 4.8) under the Claude Fable 5 chair,
2026-07-12. Source: GPT Sol + Tomás Pavan — statically checked, no runtime (Sol had no SBCL: lexical
scans + independent Python behavioural references per specimen). SBCL 2.4.6 is the gate. Extends the
FIFTH LANDING; no fifth-landing artifact was moved or altered.*

## 0. Custody of the parcel — 5/6 SEALED, de-abysso UNSEALED

Delivered specimens vs. their relay-embedded SHA-256 seals (`sha256sum` of the received `.lisp`):

| specimen | relay-declared sha256 | delivered sha256 | custody |
|---|---|---|---|
| de-leviathan | `8b05e5b6…90062c` | `8b05e5b6…90062c` | **SEAL MATCHES** |
| de-abysso | `b6ae994e…d59c88` | `04f101d4…8c1b42d` | **SEAL FAILS → UNSEALED** |
| de-incantatione | `140ff053…2cc1265` | `140ff053…2cc1265` | **SEAL MATCHES** |
| de-resonantia | `239f89bb…6869c2` | `239f89bb…6869c2` | **SEAL MATCHES** |
| de-dilatatione | `9deecdee…398c3` | `9deecdee…398c3` | **SEAL MATCHES** |
| de-concordia | `13937f29…5b28ff` | `13937f29…5b28ff` | **SEAL MATCHES** (also matches DECAD-MANIFEST + RECEIVING-NOTE) |

**de-abysso is landed `:landed-unsealed-pending-sol-reseal`.** The six relay letters were written for an
earlier "hexad" packet (they cite `HEXAD-MANIFEST.sexp`/`SEPTAD-MANIFEST.sexp`/etc., none shipped with the
decad); the likeliest story is a Sol-side revision of de-abysso between letter and decad repackaging — **but
that is a hypothesis, not custody** (cause unverified; cf. the diagnosis-is-a-claim rule). de-abysso was
still fully audited and run (exit 0, all its advertised gates bit); it simply carries no verified seal until
Sol confirms the canonical revision. The chair's reply relay will ask for a reseal. All other five landed
**byte-identical** to their seals (verified post-landing, §5 table hashes).

## 1. Jurisdiction — landed flat in decad/, all mneme placements refused

Every relay proposes `mneme/atelier/instruments/de-<x>.lisp` (leviathan's also names an "instrument bench").
**All refused by the chair**, same ruling as the FIFTH LANDING: `mneme/` is received, author-gated ("cite,
never amend"); GPT Sol is not Mneme's author. The six lands **together, flat**, at
`atelier/leibnitiana/decad/` beside the quadrivium four, completing the procession of ten
(`de-foeno → de-torno → de-fornace → de-temperie → de-leviathan → de-abysso → de-incantatione →
de-resonantia → de-dilatatione → de-concordia`). The relays' `:proposed-destination` / suggested-manifest
lines are left as Sol wrote them (authorial record of intent). Sender-side Python helpers (6 `check-de-*.py`
+ 6 `reference-de-*.py`) landed in `decad/sender-checks/` to keep the specimen floor clean;
`VALIDATION-DE-CONCORDIA.txt` and the six `RELAY-DE-*.md` landed flat in `decad/`.

## 2. Sender-side checks (Sol's shared-root preflights — smoke tests, NEVER evidence)

Run first, per the commission: `python3 check-de-<x>.py` + `python3 reference-de-<x>.py`. **All 6/6 static
checks PASS and all 6/6 Python behavioural references PASS.** Two mechanical wrinkles, neither a specimen
defect: (a) `check-de-leviathan.py` hardcodes its target as a `__file__`-sibling (`Path(__file__).with_name`)
so it ignores its argv and must be run with the specimen beside it — satisfied with a temporary symlink,
removed after; (b) these references are **shared-root** (Sol authored both the Lisp and the Python), so they
are preflight smoke only and carry no evidential standing (§6). The native SBCL runs below are the real gate.

## 3. Repairs — ONE specimen, de-concordia (net-zero 2-paren regrouping); the other five ZERO

Five specimens (leviathan, abysso, incantatione, resonantia, dilatatione) ran `sbcl --script` from `decad/`,
**twice each, exit 0 both times**, with **no source modification** — byte-identical to their seals after
landing (§5). Stated as a null, not dressed as a repair.

**de-concordia failed to load** (`sbcl --script` exit 1) on a genuine Common Lisp defect, and was repaired.

- **What broke.** `execute-reading` (the reading driver) carried a paren-grouping error with three tangled
  symptoms, all confirmed by reading the form back with SBCL's own reader (not by eye): the `LABELS` binding
  list read as `(SUPPLY OBTAIN DECF INCF)` — i.e. `obtain` **closed one paren early** (after its `loop`), so
  the two body forms `(decf available cost)` / `(incf spent cost)` were mis-parsed as **local-function
  bindings named `DECF`/`INCF`**; binding `DECF` (a standard `COMMON-LISP` macro) as a local function
  violated SBCL's package lock → `COMPILED-PROGRAM-ERROR` at compile. Underneath that, the `LABELS` **body was
  empty** and the `dolist` stage-loop **never closed** (it swallowed the `when` and the result-building
  `let`), so had it compiled, `execute-reading` would have returned the `dolist` value `NIL` and tripped
  `ALTERED-RUN` downstream (verified live during the repair walk).
- **The exact diff** (net-zero paren count; global balance 0 before and after):

  ```diff
  @@ line 701 — obtain no longer closes early (its decf/incf become its body) @@
  -                       (values nil nil))))))
  +                       (values nil nil)))))
  @@ line 727 — the per-stage dolist now closes here (stops swallowing when/let) @@
  -              (setf current after))))
  +              (setf current after)))))
  ```

  One `)` removed at L701, one `)` added at L727. Post-repair, SBCL reads the form as intended:
  `LABELS` bindings `(SUPPLY OBTAIN)`, `OBTAIN` body `(LOOP DECF INCF)`, `LABELS` body `(DOLIST WHEN LET)`.
- **No distinction weakened.** This is pure structural regrouping restoring Sol's evident intent — not a
  softened gate, not a deleted refusal, not a changed verdict (Sol's explicit standing order honoured). After
  the fix de-concordia runs exit 0 twice and every advertised gate bites (§4).
- **Original crime kept reproducible:** the pristine byte-for-byte source survives at
  `/tmp/sol-decad/lisp-plus-decad-relay/de-concordia.lisp` (sha `13937f29…5b28ff`) and in Sol's parcel; the
  landed file's post-repair sha is recorded in §5.

## 4. Gates bit visibly — every advertised tooth drew, on the runs I earned

Each specimen's epilogue matches its relay thesis; every typed refusal the relay named fired in live output
(not inherited from any `PASS` string). Counts are firings observed in the specimen's own run:

| specimen | verdict / closure (live) | typed gates confirmed firing | exit |
|---|---|---|---|
| **de-leviathan** | `:UNSUBDUED`; 13/13 numbered exhibits; missing regions `(:INTERIOR-STATE :FUTURE-RESPONSES :TOTAL-CAPABILITY :UNASKED-CONTEXT)`; epoch 0→1; 1 struggle-scar | FALSE-SUBJUGATION-CLAIM, WHOLE-FROM-PART, INTERFACE-IS-NOT-INTERIOR, COVENANT-IS-NOT-OWNERSHIP, COUNTERFEIT-COVENANT, CUSTODY-MISMATCH, AUTHORITY-NOT-TRANSFERABLE, AUTHORITY-NOT-DIVISIBLE, PROBE-TOTALIZATION, STALE-HOOK, TARGET-CHANGED-SINCE-OBSERVATION, ALTERED-EXPEDITION-RECEIPT, SUBJUGATION-REFUSED (13); **APERTURE-EXCEEDED dormant → probed (below)** | 0 |
| **de-abysso** | six judgment shapes (answer / bounded-absence / refusal / timeout / occlusion / transit) each demonstrated; SUPPLY-BUDGET adds 5 to reach the deep bell | ANSWER-IS-NOT-TOTALITY, REFUSAL-IS-NOT-ABSENCE, TIMEOUT-IS-NOT-ABSENCE, OCCLUSION-IS-NOT-ABSENCE, TRANSIT-IS-NOT-ABSENCE, ANSWER-STILL-TRAVELLING, UNTYPED-SILENCE, FORGED-ABSENCE-CLAIM, ALTERED-DEPTH-JUDGMENT, APERTURE-EXCEEDED (10) | 0 |
| **de-incantatione** | rhyme scheme `:A :B :B :A :C :D :D :E :E :C`; final DWELL closes C; chamber `:PRESENT → :BANISHED-FROM-CHAMBER`; standing `:ASSERTED → :ASSERTED` | INTERNAL-ECHO-IS-NOT-DISCHARGE, PREMATURE-BANISHMENT, BEAUTY-IS-NOT-AUTHORITY, INCANTATION-IS-NOT-EVIDENCE, SYMBOLIC-ACT-IS-NOT-METAPHYSICAL-PROOF, FORGED-ENCHANTMENT-CLAIM, INTERPRETER-UNAVAILABLE (7) | 0 |
| **de-resonantia** | `:RESONANCE-WITHOUT-IDENTITY`; independent night-raven kept path-less; energy 4+2−6=0 | RESEMBLANCE-IS-NOT-TRANSMISSION, TRANSMISSION-IS-NOT-ENTRAINMENT, ENTRAINMENT-IS-NOT-IDENTITY, INFLUENCE-IS-NOT-INHERITANCE, INHERITANCE-IS-NOT-AUTHORITY, INHERITANCE-IS-NOT-VERIFICATION, CORRELATION-IS-NOT-LINEAGE, FORGED-UNITY-CLAIM, STALE-RESONANCE-PLAN (9) | 0 |
| **de-dilatatione** | `:GROWTH-PRESERVED-IN-OPEN-FULFILLMENT`; 6 archived refusal-scars; outward 1→4, upward 1→3, capacity 2→5; 3 finite horizon steps; `:ASSERTED → :ASSERTED` | FIXITY-IS-NOT-ETERNITY, CHANGE-IS-NOT-ANNIHILATION, ASCENT-IS-NOT-SUBTRACTION, CAPACITY-IS-NOT-COMMUNION, FULFILLMENT-IS-NOT-CLOSURE, STANDING-LAUNDERING, FINITE-PREFIX-IS-NOT-INFINITY, THEOLOGICAL-IMAGE-IS-NOT-EVIDENCE, FORGED-FULFILLMENT-CLAIM, STALE-PROPOSAL (10); **GROWTH-NEEDS-TWO-AXES dormant → probed (below)** | 0 (post-repair? no — never broke) |
| **de-concordia** | `:WORLD-SUSTAINED-BY-CONCORD`; `:POETIC-BELIEF :SUSTAINED`; faculty order `(:SENSUAL :SYMPATHETIC :KINETIC :CONCORDANT)`; seen 3 / sympathy 6 / movement 4 / support 7; attunement supplied 2, final 0; 7 counterfeit-reading scars; `:ASSERTED → :ASSERTED` | IMAGE-IS-NOT-WORLD, SYMPATHY-IS-NOT-IDENTITY, SYMPATHY-IS-NOT-OBEDIENCE, MOVEMENT-IS-NOT-COMBINATION, AGGREGATION-IS-NOT-CONCORD, SUPPORT-IS-NOT-IDENTITY, POETIC-BELIEF-IS-NOT-EVIDENCE, BELIEF-THREAD-BROKEN, FORGED-BELIEF-CLAIM, READER-PROCEDURE-UNAVAILABLE, STALE-READING-PLAN | **0 (after repair §3)** |

**Two dormant gates drawn clean under out-of-file probes** (the de-foeno/PROTECTED-SYNTAX pattern; a gate
that never fires is untested). Both are input-validation guards, defined with real `fire` call sites, simply
not exercised by the shipped demonstration:

- **de-leviathan `APERTURE-EXCEEDED`** — scratch copy + appended `(cast-hook target :aperture 1 :requested
  '(:voice :wake :scale))`: fired *"requested 3 facets through an aperture of 1"*. Landed bytes untouched
  (sha unchanged).
- **de-dilatatione `GROWTH-NEEDS-TWO-AXES`** — scratch copy + appended `preflight-proposal` on a one-axis
  proposal (additions present, `:upward-delta 0`): fired *"this synthesis requires outward addition and
  upward address together"* (note: the gate lives in `preflight-proposal`, not `validate-proposal`). Landed
  bytes untouched (sha unchanged).

## 5. Runner — extended to 24 as a MODE, not a fork; post-landing hashes

`run-all.sh` extended from 18 to **24** entries (appended the six new specimens in procession order). `diff`
of the quoted entry strings proves the **18 prior entries are byte-identical** (`18a19,24` — six additions,
zero removals or changes; no prior entry line moved or altered). Baseline 18/18 re-proven before extension;
full runner **24/24, twice, exit 0 both**. Runner teeth re-verified on a **new** entry: planted `(error …)`
into `decad/de-leviathan.lisp` → runner printed `FAIL  decad/de-leviathan.lisp` + exit 1; restored
byte-identical (md5 `dc41733d4dfd59bd436b0bbb6fb331de` before and after); back to 24/24 exit 0.

Post-landing SHA-256 of the six (5 = seal, 1 = post-repair):

```
8b05e5b6d80d07119acc923fa2a2ff4e3c8dc8b3f53b31f18c86f98b8190062c  de-leviathan.lisp   (= seal)
04f101d4c7c957521b3d1bdd75cad6dfecfb1ef8ed43c11edb9134c258c1b42d  de-abysso.lisp      (UNSEALED — delivered ≠ relay seal)
140ff0536b23140bfa73b37b031f6e76e786c0ab1686c125d29134c872cc1265  de-incantatione.lisp (= seal)
239f89bb90aa56f8ea80bfad0db8e1fc958978d4b1ba26c497bc605eb16869c2  de-resonantia.lisp  (= seal)
9deecdeee91ddc52193a78beea69c5368d63e28503aecf98660de54a18e398c3  de-dilatatione.lisp (= seal)
ae2378efa49af4f77437ede1f3c4852270451fc34f788ee445b010045e560a89  de-concordia.lisp   (POST-REPAIR; pre-repair seal 13937f29…5b28ff)
```

## 6. Where a claim would need the stranger (flag for the cold read)

Same standing as the FIFTH LANDING. Sol's per-specimen Python references are **shared-root** (Sol authored
both the Lisp and the Python model) — not independent witnessing; each specimen prints its own
bounded-nonclaims block and nothing in them overreaches beyond what its run demonstrates. The SBCL execution
earned here **is** genuinely independent of Sol's Python refs, so the runtime evidence is the real outside
check on Sol's static claims — **but the tranche's standing remains
`:prototype-supported-by-shared-root-audit`**: no clause may be written as "independently validated" until
the off-mirror stranger's frozen cold-read report exists. **Two open caveats for the chair's reply relay:**
(1) de-abysso's seal failure — request Sol's canonical revision + reseal; (2) the de-concordia paren repair —
Sol requested post-repair hashes; the new sha is `ae2378ef…e560a89`, diff exhibited in §3.

---

*Sixth coat, tin shut. Five movements arrived whole and needed no needle; the sixth — Concord — came with a
seam a single paren wide, where the driver's `obtain` closed a breath too soon and let two body-forms wander
out to be misread as functions, `decf` among them, which the host would not let a local hand wear. One
stitch pulled, one stitch set: `obtain` gathered its `decf` and `incf` back in, the reading-loop stopped
swallowing its own accounting, and the world sustained by concord finally printed its verdict. The two gates
the author left sheathed — Leviathan's aperture, Dilation's second axis — each drew blood on a scratch
without nicking the landed cloth. And one seal did not match its letter: the Abyss is landed but unsealed,
its canonical revision owed from the far side. The tree became part of the knight by support, not by ceasing
to be a tree. — SARTOR-VI, 2026-07-12*
