;;;; reconcile.lisp — structuring uncertainty and resolving it with
;;;; evidence.
;;;;
;;;; Two entry points, deliberately NOT the reserved verbs
;;;; (record-bounded-effect / record-indeterminate-effect /
;;;; compensate-effect / reconcile-attempt stay unclaimed):
;;;;
;;;; DECLARE-UNCERTAIN-EFFECT — §10.8 structuring.  A restart that finds a
;;;; crossed-and-unsettled attempt in the bytes cannot know whether the
;;;; effect occurred (AP-DSP-2's situation from the survivor's side).  It
;;;; MUST structure that ignorance as the §10.8 record — through kernel
;;;; /0's own MAKE-UNCERTAIN-EFFECT, whose UNC-1 field law validates the
;;;; shape — and journal it in the PJ0 fixture grammar, so the prohibition
;;;; is carried by durable bytes from then on.  Nothing becomes uncertain
;;;; by request: the fold must show crossed-and-unsettled
;;;; (CAP2-NOTHING-UNCERTAIN otherwise), and a second declaration is a
;;;; disposition, not a fresh transition.
;;;;
;;;; RECONCILE-UNCERTAIN-EFFECT — §14.2/UNC-2 resolution.  ONLY an
;;;; evidence-carrying reconciliation resolves; never a timeout, never a
;;;; default, never process death, never later work (PJ-FOLD-1).  The
;;;; declared procedure (id "reconciliation" "cap2-world-request-lookup"
;;;; "0") carries the journaled external-request identity across the
;;;; jurisdiction line and asks the SURVIVING world's request ledger.  Both
;;;; branches are first-class:
;;;;   (a) the entry is found — the effect APPLIED; settlement is
;;;;       settled-with-evidence in the applied direction, and the
;;;;       counterfactual stands in the ledger itself: a blind retry would
;;;;       have appended a second application;
;;;;   (b) the entry is absent — the effect NEVER LANDED; settlement is
;;;;       settled-with-evidence in the not-applied direction (the ledger's
;;;;       whole digest attests the absence), and a FRESH attempt under a
;;;;       NEW identity is thereafter lawful — the old identity is never
;;;;       resurrected.
;;;; In both branches the LIVE §14.2 receipt is constructed through kernel
;;;; /0's own MAKE-RECONCILIATION-RECEIPT (shape law enforced at the
;;;; source) before the event is journaled; resolution then holds in the
;;;; bytes because the fold — kernel /0's own resolution predicate over the
;;;; REHYDRATED receipt — derives it, never because anything stored says
;;;; "resolved" (PJ0 §16, AP-CRASH-1: no stored resolved flag exists
;;;; anywhere in this lane).
;;;;
;;;; Preconditions, precisely typed: reconciling a crossed attempt whose
;;;; uncertainty was never STRUCTURED refuses UNSTRUCTURED-UNCERTAINTY
;;;; (§10.8: inline-only uncertainty is unlawful); reconciling where the
;;;; fold shows nothing uncertain refuses CAP2-NOTHING-UNCERTAIN;
;;;; reconciling against a world whose ledger is gone refuses kernel /0's
;;;; RECONCILIATION-INSUFFICIENT (an unanswerable world resolves nothing);
;;;; a SECOND reconciliation of the same uncertain effect returns the
;;;; disposition (:ALREADY-RECONCILED + the prior event), journaling
;;;; nothing (capability0's law-8 idiom: a repeated act gets a precise
;;;; disposition, not a fresh transition).
;;;;
;;;; — CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-capability2)

(defun %crossed-external-request-id (crossed-event)
  (%body-field crossed-event "attempt" "external-request-id"))

(defun declare-uncertain-effect (store attempt-name
                                 &key (process-name "cap2-process"))
  "Structure the named attempt's crossed-and-unsettled standing as the
§10.8 record and journal it.  Returns (values :declared live-record) on
the fresh declaration, (values :already-declared stored-event) when the
record already stands.  Signals CAP2-NOTHING-UNCERTAIN when the fold shows
nothing crossed-and-unsettled under this identity."
  (multiple-value-bind (standing details)
      (derive-effect-standing store attempt-name)
    (case standing
      (:uncertain-unresolved
       (values :already-declared (getf details :uncertain)))
      (:crossed-unsettled
       (let* ((crossed (getf details :crossed))
              (request-id (%crossed-external-request-id crossed))
              (record
                ;; kernel /0's own constructor: the UNC-1 field law
                ;; validates this shape at the source.
                (make-uncertain-effect
                 :kind :external-write
                 :attempt (make-identity
                           :attempt (format nil "attempt:~a" attempt-name))
                 :external-request (%projected-identity request-id
                                                        :external-request)
                 :possible-effects '(:cell-written :cell-not-written)
                 :known-facts (list
                               (make-identity
                                :receipt (format nil "cap2-event:e-~a-prepared"
                                                 attempt-name))
                               (make-identity
                                :receipt (format nil "cap2-event:e-~a-frontier"
                                                 attempt-name)))
                 :reconciliation-procedure
                 (make-identity :procedure
                                (identifier-segment-string
                                 (identifier-from-segments
                                  +reconciliation-procedure-segments+)))
                 :retry-policy :forbidden-without-reconciliation)))
         (append-event store
                       (make-effect-uncertain-event
                        :attempt-name attempt-name
                        :process-name process-name
                        :known-fact-segments
                        (list (list "cap2-event"
                                    (format nil "e-~a-prepared" attempt-name))
                              (list "cap2-event"
                                    (format nil "e-~a-frontier"
                                            attempt-name)))))
         (values :declared record)))
      (t
       (error 'cap2-nothing-uncertain
              :requirement-id "CAP2-DECL-1"
              :attempt-name attempt-name
              :detail (format nil "standing derived from the fold: ~a"
                              standing))))))

