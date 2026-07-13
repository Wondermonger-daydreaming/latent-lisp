;;;; Common Lisp host-boundary probes for the CD/0 qualification coordinator.

(load "canonical-datum/common-lisp/package.lisp")
(load "canonical-datum/common-lisp/cd0.lisp")

(defpackage #:lisp-plus-cd0-qualification
  (:use #:cl #:lisp-plus-cd0))

(in-package #:lisp-plus-cd0-qualification)

(defvar *activation-calls* 0)

(defun qcheck (condition message)
  (unless condition (error "qualification assertion failed: ~A" message)))

(defun qid (namespace name)
  (make-identifier-datum namespace (list name)))

(defun expected-failure (thunk category code stage)
  (handler-case
      (progn (funcall thunk)
             (error "expected failure ~A/~A/~A" category code stage))
    (cd0-failure (condition)
      (qcheck (string= (failure-category condition) category) "failure category")
      (qcheck (string= (failure-code condition) code) "failure code")
      (qcheck (string= (failure-stage condition) stage) "failure stage")
      t)))

(defun same-encoding-p (datum baseline)
  (string= (octets-to-hex (encode-exact datum)) baseline))

(defun mutation-probes ()
  (let ((count 0))
    (let* ((source (copy-seq "abc"))
           (datum (make-string-datum source))
           (baseline (octets-to-hex (encode-exact datum))))
      (setf (char source 0) #\z)
      (incf count)
      (qcheck (same-encoding-p datum baseline) "mutable source string alias")
      (let ((view (string-datum-value datum)))
        (setf (char view 1) #\z)
        (incf count)
        (qcheck (same-encoding-p datum baseline) "mutable string view alias")))
    (let* ((source (make-array 3 :element-type '(unsigned-byte 8)
                               :initial-contents '(1 2 3)))
           (datum (make-bytes-datum source))
           (baseline (octets-to-hex (encode-exact datum))))
      (setf (aref source 0) 9)
      (incf count)
      (qcheck (same-encoding-p datum baseline) "mutable source octets alias")
      (let ((view (bytes-datum-value datum)))
        (setf (aref view 1) 9)
        (incf count)
        (qcheck (same-encoding-p datum baseline) "mutable octet view alias")))
    (let* ((segment (copy-seq "name"))
           (datum (make-identifier-datum nil (list segment)))
           (baseline (octets-to-hex (encode-exact datum))))
      (setf (char segment 0) #\x)
      (incf count)
      (qcheck (same-encoding-p datum baseline) "mutable identifier source alias")
      (let* ((segments (identifier-datum-path datum))
             (view (aref segments 0)))
        (setf (char view 0) #\q)
        (incf count)
        (qcheck (same-encoding-p datum baseline) "mutable identifier view alias")))
    (let* ((source (vector (make-unit-datum) (make-boolean-datum t)))
           (datum (make-sequence-datum source))
           (baseline (octets-to-hex (encode-exact datum))))
      (setf (aref source 0) (make-integer-datum 99))
      (incf count)
      (qcheck (same-encoding-p datum baseline) "mutable sequence source alias")
      (let ((view (sequence-datum-elements datum)))
        (setf (aref view 0) (make-integer-datum 42))
        (incf count)
        (qcheck (same-encoding-p datum baseline) "mutable sequence view alias")))
    (let* ((key (qid nil "field"))
           (entry (make-record-entry key (make-unit-datum)))
           (source (vector entry))
           (datum (make-record-datum source))
           (baseline (octets-to-hex (encode-exact datum))))
      (setf (aref source 0)
            (make-record-entry (qid nil "other") (make-integer-datum 7)))
      (incf count)
      (qcheck (same-encoding-p datum baseline) "mutable record source alias")
      (let ((view (record-datum-fields datum)))
        (setf (aref view 0)
              (make-record-entry (qid nil "changed") (make-unit-datum)))
        (incf count)
        (qcheck (same-encoding-p datum baseline) "mutable record view alias")))
    (let* ((source (octets-copy (hex-to-octets "4c504344002103616263")))
           (datum (decode-exact source))
           (baseline (octets-to-hex (encode-exact datum))))
      (fill source 0)
      (incf count)
      (qcheck (same-encoding-p datum baseline) "mutable decoder input alias"))
    count))

(defun ambient-identity ()
  (let* ((record
           (make-record-datum
            (list
             (make-record-entry (qid '("ambient") "gamma")
                                (make-integer-datum 3))
             (make-record-entry (qid '("ambient") "alpha")
                                (make-integer-datum 1))
             (make-record-entry (qid '("ambient") "beta")
                                (make-integer-datum 2)))))
         (baseline (octets-to-hex (encode-exact record)))
         (readtable (copy-readtable nil)))
    (set-macro-character
     #\!
     (lambda (stream character)
       (declare (ignore stream character))
       (incf *activation-calls*)
       (error "qualification ambient reader hook invoked"))
     nil readtable)
    (let ((*package* (find-package :keyword))
          (*print-base* 2)
          (*print-radix* t)
          (*print-case* :downcase)
          (*print-circle* t)
          (*print-level* 0)
          (*print-length* 0)
          (*readtable* readtable))
      (qcheck (string= (octets-to-hex (encode-exact record)) baseline)
              "printer/package/readtable changed canonical identity")
      (qcheck (string= (render-diagnostic (make-integer-datum 123456789))
                       "123456789")
              "ambient printer changed diagnostic integer"))
    baseline))

(defun call-with-activation-guards (thunk)
  ;; This is finite instrumentation, not a claim that Common Lisp exposes a
  ;; universal evaluator/I/O hook.  It guards the ordinary global entry points
  ;; most directly relevant to accidental reader, evaluator, interning, and
  ;; file restoration on the qualified SBCL host.
  (let* ((symbols (list 'cl:eval 'cl:read 'cl:read-preserving-whitespace
                        'cl:read-from-string 'cl:load 'cl:open 'cl:intern
                        'cl:find-symbol))
         (originals (mapcar (lambda (symbol)
                              (cons symbol (symbol-function symbol)))
                            symbols))
         (common-lisp-package (find-package :cl))
         (was-locked (sb-ext:package-locked-p common-lisp-package)))
    (unwind-protect
         (progn
           (when was-locked (sb-ext:unlock-package common-lisp-package))
           (dolist (symbol symbols)
             (setf (symbol-function symbol)
                   (lambda (&rest arguments)
                     (declare (ignore arguments))
                     (incf *activation-calls*)
                     (error "qualification guarded activation entry point invoked"))))
           (funcall thunk))
      (dolist (entry originals)
        (setf (symbol-function (car entry)) (cdr entry)))
      (when was-locked (sb-ext:lock-package common-lisp-package)))))

(defun host-shape-probes ()
  (let* ((shared (list (cons "t" "string")
                       (cons "utf8_hex" "736861726564")))
         (ast (list (cons "t" "seq")
                    (cons "items" (list shared shared))))
         (datum (datum-from-fixture-ast ast)))
    (qcheck (= (sequence-datum-length datum) 2) "shared acyclic length")
    (qcheck (equal-datum (sequence-datum-ref datum 0)
                         (sequence-datum-ref datum 1))
            "shared acyclic values changed"))
  (let* ((cyclic (list (cons "t" "seq") (cons "items" nil)))
         (items (list cyclic)))
    (setf (cdr (assoc "items" cyclic :test #'string=)) items)
    (expected-failure
     (lambda () (datum-from-fixture-ast cyclic))
     "UnsupportedHostInput" "CyclicHostInput" "host-import"))
  (let ((left (make-identifier-datum '("a") '("b")))
        (right (make-identifier-datum nil '("a" "b"))))
    (qcheck (not (equal-datum left right)) "namespace allocation collapsed")
    (qcheck (not (string= (octets-to-hex (encode-exact left))
                          (octets-to-hex (encode-exact right))))
            "namespace allocation bytes collapsed")))

(defun inert-probe ()
  (let* ((labels '("capability" "warrant" "claim" "certificate" "receipt"
                   "authority"))
         (record
           (make-record-datum
            (loop for label in labels
                  collect
                  (make-record-entry (qid '("profile") label)
                                     (make-string-datum "inert")))))
         (document (encode-exact record))
         (readtable (copy-readtable nil)))
    (set-macro-character
     #\!
     (lambda (stream character)
       (declare (ignore stream character))
       (incf *activation-calls*)
       (error "qualification inert reader hook invoked"))
     nil readtable)
    (let ((*readtable* readtable)
          (*package* (find-package :keyword)))
      (let ((decoded
              (call-with-activation-guards
               (lambda () (decode-exact document)))))
        (qcheck (record-datum-p decoded)
                "privileged-looking bytes did not decode to an inert record")
        (qcheck (search "record{" (render-diagnostic decoded) :test #'char=)
                "privileged-looking record diagnostic changed family")))
    (qcheck (zerop *activation-calls*) "privileged-looking record activated a hook")))

(defun concurrency-probe (mode)
  (let* ((thread-count (if (string= mode "small") 4 8))
         (iterations (if (string= mode "small") 32 128))
         (datum
           (make-record-datum
            (list
             (make-record-entry
              (qid '("concurrency") "payload")
              (make-sequence-datum
               (list (make-integer-datum 1) (make-string-datum "x")))))))
         (baseline (octets-to-hex (encode-exact datum)))
         (threads
           (loop repeat thread-count
                 collect
                 (sb-thread:make-thread
                  (lambda ()
                    (handler-case
                        (progn
                          (loop repeat iterations
                                do
                                (qcheck
                                 (string= (octets-to-hex (encode-exact datum))
                                          baseline)
                                 "concurrent encode changed identity")
                                (qcheck
                                 (equal-datum datum datum)
                                 "concurrent read changed equality"))
                          t)
                      (condition (condition) condition)))))))
    (dolist (thread threads)
      (let ((result (sb-thread:join-thread thread)))
        (when (typep result 'condition) (error result))
        (qcheck (eq result t) "concurrency worker did not complete")))
    (* thread-count iterations)))

(defun deep-equality-probe (depth)
  (labels ((chain (leaf)
             (loop repeat depth
                   do (setf leaf (make-sequence-datum (vector leaf)))
                   finally (return leaf))))
    (let ((left (chain (make-unit-datum)))
          (right (chain (make-unit-datum)))
          (unequal (chain (make-boolean-datum nil))))
      (qcheck (equal-datum left right) "deep equality rejected equal values")
      (qcheck (not (equal-datum left unequal))
              "deep equality accepted unequal values"))))

(defun resource-probe ()
  (let ((small (copy-resource-budget (default-resource-budget)
                                     :id "qualification-input-5"
                                     :max-input-octets 5)))
    (expected-failure
     (lambda () (decode-exact (hex-to-octets "4c5043440000") :budget small))
     "ResourceRefusal" "ExcessiveInputLength" "input-budget")
    (qcheck (unit-datum-p (decode-exact (hex-to-octets "4c5043440000")))
            "resource retry failed")))

(defun qualification-main ()
  (setf *activation-calls* 0)
  (let* ((mode (or (sb-ext:posix-getenv "CD0_QUALIFICATION_MODE") "default"))
         (deep-count (if (string= mode "small") 1000 5000))
         (mutation-count (mutation-probes))
         (identity (ambient-identity))
         (concurrent-encodes (concurrency-probe mode)))
    (host-shape-probes)
    (inert-probe)
    (deep-equality-probe deep-count)
    (resource-probe)
    (qcheck (zerop *activation-calls*) "ambient activation counter is nonzero")
    (format t
            "{\"activation_calls\":~D,\"activation_entry_points_guarded\":8,\"ambient_state_variants\":1,\"concurrent_read_encode_pairs\":~D,\"deep_equality_depth\":~D,\"host_cycle_refusals\":1,\"identity_hex\":\"~A\",\"implementation\":\"common-lisp\",\"inert_records\":1,\"mutation_probes\":~D,\"namespace_distinctions\":1,\"resource_refusal_retries\":1,\"shared_acyclic_acceptances\":1,\"status\":\"PASS\"}~%"
            *activation-calls* concurrent-encodes deep-count identity
            mutation-count)))

(handler-case
    (progn
      (qualification-main)
      (sb-ext:exit :code 0))
  (condition (condition)
    (format *error-output* "CD/0 Common Lisp qualification probe: FAIL~%~A~%"
            condition)
    (sb-debug:print-backtrace :stream *error-output* :count 30)
    (sb-ext:exit :code 1)))
