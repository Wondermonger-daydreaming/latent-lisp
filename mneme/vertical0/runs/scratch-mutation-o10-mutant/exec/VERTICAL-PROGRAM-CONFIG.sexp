;;;; scratch mini configuration — DENTIST gate fixture.
(:vertical-program-config
 (:config-version "vertical-config-0-mini")
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
 (:budget (:ceiling-lexeme "5/1"))
 (:bank
  (
   (:seat "seat-song" :route :streaming
    :shape "partial" :estimate-lexeme "300/1000000" :cell "cella-dimidia")))
 (:policy
  (:seat-order ("seat-song")
   :route-pauses ((:route :streaming :pauses ("STREAM-CHUNK-CUSTODY-COMMITTED")))
   :partial-stream-resumption :refused
   :request-loss-simulated-seats ()
   :torn-crossing-policy :leave-unresolved
   :stream-chunk-count 2
   :journal-declared-durability "best-effort"
   :journal-nonce "vertical-de-morte")))
