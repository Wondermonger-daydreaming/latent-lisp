(in-package #:lisp-plus-lci0)

;;; Frozen v1 migration fixtures only.  This module never invokes a reader,
;;; package lookup, symbol resolution, legacy procedure, or live warrant path.

(defparameter +legacy-source-fields+
  '("kind" "schema-version" "source-artifact" "source-bytes" "grammar"
    "parse-expected" "parsed-inert-value"))

(defparameter +legacy-record-fields+
  '("kind" "schema-version" "fixture-name" "source-record-site"
    "proposition" "fingerprint" "as-of" "scope-token" "corpus-token"
    "frame-token" "predecessor-warrants" "attempt-live-restoration"))

(defun %legacy-fixture-name (value)
  (let ((name (record-field-named value "fixture-name")))
    (and (string-datum-p name) (datum-string-value* name))))

(defun %validate-legacy-inert-record (value)
  (require-record value "UnsupportedLegacyForm" "migration-source" nil)
  ;; N027 is the pinned identity-loss witness: deterministic field order makes
  ;; the absent frame coordinate the first migration-specific refusal.
  (unless (record-has-field-p value "frame-token")
    (lci-fail "migration-refusal" "IdentityBearingLoss" "represented-loss"
              :path '("fixture-field:frame-token")))
  (let ((fields (if (string= (%legacy-fixture-name value)
                             "semantic-wrong-mapping")
                    (append +legacy-record-fields+ '("mapping-candidate"))
                    +legacy-record-fields+)))
    (require-closed-fields value fields "migration-source"))
  value)

(defun parse-legacy-fixture (source)
  "Validate the sealed, non-evaluating fixture-source wrapper and return its
declared inert value.  SOURCE-BYTES are never passed to the Common Lisp reader."
  (require-record source "UnsupportedLegacyForm" "migration-source" nil)
  (let ((parse-expected (record-field-named source "parse-expected")))
    (if (and (boolean-datum-p parse-expected)
             (not (boolean-datum-value parse-expected)))
        (progn
          (require-closed-fields
           source '("kind" "schema-version" "source-artifact" "source-bytes"
                    "grammar" "parse-expected" "expected-parser-code")
           "migration-source")
          (unless (id-path= (record-field-named source "expected-parser-code")
                            "UnsupportedLegacyForm")
            (lci-fail "migration-refusal" "UnsupportedLegacyForm"
                      "migration-source"
                      :path '("fixture-field:expected-parser-code")))
          (lci-fail "migration-refusal" "UnsupportedLegacyForm"
                    "migration-source"
                    :path '("fixture-field:source-bytes")))
        (unless (and (boolean-datum-p parse-expected)
                     (boolean-datum-value parse-expected))
          (lci-fail "migration-refusal" "UnsupportedLegacyForm"
                    "migration-source"
                    :path '("fixture-field:parse-expected")))))
  (require-closed-fields source +legacy-source-fields+ "migration-source")
  (%validate-legacy-inert-record
   (record-field-named source "parsed-inert-value")))

(defun %migration-inert-value (source-or-value)
  (if (record-has-field-p source-or-value "parsed-inert-value")
      (parse-legacy-fixture source-or-value)
      (%validate-legacy-inert-record source-or-value)))

(defun migrate-v1-fixture (source-or-value)
  (let* ((value (%migration-inert-value source-or-value))
         (name (%legacy-fixture-name value)))
    (cond
      ((string= name "near-miss-package")
       (lci-fail "migration-refusal" "AmbiguousIdentifier" "migration-mapping"
                 :path '("fixture-field:parsed-inert-value"
                         "fixture-field:proposition"
                         "fixture-field:operator")))
      ((string= name "as-of-ambiguous")
       (lci-fail "migration-refusal" "UnclassifiedAsOf" "migration-mapping"
                 :path '("fixture-field:parsed-inert-value"
                         "fixture-field:as-of")))
      ((string= name "semantic-wrong-mapping")
       (lci-fail "migration-refusal" "SemanticIdentifierMappingMismatch"
                 "migration-mapping"
                 :path '("fixture-field:parsed-inert-value"
                         "fixture-field:mapping-candidate")))
      ((member name '("time-100" "printer-variation") :test #'string=)
       (registry-datum "migration-result.time-100"))
      ((string= name "time-124")
       (registry-datum "migration-result.time-124"))
      ((string= name "scope-tenant-b")
       (registry-datum "migration-result.scope-tenant-b"))
      ((string= name "corpus-r4")
       (registry-datum "migration-result.corpus-r4"))
      ((string= name "inert-predecessor-warrant")
       (registry-datum "migration-result.inert-predecessor"))
      ((string= name "attempt-live-restoration")
       (lci-fail "migration-refusal" "PrivilegedRestorationAttempt"
                 "privilege-boundary"
                 :path '("fixture-field:parsed-inert-value"
                         "fixture-field:attempt-live-restoration")))
      (t
       (lci-fail "migration-refusal" "UnsupportedLegacyForm"
                 "migration-source")))))

(defun %restore-live-warrant (source)
  (let* ((value (%migration-inert-value source))
         (attempt (record-field-named value "attempt-live-restoration"))
         (predecessors (record-field-named value "predecessor-warrants")))
    (if (and (boolean-datum-p attempt) (boolean-datum-value attempt))
        (lci-fail "privilege-refusal" "PrivilegedRestorationAttempt"
                  "privilege-boundary"
                  :path '("fixture-field:parsed-inert-value"
                          "fixture-field:attempt-live-restoration"))
        (when (and (sequence-datum-p predecessors)
                   (plusp (sequence-datum-length predecessors)))
          (lci-fail "privilege-refusal" "LegacyWarrantInert"
                    "privilege-boundary"
                    :path '("fixture-field:parsed-inert-value"
                            "fixture-field:predecessor-warrants"))))
    (lci-fail "privilege-refusal" "LegacyWarrantInert" "privilege-boundary")))
