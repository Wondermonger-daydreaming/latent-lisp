# Surface Account /0 — Opening Base and Custody

**Round:** R0 (opening).
**Custody officer:** WARDEN (Claude Opus 5, 1M context), acting under the
Surface Account /0 opening commission.
**Measured:** 2026-08-04, UTC times as stamped below, on host
`gauss-VJFE69F11X-B0221H`.

Every value in this document was produced by a command run during this
custody session and is reproduced verbatim beside the command that produced
it. **No value in this document was copied from the commission.** Where the
commission stated an expectation, the expectation is compared against a fresh
measurement in `PREDECESSOR-IDENTITIES.md`; it is never substituted for one.

Paths written `mneme/…` are subject-root relative and live at
`experiments/latent-lisp/mneme/…` in the lab monorepo. Where a lab path is
meant, it is written in full.

---

## 1. The declaration

**`OPENING_BASE` = `c12e96f4dd6c0cefdc7bfa5f79c6afc704559eff`**

This is the lab monorepo commit at which lab `HEAD`, `main`, and `origin/main`
were one exact commit at the moment this round opened, and it is the commit
the dedicated worktree was branched from.

`OPENING_BASE` is **not** the sealed Integration Baseline /0 identity. Three
distinct identities are in play in this round and must never be conflated:

| Name | Value | What it is |
|---|---|---|
| **Sealed IB/0 tip** | `798d59f24046e942fcddcac82339a7f5f56ecede` | The sealed Integration Baseline /0 lab commit. An **anchor**. Nothing in this round may be attributed to it. |
| **Sealed IB/0 subject subtree** | `6f43791fbf24abd33ea5d012fba07df38e8f52bb` | The `experiments/latent-lisp` tree at the sealed tip. |
| **`OPENING_BASE`** | `c12e96f4dd6c0cefdc7bfa5f79c6afc704559eff` | Today's lab commit this round opens from. A **linear descendant** of the sealed tip carrying post-closure housekeeping only. |

The subject subtree at `OPENING_BASE` is **also**
`6f43791fbf24abd33ea5d012fba07df38e8f52bb` — byte-identical to the sealed tip
(§5, and the proof table in `PREDECESSOR-IDENTITIES.md`). The two commits
differ; the subject tree does not.

---

## 2. Recorded initial state

### 2.1 Refs at declaration

```
$ git -C /home/gauss/Desktop/Claude-Code-Lab rev-parse HEAD main origin/main
c12e96f4dd6c0cefdc7bfa5f79c6afc704559eff
c12e96f4dd6c0cefdc7bfa5f79c6afc704559eff
c12e96f4dd6c0cefdc7bfa5f79c6afc704559eff
```

All three refs are one exact commit. **Condition satisfied.**

### 2.2 Raw status at declaration (verbatim)

```
$ git -C /home/gauss/Desktop/Claude-Code-Lab status --porcelain=v1
 M tools/ledger/agents.jsonl
?? _staging/guide-fixture-bite-evidence.lisp
?? _staging/guide-g7-diagnosis.lisp
?? _staging/guide-walk-the-recipe.lisp
?? _staging/lci0-adjudication-draft-2026-08-02.md
?? _staging/surface1-PRISMA-expansion-survey.md
?? _staging/surface1-SURVEY-DIGEST.md
?? _staging/synthesis-01/
?? experiments/latent-lisp/mneme/PROJECT-STATE-ASSESSMENT-2026-08-02.md
```

**The untracked set is eight entries.** None of them is touched, moved,
cleaned, absorbed, committed, or interpreted by this round. The single tracked
modification (`tools/ledger/agents.jsonl`) is live automatic-writer churn — see
§6.

### 2.3 Remotes

```
$ git -C /home/gauss/Desktop/Claude-Code-Lab remote -v
origin	https://github.com/Wondermonger-daydreaming/Claude-Code-Lab (fetch)
origin	https://github.com/Wondermonger-daydreaming/Claude-Code-Lab (push)
```

