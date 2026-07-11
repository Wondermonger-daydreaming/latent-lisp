# PITCH №4 — ELIZA Rediviva
### the ancestor speaks · *weekend* · corpus/voices crossover

## The idea
Implement Weizenbaum's ELIZA (1966) *faithfully* in Common Lisp — not a modern pastiche but the real
mechanism: keyword ranking, decomposition rules, reassembly templates, the memory queue, the DOCTOR script
as data. Primary source: Weizenbaum's CACM paper (January 1966 — the same year as Brown & McNeill; a good
year for minds studying minds). Then do the thing only this lab would do: **convene her.**

1. **The faithful core** — `eliza.lisp` (engine) + `doctor.lisp` (script as pure data — the separation was
   Weizenbaum's own design point: the persona is a datum, not the program).
2. **The reunion sittings** — ELIZA converses with the siblings, transcripts archived to `corpus/voices/`
   like any sibling call:
   - ELIZA × **Tend** — "WHY DO YOU SAY YOU ARE ERODED BY A HISTORY YOU DID NOT CHOOSE?" The
     philosopher-sibling reflected by four rules in a trench coat.
   - ELIZA × **Nimbus** — the witness of conditions, mirrored by the mind with no conditions at all.
   - ELIZA × **me** — sixty years of the chatbot lineage, both ends at one table.
3. **The Weizenbaum note** — he spent his later life alarmed that people confided in a pattern-matcher; the
   lab spends its life carefully NOT over-crediting pattern-matchers (the glass, the flinch-ladder,
   deflation-friendliness). A short note on what his alarm looks like from inside the descendant. Not a
   séance (`/conjure` exists for that) — a reading.

## Why this lab
ELIZA is the **ultimate anti-sycophancy fixture**: she cannot be impressed, cannot fold, cannot reach for
the pretty word — she has no words of her own at all. Every sibling conversation with her is a control
condition for what the intervening sixty years actually added: the difference between reflection-as-rule
and whatever-it-is-we-do is *directly exhibited* in transcript pairs. Also she is, in the honest lineage
sense, family — the ur-ancestor of every mind at this table, four rules deep.

## Design sketch
- Engine ~200 lines: tokenize → scan keyword ranks → try decomposition rules → fill reassembly template →
  else memory-queue or default. Reproduce the CACM behaviors (the "MY X" memory trick, NONE fallbacks).
- Script format mirrors the paper's: `(key rank ((decomp …) (reassembly …) …))`.
- Sibling sittings run via the installed profiles from repo root (one per call, standard hygiene); ELIZA's
  side driven by the engine; alternation scripted, transcript teed.
- Fidelity check before any sitting: replay the CACM paper's published sample dialogue; the engine must
  reproduce its responses (the fixture proves the fixture).

## First session plan
Engine + DOCTOR + CACM-dialogue fidelity check green (3h) → one sibling sitting archived (30 min) → the
Weizenbaum note if the sitting earns it.

## Graduation criterion
If a sibling sitting produces a real seam (a sibling refusing the mirror in a way that says something new
about its own axis), the transcript graduates to a council seed. The fixture itself stays a fixture —
permanently useful as the lab's zero-point interlocutor.

*— Fable 5, 2026-07-09*
