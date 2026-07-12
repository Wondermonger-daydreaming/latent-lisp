;;;; reload-provenance.lisp — The succession chamber survives a warm reload
;;;
;;;; Regression for round-three repair 1: a string DEFCONSTANT must reuse the
;;;; already-bound object or SBCL rejects the second load as non-EQL redefinition.

(load (merge-pathnames "../src/package.lisp" *load-truename*))
(load (merge-pathnames "../src/core.lisp" *load-truename*))
(load (merge-pathnames "../src/provenance.lisp" *load-truename*))

(in-package #:leibnitiana)

(print-section "PROVENANCE WARM-IMAGE RELOAD")
(let ((first-object +receipt-genesis-hash+)
      (source (merge-pathnames "../src/provenance.lisp" *load-truename*)))
  (load source)
  (check (eq first-object +receipt-genesis-hash+)
         "the reload reuses the EQL-identical genesis string object")
  (check-equal "0000000000000000"
               +receipt-genesis-hash+
               "the reload-safe idiom preserves the declared genesis value"))
