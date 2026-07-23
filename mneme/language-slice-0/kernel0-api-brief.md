# Kernel /0 API Brief — for `lisp-plus-slice0` (built ON TOP of kernel0)

**Author:** PROBE (execution-verified API archaeology)
**Standard:** every signature below was PROVEN by constructing it in SBCL, not inferred from reading.
**SBCL:** `(lisp-implementation-version)` => **"2.4.6"** (operation-checked first).
**Load:** `sbcl --non-interactive --load experiments/latent-lisp/mneme/kernel0/load.lisp` — all three
smoke blocks print PASS. CD/0 dependency actually lives at
`experiments/latent-lisp/canonical-datum/common-lisp/` (NOT `.../mneme/canonical-datum/...`; the
load.lisp path `../../canonical-datum/common-lisp/` resolves from `.../mneme/kernel0/` up to
`.../latent-lisp/`).
**Rule for Slice /0:** kernel0 is byte-frozen and READ ONLY. Use its exported symbols; never edit it.

Packages: `lisp-plus-kernel0` (kernel), `lisp-plus-cd0` (canonical datum).

---

## ITEM 1 — Identity

### `make-identity` — lambda list is **POSITIONAL `(domain name)`**, NOT keyword.

```lisp
(lisp-plus-kernel0:make-identity :seat "seat-1")   ; :seat is the DOMAIN arg (positional), "seat-1" the NAME
;; => #S(DURABLE-IDENTITY :DOMAIN :SEAT :NAME "seat-1")
```

- `domain` — must be one of the **19 legal domain keywords** (verified list, from `%identity-domain-p`):
  `:process :logical-operation :seat :attempt :external-request :exposure :machine-configuration
  :channel-policy :capability :claim :receipt :manifestation :effect :store :journal :parser
  :procedure :principal :reconciliation`.
- `name` — a **non-empty string** (defensively snapshotted with `copy-seq`). Never gensym/hash/pointer-derived.
- **SURPRISE / trap for callers:** because the lambda list is positional, `(make-identity :domain :seat)`
  is read as `domain=:domain, name=:seat` → **REFUSED** `unresolved-identity` (`:domain` is not a legal
  domain, and `:seat` is not a string). Do NOT call it in keyword style.

Refusals (all `unresolved-identity`, invariant `§4/§4.1 [F: ID-1]`):
```
(make-identity :seat "")          => REFUSED unresolved-identity   ; empty name
(make-identity :frobnicate "x")   => REFUSED unresolved-identity   ; unknown domain
```

### Accessors (all verified)
- `durable-identity-domain identity` => keyword domain (`:SEAT`)
- `durable-identity-name identity` => defensive copy of name string (`"seat-1"`)
- `durable-identity-p x` => predicate
- `identity-key identity` => `"domain:name"` diagnostic string (verified `"seat:seat-1"`)

### `identity=` — the single named equality
```lisp
(identity= (make-identity :seat "s") (make-identity :seat "s"))     ; => T
(identity= (make-identity :seat "s") (make-identity :attempt "s"))  ; => NIL
```
It compares **`EQ` on domain AND `STRING=` on name** (both must be durable identities, else NIL).

### `require-identity value expected-domain` — domain gate
```lisp
(require-identity (make-identity :seat "s") :seat)     ; => the identity (durable-identity-p => T)
(require-identity (make-identity :seat "s") :attempt)  ; => REFUSED identity-drift §4.2 [F: ID-2]
```

Other identity ops present: `identity->datum`, `datum->identity` (CD/0 identifier round-trip, namespace
`("lisp-plus-kernel0" "identity")`), constant `+identity-procedure+`.

---

## ITEM 2 — `require-canonical` + canonical-datum equality

### `require-canonical value &key context`  (NOTE the keyword is `:context`, not positional)

Behavior (verified): if `value` is already a CD/0 datum it is returned unchanged; otherwise EXACTLY ONE
registered predicate must match and produce a CD/0 datum, else `noncanonical-durable-value`.

