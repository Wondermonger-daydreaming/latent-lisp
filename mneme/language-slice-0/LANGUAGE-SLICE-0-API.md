# LANGUAGE-SLICE-0-API.md

**Package:** `lisp-plus-slice0` (nicknamed nowhere; use the full name).
**Load surface:** `sbcl --non-interactive --load slice0-transmissibility.lisp`
(loads `slice0.lisp` → `slice0-projection.lisp` → `slice0-transmissibility.lisp`,
which in turn loads `../kernel0/load.lisp`).
**Exported symbols documented:** 161 (authoritative list obtained by
`do-external-symbols` over the live package, not by reading the export forms).

This brief is deliberately dull. Every signature below was proven by executing
it in SBCL 2.4.6, not inferred from reading. A stranger should be able to write
a program from this file alone — see `SMOKE.lisp` for a complete worked program
that touches only exported symbols.

## Standing notes (read first)

- **Guarantee sizing.** Every guarantee in this brief holds for **well-formed
  programs using the public (single-colon) surface**. Package internals reached
  by double-colon (`lisp-plus-slice0::…`) are an **acknowledged escape**: the
  restart whitelist and canonical boundary are package state that arbitrary
  same-image code can mutate. This is surface discipline, not host closure, and
  the specimen records it as such rather than claiming to have solved it.

- **PROVISIONAL — the proposition surface.** A *proposition* is an s-expression
  built from **keywords, strings, integers, and proper lists thereof only**.
  Bare (non-keyword) symbols and floats are **refused** (`malformed-slice0-shape`),
  because they do not cross kernel0's canonical boundary. This is a **documented
  temporary restriction**: propositions are not laundered through string
  conversion, so stored-form and canonical equality agree today at the cost of a
  narrow vocabulary. Applies to `claim :proposition`, `witness :for`,
  `local-value :recipe`, `project-claim :public-form`.

- **PROVISIONAL — accepted representations.** A `receiver-context`'s
  `:accepted-representations` defaults to `(:full)`. Today the **only meaningful
  value the transmission layer checks is `:canonical-datum`**: a `:direct`
  transmission of a datum is refused unless the target context accepts
  `:canonical-datum` (the default `(:full)` does **not** satisfy it). Other
  representation tokens are inert placeholders. Under-determined; mark any
  program relying on representations other than `:canonical-datum` as PROVISIONAL.

- **Ordering.** Every record carries an `-ordinal` — a deterministic per-image
  integer (`*slice0-ordinal*`), the constitutive order. Wall-clock witness
  fields (`:produced-at`, `:observed-at`, `:valid-through`) are *testified
  evidence*, never trusted for ordering.

- **Immutability.** All records use `:copier nil` and read-only slots. There is
  no public mutation surface. Grants never mutate the input claim; they return a
  new revision whose `lineage` names the predecessor.

---

## 1. Public kernel0 dependencies (MARKED)

A program using this fragment needs exactly these kernel0 entry points to
*construct* the inputs `raise`/`transmit`/`project-claim` consume. They are in
package `lisp-plus-kernel0` (single-colon exported).

| Symbol | Signature | Act | Notes |
|---|---|---|---|
| `make-identity` | **positional** `(domain name)` | Mint a durable identity. | `domain` a keyword (e.g. `:procedure`, `:receipt`, `:claim`); `name` a string. **Not** keyword-based. |
| `make-procedure-descriptor` | strict `&rest` keyword | Build the kernel0 descriptor a `promotion-procedure` wraps. | **Required keys:** `:procedure-id` (durable identity in domain `:procedure`), `:version` (nonnegative integer), `:judgment-class` (**exactly** `:structural` or `:semantic`). Optional: `:input-domain`, `:result-vocabulary`, `:evidence-requirements`, `:bounded-unknowns`. Unknown/duplicate keys ⇒ `malformed-constructor-shape`. |
| `identity=` | `(left right)` | Kernel equality for durable identities. | Used by `support-store`/`project-claim` to match witness ids. |
| `identity-key` | `(identity)` | Hashable key for a durable identity. | Used internally by `support-store`; a program building a store by hand would use it. |

**Minimal `:semantic` construction** (the one a promotion needs — a semantic
judgment requires a `:semantic` descriptor, else `raise` refuses with
`inadmissible-procedure`):

```lisp
(lisp-plus-kernel0:make-procedure-descriptor
  :procedure-id (lisp-plus-kernel0:make-identity :procedure "checker")
  :version 0
  :judgment-class :semantic
  :result-vocabulary '(:accepted :rejected))
;; VERIFIED => #S(PROCEDURE-DESCRIPTOR :JUDGMENT-CLASS :SEMANTIC …)
```

For **accessible-supports** lists on a `receiver-context`, membership is tested
with `identity=`; supply `witness-id` values (durable identities), e.g.
`:accessible-supports (list (witness-id *w*))`.

The kernel0 condition `noncanonical-durable-value` (a subtype of
`lisp-plus-kernel0:kernel0-condition`) is what `require-canonical` signals for a
closure; `reifiable-p` catches it. A program does not signal it directly.

---

## 2. Claims & witnesses

### `claim` — assert a proposition (constructor)

```
(claim &key proposition by) => claim
```

