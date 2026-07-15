# DE-CORROBORATIONE replay verification

Runtime: SBCL 2.4.6. Command for both fresh successor processes:

```text
sbcl --noinform --disable-debugger --script mneme/atelier/hinges/de-corroboratione.lisp
```

| Run | Exit | Bytes | LF lines | SHA-256 |
|---|---:|---:|---:|---|
| successor 1 | 0 | 10,099 | 134 | `c227d96a6f2483878a8b907793db9861b722c46c3a2698665d0198d404534d0a` |
| successor 2 | 0 | 10,099 | 134 | `c227d96a6f2483878a8b907793db9861b722c46c3a2698665d0198d404534d0a` |

`cmp` returned 0. The committed final verification transcript is successor run
1 and has the same digest.

The visible in-specimen replay record binds all four required surfaces:

- ordering-use context, including candidate path, dimension, and minting
  adjudication;
- graph snapshot digest;
- exact lineage lower-certificate witness subset;
- exposure/path decision.

Reconstruction from identical components passes. Replacing only the path
decision changes the replay digest and raises typed `REPLAY-DIVERGED`.

Broader non-regression command:

```text
bash mneme/verify-all.sh
```

Result: exit 0, all six Mneme floors green. `python3
mneme/atelier/static-check.py` also exited 0 for all 22 Lisp files. These commands
do not use same-origin transcript comparison as their only oracle: they include
static structure checks, typed adversarial failures, component replay mutation,
and the repository's independent existing floors.
