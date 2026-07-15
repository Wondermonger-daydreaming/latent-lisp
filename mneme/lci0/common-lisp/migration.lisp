(in-package #:lisp-plus-lci0)

;;; Frozen v1 migration fixtures only.  No Common Lisp reader, package lookup,
;;; symbol interning, legacy procedure, registry lookup, or live warrant path is
;;; reachable from this module.

(defparameter +legacy-source-fields+
  '("kind" "schema-version" "source-artifact" "source-bytes" "grammar"
    "parse-expected" "parsed-inert-value"))

(defparameter +legacy-record-fields+
  '("kind" "schema-version" "fixture-name" "source-record-site"
    "proposition" "fingerprint" "as-of" "scope-token" "corpus-token"
    "frame-token" "predecessor-warrants" "attempt-live-restoration"))

(defparameter +legacy-fixture-names+
  '("as-of-ambiguous" "attempt-live-restoration" "corpus-r4"
    "inert-predecessor-warrant" "near-miss-package" "printer-variation"
    "scope-tenant-b" "semantic-wrong-mapping" "time-100" "time-124"))

;; Literal transcriptions of the finite package/symbol and as-of tables.  The
;; migration adapter consults no mutable registry.
(defparameter +legacy-package-symbol-map+
  '(("MNEME" "FILE-EXISTS" "proposition-form" "file-exists")
    ("MNEME" "EQUALS" "proposition-form" "exact-equality")
    ("MNEME" "CALL-RESULT-EQUALS" "proposition-form" "call-result-equality")
    ("MNEME" "ALL" "proposition-form" "universal-property-over-scope")
    ("MNEME" "EXISTS" "proposition-form" "existential-property")
    ("MNEME" "AVERAGE" "proposition-form" "average-statistical-value")
    ("MNEME" "BOUNDED-ABSENCE" "proposition-form" "bounded-corpus-absence")
    ("MNEME" "SAYS" "proposition-form" "artifact-contains-says")
    ("MNEME" "RETURNED" "proposition-form" "producer-returned-value")
    ("MNEME" "UNIVERSAL" "scope-form" "universal")
    ("MNEME" "TENANT" "scope-form" "tenant")
    ("MNEME" "SELF-DESCRIBING" "frame-form" "self-describing")))

(defparameter +legacy-as-of-role-map+
  '(("claim" "subject-time" "exact")
    ("observation" "observation-time" "exact")
    ("execution" "execution-time" "exact")
    ("attestation" "issue-time" "exact")
    ("completion" "semantic-boundary-log-horizon" "exact")
    ("standing-query" "query-time" "exact")
    ("judgment" "unclassified" "ambiguous-refuse")))

(defparameter +legacy-bare-literals+
  '("legacy-claim" "legacy-judgment" "tenant-a" "tenant-b" "alpha"
    "t" "inert-warrant-1" "file-exists"))

(defstruct (%legacy-parser-state
            (:constructor %make-legacy-parser-state (text)))
  text (index 0) (nodes 0))

