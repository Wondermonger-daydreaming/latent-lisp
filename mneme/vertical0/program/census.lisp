;;;; census.lisp — vertical-census-0: the seat outcome map, derived from
;;;; durable evidence alone (contract §§11–12).
;;;;
;;;; This module is deliberately loadable WITHOUT campaign.lisp (the
;;;; orchestration module): the official reconstruction and the
;;;; independent replay both consume THIS procedure over primary durable
;;;; journals + public configuration only.  Nothing here consults live
;;;; caches, dead state, oracle knowledge, or finalizer output.
;;;;
;;;; Derivation precedence per seat (evidence classes, not routes):
;;;;   1. a journaled vertical REFUSAL record        -> absent, refused
;;;;   2. a journaled STREAM-CLOSURE record          -> present-partial;
;;;;      effect = crossed-unsettled-partial-closed (the STREAM axis: the
;;;;      stream crossed the frontier, chunk custody is durable, no
;;;;      stream-terminal envelope was ever captured, and the partial was
;;;;      closed by declared policy — never "completed")
;;;;   3. a journaled PROJECTION record (live ap0 or vertical recovery)
;;;;      -> manifestation from its kernel status; effect from the cap2
;;;;      standing fold; projection-origin derived-recovery when the
;;;;      procedure is vertical-recovery-projection-0
;;;;   4. a journaled CONTROL-OUTCOME record         -> absent; effect =
;;;;      the reconciliation outcome standing
;;;;   5. cap2 standing :uncertain-unresolved        -> absent, uncertain
;;;;   6. cap2 standing :reconciled                  -> absent,
;;;;      reconciled-<resolution>
;;;; A seat deriving through none of these is a hard error: a founded
;;;; census is founded or it is not asserted (bilateral law).
;;;;
;;;; — FABER-MORTIS (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-vertical0)

(defun %seat-event (events namespace seat-id suffix)
  (find-event events
              :event-id (format nil "~a:e-~a-~a" namespace seat-id suffix)))

(defun %reconciled-resolution (store attempt-name)
  (multiple-value-bind (standing details)
      (derive-effect-standing store attempt-name)
    (when (eq standing :reconciled)
      (let* ((event (getf details :reconciled))
             (resolution (body-string (event-body event)
                                      "reconciliation" "resolution")))
        (cond ((equal resolution "resolution:applied") "applied")
              ((equal resolution "resolution:not-applied") "not-applied")
              (t (error "census: unreadable reconciliation resolution ~s"
                        resolution)))))))

(defun %derive-seat-outcome (store events seat-id)
  "One seat's outcome plist: (:seat :manifestation :effect
:absence-state :refusal :chunks-preserved :projection-origin) — NIL
entries omitted by the record builder."
  (let ((attempt (format nil "a-~a" seat-id))
        (refusal (%seat-event events "vertical-event" seat-id "refusal"))
        (closure (%seat-event events "vertical-event" seat-id
                              "stream-closure"))
        (live-projection (%seat-event events "ap0-event" seat-id
                                      "projection"))
        (recovery-projection (%seat-event events "vertical-event" seat-id
                                          "projection"))
        (control-outcome (%seat-event events "vertical-event" seat-id
                                      "control-outcome")))
    (cond
      (refusal
       (list :seat seat-id :manifestation "absent"
             :absence-state "refused-pre-effect"
             :refusal (body-string (event-body refusal)
                                   "vertical" "refusal")))
      (closure
       (list :seat seat-id :manifestation "present-partial"
             :effect "crossed-unsettled-partial-closed"
             :chunks-preserved (body-integer (event-body closure)
                                             "vertical" "chunks-preserved")))
      ((or live-projection recovery-projection)
       (let* ((event (or live-projection recovery-projection))
              (namespace (if live-projection "ap0" "vertical"))
              (body (event-body event))
              (status (body-string body namespace
                                   "kernel-manifestation-status"))
              (state (body-string body namespace "no-payload-state"))
              (standing (derive-effect-standing store attempt)))
         (unless (eq standing :settled)
           (error "census: seat ~a holds a projection but its cap2 ~
                   standing is ~a, not :settled" seat-id standing))
         (append
          (list :seat seat-id :manifestation status :effect "settled")
          (when (and (equal status "absent") state)
            (list :absence-state state))
          (when recovery-projection
            (list :projection-origin "derived-recovery")))))
      (control-outcome
       (list :seat seat-id :manifestation "absent"
             :effect (body-string (event-body control-outcome)
                                  "vertical" "standing")))
      (t
       (let ((standing (derive-effect-standing store attempt)))
         (case standing
           (:uncertain-unresolved
            (list :seat seat-id :manifestation "absent"
                  :effect "uncertain-unresolved"))
           (:reconciled
            (list :seat seat-id :manifestation "absent"
                  :effect (format nil "reconciled-~a"
                                  (%reconciled-resolution store attempt))))
           (t
            (error "census: seat ~a derives through no evidence class ~
                    (standing ~a); a founded census is founded or it is ~
                    not asserted" seat-id standing))))))))

(defun census-outcomes (store config)
  "The per-seat outcome plists, in declared bank order."
  (let ((events (validated-events store)))
    (loop for seat-plist in (config-bank config)
          collect (%derive-seat-outcome store events
                                        (seat-field seat-plist :seat)))))

(defun %seat-outcome-record (outcome)
  (lisp-plus-cd0:make-record-datum
   (remove nil
           (list
            (lisp-plus-cd0:make-record-entry
             (v-id "census" "seat") (v-str (getf outcome :seat)))
            (lisp-plus-cd0:make-record-entry
             (v-id "census" "manifestation")
             (v-str (getf outcome :manifestation)))
            (when (getf outcome :effect)
              (lisp-plus-cd0:make-record-entry
               (v-id "census" "effect") (v-str (getf outcome :effect))))
            (when (getf outcome :absence-state)
              (lisp-plus-cd0:make-record-entry
               (v-id "census" "absence-state")
               (v-str (getf outcome :absence-state))))
            (when (getf outcome :refusal)
              (lisp-plus-cd0:make-record-entry
               (v-id "census" "refusal") (v-str (getf outcome :refusal))))
            (when (getf outcome :chunks-preserved)
              (lisp-plus-cd0:make-record-entry
               (v-id "census" "chunks-preserved")
               (v-int (getf outcome :chunks-preserved))))
            (when (getf outcome :projection-origin)
              (lisp-plus-cd0:make-record-entry
               (v-id "census" "projection-origin")
               (v-str (getf outcome :projection-origin))))))))

(defun derive-census (store config &key (derivation-origin "in-campaign"))
  "The census record (canonical CD/0 datum) + the outcome plists.
DERIVATION-ORIGIN names where evaluation happened (\"in-campaign\" for
the campaign's own assertion; the official reconstruction and replay pass
\"reconstructed\")."
  (let ((outcomes (census-outcomes store config)))
    (values
     (v-rec '("census" "record-kind") (v-id "record" "census")
            '("census" "procedure-id") (v-str "vertical-census-0")
            '("census" "procedure-version") (v-int 0)
            '("census" "derivation-origin") (v-str derivation-origin)
            '("census" "seat-count") (v-int (length outcomes))
            '("census" "seats") (v-seq (mapcar #'%seat-outcome-record
                                               outcomes)))
     outcomes)))
