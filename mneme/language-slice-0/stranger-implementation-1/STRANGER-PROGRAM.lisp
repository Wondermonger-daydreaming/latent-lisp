;; STRANGER-PROGRAM.lisp
;; Supply-Chain Admission Program using Lisp+ Slice /0

(load (merge-pathnames "../slice0-transmissibility.lisp" *load-truename*))
(load (merge-pathnames "task-inputs/verifier.lisp" *load-truename*))

(defpackage :stranger (:use :cl))
(in-package :stranger)

;; ============================================================
;; Step 0: Read inputs and set up domain objects
;; ============================================================

(defvar *artifact*
  (supply-lab:read-artifact
   (merge-pathnames "task-inputs/artifact-payload.sexp" *load-truename*)))

(defvar *metadata*
  (supply-lab:read-artifact
   (merge-pathnames "task-inputs/artifact-metadata.sexp" *load-truename*)))

(defvar *artifact-digest*
  (supply-lab:compute-digest *artifact*))

(defvar *verifier-closure*
  (supply-lab:make-signature-verifier))

(defvar *verification-request*
  (list :artifact-digest *artifact-digest*
        :claimed-signature (getf *metadata* :claimed-signature)))

(defvar *verification-result*
  (funcall *verifier-closure* *verification-request*))

(format t "~&[Step 0] Artifact digest: ~A~%" *artifact-digest*)
(format t "[Step 0] Verification result: ~A~%" *verification-result*)

;; ============================================================
;; Step 1: Construct local claim about admissibility
;; ============================================================

