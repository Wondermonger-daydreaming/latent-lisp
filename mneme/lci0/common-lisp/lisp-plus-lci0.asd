(asdf:defsystem "lisp-plus-lci0"
  :description "Lisp+ Located Claim Identity /0 frozen fixture implementation"
  :version "0.1.0"
  :pathname "../../../"
  :serial t
  :components
  ((:file "canonical-datum/common-lisp/package")
   (:file "canonical-datum/common-lisp/cd0")
   (:file "mneme/lci0/common-lisp/package")
   (:file "mneme/lci0/common-lisp/json")
   (:file "mneme/lci0/common-lisp/values")
   (:file "mneme/lci0/common-lisp/fixture-adapter")
   (:file "mneme/lci0/common-lisp/registry")
   (:file "mneme/lci0/common-lisp/overlay")
   (:file "mneme/lci0/common-lisp/validation")
   (:file "mneme/lci0/common-lisp/calculi")
   (:file "mneme/lci0/common-lisp/matching")
   (:file "mneme/lci0/common-lisp/policy")
   (:file "mneme/lci0/common-lisp/migration")
   (:file "mneme/lci0/common-lisp/operations")
   (:file "mneme/lci0/common-lisp/harness")
   (:file "mneme/lci0/common-lisp/closure-surface")))
