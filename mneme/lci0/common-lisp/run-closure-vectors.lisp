(load "mneme/lci0/common-lisp/load.lisp")
(multiple-value-bind (passed-p passed total)
    (lisp-plus-lci0:run-closure-vectors
     (or (sb-ext:posix-getenv "LCI0_FIXTURE_ROOT")
         "/tmp/lci0-seed-fixtures-20260714"))
  (declare (ignore passed total))
  (unless passed-p (sb-ext:exit :code 1)))
