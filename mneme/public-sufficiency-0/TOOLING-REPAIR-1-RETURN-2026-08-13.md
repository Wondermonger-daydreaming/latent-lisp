# CHANNEL TOOLING REPAIR /1 — RETURN (2026-08-13)

**Terminal status: REPAIR CANDIDATE RETURNED — NOT YET OWNER-ACCEPTED.
TD-6…TD-9 remain OPEN unless and until their demonstrated repairs receive
the appropriate owner acceptance. No adoption, merge, transport,
publication authorization, or publication was performed.**

## The three hands (kept separate, each on the record)

| Hand | Actor | Record |
|---|---|---|
| Build | FERRARIUS (Opus builder, 2 rounds) | `_staging/tr1-ferrarius-builder-report.md` (1981 lines, verbatim transcripts) |
| Adversarial verify | QUAESTOR (Opus verifier, 2 rounds, cold re-runs) | `_staging/tr1-quaestor-verification.md` (609 lines) |
| Chair | Fable 5 — commission filings, TD-6 remeasure, residual close-out | this dossier + the integration commit diff |

## Final teeth state

- **131 assertions / 0 failures**, full suite, disposable `/tmp` harness
  against local bare remotes — run fresh by the chair after the final
  edit; QUAESTOR independently re-ran the 126-assertion predecessor cold
  (126/0) and FERRARIUS ran it twice (126/0); the 103-assertion round-1
  suite was QUAESTOR-re-run cold at 103/0.
- Every tooth proves BOTH directions (RED on planted failure, GREEN on
  correct path); absence-probes (recursion canary) are themselves
  teeth-checked before their silence counts.

## TD-by-TD

| Defect | State at return | Demonstrated by |
|---|---|---|
| **TD-6** | **NOT CURED — owner fork returned** (`TOOLING-REPAIR-1-TD6-OWNER-FORK-2026-08-13.md`): live fact REMEASURED (main unprotected/404, zero rulesets, zero deploy keys, host = owner account — no distinct sync principal exists); enforcement model proven on disposable bare remote only. Nothing live changed. | TOOTH-TD-6 (+ the fork doc's read-only census) |
| **TD-7** | **REPAIR CANDIDATE**: supervisor harvests terminal exit; hooks still exit 0 (source-commit success never falsified); five distinct verdicts/exits via `transport-status.sh` (OK/WITHHELD 0 · FAILED 1 · PENDING 2 · ABSENT 3 · NOT EVIDENCED 4); exact failure code preserved (proven with a planted 42). | TOOTH-TD-7 |
| **TD-8** | **REPAIR CANDIDATE**: both installed hooks = byte-verified thin delegators (class structurally dead); `install-hook.sh --verify` byte-exact RED/GREEN; stale 910-byte hook preserved (`.git/hooks/post-merge.pre-td8-backup-20260813T181941Z`, sha256 `8520185a…1747` = session-start measurement); live refresh performed only AFTER teeth passed; installer's own verifier was caught comparing strings while claiming bytes (builder's self-catch) and rebuilt on `cmp`. | TOOTH-TD-8 |
| **TD-9** | **REPAIR CANDIDATE**: append-only record on `refs/latent-lisp/transport-record` via plumbing (no checkout/index/hooks — recursion disproven by teeth-checked canary); schema carries source identity, attempted identity, event kind, exit code, reason, UTC time; credential shapes redacted, control bytes stripped (class-level, always-on in pure bash), UTF-8-boundary truncation; portability proven across fresh clone + documented refspec; `verify` RED on absence/corruption/wrong-shape/non-FF-where-journaled. **NOT the R-2b receipt; cannot create PUBLISHED standing** (verbatim in tool header). | TOOTH-TD-9 |

## The adversarial round (what the second hand caught)

