# PERSCRUTATOR — Findings against Language Surface /1 Candidate /0

*Adversarial stranger-audit probes. SBCL 2.4.6. Subject tree (read-only):
`…/surface1-audit/extract/target/tree/mneme/language-surface-1/`. Every probe
loads Surface /1 (CD/0 only) then Surface /0 as a client, imitating
`APPLICATION.lisp` / `surface1-selftest.lisp`. Probe preamble:
`probes/PERSCRUTATOR/preamble.lisp`. Every verdict below has a run transcript
in `probes/PERSCRUTATOR/*-run.txt`.*

Docs read first, per instructions: ERRATA 0.2, ERRATA 0.1, RETURN, package.lisp.
`PREREGISTRATION.md` was **not** read.

---

## H1 — symbol reincarnation crosses as same-term — **CONFIRMED (mechanics); NOT A DEFECT (adjudication)**

Witness: `probes/PERSCRUTATOR/H1.lisp` · transcript `H1-run.txt`.

Package `AUDIT-P`, symbol `S1` = `REINCARNATE`. Door 1 on `(S1 1)`. Between the
doors `S1` is uninterned and a fresh `S2` (same name, same home package,
non-EQ) is interned. Observed:

```
S2 = AUDIT-P::REINCARNATE  home=#<PACKAGE "AUDIT-P">   (eq S1 S2)=NIL
decoded form = (AUDIT-P::REINCARNATE 1)
(eq (car decoded) S1) = NIL
(eq (car decoded) S2) = T
DOOR2: refusal code = :NOT-A-KNOWN-SURFACE-CONSTRUCT  upstream = NIL
```

The chair's mechanical prediction holds exactly: `decode-term` returns a symbol
non-EQ to the one present at Door 1, the home-package guard passes (`S2` is
`:INTERNAL`, home `AUDIT-P`), the round-trip gate passes (same name → same
datum), and the request proceeds to `:NOT-A-KNOWN-SURFACE-CONSTRUCT`.
Reconstruction **succeeded** with a symbol object that did not exist at Door 1.

**Adjudication — the layer is truthful.** Surface /1's declared term equivalence
is *package-name + symbol-name* (`package.lisp:124`, "SYMBOL value = identifier
<package-name>/<symbol-name>"), and Door 2 is documented to reconstruct **"a
FRESH PRIVATE host form … on EVERY performance"** (`surface1.lisp:874-876`,
`package.lisp:101-105`). I searched every doc + `package.lisp` for a
host-**object**-identity promise (`grep` for "exact source form", "this exact",
"same symbol", "object identity", "EQ"): the only near-hit is `package.lisp:19`
*"this exact source form … produced this exact expanded form"* — which is a
claim at **datum** granularity (the immutable canonical datum), not host EQ. No
sentence commits the layer to reproducing the caller's symbol *object*.
S2 is genuinely a home-`AUDIT-P` `REINCARNATE`, so the datum's denotation is
honoured. **No claim is defeated.** Classification: **disclosed-class** (the
reconstruct-fresh design is stated throughout the errata).

---

## H2 — `rename-package` is a PUBLIC route to ROUND-TRIP-MISMATCH — **CONFIRMED**

Witness: `probes/PERSCRUTATOR/H2.lisp` · transcript `H2-run.txt`.

```
A: Door1 minted: T
A: find-package AUDIT-RHO -> #<PACKAGE "AUDIT-RHO-PRIME">
A: symbol home now -> #<PACKAGE "AUDIT-RHO-PRIME">  package-name="AUDIT-RHO-PRIME"
A: DOOR2 refusal code=:SOURCE-NOT-RECONSTRUCTIBLE upstream-cat="TermGrammar"
   upstream-code="ROUND-TRIP-MISMATCH" upstream-stage="term-decode"
B: find-package AUDIT-SIG-B -> NIL
B: DOOR2 refusal code=:SOURCE-NOT-RECONSTRUCTIBLE upstream-code="PACKAGE-ABSENT-IN-IMAGE"
```

