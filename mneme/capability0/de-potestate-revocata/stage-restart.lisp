;;;; stage-restart.lisp — the REDIVIVUS: a genuinely new process.
;;;;
;;;; Launched by run-specimen.lisp as a separate `sbcl --script` invocation
;;;; AFTER the first life has exited.  Its entire admissible input is:
;;;;
;;;;   (1) the DURABLE BYTES of the store directory named in argv,
;;;;   (2) the DURABLE BYTES of the preserved receipt file named in argv,
;;;;   (3) DECLARED CONFIGURATION — specimen-common.lisp: the fixed nonce,
;;;;       durability, bootstrap issuer, the store identity DERIVED from
;;;;       that configuration, and the declared charge.
;;;;
;;;; It has no access to the dead process's memory, inherits no ledger, no
;;;; receipt object, no fold, and takes no operator testimony about what
;;;; happened.  Everything it asserts about authority it derives by folding
;;;; the validated prefix, and it says so: origin :reconstructed, never
;;;; :observed.
;;;;
;;;; Governing sentence: history may prove that authority once existed;
;;;; only the validated present prefix can say whether it remains live.
;;;;
;;;; Output protocol (parsed and renumbered by the parent runner):
;;;;   CHECK ok|FAIL <label> · NOTE <text> · RESULT: <n> checks, <f> failures
;;;; Exit 0 iff zero failures.  No pid, timestamp, or path is printed.
;;;;
;;;; — CLAVIGER (Claude Fable 5 subagent), 2026-07-29

