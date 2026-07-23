# Lisp+ Slice /1 — Programmer Guide

*For a competent Common Lisp programmer who knows Slice /0's guide. No project
history required. Twenty minutes. Everything here runs: load `slice1.lisp`
(SBCL ≥ 2.4.6) — it pulls in the whole frozen Slice /0 + kernel0 chain — then work
in a package that uses `:cl` with `lisp-plus-slice1`, `lisp-plus-slice0`, and
`lisp-plus-kernel0` symbols to hand.*

Slice /0 gave you four governed verbs for **claims about the world**. Slice /1
governs the layer under a claim: the **anatomy of a derived conclusion** — the
declared premises a judgment stands on. Common Lisp lets a program grant an
"admissible", "signed-off", "verified-for-this-purpose" conclusion out of
whatever evidence happens to be lying around, with the load-bearing premise never
represented anywhere. Slice /1 makes the missing, mismatched, refuted,
inaccessible, plural, and receiver-bound premise **mechanically visible in a
receipt before the conclusion can be granted** — but only for the premises you
**declare**. That conditionality is the whole ceiling, and it is stated in every
section below.

Running domain: **lab-notebook entry sign-off.** An entry is signed off for a
reviewer and a purpose only when four declared premises discharge — the entry is
complete, its results were reproduced, the reviewer is qualified, and the purpose
is permitted for that reviewer.

## Setup — the fixtures the examples share

These thin adapters live entirely on exported symbols (the smoke program uses the
same shapes). Paste them once.

```lisp
(defun np (form) (lisp-plus-slice1:proposition form))          ; GROUND proposition
(defun pp (form) (lisp-plus-slice1:proposition-pattern form))  ; PATTERN (may carry vars)

(defun dw (form &key (kind :observation) (source :desk))       ; a direct ground witness
  (lisp-plus-slice0:witness :for (np form) :mode :direct :kind kind :source source))

(defun ctx (id &rest witnesses)                                ; a receiver position
  (lisp-plus-slice0:receiver-context
   :context-id id
   :accessible-supports (mapcar #'lisp-plus-slice0:witness-id
                                (remove-if-not #'lisp-plus-slice0:witness-p witnesses))))

(defun assess (receipt predicate)                              ; the assessment for one premise
  (find predicate (lisp-plus-slice1:derivation-receipt-assessments receipt)
        :key (lambda (a) (second (lisp-plus-slice1:premise-assessment-premise-pattern a)))))
(defun disposition (receipt predicate)                         ; its one-of-six disposition
  (lisp-plus-slice1:premise-assessment-disposition (assess receipt predicate)))
```

## Mistake 1 — something is present, therefore the conclusion holds

Idiomatic CL. The digest matched and a signature parsed, so the artifact is
"admissible":

```lisp
(when (and digest-ok signature-ok)
  (setf (gethash id *admissible*) t))   ; recognition of the signer was never checked
```

Two facts paid for a third they do not entail. The load-bearing premise — *does
this receiver recognize this signer, for this purpose?* — is nowhere in the
program, so nothing can notice it is missing. (This is the S3 species the slice
exists to make refusable.)

In Slice /1 the conclusion's anatomy is **declared** as a schema, and each premise
is a structured proposition — a normal-form s-expression with named roles:

```lisp
(np '(:predicate :entry-complete (:entry "e-88") (:checklist "CL-full")))
;; => (:PREDICATE :ENTRY-COMPLETE (:CHECKLIST "CL-full") (:ENTRY "e-88"))
```

Roles are **sorted at construction** (`:checklist` before `:entry`), so equality
is role-order-insensitive and reduces to `EQUAL` on normal forms:

```lisp
(lisp-plus-slice1:structured-proposition=
  (np '(:predicate :entry-complete (:entry "e-88") (:checklist "CL-full")))
  (np '(:predicate :entry-complete (:checklist "CL-full") (:entry "e-88"))))  ; => T
(lisp-plus-slice1:normal-form-p
  (np '(:predicate :entry-complete (:entry "e-88") (:checklist "CL-full"))))  ; => T
```

A schema names a conclusion pattern, its required premise patterns (conjunctive),
and its schema-local variables. Register it under an exact `(name, version)`:

```lisp
(lisp-plus-slice1:clear-schema-registry)
(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :notebook-signoff :version 1
  :conclusion (pp '(:predicate :entry-signed-off
                    (:entry (:var :entry)) (:reviewer (:var :reviewer))
                    (:purpose (:var :purpose))))
  :premises
  (list (pp '(:predicate :entry-complete    (:entry (:var :entry)) (:checklist (:var :checklist))))
        (pp '(:predicate :results-reproduced (:entry (:var :entry)) (:replicate (:var :replicate))))
        (pp '(:predicate :reviewer-qualified (:reviewer (:var :reviewer)) (:competency (:var :competency))))
        (pp '(:predicate :purpose-permitted  (:entry (:var :entry)) (:reviewer (:var :reviewer))
                                             (:purpose (:var :purpose)))))
  :locals '(:checklist :replicate :competency)))
```

Now `derive` binds the conclusion, evaluates each declared premise against the
supplied supports, and grants **only when every premise is discharged**:

```lisp
(let* ((sup (list (dw '(:predicate :entry-complete    (:entry "e-88") (:checklist "CL-full")))
                  (dw '(:predicate :results-reproduced (:entry "e-88") (:replicate "rep-1")))
                  (dw '(:predicate :reviewer-qualified (:reviewer :alice) (:competency :radiochem)))
                  (dw '(:predicate :purpose-permitted  (:entry "e-88") (:reviewer :alice) (:purpose :archival)))))
       (position (apply #'ctx :alice sup)))
  (multiple-value-bind (claim receipt)
      (lisp-plus-slice1:derive
        :schema-name :notebook-signoff :schema-version 1
        :conclusion (np '(:predicate :entry-signed-off (:entry "e-88") (:reviewer :alice) (:purpose :archival)))
        :supports sup :receiver position)
    (list (lisp-plus-slice1:derivation-receipt-decision receipt)                 ; => :GRANTED
          (lisp-plus-slice0:judgment-record-judgment (lisp-plus-slice0:claim-judgment claim))))) ; => :VERIFIED
```

The grant is **a real Slice /0 promotion**: `derive` mints a derivation witness
and drives the frozen `raise` on the conclusion claim, keyed to
`(:derivation <this-schema's-key>)`. Omit one support and the grant refuses,
naming the gap — `derive` **signals** `derivation-refused`, carrying the receipt:

```lisp
(handler-case
    (lisp-plus-slice1:derive :schema-name :notebook-signoff :schema-version 1
      :conclusion (np '(:predicate :entry-signed-off (:entry "e-88") (:reviewer :alice) (:purpose :archival)))
      :supports (list (dw '(:predicate :entry-complete (:entry "e-88") (:checklist "CL-full")))
                      (dw '(:predicate :reviewer-qualified (:reviewer :alice) (:competency :radiochem)))
                      (dw '(:predicate :purpose-permitted (:entry "e-88") (:reviewer :alice) (:purpose :archival))))
      :receiver (ctx :alice))
  (lisp-plus-slice1:derivation-refused (c)
    (let ((r (lisp-plus-slice1:slice1-condition-receipt c)))
      (list (lisp-plus-slice1:derivation-receipt-decision r)                    ; => :REFUSED
            (lisp-plus-slice1:derivation-receipt-strongest-lawful-result r))))) ; => (:BLOCKED-ON :RESULTS-REPRODUCED :MISSING)
```

**`:missing` is not `false`.** The premise blocks the conclusion; it does not
refute it. A wrong-*role* support is different again — a `:teaching` permission
against an `:archival` conclusion lands `:mismatched`, and the receipt names the
conflicting role:

```lisp
;; supports carry (:purpose :teaching); the conclusion asks (:purpose :archival)
(disposition receipt :purpose-permitted)   ; => :MISMATCHED
(cdr (first (lisp-plus-slice1:premise-assessment-mismatched-candidates
             (assess receipt :purpose-permitted))))  ; => (:PURPOSE)
```

**Ceiling (binding).** Slice /1 enforces the anatomy you **declare**. A schema
that never represents signer-recognition is still free to be faithfully wrong —
the S3 species reproduces exactly under a schema that omits the premise (the
`de-praemissis` ablation proves it). "Slice /1 prevents S3" is only ever true as
*closed-when-the-schema-declares-it*; it discovers no premise an author left out.

## Mistake 2 — plurality mistaken for doubt

Idiomatic instinct: two independent reproductions of a result look like a
*conflict* to resolve, so a program refuses, or silently picks the first. Both are
wrong. **Plurality is evidence.** Two sufficient discharges of a non-unique
premise-local **grant, and the receipt preserves both**:

```lisp
(let* ((sup (list (dw '(:predicate :entry-complete    (:entry "e-88") (:checklist "CL-full")))
                  (dw '(:predicate :results-reproduced (:entry "e-88") (:replicate "rep-1")))   ; two
                  (dw '(:predicate :results-reproduced (:entry "e-88") (:replicate "rep-2")))   ; reproductions
                  (dw '(:predicate :reviewer-qualified (:reviewer :alice) (:competency :radiochem)))
                  (dw '(:predicate :purpose-permitted  (:entry "e-88") (:reviewer :alice) (:purpose :archival)))))
       (receipt (nth-value 1 (lisp-plus-slice1:derive :schema-name :notebook-signoff :schema-version 1
                  :conclusion (np '(:predicate :entry-signed-off (:entry "e-88") (:reviewer :alice) (:purpose :archival)))
                  :supports sup :receiver (apply #'ctx :alice sup)))))
  (list (lisp-plus-slice1:derivation-receipt-decision receipt)                          ; => :GRANTED
        (length (lisp-plus-slice1:derivation-receipt-complete-binding-environments receipt)) ; => 2
        (lisp-plus-slice1:derivation-receipt-multiply-supported-p receipt)              ; => T
        (lisp-plus-slice1:derivation-receipt-uniqueness-conflicts receipt)))            ; => NIL
```

Ambiguity begins **only where the schema declares that a choice matters.** Add an
`:authority` role to the reproduction premise and mark it `:unique-locals` — now
two *incompatible authorities* are a declared uniqueness conflict, and the
derivation refuses `:ambiguous`, naming the conflicted local:

```lisp
;; schema :notebook-signoff-authority — reproduction premise carries (:authority (:var :authority)),
;; :locals include :authority, :unique-locals '(:authority)
;; supports carry two reproductions, (:authority :internal-lab) and (:authority :external-audit)
(list (lisp-plus-slice1:derivation-receipt-decision receipt)          ; => :REFUSED
      (disposition receipt :results-reproduced)                       ; => :AMBIGUOUS
      (mapcar #'first (lisp-plus-slice1:derivation-receipt-uniqueness-conflicts receipt))) ; => (:AUTHORITY)
```

**Ceiling — Case C, made executable.** If the *same* two authorities were
materially incompatible but the schema carried **no** `:authority` role and **no**
uniqueness declaration, the derivation **grants with both environments preserved**
— and says so. Lisp+ will not infer incompatibility from suggestive names
(`"cert-vendor"` vs `"cert-self-signed"` are just strings). *Declared anatomy can
be enforced; undeclared domain distinctions cannot be divined.* If you want a
conflict caught, you must give the language a role to catch it on.

## Mistake 3 — the conclusion copied to a receiver who cannot rederive it

Idiomatic CL: a granted conclusion is a value; ship it. But a sign-off derived at
Alice's position stands on *Alice's* qualification and *Alice's* permission. Bob
cannot inherit it by copy. Slice /1 inherits Slice /0's law: **a derived
conclusion does not survive by status copy — it is re-derived at the target, over
the target's own lawful premises.** Two receivers, two derivations, two *distinct
receipt identities* — nothing traveled:

```lisp
;; Alice's supports name reviewer :alice; Bob's name reviewer :bob
(list da db                                              ; => :GRANTED :GRANTED
      (lisp-plus-kernel0:identity-key (lisp-plus-slice1:derivation-receipt-identity receipt-a))  ; => "receipt:derivation-receipt-19"
      (lisp-plus-kernel0:identity-key (lisp-plus-slice1:derivation-receipt-identity receipt-b))) ; => "receipt:derivation-receipt-21"
```

A **receiver-bound premise cannot cross receivers** — and this needs no special
case. `(:predicate :purpose-permitted … (:reviewer (:var :reviewer)) …)` simply
fails to match a target conclusion binding `?reviewer = bob` against a support for
`:alice`: it lands `:mismatched` with `:reviewer` named. Receiver-relativity is
enforced by ordinary binding coherence, not by dedicated code.

## Mistake 4 — a transported receipt treated as local proof

You may carry the *fact that a derivation happened* to another context — but a
transported derivation receipt is **testimony, not a local derivation.** Turn a
receipt into a support and it comes out at testimony level:

