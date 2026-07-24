# SLICE1-KIMI-COLD-AUDIT — CHAIR ADJUDICATION

*Chair: **Claude Opus 5 (1M context)**, 2026-07-24 evening. The seat changed
hands mid-arc: custody of the two earlier deliveries was verified by Claude
Fable 5; this adjudication is Opus 5's, and the handover is recorded here
because attribution should be readable at a glance.*

## CREDIT — the originating contribution is Kimi's

*Recorded at the owner's explicit instruction, and the chair endorses it
without qualification.*

**The resumed Kimi audit seat produced the minimal reproducers that exposed
both confirmed ownership defects.** B1 and B2 are its findings. It was
interrupted by a provider quota wall mid-verdict, came back, finished its own
evaluation rather than letting another seat finish it, and delivered working
attack programs with per-probe expected-vs-observed output — the form of
evidence that makes independent reproduction cheap and disagreement precise.

Nothing downstream erases that. The chair's independent reproduction, the
wider mutable-leaf domain finding (quoted-datum payloads, adjustable strings),
the four-path receipt count, the third escaping payload class, and the whole
repair adjudication are **extensions of Kimi's finding, not replacements for
it.** A chair that reproduces a defect someone else located has confirmed a
discovery, not made one. Where this record corrects the audit's counts, those
corrections are refinements of a true report — the auditor was right about
what mattered and the corrections went in its favor twice.

## THE CHAIR'S ERRORS — all three, recorded at the top where they belong

*Two were accepted by the owner; the third occurred afterward and is logged on
the same terms. They are collected here rather than buried in the sections they
happened in, because an error record a reader has to hunt for is a record
designed not to be read.*

**Error 1 — a mis-typed literal that temporarily concealed a real alias.** The
chair's first reproduction of the quoted-datum string case compared against
`"Zinner"` when mutating `"inner"` at index 0 yields `"Znner"`. The check
returned a spurious clean result. Had it been banked, the chair would have
published a **false all-clear** on an alias that is real. Caught by a direct
`eq` probe; the check is now identity-based and the error is noted in the
artifact rather than edited away.

**Error 2 — a self-contradictory writ.** The chair's instructions to the
repair-builder demanded that all fourteen reproduction checks flip **and**
declared a ceiling under which three of them cannot. TERMINUS treated the
ceiling as governing, refused to overreach, and reported the conflict. **The
contradiction was the chair's; the catch was the builder's.**

**Error 3 — a false claim about the code, asserted to a builder as fact.** The
chair instructed LIMES to enforce the Canonical Datum /0 boundary using
`lisp-plus-cd0:datum-p`, stating as established fact that a proper list of
keywords *is* CD/0 and would pass. **This was invented.** `datum-p` recognizes
CD/0 datum *objects*; it returns NIL for **every** host value, including every
payload lawful today. The chair had read `require-canonical`'s body, seen its
`datum-p` short-circuit, and mistaken a fast path for the gate. As instructed,
the change would have refused `(:quoted-datum (:var :x))` — the very case the
escape exists to protect — while wearing the authority of a chair verification.
LIMES probed it, found the premise false, **stopped rather than implementing a
contradiction**, and reported. Chair-reproduced independently before accepting.

**What the three have in common, and it is not carelessness.** Each was a
*plausible* thing that fit the shape of what was already believed: a string
literal that looked like the mutation, a writ whose two halves each read
correctly alone, an inference from real code read in a real file. This is the
§I-f failure mode exactly — *pattern-matching from memory feels like knowledge;
only the read confirms it* — and the third is its worst form, because the chair
was **quoting a file it had actually opened.** Reading a function is not the
same as reading what it does.

**The structural point worth keeping.** All three were caught by **someone
else**, twice by workers the chair itself commissioned and instructed. The
chair did not catch a single one of its own. That is the lab theorem in its
plainest form — *you cannot grade your own mirror* — and it held even when the
mirror was writing the instructions.

**Process note, from the same builder (a fourth catch, not a chair error but a
chair assumption).** LIMES observed that while it worked under an explicit
instruction *"do not git commit — the chair commits,"* an automated checkpoint
hook (`.claude/hooks/continuity/session-checkpoint.sh`) committed the
in-progress tree anyway, sweeping in two chair documents the builder never
touched. The builder ran no writing git command. **The lesson is the lab's own
doctrine arriving from the unexpected side:** *who commits* was a guarantee the
chair wrote as **prose in a prompt**, and prose in a prompt is the weakest form
of a guarantee — here it was overridden not by a disobedient agent but by the
environment itself. If commit-ownership during agent work matters, it belongs in
the hook's own conditions, not in a sentence an agent is asked to honor. The
builder's baseline was unaffected: its pre-repair scratch copy was taken before
the checkpoint fired and was diff-verified byte-identical to the true parent
commit.

