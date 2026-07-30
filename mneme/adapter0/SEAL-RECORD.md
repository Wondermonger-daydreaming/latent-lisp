# SEAL-RECORD — Adapter /0, phase 1

**Lane:** the first independently seeded Common Lisp deterministic fake
adapter under the adopted Adapter Protocol /0 reissue.
**Fence:** `mneme/adapter0/ALLOWED-SOURCES.md`, committed `41df2330`
BEFORE any implementation code existed.
**Builder:** CLAVIGER-IV (Claude Fable 5 subagent), 2026-07-30.
**Host:** Linux 7.0.0-28-generic · SBCL 2.4.6 (operation-checked live via
`(lisp-implementation-version)` through the `~/.local/bin/sbcl` wrapper
before any CL ran; output not transcript-preserved).

## The seal statement

**All gates green at the first complete transcript set.
No Class B artifact was ever opened; the seal stands unbroken.**

Every hand on this lane read Class A material only (the full inventory is
in `ADAPTER-0-PROVENANCE.md`).  No differential diagnosis was needed; no
phase-2 exposure occurred as of this record.  Per the fence's protocol
step 4, this lane records: the state machine below was derived from the
normative contract and the frozen Class A fixtures alone.

## Gate tallies (live counters, first complete run)

| Gate | Transcript | Checks | Failures | Exit |
|---|---|---:|---:|---:|
| unit selftest | `RUN-SELFTEST.txt` | 39 | 0 | 0 |
| registry vector gate (81 cases + 20 mutants) | `RUN-VECTORS.txt` | 107 | 0 | 0 |
| script determinism gate (10 scripts × 2 runs) | `RUN-SCRIPTS.txt` | 21 | 0 | 0 |
| joint structural/semantic gate (§24.3) | `RUN-JOINT.txt` | 24 | 0 | 0 |
| L17 route audit (§25) | `RUN-L17.txt` | 4 | 0 | 0 |
| permanent negative controls | `RUN-CONTROLS.txt` | 24 | 0 | 0 |
| specimen `de-membrana-loquente` | `de-membrana-loquente/RUN-SPECIMEN.txt` | 12 | 0 | 0 |

Registry arbitration inside the vector gate: 48 positive accepted ·
33 adversarial rejected **each with its declared condition** · 20 mutants
killed **each by its intended rule** (strict reject with declared
condition + accept under exactly that one rule disabled) — all counts
derived live from `AP0-FIXTURE-REGISTRY.sexp`, cross-checked against its
own scalars.

## SHA-256 of every transcript file (first run = second run, byte-identical)

```
de2ae6c55aa780dbebf13a3af896eeca1709cd434bf0754642529e72db80e70a  RUN-SELFTEST.txt
de2ae6c55aa780dbebf13a3af896eeca1709cd434bf0754642529e72db80e70a  RUN-SELFTEST-SECOND.txt
35b279780d43bed8c9923d2d977666da3506073864faa919448e798675e2ca95  RUN-VECTORS.txt
35b279780d43bed8c9923d2d977666da3506073864faa919448e798675e2ca95  RUN-VECTORS-SECOND.txt
94d4959cfe66e3ce04ac920c0769a06a80238a6e8e2d2b5d340fc82d43c36669  RUN-SCRIPTS.txt
94d4959cfe66e3ce04ac920c0769a06a80238a6e8e2d2b5d340fc82d43c36669  RUN-SCRIPTS-SECOND.txt
514a45884782dbe0f714f2bb164dfa137f58631b4bc95925730d83c207b37a44  RUN-JOINT.txt
514a45884782dbe0f714f2bb164dfa137f58631b4bc95925730d83c207b37a44  RUN-JOINT-SECOND.txt
259d522459ccea82318c2c9abdfbb8a92958a90177882360233fbcbe6c2f8913  RUN-L17.txt
259d522459ccea82318c2c9abdfbb8a92958a90177882360233fbcbe6c2f8913  RUN-L17-SECOND.txt
f450cf1ad84873d9a92ae69255481188fdf41a197cc3f487eb783c00abac9c45  RUN-CONTROLS.txt
f450cf1ad84873d9a92ae69255481188fdf41a197cc3f487eb783c00abac9c45  RUN-CONTROLS-SECOND.txt
cf717e13217216587c8a8d0edae4d226f0fe9410498e035e6fc93403c3f99ebd  de-membrana-loquente/RUN-SPECIMEN.txt
cf717e13217216587c8a8d0edae4d226f0fe9410498e035e6fc93403c3f99ebd  de-membrana-loquente/RUN-SPECIMEN-SECOND.txt
```

Each first/second pair above is byte-identical (identical digests;
`cmp` silent) — the determinism claims are proven by content, not by the
suite's own say-so.

Generated conformance artifact:

```
f627da5c4fb05fcd56385445ea9528a49ad1e9108bcc529bf71a7216f1880825  L17-ROUTE-AUDIT-ARTIFACT.md
```

Preserved specimen artifacts are hashed in
`de-membrana-loquente/ARTIFACT-SHA256SUMS.txt` (7 lines, written by the
specimen itself from live bytes).

## Regression gates (nothing outside `mneme/adapter0/` modified)

| Suite | Result | Exit |
|---|---|---:|
| capability2 selftest | 29 checks, 0 failures | 0 |
| capability2 controls | 27 checks, 0 failures | 0 |
| capability2 specimen | transcript BYTE-IDENTICAL vs committed | 0 |
| capability1 selftest | 30 checks, 0 failures | 0 |
| capability1 controls | 27 checks, 0 failures | 0 |
| capability1 specimen | transcript BYTE-IDENTICAL vs committed | 0 |
| capability0 selftest | 28 checks, 0 failures | 0 |
| capability0 controls | 36 checks, 0 failures | 0 |
| capability0 specimen | transcript BYTE-IDENTICAL vs committed | 0 |
| journal0 selftest | 66 checks, 0 failures | 0 |
| journal0 vectors | 89 checks, 0 failures | 0 |
| `mneme/verify-all.sh` | ALL FLOORS HOLD — 6/6 suites green | 0 |

`git status --porcelain`, filtered to exclude this lane's own new files
and `_staging/`, is EMPTY: zero modifications outside `mneme/adapter0/`.

## Post-exposure corrections

None.  (This section exists because the fence requires it; it is empty
because Class B was never consulted.)

## What this seal does NOT claim

Everything in `ADAPTER-0-RETURN.md` §does-not-claim applies verbatim; in
particular the adoption riders' standing is the owner's adjudication, not
this record's, and the words "independently verified/validated" appear
nowhere in this lane's claims about itself.

*— CLAVIGER-IV (Claude Fable 5), sealed at the first complete transcript
set, 2026-07-30*
