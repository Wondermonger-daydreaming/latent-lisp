;;;; rehydrate.lisp — THE LANE'S NOVEL SEAM: durable bytes -> live Kernel /0
;;;; records -> the adopted retry fold.
;;;;
;;;; THE GAP THIS FILE CLOSES, named as such: journal0's own
;;;; PROJECT-KERNEL-EVENTS carries a NAMED GAP — stored CD/0 bodies are NOT
;;;; rehydrated into live kernel0 records ("this projection does not
;;;; fabricate live records it cannot derive").  Kernel /0's retry law
;;;; (§14.1 [UNC-1], CHECK-RETRY-SAFETY) counts uncertainty ONLY from
;;;; events whose payload carries a LIVE uncertain-effect record, and lifts
;;;; it ONLY from events whose payload carries a LIVE reconciliation
;;;; receipt.  So without rehydration, the §10.8 record journaled by a dead
;;;; process cannot reach the fold that enforces its own retry-policy — the
;;;; prohibition would NOT survive the restart.  This file rehydrates
;;;; exactly the records the fold needs, from bytes alone, under a fixed
;;;; vocabulary (no interning of stored text — every keyword is selected
;;;; from a closed table by string comparison, the journal0 projection's own
;;;; discipline).
;;;;
;;;; EXTENSION-EVENT ADJUDICATION (the seam, argued):
;;;;   • On the STORAGE side this lane journals the uncertain effect as
;;;;     kind (id "effect" "uncertain") — the PJ0 fixture grammar verbatim
;;;;     (cw3 frame 6), which is NOT in kernel0's closed
;;;;     +kernel0-event-types+ and therefore travels as an EXPLICIT
;;;;     extension event under Kernel §13.3 ("extension events MUST NOT
;;;;     alter kernel event semantics") — the corpus-attested shape wins on
;;;;     the byte side because the fixture IS the frozen exhibit of how
;;;;     Mneme stores this fact.
;;;;   • On the FOLD side this projection maps the stored effect:uncertain
;;;;     event to kernel0's :EFFECT-BOUNDED — not :EFFECT-INDETERMINATE —
;;;;     because the stored record names a finite, duplicate-free
;;;;     alternatives set ({cell-written, cell-not-written}), which is
;;;;     exactly §7.3's definition of BOUNDED standing; :indeterminate
;;;;     would discard the bound the record carries.  §9.4 requires a
;;;;     :bounded effect standing to reference a structured §10.8 record —
;;;;     the rehydrated record is attached as the event payload, so
;;;;     kernel0's own payload conventions re-validate the §10.8 shape on
;;;;     every fold.  (For the retry law the choice is load-neutral:
;;;;     CHECK-RETRY-SAFETY counts :effect-bounded and
;;;;     :effect-indeterminate identically — tested in the selftest.)
;;;;
;;;; JURISDICTION: rehydration READS the validated prefix and derives; it
;;;; never writes a byte anywhere.
;;;;
;;;; — CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-capability2)

;;; Fixed vocabulary tables — stored text selects; it is never interned.

(defvar +effect-kind-table+
  '(("effect:external-write" . :external-write))
  "Closed stored-effect-kind -> keyword table.")

(defvar +effect-state-table+
  '(("effect-state:cell-written" . :cell-written)
    ("effect-state:cell-not-written" . :cell-not-written))
  "Closed stored-possible-effect -> keyword table.")

(defvar +retry-policy-table+
  '(("retry:forbidden-without-reconciliation"
     . :forbidden-without-reconciliation))
  "Closed stored-retry-policy -> keyword table.")

