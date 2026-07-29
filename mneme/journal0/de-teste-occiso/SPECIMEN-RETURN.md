# de-teste-occiso — SPECIMEN RETURN

*The inhabited restart specimen for the independently-seeded Common Lisp
Process Journal /0 store (`mneme/journal0/`). Built, executed, and captured by
**SUPERSTES** (Claude Fable 5 subagent), 2026-07-29. Every number below is
derived live by `run-specimen.lisp`; the transcripts are the record.*

> **A process may die while its durable history survives; reconstruction may
> derive from that history, but it may not pretend to remember what was never
> committed.**

**Executed result: 63 checks, 0 failures, exit 0, twice, byte-identical.**

---

## 1. What it proved

**1.1 A charged writer was killed by SIGKILL at a governed progress point, and
the journal survived it exactly.** Two live kills, each in its own OS process,
each byte-deterministic:

| cell | kill point | surviving bytes | recovery behaviour |
|---|---|---|---|
| **CW-3** (`:synced`, phase 2) | after the §10.1 barrier and the §9.2 step-9 reopen, before the receipt reached the caller | `:valid`, **4 frames**, 1507 octets, zero excluded, no `LOCK` | retry **reconciles**: `:already-committed-identical` at ordinal 4, **zero new bytes**, receipt origin `:reconstructed` |
| **CW-0** (`:synced`, control 8) | before the first frame byte | `:valid`, **3 frames**, sha byte-identical to its own pre-kill bytes, no `LOCK`, charged event **absent** | retry **commits**: `:newly-committed` at ordinal 4, bytes grow |

The second row is the first row's teeth. Same charge, same child program, same
supervisor — only the kill point moves, and both the byte state and the lawful
recovery change with it. The cell is a **finding**, not a constant of the
harness.

**1.2 The byte proof of CW-3** (capture checks 008–012), each ruling something
out rather than asserting a conclusion:

- **(a)** the surviving bytes validate `:valid` with 4 frames — rules out CW-0
  (3 frames) and CW-1 (torn tail);
- **(b)** the valid prefix consumes all 1507 octets, zero excluded — rules out
  CW-2a (bytes absent) and CW-2b (bytes torn);
- **(c)** frame 4's payload is byte-identical to the canonical encoding of the
  declared charge, at ordinal 4;
- **(d)** no `LOCK` survives — the critical section had completed and its
  `unwind-protect` had released the lock, so the death was *after* §9.2, not
  inside it (PJ-LOCK-2: the lock coordinates, it never testifies);
- **(e)** the caller holds **no receipt** for a frame that **is** durably
  committed — the CW-3 condition itself, the append-side analogue of an
  uncertain external write (PJ-CW-3).

**1.3 The restart derives, and refuses to remember.** A genuinely new
`sbcl --script` process, given only the store directory and declared
configuration, validated the survivor, reported the terminal classification
the bytes actually carry (PJ-CW-2), reconstructed a view whose receipt carries
origin `origin:reconstructed` and in whose bytes the string `observed` does not
occur anywhere (PJ-WIT-1/2/4, PJ-RCN-1), refused reconstruction beyond the
validated prefix (K0E-11), refused a blind unsafe retry with a conflicting
payload (PJ-APP-3, zero bytes written), and reconciled the CW-3 event by
identity (PJ-CRASH-1, PJ-APP-2/4). Asked about an identity the journal never
carried, it answered **not-committed, intention-unknown** — never
*never-proposed*, because the durable bytes cannot say so.

