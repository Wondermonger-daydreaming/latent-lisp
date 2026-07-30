;;;; events.lisp — the journaled effect-event shapes and the standing fold.
;;;;
;;;; BYTE GRAMMAR, CONSUMED NOT RE-MINTED: the shapes below copy the PJ0
;;;; fixture grammar for effect events (the frozen corpus exhibit
;;;; mneme/architecture/process-journal-0/fixtures/crash-windows/
;;;; cw3-full-synced-receipt-lost.pj0): every event carries the standard
;;;; envelope (event:attempt · event:body · event:capture-boundary ·
;;;; event:capture-mechanism · event:event-id · event:kind · event:origin ·
;;;; event:process-id · event:recorder-principal · event:subject-principal)
;;;; and the bodies mirror the fixture's field sets:
;;;;
;;;;   (id "attempt" "prepared")         {attempt-id, effect-set,
;;;;                                      idempotency-id, seat-id}
;;;;   (id "attempt" "frontier-crossed") {attempt-id, external-request-id,
;;;;                                      frontier}
;;;;   (id "request" "acknowledged")     {acknowledgment class + adapter +
;;;;                                      identities + evidence when held}
;;;;   (id "effect" "settled")           {attempt-id, external-request-id,
;;;;                                      effect-id, evidence}
;;;;   (id "effect" "uncertain")         {uncertain-effect-id, attempt-id,
;;;;                                      external-request-id, known-facts,
;;;;                                      possible-effects,
;;;;                                      reconciliation-procedure,
;;;;                                      retry-policy}  — §10.8 verbatim
;;;;   (id "attempt" "reconciled")       {target-attempt-id, procedure +
;;;;                                      version, evidence, previous and
;;;;                                      resulting effect values,
;;;;                                      resolution, uncertain-effect-id,
;;;;                                      unresolved-residue}  — §14.2
;;;;
;;;; WHAT IS JOURNALED AND WHAT IS NOT (house adjudication, /0's L9 and
;;;; /1's §2.10 carried forward): queries and receipts are NEVER journaled
;;;; — they are derived state over a validated prefix.  Attempt, effect,
;;;; and reconciliation EVENTS are journaled — they are primary facts whose
;;;; absence would erase the §14.1 prohibition the journal exists to carry.
;;;; Preflight refusals journal NOTHING: a refusal is pre-frontier, its
;;;; external effect is :not-entered, and it is re-derivable from the same
;;;; prefix that produced it.
;;;;
;;;; NO STORED RESOLVED FLAG (PJ0 §16, AP-CRASH-1): no event below carries
;;;; any resolvedness field; resolvedness is derived by the fold, every
;;;; time, from the event sequence alone.
;;;;
;;;; — CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-capability2)

