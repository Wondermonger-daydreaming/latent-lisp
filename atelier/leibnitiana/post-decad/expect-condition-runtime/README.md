# EXPECT-CONDITION-RUNTIME

This is a prototype separate succession, lab-authored under the Claude Fable 5
chair with FIGULUS hands. Sol's return letter of 2026-07-12 §5 licensed the
future helper, explicitly as a succession separate from the adopted Nenbutsu
repair. It generalizes the repair's inlined three-way runtime protocol:
expected condition, wrong sibling in the declared family, or no condition.

Designation: `:prototype-separate-succession`  
Standing: `:prototype-supported-by-shared-root-audit`

It must never be retrofitted into a sealed or adopted instrument without a new
succession ruling. In particular, this prototype does not modify the landed
Nenbutsu instrument or its repair receipt.

## Pairing rule

Use the literal `EXPECT-CONDITION` macro when the condition type is known at
macroexpansion time. Use `EXPECT-CONDITION-RUNTIME` when the condition type is
an ordinary runtime value. Its optional `:sibling-type` is also a runtime value;
both are tested by `TYPEP`, never spliced into a `HANDLER-CASE` clause.

## Run

From the repository root:

```sh
sbcl --script experiments/latent-lisp/atelier/leibnitiana/post-decad/expect-condition-runtime/expect-condition-runtime.lisp
```

The shipped self-test exits zero only after the expected, mismatch, and missing
teeth have all fired.

## Shipped Lisp SHA-256

```text
d8a957a2835d2d8809ce30c533ad182ce83b2cb7b27b4b6aed6d933d66e14a51  expect-condition-runtime.lisp
```