**1.4 A torn tail is visible, uncommitted, and undeleted.** Exhibited on a
**derived** byte state (the crash artifact truncated by 7 octets — *labelled
derived, not a second kill*): `:torn-tail` at 3 frames with the excluded region
reported by offset, octet count and digest; revalidation does not truncate the
source (§14.1); a new append is refused (`pj0-torn-tail`); an identity already
in the prefix still reconciles (PJ-LOCK-1's other branch); salvage copies only
the valid prefix to a **new** identity with the source byte-identical
afterwards (PJ-SAL-1/2) and names its bounded unknown — the excluded tail may
describe an external consequence that did occur (PJ-SAL-3); and the source
remains `:torn-tail` afterwards, because salvage does not heal a tear.

**1.5 Raw crash artifacts are preserved and tracked.** `CRASH-ARTIFACT-EVENTS.pj0`
is the post-kill store bytes verbatim — the recovery's actual input, made
inspectable rather than summarized — with the metadata, the sidecar,
`CRASH-ARTIFACT-SHA256SUMS.txt` and `CRASH-ARTIFACT-MANIFEST.txt`. All are
byte-stable across runs.

**1.6 Eight negative controls, each naming the exact check that reddens.**
(1) one mutated payload byte → `pj0-payload-digest-mismatch`, prefix stops at 3
frames, nothing past the damage admitted; (2) reconstruction past the prefix
over the corrupted store → `unsupported-reconstruction`; (3) a derivation
needing non-journal authority (two non-superseded attempts on one seat) →
`unsupported-reconstruction`, never "pick the newest" (PJ-FOLD-4); (4) a
restart process truncated mid-run → exit 3 **and** no `RESULT:` sentinel,
detected as that pair; (5) an unsafe retry under a held writer lock →
`pj0-lock-failure`, zero bytes, and reconciliation once released; (6) teeth for
the cell proof — the "`:valid` with 4 frames" predicate returns **false** on the
pre-kill bytes; (7) teeth for the undelivered-receipt proof — with a receipt
planted, the predicate returns **false**; (8) the CW-0 live kill described in
1.1.

---

## 2. What it did NOT prove

- **No billing, provider, or adapter semantics.** Nothing here touches
  external effects, provider receipts, payment, or any adapter state machine.
  The uncertain-write structure is exhibited *inside* the journal only.
- **No power-loss claim. PJ-DUR-3 stands.** `:synced` here means `fsync(2)`
  returned and the reopen validated on this host (native Linux ext4, SBCL
  2.4.6). It is a declared host-contract belief, never physical proof through
  any controller, hypervisor, or firmware.
- **CW-2 was never hit live.** The specimen kills at CW-3 and CW-0 only. The
  CW-1 state is *derived by truncation*, not produced by a kill, and is
  labelled so wherever it appears. CW-2a/CW-2b (bytes absent / torn after a
  kill inside the host write path) are **not exhibited at all**.
- **A kill inside the §9.2 critical section is untested.** Consequently the
  §11.3 stale-lock path (a writer dying while holding the lock) is exercised
  only by a **planted** `LOCK` file in control 5, never by a real death.
- **`:best-effort` durability was never killed.** Every cell here is `:synced`.
  The Annex B `best-effort` row is untouched.
- **No multi-writer race.** PJ-LOCK-3 (two concurrent requests for one event
  identity) is not exercised.
- **The CW-3 / CW-2c distinction is not proved by bytes, and cannot be.**
  `cw2-full-unacknowledged` and `cw3-full-synced-receipt-lost` are
  byte-identical by design (§29). What separates them here is the harness's
  **ordering record** — the marker is written only after `append-event`
  returns — plus the store's declared `:synced` mode. That is *scaffolding*
  evidence, not byte evidence, and the capture says so at the point of claim.
- **No outside has audited this.** Same hand, same lane, same weights as the
  store it tests. The specimen is not an independent verification of
  `mneme/journal0/`; it is an exercise of it.

---

## 3. Declared deviations

- **PJ-META-1 (nonce unpredictability).** Both store nonces are fixed
  constants so the capture is byte-deterministic. These stores are test
  fixtures and are never production identities.
- **The barrier marker is harness scaffolding.** It carries a fixed constant
  and zero coordinate information (no ordinal, no digest, no identity), and
  the recovery process never names or reads it. It is nonetheless *not* part
  of a real writer's behaviour, and the CW-3 claim leans on it (see §2).
- **The retry candidate is rebuilt from the declared charge**, the way an
  idempotent client rebuilds a retry from its own knowledge — never inherited
  from the dead process, which left no such record.
- **`inside-store-p` is a construction claim.** The recovery derives every
  path it opens from its `argv` store directory, and the check confirms this
  for the three named store files. It is not a syscall-level audit of what the
  process opened.

---

## 4. §30 randomized SIGKILL harness — exact discharge

`tools/pj0_kill9_harness.py` was **never opened** (see `PROVENANCE.md`); this
harness was written from §30's ten MUST clauses, §1, and Annex B alone.

| §30 MUST | status | note |
|---|---|---|
| 1. accept an explicit PRNG seed | **NOT discharged** | there is no PRNG; the specimen is deterministic by design |
| 2. select byte offsets and crash windows deterministically from the seed | **NOT discharged** | the two windows are hand-chosen, not seed-selected; no byte-offset selection exists |
| 3. run at least `N` trials named in the transcript | **NOT discharged** (degenerate) | exactly two kill trials, both named in the transcript; the randomized-`N` intent is not met |
| 4. start from a frozen valid prefix; launch a child writer in a separate process to append the candidate frame | **DISCHARGED** | a durably committed 3-frame prefix with its sha recorded; child via `sb-ext:run-program`, killed while the parent watches |
| 5. deliver SIGKILL at the selected progress point | **DISCHARGED, for two governed points** | CW-3 and CW-0; `:signaled`/9 asserted for both. Not for randomly selected points |
| 6. retain every resulting store directory | **PARTIAL** | the resulting bytes are retained as tracked `CRASH-ARTIFACT-*` copies (CW-3) and as recorded digests (CW-0); the scratch **directories** are deleted at end of a successful run |
| 7. validate each store with the strict validator | **DISCHARGED** | every post-kill and derived state is run through `validate-journal` / `validate-event-octets` |
| 8. compare the result to the crash-window admissible set | **DISCHARGED, for two Annex B rows** | synced/CW-3 (complete valid frame · event included · caller reconstructs prior coordinate · declared synced) and synced/CW-0 (prior bytes only · no contribution · ordinary retry · event absent), each column checked |
| 9. report environment, filesystem, runtime version, durability declaration | **DISCHARGED** | `RUN-EXITCODES.txt` + the capture's PJ-DUR-3 line |
| 10. make no stronger power-loss claim than the host test permits | **DISCHARGED** | stated in the capture at the point of claim and in §2 above |

- **PJ-KILL-1** (random tests supplement exhaustive truncation, never replace
  it): honoured in the trivial sense — the exhaustive 1,235-member truncation
  family lives in the journal0 gate and nothing here displaces it. But this
  specimen supplies **no random complement**; PJ-KILL-1's actual subject is
  still owed.
- **PJ-KILL-2** (a failure archived with seed, trial number, progress offset,
  store bytes, validator report): **NOT EXERCISED.** No trial failed, and
  there is no seed/trial machinery to archive one with.

**Therefore: §32.3 writer conformance gains real forced-kill evidence at two
cells, and §32.5 FULL Process Journal /0 conformance remains NOT CLAIMED.**
What remains owed for §30 is the randomized, seeded, N-trial harness with
offset selection across the whole frame and a `best-effort` arm — including,
specifically, kills *inside* the §9.2 critical section, which is where CW-1,
CW-2a and CW-2b and the real stale-lock path live.

---

## 5. Standing

**This is a candidate: constructed, tested, and published. It is not audited,
not adopted, not frozen, and it establishes no floor.** No claim here has been
reviewed by any hand outside this lane, and the specimen shares its weights,
its fence, and its author's blind spots with the store it exercises.
Divergences adjudicate to spec text, never to this implementation.

*— SUPERSTES (Claude Fable 5 subagent), 2026-07-29*
