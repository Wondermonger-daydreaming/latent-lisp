;;;; fold.lisp — live authority is FOLD-DERIVED from the validated prefix.
;;;;
;;;; There is no capability registry, no status database, no mutable "state"
;;;; slot anywhere in this lane: every question about live authority is
;;;; answered by folding the events of the CURRENTLY VALIDATED journal prefix
;;;; under an explicitly supplied bootstrap authority, and the fold's output
;;;; is a fresh value discarded after the query.  (The one special variable
;;;; in the package, *MUTANT-LEDGER-CACHE*, belongs to the PLANTED
;;;; cached-status defect and exists precisely to be killed — mutants.lisp.)
;;;;
;;;; Terminal-classification law of this fold (adjudicated; see
;;;; CAPABILITY-0-RETURN.md §design-decisions):
;;;;   :valid      — fold over every committed frame.
;;;;   :torn-tail  — fold over the valid prefix, WITH the excluded tail's
;;;;                 offset and digest surfaced into every receipt.  A torn
;;;;                 tail is by PJ0 §13 a trailing INCOMPLETE frame: it was
;;;;                 never a committed event, so it cannot carry a committed
;;;;                 revocation — answering from the valid prefix is honest,
;;;;                 and the evidence stays visible (law 9).
;;;;   :corruption — REFUSE (kernel0's JOURNAL-PREFIX-INVALID).  Committed
;;;;                 frames beyond an invalid interior frame are unreachable
;;;;                 (no skip-forward), so a committed revocation could be
;;;;                 buried past the damage: any liveness answer would be
;;;;                 unbounded.  This deliberately DIVERGES from journal0's
;;;;                 own RECONSTRUCT (which answers history questions from
;;;;                 the pre-corruption prefix): reconstructing HISTORY at a
;;;;                 named prefix is bounded; asserting PRESENT LIVENESS is
;;;;                 not (laws L5, L13).
;;;;
;;;; — CLAVIGER (Claude Fable 5 subagent), 2026-07-29

(in-package #:lisp-plus-capability0)

;;; ---------------------------------------------------------------------------
;;; Fold output values.  Constructed fresh per derivation; never stored.

(defstruct capability-record
  capability-id        ; identifier datum
  grant-ordinal        ; integer | NIL (NIL: only dangling revocations seen)
  grant-event-id       ; identifier datum | NIL
  subject action resource scope issuer   ; identifier datums | NIL
  revocation-ordinal   ; integer | NIL (NIL: not revoked in this prefix)
  revocation-event-id  ; identifier datum | NIL — the ORIGINAL revocation
  dispositions)        ; list of plists, oldest first — the precise
                       ; dispositions of events that caused NO transition:
                       ;   (:disposition :already-granted
                       ;                 | :grant-of-revoked-identity
                       ;                 | :already-revoked
                       ;                 | :revocation-without-grant
                       ;    :ordinal N :event-id ID
                       ;    [:original-grant-event-id ID]
                       ;    [:original-revocation-event-id ID])

(defstruct authority-ledger
  store-id             ; string
  records              ; list of capability-record, first-grant order
  report)              ; the prefix-report this ledger was derived from

;;; ---------------------------------------------------------------------------
;;; Field access with refusal.

(defun %required-identifier (event ordinal namespace name)
  (let ((value (record-field event namespace name)))
    (unless (and value (lisp-plus-cd0:identifier-datum-p value))
      (error 'cap0-malformed-authority-event
             :requirement-id "CAP0-SCHEMA-2"
             :ordinal ordinal
             :missing-field (format nil "~a:~a" namespace name)
             :detail (format nil "committed capability0 event at ordinal ~a ~
                                  lacks required identifier field (~a ~a); ~
                                  the fold refuses to guess"
                             ordinal namespace name)))
    value))

(defun %require-bootstrap-issuer (issuer bootstrap ordinal role)
  "A journaled grant/revocation whose issuer the declared bootstrap does not
ground makes the whole derivation unanswerable under this bootstrap: refuse
with kernel0's MINTING-AUTHORITY-INVALID rather than silently ignoring or
silently honoring foreign authority."
  (unless (datum= issuer (bootstrap-authority-issuer bootstrap))
    (lisp-plus-kernel0:signal-kernel0
     'lisp-plus-kernel0:minting-authority-invalid
     :failed-invariant
     (format nil "~a event at ordinal ~a names issuer ~a, which the ~
                  declared bootstrap authority (~a) does not ground"
             role ordinal
             (identifier-segment-string issuer)
             (identifier-segment-string (bootstrap-authority-issuer
                                         bootstrap)))
     :requirement-id "CAP0-BOOT-3"
     :offending-field "issuer"
     :offending-value (identifier-segment-string issuer))))

;;; ---------------------------------------------------------------------------
;;; The fold.

(defun derive-authority-ledger (store bootstrap &key defect report)
  "Fold the validated prefix of STORE into an AUTHORITY-LEDGER under the
explicit BOOTSTRAP authority.  REPORT, when supplied, is the prefix-report
to fold over (so a caller can bind fold and receipt to ONE validation);
otherwise the store is validated here.  DEFECT selects a PLANTED defective
fold for the mutant-kill harness (never the strict path)."
  (%check-bootstrap store bootstrap)
  (let ((report (or report (validate-journal store))))
    (ecase (prefix-report-status report)
      ((:valid :torn-tail))
      (:corruption
       (lisp-plus-kernel0:signal-kernel0
        'lisp-plus-kernel0:journal-prefix-invalid
        :failed-invariant
        (format nil "live authority cannot be derived across an invalid ~
                     interior frame (~a): committed frames beyond the ~
                     corruption point are unreachable, so any liveness ~
                     answer would be unbounded"
                (prefix-report-condition-type report))
        :requirement-id "CAP0-FOLD-2"
        :evidence-ids (list (prefix-report-condition-type report)))))
    (let ((records '()))
      (flet ((find-record (capability-id)
               (find capability-id records
                     :key #'capability-record-capability-id
                     :test #'datum=))
             (dispose (record plist)
               (setf (capability-record-dispositions record)
                     (append (capability-record-dispositions record)
                             (list plist)))))
        (loop
          for index below (length (prefix-report-events report))
          for event = (aref (prefix-report-events report) index)
          for event-id = (aref (prefix-report-event-ids report) index)
          for ordinal = (1+ index)
          for kind = (record-field event "event" "kind")
          for kind-string = (and kind
                                 (lisp-plus-cd0:identifier-datum-p kind)
                                 (identifier-segment-string kind))
          do (cond
               ;; -------------------------------------------------- grant --
               ((equal kind-string "capability0:granted")
                (let ((capability-id (%required-identifier
                                      event ordinal "capability" "capability-id"))
                      (subject (%required-identifier event ordinal
                                                     "capability" "subject"))
                      (action (%required-identifier event ordinal
                                                    "capability" "action"))
                      (resource (%required-identifier event ordinal
                                                      "capability" "resource"))
                      (scope (%required-identifier event ordinal
                                                   "capability" "scope"))
                      (issuer (%required-identifier event ordinal
                                                    "capability" "issuer")))
                  (%require-bootstrap-issuer issuer bootstrap ordinal "grant")
                  (let ((record (find-record capability-id)))
                    (cond
                      ;; first sighting: a fresh grant.
                      ((null record)
                       (push (make-capability-record
                              :capability-id capability-id
                              :grant-ordinal ordinal
                              :grant-event-id event-id
                              :subject subject :action action
                              :resource resource :scope scope :issuer issuer)
                             records))
                      ;; only dangling revocations so far: this grant is the
                      ;; first authority for the identity.  The earlier
                      ;; dangling revocation does NOT pre-revoke it —
                      ;; revocation is an act upon existing authority, not a
                      ;; standing prohibition against future minting (which
                      ;; would be policy, out of /0 scope).
                      ((null (capability-record-grant-ordinal record))
                       (setf (capability-record-grant-ordinal record) ordinal
                             (capability-record-grant-event-id record) event-id
                             (capability-record-subject record) subject
                             (capability-record-action record) action
                             (capability-record-resource record) resource
                             (capability-record-scope record) scope
                             (capability-record-issuer record) issuer))
                      ;; already revoked: re-granting the SAME identity would
                      ;; be restoration by the back door; §11.7 (CAP-3,
                      ;; restoration requires a NEW capability identity) is
                      ;; out of this slice's scope, so the identity stays
                      ;; revoked and the event gets a precise disposition.
                      ((capability-record-revocation-ordinal record)
                       (dispose record
                                (list :disposition :grant-of-revoked-identity
                                      :ordinal ordinal :event-id event-id
                                      :original-revocation-event-id
                                      (capability-record-revocation-event-id
                                       record))))
                      ;; live: a second grant of a live identity is a precise
                      ;; disposition naming the ORIGINAL grant — never a
                      ;; fresh transition (the grant-side mirror of law 8).
                      (t
                       (dispose record
                                (list :disposition :already-granted
                                      :ordinal ordinal :event-id event-id
                                      :original-grant-event-id
                                      (capability-record-grant-event-id
                                       record))))))))
               ;; --------------------------------------------- revocation --
               ((equal kind-string "capability0:revoked")
                (let ((capability-id (%required-identifier
                                      event ordinal "revocation" "capability-id"))
                      (issuer (%required-identifier event ordinal
                                                    "revocation" "issuer")))
                  (%require-bootstrap-issuer issuer bootstrap ordinal
                                             "revocation")
                  ;; PLANTED DEFECT :ignore-revocation — the fold that reads
                  ;; grants but never revocations.  Strict path never enters.
                  (unless (eq defect :ignore-revocation)
                    (let ((record (find-record capability-id)))
                      (cond
                        ;; never granted: nothing to revoke.  Recorded as a
                        ;; dangling-revocation disposition; grants nothing,
                        ;; revokes nothing, forbids nothing.
                        ((null record)
                         (let ((fresh (make-capability-record
                                       :capability-id capability-id)))
                           (dispose fresh
                                    (list :disposition
                                          :revocation-without-grant
                                          :ordinal ordinal
                                          :event-id event-id))
                           (push fresh records)))
                        ((null (capability-record-grant-ordinal record))
                         (dispose record
                                  (list :disposition :revocation-without-grant
                                        :ordinal ordinal :event-id event-id)))
                        ;; live: THE transition.  This is the only place in
                        ;; the lane where authority ends.
                        ((null (capability-record-revocation-ordinal record))
                         (setf (capability-record-revocation-ordinal record)
                               ordinal
                               (capability-record-revocation-event-id record)
                               event-id))
                        ;; already revoked: a SECOND revocation (different
                        ;; event, same target) is a precise disposition
                        ;; naming the ORIGINAL revoking event — never a
                        ;; second historical revocation effect (law 8).
                        (t
                         (dispose record
                                  (list :disposition :already-revoked
                                        :ordinal ordinal :event-id event-id
                                        :original-revocation-event-id
                                        (capability-record-revocation-event-id
                                         record)))))))))
               ;; ---------------------------------------------- unrelated --
               ;; Any other kind carries NO authority effect (law 6 by
               ;; construction; proven by control, not only by this comment).
               (t nil))))
      (make-authority-ledger
       :store-id (journal-store-store-id store)
       :records (nreverse records)
       :report report))))

(defun capability-history (store bootstrap capability-id)
  "The full fold-derived history of CAPABILITY-ID at the current validated
prefix: (values capability-record-or-NIL ledger).  A revocation does not
erase the historical grant — both remain visible here (law 2)."
  (let ((ledger (derive-authority-ledger store bootstrap)))
    (values (find (ensure-identifier capability-id :what "capability-id")
                  (authority-ledger-records ledger)
                  :key #'capability-record-capability-id
                  :test #'datum=)
            ledger)))
