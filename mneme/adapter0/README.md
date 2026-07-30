# Adapter /0 — `#:lisp-plus-adapter0`

> **Do not translate provider ambiguity into kernel certainty.  Preserve
> the envelope, name the boundary, identify the witness, record who was
> exposed, and carry the unknown forward until evidence — not fluency —
> narrows it.**  (AP0 §0, the governing refusal)

The first independently **seeded** Common Lisp implementation of the
adopted Adapter Protocol /0 reissue: a deterministic fake adapter —
descriptor law, identity model, acknowledgment witnessing, stream
custody, envelope custody, structural projection under the exhaustive
absence table, usage/cost separation, cancellation, reconciliation, the
W1–W4 crash windows, and the §19 script machine — derived from the
normative contract and the frozen Class A fixtures alone, under an
exposure fence sealed before any code existed (`ALLOWED-SOURCES.md`,
commit `41df2330`).  **No Class B artifact was opened; the seal stands
unbroken** (`SEAL-RECORD.md`).

**Status: CANDIDATE, phase 1, all gates green at the seal.**  39 + 107 +
21 + 24 + 4 + 24 + 12 checks across seven suites, 0 failures, every
transcript byte-identical across two runs.  48 positive vectors
accepted; 33 adversarial vectors rejected each with its declared
condition; 20 rule-omission mutants killed each by its intended rule;
ten scripts deterministic with fold-derived terminals; the joint gate
keeps structural and Kernel-semantic verdicts separate; the L17 audit is
a generated artifact.  Substrates (journal0, capability0/1/2, kernel0,
CD/0, the AP0 packet) are byte-unchanged and their suites re-run green.

**The boundary paragraph — read before quoting any green.**  The
adoption riders bind: *no conformance claim beyond co-authored
self-consistency, and no specimen reliance on live-provider claims,
until an independently-seeded Common Lisp implementation passes the full
AP0 vector set* — this lane's run is such a pass **by construction of
its fence, but whether it lifts the rider is the owner's adjudication,
not this lane's to declare**; and *no artifact may use the words
"independently verified/validated" of AP0 until a stranger's frozen
report exists* — no stranger audit has been commissioned, and those
words are used of nothing here.  Every green is labeled
**self-consistency-plus-independent-seeding, pending owner ruling**.
Full AP0 conformance (§23 class 6) is not claimed
(`CONFORMANCE-MATRIX.md` holds each class at its earned size).  No live
provider, no spending, no credentials, no network.  The specimen is not
Vertical Specimen /0.

Run everything from the latent-lisp root:

```
sbcl --script mneme/adapter0/adapter0-selftest.lisp
sbcl --script mneme/adapter0/adapter0-vectors.lisp
sbcl --script mneme/adapter0/adapter0-scripts.lisp
sbcl --script mneme/adapter0/adapter0-joint.lisp
sbcl --script mneme/adapter0/adapter0-l17.lisp
sbcl --script mneme/adapter0/adapter0-controls.lisp
sbcl --script mneme/adapter0/de-membrana-loquente/run-specimen.lisp
```

Front door for claims: `ADAPTER-0-RETURN.md` (demonstrations with check
ids, design adjudications, and the full does-not-claim list — this
README asserts nothing beyond it).  Seal: `SEAL-RECORD.md`.  Exit codes:
`RUN-EXITCODES.txt`.  Provenance: `ADAPTER-0-PROVENANCE.md`.  Specimen:
`de-membrana-loquente/` (*de membrana loquente* — the membrane speaks
once, lawfully, and returns a structured outcome).

*— CLAVIGER-IV (Claude Fable 5), 2026-07-30*
