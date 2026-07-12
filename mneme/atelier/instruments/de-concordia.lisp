;;;; de-concordia.lisp — Concerning Concord
;;;;
;;;; A Lisp+ Atelier instrument after de-dilatatione.  Virginia Woolf's
;;;; layered account of reading poetry becomes an executable distinction
;;;; between activation, accumulation, and concord.  The eye, sympathy,
;;;; movement, and poetic belief arrive in order; no earlier faculty is
;;;; discarded, and no later faculty may impersonate epistemic proof.
;;;;
;;;; THESIS
;;;;   * an image is not yet a world;
;;;;   * sympathy is accompaniment, not identity-collapse or obedience;
;;;;   * movement is not yet combination;
;;;;   * a bag of activated faculties is not concord without support edges;
;;;;   * mutual support is not numerical identity;
;;;;   * poetic belief is internal world-sustaining coherence, not evidence;
;;;;   * a broken support relation must remain visible as a named failure;
;;;;   * staged reading consumes attunement and repaired attunement remains
;;;;     part of the event and its replay;
;;;;   * the interpreter is part of the inheritance of the reading.
;;;;
;;;; WHAT THIS DOES NOT ESTABLISH
;;;; This is a deterministic, cooperative, single-process model over finite
;;;; proper-list data.  It does not measure literary quality, model a human
;;;; nervous system, prove Woolf's account exhaustive, or establish anything
;;;; about the historical Spenser beyond the bounded symbolic exhibit.  Its
;;;; "poetic belief" means sustained internal concord in this instrument; it
;;;; is not factual belief, assent, verification, or metaphysical proof.  The
;;;; digest supplied by the Atelier root is pedagogical, not cryptographic.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*)))

