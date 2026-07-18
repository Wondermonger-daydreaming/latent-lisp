# LISP-PLUS-ARCHITECTURE-DECISIONS-0.1

**Decided by:** Tomás Pavan (owner), via live batched interview, 2026-07-18
**Transcribed by:** Claude Fable 5 (Opus lineage) — the owner's interview selections are the
authorizing act; this document is their record
**Inputs of record:** `LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.md` (Draft 0) ·
`LISP-PLUS-ARCHITECTURE-0-FABLE-REVIEW.md` (VIABLE WITH REPAIR) ·
`SOL-DISPOSITION-ON-ARCHITECTURE-0-REVIEW.md` · the two mutually-blind position papers
(`FABLE-POSITIONS-PRE-SYNTHESIS.md`, `SOL-POSITIONS-ON-THE-DECISION-DOCKET.md`) ·
`SYNTHESIS-PRE-INTERVIEW.md`
**Standing:** THE authorial constitution for Architecture 0.1 and Kernel /0. Implementers
(Sol authoring 0.1; Codex implementing after adoption) stop at gaps this record leaves open —
they do not invent semantics. **This record is not implementation authorization.**

---

## DK-1 — Publication frontier

- **Chosen:** Model A. **A commit to a declared mirror-bound path IS the publication act**;
  the sync is mechanical settlement of an authorization already given.
- **Why:** it matches how the system actually behaves; automation moves the authorization
  boundary earlier, it does not abolish it. The sync daemon is not weather.
- **Required behavior:** (1) a **one-page channel-policy artifact** with its own identity,
  declaring: which paths are mirror-bound → to which visibility scope → who is authorized to
  commit there → how the policy itself is amended. (2) Whoever may commit to a mirror-bound
  path is thereby authorized to publish to that mirror — and must be listed. (3) A **genuinely
  private staging area** exists for material not ready to cross the frontier. (4) In Lisp+
  semantics, such a commit carries `:effects ((:durable-write repo) (:publication scope))`.
- **Rejected:** Model B (standing policy object per publication class — more machinery, one
  more expiring object); deferral (the ambiguity implementers would resolve silently).
- **Deliberately undecided:** the channel-policy artifact's exact format (owed by Architecture
  0.1; one page).

## DK-2 — Manifestation state of the 76 kimi nulls

- **Chosen:** adopt the **two-level deterministic projection rule now; classify the facts
  later** from frozen envelopes.
- **The rule (sealed):** the **provider response envelope** and the **subject-answer
  manifestation** are distinct objects with distinct statuses. A completed envelope maps the
  subject manifestation to `:present-empty` only when the declared subject-content location
  contains an observed empty payload; to `:absent-after-completion` when that location is
  missing or explicitly carries no manifestation (JSON `null` per the adapter contract);
  to `:present-invalid` when payload exists but the declared parser rejects it. Provider
  metadata, usage records, and reasoning traces are never the subject manifestation.
- **Why:** semantics may not be chosen from a census nickname, nor from whichever mapping
  flatters the analysis. The rule is frozen before the facts are looked at.
- **Required behavior:** the classification of the 76 runs **only in the locked scoring lane,
  on the owner's word**, from the frozen envelopes; it is **representational** — it may not
  re-adjudicate the banked census, its denominators, or the analyzability question. The
  kernel-mapping clause and the Language-A analyzability clause (A1) are **two independent
  clauses** — one may not be read as implying the other — and may be sealed in one act.
