;;;; de-abysso.lisp — Concerning the Deep
;;;;
;;;; A Lisp+ Atelier instrument for inquiries that do not immediately return
;;;; an object.  It refuses the ancient convenience of compressing every quiet
;;;; result into NIL and then treating NIL as evidence of absence.
;;;;
;;;; THESIS
;;;;   • an answer is not the whole depth from which it surfaced;
;;;;   • bounded absence requires completed coverage of a declared search field;
;;;;   • refusal, timeout, occlusion, and transit are not kinds of absence;
;;;;   • a query budget may be repaired while live continuation state remains;
;;;;   • an answer already found may still be travelling toward the inquirer;
;;;;   • old plans become historical when the charted target changes;
;;;;   • bare silence is not admissible testimony without a typed cause;
;;;;   • every judgment preserves the aperture, channel, depth, and budget that
;;;;     gave it jurisdiction.
;;;;
;;;; WHAT THIS DOES NOT ESTABLISH
;;;; This is a cooperative, single-process specimen over finite proper-list
;;;; data.  The abyss is a charted toy structure; its depths, channels, costs,
;;;; policies, clocks, and payloads are locally asserted.  The FNV digest from
;;;; the Atelier root is pedagogical, not cryptographic.  A bounded absence in
;;;; this specimen is not metaphysical nonexistence, and an answer is not proof
;;;; of semantic truth, completeness, consciousness, or contact with any
;;;; physical deep.  The instrument demonstrates only the non-coercion of six
;;;; judgment shapes under the exact declared chart and execution policy below.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*)))

