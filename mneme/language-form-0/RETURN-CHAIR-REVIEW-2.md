# RETURN — OWNER RULING, CHAIR REVIEW 1

*The §7 return required by the owner ruling of 2026-07-26 (option C).*

*Every number below was read from a live run in this worktree, not recalled.*

---

## 1. Branch and commit

```
worktree   <isolated worktree>
branch     language-form-0 → origin/language-form-0   (Claude-Code-Lab, LAB remote)
commit     0bbcc4a6  option (c): package-controlled operators —
                     the substituted clerk has no door
ahead      6 commits · NOT merged
mirror     [2026-07-26T17:51:03Z] commit on branch 'language-form-0'
                                  — mirror sync SKIPPED (main-only guard)
           public tip still 17a9472 · lab main still 4c4f43ad
```

## 2. Export count, and what moved

```
before   97
after    99
```

**Internalized (1):** `MAKE-OPERATOR-DESCRIPTOR` — gone under *any* status, not
merely unexported.

**Added (3):** `OPERATOR-NAMES` · `OPERATOR-DESCRIPTOR` ·
`INSTANTIATED-FORM-TEMPLATE-SUBJECT-IDENTITY`.

The count went **up**, deliberately. Per the ruling, the census optimises for an
honest public semantic boundary, not a small number: two of the additions exist
so that a program can *read* the package-owned operator set it is selecting
from, and the third is required by the corrected subject doctrine.

`EXPORT-CENSUS.md` is regenerated. Every one of the 99 carries a declared
caller, minting power and disposition, and the census **fails** if any does not.
Every environment-related export is now marked *"none — SELECTS package-owned
operators by name; cannot supply behaviour."*

## 3. The exact public operator-construction API

There is none. That is the point.

```lisp
;; What a program may do:
(operator-names)
;; → ("equal-datum" "canonical-hex" "sequence-length" "render-diagnostic")

(operator-descriptor "canonical-hex")   ; read arity / result species only
                                        ; the handler it carries has no public accessor

(make-form-environment :name "desk" :version 1
                       :operators '("equal-datum" "canonical-hex")  ; a SELECTION of NAMES
                       :holes (list (make-form-hole "x" :integer)))
```

Behaviour is resolved **inside the package** by a closed dispatcher:

- `%OP/EQUAL-DATUM`, `%OP/CANONICAL-HEX`, `%OP/SEQUENCE-LENGTH`,
  `%OP/RENDER-DIAGNOSTIC` — ordinary package-internal functions;
- `%BUILTIN-SPEC` — a `cond` over literal names, not a table;
- `%MAKE-BUILTIN-DESCRIPTOR` — the only constructor in the layer that puts a
  function into a descriptor, internal, and able to reach only the four above.

**No mutable global registry exists.** There is no table to remap and no shared
descriptor object to mutate: each descriptor is constructed fresh and immutable
per call. A name outside the set is refused with `:operator-not-built-in`; a
host function offered where a name belongs is refused with
`:environment-unusable`.

## 4. The exploit, before and after

**Before** (reproduced live in chair review 1, from a fresh consumer package):

```
probe 2 — arbitrary handler installed as a descriptor?          YES
probe 3 — the two environments' identities are EQUAL-DATUM?     T
probe 3 — validated under HONEST, realized under SWAPPED:       ACCEPTED
         result = "forged"   handler that ran = :SWAPPED-HANDLER-RAN
```

All five drift gates passed while an attacker's handler ran.

**After** (same fresh-consumer package, `PUBLIC-SURFACE-AUDIT.lisp`):

```
ok   5. MAKE-OPERATOR-DESCRIPTOR does not exist under any status
ok   5. a host function offered as an operator selection is refused
ok   6. an operator outside the package-owned set cannot be installed
ok   6. the installable set is exactly the four of Candidate /0
ok  10. two public environments with the same selection agree on content
ok  10. a different selection changes the content digest
ok  10. a validation does NOT travel to a redeclared environment
ok  10. but it DOES travel to an identically-selected twin — behaviour is package-owned
```

And in the teeth, `T-NO-CALLER-SUPPLIED-BEHAVIOUR` (6 checks) asserts the same
from the other side, including that every handler-bearing symbol
(`%MAKE-BUILTIN-DESCRIPTOR`, `%BUILTIN-SPEC`, the four `%OP/…`,
`%OPERATOR-DESCRIPTOR-HANDLER`) is internal.

**The attack is not mitigated. It is unconstructible through the public API.**

## 5. Threat model (work order §0, closure erratum)

**Protects against:** malformed, adversarial or model-emitted Canonical Datum
forms attempting to acquire operations not installed in their sealed
environment.

**Does NOT claim protection against:** malicious Common Lisp already executing
in the same image · package-internal access through implementation facilities ·
`SYMBOL-FUNCTION` redefinition or arbitrary image mutation · replacement of the
Form /0 implementation · callers bypassing Form /0 and invoking host functions
directly · compromised Lisp implementations or process memory.

**Trusted computing base:** the Common Lisp implementation, the loaded Form /0
implementation, its package-owned descriptors and handlers, and the host
orchestration code that invokes the public protocol.

