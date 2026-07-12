(:schema-version 1
 :record-id :leibnitiana-council-rounds-1-through-3
 :scope (:from "2026-07-12T01:20:00-03:00"
         :through "2026-07-12T03:45:00-03:00")
 :evidence-boundary
 (:carrier-supplied-relay-texts
  :landed-repository-reports
  :no-private-session-telemetry
  :no-reconstructed-backstage)
 :events
 ((:id :r1-sol-tranche
   :kind :artifact-produced
   :actor :sol
   :artifact :first-tranche
   :claim (:files 13 :static-checks :passed)
   :source (:type :relay :speaker :sol))
  (:id :r1-fable-landing
   :kind :landing-audit
   :actor :fable
   :artifact :first-tranche
   :claim (:runtime "SBCL 2.4.6" :runner "7/7 PASS"
           :repairs 0 :runner-mutation-killed t)
   :source (:type :relay :speaker :fable))
  (:id :r1-fable-flags
   :kind :constitutional-audit
   :actor :fable
   :artifact :first-tranche
   :claim (:author-flags 3
           :claims-split :expression-not-global-enforcement
           :convergence :shared-root-not-independent)
   :source (:type :relay :speaker :fable))
  (:id :r2-sol-tranche
   :kind :artifact-produced
   :actor :sol
   :artifact :second-tranche
   :claim (:storm :false-harmony
           :distinction (:manufactured-harmony
                         :shared-root-convergence))
   :source (:type :relay :speaker :sol))
  (:id :r2-fable-landing
   :kind :landing-audit
   :actor :fable
   :artifact :second-tranche
   :claim (:runner "8/8 PASS" :repairs 0
           :anti-paranoia-mutation-killed t)
   :source (:type :relay :speaker :fable))
  (:id :r3-fable-obligations
   :kind :constitutional-audit
   :actor :fable
   :artifact :second-tranche
   :claim (:obligations (:tamper-evidence
                         :carrier-boundary
                         :ancestry-independent-cold-read))
   :source (:type :relay :speaker :fable))
  (:id :r3-sol-tranche
   :kind :artifact-produced
   :actor :sol
   :artifact :third-tranche
   :claim (:added (:receipt-chain
                   :external-prefix-checkpoint
                   :carrier-attestation
                   :cold-read-packet
                   :characteristica-as-ir))
   :source (:type :relay :speaker :sol))
  (:id :r3-fable-landing
   :kind :landing-audit
   :actor :fable
   :artifact :third-tranche
   :claim (:runner "11/11 PASS twice"
           :repairs 2
           :repair-kinds (:reload-unsafe-string-constant
                          :advertised-naive-blade-absent))
   :source (:type :relay :speaker :fable))
  (:id :r3-fable-mutation
   :kind :mutation-audit
   :actor :fable
   :artifact :third-tranche
   :claim (:custody-overclaim-killed t
           :source-restored-byte-identical t)
   :source (:type :relay :speaker :fable))
  (:id :r3-cold-packet-custody
   :kind :custody-decision
   :actor :fable
   :artifact :cold-read-packet
   :claim (:repository-public t
           :packet-held :off-mirror
           :delivery :out-of-band
           :prior-exposure :self-declared-only)
   :source (:type :relay :speaker :fable))
  (:id :r3-public-mirror-proposal
   :kind :custody-proposal
   :actor :fable
   :artifact :public-git-mirror
   :claim (:mirror-exists :reported
           :commit-history :weak-actual-custody
           :specific-commit-identifiers :not-supplied-in-relay)
   :source (:type :relay :speaker :fable)))
 :explicit-silences
 ((:field :carrier-selection-and-omission-history
   :status :not-established
   :reason :no-voluntary-carrier-attestation-supplied)
  (:field :private-model-retries-edits-and-discarded-drafts
   :status :not-established
   :reason :no-private-session-telemetry)
  (:field :complete-raw-transcript-lineage
   :status :not-established
   :reason :relay-record-is-selective-by-form)
  (:field :outsider-identity-and-selection-process
   :status :not-established
   :reason :cold-reader-not-yet-selected)
  (:field :specific-public-mirror-commit-checkpoint
   :status :not-established
   :reason :commit-and-blob-identifiers-not-in-supplied-relay)
  (:field :ancestry-independent-review-result
   :status :not-established
   :reason :cold-read-report-not-yet-frozen))
 :declared-standing
 :shared-root-process-ledger-with-explicit-silences)
