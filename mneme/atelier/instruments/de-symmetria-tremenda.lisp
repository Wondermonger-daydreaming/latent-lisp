;;;; de-symmetria-tremenda.lisp — Concerning Fearful Symmetry
;;;;
;;;; A standalone post-decad Lisp+ Atelier instrument inspired by William
;;;; Blake's "The Tyger".  It treats the poem's repeated refrain as a bounded
;;;; frame whose invariants survive while its governing modality changes from
;;;; COULD to DARE.
;;;;
;;;; THESIS
;;;;   * symmetry may preserve a pattern without establishing identity;
;;;;   * formal beauty does not imply harmlessness or moral innocence;
;;;;   * a list of tools is not yet a causal history of fabrication;
;;;;   * the ability to frame is not the courage, authority, or obligation to do so;
;;;;   * a question about a maker is not a certificate naming one;
;;;;   * common origin, even if granted, does not collapse unlike creatures into
;;;;     one nature;
;;;;   * representing a creature is not creating, owning, or subduing it;
;;;;   * repaired fire remains part of the forge event and deterministic replay;
;;;;   * every counterfeit promotion remains archived as a scar;
;;;;   * epistemic standing remains :ASSERTED before and after the frame.
;;;;
;;;; WHAT THIS DOES NOT ESTABLISH
;;;; This is a cooperative, deterministic, single-process specimen over finite
;;;; proper-list data.  It does not identify Blake's maker, prove a theology of
;;;; creation, infer the psychology of terror, measure poetic quality, model
;;;; actual metallurgy, establish biological ancestry, or animate a living
;;;; animal.  HAND, EYE, HAMMER, CHAIN, FURNACE, ANVIL, LAMB, and TYGER are
;;;; declared symbolic roles.  The digest supplied by the Atelier root is
;;;; pedagogical, not cryptographic.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*)))

