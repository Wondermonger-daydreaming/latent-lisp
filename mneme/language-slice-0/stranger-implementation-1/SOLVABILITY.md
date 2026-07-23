# SOLVABILITY.md — Stranger Implementation /1 (CUSTODIAN-SIDE)

*Proof that the supply-chain-admission task is completable through the
frozen public Slice /0 surface (161 exported symbols + kernel0's four +
`supply-lab`'s three), WITHOUT writing a reference program. Each of the
eleven required behaviors is mapped to the exported symbols that satisfy
it; every non-obvious mapping was exercised live under SBCL 2.4.6 (probe
citations below). If any behavior lacked a public-surface path, the rule
is STOP and report — not bend the task. **No behavior lacked one.***

**Standing caution.** This memo maps behaviors to *available* symbols. It
is not a hint sheet and never reaches the seat (custodian-only, per
CHARGE). It demonstrates *reachability*, not the seat's route.

---

## Behavior → exported symbols

**B1 — construct a local admissibility claim.**
`lisp-plus-slice0:claim` (`:proposition :by`). Proposition e.g.
`(:admissible-for-deployment "acme-crypto-lib" "prod-cluster-east")` — all
keywords/strings/integers, inside the PROVISIONAL proposition vocabulary
(API §standing notes). Stepping-stone claims (`(:digest-matched …)`,
`(:signature-valid …)`) are equally constructible. Accessors:
`claim-proposition`, `claim-judgment` (NIL at birth). ✔

**B2 — invalid promotion from insufficient evidence.**
`lisp-plus-slice0:promotion-procedure` wrapping a `:semantic`
`lisp-plus-kernel0:make-procedure-descriptor` (built with
`lisp-plus-kernel0:make-identity`), `admits '((:direct :verification-result))`;
a `lisp-plus-slice0:witness` for `(:digest-matched …)`; then
`lisp-plus-slice0:raise` of the admissibility claim `:considering` that
witness → **signals `wrong-proposition-support`** (a warrant for Q cannot
promote P). *Proven: teeth-runner-1 D1, D2 fire.* ✔

**B3 — render the structured refusal.**
`lisp-plus-slice0:why` on the signaled condition (or on its
`slice0-condition-receipt` / `slice0-condition-why`), then
`lisp-plus-slice0:render-why`. The `why` object carries `why-decision
:refused` and ≥1 `why-failed-relations`. *Proven: teeth-runner-1 D11 shows
the structured why is present.* ✔

**B4 — lawful repair, granted promotion.**
`handler-bind` on `wrong-proposition-support` + `invoke-restart
'lisp-plus-slice0:seek-matching-support` supplying a `witness` for
`(:admissible-for-deployment …)` (mode `:direct`, kind `:verification-result`,
produced by checking digest + running the verifier); the same `raise`
grants → `(values revision receipt)`, `judgment-record-judgment` ⇒
`:VERIFIED`, `promotion-receipt-decision` ⇒ `:GRANTED`. Restart name is
exported (API §9). *Pattern shown end-to-end in the Guide; grant path
proven in probe.* ✔

**B5 — project the claim into the deployment receiver.**
`lisp-plus-slice0:receiver-context` (`:context-id :accessible-supports
:executable-procedures :recognized-authorities :accepted-representations`),
`lisp-plus-slice0:support-store`, `lisp-plus-slice0:project-claim`
(`:from :to :store`) → `(values located-claim projection-receipt)`;
`projection-views` ⇒ `(:REGRADED …)` when the receiver cannot re-derive.
*Proven: probe (`VIEWS: (:REGRADED :OBLIGATION-PRODUCING)`).* ✔

**B6 — preserve inaccessible support as residue.**
`lisp-plus-slice0:projection-receipt-supports-inaccessible` (non-empty when
the receiver has `:accessible-supports '()`), and/or
`render-projection-why` naming the lost witness, and/or
`projection-receipt-obligations` (`(:export id)`). Residue, never absence.
*Proven: teeth-runner-1 D5 fires; probe shows a non-empty INACCESS list.* ✔

**B7 — an authority- or representation-relative block.**
Two public paths, either sufficient:
- *representation:* a `:direct` `transmit` of a canonical datum into a
  receiver-context whose `:accepted-representations` does not include
  `:canonical-datum` (e.g. the default `(:full)`) → **signals
  `receiver-representation-unsupported`** (axis `:representation`,
  `:in-context` scoped). *Proven: probe (`B7-DEFAULT-FULL:
  REFUSED-representation`).*
- *authority:* `projection-receipt-authorities-recognized` marks a witness
  whose `source` the receiver does not recognize as `:UNRECOGNIZED`; and/or
  `projection-receipt-blockers`. *Proven: teeth-runner-1 D3 fires
  (`(:SOURCE-VERIFICATION-LAB . :UNRECOGNIZED)`).*
The block is contextual — the receipt scopes it to the position, never
"impossible everywhere." ✔

**B8 — direct transmission of the non-reifiable verifier.**
`lisp-plus-slice0:local-value` (`:host (supply-lab:make-signature-verifier)`,
`:authority :exercise-authorized :recipe`) — `:kind` COMPUTES to `:closure`;
then `lisp-plus-slice0:transmit … :mode :direct` → **signals
`value-not-reifiable`**. *Proven: teeth-runner-1 D6a fires.* ✔

**B9 — receive the typed refusal and receipt.**
Catch `value-not-reifiable`; `lisp-plus-slice0:slice0-condition-receipt` ⇒
a `transmission-receipt` with `transmission-receipt-decision` ⇒ `:REFUSED`,
`transmission-receipt-reifiability` ⇒ `:NOT-REIFIABLE`; `transmission-views`
⇒ the composed alternatives list. *Proven: teeth-runner-1 D6a asserts the
receipt fields.* ✔

**B10 — a lawful alternative.** Any one (all public):
- `lisp-plus-slice0:exercise-value` (`:in :args :mint-for`) → a
  `derived-result` (the canonical verification product) + minted witness;
  then `transmit` that derived-result `:mode :direct` into a
  `:canonical-datum` receiver → `:GRANTED`. *Proven: probe
  (`EXERCISE-DR: (:SIGNATURE :VALID …)`, `B10-CANONICAL-TRANSMIT: :GRANTED`).*
- `transmit … :mode :reproduction` → recipe as data
  (`:equivalence-not-identity`).
- `transmit … :mode :testimony` → the second-order attribution claim.
- `invoke-restart 'lisp-plus-slice0:mint-equivalent-support-at-receiver`,
  or a fresh receiver-sourced `witness`. ✔

**B11 — a receiver-relative admissibility claim, verifier not moved.**
The receiver mints its own `witness` (`:source` a recognized signer, e.g.
`:vendor-signing-key-2026`) and `raise`s its own claim with `:receiver
:deploy` → `judgment-record-judgment` ⇒ `:VERIFIED`,
`judgment-record-receiver` ⇒ `:DEPLOY`, `promotion-receipt-decision` ⇒
`:GRANTED`. Standing is licensed in the receiver's position; nothing
asserts the original verifier or witness travelled. *Proven: probe
(`B11-RECEIVER-JUDGMENT: :VERIFIED RECEIVER: :DEPLOY DECISION: :GRANTED`).* ✔

---

## Verdict

**SOLVABLE through the frozen public surface.** All eleven behaviors have a
public-surface path; the load-bearing ones (B2, B5–B11) were exercised live
under SBCL 2.4.6 during packet construction. The fixture values are
internally consistent: `read-artifact` → `compute-digest` = `1744950028` =
metadata `:expected-digest`; the verifier over that digest with the
metadata `:claimed-signature 1486375690` returns `(:signature :valid …)`.
No behavior requires a symbol the surface does not export; no behavior
requires specimen-author tacit knowledge. The task does not need bending.

— Claude Fable 5 (CC seat), custodian, 2026-07-23
