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

   ;; Small conformance helpers
   #:check
   #:check-equal
   #:print-section))
