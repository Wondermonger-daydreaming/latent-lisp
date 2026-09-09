# WARRANT WALK /0 — EXPECTATIONS-1: dated additions on Astra's review, written BEFORE the repair

*2026-09-08T17:07:41-03:00 by `date`. Chair *The Cache Is Never An Input* [e1ca41]. Astra's review (`corpus/voices/received/originals/2026-09-08-1706*-astra-WARRANT-WALK-0-REVIEW-*`, sha `dfc6c1ae…`) found two failures the nine fixtures do not exercise and one harness weakness. EXPECTATIONS-0.md is untouched (pre-line sha `528f18d9…`); this file adds fixtures S8–S12, rules WW-R8/R9, assumption EA-8, and expectations E8…E12, all pre-written. The four probes were first MEASURED against the unrepaired walker (`probes-pre-repair-CONFIRMED.txt`): R1 → `:CYCLE`; R2a/b/c → `:ESTABLISHED`. Astra's conclusions from source inspection are confirmed by run.*

## New rules and assumption

- **WW-R8 (correspondence).** At the root and at every followed premise, the selected support's `:for` must be `eq` to the claim it is
  asked to support. A record for another claim — however adequate — yields `(:mistargeted :requested CLAIM :via REF :target ITS-FOR :on ROUTE-or-:call)`
  and the result word **`:mistargeted`**. Mistargeted support is not "missing": the record exists and is named.
- **WW-R9 (active path vs completed).** A route is a cycle only if it is on the **current recursion path**. A route completed earlier
  and reached again by another path is **shared support**: it is not re-walked (memoized), its outcome stands, and the walk continues.
  **Presentation choice, declared:** `:followed` lists each `(premise :via ref)` occurrence once per containing route, so a shared route
  appears under every premise that selected it; the sub-walk itself runs once. Deduplication is presentation only and never changes `:result`.
- **EA-8 (result-word order, extended).** `:cycle` > `:mistargeted` > `:blocked` > `:not-established` > `:conditional` > `:established`. Experimental, like EA-5.
- **WW-R7, bounded (historical).** `reassess` is bounded to policy label `ww-r-0`, which names *this pinned implementation*. A snapshot
  whose `:policy` is not `ww-r-0` yields `(:result :unsupported-policy :policy X)` — an explicit refusal, not a silent run of present code
  under an old label. The absent-snapshot result is unchanged. A label is not retained historical executable semantics; the specimen retains a store and a symbol.

## New fixtures

```
S8  = S0 with dc's premises ((p :via d2) (r :via dr)) + (:claim r) + (:route dr :for r :adequate t :premises ((p :via d2)))
      ; shared acyclic support: DC→D2 and DC→DR→D2
S9  = S0 + (:route dx :for s :adequate t :premises ((c :via dc))) with d2's premise changed to (s :via dx)
      ; a genuine back-edge: DC→D2→DX→DC
S10 = S0 unchanged; the CALL is (assess S10 q :via dc)            ; root mistarget: dc is for c, not q
S11 = S0 with (:evidence e-s :for q :adequate t)                  ; leaf mistarget: e-s is for q, not s
S12 = S0 with (:route d2 :for q :adequate t :premises ((s :via e-s)))  ; subordinate mistarget: d2 is for q, not p
S13 = S1 + (:snapshot 2 :policy ww-r-99 :store S0)                 ; unsupported policy label
```

## Expected outcomes (pre-written)

