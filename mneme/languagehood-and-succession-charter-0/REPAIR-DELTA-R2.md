# REPAIR DELTA — R1 → R2 (class-tagged census, 2026-08-12)

**Authority:** the owner's R1 Ratification-Blocker Repair /0 commission.
**Base:** R1, sha256 `fd382dee0292ed297a6d3cf4d8a5c9a257cabd34913c0f2c03b10f06b51648a5`.
**Successor:** R2, sha256 `e11a03ca180cddf4494f7d58ed9496f1f2af4c4b5bf8975058ba8cf3043ff534`.
**Charter diff: 70 changed lines, confined to exactly three surfaces.**
Every changed byte falls in an authorized class (commission §8):

| Surface | Change | Class |
|---|---|---|
| Charter banner | R1→R2 identity, repair authority, succession metadata, BLOCKED notice | 7 |
| Charter §A.2 | full C.3.5 carriage restored: "generation source must be named and inspectable, **stated in a header carrying source and date**"; gate re-establishment pointer (`GATE-C36-RECORD-2.md`); prior gate record marked historical | 2, 6 |
| Charter §E.0 | W-13 restored **verbatim** as a blockquote (colon, "either", unbroken text); paraphrase carriage removed; pin/boundary annotations preserved unchanged | 1 |
| `legend/legend-sources.json` | registry v2: `generation_date` + `generation_date_denotes` (explicit controlled datum); field renamed `standing_instrument`; required `instrument_role` (5-token vocabulary) on all 19 rows; four rows re-provenanced (LM0, RP4, RP5, SUCC) | 3, 4 |
| `legend/generate_legend.py` | validates date presence/format + denotes + role vocabulary, fail-closed; header renders source AND date with recorded meaning; column/messages renamed for schema truthfulness | 3, 4 |
| `legend/STATUS-LEGEND-GENERATED.md` | mechanically regenerated (sha `8e3f5741ee647ac3f90e53d0471819302b0e54c207fbc47241a341d0979c1667`) | 5 |
| This file, `PROVENANCE-CONCORDANCE-R2.md`, `GATE-C36-RECORD-2.md` | receipts/evidence of 1–5 | 6 |

**Nothing else changed.** Frozen strata untouched; R1 preserved byte-identical;
no owner disposition revisited; W-02/W-04/F-1(19/8/3)/directive-3.9/F-4/F-8
surfaces untouched except where a listed class required (none did); the W-13
§J pin and the W-04 ratifying-act anchor construction preserved.

## Blocker A proof — W-13 exact equality (mechanical)

Extraction rule: the adopted line of the instrument stripped of its
blockquote marker `> `, versus R2's carried line stripped of leading
whitespace + `> `. Result this session:

    adopted len: 429  carried len: 429
    EXACT EQUALITY: True

(The compared string is the full bolded W-13 text including the colon after
"edges", the word "either", and the closing sentence.)

## Blocker B1 proof — C.3.5 carriage

R2 §A.2 now carries, in the adoption's own terms: *"its generation source
must be named and inspectable, stated in a header carrying source and
date."* R1 had carried only the named/inspectable half.

## Blocker B2 — date semantics (recorded precisely)

The date is an **explicit controlled datum**: registry field
`generation_date` = 2026-08-12, whose recorded meaning
(`generation_date_denotes`) is the effective date of the registry revision
— the date of the governing owner acts and of this repair commission. It
changes only when the registry is revised under a recorded act. The
generator validates presence and ISO shape and **fails closed** on
omission/malformation; it reads no clock; identical inputs produce
byte-identical output (proven below).

## Regeneration + negative-control evidence (chair-run, this session)

- Fresh generation: exit 0, 19 rows, 9 distinct standing instruments.
- Determinism: two runs byte-identical at `8e3f5741…`; a post-battery third
  run reproduced the same hash.
- Fail-closed battery: **11/11 fault classes fired** (chair's anchor
  corruption; missing instrument; status outside vocabulary; short anchor;
  duplicate id; blanked field; malformed JSON; missing date; malformed
  date; empty date-denotes; role outside vocabulary) — each exit 2,
  nothing written, and the good output's hash **byte-unchanged through all
  eleven** (the specified invariant).

*— Chair (Claude Fable 5), 2026-08-12.*