(defvar *admissibility-proposition*
  '(:artifact-admissible "acme-crypto-lib" "2.4.0"))

(defvar *admissibility-claim*
  (lisp-plus-slice0:claim
   :proposition *admissibility-proposition*
   :by :source-lab))

(format t "~&[Step 1] Created admissibility claim.~%")

;; ============================================================
;; Step 2: Invalid promotion attempt - wrong proposition support
;; ============================================================

(defvar *admissibility-procedure*
  (lisp-plus-slice0:promotion-procedure
   :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                :procedure-id (lisp-plus-kernel0:make-identity :procedure "admissibility-check")
                :version 0
                :judgment-class :semantic
                :result-vocabulary '(:accepted :rejected))
   :admits '((:direct :digest-check) (:direct :signature-check))))

;; Witness for a DIFFERENT proposition (download complete, not admissibility)
(defvar *download-witness*
  (lisp-plus-slice0:witness
   :for '(:download-complete "acme-crypto-lib")
   :mode :direct
   :kind :digest-check
   :source :source-lab
   :content *artifact-digest*))

(format t "~&[Step 2] Attempting invalid promotion with wrong-proposition witness...~%")

(defvar *invalid-receipt* nil)

(handler-case
    (multiple-value-bind (rev rcpt)
        (lisp-plus-slice0:raise *admissibility-claim*
                                :to :verified
                                :per *admissibility-procedure*
                                :considering (list *download-witness*))
      (declare (ignore rev))
      (format t "[Step 2] UNEXPECTED: promotion granted~%")
      (setf *invalid-receipt* rcpt))
  (lisp-plus-slice0:wrong-proposition-support (c)
    (format t "[Step 2] Refused as expected: ~A~%"
            (lisp-plus-slice0:slice0-condition-failed-invariant c))
    (setf *invalid-receipt* (lisp-plus-slice0:slice0-condition-receipt c))))

;; ============================================================
;; Step 3: Render the structured reason for refusal
;; ============================================================

(format t "~&[Step 3] Rendering refusal reason:~%")
(lisp-plus-slice0:render-why (lisp-plus-slice0:why *invalid-receipt*))

;; ============================================================
;; Step 4: Lawful repair - create proper witnesses and promote
;; ============================================================

;; Witness for the CORRECT proposition (digest match)
(defvar *digest-witness*
  (lisp-plus-slice0:witness
   :for *admissibility-proposition*
   :mode :direct
   :kind :digest-check
   :source :source-lab
   :content (list :digest-matched *artifact-digest*)))

;; Local-value wrapping the verifier closure
(defvar *verifier-local-value*
  (lisp-plus-slice0:local-value
   :host *verifier-closure*
   :authority :source-verification-lab
   :exercise-authorized '(:source-lab)
   :recipe '(:rebuild (:kind :signature-verifier))))

;; Source receiver context
(defvar *source-context*
  (lisp-plus-slice0:receiver-context
   :context-id :source-lab
   :accessible-supports (list (lisp-plus-slice0:witness-id *digest-witness*))
   :executable-procedures (list *admissibility-procedure*)
   :recognized-authorities '(:source-lab :source-verification-lab)))

;; Exercise the verifier to get a canonical derived result + minted witness
(defvar *sig-witness* nil)
(defvar *derived-result* nil)

(multiple-value-bind (dr w)
    (lisp-plus-slice0:exercise-value *verifier-local-value*
                                     :in *source-context*
                                     :args (list *verification-request*)
                                     :mint-for *admissibility-proposition*
                                     :mint-kind :signature-check)
  (setf *derived-result* dr)
  (setf *sig-witness* w))

(format t "~&[Step 4] Derived result: ~A~%"
        (lisp-plus-slice0:derived-result-value *derived-result*))

(defvar *verified-claim* nil)
(defvar *promotion-receipt* nil)

(multiple-value-bind (rev rcpt)
    (lisp-plus-slice0:raise *admissibility-claim*
                            :to :verified
                            :per *admissibility-procedure*
                            :considering (list *digest-witness* *sig-witness*)
                            :receiver :source-lab)
  (setf *verified-claim* rev)
  (setf *promotion-receipt* rcpt))

(format t "[Step 4] Promotion granted! Judgment: ~A~%"
        (lisp-plus-slice0:judgment-record-judgment
         (lisp-plus-slice0:claim-judgment *verified-claim*)))

;; ============================================================
;; Step 5: Project claim to deployment receiver
;; ============================================================

;; Deployment receiver: cannot reach our supports, recognizes different authorities
(defvar *deployment-receiver*
  (lisp-plus-slice0:receiver-context
   :context-id :deployment-target
   :accessible-supports '()
   :executable-procedures (list *admissibility-procedure*)
   :recognized-authorities '(:vendor-signing-key-2026 :acme-release-key)
   :accepted-representations '(:canonical-datum)))

(format t "~&[Step 5] Projecting claim to deployment receiver...~%")

(multiple-value-bind (projected-claim proj-receipt)
    (lisp-plus-slice0:project-claim *verified-claim*
                                    :from *source-context*
                                    :to *deployment-receiver*
                                    :store (lisp-plus-slice0:support-store *digest-witness* *sig-witness*))
  
  (format t "[Step 5] Projected claim judgment: ~A~%"
          (lisp-plus-slice0:claim-judgment projected-claim))
  (format t "[Step 5] Projection views: ~A~%"
          (lisp-plus-slice0:projection-views proj-receipt))
  
  ;; ============================================================
  ;; Step 6: Preserve inaccessible support as residue
  ;; ============================================================
  
  (format t "[Step 6] Supports inaccessible (not absent, recorded): ~A~%"
          (lisp-plus-slice0:projection-receipt-supports-inaccessible proj-receipt))
  
  ;; ============================================================
  ;; Step 7: Block relative to receiver's authority
  ;; ============================================================
  
  (format t "[Step 7] Authorities recognized/unrecognized: ~A~%"
          (lisp-plus-slice0:projection-receipt-authorities-recognized proj-receipt))
  (format t "[Step 7] Rendered projection why:~%")
  (lisp-plus-slice0:render-projection-why proj-receipt)
  
  ;; ============================================================
  ;; Step 8 & 9: Attempt direct transmission of verifier (non-reifiable)
  ;; ============================================================
  
  (format t "~&[Step 8] Attempting direct transmission of verifier capability...~%")
  
  (handler-case
      (lisp-plus-slice0:transmit *verifier-local-value*
                                 :from *source-context*
                                 :to *deployment-receiver*
                                 :mode :direct)
    (lisp-plus-slice0:value-not-reifiable (c)
      (format t "[Step 9] Refused: ~A~%"
              (lisp-plus-slice0:slice0-condition-failed-invariant c))
      (let ((t-receipt (lisp-plus-slice0:slice0-condition-receipt c)))
        (format t "[Step 9] Transmission views: ~A~%"
                (lisp-plus-slice0:transmission-views t-receipt))
        (format t "[Step 9] Reifiability status: ~A~%"
                (lisp-plus-slice0:transmission-receipt-reifiability t-receipt)))))
  
  ;; ============================================================
  ;; Step 10: Lawful alternative - transmit canonical derived result
  ;; ============================================================
  
  (format t "~&[Step 10] Transmitting canonical verification result instead...~%")
  
  ;; Wrap the canonical value in a local-value for transmission
  (let ((derived-lv
         (lisp-plus-slice0:local-value
          :host (lisp-plus-slice0:derived-result-value *derived-result*)
          :authority :source-verification-lab
          :exercise-authorized '(:source-lab))))
    
    (multiple-value-bind (payload t-receipt)
        (lisp-plus-slice0:transmit derived-lv
                                   :from *source-context*
                                   :to *deployment-receiver*
                                   :mode :direct)
      (format t "[Step 10] Transmission granted!~%")
      (format t "[Step 10] Payload is local-value-p: ~A~%"
              (lisp-plus-slice0:local-value-p payload))
      (format t "[Step 10] Decision: ~A~%"
              (lisp-plus-slice0:transmission-receipt-decision t-receipt))))
  
  ;; ============================================================
  ;; Step 11: Receiver-relative admissibility claim
  ;; ============================================================
  
  (format t "~&[Step 11] Creating receiver-relative admissibility claim...~%")
  
  ;; Receiver mints its own support based on the transmitted canonical result
  (let ((receiver-witness
         (lisp-plus-slice0:witness
          :for *admissibility-proposition*
          :mode :direct
          :kind :signature-check
          :source :deployment-target
          :content (lisp-plus-slice0:derived-result-value *derived-result*))))
    
    (let ((receiver-claim
           (lisp-plus-slice0:claim
            :proposition *admissibility-proposition*
            :by :deployment-target)))
      
      (multiple-value-bind (receiver-verified rev-receipt)
          (lisp-plus-slice0:raise receiver-claim
                                  :to :verified
                                  :per *admissibility-procedure*
                                  :considering (list receiver-witness)
                                  :receiver :deployment-target)
        (format t "[Step 11] Receiver claim judgment: ~A~%"
                (lisp-plus-slice0:judgment-record-judgment
                 (lisp-plus-slice0:claim-judgment receiver-verified)))
        (format t "[Step 11] Receiver receipt decision: ~A~%"
                (lisp-plus-slice0:promotion-receipt-decision rev-receipt))))))

(format t "~&=== SUMMARY ===~%")
(format t "All 11 steps completed successfully.~%")