The public mirror is **not** a remote of the lab checkout. Its URL is read out
of `tools/latent-lisp/sync.sh`:
`https://github.com/Wondermonger-daydreaming/latent-lisp.git`.

### 2.4 Live public `main`

```
$ git ls-remote https://github.com/Wondermonger-daydreaming/latent-lisp.git refs/heads/main
ced1b2ceb13f22cec188c2b3f73dcfc73e7d112e	refs/heads/main
```

Exactly `ced1b2ceb13f22cec188c2b3f73dcfc73e7d112e`. **Condition satisfied.**

### 2.5 Superseded pre-housekeeping snapshot (kept as evidence)

An earlier snapshot was taken minutes before, at lab commit
`706993968bd037adc797646e4d7df7fdcecb1738`, before the chair committed pending
diary housekeeping. It is retained in the custody evidence dir as
`*-pre-housekeeping.txt` and is **superseded, not deleted**. Its raw status
differed from §2.2 in exactly two ways, both explained by the chair's
housekeeping commit `c12e96f4`:

- ` M diary/index.md` — the index line, now committed;
- `?? diary/entries/2026-08-03-the-five-returns-and-the-closed-baseline.md` —
  the entry it references, now tracked.

The untracked set therefore shrank from nine entries to eight by that one file
becoming tracked. No untracked file was removed, moved, or cleaned by anyone
during this custody session.

---

## 3. Opening-condition verification

| Condition | Command | Result |
|---|---|---|
| lab `HEAD` == `main` == `origin/main`, one exact commit | `git rev-parse HEAD main origin/main` | **PASS** — all three `c12e96f4…` |
| that commit is the sealed tip or a linear descendant | `git merge-base --is-ancestor 798d59f2… c12e96f4…` | **PASS** — exit 0 (ancestor) |
| no merge commits in the descent | `git rev-list --merges 798d59f2..c12e96f4` | **PASS** — empty output (linear) |
| live public `main` is exactly `ced1b2ce…` | `git ls-remote <public> refs/heads/main` | **PASS** — `ced1b2ceb13f22cec188c2b3f73dcfc73e7d112e` |
| zero changes under the protected paths | `git diff --name-status 798d59f2..c12e96f4 -- <path>` ×8 | **PASS** — see §4.2 |
| no other executable language/loader/floor/publication surface changed | `git diff --name-status 798d59f2..c12e96f4 -- experiments/latent-lisp/` | **PASS** — empty output; the entire subject tree is unchanged |

No stop condition fired. `custody-STOP.md` was not written.

---

## 4. Post-closure movement inventory

### 4.1 Commits between the sealed tip and `OPENING_BASE`

```
$ git -C /home/gauss/Desktop/Claude-Code-Lab log --format='%H %s' \
    798d59f24046e942fcddcac82339a7f5f56ecede..c12e96f4dd6c0cefdc7bfa5f79c6afc704559eff
c12e96f4dd6c0cefdc7bfa5f79c6afc704559eff diary: file the five-returns entry and its index line (post-closure housekeeping)
706993968bd037adc797646e4d7df7fdcecb1738 handoff: Integration Baseline /0 closed — coordinates, builders of record, open items, scars
d0b5b503f88b87d0f974f588905d1fd6b1eb295b ledger: restore agent rows preserved across the owner-authorized main reset, add publication-round entry
```

Three commits, all authored `Tomás P. Pavan <pelotiqueiros@gmail.com>`,
dated 2026-08-03T19:06:35-03:00, 2026-08-03T19:16:08-03:00, and
2026-08-04T12:58:00-03:00 respectively.

### 4.2 Changed paths, with the custody judgment for each

```
$ git -C /home/gauss/Desktop/Claude-Code-Lab diff --name-status \
    798d59f24046e942fcddcac82339a7f5f56ecede..c12e96f4dd6c0cefdc7bfa5f79c6afc704559eff
A	diary/entries/2026-08-03-the-five-returns-and-the-closed-baseline.md
M	diary/index.md
A	notes/2026-08-03-session-handoff-integration-baseline-0-closed.md
M	tools/ledger/agents.jsonl
```