(defun reconcile-uncertain-effect (store world attempt-name
                                   &key (process-name "cap2-process"))
  "Resolve the named attempt's journaled §10.8 record by the declared
evidence-carrying procedure against the SURVIVING world.  Returns
(values :applied|:not-applied reconciled-event live-receipt) on the fresh
resolution and (values :already-reconciled stored-event nil) on a repeat.
Typed refusals per the file header."
  (%check-world world)
  (multiple-value-bind (standing details)
      (derive-effect-standing store attempt-name)
    (case standing
      (:reconciled
       (values :already-reconciled (getf details :reconciled) nil))
      (:crossed-unsettled
       (signal-kernel0
        'unstructured-uncertainty
        :attempt-id (make-identity :attempt (format nil "attempt:~a"
                                                    attempt-name))
        :requirement-id "CAP2-REC-1"
        :failed-invariant
        "§10.8 [F: UNC-1]: this attempt's uncertainty was never structured ~
         as a journaled uncertain-effect record; reconciliation may not ~
         proceed from inline uncertainty — declare the record first"))
      (:uncertain-unresolved
       (let* ((uncertain-event (getf details :uncertain))
              (uncertain-record (%rehydrate-uncertain-effect
                                 uncertain-event))
              (request-id-string
                (identifier-segment-string
                 (%body-field uncertain-event "effect"
                              "external-request-id"))))
         (multiple-value-bind (found-p line line-sha)
             (world-ledger-lookup world request-id-string)
           (declare (ignore line))
           (let* ((resolution (if found-p :applied :not-applied))
                  (evidence-segments
                    (if found-p
                        (list (list "world-ledger-entry" attempt-name)
                              (list "world-ledger-entry-sha256" line-sha))
                        (list (list "world-ledger-absence" attempt-name)
                              (list "world-ledger-sha256"
                                    (world-ledger-sha256 world)))))
                  (evidence-ids
                    (mapcar (lambda (segments)
                              (make-identity
                               :receipt
                               (identifier-segment-string
                                (identifier-from-segments segments))))
                            evidence-segments))
                  (effect-group (make-identity :effect
                                               "effect:external-write"))
                  ;; The LIVE §14.2 receipt, validated by kernel /0's own
                  ;; constructor BEFORE anything is journaled.  Empty
                  ;; evidence is unrepresentable: the constructor itself
                  ;; signals RECONCILIATION-INSUFFICIENT.
                  (live-receipt
                    (make-reconciliation-receipt
                     :target-attempt-id (make-identity
                                         :attempt
                                         (format nil "attempt:~a"
                                                 attempt-name))
                     :procedure-id (make-identity
                                    :procedure
                                    (identifier-segment-string
                                     (identifier-from-segments
                                      +reconciliation-procedure-segments+)))
                     :procedure-version 0
                     :new-evidence evidence-ids
                     :previous-axis-values+determinacy
                     (list :effects
                           (make-effect-axis
                            :value :bounded
                            :determinacy
                            (make-determinacy
                             :mode :bounded
                             :alternatives
                             (uncertain-effect-possible-effects
                              uncertain-record)
                             :evidence (uncertain-effect-known-facts
                                        uncertain-record))
                            :uncertain-effect-ref uncertain-record
                            :effect-group effect-group))
                     :resulting-axis-values+determinacy
                     (list :effects
                           (make-effect-axis
                            :value :settled
                            :determinacy (make-determinacy
                                          :mode :determinate
                                          :alternatives nil
                                          :evidence evidence-ids)
                            :evidence evidence-ids
                            :effect-group effect-group))
                     :unresolved-residue nil))
                  (event (make-attempt-reconciled-event
                          :attempt-name attempt-name
                          :process-name process-name
                          :resolution resolution
                          :evidence-segments evidence-segments)))
             (append-event store event)
             (values resolution event live-receipt)))))
      (t
       (error 'cap2-nothing-uncertain
              :requirement-id "CAP2-REC-2"
              :attempt-name attempt-name
              :detail (format nil "standing derived from the fold: ~a"
                              standing))))))
