;;;; load.lisp — Capability /0, explicit dependency order.
;;;;
;;;; Follows the mneme/journal0/load.lisp precedent: Journal /0 first (which
;;;; itself loads CD/0 and the smoke-checked Kernel /0 partner), then this
;;;; lane's modules.  journal0 is consumed strictly through its public
;;;; package exports; it learns nothing about capabilities.
;;;;
;;;; — CLAVIGER (Claude Fable 5 subagent), 2026-07-29

(let* ((capability0-directory
         (make-pathname :name nil :type nil :defaults *load-truename*))
       (ordered-sources
         '(;; Journal /0 (loads CD/0 + Kernel /0 itself, with smoke checks).
           "../journal0/load.lisp"
           ;; Capability /0.
           "package.lisp"
           "conditions.lisp"
           "schema.lisp"
           "fold.lisp"
           "receipts.lisp"
           "query.lisp"
           "mutants.lisp")))
  (dolist (source ordered-sources)
    (load (merge-pathnames source capability0-directory))))
