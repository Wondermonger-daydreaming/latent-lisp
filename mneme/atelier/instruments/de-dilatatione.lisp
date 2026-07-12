;;;; de-dilatatione.lisp — Concerning Dilation
;;;;
;;;; A Lisp+ Atelier instrument after de-resonantia.  Fixity and mutability
;;;; arrive as rival claimants.  The specimen refuses both petrification and
;;;; replacement, then models dilation as growth along two non-zero-sum axes:
;;;; outward relation and upward address.
;;;;
;;;; THESIS
;;;;   * preservation is not petrification;
;;;;   * change is not annihilation or identity replacement;
;;;;   * upward address need not be purchased by deleting worldly relations;
;;;;   * capacity alone is not communion;
;;;;   * fulfillment may preserve the growth operator rather than close it;
;;;;   * a finite unfolding is not infinity;
;;;;   * symbolic theology remains :ASSERTED, never self-promoted to evidence;
;;;;   * every refused synthesis remains archived as provenance;
;;;;   * repaired attention remains part of the event and its replay.
;;;;
;;;; WHAT THIS DOES NOT ESTABLISH
;;;; This is a deterministic, cooperative, single-process model over finite
;;;; proper-list data.  It does not prove a doctrine of God, eternity, glory,
;;;; desire, sexuality, human flourishing, or the metaphysics of Spenser.
;;;; "Outward" and "upward" are declared axes in a small symbolic instrument,
;;;; not measurements of a person.  The horizon is represented by a repeatable
;;;; successor rule and finite prefixes; no actual infinity is computed.  The
;;;; digest supplied by the Atelier root is pedagogical, not cryptographic.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*)))