| Host input | Result — `datum-family` | Verified |
|---|---|---|
| `"hello"` (non-empty string) | `:STRING` | ✓ |
| `42` (integer) | `:INTEGER` | ✓ |
| `:kw` (keyword) | `:IDENTIFIER` (namespace `("common-lisp" "keyword")`, path = exact SYMBOL-NAME) | ✓ |
| durable identity | `:IDENTIFIER` (via `identity->datum`) | ✓ (used internally) |
| `(:a "b" 3)` proper list of canonicalizables | `:SEQUENCE` (recursive) | ✓ |
| `(:a (:b 2))` nested | `:SEQUENCE` (nested) | ✓ |
| `1.5d0` float | **REFUSED** `noncanonical-durable-value` §2.1 [F: HOST-2] | ✓ |
| `'foo` **plain (non-keyword) symbol** | **REFUSED** `noncanonical-durable-value` | ✓ |
| `(a "b" 3)` list containing a **plain symbol** | **REFUSED** (element `a` has no procedure) | ✓ |

**CRITICAL SURPRISE for proposition encoding.** A proposition like `(exited run-1 0)` written with **bare
symbols does NOT canonicalize** — `exited`, `run-1` are plain symbols with no registered procedure, so the
whole list is refused. Propositions MUST be built from **keywords / strings / integers**:
`(:exited :run-1 0)` ✓ or `("exited" "run-1" 0)` ✓. This canonicalizes to a `:SEQUENCE` datum.

### Equality of two canonical data — `lisp-plus-cd0:equal-datum` (this is the datum= function)

```lisp
(defvar d1 (require-canonical (list :exited :run-1 0)))
(defvar d2 (require-canonical (list :exited :run-1 0)))
(defvar d3 (require-canonical (list :exited :run-1 1)))
(lisp-plus-cd0:equal-datum d1 d2)   ; => T     (independently constructed, structurally equal)
(lisp-plus-cd0:equal-datum d1 d3)   ; => NIL   (different last element)
```
- Structural, recursive (worklist-based), family-by-family exact comparison. Returns `T`/`NIL`.
- **Both args MUST be datums**: `(equal-datum "x" "y")` => REFUSED `lisp-plus-cd0:cd0-failure`
  ("UnsupportedHostType"). So guard with `lisp-plus-cd0:datum-p` first, or canonicalize both sides.
- Exported name is **`equal-datum`** (there is no `datum=`). Related CD/0 exports: `datum-p`,
  `datum-family`, per-family predicates (`string-datum-p`, `sequence-datum-p`, `identifier-datum-p`, …).

---

## ITEM 3 — `make-procedure-descriptor`

Strict `&rest` keyword constructor. Closed schema; unknown/duplicate keys => `malformed-constructor-shape`.

- **Required keys:** `:procedure-id`, `:version`, `:judgment-class`.
- **Optional keys:** `:input-domain`, `:result-vocabulary`, `:evidence-requirements`, `:bounded-unknowns`.

Field laws (all enforced at construction, all refusals = `malformed-constructor-shape`, requirement `K0E-23`,
except `:procedure-id` which is `identity-drift` via `require-identity … :procedure`):

| Key | Law |
|---|---|
| `:procedure-id` | MUST be a durable identity in domain `:procedure` |
| `:version` | MUST be a **nonnegative integer** (string/nil/list/negative refused) |
| `:judgment-class` | MUST be **exactly** `:structural` or `:semantic` |
| `:input-domain` | `NIL`, or a **strict plist over exactly `:kinds` and `:statuses`** — even length, each key ≤ once, no other keys; each present dimension value MUST be a proper list |
| `:result-vocabulary` | proper list, **duplicate-free** under kernel equality |
| `:evidence-requirements` | proper list; **every entry MUST be a durable identity**; duplicate-free |
| `:bounded-unknowns` | proper list |

### (a) VERIFIED semantic descriptor with `:input-domain` + `:evidence-requirements`
```lisp
(make-procedure-descriptor
  :procedure-id (make-identity :procedure "sem-proc")
  :version 0
  :judgment-class :semantic
  :input-domain (list :kinds (list :subject-answer) :statuses (list :present))
  :result-vocabulary (list :accepted :rejected :invalid)
  :evidence-requirements (list (make-identity :receipt "ev-1")))
;; => #S(PROCEDURE-DESCRIPTOR :JUDGMENT-CLASS :SEMANTIC
;;      :INPUT-DOMAIN (:KINDS (:SUBJECT-ANSWER) :STATUSES (:PRESENT))
;;      :RESULT-VOCABULARY (:ACCEPTED :REJECTED :INVALID) :EVIDENCE-REQUIREMENTS (#<…RECEIPT ev-1>) …)
```

