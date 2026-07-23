;; plants a direct record-slot mutation
(let ((c (lisp-plus-slice0:claim :proposition '(:a 1) :by :x)))
  (setf (lisp-plus-slice0:claim-proposition c) '(:b 2)))
