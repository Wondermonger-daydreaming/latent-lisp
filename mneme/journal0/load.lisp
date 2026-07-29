;;;; load.lisp — Process Journal /0 store, explicit dependency order.
;;;;
;;;; Follows the mneme/kernel0/load.lisp precedent: Canonical Datum /0 first,
;;;; then the adopted Kernel /0 pure core (the §12-step-16 semantic partner),
;;;; then this store's modules.  kernel0/load.lisp runs its own smoke checks
;;;; and exits nonzero on failure — a green partner load is part of this
;;;; store's floor.

(require :sb-posix)

(let* ((journal0-directory
         (make-pathname :name nil :type nil :defaults *load-truename*))
       (ordered-sources
         '(;; CD/0 + Kernel /0 (loads canonical-datum itself, then smokes).
           "../kernel0/load.lisp"
           ;; Process Journal /0.
           "package.lisp"
           "sha256.lisp"
           "conditions.lisp"
           "pjs0.lisp"
           "frame.lisp"
           "meta.lisp"
           "reader.lisp"
           "writer.lisp"
           "salvage.lisp"
           "fold.lisp"
           "mutants.lisp")))
  (dolist (source ordered-sources)
    (load (merge-pathnames source journal0-directory))))
