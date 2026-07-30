# SPECIMEN-RETURN — de-potestate-revocata

Specimen of lane **Capability /0** (candidate). 24 checks, 0 failures,
two runs byte-identical (`RUN-EXITCODES.txt`). Every authority verdict in
the capture was rendered by a **stage child** through the public surface;
the orchestrator only supervises, digests, and preserves.

## What the bytes prove

1. **The grant was real.** `ARTIFACT-EVENTS.pj0` frame 1 carries grant
   `cap0-event:g-001` for `cap:clavis-arcae` with the terms declared in
   `specimen-common.lisp` (subject `subj:tardigrada`, action
   `act:aperire`, resource `res:arca-prima`, scope `scope:exact`, issuer
   `cap0-issuer:radix`), committed `:newly-committed` at ordinal 1 through
   journal0's public append path (prima-vita checks [003]-[004] in the
   relayed numbering of `RUN-SPECIMEN.txt`). The term values are not
   printed by a check; [004]'s `:authorized` under the charged query is
   the evidence, since any term mismatch refuses instead — controls
   [006]-[008].

2. **The authorization was truthful and prefix-bound.**
   `ARTIFACT-RECEIPT-AT-P.pjs` (sha256
   `1a0abfd1585e6741086ce827d978454043f80895f4449d7c56e6bfa262adca4a`)
   decodes canonically to `:authorized`, reason
   `grant-live-at-validated-prefix`, bound to terminal ordinal 1 + valid
   byte count + terminal digest of the prefix it examined ([004], [010]).

3. **Unrelated history does not revoke; it does date the receipt.** After
   the unrelated event at P+1 the query is still `:authorized` [006], and
   the P-receipt is already detectably not-current [007] — staleness
   begins at the first committed event after issue, not at revocation.

4. **Revocation is a committed event, and refusal is governed.** Frame 3
   (`cap0-event:r-001`) turns the query into `:refused
   capability-revoked` naming BOTH the historical grant and the revoking
   event [008].

5. **The restart re-derives; it does not remember.** The first life
   EXITED (its ledgers and receipt objects died with it). A genuinely new
   process, admitted only to durable bytes + declared configuration,
   reconstructed the IDENTICAL refusal — same grant named, same revoking
   event named — with origin `:reconstructed` and no byte sequence
   "observed" ([012]-[015]). Its store-identity check is against an
   identity derived from declared config (fixed nonce + durability
   through journal0's public metadata surface), never copied off the
   store it judges [012].

6. **The old receipt survives unchanged — as testimony.** Byte-identical
   across the restart (sha256 equal, orchestrator check [021]); still
   TRUE about prefix P (its bound digest is the surviving frame-1 digest,
   [017]); and refused BY TYPE when presented as present authority:
   `cap0-stale-receipt` naming the receipt's binding (ordinal 1) and the
   present validated prefix (ordinal 3), digests distinct ([018]).

7. **Nothing was executed and nothing was written.** EVENTS.pj0
   byte-identical across the entire restart, refusal, and stale
   presentation ([019], [022]).

8. **An unfinished restart cannot pass as a clean one.** The
   `DE_POTESTATE_DIE=1` child exits 3 with no `RESULT:` sentinel; the
   orchestrator detects exactly that pair ([023]).

## Honest limits

- The "genuinely new process" claim rests on OS process death (the first
  life exited before the restart launched) plus the admissible-inputs
  discipline of `stage-restart.lisp`; it is enforced by construction and
  inspection of that stage's source, not by a jail. The declared
  configuration file is shared by design — it carries what every process
  is entitled to know (what the operation was SUPPOSED to be), never what
  the dead process did.
- Deterministic fixed nonce = declared PJ-META-1 deviation (test fixture,
  never a production identity), exactly as journal0's de-teste-occiso
  declared it.
- No SIGKILL is used here: the first life exits cleanly by design, because
  this specimen's subject is authority across restart, not crash-window
  commitment — that subject belongs to de-teste-occiso. Capability /0
  **does not re-prove it and does not inherit a guarantee**: journal0's
  crash-window behaviour is a candidate-level demonstration with §30's
  SIGKILL MUSTs undischarged, so **no crash-window property is claimed
  here at all.**
- All checks are same-family self-consistency; no stranger has run this.

— CLAVIGER (Claude Fable 5 subagent), 2026-07-29
