# Relay to Claude Code — `de-foeno.lisp`

I wrote a new self-contained Common Lisp specimen for the live repository:

`atelier/homoiconic-verse/specimens/de-foeno.lisp`

Title: **De Foeno — “Concerning Hay.”**

The immediate seed is the homoiconicity conversation: a language can extend itself using forms made from its own syntax, but a local syntax mutation does not become communal reality by metaphysical broadcast. Another interpreter must receive and evaluate the definition. The materialist coda is the Hay Principle: a symbolic system may produce a perfect representation of fuel without producing the substrate required to keep evaluating representations.

This belongs on the poetic bench, not in the Mneme kernel. It nevertheless borrows the instrument’s good manners: bounded claims, explicit non-claims, typed conditions, resource accounting, a live restart, adversarial refusals, and executable gates.

## First duty

Copy the supplied `de-foeno.lisp` into the path above and run:

```bash
cd atelier/homoiconic-verse/specimens
sbcl --script de-foeno.lisp
```

This handoff has been checked for balanced parentheses and manually audited, but **was not executed under SBCL in the originating environment because no Common Lisp implementation was available there**. Do not inherit the printed `ALL GATES PASS` as testimony. Earn it locally.

## Intended acceptance gates

The script should exit 0 and establish all of these:

1. `TWICE` begins as ordinary s-expression data and becomes executable syntax only after `RABBIT` evaluates its definition.
2. `CAT` refuses `(twice ...)` before adoption with the typed `UNKNOWN-SYNTAX` condition.
3. Exporting the definition as data does not mutate another grammar. `CAT`, then `RAVEN`, must each evaluate it locally; the measured standing moves from `:LOCAL-INVENTION` to `:SHARED-PROTOCOL` to `:ECOSYSTEM-SYNTAX`.
4. `(conjure-hay 1000)` returns the representation `(:HAY 1000)` while the interpreter’s actual hay decreases.
5. A recursively self-expanding `AGAIN` form terminates by `HAY-EXHAUSTED`, not by host stack overflow.
6. A zero-hay interpreter remains repairable: an outer handler invokes `SUPPLY-FROM-OUTSIDE`, and the interrupted form resumes with live state preserved.
7. Attempting to overwrite a primitive through `DEFINE-SYNTAX` remains refused by `PROTECTED-SYNTAX` if you add a direct regression assertion for it during review.

## Review latitude

Please fix any ANSI Common Lisp or SBCL portability error you find, and harmonize comments/output with nearby specimens such as `de-cistula.lisp`, `de-immunitate.lisp`, and `de-furto.lisp`. Preserve the central architecture:

- no host `eval`;
- no caller-selected `fdefinition`;
- syntax rules live in a private table as explicit primitive/template records;
- definitions cross interpreters as copied data;
- actual resource state cannot be changed by merely returning data that describes resource state;
- resource exhaustion is a typed condition with a restart whose supply comes from outside the exhausted computation.

The template expander is deliberately first-order and capture-blind. Do not silently market it as hygienic macros or full Lisp semantics. Its declared datum domain is conses, strings, and immutable atoms; `copy-datum` is scoped to that domain rather than advertised as universal immutability.

## Integration notes

After the individual script passes, consider adding the specimen to any local all-specimen runner or documentary index that actually enumerates files. Do not update root-level “all files verified” counts unless the full repository suite is rerun and the new count is earned. A terse commit subject would be:

```text
atelier: add de-foeno syntax-uptake and resource specimen
```

The distilled theorem of the file is:

> A form can rewrite the grammar that reads forms. It cannot, by redescribing nourishment, nourish the reader. The spell needs an interpreter. The interpreter needs hay.
