# SS-0 FREEZE LEDGER

*Maintained by the chair (Fable, Claude Fable 5). Every freeze is a SHA-256 here; amendments append, never rewrite.*

## Step status (protocol §freeze procedure)

| Step | Status |
|---|---|
| 1. Substrate frozen; VOID-2 audit + teeth-check | **DONE 2026-07-19** — selftest 11/11 both directions; audit PASS on real, FAIL on planted (transcript below) |
| 2. Adjudication packet sealed | **DONE 2026-07-19** — plaintext in gitignored/mirror-excluded `_staging/ss0-sealed/`; hash below. Battery = Kimi's authored seed set; amendments per §6 of the sealed packet |
| 3. Neutral brief frozen | **DONE 2026-07-19** — seat packet assembled (hash below); ss0-void2-audit.py deliberately EXCLUDED from seat packet (its term list would leak the excluded concepts) |
| 4. Owner seeds Seat A + Seat B | **PENDING — owner's lever** |
| 5–8. Implementation freezes → reveal → runs → unseal | pending |

## Hashes

```
e9c26bdd0bd197f43a2aeb693d296126337cf60a1569fcbe14a9df5b236073ef  SS0-NEUTRAL-BRIEF.md
46fe32bb28f9ff128a9e3787d13a772261d92511ce36b8b31d29b6d455b30acc  SS0-SUBSTRATE-API.md
2c87e4ca2001d168b2a142de514831fe4e8f3b64c3941dfbe935e30510b5388b  SS0-PROTOCOL.md
46e8ff7a171ff7307a7767565403fbf18b5ad94a1e00f695a528c143b481a077  SS0-SEATING-PROPOSAL.md
8140671f53854344d8dffe5778b55e37d8fd167890f3528880efd4024f54feed  SS0-ADJUDICATION-PACKET-DRAFT.md
7594a862bd07ab8632b4a5c41ee50bfb459117d94166674d198ecb759f2de252  substrate/ss0-substrate.lisp
3bcf36123e1e86e37c539b7d959987e5a8c9b4be8ce8fc9f190a2f4bf7186696  substrate/ss0_substrate.py
e2bac1dfa102e29ba0db15c1eee624ffbdfb6911acfe307d435e98e8e0cbfea1  substrate/ss0-provider.lisp
4b2438bcb462344400ab0ccb1dde2f78da55f2b7e3a5c60ee0e328a77b207575  substrate/ss0_provider.py
9d3f3a6196652ff9dbd1e6e34548646b3e1064a8cd518f22be71eae9a6e1abf6  substrate/ss0-harness.py
99098fc7a87a40fec17a0c296aa7a47e47646f799e1f734626c63ddef81c5ed4  substrate/ss0-afel.py
2d2b9659e96c82f88af70e0975f8367269d97496c1df2c67f4a5d9d42c3bbf60  substrate/ss0-void2-audit.py
52b4dcd1daf7a806aec05436a26f4d2ef981a22377c7536fcbeba30aeeff73b2  substrate/ss0-selftest.py
45e1e39091c49cabb1c80ad87a82de934743a40c07da14a96249ae0768aedab3  substrate/test-cl.lisp
a65a5eaeb50c0e9bbbd52b67a5eff392580c192a74ad3c6bdbaf3c09dfdbff6a  substrate/SCENARIOS.md
f92f0f21faa53a06dabdb0da5e4bead72aaea75a2097ef674077e23a6df652e5  substrate/VOID2-TEETH-CHECK-TRANSCRIPT.txt
fb1b18fa7fe75aff6034d11b6ca6f41c3ecac2e1b3b12d59a96fc00b5c44b920  ~/Downloads/SS0-SEAT-PACKET.zip (byte-identical copy per seat)
673e1126c5cf91baa955061231ddc64e7c245017163ffe34c4e669e533473aaf  SS0-ADJUDICATION-SEALED.md (SEALED; plaintext _staging-only)
7bf5abada93831c6193538100441fcf7af8aa7649abca2d8ac30d16b246505bf  SS0-EXTENSION-SEALED.md (SEALED; plaintext _staging-only)
```

## Notes

- Sealed plaintexts exist ONLY in `_staging/ss0-sealed/` on this host (gitignored; mirror-sync-excluded). Owner is advised to keep an offline copy; loss would force new, disclosed commitments.
- The step-6 reveal will include a mechanical provider-fixture delta (provider-side only), hash-frozen at reveal — noted now so its later appearance is not a surprise; its content reveals nothing before then.
- VOID-1/VOID-3 teeth-checks run against the first delivered implementations, before verdict-bearing runs (sealed packet §4).

## Seat custody record (prepared 2026-07-19, pre-seeding)

