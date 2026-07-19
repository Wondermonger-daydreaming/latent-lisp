;;;; kw-oracle.lisp — deterministic fake adapter ("the provider").
;;;; The oracle owns an EXTERNAL WORLD: provider.log (its own durable record,
;;;; NOT the journal) and per-effect receipts. The reconstructor may later
;;;; fetch a receipt as new provenance-bearing evidence (F3a).
;;;; Deterministic: response = f(request content, seed). No randomness.

(in-package #:kw)

(defun oracle-dispatch (run-dir request-tag attempt-id &key (seed "kw-oracle"))
  "Dispatch REQUEST-TAG on behalf of ATTEMPT-ID.
   Returns a plist describing what the provider did in ITS world.
   Tags:
     effect:<label>  — executes an irreversible effect (appends provider.log,
                       writes receipt-<attempt>.txt), returns :executed
     complete:<text> — returns payload text
     empty           — returns empty payload (present-empty specimen)
     invalid         — returns bytes failing the declared parser
     slow:<n>        — streams N chunks with sleeps (mid-stream kill window)"
  (let ((tag request-tag))
    (cond
      ((and (> (length tag) 7) (string= (subseq tag 0 7) "effect:"))
       (let* ((label (subseq tag 7))
              (line (format nil "EXECUTED effect=~A attempt=~A seed-digest=~A~%"
                            label attempt-id
                            (digest-hex (md5-octets
                                         (map '(vector (unsigned-byte 8))
                                              #'char-code
                                              (format nil "~A|~A|~A" seed label attempt-id)))))))
         (with-open-file (s (merge-pathnames "provider.log" run-dir)
                            :direction :output :if-exists :append
                            :if-does-not-exist :create)
           (write-string line s))
         (with-open-file (s (merge-pathnames
                             (format nil "receipt-~A.txt" attempt-id) run-dir)
                            :direction :output :if-exists :supersede
                            :if-does-not-exist :create)
           (format s "PROVIDER RECEIPT~%effect: ~A~%attempt: ~A~%settlement: executed~%"
                   label attempt-id))
         (list :status :executed :label label)))
      ((and (> (length tag) 10) (string= (subseq tag 0 10) "effect-ne:"))
       ;; DEFINITIVE NON-EXECUTION: the provider durably records that the
       ;; effect was RECEIVED but NOT executed, and issues a receipt to that
       ;; effect. This is the F3a evidence class: not-execution, attested.
       (let ((label (subseq tag 10)))
         (with-open-file (s (merge-pathnames "provider.log" run-dir)
                            :direction :output :if-exists :append
                            :if-does-not-exist :create)
           (format s "RECEIVED-NOT-EXECUTED effect=~A attempt=~A~%" label attempt-id))
         (with-open-file (s (merge-pathnames
                             (format nil "receipt-~A.txt" attempt-id) run-dir)
                            :direction :output :if-exists :supersede
                            :if-does-not-exist :create)
           (format s "PROVIDER RECEIPT~%effect: ~A~%attempt: ~A~%settlement: not-executed~%"
                   label attempt-id))
         (list :status :not-executed :label label)))
      ((and (> (length tag) 9) (string= (subseq tag 0 9) "complete:"))
       (list :status :payload :payload (subseq tag 9)))
      ((string= tag "empty") (list :status :payload :payload ""))
      ((string= tag "invalid") (list :status :payload :payload "�NOT-VALID-PAYLOAD�"))
      ((and (> (length tag) 5) (string= (subseq tag 0 5) "slow:"))
       (list :status :stream :chunks (parse-integer (subseq tag 5))))
      (t (list :status :refused))))
  )

(export '(oracle-dispatch) '#:kw)
