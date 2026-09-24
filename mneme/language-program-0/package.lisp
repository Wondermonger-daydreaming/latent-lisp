;;;; package.lisp — PROGRAM /0: the programming surface of Lisp+ (CANDIDATE).
;;;;
;;;; STANDING: CANDIDATE. Loading or running this lane adopts nothing and changes
;;;; no other lane's standing. Standing attaches to immutable object identities
;;;; and explicit dispositions, never to a filename or directory (Owner Ruling 6
;;;; §3 B1; MANY-ACTS-0-STANDING.md). This file's path confers no standing on
;;;; its bytes in either direction.
;;;;
;;;; Commissioned by the ruling office (Astra, GPT-6) through the owner on
;;;; 2026-09-23 late: "build a usable Lisp+ programming surface over the existing
;;;; runtime. Deliver running code." Built by the desktop chair (Claude Fable 5.1,
;;;; session "Level at Entry").
;;;;
;;;; TWO PACKAGES, on the Many Acts /0 pattern (language-many-acts-0/package.lisp):
;;;;
;;;;   lisp-plus-program0         — the implementation: reader, evaluator, values,
;;;;                                primitives, the Kernel /0 bridge, the runner API.
;;;;   lisp-plus-program0.source  — THE PROGRAM-SYMBOL NAMESPACE. Program sources
;;;;                                are READ with *package* bound here. It :USEs
;;;;                                nothing, so no Common Lisp symbol is reachable
;;;;                                from a program by name: `nil`, `t`, `eval`,
;;;;                                `load` written in a program are ordinary
;;;;                                unbound names (E-UNBOUND), not host operators.

(defpackage #:lisp-plus-program0
  (:use #:cl)
  (:export
   ;; conditions
   #:program0-error #:program0-error-code #:program0-error-message
   #:program0-error-location #:program0-error-path #:program0-error-frames
   #:render-program0-error
   ;; values
   #:closure #:closure-p #:primitive #:primitive-p
   #:refusal #:refusal-p #:refusal-kind #:refusal-requirement #:refusal-law
   #:host-value #:host-value-p #:host-value-lane #:host-value-kind
   #:render
   ;; environments and evaluation
   #:make-global-environment #:env #:env-p
   #:read-source-forms #:evaluate #:run-source #:run-file
   ;; policy
   #:*step-budget* #:*depth-limit* #:*max-source-nodes*
   #:+program0-version+))

(defpackage #:lisp-plus-program0.source
  (:use)
  (:documentation
   "THE PROGRAM-SYMBOL NAMESPACE for PROGRAM /0. Sources are READ with *package*
bound here and *read-eval* bound to NIL (the Many Acts /0 reader law, by
reference: MANY-ACTS-0-GRAMMAR.md §1b). Nothing is used, nothing is imported;
a symbol a program writes is homed HERE and means only what the PROGRAM /0
evaluator says it means."))
