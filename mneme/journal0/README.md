# journal0 — independently-seeded Common Lisp Process Journal /0 store

The first independently-seeded Common Lisp implementation of **Process
Journal /0** (Mneme's filesystem-backed evidence protocol) plus the Kernel
/0 store boundary, with a registry-driven vector gate run against the frozen
fixture packet. This is the R-PJ-3 / PJ0-ADOPTION-RECORD binding-gate
artifact: the packet's own 1,319-green verification was self-consistency
certification; this lane is the independent seeding it demanded.

**Independence:** written from `LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md`,
`PJ0-PRESEAL-REPAIRS.md` (R-PJ-1..3, incl. PJ-READ-0 binary I/O), the
Kernel /0 store-boundary sections, Kernel Errata 0.2, and the frozen vector
bytes only. The Python reference tool, the kill-9 harness, and all prior
journal machinery (kw-0/hb0/ss0) were **never opened** — see
`ALLOWED-SOURCES.md` (the exposure fence) and `JOURNAL-0-PROVENANCE.md`
(what was actually read, this life; zero Class B).

**History:** built by CONDITOR (killed mid-lane by the 2026-07-29 platform
outage; checkpoint `notes/2026-07-29-journal0-outage-checkpoint.md`), then
verified, repaired, and completed by RESTITUTOR under the same fence. The
predecessor's dying claims were banked as nothing; every result here was
re-derived from executed transcripts in the successor's life.

## Layout

| file | contents |
|---|---|
| `package.lisp` | `#:lisp-plus-journal0` public surface |
| `load.lisp` | dependency order: CD/0 → kernel0 (smoke-checked) → this store |
| `sha256.lisp` | SHA-256 written fresh from FIPS 180-4 (proven against the standard vectors) |
| `conditions.lisp` | the 21 §23 typed conditions + PJ-CND-2 lawful restarts (+ §34 resource refusal) |
| `pjs0.lisp` | PJ-S/0 §5 codec, written fresh — no host READ (PJ-SYN-1), byte-identity gate (PJ-SYN-2), CD/0 abstract domain (PJ-SYN-3) |
| `frame.lisp` | §7 frame grammar + §8 digests (genesis computed, not transcribed) |
| `meta.lisp` | §6 metadata + §6.1 store identity derivation |
| `reader.lisp` | §12 sixteen-step strict reader + §13 terminal classification (PJ-READ-0 binary octets; PJ-TERM-1 no skip-forward) |
| `writer.lisp` | §9 append critical section, §10 durability, §11 locking, §22 store surface |
| `salvage.lisp` | §14 source-preserving salvage + R-PJ-1 origin facet |
| `fold.lisp` | §16/§17 fold, §12 step 16 semantic partner (K0E-26 joint verdicts), reconstruction (PJ-RCN-3), §20 merge |
| `mutants.lisp` | the six §28 planted defective validators (own implementations) |
| `journal0-selftest.lisp` | 66 unit checks (run: `sbcl --script mneme/journal0/journal0-selftest.lisp` from the latent-lisp root) |
| `journal0-vectors.lisp` | **the gate runner** — registry-driven, sha-verifying, counts derived live |
| `RUN-*.txt` | raw transcripts + exit codes + determinism proof (second run byte-identical) |
| `JOURNAL-0-COMPARISON.md` | per-vector comparison vs registry + reference transcript; itemized divergences |
| `JOURNAL-0-PROVENANCE.md` | every file opened, this life; Class B = zero |

## Results (derived live; transcripts are the record)

- selftest: **66 checks, 0 failures, exit 0**
- gate: **89 checks, 0 failures, exit 0** over 3 positive (accepted +
  byte-exact writer rebuild) · 16 adversarial (refused, correct §23
  category) · the full 1,235-member truncation family (PJ-TRN-1/2/3) ·
  6 semantic datum vectors · 5 crash-window scenarios (§29/Annex B; CW-2c/
  CW-3 as scenario metadata over byte-identical files; CW-3 reconciliation
  executed) · 6/6 planted mutants killed by their scorecard-designated
  fixtures · 10 negative controls in which the runner itself is shown to
  notice, each naming the exact check that went red.

## Honest ceilings

1. **No FULL §32.5 conformance claim.** Demonstrated: codec (§32.1), reader
   (§32.2), recovery (§32.4), and writer (§32.3) **except** the §30
   randomized SIGKILL harness, which was not run here. Forced-kill evidence
   belongs to the restart specimen (**de-teste-occiso**, a separate hand,
   to be built against this package's public API).
2. **Durability is a declared host-contract belief (PJ-DUR-3):** fsync(2)
   syscall completion + reopen validation on a Linux ext4 host — never
   power-loss or storage-stack proof.
3. **K0E-15 kernel-side bounded standing is a named exclusion** (Errata §8
   control 13 PARTIAL): the journal half is discharged; the kernel-fold
   construction of bounded determinacy from a torn tail is not built (the
   event projection carries no settlement-payload records — named gap).
4. **Record-key ordering is a corpus-adjudicated divergence** from a §5.10
   ambiguity (see JOURNAL-0-COMPARISON D-2) — candidate for a spec erratum.
5. **This gate is still same-ecosystem verification.** The implementation
   is independently *seeded*, but the §33 cross-language agreement was
   demonstrated against frozen bytes, not against a live independently
   seeded second runtime; and no wholly-outside stranger has reviewed this
   lane. Divergences adjudicate to spec text, not to either implementation.
6. Deterministic crash fixtures cover the representable CW cells; the live
   randomized complement (PJ-KILL-1) remains owed with the specimen.

*— RESTITUTOR (Claude Fable 5 subagent), 2026-07-29*
