(in-package #:lisp-plus-lci0)

(defparameter +frozen-lci-failure-codes+
  '("AdmissibilityUndetermined" "AmbiguousIdentifier" "BasisMismatch"
    "ClaimIdCacheMismatch" "ClaimProfileMismatch" "ClaimTargetMismatch"
    "CorpusCompletionInsufficient" "CorpusRevisionIdentityInsufficient"
    "IdentityBearingLoss" "IdentityPolicyMismatch"
    "InterpretationFrameMismatch" "InvalidBasis" "InvalidClaimLocation"
    "InvalidClaimRecord" "InvalidInterpretationFrame" "InvalidProposition"
    "InvalidScope" "InvalidStableReference" "InvalidSubjectTime"
    "InvalidWarrantTarget" "LCIAggregatePayloadBudgetExceeded"
    "LCIIdentifierSegmentBudgetExceeded" "LCIMaxNestingExceeded"
    "LCINodeCountExceeded" "LCIRecordFieldBudgetExceeded"
    "LCISequenceLengthBudgetExceeded" "LegacyFingerprintNotClaimId"
    "LegacyWarrantInert" "LineageUnverified"
    "MeaningChangingNormalizerVersionReuse" "MigrationInputSizeExceeded"
    "MissingRequiredField" "MutableReference"
    "NormalizerContentIdentityMismatch" "NormalizerRevisionEvidenceMissing"
    "PremiseMismatch" "PrivilegedRestorationAttempt"
    "ProcedureIdentityInsufficient" "ProcedureMismatch"
    "ProfileLocationMismatch" "ProjectionNonDeterminism"
    "PropositionLocationInconsistent" "PropositionMismatch"
    "PropositionNormalizationWorkExceeded" "RecursiveUnsupportedNestedVersion"
    "ReplayAuthorizationRequired" "RepresentedLossAccountSizeExceeded"
    "RepresentedLossRequired" "ScopeDisjoint" "ScopeIncompatible"
    "ScopeNarrowingCoverageInsufficient" "ScopeNarrowingNotDeclared"
    "ScopeOverlapInsufficient" "ScopeRelationUnknown" "ScopeRelationWorkExceeded"
    "ScopeWideningForbidden" "SelfDeclaredClaimId"
    "SemanticIdentifierMappingMismatch" "StableReferenceMaterialBudgetExceeded"
    "SubjectTimeMismatch" "TargetBoundaryMismatch" "TargetBoundaryMissing"
    "TargetBoundaryUnknown" "TargetBoundaryWorkExceeded"
    "TargetSchemaKindMismatch" "TemporalCoverageInsufficient"
    "TemporalRelationWorkExceeded" "TranslationBoundaryMismatch"
    "UnclassifiedAsOf" "UnexpectedUnit" "UnknownField"
    "UnnormalizedProposition" "UnresolvedAlias" "UnresolvedRelativeTime"
    "UnsupportedClaimProfile" "UnsupportedIdentityPolicy"
    "UnsupportedInterpretationFrame" "UnsupportedLCIVersion"
    "UnsupportedLegacyForm" "UnsupportedReferenceScheme"
    "UnsupportedRepresentedLossAccountSchema" "UnsupportedScopeCalculus"
    "UnsupportedTargetKind" "UnsupportedTemporalModel"))

