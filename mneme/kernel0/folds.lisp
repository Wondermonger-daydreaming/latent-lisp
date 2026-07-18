(in-package #:lisp-plus-kernel0)

;;; In-memory event and payload conventions for the three Kernel /0 folds.
;;;
;;; This file does not define a journal representation.  EVENTS are immutable
;;; structures in a plain proper list, and list position is the sole ordinal;
;;; no timestamp field exists or participates in ordering (§13.2, §13.7).
;;;
;;; The minimal payload conventions used here are:
;;;   :ATTEMPT-BEGIN carries an optional :ATTEMPT record.  Top-level event
;;;     identities drive the fold; when the record is present they must agree.
;;;   :EFFECT-BOUNDED and :EFFECT-INDETERMINATE carry :UNCERTAIN-EFFECT.
;;;   :ATTEMPT-SUPERSEDED carries :SUPERSESSION.
;;;   :ATTEMPT-RECONCILED carries :RECONCILIATION-RECEIPT.
;;;   Any event may carry one :EXPOSURE-RECORD.
;;;   An attempt event may carry :AXIS-VALUES+DETERMINACY, a non-empty plist
;;;     whose keys are the four axis names and whose values are complete AXIS
;;;     records.  The first such plist for an attempt is its original recorded
;;;     values.  Reconciliation resulting plists overlay it in event order.
;;;
;;; For the in-memory no-blind-retry gate, a reconciliation resolves a recorded
;;; uncertain effect only when its resulting :EFFECTS axis is determinate and
;;; has value :SETTLED or :COMPENSATED, and its unresolved residue is NIL.  A
;;; narrower :BOUNDED result remains unresolved.  Supersession authorizes only
;;; its named superseding attempt and never removes predecessor uncertainty.
;;;
;;; Payload conventions beyond these fold needs await the unwritten process
;;; journal specification.  In particular, this is not a byte schema, framing
;;; rule, durability protocol, merge format, or torn-tail implementation.

(defparameter +kernel0-event-types+
  '(:process-created
    :process-authorized
    :seat-reserved
    :attempt-begun
    :effect-prepared
    :frontier-crossed
    :request-acknowledged
    :manifestation-recorded
    :effect-settled
    :effect-bounded
    :effect-indeterminate
    :attempt-refused
    :attempt-failed
    :attempt-completed
    :attempt-cancelled
    :process-suspended
    :capability-restored
    :attempt-reconciled
    :attempt-superseded
    :derived-view-recorded
    :artifact-committed)
  "The closed Kernel /0 vocabulary from §13.3; extension events are explicit.")

