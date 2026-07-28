# ERRATA 0.3 — DEFECT LEDGER AND VERSION RULING

*Written and committed BEFORE implementation, per the owner's authorization of
2026-07-28. Controlling record:
`audits/2026-07-28-stranger-audit/STRANGER-AUDIT-RETURN.md` (immutable).
This ledger maps every audit headline to its authorized repair; the
`pre-repair` and `post-repair` columns are filled by execution as the work
proceeds and this file is amended in place on the errata branch.*

```
subject at start    branch surface1-errata-0.3 from abab93aa (== origin/main)
subject files       byte-identical to frozen 9b3436182c0e40c56987c77385608aef9d1f04f5
                    (verified: git diff 65782d5c..HEAD on the subject, audits/ excluded, empty)
audit commits       07be7374 · 135b834d — both verified in history
do-not-touch        audits/2026-07-28-stranger-audit/ · ~/freezer/* · Surface /0 semantics
```

---

## VERSION RULING — WRITTEN BEFORE IMPLEMENTATION

```
grammar    3 -> 4
procedure  3 -> 4
policy     1 -> 1   (unchanged)
```

**Grammar moves to 4** because the public encode/decode behaviour and the
sanctioned description of the decode relation change: (a) the decoder will
refuse surplus identifier segments it previously truncated silently (D3/%SEG —
the set of admissible data narrows); (b) the raw public term functions gain a
declared, introspectable term-depth ceiling checked before recursion (D5 — the
set of terms the raw functions process narrows); (c) the correspondence's
published description (injectivity, reachability of the round-trip mismatch)
is corrected (D1/D3). Under the layer's own Errata 0.2 §5 rule — the grammar
is the correspondence, and a grammar whose sanctioned set moved must move its
version — all three force the move.

**Procedure moves to 4** because occurrence/receipt construction and temporal
binding change: requests and receipts capture and store the governing
grammar/procedure/policy versions at mint time; receipt accessors answer from
stored values, not ambient package state; the receipt identity composition
gains the mint-time procedure binding; `:PROCEDURE-VERSION-MISMATCH` becomes a
comparison of two independently sourced values (Door-1-captured vs live at
mint). A procedure that stores what its predecessor did not, and refuses a
between-doors upgrade its predecessor could not detect, is a different
procedure.

**Policy stays 1** because no ceiling value or policy number changes. The
depth-48 / nodes-20000 / octets-262144 ceilings are untouched; D1 repairs the
*description* of their interaction, not their values. (The new raw-function
term-depth ceiling is a grammar-level property of the public checking
functions, declared under the grammar version, not a policy number governing
the doors.)

If implementation forces a different ruling, the deviation and its reason will
be recorded here before the deviating commit.

---

## THE LEDGER

Legend: **witness** = smallest executable witness (audit's immutable probe,
with its errata-0.3 re-expression); **pre** = confirmed pre-repair result
against the unmodified candidate (filled by execution, transcripts under
`errata-0.3/pre-errata-evidence/`); **repair** = authorized repair;
**version** = version consequence; **post** = post-repair regression home;
**disposition** = final state (filled at close).

### D1 — `:EXPANDED-NODES-EXCEEDED` advertised "MEASURED UNREACHABLE," publicly reachable

- **finding:** RETURN D1; TABULARIUS C-1; FOSSOR §2 F1.
- **witness:** `audits/…/probes/TABULARIUS/probe-C.lisp` (N=2491 symbol premises);
  `audits/…/probes/FOSSOR/P2d-minimal-N.lisp` (N=2493 integer premises).
- **pre:** CONFIRMED — see PRE-REPAIR REPRODUCTIONS below and `pre-errata-evidence/`
- **owning mechanism:** `+refusal-catalog+` entry (reachability field + note),
  `surface1.lisp:202-213`; certified by selftest M4/M6.
