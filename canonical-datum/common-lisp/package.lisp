(defpackage #:lisp-plus-cd0
  (:use #:cl)
  (:export
   ;; Typed failures.
   #:cd0-failure
   #:failure-category
   #:failure-code
   #:failure-stage
   #:failure-offset
   #:failure-path
   #:failure-detail
   #:failure-budget-id

   ;; Immutable resource budgets.
   #:resource-budget
   #:resource-budget-p
   #:make-resource-budget
   #:copy-resource-budget
   #:default-resource-budget
   #:budget-id
   #:budget-max-input-octets
   #:budget-max-output-octets
   #:budget-max-varint-octets
   #:budget-max-integer-bits
   #:budget-max-depth
   #:budget-max-nodes
   #:budget-max-sequence-items
   #:budget-max-record-fields
   #:budget-max-identifier-segments
   #:budget-max-segment-octets
   #:budget-max-single-string-octets
   #:budget-max-single-bytes-octets
   #:budget-max-aggregate-payload-octets
   #:budget-max-total-record-key-octets

   ;; Read-only octet results.
   #:octet-string
   #:octet-string-p
   #:octets-length
   #:octets-ref
   #:octets-copy
   #:octets-to-hex
   #:hex-to-octets

   ;; The nine disjoint datum families and explicit constructors.
   #:datum
   #:datum-p
   #:datum-family
   #:unit-datum-p
   #:boolean-datum-p
   #:integer-datum-p
   #:rational-datum-p
   #:string-datum-p
   #:bytes-datum-p
   #:identifier-datum-p
   #:sequence-datum-p
   #:record-datum-p
   #:make-unit-datum
   #:make-boolean-datum
   #:make-integer-datum
   #:make-rational-datum
   #:make-string-datum
   #:make-bytes-datum
   #:make-identifier-datum
   #:make-sequence-datum
   #:make-record-entry
   #:record-entry-p
   #:record-entry-key
   #:record-entry-value
   #:make-record-datum

   ;; Defensive accessors.
   #:boolean-datum-value
   #:integer-datum-value
   #:rational-datum-numerator
   #:rational-datum-denominator
   #:string-datum-value
   #:string-datum-scalar-length
   #:bytes-datum-value
   #:identifier-datum-namespace
   #:identifier-datum-path
   #:identifier-datum-namespace-count
   #:identifier-datum-path-count
   #:identifier-datum-namespace-segment
   #:identifier-datum-path-segment
   #:sequence-datum-length
   #:sequence-datum-ref
   #:sequence-datum-elements
   #:record-datum-size
   #:record-datum-key-at
   #:record-datum-value-at
   #:record-datum-fields
   #:record-datum-ref

   ;; Normative operations and fixture boundary.
   #:equal-datum
   #:encode-exact
   #:canonical-octets
   #:decode-exact
   #:datum-to-fixture-ast
   #:datum-from-fixture-ast
   #:datum-from-fixture-construction

   ;; Diagnostic-only rendering, never an identity representation.
   #:render-diagnostic))