Two byte-identical seat copies staged at `~/Downloads/ss0-seats/{seat-a,seat-b}/`, each containing exactly two files:

```
fb1b18fa7fe75aff6034d11b6ca6f41c3ecac2e1b3b12d59a96fc00b5c44b920  SS0-SEAT-PACKET.zip (17,794 bytes; verified = original in both copies)
3bc0587375025fd4dae99d5afd074a8f6175b093aa864215c6f23452c4ecbc24  SEED-PROMPT.txt (identical bytes both seats)
```

Custody rules bound at staging: the archive travels UNOPENED (the zip boundary + hash are custody evidence — no repackaging, no per-provider editions, no extra files); the seed prompt is the ONLY accompanying text; each seat is a fresh session with no conversation history. On seeding, the owner records per seat: model + provider, session freshness, and an enumeration of everything present in the session context beyond the prompt + packet (VOID-5 — the enumeration is the evidence, "nothing" is an enumeration). Seat identities append here at step 4.

## AMENDMENT-1 — seat-delivery deviation (2026-07-19, pre-seeding; symmetric)

1. **Channel constraint discovered:** the kimi.com web UI refuses archive uploads (accepts PDF/DOC/XLSX/PPT/images/CSV/plain text). The zip boundary cannot survive that channel. **First Seat-A seeding attempt aborted** before acknowledgment; its composed opening text (a boot-context declaration request) was NOT the frozen prompt — adopted instead, symmetrically, into v2 below.
2. **Amended delivery form (applies to BOTH seats regardless of channel capability, for arm symmetry):** the 11 packet files travel individually, bytes unmodified, accompanied ONLY by `SEED-PROMPT-V2.txt`, which embeds the per-file SHA-256 manifest and the canonical archive hash. If a channel refuses the `.lisp` extension, the staged `.lisp.txt` copies are used (byte-identical, name-only mapping, declared inside the prompt itself).
3. **Frozen v2 prompt:** `11b37b69537dd363ed232efdcb2183c8b7c5bb9362fcf2371aeda4249a7b4ca9  SEED-PROMPT-V2.txt` — supersedes SEED-PROMPT.txt (3bc05873…) for both seats; adds the delivery-deviation manifest and a mandatory pre-work declaration (files received / boot context & memory beyond packet / tools & model identity / recognition probe), with a hold until acknowledgment.
4. **Per-file manifest** (= AMENDMENT-1 custody evidence; identical in both staged seat sets, verified): brief `e9c26bdd…`, API `46fe32bb…`, SCENARIOS `a65a5eae…`, afel `99098fc7…`, harness `9d3f3a61…`, provider.lisp `e2bac1df…`, provider.py `4b2438bc…`, selftest `52b4dcd1…`, substrate.lisp `7594a862…`, substrate.py `3bcf3612…`, test-cl `45e1e390…`.
5. **Count correction:** the packet is 11 files (+1 directory entry = the zip's "12"). Prior "12-file packet" phrasing corrected here, not rewritten elsewhere.
6. **Clean-context caution recorded:** the observed Kimi account carries prior conversations (including a repository review). VOID-5's enumeration for Seat A MUST state the account-level memory status (memory features disabled, or a clean account, or the API route); "fresh chat on an exposed account with memory active" does not satisfy CLEAN-CONTEXT.

## AMENDMENT-2 — Seat B channel batching + Seat A memory disposition (2026-07-19)

1. **Seat B = Qwen** (owner's choice; satisfies `CLEAN-CONTEXT / DIFFERENT-MODEL-LINEAGE` — different provider, zero KW-0-loop presence). Its channel accepts ≤5 files per message → the 11 files travel in **three frozen batches** (5 / 5 / 1+prompt), bytes unmodified, staged at `~/Downloads/ss0-seats/seat-b-batches/`. Interstitial text is limited to two frozen preambles: `PREAMBLE-1.txt 037f3731…`, `PREAMBLE-2.txt e35d2b52…` ("reply only: received part N"); the full frozen `SEED-PROMPT-V2.txt` (`11b37b69…`) rides with batch 3. Custody rests on the per-file manifest inside the prompt, unchanged.
2. **Mechanical-symmetry note:** perfect delivery-mechanics symmetry across different vendors' UIs is impossible by construction (that asymmetry is inherent to a different-lineage seat); content symmetry is exact — same 11 files, same manifest, same prompt bytes. Docketed here, not hidden.
3. **Seat A memory disposition (owner-performed, screenshot on record):** kimi.com "Instruções de memória" toggled **OFF** (29 saved instructions rendered inactive) before seeding; seat A enumeration will read: fresh chat; account previously used for other conversations incl. a repository review; memory-instructions feature disabled; recognition probe in the prompt as backstop. Final VOID-5 entry appends when the seat's declaration arrives.