(defun %legacy-source-fail (&optional (path '("fixture-field:source-bytes")))
  (lci-fail "migration-refusal" "UnsupportedLegacyForm" "migration-source"
            :path path))

(defun %legacy-whitespace-p (character)
  (member character '(#\Space #\Tab #\Newline #\Return) :test #'char=))

(defun %legacy-skip-space (state)
  (loop with text = (%legacy-parser-state-text state)
        while (and (< (%legacy-parser-state-index state) (length text))
                   (%legacy-whitespace-p
                    (char text (%legacy-parser-state-index state))))
        do (incf (%legacy-parser-state-index state))))

(defun %legacy-utf8-length (string)
  (length (sb-ext:string-to-octets string :external-format :utf-8)))

(defun %legacy-token-character-p (character)
  (or (alphanumericp character)
      (member character '(#\- #\_ #\* #\+ #\/ #\: #\?) :test #'char=)))

(defun %legacy-integer-token-p (token)
  (and (plusp (length token))
       (let ((start (if (member (char token 0) '(#\+ #\-) :test #'char=)
                        1 0)))
         (and (< start (length token))
              (loop for index from start below (length token)
                    always (digit-char-p (char token index)))))))

(defun %legacy-parse-string (state)
  (let* ((text (%legacy-parser-state-text state))
         (output (make-string-output-stream)))
    (incf (%legacy-parser-state-index state))
    (loop
      (when (>= (%legacy-parser-state-index state) (length text))
        (%legacy-source-fail))
      (let ((character (char text (%legacy-parser-state-index state))))
        (incf (%legacy-parser-state-index state))
        (cond
          ((char= character #\") (return))
          ((char= character #\\)
           (when (>= (%legacy-parser-state-index state) (length text))
             (%legacy-source-fail))
           (let ((escaped (char text (%legacy-parser-state-index state))))
             (incf (%legacy-parser-state-index state))
             (case escaped
               (#\" (write-char #\" output))
               (#\\ (write-char #\\ output))
               (otherwise (%legacy-source-fail)))))
          ((or (char= character #\Newline) (char= character #\Return))
           (%legacy-source-fail))
          (t (write-char character output)))))
    (let ((value (get-output-stream-string output)))
      (when (> (%legacy-utf8-length value) 4096) (%legacy-source-fail))
      (list :string value))))

(defun %legacy-parse-token (state)
  (let* ((text (%legacy-parser-state-text state))
         (start (%legacy-parser-state-index state)))
    (loop while (and (< (%legacy-parser-state-index state) (length text))
                     (%legacy-token-character-p
                      (char text (%legacy-parser-state-index state))))
          do (incf (%legacy-parser-state-index state)))
    (when (= start (%legacy-parser-state-index state)) (%legacy-source-fail))
    (let ((token (subseq text start (%legacy-parser-state-index state))))
      (when (> (%legacy-utf8-length token) 128) (%legacy-source-fail))
      (cond
        ((%legacy-integer-token-p token)
         (list :integer (parse-integer token)))
        ((and (> (length token) 1) (char= (char token 0) #\:)
              (not (find #\: token :start 1)))
         (list :keyword (subseq token 1)))
        ((let ((separator (search "::" token)))
           (and separator
                (plusp separator)
                (< (+ separator 2) (length token))
                (null (search "::" token :start2 (+ separator 2)))
                (progn
                  (return-from %legacy-parse-token
                    (list :qualified (subseq token 0 separator)
                          (subseq token (+ separator 2))))))))
        ((member token +legacy-bare-literals+ :test #'string=)
         (list :bare token))
        (t (%legacy-source-fail))))))

(defun %legacy-parse-node (state depth)
  (when (> depth 32) (%legacy-source-fail))
  (when (> (incf (%legacy-parser-state-nodes state)) 4096)
    (%legacy-source-fail))
  (%legacy-skip-space state)
  (let* ((text (%legacy-parser-state-text state))
         (index (%legacy-parser-state-index state)))
    (when (>= index (length text)) (%legacy-source-fail))
    (case (char text index)
      (#\(
       (incf (%legacy-parser-state-index state))
       (let ((items nil))
         (loop
           (%legacy-skip-space state)
           (when (>= (%legacy-parser-state-index state) (length text))
             (%legacy-source-fail))
           (if (char= (char text (%legacy-parser-state-index state)) #\))
               (progn (incf (%legacy-parser-state-index state))
                      (return (cons :list (nreverse items))))
               (push (%legacy-parse-node state (1+ depth)) items)))))
      (#\" (%legacy-parse-string state))
      ((#\# #\' #\` #\, #\; #\)) (%legacy-source-fail))
      (otherwise (%legacy-parse-token state)))))

(defun %parse-legacy-octets (octets)
  (when (> (length octets) 32768)
    (lci-fail "resource-refusal" "MigrationInputSizeExceeded" "migration"
              :path '("fixture-field:source-bytes")))
  (let ((text (handler-case
                  (sb-ext:octets-to-string octets :external-format :utf-8)
                (error () (%legacy-source-fail)))))
    (let* ((state (%make-legacy-parser-state text))
           (form (%legacy-parse-node state 1)))
      (%legacy-skip-space state)
      (unless (= (%legacy-parser-state-index state) (length text))
        (%legacy-source-fail))
      form)))

(defun %legacy-node-value (node kind)
  (and (consp node) (eq (first node) kind) (second node)))

(defun %legacy-form-fields (form)
  (unless (and (consp form) (eq (first form) :list)) (%legacy-source-fail))
  (let* ((items (rest form))
         (head (%legacy-node-value (first items) :bare))
         (rest (rest items))
         (fields nil))
    (unless (member head '("legacy-claim" "legacy-judgment") :test #'string=)
      (%legacy-source-fail))
    (unless (evenp (length rest)) (%legacy-source-fail))
    (loop for (key value) on rest by #'cddr
          for name = (%legacy-node-value key :keyword)
          do (unless (member name '("op" "arg" "fingerprint" "as-of" "scope"
                                    "corpus" "frame" "warrants" "restore-live"
                                    "mapping-candidate") :test #'string=)
               (%legacy-source-fail))
             (when (assoc name fields :test #'string=) (%legacy-source-fail))
             (push (cons name value) fields))
    (dolist (required '("op" "arg" "fingerprint" "as-of" "scope" "corpus"
                        "frame"))
      (unless (assoc required fields :test #'string=) (%legacy-source-fail)))
    (cons (cons "source-record" head) (nreverse fields))))

(defun %legacy-field (parsed name)
  (cdr (assoc name parsed :test #'string=)))

(defun %legacy-fixture-name (value)
  (let ((name (record-field-named value "fixture-name")))
    (and (string-datum-p name) (datum-string-value* name))))

(defun %migration-field-fail (field)
  (lci-fail "migration-refusal" "UnsupportedLegacyForm" "migration-source"
            :path (list "fixture-field:parsed-inert-value"
                        (concatenate 'string "fixture-field:" field))))

(defun %legacy-string= (datum string)
  (and (string-datum-p datum) (string= (datum-string-value* datum) string)))

(defun %validate-parsed-coherence (parsed value)
  (let* ((proposition (record-field-named value "proposition"))
         (operator (record-field-named proposition "operator"))
         (arguments (record-field-named proposition "arguments"))
         (parsed-operator (%legacy-field parsed "op"))
         (parsed-corpus (%legacy-field parsed "corpus"))
         (parsed-warrants (%legacy-field parsed "warrants"))
         (parsed-live (%legacy-field parsed "restore-live"))
         (parsed-candidate (%legacy-field parsed "mapping-candidate")))
    (unless (and (equal (first parsed-operator) :qualified)
                 (%legacy-string= (record-field-named operator "package")
                                  (second parsed-operator))
                 (%legacy-string= (record-field-named operator "symbol")
                                  (third parsed-operator)))
      (%migration-field-fail "proposition"))
    (unless (and (sequence-datum-p arguments)
                 (= (sequence-datum-length arguments) 1)
                 (%legacy-string= (sequence-datum-ref arguments 0)
                                  (%legacy-node-value
                                   (%legacy-field parsed "arg") :string)))
      (%migration-field-fail "proposition"))
    (let ((site (if (string= (%legacy-field parsed "source-record")
                             "legacy-claim") "claim" "judgment")))
      (unless (%exact-identifier-p
               (record-field-named value "source-record-site")
               +fixture-identifier-namespace+ (list "legacy-source-record" site))
        (%migration-field-fail "source-record-site")))
    (unless (= (integer-datum-value (record-field-named value "as-of"))
               (%legacy-node-value (%legacy-field parsed "as-of") :integer))
      (%migration-field-fail "as-of"))
    (let ((scope (%legacy-node-value (%legacy-field parsed "scope") :bare)))
      (unless (%exact-identifier-p (record-field-named value "scope-token")
                                   +fixture-identifier-namespace+
                                   (list "legacy-scope-token" scope))
        (%migration-field-fail "scope-token")))
    (unless (and (eq (first parsed-corpus) :list)
                 (= (length (rest parsed-corpus)) 2)
                 (%legacy-string=
                  (record-field-named (record-field-named value "corpus-token")
                                      "name")
                  (%legacy-node-value (second parsed-corpus) :bare))
                 (= (integer-datum-value
                     (record-field-named (record-field-named value "corpus-token")
                                         "revision"))
                    (%legacy-node-value (third parsed-corpus) :integer)))
      (%migration-field-fail "corpus-token"))
    (let ((frame (%legacy-field parsed "frame")))
      (unless (and (eq (first frame) :qualified)
                   (%legacy-string=
                    (record-field-named value "frame-token")
                    (format nil "~A::~A" (second frame) (third frame))))
        (%migration-field-fail "frame-token")))
    (let ((warrants (record-field-named value "predecessor-warrants")))
      (unless (and (sequence-datum-p warrants)
                   (= (sequence-datum-length warrants)
                      (cond (parsed-warrants (length (rest parsed-warrants)))
                            ;; The frozen privileged-restoration adapter keeps
                            ;; the predecessor testimony inert even though the
                            ;; source expresses only the attempted restoration.
                            (parsed-live 1)
                            (t 0))))
        (%migration-field-fail "predecessor-warrants"))
      (loop for index below (sequence-datum-length warrants)
            do (%validate-exact-fixture-reference
                (sequence-datum-ref warrants index) "artifact"
                '("warrant-testimony" "inert-predecessor") 0
                '("fixture-field:parsed-inert-value"
                  "fixture-field:predecessor-warrants")))
      (when parsed-warrants
        (unless (and (eq (first parsed-warrants) :list)
                     (every (lambda (node)
                              (string= (%legacy-node-value node :bare)
                                       "inert-warrant-1"))
                            (rest parsed-warrants)))
          (%migration-field-fail "predecessor-warrants"))))
    (let ((live (record-field-named value "attempt-live-restoration")))
      (unless (and (boolean-datum-p live)
                   (eql (boolean-datum-value live) (not (null parsed-live)))
                   (or (null parsed-live)
                       (string= (%legacy-node-value parsed-live :bare) "t")))
        (%migration-field-fail "attempt-live-restoration")))
    (when parsed-candidate
      (unless (%exact-identifier-p
               (record-field-named value "mapping-candidate")
               +fixture-identifier-namespace+
               (list "proposition-form"
                     (%legacy-node-value parsed-candidate :bare)))
        (%migration-field-fail "mapping-candidate"))))
  value)

(defun %validate-legacy-inert-record (value &optional parsed)
  (require-record value "UnsupportedLegacyForm" "migration-source" nil)
  (unless (record-has-field-p value "frame-token")
    (lci-fail "migration-refusal" "IdentityBearingLoss" "represented-loss"
              :path '("fixture-field:frame-token")))
  (let ((fields (if (record-has-field-p value "mapping-candidate")
                    (append +legacy-record-fields+ '("mapping-candidate"))
                    +legacy-record-fields+)))
    (require-closed-fields value fields "migration-source"
                           :key-namespace +fixture-field-namespace+)
    (unless (%exact-identifier-p (record-field-named value "kind")
                                 +fixture-identifier-namespace+
                                 '("legacy-tag" "v1-claim-record"))
      (%migration-field-fail "kind"))
    (unless (and (integer-datum-p (record-field-named value "schema-version"))
                 (= (integer-datum-value
                     (record-field-named value "schema-version")) 1))
      (%migration-field-fail "schema-version"))
    (unless (and (string-datum-p (record-field-named value "fixture-name"))
                 (member (%legacy-fixture-name value) +legacy-fixture-names+
                         :test #'string=))
      (%migration-field-fail "fixture-name"))
    (unless (%exact-identifier-p
             (record-field-named value "source-record-site")
             +fixture-identifier-namespace+
             (list "legacy-source-record"
                   (identifier-last
                    (record-field-named value "source-record-site"))))
      (%migration-field-fail "source-record-site"))
    (let* ((proposition (record-field-named value "proposition"))
           (proposition-path '("fixture-field:parsed-inert-value"
                               "fixture-field:proposition")))
      (require-closed-fields proposition '("operator" "arguments")
                             "migration-source"
                             :key-namespace +fixture-field-namespace+
                             :path-prefix proposition-path)
      (let ((operator (record-field-named proposition "operator")))
        (require-closed-fields operator '("kind" "package" "symbol")
                               "migration-source"
                               :key-namespace +fixture-field-namespace+
                               :path-prefix (append proposition-path
                                                    '("fixture-field:operator")))
        (unless (and (%exact-identifier-p
                      (record-field-named operator "kind")
                      +fixture-identifier-namespace+
                      '("legacy-tag" "package-qualified-symbol"))
                     (string-datum-p (record-field-named operator "package"))
                     (string-datum-p (record-field-named operator "symbol")))
          (%migration-field-fail "proposition"))
        (reject-unknown-fields operator '("kind" "package" "symbol")
                               "migration-source"
                               :key-namespace +fixture-field-namespace+
                               :path-prefix (append proposition-path
                                                    '("fixture-field:operator"))))
      (let ((arguments (record-field-named proposition "arguments")))
        (unless (and (sequence-datum-p arguments)
                     (= (sequence-datum-length arguments) 1)
                     (string-datum-p (sequence-datum-ref arguments 0)))
          (%migration-field-fail "proposition")))
      (reject-unknown-fields proposition '("operator" "arguments")
                             "migration-source"
                             :key-namespace +fixture-field-namespace+
                             :path-prefix proposition-path))
    (unless (%legacy-string= (record-field-named value "fingerprint")
                             "legacy-fp-collision")
      (%migration-field-fail "fingerprint"))
    (unless (integer-datum-p (record-field-named value "as-of"))
      (%migration-field-fail "as-of"))
    (unless (%exact-identifier-p
             (record-field-named value "scope-token")
             +fixture-identifier-namespace+
             (list "legacy-scope-token"
                   (identifier-last (record-field-named value "scope-token"))))
      (%migration-field-fail "scope-token"))
    (let ((corpus (record-field-named value "corpus-token")))
      (require-closed-fields corpus '("name" "revision") "migration-source"
                             :key-namespace +fixture-field-namespace+
                             :path-prefix '("fixture-field:parsed-inert-value"
                                            "fixture-field:corpus-token"))
      (unless (and (string-datum-p (record-field-named corpus "name"))
                   (integer-datum-p (record-field-named corpus "revision")))
        (%migration-field-fail "corpus-token"))
      (reject-unknown-fields corpus '("name" "revision") "migration-source"
                             :key-namespace +fixture-field-namespace+
                             :path-prefix '("fixture-field:parsed-inert-value"
                                            "fixture-field:corpus-token")))
    (unless (string-datum-p (record-field-named value "frame-token"))
      (%migration-field-fail "frame-token"))
    (let ((warrants (record-field-named value "predecessor-warrants")))
      (unless (sequence-datum-p warrants)
        (%migration-field-fail "predecessor-warrants"))
      (loop for index below (sequence-datum-length warrants)
            do (%validate-exact-fixture-reference
                (sequence-datum-ref warrants index) "artifact"
                '("warrant-testimony" "inert-predecessor") 0
                '("fixture-field:parsed-inert-value"
                  "fixture-field:predecessor-warrants"))))
    (unless (boolean-datum-p
             (record-field-named value "attempt-live-restoration"))
      (%migration-field-fail "attempt-live-restoration"))
    (when (record-has-field-p value "mapping-candidate")
      (unless (identifier-datum-p (record-field-named value "mapping-candidate"))
        (%migration-field-fail "mapping-candidate")))
    (reject-unknown-fields value fields "migration-source"
                           :key-namespace +fixture-field-namespace+))
  (when parsed (%validate-parsed-coherence parsed value))
  value)

(defun parse-legacy-fixture (source)
  "Parse the sealed bounded grammar without invoking the Common Lisp reader."
  (require-closed-fields source
                         '("kind" "schema-version" "source-artifact"
                           "source-bytes" "grammar" "parse-expected")
                         "migration-source"
                         :key-namespace +fixture-field-namespace+)
  (unless (and (%exact-identifier-p (record-field-named source "kind")
                                    +fixture-identifier-namespace+
                                    '("tag" "legacy-source-fixture"))
               (exact-zero-p (record-field-named source "schema-version")))
    (%legacy-source-fail))
  (%validate-stable-ref-domain (record-field-named source "source-artifact")
                               "artifact" '("fixture-field:source-artifact"))
  (let ((source-bytes (record-field-named source "source-bytes")))
    (unless (bytes-datum-p source-bytes) (%legacy-source-fail)))
  ;; LCI0-AC-007 (LCI0-ACV-HOSTILE-007): a structurally valid grammar
  ;; reference that is not the pinned v1 fixture grammar is an unsupported
  ;; legacy form of the migration source, not a stable-reference defect.
  ;; The exact ruled tuple is migration-refusal / UnsupportedLegacyForm /
  ;; migration-source at /grammar.
  (let ((grammar (record-field-named source "grammar")))
    (%validate-stable-ref-domain grammar "artifact" '("fixture-field:grammar"))
    (unless (%stable-ref-material-exact-p
             grammar "artifact" '("legacy-grammar" "v1-fixture" "0") 0)
      (%legacy-source-fail '("fixture-field:grammar"))))
  (let ((parse-expected (record-field-named source "parse-expected")))
    (unless (boolean-datum-p parse-expected)
      (%legacy-source-fail '("fixture-field:parse-expected")))
    (if (boolean-datum-value parse-expected)
        (progn
          (require-closed-fields source +legacy-source-fields+ "migration-source"
                                 :key-namespace +fixture-field-namespace+)
          (let ((source-bytes (record-field-named source "source-bytes")))
            (prog1
                (%validate-legacy-inert-record
                 (record-field-named source "parsed-inert-value")
                 (%legacy-form-fields
                  (%parse-legacy-octets (bytes-datum-value source-bytes))))
              (reject-unknown-fields source +legacy-source-fields+
                                     "migration-source"
                                     :key-namespace +fixture-field-namespace+))))
        (progn
          (require-closed-fields
           source '("kind" "schema-version" "source-artifact" "source-bytes"
                    "grammar" "parse-expected" "expected-parser-code")
           "migration-source" :key-namespace +fixture-field-namespace+)
          (unless (%exact-identifier-p
                   (record-field-named source "expected-parser-code")
                   '("lisp-plus" "lci" "0" "failure")
                   '("UnsupportedLegacyForm"))
            (%legacy-source-fail '("fixture-field:expected-parser-code")))
          (let ((source-bytes (record-field-named source "source-bytes")))
            (reject-unknown-fields
             source '("kind" "schema-version" "source-artifact" "source-bytes"
                      "grammar" "parse-expected" "expected-parser-code")
             "migration-source" :key-namespace +fixture-field-namespace+)
            (handler-case
                (progn (%parse-legacy-octets (bytes-datum-value source-bytes))
                       (%legacy-source-fail))
              (lci-failure (condition)
                (if (string= (lci-failure-code condition)
                             "UnsupportedLegacyForm")
                    (%legacy-source-fail)
                    (error condition)))))))))

(defun %migration-inert-value (source-or-value)
  (if (record-has-field-p source-or-value "parsed-inert-value")
      (parse-legacy-fixture source-or-value)
      (%validate-legacy-inert-record source-or-value)))

(defun %legacy-operator-parts (value)
  (let* ((proposition (record-field-named value "proposition"))
         (operator (record-field-named proposition "operator")))
    (values (datum-string-value* (record-field-named operator "package"))
            (datum-string-value* (record-field-named operator "symbol")))))

(defun %validate-migration-mappings (value)
  (multiple-value-bind (package symbol) (%legacy-operator-parts value)
    (let ((mapping (find-if (lambda (row)
                              (and (string= package (first row))
                                   (string= symbol (second row))))
                            +legacy-package-symbol-map+)))
      (cond
        ((string= package "MNEME-OLD")
         (lci-fail "migration-refusal" "AmbiguousIdentifier"
                   "migration-mapping"
                   :path '("fixture-field:parsed-inert-value"
                           "fixture-field:proposition"
                           "fixture-field:operator")))
        ((record-has-field-p value "mapping-candidate")
         (lci-fail "migration-refusal" "SemanticIdentifierMappingMismatch"
                   "migration-mapping"
                   :path '("fixture-field:parsed-inert-value"
                           "fixture-field:mapping-candidate")))
        ((or (null mapping)
             (not (equal (subseq mapping 2)
                         '("proposition-form" "file-exists"))))
         (lci-fail "migration-refusal" "SemanticIdentifierMappingMismatch"
                   "migration-mapping"
                   :path '("fixture-field:parsed-inert-value"
                           "fixture-field:proposition"
                           "fixture-field:operator"))))))
  (let* ((site (identifier-last (record-field-named value "source-record-site")))
         (role (assoc site +legacy-as-of-role-map+ :test #'string=)))
    (when (or (null role) (string= (third role) "ambiguous-refuse"))
      (lci-fail "migration-refusal" "UnclassifiedAsOf" "migration-mapping"
                :path '("fixture-field:parsed-inert-value"
                        "fixture-field:as-of")))
    (unless (string= site "claim")
      (lci-fail "migration-refusal" "UnclassifiedAsOf" "migration-mapping"
                :path '("fixture-field:parsed-inert-value"
                        "fixture-field:as-of"))))
  value)

(defun %legacy-case (value)
  (let* ((as-of (datum-integer-value* (record-field-named value "as-of")))
         (scope (identifier-last (record-field-named value "scope-token")))
         (corpus (record-field-named value "corpus-token"))
         (corpus-name (datum-string-value* (record-field-named corpus "name")))
         (revision (datum-integer-value* (record-field-named corpus "revision")))
         (frame (datum-string-value* (record-field-named value "frame-token")))
         (predecessors (record-field-named value "predecessor-warrants"))
         (live (record-field-named value "attempt-live-restoration")))
    (unless (and (member as-of '(100 124))
                 (member scope '("tenant-a" "tenant-b") :test #'string=)
                 (string= corpus-name "alpha")
                 (member revision '(3 4))
                 (string= frame "MNEME::SELF-DESCRIBING")
                 (sequence-datum-p predecessors)
                 (boolean-datum-p live))
      (lci-fail "migration-refusal" "IdentityBearingLoss" "represented-loss"
                :path '("fixture-field:parsed-inert-value")))
    (loop for index below (sequence-datum-length predecessors)
          do (%validate-exact-fixture-reference
              (sequence-datum-ref predecessors index) "artifact"
              '("warrant-testimony" "inert-predecessor") 0
              '("fixture-field:parsed-inert-value"
                "fixture-field:predecessor-warrants")))
    (cond
      ((boolean-datum-value live) :live-restoration)
      ((plusp (sequence-datum-length predecessors)) :inert-predecessor)
      ((and (= revision 4) (= as-of 100) (string= scope "tenant-a"))
       :corpus-r4)
      ((and (= revision 3) (= as-of 100) (string= scope "tenant-b"))
       :scope-tenant-b)
      ((and (= revision 3) (= as-of 124) (string= scope "tenant-a"))
       :time-124)
      ((and (= revision 3) (= as-of 100) (string= scope "tenant-a"))
       :time-100)
      (t
       (lci-fail "migration-refusal" "IdentityBearingLoss" "represented-loss"
                 :path '("fixture-field:parsed-inert-value"))))))

(defun %migration-stable-ref (domain object-tail &optional (object-version 0))
  (make-lci-record
   (list "kind" (lci-tag "stable-reference"))
   (list "domain" (fixture-id "domain" domain))
   (list "scheme" (fixture-id "scheme" domain "structural" "0"))
   (list "material"
         (make-fixture-record
          (list "kind" (fixture-id "tag" "fixture-stable-material"))
          (list "schema-version" (make-integer-datum 0))
          (list "object-id"
                (apply #'fixture-id "object" domain object-tail))
          (list "object-version" (make-integer-datum object-version))))))

(defun %migration-identity-policy ()
  (make-lci-record
   (list "kind" (lci-tag "identity-policy"))
   (list "policy-id" (make-id '("lisp-plus" "lci")
                               '("located-claim-identity")))
   (list "policy-version" (make-integer-datum 0))))

(defun %migration-claim-profile ()
  (make-lci-record
   (list "kind" (lci-tag "claim-profile"))
   (list "profile-id" (make-id '("lisp-plus" "mneme") '("located-claim")))
   (list "profile-version" (make-integer-datum 0))))

(defun %migration-locator-slot (coordinate role)
  (make-named-record
   +proposition-field-namespace+
   (list (list "kind" (fixture-id "tag" "locator-slot"))
         (list "schema-version" (make-integer-datum 0))
         (list "coordinate" (fixture-id "locator-coordinate" coordinate))
         (list "locator-role" (fixture-id "locator-role" role)))))

(defun %migration-proposition-argument (placement value)
  (make-named-record
   +proposition-field-namespace+
   (list (list "kind" (fixture-id "tag" "proposition-argument"))
         (list "schema-version" (make-integer-datum 0))
         (list "placement" (fixture-id "proposition-placement" placement))
         (list "value" value))))

(defun %migration-proposition ()
  (let ((arguments
          (make-named-record
           +proposition-argument-namespace+
           (list
            (list "artifact"
                  (%migration-proposition-argument
                   "proposition-subject-content"
                   (%migration-stable-ref "artifact" '("file" "alpha.txt"))))
            (list "scope-locator"
                  (%migration-proposition-argument
                   "external-claim-location-locator"
                   (%migration-locator-slot "scope" "claim-scope")))
            (list "subject-time-locator"
                  (%migration-proposition-argument
                   "external-claim-location-locator"
                   (%migration-locator-slot "subject-time"
                                            "proposition-subject-time")))
            (list "basis-locator"
                  (%migration-proposition-argument
                   "external-claim-location-locator"
                   (%migration-locator-slot "basis" "claim-basis")))
            (list "frame-locator"
                  (%migration-proposition-argument
                   "external-claim-location-locator"
                   (%migration-locator-slot "interpretation-frame"
                                            "claim-interpretation-frame")))))))
    (make-named-record
     +proposition-field-namespace+
     (list (list "kind" (fixture-id "tag" "mneme-fixture-proposition"))
           (list "schema-version" (make-integer-datum 0))
           (list "form" (fixture-id "proposition-form" "file-exists"))
           (list "arguments" arguments)))))

(defun %migration-scope (tenant)
  (make-lci-record
   (list "kind" (lci-tag "scope"))
   (list "schema-version" (make-integer-datum 0))
   (list "calculus"
         (%migration-stable-ref "scope-calculus" '("mneme-primary")))
   (list "expression"
         (make-fixture-record
          (list "kind" (fixture-id "tag" "scope-expression"))
          (list "schema-version" (make-integer-datum 0))
          (list "form" (fixture-id "scope-form" "tenant"))
          (list "organization"
                (fixture-id "scope-object" "organization" "acme"))
          (list "tenant" (fixture-id "scope-object" "tenant" tenant))))))

(defun %migration-subject-time (tick)
  (make-lci-record
   (list "kind" (lci-tag "subject-time"))
   (list "schema-version" (make-integer-datum 0))
   (list "temporal-model"
         (%migration-stable-ref "temporal-model" '("mneme-fixture-time")))
   (list "expression"
         (make-fixture-record
          (list "kind" (fixture-id "tag" "temporal-expression"))
          (list "schema-version" (make-integer-datum 0))
          (list "form" (fixture-id "temporal-form" "instant"))
          (list "tick" (make-integer-datum tick))))))

(defun %migration-dataset-slice ()
  (make-lci-record
   (list "kind" (lci-tag "dataset-slice"))
   (list "schema-version" (make-integer-datum 0))
   (list "calculus"
         (%migration-stable-ref "dataset-slice-calculus"
                                '("mneme-fixture-slice")))
   (list "expression"
         (make-fixture-record
          (list "kind" (fixture-id "tag" "dataset-slice-expression"))
          (list "schema-version" (make-integer-datum 0))
          (list "form" (fixture-id "slice-form" "all-members"))))))

(defun %migration-semantic-boundary (revision)
  (make-lci-record
   (list "kind" (lci-tag "semantic-boundary"))
   (list "schema-version" (make-integer-datum 0))
   (list "calculus"
         (%migration-stable-ref "semantic-boundary-calculus"
                                '("mneme-fixture-boundary")))
   (list "expression"
         (make-fixture-record
          (list "kind" (fixture-id "tag" "semantic-boundary-expression"))
          (list "schema-version" (make-integer-datum 0))
          (list "form" (fixture-id "boundary-form" "snapshot-manifest"))
          (list "manifest"
                (%migration-stable-ref
                 "artifact" (list "manifest" "alpha"
                                  (format nil "~D" revision))))))))

(defun %migration-basis (revision)
  (make-lci-record
   (list "kind" (lci-tag "claim-basis"))
   (list "schema-version" (make-integer-datum 0))
   (list "mode" (lci-tag "corpus"))
   (list "corpus" (%migration-stable-ref "logical-corpus" '("alpha-corpus")))
   (list "revision"
         (%migration-stable-ref
          "immutable-corpus-revision"
          (list "alpha-corpus" (format nil "revision-~D" revision)) revision))
   (list "slice" (%migration-dataset-slice))
   (list "semantic-boundary" (%migration-semantic-boundary revision))))

(defun %migration-frame ()
  (make-lci-record
   (list "kind" (lci-tag "interpretation-frame"))
   (list "schema-version" (make-integer-datum 0))
   (list "frame-schema"
         (%migration-stable-ref "interpretation-frame-schema"
                                '("mneme-fixture-frame")))
   (list "components" (make-fixture-record))))

(defun %migration-location (tenant tick revision)
  (make-lci-record
   (list "kind" (lci-tag "claim-location"))
   (list "scope" (%migration-scope tenant))
   (list "subject-time" (%migration-subject-time tick))
   (list "basis" (%migration-basis revision))
   (list "interpretation-frame" (%migration-frame))
   (list "profile-location" (make-lci-record))))

(defun %migration-claim-values (tenant tick revision)
  (let* ((proposition (%migration-proposition))
         (location (%migration-location tenant tick revision))
         ;; The migration result's semantic core is a fixture wrapper.  Its
         ;; field keys are therefore in the sealed fixture-field namespace,
         ;; even though the projection input below uses the LCI namespace.
         (core (make-fixture-record (list "proposition" proposition)
                                    (list "location" location)))
         (projection-input
           (make-lci-record
            (list "identity-policy" (%migration-identity-policy))
            (list "claim-profile" (%migration-claim-profile))
            (list "proposition" proposition)
            (list "location" location))))
    (values core (project-claim-id projection-input))))

(defun %migration-lineage (source)
  (make-sequence-datum
   (list (make-fixture-record
          (list "relation" (fixture-id "lineage-relation" "migration"))
          (list "source" source)))))

(defun %migration-handoff-loss ()
  (let* ((predecessor
           (%migration-stable-ref "artifact" '("occurrence" "predecessor")))
         (handoff (%migration-stable-ref "procedure" '("handoff"))))
    (make-lci-record
     (list "kind" (lci-tag "represented-loss"))
     (list "schema-version" (make-integer-datum 0))
     (list "operation" handoff)
     (list "source" predecessor)
     (list "lost-dimensions"
           (make-sequence-datum
            (list (fixture-id "lost-dimension" "live-authority")
                  (fixture-id "lost-dimension" "custody-continuity"))))
     (list "consequence"
           (make-id '("lisp-plus" "lci" "0" "relation")
                    '("authority-or-custody-loss")))
     (list "account"
           (make-fixture-record
            (list "kind" (fixture-id "tag" "represented-loss-account"))
            (list "schema-version" (make-integer-datum 0))
            (list "account-schema"
                  (fixture-id "represented-loss-account-schema" "handoff" "0"))
            (list "predecessor-occurrence" predecessor)
            (list "handoff-receipt"
                  (%migration-stable-ref "artifact" '("receipt" "handoff" "1")))
            (list "live-authority-transferred" (make-boolean-datum nil))
            (list "custody-continuity-proven" (make-boolean-datum nil))
            (list "successor-live-warrants" (make-integer-datum 0))
            (list "handoff-procedure" handoff))))))

(defun %migration-testimony (predecessors)
  (make-sequence-datum
   (loop for index below (sequence-datum-length predecessors)
         collect (make-fixture-record
                  (list "kind"
                        (fixture-id "legacy-testimony" "predecessor-warrant"))
                  (list "artifact" (sequence-datum-ref predecessors index))))))

(defun %construct-migration-result (source value case)
  (let* ((scope-name (identifier-last (record-field-named value "scope-token")))
         (tenant (if (string= scope-name "tenant-b") "b" "a"))
         (tick (integer-datum-value (record-field-named value "as-of")))
         (revision (integer-datum-value
                    (record-field-named (record-field-named value "corpus-token")
                                        "revision")))
         (predecessors (record-field-named value "predecessor-warrants"))
         (inert-p (eq case :inert-predecessor)))
    (multiple-value-bind (core claim-id)
        (%migration-claim-values tenant tick revision)
      (let ((result
              (make-lci-record
               (list "kind" (lci-tag "migration-result"))
               (list "schema-version" (make-integer-datum 0))
               (list "source" source)
               (list "adapter" (%migration-stable-ref "procedure" '("migrate-v1")))
               (list "classification"
                     (fixture-id
                      "migration-classification"
                      (if inert-p
                          "privileged-runtime-relation-outside-claim-id"
                          "exact-after-explicit-tagging")))
               (list "claim" core)
               (list "claim-id" claim-id)
               (list "lineage" (%migration-lineage source))
               (list "represented-loss"
                     (make-sequence-datum
                      (if inert-p (list (%migration-handoff-loss)) nil)))
               (list "legacy-testimony"
                     (if inert-p (%migration-testimony predecessors)
                         (make-sequence-datum nil)))
               (list "live-warrants-created" (make-boolean-datum nil)))))
        (validate-migration-result result)
        result))))

(defun %migrate-v1-fixture-unbudgeted (source-or-value)
  ;; A result may name only its explicitly declared and validated
  ;; LegacySourceFixture source artifact.  A bare parsed inert value has no
  ;; source binding and therefore is not a migratable source.
  (let* ((value (%migration-inert-value source-or-value)))
    (%validate-migration-mappings value)
    (let ((case (%legacy-case value)))
      (when (eq case :live-restoration)
        (lci-fail "privilege-refusal" "PrivilegedRestorationAttempt"
                  "privilege-boundary"
                  :path '("fixture-field:parsed-inert-value"
                          "fixture-field:attempt-live-restoration")))
      ;; Preserve a more specific defect in a malformed direct inert value,
      ;; but never construct a successful result without a declared source.
      (unless (and (record-datum-p source-or-value)
                   (record-has-field-p source-or-value "source-artifact"))
        (lci-fail "invalid-input" "MissingRequiredField"
                  "migration-source"
                  :path '("fixture-field:source-artifact")))
      (%construct-migration-result
       (record-field-named source-or-value "source-artifact") value case))))

(defun migrate-v1-fixture (source-or-value)
  (with-lci-structural-budgets (source-or-value "migration")
    (%migrate-v1-fixture-unbudgeted source-or-value)))

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