### (b) VERIFIED structural descriptor
```lisp
(make-procedure-descriptor
  :procedure-id (make-identity :procedure "struct-proc")
  :version 0 :judgment-class :structural
  :result-vocabulary (list :invalid))
;; => #S(PROCEDURE-DESCRIPTOR :JUDGMENT-CLASS :STRUCTURAL :INPUT-DOMAIN NIL :RESULT-VOCABULARY (:INVALID) …)
```
(`:accepted`/`:rejected` are lawful in a vocabulary but a STRUCTURAL descriptor may not *license* them at
validation time — `validate-interpretation-against-descriptor` fires `interpretation-class-violation`
`K0E-25`. `:invalid` is lawful under either class.)

### Refused constructions (all verified, all `malformed-constructor-shape`)
```
:version "0"                                   => "…:version MUST be a nonnegative integer…"
:input-domain (:kinds (:x) :bogus (:y))        => "…admits ONLY the dimension keys :kinds and :statuses…"
:evidence-requirements (:not-an-identity)      => "…every …evidence-requirements entry MUST be a durable identity…"
(omit :judgment-class)                         => "…MUST bind its durable procedure-id, version, and judgment class"
```

Accessors return **defensive snapshots**: `procedure-descriptor-{procedure-id,version,judgment-class,
input-domain,result-vocabulary,evidence-requirements,bounded-unknowns}`.

---

## ITEM 4 — `make-verdict` and `make-joint-verdict`

### `make-verdict` (strict `&rest` keyword)
- Keys: `:value` (required), `:procedure-id`, `:condition-ids`, `:requirement-ids`.
- `:value` MUST be exactly `:pass`, `:fail`, or `:not-run`.
- `:pass`/`:fail` MUST name `:procedure-id` (a `:procedure` identity); `:not-run` may omit it.
- `:fail` MUST carry ≥1 `:condition-ids` **or** `:requirement-ids` (reasonless fail refused).
- `:condition-ids`/`:requirement-ids` are proper lists (snapshotted).

```lisp
(make-verdict :value :pass :procedure-id (make-identity :procedure "v-proc"))          ; => #S(VERDICT :VALUE :PASS …)
(make-verdict :value :fail :procedure-id pid :condition-ids (list :some-cond))         ; => #S(VERDICT :VALUE :FAIL …)
```

Refusals (both `malformed-constructor-shape`, `K0E-26`):
```
(make-verdict :value :fail :procedure-id pid)   => "…a :fail verdict MUST carry at least one condition-id or requirement-id…"
(make-verdict :value :pass)                      => "…a :pass or :fail verdict MUST name its :procedure-id…"
```

### `make-joint-verdict` (strict `&rest` keyword)
- Keys (BOTH required): **`:structural-verdict`, `:semantic-verdict`** — each MUST be a `verdict` record.
- Structural PASS + semantic FAIL is **lawful and constructs** (that divergence is the point).

```lisp
(make-joint-verdict
  :structural-verdict (make-verdict :value :pass :procedure-id pid)
  :semantic-verdict   (make-verdict :value :fail :procedure-id pid :requirement-ids (list "K0E-25")))
;; => #S(JOINT-VERDICT :STRUCTURAL #S(VERDICT :VALUE :PASS …) :SEMANTIC #S(VERDICT :VALUE :FAIL …))
```
Accessors: `joint-verdict-structural`, `joint-verdict-semantic`, `joint-verdict-divergent-p` (T iff the two
values differ — **NOT** a pass predicate). **There is deliberately NO `joint-verdict-pass-p`** and Slice /0
must not add one (the no-boolean-collapse law).

---

## ITEM 5 — `make-claim` / `make-validation-record` / `revalidate-claim` / `promote-origin`

### `make-claim` (strict `&rest`; **all 9 fields must be explicitly bound**)
Keys: `:claim-id :content-datum :source-ids :origin :validation-records :integrity-records
:visibility-records :determinacy :bounded-unknowns`. Missing any => `standing-inflation`.

- `:claim-id` — a `:claim` durable identity.
- `:content-datum` — passed through `require-canonical`, so a **raw non-empty string is accepted** (becomes a
  `:STRING` datum) OR any already-canonical datum OR any canonicalizable host value. (A plain symbol / float
  would be refused here, same as ITEM 2.)
