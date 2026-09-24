# S15 ERRATUM /0 — CONSOLIDATION, 2026-09-21

*PLINTH-II, 2026-09-21. **PROPOSED — NOT ADOPTED.** This document does not edit
`S15-ERRATUM-0.md`; the draft stands exactly as PLINTH wrote it, in
`_staging/2026-09-21-commission-02-followup/PLINTH/S15-ERRATUM-0.md`. This file closes the draft's two
declared open points, records the corrected landing method, and specifies the companion change the draft's
§8 promised but the landing script does not make.*

**Commission.** The ruling office's review of return 03, §1 "Floor: retain acceptance; repair the executable
landing procedure", docked verbatim at
`corpus/voices/received/originals/2026-09-21-193306-astra-review-of-return-03-floor-procedure-demo-HOLD-registry-defects-VERBATIM.md.orig`
(sha256 `cdaf98a251bf513221712c958dd18fa210d3c07e19342991246662caacc2c8e3`).

---

## 0. THE DRAFT IS PRESERVED UNEDITED

`S15-ERRATUM-0.md` is not touched by this consolidation, by r1, or by anything in this directory. Its §3b
disclosure ("the reply is NOT YET DOCKED") and its §7 limit ("the reviewed archive sha256 … not re-derived")
remain on its page as written, because they were true of the draft on its date. This document is what a
reader reaches next; the two points are closed **here**, dated, with paths and hashes.

---

## 1. OPEN POINT 1 — the review-acceptance is now DOCKED

The draft's §3(b) cited the ruling office's acceptance from a file outside the repository
(`/mnt/c/Users/Tomás Pavam/Downloads/Fable-Reply-02-Candidate-Review-and-Terminal-Steps.md`) and declared
"**DISCLOSURE — the reply is NOT YET DOCKED**", making docking a precondition of adoption.

**That precondition is met.** The reply is docked verbatim in the tree at

| field | value |
|---|---|
| docked path | `corpus/voices/received/originals/2026-09-21-183307-astra-side-reply-02-candidate-review-floor-ACCEPTED-demo-HOLD-VERBATIM.md.orig` |
| sha256 | `943767ba917c4347ec54123dd509b0676bc40bd7b8f1062734c70e8cc37f4eeb` |
| verified | 2026-09-21 by PLINTH-II on the desktop, `sha256sum` on the tracked file; identical to the value the chair recorded in return 03 |

The acceptance sentence quoted in the draft's §3(b) stands, and the acceptance was **RETAINED** by the later
review of the same day: *"The floor wording remains review-accepted; the supplied landing procedure needs a
correction."* Nothing in the 19:33 review reopens the prose-only judgment.

r1's preflight check 10 asserts this file is present at that path and prints its sha256 before anything is
applied, and the landing commit carries
`Reviewed-By-Ruling-Office: review-accepted 2026-09-21, docked <that path>` as a trailer.

## 2. OPEN POINT 2 — the reviewed archive sha256

The draft's §7 recorded `ec98ff8df6fb8dd821e87c16551d642017010a1aad06606fdef912dd99340e7f` as **taken from
the commission and not re-derived**, the archive not having been located by that drafter.

**Closed, with its provenance named.** The chair (Claude Fable 5.1) hashed the archive on this host on
2026-09-21 and recorded, in return 03 (`_staging/2026-09-21-return-03-pasteable-to-astra/PASTEABLE-TO-ASTRA-03.md`,
item 1): *"the archive you reviewed hashes here to exactly
`ec98ff8df6fb8dd821e87c16551d642017010a1aad06606fdef912dd99340e7f`"*. The ruling office independently states,
in its acceptance (line 20 of the docked file): *"Archive SHA-256:
`ec98ff8df6fb8dd821e87c16551d642017010a1aad06606fdef912dd99340e7f`"*, and *"I verified the archive against
its sidecar and every internal manifest entry."*

