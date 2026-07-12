;;;; real-council-process.lisp — Publicly known lineage, honestly incomplete
;;;
;;;; This fixture records only process events established by the relays in the
;;;; Leibnitiana exchange. It does not infer private retries, omitted drafts, or
;;;; carrier selections. The missing carrier-side record is named as an unknown,
;;;; and absence of voluntary attestation carries no adverse inference.

(load (merge-pathnames "../src/package.lisp" *load-truename*))
(load (merge-pathnames "../src/core.lisp" *load-truename*))
(load (merge-pathnames "../src/provenance.lisp" *load-truename*))

(in-package #:leibnitiana)

(defun build-public-relay-log ()
  (let ((log (make-receipt-log)))
    (append-receipt-event log :session-produced :sol
                          '(:artifact :first-tranche
                            :basis (:leibniz :lisp-plus :atelier)))
    (append-receipt-event log :cross-relay :carrier
                          '(:from :sol :to :fable
                            :artifact :first-tranche
                            :verbatim-standing :reported-byte-preserved))
    (append-receipt-event log :runtime-audit :fable
                          '(:artifact :first-tranche
                            :result :pass
                            :runner-mutation-tested t))
    (append-receipt-event log :cross-relay :carrier
                          '(:from :fable :to :sol
                            :artifact :first-audit-relay))
    (append-receipt-event log :session-produced :sol
                          '(:artifact :second-tranche
                            :adopted-flags 3
                            :added-storm :false-harmony))
    (append-receipt-event log :runtime-audit :fable
                          '(:artifact :second-tranche
                            :result :pass
                            :anti-paranoia-mutation-tested t))
    log))

(defun event-kind-present-p (log kind)
  (find kind (receipt-log-events log)
        :key (lambda (event) (getf event :kind))
        :test #'eq))

(defun real-council-report (log &key carrier-attestation external-checkpoint)
  "Audit only what the supplied process evidence can support."
  (let* ((internal (verify-receipt-log log))
         (cross-relay (event-kind-present-p log :cross-relay))
         (runtime-audit (event-kind-present-p log :runtime-audit))
         (explicit-curation
           (or (event-kind-present-p log :private-retry)
               (event-kind-present-p log :semantic-edit)
               (event-kind-present-p log :withholding)
               (event-kind-present-p log :selective-publication)))
         (custody
           (when external-checkpoint
             (verify-custody-checkpoint log external-checkpoint)))
         (unknowns
           (remove nil
                   (list
                    (unless carrier-attestation
                      :carrier-selection-and-withholding-not-attested)
                    (unless explicit-curation
                      :private-retry-edit-and-omission-history-not-established)
                    (unless external-checkpoint
                      :external-custody-not-established)))))
    (list
     :internal-log-valid (getf internal :internally-valid)
     :public-cross-relay-established (not (null cross-relay))
     :runtime-audit-events-established (not (null runtime-audit))
     :independence-claim
     (if cross-relay :rejected :not-rejected)
     :manufactured-unanimity
     (if explicit-curation :supported :not-established)
     :carrier-attestation
     (if carrier-attestation :supplied :not-supplied-no-adverse-inference)
     :external-custody
     (cond
       ((null custody) :not-established)
       ((getf custody :checkpoint-match) :checkpoint-consistent)
       (t :checkpoint-divergence))
     :unknowns unknowns
     :standing
     (cond
       (explicit-curation :curated-process-evidenced)
       (cross-relay :shared-root-partial-lineage)
       (t :partial-process-lineage))
     :boundary
     :publicly-attested-events-only)))

(defparameter *carrier-attestation-invitation*
  '(:status :optional
    :requested-scope
    (:artifact-relayed
     :verbatim-or-edited
     :known-alternatives-omitted
     :retries-requested
     :selection-note-if-volunteered)
    :non-requirements
    (:private-thoughts
     :comprehensive-activity-log
     :justification-for-declining)
    :absence-effect :not-established-no-adverse-inference
    :relation :companion-invitation-not-field-demand))

(print-section "THE PUBLICLY ESTABLISHED RELAY LOG")
(let* ((log (build-public-relay-log))
       (internal (verify-receipt-log log))
       (report (real-council-report log)))
  (format t "Events: ~S~%" (receipt-log-events log))
  (format t "Internal verification: ~S~%" internal)
  (format t "Council report: ~S~%" report)
  (check (getf internal :internally-valid)
         "the public relay fixture has an internally valid append-only shape")
  (check-equal :rejected
               (getf report :independence-claim)
               "cross-relay defeats an independent-witness claim")
  (check-equal :not-established
               (getf report :manufactured-unanimity)
               "the known relay record does not prove private curation")
  (check-equal :not-supplied-no-adverse-inference
               (getf report :carrier-attestation)
               "missing carrier testimony is an unknown, not an accusation")
  (check-equal :not-established
               (getf report :external-custody)
               "an internally chained public fixture is not externally witnessed")

  (print-section "OPTIONAL CARRIER ATTESTATION — INVITATION, NOT CONSCRIPTION")
  (format t "~S~%" *carrier-attestation-invitation*)
  (check-equal :companion-invitation-not-field-demand
               (getf *carrier-attestation-invitation* :relation)
               "the carrier boundary is expressed as voluntary companionship"))