(defun frozen-lci-failure-code-p (code)
  (and (stringp code)
       (member code +frozen-lci-failure-codes+ :test #'string=)))

(define-condition lci-internal-integrity-failure (error)
  ((jurisdiction :initarg :jurisdiction
                 :reader lci-internal-integrity-failure-jurisdiction)
   (code :initarg :code :reader lci-internal-integrity-failure-code)
   (stage :initarg :stage :reader lci-internal-integrity-failure-stage)
   (path :initarg :path :initform nil
         :reader lci-internal-integrity-failure-path)
   (context :initarg :context :initform nil
            :reader lci-internal-integrity-failure-context))
  (:report
   (lambda (condition stream)
     (format stream "LCI/0 implementation integrity failure ~A/~A at ~A"
             (lci-internal-integrity-failure-jurisdiction condition)
             (lci-internal-integrity-failure-code condition)
             (lci-internal-integrity-failure-stage condition)))))

(defun internal-integrity-fail (jurisdiction code stage &key path context)
  "Signal a host/fixture/harness integrity fault outside LCIFailure/0.
CODE is deliberately not projected into the frozen LCI failure namespace."
  (error 'lci-internal-integrity-failure
         :jurisdiction jurisdiction :code code :stage stage
         :path (copy-list path) :context context))

(define-condition fixture-operation-authorial-gap (error)
  ((operation :initarg :operation
              :reader fixture-operation-authorial-gap-operation)
   (path :initarg :path :reader fixture-operation-authorial-gap-path))
  (:report
   (lambda (condition stream)
     (format stream "LCI/0 fixture operation ~A has no frozen result at ~S"
             (fixture-operation-authorial-gap-operation condition)
             (fixture-operation-authorial-gap-path condition)))))

(defun %fixture-operation-authorial-gap (operation path)
  ;; Deliberately not LCIFailure/0: no authority exists for manufacturing an
  ;; LCI result tuple for an operation/inverse case outside the frozen corpus.
  (error 'fixture-operation-authorial-gap
         :operation operation :path path))

(define-condition lci-failure (error)
  ((category :initarg :category :reader lci-failure-category)
   (code :initarg :code :reader lci-failure-code)
   (stage :initarg :stage :reader lci-failure-stage)
   (path :initarg :path :initform nil :reader lci-failure-path)
   (context :initarg :context :initform nil :reader lci-failure-context))
  (:report (lambda (condition stream)
             (format stream "LCI/0 ~A/~A at ~A~@[ path ~{~A~^/~}~]"
                     (lci-failure-category condition)
                     (lci-failure-code condition)
                     (lci-failure-stage condition)
                     (lci-failure-path condition)))))

(defun lci-fail (category code stage &key path context)
  ;; This boundary is the last line of defense against implementation-local
  ;; vocabulary escaping as LCIFailure/0.  Fixture adapter, package verifier,
  ;; harness, and authorial-gap diagnostics use distinct host conditions.
  (unless (frozen-lci-failure-code-p code)
    (internal-integrity-fail "failure-vocabulary" "UnfrozenLCIFailureCode"
                             "lci-fail" :path path
                             :context (list category code stage context)))
  (error 'lci-failure :category category :code code :stage stage
                      :path (copy-list path) :context context))

(defclass lci-value ()
  ((kind :initarg :kind :reader lci-value-kind)
   (datum :initarg :datum :reader %lci-value-datum)
   (octets :initarg :octets :reader %lci-value-octets)))

(defun lci-value-p (value) (typep value 'lci-value))

(defun lci-value-datum (value)
  (unless (lci-value-p value)
    (internal-integrity-fail "host-boundary" "InvalidLCIValue" "host-import"))
  (%lci-value-datum value))

(defun lci-value-octets (value)
  (octets-copy (%lci-value-octets value)))

(defun make-lci-value (kind datum)
  (unless (datum-p datum)
    (internal-integrity-fail "host-boundary" "InvalidLCIValue" "host-import"))
  (make-instance 'lci-value :kind kind :datum datum
                 :octets (canonical-octets datum)))

;;; Identifier and closed-record helpers.  Identifiers are constructed from
;;; exact scalar strings; CD/0 performs UTF-8 encoding but no normalization.

(defun make-id (namespace path)
  (make-identifier-datum namespace path))

(defun lci-id (&rest path)
  (make-id '("lisp-plus" "lci" "0") path))

(defun lci-tag (name)
  (make-id '("lisp-plus" "lci" "0" "tag") (list name)))

(defun fixture-id (&rest path)
  (make-id '("lisp-plus" "lci" "0" "fixture") path))

(defun fixture-field-id (name)
  (make-id '("lisp-plus" "lci" "0" "fixture" "field") (list name)))

(defparameter +lci-field-namespace+ '("lisp-plus" "lci" "0"))
(defparameter +fixture-field-namespace+
  '("lisp-plus" "lci" "0" "fixture" "field"))
(defparameter +proposition-field-namespace+
  '("lisp-plus" "lci" "0" "fixture" "mneme-proposition" "field"))
(defparameter +proposition-argument-namespace+
  '("lisp-plus" "lci" "0" "fixture" "mneme-proposition" "argument"))

(defun identifier-path-strings (identifier)
  (unless (identifier-datum-p identifier) (return-from identifier-path-strings nil))
  (loop for index below (identifier-datum-path-count identifier)
        collect (identifier-datum-path-segment identifier index)))

(defun identifier-namespace-strings (identifier)
  (unless (identifier-datum-p identifier)
    (return-from identifier-namespace-strings nil))
  (loop for index below (identifier-datum-namespace-count identifier)
        collect (identifier-datum-namespace-segment identifier index)))

(defun identifier-last (identifier)
  (car (last (identifier-path-strings identifier))))

(defun id-path= (identifier &rest path)
  (and (identifier-datum-p identifier)
       (equal (identifier-path-strings identifier) path)))

(defun record-field-named (record name &optional default)
  (unless (record-datum-p record) (return-from record-field-named default))
  (loop for index below (record-datum-size record)
        for key = (record-datum-key-at record index)
        when (string= (or (identifier-last key) "") name)
          do (return (record-datum-value-at record index))
        finally (return default)))

(defun record-has-field-p (record name)
  (let ((marker (list :missing)))
    (not (eq marker (record-field-named record name marker)))))

(defun record-field-names (record)
  (unless (record-datum-p record) (return-from record-field-names nil))
  (loop for index below (record-datum-size record)
        collect (identifier-last (record-datum-key-at record index))))

(defun make-named-record (namespace fields)
  (make-record-datum
   (loop for (name value) in fields
         collect (make-record-entry
                  (make-id namespace (list name)) value))))

(defun make-lci-record (&rest fields)
  (make-named-record '("lisp-plus" "lci" "0") fields))

(defun make-fixture-record (&rest fields)
  (make-named-record '("lisp-plus" "lci" "0" "fixture" "field") fields))

(defun make-string-sequence (strings &optional (namespace '("lisp-plus" "lci" "0" "fixture")))
  (make-sequence-datum
   (mapcar (lambda (name) (make-id namespace (list name))) strings)))

(defun datum-boolean (value) (make-boolean-datum (not (null value))))

;; Frozen LCI-layer resource registry.  This is independent of CD/0's decoder
;; and encoder budgets.  The order is normative (Fixture Package section 10).
(defparameter +lci-resource-definitions+
  '(("maximum-nesting" 64
     ("validation" "normalization" "projection" "matching" "migration")
     "LCIMaxNestingExceeded" "nested-singleton-record")
    ("node-count" 4096
     ("validation" "normalization" "projection" "matching" "migration")
     "LCINodeCountExceeded" "flat-sequence-of-unit-nodes")
    ("record-fields" 64 ("validation" "projection" "matching" "migration")
     "LCIRecordFieldBudgetExceeded" "record-of-indexed-fixture-keys")
    ("sequence-length" 256
     ("validation" "normalization" "projection" "matching" "migration")
     "LCISequenceLengthBudgetExceeded" "sequence-of-unit-values")
    ("identifier-segments" 32
     ("validation" "normalization" "projection" "matching" "migration")
     "LCIIdentifierSegmentBudgetExceeded" "identifier-with-indexed-segments")
    ("aggregate-payload-octets" 131072
     ("validation" "normalization" "projection" "matching" "migration")
     "LCIAggregatePayloadBudgetExceeded" "byte-string-of-0x61")
    ("stable-reference-material-octets" 4096
     ("validation" "projection" "matching" "migration")
     "StableReferenceMaterialBudgetExceeded"
     "stable-ref-material-byte-string-of-0x61")
    ("proposition-normalization-work" 10000 ("normalization" "projection")
     "PropositionNormalizationWorkExceeded" "repeat-normalizer-node")
    ("scope-relation-work" 4096 ("matching")
     "ScopeRelationWorkExceeded" "repeat-scope-relation-node")
    ("temporal-relation-work" 4096
     ("matching" "admissibility" "migration")
     "TemporalRelationWorkExceeded" "repeat-temporal-relation-node")
    ("migration-input-octets" 32768 ("migration")
     "MigrationInputSizeExceeded" "legacy-source-byte-string-of-0x61")
    ("target-boundary-work" 8192 ("validation" "matching")
     "TargetBoundaryWorkExceeded" "repeat-target-boundary-node")
    ("represented-loss-account-entries" 64
     ("validation" "migration" "admissibility")
     "RepresentedLossAccountSizeExceeded" "indexed-account-entry-sequence")))

(defvar *lci-resource-check-active* nil)
(defvar *lci-resource-phase* nil)

(defun %datum-valuebytes-length (datum)
  ;; CD/0 documents have the four-byte magic and one-byte version prefix.
  (- (octets-length (canonical-octets datum)) 5))

(defun %subtree-node-count (datum)
  (cond
    ((record-datum-p datum)
     (+ 1 (loop for index below (record-datum-size datum)
                sum (+ (%subtree-node-count (record-datum-key-at datum index))
                       (%subtree-node-count
                        (record-datum-value-at datum index))))))
    ((sequence-datum-p datum)
     (+ 1 (loop for index below (sequence-datum-length datum)
                sum (%subtree-node-count (sequence-datum-ref datum index)))))
    (t 1)))

(defun %resource-exact-id-p (value namespace path)
  (and (identifier-datum-p value)
       (equal (identifier-namespace-strings value) namespace)
       (equal (identifier-path-strings value) path)))

(defun %resource-exact-record-shape-p (record namespace fields)
  (and (record-datum-p record)
       (= (record-datum-size record) (length fields))
       (loop for index below (record-datum-size record)
             for key = (record-datum-key-at record index)
             always (and (identifier-datum-p key)
                         (equal (identifier-namespace-strings key) namespace)
                         (= (length (identifier-path-strings key)) 1)
                         (member (identifier-last key) fields :test #'string=)))))

(defun %lci-structural-metrics (root)
  (let ((maximum-nesting 0) (node-count 0) (record-fields 0)
        (sequence-length 0) (identifier-segments 0)
        (stable-material-octets 0) (target-boundary-work 0)
        (loss-account-entries 0))
    (labels ((walk (datum depth)
               (incf node-count)
               (setf maximum-nesting (max maximum-nesting depth))
               (cond
                 ((identifier-datum-p datum)
                  (setf identifier-segments
                        (max identifier-segments
                             (+ (identifier-datum-namespace-count datum)
                                (identifier-datum-path-count datum)))))
                 ((sequence-datum-p datum)
                  (setf sequence-length
                        (max sequence-length (sequence-datum-length datum)))
                  (loop for index below (sequence-datum-length datum)
                        do (walk (sequence-datum-ref datum index) (1+ depth))))
                 ((record-datum-p datum)
                  (setf record-fields (max record-fields
                                           (record-datum-size datum)))
                  (let ((material (record-field-named datum "material")))
                    (when (and
                           (%resource-exact-id-p
                            (record-field-named datum "kind")
                            '("lisp-plus" "lci" "0" "tag")
                            '("stable-reference"))
                           (%resource-exact-record-shape-p
                            datum '("lisp-plus" "lci" "0")
                            '("kind" "domain" "scheme" "material"))
                           (%resource-exact-record-shape-p
                            material
                            '("lisp-plus" "lci" "0" "fixture" "field")
                            '("kind" "schema-version" "object-id"
                              "object-version"))
                           (%resource-exact-id-p
                            (record-field-named material "kind")
                            '("lisp-plus" "lci" "0" "fixture")
                            '("tag" "fixture-stable-material"))
                           (let ((schema-version
                                   (record-field-named material
                                                       "schema-version")))
                             (and (integer-datum-p schema-version)
                                  (zerop (integer-datum-value
                                          schema-version)))))
                      (setf stable-material-octets
                            (max stable-material-octets
                                 (%datum-valuebytes-length material)))))
                  (let ((boundaries (record-field-named datum "boundaries")))
                    (when (and
                           (%resource-exact-id-p
                            (record-field-named datum "kind")
                            '("lisp-plus" "lci" "0" "tag")
                            '("warrant-target"))
                           (%resource-exact-record-shape-p
                            datum '("lisp-plus" "lci" "0")
                            '("kind" "lci-version" "target-kind"
                              "target-schema" "claim" "boundaries"))
                           (record-datum-p boundaries))
                      (incf target-boundary-work (record-datum-size boundaries))
                      (loop for index below (record-datum-size boundaries)
                            do (incf target-boundary-work
                                     (%subtree-node-count
                                      (record-datum-value-at boundaries index))))))
                  (when (and
                             (%resource-exact-id-p
                              (record-field-named datum "kind")
                              '("lisp-plus" "lci" "0" "tag")
                              '("represented-loss"))
                             (%resource-exact-record-shape-p
                              datum '("lisp-plus" "lci" "0")
                              '("kind" "schema-version" "operation" "source"
                                "lost-dimensions" "consequence" "account"))
                             (let ((schema-version
                                     (record-field-named datum
                                                         "schema-version")))
                               (and (integer-datum-p schema-version)
                                    (zerop (integer-datum-value
                                            schema-version))))
                             (record-datum-p
                              (record-field-named datum "account")))
                    (let ((account (record-field-named datum "account")))
                      (loop for index below (record-datum-size account)
                            for value = (record-datum-value-at account index)
                            when (sequence-datum-p value)
                              do (incf loss-account-entries
                                       (sequence-datum-length value)))))
                  (loop for index below (record-datum-size datum)
                        do (walk (record-datum-key-at datum index) (1+ depth))
                           (walk (record-datum-value-at datum index)
                                 (1+ depth)))))))
      (walk root 1))
    (list (cons "maximum-nesting" maximum-nesting)
          (cons "node-count" node-count)
          (cons "record-fields" record-fields)
          (cons "sequence-length" sequence-length)
          (cons "identifier-segments" identifier-segments)
          (cons "aggregate-payload-octets" (%datum-valuebytes-length root))
          (cons "stable-reference-material-octets" stable-material-octets)
          (cons "target-boundary-work" target-boundary-work)
          (cons "represented-loss-account-entries" loss-account-entries))))

(defun enforce-lci-structural-budgets (root phase)
  (unless (datum-p root)
    (internal-integrity-fail "host-boundary" "InvalidLCIValue" phase))
  (let ((metrics (%lci-structural-metrics root)))
    (dolist (definition +lci-resource-definitions+)
      (destructuring-bind (resource limit phases code generator) definition
        (declare (ignore generator))
        (when (member phase phases :test #'string=)
          (let ((measured (cdr (assoc resource metrics :test #'string=))))
            (when (and measured (> measured limit))
              (lci-fail "resource-refusal" code phase
                        :path (cond
                                ((string= resource
                                          "stable-reference-material-octets")
                                 '("material"))
                                ((string= resource "target-boundary-work")
                                 '("boundaries"))
                                ((string= resource
                                          "represented-loss-account-entries")
                                 '("account"))
                                (t (list resource))))))))))
  t)

(defmacro with-lci-structural-budgets ((root phase) &body body)
  `(if *lci-resource-check-active*
       (progn ,@body)
       (let ((*lci-resource-check-active* t)
             (*lci-resource-phase* ,phase))
         (enforce-lci-structural-budgets ,root ,phase)
         ,@body)))

(defun datum-integer-value* (datum)
  (and (integer-datum-p datum) (integer-datum-value datum)))

(defun datum-string-value* (datum)
  (and (string-datum-p datum) (string-datum-value datum)))

(defun %record-shape-failure (stage path)
  (cond
    ((string= stage "stable-reference")
     (lci-fail "reference-refusal" "InvalidStableReference" stage :path path))
    ((member stage '("claim-shape" "identity-policy" "claim-profile")
             :test #'string=)
     (lci-fail "invalid-input" "InvalidClaimRecord" stage :path path))
    ((string= stage "proposition")
     (lci-fail "invalid-input" "InvalidProposition" stage :path path))
    ((string= stage "scope")
     (lci-fail "invalid-input" "InvalidScope" stage :path path))
    ((string= stage "subject-time")
     (lci-fail "invalid-input" "InvalidSubjectTime" stage :path path))
    ((string= stage "basis")
     (lci-fail "invalid-input" "InvalidBasis" stage :path path))
    ((string= stage "interpretation-frame")
     (lci-fail "invalid-input" "InvalidInterpretationFrame" stage :path path))
    ((member stage '("location" "location-shape" "profile-location")
             :test #'string=)
     (lci-fail "invalid-input" "InvalidClaimLocation" stage :path path))
    ((member stage '("target-shape" "target-schema" "target-boundaries"
                     "target-relation")
             :test #'string=)
     (lci-fail "invalid-input" "InvalidWarrantTarget" stage :path path))
    ((string= stage "migration-source")
     (lci-fail "migration-refusal" "UnsupportedLegacyForm" stage :path path))
    (t
     (%fixture-operation-authorial-gap stage path))))

(defun require-record (datum code stage path)
  (unless (record-datum-p datum)
    (cond
      ((string= code "UnsupportedLegacyForm")
       (lci-fail "migration-refusal" code stage :path path))
      ((string= code "InvalidStableReference")
       (lci-fail "reference-refusal" code stage :path path))
      ((frozen-lci-failure-code-p code)
       (lci-fail "invalid-input" code stage :path path))
      (t (%record-shape-failure stage path))))
  datum)

(defun require-closed-fields (datum expected stage &key
                                      (missing-code "MissingRequiredField")
                                      (unknown-code "UnknownField")
                                      path-prefix context key-namespace)
  (declare (ignore unknown-code))
  (unless (record-datum-p datum)
    (%record-shape-failure stage path-prefix))
  ;; Required-field precedence follows the declared field order.
  (dolist (field expected)
    (unless (if key-namespace
                (loop for index below (record-datum-size datum)
                      for key = (record-datum-key-at datum index)
                      thereis (and (identifier-datum-p key)
                                   (equal (identifier-namespace-strings key)
                                          key-namespace)
                                   (equal (identifier-path-strings key)
                                          (list field))))
                (record-has-field-p datum field))
      (lci-fail "invalid-input" missing-code stage
                :path (append path-prefix (list field)) :context context)))
  datum)

(defun reject-unknown-fields (datum expected stage &key
                                      (unknown-code "UnknownField")
                                      path-prefix context key-namespace)
  "Run the E6 unknown-key phase after declared values have been recursively
validated.  Record iteration is already canonical CD/0 key order."
  (unless (record-datum-p datum)
    (%record-shape-failure stage path-prefix))
  (loop for index below (record-datum-size datum)
        for key = (record-datum-key-at datum index)
        for key-path = (and (identifier-datum-p key)
                            (identifier-path-strings key))
        for valid = (and (identifier-datum-p key)
                         (or (null key-namespace)
                             (equal (identifier-namespace-strings key)
                                    key-namespace))
                         (= (length key-path) 1)
                         (member (first key-path) expected :test #'string=))
        unless valid
          do (lci-fail "invalid-input" unknown-code stage
                       :path (append
                              path-prefix
                              (list (if (and key-path (plusp (length key-path)))
                                        (car (last key-path))
                                        "invalid-field-key")))
                       :context context))
  datum)

(defun exact-zero-p (datum)
  (and (integer-datum-p datum) (zerop (integer-datum-value datum))))

(defun exact-kind-p (datum name)
  (let ((kind (record-field-named datum "kind")))
    (and (identifier-datum-p kind)
         (string= (or (identifier-last kind) "") name))))

(defun exact-form-name (datum)
  (let ((form (record-field-named datum "form")))
    (and (identifier-datum-p form) (identifier-last form))))

(defun copy-datum-through-cd0 (datum)
  (decode-exact (octets-copy (canonical-octets datum))))

(defun operation-name (operation)
  (unless (identifier-datum-p operation)
    (%fixture-operation-authorial-gap "fixture-dispatch" '("operation")))
  (identifier-last operation))

(defun result-record (operation outputs)
  (make-fixture-record
   (list "kind" (fixture-id "tag" "fixture-operation-result"))
   (list "schema-version" (make-integer-datum 0))
   (list "status" (fixture-id "result-status" "success"))
   (list "operation" operation)
   (list "outputs" (apply #'make-fixture-record outputs))))

(defparameter +standard-path-fields+
  '("kind" "schema-version" "lci-version" "identity-policy" "claim-profile"
    "proposition" "location" "scope" "subject-time" "basis"
    "interpretation-frame" "profile-location" "policy-id" "policy-version"
    "profile-id" "profile-version" "calculus" "expression" "mode"
    "parameters" "corpus" "revision" "slice" "semantic-boundary"
    "frame-schema" "components" "coordinates" "temporal-model"
    "domain" "scheme" "material" "issuer"
    "target-kind" "target-schema" "claim" "boundaries" "operation" "source"
    "lost-dimensions" "consequence" "account" "represented-loss" "digest")
  "LCI/0 field names whose structural-path identifiers use the base namespace.")

(defparameter +proposition-path-arguments+
  '("artifact" "content" "scope-locator" "subject-time-locator" "basis-locator"
    "frame-locator" "measure" "expected" "unit" "population-domain" "query"
    "corpus-locator" "dataset-slice-locator" "semantic-boundary-locator"
    "procedure" "input" "left" "right" "predicate" "quantified-domain"
    "embedded-proposition" "probability" "uncertainty-model" "producer"
    "invocation" "value" "source-text" "source-language" "target-language"
    "candidate-readings" "ambiguity-mode"))

(defun %path-part-id (part previous)
  (cond
    ((and (>= (length part) 14)
          (string= part "fixture-field:" :end1 14 :end2 14))
     (fixture-field-id (subseq part 14)))
    ((string= previous "arguments")
     (make-id '("lisp-plus" "lci" "0" "fixture" "mneme-proposition"
                "argument") (list part)))
    ((and previous
          (member previous +proposition-path-arguments+ :test #'string=)
          (member part '("kind" "schema-version" "placement" "value"
                         "coordinate" "locator-role") :test #'string=))
     (make-id '("lisp-plus" "lci" "0" "fixture" "mneme-proposition" "field")
              (list part)))
    ((member part +standard-path-fields+ :test #'string=) (lci-id part))
    ((string= part "arguments")
     (make-id '("lisp-plus" "lci" "0" "fixture" "mneme-proposition" "field")
              (list part)))
    (t (fixture-field-id part))))

(defun path-datum (path)
  ;; Keep the prior component explicit.  A LOOP `for previous = nil then part`
  ;; binding is evaluated in parallel with PART on SBCL and therefore observes
  ;; the current component here, misclassifying proposition arguments as their
  ;; own children.  Structural paths are normative LCI values, so this must not
  ;; depend on a LOOP stepping subtlety.
  (let ((previous nil))
    (make-sequence-datum
     (loop for part in path
           collect (prog1 (%path-part-id part previous)
                     (setf previous part))))))

(defun vector-context (vector-id)
  (make-fixture-record (list "vector-id" (make-string-datum vector-id))))

(defun failure-datum (condition vector-id)
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
                        (vector-context vector-id)))))
