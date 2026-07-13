(load "canonical-datum/common-lisp/package.lisp")
(load "canonical-datum/common-lisp/cd0.lisp")
(load "canonical-datum/common-lisp/tests.lisp")

(handler-case
    (progn
      (lisp-plus-cd0-tests:run-tests)
      (sb-ext:exit :code 0))
  (condition (condition)
    (format *error-output* "CD/0 Common Lisp seed conformance: FAIL~%~A~%"
            condition)
    (sb-debug:print-backtrace :stream *error-output* :count 30)
    (sb-ext:exit :code 1)))
