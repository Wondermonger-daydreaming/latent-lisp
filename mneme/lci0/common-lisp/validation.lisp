(in-package #:lisp-plus-lci0)

(declaim (ftype function validate-stable-ref normalize-proposition))

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

;; This table is a literal transcription of Fixture Package §7.  It is kept
;; in the implementation rather than fetched from the registry: target
;; validation is pure and performs no package/registry lookup.
(defparameter +target-boundary-types+
  '(("observed"
     ("observer-or-instrument" stable-ref "principal")
     ("observation-procedure" stable-ref "procedure")
     ("observation-time" event-time "observation-time")
     ("coverage-scope" scope)
     ("observation-mode" identifier)
     ("observation-artifact-or-event" stable-ref "artifact"))
    ("executed"
     ("procedure-reference" stable-ref "procedure")
     ("immutable-code-or-semantics" stable-ref "artifact")
     ("invocation" stable-ref "prompt-invocation")
     ("execution-environment-semantics" stable-ref "module")
     ("execution-time" event-time "execution-time")
     ("execution-event-or-trace" stable-ref "artifact")
     ("coverage-scope" scope))
    ("tested"
     ("system-or-procedure-under-test" stable-ref "procedure")
     ("immutable-tested-version" stable-ref "artifact")
     ("test-case-or-suite" stable-ref "artifact")
     ("test-input" datum)
     ("expected-relation" identifier)
     ("execution-environment-semantics" stable-ref "module")
     ("execution-time" event-time "test-execution-time")
     ("test-event-or-trace" stable-ref "artifact")
     ("coverage-scope" scope))
    ("derived"
     ("inference-calculus" stable-ref "module")
     ("premise-claim-ids" claim-id-sequence)
     ("rule-or-derivation-identity" stable-ref "procedure")
     ("derivation-artifact-or-trace" stable-ref "artifact")
     ("coverage-scope" scope))
    ("externally-attested"
     ("external-principal" stable-ref "principal")
     ("external-statement-or-artifact" stable-ref "artifact")
     ("attestation-time" event-time "attestation-time")
     ("mapping-receipt" stable-ref "artifact")
     ("coverage-scope" scope))
    ("replayed"
     ("predecessor-warrant-testimony-or-event" stable-ref "artifact")
     ("replay-procedure" stable-ref "procedure")
     ("immutable-code-or-semantics" stable-ref "artifact")
     ("replay-invocation" stable-ref "prompt-invocation")
     ("execution-environment-semantics" stable-ref "module")
     ("replay-time" event-time "replay-time")
     ("new-replay-trace-or-result" stable-ref "artifact")
     ("coverage-scope" scope))
    ("corpus-completion"
     ("exact-corpus-basis" corpus-basis)
     ("search-procedure" stable-ref "procedure")
     ("immutable-code-or-semantics" stable-ref "artifact")
     ("query-or-search-expression" proposition)
     ("coverage-plan" stable-ref "artifact")
     ("completion-boundary" semantic-boundary)
     ("execution-time" event-time "search-execution-time")
     ("completion-receipt-or-trace" stable-ref "artifact")
     ("coverage-scope" scope))
    ("reported"
     ("reporter-or-source-principal" stable-ref "principal")
     ("source-artifact" stable-ref "artifact")
     ("report-time" event-time "report-time")
     ("content-to-claim-interpretation-receipt" stable-ref "artifact")
     ("coverage-scope" scope))
    ("inherited"
     ("predecessor-occurrence-or-artifact" stable-ref "artifact")
     ("predecessor-warrant-testimony" stable-ref "artifact")
     ("inheritance-or-handoff-rule" stable-ref "policy")
     ("handoff-freeze-revival-receipt" stable-ref "artifact")
     ("represented-loss" represented-loss)
     ("coverage-scope" scope))
    ("translated"
     ("source-claim-id" claim-id)
     ("source-interpretation-frame" interpretation-frame)
     ("target-interpretation-frame" interpretation-frame)
     ("translation-procedure" stable-ref "procedure")
     ("translation-receipt" stable-ref "artifact")
     ("represented-loss" represented-loss)
     ("coverage-scope" scope))
    ("policy-evaluation"
     ("policy" stable-ref "policy")
     ("evaluated-warrant" stable-ref "artifact")
     ("state-snapshot" stable-ref "artifact")
     ("query-time" event-time "policy-query-time")
     ("testimony-mode" identifier)
     ("inner-target-relation" target-relation-result)
     ("coverage-scope" scope))))

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

(defparameter +fixture-identifier-namespace+
  '("lisp-plus" "lci" "0" "fixture"))

(defparameter +fixture-mutable-alias-segments+
  '("latest" "main" "production" "model-current" "display-model"
    "filename" "file.txt" "mutable-url"))

(defun %exact-identifier-p (value namespace path)
  (and (identifier-datum-p value)
       (equal (identifier-namespace-strings value) namespace)
       (equal (identifier-path-strings value) path)))

(defun %case-insensitive-prefix-p (prefix string)
  (and (stringp string)
       (<= (length prefix) (length string))
       (string-equal prefix string :end2 (length prefix))))

