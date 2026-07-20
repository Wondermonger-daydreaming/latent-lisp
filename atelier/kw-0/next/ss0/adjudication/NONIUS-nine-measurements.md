# SS-0 — The Nine Measurements, Reported Raw Per Seat

*Compiled by NONIUS (measurements clerk, step-8 adjudication), 2026-07-20. Raw values only, per-cell file citations. No pass/fail on size; extension delta reported separately (sealed packet §5). "Not measured" is written where no primary artifact grounds a raw per-side figure.*

Seat A = Kimi K3 (`ss0.py` / `ss0-reader.lisp`). Seat B = Qwen3.8Max-Preview (`ss0_runner.py` / `ss0_reader.lisp`).

Path prefixes below:
- `BENCH/` = `experiments/latent-lisp/_staging/ss0-bench/`
- `DELIV/` = `experiments/latent-lisp/_staging/ss0-deliveries/`
- `SS0/` = `experiments/latent-lisp/atelier/kw-0/next/ss0/`

---

## Definitions of the nine measurements (quoted verbatim)

Source: `SS0/SS0-PROTOCOL.md` line 13 — *"Nine measurements per side:"*

1. **application-facing effective lines**
2. **call-site obligations per consequential operation**
3. **recovery branches**
4. **manually coordinated identities**
5. **invariant violations under planted mutations**
6. **effort (AFEL delta + description) to add the sealed extension**
7. **cross-language recovery agreement**
8. **audit-trail completeness (R9 walk by the chair)**
9. **whether information loss appears only in derived views or contaminates the durable record**

Budget rule that frames them (`SS0/SS0-PROTOCOL.md` lines 11-12): *"Each side's semantic layer is measured after subtracting only the shared substrate; per-side private helpers count in full (AFEL tool, marker rule audited)."*

---

## The measurement table (base implementation)

