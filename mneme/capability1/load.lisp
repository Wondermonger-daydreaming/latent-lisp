;;;; load.lisp — Capability /1, explicit dependency order.
;;;;
;;;; Follows the mneme/capability0/load.lisp precedent: Capability /0 first
;;;; (which itself loads Journal /0, and through it CD/0 and the
;;;; smoke-checked Kernel /0 partner), then this lane's modules.  Both
;;;; substrates are consumed strictly through their public package exports;
;;;; neither learns anything about live capability objects.
;;;;
;;;; — CLAVIGER-II (Claude Fable 5 subagent), 2026-07-29

(let* ((capability1-directory
         (make-pathname :name nil :type nil :defaults *load-truename*))
       (ordered-sources
         '(;; Capability /0 (loads Journal /0 + CD/0 + Kernel /0 itself).
           "../capability0/load.lisp"
           ;; Capability /1.
           "package.lisp"
           "conditions.lisp"
           "context.lisp"
           "object.lisp"
           "mint.lisp"
           "present.lisp"
           "mutants.lisp")))
  (dolist (source ordered-sources)
    (load (merge-pathnames source capability1-directory))))