- **Act:** Mint a historical assertion. Commitment is `:asserted`; **judgment is
  always `nil`** — a claim cannot be born judged (judgment arrives only via
  `raise`).
- **Inputs:** `:proposition` a proposition (see surface note — keywords/strings/
  integers/proper lists only); `:by` any value naming the asserting principal.
  Both required.
- **Result:** a `claim` with a fresh `:claim`-domain id and ordinal.
- **Refusal:** `malformed-slice0-shape` if `:proposition` or `:by` is missing, or
  if the proposition contains a bare symbol/float. Carries `:offending-field`.
- **Example (VERIFIED):**
  ```lisp
  (claim :proposition '(:temp-ok :unit-2) :by :shift-lead)
  ;; => #S(CLAIM :PROPOSITION (:TEMP-OK :UNIT-2) :COMMITMENT :ASSERTED :JUDGMENT NIL …)
  ```
- **Refusal example (VERIFIED):**
  ```lisp
  (handler-case (claim :proposition '(foo) :by :lead)
    (malformed-slice0-shape (c) (slice0-condition-failed-invariant c)))
  ;; => "proposition parts must be keywords, strings, integers, or proper lists
  ;;     (bare symbols do not cross the canonical boundary); got FOO"
  ```

### `witness` — a first-class support record (constructor)

```
(witness &key for mode kind source procedure content
              (polarity :supports)
              produced-at observed-at valid-through
              (transmissible t) (accessible-to :all))
  => witness
```

- **Act:** Construct a support/refutation record for a proposition.
- **Inputs / constraints:**
  - `:for` (required) — the proposition supported. For `:mode :testimony` it
    **MUST** be a second-order attribution `(:asserted SOURCE P)` — level
    discipline is enforced **at construction**, not deferred.
  - `:mode` (required) — one of `:direct`, `:testimony`, `:derivation`.
  - `:kind` (required) — a keyword (e.g. `:measurement`, `:execution`,
    `:transcript`, `:report`).
  - `:source` (required).
  - `:polarity` — `:supports` (default) or `:refutes`.
  - `:transmissible` — declared boolean (default `t`); the transmission layer
    enforces it. `:accessible-to` — `:all` (default) or a list of receiver keys.
  - `:procedure`, `:content`, `:produced-at`, `:observed-at`, `:valid-through`
    — optional payload/provenance; wall-clock fields are testimony, not order.
- **Result:** a `witness` with a `:receipt`-domain id and ordinal.
- **Refusal:** `malformed-slice0-shape` for a missing/invalid required field or a
  flattened testimony witness (requirement `:testimony-preserves-proposition-level`).
- **Example (VERIFIED):**
  ```lisp
  (witness :for '(:temp-ok :unit-2) :mode :direct
           :kind :measurement :source :sensor-grid :content '(:celsius 312))
  ;; => #S(WITNESS :FOR (:TEMP-OK :UNIT-2) :MODE :DIRECT :POLARITY :SUPPORTS
  ;;      :TRANSMISSIBLE T :ACCESSIBLE-TO :ALL …)
  ```
- **Testimony discipline refusal (VERIFIED):**
  ```lisp
  (handler-case
      (witness :for '(:temp-ok :unit-2) :mode :testimony :kind :report :source :op)
    (malformed-slice0-shape (c) (slice0-condition-requirement-id c)))
  ;; => :TESTIMONY-PRESERVES-PROPOSITION-LEVEL
  ;; (lawful form: :for '(:asserted :op (:temp-ok :unit-2)))
  ```

### Accessors

`claim` (all read-only):

| Accessor | Returns |
|---|---|
| `claim-p` | type predicate |
| `claim-id` | durable identity (`:claim`) |
| `claim-proposition` | the proposition |
| `claim-commitment` | `:asserted` (never rewritten) |
| `claim-asserted-by` | the principal |
| `claim-judgment` | a `judgment-record`, or `nil` if unjudged |
| `claim-lineage` | `(predecessor-claim-id …)` or `nil` |
| `claim-ordinal` | constitutive-order integer |

`witness` (all read-only):

| Accessor | Returns | | Accessor | Returns |
|---|---|---|---|---|
| `witness-p` | predicate | | `witness-polarity` | `:supports`\|`:refutes` |
| `witness-id` | id (`:receipt`) | | `witness-produced-at` | testified, untrusted |
| `witness-for` | proposition | | `witness-observed-at` | testified |
| `witness-mode` | `:direct`\|`:testimony`\|`:derivation` | | `witness-valid-through` | testified |
| `witness-kind` | keyword | | `witness-transmissible` | declared boolean |
| `witness-source` | source | | `witness-accessible-to` | `:all`\|list |
| `witness-procedure` | producing proc id or nil | | `witness-ordinal` | integer |
| `witness-content` | payload | | | |

---

## 3. Promotion (`raise`)

### `promotion-procedure` — a kernel0 descriptor + admissibility (constructor)

```
(promotion-procedure &key descriptor admits) => promotion-procedure
```

- **Act:** Wrap a kernel0 `procedure-descriptor` with the slice's admissibility
  vocabulary — which `(mode kind)` witness shapes it accepts as support.
- **Inputs:** `:descriptor` a `procedure-descriptor` (else `malformed-slice0-shape`);
  `:admits` a list of `(MODE KIND)` pairs, `MODE` ∈ {`:direct`,`:testimony`,
  `:derivation`}, `KIND` a keyword.
