# CENSUS-SLICE-0 — public-surface census of Lisp+ Language Slice /0

*For the LANGUAGE-SLICES-0-1-SYNTHESIS. Officer: CENSOR-PRIMUS. Read-only;
no byte under `language-slice-0/` was edited. Every load-bearing claim cites
`file:line`. Every count was read from the real files or the live package,
never estimated. Where a verification step is compressed I write "traced,
compressed".*

**Package:** `lisp-plus-slice0` (no nicknames). **Substrate:** SBCL 2.4.6,
operation-checked live this sitting (`(lisp-implementation-version)` = "2.4.6").
**Live external-symbol count:** 161, obtained by `do-external-symbols` over the
loaded package (`sbcl --non-interactive --load slice0-transmissibility.lisp`,
this sitting) — matches the two frozen documents that assert 161
(`LANGUAGE-SLICE-0-API.md:8`; `language-slice-1/SLICE0-DEFECT-RECEIPT-1.md:12`).
Export forms live at `slice0.lisp:38-79` (defpackage `:export`),
`slice0-projection.lisp:20-48` (`export`), `slice0-transmissibility.lisp:34-61`
(`export`). File breakdown: 80 + 38 + 43 = 161 (see §5).

---

## 0. Standing taxonomy used

The synthesis-supplied vocabulary, and how I mapped Slice /0 onto it. Two of
the taxonomy's terms do **not** cleanly apply and I say so rather than force a
fit:

- **Kernel-0 protocol operation** — *no Slice /0 export is one.* Slice /0
  re-exports **zero** kernel0 symbols; its kernel0 dependencies
  (`make-identity`, `make-procedure-descriptor`, `identity=`, `identity-key`)
  stay in package `lisp-plus-kernel0` and are *documented* public deps
  (`LANGUAGE-SLICE-0-API.md:52-84`), not slice0 exports. The nearest thing is
  `reifiable-p`, which *exposes* kernel0's canonical boundary law but is a
  slice0-defined wrapper (`slice0-transmissibility.lisp:87-92`).
- **Mneme continuity-evidentiary operation** — Slice /0 ships **no Mneme
  journal / store**; it ships evidentiary *records* (the three receipts, `why`,
  explanations, `judgment-record`, `derived-result`). Whether those count as
  "Mneme continuity-evidentiary operations" or as language-local
  "inspection-debugging" is a genuine fork the synthesis must rule; I mark the
  whole evidentiary-record family **AUTHORIAL-STANDING-UNRESOLVED** (§1.F) with
  the exact question, rather than guess.

