# FINDING-TO-REPAIR CONCORDANCE — R0.2

**CANDIDATE R0.2 — 2026-08-11.** Exact mapping from every finding of
`SOL-R0.1-READBACK.md` (filed, sha256 `54b16ec2…`) to its repair. R0 and R0.1
preserved byte-identical (`SHA256SUMS.txt` 7/7; `SHA256SUMS-R0.1.txt` 12/12,
both re-verified at seal). Per the readback §5, **no gate design was
reopened**: W-02–W-05, W-08/D.0a, the PortJ/CI0/DG0/LM0 hardenings, W-12, and
the R-P4/R-P5 sentences are untouched in substance. **No owner disposition is
solicited; nothing is adopted; evidence remains zero.**

| Finding | Severity | Repair | Where (R0.2 files) |
|---|---|---|---|
| **SOL-R01-01** — authority/claim-class conflict (PROPOSED vs "licensed now") | BLOCKER | §F.1 items 1–2 re-classed **CC-3** (no constitutional compression presently licensed; CC-1 facts enumerated separately); ceiling column re-headed *"Strongest sayable / proposed wording (per status)"* with a banner rule that a PROPOSED row's wording is proposed, never licensed; docket F-8's "licensed by a candidate document" → **proposed** by it (candidate text proposes, never licenses); Succession Docket §3's composite-strength "open-ended" ban split — owner-ruled finite-run refusal (Ruling 8) vs P1-candidate every-strength extension, `[PROPOSED]` only | Charter §F.1(1)(2); `CLAIM-CEILING-R0.2.md` banner + header; `OWNER-DOCKET-R0.2.md` F-8; `SUCCESSION-DOCKET-R0.2.md` §3 |
| **SOL-R01-02** — W-01 not mechanically closed | BLOCKER | Token sweep: B.3's four `REFUSED` → `REFUSED CLAIM`; every OPEN sub-annotation normalized to the exact declared forms `OPEN-UNOPENED` / `OPEN-JURISDICTION-CLOSED` (charter rungs 6–10, ceiling rows, docket §4); **documentary lint added and run** — `lint_status_tokens.py`, which caught two real violations on its first pass (a stray SPLIT-mention in a Status line; one bare docket sub-annotation), both repaired; final result **CLEAN, exit 0** | Charter §B.3, rungs 6–10; `CLAIM-CEILING-R0.2.md`; `SUCCESSION-DOCKET-R0.2.md`; `lint_status_tokens.py` (results in RETURN-R0.2) |
| **SOL-R01-03** — terminus / universal spentness residue | MAJOR | D.1 R-P4 row token → "(ACCEPTED EVIDENCE, non-aggregating W-06)"; rung 7 "Would cross" and G.2 subject → fence-eligibility per W-07 (eligibility = relation among person, claim, materials, fence — never a global property); docket F-5 historical note's "terminus" → W-06 wording with the historical term marked | Charter D.1, rung 7, §G.2; `OWNER-DOCKET-R0.2.md` F-5 note |
| **SOL-R01-04** — F-5 revival; LM0/6B overreach | MAJOR | §E.0's "is fork F-5" stale text deleted (Ruling 8 governs; reopens only by express owner supersession); rung 10 "run last" → "recommended last (`[PROPOSED]` procedural edge, W-13/F-11)"; Succession Docket preamble's "every campaign sits behind 6B" → differentiated per-campaign bars, LM0 expressly **named in no stop clause**; docket F-11 default corrected identically | Charter §E.0, rung 10; `SUCCESSION-DOCKET-R0.2.md` preamble; `OWNER-DOCKET-R0.2.md` F-11 |
| **SOL-R01-05** — incomplete W-14 substitutions | MAJOR | Every surviving result-bearing negative universal bounded to the authenticated record: C.11 (transmission), C.19 (no instance), C.22 (succession sources), rung 5 cap ("every existing artifact"), rung 7 ceiling, rung 9, §F.1(5) and §F.1(6) ("no second implementation … exists" → the W-14 sentence) | Charter C.11, C.19, C.22, rungs 5/7/9, §F.1(5)(6) |
| **SOL-R01-06** — source custody closure | MAJOR | **Master commission incorporated by identity, not transcription**: `LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-FABLE-COMMISSION.md`, sha256 `a1d87146…` verified on the delivered file (4,157 words), its three part-filed sentences grep-verified byte-present — **A-1 CLOSED**; the R0.1 partial filing superseded per its own clause, preserved; the R0.1-commission filing's "verbatim" certification corrected in RETURN-R0.2 §4 (the received "in ." was a rendering gap, certified as received-as-rendered only); A-3/A-4 quote alterations repaired (SUPERSESSION-MAP quote → marked paraphrase in §A.1 and §H.4; Ruling 5A "Portability is not established." restored source-exact; settled account restored to owner-stated LANG/non-enumerable-residue form in §F.2) | Charter banner, §A.1, §F.2, §H.4, rung 6; the filed commission; RETURN-R0.2 §4 |
| **SOL-R01-07** — same-root rechecks called "independent" | MAJOR | Cannot edit frozen RETURN-R0.1; corrected of record in RETURN-R0.2 §4: the R0.1 sentence is restated as **"three separate same-root rechecks"**, and every R0.2 summary uses only that form | RETURN-R0.2 §4 |
| **SOL-R01-08** — mechanical residue | MINOR | D.1 "This charter (R0)" → "(the R0/R0.1/R0.2 line)"; charter closing → R0.2; ceiling footer → R0.2; docket footer → R0.2 line; docket manifest pointer → `SOURCE-MANIFEST-R0.1.txt`; ledger EV-22 "32 lines" → "31/31 lines, directly authenticated"; RETURN-R0.2 states the exact hand count (eight agent hands across R0/R0.1; three more at R0.2 — all same-root); `SOL-HOSTILE-RETURN-R0.md` mode normalized `100755` → `100644`, bytes untouched (sha unchanged) | All five R0.2 successors; RETURN-R0.2; the mode-only git change |

## Not reopened (readback §5, obeyed)

W-02 · W-03 · W-04 · W-05 · W-08/D.0a · R-P4/R-P5 exact sentences and
non-aggregation · PortJ-L/0 anti-lookup-table design · CI0 task-generation and
capacity separations · DG0 topology-equivalence and mutation controls · LM0
task envelope, role separation, statistical design, bounded memorization
control · W-12 clauses · the docket's broad triage · R0 byte-preservation ·
zero-evidence standing · all non-commencement clauses.

*— Concordance R0.2, the chair (Claude Fable 5), 2026-08-11. Candidate; adopts
nothing; solicits nothing.*
