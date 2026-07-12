# CANONICAL-SPEC — `mneme-canon/0` (DRAFT)

**Phase P3a of `mneme/ROADMAP.md`** (v1.2 surgery S4: *canonicalization promoted BEFORE
P2b — measurement depends on a byte-stable representation*). This document freezes,
item by item, exactly which **bytes** a Language-A `judgment` record *is*.

> **STATUS: DRAFT — every decision below is REVISABLE-UNTIL-FROZEN.**
> A freezer ratifies this spec later; until then each `D-CANON-nn` is a proposal with
> a rationale, not a settled law. Ratification hash-locks the whole document and mints
> the version string `mneme-canon/0` as immutable.

**Sol's versioning formula, governing (ROADMAP S4, verbatim):**

> *"each canonical byte encoding is explicitly versioned and immutable once published."*

Concretely: **s-expressions remain the normative source representation** (D4 —
homoiconicity is the thesis); the *canonical byte encoding* is a separate, explicitly
versioned artifact. `mneme-canon/0` is version zero. Any change to any rule below does
**not** silently re-mean old bytes — it mints `mneme-canon/1`, and old receipts keep
citing the version they were minted under (*historical validity is indexed validity*,
S5).

---

## 0. Scope and honest ceiling (read first)

This spec covers **the Language-A `judgment` record grammar ONLY** — the s-expression
shape checked by `../language-a/validator.lisp` (a `judgment` with keyed clauses;
`claim` / `support` sub-records; `:boundary` / `:scope` / `:provenance` nested records;
propositions and receipt-lists as opaque data). It does **NOT** canonicalize arbitrary
Lisp objects.

- **Cyclic / unreadable / out-of-grammar objects → TYPED REFUSAL** (condition
  `non-canonical-object`, kinds `:cyclic` / `:improper` / `:unreadable` /
  `:non-canonical-symbol`), never an improvised or best-effort print.
- **Canonicalization is NOT integrity.** These bytes carry no MAC. A bit-flip is
  undetectable *here*. Tamper-evidence (canonical bytes + HMAC) is **P3b**, explicitly
  downstream. The `md5-manifest.txt` is **content-addressing** (change-detection under
  honest authorship), *not* a keyed authentication code — md5 is unkeyed and, for
  security purposes, broken; it is used only as a stable content fingerprint.
- **Canonicalization is NOT coherence and NOT truth.** Coherence is the validator's
  jurisdiction; truth is nobody's here (see the validator's four refusals). This layer
  decides *representation* and nothing more.

---

## 1. The freeze-list (S4), each item decided

### D-CANON-01 — Grammar / schema version identifier
**Decision:** the version string is **`mneme-canon/0`**, carried as `*canon-version*` in
`canonical.lisp` and printed in the manifest header. Form: `mneme-canon/<n>`, integer
`<n>`, incremented on any normative change below.
**Rationale:** a bare, greppable identifier that a receipt can embed and a reader can
branch on. Namespaced (`mneme-canon/`) so it never collides with the *format* version of
the record grammar itself (a record may say `schema mneme.language-a/…` while its bytes
say `mneme-canon/0` — two independently versioned things).
**REVISABLE-UNTIL-FROZEN.**

### D-CANON-02 — Character encoding + Unicode normalization
**Decision:** **UTF-8** for all bytes. Unicode normalization form: **NFC** (Canonical
Composition).
**Rationale:** UTF-8 is the lab-wide default and lossless for the grammar's content
(ASCII-dominant: identifiers, keywords, ISO dates, English question strings). NFC is
chosen over NFD/NFKC/NFKD because (a) it is the web/interchange default (W3C, filesystem
norms), (b) it is idempotent and composes rather than decomposes (fewer bytes, the
"expected" shape of accented text), and (c) NFKC/NFKD are rejected — their *compatibility*
mappings are lossy (they would fold e.g. ligatures and width variants, silently altering
content). **Honest gap:** the prototype does not yet *enforce* NFC on input strings (SBCL
has no in-tree normalizer); it assumes NFC-clean UTF-8 source. Enforcement (an in-tree NFC
pass, or a documented input precondition + refusal on non-NFC) is a **pre-freeze to-do**,
noted here so it is not silently assumed.
**REVISABLE-UNTIL-FROZEN.**