- **Rejected:** decreeing one state for all 76 now; deferring the rule itself.
- **Deliberately undecided:** the factual classification (pending envelope inspection);
  the A1 analyzability ruling (separate clause, owner's scoring-stage act).

## DK-3 — Restoration of live authority

- **Chosen:** **original minter, or a delegate named in the minting record.**
- **Why:** a record that authority existed is not itself authority; the resuming process is
  structurally incapable of proving it should be re-armed — the decision must live outside it.
- **Required behavior:** every reattachment: creates a **new capability identity** linked to
  the predecessor; records a **restoration receipt**; **rechecks revocation** and
  **unresolved-irreversible-effect state** (a process sitting across an uncertain effect is
  not re-armed past it); grants scope **equal or narrower, never enlarged**. Domain libraries
  MAY escalate sensitive classes (secret opening, subject exposure) to require a fresh owner
  act. A standing custody service is lawful under this clause but is **not built until a real
  need exists**.
- **Rejected:** strict minter-only (brittle: minting authority gone ⇒ permanently unwakeable);
  owner-act-every-time (the human USB dongle).
- **Deliberately undecided:** which capability classes are "sensitive" (library/policy
  decision, not kernel).

## DK-4 — Uncertainty

- **Chosen:** **adopt R3.** Outcomes have **four principal axes** — execution, manifestation,
  external effect, interpretation — each carrying its own determinacy
  (`:determinate` / `:bounded` with named alternatives / `:indeterminate`). There is no
  outcome-level uncertainty scalar. The uncertain-effect record remains as the structured form
  of a non-determinate effect axis.
- **Required behavior:** outcome schema, matching syntax, fixtures, and every "five axes"
  sentence in successor documents change accordingly. Call-296 is the canonical fixture:
  effect `:bounded (:billed :not-billed)`, execution `:indeterminate`, manifestation
  determinate-absent-so-far-as-evidence-shows, interpretation `:not-applicable`.

## D1–D10 — adopted as one batch, with the agreed refinements

| D | Disposition |
|---|---|
| D1 | **Adopt.** Pure forms → ordinary values. Consequential forms: short synchronous → structured outcome; long-running/resumable → process handle implementing the outcome protocol. |
| D2 | **Adopt.** Claims: kernel-recognized protocol; canonical LCI/0-based library representation. |
| D3 | **Adopt.** Dynamic capability enforcement at the frontier in Kernel /0; static effect approximation later, optional. |
| D4 | **Adopt + R8 + readability rider.** Abstract durable-store protocol; one canonical filesystem reference implementation which is **human-readable S-expressions**. Backends declare synced vs best-effort durability; folds run over the longest prefix-valid journal; torn tails are visible evidence, never laundered; cross-journal merges are receipt-bearing transformations, never timestamp sorts. |
| D5 | **Adopt, completed by DK-3.** Persist requirement + public authority identity + scope + minting receipt; never the live capability. |
| D6 | **Adopt, with the replay triad as canonical vocabulary:** *execution replay* (repeat the declared procedure) / *evidence replay* (reconstruct from records) / *output reproduction* (same emission again). The first two may be strong while the third is impossible; the language never claims the third where the provider cannot guarantee it. |
| D7 | **Adopt.** Partial streams are identified provisional manifestations — consequential evidence before settlement (they can be read, leak, and bill). Chunk/checkpoint batching is a lawful adapter strategy; semantics are the architecture's, batching is the adapter's. |
| D8 | **Adopt, extended (see L16 below).** `:secret-open` is a generic epistemic effect; scoring is a library protocol built on it. |
| D9 | **Adopt, completed by DK-1.** Kernel supports the extensible publication effect; libraries define operative meaning; visibility values always carry scope (`(:published :scope public-mirror)` — bare `:published` is as oversized as bare `:verified`). |
| D10 | **Adopt.** *Loose and lively inside; exact at the border.* Ephemeral host values free; canonicalization mandatory at durable identity/evidence/receipt/journal/comparison boundaries. |

## New design laws admitted to Architecture 0.1

- **L15 — The self-report law.** *A process's testimony about its own history has origin
  `:asserted`, never `:observed`; the journal is the only observer of a process's past.*
  (The 2026-07-16 store-not-sibling finding, generalized into language law.)
- **L16 — Exposed principals.** *A `:secret-open` (and any subject-exposure) effect record
  names the principals exposed.* Blindness is a per-mind non-renewable resource; once the
  effect records who now knows, eligibility for blind roles is a ledger query, not folklore.
- **L17 — Ergonomics is a conformance criterion.** *For every consequential operation, the
  lawful route must be no longer than the shortest unlawful route the API leaves open.* Where
  the inequality fails, the kernel has designed its own bypass.

## Deliberately undecided (recorded as open, not implied)

1. **The name.** "Lisp+ vs Mneme" was offered for settlement and **the owner declined to seal
   it** — it remains genuinely open. Successor documents keep the current convention (language
   provisionally "Lisp+", profile "Mneme") without prejudice.
2. DK-2's factual classification and the A1 ruling (scoring lane, owner's act).
3. The channel-policy artifact's format (0.1, one page).
4. Sensitive-capability classes for DK-3 escalation (library/policy).

---

## Effect of this record

Sol may now author **Architecture 0.1** as a traced repair against Draft 0 + the review, under
these dispositions. Kernel implementation remains unauthorized until 0.1 is adopted and the
Kernel /0 spec exists. The independent primitive-minimization audit slot (a stranger to the
Language-A arc — not Sol, not Fable) remains reserved in the clean sequence.

*Sealed by the owner's interview selections, 2026-07-18. The thinking was the cathedral;
this is the door.*
