(defpackage #:lisp-plus-cd0-tests
  (:use #:cl #:lisp-plus-cd0)
  (:export #:run-tests))

(in-package #:lisp-plus-cd0-tests)

;;;; Dependency-free fixture and conformance harness.  The JSON parser below is
;;;; data-only: it has no reader, evaluator, package interning, or object hooks.

;;; ---------------------------------------------------------------------------
;;; Minimal safe JSON

(defstruct (%json-state (:constructor %make-json-state (text)))
  text
  (position 0 :type integer))

(defun %json-end-p (state)
  (>= (%json-state-position state) (length (%json-state-text state))))

(defun %json-peek (state)
  (and (not (%json-end-p state))
       (char (%json-state-text state) (%json-state-position state))))

(defun %json-read (state)
  (when (%json-end-p state) (error "truncated JSON"))
  (prog1 (%json-peek state) (incf (%json-state-position state))))

(defun %json-skip-space (state)
  (loop while (and (%json-peek state)
                   (member (%json-peek state)
                           '(#\Space #\Tab #\Return #\Newline)
                           :test #'char=))
        do (%json-read state)))

(defun %json-expect (state character)
  (unless (char= (%json-read state) character)
    (error "expected JSON character ~S" character)))

(defun %json-hex-digit (character)
  (cond ((char<= #\0 character #\9)
         (- (char-code character) (char-code #\0)))
        ((char<= #\a character #\f)
         (+ 10 (- (char-code character) (char-code #\a))))
        ((char<= #\A character #\F)
         (+ 10 (- (char-code character) (char-code #\A))))
        (t (error "invalid JSON hex digit"))))

(defun %json-u16 (state)
  (loop repeat 4
        for character = (%json-read state)
        for digit = (%json-hex-digit character)
        for value = digit then (+ (ash value 4) digit)
        finally (return value)))

(defun %json-push-code (code output)
  (let ((character (code-char code)))
    (unless character (error "JSON scalar unsupported by host"))
    (vector-push-extend character output)))

(defun %json-string (state)
  (%json-expect state #\")
  (let ((output (make-array 32 :element-type 'character
                            :adjustable t :fill-pointer 0)))
    (loop
      (let ((character (%json-read state)))
        (cond
          ((char= character #\") (return (coerce output 'string)))
          ((char= character #\\)
           (let ((escape (%json-read state)))
             (case escape
               (#\" (vector-push-extend #\" output))
               (#\\ (vector-push-extend #\\ output))
               (#\/ (vector-push-extend #\/ output))
               (#\b (vector-push-extend (code-char 8) output))
               (#\f (vector-push-extend (code-char 12) output))
               (#\n (vector-push-extend #\Newline output))
               (#\r (vector-push-extend #\Return output))
               (#\t (vector-push-extend #\Tab output))
               (#\u
                (let ((first (%json-u16 state)))
                  (cond
                    ((<= #xd800 first #xdbff)
                     (%json-expect state #\\)
                     (%json-expect state #\u)
                     (let ((second (%json-u16 state)))
                       (unless (<= #xdc00 second #xdfff)
                         (error "invalid JSON surrogate pair"))
                       (%json-push-code
                        (+ #x10000 (ash (- first #xd800) 10)
                           (- second #xdc00)) output)))
                    ((<= #xdc00 first #xdfff)
                     (error "isolated JSON low surrogate"))
                    (t (%json-push-code first output)))))
               (otherwise (error "invalid JSON escape")))))
          ((< (char-code character) #x20)
           (error "unescaped JSON control"))
          (t (vector-push-extend character output)))))))

(defun %json-literal (state spelling value)
  (loop for expected across spelling
        unless (char= (%json-read state) expected)
          do (error "invalid JSON literal"))
  value)

(defun %json-number (state)
  (let ((negative nil)
        (value 0)
        (digits 0))
    (when (char= (%json-peek state) #\-)
      (setf negative t)
      (%json-read state))
    (loop while (and (%json-peek state)
                     (char<= #\0 (%json-peek state) #\9))
          for character = (%json-read state)
          do (incf digits)
             (setf value (+ (* value 10)
                            (- (char-code character) (char-code #\0)))))
    (when (zerop digits) (error "invalid JSON number"))
    (when (and (%json-peek state)
               (find (%json-peek state) ".eE" :test #'char=))
      (error "fixture harness intentionally accepts integer JSON numbers only"))
    (if negative (- value) value)))

(declaim (ftype function %json-value))

(defun %json-array (state)
  (%json-expect state #\[)
  (%json-skip-space state)
  (when (and (%json-peek state) (char= (%json-peek state) #\]))
    (%json-read state)
    (return-from %json-array nil))
  (let ((items nil))
    (loop
      (push (%json-value state) items)
      (%json-skip-space state)
      (let ((separator (%json-read state)))
        (cond ((char= separator #\]) (return (nreverse items)))
              ((char= separator #\,) (%json-skip-space state))
              (t (error "invalid JSON array separator")))))))

(defun %json-object (state)
  (%json-expect state #\{)
  (%json-skip-space state)
  (when (and (%json-peek state) (char= (%json-peek state) #\}))
    (%json-read state)
    (return-from %json-object nil))
  (let ((pairs nil))
    (loop
      (unless (char= (%json-peek state) #\")
        (error "JSON object key is not a string"))
      (let ((key (%json-string state)))
        (%json-skip-space state)
        (%json-expect state #\:)
        (%json-skip-space state)
        (push (cons key (%json-value state)) pairs))
      (%json-skip-space state)
      (let ((separator (%json-read state)))
        (cond ((char= separator #\}) (return (nreverse pairs)))
              ((char= separator #\,) (%json-skip-space state))
              (t (error "invalid JSON object separator")))))))

(defun %json-value (state)
  (%json-skip-space state)
  (let ((character (%json-peek state)))
    (cond ((null character) (error "missing JSON value"))
          ((char= character #\") (%json-string state))
          ((char= character #\{) (%json-object state))
          ((char= character #\[) (%json-array state))
          ((char= character #\t) (%json-literal state "true" t))
          ((char= character #\f) (%json-literal state "false" nil))
          ((char= character #\n) (%json-literal state "null" :json-null))
          ((or (char= character #\-) (char<= #\0 character #\9))
           (%json-number state))
          (t (error "invalid JSON value")))))

(defun parse-json (text)
  (let* ((state (%make-json-state text))
         (value (%json-value state)))
    (%json-skip-space state)
    (unless (%json-end-p state) (error "trailing JSON text"))
    value))

(defun read-jsonl (path)
  (with-open-file (stream path :direction :input :external-format :utf-8)
    (loop for line = (read-line stream nil nil)
          while line
          collect (parse-json line))))

(defun read-json-document (path)
  (parse-json
   (with-open-file (stream path :direction :input :external-format :utf-8)
     (let ((text (make-string (file-length stream))))
       (read-sequence text stream)
       text))))

(defparameter +missing+ (list :missing))

(defun jget (object key &optional (default +missing+))
  (loop for pair in object
        when (string= (car pair) key) do (return (cdr pair))
        finally (if (eq default +missing+)
                    (error "missing JSON key ~A" key)
                    (return default))))

;;; ---------------------------------------------------------------------------
;;; Harness primitives and named budgets

(defvar *checks* 0)
(defvar *positive-count* 0)
(defvar *negative-count* 0)
(defvar *octet-negative-count* 0)
(defvar *host-negative-count* 0)
(defvar *host-not-applicable-count* 0)
(defvar *provisional-count* 0)
(defvar *retry-count* 0)
(defvar *distinct-pair-count* 0)
(defvar *mutation-count* 0)
(defvar *resource-count* 0)
(defvar *ambient-count* 0)
(defvar *property-count* 0)
(defvar *grammar-boundary-count* 0)

(defun check (condition control &rest arguments)
  (incf *checks*)
  (unless condition
    (error "CHECK FAILED: ~?" control arguments))
  t)

(defun check-string= (left right context)
  (check (and (stringp left) (stringp right) (string= left right))
         "~A: ~S differs from ~S" context left right))

(defun expect-failure (thunk category code stage &optional context)
  (handler-case
      (progn
        (funcall thunk)
        (error "expected CD/0 failure ~A/~A/~A~@[ in ~A~]"
               category code stage context))
    (cd0-failure (condition)
      (check-string= (failure-category condition) category
                     (or context "failure category"))
      (check-string= (failure-code condition) code
                     (or context "failure code"))
      (check-string= (failure-stage condition) stage
                     (or context "failure stage"))
      condition)))

(defun expect-vector-failure (thunk failure status context)
  (handler-case
      (progn
        (funcall thunk)
        (error "expected fixture failure in ~A" context))
    (cd0-failure (condition)
      (check-string= (failure-category condition) (jget failure "category")
                     context)
      (cond
        ((and status (string= status "provisional-blocked-stage"))
         ;; A1: only category and primary code are warranted.
         (incf *provisional-count*)
         (check-string= (failure-code condition) (jget failure "code") context))
        ((and status (string= status "provisional-blocked-code"))
         ;; A2: the fixture explicitly withholds the precise code.  The host
         ;; refusal category and importer stage remain observable here.
         (incf *provisional-count*)
         (check-string= (failure-stage condition) (jget failure "stage") context))
        (t
         (check-string= (failure-code condition) (jget failure "code") context)
         (check-string= (failure-stage condition) (jget failure "stage") context)))
      condition)))

(defun budget-keyword (name)
  (cdr
   (assoc name
          '(("max_input_octets" . :max-input-octets)
            ("max_output_octets" . :max-output-octets)
            ("max_varint_octets" . :max-varint-octets)
            ("max_integer_bits" . :max-integer-bits)
            ("max_depth" . :max-depth)
            ("max_nodes" . :max-nodes)
            ("max_sequence_items" . :max-sequence-items)
            ("max_record_fields" . :max-record-fields)
            ("max_identifier_segments" . :max-identifier-segments)
            ("max_segment_octets" . :max-segment-octets)
            ("max_single_string_octets" . :max-single-string-octets)
            ("max_single_bytes_octets" . :max-single-bytes-octets)
            ("max_aggregate_payload_octets" . :max-aggregate-payload-octets)
            ("max_total_record_key_octets" . :max-total-record-key-octets))
          :test #'string=)))

(defun budget-overrides (object)
  (loop for pair in object
        for keyword = (budget-keyword (car pair))
        when keyword append (list keyword (cdr pair))))

(defun row-budget (descriptor budgets identifier)
  (cond
    ((stringp descriptor)
     (or (gethash descriptor budgets)
         (error "~A refers to unknown budget ~A" identifier descriptor)))
    ((listp descriptor)
     (apply #'make-resource-budget
            :id (concatenate 'string "inline:" identifier)
            (budget-overrides descriptor)))
    (t (error "~A has invalid budget descriptor" identifier))))

(defun load-budgets (path)
  (let* ((document (read-json-document path))
         (objects (jget document "budgets"))
         (result (make-hash-table :test #'equal)))
    (labels ((resolve (name)
               (or (gethash name result)
                   (let* ((object (jget objects name))
                          (base-name (jget object "base" nil))
                          (budget
                            (if base-name
                                (apply #'copy-resource-budget (resolve base-name)
                                       :id name (budget-overrides object))
                                (apply #'make-resource-budget :id name
                                       (budget-overrides object)))))
                     (setf (gethash name result) budget)))))
      (loop for pair in objects do (resolve (car pair))))
    result))

;;; ---------------------------------------------------------------------------
;;; Shared vectors

(defun test-positive-vectors (rows budgets)
  (let ((classes (make-hash-table :test #'equal))
        (by-id (make-hash-table :test #'equal)))
    (loop for row in rows
          for identifier = (jget row "id")
          for budget = (row-budget (jget row "budget") budgets identifier)
          for datum = (datum-from-fixture-ast (jget row "abstract")
                                              :budget budget)
          for expected-hex = (jget row "canonical_hex")
          for encoded = (encode-exact datum :budget budget)
          for decoded = (decode-exact (octets-copy encoded) :budget budget)
          do
             (incf *positive-count*)
             (check-string= (octets-to-hex encoded) expected-hex identifier)
             (check (equal (datum-to-fixture-ast decoded)
                           (jget row "expected_decoded"))
                    "~A: decoded fixture AST differs" identifier)
             (check-string= (octets-to-hex (encode-exact decoded :budget budget))
                            expected-hex identifier)
             (let ((diagnostic (jget row "diagnostic" nil)))
               (when diagnostic
                 (check-string= (render-diagnostic datum) diagnostic identifier)))
             (let* ((class-name (jget row "equality_class"))
                    (prior (gethash class-name classes)))
               (if prior
                   (progn
                     (check (equal-datum prior datum)
                            "~A equality class mismatch" identifier)
                     (check-string=
                      (octets-to-hex (encode-exact prior :budget budget))
                      expected-hex identifier))
                   (setf (gethash class-name classes) datum)))
             (setf (gethash identifier by-id) datum))
    by-id))

(defun test-distinct-pairs (manifest by-id)
  (check-string= (jget manifest "schema") "cd0-distinct-pairs/v1"
                 "distinct-pair manifest schema")
  (loop for pair in (jget manifest "pairs")
        for left-id = (jget pair "left")
        for right-id = (jget pair "right")
        for left = (gethash left-id by-id)
        for right = (gethash right-id by-id)
        do (incf *distinct-pair-count*)
           (check (and left right) "distinct-pair vector ID is missing")
           (check (not (equal-datum left right))
                  "distinct pair ~A/~A compared equal" left-id right-id)
           (check (not (string= (octets-to-hex (encode-exact left))
                                (octets-to-hex (encode-exact right))))
                  "distinct pair ~A/~A encoded equally" left-id right-id)))

(defun test-host-negative-vector (row budget)
  (let* ((identifier (jget row "id"))
         (failure (jget row "expected_failure"))
         (status (jget row "status" nil)))
    ;; The descriptor and importer label are consumed as fixture metadata even
    ;; where this clean-room codec deliberately exposes no such optional host
    ;; adapter.
    (jget row "host_input")
    (jget row "importer")
    (cond
      ((string= identifier "cd0-neg-host-cycle")
       (incf *host-negative-count*)
       (let* ((ast (list (cons "t" "seq") (cons "items" nil)))
              (items (list ast)))
         (setf (cdr (assoc "items" ast :test #'string=)) items)
         (expect-vector-failure
          (lambda () (datum-from-fixture-ast ast :budget budget))
          failure status identifier)))
      ((string= identifier "cd0-neg-host-improper-list")
       (incf *host-negative-count*)
       (let ((improper (cons (make-integer-datum 1)
                             (make-integer-datum 2))))
         (expect-vector-failure
          (lambda () (make-sequence-datum improper :budget budget))
          failure status identifier)))
      (t
       ;; No symbol-mapping, Python-host, or evaluator-owned privileged-value
       ;; importer is exposed by this isolated Common Lisp seed.
       (incf *host-not-applicable-count*)))))

(defun test-negative-vectors (rows budgets)
  (loop for row in rows
        for identifier = (jget row "id")
        for budget = (row-budget (jget row "budget") budgets identifier)
        for failure = (jget row "expected_failure")
        for status = (jget row "status" nil)
        do
           (incf *negative-count*)
           (if (string= (jget row "input_kind") "octets")
               (let ((input (octets-copy
                             (hex-to-octets (jget row "input_hex")))))
                 (incf *octet-negative-count*)
                 (expect-vector-failure
                  (lambda () (decode-exact input :budget budget))
                  failure status identifier)
                 (let ((retry (jget row "retry_budget" nil)))
                   (when retry
                     (incf *retry-count*)
                     (let* ((retry-budget (row-budget retry budgets identifier))
                            (datum (decode-exact input :budget retry-budget)))
                       (check-string=
                        (octets-to-hex (encode-exact datum :budget retry-budget))
                        (jget row "input_hex")
                        (concatenate 'string identifier " retry"))))))
               (test-host-negative-vector row budget))))

;;; ---------------------------------------------------------------------------
;;; Focused algebra, mutation, resource, inertness, and ambient-state tests

(defun id (name)
  (make-identifier-datum nil (list name)))

(defun test-constructors-and-equality ()
  (let* ((unit (make-unit-datum))
         (false (make-boolean-datum nil))
         (integer (make-integer-datum 7))
         (rational (make-rational-datum 2 4))
         (string (make-string-datum "s"))
         (bytes (make-bytes-datum #(1 2)))
         (identifier (id "x"))
         (sequence (make-sequence-datum
                    (vector unit (make-boolean-datum t) integer)))
         (record (make-record-datum
                  (list (make-record-entry identifier sequence))))
         (families (mapcar #'datum-family
                           (list unit false integer rational string bytes
                                 identifier sequence record))))
    (check (= 9 (length (remove-duplicates families)))
           "nine datum families are not disjoint")
    (check (rational-datum-p rational) "2/4 did not normalize to rational")
    (check (= 1 (rational-datum-numerator rational)) "2/4 numerator")
    (check (= 2 (rational-datum-denominator rational)) "2/4 denominator")
    (check (equal-datum (make-rational-datum 2 2) (make-integer-datum 1))
           "integral rational constructor did not normalize")
    (check (integer-datum-p (make-rational-datum 0 -7))
           "zero rational constructor did not normalize")
    (check (not (equal-datum false (make-integer-datum 0)))
           "boolean collapsed into integer")
    (check (not (equal-datum unit (make-sequence-datum nil)))
           "unit collapsed into empty sequence")
    (check (not (equal-datum string identifier))
           "string collapsed into identifier")
    (let* ((a (id "a")) (b (id "b"))
           (one (make-integer-datum 1)) (truth (make-boolean-datum t))
           (forward (make-record-datum
                     (list (make-record-entry a one)
                           (make-record-entry b truth))))
           (reverse (make-record-datum
                     (list (make-record-entry b truth)
                           (make-record-entry a one)))))
      (check (equal-datum forward reverse) "record source order changed equality")
      (check-string= (octets-to-hex (encode-exact reverse))
                     "4c50434400310222000101611002220001016202"
                     "record canonical sort")
      (expect-failure
       (lambda ()
         (make-record-datum
          (list (make-record-entry a one) (make-record-entry a truth))))
       "InvalidCanonicalGrammar" "DuplicateRecordField" "host-import"
       "duplicate constructor key"))
    (check (not (equal-datum (make-string-datum (string (code-char #xe9)))
                             (make-string-datum
                              (coerce (list #\e (code-char #x301)) 'string))))
           "Unicode normalization leaked into equality")))

(defun true-datum () (make-boolean-datum t))

(defun unchanged-after (datum baseline mutator label)
  (funcall mutator)
  (incf *mutation-count*)
  (check-string= (octets-to-hex (encode-exact datum)) baseline label))

(defun test-mutation-resistance ()
  (let* ((source (copy-seq "abc"))
         (datum (make-string-datum source))
         (baseline (octets-to-hex (encode-exact datum))))
    (unchanged-after datum baseline (lambda () (setf (char source 0) #\z))
                     "mutated source string")
    (let ((view (string-datum-value datum)))
      (unchanged-after datum baseline (lambda () (setf (char view 1) #\z))
                       "mutated string accessor copy")))
  (let* ((source (make-array 3 :element-type '(unsigned-byte 8)
                             :initial-contents '(1 2 3)))
         (datum (make-bytes-datum source))
         (baseline (octets-to-hex (encode-exact datum))))
    (unchanged-after datum baseline (lambda () (setf (aref source 0) 9))
                     "mutated source bytes")
    (let ((view (bytes-datum-value datum)))
      (unchanged-after datum baseline (lambda () (setf (aref view 1) 9))
                       "mutated bytes accessor copy")))
  (let* ((segment (copy-seq "name"))
         (datum (make-identifier-datum nil (list segment)))
         (baseline (octets-to-hex (encode-exact datum))))
    (unchanged-after datum baseline (lambda () (setf (char segment 0) #\x))
                     "mutated identifier source")
    (let* ((segments (identifier-datum-path datum))
           (view (aref segments 0)))
      (unchanged-after datum baseline (lambda () (setf (char view 0) #\q))
                       "mutated identifier accessor copy")))
  (let* ((source (vector (make-unit-datum) (make-boolean-datum t)))
         (datum (make-sequence-datum source))
         (baseline (octets-to-hex (encode-exact datum))))
    (unchanged-after datum baseline
                     (lambda () (setf (aref source 0) (make-integer-datum 99)))
                     "mutated sequence source")
    (let ((view (sequence-datum-elements datum)))
      (unchanged-after datum baseline
                       (lambda () (setf (aref view 0) (make-integer-datum 42)))
                       "mutated sequence accessor copy")))
  (let* ((source (list (make-unit-datum) (make-boolean-datum t)))
         (datum (make-sequence-datum source))
         (baseline (octets-to-hex (encode-exact datum))))
    (unchanged-after datum baseline
                     (lambda ()
                       (setf (car source) (make-integer-datum 7)
                             (cdr source) nil))
                     "mutated source list spine"))
  (let* ((backing (make-array 5 :element-type '(unsigned-byte 8)
                              :initial-contents '(9 1 2 3 9)))
         (displaced (make-array 3 :element-type '(unsigned-byte 8)
                                :displaced-to backing :displaced-index-offset 1))
         (datum (make-bytes-datum displaced))
         (baseline (octets-to-hex (encode-exact datum))))
    (unchanged-after datum baseline (lambda () (setf (aref backing 2) 99))
                     "mutated displaced byte backing"))
  (let* ((source (make-array 8 :element-type '(unsigned-byte 8)
                             :adjustable t :fill-pointer 3
                             :initial-contents '(4 5 6 0 0 0 0 0)))
         (datum (make-bytes-datum source))
         (baseline (octets-to-hex (encode-exact datum))))
    (unchanged-after datum baseline
                     (lambda ()
                       (setf (aref source 0) 88)
                       (vector-push-extend 7 source))
                     "mutated adjustable fill-pointer bytes"))
  (let* ((entries (vector (make-record-entry (id "a") (make-unit-datum))))
         (datum (make-record-datum entries))
         (baseline (octets-to-hex (encode-exact datum))))
    (unchanged-after datum baseline
                     (lambda ()
                       (setf (aref entries 0)
                             (make-record-entry (id "b") (make-unit-datum))))
                     "mutated record source")
    (let ((view (record-datum-fields datum)))
      (unchanged-after datum baseline
                       (lambda () (setf (aref view 0)
                                        (make-record-entry (id "z")
                                                           (make-unit-datum))))
                       "mutated record accessor copy")))
  (let* ((source (octets-copy (hex-to-octets "4c50434400300300021002")))
         (datum (decode-exact source))
         (baseline (octets-to-hex (encode-exact datum))))
    (unchanged-after datum baseline (lambda () (setf (aref source 0) 0))
                     "mutated decode source buffer")
    (let* ((encoded (encode-exact datum))
           (copy (octets-copy encoded)))
      (unchanged-after datum baseline (lambda () (setf (aref copy 0) 0))
                       "mutated canonical-octet copy"))))

(defun test-resource-boundaries ()
  (labels ((resource (thunk code stage label)
             (incf *resource-count*)
             (expect-failure thunk "ResourceRefusal" code stage label)))
    (let* ((unit-hex "4c5043440000")
           (small (copy-resource-budget (default-resource-budget)
                                        :id "small-input"
                                        :max-input-octets 5)))
      (resource (lambda () (decode-exact (hex-to-octets unit-hex) :budget small))
                "ExcessiveInputLength" "input-budget" "input boundary")
      (check (unit-datum-p (decode-exact (hex-to-octets unit-hex)))
             "resource retry with sufficient input budget failed"))
    (let* ((datum (make-string-datum "ab"))
           (encoded (encode-exact datum))
           (small (copy-resource-budget (default-resource-budget)
                                        :id "small-string"
                                        :max-single-string-octets 1)))
      (resource (lambda () (decode-exact encoded :budget small))
                "ExcessiveDeclaredLength" "length" "string decode boundary")
      (check (equal-datum datum (decode-exact encoded))
             "string resource retry failed"))
    (let* ((nested (make-sequence-datum (list (make-sequence-datum
                                                (list (make-unit-datum))))))
           (encoded (encode-exact nested))
           (shallow (copy-resource-budget (default-resource-budget)
                                          :id "depth-2" :max-depth 2)))
      (resource (lambda () (decode-exact encoded :budget shallow))
                "ExcessiveNesting" "type-tag" "depth boundary")
      (check (equal-datum nested (decode-exact encoded)) "depth retry failed"))
    (let* ((sequence (make-sequence-datum (list (make-unit-datum))))
           (encoded (encode-exact sequence))
           (one-node (copy-resource-budget (default-resource-budget)
                                           :id "one-node" :max-nodes 1)))
      (resource (lambda () (decode-exact encoded :budget one-node))
                "NodeBudgetExceeded" "type-tag" "node boundary")
      (check (equal-datum sequence (decode-exact encoded)) "node retry failed"))
    (let* ((datum (make-sequence-datum
                   (list (make-string-datum "ab") (make-bytes-datum #(1 2)))))
           (encoded (encode-exact datum))
           (aggregate (copy-resource-budget
                       (default-resource-budget) :id "aggregate-3"
                       :max-aggregate-payload-octets 3)))
      (resource (lambda () (decode-exact encoded :budget aggregate))
                "AggregatePayloadBudgetExceeded" "length"
                "aggregate payload boundary")
      (check (equal-datum datum (decode-exact encoded)) "aggregate retry failed"))
    (let* ((one (make-integer-datum -65))
           (encoded (encode-exact one))
           (seven (copy-resource-budget (default-resource-budget)
                                        :id "integer-bits-7"
                                        :max-integer-bits 7))
           (six (copy-resource-budget seven :id "integer-bits-6"
                                      :max-integer-bits 6)))
      (check (equal-datum one (decode-exact encoded :budget seven))
             "A3 mathematical bit-length choice not applied")
      (resource (lambda () (decode-exact encoded :budget six))
                "IntegerBudgetExceeded" "integer-payload" "integer boundary"))
    (let ((small (copy-resource-budget (default-resource-budget)
                                       :id "output-5" :max-output-octets 5)))
      (resource (lambda () (encode-exact (make-unit-datum) :budget small))
                "ExcessiveOutputLength" "allocation" "output boundary")
      (check-string= (octets-to-hex (encode-exact (make-unit-datum)))
                     "4c5043440000" "output retry"))
    (let* ((integer (make-integer-datum 64))
           (encoded (encode-exact integer))
           (small (copy-resource-budget (default-resource-budget)
                                        :id "varint-1" :max-varint-octets 1)))
      (resource (lambda () (decode-exact encoded :budget small))
                "VarintBudgetExceeded" "integer-payload" "varint decode")
      (resource (lambda () (encode-exact integer :budget small))
                "VarintBudgetExceeded" "integer-payload" "varint encode"))
    (let* ((identifier (make-identifier-datum '("n") '("p")))
           (encoded (encode-exact identifier))
           (small (copy-resource-budget (default-resource-budget)
                                        :id "id-segments-1"
                                        :max-identifier-segments 1)))
      (resource (lambda () (decode-exact encoded :budget small))
                "ExcessiveIdentifierSegments" "count" "identifier aggregate")
      (check (identifier-datum-p (decode-exact encoded)) "identifier retry"))
    (let* ((datum (make-record-datum
                   (list (make-record-entry (id "a") (make-unit-datum)))))
           (small (copy-resource-budget (default-resource-budget)
                                        :id "key-work-1"
                                        :max-total-record-key-octets 1)))
      (resource (lambda () (encode-exact datum :budget small))
                "RecordKeyWorkBudgetExceeded" "encode-ordering"
                "record key work"))
    (let* ((value (ash 1 500))
           (datum (make-integer-datum value))
           (large (copy-resource-budget (default-resource-budget)
                                        :id "large-integer"
                                        :max-varint-octets 100
                                        :max-integer-bits 501))
           (encoded (encode-exact datum :budget large)))
      (check (equal-datum datum (decode-exact encoded :budget large))
             "arbitrary-precision integer round trip"))))

(defvar *activation-count* 0)

(defun test-inert-and-host-import ()
  (let* ((labels '("capability" "warrant" "claim" "certificate" "receipt"
                   "authority"))
         (record (make-record-datum
                  (loop for label in labels
                        collect (make-record-entry (id label)
                                                   (make-string-datum label)))))
         (decoded (decode-exact (encode-exact record))))
    (check (record-datum-p decoded) "privileged-looking record was not inert")
    (check (= *activation-count* 0) "privileged-looking record activated a hook")
    (check (search "record{" (render-diagnostic decoded) :test #'char=)
           "privileged-looking record got non-record diagnostic"))
  (let* ((child (list (cons "t" "unit")))
         (ast (list (cons "t" "seq")
                    (cons "items" (list child child))))
         (datum (datum-from-fixture-ast ast)))
    (check (= 2 (sequence-datum-length datum))
           "shared acyclic fixture structure was rejected")
    (check (equal-datum (sequence-datum-ref datum 0)
                        (sequence-datum-ref datum 1))
           "shared acyclic fixture structure changed value"))
  (let* ((ast (list (cons "t" "seq") (cons "items" nil)))
         (items (list ast)))
    (setf (cdr (assoc "items" ast :test #'string=)) items)
    (expect-failure (lambda () (datum-from-fixture-ast ast))
                    "UnsupportedHostInput" "CyclicHostInput" "host-import"
                    "fixture host cycle"))
  (let ((ast (list (cons "t" "seq")
                   (cons "items" (cons (list (cons "t" "unit")) :tail)))))
    (expect-failure (lambda () (datum-from-fixture-ast ast))
                    "UnsupportedHostInput" "ImproperHostList" "host-import"
                    "improper fixture list"))
  (expect-failure (lambda () (make-identifier-datum nil '(host-symbol)))
                  "UnsupportedHostInput" "UnsupportedHostType" "host-import"
                  "implicit host symbol identifier"))

(defun test-ambient-host-state ()
  (let* ((datum
           (make-record-datum
            (list
             (make-record-entry
              (make-identifier-datum '("ns") '("B"))
              (make-rational-datum -10 14))
             (make-record-entry
              (make-identifier-datum nil '("a"))
              (make-sequence-datum
               (list (make-string-datum (string (code-char #xe9)))
                     (make-bytes-datum #(0 255))))))))
         (baseline (octets-to-hex (encode-exact datum)))
         (readtable (copy-readtable nil)))
    (set-macro-character #\!
                         (lambda (stream character)
                           (declare (ignore stream character))
                           (incf *activation-count*)
                           (error "ambient readtable macro must not run"))
                         nil readtable)
    (let ((*package* (find-package :keyword))
          (*print-base* 2)
          (*print-radix* t)
          (*print-case* :downcase)
          (*print-circle* t)
          (*print-level* 0)
          (*print-length* 0)
          (*readtable* readtable))
      (incf *ambient-count*)
      (check-string= (octets-to-hex (encode-exact datum)) baseline
                     "ambient Common Lisp state")
      (incf *ambient-count*)
      (check-string= (render-diagnostic (make-integer-datum 123456789))
                     "123456789" "diagnostic printer independence"))
    (check (= *activation-count* 0) "ambient readtable macro ran")))

;;; A deterministic local property smoke test.  This is intentionally not the
;;; Phase-3 release-corpus generator; it writes no vectors and has a fixed small
;;; scope suitable for every seed run.

(defstruct (%lcg (:constructor %make-lcg (state))) state)

(defun lcg-next (generator modulus)
  (setf (%lcg-state generator)
        (mod (+ (* 1103515245 (%lcg-state generator)) 12345) #x80000000))
  (mod (%lcg-state generator) modulus))

(defun generated-string (generator)
  (let* ((choices #(0 9 10 65 90 97 122 233 769 65534 1114111))
         (length (lcg-next generator 6))
         (result (make-string length)))
    (loop for index below length
          for code = (aref choices (lcg-next generator (length choices)))
          do (setf (char result index) (code-char code)))
    result))

(defun generated-datum (generator depth)
  (let ((choice (lcg-next generator (if (< depth 3) 9 7))))
    (case choice
      (0 (make-unit-datum))
      (1 (make-boolean-datum (zerop (lcg-next generator 2))))
      (2 (make-integer-datum (- (lcg-next generator 20001) 10000)))
      (3 (let ((numerator (- (lcg-next generator 199) 99))
               (denominator (+ 2 (lcg-next generator 49))))
           (make-rational-datum (if (zerop numerator) 1 numerator) denominator)))
      (4 (make-string-datum (generated-string generator)))
      (5 (let* ((length (lcg-next generator 8))
                (bytes (make-array length :element-type '(unsigned-byte 8))))
           (loop for index below length
                 do (setf (aref bytes index) (lcg-next generator 256)))
           (make-bytes-datum bytes)))
      (6 (make-identifier-datum
          (if (zerop (lcg-next generator 3))
              nil
              (list (concatenate 'string "n"
                                 (write-to-string (lcg-next generator 10)
                                                  :base 10 :radix nil))))
          (list (concatenate 'string "p"
                             (write-to-string (lcg-next generator 100)
                                              :base 10 :radix nil)))))
      (7 (let ((length (lcg-next generator 4)))
           (make-sequence-datum
            (loop repeat length collect (generated-datum generator (1+ depth))))))
      (8 (let ((length (lcg-next generator 4)))
           (make-record-datum
            (loop for index below length
                  collect
                  (make-record-entry
                   (id (concatenate 'string
                                    "k" (write-to-string index :base 10 :radix nil)))
                   (generated-datum generator (1+ depth))))))))))

(defun test-deterministic-properties ()
  (let ((generator (%make-lcg 20260713)))
    (loop repeat 500
          for datum = (generated-datum generator 1)
          for encoded = (encode-exact datum)
          for decoded = (decode-exact encoded)
          for clone = (datum-from-fixture-ast (datum-to-fixture-ast datum))
          do (incf *property-count*)
             (check (equal-datum datum decoded) "generated decode round trip")
             (check (equal-datum datum clone) "generated fixture round trip")
             (check-string= (octets-to-hex (encode-exact decoded))
                            (octets-to-hex encoded)
                            "generated canonical-byte round trip")
             (check-string= (octets-to-hex (encode-exact clone))
                            (octets-to-hex encoded)
                            "generated equality/encoding correspondence"))))

(defun test-grammar-boundaries ()
  (let ((valid-strings
          '(;; Empty and one-byte boundaries.
            ("4c504344002000" . 0)
            ("4c50434400200100" . 1)
            ("4c5043440020017f" . 1)
            ;; Lowest and highest two-byte scalars.
            ("4c504344002002c280" . 1)
            ("4c504344002002dfbf" . 1)
            ;; Three-byte boundary shapes, including permitted noncharacters.
            ("4c504344002003e0a080" . 1)
            ("4c504344002003ed9fbf" . 1)
            ("4c504344002003ee8080" . 1)
            ("4c504344002003efbfbf" . 1)
            ;; Four-byte minimum and maximum Unicode scalar.
            ("4c504344002004f0908080" . 1)
            ("4c504344002004f48fbfbf" . 1))))
    (loop for (hex . scalars) in valid-strings
          for datum = (decode-exact (hex-to-octets hex))
          do (incf *grammar-boundary-count*)
             (check (string-datum-p datum) "UTF-8 boundary did not decode string")
             (check (= scalars (string-datum-scalar-length datum))
                    "UTF-8 scalar count boundary")
             (check-string= (octets-to-hex (encode-exact datum)) hex
                            "UTF-8 canonical boundary")))
  (dolist (case '((-64 . "4c50434400107f")
                  (64 . "4c50434400108001")
                  (-8192 . "4c5043440010ff7f")
                  (8192 . "4c5043440010808001")))
    (incf *grammar-boundary-count*)
    (let ((datum (make-integer-datum (car case))))
      (check-string= (octets-to-hex (encode-exact datum)) (cdr case)
                     "zigzag/UVAR boundary")
      (check (equal-datum datum (decode-exact (hex-to-octets (cdr case))))
             "zigzag/UVAR boundary round trip")))
  (expect-failure
   (lambda () (decode-exact (hex-to-octets "4c504344002001c2")))
   "InvalidCanonicalGrammar" "InvalidUTF8" "utf8"
   "complete declared payload with incomplete scalar")
  (expect-failure
   (lambda () (decode-exact (hex-to-octets "4c504344003101f0")))
   "PrivilegedRestorationAttempt" "ForbiddenPrivilegedTag" "type-tag"
   "A6 forbidden record key")
  (expect-failure
   (lambda () (decode-exact (hex-to-octets "4c50434400310103")))
   "InvalidCanonicalGrammar" "RecordKeyNotIdentifier" "record-key"
   "A6 reserved record key"))

;;; ---------------------------------------------------------------------------
;;; Entry point

(defun run-tests (&key
                    (positive-path "canonical-datum/vectors/cd0-positive.jsonl")
                    (negative-path "canonical-datum/vectors/cd0-negative.jsonl")
                    (budget-path "canonical-datum/vectors/cd0-budgets.json")
                    (distinct-path
                      "canonical-datum/vectors/cd0-distinct-pairs.json"))
  (setf *checks* 0 *positive-count* 0 *negative-count* 0
        *octet-negative-count* 0 *host-negative-count* 0
        *host-not-applicable-count* 0 *provisional-count* 0
        *retry-count* 0 *distinct-pair-count* 0
        *mutation-count* 0 *resource-count* 0 *ambient-count* 0
        *property-count* 0 *grammar-boundary-count* 0
        *activation-count* 0)
  (let* ((budgets (load-budgets budget-path))
         (positives (read-jsonl positive-path))
         (negatives (read-jsonl negative-path)))
    (check (= (length positives) 22) "shared positive row count changed")
    (check (= (length negatives) 71) "shared negative row count changed")
    (let ((by-id (test-positive-vectors positives budgets)))
      (test-distinct-pairs (read-json-document distinct-path) by-id))
    (test-negative-vectors negatives budgets))
  (test-constructors-and-equality)
  (test-mutation-resistance)
  (test-resource-boundaries)
  (test-inert-and-host-import)
  (test-ambient-host-state)
  (test-deterministic-properties)
  (test-grammar-boundaries)
  (format t "CD/0 Common Lisp seed conformance: PASS~%")
  (format t "shared positives: ~D/22~%" *positive-count*)
  (format t "shared negative manifest rows dispositioned: ~D/71~%"
          *negative-count*)
  (format t "  octet rows executed: ~D/66~%" *octet-negative-count*)
  (format t "  applicable host rows executed: ~D/2~%" *host-negative-count*)
  (format t "  optional host importers not exposed: ~D/3~%"
          *host-not-applicable-count*)
  (format t "  provisional rows compared only on warranted components: ~D~%"
          *provisional-count*)
  (format t "resource-vector successful retries: ~D~%" *retry-count*)
  (format t "declared distinct pairs: ~D~%" *distinct-pair-count*)
  (format t "mutation probes: ~D~%" *mutation-count*)
  (format t "resource refusal/retry probes: ~D~%" *resource-count*)
  (format t "ambient-state variants: ~D~%" *ambient-count*)
  (format t "deterministic generated round trips: ~D~%" *property-count*)
  (format t "grammar/Unicode boundary cases: ~D~%" *grammar-boundary-count*)
  (format t "total assertions: ~D~%" *checks*)
  t)