- **repair:** reclassify to `:public-api`; delete every "measured unreachable /
  another ceiling always fires first / ~120 octets / never approach 20000"
  claim; replace M4/M6 with an executable public witness (Door 1 accepts,
  Door 2 refuses exactly `:EXPANDED-NODES-EXCEEDED`); record the actual
  measurement (amplification is construct-dependent, ~4.0× for
  `DEFINE-JUDGMENT-SCHEMA`; threshold not universal). Guard itself untouched.
  No ceiling moved.
- **version:** contributes to grammar 3→4 (published correspondence
  description corrected).
- **post:** new selftest M4 (executable witness); REPRODUCTION-III V-D1.
- **disposition:** CLOSED — see the DISPOSITIONS table at the foot of this file

### D2 — uncaught host `TYPE-ERROR` on compound-`TYPE-OF` types through the public API

- **finding:** RETURN D2; PERSCRUTATOR NOVEL-crash.
- **witness:** `audits/…/probes/PERSCRUTATOR/CRASH.lisp`;
  `audits/…/probes/CHAIR/probe-crash-verify.lisp`.
- **pre:** CONFIRMED — see PRE-REPAIR REPRODUCTIONS below and `pre-errata-evidence/`
- **owning mechanism:** `%DESCRIBE-HOST-OBJECT` (`surface1.lisp:323-329`) —
  `(string (type-of object))` on a compound specifier.
- **repair:** repair the helper (not a catch around the door): bounded,
  non-recursive, never prints the rejected object, incapable of turning a
  designed refusal into a host condition — take the head symbol of a compound
  specifier, bound the name. Regressions for `#C(1 2)`, `(vector 1 2 3)`,
  a multidimensional array, through BOTH `REQUEST-EXPANSION` and
  `TRY-REQUEST-EXPANSION`; each must produce the designed refusal.
- **version:** none beyond the grammar move already forced (behavioural fix in
  refusal detail construction; no admissible set change — these inputs were
  always meant to refuse).
- **post:** new selftest checks (N-section); REPRODUCTION-III V-D2a/b/c.
- **disposition:** CLOSED — see the DISPOSITIONS table at the foot of this file

### D3 — `ROUND-TRIP-MISMATCH` publicly reachable; injectivity claim false; `%SEG` truncation

- **finding:** RETURN D3; CHAIR B1/D1-PLN; PERSCRUTATOR H2; TABULARIUS C-6.
- **witness:** `audits/…/probes/CHAIR/probe-door-semantics.lisp` (B1),
  `probe-pln.lisp` (D1); `audits/…/probes/TABULARIUS/probe-E.lisp` (CASE 2
  multi-segment).
- **pre:** CONFIRMED — see PRE-REPAIR REPRODUCTIONS below and `pre-errata-evidence/`
- **owning mechanism:** catalogue note (`surface1.lisp:186-201`), fault-hook
  comment (`:806-812`), `ERRATA-0.2 §2` claims; `%SEG` + `DECODE-TERM` symbol
  branch (surplus-segment truncation).
- **repair:** withdraw "decode is injective for every admissible datum" and
  "NO PUBLIC INPUT REACHES THIS"; catalogue and documents state what happens:
  the public operation can reach the mismatch; it refuses BEFORE
  macroexpansion; nothing is minted; the gate prevents a false edge. Gate
  itself preserved (vindicated). Decoder: validate the exact encoder-produced
  identifier shape (exactly one namespace segment, exactly one path segment,
  for both the KIND and the SYMBOL value identifiers) and refuse surplus
  segments with a typed reason — no silent first-segment truncation beneath
  any claim. Carry executable regressions for both returned mechanisms
  (rename+nickname; ambient-`*PACKAGE*` package-local nickname).
- **version:** grammar 3→4 (admissible decode set narrows; description
  corrected).
- **post:** new selftest O-section checks; REPRODUCTION-III V-D3a/b.
- **disposition:** CLOSED — see the DISPOSITIONS table at the foot of this file

### D4 — evidence runner fail-open for three of five instruments

