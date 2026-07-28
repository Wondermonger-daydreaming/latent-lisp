(load "preamble.lisp")
(in-package #:probe)
(defun tag () (cd0 make-identifier-datum '("audit") '("h2")))

;; ---- Variant A: rename WITH nickname retained ----
(defpackage #:audit-rho (:use))
(defvar *x* (intern "X" '#:audit-rho))
(defvar *reqA* (s1 request-expansion (list *x*) :macroexpand-1 (tag)))
(format t "~&A: Door1 minted: ~A~%" (s1 expansion-request-p *reqA*))
;; rename: primary becomes AUDIT-RHO-PRIME, old name a nickname
(rename-package (find-package "AUDIT-RHO") "AUDIT-RHO-PRIME" '("AUDIT-RHO"))
(format t "A: find-package AUDIT-RHO -> ~S~%" (find-package "AUDIT-RHO"))
(format t "A: symbol home now -> ~S  package-name=~S~%"
        (symbol-package *x*) (package-name (symbol-package *x*)))
(multiple-value-bind (rc ex ref) (s1 try-perform-expansion *reqA*)
  (declare (ignore ex))
  (if rc
      (format t "A: DOOR2 RECEIPT MINTED~%")
      (format t "A: DOOR2 refusal code=~S upstream-cat=~S upstream-code=~S upstream-stage=~S~%"
              (s1 expansion-refusal-code ref)
              (s1 expansion-refusal-upstream-category ref)
              (s1 expansion-refusal-upstream-code ref)
              (s1 expansion-refusal-upstream-stage ref))))

;; ---- Variant B: rename WITHOUT keeping old name as nickname ----
(defpackage #:audit-sig-b (:use))
(defvar *y* (intern "Y" '#:audit-sig-b))
(defvar *reqB* (s1 request-expansion (list *y*) :macroexpand-1 (tag)))
(rename-package (find-package "AUDIT-SIG-B") "AUDIT-SIG-B-PRIME") ; no nicknames -> old name gone
(format t "~&B: find-package AUDIT-SIG-B -> ~S~%" (find-package "AUDIT-SIG-B"))
(multiple-value-bind (rc ex ref) (s1 try-perform-expansion *reqB*)
  (declare (ignore ex))
  (if rc
      (format t "B: DOOR2 RECEIPT MINTED~%")
      (format t "B: DOOR2 refusal code=~S upstream-code=~S~%"
              (s1 expansion-refusal-code ref)
              (s1 expansion-refusal-upstream-code ref))))