(defpackage #:lispplus-atelier.de-abysso
  (:use #:cl #:lispplus-atelier))

(in-package #:lispplus-atelier.de-abysso)

(reset-clock 10300)

;;; ── Typed conditions: quiet must fail in named ways ────────────────────

(define-condition abysso-error (error)
  ((detail :initarg :detail :reader abysso-error-detail :initform ""))
  (:report (lambda (condition stream)
             (format stream "~a" (abysso-error-detail condition)))))

(define-condition malformed-abyss (abysso-error) ())
(define-condition malformed-depth-query (abysso-error) ())
(define-condition altered-depth-query (abysso-error) ())
(define-condition altered-descent-plan (abysso-error) ())
(define-condition stale-descent-plan (abysso-error) ())
(define-condition aperture-exceeded (abysso-error) ())
(define-condition depth-outside-chart (abysso-error) ())
(define-condition untyped-silence (abysso-error) ())

(define-condition descent-budget-exhausted (abysso-error)
  ((query-id :initarg :query-id :reader exhausted-query-id)
   (next-depth :initarg :next-depth :reader exhausted-next-depth)
   (needed :initarg :needed :reader exhausted-needed)
   (available :initarg :available :reader exhausted-available)))

(define-condition refusal-is-not-absence (abysso-error) ())
(define-condition timeout-is-not-absence (abysso-error) ())
(define-condition occlusion-is-not-absence (abysso-error) ())
(define-condition transit-is-not-absence (abysso-error) ())
(define-condition answer-is-not-absence (abysso-error) ())
(define-condition answer-is-not-totality (abysso-error) ())

(define-condition answer-still-travelling (abysso-error)
  ((pending-id :initarg :pending-id :reader travelling-pending-id)
   (required :initarg :required :reader travelling-required)
   (elapsed :initarg :elapsed :reader travelling-elapsed)))

(define-condition stale-pending-answer (abysso-error) ())
(define-condition altered-depth-judgment (abysso-error) ())
(define-condition forged-absence-claim (abysso-error) ())
(define-condition replay-diverged (abysso-error) ())

(defun fire (type control &rest arguments)
  (error type :detail (apply #'format nil control arguments)))

(defmacro expect-condition (type &body body)
  "Require TYPE to fire; another ABYSSO-ERROR is not a pass."
  (let ((condition (gensym "CONDITION")))
    `(handler-case
         (progn
           ,@body
           (error "expected ~a, but no condition fired" ',type))
       (,type (,condition)
         (format t " ✓ ~a fired: ~a~%"
                 ',type (abysso-error-detail ,condition))
         t)
       (abysso-error (,condition)
         (error "expected ~a, got ~a: ~a"
                ',type (type-of ,condition)
                (abysso-error-detail ,condition))))))

;;; ── Records ────────────────────────────────────────────────────────────

(defstruct (abyss (:constructor %make-abyss))
  id epoch layers standing digest)

(defstruct (depth-query (:constructor %make-depth-query))
  id target-id target-digest term depth-min depth-max aperture
  channel budget claim standing digest)

(defstruct (descent-plan (:constructor %make-descent-plan))
  query-digest target-id target-digest target-epoch depths plan-digest)

(defstruct (budget-event (:constructor %make-budget-event))
  at-depth decision amount available-before available-after event-digest)

(defstruct (pending-answer (:constructor %make-pending-answer))
  id query-digest target-id target-epoch term source-depth value
  travel-units boundary standing digest)

(defstruct (surfaced-answer (:constructor %make-surfaced-answer))
  pending-digest target-id target-epoch term source-depth value
  elapsed standing digest)

(defstruct (depth-judgment (:constructor %make-depth-judgment))
  id query-digest target-id target-epoch kind term
  planned-depths surveyed-depths observed-boundaries
  spent supplied initial-budget final-budget budget-events
  value refusal pending-digest missing standing judgment-digest)

;;; ── Structural floor ──────────────────────────────────────────────────

(defparameter +missing+ (gensym "MISSING"))

(defun proper-list-p (object)
  (let ((length-or-nil (ignore-errors (list-length object))))
    (or (null object) (integerp length-or-nil))))

(defun validate-tree (object)
  (labels ((walk (node)
             (when (consp node)
               (unless (proper-list-p node)
                 (fire 'malformed-abyss
                       "expected a finite proper-list tree, received ~s" node))
               (mapc #'walk node))))
    (walk object)
    object))

(defun positive-integer-p (object)
  (and (integerp object) (plusp object)))

(defun nonnegative-integer-p (object)
  (and (integerp object) (not (minusp object))))

(defun plist-field (plist key &optional (default +missing+))
  (getf plist key default))

(defun require-plist-field (plist key context)
  (let ((value (plist-field plist key)))
    (when (eq value +missing+)
      (fire 'malformed-abyss "~a lacks required field ~s" context key))
    value))

(defun same-set-p (a b)
  (and (null (set-difference a b :test #'equal))
       (null (set-difference b a :test #'equal))))

(defun depth-range (minimum maximum)
  (loop for depth from minimum to maximum collect depth))

;;; ── Charted abyss and layer grammar ───────────────────────────────────

(defun validate-entry (entry depth)
  (validate-tree entry)
  (unless (and (consp entry)
               (evenp (length entry))
               (keywordp (first entry)))
    (fire 'malformed-abyss
          "depth ~d contains malformed entry plist ~s" depth entry))
  (let ((term (require-plist-field entry :term "entry"))
        (kind (require-plist-field entry :kind "entry")))
    (declare (ignore term))
    (ecase kind
      (:answer
       (when (eq (plist-field entry :payload) +missing+)
         (fire 'malformed-abyss
               "answer entry at depth ~d lacks :PAYLOAD" depth))
       (let ((delay (plist-field entry :delivery-delay 0)))
         (unless (nonnegative-integer-p delay)
           (fire 'malformed-abyss
                 "delivery delay at depth ~d must be nonnegative" depth))))
      (:refuse
       (when (eq (plist-field entry :reason) +missing+)
         (fire 'malformed-abyss
               "refusal entry at depth ~d lacks :REASON" depth)))))
  entry)

(defun validate-layer (layer)
  (validate-tree layer)
  (unless (and (consp layer)
               (eq (first layer) :layer)
               (evenp (length (rest layer))))
    (fire 'malformed-abyss
          "expected (:LAYER key value ...), received ~s" layer))
  (let* ((plist (rest layer))
         (depth (require-plist-field plist :depth "layer"))
         (cost (require-plist-field plist :cost "layer"))
         (channels (require-plist-field plist :channels "layer"))
         (entries (require-plist-field plist :entries "layer")))
    (unless (nonnegative-integer-p depth)
      (fire 'malformed-abyss "layer depth must be nonnegative: ~s" depth))
    (unless (positive-integer-p cost)
      (fire 'malformed-abyss "layer cost must be positive at depth ~d" depth))
    (unless (and (proper-list-p channels) channels
                 (every #'keywordp channels))
      (fire 'malformed-abyss
            "layer channels must be a nonempty keyword list at depth ~d" depth))
    (unless (proper-list-p entries)
      (fire 'malformed-abyss "layer entries must be a proper list"))
    (dolist (entry entries)
      (validate-entry entry depth)))
  layer)

(defun layer-depth (layer)
  (plist-field (rest layer) :depth))

(defun layer-cost (layer)
  (plist-field (rest layer) :cost))

(defun layer-channels (layer)
  (plist-field (rest layer) :channels))

(defun layer-entries (layer)
  (plist-field (rest layer) :entries))

(defun abyss-payload (target)
  (list :id (abyss-id target)
        :epoch (abyss-epoch target)
        :layers (abyss-layers target)
        :standing (abyss-standing target)))

(defun refresh-abyss-digest (target)
  (setf (abyss-digest target) (toy-digest (abyss-payload target)))
  target)

(defun make-abyss (&key id layers (standing :asserted) (epoch 0))
  (unless id
    (fire 'malformed-abyss "an abyss requires an id"))
  (unless (and (proper-list-p layers) layers)
    (fire 'malformed-abyss "an abyss requires a nonempty layer list"))
  (mapc #'validate-layer layers)
  (let ((depths (mapcar #'layer-depth layers)))
    (unless (= (length depths)
               (length (remove-duplicates depths :test #'=)))
      (fire 'malformed-abyss "layer depths must be unique: ~s" depths))
    (unless (equal depths (sort (copy-list depths) #'<))
      (fire 'malformed-abyss "layers must be ordered by ascending depth")))
  (refresh-abyss-digest
   (%make-abyss :id id
                :epoch epoch
                :layers (copy-tree layers)
                :standing standing
                :digest nil)))

(defun validate-abyss (target)
  (unless (typep target 'abyss)
    (fire 'malformed-abyss "not an ABYSS record: ~s" target))
  (mapc #'validate-layer (abyss-layers target))
  (unless (equal (abyss-digest target)
                 (toy-digest (abyss-payload target)))
    (fire 'malformed-abyss
          "abyss ~s no longer matches its digest" (abyss-id target)))
  target)

(defun layer-at-depth (target depth)
  (find depth (abyss-layers target) :key #'layer-depth :test #'=))

(defun entry-for-term (layer term)
  (find term (layer-entries layer)
        :key (lambda (entry) (plist-field entry :term))
        :test #'equal))

(defun rechart-abyss (target transformer)
  "Return a changed chart.  The original remains historical and untouched."
  (validate-abyss target)
  (let* ((new-layers (funcall transformer (copy-tree (abyss-layers target))))
         (changed (make-abyss :id (abyss-id target)
                              :epoch (1+ (abyss-epoch target))
                              :layers new-layers
                              :standing (abyss-standing target))))
    changed))

;;; ── Queries: every silence carries its aperture ───────────────────────

(defun depth-query-payload (query)
  (list :id (depth-query-id query)
        :target-id (depth-query-target-id query)
        :target-digest (depth-query-target-digest query)
        :term (depth-query-term query)
        :depth-min (depth-query-depth-min query)
        :depth-max (depth-query-depth-max query)
        :aperture (depth-query-aperture query)
        :channel (depth-query-channel query)
        :budget (depth-query-budget query)
        :claim (depth-query-claim query)
        :standing (depth-query-standing query)))

(defun refresh-depth-query-digest (query)
  (setf (depth-query-digest query)
        (toy-digest (depth-query-payload query)))
  query)

(defun make-depth-query (target &key term depth-min depth-max aperture
                                  channel budget (claim :inquire))
  (validate-abyss target)
  (unless term
    (fire 'malformed-depth-query "a depth query requires a term"))
  (unless (and (nonnegative-integer-p depth-min)
               (nonnegative-integer-p depth-max)
               (<= depth-min depth-max))
    (fire 'malformed-depth-query
          "invalid depth interval ~s..~s" depth-min depth-max))
  (unless (positive-integer-p aperture)
    (fire 'malformed-depth-query "aperture must be positive"))
  (unless (keywordp channel)
    (fire 'malformed-depth-query "channel must be a keyword"))
  (unless (nonnegative-integer-p budget)
    (fire 'malformed-depth-query "budget must be nonnegative"))
  (let ((span (1+ (- depth-max depth-min))))
    (when (> span aperture)
      (fire 'aperture-exceeded
            "depth interval spans ~d layers through aperture ~d"
            span aperture)))
  (dolist (depth (depth-range depth-min depth-max))
    (unless (layer-at-depth target depth)
      (fire 'depth-outside-chart
            "depth ~d is not present in chart ~s"
            depth (abyss-id target))))
  (refresh-depth-query-digest
   (%make-depth-query
    :id (format nil "QUERY-~D" (tick))
    :target-id (abyss-id target)
    :target-digest (abyss-digest target)
    :term term
    :depth-min depth-min
    :depth-max depth-max
    :aperture aperture
    :channel channel
    :budget budget
    :claim claim
    :standing :asserted
    :digest nil)))

(defun validate-depth-query (query)
  (unless (typep query 'depth-query)
    (fire 'malformed-depth-query "not a DEPTH-QUERY: ~s" query))
  (unless (equal (depth-query-digest query)
                 (toy-digest (depth-query-payload query)))
    (fire 'altered-depth-query
          "query ~s no longer matches its digest" (depth-query-id query)))
  (unless (and (nonnegative-integer-p (depth-query-depth-min query))
               (nonnegative-integer-p (depth-query-depth-max query))
               (<= (depth-query-depth-min query)
                   (depth-query-depth-max query))
               (positive-integer-p (depth-query-aperture query))
               (keywordp (depth-query-channel query))
               (nonnegative-integer-p (depth-query-budget query)))
    (fire 'altered-depth-query "query contains invalid bounded fields"))
  (when (> (1+ (- (depth-query-depth-max query)
                  (depth-query-depth-min query)))
           (depth-query-aperture query))
    (fire 'altered-depth-query
          "query depth span exceeds its recorded aperture"))
  query)

(defun descent-plan-payload (plan)
  (list :query-digest (descent-plan-query-digest plan)
        :target-id (descent-plan-target-id plan)
        :target-digest (descent-plan-target-digest plan)
        :target-epoch (descent-plan-target-epoch plan)
        :depths (descent-plan-depths plan)))

(defun compile-descent (target query)
  "Purely freeze the ordered field of inquiry."
  (validate-abyss target)
  (validate-depth-query query)
  (unless (and (equal (depth-query-target-id query) (abyss-id target))
               (equal (depth-query-target-digest query) (abyss-digest target)))
    (fire 'stale-descent-plan
          "query was sworn against another target state"))
  (let ((plan (%make-descent-plan
               :query-digest (depth-query-digest query)
               :target-id (abyss-id target)
               :target-digest (abyss-digest target)
               :target-epoch (abyss-epoch target)
               :depths (depth-range (depth-query-depth-min query)
                                    (depth-query-depth-max query))
               :plan-digest nil)))
    (setf (descent-plan-plan-digest plan)
          (toy-digest (descent-plan-payload plan)))
    plan))

(defun validate-descent-plan (plan)
  (unless (typep plan 'descent-plan)
    (fire 'altered-descent-plan "not a DESCENT-PLAN: ~s" plan))
  (unless (equal (descent-plan-plan-digest plan)
                 (toy-digest (descent-plan-payload plan)))
    (fire 'altered-descent-plan "descent plan was altered after compilation"))
  (let ((depths (descent-plan-depths plan)))
    (unless (and (proper-list-p depths) depths
                 (every #'nonnegative-integer-p depths)
                 (equal depths
                        (depth-range (first depths) (car (last depths)))))
      (fire 'altered-descent-plan
            "descent plan depths are not one ordered contiguous field")))
  plan)

;;; ── Budget events and judgment receipts ───────────────────────────────

(defun budget-event-payload (event)
  (list :at-depth (budget-event-at-depth event)
        :decision (budget-event-decision event)
        :amount (budget-event-amount event)
        :available-before (budget-event-available-before event)
        :available-after (budget-event-available-after event)))

(defun make-budget-event (depth decision amount before after)
  (let ((event (%make-budget-event
                :at-depth depth :decision decision :amount amount
                :available-before before :available-after after
                :event-digest nil)))
    (setf (budget-event-event-digest event)
          (toy-digest (budget-event-payload event)))
    event))

(defun validate-budget-event (event)
  (unless (and (typep event 'budget-event)
               (equal (budget-event-event-digest event)
                      (toy-digest (budget-event-payload event))))
    (fire 'altered-depth-judgment "budget event was altered"))
  (unless (and (member (budget-event-decision event)
                       '(:supply :timeout) :test #'eq)
               (nonnegative-integer-p (budget-event-at-depth event))
               (nonnegative-integer-p (budget-event-amount event))
               (nonnegative-integer-p (budget-event-available-before event))
               (nonnegative-integer-p (budget-event-available-after event)))
    (fire 'altered-depth-judgment "budget event has invalid fields"))
  (ecase (budget-event-decision event)
    (:supply
     (unless (= (budget-event-available-after event)
                (+ (budget-event-available-before event)
                   (budget-event-amount event)))
       (fire 'altered-depth-judgment
             "supply event arithmetic does not close")))
    (:timeout
     (unless (and (zerop (budget-event-amount event))
                  (= (budget-event-available-before event)
                     (budget-event-available-after event)))
       (fire 'altered-depth-judgment
             "timeout event must preserve the remaining budget"))))
  event)

(defun pending-answer-record-payload (pending)
  (list :id (pending-answer-id pending)
        :query-digest (pending-answer-query-digest pending)
        :target-id (pending-answer-target-id pending)
        :target-epoch (pending-answer-target-epoch pending)
        :term (pending-answer-term pending)
        :source-depth (pending-answer-source-depth pending)
        :payload (pending-answer-value pending)
        :travel-units (pending-answer-travel-units pending)
        :boundary (pending-answer-boundary pending)
        :standing (pending-answer-standing pending)))

(defun make-pending-answer (query target depth payload travel-units boundary)
  (let ((pending (%make-pending-answer
                  :id (format nil "PENDING-~D" (tick))
                  :query-digest (depth-query-digest query)
                  :target-id (abyss-id target)
                  :target-epoch (abyss-epoch target)
                  :term (depth-query-term query)
                  :source-depth depth
                  :value (copy-tree payload)
                  :travel-units travel-units
                  :boundary (copy-tree boundary)
                  :standing :reported-in-transit
                  :digest nil)))
    (setf (pending-answer-digest pending)
          (toy-digest (pending-answer-record-payload pending)))
    pending))

(defun validate-pending-answer (pending)
  (unless (typep pending 'pending-answer)
    (fire 'stale-pending-answer "not a PENDING-ANSWER: ~s" pending))
  (unless (equal (pending-answer-digest pending)
                 (toy-digest (pending-answer-record-payload pending)))
    (fire 'stale-pending-answer "pending answer was altered"))
  pending)

(defun surfaced-answer-record-payload (answer)
  (list :pending-digest (surfaced-answer-pending-digest answer)
        :target-id (surfaced-answer-target-id answer)
        :target-epoch (surfaced-answer-target-epoch answer)
        :term (surfaced-answer-term answer)
        :source-depth (surfaced-answer-source-depth answer)
        :payload (surfaced-answer-value answer)
        :elapsed (surfaced-answer-elapsed answer)
        :standing (surfaced-answer-standing answer)))

(defun depth-judgment-record-payload (judgment)
  (list :id (depth-judgment-id judgment)
        :query-digest (depth-judgment-query-digest judgment)
        :target-id (depth-judgment-target-id judgment)
        :target-epoch (depth-judgment-target-epoch judgment)
        :kind (depth-judgment-kind judgment)
        :term (depth-judgment-term judgment)
        :planned-depths (depth-judgment-planned-depths judgment)
        :surveyed-depths (depth-judgment-surveyed-depths judgment)
        :observed-boundaries (depth-judgment-observed-boundaries judgment)
        :spent (depth-judgment-spent judgment)
        :supplied (depth-judgment-supplied judgment)
        :initial-budget (depth-judgment-initial-budget judgment)
        :final-budget (depth-judgment-final-budget judgment)
        :budget-event-digests
        (mapcar #'budget-event-event-digest
                (depth-judgment-budget-events judgment))
        :payload (depth-judgment-value judgment)
        :refusal (depth-judgment-refusal judgment)
        :pending-digest (depth-judgment-pending-digest judgment)
        :missing (depth-judgment-missing judgment)
        :standing (depth-judgment-standing judgment)))

(defun make-depth-judgment (&key query target kind planned-depths surveyed-depths
                                 observed-boundaries spent supplied initial-budget
                                 final-budget budget-events payload refusal pending
                                 missing)
  (let ((judgment (%make-depth-judgment
                   :id (format nil "JUDGMENT-~D" (tick))
                   :query-digest (depth-query-digest query)
                   :target-id (abyss-id target)
                   :target-epoch (abyss-epoch target)
                   :kind kind
                   :term (depth-query-term query)
                   :planned-depths (copy-list planned-depths)
                   :surveyed-depths (copy-list surveyed-depths)
                   :observed-boundaries (copy-tree observed-boundaries)
                   :spent spent
                   :supplied supplied
                   :initial-budget initial-budget
                   :final-budget final-budget
                   :budget-events (copy-list budget-events)
                   :value (copy-tree payload)
                   :refusal (copy-tree refusal)
                   :pending-digest (and pending (pending-answer-digest pending))
                   :missing (copy-tree missing)
                   :standing :asserted
                   :judgment-digest nil)))
    (setf (depth-judgment-judgment-digest judgment)
          (toy-digest (depth-judgment-record-payload judgment)))
    judgment))

(defun validate-depth-judgment (judgment)
  (unless (typep judgment 'depth-judgment)
    (fire 'altered-depth-judgment "not a DEPTH-JUDGMENT: ~s" judgment))
  (mapc #'validate-budget-event (depth-judgment-budget-events judgment))
  (unless (equal (depth-judgment-judgment-digest judgment)
                 (toy-digest (depth-judgment-record-payload judgment)))
    (fire 'altered-depth-judgment
          "judgment ~s no longer matches its digest"
          (depth-judgment-id judgment)))
  (unless (= (+ (depth-judgment-initial-budget judgment)
                (depth-judgment-supplied judgment))
             (+ (depth-judgment-spent judgment)
                (depth-judgment-final-budget judgment)))
    (fire 'altered-depth-judgment
          "judgment budget arithmetic does not close"))
  (unless (= (depth-judgment-supplied judgment)
             (loop for event in (depth-judgment-budget-events judgment)
                   when (eq (budget-event-decision event) :supply)
                   sum (budget-event-amount event)))
    (fire 'altered-depth-judgment
          "judgment supplied total does not match its budget events"))
  (unless (member (depth-judgment-kind judgment)
                  '(:answer :bounded-absence :refused
                    :timeout :occluded :in-transit)
                  :test #'eq)
    (fire 'altered-depth-judgment
          "unknown judgment kind ~s" (depth-judgment-kind judgment)))
  (unless (and (proper-list-p (depth-judgment-planned-depths judgment))
               (proper-list-p (depth-judgment-surveyed-depths judgment))
               (every #'nonnegative-integer-p
                      (depth-judgment-planned-depths judgment))
               (every #'nonnegative-integer-p
                      (depth-judgment-surveyed-depths judgment))
               (eq (depth-judgment-standing judgment) :asserted))
    (fire 'altered-depth-judgment
          "judgment boundary or standing is malformed"))
  (case (depth-judgment-kind judgment)
    (:bounded-absence
     (unless (and (equal (depth-judgment-surveyed-depths judgment)
                         (depth-judgment-planned-depths judgment))
                  (null (depth-judgment-value judgment))
                  (null (depth-judgment-refusal judgment))
                  (null (depth-judgment-pending-digest judgment)))
       (fire 'forged-absence-claim
             "bounded absence requires completed coverage of every planned depth")))
    (:timeout
     (unless (and (not (equal (depth-judgment-surveyed-depths judgment)
                              (depth-judgment-planned-depths judgment)))
                  (find :timeout (depth-judgment-budget-events judgment)
                        :key #'budget-event-decision :test #'eq))
       (fire 'altered-depth-judgment
             "timeout judgment lacks an unfinished field or timeout event")))
    (:refused
     (unless (depth-judgment-refusal judgment)
       (fire 'altered-depth-judgment
             "refusal judgment lacks its refusal record")))
    (:occluded
     (unless (getf (depth-judgment-missing judgment) :occluded-at)
       (fire 'altered-depth-judgment
             "occlusion judgment lacks its blocked depth")))
    (:in-transit
     (unless (depth-judgment-pending-digest judgment)
       (fire 'altered-depth-judgment
             "transit judgment lacks its pending-answer digest")))
    (:answer
     (when (or (depth-judgment-refusal judgment)
               (depth-judgment-pending-digest judgment))
       (fire 'altered-depth-judgment
             "answer judgment carries incompatible refusal or transit state"))))
  judgment)

;;; ── Descent engine ─────────────────────────────────────────────────────

(defun boundary-for (query plan)
  (list :depth-min (depth-query-depth-min query)
        :depth-max (depth-query-depth-max query)
        :planned-depths (descent-plan-depths plan)
        :aperture (depth-query-aperture query)
        :channel (depth-query-channel query)
        :initial-budget (depth-query-budget query)
        :claim (depth-query-claim query)))

(defun execute-descent (target query plan)
  "Return a typed judgment and, for :IN-TRANSIT, a pending answer.

If the budget cannot pay the next layer, DESCENT-BUDGET-EXHAUSTED leaves two
live restarts:
  RECORD-TIMEOUT — stop and record a bounded timeout judgment;
  SUPPLY-BUDGET  — add explicit units and continue the same descent."
  (validate-abyss target)
  (validate-depth-query query)
  (validate-descent-plan plan)
  (unless (and (equal (descent-plan-query-digest plan)
                      (depth-query-digest query))
               (equal (descent-plan-target-id plan) (abyss-id target))
               (equal (descent-plan-target-digest plan) (abyss-digest target))
               (= (descent-plan-target-epoch plan) (abyss-epoch target)))
    (fire 'stale-descent-plan
          "descent plan no longer addresses this query-target state"))
  (let* ((planned (copy-list (descent-plan-depths plan)))
         (boundary (boundary-for query plan))
         (remaining (depth-query-budget query))
         (initial (depth-query-budget query))
         (spent 0)
         (supplied 0)
         (surveyed '())
         (observed '())
         (events '()))
    (labels
        ((finish (kind &key payload refusal pending missing)
           (let ((judgment
                   (make-depth-judgment
                    :query query :target target :kind kind
                    :planned-depths planned
                    :surveyed-depths (nreverse (copy-list surveyed))
                    :observed-boundaries (nreverse (copy-list observed))
                    :spent spent :supplied supplied
                    :initial-budget initial :final-budget remaining
                    :budget-events (nreverse (copy-list events))
                    :payload payload :refusal refusal :pending pending
                    :missing missing)))
             (validate-depth-judgment judgment)
             (values judgment pending)))
         (pay-layer (depth cost)
           (loop
             (when (>= remaining cost)
               (decf remaining cost)
               (incf spent cost)
               (return :paid))
             (let* ((before remaining)
                    (deficit (- cost remaining))
                    (decision
                      (restart-case
                          (error 'descent-budget-exhausted
                                 :detail
                                 (format nil
                                         "query ~a needs ~d more unit~:p before depth ~d"
                                         (depth-query-id query) deficit depth)
                                 :query-id (depth-query-id query)
                                 :next-depth depth
                                 :needed deficit
                                 :available remaining)
                        (record-timeout ()
                          :report "Record timeout at the present boundary."
                          :timeout)
                        (supply-budget (units)
                          :report "Supply explicit budget and continue."
                          :interactive
                          (lambda ()
                            (format *query-io* "Budget units: ")
                            (list (read *query-io*)))
                          (unless (positive-integer-p units)
                            (fire 'malformed-depth-query
                                  "supplied budget must be positive"))
                          (incf remaining units)
                          (incf supplied units)
                          (push (make-budget-event depth :supply units
                                                   before remaining)
                                events)
                          :retry))))
               (ecase decision
                 (:retry nil)
                 (:timeout
                  (push (make-budget-event depth :timeout 0 before before)
                        events)
                  (return :timeout)))))))
      (dolist (depth planned
                     (finish :bounded-absence
                             :missing
                             (list :term (depth-query-term query)
                                   :within boundary
                                   :qualification :completed-bounded-survey)))
        (let* ((layer (layer-at-depth target depth))
               (cost (layer-cost layer))
               (payment (pay-layer depth cost)))
          (when (eq payment :timeout)
            (return-from execute-descent
              (finish :timeout
                      :missing
                      (list :next-depth depth
                            :reason :budget-ended-before-layer
                            :unsearched-depths
                            (member depth planned :test #'=)
                            :within boundary))))
          (push depth surveyed)
          (push (list :depth depth
                      :cost cost
                      :channel (depth-query-channel query))
                observed)
          (unless (member (depth-query-channel query)
                          (layer-channels layer) :test #'eq)
            (return-from execute-descent
              (finish :occluded
                      :missing
                      (list :occluded-at depth
                            :channel (depth-query-channel query)
                            :available-channels (layer-channels layer)
                            :unsearched-depths
                            (rest (member depth planned :test #'=))
                            :within boundary))))
          (let ((entry (entry-for-term layer (depth-query-term query))))
            (when entry
              (ecase (plist-field entry :kind)
                (:refuse
                 (return-from execute-descent
                   (finish :refused
                           :refusal
                           (list :at-depth depth
                                 :reason (plist-field entry :reason)
                                 :authority (plist-field entry :authority
                                                         :locally-asserted)
                                 :within boundary)
                           :missing
                           (list :unsearched-depths
                                 (rest (member depth planned :test #'=))))))
                (:answer
                 (let* ((payload (plist-field entry :payload))
                        (delay (plist-field entry :delivery-delay 0)))
                   (if (<= delay remaining)
                       (progn
                         (decf remaining delay)
                         (incf spent delay)
                         (return-from execute-descent
                           (finish :answer
                                   :payload
                                   (list :source-depth depth
                                         :value payload
                                         :delivery-units delay
                                         :within boundary)
                                   :missing
                                   (list :unsearched-depths
                                         (rest (member depth planned :test #'=))))))
                       (let ((pending
                               (make-pending-answer
                                query target depth payload delay boundary)))
                         (return-from execute-descent
                           (finish :in-transit
                                   :pending pending
                                   :missing
                                   (list :source-depth depth
                                         :travel-units delay
                                         :budget-remaining remaining
                                         :unsearched-depths
                                         (rest (member depth planned :test #'=))
                                         :within boundary)))))))))))))))

;;; ── Surfacing a travelling answer ─────────────────────────────────────

(defun collect-pending-answer (pending elapsed)
  "Collect after ELAPSED virtual units; WAIT-UNTIL-ARRIVAL never sleeps."
  (validate-pending-answer pending)
  (unless (nonnegative-integer-p elapsed)
    (fire 'stale-pending-answer "elapsed time must be nonnegative"))
  (labels ((surface (effective-elapsed)
             (let ((answer (%make-surfaced-answer
                            :pending-digest (pending-answer-digest pending)
                            :target-id (pending-answer-target-id pending)
                            :target-epoch (pending-answer-target-epoch pending)
                            :term (pending-answer-term pending)
                            :source-depth (pending-answer-source-depth pending)
                            :value (copy-tree (pending-answer-value pending))
                            :elapsed effective-elapsed
                            :standing :reported-answer
                            :digest nil)))
               (setf (surfaced-answer-digest answer)
                     (toy-digest (surfaced-answer-record-payload answer)))
               answer)))
    (if (>= elapsed (pending-answer-travel-units pending))
        (surface elapsed)
        (restart-case
            (error 'answer-still-travelling
                   :detail
                   (format nil
                           "answer ~a needs ~d travel units; only ~d elapsed"
                           (pending-answer-id pending)
                           (pending-answer-travel-units pending)
                           elapsed)
                   :pending-id (pending-answer-id pending)
                   :required (pending-answer-travel-units pending)
                   :elapsed elapsed)
          (wait-until-arrival ()
            :report "Advance the declared virtual interval to arrival."
            (surface (pending-answer-travel-units pending)))))))

(defun validate-surfaced-answer (answer)
  (unless (and (typep answer 'surfaced-answer)
               (equal (surfaced-answer-digest answer)
                      (toy-digest (surfaced-answer-record-payload answer))))
    (fire 'stale-pending-answer "surfaced answer was altered"))
  answer)

;;; ── Non-coercion operations ────────────────────────────────────────────

(defun require-bounded-absence (judgment)
  (validate-depth-judgment judgment)
  (ecase (depth-judgment-kind judgment)
    (:bounded-absence
     (list :absent (depth-judgment-term judgment)
           :within (depth-judgment-observed-boundaries judgment)
           :standing :bounded-testimony))
    (:refused
     (fire 'refusal-is-not-absence
           "a refusal reports policy or authority, not nonexistence"))
    (:timeout
     (fire 'timeout-is-not-absence
           "a spent clock reports an unfinished search, not nonexistence"))
    (:occluded
     (fire 'occlusion-is-not-absence
           "an inaccessible stratum reports missing access, not nonexistence"))
    (:in-transit
     (fire 'transit-is-not-absence
           "an answer already travelling is the opposite of established absence"))
    (:answer
     (fire 'answer-is-not-absence
           "an answer cannot be coerced into absence"))))

(defun totalize-answer (judgment)
  (validate-depth-judgment judgment)
  (unless (eq (depth-judgment-kind judgment) :answer)
    (fire 'answer-is-not-totality "no surfaced answer is present"))
  (fire 'answer-is-not-totality
        "one answer from depth ~s does not exhaust the planned deep"
        (getf (depth-judgment-value judgment) :source-depth)))

(defun interpret-bare-silence (value)
  (when (null value)
    (fire 'untyped-silence
          "NIL carries no aperture, clock, refusal, occlusion, or transit record"))
  value)

;;; ── Replay: same chart, same query, same budget decisions ──────────────

(defun replay-decision-handler (events)
  "Return a handler that consumes recorded budget decisions in order."
  (let ((remaining-events (copy-list events)))
    (lambda (condition)
      (unless remaining-events
        (fire 'replay-diverged
              "replay exhausted its recorded budget decisions at depth ~d"
              (exhausted-next-depth condition)))
      (let ((event (pop remaining-events)))
        (unless (= (budget-event-at-depth event)
                   (exhausted-next-depth condition))
          (fire 'replay-diverged
                "recorded budget event names depth ~d, replay requested ~d"
                (budget-event-at-depth event)
                (exhausted-next-depth condition)))
        (ecase (budget-event-decision event)
          (:timeout (invoke-restart 'record-timeout))
          (:supply (invoke-restart 'supply-budget
                                   (budget-event-amount event))))))))

(defun replay-judgment (target query plan historical)
  (validate-depth-judgment historical)
  (let ((handler (replay-decision-handler
                  (depth-judgment-budget-events historical))))
    (multiple-value-bind (fresh pending)
        (handler-bind ((descent-budget-exhausted handler))
          (execute-descent target query plan))
      (declare (ignore pending))
      (unless (and (eq (depth-judgment-kind fresh)
                       (depth-judgment-kind historical))
                   (equal (depth-judgment-planned-depths fresh)
                          (depth-judgment-planned-depths historical))
                   (equal (depth-judgment-surveyed-depths fresh)
                          (depth-judgment-surveyed-depths historical))
                   (equal (depth-judgment-value fresh)
                          (depth-judgment-value historical))
                   (equal (depth-judgment-refusal fresh)
                          (depth-judgment-refusal historical))
                   (equal (depth-judgment-missing fresh)
                          (depth-judgment-missing historical))
                   (= (depth-judgment-spent fresh)
                      (depth-judgment-spent historical))
                   (= (depth-judgment-supplied fresh)
                      (depth-judgment-supplied historical)))
        (fire 'replay-diverged
              "replayed judgment diverged from its historical bounded claim"))
      fresh)))

;;; ══ Demonstration ══════════════════════════════════════════════════════

(banner "de abysso")
(format t "The deep does not answer every hook in the same grammar.~%")
(format t "Silence without a boundary is not yet testimony.~%")

(defparameter *deep*
  (make-abyss
   :id :porch-deep
   :layers
   '((:layer :depth 0 :cost 1 :channels (:line :sonar)
      :entries
      ((:term :surface-ripple :kind :answer
        :payload (:pattern :wind-written) :delivery-delay 0)))
     (:layer :depth 1 :cost 1 :channels (:line :sonar)
      :entries
      ((:term :near-voice :kind :answer
        :payload (:utterance "The first echo is not the floor.")
        :delivery-delay 0)))
     (:layer :depth 2 :cost 2 :channels (:line)
      :entries
      ((:term :sealed-name :kind :refuse
        :reason :office-does-not-authorize-disclosure
        :authority :keeper-of-the-third-sill)))
     (:layer :depth 3 :cost 1 :channels (:line)
      :entries
      ((:term :ascending-word :kind :answer
        :payload (:word :pldenic :status :still-rising)
        :delivery-delay 4)))
     (:layer :depth 4 :cost 2 :channels (:line)
      :entries ())
     (:layer :depth 5 :cost 2 :channels (:line)
      :entries
      ((:term :deep-bell :kind :answer
        :payload (:tone :below-hearing :count 1)
        :delivery-delay 0))))))

(defun plan-query (&rest arguments)
  (let ((query (apply #'make-depth-query *deep* arguments)))
    (values query (compile-descent *deep* query))))

(section "1. planning is pure and aperture-bounded")
(let ((before (abyss-digest *deep*)))
  (multiple-value-bind (query plan)
      (plan-query :term :near-voice :depth-min 0 :depth-max 1
                  :aperture 2 :channel :line :budget 2)
    (defparameter *answer-query* query)
    (defparameter *answer-plan* plan))
  (ensure (equal before (abyss-digest *deep*))
          "query planning changed the abyss")
  (pass "the chart remained untouched "))

(expect-condition aperture-exceeded
  (make-depth-query *deep* :term :deep-bell
                    :depth-min 0 :depth-max 5
                    :aperture 3 :channel :line :budget 20))

(section "2. one answer surfaces without becoming the whole deep")
(multiple-value-bind (judgment pending)
    (execute-descent *deep* *answer-query* *answer-plan*)
  (declare (ignore pending))
  (defparameter *answer* judgment)
  (format t " answer: ~s~%" (depth-judgment-value judgment))
  (ensure (eq :answer (depth-judgment-kind judgment))
          "expected an answer judgment"))
(expect-condition answer-is-not-totality
  (totalize-answer *answer*))

(section "3. refusal is not absence")
(multiple-value-bind (query plan)
    (plan-query :term :sealed-name :depth-min 0 :depth-max 2
                :aperture 3 :channel :line :budget 4)
  (multiple-value-bind (judgment pending)
      (execute-descent *deep* query plan)
    (declare (ignore pending))
    (defparameter *refusal* judgment)
    (format t " refusal: ~s~%" (depth-judgment-refusal judgment))))
(expect-condition refusal-is-not-absence
  (require-bounded-absence *refusal*))

(section "4. completed coverage may warrant bounded absence")
(multiple-value-bind (query plan)
    (plan-query :term :white-whale :depth-min 0 :depth-max 2
                :aperture 3 :channel :line :budget 4)
  (multiple-value-bind (judgment pending)
      (execute-descent *deep* query plan)
    (declare (ignore pending))
    (defparameter *absence-query* query)
    (defparameter *absence-plan* plan)
    (defparameter *absence* judgment)
    (format t " bounded absence: ~s~%"
            (require-bounded-absence judgment))))

(section "5. timeout records unfinished jurisdiction")
(multiple-value-bind (query plan)
    (plan-query :term :deep-bell :depth-min 0 :depth-max 5
                :aperture 6 :channel :line :budget 4)
  (defparameter *timeout-query* query)
  (defparameter *timeout-plan* plan)
  (multiple-value-bind (judgment pending)
      (handler-bind
          ((descent-budget-exhausted
             (lambda (condition)
               (declare (ignore condition))
               (invoke-restart 'record-timeout))))
        (execute-descent *deep* query plan))
    (declare (ignore pending))
    (defparameter *timeout* judgment)
    (format t " timeout boundary: ~s~%" (depth-judgment-missing judgment))))
(expect-condition timeout-is-not-absence
  (require-bounded-absence *timeout*))

(section "6. live budget repair continues the same descent")
(multiple-value-bind (query plan)
    (plan-query :term :deep-bell :depth-min 0 :depth-max 5
                :aperture 6 :channel :line :budget 4)
  (defparameter *repaired-query* query)
  (defparameter *repaired-plan* plan)
  (multiple-value-bind (judgment pending)
      (handler-bind
          ((descent-budget-exhausted
             (lambda (condition)
               (invoke-restart 'supply-budget
                               (exhausted-needed condition)))))
        (execute-descent *deep* query plan))
    (declare (ignore pending))
    (defparameter *repaired-answer* judgment)
    (format t " supplied: ~d; answer: ~s~%"
            (depth-judgment-supplied judgment)
            (depth-judgment-value judgment))
    (ensure (= 5 (depth-judgment-supplied judgment))
            "expected five explicitly supplied units")))

(section "7. occlusion is not absence")
(multiple-value-bind (query plan)
    (plan-query :term :deep-bell :depth-min 0 :depth-max 5
                :aperture 6 :channel :sonar :budget 20)
  (multiple-value-bind (judgment pending)
      (execute-descent *deep* query plan)
    (declare (ignore pending))
    (defparameter *occlusion* judgment)
    (format t " occlusion: ~s~%" (depth-judgment-missing judgment))))
(expect-condition occlusion-is-not-absence
  (require-bounded-absence *occlusion*))

(section "8. an answer may be found before it arrives")
(multiple-value-bind (query plan)
    (plan-query :term :ascending-word :depth-min 0 :depth-max 3
                :aperture 4 :channel :line :budget 5)
  (multiple-value-bind (judgment pending)
      (execute-descent *deep* query plan)
    (defparameter *transit* judgment)
    (defparameter *pending* pending)
    (format t " transit receipt: ~s~%" (depth-judgment-missing judgment))))
(expect-condition transit-is-not-absence
  (require-bounded-absence *transit*))

(expect-condition answer-still-travelling
  (collect-pending-answer *pending* 2))

(defparameter *surfaced*
  (handler-bind
      ((answer-still-travelling
         (lambda (condition)
           (declare (ignore condition))
           (invoke-restart 'wait-until-arrival))))
    (collect-pending-answer *pending* 2)))
(validate-surfaced-answer *surfaced*)
(format t " surfaced after declared interval: ~s~%"
        (surfaced-answer-value *surfaced*))

(section "9. bare NIL is not an admissible depth judgment")
(expect-condition untyped-silence
  (interpret-bare-silence nil))

(section "10. incomplete coverage cannot be laundered into absence")
(let ((forged (copy-depth-judgment *timeout*)))
  (setf (depth-judgment-kind forged) :bounded-absence
        (depth-judgment-missing forged)
        '(:qualification :forged-from-timeout)
        (depth-judgment-judgment-digest forged)
        (toy-digest (depth-judgment-record-payload forged)))
  (expect-condition forged-absence-claim
    (validate-depth-judgment forged)))

(section "11. budget decisions replay as part of the event")
(let ((replayed (replay-judgment *deep* *repaired-query*
                                 *repaired-plan* *repaired-answer*)))
  (ensure (eq :answer (depth-judgment-kind replayed))
          "replay did not return the recorded answer kind")
  (ensure (= 5 (depth-judgment-supplied replayed))
          "replay lost the supplied budget history")
  (pass "repair decisions reproduced the bounded judgment "))

(section "12. a changed chart makes the old plan historical")
(defparameter *recharted-deep*
  (rechart-abyss
   *deep*
   (lambda (layers)
     (let ((copy (copy-tree layers)))
       (setf (getf (rest (first copy)) :entries)
             (append (getf (rest (first copy)) :entries)
                     '((:term :new-ripple :kind :answer
                        :payload (:arrived :after-charting)
                        :delivery-delay 0))))
       copy))))
(expect-condition stale-descent-plan
  (execute-descent *recharted-deep* *answer-query* *answer-plan*))

(section "13. receipts cannot be cosmetically rewritten")
(let ((altered (copy-depth-judgment *answer*)))
  (setf (depth-judgment-kind altered) :bounded-absence)
  (expect-condition altered-depth-judgment
    (validate-depth-judgment altered)))

(section "what this instrument does NOT establish")
(format t " The chart is finite, cooperative, and locally asserted.  A returned~%")
(format t " answer may be false; a bounded absence may fail outside its aperture;~%")
(format t " a refusal may conceal either presence or absence; an occlusion may be~%")
(format t " accidental or deliberate; and virtual travel is not physical time.~%")
(format t " Nothing here proves that every silence has one recoverable cause.~%")

(format t "~%── no answer is not one answer ──~%")
(format t "── no answer yet is not no answer ──~%")
(format t "── no answer here is not no answer anywhere ──~%")
(format t "── refusal is not absence; occlusion is not absence ──~%")
(format t "── the deep remains larger than the grammar of its return ──~%")