(defun %fixed-keyword (table identifier what)
  (let* ((key (identifier-segment-string identifier))
         (hit (assoc key table :test #'string=)))
    (unless hit
      (signal-kernel0
       'unstructured-uncertainty
       :requirement-id "CAP2-REH-1"
       :failed-invariant
       (format nil "rehydration recognizes only the closed ~a vocabulary; ~
                    ~a is not in it (stored text is never interned)"
               what key)))
    (cdr hit)))

(defun %projected-identity (identifier domain)
  "A live Kernel /0 durable identity for a stored CD/0 identifier: DOMAIN +
the identifier's segments joined with \":\" (journal0's own projection
discipline)."
  (make-identity domain (identifier-segment-string identifier)))

(defun %body-field (event namespace name)
  (let ((body (record-field event "event" "body")))
    (and body (lisp-plus-cd0:record-datum-p body)
         (record-field body namespace name))))

(defun %sequence-elements (datum)
  (and datum (lisp-plus-cd0:sequence-datum-p datum)
       (coerce (lisp-plus-cd0:sequence-datum-elements datum) 'list)))

(defun %rehydrate-uncertain-effect (event)
  "Stored effect:uncertain bytes -> the LIVE §10.8 primitive, through
kernel0's own MAKE-UNCERTAIN-EFFECT — so kernel0's UNC-1 field law
re-validates the record on every rehydration; nothing is trusted merely
because it was journaled."
  (make-uncertain-effect
   :kind :external-write
   :attempt (%projected-identity (%body-field event "effect" "attempt-id")
                                 :attempt)
   :external-request (%projected-identity
                      (%body-field event "effect" "external-request-id")
                      :external-request)
   :possible-effects (mapcar (lambda (element)
                               (%fixed-keyword +effect-state-table+ element
                                               "possible-effect"))
                             (%sequence-elements
                              (%body-field event "effect"
                                           "possible-effects")))
   :known-facts (mapcar (lambda (element)
                          (%projected-identity element :receipt))
                        (%sequence-elements
                         (%body-field event "effect" "known-facts")))
   :reconciliation-procedure (%projected-identity
                              (%body-field event "effect"
                                           "reconciliation-procedure")
                              :procedure)
   :retry-policy (%fixed-keyword +retry-policy-table+
                                 (%body-field event "effect" "retry-policy")
                                 "retry-policy")))

(defun %rehydrate-reconciliation-receipt (event uncertain-record)
  "Stored attempt:reconciled bytes + the SAME PREFIX's rehydrated §10.8
record -> the LIVE §14.2 receipt, through kernel0's own
MAKE-RECONCILIATION-RECEIPT.  The previous effect standing is rebuilt as
:BOUNDED referencing the uncertain record (K0E-4 set-identity re-checked by
kernel0's axis constructor); the resulting standing as :SETTLED with the
journaled evidence.  A stored reconciliation whose target has no journaled
§10.8 record in the prefix is refused (UNSTRUCTURED-UNCERTAINTY): a
resolution may not reference uncertainty that was never structured."
  (unless (uncertain-effect-p uncertain-record)
    (signal-kernel0
     'unstructured-uncertainty
     :requirement-id "CAP2-REH-2"
     :failed-invariant
     "§10.8 and §14.2: a journaled reconciliation MUST target a journaled ~
      structured uncertain-effect record earlier in the same validated ~
      prefix"))
  (let* ((target (%projected-identity
                  (%body-field event "reconciliation" "target-attempt-id")
                  :attempt))
         (evidence (mapcar (lambda (element)
                             (%projected-identity element :receipt))
                           (%sequence-elements
                            (%body-field event "reconciliation" "evidence"))))
         (effect-group (make-identity :effect "effect:external-write")))
    (make-reconciliation-receipt
     :target-attempt-id target
     :procedure-id (%projected-identity
                    (%body-field event "reconciliation" "procedure")
                    :procedure)
     :procedure-version (lisp-plus-cd0:integer-datum-value
                         (%body-field event "reconciliation"
                                      "procedure-version"))
     :new-evidence evidence
     :previous-axis-values+determinacy
     (list :effects
           (make-effect-axis
            :value :bounded
            :determinacy (make-determinacy
                          :mode :bounded
                          :alternatives (uncertain-effect-possible-effects
                                         uncertain-record)
                          :evidence (uncertain-effect-known-facts
                                     uncertain-record))
            :uncertain-effect-ref uncertain-record
            :effect-group effect-group))
     :resulting-axis-values+determinacy
     (list :effects
           (make-effect-axis
            :value :settled
            :determinacy (make-determinacy :mode :determinate
                                           :alternatives nil
                                           :evidence evidence)
            :evidence evidence
            :effect-group effect-group))
     :unresolved-residue nil)))

(defun rehydrate-kernel-events (stored-events)
  "Project a vector/list of stored CD/0 event records into LIVE Kernel /0
in-memory events for the adopted retry fold.  Returns (values kernel-events
extension-count).  Identified procedure:
(id \"lisp-plus-capability2\" \"kernel-event-rehydration\") version 0.
Recognized kinds and their projections (fixed table; everything else
becomes an explicit extension event, counted, never silently dropped):

  attempt:prepared         -> :ATTEMPT-BEGUN     (attempt + seat)
  attempt:frontier-crossed -> :FRONTIER-CROSSED  (attempt + external
                              request + the effect identity recorded by the
                              same attempt's prepared event)
  request:acknowledged     -> :REQUEST-ACKNOWLEDGED
  effect:settled           -> :EFFECT-SETTLED    (attempt + effect)
  effect:uncertain         -> :EFFECT-BOUNDED carrying the REHYDRATED live
                              §10.8 record as payload (see file header)
  attempt:reconciled       -> :ATTEMPT-RECONCILED carrying the REHYDRATED
                              live §14.2 receipt as payload"
  (let ((kernel-events '())
        (extension-count 0)
        (attempt-effect-ids '())     ; attempt-name -> live :effect identity
        (uncertain-records '()))     ; attempt-name -> live §10.8 record
    (flet ((collect (event) (push event kernel-events)))
      (map nil
           (lambda (event)
             (let* ((kind (%event-kind-string event))
                    (attempt-name (%event-attempt-name event))
                    (attempt-id
                      (when attempt-name
                        (%projected-identity
                         (record-field event "event" "attempt") :attempt))))
               (cond
                 ((equal kind "attempt:prepared")
                  (let ((seat (%body-field event "attempt" "seat-id"))
                        (effect-kind
                          (first (%sequence-elements
                                  (%body-field event "attempt"
                                               "effect-set")))))
                    (when effect-kind
                      (push (cons attempt-name
                                  (%projected-identity effect-kind :effect))
                            attempt-effect-ids))
                    (collect
                        (make-kernel0-event
                         :event-type :attempt-begun
                         :attempt-id attempt-id
                         :seat-id (and seat
                                       (%projected-identity seat :seat))))))
                 ((equal kind "attempt:frontier-crossed")
                  (collect
                      (make-kernel0-event
                       :event-type :frontier-crossed
                       :attempt-id attempt-id
                       :external-request-id
                       (%projected-identity
                        (%body-field event "attempt" "external-request-id")
                        :external-request)
                       :effect-id
                       (or (cdr (assoc attempt-name attempt-effect-ids
                                       :test #'equal))
                           (make-identity :effect "effect:external-write")))))
                 ((equal kind "request:acknowledged")
                  (collect
                      (make-kernel0-event
                       :event-type :request-acknowledged
                       :attempt-id attempt-id
                       :external-request-id
                       (%projected-identity
                        (%body-field event "ack" "external-request-id")
                        :external-request))))
                 ((equal kind "effect:settled")
                  (collect
                      (make-kernel0-event
                       :event-type :effect-settled
                       :attempt-id attempt-id
                       :effect-id
                       (%projected-identity
                        (%body-field event "effect" "effect-id") :effect))))
                 ((equal kind "effect:uncertain")
                  (let ((record (%rehydrate-uncertain-effect event)))
                    (push (cons attempt-name record) uncertain-records)
                    (collect
                        (make-kernel0-event
                         :event-type :effect-bounded
                         :attempt-id attempt-id
                         :effect-id (or (cdr (assoc attempt-name
                                                    attempt-effect-ids
                                                    :test #'equal))
                                        (make-identity
                                         :effect "effect:external-write"))
                         :payload (list :uncertain-effect record)))))
                 ((equal kind "attempt:reconciled")
                  (let ((receipt
                          (%rehydrate-reconciliation-receipt
                           event
                           (cdr (assoc attempt-name uncertain-records
                                       :test #'equal)))))
                    (collect
                        (make-kernel0-event
                         :event-type :attempt-reconciled
                         :attempt-id attempt-id
                         :payload (list :reconciliation-receipt receipt)))))
                 (t
                  (incf extension-count)
                  (collect
                      (make-kernel0-event
                       :event-type :cap2-extension-event
                       :extension-p t))))))
           stored-events))
    (values (reverse kernel-events) extension-count)))

;;; ---------------------------------------------------------------------------
;;; The retry gate, fed from bytes alone.

(defun check-retry-safety-from-store (store &key seat-name
                                                 candidate-attempt-name
                                                 defect)
  "The §14.1 gate over DURABLE BYTES ALONE: fold the store's validated
prefix, rehydrate, add the CANDIDATE dispatch as a hypothetical
:ATTEMPT-BEGUN into the named seat, and run kernel /0's adopted
CHECK-RETRY-SAFETY.  Returns T when dispatch is lawful; signals kernel /0's
UNSAFE-RETRY when the seat holds an unresolved uncertain predecessor.  No
clock, no flag, no process self-report participates.

DEFECT selects a planted wrong implementation (mutants.lisp), kept alive to
be killed: :STORED-RESOLVED-FLAG answers from a mutable sidecar flag file —
the exact design PJ0 §16 and AP-CRASH-1 forbid — skipping the fold whenever
the flag says so."
  (when (eq defect :stored-resolved-flag)
    (let ((flag (merge-pathnames "RESOLVED.flag"
                                 (lisp-plus-journal0:journal-store-directory
                                  store))))
      (when (probe-file flag)
        (return-from check-retry-safety-from-store t))))
  (let ((report (validate-journal store)))
    ;; (1) The STRUCTURED half — kernel /0's own §14.1 fold over the
    ;; rehydrated records: once a §10.8 record is journaled, IT carries the
    ;; prohibition, and kernel0's fold both enforces and (after a
    ;; rehydrated §14.2 receipt satisfying its own resolution predicate)
    ;; lifts it.
    (multiple-value-bind (kernel-events extension-count)
        (rehydrate-kernel-events (prefix-report-events report))
      (declare (ignore extension-count))
      (lisp-plus-kernel0:check-retry-safety
       (append kernel-events
               (list (make-kernel0-event
                      :event-type :attempt-begun
                      :attempt-id (make-identity
                                   :attempt
                                   (format nil "attempt:~a"
                                           candidate-attempt-name))
                      :seat-id (make-identity
                                :seat (format nil "seat:~a" seat-name)))))
       (make-identity :seat (format nil "seat:~a" seat-name))))
    ;; (2) The PRE-DECLARATION half (this lane's addition, adjudicated from
    ;; §10.3 + AP0 W1/AP-CRASH-4): a process that died AFTER journaling
    ;; frontier-crossed and BEFORE journaling anything further leaves no
    ;; §10.8 record for the kernel fold to count — yet its frontier was
    ;; crossed and its settlement is nowhere.  "After send, before reliable
    ;; response" is W1: the effect is unresolved and blind retry is
    ;; forbidden.  Any attempt in the seat that crossed the frontier and
    ;; has neither a journaled settlement nor a journaled reconciliation
    ;; refuses dispatch.
    (let ((events (prefix-report-events report))
          (seat-attempts '())    ; attempt-name -> seat-name
          (crossed '())
          (closed '()))
      (loop for index below (fill-pointer events)
            for event = (aref events index)
            for kind = (%event-kind-string event)
            for attempt-name = (%event-attempt-name event)
            do (cond ((equal kind "attempt:prepared")
                      (let ((seat (%body-field event "attempt" "seat-id")))
                        (when seat
                          (push (cons attempt-name
                                      (car (last (identifier-segments
                                                  seat))))
                                seat-attempts))))
                     ((equal kind "attempt:frontier-crossed")
                      (pushnew attempt-name crossed :test #'equal))
                     ((member kind '("effect:settled" "attempt:reconciled")
                              :test #'equal)
                      (pushnew attempt-name closed :test #'equal))))
      (dolist (attempt-name crossed)
        (when (and (equal seat-name
                          (cdr (assoc attempt-name seat-attempts
                                      :test #'equal)))
                   (not (member attempt-name closed :test #'equal)))
          (signal-kernel0
           'unsafe-retry
           :attempt-id (make-identity :attempt (format nil "attempt:~a"
                                                       candidate-attempt-name))
           :seat-id (make-identity :seat (format nil "seat:~a" seat-name))
           :frontier-crossed-p t
           :evidence-ids (list (make-identity
                                :attempt (format nil "attempt:~a"
                                                 attempt-name)))
           :requirement-id "CAP2-W1"
           :failed-invariant
           "§10.3, §14.1, AP0 W1/AP-CRASH-4: a predecessor attempt in this ~
            seat crossed the frontier and no journaled settlement or ~
            reconciliation exists; its effect is unresolved and blind ~
            dispatch is forbidden — reconcile first")))))
  t)

(defun %attempt-identity-taken-p (store attempt-name)
  "Does the validated prefix already bind this attempt identity (any
attempt:prepared event under it)?  The :408 duplicate-identity gate's
question, answered from bytes."
  (let ((report (validate-journal store)))
    (let ((events (prefix-report-events report)))
      (loop for index below (fill-pointer events)
            for event = (aref events index)
            thereis (and (equal (%event-kind-string event)
                                "attempt:prepared")
                         (equal (%event-attempt-name event)
                                attempt-name))))))
