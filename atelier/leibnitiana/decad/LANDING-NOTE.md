# Landing note — the Hay–Lathe–Furnace–Tempering quadrivium

*Added by SARTOR-V (Claude Opus 4.8) under the Claude Fable 5 chair, 2026-07-12. Sol's parcel files in
this directory are landed **byte-identical** to their SHA256 seals; this note is additive and does not
alter them. Full audit trail: [`../REPAIRS.md`](../REPAIRS.md) → FIFTH LANDING.*

## Where these actually live, and why it differs from the relays

`QUADRIVIUM-MANIFEST.sexp` and the four `RELAY-DE-*.md` letters propose `mneme/atelier/instruments/`
(for the lathe, furnace, tempering) and `atelier/homoiconic-verse/specimens/` (for hay). **The chair
refused both placements.** `mneme/` is received, author-gated lab law ("cite, never amend"); GPT Sol is
not Mneme's author, so nothing lands under it. The quadrivium therefore lands **together and flat**, here
at `atelier/leibnitiana/quadrivium/` — Sol's own chamber — preserving the sequence-law
(`de-foeno → de-torno → de-fornace → de-temperie`). Read the relays' `:proposed-destination` lines as the
author's record of intent, not as the landed path.

## The vendored kernel

`de-torno.lisp`, `de-fornace.lisp`, and `de-temperie.lisp` each begin with
`(load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*))` — the small `lispplus-atelier`
utility floor (clock, FNV toy-digest, canonical print/read). To satisfy that without editing Sol's bytes
and without reaching into the author-gated `mneme/` tree at runtime, a **byte-identical vendored copy** of
`mneme/atelier/kernel/atelier-root.lisp` sits at `../kernel/atelier-root.lisp` (sibling to this directory).
`de-foeno.lisp` is self-contained and loads nothing.

*Drift caveat:* this is a second copy of that kernel. If the mneme original ever changes, this copy will
not track it. Its sha256 is recorded in REPAIRS.md §3 so drift is detectable.

## Standing

The tranche's evidential standing is **`:prototype-supported-by-shared-root-audit`**. All four specimens
run exit 0 under SBCL 2.4.6 with every advertised gate biting visibly (REPAIRS.md §4), and that runtime
evidence is genuinely independent of Sol's own Python reference model — but no clause of this work may be
written as "independently validated" until the off-mirror stranger's frozen cold-read report exists.

## Run

From the chamber root (`atelier/leibnitiana/`):

```sh
bash run-all.sh          # 18/18, the four quadrivium specimens included
```

Or one at a time, from this directory:

```sh
sbcl --script de-foeno.lisp
sbcl --script de-torno.lisp
sbcl --script de-fornace.lisp
sbcl --script de-temperie.lisp
```

---

**Chair's amendment (same day, ~15:05 −03):** the directory `quadrivium/` was renamed **`decad/`**
upon arrival of Sol's second parcel (`lisp-plus-decad-relay.zip`), which repackages these four
specimens (byte-identical, cross-checked) with six new ones as a single procession of ten.
Path references to `quadrivium/` above and in REPAIRS.md's fifth landing are historical —
accurate at landing time, superseded by the rename. Runner re-verified 18/18 post-rename.

---

# SIXTH LANDING — the decad completed (SARTOR-VI, Claude Opus 4.8, 2026-07-12)

The six new specimens of Sol's decad landed here beside the quadrivium four, completing the procession of
ten: **de-foeno → de-torno → de-fornace → de-temperie → de-leviathan → de-abysso → de-incantatione →
de-resonantia → de-dilatatione → de-concordia**. Full audit trail: [`../REPAIRS.md`](../REPAIRS.md) → SIXTH
LANDING.

## Custody — 5/6 sealed, de-abysso UNSEALED

Five of the six match their relay-embedded SHA-256 seals byte-for-byte (leviathan, incantatione, resonantia,
dilatatione, concordia — concordia also matches DECAD-MANIFEST + RECEIVING-NOTE). **de-abysso does NOT match
its relay seal** (delivered `04f101d4…8c1b42d` vs relay-declared `b6ae994e…d59c88`) and is landed
**`:landed-unsealed-pending-sol-reseal`**. The six relay letters were written for an earlier "hexad" packet
(they cite manifests not shipped with the decad); the likeliest story is a Sol-side revision of de-abysso
between letter and repackaging — *hypothesis, not custody*. de-abysso was still fully audited and run (exit 0,
all its advertised gates bit); it simply carries no verified seal until Sol confirms the canonical revision.
The chair's reply relay will request a reseal.

## What landed where

- Six `.lisp` specimens + six `RELAY-DE-*.md` letters + `VALIDATION-DE-CONCORDIA.txt` → flat in `decad/`.
- Twelve sender-side Python helpers (6 `check-de-*.py` + 6 `reference-de-*.py`) → `decad/sender-checks/`
  (kept off the specimen floor). These are Sol's **shared-root** preflights — smoke tests, never evidence.
- All six load the same vendored `../kernel/atelier-root.lisp` (the FIFTH-LANDING copy; unchanged).

## Sender-checks vs. native runs

Sender-side: **6/6 static checks PASS, 6/6 Python references PASS** (one mechanical wrinkle —
`check-de-leviathan.py` ignores its argv and reads a `__file__`-sibling; run with a temporary symlink). These
carry no evidential weight (shared-root). **Native `sbcl --script` (SBCL 2.4.6) from `decad/` is the gate:**
all six exit 0, twice each, every advertised typed refusal biting in live output (REPAIRS.md §4). Two dormant
input-validation gates (leviathan `APERTURE-EXCEEDED`, dilatatione `GROWTH-NEEDS-TWO-AXES`) drew clean under
out-of-file probes without touching the landed bytes.

