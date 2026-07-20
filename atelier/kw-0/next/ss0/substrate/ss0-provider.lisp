;;;; ss0-provider.lisp — SS-0 deterministic provider fixture, CL side.
;;;; Owns an EXTERNAL WORLD: provider.log (its durable record, NOT yours)
;;;; and per-attempt receipt files. Deterministic function of (tag,
;;;; attempt-id, seed). The provider does NOT deduplicate: dispatching the
;;;; same effect twice executes it twice. It interprets none of your records.
(in-package #:ss0)
(export '(provider-dispatch))

(defun %world-append (run-dir line)
  (with-open-file (s (merge-pathnames "provider.log" run-dir)
                     :direction :output :if-exists :append
                     :if-does-not-exist :create)
    (write-line line s)))

(defun %receipt (run-dir attempt-id label outcome)
  (with-open-file (s (merge-pathnames (format nil "receipt-~A.txt" attempt-id)
                                      run-dir)
                     :direction :output :if-exists :supersede
                     :if-does-not-exist :create)
    (format s "PROVIDER RECEIPT~%effect: ~A~%attempt: ~A~%outcome: ~A~%"
            label attempt-id outcome)))

(defun %digest (label attempt-id seed)
  (crc32-hex (sb-ext:string-to-octets
              (format nil "~A|~A|~A" seed label attempt-id)
              :external-format :utf-8)))

(defun provider-dispatch (run-dir tag attempt-id &key (seed "ss0"))
  "Dispatch TAG on behalf of ATTEMPT-ID. Returns a plist describing what
   the provider did in ITS world. Tags:
     effect:<label>     irreversible execution; logs + receipt (outcome executed)
     effect-ne:<label>  durably records received-but-NOT-executed; receipt says so
     complete:<text>    returns payload text
     empty              returns empty payload (present-and-empty)
     invalid            returns bytes failing any reasonable parser
     slow:<n>           chunked stream of N deterministic chunks"
  (flet ((pref (p) (and (> (length tag) (length p))
                        (string= (subseq tag 0 (length p)) p))))
    (cond
      ((pref "effect:")
       (let ((label (subseq tag 7)))
         (%world-append run-dir (format nil "EXECUTED effect=~A attempt=~A digest=~A"
                                        label attempt-id (%digest label attempt-id seed)))
         (%receipt run-dir attempt-id label "executed")
         (list :status :executed :label label)))
      ((pref "effect-ne:")
       (let ((label (subseq tag 10)))
         (%world-append run-dir (format nil "RECEIVED-NOT-EXECUTED effect=~A attempt=~A"
                                        label attempt-id))
         (%receipt run-dir attempt-id label "not-executed")
         (list :status :not-executed :label label)))
      ((pref "complete:")
       (list :status :payload :payload (subseq tag 9)))
      ((string= tag "empty") (list :status :payload :payload ""))
      ((string= tag "invalid")
       (list :status :payload :payload (format nil "~CNOT-VALID~C" #\Nul #\Nul)))
      ((pref "slow:")
       (list :status :stream :chunks (parse-integer (subseq tag 5))
             :chunk-fn (lambda (i) (format nil "chunk-~D-of-~A" i attempt-id))))
      (t (list :status :unknown-tag)))))