- **Example (VERIFIED):**
  ```lisp
  (promotion-procedure
    :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                  :procedure-id (lisp-plus-kernel0:make-identity :procedure "checker")
                  :version 0 :judgment-class :semantic
                  :result-vocabulary '(:accepted :rejected))
    :admits '((:direct :measurement)))
  ```

Accessors: `promotion-procedure-p`, `promotion-procedure-descriptor`,
`promotion-procedure-admits`.

### `raise` — the checked promotion act

```
(raise the-claim &key to per considering receiver)
  => (values new-claim-revision promotion-receipt)   ; on grant
  ;  signals a slice0-condition                        ; on refusal
```

- **Act:** Request that `the-claim` be promoted to judgment `:to` by procedure
  `:per`, on the strength of the `:considering` witnesses, admissible to
  `:receiver` (`nil` = receiver-unqualified).
- **Inputs:** `the-claim` a `claim`; `:to` ∈ {`:verified`,`:refuted`}; `:per` a
  `promotion-procedure`; `:considering` a list of `witness`; `:receiver` a
  receiver key or `nil`.
- **Grant result:** `(values revision receipt)`. `revision` is a **new** judged
  claim (original untouched; `revision`'s lineage names it); `receipt` has
  `decision :granted` and `claim-after = revision`.
- **Refusal result:** SIGNALS a typed `slice0-condition` (never returns).
  The condition carries `:receipt` (a `promotion-receipt`, `decision :refused`,
  `claim-after nil`) and `:why` (a structured `why`). The **lawful restarts**
  below are established around the evaluation.
- **Conditions it can signal** (by check, in order):

  | Check | Condition | Requirement-id |
  |---|---|---|
  | shape of args | `malformed-slice0-shape` | (arg-specific) |
  | no witness offered | `unsupported-promotion` | `:supports-present` |
  | `:per` not `:semantic` | `inadmissible-procedure` | `:semantic-judgment-requires-semantic-procedure` |
  | no witness matches the proposition | `wrong-proposition-support` | `:witness-for-must-equal-claim-proposition` |
  | matches but wrong `(mode kind)` | `insufficient-support-kind` | `:procedure-admits-mode-kind` |
  | all admissible support unreachable by receiver | `receiver-cannot-access-support` | `:receiver-accessibility` |
  | want `:verified` but all support refutes | `unsupported-promotion` | `:supports-must-not-all-refute` |
  | want `:refuted` but all support supports | `unsupported-promotion` | `:refutation-needs-refuting-support` |

- **Grant example (VERIFIED):**
  ```lisp
  (multiple-value-bind (rev rcpt)
      (raise (claim :proposition '(:temp-ok :unit-2) :by :lead)
             :to :verified :per *proc*
             :considering (list (witness :for '(:temp-ok :unit-2) :mode :direct
                                         :kind :measurement :source :sensor)))
    (list (judgment-record-judgment (claim-judgment rev))   ; => :VERIFIED
          (promotion-receipt-decision rcpt)))                ; => :GRANTED
  ```
- **Refusal example (VERIFIED):**
  ```lisp
  (handler-case
      (raise (claim :proposition '(:flow-ok :unit-2) :by :lead)
             :to :verified :per *proc* :considering (list *w-temp*))
    (wrong-proposition-support (c)
      (list (why-decision (why c))                    ; => :REFUSED
            (why-available-repairs (why c))            ; => (RETAIN-CURRENT-CLAIM
                                                       ;      SEEK-MATCHING-SUPPORT
                                                       ;      CONSTRUCT-ATTRIBUTION-CLAIM
                                                       ;      DEFER-JUDGMENT)
            (promotion-receipt-p (slice0-condition-receipt c)))))  ; => T
  ```
- **Restart example (VERIFIED)** — re-evaluate with a matching witness:
  ```lisp
  (handler-bind
      ((wrong-proposition-support
         (lambda (c) (declare (ignore c))
           (invoke-restart 'seek-matching-support
             (list (witness :for '(:flow-ok :unit-2) :mode :direct
                            :kind :measurement :source :sensor))))))
    (raise (claim :proposition '(:flow-ok :unit-2) :by :lead)
           :to :verified :per *proc* :considering (list *w-temp*)))
  ;; => a judged revision (judgment :VERIFIED), plus its receipt
  ```

### `judgment-record` accessors (read-only)

A judgment exists only bound to its procedure. `raise` mints these; there is no
public constructor.

| Accessor | Returns |
|---|---|
| `judgment-record-p` | predicate |
| `judgment-record-judgment` | `:verified`\|`:refuted` |
| `judgment-record-procedure-id` | the procedure's id |
| `judgment-record-procedure-version` | version |
| `judgment-record-support-ids` | load-bearing witness ids |
| `judgment-record-receiver` | receiver key, or `nil` (receiver-unqualified) |
| `judgment-record-ordinal` | integer |

### `promotion-receipt` accessors (read-only)

Issued on **every** attempt (grant and refusal).

| Accessor | Returns |
|---|---|
| `promotion-receipt-p` | predicate |
| `promotion-receipt-claim-before` | the input claim |
| `promotion-receipt-requested-judgment` | `:verified`\|`:refuted` |
| `promotion-receipt-supports-considered` | witness ids weighed |
| `promotion-receipt-procedure` | the `promotion-procedure` |
| `promotion-receipt-decision` | `:granted`\|`:refused` |
| `promotion-receipt-claim-after` | the revision, or `nil` when refused |
| `promotion-receipt-residue` | plist (`:deferred`, `:current-judgment`, `:receiver-unqualified`, …) |
| `promotion-receipt-explanation` | the `why` object |

---

## 4. Projection (`project-claim`)

### `receiver-context` — a position, not a person (constructor)

```
(receiver-context &key context-id accessible-supports
                       executable-procedures recognized-authorities
                       (accepted-representations '(:full)))
  => receiver-context
```

- **Act:** Describe a receiving position: which supports it can reach, which
  procedures it can run, which authorities it recognizes, which representations
  it accepts.
- **Inputs:** `:context-id` a keyword (**required**, else `malformed-slice0-shape`);
  `:accessible-supports` a list of witness ids; `:executable-procedures` a list
  of `promotion-procedure` (each validated); `:recognized-authorities` a list of
  source keys; `:accepted-representations` (see PROVISIONAL note — only
  `:canonical-datum` is meaningful today).
- **Example (VERIFIED):**
  ```lisp
  (receiver-context :context-id :external-auditor
                    :executable-procedures (list *proc*)
                    :recognized-authorities '(:sensor-grid))
  ;; => #S(RECEIVER-CONTEXT :CONTEXT-ID :EXTERNAL-AUDITOR
  ;;      :ACCEPTED-REPRESENTATIONS (:FULL) …)
  ```

Accessors: `receiver-context-p`, `receiver-context-context-id`,
`receiver-context-accessible-supports`, `receiver-context-executable-procedures`,
`receiver-context-recognized-authorities`, `receiver-context-accepted-representations`.

### `support-store` — build an evidence store

```
(support-store &rest witnesses) => hash-table   ; identity-key -> witness
```

- **Act:** Assemble the witness lookup table `project-claim` consumes.
- **Example (VERIFIED):** `(support-store *w-temp*)` ⇒ a hash-table.

### `project-claim` — reconstruction, never copy

```
(project-claim source-claim &key from to store offering public-form derivation)
  => (values resulting-claim projection-receipt)
```

- **Act:** Project `source-claim` from position `:from` into position `:to`. The
  result's judgment (if any) is **re-derived** from `:to`'s own accessible
  supports, recognized authorities, and executable procedures — **source
  judgment is never copied**. The source claim is never mutated.
- **Inputs:** `source-claim` a `claim`; `:from`/`:to` `receiver-context`s (both
  required); `:store` a hash-table from `support-store` (required); `:offering`
  extra witnesses (optional); `:public-form` a redacted proposition (optional);
  `:derivation` a `:derivation`-mode witness whose `:for` equals `:public-form`
  (required *for* a lawful redaction — a public derivative may not silently
  inherit the private proposition's warrant).
- **Result:** always `(values resulting-claim receipt)` — this act **returns**;
  it does not signal on ordinary loss. `resulting-claim` is a new located claim;
  its judgment is `nil` when `:to` cannot re-derive it (regrade). The receipt
  records every axis: what was inaccessible, blocked, redacted, obligated.
- **Refusal semantics:** an *inaccessible* support is recorded, never erased
  (`supports-inaccessible`). A transmissible inaccessible support produces an
  `:export` **obligation** (repairable); a non-reifiable one produces a `:mute`
  **ceiling** (local to that object — says nothing about equivalent support the
  target could mint).
- **Example (VERIFIED)** — projection with loss:
  ```lisp
  (multiple-value-bind (theirs receipt)
      (project-claim *verified* :from *plant* :to *auditor*
                     :store (support-store *w-temp*))
    (list (claim-judgment theirs)                              ; => NIL (regraded)
          (projection-views receipt)                           ; => (:REGRADED
                                                               ;      :OBLIGATION-PRODUCING)
          (projection-receipt-supports-inaccessible receipt))) ; => (witness id …)
  ```

### `projection-views` — composable feature tags

```
(projection-views receipt) => list of keywords
```

Non-disjoint descriptions (one projection may be several at once):
`:preserved`, `:regraded`, `:redacted`, `:obligation-producing`, `:blocked`,
`:ceiling-bound`.

### `projection-receipt` accessors (read-only)

| Accessor | Returns |
|---|---|
| `projection-receipt-p` | predicate |
| `projection-receipt-source-claim` | the input claim |
| `projection-receipt-source-context` | `:from` |
| `projection-receipt-receiver-context` | `:to` |
| `projection-receipt-supports-considered` | ids weighed |
| `projection-receipt-supports-accessible` | ids reachable at `:to` |
| `projection-receipt-supports-inaccessible` | ids present-but-unreachable (**not absent**) |
| `projection-receipt-procedures-available` | procedure ids at `:to` |
| `projection-receipt-authorities-recognized` | `(source . :recognized`\|`:unrecognized)` alist |
| `projection-receipt-derived-claims` | public-form propositions, if any |
| `projection-receipt-redactions` | `(public private derivation-id)` triples |
| `projection-receipt-obligations` | `(:export id)` — repairable |
| `projection-receipt-blockers` | contextual blocks (not metaphysical) |
| `projection-receipt-ceilings` | `(:mute id note)` — local to the object |
| `projection-receipt-resulting-claim` | the new located claim |
| `projection-receipt-explanation` | a `projection-explanation` |

### `projection-explanation` accessors + `render-projection-why`

`projection-explanation-p`, and the read-only fields:
`projection-explanation-source-judgment`, `-supports-considered`,
`-supports-lost` (`(id . reason)` alist), `-supports-retained`,
`-proposition-transformations` (`(from to :derived`\|`:underived)`),
`-procedure-availability` (`(:available ids :selected id`\|`nil)`),
`-authority-recognition`, `-representation-blockers`, `-resulting-judgment`,
`-repair-obligations`.

```
(render-projection-why x &optional (stream t)) => the explanation
```

Accepts a `projection-explanation` **or** a `projection-receipt`. Prints prose
derived strictly from the fields (never invented past them) and returns the
explanation. **Example (VERIFIED)** output:

```
[projection] source judgment: VERIFIED checker
  considered: witness-4
  lost witness-4 — inaccessible (exportable — obligation)
  procedures: available checker; selected NONE
  resulting judgment: none — receiver context licenses no stronger act
  repair: (:EXPORT #S(DURABLE-IDENTITY :DOMAIN :RECEIPT :NAME "witness-4"))
```

---

## 5. Transmission & exercise

### `reifiable-p` — the boundary law itself

```
(reifiable-p host-object) => boolean
```

True iff `host-object` crosses kernel0's canonical boundary as data. The test
**is** the boundary (`require-canonical` accepts or refuses). A closure is
refused. VERIFIED: `(reifiable-p (lambda (x) x))` ⇒ `NIL`;
`(reifiable-p '(:a 1))` ⇒ `T`.

### `local-value` — existence and usability are local facts (constructor)

```
(local-value &key host (kind … computed) authority
                  exercise-authorized recipe purpose)
  => local-value
```

- **Act:** Admit a host object as a governed local value.
- **Inputs / laws:** `:host` a function or canonical datum (else
  `malformed-slice0-shape`). `:kind` is **COMPUTED** from the object
  (`:closure` for a function, `:datum` for canonical data); a caller-supplied
  `:kind` that contradicts the object is **refused** (requirement
  `:kind-is-computed-not-claimed`) — the anti-stringification gate. `:authority`
  required. `:exercise-authorized` a list of context-ids or `:any`. `:recipe`
  canonical data (validated as a proposition) or `nil`. `:purpose` free.
- **Example (VERIFIED):**
  ```lisp
  (local-value :host (let ((offset 2)) (lambda (raw) (list :calibrated (+ raw offset))))
               :authority :sensor-grid
               :exercise-authorized '(:plant)
               :recipe '(:rebuild (:kind :calibrator) (:offset-source (:config :unit-2))))
  ;; => #S(LOCAL-VALUE :KIND :CLOSURE :AUTHORITY :SENSOR-GRID …)
  ```
- **Kind-contradiction refusal (VERIFIED):**
  ```lisp
  (handler-case (local-value :host (lambda (x) x) :kind :datum :authority :s)
    (malformed-slice0-shape (c) (slice0-condition-requirement-id c)))
  ;; => :KIND-IS-COMPUTED-NOT-CLAIMED
  ```

**Accessors — note the defensive-copy readers.** `local-value-p`,
`local-value-id`, `local-value-kind`, `local-value-authority`. The host object
accessor is **private (not exported)** — a value's host is never handed out.
These three return **fresh defensive copies** (IANUS finding 3: returning the
internal list let a caller's `NCONC` mutate authorization state):

| Accessor | Returns (defensively copied) |
|---|---|
| `local-value-exercise-authorized` | copy of the context-id list (or `:any`) |
| `local-value-recipe` | `copy-tree` of the recipe |
| `local-value-purpose` | `copy-tree` of the purpose (if a cons) |

### `exercise-value` — governed invocation (use, never possession)

```
(exercise-value lv &key in args mint-for (mint-kind :capability-check))
  => (values derived-result witness-or-nil)
```

- **Act:** Exercise `lv` in position `:in` with `:args`. Authorization-gated. The
  caller receives a **canonical derived result** (and optionally a freshly minted
  witness) — never the host object.
- **Inputs:** `lv` a `local-value`; `:in` a `receiver-context`; `:args` a list
  applied when `lv` is a closure; `:mint-for` a proposition (mint a witness for
  it) or `nil`; `:mint-kind` the minted witness's kind.
- **Result:** `(values derived-result maybe-witness)`. The minted witness (when
  `:mint-for` given) is `:direct` mode, `source` = the value's authority,
  `content` = the raw result.
- **Refusals:** `exercise-not-authorized` if `:in`'s context-id is not in
  `exercise-authorized` (requirement `:exercise`; establishes only the
  `defer-transmission` restart); `value-not-reifiable` if the invocation
  produced a non-canonical result (requirement `:reifiability` — a closure
  returning a closure is not laundered out).
- **Example (VERIFIED):**
  ```lisp
  (multiple-value-bind (dr w) (exercise-value *calibrator* :in *plant* :args '(10)
                                              :mint-for '(:calibrated 12))
    (list (derived-result-value dr)   ; => (:CALIBRATED 12)
          (witness-p w)               ; => T
          (witness-kind w)))          ; => :CAPABILITY-CHECK
  ```
- **Refusal example (VERIFIED):**
  ```lisp
  (handler-case (exercise-value *calibrator* :in *auditor* :args '(10))
    (exercise-not-authorized (c) (slice0-condition-requirement-id c)))
  ;; => :EXERCISE
  ```

### `derived-result` accessors (read-only)

`raise`/`exercise-value` mint these; no public constructor.

| Accessor | Returns |
|---|---|
| `derived-result-p` | predicate |
| `derived-result-id` | id (`:receipt`) |
| `derived-result-producer-id` | the producer's id — **provenance, not possession** |
| `derived-result-value` | the canonical value |

### `transmit` — the governed carry

```
(transmit subject &key from to (mode :direct) derived)
  => (values payload-or-nil transmission-receipt)   ; on grant
  ;  signals a slice0-condition                       ; on refusal
```

- **Act:** Attempt to carry `subject` from `:from` to `:to` under `:mode`.
- **Inputs:** `subject` a `local-value`, `derived-result`, `witness`, or `claim`;
  `:from`/`:to` `receiver-context`s (both required); `:mode` ∈ {`:direct`,
  `:testimony`, `:reproduction`}; `:derived` a list of exportable
  `derived-result`s on offer.
- **Grant result:** `(values payload receipt)`, `decision :granted`. The payload
  depends on mode: `:direct` returns the subject; `:reproduction` returns the
  recipe as data; `:testimony` returns the **second-order attribution claim**
  (`(:asserted AUTHORITY (:exercised …))`).
- **Refusal result:** SIGNALS a typed condition carrying the `transmission-receipt`
  (`decision :refused`) and a `why`; establishes the lawful transmission repairs.
- **Mode/condition map:**

  | Mode / situation | Outcome | Condition (axis) |
  |---|---|---|
  | `:direct`, subject is a closure `local-value` | refuse | `value-not-reifiable` (`:reifiability`) |
  | `:direct`, subject is a declared-mute `witness` | refuse | `direct-transmission-impossible` (`:transmissibility`) |
  | `:direct`, `:to` does not accept `:canonical-datum` | refuse | `receiver-representation-unsupported` (`:representation`) |
  | `:direct`, otherwise | grant (payload = subject) | — |
  | `:reproduction`, recipe present | grant (payload = recipe) | — |
  | `:reproduction`, no recipe | refuse | `reproduction-procedure-unavailable` (`:reproduction`) |
  | `:testimony` | grant (payload = attribution claim) | — |

- **Direct-refusal example (VERIFIED):**
  ```lisp
  (handler-case (transmit *calibrator* :from *plant* :to *auditor* :mode :direct)
    (value-not-reifiable (c)
      (let ((r (slice0-condition-receipt c)))
        (list (transmission-receipt-decision r)       ; => :REFUSED
              (transmission-receipt-reifiability r)    ; => :NOT-REIFIABLE
              (transmission-views r)))))               ; => (:DIRECT-EXPORT-REFUSED
                                                       ;      :TESTIMONY-AVAILABLE
                                                       ;      :RECEIVER-REPRODUCTION-AVAILABLE
                                                       ;      :LOCAL-EXERCISE-ONLY)
  ```
- **Reproduction-grant example (VERIFIED):**
  ```lisp
  (multiple-value-bind (recipe receipt)
      (transmit *calibrator* :from *plant* :to *auditor* :mode :reproduction)
    (list (first recipe)                              ; => :REBUILD
          (transmission-receipt-decision receipt)))   ; => :GRANTED
  ```
- **Testimony-grant example (VERIFIED):**
  ```lisp
  (multiple-value-bind (claim* receipt)
      (transmit *calibrator* :from *plant* :to *auditor* :mode :testimony)
    (list (claim-proposition claim*)                        ; => (:ASSERTED :SENSOR-GRID
                                                            ;      (:EXERCISED "local-value-…"))
          (transmission-receipt-testimony-status receipt))) ; => :CONSTRUCTED
  ```
- **Direct-grant example (VERIFIED)** — a datum into a `:canonical-datum` context:
  ```lisp
  (let ((sink (receiver-context :context-id :sink
                                :accepted-representations '(:canonical-datum)))
        (dl (local-value :host '(:reading 42) :authority :sensor)))
    (multiple-value-bind (p r) (transmit dl :from *plant* :to sink :mode :direct)
      (list (local-value-p p) (transmission-receipt-decision r))))  ; => (T :GRANTED)
  ```

### `transmission-views` — composable feature tags

```
(transmission-views receipt) => list of keywords
```

`:direct-export-refused`, `:testimony-available`, `:derived-result-exportable`,
`:receiver-reproduction-available`, `:local-exercise-only`. Never one status
symbol.

### `transmission-receipt` accessors (read-only)

| Accessor | Returns |
|---|---|
| `transmission-receipt-p` | predicate |
| `transmission-receipt-subject` | the subject object |
| `transmission-receipt-subject-kind` | `:closure`\|`:datum`\|`:derived-result`\|`:witness`\|`:claim` |
| `transmission-receipt-source-context` | `:from` |
| `transmission-receipt-receiver-context` | `:to` |
| `transmission-receipt-requested-mode` | `:direct`\|`:testimony`\|`:reproduction` |
| `transmission-receipt-reifiability` | `:reifiable`\|`:not-reifiable`\|`:n/a` |
| `transmission-receipt-testimony-status` | `:available`\|`:constructed`\|`:impossible`\|`nil` |
| `transmission-receipt-derived-results` | exportable product ids |
| `transmission-receipt-reproduction-options` | recipe(s) on offer |
| `transmission-receipt-exercise-options` | exercise-authorized contexts |
| `transmission-receipt-blockers` | structured block records |
| `transmission-receipt-obligations` | honest riders on a grant |
| `transmission-receipt-decision` | `:granted`\|`:refused` |
| `transmission-receipt-explanation` | the `why` object |

---

## 6. Receipts & views — summary

Every governed act issues a receipt on **every** attempt (grant and refusal):

| Act | Receipt type | Views fn | Explanation type |
|---|---|---|---|
| `raise` | `promotion-receipt` | — | `why` |
| `project-claim` | `projection-receipt` | `projection-views` | `projection-explanation` |
| `transmit` / `exercise-value` | `transmission-receipt` | `transmission-views` | `why` |

A refusal receipt is preserved on the signaled condition's `:receipt` slot — the
attempted transition survives even when refused (charter §8).

---

## 7. Explanation (`why`, `render-why`, `render-projection-why`)

### `why` — the one uniform explanation extractor

```
(why object) => why-object   ; (a projection-explanation for a projection-receipt)
```

- **Act:** Extract the structured explanation from a `why`, a `slice0-condition`,
  or **any** governed receipt (promotion, projection, transmission). The single
  door to "why did this happen?" across the whole surface.
- **Refusal:** `malformed-slice0-shape` if `object` is none of those.
- **Example (VERIFIED):** `(why-p (why refusal-receipt))` ⇒ `T`;
  `(why-p (why promotion-receipt))` ⇒ `T`.

### `why` object accessors (read-only)

| Accessor | Returns |
|---|---|
| `why-p` | predicate |
| `why-decision` | `:granted`\|`:refused` |
| `why-condition-ids` | condition type names (if refused) |
| `why-requirement-ids` | charter requirement keywords |
| `why-failed-relations` | `(relation-name . detail)` alist (≥1 iff refused) |
| `why-offending-fields` | field keys |
| `why-supports-considered` | witness ids |
| `why-strongest-lawful-result` | the strongest act still available |
| `why-available-repairs` | subset of the restart vocabulary |

**Reason-law:** a refused `why` carries ≥1 failed relation; a granted `why` names
its procedure and supports.

### `render-why` — prose from structure

```
(render-why w &optional (stream t)) => the why-object
```

Accepts anything `why` accepts; prints prose derived strictly from the fields.
**Example (VERIFIED)** output:

```
[REFUSED] considered witness-4
  missing relation: PROPOSITION-MATCH — witness-4 is for (:TEMP-OK :UNIT-2), not for (:FLOW-OK :UNIT-2)
  requirements: :WITNESS-FOR-MUST-EQUAL-CLAIM-PROPOSITION
  lawful repairs: RETAIN-CURRENT-CLAIM, SEEK-MATCHING-SUPPORT, CONSTRUCT-ATTRIBUTION-CLAIM, DEFER-JUDGMENT
```

`render-projection-why` is documented in §4 (projection-specific fields).

---

## 8. Conditions

### Family tree

```
error
 └── slice0-condition            (base; abstract — signal a leaf, not this)
      ├── malformed-slice0-shape
      ├── unsupported-promotion
      ├── wrong-proposition-support
      ├── insufficient-support-kind
      ├── inadmissible-procedure
      ├── receiver-cannot-access-support
      ├── testimony-impossible
      ├── value-not-reifiable
      ├── direct-transmission-impossible
      ├── receiver-representation-unsupported
      ├── exercise-not-authorized
      └── reproduction-procedure-unavailable
```

**Design note.** The Slice /0 condition layer is **parallel to** kernel0's, not a
subtype — kernel0's initializer enforces a frozen 7-name restart whitelist that
does not fit claim promotion (charter §9). All contract enforcement lives in
`signal-slice0` (the one live signalling path) and in `with-slice0-restarts`
(macroexpansion time); no `initialize-instance :after` guard is used (verified
inert under SBCL 2.4.6's `make-condition`).

### `slice0-condition` base slots (readers)

Every condition below carries all of these; `nil` where inapplicable.

| Reader | Carries |
|---|---|
| `slice0-condition-failed-invariant` | non-empty string describing the broken invariant |
| `slice0-condition-requirement-id` | the charter requirement keyword |
| `slice0-condition-offending-field` | the field key at fault |
| `slice0-condition-offending-value` | its offending value |
| `slice0-condition-permitted-restarts` | the lawful restart names for this refusal |
| **`slice0-condition-receipt`** | the full receipt of the attempted transition (survives refusal) |
| **`slice0-condition-why`** | the structured `why` object |

These readers are exported as generic functions (`slice0-condition-failed-invariant`
etc.). The `:report` prints `TYPE: failed-invariant`.

### Condition types — axis / requirement each names

| Condition | Signaled by | Axis / requirement-id |
|---|---|---|
| `malformed-slice0-shape` | all constructors (shape gate) | field-specific (e.g. `:testimony-preserves-proposition-level`, `:kind-is-computed-not-claimed`) |
| `unsupported-promotion` | `raise` | `:supports-present` / `:supports-must-not-all-refute` / `:refutation-needs-refuting-support` |
| `wrong-proposition-support` | `raise` | `:witness-for-must-equal-claim-proposition` |
| `insufficient-support-kind` | `raise` | `:procedure-admits-mode-kind` |
| `inadmissible-procedure` | `raise` | `:semantic-judgment-requires-semantic-procedure` |
| `receiver-cannot-access-support` | `raise` | `:receiver-accessibility` |
| `testimony-impossible` | (family; repair target of `mark-testimony-impossible`) | testimony axis |
| `value-not-reifiable` | `transmit` (closure, direct), `exercise-value` | `:reifiability` |
| `direct-transmission-impossible` | `transmit` (declared-mute witness) | `:transmissibility` |
| `receiver-representation-unsupported` | `transmit` (representation gate) | `:representation` |
| `exercise-not-authorized` | `exercise-value` | `:exercise` |
| `reproduction-procedure-unavailable` | `transmit` (`:reproduction`, no recipe) | `:reproduction` |

### `signal-slice0` — the one live signalling path

```
(signal-slice0 condition-type &rest initargs
               &key failed-invariant permitted-restarts &allow-other-keys)
```

- **Act:** Contract-check then signal (`error`) a `slice0-condition`.
- **Enforced:** `failed-invariant` must be a non-empty string; `condition-type`
  must be a subtype of `slice0-condition`; every name in `permitted-restarts`
  must be a lawful Slice /0 restart name. A violated contract is a plain
  `error`, not a `slice0-condition`.
- Programs normally receive conditions from `raise`/`transmit`/etc.; call this
  directly only when extending the layer.

---

## 9. Lawful restarts

### `with-slice0-restarts` — the bounded restart macro

```
(with-slice0-restarts (clause…) body…)
```

A `restart-case` **limited to the charter §9 lawful names**. Each clause's car
must be a lawful restart name (checked at macroexpansion — a non-whitelisted
clause is a compile-time `error`). `continue-anyway`, blind `retry`, and
arbitrary standing assignment are **not expressible** through this vocabulary by
well-formed programs. Sizing: the whitelist is package state (surface
discipline, not host closure — see standing notes).

### Restart names — where established, what invoking returns, arguments

Promotion restarts (established by `raise` around each evaluation):

| Restart | Invoked with | Returns |
|---|---|---|
| `retain-current-claim` | `(receipt)` | `(values nil receipt)` — keep the claim unpromoted |
| `seek-matching-support` | `(more-witnesses)` | re-evaluate with the additional witnesses appended |
| `construct-attribution-claim` | `(testimony-witness receipt)` | `(values attribution-claim receipt)` |
| `defer-judgment` | `(receipt)` | `(values nil receipt)` with `:deferred t` residue |
| `retarget-receiver` | `(new-receiver)` | re-evaluate for the new receiver |
| `mark-testimony-impossible` | `(receipt)` | `(values nil receipt)` with `:testimony-impossible t` residue |

Transmission restarts (established by `transmit` around each evaluation):

| Restart | Invoked with | Returns |
|---|---|---|
| `export-derived-result` | `(dr)` | re-transmit the canonical product `dr` in `:direct` mode |
| `construct-testimony-claim` | `(receipt)` | `(values attribution-claim receipt)` |
| `provide-reproduction-recipe` | `(receipt)` | re-transmit in `:reproduction` mode |
| `exercise-locally` | `(in args receipt)` | `(values (exercise-value subject :in in :args args) receipt)` |
| `mint-equivalent-support-at-receiver` | `(w receipt)` | `(values w receipt)` — receiver-minted support |
| `defer-transmission` | `(receipt)` | `(values nil receipt)` — record deferral |

Which restarts are *offered* for a given refusal is in the condition's
`slice0-condition-permitted-restarts` (and mirrored in `why-available-repairs`).
Each repair is a **different lawful act**; none relabels a failed export as
success. **Restart example (VERIFIED)** — `retain-current-claim`:

```lisp
(handler-bind
    ((wrong-proposition-support
       (lambda (c) (invoke-restart 'retain-current-claim
                                   (slice0-condition-receipt c)))))
  (raise (claim :proposition '(:flow-ok :unit-2) :by :lead)
         :to :verified :per *proc* :considering (list *w-temp*)))
;; => (values NIL <refusal-receipt>)
```

---

## 10. Receiver contexts — quick reference

A `receiver-context` is the position model shared by projection and
transmission. Construct it once, pass it as `:from`/`:to`/`:in`/`:receiver`.

- Membership in `accessible-supports` is tested with kernel0 `identity=` — pass
  `witness-id` values.
- `executable-procedures` must be `promotion-procedure`s.
- `recognized-authorities` are matched against `witness-source` during projection.
- `accepted-representations` — only `:canonical-datum` is honored today
  (PROVISIONAL); the default `(:full)` will **refuse** a `:direct` datum
  transmission.

---

*Verified against: 2026-07-23 · SBCL 2.4.6 · `sbcl --non-interactive --load SMOKE.lisp` → "6 ok, 0 failed", exit 0. Every example in this brief was executed under this build; the exported-symbol list (161) was read live from the package via `do-external-symbols`.*
