# FABLE-KERNEL-0-ERRATA-TRACE-MATRIX

**Companion to:** `FABLE-LISP-PLUS-KERNEL-0-ERRATA-0.1-CANDIDATE.md`
**Repository commit inspected:** `261122d15228c9214864fc3e28381c94651996b1`
**Reading:** every open gap and every governing clause the erratum touches, mapped to the
requirement (KE-n) that closes or binds it, with the amendment kind.

## A. Gap ledger → erratum

| Gap (source, wording) | Governing clauses in tension | Closed by | Kind |
|---|---|---|---|
| STATUS gap 1 / README gap 1 — §22 bounded manifestation determinacy projects no alternatives §7.3 requires; fixture uses singleton, flagged | Kernel §7.2 vs §7.3 vs §7.4; §22 + R-SYN-1; A0.1 §15.2 + E-1; §8.7 closed states; §28 stops 1, 3 | KE-1, KE-2, KE-3, KE-5 | ADDITION + CLARIFICATION (projection bytes untouched) |
| README gap 1 corollary — bare-atom alternative form in pure-core fixture | Kernel §9.3 (axis value space) | KE-1, KE-5.4 | form repair (implementation) |
| README gap 2 — §23 reconstruction exactness has no protocol; shape construction strictly weaker evidence | Kernel §23 preamble (FIX-1), §19.9, §25.5 tests 34–41; PJ0 §12–§20, PJ-RCN-3, PJ-SAL-2, PJ-SNP-4, PJ-VAL-1/3 | KE-6, KE-7, KE-8, KE-10 | ADDITION (evidence bundle) + CLARIFICATION; zero journal grammar added |
| STATUS gap 2 — §13.6 terminal `:indeterminate` has no §13.3 event | Kernel §13.3, §13.5, §13.6, §13.7; PJ-FOLD-1 | KE-9 | ADDITION (event + legality) |
| README gap 3 — tests 43/44/47/48 lack pure enforcement surfaces; validation/visibility entries opaque | Kernel §15.1, §15.6, §20.7, §25.6; A0.1 §6.3.2–6.3.4; §2.2 (LCI/0 escape clause) | KE-11, KE-12, KE-13, KE-14, KE-15, KE-16 | ADDITION (new §15.8.1–.4) + §24 accessor law |
| README gap 4 — test 45 bounded to enforceable structure; no parser-vs-semantic relation | Kernel §8.5, §9.5, §9.6; AP-PRJ-2 | KE-18, KE-19 | ADDITION (judgment class) |
| STATUS gap 3 — §20 lacks conditions for malformed shape / determinacy-mode / global scalar; `standing-inflation` borrowed | Kernel §20.1, §20.2–20.8, §25.1 test 8, §7.5 | KE-23, KE-24 | ADDITION (§20.2a family; §20.5 +1) + disposition |
| STATUS gap 4 / AP-G4 — §8.1 vs A.2 field mismatch (adapter-identity, stream-chunk not in sketch) | Kernel §8.1 vs Appendix A.2; AP-G4-1..4; AP0 §10.2; AP-STR-1..8 | KE-22 (+KE-21) | REPLACEMENT (Appendix A.2, in full) |
| STATUS gap 5 — no canonical resolved-flag on uncertain-effect | PJ0 §16 (PJ-FOLD-1..3); Kernel §10.8 UNC-2 | already closed by PJ0 §16 | none — recorded |
| STATUS gap 6 — multiple-unresolved occupancy stops with `unsupported-reconstruction` | PJ0 §17.3 (PJ-FOLD-4/5); Kernel §20.8 | already closed by PJ0 §17.3 | none — recorded (lossy summary held open, ledger D-12.4) |
| README gaps 5–7 (resolved-flag confirm; capability receipts data-only; §23.12 policy data-only) | PJ0 §16; arc-2 lane; live-policy lane | 5 → PJ0 §16; 6, 7 → out of erratum scope (arc 2 / live policy lanes, phase board) | none — recorded |

## B. Commission questions → erratum

