# MA0 EXPORT CENSUS /0 R1 — EXPORT RECEIPT (2026-08-10)

*Chair: Claude Fable 5. Filed on `many-acts-0-candidate` under Owner Ruling 6A.
This receipt records custody and chair audit of the R1 repair parcel; it adopts
nothing and earns no evidence. Sealed and returned SEPARATELY from the Parcel B
execution integration, per Ruling 6A item 9.*

## What R1 is

Ruling 6A found a precise instrument defect in the accepted Census /0:
`ma0-export-census.sh --table P` (and the Lisp half's arbitrary table argument)
permitted **expectation substitution** — a live package with `ma0-selftest`
replaced by the bound internal `ma0-refuse`, paired with a correspondingly
substituted table, could obtain the success sentinel. The submitted
default-table teeth and clean observation remain accepted; only the instrument
required repair. R1 repairs the instrument. The submitted parcel, commits
(`9890f9b5`, `1e8e03d8`), four original transcripts, roll, and archive
(`acedd92a…`) are preserved byte-unchanged — chair-verified zero-diff.

## Parcel identity

| Field | Value |
|---|---|
| File | `~/Downloads/ma0-export-census-0-r1-2026-08-10.tar.gz` |
| Outer SHA-256 | `3e14f3510b7afb5d01919ab0809eaf8541b9fba4a97b195d9e7b5dc8ed5b0b9c` |
| Size | `26,542` bytes |
| Manifest | 10/10 green on extraction round-trip; excludes itself; zero self-references |
| Branch / commits | `ma0-export-census`: `1e27f67e` (repair + transcripts) → tip `ec60b34b` (R1 return) |
| Base | `1e8e03d899c9b515b41b0c21ac87a9b0bb76c17e` (the accepted Census /0 tip) |
| Diff shape | 2 modified (`ma0-export-census.sh` `440cf5fe`→`e968da17`; `ma0-export-census.lisp` `1a596ee9`→`fccb2df0`) + 7 added; nothing else |

## Binding identities (Ruling 6A item 2, all chair-verified present)

* adopted coordinate `231873c7be8ba275cd5756c929efba2f9c807157`
* `package.lisp` blob `a97d3c3e2f6baa21f21c52ae0c4986140eb1fa5c`
* `EXPECTED-EXPORTS.txt` blob `78592073905450ff9afcd22dea53afbf53764fa1`
  (roll blob re-verified at tip — unchanged)

## Repair construction (item-by-item against Ruling 6A)

1. **Arbitrary-table selection removed:** `--table` is refused with exit 2
   (not silently ignored), citing Ruling 6A item 1.
2–3. **Expected side bound, fail-closed before census evaluation:** the driver
   checks `git hash-object EXPECTED-EXPORTS.txt` = `78592073…`, checks
   `231873c7:…/package.lisp` = `a97d3c3e…`, AND byte-regenerates the table via
   `derive-expected-exports.sh 231873c7` + `cmp`.
4. **Direct Lisp-half invocation cannot emit the sentinel:** the sentinel text
   exists at exactly one site, inside `CENSUS-EMIT-SENTINEL`, whose first act
   re-reads the table from disk and recomputes its git blob object id with a
   SHA-1 implemented in that same file, exiting 2 without printing unless it
   equals `78592073…`; the same self-performed check also runs before parse and
   before subject load — neither half trusts the other, and no external tool,
   flag, or env var can assert verification. The in-file SHA-1 is known-answer
   tested on every run (empty, `"abc"`, 56-byte padding boundary) and was
   checked against `git hash-object` on three real lane files.
5. **Expectation-injection tooth (four legs):**
   * leg A — **control**: the PRE-repair Lisp half against the count-preserving
     substituted roll → **exit 0, sentinel PRESENT** — *the ruled cheat
     demonstrated actually working before the repair refuses it*;
   * leg B — repaired driver `--table` → exit 2, sentinel ABSENT;
   * leg C — repaired Lisp half direct, substituted roll → exit 2, sentinel ABSENT;
   * leg D — repaired driver, planted package, bound roll → exit 1, sentinel ABSENT.
6. **Original teeth re-run in order with the repaired instrument**
   (`transcripts-r1/`, fault-before-clean): unexpected → 1; missing/substituted
   at cardinality 38 → 1; unbound → 1; repaired clean run → **0**.
7. **Restoration proven after every plant:** each transcript prints
   `git hash-object` before/planted/restored; harness refuses to plant
   off-baseline. Final blobs `a97d3c3e…` / `7a2c093e…`; neither subject file
   appears in any R1 commit.
8. **Quantifier corrected in the R1 return §7** (original return not edited):
   artifact commit `9890f9b5…` introduced the operational artifacts; tip
   `1e8e03d8…` filed the return document.
9. **Separate seal, separate return** — this receipt; no bundling with the
   Parcel B execution integration; B1–B6 not reopened; S-freeze not advanced;
   PortJ-F/0, hidden bank, J2 remain closed.

## Chair audit (commands run by the chair, this session)

- Diff confinement exact (2 M + 7 A, all in `export-census/`); worktree clean.
- Preservation zero-diff over roll, four original transcripts, R0 return,
  `derive-expected-exports.sh`, `capture-tooth.sh`; roll blob `78592073…` at tip.
- Parcel re-hashed `3e14f351…` exact; manifest round-trip 10/10.
- **Behavioral readback, chair's own hand:** clean repaired driver → exit 0,
  sentinel present exactly once; `--table /tmp/fake` → exit 2, sentinel absent;
  direct Lisp half with arbitrary table → exit 2, sentinel absent
  ("The normative success sentinel is UNREACHABLE on this path"). Sentinel
  greps 1 / 0 / 0.

## Red flags (CENSOR-II's own, carried verbatim in substance)

1. Same-hand repair — construction and tooth are one author's; leg A's
   pre-repair binary fact is the closest thing to an outside here.
2. Binding is to bytes, not to correctness — a wrong coordinate would be
   enforced flawlessly.
3. Check 3c re-runs `derive-expected-exports.sh`, an R0 artifact exercised but
   not re-audited line-by-line.
4. The in-file SHA-1 is new code — known-answer gated, fails closed, least
   tested in the lane.
5. Tooth 00 leg D and tooth 02 plant the same fault — one fault twice, not two
   independent confirmations.
6. Nothing is claimed against an adversary who may edit the gate's own source;
   only the ruled substitution path is closed.

## Standing

CANDIDATE, branch-local, same-author. **Evidence earned: ZERO.** No
portability, independent-implementation, conformance, or affirmative
independent-verification characterization. Stranger audit remains OWED.

— Claude Fable 5, chair
