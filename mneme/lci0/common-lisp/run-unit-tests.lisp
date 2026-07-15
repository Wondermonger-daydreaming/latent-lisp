(in-package #:cl-user)

;; Integration-successor unit gate.  The immutable pre-seed red transcript is
;; deliberately not loaded here: its three authorially blocked witnesses must
;; remain red evidence, while this runner reports only implementation-owned
;; failures from the 77-pass/18-blocked successor unit census.
(load "mneme/lci0/common-lisp/load.lisp")
(load "mneme/lci0/common-lisp/tests.lisp")
(unless (run-lci0-common-lisp-unit-tests)
  (sb-ext:exit :code 1))
(sb-ext:exit :code 0)
