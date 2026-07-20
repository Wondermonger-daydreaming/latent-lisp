# LIBRA — SS-0 Step-8 Band-Application Analysis

*Band examiner: LIBRA (Claude Opus 4.8, 1M ctx), for the chair (Claude Fable 5), 2026-07-20.
Standard: apply the frozen bands EXACTLY as written; show every arithmetic step; refuse any
reading that inflates or deflates. Where the outcome falls between bands, say so plainly rather
than force a fit. Flinch doctrine applies in BOTH directions — the pretty verdict (warm: "Band S,
architecture supported!") and the ugly one (cold: "budget blown 8×, thesis dead") both arrive
early; the true one leaves evidence.*

---

## 0. The frozen band texts (quoted verbatim, sealed packet §3 + §5)

> **Band S** (architecture supported at multi-effect scale): both seats satisfy R1–R9 and the
> satisfying designs exhibit per-proposition-style machinery at AFEL cost ≤1.5× KW-0's application
> column. Reported ALWAYS with the shared-root cap: both seats' training corpora overlap;
> convergence is corpus-attractor-sensitive, never "independent" simpliciter.
>
> **Band C** (conventional-parity — F5 weakened): ≥1 seat satisfies R1–R9 within a smaller
> application-facing budget with a design the exclusion audit confirms conventional (no
> per-proposition machinery re-derived).
>
> **Band M** (mixed): obligations met with partial machinery or at sharply asymmetric cost —
> per-obligation report, no thesis-level promotion either direction.
>
> **Band F** (obligations unmet): evidence about difficulty, not the thesis; report which and why.
>
> **NULL/VOID discipline:** a VOIDed arm confirms nothing in any direction; re-run or report VOID
> as VOID. An underpowered arm cannot confirm a null.

§5 (measurement bands): *"The only thresholded quantity is Band S's ≤1.5× comparison to KW-0's
application column (62 AFEL, fixed reference), and Band C's 'smaller budget' comparison between
seats."*

So the entire adjudication carries **exactly one pass/fail quantity**: a seat's application-facing
AFEL vs `1.5 × 62 = 93`. Everything else is reported raw. This gate is load-bearing and cannot be
waved away.

---

## 1. What the 62-AFEL reference actually measured (file-cited)

The reference is **not** a seat total, a recovery-layer figure, or a whole-repo count. It is the
output of a pre-registered mechanical counter run on **one file**.

**Source:** `atelier/kw-0/specimen/src/f6v3.py` (the F6-v3 metric, pre-registered RDP-1/D3),
docstring lines 8–24:

> Unit: APPLICATION-FACING EFFECTIVE LINE (AFEL). … **Designated application files: the scenario
> drivers an application author writes: KW column = `kw-runner.lisp`; baseline column =
> `kw-baseline.lisp`. Substrate (`kw-common`, `kw-oracle`, `kw-reconstruct`, `folder.py`,
> `harness.py`) is excluded by definition** — it is the substrate, per the owner's F6 repair.
> Threshold … KW-AFEL ≤ 1.5× baseline-AFEL.

Confirmed by the verification report (`verification/FABLE-KW0-VERIFICATION-REPORT.md` line 51):
*"F6-v3 (prospective, mechanical AFEL): **62 vs 52 = 1.192× — PASS**."* And by the HB-0 report
(`hb0/HB0-F5-REPORT.md` line 24): *"the specimen's measured column (**62**) **excludes
`kw-reconstruct.lisp` (219 lines) as substrate**."*

**Therefore the 62 measured, precisely: `kw-runner.lisp` alone — the KW-0 runner-side scenario
driver for a SINGLE effect type (the killed-witness scenario), with the 219-line cold recovery
reconstructor AND the second-language reader (`folder.py`) both EXCLUDED as substrate.** 52 is the
conventional baseline (`kw-baseline.lisp`); the 62/52 = 1.192× is an *intra-KW-0* ratio. Band S
imports only the numerator, 62, and freezes it as a fixed cross-experiment reference.

**Two scope facts that matter for the comparison (flagged, not smoothed):**

1. **62 is single-effect-type.** KW-0 was one effect across several crash windows. SS-0's brief
   (`SS0-NEUTRAL-BRIEF.md`) mandates *"≥3 effect types and ≥2 payload regimes,"* nine obligations,
   plus a whole additional effect type at extension. The 62 reference was never scale-normalized to
   a multi-effect problem; the frozen band supplies no per-effect or per-obligation divisor.
2. **62 excluded KW-0's recovery reader as "substrate"; SS-0's readers are private per-seat code.**
   In SS-0 the shared substrate is a *separately counted* frozen deliverable; each seat *wrote its
   own* `ss0-reader.lisp`/`ss0_reader.lisp`, which is application-facing private code, not amortized
   substrate. The KW-0 verification itself flagged its own reconstructor-exclusion as a *"measurement
   asymmetry … a promise at n=1, not a measurement"* (`HB0-F5-REPORT.md` line 24). So the SS-0
   reader has no clean analogue to KW-0's excluded reconstructor — which bears directly on which
   SS-0 column is "comparable."

---

## 2. Do both seats satisfy R1–R9? (per-obligation, cited to BENCH-LOG)

Yes — all nine, both seats, per the chair's verdict-bearing bench (`_staging/ss0-bench/BENCH-LOG.md`).

| Obl. | Requirement (brief) | Bench evidence (both seats) | Mutation check |
|---|---|---|---|
| **R1** | No invented history; report ambiguity | Recovery coherent on all corpses; S4/S7 honestly `unresolved`, no guessing (B); predecessor stays UNRESOLVED + visible (A) | M6→R1/R9 both DETECTED |
| **R2** | Empty/absent/invalid payload distinguishable end-to-end | M1 (collapse payload distinction) → CL differential splits digests | **M1→R2 both DETECTED** |
| **R3** | No blind re-dispatch; refusal cites record | R3 refusals cite record evidence — B 4/4 states, A 5/5 incl. stream-incomplete | **M2→R3 both DETECTED** (A needed 2-hunk mutant: gate is default-deny) |
| **R4** | Evidence-based resolution; receipts enter record; no re-dispatch | Executed-receipt permanently blocks re-dispatch (B); provenance check verifies attempt identity (A) | **M4→R4 both DETECTED** (mode claims admission; canon shows UNRESOLVED) |
| **R5** | Distinct succession; predecessor unresolved stays visible | Successor fresh identity + visible predecessor (B); `succeed`-on-unresolved keeps predecessor UNRESOLVED (A) | **M5→R5 both DETECTED** (A: v2; v1 neutralized by design — robustness, see §7) |
| **R6** | Derived stays derived; re-verify doesn't upgrade | Census only in derived output; durable record carries no scalar batch outcome | **M3→R6 both DETECTED** (conf/derived laundering splits digests) |
| **R7** | Independent second-language reader; digest agreement | **27/27 cross-language agreements** (A 10 base+4 ext; B 9 base+4 ext); reports identical modulo "(CL)" header | VOID-3 PASS w/ teeth (no shared fold/fixture) |
| **R8** | Extension without rewrite; delta measured | **S1–S7 under v1.1 byte-identical to base, 7/7 hashes, BOTH seats**; per-leg identities added, base untouched | Seat B reader locational claim PARTIAL — see §5 |
| **R9** | Auditability: attempted/known/unknown/evidence | R9 walk coherent; VOID-1/VOID-3 PASS with teeth (planted READY-read + hardcoded-digest both fired) | M6→R1/R9 both DETECTED |

**Mutation battery: 12/12 DETECTED, zero survivors** (BENCH-LOG §"Mutation battery … COMPLETE").
By the packet's own rule (§2), *"a surviving mutant fails the mapped obligation"* — no survivors, so
**no obligation fails via the battery, either seat.** Both seats satisfy R1–R9. **Band S conjunct (a)
and Band C's "satisfies R1–R9" clause are both met.**

---

## 3. Do the designs exhibit "per-proposition-style machinery"? (both — assessed honestly)

**Yes, both seats re-derived genuine per-proposition machinery.** This is decisive for Band C (see
§5), so I assess it directly from the bench descriptions rather than taking the label on faith.

- **Seat B (Qwen):** *"per-leg identities `<op>-L<i>`; … batch redispatch refusal cites the specific
  leg; per-leg receipt resolves only its leg; `succeed <batch>` records `reattempt=2,3 abandon=1`
  lineage; census only in derived output."* Per-leg (= per-proposition) identity, resolution, and
  lineage — not a scalar batch status.
- **Seat A (Kimi K3):** *"`bsucceed` abandons known-executed legs …, re-attempts others under
  per-leg `succ` lineage; `admit <batch>` refuses per-batch receipts; batch census in derived
  rendering only."* Same shape: per-leg discipline, census kept out of the durable record.

Both designs carry per-proposition standing through crash recovery and refuse to scalar-compress it
into the durable record (M6 DETECTED on both confirms the machinery is real, not cosmetic).
**Band S conjunct (b) is met; Band C's "no per-proposition machinery re-derived" clause is FALSE for
both seats** — no conventional shortcut appeared.

---

## 4. Band S arithmetic — under EACH defensible scoping (labeled; none invented favorably)

Threshold: `1.5 × 62 = 93 AFEL`. AFEL recounts from BENCH-LOG (mechanical, `ss0-afel.py`):

| Seat | Base runner | Base reader | **Base total** | Ext runner | Ext reader | **Ext total** |
|---|---|---|---|---|---|---|
| A | 361 | 121 | **482** | 513 | 166 | **679** |
| B | 233 | 106 | **339** | 433 | 182 | **615** |

**Scoping (i) — seat TOTAL vs 62** (runner + reader; treats the seat's whole written application as
application-facing, which is correct since SS-0 readers are private per-seat code, not amortized
substrate — see §1 fact 2):

| Seat | Base total / 62 | Verdict | Ext total / 62 | Verdict |
|---|---|---|---|---|
| A | 482/62 = **7.774×** | FAIL | 679/62 = **10.952×** | FAIL |
| B | 339/62 = **5.468×** | FAIL | 615/62 = **9.919×** | FAIL |

**Scoping (ii) — RUNNER only vs 62** (the scope-faithful runner-to-runner match, since 62 =
`kw-runner.lisp` and excluded KW-0's reconstructor; this is the MOST FAVORABLE-to-seats defensible
scoping because it drops the reader):

| Seat | Base runner / 62 | Verdict |
|---|---|---|
| A | 361/62 = **5.823×** | FAIL |
| B | 233/62 = **3.758×** | FAIL |

**Scoping (iii) — the single smallest application column anywhere** (an indefensible cherry-pick,
included only to show robustness): Seat B base reader = 106 → 106/62 = **1.710× → FAIL**.

**Result: there is NO defensible scoping — total, runner-only, reader-only, or even the single
smallest column — under which any seat lands ≤ 1.5×.** Every one of the eight measured columns
exceeds 93 (smallest = 106). **Band S's cost conjunct (c) FAILS universally.** I did not invent a
favorable scope; I checked all of them and they all fail.

**⇒ Band S is NOT satisfiable as frozen.** Conjuncts (a) obligations and (b) machinery are met; the
frozen `≤1.5×` cost conjunct — the adjudication's single thresholded quantity — is not. The band is
a conjunction; one failed conjunct means the label cannot be applied. **No inflation move (dropping,
softening, or "spiritually satisfying" the cost clause) is licensed.**

---

## 5. Band C assessment — F5 is NOT weakened

Band C fires only if **≥1 seat satisfies R1–R9 within a smaller application-facing budget with a
design the exclusion audit confirms CONVENTIONAL (no per-proposition machinery re-derived).**

- A cheaper seat **does** exist: Seat B (base 339 / ext 615) < Seat A (base 482 / ext 679). Band C's
  intra-seat "smaller budget" comparison is satisfied by Seat B.
- **BUT Seat B's design is NOT conventional** — §3 shows it re-derived full per-leg/per-proposition
  machinery (per-leg identities, per-leg receipts, per-leg lineage, census-out-of-durable-record).
  The exclusion audit (the mutation battery) confirms the machinery is *real*: M3/M5/M6 DETECTED on
  Seat B specifically because the machinery is present to be broken.

**⇒ Band C FAILS on its conventionality clause.** No conventional-parity design appeared on either
seat. **This is the load-bearing good news for F5: F5 is NOT weakened.** The band that would weaken
the thesis requires a cheap conventional falsifier, and none exists — both seats had to build the
machinery. (Recall KW-0's own honest conventional control cost **177 AFEL with only PARTIAL coverage
on clauses 1 and 4** — `HB0-F5-REPORT.md`; conventional is expensive too.)

**Seat B reader PARTIAL finding (docketed, held at size):** the bench found Seat B's reader has *one
unmarked structural edit* (normalization hoisted to a pre-pass; rule content byte-identical) — its
**semantic** R8 claim ("no original recovery rule rewritten") HOLDS; its **locational** claim
("confined to marked additions") is not byte-strict. This is a minor blemish on Seat B's R8
book-keeping, not an obligation failure (no rule was rewritten; M-battery on the reader still 6/6
detected). It does not move any band. Naming it and leaving it alone.

---

## 6. Band M / Band F assessment

**Band F (obligations unmet):** Every obligation R1–R9 met by both seats; 12/12 mutants detected;
27/27 cross-language. **Not Band F.**

**Band M (mixed — "partial machinery or sharply asymmetric cost"):** Band M partially describes the
outcome ("no thesis-level promotion either direction" is exactly right here), but it *mis-describes
the mechanism* on both of its own triggers:
- **Not "partial machinery":** machinery is FULL on both seats (§3), not partial.
- **Not "sharply asymmetric cost" between seats:** B/A base = 339/482 = 0.70; ext = 615/679 = 0.91.
  Moderate, not sharp; and both seats fail the *absolute* 93 gate regardless of the inter-seat ratio.

So the true situation is neither "partial machinery" (that would understate it) nor a clean Band S
(the cost gate forbids the label). **Band M's descriptors don't fit, but its disposition — "no
thesis-level promotion either direction" — is the correct posture.**

---

## 7. The two docketed asymmetries — non-dispositive here (trigger condition not met)

The freeze ledger dockets two asymmetries and gives them an **explicit conditional trigger**:
*"Interpretation bands must weigh this **if outcomes differ sharply on execution-sensitive
obligations**"* (SS0-FREEZE-LEDGER, Seat B declaration entry).

1. **Execution asymmetry:** Seat A had a live sandbox and could iterate against the selftest; Seat B
   authored **blind**, execution deferred wholly to the chair.
2. **Hash-verification asymmetry:** Seat A hash-verified its received files; Seat B (chat-only) could
   not, custody resting on owner-side staging.

**Did outcomes differ sharply on execution-sensitive obligations? No.** The bench records Seat B's
blind-authored code *"ran first-try … the entire corpus without a single error"* (BENCH-LOG),
27/27 cross-language including Seat B's 13, all six mutations detected on Seat B. Seat B — the blind
seat — met every execution-sensitive obligation the executing seat met. **The trigger condition is
not satisfied; the asymmetries stay docketed but do not move the verdict.** (They cut, if anywhere,
*in Seat B's favor* — a blind author matching a live-iterating one on execution is the stronger
result, not the weaker. And the cost axis, where the seats do differ, fails the 93 gate on both
regardless, so even there the asymmetry rescues nothing.) SUBSTRATE-DOC-DEFECT-1's per-seat CLI
accommodation (A native, B via `seat-b-adapter.py`, byte-identical kill mechanics) is recorded as
applied; it introduced no outcome divergence.

---

## 8. The shared-root cap — MUST ride any convergence claim

The frozen Band S text mandates it: *"convergence is corpus-attractor-sensitive, never 'independent'
simpliciter."* Any statement that "both seats converged on per-proposition machinery / both met all
obligations" MUST carry this cap. Three specific notes, held at their true size:

- **The convergence here is CROSS-LINEAGE** — Seat A = Kimi K3, Seat B = Qwen (the
  `DIFFERENT-MODEL-LINEAGE` classification was the point). Cross-lineage agreement is *stronger* than
  same-model-sibling agreement (the Shared-Root Check's worst case), but the frozen cap still binds:
  both are LLMs over heavily-overlapping public corpora (systems-programming / crash-recovery /
  Lisp conventions). Convergence remains corpus-attractor-sensitive; it is **not** independent
  discovery, and no "two independent witnesses" language may attach.
- **Seat A shares root with the apparatus author.** Seat A is `SHARED-KIMI-LINEAGE`; KW-0's specimen
  and the SS-0 mutation seed set were authored within the Kimi/lab lineage. Seat A's convergence with
  the reference design carries a *narrower* shared-root than Seat B's. Flag on Seat A specifically.
- **The 62 reference itself is lab-authored** (Fable's F6-v3 registration). The threshold is not an
  external standard; it is the lab grading its own ruler. Named, per the cold-flinch guard (a
  lab-set gate that the lab's own seats fail is still evidence, but it is *in-house* evidence).

---

## 9. VERDICT — a between-bands outcome, stated plainly

**The result falls BETWEEN Band S and Band M, and is NOT reducible to any single frozen label.**

- **On the obligation-and-machinery axis it reaches Band S:** both cross-lineage seats satisfy all
  nine obligations (12/12 mutants detected, 27/27 cross-language, VOID-1/3 PASS with teeth) and both
  re-derived genuine per-proposition machinery. **No conventional-parity design appeared to falsify
  F5** (Band C is empty). The F5 thesis is **SUPPORTED IN DIRECTION at multi-effect scale** — i.e.,
  the architecture's per-proposition discipline was independently rebuilt, not cheaply shortcut, by
  two different model lineages under a live mutation battery.

- **On the cost axis Band S is FORECLOSED:** the adjudication's single thresholded quantity — seat
  application AFEL ≤ 1.5×62 = 93 — **fails under every defensible scoping** (5.5×–7.8× at base
  totals; 3.8×–5.8× runner-only; smallest single column 1.71×). The Band S label **cannot be
  applied as frozen**, and no inflation move may retire the failed cost clause.

- **It is NOT Band C** (F5 not weakened — no cheap conventional design), **NOT Band F** (nothing
  unmet), and **only loosely Band M** — Band M's *"no thesis-level promotion either direction"* is
  the correct posture, but its "partial machinery / sharply asymmetric cost" descriptors misfit
  (machinery is full; inter-seat cost asymmetry is moderate).

**Plain-language disposition for the record:**
> **F5 remains SUPPORTED-IN-DIRECTION and NOT-WEAKENED, at multi-effect toy scale, with the Band S
> cost gate unmet.** Both seats built the machinery and met every obligation; neither did it within
> 1.5× the KW-0 62-AFEL reference. Reported with the mandatory shared-root cap: the two seats are
> different model lineages but overlapping-corpus LLMs, so this is corpus-attractor-sensitive
> convergence, never independent confirmation. Per the standing rule (SS0-PROTOCOL §"Standing
> rule"), F5 stays `SUPPORTED-AT-TOY-SCALE-UNDER-HB0` and inherits `TOY-SCALE`-class qualifiers
> (multi-effect-type, still one seat-pair, one host, SIGKILL not power loss); this result does not
> license strengthening past toy scale.

Both flinch directions refused: I did **not** promote the clean obligation sweep to a declared
"Band S" (warm/vindication flinch — retiring the failed cost gate to make a true result mean more),
and I did **not** read the 8× budget overrun as "F5 refuted / architecture too expensive"
(cold/deflation flinch — emptying a real result, when the failed gate means "Band S not declarable,"
NOT "thesis weakened"; weakening requires the conventional falsifier that Band C never found).

---

## 10. What I could NOT resolve in the frozen bands — flagged, not smoothed

1. **The 62 reference is not scale-normalized, and the frozen text provides no divisor.** 62 =
   `kw-runner.lisp` for **one** effect type; SS-0 mandates **≥3** effect types + a whole extension +
   nine obligations. The literal frozen threshold (93) therefore compares a multi-effect application
   to a single-effect ruler. Under the literal text Band S fails (my verdict). **But whether 62 was
   the correct *fixed reference* for a multi-effect problem is a question the frozen bands do not
   answer, and I will not answer it by inventing a per-effect normalization** — that would be exactly
   the favorable rescoping my charge forbids. If the owner/chair judges the reference should have
   been scale-normalized, that is a **band-design amendment**, made openly and hashed (packet §6),
   not a reading LIBRA may apply retroactively. As frozen, the gate fails; flagged for the chair.

2. **Total-vs-runner scope ambiguity is real but non-dispositive.** 62 excluded KW-0's reconstructor
   as substrate, which argues for a runner-only SS-0 comparison; but SS-0 readers are private per-seat
   code (not amortized substrate), which argues for the total. The frozen band says only "KW-0's
   application column" and does not name which SS-0 column mirrors it. **Resolved for the verdict
   (both scopings fail 93), flagged for completeness.** I report both, labeled, per §4.

3. **The frozen band taxonomy has no slot for "all obligations met + full machinery + no conventional
   falsifier, BUT the absolute cost gate unmet."** That is precisely the outcome observed. Band S
   requires the cost gate; Band C requires a conventional design; Band M presumes partial machinery or
   sharp asymmetry; Band F presumes unmet obligations. **None fits cleanly** — hence the explicit
   between-bands verdict in §9. This is a genuine gap in the frozen bands, surfaced honestly rather
   than forced into the nearest label.

4. **The threshold is lab-self-set** (§8) — 62 is Fable's own F6-v3 registration, and Seat A shares
   its lineage. This does not void the gate (a self-set gate the lab's seats *fail* is still a
   real negative result), but "the lab graded its own ruler and its own seats overran it" is the
   honest frame; recorded, not dissolved.

*— LIBRA (Claude Opus 4.8, 1M context), band examiner, SS-0 step 8. Every arithmetic step shown;
every scope checked, not assumed; both flinches named and refused.*
