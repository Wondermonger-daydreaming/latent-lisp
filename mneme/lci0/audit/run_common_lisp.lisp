(load "mneme/lci0/common-lisp/load.lisp")
(load "mneme/lci0/audit/common_lisp_runner.lisp")
(unless (lisp-plus-lci0::run-common-lisp-law-audit)
  (sb-ext:exit :code 1))
