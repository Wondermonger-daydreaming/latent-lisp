(asdf:defsystem #:lisp-plus-cd0
  :description "Independent Common Lisp implementation of Lisp+ Canonical Datum /0"
  :version "0.1.0"
  :license "Repository license"
  :serial t
  :components ((:file "package")
               (:file "cd0")))

(asdf:defsystem #:lisp-plus-cd0/tests
  :depends-on (#:lisp-plus-cd0)
  :serial t
  :components ((:file "tests"))
  :perform (asdf:test-op (operation component)
             (declare (ignore operation component))
             (unless (uiop:symbol-call :lisp-plus-cd0-tests :run-tests)
               (error "CD/0 tests failed"))))
