# Leibnitiana second tranche — landing notes

Files to add or replace:

- Add `storms/false-harmony.lisp`.
- Replace `specimens/de-compossibilitate.lisp` (date represented as a string).
- Replace `essays/calculemus-question-mark.md` (target-schema and aspirational-profile disclosures).
- Replace `leibnitiana.asd` (MIT license metadata).
- Append the second-tranche disclosure to `README.md`.

Runner expectation:

```sh
sbcl --script storms/false-harmony.lisp
```

Required outcomes:

- public toy transcript is unanimous;
- first-pass toy outputs are divergent;
- receipt records at least one retry, discarded history, and curator intervention;
- endogenous agreement is rejected as manufactured harmony;
- relay-process independence is rejected;
- manufactured unanimity for the relay process remains `:not-established`.
