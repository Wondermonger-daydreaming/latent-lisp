;;;; EXPECT-CONDITION-RUNTIME — amended separate succession
;;;;
;;;; Ancestor SHA-256:
;;;; d8a957a2835d2d8809ce30c533ad182ce83b2cb7b27b4b6aed6d933d66e14a51
;;;; Sol's ruling: :AMEND-THEN-ADOPT (2026-07-12).
;;;; Standing: :amended-successor-pending-Sol-adoption.
;;;;
;;;; Customs-desk doctrine: classify conditions while their original signaling
;;;; context is alive.  Conditions outside SIBLING-TYPE are declined by the
;;;; handler and never transferred or re-signaled.
;;;;
;;;; Pairing rule: use literal EXPECT-CONDITION when the family is known at
;;;; macroexpansion; use EXPECT-CONDITION-RUNTIME when condition and family
;;;; types are runtime values.
;;;;
;;;; Probe-6 precedence: CONDITION-TYPE is tested before SIBLING-TYPE, so a
;;;; condition satisfying both is expected, never a mismatch.

(define-condition expect-condition-runtime-error (error) ())

(define-condition expect-condition-runtime-mismatch
    (expect-condition-runtime-error)
  ((expected-type :initarg :expected-type :reader mismatch-expected-type)
   (sibling-type :initarg :sibling-type :reader mismatch-sibling-type)
   (actual-condition :initarg :actual-condition :reader mismatch-actual-condition))
  (:report (lambda (condition stream)
             (format stream
                     "expected condition of type ~s within sibling family ~s, got ~s"
                     (mismatch-expected-type condition)
                     (mismatch-sibling-type condition)
                     (type-of (mismatch-actual-condition condition))))))

(define-condition expect-condition-runtime-missing
    (expect-condition-runtime-error)
  ((expected-type :initarg :expected-type :reader missing-expected-type)
   (sibling-type :initarg :sibling-type :reader missing-sibling-type))
  (:report (lambda (condition stream)
             (format stream
                     "expected condition of type ~s within sibling family ~s, but none fired"
                     (missing-expected-type condition)
                     (missing-sibling-type condition)))))

(defun expect-condition-runtime
    (thunk condition-type &key (sibling-type 'condition))
  "Call THUNK and require a condition matching CONDITION-TYPE.

The first condition matching CONDITION-TYPE succeeds. The first condition
matching SIBLING-TYPE but not CONDITION-TYPE becomes a mismatch. Conditions
outside SIBLING-TYPE are declined without transfer, preserving their original
signaling context. Normal return becomes a missing-condition diagnostic."

  (multiple-value-bind (outcome actual-condition)
      (block capture
        (handler-bind
            ((condition
               (lambda (condition)
                 (cond
                   ((typep condition condition-type)
                    (return-from capture
                      (values :expected condition)))

                   ((typep condition sibling-type)
                    (return-from capture
                      (values :sibling condition)))

                   ;; The outside remains outside:
                   ;; return from the handler, decline this condition,
                   ;; and let the original signaling protocol continue.
                   (t
                    nil)))))
          (funcall thunk)
          (values :missing nil)))

    ;; Diagnostics remain outside the observing handler.
    (ecase outcome
      (:expected
       t)

      (:sibling
       (error 'expect-condition-runtime-mismatch
              :expected-type condition-type
              :sibling-type sibling-type
              :actual-condition actual-condition))

      (:missing
       (error 'expect-condition-runtime-missing
              :expected-type condition-type
              :sibling-type sibling-type)))))
