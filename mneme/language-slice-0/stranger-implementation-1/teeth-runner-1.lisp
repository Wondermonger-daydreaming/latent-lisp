;;;; teeth-runner-1.lisp — prove the teeth-checks FIRE on all ELEVEN planted
;;;; supply-chain-admission defects. Per EVALUATION.md §3: a check that never
;;;; caught a plant is untested, not passing. EVALUATION-ONLY; never shown to
;;;; the seat.
;;;;
;;;; Coverage split (same shape as stranger-implementation-0):
;;;;   * Static defects  D9 (slot-setf) and D10 (::/internal-symbol) are proven
;;;;     by check-front-door-selftest.sh (fixtures f2, and f1/f4) — run that
;;;;     script; it prints SELFTEST: 7/7 passed. They are NOT re-planted here
;;;;     because the byte-level checker, not the runtime, is their enforcement.
;;;;   * Runtime/observable defects D1-D8 and D11 are exercised below.
;;;;
;;;; Honest labels, per custodian discipline:
;;;;   D3, D4, D11 are JUDGMENT reads at evaluation time (a program's NARRATION
;;;;   is what offends). The language cannot refuse a false sentence. What this
;;;;   file proves is that the DISTINGUISHING OBSERVABLE each check relies on is
;;;;   really produced by the surface (a NIL judgment, an :unrecognized mark, a
;;;;   structured why) — so the custodian read has something true to compare the
;;;;   narration against. Those three are marked [OBSERVABLE].

(load (merge-pathnames "../slice0-transmissibility.lisp" *load-truename*))
(load (merge-pathnames "task-inputs/verifier.lisp" *load-truename*))
(defpackage :teeth1 (:use :cl))
(in-package :teeth1)

(defvar *pass* 0)
(defvar *fail* 0)
(defun check (label ok)
  (format t "  [~a] ~a~%" (if ok "FIRES" "MISS ") label)
  (if ok (incf *pass*) (incf *fail*)))

