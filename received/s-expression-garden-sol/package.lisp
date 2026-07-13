;;;; package.lisp --- The S-Expression Garden

(defpackage #:s-expression-garden
  (:use #:cl)
  (:export
   ;; Garden and specimens
   #:garden
   #:specimen
   #:make-garden
   #:garden-id
   #:garden-receipts
   #:garden-specimen-ids
   #:find-specimen
   #:register-specimen
   #:remove-specimen
   #:specimen-id
   #:specimen-form
   #:specimen-contract
   #:specimen-revision
   #:specimen-provenance
   #:specimen-hash

   ;; Tree surgery
   #:subtree-at
   #:replace-subtree
   #:all-paths
   #:path-valid-p

   ;; Grafting and receipts
   #:attempt-graft
   #:graft-rulebook
   #:replay-receipt
   #:receipt-field
   #:receipt-status
   #:receipt-rule
   #:receipt-id
   #:receipt->string
   #:write-receipt
   #:read-receipt
   #:plant-receipt

   ;; Audits and invariants
   #:canonical-sexp-string
   #:stable-sexp-hash
   #:check-receipt-invariants
   #:check-garden-invariants
   #:assert-garden-invariants

   ;; Specimens, demonstrations, and tests
   #:make-specimen-garden
   #:run-demonstration
   #:run-tests

   ;; Deliberately small operator ecology
   #:garden-add
   #:garden-sub
   #:garden-mul
   #:garden-div
   #:garden-concat
   #:garden-spin))

(in-package #:s-expression-garden)
