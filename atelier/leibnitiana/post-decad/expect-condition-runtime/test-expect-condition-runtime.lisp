;;;; Native nine-row ledger for the amended EXPECT-CONDITION-RUNTIME succession.

(define-condition planted-family-error (error) ())
(define-condition planted-expected-error (planted-family-error) ())
(define-condition planted-sibling-error (planted-family-error) ())
(define-condition audit-outsider-note (condition) ())
(define-condition audit-repairable-outsider (error) ())

(load (merge-pathnames "expect-condition-runtime.lisp" *load-truename*))

(let ((passed 0))
  (labels ((run-row (number label thunk)
             (handler-case
                 (progn
                   (funcall thunk)
                   (incf passed)
                   (format t "[PASS ~d/9] ~a~%" number label))
               (error (condition)
                 (format *error-output* "[FAIL ~d/9] ~a — ~a~%"
                         number label condition)))))
    (format t "EXPECT-CONDITION-RUNTIME amended-successor ledger~%")

    (run-row 1 "original expected -> T"
             (lambda ()
               (assert
                (eq t
                    (expect-condition-runtime
                     (lambda () (error 'planted-expected-error))
                     'planted-expected-error
                     :sibling-type 'planted-family-error)))))

    (run-row 2 "original sibling -> mismatch"
             (lambda ()
               (handler-case
                   (expect-condition-runtime
                    (lambda () (error 'planted-sibling-error))
                    'planted-expected-error
                    :sibling-type 'planted-family-error)
                 (expect-condition-runtime-mismatch (diagnostic)
                   (assert (typep (mismatch-actual-condition diagnostic)
                                  'planted-sibling-error))
                   (assert (eq (mismatch-expected-type diagnostic)
                               'planted-expected-error))
                   (assert (eq (mismatch-sibling-type diagnostic)
                               'planted-family-error))))))

    (run-row 3 "original normal return -> missing"
             (lambda ()
               (handler-case
                   (expect-condition-runtime
                    (lambda () :normal-return)
                    'planted-expected-error
                    :sibling-type 'planted-family-error)
                 (expect-condition-runtime-missing (diagnostic)
                   (assert (eq (missing-expected-type diagnostic)
                               'planted-expected-error))
                   (assert (eq (missing-sibling-type diagnostic)
                               'planted-family-error))))))

    ;; Receiver probe 1: a continuable outsider must remain continuable.
    (run-row 4 "probe 1: continuable outsider remains continuable"
             (lambda ()
               (let ((outer-observations 0))
                 ;; Sol's literal HANDLER-CASE wrapper would itself catch the
                 ;; ordinary, declined SIGNAL.  Preserve the stated intent by
                 ;; leaving only the declining observer around the call.
                 (handler-bind
                     ((audit-outsider-note
                        (lambda (condition)
                          (declare (ignore condition))
                          (incf outer-observations)
                          nil)))
                   (assert
                    (expect-condition-runtime
                     (lambda ()
                       (signal 'audit-outsider-note)
                       (error 'planted-expected-error))
                     'planted-expected-error
                     :sibling-type 'planted-family-error))
                   (assert (= outer-observations 1))))))

    ;; Receiver probe 2: the outsider's signal-site restart remains live.
    (run-row 5 "probe 2: outsider restart remains available"
             (lambda ()
               (let ((repair-invoked nil))
                 (handler-bind
                     ((audit-repairable-outsider
                        (lambda (condition)
                          (let ((restart
                                  (find-restart 'repair-to-expected condition)))
                            (unless restart
                              (error "outsider arrived after its restart was unwound"))
                            (setf repair-invoked t)
                            (invoke-restart restart)))))
                   (assert
                    (expect-condition-runtime
                     (lambda ()
                       (restart-case
                           (error 'audit-repairable-outsider)
                         (repair-to-expected ()
                           (error 'planted-expected-error))))
                     'planted-expected-error
                     :sibling-type 'planted-family-error))
                   (assert repair-invoked)))))

    ;; Receiver probe 3: reaching this row proves LOAD returned to its caller.
    (run-row 6 "probe 3: implementation load returned"
             (lambda () t))

    ;; Receiver probe 4: mismatch retains the exact planted object.
    (run-row 7 "probe 4: mismatch retains object identity"
             (lambda ()
               (let ((planted (make-condition 'planted-sibling-error)))
                 (handler-case
                     (expect-condition-runtime
                      (lambda () (error planted))
                      'planted-expected-error
                      :sibling-type 'planted-family-error)
                   (expect-condition-runtime-mismatch (diagnostic)
                     (assert (eq planted
                                 (mismatch-actual-condition diagnostic))))))))

    ;; Receiver probe 5: diagnostics are emitted outside the observing net.
    (run-row 8 "probe 5: helper diagnostic remains outside its net"
             (lambda ()
               (handler-case
                   (expect-condition-runtime
                    (lambda () :normal-return)
                    'condition
                    :sibling-type 'condition)
                 (expect-condition-runtime-missing () t))))

    ;; Receiver probe 6: expected classification precedes sibling classification.
    (run-row 9 "probe 6: expected classification outranks family mismatch"
             (lambda ()
               (assert
                (expect-condition-runtime
                 (lambda () (error 'planted-expected-error))
                 'planted-family-error
                 :sibling-type 'condition))))

    (if (= passed 9)
        (progn
          (format t "RESULT: PASS — 9/9 rows passed~%")
          (sb-ext:exit :code 0))
        (progn
          (format *error-output* "RESULT: FAIL — ~d/9 rows passed~%" passed)
          (sb-ext:exit :code 1)))))
