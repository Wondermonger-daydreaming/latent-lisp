(load "mneme/lci0/common-lisp/load.lisp")

(in-package #:lisp-plus-lci0)

(defun integration-relation-failure-class (condition)
  (cond
    ((member (lci-failure-code condition)
             '("ScopeIncompatible" "UnsupportedTemporalModel")
             :test #'string=)
     "incompatible")
    ((member (lci-failure-code condition)
             '("ScopeRelationUnknown" "AdmissibilityUndetermined")
             :test #'string=)
     "unknown")
    (t (concatenate 'string "failure:" (lci-failure-code condition)))))

(defun integration-relation-entry-result (table-name row)
  (let ((datum (fixture-json-to-datum (jget row "abstract_cd0"))))
    (handler-case
        (identifier-last
         (if (string= table-name "scope_relation_table_0")
             (scope-relation (record-field-named datum "left-scope")
                             (record-field-named datum "right-scope"))
             (temporal-relation
              (record-field-named datum "left-subject-time")
              (record-field-named datum "right-subject-time"))))
      (lci-failure (condition)
        (integration-relation-failure-class condition)))))

(defun run-integration-relation-probe
    (&optional (root (or (sb-ext:posix-getenv "LCI0_FIXTURE_ROOT")
                        "/tmp/lci0-seed-fixtures-20260714")))
  (let ((total 0) (mismatches 0))
    (dolist (table-name '("scope_relation_table_0"
                          "temporal_relation_table_0"))
      (let ((table-total 0) (table-mismatches 0))
        (map-registry-relation-entries
         root table-name
         (lambda (row)
           (incf total)
           (incf table-total)
           (let ((actual (integration-relation-entry-result table-name row))
                 (expected (jget row "relation")))
             (unless (string= actual expected)
               (incf mismatches)
               (incf table-mismatches)
               (format t "RELATION-MISMATCH ~A ~A ~A expected=~A actual=~A~%"
                       table-name (jget row "left_fixture")
                       (jget row "right_fixture") expected actual)))))
        (format t "RELATION-TABLE ~A total=~D mismatches=~D~%"
                table-name table-total table-mismatches)))
    (format t "RELATION-TOTAL total=~D mismatches=~D~%" total mismatches)
    (zerop mismatches)))

(unless (run-integration-relation-probe)
  (sb-ext:exit :code 1))
