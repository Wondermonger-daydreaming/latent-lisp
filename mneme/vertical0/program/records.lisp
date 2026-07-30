;;;; records.lisp — vertical event envelopes, event readers, and the
;;;; vertical typed conditions.
;;;;
;;;; Three event namespaces share the one campaign journal:
;;;;   cap2 events      — journaled by Capability /2's own public calls
;;;;                      (event-id namespace "cap2-event").
;;;;   ap0 events       — Adapter /0 membrane records wrapped in the
;;;;                      de-membrana-loquente envelope (event-id
;;;;                      namespace "ap0-event", kind "ap0-record:<k>",
;;;;                      origin "asserted" — AP-JRN-1: the adapter's
;;;;                      narrative of its own conduct is testimony).
;;;;   vertical events  — this lane's own records (refusals, custody
;;;;                      bindings, closures, consumptions, census,
;;;;                      campaign-complete; event-id namespace
;;;;                      "vertical-event", kind "vertical-record:<k>",
;;;;                      origin "asserted": the program's account of its
;;;;                      own conduct, never promoted to observation).
;;;;
;;;; No record built here carries wall-clock, PID, random pathname, host
;;;; address, or directory-enumeration order: every identity derives from
;;;; declared configuration labels (contract §16).
;;;;
;;;; — FABER-MORTIS (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-vertical0)

;;; ---------------------------------------------------------------------------
;;; Vertical typed conditions (contract §15: planned vertical predicates).

(define-condition vertical-condition (error)
  ((detail :initarg :detail :initform nil :reader vertical-condition-detail))
  (:report (lambda (condition stream)
             (format stream "~a: ~a" (type-of condition)
                     (vertical-condition-detail condition)))))

