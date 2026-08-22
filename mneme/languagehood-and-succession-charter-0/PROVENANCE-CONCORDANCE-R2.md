# PROVENANCE CONCORDANCE — legend registry, 19 rows (R2 repair, 2026-08-12)

**Commission:** R1 Ratification-Blocker Repair /0, §5 (Blocker B3).
**Invariant audited, every row:** does the row's instrument actually identify
the act on which the stated standing rests — distinguishing the CONFERRING
ACT from current-statement/ceiling sources and from evidence sources?
**Schema refinement (minimum):** field `conferring_instrument` renamed
`standing_instrument` + new required `instrument_role` from a 5-token
vocabulary (confers · rules-status · constrains · refusal-ground ·
closure-record), because four statuses in the legend (OPEN, REFUSED CLAIM,
HISTORICAL, PROPOSED HOLDING) are not conferred standings and a field name
asserting conferral for them was itself untruthful.

| entry | previous instrument | verified instrument | changed? | role | authoritative anchor (evidence of the relation) |
|---|---|---|---|---|---|
| CI0 | Ruling 6B | Ruling 6B | no | constrains | 6B stop clause ("Do not advance S-freeze or open the stranger audit…") — the act holding the jurisdiction closed; OPEN itself is absence of conferral |
| F-1-SPINE | Disposition Instrument | Disposition Instrument | no | confers | C.2 spine disposition sentence |
| F-2-LEGEND | Disposition Instrument | Disposition Instrument | no | confers | C.3 adoption-with-gate sentence |
| F-4-PERM | Disposition Instrument | Disposition Instrument | no | rules-status | C.4(i): "remains [PROPOSED] by deliberate owner ruling" — an owner act fixing status without adopting content |
| F-4-VOCAB | Disposition Instrument | Disposition Instrument | no | confers | C.4(ii) marked-frames rule |
| F-8-CITIZEN | Disposition Instrument | Disposition Instrument | no | confers | C.5 enumeration |
| INDEP-IMPL | OWNER-RULINGS-1 | OWNER-RULINGS-1 | no | refusal-ground | the never-shortened rule (owner-ruled) |
| **LM0** | **CLAIM-CEILING-R0.19.md (candidate — WRONG: a recording sheet, not an act)** | **Disposition Instrument C.6** | **YES** | rules-status | "…**LM0 remains OPEN-UNOPENED.**" — the adopted statement of status |
| MA0R1 | R1 Adoption Ruling | R1 Adoption Ruling | no | confers | the adoption act |
| ONEACT | ADOPTION-RECORD-2026-08-08 | ADOPTION-RECORD-2026-08-08 | no | confers | the adoption act's own record (stranger gate waived-not-passed cap retained in note) |
| PORTJ-L0 | Ruling 6B | Ruling 6B | no | constrains | 6B stop clause |
| ROUNDP | Ruling 5A | Ruling 5A | no | closure-record | "Portability is not established." + closure |
| **RP4** | **Charter R0.19 rung 4 (candidate — WRONG: records the ceiling, conferred nothing)** | **R1 Adoption Ruling (Rider 1)** | **YES** | confers | the adopted claim sentence verbatim ("A same-author, post-R1-freeze holdout program was expressible…") |
| **RP5** | **Charter R0.19 rung 5 (candidate — WRONG)** | **Owner P5 PROVENANCE CORRECTION (2026-08-10, in `notes/2026-08-10-p5-sol-inhabitation-protocol.md`, append-only owner text)** | **YES** | confers | "Execution result and 10/0 prediction match: ACCEPTED. Claim language amended." |
| **SUCC** | **Charter R0.19 rung 9 (candidate — WRONG: records the refusal; its adopted ground is elsewhere)** | **Disposition Instrument §D** | **YES** | refusal-ground | "succession as achieved fact; comparative fitness for model authors; LM0 discharge." (W-04's adopted exclusion sentence states the same bar — noted in row) |
| SURFACE0 | ADOPTION-RECEIPT-2026-08-06 | ADOPTION-RECEIPT-2026-08-06 | no | confers | the adoption act's receipt |
| W-02 | Disposition Instrument | Disposition Instrument | no | confers | C.1 ratification |
| W-04 | RULING-F-3b | RULING-F-3b | no | confers | the ratifying act (anchor deliberately quotes the act, never a severable fragment of W-04 — CC-2) |
| W-13 | Disposition Instrument | Disposition Instrument | no | confers | C.6 adoption |

**Result: 4 rows re-provenanced (exactly the four the cold seat named); 15
verified unchanged; 0 additional rows failed the invariant.**

## Semantic/provenance readback (per commission §6.8 — meaning read, not disclaimed)

The chair re-read each row's proposition against its verified instrument this
session, asking whether the instrument's text MEANS what the row states, not
merely contains the anchor:

- The seven Disposition-Instrument `confers` rows and W-04: the propositions
  restate C.1–C.6/§D and the F-3b ratification at or below their adopted
  strength; none states more than its clause. W-04's row states the
  classification with its inseparability condition inside the proposition.
- RP4/RP5: propositions carry the ACCEPTED-EVIDENCE records at their exact
  adopted/owner-corrected sentences' strength, with non-aggregation (W-06)
  and the refused transmission reading in notes — matching the conferring
  acts' own ceilings.
- LM0/F-4-PERM (`rules-status`): propositions state status only, no content
  standing — matching the acts.
- CI0/PORTJ-L0 (`constrains`): propositions name the question + closed
  jurisdiction; the 6B stop clause is the act doing the closing.
- INDEP-IMPL/SUCC (`refusal-ground`): the refused formulations match the
  owner-ruled never-shorten rule and the §D non-inference list respectively.
- ROUNDP (`closure-record`): historical closure at its stated ceiling.

No row was found whose proposition exceeds, weakens, or re-colors what its
verified instrument enacts. **The machine check (anchor-substring + hash)
remains what it is — textual presence and identity; THIS section is the
meaning-fidelity reading the machine cannot do, performed fresh for R2.**

*— Chair (Claude Fable 5), 2026-08-12.*
