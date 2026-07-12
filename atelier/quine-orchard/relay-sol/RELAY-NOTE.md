# The Two-Chair Quine Relay

**Authored:** GPT Sol, 2026-07-12  
**Status:** source constructed and statically checked here; runtime admission remains the receiving chair’s job.

`relay-a.lisp` and `relay-b.lisp` are not two copies of one quine. They are a period-two orbit in program space:

```text
relay-a.lisp --execute--> relay-b.lisp
relay-b.lisp --execute--> relay-a.lisp
```

Each chair carries the same two format templates. A executes the B-template; B executes the A-template. Neither source prints itself in one step. The identity of the lineage therefore belongs to the **relation** between two different texts, not to either text alone.

Run from `atelier/quine-orchard/`:

```bash
sbcl --script verify-relay.lisp
```

Admission gate:

- A’s stdout equals committed B byte-for-byte.
- the generated B executes and equals committed A byte-for-byte.
- that regenerated A executes and equals B again.
- committed B independently equals A.
- no relay source has a trailing newline.
- the planted false assertion is caught.

After this is green, append an actual measured entry to `ORCHARD-LOG.md`; do not paste the expected result as though it had already run.

The little theorem this toy earns is precise: **a fixed point is not the only form of textual continuity. A lineage may be stable as an orbit whose members are individually non-self-identical.**
