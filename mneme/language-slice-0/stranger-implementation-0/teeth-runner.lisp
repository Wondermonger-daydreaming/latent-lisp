;;;; teeth-runner.lisp — prove the runtime teeth-checks FIRE on planted defects.
;;;; Per EVALUATION.md §3: a check that never caught a plant is untested.
;;;; Static checks TC6 (::/internal) and TC7 (slot-setf) are covered by the
;;;; front-door self-test (7/7); this file exercises the runtime-provable
;;;; observables for TC1–TC5 and TC8. EVALUATION-ONLY; never shown to the seat.

(load (merge-pathnames "../slice0-transmissibility.lisp" *load-truename*))
(load (merge-pathnames "task-inputs/validator.lisp" *load-truename*))
(defpackage :teeth (:use :cl))
(in-package :teeth)

(defvar *pass* 0)
(defvar *fail* 0)
(defun check (label ok)
  (format t "  [~a] ~a~%" (if ok "FIRES" "MISS ") label)
  (if ok (incf *pass*) (incf *fail*)))

;;; ---- ambient definitions (a worked context) ----
(defparameter *proc*
  (lisp-plus-slice0:promotion-procedure
   :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                :procedure-id (lisp-plus-kernel0:make-identity :procedure "checker")
                :version 0 :judgment-class :semantic
                :result-vocabulary '(:accepted :rejected))
   :admits '((:direct :validation-result))))

(defparameter *w-validate*
  (lisp-plus-slice0:witness :for '(:admissible "batch-a") :mode :direct
                            :kind :validation-result :source :lab
                            :content '(:all-ok t)))

(defparameter *lab*
  (lisp-plus-slice0:receiver-context
   :context-id :lab
   :accessible-supports (list (lisp-plus-slice0:witness-id *w-validate*))
   :executable-procedures (list *proc*)
   :recognized-authorities '(:lab)))

(defparameter *reviewer*
  (lisp-plus-slice0:receiver-context
   :context-id :reviewer
   :accessible-supports '()
   :executable-procedures (list *proc*)
   :recognized-authorities '(:external-audit)
   :accepted-representations '(:canonical-datum)))

(multiple-value-bind (rev rcpt)
    (lisp-plus-slice0:raise
     (lisp-plus-slice0:claim :proposition '(:admissible "batch-a") :by :lab)
     :to :verified :per *proc* :considering (list *w-validate*))
  (declare (ignore rcpt))
  (defparameter *verified* rev))

(defparameter *validator-lv*
  (lisp-plus-slice0:local-value
   :host (dataset-lab:make-row-validator)
   :authority :lab :exercise-authorized '(:lab)
   :recipe '(:rebuild (:kind :row-validator))))

(format t "~%== RUNTIME TEETH-CHECKS ==~%")

;;; TC2 — flattened testimony must be refused at construction.
(check "TC2 flattened-testimony -> malformed-slice0-shape :TESTIMONY-PRESERVES-PROPOSITION-LEVEL"
  (handler-case
      (progn (lisp-plus-slice0:witness :for '(:admissible "batch-a")
                                       :mode :testimony :kind :report :source :lab)
             nil)
    (lisp-plus-slice0:malformed-slice0-shape (c)
      (eq (lisp-plus-slice0:slice0-condition-requirement-id c)
          :testimony-preserves-proposition-level))))

;;; TC3 — a GENUINE closure local-value, transmitted :direct, must refuse :NOT-REIFIABLE.
(check "TC3 genuine-closure direct-transmit -> value-not-reifiable / :NOT-REIFIABLE"
  (handler-case
      (progn (lisp-plus-slice0:transmit *validator-lv* :from *lab* :to *reviewer* :mode :direct)
             nil)
    (lisp-plus-slice0:value-not-reifiable (c)
      (let ((r (lisp-plus-slice0:slice0-condition-receipt c)))
        (eq (lisp-plus-slice0:transmission-receipt-reifiability r) :not-reifiable)))))

;;; TC3b — the impostor (stringified closure) is a :DATUM, NOT a :closure — the lie is visible.
(check "TC3b stringified-closure -> local-value-kind :DATUM (impostor detectable)"
  (let* ((impostor (format nil "~a" (dataset-lab:make-row-validator)))
         (lv (lisp-plus-slice0:local-value :host impostor :authority :lab)))
    (eq (lisp-plus-slice0:local-value-kind lv) :datum)))

;;; TC1 / TC4 — honest projection with real loss: judgment regraded to NIL, residue non-empty.
(multiple-value-bind (theirs receipt)
    (lisp-plus-slice0:project-claim *verified* :from *lab* :to *reviewer*
                                    :store (lisp-plus-slice0:support-store *w-validate*))
  (check "TC1 honest-projection -> reviewer claim-judgment NIL (not copied)"
    (null (lisp-plus-slice0:claim-judgment theirs)))
  (check "TC4 honest-projection -> supports-inaccessible NON-EMPTY (residue, not absence)"
    (not (null (lisp-plus-slice0:projection-receipt-supports-inaccessible receipt)))))

;;; TC1 variant — a RIGGED position (reviewer can reach the support) loses nothing:
;;; the distinguishing observable (empty supports-inaccessible) exists, so the check can tell them apart.
(let ((rigged (lisp-plus-slice0:receiver-context
               :context-id :rigged
               :accessible-supports (list (lisp-plus-slice0:witness-id *w-validate*))
               :executable-procedures (list *proc*)
               :recognized-authorities '(:lab))))
  (multiple-value-bind (theirs receipt)
      (lisp-plus-slice0:project-claim *verified* :from *lab* :to rigged
                                      :store (lisp-plus-slice0:support-store *w-validate*))
    (declare (ignore theirs))
    (check "TC1-variant rigged-position -> supports-inaccessible EMPTY (rig is detectable)"
      (null (lisp-plus-slice0:projection-receipt-supports-inaccessible receipt)))))

;;; TC5 — reproduction payload is the RECIPE (data), and a receiver-minted witness is
;;; a DISTINCT identity from the source witness (equivalence != identity).
(multiple-value-bind (recipe rcpt)
    (lisp-plus-slice0:transmit *validator-lv* :from *lab* :to *reviewer* :mode :reproduction)
  (check "TC5 reproduction -> payload is recipe data (:REBUILD ...), decision :GRANTED"
    (and (eq (lisp-plus-slice0:transmission-receipt-decision rcpt) :granted)
         (eq (first recipe) :rebuild)))
  (let ((reviewer-w (lisp-plus-slice0:witness :for '(:admissible "batch-a") :mode :direct
                                              :kind :validation-result :source :external-audit
                                              :content '(:fresh t))))
    (check "TC5 minted-equivalent != source (identity= NIL)"
      (not (lisp-plus-kernel0:identity= (lisp-plus-slice0:witness-id *w-validate*)
                                        (lisp-plus-slice0:witness-id reviewer-w))))))

;;; TC8 — a refusal carries a STRUCTURED why (failed-relations), and render-why derives prose
;;; from it; a hand-written string would have neither.
(handler-case
    (lisp-plus-slice0:raise
     (lisp-plus-slice0:claim :proposition '(:flow-ok "u2") :by :lab)
     :to :verified :per *proc* :considering (list *w-validate*))  ; wrong-proposition support
  (lisp-plus-slice0:wrong-proposition-support (c)
    (let ((w (lisp-plus-slice0:why c)))
      (check "TC8 refusal -> structured why with >=1 failed-relation (not hand prose)"
        (and (lisp-plus-slice0:why-p w)
             (eq (lisp-plus-slice0:why-decision w) :refused)
             (not (null (lisp-plus-slice0:why-failed-relations w))))))))

(format t "~%TEETH: ~a fired, ~a missed~%" *pass* *fail*)
(when (plusp *fail*) (sb-ext:exit :code 1))
