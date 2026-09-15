# PREREG — P8 forged-record arm, probe-harness repair delta /0

*MNEME DEBT DISPOSITION /0, Part B (Astra → Fable, 2026-09-15, attachment sha256 `b950aafe36727defa8426bae925fc1f4c97be086d3c005aa13db95dc5263f235`). Written by Claude Fable 5.1, chair **A Comment Is A Claim** [653264], laptop, BEFORE any harness code was written; the sha256 of this file is printed in the chair's transcript at the moment of freezing and recorded in `RETURN.md`. The timestamp is written by `date` in the same command that hashes the file (see `PREREG-P8-DELTA-0.sha256`).*

## 0. Pinned subject

- Governing ML/0 subject: lab `main` HEAD `8f41eee133555ee47e2d4d3c1eb7a6bb9427b212`; `experiments/latent-lisp` tree `e148d8a5344cd0bef88d0a8d5eba77684577d9f3` (= the public tip `5e63bffd`'s subject, per MEMORY and the 09-09 PUBLISHED ruling); lane tree `experiments/latent-lisp/mneme/memory-layer-0` = `9458616a438fbce1de0433d439b458f83d76fbac`, last touched by lab commit `fa0a45d4a` (2026-08-21). The WARRANT SESSION branch is NOT the baseline and is not imported.
- The original block, primary record: MiniMax-M3 supplement parcel `/0.1` sha256 `34d7032ed1015437687e6cc378a725bc81d82441d7560151b8f405d210556ac7`, member `supplement/auditor/OUT-C/probes/probe-p8-supplement.lisp` and `…/runs/probe-p8-supplement.{out,err}`; Sol II TERMINAL §III (`corpus/voices/received/2026-09-01-201730-…-TERMINAL.md`): *"failed during load because it called non-exported `LISP-PLUS-CD0:RECORD-FIELD` with external-package syntax. It never reached the ML/0 decoder or `ML0-RB-5`."* ADDENDUM 24 §5: **P8 forged-record discriminator BLOCKED — PROBE HARNESS.**

## 1. The intended forged-record property (unchanged from the auditor's intent)

A durable ML/0 account frame that is **coherent** — canonical CD/0 bytes, this lane's `w-<hex>` event-id shape, body digest re-minted so the identity and the content agree (ML0-RB-11 passes), every source naming the account's own act (ML0-RB-10 passes), rendering version current (RB-7), vocabularies inside the declared sets (RB-8), source count agreeing (RB-9) — and that **differs from a lawfully written frame only in the effect observation's `provenance` field**, which reads `"observed"` instead of `"caller-asserted"`.

## 2. The clause that determines its expected treatment

- SPEC `MEMORY-LAYER-0-SPEC.md` (R4 paragraph, ~l.181–184): *"Every effect observation now carries `provenance = :caller-asserted`, in the type and in the durable bytes; the mark is not a constructor parameter … and bytes claiming any other provenance are **refused** at `ML0-RB-5` rather than best-effort decoded."*
- GUIDE `MEMORY-LAYER-0-GUIDE.md:261`: *read back an effect observation whose provenance is not `caller-asserted` (R4) → `ml0-account-readback-refused` → `ML0-RB-5`.*
- Code site: `ml0.lisp` `ml0-effect-observation-from-record` (l.1064–1091) — ML0-RB-5 is raised there and nowhere else (three reasons: missing field l.1067; provenance ≠ "caller-asserted" l.1075 with detail *"the effect observation's provenance reads ~s"*; determinacy outside the three l.1087). **The expectation is the l.1075 refusal, identified by requirement-id `ML0-RB-5` AND the detail substring `provenance reads`.** A missing-field RB-5 or a determinacy RB-5 is NOT the intended refusal.
- No clause anywhere says a forged frame is refused *at the journal* or *at RB-11*; Journal /0 knows nothing of ML/0 semantics. The expectation is therefore precisely: refused at RB-5 on the read path, after the earlier RB checks pass. **"Forged" confers no policy of its own** — the only policy is the provenance vocabulary of RB-5.

## 3. Entry points tested, each labelled

| Tag | Entry point | Supported-path status | Role |
|---|---|---|---|
| R | `ml0-retrieve store :account-hex hex` | **supported read path** (GUIDE §retrieve; the only validated route) | the boundary the contract names |
| D | `ml0-effect-observation-from-record record` | exported accessor documented in the GUIDE (§constructors and their accessors); bypasses the store — a **direct interface experiment** | the auditor's original entry point |
| W | `%ml0-dry-decode envelope hex` (lane-internal, the R5 pre-append gate of the supported writer) | **auditor machinery** (internal; reached from inside the package) | shows what the supported WRITE path would do with the same bytes |
| J | `lisp-plus-journal0:append-event store envelope` | Journal /0 supported API — but its use here to inject an ML/0-shaped frame that `ml0-write` would never produce is **auditor machinery** | how the forged frame enters the store |

Fixture construction (all auditor machinery, executed from inside `lisp-plus-memory-layer0` so the imported `record-field`, `rec`, `entry`, `s-datum`, `ml0-mint-account-identity`, `ml0-account-envelope` are reachable): write ONE lawful account through `ml0-write` (exactly the auditor's Phase-B/-C recipe: `ml0-ground`, `ml0-settled-row`, `run-act1`, the three observation doors, one self-report source, `ml0-effect-observation-of`); retrieve it (R); take `ml0-account-body-record`; produce a body that is the same record with the `("account" "effect-observation")` entry replaced by an effect record identical to the original's except `("effect" "provenance")`. The rebuild is done by re-encoding entries, never by `rplaca` on a held object.

## 4. How reachability is observed

Reachability of the boundary is observed by the **requirement-id and detail of the typed condition**, read through `ml0-condition-requirement-id` / `ml0-condition-detail`, printed by the case script as one machine-readable line `RESULT-CLASS: <class>` (below), plus `sb-ext:exit` code, plus the store's frame count and account-hex list before and after (`ml0-list-account-ids`) and the sha256 of `EVENTS.pj0` before/after — the state effect. Because `ML0-RB-5` is raised only inside `ml0-effect-observation-from-record`, which the decoder calls only after RB-2/7/8/9/10/11 have passed (l.2011–2162), an `ML0-RB-5 … provenance reads` refusal on path R is itself the observation that the decoder reached the effect-observation step.

## 5. Result classes (closed set; every case prints exactly one)

- `DECODED provenance=<value>` — no refusal; the value the reader returned.
- `REFUSED <requirement-id> <tag>` — an `ml0-condition` with that id; `<tag>` ∈ {`provenance-reads`, `missing-field`, `determinacy`, `other`} from the detail.
- `JOURNAL-REFUSED <condition-type> <requirement-id>` — a `pj0-*` condition (Journal /0 refused before any ML/0 decoder ran).
- `LISP-ERROR <condition-type>` — any other condition caught at the case boundary.
- `LOAD-ERROR` — assigned by the RUNNER when the process ended without printing a `RESULT-CLASS:` line (reader error, crash, kill). Never assigned by the probe.

The case script exits 0 iff it printed its `RESULT-CLASS:` line; the RUNNER compares the class to `EXPECTATIONS-P8.txt` and decides PASS / FAIL / BLOCKED per case. "The probe ran" and "the expectation held" are two different lines.

## 6. Cases and pre-committed expectations

| Case | Fixture | Entry | Expected class | What it establishes |
|---|---|---|---|---|
| V-R | the lawful account, unmodified | R | `DECODED provenance=CALLER-ASSERTED` | the harness reaches the operation on the contract's valid case |
| V-D | the lawful account's effect record, unmodified | D | `DECODED provenance=CALLER-ASSERTED` | the direct entry decodes the valid record |
| V-J | rebuilt body with provenance `"caller-asserted"` (byte-identical to the lawful body — **structural admissibility of the rebuild**) | J then R | `append-event` returns disposition `:already-committed-identical` (PJ-APP-2), same account-hex as V-R; R → `DECODED provenance=CALLER-ASSERTED`; frame count unchanged | the rebuild machinery produces the lane's own bytes exactly; identity re-mints to the lane's own hex |
| F-D | forged effect record (provenance `"observed"`) | D | `REFUSED ML0-RB-5 provenance-reads` | the auditor's original arm, now reached |
| F-R | coherent forged frame (identity re-minted, `w-<hex'>`), injected via J | J then R | J: appended (a new frame, count +1); R on hex' → `REFUSED ML0-RB-5 provenance-reads` | the contract's read-path boundary is reached and refuses for the intended reason |
| F-W | the same forged envelope handed to the writer's pre-append gate | W | `REFUSED ML0-RB-5 provenance-reads` (possibly wrapped/renamed by the gate — the id actually raised is RECORDED; the pass criterion is: a refusal, no append, frame count unchanged) | the supported write path cannot produce these bytes |
| E-J | forged body under the ORIGINAL account-hex/event-id (identity NOT re-minted) | J | `JOURNAL-REFUSED pj0-event-identity-collision PJ-APP-3` (or the journal's actual refusal — recorded); frame count unchanged | an earlier-stage (transport) failure, classified separately, never counted as the intended refusal |
| E-R | forged body under a FRESH but WRONG hex (64 hex chars that are not the body's digest), injected via J | J then R | J: appended (count +1); R → `REFUSED ML0-RB-11 other` | an ML/0 refusal that is NOT RB-5 though the provenance IS forged — the earlier-stage control at the lane's own boundary |
| E-L | the auditor's ORIGINAL probe, venue path substituted only | its own load | `LOAD-ERROR` (reader: `Symbol "RECORD-FIELD" not found in the LISP-PLUS-CD0 package`) | the original block, retained and classified: BLOCKED, not a catch |

Every case is a **fresh `sbcl --script` process** on a **fresh ground** (`ml0-fresh-run-root` under /tmp, outside the subject tree). Nothing is reused between cases except the pinned subject bytes.

## 7. Controls of the auditor's verdict (the checker must be able to fail)

- C-1: run the runner with `P8_EXPECT_OVERRIDE="F-R=REFUSED ML0-RB-4 other"` → the runner must print `FAIL F-R: got 'REFUSED ML0-RB-5 provenance-reads' expected 'REFUSED ML0-RB-4 other'` and exit nonzero. A disposable wrong target makes the auditor fail for that specific mismatch.
- C-2: run the runner with `P8_EXPECT_OVERRIDE="E-L=REFUSED ML0-RB-5 provenance-reads"` → the runner must print `BLOCKED E-L: LOAD-ERROR (no RESULT-CLASS line)` and exit nonzero, and the word `PASS` must not appear on E-L's line. An unrelated crash does not count as a successful catch.
- C-3: run the runner with `P8_EXPECT_OVERRIDE="E-R=REFUSED ML0-RB-5 provenance-reads"` → `FAIL E-R: got 'REFUSED ML0-RB-11 other' …`. A refusal of the wrong kind is not the intended refusal.
- The three control runs are kept under their own stamps beside the real run; the real run has no override.

## 8. VOID conditions (the run is VOID, not FAIL, if any holds)

- The venue's lane bytes differ from the pinned lane tree (checked by sha256 over every file before the run).
- Two `sbcl` processes of this harness run concurrently (fresh-process isolation is the design; one at a time).
- Any case writes into the checkout (the run root must be under /tmp).
- The runner's expectation table was edited after this prereg's hash was recorded, other than through the documented `P8_EXPECT_OVERRIDE` control which is printed in the transcript.

## 9. What no outcome here may be turned into

- A PASS on F-R establishes the read-path refusal for THIS forgery (provenance only), on THIS pinned subject, in THIS venue. It does not establish that every forged frame is refused, nor anything about supported-path soundness beyond RB-5's own sentence.
- A discrepancy (e.g. F-R DECODED, or refused at an unexpected earlier RB) is preserved as a minimal reproducer with the violated clause named; the repair path STOPS at diagnosis (attachment §3, last paragraph).
- Nothing here closes the P8 register entry; the chair reports a proposed disposition for adjudication.
