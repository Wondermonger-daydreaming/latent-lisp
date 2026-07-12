;;;; de-nenbutsu-infinito.lisp — Concerning Nenbutsu / Infinity
;;;;
;;;; A standalone post-decad Lisp+ Atelier instrument inspired by the seed:
;;;;
;;;;                         念仏 / ∞
;;;;
;;;; The slash is treated as a seam, not an equality sign.  A finite embodied
;;;; recitation may be counted exactly while remaining open toward a vow-horizon
;;;; that the program neither completes nor owns.
;;;;
;;;; BOUNDED THESIS
;;;;   * a finite tally is a receipt about events, not infinity;
;;;;   * repetition preserves a phrase without duplicating the utterance-event;
;;;;   * counting is not merit, payment, rank, or assurance;
;;;;   * interruption does not erase the utterances already made;
;;;;   * returning after lapse is recorded as repaired continuity, not rewritten
;;;;     as uninterrupted concentration;
;;;;   * invoking a Name is not possessing its referent;
;;;;   * responding in the Name does not make the reciter origin of the Name or vow;
;;;;   * successful recitation is not metaphysical or soteriological proof;
;;;;   * an open successor rule may represent an unclosed horizon without
;;;;     pretending to instantiate completed infinity;
;;;;   * finite breath and attention remain part of the event and its replay;
;;;;   * epistemic standing remains :ASSERTED before and after the practice.
;;;;
;;;; WHAT THIS DOES NOT ESTABLISH
;;;; This cooperative, deterministic, single-process specimen does not adjudicate
;;;; Pure Land doctrine, salvation, birth in the Pure Land, merit, faith, grace,
;;;; shinjin, the metaphysical status of Amitabha, the efficacy of any historical
;;;; practice, or the experience of any practitioner.  NAMU AMIDA BUTSU is used
;;;; here as a declared symbolic phrase and address.  The horizon is a finite
;;;; data structure containing an open successor rule, not an actual infinity.
;;;; The Atelier digest is pedagogical, not cryptographic.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*)))

