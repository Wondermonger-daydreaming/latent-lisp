# capability0 — Capability /0, the live-authority candidate

> History may prove that authority once existed; only the validated present
> prefix can say whether it remains live.

The smallest executable **candidate** proving that live authority is
**fold-derived from the currently validated journal prefix**, never
inherited forever from the historical existence of a grant. One root
authority grants and revokes one exact capability; every capability claim
in `CAPABILITY-0-RETURN.md` §1 is executable. Companion board rule
(`mneme/architecture/IMPLEMENTATION-PHASE-BOARD-2026-07-18.md:89`):

> A durable record that authority existed is evidence about the past; it is
> not live authority in the present.

Built on **Journal /0** strictly through its public package exports
(`#:lisp-plus-journal0`); journal0 stays capability-ignorant. Typed
refusals prefer **Kernel /0's** exported condition types
(`capability-missing`, `capability-revoked`, `capability-scope-mismatch`,
`minting-authority-invalid`, `journal-prefix-invalid`); capability0 mints
its own conditions only where kernel0 has no honest match (see
`conditions.lisp` header and `CAPABILITY-0-RETURN.md`).

**Status: candidate.** Not adopted, not frozen, no floor, no stranger
audit. All greens are same-family self-consistency. This lane is *not*
"Vertical Specimen /0" (that reserved name requires a deterministic fake
adapter and four interruption trials — out of scope here) and does *not*
claim the Kernel §19.5 reserved verbs (`mint-capability` /
`check-capability` / `revoke-capability` / `restore-capability`).

## Layout

| file | contents |
|---|---|
| `package.lisp` | `#:lisp-plus-capability0` public surface; the `:import-from` list is the exact journal0 surface consumed |
| `load.lisp` | dependency order: journal0 (which loads CD/0 + smoke-checked kernel0) → this lane |
| `conditions.lisp` | the four own-minted typed conditions, each with its why-not-kernel0 adjudication inline |
| `schema.lisp` | explicit bootstrap authority (`declare-bootstrap-authority`, the no-smuggling gate), grant/revocation event constructors, exact canonical CD/0 equality (`datum=`) |
| `fold.lisp` | `derive-authority-ledger` — live authority derived fresh per query from the validated prefix; terminal-classification law (:valid fold · :torn-tail fold + surfaced tail · :corruption refuse) |
| `receipts.lisp` | receipts bound to store-id + terminal ordinal + valid byte count + terminal digest; `receipt-current-p` staleness detection |
| `query.lisp` | `query-live-authority` (receipt for every answerable question, typed signal for every unanswerable one), `require-live-authority` (kernel0 condition escalation), `present-receipt-as-present-authority` (stale ⇒ `cap0-stale-receipt`; current ⇒ re-derived, never trusted) |
| `mutants.lisp` | `+planted-defects+` (`:cached-status`, `:ignore-revocation`, `:receipt-unbound-to-prefix`) + `run-mutant-kill` |
| `capability0-selftest.lisp` | 28 unit checks incl. all three mutant kills and the planted-fault gate teeth |
| `capability0-controls.lisp` | 36 checks: the twelve laws executed + the negative controls, each naming the exact typed condition/decision that fired |
| `de-potestate-revocata/` | the inhabited restart specimen (separate OS processes; preserved raw artifacts) |
| `RUN-*.txt` | raw transcripts + `RUN-EXITCODES.txt` (exit codes, determinism shas, gate teeth) |
| `ALLOWED-SOURCES.md` | exposure fence (documents exposure; seals no blind protocol — no reference implementation exists) |
| `CAPABILITY-0-PROVENANCE.md` | every file this hand opened |
| `CAPABILITY-0-RETURN.md` | **the deliverable**: what is demonstrated, design adjudications, what is NOT claimed |

## Run recipe (from the latent-lisp root; SBCL 2.4.6)

```
sbcl --script mneme/capability0/capability0-selftest.lisp                    # 28 checks, exit 0
sbcl --script mneme/capability0/capability0-controls.lisp                    # 36 checks, exit 0
sbcl --script mneme/capability0/de-potestate-revocata/run-specimen.lisp      # 24 checks, exit 0
```

Regression gates stay green beside it: journal0's own candidate suites
(`mneme/journal0/journal0-selftest.lisp` 66/0,
`mneme/journal0/journal0-vectors.lisp` 89/0) and the CD/0 floor
`bash mneme/verify-all.sh` (6/6). Exit codes + determinism proof:
`RUN-EXITCODES.txt`.

— CLAVIGER (Claude Fable 5 subagent), 2026-07-29
