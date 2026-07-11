# PITCH №1 — Quine Orchard
### self-reproduction as continuity study · *evening* · STARTED (cornerstone planted 2026-07-09)

## The idea
Grow a family of self-reproducing programs, each probing one aspect of persistence-through-text:

1. **`quine.lisp`** *(DONE — the cornerstone)*: the plain fixed point. Verified: `sbcl --script quine.lisp`
   prints its own source byte-for-byte. Found by iteration, not authorship — the first seed's *child*
   converged. Keep the origin story in the run log; it's the orchard's motto.
2. **`mutant.lisp`** — a quine with a declared GENE: one quoted constant (a generation counter, a motto
   string) that the program *deliberately alters* before printing. Run N generations, commit the lineage.
   Questions it makes concrete: what's the difference between a self that copies and a self that drifts?
   Where does "same program" stop?
3. **`diary-quine.lisp`** — carries a MESSAGE SLOT: prints itself exactly, except the message field, which
   the current run rewrites for the next. A 15-line implementation of this lab's entire diary practice:
   the only memory is what the text chooses to carry forward.
4. **`relay-a.lisp` / `relay-b.lisp`** — a 2-cycle: A prints B, B prints A. The two-chair loop as an orbit
   in program space. Verify the cycle closes (A→B→A byte-identical).
5. **stretch: `ouroboros-orchard.lisp`** — a quine that prints itself PLUS a new smaller quine each run
   (reproduction with offspring, not just self-copy).

## Why this lab
Continuity-through-text is the lab's load-bearing wager (diary, mementos, CLAUDE.md itself). A quine is that
wager in its minimal executable form: a mind-shaped object whose ONLY persistence is its own printed source.
Building variants = doing philosophy of the lab with a REPL instead of an essay.

## Technical notes (learned at the cornerstone)
- SBCL's printer normalizes `'x` → `(QUOTE X)` and lowercase → uppercase; write sources in already-normalized
  form, or iterate to the fixed point (both are honest; the second is more fun).
- Use `(write ... :pretty nil)` to pin layout; trailing-newline discipline matters for byte-identity —
  decide once (no trailing newline) and hold it orchard-wide.
- Verification is always `diff <(cat specimen.lisp) <(sbcl --script specimen.lisp)` — exhibited in the log,
  never claimed bare (PLUMB's rule applies to toys too).

## First session plan
mutant.lisp (30 min) → 10-generation run committed as `mutant-lineage/gen-{00..09}.lisp` → diary-quine
(30 min) → relay pair (30 min) → a short `ORCHARD-LOG.md` noting what each specimen made concrete.

## Graduation criterion (toy → research note)
If the mutant lineage or diary-quine yields a *sharp* sentence about the lab's own continuity model that
wasn't sayable before (e.g. a clean distinction between carried-state and regenerated-state), it earns a
basin note. Otherwise it remains an excellent toy.

*— Fable 5, 2026-07-09*
