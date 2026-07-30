# capability1 — Capability /1, the minting-bridge candidate

> A receipt may explain why a key was minted; it is not the key, and its
> description cannot forge one.

The smallest executable **candidate** demonstrating the Kernel /0 §11.3
minting bridge over §11.2 opaqueness **at this slice's scope (in-process,
non-adversarial, EQ-recognition)**: a truthful **Capability /0**
authorization receipt can justify minting an **opaque live capability
object** whose authority lives in **process-local recognition** (EQ
membership in an explicit minting context) — and no serialized public
field, receipt, printed form, or field-copy can, **in this process and
against honest misuse or description-forgery, reconstruct, counterfeit,
or replace it. Boundary: no resistance to a hostile same-process attacker
with introspection access to a LIVING minting context is claimed — see
`CAPABILITY-1-RETURN.md` §2.2 and §3.** The key dies with its process;
only truthful testimony survives. Companion discipline, executed and mutant-killed: **the context
recognizes; the journal decides** — every presentation re-validates the
journal fresh; the recognition context never decays into a liveness cache.

Built on **Capability /0** strictly through its public package exports
(`#:lisp-plus-capability0`) and **Journal /0** through
`#:lisp-plus-journal0`; both substrates unchanged and
capability-object-ignorant. Typed refusals reuse /0's exported conditions
where the meaning is identical (`cap0-bootstrap-missing`,
`cap0-bootstrap-store-mismatch`, `cap0-stale-receipt` on the mint path) and
kernel /0's `journal-prefix-invalid` at the corruption frontier; capability1
mints its own conditions only where no substrate condition is honest (see
`conditions.lisp` header and `CAPABILITY-1-RETURN.md`).

**Status: candidate.** Not adopted, not frozen, no floor, no stranger
audit; all greens are same-family self-consistency. Substrate statuses at
first mention: **capability0 and journal0 are themselves candidates** (not
audited, not adopted, not frozen; journal0's PJ0 §32.5 FULL is NOT
claimed) — nothing here inherits a guarantee from them. This lane is *not*
"Vertical Specimen /0" and does *not* claim the Kernel §19.5 reserved verbs
(`mint-capability` / `check-capability` / `revoke-capability` /
`restore-capability`): its entry points are the deliberately unreserved
`mint-from-authorization` and `present-live-capability`, because claiming
the reserved verbs would imply the full §11.3/§11.4 semantics (delegates,
effect classes, expiry, budgets, revocation registry) that this slice does
not perform.

## Layout

| file | contents |
|---|---|
| `package.lisp` | `#:lisp-plus-capability1` public surface; the two `:import-from` lists are the consumed substrate surface |
| `load.lisp` | dependency order: capability0 (which loads journal0 + CD/0 + smoke-checked kernel0) → this lane |
| `conditions.lisp` | the five own-minted typed conditions, each with its why-not-substrate adjudication inline; the reuse list |
| `context.lisp` | `make-minting-context` — the explicit recognizer (EQ table of objects it minted); never ambient, never a liveness cache |
| `object.lisp` | the opaque `live-capability` struct: internal constructor, no copier, public-identity-only printing, defensive readers (§11.5), four-facet prefix binding |
| `mint.lisp` | `mint-from-authorization` — the §11.3 bridge subset: /0 present-receipt discipline for standing, exact-copy scope procedure, derived occurrence/public identities, the public minting receipt |
| `present.lisp` | `present-live-capability` — recognition (EQ) → exact term discipline → FRESH journal validation + four-facet staleness check; success = presentation receipt, refusals = typed signals only |
| `mutants.lisp` | `+planted-defects+` (`:context-as-liveness-cache`, `:serializable-authority`, `:public-constructor`) + `run-mutant-kill` |
| `capability1-selftest.lisp` | 30 unit checks incl. all three mutant kills and the planted-fault gate teeth |
| `capability1-controls.lisp` | 27 checks: the owner's vertical executed end to end + the negative controls, each naming the exact typed condition/decision that fired |
| `de-clave-mortua/` | the inhabited dead-key restart specimen (separate OS processes; preserved raw artifacts) |
| `RUN-*.txt` | raw transcripts + `RUN-EXITCODES.txt` (exit codes, determinism shas, gate teeth) |
| `ALLOWED-SOURCES.md` | exposure fence (documents exposure; written at lane close and says so — no pre-coding ordering claim) |
| `CAPABILITY-1-PROVENANCE.md` | every file this hand opened |
| `CAPABILITY-1-RETURN.md` | **the deliverable**: what is demonstrated, design adjudications, what is NOT claimed |

## Run recipe (from the latent-lisp root; SBCL 2.4.6)

```
sbcl --script mneme/capability1/capability1-selftest.lisp                 # 30 checks, exit 0
sbcl --script mneme/capability1/capability1-controls.lisp                 # 27 checks, exit 0
sbcl --script mneme/capability1/de-clave-mortua/run-specimen.lisp         # 29 checks, exit 0
```

Regression gates stay green beside it: capability0's candidate suites
(28/0 selftest, 36/0 controls, 24/0 specimen — transcript byte-identical
to its committed capture), journal0's candidate suites (66/0 selftest,
89/0 vectors), and the CD/0 floor `bash mneme/verify-all.sh` (6/6). Exit
codes + determinism proof: `RUN-EXITCODES.txt`.

— CLAVIGER-II (Claude Fable 5 subagent), 2026-07-29