**Layer discipline (required by the owner's relay).** Every statement below is
tagged by provenance. **[K]** = Kimi's delivered evidence. **[C]** = chair
reproduction, run by this chair's own hand. **[A]** = authorial
classification — the chair's ruling. **[R]** = authorized repair.
**[V]** = post-repair verification. Nothing crosses a layer silently.

---

## 0. Custody and identity — ALL PASS **[C]**

| Check | Expected | Observed (chair hand) | Verdict |
|---|---|---|---|
| Sidecar SHA-256 | `5b0d9903…c31027` | identical | PASS |
| Sidecar exact bytes | hash + 2 spaces + name + final LF | `cat -A`: exactly that, no CR | PASS |
| ZIP byte count | 84600 | 84600 | PASS |
| ZIP SHA-256 | `97405e07…67901` | identical; `sha256sum -c` OK | PASS |
| Member count | 34 (31 files + 3 dirs) | 34 = 31 + 3 | PASS |
| Top-level dir | `SLICE1-KIMI-COLD-AUDIT-2026-07-24/` | single, exactly that | PASS |
| `unzip -t` | PASS | "No errors detected" | PASS |
| Internal `SHA256SUMS.txt` | 29/29 | 29/29 OK | PASS |
| Audited-tree manifest | 33 files | **33/33 OK** vs a fresh worktree at `8d9cbf1b` | PASS |
| Thin bundle | contains `8d9cbf1b`, requires `ae4e79ee` | **verified by the chair's own run** inside a repo holding the prerequisite; complete-history flag absent as expected for a thin bundle | PASS |

The packet's stored `evidence/bundle-verify.txt` was **not** used as a
substitute; the chair ran `git bundle verify` itself, as instructed.

Extraction into a fresh isolated directory (`/tmp/chair-kimi-cold/`).

## 1. Semantic-drift standing — DRIFT PRESENT, IMMATERIAL, AND SELF-INFLICTED **[C]**

Live `origin/main` is **`bd9788be`** (now `872f01a` after tonight's later
commits), **27 files ahead** of the audited `8d9cbf1b`. Every one of those 27
files is a **custody record this lab committed tonight** — the Codex stranger
chair-verification, the Kimi interrupted-custody verification, the continuation
relay draft, and the adopted stranger packet. Verified by exclusion: filtering
the changed-file list for anything outside
`language-slice-1/SLICE1-*` and `language-slice-1/stranger-implementation-codex/`
returns **empty**.

Semantic paths, checked individually: `slice1.lisp` **IDENTICAL** ·
`slice0.lisp` **IDENTICAL** · `LANGUAGE-SLICE-1-CHARTER.md` **IDENTICAL**.

**Ruling [A]: no material drift.** The audited commit and today's remote differ
only by this lab's own custody bookkeeping. The drift is the public mirror
working correctly (one-way auto-sync from lab commits), not neglect. The
audit's conclusions apply unchanged to current `main`.

## 2. Baseline suites — ALL FIVE REPRODUCE **[C]**

Chair-run in a fresh detached worktree at `8d9cbf1b`, SBCL 2.4.6
(operation-checked via `(lisp-implementation-version)` before the runs — the
2026-07-20 wrapper-misbind scar):

| Suite | Kimi reported **[K]** | Chair observed **[C]** |
|---|---|---|
| `slice1-selftest` | 50 passed / 0 failed | **50 passed, 0 failed** |
| `SMOKE-1` | 9/9 | **9/9, 0 failed** |
| `de-praemissis` | 12/12 | **12/12 behaviors demonstrated** |
| `de-admissione-datorum` | 14/14 | **14/14 behaviors demonstrated** |
| `MULTIPLICITY-REPAIRED` | 16 expect-checks | **16 expect-checks held** |

All exit 0. Kimi's baseline reporting is accurate.

---

## 3. Finding B1 — mutable-leaf detachment: **CONFIRMED, and BROADER than reported**

### Kimi's claim **[K]**
Mutable strings supplied through a proposition or derived conclusion remain
shared with the stored normal form; mutation rewrites a granted receipt, in
both the caller-input and the reader-result direction; `copy-tree` detaches
cons structure but not mutable string leaves.

### Chair reproduction **[C]**
The delivered `testing-a.lisp` reproduces verbatim under the chair's hand
(A2/A2b/A2c all as reported). The chair additionally wrote an **independent**
battery from the API — not copied from the auditor —
(`CHAIR-REPRO-B1-B2.lisp`, banked pre-repair at commit `9057294c` with its
receipt): **14 checks, 14 matches, 0 divergences.** Both directions confirmed
separately:

- **caller input → stored receipt:** a granted receipt's conclusion changed
  from `(:x "V1")` to `(:x "Z1")` after mutating a caller-held string, *after
  the grant*.
- **public reader result → stored receipt:** mutating a leaf inside the value
  returned by `derivation-receipt-conclusion` (a documented defensive-copy
  reader) rewrote storage to `(:x "Q1")`.

### The complete admitted mutable-leaf domain **[C]** — *the relay's precondition, answered*

The relay forbade authorizing a string-only repair before this was known. It
was right to. From `%validate-value` (`slice1.lisp:168-195`) the admitted
grammar is: keywords, integers, **non-empty strings**, proper lists thereof,
`(:var KW)` in patterns only, and `(:quoted-datum FORM)` whose payload is
declared *"never walked or interpreted."* Probed:

| Ingress | Shared with storage? | `normal-form-p` |
|---|---|---|
| string at an ordinary leaf | **YES** | T |
| **adjustable** string (length-mutable) at an ordinary leaf | **YES** — stored value can be *shortened* | T |
| string inside `(:quoted-datum …)` | **YES** — `eq`-confirmed | T |
| **vector** inside `(:quoted-datum …)` | **YES** | **T** |
| **hash-table** inside `(:quoted-datum …)` | **YES** | T |

**Ruling [A]: the mutable-leaf domain is NOT strings-only.** There are two
ingresses: the validated string leaf, and the **by-design opaque
`(:quoted-datum …)` payload**, which admits arbitrary mutable objects because
the validator declines to walk it. A string-only repair would close one and
read as closure of both.

### Classification **[A]: IMPLEMENTATION DEFECT — CONFIRMED**

Not a documentation matter. Two reasons, both from the bytes:

1. **The chokepoint documents a false premise.** `slice1.lisp:242-243`:
   *"Atoms (keywords, integers, **strings**) are **immutable value nodes** and
   are shared."* Common Lisp strings are mutable. The code states its
   reasoning and the reasoning is wrong.
2. **A public promise is falsified.** `LANGUAGE-SLICE-1-API.md:40`: *"A caller
   cannot revise a registered schema or a past receipt through a [returned
   value]."* The chair's B1.3 does exactly that, through a documented
   defensive-copy reader.

**Lineage note [A]:** B1 and B2 are the **residue of AUDIT-1's own repairs** —
repair 1 (structural copy) cured this defect class at *cons* granularity;
repair 2 (defensive-copy readers) cured it at *spine* granularity. Kimi found
what those two repairs did not reach: the leaf and the constructor. That is a
compliment to AUDIT-1's diagnosis and a correction of its depth.

### Smallest correct detachment operation, and where it applies **[A]**

An internal `%copy-value` = `copy-tree` + `copy-seq` on string leaves
(`copy-seq` also normalizes adjustable/displaced strings to simple strings,
closing the length-mutability path). Applied at:

- **1 ingress:** `%normal-form` (`slice1.lisp:249`) — the declared *"ONE
  construction chokepoint."*
- **12 egress readers** currently using `copy-tree`:
  `proposition-pattern-normal-form` (299) ·
  `premise-assessment-premise-pattern` (599) ·
  `premise-assessment-ground-instance` (601) ·
  `premise-assessment-mismatched-candidates` (603) ·
  `premise-assessment-binding-environments` (605) ·
  `premise-assessment-ambiguities` (607) ·
  `derivation-receipt-conclusion` (647) · `derivation-receipt-bindings` (648) ·
  `derivation-receipt-strongest-lawful-result` (650) ·
  `derivation-receipt-repair-options` (652) ·
  `derivation-receipt-complete-binding-environments` (659) ·
  `derivation-receipt-uniqueness-conflicts` (661).

**Declared residual ceiling [A] — must travel with the repair, never be
implied away:** a `(:quoted-datum …)` payload that is neither a cons nor a
string — a vector, hash-table, struct, adjustable array — **remains
caller-owned and is NOT detached.** Walking it would contradict the declared
opacity and is impossible in general. The repair must say so in the code.

---

## 4. Finding B2 — schema constructor input ownership: **CONFIRMED**

### Kimi's claim **[K]**
`judgment-schema` retains caller-owned list spines for `:premises`, `:locals`,
`:unique-locals`; post-registration mutation changes registered behavior,
including erasing a declared uniqueness constraint so an expected ambiguous
result becomes a grant.

### Chair reproduction **[C]** — each slot separately, as instructed

| Slot | Result |
|---|---|
| `:unique-locals` | declaration rewritten to `(:wiped)` post-registration **and** the behavioral consequence confirmed: two conflicting `:tag` values **GRANTED** with `conflicts=NIL`, where the declaration would have made it ambiguous |
| `:premises` | registered premise silently became `:ev-b` after `(setf (car …))` on the caller's spine |
| `:locals` | declaration rewritten to `(:wiped)` post-registration |

Mechanism, read from source: `judgment-schema` passes the caller's lists
directly to `%make-judgment-schema` (`slice1.lisp:497-500`). The struct slots
are `:read-only t` — **which protects the slot, never the list structure.**

### Is shallow `copy-list` snapshotting sufficient? **[A] — YES, given B1's cure**

Determined from the element grammar, not assumed:

- `:locals` / `:unique-locals` are validated as **lists of keywords**
  (`slice1.lisp:458-461`) — elements immutable ⇒ **spine copy is total.**
- `:premises` elements are `proposition-pattern` structs with `:read-only t`
  slots ⇒ spine copy detaches the spine; the residual path is a mutable
  **string inside a premise pattern's normal form**, which the chair confirmed
  separately (check B2.R) and which belongs to **B1's** cure, not B2's.

So: **shallow `copy-list` at construction is the correct and sufficient B2
repair.** No deep copy of premise structs. The two defects compose exactly.

### Classification **[A]: IMPLEMENTATION DEFECT — CONFIRMED.**
Same falsified public promise as B1 (`API:40`), plus the multiplicity law M9
(*"mutating the unique-locals declaration cannot revise registered schema
behavior"*) which was tested **only on the reader path** and holds there while
failing on the constructor path.

---

## 5. Finding B3 — receipt scope: **DOCUMENTATION ERRATUM, with a docketed capability question**

### Kimi's claim **[K]**
`schema-not-found` and `unbound-conclusion-variable` carry
`slice1-condition-receipt` = NIL despite language saying a receipt is issued on
every attempt / every path.

### Chair finding **[C] — the auditor UNDERCOUNTED: there are FOUR, not two**

Reproduced live; `derive`'s un-receipted exits are:

| Path | Signalled at | Receipt |
|---|---|---|
| `pattern-used-as-ground` | `slice1.lisp:954` | **NIL** (not reported by Kimi) |
| `schema-not-found` | `slice1.lisp:955` | NIL |
| `malformed-structured-proposition` (malformed `:conclusion`) | `slice1.lisp:956` | **NIL** (not reported by Kimi) |
| `unbound-conclusion-variable` | `slice1.lisp:961` | NIL |
| `derivation-refused` (both sites) | 944 / 1014 | **PRESENT** |

The receipt is constructed at `slice1.lisp:979-999`, after all four exits.
**No tooth anywhere asserts receipt-presence on a non-`derivation-refused`
condition** — all 8 read sites sit inside `derivation-refused` handlers.

### The governing chain **[C]**
The promise appears **nine times unqualified** — charter §6 heading and body,
charter §7 step 5, `API:332`, `API:399`, `GUIDE:280`, `CLOSURE:20`,
`ARCH:175`, plus the code's own `ALWAYS` at `slice1.lisp:854` and `950`.
Exactly **one** scoping gloss exists in the whole corpus: a four-word comment
in a specimen disposition (`DE-PRAEMISSIS-DISPOSITION.md:19`, *"both derive
paths"*). Neither delta narrowed it; `CHARTER-DELTA-1`'s Errata block — the
lane's designated instrument for code-forced departures — does not mention it.

### Ruling **[A]: DOCUMENTATION ERRATUM.**

Two contemporaneous structural indications establish that the authors'
operative sense of "attempt" was *a derivation that reached assessment*, not
*any invocation of `derive`*:

1. **The API contradicts itself, and the specific beats the general.** The same
   document that says "on every path" (`API:332`) carries a per-condition table
   (`API:519-531`) that marks receipt-carriage on **exactly one row** —
   `derivation-refused`. `schema-not-found` and `unbound-conclusion-variable`
   are listed there as `derive` signallers with **no receipt annotation.**
2. **The charter's own step ordering** puts issuance at step 5, after schema
   resolution (step 1) and conclusion binding (step 2).

Against ruling it an implementation defect: two of the four paths
(`pattern-used-as-ground`, malformed conclusion) are **genuinely pre-receipt** —
no lawful conclusion normal-form exists to record, so no meaningful receipt is
constructible.

**But the erratum must not launder the other two.** For `schema-not-found` and
`unbound-conclusion-variable` a receipt **is** constructible on the document's
own field semantics — `API:405` defines the receipt's schema-name field as the
**requested** name. So:

- **[R] In scope now:** an erratum amending all nine unqualified statements to
  the true scope, and it must name **all four** paths, not the two reported.
- **[A] Docketed, NOT repaired tonight:** *should `schema-not-found` and
  `unbound-conclusion-variable` carry receipts, given that they constructibly
  could?* This is a capability question, not a wording question. The relay's
  repair authorization for B3–B5 is **documentation corrections only**, and the
  chair will not expand it. **Owner decision.**

*Chair's note against its own ruling, recorded so a successor can weigh it:
demoting a promise published nine times to "wording" is the shape a cold
flinch takes. The demotion rests on contemporaneous evidence (the API's own
table, the charter's own step ordering), not on convenience — and the half of
the finding that convenience would have swallowed is docketed above rather
than dissolved.*

---

## 6. Finding B4 — quoted-datum boundary: **SLICE /1 CONSTRUCTOR DEFECT (repair docketed)**

### Kimi's claim **[K]**
`(:quoted-datum 1.5)` and `(:quoted-datum some-bare-symbol)` construct in
Slice /1 and satisfy `normal-form-p`, but the frozen Slice /0 boundary refuses
them.

### Chair finding **[C] — THREE escaping payload classes, not two**
Reproduced, and extended: **dotted lists escape as well** —
`(:quoted-datum (A . B))` constructs, `normal-form-p` = T, and is refused at
both `claim :proposition` and `witness :for` with `MALFORMED-SLICE0-SHAPE`.
This matters because `API:111` names dotted lists as a `proposition` refusal in
the same breath as floats.

### The governing chain **[C]**
Slice /1 asserts **universal flow-through five times**, including
post-implementation: `CHARTER:40-46` (*"every structured proposition **is** a
lawful Slice /0 proposition … Backward compatibility is **by construction, not
by adapter**"*), `ARCH:42-45`, `API:32-35`, `API:108`, and the constructor's own
docstring (`slice1.lisp:255-257`). `CHARTER-DELTA-1` Δ5 introduced
`(:quoted-datum …)` with a stated **purpose** (protect var-shaped literals) and
**no stated domain**, and did not reconcile the widening with §1's law. The
Errata block was not used.

**Searched for any text authorizing a deliberately broader intermediate
language** — charter, both deltas, guide, API, architecture, closure, work
order, audit, inventory: **zero hits.**

### Ruling **[A]: SLICE /1 CONSTRUCTOR DEFECT.**
The flow-through invariant is stated as a **law** ("by construction, not by
adapter"), five times, twice after the code existed. Δ5's escape is fully
served by a payload restricted to boundary-lawful values — nothing about
protecting `(:var :x)`-shaped literals requires admitting floats, bare symbols,
or dotted lists. The option "deliberately broader intermediate language" is
**not available on this record**: it appears nowhere and would have to be
legislated *de novo* against five contrary statements. The option "end-to-end
contradiction" is a fair description of the *symptom*, but a contradiction
between a law and an under-specified escape is resolved in favor of the law.

**[R] In scope now:** documentation correction only — the docs must stop
asserting a flow-through universality that is currently false, and must record
the defect and its docket.
**[A] Docketed, NOT repaired tonight:** payload restriction at
`slice1.lisp:174-176` (one clause). A constructor semantic change is outside
the relay's authorized repair list. **Owner decision.**

---

## 7. Finding B5 — already-judged claims as premise support: **CHARTER PROMISE GOVERNING; SILENTLY LEFT UNIMPLEMENTED**

### Kimi's claim **[K]**
The charter says a premise may be discharged by an already-judged claim, while
`derive` filters supports to witnesses and refutations, so a matching verified
claim lands `:missing`.

### Chair finding **[C]**
Confirmed. `slice1.lisp:959-960` filters `supports` into `witnesses` and
`refutations`; `%assess-and-enumerate` touches nothing else; a `claim` is
**silently discarded** — no typed refusal, no assessment field, no receipt
trace. Reproduced: `claim-p` = T, `witness-p` = NIL, decision REFUSED,
disposition `:MISSING`.

The promise is stated **three** times, not once, and two of them are
load-bearing beyond the parenthetical Kimi cited: `CHARTER:119` is the in-code
**definition of the `:satisfied` status** (*"a matching, admissible, accessible
support/judged claim"*), and `CHARTER:155` is a **numbered step of the governed
act**. `CHARTER:93` further imposes a *ground* requirement on judged premise
claims — a constraint that presupposes they are admissible inputs.

### Ruling **[A]: THE CHARTER PROMISE REMAINS GOVERNING; IT WAS SILENTLY LEFT UNIMPLEMENTED.**

The narrowing was **never enacted by any instrument this lane uses to narrow.**
`CHARTER-DELTA-1` supersedes explicitly five times and maintains an Errata
block; neither was used here. The closure never marks it `:not-earned`. No
tooth ever tested it. The only restricting text is two **descriptive**
sentences in the API brief (`API:331`, `API:432`) — in a document that
describes itself as recording what was *proven by executing it*. And decisively:
`ARCH:225-226` **restates the promise unchanged, after implementation, in the
closure sitting's own architecture record.**

Under the lane's own discipline (`WORK-ORDER-1:83-85`: every normative
must/cannot/never names its live enforcement path or is labeled
`[DESIGN-OBLIGATION]`; `CHARTER:6-7`: *"the founding specimen converts them or
they die"*), this obligation was **neither converted nor recorded dead.**

**[R] In scope now:** documentation correction — label the obligation
`[DESIGN-OBLIGATION — unconverted]` at all three charter sites and add a
`:not-earned` line to the closure disposition, using the lane's own instruments.
**[A] Docketed, NOT repaired tonight:** accepting judged claims as supports is
a genuine design decision (which judgment states discharge? does accessibility
apply? what disposition does a *refuted* claim produce?), not a filter tweak.
**Owner decision.**

---

## 8. Additional classifications **[A]**

**8.1 — 22 vs 20 unused readers: BOTH COUNTS PRESERVED; they answer different
questions.** The chair's hypothesis is confirmed by independent census: 39
exports unreferenced by the three shipped public programs, 37 unreferenced by
the whole shipped tree; subtracting the same 17 non-field-reader symbols (5
`-P` predicates, 7 condition type names, 3 `slice1-condition-*` readers,
`signal-slice1`, the bare `derivation-receipt` type name) gives **22 and 20
exactly.** The two-symbol difference is named:
`premise-assessment-ambiguities` and
`premise-assessment-binding-environments`, both consumed only by the
multiplicity materials. `CLOSURE:71`'s "22" measures the public-programs
domain. **Both stand; neither supersedes the other.**
*Correction to the packet [C]:* `evidence/specimen-packet-report.log:57` says
"71 symbols" — false; 69 live and 69 textual (the 71 counts two package
designators). The packet contradicts itself, since
`SLICE1-KIMI-FINDINGS-INDEX.md:83` says 69. The **used-set** agrees perfectly;
only the denominator was wrong.

**8.2 — Exported-symbol D-forge: CONFIRMS existence; FALSIFIES the stratum-3
placement.** What is confirmed: the escape is real and grants `:VERIFIED` —
`CLOSURE:28`, `CLOSURE:43-45`, Δ3, and AUDIT-1's refuse-no-repair are all
vindicated as to *existence*, and the closure's `:host-level-closure
:not-earned` survives intact. What is **falsified** is the *classification*:
`ARCH:179-181` places the D-forge in stratum 3, *"Explicit/internal host
escape,"* beside the licensed `::` — the paradigm case of internal access. The
forge is constructible from **exported, single-colon symbols only**, so it sits
inside the region `API:21-22` scopes as *guaranteed*, separated from a governed
program only by the undefined word "well-formed." **[R] Documentation
correction in scope:** re-place the D-forge honestly and stop implying (via
`API:25`) that the ungoverned region is reached by `::`. **[A] Noted:** stratum
1's own definition (`ARCH:175`) embeds the B3 receipt promise, so §5's erratum
touches it too.

**8.3 — Cross-schema support acceptance without mode/kind checking: a
normative term with no live enforcement path.** No document promises mode/kind
matching for premise discharge — but three do assert that a `:satisfied`
premise requires an **admissible** support (`CHARTER:119`, Δ1 law 1,
`API:432`), and **"admissible" is nowhere defined.** The implementation applies
exactly two filters: proposition match and receiver accessibility; `witness-mode`
and `witness-kind` appear nowhere in `slice1.lisp`. This is **the same defect
class as B5, one size smaller** — a normative word carrying no enforcement.
Reading it as merely "accessible + matching" makes `CHARTER:119` say *"a
matching, matching, accessible support."* **[R] Documentation correction in
scope; definition or enforcement docketed for the owner.**

**8.4 — `signal-slice1` and `clear-schema-registry`: split ruling.**
`clear-schema-registry` is **warranted** — listed in the closure's admitted
surface, documented at `API:279-285`, and specimen-referenced, which is
precisely the charter's admission test. `signal-slice1` is **unwarranted on the
record**: exported and API-documented (`API:533-543`), but **absent from the
closure's evidence-based admitted surface** and **referenced by no shipped
program** — against `CHARTER:250-252` (*"names and division earned by runnable
specimen code only"*). Kimi's A12 is confirmed by code: `signal-slice1`
contract-checks only `failed-invariant` and `condition-type`, so `:receipt`
passes through unvalidated. **[A] The export lacks warrant. [R] NOT removed —
export removal is explicitly forbidden by the relay's scope lock.** Documented
and docketed for the owner.

**8.5 — Ground-instance traversal-order dependence: promise honored at every
granularity it was written; ONE over-broad sentence breached.** Order
independence is promised for the **decision** and the **environment set**
(`ARCH:159-161`, Δ2 tooth M3, `CLOSURE:17`) and those hold — M3 itself holds,
which Kimi concedes. Nothing promises order-independence of the recorded
per-premise *fields*. The single breach is `ARCH:165-166`'s unqualified *"no
environment is ever selected by traversal order"* — because `%build-assessment`
does select one, by accumulation order, to instantiate `ground-instance`
(`slice1.lisp:756`, `:779`, from an unsorted `pushnew` list). **[A]
Documentation-level overclaim, not a semantic-law violation. [R] Narrowing
`ARCH:165-166` to match `ARCH:160-161` is in scope; the `%sort-envs`-then-`first`
code change is docketed.**

**8.6 — Deep and circular structure: NO public-contract violation established;
constitutional call for the owner.** No document promises a typed refusal for
*all* malformed input — every refusal statement is an enumerated list. Circular
structure is excluded from the value vocabulary only **extensionally**, via
"proper lists thereof." Searched all Slice /0 and Slice /1 documents for
`depth`/`recursion`/`stack`/`circular`/`cyclic`/`adversarial`: **silent**;
the "finite" language describes the evaluator's search, not the input. The
genuine, narrower finding: **the vocabulary implies an exclusion the validator
never detects** — `%proper-list-p` diverges on a cycle rather than reaching a
verdict. **[A] Filed as a robustness limitation and an open constitutional
question, NOT a breach.** The chair records the strongest argument on the other
side, since it is internal: AUDIT-1 treated this same untyped-crash class as a
**BREACH** when it touched receipt integrity, and this path needs no `::`, no
hostility, and no exotic host behavior — only `*print-circle*` data on the
public surface. **Explicitly OUT of tonight's repair scope** per the relay.

---

## 9. Authorized repair **[R]** — scope, and what was refused

**Authorized and performed tonight (B1/B2 only):**
1. Complete detachment of admitted mutable values at the one ingress chokepoint
   and all twelve egress readers, via an internal `%copy-value`, **carrying the
   declared quoted-datum residual ceiling in the code.**
2. Construction-time `copy-list` snapshotting of `:premises`, `:locals`,
   `:unique-locals`.
3. Bite-before-cure teeth for every confirmed aliasing path.
4. Tightly scoped documentation corrections for the statements B1/B2 falsify.
5. Complete Slice /1 and dependent regression reruns.

**Refused as out of scope, per the relay's boundary** — no new exports, no
export removal, no general API cleanup, no Core /0 change, no Slice /2, no new
features, no guide redesign, no unrelated robustness work.

**Docketed for the owner — NOT performed** (each is a decision, not a fix):
B3's receipt-capability question for the two constructible paths · B4's
quoted-datum payload restriction · B5's judged-claim discharge design ·
8.3's definition of "admissible" · 8.4's `signal-slice1` export warrant ·
8.5's `ground-instance` canonicalization · 8.6's cycle/depth guard.

**Bite-before-cure order was enforced:** the chair's failing reproduction and
its receipt were committed at `9057294c` **before** any repair was written.

## 10. Post-repair verification **[V]**

*Every line below was produced by the chair's own run. The builder's report was
read for its claims and then re-run; nothing here is adopted from it.*

**Repair as built.** An internal `%copy-value` (`copy-tree` + `copy-seq` on
string leaves) at **13 call sites — 1 ingress + 12 egress, exactly the surface
this adjudication specified** (chair-enumerated by enclosing function; the
apparent 16 grep hits resolve to 13 sites + the recursive body + 2 comments).
Zero `copy-tree` remain as code. Constructor snapshots at
`slice1.lisp:541-543` (`:premises`, `:locals`, `:unique-locals`). The declared
quoted-datum ceiling is carried in `%copy-value`'s own docstring, stating the
guarantee exactly: *"no caller-held CONS or STRING is aliased into stored
state,"* **not** *"stored state is immutable against every caller."*

**Scope lock — HELD.** Three files touched, all in `language-slice-1`
(`slice1.lisp`, `slice1-selftest.lisp`, `LANGUAGE-SLICE-1-API.md`). **Zero**
export additions or removals (`%copy-value` is unexported — verified against
the `:export` list). **Nothing** in Core /0, kernel0, canonical-datum, or
Slice /0 was touched. No charter, guide, architecture, or closure edit — those
await the B3/B4/B5 documentation errata, which are separate.

**Teeth bit before the cure.** T18–T26 (10 checks) were run against a
byte-restored pre-repair tree: **50 passed / 10 failed**, each failure's text
captured verbatim. Post-repair: **60 passed / 0 failed**. Evidence:
`_staging/terminus-teeth-evidence.txt` (125 lines). The chair's own battery
was **not modified by the builder** (verified clean) — evidence integrity
preserved.

**Chair reruns, all suites:**

| Suite | Pre-repair | Post-repair (chair hand) |
|---|---|---|
| `slice1-selftest` | 50 passed / 0 failed | **60 passed, 0 failed** (+10 teeth) |
| `SMOKE-1` | 9/9 | **9/9, 0 failed** |
| `de-praemissis` | 12/12 | **12/12** |
| `de-admissione-datorum` | 14/14 | **14/14** |
| `MULTIPLICITY-REPAIRED` | 16 held | **16 expect-checks held** |
| `kernel0-selftest` | — | **33 passed, 0 failed, 59 mutants killed** |
| Slice /0 `SMOKE` | — | **6 ok, 0 failed** |

**Chair battery: 11 of 14 flipped to `<<DIVERGENCE>>`** — every defect gone.
The three that did not flip are **exactly the declared ceiling**, and their
standing is ruled here:

| Check | Status | Ruling **[A]** |
|---|---|---|
| `[06]` quoted-datum **vector** payload shared | unflipped | **Inside the declared ceiling.** Correct behavior, documented, not a residual defect. |
| `[08]` quoted-datum **hash-table** payload shared | unflipped | Same. |
| `[07]` "constructs with a vector payload at all" (`normal-form-p` ⇒ T) | unflipped | **Not a defect and never was** — a domain fact about the admitted grammar. **The chair's own check was mis-framed**, conflating "defect present" with "grammar admits this." It could only flip by changing `%validate-value`, which is out of scope. |

**Chair error, recorded [A].** The builder's writ (written by this chair)
demanded *"expect all 14 to now read `<<DIVERGENCE>>`"* **and** declared a
ceiling under which three of them cannot flip. Those two instructions are
contradictory. The builder treated the ceiling as governing, refused to exceed
scope, and reported the conflict rather than resolving it silently — which is
the correct disposition and the one the writ asked for. **The contradiction was
the chair's; the catch was the builder's.** Recorded rather than quietly fixed,
because a writ that contradicts itself is the kind of defect that otherwise
only shows up as an agent quietly overreaching.

**Verification verdict [V]: the repair is CORRECT, COMPLETE WITHIN ITS DECLARED
CEILING, and SCOPE-CLEAN.** B1 and B2 are cured at every path the chair
reproduced; the residual is declared in code, not implied away.

---

## 11. Standing after this record

Kimi's cold evaluation is **accepted as evidence** at the size its bytes
support. Its central restraint is endorsed: the core Slice /1 semantics
survived the evaluated cases; nothing here authorizes Slice /2, and nothing
here opens a Core /0 successor. Two implementation defects are confirmed and
repaired; three authority-chain findings are adjudicated — **one erratum, one
constructor defect, one unkept promise** — and their code-level consequences
are docketed rather than smuggled into an erratum cycle. The auditor was
corrected in four places, twice in its own favor. This is one bounded erratum
cycle and it closes here.

— **Claude Opus 5 (1M context)**, chair, 2026-07-24
