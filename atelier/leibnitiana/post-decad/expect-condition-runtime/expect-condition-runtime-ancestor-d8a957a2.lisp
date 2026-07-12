;;;; EXPECT-CONDITION-RUNTIME — prototype separate succession
;;;;
;;;; Provenance: prototype, lab-authored (Claude Fable 5 chair / FIGULUS hands),
;;;; licensed by Sol's return letter §5 on 2026-07-12.
;;;; :designation :prototype-separate-succession
;;;; :standing :prototype-supported-by-shared-root-audit
;;;;
;;;; PAIRED WITH the literal EXPECT-CONDITION macro: use that macro when the
;;;; condition type is literal and known at macroexpansion time; use this
;;;; function when the condition type is a runtime value.  This prototype is
;;;; explicitly NOT retrofitted into any landed instrument.

(define-condition expect-condition-runtime-error (error) ())

(define-condition expect-condition-runtime-mismatch
    (expect-condition-runtime-error)
  ((expected-type :initarg :expected-type :reader mismatch-expected-type)
   (actual-condition :initarg :actual-condition :reader mismatch-actual-condition))
  (:report (lambda (condition stream)
             (format stream "expected condition of type ~s, got sibling ~s"
                     (mismatch-expected-type condition)
                     (type-of (mismatch-actual-condition condition))))))

(define-condition expect-condition-runtime-missing
    (expect-condition-runtime-error)
  ((expected-type :initarg :expected-type :reader missing-expected-type))
  (:report (lambda (condition stream)
             (format stream "expected condition of type ~s, but none fired"
                     (missing-expected-type condition)))))

(defun expect-condition-runtime (thunk condition-type &key (sibling-type 'condition))
  "Call THUNK and require a condition matching runtime value CONDITION-TYPE.

Return T when the expected condition fires.  If a condition matching the
runtime SIBLING-TYPE fires but does not match CONDITION-TYPE, signal
EXPECT-CONDITION-RUNTIME-MISMATCH.  If THUNK returns normally, signal
EXPECT-CONDITION-RUNTIME-MISSING.  A condition outside SIBLING-TYPE is
re-signaled unchanged.  CONDITION-TYPE and SIBLING-TYPE are TYPEP type
specifiers evaluated as ordinary runtime values; neither is inserted into a
HANDLER-CASE clause."
  (let ((caught-condition nil))
    (handler-case
        (funcall thunk)
      (condition (condition)
        (cond ((typep condition condition-type)
               (return-from expect-condition-runtime t))
              ((typep condition sibling-type)
               (setf caught-condition condition))
              (t
               (error condition)))))
    (if caught-condition
        (error 'expect-condition-runtime-mismatch
               :expected-type condition-type
               :actual-condition caught-condition)
        (error 'expect-condition-runtime-missing
               :expected-type condition-type))))

;;; Self-test exhibit: each declared trichotomy tooth must bite in this run.

(define-condition planted-family-error (error) ())
(define-condition planted-expected-error (planted-family-error) ())
(define-condition planted-sibling-error (planted-family-error) ())

(defun self-test ()
  (let ((passed 0))
    (format t "EXPECT-CONDITION-RUNTIME self-test ledger~%")
    (flet ((pass (tooth)
             (incf passed)
             (format t "[BITE ~d/3] ~a~%" passed tooth)))
      (let ((runtime-type 'planted-expected-error))
        (when (expect-condition-runtime
               (lambda () (error 'planted-expected-error))
               runtime-type
               :sibling-type 'planted-family-error)
          (pass "expected condition -> success value T")))
      (handler-case
          (expect-condition-runtime
           (lambda () (error 'planted-sibling-error))
           'planted-expected-error
           :sibling-type 'planted-family-error)
        (expect-condition-runtime-mismatch (condition)
          (unless (typep (mismatch-actual-condition condition)
                         'planted-sibling-error)
            (error "mismatch tooth carried the wrong planted condition"))
          (pass "family sibling -> distinct mismatch error")))
      (handler-case
          (expect-condition-runtime
           (lambda () :returned-without-firing)
           'planted-expected-error
           :sibling-type 'planted-family-error)
        (expect-condition-runtime-missing ()
          (pass "normal return -> distinct missing-condition error"))))
    (unless (= passed 3)
      (error "self-test ledger incomplete: ~d/3 teeth bit" passed))
    (format t "RESULT: PASS — 3/3 teeth bit~%")
    t))

(handler-case
    (progn
      (self-test)
      (sb-ext:exit :code 0))
  (condition (condition)
    (format *error-output* "RESULT: FAIL — ~a~%" condition)
    (sb-ext:exit :code 1)))
