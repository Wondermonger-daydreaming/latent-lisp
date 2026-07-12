;;;; garden-grafted.lisp — load the Garden with exact crossover receipts.
;;;;
;;;; This is an optional adapter, not a replacement for garden.lisp.
;;;; In run.lisp, change only:
;;;;
;;;;   (load (merge-pathnames "garden.lisp" *load-pathname*))
;;;;
;;;; to:
;;;;
;;;;   (load (merge-pathnames "garden-grafted.lisp" *load-pathname*))
;;;;
;;;; CROSSOVER, REGISTER, and LEDGER-RESET keep their old calling conventions.
;;;; A parallel *GRAFT-LEDGER* now records and seals every crossover attempt.

(defparameter *run-self-tests* nil)
(load (merge-pathnames "garden.lisp" *load-pathname*))

(defparameter *run-graft-receipt-self-tests* nil)
(load (merge-pathnames "graft-receipt.lisp" *load-pathname*))

(defparameter *graft-journal-path*
  (merge-pathnames "grafts.sexp" *load-pathname*))

(graft-ledger-reset)
(reset-graft-journal)
(install-graft-instrumentation)
