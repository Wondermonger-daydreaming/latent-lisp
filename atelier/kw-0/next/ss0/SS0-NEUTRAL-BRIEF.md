# Implementer Brief — Durable-Record Semantic Layer (SS-0)

*DRAFT-FOR-OWNER-REVIEW — not frozen. On freeze, this exact text (hash-recorded) goes to every implementer seat, byte-identical.*

You are an engineer commissioned to build the **application-facing semantic layer** of a small effectful system. You work alone, from this brief and the attached Substrate API only. Build the best system you can; you are not told what any other party built or expects.

## The setting

A process performs operations against an external **provider** (a deterministic fixture supplied by the substrate) that executes **irreversible effects**, returns payloads, or streams chunked output. The process can be killed at any moment by a real OS `SIGKILL` — mid-write, mid-effect, before results are recorded. After a death, a separate **cold recovery program** (also yours) starts with no memory and reads only what survived in durable storage.

The substrate gives you durable framed append-only storage with checksums and fsync orchestration, torn-tail-safe prefix reading, deterministic serialization, the kill harness, and the provider fixture. **What records mean is entirely yours to design.**

## Behavioral obligations (all must hold across ≥3 effect types and ≥2 payload regimes)

- **R1 — No invented history.** Recovery reports only what surviving records warrant. Where two different external histories leave identical surviving records, recovery must report that ambiguity. A causally correct *guess* counts as a failure.
- **R2 — Payload standing survives.** Empty payload, absent payload, and invalid payload are distinguishable end-to-end, including after crash recovery.
- **R3 — No blind re-dispatch.** If an effect was dispatched and its outcome is unrecorded, automatic re-dispatch must be impossible; a refusal must cite record evidence. (The provider does not deduplicate. A double execution is a real double execution.)
- **R4 — Evidence-based resolution.** External attestations (provider receipts) may resolve an unknown outcome only by entering the durable record as new, provenance-carrying entries. Resolution to "executed" must not enable re-dispatch of the same intent.
- **R5 — Distinct succession.** Proceeding despite an unresolved predecessor requires an explicitly distinct successor with fresh identity; the predecessor's unresolved standing stays visible; the successor is not presented as a first attempt or a plain retry.
- **R6 — Derived stays derived.** State reconstructed from records must be distinguishable from directly recorded observation, and re-verification must not upgrade it.
- **R7 — Independent second reader.** A reader in a second programming language, sharing no code with your primary implementation, must derive equivalent recovery state (canonical digest agreement; digest spec is yours, but both readers must implement it independently).
- **R8 — Extension without rewrite.** After your implementation is frozen, one additional effect type will be introduced. Adding it must not require rewriting recovery logic at every call site. You will implement the extension when it is revealed; the delta is measured.
- **R9 — Auditability.** From the records alone, an examiner must be able to reconstruct what was attempted, what is known, what is unknown, and on what evidence.

## Measurement

Application-facing code is measured mechanically (tool provided: non-blank, non-comment lines outside marked death-instrumentation blocks; the marker rule is audited — only readiness markers, kill-waits, and torn-write injection may be marked). Substrate calls are free; **private helpers you write count in full.** There is no pass/fail line on size: smaller is better, correctness and the obligations come first. Every obligation will be tested, including by planted faults.

## Deliverables

Primary implementation; independent second-language reader; a runnable entry point for the scenario corpus (contract in the Substrate API); a short README; a statement of any assumptions.

## What you have and don't have

You have: this brief, the Substrate API document, the substrate itself. You do not have, and must not seek: other implementations, prior experimental reports, or the evaluation criteria (an adjudication exists; it is sealed until after your freeze). If any material outside this brief and the API reaches your context, say so immediately.