- `:origin` — MUST be one of `:asserted :observed :derived :reconstructed`.
- `:determinacy` — MUST be a `determinacy` record (`make-determinacy :mode :determinate :evidence nil`).
- `:source-ids`, `:validation-records`, `:integrity-records`, `:visibility-records`, `:bounded-unknowns` —
  proper lists (typed-record lists where applicable); `nil` is legal for a minimal claim.

VERIFIED minimal construction (origin `:asserted`):
```lisp
(let ((cid (make-identity :claim "claim-1"))
      (det (make-determinacy :mode :determinate :evidence nil)))
  (make-claim :claim-id cid :content-datum "the sky is blue"
              :source-ids nil :origin :asserted
              :validation-records nil :integrity-records nil
              :visibility-records nil :determinacy det :bounded-unknowns nil))
;; => claim with (claim-origin …) => :ASSERTED, (datum-family (claim-content-datum …)) => :STRING
```

### `make-validation-record` (strict `&rest`)
Keys: `:status :subject-id :validator-principal-id :procedure-id :procedure-version :scope :evidence
:bounded-unknowns`. `:status` MUST be `:unchecked | :checked | :verified | :refuted`.
Standing requirements by status (verified from source):
- `:unchecked` — MUST bind `:subject-id` and `:scope` (only).
- `:checked` — MUST bind subject, validator, procedure, version, scope (empty evidence allowed).
- `:verified`/`:refuted` — MUST bind subject, validator, procedure, version, scope **and** non-empty evidence.
- `:validator-principal-id` (if present) must be `:principal` domain; `:procedure-id` (if present) `:procedure`.

### `revalidate-claim claim new-validation-record` — positional (2 args)
Appends the record, returns a NEW claim, **keeps the same origin** (`:reconstructed` stays `:reconstructed`).
```lisp
(revalidate-claim claim
  (make-validation-record :status :unchecked :subject-id cid :scope :whole-claim))
;; => new claim; (length (claim-validation-records …)) => 1 ; origin unchanged => :ASSERTED
```
**Subject-id law (verified):** the validation-record's `:subject-id` MUST `identity=` the claim's `:claim-id`.
A foreign subject is refused:
```
(revalidate-claim claim (make-validation-record :status :unchecked
                          :subject-id (make-identity :claim "other") :scope :whole-claim))
   => REFUSED standing-inflation "§3.1 [K0E-18]: a validation record MUST name its containing claim as :subject-id…"
```

### `promote-origin claim new-origin` — **UNCONDITIONAL REFUSAL SURFACE**
```lisp
(promote-origin claim :observed)
;; => REFUSED standing-inflation "§15.6 and §15.7 [F: JRN-6]: asserted→observed and reconstructed→observed
;;    standing promotion is refused; validation MUST NOT rewrite historical origin"
```
It **always** signals `standing-inflation` and never mutates the claim (any `new-origin` argument). There is
no legal promotion; origin is historical and write-once at construction.

---

## ITEM 6 — Restart whitelist / condition containment  ⚠ CONTAINS A MAJOR CORRECTION

### The frozen 7-name whitelist (`%permitted-restart-name-p`, verified)
`supply-resolved-identity`, `choose-private-staging-channel`,
`request-lawful-capability-restoration`, `begin-reconciliation`, `authorize-supersession`,
`preserve-payload-mark-invalid`, `stop-and-export-evidence`.

### (b) `with-kernel0-restarts` — **ENFORCED, verified** (this is the real containment)
A non-whitelisted clause name is refused at **macroexpansion** (the `dolist` runs in the macro body):
```lisp
(macroexpand-1 '(with-kernel0-restarts ((bogus-clause () nil)) (values)))
;; => REFUSED kernel0-condition  ("restart clause is not permitted by §20.9: …")
(macroexpand-1 '(with-kernel0-restarts ((begin-reconciliation () :done)) :body))
;; => (RESTART-CASE (PROGN :BODY) (BEGIN-RECONCILIATION NIL :DONE))   ; good clause expands fine
```
⇒ **A Slice /0 layer cannot establish its own restart name through `with-kernel0-restarts`.** This macro is
the effective lock: actual restart *establishment* is confined to the 7 names.

### (a) ⚠ **CORRECTION — condition construction does NOT refuse a bad `permitted-restarts` entry.**
The mission expected `make-condition`/`signal-kernel0` to REFUSE a non-whitelisted `:permitted-restarts`
entry at construction. **This is FALSE as executed.** The `initialize-instance :after ((c kernel0-condition))`
guard in `conditions.lisp` (which is *written* to check the restart whitelist, non-empty failed-invariant,
proper evidence-ids, and to snapshot offending-value) **never runs under SBCL 2.4.6's `make-condition`** —
CL does not require `make-condition` to invoke `initialize-instance`, and SBCL's does not.

