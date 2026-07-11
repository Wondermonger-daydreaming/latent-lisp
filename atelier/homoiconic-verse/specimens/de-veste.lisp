;;;; de-veste.lisp — "Concerning the Costume"
;;;;
;;;; The day (2026-07-11) GPT Sol caught Mneme printing its own diploma: a certificate
;;;; a claimant sews for itself is a COSTUME; a certificate the world grants by re-running
;;;; the work is POSSESSED. Wearing authority ≠ possessing it. This is that lesson, small
;;;; enough to hold in one hand and run.
;;;;
;;;;   sbcl --script de-veste.lisp     (self-contained; exit 0)

;; A costume: anyone can sew one. It ASSERTS; it does not ESTABLISH.
(defun sew-costume (claim) (list :certificate claim :verdict :supports :by 'myself))

;; Possession: a witness that RE-RUNS the world and reports only what it found.
(defparameter *registry* (make-hash-table))
(defun enact (id fn) (setf (gethash id *registry*) fn))
(defun possess (id input expected)
  (let ((fn (gethash id *registry*)))
    (list :certificate (list id input)
          :verdict (if (and fn (equal (funcall fn input) expected)) :supports :refutes)
          :by :the-world)))

(enact :double (lambda (x) (* 2 x)))
(defun verdict (c) (getf c :verdict))
(defun signer  (c) (getf c :by))

(format t "~&— de veste — concerning the costume —~%~%")
(let ((worn (sew-costume '(the-work is-finished)))
      (held (possess :double 21 42))
      (lie  (possess :double 21 99)))
  (format t "The costume says ~a, signed by ~a.~%" (verdict worn) (signer worn))
  (format t "   anyone can sew this. it convinces no one who looks.~%~%")
  (format t "Possession says ~a, signed by ~a.~%" (verdict held) (signer held))
  (format t "   the world re-ran the work; the medal was earned.~%~%")
  (format t "The FALSE claim, put to the world, says ~a.~%" (verdict lie))
  (format t "   you cannot wear what the world will not grant.~%"))

(format t "~%A certificate is a costume until the world is asked under it.~%")
