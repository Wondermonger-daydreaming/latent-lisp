(defpackage #:lisp-plus-lci0
  (:use #:cl #:lisp-plus-cd0)
  (:export
   ;; Typed, immutable LCI/0 boundary values.
   #:lci-value
   #:lci-value-p
   #:lci-value-kind
   #:lci-value-datum
   #:lci-value-octets
   #:lci-failure
   #:lci-failure-category
   #:lci-failure-code
   #:lci-failure-stage
   #:lci-failure-path
   #:lci-failure-context

   ;; Fixture JSON and canonical-document boundary.
   #:parse-json
   #:read-json-document
   #:read-jsonl
   #:fixture-json-to-datum
   #:fixture-json-schema-shape
   #:verify-fixture-document
   #:verify-fixture-corpus

   ;; Closed-value validation and identity projection.
   #:validate-stable-ref
   #:validate-identity-policy
   #:validate-claim-profile
   #:validate-scope
   #:validate-subject-time
   #:validate-world-basis
   #:validate-dataset-slice
   #:validate-semantic-boundary
   #:validate-corpus-basis
   #:validate-interpretation-frame
   #:validate-profile-location
   #:validate-claim-location
   #:validate-claim-id
   #:validate-warrant-target
   #:validate-represented-loss
   #:validate-claim-lineage-edge
   #:validate-migration-result
   #:validate-claim-occurrence
   #:normalize-proposition
   #:proposition-location-consistent-p
   #:project-claim-id

   ;; Fixture calculi, target matching, policies, and inert migration.
   #:scope-relation
   #:temporal-relation
   #:dataset-slice-relation
   #:semantic-boundary-relation
   #:match-warrant-target
   #:evaluate-fixture-policy
   #:parse-legacy-fixture
   #:migrate-v1-fixture

   ;; Shared-vector and differential protocol.
   #:execute-fixture-operation
   #:execute-fixture-vector
   #:run-vector-selection
   #:run-all-vectors
   #:verify-fixture-relation-tables
   #:run-mutation-snapshot-test
   #:write-json-line-result))