(defpackage #:lispplus-atelier.de-dilatatione
  (:use #:cl #:lispplus-atelier))

(in-package #:lispplus-atelier.de-dilatatione)

(reset-clock 14100)

;;; ── Conditions: every counterfeit synthesis fails by name ─────────────

(define-condition dilation-error (error)
  ((detail :initarg :detail :reader dilation-error-detail :initform ""))
  (:report (lambda (condition stream)
             (format stream "~a" (dilation-error-detail condition)))))

(define-condition malformed-heart (dilation-error) ())
(define-condition malformed-proposal (dilation-error) ())
(define-condition altered-proposal (dilation-error) ())
(define-condition stale-proposal (dilation-error) ())
(define-condition source-changed (dilation-error) ())
(define-condition fixity-is-not-eternity (dilation-error) ())
(define-condition change-is-not-annihilation (dilation-error) ())
(define-condition ascent-is-not-subtraction (dilation-error) ())
(define-condition capacity-is-not-communion (dilation-error) ())
(define-condition growth-needs-two-axes (dilation-error) ())
(define-condition fulfillment-is-not-closure (dilation-error) ())
(define-condition standing-laundering (dilation-error) ())
(define-condition finite-prefix-is-not-infinity (dilation-error) ())
(define-condition theological-image-is-not-evidence (dilation-error) ())
(define-condition altered-scar (dilation-error) ())
(define-condition altered-run (dilation-error) ())
(define-condition altered-horizon (dilation-error) ())
(define-condition altered-receipt (dilation-error) ())
(define-condition forged-fulfillment-claim (dilation-error) ())
(define-condition replay-diverged (dilation-error) ())

(define-condition attention-exhausted (dilation-error)
  ((needed :initarg :needed :reader exhausted-needed)
   (available :initarg :available :reader exhausted-available)
   (proposal-id :initarg :proposal-id :reader exhausted-proposal-id)))

(defun fire (type control &rest arguments)
  (error type :detail (apply #'format nil control arguments)))

(defmacro expect-condition (type &body body)
  "Require TYPE to fire.  Another DILATION-ERROR is not accepted as a pass."
  (let ((condition (gensym "CONDITION")))
    `(handler-case
         (progn
           ,@body
           (error "expected ~a, but no condition fired" ',type))
       (,type (,condition)
         (format t " ✓ ~a fired: ~a~%"
                 ',type (dilation-error-detail ,condition))
         t)
       (dilation-error (,condition)
         (error "expected ~a, got ~a: ~a"
                ',type (type-of ,condition)
                (dilation-error-detail ,condition))))))

;;; ── Records ────────────────────────────────────────────────────────────

(defstruct (heart-state (:constructor %make-heart-state))
  id epoch core-vow capacity outward-relations upward-address
  mode open-p standing history digest)

(defstruct (dilation-proposal (:constructor %make-dilation-proposal))
  id source-id source-epoch source-digest operation core-claim
  additions losses capacity-delta upward-delta completion-claim
  standing-claim cost rationale proposal-digest)

(defstruct (dilation-scar (:constructor %make-dilation-scar))
  sequence proposal-id proposal-digest condition-type detail
  rejected-proposal scar-digest)

(defstruct (attention-event (:constructor %make-attention-event))
  sequence proposal-id amount before after digest)

(defstruct (dilation-run (:constructor %make-dilation-run))
  source-digest proposal-digest result-digest initial-attention
  supplied-attention spent-attention final-attention attention-events
  run-digest)

(defstruct (growth-horizon (:constructor %make-growth-horizon))
  id seed-id seed-digest generator-id generator-version
  outward-rule upward-rule capacity-rule closure standing horizon-digest)

(defstruct (horizon-step (:constructor %make-horizon-step))
  index parent-digest result-digest added-relation upward-before
  upward-after capacity-before capacity-after step-digest)

(defstruct (dilation-receipt (:constructor %make-dilation-receipt))
  id source-id source-digest source-epoch proposal-digest run-digest
  result-digest scar-digests horizon-digest horizon-step-digests
  outward-before outward-after upward-before upward-after
  capacity-before capacity-after initial-attention supplied-attention
  spent-attention final-attention standing-before standing-after
  conclusion receipt-digest)

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
    (fire 'malformed-heart "~a must be a finite proper-list tree: ~s"
          context object))
  object)

(defun nonnegative-integer-p (object)
  (and (integerp object) (not (minusp object))))

(defun positive-integer-p (object)
  (and (integerp object) (plusp object)))

(defun same-set-p (left right)
  (and (null (set-difference left right :test #'equal))
       (null (set-difference right left :test #'equal))))

(defun relation-key (relation)
  (if (consp relation) (first relation) relation))

(defun relation-present-p (relation relations)
  (member (relation-key relation) relations
          :key #'relation-key :test #'equal))

(defun add-relations (old additions)
  (let ((result (copy-tree old)))
    (dolist (relation additions (nreverse result))
      (unless (relation-present-p relation result)
        (push (copy-tree relation) result)))))

;;; ── Heart states ───────────────────────────────────────────────────────

(defun heart-payload (heart)
  (list :id (heart-state-id heart)
        :epoch (heart-state-epoch heart)
        :core-vow (copy-tree (heart-state-core-vow heart))
        :capacity (heart-state-capacity heart)
        :outward-relations (copy-tree (heart-state-outward-relations heart))
        :upward-address (heart-state-upward-address heart)
        :mode (heart-state-mode heart)
        :open-p (heart-state-open-p heart)
        :standing (heart-state-standing heart)
        :history (copy-tree (heart-state-history heart))))

(defun refresh-heart-digest (heart)
  (setf (heart-state-digest heart) (toy-digest (heart-payload heart)))
  heart)

(defun make-heart-state (&key id (epoch 0) core-vow capacity
                              outward-relations upward-address
                              (mode :mutable-growth) (open-p t)
                              (standing :asserted) (history '()))
  (unless (and id (nonnegative-integer-p epoch)
               (positive-integer-p capacity)
               (nonnegative-integer-p upward-address)
               (proper-list-p outward-relations)
               (<= (length outward-relations) capacity)
               (member standing '(:asserted :verified) :test #'eq))
    (fire 'malformed-heart "invalid heart-state constructor arguments"))
  (require-finite-tree core-vow "core vow")
  (require-finite-tree outward-relations "outward relations")
  (refresh-heart-digest
   (%make-heart-state
    :id id :epoch epoch :core-vow (copy-tree core-vow)
    :capacity capacity :outward-relations (copy-tree outward-relations)
    :upward-address upward-address :mode mode :open-p open-p
    :standing standing :history (copy-tree history))))

(defun copy-heart-deep (heart)
  (make-heart-state
   :id (heart-state-id heart)
   :epoch (heart-state-epoch heart)
   :core-vow (heart-state-core-vow heart)
   :capacity (heart-state-capacity heart)
   :outward-relations (heart-state-outward-relations heart)
   :upward-address (heart-state-upward-address heart)
   :mode (heart-state-mode heart)
   :open-p (heart-state-open-p heart)
   :standing (heart-state-standing heart)
   :history (heart-state-history heart)))

(defun validate-heart (heart)
  (unless (typep heart 'heart-state)
    (fire 'malformed-heart "expected HEART-STATE, received ~s" heart))
  (unless (and (positive-integer-p (heart-state-capacity heart))
               (nonnegative-integer-p (heart-state-upward-address heart))
               (<= (length (heart-state-outward-relations heart))
                   (heart-state-capacity heart))
               (string= (heart-state-digest heart)
                        (toy-digest (heart-payload heart))))
    (fire 'malformed-heart "heart ~s is structurally invalid or altered"
          (heart-state-id heart)))
  heart)

;;; ── Proposals and their custody ────────────────────────────────────────

(defun proposal-payload (proposal)
  (list :id (dilation-proposal-id proposal)
        :source-id (dilation-proposal-source-id proposal)
        :source-epoch (dilation-proposal-source-epoch proposal)
        :source-digest (dilation-proposal-source-digest proposal)
        :operation (dilation-proposal-operation proposal)
        :core-claim (copy-tree (dilation-proposal-core-claim proposal))
        :additions (copy-tree (dilation-proposal-additions proposal))
        :losses (copy-tree (dilation-proposal-losses proposal))
        :capacity-delta (dilation-proposal-capacity-delta proposal)
        :upward-delta (dilation-proposal-upward-delta proposal)
        :completion-claim (dilation-proposal-completion-claim proposal)
        :standing-claim (dilation-proposal-standing-claim proposal)
        :cost (dilation-proposal-cost proposal)
        :rationale (copy-tree (dilation-proposal-rationale proposal))))

(defun refresh-proposal-digest (proposal)
  (setf (dilation-proposal-proposal-digest proposal)
        (toy-digest (proposal-payload proposal)))
  proposal)

(defun make-dilation-proposal (&key id source operation core-claim
                                    (additions '()) (losses '())
                                    (capacity-delta 0) (upward-delta 0)
                                    (completion-claim :open-horizon)
                                    (standing-claim :asserted)
                                    (cost 1) rationale)
  (validate-heart source)
  (unless (and id operation (proper-list-p additions) (proper-list-p losses)
               (integerp capacity-delta) (integerp upward-delta)
               (positive-integer-p cost))
    (fire 'malformed-proposal "invalid proposal constructor arguments"))
  (require-finite-tree core-claim "proposal core claim")
  (require-finite-tree additions "proposal additions")
  (require-finite-tree losses "proposal losses")
  (refresh-proposal-digest
   (%make-dilation-proposal
    :id id :source-id (heart-state-id source)
    :source-epoch (heart-state-epoch source)
    :source-digest (heart-state-digest source)
    :operation operation :core-claim (copy-tree core-claim)
    :additions (copy-tree additions) :losses (copy-tree losses)
    :capacity-delta capacity-delta :upward-delta upward-delta
    :completion-claim completion-claim :standing-claim standing-claim
    :cost cost :rationale (copy-tree rationale))))

(defun copy-proposal-deep (proposal)
  (let ((copy (%make-dilation-proposal
               :id (dilation-proposal-id proposal)
               :source-id (dilation-proposal-source-id proposal)
               :source-epoch (dilation-proposal-source-epoch proposal)
               :source-digest (dilation-proposal-source-digest proposal)
               :operation (dilation-proposal-operation proposal)
               :core-claim (copy-tree (dilation-proposal-core-claim proposal))
               :additions (copy-tree (dilation-proposal-additions proposal))
               :losses (copy-tree (dilation-proposal-losses proposal))
               :capacity-delta (dilation-proposal-capacity-delta proposal)
               :upward-delta (dilation-proposal-upward-delta proposal)
               :completion-claim (dilation-proposal-completion-claim proposal)
               :standing-claim (dilation-proposal-standing-claim proposal)
               :cost (dilation-proposal-cost proposal)
               :rationale (copy-tree (dilation-proposal-rationale proposal))
               :proposal-digest (dilation-proposal-proposal-digest proposal))))
    copy))

(defun validate-proposal (proposal source)
  (validate-heart source)
  (unless (typep proposal 'dilation-proposal)
    (fire 'malformed-proposal "expected DILATION-PROPOSAL"))
  (unless (string= (dilation-proposal-proposal-digest proposal)
                   (toy-digest (proposal-payload proposal)))
    (fire 'altered-proposal "proposal ~s was altered after minting"
          (dilation-proposal-id proposal)))
  (unless (and (eq (dilation-proposal-source-id proposal)
                   (heart-state-id source))
               (= (dilation-proposal-source-epoch proposal)
                  (heart-state-epoch source))
               (string= (dilation-proposal-source-digest proposal)
                        (heart-state-digest source)))
    (fire 'stale-proposal
          "proposal ~s no longer faces this heart-state epoch"
          (dilation-proposal-id proposal)))
  proposal)

(defun preflight-proposal (proposal source)
  (validate-proposal proposal source)
  (case (dilation-proposal-operation proposal)
    (:freeze
     (fire 'fixity-is-not-eternity
           "preserving a form by forbidding all further relation is petrification"))
    (:replace
     (fire 'change-is-not-annihilation
           "change may not purchase novelty by discarding core, history, and identity"))
    (:substitute
     (fire 'ascent-is-not-subtraction
           "upward address may not be financed by deleting worldly relations"))
    (:inflate
     (fire 'capacity-is-not-communion
           "empty capacity growth establishes no new relation or address"))
    (:dilate nil)
    (otherwise
     (fire 'malformed-proposal "unknown proposal operation ~s"
           (dilation-proposal-operation proposal))))
  (unless (equal (dilation-proposal-core-claim proposal)
                 (heart-state-core-vow source))
    (fire 'change-is-not-annihilation
          "lawful dilation must preserve the declared core vow"))
  (when (dilation-proposal-losses proposal)
    (fire 'ascent-is-not-subtraction
          "lawful dilation records no old relation as payment: ~s"
          (dilation-proposal-losses proposal)))
  (unless (and (plusp (length (dilation-proposal-additions proposal)))
               (plusp (dilation-proposal-upward-delta proposal)))
    (fire 'growth-needs-two-axes
          "this synthesis requires outward addition and upward address together"))
  (unless (>= (dilation-proposal-capacity-delta proposal)
              (length (dilation-proposal-additions proposal)))
    (fire 'capacity-is-not-communion
          "capacity delta ~d cannot host ~d new relations"
          (dilation-proposal-capacity-delta proposal)
          (length (dilation-proposal-additions proposal))))
  (unless (eq (dilation-proposal-completion-claim proposal) :open-horizon)
    (fire 'fulfillment-is-not-closure
          "fulfillment may not close the successor relation"))
  (unless (eq (dilation-proposal-standing-claim proposal)
              (heart-state-standing source))
    (fire 'standing-laundering
          "transformation cannot promote ~s to ~s"
          (heart-state-standing source)
          (dilation-proposal-standing-claim proposal)))
  t)

;;; ── Refusal archive ────────────────────────────────────────────────────

(defun scar-payload (scar)
  (list :sequence (dilation-scar-sequence scar)
        :proposal-id (dilation-scar-proposal-id scar)
        :proposal-digest (dilation-scar-proposal-digest scar)
        :condition-type (dilation-scar-condition-type scar)
        :detail (dilation-scar-detail scar)
        :rejected-proposal
        (proposal-payload (dilation-scar-rejected-proposal scar))))

(defun refresh-scar-digest (scar)
  (setf (dilation-scar-scar-digest scar) (toy-digest (scar-payload scar)))
  scar)

(defun make-scar (sequence proposal condition)
  (refresh-scar-digest
   (%make-dilation-scar
    :sequence sequence
    :proposal-id (dilation-proposal-id proposal)
    :proposal-digest (dilation-proposal-proposal-digest proposal)
    :condition-type (type-of condition)
    :detail (dilation-error-detail condition)
    :rejected-proposal (copy-proposal-deep proposal))))

(defun validate-scar (scar)
  (unless (and (typep scar 'dilation-scar)
               (string= (dilation-scar-scar-digest scar)
                        (toy-digest (scar-payload scar)))
               (string= (dilation-scar-proposal-digest scar)
                        (dilation-proposal-proposal-digest
                         (dilation-scar-rejected-proposal scar))))
    (fire 'altered-scar "a refusal scar was altered"))
  scar)

(defun archive-refusal (sequence proposal source)
  (handler-case
      (progn
        (preflight-proposal proposal source)
        (error "proposal ~s unexpectedly passed preflight"
               (dilation-proposal-id proposal)))
    (dilation-error (condition)
      (let ((scar (make-scar sequence proposal condition)))
        (format t "  scar ~d: ~s refused by ~s~%"
                sequence (dilation-proposal-id proposal)
                (type-of condition))
        scar))))

;;; ── Lawful execution and attention accounting ─────────────────────────

(defun attention-event-payload (event)
  (list :sequence (attention-event-sequence event)
        :proposal-id (attention-event-proposal-id event)
        :amount (attention-event-amount event)
        :before (attention-event-before event)
        :after (attention-event-after event)))

(defun make-attention-event (sequence proposal-id amount before after)
  (%make-attention-event
   :sequence sequence :proposal-id proposal-id :amount amount
   :before before :after after
   :digest (toy-digest
            (list :sequence sequence :proposal-id proposal-id
                  :amount amount :before before :after after))))

(defun validate-attention-event (event)
  (unless (and (typep event 'attention-event)
               (positive-integer-p (attention-event-amount event))
               (= (+ (attention-event-before event)
                     (attention-event-amount event))
                  (attention-event-after event))
               (string= (attention-event-digest event)
                        (toy-digest (attention-event-payload event))))
    (fire 'altered-run "an attention repair event was altered"))
  event)

(defun apply-dilation (proposal source)
  (preflight-proposal proposal source)
  (let* ((result (copy-heart-deep source))
         (new-relations
           (add-relations (heart-state-outward-relations source)
                          (dilation-proposal-additions proposal))))
    (setf (heart-state-capacity result)
          (+ (heart-state-capacity source)
             (dilation-proposal-capacity-delta proposal))
          (heart-state-outward-relations result) new-relations
          (heart-state-upward-address result)
          (+ (heart-state-upward-address source)
             (dilation-proposal-upward-delta proposal))
          (heart-state-mode result) :dilated-growth
          (heart-state-open-p result) t
          (heart-state-standing result) (heart-state-standing source))
    (push (list :event :dilation
                :proposal (dilation-proposal-id proposal)
                :outward-added (copy-tree
                                (dilation-proposal-additions proposal))
                :upward-delta (dilation-proposal-upward-delta proposal))
          (heart-state-history result))
    (refresh-heart-digest result)))

(defun run-payload (run)
  (list :source-digest (dilation-run-source-digest run)
        :proposal-digest (dilation-run-proposal-digest run)
        :result-digest (dilation-run-result-digest run)
        :initial-attention (dilation-run-initial-attention run)
        :supplied-attention (dilation-run-supplied-attention run)
        :spent-attention (dilation-run-spent-attention run)
        :final-attention (dilation-run-final-attention run)
        :attention-events
        (mapcar #'attention-event-payload
                (dilation-run-attention-events run))))

(defun refresh-run-digest (run)
  (setf (dilation-run-run-digest run) (toy-digest (run-payload run)))
  run)

(defun execute-dilation (proposal source &key (initial-attention 0)
                                           supply-schedule)
  (preflight-proposal proposal source)
  (unless (nonnegative-integer-p initial-attention)
    (fire 'malformed-proposal "initial attention must be nonnegative"))
  (let ((attention initial-attention)
        (supplied 0)
        (events '())
        (event-sequence 0)
        (schedule (copy-list supply-schedule))
        (cost (dilation-proposal-cost proposal)))
    (labels ((record-supply (amount)
               (unless (positive-integer-p amount)
                 (fire 'malformed-proposal
                       "supplied attention must be a positive integer"))
               (let ((before attention))
                 (incf attention amount)
                 (incf supplied amount)
                 (incf event-sequence)
                 (push (make-attention-event
                        event-sequence (dilation-proposal-id proposal)
                        amount before attention)
                       events)))
             (ensure-attention ()
               (loop while (< attention cost) do
                 (if schedule
                     (record-supply (pop schedule))
                     (restart-case
                         (error 'attention-exhausted
                                :detail
                                (format nil
                                        "proposal ~s needs ~d attention; ~d available"
                                        (dilation-proposal-id proposal)
                                        cost attention)
                                :needed cost :available attention
                                :proposal-id
                                (dilation-proposal-id proposal))
                       (supply-attention (amount)
                         :report "Supply bounded attention and resume."
                         (record-supply amount))
                       (abort-dilation ()
                         :report "Abort without mutating the source."
                         (return-from execute-dilation
                           (values nil nil))))))))
      (ensure-attention)
      (let* ((source-before (heart-state-digest source))
             (result (apply-dilation proposal source)))
        (unless (string= source-before (heart-state-digest source))
          (fire 'source-changed "execution mutated the source heart"))
        (decf attention cost)
        (let ((run
                (refresh-run-digest
                 (%make-dilation-run
                  :source-digest source-before
                  :proposal-digest
                  (dilation-proposal-proposal-digest proposal)
                  :result-digest (heart-state-digest result)
                  :initial-attention initial-attention
                  :supplied-attention supplied
                  :spent-attention cost
                  :final-attention attention
                  :attention-events (nreverse events)))))
          (values run result))))))

(defun validate-run (run proposal source result)
  (mapc #'validate-attention-event (dilation-run-attention-events run))
  (unless (and (typep run 'dilation-run)
               (string= (dilation-run-run-digest run)
                        (toy-digest (run-payload run)))
               (string= (dilation-run-source-digest run)
                        (heart-state-digest source))
               (string= (dilation-run-proposal-digest run)
                        (dilation-proposal-proposal-digest proposal))
               (string= (dilation-run-result-digest run)
                        (heart-state-digest result))
               (= (+ (dilation-run-initial-attention run)
                     (dilation-run-supplied-attention run))
                  (+ (dilation-run-spent-attention run)
                     (dilation-run-final-attention run))))
    (fire 'altered-run "dilation run no longer balances or faces its event"))
  run)

;;; ── Fulfillment as an open successor horizon ──────────────────────────

(defun horizon-payload (horizon)
  (list :id (growth-horizon-id horizon)
        :seed-id (growth-horizon-seed-id horizon)
        :seed-digest (growth-horizon-seed-digest horizon)
        :generator-id (growth-horizon-generator-id horizon)
        :generator-version (growth-horizon-generator-version horizon)
        :outward-rule (copy-tree (growth-horizon-outward-rule horizon))
        :upward-rule (copy-tree (growth-horizon-upward-rule horizon))
        :capacity-rule (copy-tree (growth-horizon-capacity-rule horizon))
        :closure (growth-horizon-closure horizon)
        :standing (growth-horizon-standing horizon)))

(defun refresh-horizon-digest (horizon)
  (setf (growth-horizon-horizon-digest horizon)
        (toy-digest (horizon-payload horizon)))
  horizon)

(defun make-growth-horizon (seed)
  (validate-heart seed)
  (refresh-horizon-digest
   (%make-growth-horizon
    :id :spenserian-dilation-horizon
    :seed-id (heart-state-id seed)
    :seed-digest (heart-state-digest seed)
    :generator-id :dilate-one-more-relation
    :generator-version 1
    :outward-rule '(:add-one :previously-unaddressed-relation)
    :upward-rule '(:increment 1)
    :capacity-rule '(:increment 1)
    :closure :open
    :standing (heart-state-standing seed))))

(defun validate-horizon (horizon seed)
  (unless (and (typep horizon 'growth-horizon)
               (string= (growth-horizon-horizon-digest horizon)
                        (toy-digest (horizon-payload horizon)))
               (eq (growth-horizon-seed-id horizon)
                   (heart-state-id seed))
               (string= (growth-horizon-seed-digest horizon)
                        (heart-state-digest seed))
               (eq (growth-horizon-closure horizon) :open)
               (eq (growth-horizon-standing horizon)
                   (heart-state-standing seed)))
    (fire 'altered-horizon "growth horizon was closed, detached, or altered"))
  horizon)

(defun step-payload (step)
  (list :index (horizon-step-index step)
        :parent-digest (horizon-step-parent-digest step)
        :result-digest (horizon-step-result-digest step)
        :added-relation (copy-tree (horizon-step-added-relation step))
        :upward-before (horizon-step-upward-before step)
        :upward-after (horizon-step-upward-after step)
        :capacity-before (horizon-step-capacity-before step)
        :capacity-after (horizon-step-capacity-after step)))

(defun make-horizon-step (index parent result relation)
  (%make-horizon-step
   :index index :parent-digest (heart-state-digest parent)
   :result-digest (heart-state-digest result)
   :added-relation (copy-tree relation)
   :upward-before (heart-state-upward-address parent)
   :upward-after (heart-state-upward-address result)
   :capacity-before (heart-state-capacity parent)
   :capacity-after (heart-state-capacity result)
   :step-digest
   (toy-digest
    (list :index index :parent-digest (heart-state-digest parent)
          :result-digest (heart-state-digest result)
          :added-relation relation
          :upward-before (heart-state-upward-address parent)
          :upward-after (heart-state-upward-address result)
          :capacity-before (heart-state-capacity parent)
          :capacity-after (heart-state-capacity result)))))

(defun validate-horizon-step (step)
  (unless (and (typep step 'horizon-step)
               (positive-integer-p (horizon-step-index step))
               (= (1+ (horizon-step-upward-before step))
                  (horizon-step-upward-after step))
               (= (1+ (horizon-step-capacity-before step))
                  (horizon-step-capacity-after step))
               (string= (horizon-step-step-digest step)
                        (toy-digest (step-payload step))))
    (fire 'altered-horizon "a horizon successor step was altered"))
  step)

(defun horizon-successor (heart index)
  (let* ((result (copy-heart-deep heart))
         (relation (list :future-relation index :addressed-without-exhaustion)))
    (setf (heart-state-capacity result)
          (1+ (heart-state-capacity heart))
          (heart-state-outward-relations result)
          (add-relations (heart-state-outward-relations heart)
                         (list relation))
          (heart-state-upward-address result)
          (1+ (heart-state-upward-address heart))
          (heart-state-mode result) :glory-horizon
          (heart-state-open-p result) t
          (heart-state-standing result) (heart-state-standing heart))
    (push (list :event :horizon-successor :index index
                :relation (copy-tree relation))
          (heart-state-history result))
    (refresh-heart-digest result)
    (values result relation)))

(defun unfold-horizon (horizon seed count)
  (validate-horizon horizon seed)
  (unless (nonnegative-integer-p count)
    (fire 'altered-horizon "horizon prefix length must be nonnegative"))
  (let ((current (copy-heart-deep seed))
        (steps '()))
    (dotimes (offset count)
      (let ((index (1+ offset)))
        (multiple-value-bind (next relation)
            (horizon-successor current index)
          (push (make-horizon-step index current next relation) steps)
          (setf current next))))
    (values (nreverse steps) current)))

(defun claim-prefix-as-infinity (steps)
  (declare (ignore steps))
  (fire 'finite-prefix-is-not-infinity
        "a finite witness to repeatability is not an actually completed infinity"))

(defun claim-horizon-as-proof (horizon)
  (declare (ignore horizon))
  (fire 'theological-image-is-not-evidence
        "an executable image of glory is not evidence for its metaphysical object"))

;;; ── Receipt and replay ─────────────────────────────────────────────────

(defun receipt-payload (receipt)
  (list :id (dilation-receipt-id receipt)
        :source-id (dilation-receipt-source-id receipt)
        :source-digest (dilation-receipt-source-digest receipt)
        :source-epoch (dilation-receipt-source-epoch receipt)
        :proposal-digest (dilation-receipt-proposal-digest receipt)
        :run-digest (dilation-receipt-run-digest receipt)
        :result-digest (dilation-receipt-result-digest receipt)
        :scar-digests (copy-list (dilation-receipt-scar-digests receipt))
        :horizon-digest (dilation-receipt-horizon-digest receipt)
        :horizon-step-digests
        (copy-list (dilation-receipt-horizon-step-digests receipt))
        :outward-before (dilation-receipt-outward-before receipt)
        :outward-after (dilation-receipt-outward-after receipt)
        :upward-before (dilation-receipt-upward-before receipt)
        :upward-after (dilation-receipt-upward-after receipt)
        :capacity-before (dilation-receipt-capacity-before receipt)
        :capacity-after (dilation-receipt-capacity-after receipt)
        :initial-attention (dilation-receipt-initial-attention receipt)
        :supplied-attention (dilation-receipt-supplied-attention receipt)
        :spent-attention (dilation-receipt-spent-attention receipt)
        :final-attention (dilation-receipt-final-attention receipt)
        :standing-before (dilation-receipt-standing-before receipt)
        :standing-after (dilation-receipt-standing-after receipt)
        :conclusion (dilation-receipt-conclusion receipt)))

(defun refresh-receipt-digest (receipt)
  (setf (dilation-receipt-receipt-digest receipt)
        (toy-digest (receipt-payload receipt)))
  receipt)

(defun mint-receipt (source proposal run result scars horizon steps)
  (refresh-receipt-digest
   (%make-dilation-receipt
    :id :dilation-receipt-9
    :source-id (heart-state-id source)
    :source-digest (heart-state-digest source)
    :source-epoch (heart-state-epoch source)
    :proposal-digest (dilation-proposal-proposal-digest proposal)
    :run-digest (dilation-run-run-digest run)
    :result-digest (heart-state-digest result)
    :scar-digests (mapcar #'dilation-scar-scar-digest scars)
    :horizon-digest (growth-horizon-horizon-digest horizon)
    :horizon-step-digests (mapcar #'horizon-step-step-digest steps)
    :outward-before (length (heart-state-outward-relations source))
    :outward-after (length (heart-state-outward-relations result))
    :upward-before (heart-state-upward-address source)
    :upward-after (heart-state-upward-address result)
    :capacity-before (heart-state-capacity source)
    :capacity-after (heart-state-capacity result)
    :initial-attention (dilation-run-initial-attention run)
    :supplied-attention (dilation-run-supplied-attention run)
    :spent-attention (dilation-run-spent-attention run)
    :final-attention (dilation-run-final-attention run)
    :standing-before (heart-state-standing source)
    :standing-after (heart-state-standing result)
    :conclusion :growth-preserved-in-open-fulfillment)))

(defun validate-receipt (receipt source proposal run result scars horizon steps)
  (mapc #'validate-scar scars)
  (mapc #'validate-horizon-step steps)
  (validate-run run proposal source result)
  (validate-horizon horizon result)
  (unless (and (typep receipt 'dilation-receipt)
               (string= (dilation-receipt-receipt-digest receipt)
                        (toy-digest (receipt-payload receipt)))
               (eq (dilation-receipt-source-id receipt)
                   (heart-state-id source))
               (string= (dilation-receipt-source-digest receipt)
                        (heart-state-digest source))
               (string= (dilation-receipt-proposal-digest receipt)
                        (dilation-proposal-proposal-digest proposal))
               (string= (dilation-receipt-run-digest receipt)
                        (dilation-run-run-digest run))
               (string= (dilation-receipt-result-digest receipt)
                        (heart-state-digest result))
               (equal (dilation-receipt-scar-digests receipt)
                      (mapcar #'dilation-scar-scar-digest scars))
               (string= (dilation-receipt-horizon-digest receipt)
                        (growth-horizon-horizon-digest horizon))
               (equal (dilation-receipt-horizon-step-digests receipt)
                      (mapcar #'horizon-step-step-digest steps))
               (= (dilation-receipt-outward-before receipt)
                  (length (heart-state-outward-relations source)))
               (= (dilation-receipt-outward-after receipt)
                  (length (heart-state-outward-relations result)))
               (= (dilation-receipt-upward-before receipt)
                  (heart-state-upward-address source))
               (= (dilation-receipt-upward-after receipt)
                  (heart-state-upward-address result))
               (= (dilation-receipt-capacity-before receipt)
                  (heart-state-capacity source))
               (= (dilation-receipt-capacity-after receipt)
                  (heart-state-capacity result))
               (= (dilation-receipt-initial-attention receipt)
                  (dilation-run-initial-attention run))
               (= (dilation-receipt-supplied-attention receipt)
                  (dilation-run-supplied-attention run))
               (= (dilation-receipt-spent-attention receipt)
                  (dilation-run-spent-attention run))
               (= (dilation-receipt-final-attention receipt)
                  (dilation-run-final-attention run)))
    (fire 'altered-receipt
          "dilation receipt no longer faces source, event, scars, or horizon"))
  (unless (and (eq (dilation-receipt-standing-before receipt) :asserted)
               (eq (dilation-receipt-standing-after receipt) :asserted)
               (eq (dilation-receipt-conclusion receipt)
                   :growth-preserved-in-open-fulfillment))
    (fire 'forged-fulfillment-claim
          "dilation cannot promote standing or rename an open horizon as proof"))
  receipt)

(defun supply-schedule-from-run (run)
  (mapcar #'attention-event-amount
          (dilation-run-attention-events run)))

(defun replay-dilation (proposal source original-run)
  (multiple-value-bind (replayed-run replayed-result)
      (execute-dilation
       proposal source
       :initial-attention (dilation-run-initial-attention original-run)
       :supply-schedule (supply-schedule-from-run original-run))
    (unless (and (string= (dilation-run-run-digest replayed-run)
                          (dilation-run-run-digest original-run))
                 (string= (heart-state-digest replayed-result)
                          (dilation-run-result-digest original-run)))
      (fire 'replay-diverged "dilation replay diverged"))
    (values replayed-run replayed-result)))

;;; ── The debate ─────────────────────────────────────────────────────────

(defparameter +initial-heart+
  (make-heart-state
   :id :spenserian-heart
   :epoch 0
   :core-vow '(:receive-good :remain-answerable :do-not-consume-the-other)
   :capacity 2
   :outward-relations '((:neighbor :recognized))
   :upward-address 1
   :mode :mutable-growth
   :open-p t
   :standing :asserted
   :history '((:origin :mutabilitie-debate))))

(defun make-rival-proposals (source)
  (list
   (make-dilation-proposal
    :id :eternal-fixity-alone :source source :operation :freeze
    :core-claim (heart-state-core-vow source)
    :completion-claim :closed :cost 1
    :rationale '(:preserve-by-forbidding-change))
   (make-dilation-proposal
    :id :changefulness-alone :source source :operation :replace
    :core-claim '(:new-heart-without-predecessor)
    :additions '((:novelty :total))
    :losses (heart-state-outward-relations source)
    :capacity-delta 1 :upward-delta 0 :cost 1
    :rationale '(:replace-everything-that-came-before))
   (make-dilation-proposal
    :id :substitutional-ascesis :source source :operation :substitute
    :core-claim (heart-state-core-vow source)
    :losses (heart-state-outward-relations source)
    :capacity-delta 0 :upward-delta 4 :cost 2
    :rationale '(:god-instead-of-world))
   (make-dilation-proposal
    :id :empty-inflation :source source :operation :inflate
    :core-claim (heart-state-core-vow source)
    :capacity-delta 12 :upward-delta 0 :cost 1
    :rationale '(:larger-container-no-new-relation))
   (make-dilation-proposal
    :id :premature-glory :source source :operation :dilate
    :core-claim (heart-state-core-vow source)
    :additions '((:natural-cosmos :addressed))
    :capacity-delta 1 :upward-delta 1
    :completion-claim :complete :cost 2
    :rationale '(:growth-declared-finished))
   (make-dilation-proposal
    :id :rhetoric-as-verification :source source :operation :dilate
    :core-claim (heart-state-core-vow source)
    :additions '((:natural-cosmos :addressed))
    :capacity-delta 1 :upward-delta 1
    :standing-claim :verified :cost 2
    :rationale '(:beautiful-synthesis-therefore-true))))

(defun make-lawful-dilation (source)
  (make-dilation-proposal
   :id :dilation-of-the-heart
   :source source
   :operation :dilate
   :core-claim (heart-state-core-vow source)
   :additions
   '((:natural-cosmos :addressed)
     (:human-society :addressed)
     (:sexual-other :reciprocal-and-not-consumed))
   :losses '()
   :capacity-delta 3
   :upward-delta 2
   :completion-claim :open-horizon
   :standing-claim :asserted
   :cost 4
   :rationale
   '(:change-as-expansion
     :horizontal-and-vertical-noncompetitive
     :old-relations-retained
     :future-growth-not-closed)))

;;; ── Exhibit ────────────────────────────────────────────────────────────

(defun print-heart (label heart)
  (format t " ~a~%" label)
  (format t "   capacity: ~d~%" (heart-state-capacity heart))
  (format t "   outward:  ~s~%" (heart-state-outward-relations heart))
  (format t "   upward:   ~d~%" (heart-state-upward-address heart))
  (format t "   mode:     ~s; open: ~s; standing: ~s~%"
          (heart-state-mode heart)
          (heart-state-open-p heart)
          (heart-state-standing heart)))

(defun demonstrate ()
  (banner "DE DILATATIONE — CONCERNING DILATION")
  (format t "Claim: fixity and change need not compete when change is typed~%")
  (format t "       as capacity-preserving growth along outward and upward axes.~%")
  (let* ((source (copy-heart-deep +initial-heart+))
         (rivals (make-rival-proposals source))
         (scars
           (loop for proposal in rivals
                 for sequence from 1
                 collect (archive-refusal sequence proposal source)))
         (lawful (make-lawful-dilation source)))

    (section "I. THE RIVAL ABSOLUTES LEAVE DISTINCT SCARS")
    (mapc #'validate-scar scars)
    (ensure (= (length scars) 6)
            "six rival or counterfeit syntheses should be archived")
    (format t " archived conditions: ~s~%"
            (mapcar #'dilation-scar-condition-type scars))

    (section "II. DILATION IS NOT A ZERO-SUM TRANSFER")
    (print-heart "before:" source)
    (multiple-value-bind (run result)
        (handler-bind
            ((attention-exhausted
               (lambda (condition)
                 (format t " attention boundary for ~s: supplying 2~%"
                         (exhausted-proposal-id condition))
                 (invoke-restart 'supply-attention 2))))
          (execute-dilation lawful source :initial-attention 2))
      (validate-run run lawful source result)
      (print-heart "after:" result)
      (ensure (= (length (heart-state-outward-relations result)) 4)
              "one inherited and three new relations should remain")
      (ensure (= (heart-state-upward-address result) 3)
              "upward address should grow from one to three")
      (ensure (relation-present-p
               '(:neighbor :recognized)
               (heart-state-outward-relations result))
              "old worldly relation was silently sacrificed")
      (ensure (= (dilation-run-supplied-attention run) 2)
              "repaired attention must remain in the event")
      (ensure (= (dilation-run-final-attention run) 0)
              "attention ledger should close at zero")
      (pass "horizontal expansion and vertical lift increased together")

      (section "III. FULFILLMENT PRESERVES THE SUCCESSOR RULE")
      (let ((horizon (make-growth-horizon result)))
        (multiple-value-bind (steps prefix-end)
            (unfold-horizon horizon result 3)
          (declare (ignore prefix-end))
          (format t " finite prefix:~%")
          (dolist (step steps)
            (format t "  step ~d: +~s; upward ~d→~d; capacity ~d→~d~%"
                    (horizon-step-index step)
                    (horizon-step-added-relation step)
                    (horizon-step-upward-before step)
                    (horizon-step-upward-after step)
                    (horizon-step-capacity-before step)
                    (horizon-step-capacity-after step)))
          (expect-condition finite-prefix-is-not-infinity
            (claim-prefix-as-infinity steps))
          (expect-condition theological-image-is-not-evidence
            (claim-horizon-as-proof horizon))

          (section "IV. THE RECEIPT KEEPS GROWTH OPEN AND STANDING BOUNDED")
          (let ((receipt
                  (mint-receipt source lawful run result scars horizon steps)))
            (validate-receipt receipt source lawful run result scars
                              horizon steps)
            (format t " outward:   ~d → ~d~%"
                    (dilation-receipt-outward-before receipt)
                    (dilation-receipt-outward-after receipt))
            (format t " upward:    ~d → ~d~%"
                    (dilation-receipt-upward-before receipt)
                    (dilation-receipt-upward-after receipt))
            (format t " capacity:  ~d → ~d~%"
                    (dilation-receipt-capacity-before receipt)
                    (dilation-receipt-capacity-after receipt))
            (format t " conclusion: ~s~%"
                    (dilation-receipt-conclusion receipt))
            (let ((forged (copy-dilation-receipt receipt)))
              (setf (dilation-receipt-conclusion forged)
                    :eternal-glory-proven
                    (dilation-receipt-standing-after forged) :verified)
              (refresh-receipt-digest forged)
              (expect-condition forged-fulfillment-claim
                (validate-receipt forged source lawful run result scars
                                  horizon steps))))

          (section "V. REPLAY RETAINS THE REPAIR")
          (multiple-value-bind (replayed-run replayed-result)
              (replay-dilation lawful source run)
            (declare (ignore replayed-result))
            (ensure (= (dilation-run-supplied-attention replayed-run) 2)
                    "replay erased supplied attention")
            (pass "same source, proposal, repair, and result replayed"))

          (section "VI. OLD PLANS DO NOT GOVERN A CHANGED HEART")
          (let ((changed (copy-heart-deep source)))
            (incf (heart-state-epoch changed))
            (push '(:event :history-continued)
                  (heart-state-history changed))
            (refresh-heart-digest changed)
            (expect-condition stale-proposal
              (execute-dilation lawful changed :initial-attention 4)))

          (section "EXHIBIT")
          (format t " fixity alone:          archived as petrification~%")
          (format t " change alone:          archived as replacement~%")
          (format t " substitutional ascent: archived as zero-sum loss~%")
          (format t " lawful dilation:       outward 1→4; upward 1→3~%")
          (format t " fulfillment:           an open successor horizon~%")
          (format t " standing:              :ASSERTED → :ASSERTED~%")
          (format t " verdict:               :GROWTH-PRESERVED-IN-OPEN-FULFILLMENT~%")
          (format t "~%The heart becomes more capacious without making God and world rivals.~%")
          (pass "DE DILATATIONE complete")
          t)))))

(demonstrate)