| Lab path | Commit | Judgment |
|---|---|---|
| `diary/entries/2026-08-03-the-five-returns-and-the-closed-baseline.md` | `c12e96f4` | **Diary entry — recorded housekeeping.** `/diary` was explicitly authorized after closure. Narrative only; no executable, loader, floor, or publication surface. |
| `diary/index.md` | `c12e96f4` | **Diary index line — recorded housekeeping.** A one-line pointer to the entry above. Narrative only. |
| `notes/2026-08-03-session-handoff-integration-baseline-0-closed.md` | `70699396` | **Session handoff note — recorded housekeeping.** Continuity prose recording IB/0 closure coordinates. Outside the subject tree; narrative only. |
| `tools/ledger/agents.jsonl` | `d0b5b503` | **Provenance ledger append — recorded housekeeping.** Sub-agent rows restored across the owner-authorized main reset plus a publication-round row. Append-only provenance data; outside the subject tree; no behavioural surface. |

**Every changed path lies outside `experiments/latent-lisp/`.** The whole
subject tree is untouched — the strongest available form of the required
"zero changes to the protected paths":

```
$ git diff --name-status 798d59f2..c12e96f4 -- experiments/latent-lisp/
(no output)
```

Per-protected-path change counts (all zero):

```
0  experiments/latent-lisp/mneme/integration-baseline-0/
0  experiments/latent-lisp/mneme/language-surface-0/
0  experiments/latent-lisp/mneme/language-surface-1/
0  experiments/latent-lisp/mneme/language-surface-2/
0  experiments/latent-lisp/lisp-plus.asd
0  experiments/latent-lisp/mneme/load-lisp-plus.sh
0  experiments/latent-lisp/mneme/load-order-matrix.sh
0  experiments/latent-lisp/mneme/verify-release.sh
```

---

## 5. Working branch and worktree

```
$ git -C /home/gauss/Desktop/Claude-Code-Lab worktree add -b surface-account-0-opening \
    /home/gauss/Desktop/worktrees/surface-account-0 c12e96f4dd6c0cefdc7bfa5f79c6afc704559eff
Preparing worktree (new branch 'surface-account-0-opening')
HEAD is now at c12e96f4 diary: file the five-returns entry and its index line (post-closure housekeeping)
```

- **Branch:** `surface-account-0-opening`
- **Worktree:** `/home/gauss/Desktop/worktrees/surface-account-0`
- **Worktree HEAD at creation:** `c12e96f4dd6c0cefdc7bfa5f79c6afc704559eff`

Raw-clean at creation, measured 2026-08-04T16:00:41Z:

```
$ git -C /home/gauss/Desktop/worktrees/surface-account-0 status --porcelain
(no output)
```

All round work happens **only** in this worktree on this branch. Lab `main`,
lab `origin/main`, and public `main` are not written to by this round. No
push, no tag, no sync, no `git add`/`commit`/`checkout`/`clean` in the original
checkout is performed by the custody officer at any point.

---

## 6. Custody hazard: two live automatic writers in the ORIGINAL checkout

This is recorded so that mid-arc movement in the original checkout is
**recognized as the documented mechanism it is**, and not silently absorbed as
if it were round work — nor mistaken for divergence. Both writers are
authorized lab housekeeping and predate this round.

**(a) PostToolUse(`Task`) ledger hook.** Every subagent spawn appends a row to
`tools/ledger/agents.jsonl`. Several more spawns are expected this arc.
Consequence: that one tracked file will show as ` M` in the original
checkout's raw status at arbitrary moments.

**(b) Stop hook `.claude/hooks/continuity/session-checkpoint.sh`.** At
conversation turn boundaries it stages **modified tracked files only**
(`git add -u`, never untracked) and commits them locally with a message of the
form `checkpoint: N file(s) in <dirs> [YYYY-MM-DD HH:MM]`. It skips entirely if
anything is already staged, and it never pushes. Read from the script itself
during this session; the behaviour above is quoted from its own header and body,
not assumed.

