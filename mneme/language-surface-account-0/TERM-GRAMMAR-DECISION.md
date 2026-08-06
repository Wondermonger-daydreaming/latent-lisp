# Surface Account /0 — Term Grammar Decision

**Author:** Claude Fable 5 (JURIST seat); measurements by CARTOGRAPHER /
FABER (Claude Opus 5). Same-family cross-checks, not an independent audit.
**Date:** 2026-08-04. Design document only; nothing here is implemented.

**The question.** Before any Account-owned mint may be implemented (in the
governed /1 successor — `ARCHITECTURE-DOCKET.md` §6), one shared term
grammar must be adjudicated. The commission names two candidates and an
elimination rule. This document applies the rule to the measured evidence
and decides.

---

## 1. What the recommended /0 lineage needs — and deliberately does not need

The recommended native-composite /0 **adopts no term grammar at all**: it
carries native canonical datums unchanged, with species and provenance
explicit. This is not an omission; it is the measured-safe choice:

- The two native grammars do not agree octet-for-octet on one host form
  (Control 5, `controls-transcript.txt`), so there is no "common codec" to
  discover — only one to invent, which would be normalization by another
  name.
- Each native decoder refuses the other's datum; neither has a printed
  fallback; neither INTERNs (Control 5, planted arms). The no-new-grammar
  design therefore **proves, rather than assumes**, that it does not
  normalize foreign native datums through a guessed common codec — the
  commission's fixed control 5 obligation for a no-new-grammar design, and
  it was exercised with teeth.

The grammar decision below therefore governs the **/1 Account-owned mint**,
whose Door 1/Door 2 must encode sources and expansions itself.

## 2. Candidate 1 — pinned Surface /1 codec at grammar version 4

Treated honestly as a **codec dependency**, not as admission to Surface /1's
closed construct table: calling `LISP-PLUS-SURFACE1:ENCODE-TERM` /
`DECODE-TERM` as qualified external functions binds the Account to S1's
grammar-v4 term algebra without enlarging S1's construct vocabulary or
implying S1 observes the Account's heads.

**The commission's elimination rule:** pinned codec reuse requires a public
failure law — *prove that every source and expansion rejection can be
classified through public APIs without broad `CONDITION` capture and
without reaching through `::`* — else eliminate the candidate.

**The contested step, shown.** Surface /1's public codec functions signal
**non-exported** condition classes:

- `surface1.lisp:390` — `(define-condition %term-unrepresentable (error) …)`
- `surface1.lisp:637` — `(define-condition %term-irreconstructible (error) …)`
- `surface1.lisp:554–557` — `ENCODE-TERM`'s **public docstring** says
  "Encode a host FORM under the declared term grammar, or signal
  %TERM-UNREPRESENTABLE" — a public function whose declared failure mode is
  a private class.
- `PROVIDER-API-MATRIX.tsv`: Surface /1 exports exactly **one**
  condition-type, `EXPANSION-REFUSED` — which its own doors, not its codec,
  signal. The codec conditions are not among the 80 externals.

A caller outside `LISP-PLUS-SURFACE1` can classify a codec failure only by
(a) `handler-case` on the private class — which requires naming
`lisp-plus-surface1::%term-unrepresentable` (forbidden `::`) or resolving
the symbol at runtime out of the package's internals (a `::`-equivalent
reach through the package boundary, differing only in spelling); or
(b) `handler-case` on `ERROR`/`CONDITION` — the forbidden broad capture,
which cannot distinguish a grammar refusal from a bug and would translate
unknown predecessor conditions into an Account refusal by catch-all, which
the commission separately forbids. The refusal *codes* the S1 catalog
exposes (`:source-term-unrepresentable` etc., `surface1.lisp:185–230`) are
reachable only through S1's own **doors**, which classify codec failures for
S1's heads — the Account's new heads would never pass through those doors,
so the catalog does not rescue the codec path. (S2's codec is the same shape
one lane over: public `ENCODE-TERM2` signalling non-exported `%TERM2-TROUBLE`,
`surface2.lisp:541, 594` — no refuge there either.)

**And the boundary cannot be repaired:** Surface /1 is closed under its
accepted law and Surface /2 permanently closed at Erratum 0.2; exporting the
condition classes would be a predecessor edit, which is forbidden
absolutely.

