(in-package #:lisp-plus-lci0)

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
  (error 'lci-failure :category category :code code :stage stage
                      :path (copy-list path) :context context))

(defclass lci-value ()
  ((kind :initarg :kind :reader lci-value-kind)
   (datum :initarg :datum :reader %lci-value-datum)
   (octets :initarg :octets :reader %lci-value-octets)))

(defun lci-value-p (value) (typep value 'lci-value))

(defun lci-value-datum (value)
  (unless (lci-value-p value)
    (lci-fail "invalid-input" "InvalidLCIValue" "host-import"))
  (%lci-value-datum value))

(defun lci-value-octets (value)
  (octets-copy (%lci-value-octets value)))

(defun make-lci-value (kind datum)
  (unless (datum-p datum)
    (lci-fail "invalid-input" "InvalidLCIValue" "host-import"))
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

(defun datum-integer-value* (datum)
  (and (integer-datum-p datum) (integer-datum-value datum)))

(defun datum-string-value* (datum)
  (and (string-datum-p datum) (string-datum-value datum)))

(defun require-record (datum code stage path)
  (unless (record-datum-p datum)
    (lci-fail "invalid-input" code stage :path path))
  datum)

(defun require-closed-fields (datum expected stage &key
                                      (missing-code "MissingRequiredField")
                                      (unknown-code "UnknownField")
                                      path-prefix context)
  (require-record datum "InvalidRecord" stage path-prefix)
  ;; Required-field precedence follows the declared field order.
  (dolist (field expected)
    (unless (record-has-field-p datum field)
      (lci-fail "invalid-input" missing-code stage
                :path (append path-prefix (list field)) :context context)))
  ;; Unknown fields are checked in CD/0 canonical record order.
  (dolist (field (record-field-names datum))
    (unless (member field expected :test #'string=)
      (lci-fail "invalid-input" unknown-code stage
                :path (append path-prefix (list field)) :context context)))
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
    (lci-fail "invalid-input" "UnsupportedFixtureOperation" "fixture-dispatch"))
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
