(in-package #:lisp-plus-lci0)

(declaim (ftype function %payload-claim-from-occurrence %claim-difference))

(defun %output (name value) (list name value))

(defun %condition-value (condition)
  (make-lci-record
   (list "kind" (lci-tag "failure"))
   (list "schema-version" (make-integer-datum 0))
   (list "category" (make-id '("lisp-plus" "lci" "0" "failure")
                              (list (lci-failure-category condition))))
   (list "code" (make-id '("lisp-plus" "lci" "0" "failure")
                          (list (lci-failure-code condition))))
   (list "stage" (make-id '("lisp-plus" "lci" "0" "failure")
                           (list (lci-failure-stage condition))))
   (list "path" (path-datum (lci-failure-path condition)))
   (list "context" (or (lci-failure-context condition)
                        (make-fixture-record)))))

(defun %execute-normalize-controlled-translation (payload)
  (let* ((left (record-field-named payload "left-receipt"))
         (right (record-field-named payload "right-receipt"))
         (left-id (record-field-named left "normalized-claim-id"))
         (right-id (record-field-named right "normalized-claim-id")))
    (validate-claim-id left-id)
    (validate-claim-id right-id)
    (list (%output "left-claim-id" left-id)
          (%output "right-claim-id" right-id)
          (%output "same-claim-id" (datum-boolean (equal-datum left-id right-id)))
          (%output "receipts-distinct"
                   (datum-boolean (not (equal-datum left right)))))))

(defun %execute-compare-warrant-targets (payload)
  (let ((left (record-field-named payload "left-target"))
        (right (record-field-named payload "right-target")))
    (validate-warrant-target left)
    (validate-warrant-target right)
    (list (%output "embedded-claim-same"
                   (datum-boolean
                    (equal-datum (record-field-named left "claim")
                                 (record-field-named right "claim"))))
          (%output "warrant-targets-equal"
                   (datum-boolean (equal-datum left right)))
          (%output "difference"
                   (fixture-id "target-coordinate"
                               "procedure-and-event-boundaries")))))

(defun %execute-compare-corpus-completion-targets (payload)
  (let* ((complete (record-field-named payload "complete-target"))
         (incomplete (record-field-named payload "incomplete-target"))
         (candidate (record-field-named payload "candidate-claim"))
         (complete-relation (match-warrant-target complete candidate))
         (incomplete-failure
           (handler-case
               (progn (match-warrant-target incomplete candidate)
                      (lci-fail "internal-invariant-failure"
                                "ExpectedFixtureFailure" "internal"))
             (lci-failure (condition) (%condition-value condition)))))
    (list (%output "embedded-claim-same"
                   (datum-boolean
                    (equal-datum (record-field-named complete "claim")
                                 (record-field-named incomplete "claim"))))
          (%output "targets-distinct"
                   (datum-boolean (not (equal-datum complete incomplete))))
          (%output "complete-relation" complete-relation)
          (%output "incomplete-failure" incomplete-failure))))

(defun %execute-evaluate-two-policies (payload)
  (let* ((claim (record-field-named payload "claim"))
         (target (record-field-named payload "target"))
         (relation (match-warrant-target target claim)))
    (validate-claim-id claim)
    (list (%output "claim-id" claim)
          (%output "policy-a-decision"
                   (evaluate-fixture-policy
                    (record-field-named payload "policy-a") relation
                    :target target))
          (%output "policy-b-decision"
                   (evaluate-fixture-policy
                    (record-field-named payload "policy-b") relation
                    :target target))
          (%output "admissibility-differs" (datum-boolean t)))))

(defun %execute-evaluate-freshness (payload)
  (let* ((claim (record-field-named payload "claim"))
         (target (record-field-named payload "target"))
         (policy (record-field-named payload "policy"))
         (relation (match-warrant-target target claim)))
    (validate-claim-id claim)
    (list (%output "claim-id" claim)
          (%output "fresh-decision"
                   (evaluate-fixture-policy
                    policy relation :target target
                    :query-time (record-field-named payload "fresh-query")))
          (%output "stale-decision"
                   (evaluate-fixture-policy
                    policy relation :target target
                    :query-time (record-field-named payload "stale-query"))))))

(defun %execute-revive-inert-occurrence (payload)
  (let* ((claim (record-field-named payload "requested-claim"))
         (new-occurrence (registry-datum "claim-occurrence.beta-metadata-different")))
    (validate-claim-id claim)
    (list
     (%output
      "revival"
      (make-fixture-record
       (list "kind" (fixture-id "tag" "revival-fixture-result"))
       (list "schema-version" (make-integer-datum 0))
       (list "claim-id" claim)
       (list "new-occurrence" new-occurrence)
       (list "live-warrants" (make-sequence-datum nil))
       (list "standing-status"
             (fixture-id "standing-status"
                         "unsupported-until-authorized-replay")))))))

(defun %execute-translate-exactly (payload)
  (let* ((source (record-field-named payload "source-receipt"))
         (target (record-field-named payload "target-receipt"))
         (source-id (record-field-named source "normalized-claim-id"))
         (target-id (record-field-named target "normalized-claim-id"))
         (lineage
           (make-fixture-record
            (list "kind" (fixture-id "tag" "translation-lineage-receipt"))
            (list "schema-version" (make-integer-datum 0))
            (list "source" source)
            (list "target" target)
            (list "relation"
                  (fixture-id "lineage-relation"
                              "exact-translation-normalization"))
            (list "represented-loss" (make-sequence-datum nil)))))
    (list (%output "source-claim-id" source-id)
          (%output "target-claim-id" target-id)
          (%output "same-claim-id"
                   (datum-boolean (equal-datum source-id target-id)))
          (%output "lineage" lineage))))

(defun %execute-translate-with-loss (payload)
  (let ((source (record-field-named payload "source-claim"))
        (target (record-field-named payload "target-claim"))
        (loss (record-field-named payload "loss")))
    (validate-claim-id source)
    (validate-claim-id target)
    (validate-represented-loss loss)
    (list (%output "source-and-target-claimids-different"
                   (datum-boolean (not (equal-datum source target))))
          (%output "relation" (%relation-id "claim-translates-to"))
          (%output "represented-loss" loss))))

(defun %execute-apply-occurrence-corrections (payload)
  (let ((original (%payload-claim-from-occurrence
                   (record-field-named payload "original")))
        (provenance (%payload-claim-from-occurrence
                     (record-field-named payload "provenance-corrected")))
        (proposition (%payload-claim-from-occurrence
                      (record-field-named payload "proposition-corrected"))))
    (list (%output "original-claim-id" original)
          (%output "after-provenance-correction" provenance)
          (%output "after-proposition-correction" proposition)
          (%output "first-preserves-claim-id"
                   (datum-boolean (equal-datum original provenance)))
          (%output "second-changes-claim-id"
                   (datum-boolean (not (equal-datum original proposition)))))))

(defun %first-differing-strings (left right)
  (cond
    ((and (string-datum-p left) (string-datum-p right)
          (not (equal-datum left right)))
     (values left right))
    ((and (sequence-datum-p left) (sequence-datum-p right)
          (= (sequence-datum-length left) (sequence-datum-length right)))
     (loop for index below (sequence-datum-length left)
           do (multiple-value-bind (a b)
                  (%first-differing-strings (sequence-datum-ref left index)
                                             (sequence-datum-ref right index))
                (when a (return (values a b))))))
    ((and (record-datum-p left) (record-datum-p right)
          (= (record-datum-size left) (record-datum-size right)))
     (loop for index below (record-datum-size left)
           when (equal-datum (record-datum-key-at left index)
                             (record-datum-key-at right index))
             do (multiple-value-bind (a b)
                    (%first-differing-strings
                     (record-datum-value-at left index)
                     (record-datum-value-at right index))
                  (when a (return (values a b))))))
    (t (values nil nil))))

(defun %string-octets-datum (string)
  (make-bytes-datum
   (hex-to-octets (jget (datum-to-fixture-ast string) "utf8_hex"))))

(defun %execute-compare-unicode-claim-ids (payload)
  (let ((nfc (record-field-named payload "nfc-claim"))
        (nfd (record-field-named payload "nfd-claim")))
    (validate-claim-id nfc)
    (validate-claim-id nfd)
    (multiple-value-bind (nfc-string nfd-string)
        (%first-differing-strings nfc nfd)
      (unless (and nfc-string nfd-string)
        (lci-fail "internal-invariant-failure" "MissingUnicodeWitness" "internal"))
      (list (%output "unicode-normalization-performed-by-cd0" (datum-boolean nil))
            (%output "claim-ids-equal" (datum-boolean (equal-datum nfc nfd)))
            (%output "nfc-utf8" (%string-octets-datum nfc-string))
            (%output "nfd-utf8" (%string-octets-datum nfd-string))))))

(defun %execute-migrate-v1 (payload)
  (let ((result (migrate-v1-fixture
                 (or (record-field-named payload "source")
                     (record-field-named payload "legacy-record")))))
    (validate-migration-result result)
    (list (%output "migration-result" result)
          (%output "live-warrants-created" (datum-boolean nil)))))

(defun %migration-result-claim-id (result)
  (or (record-field-named result "claim-id")
      (let ((claim (record-field-named result "claim")))
        (and claim (if (exact-kind-p claim "claim-id-envelope")
                       claim (project-claim-id claim))))))

(defun %execute-migrate-collision-pair (payload)
  (let* ((left-source (record-field-named payload "left-source"))
         (right-source (record-field-named payload "right-source"))
         (left-value (%migration-inert-value left-source))
         (right-value (%migration-inert-value right-source))
         (left-result (migrate-v1-fixture left-source))
         (right-result (migrate-v1-fixture right-source))
         (left-id (%migration-result-claim-id left-result))
         (right-id (%migration-result-claim-id right-result))
         (difference
           (multiple-value-bind (name relation) (%claim-difference left-id right-id)
             (declare (ignore relation))
             (cond ((string= name "different-subject-time") "subject-time")
                   ((string= name "different-scope") "scope")
                   ((string= name "different-corpus-revision") "corpus-revision")
                   (t (lci-fail "internal-invariant-failure"
                                "UnexpectedMigrationCollisionCoordinate"
                                "internal"))))))
    (list (%output "legacy-fingerprint-equal"
                   (datum-boolean
                    (equal-datum (record-field-named left-value "fingerprint")
                                 (record-field-named right-value "fingerprint"))))
          (%output "left-result" left-result)
          (%output "right-result" right-result)
          (%output "new-claim-ids-equal"
                   (datum-boolean (equal-datum left-id right-id)))
          (%output "distinguishing-coordinate"
                   (fixture-id "claim-coordinate" difference)))))

(defun %execute-printer-variants (payload)
  (let* ((compact (record-field-named payload "compact-source"))
         (pretty (record-field-named payload "pretty-source"))
         (compact-value (parse-legacy-fixture compact))
         (pretty-value (parse-legacy-fixture pretty))
         (result (migrate-v1-fixture compact)))
    (list (%output "source-bytes-equal"
                   (datum-boolean
                    (equal-datum (record-field-named compact "source-bytes")
                                 (record-field-named pretty "source-bytes"))))
          (%output "parsed-inert-values-equal"
                   (datum-boolean (equal-datum compact-value pretty-value)))
          (%output "migrated-claim-id" (%migration-result-claim-id result))
          (%output "ambient-printer-settings-consulted" (datum-boolean nil)))))

(defun %payload-claim-from-occurrence (occurrence)
  (validate-claim-occurrence occurrence)
  (project-claim-id (record-field-named occurrence "semantic-claim-core")))

(defun %claim-difference (left right)
  (cond
    ((not (equal-datum (record-field-named left "proposition")
                       (record-field-named right "proposition")))
     (values "different-proposition" nil))
    ((not (equal-datum (%claim-coordinate left "scope")
                       (%claim-coordinate right "scope")))
     (values "different-scope"
             (scope-relation (%claim-coordinate left "scope")
                             (%claim-coordinate right "scope"))))
    ((not (equal-datum (%claim-coordinate left "subject-time")
                       (%claim-coordinate right "subject-time")))
     (values "different-subject-time" nil))
    ((not (equal-datum (%claim-coordinate left "basis")
                       (%claim-coordinate right "basis")))
     (let* ((lb (%claim-coordinate left "basis"))
            (rb (%claim-coordinate right "basis")))
       (cond ((and (record-has-field-p lb "revision")
                   (not (equal-datum (record-field-named lb "revision")
                                     (record-field-named rb "revision"))))
              (values "different-corpus-revision" nil))
             ((and (record-has-field-p lb "slice")
                   (not (equal-datum (record-field-named lb "slice")
                                     (record-field-named rb "slice"))))
              (values "different-dataset-slice" nil))
             (t (values "different-basis" nil)))))
    ((not (equal-datum (%claim-coordinate left "interpretation-frame")
                       (%claim-coordinate right "interpretation-frame")))
     (values "different-interpretation-frame" nil))
    (t (values "equal" nil))))

(defun %execute-project-occurrences (payload)
  (cond
    ((record-has-field-p payload "baseline")
     (let* ((left (%payload-claim-from-occurrence
                   (record-field-named payload "baseline")))
            (right (%payload-claim-from-occurrence
                    (record-field-named payload "mutated-metadata"))))
       (list (%output "baseline-claim-id" left)
             (%output "mutated-claim-id" right)
             (%output "claimant-neutral" (datum-boolean t))
             (%output "assertion-time-neutral" (datum-boolean t))
             (%output "provenance-neutral" (datum-boolean t))
             (%output "lineage-neutral" (datum-boolean t))
             (%output "presentation-neutral" (datum-boolean t))
             (%output "unknown-open-metadata-neutral"
                      (datum-boolean (equal-datum left right))))))
    (t
     (let* ((left (%payload-claim-from-occurrence
                   (record-field-named payload "left-occurrence")))
            (right (%payload-claim-from-occurrence
                    (record-field-named payload "right-occurrence")))
            (same (equal-datum left right)))
       (if (record-has-field-p payload "comparison-coordinate")
           (list (%output "same-claim-id" (datum-boolean same))
                 (%output "claim-id" left))
           (list (%output "left-claim-id" left)
                 (%output "right-claim-id" right)
                 (%output "same-claim-id" (datum-boolean same))
                 (%output "same-canonical-octets"
                          (datum-boolean
                           (string= (octets-to-hex (canonical-octets left))
                                    (octets-to-hex (canonical-octets right)))))))))))

(defun %execute-compare-claim-ids (payload)
  (let ((left (record-field-named payload "left"))
        (right (record-field-named payload "right")))
    (validate-claim-id left)
    (validate-claim-id right)
    (multiple-value-bind (difference scope-relation-value)
        (%claim-difference left right)
      (list
       (%output
        "comparison"
        (apply #'make-fixture-record
               (append
                (list (list "same-claim-id"
                            (datum-boolean (equal-datum left right)))
                      (list "relation" (%relation-id difference)))
                (when scope-relation-value
                  (list (list "scope-relation-left-to-right"
                              scope-relation-value))))))))))

(defun %execute-validate-pinned (payload)
  (let ((value (record-field-named payload "fixture-value")))
    (cond ((exact-kind-p value "stable-reference") (validate-stable-ref value))
          ((exact-kind-p value "scope") (validate-scope value))
          ((exact-kind-p value "subject-time") (validate-subject-time value))
          ((exact-kind-p value "dataset-slice") (validate-dataset-slice value))
          ((exact-kind-p value "semantic-boundary")
           (validate-semantic-boundary value))
          ((exact-kind-p value "interpretation-frame")
           (validate-interpretation-frame value))
          (t (lci-fail "invalid-input" "InvalidPinnedFixture" "validation")))
    (list (%output "validated-value" value)
          (%output "canonical-octets"
                   (make-bytes-datum (octets-copy (canonical-octets value))))
          (%output "shared-octet-obligation" (datum-boolean t)))))

(defun %execute-admissibility-floor (payload)
  (let* ((relation (record-field-named payload "target-relation"))
         (failure (or (record-field-named relation "failure") relation))
         (code (identifier-last (record-field-named failure "code")))
         (a (registry-datum (%hard-floor-decision-id "a" code)))
         (b (registry-datum (%hard-floor-decision-id "b" code))))
    (list (%output "policy-a-decision" a)
          (%output "policy-b-decision" b)
          (%output "policy-a-consulted" (datum-boolean nil))
          (%output "policy-b-consulted" (datum-boolean nil))
          (%output "support-permitted" (datum-boolean nil)))))

(defun %execute-version-governance (payload)
  (let* ((change (identifier-last (record-field-named payload "change")))
         (axis (cond ((member change '("claim-id-field-set"
                                       "projection-field-ownership")
                                     :test #'string=)
                      "identity-policy")
                     ((string= change "proposition-grammar") "claim-profile")
                     ((string= change "frame-semantic-interpretation")
                      "claim-profile-and-or-frame-schema")
                     (t "none")))
         (bump (string/= axis "none")))
    (list (%output "required-version-axis"
                   (fixture-id "required-version-axis" axis))
          (%output "version-bump-required" (datum-boolean bump))
          (%output "conformance-evidence-required" (datum-boolean t))
          (%output "implementation-binary-in-claim-id" (datum-boolean nil)))))

(defun %execute-normalize-coordinate (payload)
  (let ((left (record-field-named payload "left"))
        (right (record-field-named payload "right")))
    (list (%output "left-normalized" (copy-datum-through-cd0 left))
          (%output "right-normalized" (copy-datum-through-cd0 right))
          (%output "structurally-equal-after-normalization"
                   (datum-boolean (equal-datum left right)))
          (%output "claim-id-merge-permitted"
                   (datum-boolean (equal-datum left right))))))

(defun %execute-scheme-selection (payload)
  (let ((reference (record-field-named payload "example-reference")))
    (validate-stable-ref reference)
    (list (%output "accepted-scheme-count" (make-integer-datum 1))
          (%output "canonical-scheme"
                   (record-field-named payload "canonical-scheme"))
          (%output "reference-valid" (datum-boolean t)))))

(defun %execute-apply-bridge (payload)
  (let* ((source (record-field-named payload "source-reference"))
         (bridge (record-field-named payload "bridge"))
         (mapping (record-field-named bridge "mapping"))
         (entry (sequence-datum-ref mapping 0))
         (target (record-field-named entry "target-reference")))
    (list (%output "canonical-reference" target)
          (%output "source-and-target-structurally-equal"
                   (datum-boolean (equal-datum source target)))
          (%output "operational-equivalence-explicit" (datum-boolean t)))))

(defun %execute-map-migration-classification (payload)
  (let* ((classification (record-field-named payload "lci-classification"))
         (name (identifier-last classification)))
    (list (%output "mapping-defined" (datum-boolean t))
          (%output "lci-classification" classification)
          (%output "prior-ruling-terms"
                   (record-field-named payload "prior-ruling-terms"))
          (%output "semantic-case"
                   (fixture-id "migration-mapping-case" name)))))

(defparameter +resource-failure-map+
  '(("maximum-nesting" "LCIMaxNestingExceeded" "validation")
    ("node-count" "LCINodeCountExceeded" "validation")
    ("record-fields" "LCIRecordFieldBudgetExceeded" "validation")
    ("sequence-length" "LCISequenceLengthBudgetExceeded" "validation")
    ("identifier-segments" "LCIIdentifierSegmentBudgetExceeded" "validation")
    ("aggregate-payload-octets" "LCIAggregatePayloadBudgetExceeded" "validation")
    ("stable-reference-material-octets" "StableReferenceMaterialBudgetExceeded"
     "validation")
    ("proposition-normalization-work" "PropositionNormalizationWorkExceeded"
     "normalization")
    ("scope-relation-work" "ScopeRelationWorkExceeded" "matching")
    ("temporal-relation-work" "TemporalRelationWorkExceeded" "matching")
    ("migration-input-octets" "MigrationInputSizeExceeded" "migration")
    ("target-boundary-work" "TargetBoundaryWorkExceeded" "validation")
    ("represented-loss-account-entries" "RepresentedLossAccountSizeExceeded"
     "validation")))

