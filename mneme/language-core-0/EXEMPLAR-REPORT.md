# EXEMPLAR-REPORT — the three Language Core /0 specimen packets

*EXEMPLAR (CC seat, Claude Opus 4.8 · 1M), 2026-07-24. Jurisdiction honored: only
three NEW directories under `experiments/latent-lisp/mneme/language-core-0/`
(`de-abaco/`, `de-cursore-aereo/`, `de-ponte-usto/`). Substrate consumed, never
edited. All greens are **self-consistency certification** (AP0 §24.1) — no PJ0
reliance, no durability claim, no AP0-conformance language, no "independently
verified/validated" anywhere.*

Runtime operation-checked before every run: `(lisp-implementation-version)` =
`"2.4.6"` through the wrapper (`/home/gauss/.local/bin/sbcl`).

Each packet is house form: `HYPOTHESIS.md` · `SPECIMEN.lisp` ·
`EXPECTED-FAILURES.md` (pre-registered, header says so — authored, frozen from
design + read substrate behavior, THEN the captured run) · `RUN-RECEIPT.txt`
(verbatim output + `EXIT=` + the `::` grep).

## Per-specimen results

### A. de-abaco — THE POCKET ABACUS (synthesis §4a, quiet-zone control)

- **9 checks passed / 0 failed, exit 0.**
- Proves the negative. The abacus program (`tally-vowels` + `parse-lantern-counts`
  with a plain CL `restart-case`/`invoke-restart` repairing a malformed entry)
  lives in package `de-abaco-abacus` using ONLY `#:cl`.
- Acceptance = the negative, machine-checked three ways: **[3a]** the abacus
  package's use-list is `("COMMON-LISP")` only; **[3b]** a live `do-symbols` audit
  finds zero governed-home symbols interned in it; **[3c]** a static scan of the
  verbatim abacus source finds zero governed *external* references — and its
  planted-positive control **[3c-control]** confirms the scanner CAN see
  `lisp-plus-core0:perform` when one is present (the empty scans are evidence, not
  a broken instrument).
- Registries untouched: **[4a]** schema-registry probe and **[4b]** adapter-registry
  probe both refuse (`schema-not-found` / `unknown-adapter`) before AND after the
  run — the run registered nothing.
- **[5]** CL restart ≠ governed repair, stated and shown: the repair produced no
  `core0-evidence`, no `outcome`, no receipt; the two grammars coexist without
  leaking.
- Receipt tail:
  ```
  de-abaco: 9 checks passed / 0 failed
  (quiet zone confirmed: ordinary Lisp+ is Common Lisp — no consequence without a claim or a governed act)
  EXIT=0
  ```

### B. de-cursore-aereo — THE BRASS COURIER (synthesis §4b, one effectful crossing)

- **23 checks passed / 0 failed, exit 0.**
- Three arms through `:fake-courier`: **committed** (`outcome-kind :committed`;
  manifestation is a record carrying receipt token `fake:courier:0001`, never the
  payload string; lawful event order validates), **refused** (a `:deliver`
  capability on a `:shred` request ⇒ typed `capability-scope-violation`,
  pre-frontier, refused outcome view `:refused`, NO frontier event, NO ledger row),
  **indeterminate** (a `:kill-after-commit` W1 ⇒ `core0-interrupted`,
  `outcome-kind :indeterminate`, told no token).
