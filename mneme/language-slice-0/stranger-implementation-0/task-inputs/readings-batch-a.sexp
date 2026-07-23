;;; readings-batch-a.sexp — a frozen local scientific dataset.
;;;
;;; A batch of specimen readings from an assay run. Read with ordinary
;;; Common Lisp `read` (the whole file is ONE s-expression: a plist with
;;; :batch, :collected-at, and :rows). Each row is a plist.
;;;
;;; This file is DATA. It is not part of Lisp+; it is the world your
;;; program makes claims ABOUT.

(:batch "batch-a"
 :collected-at "2026-07-21T09:14:00Z"
 :schema-note "each row: (:specimen-id STRING :mass-mg INT :temp-c INT :replicate INT)"
 :rows
 ((:specimen-id "A-001" :mass-mg 412 :temp-c 21 :replicate 1)
  (:specimen-id "A-001" :mass-mg 419 :temp-c 21 :replicate 2)
  (:specimen-id "A-002" :mass-mg 388 :temp-c 22 :replicate 1)
  (:specimen-id "A-002" :mass-mg 401 :temp-c 22 :replicate 2)
  (:specimen-id "A-003" :mass-mg 455 :temp-c 20 :replicate 1)
  (:specimen-id "A-003" :mass-mg 448 :temp-c 20 :replicate 2)
  (:specimen-id "A-004" :mass-mg 372 :temp-c 23 :replicate 1)
  (:specimen-id "A-004" :mass-mg 369 :temp-c 23 :replicate 2)))