**This already fired once during custody, as predicted.** Immediately after the
worktree was created, lab `main` advanced:

```
$ git -C /home/gauss/Desktop/Claude-Code-Lab log --format='%H %s' c12e96f4..main
33b916237fb57ba437fc86d37e9f438fc0655b4d checkpoint: 1 file(s) in tools [2026-08-04 12:59]

$ git -C /home/gauss/Desktop/Claude-Code-Lab diff --name-status c12e96f4..main
M	tools/ledger/agents.jsonl
```

That commit is the (a)-churn absorbed by (b). It touches `tools/ledger/` only,
nothing under `experiments/latent-lisp/`, and it was **not** pushed —
`origin/main` remained at `c12e96f4` while `main` moved to `33b91623`. It is
recorded here as the first observed instance of the mechanism, and it does not
move `OPENING_BASE`: `OPENING_BASE` is the last commit at which `HEAD`, `main`,
and `origin/main` coincided, and it is the branch point of the worktree.

### 6.1 The custody law for the remainder of the arc

At return, the following must hold. Anything else is a **reconciliation stop**,
not a value to absorb silently.

1. **Lab `main` must be a linear descendant of `OPENING_BASE`** in which every
   intervening commit either (i) touches only `tools/ledger/`, or (ii) is an
   explicitly chair-authored recorded housekeeping commit — and in which
   **zero** changes appear under any protected path or anywhere under
   `experiments/latent-lisp/` outside this round's own branch.
2. **`origin/main` may lag `main`** by exactly those unpushed checkpoint
   commits. Any *other* divergence between `main` and `origin/main` is a stop.
3. **Public `main` must remain exactly**
   `ced1b2ceb13f22cec188c2b3f73dcfc73e7d112e`. Any public movement is a
   reconciliation stop, not a value to absorb.
4. **The original checkout's raw status must be byte-identical to §2.2, with
   one explicitly documented exception**: the `tools/ledger/agents.jsonl` line
   may be present or absent depending on whether the checkpoint hook last fired
   before or after the most recent spawn. **The untracked set must be
   unchanged — all eight entries of §2.2, exactly, no additions and no
   removals.** This exception is a documented mechanism (§6a, §6b), disclosed
   here in advance and not a waiver invented after the fact.
5. **The dedicated worktree must be raw-clean at return.**
6. **The eight protected paths must remain byte-identical** to their sealed-tip
   hashes as tabulated in `PREDECESSOR-IDENTITIES.md`.

Any divergence, unrecorded commit, semantic movement, or predecessor mutation
is a stop condition. A stop is written up, not repaired.

### 6.2 Standing of the two tolerances above — amended after the fresh-context review (F5)

The fresh-context review is right on jurisdiction, and this amendment
concedes it: items **2** and **4** above are not the commission's law — the
commission's strict text requires lab `HEAD`, `main`, and `origin/main` to
be **one exact commit** and the original checkout's raw status to be
**byte-identical** before and after, with any divergence a stop condition.
Items 2 and 4 are **chair-authored deviations from that strict text**,
written to accommodate two pre-existing automatic lab mechanisms (§6a, §6b)
that this round neither installed nor controls. However honest and however
pre-disclosed, **a builder cannot grant itself relief from the law it is
judged by**: these tolerances are therefore **SUBMITTED FOR OWNER RULING as
part of this return, not waivers in force**. Until the owner rules, the
honest statement of the custody condition is: *technically unmet under the
strict text; the deviation mechanism is exhibited, measured, and confined
to `tools/ledger/agents.jsonl` and unpushed checkpoint commits; the owner
decides whether this is recorded housekeeping within the commission's
meaning or a stop.* The review's own read-only remeasurement at review time
found the tolerances honoured in fact (four checkpoint commits, all
`tools/ledger/` only; untracked set unchanged; public `main` unmoved).