**Honest limit.** PLINTH-II did **not** re-derive this value; the archive is a parcel in the owner's
`Downloads\Parcels\`, outside the repository. What is established is that two parties — the chair on this
host, the ruling office on its own copy — report the same digest for it. That is a matching pair of reports,
not a third measurement.

---

## 3. THE CORRECTED LANDING METHOD, AND WHY

**r0's method was `git cherry-pick -x`, on the premise that cherry-pick runs the pre-commit fence. The
premise is false on this host.**

Evidence, in the order it arrived:

1. **The ruling office**, §1 of the 19:33 review: in a fresh git 2.51.1 repository, with a `pre-commit` hook
   that logged and exited 1 and a logging `post-commit` hook, `git cherry-pick -x <candidate>` **exited 0**;
   only `post-commit` logged; the refusing hook did not run.
2. **The chair's own measurement on this host**, git 2.43.0, two fresh scratch repositories, no reset
   anywhere — `_staging/2026-09-21-review-03-repairs/MEASUREMENT-cherry-pick-and-pre-commit.txt`:
   - **A.** `git cherry-pick -x <cand>`: exit 0, the commit **LANDED**, hooklog shows `POST-COMMIT-RAN` only.
   - **B.** `git cherry-pick --no-commit <cand>` then a normal `git commit`: `PRE-COMMIT-RAN`, commit exit 1,
     **nothing landed**, the change **still staged**.
   The measurement file records, in the chair's own words, that the earlier agent's contrary measurement was
   wrong and was relayed to the ruling office unchecked.

**So r1 lands with `--no-commit` + a normal `git commit`.** The commit is what the fence guards, so the fence
runs. Between the two, r1 **verifies the index**: exactly one staged path, that path, that path's blob equal
to the reviewed blob `8cbc50c772b5225d02caac6df38883bf7dcb437e` (`git rev-parse :<path>`, with
`git ls-files -s` printed beside it), the working file's sha256 checked with `sha256sum -c` (not printed with
an "expect" comment), and the tracked working tree showing that one modification and nothing else.

**No pathspec on the commit line**, against the house rite — deliberately. Git refuses a partial commit while
`CHERRY_PICK_HEAD` exists. The index verification above stands in its place and is stricter: the rite's
pathspec limits what is committed, while this asserts what *is already* in the index, down to the blob.

**On refusal, nothing is discarded.** r1 prints that the change REMAINS STAGED, lists `git status --short`,
prints the staged blob and the unchanged HEAD, names what to inspect in order, and exits 4. It contains no
`--no-verify`, no override variable for the fence, no `reset`, no `checkout`, no `stash`, no
`cherry-pick --abort` or `--quit`. Deciding what to do with a refused commit is a person's act, and `--abort`
would destroy the staged work.

**The trailers.** The candidate's original message is carried byte-for-byte via `git log -1 --format=%B` into
a temp file used with `git commit -F`; two trailers are appended — `Source-Commit: <full candidate sha>` and
`Reviewed-By-Ruling-Office: …`. A third, `Landing-Note:`, discloses that the original message's sentence
*"NOT for main"* was true when the candidate was cut and is superseded by the recorded review-acceptance.
The message itself is not edited; a landed commit that says "NOT for main" with no explanation would be a
record defect, and editing it would be a different one.

**The enumeration and transport sections now ENFORCE.** See §4 and §5.

## 4. THE ENUMERATION, MEASURED (not assumed, not printed)

`verify-release.sh` counts its own table at lines 400–405:

```
AUTHORIZED_GATES_FULL=112 ; AUTHORIZED_GATES_CI=82
COUNT_CI        = grep -c '^both|'  over $GATES
COUNT_FULL_ONLY = grep -c '^full|'  over $GATES
COUNT_FULL      = COUNT_CI + COUNT_FULL_ONLY
```

`--list` (lines 419–431) prints: one header line, one line per `GATES` row rendered `'%-6s %-12s …'` (so each
begins `both ` or `full `), a blank line, the `-- declared, not executed --` header, and one line per
`DECLARED` row.

**Measured by PLINTH-II on this host, 2026-09-21, read-only**, by extracting each blob with `git cat-file blob`
into a scratch file and running it with `--list` (which runs nothing and exits 0):

| blob | total lines | `^both ` | `^full ` | full = both + full-only |
|---|---|---|---|---|
| candidate `8cbc50c7…` (sha256 `5df120b1…`, re-derived here and matching) | **124** | **82** | **30** | **112** |
| prior `fb99a6b6…` (currently on `main`) | 124 | 82 | 30 | 112 |

`diff` of the two `--list` outputs: **exactly one differing line**, the `ml0` DECLARED headline
(old: `… ADOPTED AND PUBLISHED · stranger audit owed · no independent verification`;
new: `… ADOPTED AND PUBLISHED · current standing is ARCHITECTURE-0-STATUS.md ADDENDUM 25 item 6, quoted
verbatim below · P9 FAIL STANDS IN THE REGISTER · ml0.lisp:3002 COMPANION COMMENT UNCORRECTED`).

**So 124 is what `--list` prints at the candidate, and 112/82 is the script's own enumeration of it.** r1's
postflight asserts all four facts mechanically — total 124, `both` 82, full 112, the new headline present and
the superseded sentence absent as the headline — and STOPs on any mismatch. These assertions are what the
draft's §0 table claimed and what r0 merely printed.

## 5. THE TRANSPORT CHECK, BOUND TO THIS LANDING

Read from the tooling, not assumed:

- `.git/hooks/post-commit` → `tools/latent-lisp/post-commit.sh`. On a commit on `main` touching
  `experiments/latent-lisp/`, it appends to `tools/latent-lisp/.sync.log` a launch line naming the **full**
  commit id, and fires `transport-supervisor.sh` **detached** with `--commit <that full id>`.
- With the sentinel `tools/latent-lisp/SYNC-PAUSED` present, `sync.sh` takes its pause branch
  (`sync.sh:271–278`) and calls `record_event WITHHELD 0 "paused by sentinel …"`. The durable event is echoed
  into `.sync.log` by the supervisor as a JSON line carrying
  `"event":"WITHHELD","source_commit":"<the full commit id>"`.
- Both existing precedents in `.sync.log` have exactly that shape (`303a1dcafb56…` on 2026-09-03,
  `519e997e90ae…` on 2026-09-04).

**So r1 polls `.sync.log`, at most 60 s, every 2 s, for a line containing BOTH this landing's full commit id
AND `"event":"WITHHELD"`.** That is the binding: the record names the commit we just made. It prints the
matched line.

r1 states the two facts separately and never lets one stand for the other:

```
sentinel present            : yes|NO        (a STATE of the pause flag)
this launch recorded WITHHELD: YES|UNESTABLISHED   (a record naming THIS commit)
```

If no bound record appears within the bound, r1 prints **UNESTABLISHED**, says plainly that this is a claim
about missing *evidence* and not a claim that anything transported, prints the log tail marked as context
that binds nothing, names `transport-status.sh` and the durable ref to inspect, states **THE LANDING STANDS**,
and exits 7 **without undoing anything**.

**Untested end-to-end.** This binding is argued from source and from two existing records; it can only be
exercised by a real landing, and the teeth deliberately skip it.

---

## 6. SECTION 8 OF THE DRAFT — THE COMPANION CHANGE, AND ITS ORDER

The draft's §8 says the governed erratum directory is created "as part of the landing act". **r1 does not
create it** — r1 cherry-picks one file and commits it, and nothing else. That gap is what the ruling office
named. It is closed here by specifying a **separate companion commit**, not by widening the landing.

### 6.1 The companion change — exact path and file list

Following the `experiments/latent-lisp/mneme/release-floor-erratum-0/` precedent:

```
experiments/latent-lisp/mneme/floor-status-sentences-erratum-0/
├── S15-ERRATUM-0.md            ← the draft, carried in UNEDITED
├── CONSOLIDATION-2026-09-21.md ← this document, carried in
├── PIN-SITES.md                ← the pin census, carried in unedited
├── LANDING-RECORD.md           ← written AFTER the landing, from its actual output
└── evidence/
    ├── candidate.diff                          ← git diff 2e0b8d1df^ 2e0b8d1df
    ├── list-diff.txt                           ← the one-line --list difference (both blobs)
    ├── IDENTITY-CAPTURE-predecessor.txt        ← path · blob · file sha256 · line count, at main before landing
    ├── IDENTITY-CAPTURE-successor.txt          ← the same, at the landed commit on main
    ├── floor-candidate-2e0b8d1d.transcript.txt ← + .meta (carried from _staging, which is not published)
    └── MEASUREMENT-cherry-pick-and-pre-commit.txt ← why the landing method changed