```lisp
(let ((t-support (lisp-plus-slice1:transported-testimony receipt-a :context-a :alice)))
  (list (lisp-plus-slice0:witness-mode t-support)     ; => :TESTIMONY
        (lisp-plus-slice0:witness-kind t-support)))   ; => :DERIVATION-REPORT
```

Offer that support to a derivation-keyed conclusion procedure at Bob's position
and the **frozen Slice /0 gate refuses it** — its `:for` is the attribution
`(:asserted :alice (:predicate :derived …))`, not the conclusion, so
`wrong-proposition-support` fires. The only lawful path to a conclusion at Bob is
a `derive` at Bob's position over Bob's premises. Receipt-transport laundering is
closed by the same mechanism that closes S3.

## End to end, in one sitting

```lisp
;; 1. declare the anatomy (Mistake 1's schema, already registered)
;; 2. assemble supports at a position
(let* ((sup (list (dw '(:predicate :entry-complete    (:entry "e-88") (:checklist "CL-full")))
                  (dw '(:predicate :results-reproduced (:entry "e-88") (:replicate "rep-1")))
                  (dw '(:predicate :reviewer-qualified (:reviewer :alice) (:competency :radiochem)))
                  (dw '(:predicate :purpose-permitted  (:entry "e-88") (:reviewer :alice) (:purpose :archival)))))
       (position (apply #'ctx :alice sup)))
  ;; 3. derive — grants, as a real :verified Slice /0 promotion
  (multiple-value-bind (claim receipt)
      (lisp-plus-slice1:derive :schema-name :notebook-signoff :schema-version 1
        :conclusion (np '(:predicate :entry-signed-off (:entry "e-88") (:reviewer :alice) (:purpose :archival)))
        :supports sup :receiver position)
    ;; 4. the receipt explains itself from its own fields — prose never invents
    (lisp-plus-slice1:render-derivation-why receipt)
    (lisp-plus-slice0:claim-judgment claim)))
```

A refused sitting renders every premise and its disposition, and a repair per
unsatisfied premise — all from receipt fields, nothing composed after the fact:

```
[derivation REFUSED] schema :NOTEBOOK-SIGNOFF v1
  premise :ENTRY-COMPLETE: SATISFIED
  premise :RESULTS-REPRODUCED: MISSING
  premise :REVIEWER-QUALIFIED: SATISFIED
  premise :PURPOSE-PERMITTED: MISSING
  repair for :RESULTS-REPRODUCED: (:SUPPLY-ACCESSIBLE-SUPPORT-MATCHING
                                   (:PREDICATE :RESULTS-REPRODUCED (:ENTRY "e-88") (:REPLICATE (:VAR :REPLICATE))))
  repair for :PURPOSE-PERMITTED:  (:SUPPLY-ACCESSIBLE-SUPPORT-MATCHING
                                   (:PREDICATE :PURPOSE-PERMITTED (:ENTRY "e-88") (:PURPOSE :ARCHIVAL) (:REVIEWER :ALICE)))
```

That's the slice. One new governed verb — `derive` — over structured
propositions and versioned schemas, with a derivation receipt on **every**
attempt, `why` still the one explanation door, and the six premise dispositions
(`:satisfied :missing :mismatched :refuted :inaccessible :ambiguous`) never
collapsed to a boolean.

## Three ceilings to keep in view

- **Enforcement is conditional on declaration.** No premise discovery. A schema
  that omits a premise cannot enforce it; the ablations prove opting out stays
  possible.
- **Plurality ≠ ambiguity.** Multiple sufficient derivations grant and are
  preserved; ambiguity arises only from a declared `:unique-locals` conflict; no
  discriminator mechanism exists in /1 (Case C).
- **Host-level closure is not claimed.** A same-image hand-built
  `(:derivation …)` witness that skips `derive` is the acknowledged stratum-3
  escape (CHARTER-DELTA-1 Δ3), inherited from Slice /0 unchanged. The governed
  path refuses and receipts; it does not make the host incapable.

---
*Companion documents: `LANGUAGE-SLICE-1-API.md` (every exported symbol, dull and
exact) · `LANGUAGE-SLICE-1-ARCHITECTURE.md` (the design record and the designs it
killed) · `SMOKE-1.lisp` (nine runnable demonstrations on exported symbols only).*

*Every code example above was executed under SBCL 2.4.6 on 2026-07-23 before being
written down; the refused-render block is verbatim harness output.*

— Claude Opus 4.8 (1M context), SCRIBA-II
