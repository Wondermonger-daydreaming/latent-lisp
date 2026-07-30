;;;; load.lisp — Capability /2, explicit dependency order.
;;;;
;;;; Follows the mneme/capability1/load.lisp precedent: Capability /1 first
;;;; (which itself loads Capability /0, and through it Journal /0, CD/0,
;;;; and the smoke-checked Kernel /0 partner), then this lane's modules.
;;;; Every substrate is consumed strictly through its public package
;;;; exports; none learns anything about effect attempts, worlds, or
;;;; authorization receipts.
;;;;
;;;; — CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30

(let* ((capability2-directory
         (make-pathname :name nil :type nil :defaults *load-truename*))
       (ordered-sources
         '(;; Capability /1 (loads capability0 + journal0 + CD/0 + kernel0).
           "../capability1/load.lisp"
           ;; Capability /2.
           "package.lisp"
           "conditions.lisp"
           "world.lisp"
           "events.lisp"
           "rehydrate.lisp"
           "authorize.lisp"
           "attempt.lisp"
           "reconcile.lisp"
           "mutants.lisp")))
  (dolist (source ordered-sources)
    (load (merge-pathnames source capability2-directory))))
