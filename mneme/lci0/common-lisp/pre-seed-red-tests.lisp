(in-package #:cl-user)

(defparameter *lci0-red-fixture-root*
  (or (sb-ext:posix-getenv "LCI0_FIXTURE_ROOT")
      "/tmp/lci0-seed-fixtures-20260714"))

(defparameter *lci0-risk-cases*
  '(("01-neutral-base-reference-and-bytes"
     ("LCI0-E1-01" "LCI0-E1-02" "LCI0-E1-03" "LCI0-E1-04"
      "LCI0-E1-05" "LCI0-E1-06" "LCI0-E1-07" "LCI0-E1-08"
      "LCI0-E1-09" "LCI0-E1-10"))
    ("02-one-identity-coordinate-changes-envelope"
     ("LCI0-P003" "LCI0-P004" "LCI0-P005" "LCI0-P006" "LCI0-P007"
      "LCI0-P008" "LCI0-P009"))
    ("03-nonidentity-metadata-preserves-envelope"
     ("LCI0-P001" "LCI0-METADATA-NEUTRAL-ALL-FIELDS"))
    ("04-undetermined-hard-inadmissible-policy-not-consulted"
     ("LCI0-N012" "LCI0-E2-UNKNOWN"))
    ("05-nonmonotone-narrowing-not-declared"
     ("LCI0-E5-NONMONOTONE-NARROWING"))
    ("06-narrowing-coverage-insufficient"
     ("LCI0-E5-COVERAGE-INSUFFICIENT"))
    ("07-temporal-containment-not-direct-support"
     ("LCI0-TEMPORAL-CONTAINED-BY" "LCI0-TEMPORAL-CONTAINS"))
    ("08-digest-does-not-replace-envelope"
     ("LCI0-E8-DIGEST-NOT-ENVELOPE" "LCI0-E8-DIGEST-ONLY-LOOKUP"))
    ("09-mutable-aliases-rejected"
     ("LCI0-E7-ALIAS-01" "LCI0-E7-ALIAS-02" "LCI0-E7-ALIAS-03"
      "LCI0-E7-ALIAS-04" "LCI0-E7-ALIAS-05" "LCI0-E7-ALIAS-06"
      "LCI0-E7-ALIAS-07" "LCI0-E7-ALIAS-08" "LCI0-E7-ALIAS-09"
      "LCI0-E7-ALIAS-10" "LCI0-E7-ALIAS-11" "LCI0-E7-ALIAS-12"
      "LCI0-E7-ALIAS-13" "LCI0-E7-ALIAS-14"))
    ("10-unknown-nested-versions-fail-closed"
     ("LCI0-I12-RECURSIVE-NESTED-VERSION"))
    ("11-proposition-location-placement-disagreement"
     ("LCI0-PLACEMENT-LOG-HORIZON-NEG"
      "LCI0-PLACEMENT-QUANTIFIED-DOMAIN-NEG"))
    ("12-legacy-fingerprint-collision-does-not-collapse-claim-id"
     ("LCI0-P027" "LCI0-P028" "LCI0-P029"))
    ("13-migrated-warrant-remains-inert"
     ("LCI0-E9-INERT-PREDECESSOR" "LCI0-E9-LIVE-RESTORATION"))
    ("14-unknown-fields-fail-closed"
     ("LCI0-METADATA-UNKNOWN-TOP-CLOSED" "LCI0-N001"))
    ("15-source-mutation-cannot-change-claim-id-bytes" :mutation)))

(defun run-lci0-pre-seed-risk-tests ()
  (let ((passes 0) (failures 0))
    (dolist (case *lci0-risk-cases*)
      (handler-case
          (progn
            (if (eq (second case) :mutation)
                (unless (lisp-plus-lci0:run-mutation-snapshot-test)
                  (error "mutation snapshot assertion returned false"))
                (unless (lisp-plus-lci0:run-vector-selection
                         (second case) *lci0-red-fixture-root*)
                  (error "selected fixture assertion returned false")))
            (incf passes)
            (format t "GREEN ~A~%" (first case)))
        (error (condition)
          (incf failures)
          (format t "RED   ~A -- ~A~%" (first case) condition))))
    (format t "LCI0 PRE-SEED RISK SUMMARY: ~D green, ~D red, ~D total~%"
            passes failures (+ passes failures))
    (when (plusp failures) (sb-ext:exit :code 1))))

(run-lci0-pre-seed-risk-tests)