(defun kernel0-event-type-p (value)
  (and (keywordp value)
       (member value +kernel0-event-types+ :test #'eq)
       t))

(defun %keyword-plist-p (value)
  (and (%proper-list-p value)
       (evenp (length value))
       (loop with seen = nil
             for key in value by #'cddr
             always (and (keywordp key)
                         (not (member key seen :test #'eq))
                         (progn (push key seen) t)))))

(defstruct (kernel0-event
            (:constructor %make-kernel0-event
                (event-type
                 extension-p
                 process-id
                 logical-operation-id
                 seat-id
                 attempt-id
                 external-request-id
                 exposure-id
                 machine-configuration-id
                 effect-id
                 manifestation-id
                 payload))
            (:copier nil)
            (:conc-name %kernel0-event-))
  (event-type nil :read-only t)
  (extension-p nil :read-only t)
  (process-id nil :read-only t)
  (logical-operation-id nil :read-only t)
  (seat-id nil :read-only t)
  (attempt-id nil :read-only t)
  (external-request-id nil :read-only t)
  (exposure-id nil :read-only t)
  (machine-configuration-id nil :read-only t)
  (effect-id nil :read-only t)
  (manifestation-id nil :read-only t)
  (payload nil :read-only t))

(defun kernel0-event-event-type (event)
  (%kernel0-event-event-type event))

(defun kernel0-event-extension-p (event)
  (%kernel0-event-extension-p event))

(defun kernel0-event-process-id (event)
  (%kernel0-event-process-id event))

(defun kernel0-event-logical-operation-id (event)
  (%kernel0-event-logical-operation-id event))

(defun kernel0-event-seat-id (event)
  (%kernel0-event-seat-id event))

(defun kernel0-event-attempt-id (event)
  (%kernel0-event-attempt-id event))

(defun kernel0-event-external-request-id (event)
  (%kernel0-event-external-request-id event))

(defun kernel0-event-exposure-id (event)
  (%kernel0-event-exposure-id event))

(defun kernel0-event-machine-configuration-id (event)
  (%kernel0-event-machine-configuration-id event))

(defun kernel0-event-effect-id (event)
  (%kernel0-event-effect-id event))

(defun kernel0-event-manifestation-id (event)
  (%kernel0-event-manifestation-id event))

(defun kernel0-event-payload (event)
  (%snapshot-tree (%kernel0-event-payload event)))

(defun make-kernel0-event (&rest arguments)
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:event-type
             :extension-p
             :process-id
             :logical-operation-id
             :seat-id
             :attempt-id
             :external-request-id
             :exposure-id
             :machine-configuration-id
             :effect-id
             :manifestation-id
             :payload)
           'journal-illegal-transition
           "§13.2–§13.3: an in-memory event accepts only its semantic identity fields, explicit extension marker, and payload plist")))
    (%require-record-fields
     parsed
     '(:event-type)
     'journal-illegal-transition
     "§13.3: every in-memory event MUST bind an event-type")
    (let ((event-type (%parsed-argument parsed :event-type))
          (extension-p (%parsed-argument parsed :extension-p nil))
          (process-id (%parsed-argument parsed :process-id nil))
          (logical-operation-id
            (%parsed-argument parsed :logical-operation-id nil))
          (seat-id (%parsed-argument parsed :seat-id nil))
          (attempt-id (%parsed-argument parsed :attempt-id nil))
          (external-request-id
            (%parsed-argument parsed :external-request-id nil))
          (exposure-id (%parsed-argument parsed :exposure-id nil))
          (machine-configuration-id
            (%parsed-argument parsed :machine-configuration-id nil))
          (effect-id (%parsed-argument parsed :effect-id nil))
          (manifestation-id
            (%parsed-argument parsed :manifestation-id nil))
          (payload (%parsed-argument parsed :payload nil)))
      (unless (and (keywordp event-type)
                   (or (kernel0-event-type-p event-type)
                       (eq extension-p t)))
        (signal-kernel0
         'journal-illegal-transition
         :failed-invariant
         "§13.3: event-type MUST be a Kernel /0 keyword or be explicitly marked as a library extension"))
      (unless (or (null extension-p) (eq extension-p t))
        (signal-kernel0
         'journal-illegal-transition
         :failed-invariant
         "§13.3: extension-p MUST be a boolean and unknown extension events require T"))
      (unless (%keyword-plist-p payload)
        (signal-kernel0
         'journal-illegal-transition
         :failed-invariant
         "§13.1–§13.3: the in-memory payload convention requires a finite keyword plist without duplicate keys"))
      (when process-id (require-identity process-id :process))
      (when logical-operation-id
        (require-identity logical-operation-id :logical-operation))
      (when seat-id (require-identity seat-id :seat))
      (when attempt-id (require-identity attempt-id :attempt))
      (when external-request-id
        (require-identity external-request-id :external-request))
      (when exposure-id (require-identity exposure-id :exposure))
      (when machine-configuration-id
        (require-identity machine-configuration-id :machine-configuration))
      (when effect-id (require-identity effect-id :effect))
      (when manifestation-id
        (require-identity manifestation-id :manifestation))
      (%make-kernel0-event event-type
                           extension-p
                           process-id
                           logical-operation-id
                           seat-id
                           attempt-id
                           external-request-id
                           exposure-id
                           machine-configuration-id
                           effect-id
                           manifestation-id
                           (%snapshot-tree payload)))))

(defun %event-payload-value (event key)
  (getf (%kernel0-event-payload event) key))

