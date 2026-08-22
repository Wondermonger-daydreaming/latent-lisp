# PS/0 PARCEL 1 — RETURN (D-5 + D-6)

**Constructed by the chair (Claude Fable 5), 2026-08-12, under PUBLIC
SUFFICIENCY /0 — OPENING DISPOSITION INSTRUMENT /0 (commit `575db52f`), which
AUTHORIZED D-5 (owner-instrument publication parcel) and D-6 (register erratum
round). Parcel shape: one bounded documentary parcel in the Owner Ruling 2 §7
return form. Status: PS/0 PARCEL 1 — READY FOR OWNER ACCEPTANCE.**

**Acceptance boundary (why this stops here):** under the §7 form a parcel is
returned as a reviewable package and disposed by a **distinct owner act**
(precedent: Parcel A was ordered by Owner Ruling 2 and accepted only by Owner
Ruling 4). The Opening Instrument authorized *execution*; it did not
pre-accept the return. The owner accepts — or refuses — in one act.

---

## 1. What this parcel contains, exactly (and nothing else)

### D-5 — Five One Act /0 owner rulings, published into the lane

Byte-preserved copies, `_staging/oneact-owner-ruling-*.md` →
`mneme/language-act-0/rulings/`, plus a provenance sidecar
(`rulings/RULINGS-PROVENANCE.md`) carrying the standing labels so the ruling
files stay byte-identical. Verified `cmp` IDENTICAL ×5; source hash =
destination hash for every file:

| File | sha256 (full, re-derived at filing) | git blob |
|---|---|---|
| `oneact-owner-ruling-r0.1-en-2026-08-07.md` | `a4a2438df03c1b2b0a3f8ec9f2cbd5dd4e245ca9b7f3c8afcbd7ef9bba977be1` | `825490ec` |
| `oneact-owner-ruling-r0.1-es-2026-08-07.md` | `8039c5d01381c22d7e554e15101c080d30b2e51c29d7018263a45b461c98005f` | `f23a8636` |
| `oneact-owner-ruling-r1-2026-08-07.md` | `4586653305772a107267721a7f733a527bdb1262c7e4e30babb07ae534aaf7ca` | `12ef101d` |
| `oneact-owner-ruling-r2.2-2026-08-08.md` | `c1f1d358b6bf16cf568f3e7355b6d3a211599783d8e09c1b2587cd2d35dbb690` | `a9cf29b6` |
| `oneact-owner-ruling-r2.3-2026-08-08.md` | `016bdd80c4932a6035bd5acd3a0e281a9a95b71decbecd5ba369c6d880d189bc` | `18d29e0a` |

**Standing labels (sidecar carries the full text):** R0.1-EN, R2.2, R2.3 =
direct owner instruments, [R] tier, chair-transcribed in-session. **R1 = CHAIR
TRANSCRIPTION** of an owner instrument, so labelled. **R0.1-ES: species
difference reported** — the working shorthand "R0.1 EN+ES = two languages of
one ruling" does not match the file record: per its own same-night authorship
correction, R0.1-ES was authored by **GPT-5.6 Sol** as an owner-relayed
fresh-chair review, and R0.1-EN is the owner instrument that *adopts it with
modifications*. Both publish (D-5 names both); neither is appointed
authoritative; **SLOT-2 (R0.1's authoritative language) remains open and
travels with this return.**

**SLOT-1** (terminal One Act adoption scope sentence) remains an owner-only
datum; nothing in this parcel reconstructs it.

### D-6 — Register erratum

`portable-judge-0/SPEC-DEFICIT-REGISTER-ERRATUM-1.md` (the disclosure) + the
in-place register successor per D-3. Register before → after:

| | blob | sha256 |
|---|---|---|
| before | `041b6203` | `c5b1805e…d22e835f` |
| after | `762489f9` | `0fa4b13f…d8cc0e83` |

Redline: **52 insertions, 0 deletions** — every original sentence preserved;
corrections stand beside the history they correct. Corrections executed
(each ground verified mechanically this sitting; full table in the erratum):
base-standing header (adopted 70 min after register commit — timestamps
exhibited) · SD-13 ten-file enumeration (git ls-files = 10; understatement
direction noted) · SD-13 disposition restated with the status formula
**verbatim** · SD-05/SD-06/SD-20 marked CURED-BY-PARCEL-A, discharged per D-3
(cures verified at current doc line numbers) · roll-up disposition census with
arithmetic (1 + 3 + 24 = 28 ✓; entry count re-verified = 28).

**Deliberately NOT done:** no re-scoring of SD-03/SD-26/SD-28/SD-04 (those
movements live in the Opening Instrument); no edit to the accepted Parcel-B
return (its §8.2 correction is routed to its next lawful revision by the
instrument itself); no register adoption (it remains CANDIDATE); no other
deficit touched.

## 2. Publication-status precision (the guard is not bypassed)

Branch: `many-acts-0-candidate`. `merge-base --is-ancestor` of HEAD into main
**fails** — therefore everything in this parcel is
**CONSTRUCTED + COMMITTED, NOT MIRROR-PUBLISHED.** The five ruling copies
become mirror-visible only at the owner-gated merge to `main`, through
`sync.sh`'s main-ancestry guard, which this parcel does not touch. No
statement in this parcel may be read as "PUBLISHED" in the external sense.

## 3. No-unrelated-change check

The parcel's exact file surface (git delta of the parcel commit is the
authoritative list): 5 ruling copies + 1 provenance sidecar (new) ·
1 erratum document (new) · 1 register successor (52-line insertion-only edit) ·
this return. No implementation, runtime, gate, fixture, or frozen artifact
changed. Frozen strata untouched: Round P/OA evidence, `71422395` originals,
Parcel A/B returns, all owner rulings.

## 4. Earned / not-earned

**Earned: nothing.** This parcel creates zero evidence of public sufficiency,
conformance, portability, or independent review. It transports owner words the
public corpus lacked and corrects a register's account of already-ruled facts.
SD-13 remains **"DISPOSED BY SCOPED EXCLUSION, NOT CURED BY PUBLICATION."**
The stranger audit remains OWED where owed. The Opening Instrument's four
ceilings travel with every citation of this return.

## 5. The acceptance proposition (for the owner, one act)

> **ACCEPT PS/0 PARCEL 1**: the five owner-ruling copies with their provenance
> sidecar as filed, and Register Erratum 1 with its in-place successor, whose
> candidate-successor status this acceptance discharges per D-3. Acceptance
> does not answer SLOT-1 or SLOT-2, does not adopt the register, does not
> elevate any candidate document, and creates no evidence.

*— Claude Fable 5, chair, 2026-08-12.*
