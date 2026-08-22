# CHANNEL TOOLING REPAIR /2 — SUCCESSOR-2 RETURN (2026-08-18)

**CANDIDATE ONLY. Nothing here is accepted, closed, or independently verified.
TD-10 and TD-11 remain OPEN and continue to block `SYNC-PAUSED` removal, public-mirror
transport execution, and reliance on post-merge automatic transport. Every hand in
this return — builder (FERRARIUS-TR2, rounds 6–7), adversary (QUAESTOR-TR2, round 6),
and the chair — is same-root; the STRANGER AUDIT IS OWED. This parcel exists for
Sol's THIRD cold seat. Acceptance, TD closure, and sentinel lift are owner acts, all
still ahead.**

## What is returned

The TR/2 candidate, resubmitted after the second cold seat blocked it **narrowly,
with credit preserved** (SOL-TR2-01 and SOL-TR2-02 ruled CURED by the cold seat's own
replay; SOL-TR2-03 the sole blocker). This return covers successor-2's two build
rounds and one adversarial round against the disposition's seven requirements, plus
one owner ruling disposing the adversary's finding.

## The seven requirements, item by item

| # | Requirement | Disposition |
|---|---|---|
| 1 | Preserve the SOL-TR2-01 classifier cures and the self-rooted bundle cure unchanged | `post-merge.sh` / `post-commit.sh` byte-untouched all rounds (git diff empty at every hand); the bundle cure is re-executed as this parcel's own build (below) |
| 2 | Preserve `--checksum` + content-identity verification | `sync.sh` untouched in round 7; round 6 changed comments only — verified by the adversary's own heredoc-and-quote-aware scanner: **244 code lines byte-identical** pre/post, and by a full raw-diff read |
| 3 | Append-only correction: whole-commit vs `<commit>:<subdir>` tree-archive timestamps | Corrected in `sync.sh` comments and the teeth; §R6 appended to the build report with the wrong round-5 sentence quoted before replacement; round-7 amendment banners additive-only (**diff shows 0 deleted lines**: 413 and 398 added); the true mechanism is re-derived **inside the harness on every run** as five permanent assertions (teeth-checked: shown able to bleed), closing with a check that production actually uses the subtree form |
| 4 | Replace Q4-F1's tooth with one observing the actual rsync boundary | The tooth now measures the destination as left by transport 1 vs the source materialized for transport 2, and declares the collision precondition **only** when `(size,mtime)` are equal AND bytes differ — measured before declaring, retry-until-observed, never proceeding unverified. The adversary confirmed the boundary independently by **watching `sync.sh`'s own materialization directory live during transport 2** (retiring the builder's window-inference void by measurement), and at nanosecond resolution (both sides carry `.000000000` — tar stores whole seconds — so ns equality is decisive; round 7 added this read to the tooth itself, +2 assertions) |
| 5 | Against the accepted blob, prove stale mirror + false no-op + durable false `TRANSPORT-OK`; deterministic or STOP for the owner fork | **All three facts observed against the hash-verified accepted blob** (`00813082…`, content sha256 `7183f8a6…`), by the builder AND by the adversary in an independent harness sharing no code with the teeth — no shim, no subject edit, no clock manipulation; timing control only (second-boundary scheduling + self-checking retry). **Verdict, at headline volume: DETERMINISTIC ON AN IDLE HOST — 26/26 builder, 10/10 adversary, zero discards — and SYSTEMATICALLY NON-ESTABLISHABLE UNDER LOAD** (24-way load: 80/80 attempts discarded at the prescribed budget over 6m12s; dominant discard reasons are host-speed facts no budget cures). **The tooth refuses rather than guesses in both climates** — under load it fails loudly (366/2, exit 1) with a preflight probe that names the host-speed diagnosis in seconds. The exhausted-budget outcome remains a loud FAIL by design (a SKIP conversion would recreate SOL-TR2-03's own charge; the refusal is written into the code's comment). **Discharge question, presented per the disposition's own fork clause:** the owner ruled *requalify + seal* — the RED proof is offered as idle-host-deterministic with the load measurements disclosed verbatim (§QUAESTOR F1 below); whether this discharges requirement 5, or whether the fork's other arms (amend the requirement / controlled-clock arm) are due, **is put to the cold seat, not answered for it** |
| 6 | Root-inapplicable permission plants become explicit SKIPs | Three-state semantics: idle non-root **381/0/0 exit 0**; simulated-root (`unshare -r`) **375/0/6 exit 0**, SKIP count printed in the summary line; availability established by **attempting the read the plant needs refused** — never `id -u`. The adversary's plant P4 (a non-permission failure in the probed path) proved **a SKIP cannot mask a FAIL** (skips collapsed 6→1, three assertions bled, exit 1). Bonus catch, builder's own: the OLD suite carried a false PASS under root ("runs THROUGH the pause gate", matching exit code only) — now measured by observation |
| 7 | Re-run, seal a new self-rooted zero-prerequisite parcel, return it cold | This document and the parcel it fronts |

## Verification of record (whose hands, exact counts)

Suite series across TR/2: 106 → 195 → 268 → 322 → 373 → 379 → **381** (2706 lines);
grown or visibly corrected, never silently shrunk.

| Hand | Round | teeth-td10.sh (idle) | root-sim | accepted suite |
|---|---|---|---|---|
| FERRARIUS (builder) | 6 | **379/0/0 ×2**, exit 0 | **373/0/6**, exit 0 | **680/0** |
| QUAESTOR (adversary) | 6 | **379/0/0 ×3**, exit 0 | **373/0/6**, exit 0 | **680/0** |
| QUAESTOR (adversary) | 6, 24-way load | 366/**2**/0, **exit 1** (honest refusal; ×2 incl. budget-40) | — | — |
| FERRARIUS (builder) | 7 | **381/0/0 ×2**, exit 0 | **375/0/6**, exit 0 | **680/0** |
| FERRARIUS (builder) | 7, load demo | 366/**2**/0, **exit 1** — preflight named the diagnosis first | — | — |
| Chair (this document) | seal | **381/0/0 ×2**, exit 0 | — | **680/0** |

`install-hook.sh --verify` HOOKS GREEN at every hand. Sentinel
`9b741ed1ac721dca31d9cc935eabda2e684e8d540039c19412dbeec3d216419b`, mtime epoch
`1786995178` — identical at every hand's start and end; never touched. Preserve set
(`teeth-td6-td9.sh` · `transport-record.sh` · `transport-supervisor.sh` ·
`post-merge.sh` · `post-commit.sh`) byte-untouched at every hand; `sync.sh` untouched
since its round-6 comments-only edit (`3f2ceede…`). Subject hashes at the seal:
`teeth-td10.sh` `00d2c2ac…` · `sync.sh` `3f2ceede…` · `teeth-td6-td9.sh`
`dd93547f…` (= accepted blob).

## QUAESTOR round 6 (the internal adversarial audit — `reports/tr2-quaestor-round6.md`)

Verdict **SEALABLE-AS-CANDIDATE** with findings against the round-6 *account*, not
the cures. He could not kill claims A–D or F: the item-5 triple reproduced in his own
independent harness; the boundary confirmed by watching the live materialization
directory; comments-only verified by his own scanner; append-only verified at byte
granularity. Plants **5/5 bled**, including the SKIP-cannot-mask-FAIL case.

- **F1 (MEDIUM-HIGH, disposed by owner ruling + round 7):** "PROVEN-DETERMINISTIC"
  was an idle-host property stated at headline volume with the host-relativity only
  in a void note — *"the disclaimer and the verdict are not at the same volume, and a
  cold seat reads the verdict."* His measurements, verbatim in his report: 24-way
  load ⇒ 20/20 discards; at `Q4F1_MAX_ATTEMPTS=40` ⇒ **80/80 discards, 6m12.2s,
  still 366/2 exit 1**; failure systematic ("transport 1 took 1s+" / "straddled a
  second boundary"), so no budget cures it. Round 7 requalified the verdict at
  headline volume, replaced the budget remedy with the host-speed diagnostic, and
  added the preflight probe (demonstrated under load: named the diagnosis *before*
  the attempt loop, predicting exactly the discard reasons the loop then printed).
- **F2 (LOW, cured round 7):** the "unchanged across transport 2" check was
  whole-second; the ns-equality read (decisive, since tar stores whole seconds) is
  now in the tooth (+2 assertions).
- **F3 (informational, cured round 7):** the tooth-count label now matches the
  printed transcript (block = 35).

## Honest voids (carried, not converted, for the cold seat)

1. **The idle-host condition on the item-5 RED proof** — stated at headline volume
   above; the discharge question is the cold seat's (requirement-5 fork clause).
2. **One machine, one git, one kernel** (QUAESTOR): every measurement here is git
   2.43.0 on one WSL2 host; Sol measured the SOL-TR2-03 premise on 2.51.1 and the
   in-harness assertions re-derive it per-run, but the boundary timings are
   single-host facts.
3. QUAESTOR's remaining named voids (his report §HONEST VOIDS, nine items) and the
   builder's residual voids 5–7 (`|| echo` commit-ish fallback; stale work clone ⇒
   wrong parent right tree) stand un-attacked and un-cured.
4. The round-5 consolidated void list (§11 of `reports/tr2-quaestor-round5.md`)
   carries forward where not superseded: `ORIG_HEAD` freshness unproven;
   **`transport-record.sh` never attacked by anyone in seven rounds — the largest
   unexamined surface in the channel and both hands' dig-next**; root-commit door
   (Q2-F1) uncured; hook/script-level plant reproduction; mirror drift nobody's
   office; the content pipeline floored, not finished.
5. **Everything is same-root.** Builder, adversary, chair: one model line. The
   stranger has found something on every look; nothing here predicts otherwise.

## Chain

TR/2 commission `7086947a` → rounds 1–2 → cold seat 1 BLOCKED (SOL-TR2-01/02) →
successor-1, rounds 3–5 → sealed parcel `d27f4e1d…` → **cold seat 2 BLOCKED narrowly
(SOL-TR2-03; 01/02 CURED, credit preserved)** → successor-2 commission → round 6
(items 3–6; checkpoint `f52bdfff`, evidence `3f59c86a`) → QUAESTOR round 6
(SEALABLE + F1/F2/F3) → owner ruling (requalify + seal; fold F2/F3) → round 7
(requalification + preflight + ns-read) → chair hands → this return. No predecessor
document is rewritten; every correction is additive and banner-marked.

## The parcel (SOL-TR2-02 compliance, re-executed)

`~/Downloads/tr2-successor2-2026-08-18.tar.gz` + `.sha256` sidecar (outer hash in the
sidecar and the session readback — never inside the parcel). Contents: this return as
README-FIRST · instruments/ (both TR/2 commissions, successor-1 and successor-2
commissions, scope extensions 1–3, TD docket, both Sol dispositions verbatim) ·
reports/ (build report rounds 1–7, QUAESTOR rounds 1–6, FERRARIUS round-6/7 report) ·
subject/ (the ten `tools/latent-lisp` files, flat copies) · a **self-rooted
zero-prerequisite bundle** of the filtered lab lineage with lab→parcel mapping (equal
counts asserted; lab log drawn from the lab repo) · the chair's **empty-repo walk
transcript** (bundle verified from inside an empty initialized repository, exit
captured directly; cold clone; ten files byte-compared) · MANIFEST.sha256 (per-file,
never including its own hash; `sha256sum -c` verified from a cold extract, bundle
re-verified from inside a repo there).

*— recorded by the chair, Claude Fable 5 (1M context), 2026-08-18. Same-root
throughout; the teeth are green on an idle host, honest under load, and the stranger
has not yet looked a third time.*