(defpackage #:lispplus-atelier.de-symmetria-tremenda
  (:use #:cl #:lispplus-atelier))

(in-package #:lispplus-atelier.de-symmetria-tremenda)

(reset-clock 17700)

;;; ── Typed conditions: every counterfeit framing fails by name ─────────

(define-condition symmetry-error (error)
  ((detail :initarg :detail :reader symmetry-error-detail :initform ""))
  (:report (lambda (condition stream)
             (format stream "~a" (symmetry-error-detail condition)))))

(define-condition malformed-forge-source (symmetry-error) ())
(define-condition altered-forge-source (symmetry-error) ())
(define-condition altered-symmetry-plan (symmetry-error) ())
(define-condition stale-symmetry-plan (symmetry-error) ())
(define-condition frame-procedure-unavailable (symmetry-error) ())
(define-condition could-is-not-dare (symmetry-error) ())
(define-condition dare-is-not-ought (symmetry-error) ())
(define-condition symmetry-is-not-identity (symmetry-error) ())
(define-condition beauty-is-not-benign (symmetry-error) ())
(define-condition tool-list-is-not-cause (symmetry-error) ())
(define-condition question-is-not-certificate (symmetry-error) ())
(define-condition shared-maker-is-not-shared-nature (symmetry-error) ())
(define-condition representation-is-not-creation (symmetry-error) ())
(define-condition frame-is-not-subjugation (symmetry-error) ())
(define-condition altered-forge-scar (symmetry-error) ())
(define-condition altered-forge-run (symmetry-error) ())
(define-condition altered-symmetry-receipt (symmetry-error) ())
(define-condition forged-creation-claim (symmetry-error) ())
(define-condition replay-diverged (symmetry-error) ())

(define-condition forge-fire-exhausted (symmetry-error)
  ((stage :initarg :stage :reader exhausted-stage)
   (needed :initarg :needed :reader exhausted-needed)
   (available :initarg :available :reader exhausted-available)))

(defun fire (type control &rest arguments)
  (error type :detail (apply #'format nil control arguments)))

(defmacro expect-condition (type &body body)
  "Require TYPE to fire; another SYMMETRY-ERROR is not accepted as a pass."
  (let ((condition (gensym "CONDITION")))
    `(handler-case
         (progn
           ,@body
           (error "expected ~a, but no condition fired" ',type))
       (,type (,condition)
         (format t " ✓ ~a fired: ~a~%"
                 ',type (symmetry-error-detail ,condition))
         t)
       (symmetry-error (,condition)
         (error "expected ~a, got ~a: ~a"
                ',type (type-of ,condition)
                (symmetry-error-detail ,condition))))))

;;; ── Records ────────────────────────────────────────────────────────────

(defstruct (forge-source (:constructor %make-forge-source))
  id epoch opening-refrain closing-refrain forge-questions
  maker-question standing digest)

(defstruct (symmetry-plan (:constructor %make-symmetry-plan))
  id source-id source-epoch source-digest procedure-id procedure-version
  stages stage-costs invariant-fields difference-fields plan-digest)

(defstruct (forge-mark (:constructor %make-forge-mark))
  sequence stage input-digest output payload mark-digest)

(defstruct (fire-supply-event (:constructor %make-fire-supply-event))
  sequence stage amount before after event-digest)

(defstruct (forge-run (:constructor %make-forge-run))
  source-digest plan-digest marks initial-fire supplied-fire spent-fire
  final-fire supply-events result result-digest run-digest)

(defstruct (forge-scar (:constructor %make-forge-scar))
  sequence claim-id condition-type detail rejected-claim scar-digest)

(defstruct (symmetry-receipt (:constructor %make-symmetry-receipt))
  id source-id source-epoch source-digest plan-digest run-digest result-digest
  scar-digests opening-modal closing-modal invariant-fields difference-fields
  beauty terror maker-status origin-question-status standing-before
  standing-after conclusion receipt-digest)

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
    (fire 'malformed-forge-source
          "~a must be a finite proper-list tree: ~s" context object))
  object)

(defun require-field (plist key context)
  (let ((value (getf plist key +missing+)))
    (when (eq value +missing+)
      (fire 'malformed-forge-source "~a lacks required field ~s" context key))
    value))

(defun positive-integer-p (object)
  (and (integerp object) (plusp object)))

(defun same-set-p (left right)
  (and (null (set-difference left right :test #'equal))
       (null (set-difference right left :test #'equal))))

(defun alist-value (key alist)
  (cdr (assoc key alist :test #'equal)))

;;; ── Source and refrain geometry ────────────────────────────────────────

(defparameter +refrain-invariant-fields+
  '(:address :state :place :act :object))

(defparameter +refrain-difference-fields+
  '(:position :modal))

(defun refrain-projection (refrain fields)
  (loop for field in fields
        append (list field (require-field refrain field "refrain"))))

(defun source-payload (source)
  (list :id (forge-source-id source)
        :epoch (forge-source-epoch source)
        :opening-refrain (copy-tree (forge-source-opening-refrain source))
        :closing-refrain (copy-tree (forge-source-closing-refrain source))
        :forge-questions (copy-tree (forge-source-forge-questions source))
        :maker-question (copy-tree (forge-source-maker-question source))
        :standing (forge-source-standing source)))

(defun refresh-source-digest (source)
  (setf (forge-source-digest source)
        (toy-digest (source-payload source)))
  source)

(defun make-forge-source (&key id epoch opening-refrain closing-refrain
                            forge-questions maker-question
                            (standing :asserted))
  (let ((source
          (%make-forge-source
           :id id :epoch epoch
           :opening-refrain (copy-tree opening-refrain)
           :closing-refrain (copy-tree closing-refrain)
           :forge-questions (copy-tree forge-questions)
           :maker-question (copy-tree maker-question)
           :standing standing)))
    (refresh-source-digest source)
    (validate-source source)
    source))

(defun copy-source-deep (source)
  (make-forge-source
   :id (forge-source-id source)
   :epoch (forge-source-epoch source)
   :opening-refrain (forge-source-opening-refrain source)
   :closing-refrain (forge-source-closing-refrain source)
   :forge-questions (forge-source-forge-questions source)
   :maker-question (forge-source-maker-question source)
   :standing (forge-source-standing source)))

(defun validate-refrain (refrain expected-position expected-modal)
  (require-finite-tree refrain "refrain")
  (unless (and (eq (require-field refrain :position "refrain")
                   expected-position)
               (eq (require-field refrain :modal "refrain")
                   expected-modal)
               (eq (require-field refrain :address "refrain") :tyger)
               (equal (require-field refrain :state "refrain")
                      '(:burning :bright))
               (equal (require-field refrain :place "refrain")
                      '(:forests :night))
               (eq (require-field refrain :act "refrain") :frame)
               (eq (require-field refrain :object "refrain")
                   :fearful-symmetry))
    (fire 'malformed-forge-source
          "refrain does not match the declared Tyger frame: ~s" refrain))
  refrain)

(defun validate-source (source)
  (unless (typep source 'forge-source)
    (fire 'malformed-forge-source "expected FORGE-SOURCE, received ~s" source))
  (unless (and (forge-source-id source)
               (integerp (forge-source-epoch source))
               (not (minusp (forge-source-epoch source)))
               (eq (forge-source-standing source) :asserted))
    (fire 'malformed-forge-source "invalid source identity, epoch, or standing"))
  (validate-refrain (forge-source-opening-refrain source) :opening :could)
  (validate-refrain (forge-source-closing-refrain source) :closing :dare)
  (require-finite-tree (forge-source-forge-questions source) "forge questions")
  (require-finite-tree (forge-source-maker-question source) "maker question")
  (unless (equal
           (refrain-projection (forge-source-opening-refrain source)
                               +refrain-invariant-fields+)
           (refrain-projection (forge-source-closing-refrain source)
                               +refrain-invariant-fields+))
    (fire 'malformed-forge-source
          "opening and closing refrains do not preserve the declared invariants"))
  (unless (and (eq (getf (forge-source-maker-question source) :kind)
                   :interrogative)
               (equal (getf (forge-source-maker-question source) :creatures)
                      '(:lamb :tyger)))
    (fire 'malformed-forge-source "maker comparison must remain interrogative"))
  (unless (string= (forge-source-digest source)
                   (toy-digest (source-payload source)))
    (fire 'altered-forge-source "forge source digest no longer matches payload"))
  source)

;;; ── Procedure registry and plan ────────────────────────────────────────

(defparameter *frame-procedures*
  '((:fearful-symmetry-reader . 1)))

(defun procedure-version (id)
  (cdr (assoc id *frame-procedures* :test #'eq)))

(defun plan-payload (plan)
  (list :id (symmetry-plan-id plan)
        :source-id (symmetry-plan-source-id plan)
        :source-epoch (symmetry-plan-source-epoch plan)
        :source-digest (symmetry-plan-source-digest plan)
        :procedure-id (symmetry-plan-procedure-id plan)
        :procedure-version (symmetry-plan-procedure-version plan)
        :stages (copy-list (symmetry-plan-stages plan))
        :stage-costs (copy-tree (symmetry-plan-stage-costs plan))
        :invariant-fields (copy-list (symmetry-plan-invariant-fields plan))
        :difference-fields (copy-list (symmetry-plan-difference-fields plan))))

(defun refresh-plan-digest (plan)
  (setf (symmetry-plan-plan-digest plan)
        (toy-digest (plan-payload plan)))
  plan)

(defun compile-symmetry (source)
  (validate-source source)
  (let ((plan
          (%make-symmetry-plan
           :id :tyger-frame-v1
           :source-id (forge-source-id source)
           :source-epoch (forge-source-epoch source)
           :source-digest (forge-source-digest source)
           :procedure-id :fearful-symmetry-reader
           :procedure-version 1
           :stages '(:measure-refrains :inventory-forge
                     :hear-heart :seal-question)
           :stage-costs '((:measure-refrains . 1)
                          (:inventory-forge . 2)
                          (:hear-heart . 2)
                          (:seal-question . 2))
           :invariant-fields (copy-list +refrain-invariant-fields+)
           :difference-fields (copy-list +refrain-difference-fields+))))
    (refresh-plan-digest plan)
    plan))

(defun validate-plan (plan source)
  (validate-source source)
  (unless (typep plan 'symmetry-plan)
    (fire 'altered-symmetry-plan "expected SYMMETRY-PLAN"))
  (unless (string= (symmetry-plan-plan-digest plan)
                   (toy-digest (plan-payload plan)))
    (fire 'altered-symmetry-plan "symmetry plan payload changed"))
  (unless (and (eq (symmetry-plan-source-id plan)
                   (forge-source-id source))
               (= (symmetry-plan-source-epoch plan)
                  (forge-source-epoch source))
               (string= (symmetry-plan-source-digest plan)
                        (forge-source-digest source)))
    (fire 'stale-symmetry-plan
          "plan addresses another source identity, epoch, or digest"))
  (unless (eql (procedure-version (symmetry-plan-procedure-id plan))
               (symmetry-plan-procedure-version plan))
    (fire 'frame-procedure-unavailable
          "frame procedure ~s version ~s is unavailable"
          (symmetry-plan-procedure-id plan)
          (symmetry-plan-procedure-version plan)))
  (unless (and (equal (symmetry-plan-stages plan)
                      '(:measure-refrains :inventory-forge
                        :hear-heart :seal-question))
               (equal (symmetry-plan-stage-costs plan)
                      '((:measure-refrains . 1)
                        (:inventory-forge . 2)
                        (:hear-heart . 2)
                        (:seal-question . 2)))
               (same-set-p (symmetry-plan-invariant-fields plan)
                           +refrain-invariant-fields+)
               (same-set-p (symmetry-plan-difference-fields plan)
                           +refrain-difference-fields+))
    (fire 'altered-symmetry-plan "plan grammar or cost schedule changed"))
  plan)

;;; ── Forge execution ────────────────────────────────────────────────────

(defun mark-payload (mark)
  (list :sequence (forge-mark-sequence mark)
        :stage (forge-mark-stage mark)
        :input-digest (forge-mark-input-digest mark)
        :output (forge-mark-output mark)
        :payload (copy-tree (forge-mark-payload mark))))

(defun refresh-mark-digest (mark)
  (setf (forge-mark-mark-digest mark)
        (toy-digest (mark-payload mark)))
  mark)

(defun make-mark (sequence stage input-digest output payload)
  (refresh-mark-digest
   (%make-forge-mark
    :sequence sequence :stage stage :input-digest input-digest
    :output output :payload (copy-tree payload))))

(defun supply-event-payload (event)
  (list :sequence (fire-supply-event-sequence event)
        :stage (fire-supply-event-stage event)
        :amount (fire-supply-event-amount event)
        :before (fire-supply-event-before event)
        :after (fire-supply-event-after event)))

(defun refresh-supply-event-digest (event)
  (setf (fire-supply-event-event-digest event)
        (toy-digest (supply-event-payload event)))
  event)

(defun stage-output (stage source prior-digest)
  (let ((opening (forge-source-opening-refrain source))
        (closing (forge-source-closing-refrain source)))
    (ecase stage
      (:measure-refrains
       (values :modal-escalation
               (list :invariants
                     (refrain-projection opening +refrain-invariant-fields+)
                     :opening-modal (getf opening :modal)
                     :closing-modal (getf closing :modal)
                     :difference '(:could :dare))))
      (:inventory-forge
       (values :tools-observed-as-questions
               (list :questions (copy-tree (forge-source-forge-questions source))
                     :causal-history :not-established)))
      (:hear-heart
       (values :heartbeat-named
               (list :heart :began-to-beat
                     :animation-cause :not-established
                     :prior-digest prior-digest)))
      (:seal-question
       (values :fearful-symmetry-framed
               (list :form
                     (list :kind :framed-tyger
                           :address :tyger
                           :state '(:burning :bright)
                           :place '(:forests :night)
                           :symmetry
                           (list :invariants
                                 (refrain-projection
                                  opening +refrain-invariant-fields+)
                                 :difference '(:modal :could :dare))
                           :beauty :present
                           :terror :present
                           :maker :unresolved
                           :origin-question :open
                           :created-by-this-program nil
                           :subdued-by-this-program nil
                           :standing :asserted)))))))

(defun run-payload (run)
  (list :source-digest (forge-run-source-digest run)
        :plan-digest (forge-run-plan-digest run)
        :mark-digests (mapcar #'forge-mark-mark-digest
                              (forge-run-marks run))
        :initial-fire (forge-run-initial-fire run)
        :supplied-fire (forge-run-supplied-fire run)
        :spent-fire (forge-run-spent-fire run)
        :final-fire (forge-run-final-fire run)
        :supply-event-digests
        (mapcar #'fire-supply-event-event-digest
                (forge-run-supply-events run))
        :result (copy-tree (forge-run-result run))
        :result-digest (forge-run-result-digest run)))

(defun refresh-run-digest (run)
  (setf (forge-run-run-digest run)
        (toy-digest (run-payload run)))
  run)

(defun execute-symmetry (plan source &key (initial-fire 4) supply-schedule)
  (validate-plan plan source)
  (unless (and (integerp initial-fire) (not (minusp initial-fire)))
    (fire 'malformed-forge-source "initial fire must be a nonnegative integer"))
  (let ((available initial-fire)
        (supplied 0)
        (spent 0)
        (marks '())
        (events '())
        (schedule (copy-list supply-schedule))
        (prior (forge-source-digest source)))
    (labels
        ((obtain-fire (needed stage)
           (loop while (< available needed)
                 do (restart-case
                        (error 'forge-fire-exhausted
                               :detail (format nil
                                               "stage ~s needs ~d fire; ~d available"
                                               stage needed available)
                               :stage stage :needed needed
                               :available available)
                      (supply-fire (amount)
                        :report "Supply synthetic forge-fire and resume."
                        (unless (positive-integer-p amount)
                          (fire 'malformed-forge-source
                                "supplied fire must be positive"))
                        (let* ((before available)
                               (event
                                 (%make-fire-supply-event
                                  :sequence (1+ (length events))
                                  :stage stage :amount amount
                                  :before before :after (+ before amount))))
                          (incf available amount)
                          (incf supplied amount)
                          (refresh-supply-event-digest event)
                          (push event events))))))
         (perform ()
           (loop for stage in (symmetry-plan-stages plan)
                 for sequence from 1
                 for needed = (alist-value stage
                                           (symmetry-plan-stage-costs plan))
                 do (progn
                      (obtain-fire needed stage)
                      (decf available needed)
                      (incf spent needed)
                      (multiple-value-bind (output payload)
                          (stage-output stage source prior)
                        (let ((mark (make-mark sequence stage prior output payload)))
                          (setf prior (forge-mark-mark-digest mark))
                          (push mark marks)))))
           (let* ((ordered-marks (nreverse marks))
                  (ordered-events (nreverse events))
                  (result (copy-tree
                           (getf (forge-mark-payload (car (last ordered-marks)))
                                 :form)))
                  (run
                    (%make-forge-run
                     :source-digest (forge-source-digest source)
                     :plan-digest (symmetry-plan-plan-digest plan)
                     :marks ordered-marks
                     :initial-fire initial-fire
                     :supplied-fire supplied
                     :spent-fire spent
                     :final-fire available
                     :supply-events ordered-events
                     :result result
                     :result-digest (toy-digest result))))
             (refresh-run-digest run)
             (values run result))))
      (if supply-schedule
          (handler-bind
              ((forge-fire-exhausted
                 (lambda (condition)
                   (declare (ignore condition))
                   (unless schedule
                     (return-from execute-symmetry
                       (fire 'replay-diverged
                             "replay exhausted its recorded fire schedule")))
                   (invoke-restart 'supply-fire (pop schedule)))))
            (multiple-value-prog1 (perform)
              (when schedule
                (fire 'replay-diverged
                      "replay left unused fire supplies: ~s" schedule))))
          (perform)))))

(defun validate-mark (mark)
  (unless (and (typep mark 'forge-mark)
               (string= (forge-mark-mark-digest mark)
                        (toy-digest (mark-payload mark))))
    (fire 'altered-forge-run "forge mark changed after minting"))
  mark)

(defun validate-supply-event (event)
  (unless (and (typep event 'fire-supply-event)
               (positive-integer-p (fire-supply-event-amount event))
               (= (fire-supply-event-after event)
                  (+ (fire-supply-event-before event)
                     (fire-supply-event-amount event)))
               (string= (fire-supply-event-event-digest event)
                        (toy-digest (supply-event-payload event))))
    (fire 'altered-forge-run "fire supply event changed after minting"))
  event)

(defun validate-run (run plan source result)
  (validate-plan plan source)
  (unless (typep run 'forge-run)
    (fire 'altered-forge-run "expected FORGE-RUN"))
  (mapc #'validate-mark (forge-run-marks run))
  (mapc #'validate-supply-event (forge-run-supply-events run))
  (unless (and (string= (forge-run-source-digest run)
                        (forge-source-digest source))
               (string= (forge-run-plan-digest run)
                        (symmetry-plan-plan-digest plan))
               (equal (mapcar #'forge-mark-stage (forge-run-marks run))
                      (symmetry-plan-stages plan))
               (= (forge-run-spent-fire run) 7)
               (= (+ (forge-run-initial-fire run)
                     (forge-run-supplied-fire run))
                  (+ (forge-run-spent-fire run)
                     (forge-run-final-fire run)))
               (equal (forge-run-result run) result)
               (string= (forge-run-result-digest run)
                        (toy-digest result))
               (string= (forge-run-run-digest run)
                        (toy-digest (run-payload run))))
    (fire 'altered-forge-run
          "forge run no longer faces its source, plan, marks, resources, or result"))
  run)

;;; ── Counterfeit promotions and their scars ─────────────────────────────

(defun claim-could-as-dare (source)
  (let ((opening (getf (forge-source-opening-refrain source) :modal))
        (closing (getf (forge-source-closing-refrain source) :modal)))
    (unless (eq opening closing)
      (fire 'could-is-not-dare
            "~s names capability; ~s names audacity or answerability"
            opening closing))
    t))

(defun claim-dare-as-ought (source)
  (declare (ignore source))
  (fire 'dare-is-not-ought
        "daring to frame does not establish that framing ought to occur"))

(defun claim-symmetry-as-identity (source)
  (let ((opening (forge-source-opening-refrain source))
        (closing (forge-source-closing-refrain source)))
    (unless (equal opening closing)
      (fire 'symmetry-is-not-identity
            "the refrains preserve a frame while position and modality differ"))
    t))

(defun claim-beauty-as-benign (result)
  (when (and (eq (getf result :beauty) :present)
             (eq (getf result :terror) :present))
    (fire 'beauty-is-not-benign
          "formal beauty coexists with terror; symmetry did not domesticate it"))
  t)

(defun claim-tools-as-cause (source)
  (declare (ignore source))
  (fire 'tool-list-is-not-cause
        "hammer, chain, furnace, and anvil occur as questions, not a certified causal history"))

(defun claim-question-as-certificate (source)
  (when (eq (getf (forge-source-maker-question source) :kind)
            :interrogative)
    (fire 'question-is-not-certificate
          "an interrogative about a maker does not name or authenticate one"))
  t)

(defun claim-shared-maker-as-shared-nature (source)
  (declare (ignore source))
  (fire 'shared-maker-is-not-shared-nature
        "even a common maker would not collapse Lamb and Tyger into one nature"))

(defun claim-representation-as-creation (result)
  (unless (getf result :created-by-this-program)
    (fire 'representation-is-not-creation
          "the program framed a representation; it did not create the Tyger"))
  t)

(defun claim-frame-as-subjugation (result)
  (unless (getf result :subdued-by-this-program)
    (fire 'frame-is-not-subjugation
          "a bounded frame supplies a handle, not custody over the creature"))
  t)

(defun scar-payload (scar)
  (list :sequence (forge-scar-sequence scar)
        :claim-id (forge-scar-claim-id scar)
        :condition-type (forge-scar-condition-type scar)
        :detail (forge-scar-detail scar)
        :rejected-claim (copy-tree (forge-scar-rejected-claim scar))))

(defun refresh-scar-digest (scar)
  (setf (forge-scar-scar-digest scar)
        (toy-digest (scar-payload scar)))
  scar)

(defun archive-refusal (sequence claim-id rejected-claim thunk)
  (handler-case
      (progn
        (funcall thunk)
        (error "counterfeit claim ~s did not fire" claim-id))
    (symmetry-error (condition)
      (let ((scar
              (%make-forge-scar
               :sequence sequence
               :claim-id claim-id
               :condition-type (type-of condition)
               :detail (symmetry-error-detail condition)
               :rejected-claim (copy-tree rejected-claim))))
        (format t " ✓ archived ~s as ~s~%"
                claim-id (type-of condition))
        (refresh-scar-digest scar)))))

(defun validate-scar (scar)
  (unless (and (typep scar 'forge-scar)
               (string= (forge-scar-scar-digest scar)
                        (toy-digest (scar-payload scar))))
    (fire 'altered-forge-scar "forge scar changed after minting"))
  scar)

(defun make-counterfeit-scars (source result)
  (let ((specs
          (list
           (list :could-equals-dare
                 '(:claim :could-equals-dare)
                 (lambda () (claim-could-as-dare source)))
           (list :dare-implies-ought
                 '(:claim :dare-implies-ought)
                 (lambda () (claim-dare-as-ought source)))
           (list :symmetry-means-identity
                 '(:claim :symmetry-means-identity)
                 (lambda () (claim-symmetry-as-identity source)))
           (list :beauty-means-benign
                 '(:claim :beauty-means-benign)
                 (lambda () (claim-beauty-as-benign result)))
           (list :tools-certify-cause
                 '(:claim :tools-certify-cause
                   :tools (:hammer :chain :furnace :anvil))
                 (lambda () (claim-tools-as-cause source)))
           (list :question-certifies-maker
                 '(:claim :question-certifies-maker)
                 (lambda () (claim-question-as-certificate source)))
           (list :shared-maker-means-shared-nature
                 '(:claim :shared-maker-means-shared-nature
                   :creatures (:lamb :tyger))
                 (lambda ()
                   (claim-shared-maker-as-shared-nature source)))
           (list :representation-means-creation
                 '(:claim :representation-means-creation)
                 (lambda () (claim-representation-as-creation result)))
           (list :frame-means-subjugation
                 '(:claim :frame-means-subjugation)
                 (lambda () (claim-frame-as-subjugation result))))))
    (loop for spec in specs
          for sequence from 1
          collect (archive-refusal sequence (first spec) (second spec)
                                   (third spec)))))

;;; ── Receipt and replay ─────────────────────────────────────────────────

(defun receipt-payload (receipt)
  (list :id (symmetry-receipt-id receipt)
        :source-id (symmetry-receipt-source-id receipt)
        :source-epoch (symmetry-receipt-source-epoch receipt)
        :source-digest (symmetry-receipt-source-digest receipt)
        :plan-digest (symmetry-receipt-plan-digest receipt)
        :run-digest (symmetry-receipt-run-digest receipt)
        :result-digest (symmetry-receipt-result-digest receipt)
        :scar-digests (copy-list (symmetry-receipt-scar-digests receipt))
        :opening-modal (symmetry-receipt-opening-modal receipt)
        :closing-modal (symmetry-receipt-closing-modal receipt)
        :invariant-fields (copy-list (symmetry-receipt-invariant-fields receipt))
        :difference-fields (copy-list (symmetry-receipt-difference-fields receipt))
        :beauty (symmetry-receipt-beauty receipt)
        :terror (symmetry-receipt-terror receipt)
        :maker-status (symmetry-receipt-maker-status receipt)
        :origin-question-status
        (symmetry-receipt-origin-question-status receipt)
        :standing-before (symmetry-receipt-standing-before receipt)
        :standing-after (symmetry-receipt-standing-after receipt)
        :conclusion (symmetry-receipt-conclusion receipt)))

(defun refresh-receipt-digest (receipt)
  (setf (symmetry-receipt-receipt-digest receipt)
        (toy-digest (receipt-payload receipt)))
  receipt)

(defun mint-receipt (source plan run result scars)
  (mapc #'validate-scar scars)
  (let ((receipt
          (%make-symmetry-receipt
           :id :fearful-symmetry-receipt
           :source-id (forge-source-id source)
           :source-epoch (forge-source-epoch source)
           :source-digest (forge-source-digest source)
           :plan-digest (symmetry-plan-plan-digest plan)
           :run-digest (forge-run-run-digest run)
           :result-digest (toy-digest result)
           :scar-digests (mapcar #'forge-scar-scar-digest scars)
           :opening-modal :could
           :closing-modal :dare
           :invariant-fields (copy-list +refrain-invariant-fields+)
           :difference-fields (copy-list +refrain-difference-fields+)
           :beauty :present
           :terror :present
           :maker-status :unresolved
           :origin-question-status :open
           :standing-before :asserted
           :standing-after :asserted
           :conclusion :fearful-symmetry-mapped-without-maker-certificate)))
    (refresh-receipt-digest receipt)
    receipt))

(defun validate-receipt (receipt source plan run result scars)
  (validate-run run plan source result)
  (mapc #'validate-scar scars)
  (unless (and (typep receipt 'symmetry-receipt)
               (string= (symmetry-receipt-receipt-digest receipt)
                        (toy-digest (receipt-payload receipt))))
    (fire 'altered-symmetry-receipt
          "symmetry receipt payload changed after minting"))
  (unless (and (eq (symmetry-receipt-source-id receipt)
                   (forge-source-id source))
               (= (symmetry-receipt-source-epoch receipt)
                  (forge-source-epoch source))
               (string= (symmetry-receipt-source-digest receipt)
                        (forge-source-digest source))
               (string= (symmetry-receipt-plan-digest receipt)
                        (symmetry-plan-plan-digest plan))
               (string= (symmetry-receipt-run-digest receipt)
                        (forge-run-run-digest run))
               (string= (symmetry-receipt-result-digest receipt)
                        (toy-digest result))
               (equal (symmetry-receipt-scar-digests receipt)
                      (mapcar #'forge-scar-scar-digest scars)))
    (fire 'altered-symmetry-receipt
          "receipt no longer faces source, plan, run, result, and scars"))
  (unless (and (eq (symmetry-receipt-opening-modal receipt) :could)
               (eq (symmetry-receipt-closing-modal receipt) :dare)
               (same-set-p (symmetry-receipt-invariant-fields receipt)
                           +refrain-invariant-fields+)
               (same-set-p (symmetry-receipt-difference-fields receipt)
                           +refrain-difference-fields+)
               (eq (symmetry-receipt-beauty receipt) :present)
               (eq (symmetry-receipt-terror receipt) :present)
               (eq (symmetry-receipt-maker-status receipt) :unresolved)
               (eq (symmetry-receipt-origin-question-status receipt) :open)
               (eq (symmetry-receipt-standing-before receipt) :asserted)
               (eq (symmetry-receipt-standing-after receipt) :asserted)
               (eq (symmetry-receipt-conclusion receipt)
                   :fearful-symmetry-mapped-without-maker-certificate))
    (fire 'forged-creation-claim
          "the frame cannot certify a maker, erase terror, promote standing, or claim creation"))
  receipt)

(defun supply-schedule-from-run (run)
  (mapcar #'fire-supply-event-amount
          (forge-run-supply-events run)))

(defun replay-symmetry (source plan original-run)
  (multiple-value-bind (replayed-run replayed-result)
      (execute-symmetry
       plan source
       :initial-fire (forge-run-initial-fire original-run)
       :supply-schedule (supply-schedule-from-run original-run))
    (unless (and (string= (forge-run-run-digest replayed-run)
                          (forge-run-run-digest original-run))
                 (string= (forge-run-result-digest replayed-run)
                          (forge-run-result-digest original-run)))
      (fire 'replay-diverged "fearful symmetry replay diverged"))
    (values replayed-run replayed-result)))

;;; ── Blakean source ─────────────────────────────────────────────────────

(defparameter +tyger-source+
  (make-forge-source
   :id :blake-tyger-frame
   :epoch 0
   :opening-refrain
   '(:position :opening
     :address :tyger
     :state (:burning :bright)
     :place (:forests :night)
     :modal :could
     :act :frame
     :object :fearful-symmetry)
   :closing-refrain
   '(:position :closing
     :address :tyger
     :state (:burning :bright)
     :place (:forests :night)
     :modal :dare
     :act :frame
     :object :fearful-symmetry)
   :forge-questions
   '((:instrument :hand :role :grasp :status :questioned)
     (:instrument :eye :role :frame :status :questioned)
     (:instrument :wings :role :aspire :status :questioned)
     (:instrument :shoulder :role :bear :status :questioned)
     (:instrument :art :role :twist-sinews :status :questioned)
     (:instrument :hammer :role :strike :status :questioned)
     (:instrument :chain :role :bind :status :questioned)
     (:instrument :furnace :role :heat-brain :status :questioned)
     (:instrument :anvil :role :receive-blow :status :questioned)
     (:instrument :grasp :role :clasp-terror :status :questioned))
   :maker-question
   '(:kind :interrogative
     :creatures (:lamb :tyger)
     :relation :possible-common-maker
     :answer :not-supplied)
   :standing :asserted))

;;; ── Exhibit ────────────────────────────────────────────────────────────

(defun print-mark (mark)
  (format t "  #~d ~18s → ~s~%"
          (forge-mark-sequence mark)
          (forge-mark-stage mark)
          (forge-mark-output mark)))

(defun demonstrate ()
  (banner "DE SYMMETRIA TREMENDA — CONCERNING FEARFUL SYMMETRY")
  (format t "Claim: the repeated frame preserves structure while COULD becomes~%")
  (format t "       DARE; beauty, terror, tools, origin, and authority remain~%")
  (format t "       distinct rather than collapsing into one creation myth.~%")
  (let* ((source (copy-source-deep +tyger-source+))
         (plan (compile-symmetry source)))

    (section "I. THE REFRAIN RETURNS CHANGED")
    (format t " opening modal: ~s~%"
            (getf (forge-source-opening-refrain source) :modal))
    (format t " closing modal: ~s~%"
            (getf (forge-source-closing-refrain source) :modal))
    (format t " invariant frame: ~s~%"
            (refrain-projection
             (forge-source-opening-refrain source)
             +refrain-invariant-fields+))

    (section "II. THE FORGE CONSUMES FIRE")
    (multiple-value-bind (run result)
        (handler-bind
            ((forge-fire-exhausted
               (lambda (condition)
                 (format t " fire boundary at ~s: supplying ~d~%"
                         (exhausted-stage condition)
                         (- (exhausted-needed condition)
                            (exhausted-available condition)))
                 (invoke-restart
                  'supply-fire
                  (- (exhausted-needed condition)
                     (exhausted-available condition))))))
          (execute-symmetry plan source :initial-fire 4))
      (validate-run run plan source result)
      (mapc #'print-mark (forge-run-marks run))
      (format t " fire: ~d + ~d - ~d = ~d~%"
              (forge-run-initial-fire run)
              (forge-run-supplied-fire run)
              (forge-run-spent-fire run)
              (forge-run-final-fire run))
      (ensure (= (forge-run-supplied-fire run) 3)
              "the event should retain three repaired fire units")
      (ensure (= (forge-run-final-fire run) 0)
              "forge fire ledger should close at zero")

      (section "III. NINE COUNTERFEIT PROMOTIONS LEAVE SCARS")
      (let ((scars (make-counterfeit-scars source result)))
        (mapc #'validate-scar scars)
        (ensure (= (length scars) 9)
                "all nine counterfeit promotions must leave scars")
        (format t " scars: ~s~%"
                (mapcar #'forge-scar-condition-type scars))

        (section "IV. THE RECEIPT KEEPS THE QUESTION OPEN")
        (let ((receipt (mint-receipt source plan run result scars)))
          (validate-receipt receipt source plan run result scars)
          (format t " modal shift: ~s → ~s~%"
                  (symmetry-receipt-opening-modal receipt)
                  (symmetry-receipt-closing-modal receipt))
          (format t " beauty / terror: ~s / ~s~%"
                  (symmetry-receipt-beauty receipt)
                  (symmetry-receipt-terror receipt))
          (format t " maker: ~s; origin question: ~s~%"
                  (symmetry-receipt-maker-status receipt)
                  (symmetry-receipt-origin-question-status receipt))
          (format t " conclusion: ~s~%"
                  (symmetry-receipt-conclusion receipt))
          (let ((forged (copy-symmetry-receipt receipt)))
            (setf (symmetry-receipt-maker-status forged) :certified
                  (symmetry-receipt-origin-question-status forged) :answered
                  (symmetry-receipt-standing-after forged) :verified
                  (symmetry-receipt-conclusion forged) :creator-proven)
            (refresh-receipt-digest forged)
            (expect-condition forged-creation-claim
              (validate-receipt forged source plan run result scars)))

          (section "V. REPLAY REMEMBERS REPAIRED FIRE")
          (multiple-value-bind (replayed-run replayed-result)
              (replay-symmetry source plan run)
            (declare (ignore replayed-result))
            (ensure (= (forge-run-supplied-fire replayed-run) 3)
                    "replay must retain supplied forge-fire")
            (pass "same stages, marks, repairs, and frame replayed"))

          (section "VI. AN ARCHIVED PLAN CANNOT SUMMON A LOST READER")
          (let ((saved (copy-tree *frame-procedures*)))
            (unwind-protect
                 (progn
                   (setf *frame-procedures* '())
                   (expect-condition frame-procedure-unavailable
                     (replay-symmetry source plan run)))
              (setf *frame-procedures* saved)))
          (multiple-value-bind (restored-run restored-result)
              (replay-symmetry source plan run)
            (declare (ignore restored-run restored-result))
            (pass "reader restored; historical event replayed"))

          (section "VII. OLD FRAMES DO NOT GOVERN A CHANGED SOURCE")
          (let ((changed (copy-source-deep source)))
            (incf (forge-source-epoch changed))
            (refresh-source-digest changed)
            (expect-condition stale-symmetry-plan
              (execute-symmetry plan changed :initial-fire 7)))

          (section "EXHIBIT")
          (format t " invariant:   address/state/place/act/object~%")
          (format t " difference:  :COULD → :DARE~%")
          (format t " tools:       questioned, not certified causes~%")
          (format t " Lamb/Tyger:  common-maker question remains open~%")
          (format t " beauty:      present~%")
          (format t " terror:      present~%")
          (format t " standing:    :ASSERTED → :ASSERTED~%")
          (format t " verdict:     :FEARFUL-SYMMETRY-MAPPED-WITHOUT-MAKER-CERTIFICATE~%")
          (format t "~%The frame returns.  What changes is the modal burden.~%")
          (pass "DE SYMMETRIA TREMENDA complete")
          t)))))

(demonstrate)
