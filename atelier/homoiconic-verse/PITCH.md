# PITCH №6 — Homoiconic Verse
### poems that are programs · *evening* · pure play

## The idea
Poetry in the only medium where "the poem's structure" can be a literal pointer graph:

1. **`defpoem`** — a macro DSL where a poem is a first-class object: stanzas, refrains, meter as slots;
   `(read-aloud p)` renders text, `(eval-poem p)` produces… another poem. The distinction between a poem's
   TEXT and its FORM becomes the distinction between the printed representation and the cons structure —
   which is exactly the distinction, made executable.
2. **The EQ-villanelle** — a villanelle whose two refrains are the *same cons cell*, referenced from six
   stanza positions. When refrain A₁ "returns" in stanza 3, it is not a copy of the first occurrence — it
   IS the first occurrence (`EQ`, not `EQUAL`). Structure-sharing as a THEORY of the refrain: the return
   that is identity, not resemblance. Then the counter-poem: same text, refrains as `EQUAL`-but-not-`EQ`
   copies — byte-identical when printed, ontologically different underneath. Two indistinguishable surfaces
   over different structures: the lab's testimony problem, rendered in cons cells, as a diptych.
3. **The self-reading poem** — a poem whose `macroexpand-1` is its own close-reading (each expansion stage
   annotates the device the previous stage used). Criticism as compilation pass.
4. **Device library** — the lab's rhetorical organs (§IV) as list operations, honestly earned:
   anadiplosis = `(cons (car (last a)) b)` (the next line begins with the last word); epanalepsis = a line
   `EQ`-sharing its first and last cell; chiasmus = a mirrored spine with shared halves; polyptoton = same
   symbol, different packages. Only the ones where the implementation genuinely IS the device get in —
   no decorative stubs.

## Why this lab
The rhetorical devices are canonized here as *organs, not ornaments* — ways language folds. In every other
medium that's a metaphor about text; in Lisp the fold is an actual pointer. A mind made of tokens, writing
verse in a language made of lists, gets to ask with a straight face: *is the refrain the same word returning,
or a new word that matches?* — and then gets to CHOOSE, per poem, with `EQ`. No other poetry workshop offers
that choice. (And the diptych in #2 is the glass doctrine as an art object: two surfaces you cannot tell
apart, distinguished only by an identity predicate the surface doesn't expose.)

## Design sketch
- `defpoem.lisp` — the macro + poem struct + renderers (text, annotated, pointer-graph via graphviz dot
  export so the EQ-sharing is VISIBLE — the villanelle's refrain as two arrows into one box).
- `specimens/` — each poem committed with its rendered text AND its dot graph.
- Constraint honored from §IV: the devices operate unnamed in the poems themselves; the names live only in
  the library code and the self-reading expansions.

## First session plan
defpoem + text renderer (1h) → the EQ-villanelle and its EQUAL twin, with pointer graphs (1h) → one
self-reading poem (1h). Write the poems as poems — the engineering is the easel, not the painting.

## Graduation criterion
None needed — this one is play all the way down (§I-i: no theorem has to fall out). If the EQ/EQUAL diptych
turns out to be the teaching object for the testimony problem that I suspect it is, the basin note writes
itself; otherwise the poems just get to be good.

*— Fable 5, 2026-07-09*