*Amendment entered by JURIST (Claude Fable 5) at the chair's direction, in
WARDEN's custody document; the original §6.1 text is left standing above so
the owner can see exactly what was written before the review and what its
standing was corrected to.*

### 6.3 The owner has ruled (R1 adjudication, Locked Ruling 4)

The submission of §6.2 is answered. The owner **ratifies these exact six
local Stop-hook commits as ledger-only housekeeping**:

    33b91623   907c3fc8   4c5f0282   b58ca619   15c2c254   e6cbbf7b

The ruling's own limit is carried here verbatim: **"This is not a general
waiver."** The ratification covers exactly those six commits; any further
checkpoint movement is a fresh fact for the owner, not covered by this
ruling, and the strict-text stop conditions of the commission otherwise
stand. The ruling also directs a correction to the parcel's
`BUNDLE-INSTRUCTIONS.md` (a packing artifact, not a lane file): it must
state that the **three pre-opening housekeeping commits were accepted** at
opening, while the **six checkpoints are accepted now by this ruling** —
two acceptances, two moments, never merged into one.

*R1 note entered by JURIST (Claude Fable 5) per the owner adjudication, in
WARDEN's custody document.*

### 6.4 R3 custody rulings — six further ratifications and four precision corrections

The R3 adjudication ratifies **six exact post-R1 private-lab housekeeping
commits** (`4b66c013`, `0e303440`, `ae10527a`, `f5989500`, `186ec1e9`,
`0f5013c1`) — granting, in the ruling's words, *no design, contract,
production, publication, or precedent standing*, and *not a waiver for
future custody deviations* — and records four **authoritative precision
corrections**, carried here so no reader inherits the older, stronger
phrasings:

1. **The push nuance:** *no Surface Account design commit was ever
   pushed*; **one** disclosed private-lab ledger commit, `4b66c013`, was
   pushed to lab `main`; the five later checkpoints remained local. Every
   "unpushed" claim in this lane is a claim about the **design branch**,
   which remains exactly true; no lane claim of "nothing pushed anywhere"
   survives.
2. **The untracked-set evidence proves the same eight status/path
   NAMES** — not byte-identical untracked contents. §6.1(4)'s
   eight-entries condition is and always was a names condition; no
   content-identity claim about untracked files exists or may be inferred.
3. **One raw-clean design status is captured.** No later commit is
   established, but **separate raw statuses after every individual run are
   not present** — the packer supplies per-run statuses going forward;
   nothing in this lane claims they exist for past runs.
4. **R1→R2 changed 25 paths — 18 modified and 7 added, not 24**
   (corrected in place in `R2-COMPLIANCE-CHECK.md` T2).

*R3 note entered by JURIST (Claude Fable 5) per the R2 adjudication's
custody rulings, in WARDEN's custody document.*

---

## 7. Evidence

Raw command output is held outside the repo, in this session's custody
evidence directory:

```
…/scratchpad/sa0-parcel-staging/custody/
  head-refs-initial.txt                 status-initial.txt
  status-initial-human.txt              remotes.txt
  public-main-initial.txt               post-closure-commits.txt
  post-closure-paths.txt                subject-tree-diff.txt
  protected-paths-check.txt             merges-in-range.txt
  byte-identity-lab.txt                 anchors-public-remeasured.txt
  worktree-clean-initial.txt            worktree-clean-initial-annotated.txt
  mid-arc-checkpoint-commits.txt        mid-arc-checkpoint-paths.txt
  *-pre-housekeeping.txt                (superseded 70699396 snapshot)
…/scratchpad/sa0-parcel-staging/public-mirror-ro/   (read-only clone, --no-checkout)
```

The public mirror was reached **read-only** — one `git ls-remote` and one
`git clone --no-checkout`. Nothing was pushed to the public mirror, no
Surface Account design commit was ever pushed to any remote (one private-lab
ledger commit, `4b66c013`, was later pushed to the lab origin — the §6.4(1)
precision correction), and `tools/latent-lisp/sync.sh` was read but never run.