- **finding:** RETURN D4; FOSSOR §4 F4 (T5–T11).
- **witness:** `audits/…/probes/FOSSOR/teeth/T6-selftest-truncated-no-summary.txt` et al.
- **pre:** CONFIRMED — see PRE-REPAIR REPRODUCTIONS below and `pre-errata-evidence/PRE-REPAIR-D4-D6-OUTPUT-65782d5c.txt`
- **owning mechanism:** `run-surface1-candidate.sh` success condition (exit
  codes only for selftest/stub/application); instruments emit no canonical line.
- **repair:** every instrument (selftest, stub fixture, application,
  reproductions I/II/III) emits ONE canonical machine-readable result line
  from live counters, only after every intended check executed; the runner
  requires process exit 0 AND the exact line with exact expected counts AND
  zero failures, for ALL instruments. Negative teeth controls captured for all
  instruments (clean-boundary truncation, zero-checks run, crash-before-summary,
  renamed/malformed summary).
- **version:** none (harness, not grammar/procedure/policy).
- **post:** runner success condition; `errata-0.3/teeth/` transcripts.
- **disposition:** CLOSED — see the DISPOSITIONS table at the foot of this file

### D5 — public `ENCODE-TERM`/`DECODE-TERM` die on deep acyclic input

- **finding:** RETURN D5; FOSSOR §3 F2.
- **witness:** `audits/…/probes/FOSSOR/P3e-encode-term-stack.lisp`, `P3f…`.
- **pre:** CONFIRMED — encode: `CONTROL STACK EXHAUSTED` at depth 40000;
  decode: **fatal abort, process death** at depth 40000, run in a separate
  process because no handler in the same image could survive it
  (`pre-errata-evidence/PRE-REPAIR-D5-OUTPUT-65782d5c.txt`)
- **owning mechanism:** `%SHARED-CONS-COUNT` (recursion per CAR level),
  `%ENCODE-TERM-1` and `DECODE-TERM` (recursion per list level).
- **repair:** declared grammar-level term-depth ceiling for the raw public
  functions — declared, introspectable (exported reader), symmetrical (same
  bound, host-term side and datum side), checked BEFORE recursion by iterative
  traversal, edge-tested at ceiling and ceiling+1, versioned under grammar 4.
  `%SHARED-CONS-COUNT` rewritten iteratively (explicit work stack) so the
  sharing/cycle refusal cannot itself exhaust the stack. Order on encode:
  sharing/cycle check (iterative, terminates on any input) → depth check
  (iterative, tree guaranteed) → bounded recursion. Decode: iterative,
  memoized depth measure over the datum (DAG-safe) → bounded recursion. Door
  behaviour unchanged (policy ceiling 48 fires far earlier). No
  `STORAGE-CONDITION` catching; the death is not moved, it is removed below
  the declared bound and refused above it.
- **version:** grammar 3→4 (raw-function admissible set narrows, declared).
- **post:** new selftest checks (edge at ceiling / ceiling+1, deep-refusal both
  functions, cycles/sharing unchanged); REPRODUCTION-III V-D5a/b.
- **disposition:** CLOSED — see the DISPOSITIONS table at the foot of this file

### D6 — evidence label detached from measured content

- **finding:** RETURN D6; FOSSOR §6 F6; TABULARIUS E-2.
- **witness:** `audits/…/probes/FOSSOR/teeth/EV-*` (byte-identical transcripts,
  two subjects, one label).
- **pre:** CONFIRMED — audit transcripts + `pre-errata-evidence/PRE-REPAIR-D4-D6-OUTPUT-65782d5c.txt`
- **owning mechanism:** `run-surface1-candidate.sh:37` (`git rev-parse HEAD`
  fallback); no content digest anywhere in the evidence.
- **repair:** deterministic content-derived subject digest over an exact-path
  manifest (`errata-0.3/SUBJECT-MANIFEST.txt`) covering the exact source
  inputs and dependency closure the instruments load; per-file SHA-256 bound
  to its path with unambiguous framing (fixed-width digest + explicit path,
  newline-delimited; no raw concatenation), digest of that manifest rendering
  = the subject-content digest; computed outside git; missing member = hard
  fail; generated transcripts excluded by exact path; printed in every
  evidence header; bound into each canonical result line. Human label retained
  as explicitly advisory. Demonstrations: same bytes → same digest; one
  behavioural byte change → different digest; same HEAD + dirty tree →
  different digest; different label → same digest. Freeze/runner docs name the
  expected-to-change transcripts.
