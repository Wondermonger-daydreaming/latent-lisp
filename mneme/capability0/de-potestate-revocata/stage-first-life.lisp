;;;; stage-first-life.lisp — the PRIMA VITA: the process that holds power
;;;; and loses it, then dies.
;;;;
;;;; Launched by run-specimen.lisp as a separate `sbcl --script` invocation.
;;;; It: creates the declared store · commits the bootstrap-grounded grant ·
;;;; queries live authority at prefix P and PRESERVES the receipt bytes to
;;;; disk · commits an unrelated event (still authorized) · commits the
;;;; matching revocation (governed refusal) · exits.  Its process memory —
;;;; every ledger it folded, every receipt object it held — dies with it.
;;;; Whatever the restart knows, it will know from durable bytes alone.
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

(defvar *v-checks* 0)
(defvar *v-failures* 0)

(defun vcheck (label thunk)
  (incf *v-checks*)
  (let ((label (format nil label))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "CHECK ok ~a~%" label)
        (progn (incf *v-failures*)
               (format t "CHECK FAIL ~a~@[ (~a)~]~%" label
                       (when (consp outcome) (second outcome)))))))

(defun vnote (control &rest arguments)
  (format t "NOTE ~a~%" (apply #'format nil control arguments)))

;;; ---------------------------------------------------------------------------
;;; Admissible inputs: argv paths + the declared configuration.

(defvar *arguments* (rest sb-ext:*posix-argv*))
(defvar *store-directory* (pathname (first *arguments*)))
(defvar *receipt-path* (pathname (second *arguments*)))

(vnote "prima vita: explicit bootstrap · grant · query at P · preserve ~
        receipt · unrelated event · revocation · exit")

;;; 1. The store, created under the DECLARED configuration.

(defvar *store* (create-journal *store-directory*
                                :declared-durability *specimen-durability*
                                :nonce-octets *specimen-nonce*))

(vcheck "the created store's derived identity EQUALS the identity derived ~
         from the declared configuration alone — the bootstrap binding is ~
         config, not a copy off the live store"
  (lambda () (string= (journal-store-store-id *store*)
                      (expected-store-id))))

(defvar *bootstrap* (specimen-bootstrap))

;;; 2. Explicit bootstrap, negative control first: nothing derives without it.

(vcheck "before anything is granted, a query WITHOUT bootstrap authority ~
         refuses with cap0-bootstrap-missing (the no-smuggling proof, run ~
         in the very process that owns every convenience)"
  (lambda ()
    (handler-case (progn (charged-query *store* nil "q-noboot") nil)
      (cap0-bootstrap-missing () t)
      (error () nil))))

;;; 3. The grant.

(defvar *grant-receipt* (append-event *store* (charged-grant)))

(vcheck "the capability grant commits durably through the public append ~
         path: ordinal 1, :newly-committed, declared durability :synced"
  (lambda ()
    (and (eql 1 (append-receipt-ordinal *grant-receipt*))
         (eq :newly-committed (append-receipt-disposition *grant-receipt*))
         (eq :synced (lisp-plus-journal0:journal-store-durability *store*)))))

;;; 4. The query at prefix P, and the receipt preserved as bytes.

(defvar *receipt-at-p* (charged-query *store* *bootstrap* "q-at-p"))
(defvar *report-at-p* (validate-journal *store*))

(vcheck "live authority at prefix P: decision :authorized, reason ~
         grant-live-at-validated-prefix, bound to the EXACT validated ~
         prefix (ordinal 1, byte count and terminal digest of the fresh ~
         report), naming grant event g-001"
  (lambda ()
    (and (eq :authorized (receipt-decision *receipt-at-p*))
         (string= "grant-live-at-validated-prefix"
                  (receipt-reason *receipt-at-p*))
         (receipt-current-p *receipt-at-p* *report-at-p*
                            :store-id (journal-store-store-id *store*))
         (datum= (record-field *receipt-at-p* "receipt" "grant-event-id")
                 (identifier-from-segments '("cap0-event" "g-001"))))))

(sp-write-octets *receipt-path* (encode-pjs0 *receipt-at-p*))

(vcheck "the receipt's canonical bytes are preserved to disk and read back ~
         byte-identical (the artifact the restart will judge)"
  (lambda ()
    (equalp (sp-read-octets *receipt-path*) (encode-pjs0 *receipt-at-p*))))

(vnote "receipt at P: ordinal 1 · terminal ~a · sha256 ~a"
       (prefix-report-terminal-digest *report-at-p*)
       (sha256-hex (encode-pjs0 *receipt-at-p*)))

;;; 5. The unrelated event at P+1.

(append-event *store* (charged-unrelated))

(vcheck "an unrelated committed event does not revoke: at prefix P+1 the ~
         charged query is still :authorized"
  (lambda ()
    (eq :authorized
        (receipt-decision (charged-query *store* *bootstrap* "q-p1")))))

(vcheck "the receipt from P is already DETECTABLY not-current at P+1 ~
         (receipt-current-p false) — staleness begins at the first ~
         committed event after issue, not at revocation"
  (lambda ()
    (not (receipt-current-p *receipt-at-p* (validate-journal *store*)
                            :store-id (journal-store-store-id *store*)))))

;;; 6. The revocation at P+2.

(append-event *store* (charged-revocation))

(vcheck "the explicit revocation commits at ordinal 3 and the query becomes ~
         a governed refusal: :refused capability-revoked, naming BOTH the ~
         historical grant (g-001) and the revoking event (r-001)"
  (lambda ()
    (let ((receipt (charged-query *store* *bootstrap* "q-revoked")))
      (and (eq :refused (receipt-decision receipt))
           (string= "capability-revoked" (receipt-reason receipt))
           (datum= (record-field receipt "receipt" "grant-event-id")
                   (identifier-from-segments '("cap0-event" "g-001")))
           (datum= (record-field receipt "receipt" "revoking-event-id")
                   (identifier-from-segments '("cap0-event" "r-001")))
           (= 3 (prefix-report-frame-count (validate-journal *store*)))))))

(vnote "prefix now: 3 frames · terminal ~a"
       (prefix-report-terminal-digest (validate-journal *store*)))
(vnote "this process now exits; its memory of having been authorized dies ~
        with it")

;;; ---------------------------------------------------------------------------

(format t "RESULT: ~a checks, ~a failures~%" *v-checks* *v-failures*)
(sb-ext:exit :code (if (zerop *v-failures*) 0 1))