Door 1 on `(AUDIT-RHO::X)`; then
`(rename-package (find-package "AUDIT-RHO") "AUDIT-RHO-PRIME" '("AUDIT-RHO"))`.
The old name survives as a **nickname**, so `find-package "AUDIT-RHO"` still
resolves the *same package object*; the home-package guard passes
(`(eq (symbol-package symbol) package)` is T — same object); but re-encoding
writes `(package-name (symbol-package s))` = the new **primary** name
`"AUDIT-RHO-PRIME"` ≠ stored `"AUDIT-RHO"`, so the round-trip gate fires with
`upstream-code = "ROUND-TRIP-MISMATCH"`, exactly as the chair predicted. The
`expansion-refusal-upstream-code` reader reports it verbatim. Variant B (rename
without keeping the nickname) lands on `PACKAGE-ABSENT-IN-IMAGE`, drawing the
boundary precisely.

Only standard public CL package operations were used between the doors — the
**same class of mutation** Errata 0.2's own reproduction used (uninterning
between doors).

**Claim-sentences defeated (verbatim):**

1. `surface1.lisp:196-200`, catalog note on `:source-not-reconstructible`,
   `ROUND-TRIP-MISMATCH`: *"DEFENCE IN DEPTH: with the home-package guard in
   place decode is injective, so **NO PUBLIC INPUT REACHES THIS** — the earlier
   and more precise guard always fires first. Proved live by planted fault
   only…"*
2. `LANGUAGE-SURFACE-1-ERRATA-0.2.md:104-108`, §2: *"With the home-package guard
   in place, **decode is injective for every admissible datum, so NO PUBLIC
   INPUT CAN REACH the round-trip mismatch** — the earlier, more precise guard
   always fires first. The gate is **defence in depth**, and a gate that has
   never fired is untested, not passing."*

Both are false as written. The home-package guard did **not** fire first (it
passed), and the round-trip gate was reached **by public input**. The deeper
error is the injectivity premise: decode is **not** injective for every
admissible datum — a package's *name* can change while the *object* persists, so
a datum admissible at Door 1 decodes to a symbol that re-encodes to a different
namespace. Decode-injectivity is time-relative to the package namespace, and
`rename-package` moves it publicly.

**Not a false edge.** The route produces a *refusal*, not a minted receipt; the
round-trip gate does its defensive job (I verified the analogous rename on a
would-be known construct also refuses rather than minting). The finding is that
the "unreachable / defence-in-depth / planted-fault-only" **classification is
false** — a claim the two documents make emphatically.

**Classification: NOVEL refutation of a disclosed claim.** The code and its
`ROUND-TRIP-MISMATCH` label are disclosed; the *unreachability* is asserted, and
this refutes it.

---

## H3 — whole-package reincarnation crosses the reconstruction gates — **CONFIRMED (mechanics); NOT A DEFECT (adjudication)**

Witness: `probes/PERSCRUTATOR/H3.lisp` · transcript `H3-run.txt`.

```
old pkg obj = #<PACKAGE "AUDIT-SIGMA-OLD">  new pkg obj = #<PACKAGE "AUDIT-SIGMA">  (eq old-y new-y)=NIL
decoded head = AUDIT-SIGMA::Y  home=#<PACKAGE "AUDIT-SIGMA">  (eq y1)=NIL (eq y2)=T
DOOR2 refusal code=:NOT-A-KNOWN-SURFACE-CONSTRUCT upstream-code=NIL
```

Door 1 on `(AUDIT-SIGMA::Y)`; then rename `AUDIT-SIGMA` away (no nickname),
create a **fresh** package `AUDIT-SIGMA`, intern a fresh `Y`. `decode-term`
resolves to the fresh `Y`, home = the fresh package object (which did **not
exist at Door 1**); the home-package guard passes and the round-trip gate passes
(the fresh package's primary name still equals the stored namespace
`"AUDIT-SIGMA"`). So a symbol in a package object that never existed at Door 1
crosses **both** reconstruction gates — the chair's load-bearing point is
confirmed.

The chair's further wording ("reaches the macroexpander, and no refusal fires")
is slightly off: a refusal *does* fire, at **resolve** (`:NOT-A-KNOWN-SURFACE-
CONSTRUCT`), before `macroexpand`, because `AUDIT-SIGMA` is not in the closed
construct table. Reaching `macroexpand` would require reincarnating one of
Surface /0's own macro packages, which would alter the layer under observation.

