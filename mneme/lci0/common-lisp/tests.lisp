(in-package #:cl-user)

(defvar *lci0-test-passes* 0)
(defvar *lci0-test-failures* 0)
(defvar *lci0-test-blocked* 0)

(defmacro lci0-check (name form)
  `(handler-case
       (if ,form
           (progn (incf *lci0-test-passes*)
                  (format t "PASS ~A~%" ,name))
           (progn (incf *lci0-test-failures*)
                  (format t "FAIL ~A -- false~%" ,name)))
     (error (condition)
       (incf *lci0-test-failures*)
       (format t "FAIL ~A -- ~A~%" ,name condition))))

(defmacro lci0-blocked-check (name form)
  `(handler-case
       (if ,form
           (progn (incf *lci0-test-blocked*)
                  (format t "BLOCKED ~A -- authorial return required~%" ,name))
           (progn (incf *lci0-test-failures*)
                  (format t "FAIL ~A -- blocked witness disappeared~%" ,name)))
     (error (condition)
       (incf *lci0-test-failures*)
       (format t "FAIL ~A -- ~A~%" ,name condition))))

(defun lci0-refusal-code (thunk)
  (handler-case (progn (funcall thunk) nil)
    (lisp-plus-lci0:lci-failure (condition)
      (lisp-plus-lci0:lci-failure-code condition))))

(defun lci0-capture-refusal (thunk)
  (handler-case (progn (funcall thunk) nil)
    (lisp-plus-lci0:lci-failure (condition) condition)))

(defun lci0-capture-authorial-gap (thunk)
  (handler-case (progn (funcall thunk) nil)
    (lisp-plus-lci0::fixture-operation-authorial-gap (condition) condition)))

(defun lci0-capture-internal-integrity-failure (thunk)
  (handler-case (progn (funcall thunk) nil)
    (lisp-plus-lci0::lci-internal-integrity-failure (condition) condition)))

(defun lci0-internal-integrity-code (thunk)
  (let ((condition (lci0-capture-internal-integrity-failure thunk)))
    (and condition
         (lisp-plus-lci0::lci-internal-integrity-failure-code condition))))

(defun lci0-registry-failure-codes ()
  (let ((codes nil))
    (lisp-plus-lci0::map-registry-definitions
     lisp-plus-lci0::*fixture-root*
     (lambda (definition)
       (let ((fixture-id (lisp-plus-lci0::jget definition "fixture_id")))
         (when (and (>= (length fixture-id) 13)
                    (string= fixture-id "failure-code." :end1 13 :end2 13))
           (push (subseq fixture-id 13) codes)))))
    (sort codes #'string<)))

(defun lci0-source-literal-failure-codes ()
  (let ((codes nil))
    (labels ((walk (form)
               (when (consp form)
                 (when (and (symbolp (first form))
                            (string= (symbol-name (first form)) "LCI-FAIL")
                            (stringp (third form)))
                   (push (third form) codes))
                 (walk (car form))
                 (walk (cdr form)))))
      (dolist (path (directory "mneme/lci0/common-lisp/*.lisp"))
        (with-open-file (stream path :direction :input :external-format :utf-8)
          (let ((*read-eval* nil))
            (loop for form = (read stream nil :eof)
                  until (eq form :eof)
                  do (walk form))))))
    (sort (remove-duplicates codes :test #'string=) #'string<)))

(defun lci0-record-replace (record field-name value
                             &optional expected-namespace)
  (lisp-plus-cd0:make-record-datum
   (loop for index below (lisp-plus-cd0:record-datum-size record)
         for key = (lisp-plus-cd0:record-datum-key-at record index)
         for old = (lisp-plus-cd0:record-datum-value-at record index)
         collect
         (lisp-plus-cd0:make-record-entry
          key
          (if (and (string= (or (lisp-plus-lci0::identifier-last key) "")
                            field-name)
                   (or (null expected-namespace)
                       (equal (lisp-plus-lci0::identifier-namespace-strings key)
                              expected-namespace)))
              value old)))))

(defun lci0-record-add (record key value)
  (lisp-plus-cd0:make-record-datum
   (append
    (loop for index below (lisp-plus-cd0:record-datum-size record)
          collect
          (lisp-plus-cd0:make-record-entry
           (lisp-plus-cd0:record-datum-key-at record index)
           (lisp-plus-cd0:record-datum-value-at record index)))
    (list (lisp-plus-cd0:make-record-entry key value)))))

(defun lci0-record-rekey (record field-name replacement-key)
  (lisp-plus-cd0:make-record-datum
   (loop for index below (lisp-plus-cd0:record-datum-size record)
         for key = (lisp-plus-cd0:record-datum-key-at record index)
         collect
         (lisp-plus-cd0:make-record-entry
          (if (string= (or (lisp-plus-lci0::identifier-last key) "") field-name)
              replacement-key key)
          (lisp-plus-cd0:record-datum-value-at record index)))))

(defun lci0-metric (datum name)
  (cdr (assoc name (lisp-plus-lci0::%lci-structural-metrics datum)
              :test #'string=)))

(defun lci0-vector-payload (vector-id)
  (block found
    (lisp-plus-lci0::map-vector-rows
     lisp-plus-lci0::*fixture-root*
     (lambda (row)
       (when (string= (lisp-plus-lci0::jget row "vector_id") vector-id)
         (let* ((document (lisp-plus-lci0::jget row "inputs"))
                (input
                  (lisp-plus-lci0:fixture-json-to-datum
                   (lisp-plus-lci0::jget document "abstract_cd0"))))
           (return-from found
             (lisp-plus-lci0::record-field-named input "payload"))))))
    (error "missing vector payload ~A" vector-id)))

(defun lci0-execute-operation (name payload)
  (lisp-plus-lci0:execute-fixture-operation
   (lisp-plus-lci0::fixture-id "operation" name) payload))

(defun lci0-result-output (result name)
  (lisp-plus-lci0::record-field-named
   (lisp-plus-lci0::record-field-named result "outputs") name))

(defun lci0-true-p (datum)
  (and (lisp-plus-cd0:boolean-datum-p datum)
       (lisp-plus-cd0:boolean-datum-value datum)))

(defun run-lci0-common-lisp-unit-tests ()
  (setf *lci0-test-passes* 0 *lci0-test-failures* 0 *lci0-test-blocked* 0)
  (let* ((samples
           (list
            (cons :unit "{\"t\":\"unit\"}")
            (cons :boolean "{\"t\":\"bool\",\"v\":true}")
            (cons :integer "{\"t\":\"int\",\"v\":\"1\"}")
            (cons :rational
                  "{\"t\":\"rat\",\"num\":\"1\",\"den\":\"2\"}")
            (cons :bytes "{\"t\":\"bytes\",\"hex\":\"00ff\"}")
            (cons :string
                  "{\"t\":\"string\",\"text\":\"A\",\"utf8_hex\":\"41\"}")
            (cons :identifier
                  "{\"t\":\"id\",\"namespace\":[\"N\"],\"path\":[\"P\"]}")
            (cons :sequence
                  "{\"t\":\"seq\",\"items\":[{\"t\":\"unit\"}]}")
            (cons :record
                  "{\"t\":\"record\",\"fields\":[{\"key\":{\"t\":\"id\",\"namespace\":[\"N\"],\"path\":[\"K\"]},\"value\":{\"t\":\"unit\"}}]}")
            (cons :record-field-wrapper
                  "{\"key\":{\"t\":\"unit\"},\"value\":{\"t\":\"unit\"}}")))
         (observed (mapcar (lambda (sample)
                             (lisp-plus-lci0:fixture-json-schema-shape
                              (lisp-plus-lci0:parse-json (cdr sample))))
                           samples)))
    (lci0-check "adapter-schema-census"
      (equal observed (mapcar #'car samples)))
    (lci0-check "adapter-all-datum-shapes-construct"
      (every (lambda (sample)
               (or (eq (car sample) :record-field-wrapper)
                   (lisp-plus-cd0:datum-p
                    (lisp-plus-lci0:fixture-json-to-datum
                     (lisp-plus-lci0:parse-json (cdr sample))))))
             samples)))
  (let ((registry-codes (lci0-registry-failure-codes))
        (implementation-codes
          (sort (copy-list lisp-plus-lci0::+frozen-lci-failure-codes+)
                #'string<))
        (literal-codes (lci0-source-literal-failure-codes)))
    (lci0-check "failure-code-registry-census-is-exactly-84"
      (and (= (length registry-codes) 84)
           (= (length (remove-duplicates registry-codes :test #'string=)) 84)))
    ;; LCI0-AC-008 authorizes exactly one failure code beyond the frozen 0.1
    ;; registry census: InvalidMigrationResult, the ruled tuple's code for the
    ;; classification/content coupling rejection.
    (lci0-check "failure-code-allowlist-equals-frozen-registry-plus-closure"
      (equal implementation-codes
             (sort (cons "InvalidMigrationResult" (copy-list registry-codes))
                   #'string<)))
    (lci0-check "every-literal-lci-fail-code-is-frozen-authoritative"
      (every #'lisp-plus-lci0::frozen-lci-failure-code-p literal-codes))
    (lci0-check "dynamic-unfrozen-lci-code-cannot-escape-as-lci-failure"
      (let* ((invented (concatenate 'string "Invented" "FailureCode"))
             (condition
               (lci0-capture-internal-integrity-failure
                (lambda ()
                  (lisp-plus-lci0::lci-fail
                   "invalid-input" invented "census-probe")))))
        (and condition
             (string=
              (lisp-plus-lci0::lci-internal-integrity-failure-jurisdiction
               condition)
              "failure-vocabulary")
             (string=
              (lisp-plus-lci0::lci-internal-integrity-failure-code condition)
              "UnfrozenLCIFailureCode")))))
  (lci0-check "adapter-unknown-shape-fails-closed"
    (string= "UnknownFixtureShape"
             (lci0-internal-integrity-code
              (lambda ()
                (lisp-plus-lci0:fixture-json-to-datum
                 (lisp-plus-lci0:parse-json
                  "{\"t\":\"future-datum\",\"v\":0}"))))))
  (lci0-check "adapter-nonstring-tag-fails-closed"
    (string= "UnknownFixtureShape"
             (lci0-internal-integrity-code
              (lambda ()
                (lisp-plus-lci0:fixture-json-to-datum
                 (lisp-plus-lci0:parse-json "{\"t\":0}"))))))
  (lci0-check "adapter-redundant-string-verification"
    (string= "RedundantFixtureFieldMismatch"
             (lci0-internal-integrity-code
              (lambda ()
                (lisp-plus-lci0:fixture-json-to-datum
                 (lisp-plus-lci0:parse-json
                  "{\"t\":\"string\",\"text\":\"A\",\"utf8_hex\":\"42\"}"))))))
  (let ((boolean (lisp-plus-lci0:fixture-json-to-datum
                  (lisp-plus-lci0:parse-json
                   "{\"t\":\"bool\",\"v\":true}")))
        (integer (lisp-plus-lci0:fixture-json-to-datum
                  (lisp-plus-lci0:parse-json
                   "{\"t\":\"int\",\"v\":\"1\"}"))))
    (lci0-check "adapter-preserves-boolean-versus-integer"
      (and (lisp-plus-cd0:boolean-datum-p boolean)
           (lisp-plus-cd0:integer-datum-p integer)
           (not (lisp-plus-cd0:equal-datum boolean integer)))))
  (lci0-check "adapter-rejects-reducible-rational-surface"
    (string= "NoncanonicalFixtureRational"
             (lci0-internal-integrity-code
              (lambda ()
                (lisp-plus-lci0:fixture-json-to-datum
                 (lisp-plus-lci0:parse-json
                  "{\"t\":\"rat\",\"num\":\"2\",\"den\":\"4\"}"))))))
  (lci0-check "adapter-rejects-negative-rational-denominator"
    (string= "NoncanonicalFixtureRational"
             (lci0-internal-integrity-code
              (lambda ()
                (lisp-plus-lci0:fixture-json-to-datum
                 (lisp-plus-lci0:parse-json
                  "{\"t\":\"rat\",\"num\":\"1\",\"den\":\"-2\"}"))))))
  (let* ((source (lisp-plus-lci0:parse-json
                  "{\"t\":\"id\",\"namespace\":[\"Case\"],\"path\":[\"Segment\"]}"))
         (datum (lisp-plus-lci0:fixture-json-to-datum source))
         (before (lisp-plus-cd0:canonical-octets datum)))
    (let ((namespace (cdr (assoc "namespace" source :test #'string=))))
      (setf (char (first namespace) 0) #\x))
    (lci0-check "adapter-source-mutation-isolated"
      (string= (lisp-plus-lci0::octets-to-hex before)
               (lisp-plus-lci0::octets-to-hex
                (lisp-plus-cd0:canonical-octets datum)))))
  (lci0-check "cd0-sha256-known-answer"
    (string= (lisp-plus-lci0::sha256-hex
              (lisp-plus-lci0::hex-to-octets "616263"))
             "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"))
  (lci0-check "independently-allocated-values-equal"
    (let ((left (lisp-plus-cd0:make-identifier-datum '("N") '("P")))
          (right (lisp-plus-cd0:make-identifier-datum '("N") '("P"))))
      (and (not (eq left right)) (lisp-plus-cd0:equal-datum left right))))
  (lci0-check "record-insertion-order-neutral"
    (let* ((a (lisp-plus-cd0:make-identifier-datum '("N") '("a")))
           (b (lisp-plus-cd0:make-identifier-datum '("N") '("b")))
           (one (lisp-plus-cd0:make-record-datum
                 (list (lisp-plus-cd0:make-record-entry
                        a (lisp-plus-cd0:make-integer-datum 1))
                       (lisp-plus-cd0:make-record-entry
                        b (lisp-plus-cd0:make-integer-datum 2)))))
           (two (lisp-plus-cd0:make-record-datum
                 (list (lisp-plus-cd0:make-record-entry
                        b (lisp-plus-cd0:make-integer-datum 2))
                       (lisp-plus-cd0:make-record-entry
                        a (lisp-plus-cd0:make-integer-datum 1))))))
      (lisp-plus-cd0:equal-datum one two)))
  (lci0-check "source-list-mutation-snapshot"
    (lisp-plus-lci0:run-mutation-snapshot-test))
  (lci0-check "printer-package-readtable-ambient-neutrality"
    (let* ((claim (lisp-plus-lci0::registry-datum "claim-id.file-alpha-neutral"))
           (before (lisp-plus-cd0:canonical-octets claim))
           (package (make-package (symbol-name (gensym "LCI0-AMBIENT-"))
                                  :use '(#:cl))))
      (unwind-protect
           (let ((*package* package)
                 (*print-base* 16) (*print-radix* t) (*print-case* :downcase)
                 (*print-readably* nil) (*readtable* (copy-readtable nil)))
             (set-macro-character #\! (lambda (stream character)
                                        (declare (ignore stream character)) :ambient))
             (string= (lisp-plus-lci0::octets-to-hex before)
                      (lisp-plus-lci0::octets-to-hex
                       (lisp-plus-cd0:canonical-octets
                        (lisp-plus-lci0:project-claim-id claim)))))
        (delete-package package))))
  (lci0-check "filesystem-and-clock-ambient-neutrality"
    (let* ((claim (lisp-plus-lci0::registry-datum "claim-id.file-alpha-neutral"))
           (before (lisp-plus-cd0:canonical-octets
                    (lisp-plus-lci0:project-claim-id claim)))
           (cl:*default-pathname-defaults* #P"/definitely-unavailable-lci0/"))
      (get-universal-time)
      (string= (lisp-plus-lci0::octets-to-hex before)
               (lisp-plus-lci0::octets-to-hex
                (lisp-plus-cd0:canonical-octets
                 (lisp-plus-lci0:project-claim-id claim))))))
  (let ((counts (lisp-plus-lci0:verify-fixture-relation-tables)))
    (lci0-check "all-458-relation-table-semantics"
      (and (= (getf counts :scope) 169)
           (= (getf counts :temporal) 289)
           (= (getf counts :total) 458))))
  (let* ((reference
           (lisp-plus-lci0::registry-datum "stable-ref.artifact.file.alpha"))
         (material (lisp-plus-lci0::record-field-named reference "material"))
         (bad-material
           (lci0-record-replace
            material "object-id" (lisp-plus-cd0:make-string-datum "host-value")))
         (bad-reference (lci0-record-replace reference "material" bad-material))
         (wrong-key-reference
           (lci0-record-rekey
            reference "domain"
            (lisp-plus-lci0::fixture-field-id "domain"))))
    (lci0-check "malformed-stable-ref-object-id-is-typed"
      (string= "InvalidStableReference"
               (lci0-refusal-code
                (lambda ()
                  (lisp-plus-lci0:validate-stable-ref bad-reference)))))
    (lci0-check "wrong-stable-ref-field-namespace-fails-closed"
      (let ((condition
              (lci0-capture-refusal
               (lambda ()
                 (lisp-plus-lci0:validate-stable-ref wrong-key-reference)))))
        (and condition
             (string= (lisp-plus-lci0:lci-failure-code condition)
                      "MissingRequiredField")
             (equal (lisp-plus-lci0:lci-failure-path condition) '("domain"))))))
  (let* ((exact
           (lisp-plus-lci0::registry-datum "stable-ref.artifact.file.alpha"))
         (aliases
           (list
            (list "mutable-alias-display-model" '("display-model"))
            (list "mutable-alias-filename" '("file.txt"))
            (list "mutable-alias-url" '("https://mutable.invalid/x"))
            (list "mutable-alias-latest-case-insensitive" '("LaTeSt"))
            (list "mutable-alias-main-case-insensitive" '("MAIN"))
            (list "mutable-alias-package-symbol" '("MNEME::FILE-EXISTS")))))
    (lci0-check "registered-file-reference-remains-valid"
      (lisp-plus-lci0:lci-value-p
       (lisp-plus-lci0:validate-stable-ref exact)))
    (dolist (case aliases)
      (let ((reference
              (lisp-plus-lci0::%migration-stable-ref "artifact" (second case))))
        (lci0-check (first case)
          (let ((condition
                  (lci0-capture-refusal
                   (lambda ()
                     (lisp-plus-lci0:validate-stable-ref reference)))))
            (and condition
                 (string= (lisp-plus-lci0:lci-failure-code condition)
                          "UnresolvedAlias")
                 (equal (lisp-plus-lci0:lci-failure-path condition)
                        '("material" "object-id")))))))
    (lci0-check "nested-stable-ref-alias-path-is-not-truncated"
      (let* ((reference
               (lisp-plus-lci0::%migration-stable-ref
                "artifact" '("display-model")))
             (condition
               (lci0-capture-refusal
                (lambda ()
                  (lisp-plus-lci0:validate-stable-ref
                   reference :path '("outer"))))))
        (and condition
             (string= (lisp-plus-lci0:lci-failure-code condition)
                      "UnresolvedAlias")
             (equal (lisp-plus-lci0:lci-failure-path condition)
                    '("outer" "material" "object-id")))))
    (let* ((material (lisp-plus-lci0::record-field-named exact "material"))
           (case-id
             (lisp-plus-cd0:make-identifier-datum
              '("lisp-plus" "lci" "0" "fixture")
              '("Object" "artifact" "file" "alpha.txt")))
           (joined-prefix-id
             (lisp-plus-cd0:make-identifier-datum
              '("lisp-plus" "lci" "0" "fixture")
              '("object/artifact" "file" "alpha.txt")))
           (segmented-tail-id
             (lisp-plus-cd0:make-identifier-datum
              '("lisp-plus" "lci" "0" "fixture")
              '("object" "artifact" "file/alpha.txt")))
           (with-id
             (lambda (object-id)
               (lci0-record-replace
                exact "material"
                (lci0-record-replace material "object-id" object-id)))))
      (lci0-check "stable-ref-prefix-case-is-not-normalized"
        (string= "InvalidStableReference"
                 (lci0-refusal-code
                  (lambda ()
                    (lisp-plus-lci0:validate-stable-ref
                     (funcall with-id case-id))))))
      (lci0-check "stable-ref-prefix-segmentation-is-not-normalized"
        (string= "InvalidStableReference"
                 (lci0-refusal-code
                  (lambda ()
                    (lisp-plus-lci0:validate-stable-ref
                     (funcall with-id joined-prefix-id))))))
      (lci0-check "stable-ref-tail-segmentation-remains-distinct"
        (let ((variant (funcall with-id segmented-tail-id)))
          (and (lisp-plus-lci0:lci-value-p
                (lisp-plus-lci0:validate-stable-ref variant))
               (not (lisp-plus-cd0:equal-datum exact variant))
               (not (string=
                     (lisp-plus-lci0::octets-to-hex
                      (lisp-plus-cd0:canonical-octets exact))
                     (lisp-plus-lci0::octets-to-hex
                      (lisp-plus-cd0:canonical-octets variant)))))))))
  (let* ((claim (lisp-plus-lci0::registry-datum
                 "claim-id.file-alpha-neutral"))
         (location (lisp-plus-lci0::record-field-named claim "location"))
         (scope (lisp-plus-lci0::record-field-named location "scope"))
         (bad-scope
           (lci0-record-replace scope "schema-version"
                                (lisp-plus-cd0:make-integer-datum 1)))
         (bad-location (lci0-record-replace location "scope" bad-scope))
         (bad-claim (lci0-record-replace claim "location" bad-location))
         (two-fault-claim
           (lci0-record-add bad-claim (lisp-plus-lci0::lci-id "future-field")
                            (lisp-plus-cd0:make-unit-datum)))
         (wrong-location-key
           (lci0-record-rekey
            claim "location" (lisp-plus-lci0::fixture-field-id "location")))
         (proposition (lisp-plus-lci0::record-field-named claim "proposition"))
         (bad-proposition
           (lci0-record-replace
            (lci0-record-replace
             proposition "kind" (lisp-plus-lci0::fixture-id "tag" "future"))
            "schema-version" (lisp-plus-cd0:make-integer-datum 1))))
    (lci0-check "e6-nested-declared-fault-precedes-later-unknown"
      (let ((condition
              (lci0-capture-refusal
               (lambda () (lisp-plus-lci0:validate-claim-id two-fault-claim)))))
        (and condition
             (string= (lisp-plus-lci0:lci-failure-code condition)
                      "RecursiveUnsupportedNestedVersion")
             (equal (lisp-plus-lci0:lci-failure-path condition)
                    '("location" "scope" "schema-version")))))
    (lci0-check "e6-kind-precedes-later-version"
      (let ((condition
              (lci0-capture-refusal
               (lambda ()
                 (lisp-plus-lci0:normalize-proposition bad-proposition)))))
        (and condition
             (string= (lisp-plus-lci0:lci-failure-code condition)
                      "UnnormalizedProposition")
             (equal (lisp-plus-lci0:lci-failure-path condition)
                    '("proposition" "kind")))))
    (lci0-check "wrong-claim-field-namespace-is-missing-not-inferred"
      (string= "MissingRequiredField"
               (lci0-refusal-code
                (lambda ()
                  (lisp-plus-lci0:validate-claim-id wrong-location-key))))))
  (let* ((claim
           (lisp-plus-lci0::registry-datum "claim-id.file-alpha-neutral"))
         (proposition
           (lisp-plus-lci0::record-field-named claim "proposition"))
         (arguments
           (lisp-plus-lci0::record-field-named proposition "arguments"))
         (artifact
           (lisp-plus-lci0::record-field-named arguments "artifact"))
         (unit-artifact
           (lci0-record-replace artifact "value"
                                (lisp-plus-cd0:make-unit-datum)))
         (unit-arguments
           (lci0-record-replace arguments "artifact" unit-artifact))
         (unit-proposition
           (lci0-record-replace proposition "arguments" unit-arguments))
         (open-artifact
           (lci0-record-add
            artifact
            (lisp-plus-cd0:make-identifier-datum
             lisp-plus-lci0::+proposition-field-namespace+
             '("future-field"))
            (lisp-plus-cd0:make-unit-datum)))
         (open-proposition
           (lci0-record-replace
            proposition "arguments"
            (lci0-record-replace arguments "artifact" open-artifact))))
    (lci0-check "proposition-subject-content-allows-arbitrary-cd0"
      (lisp-plus-cd0:equal-datum
       unit-proposition
       (lisp-plus-lci0:normalize-proposition unit-proposition)))
    (lci0-check "proposition-argument-wrapper-remains-closed"
      (let ((condition
              (lci0-capture-refusal
               (lambda ()
                 (lisp-plus-lci0:normalize-proposition open-proposition)))))
        (and condition
             (string= (lisp-plus-lci0:lci-failure-code condition)
                      "UnknownField")
             (equal (lisp-plus-lci0:lci-failure-path condition)
                    '("proposition" "arguments" "artifact"
                      "future-field"))))))
  (let* ((target (lisp-plus-lci0::registry-datum
                  "warrant-target.observed.file-alpha.exact"))
         (swapped
           (lci0-record-replace
            target "target-schema"
            (lisp-plus-lci0::registry-datum "stable-ref.target-schema.tested")))
         (boundaries (lisp-plus-lci0::record-field-named target "boundaries"))
         (open-boundaries
           (lci0-record-add boundaries
                            (lisp-plus-lci0::fixture-field-id "future-boundary")
                            (lisp-plus-cd0:make-unit-datum)))
         (open-target (lci0-record-replace target "boundaries" open-boundaries))
         (coverage
           (lisp-plus-lci0::record-field-named boundaries "coverage-scope"))
         (coverage-expression
           (lisp-plus-lci0::record-field-named coverage "expression"))
         (open-coverage-expression
           (lci0-record-add
            coverage-expression
            (lisp-plus-lci0::fixture-field-id "future-selector")
            (lisp-plus-cd0:make-unit-datum)))
         (open-coverage
           (lci0-record-replace coverage "expression"
                                open-coverage-expression))
         (nested-open-target
           (lci0-record-replace
            target "boundaries"
            (lci0-record-replace boundaries "coverage-scope" open-coverage)))
         (different-proposition
           (lisp-plus-lci0::registry-datum "claim-id.file-beta-neutral")))
    (lci0-check "target-schema-kind-swap-refused"
      (string= "TargetSchemaKindMismatch"
               (lci0-refusal-code
                (lambda () (lisp-plus-lci0:validate-warrant-target swapped)))))
    (lci0-check "target-boundary-record-is-closed"
      (string= "TargetBoundaryUnknown"
               (lci0-refusal-code
                (lambda ()
                  (lisp-plus-lci0:validate-warrant-target open-target)))))
    ;; LCI0-AC-007 (LCI0-ACV-HOSTILE-004): the depth-first coordinate is
    ;; retained, and the boundary-value defect now carries the ruled stage
    ;; target-boundary instead of the inner validator's stage.
    (lci0-check "nested-scope-unknown-field-retains-depth-first-failure"
      (let ((condition
              (lci0-capture-refusal
               (lambda ()
                 (lisp-plus-lci0:validate-warrant-target
                  nested-open-target)))))
        (and condition
             (string= (lisp-plus-lci0:lci-failure-category condition)
                      "invalid-input")
             (string= (lisp-plus-lci0:lci-failure-code condition)
                      "UnknownField")
             (string= (lisp-plus-lci0:lci-failure-stage condition)
                      "target-boundary")
             (equal (lisp-plus-lci0:lci-failure-path condition)
                    '("boundaries" "coverage-scope" "expression"
                      "future-selector")))))
    (lci0-check "target-proposition-mismatch-uses-specific-frozen-code"
      (string= "PropositionMismatch"
               (lci0-refusal-code
                (lambda ()
                  (lisp-plus-lci0:match-warrant-target
                   target different-proposition))))))
  (let* ((executed
           (lisp-plus-lci0::registry-datum "warrant-target.executed.call-17"))
         (org-claim
           (lisp-plus-lci0::registry-datum
            "claim-id.all-devices-encrypted-org"))
         (dept-claim
           (lisp-plus-lci0::registry-datum
            "claim-id.all-devices-encrypted-dept"))
         (org-scope
           (lisp-plus-lci0::record-field-named
            (lisp-plus-lci0::record-field-named org-claim "location") "scope"))
         (executed-boundaries
           (lisp-plus-lci0::record-field-named executed "boundaries"))
         (transplanted
           (lci0-record-replace
            (lci0-record-replace executed "claim" org-claim)
            "boundaries"
            (lci0-record-replace executed-boundaries "coverage-scope"
                                 org-scope)))
         (observed
           (lisp-plus-lci0::registry-datum
            "warrant-target.observed.file-alpha.exact"))
         (observed-boundaries
           (lisp-plus-lci0::record-field-named observed "boundaries"))
         (bad-coverage-target
           (lci0-record-replace
            observed "boundaries"
            (lci0-record-replace
             observed-boundaries "coverage-scope"
             (lisp-plus-lci0::registry-datum "scope.tenant-b"))))
         (corpus-target
           (lisp-plus-lci0::registry-datum
            "warrant-target.corpus-completion.absence-docs.complete"))
         (corpus-boundaries
           (lisp-plus-lci0::record-field-named corpus-target "boundaries"))
         (bad-basis-target
           (lci0-record-replace
            corpus-target "boundaries"
            (lci0-record-replace
             corpus-boundaries "exact-corpus-basis"
             (lisp-plus-lci0::registry-datum
              "claim-basis.alpha-r3-all-manifest3")))))
    (lci0-check "nonmonotone-schema-cannot-borrow-proposition-narrowing"
      (string= "ScopeNarrowingNotDeclared"
               (lci0-refusal-code
                (lambda ()
                  (lisp-plus-lci0:match-warrant-target
                   transplanted dept-claim)))))
    (lci0-check "equal-target-scope-still-requires-exact-coverage"
      (string= "TargetBoundaryMismatch"
               (lci0-refusal-code
                (lambda ()
                  (lisp-plus-lci0:match-warrant-target
                   bad-coverage-target
                   (lisp-plus-lci0::record-field-named observed "claim"))))))
    (lci0-check "corpus-completion-exact-basis-is-cross-checked"
      (string= "BasisMismatch"
               (lci0-refusal-code
                (lambda ()
                  (lisp-plus-lci0:match-warrant-target
                   bad-basis-target
                   (lisp-plus-lci0::record-field-named corpus-target
                                                        "claim")))))))
  (let* ((r3
           (lisp-plus-lci0::registry-datum
            "claim-basis.alpha-r3-all-manifest3"))
         (beta-revision
           (lci0-record-replace
            r3 "revision"
            (lisp-plus-lci0::registry-datum "stable-ref.revision.beta.1")))
         (r4
           (lisp-plus-lci0::registry-datum
            "claim-basis.alpha-r4-all-manifest4"))
         (r4-boundary
           (lisp-plus-lci0::record-field-named r4 "semantic-boundary"))
         (cross-revision-boundary
           (lci0-record-replace r3 "semantic-boundary" r4-boundary)))
    (lci0-check "corpus-and-revision-stable-refs-must-cohere"
      (string= "InvalidBasis"
               (lci0-refusal-code
                (lambda ()
                  (lisp-plus-lci0:validate-corpus-basis beta-revision)))))
    ;; LCI0-AC-006: the retained r3/r4 mixed witness is rejected with the
    ;; exact ruled tuple after the declared cross-field checks: invalid-input
    ;; / BasisMismatch / corpus-basis at /semantic-boundary/manifest/revision
    ;; with both offending revisions in closed context.
    (lci0-check "corpus-boundary-cross-coherence-exact-tuple-LCI0-AC-006"
      (let ((condition
              (lci0-capture-refusal
               (lambda ()
                 (lisp-plus-lci0:validate-corpus-basis
                  cross-revision-boundary)))))
        (and condition
             (string= (lisp-plus-lci0:lci-failure-category condition)
                      "invalid-input")
             (string= (lisp-plus-lci0:lci-failure-code condition)
                      "BasisMismatch")
             (string= (lisp-plus-lci0:lci-failure-stage condition)
                      "corpus-basis")
             (equal (lisp-plus-lci0:lci-failure-path condition)
                    '("semantic-boundary" "manifest" "revision"))
             (let ((context (lisp-plus-lci0:lci-failure-context condition)))
               (and (= 3 (lisp-plus-cd0:integer-datum-value
                          (lisp-plus-lci0::record-field-named
                           context "basis_revision")))
                    (= 4 (lisp-plus-cd0:integer-datum-value
                          (lisp-plus-lci0::record-field-named
                           context "semantic_boundary_manifest_revision")))))))))
  (let* ((occurrence (lisp-plus-lci0::registry-datum "claim-occurrence.alpha"))
         (metadata
           (lisp-plus-lci0::record-field-named occurrence
                                                "nonidentity-metadata"))
         (entries (lisp-plus-lci0::record-field-named metadata "entries"))
         (open-entries
           (lci0-record-add entries
                            (lisp-plus-lci0::fixture-id "metadata" "new-key")
                            (lisp-plus-cd0:make-string-datum "inert")))
         (open-metadata (lci0-record-replace metadata "entries" open-entries))
         (open-occurrence
           (lci0-record-replace occurrence "nonidentity-metadata" open-metadata))
         (bad-occurrence
           (lci0-record-add occurrence
                            (lisp-plus-lci0::fixture-field-id "future-field")
                            (lisp-plus-cd0:make-unit-datum))))
    (lci0-check "only-occurrence-metadata-entries-is-open"
      (lisp-plus-lci0:lci-value-p
       (lisp-plus-lci0:validate-claim-occurrence open-occurrence)))
    (lci0-check "occurrence-wrapper-remains-closed"
      (string= "UnknownField"
               (lci0-refusal-code
                (lambda ()
                  (lisp-plus-lci0:validate-claim-occurrence bad-occurrence))))))
  (let* ((occurrence
           (lisp-plus-lci0::registry-datum "claim-occurrence.alpha"))
         (bad-occurrence
           (lci0-record-replace occurrence "claimant"
                                (lisp-plus-cd0:make-unit-datum)))
         (condition
           (lci0-capture-refusal
            (lambda ()
              (lci0-execute-operation
               "project-occurrence"
               (lisp-plus-lci0::make-fixture-record
                (list "occurrence" bad-occurrence)))))))
    (lci0-check "operation-recursively-validates-occurrence-wrapper"
      (typep condition 'lisp-plus-lci0:lci-failure)))
  (let* ((loss (lisp-plus-lci0::registry-datum
                "represented-loss.migration-identity-neutral"))
         (account (lisp-plus-lci0::record-field-named loss "account"))
         (wrong-type-account
           (lci0-record-replace account "source-format"
                                (lisp-plus-cd0:make-string-datum "v1")))
         (wrong-type-loss (lci0-record-replace loss "account" wrong-type-account))
         (future-schema-account
           (lci0-record-replace
            account "account-schema"
            (lisp-plus-lci0::fixture-id
             "represented-loss-account-schema" "future" "0")))
         (future-schema-loss
           (lci0-record-replace loss "account" future-schema-account))
         (open-account
           (lci0-record-add account
                            (lisp-plus-lci0::fixture-field-id "future-field")
                            (lisp-plus-cd0:make-unit-datum)))
         (open-loss (lci0-record-replace loss "account" open-account)))
    (lci0-blocked-check
        "represented-loss-field-type-has-no-frozen-lci-failure-code"
      (let ((condition
              (lci0-capture-authorial-gap
               (lambda ()
                 (lisp-plus-lci0:validate-represented-loss wrong-type-loss)))))
        (and condition
             (string=
              (lisp-plus-lci0::fixture-operation-authorial-gap-operation
               condition)
              "represented-loss-validation"))))
    (lci0-check "represented-loss-account-schema-is-finite"
      (string= "UnsupportedRepresentedLossAccountSchema"
               (lci0-refusal-code
                (lambda ()
                  (lisp-plus-lci0:validate-represented-loss
                   future-schema-loss)))))
    (lci0-check "represented-loss-account-is-closed"
      (string= "UnknownField"
               (lci0-refusal-code
                (lambda ()
                  (lisp-plus-lci0:validate-represented-loss open-loss))))))
  (let* ((source (lisp-plus-lci0::registry-datum "legacy-source.time-100"))
         (parsed (lisp-plus-lci0:parse-legacy-fixture source))
         (declared-source
           (lisp-plus-lci0::%migration-stable-ref
            "artifact" '("legacy-source" "explicit-mismatch")))
         (source-with-explicit-mismatch
           (lci0-record-replace source "source-artifact" declared-source))
         (expected-claim-id
           (lisp-plus-lci0::registry-datum "claim-id.migration-time-100"))
         (original-registry
           (symbol-function 'lisp-plus-lci0::registry-datum))
         (result nil))
    (lci0-check "successful-bare-inert-record-has-no-source-binding"
      (string= "MissingRequiredField"
               (lci0-refusal-code
                (lambda () (lisp-plus-lci0:migrate-v1-fixture parsed)))))
    (lci0-check "migration-constructs-with-registry-result-oracle-poisoned"
      (unwind-protect
           (progn
             (setf (symbol-function 'lisp-plus-lci0::registry-datum)
                   (lambda (&rest arguments)
                     (declare (ignore arguments))
                     (error "migration attempted a registry result lookup")))
             (setf result
                   (lisp-plus-lci0:migrate-v1-fixture
                    source-with-explicit-mismatch))
             (and
              (lisp-plus-cd0:equal-datum
               (lisp-plus-lci0::record-field-named result "source")
               declared-source)
              (lisp-plus-cd0:equal-datum
               (lisp-plus-lci0::record-field-named result "claim-id")
               expected-claim-id)
              (let* ((lineage
                       (lisp-plus-lci0::record-field-named result "lineage"))
                     (edge (lisp-plus-cd0:sequence-datum-ref lineage 0)))
                (lisp-plus-cd0:equal-datum
                 (lisp-plus-lci0::record-field-named edge "source")
                 declared-source))))
        (setf (symbol-function 'lisp-plus-lci0::registry-datum)
              original-registry)))
    (lci0-check "migration-propagates-explicit-source-artifact"
      (and
       (lisp-plus-cd0:equal-datum
        (lisp-plus-lci0::record-field-named result "source") declared-source)
       (lisp-plus-cd0:equal-datum
        (lisp-plus-lci0::record-field-named result "claim-id")
        expected-claim-id)
       (let* ((lineage (lisp-plus-lci0::record-field-named result "lineage"))
              (edge (lisp-plus-cd0:sequence-datum-ref lineage 0)))
         (lisp-plus-cd0:equal-datum
          (lisp-plus-lci0::record-field-named edge "source")
          declared-source))))
    (let* ((other-claim
             (lisp-plus-lci0::registry-datum "claim-id.migration-time-124"))
           (stale (lci0-record-replace result "claim-id" other-claim))
           (open-result
             (lci0-record-add result (lisp-plus-lci0::lci-id "future-field")
                              (lisp-plus-cd0:make-unit-datum))))
      (lci0-check "migration-result-recomputes-claim-id"
        (string= "ClaimIdCacheMismatch"
                 (lci0-refusal-code
                  (lambda ()
                    (lisp-plus-lci0:validate-migration-result stale)))))
      (lci0-check "migration-result-is-closed"
        (string= "UnknownField"
                 (lci0-refusal-code
                  (lambda ()
                    (lisp-plus-lci0:validate-migration-result open-result)))))))
  (lci0-check "migration-recognizes-only-seven-errata-classifications"
    (equal (sort (copy-list lisp-plus-lci0::+migration-classifications+)
                 #'string<)
           (sort (copy-list
                  '("exact" "exact-after-explicit-tagging"
                    "new-identity-required" "lossy-with-represented-loss"
                    "rejected" "deferred-to-named-calculus"
                    "privileged-runtime-relation-outside-claim-id"))
                 #'string<)))
  (lci0-check "every-operation-empty-payload-refuses-with-typed-lci-failure"
    (every
     (lambda (entry)
       (typep
        (lci0-capture-refusal
         (lambda ()
           (lci0-execute-operation
            (first entry) (lisp-plus-lci0::make-fixture-record))))
        'lisp-plus-lci0:lci-failure))
     lisp-plus-lci0::+operation-payload-shapes+))
  (lci0-check "every-operation-unknown-payload-refuses-with-typed-lci-failure"
    (every
     (lambda (entry)
       (typep
        (lci0-capture-refusal
         (lambda ()
           (lci0-execute-operation
            (first entry)
            (lisp-plus-lci0::make-fixture-record
             (list "future-field" (lisp-plus-cd0:make-unit-datum))))))
        'lisp-plus-lci0:lci-failure))
     lisp-plus-lci0::+operation-payload-shapes+))
  (lci0-check "placement-negative-remains-an-executed-regression"
    (lisp-plus-lci0:run-vector-selection '("LCI0-N014")))
  (let* ((payload (lci0-vector-payload "LCI0-N031"))
         (evidence
           (lisp-plus-lci0::record-field-named payload "evidence"))
         (equal-evidence
           (lci0-record-replace
            evidence "right-output"
            (lisp-plus-lci0::record-field-named evidence "left-output")))
         (condition
           (lci0-capture-authorial-gap
            (lambda ()
              (lci0-execute-operation
               "differential-project"
               (lci0-record-replace payload "evidence" equal-evidence))))))
    (lci0-blocked-check
        "equal-differential-evidence-has-no-frozen-result-vocabulary"
      (and condition
           (string=
            (lisp-plus-lci0::fixture-operation-authorial-gap-operation
             condition)
            "differential-project")
           (equal
            (lisp-plus-lci0::fixture-operation-authorial-gap-path condition)
            '("evidence" "right-output")))))
  (let* ((payload
           (lci0-vector-payload "LCI0-E4-STRUCTURAL-DATASET-SLICE"))
         (left (lisp-plus-lci0::record-field-named payload "left"))
         (bad-normalizer
           (lci0-record-replace payload "normalizer"
                                (lisp-plus-cd0:make-unit-datum)))
         (wrong-coordinate
           (lci0-record-replace
            payload "coordinate"
            (lisp-plus-lci0::fixture-id "claim-coordinate" "scope")))
         (equal-payload (lci0-record-replace payload "right" left)))
    (lci0-blocked-check
        "unknown-normalizer-has-no-frozen-lci-failure-tuple"
      (typep
       (lci0-capture-authorial-gap
        (lambda ()
          (lci0-execute-operation "normalize-preprojection-coordinate"
                                  bad-normalizer)))
       'lisp-plus-lci0::fixture-operation-authorial-gap))
    (lci0-check "normalization-operation-validates-coordinate-against-values"
      (typep
       (lci0-capture-refusal
        (lambda ()
          (lci0-execute-operation "normalize-preprojection-coordinate"
                                  wrong-coordinate)))
       'lisp-plus-lci0:lci-failure))
    (lci0-check "equal-e4-inputs-derive-merge-permitted"
      (lci0-true-p
       (lci0-result-output
        (lci0-execute-operation "normalize-preprojection-coordinate"
                                equal-payload)
        "claim-id-merge-permitted"))))
  (let* ((payload (lci0-vector-payload "LCI0-E8-DIGEST-NOT-ENVELOPE"))
         (left
           (lisp-plus-lci0::record-field-named payload "left-claim-id"))
         (equal-payload (lci0-record-replace payload "right-claim-id" left))
         (bad-payload
           (lci0-record-replace
            payload "left-operational-digest"
            (lisp-plus-cd0:make-bytes-datum
             (make-array 1 :element-type '(unsigned-byte 8)
                           :initial-element 0)))))
    (lci0-check "equal-e8-envelopes-derive-semantic-equality"
      (lci0-true-p
       (lci0-result-output
        (lci0-execute-operation "compare-claim-digests-and-envelopes"
                                equal-payload)
        "semantic-claim-id-equal")))
    (lci0-blocked-check
        "invalid-test-digest-material-has-no-frozen-lci-failure-tuple"
      (typep
       (lci0-capture-authorial-gap
        (lambda ()
          (lci0-execute-operation "compare-claim-digests-and-envelopes"
                                  bad-payload)))
       'lisp-plus-lci0::fixture-operation-authorial-gap)))
  (let* ((migration-result
           (lisp-plus-lci0::registry-datum "migration-result.time-100"))
         (condition
           (lci0-capture-authorial-gap
            (lambda ()
              (lci0-execute-operation
               "validate-migration-result"
               (lisp-plus-lci0::make-fixture-record
                (list "migration-result" migration-result)))))))
    (lci0-blocked-check
        "valid-migration-result-has-no-frozen-positive-output-schema"
      (and condition
           (string=
            (lisp-plus-lci0::fixture-operation-authorial-gap-operation
             condition)
            "validate-migration-result")
           (equal
            (lisp-plus-lci0::fixture-operation-authorial-gap-path condition)
            '("migration-result")))))
  (let* ((record-order (lci0-vector-payload "LCI0-P002"))
         (bad-order
           (lci0-record-replace
            record-order "left-construction-order"
            (lisp-plus-cd0:make-unit-datum)))
         (governance
           (lci0-vector-payload "LCI0-E3-IMPLEMENTATION-CORRECTION"))
         (bad-governance
           (lci0-record-replace
            governance "claim-ids-unchanged"
            (lisp-plus-cd0:make-boolean-datum nil)))
         (normalizer
           (lci0-vector-payload "LCI0-E3-NORMALIZER-BINDING"))
         (binding
           (lisp-plus-lci0::record-field-named normalizer "binding"))
         (bad-normalizer
           (lci0-record-replace
            normalizer "binding"
            (lci0-record-replace binding "pure"
                                 (lisp-plus-cd0:make-boolean-datum nil))))
         (scheme (lci0-vector-payload "LCI0-E7-SCHEME-01"))
         (bad-scheme
           (lci0-record-replace scheme "canonical-scheme"
                                (lisp-plus-cd0:make-unit-datum)))
         (bridge (lci0-vector-payload "LCI0-E7-BRIDGE-PRESENT"))
         (bridge-definition
           (lisp-plus-lci0::record-field-named bridge "bridge"))
         (bad-bridge
           (lci0-record-replace
            bridge "bridge"
            (lci0-record-replace bridge-definition "mapping"
                                 (lisp-plus-cd0:make-unit-datum))))
         (translation (lci0-vector-payload "LCI0-P026"))
         (bad-translation
           (lci0-record-replace
            translation "target-claim"
            (lisp-plus-lci0::record-field-named translation "source-claim")))
         (restoration (lci0-vector-payload "LCI0-N029"))
         (bad-restoration
           (lci0-record-replace restoration "source"
                                (lisp-plus-cd0:make-unit-datum))))
    (dolist
        (case
         (list
          (list "stable-ref-scheme-declaration-is-observed"
                "validate-stable-ref-scheme-selection" bad-scheme)
          (list "bridge-nested-shape-refuses-before-host-access"
                "apply-stable-ref-bridge" bad-bridge)
          (list "live-restoration-source-is-recursively-validated"
                "restore-live-warrant" bad-restoration)))
      (lci0-check (first case)
        (typep
         (lci0-capture-refusal
          (lambda () (lci0-execute-operation (second case) (third case))))
         'lisp-plus-lci0:lci-failure)))
    (dolist
        (case
         (list
          (list "record-order-mutation-has-no-frozen-lci-failure-tuple"
                "canonicalize-record-order" bad-order)
          (list "version-governance-mutation-has-no-frozen-lci-failure-tuple"
                "classify-version-governance" bad-governance)
          (list "normalizer-evidence-mutation-has-no-frozen-lci-failure-tuple"
                "validate-normalizer-conformance-evidence" bad-normalizer)
          (list "equal-lossy-translation-has-no-frozen-result-tuple"
                "translate-with-represented-loss" bad-translation)))
      (lci0-blocked-check (first case)
        (typep
         (lci0-capture-authorial-gap
          (lambda () (lci0-execute-operation (second case) (third case))))
         'lisp-plus-lci0::fixture-operation-authorial-gap))))
  (let* ((profile-location
           (lisp-plus-lci0::registry-datum "mneme.profile-location.empty.0"))
         (open
           (lci0-record-add
            profile-location
            (lisp-plus-lci0::lci-id "future-field")
            (lisp-plus-cd0:make-unit-datum))))
    (lci0-check "profile-location-operation-validates-closed-value"
      (typep
       (lci0-capture-refusal
        (lambda ()
          (lci0-execute-operation
           "validate-profile-location"
           (lisp-plus-lci0::make-fixture-record
            (list "profile-location" open)))))
       'lisp-plus-lci0:lci-failure)))
  ;; LCI0-AC-010 (LCI0-ACV-ORIG-004): P024 emits the exact inert defensive
  ;; result from supplied fields only.  The former blocked witness ("the
  ;; expected beta occurrence has no input source") is closed: no claimant,
  ;; assertion time, provenance edge, standing effect, warrant effect,
  ;; authority, custody, or verified lineage is synthesized; zero live
  ;; warrants are created; production revival remains deferred.  The
  ;; whole-registry poison proves no ambient registry lookup sources any
  ;; output field.
  (let* ((payload (lci0-vector-payload "LCI0-P024"))
         (original-registry
           (symbol-function 'lisp-plus-lci0::registry-datum))
         (result
           (unwind-protect
                (progn
                  (setf (symbol-function 'lisp-plus-lci0::registry-datum)
                        (lambda (&rest arguments)
                          (declare (ignore arguments))
                          (error "revival attempted a registry lookup")))
                  (lci0-execute-operation "revive-inert-occurrence" payload))
             (setf (symbol-function 'lisp-plus-lci0::registry-datum)
                   original-registry)))
         (production (lci0-result-output result "production_revival"))
         (value (lci0-result-output result "value")))
    (flet ((value-field (name) (lisp-plus-lci0::record-field-named value name)))
      (lci0-check "p024-inert-defensive-revival-without-registry-lookup"
        (and (string= (lisp-plus-cd0:string-datum-value production) "deferred")
             (string= (lisp-plus-cd0:string-datum-value (value-field "mode"))
                      "inert-defensive-reconstruction")
             (string= (lisp-plus-cd0:string-datum-value
                       (value-field "predecessor"))
                      "defensive copy of supplied predecessor only")
             (string= (lisp-plus-cd0:string-datum-value
                       (value-field "requested_claim"))
                      "preserve supplied ClaimId exactly")
             (lisp-plus-cd0:unit-datum-p (value-field "claimant"))
             (lisp-plus-cd0:unit-datum-p (value-field "assertion_time"))
             (lisp-plus-cd0:unit-datum-p (value-field "provenance_edge"))
             (lisp-plus-cd0:unit-datum-p (value-field "authority"))
             (lisp-plus-cd0:unit-datum-p (value-field "custody"))
             (zerop (lisp-plus-cd0:integer-datum-value
                     (value-field "live_warrants_created")))
             (not (lci0-true-p (value-field "standing_effect")))
             (not (lci0-true-p (value-field "warrant_effect")))
             (not (lci0-true-p (value-field "verified_lineage")))))))
  ;; The four formerly-blocked official vectors are closed by the 0.2
  ;; fixture-authority overlay: LCI0-AC-001 (N012 matcher symbolic guard),
  ;; LCI0-AC-003 (E5 input-derived coverage context), LCI0-AC-010 (P024
  ;; inert defensive revival), LCI0-AC-004 (P029 source preservation,
  ;; already conforming).  With the overlay installed the selection passes
  ;; against the superseding expectations; the historical red-witness
  ;; transcripts under evidence/ remain unchanged records of the pre-closure
  ;; state.
  (dolist
      (case
       '(("official-green-N012-closed-by-LCI0-AC-001"
          "LCI0-N012")
         ("official-green-E5-closed-by-LCI0-AC-003"
          "LCI0-E5-COVERAGE-INSUFFICIENT")
         ("official-green-P024-closed-by-LCI0-AC-010"
          "LCI0-P024")
         ("official-green-P029-closed-by-LCI0-AC-004"
          "LCI0-P029")))
    (lci0-check (first case)
      (lisp-plus-lci0:run-vector-selection (list (second case)))))
  (let* ((policy-a
           (lisp-plus-lci0::registry-datum "admissibility-policy.a.0"))
         (policy-b
           (lisp-plus-lci0::registry-datum "admissibility-policy.b.0"))
         (observed
           (lisp-plus-lci0::registry-datum
            "warrant-target.observed.file-alpha.exact"))
         (observed-claim
           (lisp-plus-lci0::record-field-named observed "claim"))
         (observed-relation
           (lisp-plus-lci0:match-warrant-target observed observed-claim))
         (trusted
           (lisp-plus-lci0::registry-datum
            "warrant-target.externally-attested.file-alpha.trusted"))
         (trusted-relation
           (lisp-plus-lci0:match-warrant-target
            trusted (lisp-plus-lci0::record-field-named trusted "claim")))
         (untrusted
           (lisp-plus-lci0::registry-datum
            "warrant-target.externally-attested.file-alpha.untrusted"))
         (untrusted-relation
           (lisp-plus-lci0:match-warrant-target
            untrusted (lisp-plus-lci0::record-field-named untrusted "claim")))
         (query-124
           (lisp-plus-lci0::registry-datum "event-time.query-124"))
         (query-expression
           (lisp-plus-lci0::record-field-named query-124 "expression"))
         (query-125
           (lci0-record-replace
            query-124 "expression"
            (lci0-record-replace query-expression "tick"
                                 (lisp-plus-cd0:make-integer-datum 125))))
         (query-300
           (lisp-plus-lci0::registry-datum "event-time.query-300"))
         (loss
           (lisp-plus-lci0::registry-datum
            "represented-loss.translation-semantic"))
         (expected-a-external
           (lisp-plus-lci0::registry-datum
            "admissibility-decision.a-external-reject"))
         (expected-b-external
           (lisp-plus-lci0::registry-datum
            "admissibility-decision.b-external-trusted"))
         (expected-a-fresh
           (lisp-plus-lci0::registry-datum
            "admissibility-decision.a-observed-fresh"))
         (expected-a-stale
           (lisp-plus-lci0::registry-datum
            "admissibility-decision.a-observed-stale"))
         (original-registry
           (symbol-function 'lisp-plus-lci0::registry-datum))
         (oracle-independent nil))
    (unwind-protect
         (progn
           (setf
            (symbol-function 'lisp-plus-lci0::registry-datum)
            (lambda (&rest arguments)
              (let ((identifier (first arguments)))
                (if (and (stringp identifier)
                         (eql 0 (search "admissibility-decision."
                                        identifier)))
                    (error "policy attempted a whole-decision oracle lookup")
                    (apply original-registry arguments)))))
           (setf
            oracle-independent
            (and
             (lisp-plus-cd0:equal-datum
              (lisp-plus-lci0:evaluate-fixture-policy
               policy-a trusted-relation :target trusted)
              expected-a-external)
             (lisp-plus-cd0:equal-datum
              (lisp-plus-lci0:evaluate-fixture-policy
               policy-b trusted-relation :target trusted)
              expected-b-external)
             (lisp-plus-cd0:equal-datum
              (lisp-plus-lci0:evaluate-fixture-policy
               policy-a observed-relation :target observed)
              expected-a-fresh)
             (lisp-plus-cd0:equal-datum
              (lisp-plus-lci0:evaluate-fixture-policy
               policy-a observed-relation :target observed
               :query-time query-300)
              expected-a-stale))))
      (setf (symbol-function 'lisp-plus-lci0::registry-datum)
            original-registry))
    (lci0-check "fixture-policies-construct-with-decision-oracles-poisoned"
      oracle-independent)
    (let* ((policy-c
             (lci0-record-replace
              policy-a "policy"
              (lisp-plus-lci0::fixture-id "policy" "c" "0")))
           (condition
             (lci0-capture-authorial-gap
              (lambda ()
                (lisp-plus-lci0:evaluate-fixture-policy
                 policy-c observed-relation :target observed)))))
      (lci0-blocked-check
          "policy-c-is-an-authorial-gap-not-an-lci-failure"
        (and
         condition
         (not (typep condition 'lisp-plus-lci0:lci-failure))
         (string=
          (lisp-plus-lci0::fixture-operation-authorial-gap-operation condition)
          "evaluate-fixture-policy")
         (equal
          (lisp-plus-lci0::fixture-operation-authorial-gap-path condition)
          '("policy")))))
    (let* ((age-one
             (lisp-plus-lci0:evaluate-fixture-policy
              policy-a observed-relation :target observed
              :query-time query-125))
           (freshness
             (lisp-plus-lci0::record-field-named age-one "freshness")))
      (lci0-check "policy-freshness-is-derived-from-mutated-query-time"
        (and
         (= (lisp-plus-cd0:integer-datum-value
             (lisp-plus-lci0::record-field-named freshness "age-ticks"))
            1)
         (not (lisp-plus-cd0:equal-datum age-one expected-a-fresh)))))
    (let ((loss-decision
            (lisp-plus-lci0:evaluate-fixture-policy
             policy-b trusted-relation :target trusted
             :represented-loss loss)))
      (lci0-check "policy-b-observes-explicit-represented-loss"
        (and
         (not (lci0-true-p
               (lisp-plus-lci0::record-field-named loss-decision
                                                    "admitted")))
         (string=
          (lisp-plus-lci0::identifier-last
           (lisp-plus-lci0::record-field-named loss-decision "decision"))
          "reject-represented-loss"))))
    ;; LCI0-AC-005: the one authorized external-principal rejection carries
    ;; the registered decision spelling reject-external-principal.
    (lci0-check "policy-b-untrusted-external-rejects-external-principal"
      (let ((decision
              (lisp-plus-lci0:evaluate-fixture-policy
               policy-b untrusted-relation :target untrusted)))
        (and (not (lci0-true-p
                   (lisp-plus-lci0::record-field-named decision "admitted")))
             (string=
              (lisp-plus-lci0::identifier-last
               (lisp-plus-lci0::record-field-named decision "decision"))
              "reject-external-principal"))))
    ;; LCI0-AC-005: input-sensitive combined evaluation in the ruled order —
    ;; the all-at-once stale + represented-loss + untrusted-principal witness
    ;; is rejected on its represented loss first.
    (lci0-check "policy-combined-witness-rejects-represented-loss-first"
      (let ((decision
              (lisp-plus-lci0:evaluate-fixture-policy
               policy-b untrusted-relation :target untrusted
               :query-time query-300 :represented-loss loss)))
        (and (not (lci0-true-p
                   (lisp-plus-lci0::record-field-named decision "admitted")))
             (string=
              (lisp-plus-lci0::identifier-last
               (lisp-plus-lci0::record-field-named decision "decision"))
              "reject-represented-loss"))))
    (let* ((meta
             (lisp-plus-lci0::registry-datum
              "warrant-target.policy-evaluation.file-alpha.meta"))
           (relation
             (lisp-plus-lci0:match-warrant-target
              meta (lisp-plus-lci0::record-field-named meta "claim")))
           (a (lisp-plus-lci0:evaluate-fixture-policy
               policy-a relation :target meta))
           (b (lisp-plus-lci0:evaluate-fixture-policy
               policy-b relation :target meta)))
      (lci0-check "policy-evaluation-is-limited-meta-testimony-only"
        (and
         (not (lci0-true-p
               (lisp-plus-lci0::record-field-named a "admitted")))
         (string=
          (lisp-plus-lci0::identifier-last
           (lisp-plus-lci0::record-field-named a "decision"))
          "reject-target-kind")
         (lci0-true-p
          (lisp-plus-lci0::record-field-named b "admitted"))
         (string=
          (lisp-plus-lci0::identifier-last
           (lisp-plus-lci0::record-field-named b "decision"))
          "accept-limited-testimony")
         (string=
          (lisp-plus-lci0::identifier-last
           (lisp-plus-lci0::record-field-named b "testimony-class"))
          "limited-testimony")))))
  (let* ((large (lisp-plus-cd0:make-string-datum
                 (make-string 70000 :initial-element #\a)))
         (left (lisp-plus-lci0::make-fixture-record (list "blob" large)))
         (right (lisp-plus-lci0::make-fixture-record (list "blob" large))))
    (dolist (case
             (list
              (cons "matching-combined-payload-budget-root"
                    (lambda () (lisp-plus-lci0:match-warrant-target left right)))
              (cons "scope-combined-payload-budget-root"
                    (lambda () (lisp-plus-lci0:scope-relation left right)))
              (cons "temporal-combined-payload-budget-root"
                    (lambda () (lisp-plus-lci0:temporal-relation left right)))))
      (lci0-check (car case)
        (string= "LCIAggregatePayloadBudgetExceeded"
                 (lci0-refusal-code (cdr case))))))
  (let* ((unrelated-material
           (lisp-plus-lci0::make-fixture-record
            (list "material"
                  (lisp-plus-cd0:make-bytes-datum
                   (make-array 5000 :element-type '(unsigned-byte 8)
                                     :initial-element 0)))))
         (wrong-kind-target
           (lisp-plus-lci0::make-lci-record
            (list "kind" (lisp-plus-lci0::fixture-id "tag" "warrant-target"))
            (list "lci-version" (lisp-plus-cd0:make-integer-datum 0))
            (list "target-kind" (lisp-plus-lci0::fixture-id "target-kind" "x"))
            (list "target-schema" (lisp-plus-cd0:make-unit-datum))
            (list "claim" (lisp-plus-cd0:make-unit-datum))
            (list "boundaries"
                  (lisp-plus-lci0::make-fixture-record
                   (list "large" (lisp-plus-cd0:make-sequence-datum
                                  (loop repeat 70 collect
                                        (lisp-plus-cd0:make-unit-datum))))))))
         (wrong-kind-loss
           (lisp-plus-lci0::make-lci-record
            (list "kind" (lisp-plus-lci0::fixture-id "tag" "represented-loss"))
            (list "schema-version" (lisp-plus-cd0:make-integer-datum 0))
            (list "operation" (lisp-plus-cd0:make-unit-datum))
            (list "source" (lisp-plus-cd0:make-unit-datum))
            (list "lost-dimensions" (lisp-plus-cd0:make-sequence-datum nil))
            (list "consequence" (lisp-plus-cd0:make-unit-datum))
            (list "account"
                  (lisp-plus-lci0::make-fixture-record
                   (list "entries" (lisp-plus-cd0:make-sequence-datum
                                    (loop repeat 70 collect
                                          (lisp-plus-cd0:make-unit-datum)))))))))
    (lci0-check "unrelated-material-does-not-count-as-stable-reference"
      (zerop (lci0-metric unrelated-material
                          "stable-reference-material-octets")))
    (lci0-check "wrong-kind-target-does-not-count-boundary-work"
      (zerop (lci0-metric wrong-kind-target "target-boundary-work")))
    (lci0-check "wrong-kind-loss-does-not-count-account-entries"
      (zerop (lci0-metric wrong-kind-loss
                          "represented-loss-account-entries"))))
  (format t
          "LCI0 COMMON LISP UNIT SUMMARY: ~D passed, ~D failed, ~D blocked, ~D total~%"
          *lci0-test-passes* *lci0-test-failures* *lci0-test-blocked*
          (+ *lci0-test-passes* *lci0-test-failures* *lci0-test-blocked*))
  (zerop *lci0-test-failures*))
