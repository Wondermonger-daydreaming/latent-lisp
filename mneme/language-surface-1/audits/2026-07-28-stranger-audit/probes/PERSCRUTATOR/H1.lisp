(load "preamble.lisp")
(in-package #:probe)
(defun tag () (cd0 make-identifier-datum '("audit") '("h1")))

;; Package AUDIT-P, intern S1 named REINCARNATE
(defpackage #:audit-p (:use))
(defvar *s1* (intern "REINCARNATE" '#:audit-p))
(format t "~&S1 = ~S  home=~S~%" *s1* (symbol-package *s1*))

;; Door 1
(defvar *form* (list *s1* 1))
(defvar *req* (s1 request-expansion *form* :macroexpand-1 (tag)))
(format t "Door1 minted request: ~A~%" (s1 expansion-request-p *req*))

;; Between the doors: unintern S1, intern fresh S2 same name
(unintern *s1* '#:audit-p)
(defvar *s2* (intern "REINCARNATE" '#:audit-p))
(format t "S2 = ~S  home=~S   (eq S1 S2)=~S~%" *s2* (symbol-package *s2*) (eq *s1* *s2*))

;; Verify decode-term of stored source datum
(defvar *stored* (s1 expansion-request-source-form-datum *req*))
(defvar *decoded* (s1 decode-term *stored*))
(format t "decoded form = ~S~%" *decoded*)
(format t "(eq (car decoded) S1) = ~S~%" (eq (car *decoded*) *s1*))
(format t "(eq (car decoded) S2) = ~S~%" (eq (car *decoded*) *s2*))

;; Door 2
(multiple-value-bind (rc ex ref) (s1 try-perform-expansion *req*)
  (declare (ignore ex))
  (if rc
      (format t "DOOR2: RECEIPT MINTED (unexpected for unknown construct)~%")
      (format t "DOOR2: refusal code = ~S  upstream = ~S~%"
              (s1 expansion-refusal-code ref)
              (s1 expansion-refusal-upstream-code ref))))
