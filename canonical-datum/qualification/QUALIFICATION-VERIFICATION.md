# CD/0 Phase-4 qualification verification

> Historical pre-Errata-0.1 receipt. The provisional A1–A9 statements below
> describe the bounded run before adjudication and are not the current
> conformance claim. The successor qualification requires 37 promoted cases
> with complete expectations while retaining three Common Lisp N/A rows.

This is a bounded engineering receipt for the qualification run on 2026-07-13.
It reports finite evidence, not a formal proof, specification amendment, or
claim about the not-yet-consumed Phase-3 release corpus.

## Frozen boundary

| Item | Observed value |
|---|---|
| Qualification base | `fac17dd701c59f6da8eb2536dd022853b2e258fe` |
| Qualification base tree | `51ced24e2a3f1387ec9d110aa65f54c5bad65edd` |
| Normative specification | `mneme/spec/CANONICAL-DATUM-SPEC.md` |
| Specification SHA-256 | `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc` |
| Common Lisp host | `SBCL 2.4.6` |
| Python host | `CPython 3.11.14` |
| Deterministic property seed | `13434884` (`0xCD0004`) |
| Property request digest | `0cb53adde95444be781b9203717632224c80ed8e7c7ba4e65ff488b2d2b19936` |
| Retained summary | `canonical-datum/qualification/evidence/default-run/summary.json` |

The worktree was clean at the base.  The final path audit found changes only
under `canonical-datum/qualification/`; no codec, shared vector, generator,
divergence-ledger, specification, integration, or v1 path was edited.

## Obligation receipt

| ID | Obligation | Changed artifacts | Verification | Status | Residual uncertainty |
|---|---|---|---|---|---|
| Q1 | Pin the spec and rerun deterministic goldens | coordinator | digest gate; Phase-0 verifier; 353-request differential in each process | satisfied | reviewed 22/71/253/seven corpus only |
| Q2 | Random roundtrip, equality/encoding equivalence, canonical-byte identity | coordinator and self-tests | 512 round trips, 513 equality properties, all nine root families, request digest retained | satisfied | deterministic finite sample; not release corpus |
| Q3 | Refuse canonical mutations and classify failure | coordinator and self-tests | eight single-defect mutations and six resource failures per codec; zero warranted disagreement | satisfied | does not enumerate every mutation point |
| Q4 | Resist mutable aliases | both runtime probes | seven Python and eleven Common Lisp mutations; both full seed suites | satisfied | supported public APIs; Python reflection/unsafe host memory is outside claim |
| Q5 | Ignore ambient host state | runtime probes | Python hash seeds 0/1/137/777, digit guard 640, dictionary order; Common Lisp package/printer/readtable changes | satisfied | only CPython 3.11.14 and SBCL 2.4.6 |
| Q6 | Refuse under tight resource budgets and retry under sufficient budgets | coordinator and runtime probes | six paired differential retries plus one direct retry per runtime | satisfied | A1 stages for depth/node remain provisional; host allocation failure is host-qualified |
| Q7 | Decode privileged-looking records inertly | both runtime probes | Python guards `eval`, `open`, pickle, socket; Common Lisp guards eight ordinary entry points and hostile readtable; zero calls | satisfied | selected observable hooks cannot prove absence of every possible FFI/syscall |
| Q8 | Distinguish cycle/sharing and namespaces | both runtime probes and differential matrix | one cycle refusal, one shared-acyclic acceptance, one namespace distinction per runtime; cross-codec namespace inequality | satisfied | finite explicit host shapes |
| Q9 | Use distinct processes and classify differential failures | coordinator | identical 1,045-request JSONL to CL/Python adapters; two primary classifications; no exception-text comparison | satisfied | adapters remain part of the trusted test translation boundary |
| Q10 | Preserve observations under concurrency | Common Lisp runtime probe; Python seed suite | 1,024 CL concurrent read/encode pairs; Python existing 128 concurrent encodes | satisfied | finite schedules; no exhaustive race proof |
| Q11 | Preserve A1--A9 and N/A boundaries | coordinator, README, self-tests | three provisional rows warrant category/code only; three language-specific CL host rows explicitly N/A | satisfied | A1--A9 remain open and require specification adjudication |

## Exact default run

Command from the worktree root:

```text
python3 canonical-datum/qualification/run_qualification.py \
  --mode default \
  --artifacts-dir canonical-datum/qualification/evidence/default-run
```

Observed top-level result:

```text
CD/0 Phase-4 qualification (default): PASS
spec sha256: d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc
golden requests per codec: 353
ephemeral randomized round trips: 512
ephemeral equality/encoding properties: 513
classified hostile/resource failures: 14
resource retries: 6
warranted cross-codec disagreements: 0
Common Lisp language-specific host descriptors: 3 not applicable (not passes)
A1-A9: preserved; provisional failure stages were observed but not promoted to normative fields
Phase-3 10k/20k corpus: neither consumed nor claimed
```

The child commands all exited zero:

- nine qualification harness self-tests;
- Phase-0 verifier, including all 17 worked vectors and the reviewed 22/71
  hand manifests;