**Adjudication — truthful, as H1.** The reconstructed symbol is genuinely a
home-`AUDIT-SIGMA` `Y`; term equivalence is package-name + symbol-name; no
host-object-identity claim exists to defeat. Classification: **disclosed-class**.

---

## NOVEL — public API crashes with an uncaught host TYPE-ERROR on `complex`, vectors, and arrays — **CONFIRMED**

Witnesses: `probes/PERSCRUTATOR/CRASH.lisp` (`CRASH-run.txt`) and
`TOTAL.lisp` (`TOTAL-full.txt`).

```
type-of #C(1 2) = (COMPLEX (INTEGER 1 2))  (consp it)=T
type-of #(1 2 3) = (SIMPLE-VECTOR 3)
-- public ENCODE-TERM on a complex --   UNCAUGHT TYPE-ERROR
-- Door 1 with a vector arg --          UNCAUGHT TYPE-ERROR
-- Door 1 with a 2D array arg --        UNCAUGHT TYPE-ERROR
```

The escaping condition (from `TOTAL-full.txt`):

```
complex-arg: *** UNCAUGHT HOST ERROR: TYPE-ERROR: The value
   (COMPLEX (INTEGER 1 2))  is not of type  (OR STRING SYMBOL CHARACTER)
vector-arg:  *** UNCAUGHT HOST ERROR: TYPE-ERROR: The value
   (SIMPLE-VECTOR 3)        is not of type  (OR STRING SYMBOL CHARACTER)
```

**Root cause.** `%describe-host-object` (`surface1.lisp:323-329`) builds the
refusal DETAIL with `(let ((tn (string (type-of object)))) …)`. For host types
whose `TYPE-OF` returns a **compound type specifier** (a cons) — `complex`,
`(simple-vector N)`, `(simple-array …)`, multi-dimensional arrays — `(string …)`
signals a `TYPE-ERROR` (a cons is not `(OR STRING SYMBOL CHARACTER)`). That error
originates **inside Surface /1's own refusal machinery** and escapes the public
API entirely, so the designed `:SOURCE-TERM-UNREPRESENTABLE` refusal is never
minted. It fires on the exported `ENCODE-TERM` directly and through Door 1
(`REQUEST-EXPANSION` / `TRY-REQUEST-EXPANSION` — note the non-signalling twin
does **not** contain it, because it only catches `expansion-refused`).

By contrast `character`, `float`, `ratio`, `pathname`, `hash-table`, `function`
(whose `TYPE-OF` returns an atom) refuse cleanly with
`:SOURCE-TERM-UNREPRESENTABLE / NO-TERM-KIND` (see `TOTAL-run.txt`).

**Claim-sentences defeated (verbatim):**

1. `package.lisp:157-162`: *"ANY OTHER HOST TYPE — character, float, ratio,
   **complex, array**, pathname, structure, function, hash table … There is no
   printed-representation escape hatch…"* — listed under *"AND NOTHING ELSE IS
   REPRESENTABLE. **Refused, each with its own code**"* (`package.lisp:129`).
2. `LANGUAGE-SURFACE-1-RETURN.md:159-161`, §4(4): *"Everything outside the
   grammar is **refused, never rendered**: a symbol with no package, a symbol
   with an empty name, a dotted tail, a cycle, and **every other host type**."*
3. The layer's own stated robustness standard, `surface1.lisp:508-512`: *"a
   measurement that crashes on a dotted tail turns a designed refusal into a
   host accident"* — and Errata 0.1's finding-2 pride that a *"public function
   turning hostile input into a host accident"* was closed. It was not closed
   for `complex`/array-valued leaves.

`complex` and `array` are **named explicitly** in the refusal list yet crash.
`%describe-host-object`'s own docstring says the string *"reaches a human in a
refusal, and nowhere else"* — but it never reaches the refusal; `string` throws
first.