(defun %mutable-fixture-object-id-p (segments)
  (or (some (lambda (segment)
              (member segment +fixture-mutable-alias-segments+
                      :test #'string-equal))
            segments)
      (some (lambda (segment)
              (or (%case-insensitive-prefix-p "http://" segment)
                  (%case-insensitive-prefix-p "https://" segment)
                  ;; A package-symbol spelling is a display/runtime alias,
                  ;; never an LCI fixture structural object identifier.
                  (and (stringp segment) (search "::" segment))))
            segments)))

(defun %fixture-object-id-prefix-p (object-id domain-name)
  (and (identifier-datum-p object-id)
       (equal (identifier-namespace-strings object-id)
              +fixture-identifier-namespace+)
       (let ((segments (identifier-path-strings object-id)))
         (and (<= 2 (length segments))
              (string= (first segments) "object")
              (string= (second segments) domain-name)))))

(defun %stable-ref-domain-p (reference domain-name)
  (%exact-identifier-p (record-field-named reference "domain")
                       +fixture-identifier-namespace+
                       (list "domain" domain-name)))

(defun %validate-stable-ref-domain (reference domain-name path)
  (validate-stable-ref reference :path path)
  (unless (%stable-ref-domain-p reference domain-name)
    (lci-fail "reference-refusal" "InvalidStableReference"
              "stable-reference" :path (append path '("domain"))))
  reference)

(defun %stable-ref-material-exact-p (reference domain-name object-tail version)
  (let* ((material (record-field-named reference "material"))
         (object-id (record-field-named material "object-id"))
         (object-version (record-field-named material "object-version")))
    (and (%stable-ref-domain-p reference domain-name)
         (%exact-identifier-p
          object-id +fixture-identifier-namespace+
          (append (list "object" domain-name) object-tail))
         (integer-datum-p object-version)
         (= (integer-datum-value object-version) version))))

(defun %stable-ref-object-path (reference)
  (let* ((material (and (record-datum-p reference)
                        (record-field-named reference "material")))
         (object-id (and (record-datum-p material)
                         (record-field-named material "object-id"))))
    (and (identifier-datum-p object-id)
         (identifier-path-strings object-id))))

(defun %validate-exact-fixture-reference (reference domain-name object-tail
                                          version path)
  (%validate-stable-ref-domain reference domain-name path)
  (unless (%stable-ref-material-exact-p reference domain-name object-tail version)
    (lci-fail "reference-refusal" "InvalidStableReference"
              "stable-reference" :path (append path '("material" "object-id"))))
  reference)

(defun %octets-lexicographic-less-p (left right)
  (loop for index below (min (octets-length left) (octets-length right))
        for left-byte = (octets-ref left index)
        for right-byte = (octets-ref right index)
        when (< left-byte right-byte) do (return t)
        when (> left-byte right-byte) do (return nil)
        finally (return (< (octets-length left) (octets-length right)))))

(defun %string-suffix-p (suffix string)
  (and (<= (length suffix) (length string))
       (string= suffix string :start2 (- (length string) (length suffix)))))

(defun %normalized-fixture-absolute-path-p (string)
  (and (stringp string)
       (plusp (length string))
       (char= (char string 0) #\/)
       (not (search "//" string))
       (not (string= string "/."))
       (not (string= string "/.."))
       (not (search "/./" string))
       (not (search "/../" string))
       (not (%string-suffix-p "/." string))
       (not (%string-suffix-p "/.." string))))

(defun %validate-stable-ref-unbudgeted (reference &key (path nil))
  (require-closed-fields reference '("kind" "domain" "scheme" "material")
                         "stable-reference" :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (unless (%exact-identifier-p (record-field-named reference "kind")
                               '("lisp-plus" "lci" "0" "tag")
                               '("stable-reference"))
    (lci-fail "reference-refusal" "InvalidStableReference" "stable-reference"
              :path (append path '("kind"))))
  (let* ((domain (record-field-named reference "domain"))
         (scheme (record-field-named reference "scheme"))
         (material (record-field-named reference "material"))
         (domain-path (and (identifier-datum-p domain)
                           (identifier-path-strings domain)))
         (domain-name (and (= (length domain-path) 2)
                           (string= (first domain-path) "domain")
                           (second domain-path))))
    (unless (and domain-name
                 (equal (identifier-namespace-strings domain)
                        +fixture-identifier-namespace+)
                 (member domain-name +stable-ref-domains+ :test #'string=))
      (lci-fail "reference-refusal" "InvalidStableReference"
                "stable-reference" :path (append path '("domain"))))
    (unless (%exact-identifier-p
             scheme +fixture-identifier-namespace+
             (list "scheme" domain-name "structural" "0"))
      (lci-fail "unsupported-version-or-profile" "UnsupportedReferenceScheme"
                "stable-reference" :path (append path '("scheme"))))
    (require-closed-fields material
                           '("kind" "schema-version" "object-id" "object-version")
                           "stable-reference"
                           :key-namespace +fixture-field-namespace+
                           :path-prefix (append path '("material")))
    (unless (%exact-identifier-p
             (record-field-named material "kind")
             +fixture-identifier-namespace+ '("tag" "fixture-stable-material"))
      (lci-fail "reference-refusal" "InvalidStableReference"
                "stable-reference" :path (append path '("material" "kind"))))
    (unless (exact-zero-p (record-field-named material "schema-version"))
      (lci-fail "unsupported-version-or-profile"
                "RecursiveUnsupportedNestedVersion" "stable-reference"
                :path (append path '("material" "schema-version"))))
    (let ((object-id (record-field-named material "object-id")))
      (unless (identifier-datum-p object-id)
        (lci-fail "reference-refusal" "InvalidStableReference"
                  "stable-reference"
                  :path (append path '("material" "object-id"))))
      (let ((segments (identifier-path-strings object-id)))
        ;; Alias refusal precedes the registered-prefix check because the
        ;; sealed E7 witnesses deliberately use a noncanonical prefix.
        (when (%mutable-fixture-object-id-p segments)
          (lci-fail "reference-refusal" "UnresolvedAlias" "stable-reference"
                    ;; N008 owns this observable failure at the StableRef's
                    ;; containing identity coordinate.  Other nested callers
                    ;; retain the complete recursive path through the failing
                    ;; StableRef material.
                    :path (if (equal path '("location" "basis" "revision"))
                              path
                              (append path '("material" "object-id")))))
        (unless (%fixture-object-id-prefix-p object-id domain-name)
          (lci-fail "reference-refusal" "InvalidStableReference"
                    "stable-reference"
                    :path (append path '("material" "object-id"))))))
    (let ((object-version (record-field-named material "object-version")))
      (unless (and (integer-datum-p object-version)
                   (not (minusp (integer-datum-value object-version))))
        (lci-fail "reference-refusal" "InvalidStableReference"
                  "stable-reference"
                  :path (append path '("material" "object-version")))))
    (reject-unknown-fields
     material '("kind" "schema-version" "object-id" "object-version")
     "stable-reference" :key-namespace +fixture-field-namespace+
     :path-prefix (append path '("material")))
    (reject-unknown-fields reference '("kind" "domain" "scheme" "material")
                           "stable-reference"
                           :key-namespace +lci-field-namespace+
                           :path-prefix path)
    (make-lci-value :stable-ref reference)))

(defun validate-stable-ref (reference &key (path nil))
  (with-lci-structural-budgets (reference "validation")
    (%validate-stable-ref-unbudgeted reference :path path)))

(defun validate-identity-policy (policy &key (path '("identity-policy")))
  (require-closed-fields policy '("kind" "policy-id" "policy-version")
                         "identity-policy" :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (unless (and (%exact-identifier-p (record-field-named policy "kind")
                                    '("lisp-plus" "lci" "0" "tag")
                                    '("identity-policy"))
               (%exact-identifier-p (record-field-named policy "policy-id")
                                    '("lisp-plus" "lci")
                                    '("located-claim-identity"))
               (exact-zero-p (record-field-named policy "policy-version")))
    (lci-fail "unsupported-version-or-profile" "UnsupportedIdentityPolicy"
              "identity-policy" :path (append path '("policy-version"))))
  (reject-unknown-fields policy '("kind" "policy-id" "policy-version")
                         "identity-policy" :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (make-lci-value :identity-policy policy))

(defun validate-claim-profile (profile &key (path '("claim-profile")))
  (require-closed-fields profile '("kind" "profile-id" "profile-version")
                         "claim-profile" :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (unless (and (%exact-identifier-p (record-field-named profile "kind")
                                    '("lisp-plus" "lci" "0" "tag")
                                    '("claim-profile"))
               (%exact-identifier-p (record-field-named profile "profile-id")
                                    '("lisp-plus" "mneme")
                                    '("located-claim"))
               (exact-zero-p (record-field-named profile "profile-version")))
    (lci-fail "unsupported-version-or-profile" "UnsupportedClaimProfile"
              "claim-profile" :path (append path '("profile-version"))))
  (reject-unknown-fields profile '("kind" "profile-id" "profile-version")
                         "claim-profile" :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (make-lci-value :claim-profile profile))

(defun %validate-versioned-expression (expression form-fields code stage path
                                       &key kind form-category)
  (require-record expression code stage path)
  (let* ((form (exact-form-name expression))
         (entry (assoc form form-fields :test #'string=))
         (fields (cdr entry)))
    (unless entry (lci-fail "invalid-input" code stage :path path))
    (require-closed-fields expression (cons "kind" (cons "schema-version"
                                                          (cons "form" fields)))
                           stage :key-namespace +fixture-field-namespace+
                           :path-prefix path)
    (when (and kind
               (not (%exact-identifier-p
                     (record-field-named expression "kind")
                     +fixture-identifier-namespace+ (list "tag" kind))))
      (lci-fail "invalid-input" code stage :path (append path '("kind"))))
    (unless (exact-zero-p (record-field-named expression "schema-version"))
      (lci-fail "unsupported-version-or-profile"
                "RecursiveUnsupportedNestedVersion" stage
                :path (append path '("schema-version"))))
    (when (and form-category
               (not (%exact-identifier-p
                     (record-field-named expression "form")
                     +fixture-identifier-namespace+
                     (list form-category form))))
      (lci-fail "invalid-input" code stage :path (append path '("form"))))
    expression))

(defun %finish-versioned-expression (expression form-fields stage path
                                     &key (unknown-code "UnknownField"))
  (let* ((form (exact-form-name expression))
         (fields (cdr (assoc form form-fields :test #'string=))))
    (reject-unknown-fields
     expression (append '("kind" "schema-version" "form") fields) stage
     :unknown-code unknown-code :key-namespace +fixture-field-namespace+
     :path-prefix path))
  expression)

(defparameter +scope-form-fields+
  '(("universal") ("organization" "organization")
    ("department" "organization" "department")
    ("tenant" "organization" "tenant") ("region-set" "members")
    ("symbolic-predicate" "symbol" "known-proper-subset")
    ("opaque-token" "token")))

(defun %validate-scope-object (value class names path)
  (unless (and (identifier-datum-p value)
               (%exact-identifier-p value +fixture-identifier-namespace+
                                    (list "scope-object" class
                                          (identifier-last value)))
               (member (identifier-last value) names :test #'string=))
    (lci-fail "invalid-input" "InvalidScope" "scope" :path path))
  value)

(defun validate-scope (scope &key (path '("scope")))
  (require-closed-fields scope '("kind" "schema-version" "calculus" "expression")
                         "scope" :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (unless (%exact-identifier-p (record-field-named scope "kind")
                               '("lisp-plus" "lci" "0" "tag") '("scope"))
    (lci-fail "invalid-input" "InvalidScope" "scope"
              :path (append path '("kind"))))
  (unless (exact-zero-p (record-field-named scope "schema-version"))
    (lci-fail "unsupported-version-or-profile" "RecursiveUnsupportedNestedVersion"
              "scope" :path (append path '("schema-version"))))
  (let* ((calculus (record-field-named scope "calculus"))
         (primary-p (%stable-ref-material-exact-p
                     calculus "scope-calculus" '("mneme-primary") 0))
         (second-p (%stable-ref-material-exact-p
                    calculus "scope-calculus" '("bridge-less-second") 0)))
    (%validate-stable-ref-domain calculus "scope-calculus"
                                 (append path '("calculus")))
    (unless (or primary-p second-p)
      (lci-fail "reference-refusal" "InvalidStableReference"
                "stable-reference"
                :path (append path '("calculus" "material" "object-id"))))
  (handler-case
      (let* ((expression (record-field-named scope "expression"))
             (expression-path (append path '("expression")))
             (form (exact-form-name expression)))
        (%validate-versioned-expression
         expression +scope-form-fields+ "InvalidScope" "scope" expression-path
         :kind "scope-expression" :form-category "scope-form")
        (unless (if second-p (string= form "opaque-token")
                    (not (string= form "opaque-token")))
          (lci-fail "invalid-input" "InvalidScope" "scope"
                    :path (append expression-path '("form"))))
        (cond
          ((string= form "universal"))
          ((string= form "organization")
           (%validate-scope-object
            (record-field-named expression "organization") "organization"
            '("acme") (append expression-path '("organization"))))
          ((string= form "department")
           (%validate-scope-object
            (record-field-named expression "organization") "organization"
            '("acme") (append expression-path '("organization")))
           (%validate-scope-object
            (record-field-named expression "department") "department"
            '("research" "operations")
            (append expression-path '("department"))))
          ((string= form "tenant")
           (%validate-scope-object
            (record-field-named expression "organization") "organization"
            '("acme") (append expression-path '("organization")))
           (%validate-scope-object
            (record-field-named expression "tenant") "tenant" '("a" "b")
            (append expression-path '("tenant"))))
          ((string= form "region-set")
           (let ((members (record-field-named expression "members")))
             (unless (and (sequence-datum-p members)
                          (plusp (sequence-datum-length members)))
               (lci-fail "invalid-input" "InvalidScope" "scope"
                         :path (append expression-path '("members"))))
             (loop for index below (sequence-datum-length members)
                   for member = (sequence-datum-ref members index)
                   for member-path = (append expression-path
                                             (list "members"
                                                   (format nil "~D" index)))
                   do (%validate-scope-object member "region"
                                              '("east" "north" "south")
                                              member-path)
                   when (plusp index)
                     do (unless (%octets-lexicographic-less-p
                                 (canonical-octets
                                  (sequence-datum-ref members (1- index)))
                                 (canonical-octets member))
                          (lci-fail "invalid-input" "InvalidScope" "scope"
                                    :path member-path)))))
          ((string= form "symbolic-predicate")
           (unless (and
                    (%exact-identifier-p
                     (record-field-named expression "symbol")
                     +fixture-identifier-namespace+
                     '("scope-symbol" "undecidable-predicate-pi"))
                    (let ((known (record-field-named expression
                                                     "known-proper-subset")))
                      (and (boolean-datum-p known)
                           (boolean-datum-value known))))
             (lci-fail "invalid-input" "InvalidScope" "scope"
                       :path expression-path)))
          ((string= form "opaque-token")
           (unless (%exact-identifier-p
                    (record-field-named expression "token")
                    +fixture-identifier-namespace+
                    '("scope-object" "second-calculus" "alpha"))
             (lci-fail "invalid-input" "InvalidScope" "scope"
                       :path (append expression-path '("token"))))) )
        (%finish-versioned-expression expression +scope-form-fields+ "scope"
                                      expression-path))
    (lci-failure (condition)
      ;; LCI0-N010 pins an incomplete declared scope form to InvalidScope at
      ;; the expression boundary.  Errata E6 independently requires an
      ;; otherwise valid closed form's unknown member to retain UnknownField
      ;; and its depth-first structural path.
      (if (string= (lci-failure-code condition) "MissingRequiredField")
          (lci-fail "invalid-input" "InvalidScope" "scope"
                    :path (append path '("expression")))
          (error condition))))
  (reject-unknown-fields scope '("kind" "schema-version" "calculus" "expression")
                         "scope" :key-namespace +lci-field-namespace+
                         :path-prefix path))
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
                         "subject-time" :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (unless (%exact-identifier-p (record-field-named time "kind")
                               '("lisp-plus" "lci" "0" "tag")
                               '("subject-time"))
    (lci-fail "invalid-input" "InvalidSubjectTime" "subject-time"
              :path (append path '("kind"))))
  (unless (exact-zero-p (record-field-named time "schema-version"))
    (lci-fail "unsupported-version-or-profile" "RecursiveUnsupportedNestedVersion"
              "subject-time" :path (append path '("schema-version"))))
  (let* ((model (record-field-named time "temporal-model"))
         (primary-p (%stable-ref-material-exact-p
                     model "temporal-model" '("mneme-fixture-time") 0))
         (second-p (%stable-ref-material-exact-p
                    model "temporal-model" '("bridge-less-second") 0)))
    (%validate-stable-ref-domain model "temporal-model"
                                 (append path '("temporal-model")))
    (unless (or primary-p second-p)
      (lci-fail "reference-refusal" "InvalidStableReference"
                "stable-reference"
                :path (append path '("temporal-model" "material" "object-id"))))
  (let* ((expression (%validate-versioned-expression
                      (record-field-named time "expression")
                      +temporal-form-fields+ "InvalidSubjectTime" "subject-time"
                      (append path '("expression"))
                      :kind "temporal-expression"
                      :form-category "temporal-form"))
         (expression-path (append path '("expression")))
         (form (exact-form-name expression)))
    (unless (if second-p (string= form "opaque-token")
                (not (string= form "opaque-token")))
      (lci-fail "invalid-input" "InvalidSubjectTime" "subject-time"
                :path (append expression-path '("form"))))
    (cond
      ((string= form "atemporal"))
      ((string= form "instant")
       (unless (integer-datum-p (record-field-named expression "tick"))
         (lci-fail "invalid-input" "InvalidSubjectTime" "subject-time"
                   :path (append expression-path '("tick")))))
      ((string= form "interval")
       (let ((start (record-field-named expression "start"))
             (end (record-field-named expression "end"))
             (start-closed (record-field-named expression "start-closed"))
             (end-closed (record-field-named expression "end-closed")))
         (unless (and (integer-datum-p start) (integer-datum-p end)
                      (< (integer-datum-value start)
                         (integer-datum-value end))
                      (boolean-datum-p start-closed)
                      (boolean-datum-p end-closed))
           (lci-fail "invalid-input" "InvalidSubjectTime" "subject-time"
                     :path expression-path))))
      ((string= form "periodic-set")
       (let ((modulus (record-field-named expression "modulus"))
             (remainder (record-field-named expression "remainder")))
         (unless (and (integer-datum-p modulus)
                      (plusp (integer-datum-value modulus))
                      (integer-datum-p remainder)
                      (<= 0 (integer-datum-value remainder))
                      (< (integer-datum-value remainder)
                         (integer-datum-value modulus)))
           (lci-fail "invalid-input" "InvalidSubjectTime" "subject-time"
                     :path expression-path))))
      ((string= form "symbolic")
       (unless (%exact-identifier-p
                (record-field-named expression "symbol")
                +fixture-identifier-namespace+
                '("temporal-symbol" "unknown-event-window"))
         (lci-fail "invalid-input" "InvalidSubjectTime" "subject-time"
                   :path (append expression-path '("symbol")))))
      ((string= form "opaque-token")
       (unless (%exact-identifier-p
                (record-field-named expression "token")
                +fixture-identifier-namespace+
                '("temporal-object" "second-model" "alpha"))
         (lci-fail "invalid-input" "InvalidSubjectTime" "subject-time"
                   :path (append expression-path '("token")))))
      ((string= form "relative")
       ;; The bounded legacy-relative token is inert.  Its unresolved status,
       ;; not a guessed token interpretation, governs projection refusal.
       (unless (datum-p (record-field-named expression "token"))
         (lci-fail "invalid-input" "InvalidSubjectTime" "subject-time"
                   :path (append expression-path '("token"))))))
    (%finish-versioned-expression expression +temporal-form-fields+
                                  "subject-time" expression-path)
    (when (and (string= (exact-form-name expression) "relative")
               (not allow-relative))
      (lci-fail "projection-refusal" "UnresolvedRelativeTime" "subject-time"
                :path (append path '("expression")))))
  (reject-unknown-fields
   time '("kind" "schema-version" "temporal-model" "expression")
   "subject-time" :key-namespace +lci-field-namespace+ :path-prefix path))
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
                         "basis" :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (unless (%exact-identifier-p (record-field-named slice "kind")
                               '("lisp-plus" "lci" "0" "tag")
                               '("dataset-slice"))
    (lci-fail "invalid-input" "InvalidBasis" "basis" :path path))
  (unless (exact-zero-p (record-field-named slice "schema-version"))
    (lci-fail "unsupported-version-or-profile"
              "RecursiveUnsupportedNestedVersion" "basis"
              :path (append path '("schema-version"))))
  (%validate-exact-fixture-reference
   (record-field-named slice "calculus") "dataset-slice-calculus"
   '("mneme-fixture-slice") 0 (append path '("calculus")))
  (let* ((expression (record-field-named slice "expression"))
         (expression-path (append path '("expression")))
         (form (exact-form-name expression)))
    (%validate-versioned-expression expression +slice-form-fields+
                                    "InvalidBasis" "basis"
                                    expression-path
                                    :kind "dataset-slice-expression"
                                    :form-category "slice-form")
    (cond
      ((string= form "all-members"))
      ((string= form "explicit-members")
       (let ((members (record-field-named expression "members")))
         (unless (sequence-datum-p members)
           (lci-fail "invalid-input" "InvalidBasis" "basis"
                     :path (append expression-path '("members"))))
         (loop for index below (sequence-datum-length members)
               for member = (sequence-datum-ref members index)
               for member-path = (append expression-path
                                         (list "members" (format nil "~D" index)))
               do (%validate-stable-ref-domain member "artifact" member-path)
               when (plusp index)
                 do (let* ((previous (sequence-datum-ref members (1- index)))
                           (previous-octets (canonical-octets previous))
                           (current-octets (canonical-octets member)))
                      (unless (%octets-lexicographic-less-p
                               previous-octets current-octets)
                        (lci-fail "invalid-input" "InvalidBasis" "basis"
                                  :path member-path))))))
      ((string= form "predicate")
       (unless (%exact-identifier-p (record-field-named expression "predicate")
                                    +fixture-identifier-namespace+
                                    '("slice-predicate"
                                      "artifact-object-id-prefix"))
         (lci-fail "invalid-input" "InvalidBasis" "basis"
                   :path (append expression-path '("predicate"))))
       (unless (string-datum-p (record-field-named expression "argument"))
         (lci-fail "invalid-input" "InvalidBasis" "basis"
                   :path (append expression-path '("argument"))))
       (%validate-exact-fixture-reference
        (record-field-named expression "evaluation-domain")
        "immutable-corpus-revision" '("alpha-corpus" "revision-4") 4
        (append expression-path '("evaluation-domain")))))
    (%finish-versioned-expression expression +slice-form-fields+ "basis"
                                  expression-path))
  (reject-unknown-fields slice '("kind" "schema-version" "calculus" "expression")
                         "basis" :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (make-lci-value :dataset-slice slice))

(defun validate-semantic-boundary (boundary &key (path '("semantic-boundary")))
  (require-closed-fields boundary '("kind" "schema-version" "calculus" "expression")
                         "basis" :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (unless (%exact-identifier-p (record-field-named boundary "kind")
                               '("lisp-plus" "lci" "0" "tag")
                               '("semantic-boundary"))
    (lci-fail "invalid-input" "InvalidBasis" "basis" :path path))
  (unless (exact-zero-p (record-field-named boundary "schema-version"))
    (lci-fail "unsupported-version-or-profile"
              "RecursiveUnsupportedNestedVersion" "basis"
              :path (append path '("schema-version"))))
  (%validate-exact-fixture-reference
   (record-field-named boundary "calculus") "semantic-boundary-calculus"
   '("mneme-fixture-boundary") 0 (append path '("calculus")))
  (let* ((expression (record-field-named boundary "expression"))
         (expression-path (append path '("expression")))
         (form (exact-form-name expression)))
    (%validate-versioned-expression expression +boundary-form-fields+
                                    "InvalidBasis" "basis"
                                    expression-path
                                    :kind "semantic-boundary-expression"
                                    :form-category "boundary-form")
    (cond
      ((string= form "not-applicable"))
      ((string= form "snapshot-manifest")
       (%validate-stable-ref-domain
        (record-field-named expression "manifest") "artifact"
        (append expression-path '("manifest"))))
      ((string= form "path-root")
       (let* ((path-datum (record-field-named expression "path"))
              (path-string (and (string-datum-p path-datum)
                                (datum-string-value* path-datum))))
         (unless (%normalized-fixture-absolute-path-p path-string)
           (lci-fail "invalid-input" "InvalidBasis" "basis"
                     :path (append expression-path '("path")))))
       (unless (%exact-identifier-p
                (record-field-named expression "path-semantics")
                +fixture-identifier-namespace+
                '("path-semantics" "posix-absolute-byte-exact-utf8"))
         (lci-fail "invalid-input" "InvalidBasis" "basis"
                   :path (append expression-path '("path-semantics")))))
      ((string= form "log-horizon")
       (%validate-stable-ref-domain
        (record-field-named expression "stream") "artifact"
        (append expression-path '("stream")))
       (let ((horizon (record-field-named expression "horizon")))
         (%validate-versioned-expression
          horizon +temporal-form-fields+ "InvalidBasis" "basis"
          (append expression-path '("horizon"))
          :kind "temporal-expression" :form-category "temporal-form")
         (unless (and (%exact-identifier-p
                       (record-field-named horizon "kind")
                       +fixture-identifier-namespace+
                       '("tag" "temporal-expression"))
                      (%exact-identifier-p
                       (record-field-named horizon "form")
                       +fixture-identifier-namespace+
                       '("temporal-form" "instant"))
                      (integer-datum-p (record-field-named horizon "tick")))
           (lci-fail "invalid-input" "InvalidBasis" "basis"
                     :path (append expression-path '("horizon"))))
         (%finish-versioned-expression
          horizon +temporal-form-fields+ "basis"
          (append expression-path '("horizon"))))))
    (%finish-versioned-expression expression +boundary-form-fields+ "basis"
                                  expression-path))
  (reject-unknown-fields
   boundary '("kind" "schema-version" "calculus" "expression") "basis"
   :key-namespace +lci-field-namespace+ :path-prefix path)
  (make-lci-value :semantic-boundary boundary))

(defun validate-world-basis (basis &key (path '("basis")))
  (require-closed-fields basis '("kind" "schema-version" "mode" "parameters")
                         "basis" :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (unless (and (%exact-identifier-p (record-field-named basis "kind")
                                    '("lisp-plus" "lci" "0" "tag")
                                    '("claim-basis"))
               (exact-zero-p (record-field-named basis "schema-version"))
               (%exact-identifier-p (record-field-named basis "mode")
                                    '("lisp-plus" "lci" "0" "tag") '("world"))
               (record-datum-p (record-field-named basis "parameters"))
               (zerop (record-datum-size
                       (record-field-named basis "parameters"))))
    (lci-fail "invalid-input" "InvalidBasis" "basis" :path path))
  (reject-unknown-fields basis '("kind" "schema-version" "mode" "parameters")
                         "basis" :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (make-lci-value :world-basis basis))

(defun validate-corpus-basis (basis &key (path '("basis")))
  (require-closed-fields basis
                         '("kind" "schema-version" "mode" "corpus" "revision"
                           "slice" "semantic-boundary")
                         "basis" :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (unless (and (%exact-identifier-p (record-field-named basis "kind")
                                    '("lisp-plus" "lci" "0" "tag")
                                    '("claim-basis"))
               (exact-zero-p (record-field-named basis "schema-version"))
               (%exact-identifier-p (record-field-named basis "mode")
                                    '("lisp-plus" "lci" "0" "tag") '("corpus")))
    (lci-fail "invalid-input" "InvalidBasis" "basis" :path path))
  (%validate-stable-ref-domain (record-field-named basis "corpus")
                               "logical-corpus" (append path '("corpus")))
  (%validate-stable-ref-domain (record-field-named basis "revision")
                               "immutable-corpus-revision"
                               (append path '("revision")))
  (validate-dataset-slice (record-field-named basis "slice")
                          :path (append path '("slice")))
  (validate-semantic-boundary (record-field-named basis "semantic-boundary")
                              :path (append path '("semantic-boundary")))
  (reject-unknown-fields
   basis '("kind" "schema-version" "mode" "corpus" "revision" "slice"
           "semantic-boundary")
   "basis" :key-namespace +lci-field-namespace+ :path-prefix path)
  (let ((corpus-path (%stable-ref-object-path
                      (record-field-named basis "corpus")))
        (revision-path (%stable-ref-object-path
                        (record-field-named basis "revision"))))
    (unless (and (= (length corpus-path) 3)
                 (<= 4 (length revision-path))
                 (string= (third corpus-path) (third revision-path)))
      (lci-fail "invalid-input" "InvalidBasis" "basis"
                :path (append path '("revision")))))
  ;; Fixture Package §4 requires the slice and semantic boundary to name the
  ;; same finite revision as the enclosing CorpusBasis.  InvalidBasis is the
  ;; authorized semantic refusal.  Errata 0.1 does not pin the finer stage/path
  ;; tuple for these cross-field witnesses, so the paths below deliberately
  ;; identify the first offending coordinate without claiming fixture status.
  (let* ((revision (record-field-named basis "revision"))
         (revision-path (%stable-ref-object-path revision))
         (slice-expression
           (record-field-named (record-field-named basis "slice")
                               "expression"))
         (slice-form (exact-form-name slice-expression))
         (boundary-expression
           (record-field-named
            (record-field-named basis "semantic-boundary") "expression"))
         (boundary-form (exact-form-name boundary-expression)))
    (when (and (string= slice-form "predicate")
               (not (equal-datum
                     (record-field-named slice-expression "evaluation-domain")
                     revision)))
      (lci-fail "invalid-input" "InvalidBasis" "basis"
                :path (append path
                              '("slice" "expression" "evaluation-domain"))))
    (cond
      ((string= boundary-form "snapshot-manifest")
       (let ((manifest-path
               (%stable-ref-object-path
                (record-field-named boundary-expression "manifest"))))
         (unless
             (or (and (equal revision-path
                             '("object" "immutable-corpus-revision"
                               "alpha-corpus" "revision-3"))
                      (equal manifest-path
                             '("object" "artifact" "manifest" "alpha" "3")))
                 (and (equal revision-path
                             '("object" "immutable-corpus-revision"
                               "alpha-corpus" "revision-4"))
                      (equal manifest-path
                             '("object" "artifact" "manifest" "alpha" "4"))))
           (lci-fail "invalid-input" "InvalidBasis" "basis"
                     :path (append path
                                   '("semantic-boundary" "expression"
                                     "manifest"))))))
      ((member boundary-form '("path-root" "log-horizon") :test #'string=)
       (unless (equal revision-path
                      '("object" "immutable-corpus-revision"
                        "alpha-corpus" "revision-4"))
         (lci-fail "invalid-input" "InvalidBasis" "basis"
                   :path (append path
                                 '("semantic-boundary" "expression")))))))
  (make-lci-value :corpus-basis basis))

(defun validate-interpretation-frame (frame &key (path '("interpretation-frame")))
  (require-closed-fields frame
                         '("kind" "schema-version" "frame-schema" "components")
                         "interpretation-frame"
                         :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (unless (and (%exact-identifier-p (record-field-named frame "kind")
                                    '("lisp-plus" "lci" "0" "tag")
                                    '("interpretation-frame"))
               (record-datum-p (record-field-named frame "components")))
    (lci-fail "invalid-input" "InvalidInterpretationFrame"
              "interpretation-frame" :path path))
  (unless (exact-zero-p (record-field-named frame "schema-version"))
    (lci-fail "unsupported-version-or-profile"
              "RecursiveUnsupportedNestedVersion" "interpretation-frame"
              :path (append path '("schema-version"))))
  (%validate-exact-fixture-reference
   (record-field-named frame "frame-schema") "interpretation-frame-schema"
   '("mneme-fixture-frame") 0 (append path '("frame-schema")))
  (let ((components (record-field-named frame "components")))
    (unless (zerop (record-datum-size components))
      (require-closed-fields
       components '("ontology" "unit-system" "schema-edition"
                    "language-semantics" "evaluator-semantics")
       "interpretation-frame" :key-namespace +fixture-field-namespace+
       :path-prefix (append path '("components")))
      (%validate-stable-ref-domain
       (record-field-named components "ontology") "artifact"
       (append path '("components" "ontology")))
      (unless (member (identifier-path-strings
                       (record-field-named components "unit-system"))
                      '(("unit-system" "si") ("unit-system" "imperial"))
                      :test #'equal)
        (lci-fail "invalid-input" "InvalidInterpretationFrame"
                  "interpretation-frame"
                  :path (append path '("components" "unit-system"))))
      (unless (member (identifier-path-strings
                       (record-field-named components "schema-edition"))
                      '(("schema-edition" "measurement-v1")
                        ("schema-edition" "measurement-v2")) :test #'equal)
        (lci-fail "invalid-input" "InvalidInterpretationFrame"
                  "interpretation-frame"
                  :path (append path '("components" "schema-edition"))))
      (dolist (entry '(("language-semantics"
                        ("language-semantics" "fixture-literal-v0"))
                       ("evaluator-semantics"
                        ("evaluator-semantics" "fixture-inert-v0"))))
        (unless (%exact-identifier-p (record-field-named components (first entry))
                                     +fixture-identifier-namespace+
                                     (second entry))
          (lci-fail "invalid-input" "InvalidInterpretationFrame"
                    "interpretation-frame"
                    :path (append path (list "components" (first entry))))))
      ;; Unit/schema identifiers also use the exact fixture namespace.
      (dolist (field '("unit-system" "schema-edition"))
        (unless (equal (identifier-namespace-strings
                        (record-field-named components field))
                       +fixture-identifier-namespace+)
          (lci-fail "invalid-input" "InvalidInterpretationFrame"
                    "interpretation-frame"
                    :path (append path (list "components" field)))))
      (reject-unknown-fields
       components '("ontology" "unit-system" "schema-edition"
                    "language-semantics" "evaluator-semantics")
       "interpretation-frame" :key-namespace +fixture-field-namespace+
       :path-prefix (append path '("components")))))
  (reject-unknown-fields
   frame '("kind" "schema-version" "frame-schema" "components")
   "interpretation-frame" :key-namespace +lci-field-namespace+
   :path-prefix path)
  (make-lci-value :interpretation-frame frame))

(defun validate-profile-location (location &key (path '("profile-location")))
  (unless (record-datum-p location)
    (lci-fail "invalid-input" "InvalidClaimLocation" "profile-location"
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
                         "location-shape" :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (unless (%exact-identifier-p (record-field-named location "kind")
                               '("lisp-plus" "lci" "0" "tag")
                               '("claim-location"))
    (lci-fail "invalid-input" "InvalidClaimLocation" "location-shape"
              :path (append path '("kind"))))
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
  (reject-unknown-fields
   location '("kind" "scope" "subject-time" "basis" "interpretation-frame"
              "profile-location")
   "location-shape" :key-namespace +lci-field-namespace+ :path-prefix path)
  (make-lci-value :claim-location location))

(defparameter +proposition-locator-slots+
  '(("scope-locator" "scope" "claim-scope")
    ("subject-time-locator" "subject-time" "proposition-subject-time")
    ("basis-locator" "basis" "claim-basis")
    ("frame-locator" "interpretation-frame" "claim-interpretation-frame")
    ("corpus-locator" "basis" "logical-corpus-and-revision")
    ("dataset-slice-locator" "dataset-slice" "claim-dataset-slice")
    ("semantic-boundary-locator" "semantic-boundary"
     "bounded-search-horizon")
    ("quantified-domain" "scope" "quantified-domain")
    ("population-domain" "scope" "population-domain")))

(defun %validate-proposition-locator-slot (value descriptor path)
  (require-closed-fields value '("kind" "schema-version" "coordinate"
                                 "locator-role")
                         "proposition"
                         :key-namespace +proposition-field-namespace+
                         :path-prefix path)
  (unless (%exact-identifier-p (record-field-named value "kind")
                               +fixture-identifier-namespace+
                               '("tag" "locator-slot"))
    (lci-fail "projection-refusal" "UnnormalizedProposition" "proposition"
              :path (append path '("kind"))))
  (unless (exact-zero-p (record-field-named value "schema-version"))
    (lci-fail "unsupported-version-or-profile" "UnsupportedClaimProfile"
              "claim-profile" :path (append path '("schema-version"))))
  (unless (%exact-identifier-p (record-field-named value "coordinate")
                               +fixture-identifier-namespace+
                               (list "locator-coordinate" (second descriptor)))
    (lci-fail "projection-refusal" "UnnormalizedProposition" "proposition"
              :path (append path '("coordinate"))))
  (unless (%exact-identifier-p (record-field-named value "locator-role")
                               +fixture-identifier-namespace+
                               (list "locator-role" (third descriptor)))
    (lci-fail "projection-refusal" "UnnormalizedProposition" "proposition"
              :path (append path '("locator-role"))))
  (reject-unknown-fields value '("kind" "schema-version" "coordinate"
                                 "locator-role")
                         "proposition"
                         :key-namespace +proposition-field-namespace+
                         :path-prefix path)
  value)

(defun %normalize-proposition-unbudgeted (proposition &key budget)
  (declare (ignore budget))
  (unless (record-datum-p proposition)
    (lci-fail "projection-refusal" "UnnormalizedProposition" "proposition"
              :path '("proposition")))
  (require-closed-fields proposition '("kind" "schema-version" "form" "arguments")
                         "proposition"
                         :key-namespace +proposition-field-namespace+
                         :path-prefix '("proposition"))
  (unless (%exact-identifier-p (record-field-named proposition "kind")
                               +fixture-identifier-namespace+
                               '("tag" "mneme-fixture-proposition"))
    (lci-fail "projection-refusal" "UnnormalizedProposition" "proposition"
              :path '("proposition" "kind")))
  (unless (exact-zero-p (record-field-named proposition "schema-version"))
    (lci-fail "unsupported-version-or-profile" "UnsupportedClaimProfile"
              "claim-profile" :path '("proposition" "schema-version")))
  (let* ((form (exact-form-name proposition))
         (fields (cdr (assoc form +proposition-arguments+ :test #'string=)))
         (arguments (record-field-named proposition "arguments")))
    (unless fields
      (lci-fail "projection-refusal" "UnnormalizedProposition" "proposition"
                :path '("proposition" "form")))
    (unless (%exact-identifier-p (record-field-named proposition "form")
                                 +fixture-identifier-namespace+
                                 (list "proposition-form" form))
      (lci-fail "projection-refusal" "UnnormalizedProposition" "proposition"
                :path '("proposition" "form")))
    (unless (record-datum-p arguments)
      (lci-fail "projection-refusal" "UnnormalizedProposition" "proposition"
                :path '("proposition" "arguments")))
    (require-closed-fields arguments fields "proposition"
                           :key-namespace +proposition-argument-namespace+
                           :path-prefix '("proposition" "arguments"))
    (dolist (field fields)
      (let ((argument (record-field-named arguments field)))
        (let ((argument-path (list "proposition" "arguments" field)))
        (unless (record-datum-p argument)
          (lci-fail "projection-refusal" "UnnormalizedProposition" "proposition"
                    :path argument-path))
        (require-closed-fields argument '("kind" "schema-version" "placement" "value")
                               "proposition"
                               :key-namespace +proposition-field-namespace+
                               :path-prefix argument-path)
        (unless (%exact-identifier-p (record-field-named argument "kind")
                                     +fixture-identifier-namespace+
                                     '("tag" "proposition-argument"))
          (lci-fail "projection-refusal" "UnnormalizedProposition" "proposition"
                    :path (append argument-path '("kind"))))
        (unless (exact-zero-p (record-field-named argument "schema-version"))
          (lci-fail "unsupported-version-or-profile" "UnsupportedClaimProfile"
                    "claim-profile"
                    :path (append argument-path '("schema-version"))))
        (let* ((locator (assoc field +proposition-locator-slots+
                              :test #'string=))
               (placement (record-field-named argument "placement")))
          (unless (member (identifier-path-strings placement)
                          '(("proposition-placement"
                             "external-claim-location-locator")
                            ("proposition-placement"
                             "proposition-subject-content")) :test #'equal)
            (lci-fail "projection-refusal" "UnnormalizedProposition"
                      "proposition"
                      :path (append argument-path '("placement"))))
          (unless (equal (identifier-namespace-strings placement)
                         +fixture-identifier-namespace+)
            (lci-fail "projection-refusal" "UnnormalizedProposition"
                      "proposition"
                      :path (append argument-path '("placement"))))
          (let ((value (record-field-named argument "value")))
            (when (and locator
                       (string= (identifier-last placement)
                                "external-claim-location-locator"))
              (%validate-proposition-locator-slot
               value locator (append argument-path '("value"))))
            (when (and (string= field "embedded-proposition")
                       (record-datum-p value))
              (normalize-proposition value))))
        (reject-unknown-fields
         argument '("kind" "schema-version" "placement" "value")
         "proposition" :key-namespace +proposition-field-namespace+
         :path-prefix argument-path))))
    (reject-unknown-fields arguments fields "proposition"
                           :key-namespace +proposition-argument-namespace+
                           :path-prefix '("proposition" "arguments")))
  (reject-unknown-fields proposition '("kind" "schema-version" "form" "arguments")
                         "proposition"
                         :key-namespace +proposition-field-namespace+
                         :path-prefix '("proposition"))
  (copy-datum-through-cd0 proposition))

(defun normalize-proposition (proposition &key budget)
  (with-lci-structural-budgets (proposition "normalization")
    (let* ((normalized (%normalize-proposition-unbudgeted proposition
                                                          :budget budget))
           (work (+ (%subtree-node-count proposition)
                    (%subtree-node-count normalized))))
      (when (> work 10000)
        (lci-fail "resource-refusal" "PropositionNormalizationWorkExceeded"
                  (or *lci-resource-phase* "normalization")
                  :path '("proposition")))
      normalized)))

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
               (locator-p (assoc field +proposition-locator-slots+
                                 :test #'string=))
               (expected (if locator-p "external-claim-location-locator"
                             "proposition-subject-content")))
          (unless (%exact-identifier-p
                   placement +fixture-identifier-namespace+
                   (list "proposition-placement" expected))
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

(defun %validate-claim-id-unbudgeted (claim &key (path nil))
  (require-closed-fields claim
                         '("kind" "lci-version" "identity-policy" "claim-profile"
                           "proposition" "location")
                         "claim-shape" :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (unless (%exact-identifier-p (record-field-named claim "kind")
                               '("lisp-plus" "lci" "0" "tag")
                               '("claim-id-envelope"))
    (lci-fail "invalid-input" "InvalidClaimRecord" "claim-shape" :path path))
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
    (reject-unknown-fields
     claim '("kind" "lci-version" "identity-policy" "claim-profile"
             "proposition" "location")
     "claim-shape" :key-namespace +lci-field-namespace+ :path-prefix path)
    (proposition-location-consistent-p
     proposition (record-field-named claim "location") :signal-p t))
  (make-lci-value :claim-id claim))

(defun validate-claim-id (claim &key (path nil))
  (with-lci-structural-budgets (claim "validation")
    (%validate-claim-id-unbudgeted claim :path path)))

(defun %project-claim-id-unbudgeted (claim)
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
                               "claim-shape"
                               :key-namespace +lci-field-namespace+)
        (validate-identity-policy (record-field-named claim "identity-policy"))
        (validate-claim-profile (record-field-named claim "claim-profile"))
        (let* ((proposition (normalize-proposition
                             (record-field-named claim "proposition")))
               (location (record-field-named claim "location")))
          (validate-claim-location location)
          (reject-unknown-fields
           claim '("identity-policy" "claim-profile" "proposition" "location")
           "claim-shape" :key-namespace +lci-field-namespace+)
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

(defun project-claim-id (claim)
  (with-lci-structural-budgets (claim "projection")
    (%project-claim-id-unbudgeted claim)))

(defun %loss-invalid (path)
  (%fixture-operation-authorial-gap "represented-loss-validation" path))

(defun %validate-identifier-sequence (value path)
  (unless (sequence-datum-p value) (%loss-invalid path))
  (loop for index below (sequence-datum-length value)
        unless (identifier-datum-p (sequence-datum-ref value index))
          do (%loss-invalid (append path (list (format nil "~D" index)))))
  value)

(defun %validate-reference-sequence (value domain path)
  (unless (sequence-datum-p value) (%loss-invalid path))
  (loop for index below (sequence-datum-length value)
        do (%validate-stable-ref-domain
            (sequence-datum-ref value index) domain
            (append path (list (format nil "~D" index)))))
  value)

(defun %validate-loss-account (account path)
  (unless (record-datum-p account) (%loss-invalid path))
  (let* ((account-schema (record-field-named account "account-schema"))
         (schema-path (and (identifier-datum-p account-schema)
                           (identifier-path-strings account-schema)))
         (operation (and (equal (identifier-namespace-strings account-schema)
                                +fixture-identifier-namespace+)
                         (= (length schema-path) 3)
                         (string= (first schema-path)
                                  "represented-loss-account-schema")
                         (string= (third schema-path) "0")
                         (second schema-path)))
         (fields (cdr (assoc operation +loss-account-fields+ :test #'string=))))
    (unless fields
      (lci-fail "unsupported-version-or-profile"
                "UnsupportedRepresentedLossAccountSchema" "represented-loss"
                :path (append path '("account-schema"))))
    (require-closed-fields account fields "represented-loss"
                           :key-namespace +fixture-field-namespace+
                           :path-prefix path)
    (unless (%exact-identifier-p (record-field-named account "kind")
                                 +fixture-identifier-namespace+
                                 '("tag" "represented-loss-account"))
      (%loss-invalid (append path '("kind"))))
    (unless (exact-zero-p (record-field-named account "schema-version"))
      (lci-fail "unsupported-version-or-profile"
                "RecursiveUnsupportedNestedVersion" "represented-loss"
                :path (append path '("schema-version"))))
    (unless (%exact-identifier-p account-schema +fixture-identifier-namespace+
                                 (list "represented-loss-account-schema"
                                       operation "0"))
      (lci-fail "unsupported-version-or-profile"
                "UnsupportedRepresentedLossAccountSchema" "represented-loss"
                :path (append path '("account-schema"))))
    (labels ((id-field (name)
               (unless (identifier-datum-p (record-field-named account name))
                 (%loss-invalid (append path (list name)))))
             (bool-field (name)
               (unless (boolean-datum-p (record-field-named account name))
                 (%loss-invalid (append path (list name)))))
             (int-field (name)
               (unless (integer-datum-p (record-field-named account name))
                 (%loss-invalid (append path (list name)))))
             (id-seq (name)
               (%validate-identifier-sequence
                (record-field-named account name) (append path (list name))))
             (ref-field (name domain)
               (%validate-stable-ref-domain
                (record-field-named account name) domain
                (append path (list name))))
             (ref-seq (name domain)
               (%validate-reference-sequence
                (record-field-named account name) domain
                (append path (list name)))))
      (cond
        ((string= operation "v1-migration")
         (id-field "source-format") (ref-field "adapter" "procedure")
         (id-seq "recovered-dimensions") (id-seq "unresolved-dimensions")
         (ref-seq "mapping-receipts" "artifact") (id-field "classification"))
        ((string= operation "translation")
         (id-field "source-language") (id-field "target-language")
         (id-seq "lost-features") (id-seq "preserved-features")
         (bool-field "ambiguity-resolved")
         (ref-field "translation-receipt" "artifact"))
        ((string= operation "reconstruction")
         (ref-seq "source-fragments" "artifact") (id-seq "recovered-fields")
         (id-seq "unresolved-fields")
         (ref-field "reconstruction-procedure" "procedure")
         (id-field "confidence-class"))
        ((string= operation "compaction")
         (id-seq "removed-metadata-fields") (id-seq "retained-identity-fields")
         (bool-field "reversible")
         (ref-field "compaction-procedure" "procedure"))
        ((string= operation "identifier-mapping")
         (unless (datum-p (record-field-named account "source-identifier"))
           (%loss-invalid (append path '("source-identifier"))))
         (id-field "mapped-identifier") (ref-field "mapping-table" "artifact")
         (id-field "mapping-class") (int-field "candidate-count"))
        ((string= operation "temporal-role-classification")
         (id-field "source-site")
         (unless (datum-p (record-field-named account "source-value"))
           (%loss-invalid (append path '("source-value"))))
         (id-field "selected-role")
         (ref-field "classification-table" "artifact")
         (id-field "ambiguity-class"))
        ((string= operation "handoff")
         (ref-field "predecessor-occurrence" "artifact")
         (ref-field "handoff-receipt" "artifact")
         (bool-field "live-authority-transferred")
         (bool-field "custody-continuity-proven")
         (int-field "successor-live-warrants")
         (ref-field "handoff-procedure" "procedure"))))
    (reject-unknown-fields account fields "represented-loss"
                           :key-namespace +fixture-field-namespace+
                           :path-prefix path)
    operation))

(defparameter +loss-operation-coherence+
  '(("migrate-v1" "v1-migration" ("source-record-field-order")
     "identity-neutral-loss")
    ("translate" "translation" ("lexical-sense-resolution")
     "semantic-translation-loss")
    ("handoff" "handoff" ("live-authority" "custody-continuity")
     "authority-or-custody-loss")))

(defun %stable-ref-object-last (reference)
  (identifier-last
   (record-field-named (record-field-named reference "material") "object-id")))

(defun validate-represented-loss (loss &key (path '("represented-loss")))
  (require-closed-fields loss
                         '("kind" "schema-version" "operation" "source"
                           "lost-dimensions" "consequence" "account")
                         "represented-loss" :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (unless (%exact-identifier-p (record-field-named loss "kind")
                               '("lisp-plus" "lci" "0" "tag")
                               '("represented-loss"))
    (%loss-invalid (append path '("kind"))))
  (unless (exact-zero-p (record-field-named loss "schema-version"))
    (lci-fail "unsupported-version-or-profile" "RecursiveUnsupportedNestedVersion"
              "represented-loss" :path (append path '("schema-version"))))
  (let* ((operation-ref (record-field-named loss "operation"))
         (source (record-field-named loss "source")))
    (%validate-stable-ref-domain operation-ref "procedure"
                                 (append path '("operation")))
    (%validate-stable-ref-domain source "artifact" (append path '("source")))
    (let ((dimensions (record-field-named loss "lost-dimensions")))
      (%validate-identifier-sequence dimensions (append path '("lost-dimensions")))
      (loop for index below (sequence-datum-length dimensions)
            for dimension = (sequence-datum-ref dimensions index)
            unless (and (equal (identifier-namespace-strings dimension)
                               +fixture-identifier-namespace+)
                        (= (length (identifier-path-strings dimension)) 2)
                        (string= (first (identifier-path-strings dimension))
                                 "lost-dimension"))
              do (%loss-invalid (append path
                                        (list "lost-dimensions"
                                              (format nil "~D" index))))))
    (let ((consequence (record-field-named loss "consequence")))
      (unless (and (identifier-datum-p consequence)
                   (equal (identifier-namespace-strings consequence)
                          '("lisp-plus" "lci" "0" "relation"))
                   (= (length (identifier-path-strings consequence)) 1))
        (%loss-invalid (append path '("consequence")))))
    (let* ((account-operation (%validate-loss-account
                               (record-field-named loss "account")
                               (append path '("account"))))
           (operation-name (%stable-ref-object-last operation-ref))
           (coherence (assoc operation-name +loss-operation-coherence+
                             :test #'string=)))
      (unless (and coherence (string= account-operation (second coherence)))
        (%loss-invalid (append path '("account" "account-schema"))))
      (let ((actual-dimensions
              (loop with dimensions = (record-field-named loss "lost-dimensions")
                    for index below (sequence-datum-length dimensions)
                    collect (identifier-last (sequence-datum-ref dimensions index)))))
        (unless (equal actual-dimensions (third coherence))
          (%loss-invalid (append path '("lost-dimensions"))))
        (unless (string= (identifier-last (record-field-named loss "consequence"))
                         (fourth coherence))
          (%loss-invalid (append path '("consequence")))))
    (reject-unknown-fields
     loss '("kind" "schema-version" "operation" "source" "lost-dimensions"
            "consequence" "account")
     "represented-loss" :key-namespace +lci-field-namespace+ :path-prefix path))
  (make-lci-value :represented-loss loss)))

(defun validate-claim-lineage-edge (edge &key (path '("lineage")))
  (require-closed-fields
   edge '("kind" "schema-version" "relation" "source-occurrence"
          "destination-occurrence" "source-claim" "destination-claim"
          "receipt" "represented-loss")
   "lineage" :key-namespace +lci-field-namespace+ :path-prefix path)
  (unless (and (%exact-identifier-p (record-field-named edge "kind")
                                    '("lisp-plus" "lci" "0" "tag")
                                    '("claim-lineage-edge"))
               (exact-zero-p (record-field-named edge "schema-version"))
               (let ((relation (record-field-named edge "relation")))
                 (and (identifier-datum-p relation)
                      (equal (identifier-namespace-strings relation)
                             '("lisp-plus" "lci" "0" "relation"))))
               (record-datum-p (record-field-named edge "receipt")))
    (%fixture-operation-authorial-gap "claim-lineage-edge-validation" path))
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
      (%fixture-operation-authorial-gap
       "claim-lineage-edge-validation" (append path '("represented-loss"))))
    (loop for index below (sequence-datum-length losses)
          do (validate-represented-loss
              (sequence-datum-ref losses index)
              :path (append path (list "represented-loss"
                                       (format nil "~D" index))))))
  (reject-unknown-fields
   edge '("kind" "schema-version" "relation" "source-occurrence"
          "destination-occurrence" "source-claim" "destination-claim"
          "receipt" "represented-loss")
   "lineage" :key-namespace +lci-field-namespace+ :path-prefix path)
  (make-lci-value :claim-lineage-edge edge))

(defun %validate-evidence-event-time (value expected-role path)
  (require-closed-fields value
                         '("kind" "schema-version" "temporal-model"
                           "expression" "temporal-role")
                         "target-boundaries"
                         :key-namespace +fixture-field-namespace+
                         :path-prefix path)
  (unless (%exact-identifier-p (record-field-named value "kind")
                               +fixture-identifier-namespace+
                               '("tag" "evidence-event-time"))
    (lci-fail "invalid-input" "InvalidWarrantTarget" "target-boundaries"
              :path (append path '("kind"))))
  (unless (exact-zero-p (record-field-named value "schema-version"))
    (lci-fail "unsupported-version-or-profile"
              "RecursiveUnsupportedNestedVersion" "target-boundaries"
              :path (append path '("schema-version"))))
  (%validate-exact-fixture-reference
   (record-field-named value "temporal-model") "temporal-model"
   '("mneme-fixture-time") 0 (append path '("temporal-model")))
  (let ((expression (record-field-named value "expression")))
    (%validate-versioned-expression expression +temporal-form-fields+
                                    "InvalidWarrantTarget" "target-boundaries"
                                    (append path '("expression"))
                                    :kind "temporal-expression"
                                    :form-category "temporal-form")
    (%finish-versioned-expression expression +temporal-form-fields+
                                  "target-boundaries"
                                  (append path '("expression"))))
  (unless (%exact-identifier-p (record-field-named value "temporal-role")
                               +fixture-identifier-namespace+
                               (list "temporal-role" expected-role))
    (lci-fail "target-mismatch" "TargetBoundaryMismatch" "target-boundaries"
              :path (append path '("temporal-role"))))
  (reject-unknown-fields
   value '("kind" "schema-version" "temporal-model" "expression"
           "temporal-role")
   "target-boundaries" :key-namespace +fixture-field-namespace+
   :path-prefix path)
  value)

(defun %validate-lci-failure-datum (failure path)
  (require-closed-fields failure
                         '("kind" "schema-version" "category" "code" "stage"
                           "path" "context")
                         "target-boundaries" :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (unless (%exact-identifier-p (record-field-named failure "kind")
                               '("lisp-plus" "lci" "0" "tag") '("failure"))
    (lci-fail "invalid-input" "InvalidWarrantTarget" "target-boundaries"
              :path (append path '("kind"))))
  (unless (exact-zero-p (record-field-named failure "schema-version"))
    (lci-fail "unsupported-version-or-profile"
              "RecursiveUnsupportedNestedVersion" "target-boundaries"
              :path (append path '("schema-version"))))
  (dolist (field '("category" "code" "stage"))
    (unless (and (identifier-datum-p (record-field-named failure field))
                 (equal (identifier-namespace-strings
                         (record-field-named failure field))
                        '("lisp-plus" "lci" "0" "failure")))
      (lci-fail "invalid-input" "InvalidWarrantTarget" "target-boundaries"
                :path (append path (list field)))))
  (let ((failure-path (record-field-named failure "path")))
    (unless (and (sequence-datum-p failure-path)
                 (loop for index below (sequence-datum-length failure-path)
                       always (let ((part (sequence-datum-ref failure-path index)))
                                (or (identifier-datum-p part)
                                    (integer-datum-p part)))))
      (lci-fail "invalid-input" "InvalidWarrantTarget" "target-boundaries"
                :path (append path '("path")))))
  (unless (record-datum-p (record-field-named failure "context"))
    (lci-fail "invalid-input" "InvalidWarrantTarget" "target-boundaries"
              :path (append path '("context"))))
  (reject-unknown-fields
   failure '("kind" "schema-version" "category" "code" "stage" "path"
             "context")
   "target-boundaries" :key-namespace +lci-field-namespace+
   :path-prefix path)
  failure)

(defun %validate-target-relation-result (result path)
  (require-record result "InvalidWarrantTarget" "target-boundaries" path)
  (unless (%exact-identifier-p (record-field-named result "kind")
                               +fixture-identifier-namespace+
                               '("tag" "target-relation-result"))
    (lci-fail "invalid-input" "InvalidWarrantTarget" "target-boundaries"
              :path (append path '("kind"))))
  (unless (exact-zero-p (record-field-named result "schema-version"))
    (lci-fail "unsupported-version-or-profile"
              "RecursiveUnsupportedNestedVersion" "target-boundaries"
              :path (append path '("schema-version"))))
  (let ((status (record-field-named result "status")))
    (cond
      ((%exact-identifier-p status +fixture-identifier-namespace+
                            '("result-status" "success"))
       (require-closed-fields result '("kind" "schema-version" "status" "relation")
                              "target-boundaries"
                              :key-namespace +fixture-field-namespace+
                              :path-prefix path)
       (unless (member (identifier-path-strings
                        (record-field-named result "relation"))
                       '(("exact-target")
                         ("supports-by-scope-narrowing")) :test #'equal)
         (lci-fail "invalid-input" "InvalidWarrantTarget" "target-boundaries"
                   :path (append path '("relation"))))
       (unless (equal (identifier-namespace-strings
                       (record-field-named result "relation"))
                      '("lisp-plus" "lci" "0" "relation"))
         (lci-fail "invalid-input" "InvalidWarrantTarget" "target-boundaries"
                   :path (append path '("relation"))))
       (reject-unknown-fields result '("kind" "schema-version" "status" "relation")
                              "target-boundaries"
                              :key-namespace +fixture-field-namespace+
                              :path-prefix path))
      ((%exact-identifier-p status +fixture-identifier-namespace+
                            '("result-status" "failure"))
       (require-closed-fields result '("kind" "schema-version" "status" "failure")
                              "target-boundaries"
                              :key-namespace +fixture-field-namespace+
                              :path-prefix path)
       (%validate-lci-failure-datum (record-field-named result "failure")
                                    (append path '("failure")))
       (reject-unknown-fields result '("kind" "schema-version" "status" "failure")
                              "target-boundaries"
                              :key-namespace +fixture-field-namespace+
                              :path-prefix path))
      (t
       (lci-fail "invalid-input" "InvalidWarrantTarget" "target-boundaries"
                 :path (append path '("status"))))))
  result)

(defun %validate-target-schema-pair (schema kind path)
  (%validate-stable-ref-domain schema "module" path)
  (unless (%stable-ref-material-exact-p
           schema "module" (list "target-schema" kind) 0)
    (lci-fail "invalid-input" "TargetSchemaKindMismatch" "target-schema"
              :path path))
  schema)

(defun %validate-target-boundary-value (descriptor value path)
  (case (second descriptor)
    (stable-ref
     (%validate-stable-ref-domain value (third descriptor) path))
    (event-time
     (%validate-evidence-event-time value (third descriptor) path))
    (scope
     (validate-scope value :path path))
    (identifier
     (unless (identifier-datum-p value)
       (lci-fail "invalid-input" "InvalidWarrantTarget" "target-boundaries"
                 :path path)))
    (datum
     (unless (datum-p value)
       (lci-fail "invalid-input" "InvalidWarrantTarget" "target-boundaries"
                 :path path)))
    (claim-id-sequence
     (unless (sequence-datum-p value)
       (lci-fail "invalid-input" "InvalidWarrantTarget" "target-boundaries"
                 :path path))
     (loop for index below (sequence-datum-length value)
           do (validate-claim-id (sequence-datum-ref value index)
                                 :path (append path (list (format nil "~D" index))))))
    (corpus-basis
     (validate-corpus-basis value :path path))
    (proposition
     (normalize-proposition value))
    (semantic-boundary
     (validate-semantic-boundary value :path path))
    (represented-loss
     (validate-represented-loss value :path path))
    (claim-id
     (validate-claim-id value :path path))
    (interpretation-frame
     (validate-interpretation-frame value :path path))
    (target-relation-result
     (%validate-target-relation-result value path))
    (otherwise
     (internal-integrity-fail "target-schema" "UnknownTargetBoundaryType"
                              "internal" :path path)))
  value)

(defun %validate-target-cross-field-coherence (target path)
  (let* ((kind (identifier-last (record-field-named target "target-kind")))
         (claim (record-field-named target "claim"))
         (boundaries (record-field-named target "boundaries")))
    (when (string= kind "corpus-completion")
      (let* ((claim-location (record-field-named claim "location"))
             (claim-basis (record-field-named claim-location "basis"))
             (claim-proposition (record-field-named claim "proposition"))
             (exact-basis (record-field-named boundaries "exact-corpus-basis"))
             (query (record-field-named boundaries
                                        "query-or-search-expression"))
             (completion (record-field-named boundaries "completion-boundary")))
        (unless (equal-datum exact-basis claim-basis)
          (lci-fail "target-mismatch" "BasisMismatch" "target-boundaries"
                    :path (append path
                                  '("boundaries" "exact-corpus-basis"))))
        (unless (equal-datum query claim-proposition)
          (lci-fail "target-mismatch" "TargetBoundaryMismatch"
                    "target-boundaries"
                    :path (append path
                                  '("boundaries"
                                    "query-or-search-expression"))))
        (unless (equal-datum completion
                             (record-field-named claim-basis
                                                 "semantic-boundary"))
          (lci-fail "target-mismatch" "TargetBoundaryMismatch"
                    "target-boundaries"
                    :path (append path
                                  '("boundaries" "completion-boundary")))))))
  target)

(defun %validate-warrant-target-unbudgeted (target &key (path nil))
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
                         "target-shape" :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (unless (%exact-identifier-p (record-field-named target "kind")
                               '("lisp-plus" "lci" "0" "tag")
                               '("warrant-target"))
    (lci-fail "invalid-input" "InvalidWarrantTarget" "target-shape" :path path))
  (unless (exact-zero-p (record-field-named target "lci-version"))
    (lci-fail "unsupported-version-or-profile" "UnsupportedLCIVersion"
              "lci-version" :path (append path '("lci-version"))))
  (let* ((kind-id (record-field-named target "target-kind"))
         (kind (identifier-last kind-id))
         (fields (cdr (assoc kind +target-boundary-fields+ :test #'string=)))
         (types (cdr (assoc kind +target-boundary-types+ :test #'string=)))
         (boundaries (record-field-named target "boundaries")))
    (unless (and fields types
                 (%exact-identifier-p kind-id +fixture-identifier-namespace+
                                      (list "target-kind" kind)))
      (lci-fail "unsupported-version-or-profile" "UnsupportedTargetKind"
                "target-shape"
                :path (append path '("target-kind"))))
    (%validate-target-schema-pair (record-field-named target "target-schema")
                                  kind (append path '("target-schema")))
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
                           :key-namespace +fixture-field-namespace+
                           :path-prefix (append path '("boundaries")))
    ;; The fixture negative executed witness uses a mutable procedure/code
    ;; identity in this exact boundary position.
    (when (and (member kind '("executed" "replayed") :test #'string=)
               (let ((code (record-field-named boundaries
                                                "immutable-code-or-semantics")))
                 (and code (not (exact-kind-p code "stable-reference")))))
      (lci-fail "reference-refusal" "ProcedureIdentityInsufficient"
                "target-boundaries"
                :path (append path '("boundaries" "immutable-code-or-semantics"))))
    (dolist (descriptor types)
      (let ((field (first descriptor)))
        (%validate-target-boundary-value
         descriptor (record-field-named boundaries field)
         (append path (list "boundaries" field)))))
    (reject-unknown-fields boundaries fields "target-boundaries"
                           :unknown-code "TargetBoundaryUnknown"
                           :key-namespace +fixture-field-namespace+
                           :path-prefix (append path '("boundaries"))))
  (reject-unknown-fields
   target '("kind" "lci-version" "target-kind" "target-schema" "claim"
            "boundaries")
   "target-shape" :key-namespace +lci-field-namespace+ :path-prefix path)
  (%validate-target-cross-field-coherence target path)
  (make-lci-value :warrant-target target))

(defun validate-warrant-target (target &key (path nil))
  (with-lci-structural-budgets (target "validation")
    (%validate-warrant-target-unbudgeted target :path path)))

(defun %validate-occurrence-provenance (value path)
  (unless (sequence-datum-p value)
    (lci-fail "invalid-input" "InvalidClaimRecord" "claim-shape" :path path))
  (loop for index below (sequence-datum-length value)
        for entry = (sequence-datum-ref value index)
        for entry-path = (append path (list (format nil "~D" index)))
        do (require-closed-fields entry
                                  '("kind" "schema-version" "provenance-kind"
                                    "artifact" "note")
                                  "claim-shape"
                                  :key-namespace +fixture-field-namespace+
                                  :path-prefix entry-path)
           (unless (and
                    (%exact-identifier-p (record-field-named entry "kind")
                                         +fixture-identifier-namespace+
                                         '("tag" "provenance-entry"))
                    (exact-zero-p (record-field-named entry "schema-version"))
                    (let ((provenance-kind
                            (record-field-named entry "provenance-kind")))
                      (and (equal (identifier-namespace-strings provenance-kind)
                                  +fixture-identifier-namespace+)
                           (member (identifier-path-strings provenance-kind)
                                   '(("provenance-kind" "source-artifact")
                                     ("provenance-kind" "correction"))
                                   :test #'equal))))
             (lci-fail "invalid-input" "InvalidClaimRecord" "claim-shape"
                       :path entry-path))
           (%validate-stable-ref-domain
            (record-field-named entry "artifact") "artifact"
            (append entry-path '("artifact")))
           (unless (string-datum-p (record-field-named entry "note"))
             (lci-fail "invalid-input" "InvalidClaimRecord" "claim-shape"
                       :path (append entry-path '("note"))))
           (reject-unknown-fields
            entry '("kind" "schema-version" "provenance-kind" "artifact" "note")
            "claim-shape" :key-namespace +fixture-field-namespace+
            :path-prefix entry-path))
  value)

(defun %validate-occurrence-lineage (value path)
  (unless (sequence-datum-p value)
    (lci-fail "invalid-input" "InvalidClaimRecord" "claim-shape" :path path))
  (loop for index below (sequence-datum-length value)
        for entry = (sequence-datum-ref value index)
        for entry-path = (append path (list (format nil "~D" index)))
        do (require-closed-fields entry
                                  '("kind" "schema-version" "relation"
                                    "predecessor")
                                  "claim-shape"
                                  :key-namespace +fixture-field-namespace+
                                  :path-prefix entry-path)
           (unless (and
                    (%exact-identifier-p (record-field-named entry "kind")
                                         +fixture-identifier-namespace+
                                         '("tag" "lineage-entry"))
                    (exact-zero-p (record-field-named entry "schema-version"))
                    (let ((relation (record-field-named entry "relation")))
                      (and (equal (identifier-namespace-strings relation)
                                  +fixture-identifier-namespace+)
                           (member (identifier-path-strings relation)
                                   '(("lineage-relation"
                                      "independent-reassertion")
                                     ("lineage-relation" "corrects"))
                                   :test #'equal))))
             (lci-fail "invalid-input" "InvalidClaimRecord" "claim-shape"
                       :path entry-path))
           (%validate-stable-ref-domain
            (record-field-named entry "predecessor") "artifact"
            (append entry-path '("predecessor")))
           (reject-unknown-fields entry
                                  '("kind" "schema-version" "relation"
                                    "predecessor")
                                  "claim-shape"
                                  :key-namespace +fixture-field-namespace+
                                  :path-prefix entry-path))
  value)

(defun %validate-occurrence-presentation (value path)
  (require-closed-fields value '("kind" "schema-version" "title" "surface")
                         "claim-shape" :key-namespace +fixture-field-namespace+
                         :path-prefix path)
  (unless (and (%exact-identifier-p (record-field-named value "kind")
                                    +fixture-identifier-namespace+
                                    '("tag" "claim-presentation"))
               (exact-zero-p (record-field-named value "schema-version"))
               (string-datum-p (record-field-named value "title"))
               (string-datum-p (record-field-named value "surface")))
    (lci-fail "invalid-input" "InvalidClaimRecord" "claim-shape" :path path))
  (reject-unknown-fields value '("kind" "schema-version" "title" "surface")
                         "claim-shape" :key-namespace +fixture-field-namespace+
                         :path-prefix path)
  value)

(defun %validate-occurrence-metadata (value path)
  (require-closed-fields value '("kind" "schema-version" "metadata-schema"
                                 "entries")
                         "claim-shape" :key-namespace +fixture-field-namespace+
                         :path-prefix path)
  (unless (and
           (%exact-identifier-p (record-field-named value "kind")
                                +fixture-identifier-namespace+
                                '("tag" "nonidentity-metadata"))
           (exact-zero-p (record-field-named value "schema-version"))
           (%exact-identifier-p (record-field-named value "metadata-schema")
                                +fixture-identifier-namespace+
                                '("metadata-schema" "open-inert-nonidentity" "0"))
           (record-datum-p (record-field-named value "entries")))
    (lci-fail "invalid-input" "InvalidClaimRecord" "claim-shape" :path path))
  ;; entries is the one explicitly open path.  CD/0 already guarantees that
  ;; every key is an Identifier and every value is an inert datum.
  (reject-unknown-fields value '("kind" "schema-version" "metadata-schema"
                                 "entries")
                         "claim-shape" :key-namespace +fixture-field-namespace+
                         :path-prefix path)
  value)

(defun validate-claim-occurrence (occurrence &key (path nil))
  (let ((fields '("kind" "schema-version" "semantic-claim-core" "claimant"
                  "assertion-time" "provenance" "lineage" "cached-claim-id"
                  "presentation" "nonidentity-metadata")))
    (require-closed-fields occurrence fields "claim-shape"
                           :key-namespace +fixture-field-namespace+
                           :path-prefix path)
    (unless (%exact-identifier-p (record-field-named occurrence "kind")
                                 +fixture-identifier-namespace+
                                 '("tag" "full-claim-occurrence"))
      (lci-fail "invalid-input" "InvalidClaimRecord" "claim-shape"
                :path (append path '("kind"))))
    (unless (exact-zero-p (record-field-named occurrence "schema-version"))
      (lci-fail "unsupported-version-or-profile"
                "RecursiveUnsupportedNestedVersion" "claim-shape"
                :path (append path '("schema-version"))))
    (let ((projected (project-claim-id
                      (record-field-named occurrence "semantic-claim-core"))))
      (%validate-stable-ref-domain
       (record-field-named occurrence "claimant") "principal"
       (append path '("claimant")))
      (%validate-evidence-event-time
       (record-field-named occurrence "assertion-time") "assertion-time"
       (append path '("assertion-time")))
      (%validate-occurrence-provenance
       (record-field-named occurrence "provenance") (append path '("provenance")))
      (%validate-occurrence-lineage
       (record-field-named occurrence "lineage") (append path '("lineage")))
      (let ((cached (record-field-named occurrence "cached-claim-id")))
        (validate-claim-id cached :path (append path '("cached-claim-id")))
        (%validate-occurrence-presentation
         (record-field-named occurrence "presentation")
         (append path '("presentation")))
        (%validate-occurrence-metadata
         (record-field-named occurrence "nonidentity-metadata")
         (append path '("nonidentity-metadata")))
        (reject-unknown-fields occurrence fields "claim-shape"
                               :key-namespace +fixture-field-namespace+
                               :path-prefix path)
        (unless (equal-datum projected cached)
          (lci-fail "projection-refusal" "ClaimIdCacheMismatch" "claim-id-cache"
                    :path (append path '("cached-claim-id"))))))
    (make-lci-value :claim-occurrence occurrence)))

(defparameter +migration-result-fields+
  '("kind" "schema-version" "source" "adapter" "classification" "claim"
    "claim-id" "lineage" "represented-loss" "legacy-testimony"
    "live-warrants-created"))

(defparameter +migration-classifications+
  '("exact" "exact-after-explicit-tagging" "new-identity-required"
    "lossy-with-represented-loss" "rejected"
    "deferred-to-named-calculus"
    "privileged-runtime-relation-outside-claim-id"))

(defun %migration-result-invalid (path)
  (%fixture-operation-authorial-gap "migration-result-validation" path))

(defun %validate-migration-claim-core (claim path)
  (let ((fields '("proposition" "location")))
    (require-closed-fields claim fields "migration-result"
                           :key-namespace +fixture-field-namespace+
                           :path-prefix path)
    (let* ((proposition (record-field-named claim "proposition"))
           (normalized (normalize-proposition proposition))
           (location (record-field-named claim "location")))
      ;; MigrationResult/0 contains already-normalized, validated semantic
      ;; claim data.  Normalization is a validator here, not a repair step.
      (unless (equal-datum proposition normalized)
        (%migration-result-invalid
         (append path '("fixture-field:proposition"))))
      (validate-claim-location location :path (append path '("location")))
      (proposition-location-consistent-p proposition location :signal-p t)
      (reject-unknown-fields claim fields "migration-result"
                             :key-namespace +fixture-field-namespace+
                             :path-prefix path))
    claim))

(defun %validate-migration-lineage (lineage source path)
  (unless (sequence-datum-p lineage) (%migration-result-invalid path))
  (loop for index below (sequence-datum-length lineage)
        for entry = (sequence-datum-ref lineage index)
        for entry-path = (append path (list (format nil "~D" index)))
        do (require-closed-fields entry '("relation" "source")
                                  "migration-result"
                                  :key-namespace +fixture-field-namespace+
                                  :path-prefix entry-path)
           (unless (%exact-identifier-p
                    (record-field-named entry "relation")
                    +fixture-identifier-namespace+
                    '("lineage-relation" "migration"))
             (%migration-result-invalid
              (append entry-path '("fixture-field:relation"))))
           (%validate-stable-ref-domain
            (record-field-named entry "source") "artifact"
            (append entry-path '("source")))
           (reject-unknown-fields entry '("relation" "source")
                                  "migration-result"
                                  :key-namespace +fixture-field-namespace+
                                  :path-prefix entry-path)
           (unless (equal-datum (record-field-named entry "source") source)
             (%migration-result-invalid
              (append entry-path '("fixture-field:source")))))
  lineage)

(defun %validate-migration-testimony (testimony path)
  (unless (sequence-datum-p testimony) (%migration-result-invalid path))
  (loop for index below (sequence-datum-length testimony)
        for entry = (sequence-datum-ref testimony index)
        for entry-path = (append path (list (format nil "~D" index)))
        do (require-closed-fields entry '("kind" "artifact")
                                  "migration-result"
                                  :key-namespace +fixture-field-namespace+
                                  :path-prefix entry-path)
           (unless (%exact-identifier-p
                    (record-field-named entry "kind")
                    +fixture-identifier-namespace+
                    '("legacy-testimony" "predecessor-warrant"))
             (%migration-result-invalid
              (append entry-path '("fixture-field:kind"))))
           (%validate-stable-ref-domain
            (record-field-named entry "artifact") "artifact"
            (append entry-path '("fixture-field:artifact")))
           (reject-unknown-fields entry '("kind" "artifact")
                                  "migration-result"
                                  :key-namespace +fixture-field-namespace+
                                  :path-prefix entry-path))
  testimony)

(defun validate-migration-result (result &key (path nil))
  ;; E6 ordering: missing required fields first; then recursively validate
  ;; present fields in declared order; then unknown keys; finally coherence.
  (require-closed-fields result +migration-result-fields+ "migration-result"
                         :key-namespace +lci-field-namespace+
                         :path-prefix path)
  (unless (%exact-identifier-p (record-field-named result "kind")
                               '("lisp-plus" "lci" "0" "tag")
                               '("migration-result"))
    (%migration-result-invalid (append path '("kind"))))
  (unless (exact-zero-p (record-field-named result "schema-version"))
    (lci-fail "unsupported-version-or-profile"
              "RecursiveUnsupportedNestedVersion" "migration-result"
              :path (append path '("schema-version"))))
  (let* ((source (record-field-named result "source"))
         (adapter (record-field-named result "adapter"))
         (classification-id (record-field-named result "classification"))
         (classification
           (and (identifier-datum-p classification-id)
                (equal (identifier-namespace-strings classification-id)
                       +fixture-identifier-namespace+)
                (= (length (identifier-path-strings classification-id)) 2)
                (string= (first (identifier-path-strings classification-id))
                         "migration-classification")
                (second (identifier-path-strings classification-id))))
         (claim (record-field-named result "claim"))
         (claim-id (record-field-named result "claim-id"))
         (lineage (record-field-named result "lineage"))
         (losses (record-field-named result "represented-loss"))
         (testimony (record-field-named result "legacy-testimony"))
         (live (record-field-named result "live-warrants-created")))
    (%validate-stable-ref-domain source "artifact" (append path '("source")))
    (%validate-stable-ref-domain adapter "procedure" (append path '("adapter")))
    (unless (%stable-ref-material-exact-p adapter "procedure" '("migrate-v1") 0)
      (%migration-result-invalid (append path '("adapter"))))
    (unless (member classification +migration-classifications+ :test #'string=)
      (%migration-result-invalid (append path '("classification"))))
    (%validate-migration-claim-core claim (append path '("claim")))
    (validate-claim-id claim-id :path (append path '("claim-id")))
    (%validate-migration-lineage lineage source (append path '("lineage")))
    (unless (sequence-datum-p losses)
      (%migration-result-invalid (append path '("represented-loss"))))
    (loop for index below (sequence-datum-length losses)
          do (validate-represented-loss
              (sequence-datum-ref losses index)
              :path (append path (list "represented-loss"
                                       (format nil "~D" index)))))
    (%validate-migration-testimony testimony
                                   (append path '("legacy-testimony")))
    (unless (boolean-datum-p live)
      (%migration-result-invalid (append path '("live-warrants-created"))))
    (when (boolean-datum-value live)
      (lci-fail "privilege-refusal" "PrivilegedRestorationAttempt"
                "privilege-boundary"
                :path (append path '("live-warrants-created"))))
    (reject-unknown-fields result +migration-result-fields+ "migration-result"
                           :key-namespace +lci-field-namespace+
                           :path-prefix path)
    ;; Recompute from the semantic core and the validated profile coordinates;
    ;; a cached/self-declared envelope is never trusted.
    (let ((projected
            (project-claim-id
             (make-lci-record
              (list "identity-policy"
                    (record-field-named claim-id "identity-policy"))
              (list "claim-profile"
                    (record-field-named claim-id "claim-profile"))
              (list "proposition" (record-field-named claim "proposition"))
              (list "location" (record-field-named claim "location"))))))
      (unless (equal-datum projected claim-id)
        (lci-fail "projection-refusal" "ClaimIdCacheMismatch"
                  "claim-id-cache" :path (append path '("claim-id")))))
    (when (and (member classification
                       '("lossy-with-represented-loss"
                         "privileged-runtime-relation-outside-claim-id")
                       :test #'string=)
               (zerop (sequence-datum-length losses)))
      (lci-fail "migration-refusal" "RepresentedLossRequired"
                "represented-loss"
                :path (append path '("represented-loss"))))
    ;; The packet freezes field closure/types, live=false, and the N028
    ;; one-way represented-loss requirement.  It does not freeze an inverse
    ;; classification/testimony matrix; testimony therefore remains inert data
    ;; here and is not inferred from, or used to rewrite, classification.)
    )
  (make-lci-value :migration-result result))
