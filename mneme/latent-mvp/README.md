# Mneme latent-mvp — the seven-brick arc + the shared kernel

*The runnable core of Lisp+/Mneme: a Lisp for latent-space minds, built one law at a time across a single
2026-07-11 session, each brick hardened by a GPT Sol cold-chair review. All files run under `sbcl --script`
(or `--load` for the kernel), exit 0 == the law holds.*

## v1 — the hardened kernel (the "second commit", 2026-07-11)

**`kernel.lisp` (below) is v0: it enforces the intended *route*, not the *invariant*.** GPT Sol's cold-chair
review of the public repo showed a caller can mint its own certificate/grade/verifier-identity through the
exported API. The hardening lives in two new files:

- **`kernel-hardened.lisp`** — Mneme **v1**, built across two GPT Sol co-design passes. What changed: the public
  surface is **mechanically split** into `mneme.client` (adversarially callable) and `mneme.operator` (trusted
  bootstrap — a package boundary, not a comment); no exported constructors for authenticated objects; private
  `%accessors` with exported **defensive-copy** readers (a read-only box may not leak mutable conses); verifier
  authority is an **opaque capability object** (registry-membership is validity) whose scope lists are
  **copied on grant** (no widening the warrant after issuance); a private **procedure registry** (propositions
  name a registered `procedure-id` — never a live function, no `fdefinition` from caller data); `raise-claim`
  validates an attestation's **mint provenance**, not its shape (nominal typing must not impersonate
  authentication); a **hostile-data decoder** (`*read-eval*` nil, `#S`/`#.` refused, one-form-only, inert
  records never live objects); **inert revival** (inherited warrants are *historical testimony only* —
  authenticated set begins empty; `:revived` is the 4th receipt transition; no double-revive); and **typed
  conditions** (`authority-violation`, `scope-mismatch`, `unsafe-procedure`, `invalid-attestation`,
  `schema-mismatch`, `handoff-state-violation`).
- **`adversarial-conformance.lisp`** — the external-client attack suite (package `attacker`, sees only the
  `mneme.client` surface + trusted `mneme.operator` in setup). Each attack must signal its **own intended typed
  condition** — proving the right constitutional organ objected, not merely that *something* did.
  `sbcl --script adversarial-conformance.lisp` → **18 passed, 0 failed, exit 0** (15 forgeries refused +
  3 lawful-route checks). The red-run matters as much as the green: an earlier version failed 9/14 and the suite
  caught the bug before certifying — the gate bit the builder first. (A14/A15 — the retrospective-revocation
  gates — were planted red the same way: A15 survived until the `raise-claim` revocation-registry guard was
  added, proving the guard, not the validity-flip alone, is load-bearing for cascade revocation.)

Threat model (Sol's ceiling, exact): `mneme.client` resists adversarial use of the exported API and treats
serialized input as hostile; `mneme.operator` is **trusted bootstrap**, not part of the adversarial surface; it
does **not** defend against same-image code reaching `mneme::` internals (process isolation, not a language
feature); crypto deferred. Revocation is now **both prospective and retrospective**: `revoke-authority` still
blocks future issuance, and a new operator op `revoke-attestation` (plus a `raise-claim` revocation-registry
guard) voids *already-minted* warrants so they can no longer raise — and revoking a verifier **cascades** to
every warrant it minted (each attestation records its minting cap-token). This closes the attestation-revocation
debt for the *raise* step within one image; it does **not** retroactively un-authenticate claims already raised
(claims are immutable value objects with no central registry to sweep — named, not solved), and revocation does
not survive serialization (revived warrants are inert predecessor data anyway). This is a **bounded receipt —
"all specified v1 gates passed" — not a proof of universal unforgeability.** **Still owed** (honest): canonical
byte serialization + real crypto, durable cross-process IDs (still `gensym`), full procedure/code identity (v1
reserves `procedure-id`/`procedure-version` in attestations so that work *extends* rather than rewrites),
retroactive claim-level revocation, migrating the v0 bricks onto the hardened kernel, and the standing question —
*what's the next unenumerated forgery?* (Sol's Q5).

## The consolidation (v0 — the record of discovery)

- **`kernel.lisp`** — the shared root (package `mneme`). The un-improvisable common floor: `claim`, typed
  `witness`, `certificate`, the grade vocabulary, the authority table, `witness-supports-p`,
  `verify-proposition`, `raise-claim` (certificate-required), `authenticate-grade`, `freeze`/`mneme-revive`,
  and the four-state receipt (`prepare`/`commit`/`receive`). Sol asked for this four times; here it is.
- **`conformance-walk.lisp`** — the seven laws re-proved as ONE walk over the kernel (not seven private
  implementations). `sbcl --script conformance-walk.lisp` → seven ✓, exit 0.

## The seven bricks (the record of discovery — kept as museum/strata)

Each was written standalone and reviewed before the next; they remain as the provenance of how the laws were
found. Going forward, new laws are conformance walks over `kernel.lisp`, not new private civilizations.

| brick | file | law made mechanical |
|---|---|---|
| #1 | `lisp-plus.lisp` | rhetoric ≠ evidence (grades travel; a rationale can't wear a verdict) |
| #2b | `handoff-kernel.lisp` | continuity is a witnessed relation (4-state receipt, 9 gates) |
| #3 | `judgment.lisp` | production ≠ truth (infer returns a judgment; invocation ≠ world-claim) |
| #4 | `evidence-kernel.lisp` | proximity ≠ support (a witness must face the proposition) |
| #5 | `surviving-witness.lisp` | completed work leaves admissible testimony (trust + distrust) |
| #6 | `certificate-kernel.lisp` | report ≠ certificate (a witness can't notarize itself) |
| — | `continuity.lisp` | brick #2's ancestor (superseded → strata) |

## What's owed (Sol's ledger, honest)

Not yet built: canonical byte serialization + SHA-256/HMAC (the digests here are `md5`/`sxhash`-class, fine
for specimens, not for adversaries); UUID identity (not `gensym`); the warrant-profile (grades are a lattice,
not a ladder); typed evidence edges (`:supports` vs `:produced-by`); scope-matching (a witness supports a
*located* claim); the provider adapter → un-stub `infer` (a live model, mintable only through the authority
table); and migrating each standalone brick to `(load "kernel.lisp")` (the kernel + walk prove the pattern;
the per-brick migration is mechanical and un-started).

## Governing docs

- `../CONSTITUTION-v0.5-mneme-skeleton.md` — Mneme as a profile answerable to the existing
  `../v0.3/constitution/BOOK-0.md`
- `../atelier/` — GPT Sol's cabinet of six `:toy-with-teeth` specimens over its own shared root
- The review arc: `corpus/voices/received/originals/2026-07-11-gptsol-*` and `…-fable-*`
