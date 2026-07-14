(in-package #:lisp-plus-lci0)

(defstruct vector-result
  id operation passed actual expected detail)

(defun first-datum-difference (left right &optional (path nil))
  (when (equal-datum left right)
    (return-from first-datum-difference (values nil nil nil)))
  (unless (eq (datum-family left) (datum-family right))
    (return-from first-datum-difference (values path left right)))
  (cond
    ((sequence-datum-p left)
     (unless (= (sequence-datum-length left) (sequence-datum-length right))
       (return-from first-datum-difference (values path left right)))
     (loop for index below (sequence-datum-length left)
           do (multiple-value-bind (where actual expected)
                  (first-datum-difference (sequence-datum-ref left index)
                                          (sequence-datum-ref right index)
                                          (append path (list index)))
                (when actual (return (values where actual expected))))))
    ((record-datum-p left)
     (unless (= (record-datum-size left) (record-datum-size right))
       (return-from first-datum-difference (values path left right)))
     (loop for index below (record-datum-size left)
           for lk = (record-datum-key-at left index)
           for rk = (record-datum-key-at right index)
           do (unless (equal-datum lk rk)
                (return (values (append path (list :key index)) lk rk)))
              (multiple-value-bind (where actual expected)
                  (first-datum-difference
                   (record-datum-value-at left index)
                   (record-datum-value-at right index)
                   (append path (list (identifier-last lk))))
                (when actual (return (values where actual expected))))))
    (t (values path left right))))

(defun %vector-input-components (input)
  (values (datum-string-value* (record-field-named input "vector-id"))
          (record-field-named input "operation")
          (record-field-named input "payload")))

(defun execute-fixture-vector (row &key (verify-documents t))
  (let* ((input-document (jget row "inputs"))
         (expected-document (jget row "expected"))
         (input (fixture-json-to-datum (jget input-document "abstract_cd0")))
         (expected (fixture-json-to-datum (jget expected-document "abstract_cd0"))))
    (when verify-documents
      (verify-fixture-document input-document)
      (verify-fixture-document expected-document))
    (multiple-value-bind (id operation payload) (%vector-input-components input)
      (let ((actual
              (handler-case
                  (execute-fixture-operation operation payload :vector-id id)
                (lci-failure (condition) (failure-datum condition id)))))
        (make-vector-result
         :id id :operation (operation-name operation)
         :passed (and (equal-datum actual expected)
                      (string= (octets-to-hex (canonical-octets actual))
                               (jget expected-document "canonical_cd0_hex")))
         :actual actual :expected expected
         :detail (unless (equal-datum actual expected)
                   (format nil "actual ~A expected ~A"
                           (octets-to-hex (canonical-octets actual))
                           (jget expected-document "canonical_cd0_hex"))))))))

(defun map-vector-rows (root function)
  (with-open-file
      (stream (fixture-path root "LCI0-FIXTURE-VECTORS.jsonl")
              :direction :input :external-format :utf-8)
    (loop for line = (read-line stream nil nil)
          while line
          unless (zerop (length line))
            do (funcall function (parse-json line)))))

(defun run-vector-selection (ids &optional (root *fixture-root*))
  (let ((wanted (make-hash-table :test #'equal))
        (seen (make-hash-table :test #'equal))
        (all-pass t))
    (dolist (id ids) (setf (gethash id wanted) t))
    (map-vector-rows
     root
     (lambda (row)
       (let ((id (jget row "vector_id")))
         (when (gethash id wanted)
           (setf (gethash id seen) t)
           (let ((result (execute-fixture-vector row)))
             (unless (vector-result-passed result)
               (setf all-pass nil)
               (format *error-output* "VECTOR FAIL ~A (~A)~%"
                       id (vector-result-operation result))))))))
    (dolist (id ids)
      (unless (gethash id seen)
        (setf all-pass nil)
        (format *error-output* "VECTOR MISSING ~A~%" id)))
    all-pass))

(defun verify-fixture-relation-tables (&optional (root *fixture-root*))
  "Execute every sealed scope and temporal relation-table document against
the local calculus.  This is distinct from the canonical-document sweep: it
checks all 458 recorded semantic results, not merely their CD/0 round trips."
  (labels ((table-result (table relation-function left right)
             (handler-case (funcall relation-function left right)
               (lci-failure (condition)
                 ;; The tables record the abstract calculus relation while the
                 ;; public engines expose the corresponding typed failure at
                 ;; an undetermined/incompatible operational boundary.
                 (let ((relation
                         (cond
                           ((and (string= table "scope_relation_table_0")
                                 (string= (lci-failure-code condition)
                                          "ScopeIncompatible"))
                            "incompatible")
                           ((and (string= table "scope_relation_table_0")
                                 (string= (lci-failure-code condition)
                                          "ScopeRelationUnknown"))
                            "unknown")
                           ((and (string= table "temporal_relation_table_0")
                                 (string= (lci-failure-code condition)
                                          "UnsupportedTemporalModel"))
                            "incompatible")
                           ((and (string= table "temporal_relation_table_0")
                                 (string= (lci-failure-code condition)
                                          "AdmissibilityUndetermined"))
                            "unknown"))))
                   (if relation (%relation-id relation) (error condition))))))
           (verify-table (table left-field right-field relation-function)
             (let ((count 0))
               (map-registry-relation-entries
                root table
                (lambda (entry)
                  (verify-fixture-document entry)
                  (let* ((row (fixture-json-to-datum
                               (jget entry "abstract_cd0")))
                         (left (record-field-named row left-field))
                         (right (record-field-named row right-field))
                         (expected (record-field-named row "relation"))
                         (actual (table-result table relation-function
                                               left right)))
                    (unless (equal-datum actual expected)
                      (internal-integrity-fail
                       "fixture-package" "RelationTableMismatch"
                       "fixture-corpus"
                       :path (list table (format nil "~D" count))))
                    (incf count))))
               count)))
    (let ((scope (verify-table "scope_relation_table_0"
                               "left-scope" "right-scope" #'scope-relation))
          (temporal (verify-table "temporal_relation_table_0"
                                  "left-subject-time" "right-subject-time"
                                  #'temporal-relation)))
      (unless (= (+ scope temporal) 458)
        (internal-integrity-fail "fixture-package"
                                 "FixtureCorpusCensusMismatch"
                                 "fixture-corpus"))
      (list :scope scope :temporal temporal :total (+ scope temporal)))))

(defun run-all-vectors (&rest arguments)
  ;; Accept the historical positional ROOT followed by keywords without the
  ;; ambiguous &OPTIONAL/&KEY lambda-list combination.
  (let* ((root (if (and arguments (not (keywordp (first arguments))))
                   (pop arguments) *fixture-root*))
         (verbose (if (member :verbose arguments) (getf arguments :verbose) t))
         (verify-documents
           (if (member :verify-documents arguments)
               (getf arguments :verify-documents) t))
         (total 0) (passed 0) (ids (make-hash-table :test #'equal))
        (failures (make-hash-table :test #'equal)))
    (map-vector-rows
     root
     (lambda (row)
       (incf total)
       (let* ((id (jget row "vector_id"))
              (operation (jget row "operation")))
         (when (gethash id ids) (error "duplicate vector ID ~A" id))
         (setf (gethash id ids) t)
         (handler-case
             (let ((result (execute-fixture-vector row
                                                   :verify-documents verify-documents)))
               (if (vector-result-passed result)
                   (incf passed)
                   (progn
                     (incf (gethash operation failures 0))
                     (when verbose
                       (format t "FAIL ~A ~A~%" id operation)))))
           (error (condition)
             (incf (gethash operation failures 0))
             (when verbose
               (format t "ERROR ~A ~A -- ~A~%" id operation condition)))))))
    (unless (= (hash-table-count ids) total)
      (error "vector ID uniqueness failure"))
    (dolist (required
             (append (loop for index from 1 to 30
                           collect (format nil "LCI0-P~3,'0D" index))
                     (loop for index from 1 to 32
                           collect (format nil "LCI0-N~3,'0D" index))))
      (unless (gethash required ids) (error "missing required vector ~A" required)))
    (format t "LCI0 VECTOR SUMMARY: ~D/~D exact; ~D failed~%"
            passed total (- total passed))
    (when (plusp (- total passed))
      (format t "FAILURES BY OPERATION:~%")
      (let ((pairs nil))
        (maphash (lambda (key value) (push (cons key value) pairs)) failures)
        (dolist (pair (sort pairs #'string< :key #'car))
          (format t "  ~A: ~D~%" (car pair) (cdr pair)))))
    (values (= passed total) passed total failures)))

(defun run-mutation-snapshot-test ()
  (let* ((namespace (list "lisp-plus" "lci" "0" "test"))
         (path (list "immutable"))
         (identifier (make-identifier-datum namespace path))
         (record (make-lci-record
                  (list "kind" (lci-tag "fixture-mutation-value"))
                  (list "value" identifier)))
         (before (octets-to-hex (canonical-octets record))))
    (setf (first namespace) "mutated" (first path) "changed")
    (string= before (octets-to-hex (canonical-octets record)))))

(defun write-json-line-result (result &optional (stream *standard-output*))
  (write-json-value
   (list (cons "vector_id" (vector-result-id result))
         (cons "operation" (vector-result-operation result))
         (cons "passed" (if (vector-result-passed result)
                             :json-true :json-false))
         (cons "actual_canonical_cd0_hex"
               (octets-to-hex (canonical-octets
                               (vector-result-actual result)))))
   stream)
  (terpri stream))