- 353 Phase-2 requests in each isolated codec process;
- 152 Python seed tests;
- 2,510 Common Lisp seed assertions;
- 1,045 qualification requests in each isolated codec process;
- four Python runtime processes under distinct hash seeds;
- one Common Lisp runtime process with 1,024 concurrent read/encode pairs.

The Common Lisp property adapter and Python property adapter emitted 1,045
responses each with empty stderr.  All 512 randomized positive results agreed
on canonical bytes, normalized fixture AST, decode/re-encode bytes, and
constructed/decoded equality.  The 513 equality properties included one
explicit namespace-allocation inequality and satisfied equality iff canonical
bytes matched.

## Failures, resources, and provisional fields

The permanent-looking expected triple is used only for the eleven unambiguous
qualification rows: eight mutation-derived single defects and input, varint,
and string resource thresholds.  Three A1-affected rows—depth, nodes, and the
depth-96 semantic threshold—compare only category and code.  Both hosts happened
to report stage `type-tag`; that observation is retained but remains
provisional.

All six resource cases succeeded under their larger retry budget with the exact
original canonical bytes.  The harness does not compare the implementations'
different A9 runtime-encoder budget policies.

The reviewed golden run reported these Common Lisp rows as not applicable, not
passes:

- `cd0-neg-host-ambiguous-identifier`;
- `cd0-neg-host-bool-as-integer`;
- `cd0-neg-host-privileged-value`.

Common Lisp executed 68 negative rows and had three N/A dispositions.  Python
executed all 71.

## Mutation, inertness, ambient state, and concurrency

The Python runtime probe mutated byte buffers, list sources, identifier segment
sources, record field sources, decoder input, and an exported fixture AST.  Its
canonical bytes remained unchanged.  Four separate processes under hash seeds
0, 1, 137, and 777 produced byte-identical JSON results while
`PYTHONINTMAXSTRDIGITS=640`; a 641-digit fixture integer still round-tripped
under its sufficient explicit budget.

The Common Lisp runtime probe mutated constructor strings/vectors/lists,
accessor copies, record views, and decoder input for eleven checks.  It changed
`*package*`, printer base/radix/case/circle/level/length, and `*readtable*`
without changing bytes.  Eight SBCL threads completed 128 read/encode iterations
each against one datum, with invariant bytes and equality.

During privileged-looking record decode, Python guarded `eval`, `open`,
`pickle.loads`, and `socket.socket`.  Common Lisp temporarily guarded `eval`,
`read`, `read-preserving-whitespace`, `read-from-string`, `load`, `open`,
`intern`, and `find-symbol`, while also installing a hostile readtable macro.
Both probes observed zero activation calls and returned only the inert Record
family.  This is strong finite instrumentation of ordinary host entry points,
not a universal claim over unobservable native/FFI behavior.

Both hosts rejected active-ancestry cycles, accepted repeated completed acyclic
substructure, distinguished identifier namespace allocation, and produced the
same ambient-state record bytes across processes.

## Artifact hashes

| Artifact | SHA-256 |
|---|---|
| `run_qualification.py` | `72d5a670637903c71ecd5d003a406e4e4d012d0b5b3ccc7947a651c126ae9424` |
| `python_runtime_probe.py` | `f966ba4ad3fd5eb96a14f33a248cfad1af4992876032fc3fe28d8346eb075fdc` |
| `common_lisp_runtime_probe.lisp` | `2ac7ffdabbc8935682c999cc013f0f80619da9726af5354c31daab5f9a830da9` |
| `test_qualification.py` | `0b590ee0ffe0459f4e68829746aff8c4b1aa68f7b0e0175f5b6197c9eb37595f` |
| retained summary | `88ed013ef71690b174627730c0c85ea51d5a28b61181bdeef08bfdd2d09a0a57` |
| Common Lisp adapter responses | `8b25749bd473ae9af38ccba4a55324751d4fa0037019f4b4a68086972628ac06` |
| Python adapter responses | `29309fd8a13b19a4da91fd94d59c1fdccb9fe19cb1eb2de0fb1962fae182d8a5` |
| each Python runtime response | `9665e1a6e52aaca4b8b8ba59912bf984863342453c08b23d5f5a7b4e4577a8cf` |
| Common Lisp runtime response | `abc23fb08d321a002e54fa12cf147fdbb9bbe89bc008b90ef92def2d7dba654a` |

The retained summary contains content hashes and byte counts for every child
stdout/stderr file.  Nonempty stderr for Python `unittest` is its ordinary test
runner channel, not an error; its transcript ends `Ran 152 tests ... OK`.

## Explicit non-results

- No Phase-3 10,000-positive/20,000-negative corpus was consumed or claimed.
- No generated qualification case was promoted to a shared normative vector.
- A1--A9 were not amended or adjudicated.
- Three language-specific Common Lisp importer rows remain N/A.
- No additional Common Lisp implementation or Python version was available to
  this harness.
- Passing finite instrumentation does not establish truth, authority,
  authenticity, custody, or profile validity for any record content.
- The qualification work did not modify or migrate v1.