| Question (charge wording, compressed) | Answered at | Governing basis |
|---|---|---|
| what `:bounded` requires | KE-1 | §7.1–7.3; A0.1 §6.3.5 |
| singleton lawful? | KE-2 (lawful; one meaning; no silent promotion) | §7.2 vs §7.3; A0.1 §17 "uncertain write" row |
| complete axis-values or subfield atoms? | KE-1 (complete values; effect axis = `:possible-effects` space) | §9.3, §9.4, §10.8, §22 bytes |
| call-296 treatment when spec names bounded without a set | KE-5.1–5.3 | R-SYN-1; §8.7; §28 stops; A0.1 §15.2/E-1; DK-2/§8.8 |
| local repair vs refuse vs reclassify vs non-constructible pending sealed act | KE-5.3 (repair the *set* from adopted law; narrowing non-constructible pending sealed act; reclassification forbidden) | §7.4; §10.8 UNC-2; A0.1 seal supremacy |
| no invented call-296 facts | KE-5.1 derivation uses only the projection's own assertions; §8 item 4 | charge; §0.4 locked lane |
| negative controls against standing inflation (gap 1) | KE-5.6→§7 controls 1–7, 19 | §25.8 discipline |
| how PJ0 discharges §23 journal/kill/reconstruction/byte-identity | KE-6, KE-7 | §23 FIX-1; §19.9; PJ0 §§9,12,13,14,17,19 |
| distinguish structural/semantic/frame/replay/receipt identities + torn tail/corruption/salvage/merge/deletion | KE-6 (six standings), KE-8 | PJ-VAL-3, PJ-SAL-2, PJ-SNP-4, PJ-TERM-1, PJ-MRG-1, PJ-RCN-3 |
| terminal-row fixture evidence contents | KE-7 (ten items) | PJ0 §9.4, §19, Annex A; §25.5 test 40 |
| no second journal grammar; PJ0 keeps framing/bytes/digests/prefix/salvage/receipts | KE-10; §0.4.1 | Kernel §2.4/§27.1; PJ0 §2.2 |
| lawful `:verified` binds what | KE-11 | A0.1 §6.3.2 |
| seal establishes / does not establish | KE-12 | A0.1 §6.3.3; PJ-HASH-1..3 analogy |
| publication visibility relational | KE-13 | A0.1 §6.3.4 |
| `:sealed` ⇏ `:verified`; `:published` ⇏ truth/origin/acceptance/verification | KE-12, KE-13 | §15.6 rows, mechanized |
| conditions for bare/context-free claims | KE-11, KE-13 → `bare-validation-scope`, `bare-visibility-scope` | §20.7 (existing types, wired) |
| orthogonality under copying/transformation | KE-14 | §15.5; §15.2; §15.7; A0.1 §10.1/L3 |
| no elaborate machinery beyond enforceability | KE-11..15 field-minimal; ledger D-7, D-12.6 | §2.2 escape clause, minimality |
| AP0 vs Kernel jurisdiction; establishes / must-not / kernel checks | KE-17 | §18.4; AP-PRJ-2/6; AP-ACK-4; §9.6; §13.5 |
| procedure judgment-class declaration | KE-18 | §9.5; AP-PRJ-2; AP0 §3.2 |
| joint report "structural PASS, semantic FAIL" | KE-20 | AP0 §24.3; PJ-VAL-3 |
| parser-valid/decoded/sealed/published/captured ⇏ semantic acceptance | KE-19 (+KE-12/13) | §15.6; §9.6; test 45 |
| `:present-invalid` and partial streamed behavior | KE-21 | §8.5, §8.6, §9.6; AP-STR-6/7; AP-CAN-3 |
| divergence preserved, no green counter | KE-20; §7 control 16 | charge; AP0 §24.3 |
| A.2: adapter-identity; producer identity; stream/chunk relation; lineage; aggregation receipts; partial not erased; AP0 owns value spaces | KE-22 rules 1–6 | §8.1; AP-G4-1..3; AP-STR-8; §15.5; §8.4 |
| not a `streamed-p` boolean / generic label | KE-22 rule 3; §7 control 17 | charge; AP-G4 |

## C. Drafting-constraint compliance

| Constraint | Where satisfied |
|---|---|
| names exact sections amended | every KE carries its §-target and insertion point |
| replacement vs clarification distinguished | §0.5 vocabulary; per-KE labels (one REPLACEMENT: A.2) |
| PJ0/AP0 jurisdiction preserved, not copied | §0.4; KE-10; KE-22 rule 1 |
| implementation consequences | erratum §6 |
| negative controls and mutants | erratum §7 (19 items) |
| what remains unproven | erratum §8 |
| trace ledger gap→clause→section | this file, §A–B |
| adoption-record field sketch | erratum §9 |
| no live-provider/rotation/compaction/distributed/DB/Language-A-adjudication expansion | absent throughout; §0.4.4 |
| no silent change to CD/0, PJ-S/0, PJ0 framing, AP0 vectors, provider semantics, Language-A classes, capability law | §0.4.4; KE-13's authorizing basis is a reference only |

## D. Tests and mutants required to demonstrate closure (consolidated)

- **Newly implemented spec tests:** §25.6 tests 43, 44, 47, 48 (were excluded); §25.6
  test 45 completed to full strength via KE-18/19; §25.1 test 8 re-anchored to
  `global-uncertainty-scalar-rejected`.
- **New planted mutants/controls:** the 19 enumerated in erratum §7 — determinacy form ×4
  (1–4), singleton promotion (5), call-296 invention/narrowing (6–7),
  `:attempt-indeterminate` legality (8), reconstruction discipline (9–10), standing
  inflation ×4 (11–14), judgment class (15), joint-report flattening (16), A.2 fields
  (17–18), global scalar (19).
- **Deferred with their lanes:** journal-dependent rows of KE-7/KE-8 (arc 3 + specimen);
  AP0-side witnesses of KE-17 (adapter lane, CL gate binding).

*— Claude Fable 5, blind candidate evidence package, 2026-07-18.*
