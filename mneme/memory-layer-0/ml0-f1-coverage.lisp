;;;; ml0-f1-coverage.lisp — Memory Layer /0: the F1 inspection walk, shared by
;;;; `ml0-block-proof` probe F1 and `ml0-selftest` §K F1.
;;;;
;;;; CANDIDATE — P10 TRUTHFUL GATE /0 (Astra → Fable, 2026-09-16).  Nothing here
;;;; is adopted, and nothing here is independent verification.
;;;;
;;;; WHY THIS FILE EXISTS.  P10 REAL GATE /0 (atelier/p10-real-gate-0, ACCEPTED
;;;; 2026-09-15) established a concrete false negative: both checks wrapped the
;;;; introspection in `(handler-case (function-lambda-list s) (error () nil))`,
;;;; so a lambda list that could NOT be read was indistinguishable from an empty
;;;; one, and a planted forbidden parameter whose introspection was forced to
;;;; error passed CLOSED under the fixed note "walked every external fbound
;;;; symbol's compiled lambda list" (case U1-M).  The two checks are now ONE
;;;; walk, so they cannot drift apart again.
;;;;
;;;; THE RULE.  A check may report success only when it COMPLETED its declared
;;;; inspection AND found no offender.  Two findings are kept separate:
;;;;   coverage   — every external fbound symbol ATTEMPTED; each either INSPECTED
;;;;                (the instrument RETURNED A LAMBDA LIST, possibly NIL) or
;;;;                UNINSPECTABLE (it signalled, OR it returned `(values nil t)`
;;;;                = no lambda list recorded; either way NOT READ);
;;;;                attempted = inspected + uninspectable;
;;;;   violations — among the INSPECTED lambda lists, those carrying a parameter
;;;;                named DEFECT or DEFECT-PAYLOAD (the existing matcher scope).
;;;; Success ⇔ attempted > 0 ∧ uninspectable = 0 ∧ no offender.  An uninspectable
;;;; target is reported by name as NOT READ — nothing is established about its
;;;; parameters, in either direction.  A NIL lambda list returned successfully is
;;;; a compiled zero-argument function and counts as inspected.
;;;;
;;;; LOADING AND IDENTITY.  Loaded by the two checks only (right after
;;;; `ml0-suite-ground.lisp`); NOT loaded by `load.lisp`; every name is internal
;;;; (`%`-prefixed, never exported); no production runtime path reads it.  Its
;;;; presence changes the two checks' load closures and FILE-MANIFEST rows, and
;;;; nothing else in the lane.
;;;;
;;;; — Claude Fable 5.1 (chair), 2026-09-16

