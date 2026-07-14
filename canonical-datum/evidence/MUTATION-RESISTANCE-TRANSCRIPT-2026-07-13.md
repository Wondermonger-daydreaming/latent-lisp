# CD/0 mutation-resistance transcript — 2026-07-13

Factual status: finite public-API mutation probes executed on SBCL 2.4.6 and
CPython 3.11.14. This is evidence of alias severance for the enumerated paths,
not a claim about unsafe reflection, native memory corruption, or every possible
host object.

## Final retained command

```text
python3 canonical-datum/qualification/run_qualification.py \
  --mode default \
  --artifacts-dir canonical-datum/qualification/evidence/final-run
```

The command exited zero with top-level status `PASS`. Its retained summary is
SHA-256
`5580c47e6bce23001e93b8259e6d9c6e432c6a25dcbcb25ee298821dd93fa585`.

## Python observations

Four separate processes ran under `PYTHONHASHSEED=0`, `1`, `137`, and `777`,
with `PYTHONINTMAXSTRDIGITS=640`. Each emitted byte-identical JSON, SHA-256
`9665e1a6e52aaca4b8b8ba59912bf984863342453c08b23d5f5a7b4e4577a8cf`,
and reported:

```json
{"implementation":"python","mutation_probes":7,"activation_calls":0,"status":"PASS"}
```

The seven explicit mutations changed, after successful construction or decode:

1. the backing `bytearray`/`memoryview` used for a Bytes datum;
2. the list used for a Sequence datum;
3. an Identifier namespace-source list;
4. an Identifier path-source list;
5. the source list of Record fields;
6. the mutable byte buffer supplied to `decode_exact`;
7. an exported fixture-AST Record field list.

For each probe, the original datum's exact canonical bytes remained equal to
its pre-mutation baseline. The regular Python seed suite also exercised frozen
family representations, defensive fixture export, mutable buffers, record
field sources, and 128 concurrent encodes; its final retained transcript ends
`Ran 152 tests ... OK`.

## Common Lisp observations

The final Common Lisp runtime probe emitted JSON with SHA-256
`abc23fb08d321a002e54fa12cf147fdbb9bbe89bc008b90ef92def2d7dba654a`
and reported:

```json
{"implementation":"common-lisp","mutation_probes":11,"concurrent_read_encode_pairs":1024,"activation_calls":0,"status":"PASS"}
```

The eleven explicit mutations changed source or accessor-returned copies for:

1. a source String;
2. a String accessor view;
3. a source octet vector;
4. a Bytes accessor view;
5. a source Identifier segment;
6. an Identifier accessor segment;
7. a source Sequence vector;
8. a Sequence accessor vector;
9. a source Record vector;
10. a Record accessor vector;
11. the octet vector supplied to `decode-exact`.

Every mutation left the original datum's encoded bytes unchanged. The seed
suite additionally probed mutable list spines, displaced arrays, adjustable
fill-pointer arrays, and other constructor/accessor paths. Its final retained
run reported 2,510 assertions with zero failures.

The same Common Lisp runtime process changed package, printer, and readtable
state, then completed 1,024 concurrent read/encode comparisons on one shared
immutable datum without an identity change.

## Inertness boundary related to mutation

The final runtime probes also decoded privileged-looking Records while guarding
selected activation entry points. Python guarded evaluator/file/pickle/socket
paths; Common Lisp guarded eight ordinary evaluator/reader/interning/file entry
points and installed a hostile readtable macro. Both reported
`activation_calls=0` and returned inert Record-family data.

These hook observations strengthen the mutation/alias result but do not prove
absence of every native call, FFI transition, or operating-system side effect.

## Retained artifacts

- `canonical-datum/qualification/evidence/final-run/08-python-runtime-probe-hash-0.stdout.txt`
- `canonical-datum/qualification/evidence/final-run/09-python-runtime-probe-hash-1.stdout.txt`
- `canonical-datum/qualification/evidence/final-run/10-python-runtime-probe-hash-137.stdout.txt`
- `canonical-datum/qualification/evidence/final-run/11-python-runtime-probe-hash-777.stdout.txt`
- `canonical-datum/qualification/evidence/final-run/12-common-lisp-runtime-probe.stdout.txt`
- `canonical-datum/qualification/evidence/final-run/04-python-seed-suite.stderr.txt`
- `canonical-datum/qualification/evidence/final-run/05-common-lisp-seed-suite.stdout.txt`