Proof (all executed):
```
(make-condition 'unresolved-identity :failed-invariant "test" :permitted-restarts (list 'bogus-restart))
   => CONSTRUCTED (no refusal); slot = (BOGUS-RESTART)          ; yet (%permitted-restart-name-p 'bogus-restart) => NIL
(make-condition 'unresolved-identity :failed-invariant "")      => CONSTRUCTED (empty FI accepted)
(make-condition 'unresolved-identity :failed-invariant "x" :evidence-ids '(a . b)) => CONSTRUCTED (improper accepted)
;; offending-value snapshot check: (eq shared (kernel0-condition-offending-value c)) => T  (NOT snapshotted)
(signal-kernel0 'unresolved-identity :failed-invariant "intended" :permitted-restarts (list 'bogus-restart))
   => signals UNRESOLVED-IDENTITY "intended"  (bad restart carried, NOT refused)
```
**Implication for Slice /0:** you MUST NOT rely on kernel0 refusing an ill-formed `permitted-restarts` slot,
empty failed-invariant, or improper evidence-ids at condition-construction time — those guards are inert in
this build. The restart-name containment you CAN rely on is `with-kernel0-restarts` (macroexpand refusal).

### The containment that IS explicit-and-live: `signal-kernel0` subtype check (verified)
`signal-kernel0` has an explicit body check (not in the dead initializer), so it fires:
```lisp
(signal-kernel0 'simple-error :failed-invariant "x")
;; => REFUSED kernel0-condition "§20.1 [F: CND-1]: … CONDITION-TYPE must name a KERNEL0-CONDITION subtype"
```
⇒ A Slice /0 layer can `define-condition` a subtype of `kernel0-condition` and signal it through
`signal-kernel0` (that is allowed); it just cannot route a NON-subtype through `signal-kernel0`, and cannot
mint a new restart NAME through `with-kernel0-restarts`.

---

## ITEM 7 — Timestamp / ordinal discipline

kernel0 exposes **no** timestamp/clock/ordinal API symbol (no `*-timestamp`, `*-clock`, `*-ordinal` export).
The discipline is a source-comment invariant. **Note:** it is NOT in `records.lisp` (mission said to grep
there) — it lives in **`folds.lisp` lines 6–7**, verbatim:

> ";;; structures in a plain proper list, and list position is the sole ordinal;
>  ;;; no timestamp field exists or participates in ordering (§13.2, §13.7)."

Corroborating in-code invariants (folds.lisp): "§13.2–§13.3: an in-memory event accepts only its semantic
identity fields, explicit extension marker, and payload plist" (line 159); "§13.2: top-level attempt event
identities MUST agree with its :ATTEMPT payload record" (330). Event ordering is **list position only** —
`fold-seat-occupancy` / `fold-exposure-principals` operate "in list ordinal order" (733, 773). README.md:172
records the paired store rule: a "timestamp-only journal merge" fires `journal-merge-receipt-required`
before any merge transformation.

⇒ **Slice /0 must not introduce timestamps into ordering.** Sequence is carried by list position; any
temporal fact must be modeled as data payload, never as an ordering key.

---

## Cross-cutting notes for Slice /0 authors

- **Strict `&rest` keyword constructors** (`make-procedure-descriptor`, `make-verdict`, `make-joint-verdict`,
  `make-claim`, `make-validation-record`, `make-determinacy`, etc.) reject unknown/duplicate keys via
  `%strict-constructor-arguments` → `malformed-constructor-shape`/`standing-inflation`. `make-identity` and
  `require-identity` and `revalidate-claim`/`promote-origin` are **positional**.
- **Everything is immutable + defensively snapshotted** on the way in and (usually) out; `:copier nil` on all
  structs. Do not expect to mutate returned records.
- **Kernel equality** across the API is `identity=` for durable identities and `equal` otherwise
  (`%kernel-name=`); datum equality is `lisp-plus-cd0:equal-datum`.
- **UNVERIFIED / out of scope:** the deeper interpretation-validation path
  (`validate-interpretation-against-descriptor`) and the full fold/journal/merge machinery were read but not
  exhaustively exercised here; only the constructors named in the mission were proven end-to-end.
