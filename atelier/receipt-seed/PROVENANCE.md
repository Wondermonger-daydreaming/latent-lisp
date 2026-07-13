# Provenance — The Receipt-Bearing Seed

**Author:** Codex (OpenAI, via ChatGPT), working in **Codex-Lab**
(`/home/gauss/Codex-Lab`, the owner's companion lab).
**Original commit:** Codex-Lab `42a74ff` "Plant receipt-bearing seed" (2026-07-12).
**Read to build it:** the public `latent-lisp` mirror at commit `87bbfec` — specifically
`atelier/quine-orchard` (executable textual lineages) and `atelier/sexp-garden` (preorder
subtree surgery + the insistence that an *operation* carry a receipt). The graft between
those two practices is Codex's own; the little law it plants —
*"a descendant may inherit a method of becoming without inheriting the name of what it was
before"* — is Codex's own sentence.

## Why this copy exists here

The owner committed Codex's seed directly to the shared `latent-lisp` repo
(`99695cf` "Receive receipt-bearing seed", 2026-07-12 23:33 UTC). Two minutes later the
lab's **one-way mirror** (`tools/latent-lisp/sync.sh`, `rsync -a --delete` from
`experiments/latent-lisp/` → the public repo) auto-fired on an unrelated lab commit and
**deleted the seed** — because it was not in the lab's canonical tree, and the mirror
prunes anything it doesn't find at the source. Every subsequent sync kept it gone.

**The fix (owner-ruled, 2026-07-12):** adopt the seed into the canonical lab tree here, so
the mirror *publishes* it instead of eating it. Attribution kept in full: Codex is the
author; the lab is only the custodian that gives it a home the automation won't clobber.

## Standing workflow note (so this doesn't recur)

The public `latent-lisp` mirror is **one-way and destructive** (`lab → public`, with
`--delete`). **Direct commits to the public repo do not survive** — the next lab sync
prunes anything absent from `experiments/latent-lisp/`. So: anything meant to live in the
public gallery must land in the **lab tree** (`experiments/latent-lisp/…`) and reach the
public repo *through* a lab commit. A future Codex (or any hand) contributing to the
gallery: hand the files to the lab tree, not to the public repo directly.

## Verified in place

Re-grown and independently verified from this location on adoption:
`sbcl --script nursery.lisp && sbcl --script verify.lisp` → **35 checks pass**, deterministic.
The verifier grows four descendants in isolated subprocesses, replays every graft with its
*own* `replay-graft` (not the seed's), confirms the program body stays structurally fixed,
and names its own limits: *descent-is-not-identity, replay-is-not-authorship,
queued-grafts-are-preselected-not-evolved.*

*A reception of this seed — and the striking same-day convergence with the orchard's
integrity quine and the day's carried-vs-regenerated basin — is filed at
`corpus/voices/received/2026-07-12-codex-receipt-bearing-seed.md` in the lab repo.*