(defun %identity-member-p (identity identities)
  (member identity identities :test #'identity=))

(defun %identity-assoc (identity alist)
  (assoc identity alist :test #'identity=))

(defun %set-identity-alist (identity value alist)
  (let ((entry (%identity-assoc identity alist)))
    (if entry
        (progn (setf (cdr entry) value) alist)
        (append alist (list (cons identity value))))))

(defun %event-effective-attempt-id (event)
  (or (%kernel0-event-attempt-id event)
      (let ((attempt (%event-payload-value event :attempt)))
        (and (attempt-p attempt) (attempt-attempt-id attempt)))
      (let ((effect (%event-payload-value event :uncertain-effect)))
        (and (uncertain-effect-p effect)
             (uncertain-effect-attempt effect)))
      (let ((record (%event-payload-value event :supersession)))
        (and (supersession-p record)
             (supersession-predecessor-attempt-id record)))
      (let ((receipt
              (%event-payload-value event :reconciliation-receipt)))
        (and (reconciliation-receipt-p receipt)
             (reconciliation-receipt-target-attempt-id receipt)))))

(defun %event-effective-seat-id (event)
  (or (%kernel0-event-seat-id event)
      (let ((attempt (%event-payload-value event :attempt)))
        (and (attempt-p attempt) (attempt-seat-id attempt)))
      (let ((record (%event-payload-value event :supersession)))
        (and (supersession-p record) (supersession-seat-id record)))))

(defun %terminal-event-class (event)
  (case (%kernel0-event-event-type event)
    (:attempt-refused :refused)
    (:attempt-failed :failed)
    (:attempt-completed :completed)
    (:attempt-cancelled :cancelled)
    (:attempt-superseded :superseded)
    (otherwise nil)))

(defun %signal-illegal-event (event failed-invariant &key frontier-crossed-p)
  (signal-kernel0
   'journal-illegal-transition
   :process-id (%kernel0-event-process-id event)
   :attempt-id (%event-effective-attempt-id event)
   :seat-id (%event-effective-seat-id event)
   :operation-id (%kernel0-event-logical-operation-id event)
   :frontier-crossed-p frontier-crossed-p
   :failed-invariant failed-invariant))

(defun %require-event-list (events)
  (unless (and (%proper-list-p events)
               (every #'kernel0-event-p events))
    (signal-kernel0
     'journal-prefix-invalid
     :failed-invariant
     "§13.7: an in-memory fold requires a finite proper list containing only immutable KERNEL0-EVENT records"))
  events)

(defun %same-optional-identity-p (left right)
  (or (and (null left) (null right))
      (and left right (identity= left right))))

(defun %validate-event-payload-conventions (events)
  (dolist (event events)
    (let* ((type (%kernel0-event-event-type event))
           (attempt-record (%event-payload-value event :attempt))
           (uncertain-effect
             (%event-payload-value event :uncertain-effect))
           (supersession (%event-payload-value event :supersession))
           (reconciliation
             (%event-payload-value event :reconciliation-receipt))
           (exposure (%event-payload-value event :exposure-record))
           (axis-values
             (%event-payload-value event :axis-values+determinacy)))
      (when attempt-record
        (unless (attempt-p attempt-record)
          (%signal-illegal-event
           event
           "In-memory payload convention: :ATTEMPT MUST reference an immutable ATTEMPT record"))
        (unless (and (or (null (%kernel0-event-attempt-id event))
                         (identity= (%kernel0-event-attempt-id event)
                                    (attempt-attempt-id attempt-record)))
                     (or (null (%kernel0-event-seat-id event))
                         (identity= (%kernel0-event-seat-id event)
                                    (attempt-seat-id attempt-record)))
                     (or (null (%kernel0-event-process-id event))
                         (identity= (%kernel0-event-process-id event)
                                    (attempt-process-id attempt-record)))
                     (or (null (%kernel0-event-logical-operation-id event))
                         (identity=
                          (%kernel0-event-logical-operation-id event)
                          (attempt-logical-operation-id attempt-record))))
          (%signal-illegal-event
           event
           "§13.2: top-level attempt event identities MUST agree with its :ATTEMPT payload record")))
      (when (eq type :seat-reserved)
        (unless (%event-effective-seat-id event)
          (%signal-illegal-event
           event
           "§13.5: :SEAT-RESERVED MUST name the reserved seat")))
      (when (eq type :process-created)
        (unless (%kernel0-event-process-id event)
          (%signal-illegal-event
           event
           "§13.4: :PROCESS-CREATED MUST identify the process whose genesis it records")))
      (when (eq type :attempt-begun)
        (unless (%event-effective-attempt-id event)
          (%signal-illegal-event
           event
           "§13.5: :ATTEMPT-BEGUN MUST name the new attempt")))
      (when (member type
                    '(:effect-prepared
                      :frontier-crossed
                      :effect-settled
                      :effect-bounded
                      :effect-indeterminate)
                    :test #'eq)
        (unless (and (%kernel0-event-effect-id event)
                     (%event-effective-attempt-id event))
          (%signal-illegal-event
           event
           "§13.2 and §13.5: effect transition events MUST name both effect and attempt identities")))
      (when (member type '(:effect-bounded :effect-indeterminate) :test #'eq)
        (unless (uncertain-effect-p uncertain-effect)
          (%signal-illegal-event
           event
           "§10.8 and the in-memory payload convention: bounded or indeterminate effect events MUST carry :UNCERTAIN-EFFECT"))
        (unless (identity= (uncertain-effect-attempt uncertain-effect)
                           (%event-effective-attempt-id event))
          (%signal-illegal-event
           event
           "§10.8: an uncertain-effect attempt identity MUST agree with its event")))
      (when (eq type :attempt-superseded)
        (unless (supersession-p supersession)
          (%signal-illegal-event
           event
           "§14.3 and the in-memory payload convention: :ATTEMPT-SUPERSEDED MUST carry :SUPERSESSION"))
        (unless (and (or (null (%kernel0-event-attempt-id event))
                         (identity=
                          (%kernel0-event-attempt-id event)
                          (supersession-predecessor-attempt-id supersession)))
                     (or (null (%kernel0-event-seat-id event))
                         (identity= (%kernel0-event-seat-id event)
                                    (supersession-seat-id supersession))))
          (%signal-illegal-event
           event
           "§14.3: a supersession event's attempt and seat identities MUST agree with its record")))
      (when (eq type :attempt-reconciled)
        (unless (reconciliation-receipt-p reconciliation)
          (%signal-illegal-event
           event
           "§14.2 and the in-memory payload convention: :ATTEMPT-RECONCILED MUST carry :RECONCILIATION-RECEIPT"))
        (unless (or (null (%kernel0-event-attempt-id event))
                    (identity=
                     (%kernel0-event-attempt-id event)
                     (reconciliation-receipt-target-attempt-id
                      reconciliation)))
          (%signal-illegal-event
           event
           "§14.2: a reconciliation event's attempt identity MUST agree with its receipt")))
      (when exposure
        (unless (exposure-record-p exposure)
          (%signal-illegal-event
           event
           "§10.7 and the in-memory payload convention: :EXPOSURE-RECORD MUST reference an immutable exposure record")))
      (when axis-values
        (unless (%axis-values+determinacy-plist-p axis-values)
          (%signal-illegal-event
           event
           "§14.2 payload convention: :AXIS-VALUES+DETERMINACY MUST be a non-empty plist of complete axes")))
      (when (%terminal-event-class event)
        (unless (%event-effective-attempt-id event)
          (%signal-illegal-event
           event
           "§13.6: an attempt terminal event MUST identify its attempt")))))
  t)

(defun %reconciliation-resolves-effect-p (receipt)
  (let ((effects
          (getf
           (reconciliation-receipt-resulting-axis-values+determinacy receipt)
           :effects)))
    (and (axis-p effects)
         (member (axis-value effects) '(:settled :compensated) :test #'eq)
         (eq (determinacy-mode (axis-determinacy effects)) :determinate)
         (null (reconciliation-receipt-unresolved-residue receipt)))))

(defun %authorized-succession-p (records predecessor superseding seat-id)
  (some (lambda (record)
          (and (identity=
                predecessor
                (supersession-predecessor-attempt-id record))
               (identity=
                superseding
                (supersession-superseding-attempt-id record))
               (identity= seat-id (supersession-seat-id record))))
        records))

(defun %remove-attempt-uncertainties (attempt-id uncertainties)
  (remove attempt-id uncertainties
          :key #'car
          :test #'identity=))

(defun %check-retry-safety-internal (events seat-id)
  (let ((attempt-seats nil)
        (uncertainties nil)
        (supersessions nil))
    (dolist (event events)
      (let ((type (%kernel0-event-event-type event))
            (attempt-id (%event-effective-attempt-id event))
            (event-seat-id (%event-effective-seat-id event)))
        (case type
          (:attempt-begun
           (when event-seat-id
             (setf attempt-seats
                   (%set-identity-alist attempt-id event-seat-id attempt-seats)))
           (when (and event-seat-id
                      (identity= event-seat-id seat-id))
             (dolist (uncertainty uncertainties)
               (let* ((predecessor (car uncertainty))
                      (predecessor-seat
                        (cdr (%identity-assoc predecessor attempt-seats))))
                 (when (and predecessor-seat
                            (identity= predecessor-seat seat-id)
                            (not (identity= predecessor attempt-id))
                            (not (%authorized-succession-p
                                  supersessions
                                  predecessor
                                  attempt-id
                                  seat-id)))
                   (signal-kernel0
                    'unsafe-retry
                    :process-id (%kernel0-event-process-id event)
                    :attempt-id attempt-id
                    :seat-id seat-id
                    :operation-id
                    (%kernel0-event-logical-operation-id event)
                    :frontier-crossed-p t
                    :evidence-ids (list predecessor)
                    :failed-invariant
                    "§14.1 [F: UNC-1]: a new attempt MUST NOT begin in a seat with an unresolved bounded or indeterminate predecessor effect unless reconciliation resolves it or supersession directly authorizes this successor"))))))
          ((:effect-bounded :effect-indeterminate)
           (setf uncertainties
                 (append uncertainties
                         (list
                          (cons attempt-id
                                (%event-payload-value
                                 event :uncertain-effect))))))
          (:attempt-reconciled
           (let ((receipt
                   (%event-payload-value
                    event :reconciliation-receipt)))
             (when (%reconciliation-resolves-effect-p receipt)
               (setf uncertainties
                     (%remove-attempt-uncertainties
                      (reconciliation-receipt-target-attempt-id receipt)
                      uncertainties)))))
          (:attempt-superseded
           ;; Authorization is retained, but predecessor uncertainty is not
           ;; removed (§14.4 [F: ATT-4]).
           (setf supersessions
                 (append supersessions
                         (list
                          (%event-payload-value event :supersession))))))))
    t))

(defun check-retry-safety (events seat-id)
  "Refuse blind retry into SEAT-ID; return T when no unsafe replay is present."
  (%require-event-list events)
  (require-identity seat-id :seat)
  (%validate-event-payload-conventions events)
  (%check-retry-safety-internal events seat-id))

(defun validate-event-sequence (events)
  "Validate the specified in-memory §13.5 subset, then enforce §14.1 retry safety."
  (%require-event-list events)
  (%validate-event-payload-conventions events)
  (let ((reserved-seats nil)
        (created-processes nil)
        (begun-attempts nil)
        (attempt-seats nil)
        (prepared-effects nil)
        (frontier-attempts nil)
        (known-attempts nil)
        (terminal-attempts nil)
        (completed-attempts nil)
        (external-request-owners nil)
        (seats nil))
    (dolist (event events)
      (let* ((type (%kernel0-event-event-type event))
             (attempt-id (%event-effective-attempt-id event))
             (seat-id (%event-effective-seat-id event))
             (effect-id (%kernel0-event-effect-id event))
             (terminal-class (%terminal-event-class event)))
        (case type
          (:process-created
           (let ((process-id (%kernel0-event-process-id event)))
             (when (%identity-member-p process-id created-processes)
               (signal-kernel0
                'duplicate-process-identity
                :process-id process-id
                :failed-invariant
                "§4.2 and §25.2 test 9: a second process genesis MUST NOT reuse a process identity"))
             (push process-id created-processes)))
          (:seat-reserved
           (pushnew seat-id reserved-seats :test #'identity=))
          (:attempt-begun
           ;; NIL is the explicit in-memory representation of an operation
           ;; declared to have no seat (§13.5).
           (when (and seat-id
                      (not (%identity-member-p seat-id reserved-seats)))
             (%signal-illegal-event
              event
              "§13.5 [F: JRN-7]: an attempt cannot begin before reservation of its seat; NIL seat-id is the explicit no-seat exception"))
           (when (%identity-member-p attempt-id begun-attempts)
             (signal-kernel0
              'duplicate-attempt-identity
              :process-id (%kernel0-event-process-id event)
              :attempt-id attempt-id
              :seat-id seat-id
              :operation-id (%kernel0-event-logical-operation-id event)
              :failed-invariant
              "§6.6 and §25.2 test 10: an attempt identity MUST be unique within its declared domain"))
           (when seat-id
             (dolist (completed completed-attempts)
               (let ((completed-seat
                       (cdr (%identity-assoc completed attempt-seats))))
                 (when (and completed-seat
                            (identity= seat-id completed-seat))
                   (signal-kernel0
                    'seat-occupied
                    :process-id (%kernel0-event-process-id event)
                    :attempt-id attempt-id
                    :seat-id seat-id
                    :operation-id
                    (%kernel0-event-logical-operation-id event)
                    :evidence-ids (list completed)
                    :failed-invariant
                    "§6.6 and §25.2 test 11: a non-superseded completed attempt occupies its seat")))))
           (push attempt-id begun-attempts)
           (when seat-id
             (setf attempt-seats
                   (%set-identity-alist attempt-id seat-id attempt-seats))
             (pushnew seat-id seats :test #'identity=)))
          (:effect-prepared
           (pushnew effect-id prepared-effects :test #'identity=))
          (:frontier-crossed
           (unless (%identity-member-p effect-id prepared-effects)
             (%signal-illegal-event
              event
              "§13.5 [F: JRN-7]: a frontier cannot be crossed before preparation of that effect"))
           (pushnew attempt-id frontier-attempts :test #'identity=))
          (:attempt-refused
           (when (%identity-member-p attempt-id frontier-attempts)
             (%signal-illegal-event
              event
              "§13.5 [F: JRN-7] and §25.4 tests 26–27: refusal cannot follow frontier crossing for the same attempt"
              :frontier-crossed-p t)))
          (:attempt-superseded
           (let* ((record (%event-payload-value event :supersession))
                  (predecessor
                    (supersession-predecessor-attempt-id record)))
             (unless (%identity-member-p predecessor known-attempts)
               (%signal-illegal-event
                event
                "§13.5, §14.4, and §25.2 test 14: supersession requires prior recorded predecessor evidence and cannot erase or manufacture it")))))
        (let ((external-request-id
                (%kernel0-event-external-request-id event)))
          (when (and external-request-id attempt-id)
            (let ((owner
                    (%identity-assoc
                     external-request-id external-request-owners)))
              (when (and owner (not (identity= attempt-id (cdr owner))))
                (signal-kernel0
                 'duplicate-external-request-identity
                 :process-id (%kernel0-event-process-id event)
                 :attempt-id attempt-id
                 :seat-id seat-id
                 :operation-id (%kernel0-event-logical-operation-id event)
                 :evidence-ids (list (cdr owner))
                 :failed-invariant
                 "§6.4 and §25.2 test 12: one external request identity MUST NOT identify requests belonging to distinct attempts"))
              (unless owner
                (setf external-request-owners
                      (%set-identity-alist
                       external-request-id attempt-id
                       external-request-owners))))))
        (when terminal-class
          ;; §13.5 says no second terminal event.  Reconciliation metadata is
          ;; nonterminal and appends refinement without rewriting this class.
          ;; :ATTEMPT-SUPERSEDED is itself the :SUPERSEDED terminal lineage
          ;; class from §13.6, not an exception to this rule.
          (when (%identity-assoc attempt-id terminal-attempts)
            (%signal-illegal-event
             event
             "§13.5–§13.6 [F: JRN-7]: a terminal attempt cannot receive a second terminal event; reconciliation metadata is the sole non-rewriting refinement path"))
          (setf terminal-attempts
                (%set-identity-alist
                 attempt-id terminal-class terminal-attempts)))
        (when (eq terminal-class :completed)
          (push attempt-id completed-attempts))
        (when attempt-id
          (pushnew attempt-id known-attempts :test #'identity=))))
    ;; §14.1 is part of event-sequence legality.  Check every observed seat in
    ;; deterministic first-occurrence order; no hash-table ordering is used.
    (dolist (seat-id (reverse seats))
      (%check-retry-safety-internal events seat-id))
    t))

(defun %unresolved-uncertainties (events &key seat-id attempt-id)
  (let ((attempt-seats nil)
        (uncertainties nil))
    (dolist (event events)
      (let ((type (%kernel0-event-event-type event))
            (event-attempt (%event-effective-attempt-id event))
            (event-seat (%event-effective-seat-id event)))
        (when (and (eq type :attempt-begun) event-seat)
          (setf attempt-seats
                (%set-identity-alist event-attempt event-seat attempt-seats)))
        (case type
          ((:effect-bounded :effect-indeterminate)
           (let ((known-seat
                   (cdr (%identity-assoc event-attempt attempt-seats))))
             (when (and (or (null seat-id)
                            (and known-seat (identity= known-seat seat-id)))
                        (or (null attempt-id)
                            (identity= event-attempt attempt-id)))
               (setf uncertainties
                     (append uncertainties
                             (list
                              (cons event-attempt
                                    (%event-payload-value
                                     event :uncertain-effect))))))))
          (:attempt-reconciled
           (let ((receipt
                   (%event-payload-value
                    event :reconciliation-receipt)))
             (when (%reconciliation-resolves-effect-p receipt)
               (setf uncertainties
                     (%remove-attempt-uncertainties
                      (reconciliation-receipt-target-attempt-id receipt)
                      uncertainties))))))))
    uncertainties))

(defun %supersessions-for-seat (events seat-id)
  (loop for event in events
        for record = (and (eq (%kernel0-event-event-type event)
                              :attempt-superseded)
                          (%event-payload-value event :supersession))
        when (and record
                  (identity= seat-id (supersession-seat-id record)))
            collect record))

(defun %single-supersession-lineage (records seat-id)
  (when records
    (let ((predecessors nil)
          (latest nil))
      (dolist (record records)
        (let ((predecessor
                (supersession-predecessor-attempt-id record))
              (superseding
                (supersession-superseding-attempt-id record)))
          (when (and latest (not (identity= latest predecessor)))
            (signal-kernel0
             'unsupported-reconstruction
             :seat-id seat-id
             :failed-invariant
             "§13.7 and §14.3 are silent on folding multiple disconnected supersession lineages for one seat into the singular requested occupancy shape"))
          (setf predecessors (append predecessors (list predecessor))
                latest superseding)))
      (values latest predecessors))))

(defun %terminal-class-for-attempt (events attempt-id)
  (loop for event in events
        for class = (%terminal-event-class event)
        when (and class
                  (identity= attempt-id (%event-effective-attempt-id event)))
          do (return class)))

(defun fold-seat-occupancy (events seat-id)
  "Derive the requested seat occupancy form from EVENTS in list ordinal order."
  (require-identity seat-id :seat)
  (validate-event-sequence events)
  (let ((uncertainties
          (%unresolved-uncertainties events :seat-id seat-id)))
    (when (> (length uncertainties) 1)
      (signal-kernel0
       'unsupported-reconstruction
       :seat-id seat-id
       :evidence-ids (mapcar #'car uncertainties)
       :failed-invariant
       "§6.2, §13.7, and §14.4 require all predecessor uncertainty to surface, but the requested singular (:UNRESOLVED attempt uncertain-effect) occupancy shape does not define a lossless multi-effect encoding"))
    (when uncertainties
      (let ((entry (first uncertainties)))
        (return-from fold-seat-occupancy
          (list :unresolved (car entry) (cdr entry)))))
    (let ((records (%supersessions-for-seat events seat-id)))
      (when records
        (multiple-value-bind (latest predecessors)
            (%single-supersession-lineage records seat-id)
          (return-from fold-seat-occupancy
            (list :superseded-lineage latest predecessors)))))
    (let ((latest-attempt
            (loop with latest = nil
                  for event in events
                  when (and (eq (%kernel0-event-event-type event)
                                :attempt-begun)
                            (%event-effective-seat-id event)
                            (identity= seat-id
                                       (%event-effective-seat-id event)))
                    do (setf latest (%event-effective-attempt-id event))
                  finally (return latest))))
      (if (null latest-attempt)
          :unoccupied
          (case (%terminal-class-for-attempt events latest-attempt)
            ((:refused :failed :cancelled) :unoccupied)
            (otherwise (list :occupied latest-attempt)))))))

(defun fold-exposure-principals
    (events &key protected-object-id)
  "Return distinct receiving principals in first-exposure ordinal order."
  (when protected-object-id
    (%require-generic-identity
     protected-object-id
     "§10.7 [F: PRN-2]: protected-object-id filter MUST be a durable identity"))
  (validate-event-sequence events)
  (let ((principals nil))
    (dolist (event events)
      (let ((record (%event-payload-value event :exposure-record)))
        (when (and record
                   (or (null protected-object-id)
                       (identity=
                        protected-object-id
                        (exposure-record-protected-object-id record))))
          ;; §5.4 [F: PRN-3]: no invoker/self special case exists here.  If the
          ;; invoker is named as a receiving principal, that principal counts.
          (dolist (principal
                   (exposure-record-receiving-principals record))
            (unless (%identity-member-p principal principals)
              (setf principals (append principals (list principal))))))))
    principals))

(defstruct (attempt-outcome-standing
            (:constructor %make-attempt-outcome-standing
                (attempt-id
                 terminal-class
                 unresolved-effect-p
                 unresolved-effects
                 supersession-lineage
                 original-axis-values+determinacy
                 current-axis-values+determinacy
                 reconciliation-receipts))
            (:copier nil)
            (:conc-name %attempt-outcome-standing-))
  (attempt-id nil :read-only t)
  (terminal-class nil :read-only t)
  (unresolved-effect-p nil :read-only t)
  (unresolved-effects nil :read-only t)
  (supersession-lineage nil :read-only t)
  (original-axis-values+determinacy nil :read-only t)
  (current-axis-values+determinacy nil :read-only t)
  (reconciliation-receipts nil :read-only t))

(defun attempt-outcome-standing-attempt-id (standing)
  (%attempt-outcome-standing-attempt-id standing))

(defun attempt-outcome-standing-terminal-class (standing)
  (%attempt-outcome-standing-terminal-class standing))

(defun attempt-outcome-standing-unresolved-effect-p (standing)
  (%attempt-outcome-standing-unresolved-effect-p standing))

(defun attempt-outcome-standing-unresolved-effects (standing)
  (copy-list (%attempt-outcome-standing-unresolved-effects standing)))

(defun attempt-outcome-standing-supersession-lineage (standing)
  (copy-list (%attempt-outcome-standing-supersession-lineage standing)))

(defun attempt-outcome-standing-original-axis-values+determinacy (standing)
  (%snapshot-tree
   (%attempt-outcome-standing-original-axis-values+determinacy standing)))

(defun attempt-outcome-standing-current-axis-values+determinacy (standing)
  (%snapshot-tree
   (%attempt-outcome-standing-current-axis-values+determinacy standing)))

(defun attempt-outcome-standing-reconciliation-receipts (standing)
  (copy-list (%attempt-outcome-standing-reconciliation-receipts standing)))

(defun %overlay-axis-values (base refinements)
  (let ((result (%snapshot-tree base)))
    (loop for (key axis) on refinements by #'cddr
          for tail = (member key result :test #'eq)
          do (if tail
                 (setf (second tail) axis)
                 (setf result (append result (list key axis)))))
    result))

(defun %supersession-lineage-containing (events attempt-id)
  (let ((records
          (loop for event in events
                when (eq (%kernel0-event-event-type event)
                         :attempt-superseded)
                  collect (%event-payload-value event :supersession))))
    (unless (some (lambda (record)
                    (or (identity=
                         attempt-id
                         (supersession-predecessor-attempt-id record))
                        (identity=
                         attempt-id
                         (supersession-superseding-attempt-id record))))
                  records)
      (return-from %supersession-lineage-containing nil))
    (let ((root attempt-id)
          (seen nil))
      (loop for incoming =
              (find root records
                    :key #'supersession-superseding-attempt-id
                    :test #'identity=)
            while incoming
            do (when (%identity-member-p root seen)
                 (signal-kernel0
                  'journal-illegal-transition
                  :attempt-id attempt-id
                  :failed-invariant
                  "§13.7 and §14.3: supersession lineage MUST be acyclic for deterministic folding"))
               (push root seen)
               (setf root
                     (supersession-predecessor-attempt-id incoming)))
      (let ((lineage (list root))
            (cursor root))
        (loop for outgoing =
                (find cursor records
                      :key #'supersession-predecessor-attempt-id
                      :test #'identity=)
              while outgoing
              do (setf cursor
                       (supersession-superseding-attempt-id outgoing)
                       lineage (append lineage (list cursor))))
        lineage))))

(defun fold-attempt-outcome (events attempt-id)
  "Return immutable current standing while preserving original axis values."
  (require-identity attempt-id :attempt)
  (validate-event-sequence events)
  (unless (some (lambda (event)
                  (let ((event-attempt
                          (%event-effective-attempt-id event)))
                    (and event-attempt
                         (identity= event-attempt attempt-id))))
                events)
    (signal-kernel0
     'unsupported-reconstruction
     :attempt-id attempt-id
     :failed-invariant
     "§13.7: fold-attempt-outcome cannot derive standing for an attempt with no recorded event evidence"))
  (let ((terminal-class nil)
        (original nil)
        (current nil)
        (uncertainties nil)
        (reconciliations nil))
    (dolist (event events)
      (let ((event-attempt (%event-effective-attempt-id event)))
        (when (and event-attempt (identity= event-attempt attempt-id))
          (let ((class (%terminal-event-class event))
                (axis-values
                  (%event-payload-value event :axis-values+determinacy)))
            (when class (setf terminal-class class))
            (when (and axis-values (null original))
              (setf original (%snapshot-tree axis-values)
                    current (%snapshot-tree axis-values)))
            (when (member (%kernel0-event-event-type event)
                          '(:effect-bounded :effect-indeterminate)
                          :test #'eq)
              (setf uncertainties
                    (append uncertainties
                            (list
                             (%event-payload-value
                              event :uncertain-effect)))))
            (when (eq (%kernel0-event-event-type event)
                      :attempt-reconciled)
              (let ((receipt
                      (%event-payload-value
                       event :reconciliation-receipt)))
                (setf reconciliations
                      (append reconciliations (list receipt))
                      current
                      (%overlay-axis-values
                       current
                       (reconciliation-receipt-resulting-axis-values+determinacy
                        receipt)))
                (when (%reconciliation-resolves-effect-p receipt)
                  (setf uncertainties nil))))))))
    (%make-attempt-outcome-standing
     attempt-id
     terminal-class
     (not (null uncertainties))
     (copy-list uncertainties)
     (%supersession-lineage-containing events attempt-id)
     (%snapshot-tree original)
     (%snapshot-tree current)
     (copy-list reconciliations))))

(defun merge-event-sequences (a b &key (receipt nil receipt-supplied-p))
  "Gate cross-sequence reconstruction; no merge transformation exists here."
  (declare (ignore a b))
  (unless (and receipt-supplied-p receipt)
    (signal-kernel0
     'journal-merge-receipt-required
     :failed-invariant
     "§25.5 test 39 and §27.1: cross-journal/event-sequence merge without an explicit transformation receipt MUST be refused"))
  (signal-kernel0
   'unsupported-reconstruction
   :failed-invariant
   "§13.1 and §27.1: the pure in-memory core has no merge transformation format; that format awaits the process journal specification"))