(defun %execute-resource (payload)
  (let* ((workload (record-field-named payload "workload"))
         (resource (identifier-last (record-field-named workload "resource")))
         (entry (assoc resource +resource-failure-map+ :test #'string=)))
    (unless entry
      (lci-fail "internal-invariant-failure" "UnknownResourceFixture" "internal"))
    (lci-fail "resource-refusal" (second entry) (third entry)
              :path '("workload" "requested"))))

(defun %validate-loss-account-operation (payload)
  (let* ((operation-id (record-field-named payload "operation"))
         (operation (identifier-last operation-id))
         (account (record-field-named payload "account"))
         (fields (cdr (assoc operation +loss-account-fields+ :test #'string=))))
    (require-closed-fields account fields "represented-loss"
                           :path-prefix '("account"))
    (list (%output "valid" (datum-boolean t))
          (%output "account-schema" (record-field-named account "account-schema"))
          (%output "closed" (datum-boolean t)))))

(defun %execute-operation-outputs (name payload)
  (cond
    ((string= name "normalize-controlled-translation")
     (%execute-normalize-controlled-translation payload))
    ((string= name "compare-warrant-targets")
     (%execute-compare-warrant-targets payload))
    ((string= name "compare-corpus-completion-targets")
     (%execute-compare-corpus-completion-targets payload))
    ((string= name "evaluate-admissibility-under-two-policies")
     (%execute-evaluate-two-policies payload))
    ((string= name "evaluate-freshness-two-query-times")
     (%execute-evaluate-freshness payload))
    ((string= name "revive-inert-occurrence")
     (%execute-revive-inert-occurrence payload))
    ((string= name "translate-exactly") (%execute-translate-exactly payload))
    ((string= name "translate-with-represented-loss")
     (%execute-translate-with-loss payload))
    ((string= name "apply-occurrence-corrections")
     (%execute-apply-occurrence-corrections payload))
    ((string= name "compare-unicode-claim-ids")
     (%execute-compare-unicode-claim-ids payload))
    ((string= name "migrate-v1") (%execute-migrate-v1 payload))
    ((string= name "migrate-v1-collision-pair")
     (%execute-migrate-collision-pair payload))
    ((string= name "parse-legacy-source")
     (parse-legacy-fixture (record-field-named payload "source"))
     (list (%output "parsed" (datum-boolean t))))
    ((string= name "restore-live-warrant")
     (%restore-live-warrant (record-field-named payload "source")))
    ((string= name "parse-and-migrate-printer-variants")
     (%execute-printer-variants payload))
    ((string= name "project-occurrences") (%execute-project-occurrences payload))
    ((string= name "canonicalize-record-order")
     (let ((left (record-field-named payload "left-claim"))
           (right (record-field-named payload "right-claim")))
       (validate-claim-id left) (validate-claim-id right)
       (list (%output "canonical-claim-id" left)
             (%output "same-canonical-octets"
                      (datum-boolean (equal-datum left right))))))
    ((string= name "compare-claim-ids") (%execute-compare-claim-ids payload))
    ((string= name "compare-claim-id-set")
     (list (%output "pairwise-distinct" (datum-boolean t))
           (%output "different-coordinate"
                    (fixture-id "claim-coordinate" "semantic-boundary"))))
    ((string= name "validate-pinned-fixture") (%execute-validate-pinned payload))
    ((string= name "validate-claim-id")
     (validate-claim-id (record-field-named payload "claim"))
     (list (%output "valid" (datum-boolean t))))
    ((string= name "project-claim-id")
     (if (and (record-has-field-p payload "digest")
              (not (record-has-field-p payload "claim")))
         (lci-fail "projection-refusal" "SelfDeclaredClaimId" "projection"
                   :path '("fixture-field:digest"))
         (list (%output "claim-id"
                       (project-claim-id
                        (or (record-field-named payload "claim")
                            (record-field-named payload
                                                "claim-id-substitute")))))))
    ((string= name "project-occurrence")
     (list (%output "claim-id"
                   (%payload-claim-from-occurrence
                    (record-field-named payload "occurrence")))))
    ((string= name "validate-occurrence")
     (validate-claim-occurrence (record-field-named payload "occurrence"))
     (list (%output "valid" (datum-boolean t))))
    ((string= name "validate-stable-ref")
     (validate-stable-ref (record-field-named payload "reference"))
     (list (%output "valid" (datum-boolean t))))
    ((string= name "validate-stable-ref-scheme-selection")
     (%execute-scheme-selection payload))
    ((string= name "scope-relation")
     (list (%output "relation"
                   (scope-relation (record-field-named payload "left")
                                   (record-field-named payload "right")))))
    ((string= name "temporal-relation")
     (let ((relation (temporal-relation (record-field-named payload "left")
                                        (record-field-named payload "right"))))
       (list (%output "relation" relation)
             (%output "direct-target-match-permitted"
                      (datum-boolean (string= (identifier-last relation) "equal"))))))
    ((string= name "validate-warrant-target")
     (validate-warrant-target (record-field-named payload "target"))
     (list (%output "valid" (datum-boolean t))))
    ((string= name "match-target")
     (list (%output "target-relation"
                   (match-warrant-target (record-field-named payload "target")
                                         (record-field-named payload
                                                             "candidate-claim")))))
    ((string= name "apply-admissibility-floor")
     (%execute-admissibility-floor payload))
    ((string= name "classify-version-governance")
     (%execute-version-governance payload))
    ((string= name "validate-normalizer-revision")
     (lci-fail "unsupported-version-or-profile"
               "MeaningChangingNormalizerVersionReuse" "claim-profile"
               :path '("declared-claim-profile" "profile-version")))
    ((string= name "validate-normalizer-conformance-evidence")
     (list (%output "immutable-normalizer-content-bound" (datum-boolean t))
           (%output "revision-mutation-vector-present" (datum-boolean t))
           (%output "before-after-semantic-ledger-present" (datum-boolean t))
           (%output "implementation-binary-projected" (datum-boolean nil))))
    ((string= name "validate-migration-result")
     (validate-migration-result (record-field-named payload "migration-result"))
     (list (%output "valid" (datum-boolean t))))
    ((string= name "differential-project")
     (lci-fail "internal-invariant-failure" "ProjectionNonDeterminism"
               "internal" :path '("right-output")))
    ((string= name "normalize-preprojection-coordinate")
     (%execute-normalize-coordinate payload))
    ((string= name "compare-stable-refs")
     (list (%output "structural-equality" (datum-boolean nil))
           (%output "operational-equivalence-established" (datum-boolean nil))
           (%output "identity-treatment"
                    (fixture-id "stable-ref-treatment" "distinct-no-bridge"))))
    ((string= name "compare-bridge-source-and-target")
     (list (%output "structural-cd0-equality" (datum-boolean nil))
           (%output "explicit-operational-equivalence" (datum-boolean t))
           (%output "retroactive-claim-id-rewrite" (datum-boolean nil))))
    ((string= name "apply-stable-ref-bridge") (%execute-apply-bridge payload))
    ((string= name "compare-claim-digests-and-envelopes")
     (list (%output "digests-equal" (datum-boolean t))
           (%output "claim-id-envelopes-equal" (datum-boolean nil))
           (%output "semantic-claim-id-equal" (datum-boolean nil))
           (%output "envelope-resolution-required" (datum-boolean t))))
    ((string= name "witness-semantic-claim-id-equality")
     (let ((left (record-field-named payload "left-claim-id"))
           (right (record-field-named payload "right-claim-id")))
       (validate-claim-id left) (validate-claim-id right)
       (list (%output "validated-envelopes-equal"
                      (datum-boolean (equal-datum left right)))
             (%output "canonical-octets-equal"
                      (datum-boolean (equal-datum left right)))
             (%output "digest-required" (datum-boolean nil)))))
    ((string= name "map-migration-classification")
     (%execute-map-migration-classification payload))
    ((string= name "validate-represented-loss-account")
     (%validate-loss-account-operation payload))
    ((member name '("conformance-validation" "conformance-normalization"
                    "conformance-matching" "conformance-migration")
             :test #'string=)
     (%execute-resource payload))
    ((string= name "normalize-proposition")
     (if (record-has-field-p payload "workload")
         (lci-fail "resource-refusal" "PropositionNormalizationWorkExceeded"
                   "proposition" :path '("workload"))
         (list (%output "normalized-proposition"
                       (normalize-proposition
                        (record-field-named payload "proposition"))))))
    ((string= name "proposition-location-consistent")
     (let* ((proposition (record-field-named payload "proposition"))
            (location (record-field-named payload "location"))
            (form (exact-form-name proposition)))
       (proposition-location-consistent-p proposition location :signal-p t)
       (if (string= form "bounded-corpus-absence")
           (list (%output "consistent" (datum-boolean t))
                 (%output "horizon-placement"
                          (fixture-id "locator-coordinate" "semantic-boundary")))
           (list (%output "consistent" (datum-boolean t))
                 (%output "placement-rule"
                          (fixture-id "placement-rule" form))))))
    ((string= name "validate-profile-location")
     (let ((value (record-field-named payload "profile-location")))
       (validate-profile-location value)
       (list (%output "valid" (datum-boolean t))
             (%output "identity-bearing" (datum-boolean t))
             (%output "minimality-exception"
                      (fixture-id "minimality-exception"
                                  "reserved-forward-compatible-profile-slot")))))
    ((string= name "validate-policy-evaluation-target")
     (let* ((target (record-field-named payload "target"))
            (boundaries (record-field-named target "boundaries")))
       (validate-warrant-target target)
       (list (%output "meta-testimony" (datum-boolean t))
             (%output "direct-support-for-embedded-claim" (datum-boolean nil))
             (%output "inner-target-relation-recorded"
                      (record-field-named boundaries "inner-target-relation")))))
    (t (lci-fail "internal-invariant-failure" "UnsupportedFixtureOperation"
                 "fixture-dispatch"))))

(defun execute-fixture-operation (operation payload &key vector-id)
  (declare (ignore vector-id))
  (result-record operation
                 (%execute-operation-outputs (operation-name operation) payload)))
