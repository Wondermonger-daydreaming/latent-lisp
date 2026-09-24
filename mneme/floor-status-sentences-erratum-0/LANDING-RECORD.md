# LANDING RECORD — floor status sentences /0

*Template drafted by PLINTH-II, 2026-09-21, with every execution-time field as the literal token
`PENDING-AT-EXECUTION`. **Filled by PLINTH-III on 2026-09-21 20:21:28 -0300**, after the landing, from the
preserved receipt and from the store. No value here is predicted. A value the receipt does not show is
written `NOT OBSERVED in the receipt`, and where Git or the store can establish it another way that is said
as a separate, labelled observation.*

**Three labels are used throughout, and they are not interchangeable:**

| label | means |
|---|---|
| **OBSERVED AT EXECUTION** | the preserved receipt shows it; the receipt line number is cited |
| **OBSERVED AFTERWARDS BY THE RECORD-KEEPER** | read from Git or the store on 2026-09-21 20:21:28 -0300, after the fact; the command is cited |
| **INFERRED** | neither of the above; the reasoning is given in full and the word INFERRED is kept |

The receipt is `evidence/floor-landing-r1.kYOW4s.log.txt`, sha256
`e94108768849fad06171ff1e6871c28d83878b275697a338b9eca8759c9727aa`, 61 lines, byte-identical (`cmp`, exit 0)
to the copy preserved by the chair at `_staging/2026-09-21-floor-landing-executed/`. "receipt l.N" means
line N of that file.

---

## 0. WHAT THIS RECORD IS PERMITTED TO DO

The draft this file grew from said that **deleting the `PROPOSED — NOT ADOPTED` header was the only change
the landing step was allowed to make to a draft.** That was too narrow: it left no stated permission to fill
the very fields the draft created for filling. The ruling office corrected it. Astra's words, verbatim:

> "For the companion receipt, correct two documentary points: inspect rather than presume
> `CHERRY_PICK_HEAD`, and expressly permit filling the designated execution fields from observed output.
> Preserve original evidence unchanged. Prepare the companion after receiving the actual landing transcript;
> do not treat the floor commit alone as completion of the erratum."

and, on the trailer:

> "Retain the explanatory Landing-Note, understood as applying through review acceptance plus Tomás's owner
> execution."

**So, expressly: the fields this record designates as execution fields MAY be filled from observed output** —
that is what they are for — and doing so is not an edit that makes the document a new draft. Two limits that
do not move: (i) the *original evidence* (`S15-ERRATUM-0.md`, `PIN-SITES.md`, `CONSOLIDATION-2026-09-21.md`,
the machine artifacts under `evidence/`) is preserved unchanged, byte-identical to its source; (ii) nothing
is filled that was not observed.

**Where this acceptance is recorded.** It reached this chair as the **owner's relay of 2026-09-21**, quoted
above verbatim. At the time of writing it is **NOT YET DOCKED AS A FILE** under
`corpus/voices/received/originals/` — there is no `.orig` to cite and no sha256 to bind it. That is stated
rather than papered over: the two corrections below rest on a relayed quotation, not on a docked artifact.
The two *docked* Astra documents this landing does cite are named in §1.

## 0b. THE CHERRY_PICK_HEAD CORRECTION

**What was presumed, and where.** Three sentences in the prepared material assert the behaviour of Git under
`CHERRY_PICK_HEAD` as a known fact rather than as something inspected:

1. `land-floor-status-sentences-0-r1.sh` l.253-255 (a comment above the COMMIT block): *"No pathspec on the
   commit line. The house rite puts pathspecs there, but git REFUSES a partial commit while
   `CHERRY_PICK_HEAD` exists; the index check above is what stands in its place…"*
2. `land-floor-status-sentences-0-r1.sh` l.296 (inside the commit-refusal branch): *"3. git status
   (`CHERRY_PICK_HEAD` is still present; the sequencer state is left for a person to resolve deliberately)"*
3. `CONSOLIDATION-2026-09-21.md` l.92: *"**No pathspec on the commit line**, against the house rite —
   deliberately. Git refuses a partial commit while `CHERRY_PICK_HEAD` exists."*

Neither the script nor the consolidation is edited here. The script is the executed instrument and the
consolidation is evidence of what was reviewed; both are carried byte-identical. **The correction is made in
the companion's own text, which is this file.**

**What this record says instead.** The state was **not inspected** at execution, and the claim about Git's
refusal of a partial commit was **not tested** by anything in this dossier. Precisely:

| question | answer |
|---|---|
| Does the receipt show `CHERRY_PICK_HEAD` being inspected at any point? | **NO — NOT OBSERVED in the receipt.** The string does not occur in the receipt at all. |
| Does r1 test for `CHERRY_PICK_HEAD` anywhere? | **Yes, but only BEFORE the cherry-pick**, and as a refusal condition, not as an inspection of the mid-landing state: preflight 2b (r1 l.129-131) STOPs if `CHERRY_PICK_HEAD`, `MERGE_HEAD`, `REVERT_HEAD` or `BISECT_LOG` is already present. It ran and did not stop (receipt reaches "PREFLIGHT OK", l.17) — **so the observed fact is that no sequencer state existed BEFORE the landing began.** r1 makes no check of the state AFTER `cherry-pick --no-commit`. |
| Was l.296's assertion exercised? | **No.** It sits in the `COMMIT_RC -ne 0` branch (r1 l.279-304). The commit succeeded, so that branch did not run; the receipt goes straight from the message to `[main 931be1d1a]` (l.37→38). |
| Does the measurement transcript test it? | **No.** `evidence/MEASUREMENT-cherry-pick-and-pre-commit.txt` tests whether the pre-commit fence runs under `cherry-pick -x` (run A) versus `--no-commit` + a normal commit (run B). Neither run attempts a **partial** (pathspec-limited) commit, so neither bears on the refusal claim. |
| Can the state be inspected now? | **Only uninformatively.** OBSERVED AFTERWARDS BY THE RECORD-KEEPER (2026-09-21 20:21:28 -0300): `ls .git/CHERRY_PICK_HEAD` → *No such file or directory*; `ls .git/sequencer` → *No such file or directory*. That is the expected state after any successful commit and establishes **nothing** about the window between `cherry-pick --no-commit` and `git commit`, which is the window the presumed sentences describe. |

**Therefore:** the "no pathspec on the commit line" decision stands on the **index verification that was
actually performed and is actually in the receipt** (l.20-26: exactly one staged path, that path, the
reviewed blob `8cbc50c7…`, the reviewed bytes checked with `sha256sum -c`, and a tracked working tree showing
that one modification) — **not** on the untested claim about Git's behaviour. The claim may well be true; this
record does not assert it, because nobody here checked it.

---

## 1. WHAT WAS LANDED

| field | value |
|---|---|
| path | `experiments/latent-lisp/mneme/verify-release.sh` |
| reviewed candidate | `2e0b8d1df67f0443306c41bd62b36c717c9ae53e` (branch `candidate/floor-status-sentences-0`, preserved, unmerged, not deleted) |
| prior blob | `fb99a6b64c77640b1dd81a8bf39f5673c22856a4` |
| landed blob | `8cbc50c772b5225d02caac6df38883bf7dcb437e` |
| landed file sha256 | `5df120b1723655bcf333dc181d43fa31289c53b378a6aba559c35251588a4b69` |
| review-acceptance | ruling office (Astra, GPT-6), 2026-09-21, docked `corpus/voices/received/originals/2026-09-21-183307-astra-side-reply-02-candidate-review-floor-ACCEPTED-demo-HOLD-VERBATIM.md.orig`, sha256 `943767ba917c4347ec54123dd509b0676bc40bd7b8f1062734c70e8cc37f4eeb`; acceptance RETAINED by the 19:33 review of return 03 (`…193306-astra-review-of-return-03-…VERBATIM.md.orig`, sha256 `cdaf98a251bf513221712c958dd18fa210d3c07e19342991246662caacc2c8e3`) |

*Row carried unchanged from the draft. The docked reply and its sha256 were re-read by the script itself at
execution and printed: receipt l.15-16, matching the value above.*

## 2. THE LANDING, AS EXECUTED

