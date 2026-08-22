# CHANNEL POLICY /1 — MACHINERY ERRATUM 1 (2026-08-13)

**Dated divergence note filed under the accepted candidate's §4
review-trigger pattern, as the issued Tooling Repair /1 commission (step 7)
requires: transport-machinery semantics change with the TR/1 integration
commit, and this filing precedes the changed machinery's first live run.
Timing fact, verified: at filing, `refs/latent-lisp/transport-record` does
not exist in the lab repository and no pending-attempt marker exists — the
changed recording semantics have never executed in the live channel (the
builder's live-path exercise terminated at the hook-layer branch guard,
before any new code path). This erratum updates DESCRIPTIVE MACHINERY
FACTS ONLY. It does not amend the policy text (blob `180734f6…c7054`,
untouched — verifiable by `git ls-tree`), the §0 domain, §4 authority, the
standing model, or any residual fork. The candidate remains ACCEPTED, NOT
ADOPTED, NOT OPERATIVE.**

## Machinery facts that change at the TR/1 integration commit

1. **Hook layer (TD-7):** `post-commit.sh` / `post-merge.sh` launch
   `transport-supervisor.sh` (new) instead of raw `sync.sh`; the
   supervisor harvests the transport's terminal exit code. Hooks still
   return 0 unconditionally — a successful source commit is never
   reported failed because transport failed later.
2. **Terminal-result record (TD-7 + TD-9):** every terminal transport
   outcome (TRANSPORT-OK · TRANSPORT-FAILED with exact exit code ·
   WITHHELD with the refusing gate named) is appended as one commit on
   the dedicated ref `refs/latent-lisp/transport-record` via git plumbing
   (no checkout, no index, no hooks fired — recursion disproven by
   teeth-checked canary). Query: `transport-status.sh` — five verdicts,
   five exit codes (OK/WITHHELD 0 · FAILED 1 · PENDING 2 · ABSENT 3 ·
   NOT EVIDENCED 4). The host-local `.sync.log` remains diagnostic; the
   ref is the record of record. **The record is diagnostic/provenance
   machinery only — it is NOT the R-2b publication receipt and cannot
   create PUBLISHED standing** (sentence carried verbatim in the tool
   header). Historical `.sync.log` refusals are NOT retro-imported (no
   fabricated events); the record begins at first live run.
3. **Installed hooks (TD-8):** both `.git/hooks/{post-commit,post-merge}`
   are byte-verified thin delegators to the canonical tracked scripts;
   `install-hook.sh --verify` makes drift a byte-exact RED/GREEN
   question. The stale pre-2026-08-02 hook is preserved as evidence at
   `.git/hooks/post-merge.pre-td8-backup-20260813T181941Z`
   (sha256 `8520185a…1747`).
4. **Vocabulary (§7-consistent):** `sync.sh` success line now reads
   `TRANSPORT-OK — pushed to <remote>` with an explicit disclaimer of
   PUBLISHED standing; the word "published" no longer appears as a
   transport-success claim anywhere in the machinery's output.
5. **Harness override (testability):** `sync.sh` honors a remote override
   ONLY under a double gate (harness env sentinel AND local-path-only
   target); the default remote remains the exact https mirror URL and the
   push-target assertion is intact and additionally *records* its
   refusal.
6. **Unchanged guards, explicitly:** SYNC-PAUSED sentinel · main-only
   guard · push-target assertion · `git archive` committed-tree
   publication model · main-ancestry conjunction · mneme verify hook.
   TD-1..TD-5 closure preserved (regression gates re-run, outputs in the
   builder report).

## What this erratum does NOT do

No adoption, no publication authorization, no transport, no PUBLISHED
standing, no R-2b/R-3/R-8 disposition, no change to TD-6 (owner fork
returned separately, knife sheathed). TD-6..TD-9 remain OPEN pending
owner acceptance of the repair candidate.

*— filed 2026-08-13 by the chair; first live run of the changed machinery
is the integration commit's own post-commit firing (which, with
SYNC-PAUSED still up at that moment, should record its first event as
WITHHELD/pause — an honest first entry).*

---

**DATED CORRECTION (2026-08-13, same sitting, after the integration
commit's hook fired):** the closing note's prediction — first event =
"WITHHELD/pause" — was WRONG. The hook-layer branch guard (post-commit.sh,
a preserved TD-1..5-era protection) exits before the supervisor launches
on any non-`main` branch, so on `many-acts-0-candidate` no transport is
attempted and no event is due; `.sync.log` carries the diagnostic skip
line (18:53:07Z) and `transport-status.sh` correctly reports ABSENT with
honest semantics. The record ref therefore begins at the first
sync.sh-reaching run (a `main` commit, a direct invocation, or a harness
run) — not at this commit. Machinery correct; the prediction was the
defect. Hook-layer branch skips remain diagnostic-log-only by design
(recording an event per branch commit would flood the record with
non-attempts); if the owner wants branch-skips evidenced, that is a
design change to commission, not a bug.

---

**SECOND DATED CORRECTION (2026-08-13, per SOL-TR1-01; the original text
above is not rewritten):** fact 2's assertion that "every terminal
transport outcome … is appended" is **not true under append failure** —
Sol's cold plant forced an `update-ref` failure and the supervisor
reported "recorded" anyway, exited 0, and left the outcome evidenced
nowhere (status NOT EVIDENCED, not RED). The machinery is being repaired
to the class rule: **transport outcome ≠ persistence outcome** — a
persistence failure yields a distinct EVIDENCE-FAILED state (own RED
exit, terminal host-local marker surviving the supervisor, no "recorded"
sentence, qualified non-green from direct `sync.sh`), and CAS/concurrent
append failure is the same class. The corrected description of fact 2:
every terminal transport outcome is *attempted* to be appended; a failed
append is itself surfaced as a distinct evidenced failure, never
silently absorbed. TD-9's standing under SOL-TR1-02:
**IMPLEMENTATION-CANDIDATE / OFF-HOST DURABILITY UNREACHED** (the record
ref has never reached a durable remote; owner fork returned separately).
