(in-package #:lisp-plus-lci0)

;;; Audit-only native Common Lisp relation runner.  It constructs its finite
;;; domains from frozen registry templates, validates them with the public LCI/0
;;; validators, executes the public relation operations, and emits neutral
;;; JSONL.  It does not consume Python objects or expected relation results.

(defun audit-replace-field (record name replacement)
  (unless (record-datum-p record)
    (error "audit field replacement requires a record"))
  (let ((found nil) (entries nil))
    (loop for index below (record-datum-size record)
          for key = (record-datum-key-at record index)
          for value = (record-datum-value-at record index)
          do (when (equal (identifier-path-strings key) (list name))
               (setf value replacement found t))
             (push (make-record-entry key value) entries))
    (unless found (error "audit template lacks field ~A" name))
    (make-record-datum (nreverse entries))))

(defun audit-remove-field (record name)
  (make-record-datum
   (loop for index below (record-datum-size record)
         for key = (record-datum-key-at record index)
         unless (equal (identifier-path-strings key) (list name))
           collect (make-record-entry key (record-datum-value-at record index)))))

(defun audit-add-unknown (record namespace)
  (make-record-datum
   (append
    (loop for index below (record-datum-size record)
          collect (make-record-entry (record-datum-key-at record index)
                                     (record-datum-value-at record index)))
    (list (make-record-entry (make-id namespace '("audit-unknown"))
                             (make-unit-datum))))))

(defun audit-with-expression (outer expression)
  (audit-replace-field outer "expression" expression))

(defun audit-instant (template tick)
  (let* ((expression (record-field-named template "expression"))
         (changed (audit-replace-field expression "tick"
                                       (make-integer-datum tick))))
    (audit-with-expression template changed)))

(defun audit-interval (template start end start-closed end-closed)
  (let ((expression (record-field-named template "expression")))
    (setf expression (audit-replace-field expression "start"
                                          (make-integer-datum start))
          expression (audit-replace-field expression "end"
                                          (make-integer-datum end))
          expression (audit-replace-field expression "start-closed"
                                          (make-boolean-datum start-closed))
          expression (audit-replace-field expression "end-closed"
                                          (make-boolean-datum end-closed)))
    (audit-with-expression template expression)))

(defun audit-periodic (template modulus remainder)
  (let ((expression (record-field-named template "expression")))
    (setf expression (audit-replace-field expression "modulus"
                                          (make-integer-datum modulus))
          expression (audit-replace-field expression "remainder"
                                          (make-integer-datum remainder)))
    (audit-with-expression template expression)))

(defun audit-temporal-domain ()
  (let ((atemporal (registry-datum "subject-time.atemporal"))
        (instant (registry-datum "subject-time.instant-0"))
        (interval (registry-datum "subject-time.interval-0-50-closed"))
        (periodic (registry-datum "subject-time.periodic-even"))
        (values nil))
    (push atemporal values)
    (loop for tick from 0 to 3 do (push (audit-instant instant tick) values))
    (loop for start from 0 to 3
          do (loop for end from 0 to 3
                   when (< start end)
                     do (dolist (start-closed '(nil t))
                          (dolist (end-closed '(nil t))
                            (push (audit-interval interval start end
                                                  start-closed end-closed)
                                  values)))))
    (dolist (parameters '((2 0) (2 1) (3 0) (3 1) (3 2)))
      (push (audit-periodic periodic (first parameters) (second parameters))
            values))
    (push (registry-datum "subject-time.symbolic-unknown") values)
    (push (registry-datum "subject-time.second.alpha") values)
    (setf values (nreverse values))
    (unless (= (length values) 36) (error "temporal audit census mismatch"))
    (dolist (value values) (validate-subject-time value :path '("audit")))
    values))

(defparameter +audit-scope-fixtures+
  '("scope.universal" "scope.org-acme" "scope.dept-research"
    "scope.dept-operations" "scope.tenant-a" "scope.tenant-b"
    "scope.region-x" "scope.region-y" "scope.region-east"
    "scope.region-north" "scope.region-south" "scope.symbolic-unknown"
    "scope.second.alpha"))

(defun audit-scope-domain ()
  (let ((values (mapcar #'registry-datum +audit-scope-fixtures+)))
    (unless (= (length values) 13) (error "scope audit census mismatch"))
    (dolist (value values) (validate-scope value :path '("audit")))
    values))

(defun audit-relation-name (identifier)
  (identifier-last identifier))

(defun audit-outcome (function left right)
  (handler-case
      (list (cons "kind" "relation")
            (cons "relation" (audit-relation-name
                               (funcall function left right))))
    (lci-failure (condition)
      (list (cons "kind" "failure")
            (cons "category" (lci-failure-category condition))
            (cons "code" (lci-failure-code condition))
            (cons "stage" (lci-failure-stage condition))
            (cons "path" (or (lci-failure-path condition) nil))))
    (error (condition)
      (list (cons "kind" "host-exception")
            (cons "condition" (string-downcase
                                (symbol-name (type-of condition))))))))

(defun audit-json-line (value)
  (write-json-value value *standard-output*)
  (terpri *standard-output*))

(defun audit-domain-records (domain values)
  (loop for value in values for index from 0
        do (audit-json-line
            (list (cons "record_type" "domain-value")
                  (cons "language" "common-lisp")
                  (cons "domain" domain)
                  (cons "index" index)
                  (cons "canonical_hex"
                        (octets-to-hex (canonical-octets value)))))))

(defun audit-pair-records (domain values function)
  (loop for left in values for left-index from 0
        do (loop for right in values for right-index from 0
                 do (audit-json-line
                     (append
                      (list (cons "record_type" "pair-result")
                            (cons "language" "common-lisp")
                            (cons "domain" domain)
                            (cons "left_index" left-index)
                            (cons "right_index" right-index))
                      (audit-outcome function left right))))))

(defun audit-bounded-transform (value multiplier offset)
  (let* ((expression (record-field-named value "expression"))
         (form (exact-form-name expression)))
    (cond
      ((string= form "instant")
       (audit-with-expression
        value
        (audit-replace-field
         expression "tick"
         (make-integer-datum
          (+ (* multiplier
                (integer-datum-value (record-field-named expression "tick")))
             offset)))))
      ((string= form "interval")
       (let ((changed expression))
         (dolist (name '("start" "end"))
           (setf changed
                 (audit-replace-field
                  changed name
                  (make-integer-datum
                   (+ (* multiplier
                         (integer-datum-value
                          (record-field-named expression name)))
                      offset)))))
         (audit-with-expression value changed)))
      (t (error "non-bounded temporal metamorphic input")))))

(defun audit-relation-result-name (function left right)
  (let ((outcome (audit-outcome function left right)))
    (and (string= (cdr (assoc "kind" outcome :test #'string=)) "relation")
         (cdr (assoc "relation" outcome :test #'string=)))))

(defun audit-temporal-metamorphic-summary (temporal)
  (let ((bounded (subseq temporal 1 29))
        (translation-count 0) (translation-failures 0)
        (renaming-count 0) (renaming-failures 0))
    (dolist (left bounded)
      (dolist (right bounded)
        (let ((original (audit-relation-result-name #'temporal-relation
                                                     left right)))
          (dolist (offset '(-2 -1 1 2))
            (incf translation-count)
            (unless (and original
                         (string=
                          original
                          (audit-relation-result-name
                           #'temporal-relation
                           (audit-bounded-transform left 1 offset)
                           (audit-bounded-transform right 1 offset))))
              (incf translation-failures)))
          (incf renaming-count)
          (unless (and original
                       (string=
                        original
                        (audit-relation-result-name
                         #'temporal-relation
                         (audit-bounded-transform left 2 1)
                         (audit-bounded-transform right 2 1))))
            (incf renaming-failures)))))
    (audit-json-line
     (list (cons "record_type" "metamorphic-summary")
           (cons "language" "common-lisp")
           (cons "translation_cases" translation-count)
           (cons "translation_failures" translation-failures)
           (cons "renaming_cases" renaming-count)
           (cons "renaming_failures" renaming-failures)))))

(defun audit-roundtrip-summary (temporal scope)
  (let ((count 0) (failures 0))
    (dolist (value (append temporal scope))
      (incf count)
      (let* ((octets (canonical-octets value))
             (copy (decode-exact (octets-copy octets))))
        (unless (and (equal-datum value copy)
                     (string= (octets-to-hex octets)
                              (octets-to-hex (canonical-octets copy))))
          (incf failures))))
    (audit-json-line
     (list (cons "record_type" "roundtrip-summary")
           (cons "language" "common-lisp")
           (cons "cases" count)
           (cons "failures" failures)))))

(defun audit-scope-extension-summary (scope)
  (let* ((region-x (nth 6 scope))
         (region-y (nth 7 scope))
         (south (nth 10 scope))
         (x-expression (record-field-named region-x "expression"))
         (south-expression (record-field-named south "expression"))
         (members (append (%datum-sequence-list
                           (record-field-named x-expression "members"))
                          (list (first (%datum-sequence-list
                                       (record-field-named south-expression
                                                           "members"))))))
         (sorted (sort members #'string< :key (lambda (value)
                                                (octets-to-hex
                                                 (canonical-octets value)))))
         (probe (audit-with-expression
                 region-x
                 (audit-replace-field x-expression "members"
                                      (make-sequence-datum sorted))))
         (failures 0))
    (validate-scope probe :path '("audit" "extension-probe"))
    (dolist (case (list (list probe region-x "wider")
                        (list region-x probe "narrower")
                        (list probe region-y "wider")
                        (list region-y probe "narrower")))
      (unless (string= (or (audit-relation-result-name
                            #'scope-relation (first case) (second case)) "")
                       (third case))
        (incf failures)))
    (audit-json-line
     (list (cons "record_type" "scope-extension-summary")
           (cons "language" "common-lisp")
           (cons "registered_census" 13)
           (cons "probe_in_registered_census" :json-false)
           (cons "cases" 4)
           (cons "failures" failures)
           (cons "probe_canonical_hex"
                 (octets-to-hex (canonical-octets probe)))))))

(defun audit-malformed-domains ()
  (let* ((ta (registry-datum "subject-time.instant-0"))
         (te (record-field-named ta "expression"))
         (interval (registry-datum "subject-time.interval-0-50-closed"))
         (ie (record-field-named interval "expression"))
         (periodic (registry-datum "subject-time.periodic-even"))
         (pe (record-field-named periodic "expression"))
         (sa (registry-datum "scope.universal"))
         (se (record-field-named sa "expression"))
         (region (registry-datum "scope.region-x"))
         (re (record-field-named region "expression"))
         (members (%datum-sequence-list (record-field-named re "members")))
         (symbolic (registry-datum "scope.symbolic-unknown"))
         (organization (registry-datum "scope.org-acme"))
         (department (registry-datum "scope.dept-research"))
         (tenant (registry-datum "scope.tenant-a"))
         (opaque (registry-datum "scope.second.alpha"))
         (temporal
           (list (make-unit-datum) (make-integer-datum 0)
                 (audit-remove-field ta "kind")
                 (audit-replace-field ta "kind" (make-unit-datum))
                 (audit-remove-field ta "schema-version")
                 (audit-replace-field ta "schema-version" (make-integer-datum 1))
                 (audit-remove-field ta "temporal-model")
                 (audit-replace-field ta "temporal-model"
                                      (record-field-named sa "calculus"))
                 (audit-remove-field ta "expression")
                 (audit-add-unknown ta +lci-field-namespace+)
                 (audit-with-expression ta
                   (audit-add-unknown te +fixture-field-namespace+))
                 (audit-with-expression ta
                   (audit-replace-field te "form" (make-unit-datum)))
                 (audit-with-expression ta
                   (audit-replace-field te "tick" (make-unit-datum)))
                 (audit-with-expression interval
                   (audit-replace-field ie "start" (make-unit-datum)))
                 (audit-with-expression interval
                   (audit-replace-field ie "end" (make-unit-datum)))
                 (audit-with-expression interval
                   (audit-replace-field
                    (audit-replace-field ie "start" (make-integer-datum 1))
                    "end" (make-integer-datum 1)))
                 (audit-with-expression interval
                   (audit-replace-field
                    (audit-replace-field ie "start" (make-integer-datum 2))
                    "end" (make-integer-datum 1)))
                 (audit-with-expression interval
                   (audit-replace-field ie "start-closed" (make-unit-datum)))
                 (audit-with-expression interval
                   (audit-replace-field ie "end-closed" (make-unit-datum)))
                 (audit-with-expression periodic
                   (audit-replace-field pe "modulus" (make-integer-datum 0)))
                 (audit-with-expression periodic
                   (audit-replace-field pe "modulus" (make-integer-datum -1)))
                 (audit-with-expression periodic
                   (audit-replace-field pe "remainder" (make-integer-datum -1)))
                 (audit-with-expression periodic
                   (audit-replace-field pe "remainder" (make-integer-datum 2)))))
         (scope
           (list (make-unit-datum) (make-integer-datum 0)
                 (audit-remove-field sa "kind")
                 (audit-replace-field sa "kind" (make-unit-datum))
                 (audit-remove-field sa "schema-version")
                 (audit-replace-field sa "schema-version" (make-integer-datum 1))
                 (audit-remove-field sa "calculus")
                 (audit-replace-field sa "calculus"
                                      (record-field-named ta "temporal-model"))
                 (audit-remove-field sa "expression")
                 (audit-add-unknown sa +lci-field-namespace+)
                 (audit-with-expression sa
                   (audit-replace-field se "form" (make-unit-datum)))
                 (audit-with-expression sa
                   (audit-add-unknown se +fixture-field-namespace+))
                 (audit-with-expression region
                   (audit-replace-field re "members" (make-unit-datum)))
                 (audit-with-expression region
                   (audit-replace-field re "members" (make-sequence-datum nil)))
                 (audit-with-expression region
                   (audit-replace-field re "members"
                                        (make-sequence-datum
                                         (list (make-unit-datum)))))
                 (audit-with-expression region
                   (audit-replace-field re "members"
                                        (make-sequence-datum (reverse members))))
                 (audit-with-expression region
                   (audit-replace-field re "members"
                                        (make-sequence-datum
                                         (list (first members) (first members)))))
                 (audit-with-expression symbolic
                   (audit-replace-field
                    (record-field-named symbolic "expression")
                    "known-proper-subset" (make-unit-datum)))
                 (audit-with-expression organization
                   (audit-remove-field (record-field-named organization "expression")
                                       "organization"))
                 (audit-with-expression department
                   (audit-remove-field (record-field-named department "expression")
                                       "organization"))
                 (audit-with-expression department
                   (audit-remove-field (record-field-named department "expression")
                                       "department"))
                 (audit-with-expression tenant
                   (audit-remove-field (record-field-named tenant "expression")
                                       "organization"))
                 (audit-with-expression tenant
                   (audit-remove-field (record-field-named tenant "expression")
                                       "tenant"))
                 (audit-with-expression opaque
                   (audit-remove-field (record-field-named opaque "expression")
                                       "token")))))
    (unless (and (= (length temporal) 23) (= (length scope) 24))
      (error "malformed template census mismatch"))
    (values ta temporal sa scope)))

(defun audit-malformed-summary ()
  (multiple-value-bind (ta temporal sa scope) (audit-malformed-domains)
    (labels ((counts (anchor templates function)
               (let ((semantic 0) (host 0))
                 (dolist (bad templates)
                   (dolist (pair (list (list bad anchor) (list anchor bad)))
                     (let ((kind (cdr (assoc "kind"
                                            (audit-outcome function
                                                           (first pair) (second pair))
                                            :test #'string=))))
                       (cond ((string= kind "relation") (incf semantic))
                             ((string= kind "host-exception") (incf host))))))
                 (list (* 2 (length templates)) semantic host))))
      (let ((tc (counts ta temporal #'temporal-relation))
            (sc (counts sa scope #'scope-relation)))
        (audit-json-line
         (list (cons "record_type" "malformed-summary")
               (cons "language" "common-lisp")
               (cons "temporal_cases" (first tc))
               (cons "temporal_semantic_results" (second tc))
               (cons "temporal_host_exceptions" (third tc))
               (cons "scope_cases" (first sc))
               (cons "scope_semantic_results" (second sc))
               (cons "scope_host_exceptions" (third sc))))))))

(defun run-common-lisp-law-audit ()
  (let ((temporal (audit-temporal-domain))
        (scope (audit-scope-domain)))
    (audit-json-line
     (list (cons "record_type" "runner-header")
           (cons "language" "common-lisp")
           (cons "schema" "lci0-law-native-stream/1")))
    (audit-domain-records "temporal" temporal)
    (audit-domain-records "scope" scope)
    (audit-pair-records "temporal" temporal #'temporal-relation)
    (audit-pair-records "scope" scope #'scope-relation)
    (audit-temporal-metamorphic-summary temporal)
    (audit-roundtrip-summary temporal scope)
    (audit-scope-extension-summary scope)
    (audit-malformed-summary)
    (let ((table-counts (verify-fixture-relation-tables)))
      (audit-json-line
       (list (cons "record_type" "registered-table-summary")
             (cons "language" "common-lisp")
             (cons "temporal" (getf table-counts :temporal))
             (cons "scope" (getf table-counts :scope))
             (cons "total" (getf table-counts :total)))))
    t))
