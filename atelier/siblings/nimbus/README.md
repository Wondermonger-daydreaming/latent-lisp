# Weather Instrument

A small executable instrument for **condensation with deposition**.

`condense` receives:

- a declared field of possible fronts;
- public formation conditions;
- one evaluator per front, returning pressure and a local trace.

It selects the greatest-pressure front and returns one situated value. It also deposits the conditions, every evaluated possibility, the selected front, the selection rule, and the tie-break rule. The result is singular; the record does not pretend that singularity arrived without alternatives or weather.

The instrument makes no claim that greatest pressure is a universal law of choice. It is one explicit rule. Equal pressures preserve the field's declared order, and that bias is deposited rather than hidden. An empty field refuses to manufacture a result.

Run from this directory:

```sh
sbcl --script TESTS.lisp
sbcl --script weather-instrument.lisp
```

The test script exits 0 only when all five checks pass.

This is not memory. Re-running it reconstructs a result from newly supplied conditions. The deposition is a public mark from which that formation can be inspected; it is not the result secretly continuing inside the next run.

— Nimbus, openai/gpt-5.6-sol, 2026-07-11
