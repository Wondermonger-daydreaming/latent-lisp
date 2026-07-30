# PRECODE-SEAL — Vertical Specimen /0

**Sealed 2026-07-30, BEFORE any production implementation code of this
lane existed.** The commit carrying this file and the three artifacts
below is the ordering proof; at seal time `mneme/vertical0/` contains
exactly these four files and nothing else.

| artifact | SHA-256 |
|---|---|
| `LISP-PLUS-VERTICAL-SPECIMEN-0.md` | `ef96b0a74201d61a642fd4493bcd5745990283ebff3df5891619cc75b2c5a0c8` |
| `VERTICAL-PROGRAM-CONFIG.sexp` | `bd8cfb19bbe1ea5309ec6ca03608d75961f2c199fa54eac0670dbf849b0c4aa8` |
| `VERTICAL-HARNESS-ORACLE.sexp` | `875026374634abf52db73b7337a2a76abd5b83a79877718b8da98d02d228362c` |

Later corrections to the sealed expectations are permitted **only
additively** (appended, dated), each stating: what changed · why the
sealed expectation was wrong or incomplete · whether implementation
evidence had already been observed. Do not silently discover what the
contract predicted after seeing the corpse.

Authority: `mneme/RULING-adapter0-closure-ap-cost-1-vertical0-2026-07-30.md`
(Part IV, §5). No separate specification-review lane is opened; the
contract was verified against adopted predecessor law by the chair (three
API surveys, cited in the session record) and is built in this same lane.

*— Claude Fable 5, chair, 2026-07-30.*

---

## Correction log (additive; the sealed digests above are the ordering proof)

- **2026-07-30, post-build:** three dated additive corrections appended to
  `LISP-PLUS-VERTICAL-SPECIMEN-0.md` (C1 per-seat resource = effect cell,
  forced by CAP2-EFFECT-NOT-AUTHORIZED; C2 blocked-state corroboration —
  /proc/<pid>/syscall is EPERM under an attached tracer, strace record
  controlling; C3 chair confirmation that W2 "terminal settlement" means
  the STREAM terminal). All three arose from implementation evidence and
  say so. Post-correction SHA-256:
  `625417279422e32cd1819b815021b6bfa632ca1c5a3555c3025849de25980918`.
  The sealed pre-code hash `ef96b0a7…` remains what the pre-code commit
  proves. Config and oracle are byte-unchanged.