| # | Measurement | Seat A (Kimi K3) | Seat B (Qwen) | Notes / source |
|---|---|---|---|---|
| 1 | Application-facing effective lines (AFEL, base) | **482** = 361 runner + 121 reader | **339** = 233 runner + 106 reader | `BENCH/afel-base-recount.txt`; NONIUS re-ran `SS0/substrate/ss0-afel.py` on the frozen `DELIV/seat-{a,b}/` sources — identical (A 361/121, B 233/106). Matches chair anchors exactly. 8 `@harness` lines excluded each runner (audited list in file); 0 excluded each reader. |
| 2 | Call-site obligations per consequential operation | **Not measured** (no raw per-side figure) | **Not measured** (no raw per-side figure) | No chair-produced count in any step-7 artifact. Design-descriptive prose only: Seat A README `DELIV/seat-a/README.md` line 50-52 ("declaration is fsynced before the provider is contacted") states the single per-call-site invariant; Seat B `DELIV/seat-b/README.md` records `intent`→`dispatch`→`outcome`/`complete` sequencing but no obligation count. See FLAGS. |
| 3 | Recovery branches (derived standings the recovery logic distinguishes) | **7 standings**: UNRESOLVED, OUTCOME-UNCONFIRMED, SETTLED, ATTESTED, CONFLICT, STREAM-INCOMPLETE, STREAM-COMPLETE | **6 states**: unknown, attempted, unresolved, outcome-recorded, receipt-resolved, completed | Seat A: `DELIV/seat-a/README.md` lines 55-61 (verified against recover output `BENCH/seat-a/recover-base-all.txt`). Seat B: `DELIV/seat-b/README.md` lines 87-92. Counts are of named recovery standings/states; anomaly kinds reported separately (not counted here). Different granularity between seats — reported raw, no normalization. |
| 4 | Manually coordinated identities | **Not measured** as a raw figure | **Not measured** as a raw figure | No chair count. Source-observable design difference: Seat A `succeed <old> <new> [tag]` takes a caller-supplied successor id (`DELIV/seat-a/README.md` line 33; `DELIV/seat-a/ss0.py:372,417-418`), so successor identity is externally coordinated. Seat B auto-generates `succ-<timestamp>` (`BENCH/seat-b/recovery-modes-base.txt` line 26: `succ-1784582840630`; `DELIV/seat-b/README.md` line 42). Batch legs auto-derived both seats (`<batch>-leg-<i>` / `<op>-L<i>`, `DELIV/seat-{a,b}/extension/CHANGE-STATEMENT.*`). No per-side integer was produced by the chair. See FLAGS. |
| 5 | Invariant violations under planted mutations | **0 survivors** — 6/6 mutants (M1-M6) DETECTED | **0 survivors** — 6/6 mutants (M1-M6) DETECTED | `BENCH/BENCH-LOG.md` lines 138-158 ("12/12 DETECTED, zero survivors"); per-mutant detector+diff in table. 12 disclosed diffs present: `BENCH/mutants/DIFF-{a,b}-m{1..6}.diff`. Battery conclusion (line 156): "no surviving mutant ⇒ no obligation fails via the battery, both seats." |
| 6 | Effort to add sealed extension — AFEL delta | **+197** (net Δtotal: 482→679) | **+276** (net Δtotal: 339→615) | `BENCH/void-afel-ext.txt` + `BENCH/BENCH-LOG.md` lines 96-99; NONIUS re-ran AFEL on frozen `DELIV/seat-{a,b}/extension/` sources — identical (A 513/166, B 433/182). Descriptions: `DELIV/seat-a/extension/CHANGE-STATEMENT.md`; `DELIV/seat-b/extension/CHANGE-STATEMENT.txt`. See extension rows + FLAG on Seat A's separate diff figure. |
| 7 | Cross-language recovery agreement (PY↔CL digest) | **14/14** = 10/10 base + 4/4 ext | **13/13** = 9/9 base + 4/4 ext | `BENCH/BENCH-LOG.md` lines 55-56 (Seat B 9/9 base, 4/4 ext), 76-77 (Seat A 10/10 base, 4/4 ext); total 27/27 at line 133. Raw digest transcripts: `BENCH/seat-{a,b}/clreader-base-pristine.txt`, `crosslang-mutated.txt`, `BENCH/seat-b/recover-ext.txt`, `BENCH/seat-{a,b}/ext-modes.txt`. Zero digest disagreements either seat. |
| 8 | Audit-trail completeness (R9 walk by the chair) | R9 exercised on **7/7 base corpses**; four-section audit report present; **no discrete completeness verdict/figure recorded** | R9 exercised on **7/7 base corpses**; **no discrete completeness verdict/figure recorded** | Raw evidence = `recover` transcripts `BENCH/seat-a/recover-base-all.txt`, `BENCH/seat-b/recover-base-all.txt` (sections A surviving records / B derived state / C anomalies / D canonical rendering — the R9 reconstruction). No section in `BENCH/BENCH-LOG.md` or `SS0/SS0-FREEZE-LEDGER.md` labels a per-seat "R9 walk" verdict. See FLAGS. |
| 9 | Information loss: derived views only, or contaminates durable record | **Derived views only** — batch census in derived rendering only; no scalar batch outcome in durable record | **Derived views only** — census only in derived output; obligation held | Seat A: `BENCH/BENCH-LOG.md` line 80 ("batch census in derived rendering only"). Seat B: `BENCH/BENCH-LOG.md` line 59 ("census only in derived output … no scalar batch outcome in durable record — held"). Corroborated by M6 (scalar-compress census → R1/R9) DETECTED both seats (`BENCH/BENCH-LOG.md` line 154): the durable record provably carries no scalar census. Base design: derived standings "never written back — R6" (`DELIV/seat-a/README.md` line 54; `DELIV/seat-b/README.md` line 94 `derived=true`). |

---

## Extension-delta rows (reported separately — sealed packet §5)

