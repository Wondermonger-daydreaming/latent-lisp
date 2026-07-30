;;;; query.lisp — the live-authority question, answered fold-first.
;;;;
;;;; QUERY-LIVE-AUTHORITY answers exactly one question: "was authority for
;;;; this capability, under these exact terms, LIVE at the currently
;;;; validated prefix of this journal?"  It executes NO protected effect —
;;;; there is no effect execution anywhere in this slice (law 12); the
;;;; kernel §19.5 reserved verb CHECK-CAPABILITY is deliberately NOT claimed
;;;; (this function implements a strict subset of the §11.4 check: exact
;;;; term equality; no budgets, counts, roles, expiry, or unresolved-effect
;;;; restrictions — see CAPABILITY-0-RETURN.md).
;;;;
;;;; Two refusal classes, split on answerability:
;;;;   RECEIPT refusals (decision :refused) — the question IS answerable
;;;;     relative to a validated prefix, and the truthful answer is no:
;;;;     capability-missing, capability-revoked, capability-scope-mismatch.
;;;;   SIGNALED refusals (typed conditions, no receipt) — the question is
;;;;     not answerable at all: missing/mismatched bootstrap, foreign
;;;;     issuer, interior corruption, stale receipt presented as present
;;;;     authority.  Issuing a decision receipt there would be false
;;;;     testimony about a prefix that was never validly examined.
;;;;
;;;; — CLAVIGER (Claude Fable 5 subagent), 2026-07-29

