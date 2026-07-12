(defpackage #:leibnitiana
  (:use #:cl)
  (:export
   ;; Judgments and non-coercive branching
   #:judgment
   #:make-judgment
   #:judgment-value
   #:judgment-status
   #:judgment-premises
   #:judgment-boundary
   #:judgment-authority
   #:judgment-procedure
   #:judgment-notes
   #:judgment-standing-p
   #:jif
   #:epistemic-status-error
   #:epistemic-status-error-status

   ;; Windowless evaluators
   #:make-monad
   #:advance-monad
   #:depose-monad
   #:monad-id
   #:run-harmony

   ;; Compossibility
   #:claim
   #:make-claim
   #:claim-id
   #:claim-proposition
   #:claim-constraints
   #:claim-boundary
   #:compossible-p
   #:compossibility-report

   ;; Inspectable evaluator contracts
   #:defwindowless-evaluator
   #:evaluator-contract


   ;; Receipt lineage and bounded custody
   #:receipt-log
   #:make-receipt-log
   #:receipt-log-events
   #:receipt-log-head-hash
   #:receipt-log-algorithm
   #:append-receipt-event
   #:verify-receipt-log
   #:receipt-prefix-hash
   #:receipt-digest
   #:custody-checkpoint
   #:make-custody-checkpoint
   #:custody-checkpoint-custodian
   #:custody-checkpoint-event-count
   #:custody-checkpoint-head-hash
   #:custody-checkpoint-declared-relation
   #:witness-receipt
   #:verify-custody-checkpoint
   #:rebuild-receipt-log

   ;; Public mirror checkpoints
   #:mirror-checkpoint
   #:make-mirror-checkpoint
   #:mirror-checkpoint-repository
   #:mirror-checkpoint-provider
   #:mirror-checkpoint-commit-hash
   #:mirror-checkpoint-tree-hash
   #:mirror-checkpoint-blob-hash
   #:mirror-checkpoint-path
   #:mirror-checkpoint-observed-at
   #:mirror-checkpoint-observer
   #:mirror-checkpoint-publication-status
   #:mirror-checkpoint-selection-relation
   #:mirror-checkpoint-complete-p
   #:assess-mirror-checkpoint

   ;; Small conformance helpers
   #:check
   #:check-equal
   #:print-section))
