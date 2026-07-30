(:vertical-program-config
 (:config-version "vertical-config-0-control")
 (:declared-versions
  (:adapter "adapter0-through-erratum-0.1"
   :cost-procedure "fake-cost-procedure-1"
   :recovery-projection "vertical-recovery-projection-0"
   :interpretation "vertical-interpretation-0"
   :census "vertical-census-0"))
 (:adapter
  (:descriptor-identity "fake-reference-0"
   :usage-procedure "fake-usage-procedure-0"
   :cost-procedure "fake-cost-procedure-1"
   :price-schedule "fake-prices-v0"))
 (:authority
  (:bootstrap-issuer "auctor-primus"
   :subject ("subject" "machina")
   :action ("action" "loqui")
   :scope ("scope" "semel")
   :revoked-seats ()))
 (:budget
  (:ceiling-lexeme "5/1"))
 (:bank
  ((:seat "seat-control" :route :frontier-only
    :shape nil :estimate-lexeme "100/1000000" :cell "cella-controlata"
    :control-policy :disposition-then-reconcile
    :control-pauses ("EFFECT-FRONTIER-CROSSED-UNSETTLED"
                     "CONTROL-DISPOSITION-COMMITTED"))))
 (:policy
  (:seat-order ("seat-control")
   :route-pauses
   ((:route :frontier-only
     :pauses ("EFFECT-FRONTIER-CROSSED-UNSETTLED")))
   :partial-stream-resumption :refused
   :request-loss-simulated-seats ("seat-control")
   :torn-crossing-policy :leave-unresolved
   :stream-chunk-count 2
   :journal-declared-durability "synced"
   :journal-nonce "vertical-de-morte")))
