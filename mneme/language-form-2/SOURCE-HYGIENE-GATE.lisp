;;;; SOURCE-HYGIENE-GATE.lisp — Language Form /2, Lexical Source Erratum 0.1.
;;;;
;;;; Run: sbcl --script mneme/language-form-2/SOURCE-HYGIENE-GATE.lisp
;;;;      (from the latent-lisp root; cwd-independent — it resolves its own dir)
;;;;
;;;; WHY THIS FILE EXISTS.
;;;;
;;;; Form /2's selftest reported "86 checks passed / 0 failed" for as long as
;;;; form2.lisp carried two genuine compiler WARNINGs, because its loader bound
;;;; *ERROR-OUTPUT* to an empty broadcast stream — a sink — and every diagnostic
;;;; went into it.  The two warnings were:
;;;;
;;;;   undefined variable: LISP-PLUS-FORM2::LAWFUL
;;;;       an unescaped interior quote in %BUILD-RECEIPT's docstring terminated
;;;;       the string early, so the word Lawful was read as an executable
;;;;       variable reference sitting in the function body;
;;;;
;;;;   undefined variable: LISP-PLUS-FORM2::*%FAULT-REBUILD-CD0-FAILURE*
;;;;       %REBUILD read the planted-fault special in its first form, while the
;;;;       DEFVAR sat ~70 lines further down the file.
;;;;
;;;; Neither was a behavioural defect, and that is precisely the point: a
;;;; behavioural suite passing does not certify that the source compiled
;;;; cleanly, and a suite that cannot SEE a warning is not evidence there was
;;;; none.  This gate exists so those two facts are checked by something other
;;;; than a reader's attention.
;;;;
;;;; SCOPE.  Source hygiene and the exact regression facts the erratum owes.
;;;; It asserts nothing about Form /2 semantics that the selftest does not
;;;; already assert, changes no count in any existing gate, and confers no
;;;; standing.  Form /2 remains a published candidate-by-default.

