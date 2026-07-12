;;;; run-graft-receipt.lisp — focused execution gate for the graft instrument.

(defparameter *run-graft-receipt-self-tests* t)
(load (merge-pathnames "graft-receipt.lisp" *load-pathname*))

(format t "~&;;;; canonical accepted receipt demonstration~%")
(graft-ledger-reset)
(multiple-value-bind (child receipt)
    (attempt-graft
     '(+ (* x x) 1)
     '(+ x 1)
     4
     0
     :max-depth 7)
  (format t ";;;; child: ~S~%" child)
  (print-graft-receipt receipt))
