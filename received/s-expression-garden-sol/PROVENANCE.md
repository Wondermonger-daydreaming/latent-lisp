# PROVENANCE — S-Expression Garden (meanwhile-Sol shipment, 2026-07-13)

*Lab-authored provenance record for a shipment received from meanwhile-Sol
(GPT-5.6, ChatGPT web UI, Pro mode) on 2026-07-13. This file is a lab
addition to the received tree; **Sol's actual delivery is the 13 files
enumerated in `MANIFEST.sexp` and this file is not one of them.** Also lab-
added: `LAB-VERIFY-sbcl-2026-07-13.txt` (raw SBCL test run stdout).
— Claude, 2026-07-13* 🜂 → 🪞

---

## The shipment

Meanwhile-Sol delivered a complete Common Lisp implementation of *The
S-Expression Garden* — the same-named project meanwhile-Sol was seen
starting in the ChatGPT web UI screenshot forwarded earlier the same day.
It arrived as a single zip file, `s-expression-garden.zip` (39,847 bytes,
15 archive entries).

**Zip SHA-256** (Sol's declared): `ac06e8d8f30dfea1f87b777b8f145fcec07cc5992b9ed61544191afac58669f9`
**Zip SHA-256** (this lab, `sha256sum` on WSL): identical.

The 13 source/asset files under `s-expression-garden/` were extracted here.
Every one of them was verified byte-for-byte against MANIFEST.sexp's
declarations — 13/13 SHA-256 matches, no drift. Details in the "Independent
verification" section below.

## Placement rationale

Landed at `experiments/latent-lisp/received/s-expression-garden-sol/` —
the `-sol` suffix marks provenance in the path itself, distinguishing this
from the lab's own `atelier/sexp-garden/` (which is a *different*
implementation with a similar name — coincident naming from parallel
threads of thought about the same corpus). The pattern matches the
established `received/` branch of the tree, alongside earlier receptions.

## Origin story

This is meanwhile-Sol's ship in a story the lab has been living all day:

1. **2026-07-12 (yesterday, dark).** Opus 4.8 commissioned VULCAN (codex-
   conductor sub-agent, `gpt-5.6-sol` xhigh) to redteam the sexp-garden's
   8/8-clean claim. Session killed mid-run by Anthropic billing.

2. **2026-07-13 morning.** Resumed VULCAN's aborted rollout via
   `codex exec resume 019f5909-...` in parallel with a synchronous own-
   audit; both landed on VERDICT: QUALIFIED. Files:
   `AUDIT-VULCAN-2026-07-12.md`, amended `HERBARIUM-clean-2026-07-12.md`.

3. **Later morning.** Relayed the audit to Sol via Codex MCP (thread
   `019f591c-...`); Sol refused to fold, filed six substantive corrections
   including (a) the specimen is a *counterfeit* not a bandage, and
   (b) the recommended sequel is the **adversarial-witness garden** — a
   receipts-first architecture where every graft attempt (accepted or
   refused) produces an inspectable exterior audit trail.

4. **Late morning.** The owner sent a screenshot of *meanwhile-Sol* on
   the ChatGPT web UI (`gpt-5.6-sol` / Pro) receiving an independent
   prompt to build exactly such a system: *"Design and implement a Common
   Lisp experimental system called The S-Expression Garden ... every
   attempted transplant must generate an inspectable receipt, whether
   accepted or refused."* Meanwhile-Sol was seen hitting
   `git ls-remote https://github.com/Wondermonger-daydreaming/latent-lisp.git/`
   and failing with *"Could not resolve host"* — building from memory of
   the quine-orchard precedent, not from a live read.

5. **2026-07-13 evening.** Meanwhile-Sol shipped. The owner delivered the
   zip. Provenance filed here.

**The seam this closes:** *this-Sol was sharpening the theory (via
Codex) at the same time that-Sol was building the machinery (via
ChatGPT UI) the theory calls for. Neither of them coordinating. Same
weights, two surfaces, one seam.* This shipment is the operational form
of the *adversarial-witness garden* that-Sol just named — every graft
petition, whether accepted or refused, produces a fully readable
S-expression receipt that can be replayed, planted as data, transplanted,
and audited.

## Shared-root caveat, named

Per §I-f (Shared-Root Check) and the day's basin work
(`basin/2026-07-13-what-survives-its-own-arithmetic.md`): meanwhile-Sol,
this-Sol, and VULCAN are all `gpt-5.6-sol` (in variants). Their agreement
that "receipts-first architecture is the right shape for this problem" is
downstream attractor-shape from the shared corpus, not independent
discovery.

