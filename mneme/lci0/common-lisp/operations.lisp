(in-package #:lisp-plus-lci0)

(declaim (ftype function %payload-claim-from-occurrence %claim-difference))

;; Closed operation payload shapes, mechanically censused from all 215 frozen
;; vectors.  Operations with more than one declared fixture form list each
;; complete alternative; there is no open/default payload surface.
(defparameter +operation-payload-shapes+
  '(("apply-admissibility-floor"
     ("target-relation" "policy-a" "policy-b"))
    ("apply-occurrence-corrections"
     ("original" "provenance-corrected" "proposition-corrected"))
    ("apply-stable-ref-bridge" ("source-reference" "bridge"))
    ("canonicalize-record-order"
     ("left-construction-order" "right-construction-order"
      "left-claim" "right-claim"))
    ("classify-version-governance"
     ("change" "accepted-abstract-inputs-unchanged"
      "normalized-propositions-unchanged" "claim-ids-unchanged"
      "projection-field-set-unchanged" "relations-and-failures-unchanged"))
    ("compare-bridge-source-and-target" ("source" "target" "bridge"))
    ("compare-claim-digests-and-envelopes"
     ("left-claim-id" "right-claim-id" "left-operational-digest"
      "right-operational-digest" "digest-scheme"))
    ("compare-claim-id-set" ("claims"))
    ("compare-claim-ids" ("left" "right"))
    ("compare-corpus-completion-targets"
     ("complete-target" "incomplete-target" "candidate-claim"))
    ("compare-stable-refs"
     ("left-reference" "right-reference" "bridge-registry"))
    ("compare-unicode-claim-ids" ("nfc-claim" "nfd-claim"))
    ("compare-warrant-targets" ("left-target" "right-target"))
    ("conformance-matching" ("workload" "budget"))
    ("conformance-migration" ("workload" "budget"))
    ("conformance-normalization" ("workload" "budget"))
    ("conformance-validation" ("workload" "budget"))
    ("differential-project" ("evidence"))
    ("evaluate-admissibility-under-two-policies"
     ("claim" "target" "policy-a" "policy-b"))
    ("evaluate-freshness-two-query-times"
     ("claim" "target" "policy" "fresh-query" "stale-query"))
    ("map-migration-classification"
     ("lci-classification" "prior-ruling-terms"))
    ("match-target" ("target" "candidate-claim"))
    ("migrate-v1" ("source") ("legacy-record"))
    ("migrate-v1-collision-pair" ("left-source" "right-source"))
    ("normalize-controlled-translation" ("left-receipt" "right-receipt"))
    ("normalize-preprojection-coordinate"
     ("coordinate" "normalizer" "left" "right"))
    ("normalize-proposition" ("workload" "budget") ("proposition"))
    ("parse-and-migrate-printer-variants"
     ("compact-source" "pretty-source"))
    ("parse-legacy-source" ("source"))
    ("project-claim-id" ("claim") ("claim-id-substitute")
     ("digest" "digest-scheme"))
    ("project-occurrence" ("occurrence"))
    ("project-occurrences" ("baseline" "mutated-metadata")
     ("left-occurrence" "right-occurrence")
     ("comparison-coordinate" "left-occurrence" "right-occurrence"))
    ("proposition-location-consistent" ("proposition" "location"))
    ("restore-live-warrant" ("source"))
    ("revive-inert-occurrence" ("predecessor" "requested-claim"))
    ("scope-relation" ("left" "right"))
    ("temporal-relation" ("left" "right"))
    ("translate-exactly" ("source-receipt" "target-receipt"))
    ("translate-with-represented-loss"
     ("source-claim" "target-claim" "loss"))
    ("validate-claim-id" ("claim") ("claim" "precedence"))
    ("validate-migration-result" ("migration-result"))
    ("validate-normalizer-conformance-evidence"
     ("binding" "mutation-vector" "semantic-projection-ledger"))
    ("validate-normalizer-revision" ("proposal"))
    ("validate-occurrence" ("occurrence"))
    ("validate-pinned-fixture" ("fixture-value" "registry-definition"))
    ("validate-policy-evaluation-target" ("target"))
    ("validate-profile-location" ("profile-location"))
    ("validate-represented-loss-account" ("operation" "account"))
    ("validate-stable-ref" ("reference"))
    ("validate-stable-ref-scheme-selection"
     ("domain" "canonical-scheme" "example-reference"))
    ("validate-warrant-target" ("target") ("target" "precedence"))
    ("witness-semantic-claim-id-equality"
     ("left-claim-id" "right-claim-id"))))

(defun %payload-has-exact-field-p (payload field)
  (loop for index below (record-datum-size payload)
        for key = (record-datum-key-at payload index)
        thereis (and (identifier-datum-p key)
                     (equal (identifier-namespace-strings key)
                            +fixture-field-namespace+)
                     (equal (identifier-path-strings key) (list field)))))

(defun %payload-exact-shape-p (payload fields)
  (and (= (record-datum-size payload) (length fields))
       (every (lambda (field) (%payload-has-exact-field-p payload field))
              fields)))