Stated in the runner banner, the work order, the package header and the closure:
**a public-API enforcement boundary, not process isolation.** Carried as `S-1`
in the audit — labelled *scope*, not *hole*.

Option (b) **rejected** — an assertion about behaviour is not enforcement.
Option (a) **deferred** to a separate lane, and not silently preserved through
any Candidate /0 export.

## 6. The corrected identity ledger

The doctrine said the subject is stable across phases. The printed values
already disagreed. Instantiation is precisely where the syntax moves.

```
stage           subject form  [T]emplate/[C]losed   phase object
candidate datum 4c50434400300322020f6c69(440)       —
proposed  [T]   4c50434400300322020f6c69(440)       4c50434400300422020f6c69(1040)
instant.  [T]   4c50434400300322020f6c69(440)       (template recorded)
instant.  [C]   4c50434400300322020f6c69(410)       4c50434400300522020f6c69(4658)
  bindings      —                                   4c50434400300222020f6c69(382)
validated       4c50434400300322020f6c69(410)       4c50434400300a22020f6c69(12456)
  val receipt   4c50434400300322020f6c69(410)       4c50434400300a22020f6c69(12474)
realized        4c50434400300322020f6c69(410)       4c50434400300522020f6c69(26020)
  result        4c5043440002(12)                    —
```

`candidate = proposed [T] = instant. [T]` at 440; the closed form is 410 from
instantiation onward. The instantiated phase identity commits to **both** sides
plus the binding identity, so it moves if either the template or the produced
closed form differs.

**The implementation was right; the prose was one adjective from lying.** Only
documentation, diagnostics and the missing teeth changed — no working machinery
was redesigned.

## 7. Tests and mutants added

**Teeth added this round (43):** `T-NO-CALLER-SUPPLIED-BEHAVIOUR` ×6 ·
`T-SUBJECT-TEMPLATE` · `T-SUBJECT-MOVES` · `T-SUBJECT-CLOSED` ×2 ·
`T-SUBJECT-BOTH-SIDES` · `T-SUBJECT-BINDINGS-DIVERGE` ×3, plus the migration of
every environment-building tooth to name-selection.

**Application checks added (2):** instantiation moved the subject; the closed
subject is preserved through validation and realization.

**Public-surface checks added (4):** the four in §4 above.

**Mutant added (1):** `restore-arbitrary-handler` — appends a public
`MAKE-OPERATOR-DESCRIPTOR` taking a handler and exports it, i.e. restores the
exploit. Run against `PUBLIC-SURFACE-AUDIT.lisp`, **killed at the intended
tooth.** The ledger script gained a per-mutant suite selector and now also
requires that `package.lisp` be checked for application, not just `form0.lisp`.

## 8. Exact check counts

```bash
bash verify-form-floor.sh
  PASS  form0-teeth           152 passed / 0 failed     (was 109)
  PASS  de-forma-dormiente     24 passed / 0 failed     (was  22)
  PASS  public-surface         23 passed / 0 failed     (was  19)
  FORM FLOOR GREEN — 3 floors, 199 checks, 0 failed      (was 150)   exit 0

bash verify-language-floor.sh
  LANGUAGE FLOOR GREEN — 11 floors, 654 checks, 0 failed  unchanged  exit 0

bash verify-all.sh
  ALL FLOORS HOLD — 6/6 suites green                      unchanged  exit 0

bash MUTATION-LEDGER.sh
  killed=10  survived=0                                   (was 9/0)  exit 0

sbcl --non-interactive --load PUBLIC-SURFACE-AUDIT.lisp
  23 passed / 0 failed · 1 declared limit (S-1, scope)               exit 0
```

Mutation ledger, `reached` column: **7 at the intended tooth** · **2 at another
marker** (`boundary-accepts-host`, `unfilled-hole-allowed`) · **1 before the
intended tooth** (`literal-descends`, still not evidence for `T-ONE-PASS`).

## 9. No existing language layer changed

```
git status --porcelain          11 files, ALL under language-form-0/
                                plus verify-form-floor.sh
git diff --stat HEAD            627 insertions, 192 deletions — no path outside
                                language-form-0/ and verify-form-floor.sh
verify-language-floor.sh        11 floors · 654 checks · 0 failed   unchanged
verify-all.sh                   6/6 suites green                    unchanged
```

Kernel /0, Core /0, Slice /0, Slice /1, Slice /2, Surface /0 and Canonical
Datum /0 are untouched.

## 10. Also corrected this round

The floor runner still advertised **L-1 and L-2 as open limits** after they were
closed, and earlier in the round it printed *"3 floors"* while executing two. A
CI banner that overstates what it ran, or what remains open, is the defect this
lane keeps finding in itself; both are fixed, and the floor count is now derived
from the verdicts actually produced.

## 11. Standing

Nothing adopted. Nothing frozen. Slice /3 not opened. No new operator, grammar
production, macroexpansion, code-valued hole, persistence or governed
Slice/Core operation. Form /1 not opened — and its entrance gate on
phase-identity growth is recorded in the work order §0.

**Stranger audit still OWED**, against this return too.

Branch pushed. **Not merged.** Mirror not published. Stopping for owner review.

— **Claude Opus 5 (1M context)**, 2026-07-26