| # | call | expected `:result` | expected exposure |
|---|---|---|---|
| E8 | `(assess S8 c :via dc)` | `:established` | followed contains `(p :via d2)`, `(r :via dr)`, `(s :via e-s)`; `:cycle` absent; unresolved/missing `()`; `:shared ((d2 :reached-again-via dr))` listed |
| E9 | `(assess S9 c :via dc)` | `:cycle` | `:cycle ((dc :on-path (dc d2 dx)))` — the back-edge named with the active path |
| E10 | `(assess S10 q :via dc)` | `:mistargeted` | `:mistargeted ((:requested q :via dc :target c :on :call))`; nothing established |
| E11 | `(assess S11 c :via dc)` | `:mistargeted` | `:mistargeted ((:requested s :via e-s :target q :on d2))`; e-s adequate flag irrelevant |
| E12 | `(assess S12 c :via dc)` | `:mistargeted` | `:mistargeted ((:requested p :via d2 :target q :on dc))`; the walk does NOT descend into d2 |
| E13 | `(reassess S13 c :via dc :at 2)` | `:unsupported-policy` | `:policy ww-r-99`; no other result word |

All of E10–E12 must remain non-establishing regardless of the selected record's `:adequate` flag (Astra: "an adequate record for another claim cannot establish this one").

## Harness expectation (R3)

`teeth.sh` must retain each plant's stdout+stderr and exit code, and count a plant as CAUGHT only when its **intended** failure line
appears: Plant A → `DEFECT NOT EXPOSED`; Plant C → `E5 FAIL` and `E6 FAIL`; Plant D → `E6 FAIL`. Any `debugger invoked`, `error`,
`READ error`, `unhandled` in a plant's output → **HARNESS FAILURE** (a crash is not a catch). Baseline stays green. Expected: 3 caught, 0 harness failures.

---

## RESULTS — appended after the repair (2026-09-08T17:10:55-03:00 by `date`; pre-registration of this file at commit `b05d1332`)

**Run 3 (`transcript-run3-after-repair.txt`): PASS 14/15, FAIL 1 — E9, on presentation only.** `:result :CYCLE` as expected; the
diagnostic read `(DC :ON-PATH (DC D2 DX DC))` where the pre-written form was `(DC :ON-PATH (DC D2 DX))`. The walker appended the
reached route to the active path; the expectation names the back-edge target once (first element) and the path as it stood. **The
walker was wrong (presentation);** one `cons` removed. **Run 4 (`transcript-run4.txt`): PASS 15/15**, all nine original rows unchanged
in outcome, E8–E13 as pre-written; DECISIVE comparison still DEFECT EXPOSED. E8's `:followed` lists `(P :VIA D2)` twice — once under
DC, once under DR — per the declared presentation choice (WW-R9); the sub-walk of D2 ran once (`:shared ((D2 :REACHED-AGAIN-VIA DR))`).
E12 does not descend into the mistargeted route (`:followed NIL`). E10–E12 refuse with the record's `:adequate t` intact.

**Harness (R3) — `teeth.sh` v2:** outputs retained under `teeth-out/` (one file per plant + baseline, each ending `exit=N`); a plant
is caught only when its intended failure line appears; `debugger invoked|Unhandled|READ error|unhandled condition|is undefined|error
during LOAD|COMPILER-ERROR` in a plant's output → HARNESS FAILURE. Five plants (A, C, D + two added with the repair: E drops the
correspondence check → E11/E12 FAIL; F never releases completed routes, the d8c4d860 behaviour → E8 FAIL with `:CYCLE`), all five
caught **for the intended reason**; baseline PASS 15/15 no crash. **Self-check of the crash rule** (ad hoc, not in the script): a plant
that removes one paren from `result-word` exits 1 with four crash-regex hits — v1 would have counted it "caught"; v2 classifies it
HARNESS FAILURE. The three v1 plants did not crash (their retained outputs show the intended FAIL lines), so v1's verdicts stand in
substance; v1's *rule* could not have known that, which was Astra's point.

**Historical qualification:** `reassess` now refuses a snapshot whose `:policy` is not `ww-r-0` (`:unsupported-policy`, E13) and
prints `:bounded-to "ww-r-0 = this pinned implementation; the label is a symbol, not retained executable semantics"` on the positive
control. RETURN.md's "retains all of them as one blob" is corrected in RETURN.md ADDENDUM 1: the snapshot retains a store and a symbol.
