# PJ0 Reference Authoring Transcript

- Generated at fixed authoring date: 2026-07-18
- Governing Kernel copy SHA-256: `386fead212bf8baccd116d673993145e6f2bea077516ee4770ebf9521503093c`
- Governing Architecture SHA-256: `dd4894d45ad55dc1c051af44fcca22367b5b0718e1129adbd30059e3a58c7161`
- Synced demo store id: `pj0-store:12b099a4b4fa66b1c4e07a1e076228d4a214588f558a35edf07523782fd1573c`
- Synced demo metadata SHA-256: `af58ab13f6826b33911581d11a55e54c24cedd0c29c05f013714042d013f6184`
- Synced demo event file SHA-256: `41cda0a5b99550579837b94d2a424fc3d763df2b9047e24596339b16779738da`
- Frames: `7`
- Final frame starts at byte: `6684`
- Final frame length: `1235`
- Exhaustive proper truncation vectors: `1235` (offset 0 valid-end; all nonzero offsets torn-tail)

## Strict fixture results

- `positive-synced-demo` → `valid`
- `positive-one-record` → `valid`
- `positive-best-effort` → `valid`
- `adversarial-bad-magic` → `corruption` (`header-magic-version`)
- `adversarial-bad-version` → `corruption` (`header-magic-version`)
- `adversarial-leading-zero-ordinal` → `corruption` (`noncanonical-ordinal`)
- `adversarial-ordinal-gap` → `corruption` (`ordinal-gap`)
- `adversarial-leading-zero-length` → `corruption` (`noncanonical-length`)
- `adversarial-uppercase-digest` → `corruption` (`digest-syntax`)
- `adversarial-payload-hash` → `corruption` (`payload-hash`)
- `adversarial-prev-chain` → `corruption` (`previous-frame-digest`)
- `adversarial-frame-hash` → `corruption` (`frame-hash`)
- `adversarial-noncanonical-record-order` → `corruption` (`payload-canonicality:noncanonical PJ-S/0 rendering`)
- `adversarial-malformed-utf8` → `corruption` (`payload-canonicality:invalid UTF-8: 'utf-8' codec can't decode byte 0xff in position 10: invalid start byte`)
- `adversarial-bad-separator` → `corruption` (`bad-frame-separator`)
- `adversarial-extra-between` → `corruption` (`header-field-count`)
- `adversarial-splice-other-store` → `corruption` (`frame-hash`)
- `adversarial-duplicate-identical` → `corruption` (`duplicate-event-id`)
- `adversarial-duplicate-conflict` → `corruption` (`duplicate-event-id`)

## Planted mutant scorecard

- `ignore-payload-hash` killed by `adversarial-payload-hash`: expected `corruption`, mutant returned `valid`
- `ignore-prev-chain` killed by `adversarial-prev-chain`: expected `corruption`, mutant returned `valid`
- `accept-noncanonical` killed by `adversarial-noncanonical-record-order`: expected `corruption`, mutant returned `valid`
- `interior-as-tail` killed by `adversarial-payload-hash`: expected `corruption`, mutant returned `torn-tail`
- `duplicate-last-write-wins` killed by `adversarial-duplicate-conflict`: expected `corruption`, mutant returned `valid`
- `ignore-ordinal` killed by `adversarial-ordinal-gap`: expected `corruption`, mutant returned `valid`

## Crash-window interpretation

- CW-0 fixture ends before the proposed final frame and is a valid prior prefix.
- CW-1 selected fixtures and every nonzero exhaustive truncation are torn tails.
- CW-2/CW-3 full-byte fixtures validate; caller knowledge and durability standing remain scenario metadata, not derivable from bytes alone.

## Host-honesty note

The vector run verifies deterministic bytes, digests, canonical parsing, and ordinary reopen behavior. It does not claim to prove persistence through WSL virtualization or physical power loss. A future runtime conformance run must record its actual host and storage contract.

## Result

**PASS — strict validator accepted all positives, classified all adversarial vectors as corruption, classified every terminal proper-prefix vector as torn tail, and every planted mutant was killed.**