(in-package #:cl-user)

(defparameter *here*
  (make-pathname :name nil :type nil
                 :defaults (or *load-truename* *default-pathname-defaults*)))

(defparameter *checks* 0)
(defparameter *failed* 0)

(defun check (ok label)
  (incf *checks*)
  (if ok
      (format t "  ok    ~a~%" label)
      (progn (incf *failed*)
             (format t "  FAIL  ~a~%" label))))

(format t "~%== Form /2 source-hygiene gate (Lexical Source Erratum 0.1) ==~%~%")

;;; ------------------------------------------------------------------
;;; H1 — loading form2.lisp emits no non-style warnings.
;;;
;;; *ERROR-OUTPUT* is NOT rebound to a sink here.  Non-style warnings are
;;; collected by declining handler, so they remain visible AND countable.
;;; ------------------------------------------------------------------

(defparameter *nonstyle* '())

(handler-bind ((style-warning #'muffle-warning)
               (warning (lambda (w) (push (princ-to-string w) *nonstyle*))))
  (load (merge-pathnames "form2.lisp" *here*)))

(setf *nonstyle* (nreverse *nonstyle*))

(check (null *nonstyle*)
       (format nil "H1 loading form2.lisp emits 0 non-style warnings (observed ~a)"
               (length *nonstyle*)))
(dolist (w *nonstyle*)
  (format t "        > ~a~%" w))

;;; ------------------------------------------------------------------
;;; H2 — %BUILD-RECEIPT's documentation is ONE continuous string that still
;;; contains the intended sentence, with Lawful present as TEXT.
;;; ------------------------------------------------------------------

(let ((doc (documentation 'lisp-plus-form2::%build-receipt 'function)))
  (check (stringp doc) "H2a %BUILD-RECEIPT has a documentation string")
  (when (stringp doc)
    (check (search "(values RECEIPT nil)" doc)
           "H2b the docstring still starts at the intended first sentence")
    (check (search "only path by which a receipt exists" doc)
           "H2c the docstring still reaches its intended final sentence")
    (check (search "\"Lawful\" was the earlier word and it was too broad" doc)
           "H2d the Lawful sentence survives INSIDE the docstring, quotes and all")
    (check (search "WHAT THAT DOES NOT ESTABLISH" doc)
           "H2e the limits paragraph is inside the same string, not orphaned")))

;;; ------------------------------------------------------------------
;;; H3 — no executable LAWFUL variable form remains anywhere in the package.
;;;
;;; Two independent witnesses: the symbol does not exist in the package at all,
;;; and the source text carries no unescaped interior quote on that line.
;;; ------------------------------------------------------------------

(check (null (find-symbol "LAWFUL" (find-package "LISP-PLUS-FORM2")))
       "H3a no symbol named LAWFUL exists in LISP-PLUS-FORM2 (so none can be read)")

(let* ((path (merge-pathnames "form2.lisp" *here*))
       (text (with-open-file (s path :external-format :utf-8)
               (let ((buf (make-string (file-length s))))
                 (subseq buf 0 (read-sequence buf s))))))
  (check (search "\\\"Lawful\\\" was the earlier word" text)
         "H3b the source carries the ESCAPED form of the Lawful quotes")
  (check (not (search (format nil "~%\"Lawful\" was the earlier word") text))
         "H3c no line begins with an unescaped \"Lawful\" (the exact old defect)"))

;;; ------------------------------------------------------------------
;;; H4 — the planted-fault special is declared before its first reader.
;;; ------------------------------------------------------------------

(let* ((path (merge-pathnames "form2.lisp" *here*))
       (text (with-open-file (s path :external-format :utf-8)
               (let ((buf (make-string (file-length s))))
                 (subseq buf 0 (read-sequence buf s)))))
       (defvar-at (search "(defvar *%fault-rebuild-cd0-failure*" text))
       (reader-at (search "(defun %rebuild " text)))
  (check (and defvar-at reader-at (< defvar-at reader-at))
         "H4 *%FAULT-REBUILD-CD0-FAILURE* is DEFVAR'd before %REBUILD, its first reader")
  (check (boundp 'lisp-plus-form2::*%fault-rebuild-cd0-failure*)
         "H4b the special is bound after load")
  (check (null (symbol-value 'lisp-plus-form2::*%fault-rebuild-cd0-failure*))
         "H4c its default value is still NIL"))

(check (eq :internal
           (nth-value 1 (find-symbol "*%FAULT-REBUILD-CD0-FAILURE*"
                                     (find-package "LISP-PLUS-FORM2"))))
       "H4e the fault hook remains INTERNAL (unexported), as before the erratum")

;;; ------------------------------------------------------------------
;;; H5 — an ordinary successful TRY-APPLY-REPLACEMENT is unchanged:
;;; successor + receipt + no refusal.
;;; ------------------------------------------------------------------

(macrolet ((f2 (name &rest args)
             `(,(intern (string name) '#:lisp-plus-form2) ,@args))
           (cd0 (name &rest args)
             `(,(intern (string name) '#:lisp-plus-cd0) ,@args)))
  (labels ((txt (s) (cd0 make-string-datum s))
           (sq (l) (cd0 make-sequence-datum l))
           (idr (ns p) (cd0 make-identifier-datum ns p))
           (rec (pairs) (cd0 make-record-datum
                             (mapcar (lambda (p) (cd0 make-record-entry (car p) (cdr p)))
                                     pairs)))
           (tree ()
             (sq (list (idr '("demo") '("root"))
                       (txt "alpha")
                       (rec (list (cons (idr '("demo") '("k1")) (txt "one"))
                                  (cons (idr '("demo") '("k2")) (txt "two")))))))
           (proposal ()
             (f2 replacement-proposal-datum
                 :input (tree)
                 :path (f2 path-datum (f2 index-step 1))
                 :expected-old (txt "alpha")
                 :replacement (txt "GAMMA")
                 :occurrence-tag (txt "tag-0001"))))

    (multiple-value-bind (p refusal) (f2 try-propose-replacement (proposal))
      (check (and p (null refusal)) "H5a an ordinary proposal is accepted")
      (when p
        (multiple-value-bind (successor receipt r2) (f2 try-apply-replacement p)
          (check successor "H5b a successful apply returns a successor")
          (check receipt   "H5c a successful apply returns a receipt")
          (check (null r2) "H5d a successful apply returns NO refusal")
          (check (f2 form-transformation-receipt-p receipt)
                 "H5e the receipt is a real FORM-TRANSFORMATION-RECEIPT"))))

    ;; ----------------------------------------------------------------
    ;; H6 — the planted CD/0 rebuild fault still reaches its existing
    ;; reclassification checks.  Same fixture the selftest uses.
    ;; ----------------------------------------------------------------
    (let ((lisp-plus-form2::*%fault-rebuild-cd0-failure* t))
      (multiple-value-bind (p refusal) (f2 try-propose-replacement (proposal))
        (declare (ignore refusal))
        (multiple-value-bind (successor receipt r2) (f2 try-apply-replacement p)
          (check (and (null successor) (null receipt) r2)
                 "H6a the planted CD/0 rebuild fault still produces a refusal, no successor")
          (when r2
            (check (eq :rebuild-record-key-work-exceeded
                       (f2 form-transformation-refusal-code r2))
                   "H6b it is still reclassified under the Form /2 code")
            (check (equal "host-import" (f2 form-transformation-refusal-upstream-stage r2))
                   "H6c CD/0's upstream stage label is still PRESERVED")
            (check (equal "ResourceRefusal" (f2 form-transformation-refusal-upstream-category r2))
                   "H6d the upstream category is still retained")
            (check (equal "RecordKeyWorkBudgetExceeded" (f2 form-transformation-refusal-upstream-code r2))
                   "H6e the upstream code is still retained")))))))

;;; ------------------------------------------------------------------

(format t "~%== Form /2 source hygiene: ~a passed / ~a failed ==~%"
        (- *checks* *failed*) *failed*)
(format t "~%SELF-CONSISTENCY ONLY.  This gate certifies that the source compiles~%")
(format t "clean and that the erratum's named regressions hold.  It confers no~%")
(format t "standing: Form /2 remains a published candidate-by-default, its stranger~%")
(format t "audit is OWED, and nothing here adopts anything.~%")

(if (zerop *failed*)
    (progn (format t "~%RESULT: PASS~%") (finish-output) (sb-ext:exit :code 0))
    (progn (format t "~%RESULT: FAIL~%") (finish-output) (sb-ext:exit :code 1)))