**Ruling: Candidate 1 is ELIMINATED** under the commission's own rule, on
measured evidence, with the failure boundary shown. **CONFIRMED by the
owner adjudication, Locked Ruling 3** (verbatim: "Its public functions
expose private failure classes, so lawful external classification would
require forbidden private reach or broad catch-all"). The elimination is
settled law; the /1 commission does not re-litigate it against the same
facts.

## 3. Candidate 2 — a small Account-owned grammar with the predecessor repairs

**Ruling: REQUIRED** (by the elimination of Candidate 1) for any
Account-owned mint. Its contract:

**Kinds.** Exactly the four native kinds — interned symbols, integers,
strings, proper lists — plus `NIL` (as symbol/empty-list per the codec's own
stated law, adjudicated explicitly in the /1 spec, not left to the reader).
Both providers declare exactly these kinds (probe transcript, provider
declarations: `S1/S2 term kinds (SYMBOL INTEGER STRING LIST)`); the Account
grammar does not enlarge the algebra.

**Every other host object class, explicitly adjudicated — all REFUSE, each
with its own typed code, none by catch-all:** uninterned symbols (refuse:
no gensym identity law exists); dotted/improper lists; cycles and shared
structure (global sharing check **before** any recursion — the Errata 0.1
jurisprudence: a CAR-position cycle must refuse, not exhaust the stack);
characters; all non-integer numbers (floats, ratios, complex); vectors,
arrays, hash-tables, structures, CLOS instances; pathnames; packages;
functions and compiled functions; conditions; streams; random-states;
readtables. No printed-object fallback for any of them — a rendering of an
object is not the object (the S1 `%describe-host-object` doctrine:
descriptions reach humans in refusal details, never enter a datum).

**The predecessor repairs, inherited as law, not re-discovered:**

| Repair | Predecessor source |
|---|---|
| Global sharing/cycle check before recursion | S1 Errata 0.1 (`:source-term-shared-structure` catalog note, `surface1.lisp:198–202`) |
| Depth measured iteratively after the tree is proven finite | S1 Errata 0.3 D5 (`surface1.lisp`, encode-term commentary) |
| Package identity: home package recorded; decode answers accessibility vs home distinctly (`SYMBOL-NOT-HOME-IN-NAMESPACE`) | S1 Errata 0.2 (`surface1.lisp:185–230` catalog) |
| Alias/surplus-segment refusal: surplus identifier segments refuse, never discard | S1 Errata 0.3 D3 (`surface1.lisp:645–655` commentary) |
| Decode uses `FIND-SYMBOL` lookup, **never `INTERN`**; absent package / absent symbol / non-home / round-trip mismatch are four distinct refusal facts | S1 Errata 0.1/0.2 (`:source-not-reconstructible` arms) |
| Round-trip after reconstruction: re-encode must equal the stored datum before invocation | S1 Errata 0.3 (round-trip-mismatch publicly reachable) |
| Printed-representation refusal: no reader/printer round-trip anywhere in the grammar | both codecs, Control 5 planted arm |

**Failure boundary (the repair of Candidate 1's defect):** the Account
grammar's refusal classes are **exported, typed, and catalogued** in the
Account package from day one — the grammar is born with the public failure
law its predecessors lack.

## 4. Ceilings — observations, policy proposals, and how boundaries get tested

**Observed this round (observations only, never "needed" ceilings):**
fourteen sources: max depth 4, nodes 47, canonical octets 1511; the twelve
producible expansions: max depth 8, nodes 109, octets 3451
(`probe-transcript.txt`, the `OBSERVED MAXIMA OVER THE FOURTEEN FIXTURES`
block — including its own printed caveat that each STOP hides a larger
unrepresented expansion behind it).

**Proposed policy ceilings for the /1 grammar** — anchored to the question
"what should an account be willing to carry?", not to this fixture set:
adopt S1's declared policy values as the starting proposal, since they are
the only ceilings in the tree with operational history — max source depth
48, max source nodes 20000, max term octets 262144, term depth ceiling 2000
(all read live from S1's public policy accessors this round;
`probe-transcript.txt`, the `PROVIDER DECLARATIONS AS READ IN THIS IMAGE`
block). These are Account-owned policy
declarations with their own identity/version, **not** an inheritance and not
a compatibility claim; /1 may move them under its own version law.

**How a later round tests the boundaries** (so the ceilings are teeth, not
prose): planted fixtures at ceiling−1, at ceiling, and at ceiling+1 for each
of depth/nodes/octets; the +1 arm must draw the exact typed refusal code
(`…-exceeded`), the −1/at arms must mint; a ceiling whose breach arm has
never fired is untested, not passing (the Control discipline). The fixture
maxima above sit far below every proposed ceiling, which is exactly why they
must never be promoted into ceilings: they measure these fourteen forms,
not the domain.

## 5. The two shared-structure STOP cases, handled explicitly

`DERIVE-CASE` and `DERIVE/2-CASE` under `:macroexpand` expand into trees
with 3 shared conses (from `CL:HANDLER-CASE`) and 13 uninterned symbols
(`probe-transcript.txt`, the `CASE 11` and `CASE 12` blocks). **These two
outcomes are RATIFIED as the lawful current composite outcomes by the owner
adjudication, Locked Ruling 2** — both heads remain admitted and
requestable; the native retained refusal with
`invoked-no-completion-account` standing is the truthful outcome; no
completed account exists for either. Adjudication:

1. **Under Candidate 2 the same two cells refuse for the same two reasons**
   — sharing and uninterned symbols are both outside the grammar by its own
   law (§3). An Account-owned grammar is not a repair for the STOP cells and
   must never be sold as one.
2. **The commission's stop clause is answered, not tripped.** "If any lawful
   current source or expansion requires an unrepresentable gensym … or
   shared structure, stop. Do not silently drop the head, weaken one
   operation, or manufacture a lossy datum." The composite drops no head and
   weakens no operation: both cells remain requestable, and their lawful
   outcome is a **retained, typed, inspectable refusal** whose fields carry
   the exact cause (`EXPANDED-TERM-SHARED-STRUCTURE`, upstream
   `TermGrammar/SHARED-OR-CIRCULAR-STRUCTURE/term-encode`) and whose phase
   (`PERFORM`) records that invocation occurred
   (`invoked-no-completion-account` standing). No lossy datum is
   manufactured — no datum is manufactured at all.
3. **The only true repair is a bigger grammar** — gensym identity plus
   DAG/sharing representation — which carries its own aliasing and equality
   jurisprudence and is **not recommended** here and not commissioned. If an
   owner ever wants those two cells to complete under `:macroexpand`, that
   is a new grammar commission, opened on its own evidence, not a rider on
   this one.

## 6. Decision summary

| Layer | Grammar | Standing |
|---|---|---|
| /0 native composite | none — native datums carried unchanged, species explicit | recommended; Control-5-proven no-normalization |
| /1 Account-owned mint | Account-owned grammar per §3–§4; pinned S1 codec **eliminated** per §2 | returned contract; implemented never in this round |
| STOP cells | refuse under every commissioned grammar; retained refusal is the lawful account outcome | named claim limitation, lane-wide |

— Claude Fable 5 (JURIST, Surface Account /0 opening round), 2026-08-04