(in-package #:lisp-plus-memory-layer0)

(defparameter +ml0-f1-forbidden-parameter-names+ '("DEFECT" "DEFECT-PAYLOAD")
  "The existing matcher scope of F1, unchanged.")

(defun %ml0-f1-one-line (string &optional (limit 160))
  "Squeeze STRING to one line of at most LIMIT characters, for transcript lines."
  (let ((out (make-string-output-stream)))
    (loop for ch across string
          do (write-char (if (member ch '(#\Newline #\Return #\Tab)) #\Space ch) out))
    (let ((s (get-output-stream-string out)))
      (if (> (length s) limit) (concatenate 'string (subseq s 0 limit) "…") s))))

(defun %ml0-f1-escape-tildes (string)
  "`probe` folds its note through FORMAT again; a tilde in an error text would be
read as a directive.  Double every tilde so the text prints as itself."
  (with-output-to-string (out)
    (loop for ch across string
          do (write-char ch out)
             (when (char= ch #\~) (write-char ch out)))))

(defun %ml0-f1-forbidden-parameter-p (arglist)
  "The existing F1 matcher, verbatim in scope: a SYMBOL element of the compiled
lambda list whose name is one of `+ml0-f1-forbidden-parameter-names+`."
  (some (lambda (item)
          (and (symbolp item)
               (member (symbol-name item) +ml0-f1-forbidden-parameter-names+
                       :test #'string=)))
        arglist))

(defun %ml0-f1-inspect (symbol)
  "Three values: ARGLIST, INSPECTED-P, REASON.
INSPECTED-P is the success discriminator, and it is NOT the arglist: a NIL
arglist is a lawful answer (a compiled zero-argument function).  The instrument
has THREE outcomes, and only the first is an inspection —
  READ         `function-lambda-list` returned with its second value NIL: the
               lambda list was read; ARGLIST is it (possibly NIL).
  NO-LAMBDA-LIST  it returned `(values nil t)`: SBCL records no lambda list for
               this function (compiled with debug 0).  Nothing was read.  Found
               by SKEPTIC-TG (in-frame review, 2026-09-16): the r1 helper took
               the primary value only and counted this as an empty list — the
               U1-M mask again, reachable with no injected error.
  SIGNALLED    it signalled an `error`; REASON carries the condition TYPE and
               its one-line report (the type is the stable part — ml0.lisp §1).
INSPECTED-P is T only for READ; REASON is NIL then, a string otherwise."
  (handler-case
      (multiple-value-bind (arglist no-lambda-list-p)
          (sb-introspect:function-lambda-list symbol)
        (if no-lambda-list-p
            (values nil nil
                    "NO-LAMBDA-LIST: function-lambda-list returned (values nil t) — the compiled function carries no lambda list (debug 0); not read")
            (values arglist t nil)))
    (error (c)
      (values nil nil
              (format nil "SIGNALLED ~a: ~a" (type-of c)
                      (%ml0-f1-one-line (princ-to-string c)))))))

(defun %ml0-f1-walk (package)
  "Walk every EXTERNAL FBOUND symbol of PACKAGE once.  Returns a plist:
  :attempted n · :inspected n · :uninspectable ((NAME . error-text) …) ·
  :offenders (NAME …) · :complete-p · :closed-p
Counts are of TARGET SYMBOLS (one per external fbound symbol), never of
instrument calls — SBCL's `function-lambda-list` recurses internally."
  (let ((attempted 0) (inspected 0) (uninspectable '()) (offenders '()))
    (when package
      (do-external-symbols (symbol package)
        (when (fboundp symbol)
          (incf attempted)
          (multiple-value-bind (arglist inspected-p error-text)
              (%ml0-f1-inspect symbol)
            (cond (inspected-p
                   (incf inspected)
                   (when (%ml0-f1-forbidden-parameter-p arglist)
                     (push (symbol-name symbol) offenders)))
                  (t
                   (push (cons (symbol-name symbol) error-text) uninspectable)))))))
    (setf uninspectable (sort uninspectable #'string< :key #'car)
          offenders (sort offenders #'string<))
    (let ((complete-p (and (plusp attempted)
                           (null uninspectable)
                           (= attempted (+ inspected (length uninspectable))))))
      (list :attempted attempted
            :inspected inspected
            :uninspectable uninspectable
            :offenders offenders
            :complete-p complete-p
            :closed-p (and complete-p (null offenders))))))

(defun %ml0-f1-print-findings (walk &optional (stream *standard-output*))
  "The deterministic lines a classifier reads.  One F1-COVERAGE line; one
F1-UNINSPECTABLE line per target not read; one F1-OFFENDER line per detected
forbidden parameter."
  (format stream "~&F1-COVERAGE attempted=~d inspected=~d uninspectable=~d offenders=~d complete=~:[NIL~;T~]~%"
          (getf walk :attempted) (getf walk :inspected)
          (length (getf walk :uninspectable)) (length (getf walk :offenders))
          (getf walk :complete-p))
  (dolist (u (getf walk :uninspectable))
    (format stream "F1-UNINSPECTABLE name=~a error=~a~%" (car u) (cdr u)))
  (dolist (o (getf walk :offenders))
    (format stream "F1-OFFENDER name=~a~%" o))
  (finish-output stream))

(defun %ml0-f1-note (walk &key escape-tildes)
  "The human-readable note for the probe/check line: the same accounting in
prose.  With ESCAPE-TILDES the text is safe to hand to a caller that will fold
it through FORMAT again (`probe` does; `ml0-check` takes it as a ~a argument)."
  (let* ((attempted (getf walk :attempted))
         (inspected (getf walk :inspected))
         (uninspectable (getf walk :uninspectable))
         (offenders (getf walk :offenders))
         (text
           (with-output-to-string (s)
             (when offenders
               (format s "⚠ ~d exported function(s) still take it: ~{~a~^, ~} · "
                       (length offenders) offenders))
             (cond ((getf walk :complete-p)
                    (format s "inspection complete — ~d external fbound symbol(s) attempted = ~d inspected + 0 uninspectable; ~d forbidden parameter(s) detected"
                            attempted inspected (length offenders)))
                   ((zerop attempted)
                    (format s "⚠ inspection EMPTY — 0 external fbound symbols attempted; nothing was inspected"))
                   (t
                    (format s "⚠ inspection INCOMPLETE — ~d attempted = ~d inspected + ~d uninspectable [~{~a~^; ~}]; ~d forbidden parameter(s) detected among the ~d inspected; nothing is established about the uninspectable"
                            attempted inspected (length uninspectable)
                            (mapcar (lambda (u) (format nil "~a: ~a" (car u) (cdr u)))
                                    uninspectable)
                            (length offenders) inspected))))))
    (if escape-tildes (%ml0-f1-escape-tildes text) text)))