(defvar +effect-kind-segments+ '("effect" "external-write")
  "The one declared effect kind of this lane (§10.1 vocabulary member
:external-write; the adapter's cell write is also honestly a :tool-action —
the declaration names the primary class; see the RETURN).")
(defvar +effect-class-segments+ '("effect-class" "irreversible")
  "§10.2 class of the declared effect: the request-ledger append cannot be
unmade and no compensation machinery exists in this lane.")
(defvar +frontier-segments+ '("frontier" "world-dispatch"))
(defvar +reconciliation-procedure-segments+
  '("reconciliation" "cap2-world-request-lookup" "0"))

(defun %cap2-field (segments value)
  (lisp-plus-cd0:make-record-entry (identifier-from-segments segments)
                                   value))

(defun %cap2-record (&rest entries)
  (lisp-plus-cd0:make-record-datum (remove nil entries)))

(defun %event-envelope (&key event-name kind-segments attempt-id process-name
                             body)
  "The standard journal0 event envelope, per the PJ0 fixture grammar."
  (%cap2-record
   (%cap2-field '("event" "attempt")
                (or attempt-id (lisp-plus-cd0:make-unit-datum)))
   (%cap2-field '("event" "body") body)
   (%cap2-field '("event" "capture-boundary")
                (identifier-from-segments '("boundary" "kernel-transition")))
   (%cap2-field '("event" "capture-mechanism")
                (identifier-from-segments
                 '("witness" "kernel-mediated-journal")))
   (%cap2-field '("event" "event-id")
                (identifier-from-segments (list "cap2-event" event-name)))
   (%cap2-field '("event" "kind") (identifier-from-segments kind-segments))
   (%cap2-field '("event" "origin")
                (identifier-from-segments '("origin" "observed")))
   (%cap2-field '("event" "process-id")
                (identifier-from-segments (list "process" process-name)))
   (%cap2-field '("event" "recorder-principal")
                (identifier-from-segments '("principal" "kernel-store")))
   (%cap2-field '("event" "subject-principal")
                (identifier-from-segments (list "principal" process-name)))))

(defun %attempt-identifier (attempt-name)
  (identifier-from-segments (list "attempt" attempt-name)))

(defun %seat-identifier (seat-name)
  (identifier-from-segments (list "seat" seat-name)))

(defun %external-request-identifier (attempt-name)
  "The external request identity, derived deterministically from the
declared attempt name (declared charge, not clock or randomness)."
  (identifier-from-segments (list "external-request" "cap2" attempt-name)))

(defun make-attempt-prepared-event (&key attempt-name seat-name process-name)
  (%event-envelope
   :event-name (format nil "e-~a-prepared" attempt-name)
   :kind-segments '("attempt" "prepared")
   :attempt-id (%attempt-identifier attempt-name)
   :process-name process-name
   :body (%cap2-record
          (%cap2-field '("attempt" "attempt-id")
                       (%attempt-identifier attempt-name))
          (%cap2-field '("attempt" "effect-set")
                       (lisp-plus-cd0:make-sequence-datum
                        (list (identifier-from-segments
                               +effect-kind-segments+))))
          (%cap2-field '("attempt" "effect-class")
                       (identifier-from-segments +effect-class-segments+))
          (%cap2-field '("attempt" "idempotency-id")
                       (identifier-from-segments
                        (list "idempotency" "cap2" attempt-name)))
          (%cap2-field '("attempt" "seat-id")
                       (%seat-identifier seat-name)))))

(defun make-frontier-crossed-event (&key attempt-name process-name)
  (%event-envelope
   :event-name (format nil "e-~a-frontier" attempt-name)
   :kind-segments '("attempt" "frontier-crossed")
   :attempt-id (%attempt-identifier attempt-name)
   :process-name process-name
   :body (%cap2-record
          (%cap2-field '("attempt" "attempt-id")
                       (%attempt-identifier attempt-name))
          (%cap2-field '("attempt" "external-request-id")
                       (%external-request-identifier attempt-name))
          (%cap2-field '("attempt" "frontier")
                       (identifier-from-segments +frontier-segments+)))))

(defun make-acknowledged-event (&key attempt-name process-name class
                                     ledger-entry-sha cells-sha)
  "The acknowledgment as journaled testimony.  AP-ACK-4 is structural here:
this event carries a class and (when the adapter held it) evidence — and
NOTHING in the fold treats it as settlement."
  (%event-envelope
   :event-name (format nil "e-~a-ack" attempt-name)
   :kind-segments '("request" "acknowledged")
   :attempt-id (%attempt-identifier attempt-name)
   :process-name process-name
   :body (apply
          #'%cap2-record
          (append
           (list
            (%cap2-field '("ack" "acknowledgment-class")
                         (identifier-from-segments
                          (list "ack" (string-downcase (symbol-name class)))))
            (%cap2-field '("ack" "adapter")
                         (identifier-from-segments +world-adapter-segments+))
            (%cap2-field '("ack" "attempt-id")
                         (%attempt-identifier attempt-name))
            (%cap2-field '("ack" "external-request-id")
                         (%external-request-identifier attempt-name)))
           (when ledger-entry-sha
             (list (%cap2-field '("ack" "ledger-entry-sha256")
                                (lisp-plus-cd0:make-string-datum
                                 ledger-entry-sha))))
           (when cells-sha
             (list (%cap2-field '("ack" "cells-sha256")
                                (lisp-plus-cd0:make-string-datum
                                 cells-sha))))))))

(defun make-effect-settled-event (&key attempt-name process-name
                                       evidence-segments)
  "EVIDENCE-SEGMENTS: a non-empty list of segment lists naming the durable
evidence the settlement derivation verified (never the bare acknowledgment
class)."
  (%event-envelope
   :event-name (format nil "e-~a-settled" attempt-name)
   :kind-segments '("effect" "settled")
   :attempt-id (%attempt-identifier attempt-name)
   :process-name process-name
   :body (%cap2-record
          (%cap2-field '("effect" "attempt-id")
                       (%attempt-identifier attempt-name))
          (%cap2-field '("effect" "effect-id")
                       (identifier-from-segments +effect-kind-segments+))
          (%cap2-field '("effect" "evidence")
                       (lisp-plus-cd0:make-sequence-datum
                        (mapcar #'identifier-from-segments
                                evidence-segments)))
          (%cap2-field '("effect" "external-request-id")
                       (%external-request-identifier attempt-name)))))

(defun make-effect-uncertain-event (&key attempt-name process-name
                                         known-fact-segments)
  "The §10.8 record as journaled bytes — the PJ0 fixture grammar verbatim:
uncertain-effect-id, attempt-id, external-request-id, known-facts,
possible-effects, reconciliation-procedure, retry-policy (the UNC-1 default,
:forbidden-without-reconciliation).  No resolvedness field exists."
  (%event-envelope
   :event-name (format nil "e-~a-uncertain" attempt-name)
   :kind-segments '("effect" "uncertain")
   :attempt-id (%attempt-identifier attempt-name)
   :process-name process-name
   :body (%cap2-record
          (%cap2-field '("effect" "attempt-id")
                       (%attempt-identifier attempt-name))
          (%cap2-field '("effect" "external-request-id")
                       (%external-request-identifier attempt-name))
          (%cap2-field '("effect" "known-facts")
                       (lisp-plus-cd0:make-sequence-datum
                        (mapcar #'identifier-from-segments
                                known-fact-segments)))
          (%cap2-field '("effect" "possible-effects")
                       (lisp-plus-cd0:make-sequence-datum
                        (list (identifier-from-segments
                               '("effect-state" "cell-written"))
                              (identifier-from-segments
                               '("effect-state" "cell-not-written")))))
          (%cap2-field '("effect" "reconciliation-procedure")
                       (identifier-from-segments
                        +reconciliation-procedure-segments+))
          (%cap2-field '("effect" "retry-policy")
                       (identifier-from-segments
                        '("retry" "forbidden-without-reconciliation")))
          (%cap2-field '("effect" "uncertain-effect-id")
                       (identifier-from-segments
                        (list "uncertain-effect" "cap2" attempt-name))))))

(defun make-attempt-reconciled-event (&key attempt-name process-name
                                           resolution evidence-segments)
  "§14.2: the reconciliation appends; it never rewrites.  RESOLUTION is
:applied or :not-applied — the direction the evidence established; in both
directions the resulting external-effect standing is SETTLED-WITH-EVIDENCE
(§10.3 progression → SETTLED; the direction lives here, in the record)."
  (%event-envelope
   :event-name (format nil "e-~a-reconciled" attempt-name)
   :kind-segments '("attempt" "reconciled")
   :attempt-id (%attempt-identifier attempt-name)
   :process-name process-name
   :body (%cap2-record
          (%cap2-field '("reconciliation" "evidence")
                       (lisp-plus-cd0:make-sequence-datum
                        (mapcar #'identifier-from-segments
                                evidence-segments)))
          (%cap2-field '("reconciliation" "previous-effect-value")
                       (identifier-from-segments '("effect-value" "bounded")))
          (%cap2-field '("reconciliation" "procedure")
                       (identifier-from-segments
                        +reconciliation-procedure-segments+))
          (%cap2-field '("reconciliation" "procedure-version")
                       (lisp-plus-cd0:make-integer-datum 0))
          (%cap2-field '("reconciliation" "resolution")
                       (identifier-from-segments
                        (list "resolution"
                              (string-downcase (symbol-name resolution)))))
          (%cap2-field '("reconciliation" "resulting-effect-value")
                       (identifier-from-segments '("effect-value" "settled")))
          (%cap2-field '("reconciliation" "target-attempt-id")
                       (%attempt-identifier attempt-name))
          (%cap2-field '("reconciliation" "uncertain-effect-id")
                       (identifier-from-segments
                        (list "uncertain-effect" "cap2" attempt-name)))
          (%cap2-field '("reconciliation" "unresolved-residue")
                       (lisp-plus-cd0:make-sequence-datum '())))))

;;; ---------------------------------------------------------------------------
;;; The standing fold — resolvedness derived from bytes, every time.

(defun %event-kind-string (event)
  (let ((kind (record-field event "event" "kind")))
    (and kind (lisp-plus-cd0:identifier-datum-p kind)
         (identifier-segment-string kind))))

(defun %event-attempt-name (event)
  "The attempt name (final segment) of the event's attempt identity, or NIL."
  (let ((attempt (record-field event "event" "attempt")))
    (when (and attempt (lisp-plus-cd0:identifier-datum-p attempt))
      (let ((segments (identifier-segments attempt)))
        (car (last segments))))))

(defun derive-effect-standing (store attempt-name)
  "Fold the validated prefix and derive the named attempt's effect
standing.  Returns (values standing details) where STANDING is one of
:absent · :prepared-only · :crossed-unsettled · :uncertain-unresolved ·
:settled · :reconciled, and DETAILS is a plist carrying the stored events
found (:prepared :crossed :acknowledged :settled :uncertain :reconciled).
PJ-FOLD-1 is structural here: nothing in this derivation consults clocks,
file ages, process liveness, or any stored flag — only the event sequence."
  (let ((report (validate-journal store))
        (prepared nil) (crossed nil) (acknowledged nil)
        (settled nil) (uncertain nil) (reconciled nil))
    (let ((events (prefix-report-events report)))
      (loop for index below (fill-pointer events)
            for event = (aref events index)
            for kind = (%event-kind-string event)
            when (equal (%event-attempt-name event) attempt-name)
              do (cond ((equal kind "attempt:prepared") (setf prepared event))
                       ((equal kind "attempt:frontier-crossed")
                        (setf crossed event))
                       ((equal kind "request:acknowledged")
                        (setf acknowledged event))
                       ((equal kind "effect:settled") (setf settled event))
                       ((equal kind "effect:uncertain")
                        (setf uncertain event))
                       ((equal kind "attempt:reconciled")
                        (setf reconciled event)))))
    (values
     (cond (reconciled :reconciled)
           (settled :settled)
           (uncertain :uncertain-unresolved)
           (crossed :crossed-unsettled)
           (prepared :prepared-only)
           (t :absent))
     (list :prepared prepared :crossed crossed :acknowledged acknowledged
           :settled settled :uncertain uncertain :reconciled reconciled))))