- **Ledger-vs-testimony demonstrated [1e/1f]:** the effect (a ledger row
  `(attempt-key token request)` in the adapter's private world) and the testimony
  (a kernel0 manifestation record + the event sequence) are DISTINCT records that
  agree on the token — the row is not the manifestation, and `not eq`.
- **Ack-has-no-settling-force [4a–4c]:** both the committed and interrupted arms
  carry `:request-acknowledged`; only the committed arm carries `:effect-settled`;
  the fold (not the ack) settles — the interrupted attempt's fold standing is
  `unresolved-effect-p` = T despite the ack.
- **Forbidden shortcuts asserted absent [5a–5d]:** ambient authority refuses
  (`:authority nil` ⇒ `ambient-authority-forbidden`, 0 rows); a durable
  mint-receipt as authority refuses; `outcome-kind` is a keyword view, never a
  boolean; the manifestation is never the bare value.
- Receipt tail:
  ```
  de-cursore-aereo: 23 checks passed / 0 failed
  EXIT=0
  ```

### C. de-ponte-usto — THE LETTER ACROSS THE BURNED BRIDGE (synthesis §4c-i ONLY)

- **17 checks passed / 0 failed, exit 0.**
- Both load-bearing sentences are printed in the run output, and both are stated in
  the packet's own bytes (HYPOTHESIS + SPECIMEN):
  - *"ABSENCE OF TESTIMONY IS NOT TESTIMONY OF ABSENCE."* (head)
  - *"NOTHING HERE DEMONSTRATES CRASH-SURVIVAL. The event sequence survived because
    the IMAGE did."* (closing disclaimer)
- **The UNSAFE-RETRY refusal fires visibly in the receipt [2a]:** the specimen
  directly runs live `check-retry-safety` on a blind-retry event sequence and
  prints `★ UNSAFE-RETRY fired: UNSAFE-RETRY` before refusing.
- Standing is fold-derived, not self-reported **[3a/3b]** (`fold-attempt-outcome`
  ⇒ unresolved, terminal-class `:failed`).
- **Central assertions all hold:** **[4d]** EXACTLY ONE ledger row after
  continuation (before=1, after=1); **[4e]** the continuation never re-invokes (row
  count is the witness); **[4a–4c]** `continue-from` reconciles, produces a
  `reconciliation-receipt` naming its evidence basis, narrows the standing to
  resolved; **[5a]** a historical mint-receipt is refused as continuation authority
  (`ambient-authority-forbidden`) while a fresh live capability works **[5b]**;
  **[6a–6c]** the withholding variant yields honest `:indeterminate` naming
  known/unknown/required-action, still exactly one row.
- Receipt tail:
  ```
  de-ponte-usto: 17 checks passed / 0 failed
  (reconciliation as jurisprudence: derive standing from evidence, refuse the blind retry, and be honest when the witness withholds — all superior to lying)
  EXIT=0
  ```

## Discipline results (all clean)

- **`::` grep:** zero double-colon (governed internal) access in ALL specimen code.
  Verified per-packet in each RUN-RECEIPT and swept across all three:
  `grep -rn '::' de-abaco/*.lisp de-cursore-aereo/*.lisp de-ponte-usto/*.lisp` ⇒
  **0 matches.** (The only licensed `::` in this lane is the substrate's own
  receipted `why` seam in `core0.lisp`, outside my jurisdiction.)
- **Full regression after the work — my work changed nothing:**
  - `core0-selftest.lisp`: **29 passed / 0 failed** (identical to the pre-work
    baseline I captured before writing any specimen).
  - `kernel0-selftest.lisp`: **33 passed, 23 excluded, 0 failed, 59 mutants
    killed** (identical PRE and POST).
- **Frozen trees byte-untouched:** `git status` shows ZERO modifications under
  `kernel0/`, `language-slice-0/`, `language-slice-1/`. Under `language-core-0/`
  the only new entries are my three specimen directories (`de-abaco/`,
  `de-cursore-aereo/`, `de-ponte-usto/`) — substrate files unmodified.

## Chair-findings (mismatches, surprises, design notes)

**No pre-registration divergences.** Every specimen matched its frozen
EXPECTED-FAILURES exactly (9/9, 23/23, 17/17). Four notes for the chair, none a
mismatch:

1. **Adapter passed as an OBJECT, not resolved by keyword designator.** The
   specimens call `make-fake-courier` (⇒ `values adapter world`) and pass the
   adapter object directly to `perform :adapter <object>`. `resolve-adapter` passes
   an adapter object through, so no `register-adapter` step is needed and the
   keyword-designator path (GAP 5 in the substrate report) is not exercised by
   these three specimens. This is lawful and keeps each specimen self-contained
   (its own private world per run); flagged so the chair knows the
   `register-adapter` / keyword-resolve path is covered by the substrate selftest,
   not by these specimens.

2. **de-abaco "receipt counts untouched" realized on the PUBLIC surface.** The
   synthesis §4a wording names "receipt counts". The Core /0 receipt-id counter is
   internal (reading it would need a forbidden `::`). I realized the requirement
   two lawful ways instead: (a) dynamic before/after probes of the two PUBLIC
   registries (schema, adapter), and (b) the structural guarantee that the abacus,
   referencing zero governed constructors (machine-checked 3a–3c), *cannot* mint a
   receipt/evidence/outcome. This is a faithful public-surface adaptation, not a
   weakening — but the chair should know I did not read a numeric receipt counter,
   because none is public.

3. **The W1 kill's surviving event tail is `…:effect-bounded :attempt-failed`**
   (not a settled tail), and `:request-acknowledged` precedes it — which is exactly
   what makes the ack-vs-settle demonstration (Brass Courier [4a–4c]) and the
   fold-derived unresolved standing (Burned Bridge [3a]) land. Matches the
   substrate report's GAP 3 W1 encoding.

4. **Scope of what was NOT claimed, restated:** no crash-survival (de-ponte-usto
   says so in its own bytes), no durability, no AP0 conformance (fake courier is a
   labeled scripted subset), no promotion of the 22 readers, no `match-outcome` /
   `with-outcome`. `outcome-kind` is used only as the three-way view over `perform`
   outcomes.

## Handoff

- **Do NOT git commit** — the chair commits after verification (per work order §1.5
  cadence; the chair owns the closure).
- Total: 49 checks across three specimens, all green; both regressions unchanged;
  zero `::`; frozen trees untouched. Deliverable 3 of the work order (the three
  specimens in house form) is built and self-consistency-certified; `CORE-0-CLOSURE.md`
  (§1.5) remains the chair's to write.

— EXEMPLAR (CC seat), Claude Opus 4.8 (1M), 2026-07-24
