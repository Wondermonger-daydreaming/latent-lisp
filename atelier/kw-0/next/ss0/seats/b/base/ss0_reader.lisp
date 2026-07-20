;;;; ss0_reader.lisp — independent second-language reader for SS-0.
(load (merge-pathnames "substrate/ss0-substrate.lisp" *load-truename*))
(in-package #:ss0)

(defun get-val (key record)
  (let ((cell (assoc key record :test #'string=)))
    (if cell (cdr cell) nil)))

(defun payload-crc (s)
  (crc32-hex (sb-ext:string-to-octets (or s "") :external-format :utf-8)))

(defun read-all-records (run-dir)
  (multiple-value-bind (payloads status) (store-read-prefix run-dir)
    (values (mapcar #'ser-decode payloads) status)))

(defun ensure-op (ops op)
  (unless (gethash op ops)
    (setf (gethash op ops)
          (list :op op :state "unknown" :derived "true" :label "-" :regime "-"
                :payload-crc "-" :outcome "-" :outcome-durable "-"
                :outcome-payload-crc "-" :evidence "-" :successor "-"
                :chunks '() :lineage "-" :tag "-" :attempt "-"))))

(defun compute-ops (records)
  (let ((ops (make-hash-table :test 'equal)))
    (dolist (r records)
      (let ((op (get-val "op" r))
            (ty (get-val "t" r)))
        (when op
          (ensure-op ops op)
          (let ((pl (gethash op ops)))
            (cond
              ((string= ty "intent")
               (setf (getf pl :state) "attempted"
                     (getf pl :label) (or (get-val "label" r) "-")
                     (getf pl :regime) (or (get-val "regime" r) "-")
                     (getf pl :payload-crc) (payload-crc (get-val "payload" r))
                     (getf pl :attempt) (or (get-val "attempt" r) "-")
                     (getf pl :lineage) (or (get-val "lineage" r) "-")
                     (getf pl :derived) "false"))
              ((string= ty "dispatch")
               (setf (getf pl :state) "dispatched"
                     (getf pl :tag) (or (get-val "tag" r) "-")))
              ((string= ty "outcome")
               (setf (getf pl :state) "outcome-recorded"
                     (getf pl :outcome) (or (get-val "status" r) "-")
                     (getf pl :outcome-durable) (if (get-val "durable" r) "true" "false")
                     (getf pl :derived) "false")
               (when (assoc "payload" r :test #'string=)
                 (setf (getf pl :outcome-payload-crc)
                       (payload-crc (get-val "payload" r)))))
              ((string= ty "receipt")
               (setf (getf pl :state) "receipt-resolved"
                     (getf pl :outcome) (or (get-val "outcome" r) "-")
                     (getf pl :evidence) (or (get-val "provenance" r) "-")
                     (getf pl :derived) "false"))
              ((string= ty "complete")
               (setf (getf pl :state) "completed"
                     (getf pl :derived) "false"))
              ((string= ty "successor")
               (setf (getf pl :successor) (or (get-val "succ" r) "-")))
              ((string= ty "chunk")
               (let ((idx (get-val "idx" r)))
                 (when (integerp idx)
                   (push idx (getf pl :chunks))))))
            (setf (gethash op ops) pl)))))
    (let ((out '()))
      (maphash (lambda (k pl)
                 (declare (ignore k))
                 (when (getf pl :chunks)
                   (setf (getf pl :chunks)
                         (sort (delete-duplicates (getf pl :chunks)) #'<)))
                 (when (string= (getf pl :state) "dispatched")
                   (setf (getf pl :state) "unresolved"
                         (getf pl :derived) "true"))
                 (when (string= (getf pl :state) "unknown")
                   (setf (getf pl :derived) "true"))
                 (push pl out))
               ops)
      (sort out #'string< :key (lambda (pl) (getf pl :op))))))

(defun chunks-string (pl)
  (let ((chs (getf pl :chunks)))
    (if chs (format nil "~{~A~^,~}" chs) "-")))

(defun digest-line (pl)
  (format nil "~A|~A|~A|~A|~A|~A|~A|~A|~A|~A|~A|~A|~A"
          (getf pl :op) (getf pl :label) (getf pl :state) (getf pl :regime)
          (getf pl :payload-crc) (getf pl :outcome) (getf pl :outcome-durable)
          (getf pl :outcome-payload-crc) (getf pl :evidence)
          (getf pl :successor) (chunks-string pl) (getf pl :lineage)
          (getf pl :derived)))

(defun canonical-digest (ops)
  (crc32-hex (sb-ext:string-to-octets
              (format nil "~{~A~^~%~}" (mapcar #'digest-line ops))
              :external-format :utf-8)))

(defun main ()
  (let* ((args (cdr sb-ext:*posix-argv*))
         (run-dir (pathname (first args))))
    (multiple-value-bind (records status) (read-all-records run-dir)
      (let ((ops (compute-ops records)))
        (format t "RECOVERY REPORT (CL)~%")
        (format t "tail: ~A~%" (string-downcase (symbol-name status)))
        (format t "records: ~A~%" (length records))
        (dolist (pl ops)
          (format t "op=~A label=~A state=~A regime=~A payload_crc=~A outcome=~A outcome_durable=~A outcome_payload_crc=~A evidence=~A successor=~A chunks=~A lineage=~A derived=~A tag=~A~%"
                  (getf pl :op) (getf pl :label) (getf pl :state)
                  (getf pl :regime) (getf pl :payload-crc) (getf pl :outcome)
                  (getf pl :outcome-durable) (getf pl :outcome-payload-crc)
                  (getf pl :evidence) (getf pl :successor)
                  (chunks-string pl) (getf pl :lineage)
                  (getf pl :derived) (getf pl :tag)))
        (format t "digest: ~A~%" (canonical-digest ops))))))

(main)