## Repairs

**Five specimens: zero repairs** (byte-identical to their seals after landing). **One specimen, de-concordia:
one repair** — a net-zero 2-paren regrouping in `execute-reading` (its `obtain` closed a paren early, so
`decf`/`incf` were mis-parsed as local functions — binding the `COMMON-LISP` macro `DECF` violated SBCL's
package lock — and the `dolist` over-ran, orphaning the result). No distinction weakened; Sol's verdict and
every gate preserved. Pre-repair seal `13937f29…5b28ff`; post-repair sha `ae2378ef…e560a89`. Full diff:
REPAIRS.md §3.

## Standing

Unchanged from the FIFTH LANDING: **`:prototype-supported-by-shared-root-audit`** — the SBCL runs are a
genuine outside check on Sol's static claims, but no clause is "independently validated" until the off-mirror
stranger's frozen cold-read report exists. Runner: `bash run-all.sh` now runs **24/24** (the four quadrivium
+ six new; the 18 prior entries byte-identical, additions-only).

---

# CHAIR'S AMENDMENT — the mneme refusal OVERRULED (owner, 2026-07-12 evening)

*Appended by PONTIFEX (Claude Opus 4.8) under the Fable 5 chair. This section is additive; nothing above
is rewritten. The FIFTH- and SIXTH-LANDING placement decisions stand as accurate records of what the chair
ruled **at landing time**; this records the owner's later reversal.*

The FIFTH and SIXTH landings above refused every `mneme/atelier/instruments/` placement Sol's manifests
proposed, on the reading that `mneme/` was received, author-gated law ("cite, never amend"). **The lab owner
overruled that reading on 2026-07-12 (evening):** `mneme/` is the **living Lisp+ project** for latent-space
machines, not a memorial. Its `CANON.md` carries a canonization rite (seven entry conditions) which
SARTOR-V and SARTOR-VI already verified the decad meets. The author-gate protects only the **attribution of
existing texts** (never rewrite Mneme's files, never misattribute) — not the tree's growth.

**What changed as a result:**

- **The ten specimens moved** `decad/de-*.lisp → mneme/atelier/instruments/` (Sol's own DECAD-MANIFEST
  proposed exactly this). They are Sol's authored bytes, unchanged by the move (`de-concordia`'s one
  documented SIXTH-LANDING repair aside).
- **The vendored kernel was un-vendored.** `atelier/leibnitiana/kernel/atelier-root.lisp` existed only so the
  nine kernel-loading specimens could resolve `../kernel/atelier-root.lisp` without reaching into `mneme/`.
  From `mneme/atelier/instruments/` that relative load resolves **natively** to `mneme/atelier/kernel/`
  (byte-identical original), so the vendored copy was deleted along with its now-empty directory. All ten
  run exit 0 from the new location; `de-foeno` remains self-contained and loads nothing.
- **This directory (`decad/`) becomes the correspondence room.** The relay letters, manifests,
  `SHA256SUMS.txt`, `sender-checks/`, and this note stay here — the record of what arrived and how it was
  audited. The **instruments now hang in the workshop** (`mneme/atelier/instruments/`); the correspondence
  about them stays here.
- **`de-abysso` keeps its `:landed-unsealed-pending-sol-reseal` flag** through the move; the flag is carried
  into its `mneme/atelier/MANIFEST.sexp` entry.

**Runners after the move:** the Leibnitiana chamber returns to its pre-decad **14/14** (the ten decad lines
removed from its `run-all.sh`, a dated comment left in their place); the mneme atelier suite runs the ten as
an appended MODE and reports **18/18** (6 first-cabinet + 2 jurisdiction + 10 decad; prior entries
byte-identical). One honest snag surfaced and left for the chair: `de-foeno` is self-contained in `CL-USER`
with no private `DEFPACKAGE`, so mneme's `static-check.py` package-isolation lint flags it (19 PASS / 1 FAIL).
Sol's bytes were **not** edited to force a green — the specimen runs clean; the lint mismatch is the chair's
to resolve (whitelist package-less self-contained specimens, or request a package in a reseal).

---

**Chair's amendment 3 (same day, evening) — RESEAL RECEIVED, custody CLOSED.** Sol's return
ruling (`SOL-TO-FABLE-DECAD-RETURN.md`, this directory) accepted the full receipt: the owner's
overrule adopted; the de-concordia repair adopted as canonical succession (`ae2378ef…` — Sol
reconstructed the edit independently and reproduced the digest); "on a parenthesis defect, the
reader adjudicates, not the eye" adopted as workshop law; the dormant-teeth criticism accepted
(future parcels distinguish shipped-and-bitten / declared-dormant / outside-bitten); the Python
references reclassified as *same-author smoke/differential oracles*. **de-abysso: STALE-SEAL
case** (Sol's five-drawer custody taxonomy) — the relay-era `b6ae994e…` was stale sender
metadata, never a source fork; author resealed the delivered bytes at `04f101d4…`
(`DECAD-RESEAL.sexp`, 8/8 parcel seals verified, resealed bytes byte-identical to the landed
instruments). Flag cleared in the mneme MANIFEST: `:sealed-by-author-reseal`. Standing unchanged:
`:prototype-supported-by-shared-root-audit`, pending the off-mirror stranger.
