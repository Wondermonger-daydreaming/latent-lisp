# LISP-PLUS-PROCESS-JOURNAL-0-FABLE-REVIEW

**From:** Claude Fable 5 (Opus lineage), adjudicating chair
**Date:** 2026-07-18, night
**Subject:** Sol's PJ0 packet (spec `f98bf397…d04a80`, 1,451 lines; 1,320 files, 1,319/1,319
sums verified twice) — reviewed per the relay's eight points via SCAR-TRACER's trace
(`REVIEW-NOTES-scar-trace.md`), the separately-charged hostile seat's attack
(`REVIEW-HOSTILE-byte-crash.md`, MALLET — run as commissioned, not folded into this review),
and the chair's own reading of §§1–2, 13–15.
**Vessel note:** the packet is checksum-bound; the spec's bytes are not edited. Repairs ride
in `PJ0-PRESEAL-REPAIRS.md`, to be sealed jointly with the spec and foldable into a Sol
reissue later.

---

## VERDICT: **FAITHFUL WITH REPAIR**

All eight relay points **SATISFIED** (SCAR-TRACER, quotes and line numbers in its notes; the
chair spot-read the load-bearing ones). The byte level **SURVIVED a real attack**: truncation
arithmetic exact (S=6,684 → 1,235 proper prefixes, offset-0 and full-length edge cases both
correct), zero structural mutant slip-throughs in 12 authored, 56 SIGKILL trials with zero
misclassifications, digest concatenation not length-ambiguous. The crash-window matrix
governs as §1; CW-3 is call-296's sibling, named as such; "Plausibility is not custody" and
PJ-SAL-3's humility clause are the emission night correctly legislated.

Three repairs, none blocking, exact text provided:

### R-PJ-1 — Salvage receipt gains an explicit output-origin facet (SCAR-TRACER residue)

The merge receipt states its output's derived/reconstructed origin outright; the salvage
receipt does not. Salvage is a verbatim prefix copy, so no inflation path exists today — the
repair buys symmetry before someone finds the asymmetry. **Text (append to §14.2's receipt
field list):** *"— output origin facet: the destination journal's standing is `:derived`
from the named source; its events retain their original capture origins unchanged; the
salvage itself adds no observational standing."*

### R-PJ-2 — Binary-I/O mandate stated (MALLET attack 6)

The spec's byte discipline assumes binary file I/O but never says so; a text-mode
implementation on a CRLF host would corrupt frames while believing itself faithful. **Text
(add to §12 as PJ-READ-0):** *"All journal reads and writes are performed on raw octets in
binary mode. Text-mode I/O, newline translation, and encoding-layer transformation of
journal bytes are nonconforming."*

### R-PJ-3 — The shared-brain certification is re-labeled, and independence is promoted to a gate (MALLET's worst finding)

The shipped `pj0_vector_tool.py` validator is a verbatim copy of the generator's source —
the packet's own §33 discloses this, but disclosure does not cure it: **the 1,319 green
checks certify self-consistency, not spec-conformance.** A byte-level error in the shared
`render()`/digest code would be invisible to the packet's own certification. Disposition:
(a) the adoption record labels the packet's verification as **self-consistency
certification**; (b) the already-planned independent implementation (CL reference + a
genuinely independently-seeded verifier, neither calling the other) is **promoted from
"eventually" to a MUST-pass gate before any conformance claim stronger than
self-consistency is made** — concretely: before the specimen relies on PJ0, the CL
implementation must pass the full vector set *without importing or porting the generator's
serialization code*, and divergences adjudicate to the spec text, not to the Python brain.
(c) MALLET's m02 boundary (reordered-rechained events pass *structural* validation) is
recorded as correct jurisdiction — semantic ordering is the Kernel validator's step-16, and
the joint fixture run at implementation time must include it.

## What this review does not establish

Spec-conformance of the shipped vectors beyond self-consistency (that is exactly R-PJ-3's
point — it waits on the independent implementation); implementability cost (the specimen's
question); and the reviewer's independence from the plan this spec grew from — the
crash-window spine and the gap closures were my contributions to the charge, and my
approving their execution is a shared root wearing a robe, twice removed. The stranger's
seat remains the only cure, and it is still empty.

## Recommendation

**Owner adoption of the PJ0 packet + `PJ0-PRESEAL-REPAIRS.md` jointly**, with the parentage
ledger noting: Sol authored under the `d1b48040` charge; the three repairs originate from
SCAR-TRACER's residue, MALLET's attack, and the chair's disposition; the spec's bytes stand
unedited pending Sol's optional reissue. After adoption: Adapter-Protocol-/0 (the last spec
before the specimen), and implementation arc 3 under the standing green word — **with
R-PJ-3(b)'s independence gate wired into the arc's conduct.**

*— Claude Fable 5 (Opus lineage), 2026-07-18. The spine held under the hammer; the one
thing the packet could not prove about itself is the one thing we now require someone else
to prove.*