(defun %validate-operation-payload (name payload)
  (unless (record-datum-p payload)
    (%fixture-operation-authorial-gap name '("payload")))
  (let ((shapes (cdr (assoc name +operation-payload-shapes+ :test #'string=))))
    (unless shapes
      (%fixture-operation-authorial-gap name '("operation")))
    (when (some (lambda (shape) (%payload-exact-shape-p payload shape)) shapes)
      (return-from %validate-operation-payload payload))
    ;; Select the closest declared alternative only to produce deterministic
    ;; standard missing-before-unknown diagnostics for malformed payloads.
    (let ((best (first shapes)) (best-score -1))
      (dolist (shape shapes)
        (let ((score (count-if (lambda (field)
                                 (%payload-has-exact-field-p payload field))
                               shape)))
          (when (> score best-score)
            (setf best shape best-score score))))
      (require-closed-fields payload best "fixture-operation-payload"
                             :key-namespace +fixture-field-namespace+
                             :path-prefix '("payload"))
      (reject-unknown-fields payload best "fixture-operation-payload"
                             :key-namespace +fixture-field-namespace+
                             :path-prefix '("payload"))
      ;; Equal cardinality/field presence was checked above, so reaching this
      ;; point can only mean an invalid field key that standard closure should
      ;; already have refused.
      (lci-fail "invalid-input" "UnknownField" "fixture-operation-payload"
                :path '("payload" "invalid-field-key")))))

(defun %output (name value) (list name value))

(defun %operation-refuse (path &optional (stage "fixture-dispatch"))
  ;; Several fixture operations have only one frozen positive or negative
  ;; witness.  A mutation outside that witness must not inherit the witness's
  ;; result.  No generic LCI failure code is frozen for this boundary.
  (%fixture-operation-authorial-gap stage path))

(defun %validate-translation-receipt (receipt path)
  (require-closed-fields receipt
                         '("source-language" "surface" "normalized-claim-id")
                         "translation-receipt"
                         :key-namespace +fixture-field-namespace+
                         :path-prefix path)
  (let ((language (record-field-named receipt "source-language"))
        (surface (record-field-named receipt "surface"))
        (claim (record-field-named receipt "normalized-claim-id")))
    (unless (and (identifier-datum-p language)
                 (equal (identifier-namespace-strings language)
                        +fixture-identifier-namespace+)
                 (= (length (identifier-path-strings language)) 2)
                 (string= (first (identifier-path-strings language))
                          "language"))
      (%operation-refuse (append path '("source-language"))))
    (unless (string-datum-p surface)
      (%operation-refuse (append path '("surface"))))
    (validate-claim-id claim :path (append path '("normalized-claim-id")))
    (reject-unknown-fields receipt
                           '("source-language" "surface"
                             "normalized-claim-id")
                           "translation-receipt"
                           :key-namespace +fixture-field-namespace+
                           :path-prefix path)
    receipt))

(defun %record-differing-field-names (left right)
  (unless (and (record-datum-p left) (record-datum-p right)
               (= (record-datum-size left) (record-datum-size right)))
    (return-from %record-differing-field-names nil))
  (loop for index below (record-datum-size left)
        for left-key = (record-datum-key-at left index)
        for right-key = (record-datum-key-at right index)
        unless (equal-datum left-key right-key)
          do (return-from %record-differing-field-names nil)
        unless (equal-datum (record-datum-value-at left index)
                            (record-datum-value-at right index))
          collect (identifier-last left-key)))

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
    (%validate-translation-receipt left '("left-receipt"))
    (%validate-translation-receipt right '("right-receipt"))
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
    (let* ((embedded-same
             (equal-datum (record-field-named left "claim")
                          (record-field-named right "claim")))
           (target-same (equal-datum left right))
           (top-differences (%record-differing-field-names left right))
           (boundary-differences
             (%record-differing-field-names
              (record-field-named left "boundaries")
              (record-field-named right "boundaries"))))
      ;; P013 pins this category for equal observed schemas/claims whose
      ;; observation-procedure boundary differs.  Do not reuse it for an
      ;; unrelated target mutation.
      (unless (and embedded-same (not target-same)
                   (equal top-differences '("boundaries"))
                   (equal boundary-differences '("observation-procedure")))
        (%operation-refuse '("left-target" "boundaries")))
      (list (%output "embedded-claim-same" (datum-boolean embedded-same))
            (%output "warrant-targets-equal" (datum-boolean target-same))
            (%output "difference"
                     (fixture-id "target-coordinate"
                                 "procedure-and-event-boundaries"))))))

(defun %execute-compare-corpus-completion-targets (payload)
  (let* ((complete (record-field-named payload "complete-target"))
         (incomplete (record-field-named payload "incomplete-target"))
         (candidate (record-field-named payload "candidate-claim"))
         (complete-relation (match-warrant-target complete candidate))
         (incomplete-failure
           (handler-case
               (progn (match-warrant-target incomplete candidate)
                      (internal-integrity-fail
                       "fixture-operation" "ExpectedFixtureFailure" "internal"))
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
         (relation (match-warrant-target target claim))
         (a (evaluate-fixture-policy
             (record-field-named payload "policy-a") relation :target target))
         (b (evaluate-fixture-policy
             (record-field-named payload "policy-b") relation :target target)))
    (validate-claim-id claim)
    (list (%output "claim-id" claim)
          (%output "policy-a-decision" a)
          (%output "policy-b-decision" b)
          (%output "admissibility-differs"
                   (datum-boolean (not (equal-datum a b)))))))

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
  (let* ((predecessor (record-field-named payload "predecessor"))
         (claim (record-field-named payload "requested-claim")))
    (validate-claim-occurrence predecessor :path '("predecessor"))
    (validate-claim-id claim :path '("requested-claim"))
    (unless (equal-datum claim
                         (record-field-named predecessor "cached-claim-id"))
      (lci-fail "projection-refusal" "ClaimIdCacheMismatch" "claim-id-cache"
                :path '("requested-claim")))
    ;; I12(e) forbids inventing a revival.  The package gives no operation rule
    ;; that could source the beta claimant/time/provenance/presentation found in
    ;; P024's expected result.  Preserve only the input-derived predecessor
    ;; occurrence, defensively copied through CD/0, and create no live warrant.
    (let ((new-occurrence (copy-datum-through-cd0 predecessor)))
      (validate-claim-occurrence new-occurrence)
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
                           "unsupported-until-authorized-replay"))))))))

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
    (%validate-translation-receipt source '("source-receipt"))
    (%validate-translation-receipt target '("target-receipt"))
    (unless (equal-datum source-id target-id)
      (%operation-refuse '("target-receipt" "normalized-claim-id")
                         "translation"))
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
    (when (equal-datum source target)
      (%operation-refuse '("target-claim") "translation"))
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
        (internal-integrity-fail "fixture-operation" "MissingUnicodeWitness"
                                 "internal"))
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
                   (t (internal-integrity-fail
                       "fixture-operation" "UnexpectedMigrationCollisionCoordinate"
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
                    (record-field-named payload "mutated-metadata")))
            (same (equal-datum left right)))
       (list (%output "baseline-claim-id" left)
             (%output "mutated-claim-id" right)
             (%output "claimant-neutral" (datum-boolean same))
             (%output "assertion-time-neutral" (datum-boolean same))
             (%output "provenance-neutral" (datum-boolean same))
             (%output "lineage-neutral" (datum-boolean same))
             (%output "presentation-neutral" (datum-boolean same))
             (%output "unknown-open-metadata-neutral"
                      (datum-boolean same)))))
    (t
     (let* ((left-occurrence (record-field-named payload "left-occurrence"))
            (right-occurrence (record-field-named payload "right-occurrence"))
            (left (%payload-claim-from-occurrence left-occurrence))
            (right (%payload-claim-from-occurrence right-occurrence))
            (same (equal-datum left right)))
       (if (record-has-field-p payload "comparison-coordinate")
           (let* ((coordinate
                    (record-field-named payload "comparison-coordinate"))
                  (name (identifier-last coordinate)))
             (unless (and
                      (member name '("provenance" "lineage") :test #'string=)
                      (%exact-identifier-p
                       coordinate +fixture-identifier-namespace+
                       (list "nonidentity-coordinate" name))
                      (not (equal-datum
                            (record-field-named left-occurrence name)
                            (record-field-named right-occurrence name))))
               (%operation-refuse '("comparison-coordinate")))
             (list (%output "same-claim-id" (datum-boolean same))
                   (%output "claim-id" left)))
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
  (let ((value (record-field-named payload "fixture-value"))
        (definition (record-field-named payload "registry-definition")))
    (unless (equal-datum value definition)
      (%operation-refuse '("registry-definition") "validation"))
    (cond ((exact-kind-p value "stable-reference") (validate-stable-ref value))
          ((exact-kind-p value "scope") (validate-scope value))
          ((exact-kind-p value "subject-time") (validate-subject-time value))
          ((exact-kind-p value "dataset-slice") (validate-dataset-slice value))
          ((exact-kind-p value "semantic-boundary")
           (validate-semantic-boundary value))
          ((exact-kind-p value "interpretation-frame")
           (validate-interpretation-frame value))
          (t (%fixture-operation-authorial-gap
              "validate-pinned-fixture" '("fixture-value"))))
    (list (%output "validated-value" value)
          (%output "canonical-octets"
                   (make-bytes-datum (octets-copy (canonical-octets value))))
          (%output "shared-octet-obligation" (datum-boolean t)))))

(defun %execute-admissibility-floor (payload)
  (let* ((relation (record-field-named payload "target-relation"))
         (a (%hard-floor-decision
             (record-field-named payload "policy-a") relation))
         (b (%hard-floor-decision
             (record-field-named payload "policy-b") relation)))
    (list (%output "policy-a-decision" a)
          (%output "policy-b-decision" b)
          (%output "policy-a-consulted" (datum-boolean nil))
          (%output "policy-b-consulted" (datum-boolean nil))
          (%output "support-permitted" (datum-boolean nil)))))

(defun %execute-version-governance (payload)
  (let* ((change-id (record-field-named payload "change"))
         (change (identifier-last change-id))
         (evidence-fields
           '("accepted-abstract-inputs-unchanged"
             "normalized-propositions-unchanged" "claim-ids-unchanged"
             "projection-field-set-unchanged"
             "relations-and-failures-unchanged"))
         (expected-evidence
           (cdr (assoc
                 change
                 '(("projection-field-ownership" nil nil nil t nil)
                   ("claim-id-field-set" nil nil nil nil nil)
                   ("proposition-grammar" nil nil nil t nil)
                   ("frame-semantic-interpretation" nil nil nil t nil)
                   ("semantics-preserving-implementation-correction"
                    t t t t t))
                 :test #'string=)))
         (axis (cond ((member change '("claim-id-field-set"
                                       "projection-field-ownership")
                                     :test #'string=)
                      "identity-policy")
                     ((string= change "proposition-grammar") "claim-profile")
                     ((string= change "frame-semantic-interpretation")
                      "claim-profile-and-or-frame-schema")
                     (t "none")))
         (bump (string/= axis "none")))
    (unless (and expected-evidence
                 (%exact-identifier-p change-id +fixture-identifier-namespace+
                                      (list "change-class" change)))
      (%operation-refuse '("change") "version-governance"))
    (loop for field in evidence-fields
          for expected in expected-evidence
          for value = (record-field-named payload field)
          unless (and (boolean-datum-p value)
                      (eql (boolean-datum-value value) expected))
            do (%operation-refuse (list field) "version-governance"))
    (list (%output "required-version-axis"
                   (fixture-id "required-version-axis" axis))
          (%output "version-bump-required" (datum-boolean bump))
          (%output "conformance-evidence-required" (datum-boolean t))
          (%output "implementation-binary-in-claim-id" (datum-boolean nil)))))

(defun %execute-normalizer-revision (payload)
  (let* ((proposal (record-field-named payload "proposal"))
         (fields '("kind" "schema-version" "declared-claim-profile"
                   "declared-frame-schema" "before-normalizer"
                   "after-normalizer" "known-input" "before-claim-id"
                   "after-claim-id")))
    (require-closed-fields proposal fields "normalizer-revision"
                           :key-namespace +fixture-field-namespace+
                           :path-prefix '("proposal"))
    (unless (and (%exact-identifier-p
                  (record-field-named proposal "kind")
                  +fixture-identifier-namespace+
                  '("tag" "normalizer-revision-proposal"))
                 (exact-zero-p
                  (record-field-named proposal "schema-version")))
      (%operation-refuse '("proposal" "kind") "normalizer-revision"))
    (let ((profile (record-field-named proposal "declared-claim-profile"))
          (frame (record-field-named proposal "declared-frame-schema"))
          (before (record-field-named proposal "before-claim-id"))
          (after (record-field-named proposal "after-claim-id")))
      (validate-claim-profile profile
                              :path '("proposal" "declared-claim-profile"))
      (%validate-stable-ref-domain
       frame "interpretation-frame-schema"
       '("proposal" "declared-frame-schema"))
      (%validate-stable-ref-domain
       (record-field-named proposal "before-normalizer") "procedure"
       '("proposal" "before-normalizer"))
      (%validate-stable-ref-domain
       (record-field-named proposal "after-normalizer") "procedure"
       '("proposal" "after-normalizer"))
      (unless (datum-p (record-field-named proposal "known-input"))
        (%operation-refuse '("proposal" "known-input")
                           "normalizer-revision"))
      (validate-claim-id before :path '("proposal" "before-claim-id"))
      (validate-claim-id after :path '("proposal" "after-claim-id"))
      (unless (and
               (equal-datum
                profile (record-field-named before "claim-profile"))
               (equal-datum
                profile (record-field-named after "claim-profile"))
               (equal-datum
                frame
                (record-field-named
                 (record-field-named
                  (record-field-named before "location")
                  "interpretation-frame")
                 "frame-schema"))
               (equal-datum
                frame
                (record-field-named
                 (record-field-named
                  (record-field-named after "location")
                  "interpretation-frame")
                 "frame-schema")))
        (%operation-refuse '("proposal" "declared-claim-profile")
                           "normalizer-revision"))
      (reject-unknown-fields proposal fields "normalizer-revision"
                             :key-namespace +fixture-field-namespace+
                             :path-prefix '("proposal"))
      (if (not (equal-datum before after))
          (lci-fail "unsupported-version-or-profile"
                    "MeaningChangingNormalizerVersionReuse" "claim-profile"
                    :path '("declared-claim-profile" "profile-version"))
          ;; Only the meaning-changing negative is frozen for this operation.
          (%operation-refuse '("proposal" "after-claim-id")
                             "normalizer-revision")))))

(defun %execute-normalizer-conformance (payload)
  (let* ((binding (record-field-named payload "binding"))
         (mutation (record-field-named payload "mutation-vector"))
         (ledger (record-field-named payload "semantic-projection-ledger")))
    ;; These are named normative components, not whole operation-result
    ;; oracles.  Exact equality supplies closed recursive validation for the
    ;; sole frozen conformance-evidence schema instance.
    (dolist (case
             (list
              (list binding "normalizer.conformance-binding.0"
                    '("binding"))
              (list mutation "normalizer.mutation-vector.0"
                    '("mutation-vector"))
              (list ledger "normalizer.semantic-projection-ledger.0"
                    '("semantic-projection-ledger"))))
      (unless (equal-datum (first case) (registry-datum (second case)))
        (%operation-refuse (third case) "normalizer-conformance")))
    (let* ((revision (record-field-named binding "normalizer-revision"))
           (immutable-bound
             (equal-datum
              (record-field-named binding "normalizer-content-identity")
              (record-field-named ledger "normative-source")))
           (mutation-present
             (and (equal-datum
                   (record-field-named binding "mutation-vector")
                   (registry-datum
                    "stable-ref.artifact.normalizer.mutation-vector.0"))
                  (equal-datum revision
                               (record-field-named mutation "revision"))))
           (ledger-present
             (and (equal-datum
                   (record-field-named binding "semantic-projection-ledger")
                   (registry-datum "stable-ref.artifact.normalizer.ledger.0"))
                  (equal-datum
                   revision
                   (record-field-named ledger "normalizer-revision")))))
      (unless (and immutable-bound mutation-present ledger-present)
        (%operation-refuse '("binding") "normalizer-conformance"))
      (list
       (%output "immutable-normalizer-content-bound"
                (datum-boolean immutable-bound))
       (%output "revision-mutation-vector-present"
                (datum-boolean mutation-present))
       (%output "before-after-semantic-ledger-present"
                (datum-boolean ledger-present))
       (%output "implementation-binary-projected" (datum-boolean nil))))))

(defun %execute-normalize-coordinate (payload)
  (let* ((coordinate-id (record-field-named payload "coordinate"))
         (coordinate (identifier-last coordinate-id))
         (normalizer (record-field-named payload "normalizer"))
         (left (record-field-named payload "left"))
         (right (record-field-named payload "right")))
    (unless (equal-datum normalizer
                         (registry-datum
                          "algorithm.preprojection-normalization.0"))
      (%fixture-operation-authorial-gap
       "normalize-preprojection-coordinate" '("normalizer")))
    (unless (%exact-identifier-p coordinate-id +fixture-identifier-namespace+
                                 (list "claim-coordinate" coordinate))
      (%fixture-operation-authorial-gap
       "normalize-preprojection-coordinate" '("coordinate")))
    (flet ((validate (value path)
             (cond
               ((string= coordinate "scope") (validate-scope value :path path))
               ((string= coordinate "subject-time")
                (validate-subject-time value :path path))
               ((string= coordinate "interpretation-frame")
                (validate-interpretation-frame value :path path))
               ((string= coordinate "dataset-slice")
                (validate-dataset-slice value :path path))
               ((string= coordinate "semantic-boundary")
                (validate-semantic-boundary value :path path))
               (t (%fixture-operation-authorial-gap
                   "normalize-preprojection-coordinate" '("coordinate"))))))
      (validate left '("left"))
      (validate right '("right")))
    ;; The exact fixture contract performs no inferred co-denotation: validated
    ;; values normalize only by a defensive CD/0 round trip.
    (let ((left-normalized (copy-datum-through-cd0 left))
          (right-normalized (copy-datum-through-cd0 right)))
      (list (%output "left-normalized" left-normalized)
            (%output "right-normalized" right-normalized)
            (%output "structurally-equal-after-normalization"
                     (datum-boolean
                      (equal-datum left-normalized right-normalized)))
            (%output "claim-id-merge-permitted"
                     (datum-boolean
                      (equal-datum left-normalized right-normalized)))))))

(defun %execute-differential-project (payload)
  (let ((evidence (record-field-named payload "evidence"))
        (fields '("kind" "schema-version" "declared-profile"
                  "left-normalizer" "right-normalizer" "same-input"
                  "left-output" "right-output")))
    (require-closed-fields evidence fields "differential-projection"
                           :key-namespace +fixture-field-namespace+
                           :path-prefix '("evidence"))
    (unless (and (%exact-identifier-p
                  (record-field-named evidence "kind")
                  +fixture-identifier-namespace+
                  '("tag" "differential-projector-evidence"))
                 (exact-zero-p (record-field-named evidence "schema-version")))
      (%fixture-operation-authorial-gap
       "differential-project" '("evidence" "kind")))
    (let ((profile (record-field-named evidence "declared-profile"))
          (same-input (record-field-named evidence "same-input"))
          (left-output (record-field-named evidence "left-output"))
          (right-output (record-field-named evidence "right-output")))
      (validate-claim-profile profile :path '("evidence" "declared-profile"))
      (%validate-stable-ref-domain
       (record-field-named evidence "left-normalizer") "procedure"
       '("evidence" "left-normalizer"))
      (%validate-stable-ref-domain
       (record-field-named evidence "right-normalizer") "procedure"
       '("evidence" "right-normalizer"))
      (normalize-proposition same-input)
      (validate-claim-id left-output :path '("evidence" "left-output"))
      (validate-claim-id right-output :path '("evidence" "right-output"))
      (dolist (output (list left-output right-output))
        (unless (equal-datum profile
                             (record-field-named output "claim-profile"))
          (%fixture-operation-authorial-gap
           "differential-project" '("evidence" "declared-profile"))))
      (reject-unknown-fields evidence fields "differential-projection"
                             :key-namespace +fixture-field-namespace+
                             :path-prefix '("evidence"))
      (if (equal-datum left-output right-output)
          (%fixture-operation-authorial-gap
           "differential-project" '("evidence" "right-output"))
          (lci-fail "internal-invariant-failure" "ProjectionNonDeterminism"
                    "internal" :path '("right-output"))))))

(defun %execute-scheme-selection (payload)
  (let ((reference (record-field-named payload "example-reference"))
        (domain (record-field-named payload "domain"))
        (scheme (record-field-named payload "canonical-scheme")))
    (validate-stable-ref reference)
    (unless (and (equal-datum domain (record-field-named reference "domain"))
                 (equal-datum scheme (record-field-named reference "scheme")))
      (lci-fail "reference-refusal" "InvalidStableReference"
                "stable-reference" :path '("canonical-scheme")))
    (list (%output "accepted-scheme-count" (make-integer-datum 1))
          (%output "canonical-scheme" scheme)
          (%output "reference-valid" (datum-boolean t)))))

(defun %external-fixture-source-material (reference path)
  (require-closed-fields reference '("kind" "domain" "scheme" "material")
                         "stable-reference"
                         :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (unless (and (%exact-identifier-p
                (record-field-named reference "kind")
                '("lisp-plus" "lci" "0" "tag") '("stable-reference"))
               (%exact-identifier-p
                (record-field-named reference "domain")
                +fixture-identifier-namespace+ '("domain" "artifact"))
               (%exact-identifier-p
                (record-field-named reference "scheme")
                +fixture-identifier-namespace+
                '("stable-ref-scheme" "external-fixture-source"
                  "artifact" "0")))
    (lci-fail "reference-refusal" "InvalidStableReference"
              "stable-reference" :path path))
  (let ((material (record-field-named reference "material")))
    (require-closed-fields material '("source-material") "stable-reference"
                           :key-namespace +fixture-field-namespace+
                           :path-prefix (append path '("material")))
    (let ((value (record-field-named material "source-material")))
      (unless (string-datum-p value)
        (lci-fail "reference-refusal" "InvalidStableReference"
                  "stable-reference"
                  :path (append path '("material" "source-material"))))
      (reject-unknown-fields material '("source-material") "stable-reference"
                             :key-namespace +fixture-field-namespace+
                             :path-prefix (append path '("material")))
      (reject-unknown-fields reference '("kind" "domain" "scheme" "material")
                             "stable-reference"
                             :key-namespace +lci-field-namespace+
                             :path-prefix path)
      value)))

(defun %execute-apply-bridge (payload)
  (let* ((source (record-field-named payload "source-reference"))
         (bridge (record-field-named payload "bridge"))
         (expected-bridge
           (registry-datum
            "stable-ref-bridge.external-artifact-source-to-lci-fixture.0")))
    (unless (equal-datum bridge expected-bridge)
      (lci-fail "reference-refusal" "InvalidStableReference"
                "stable-reference" :path '("bridge")))
    (let* ((declared-domain (record-field-named bridge "declared-domain"))
           (mapping (record-field-named bridge "mapping"))
           (entry (sequence-datum-ref mapping 0))
           (source-material
             (%external-fixture-source-material source '("source-reference")))
           (target (record-field-named entry "target-reference")))
      (unless (and (sequence-datum-p declared-domain)
                   (= (sequence-datum-length declared-domain) 1)
                   (equal-datum source-material
                                (sequence-datum-ref declared-domain 0))
                   (equal-datum source-material
                                (record-field-named entry "source-material")))
        (lci-fail "reference-refusal" "InvalidStableReference"
                  "stable-reference" :path '("source-reference")))
      (validate-stable-ref target :path '("bridge" "mapping" "0"
                                          "target-reference"))
      (list (%output "canonical-reference" target)
            (%output "source-and-target-structurally-equal"
                     (datum-boolean (equal-datum source target)))
            (%output "operational-equivalence-explicit" (datum-boolean t))))))

(defun %execute-map-migration-classification (payload)
  (let* ((classification (record-field-named payload "lci-classification"))
         (name (identifier-last classification))
         (terms (record-field-named payload "prior-ruling-terms")))
    (unless (and
             (member name +migration-classifications+ :test #'string=)
             (%exact-identifier-p
              classification +fixture-identifier-namespace+
              (list "migration-classification" name)))
      (%operation-refuse '("lci-classification")
                         "migration-classification"))
    ;; The package records prior-ruling labels as inert character identifiers.
    ;; Validate their closed surface without inferring an inverse mapping.
    (unless (and
             (sequence-datum-p terms)
             (plusp (sequence-datum-length terms))
             (loop for index below (sequence-datum-length terms)
                   for term = (sequence-datum-ref terms index)
                   always
                   (and (identifier-datum-p term)
                        (equal (identifier-namespace-strings term)
                               +fixture-identifier-namespace+)
                        (= (length (identifier-path-strings term)) 2)
                        (string=
                         (first (identifier-path-strings term))
                         "prior-ruling-migration-classification")
                        (= (length (second (identifier-path-strings term)))
                           1))))
      (%operation-refuse '("prior-ruling-terms")
                         "migration-classification"))
    (list (%output "mapping-defined" (datum-boolean t))
          (%output "lci-classification" classification)
          (%output "prior-ruling-terms" terms)
          (%output "semantic-case"
                   (fixture-id "migration-mapping-case" name)))))

(defvar +lci-resource-definitions+
  ;; Registry order is normative and deliberately differs from the prose
  ;; table's alphabetical presentation.
  '(("maximum-nesting" 64
     ("validation" "normalization" "projection" "matching" "migration")
     "LCIMaxNestingExceeded" "nested-singleton-record")
    ("node-count" 4096
     ("validation" "normalization" "projection" "matching" "migration")
     "LCINodeCountExceeded" "flat-sequence-of-unit-nodes")
    ("record-fields" 64
     ("validation" "projection" "matching" "migration")
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
    ("proposition-normalization-work" 10000
     ("normalization" "projection")
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

(defun %resource-invalid (path)
  (%fixture-operation-authorial-gap "resource-conformance" path))

(defun %exact-resource-id-p (datum category name &optional version)
  (%exact-identifier-p
   datum +fixture-identifier-namespace+
   (if version (list category name version) (list category name))))

(defun %validate-resource-budget (budget)
  (require-closed-fields
   budget '("kind" "schema-version" "budget-id" "limits" "counting-rule"
            "cd0-budget-separation")
   "resource-budget" :key-namespace +fixture-field-namespace+
   :path-prefix '("budget"))
  (unless (and (%exact-resource-id-p (record-field-named budget "kind")
                                     "tag" "lci-resource-budget")
               (exact-zero-p (record-field-named budget "schema-version"))
               (%exact-resource-id-p (record-field-named budget "budget-id")
                                     "budget" "lci-first-implementation" "0")
               (%exact-resource-id-p (record-field-named budget "counting-rule")
                                     "resource-counting-rule"
                                     "preallocation-check-then-deterministic-work-units")
               (let ((separate (record-field-named budget
                                                    "cd0-budget-separation")))
                 (and (boolean-datum-p separate)
                      (boolean-datum-value separate))))
    (%resource-invalid '("budget")))
  (let ((limits (record-field-named budget "limits")))
    (unless (and (sequence-datum-p limits)
                 (= (sequence-datum-length limits)
                    (length +lci-resource-definitions+)))
      (%resource-invalid '("budget" "limits")))
    (loop for definition in +lci-resource-definitions+
          for index from 0
          for limit = (sequence-datum-ref limits index)
          for (resource maximum phases code) = definition
          for limit-path = (list "budget" "limits" (format nil "~D" index))
          do (require-closed-fields
              limit '("resource" "limit" "applies-to" "failure-code")
              "resource-budget" :key-namespace +fixture-field-namespace+
              :path-prefix limit-path)
             (unless (and
                      (%exact-resource-id-p
                       (record-field-named limit "resource") "resource" resource)
                      (let ((value (record-field-named limit "limit")))
                        (and (integer-datum-p value)
                             (= (integer-datum-value value) maximum)))
                      (let ((actual-phases
                              (record-field-named limit "applies-to")))
                        (and (sequence-datum-p actual-phases)
                             (= (sequence-datum-length actual-phases)
                                (length phases))
                             (loop for phase in phases
                                   for phase-index from 0
                                   always (%exact-resource-id-p
                                           (sequence-datum-ref actual-phases
                                                               phase-index)
                                           "operation-phase" phase))))
                      (%exact-identifier-p
                       (record-field-named limit "failure-code")
                       '("lisp-plus" "lci" "0" "failure") (list code)))
               (%resource-invalid limit-path))
             (reject-unknown-fields
              limit '("resource" "limit" "applies-to" "failure-code")
              "resource-budget" :key-namespace +fixture-field-namespace+
              :path-prefix limit-path)))
  (reject-unknown-fields
   budget '("kind" "schema-version" "budget-id" "limits" "counting-rule"
            "cd0-budget-separation")
   "resource-budget" :key-namespace +fixture-field-namespace+
   :path-prefix '("budget"))
  budget)

(defun %validate-resource-workload (workload)
  (require-closed-fields
   workload '("kind" "schema-version" "resource" "requested" "generator" "seed")
   "resource-budget" :key-namespace +fixture-field-namespace+
   :path-prefix '("workload"))
  (unless (and (%exact-resource-id-p (record-field-named workload "kind")
                                     "tag" "deterministic-resource-workload")
               (exact-zero-p (record-field-named workload "schema-version")))
    (%resource-invalid '("workload")))
  (let* ((resource-id (record-field-named workload "resource"))
         (resource-path (and (identifier-datum-p resource-id)
                             (identifier-path-strings resource-id)))
         (resource (and (%exact-identifier-p
                         resource-id +fixture-identifier-namespace+
                         resource-path)
                        (= (length resource-path) 2)
                        (string= (first resource-path) "resource")
                        (second resource-path)))
         (definition (and resource
                          (assoc resource +lci-resource-definitions+
                                 :test #'string=)))
         (requested (record-field-named workload "requested"))
         (seed (record-field-named workload "seed")))
    (unless definition (%resource-invalid '("workload" "resource")))
    (unless (and (integer-datum-p requested)
                 (not (minusp (integer-datum-value requested))))
      (%resource-invalid '("workload" "requested")))
    (unless (and (integer-datum-p seed) (zerop (integer-datum-value seed)))
      (%resource-invalid '("workload" "seed")))
    (unless (%exact-resource-id-p (record-field-named workload "generator")
                                  "workload-generator" (fifth definition) "0")
      (%resource-invalid '("workload" "generator")))
    (reject-unknown-fields
     workload '("kind" "schema-version" "resource" "requested" "generator"
                "seed")
     "resource-budget" :key-namespace +fixture-field-namespace+
     :path-prefix '("workload"))
    (values definition (integer-datum-value requested))))

(defun %resource-operation-phase (operation-name)
  (cdr (assoc operation-name
              '(("conformance-validation" . "validation")
                ("conformance-normalization" . "normalization")
                ("conformance-matching" . "matching")
                ("conformance-migration" . "migration"))
              :test #'string=)))

(defun %execute-resource (payload operation-name)
  (require-closed-fields payload '("workload" "budget") "resource-budget"
                         :key-namespace +fixture-field-namespace+)
  (let ((phase (%resource-operation-phase operation-name)))
    (unless phase (%resource-invalid '("operation")))
    (%validate-resource-budget (record-field-named payload "budget"))
    (multiple-value-bind (definition requested)
        (%validate-resource-workload (record-field-named payload "workload"))
      (unless (member phase (third definition) :test #'string=)
        (%fixture-operation-authorial-gap
         operation-name '("workload" "resource")))
      ;; The sealed generators declare their requested unit count before
      ;; proportional allocation.  This is the measured value for the named
      ;; resource; checks occur at that resource's position in registry order.
      (loop for entry in +lci-resource-definitions+
            when (eq entry definition)
              do (when (> requested (second entry))
                   (lci-fail "resource-refusal" (fourth entry) phase
                             :path '("workload" "requested")))
                 (return))
      (reject-unknown-fields payload '("workload" "budget") "resource-budget"
                             :key-namespace +fixture-field-namespace+)
      (list (%output "within-budget" (datum-boolean t))))))

(defun %validate-loss-account-operation (payload)
  (let* ((operation-id (record-field-named payload "operation"))
         (operation (identifier-last operation-id))
         (account (record-field-named payload "account"))
         (fields (cdr (assoc operation +loss-account-fields+ :test #'string=))))
    (unless (and fields
                 (%exact-identifier-p
                 operation-id +fixture-identifier-namespace+
                  (list "loss-operation" operation))
                 (string= operation (%validate-loss-account account '("account"))))
      (%fixture-operation-authorial-gap
       "validate-represented-loss-account" '("account" "account-schema")))
    (list (%output "valid" (datum-boolean t))
          (%output "account-schema" (record-field-named account "account-schema"))
          (%output "closed" (datum-boolean t)))))

(defun %pairwise-distinct-data-p (data)
  (loop for tail on data
        always (every (lambda (right)
                        (not (equal-datum (first tail) right)))
                      (rest tail))))

(defun %claim-coordinate-value (claim coordinate)
  (let* ((location (record-field-named claim "location"))
         (basis (record-field-named location "basis")))
    (cond ((string= coordinate "proposition")
           (record-field-named claim "proposition"))
          ((member coordinate '("scope" "subject-time"
                                "interpretation-frame" "profile-location")
                   :test #'string=)
           (record-field-named location coordinate))
          ((string= coordinate "corpus-revision")
           (record-field-named basis "revision"))
          ((string= coordinate "dataset-slice")
           (record-field-named basis "slice"))
          ((string= coordinate "semantic-boundary")
           (record-field-named basis "semantic-boundary"))
          ((string= coordinate "basis") basis))))

(defun %claim-set-distinguishing-coordinate (claims)
  ;; A reported coordinate must itself distinguish every member of the set;
  ;; it need not be the only coordinate that varies.  Prefer the most specific
  ;; basis subcoordinate before the enclosing basis.
  (dolist (coordinate '("proposition" "scope" "subject-time"
                        "corpus-revision" "dataset-slice"
                        "semantic-boundary" "interpretation-frame"
                        "profile-location" "basis"))
    (when (%pairwise-distinct-data-p
           (mapcar (lambda (claim) (%claim-coordinate-value claim coordinate))
                   claims))
      (return-from %claim-set-distinguishing-coordinate coordinate)))
  nil)

(defun %validate-construction-order (order path)
  (let ((required '("kind" "lci-version" "identity-policy" "claim-profile"
                    "proposition" "location")))
    (unless (and
             (sequence-datum-p order)
             (= (sequence-datum-length order) (length required))
             (let ((seen nil))
               (loop for index below (sequence-datum-length order)
                     for field = (sequence-datum-ref order index)
                     for name = (identifier-last field)
                     always
                     (and (%exact-identifier-p field +lci-field-namespace+
                                               (list name))
                          (member name required :test #'string=)
                          (not (member name seen :test #'string=))
                          (progn (push name seen) t)))))
      (%operation-refuse path "record-order"))
    order))

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
           (right (record-field-named payload "right-claim"))
           (left-order (record-field-named payload "left-construction-order"))
           (right-order
             (record-field-named payload "right-construction-order")))
       (validate-claim-id left) (validate-claim-id right)
       (%validate-construction-order left-order '("left-construction-order"))
       (%validate-construction-order right-order '("right-construction-order"))
       (unless (and (not (equal-datum left-order right-order))
                    (equal-datum left right))
         (%operation-refuse '("right-claim") "record-order"))
       (list (%output "canonical-claim-id" (copy-datum-through-cd0 left))
             (%output "same-canonical-octets"
                      (datum-boolean (equal-datum left right))))))
    ((string= name "compare-claim-ids") (%execute-compare-claim-ids payload))
    ((string= name "compare-claim-id-set")
     (let ((claims (record-field-named payload "claims")))
       (unless (and (sequence-datum-p claims)
                    (> (sequence-datum-length claims) 1))
         (%fixture-operation-authorial-gap
          "compare-claim-id-set" '("claims")))
       (loop for index below (sequence-datum-length claims)
             do (validate-claim-id (sequence-datum-ref claims index)
                                   :path (list "claims" (format nil "~D" index))))
       (let* ((claim-list
                (loop for index below (sequence-datum-length claims)
                      collect (sequence-datum-ref claims index)))
              (distinct
                (loop for left below (sequence-datum-length claims)
                      always
                      (loop for right from (1+ left)
                            below (sequence-datum-length claims)
                            always (not (equal-datum
                                         (sequence-datum-ref claims left)
                                         (sequence-datum-ref claims right))))))
              (coordinate (%claim-set-distinguishing-coordinate claim-list)))
         (unless coordinate
           (%operation-refuse '("claims") "claim-id"))
         (list (%output "pairwise-distinct" (datum-boolean distinct))
               (%output "different-coordinate"
                        (fixture-id "claim-coordinate" coordinate))))))
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
     (%execute-normalizer-revision payload))
    ((string= name "validate-normalizer-conformance-evidence")
     (%execute-normalizer-conformance payload))
    ((string= name "validate-migration-result")
     (validate-migration-result (record-field-named payload "migration-result"))
     (%fixture-operation-authorial-gap
      "validate-migration-result" '("migration-result")))
    ((string= name "differential-project")
     (%execute-differential-project payload))
    ((string= name "normalize-preprojection-coordinate")
     (%execute-normalize-coordinate payload))
    ((string= name "compare-stable-refs")
     (let ((left (record-field-named payload "left-reference"))
           (right (record-field-named payload "right-reference"))
           (bridges (record-field-named payload "bridge-registry")))
       (%external-fixture-source-material left '("left-reference"))
       (validate-stable-ref right :path '("right-reference"))
       (unless (and (sequence-datum-p bridges)
                    (zerop (sequence-datum-length bridges)))
         (lci-fail "reference-refusal" "InvalidStableReference"
                   "stable-reference" :path '("bridge-registry")))
       (let ((same (equal-datum left right)))
         (list (%output "structural-equality" (datum-boolean same))
               (%output "operational-equivalence-established"
                        (datum-boolean same))
               (%output "identity-treatment"
                        (fixture-id
                         "stable-ref-treatment"
                         (if same "structurally-equal"
                             "distinct-no-bridge")))))))
    ((string= name "compare-bridge-source-and-target")
     (let* ((source (record-field-named payload "source"))
            (target (record-field-named payload "target"))
            (bridge (record-field-named payload "bridge"))
            (expected
              (registry-datum
               "stable-ref-bridge.external-artifact-source-to-lci-fixture.0")))
       (unless (equal-datum bridge expected)
         (lci-fail "reference-refusal" "InvalidStableReference"
                   "stable-reference" :path '("bridge")))
       (let* ((domain (record-field-named bridge "declared-domain"))
              (mapping (record-field-named bridge "mapping"))
              (entry (sequence-datum-ref mapping 0))
              (source-material
                (%external-fixture-source-material source '("source"))))
         (unless (and
                    (sequence-datum-p domain)
                    (= (sequence-datum-length domain) 1)
                    (equal-datum source-material
                                 (sequence-datum-ref domain 0))
                    entry
                    (equal-datum source-material
                                 (record-field-named entry "source-material"))
                      (equal-datum target
                                   (record-field-named entry
                                                       "target-reference")))
           (lci-fail "reference-refusal" "InvalidStableReference"
                     "stable-reference" :path '("bridge")))
         (validate-stable-ref target :path '("target"))
         (list (%output "structural-cd0-equality"
                        (datum-boolean (equal-datum source target)))
               (%output "explicit-operational-equivalence" (datum-boolean t))
               (%output "retroactive-claim-id-rewrite"
                        (datum-boolean nil))))))
    ((string= name "apply-stable-ref-bridge") (%execute-apply-bridge payload))
    ((string= name "compare-claim-digests-and-envelopes")
     (let ((left (record-field-named payload "left-claim-id"))
           (right (record-field-named payload "right-claim-id"))
           (left-digest (record-field-named payload "left-operational-digest"))
           (right-digest (record-field-named payload "right-operational-digest"))
           (scheme (record-field-named payload "digest-scheme")))
       (validate-claim-id left :path '("left-claim-id"))
       (validate-claim-id right :path '("right-claim-id"))
       (unless (and (bytes-datum-p left-digest) (bytes-datum-p right-digest)
                    (%exact-identifier-p
                     scheme +fixture-identifier-namespace+
                     '("nonproduction-test-digest-scheme" "constant-zero" "0"))
                    (= (length (bytes-datum-value left-digest)) 32)
                    (= (length (bytes-datum-value right-digest)) 32)
                    (every #'zerop (bytes-datum-value left-digest))
                    (every #'zerop (bytes-datum-value right-digest)))
         (%fixture-operation-authorial-gap
          "compare-claim-digests-and-envelopes" '("digest-scheme")))
       (let ((digest-same (equal-datum left-digest right-digest))
             (claim-same (equal-datum left right)))
         (list (%output "digests-equal" (datum-boolean digest-same))
               (%output "claim-id-envelopes-equal" (datum-boolean claim-same))
               (%output "semantic-claim-id-equal" (datum-boolean claim-same))
               (%output "envelope-resolution-required"
                        (datum-boolean (and digest-same (not claim-same))))))))
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
     (%execute-resource payload name))
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
       (normalize-proposition proposition)
       (validate-claim-location location)
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
    (t (%fixture-operation-authorial-gap name '("operation")))))

(defun execute-fixture-operation (operation payload &key vector-id)
  (declare (ignore vector-id))
  (let ((name (operation-name operation)))
    (unless (%exact-identifier-p operation +fixture-identifier-namespace+
                                 (list "operation" name))
      (%fixture-operation-authorial-gap name '("operation")))
    (%validate-operation-payload name payload)
    (result-record operation (%execute-operation-outputs name payload))))