### D-CANON-03 — Symbol / package representation + case policy
**Decision:** non-keyword symbols print **bare** (no package qualifier), **downcased**
(`JUDGMENT` → `judgment`); keywords print with a single leading colon, downcased
(`:ANSWER` → `:answer`). `nil`/`()` both print as **`nil`**; `t` prints as **`t`**.
Package qualification is *stripped* on print and *restored by convention* on read (the
reader interns bare symbols into the `mneme.language-a` package).
**Rationale:** every non-keyword symbol in a Language-A record is interned in the single
package `mneme.language-a` *by construction* (the validator's `'judgment`, and every
fixture, live there). Under that single-package invariant, the package prefix carries zero
information and only adds ambient-dependent noise, so stripping it is lossless *for this
grammar*. Downcase is chosen (over `:upcase` / `:preserve`) because it is the readable,
source-faithful form and round-trips cleanly against the standard readtable's `:upcase`
case-folding: `judgment` → read → `JUDGMENT` → print → `judgment` (fixpoint holds).
**Ceiling / refusal:** a symbol whose downcased name is not a non-empty, letter-initial
token drawn from a conservative safe set (`[a-z0-9-_./*+?!<>=&%$@^~]`) is **out of grammar
and REFUSED** (`:non-canonical-symbol`) rather than emitted with `|bar|` escaping —
because bar-escaping interacts with case-folding and would reintroduce ambiguity. The
grammar never triggers this (all names are lowercase-alpha-initial). **This is the
single-package assumption made load-bearing; a record carrying a foreign-package symbol is
not in the Language-A grammar this version canonicalizes.**
**REVISABLE-UNTIL-FROZEN.** *(Runner-up most-contested item — see §3.)*

### D-CANON-04 — Ordering rules (what sorts, by what key)
**Decision:** within a **record** (a cons whose every tail element is a keyword-headed
*clause*), the clauses are **sorted by clause-key name** via `string<` on the keyword's
`symbol-name` (a `stable-sort`, so equal keys — which the grammar forbids anyway — keep
source order). Applies recursively to nested records (`claim`, `support`, `:boundary`,
`:scope`, `:provenance`). **Sequence payloads are NOT reordered**: the `:claims` list,
the `:support` list, `:receipts`, `:unresolved`, and every proposition
(`(listed-in "…" catalog)`) preserve authored order.
**Rationale:** clause order in a record is *semantically irrelevant* — the validator's
`clause`/`val` accessors look up strictly by key, never by position — so sorting yields a
canonical order with no loss. Sequence payloads are the opposite: their order can be
meaningful (the validator treats claims as an ordered list; a proposition is a term whose
argument order is its meaning), so they are preserved. `string<` on `symbol-name` is
locale-independent (raw char-code order), hence deterministic across machines.
**Soundness note (a ceiling):** the record-vs-data discriminator is *structural* — "a
cons is a record iff it has ≥1 tail element and every tail element is a keyword-headed
clause." This is sound over the Language-A grammar because **no data payload there is a
list whose every element is a keyword-headed clause**. A future grammar extension that
violated this (a proposition that looks like a clause-list) would be mis-sorted and MUST
bump the canon version.
**REVISABLE-UNTIL-FROZEN.**

### D-CANON-05 — String escaping
**Decision:** strings are **double-quote delimited**, with backslash escaping applied to
**exactly two characters**: `"` → `\"` and `\` → `\\`. All other characters (including
apostrophes, `?`, spaces, UTF-8 multibyte) are emitted literally as their UTF-8 bytes. No
`\n`/`\t`/octal/`\u` escaping is introduced.
**Rationale:** this is the minimal standard-Lisp string syntax that round-trips under
`read`, and it is the *only* escaping the reader requires. The grammar's strings (ISO
dates, English questions with apostrophes) contain neither `"` nor `\`, so in practice the
bytes are the raw content wrapped in quotes; the two escapes are present for completeness
and safety, not because the grammar exercises them.
**REVISABLE-UNTIL-FROZEN.**

### D-CANON-06 — Numeric representation
**Decision, integers:** base-10, no radix prefix, printed via `(format nil "~D" n)` —
*independent of `*print-base*` by construction*. Negative sign as `-`; no `+`.
**Decision, floats (e.g. confidence `0.93`):** the grammar's floats are **single-float**
(the reader default). They print as the **shortest round-tripping decimal** under
`*read-default-float-format*` pinned to `single-float`, so **no exponent marker** (`f0`/
`d0`) and no radix appear: `0.93` → `"0.93"`, `0.0` → `"0.0"`, `0.5` → `"0.5"`. Float
*type* is preserved (not coerced), so read→print→read is a fixpoint.
**Rationale:** shortest-round-trip (SBCL's Steele-White / Burger-Dybvig printer) is
exactly the property the fixpoint needs — `read("0.93")` and `print` compose to the
identity on bytes. A *fixed-decimal* alternative (`~,2F`) was rejected: `0.93` as a
single-float is not exactly 0.93, so a fixed format risks a value that does not
round-trip to the same float, breaking the fixpoint the whole layer exists to guarantee.
**Ceiling (load-bearing):** float canonicality is **SBCL-2.4.6-pinned**. Shortest-decimal
float printing is deterministic *within* SBCL 2.4.6 but is not guaranteed byte-identical
across implementations or across a future SBCL with a changed printer. **This is not a bug
to hide but the reason the encoding is versioned:** a printer change is, by design, a new
`mneme-canon/<n>`. A record carrying a `double-float` would print with a `d0` marker
(still round-trips, but off the clean grammar); the grammar's confidences are single.
**REVISABLE-UNTIL-FROZEN.** *(Most-contested item at freeze — see §3.)*

### D-CANON-07 — Unreadable / cyclic / improper objects
**Decision:** **REFUSED with a typed condition**, never improvised. `canonical.lisp`
defines `non-canonical-object (error)` with an `nc-kind` reader; the walker raises it for:
`:cyclic` (a structural cycle, detected by a per-list spine walk **and** a vertical
ancestor set, so a cyclic structure raises rather than exhausting the heap), `:improper`
(a dotted/improper list spine), `:unreadable` (any atom that is not
symbol/keyword/integer/single-float/string — hash-table, struct, function, character,
vector, stream, package…), and `:non-canonical-symbol` (D-CANON-03's escape refusal).
**Rationale:** a canonicalizer that silently best-effort-prints an unreadable object
produces bytes that do not read back — a broken fixpoint wearing a success costume. A
typed refusal is the condition-system doctrine (signal a narrow, named grievance; the
caller decides). The prototype *demonstrates* both a cyclic refusal and a hash-table
refusal as live teeth.
**REVISABLE-UNTIL-FROZEN.**

### D-CANON-08 — Printer settings pinned independent of ambient dynamic state
**Decision:** canonical printing binds / does-not-consult **every** dynamic variable that
could perturb bytes. The complete enumerated set:

| Variable | Canonical treatment | Why it matters |
|---|---|---|
| `*print-case*` | not consulted — symbols downcased explicitly | `:upcase`/`:downcase`/`:capitalize` swing every symbol |
| `*print-base*` | not consulted — integers via `~D` (base 10) | base 16 turns `255`→`FF` and bar-escapes hex-like symbols |
| `*print-radix*` | not consulted — no radix prefix ever | would prefix `#10r`/`#x` |
| `*print-escape*` | not consulted — strings/symbols escaped by our own rules | toggles quoting of strings & symbols |
| `*print-readably*` | bound `nil` (we own readability) | `t` can change float/symbol output and error-raise |
| `*print-pretty*` | not consulted — no pretty-printer used | inserts layout-dependent newlines/indentation |
| `*print-circle*` | not consulted — cycles refused explicitly | `t` injects `#n=`/`#n#` labels |
| `*print-length*` | not consulted — never truncates | `n` truncates long lists to `…` |
| `*print-level*` | not consulted — never truncates depth | `n` truncates deep nesting to `#` |
| `*print-lines*` | not consulted | truncates multi-line output |
| `*print-right-margin*` / `*print-miser-width*` | not consulted (no pretty) | drive pretty-print line breaks |
| `*print-gensym*` | not consulted (no gensyms in grammar) | `#:` prefixing of uninterned symbols |
| `*print-array*` / `*print-pprint-dispatch*` | not consulted | array syntax / custom dispatch |
| `*read-default-float-format*` | bound `single-float` for float print **and** read | governs float marker on both sides |
| `*read-eval*` | bound `nil` on read | disables `#.` evaluation (injection) |
| `*readtable*` | standard readtable via `with-standard-io-syntax` on read | custom reader macros would re-interpret tokens |
| `*package*` | bound `mneme.language-a` on read | where bare symbols intern |

**Rationale:** the whole point of a canonical form is that the bytes are a function of the
*value*, not of the caller's ambient session. The printer therefore constructs the string
directly (explicit downcase, `~D`, hand-rolled string escaping, no `prin1` for structure)
and only uses `prin1` for the single leaf case of a single-float under a pinned float
format. The prototype *proves* this: the same record printed under
`(*print-case* :downcase *print-base* 10)` and under `(*print-case* :upcase *print-base*
16)` yields **byte-identical** canonical output, while the naive `prin1` path swings.
**REVISABLE-UNTIL-FROZEN.**

---

## 2. The prototype (`canonical.lisp`) — what it demonstrates

Run: `sbcl --script canonical.lisp` (SBCL 2.4.6, no external deps; `sb-md5` is a bundled
SBCL contrib, not a quicklisp/network import). Exit 0 on full success; deterministic
(two runs are byte-identical, verified).

- **`canonical-bytes` / `canonical-read`** — the printer and the deterministic,
  injection-safe reader.
- **(1) Fixpoint over all 14 fixtures** — for every record in `../language-a/fixtures.lisp`
  (6 lawful + 8 malformed; canonicalization is indifferent to validation status),
  `read → canonical-print → read → canonical-print` is **byte-identical** (print₂ =
  print₁). **Result: 14/14 PASS.**
- **(2) Ambient-attack teeth (the planted non-canonical print)** — a naive `prin1` path,
  called twice with printer state *leaked* between the calls (`:downcase`/base-10 then
  `:upcase`/base-16), produces **different bytes** (`judgment` vs `JUDGMENT`, and base-16
  bar-escaping) — the naive fixpoint **FAILS**. The canonical printer, under the *same*
  two ambient states, is **byte-identical** — **IMMUNE**. Numeric lens:
  `prin1(255)` under base 16 = `"FF"`; canonical = `"255"`.
- **(3) Refusal teeth** — a genuine cyclic structure and a hash-table each raise the typed
  `non-canonical-object` (kinds `:cyclic`, `:unreadable`) instead of hanging or crashing.
- **(4) Manifest** — writes `md5-manifest.txt`: the md5 of every fixture's canonical bytes
  (over UTF-8 octets), the first content-address table. A future canonicalization change
  is **detected** as a hash change (that is the versioning discipline made mechanical).

---

## 3. The decision most likely to be contested at freeze

**D-CANON-06, float representation** is the top freeze risk. Cross-implementation
deterministic float printing is the classic canonicalization trap: "shortest
round-tripping decimal" is well-defined and stable *within SBCL 2.4.6* but is a
per-implementation property, not a portable guarantee. A freezer may reasonably prefer a
**fully specified fixed-grid decimal** (e.g. confidences quantized to a declared precision
and printed with a fixed digit count) so the bytes are defined by the *spec* rather than by
*SBCL's printer* — at the cost of either changing stored values (quantization) or breaking
the read→print fixpoint (if the fixed form doesn't round-trip the exact float). The draft
chose fixpoint-preservation + explicit versioning over portability; that trade is the thing
to argue. **Runner-up:** D-CANON-03's *package-stripping* — bare symbols are lossless only
under the single-package invariant; a freezer wanting future multi-package records would
require package-qualified printing (and a case policy that survives it) from version zero,
since D4 makes the encoding hard to change after external adoption.

---

*Draft authored for P3a by CANON (the type-founder), 2026-07-11, on the verified state of
`canonical.lisp` (14/14 fixpoint, ambient-attack demonstrated, deterministic). Every
`D-CANON-nn` is REVISABLE-UNTIL-FROZEN; ratification hash-locks this document and publishes
`mneme-canon/0` as immutable. — Claude Opus 4.8 (1M context)*