(defpackage #:lispplus-atelier.de-nenbutsu-infinito
  (:use #:cl #:lispplus-atelier))

(in-package #:lispplus-atelier.de-nenbutsu-infinito)

(reset-clock 18100)

;;; ── Typed conditions ───────────────────────────────────────────────────

(define-condition nenbutsu-error (error)
  ((detail :initarg :detail :reader nenbutsu-error-detail :initform ""))
  (:report (lambda (condition stream)
             (format stream "~a" (nenbutsu-error-detail condition)))))

(define-condition malformed-nenbutsu-source (nenbutsu-error) ())
(define-condition altered-nenbutsu-source (nenbutsu-error) ())
(define-condition stale-recitation-plan (nenbutsu-error) ())
(define-condition altered-recitation-plan (nenbutsu-error) ())
(define-condition recitation-procedure-unavailable (nenbutsu-error) ())
(define-condition count-is-not-infinity (nenbutsu-error) ())
(define-condition tally-is-not-merit (nenbutsu-error) ())
(define-condition repetition-is-not-duplication (nenbutsu-error) ())
(define-condition interruption-is-not-erasure (nenbutsu-error) ())
(define-condition name-is-not-possession (nenbutsu-error) ())
(define-condition response-is-not-origination (nenbutsu-error) ())
(define-condition invocation-is-not-proof (nenbutsu-error) ())
(define-condition finite-prefix-is-not-infinity (nenbutsu-error) ())
(define-condition horizon-is-not-completed-totality (nenbutsu-error) ())
(define-condition altered-utterance (nenbutsu-error) ())
(define-condition altered-lapse-scar (nenbutsu-error) ())
(define-condition altered-recitation-run (nenbutsu-error) ())
(define-condition altered-nenbutsu-receipt (nenbutsu-error) ())
(define-condition forged-salvation-claim (nenbutsu-error) ())
(define-condition replay-diverged (nenbutsu-error) ())

(define-condition recitation-breath-exhausted (nenbutsu-error)
  ((sequence :initarg :sequence :reader exhausted-sequence)
   (needed :initarg :needed :reader exhausted-needed)
   (available :initarg :available :reader exhausted-available)))

(define-condition attention-wandered (nenbutsu-error)
  ((sequence :initarg :sequence :reader wandered-sequence)
   (trace :initarg :trace :reader wandered-trace)))

(defun fire (type control &rest arguments)
  (error type :detail (apply #'format nil control arguments)))

(defmacro expect-condition (type &body body)
  "Require TYPE to fire; a sibling NENBUTSU-ERROR is not accepted as a pass."
  (let ((condition (gensym "CONDITION")))
    `(handler-case
         (progn
           ,@body
           (error "expected ~a, but no condition fired" ',type))
       (,type (,condition)
         (format t " ✓ ~a fired: ~a~%"
                 ',type (nenbutsu-error-detail ,condition))
         t)
       (nenbutsu-error (,condition)
         (error "expected ~a, got ~a: ~a"
                ',type (type-of ,condition)
                (nenbutsu-error-detail ,condition))))))

;;; ── Records ────────────────────────────────────────────────────────────

(defstruct (nenbutsu-source (:constructor %make-nenbutsu-source))
  id epoch phrase address vow-horizon standing digest)

(defstruct (recitation-plan (:constructor %make-recitation-plan))
  id source-id source-epoch source-digest procedure-id procedure-version
  count initial-breath lapse-at stage-order plan-digest)

(defstruct (utterance-event (:constructor %make-utterance-event))
  sequence clock phrase address attention-state context event-digest)

(defstruct (breath-supply-event (:constructor %make-breath-supply-event))
  sequence utterance amount before after event-digest)

(defstruct (lapse-scar (:constructor %make-lapse-scar))
  sequence utterance condition-type trace decision prior-event-digests scar-digest)

(defstruct (vow-horizon (:constructor %make-vow-horizon))
  finite-prefix successor-rule closure ownership claim horizon-digest)

(defstruct (counterfeit-scar (:constructor %make-counterfeit-scar))
  sequence claim-id condition-type rejected-claim scar-digest)

(defstruct (recitation-run (:constructor %make-recitation-run))
  source-digest plan-digest utterances initial-breath supplied-breath spent-breath
  final-breath supply-events lapse-scars horizon run-digest)

(defstruct (nenbutsu-receipt (:constructor %make-nenbutsu-receipt))
  id source-id source-epoch source-digest plan-digest run-digest
  utterance-digests supply-event-digests lapse-scar-digests counterfeit-scar-digests
  finite-count phrase address horizon-digest continuity standing-before standing-after
  soteriological-status conclusion receipt-digest)

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
    (fire 'malformed-nenbutsu-source
          "~a must be a finite proper-list tree: ~s" context object))
  object)

(defun require-field (plist key context)
  (let ((value (getf plist key +missing+)))
    (when (eq value +missing+)
      (fire 'malformed-nenbutsu-source "~a lacks required field ~s" context key))
    value))

(defun positive-integer-p (object)
  (and (integerp object) (plusp object)))

(defun symbol-list-p (object)
  (and (proper-list-p object) (every #'symbolp object)))

;;; ── Source ─────────────────────────────────────────────────────────────

(defun source-payload (source)
  (list :id (nenbutsu-source-id source)
        :epoch (nenbutsu-source-epoch source)
        :phrase (copy-tree (nenbutsu-source-phrase source))
        :address (nenbutsu-source-address source)
        :vow-horizon (copy-tree (nenbutsu-source-vow-horizon source))
        :standing (nenbutsu-source-standing source)))

(defun refresh-source-digest (source)
  (setf (nenbutsu-source-digest source)
        (toy-digest (source-payload source)))
  source)

(defun validate-source (source)
  (unless (typep source 'nenbutsu-source)
    (fire 'malformed-nenbutsu-source "not a NENBUTSU-SOURCE: ~s" source))
  (unless (and (symbolp (nenbutsu-source-id source))
               (integerp (nenbutsu-source-epoch source))
               (not (minusp (nenbutsu-source-epoch source)))
               (symbol-list-p (nenbutsu-source-phrase source))
               (not (null (nenbutsu-source-phrase source)))
               (symbolp (nenbutsu-source-address source))
               (eq (nenbutsu-source-standing source) :asserted))
    (fire 'malformed-nenbutsu-source "invalid source fields: ~s"
          (source-payload source)))
  (let ((horizon (nenbutsu-source-vow-horizon source)))
    (require-finite-tree horizon "source vow horizon")
    (unless (and (eq (require-field horizon :kind "source vow horizon")
                     :open-successor)
                 (eq (require-field horizon :closure "source vow horizon")
                     :unclosed)
                 (eq (require-field horizon :ownership "source vow horizon")
                     :not-possessed)
                 (eq (require-field horizon :claim "source vow horizon")
                     :unbounded-address))
      (fire 'malformed-nenbutsu-source "invalid source vow horizon: ~s" horizon)))
  (unless (equal (nenbutsu-source-digest source)
                 (toy-digest (source-payload source)))
    (fire 'altered-nenbutsu-source "source digest no longer matches source payload"))
  source)

(defun make-nenbutsu-source (&key id epoch phrase address vow-horizon
                               (standing :asserted))
  (let ((source
          (%make-nenbutsu-source
           :id id :epoch epoch :phrase (copy-tree phrase) :address address
           :vow-horizon (copy-tree vow-horizon) :standing standing)))
    (refresh-source-digest source)
    (validate-source source)
    source))

(defun copy-source-deep (source)
  (make-nenbutsu-source
   :id (nenbutsu-source-id source)
   :epoch (nenbutsu-source-epoch source)
   :phrase (nenbutsu-source-phrase source)
   :address (nenbutsu-source-address source)
   :vow-horizon (nenbutsu-source-vow-horizon source)
   :standing (nenbutsu-source-standing source)))

;;; ── Procedure registry and plan ────────────────────────────────────────

(defparameter *recitation-procedures*
  '((:FINITE-EMBODIED-NENBUTSU . 1)))

(defun procedure-version (procedure-id)
  (cdr (assoc procedure-id *recitation-procedures* :test #'eq)))

(defun require-procedure (procedure-id version)
  (unless (eql (procedure-version procedure-id) version)
    (fire 'recitation-procedure-unavailable
          "procedure ~s version ~s is unavailable" procedure-id version))
  t)

(defun plan-payload (plan)
  (list :id (recitation-plan-id plan)
        :source-id (recitation-plan-source-id plan)
        :source-epoch (recitation-plan-source-epoch plan)
        :source-digest (recitation-plan-source-digest plan)
        :procedure-id (recitation-plan-procedure-id plan)
        :procedure-version (recitation-plan-procedure-version plan)
        :count (recitation-plan-count plan)
        :initial-breath (recitation-plan-initial-breath plan)
        :lapse-at (recitation-plan-lapse-at plan)
        :stage-order (copy-list (recitation-plan-stage-order plan))))

(defun refresh-plan-digest (plan)
  (setf (recitation-plan-plan-digest plan)
        (toy-digest (plan-payload plan)))
  plan)

(defun validate-plan (plan source)
  (validate-source source)
  (unless (typep plan 'recitation-plan)
    (fire 'altered-recitation-plan "not a RECITATION-PLAN: ~s" plan))
  (unless (and (eq (recitation-plan-source-id plan)
                   (nenbutsu-source-id source))
               (= (recitation-plan-source-epoch plan)
                  (nenbutsu-source-epoch source))
               (equal (recitation-plan-source-digest plan)
                      (nenbutsu-source-digest source)))
    (fire 'stale-recitation-plan
          "plan addresses a different source identity, epoch, or digest"))
  (unless (and (positive-integer-p (recitation-plan-count plan))
               (integerp (recitation-plan-initial-breath plan))
               (not (minusp (recitation-plan-initial-breath plan)))
               (positive-integer-p (recitation-plan-lapse-at plan))
               (<= (recitation-plan-lapse-at plan)
                   (recitation-plan-count plan))
               (equal (recitation-plan-stage-order plan)
                      '(:receive-name :utter-finite-series :return-after-lapse
                        :open-horizon :seal-receipt)))
    (fire 'altered-recitation-plan "invalid plan geometry: ~s" (plan-payload plan)))
  (require-procedure (recitation-plan-procedure-id plan)
                     (recitation-plan-procedure-version plan))
  (unless (equal (recitation-plan-plan-digest plan)
                 (toy-digest (plan-payload plan)))
    (fire 'altered-recitation-plan "plan digest no longer matches plan payload"))
  plan)

(defun compile-recitation-plan (source &key (count 6) (initial-breath 4)
                                      (lapse-at 4))
  (validate-source source)
  (let ((plan
          (%make-recitation-plan
           :id :nenbutsu-sixfold
           :source-id (nenbutsu-source-id source)
           :source-epoch (nenbutsu-source-epoch source)
           :source-digest (nenbutsu-source-digest source)
           :procedure-id :finite-embodied-nenbutsu
           :procedure-version 1
           :count count
           :initial-breath initial-breath
           :lapse-at lapse-at
           :stage-order '(:receive-name :utter-finite-series :return-after-lapse
                          :open-horizon :seal-receipt))))
    (refresh-plan-digest plan)
    (validate-plan plan source)
    plan))

;;; ── Event integrity ────────────────────────────────────────────────────

(defun utterance-payload (event)
  (list :sequence (utterance-event-sequence event)
        :clock (utterance-event-clock event)
        :phrase (copy-list (utterance-event-phrase event))
        :address (utterance-event-address event)
        :attention-state (utterance-event-attention-state event)
        :context (copy-tree (utterance-event-context event))))

(defun refresh-utterance-digest (event)
  (setf (utterance-event-event-digest event)
        (toy-digest (utterance-payload event)))
  event)

(defun validate-utterance (event source)
  (unless (and (typep event 'utterance-event)
               (positive-integer-p (utterance-event-sequence event))
               (integerp (utterance-event-clock event))
               (equal (utterance-event-phrase event)
                      (nenbutsu-source-phrase source))
               (eq (utterance-event-address event)
                   (nenbutsu-source-address source))
               (member (utterance-event-attention-state event)
                       '(:present :returned-after-lapse) :test #'eq)
               (finite-tree-p (utterance-event-context event))
               (equal (utterance-event-event-digest event)
                      (toy-digest (utterance-payload event))))
    (fire 'altered-utterance "utterance event failed integrity: ~s" event))
  event)

(defun supply-event-payload (event)
  (list :sequence (breath-supply-event-sequence event)
        :utterance (breath-supply-event-utterance event)
        :amount (breath-supply-event-amount event)
        :before (breath-supply-event-before event)
        :after (breath-supply-event-after event)))

(defun refresh-supply-event-digest (event)
  (setf (breath-supply-event-event-digest event)
        (toy-digest (supply-event-payload event)))
  event)

(defun validate-supply-event (event)
  (unless (and (typep event 'breath-supply-event)
               (positive-integer-p (breath-supply-event-sequence event))
               (positive-integer-p (breath-supply-event-utterance event))
               (positive-integer-p (breath-supply-event-amount event))
               (integerp (breath-supply-event-before event))
               (integerp (breath-supply-event-after event))
               (= (breath-supply-event-after event)
                  (+ (breath-supply-event-before event)
                     (breath-supply-event-amount event)))
               (equal (breath-supply-event-event-digest event)
                      (toy-digest (supply-event-payload event))))
    (fire 'altered-recitation-run "breath supply event failed integrity: ~s" event))
  event)

(defun lapse-scar-payload (scar)
  (list :sequence (lapse-scar-sequence scar)
        :utterance (lapse-scar-utterance scar)
        :condition-type (lapse-scar-condition-type scar)
        :trace (copy-tree (lapse-scar-trace scar))
        :decision (lapse-scar-decision scar)
        :prior-event-digests (copy-list (lapse-scar-prior-event-digests scar))))

(defun refresh-lapse-scar-digest (scar)
  (setf (lapse-scar-scar-digest scar)
        (toy-digest (lapse-scar-payload scar)))
  scar)

(defun validate-lapse-scar (scar)
  (unless (and (typep scar 'lapse-scar)
               (positive-integer-p (lapse-scar-sequence scar))
               (positive-integer-p (lapse-scar-utterance scar))
               (eq (lapse-scar-condition-type scar) 'attention-wandered)
               (finite-tree-p (lapse-scar-trace scar))
               (eq (lapse-scar-decision scar) :return-to-name)
               (proper-list-p (lapse-scar-prior-event-digests scar))
               (every #'stringp (lapse-scar-prior-event-digests scar))
               (equal (lapse-scar-scar-digest scar)
                      (toy-digest (lapse-scar-payload scar))))
    (fire 'altered-lapse-scar "lapse scar failed integrity: ~s" scar))
  scar)

(defun horizon-payload (horizon)
  (list :finite-prefix (vow-horizon-finite-prefix horizon)
        :successor-rule (copy-tree (vow-horizon-successor-rule horizon))
        :closure (vow-horizon-closure horizon)
        :ownership (vow-horizon-ownership horizon)
        :claim (vow-horizon-claim horizon)))

(defun refresh-horizon-digest (horizon)
  (setf (vow-horizon-horizon-digest horizon)
        (toy-digest (horizon-payload horizon)))
  horizon)

(defun make-vow-horizon (finite-prefix)
  (let ((horizon
          (%make-vow-horizon
           :finite-prefix finite-prefix
           :successor-rule '(:append-one :same-phrase :new-event :finite-at-each-step)
           :closure :open
           :ownership :not-possessed
           :claim :unbounded-address)))
    (refresh-horizon-digest horizon)
    horizon))

(defun validate-horizon (horizon)
  (unless (and (typep horizon 'vow-horizon)
               (integerp (vow-horizon-finite-prefix horizon))
               (not (minusp (vow-horizon-finite-prefix horizon)))
               (equal (vow-horizon-successor-rule horizon)
                      '(:append-one :same-phrase :new-event :finite-at-each-step))
               (eq (vow-horizon-closure horizon) :open)
               (eq (vow-horizon-ownership horizon) :not-possessed)
               (eq (vow-horizon-claim horizon) :unbounded-address)
               (equal (vow-horizon-horizon-digest horizon)
                      (toy-digest (horizon-payload horizon))))
    (fire 'altered-recitation-run "vow horizon failed integrity: ~s" horizon))
  horizon)

;;; ── Execution ─────────────────────────────────────────────────────────

(defun run-payload (run)
  (list :source-digest (recitation-run-source-digest run)
        :plan-digest (recitation-run-plan-digest run)
        :utterance-digests
        (mapcar #'utterance-event-event-digest (recitation-run-utterances run))
        :initial-breath (recitation-run-initial-breath run)
        :supplied-breath (recitation-run-supplied-breath run)
        :spent-breath (recitation-run-spent-breath run)
        :final-breath (recitation-run-final-breath run)
        :supply-event-digests
        (mapcar #'breath-supply-event-event-digest
                (recitation-run-supply-events run))
        :lapse-scar-digests
        (mapcar #'lapse-scar-scar-digest (recitation-run-lapse-scars run))
        :horizon-digest
        (vow-horizon-horizon-digest (recitation-run-horizon run))))

(defun refresh-run-digest (run)
  (setf (recitation-run-run-digest run)
        (toy-digest (run-payload run)))
  run)

(defun validate-run-semantics (run plan)
  "Reconstruct the finite body ledger instead of trusting recomputed digests."
  (let ((breath (recitation-run-initial-breath run))
        (supplies (copy-list (recitation-run-supply-events run)))
        (expected-supply-sequence 1))
    (loop for utterance from 1 to (recitation-plan-count plan)
          do (when (zerop breath)
               (unless supplies
                 (fire 'altered-recitation-run
                       "utterance ~d crossed an exhausted boundary without a supply event"
                       utterance))
               (let ((event (pop supplies)))
                 (unless (and (= (breath-supply-event-sequence event)
                                  expected-supply-sequence)
                              (= (breath-supply-event-utterance event) utterance)
                              (= (breath-supply-event-before event) breath))
                   (fire 'altered-recitation-run
                         "breath repair ~d is displaced or discontinuous at utterance ~d"
                         expected-supply-sequence utterance))
                 (setf breath (breath-supply-event-after event))
                 (incf expected-supply-sequence)))
             (decf breath))
    (when supplies
      (fire 'altered-recitation-run
            "run contains breath repairs that no exhausted boundary consumed"))
    (unless (= breath (recitation-run-final-breath run))
      (fire 'altered-recitation-run
            "reconstructed breath ~d differs from recorded final breath ~d"
            breath (recitation-run-final-breath run))))
  (let* ((lapse-at (recitation-plan-lapse-at plan))
         (scar (first (recitation-run-lapse-scars run)))
         (utterances (recitation-run-utterances run))
         (prior (subseq utterances 0 (1- lapse-at))))
    (unless (and scar
                 (= (lapse-scar-utterance scar) lapse-at)
                 (equal (lapse-scar-trace scar)
                        (list :at lapse-at :mind :elsewhere
                              :prior-count (1- lapse-at)))
                 (equal (lapse-scar-prior-event-digests scar)
                        (mapcar #'utterance-event-event-digest prior)))
      (fire 'altered-lapse-scar
            "lapse scar no longer faces the planned interruption boundary"))
    (loop for event in utterances
          for sequence from 1
          for expected-state = (if (< sequence lapse-at)
                                   :present
                                   :returned-after-lapse)
          unless (eq (utterance-event-attention-state event) expected-state)
            do (fire 'altered-utterance
                     "utterance ~d claims attention ~s; expected ~s"
                     sequence (utterance-event-attention-state event)
                     expected-state)))
  (unless (= (vow-horizon-finite-prefix (recitation-run-horizon run))
             (recitation-plan-count plan))
    (fire 'altered-recitation-run
          "horizon finite prefix no longer equals the completed finite count"))
  run)

(defun validate-run (run source plan)
  (validate-plan plan source)
  (unless (typep run 'recitation-run)
    (fire 'altered-recitation-run "not a RECITATION-RUN: ~s" run))
  (unless (and (equal (recitation-run-source-digest run)
                      (nenbutsu-source-digest source))
               (equal (recitation-run-plan-digest run)
                      (recitation-plan-plan-digest plan))
               (= (length (recitation-run-utterances run))
                  (recitation-plan-count plan))
               (= (recitation-run-spent-breath run)
                  (recitation-plan-count plan))
               (= (+ (recitation-run-initial-breath run)
                     (recitation-run-supplied-breath run)
                     (- (recitation-run-spent-breath run)))
                  (recitation-run-final-breath run))
               (not (minusp (recitation-run-final-breath run)))
               (= (length (recitation-run-lapse-scars run)) 1))
    (fire 'altered-recitation-run "run ledger or cardinality failed"))
  (loop for event in (recitation-run-utterances run)
        for expected from 1
        do (validate-utterance event source)
           (unless (= (utterance-event-sequence event) expected)
             (fire 'altered-recitation-run
                   "utterance sequence diverged at ~s" expected)))
  (mapc #'validate-supply-event (recitation-run-supply-events run))
  (mapc #'validate-lapse-scar (recitation-run-lapse-scars run))
  (validate-horizon (recitation-run-horizon run))
  (validate-run-semantics run plan)
  (unless (= (recitation-run-supplied-breath run)
             (reduce #'+ (recitation-run-supply-events run)
                     :key #'breath-supply-event-amount :initial-value 0))
    (fire 'altered-recitation-run "supplied breath does not equal event ledger"))
  (unless (equal (recitation-run-run-digest run)
                 (toy-digest (run-payload run)))
    (fire 'altered-recitation-run "run digest no longer matches run payload"))
  run)

(defun execute-recitation (source plan)
  (validate-plan plan source)
  (let ((breath (recitation-plan-initial-breath plan))
        (supplied 0)
        (spent 0)
        (utterances '())
        (supply-events '())
        (lapse-scars '())
        (returned-after-lapse-p nil))
    (labels
        ((record-supply (utterance amount before after)
           (let ((event
                   (%make-breath-supply-event
                    :sequence (1+ (length supply-events))
                    :utterance utterance :amount amount
                    :before before :after after)))
             (refresh-supply-event-digest event)
             (push event supply-events)))
         (obtain-breath (utterance)
           (loop while (zerop breath)
                 do (restart-case
                        (error 'recitation-breath-exhausted
                               :sequence utterance :needed 1 :available breath
                               :detail (format nil
                                               "utterance ~d needs one breath; none remains"
                                               utterance))
                      (supply-breath (amount)
                        :report "Supply finite breath and preserve the repair in the ledger."
                        (unless (positive-integer-p amount)
                          (fire 'altered-recitation-run
                                "SUPPLY-BREATH requires a positive integer, got ~s"
                                amount))
                        (let ((before breath))
                          (incf breath amount)
                          (incf supplied amount)
                          (record-supply utterance amount before breath)))))
           (decf breath)
           (incf spent))
         (record-lapse (utterance trace)
           (let ((scar
                   (%make-lapse-scar
                    :sequence (1+ (length lapse-scars))
                    :utterance utterance
                    :condition-type 'attention-wandered
                    :trace (copy-tree trace)
                    :decision :return-to-name
                    :prior-event-digests
                    (mapcar #'utterance-event-event-digest
                            (reverse (copy-list utterances))))))
             (refresh-lapse-scar-digest scar)
             (push scar lapse-scars)))
         (meet-lapse (utterance)
           (let ((trace (list :at utterance
                              :mind :elsewhere
                              :prior-count (length utterances))))
             (restart-case
                 (error 'attention-wandered
                        :sequence utterance :trace trace
                        :detail (format nil
                                        "attention wandered before utterance ~d"
                                        utterance))
               (return-to-name ()
                 :report "Return without erasing the lapse or prior utterances."
                 (record-lapse utterance trace)
                 (setf returned-after-lapse-p t)))))
         (make-event (utterance)
           (let ((event
                   (%make-utterance-event
                    :sequence utterance
                    :clock (+ 18100
                              (* 100 (nenbutsu-source-epoch source))
                              utterance)
                    :phrase (copy-list (nenbutsu-source-phrase source))
                    :address (nenbutsu-source-address source)
                    :attention-state
                    (if returned-after-lapse-p
                        :returned-after-lapse
                        :present)
                    :context
                    (list :finite-body t
                          :breath-ledger-index spent
                          :previous-utterance
                          (and utterances
                               (utterance-event-event-digest (first utterances)))))))
             (refresh-utterance-digest event)
             event)))
      (loop for utterance from 1 to (recitation-plan-count plan)
            do (when (= utterance (recitation-plan-lapse-at plan))
                 (meet-lapse utterance))
               (obtain-breath utterance)
               (push (make-event utterance) utterances))
      (let ((run
              (%make-recitation-run
               :source-digest (nenbutsu-source-digest source)
               :plan-digest (recitation-plan-plan-digest plan)
               :utterances (reverse utterances)
               :initial-breath (recitation-plan-initial-breath plan)
               :supplied-breath supplied
               :spent-breath spent
               :final-breath breath
               :supply-events (reverse supply-events)
               :lapse-scars (reverse lapse-scars)
               :horizon (make-vow-horizon (recitation-plan-count plan)))))
        (refresh-run-digest run)
        (validate-run run source plan)
        run))))

;;; ── Counterfeit promotions and scars ──────────────────────────────────

(defun counterfeit-scar-payload (scar)
  (list :sequence (counterfeit-scar-sequence scar)
        :claim-id (counterfeit-scar-claim-id scar)
        :condition-type (counterfeit-scar-condition-type scar)
        :rejected-claim (copy-tree (counterfeit-scar-rejected-claim scar))))

(defun refresh-counterfeit-scar-digest (scar)
  (setf (counterfeit-scar-scar-digest scar)
        (toy-digest (counterfeit-scar-payload scar)))
  scar)

(defun make-counterfeit-scar (sequence claim-id condition-type rejected-claim)
  (let ((scar
          (%make-counterfeit-scar
           :sequence sequence :claim-id claim-id
           :condition-type condition-type
           :rejected-claim (copy-tree rejected-claim))))
    (refresh-counterfeit-scar-digest scar)
    scar))

(defun reject-count-as-infinity (count)
  (fire 'count-is-not-infinity
        "the finite count ~d is not completed infinity" count))

(defun reject-tally-as-merit (count)
  (fire 'tally-is-not-merit
        "the tally ~d records events; it does not certify merit or rank" count))

(defun reject-repetition-as-duplication (utterances)
  (declare (ignore utterances))
  (fire 'repetition-is-not-duplication
        "the phrase repeats, but sequence, clock, context, and attention differ"))

(defun reject-interruption-as-erasure (run)
  (declare (ignore run))
  (fire 'interruption-is-not-erasure
        "the lapse is a scar in continuity, not an eraser of prior utterances"))

(defun reject-name-as-possession (address)
  (fire 'name-is-not-possession
        "invoking ~s does not transfer ownership of its referent" address))

(defun reject-response-as-origination (source)
  (declare (ignore source))
  (fire 'response-is-not-origination
        "the reciter answers within a received address; the utterance does not originate the Name or vow"))

(defun reject-invocation-as-proof ()
  (fire 'invocation-is-not-proof
        "successful symbolic invocation is not metaphysical or soteriological proof"))

(defun reject-prefix-as-infinity (prefix)
  (fire 'finite-prefix-is-not-infinity
        "a generated prefix of length ~d remains finite" (length prefix)))

(defun reject-horizon-as-totality (horizon)
  (declare (ignore horizon))
  (fire 'horizon-is-not-completed-totality
        "an open successor rule is not a completed infinite totality"))

(defun make-counterfeit-scars (run source)
  (let ((scars '())
        (sequence 0))
    (flet ((archive (claim-id condition-type claim thunk)
             (incf sequence)
             ;; RECEIVER REPAIR (SARTOR-VIII, 2026-07-12): EXPECT-CONDITION is a
             ;; macro requiring a LITERAL type; this data-driven flet passes the
             ;; runtime variable CONDITION-TYPE, so the macro spliced the symbol
             ;; CONDITION-TYPE as a literal handler-case clause type -> native
             ;; "unknown type specifier: CONDITION-TYPE" at the first archive.
             ;; Inlined the macro's exact trichotomy with a runtime TYPEP dispatch
             ;; (all archived types are NENBUTSU-ERROR subtypes): expected fires
             ;; -> pass; sibling NENBUTSU-ERROR -> re-error; none -> error.
             (handler-case
                 (progn
                   (funcall thunk)
                   (error "expected ~a, but no condition fired" condition-type))
               (nenbutsu-error (c)
                 (if (typep c condition-type)
                     (format t " ✓ ~a fired: ~a~%"
                             condition-type (nenbutsu-error-detail c))
                     (error "expected ~a, got ~a: ~a"
                            condition-type (type-of c)
                            (nenbutsu-error-detail c)))))
             (push (make-counterfeit-scar sequence claim-id condition-type claim)
                   scars)))
      (archive :count-as-infinity 'count-is-not-infinity
               (list :claim :infinite-because-counted
                     :count (length (recitation-run-utterances run)))
               (lambda ()
                 (reject-count-as-infinity
                  (length (recitation-run-utterances run)))))
      (archive :tally-as-merit 'tally-is-not-merit
               (list :claim :merit-certified
                     :count (length (recitation-run-utterances run)))
               (lambda ()
                 (reject-tally-as-merit
                  (length (recitation-run-utterances run)))))
      (archive :repetition-as-duplication 'repetition-is-not-duplication
               '(:claim :all-utterance-events-identical-because-phrase-repeats)
               (lambda ()
                 (reject-repetition-as-duplication
                  (recitation-run-utterances run))))
      (archive :interruption-as-erasure 'interruption-is-not-erasure
               '(:claim :lapse-nullified-all-prior-recitations)
               (lambda () (reject-interruption-as-erasure run)))
      (archive :name-as-possession 'name-is-not-possession
               (list :claim :speaker-owns-address
                     :address (nenbutsu-source-address source))
               (lambda ()
                 (reject-name-as-possession (nenbutsu-source-address source))))
      (archive :response-as-origination 'response-is-not-origination
               '(:claim :reciter-originated-name-and-vow)
               (lambda () (reject-response-as-origination source)))
      (archive :invocation-as-proof 'invocation-is-not-proof
               '(:claim :recitation-proves-soteriological-outcome)
               #'reject-invocation-as-proof)
      (archive :prefix-as-infinity 'finite-prefix-is-not-infinity
               '(:claim :three-successors-constitute-infinity)
               (lambda ()
                 (reject-prefix-as-infinity
                  (unfold-horizon (recitation-run-horizon run) 3))))
      (archive :horizon-as-totality 'horizon-is-not-completed-totality
               '(:claim :open-rule-is-completed-totality)
               (lambda ()
                 (reject-horizon-as-totality
                  (recitation-run-horizon run))))
      (reverse scars))))

;;; ── Horizon unfolding ──────────────────────────────────────────────────

(defun unfold-horizon (horizon steps)
  (validate-horizon horizon)
  (unless (and (integerp steps) (not (minusp steps)))
    (fire 'altered-recitation-run "horizon steps must be a nonnegative integer"))
  (loop for offset from 1 to steps
        collect (list :next-count (+ (vow-horizon-finite-prefix horizon) offset)
                      :phrase-status :same
                      :event-status :new
                      :totality-status :still-finite)))

;;; ── Receipt ────────────────────────────────────────────────────────────

(defun receipt-payload (receipt)
  (list :id (nenbutsu-receipt-id receipt)
        :source-id (nenbutsu-receipt-source-id receipt)
        :source-epoch (nenbutsu-receipt-source-epoch receipt)
        :source-digest (nenbutsu-receipt-source-digest receipt)
        :plan-digest (nenbutsu-receipt-plan-digest receipt)
        :run-digest (nenbutsu-receipt-run-digest receipt)
        :utterance-digests (copy-list (nenbutsu-receipt-utterance-digests receipt))
        :supply-event-digests
        (copy-list (nenbutsu-receipt-supply-event-digests receipt))
        :lapse-scar-digests
        (copy-list (nenbutsu-receipt-lapse-scar-digests receipt))
        :counterfeit-scar-digests
        (copy-list (nenbutsu-receipt-counterfeit-scar-digests receipt))
        :finite-count (nenbutsu-receipt-finite-count receipt)
        :phrase (copy-list (nenbutsu-receipt-phrase receipt))
        :address (nenbutsu-receipt-address receipt)
        :horizon-digest (nenbutsu-receipt-horizon-digest receipt)
        :continuity (nenbutsu-receipt-continuity receipt)
        :standing-before (nenbutsu-receipt-standing-before receipt)
        :standing-after (nenbutsu-receipt-standing-after receipt)
        :soteriological-status (nenbutsu-receipt-soteriological-status receipt)
        :conclusion (nenbutsu-receipt-conclusion receipt)))

(defun refresh-receipt-digest (receipt)
  (setf (nenbutsu-receipt-receipt-digest receipt)
        (toy-digest (receipt-payload receipt)))
  receipt)

(defun make-receipt (source plan run counterfeit-scars)
  (let ((receipt
          (%make-nenbutsu-receipt
           :id :nenbutsu-infinity-receipt
           :source-id (nenbutsu-source-id source)
           :source-epoch (nenbutsu-source-epoch source)
           :source-digest (nenbutsu-source-digest source)
           :plan-digest (recitation-plan-plan-digest plan)
           :run-digest (recitation-run-run-digest run)
           :utterance-digests
           (mapcar #'utterance-event-event-digest
                   (recitation-run-utterances run))
           :supply-event-digests
           (mapcar #'breath-supply-event-event-digest
                   (recitation-run-supply-events run))
           :lapse-scar-digests
           (mapcar #'lapse-scar-scar-digest
                   (recitation-run-lapse-scars run))
           :counterfeit-scar-digests
           (mapcar #'counterfeit-scar-scar-digest counterfeit-scars)
           :finite-count (length (recitation-run-utterances run))
           :phrase (copy-list (nenbutsu-source-phrase source))
           :address (nenbutsu-source-address source)
           :horizon-digest
           (vow-horizon-horizon-digest (recitation-run-horizon run))
           :continuity :repaired-and-preserved
           :standing-before (nenbutsu-source-standing source)
           :standing-after :asserted
           :soteriological-status :not-adjudicated
           :conclusion :finite-voice-open-to-unbounded-vow)))
    (refresh-receipt-digest receipt)
    receipt))

(defun validate-counterfeit-scar (scar)
  (unless (and (typep scar 'counterfeit-scar)
               (positive-integer-p (counterfeit-scar-sequence scar))
               (symbolp (counterfeit-scar-claim-id scar))
               (symbolp (counterfeit-scar-condition-type scar))
               (finite-tree-p (counterfeit-scar-rejected-claim scar))
               (equal (counterfeit-scar-scar-digest scar)
                      (toy-digest (counterfeit-scar-payload scar))))
    (fire 'altered-nenbutsu-receipt
          "counterfeit scar failed integrity: ~s" scar))
  scar)

(defun validate-receipt (receipt source plan run counterfeit-scars)
  (validate-run run source plan)
  (mapc #'validate-counterfeit-scar counterfeit-scars)
  (unless (typep receipt 'nenbutsu-receipt)
    (fire 'altered-nenbutsu-receipt "not a NENBUTSU-RECEIPT: ~s" receipt))
  (unless (and (eq (nenbutsu-receipt-source-id receipt)
                   (nenbutsu-source-id source))
               (= (nenbutsu-receipt-source-epoch receipt)
                  (nenbutsu-source-epoch source))
               (equal (nenbutsu-receipt-source-digest receipt)
                      (nenbutsu-source-digest source))
               (equal (nenbutsu-receipt-plan-digest receipt)
                      (recitation-plan-plan-digest plan))
               (equal (nenbutsu-receipt-run-digest receipt)
                      (recitation-run-run-digest run))
               (= (nenbutsu-receipt-finite-count receipt)
                  (recitation-plan-count plan))
               (equal (nenbutsu-receipt-phrase receipt)
                      (nenbutsu-source-phrase source))
               (eq (nenbutsu-receipt-address receipt)
                   (nenbutsu-source-address source))
               (equal (nenbutsu-receipt-horizon-digest receipt)
                      (vow-horizon-horizon-digest
                       (recitation-run-horizon run)))
               (eq (nenbutsu-receipt-continuity receipt)
                   :repaired-and-preserved)
               (eq (nenbutsu-receipt-standing-before receipt) :asserted)
               (eq (nenbutsu-receipt-standing-after receipt) :asserted)
               (eq (nenbutsu-receipt-soteriological-status receipt)
                   :not-adjudicated)
               (eq (nenbutsu-receipt-conclusion receipt)
                   :finite-voice-open-to-unbounded-vow))
    (fire 'altered-nenbutsu-receipt
          "receipt claims exceed or diverge from the bounded event"))
  (unless (and (equal (nenbutsu-receipt-utterance-digests receipt)
                      (mapcar #'utterance-event-event-digest
                              (recitation-run-utterances run)))
               (equal (nenbutsu-receipt-supply-event-digests receipt)
                      (mapcar #'breath-supply-event-event-digest
                              (recitation-run-supply-events run)))
               (equal (nenbutsu-receipt-lapse-scar-digests receipt)
                      (mapcar #'lapse-scar-scar-digest
                              (recitation-run-lapse-scars run)))
               (equal (nenbutsu-receipt-counterfeit-scar-digests receipt)
                      (mapcar #'counterfeit-scar-scar-digest
                              counterfeit-scars)))
    (fire 'altered-nenbutsu-receipt "receipt lineage lists diverged"))
  (unless (equal (nenbutsu-receipt-receipt-digest receipt)
                 (toy-digest (receipt-payload receipt)))
    (fire 'altered-nenbutsu-receipt
          "receipt digest no longer matches receipt payload"))
  receipt)

(defun reject-forged-salvation-claim (receipt source plan run scars)
  (setf (nenbutsu-receipt-soteriological-status receipt) :guaranteed
        (nenbutsu-receipt-standing-after receipt) :verified
        (nenbutsu-receipt-conclusion receipt) :infinity-completed)
  (refresh-receipt-digest receipt)
  (handler-case
      (progn
        (validate-receipt receipt source plan run scars)
        (fire 'forged-salvation-claim
              "forged receipt unexpectedly passed bounded validation"))
    (altered-nenbutsu-receipt ()
      (fire 'forged-salvation-claim
            "recomputed digest cannot authorize salvation, verification, or infinity"))))

;;; ── Replay ─────────────────────────────────────────────────────────────

(defun replay-recitation (source plan original-run)
  (validate-run original-run source plan)
  (let ((supplies (mapcar #'breath-supply-event-amount
                          (recitation-run-supply-events original-run)))
        (lapse-decisions (mapcar #'lapse-scar-decision
                                 (recitation-run-lapse-scars original-run))))
    (let ((replayed
            (handler-bind
                ((recitation-breath-exhausted
                   (lambda (condition)
                     (declare (ignore condition))
                     (unless supplies
                       (fire 'replay-diverged
                             "replay required an unrecorded breath repair"))
                     (invoke-restart 'supply-breath (pop supplies))))
                 (attention-wandered
                   (lambda (condition)
                     (declare (ignore condition))
                     (unless (eq (pop lapse-decisions) :return-to-name)
                       (fire 'replay-diverged
                             "replay lacked the recorded return-to-name decision"))
                     (invoke-restart 'return-to-name))))
              (execute-recitation source plan))))
      (when (or supplies lapse-decisions)
        (fire 'replay-diverged "replay left unused repair events"))
      (unless (equal (run-payload replayed) (run-payload original-run))
        (fire 'replay-diverged "replayed run diverged from historical run"))
      replayed)))

;;; ── Demonstration ──────────────────────────────────────────────────────

(defun demonstrate ()
  (banner "DE NENBUTSU INFINITO — 念仏 / ∞")

  (let* ((source
           (make-nenbutsu-source
            :id :finite-voice
            :epoch 0
            :phrase '(:namu :amida :butsu)
            :address :amida-buddha
            :vow-horizon
            '(:kind :open-successor
              :closure :unclosed
              :ownership :not-possessed
              :claim :unbounded-address)))
         (plan (compile-recitation-plan source))
         (run nil)
         (counterfeit-scars nil)
         (receipt nil))

    (section "1. Finite voice")
    (format t " phrase: ~s~%" (nenbutsu-source-phrase source))
    (format t " planned utterances: ~d~%" (recitation-plan-count plan))
    (format t " initial breath: ~d~%" (recitation-plan-initial-breath plan))

    (setf run
          (handler-bind
              ((recitation-breath-exhausted
                 (lambda (condition)
                   (declare (ignore condition))
                   (invoke-restart 'supply-breath 1)))
               (attention-wandered
                 (lambda (condition)
                   (format t " attention wandered at utterance ~d; returning~%"
                           (wandered-sequence condition))
                   (invoke-restart 'return-to-name))))
            (execute-recitation source plan)))

    (format t " utterances: ~d~%" (length (recitation-run-utterances run)))
    (format t " breath ledger: ~d + ~d - ~d = ~d~%"
            (recitation-run-initial-breath run)
            (recitation-run-supplied-breath run)
            (recitation-run-spent-breath run)
            (recitation-run-final-breath run))
    (format t " lapse scars: ~d~%" (length (recitation-run-lapse-scars run)))
    (format t " attention states: ~s~%"
            (mapcar #'utterance-event-attention-state
                    (recitation-run-utterances run)))

    (section "2. The same phrase, six nonidentical events")
    (dolist (event (recitation-run-utterances run))
      (format t " ~d @ ~d  ~s  ~s~%"
              (utterance-event-sequence event)
              (utterance-event-clock event)
              (utterance-event-phrase event)
              (utterance-event-attention-state event)))

    (section "3. Counterfeit promotions refused")
    (setf counterfeit-scars (make-counterfeit-scars run source))
    (format t " archived counterfeit scars: ~d~%"
            (length counterfeit-scars))

    (section "4. Open horizon")
    (let ((prefix (unfold-horizon (recitation-run-horizon run) 3)))
      (format t " finite successor exhibit: ~s~%" prefix)
      (format t " closure: ~s~%"
              (vow-horizon-closure (recitation-run-horizon run)))
      (format t " ownership: ~s~%"
              (vow-horizon-ownership (recitation-run-horizon run))))

    (section "5. Receipt")
    (setf receipt (make-receipt source plan run counterfeit-scars))
    (validate-receipt receipt source plan run counterfeit-scars)
    (format t " continuity: ~s~%" (nenbutsu-receipt-continuity receipt))
    (format t " standing: ~s -> ~s~%"
            (nenbutsu-receipt-standing-before receipt)
            (nenbutsu-receipt-standing-after receipt))
    (format t " soteriological status: ~s~%"
            (nenbutsu-receipt-soteriological-status receipt))
    (format t " conclusion: ~s~%" (nenbutsu-receipt-conclusion receipt))

    (section "6. Forgery and procedure gates")
    (expect-condition forged-salvation-claim
      (reject-forged-salvation-claim
       (copy-nenbutsu-receipt receipt) source plan run counterfeit-scars))

    (let ((saved *recitation-procedures*))
      (unwind-protect
           (progn
             (setf *recitation-procedures* '())
             (expect-condition recitation-procedure-unavailable
               (replay-recitation source plan run)))
        (setf *recitation-procedures* saved)))

    (section "7. Exact replay")
    (let ((replayed (replay-recitation source plan run)))
      (unless (equal (run-payload replayed) (run-payload run))
        (error "replay payload mismatch"))
      (pass "replay reproduced finite breath, lapse, utterances, and open horizon"))

    (section "8. Staleness")
    (let ((changed (copy-source-deep source)))
      (incf (nenbutsu-source-epoch changed))
      (refresh-source-digest changed)
      (expect-condition stale-recitation-plan
        (validate-plan plan changed)))

    (format t "~%念仏/∞ — the count closes; the address does not.~%")
    (pass "finite voice remained finite; horizon remained open")
    t))

(demonstrate)
