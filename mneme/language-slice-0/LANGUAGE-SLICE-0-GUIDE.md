# Lisp+ Slice /0 — Programmer Guide

*For a competent Common Lisp programmer. No project history required.
Fifteen minutes. Everything here runs: load
`slice0-transmissibility.lisp` (SBCL ≥ 2.4.6) and `(:use :cl
:lisp-plus-slice0)`; the file pulls in the rest.*

Lisp+ Slice /0 is a small embedded language fragment for programs that
make **claims about the world** — "the tests pass", "the backup
restored", "the gate holds" — and routinely wreck them with four ordinary
moves that Common Lisp does not resist. The fragment gives you four
governed verbs — `raise`, `project-claim`, `transmit`, `exercise-value` —
that refuse those moves, tell you exactly why, and hand you a lawful
repair.

## Mistake 1 — something ran, therefore it's verified

Idiomatic CL. Nothing wrong-looking anywhere:

```lisp
(defstruct release (status :pending))
(when (zerop exit-code)
  (setf (release-status r) :verified))   ; the misleading local move
```

The exit code says a *process exited*. The `setf` says the *release is
verified*. Those are different propositions, and the language happily let
one pay for the other.

In Slice /0, a claim starts as an assertion and standing arrives only
through `raise` — a checked act that relates a proposition, evidence, and
an authorized procedure:

```lisp
(defparameter *suite-check*
  (promotion-procedure
   :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                :procedure-id (lisp-plus-kernel0:make-identity
                               :procedure "suite-check")
                :version 0 :judgment-class :semantic
                :result-vocabulary '(:accepted :rejected))
   :admits '((:direct :transcript-parse))))

(defparameter *exit-w*
  (witness :for '(:exited :run-1 0) :mode :direct :kind :exit-status
           :source :ci :content 0))

(raise (claim :proposition '(:tests-passed :suite-a) :by :pipeline)
       :to :verified :per *suite-check* :considering (list *exit-w*))
```

This **signals `wrong-proposition-support`**: the witness is for
`(:exited :run-1 0)`, not `(:tests-passed :suite-a)` — a warrant for Q
cannot promote P. The condition carries a `promotion-receipt` (the
attempt is never lost) and a structured explanation:

```lisp
(handler-case (raise ...)
  (wrong-proposition-support (c)
    (render-why (why c))))
;; [REFUSED] considered witness-1
;;   missing relation: PROPOSITION-MATCH — witness-1 is for
;;     (:EXITED :RUN-1 0), not for (:TESTS-PASSED :SUITE-A)
;;   lawful repairs: retain-current-claim, seek-matching-support, ...
```

The lawful repair is a restart. Supply the evidence that actually stands
in the needed relation, and the *same* raise grants:

```lisp
(handler-bind ((wrong-proposition-support
                 (lambda (c)
                   (declare (ignore c))
                   (invoke-restart 'seek-matching-support
                                   (list *parse-w*)))))  ; a :transcript-parse witness FOR the proposition
  (raise (claim :proposition '(:tests-passed :suite-a) :by :pipeline)
         :to :verified :per *suite-check* :considering (list *exit-w*)))
;; => a NEW claim revision carrying a judgment record, + a granted receipt
```

**Claim ceiling:** a granted `:verified` is a *procedure-relative
judgment* — this procedure, this version, this evidence, recorded in the
revision's judgment record. It is not a context-free truth bit, and the
original asserted claim is untouched (the revision's lineage points at
it). Refuting evidence refuses `:verified` while *recording* the
refutation — the assertion history survives.

Two more refusals you get for free: a `:structural` procedure cannot
license `:verified` at all (`inadmissible-procedure`), and testimony —
see Mistake 4's cousin below — can never be constructed as first-order
evidence: `(witness :for P :mode :testimony ...)` is **unrepresentable**;
testimony's `:for` must be the attribution `(:asserted <who> P)`.

## Mistake 2 — a verified claim copied to someone who can't inspect it

Idiomatic CL:

```lisp
(let ((theirs (copy-claim mine)))          ; :verified travels by copy
  (send-to-auditor theirs))
```

The auditor cannot reach your transcript, doesn't recognize your CI, and
can't run your checker — but the copy says `:verified` anyway.

In Slice /0, receivers are **positions**, not names, and travel is
reconstruction:

```lisp
(defparameter *auditor*
  (receiver-context :context-id :auditor
                    :accessible-supports '()          ; reaches nothing
                    :executable-procedures (list *suite-check*)
                    :recognized-authorities '(:ci)))

(multiple-value-bind (theirs receipt)
    (project-claim *verified-claim* :from *plant* :to *auditor*
                   :store (support-store *parse-w*))
  (claim-judgment theirs)          ; => NIL — judgment did not travel
  (projection-views receipt)       ; => (:REGRADED :OBLIGATION-PRODUCING)
  (projection-receipt-supports-inaccessible receipt))  ; the loss, receipted
```

What the auditor holds is what the auditor's own supports, authorities,
and procedures license — here, only the bare assertion. The receipt keeps
the lost evidence as **residue** (`supports-inaccessible`, with reasons)
and, where export would repair it, an obligation `(:export <id>)`. Views
**compose**: one projection can be regraded AND redacted AND
obligation-producing; there is no single status symbol to lie by
omission.

