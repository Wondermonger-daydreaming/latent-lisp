;;;; atelier-root.lisp — shared root for the Lisp+ Atelier specimens
;;;; Small, deliberately boring utilities. The toys may be strange; their floor should not be.

(defpackage #:lispplus-atelier
  (:use #:cl)
  (:export
   #:*atelier-clock* #:tick #:reset-clock
   #:canonical-string #:toy-digest #:toy-sign #:safe-read-one
   #:signals-error-p #:ensure #:pass #:banner #:section
   #:overlap-similarity #:plist-copy #:whitespace-only-p))

(in-package #:lispplus-atelier)

(defparameter *atelier-clock* 7000)

(defun reset-clock (&optional (value 7000))
  (setf *atelier-clock* value))

(defun tick ()
  (incf *atelier-clock*))

(defun canonical-string (object)
  "A readable, stable-enough representation for executable specimens.
Not a cross-implementation canonicalization standard; every specimen says so."
  (let ((caller-package *package*))
    (with-standard-io-syntax
      (let ((*print-circle* t)
            (*print-readably* t)
            (*package* caller-package))
        (prin1-to-string object)))))

(defun toy-digest (object)
  "Deterministic FNV-1a/64 digest for specimens. Not cryptographic."
  (let ((hash #x14650FB0739D0383)
        (prime #x100000001B3)
        (modulus (ash 1 64))
        (text (if (stringp object) object (canonical-string object))))
    (loop for ch across text
          do (setf hash (mod (* (logxor hash (char-code ch)) prime) modulus)))
    (format nil "~16,'0X" hash)))

(defun toy-sign (secret payload)
  "Pedagogical MAC. It demonstrates authority separation, not real cryptography."
  (toy-digest (list :secret secret :payload payload)))

(defun whitespace-only-p (string)
  (every (lambda (ch) (find ch " \t\n\r")) string))

(defun safe-read-one (text)
  "Read exactly one data form with reader evaluation disabled and no trailing payload."
  (let ((caller-package *package*))
    (with-standard-io-syntax
      (let ((*read-eval* nil)
            (*package* caller-package))
        (multiple-value-bind (value end) (read-from-string text nil :eof)
          (when (eq value :eof)
            (error "empty artifact"))
          (unless (whitespace-only-p (subseq text end))
            (error "trailing unread data after canonical form"))
          value)))))

(defun signals-error-p (thunk)
  (handler-case (progn (funcall thunk) nil)
    (error () t)))

(defun ensure (condition control &rest arguments)
  (unless condition
    (apply #'error control arguments))
  condition)

(defun pass (label)
  (format t "   ~a✓~%" label)
  t)

(defun banner (title)
  (format t "~%── ~a ~a~%~%"
          title
          (make-string (max 1 (- 68 (length title))) :initial-element #\─)))

(defun section (title)
  (format t "~%~a~%" title))

(defun flatten (object)
  (if (atom object)
      (list object)
      (mapcan #'flatten object)))

(defun overlap-similarity (a b)
  "Simple Jaccard overlap for transparent specimen scoring."
  (let* ((x (remove-duplicates (flatten a) :test #'equal))
         (y (remove-duplicates (flatten b) :test #'equal))
         (u (union x y :test #'equal)))
    (if (null u)
        0.0
        (/ (float (length (intersection x y :test #'equal)))
           (length u)))))

(defun plist-copy (plist)
  (loop for (key value) on plist by #'cddr append (list key value)))
