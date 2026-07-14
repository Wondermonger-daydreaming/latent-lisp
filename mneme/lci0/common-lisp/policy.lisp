(in-package #:lisp-plus-lci0)

;;; The finite package policies are conformance instruments.  This evaluator
;;; intentionally has no extension/default branch that could become production
;;; admissibility policy.

(defun %hard-floor-decision-id (policy code)
  (let ((prefix (if (string= policy "a") "a" "b"))
        (suffix (cond ((string= code "ScopeNarrowingCoverageInsufficient")
                       "coverage-hard-reject")
                      ((string= code "ScopeIncompatible")
                       "incompatible-hard-reject")
                      ((string= code "ScopeNarrowingNotDeclared")
                       "nonmonotone-hard-reject")
                      (t "relation-unknown-hard-reject"))))
    (format nil "admissibility-decision.~A-~A" prefix suffix)))

(defun %fixture-policy-letter (policy)
  (cond ((equal-datum policy (registry-datum "admissibility-policy.a.0")) "a")
        ((equal-datum policy (registry-datum "admissibility-policy.b.0")) "b")
        (t (lci-fail "invalid-input" "UnsupportedFixturePolicy"
                     "admissibility" :path '("policy")))))

(defun %relation-failure-code (relation)
  (when (and (record-datum-p relation) (exact-kind-p relation "failure"))
    (let ((code (record-field-named relation "code")))
      (and (identifier-datum-p code) (identifier-last code)))))

(defun %fixture-event-tick (time)
  (let* ((expression (record-field-named time "expression"))
         (tick (record-field-named expression "tick")))
    (and (integer-datum-p tick) (integer-datum-value tick))))

(defun evaluate-fixture-policy (policy relation &key target query-time)
  (let* ((letter (%fixture-policy-letter policy))
         (failure-code (%relation-failure-code relation)))
    (when failure-code
      (return-from evaluate-fixture-policy
        (registry-datum (%hard-floor-decision-id letter failure-code))))
    (unless (and (record-datum-p relation)
                 (id-path= (record-field-named relation "status")
                           "result-status" "success")
                 (member (identifier-last (record-field-named relation "relation"))
                         '("exact-target" "supports-by-scope-narrowing")
                         :test #'string=))
      (lci-fail "relation-undetermined" "ScopeRelationUnknown"
                "admissibility" :path '("target-relation")))
    (unless target
      (lci-fail "invalid-input" "MissingFixturePolicyTarget"
                "admissibility" :path '("target")))
    (validate-warrant-target target)
    (let ((kind (identifier-last (record-field-named target "target-kind"))))
      (cond
        ((string= kind "externally-attested")
         (registry-datum
          (if (string= letter "a")
              "admissibility-decision.a-external-reject"
              "admissibility-decision.b-external-trusted")))
        ((and (string= kind "observed") (string= letter "a") query-time)
         (let* ((observation-time
                  (record-field-named (record-field-named target "boundaries")
                                      "observation-time"))
                (observed (%fixture-event-tick observation-time))
                (queried (%fixture-event-tick query-time)))
           (unless (and observed queried (>= queried observed))
             (lci-fail "invalid-input" "InvalidFixtureFreshnessTime"
                       "admissibility" :path '("query-time")))
           (registry-datum
            (if (<= (- queried observed) 24)
                "admissibility-decision.a-observed-fresh"
                "admissibility-decision.a-observed-stale"))))
        ((and (string= kind "inherited") (string= letter "b"))
         (registry-datum "admissibility-decision.b-inherited-limited"))
        (t
         (lci-fail "invalid-input" "UnsupportedFixturePolicyCase"
                   "admissibility" :path '("target" "target-kind")))))))
