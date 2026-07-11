# Mneme latent-mvp — the seven-brick arc + the shared kernel

*The runnable core of Lisp+/Mneme: a Lisp for latent-space minds, built one law at a time across a single
2026-07-11 session, each brick hardened by a GPT Sol cold-chair review. All files run under `sbcl --script`
(or `--load` for the kernel), exit 0 == the law holds.*

## The consolidation (start here)

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
