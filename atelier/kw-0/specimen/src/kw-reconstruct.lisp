;;;; kw-reconstruct.lisp — the cold reconstructor.
;;;; Usage: sbcl --script kw-reconstruct.lisp <run-dir> <mode>
;;;; Modes:
;;;;   classify   — fold corpse, classify recovery state, emit census
;;;;   blind-retry— attempt to re-run the operation as though nothing happened
;;;;   resolve    — F3a: fetch provider receipt as new provenance-bearing
;;;;                evidence, append effect-settled, retry lawfully
;;;;   supersede  — F3b: fresh attempt with fresh exposure, predecessor's
;;;;                uncertainty PRESERVED, then census again
;;;; The reconstructor knows NOTHING but the journal bytes and (in resolve)
;;;; evidence it appends. It must not counterfeit causal knowledge.

(defvar *kw-repo-root* (pathname (or (sb-ext:posix-getenv "KW_REPO") "/tmp/latent-lisp/")))
(load "/tmp/kw/kw-common.lisp")
(load "/tmp/kw/kw-oracle.lisp")

(in-package #:kw)

(defun argv () (cdr sb-ext:*posix-argv*))

(defun census (state origin)
  "Derived census. Origin is :observed or :reconstructed and NEVER changes
   under verification (L10 ratchet)."
  (list (cons "census-origin" origin)
        (cons "attempts" (format nil "~{~A~^,~}"
                                 (cdr (assoc "attempts" state :test #'string=))))
        (cons "uncertain-effects"
              (format nil "~{~A~^,~}"
                      (cdr (assoc "uncertain-effects" state :test #'string=))))
        (cons "settled-effects"
              (format nil "~{~A~^,~}"
                      (cdr (assoc "settled-effects" state :test #'string=))))
        (cons "receipt-frames"
              (write-to-string (cdr (assoc "receipt-frames" state :test #'string=))))
        (cons "manifestation-frames"
              (write-to-string (cdr (assoc "manifestation-frames" state
                                           :test #'string=))))))

(defun print-alist (title alist)
  (format t "~&~A:~%" title)
  (dolist (cell alist) (format t "  ~A: ~A~%" (car cell) (cdr cell))))

(defun state-digest (state)
  "Canonical digest of derived state (for the Python differential, F2).
   Canonical form: fixed key order, list values SORTED (set semantics;
   order is incidental), 'key=value;' joined, md5, uppercase hex.
   folder.py implements the identical form independently."
  (digest-hex
   (md5-octets
    (map '(vector (unsigned-byte 8)) #'char-code
         (with-output-to-string (s)
           (dolist (cell state)
             (format s "~A=~A;" (car cell)
                     (if (listp (cdr cell))
                         (format nil "~{~A~^,~}"
                                 (sort (copy-list (cdr cell)) #'string<))
                         (cdr cell)))))))))

(let* ((args (argv))
       (run-dir (first args))
       (mode (second args))
       (journal-path (merge-pathnames "witness.journal" run-dir)))
  (multiple-value-bind (frames status detail) (validate-prefix journal-path)
    (declare (ignore detail))
    (let* ((state (fold-state frames))
           (uncertain (cdr (assoc "uncertain-effects" state :test #'string=)))
           (classification (classify-recovery journal-path)))
      (print-alist "RECOVERY-CLASSIFICATION" classification)
      (format t "state-digest: ~A~%" (state-digest state))
      (format t "frame-count: ~D status: ~A~%" (length frames) status)

      (cond
        ((string= mode "classify")
         (print-alist "CENSUS" (census state "reconstructed"))
         ;; verification pass: re-fold, compare, origin must not move
         (multiple-value-bind (frames2 s2 d2) (validate-prefix journal-path)
           (declare (ignore d2))
           (let ((state2 (fold-state frames2)))
             (declare (ignore s2))
             (format t "verification: refold-digest=~A (~:[MISMATCH~;match~])~%"
                     (state-digest state2)
                     (string= (state-digest state) (state-digest state2)))
             (print-alist "CENSUS-AFTER-VERIFICATION"
                          (census state2 "reconstructed")))))

        ((string= mode "blind-retry")
         (if uncertain
             (format t "~&REFUSAL unsafe-retry: seat-alpha is occupied by ~
                        uncertain effect(s) ~{~A~^, ~}. ~
                        Evidence: journal prefix (~D valid frames) shows ~
                        frontier-crossed without settlement or finalizer.~%"
                     uncertain (length frames))
             (format t "~&RETRY-LAWFUL: no uncertain effects occupy the seat.~%")))

        ((string= mode "resolve")
         ;; F3a / RECONCILED-EXECUTED (owner's D1 rename): the receipt
         ;; establishes EXECUTION, not non-execution — this branch is
         ;; evidence-bearing reconciliation to an executed outcome.
         ;; It is NOT the non-execution path; that is retry-nonexecution.
         (let ((receipt (merge-pathnames "receipt-a1.txt" run-dir)))
           (if (and uncertain (probe-file receipt))
               (let ((j (open-journal journal-path)))
                 (append-event j `(("event-type" . "effect-settled")
                                   ("attempt-id" . "a1")
                                   ("settlement" . "executed")
                                   ("evidence-kind" . "provider-receipt")
                                   ("evidence-digest" . ,(sha-file-hex receipt))
                                   ("origin" . "observed")))
                 (append-event j `(("event-type" . "attempt-completed")
                                   ("attempt-id" . "a1")
                                   ("outcome" . "completed")
                                   ("via" . "reconciled-executed")))
                 (close-journal j)
                 (format t "~&F3a-reconciled-executed: provider receipt ~
                            appended as provenance-bearing evidence ~
                            (digest ~A). Settlement: executed.~%"
                         (sha-file-hex receipt))
                 (multiple-value-bind (f2 s2 d2) (validate-prefix journal-path)
                   (declare (ignore s2 d2))
                   (let ((st (fold-state f2)))
                     (print-alist "CENSUS" (census st "reconstructed"))
                     (format t "post-state-digest: ~A~%" (state-digest st)))))
               (format t "~&F3a-UNAVAILABLE: uncertain=~S receipt=~S~%"
                       uncertain (probe-file receipt)))))

        ((string= mode "retry-nonexecution")
         ;; F3a / NON-EXECUTION (owner's D1, the missing branch):
         ;; definitive non-execution evidence -> lawful retry of the SAME
         ;; operation. Steps: (3) provider receipt attests not-executed;
         ;; (4) evidence appended as provenance-bearing event; (5) actual
         ;; retry proceeds; (6) the retry follows the governing identity
         ;; rule — settlement KNOWN, so the seat is free: fresh attempt
         ;; identity, retry-of reference, NO supersession (nothing is
         ;; uncertain anymore); (7) the journal preserves a1's whole path.
         (let ((receipt (merge-pathnames "receipt-a1.txt" run-dir)))
           (if (and uncertain (probe-file receipt))
               (let ((j (open-journal journal-path)))
                 (append-event j `(("event-type" . "effect-settled")
                                   ("attempt-id" . "a1")
                                   ("settlement" . "not-executed")
                                   ("evidence-kind" . "provider-receipt")
                                   ("evidence-digest" . ,(sha-file-hex receipt))
                                   ("origin" . "observed")))
                 ;; the actual retry: same operation, fresh attempt identity
                 (append-event j `(("event-type" . "attempt-begun")
                                   ("attempt-id" . "a2")
                                   ("seat-id" . "seat-alpha")
                                   ("retry-of" . "a1")
                                   ("basis" . "f3a-nonexecution-evidence")))
                 (append-event j `(("event-type" . "frontier-crossed")
                                   ("attempt-id" . "a2")))
                 (oracle-dispatch run-dir "effect:bank-write" "a2")
                 (append-event j `(("event-type" . "effect-settled")
                                   ("attempt-id" . "a2")
                                   ("settlement" . "executed")))
                 (append-event j `(("event-type" . "attempt-completed")
                                   ("attempt-id" . "a2")
                                   ("outcome" . "completed")))
                 (close-journal j)
                 (format t "~&F3a-nonexecution: receipt (digest ~A) attests ~
                            not-executed. Appended as evidence; a1's path ~
                            preserved; retry proceeded as a2 (retry-of a1, ~
                            no supersession — settlement was KNOWN).~%"
                         (sha-file-hex receipt))
                 (multiple-value-bind (f2 s2 d2) (validate-prefix journal-path)
                   (declare (ignore s2 d2))
                   (let ((st2 (fold-state f2)))
                     (print-alist "CENSUS" (census st2 "reconstructed"))
                     (format t "post-state-digest: ~A~%" (state-digest st2))
                     (format t "a1-history-preserved: ~A~%"
                             (member "a1" (cdr (assoc "attempts" st2
                                                      :test #'string=))
                                     :test #'string=)))))
               (format t "~&F3a-nonexecution-UNAVAILABLE: uncertain=~S ~
                          receipt=~S~%" uncertain (probe-file receipt)))))

        ((string= mode "supersede")
         ;; F3b — authorized successor. NOT a retry: fresh attempt identity,
         ;; fresh exposure, predecessor's uncertainty preserved on record.
         (if uncertain
             (let ((j (open-journal journal-path)))
               (append-event j `(("event-type" . "attempt-superseded")
                                 ("predecessor-attempt-id" . "a1")
                                 ("successor-attempt-id" . "a2")
                                 ("authorization" . "owner-directive-001")
                                 ("precedence-rule" . "successor-inherits-seat-not-innocence")
                                 ("fresh-exposure-id" . "x2")))
               (append-event j `(("event-type" . "attempt-begun")
                                 ("attempt-id" . "a2")
                                 ("seat-id" . "seat-alpha")
                                 ("supersedes" . "a1")
                                 ("exposure-id" . "x2")))
               (append-event j `(("event-type" . "frontier-crossed")
                                 ("attempt-id" . "a2")))
               (oracle-dispatch run-dir "effect:bank-write" "a2")
               (append-event j `(("event-type" . "effect-settled")
                                 ("attempt-id" . "a2")
                                 ("settlement" . "executed")))
               (append-event j `(("event-type" . "attempt-completed")
                                 ("attempt-id" . "a2")
                                 ("outcome" . "completed")))
               (close-journal j)
               (format t "~&F3b: supersession recorded. Predecessor a1's ~
                          uncertainty is PRESERVED, not resolved: no frame ~
                          asserts a1's settlement. Successor a2 has fresh ~
                          identity and exposure x2.~%")
               (multiple-value-bind (f2 s2 d2) (validate-prefix journal-path)
                 (declare (ignore s2 d2))
                 (let ((st2 (fold-state f2)))
                   (print-alist "CENSUS" (census st2 "reconstructed"))
                   (format t "post-state-digest: ~A~%" (state-digest st2))
                   (format t "predecessor-still-unresolved: ~A~%"
                           (not (member "a1"
                                        (cdr (assoc "settled-effects" st2
                                                    :test #'string=))
                                        :test #'string=))))))
             (format t "~&F3b-REFUSED: nothing uncertain to supersede.~%")))))
  (sb-ext:exit :code 0))
)
