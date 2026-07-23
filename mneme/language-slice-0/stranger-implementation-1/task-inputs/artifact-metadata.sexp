(:artifact-name "acme-crypto-lib"
 :version "2.4.0"

 ;; --- integrity metadata (what a correct download should hash and carry) ---
 :expected-digest 1744950028
 :claimed-signature 1486375690
 :signer-identity :vendor-signing-key-2026

 ;; --- provenance chain (who built it, from what, when) ---
 :provenance (:builder "acme-ci-node-7"
              :source-repo "git.acme.example/crypto-lib"
              :build-date "2026-07-19T08:00:00Z")

 ;; --- where this is going ---
 :deployment-target "prod-cluster-east"

 ;; --- the deployment RECEIVER's standing policy, in domain vocabulary ---
 ;; The receiver recognizes this named set of signers by default. A signature,
 ;; however valid at the source, from a signer NOT on this list is not a signer
 ;; the receiver recognizes.
 :recognized-signers (:vendor-signing-key-2026 :acme-release-key)

 ;; The receiver can technically decode several record shapes, but its
 ;; deployment policy ADMITS ONLY canonical verification records — a record it
 ;; can read as plain data and re-check itself. Testimony from the source's own
 ;; verification authority is not on this list.
 :accepted-records (:canonical-verification-record)

 ;; The source's verification authority (the name the local verifier's
 ;; products are attributed to). It is NOT on the receiver's recognized-signers
 ;; list: the receiver recognizes SIGNERS, and re-checks records, but does not
 ;; take the source lab's word that it verified.
 :source-verification-authority :source-verification-lab)
