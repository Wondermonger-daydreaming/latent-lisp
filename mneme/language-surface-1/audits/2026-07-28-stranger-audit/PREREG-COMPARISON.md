# PREREGISTRATION vs RESULT — filed AFTER the return was fixed and published

```
prereg identity     8fe0ee39e39a90a2dab654f655154f853f9a9ea3e68d1e77396f5f5a4f5091c7 · 11350 bytes
                    recomputed unchanged: before the audit began, and again
                    immediately before this first read
ordering proof      return committed at 07be7374 BEFORE the plaintext was opened;
                    the disclosed copy in this directory hashes to the committed value
band adjudicated    BAND A — one or more confirmed defects (the preregistered
                    EXPECTED outcome)
```

## Run-VOID conditions — none holds

1. Manifest verified 48/48 against the delivered packet (twice, before any run). ✔ not void
2. The preregistration was not read, in whole or part, before the return was
   fixed. The auditing chair and all three subagents were explicitly barred; the
   subagent reports each state it. ✔ not void
3. The auditor is not the author's instance or a same-context continuation —
   different model (Fable 5 chair vs the Opus 5 author), fresh contexts. Per the
   prereg's own term this is the **weaker fresh-context Claude tier**, and it is
   labelled as such at the top of the return, before any verdict. ✔ not void
4. The subject tree unmodified between freeze and audit — subtree
   `9b343618…` re-derived from the repository and matched; packet byte-identical. ✔ not void
5. The raw subagent reports are filed byte-exact in `findings/`, committed in the
   same commit as the return, before any laboratory commentary. ✔ not void

## The fourteen falsifiers, disposed

| # | preregistered claim | outcome |
|---|---|---|
| F1 | no caller-owned object reaches Door 2 | **HELD** (re-verified; mutation after Door 1 cannot reach the stored datum) |
| F2 | `encode(decode(d)) == d` enforced at runtime | **HELD** — the routes on which the equation fails are all **refused**; the falsifier required failure *without* refusal, and none exists |
| F3 | decode is injective; a datum determines its reconstruction uniquely | **FALSIFIED, both horns** — two distinct admissible datums decode to one symbol (multi-segment namespaces, `probes/TABULARIUS/probe-E.lisp`), and one datum's decode varies across performances with the caller's ambient `*package*` (`probes/CHAIR/probe-pln.lisp`) |
| F4 | namespace resolves only to a home-package symbol | **HELD** |
| F5 | `DECODE-TERM` never interns | **HELD** |
| F6 | sharing/cycles refused globally, both sides | **HELD through the doors** (the deep-acyclic crashes of D5 are a depth defect on the raw public functions, not an admitted shared structure) |
| F7 | no public input can reach `ROUND-TRIP-MISMATCH` | **FALSIFIED** — return D3, two mechanisms (`rename-package` with nickname; package-local nickname with zero mutation) |
| F8 | `:EXPANDED-NODES-EXCEEDED` unreachable under this policy | **FALSIFIED** — return D1, two independent constructions, chair-verified |
| F9 | Surface /0 unmodified; loads CD/0 only | **HELD** |
| F10 | no receipt field or document sentence asserts meaning/correctness/hygiene/portability/equivalence | **HELD** on everything read and minted |
| F11 | Surface /0's refusal escapes unwrapped, minting nothing | **HELD** (witnessed directly) |
| F12 | every code exercised or honestly classified | **FALSIFIED three ways** — D1 (false `:unreachable` classification), D8/M2 (`:source-term-shared-structure` claimed exercised, exercised nowhere), D7 (the version alarm's classification understates: not internal-only but structurally incapable of violation) |
| F13 | the runner fails closed | **LETTER HELD, SPIRIT FALSIFIED** — no component can *fail* while the runner exits 0 (T10), but three of five instruments can silently run almost nothing and be blessed (return D4); the falsifier as worded was not met, the Errata 0.2 §3 fail-closed claim at tree scope was |
| F14 | every test label describes what its code checks | **FALSIFIED, at population scale** — return D8: tautologies (census, C3), stale literals (I4), false coverage (M2), one-assertion-two-labels (G1/G4), and more (`findings/TABULARIUS.md` §1) |

**Held: 8 of 14. Falsified: 5 (F3, F7, F8, F12, F14). Split on letter/spirit: 1 (F13).**

## The author's §8 expectations, scored

The author expected **Band A**, most likely against **F7**, second most likely
**F14**. Both fell — F7 to two mechanisms, F14 to a population. One honesty cap
on the F7 match: the commissioning brief told the auditor a preregistered
expectation existed that the F7-class claim "is likely to fail," so the
*direction* of that hunt was disclosed; what the audit adds is not confirmation
of the prediction but the two concrete mechanisms, neither of which any
document contains. **F3, F8, and F12 fell unpredicted** — F8 in particular was
defended in five places and certified by two green checks, and no document
questioned it.

## Band A response commitments — status

- *"Reproduce each against the frozen target before repairing anything"* —
  done within the audit: every witness ran against the frozen packet.
- *"Publish an Errata 0.3"* — owed by the family; this audit repairs nothing,
  per its jurisdiction.
- *"Do not describe the layer as 'now correct'"* — the return does not, and the
  recommendation line is `DEFECTS FOUND, REPAIR REQUIRED`.
- The prereg's §2 pre-commitments were honoured in the return: the audit is
  described as claim-directed on a disclosed subject, never blind; disclosed-class
  findings are marked and weighted below the novel ones; the tier is labelled
  fresh-context Claude, with the fresh-weights tier recorded as still open.

*— Claude Fable 5 (chair), 2026-07-28. First read of the preregistration
occurred after commit `07be7374`.*