- **version:** none (evidence identity, not grammar/procedure/policy).
- **post:** digest demonstrations under `errata-0.3/`; runner header;
  canonical lines carry `subject=<digest-prefix>`.
- **disposition:** CLOSED — see the DISPOSITIONS table at the foot of this file

### D7 — vacuous version alarm; receipt accessors answer the live package

- **finding:** RETURN D7; FOSSOR §5 F5; CHAIR E5 exhibit.
- **witness:** `audits/…/probes/FOSSOR/P5-temporal.lisp`.
- **pre:** CONFIRMED — see PRE-REPAIR REPRODUCTIONS below and `pre-errata-evidence/`
- **owning mechanism:** `%MINT-RECEIPT` (`(or hook (expansion-procedure-version))`
  vs `(expansion-procedure-version)`); constant-function accessors
  (`surface1.lisp:792-801`); no version slots.
- **repair:** real value binding. Requests capture grammar/procedure/policy
  versions (and identities) at Door 1 in read-only slots; receipts capture the
  mint-time (Door 2) values in read-only slots; public receipt accessors
  return STORED values; the receipt identity composition includes the
  mint-time procedure binding; `:PROCEDURE-VERSION-MISMATCH` compares the
  Door-1-captured version against the live-at-mint version — two independently
  sourced values; a between-doors upgrade now refuses. The fault hook replaces
  one side of a genuine comparison (legitimate). Demonstrations: an old
  receipt keeps reporting its minted version after a live bump; identity
  coherent; planted mismatch fires; production gate compares two real values;
  no semantic authority acquired.
- **version:** procedure 3→4 (construction and temporal binding change).
- **post:** new selftest checks; REPRODUCTION-III V-D7.
- **disposition:** CLOSED — see the DISPOSITIONS table at the foot of this file

### D8 — self-certifying checks: the full TABULARIUS F-1…F-17 inventory

- **finding:** RETURN D8; `findings/TABULARIUS.md §1` — the complete
  inventory is the controlling list, per the authorization; the per-item
  dispositions are recorded in the companion table
  `errata-0.3/D8-DISPOSITIONS.md` (one disposition per item: replace-with-real
  -predicate / narrow-label / merge / delete / move-to-prose).
- **pre:** CONFIRMED by direct read; tautologies re-confirmed by the chair
- **repair:** per D8-DISPOSITIONS.md; coverage claims measured from actually
  observed refusal codes or narrowed; no filler checks to preserve totals; the
  retracted nondeterminism sentence removed from the live tree; instrument
  helpers required to resolve existing external symbols (no bare `INTERN`).
- **version:** none.
- **post:** repaired suites; live counts re-derived.
- **disposition:** CLOSED — see the DISPOSITIONS table at the foot of this file

### D9 — the RETURN's false self-inventory; stale citations; live pre-errata prose

- **finding:** RETURN D9; TABULARIUS C-3/C-4/C-5, F-17.
- **pre:** CONFIRMED by direct read
- **repair:** `LANGUAGE-SURFACE-1-ERRATA-0.3.md` created (names D1–D9, chosen
  repairs, version movement, before/after evidence, remaining limits); live
  documents corrected by SUPERSESSION notes, never by silent rewrite: the
  "exactly two claims are FALSE" banner corrected; §4(8) E11 citation, §11
  "unfolds shared structure," application-check numbers, "exhaustively" field
  lists all corrected with markers; Errata 0.2's defeated reachability and
  injectivity claims marked superseded IN PLACE in the current tree's copy of
  the claims (the errata document itself gains a header note, its body
  preserved); "exact source form = exact term under the declared grammar"
  stated; account/authentication boundary untouched. The stranger-audit
  return is never edited.
