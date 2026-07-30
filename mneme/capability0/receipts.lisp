;;;; receipts.lisp — receipts bound to the exact validated prefix.
;;;;
;;;; Both receipt kinds (authorization, refusal) bind to, at minimum:
;;;; journal identity (store-id) · validated terminal ordinal AND valid byte
;;;; count · terminal digest (the content-derived validated-prefix identity)
;;;; · capability identity · query identity · decision · reason · procedure
;;;; identity/version.  NEVER merely a human label, git commit, pathname, or
;;;; process-local object.  A receipt is rendered as a canonical CD/0 record
;;;; (PJ-S/0 encodable) so later code can DECODE it and DETECT that it
;;;; concerns an older prefix (RECEIPT-CURRENT-P).
;;;;
;;;; Receipts are DERIVED artifacts: they are written to disk as canonical
;;;; bytes by callers who want them preserved, but they are never journaled
;;;; — appending a derived receipt would dress derived state as a primary
;;;; fact (architecture L9).
;;;;
;;;; — CLAVIGER (Claude Fable 5 subagent), 2026-07-29

(in-package #:lisp-plus-capability0)

(defvar +procedure-id-segments+ '("lisp-plus-capability0"
                                  "query-live-authority"))
(defvar +procedure-version+ 0)

(defun %origin-identifier (origin)
  "The caller-side epistemic-origin facet (journal0's PJ-APP-4 precedent).
Only :LIVE-QUERY and :RECONSTRUCTED exist.  :OBSERVED is not a member of
this ecase ON PURPOSE: a fold-derived answer can never be an observation
(laws L10, L15) — passing it is a caller error, refused here in code."
  (ecase origin
    (:live-query (identifier-from-segments '("origin" "live-query")))
    (:reconstructed (identifier-from-segments '("origin" "reconstructed")))))

(defun make-authority-receipt (&key store report decision reason
                                    capability-id query-id
                                    subject action resource scope
                                    grant-event-id revoking-event-id
                                    mismatched-terms
                                    dangling-revocation-event-ids
                                    (origin :live-query)
                                    defect)
  "Construct the CD/0 receipt record for one authority-query occurrence.
DECISION is :authorized | :refused; REASON is a string from the closed
cap0-reason vocabulary.  REPORT is the SAME prefix-report the fold used —
one validation feeds both the decision and the binding, so there is no gap
between what was examined and what the receipt claims was examined.
DEFECT :receipt-unbound-to-prefix is the PLANTED mutant: it binds the
receipt to the empty (genesis) prefix instead — plausible-looking, wrong,
and killed by the binding comparison in mutants.lisp."
  (let* ((unbound (eq defect :receipt-unbound-to-prefix))
         (terminal-ordinal (if unbound 0 (prefix-report-frame-count report)))
         (valid-bytes (if unbound 0 (prefix-report-valid-byte-count report)))
         (terminal-digest (if unbound
                              +genesis-digest-hex+
                              (prefix-report-terminal-digest report)))
         (entries
           (list
            (%field '("receipt" "kind")
                    (identifier-from-segments
                     (list "cap0" (ecase decision
                                    (:authorized "authorization")
                                    (:refused "refusal")))))
            (%field '("receipt" "decision")
                    (identifier-from-segments
                     (list "cap0" (ecase decision
                                    (:authorized "authorized")
                                    (:refused "refused")))))
            (%field '("receipt" "reason")
                    (identifier-from-segments (list "cap0-reason" reason)))
            (%field '("receipt" "store-id")
                    (lisp-plus-cd0:make-string-datum
                     (journal-store-store-id store)))
            (%field '("receipt" "terminal-ordinal")
                    (lisp-plus-cd0:make-integer-datum terminal-ordinal))
            (%field '("receipt" "valid-byte-count")
                    (lisp-plus-cd0:make-integer-datum valid-bytes))
            (%field '("receipt" "terminal-digest")
                    (lisp-plus-cd0:make-string-datum terminal-digest))
            (%field '("receipt" "capability-id")
                    (ensure-identifier capability-id :what "capability-id"))
            (%field '("receipt" "query-id")
                    (ensure-identifier query-id :what "query-id"))
            (%field '("receipt" "procedure-id")
                    (identifier-from-segments +procedure-id-segments+))
            (%field '("receipt" "procedure-version")
                    (lisp-plus-cd0:make-integer-datum +procedure-version+))
            (%field '("receipt" "origin") (%origin-identifier origin)))))
    ;; Queried terms (present whenever the caller named them).
    (loop for (name value) in (list (list "subject" subject)
                                    (list "action" action)
                                    (list "resource" resource)
                                    (list "scope" scope))
          when value
            do (push (%field (list "receipt" name)
                             (ensure-identifier value :what name))
                     entries))
    ;; Evidence facets.
    (when grant-event-id
      (push (%field '("receipt" "grant-event-id") grant-event-id) entries))
    (when revoking-event-id
      (push (%field '("receipt" "revoking-event-id") revoking-event-id)
            entries))
    (when mismatched-terms
      (push (%field '("receipt" "mismatched-terms")
                    (lisp-plus-cd0:make-sequence-datum
                     (mapcar #'lisp-plus-cd0:make-string-datum
                             mismatched-terms)))
            entries))
    (when dangling-revocation-event-ids
      (push (%field '("receipt" "dangling-revocation-event-ids")
                    (lisp-plus-cd0:make-sequence-datum
                     dangling-revocation-event-ids))
            entries))
    ;; Law 9: over a torn tail the answer derives from the valid prefix AND
    ;; the excluded tail is surfaced, never hidden.
    (when (and (not unbound) (eq (prefix-report-status report) :torn-tail))
      (push (%field '("receipt" "tail-offset")
                    (lisp-plus-cd0:make-integer-datum
                     (prefix-report-tail-offset report)))
            entries)
      (push (%field '("receipt" "tail-sha256")
                    (lisp-plus-cd0:make-string-datum
                     (prefix-report-tail-sha256 report)))
            entries))
    (lisp-plus-cd0:make-record-datum (reverse entries))))

;;; ---------------------------------------------------------------------------
;;; Reading receipts back.

(defun %identifier-field-string (receipt namespace name)
  (let ((value (record-field receipt namespace name)))
    (and value (lisp-plus-cd0:identifier-datum-p value)
         (identifier-segment-string value))))

(defun receipt-decision (receipt)
  "The receipt's decision as a keyword: :AUTHORIZED | :REFUSED | NIL."
  (let ((decision (%identifier-field-string receipt "receipt" "decision")))
    (cond ((equal decision "cap0:authorized") :authorized)
          ((equal decision "cap0:refused") :refused)
          (t nil))))

(defun receipt-reason (receipt)
  "The receipt's reason as a string from the cap0-reason vocabulary, or NIL."
  (let ((reason (record-field receipt "receipt" "reason")))
    (and reason (lisp-plus-cd0:identifier-datum-p reason)
         (let ((segments (identifier-segments reason)))
           (and (equal (first segments) "cap0-reason")
                (format nil "~{~a~^:~}" (rest segments)))))))

(defun receipt-mismatched-terms (receipt)
  "The mismatched term names on a scope-mismatch refusal, as strings."
  (let ((terms (record-field receipt "receipt" "mismatched-terms")))
    (when (and terms (lisp-plus-cd0:sequence-datum-p terms))
      (loop for index below (lisp-plus-cd0:sequence-datum-length terms)
            for element = (lisp-plus-cd0:sequence-datum-ref terms index)
            when (lisp-plus-cd0:string-datum-p element)
              collect (lisp-plus-cd0:string-datum-value element)))))

(defun %receipt-binding (receipt)
  "The receipt's validated-prefix binding: (values store-id ordinal
byte-count digest), each NIL when absent or mistyped."
  (let ((store-id (record-field receipt "receipt" "store-id"))
        (ordinal (record-field receipt "receipt" "terminal-ordinal"))
        (bytes (record-field receipt "receipt" "valid-byte-count"))
        (digest (record-field receipt "receipt" "terminal-digest")))
    (values (and store-id (lisp-plus-cd0:string-datum-p store-id)
                 (lisp-plus-cd0:string-datum-value store-id))
            (and ordinal (lisp-plus-cd0:integer-datum-p ordinal)
                 (lisp-plus-cd0:integer-datum-value ordinal))
            (and bytes (lisp-plus-cd0:integer-datum-p bytes)
                 (lisp-plus-cd0:integer-datum-value bytes))
            (and digest (lisp-plus-cd0:string-datum-p digest)
                 (lisp-plus-cd0:string-datum-value digest)))))

(defun receipt-current-p (receipt report &key store-id)
  "Does RECEIPT's validated-prefix binding name EXACTLY the prefix REPORT
describes (for the store identified by STORE-ID)?  Returns
(values current-p mismatched-facet-names).  This is the detection the whole
lane exists for: a receipt that fails here is testimony about an older
prefix, never present authority."
  (multiple-value-bind (r-store r-ordinal r-bytes r-digest)
      (%receipt-binding receipt)
    (let ((mismatches '()))
      (unless (and r-store store-id (string= r-store store-id))
        (push "store-id" mismatches))
      (unless (and r-ordinal
                   (= r-ordinal (prefix-report-frame-count report)))
        (push "terminal-ordinal" mismatches))
      (unless (and r-bytes
                   (= r-bytes (prefix-report-valid-byte-count report)))
        (push "valid-byte-count" mismatches))
      (unless (and r-digest
                   (string= r-digest (prefix-report-terminal-digest report)))
        (push "terminal-digest" mismatches))
      (values (null mismatches) (nreverse mismatches)))))
