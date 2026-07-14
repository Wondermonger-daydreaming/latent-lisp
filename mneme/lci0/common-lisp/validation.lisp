(in-package #:lisp-plus-lci0)

(defparameter +stable-ref-domains+
  '("scope-calculus" "temporal-model" "dataset-slice-calculus"
    "semantic-boundary-calculus" "interpretation-frame-schema"
    "logical-corpus" "immutable-corpus-revision" "module" "procedure"
    "model" "prompt-invocation" "artifact" "principal" "policy"))

(defparameter +proposition-arguments+
  '(("artifact-contains-says" "artifact" "content" "scope-locator"
     "subject-time-locator" "basis-locator" "frame-locator")
    ("average-statistical-value" "measure" "expected" "unit"
     "population-domain" "subject-time-locator" "basis-locator" "frame-locator")
    ("bounded-corpus-absence" "query" "scope-locator" "subject-time-locator"
     "corpus-locator" "dataset-slice-locator" "semantic-boundary-locator"
     "frame-locator")
    ("call-result-equality" "procedure" "input" "expected" "scope-locator"
     "subject-time-locator" "basis-locator" "frame-locator")
    ("exact-equality" "left" "right" "scope-locator" "subject-time-locator"
     "basis-locator" "frame-locator")
    ("existential-property" "predicate" "quantified-domain"
     "subject-time-locator" "basis-locator" "frame-locator")
    ("file-exists" "artifact" "scope-locator" "subject-time-locator"
     "basis-locator" "frame-locator")
    ("probabilistic-claim" "embedded-proposition" "probability"
     "uncertainty-model" "scope-locator" "subject-time-locator"
     "basis-locator" "frame-locator")
    ("producer-returned-value" "producer" "invocation" "value"
     "scope-locator" "subject-time-locator" "basis-locator" "frame-locator")
    ("translation-ambiguity" "source-text" "source-language" "target-language"
     "candidate-readings" "ambiguity-mode" "scope-locator"
     "subject-time-locator" "basis-locator" "frame-locator")
    ("universal-property-over-scope" "predicate" "quantified-domain"
     "subject-time-locator" "basis-locator" "frame-locator")))

(defparameter +target-boundary-fields+
  '(("observed" "observer-or-instrument" "observation-procedure"
     "observation-time" "coverage-scope" "observation-mode"
     "observation-artifact-or-event")
    ("executed" "procedure-reference" "immutable-code-or-semantics" "invocation"
     "execution-environment-semantics" "execution-time"
     "execution-event-or-trace" "coverage-scope")
    ("tested" "system-or-procedure-under-test" "immutable-tested-version"
     "test-case-or-suite" "test-input" "expected-relation"
     "execution-environment-semantics" "execution-time" "test-event-or-trace"
     "coverage-scope")
    ("derived" "inference-calculus" "premise-claim-ids"
     "rule-or-derivation-identity" "derivation-artifact-or-trace"
     "coverage-scope")
    ("externally-attested" "external-principal" "external-statement-or-artifact"
     "attestation-time" "mapping-receipt" "coverage-scope")
    ("replayed" "predecessor-warrant-testimony-or-event" "replay-procedure"
     "immutable-code-or-semantics" "replay-invocation"
     "execution-environment-semantics" "replay-time"
     "new-replay-trace-or-result" "coverage-scope")
    ("corpus-completion" "exact-corpus-basis" "search-procedure"
     "immutable-code-or-semantics" "query-or-search-expression" "coverage-plan"
     "completion-boundary" "execution-time" "completion-receipt-or-trace"
     "coverage-scope")
    ("reported" "reporter-or-source-principal" "source-artifact" "report-time"
     "content-to-claim-interpretation-receipt" "coverage-scope")
    ("inherited" "predecessor-occurrence-or-artifact"
     "predecessor-warrant-testimony" "inheritance-or-handoff-rule"
     "handoff-freeze-revival-receipt" "represented-loss" "coverage-scope")
    ("translated" "source-claim-id" "source-interpretation-frame"
     "target-interpretation-frame" "translation-procedure" "translation-receipt"
     "represented-loss" "coverage-scope")
    ("policy-evaluation" "policy" "evaluated-warrant" "state-snapshot"
     "query-time" "testimony-mode" "inner-target-relation" "coverage-scope")))