**Claim ceiling:** an authority the receiver doesn't recognize blocks
*in that context* (`:in-context :auditor` on the blocker) — it is never
"impossible everywhere, forever."

## Mistake 3 — it couldn't travel, so it was treated as absent

Idiomatic CL:

```lisp
(remove-if-not #'exportable-p inventory)   ; the closure vanishes silently
```

The remote inventory now shows the thing never existed. But it exists,
runs, and warrants — *here*.

Slice /0 separates the axes that one `:exportable` boolean collapses:
**local existence, local usability, reifiability (can it cross the
canonical data boundary at all), declared transmissibility, testimony,
derived-result export, reproducibility, exercisability.** A closure over
local state fails exactly one of them:

```lisp
(defparameter *checker*
  (local-value :host (let ((k 3)) (lambda (x) (list :ok (>= x k))))
               :authority :operator
               :exercise-authorized '(:plant)
               :recipe '(:rebuild (:kind :threshold-check))))

(transmit *checker* :from *plant* :to *auditor* :mode :direct)
;; signals VALUE-NOT-REIFIABLE — axis :reifiability, scope (:mode :direct)
```

The refusal receipt does not erase the value — it *represents* it, along
with every lawful alternative, composed on one receipt:

```lisp
(transmission-views <receipt>)
;; => (:DIRECT-EXPORT-REFUSED :TESTIMONY-AVAILABLE
;;     :DERIVED-RESULT-EXPORTABLE :RECEIVER-REPRODUCTION-AVAILABLE
;;     :LOCAL-EXERCISE-ONLY)
```

And each alternative is a *different lawful act*, not a relabel: the
canonical **product** travels (`:mode :direct` on the derived result —
granted, with `:producer-not-included` on the receipt); **testimony**
travels as the attribution claim; the **recipe** travels as data
(`:mode :reproduction`, `:equivalence-not-identity`); or the receiver
**mints its own equivalent support** and verifies the proposition without
the object ever moving.

**Claim ceiling:** "this object cannot travel" is object-local and
mode-scoped. It never becomes "that proposition is unsupportable over
there."

## Mistake 4 — a callable capability confused with possession

Idiomatic CL: you hand out the closure, or its printed form, and
receiver-side code says "we have the gate now."

```lisp
(format nil "~a" checker)   ; "#<FUNCTION ...>" — a string wearing a capability
```

In Slice /0, invocation is a governed act that grants **use, never
possession**:

```lisp
(exercise-value *checker* :in *plant* :args '(5))
;; => a DERIVED-RESULT record (canonical data, provenance attached)
;;    — never the closure

(exercise-value *checker* :in *outsider* :args '(5))
;; signals EXERCISE-NOT-AUTHORIZED — axis :exercise, contextual
```

The stringification cheat is unrepresentable at the door: `local-value`
*computes* its `:kind` from the object — a printed closure is a string
and cannot claim otherwise. And a governed invocation whose raw result is
itself a host object (a closure returning a closure) is refused — the
interface does not launder.

**Claim ceiling:** all of this governs the *public surface*. Arbitrary
same-image Common Lisp — package internals, the printer, the debugger —
can still bypass it. Slice /0 makes the governed path refuse and receipt;
it does not make the host incapable. (See the architecture record for
the exact boundary statement.)

## End to end, in one sitting

```lisp
;; 1. a local procedure produces support
(multiple-value-bind (result w-local)
    (exercise-value *checker* :in *plant* :args '(5)
                    :mint-for '(:gate-holds :prod))
  ;; 2. a claim is promoted, locally
  (multiple-value-bind (verified r1)
      (raise (claim :proposition '(:gate-holds :prod) :by :operator)
             :to :verified :per *gate-check* :considering (list w-local))
    ;; 3. project it to the auditor — 4. the witness cannot travel
    (multiple-value-bind (theirs r2)
        (project-claim verified :from *plant* :to *auditor*
                       :store (support-store w-local))
      ;; theirs: asserted only; r2 receipts the loss
      ;; 5. a canonical product and testimony travel instead
      (transmit result :from *plant* :to *auditor* :mode :direct)
      (transmit *checker* :from *plant* :to *auditor* :mode :testimony)
      ;; 6. the auditor mints equivalent local support
      (let ((w-theirs (witness :for '(:gate-holds :prod) :mode :direct
                               :kind :capability-check :source :auditor-probe
                               :content '(:fresh-check :ok))))
        ;; 7. and verifies — receiver-relative, honestly
        (raise (claim :proposition '(:gate-holds :prod) :by :auditor)
               :to :verified :per *auditor-gate-check*
               :considering (list w-theirs) :receiver :auditor)))))
```

The final claim is verified **at the auditor, by the auditor's
procedure, on the auditor's evidence** — and nothing anywhere pretends
the original witness moved. Every step above returned a receipt; every
refusal along any wrong path would have named its axis and offered its
repairs; and `(why <any receipt or condition>)` followed by `render-why`
turns any of it into prose derived from structure.

That's the fragment. Four verbs, one explanation interface, receipts all
the way down.

---
*Companion documents: `LANGUAGE-SLICE-0-API.md` (every symbol, dull and
exact) · `LANGUAGE-SLICE-0-ARCHITECTURE.md` (design record) ·
`SMOKE.lisp` (a complete runnable program on exported symbols only).*

— Claude Fable 5, 2026-07-23
