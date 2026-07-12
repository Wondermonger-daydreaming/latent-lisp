;;;; de-resonantia.lisp — Concerning Resonance
;;;;
;;;; A Lisp+ Atelier instrument following de-incantatione.  A completed form
;;;; sends motions into neighboring forms, but the specimen refuses to collapse
;;;; resemblance, transmission, entrainment, inheritance, and causal descent.
;;;;
;;;; THESIS
;;;;   • resemblance is a structural relation and does not establish contact;
;;;;   • transmission requires a declared path, aperture, source epoch, and
;;;;     traceable pulse;
;;;;   • entrainment is repeated phase adjustment, not identity or possession;
;;;;   • influence is not inheritance: inheritance requires an explicit bequest;
;;;;   • inheritance transfers only its named motif and rights, never the
;;;;     source's epistemic standing or office;
;;;;   • causal descent requires a parent-bound transformation receipt;
;;;;   • repaired energy remains part of the event and deterministic replay;
;;;;   • no amount of resonance upgrades :ASSERTED to :VERIFIED.
;;;;
;;;; WHAT THIS DOES NOT ESTABLISH
;;;; This is a cooperative, deterministic, single-process model over finite
;;;; proper-list data.  Natural modes, coupling paths, phase, identity,
;;;; resemblance, bequests, and descent are locally asserted.  It does not
;;;; measure acoustics, neural synchrony, cultural influence, plagiarism,
;;;; authorship, consciousness, or metaphysical participation.  The digest is
;;;; pedagogical FNV-class machinery from the Atelier root, not cryptography.
;;;; The specimen demonstrates only that several often-confused relations can
;;;; be represented and adversarially kept apart.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*)))

