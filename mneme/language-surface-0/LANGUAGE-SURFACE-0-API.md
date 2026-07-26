# LANGUAGE SURFACE /0 — API

*The public surface of `lisp-plus-surface0`. Candidate, not frozen. Companion to
`LANGUAGE-SURFACE-0-SPEC.md`, which is authoritative for semantics.*

Load: `(load "surface0.lisp")` — it loads Slice /2, which loads Core /0,
Slice /1, Slice /0, Kernel /0 and CD/0.

**Exported symbols: 10** — five macros, four condition readers plus the
condition, and the reason-list accessor. Count it live with
`do-external-symbols`; do not derive it from this sentence.

**Everything here is optional.** The direct constructor API of Slice /1 and
Slice /2 is unchanged and fully usable; a program may mix the two freely.

---

## Declaration forms

### `(define-judgment-schema VARIABLE &body FIELDS)`

Every field is **literal syntax** and every field is **required**.

| field | notes |
|---|---|
| `:name` | keyword |
| `:version` | nonnegative integer |
| `:conclusion` | a proposition-pattern **form**, quoted by the macro |
| `:premises` | a list of proposition-pattern forms, **in source order** |
| `:locals` | required even when `()` |
| `:unique-locals` | required even when `()` — uniqueness is standing-relevant |

```lisp
(define-judgment-schema *daybook-schema*
  :name :closure-daybook-standing :version 1
  :conclusion (:predicate :closure-recorded-in-daybook
               (:volume (:var :volume)) (:courier (:var :courier)))
  :premises ((:predicate :dispatch-account-acknowledged
              (:volume (:var :volume)) (:courier (:var :courier))))
  :locals () :unique-locals ())
```

Expands to a `defparameter`, `lisp-plus-slice1:judgment-schema`, and
`lisp-plus-slice1:register-schema`. **Does not clear the registry** and does not
weaken duplicate detection.

### `(define-admission-contract VARIABLE &body FIELDS)`

Every field is **literal syntax** and every field is **required** — there are no
defaults here at all.

| field | notes |
|---|---|
| `:contract-id` | keyword or string |
| `:contract-version` | `0` or `1`; **always written** |
| `:accepted-clauses` | as written; **never translated or broadened** |
| `:proposition-relation` | |
| `:receiver-accessibility` | `:required` or `:optional` |
| `:retain` | |

An unknown version or an unknown clause reaches **Slice /2's** existing refusal,
not a surface refusal.

### `(define-slice2-schema VARIABLE &body FIELDS)`

**The one form that mixes syntax and expressions**, drawn on a visible line:

```
:schema-id  :schema-version  premise INDEX     →  literal
:base-schema     contract EXPRESSION           →  evaluated, once, in order
```

```lisp
(define-slice2-schema *daybook-schema/2*
  :schema-id :closure-daybook-standing/2 :schema-version 0
  :base-schema *daybook-schema*
  :premise-contracts ((0 *daybook-contract*)))
```

Attachment is **by written index only**.

## Control forms

### `(derive-case (CLAIM RECEIPT) OPERATION &body ARMS)`
### `(derive/2-case (CLAIM RECEIPT DERIVATION-BASIS) OPERATION &body ARMS)`

`OPERATION` must be a visible call to `lisp-plus-slice1:derive` /
`lisp-plus-slice2:derive/2` respectively — anything else is `:wrong-operation` at
macroexpansion time. Both arms are required.

```lisp
(derive/2-case (claim receipt basis)
    (lisp-plus-slice2:derive/2
     :schema *daybook-schema/2* :conclusion *daybook-conclusion*
     :supports (list *ack-dbasis*) :receiver (at-the-desk *ack-dbasis*))
  (:granted (setf *claim* claim *receipt* receipt *basis* basis))
  (:refused (c) (desk "refused: ~A"
                      (lisp-plus-slice2:slice2-condition-failed-invariant c))))
```

**Scope, deliberately asymmetric:**

| arm | in scope |
|---|---|
| `:granted` | the result variables, bound to the **exact** returned objects |
| `:refused` | the condition variable **and** `RECEIPT` (the refusal receipt) |

**The claim and the derivation basis are not in scope in the `:refused` arm at
all.** A refusal has no claim and no basis; binding them to `nil` would invite
`(when claim …)` to read as a decision when it is really a shrug.

Guarantees: operands evaluated **exactly once**, in **source order** (the
operation form is placed verbatim) · only the governed refusal type is caught —
an unexpected host error **escapes** · nothing retried · no support added,
removed or reordered · no condition converted to `nil` or a boolean · the
selected arm's values are the form's values · `derive/2-case` never contains or
calls the internal basis constructor.

## Conditions

```
surface-syntax-refused          MALFORMED SURFACE GRAMMAR ONLY
  surface-syntax-refused-form        the complete source form
  surface-syntax-refused-reason      a stable keyword
  surface-syntax-refused-offending   the offending field or clause
(surface-syntax-reasons)        → (:missing-field :duplicate-field
                                   :unknown-field :malformed-clause
                                   :wrong-operation)
```

**It never absorbs a semantic refusal.** A syntactically valid declaration naming
an unknown contract version or support clause reaches Slice /2's typed condition
instead — asserted by controls SC8–SC12.

## Not provided, on purpose

No `with-authority`, `prove`, `verify`, `establish`, `trust`, `settle`,
`do-judgment` or `action`. No macro that performs an effect, mints a witness,
raises a claim, establishes a source basis, obtains a derivation basis, retries a
refusal, or turns a receipt into a truth value.

**No receiver-context convenience form.** Its absence is a decision: supplying
every offered support identity automatically would erase a live semantic refusal
while presenting itself as ergonomics. Planted fault B does exactly that, and
control SC17 catches it.

`perform`, `establish-core0-source-basis`, `derive` and `derive/2` are never
sugared — their names stay where the program performs them.

---

— **Claude Opus 5 (1M context)**, 2026-07-25