| field | value | source |
|---|---|---|
| script run | `_staging/2026-09-21-review-03-repairs/FLOOR/land-floor-status-sentences-0-r1.sh` | commission; the receipt does not name its own script |
| script sha256 at run time | **NOT OBSERVED in the receipt** — r1 does not print its own digest. *Separate observation, OBSERVED AFTERWARDS BY THE RECORD-KEEPER (2026-09-21 20:21:28 -0300):* `sha256sum` of that file today = `88bed3301d63a7a06a01084e08cc2ce108edb9ffa57a79bbd8c80e2fb5ab3dcb`, which equals the value the commission names as expected. Nothing witnesses that the file was byte-identical *at the moment it ran*; the receipt's content is consistent with this script throughout (every printed line matches an `echo` in it). | receipt: absent; git/filesystem: `sha256sum` |
| run by | **NOT OBSERVED in the receipt** — it records no identity for the invoking hand. *Separate observation:* the commission relays that **the owner (Tomás) executed it**; that is testimony, not a store fact. *Separate observation, OBSERVED AFTERWARDS (2026-09-21 20:21:28 -0300):* the commit's recorded git identity is `Claude <claude@lab.local>` for both author and committer — that is the repository's configured identity, and it does **not** witness whose hand launched the script. | receipt: absent; relay; `git log -1 --format='%an <%ae> / %cn <%ce>'` |
| date/time of the landing | **The commit instant IS observed at execution:** `2026-09-21T23:03:28Z` — the transport record embedded in the receipt at l.54 carries `"utc_time":"2026-09-21T23:03:28Z"` and `"run_id":"20260921T230328Z-330960-145554993"`. The receipt prints no other wall clock. *Separate observation, OBSERVED AFTERWARDS (2026-09-21 20:21:28 -0300):* `git log -1 --format='%ad / %cd' 931be1d1a` → `Mon Sep 21 20:03:28 2026 -0300` for both author and committer date — the same instant in the desktop's local zone. *Separate observation:* `tools/latent-lisp/.sync.log` l.6919-6920 carry `[2026-09-21T23:03:28Z]` for the post-commit launch naming this commit. | receipt l.54; `git log`; `.sync.log` l.6919-6920 |
| method | `git cherry-pick --no-commit` → index verification → a normal `git commit -F <original message + trailers>` | r1 l.191, 205-247, 275; witnessed in the receipt by the section headers "=== APPLY (no commit yet)" (l.19) and "=== COMMIT" (l.28), and by the index verification block l.20-26 |
| starting HEAD (= the landing commit's parent) | `892605580c5b6e5c709ba95a19b5d0124a444865` | **OBSERVED AT EXECUTION**, receipt l.2 ("starting HEAD:") and l.40 ("parent 892605580…, first-parent line") |
| landed commit | `931be1d1a816369b6701b13b756d4c70d6a4f19e` | **OBSERVED AT EXECUTION**, receipt l.38 (`[main 931be1d1a] …`) and l.40 (`landed: 931be1d1a816369b6701b13b756d4c70d6a4f19e`) |
| committer / author as recorded | `Claude <claude@lab.local>` / `Claude <claude@lab.local>` | **OBSERVED AFTERWARDS BY THE RECORD-KEEPER** (2026-09-21 20:21:28 -0300): `git log -1 --format='%an <%ae> / %cn <%ce> / %ad / %cd' 931be1d1a` → `Claude <claude@lab.local> / Claude <claude@lab.local> / Mon Sep 21 20:03:28 2026 -0300 / Mon Sep 21 20:03:28 2026 -0300`. **NOT OBSERVED in the receipt** — r1 does not print the identity. |
| pre-commit fence — did `lane-guard.sh` / `minute-guard.sh` run, and what did they say? | **NOT OBSERVED in the receipt.** The receipt carries no output from either guard: it goes from the printed message (l.29-37) directly to git's own `[main 931be1d1a]` summary (l.38). *Separate observation, OBSERVED AFTERWARDS BY THE RECORD-KEEPER (2026-09-21 20:21:28 -0300):* `.git/hooks/pre-commit` exists and is executable (3434 bytes, mtime 2026-09-05), and its first two actions are to run `tools/chairs/lane-guard.sh` and then `tools/chairs/minute-guard.sh`, each `|| exit 1`. Its own comment states lane-guard is *"silent for a lone chair."* So the receipt's silence is **consistent with** both guards running and passing silently — but silence is not a witness, and git keeps no per-commit record of hook execution. **What IS established:** the commit was made by a normal `git commit` (not `cherry-pick -x`, not `--no-verify` — r1 contains neither), so the hook path was taken, and the commit exited 0, so nothing on that path exited nonzero. **What is NOT established:** what either guard printed, or that either was invoked for *this* commit as opposed to being skipped for some reason the store does not record. | receipt: absent; `.git/hooks/pre-commit` read on 2026-09-21 20:21:28 -0300 |
| chair census printed by preflight 9 | sockets **1**, ps **1** | **OBSERVED AT EXECUTION**, receipt l.9-10. Both below the ≥2 threshold at which lane-guard refuses (receipt l.11-14 states the rule). |
| script exit code | **NOT OBSERVED in the receipt** — no exit code is printed anywhere in the 61 lines, and the preserved file is the script's output, not a shell trace. **INFERRED: 0.** Reasoning, in full: r1 runs under `set -euo pipefail`; the receipt's last four lines (l.57-61) are the script's closing `echo` block (r1 l.413-417), which is reachable only after every POSTFLIGHT assertion has passed, and the statement immediately following it is `exit 0` (r1 l.418). No `STOP:` line and no non-zero `exit` message appears anywhere in the receipt. The inference is that the process reached l.418 and exited 0; it is an inference, not a reading. | INFERRED |

**Why the method changed from r0.** `git cherry-pick -x` does **not** run a refusing `pre-commit` hook on
this host: measured by the chair, git 2.43.0, two fresh scratch repositories
(`evidence/MEASUREMENT-cherry-pick-and-pre-commit.txt`), and independently by the ruling office on git
2.51.1. The `--no-commit` + normal-commit route puts the house's own fence back in the path. r0's script
(`_staging/2026-09-21-commission-02-followup/PLINTH/land-floor-status-sentences-0.sh`) is SUPERSEDED and was
not run. *(Paragraph carried from the draft; the only change is the evidence path, now local to this
directory. See §0b for what this dossier does and does not establish about the fence actually firing.)*

**The `Landing-Note:` trailer is retained.** The landed commit carries, verbatim:

> `Landing-Note: the original message's sentence "NOT for main" was true when the candidate was cut and is
> superseded by the review-acceptance recorded in the trailer above; the message is carried unedited.`

OBSERVED AT EXECUTION (receipt l.37) and OBSERVED AFTERWARDS BY THE RECORD-KEEPER (2026-09-21 20:21:28 -0300,
`git log -1 --format=%B 931be1d1a`). Astra's ruling on it, verbatim: *"Retain the explanatory Landing-Note,
understood as applying through review acceptance plus Tomás's owner execution."* — i.e. the supersession it
declares rests on **two** acts, the ruling office's review-acceptance **and** the owner's execution, not on
either alone.

## 3. POSTFLIGHT, AS ASSERTED (r1 STOPs on any mismatch)

Every row below is **OBSERVED AT EXECUTION**.

| # | assertion | observed |
|---|---|---|
| a | landed blob == `8cbc50c7…` | `a. landed blob = 8cbc50c772b5225d02caac6df38883bf7dcb437e  CHECKED` — receipt l.43 |
| b | landed file sha256 == `5df120b1…` (`sha256sum -c`) | `b. landed file sha256 = 5df120b1723655bcf333dc181d43fa31289c53b378a6aba559c35251588a4b69  CHECKED` — receipt l.44 |
| c | `git diff --name-only HEAD^ HEAD` == the one path | `c. git diff --name-only HEAD^ HEAD = experiments/latent-lisp/mneme/verify-release.sh  CHECKED` — receipt l.45 |
| d | `Source-Commit:` and `Reviewed-By-Ruling-Office:` trailers present | `d. Source-Commit and Reviewed-By-Ruling-Office trailers present  CHECKED` — receipt l.46 |
| e | `bash -n` on the landed file | `e. bash -n experiments/latent-lisp/mneme/verify-release.sh  CHECKED` — receipt l.47 |
| f | `--list`: 124 total lines · `^both ` 82 · `^full ` 30 · full 112 · new `ml0` headline present · superseded headline absent | `f. --list: 123 non-empty lines of 124 total; both=82  full-only=30  full=112` / `124 / 82 ci / 112 full / new ml0 headline  ALL CHECKED` — receipt l.48-49. **Read exactly:** 123 is the *non-empty* count (`grep -c .`); 124 is the total (`wc -l`), asserted at r1 l.360. The "superseded headline absent" leg is asserted at r1 l.364 and is witnessed only by the run not stopping — it prints no line of its own. |
| g | a `.sync.log` record naming THIS commit with `"event":"WITHHELD"` (bounded wait, ≤ 60 s) | **YES.** `g. transport / sentinel present : yes / … this launch recorded WITHHELD: YES — the durable event names 931be1d1a816369b6701b13b756d4c70d6a4f19e` — receipt l.50-53, with the matched line quoted at l.54: `{"schema":"latent-lisp/transport-record/1","event":"WITHHELD","source_commit":"931be1d1a816369b6701b13b756d4c70d6a4f19e","attempted_ref":"https://github.com/Wondermonger-daydreaming/latent-lisp.git#refs/heads/main","subject_subtree":"(none)","exit_code":0,"reason":"paused by sentinel tools/latent-lisp/SYNC-PAUSED","tool":"sync.sh","run_id":"20260921T230328Z-330960-145554993","utc_time":"2026-09-21T23:03:28Z"}` |
| h | `origin/main` unmoved; `main` exactly one commit ahead | `h. origin/main still 892605580c5b6e5c709ba95a19b5d0124a444865 — main is ONE commit ahead. NOTHING PUSHED.` — receipt l.55 |

**On (g).** "Sentinel present" and "this launch recorded WITHHELD" are two different facts and are recorded
separately; the receipt says so itself at l.52. Both held here.
*Separate observation, OBSERVED AFTERWARDS BY THE RECORD-KEEPER (2026-09-21 20:21:28 -0300):* `grep -n 931be1d1a
tools/latent-lisp/.sync.log` returns four lines — 6919 (post-commit launching the supervisor for this
commit), 6920 (the supervisor's PENDING line for run `20260921T230328Z-330960-145554993`), 6939
(`transport-record: appended WITHHELD  8dd22d1c870e  source=931be1d1a816`), and 6941 (the same JSON quoted in
the receipt). The supervisor's closing line reads `transport-supervisor: sync exit=0 … — harvest complete`.
The sentinel `tools/latent-lisp/SYNC-PAUSED` is present on disk at 2026-09-21 20:21:28 -0300 (2019 bytes, mtime 2026-08-30).

## 4. WHAT THIS LANDING DID NOT DO

*Carried from the draft; every line re-checked against the store on 2026-09-21 20:21:28 -0300 and none required amendment.*

- **No publication and no ferry.** The sentinel `tools/latent-lisp/SYNC-PAUSED` stays RAISED; `sync.sh` was
  not invoked by hand; the public mirror tip `3e00b29c183fb9edc578fef0f20a44f63ade9153` does not move.
  PUBLISHED remains a three-stage word (CLAUDE.md §I-j) and every ferry is the owner's launch.
- **No pin edit.** `warrant-calculus/LMP0-clauses-CD-LCI.md` is untouched, as is every file under
  `release-floor-erratum-0/`. The successor identity is recorded here, beside the old one, per
  ARCHITECTURE-0-STATUS.md ADDENDUM 25 item 7 and the ruling office's *"Preserve the old pin as historical
  evidence."*
- **No other candidate.** Only `2e0b8d1df` was applied, and its branch is neither merged nor deleted. No a13
  branch, no warrant-session, no p10 gate, no mneme-debt, no p9-disposition.
- **`ml0.lisp:3002` is untouched**, `ml0-3002.patch` stays unapplied, the companion comment stands
  **UNCORRECTED**, **P9 FAIL STANDS IN THE REGISTER**, and the ML/0 repair programme is **not discharged**.
- **The demonstration is not bundled here** and is not evidence for this repair; it remains on HOLD.
- **No adoption, registration, freeze, or ML/1 reopening.** The stranger primitive-minimization audit remains
  **OWED and uncommissioned**.

**One consequence, said aloud:** the changed file lives under `experiments/latent-lisp/`, the published
subject subtree. Landing it does not publish it — but it **will be carried into the next public cargo
whenever a ferry is next authorized**, as part of whatever commit that ferry binds. That is a future
owner-gated act, not this one.

## 5. PUSH

`git push` is a separate act, not performed by the landing script.

| field | value | source |
|---|---|---|
| pushed? | **NO.** Nothing has been pushed. | **OBSERVED AT EXECUTION**, receipt l.55 ("NOTHING PUSHED") and l.58. **OBSERVED AFTERWARDS BY THE RECORD-KEEPER** (2026-09-21 20:21:28 -0300): `git rev-parse origin/main` → `892605580c5b6e5c709ba95a19b5d0124a444865`, unmoved. |
| by whom, when | **NOT APPLICABLE — no push has occurred.** | as above |
| `origin/main` after | `892605580c5b6e5c709ba95a19b5d0124a444865` — unchanged from the starting HEAD | **OBSERVED AT EXECUTION** (receipt l.55) and **OBSERVED AFTERWARDS** (2026-09-21 20:21:28 -0300) |

**State of `main` at the time of writing, OBSERVED AFTERWARDS BY THE RECORD-KEEPER (2026-09-21 20:21:28 -0300):**
`git rev-parse HEAD` → `ef62aed700b2908a42a27a531444bd9de224e07f`; `git rev-list --count origin/main..main`
→ **2**. The landing commit `931be1d1a` and one further local commit (`ef62aed70`, the front-door ADDENDUM 9
carrying the preserved receipt) are both **local only**. The companion commit this directory is prepared for
will make it three. **Nothing goes to `origin` until the companion's own transport result has been returned.**
