# MANIFEST.md — Stranger Implementation /0 (pre-reveal freeze)

*Digests frozen 2026-07-23, BEFORE architecture/closure were revealed to the seat.*

Seat: `deepseek/deepseek-v3.2` (OpenRouter, clean memoryless call). Lineage-distant from Claude/Anthropic.

Final program `STRANGER-PROGRAM.lisp` == `rounds/round-2-program.lisp` (byte-identical, verified by digest).

| File | sha256 |
|---|---|
| `CHARGE.md` | `5f917332204e195ac87b1f530318e59fb4a24955d901a8cc034f53e25b8b0f98` |
| `ALLOWED-SOURCES.md` | `dcf92e58b1a6a9a6db844db0460cbca24f29c530799da987e693b7298a72af73` |
| `TASK.md` | `cb1a335caa6e4f40ade062c39cd9e83e9f942bb74e54ed30c7e1980eca917570` |
| `EVALUATION.md` | `fa49854573e908a902acf98d69a299cd4df59ecc5e52ce3e15a32d4f3a2e066c` |
| `task-inputs/readings-batch-a.sexp` | `6a1cbffe5d03e6e953e0b15431ace76be4d08c902fe25eb1d95ab33e57f34082` |
| `task-inputs/validator.lisp` | `3ad4f8d319b00afb29a081bf098c0193cf5119090bfc0e0391235977fc5921d7` |
| `check-front-door.py` | `01005b0a4739b5532bbe5eee933d155de359d723658910062d39a27dac84c9c4` |
| `check-external-symbols.lisp` | `256d7d97870166b8f9deac391477526987312a79381a3812563097633155ebc4` |
| `check-front-door-selftest.sh` | `cce30dd0ebd39299bf7c93003ceded00673c6350b6e06f56197709237aa3f9c1` |
| `teeth-runner.lisp` | `0c5f8695015ecccfec63d424f05e25b24a99c1fb7c2050ae64f00a77f5b58922` |
| `run_stranger_round.py` | `f55358f58d674ec169e955b4d19463ff897e7520b421040874eb83f38b2064d7` |
| `STRANGER-PROGRAM.lisp` | `d44c46e59dbfdb9dcb2746e0927c608d6dcff2811341f0cdefd9dffdeab7fa3c` |
| `RUN-RECEIPT.txt` | `885b2d24f02262d714029adf5de9f42278f9f1e1ce63e0dff1b2a2d0cd9895e0` |
| `IMPLEMENTER-REPORT.md` | `a06f3a0b75f98714dd773e5e10ed5fbe032b2d2513bb3237c4f7f91ce73d2e9e` |
| `rounds/round-1-program.lisp` | `2e2d35a50f47fc0d03cfba4065481b17244c77b5ce56fd6b996ac1ea4f5d12ff` |
| `rounds/round-1-reply.md` | `d35203035d833faf429189b72ee8b377474e8191639885730dd63acbb22da889` |
| `rounds/round-1-run.txt` | `5ee3b277b8f052e544aac998854400276282407f6d4c68ec674073f5ddfe15e8` |
| `rounds/round-1-meta.json` | `7616928d6e4ec58e115f85d0eb7e28e9733f82d779112a63b6057d1bc7b105ee` |
| `rounds/round-2-program.lisp` | `d44c46e59dbfdb9dcb2746e0927c608d6dcff2811341f0cdefd9dffdeab7fa3c` |
| `rounds/round-2-reply.md` | `d450a8ecea38f8ad13b68b63b71b96dc91e1b32282d9971abfee05369b23f82b` |
| `rounds/round-2-run.txt` | `885b2d24f02262d714029adf5de9f42278f9f1e1ce63e0dff1b2a2d0cd9895e0` |
| `rounds/round-2-meta.json` | `603b68b4e759449c2a357482a8e2b6a7d0bd7459b7169fe8c4d7155a031fd09b` |

## Round ledger

| Round | Relay | Result | Program digest |
|---|---|---|---|
| 1 | initial (Guide+API+Task only) | front-door CLEAN, EXIT 1 at step 13 (self-inflicted CL quoting bug) | `2e2d35a50f47fc0d03cfba4065481b17244c77b5ce56fd6b996ac1ea4f5d12ff` |
| 2 (voided ×2) | BROKEN relay (transcript only, no program) | regressed — VOID, archived `rounds/void-broken-relay/` | — |
| 2 (corrected) | program + transcript | front-door CLEAN, **EXIT 0, all 14 substeps** | `d44c46e59dbfdb9dcb2746e0927c608d6dcff2811341f0cdefd9dffdeab7fa3c` |

Ground-truth identity is the OpenRouter store (`round-*-meta.json`), never the seat's self-report.

