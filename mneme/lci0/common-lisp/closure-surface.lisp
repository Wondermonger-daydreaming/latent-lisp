(in-package #:lisp-plus-lci0)

;;;; LCI/0 authorial-closure acceptance surface (LCI0-AC-001 .. LCI0-AC-010).
;;;;
;;;; The fifty successor vectors in the verified closure packet are the
;;;; acceptance surface for the ten closures.  This file gives them an
;;;; executable Common Lisp form:
;;;;
;;;;   - EXECUTE-OVERLAY-SUPERSEDED-VECTOR runs one of the four superseded
;;;;     0.1 vectors against its overlay-0.2 expectation
;;;;     (LCI0-ACV-ORIG-001..004; canonical octets where the vector carries
;;;;     hex, semantic document equality where it carries JSON).
;;;;   - EVALUATE-RELATION-TABLE-COMPANION executes one sealed relation-table
;;;;     row and reports the ruled companion failure coordinates
;;;;     (LCI0-ACV-REL-001..038, LCI0-AC-002).
;;;;   - EXECUTE-HOSTILE-CASE executes one retained hostile request and
;;;;     reports its exact structural result (LCI0-ACV-HOSTILE-001..008,
;;;;     LCI0-AC-005/LCI0-AC-007).
;;;;   - RUN-CLOSURE-VECTORS drives all fifty and reports PASS/FAIL.
;;;;
;;;; Diagnostic documents on this surface never expose host argument indexes,
;;;; stack positions, or host exception prose (LCI0-AC-002 adapter rule,
;;;; LCI0-AC-007 payload rule).

;;; ---------------------------------------------------------------------------
;;; Semantic JSON projection (the adapter between CD/0 data and the closure
;;; vectors' semantic result documents).

(defun semantic-json-of-datum (datum)
  "Project a CD/0 datum into the closure vectors' semantic JSON value space.
Record field names travel verbatim: the closure vectors' semantic documents
spell their own keys (underscored or dashed), and the producing operations
name their output fields to match exactly."
  (cond
    ((unit-datum-p datum) :json-null)
    ((boolean-datum-p datum)
     (if (boolean-datum-value datum) :json-true :json-false))
    ((integer-datum-p datum) (integer-datum-value datum))
    ((string-datum-p datum) (string-datum-value datum))
    ((identifier-datum-p datum) (identifier-last datum))
    ((sequence-datum-p datum)
     (loop for index below (sequence-datum-length datum)
           collect (semantic-json-of-datum (sequence-datum-ref datum index))))
    ((record-datum-p datum)
     (loop for index below (record-datum-size datum)
           collect (cons (identifier-last (record-datum-key-at datum index))
                         (semantic-json-of-datum
                          (record-datum-value-at datum index)))))
    (t (error "no semantic JSON projection for datum ~S" datum))))

(defun %semantic-path-part (part)
  ;; Path parts on condition objects may carry the implementation-local
  ;; "fixture-field:" spelling; the semantic path never exposes it (the same
  ;; normalization FAILURE-DATUM applies when minting failure documents).
  (if (and (>= (length part) 14)
           (string= part "fixture-field:" :end1 14 :end2 14))
      (subseq part 14)
      part))

(defun %semantic-path-string (path-strings)
  (format nil "~{/~A~}" (mapcar #'%semantic-path-part path-strings)))

(defun %failure-datum-path-strings (path-datum)
  (loop for index below (sequence-datum-length path-datum)
        collect (identifier-last (sequence-datum-ref path-datum index))))

(defun semantic-json-of-lci-failure (condition &key path-prefix)
  "The exact four-coordinate structural failure document of the closure
vectors: category, code, stage, and a semantic path."
  (list
   (cons "status" "failure")
   (cons "failure"
         (list (cons "category" (lci-failure-category condition))
               (cons "code" (lci-failure-code condition))
               (cons "stage" (lci-failure-stage condition))
               (cons "semantic_path"
                     (%semantic-path-string
                      (append path-prefix
                              (lci-failure-path condition))))))))

(defun semantic-json-of-operation-result (actual)
  "Project an executed fixture-operation result (or failure document) into
the closure vectors' semantic result form."
  (cond
    ((and (record-datum-p actual) (exact-kind-p actual "failure"))
     (list
      (cons "status" "failure")
      (cons "failure"
            (list (cons "category"
                        (identifier-last (record-field-named actual "category")))
                  (cons "code"
                        (identifier-last (record-field-named actual "code")))
                  (cons "stage"
                        (identifier-last (record-field-named actual "stage")))
                  (cons "semantic_path"
                        (%semantic-path-string
                         (%failure-datum-path-strings
                          (record-field-named actual "path"))))))))
    ((and (record-datum-p actual)
          (exact-kind-p actual "fixture-operation-result"))
     (let ((outputs (record-field-named actual "outputs")))
       (append
        (list (cons "status"
                    (identifier-last (record-field-named actual "status"))))
        (when (record-datum-p outputs)
          (loop for index below (record-datum-size outputs)
                collect (cons (identifier-last
                               (record-datum-key-at outputs index))
                              (semantic-json-of-datum
                               (record-datum-value-at outputs index))))))))
    (t (error "no semantic projection for operation result ~S" actual))))

;;; ---------------------------------------------------------------------------
;;; Structural JSON equality (objects key-set equal, arrays order-exact).

(defun %json-object-p (value)
  (and (listp value)
       (every (lambda (pair) (and (consp pair) (stringp (car pair)))) value)))

(defun json-equal (left right)
  (cond
    ((and (null left) (null right)) t)
    ((and (%json-object-p left) (%json-object-p right)
          (or left right))
     (and (= (length left) (length right))
          (every (lambda (pair)
                   (and (jhas-p right (car pair))
                        (json-equal (cdr pair) (jget right (car pair)))))
                 left)))
    ((and (listp left) (listp right))
     (and (= (length left) (length right))
          (every #'json-equal left right)))
    ((and (stringp left) (stringp right)) (string= left right))
    ((and (integerp left) (integerp right)) (= left right))
    (t (eq left right))))

;;; ---------------------------------------------------------------------------
;;; Superseded 0.1 vectors (LCI0-ACV-ORIG-001..004).

(defun execute-overlay-superseded-vector (row entry &key (verify-documents t))
  "Execute the 0.1 vector ROW against its overlay-0.2 supersession ENTRY.
The 0.1 input document remains authoritative and is verified; the 0.1
expected document is superseded and is not consulted (Errata F0.2-1)."
  (let* ((input-document (jget row "inputs"))
         (input (fixture-json-to-datum (jget input-document "abstract_cd0"))))
    (when verify-documents
      (verify-fixture-document input-document))
    (multiple-value-bind (id operation payload) (%vector-input-components input)
      (let ((actual
              (handler-case
                  (execute-fixture-operation operation payload :vector-id id)
                (lci-failure (condition) (failure-datum condition id))))
            (encoding (jget entry "expected_result_encoding")))
        (cond
          ((string= encoding "canonical_cd0_hex")
           (let* ((expected-hex (jget entry "expected_canonical_cd0_hex"))
                  (actual-hex (octets-to-hex (canonical-octets actual)))
                  (passed (string= actual-hex expected-hex)))
             (make-vector-result
              :id id :operation (operation-name operation)
              :passed passed :actual actual
              :expected (decode-exact (hex-to-octets expected-hex))
              :detail (unless passed
                        (format nil "overlay-superseded actual ~A expected ~A"
                                actual-hex expected-hex)))))
          ((string= encoding "semantic_json_document")
           (let* ((expected (jget entry "expected_result"))
                  (actual-json (semantic-json-of-operation-result actual))
                  (passed (json-equal actual-json expected)))
             (make-vector-result
              :id id :operation (operation-name operation)
              :passed passed :actual actual :expected expected
              :detail (unless passed
                        (with-output-to-string (stream)
                          (write-string "overlay-superseded semantic actual "
                                        stream)
                          (write-json-value actual-json stream)
                          (write-string " expected " stream)
                          (write-json-value expected stream))))))
          (t (error "unknown overlay expected_result_encoding ~A" encoding)))))))

;;; ---------------------------------------------------------------------------
;;; Relation-table companion surface (LCI0-AC-002).

(defparameter +relation-table-operands+
  '(("scope_relation_table_0" "left-scope" "right-scope")
    ("temporal_relation_table_0" "left-subject-time" "right-subject-time")))

(defun %companion-relation-of-code (table code)
  (cond
    ((and (string= table "scope_relation_table_0")
          (string= code "ScopeIncompatible")) "incompatible")
    ((and (string= table "scope_relation_table_0")
          (string= code "ScopeRelationUnknown")) "unknown")
    ((and (string= table "temporal_relation_table_0")
          (string= code "UnsupportedTemporalModel")) "incompatible")
    ((and (string= table "temporal_relation_table_0")
          (string= code "AdmissibilityUndetermined")) "unknown")
    (t nil)))

(defun evaluate-relation-table-companion (table row)
  "Execute one sealed relation-table ROW of TABLE and return the semantic
companion document: the determinate relation on success, or the ruled
failure coordinates (LCI0-AC-002) with their precedence evidence.

Ruled nested coordinates: cross-calculus scope incompatibility selects the
right operand's calculus coordinate; a symbolic right temporal form selects
the right operand's expression form coordinate.  Host argument positions are
never exposed."
  (destructuring-bind (left-field right-field)
      (cdr (assoc table +relation-table-operands+ :test #'string=))
    (let ((left (record-field-named row left-field))
          (right (record-field-named row right-field))
          (engine (if (string= table "scope_relation_table_0")
                      #'scope-relation #'temporal-relation)))
      (handler-case
          (list (cons "status" "success")
                (cons "relation" (identifier-last (funcall engine left right))))
        (lci-failure (condition)
          (let* ((code (lci-failure-code condition))
                 (relation (%companion-relation-of-code table code)))
            (unless relation (error condition))
            (cond
              ;; LCI0-AC-002 scope_24: left operand validated first; the right
              ;; nested calculus completes proof of cross-calculus
              ;; incompatibility.  Confirm the ruled ground on the inputs.
              ((and (string= code "ScopeIncompatible")
                    (not (equal-datum (record-field-named left "calculus")
                                      (record-field-named right "calculus"))))
               (list
                (cons "status" "failure")
                (cons "relation" relation)
                (cons "failure"
                      (list (cons "category" (lci-failure-category condition))
                            (cons "code" code)
                            (cons "stage" (lci-failure-stage condition))
                            (cons "semantic_path"
                                  (%semantic-path-string
                                   (list right-field "calculus")))))
                (cons "precedence_evidence"
                      (list (cons "rule"
                                  "left operand validated first; the right nested calculus is the first coordinate that completes proof of cross-calculus incompatibility")
                            (cons "selected_coordinate"
                                  (%semantic-path-string
                                   (list right-field "calculus")))
                            (cons "retained_competing_causes"
                                  (list (%semantic-path-string
                                         (list left-field "calculus"))
                                        (%semantic-path-string
                                         (list right-field "calculus"))))))))
              ;; LCI0-AC-002 temporal_14: a symbolic right form independently
              ;; prevents relation determination.
              ((and (string= code "AdmissibilityUndetermined")
                    (string= (or (exact-form-name
                                  (record-field-named right "expression"))
                                 "")
                             "symbolic"))
               (list
                (cons "status" "failure")
                (cons "relation" relation)
                (cons "failure"
                      (list (cons "category" (lci-failure-category condition))
                            (cons "code" code)
                            (cons "stage" (lci-failure-stage condition))
                            (cons "semantic_path"
                                  (%semantic-path-string
                                   (list right-field "expression" "form")))))
                (cons "precedence_evidence"
                      (list (cons "rule"
                                  "right symbolic form independently prevents determination")
                            (cons "selected_coordinate"
                                  (%semantic-path-string
                                   (list right-field "expression" "form")))
                            (cons "retained_competing_causes" nil)))))
              ;; Families outside the two ruled ones keep the operand-rooted
              ;; coordinate without exposing host argument spellings.
              (t
               (list
                (cons "status" "failure")
                (cons "relation" relation)
                (cons "failure"
                      (list (cons "category" (lci-failure-category condition))
                            (cons "code" code)
                            (cons "stage" (lci-failure-stage condition))
                            (cons "semantic_path"
                                  (%semantic-path-string
                                   (if (member "left"
                                               (lci-failure-path condition)
                                               :test #'string=)
                                       (list left-field)
                                       (list right-field)))))))))))))))

(defun %parse-relation-machine-path (machine-path)
  "\"/relation_and_mapping_tables/<table>/entries/<n>\" -> (values table n)"
  (let* ((parts (loop with start = 1
                      for slash = (position #\/ machine-path :start start)
                      collect (subseq machine-path start slash)
                      while slash
                      do (setf start (1+ slash)))))
    (unless (and (= (length parts) 4)
                 (string= (first parts) "relation_and_mapping_tables")
                 (string= (third parts) "entries"))
      (error "unexpected relation machine path ~A" machine-path))
    (values (second parts) (parse-integer (fourth parts)))))

;;; ---------------------------------------------------------------------------
;;; Retained hostile requests (LCI0-AC-005, LCI0-AC-007).

(defun %hostile-semantic (thunk &key path-prefix)
  "Run THUNK; report success as :SUCCESS, an LCI failure as its exact
structural document.  Host exceptions are never converted into results."
  (handler-case (progn (funcall thunk) (list (cons "status" "success")))
    (lci-failure (condition)
      (semantic-json-of-lci-failure condition :path-prefix path-prefix))))

(defun execute-hostile-case (entry)
  "Execute one retained hostile request from its overlay INDEX ENTRY and
return the semantic result document."
  (let* ((operation (jget entry "operation"))
         (input (decode-exact (hex-to-octets (jget entry "input_hex")))))
    (cond
      ((string= operation "hostile-validate-stable-ref")
       (%hostile-semantic (lambda () (validate-stable-ref input))))
      ((string= operation "hostile-validate-warrant-target")
       (%hostile-semantic (lambda () (validate-warrant-target input))))
      ((string= operation "conformance-validation")
       ;; Full fixture vector-input record.  The positive resource result at
       ;; the inclusive limit projects the implementation's own measured
       ;; decision: the registered limit and workload name come from the
       ;; implementation's resource table, the requested count from the
       ;; validated workload, and the budget verdict from the executed
       ;; operation result.
       (multiple-value-bind (id inner-operation payload)
           (%vector-input-components input)
         (handler-case
             (let ((result (execute-fixture-operation inner-operation payload
                                                      :vector-id id)))
               (multiple-value-bind (definition requested)
                   (%validate-resource-workload
                    (record-field-named payload "workload"))
                 (let* ((outputs (record-field-named result "outputs"))
                        (within (record-field-named outputs "within-budget")))
                   (list
                    (cons "status"
                          (identifier-last
                           (record-field-named result "status")))
                    (cons "value"
                          (list (cons "limit" (second definition))
                                (cons "requested" requested)
                                (cons "within-budget"
                                      (if (boolean-datum-value within)
                                          :json-true :json-false))
                                (cons "workload" (first definition))))))))
           (lci-failure (condition)
             (semantic-json-of-lci-failure condition)))))
      ((string= operation "migrate-v1")
       ;; Full fixture vector-input record.
       (multiple-value-bind (id inner-operation payload)
           (%vector-input-components input)
         (handler-case
             (semantic-json-of-operation-result
              (execute-fixture-operation inner-operation payload
                                         :vector-id id))
           (lci-failure (condition)
             (semantic-json-of-lci-failure condition)))))
      ((string= operation "hostile-evaluate-policy-c")
       ;; LCI0-AC-005: an unknown policy is a non-LCI fixture-authority gap,
       ;; never a Policy-B-like acceptance and never an LCIFailure/0.
       (let ((policy (record-field-named input "policy"))
             (relation (record-field-named input "target-relation")))
         (handler-case
             (progn (evaluate-fixture-policy policy relation)
                    (list (cons "status" "success")))
           (fixture-operation-authorial-gap ()
             (list (cons "status" "authority-gap")
                   (cons "authority_gap" "unsupported fixture policy")
                   (cons "lci_failure" :json-null)))
           (lci-failure (condition)
             (semantic-json-of-lci-failure condition)))))
      (t (error "unknown hostile operation ~A" operation)))))

;;; ---------------------------------------------------------------------------
;;; The fifty-vector closure runner.

(defun %closure-report (results verbose)
  (let ((passed (count-if #'cdr results)))
    (when verbose
      (dolist (result results)
        (format t "~:[FAIL~;PASS~] ~A~%" (cdr result) (car result))))
    (format t "LCI0 CLOSURE SUMMARY: ~D/~D exact; ~D failed~%"
            passed (length results) (- (length results) passed))
    (when verbose
      (dolist (result results)
        (unless (cdr result)
          (format t "CLOSURE FAIL ~A~%" (car result)))))
    (values (= passed (length results)) passed (length results))))

(defun run-closure-vectors (&optional (root *fixture-root*) &key (verbose t))
  "Execute all fifty successor closure vectors against the installed 0.2
overlay: 4 superseded originals, 38 relation companions, 8 hostile cases."
  (let ((overlay (or (load-fixture-overlay root)
                     (error "no fixture overlay installed under ~A" root)))
        (results nil))
    ;; 4 superseded original vectors.
    (let ((wanted (fixture-overlay-supersessions overlay))
          (seen 0))
      (map-vector-rows
       root
       (lambda (row)
         (let* ((id (jget row "vector_id"))
                (entry (gethash id wanted)))
           (when entry
             (incf seen)
             (let ((result (execute-overlay-superseded-vector row entry)))
               (push (cons (format nil "~A (~A)"
                                   (jget entry "successor_vector_id") id)
                           (vector-result-passed result))
                     results)
               (unless (vector-result-passed result)
                 (format *error-output* "~A~%" (vector-result-detail result))))))))
      (unless (= seen 4) (error "expected 4 superseded vectors, saw ~D" seen)))
    ;; 38 relation companions, one registry pass per table.
    (let ((by-table (make-hash-table :test #'equal)))
      (maphash
       (lambda (machine-path entry)
         (multiple-value-bind (table index)
             (%parse-relation-machine-path machine-path)
           (push (list index machine-path entry) (gethash table by-table))))
       (fixture-overlay-relation-failures overlay))
      (maphash
       (lambda (table wanted)
         (let ((count 0))
           (map-registry-relation-entries
            root table
            (lambda (registry-entry)
              (let ((hit (assoc count wanted)))
                (when hit
                  (destructuring-bind (index machine-path entry) hit
                    (declare (ignore index))
                    (let* ((row (fixture-json-to-datum
                                 (jget registry-entry "abstract_cd0")))
                           (actual (evaluate-relation-table-companion table row))
                           (expected
                             (list
                              (cons "status" (jget entry "status"))
                              (cons "relation" (jget entry "relation"))
                              (cons "failure"
                                    (list (cons "category"
                                                (jget entry "category"))
                                          (cons "code" (jget entry "code"))
                                          (cons "stage" (jget entry "stage"))
                                          (cons "semantic_path"
                                                (jget entry "semantic_path"))))
                              (cons "precedence_evidence"
                                    (jget entry "precedence_evidence"))))
                           (passed (json-equal actual expected)))
                      (push (cons (format nil "~A (~A)"
                                          (jget entry "successor_vector_id")
                                          machine-path)
                                  passed)
                            results)
                      (unless passed
                        (format *error-output*
                                "CLOSURE RELATION MISMATCH ~A:~% actual ~A~% expected ~A~%"
                                machine-path
                                (with-output-to-string (s)
                                  (write-json-value actual s))
                                (with-output-to-string (s)
                                  (write-json-value expected s))))))))
              (incf count)))))
       by-table))
    ;; 8 retained hostile requests.
    (maphash
     (lambda (slug entry)
       (let* ((actual (execute-hostile-case entry))
              (expected (jget entry "expected_result"))
              (passed (json-equal actual expected)))
         (push (cons (format nil "~A (~A)"
                             (jget entry "successor_vector_id") slug)
                     passed)
               results)
         (unless passed
           (format *error-output*
                   "CLOSURE HOSTILE MISMATCH ~A:~% actual ~A~% expected ~A~%"
                   slug
                   (with-output-to-string (s) (write-json-value actual s))
                   (with-output-to-string (s) (write-json-value expected s))))))
     (fixture-overlay-hostile overlay))
    (%closure-report (sort results #'string< :key #'car) verbose)))
