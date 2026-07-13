;;;; make-relay.lisp — emit chair-1 of an n-chair relay for any n>=2.
;;;; Form: (L 'L '(m1 m2 ... mn)) prints (L 'L '(m2 ... mn m1)) — rotate marks left.
;;;; Run chair-1 -> chair-2 -> ... -> chair-n -> chair-1 : a period-n orbit.
;;;; A generalization of the triad (n=3) and the relay pair (n=2): one lambda,
;;;; the marks a single list rotated by one each generation.
(defun make-relay (n dir)
  (let ((L '(LAMBDA (X MARKS)
              (WRITE (LIST X (LIST (QUOTE QUOTE) X)
                           (LIST (QUOTE QUOTE) (APPEND (CDR MARKS) (LIST (CAR MARKS)))))
                     :PRETTY NIL)))
        (marks (loop for i from 1 to n collect (list 'CHAIR i))))
    (with-open-file (s (merge-pathnames (format nil "ring-~D/chair-1.lisp" n) dir)
                       :direction :output :if-exists :supersede :if-does-not-exist :create)
      (write (list L (list 'quote L) (list 'quote marks)) :stream s :pretty nil))))
(let ((dir (or *load-pathname* *default-pathname-defaults*)))
  (dolist (n '(2 3 4 5))
    (ensure-directories-exist (merge-pathnames (format nil "ring-~D/x" n) dir))
    (make-relay n dir)))
