# EXPECT-CONDITION-RUNTIME

This directory carries the audited prototype ancestor and its amended,
split-file successor. Sol's 2026-07-12 reversed audit ruled
`:AMEND-THEN-ADOPT`: the prototype's clay was honest, but broad
`HANDLER-CASE` interception moved outsiders out of their live signaling
context.

## Standing

- `expect-condition-runtime-ancestor-d8a957a2.lisp`:
  `:audited-prototype-ancestor`; **not canonical**. Its bytes are preserved.
- `expect-condition-runtime.lisp`:
  `:canonical-runtime-companion`; definitions only and safe to
  `LOAD`.
- `test-expect-condition-runtime.lisp`: executable nine-row native ledger.

No sealed or adopted Nenbutsu instrument is modified by this succession.

## Pairing rule

Use literal `EXPECT-CONDITION` when the condition family is known at
macroexpansion. Use `EXPECT-CONDITION-RUNTIME` when the condition and family
types are runtime values. The runtime helper uses `TYPEP`; expected
classification precedes sibling classification.

The helper is a customs desk: it classifies while the signal is alive and
declines outsiders by returning from its handler. It never transfers or
re-signals them.

## Run

From this directory, load the reusable definitions without exiting the image:

```sh
sbcl --noinform --non-interactive \
  --eval '(load "expect-condition-runtime.lisp")' \
  --eval '(format t "POST-LOAD-SURVIVED~%")'
```

Run the executable nine-row ledger separately:

```sh
sbcl --noinform --script test-expect-condition-runtime.lisp
```

See `CENSUS-old-vs-new.md` for commands and native old-versus-new evidence.

## SHA-256

```text
d8a957a2835d2d8809ce30c533ad182ce83b2cb7b27b4b6aed6d933d66e14a51  expect-condition-runtime-ancestor-d8a957a2.lisp
d16fbe7b22be6f83713fbd138ecca25a5e5654faba14c3f1fe7de5a4489a8e12  expect-condition-runtime.lisp
b1780205e995ca724127a0c20019a49b987d9c3d77a2fe7bc56555a4781718dc  test-expect-condition-runtime.lisp
```