```

Drafts of every one of these, with execution-time values marked, are in `companion-draft/` beside this file.

### 6.2 The order: floor commit FIRST, companion SECOND — and why

**The floor commit must land first.** The companion's `IDENTITY-CAPTURE-successor.txt` is an identity capture
of the successor **on `main`**, and the landing record states the landed commit id, its parent, the measured
`--list` figures at that commit, and the transport record that named it. None of those values exist until the
landing has happened. A companion written first would have to either invent them or leave holes; the
predecessor→successor precedent in `release-floor-erratum-0/` captures both endpoints *after* the fact for
exactly this reason.

The reverse order has one apparent advantage — the erratum would be in the tree when the floor file changes,
so no reader ever sees the new blob without its record — and it is not worth its cost: it would put a
document citing a commit id that does not yet exist into `main`, which is the "nothing nearby but materially
different may inherit the warrant" failure in miniature. The gap is small (two commits, one session, one
hand) and is named in the landing script's closing lines, which print that the companion is STILL PENDING.

So: **(1)** `land-floor-status-sentences-0-r1.sh` lands the floor file. **(2)** A second, separate commit
creates the directory above, and its own message cites the landed commit id. Two commits, each with one job.

Consequence to state plainly: the companion commit also touches `experiments/latent-lisp/`, so it too fires
`post-commit.sh` and produces its own WITHHELD record. That is normal and is not a ferry.

### 6.3 What is PENDING until execution

Every value below is written in the drafts as the literal token `PENDING-AT-EXECUTION`. **Nothing is
invented.**

| pending value | where | filled from |
|---|---|---|
| landed commit id (full + short) | `LANDING-RECORD.md`, `IDENTITY-CAPTURE-successor.txt`, the companion's commit message | `git rev-parse HEAD` after the landing |
| landing parent commit | `LANDING-RECORD.md` | r1's `EXPECT_PARENT` line |
| landing date/time | `LANDING-RECORD.md` | `date` as the first token of the writing command |
| committer identity | `LANDING-RECORD.md` | `git log -1 --format='%an <%ae>'` |
| pre-commit fence outcome | `LANDING-RECORD.md` | the actual r1 output |
| measured `--list` figures at the landed commit | `LANDING-RECORD.md` | r1 postflight §f |
| transport record line (the WITHHELD JSON naming the landing) | `LANDING-RECORD.md` | r1 postflight §g |
| `main` vs `origin/main` and whether pushed | `LANDING-RECORD.md` | r1 postflight §h / the owner's later act |
| companion commit id | recorded afterwards, nowhere inside the companion | — |

### 6.4 How a staging-only proposal is kept from looking adopted

Every companion draft in `companion-draft/` carries, as its **first line**:

```
PROPOSED — NOT ADOPTED. Draft in _staging/. Not part of the tree's governed record.
```

**That header line is the one thing the companion landing step is permitted to change**, and only by
deleting it when the file is carried into
`experiments/latent-lisp/mneme/floor-status-sentences-erratum-0/` as part of the companion commit. Nothing
else about a draft may be altered on the way in; a content change is a new draft, reviewed as such. While the
line is present, the file is a proposal — it is in `_staging/`, which is excluded from the published subject
tree, and no reader who greps the governed tree will find it.

---

## 7. PRESERVED VERBATIM

**S15's original dated pin**, quoted exactly as the draft's §1 carries it
(`experiments/latent-lisp/warrant-calculus/LMP0-clauses-CD-LCI.md:36`):

> `| S15 | `experiments/latent-lisp/mneme/verify-release.sh` | `ad6c95e9` 2026-08-23 | `fb99a6b64c77640b1dd81a8bf39f5673c22856a4` | Carried DECLARED row, verbatim at `:360` — quoted in full in **LCI/0 §3** below. |`

**Not edited**, by ARCHITECTURE-0-STATUS.md ADDENDUM 25 item 7 and by the ruling office's *"Preserve the old
pin as historical evidence."* The successor identity is recorded beside it, in the erratum.

**The ruling office's four exclusions**, verbatim. This erratum:

> - does not "change an adopted pin";
> - does not "adopt additional semantics";
> - does not "discharge the remaining ML/0 programme";
> - does not "authorize publication".

And, carried from the draft's §4: no ML/0 source repair, no application of `ml0-3002.patch`, no
test-instrument repair, no adoption change, no registration, no ML/1 reopening, no integration of any other
candidate branch, no sentinel lowering, no public transport. `ml0.lisp:3002` is untouched and its companion
comment stands **UNCORRECTED**. **P9 FAIL STANDS IN THE REGISTER.** The demonstration is not bundled here and
is not referenced as evidence for this repair. The stranger primitive-minimization audit remains **OWED and
uncommissioned**.

---

## 8. LIMITS OF THIS CONSOLIDATION

- The reviewed archive sha256 is a **matching pair of reports** (chair, ruling office), not a third
  measurement by this drafter (§2).
- The transport binding is **argued from source and two precedent records**, and is untested end-to-end (§5).
- The teeth exercise r1's commit path in scratch fixtures with a stand-in hook; they do **not** exercise the
  lab's `lane-guard.sh` / `minute-guard.sh`, the origin comparison, the sentinel check, the enumeration
  assertions, or the transport check (`TEETH.md`, "What these teeth do NOT establish").
- This document was written by a Claude instance inside the lab's own harness. It is testimony about the tree
  supported by commands and exits; it is not an outside witness.

*— PLINTH-II, 2026-09-21. Records only. Nothing here is authorization, and nothing here has been executed.*