(define-condition budget-ceiling-exceeded (vertical-condition)
  ((seat :initarg :seat :reader budget-ceiling-exceeded-seat)
   (ceiling :initarg :ceiling :reader budget-ceiling-exceeded-ceiling)
   (spent :initarg :spent :reader budget-ceiling-exceeded-spent)
   (estimate :initarg :estimate :reader budget-ceiling-exceeded-estimate))
  (:documentation
   "Contract §8: the pre-frontier budget refusal.  Signaled BEFORE any
frontier when fold(spent) + declared-estimate would exceed the declared
ceiling.  Typed, pre-frontier, journals nothing itself — the campaign
journals the refusal record."))

(define-condition stream-resume-would-duplicate (vertical-condition)
  ((seat :initarg :seat :reader stream-resume-seat)
   (chunks-preserved :initarg :chunks-preserved
                     :reader stream-resume-chunks-preserved))
  (:documentation
   "Contract §5 W2 / §15: resuming a partial stream from chunk zero would
duplicate the journaled chunk custody.  The typed refusal behind the
:partial-stream-resumption :refused policy."))

(define-condition vertical-unresumable-seat (vertical-condition)
  ((seat :initarg :seat :reader vertical-unresumable-seat-seat))
  (:documentation
   "Defensive: a seat found in a durable state no declared route can
lawfully resume (e.g. a full-clean seat interrupted where no pause is
declared).  Unreachable under any lawful schedule; refusing is the honest
behavior if it is ever reached."))

;;; ---------------------------------------------------------------------------
;;; CD/0 shorthands (build-side).

(defun v-id (&rest segments) (identifier-from-segments segments))
(defun v-str (string) (lisp-plus-cd0:make-string-datum string))
(defun v-int (value) (lisp-plus-cd0:make-integer-datum value))
(defun v-seq (elements) (lisp-plus-cd0:make-sequence-datum elements))

(defun v-rec (&rest field-specs)
  "FIELD-SPECS is alternating (segments-list datum)."
  (lisp-plus-cd0:make-record-datum
   (loop for (segments datum) on field-specs by #'cddr
         collect (lisp-plus-cd0:make-record-entry
                  (identifier-from-segments segments)
                  datum))))

;;; ---------------------------------------------------------------------------
;;; Event envelopes.

(defun ap0-event (event-name kind-leaf ap0-record)
  "The de-membrana-loquente AP0 event envelope: origin ASSERTED
(AP-JRN-1)."
  (v-rec '("event" "event-id") (v-id "ap0-event" event-name)
         '("event" "kind") (v-id "ap0-record" kind-leaf)
         '("event" "origin") (v-id "origin" "asserted")
         '("event" "body") ap0-record))

(defun vertical-event (event-name kind-leaf body-record)
  "The vertical event envelope: origin ASSERTED (the program's account of
its own conduct — testimony, never observation)."
  (v-rec '("event" "event-id") (v-id "vertical-event" event-name)
         '("event" "kind") (v-id "vertical-record" kind-leaf)
         '("event" "origin") (v-id "origin" "asserted")
         '("event" "body") body-record))

;;; ---------------------------------------------------------------------------
;;; Event readers (fold-side; shared by budget, census, interpretation).

(defun event-kind-string (event)
  (let ((kind (record-field event "event" "kind")))
    (and kind (lisp-plus-cd0:identifier-datum-p kind)
         (identifier-segment-string kind))))

(defun event-id-string (event)
  (let ((id (record-field event "event" "event-id")))
    (and id (lisp-plus-cd0:identifier-datum-p id)
         (identifier-segment-string id))))

(defun event-body (event)
  (record-field event "event" "body"))

(defun body-string (body namespace name)
  (let ((field (record-field body namespace name)))
    (cond ((null field) nil)
          ((lisp-plus-cd0:string-datum-p field)
           (lisp-plus-cd0:string-datum-value field))
          ((lisp-plus-cd0:identifier-datum-p field)
           (identifier-segment-string field))
          (t nil))))

(defun body-integer (body namespace name)
  (let ((field (record-field body namespace name)))
    (and field (lisp-plus-cd0:integer-datum-p field)
         (lisp-plus-cd0:integer-datum-value field))))

(defun validated-events (store)
  "The validated prefix's events as a list, oldest first."
  (let* ((report (validate-journal store))
         (events (prefix-report-events report)))
    (unless (eq :valid (prefix-report-status report))
      (error "validated-events: store did not validate :valid (~a)"
             (prefix-report-status report)))
    (loop for index below (fill-pointer events)
          collect (aref events index))))

(defun find-event (events &key kind event-id (test #'string=))
  "First event matching KIND and/or EVENT-ID (both segment strings)."
  (find-if (lambda (event)
             (and (or (null kind)
                      (funcall test kind (event-kind-string event)))
                  (or (null event-id)
                      (funcall test event-id (event-id-string event)))))
           events))

(defun collect-events (events &key kind kind-prefix)
  (remove-if-not
   (lambda (event)
     (let ((event-kind (event-kind-string event)))
       (and event-kind
            (or (null kind) (string= kind event-kind))
            (or (null kind-prefix)
                (and (>= (length event-kind) (length kind-prefix))
                     (string= kind-prefix event-kind
                              :end2 (length kind-prefix)))))))
   events))

;;; CD/0 exact-number extraction (Erratum 0.1 qere consumption).

(defun canonical-amount-rational (datum)
  "A CD/0 integer or rational datum as a CL exact rational."
  (cond ((lisp-plus-cd0:integer-datum-p datum)
         (lisp-plus-cd0:integer-datum-value datum))
        ((lisp-plus-cd0:rational-datum-p datum)
         (/ (lisp-plus-cd0:rational-datum-numerator datum)
            (lisp-plus-cd0:rational-datum-denominator datum)))
        (t (error "canonical-amount-rational: not a CD/0 number datum: ~s"
                  datum))))

(defun parse-lexeme-rational (lexeme)
  "Parse LEXEME through Adapter /0's public narrow grammar (never the CL
reader) and return a CL exact rational."
  (canonical-amount-rational (parse-cost-lexeme lexeme)))