Standings I *do* assign with evidence: **ordinary language form** (base-object
constructors), **consequential language form** (the four governed acts + their
typed-refusal and lawful-repair vocabularies), **deliberate introspection
surface** (`why`/`render-*`/`*-views`/`reifiable-p`), **inspection-debugging
operation** (read-only predicates & accessors), **surface-to-kernel elaboration
form** (`signal-slice0`, `with-slice0-restarts` — the layer's own signalling /
restart-establishment machinery built atop kernel0's condition apparatus).

---

## 1. EXPORT TABLE (all 161 symbols)

"Exercised by" names the shipped programs that touch the symbol: **P** =
`de-promotione/SPECIMEN.lisp` (19/0), **J** = `de-projectione-1/SPECIMEN.lisp`
(17/0), **I** = `de-infando/SPECIMEN.lisp` (30/0), **S** = `SMOKE.lisp` (6/6).
"unexercised" = no shipped program calls that *accessor/symbol directly* in an
assertion (the underlying field may still be exercised internally by an act —
noted where so). Behavior is from code + tests + specimens, never the name.

### 1.A — Base-object constructors — ORDINARY LANGUAGE FORM

| Symbol | Export | Behavior (actual) | Exercised by | Standing |
|---|---|---|---|---|
| `claim` | slice0.lisp:40 | Mint a historical assertion; `commitment :asserted`, `judgment` always `nil` (`slice0.lisp:323-337`) — a claim cannot be born judged. Refuses missing prop/by and non-canonical proposition parts. | P,J,I,S | ordinary language form |
| `witness` | slice0.lisp:40 | First-class support record; **testimony level discipline enforced at construction** — `:mode :testimony` with a non-attribution `:for` is unrepresentable (`slice0.lisp:272-281`). | P,J,I,S | ordinary language form |
| `promotion-procedure` | slice0.lisp:50 | Wrap a kernel0 `procedure-descriptor` + admitted `(mode kind)` pairs (`slice0.lisp:349-358`). | P,J,I,S | ordinary language form |
| `receiver-context` | slice0-projection.lisp:20 | An evidentiary **position**: accessible supports / executable procedures / recognized authorities / accepted representations (`slice0-projection.lisp:61-76`). | J,I,S | ordinary language form |
| `support-store` | slice0-projection.lisp:25 | Build the `identity-key → witness` hash-table `project-claim` consumes (`slice0-projection.lisp:78-82`). | J,S | ordinary language form / library convenience |
| `local-value` | slice0-transmissibility.lisp:34 | Governed **admission** of a host object; `:kind` **computed** (`:closure`/`:datum`), a contradicting caller `:kind` refused — the anti-stringification gate (`slice0-transmissibility.lisp:108-138`). Architecture §6 rules it "not a mere record: the governed admission act" (`LANGUAGE-SLICE-0-ARCHITECTURE.md:106`). | I,S | ordinary language form (semantic constructor per arch §6) |

### 1.B — The four governed acts — CONSEQUENTIAL LANGUAGE FORM

| Symbol | Export | Behavior (actual) | Exercised by | Standing |
|---|---|---|---|---|
| `raise` | slice0.lisp:40 | The checked promotion act. Grants iff proposition-match × mode/kind-admissibility × `:semantic`-procedure authority × receiver-admissibility × polarity all hold (`slice0.lisp:495-686`). Grant returns `(values revision receipt)`, original untouched; refusal **signals** a typed condition carrying receipt+why+restarts. | P,J,I,S | consequential language form |
| `project-claim` | slice0-projection.lisp:26 | Receiver-relative **reconstruction**: target judgment exists only via the receiver's own `raise` over what its position can access/recognize/run; source judgment never copied; loss is receipted residue, never absence (`slice0-projection.lisp:188-368`). Always *returns* `(values claim receipt)`, does not signal on ordinary loss. | J,S | consequential language form |
| `transmit` | slice0-transmissibility.lisp:42 | Governed carry under `:direct`/`:testimony`/`:reproduction`; reifiability decided by the canonical boundary itself, declared transmissibility respected, receiver representation contextual; each alternative a **different lawful act** (`slice0-transmissibility.lisp:355-492`). | I,S | consequential language form |
| `exercise-value` | slice0-transmissibility.lisp:41 | Governed invocation: authorization-gated, returns a **canonical derived result** (+ optional minted witness), never the host object; a non-canonical raw result is refused (no laundering) (`slice0-transmissibility.lisp:169-209`). | I | consequential language form |

### 1.C — Typed refusal vocabulary (13 condition types) — CONSEQUENTIAL LANGUAGE FORM (refusal grammar)

Base is abstract; signal a leaf. Family tree `LANGUAGE-SLICE-0-API.md:731-746`.
Defined `slice0.lisp:105-141` (base + 7) and `slice0-transmissibility.lisp:75-82`
(5). Contract enforced at `signal-slice0`, not in a condition initializer
(inert under SBCL — see §4).

| Symbol | Export | Signaled by / axis | Exercised by | Standing |
|---|---|---|---|---|
| `slice0-condition` | slice0.lisp:67 | abstract base (never signalled directly) | P,J,I,S (via accessors) | consequential language form (refusal grammar) |
| `malformed-slice0-shape` | slice0.lisp:71 | all constructors' shape gate (`slice0.lisp:167-171`) | P,I,S | consequential language form |
| `unsupported-promotion` | slice0.lisp:72 | `raise`: no support / all-refutes / all-supports-when-refuted (`slice0.lisp:502-506,587-604`) | P | consequential language form |
| `wrong-proposition-support` | slice0.lisp:72 | `raise`: witness `:for` ≠ claim proposition (`slice0.lisp:521-542`) | P,S | consequential language form |
| `insufficient-support-kind` | slice0.lisp:73 | `raise`: matched but wrong `(mode kind)` (`slice0.lisp:547-559`) | P | consequential language form |
| `inadmissible-procedure` | slice0.lisp:73 | `raise`: `:per` not `:semantic` (kernel0 K0E-25 one level up) (`slice0.lisp:509-519`) | P | consequential language form |
| `receiver-cannot-access-support` | slice0.lisp:74 | `raise`: all admissible support unreachable by receiver (`slice0.lisp:561-574`) | P | consequential language form |
| `testimony-impossible` | slice0.lisp:74 | family; repair target of `mark-testimony-impossible` | P (repair path) | consequential language form |
| `value-not-reifiable` | slice0-transmissibility.lisp:55 | `transmit` (closure, direct) + `exercise-value` (non-canonical result) (`slice0-transmissibility.lisp:193-198,399-414`) | I,S | consequential language form |
| `direct-transmission-impossible` | slice0-transmissibility.lisp:55 | `transmit` (declared-mute witness) (`slice0-transmissibility.lisp:416-426`) | I | consequential language form |
| `receiver-representation-unsupported` | slice0-transmissibility.lisp:56 | `transmit` (`:to` rejects `:canonical-datum`) (`slice0-transmissibility.lisp:428-439`) | I | consequential language form |
| `exercise-not-authorized` | slice0-transmissibility.lisp:56 | `exercise-value` (context not in `exercise-authorized`) (`slice0-transmissibility.lisp:179-188`) | I | consequential language form |
| `reproduction-procedure-unavailable` | slice0-transmissibility.lisp:57 | `transmit` (`:reproduction`, no recipe) (`slice0-transmissibility.lisp:387-395`) | I | consequential language form |

### 1.D — Lawful-repair vocabulary (12 restart names) — CONSEQUENTIAL LANGUAGE FORM (repair grammar)

Each is a **different lawful act**; none relabels a refusal as success
(`slice0.lisp:644-662`, `slice0-transmissibility.lisp:457-472`). Whitelist is
package state — see host-escape §4.

| Symbol | Export | Act | Exercised by | Standing |
|---|---|---|---|---|
| `retain-current-claim` | slice0.lisp:77 | keep claim unpromoted → `(values nil receipt)` | P | consequential language form |
| `seek-matching-support` | slice0.lisp:77 | re-evaluate with appended witnesses | P,S(guide) | consequential language form |
| `construct-attribution-claim` | slice0.lisp:78 | mint the lawful second-order attribution claim | P | consequential language form |
| `defer-judgment` | slice0.lisp:78 | `(values nil receipt)` + `:deferred` residue | P | consequential language form |
| `retarget-receiver` | slice0.lisp:78 | re-evaluate for a new receiver | unexercised (established, not invoked in asserts) | consequential language form |
| `mark-testimony-impossible` | slice0.lisp:79 | `(values nil receipt)` + `:testimony-impossible` residue | unexercised (established) | consequential language form |
| `export-derived-result` | slice0-transmissibility.lisp:59 | re-transmit the canonical product in `:direct` | I | consequential language form |
| `construct-testimony-claim` | slice0-transmissibility.lisp:59 | return the second-order attribution claim | I | consequential language form |
| `provide-reproduction-recipe` | slice0-transmissibility.lisp:60 | re-transmit in `:reproduction` mode | I | consequential language form |
| `exercise-locally` | slice0-transmissibility.lisp:60 | `(exercise-value subject …)` — use, not transport | I | consequential language form |
| `mint-equivalent-support-at-receiver` | slice0-transmissibility.lisp:61 | receiver-minted support | I | consequential language form |
| `defer-transmission` | slice0-transmissibility.lisp:61 | record deferral | I | consequential language form |

### 1.E — Explanation & view surface — DELIBERATE INTROSPECTION SURFACE

| Symbol | Export | Behavior | Exercised by | Standing |
|---|---|---|---|---|
| `why` | slice0.lisp:40 | The **one uniform** extractor: accepts a why object, any slice0 condition, or **any** governed receipt via the `*why-extractors*` registry (`slice0.lisp:395-407`). The single code-forced surface change of the closure sitting. | P,S | deliberate introspection surface |
| `render-why` | slice0.lisp:40 | Prose derived strictly from `why` fields, never invented past them (`slice0.lisp:409-426`). | P,I,S | deliberate introspection surface |
| `render-projection-why` | slice0-projection.lisp:38 | Prose from `projection-explanation`/`projection-receipt` fields (`slice0-projection.lisp:131-162`). Kept **separate** from `render-why` (arch §6: symmetry not forced where semantics differ). | J | deliberate introspection surface |
| `projection-views` | slice0-projection.lisp:26 | **Composable** feature tags (`:preserved :regraded :redacted :obligation-producing :blocked :ceiling-bound`), never one status symbol (`slice0-projection.lisp:164-183`). | J,S | deliberate introspection surface |
| `transmission-views` | slice0-transmissibility.lisp:42 | Composable feature tags on a transmission receipt (`slice0-transmissibility.lisp:232-248`). | I,S | deliberate introspection surface |
| `reifiable-p` | slice0-transmissibility.lisp:38 | The canonical boundary law **exposed** — `require-canonical` accepts→T / refuses→NIL (`slice0-transmissibility.lisp:87-92`). Arch §6: "retain as public inspector," useful to programs deciding a mode. | I | deliberate introspection surface (kernel-boundary exposed) |

### 1.F — Evidentiary records + accessors — **AUTHORIAL-STANDING-UNRESOLVED**

These are the receipts (issued on **every** attempt, refusals included —
charter §8, `slice0.lisp:371-383`), the structured explanations, the
procedure-bound `judgment-record`, and `derived-result`. They are read-only and
load-bearing (the receipt *survives* refusal by design). **The fork:** are they
**Mneme continuity-evidentiary operations** (evidentiary spine of a continuity
layer) or merely **inspection-debugging operations** (language-local read
surface)? Slice /0 ships no Mneme store, so "Mneme continuity-evidentiary" would
assert a wiring the slice does not build; "inspection-debugging" understates
records the charter makes non-optional.

> **Exact authorial question for the synthesis:** *Does the synthesis treat
> Slice /0's three receipt types + `why`/explanations + `judgment-record` +
> `derived-result` as the language-layer instances of the Mneme
> continuity-evidentiary operation class (and therefore governed by whatever
> continuity/journal law the synthesis sets), or as language-local
> inspection-debugging records with no Mneme obligation? Slice /0 itself is
> silent — it ships the records and no store.*

Pending that ruling, the members (all read-only; predicates are pure
type-tests):

**`judgment-record`** (minted only by `raise`; no public constructor,
`slice0.lisp:300-306`): `judgment-record-p` (slice0.lisp:53),
`judgment-record-judgment` (:54), `judgment-record-procedure-id` (:54),
`judgment-record-procedure-version` (:54), `judgment-record-support-ids` (:54),
`judgment-record-receiver` (:55), `judgment-record-ordinal` (:55). Exercised: P,J
(via `claim-judgment`); `-procedure-version`,`-ordinal` unexercised.

**`promotion-receipt`** (`slice0.lisp:57-61`): `promotion-receipt-p`,
`-claim-before`, `-requested-judgment`, `-supports-considered`, `-procedure`,
`-decision`, `-claim-after`, `-residue`, `-explanation`. Exercised: P,S
(`-decision` heavily; `-residue` in P). 

**`projection-receipt`** (`slice0-projection.lisp:27-37`): `projection-receipt-p`
+ `-source-claim`, `-source-context`, `-receiver-context`, `-supports-considered`,
`-supports-accessible`, `-supports-inaccessible`, `-procedures-available`,
`-authorities-recognized`, `-derived-claims`, `-redactions`, `-obligations`,
`-blockers`, `-ceilings`, `-resulting-claim`, `-explanation` (16). Exercised: J,S
(`-supports-inaccessible` load-bearing in both).

**`projection-explanation`** (`slice0-projection.lisp:38-48`):
`projection-explanation-p` + `-source-judgment`, `-supports-considered`,
`-supports-lost`, `-supports-retained`, `-proposition-transformations`,
`-procedure-availability`, `-authority-recognition`, `-representation-blockers`,
`-resulting-judgment`, `-repair-obligations` (11). Exercised: J (via
`render-projection-why`); most fields not directly asserted.

**`transmission-receipt`** (`slice0-transmissibility.lisp:43-53`):
`transmission-receipt-p` + `-subject`, `-subject-kind`, `-source-context`,
`-receiver-context`, `-requested-mode`, `-reifiability`, `-testimony-status`,
`-derived-results`, `-reproduction-options`, `-exercise-options`, `-blockers`,
`-obligations`, `-decision`, `-explanation` (15). Exercised: I,S
(`-decision`,`-reifiability` in I,S; `-obligations` in I).

**`derived-result`** (minted by `raise`/`exercise-value`; no public constructor,
`slice0-transmissibility.lisp:158-162`): `derived-result-p`, `-id`,
`-producer-id` ("provenance, NOT possession"), `-value`. Exercised: I
(`-value`); `-producer-id` unexercised as accessor though I4 asserts the
producer is not included.

**`why` object** (`slice0.lisp:63-65`): `why-p`, `-decision`, `-condition-ids`,
`-requirement-ids`, `-failed-relations`, `-offending-fields`,
`-supports-considered`, `-strongest-lawful-result`, `-available-repairs` (9).
Reason-law: refused ⇒ ≥1 failed relation; granted ⇒ names procedure+supports
(`slice0.lisp:218-231`). Exercised: P (`-decision`,`-available-repairs`,
`-strongest-lawful-result`); S (`why-p`).

*(If the synthesis rules "inspection-debugging," the `-p` predicates alone stay
inspection-debugging and the field accessors stay inspection-debugging; if it
rules "Mneme continuity-evidentiary," the whole family lifts. The question is
one ruling, not per-symbol.)*

### 1.G — Object accessors on the ordinary/consequential objects — INSPECTION-DEBUGGING OPERATION

Pure read-only accessors on `claim`, `witness`, `promotion-procedure`,
`receiver-context`, `local-value`. All immutable (`:copier nil`, read-only
slots) — no public mutation surface.

**`claim`** (`slice0.lisp:42-43`): `claim-p`, `claim-id`, `claim-proposition`,
`claim-commitment`, `claim-asserted-by`, `claim-judgment`, `claim-lineage`,
`claim-ordinal`. Exercised: P,J,I,S (`claim-judgment`,`claim-p` heavily;
`claim-commitment` in P,J; `claim-ordinal` unexercised).

**`witness`** (`slice0.lisp:45-48`): `witness-p`, `witness-id`, `witness-for`,
`witness-mode`, `witness-kind`, `witness-source`, `witness-procedure`,
`witness-content`, `witness-polarity`, `witness-produced-at`,
`witness-observed-at`, `witness-valid-through`, `witness-transmissible`,
`witness-accessible-to`, `witness-ordinal` (15). Exercised: `witness-id` (P,J,S),
`witness-transmissible` (I). **Unexercised accessors** (fields exist, several
consumed *internally* by acts but the public reader is called by no shipped
program): `witness-produced-at`, `witness-observed-at`, `witness-valid-through`,
`witness-procedure`, `witness-content`, `witness-accessible-to`,
`witness-ordinal`. The three time fields are the **testified-evidence** surface
(charter §4/Q8, `slice0.lisp:252-254`) — carried, never trusted for ordering.

**`promotion-procedure`** (`slice0.lisp:50-51`): `promotion-procedure-p`,
`-descriptor`, `-admits`. Exercised: internally by `raise`/`project-claim`;
predicate is a shape gate.

**`receiver-context`** (`slice0-projection.lisp:20-24`): `receiver-context-p`,
`-context-id`, `-accessible-supports`, `-executable-procedures`,
`-recognized-authorities`, `-accepted-representations` (6). Exercised: J,I,S
(via construction + internal reads). **Known wart (PROVISIONAL):**
`-accepted-representations` defaults to `(:full)` (`slice0-projection.lisp:59,63`)
while `transmit :direct` gates on `:canonical-datum` — a default-constructed
receiver **refuses** direct datum transport. Left in the bytes at closure
(behavior-visible to change); folded into Slice /1 candidate 4
(`LANGUAGE-SLICE-0-ARCHITECTURE.md:112`).

**`local-value`** (`slice0-transmissibility.lisp:34-36`): `local-value-p`,
`local-value-id`, `local-value-kind`, `local-value-authority`,
`local-value-exercise-authorized`, `local-value-recipe`, `local-value-purpose`
(7). The **host-object accessor is deliberately NOT exported** — a value's host
is never handed out (`slice0-transmissibility.lisp:98` `%local-value-host-object`
is private; I9c asserts "public surface exports no host-object accessor").
`-exercise-authorized`/`-recipe`/`-purpose` return **defensive copies** (IANUS
finding 3 fix, `slice0-transmissibility.lisp:140-153`). Exercised: I
(`local-value-recipe`, `local-value-p`); `local-value-purpose` unexercised.

### 1.H — Layer signalling/restart machinery — SURFACE-TO-KERNEL ELABORATION FORM

| Symbol | Export | Behavior | Exercised by | Standing |
|---|---|---|---|---|
| `signal-slice0` | slice0.lisp:75 | The **one live signalling path**; contract-checks (`failed-invariant` non-empty string, type is a `slice0-condition` subtype, restarts all §9-lawful) then `error`s (`slice0.lisp:143-154`). Where the layer enforces what the inert condition-initializer cannot. | P | surface-to-kernel elaboration form (extension API) |
| `with-slice0-restarts` | slice0.lisp:75 | `restart-case` limited to §9 names, checked at **macroexpansion** — a non-whitelisted clause is a compile-time error (`slice0.lisp:156-165`). Sizing: whitelist is package state → surface discipline, not host closure. | P | surface-to-kernel elaboration form |

---

## 2. THE FOUR-STRATA DOCTRINE (verbatim-anchored)

Slice /0's host-boundary model, `LANGUAGE-SLICE-0-ARCHITECTURE.md:136-155`,
quoted for the quiet-zone/consequential seam:

> **1. Governed public Lisp+ surface** — the four acts + constructors +
> receipts. *Claim:* ordinary governed acts enforce the semantic distinctions
> and issue inspectable receipts for success and refusal.
> **2. Common Lisp host language** — everything CL lawfully provides.
> Well-formed programs that stay on the public surface get the guarantees;
> nothing stops a program leaving it.
> **3. Explicit/internal host escape** — package internals, printer,
> whitelist-and-registry package state. Acknowledged, thrice measured, once
> demonstrated from inside (IANUS: `continue-anyway` through the forbidding
> macro). *Not claimed closed.* A `with-host-escape` marker + static checker is
> a **Slice /1 candidate only** — recorded, not implemented.
> **4. Hostile same-image security** — cryptographic confinement, process
> isolation, debugger resistance. *Explicitly outside every Slice /0 claim*
> (the R3 ceiling).

And the governing sentence (`LANGUAGE-SLICE-0-ARCHITECTURE.md:154-155`):

> The Slice /0 claim is stratum 1. It is **not** a claim that stratum 3 cannot
> reach stratum 1's state.

**The quiet-zone / consequential seam, per the charter's own model
(`LANGUAGE-SLICE-0-CHARTER.md:37-67`):** there is **no total order of
standings** — "**There is no total order of standings in Slice /0**"
(charter:39). Categories are *separated*, not ranked: proposition · commitment ·
support record · support **mode** (`:direct|:testimony|:derivation` — "*kinds of
relation to the proposition*, not rungs", charter:52) · support **kind** (open
keyword vocabulary) · **polarity** (`:supports|:refutes`, orthogonal) ·
**judgment** (`:verified|:refuted`, "exists ONLY inside a judgment record naming
the procedure … there is no procedure-free judgment", charter:55) ·
**admissibility** (receiver-relative, computed, never stored) ·
**transmissibility** (declared, carried but not enforced). "**Verification is a
judgment, not a rung**" (charter:65). This is the seam the synthesis needs: the
"quiet zone" of ordinary assertion/witness construction carries **no** standing;
standing is only ever the *consequence* of a governed act (`raise`) writing a
procedure-bound `judgment-record`.

---

## 3. WHAT SLICE /0 CLAIMS IDENTITY OVER (governing ceilings, quoted)

What makes it more than "Common Lisp + a library," per its own closure —
and, in the same breath, exactly where it stops. Quote these, do not paraphrase
upward.

**The earned claim** (`LANGUAGE-SLICE-0-CLOSURE.md:46-50`):

> An embedded epistemic language fragment implemented in Common Lisp, governing
> **promotion, projection, transmission, and exercise** through typed semantic
> relations, immutable history, structured receipts, explanations derived from
> structure, and lawful repairs.

**Final disposition** (`LANGUAGE-SLICE-0-CLOSURE.md:13-24`):
`:embedded-language-fragment :earned` · `:host-level-closure :not-earned` ·
`:standalone-language-claim :not-yet-earned` · `:escape-surface
:common-lisp-package-internals`.

**The "more than a library" argument is the acceptance test itself, and it is
held open, not asserted** (`LANGUAGE-SLICE-0-CHARTER.md:240-251`): the acceptance
threshold is *"**can a disciplined library reproduce this**"* — and the closure's
honest answer is that the fragment is **"constructively library-reproducible
(each substrate file *is* portable CL)"** (`LANGUAGE-SLICE-0-CLOSURE.md:35`).
So Slice /0 does **not** claim to be irreducible to a library. What it claims is
narrower and evidence-backed:

- **`:embedded-language-fragment :earned`** because "the four acts refuse the
  four ordinary misleading moves through the public surface, name the missing
  relation/axis, offer lawful repairs, and stay intelligible — and **`SMOKE.lisp`
  (6/6, exit 0, zero double-colons) proves a stranger's program is writable on
  exports alone**" (`LANGUAGE-SLICE-0-CLOSURE.md:33`).
- The identity is over the **negative law made programmer-facing**: kernel0
  already enforces "*structural execution evidence must not license semantic
  acceptance*" at the record level; Slice /0 "turns that law into a
  **programmer-facing act**" (`LANGUAGE-SLICE-0-CHARTER.md:19-23`). Its reason
  for being is to make impossible-or-conspicuous "**execution evidence … silently
  becoming verification standing**" (charter:33-35).

**What it explicitly is NOT** (`LANGUAGE-SLICE-0-CLOSURE.md:53-60`): a standalone
implementation; host-closed against arbitrary CL internals; a cryptographic or
process-isolated boundary; a complete policy language; a complete proposition
calculus (atomic surface is a documented temporary restriction); production-
qualified.

**Per-specimen ceiling that must ride every convergence sentence**
(`de-promotione/DISPOSITION.md:94-99`, DPM-7):

> The governed public surface enforces the semantics. Arbitrary same-image host
> access does not. This is not a cryptographic, process-isolation, or
> hostile-custody result, and must not be cited as one.

---

## 4. HOST-ESCAPE INVENTORY (every acknowledged escape, with receipt)

Slice /0's identity claim is **stratum 1 only**; every item below sits in
stratum 3 (or exposes a stratum-2/3 fact) and is *on the record*, not solved.

| # | Escape | Mechanism | Receipt |
|---|---|---|---|
| E1 | **The `::` seam** (package-internal access) | One `::` in every ablation reaches internal constructors/state; package privacy is "an explicit but inexpensive escape route" | `de-promotione/DISPOSITION.md:94-99` (DPM-7); `LANGUAGE-SLICE-0-CLOSURE.md:36`; charter §9 sizing (`LANGUAGE-SLICE-0-CHARTER.md:203-210`) |
| E2 | **Restart-whitelist mutation** — `continue-anyway` mintable | `*slice0-restart-names*` is a mutable `defparameter` (`slice0.lisp:94-100`); any loaded file can `pushnew` a name (transmissibility does so openly, `slice0-transmissibility.lisp:70-73`), then express it through `with-slice0-restarts` — the forbidding macro | **Demonstrated from inside**, `de-infando/IANUS-AUDIT.md:24-68` (finding 1, CORRECTION); charter §9 sized to match (`LANGUAGE-SLICE-0-CHARTER.md:203-210`) |
| E3 | **`*why-extractors*` registry is package state and UNEXPORTED** | The `why`-registration seam (`slice0.lisp:388-393`) is documented only for same-package modules; a successor slice cannot register through the public surface — "the one licensed `::`" | `language-slice-1/SLICE0-DEFECT-RECEIPT-1.md` (the single receipted `::` access: `slice1.lisp` `push`es onto `lisp-plus-slice0::*why-extractors*`, annotated) |
| E4 | **Mode-fidelity is a caller obligation** (hand-declared witnesses) | The testimony level-gate fires **only** for `:mode :testimony` (`slice0.lisp:272`); a caller can construct a `:direct`/`:derivation` witness for first-order P carrying attribution `:content` and it verifies — a caller provenance-lie R3 does not police | `de-infando/IANUS-AUDIT.md:72-106` (finding 2, NOTE); "the gate guards the vocabulary, not caller provenance-lies" (`LANGUAGE-SLICE-0-ARCHITECTURE.md:60`) |
| E5 | **Kernel0 condition-initializer inert** | An `initialize-instance :after` guard on `kernel0-condition` never runs under SBCL 2.4.6 `make-condition`; direct `make-condition` bypasses the §20.1 contract silently | `KERNEL0-DEFECT-RECEIPT-0.md` (confirmed-by-execution). Slice /0 disposition: **wrapped, not relied upon** — enforcement lives in `signal-slice0` + macroexpansion (`slice0.lisp:125-130`) |

**One escape was CLOSED between audit and closure (not a live escape, recorded
for completeness):** IANUS finding 3 (accessor-returned lists were caller-mutable
and one governed the auth gate — `nconc` escalation) was fixed by defensive-copy
readers (`slice0-transmissibility.lisp:140-153`); `de-infando` teeth-7 now passes
("nconc on returned auth list mints nothing", `de-infando/RUN-RECEIPT.txt`).

**Same-image escapes generally:** stratum 4 (cryptographic / process-isolation /
debugger-resistance) is *explicitly outside every Slice /0 claim* — the R3
ceiling (`slice0-transmissibility.lisp:5-9`,
`LANGUAGE-SLICE-0-ARCHITECTURE.md:150-155`). "Hand-built witnesses" as a lawful
*feature* (the receiver minting equivalent support, I6) is design, not escape;
the *escape* is only that provenance labels on hand-built witnesses are trusted
(E4).

---

## 5. COUNT LINE (exact, read from the real files / live package)

- **Exported symbols: 161** — live `do-external-symbols` this sitting =
  `LANGUAGE-SLICE-0-API.md:8` = `SLICE0-DEFECT-RECEIPT-1.md:12`. File split:
  **80** (`slice0.lisp:38-79`) + **38** (`slice0-projection.lisp:20-48`) + **43**
  (`slice0-transmissibility.lisp:34-61`) = 161. (Not exported: `*why-extractors*`
  — the E3 seam; `%local-value-host-object` — the deliberately-private host
  reader.)
- **Condition types: 13** (1 abstract base + 12 signalable leaves) —
  `slice0.lisp:105-141` (base + 7) + `slice0-transmissibility.lisp:75-82` (5);
  family tree `LANGUAGE-SLICE-0-API.md:731-746`. Plus **7** base-slot readers
  (`slice0-condition-*`).
- **Restart names: 12** — 6 (`slice0.lisp:94-100`) + 6
  (`slice0-transmissibility.lisp:70-73`).
- **Governed acts: 4** — `raise`, `project-claim`, `transmit`, `exercise-value`.
- **Receipt types: 3** — `promotion-receipt`, `projection-receipt`,
  `transmission-receipt`.
- **Shipped specimen programs: 3** (`de-promotione`, `de-projectione-1`,
  `de-infando`), each with SPECIMEN + BASELINE + ABLATION + HYPOTHESIS +
  EXPECTED-FAILURES + RUN-RECEIPT. Plus `SMOKE.lisp` (the stranger's program,
  not a fourth specimen).
- **Specimen test counts (from RUN-RECEIPT files, live runs 2026-07-23):**
  de-promotione **19/0**, de-projectione-1 **17/0**, de-infando **30/0** — total
  **66 passed / 0 failed**. `SMOKE.lisp` **6/6**, exit 0, zero double-colons.
  (Note: `de-infando/IANUS-AUDIT.md:12` records 29/0 — the audit predates the
  30th test `teeth-2`; the frozen closure count is 30/0,
  `LANGUAGE-SLICE-0-CLOSURE.md:28,40-43`.)
- **kernel0 selftest (regression gate, run read-only each sitting):** 33 passed
  / 0 failed / 59 mutants killed / 0 survived — before and after Slice /0 work
  (`de-infando/RUN-RECEIPT.txt`; `LANGUAGE-SLICE-0-CLOSURE.md:40-43`).

---

## Appendix — standing-assignment summary

- **ordinary language form (6):** `claim`, `witness`, `promotion-procedure`,
  `receiver-context`, `support-store`, `local-value`.
- **consequential language form (4 acts + 13 conditions + 12 restarts = 29):**
  the four governed acts and their typed-refusal + lawful-repair grammars.
- **deliberate introspection surface (6):** `why`, `render-why`,
  `render-projection-why`, `projection-views`, `transmission-views`,
  `reifiable-p`.
- **surface-to-kernel elaboration form (2):** `signal-slice0`,
  `with-slice0-restarts`.
- **inspection-debugging operation (≈47):** the read-only predicates/accessors on
  `claim` (8), `witness` (15), `promotion-procedure` (3), `receiver-context` (6),
  `local-value` (7), plus the 7 `slice0-condition-*` base readers, plus the `-p`
  predicates.
- **AUTHORIAL-STANDING-UNRESOLVED (the evidentiary-record family, §1.F):** the 3
  receipt types + their accessors, `judgment-record` + accessors,
  `derived-result` + accessors, `why` object + accessors, `projection-explanation`
  + accessors — Mneme-continuity-evidentiary vs. inspection-debugging is one
  ruling the synthesis owes (question stated in §1.F).

*(These groupings are proposals with cited evidence, save the one family I
declined to guess on. Counts are indicative of the grouping, not a second
authority over the exact 161; the authoritative per-symbol rows are §1.)*

— CENSOR-PRIMUS, surface-census hand, for the LANGUAGE-SLICES-0-1-SYNTHESIS