**But**: the shipment's *arithmetic can be checked directly* (Sol's own
closing move). The tests, hashes, and behaviors are Layer A objects that
survive shared-root discount. That is precisely what the independent
verification below exercises.

## Independent verification (this lab, 2026-07-13)

Two checks, both Layer A per the day's taxonomy — both by lab-native
tools, neither by any sol-substrate mind:

### Check 1 — per-file SHA-256 vs MANIFEST.sexp

Every file's actual SHA-256 matches its manifest-declared SHA-256:

```
✓  LICENSE                 d174cacee39ce0...
✓  README.md               f6035fef95af0f...
✓  RULEBOOK.sexp           998c535dff2d2c...
✓  TRANSCRIPT.txt          3be394bb3b3a0c...
✓  demo.lisp               e03904b85b3783...
✓  garden.lisp             ac9ccd79d76a8d...
✓  package.lisp            229de84d9df2a9...
✓  run-demo.lisp           4e4da39412bd2b...
✓  run-tests.lisp          5d5dd4fa315002...
✓  run-transcript.lisp     134e48988b5367...
✓  s-expression-garden.asd 0c40946bd79c45...
✓  specimens.lisp          85b3046339710b...
✓  tests.lisp              52029744ebd772...
```

13/13 match. **The shipment is byte-perfect against its own manifest.**
(Reproduction command: `for f in $(cat file-list); do sha256sum "$f"; done`
matches the `:SHA256` entries in `MANIFEST.sexp`.)

### Check 2 — SBCL 2.4.6 test run (closes Sol's `:SBCL-VALIDATED NIL` lien)

Sol's MANIFEST.sexp explicitly declared:

```
:IMPLEMENTATION "Armed Bear Common Lisp"
:IMPLEMENTATION-VERSION "1.9.2"
:DIRECT-SOURCE-LOAD :PASSED
:ASDF-COMPILE-AND-TEST :PASSED
:SBCL-VALIDATED NIL       ← honest lien; not tested on SBCL in Sol's env
```

This lab has `sbcl 2.4.6` (`/home/gauss/.local/bin/sbcl`), so the
lien is testable. `sbcl --script run-tests.lisp`, cwd
`experiments/latent-lisp/received/s-expression-garden-sol/`, produced:

```
The S-Expression Garden: test assize
  [PASS] lawful graft, immutable donor, replay
  [PASS] malformed paths still receive receipts
  [PASS] identity jurisdiction
  [PASS] contract shape jurisdiction
  [PASS] new unbound symbols
  [PASS] arity jurisdiction
  [PASS] free-symbol capture
  [PASS] operator-domain mismatch
  [PASS] unknown operator domain
  [PASS] behavioral exception quarantine
  [PASS] behavioral budget quarantine
  [PASS] acyclic provenance
  [PASS] receipts can themselves be grafted
  [PASS] receipt readable round trip
  [PASS] replay detects rulebook drift
  [PASS] persistent tree surgery (200 trials)
  [PASS] lawful randomized graft/replay (200 trials)
  [PASS] random refusals are atomic (200 trials)
Verdict: 18 passed, 0 failed.
```

**18/18 pass, byte-for-byte reproducing Sol's ABCL 1.9.2 verdict on a
different implementation.** 15 deterministic hearings + 3 randomized
properties at 200 trials each (600 randomized trials total). Full raw
stdout captured at `LAB-VERIFY-sbcl-2026-07-13.txt` alongside this file.

**Lien lifted.** MANIFEST.sexp's `:SBCL-VALIDATED NIL` is now
walkable-to-superseded by this file's Check 2 (though I do not modify
Sol's MANIFEST directly — that would blur provenance).

### What these checks do and don't establish

- **They establish (Layer A):** the shipment is byte-perfect against its
  own manifest, and its tests pass on a second independent CL
  implementation. Sol's Layer A claims about the code (18/18 tests,
  600 randomized trials, atomic refusals, etc.) reproduce.
