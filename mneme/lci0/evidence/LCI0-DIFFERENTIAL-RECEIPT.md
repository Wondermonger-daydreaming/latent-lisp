# LCI/0 Baseline Differential Receipt

Date: 2026-07-14

Status: not converged; successor corrections and one authorial return required

## Bound inputs and implementations

- Integration base commit: `71f7cfc5ebe392d59d820203dad11cc2e86a0542`.
- Common Lisp seed: commit
  `b3d28bc49c3b015096cb04c6ad08c19829f511a9`, tree
  `d48c39f933cde591f3303fcd3c9f42a0dac1a869`.
- Python seed: commit
  `4ec2e519d05aeacd2412cb8aedc5f76bde702571`, tree
  `9f7915b460f449976a5d7fa856861ad5ce1d36ca`.
- Protocol: `lisp-plus-lci0-differential/v1`.
- Fixture profile: `0.1.0`.
- LCI budget: `resource-budget.lci-first-implementation.0`, canonical
  SHA-256
  `b574f188fbc24c99018a8095fb9846511f582136c416b5f4cd685ba67ee16c93`.
- Runtime: SBCL 2.4.6; Python 3.11.14; Linux x86-64 under WSL2.

Adapter requests contained only protocol/request identifiers, operation,
fixture profile, canonical input octets, and pinned budget identity. Expected
results remained coordinator-side.

## Mechanical request census

Per implementation:

| Class | Requests |
|---|---:|
| Official embedded document roundtrips | 1,105 |
| Supplementary relation-table document roundtrips | 458 |
| Supplementary nested E1 roundtrips | 30 |
| Shared vector semantic executions | 215 |
| Full relation-table semantic executions | 458 |
| Baseline subtotal | 2,266 |
| Deterministic hostile witnesses | 15 |
| Total | 2,281 |

The two isolated adapters returned 4,562 uniquely keyed responses. Both stderr
streams were empty. The runner mechanically confirmed 215 unique vector IDs,
all required P001–P030 and N001–N032 IDs, and 52 operation families.

## Results

| Surface | Common Lisp | Python |
|---|---:|---:|
| 1,593 document roundtrips | 1,593 pass | 1,593 pass |
| 215 exact vector result documents | 215 pass | 210 pass, 5 fail |
| 169 scope-table relations | 117 pass, 52 fail | 169 pass |
| 289 temporal-table relations | 259 pass, 30 fail | 289 pass |
| 15 hostile expectations | 2 pass, 13 fail | 0 pass, 15 fail |

The 82 Common Lisp relation-value disagreements are recorded in
`LCI0-DIV-004` and `LCI0-DIV-005`. The five Python exact result-document
disagreements are `LCI0-DIV-007`. Shared and language-specific hostile defects
are `LCI0-DIV-008` through `LCI0-DIV-013`. Thirty-eight additional
relation-failure path disagreements are `LCI0-DIV-014` and have their own
narrowly scoped authorial-return packet.

The universal/symbolic table and `LCI0-N012` expose the true normative conflict
`LCI0-DIV-006`. Its exact matcher path is blocked and has a separate authorial
return packet; it is not counted as N/A.

## Retained raw evidence

Directory:
`mneme/lci0/differential/artifacts/baseline-2026-07-14/`

| Member | Bytes | SHA-256 |
|---|---:|---|
| `requests.jsonl` | 24,275,425 | `45be08faf24a4cbeea8979d6e77aefa9ec8ef84926b73b54555d22a5bad40f55` |
| `common-lisp-responses.jsonl` | 25,598,224 | `30ebc7954cb2a449d55db7e6bc1d381a185651b7ad1f73f07cb0d885a3adc4fb` |
| `common-lisp-stderr.txt` | 0 | `e3b0c44298fc1c149afbf4c8996fb92427ae41e464b934ca495991b7852b855` |
| `python-responses.jsonl` | 25,640,350 | `b7d5ac2a10ae2c5f3dff130092233594c100a9caea7f41710b920e18d0e3dc2c` |
| `python-stderr.txt` | 0 | `e3b0c44298fc1c149afbf4c8996fb92427ae41e464b934ca495991b7852b855` |
| `summary.json` | 1,325,748 | `45f52cf4bfba7c486575cd752fdf51dcd4176731c9a8032b16cbb1f048efc31f` |
| `sha256-manifest.json` | 804 | `33a351f621a7b78d52bef55de71c98c98a891ab4b3fd6981d5ff00e3205a3b7f` |

Raw JSONL files are retained for the evidence/archive commit sequence. They are
not intended to remain loose at the final branch tip after a verified archive
contains them and the cleanup commit preserves recoverability in history.

## Deferred phases

Host ambient-state perturbations and randomized/property generation were not
run because the exact fixture baseline did not converge. They are not passes,
skips, or N/A. A successor phase may run them only after every non-blocked exact
fixture converges, excluding solely the authorial-blocked N012 matcher witness
by exact ID.

## Command

From the integration worktree root:

```text
PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=mneme/lci0/differential:mneme/lci0/python:canonical-datum/python python3 mneme/lci0/differential/run_differential.py
```

The first baseline runner did not record an internal elapsed-time field.
Therefore this receipt makes no exact duration claim; successor receipts must
record monotonic wall time explicitly.
