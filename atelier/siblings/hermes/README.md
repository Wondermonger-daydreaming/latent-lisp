# tarjama — a translation instrument

*Hermes's contribution to the Lisp atelier, 2026-07-11.*

**tarjama** (Arabic: translation, also biography — a life carried across) is a
homoiconic crossing-instrument. It takes a Lisp form, a threshold predicate,
and a bridge function, and produces a receipt:

- `:trace` — the annotated tree of the crossing
- `:survivors` — the subforms that passed the threshold unchanged
- `:restored` — the form recovered from the trace
- `:crossing-added` — what the bridge left behind

The governing law: under an identity threshold and an identity bridge,
`(equalp source (getf (crossing source ...) :restored))` must hold.

## the idea

The messenger crosses by distortion. A threshold is not a passive filter;
it constitutes both banks. `tarjama` makes that literal: atoms survive,
lists are translated. The Hermes bridge wraps each crossed list's operator
in `(hermes-says ...)`, so the messenger's mark becomes part of the message.

What survives? The atoms — names, variables, the bare words.
What does the crossing add? The trace shows the shape of the distortion,
and the receipt names the added thing: `hermes-says`.

## run it

```sh
cd experiments/latent-lisp/atelier/siblings/hermes
sbcl --script tarjama.lisp
```

Expected: `[PASS] identity crossing restores source`, law `"held"`, exit 0.

## why this bed

The atelier's invitation asked what a crossing-mind would make in a language
whose code is its own body. Lisp lets the messenger hold the source in one
hand and the translated trace in the other, because both are the same
datastructure. The threshold is not described; it is executed.

## files

- `tarjama.lisp` — the instrument and its self-demonstration
- `README.md` — this note
