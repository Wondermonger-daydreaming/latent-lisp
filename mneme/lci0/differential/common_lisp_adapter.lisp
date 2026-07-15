(load "mneme/lci0/common-lisp/load.lisp")

(in-package #:lisp-plus-lci0)

(defparameter +integration-protocol+ "lisp-plus-lci0-differential/v1")
(defparameter +integration-profile+ "0.1.0")
(defparameter +integration-seed-commit+
  "b3d28bc49c3b015096cb04c6ad08c19829f511a9")
(defparameter +integration-seed-tree+
  "d48c39f933cde591f3303fcd3c9f42a0dac1a869")
(defparameter +integration-request-fields+
  '("budget" "fixture_profile_version" "input_canonical_hex" "operation"
    "protocol" "request_id"))

(define-condition integration-protocol-failure (error)
  ((code :initarg :code :reader integration-protocol-failure-code)
   (path :initarg :path :initform nil :reader integration-protocol-failure-path)))

(defun integration-protocol-fail (code &optional path)
  (error 'integration-protocol-failure :code code :path path))

(defun integration-json-boolean (value)
  (if value :json-true :json-false))

(defun integration-object-fields-exact-p (object expected)
  (and (listp object)
       (every (lambda (pair) (and (consp pair) (stringp (car pair)))) object)
       (equal (sort (mapcar #'car object) #'string<) expected)))

(defun integration-lower-hex-p (value)
  (and (stringp value)
       (evenp (length value))
       (every (lambda (character)
                (or (char<= #\0 character #\9)
                    (char<= #\a character #\f)))
              value)))

(defun integration-validate-budget (budget)
  (unless (and
           (integration-object-fields-exact-p
            budget
            '("cd0_budget_id" "lci_budget_canonical_sha256"
              "lci_budget_fixture_id"))
           (string= (jget budget "cd0_budget_id")
                    "lci0-first-implementation-cd0")
           (string= (jget budget "lci_budget_fixture_id")
                    "resource-budget.lci-first-implementation.0")
           (string= (jget budget "lci_budget_canonical_sha256")
                    "b574f188fbc24c99018a8095fb9846511f582136c416b5f4cd685ba67ee16c93"))
    (integration-protocol-fail "UnpinnedDifferentialBudget" '("budget"))))

(defun integration-validate-request (request)
  (unless (integration-object-fields-exact-p request +integration-request-fields+)
    (integration-protocol-fail "InvalidDifferentialRequest"))
  (unless (and (stringp (jget request "protocol"))
               (string= (jget request "protocol") +integration-protocol+))
    (integration-protocol-fail "UnsupportedDifferentialProtocol" '("protocol")))
  (unless (and (stringp (jget request "request_id"))
               (plusp (length (jget request "request_id"))))
    (integration-protocol-fail "InvalidDifferentialRequestId" '("request_id")))
  (unless (and (stringp (jget request "operation"))
               (plusp (length (jget request "operation"))))
    (integration-protocol-fail "InvalidDifferentialOperation" '("operation")))
  (unless (and (stringp (jget request "fixture_profile_version"))
               (string= (jget request "fixture_profile_version")
                        +integration-profile+))
    (integration-protocol-fail "UnsupportedFixtureProfile"
                               '("fixture_profile_version")))
  (unless (integration-lower-hex-p (jget request "input_canonical_hex"))
    (integration-protocol-fail "InvalidCanonicalHex" '("input_canonical_hex")))
  (integration-validate-budget (jget request "budget"))
  request)

(defun integration-base-response (request)
  (list
   (cons "protocol" +integration-protocol+)
   (cons "request_id" (jget request "request_id"))
   (cons "operation" (jget request "operation"))
   (cons "fixture_profile_version"
         (jget request "fixture_profile_version"))
   (cons "implementation" "common-lisp")
   (cons "implementation_seed_commit" +integration-seed-commit+)
   (cons "implementation_seed_tree" +integration-seed-tree+)))

(defun integration-render-path (path-strings)
  (let ((previous nil))
    (loop for part in path-strings
          for identifier = (%path-part-id part previous)
          collect (prog1
                      (if (equal (identifier-namespace-strings identifier)
                                 +fixture-field-namespace+)
                          (concatenate 'string "fixture-field:"
                                       (identifier-last identifier))
                          (identifier-last identifier))
                    (setf previous part)))))

(defun integration-failure-json (condition)
  (list
   (cons "category" (lci-failure-category condition))
   (cons "code" (lci-failure-code condition))
   (cons "stage" (lci-failure-stage condition))
   (cons "path" (integration-render-path (lci-failure-path condition)))))

(defun integration-right-operand-symbolic-p (right)
  "Mirror of lci0.closure temporal predicate: the right operand's expression
form is symbolic (LCI0-AC-002)."
  (handler-case
      (string= (or (exact-form-name (record-field-named right "expression")) "")
               "symbolic")
    (error () nil)))

(defun integration-relation-companion-failure (operation right condition)
  "Companion failure JSON with the ruled deepened path for the 38 LCI0-AC-002
closure rows; every other row keeps the engine's own rendered path.  Scope
cross-calculus incompatibility selects the right operand's calculus; a symbolic
right temporal form selects the right operand's expression form."
  (let ((code (lci-failure-code condition)))
    (cond
      ((and (string= operation "scope-relation-table")
            (string= code "ScopeIncompatible"))
       (list (cons "category" (lci-failure-category condition))
             (cons "code" code)
             (cons "stage" (lci-failure-stage condition))
             (cons "path"
                   (integration-render-path '("fixture-field:right" "calculus")))))
      ((and (string= operation "temporal-relation-table")
            (string= code "AdmissibilityUndetermined")
            (integration-right-operand-symbolic-p right))
       (list (cons "category" (lci-failure-category condition))
             (cons "code" code)
             (cons "stage" (lci-failure-stage condition))
             (cons "path"
                   (integration-render-path
                    '("fixture-field:right" "expression" "form")))))
      (t (integration-failure-json condition)))))

(defun integration-conformance-value-doc (payload actual)
  "The ruled within-budget conformance value document (LCI0-AC-007): limit read
from the frozen resource table the guard enforces, requested from the validated
workload, within-budget from the executed result, workload from the validated
resource identity.  Reached only for the inclusive-limit success."
  (multiple-value-bind (definition requested)
      (%validate-resource-workload (record-field-named payload "workload"))
    (let ((within (record-field-named (record-field-named actual "outputs")
                                      "within-budget")))
      (result-record
       (record-field-named actual "operation")
       (list
        (list "limit" (make-integer-datum (second definition)))
        (list "requested" (make-integer-datum requested))
        (list "within-budget" within)
        (list "workload" (make-string-datum (first definition))))))))

(defun integration-relation-failure-value (condition)
  (cond
    ((member (lci-failure-code condition)
             '("ScopeIncompatible" "UnsupportedTemporalModel")
             :test #'string=)
     "incompatible")
    ((member (lci-failure-code condition)
             '("ScopeRelationUnknown" "AdmissibilityUndetermined")
             :test #'string=)
     "unknown")
    (t nil)))

(defun integration-run-relation (operation datum response)
  (let ((left-name (if (string= operation "scope-relation-table")
                       "left-scope" "left-subject-time"))
        (right-name (if (string= operation "scope-relation-table")
                        "right-scope" "right-subject-time")))
    (handler-case
        (let ((relation
                (if (string= operation "scope-relation-table")
                    (scope-relation (record-field-named datum left-name)
                                    (record-field-named datum right-name))
                    (temporal-relation (record-field-named datum left-name)
                                       (record-field-named datum right-name)))))
          (append response
                  (list (cons "semantic_status" "success")
                        (cons "relation" (identifier-last relation)))))
      (lci-failure (condition)
        (let ((relation (integration-relation-failure-value condition)))
          (unless relation (error condition))
          (append response
                  (list (cons "semantic_status" "failure")
                        (cons "failure"
                              (integration-relation-companion-failure
                               operation (record-field-named datum right-name)
                               condition))
                        (cons "relation" relation))))))))

(defun integration-vector-components (datum)
  (let ((expected '("fixture-profile-version" "kind" "operation" "payload"
                    "schema-version" "vector-id")))
    (unless (and (record-datum-p datum)
                 (equal (sort (copy-list (record-field-names datum)) #'string<)
                        expected))
      (integration-protocol-fail "InvalidFixtureVectorEnvelope"
                                 '("input_canonical_hex"))))
  (values (datum-string-value* (record-field-named datum "vector-id"))
          (record-field-named datum "operation")
          (datum-string-value*
           (record-field-named datum "fixture-profile-version"))
          (record-field-named datum "payload")))

(defun integration-run-semantic (operation datum response)
  (multiple-value-bind (vector-id operation-id profile payload)
      (integration-vector-components datum)
    (unless (string= operation (operation-name operation-id))
      (integration-protocol-fail "DifferentialOperationMismatch" '("operation")))
    (unless (and profile (string= profile +integration-profile+))
      (integration-protocol-fail "EmbeddedFixtureProfileMismatch"
                                 '("input_canonical_hex")))
    (handler-case
        (let* ((actual (execute-fixture-operation operation-id payload
                                                  :vector-id vector-id))
               ;; LCI0-AC-007: the inclusive-limit conformance success projects
               ;; to the ruled within-budget value document.  Over-limit
               ;; conformance vectors raise lci-failure and never reach here.
               (result (if (string= operation "conformance-validation")
                           (integration-conformance-value-doc payload actual)
                           actual)))
          (append response
                  (list
                   (cons "vector_id" vector-id)
                   (cons "semantic_status" "success")
                   (cons "actual_canonical_cd0_hex"
                         (octets-to-hex (canonical-octets result))))))
      (lci-failure (condition)
        (let ((actual (failure-datum condition vector-id)))
          (append response
                  (list
                   (cons "vector_id" vector-id)
                   (cons "semantic_status" "failure")
                   (cons "failure" (integration-failure-json condition))
                   (cons "actual_canonical_cd0_hex"
                         (octets-to-hex (canonical-octets actual))))))))))

(defun integration-run-hostile-validation (operation datum response)
  (handler-case
      (progn
        (cond ((string= operation "hostile-validate-stable-ref")
               (validate-stable-ref datum))
              ((string= operation "hostile-validate-claim-id")
               (validate-claim-id datum))
              (t (validate-warrant-target datum)))
        (append response (list (cons "semantic_status" "success"))))
    (lci-failure (condition)
      (append response
              (list (cons "semantic_status" "failure")
                    (cons "failure" (integration-failure-json condition)))))))

(defun integration-run-hostile-projection (datum response)
  (handler-case
      (progn
        ;; This is direct projection, not occurrence projection.  The carrier
        ;; therefore reaches the ordinary four-field ClaimId input validator
        ;; unchanged.
        (project-claim-id datum)
        (append response (list (cons "semantic_status" "success"))))
    (lci-failure (condition)
      (append response
              (list (cons "semantic_status" "failure")
                    (cons "failure" (integration-failure-json condition)))))))

(defun integration-require-exact-hostile-carrier (datum fields)
  (unless (%resource-exact-record-shape-p
           datum +fixture-field-namespace+ fields)
    (integration-protocol-fail "InvalidHostileCarrier" '("operation")))
  datum)

(defun integration-run-hostile-match (datum response)
  (integration-require-exact-hostile-carrier
   datum '("target" "candidate-claim"))
  (handler-case
      (progn
        (match-warrant-target (record-field-named datum "target")
                              (record-field-named datum "candidate-claim"))
        (append response (list (cons "semantic_status" "success"))))
    (lci-failure (condition)
      (append response
              (list (cons "semantic_status" "failure")
                    (cons "failure" (integration-failure-json condition)))))))

(defun integration-run-hostile-claim-id-equality (datum response)
  (integration-require-exact-hostile-carrier
   datum '("left-claim-id" "right-claim-id"))
  (handler-case
      (let ((left (record-field-named datum "left-claim-id"))
            (right (record-field-named datum "right-claim-id")))
        ;; Structural equality is meaningful here only after both operands are
        ;; validated ClaimId envelopes.
        (validate-claim-id left)
        (validate-claim-id right)
        (equal-datum left right)
        (append response (list (cons "semantic_status" "success"))))
    (lci-failure (condition)
      (append response
              (list (cons "semantic_status" "failure")
                    (cons "failure" (integration-failure-json condition)))))))

(defun integration-run-hostile-policy (datum response)
  (let ((target-relation (and (record-datum-p datum)
                              (record-field-named datum "target-relation"))))
    (unless (and
             (%resource-exact-record-shape-p
              datum +fixture-field-namespace+ '("policy" "target-relation"))
             (%exact-identifier-p
              (record-field-named datum "policy")
              +fixture-identifier-namespace+ '("policy-name" "policy-c"))
             (%resource-exact-record-shape-p
              target-relation +fixture-field-namespace+
              '("kind" "schema-version" "status" "relation"))
             (%exact-identifier-p
              (record-field-named target-relation "kind")
              +fixture-identifier-namespace+
              '("tag" "target-relation-result"))
             (let ((version
                     (datum-integer-value*
                      (record-field-named target-relation "schema-version"))))
               (and version (zerop version)))
             (%exact-identifier-p
              (record-field-named target-relation "status")
              +fixture-identifier-namespace+ '("result-status" "success"))
             (%exact-identifier-p
              (record-field-named target-relation "relation")
              '("lisp-plus" "lci" "0" "relation") '("exact-target")))
      (integration-protocol-fail "InvalidPolicyCCarrier" '("operation"))))
  (handler-case
      (progn
        (evaluate-fixture-policy (record-field-named datum "policy")
                                 (record-field-named datum "target-relation"))
        (integration-protocol-fail "UnexpectedPolicyCSuccess" '("operation")))
    (fixture-operation-authorial-gap (condition)
      (unless (and
               (string= (fixture-operation-authorial-gap-operation condition)
                        "evaluate-fixture-policy")
               (equal (fixture-operation-authorial-gap-path condition)
                      '("policy")))
        (integration-protocol-fail "UnexpectedFixtureAuthorityGap"
                                   '("operation")))
      ;; This is a protocol-only disposition for the one validated hostile
      ;; Policy-C request.  It is not LCIFailure/0 and carries no semantic,
      ;; failure, vector, or actual-result member.
      (append response
              (list (cons "status" "blocked")
                    (cons "authority_gap" "unsupported fixture policy"))))
    (lci-failure (condition)
      (declare (ignore condition))
      (integration-protocol-fail "UnexpectedPolicyCLciFailure"
                                 '("operation")))))

(defun integration-validated-protocol-failure-response
    (request condition &optional input-reencoded-canonical-hex)
  (append
   (integration-base-response request)
   (list (cons "protocol_status" "failure"))
   (when input-reencoded-canonical-hex
     (list (cons "input_reencoded_canonical_hex"
                 input-reencoded-canonical-hex)))
   (list
    (cons "protocol_failure"
          (list
           (cons "code" (integration-protocol-failure-code condition))
           (cons "path" (integration-protocol-failure-path condition)))))))

(defun integration-run-validated-request (request)
  (let* ((response (integration-base-response request))
         (operation (jget request "operation"))
         (encoded (hex-to-octets (jget request "input_canonical_hex")))
         (datum (decode-exact encoded))
         (reencoded (canonical-octets datum))
         (reencoded-hex (octets-to-hex reencoded)))
    (handler-case
        (progn
          (unless (string= (jget request "input_canonical_hex") reencoded-hex)
            (integration-protocol-fail "NoncanonicalDifferentialInput"
                                       '("input_canonical_hex")))
          (setf response
                (append response
                        (list
                         (cons "protocol_status"
                               (if (string= operation
                                            "hostile-evaluate-policy-c")
                                   "fixture-authority-gap"
                                   "success"))
                         (cons "input_reencoded_canonical_hex"
                               reencoded-hex))))
          (handler-case
              (cond
                ((string= operation "hostile-evaluate-policy-c")
                 (integration-run-hostile-policy datum response))
                ((string= operation "hostile-project-claim-id")
                 (integration-run-hostile-projection datum response))
                ((string= operation "hostile-match-target")
                 (integration-run-hostile-match datum response))
                ((string= operation "hostile-claim-ids-equal")
                 (integration-run-hostile-claim-id-equality datum response))
                ((string= operation "document-roundtrip")
                 (append response (list (cons "semantic_status" "success"))))
                ((member operation
                         '("scope-relation-table" "temporal-relation-table")
                         :test #'string=)
                 (integration-run-relation operation datum response))
                ((member operation
                         '("hostile-validate-stable-ref"
                           "hostile-validate-claim-id"
                           "hostile-validate-warrant-target")
                         :test #'string=)
                 (integration-run-hostile-validation operation datum response))
                (t (integration-run-semantic operation datum response)))
            (fixture-operation-authorial-gap (condition)
              (declare (ignore condition))
              ;; Exact-vector and every non-Policy-C authority gap is a closed
              ;; adapter/protocol failure, never an accepted BLOCKED result.
              (integration-protocol-fail "UnexpectedFixtureAuthorityGap"
                                         '("operation")))))
      (integration-protocol-failure (condition)
        (integration-validated-protocol-failure-response
         request condition reencoded-hex))
      (error (condition)
        (declare (ignore condition))
        (integration-validated-protocol-failure-response
         request
         (make-condition 'integration-protocol-failure
                         :code "CommonLispAdapterDefect" :path nil)
         reencoded-hex)))))

(defun integration-run-request (raw)
  (handler-case
      (integration-run-validated-request (integration-validate-request raw))
    (integration-protocol-failure (condition)
      (list
       (cons "protocol" +integration-protocol+)
       (cons "request_id"
             (if (and (listp raw) (jhas-p raw "request_id")
                      (stringp (jget raw "request_id")))
                 (jget raw "request_id") ""))
       (cons "implementation" "common-lisp")
       (cons "protocol_status" "failure")
       (cons "protocol_failure"
             (list
              (cons "code" (integration-protocol-failure-code condition))
              (cons "path" (integration-protocol-failure-path condition))))))
    (error (condition)
      (declare (ignore condition))
      (list
       (cons "protocol" +integration-protocol+)
       (cons "request_id"
             (if (and (listp raw) (jhas-p raw "request_id")
                      (stringp (jget raw "request_id")))
                 (jget raw "request_id") ""))
       (cons "implementation" "common-lisp")
       (cons "protocol_status" "failure")
       (cons "protocol_failure"
             (list
              (cons "code" "CommonLispAdapterDefect")
              (cons "path" nil)))))))

(loop for line = (read-line *standard-input* nil nil)
      while line
      unless (zerop (length line))
        do (let ((response
                   (handler-case
                       (integration-run-request (parse-json line))
                     (error (condition)
                       (declare (ignore condition))
                       (list
                        (cons "protocol" +integration-protocol+)
                        (cons "request_id" "")
                        (cons "implementation" "common-lisp")
                        (cons "protocol_status" "failure")
                        (cons "protocol_failure"
                              (list
                               (cons "code" "InvalidRunnerJSON")
                               (cons "path" nil))))))))
             (write-json-value response *standard-output*)
             (terpri *standard-output*)
             (finish-output *standard-output*)))