1. **Poisonable record (genuine, cured at class level):** server-controlled
   `remote:` bytes reaching event reasons could write invalid JSON —
   permanently RED, host-dependently detected. Cure: C0+DEL strip before
   redaction (the stronger ordering), always-on bash structural check,
   UTF-8-boundary truncation (builder-extended beyond the finding),
   `--exit` integer guard with disclosed sentinel. QUAESTOR round-2
   re-probed its own attack four ways plus one new angle: could not
   poison the record.
2. **Residual LOW (closed by chair, QUAESTOR's exact prescription):**
   leading-zero `--exit` values (`08` killed the append — event LOST;
   `010` silently stored as 8). Unreachable from production
   (`$?`/`PIPESTATUS` never carry leading zeros). Regex →
   `^-?(0|[1-9][0-9]*)$`; two new teeth prove `08`→sentinel-recorded and
   `010`→NOT octal-mangled; suite green at 131/0. Diff exhibited in the
   integration commit.

## Honest voids (carried at full strength from the builder's §7 + rounds)

The record ref has never crossed a real network (portability proven
locally only; pushing the ref is an unauthorized owner act) · truncation
of the ref is detectable only where its journal exists (a cryptographic
exterior anchor would be needed; out of scope) · **no real transport was
performed** — the new success path is proven only against local bare
repos; the first real run is the first real evidence · the post-merge
path was never tested through a real merge (forbidden; merge gate closed)
· historical `.sync.log` refusals NOT retro-imported (no fabricated
events) · `--dry-run` records nothing by design · concurrency guarded
(CAS update-ref) but not race-tested · the reduced floor gate not run ·
sentinel `-1` distinguishable from a genuine exit -1 only by reason text
· TOOTH-TD-6 GREEN is evidence about a pre-receive hook in `/tmp`,
never about github.com.

## Regression

TD-1..TD-5 closure preserved: TR/0 campaign gate 9 gates/0 failures
(before AND after, byte-matching); `verify-sync.sh` behavior class
unchanged (mirror stale at `3101fcee…`, exit 1, expected-divergence
report); all pre-existing guards (SYNC-PAUSED · main-only · push-target
assertion · committed-tree `git archive` model · mneme verify hook)
verified intact by both hands.

## Session facts the record must carry

- The lab's session-checkpoint Stop hook committed in-flight tracked
  edits locally during the arc (`4736523b`, `0e18b1cf`, ledger + five
  tooling files) — expected structural behavior (§I-j class), local only,
  nothing pushed, branch guard held on every firing (`.sync.log`).
- `SYNC-PAUSED` sentinel: raised at surgery start; removed in the commit
  after integration. First live run of the changed machinery is the
  integration commit's own post-commit firing (recorded WITHHELD/pause —
  see `CHANNEL-POLICY-1-MACHINERY-ERRATUM-1-2026-08-13.md`, filed in the
  same commit, satisfying the §4-pattern ordering).
- Accepted candidate blob `180734f6…c7054` untouched (verify:
  `git ls-tree HEAD` on the candidate path).

## WE-ARE-HERE (terminal)

**Channel Policy /1 = accepted candidate (blob `180734f6`), NOT adopted.
TR/1 repair candidate RETURNED for TD-7/TD-8/TD-9; TD-6 owner fork
RETURNED (A / B / DEFER) — all four TDs remain OPEN pending owner
acceptance. Merge gate remains CLOSED until the owner accepts the
TD-7+TD-8 repairs (and their first real-transport evidence exists).
Next, in order: owner acceptance of this repair candidate + TD-6 fork
decision → adoption act (§8.1) → authorization acts → owner-gated
branch→main merge → verified transport + R-2b receipt → PS/0 far-side
readback. Open and untouched: R-3 · R-8 · R-2b.**

*— chair, 2026-08-13.*

---

**DATED CORRECTION (2026-08-13, post-integration):** "Session facts"
above repeated the erratum's wrong prediction (first live event =
WITHHELD/pause). In fact the hook-layer branch guard preempts the
supervisor on non-`main` branches: the integration commit produced a
`.sync.log` skip line and NO event — correct behavior; the record begins
at the first sync.sh-reaching run. See the erratum's dated correction.