(in-package #:lisp-plus-capability0)

;;; PLANTED-DEFECT APPARATUS ONLY.  The strict path never reads or writes
;;; this variable (guarded by explicit EQ checks on the defect keyword); it
;;; is the "cached status" the lane's design forbids, kept alive in one
;;; place so the mutant-kill harness can prove the design necessary.
(defvar *mutant-ledger-cache* nil)

(defvar +reason-authorized+ "grant-live-at-validated-prefix")
(defvar +reason-missing+ "capability-missing")
(defvar +reason-revoked+ "capability-revoked")
(defvar +reason-scope-mismatch+ "capability-scope-mismatch")

(defun %term-mismatches (record subject action resource scope)
  "Exact canonical comparison of the four queried terms against the grant's.
Returns the mismatched term names, oldest declaration order, as strings."
  (loop for (name queried granted)
          in (list (list "subject" subject
                         (capability-record-subject record))
                   (list "action" action
                         (capability-record-action record))
                   (list "resource" resource
                         (capability-record-resource record))
                   (list "scope" scope
                         (capability-record-scope record)))
        unless (datum= queried granted)
          collect name))

(defun %dangling-revocation-event-ids (record)
  (loop for disposition in (and record
                                (capability-record-dispositions record))
        when (eq (getf disposition :disposition) :revocation-without-grant)
          collect (getf disposition :event-id)))

(defun query-live-authority (store bootstrap
                             &key capability-id subject action resource scope
                                  query-id (origin :live-query) defect)
  "Answer the live-authority question at the currently validated prefix.
Returns a receipt (authorization or refusal) for every answerable question;
signals a typed condition for every unanswerable one.  All matching is
EXACT canonical CD/0 equality.  ORIGIN is the caller-side epistemic facet
(:live-query | :reconstructed) — a restart derivation MUST pass
:reconstructed (law 11).  DEFECT selects a planted mutant (mutants.lisp);
the strict path is DEFECT = NIL."
  (%check-bootstrap store bootstrap)
  (let ((capability-id (ensure-identifier capability-id
                                          :what "capability-id"))
        (subject (and subject (ensure-identifier subject :what "subject")))
        (action (and action (ensure-identifier action :what "action")))
        (resource (and resource (ensure-identifier resource
                                                   :what "resource")))
        (scope (and scope (ensure-identifier scope :what "scope")))
        (query-id (ensure-identifier query-id :what "query-id")))
    (multiple-value-bind (ledger report)
        ;; PLANTED DEFECT :cached-status — answer a later query from an
        ;; earlier fold's cached ledger, exactly the mutable-status design
        ;; this lane forbids.  The strict path validates and folds afresh on
        ;; EVERY query; there is nothing for it to consult but the journal.
        (if (and (eq defect :cached-status) *mutant-ledger-cache*)
            (values (first *mutant-ledger-cache*)
                    (second *mutant-ledger-cache*))
            (let* ((report (validate-journal store))
                   (ledger (derive-authority-ledger store bootstrap
                                                    :defect defect
                                                    :report report)))
              (when (eq defect :cached-status)
                (setf *mutant-ledger-cache* (list ledger report)))
              (values ledger report)))
      (let ((record (find capability-id (authority-ledger-records ledger)
                          :key #'capability-record-capability-id
                          :test #'datum=)))
        (flet ((receipt (decision reason &rest extras)
                 (apply #'make-authority-receipt
                        :store store :report report
                        :decision decision :reason reason
                        :capability-id capability-id :query-id query-id
                        :subject subject :action action
                        :resource resource :scope scope
                        :origin origin :defect defect
                        extras)))
          (cond
            ;; No grant in the validated prefix (possibly dangling
            ;; revocations — surfaced, since they are the history's answer
            ;; to "why did you think this existed?").
            ((or (null record)
                 (null (capability-record-grant-ordinal record)))
             (receipt :refused +reason-missing+
                      :dangling-revocation-event-ids
                      (%dangling-revocation-event-ids record)))
            ;; Revoked: the refusal names the historical grant AND the
            ;; ORIGINAL revoking event — §11.6's distinction between
            ;; historical validity and current revocation state, executed.
            ((capability-record-revocation-ordinal record)
             (receipt :refused +reason-revoked+
                      :grant-event-id (capability-record-grant-event-id
                                       record)
                      :revoking-event-id
                      (capability-record-revocation-event-id record)))
            ;; Live grant: exact term matching.
            (t
             (let ((mismatches (%term-mismatches record subject action
                                                 resource scope)))
               (if mismatches
                   (receipt :refused +reason-scope-mismatch+
                            :grant-event-id
                            (capability-record-grant-event-id record)
                            :mismatched-terms mismatches)
                   (receipt :authorized +reason-authorized+
                            :grant-event-id
                            (capability-record-grant-event-id record)))))))))))

(defun %event-id-string (identifier)
  (and identifier (lisp-plus-cd0:identifier-datum-p identifier)
       (identifier-segment-string identifier)))

(defun require-live-authority (store bootstrap &rest arguments
                               &key capability-id subject action resource
                                    scope query-id origin)
  "QUERY-LIVE-AUTHORITY, with refusal receipts escalated to kernel /0's
typed conditions: capability-missing, capability-revoked, or
capability-scope-mismatch (offending-field = the first mismatched term).
Returns the authorization receipt on success.  This is the executable form
of the kernel0-condition-reuse preference: the conditions this lane's
refusals raise are the kernel's own exported types."
  (declare (ignorable capability-id subject action resource scope query-id
                      origin))
  (let ((receipt (apply #'query-live-authority store bootstrap arguments)))
    (if (eq (receipt-decision receipt) :authorized)
        receipt
        (let ((reason (receipt-reason receipt)))
          (cond
            ((equal reason +reason-missing+)
             (lisp-plus-kernel0:signal-kernel0
              'lisp-plus-kernel0:capability-missing
              :failed-invariant
              (format nil "no grant for capability ~a in the validated ~
                           prefix [ordinal ~a · terminal ~a]"
                      (%identifier-field-string receipt "receipt"
                                                "capability-id")
                      (nth-value 1 (%receipt-binding receipt))
                      (nth-value 3 (%receipt-binding receipt)))
              :requirement-id "CAP0-QRY-1"))
            ((equal reason +reason-revoked+)
             (lisp-plus-kernel0:signal-kernel0
              'lisp-plus-kernel0:capability-revoked
              :failed-invariant
              (format nil "capability ~a was revoked by event ~a (grant ~a ~
                           remains historical fact; it is not live authority)"
                      (%identifier-field-string receipt "receipt"
                                                "capability-id")
                      (%event-id-string
                       (record-field receipt "receipt" "revoking-event-id"))
                      (%event-id-string
                       (record-field receipt "receipt" "grant-event-id")))
              :requirement-id "CAP0-QRY-2"
              :evidence-ids
              (remove nil
                      (list (%event-id-string
                             (record-field receipt "receipt"
                                           "grant-event-id"))
                            (%event-id-string
                             (record-field receipt "receipt"
                                           "revoking-event-id"))))))
            ((equal reason +reason-scope-mismatch+)
             (lisp-plus-kernel0:signal-kernel0
              'lisp-plus-kernel0:capability-scope-mismatch
              :failed-invariant
              (format nil "queried terms ~a do not match the grant exactly"
                      (receipt-mismatched-terms receipt))
              :requirement-id "CAP0-QRY-3"
              :offending-field (first (receipt-mismatched-terms receipt))))
            (t (error "unreachable: unknown refusal reason ~s" reason)))))))

(defun present-receipt-as-present-authority (store bootstrap receipt
                                             &key query-id)
  "Present a previously issued RECEIPT as PRESENT authority.  The receipt is
NEVER trusted for its decision: if its prefix binding is stale (any facet of
store-id / terminal ordinal / valid byte count / terminal digest differs
from the present validated prefix), signal CAP0-STALE-RECEIPT naming BOTH
prefixes; if the binding is current, the answer is RE-DERIVED by a fresh
fold over the same terms and the FRESH receipt is returned.  Holding the
card proves you HELD it; only the table says whether you hold it."
  (%check-bootstrap store bootstrap)
  (let ((report (validate-journal store)))
    (when (eq (prefix-report-status report) :corruption)
      (lisp-plus-kernel0:signal-kernel0
       'lisp-plus-kernel0:journal-prefix-invalid
       :failed-invariant "the present prefix is invalid; no receipt can be ~
                          checked against it"
       :requirement-id "CAP0-FOLD-2"
       :evidence-ids (list (prefix-report-condition-type report))))
    (multiple-value-bind (currentp mismatches)
        (receipt-current-p receipt report
                           :store-id (journal-store-store-id store))
      (declare (ignorable mismatches))
      (unless currentp
        (multiple-value-bind (r-store r-ordinal r-bytes r-digest)
            (%receipt-binding receipt)
          (error 'cap0-stale-receipt
                 :requirement-id "CAP0-RCPT-2"
                 :detail (format nil "stale facets: ~{~a~^, ~}" mismatches)
                 :receipt-store-id r-store
                 :receipt-terminal-ordinal r-ordinal
                 :receipt-valid-byte-count r-bytes
                 :receipt-terminal-digest r-digest
                 :present-store-id (journal-store-store-id store)
                 :present-terminal-ordinal (prefix-report-frame-count report)
                 :present-valid-byte-count (prefix-report-valid-byte-count
                                            report)
                 :present-terminal-digest (prefix-report-terminal-digest
                                           report))))
      (query-live-authority
       store bootstrap
       :capability-id (record-field receipt "receipt" "capability-id")
       :subject (record-field receipt "receipt" "subject")
       :action (record-field receipt "receipt" "action")
       :resource (record-field receipt "receipt" "resource")
       :scope (record-field receipt "receipt" "scope")
       :query-id (or query-id
                     (record-field receipt "receipt" "query-id"))))))
