# SS-0 Seat — Statement of Assumptions

1. **Boundary of trust.** Cold recovery (`recover`, `canon`, `redispatch`) reads only
   `records.log` — the seat's own durable record. The provider's world (`provider.log`,
   `receipt-*.txt`) is *external evidence*: it can change standing only by entering the
   record through `admit`, which appends an `att` record carrying source filename,
   content crc32, and the claim (R4). Recovery never consults the provider world
   directly, so two external histories that leave identical records are reported as
   ambiguous (R1), never guessed — even when a peek at `provider.log` would "resolve" it.

2. **Op-id = provider attempt-id.** The seat dispatches with its own op-id as the
   provider attempt-id, so the provider names receipts `receipt-<op-id>.txt` and `admit`
   can match provenance mechanically. A successor's fresh op-id therefore yields a
   fresh receipt identity.

3. **Payload validity criterion (R2).** The seat's parser: a payload is `empty` iff it
   is the empty string; `invalid` iff it contains control characters (codepoint < 32
   other than TAB/LF, or 127); otherwise `valid`. "Absent" is not a payload at all
   (effects carry none). Invalid payloads are recorded by crc32 digest (`pd`) only —
   bytes that fail the parser are not enshrined as data.

4. **SIGKILL semantics.** After SIGKILL, bytes that were written and flushed survive in
   practice; fsync distinguishes power-loss durability, which the harness does not test.
   The seat nonetheless records write-time durability intent (`dur`) and treats any
   outcome without a completion record as `OUTCOME-UNCONFIRMED`, so S5's surviving
   un-fsynced outcome is reported as recorded-but-unconfirmed, not settled.

5. **Recovery is read-only (R6).** `recover`/`canon`/`redispatch` append nothing, ever.
   The only record-writing modes are the runner, `admit`, and `succeed`, which append
   new, provenance-carrying records — never derived state. Re-verification therefore
   cannot upgrade derived standings.

6. **The gate never dispatches.** `redispatch` is a certification oracle, not a
   dispatcher (exit 0 = lawful path exists, 3 = refused, 4 = cannot evaluate). Every
   actual dispatch flows through the runner or `succeed`, always under an identity that
   is declared durable first.

7. **Scenario contract.** The harness invokes `<entry> <run-dir>/ <kind> <killpoint>`
   with kind ∈ {effect, stream, refused}; the seat maps (kind, killpoint) to the frozen
   S1–S7 behaviors and also accepts the S-names directly for standalone runs. S3 and S6
   end at their kill windows by construction (the torn tail is terminal). The payload
   family (`P-complete`, `P-empty`, `P-invalid`, `P-stream`) is seat-added to exercise
   all three payload regimes plus a clean stream; labels `bank-write`, `mint`, `notify`
   give three distinct effect labels across corpus runs.

8. **Anomaly stance.** Malformed, orphaned, duplicate, or mutually contradictory
   records are reported as anomalies (or `CONFLICT` standing) and never silently
   repaired, reordered, or dropped; the torn tail is excluded from all derivation and
   reported as `tail=torn`.

9. **Digest scope.** The canonical rendering covers derived recovery state only
   (standings, evidence, anomalies, tail status) — not wall-clock, paths, or the
   provider world — so the independent CL reader can reproduce it byte-for-byte from
   `records.log` alone. Rendered fields are strings/integers per the vocabulary;
   out-of-vocabulary value types in planted records are surfaced as anomalies where
   detectable, but byte-agreement on adversarially typed fields is not guaranteed.

10. **Environment.** Primary implementation needs Python ≥ 3.8 stdlib only; the second
    reader needs SBCL (verified on 2.4.11). The substrate is used unmodified, byte-identical
    to the packet manifest.
