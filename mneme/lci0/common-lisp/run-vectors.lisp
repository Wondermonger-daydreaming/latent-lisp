(load "mneme/lci0/common-lisp/load.lisp")
(multiple-value-bind (passed-p passed total failures)
    (lisp-plus-lci0:run-all-vectors
     (or (sb-ext:posix-getenv "LCI0_FIXTURE_ROOT")
         "/tmp/lci0-seed-fixtures-20260714")
     :verbose t :verify-documents t)
  (declare (ignore passed total failures))
  (unless passed-p (sb-ext:exit :code 1)))
