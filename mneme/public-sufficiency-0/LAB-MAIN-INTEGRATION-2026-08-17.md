# LAB-MAIN INTEGRATION — STAGED ACTS, EXECUTED (2026-08-17)

**Lab `main` fast-forwarded `4bfc5278 → df23cdd0` (338 commits) and pushed to the LAB
remote only, under owner authorization, with SYNC-PAUSED raised throughout and still
raised. NO mirror transport occurred, NO publication act, NO PUBLISHED standing, NO
credential/ruleset change, NO sentinel lift. TD-6 and TD-9 remain OPEN. TD-7's
first-real-transport readback duty remains FUTURE and unsatisfied. One machinery
finding is REPORTED (not docketed — the owner's call): the post-merge path-gate tests
only the tip commit, so the fast-forward produced zero machinery events despite making
128 covered commits main-ancestral.**

## 1. The owner's sequencing directive (verbatim, the act's frame)

> Fire the prepared §4 fork as written.
>
> My choices are:
>
> 1. **Sequencing: staged forks.**
> 2. **Merge form: `--ff-only`.**
>
> Do not treat this message as blanket merge authorization. Return the first required
> Channel Policy /1 §8.1 adoption fork for decision, then the exact
> integration-authorization fork against the resulting pinned tip. Keep `SYNC-PAUSED`
> continuously raised; preserve TD-6 and TD-9 as OPEN; perform no public-mirror
> transport, publication act, credential/ruleset change, or sentinel lifting.
>
> At execution, the fast-forward must be conditioned on the accepted successor-9 tools
> tree remaining byte-identical, all intervening commits being classified, installed
> hooks verifying, and `main` still being an ancestor of the authorized tip. Return the
> post-merge WITHHELD machinery evidence separately from TD-7's still-future
> first-real-transport readback.

This discharged the §4 fork of `notes/2026-08-17-lab-main-integration-prep.md` by the
owner's own written word (staged · `--ff-only`); the interview was not re-fired for
questions already answered.

## 2. Staged act 1 — CP/1 §8.1 adoption

Presented and adopted; its own instrument is authoritative:
`CHANNEL-POLICY-1-ADOPTION-2026-08-17.md`, commit `df08fd8d`. Policy identity
`latent-lisp-public-mirror`, blob `180734f6` verified byte-identical to the accepted
bytes at presentation time. Prospective only; no authorization of any artifact; R-3 ·
R-8 · R-2b open.

## 3. Staged act 2 — integration authorization (pinned tip)

Cargo classified per the owner's condition: CENSOR census
(`_staging/main-ff-cargo-census-2026-08-17.md`, committed `df23cdd0`) — 336 commits,
11 categories, reconciliation exact, zero residue, anomaly sweep clean, **zero commits
touching `tools/latent-lisp/` after the accepted `214c2c90`** (clean for the strongest
reason: nothing touched the path) — plus 2 chair-classified commits (`df08fd8d` PS/0
adoption instrument · `df23cdd0` guild-ledger) = 338. The authorization fork was
presented pinned to tip `df23cdd0`; the owner selected, verbatim:

> **Authorize incl. lab push** — Execute `git merge --ff-only df23cdd0` on main, then
> `git push origin main` — the LAB remote (Claude-Code-Lab) only, never the mirror.
> Lab main and origin/main land byte-identically on the verified tip.

## 4. Execution (2026-08-17 ~19:56Z) — conditions re-verified immediately before, all ✓

```
tip pinned: df23cdd0 ✓            tracked tree clean ✓
accepted tools tree byte-identical (214c2c90..df23cdd0 -- tools/latent-lisp/ empty) ✓
hooks byte-exact (cmp vs printf template; post-commit 93B, post-merge 92B) ✓
hooksPath unset ✓                 main ancestor of tip ✓
sentinel RAISED ✓
git checkout main → git merge --ff-only df23cdd0 → git push origin main
To https://github.com/Wondermonger-daydreaming/Claude-Code-Lab.git
   4bfc5278..df23cdd0  main -> main
post-state: HEAD = main = origin/main = df23cdd0
```

The push target is the **lab** repository. The public mirror
(`github.com/Wondermonger-daydreaming/latent-lisp`) was not written, fetched, or
touched; it is reachable only through `sync.sh`, which is sentinel-paused.

## 5. Post-merge machinery evidence — THREE CLASSES, kept separate (owner's instruction)

**(a) The merge itself produced ZERO machinery events — and the mechanism is exhibited,
not guessed.** No new `.sync.log` entry, no supervisor process, record ref ABSENT at
merge+2min. Cause, read from `tools/latent-lisp/post-merge.sh:23–24` and reproduced
with the hook's own test: the launch gate is
`git diff-tree -m --no-commit-id --name-only -r HEAD | grep -q '^experiments/latent-lisp/'`
— it inspects **only the tip commit**. After a fast-forward, HEAD = `df23cdd0` (a
ledger commit): the test returns 0 matches. Run against `5c50fa99` (an in-range PS/0
instrument commit): 2 matches. Commits in the merged range touching the covered tree:
**128**. So a fast-forward whose tip happens not to touch the covered tree makes the
whole range main-ancestral **silently** — no launch, no log line, no WITHHELD record.
**The prep document's §1/§3 prediction ("the merge will fire post-merge → WITHHELD
entries") was WRONG** and is corrected here; the prediction assumed the gate tested the
range, not the tip.

**REPORTED FINDING (not docketed; the owner may docket it, e.g. as a TD-10 candidate):
the post-merge path-gate is tip-only, so range-integration is invisible to the
transport machinery.** Consequence while it stands: after any future sentinel lift, no
transport fires for this integration until a later commit touches the covered tree on
`main` — or `sync.sh` is run deliberately. Same class as TD-8's which-commit race
(a merge-path blind spot), but in the launch gate rather than the commit argument.
Nothing is repaired by this report; repair would be new tooling work under its own
authorization.

**(b) First genuine WITHHELD evidence — produced by THIS instrument's commit, not by
the merge.** This file lives in the covered tree and is committed on `main`, so the
post-commit hook's gate is genuinely true for it: supervisor launches → `sync.sh` sees
`SYNC-PAUSED` → transport lawfully WITHHELD and recorded. That record (appended to this
file's §7 after observation, or read back in-session) is machinery evidence of the
harvest path firing live under the sentinel — **and it is NOT the TD-7 readback**.

**(c) TD-7's first-real-transport readback: FUTURE, UNSATISFIED, UNTOUCHED.** The
binding duty (closure act `5c50fa99`) binds to the first *actual* transport after an
owner-gated sentinel lift. Nothing tonight advances, satisfies, or weakens it.

## 6. Standing after this act (complete negative space)

- Lab `main` = lab `origin/main` = `df23cdd0`. The latent-lisp subject tree is now
  main-ancestral — which satisfies the *main-ancestry entry* component of CP/1 §1's
  PUBLISHED conjunction for those bytes, **and confers no PUBLISHED standing**:
  publication authorization has not been granted for any artifact (blanket option still
  reserved, §8.6), no transport occurred, and R-2b's receipt standard is unruled.
- **SYNC-PAUSED: RAISED, continuously, since 19:33Z.** Lifting is a separate owner act.
- **TD-6 OPEN** (no credential/ruleset action) · **TD-9 OPEN** (record ref: zero events
  at merge time; off-host durability unreached; four-step criterion untouched).
- **CP/1 ADOPTED and operative (prospective)**; adoption ≠ authorization.
- Next in the PS/0 order: authorization act(s) (blanket option reserved) → sentinel
  lift + verified transport + R-2b receipt (carrying the TD-7 first-fire readback) →
  PS/0 far-side readback. The reported tip-only-gate finding sits before or beside the
  lift, at the owner's discretion.

## 7. Observed WITHHELD record (appended post-commit, same sitting)

The commit of this instrument (`a7a94be6`, on `main`, touching the covered tree) fired
the post-commit path genuinely — **the first live firing of the TD-7 harvest machinery
in its history**, and the first event ever written to
`refs/latent-lisp/transport-record`:

```
event  : WITHHELD
source : a7a94be6ef81ea6e1cb676cab7e21dd929b5ef7d (SOURCE-COMMIT-PRESENT; commit SUCCEEDED)
attempted : https://github.com/Wondermonger-daydreaming/latent-lisp.git#refs/heads/main
exit   : 0     reason : paused by sentinel tools/latent-lisp/SYNC-PAUSED
utc    : 2026-08-17T19:57:44Z   tool : sync.sh   run: 20260817T195744Z-2221420-2770521941
record ref now EXISTS: 901f584e (1 event)
supervisor log: "sync exit=0 — harvest complete"
```

`transport-status.sh`'s own gloss, kept: *"WITHHELD — a policy gate deliberately
refused transport. Withholding is not failure, and it is not a silent success either."*

Evidential caps on this event: it proves the launch→supervisor→sync→record chain fires
live and the sentinel is honored — **it is NOT a transport, NOT the TD-7
first-real-transport readback (still future), and it does not touch TD-9** (the record
ref now exists locally with one event and has still never crossed to any remote —
TD-9's off-host durability criterion remains fully unmet).

*— recorded by the chair, Claude Fable 5 (1M context), 2026-08-17, at the owner's word.*
