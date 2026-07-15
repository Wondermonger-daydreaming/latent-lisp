(load "mneme/lci0/common-lisp/load.lisp")

(in-package #:cl-user)

(defparameter *lci0-host-probe-source*
  (let ((envelope (lisp-plus-lci0::registry-datum
                   "claim-id.file-alpha-neutral")))
    (lisp-plus-lci0::make-lci-record
     (list "identity-policy"
           (lisp-plus-lci0::record-field-named envelope "identity-policy"))
     (list "claim-profile"
           (lisp-plus-lci0::record-field-named envelope "claim-profile"))
     (list "proposition"
           (lisp-plus-lci0::record-field-named envelope "proposition"))
     (list "location"
           (lisp-plus-lci0::record-field-named envelope "location")))))

(define-condition lci0-host-ambient-access (error)
  ((entry-point :initarg :entry-point :reader lci0-host-entry-point)))

(defun lci0-denied-entry-point (name)
  (lambda (&rest arguments)
    (declare (ignore arguments))
    (error 'lci0-host-ambient-access :entry-point name)))

(defun lci0-call-with-denied-filesystem-and-clock (thunk)
  (let* ((symbols (list 'cl:open 'cl:probe-file 'cl:truename
                        'cl:get-universal-time))
         (originals (mapcar #'symbol-function symbols)))
    (unwind-protect
         (progn
           (sb-ext:without-package-locks
             (loop for symbol in symbols
                   do (setf (symbol-function symbol)
                            (lci0-denied-entry-point symbol))))
           ;; Self-tests prove the interception is live before projection.
           (dolist (probe (list (lambda () (open #P"/denied"))
                                (lambda () (probe-file #P"/denied"))
                                (lambda () (truename #P"/denied"))
                                (lambda () (get-universal-time))))
             (handler-case
                 (progn (funcall probe)
                        (error "ambient denial self-test did not signal"))
               (lci0-host-ambient-access () nil)))
           (funcall thunk))
      (sb-ext:without-package-locks
        (loop for symbol in symbols
              for original in originals
              do (setf (symbol-function symbol) original))))))

(defun lci0-host-probe-project (source)
  (let ((projected (lisp-plus-lci0:project-claim-id source)))
    (lisp-plus-lci0::octets-to-hex
     (lisp-plus-cd0:canonical-octets projected))))

(defun lci0-host-probe-adapter-result (text)
  (handler-case
      (progn
        (lisp-plus-lci0::fixture-json-to-datum
         (lisp-plus-lci0::parse-json text))
        "accepted")
    (lisp-plus-lci0:lci-failure (condition)
      (lisp-plus-lci0:lci-failure-code condition))
    (lisp-plus-lci0::lci-internal-integrity-failure (condition)
      (lisp-plus-lci0::lci-internal-integrity-failure-code condition))))

(defun lci0-host-probe-rational-results ()
  (mapcar #'lci0-host-probe-adapter-result
          '("{\"t\":\"rat\",\"num\":\"1\",\"den\":\"2\"}"
            "{\"t\":\"rat\",\"num\":\"2\",\"den\":\"4\"}"
            "{\"t\":\"rat\",\"num\":\"1\",\"den\":\"-2\"}"
            "{\"t\":\"rat\",\"num\":\"0\",\"den\":\"2\"}"
            "{\"t\":\"rat\",\"num\":\"1\",\"den\":\"1\"}")))

(defun lci0-host-probe-run-profile (profile thunk)
  (cond
    ((string= profile "package")
     (let ((package (make-package
                     (symbol-name (gensym "LCI0-HOST-PROBE-")) :use '(#:cl))))
       (unwind-protect
            (let ((*package* package)) (funcall thunk))
         (delete-package package))))
    ((string= profile "printer")
     (let ((*print-base* 16) (*print-radix* t) (*print-case* :downcase)
           (*print-pretty* t) (*print-level* 2) (*print-length* 3)
           (*print-readably* nil))
       (funcall thunk)))
    ((string= profile "readtable")
     (let ((*readtable* (copy-readtable nil)))
       (set-macro-character #\! (lambda (stream character)
                                  (declare (ignore stream character)) :poison))
       (funcall thunk)))
    ((string= profile "hash-insertion")
     (let ((table (make-hash-table :test #'equal)))
       (dolist (key '("z" "a" "m" "b" "y"))
         (setf (gethash key table) key))
       (funcall thunk)))
    ((string= profile "unavailable-io-clock")
     (let ((*default-pathname-defaults* #P"/definitely-unavailable-lci0/"))
       (lci0-call-with-denied-filesystem-and-clock thunk)))
    (t (funcall thunk))))

(let* ((profile (or (sb-ext:posix-getenv "LCI0_HOST_PROFILE") "baseline"))
       (cases-text (or (sb-ext:posix-getenv "LCI0_PROPERTY_CASES") "1"))
       (cases (parse-integer cases-text))
       (baseline (lci0-host-probe-project *lci0-host-probe-source*))
       (observed nil))
  (dotimes (index cases)
    (declare (ignore index))
    (push (lci0-host-probe-run-profile
           profile (lambda ()
                     (lci0-host-probe-project *lci0-host-probe-source*)))
          observed))
  (unless (and (every (lambda (value) (string= value baseline)) observed)
               (lisp-plus-lci0:run-mutation-snapshot-test))
    (error "LCI/0 Common Lisp host probe changed projection"))
  (lisp-plus-lci0::write-json-value
   (list (cons "cases" cases)
         (cons "filesystem_denial"
               (if (string= profile "unavailable-io-clock")
                   "unavailable default pathname during projection"
                   "not selected in this profile"))
         (cons "network_denial"
               (if (string= profile "unavailable-io-clock")
                   "no socket package/system loaded; procedural boundary only"
                   "not selected in this profile"))
         (cons "profile" profile)
         (cons "projection_canonical_hex" baseline)
         (cons "rational_adapter_results"
               (lci0-host-probe-rational-results))
         (cons "source_mutation_snapshot" :json-true)
         (cons "unique_projection_values" 1)
         (cons "wall_clock"
               (if (string= profile "unavailable-io-clock")
                   "CL get-universal-time replaced with signalling denial during projection"
                   "not selected in this profile")))
   *standard-output*)
  (terpri))