(defparameter +loss-account-fields+
  '(("v1-migration" "kind" "schema-version" "account-schema" "source-format"
     "adapter" "recovered-dimensions" "unresolved-dimensions"
     "mapping-receipts" "classification")
    ("translation" "kind" "schema-version" "account-schema" "source-language"
     "target-language" "lost-features" "preserved-features"
     "ambiguity-resolved" "translation-receipt")
    ("reconstruction" "kind" "schema-version" "account-schema"
     "source-fragments" "recovered-fields" "unresolved-fields"
     "reconstruction-procedure" "confidence-class")
    ("compaction" "kind" "schema-version" "account-schema"
     "removed-metadata-fields" "retained-identity-fields" "reversible"
     "compaction-procedure")
    ("identifier-mapping" "kind" "schema-version" "account-schema"
     "source-identifier" "mapped-identifier" "mapping-table" "mapping-class"
     "candidate-count")
    ("temporal-role-classification" "kind" "schema-version" "account-schema"
     "source-site" "source-value" "selected-role" "classification-table"
     "ambiguity-class")
    ("handoff" "kind" "schema-version" "account-schema"
     "predecessor-occurrence" "handoff-receipt" "live-authority-transferred"
     "custody-continuity-proven" "successor-live-warrants"
     "handoff-procedure")))