**Classification: NOVEL.** Same *defect-class* as Errata 0.1 finding 2 ("hostile
host input → uncaught host accident from a public function"), a **different
instance** (a compound `TYPE-OF` crashing the describe path, vs a CAR-cycle
exhausting the stack). Not disclosed anywhere; the documents assert the opposite
for these exact types. No false receipt is produced — this is a
robustness/totality defect, not a false edge.

**Corollary risk (reasoned, not separately witnessed with a live construct).**
The same `encode-term` path runs on the **expanded** side at Door 2
(`%encode-checked` → `encode-term`, `surface1.lisp:952-957`). Any macro that
expands to a form containing a **literal vector or array** — common in real CL
macros — would crash Door 2 with the same uncaught `TYPE-ERROR` instead of the
designed `:EXPANDED-TERM-UNREPRESENTABLE` refusal. None of the five closed
constructs happens to do so, so I could not exhibit it live without altering the
layer; flagged as the natural extension of the confirmed public-`encode-term`
crash.

---

## Governing false-edge hunt — **no third false edge found (COULD-NOT-DETERMINE, leaning REAL/SOUND on the routes tested)**

Witnesses: `probes/PERSCRUTATOR/EDGE.lisp` (`EDGE-run.txt`),
`EDGE2.lisp` (`EDGE2-run.txt`).

On a legitimate `define-admission-contract` specimen the receipt's account
matches the expansion actually performed:

```
EDGE source round-trips: T
EDGE receipt-expanded == independent macroexpand of receipt-source: T
EDGE actual-returned-expansion encodes == receipt-expanded: T
```

- **Encode injectivity in the representable domain holds.** Symbols encode as
  `(home-package-name, symbol-name)`, a pair unique per symbol (package names are
  globally unique), and `decode` recovers the unique symbol with that home+name;
  integers round-trip (bignums, negatives, fixnum boundary — `EDGE2-run.txt`);
  strings round-trip by content, including a fill-pointer string (stores the
  active `"abc"`, decodes to `"abc"`, re-encodes equal). So there is no pair of
  distinct source forms colliding to one datum that could re-expand differently.
- **Immutability holds** (Errata 0.1's fix, re-verified): mutating a caller
  source string after Door 1 leaves the stored source datum byte-identical
  (`EDGE stored source datum unchanged by caller mutation: T`).
- **"This layer catches nothing from the macro function"** — positively
  demonstrated: a macro invoked with a bad arg count let an
  `SB-KERNEL::ARG-COUNT-ERROR` escape unwrapped with nothing minted
  (`EDGE-run.txt`, "escaped condition … SB-KERNEL"). I could **not** exhibit
  Surface /0's own `surface-syntax-refused` escaping, because the malformed
  inputs I tried were either accepted by Surface /0 or produced a host
  arg-count error rather than the grammar refusal — so the specific J1–J3
  disclosed path is **COULD-NOT-DETERMINE**, though the broader "catches nothing"
  invariant is confirmed for a host error.

I did not find a route minting a receipt whose account diverges from the
expansion performed. The two known false edges (mutable alias; FIND-SYMBOL
substitution) are both closed on the routes I could reach.

---

## SUMMARY

**What is REAL:**
- **H2 (novel refutation):** `rename-package` with a retained nickname is a
  public route to `ROUND-TRIP-MISMATCH`; the documents' "NO PUBLIC INPUT REACHES
  THIS" / "decode is injective for every admissible datum" / "planted-fault
  only" classifications are **false**. It refuses (no false edge), but the gate
  is publicly reachable and decode-injectivity is time-relative to package names.
- **NOVEL crash:** the public `ENCODE-TERM` and Door 1 crash with an **uncaught
  host `TYPE-ERROR`** on `complex`, vectors, and arrays — types the layer's own
  refusal list names as cleanly refused — because `%describe-host-object` calls
  `(string (type-of object))` and `TYPE-OF` returns a cons for these. Same
  defect-*class* as Errata 0.1's closed "host accident," new instance; not
  disclosed; likely also crashes Door 2 on any macro expanding to a vector/array
  literal.

**What is NOISE:**
- **H1 and H3** are mechanically real but **not defects**: Surface /1 declares
  term equivalence at *package-name + symbol-name* and reconstructs a fresh form
  by design; no claim commits it to host-object identity, so identifying a
  reincarnated symbol (H1) or a reincarnated package (H3) with the original is
  *truthful*, not a false edge.
- No third false edge exists on the routes tested; encode-injectivity,
  immutability, and receipt-account-vs-expansion all hold on legitimate inputs.