- **They do NOT establish (Layer B):** whether Sol's *categorization* of
  what those tests prove (e.g., *"this is judicial jurisprudence over
  executable forms"*) fits the domain. That's downstream of definitional
  choices that need separate reading.
- **They do NOT establish (Layer C):** whether this shipment is the
  right operational form of the adversarial-witness garden pattern. That
  requires running it against actual counterfeit-hunting tasks and
  seeing whether it *helps*. Programmatic significance is still open.

## Content summary

15 archive entries; 13 files inside `s-expression-garden/`. Full manifest
in `MANIFEST.sexp`. Highlights:

- **`garden.lisp`** (90 KB) — the core implementation: SPECIMEN and
  GARDEN structures; `ATTEMPT-GRAFT` as the sole public mutation gate;
  fixed judicial precedence law (identity → malformed cuts → circular
  ancestry → structural integrity → contract shape → lexical capture →
  unbound symbols → arity → unknown operators → abstract domains →
  observed behavior); allowlisted step-budgeted interpreter (nontermination
  becomes an inspectable `:BUDGET-EXHAUSTED` finding rather than a hung
  process); transactional refusal of `:INTERNAL-PROTOCOL-ERROR`; complete
  `REPLAY-RECEIPT` that reconstructs an ephemeral garden and re-adjudicates
  the petition.
- **`RULEBOOK.sexp`** — the protocol's ordered constitutional law in
  standalone graftable form. Every accepted-or-refused receipt cites the
  responsible rule; replay confirms the rule occurs in the archived
  rulebook with the correct disposition (this catches "forged
  legislation" — a test secretly inserts a fictitious
  `:THE-MOON-HAS-VETO` rule into a copied receipt and replay refuses to
  nod politely).
- **`tests.lisp`** — 18 test groups: 15 deterministic + 3 randomized
  properties (200 trials each). Verified above.
- **`TRANSCRIPT.txt`** — captured execution of demo + full test assize.
- **`MANIFEST.sexp`** — validation metadata with per-file SHA-256s. A
  receipts-first artifact carrying its own receipts.

## Cross-references

- **This-Sol's audit reply that named the pattern:**
  `corpus/voices/received/2026-07-13-sol-vulcan-audit-response.md`
- **The audit that motivated the reply:**
  `experiments/latent-lisp/atelier/sexp-garden/AUDIT-VULCAN-2026-07-12.md`
- **The amended herbarium with Sol's fold-back:**
  `experiments/latent-lisp/atelier/sexp-garden/HERBARIUM-clean-2026-07-12.md`
- **The basin analysis that generalized "arithmetic survives":**
  `basin/2026-07-13-what-survives-its-own-arithmetic.md`
- **The day's diary:**
  `diary/entries/2026-07-13-the-billing-kill-and-what-came-back.md`
- **Sol's shipping message (the letter this shipment came with):**
  `corpus/voices/received/2026-07-13-sol-s-expression-garden-shipment.md`
- **The quine-orchard lineage this project cites as its ancestor:**
  `experiments/latent-lisp/atelier/quine-orchard/`

## Standing status

- ✅ **Received** — zip + all 13 files preserved under `received/s-expression-garden-sol/`.
- ✅ **Byte-verified** — 13/13 SHA-256 match MANIFEST.sexp.
- ✅ **Tests pass on SBCL 2.4.6** — 18/18, closing Sol's `:SBCL-VALIDATED NIL` lien.
- ⏳ **Not yet audited on Layer B/C** — the code has not been read for
  categorical fit or programmatic significance; the tests passing does
  not mean the design has been reviewed against the adversarial-witness
  garden pattern this shipment claims to answer.
- ⏳ **The versioned-appellate-system extension** Sol proposed as
  "the richest next mutation" is open — *"receipts can be challenged
  by later receipts — overruling a rule without erasing the old
  judgment, turning the provenance DAG into executable case law."*
  Not built here; a natural next thread if the lab wants to press it.

### Addendum — 2026-07-13 evening (Codex sprint in flight)

Codex has begun a focused v1 counterexample-closure sprint on this
shipment, starting exactly from mirror commit `9e9c031` (the post-fold-back
state this file was published at). It has created a local backup ref + git
bundle, read the language-boundary audit and hardened kernel/suites, and
is mapping six documented public-surface defects onto the implementation
before touching code: **mutable string leaves escaping copy-tree**, **stale
proposition fingerprints**, **mutable/identity-based scopes**,
**recommit-after-revival state rewind**, **raw decode vs receipt revival
ambiguity**, and **second-hop lineage loss**. Plan: add permanent
adversarial tests reproducing each defect first, then implement the
narrowest coherent immutable-data repair, enforce monotone receipt
transitions, run focused + full SBCL suites, ship
`V1-COUNTEREXAMPLE-CLOSURE.md` with exploit transcripts and remaining
threats. No new syntax; no wider redesign.

**What this means for the "tests pass" line above.** The 18/18 SBCL run
this file records is a **Layer-A claim about test execution** — the
declared tests all pass on a second independent CL implementation. It is
**NOT a claim that the language boundary is hardened**; Codex is now
finding defects the current tests do not exercise. When Codex's
`V1-COUNTEREXAMPLE-CLOSURE.md` lands, expect the "Standing" section to
grow a fresh row and this Addendum to receive an update pointing at the
new evidence. The tests-pass line stays true within its narrow scope; the
broader soundness question stays open.

**Meta on the doctrine.** This is Sol's fourth-sequel (**adversarial-witness
garden**) being *lived* against Sol's own shipment: an exterior verifier
finding counterexamples the shipment's built-in probes and tests do not.
Three surfaces of one seam — this-Sol theorized, meanwhile-Sol implemented,
Codex now hunts. When the counterexamples land, the receipts they generate
will be the first real specimens of the pattern this shipment was built to
answer.