(defpackage #:lispplus-atelier.de-concordia
  (:use #:cl #:lispplus-atelier))

(in-package #:lispplus-atelier.de-concordia)

(reset-clock 15100)

;;; ── Conditions: every counterfeit combination fails by name ───────────

(define-condition concord-error (error)
  ((detail :initarg :detail :reader concord-error-detail :initform ""))
  (:report (lambda (condition stream)
             (format stream "~a" (concord-error-detail condition)))))

(define-condition malformed-world (concord-error) ())
(define-condition malformed-plan (concord-error) ())
(define-condition malformed-event (concord-error) ())
(define-condition altered-plan (concord-error) ())
(define-condition altered-event (concord-error) ())
(define-condition altered-scar (concord-error) ())
(define-condition altered-run (concord-error) ())
(define-condition altered-receipt (concord-error) ())
(define-condition stale-reading-plan (concord-error) ())
(define-condition source-changed (concord-error) ())
(define-condition reader-procedure-unavailable (concord-error) ())
(define-condition faculty-order-violation (concord-error) ())
(define-condition image-is-not-world (concord-error) ())
(define-condition sympathy-is-not-identity (concord-error) ())
(define-condition sympathy-is-not-obedience (concord-error) ())
(define-condition movement-is-not-combination (concord-error) ())
(define-condition aggregation-is-not-concord (concord-error) ())
(define-condition support-is-not-identity (concord-error) ())
(define-condition belief-thread-broken (concord-error) ())
(define-condition poetic-belief-is-not-evidence (concord-error) ())
(define-condition forged-belief-claim (concord-error) ())
(define-condition replay-diverged (concord-error) ())

(define-condition attunement-exhausted (concord-error)
  ((needed :initarg :needed :reader exhausted-needed)
   (available :initarg :available :reader exhausted-available)
   (stage :initarg :stage :reader exhausted-stage)))

(defun fire (type control &rest arguments)
  (error type :detail (apply #'format nil control arguments)))

(defmacro expect-condition (type &body body)
  "Require TYPE to fire; another CONCORD-ERROR is not accepted as a pass."
  (let ((condition (gensym "CONDITION")))
    `(handler-case
         (progn
           ,@body
           (error "expected ~a, but no condition fired" ',type))
       (,type (,condition)
         (declare (ignore ,condition))
         (pass (format nil "~a fired" ',type)))
       (concord-error (,condition)
         (error "expected ~a, received ~a: ~a"
                ',type (type-of ,condition) ,condition)))))

;;; ── Records ────────────────────────────────────────────────────────────

(defstruct (poem-world (:constructor %make-poem-world))
  id epoch figures scenes seen sympathy movement support-edges
  faculty-order poetic-belief standing history digest)

(defstruct (reading-plan (:constructor %make-reading-plan))
  id source-id source-epoch source-digest procedure procedure-version
  script stage-costs claim standing-claim plan-digest)

(defstruct (faculty-event (:constructor %make-faculty-event))
  sequence stage cost before-digest after-digest activations relations
  belief-before belief-after event-digest)

(defstruct (attunement-event (:constructor %make-attunement-event))
  sequence stage amount before after event-digest)

(defstruct (misreading-scar (:constructor %make-misreading-scar))
  sequence proposal condition-type detail rejected-digest scar-digest)

(defstruct (reading-run (:constructor %make-reading-run))
  id source-digest plan-digest initial-attunement supplied-attunement
  spent-attunement final-attunement faculty-events attunement-events
  result-digest run-digest)

(defstruct (concord-receipt (:constructor %make-concord-receipt))
  id source-id source-epoch source-digest plan-digest run-digest
  result-digest event-digests scar-digests faculty-order
  seen-count sympathy-count movement-count support-count
  initial-attunement supplied-attunement spent-attunement final-attunement
  poetic-belief standing-before standing-after conclusion receipt-digest)

;;; ── Structural floor ───────────────────────────────────────────────────

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

(defun require-finite-tree (object context &optional (condition 'malformed-world))
  (unless (finite-tree-p object)
    (fire condition "~a must be a finite proper-list tree: ~s" context object))
  object)

(defun nonnegative-integer-p (object)
  (and (integerp object) (not (minusp object))))

(defun positive-integer-p (object)
  (and (integerp object) (plusp object)))

(defun same-set-p (left right)
  (and (null (set-difference left right :test #'equal))
       (null (set-difference right left :test #'equal))))

(defun alist-value (key alist)
  (cdr (assoc key alist :test #'equal)))

(defun relation-key (relation)
  (subseq relation 0 (min 3 (length relation))))

(defun relation-present-p (relation relations)
  (member (relation-key relation) relations
          :key #'relation-key :test #'equal))

(defun add-unique (items additions &key (test #'equal))
  (let ((result (copy-tree items)))
    (dolist (item additions result)
      (unless (member item result :test test)
        (setf result (append result (list (copy-tree item))))))))

;;; ── The poem-world ─────────────────────────────────────────────────────

(defun world-payload (world)
  (list :id (poem-world-id world)
        :epoch (poem-world-epoch world)
        :figures (copy-tree (poem-world-figures world))
        :scenes (copy-tree (poem-world-scenes world))
        :seen (copy-tree (poem-world-seen world))
        :sympathy (copy-tree (poem-world-sympathy world))
        :movement (copy-tree (poem-world-movement world))
        :support-edges (copy-tree (poem-world-support-edges world))
        :faculty-order (copy-tree (poem-world-faculty-order world))
        :poetic-belief (poem-world-poetic-belief world)
        :standing (poem-world-standing world)
        :history (copy-tree (poem-world-history world))))

(defun refresh-world-digest (world)
  (setf (poem-world-digest world) (toy-digest (world-payload world)))
  world)

(defun make-poem-world (&key id (epoch 0) figures scenes (seen '())
                             (sympathy '()) (movement '())
                             (support-edges '()) (faculty-order '())
                             (poetic-belief :not-yet-sustained)
                             (standing :asserted) (history '()))
  (unless (and id (nonnegative-integer-p epoch)
               (proper-list-p figures) (proper-list-p scenes)
               (proper-list-p seen) (proper-list-p sympathy)
               (proper-list-p movement) (proper-list-p support-edges)
               (proper-list-p faculty-order)
               (member poetic-belief
                       '(:not-yet-sustained :sustained :broken) :test #'eq)
               (member standing '(:asserted :verified) :test #'eq))
    (fire 'malformed-world "invalid poem-world constructor arguments"))
  (mapc (lambda (pair)
          (require-finite-tree (cdr pair) (car pair)))
        `((:figures . ,figures) (:scenes . ,scenes) (:seen . ,seen)
          (:sympathy . ,sympathy) (:movement . ,movement)
          (:support . ,support-edges) (:history . ,history)))
  (refresh-world-digest
   (%make-poem-world
    :id id :epoch epoch :figures (copy-tree figures)
    :scenes (copy-tree scenes) :seen (copy-tree seen)
    :sympathy (copy-tree sympathy) :movement (copy-tree movement)
    :support-edges (copy-tree support-edges)
    :faculty-order (copy-tree faculty-order)
    :poetic-belief poetic-belief :standing standing
    :history (copy-tree history))))

(defun copy-world-deep (world)
  (make-poem-world
   :id (poem-world-id world)
   :epoch (poem-world-epoch world)
   :figures (poem-world-figures world)
   :scenes (poem-world-scenes world)
   :seen (poem-world-seen world)
   :sympathy (poem-world-sympathy world)
   :movement (poem-world-movement world)
   :support-edges (poem-world-support-edges world)
   :faculty-order (poem-world-faculty-order world)
   :poetic-belief (poem-world-poetic-belief world)
   :standing (poem-world-standing world)
   :history (poem-world-history world)))

(defun validate-world (world)
  (unless (typep world 'poem-world)
    (fire 'malformed-world "expected POEM-WORLD, received ~s" world))
  (unless (and (nonnegative-integer-p (poem-world-epoch world))
               (proper-list-p (poem-world-faculty-order world))
               (member (poem-world-poetic-belief world)
                       '(:not-yet-sustained :sustained :broken) :test #'eq)
               (string= (poem-world-digest world)
                        (toy-digest (world-payload world))))
    (fire 'malformed-world "world ~s is structurally invalid or altered"
          (poem-world-id world)))
  world)

(defun figure-known-p (world id)
  (assoc id (poem-world-figures world) :test #'eq))

(defun scene-known-p (world id)
  (assoc id (poem-world-scenes world) :test #'eq))

;;; ── Reader procedures and the homoiconic script ───────────────────────

(defparameter *reader-procedures* (make-hash-table :test #'equal))

(defun register-reader (name version)
  (setf (gethash (list name version) *reader-procedures*) t))

(defun unregister-reader (name version)
  (remhash (list name version) *reader-procedures*))

(defun reader-available-p (name version)
  (gethash (list name version) *reader-procedures*))

(register-reader :woolf-layered-reader 1)

(defparameter +required-faculty-order+
  '(:sensual :sympathetic :kinetic :concordant))

(defparameter +woolf-reading-script+
  '(:reading
    (:procedure :woolf-layered-reader :version 1)
    (:sensual
     (:rouse (:green-tree :pearled-lady :crested-knight)))
    (:sympathetic
     (:go-with (:crested-knight :pearled-lady))
     (:feel (:heat :cold :thirst :hunger)))
    (:kinetic
     (:move (:crested-knight :pearled-lady)
      :along :grass-track
      :toward (:hovel :palace :reader-in-weeds)))
    (:concordant
     (:support
      ((:green-tree :crested-knight :inhabited-world)
       (:crested-knight :pearled-lady :shared-quest)
       (:pearled-lady :green-tree :world-return)
       (:reader :crested-knight :sympathetic-attendance)
       (:reader :pearled-lady :sympathetic-attendance)))
     (:belief :sustained))))

(defun plan-payload (plan)
  (list :id (reading-plan-id plan)
        :source-id (reading-plan-source-id plan)
        :source-epoch (reading-plan-source-epoch plan)
        :source-digest (reading-plan-source-digest plan)
        :procedure (reading-plan-procedure plan)
        :procedure-version (reading-plan-procedure-version plan)
        :script (copy-tree (reading-plan-script plan))
        :stage-costs (copy-tree (reading-plan-stage-costs plan))
        :claim (reading-plan-claim plan)
        :standing-claim (reading-plan-standing-claim plan)))

(defun refresh-plan-digest (plan)
  (setf (reading-plan-plan-digest plan) (toy-digest (plan-payload plan)))
  plan)

(defun script-stage (script stage)
  (assoc stage (rest script) :test #'eq))

(defun compile-reading (source script)
  (validate-world source)
  (require-finite-tree script "reading script" 'malformed-plan)
  (unless (and (consp script) (eq (first script) :reading))
    (fire 'malformed-plan "reading script must begin with :READING"))
  (let* ((procedure-form (assoc :procedure (rest script) :test #'eq))
         (procedure (second procedure-form))
         (version (getf (cddr procedure-form) :version)))
    (unless (and procedure-form procedure (positive-integer-p version))
      (fire 'malformed-plan "script lacks a valid procedure declaration"))
    (dolist (stage +required-faculty-order+)
      (unless (script-stage script stage)
        (fire 'malformed-plan "script lacks stage ~s" stage)))
    (refresh-plan-digest
     (%make-reading-plan
      :id :woolfian-concord-1
      :source-id (poem-world-id source)
      :source-epoch (poem-world-epoch source)
      :source-digest (poem-world-digest source)
      :procedure procedure :procedure-version version
      :script (copy-tree script)
      :stage-costs '((:sensual . 1) (:sympathetic . 1)
                     (:kinetic . 2) (:concordant . 2))
      :claim :world-sustained-by-concord
      :standing-claim :asserted))))

(defun validate-plan (plan source)
  (unless (typep plan 'reading-plan)
    (fire 'malformed-plan "expected READING-PLAN, received ~s" plan))
  (validate-world source)
  (unless (string= (reading-plan-plan-digest plan)
                   (toy-digest (plan-payload plan)))
    (fire 'altered-plan "reading plan ~s was altered"
          (reading-plan-id plan)))
  (unless (and (eq (reading-plan-source-id plan) (poem-world-id source))
               (= (reading-plan-source-epoch plan) (poem-world-epoch source)))
    (fire 'stale-reading-plan
          "plan ~s addresses another source identity or epoch"
          (reading-plan-id plan)))
  (unless (string= (reading-plan-source-digest plan)
                   (poem-world-digest source))
    (fire 'source-changed "source changed after reading was planned"))
  (unless (reader-available-p (reading-plan-procedure plan)
                              (reading-plan-procedure-version plan))
    (fire 'reader-procedure-unavailable
          "reader ~s version ~d is unavailable"
          (reading-plan-procedure plan)
          (reading-plan-procedure-version plan)))
  (unless (and (eq (reading-plan-claim plan) :world-sustained-by-concord)
               (eq (reading-plan-standing-claim plan) :asserted)
               (equal (mapcar #'car (reading-plan-stage-costs plan))
                      +required-faculty-order+))
    (fire 'malformed-plan "plan claim, standing, or stage order is invalid"))
  plan)

(defun stage-cost (plan stage)
  (or (cdr (assoc stage (reading-plan-stage-costs plan) :test #'eq))
      (fire 'malformed-plan "no cost declared for stage ~s" stage)))

;;; ── Misreadings and scars ──────────────────────────────────────────────

(defun scar-payload (scar)
  (list :sequence (misreading-scar-sequence scar)
        :proposal (copy-tree (misreading-scar-proposal scar))
        :condition-type (misreading-scar-condition-type scar)
        :detail (misreading-scar-detail scar)
        :rejected-digest (misreading-scar-rejected-digest scar)))

(defun refresh-scar-digest (scar)
  (setf (misreading-scar-scar-digest scar)
        (toy-digest (scar-payload scar)))
  scar)

(defun make-scar (sequence proposal condition)
  (refresh-scar-digest
   (%make-misreading-scar
    :sequence sequence :proposal (copy-tree proposal)
    :condition-type (type-of condition)
    :detail (princ-to-string condition)
    :rejected-digest (toy-digest proposal))))

(defun validate-scar (scar)
  (unless (and (typep scar 'misreading-scar)
               (positive-integer-p (misreading-scar-sequence scar))
               (string= (misreading-scar-rejected-digest scar)
                        (toy-digest (misreading-scar-proposal scar)))
               (string= (misreading-scar-scar-digest scar)
                        (toy-digest (scar-payload scar))))
    (fire 'altered-scar "misreading scar is invalid or altered"))
  scar)

(defun refuse-misreading (proposal)
  (case (getf proposal :kind)
    (:image-totalization
     (fire 'image-is-not-world
           "vivid images do not yet constitute a mutually supporting world"))
    (:sympathy-collapse
     (fire 'sympathy-is-not-identity
           "going with a figure does not make reader and figure identical"))
    (:sympathy-command
     (fire 'sympathy-is-not-obedience
           "sympathetic accompaniment does not transfer command authority"))
    (:motion-totalization
     (fire 'movement-is-not-combination
           "arrival at a hovel or palace does not yet combine the world"))
    (:feature-bag
     (fire 'aggregation-is-not-concord
           "activated faculties without support relations are only a bag"))
    (:identity-by-support
     (fire 'support-is-not-identity
           "mutual support preserves the relata whose support is described"))
    (:truth-upgrade
     (fire 'poetic-belief-is-not-evidence
           "poetic belief cannot promote :ASSERTED to :VERIFIED"))
    (otherwise
     (fire 'malformed-plan "unknown misreading proposal ~s" proposal))))

(defun archive-misreading (sequence proposal)
  (handler-case
      (progn
        (refuse-misreading proposal)
        (error "misreading unexpectedly passed: ~s" proposal))
    (concord-error (condition)
      (make-scar sequence proposal condition))))

(defun make-misreadings ()
  (list
   '(:kind :image-totalization :claim :world-complete)
   '(:kind :sympathy-collapse :reader-becomes :crested-knight)
   '(:kind :sympathy-command :figure-controls-reader)
   '(:kind :motion-totalization :arrival-means-combination)
   '(:kind :feature-bag
     :faculties (:sensual :sympathetic :kinetic :concordant)
     :support ())
   '(:kind :identity-by-support :tree-is-knight-is-lady)
   '(:kind :truth-upgrade :standing :verified)))

;;; ── Faculty events ─────────────────────────────────────────────────────

(defun event-payload (event)
  (list :sequence (faculty-event-sequence event)
        :stage (faculty-event-stage event)
        :cost (faculty-event-cost event)
        :before-digest (faculty-event-before-digest event)
        :after-digest (faculty-event-after-digest event)
        :activations (copy-tree (faculty-event-activations event))
        :relations (copy-tree (faculty-event-relations event))
        :belief-before (faculty-event-belief-before event)
        :belief-after (faculty-event-belief-after event)))

(defun refresh-event-digest (event)
  (setf (faculty-event-event-digest event)
        (toy-digest (event-payload event)))
  event)

(defun make-faculty-event (sequence stage cost before after activations relations)
  (refresh-event-digest
   (%make-faculty-event
    :sequence sequence :stage stage :cost cost
    :before-digest (poem-world-digest before)
    :after-digest (poem-world-digest after)
    :activations (copy-tree activations)
    :relations (copy-tree relations)
    :belief-before (poem-world-poetic-belief before)
    :belief-after (poem-world-poetic-belief after))))

(defun validate-event (event before after expected-stage expected-sequence)
  (unless (and (typep event 'faculty-event)
               (= (faculty-event-sequence event) expected-sequence)
               (eq (faculty-event-stage event) expected-stage)
               (positive-integer-p (faculty-event-cost event))
               (string= (faculty-event-before-digest event)
                        (poem-world-digest before))
               (string= (faculty-event-after-digest event)
                        (poem-world-digest after))
               (string= (faculty-event-event-digest event)
                        (toy-digest (event-payload event))))
    (fire 'malformed-event "faculty event ~d/~s is invalid or altered"
          expected-sequence expected-stage))
  event)

(defun expected-prefix-before (stage)
  (subseq +required-faculty-order+
          0 (position stage +required-faculty-order+ :test #'eq)))

(defun require-stage-order (world stage)
  (unless (equal (poem-world-faculty-order world)
                 (expected-prefix-before stage))
    (fire 'faculty-order-violation
          "stage ~s requires completed prefix ~s, received ~s"
          stage (expected-prefix-before stage)
          (poem-world-faculty-order world))))

(defun sensual-stage (world stage-form)
  (declare (ignore stage-form))
  (require-stage-order world :sensual)
  (let* ((after (copy-world-deep world))
         (images '(:green-tree :pearled-lady :crested-knight)))
    (dolist (image images)
      (unless (or (figure-known-p world image) (scene-known-p world image))
        (fire 'malformed-world "sensual image ~s is absent from source" image)))
    (setf (poem-world-seen after)
          (add-unique (poem-world-seen after) images)
          (poem-world-faculty-order after) '(:sensual))
    (push '(:faculty :sensual :eye-of-mind-opened)
          (poem-world-history after))
    (refresh-world-digest after)
    (values after images '((:eye :opens-upon :image)))))

(defun sympathetic-stage (world stage-form)
  (declare (ignore stage-form))
  (require-stage-order world :sympathetic)
  (unless (same-set-p (poem-world-seen world)
                      '(:green-tree :pearled-lady :crested-knight))
    (fire 'image-is-not-world
          "sympathy cannot proceed as though the sensual layer never opened"))
  (let* ((after (copy-world-deep world))
         (activations
           '((:reader :goes-with :crested-knight)
             (:reader :goes-with :pearled-lady)
             (:reader :feels-with :heat)
             (:reader :feels-with :cold)
             (:reader :feels-with :thirst)
             (:reader :feels-with :hunger))))
    (setf (poem-world-sympathy after)
          (add-unique (poem-world-sympathy after) activations)
          (poem-world-faculty-order after)
          '(:sensual :sympathetic))
    (push '(:faculty :sympathetic :otherness-retained)
          (poem-world-history after))
    (refresh-world-digest after)
    (values after activations
            '((:reader :accompanies :figures)
              (:figures :remain-distinct-from :reader)))))

(defun kinetic-stage (world stage-form)
  (declare (ignore stage-form))
  (require-stage-order world :kinetic)
  (unless (>= (length (poem-world-sympathy world)) 6)
    (fire 'faculty-order-violation
          "kinetic layer lacks the sympathetic accompaniment it carries"))
  (let* ((after (copy-world-deep world))
         (moves
           '((:crested-knight :along :grass-track :toward :hovel)
             (:pearled-lady :along :grass-track :toward :palace)
             (:crested-knight :encounters :reader-in-weeds)
             (:pearled-lady :encounters :reader-in-weeds))))
    (dolist (destination '(:grass-track :hovel :palace :reader-in-weeds))
      (unless (scene-known-p world destination)
        (fire 'malformed-world "kinetic destination ~s is absent" destination)))
    (setf (poem-world-movement after)
          (add-unique (poem-world-movement after) moves)
          (poem-world-faculty-order after)
          '(:sensual :sympathetic :kinetic))
    (push '(:faculty :kinetic :figures-carried-through-world)
          (poem-world-history after))
    (refresh-world-digest after)
    (values after moves '((:path :carries :figure)
                          (:arrival :does-not-yet-imply :concord)))))

(defun required-support-edges ()
  '((:green-tree :crested-knight :inhabited-world)
    (:crested-knight :pearled-lady :shared-quest)
    (:pearled-lady :green-tree :world-return)
    (:reader :crested-knight :sympathetic-attendance)
    (:reader :pearled-lady :sympathetic-attendance)
    (:grass-track :crested-knight :narrative-carry)
    (:grass-track :pearled-lady :narrative-carry)))

(defun support-complete-p (edges)
  (every (lambda (edge) (relation-present-p edge edges))
         (required-support-edges)))

(defun concordant-stage (world stage-form)
  (declare (ignore stage-form))
  (require-stage-order world :concordant)
  (unless (>= (length (poem-world-movement world)) 4)
    (fire 'movement-is-not-combination
          "concordant layer requires movement but is not reducible to it"))
  (let* ((after (copy-world-deep world))
         (edges (required-support-edges)))
    (setf (poem-world-support-edges after)
          (add-unique (poem-world-support-edges after) edges)
          (poem-world-faculty-order after)
          (copy-list +required-faculty-order+)
          (poem-world-poetic-belief after) :sustained)
    (push '(:faculty :concordant :world-mutually-supported)
          (poem-world-history after))
    (refresh-world-digest after)
    (unless (support-complete-p (poem-world-support-edges after))
      (fire 'belief-thread-broken
            "concordant stage failed to establish all required supports"))
    (values after edges '((:tree :supports :knight)
                          (:knight :supports :lady)
                          (:lady :returns-to :world)
                          (:support :preserves :difference)))))

(defun apply-stage (world stage stage-form)
  (case stage
    (:sensual (sensual-stage world stage-form))
    (:sympathetic (sympathetic-stage world stage-form))
    (:kinetic (kinetic-stage world stage-form))
    (:concordant (concordant-stage world stage-form))
    (otherwise
     (fire 'malformed-plan "unknown faculty stage ~s" stage))))

;;; ── Attunement accounting ──────────────────────────────────────────────

(defun attunement-payload (event)
  (list :sequence (attunement-event-sequence event)
        :stage (attunement-event-stage event)
        :amount (attunement-event-amount event)
        :before (attunement-event-before event)
        :after (attunement-event-after event)))

(defun make-attunement-event (sequence stage amount before after)
  (let ((event (%make-attunement-event
                :sequence sequence :stage stage :amount amount
                :before before :after after)))
    (setf (attunement-event-event-digest event)
          (toy-digest (attunement-payload event)))
    event))

(defun validate-attunement-event (event)
  (unless (and (typep event 'attunement-event)
               (positive-integer-p (attunement-event-sequence event))
               (positive-integer-p (attunement-event-amount event))
               (= (+ (attunement-event-before event)
                     (attunement-event-amount event))
                  (attunement-event-after event))
               (string= (attunement-event-event-digest event)
                        (toy-digest (attunement-payload event))))
    (fire 'altered-run "attunement event is invalid or altered"))
  event)

;;; ── Execution ──────────────────────────────────────────────────────────

(defun run-payload (run)
  (list :id (reading-run-id run)
        :source-digest (reading-run-source-digest run)
        :plan-digest (reading-run-plan-digest run)
        :initial-attunement (reading-run-initial-attunement run)
        :supplied-attunement (reading-run-supplied-attunement run)
        :spent-attunement (reading-run-spent-attunement run)
        :final-attunement (reading-run-final-attunement run)
        :faculty-events (mapcar #'faculty-event-event-digest
                                (reading-run-faculty-events run))
        :attunement-events (mapcar #'attunement-event-event-digest
                                   (reading-run-attunement-events run))
        :result-digest (reading-run-result-digest run)))

(defun refresh-run-digest (run)
  (setf (reading-run-run-digest run) (toy-digest (run-payload run)))
  run)

(defun execute-reading (plan source &key (initial-attunement 0)
                                      supply-schedule)
  (validate-plan plan source)
  (unless (nonnegative-integer-p initial-attunement)
    (fire 'malformed-plan "initial attunement must be nonnegative"))
  (let ((current (copy-world-deep source))
        (available initial-attunement)
        (supplied 0)
        (spent 0)
        (faculty-events '())
        (attunement-events '())
        (supply-index 0))
    (labels ((supply (stage amount)
               (unless (positive-integer-p amount)
                 (fire 'malformed-plan "supplied attunement must be positive"))
               (let ((before available))
                 (incf available amount)
                 (incf supplied amount)
                 (push (make-attunement-event
                        (1+ (length attunement-events))
                        stage amount before available)
                       attunement-events)))
             (obtain (stage cost)
               (loop while (< available cost) do
                 (restart-case
                     (error 'attunement-exhausted
                            :needed cost :available available :stage stage
                            :detail (format nil
                                            "stage ~s needs ~d attunement; ~d available"
                                            stage cost available))
                   (supply-attunement (amount)
                     :report "Supply attunement and continue the reading."
                     (supply stage amount))
                   (abort-reading ()
                     :report "Abort without committing a result."
                     (return-from execute-reading
                       (values nil nil)))))
               (decf available cost)
               (incf spent cost)))
      (dolist (stage +required-faculty-order+)
        (let ((cost (stage-cost plan stage)))
          (loop while (and supply-schedule (< available cost)) do
            (unless (< supply-index (length supply-schedule))
              (fire 'replay-diverged
                    "replay exhausted its recorded supply schedule"))
            (destructuring-bind (scheduled-stage amount)
                (nth supply-index supply-schedule)
              (unless (eq scheduled-stage stage)
                (fire 'replay-diverged
                      "replay expected supply at ~s, found ~s"
                      stage scheduled-stage))
              (incf supply-index)
              (supply stage amount)))
          (obtain stage cost)
          (let ((before (copy-world-deep current)))
            (multiple-value-bind (after activations relations)
                (apply-stage current stage
                             (script-stage (reading-plan-script plan) stage))
              (push (make-faculty-event
                     (1+ (length faculty-events)) stage cost
                     before after activations relations)
                    faculty-events)
              (setf current after)))))
      (when (and supply-schedule (/= supply-index (length supply-schedule)))
        (fire 'replay-diverged "replay left unused supply events"))
      (let ((run
              (refresh-run-digest
               (%make-reading-run
                :id :woolfian-reading-run-1
                :source-digest (poem-world-digest source)
                :plan-digest (reading-plan-plan-digest plan)
                :initial-attunement initial-attunement
                :supplied-attunement supplied
                :spent-attunement spent
                :final-attunement available
                :faculty-events (nreverse faculty-events)
                :attunement-events (nreverse attunement-events)
                :result-digest (poem-world-digest current)))))
        (values run current)))))

(defun validate-run (run plan source result)
  (unless (typep run 'reading-run)
    (fire 'altered-run "expected READING-RUN"))
  (validate-plan plan source)
  (validate-world result)
  (loop for event in (reading-run-faculty-events run)
        for stage in +required-faculty-order+
        for sequence from 1
        do (unless (and (= (faculty-event-sequence event) sequence)
                        (eq (faculty-event-stage event) stage)
                        (= (faculty-event-cost event) (stage-cost plan stage))
                        (string= (faculty-event-event-digest event)
                                 (toy-digest (event-payload event))))
             (fire 'altered-run
                   "faculty event ~d/~s is malformed or altered"
                   sequence stage)))
  (unless (and (string= (reading-run-source-digest run)
                        (poem-world-digest source))
               (string= (reading-run-plan-digest run)
                        (reading-plan-plan-digest plan))
               (string= (reading-run-result-digest run)
                        (poem-world-digest result))
               (= (+ (reading-run-initial-attunement run)
                     (reading-run-supplied-attunement run))
                  (+ (reading-run-spent-attunement run)
                     (reading-run-final-attunement run)))
               (= (reading-run-spent-attunement run)
                  (reduce #'+ (mapcar #'cdr
                                      (reading-plan-stage-costs plan))))
               (= (length (reading-run-faculty-events run)) 4)
               (equal (mapcar #'faculty-event-stage
                              (reading-run-faculty-events run))
                      +required-faculty-order+)
               (every #'validate-attunement-event
                      (reading-run-attunement-events run))
               (string= (reading-run-run-digest run)
                        (toy-digest (run-payload run))))
    (fire 'altered-run "reading run is invalid, discontinuous, or altered"))
  (unless (and (equal (poem-world-faculty-order result)
                      +required-faculty-order+)
               (eq (poem-world-poetic-belief result) :sustained)
               (support-complete-p (poem-world-support-edges result))
               (eq (poem-world-standing result) :asserted))
    (fire 'belief-thread-broken
          "result lacks ordered faculties, support, or bounded standing"))
  run)

(defun supply-schedule-from-run (run)
  (mapcar (lambda (event)
            (list (attunement-event-stage event)
                  (attunement-event-amount event)))
          (reading-run-attunement-events run)))

(defun replay-reading (plan source original-run)
  (multiple-value-bind (run result)
      (execute-reading
       plan source
       :initial-attunement (reading-run-initial-attunement original-run)
       :supply-schedule (supply-schedule-from-run original-run))
    (unless (and run
                 (string= (reading-run-run-digest run)
                          (reading-run-run-digest original-run)))
      (fire 'replay-diverged "reading replay diverged from recorded event"))
    (values run result)))

;;; ── Concord and anti-totalization gates ────────────────────────────────

(defun claim-poetic-belief-as-proof (world)
  (validate-world world)
  (when (eq (poem-world-poetic-belief world) :sustained)
    (fire 'poetic-belief-is-not-evidence
          "sustained poetic belief is not verification of the represented world"))
  nil)

(defun collapse-support-into-identity (world)
  (validate-world world)
  (when (support-complete-p (poem-world-support-edges world))
    (fire 'support-is-not-identity
          "tree, knight, lady, and reader remain distinct within their concord"))
  nil)

(defun sever-support (world edge)
  (let ((damaged (copy-world-deep world)))
    (setf (poem-world-support-edges damaged)
          (remove (relation-key edge)
                  (poem-world-support-edges damaged)
                  :key #'relation-key :test #'equal :count 1)
          (poem-world-poetic-belief damaged) :broken)
    (push (list :support-severed (copy-tree edge))
          (poem-world-history damaged))
    (refresh-world-digest damaged)
    damaged))

(defun validate-concord (world)
  (validate-world world)
  (unless (and (equal (poem-world-faculty-order world)
                      +required-faculty-order+)
               (support-complete-p (poem-world-support-edges world))
               (eq (poem-world-poetic-belief world) :sustained))
    (fire 'belief-thread-broken
          "the mutually supporting world has lost a required relation"))
  world)

;;; ── Receipt ────────────────────────────────────────────────────────────

(defun receipt-payload (receipt)
  (list :id (concord-receipt-id receipt)
        :source-id (concord-receipt-source-id receipt)
        :source-epoch (concord-receipt-source-epoch receipt)
        :source-digest (concord-receipt-source-digest receipt)
        :plan-digest (concord-receipt-plan-digest receipt)
        :run-digest (concord-receipt-run-digest receipt)
        :result-digest (concord-receipt-result-digest receipt)
        :event-digests (copy-list (concord-receipt-event-digests receipt))
        :scar-digests (copy-list (concord-receipt-scar-digests receipt))
        :faculty-order (copy-list (concord-receipt-faculty-order receipt))
        :seen-count (concord-receipt-seen-count receipt)
        :sympathy-count (concord-receipt-sympathy-count receipt)
        :movement-count (concord-receipt-movement-count receipt)
        :support-count (concord-receipt-support-count receipt)
        :initial-attunement (concord-receipt-initial-attunement receipt)
        :supplied-attunement (concord-receipt-supplied-attunement receipt)
        :spent-attunement (concord-receipt-spent-attunement receipt)
        :final-attunement (concord-receipt-final-attunement receipt)
        :poetic-belief (concord-receipt-poetic-belief receipt)
        :standing-before (concord-receipt-standing-before receipt)
        :standing-after (concord-receipt-standing-after receipt)
        :conclusion (concord-receipt-conclusion receipt)))

(defun refresh-receipt-digest (receipt)
  (setf (concord-receipt-receipt-digest receipt)
        (toy-digest (receipt-payload receipt)))
  receipt)

(defun mint-receipt (source plan run result scars)
  (validate-run run plan source result)
  (mapc #'validate-scar scars)
  (refresh-receipt-digest
   (%make-concord-receipt
    :id :concord-receipt-1
    :source-id (poem-world-id source)
    :source-epoch (poem-world-epoch source)
    :source-digest (poem-world-digest source)
    :plan-digest (reading-plan-plan-digest plan)
    :run-digest (reading-run-run-digest run)
    :result-digest (poem-world-digest result)
    :event-digests (mapcar #'faculty-event-event-digest
                           (reading-run-faculty-events run))
    :scar-digests (mapcar #'misreading-scar-scar-digest scars)
    :faculty-order (copy-list (poem-world-faculty-order result))
    :seen-count (length (poem-world-seen result))
    :sympathy-count (length (poem-world-sympathy result))
    :movement-count (length (poem-world-movement result))
    :support-count (length (poem-world-support-edges result))
    :initial-attunement (reading-run-initial-attunement run)
    :supplied-attunement (reading-run-supplied-attunement run)
    :spent-attunement (reading-run-spent-attunement run)
    :final-attunement (reading-run-final-attunement run)
    :poetic-belief (poem-world-poetic-belief result)
    :standing-before (poem-world-standing source)
    :standing-after (poem-world-standing result)
    :conclusion :world-sustained-by-concord)))

(defun validate-receipt (receipt source plan run result scars)
  (unless (typep receipt 'concord-receipt)
    (fire 'altered-receipt "expected CONCORD-RECEIPT"))
  (validate-run run plan source result)
  (mapc #'validate-scar scars)
  ;; First establish custody and internal integrity.  A claimant may recompute
  ;; the toy digest after lying, so the semantic ceiling is checked separately.
  (unless (and (eq (concord-receipt-source-id receipt)
                   (poem-world-id source))
               (= (concord-receipt-source-epoch receipt)
                  (poem-world-epoch source))
               (string= (concord-receipt-source-digest receipt)
                        (poem-world-digest source))
               (string= (concord-receipt-plan-digest receipt)
                        (reading-plan-plan-digest plan))
               (string= (concord-receipt-run-digest receipt)
                        (reading-run-run-digest run))
               (string= (concord-receipt-result-digest receipt)
                        (poem-world-digest result))
               (equal (concord-receipt-event-digests receipt)
                      (mapcar #'faculty-event-event-digest
                              (reading-run-faculty-events run)))
               (equal (concord-receipt-scar-digests receipt)
                      (mapcar #'misreading-scar-scar-digest scars))
               (string= (concord-receipt-receipt-digest receipt)
                        (toy-digest (receipt-payload receipt))))
    (fire 'altered-receipt "concord receipt is invalid or altered"))
  (unless (and (eq (concord-receipt-conclusion receipt)
                   :world-sustained-by-concord)
               (eq (concord-receipt-standing-before receipt) :asserted)
               (eq (concord-receipt-standing-after receipt) :asserted))
    (fire 'forged-belief-claim
          "poetic concord was promoted beyond its bounded standing"))
  (unless (and (equal (concord-receipt-faculty-order receipt)
                      +required-faculty-order+)
               (= (concord-receipt-seen-count receipt) 3)
               (= (concord-receipt-sympathy-count receipt) 6)
               (= (concord-receipt-movement-count receipt) 4)
               (= (concord-receipt-support-count receipt) 7)
               (= (+ (concord-receipt-initial-attunement receipt)
                     (concord-receipt-supplied-attunement receipt))
                  (+ (concord-receipt-spent-attunement receipt)
                     (concord-receipt-final-attunement receipt)))
               (eq (concord-receipt-poetic-belief receipt) :sustained))
    (fire 'altered-receipt
          "receipt no longer describes the recorded concord event"))
  receipt)

;;; ── Source world ───────────────────────────────────────────────────────

(defparameter +spenserian-world+
  (make-poem-world
   :id :faerie-queene-reading-field
   :epoch 0
   :figures
   '((:green-tree :kind :landscape :quality :softly-brilliant)
     (:pearled-lady :kind :traveller :quality :pearled)
     (:crested-knight :kind :traveller :quality :plumed)
     (:reader :kind :attending-mind :quality :tolerant-sympathy))
   :scenes
   '((:grass-track :kind :path)
     (:hovel :kind :destination)
     (:palace :kind :destination)
     (:reader-in-weeds :kind :encounter :activity :reading))
   :standing :asserted))

;;; ── Exhibit ────────────────────────────────────────────────────────────

(defun print-world (label world)
  (format t " ~a~%" label)
  (format t "   faculty order: ~s~%" (poem-world-faculty-order world))
  (format t "   seen:          ~d~%" (length (poem-world-seen world)))
  (format t "   sympathy:      ~d~%" (length (poem-world-sympathy world)))
  (format t "   movements:     ~d~%" (length (poem-world-movement world)))
  (format t "   support edges: ~d~%" (length (poem-world-support-edges world)))
  (format t "   poetic belief: ~s~%" (poem-world-poetic-belief world))
  (format t "   standing:      ~s~%" (poem-world-standing world)))

(defun demonstrate ()
  (banner "DE CONCORDIA — CONCERNING CONCORD")
  (format t "Claim: poetry may recruit faculties in order, then bind them~%")
  (format t "       into a mutually supporting world without proving that world.~%")
  (let* ((source (copy-world-deep +spenserian-world+))
         (plan (compile-reading source +woolf-reading-script+))
         (scars
           (loop for proposal in (make-misreadings)
                 for sequence from 1
                 collect (archive-misreading sequence proposal))))

    (section "I. SEVEN COUNTERFEIT READINGS LEAVE SEVEN SCARS")
    (mapc #'validate-scar scars)
    (ensure (= (length scars) 7)
            "seven rival readings should be archived")
    (format t " archived conditions: ~s~%"
            (mapcar #'misreading-scar-condition-type scars))

    (section "II. THE FACULTIES ARRIVE IN ORDER")
    (print-world "before:" source)
    (multiple-value-bind (run result)
        (handler-bind
            ((attunement-exhausted
               (lambda (condition)
                 (format t " attunement boundary at ~s: supplying 1~%"
                         (exhausted-stage condition))
                 (invoke-restart 'supply-attunement 1))))
          (execute-reading plan source :initial-attunement 4))
      (validate-run run plan source result)
      (print-world "after:" result)
      (ensure (= (reading-run-supplied-attunement run) 2)
              "two repaired units must remain in the event")
      (ensure (= (reading-run-final-attunement run) 0)
              "attunement ledger should close at zero")
      (pass "eye, sympathy, movement, and concord completed in order")

      (section "III. COMBINATION PRESERVES DIFFERENCE")
      (expect-condition support-is-not-identity
        (collapse-support-into-identity result))
      (expect-condition poetic-belief-is-not-evidence
        (claim-poetic-belief-as-proof result))
      (let ((damaged
              (sever-support
               result
               '(:green-tree :crested-knight :inhabited-world))))
        (expect-condition belief-thread-broken
          (validate-concord damaged)))

      (section "IV. THE RECEIPT NAMES INTERNAL BELIEF WITHOUT LAUNDERING IT")
      (let ((receipt (mint-receipt source plan run result scars)))
        (validate-receipt receipt source plan run result scars)
        (format t " faculty order: ~s~%"
                (concord-receipt-faculty-order receipt))
        (format t " relation counts: seen ~d; sympathy ~d; movement ~d; support ~d~%"
                (concord-receipt-seen-count receipt)
                (concord-receipt-sympathy-count receipt)
                (concord-receipt-movement-count receipt)
                (concord-receipt-support-count receipt))
        (format t " conclusion: ~s~%" (concord-receipt-conclusion receipt))
        (let ((forged (copy-concord-receipt receipt)))
          (setf (concord-receipt-conclusion forged) :represented-world-verified
                (concord-receipt-standing-after forged) :verified)
          (refresh-receipt-digest forged)
          (expect-condition forged-belief-claim
            (validate-receipt forged source plan run result scars))))

      (section "V. REPLAY RETAINS BOTH ATTUNEMENT REPAIRS")
      (multiple-value-bind (replayed-run replayed-result)
          (replay-reading plan source run)
        (ensure (= (reading-run-supplied-attunement replayed-run) 2)
                "replay erased supplied attunement")
        (ensure (string= (poem-world-digest replayed-result)
                         (poem-world-digest result))
                "replayed world diverged")
        (pass "same source, procedure, repairs, and concord replayed"))

      (section "VI. THE READING REQUIRES ITS HISTORICAL PROCEDURE")
      (unregister-reader :woolf-layered-reader 1)
      (unwind-protect
           (expect-condition reader-procedure-unavailable
             (replay-reading plan source run))
        (register-reader :woolf-layered-reader 1))

      (section "VII. AN OLD PLAN DOES NOT GOVERN A REVISED POEM-WORLD")
      (let ((changed (copy-world-deep source)))
        (incf (poem-world-epoch changed))
        (push '(:event :another-canto-entered)
              (poem-world-history changed))
        (refresh-world-digest changed)
        (expect-condition stale-reading-plan
          (execute-reading plan changed :initial-attunement 6)))

      (section "EXHIBIT")
      (format t " sensual image:       necessary, not sufficient~%")
      (format t " sympathy:            accompaniment without identity~%")
      (format t " movement:            narrative carriage, not concord~%")
      (format t " support:             combination without merger~%")
      (format t " poetic belief:       :SUSTAINED~%")
      (format t " standing:            :ASSERTED → :ASSERTED~%")
      (format t " verdict:             :WORLD-SUSTAINED-BY-CONCORD~%")
      (format t "~%The tree becomes part of the knight by support, not by ceasing to be a tree.~%")
      (pass "DE CONCORDIA complete")
      t)))

(demonstrate)
