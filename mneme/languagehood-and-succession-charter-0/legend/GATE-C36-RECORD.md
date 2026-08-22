# GATE RECORD — Instrument C.3.6: FIRST DETERMINISTIC GENERATION + READBACK — PASSED

**2026-08-12. Chair record (Claude Fable 5).** Per clause C.3.6 of the
owner-adopted Disposition Instrument /0, cross-lane constitutional reliance
on the derived status legend begins only after the generator exists and its
first deterministic generation and readback succeed against the
authoritative sources. Both conditions are now RECORDED AS MET:

1. **Generator exists and is inspectable:** `legend/generate_legend.py` +
   registry `legend/legend-sources.json` (19 entries, 10 conferring
   instruments), built by FABER-LEGENDI (Opus agent), verified by the chair.
2. **First deterministic generation:** chair re-ran the generator twice this
   session — exit 0 both times, output byte-identical at sha256
   `edb63828d8c48e9d0475e214e6d0eb9f6c7904219964bc30dd54c3e6ac069464`,
   matching the builder's independently recorded hash.
3. **Readback against authoritative sources:** every anchor is verified as a
   literal substring of its cited instrument at generation time
   (fail-closed); the builder additionally re-verified 19/19 anchors with
   grep -F and 10/10 instrument hashes with sha256sum -c outside the
   generator's code path (`READBACK-FIRST-GENERATION.md`).
4. **Teeth (a gate that has never fired is untested):** the builder's
   planted fault fired, AND the chair independently planted a second,
   different fault (case-mutation of the W-04 anchor in a temp registry) —
   exit 2, stderr named the failing id and reason, no output written, the
   good output's hash unchanged.

**Effect:** the C.3.6 condition is satisfied; per the instrument, cross-lane
constitutional reliance on `STATUS-LEGEND-GENERATED.md` is now EFFECTIVE —
subject always to C.3's standing terms: the legend confers nothing; an
originating instrument wins automatically on conflict; re-derived, never
hand-edited, after every owner ruling affecting its contents; any future
generation/readback failure blocks updated reliance (C.3.7) and never
alters underlying standing.

**Bounds, carried from the builder's own limits section:** anchor
verification proves textual presence and file identity, never
meaning-fidelity (that remains a reading duty); sub-annotations and notes
are unanchored gloss; registry completeness is an editorial claim the
machinery does not check.