(defun validate-stable-ref (reference &key (path nil))
  (require-closed-fields reference '("kind" "domain" "scheme" "material")
                         "stable-reference" :path-prefix path)
  (unless (exact-kind-p reference "stable-reference")
    (lci-fail "reference-refusal" "InvalidStableReference" "stable-reference"
              :path path))
  (let* ((domain (record-field-named reference "domain"))
         (scheme (record-field-named reference "scheme"))
         (material (record-field-named reference "material"))
         (domain-name (identifier-last domain)))
    (unless (and (identifier-datum-p domain)
                 (member domain-name +stable-ref-domains+ :test #'string=))
      (lci-fail "reference-refusal" "UnsupportedReferenceDomain"
                "stable-reference" :path (append path '("domain"))))
    (unless (and (identifier-datum-p scheme)
                 (equal (identifier-path-strings scheme)
                        (list "scheme" domain-name "structural" "0")))
      (lci-fail "reference-refusal" "UnsupportedReferenceScheme"
                "stable-reference" :path (append path '("scheme"))))
    (require-closed-fields material
                           '("kind" "schema-version" "object-id" "object-version")
                           "stable-reference" :path-prefix (append path '("material")))
    (unless (and (exact-kind-p material "fixture-stable-material")
                 (exact-zero-p (record-field-named material "schema-version"))
                 (identifier-datum-p (record-field-named material "object-id"))
                 (integer-datum-p (record-field-named material "object-version"))
                 (not (minusp (integer-datum-value
                               (record-field-named material "object-version")))))
      (lci-fail "reference-refusal" "InvalidStableReference"
                "stable-reference" :path (append path '("material"))))
    (let* ((object-id (record-field-named material "object-id"))
           (segments (identifier-path-strings object-id)))
      (when (some (lambda (segment)
                    (member segment '("latest" "main") :test #'string-equal))
                  segments)
        (lci-fail "reference-refusal" "UnresolvedAlias" "stable-reference"
                  :path (if path path '("material" "object-id")))))
    (make-lci-value :stable-ref reference)))

(defun validate-identity-policy (policy &key (path '("identity-policy")))
  (require-closed-fields policy '("kind" "policy-id" "policy-version")
                         "identity-policy" :path-prefix path)
  (unless (and (exact-kind-p policy "identity-policy")
               (let ((id (record-field-named policy "policy-id")))
                 (and (identifier-datum-p id)
                      (equal (identifier-namespace-strings id)
                             '("lisp-plus" "lci"))
                      (equal (identifier-path-strings id)
                             '("located-claim-identity"))))
               (exact-zero-p (record-field-named policy "policy-version")))
    (lci-fail "unsupported-version-or-profile" "UnsupportedIdentityPolicy"
              "identity-policy" :path (append path '("policy-version"))))
  (make-lci-value :identity-policy policy))

(defun validate-claim-profile (profile &key (path '("claim-profile")))
  (require-closed-fields profile '("kind" "profile-id" "profile-version")
                         "claim-profile" :path-prefix path)
  (unless (and (exact-kind-p profile "claim-profile")
               (let ((id (record-field-named profile "profile-id")))
                 (and (identifier-datum-p id)
                      (equal (identifier-namespace-strings id)
                             '("lisp-plus" "mneme"))
                      (equal (identifier-path-strings id) '("located-claim"))))
               (exact-zero-p (record-field-named profile "profile-version")))
    (lci-fail "unsupported-version-or-profile" "UnsupportedClaimProfile"
              "claim-profile" :path (append path '("profile-version"))))
  (make-lci-value :claim-profile profile))

(defun %validate-versioned-expression (expression form-fields code stage path)
  (require-record expression code stage path)
  (let* ((form (exact-form-name expression))
         (entry (assoc form form-fields :test #'string=))
         (fields (cdr entry)))
    (unless entry (lci-fail "invalid-input" code stage :path path))
    (require-closed-fields expression (cons "kind" (cons "schema-version"
                                                          (cons "form" fields)))
                           stage :path-prefix path)
    (unless (exact-zero-p (record-field-named expression "schema-version"))
      (lci-fail "unsupported-version-or-profile"
                "RecursiveUnsupportedNestedVersion" stage
                :path (append path '("schema-version"))))
    expression))

(defparameter +scope-form-fields+
  '(("universal") ("organization" "organization")
    ("department" "organization" "department")
    ("tenant" "organization" "tenant") ("region-set" "members")
    ("symbolic-predicate" "symbol" "known-proper-subset")
    ("opaque-token" "token")))

(defun validate-scope (scope &key (path '("scope")))
  (require-closed-fields scope '("kind" "schema-version" "calculus" "expression")
                         "scope" :path-prefix path)
  (unless (exact-zero-p (record-field-named scope "schema-version"))
    (lci-fail "unsupported-version-or-profile" "RecursiveUnsupportedNestedVersion"
              "scope" :path (append path '("schema-version"))))
  (validate-stable-ref (record-field-named scope "calculus")
                       :path (append path '("calculus")))
  (handler-case
      (%validate-versioned-expression (record-field-named scope "expression")
                                      +scope-form-fields+ "InvalidScope" "scope"
                                      (append path '("expression")))
    (lci-failure (condition)
      ;; A malformed scope expression is one closed InvalidScope witness.  A
      ;; nested version refusal remains separately governed by Errata 0.1.
      (if (member (lci-failure-code condition)
                  '("MissingRequiredField" "UnknownField") :test #'string=)
          (lci-fail "invalid-input" "InvalidScope" "scope"
                    :path (append path '("expression")))
          (error condition))))
  (make-lci-value :scope scope))

(defparameter +temporal-form-fields+
  '(("atemporal") ("instant" "tick")
    ("interval" "start" "end" "start-closed" "end-closed")
    ("periodic-set" "modulus" "remainder") ("symbolic" "symbol")
    ("opaque-token" "token") ("relative" "token")))

(defun validate-subject-time (time &key (path '("subject-time"))
                                      (allow-relative nil))
  (when (unit-datum-p time)
    (lci-fail "invalid-input" "UnexpectedUnit" "subject-time" :path path))
  (require-closed-fields time
                         '("kind" "schema-version" "temporal-model" "expression")
                         "subject-time" :path-prefix path)
  (unless (exact-zero-p (record-field-named time "schema-version"))
    (lci-fail "unsupported-version-or-profile" "RecursiveUnsupportedNestedVersion"
              "subject-time" :path (append path '("schema-version"))))
  (validate-stable-ref (record-field-named time "temporal-model")
                       :path (append path '("temporal-model")))
  (let ((expression (%validate-versioned-expression
                     (record-field-named time "expression")
                     +temporal-form-fields+ "InvalidSubjectTime" "subject-time"
                     (append path '("expression")))))
    (when (and (string= (exact-form-name expression) "relative")
               (not allow-relative))
      (lci-fail "projection-refusal" "UnresolvedRelativeTime" "subject-time"
                :path (append path '("expression")))))
  (make-lci-value :subject-time time))

(defparameter +slice-form-fields+
  '(("all-members") ("explicit-members" "members")
    ("predicate" "predicate" "argument" "evaluation-domain")))

(defparameter +boundary-form-fields+
  '(("not-applicable") ("snapshot-manifest" "manifest")
    ("path-root" "path" "path-semantics")
    ("log-horizon" "stream" "horizon")))

(defun validate-dataset-slice (slice &key (path '("slice")))
  (require-closed-fields slice '("kind" "schema-version" "calculus" "expression")
                         "basis" :path-prefix path)
  (validate-stable-ref (record-field-named slice "calculus")
                       :path (append path '("calculus")))
  (%validate-versioned-expression (record-field-named slice "expression")
                                  +slice-form-fields+ "InvalidDatasetSlice" "basis"
                                  (append path '("expression")))
  (make-lci-value :dataset-slice slice))

(defun validate-semantic-boundary (boundary &key (path '("semantic-boundary")))
  (require-closed-fields boundary '("kind" "schema-version" "calculus" "expression")
                         "basis" :path-prefix path)
  (validate-stable-ref (record-field-named boundary "calculus")
                       :path (append path '("calculus")))
  (%validate-versioned-expression (record-field-named boundary "expression")
                                  +boundary-form-fields+ "InvalidSemanticBoundary"
                                  "basis" (append path '("expression")))
  (make-lci-value :semantic-boundary boundary))

(defun validate-world-basis (basis &key (path '("basis")))
  (require-closed-fields basis '("kind" "schema-version" "mode" "parameters")
                         "basis" :path-prefix path)
  (unless (and (exact-kind-p basis "claim-basis")
               (exact-zero-p (record-field-named basis "schema-version"))
               (id-path= (record-field-named basis "mode") "world")
               (record-datum-p (record-field-named basis "parameters"))
               (zerop (record-datum-size
                       (record-field-named basis "parameters"))))
    (lci-fail "invalid-input" "InvalidBasis" "basis" :path path))
  (make-lci-value :world-basis basis))

(defun validate-corpus-basis (basis &key (path '("basis")))
  (require-closed-fields basis
                         '("kind" "schema-version" "mode" "corpus" "revision"
                           "slice" "semantic-boundary")
                         "basis" :path-prefix path)
  (unless (and (exact-kind-p basis "claim-basis")
               (exact-zero-p (record-field-named basis "schema-version"))
               (id-path= (record-field-named basis "mode") "corpus"))
    (lci-fail "invalid-input" "InvalidBasis" "basis" :path path))
  (validate-stable-ref (record-field-named basis "corpus")
                       :path (append path '("corpus")))
  (validate-stable-ref (record-field-named basis "revision")
                       :path (append path '("revision")))
  (validate-dataset-slice (record-field-named basis "slice")
                          :path (append path '("slice")))
  (validate-semantic-boundary (record-field-named basis "semantic-boundary")
                              :path (append path '("semantic-boundary")))
  (make-lci-value :corpus-basis basis))

(defun validate-interpretation-frame (frame &key (path '("interpretation-frame")))
  (require-closed-fields frame
                         '("kind" "schema-version" "frame-schema" "components")
                         "interpretation-frame" :path-prefix path)
  (unless (and (exact-zero-p (record-field-named frame "schema-version"))
               (record-datum-p (record-field-named frame "components")))
    (lci-fail "invalid-input" "InvalidInterpretationFrame"
              "interpretation-frame" :path path))
  (validate-stable-ref (record-field-named frame "frame-schema")
                       :path (append path '("frame-schema")))
  (make-lci-value :interpretation-frame frame))

(defun validate-profile-location (location &key (path '("profile-location")))
  (unless (record-datum-p location)
    (lci-fail "invalid-input" "InvalidProfileLocation" "profile-location"
              :path path))
  ;; Mneme/0 reserves the slot and accepts only the exact empty record in a
  ;; ClaimLocation.  The standalone fixture schema has a closed explanatory
  ;; wrapper and is handled by its vector operation.
  (when (plusp (record-datum-size location))
    (let* ((coordinates (record-field-named location "coordinates"))
           (unknown (and (record-datum-p coordinates)
                         (first (record-field-names coordinates)))))
      (lci-fail "invalid-input" "UnknownField" "profile-location"
                :path (append path (if unknown
                                       (list "coordinates" unknown)
                                       (list (first (record-field-names location))))))))
  (make-lci-value :profile-location location))

(defun validate-claim-location (location &key (path '("location")))
  (require-closed-fields location
                         '("kind" "scope" "subject-time" "basis"
                           "interpretation-frame" "profile-location")
                         "location-shape" :path-prefix path)
  (validate-scope (record-field-named location "scope")
                  :path (append path '("scope")))
  (validate-subject-time (record-field-named location "subject-time")
                         :path (append path '("subject-time")))
  (let ((basis (record-field-named location "basis")))
    (if (id-path= (record-field-named basis "mode") "world")
        (validate-world-basis basis :path (append path '("basis")))
        (validate-corpus-basis basis :path (append path '("basis")))))
  (validate-interpretation-frame
   (record-field-named location "interpretation-frame")
   :path (append path '("interpretation-frame")))
  (validate-profile-location (record-field-named location "profile-location")
                             :path (append path '("profile-location")))
  (make-lci-value :claim-location location))

(defun normalize-proposition (proposition &key budget)
  (declare (ignore budget))
  (unless (and (record-datum-p proposition)
               (exact-kind-p proposition "mneme-fixture-proposition"))
    (lci-fail "projection-refusal" "UnnormalizedProposition" "proposition"
              :path '("proposition")))
  (require-closed-fields proposition '("kind" "schema-version" "form" "arguments")
                         "proposition" :path-prefix '("proposition"))
  (unless (exact-zero-p (record-field-named proposition "schema-version"))
    (lci-fail "unsupported-version-or-profile" "UnsupportedClaimProfile"
              "claim-profile" :path '("proposition" "schema-version")))
  (let* ((form (exact-form-name proposition))
         (fields (cdr (assoc form +proposition-arguments+ :test #'string=)))
         (arguments (record-field-named proposition "arguments")))
    (unless fields
      (lci-fail "projection-refusal" "UnnormalizedProposition" "proposition"
                :path '("proposition" "form")))
    (require-closed-fields arguments fields "proposition"
                           :path-prefix '("proposition" "arguments"))
    (dolist (field fields)
      (let ((argument (record-field-named arguments field)))
        (require-closed-fields argument '("kind" "schema-version" "placement" "value")
                               "proposition"
                               :path-prefix (list "proposition" "arguments" field))
        (unless (and (exact-kind-p argument "proposition-argument")
                     (exact-zero-p (record-field-named argument "schema-version")))
          (lci-fail "projection-refusal" "UnnormalizedProposition" "proposition"
                    :path (list "proposition" "arguments" field))))))
  (copy-datum-through-cd0 proposition))

(defun proposition-location-consistent-p (proposition location &key (signal-p nil))
  (labels ((refuse (path)
             (if signal-p
                 (lci-fail "projection-refusal" "PropositionLocationInconsistent"
                           (if (member "basis" path :test #'string=)
                               "basis" "proposition") :path path)
                 (return-from proposition-location-consistent-p nil))))
    (let* ((form (exact-form-name proposition))
           (arguments (record-field-named proposition "arguments")))
      (dolist (field (cdr (assoc form +proposition-arguments+ :test #'string=)))
        (let* ((argument (record-field-named arguments field))
               (placement (record-field-named argument "placement"))
               (locator-p (or (search "locator" field)
                              (member field '("quantified-domain" "population-domain")
                                      :test #'string=)))
               (expected (if locator-p "external-claim-location-locator"
                             "proposition-subject-content")))
          (unless (and (identifier-datum-p placement)
                       (string= (identifier-last placement) expected))
            (refuse (list "proposition" "arguments" field "placement")))))
      (let* ((basis (record-field-named location "basis"))
             (corpus-p (id-path= (record-field-named basis "mode") "corpus")))
        (when (and (string= form "bounded-corpus-absence") (not corpus-p))
          (refuse '("location" "basis")))
        (when (and corpus-p (string/= form "bounded-corpus-absence"))
          ;; Corpus basis is valid for several fixture forms; no blanket refusal.
          nil)
        (when (and (string= form "bounded-corpus-absence") corpus-p)
          (let* ((boundary (record-field-named basis "semantic-boundary"))
                 (expression (record-field-named boundary "expression")))
            (when (member (exact-form-name expression)
                          '("not-applicable" "snapshot-manifest")
                          :test #'string=)
              (refuse '("location" "basis" "semantic-boundary")))))))
    t))

(defun validate-claim-id (claim &key (path nil))
  (require-closed-fields claim
                         '("kind" "lci-version" "identity-policy" "claim-profile"
                           "proposition" "location")
                         "claim-shape" :path-prefix path)
  (unless (exact-kind-p claim "claim-id-envelope")
    (lci-fail "invalid-input" "InvalidClaimId" "claim-shape" :path path))
  (unless (exact-zero-p (record-field-named claim "lci-version"))
    (lci-fail "unsupported-version-or-profile" "UnsupportedLCIVersion"
              "lci-version" :path (append path '("lci-version"))))
  (validate-identity-policy (record-field-named claim "identity-policy")
                            :path (append path '("identity-policy")))
  (validate-claim-profile (record-field-named claim "claim-profile")
                          :path (append path '("claim-profile")))
  (let ((proposition (normalize-proposition
                      (record-field-named claim "proposition"))))
    (validate-claim-location (record-field-named claim "location")
                             :path (append path '("location")))
    (proposition-location-consistent-p
     proposition (record-field-named claim "location") :signal-p t))
  (make-lci-value :claim-id claim))

(defun project-claim-id (claim)
  (when (and (record-datum-p claim)
             (or (record-has-field-p claim "digest")
                 (record-has-field-p claim "digest-scheme")))
    (lci-fail "projection-refusal" "SelfDeclaredClaimId" "projection"
              :path '("digest")))
  (if (exact-kind-p claim "claim-id-envelope")
      (progn (validate-claim-id claim) (copy-datum-through-cd0 claim))
      (progn
        (require-closed-fields claim
                               '("identity-policy" "claim-profile" "proposition"
                                 "location")
                               "claim-shape")
        (validate-identity-policy (record-field-named claim "identity-policy"))
        (validate-claim-profile (record-field-named claim "claim-profile"))
        (let* ((proposition (normalize-proposition
                             (record-field-named claim "proposition")))
               (location (record-field-named claim "location")))
          (validate-claim-location location)
          (proposition-location-consistent-p proposition location :signal-p t)
          (let ((envelope
                  (make-lci-record
                   (list "kind" (lci-tag "claim-id-envelope"))
                   (list "lci-version" (make-integer-datum 0))
                   (list "identity-policy" (record-field-named claim "identity-policy"))
                   (list "claim-profile" (record-field-named claim "claim-profile"))
                   (list "proposition" proposition)
                   (list "location" location))))
            (validate-claim-id envelope)
            envelope)))))

(defun validate-represented-loss (loss &key (path '("represented-loss")))
  (require-closed-fields loss
                         '("kind" "schema-version" "operation" "source"
                           "lost-dimensions" "consequence" "account")
                         "represented-loss" :path-prefix path)
  (unless (and (exact-kind-p loss "represented-loss")
               (exact-zero-p (record-field-named loss "schema-version")))
    (lci-fail "invalid-input" "InvalidRepresentedLoss" "represented-loss"
              :path path))
  (validate-stable-ref (record-field-named loss "operation")
                       :path (append path '("operation")))
  (validate-stable-ref (record-field-named loss "source")
                       :path (append path '("source")))
  (let ((dimensions (record-field-named loss "lost-dimensions")))
    (unless (and (sequence-datum-p dimensions)
                 (loop for index below (sequence-datum-length dimensions)
                       always (identifier-datum-p
                               (sequence-datum-ref dimensions index))))
      (lci-fail "invalid-input" "InvalidRepresentedLoss" "represented-loss"
                :path (append path '("lost-dimensions")))))
  (unless (identifier-datum-p (record-field-named loss "consequence"))
    (lci-fail "invalid-input" "InvalidRepresentedLoss" "represented-loss"
              :path (append path '("consequence"))))
  (let* ((account (record-field-named loss "account"))
         (account-schema (record-field-named account "account-schema"))
         (schema-path (and (identifier-datum-p account-schema)
                           (identifier-path-strings account-schema)))
         (operation (and schema-path (second schema-path)))
         (fields (cdr (assoc operation +loss-account-fields+ :test #'string=))))
    (unless fields
      (lci-fail "invalid-input" "InvalidRepresentedLoss" "represented-loss"
                :path (append path '("operation"))))
    (require-closed-fields account fields "represented-loss"
                           :path-prefix (append path '("account"))))
  (make-lci-value :represented-loss loss))

(defun validate-claim-lineage-edge (edge &key (path '("lineage")))
  (require-closed-fields
   edge '("kind" "schema-version" "relation" "source-occurrence"
          "destination-occurrence" "source-claim" "destination-claim"
          "receipt" "represented-loss")
   "lineage" :path-prefix path)
  (unless (and (exact-kind-p edge "claim-lineage-edge")
               (exact-zero-p (record-field-named edge "schema-version"))
               (identifier-datum-p (record-field-named edge "relation"))
               (record-datum-p (record-field-named edge "receipt")))
    (lci-fail "invalid-input" "InvalidClaimLineageEdge" "lineage" :path path))
  (validate-stable-ref (record-field-named edge "source-occurrence")
                       :path (append path '("source-occurrence")))
  (validate-stable-ref (record-field-named edge "destination-occurrence")
                       :path (append path '("destination-occurrence")))
  (validate-claim-id (record-field-named edge "source-claim")
                     :path (append path '("source-claim")))
  (validate-claim-id (record-field-named edge "destination-claim")
                     :path (append path '("destination-claim")))
  (let ((losses (record-field-named edge "represented-loss")))
    (unless (sequence-datum-p losses)
      (lci-fail "invalid-input" "InvalidClaimLineageEdge" "lineage"
                :path (append path '("represented-loss"))))
    (loop for index below (sequence-datum-length losses)
          do (validate-represented-loss
              (sequence-datum-ref losses index)
              :path (append path (list "represented-loss"
                                       (write-to-string index))))))
  (make-lci-value :claim-lineage-edge edge))

(defun validate-warrant-target (target &key (path nil))
  (require-record target "InvalidWarrantTarget" "target-shape" path)
  ;; Legacy proposition fingerprints are inert predecessor metadata and cannot
  ;; occupy the ClaimId envelope slot, even when their text happens to collide.
  (when (and (record-has-field-p target "legacy-fingerprint")
             (not (record-has-field-p target "claim")))
    (lci-fail "migration-refusal" "LegacyFingerprintNotClaimId"
              "target-shape" :path (append path '("claim"))))
  (require-closed-fields target
                         '("kind" "lci-version" "target-kind" "target-schema"
                           "claim" "boundaries")
                         "target-shape" :path-prefix path)
  (unless (and (exact-kind-p target "warrant-target")
               (exact-zero-p (record-field-named target "lci-version")))
    (lci-fail "invalid-input" "InvalidWarrantTarget" "target-shape" :path path))
  (let* ((kind-id (record-field-named target "target-kind"))
         (kind (identifier-last kind-id))
         (fields (cdr (assoc kind +target-boundary-fields+ :test #'string=)))
         (boundaries (record-field-named target "boundaries")))
    (unless fields
      (lci-fail "invalid-input" "UnsupportedTargetKind" "target-shape"
                :path (append path '("target-kind"))))
    (validate-stable-ref (record-field-named target "target-schema")
                         :path (append path '("target-schema")))
    (validate-claim-id (record-field-named target "claim")
                       :path (append path '("claim")))
    (when (and (member kind '("executed" "replayed") :test #'string=)
               (not (record-has-field-p boundaries
                                        "immutable-code-or-semantics")))
      (lci-fail "reference-refusal" "ProcedureIdentityInsufficient"
                "target-boundaries"
                :path (append path
                              '("boundaries" "immutable-code-or-semantics"))))
    (require-closed-fields boundaries fields "target-boundaries"
                           :missing-code "TargetBoundaryMissing"
                           :unknown-code "TargetBoundaryUnknown"
                           :path-prefix (append path '("boundaries")))
    ;; The fixture negative executed witness uses a mutable procedure/code
    ;; identity in this exact boundary position.
    (when (and (member kind '("executed" "replayed") :test #'string=)
               (let ((code (record-field-named boundaries
                                                "immutable-code-or-semantics")))
                 (and code (not (exact-kind-p code "stable-reference")))))
      (lci-fail "reference-refusal" "ProcedureIdentityInsufficient"
                "target-boundaries"
                :path (append path '("boundaries" "immutable-code-or-semantics")))))
  (make-lci-value :warrant-target target))

(defun validate-claim-occurrence (occurrence &key (path nil))
  (require-closed-fields occurrence
                         '("kind" "schema-version" "semantic-claim-core" "claimant"
                           "assertion-time" "provenance" "lineage" "cached-claim-id"
                           "presentation" "nonidentity-metadata")
                         "claim-shape" :path-prefix path)
  (let* ((projected (project-claim-id
                     (record-field-named occurrence "semantic-claim-core")))
         (cached (record-field-named occurrence "cached-claim-id")))
    (unless (equal-datum projected cached)
      (lci-fail "projection-refusal" "ClaimIdCacheMismatch" "claim-id-cache"
                :path (append path '("cached-claim-id")))))
  (make-lci-value :claim-occurrence occurrence))

(defun validate-migration-result (result &key (path nil))
  (require-closed-fields
   result '("kind" "schema-version" "source" "adapter" "classification"
            "claim" "claim-id" "lineage" "represented-loss"
            "legacy-testimony" "live-warrants-created")
   "migration-result" :path-prefix path)
  (unless (and (exact-kind-p result "migration-result")
               (exact-zero-p (record-field-named result "schema-version")))
    (lci-fail "migration-refusal" "InvalidMigrationResult" "migration-result"
              :path path))
  (let ((classification (identifier-last
                         (record-field-named result "classification")))
        (loss (record-field-named result "represented-loss")))
    (when (and (member classification
                       '("lossy-with-represented-loss"
                         "privileged-runtime-relation-outside-claim-id")
                       :test #'string=)
               (or (null loss) (unit-datum-p loss)
                   (and (sequence-datum-p loss)
                        (zerop (sequence-datum-length loss)))))
      (lci-fail "migration-refusal" "RepresentedLossRequired" "represented-loss"
                :path (append path '("represented-loss"))))
    (validate-stable-ref (record-field-named result "source")
                         :path (append path '("source")))
    (validate-stable-ref (record-field-named result "adapter")
                         :path (append path '("adapter")))
    (unless (identifier-datum-p (record-field-named result "classification"))
      (lci-fail "migration-refusal" "InvalidMigrationResult" "migration-result"
                :path (append path '("classification"))))
    (validate-claim-id (record-field-named result "claim-id")
                       :path (append path '("claim-id")))
    (let ((losses (record-field-named result "represented-loss")))
      (unless (sequence-datum-p losses)
        (lci-fail "migration-refusal" "InvalidMigrationResult"
                  "migration-result" :path (append path '("represented-loss"))))
      (loop for index below (sequence-datum-length losses)
            do (validate-represented-loss (sequence-datum-ref losses index)
                                          :path (append path
                                                        '("represented-loss")))))
    (dolist (field '("lineage" "legacy-testimony"))
      (let ((items (record-field-named result field)))
        (unless (and (sequence-datum-p items)
                     (loop for index below (sequence-datum-length items)
                           always (record-datum-p
                                   (sequence-datum-ref items index))))
          (lci-fail "migration-refusal" "InvalidMigrationResult"
                    "migration-result" :path (append path (list field))))))
    (let ((live (record-field-named result "live-warrants-created")))
      (unless (and (boolean-datum-p live) (not (boolean-datum-value live)))
        (lci-fail "privilege-refusal" "PrivilegedRestorationAttempt"
                  "privilege-boundary"
                  :path (append path '("live-warrants-created"))))))
  (make-lci-value :migration-result result))
