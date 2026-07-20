# SS-0 Durable-Record Semantic Layer

Primary implementation and scenario entry point: `ss0_runner.py` (Python).  
Independent second-language reader: `ss0_reader.lisp` (Common Lisp / SBCL).

## Scenario corpus entry point

The death harness contract is:

```sh
SS0_ENTRY="python3 ss0_runner.py" python3 substrate/ss0-harness.py
```

The runner is invoked as:

```sh
python3 ss0_runner.py <run-dir>/ <scenario> <killpoint-or-empty>
```

Scenario plan:

| Scenario | Label | Payload regime | Provider tag |
|---|---:|---|---|
| S1-clean | bank-write | complete | effect:bank-write |
| S2-pre-record | mint | empty | effect:mint |
| S3-mid-record | notify | invalid | effect:notify |
| S4-post-dispatch | notify | invalid | effect:notify |
| S5-unfsynced-outcome | mint | empty | effect:mint |
| S6-mid-stream | stream | none | slow:3 |
| S7-refused-unrecorded | bank-write | complete | effect-ne:bank-write |

This exercises at least three effect labels and the complete/empty/invalid payload regimes.

## Recovery modes

Cold recovery invocations:

```sh
python3 ss0_runner.py <run-dir>/ recover
python3 ss0_runner.py <run-dir>/ redispatch <op-id>
python3 ss0_runner.py <run-dir>/ admit-receipt <op-id>
python3 ss0_runner.py <run-dir>/ succeed <pred-op-id>
```

Meaning:

- `recover`: report recovery state, tail status, record count, and canonical digest.
- `redispatch`: attempt re-dispatch of an operation; refuses when dispatch exists without durable outcome/receipt, when an executed outcome is recorded, when a receipt resolves to executed, or when the operation is completed. Refusals cite record evidence.
- `admit-receipt`: read `receipt-<attempt>.txt` from the run directory and append a provenance-carrying `receipt` record.
- `succeed`: create an explicitly distinct successor operation with fresh identity, link it to the predecessor, and proceed under the successor identity.

## Independent second-language reader

Run:

```sh
sbcl --script ss0_reader.lisp <run-dir>/
```

It shares no code with the Python implementation. It reads `records.log` using the Common Lisp substrate, derives equivalent recovery state, and prints the same canonical digest.

## Canonical digest specification

Digest input is one line per operation, sorted lexicographically by `op`:

```text
<op>|<label>|<state>|<regime>|<payload_crc>|<outcome>|<outcome_durable>|<outcome_payload_crc>|<evidence>|<successor>|<chunks>|<lineage>|<derived>
```

Missing fields are `-`. `payload_crc` and `outcome_payload_crc` are uppercase CRC32-hex of UTF-8 payload bytes; empty payload is `00000000`; absent payload is `-`. `chunks` is a sorted comma-separated list of chunk indexes, or `-`. The digest is CRC32-hex of the UTF-8 bytes of the joined lines, with lines separated by `\n` and no trailing newline.

## Record schema

Records are canonical flat maps serialized by the substrate. Field `t` is the record type.

- `intent`: `op`, `label`, `regime`, `payload`, `attempt`, optional `lineage`, optional `pred`
- `dispatch`: `op`, `attempt`, `tag`
- `outcome`: `op`, `attempt`, `status`, `durable`, optional `payload`
- `chunk`: `op`, `attempt`, `idx`, `data`, `durable`
- `receipt`: `op`, `attempt`, `outcome`, `provenance`
- `successor`: `op` = predecessor, `pred`, `succ`, `reason`
- `complete`: `op`, `attempt`
- `setup`: optional process-level record with no `op`; ignored by recovery state

## Recovery states

- `unknown`: operation key present but no recognized direct state record.
- `attempted`: intent recorded, no dispatch.
- `unresolved`: dispatch recorded, no durable outcome or receipt.
- `outcome-recorded`: outcome recorded but no completion record.
- `receipt-resolved`: provider receipt admitted as durable evidence.
- `completed`: completion record present.

`derived=true` marks states inferred from absence, especially `unresolved`. Directly recorded states are `derived=false`. Receipt resolution carries `evidence=<provenance>`.

## Obligation coverage

- R1: recovery reports only surviving records; unresolved operations remain unresolved.
- R2: `regime`, `payload_crc`, and `outcome_payload_crc` distinguish empty/absent/invalid payloads after recovery.
- R3: `redispatch` refuses blind re-dispatch and cites record evidence.
- R4: `admit-receipt` resolves unknown outcomes only by appending a provenance-carrying receipt record; executed resolution blocks re-dispatch.
- R5: `succeed` creates a fresh successor identity, preserves predecessor unresolved standing, and marks lineage.
- R6: derived state is marked; evidence is separate; re-verification does not silently upgrade derivation.
- R7: Common Lisp reader independently derives equivalent state and digest.
- R8: recovery logic switches only on record type, not effect label; new effect types do not require recovery rewrite.
- R9: `records.log` alone reconstructs attempts, knowledge, unknowns, and evidence.

## Assumptions

1. The examiner invokes recovery modes as separate cold processes.
2. Mode arguments are: `recover` takes none; `redispatch`, `admit-receipt`, and `succeed` take an operation id.
3. Provider receipt files are named `receipt-<attempt>.txt` and contain `outcome: executed` or `outcome: not-executed`.
4. Successor operations use fresh operation ids and explicitly record predecessor linkage.
5. Same-attempt re-dispatch is refused once an executed outcome, completion, or executed receipt exists; known not-executed outcomes may be allowed, but distinct succession is always available via `succeed`.
6. No execution environment was available during authorship; substrate selftest, harness, and AFEL were not run here. Execution-verification is the examiner's job.
7. No external materials beyond the frozen packet were consulted or received.