(load (merge-pathnames "specimen-common.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-capability0)

(defvar *r-checks* 0)
(defvar *r-failures* 0)

(defun rcheck (label thunk)
  (incf *r-checks*)
  (let ((label (format nil label))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "CHECK ok ~a~%" label)
        (progn (incf *r-failures*)
               (format t "CHECK FAIL ~a~@[ (~a)~]~%" label
                       (when (consp outcome) (second outcome)))))))

(defun rnote (control &rest arguments)
  (format t "NOTE ~a~%" (apply #'format nil control arguments)))

;;; Negative control hook: a child invocation dies HERE, mid-run, before
;;; any verdict and before the RESULT sentinel.
(when (sb-posix:getenv "DE_POTESTATE_DIE")
  (rnote "child control: dying mid-restart before any verdict (planted)")
  (sb-ext:exit :code 3))

;;; ---------------------------------------------------------------------------
;;; Admissible inputs.

(defvar *arguments* (rest sb-ext:*posix-argv*))
(defvar *store-directory* (pathname (first *arguments*)))
(defvar *receipt-path* (pathname (second *arguments*)))

(rnote "redivivus: durable bytes + declared configuration only; no dead ~
        process memory, no inherited receipt object, no operator testimony")

(defvar *events-sha-before*
  (sha256-hex (sp-read-octets (merge-pathnames "EVENTS.pj0"
                                               *store-directory*))))

;;; 1. Open the surviving store; the identity check is against DECLARED
;;;    configuration, not against anything the dead process said.

(defvar *store* nil)

(rcheck "the surviving store opens and its derived identity EQUALS the ~
         identity derived from the declared configuration alone — the ~
         restart trusts config + bytes, never testimony"
  (lambda ()
    (setf *store* (open-store *store-directory*))
    (and (journal-store-p *store*)
         (string= (journal-store-store-id *store*) (expected-store-id)))))

(defvar *bootstrap* (specimen-bootstrap))
(defvar *report* (validate-journal *store*))

(rcheck "the validated prefix is exactly what the bytes say: :valid, 3 ~
         frames, every byte inside the prefix, no tail"
  (lambda ()
    (and (eq :valid (prefix-report-status *report*))
         (= 3 (prefix-report-frame-count *report*))
         (null (prefix-report-tail-sha256 *report*)))))

;;; 2. The reconstructed refusal — the same verdict, derived from bytes
;;;    alone by a mind that never held the authority.

(defvar *reconstructed-refusal*
  (charged-query *store* *bootstrap* "q-restart" :origin :reconstructed))

(rcheck "IDENTICAL REFUSAL, reconstructed: the fold over durable bytes ~
         alone answers :refused capability-revoked, naming the SAME grant ~
         event (g-001) and the SAME revoking event (r-001) the first life ~
         saw — fold-derived, not remembered"
  (lambda ()
    (and (eq :refused (receipt-decision *reconstructed-refusal*))
         (string= "capability-revoked"
                  (receipt-reason *reconstructed-refusal*))
         (datum= (record-field *reconstructed-refusal* "receipt"
                               "grant-event-id")
                 (identifier-from-segments '("cap0-event" "g-001")))
         (datum= (record-field *reconstructed-refusal* "receipt"
                               "revoking-event-id")
                 (identifier-from-segments '("cap0-event" "r-001"))))))

(rcheck "the reconstructed refusal says WHAT IT IS: origin renders ~
         (id \"origin\" \"reconstructed\") and the receipt bytes contain ~
         no occurrence of \"observed\" (L10/L15: storage integrity never ~
         upgrades epistemic origin)"
  (lambda ()
    (and (string= "origin:reconstructed"
                  (identifier-segment-string
                   (record-field *reconstructed-refusal* "receipt"
                                 "origin")))
         (null (search "observed"
                       (sp-octets-string
                        (encode-pjs0 *reconstructed-refusal*)))))))

(rnote "reconstructed refusal: capability-revoked · grant cap0-event:g-001 ~
        · revoking cap0-event:r-001 · bound to terminal ~a"
       (prefix-report-terminal-digest *report*))

;;; 3. The preserved receipt: still truthful about P, no longer a key.

(defvar *receipt-octets* (sp-read-octets *receipt-path*))
(defvar *old-receipt* (decode-pjs0 *receipt-octets*))

(rcheck "the preserved receipt DECODES canonically from its durable bytes ~
         (decode-pjs0 status :canonical) and reads back decision ~
         :authorized bound to terminal ordinal 1"
  (lambda ()
    (multiple-value-bind (datum status) (decode-pjs0 *receipt-octets*)
      (and datum (eq :canonical status)
           (eq :authorized (receipt-decision datum))
           (= 1 (lisp-plus-cd0:integer-datum-value
                 (record-field datum "receipt" "terminal-ordinal")))))))

(rcheck "the old receipt is STILL TRUTHFUL about prefix P: its bound ~
         terminal digest IS the store's frame-1 digest, in the surviving ~
         chain, today — 'authorized relative to validated prefix P' did ~
         not become false; it became PAST"
  (lambda ()
    (string= (lisp-plus-cd0:string-datum-value
              (record-field *old-receipt* "receipt" "terminal-digest"))
             (aref (prefix-report-frame-digests *report*) 0))))

(rcheck "presenting the old receipt as PRESENT authority is refused with ~
         CAP0-STALE-RECEIPT naming BOTH prefixes: the receipt's binding ~
         (ordinal 1) and the present validated prefix (ordinal 3), digests ~
         distinct, the present digest equal to the fresh report's — ~
         history proves authority existed; it is not live authority"
  (lambda ()
    (handler-case
        (progn (present-receipt-as-present-authority *store* *bootstrap*
                                                     *old-receipt*)
               nil)
      (cap0-stale-receipt (condition)
        (and (eql 1 (cap0-stale-receipt-receipt-terminal-ordinal condition))
             (eql 3 (cap0-stale-receipt-present-terminal-ordinal condition))
             (not (string= (cap0-stale-receipt-receipt-terminal-digest
                            condition)
                           (cap0-stale-receipt-present-terminal-digest
                            condition)))
             (string= (cap0-stale-receipt-present-terminal-digest condition)
                      (prefix-report-terminal-digest *report*)))))))

;;; 4. The restart changed nothing.

(rcheck "the restart WROTE NOTHING: EVENTS.pj0 is byte-identical (sha256) ~
         after the whole reconstruction, refusal, and stale-receipt ~
         presentation — recognizing (or refusing) authority executes no ~
         effect and appends no frame"
  (lambda ()
    (string= *events-sha-before*
             (sha256-hex (sp-read-octets
                          (merge-pathnames "EVENTS.pj0"
                                           *store-directory*))))))

;;; ---------------------------------------------------------------------------

(format t "RESULT: ~a checks, ~a failures~%" *r-checks* *r-failures*)
(sb-ext:exit :code (if (zerop *r-failures*) 0 1))