| Row | Seat A | Seat B | Source |
|---|---|---|---|
| AFEL ext total | 679 = 513 runner + 166 reader | 615 = 433 runner + 182 reader | `BENCH/void-afel-ext.txt`; NONIUS re-run identical |
| AFEL net Δtotal (base→ext) | **+197** | **+276** | derived from rows above; `BENCH/BENCH-LOG.md` line 98-99 "Net Δ" col |
| `@harness` lines excluded (ext runner) | 10 | 10 | `BENCH/void-afel-ext.txt`; NONIUS audited lists A `[78,82,83,88,96,103,104,109,155,164]`, B `[380,382,383,388,395,405,406,411,460,464]` |
| Seat A's separately-claimed diff-based delta | **225 added/changed application lines** (over `EXTENSION-DELTA.diff`, AFEL rules) | *no equivalent diff figure claimed* | `DELIV/seat-a/extension/CHANGE-STATEMENT.md` line 26; flagged as a **different measure** from net AFEL Δtotal by `BENCH/BENCH-LOG.md` lines 104-106 |
| New record kind added by extension | 1 (`batch`, declaration-only) | 1 (metadata-only batch descriptor) | `DELIV/seat-a/extension/CHANGE-STATEMENT.md` lines 6-9; `DELIV/seat-b/extension/CHANGE-STATEMENT.txt` line 1 |
| Digest spec version bump | `ss0-recovery/1`→`/2` | one new derived field `legs` (census) | `DELIV/seat-a/extension/CHANGE-STATEMENT.md` lines 22-23; `DELIV/seat-b/extension/CHANGE-STATEMENT.txt` line 1 |
| New recovery mode added | 1 (`bsucceed`) | 0 new mode (batch-aware branches added to existing modes) | `DELIV/seat-a/extension/CHANGE-STATEMENT.md` lines 17-21; `DELIV/seat-b/extension/CHANGE-STATEMENT.txt` line 1 |

**Recompute of Seat A's "225" under AFEL counting rules:** the packet definition of measurement 6 calls for *"AFEL delta + description,"* and the AFEL delta is the net Δtotal = **+197** (independently re-run above). The "225 added/changed lines" is Seat A's own **diff-based** count over `DELIV/seat-a/extension/EXTENSION-DELTA.diff` (added + changed lines), which is *not* the same statistic as net AFEL Δtotal (net Δ nets out deletions/replacements; a diff's added+changed count does not). The chair already recorded this distinction (`BENCH/BENCH-LOG.md` lines 104-106). Both figures reported; no discrepancy with the anchors — they measure different things. NONIUS did not re-run a line-by-line AFEL pass over the raw diff hunks (the diff is not a standalone source file the AFEL tool ingests); that finer recompute is available at adjudication from `EXTENSION-DELTA.diff` if wanted.

---

## Chair-verified anchor consistency check (task-required)

| Anchor (from task) | Primary artifact | NONIUS re-run | Match |
|---|---|---|---|
| Seat A base 361+121=482 | `BENCH/afel-base-recount.txt` | 361 / 121 | ✅ |
| Seat A ext 513+166=679 | `BENCH/void-afel-ext.txt` | 513 / 166 | ✅ |
| Seat B base 233+106=339 | `BENCH/afel-base-recount.txt` | 233 / 106 | ✅ |
| Seat B ext 433+182=615 | `BENCH/void-afel-ext.txt` | 433 / 182 | ✅ |
| Seat A diff-based ext delta "225 added/changed" | `DELIV/seat-a/extension/CHANGE-STATEMENT.md` line 26 | — (diff measure, ≠ AFEL Δtotal +197) | ✅ consistent; distinct statistic |

**No discrepancy found against any chair-verified anchor.**

---

## FLAGS — measurements NOT groundable in a primary artifact as a raw per-side figure

- **#2 Call-site obligations per consequential operation** — no chair-produced count exists in any step-7 bench artifact or the freeze ledger. Only design-descriptive prose is available (the fsync-before-dispatch invariant, README obligation maps). Reported as **Not measured**; a count would require a fresh source walk at adjudication, not compilation.
- **#4 Manually coordinated identities** — no chair-produced integer. A source-observable design *difference* exists (Seat A caller supplies the successor id; Seat B auto-generates it), cited above, but neither seat's artifact states a raw count. Reported as **Not measured** with the design difference noted.
- **#8 Audit-trail completeness (R9 walk by the chair)** — the R9 machinery was *exercised* (recover transcripts on all 7 base corpses, both seats) but no dedicated per-seat "R9 walk" completeness verdict or score was written into the bench log or ledger. The raw artifact is the transcript itself, not a completeness figure. Reported as exercised, figure **not separately recorded**.

All six remaining measurements (#1, #3, #5, #6, #7, #9) are grounded in cited primary artifacts and, where mechanical, independently re-derived by NONIUS.