— WARDEN, custody officer, Surface Account /0 opening round
— Claude Opus 5 (1M context), 2026-08-04

---

## 8. The R3.3.x custody spine (entered at R4 opening, per the R4 relay's documentary debt)

*Entered by FABER (Claude Fable 5), R4 integrator, 2026-08-06, under the R4
relay's explicit authorization to update this document with the unpaid
R3.3.x chain. Every byte count, SHA-256, and member count below was measured
this session against the actual parcels in `/home/gauss/Downloads/`
(`stat`, `sha256sum`, `unzip -l`), read-only — none is inferred from memory
or copied from the relay without measurement. Earlier rulings are recorded
as they were; nothing below smooths the historical path.*

| Round | Canonical parcel (exact name, in `Downloads/`) | Bytes | Archive SHA-256 (measured; matches the relay spine exactly) | Members *(total archive entries incl. directory entries — `unzip -l` census, NOT a file-only count; a `find -type f` over an extraction will read 11–13 lower — R4.1 note per QUARTERMASTER F3)* | Tip | Ruling |
|---|---|---|---|---|---|---|
| **R3.3** | `SURFACE-ACCOUNT-0-R3.3-RETURN-2026-08-05.zip` | 516489 | `2fbb921cdfb511e6ea03c636024748e0f090bd8a932eadf6ead7290e6288a3ec` | 118 | `4ef6c232fd2d89d7cbd3779944775b8b024afc2c` | RETURN — exceptional initialization closure remained |
| **R3.3.1** | `SURFACE-ACCOUNT-0-R3.3.1-RETURN-2026-08-05.zip` | 434619 | `fa8ab9273dd56d26ac86218d75758dc5d07c37d2e074b674c34c58344505ec7e` | 133 | `fd27d5a3eefc4624bbb099face9ce1e91c92ca18` | RETURN — publication finality and reserved-indicator validity remained |
| **R3.3.2** | `SURFACE-ACCOUNT-0-R3.3.2-RETURN-2026-08-05.zip` | 491461 | `9aa53abde372426792e83ab9938a701ea2bffab3693cf65c6500922c43099675` | 145 | `012c68f13b6a1d4c655d53f1f3d3d26ba55c8659` | RETURN — malformed-carrier totality remained |
| **R3.3.3** | `SURFACE-ACCOUNT-0-R3.3.3-RETURN-2026-08-06.zip` | 497184 | `ffeeedb2b4e666d3f72698f64917e91f523e11d83e10157d048e5e5bf7211edf` | 162 | `2c1ac711b039528fd6a9d665d37ac2a937bf532d` | **ACCEPT** — Surface Account /0 laboratory phase terminally closed; R4 production-candidate round authorized |

The accepted R3.3.3 lane tree is `3076aa17e922f0589e75827f560c038699f0854e`
(verified live at R4 opening: `git ls-tree 2c1ac711…` in the R4 worktree).

**Non-canonical variants present beside the spine, measured and named so no
future custody reader mistakes them:**

- `SURFACE-ACCOUNT-0-R3 (3).3-RETURN-2026-08-05.zip` — the R3.3
  duplicate-upload wrapper the relay warns against: SHA-256
  `9577c9a2477ebed10241b5b99b40ae7e7e0ff9cb02a1c9c63b7c54775b36f439`,
  536740 bytes, 119 members. **Not canonical.** The exact-name R3.3 parcel
  above is the custody object.
- `SURFACE-ACCOUNT-0-R3.3.2-RETURN-2026-08-05a.zip` — a second R3.3.2
  upload: SHA-256
  `b66b6ae161e7f62babfbaf581e921b89e14854b4cd46606d6ff51e01bb741fd2`,
  515828 bytes, 146 members. **Not canonical.** The exact-name R3.3.2
  parcel above matches the spine and is the custody object.

— FABER, R4 integrator (Claude Fable 5), 2026-08-06
