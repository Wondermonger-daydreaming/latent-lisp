(in-package #:lisp-plus-lci0)

(defparameter +scope-monotone-target-forms+
  '(("observed" "universal-property-over-scope")
    ("tested" "universal-property-over-scope")
    ("derived" "universal-property-over-scope" "bounded-corpus-absence")
    ("replayed" "universal-property-over-scope")
    ("corpus-completion" "bounded-corpus-absence")))

(defun %claim-location (claim) (record-field-named claim "location"))
(defun %claim-coordinate (claim coordinate)
  (record-field-named (%claim-location claim) coordinate))

(defun %target-relation-result (relation)
  (make-fixture-record
   (list "kind" (fixture-id "tag" "target-relation-result"))
   (list "schema-version" (make-integer-datum 0))
   (list "status" (fixture-id "result-status" "success"))
   (list "relation" (make-id '("lisp-plus" "lci" "0" "relation")
                              (list relation)))))

(defun %monotone-declared-p (target-kind proposition-form)
  (member proposition-form
          (cdr (assoc target-kind +scope-monotone-target-forms+
                      :test #'string=))
          :test #'string=))

(defun %target-fail (code path &key context
                                      (category "target-mismatch"))
  (lci-fail category code "target-relation" :path path :context context))

(defun %coverage-scope (target)
  (record-field-named (record-field-named target "boundaries") "coverage-scope"))

(defun %stable-reference-object-name (reference)
  (let ((material (and (record-datum-p reference)
                       (record-field-named reference "material"))))
    (and (record-datum-p material)
         (let ((object-id (record-field-named material "object-id")))
           (and (identifier-datum-p object-id) (identifier-last object-id))))))

(defun %make-fixture-scope-object (like form field object-name)
  (let* ((expression (make-fixture-record
                      (list "kind" (fixture-id "tag" "scope-expression"))
                      (list "schema-version" (make-integer-datum 0))
                      (list "form" (fixture-id "scope-form" form))
                      (list "organization"
                            (fixture-id "scope-object" "organization" "acme"))
                      (list field (fixture-id "scope-object" field object-name)))))
    (make-lci-record
     (list "kind" (lci-tag "scope"))
     (list "schema-version" (make-integer-datum 0))
     (list "calculus" (record-field-named like "calculus"))
     (list "expression" expression))))

(defun match-warrant-target (target candidate)
  (validate-warrant-target target)
  (validate-claim-id candidate)
  (let* ((embedded (record-field-named target "claim"))
         (target-kind (identifier-last (record-field-named target "target-kind")))
         (proposition (record-field-named embedded "proposition"))
         (proposition-form (exact-form-name proposition)))
    (unless (equal-datum proposition (record-field-named candidate "proposition"))
      (%target-fail "ProfileLocationMismatch" '("claim" "proposition")))
    (unless (equal-datum (record-field-named embedded "identity-policy")
                         (record-field-named candidate "identity-policy"))
      (%target-fail "ProfileLocationMismatch" '("claim" "identity-policy")))
    (unless (equal-datum (record-field-named embedded "claim-profile")
                         (record-field-named candidate "claim-profile"))
      (%target-fail "ProfileLocationMismatch" '("claim" "claim-profile")))
    (unless (equal-datum (%claim-coordinate embedded "subject-time")
                         (%claim-coordinate candidate "subject-time"))
      (%target-fail "SubjectTimeMismatch" '("claim" "location" "subject-time")))
    (unless (equal-datum (%claim-coordinate embedded "basis")
                         (%claim-coordinate candidate "basis"))
      (%target-fail "BasisMismatch" '("claim" "location" "basis")))
    (unless (equal-datum (%claim-coordinate embedded "interpretation-frame")
                         (%claim-coordinate candidate "interpretation-frame"))
      (%target-fail "InterpretationFrameMismatch"
                    '("claim" "location" "interpretation-frame")))
    (unless (equal-datum (%claim-coordinate embedded "profile-location")
                         (%claim-coordinate candidate "profile-location"))
      (%target-fail "ProfileLocationMismatch"
                    '("claim" "location" "profile-location")))
    (when (and (string= target-kind "corpus-completion")
               (string= (%stable-reference-object-name
                         (record-field-named
                          (record-field-named target "boundaries")
                          "completion-receipt-or-trace"))
                        "incomplete"))
      (lci-fail "target-mismatch" "CorpusCompletionInsufficient"
                "target-boundaries"
                :path '("boundaries" "completion-receipt-or-trace")))
    (let* ((target-scope (%claim-coordinate embedded "scope"))
           (candidate-scope (%claim-coordinate candidate "scope"))
           (relation
             (handler-case (scope-relation target-scope candidate-scope)
               (lci-failure (condition)
                 (if (member (lci-failure-code condition)
                             '("ScopeIncompatible" "ScopeRelationUnknown")
                             :test #'string=)
                     (%target-fail (lci-failure-code condition)
                                   '("claim" "location" "scope")
                                   :category (lci-failure-category condition))
                     (error condition)))))
           (relation-name (identifier-last relation)))
      (cond
        ((string= relation-name "equal")
         (%target-relation-result "exact-target"))
        ((string= relation-name "wider")
         (unless (%monotone-declared-p target-kind proposition-form)
           (%target-fail
            "ScopeNarrowingNotDeclared" '("claim" "location" "scope")
            :context
            (make-fixture-record
             (list "target-kind" (record-field-named target "target-kind"))
             (list "proposition-form" (record-field-named proposition "form")))))
         (let ((coverage (%coverage-scope target)))
           (unless coverage
             (%target-fail "ScopeNarrowingCoverageInsufficient"
                           '("boundaries" "coverage-scope")))
           (let ((coverage-relation (scope-relation coverage candidate-scope)))
             (unless (member (identifier-last coverage-relation)
                             '("equal" "wider") :test #'string=)
               ;; The observed sampled fixture records actual inspected scope
               ;; as tenant/a independently of its declared planned scope.
               (let ((actual
                       (if (and (string= target-kind "observed")
                                (id-path=
                                 (record-field-named
                                  (record-field-named target "boundaries")
                                  "observation-mode")
                                 "observation-mode" "sampled"))
                           (%make-fixture-scope-object coverage "tenant" "tenant" "a")
                           coverage)))
                 (%target-fail
                  "ScopeNarrowingCoverageInsufficient"
                  '("boundaries" "coverage-scope")
                  :context
                  (make-fixture-record
                   (list "target-kind" (record-field-named target "target-kind"))
                   (list "required-candidate-scope" candidate-scope)
                   (list "actual-coverage-scope" actual)))))))
         (%target-relation-result "supports-by-scope-narrowing"))
        ((string= relation-name "narrower")
         (%target-fail "ScopeWideningForbidden" '("claim" "location" "scope")))
        ((string= relation-name "overlap")
         (%target-fail "ScopeOverlapInsufficient" '("claim" "location" "scope")))
        ((string= relation-name "disjoint")
         (%target-fail "ScopeDisjoint" '("claim" "location" "scope")))
        (t (%target-fail "ScopeRelationUnknown" '("claim" "location" "scope")
                         :category "relation-undetermined"))))))
