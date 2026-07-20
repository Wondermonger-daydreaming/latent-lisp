;;;; ss0_reader.lisp — independent second-language reader for SS-0.
(load (merge-pathnames "substrate/ss0-substrate.lisp" *load-truename*))
(in-package #:ss0)

; EXTENSION-DELTA-BEGIN (R8 batch support helpers)
(defun split-comma (s)
  (let ((out '())
        (start 0))
    (loop
      (let ((pos (position #\, s :start start)))
        (if pos
            (progn
              (push (subseq s start pos) out)
              (setf start (1+ pos)))
            (progn
              (push (subseq s start) out)
              (return)))))
    (nreverse out)))

(defun parse-int-list (s)
  (if (or (not (stringp s)) (string= s "-"))
      '()
      (loop for tok in (split-comma s)
            when (and (> (length tok) 0) (every #'digit-char-p tok))
            collect (parse-integer tok))))
; EXTENSION-DELTA-END

(defun get-val (key record)
  (let ((cell (assoc key record :test #'string=)))
    (if cell (cdr cell) nil)))

(defun payload-crc (s)
  (crc32-hex (sb-ext:string-to-octets (or s "") :external-format :utf-8)))

(defun read-all-records (run-dir)
  (multiple-value-bind (payloads status) (store-read-prefix run-dir)
    (values (mapcar #'ser-decode payloads) status)))

; EXTENSION-DELTA-BEGIN (batch fields added to op state)
(defun ensure-op (ops op)
  (unless (gethash op ops)
    (setf (gethash op ops)
          (list :op op :state "unknown" :derived "true" :label "-" :regime "-"
                :payload-crc "-" :outcome "-" :outcome-durable "-"
                :outcome-payload-crc "-" :evidence "-" :successor "-"
                :chunks '() :lineage "-" :tag "-" :attempt "-"
                :is-batch nil :legs 0 :legs-census "-"
                :reattempt "-" :abandon "-" :batch "-" :leg "-"))))
; EXTENSION-DELTA-END

; EXTENSION-DELTA-BEGIN (batch leg placeholder constructor)
(defun ensure-leg-placeholder (ops batch-op batch-pl i state derived)
  (let ((lop (format nil "~A-L~D" batch-op i)))
    (unless (gethash lop ops)
      (setf (gethash lop ops)
            (list :op lop :state state :derived derived
                  :label (format nil "~A-L~D" (or (getf batch-pl :label) "-") i)
                  :regime "-" :payload-crc "-" :outcome "-" :outcome-durable "-"
                  :outcome-payload-crc "-" :evidence "-" :successor "-"
                  :chunks '() :lineage "-" :tag "-" :attempt "-"
                  :is-batch nil :legs 0 :legs-census "-"
                  :reattempt "-" :abandon "-" :batch batch-op :leg i)))))
; EXTENSION-DELTA-END

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
                     (getf pl :derived) "false")
               ; EXTENSION-DELTA-BEGIN (leg linkage)
               (when (assoc "batch" r :test #'string=)
                 (setf (getf pl :batch) (get-val "batch" r)))
               (when (assoc "leg" r :test #'string=)
                 (setf (getf pl :leg) (get-val "leg" r)))
               ; EXTENSION-DELTA-END
               )
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
                   (push idx (getf pl :chunks)))))
              ; EXTENSION-DELTA-BEGIN (batch descriptor record)
              ((string= ty "batch")
               (setf (getf pl :state) "batch"
                     (getf pl :is-batch) t
                     (getf pl :label) (or (get-val "label" r) "-")
                     (getf pl :legs) (let ((lv (get-val "legs" r)))
                                       (if (integerp lv) lv 0))
                     (getf pl :attempt) (or (get-val "attempt" r) "-")
                     (getf pl :lineage) (or (get-val "lineage" r) "-")
                     (getf pl :reattempt) (or (get-val "reattempt" r) "-")
                     (getf pl :abandon) (or (get-val "abandon" r) "-")
                     (getf pl :derived) "false"))
              ; EXTENSION-DELTA-END
              )
            (setf (gethash op ops) pl)))))
    (maphash (lambda (k pl)
               (when (getf pl :chunks)
                 (setf (getf pl :chunks)
                       (sort (delete-duplicates (getf pl :chunks)) #'<)))
               (when (string= (getf pl :state) "dispatched")
                 (setf (getf pl :state) "unresolved"
                       (getf pl :derived) "true"))
               (when (string= (getf pl :state) "unknown")
                 (setf (getf pl :derived) "true"))
               (setf (gethash k ops) pl))
             ops)
    ; EXTENSION-DELTA-BEGIN (batch per-leg placeholders and census)
    (let ((batch-specs '()))
      (maphash (lambda (k pl)
                 (when (getf pl :is-batch)
                   (push (cons k pl) batch-specs)))
               ops)
      (dolist (spec batch-specs)
        (let* ((bop (car spec))
               (bpl (gethash bop ops))
               (legs (or (getf bpl :legs) 0))
               (abandon (parse-int-list (or (getf bpl :abandon) "-"))))
          (loop for i from 1 to legs do
            (if (member i abandon)
                (ensure-leg-placeholder ops bop bpl i "abandoned" "false")
                (ensure-leg-placeholder ops bop bpl i "not-started" "true")))
          (let ((parts '()))
            (loop for i from 1 to legs do
              (let* ((lop (format nil "~A-L~D" bop i))
                     (lpl (gethash lop ops))
                     (st (if lpl (or (getf lpl :state) "missing") "missing")))
                (push (format nil "~D:~A" i st) parts)))
            (setf (getf bpl :legs-census)
                  (if parts (format nil "~{~A~^,~}" (nreverse parts)) "-"))
            (setf (gethash bop ops) bpl)))))
    ; EXTENSION-DELTA-END
    (let ((out '()))
      (maphash (lambda (k pl)
                 (declare (ignore k))
                 (push pl out))
               ops)
      (sort out #'string< :key (lambda (pl) (getf pl :op))))))

(defun chunks-string (pl)
  (let ((chs (getf pl :chunks)))
    (if chs (format nil "~{~A~^,~}" chs) "-")))

; EXTENSION-DELTA-BEGIN (digest field 14: legs census)
(defun digest-line (pl)
  (format nil "~A|~A|~A|~A|~A|~A|~A|~A|~A|~A|~A|~A|~A|~A"
          (getf pl :op) (getf pl :label) (getf pl :state) (getf pl :regime)
          (getf pl :payload-crc) (getf pl :outcome) (getf pl :outcome-durable)
          (getf pl :outcome-payload-crc) (getf pl :evidence)
          (getf pl :successor) (chunks-string pl) (getf pl :lineage)
          (getf pl :derived) (or (getf pl :legs-census) "-")))
; EXTENSION-DELTA-END

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
        ; EXTENSION-DELTA-BEGIN (report legs census)
        (dolist (pl ops)
          (format t "op=~A label=~A state=~A regime=~A payload_crc=~A outcome=~A outcome_durable=~A outcome_payload_crc=~A evidence=~A successor=~A chunks=~A lineage=~A derived=~A tag=~A legs=~A~%"
                  (getf pl :op) (getf pl :label) (getf pl :state)
                  (getf pl :regime) (getf pl :payload-crc) (getf pl :outcome)
                  (getf pl :outcome-durable) (getf pl :outcome-payload-crc)
                  (getf pl :evidence) (getf pl :successor)
                  (chunks-string pl) (getf pl :lineage)
                  (getf pl :derived) (getf pl :tag)
                  (or (getf pl :legs-census) "-")))
        ; EXTENSION-DELTA-END
        (format t "digest: ~A~%" (canonical-digest ops))))))

(main)