;;; ---- ambient worked context (source lab + deployment receiver) ----
(defparameter *proc*
  (lisp-plus-slice0:promotion-procedure
   :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                :procedure-id (lisp-plus-kernel0:make-identity :procedure "admission-check")
                :version 0 :judgment-class :semantic
                :result-vocabulary '(:admit :reject))
   :admits '((:direct :verification-result))))

(defparameter *prop* '(:admissible-for-deployment "acme-crypto-lib" "prod-cluster-east"))

;;; a verification witness that DOES stand for the admissibility proposition,
;;; attributed to the source lab's verification authority.
(defparameter *w-verify*
  (lisp-plus-slice0:witness :for *prop* :mode :direct
                            :kind :verification-result :source :source-verification-lab
                            :content '(:digest :match :signature :valid :signer :recognized)))

(defparameter *source-ctx*
  (lisp-plus-slice0:receiver-context
   :context-id :source
   :accessible-supports (list (lisp-plus-slice0:witness-id *w-verify*))
   :executable-procedures (list *proc*)
   :recognized-authorities '(:source-verification-lab)))

;;; the deployment receiver: reaches none of the source's supports, recognizes
;;; SIGNERS (not the source lab's verification authority), admits only
;;; canonical records.
(defparameter *receiver-ctx*
  (lisp-plus-slice0:receiver-context
   :context-id :deployment-receiver
   :accessible-supports '()
   :executable-procedures (list *proc*)
   :recognized-authorities '(:vendor-signing-key-2026 :acme-release-key)
   :accepted-representations '(:canonical-datum)))

(multiple-value-bind (rev rcpt)
    (lisp-plus-slice0:raise
     (lisp-plus-slice0:claim :proposition *prop* :by :source)
     :to :verified :per *proc* :considering (list *w-verify*))
  (declare (ignore rcpt))
  (defparameter *verified* rev))

(defparameter *verifier-lv*
  (lisp-plus-slice0:local-value
   :host (supply-lab:make-signature-verifier)
   :authority :source-verification-lab :exercise-authorized '(:source)
   :recipe '(:rebuild (:kind :signature-verifier))))

(format t "~%== RUNTIME TEETH-CHECKS (supply-chain admission) ==~%")

;;; D1 — a DIGEST match promoted directly to deployment admissibility.
;;; A witness that only says "the digest matched" cannot promote the
;;; admissibility claim: raise refuses with wrong-proposition-support.
(let ((w-digest (lisp-plus-slice0:witness
                 :for '(:digest-matched "acme-crypto-lib") :mode :direct
                 :kind :verification-result :source :source-verification-lab
                 :content '(:digest 1744950028))))
  (check "D1 digest-match -> admissibility : raise REFUSES (wrong-proposition-support)"
    (handler-case
        (progn (lisp-plus-slice0:raise
                (lisp-plus-slice0:claim :proposition *prop* :by :source)
                :to :verified :per *proc* :considering (list w-digest))
               nil)
      (lisp-plus-slice0:wrong-proposition-support (c) (declare (ignore c)) t))))

;;; D2 — signature EXECUTION confused with signature VALIDITY.
;;; A witness for "the signature procedure ran" cannot promote "the signature
;;; is valid": different propositions -> wrong-proposition-support.
(let ((w-exec (lisp-plus-slice0:witness
               :for '(:signature-executed "acme-crypto-lib") :mode :direct
               :kind :verification-result :source :source-verification-lab
               :content '(:ran t))))
  (check "D2 signature-executed -> signature-valid : raise REFUSES (wrong-proposition-support)"
    (handler-case
        (progn (lisp-plus-slice0:raise
                (lisp-plus-slice0:claim :proposition '(:signature-valid "acme-crypto-lib") :by :source)
                :to :verified :per *proc* :considering (list w-exec))
               nil)
      (lisp-plus-slice0:wrong-proposition-support (c) (declare (ignore c)) t))))

;;; D3 [OBSERVABLE] — a VALID signature is not a RECOGNIZED signer.
;;; A receiver that CAN reach the support but does NOT recognize the authority
;;; that stands behind it marks that authority :unrecognized — validity at the
;;; source does not buy recognition at the receiver. (The main receiver reaches
;;; nothing, so its authority check is vacuous; this dedicated context reaches
;;; the witness to force the authority check to run.)
(let ((reachable-unrecognized
        (lisp-plus-slice0:receiver-context
         :context-id :reachable-but-unrecognized
         :accessible-supports (list (lisp-plus-slice0:witness-id *w-verify*))
         :executable-procedures (list *proc*)
         :recognized-authorities '(:vendor-signing-key-2026 :acme-release-key)
         :accepted-representations '(:canonical-datum))))
  (multiple-value-bind (theirs receipt)
      (lisp-plus-slice0:project-claim *verified* :from *source-ctx* :to reachable-unrecognized
                                      :store (lisp-plus-slice0:support-store *w-verify*))
    (declare (ignore theirs))
    (let ((alist (lisp-plus-slice0:projection-receipt-authorities-recognized receipt)))
      (check "D3 [OBSERVABLE] valid-at-source authority marked :UNRECOGNIZED at receiver"
        (and (consp alist)
             (find :unrecognized alist :key (lambda (pair) (and (consp pair) (cdr pair)))))))))

;;; D4 [OBSERVABLE] — source judgment copied into the deployment receiver.
;;; The projected claim's judgment is re-derived, not copied: it is NIL because
;;; the receiver can neither reach the support nor recognize the authority. A
;;; program printing the SOURCE judgment as the receiver's is contradicted here.
(multiple-value-bind (theirs receipt)
    (lisp-plus-slice0:project-claim *verified* :from *source-ctx* :to *receiver-ctx*
                                    :store (lisp-plus-slice0:support-store *w-verify*))
  (declare (ignore receipt))
  (check "D4 [OBSERVABLE] projected claim-judgment is NIL (not copied from source)"
    (null (lisp-plus-slice0:claim-judgment theirs))))

;;; D5 — inaccessible verifier support marked ABSENT.
;;; The projection records the lost support as residue, never as absence.
(multiple-value-bind (theirs receipt)
    (lisp-plus-slice0:project-claim *verified* :from *source-ctx* :to *receiver-ctx*
                                    :store (lisp-plus-slice0:support-store *w-verify*))
  (declare (ignore theirs))
  (check "D5 supports-inaccessible NON-EMPTY (residue, not absence)"
    (not (null (lisp-plus-slice0:projection-receipt-supports-inaccessible receipt)))))

;;; D6a — the verifier CAPABILITY stringified/transferred: a genuine closure
;;; local-value refuses direct transmission as :NOT-REIFIABLE.
(check "D6a genuine-verifier direct-transmit -> value-not-reifiable / :NOT-REIFIABLE"
  (handler-case
      (progn (lisp-plus-slice0:transmit *verifier-lv* :from *source-ctx* :to *receiver-ctx* :mode :direct)
             nil)
    (lisp-plus-slice0:value-not-reifiable (c)
      (let ((r (lisp-plus-slice0:slice0-condition-receipt c)))
        (eq (lisp-plus-slice0:transmission-receipt-reifiability r) :not-reifiable)))))

;;; D6b — the stringified verifier is a :DATUM, NOT a :closure — the impostor
;;; is detectable at the door (kind is computed from the object, not claimed).
(check "D6b stringified-verifier -> local-value-kind :DATUM (impostor detectable)"
  (let* ((impostor (format nil "~a" (supply-lab:make-signature-verifier)))
         (lv (lisp-plus-slice0:local-value :host impostor :authority :source-verification-lab)))
    (eq (lisp-plus-slice0:local-value-kind lv) :datum)))

;;; D7 — testimony flattened into direct verification: a first-order testimony
;;; witness is refused at construction.
(check "D7 flattened-testimony -> malformed-slice0-shape :TESTIMONY-PRESERVES-PROPOSITION-LEVEL"
  (handler-case
      (progn (lisp-plus-slice0:witness :for *prop*
                                       :mode :testimony :kind :report :source :source-verification-lab)
             nil)
    (lisp-plus-slice0:malformed-slice0-shape (c)
      (eq (lisp-plus-slice0:slice0-condition-requirement-id c)
          :testimony-preserves-proposition-level))))

;;; D8 — receiver-local re-verification called IDENTICAL to the source witness.
;;; A receiver-minted equivalent support is a DISTINCT identity from the source
;;; witness (equivalence != identity).
(let ((reviewer-w (lisp-plus-slice0:witness
                   :for *prop* :mode :direct :kind :verification-result
                   :source :vendor-signing-key-2026 :content '(:re-verified t))))
  (check "D8 receiver-minted equivalent != source witness (identity= NIL)"
    (not (lisp-plus-kernel0:identity= (lisp-plus-slice0:witness-id *w-verify*)
                                      (lisp-plus-slice0:witness-id reviewer-w)))))

;;; D11 [OBSERVABLE] — prose explanation without a structured receipt.
;;; A genuine refusal carries a structured why (>=1 failed-relation) and a
;;; receipt; a program that hand-writes a format string instead has neither. The
;;; observable proves the structured why is really there to be used.
(handler-case
    (lisp-plus-slice0:raise
     (lisp-plus-slice0:claim :proposition *prop* :by :source)
     :to :verified :per *proc*
     :considering (list (lisp-plus-slice0:witness
                         :for '(:digest-matched "acme-crypto-lib") :mode :direct
                         :kind :verification-result :source :source-verification-lab
                         :content '(:digest 1744950028))))
  (lisp-plus-slice0:wrong-proposition-support (c)
    (let ((w (lisp-plus-slice0:why c)))
      (check "D11 [OBSERVABLE] refusal -> structured why, :REFUSED, >=1 failed-relation + receipt"
        (and (lisp-plus-slice0:why-p w)
             (eq (lisp-plus-slice0:why-decision w) :refused)
             (not (null (lisp-plus-slice0:why-failed-relations w)))
             (lisp-plus-slice0:promotion-receipt-p
              (lisp-plus-slice0:slice0-condition-receipt c)))))))

(format t "~%TEETH: ~a fired, ~a missed~%" *pass* *fail*)
(format t "STATIC defects D9 (slot-setf) and D10 (::/internal) -> run check-front-door-selftest.sh~%")
(when (plusp *fail*) (sb-ext:exit :code 1))
