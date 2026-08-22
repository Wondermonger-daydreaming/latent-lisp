# SPEC DEFICIT REGISTER — ERRATUM 1 (2026-08-12)

**Filed by the chair (Claude Fable 5) under PS/0 Parcel 1, D-6 authorization:
PUBLIC SUFFICIENCY /0 — OPENING DISPOSITION INSTRUMENT /0 (2026-08-12, commit
`575db52f`): "Register erratum round: AUTHORIZED, as a disclosed erratum (never
a silent edit)." Append-only. This document is the disclosure; the register
carries the corrections in place as an in-place successor whose
candidate-successor status is discharged on parcel acceptance per D-3.**

**Erratum model (the repository's lawful form):** the pre-edit register blob
remains frozen documentary history in Git custody; this erratum identifies each
mistake and its verified ground; the corrected current reading lives in the
register beside the preserved original wording. Nothing was deleted: the edit
is **52 inserted lines, 0 removed lines** (`git diff --stat`).

## Identity

| | blob | sha256 |
|---|---|---|
| **Before** (as committed `12388ff9`, unchanged through `575db52f`) | `041b6203c28327579d44a3446bf84ceef485193a` | `c5b1805ea958dad1645266b28b03eefe4eb9dc0c01e37ca79bf9816ad22e835f` |
| **After** (ERRATUM-1 applied) | `762489f9545a965ac5d1045039f867c5a968eff6` | `0fa4b13f75f485639fa9606c9c8d04860dbf427b7a90039425596c99d8cc0e83` |

**Line-anchor notice:** citations of register line numbers made before
2026-08-12 (e.g. the authentication dossier's "register `:72-75`") anchor to
blob `041b6203`, not to the current file. Re-anchor against the blob, not the
successor.

## The corrections, each with its verified ground

| # | Site | Mistake | Verified ground (chair-run, 2026-08-12) |
|---|---|---|---|
| 1 | Header, standing block | No notice that an erratum round occurred | (administrative; this table) |
| 2 | Header, base paragraph | *"The base is itself NOT owner-adopted"* — true at register commit, superseded 70 minutes later | `git show -s` timestamps: register `12388ff9` 2026-08-10 14:14:49 −03; MA0 R1 adoption `2b69c18c` 15:24:31 −03 |
| 3 | SD-13 "Where it lives" | `language-act-0/` enumerated as six files; actually **ten** tracked; the four omitted are the sole carriers of comment-only law C4-01…C4-11 — the enumeration UNDERSTATED the deficit | `git ls-files` count = 10 (pre-Parcel-1); dossier §A.5 finding re-verified |
| 4 | SD-13, end of entry | No record of the owner's disposition | Opening Disposition Instrument /0 D-1/D-2; status formula carried **verbatim**: "SD-13 — DISPOSED BY SCOPED EXCLUSION, NOT CURED BY PUBLICATION" |
| 5 | SD-05, end of entry | Cure landed but unrecorded | AUTHOR-GUIDE §10 cap 9 now reads teeth *"have been built and run"* (`AUTHOR-GUIDE.md:377-381`) |
| 6 | SD-06, end of entry | Cure landed but unrecorded | CONTRACT §6 lists `ma0-environment-stale`(+`-store-id`) with R1/D4 disclosure (`MANY-ACTS-0-CONTRACT-CANDIDATE.md:86-111`) |
| 7 | SD-20, end of entry | Cure landed but unrecorded | CONTRACT environment signature includes `:revocations` with disclosure (`MANY-ACTS-0-CONTRACT-CANDIDATE.md:88-97`) |
| 8 | §2 roll-up | No disposition census | Recount: 1 + 3 + 24 = 28 ✓; entry count re-verified `grep -c '^### SD-'` = 28 |

SD-05/SD-06/SD-20 status: **CURED-BY-PARCEL-A**, Parcel A accepted by Owner
Ruling 4 (`OWNER-RULING-4-PARCEL-A-ACCEPTED-ROUND-P-PENDING-2026-08-10.md`);
successor status **DISCHARGED per D-3** ("acceptance discharges").

## D-3 standing treatment (what this erratum does and does not repair)

D-3 rules that parcel acceptance discharges candidate-successor status, and
directs the repair at the **classifier's standing logic** — the model must
represent authoritative acceptance rather than treating blob inequality as
constitutional ontology. Accordingly:

- accepted historical parcels are **NOT rewritten** by this erratum (Git diff
  is evidence of byte difference, not constitutional standing);
- this register's own in-place successor is created under that same logic and
  is discharged on this parcel's acceptance;
- the Parcel-B execution return's §8.2 over-inclusive classification receives
  its disclosed correction **at its next lawful revision**, per the
  instrument's own routing — deliberately NOT edited by this parcel.

## Boundaries

1. **No other deficit is cured or re-scored.** The severity movements the
   Opening Disposition Instrument derives on the register's own conditionals
   (SD-03, SD-26, SD-28, SD-04's flag) are recorded in that instrument, not
   here — re-scoring is outside D-6's scope.
2. **Zero evidence.** This erratum creates no evidence of public sufficiency,
   conformance, or independent review; it repairs the register's account of
   already-ruled facts. SD-13 remains DISPOSED BY SCOPED EXCLUSION, NOT CURED
   BY PUBLICATION.
3. **Non-extension.** Nothing here extends the register, adds entries, or
   alters any entry's cure class or severity as drafted.

*— Claude Fable 5, chair, 2026-08-12.*