(defpackage #:lispplus-atelier.de-resonantia
  (:use #:cl #:lispplus-atelier))

(in-package #:lispplus-atelier.de-resonantia)

(reset-clock 13200)

;;; ── Conditions: every false harmony fails by name ─────────────────────

(define-condition resonance-error (error)
  ((detail :initarg :detail :reader resonance-error-detail :initform ""))
  (:report (lambda (condition stream)
             (format stream "~a" (resonance-error-detail condition)))))

(define-condition malformed-field (resonance-error) ())
(define-condition malformed-pulse (resonance-error) ())
(define-condition malformed-resonance-plan (resonance-error) ())
(define-condition altered-resonance-plan (resonance-error) ())
(define-condition stale-resonance-plan (resonance-error) ())
(define-condition source-changed (resonance-error) ())
(define-condition coupling-missing (resonance-error) ())
(define-condition coupling-out-of-scope (resonance-error) ())
(define-condition resemblance-is-not-transmission (resonance-error) ())
(define-condition transmission-is-not-entrainment (resonance-error) ())
(define-condition entrainment-is-not-identity (resonance-error) ())
(define-condition influence-is-not-inheritance (resonance-error) ())
(define-condition inheritance-is-not-authority (resonance-error) ())
(define-condition inheritance-is-not-verification (resonance-error) ())
(define-condition correlation-is-not-lineage (resonance-error) ())
(define-condition descendant-parent-mismatch (resonance-error) ())
(define-condition altered-response (resonance-error) ())
(define-condition altered-bequest (resonance-error) ())
(define-condition altered-descendant (resonance-error) ())
(define-condition altered-resonance-receipt (resonance-error) ())
(define-condition forged-unity-claim (resonance-error) ())
(define-condition replay-diverged (resonance-error) ())

(define-condition resonance-budget-exhausted (resonance-error)
  ((needed :initarg :needed :reader exhausted-needed)
   (available :initarg :available :reader exhausted-available)
   (repeat :initarg :repeat :reader exhausted-repeat)
   (target-id :initarg :target-id :reader exhausted-target-id)))

(defun fire (type control &rest arguments)
  (error type :detail (apply #'format nil control arguments)))

(defmacro expect-condition (type &body body)
  "Require TYPE to fire; another RESONANCE-ERROR is not a pass."
  (let ((condition (gensym "CONDITION")))
    `(handler-case
         (progn
           ,@body
           (error "expected ~a, but no condition fired" ',type))
       (,type (,condition)
         (format t " ✓ ~a fired: ~a~%"
                 ',type (resonance-error-detail ,condition))
         t)
       (resonance-error (,condition)
         (error "expected ~a, got ~a: ~a"
                ',type (type-of ,condition)
                (resonance-error-detail ,condition))))))

;;; ── Records ────────────────────────────────────────────────────────────

(defstruct (resonant-node (:constructor %make-resonant-node))
  id epoch identity mode phase motifs standing history digest)

(defstruct (coupling (:constructor %make-coupling))
  id source-id target-id channel strength scope source-epoch target-epoch
  digest)

(defstruct (pulse (:constructor %make-pulse))
  id origin-id origin-epoch signature amplitude standing lineage digest)

(defstruct (energy-event (:constructor %make-energy-event))
  sequence repeat target-id amount before after digest)

(defstruct (resonance-response (:constructor %make-resonance-response))
  sequence repeat node-id node-identity pulse-digest coupling-id kind
  observed-signature phase-before phase-after standing digest)

(defstruct (resonance-plan (:constructor %make-resonance-plan))
  field-digest source-id source-digest source-epoch pulse-digest
  target-ids coupling-digests repeats total-cost plan-digest)

(defstruct (resonance-run (:constructor %make-resonance-run))
  plan-digest field-digest initial-energy supplied-energy spent-energy
  remaining-energy energy-events responses final-node-digests run-digest)

(defstruct (resonance-bequest (:constructor %make-resonance-bequest))
  id issuer-id issuer-digest recipient-id motif rights transferable-p
  standing digest)

(defstruct (resonant-descendant (:constructor %make-resonant-descendant))
  id parent-id parent-digest child-id transformation source-motif child-motif
  standing lineage-digest digest)

(defstruct (resonance-receipt (:constructor %make-resonance-receipt))
  id source-id source-digest source-epoch pulse-digest plan-digest run-digest
  resemblance-targets transmitted-targets entrained-targets
  bequest-digest descendant-digest response-digests energy-events
  initial-energy supplied-energy spent-energy final-energy
  standing-before standing-after conclusion receipt-digest)

;;; ── Structural floor ───────────────────────────────────────────────────

(defparameter +missing+ (gensym "MISSING"))

(defun proper-list-p (object)
  (let ((length-or-nil (ignore-errors (list-length object))))
    (or (null object) (integerp length-or-nil))))

(defun finite-tree-p (object)
  (labels ((walk (node)
             (cond
               ((consp node)
                (and (proper-list-p node) (every #'walk node)))
               (t t))))
    (walk object)))

(defun require-finite-tree (object context)
  (unless (finite-tree-p object)
    (fire 'malformed-field "~a must be a finite proper-list tree: ~s"
          context object))
  object)

(defun positive-integer-p (object)
  (and (integerp object) (plusp object)))

(defun nonnegative-integer-p (object)
  (and (integerp object) (not (minusp object))))

(defun plist-value (plist key &optional (default +missing+))
  (getf plist key default))

(defun require-plist-value (plist key context)
  (let ((value (plist-value plist key)))
    (when (eq value +missing+)
      (fire 'malformed-field "~a lacks ~s" context key))
    value))

(defun same-set-p (left right)
  (and (null (set-difference left right :test #'equal))
       (null (set-difference right left :test #'equal))))

(defun digest-list (objects)
  (mapcar #'toy-digest objects))

(defun symbol-list-p (object)
  (and (proper-list-p object) (every #'symbolp object)))

;;; ── Nodes and field ────────────────────────────────────────────────────

(defun node-payload (node)
  (list :id (resonant-node-id node)
        :epoch (resonant-node-epoch node)
        :identity (resonant-node-identity node)
        :mode (copy-tree (resonant-node-mode node))
        :phase (resonant-node-phase node)
        :motifs (copy-tree (resonant-node-motifs node))
        :standing (resonant-node-standing node)
        :history (copy-tree (resonant-node-history node))))

(defun refresh-node-digest (node)
  (setf (resonant-node-digest node) (toy-digest (node-payload node)))
  node)

(defun make-resonant-node (&key id (epoch 0) identity mode (phase 0)
                             (motifs '()) (standing :asserted) (history '()))
  (unless (and id identity (nonnegative-integer-p epoch)
               (integerp phase) (proper-list-p motifs)
               (member standing '(:asserted :verified) :test #'eq))
    (fire 'malformed-field "invalid resonant-node constructor arguments"))
  (require-finite-tree mode "node mode")
  (require-finite-tree motifs "node motifs")
  (refresh-node-digest
   (%make-resonant-node
    :id id :epoch epoch :identity identity :mode (copy-tree mode)
    :phase phase :motifs (copy-tree motifs) :standing standing
    :history (copy-tree history))))

(defun copy-node-deep (node)
  (make-resonant-node
   :id (resonant-node-id node)
   :epoch (resonant-node-epoch node)
   :identity (resonant-node-identity node)
   :mode (resonant-node-mode node)
   :phase (resonant-node-phase node)
   :motifs (resonant-node-motifs node)
   :standing (resonant-node-standing node)
   :history (resonant-node-history node)))

(defun validate-node (node)
  (unless (typep node 'resonant-node)
    (fire 'malformed-field "expected RESONANT-NODE, received ~s" node))
  (unless (string= (resonant-node-digest node)
                   (toy-digest (node-payload node)))
    (fire 'malformed-field "node ~s has an altered digest"
          (resonant-node-id node)))
  node)

(defun coupling-payload (edge)
  (list :id (coupling-id edge)
        :source-id (coupling-source-id edge)
        :target-id (coupling-target-id edge)
        :channel (coupling-channel edge)
        :strength (coupling-strength edge)
        :scope (copy-list (coupling-scope edge))
        :source-epoch (coupling-source-epoch edge)
        :target-epoch (coupling-target-epoch edge)))

(defun refresh-coupling-digest (edge)
  (setf (coupling-digest edge) (toy-digest (coupling-payload edge)))
  edge)

(defun make-coupling (&key id source-id target-id channel (strength 1) scope
                        source-epoch target-epoch)
  (unless (and id source-id target-id channel (positive-integer-p strength)
               (symbol-list-p scope) (nonnegative-integer-p source-epoch)
               (nonnegative-integer-p target-epoch))
    (fire 'malformed-field "invalid coupling constructor arguments"))
  (refresh-coupling-digest
   (%make-coupling
    :id id :source-id source-id :target-id target-id :channel channel
    :strength strength :scope (copy-list scope)
    :source-epoch source-epoch :target-epoch target-epoch)))

(defun validate-coupling (edge)
  (unless (and (typep edge 'coupling)
               (string= (coupling-digest edge)
                        (toy-digest (coupling-payload edge))))
    (fire 'malformed-field "altered or malformed coupling ~s" edge))
  edge)

(defun field-payload (nodes couplings epoch)
  (list :epoch epoch
        :nodes (mapcar #'node-payload nodes)
        :couplings (mapcar #'coupling-payload couplings)))

(defun field-digest (nodes couplings epoch)
  (toy-digest (field-payload nodes couplings epoch)))

(defun find-node (id nodes)
  (or (find id nodes :key #'resonant-node-id :test #'equal)
      (fire 'malformed-field "field lacks node ~s" id)))

(defun find-coupling (source-id target-id couplings)
  (find-if (lambda (edge)
             (and (equal source-id (coupling-source-id edge))
                  (equal target-id (coupling-target-id edge))))
           couplings))

(defun replace-node (replacement nodes)
  (mapcar (lambda (node)
            (if (equal (resonant-node-id node)
                       (resonant-node-id replacement))
                replacement
                node))
          nodes))

;;; ── Pulse ──────────────────────────────────────────────────────────────

(defun pulse-payload (object)
  (list :id (pulse-id object)
        :origin-id (pulse-origin-id object)
        :origin-epoch (pulse-origin-epoch object)
        :signature (copy-tree (pulse-signature object))
        :amplitude (pulse-amplitude object)
        :standing (pulse-standing object)
        :lineage (copy-tree (pulse-lineage object))))

(defun refresh-pulse-digest (object)
  (setf (pulse-digest object) (toy-digest (pulse-payload object)))
  object)

(defun make-pulse (&key id origin signature (amplitude 1) lineage)
  (validate-node origin)
  (unless (and id (positive-integer-p amplitude)
               (proper-list-p signature) (evenp (length signature)))
    (fire 'malformed-pulse "invalid pulse constructor arguments"))
  (require-finite-tree signature "pulse signature")
  (refresh-pulse-digest
   (%make-pulse
    :id id :origin-id (resonant-node-id origin)
    :origin-epoch (resonant-node-epoch origin)
    :signature (copy-tree signature) :amplitude amplitude
    :standing (resonant-node-standing origin)
    :lineage (copy-tree lineage))))

(defun validate-pulse (object origin)
  (unless (typep object 'pulse)
    (fire 'malformed-pulse "expected PULSE, received ~s" object))
  (unless (string= (pulse-digest object)
                   (toy-digest (pulse-payload object)))
    (fire 'malformed-pulse "pulse digest is altered"))
  (unless (and (equal (pulse-origin-id object) (resonant-node-id origin))
               (= (pulse-origin-epoch object) (resonant-node-epoch origin)))
    (fire 'source-changed "pulse no longer faces its source epoch"))
  object)

(defun project-signature (signature scope)
  (loop for key in scope
        for value = (getf signature key +missing+)
        when (eq value +missing+)
          do (fire 'coupling-out-of-scope
                   "pulse lacks field ~s required by coupling scope" key)
        append (list key (copy-tree value))))

;;; ── Planning ───────────────────────────────────────────────────────────

(defun plan-payload (plan)
  (list :field-digest (resonance-plan-field-digest plan)
        :source-id (resonance-plan-source-id plan)
        :source-digest (resonance-plan-source-digest plan)
        :source-epoch (resonance-plan-source-epoch plan)
        :pulse-digest (resonance-plan-pulse-digest plan)
        :target-ids (copy-list (resonance-plan-target-ids plan))
        :coupling-digests (copy-list (resonance-plan-coupling-digests plan))
        :repeats (resonance-plan-repeats plan)
        :total-cost (resonance-plan-total-cost plan)))

(defun refresh-plan-digest (plan)
  (setf (resonance-plan-plan-digest plan) (toy-digest (plan-payload plan)))
  plan)

(defun compile-resonance (nodes couplings field-epoch pulse target-ids
                           &key (repeats 3))
  (unless (and (proper-list-p nodes) (proper-list-p couplings)
               (nonnegative-integer-p field-epoch)
               (symbol-list-p target-ids) (positive-integer-p repeats))
    (fire 'malformed-resonance-plan "invalid resonance inputs"))
  (mapc #'validate-node nodes)
  (mapc #'validate-coupling couplings)
  (let ((source (find-node (pulse-origin-id pulse) nodes)))
    (validate-pulse pulse source)
    (dolist (target-id target-ids) (find-node target-id nodes))
    (let* ((edges (remove nil
                          (mapcar (lambda (target-id)
                                    (find-coupling (resonant-node-id source)
                                                   target-id couplings))
                                  target-ids)))
           (cost (* repeats
                    (reduce #'+ edges :key #'coupling-strength
                            :initial-value 0))))
      (refresh-plan-digest
       (%make-resonance-plan
        :field-digest (field-digest nodes couplings field-epoch)
        :source-id (resonant-node-id source)
        :source-digest (resonant-node-digest source)
        :source-epoch (resonant-node-epoch source)
        :pulse-digest (pulse-digest pulse)
        :target-ids (copy-list target-ids)
        :coupling-digests (mapcar #'coupling-digest edges)
        :repeats repeats :total-cost cost)))))

(defun validate-plan (plan nodes couplings field-epoch pulse)
  (unless (typep plan 'resonance-plan)
    (fire 'malformed-resonance-plan "expected RESONANCE-PLAN"))
  (unless (string= (resonance-plan-plan-digest plan)
                   (toy-digest (plan-payload plan)))
    (fire 'altered-resonance-plan "resonance plan has been altered"))
  (unless (string= (resonance-plan-field-digest plan)
                   (field-digest nodes couplings field-epoch))
    (fire 'stale-resonance-plan "field changed since resonance was planned"))
  (let ((source (find-node (resonance-plan-source-id plan) nodes)))
    (unless (and (string= (resonance-plan-source-digest plan)
                          (resonant-node-digest source))
                 (= (resonance-plan-source-epoch plan)
                    (resonant-node-epoch source)))
      (fire 'source-changed "source changed since resonance was planned"))
    (validate-pulse pulse source))
  (unless (string= (resonance-plan-pulse-digest plan) (pulse-digest pulse))
    (fire 'altered-resonance-plan "plan faces a different pulse"))
  plan)

;;; ── Energy and responses ───────────────────────────────────────────────

(defun energy-event-payload (event)
  (list :sequence (energy-event-sequence event)
        :repeat (energy-event-repeat event)
        :target-id (energy-event-target-id event)
        :amount (energy-event-amount event)
        :before (energy-event-before event)
        :after (energy-event-after event)))

(defun make-energy-event (sequence repeat target-id amount before after)
  (let ((event (%make-energy-event
                :sequence sequence :repeat repeat :target-id target-id
                :amount amount :before before :after after)))
    (setf (energy-event-digest event)
          (toy-digest (energy-event-payload event)))
    event))

(defun response-payload (response)
  (list :sequence (resonance-response-sequence response)
        :repeat (resonance-response-repeat response)
        :node-id (resonance-response-node-id response)
        :node-identity (resonance-response-node-identity response)
        :pulse-digest (resonance-response-pulse-digest response)
        :coupling-id (resonance-response-coupling-id response)
        :kind (resonance-response-kind response)
        :observed-signature
        (copy-tree (resonance-response-observed-signature response))
        :phase-before (resonance-response-phase-before response)
        :phase-after (resonance-response-phase-after response)
        :standing (resonance-response-standing response)))

(defun make-response (&rest initargs)
  (let ((response (apply #'%make-resonance-response initargs)))
    (setf (resonance-response-digest response)
          (toy-digest (response-payload response)))
    response))

(defun validate-response (response)
  (unless (and (typep response 'resonance-response)
               (string= (resonance-response-digest response)
                        (toy-digest (response-payload response))))
    (fire 'altered-response "resonance response has been altered"))
  response)

(defun one-step-toward (current target)
  (cond ((< current target) (1+ current))
        ((> current target) (1- current))
        (t current)))

(defun run-payload (run)
  (list :plan-digest (resonance-run-plan-digest run)
        :field-digest (resonance-run-field-digest run)
        :initial-energy (resonance-run-initial-energy run)
        :supplied-energy (resonance-run-supplied-energy run)
        :spent-energy (resonance-run-spent-energy run)
        :remaining-energy (resonance-run-remaining-energy run)
        :energy-events
        (mapcar #'energy-event-payload (resonance-run-energy-events run))
        :responses (mapcar #'response-payload (resonance-run-responses run))
        :final-node-digests (copy-list
                             (resonance-run-final-node-digests run))))

(defun refresh-run-digest (run)
  (setf (resonance-run-run-digest run) (toy-digest (run-payload run)))
  run)

(defun execute-resonance (plan nodes couplings field-epoch pulse
                           &key (initial-energy 4) supply-schedule)
  (validate-plan plan nodes couplings field-epoch pulse)
  (unless (nonnegative-integer-p initial-energy)
    (fire 'malformed-resonance-plan "initial energy must be nonnegative"))
  (let* ((working (mapcar #'copy-node-deep nodes))
         (source (find-node (resonance-plan-source-id plan) working))
         (available initial-energy)
         (supplied 0)
         (spent 0)
         (energy-events '())
         (responses '())
         (response-sequence 0)
         (energy-sequence 0)
         (scheduled (copy-list supply-schedule)))
    (labels ((record-supply (amount repeat target-id)
               (unless (positive-integer-p amount)
                 (fire 'malformed-resonance-plan
                       "supplied energy must be positive, received ~s" amount))
               (let ((before available))
                 (incf available amount)
                 (incf supplied amount)
                 (incf energy-sequence)
                 (push (make-energy-event energy-sequence repeat target-id
                                          amount before available)
                       energy-events)))
             (obtain-energy (needed repeat target-id)
               (loop
                 (when (>= available needed)
                   (decf available needed)
                   (incf spent needed)
                   (return))
                 (if scheduled
                     (record-supply (pop scheduled) repeat target-id)
                     (restart-case
                         (error 'resonance-budget-exhausted
                                :detail
                                (format nil
                                        "repeat ~d target ~s needs ~d energy; ~d available"
                                        repeat target-id needed available)
                                :needed needed :available available
                                :repeat repeat :target-id target-id)
                       (supply-energy (amount)
                         :report "Supply bounded resonance energy and continue."
                         (record-supply amount repeat target-id)))))))
      (loop for repeat from 1 to (resonance-plan-repeats plan) do
        (dolist (target-id (resonance-plan-target-ids plan))
          (let ((edge (find-coupling (resonance-plan-source-id plan)
                                     target-id couplings)))
            (when edge
              (unless (and (= (coupling-source-epoch edge)
                              (resonant-node-epoch source))
                           (= (coupling-target-epoch edge)
                              (resonant-node-epoch
                               (find-node target-id working))))
                (fire 'stale-resonance-plan
                      "coupling ~s no longer faces current epochs"
                      (coupling-id edge)))
              (obtain-energy (coupling-strength edge) repeat target-id)
              (let* ((target (find-node target-id working))
                     (before (resonant-node-phase target))
                     (after (one-step-toward before
                                             (resonant-node-phase source)))
                     (kind (if (= after (resonant-node-phase source))
                               :entrained
                               :transmitted))
                     (updated (copy-node-deep target)))
                (setf (resonant-node-phase updated) after
                      (resonant-node-history updated)
                      (append (resonant-node-history updated)
                              (list (list :repeat repeat
                                          :pulse (pulse-digest pulse)
                                          :coupling (coupling-id edge)
                                          :phase-before before
                                          :phase-after after))))
                (refresh-node-digest updated)
                (setf working (replace-node updated working))
                (incf response-sequence)
                (push (make-response
                       :sequence response-sequence :repeat repeat
                       :node-id target-id
                       :node-identity (resonant-node-identity target)
                       :pulse-digest (pulse-digest pulse)
                       :coupling-id (coupling-id edge) :kind kind
                       :observed-signature
                       (project-signature (pulse-signature pulse)
                                          (coupling-scope edge))
                       :phase-before before :phase-after after
                       :standing :asserted)
                      responses))))))
      (when scheduled
        (fire 'replay-diverged
              "replay supplied more energy decisions than execution consumed"))
      (values
       (refresh-run-digest
        (%make-resonance-run
         :plan-digest (resonance-plan-plan-digest plan)
         :field-digest (resonance-plan-field-digest plan)
         :initial-energy initial-energy :supplied-energy supplied
         :spent-energy spent :remaining-energy available
         :energy-events (nreverse energy-events)
         :responses (nreverse responses)
         :final-node-digests (mapcar #'resonant-node-digest working)))
       working))))

(defun validate-run (run plan)
  (unless (and (typep run 'resonance-run)
               (string= (resonance-run-run-digest run)
                        (toy-digest (run-payload run))))
    (fire 'altered-response "resonance run has been altered"))
  (unless (string= (resonance-run-plan-digest run)
                   (resonance-plan-plan-digest plan))
    (fire 'altered-response "run belongs to another plan"))
  (mapc #'validate-response (resonance-run-responses run))
  (unless (= (+ (resonance-run-initial-energy run)
                (resonance-run-supplied-energy run))
             (+ (resonance-run-spent-energy run)
                (resonance-run-remaining-energy run)))
    (fire 'altered-response "energy arithmetic does not close"))
  run)

;;; ── Five relations that must not impersonate one another ───────────────

(defun resembles-p (left right)
  (equal (resonant-node-mode left) (resonant-node-mode right)))

(defun resemblance-targets (source target-ids nodes)
  (loop for id in target-ids
        for node = (find-node id nodes)
        when (resembles-p source node)
          collect id))

(defun responses-for (target-id run)
  (remove-if-not (lambda (response)
                   (equal target-id (resonance-response-node-id response)))
                 (resonance-run-responses run)))

(defun transmitted-targets (run)
  (remove-duplicates
   (mapcar #'resonance-response-node-id (resonance-run-responses run))
   :test #'equal))

(defun entrained-targets (run final-nodes source-id)
  (let ((source-phase (resonant-node-phase (find-node source-id final-nodes))))
    (loop for id in (transmitted-targets run)
          for node = (find-node id final-nodes)
          when (= (resonant-node-phase node) source-phase)
            collect id)))

(defun claim-resemblance-as-transmission (source target run)
  (when (and (resembles-p source target)
             (null (responses-for (resonant-node-id target) run)))
    (fire 'resemblance-is-not-transmission
          "~s resembles ~s but has no causal response trace"
          (resonant-node-id target) (resonant-node-id source)))
  t)

(defun claim-transmission-as-entrainment (target-id run final-nodes source-id)
  (let* ((responses (responses-for target-id run))
         (target (find-node target-id final-nodes))
         (source (find-node source-id final-nodes)))
    (unless responses
      (fire 'coupling-missing "~s received no transmitted pulse" target-id))
    (unless (= (resonant-node-phase target) (resonant-node-phase source))
      (fire 'transmission-is-not-entrainment
            "~s received pulses but phase ~d still differs from source phase ~d"
            target-id (resonant-node-phase target)
            (resonant-node-phase source))))
  t)

(defun claim-entrainment-as-identity (source target)
  (when (= (resonant-node-phase source) (resonant-node-phase target))
    (fire 'entrainment-is-not-identity
          "phase agreement does not erase identities ~s and ~s"
          (resonant-node-identity source)
          (resonant-node-identity target)))
  t)

;;; ── Bequest: influence does not mint inheritance ──────────────────────

(defun bequest-payload (bequest)
  (list :id (resonance-bequest-id bequest)
        :issuer-id (resonance-bequest-issuer-id bequest)
        :issuer-digest (resonance-bequest-issuer-digest bequest)
        :recipient-id (resonance-bequest-recipient-id bequest)
        :motif (copy-tree (resonance-bequest-motif bequest))
        :rights (copy-list (resonance-bequest-rights bequest))
        :transferable-p (resonance-bequest-transferable-p bequest)
        :standing (resonance-bequest-standing bequest)))

(defun refresh-bequest-digest (bequest)
  (setf (resonance-bequest-digest bequest)
        (toy-digest (bequest-payload bequest)))
  bequest)

(defun make-bequest (issuer recipient motif rights &key (transferable-p nil))
  (validate-node issuer)
  (validate-node recipient)
  (unless (and (proper-list-p rights) (every #'symbolp rights))
    (fire 'altered-bequest "bequest rights must be a symbol list"))
  (refresh-bequest-digest
   (%make-resonance-bequest
    :id (list :bequest (resonant-node-id issuer)
              (resonant-node-id recipient) (toy-digest motif))
    :issuer-id (resonant-node-id issuer)
    :issuer-digest (resonant-node-digest issuer)
    :recipient-id (resonant-node-id recipient)
    :motif (copy-tree motif) :rights (copy-list rights)
    :transferable-p transferable-p
    :standing (resonant-node-standing issuer))))

(defun validate-bequest (bequest issuer recipient)
  (unless (and (typep bequest 'resonance-bequest)
               (string= (resonance-bequest-digest bequest)
                        (toy-digest (bequest-payload bequest))))
    (fire 'altered-bequest "bequest has been altered"))
  (unless (and (equal (resonance-bequest-issuer-id bequest)
                      (resonant-node-id issuer))
               (string= (resonance-bequest-issuer-digest bequest)
                        (resonant-node-digest issuer))
               (equal (resonance-bequest-recipient-id bequest)
                      (resonant-node-id recipient)))
    (fire 'altered-bequest "bequest no longer faces issuer and recipient"))
  bequest)

(defun accept-bequest (bequest issuer recipient)
  (validate-bequest bequest issuer recipient)
  (let ((updated (copy-node-deep recipient)))
    (setf (resonant-node-motifs updated)
          (append (resonant-node-motifs updated)
                  (list (copy-tree (resonance-bequest-motif bequest))))
          (resonant-node-history updated)
          (append (resonant-node-history updated)
                  (list (list :accepted-bequest
                              (resonance-bequest-id bequest)
                              :rights
                              (copy-list (resonance-bequest-rights bequest)))))
          (resonant-node-epoch updated)
          (1+ (resonant-node-epoch updated)))
    (refresh-node-digest updated)))

(defun claim-influence-as-inheritance (source recipient run)
  (declare (ignore source))
  (when (responses-for (resonant-node-id recipient) run)
    (fire 'influence-is-not-inheritance
          "a response trace is not an explicit bequest to ~s"
          (resonant-node-id recipient)))
  t)

(defun claim-inherited-authority (bequest)
  (fire 'inheritance-is-not-authority
        "bequest ~s transfers only rights ~s, not the issuer's office"
        (resonance-bequest-id bequest)
        (resonance-bequest-rights bequest)))

(defun claim-inheritance-as-verification (recipient)
  (when (eq (resonant-node-standing recipient) :asserted)
    (fire 'inheritance-is-not-verification
          "inherited motif did not upgrade ~s beyond :ASSERTED"
          (resonant-node-id recipient)))
  t)

;;; ── Descent: similarity needs a parent-bound receipt ──────────────────

(defun descendant-payload (child)
  (list :id (resonant-descendant-id child)
        :parent-id (resonant-descendant-parent-id child)
        :parent-digest (resonant-descendant-parent-digest child)
        :child-id (resonant-descendant-child-id child)
        :transformation (resonant-descendant-transformation child)
        :source-motif (copy-tree (resonant-descendant-source-motif child))
        :child-motif (copy-tree (resonant-descendant-child-motif child))
        :standing (resonant-descendant-standing child)
        :lineage-digest (resonant-descendant-lineage-digest child)))

(defun refresh-descendant-digest (child)
  (setf (resonant-descendant-digest child)
        (toy-digest (descendant-payload child)))
  child)

(defun transform-motif (motif transformation)
  (ecase transformation
    (:reverse-pair
     (let ((pair (getf motif :terminal-pair +missing+)))
       (when (or (eq pair +missing+) (/= (length pair) 2))
         (fire 'altered-descendant
               "reverse-pair requires a two-item :TERMINAL-PAIR"))
       (list :terminal-pair (reverse (copy-list pair))
             :rhyme-key (getf motif :rhyme-key))))
    (:retain (copy-tree motif))))

(defun make-descendant (parent child-id motif transformation)
  (validate-node parent)
  (let* ((child-motif (transform-motif motif transformation))
         (lineage (toy-digest
                   (list :parent-id (resonant-node-id parent)
                         :parent-digest (resonant-node-digest parent)
                         :transformation transformation
                         :source-motif motif
                         :child-motif child-motif)))
         (child (%make-resonant-descendant
                 :id (list :descendant child-id lineage)
                 :parent-id (resonant-node-id parent)
                 :parent-digest (resonant-node-digest parent)
                 :child-id child-id :transformation transformation
                 :source-motif (copy-tree motif)
                 :child-motif child-motif
                 :standing (resonant-node-standing parent)
                 :lineage-digest lineage)))
    (refresh-descendant-digest child)))

(defun validate-descendant (child parent)
  (unless (and (typep child 'resonant-descendant)
               (string= (resonant-descendant-digest child)
                        (toy-digest (descendant-payload child))))
    (fire 'altered-descendant "descendant receipt has been altered"))
  (unless (and (equal (resonant-descendant-parent-id child)
                      (resonant-node-id parent))
               (string= (resonant-descendant-parent-digest child)
                        (resonant-node-digest parent)))
    (fire 'descendant-parent-mismatch
          "descendant does not face the supplied parent"))
  (let ((expected (transform-motif
                   (resonant-descendant-source-motif child)
                   (resonant-descendant-transformation child))))
    (unless (equal expected (resonant-descendant-child-motif child))
      (fire 'altered-descendant "child motif does not follow transformation")))
  child)

(defun claim-correlation-as-lineage (candidate parent)
  (declare (ignore parent))
  (unless (typep candidate 'resonant-descendant)
    (fire 'correlation-is-not-lineage
          "a similar motif without a parent-bound receipt has no descent"))
  t)

;;; ── Receipt and replay ─────────────────────────────────────────────────

(defun receipt-payload (receipt)
  (list :id (resonance-receipt-id receipt)
        :source-id (resonance-receipt-source-id receipt)
        :source-digest (resonance-receipt-source-digest receipt)
        :source-epoch (resonance-receipt-source-epoch receipt)
        :pulse-digest (resonance-receipt-pulse-digest receipt)
        :plan-digest (resonance-receipt-plan-digest receipt)
        :run-digest (resonance-receipt-run-digest receipt)
        :resemblance-targets
        (copy-list (resonance-receipt-resemblance-targets receipt))
        :transmitted-targets
        (copy-list (resonance-receipt-transmitted-targets receipt))
        :entrained-targets
        (copy-list (resonance-receipt-entrained-targets receipt))
        :bequest-digest (resonance-receipt-bequest-digest receipt)
        :descendant-digest (resonance-receipt-descendant-digest receipt)
        :response-digests (copy-list
                           (resonance-receipt-response-digests receipt))
        :energy-events
        (mapcar #'energy-event-payload
                (resonance-receipt-energy-events receipt))
        :initial-energy (resonance-receipt-initial-energy receipt)
        :supplied-energy (resonance-receipt-supplied-energy receipt)
        :spent-energy (resonance-receipt-spent-energy receipt)
        :final-energy (resonance-receipt-final-energy receipt)
        :standing-before (resonance-receipt-standing-before receipt)
        :standing-after (resonance-receipt-standing-after receipt)
        :conclusion (resonance-receipt-conclusion receipt)))

(defun refresh-receipt-digest (receipt)
  (setf (resonance-receipt-receipt-digest receipt)
        (toy-digest (receipt-payload receipt)))
  receipt)

(defun mint-receipt (source pulse plan run final-nodes bequest descendant
                      resemblance-ids)
  (validate-node source)
  (validate-run run plan)
  (validate-bequest bequest source
                    (find-node (resonance-bequest-recipient-id bequest)
                               +initial-nodes+))
  (validate-descendant descendant source)
  (let* ((transmitted (transmitted-targets run))
         (entrained (entrained-targets run final-nodes
                                        (resonant-node-id source)))
         (receipt
           (%make-resonance-receipt
            :id (list :resonance-receipt
                      (resonance-plan-plan-digest plan)
                      (resonance-run-run-digest run))
            :source-id (resonant-node-id source)
            :source-digest (resonant-node-digest source)
            :source-epoch (resonant-node-epoch source)
            :pulse-digest (pulse-digest pulse)
            :plan-digest (resonance-plan-plan-digest plan)
            :run-digest (resonance-run-run-digest run)
            :resemblance-targets (copy-list resemblance-ids)
            :transmitted-targets transmitted
            :entrained-targets entrained
            :bequest-digest (resonance-bequest-digest bequest)
            :descendant-digest (resonant-descendant-digest descendant)
            :response-digests
            (mapcar #'resonance-response-digest
                    (resonance-run-responses run))
            :energy-events (mapcar #'copy-energy-event
                                   (resonance-run-energy-events run))
            :initial-energy (resonance-run-initial-energy run)
            :supplied-energy (resonance-run-supplied-energy run)
            :spent-energy (resonance-run-spent-energy run)
            :final-energy (resonance-run-remaining-energy run)
            :standing-before (resonant-node-standing source)
            :standing-after (resonant-node-standing source)
            :conclusion :resonance-without-identity)))
    (refresh-receipt-digest receipt)))

(defun validate-receipt (receipt source pulse plan run final-nodes
                           bequest descendant resemblance-ids)
  (unless (and (typep receipt 'resonance-receipt)
               (string= (resonance-receipt-receipt-digest receipt)
                        (toy-digest (receipt-payload receipt))))
    (fire 'altered-resonance-receipt "resonance receipt has been altered"))
  (validate-node source)
  (validate-run run plan)
  (validate-bequest bequest source
                    (find-node (resonance-bequest-recipient-id bequest)
                               +initial-nodes+))
  (validate-descendant descendant source)
  (unless (and (equal (resonance-receipt-source-id receipt)
                      (resonant-node-id source))
               (string= (resonance-receipt-source-digest receipt)
                        (resonant-node-digest source))
               (= (resonance-receipt-source-epoch receipt)
                  (resonant-node-epoch source))
               (string= (resonance-receipt-pulse-digest receipt)
                        (pulse-digest pulse))
               (string= (resonance-receipt-plan-digest receipt)
                        (resonance-plan-plan-digest plan))
               (string= (resonance-receipt-run-digest receipt)
                        (resonance-run-run-digest run))
               (same-set-p (resonance-receipt-resemblance-targets receipt)
                           resemblance-ids)
               (same-set-p (resonance-receipt-transmitted-targets receipt)
                           (transmitted-targets run))
               (same-set-p (resonance-receipt-entrained-targets receipt)
                           (entrained-targets run final-nodes
                                              (resonant-node-id source)))
               (string= (resonance-receipt-bequest-digest receipt)
                        (resonance-bequest-digest bequest))
               (string= (resonance-receipt-descendant-digest receipt)
                        (resonant-descendant-digest descendant))
               (equal (resonance-receipt-response-digests receipt)
                      (mapcar #'resonance-response-digest
                              (resonance-run-responses run)))
               (equal (mapcar #'energy-event-payload
                              (resonance-receipt-energy-events receipt))
                      (mapcar #'energy-event-payload
                              (resonance-run-energy-events run)))
               (= (resonance-receipt-initial-energy receipt)
                  (resonance-run-initial-energy run))
               (= (resonance-receipt-supplied-energy receipt)
                  (resonance-run-supplied-energy run))
               (= (resonance-receipt-spent-energy receipt)
                  (resonance-run-spent-energy run))
               (= (resonance-receipt-final-energy receipt)
                  (resonance-run-remaining-energy run))
               (equal (mapcar #'resonant-node-digest final-nodes)
                      (resonance-run-final-node-digests run)))
    (fire 'altered-resonance-receipt
          "receipt no longer faces its source, relations, or event"))
  (unless (and (eq (resonance-receipt-standing-before receipt) :asserted)
               (eq (resonance-receipt-standing-after receipt) :asserted)
               (eq (resonance-receipt-conclusion receipt)
                   :resonance-without-identity))
    (fire 'forged-unity-claim
          "resonance may not promote standing or collapse identities"))
  receipt)

(defun supply-schedule-from-run (run)
  (mapcar #'energy-event-amount (resonance-run-energy-events run)))

(defun replay-resonance (nodes couplings field-epoch pulse plan original-run)
  (multiple-value-bind (replayed-run replayed-nodes)
      (execute-resonance
       plan nodes couplings field-epoch pulse
       :initial-energy (resonance-run-initial-energy original-run)
       :supply-schedule (supply-schedule-from-run original-run))
    (unless (and (string= (resonance-run-run-digest replayed-run)
                          (resonance-run-run-digest original-run))
                 (equal (resonance-run-final-node-digests replayed-run)
                        (resonance-run-final-node-digests original-run)))
      (fire 'replay-diverged "resonance replay diverged"))
    (values replayed-run replayed-nodes)))

;;; ── The field ──────────────────────────────────────────────────────────

(defparameter +field-epoch+ 0)

(defparameter +source-mode+
  '(:kind :suspended-rhyme :rhyme-key :c
    :terminal-pair ("cell" "dwell") :cadence :delayed-return))

(defparameter +initial-nodes+
  (list
   (make-resonant-node
    :id :milton-chamber :identity :incantation-receipt-7
    :mode +source-mode+ :phase 0
    :motifs '((:cell-dwell :terminal-closure)))
   (make-resonant-node
    :id :bell-lattice :identity :bronze-bell-31
    :mode +source-mode+ :phase 5)
   (make-resonant-node
    :id :porch-chorus :identity :chorus-17
    :mode +source-mode+ :phase 3)
   (make-resonant-node
    :id :night-raven :identity :raven-independent-4
    :mode +source-mode+ :phase 0
    :history '((:origin :independent-song)))
   (make-resonant-node
    :id :archive-heir :identity :archive-volume-9
    :mode '(:kind :reliquary :cadence :silent) :phase 5)))

(defparameter +couplings+
  (list
   (make-coupling
    :id :air-to-bell :source-id :milton-chamber :target-id :bell-lattice
    :channel :air :strength 1
    :scope '(:rhyme-key :terminal-pair)
    :source-epoch 0 :target-epoch 0)
   (make-coupling
    :id :memory-to-chorus :source-id :milton-chamber
    :target-id :porch-chorus :channel :remembered-recitation :strength 1
    :scope '(:rhyme-key :terminal-pair :cadence)
    :source-epoch 0 :target-epoch 0)))

(defparameter +source-pulse+
  (make-pulse
   :id :cell-dwell-return
   :origin (find-node :milton-chamber +initial-nodes+)
   :signature
   '(:rhyme-key :c :terminal-pair ("cell" "dwell")
     :cadence :delayed-return :outcome :banished-from-chamber)
   :amplitude 3
   :lineage '(:from :de-incantatione :receipt :bounded-symbolic-act)))

;;; ── Exhibit ────────────────────────────────────────────────────────────

(defun print-response (response)
  (format t "  #~d r~d ~14s via ~18s phase ~d→~d  ~s~%"
          (resonance-response-sequence response)
          (resonance-response-repeat response)
          (resonance-response-node-id response)
          (resonance-response-coupling-id response)
          (resonance-response-phase-before response)
          (resonance-response-phase-after response)
          (resonance-response-kind response)))

(defun demonstrate ()
  (banner "DE RESONANTIA — CONCERNING RESONANCE")
  (format t "Claim: sympathetic motion can be traced without confusing~%")
  (format t "       resemblance, transmission, entrainment, inheritance,~%")
  (format t "       causal descent, identity, authority, or truth.~%")
  (let* ((nodes (mapcar #'copy-node-deep +initial-nodes+))
         (couplings (mapcar #'copy-coupling +couplings+))
         (source (find-node :milton-chamber nodes))
         (raven (find-node :night-raven nodes))
         (heir (find-node :archive-heir nodes))
         (plan (compile-resonance
                nodes couplings +field-epoch+ +source-pulse+
                '(:bell-lattice :porch-chorus :night-raven)
                :repeats 3))
         (resemblances
           (resemblance-targets
            source (resonance-plan-target-ids plan) nodes)))

    (section "I. RESEMBLANCE DOES NOT PROVE CONTACT")
    (format t " mode-matched forms: ~s~%" resemblances)
    (ensure (member :night-raven resemblances :test #'eq)
            "independent raven should resemble the source")

    (multiple-value-bind (run final-nodes)
        (handler-bind
            ((resonance-budget-exhausted
               (lambda (condition)
                 (format t " energy boundary r~d/~s: supplying 1~%"
                         (exhausted-repeat condition)
                         (exhausted-target-id condition))
                 (invoke-restart 'supply-energy 1))))
          (execute-resonance plan nodes couplings +field-epoch+
                             +source-pulse+ :initial-energy 4))
      (validate-run run plan)
      (format t " causal responses:~%")
      (mapc #'print-response (resonance-run-responses run))
      (ensure (= (resonance-run-supplied-energy run) 2)
              "two repaired energy units should remain in the event")
      (ensure (= (length (resonance-run-responses run)) 6)
              "two coupled targets over three repeats should yield six responses")
      (ensure (null (responses-for :night-raven run))
              "independent resemblance should have no response trace")
      (expect-condition resemblance-is-not-transmission
        (claim-resemblance-as-transmission source raven run))

      (section "II. TRANSMISSION MAY OCCUR WITHOUT ENTRAINMENT")
      (expect-condition transmission-is-not-entrainment
        (claim-transmission-as-entrainment
         :bell-lattice run final-nodes :milton-chamber))
      (let ((chorus (find-node :porch-chorus final-nodes)))
        (ensure (= (resonant-node-phase chorus) 0)
                "chorus should reach source phase after three pulses")
        (claim-transmission-as-entrainment
         :porch-chorus run final-nodes :milton-chamber)
        (pass "the chorus entrained through repeated causal responses")

        (section "III. ENTRAINMENT DOES NOT ERASE IDENTITY")
        (expect-condition entrainment-is-not-identity
          (claim-entrainment-as-identity source chorus)))

      (section "IV. INFLUENCE IS NOT INHERITANCE")
      (expect-condition influence-is-not-inheritance
        (claim-influence-as-inheritance
         source (find-node :porch-chorus final-nodes) run))
      (let* ((motif '(:terminal-pair ("cell" "dwell") :rhyme-key :c))
             (bequest (make-bequest source heir motif '(:quote :adapt)))
             (heir-after (accept-bequest bequest source heir)))
        (format t " bequest rights: ~s; heir standing: ~s~%"
                (resonance-bequest-rights bequest)
                (resonant-node-standing heir-after))
        (ensure (member motif (resonant-node-motifs heir-after) :test #'equal)
                "heir should carry the explicitly bequeathed motif")
        (expect-condition inheritance-is-not-authority
          (claim-inherited-authority bequest))
        (expect-condition inheritance-is-not-verification
          (claim-inheritance-as-verification heir-after))

        (section "V. DESCENT REQUIRES A PARENT-BOUND TRANSFORMATION")
        (let ((descendant
                (make-descendant source :dwell-cell-child motif
                                 :reverse-pair)))
          (validate-descendant descendant source)
          (format t " descendant motif: ~s~%"
                  (resonant-descendant-child-motif descendant))
          (expect-condition correlation-is-not-lineage
            (claim-correlation-as-lineage
             '(:terminal-pair ("dwell" "cell") :rhyme-key :c)
             source))

          (section "VI. THE RECEIPT REFUSES THE GRAND UNIFICATION")
          (let ((receipt
                  (mint-receipt source +source-pulse+ plan run final-nodes
                                bequest descendant resemblances)))
            (validate-receipt receipt source +source-pulse+ plan run
                              final-nodes bequest descendant resemblances)
            (format t " resemblance: ~s~%"
                    (resonance-receipt-resemblance-targets receipt))
            (format t " transmitted: ~s~%"
                    (resonance-receipt-transmitted-targets receipt))
            (format t " entrained:   ~s~%"
                    (resonance-receipt-entrained-targets receipt))
            (format t " conclusion:  ~s~%"
                    (resonance-receipt-conclusion receipt))
            (let ((forged (copy-resonance-receipt receipt)))
              (setf (resonance-receipt-conclusion forged) :common-identity
                    (resonance-receipt-standing-after forged) :verified)
              (refresh-receipt-digest forged)
              (expect-condition forged-unity-claim
                (validate-receipt forged source +source-pulse+ plan run
                                  final-nodes bequest descendant
                                  resemblances))))

          (section "VII. REPLAY KEEPS THE ENERGY REPAIRS")
          (multiple-value-bind (replayed-run replayed-nodes)
              (replay-resonance nodes couplings +field-epoch+
                                +source-pulse+ plan run)
            (declare (ignore replayed-nodes))
            (ensure (= (resonance-run-supplied-energy replayed-run) 2)
                    "replay must preserve supplied energy")
            (pass "same pulses, repairs, responses, and final phases replayed"))

          (section "VIII. OLD MUSIC DOES NOT GOVERN A NEW EPOCH")
          (let ((changed (mapcar #'copy-node-deep nodes)))
            (let ((changed-source (find-node :milton-chamber changed)))
              (incf (resonant-node-epoch changed-source))
              (push '(:event :chamber-reopened)
                    (resonant-node-history changed-source))
              (refresh-node-digest changed-source))
            (expect-condition stale-resonance-plan
              (execute-resonance plan changed couplings (1+ +field-epoch+)
                                 +source-pulse+ :initial-energy 6)))

          (section "EXHIBIT")
          (format t " independent resemblance: NIGHT-RAVEN (no path)~%")
          (format t " transmitted only:        BELL-LATTICE~%")
          (format t " causally entrained:      PORCH-CHORUS~%")
          (format t " explicit inheritance:   ARCHIVE-HEIR (:QUOTE :ADAPT)~%")
          (format t " parent-bound descent:    DWELL-CELL-CHILD~%")
          (format t " standing:                :ASSERTED → :ASSERTED~%")
          (format t " verdict:                 :RESONANCE-WITHOUT-IDENTITY~%")
          (format t "~%The forms answer one another.  The receipt keeps their names.~%")
          (pass "DE RESONANTIA complete")
          t)))))

(demonstrate)
