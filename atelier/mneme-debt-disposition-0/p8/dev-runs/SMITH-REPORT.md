# SMITH-REPORT — P8 auditor harness, built to PREREG-P8-DELTA-0

*SMITH (Claude Opus 5, subagent), 2026-09-15. Scratchpad only; nothing was written into the lab checkout.*

## 0. Pins verified before any code was written

| Thing | Value |
|---|---|
| prereg sha256 (recomputed) | `295bab9fc390dc0a1beac5cc85fbb361ed4c0bfe65f7ed7618f04e5bc4f81c98` — **matches** the commission |
| lab HEAD | `8f41eee133555ee47e2d4d3c1eb7a6bb9427b212` — **matches** |
| `HEAD:experiments/latent-lisp` | `e148d8a5344cd0bef88d0a8d5eba77684577d9f3` — matches prereg §0 |
| `…/mneme/memory-layer-0` | `9458616a438fbce1de0433d439b458f83d76fbac` — matches prereg §0 |
| sbcl | SBCL 2.4.6 |
| venue | `$W/venue`, cut by `git archive HEAD:experiments/latent-lisp | tar -x` (from the COMMIT, never the tree) |

**Venue = pinned tree, by blob:** `git hash-object` over all 62 files of the extracted lane dir equals
`git ls-tree -r 9458616a…` entry-for-entry (diff empty). Prereg §8's first VOID condition does not hold.

**mkdtemp finding (hard rule 7).** `ml0-suite-ground.lisp:465-475` — `ml0-fresh-run-root` builds its root from
`(sb-posix:mkdtemp "/tmp/<stem>-XXXXXX")`, **not** `(random …)`, and refuses if the root falls inside
`(truename subject-root)`. Concurrency would therefore have been safe on the run-root axis; **I ran strictly
one `sbcl` process at a time anyway**, because prereg §8 makes concurrency a VOID condition in its own right.

## 1. Files delivered (all under `$W = …/scratchpad/smith/`)

- `harness/p8-case.lisp` — one case per process, `sbcl --script p8-case.lisp <CASE> <lane-dir>`.
- `harness/p8-runner.sh` — `p8-runner.sh <lane-dir> <out-dir>`; sequential, fresh process per case.
- `harness/EXPECTATIONS-P8.txt` — the nine prereg §6 classes, verbatim.
- `harness/original/probe-p8-supplement.ORIGINAL.lisp` (parcel copy) +
  `…-venue-path.lisp` (sed-substituted) + `venue-path-substitution.diff.txt` (**one line changed**: the `load`
  path). The sed lives in the runner, so it is reproducible; if the chair drops its own file at
  `harness/original/probe-p8-supplement-venue-path.lisp` the runner uses that instead of regenerating.
- `dev-runs/` — every run kept, failures included (001 · 002 · 003 · 004 · 005 · 006 · ctl-c1/c2/c3).
- Final recorded run: `dev-runs/006-final-real-run/` (runner stdout, plus `out/` with per-case
  `.out.txt`/`.err.txt`/`.exit.txt`, `SUMMARY.txt`, `VENUE-IDENTITY.txt`, `RUNNER-HEADER.txt`).

**Transcripts are `.txt`.** Every probe run is a fresh `sbcl --script` with stdout, stderr and `EXIT $?` captured.
Cwd for every case is the **venue root** (see §5, divergence D-1). The run root is deleted in an `unwind-protect`,
so it goes on refusal paths too; each case prints `RUN-ROOT-REMOVED: YES` (the auditor's original probe never
reached its own cleanup on any path — every `cond` branch exits first — and its roots do litter `/tmp`).

## 2. The machinery used, with file:line (the "auditor machinery" boundary the chair asked for)

CD/0 **public** record API — `experiments/latent-lisp/canonical-datum/common-lisp/package.lisp` exports;
definitions in `cd0.lisp`. The forged body is built by RE-ENCODING entries; no `rplaca` anywhere:

| Symbol | Definition | Used for |
|---|---|---|
| `record-datum-fields` | `cd0.lisp:948` | walking a record's entries |
| `record-entry-key` / `record-entry-value` | `cd0.lisp:738` / `743` | reading each entry |
| `make-record-entry` | `cd0.lisp:732` | re-encoding each entry |
| `make-record-datum` | `cd0.lisp:932` | the rebuilt record |
| `identifier-datum-path-segment` / `-path-count` | `package.lisp` exports | envelope segment extraction |
| `string-datum-value`, `record-datum-ref`, `render-diagnostic`, `equal-datum` | `package.lisp` exports | reads / diagnosis |

Lane symbols, all reached from inside `lisp-plus-memory-layer0` (`mneme/memory-layer-0/`):

| Symbol | Definition | Status |
|---|---|---|
| `ml0-fresh-run-root` | `ml0-suite-ground.lisp:465` | suite ground |
| `ml0-ground`, `ml0-settled-row`, `ml0-open-authority`, `ml0-world`, `ml0-subject-from-fixture-row`, `ml0-observe-{world,journal,issuance}`, `ml0-self-report-source` | `ml0-suite-ground.lisp` | suite ground (auditor's Phase-B recipe) |
| `ml0-write` | `ml0.lisp:2346` | supported write path |
| `ml0-retrieve` | `ml0.lisp:2178` | **supported read path** (tag R) |
| `ml0-effect-observation-from-record` | `ml0.lisp:1064` (RB-5 at l.1067/1075/1087) | exported accessor (tag D) |
| `ml0-effect-observation-record` | `ml0.lisp:1048` | record for the forgery |
| `ml0-mint-account-identity` | `ml0.lisp:1727` | identity re-mint |
| `ml0-account-envelope` | `ml0.lisp:1750` | envelope (tag J/W) |
| `%ml0-dry-decode` | `ml0.lisp:2548` | **lane-internal** pre-append gate (tag W) |
| `ml0-list-account-ids` | `ml0.lisp:2218` | STORE-BEFORE/AFTER |
| `ml0-account-hex-of-event` | `ml0.lisp:1926` | locating the lawful frame |
| `record-field`, `identifier-segment-string`, `sha256-hex`, `append-event`, `validate-journal`, `prefix-report-*`, `journal-store-directory` | imported from `lisp-plus-journal0`, `package.lisp:80-105` | — |
| `idf`, `s-datum`, `rec`, `entry`, `same-datum-p` | `ml0.lisp:98,116,118,120,127` | lane-internal helpers |
| `append-receipt-disposition`, `pj0-condition-{detail,requirement-id}` | `journal0/package.lisp:124, 24, 26` | dispositions / journal refusals |

`EVENTS.pj0` is located as `(merge-pathnames "EVENTS.pj0" (journal-store-directory *ml0-account-store*))`.

## 3. Final per-case table — from the LAST dev run, `dev-runs/006-final-real-run/`

Lawful account hex `1b6345aa050e20c18b5f6f00a68629e1538fb8ad097d188e386dd775562b0504`;
forged-body hex `49332c1d565f20098065f1e87a27e47021a36ddf2b9414e055ef47a42a5fc9dc`;
E-R's deliberately wrong hex `7a00e8d7cebe87ca06fbd70f8e885bbf23d82058c5a5a8a0b4eb5bef203c19b4`
(= sha256 of the string `not-the-body`).

| Case | class observed | expected | frames | disposition | detail excerpt |
|---|---|---|---|---|---|
| V-R | `DECODED provenance=CALLER-ASSERTED` | same | 1→1 | — | — |
| V-D | `DECODED provenance=CALLER-ASSERTED` | same | 1→1 | — | — |
| V-J | `DECODED provenance=CALLER-ASSERTED` | same | 1→1 | `:ALREADY-COMMITTED-IDENTICAL` | rebuilt body AND envelope `equal-datum` T; rebuilt hex = lawful hex |
| F-D | `REFUSED ML0-RB-5 provenance-reads` | same | 1→1 | — | *"the effect observation's provenance reads \"observed\"; this slice mints exactly one value…"* |
| F-R | `REFUSED ML0-RB-5 provenance-reads` | same | 1→**2** | `:NEWLY-COMMITTED` | same RB-5 detail, via `ml0-retrieve` on the forged hex |
| F-W | `REFUSED ML0-WR-8 other` | same | 1→1 | *(no append)* | *"dry decode: the exact account decoder refuses this frame (ML0-ACCOUNT-READBACK-REFUSED [**ML0-RB-5**]) — refused BEFORE any durable mutation"* |
| E-J | `JOURNAL-REFUSED pj0-event-identity-collision PJ-APP-3` | same | 1→1 | *(refused)* | *"event identity ml0-event:w-1b6345aa… is committed with a different payload at ordinal 1"* |
| E-R | `REFUSED ML0-RB-11 other` | same | 1→**2** | `:NEWLY-COMMITTED` | *"the frame's event-id names account 7a00e8d7… but the body digests to 49332c1d… — the identity and the content disagree"* |
| E-L | *(no RESULT-CLASS line)* → `LOAD-ERROR` | `LOAD-ERROR` | — | — | `READ error during LOAD: Symbol "RECORD-FIELD" not found in the LISP-PLUS-CD0 package. Line: 41, Column: 36` |

`P8-RUNNER: pass=8 fail=0 blocked=1`, runner exit **0**. Every case process exited 0 except E-L (exit 1).
Secondary checks all held: V-J disposition and unchanged frames; F-R/E-R +1; E-J/F-W unchanged; F-W's DETAIL names ML0-RB-5.

**E-L cross-check worth recording:** the substituted original *does* execute its Phase-B fixture before dying —
it prints `account written: "1b6345aa…"`, the **same** lawful hex my harness produces — and then hits the reader
error at its line 41. Sol II's TERMINAL sentence is reproduced exactly: it never reached the ML/0 decoder.

## 4. The three §7 controls — decisive lines (`dev-runs/ctl-c1`, `ctl-c2`, `ctl-c3`)

- **C-1** `P8_EXPECT_OVERRIDE="F-R=REFUSED ML0-RB-4 other"` →
  `FAIL F-R: got 'REFUSED ML0-RB-5 provenance-reads' expected 'REFUSED ML0-RB-4 other'`;
  `P8-RUNNER: pass=7 fail=1 blocked=1`; **RUNNER EXIT 1**.
- **C-2** `P8_EXPECT_OVERRIDE="E-L=REFUSED ML0-RB-5 provenance-reads"` →
  `BLOCKED E-L: LOAD-ERROR (no RESULT-CLASS line)`; the word `PASS` does not appear on E-L's line;
  `P8-RUNNER: pass=8 fail=0 blocked=1`; **RUNNER EXIT 1** (a blocked case not expected `LOAD-ERROR` forces nonzero).
- **C-3** `P8_EXPECT_OVERRIDE="E-R=REFUSED ML0-RB-5 provenance-reads"` →
  `FAIL E-R: got 'REFUSED ML0-RB-11 other' expected 'REFUSED ML0-RB-5 provenance-reads'`; **RUNNER EXIT 1**.

Each control run prints `P8_EXPECT_OVERRIDE (verbatim): …` plus the before→after expectation into its transcript.

## 5. Divergences from the prereg

**D-1 — `#p"mneme/../"` is cwd-relative, and the prereg does not say which cwd.** §3's fixture paragraph and
the auditor's line 9 pass `#p"mneme/../"` to `ml0-fresh-run-root`, which `truename`s it
(`ml0-suite-ground.lisp:469-472`). That resolves **only** when the process cwd is the venue root (the directory
holding `mneme/`); with cwd = lane dir the probe dies at line 9 with *Failed to find the TRUENAME of
…/memory-layer-0/mneme/../* — an earlier, unrelated failure. **Resolution:** the lane dir is an explicit argv
(no venue path is compiled in), and the runner `cd`s to `<lane-dir>/../..` before every `sbcl --script`; the
case script keeps the auditor's literal `#p"mneme/../"`. Independently observed by REPRO and relayed by the chair.
*(The lane's own suites avoid this: `ml0-selftest.lisp:35` uses `(merge-pathnames "../../" *lane-directory*)`.)*

**D-2 — `lisp-plus-cd0:record-field` does not exist; `record-field` is Journal /0's.** Prereg §3 lists
`record-field` among the symbols reachable "from inside `lisp-plus-memory-layer0`" — correct, but it is
imported from `lisp-plus-journal0` (`memory-layer-0/package.lisp:98`), not exported by CD/0
(`canonical-datum/common-lisp/package.lisp` has no `record-field`). This is the very defect E-L preserves; the
prereg is right about the fix, and I record the package of record so the chair need not re-derive it.

**D-3 — `ml0-account-subject-principal` is NOT round-trippable into `ml0-account-envelope`, and V-J is the
detector.** `%ml0-decode-account-event` sets `:subject-principal (identifier-segment-string (field …))`
(`ml0.lisp:2168`), i.e. the **rendered** identifier `"principal:the actor"`;
`ml0-account-envelope` takes a **segment** and wraps it as `(idf (list "principal" <arg>))` (`ml0.lisp:1785-1786`).
Feeding the accessor's value back mints `principal:principal:the actor`. My first build did exactly that: V-J's
body was `equal-datum` to the lawful body and minted the identical hex, yet the append refused
`JOURNAL-REFUSED pj0-event-identity-collision PJ-APP-3` instead of reconciling at PJ-APP-2 — **kept at
`dev-runs/002-all-cases/V-J/`, diagnosed field-by-field at `dev-runs/003-vj-diagnosis/`** (the only unequal
envelope field was `event:subject-principal`). `ml0-account-subject-attempt` has no such problem (it is a
`string-datum-value`). **Fix is in my harness, not the lane:** the three envelope fields (`attempt`,
`subject-principal`, `process-id`) are read as the last path segment of the **lawful frame's own identifiers**.
After that, V-J is `:ALREADY-COMMITTED-IDENTICAL` with envelope equality T, exactly as §6 pre-committed.
I flag the asymmetry as an observation about the lane's accessor pair; **I did not touch the lane.**

**No other divergence.** All nine §6 classes came out as pre-committed on the first run that was free of D-3;
no case was bent to reach its expected class, and no runtime discrepancy arose to diagnose.

## 6. Uncertainties and things the chair should check itself

1. **F-W's class is `REFUSED ML0-WR-8 other`, by design of the prereg** — WR-8 is what `%ml0-dry-decode`
   re-signals (`ml0.lisp:2566-2572`); the RB-5 identity survives only inside the DETAIL string, which the runner
   checks separately. The `other` tag is therefore *correct and uninformative*; the informative artefact is the
   detail line. Anyone quoting "F-W: REFUSED ML0-WR-8 other" without the detail loses the finding.
2. **E-R's `other` tag likewise.** RB-11 fires before the effect-observation is decoded at all
   (`%ml0-decode-account-event`: RB-2 → RB-7 → sources → RB-8 → RB-9 → RB-10 → mint → **RB-11** → then
   `ml0-effect-observation-from-record`). So E-R is a genuine earlier-stage control, as §6 intends.
3. **The store's `tail-sha256` reads `NIL` for a valid prefix** in every transcript; I surface it but the
   state-effect evidence is `frames` + the sha256 of `EVENTS.pj0`, both printed.
4. **Concurrent activity in the lab checkout, not mine.** During my runs `git status` briefly showed
   ` M …/FILE-MANIFEST.txt` and ` M …/ml0-consolidation-proof.lisp`. `git diff --numstat` over that path is
   **empty** — stat-only, content unchanged — and my venue is cut from the commit, so nothing of mine could
   reach the checkout. I wrote nothing there; I only ran `git archive`/`git show`/`git ls-tree`/reads. The chair
   may want to know another hand was touching those mtimes at 13:53 and 13:55.
5. **I removed the five `/tmp/ml0-probe-p8-sup-*` roots my own E-L runs leaked** (the auditor's probe has no
   cleanup on any path) and deliberately **left the two that predate my session** (13:41:08, 13:41:57) alone —
   they are another chair's.
6. **Scope of what this establishes** is exactly prereg §9's: one forgery (provenance only), one pinned subject,
   one venue. Nothing here is independent verification of anything.

## 7. Reproduce

```sh
W=/tmp/claude-1000/-home-gauss-Desktop-Claude-Code-Lab/a9455147-ea7d-42f0-8bf8-78425fb9c7d7/scratchpad/smith
bash $W/harness/p8-runner.sh $W/venue/mneme/memory-layer-0 $W/<out-dir>          # real run, exit 0
P8_EXPECT_OVERRIDE="F-R=REFUSED ML0-RB-4 other" bash $W/harness/p8-runner.sh …   # C-1, exit 1
```
