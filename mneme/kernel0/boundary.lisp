(in-package #:lisp-plus-kernel0)

(defconstant +identity-canonicalization-procedure-id+
  "kernel0/durable-identity-to-cd0-identifier/v0")

(defconstant +string-canonicalization-procedure-id+
  "kernel0/non-empty-string-to-cd0-string/v0")

(defconstant +integer-canonicalization-procedure-id+
  "kernel0/integer-to-cd0-integer/v0")

(defconstant +keyword-canonicalization-procedure-id+
  "kernel0/keyword-to-cd0-identifier/v0")

(defconstant +proper-list-canonicalization-procedure-id+
  "kernel0/proper-list-to-cd0-sequence/v0")

(defstruct (%canonicalization-procedure
            (:constructor %make-canonicalization-procedure
                (id predicate function))
            (:copier nil))
  (id "" :type string :read-only t)
  (predicate nil :type function :read-only t)
  (function nil :type function :read-only t))

(defvar *canonicalization-procedures* nil)

(defun register-canonicalization-procedure (procedure-id predicate function)
  "Register an identified host-to-CD/0 canonicalization procedure.

PROCEDURE-ID must be a non-empty string.  PREDICATE and FUNCTION must be
functions.  Registrations accumulate; REQUIRE-CANONICAL refuses rather than
choosing when registered predicates overlap."
  (unless (and (stringp procedure-id)
               (plusp (length procedure-id))
               (functionp predicate)
               (functionp function))
    (signal-kernel0
     'unresolved-identity
     :failed-invariant
     "§2.1 [F: HOST-2]: a durable-boundary conversion MUST use an identified canonicalization procedure"))
  (setf *canonicalization-procedures*
        (append *canonicalization-procedures*
                (list (%make-canonicalization-procedure
                       (copy-seq procedure-id) predicate function))))
  procedure-id)

(defun %signal-noncanonical-durable-value (context)
  (apply #'signal-kernel0
         'noncanonical-durable-value
         :failed-invariant
         "§2.1 [F: HOST-2]: before crossing a durable boundary a host value MUST already be CD/0 or be converted by one identified procedure to a CD/0 value"
         (%identity-condition-context context)))

(defun %applicable-canonicalization-procedures (value)
  (loop for procedure in *canonicalization-procedures*
        when (funcall (%canonicalization-procedure-predicate procedure) value)
          collect procedure))

(defun require-canonical (value &key context)
  "Return VALUE if it is CD/0, otherwise apply one identified procedure.

Exactly one registered predicate must match and its result must be a CD/0
datum.  Zero matches, overlapping matches, predicate/converter failure, and a
non-CD/0 result all signal NONCANONICAL-DURABLE-VALUE.  If CONTEXT is a durable
process, attempt, seat, or operation identity, it is retained in the matching
section 20.1 condition slot.  Floats have no built-in procedure and are
therefore refused."
  (when (lisp-plus-cd0:datum-p value)
    (return-from require-canonical value))
  (handler-case
      (let ((procedures (%applicable-canonicalization-procedures value)))
        (unless (= 1 (length procedures))
          (%signal-noncanonical-durable-value context))
        (let ((datum
                (funcall
                 (%canonicalization-procedure-function (first procedures))
                 value)))
          (unless (lisp-plus-cd0:datum-p datum)
            (%signal-noncanonical-durable-value context))
          datum))
    (kernel0-condition (condition)
      (error condition))
    (error ()
      (%signal-noncanonical-durable-value context))))

(defun %non-empty-string-p (value)
  (and (stringp value) (plusp (length value))))

(defun %keyword->datum (value)
  ;; Exact SYMBOL-NAME case is retained.  Downcasing would collapse distinct
  ;; escaped Common Lisp keyword names.
  (lisp-plus-cd0:make-identifier-datum
   '("common-lisp" "keyword")
   (list (symbol-name value))))

(defun %proper-list->datum (value)
  (lisp-plus-cd0:make-sequence-datum
   (mapcar #'require-canonical value)))

(register-canonicalization-procedure
 +identity-canonicalization-procedure-id+
 #'durable-identity-p
 #'identity->datum)

(register-canonicalization-procedure
 +string-canonicalization-procedure-id+
 #'%non-empty-string-p
 #'lisp-plus-cd0:make-string-datum)

(register-canonicalization-procedure
 +integer-canonicalization-procedure-id+
 #'integerp
 #'lisp-plus-cd0:make-integer-datum)

(register-canonicalization-procedure
 +keyword-canonicalization-procedure-id+
 #'keywordp
 #'%keyword->datum)

(register-canonicalization-procedure
 +proper-list-canonicalization-procedure-id+
 #'%proper-list-p
 #'%proper-list->datum)