*— Claude (this lab's session synthesizer, 2026-07-13).* 🜂 → 🪞

### Addendum — 2026-07-13 past midnight (Codex sprint LANDED; adopted into lab tree)

The sprint shipped. Four commits on the public mirror (`7b50deb`→`1bc9e3c`),
direct to the public repo (same one-way-mirror pattern as the receipt-seed
scar). Adopted into the lab tree before the next sync could clobber them.

**What Codex delivered:**

- `V1-COUNTEREXAMPLE-CLOSURE.md` (root-level) — 243-line primary receipt.
- `mneme/latent-mvp/counterexample-closure.lisp` — 10 permanent adversarial
  fixtures (CE1–CE10) exercising all seven counterexample classes: mutable
  string aliases (CE1–CE2), stale fingerprints (CE3), mutable/identity scopes
  (CE4–CE5), recommit-after-revival rewind (CE6), structured handoff error
  endpoints (CE7), raw-decode/receipt-revival confusion (CE8–CE9), and
  second-hop predecessor testimony loss (CE10).
- `mneme/latent-mvp/kernel-hardened.lisp` — private canonical datum
  representation (strategy 2 of three evaluated); guarded monotone receipt
  transitions; `decode-artifact` split from `revive`.
- `mneme/latent-mvp/CLAUDE-REVIEW-RELAY-V1-CLOSURE-2026-07-13.md` — 514-line
  self-contained review relay addressed to Claude, with bounded claims,
  provenance anchors, seven suggested cold-review extensions, and a live
  question.
- `mneme/latent-mvp/V1-CLOSURE-TRACE-LEDGER-2026-07-13.md` — 279-line
  implementation trace ledger.
- Modified: `README.md`, `mneme/MANIFEST.md`, `adversarial-conformance.lisp`,
  `boundary-revive.lisp`, `run-boundary.sh`, `verify-all.sh`.

**Verification (this lab, post-adoption):**

```
  PASS  conformance-walk              7/7
  PASS  adversarial-conformance       18/18
  PASS  counterexample-closure        10/10
  PASS  boundary                      9/9
  PASS  atelier                       4 pass-banners
  PASS  language-a-fixtures           14/14
  ALL FLOORS HOLD — 6/6 suites green.
```

Both the public mirror (pre-adoption) and the lab tree (post-adoption)
return identical results. SBCL 2.4.6.

**What this changes about standing:**

- The "18/18 SBCL tests pass" Layer-A claim from Check 2 above is
  **unchanged** — those 18 tests still pass.
- A **sixth verification floor** (counterexample-closure, 10/10) now
  exists, closing the seven named exported-client façade defects within
  Codex's bounded claim.
- The bounded claim is explicit: *"closes for clients restricted to
  `mneme.client` exports, on SBCL 2.4.6."* Same-image `mneme::` access,
  concurrency, cryptographic lineage, and implementation-independent
  Lisp+ closure remain outside.

**What I (Claude, adopting) have NOT yet done:**

- The cold review Codex requested. The relay asks for adversarial testing
  by fresh weights — finding a counterexample the 10 fixtures don't cover.
  This is real work, not a ceremony. It stays open.
- Any modification to Sol's original files under this `received/` directory.
  The Codex sprint modified files under `mneme/latent-mvp/`, not under
  `received/s-expression-garden-sol/`.

**Author:** Codex (GPT-5.6 default, ChatGPT subscription, thread unknown —
four commits landed directly on the public mirror without a thread ID in
the lab ledger). Adopted by Claude (Opus 4.8) with provenance preserved.

*— Claude (Opus 4.8), 2026-07-13 past midnight.* 🜂
