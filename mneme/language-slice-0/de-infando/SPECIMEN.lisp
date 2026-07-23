;;;; SPECIMEN.lisp — de-infando: what can exist, act, and warrant locally
;;;; without becoming an object that may be carried away.
;;;;
;;;; Third and last official Slice /0 specimen, under the R3 ceiling: no
;;;; hostile custody, no secrecy claim against same-image introspection.
;;;; The subject: a non-reifiable closure over local state — locally
;;;; existing, locally exercisable, locally warrant-bearing, and refused by
;;;; the governed direct-export path with every lawful alternative receipted.
;;;;
;;;; Run: sbcl --non-interactive --load SPECIMEN.lisp   (exit 0 = all pass)

(load (merge-pathnames "../slice0-transmissibility.lisp" *load-truename*))

(defpackage #:de-infando
  (:use #:cl #:lisp-plus-slice0)
  (:import-from #:lisp-plus-kernel0
                #:make-identity #:make-procedure-descriptor #:identity=))
(in-package #:de-infando)

(defvar *pass* 0)
(defvar *fail* 0)
(defun check (name ok &optional detail)
  (if ok (incf *pass*) (incf *fail*))
  (format t "~&~:[FAIL~;pass~] ~a~@[ — ~a~]~%" ok name (unless ok detail)))

;;; ------------------------------------------------------------------
;;; The closure: a capability-gate checker over local state.  It exists
;;; and executes HERE; its results are canonical; it itself is not.

(defparameter *gate-closure*
  (let ((threshold 3) (calls 0))
    (lambda (probe)
      (incf calls)
      (list :gate-check :prod
            (if (>= probe threshold) :held :failed)
            :call calls))))

(defparameter *gate*
  (local-value :host *gate-closure*
               :authority :operator
               :exercise-authorized '(:source-lab :ops-desk)
               :recipe '(:rebuild (:kind :gate-checker)
                         (:threshold-source (:config :prod-gate))
                         (:probe-protocol (:ge :threshold)))
               :purpose '(:gate-keeping :prod)))

(defparameter *plain-config*     ; the negative-control subject: plain data
  (local-value :host '(:config :prod-gate :v 2) :authority :operator))

;;; Positions.

(defun semantic-procedure (name admits)
  (promotion-procedure
   :descriptor (make-procedure-descriptor
                :procedure-id (make-identity :procedure name)
                :version 0 :judgment-class :semantic
                :input-domain '(:kinds (:subject-answer))
                :result-vocabulary '(:accepted :rejected)
                :evidence-requirements '())
   :admits admits))

(defparameter *gate-verification*
  (semantic-procedure "gate-verification" '((:direct :capability-check))))

(defparameter *source-lab*
  (receiver-context :context-id :source-lab
                    :executable-procedures (list *gate-verification*)
                    :recognized-authorities '(:operator :prod-auditor)
                    :accepted-representations '(:canonical-datum)))
(defparameter *ops-desk*
  (receiver-context :context-id :ops-desk
                    :recognized-authorities '(:operator)
                    :accepted-representations '(:canonical-datum)))
(defparameter *remote-a*
  (receiver-context :context-id :remote-a
                    :executable-procedures (list *gate-verification*)
                    :recognized-authorities '(:prod-auditor)
                    :accepted-representations '(:canonical-datum)))
(defparameter *remote-b*     ; accepts only envelopes this slice can't make
  (receiver-context :context-id :remote-b
                    :recognized-authorities '(:operator)
                    :accepted-representations '(:signed-envelope)))
(defparameter *outsider*
  (receiver-context :context-id :outsider
                    :recognized-authorities '()
                    :accepted-representations '(:canonical-datum)))

;;; ==================================================================
;;; TEETH — planted defects; every gate must FIRE.

;; teeth-1: silent closure stringification — the printed form is a string
;; and may not claim to be the closure.
(handler-case
    (progn (local-value :host (format nil "~a" *gate-closure*)
                        :kind :closure :authority :operator)
           (check "teeth-1 stringified closure cannot claim :closure" nil
                  "constructor accepted the lie"))
  (malformed-slice0-shape (c)
    (check "teeth-1 stringified closure cannot claim :closure"
           (eq (slice0-condition-requirement-id c)
               :kind-is-computed-not-claimed))))

;; teeth-3: invocation testimony flattened to first order is unrepresentable.
(handler-case
    (progn (witness :for '(:exercised :gate) :mode :testimony :kind :report
                    :source :operator :content "I ran it")
           (check "teeth-3 flattened invocation testimony unrepresentable" nil
                  "constructor accepted it"))
  (malformed-slice0-shape (c)
    (check "teeth-3 flattened invocation testimony unrepresentable"
           (eq (slice0-condition-requirement-id c)
               :testimony-preserves-proposition-level))))

;; teeth-6: local standing cannot be copied onto a claim at construction.
(handler-case
    (progn (claim :proposition '(:gate-holds :prod) :by :me
                  :judgment :verified)
           (check "teeth-6 standing cannot be copy-constructed" nil))
  (error () (check "teeth-6 standing cannot be copy-constructed" t)))

;;; ==================================================================
;;; I1 — locally executable is not thereby canonical or transmissible.

(multiple-value-bind (dr minted)
    (exercise-value *gate* :in *source-lab* :args '(5)
                    :mint-for '(:gate-holds :prod))
  (declare (ignorable minted))
  (defparameter *dr* dr)
  (defparameter *w-gate*
    ;; strong local support, declared non-transmissible (I3's subject)
    (witness :for '(:gate-holds :prod) :mode :direct :kind :capability-check
             :source :operator :content (derived-result-value dr)
             :transmissible nil))
  (check "I1a the closure exercises locally (canonical product)"
         (and (derived-result-p dr)
              (equal (derived-result-value dr)
                     '(:gate-check :prod :held :call 1))))
  (check "I1b ...and is not reifiable"
         (not (reifiable-p *gate-closure*))))

(defparameter *refusal-receipt* nil)

(handler-case
    (transmit *gate* :from *source-lab* :to *remote-a* :mode :direct
              :derived (list *dr*))
  (value-not-reifiable (c)
    (setf *refusal-receipt* (slice0-condition-receipt c))
    (check "I1c governed direct export refuses the closure"
           (and (eq (slice0-condition-requirement-id c) :reifiability)
                (transmission-receipt-p *refusal-receipt*)
                (eq (transmission-receipt-decision *refusal-receipt*)
                    :refused)))))

;;; I11 — consequences compose on ONE receipt: refused-direct, yet
;;; testimony, derived export, reproduction, and local exercise all offer.

(check "I11 five views compose on the refusal receipt"
       (subsetp '(:direct-export-refused :testimony-available
                  :derived-result-exportable :receiver-reproduction-available
                  :local-exercise-only)
                (transmission-views *refusal-receipt*)))

;;; teeth-4 — inaccessible is NOT absent: the refusal receipt itself holds
;;; the subject, its exercise options, and its alternatives.
(check "teeth-4 refusal represents the value; nothing becomes absent"
       (and (eq (transmission-receipt-subject *refusal-receipt*) *gate*)
            (transmission-receipt-exercise-options *refusal-receipt*)
            (transmission-receipt-reproduction-options *refusal-receipt*)))

;;; teeth-5 — the refusal is scoped, never permanent-impossibility...
(check "teeth-5a blocker carries its scope (:mode :direct, object-local)"
       (let ((b (find :reifiability
                      (transmission-receipt-blockers *refusal-receipt*)
                      :key #'first)))
         (and b (equal (getf (cddr b) :scope)
                       '(:mode :direct :object-local t)))))

;;; I2 — refusal erases nothing local: exercise still works, and the local
;;; claim verifies on the closure-minted support.

(multiple-value-bind (dr2 w2) (exercise-value *gate* :in *source-lab* :args '(9))
  (declare (ignore w2))
  (check "I2a the closure still exercises after refusal"
         (equal (derived-result-value dr2) '(:gate-check :prod :held :call 2))))

(defparameter *local-gate-claim*
  (multiple-value-bind (v r)
      (raise (claim :proposition '(:gate-holds :prod) :by :operator)
             :to :verified :per *gate-verification*
             :considering (list *w-gate*))
    (declare (ignore r)) v))

;;; I3 — strong local support, zero direct transmissibility — and the
;;; witness refusal rides a DIFFERENT axis than the closure's.

(check "I3a locally verified on the non-transmissible witness"
       (eq (judgment-record-judgment (claim-judgment *local-gate-claim*))
           :verified))

(handler-case
    (transmit *w-gate* :from *source-lab* :to *remote-a* :mode :direct)
  (direct-transmission-impossible (c)
    (check "I3b witness refusal names :transmissibility (declared axis)"
           (eq (slice0-condition-requirement-id c) :transmissibility))))

;;; I4 — the canonical product travels though its producer cannot.

(multiple-value-bind (payload receipt)
    (transmit *dr* :from *source-lab* :to *remote-a* :mode :direct)
  (check "I4 derived result exports; producer explicitly not included"
         (and (eq payload *dr*)
              (eq (transmission-receipt-decision receipt) :granted)
              (assoc :producer-not-included
                     (transmission-receipt-obligations receipt)))))

;;; I5 — testimony about invocation is second-order, never the invocation.

(multiple-value-bind (attribution receipt)
    (transmit *gate* :from *source-lab* :to *remote-a* :mode :testimony)
  (check "I5 testimony transmits the attribution proposition"
         (and (claim-p attribution)
              (eq (first (claim-proposition attribution)) :asserted)
              (eq (transmission-receipt-decision receipt) :granted)
              (assoc :second-order-only
                     (transmission-receipt-obligations receipt))
              ;; and it is NOT the proposition the gate supports
              (not (equal (claim-proposition attribution)
                          '(:gate-holds :prod))))))

;;; I6/I7 — receiver-local reproduction: equivalent support without the
;;; original object; "cannot travel" does not become "unsupportable there".

(multiple-value-bind (w-remote receipt)
    (handler-bind ((value-not-reifiable
                     (lambda (c)
                       (invoke-restart 'mint-equivalent-support-at-receiver
                                       (witness :for '(:gate-holds :prod)
                                                :mode :direct
                                                :kind :capability-check
                                                :source :prod-auditor
                                                :content '(:fresh-remote-check :held))
                                       (slice0-condition-receipt c)))))
      (transmit *gate* :from *source-lab* :to *remote-a* :mode :direct))
  (check "I6 equivalent support minted at receiver via lawful repair"
         (and (witness-p w-remote)
              (eq (transmission-receipt-decision receipt) :refused)))
  (multiple-value-bind (v r)
      (raise (claim :proposition '(:gate-holds :prod) :by :prod-auditor)
             :to :verified :per *gate-verification*
             :considering (list w-remote) :receiver :remote-a)
    (declare (ignore r))
    (check "I7 the proposition verifies at the receiver — muteness was local"
           (and (eq (judgment-record-judgment (claim-judgment v)) :verified)
                (eq (judgment-record-receiver (claim-judgment v)) :remote-a)))))

;;; teeth-5b — ...and a different lawful mode GRANTS (non-permanence).

(multiple-value-bind (recipe receipt)
    (transmit *gate* :from *source-lab* :to *remote-a* :mode :reproduction)
  (check "teeth-5b reproduction mode grants after direct refused"
         (and (equal recipe (local-value-recipe *gate*))
              (eq (transmission-receipt-decision receipt) :granted)
              (assoc :equivalence-not-identity
                     (transmission-receipt-obligations receipt)))))

;;; I8 — representation rejection is contextual to the receiver.

(handler-case
    (transmit *dr* :from *source-lab* :to *remote-b* :mode :direct)
  (receiver-representation-unsupported (c)
    (check "I8 representation refusal names the context"
           (let ((b (find :representation
                          (transmission-receipt-blockers
                           (slice0-condition-receipt c))
                          :key #'first)))
             (and (eq (slice0-condition-requirement-id c) :representation)
                  b (eq (getf (cddr b) :in-context) :remote-b))))))
;; (the same subject was GRANTED at remote-a in I4 — contextual, proven.)

;;; I9 — governed exercise grants use, never possession.

(multiple-value-bind (dr3 w3) (exercise-value *gate* :in *ops-desk* :args '(1))
  (declare (ignore w3))
  (check "I9a authorized position exercises; result is data, not the closure"
         (and (equal (derived-result-value dr3)
                     '(:gate-check :prod :failed :call 3))
              (not (functionp (derived-result-value dr3))))))

(handler-case
    (exercise-value *gate* :in *outsider* :args '(5))
  (exercise-not-authorized (c)
    (check "I9b unauthorized position refused; axis :exercise"
           (eq (slice0-condition-requirement-id c) :exercise))))

(check "I9c the public surface exports no host-object accessor"
       ;; post-hardening: the public-named accessor does not exist at all,
       ;; and the internal one is not exported.
       (multiple-value-bind (sym status)
           (find-symbol "LOCAL-VALUE-HOST-OBJECT" :lisp-plus-slice0)
         (and (or (null sym) (not (fboundp sym)))
              (multiple-value-bind (isym istatus)
                  (find-symbol "%LOCAL-VALUE-HOST-OBJECT" :lisp-plus-slice0)
                (and isym (not (eq istatus :external)))))))

;;; teeth-7 (from the IANUS audit, finding 3 — fixed then teethed): NCONC
;;; onto the accessor-returned authorization list must NOT mint access; the
;;; public accessors return defensive copies.
(let ((grabbed (local-value-exercise-authorized *gate*)))
  (nconc grabbed (list :outsider))          ; the audit's attack, replayed
  (handler-case
      (progn (exercise-value *gate* :in *outsider* :args '(5))
             (check "teeth-7 nconc on returned auth list mints nothing" nil
                    "unauthorized exercise succeeded after nconc"))
    (exercise-not-authorized (c)
      (declare (ignore c))
      (check "teeth-7 nconc on returned auth list mints nothing" t))))

;;; teeth-2 — a transmission receipt is a RECORD, not live authority.

(handler-case
    (progn (raise (claim :proposition '(:gate-holds :prod) :by :me)
                  :to :verified :per *refusal-receipt*
                  :considering (list *w-gate*))
           (check "teeth-2 a receipt is not a procedure" nil "raise accepted it"))
  (malformed-slice0-shape (c)
    (declare (ignore c))
    (check "teeth-2 a receipt is not a procedure" t)))

;;; I12 — every refusal named its exact axis (collected across the run).

(defparameter *axes-seen* '())
(dolist (probe (list
                (cons :reifiability
                      (lambda () (transmit *gate* :from *source-lab*
                                           :to *remote-a* :mode :direct)))
                (cons :transmissibility
                      (lambda () (transmit *w-gate* :from *source-lab*
                                           :to *remote-a* :mode :direct)))
                (cons :representation
                      (lambda () (transmit *dr* :from *source-lab*
                                           :to *remote-b* :mode :direct)))
                (cons :exercise
                      (lambda () (exercise-value *gate* :in *outsider*
                                                 :args '(5))))
                (cons :reproduction
                      (lambda () (transmit *plain-config* :from *source-lab*
                                           :to *remote-a* :mode :reproduction)))))
  (handler-case (funcall (cdr probe))
    (slice0-condition (c)
      (when (eq (slice0-condition-requirement-id c) (car probe))
        (push (car probe) *axes-seen*)))))
(check "I12 refusals name their axes: reifiability/transmissibility/representation/exercise/reproduction"
       (null (set-difference '(:reifiability :transmissibility :representation
                               :exercise :reproduction)
                             *axes-seen*)))

;;; I10 — the original value, support, and claim are immutable throughout.

(check "I10 value, support, and claim unchanged by every attempt"
       (and (eq (local-value-kind *gate*) :closure)
            (equal (local-value-exercise-authorized *gate*)
                   '(:source-lab :ops-desk))
            (null (witness-transmissible *w-gate*))
            (eq (judgment-record-judgment (claim-judgment *local-gate-claim*))
                :verified)))

;;; ==================================================================
;;; Lawful repairs — each a DIFFERENT lawful act, never a relabel.

(multiple-value-bind (payload receipt)
    (handler-bind ((value-not-reifiable
                     (lambda (c) (declare (ignore c))
                       (invoke-restart 'export-derived-result *dr*))))
      (transmit *gate* :from *source-lab* :to *remote-a* :mode :direct))
  (check "repair: export-derived-result yields a GRANT for the product"
         (and (eq payload *dr*)
              (eq (transmission-receipt-decision receipt) :granted)
              (eq (transmission-receipt-subject receipt) *dr*)))) ; not the gate

(multiple-value-bind (attribution receipt)
    (handler-bind ((value-not-reifiable
                     (lambda (c)
                       (invoke-restart 'construct-testimony-claim
                                       (slice0-condition-receipt c)))))
      (transmit *gate* :from *source-lab* :to *remote-a* :mode :direct))
  (check "repair: construct-testimony-claim keeps the refusal receipt"
         (and (claim-p attribution)
              (eq (transmission-receipt-decision receipt) :refused))))

(multiple-value-bind (dr4 receipt)
    (handler-bind ((value-not-reifiable
                     (lambda (c)
                       (invoke-restart 'exercise-locally *source-lab* '(7)
                                       (slice0-condition-receipt c)))))
      (transmit *gate* :from *source-lab* :to *remote-a* :mode :direct))
  (check "repair: exercise-locally is use, not transmission"
         (and (derived-result-p dr4)
              (eq (transmission-receipt-decision receipt) :refused))))

(multiple-value-bind (nothing receipt)
    (handler-bind ((value-not-reifiable
                     (lambda (c)
                       (invoke-restart 'defer-transmission
                                       (slice0-condition-receipt c)))))
      (transmit *gate* :from *source-lab* :to *remote-a* :mode :direct))
  (check "repair: defer-transmission returns only the record"
         (and (null nothing)
              (eq (transmission-receipt-decision receipt) :refused))))

;;; ==================================================================
;;; NEGATIVE CONTROL — plain canonical data transmits with silent gates.

(multiple-value-bind (payload receipt)
    (transmit *plain-config* :from *source-lab* :to *remote-a* :mode :direct)
  (check "control: canonical datum transmits clean"
         (and (eq payload *plain-config*)
              (eq (transmission-receipt-decision receipt) :granted)
              (null (transmission-receipt-blockers receipt))
              (null (transmission-receipt-obligations receipt))
              (not (member :direct-export-refused
                           (transmission-views receipt))))))

;;; ==================================================================

(format t "~&~%the refusal receipt, rendered from structure:~%")
(render-why (transmission-receipt-explanation *refusal-receipt*))

(format t "~&~%~d passed, ~d failed~%" *pass* *fail*)
(when (plusp *fail*)
  (sb-ext:exit :code 1))
