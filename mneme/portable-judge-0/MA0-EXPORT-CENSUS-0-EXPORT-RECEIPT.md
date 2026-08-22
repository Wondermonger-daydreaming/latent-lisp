# MA0 EXPORT CENSUS /0 — EXPORT RECEIPT (2026-08-10)

*Chair: Claude Fable 5. Filed on `many-acts-0-candidate`. This receipt records
custody and chair audit of the sealed parcel; it adopts nothing and earns no
evidence. The return awaits owner disposition. It is a separate return from the
Parcel B execution return (separate branch, separate parcel, separate receipt,
separate commits), per Ruling 6 §5.*

## Provenance — crash and reconstruction

The census had not been built when the chair's process died (the branch
existed with zero commits; recovery inventory in the campaign log, commit
`4ea6288b`). This return is a fresh build from Owner Ruling 6 §3 B7 + §5.2, by
agent CENSOR (Claude Opus).

## Parcel identity

| Field | Value |
|---|---|
| File | `~/Downloads/ma0-export-census-0-2026-08-10.tar.gz` |
| Outer SHA-256 | `acedd92a366173377eb436b323113820b1705db2f2d7087c0a2e3aaf76f9325d` |
| Size | `19,439` bytes |
| Manifest | 11/11 payload hashes green on extraction round-trip; manifest excludes itself |
| Branch / tips | `ma0-export-census` @ `1e8e03d899c9b515b41b0c21ac87a9b0bb76c17e` (artifact commit `9890f9b5`, named-in-ceiling commit `1e8e03d8`) |
| Base | `48e59db311888b7b1b123289477a923a54689963` |
| Adopted R1 coordinate | `231873c7be8ba275cd5756c929efba2f9c807157` (freeze tip; lane subtree `e94870bd…` per the R1 adoption record — chair-verified against the record) |
| `package.lisp` blob there | `a97d3c3e2f6baa21f21c52ae0c4986140eb1fa5c` (proven identical at freeze tip, freeze record, R1 return, base, and worktree — coordinate question dissolved by identity) |
| Diff shape | 10 files, ALL additions, all inside `language-many-acts-0/export-census/` |

## Chair audit (performed this session, commands run by the chair)

- **Roll:** `EXPECTED-EXPORTS.txt` = exactly 38 non-comment lines, sorted
  (`sort -c` clean), derived statically from `package.lisp` at `231873c7` by
  two independent extractions (regex sweep + reader-based structural walk)
  that fail closed on disagreement. Chair cross-check: the only `#:` symbols
  at the coordinate not on the roll are `#:cl` and the package's own name —
  pure package machinery. 38 is reported as derived cardinality only; the gate
  compares names, never counts.
- **Teeth 3/3 fired, each caught by a different check**, planted-fault
  transcripts saved BEFORE the clean one: (01) unexpected export — a genuinely
  `fbound` internal, so boundness alone would have passed it → set-equality
  refusal, exit 1; (02) missing + substituted **with cardinality still 38 on
  both sides in the same refusing run** — the ruling's own scenario — both
  directions named, exit 1; (03) unbound expected export with the roll
  byte-untouched → boundness refusal, exit 1. Fault plants reverted with blob
  identity proven; subject sources appear in no commit.
- **Clean gate:** exit 0 — exact set equality, 38 exports, 0 missing /
  0 unexpected / 0 unbound, all externals homed in `LISP-PLUS-MANY-ACTS0`.
  **Chair readback: the chair re-ran the gate and reproduced exit 0** with the
  same verdict line (SBCL 2.4.6 operation-checked through the wrapper first).
- **Designations:** 27 function / 8 condition-class / 3 variable / 0 structure
  type (zero by subject design — private `:conc-name`s; the four `…-p` names
  are `:predicate`s). Six of the eight condition classes are minted inside a
  `macrolet` — no `define-condition` line exists for them; a naive grep would
  have called them undefined.
- **Instrument honesty:** CENSOR self-caught a false transcript (`PIPESTATUS`
  read after an intervening `echo` reported exit 0 for a refusing run), built
  `capture-tooth.sh` to capture `$?` from the gate process directly, and
  recorded the defect in return §4.2. All four transcripts use the fixed tool.

## Standing

CANDIDATE, branch-local, bounded: on `ma0-export-census` at `1e8e03d8`, the
census gate found exact set equality and all 38 expected exports bound in
their designated categories. **Nothing more.** The gate fails closed off SBCL
2.4.6; one implementation on one version is not portability. No
independent-implementation, conformance, or independent-verification claim.
Same-author evidence; **evidence earned: ZERO**; stranger audit remains OWED.
A future legitimate export change must regenerate the roll from its new
coordinate — hand-editing the roll green inverts the instrument (return's own
warning). S-freeze not reached.

— Claude Fable 5, chair
