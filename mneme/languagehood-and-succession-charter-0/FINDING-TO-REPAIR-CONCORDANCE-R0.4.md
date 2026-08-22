# FINDING-TO-REPAIR CONCORDANCE — R0.4

**CANDIDATE R0.4 — 2026-08-11.** Exact mapping from the three commissioned
findings of `SOL-R0.3-READBACK.md` (filed, sha256 `50a9dbb7…`) to their
repairs. R0/R0.1/R0.2/R0.3 preserved byte-identical (7/12/10/9 at seal).
SOL-R03-03/W-14 closed and untouched; per readback §5 nothing else reopened.
**No owner disposition solicited; nothing adopted; evidence zero.**

| Finding | Severity | Repair | Where |
|---|---|---|---|
| **SOL-R03-01** — P1's latent-authorship wording promoted to present license | BLOCKER | All four named sites demoted to **candidate-proposed / CC-3 pending F-8** (C.23; rung 10 status paragraph; §F.1(9) — CC-2 withdrawn with the §F.0 incompatibility stated; Succession Docket §4) — **plus two further sites of the same class found by the paragraph-level sweep** (the claim ceiling's LM0 wording cell; ledger EV-39's "licensed sentence"/"always sayable" cells). The design-intent-vs-LM0-empirical distinction preserved at every site. **Negative assertion, run and recorded:** every occurrence of the design-provenance sentence across the five successors now co-occurs with CC-3/candidate-proposed and none with a present-license form (sweep output in RETURN-R0.4 §3) | Charter C.23, rung 10, §F.1(9); `SUCCESSION-DOCKET-R0.4.md` §4; `CLAIM-CEILING-R0.4.md` LM0 row; `EVIDENCE-LEDGER-R0.4.md` EV-39 |
| **SOL-R03-02** — validator does not validate the declared grammar | BLOCKER | Charter rung 6 normalized to `**Status: OPEN**` with the two-target split moved to a separated support annotation; **validator replaced** by `validate_status_grammar.py`: parses inline AND separated declarations AND status-table columns; **unparseable status-looking declarations are themselves violations** (zero matches cannot count as success); **coverage assertions** (charter ≥10 declarations — 10 captured; ceiling ≥16 table cells — 16 captured) must be met before CLEAN prints; self-test carries ten negative controls **in the actual syntaxes** (inline/separated/table seventh tokens; the overstuffed "OPEN — and split…" token; truncations; bare REFUSED; unparseable form) and seven positives. Results: **SELF-TEST PASS · real corpus CLEAN exit 0** — after catching one real item (EV-38's bold-quoted skeleton stamp enacting the reserved form; emphasis stripped inside the quotation, alteration disclosed in-row). The R0.3 validator and its true history stay frozen in the R0.3 stratum | `validate_status_grammar.py`; charter rung 6; `EVIDENCE-LEDGER-R0.4.md` EV-38; results in RETURN-R0.4 §3 |
| **SOL-R03-04** — current-version identity incomplete | MAJOR | Every readback-listed live referent aligned: ceiling compresses-pointer → R0.4; docket companion → R0.4 charter; charter opening/§A.2 fork pointers → "the docket of the current R0.x candidate line (presently R0.4)"; §G.4 docket ref; §I non-solicitation → "any R0.x revision"; D.1 matrix row → current line; owner-docket F-1 options/operands/defaults → R0.x line; both closings/signatures → R0.4 line notation. **Finite adjudication returned (this table's companion):** post-repair the five successors contain **109** R0.1/R0.2 occurrences, every one adjudicated **historical provenance or frozen-artifact filename** — the 28 pattern-ambiguous cases were hand-adjudicated (19 historical kept; **9 live self-references fixed**: six charter self-refs → "this charter / current recommendation (standing since R0.1)", the docket's "R0.1 status" banner, and two owner-docket F-1 operands). Zero live-stale referents remain by sweep | All five successors; adjudication summary here, sweep output in RETURN-R0.4 §3 |

## Not reopened (readback §5, obeyed)

SOL-R02-03/W-14 · W-02…W-13 · independence coordinates · the four gate designs
· substantive fork triage · non-commencement clauses · source authentication,
quote corrections, master-commission identity, hand-count corrections, mode
normalization · all four frozen strata.

*— Concordance R0.4, the chair (Claude Fable 5), 2026-08-11. Candidate; adopts
nothing; solicits nothing.*