- **version:** none.
- **post:** document diffs; ERRATA-0.3.md.
- **disposition:** CLOSED — see the DISPOSITIONS table at the foot of this file

---

## PRE-REPAIR BASELINE (custody figures, not preserved counts) — FILLED

```
selftest 115/0 · stub 8/0 · application 24/0
reproduction I  verdicts=6 confirmed=0      reproduction II verdicts=4 confirmed=0
runner exit 0
```

## PRE-REPAIR REPRODUCTIONS — FILLED BY EXECUTION

```
PRE-REPAIR-RESULT verdicts=8 expected=8 confirmed=8   (D1 · D2a/b/c · D3a/b/c · D7)
D5 encode 40000 -> CONTROL STACK EXHAUSTED (catchable)
D5 decode 40000 -> fatal abort, process death (UNCATCHABLE)
D4 witness: 35 of 115 checks ran, no summary line, runner exit 0
D6 witness: two subjects, one label, byte-identical transcripts
```
Transcripts: `pre-errata-evidence/`.

## POST-REPAIR — FILLED BY EXECUTION

```
runner exit 0 · 173 checks / 0 failed · 22 verdicts / 0 confirmed
teeth 43 planted faults, 0 holes · digest agreement 1 across six instruments
form floor 199/0 · language floor 654/0 · ten predecessor trees: zero diff
```

## DISPOSITIONS — FINAL

| finding | disposition |
|---|---|
| D1 | CLOSED — reclassified `:public-api`, retracted note deleted, M4/M6 replaced by an executable public witness; guard unchanged, no ceiling moved (REPRODUCTION-III D1c is inverted and would fire if one had been) |
| D2 | CLOSED — helper repaired; all three types reach the designed refusal through both doors |
| D3 | CLOSED — both claims withdrawn and marked; surplus segments refused; gate preserved and now field-proven by public input |
| D4 | CLOSED — six instruments emit canonical lines from live counters; runner requires exit 0 + exact line + self-consistent counts + zero failures + digest agreement; 43 planted faults, 0 holes |
| D5 | CLOSED — iterative sharing check, declared symmetrical ceiling enforced before recursion on both sides; fatal decode abort removed, verified to 500k levels |
| D6 | CLOSED — content-derived digest over a 25-member traced manifest, computed independently by each instrument; four demonstrations filed |
| D7 | CLOSED — versions captured and stored at both doors; accessors read stored values; alarm compares two independently sourced operands |
| D8 | CLOSED for the returned inventory (F-1..F-17 + M4/M6), **with a named open limit**: the class re-opens on every move of `surface1.lisp` and nothing detects it |
| D9 | CLOSED — banner corrected, four unmarked false claims marked in place, term-granularity ruling written into `package.lisp` |

## DEFECTS FOUND IN THE REPAIRS THEMSELVES (all caught pre-publication)

1. ceiling not symmetrical (deepest encodable term would not decode) — fixed
2. decode quadratic in depth — fixed by door/body split
3. `:PROCEDURE-VERSION-MISMATCH` left internal-only after D7 made it public — reclassified
4. two chair probe bugs: `EQUALP` on CD/0 octet OBJECTS; a probe matching a retracted claim inside its own retraction

## REGRESSION INSTRUMENT

`errata-0.3/REPRODUCTION-III.lisp` — smallest witnesses for the repaired
classes; BEFORE run against the frozen Errata 0.2 subject must CONFIRM the
applicable defects; AFTER run against Errata 0.3 must report the exact
expected dispositions; fail-closed canonical line; included in the runner.
Verdicts planned: V-D1 (public reach + catalogue field), V-D2a/b/c (three
crash types → designed refusals), V-D3a (rename+nickname), V-D3b (ambient
PLN), V-D3c (surplus-segment datum), V-D5a (deep encode), V-D5b (deep decode),
V-D7 (stored version survives a live bump). Exact verdict counts recorded in
the canonical line; no "zero CONFIRMED strings" counting.

*— Claude Fable 5, errata branch, 2026-07-28. This ledger is amended in place
as execution fills its brackets; the authorization and the audit return are
not.*
