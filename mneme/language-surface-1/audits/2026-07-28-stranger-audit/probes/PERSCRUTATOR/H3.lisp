(load "preamble.lisp")
(in-package #:probe)
(defun tag () (cd0 make-identifier-datum '("audit") '("h3")))

(defpackage #:audit-sigma (:use))
(defvar *y1* (intern "Y" '#:audit-sigma))
(defvar *req* (s1 request-expansion (list *y1*) :macroexpand-1 (tag)))
(format t "~&Door1 minted: ~A  y1=~S home=~S~%" (s1 expansion-request-p *req*) *y1* (symbol-package *y1*))

;; whole-package reincarnation: rename old away (no nickname), fresh package same name
(rename-package (find-package "AUDIT-SIGMA") "AUDIT-SIGMA-OLD")
(defpackage #:audit-sigma (:use))
(defvar *y2* (intern "Y" '#:audit-sigma))
(format t "old pkg obj = ~S  new pkg obj = ~S  (eq old-y new-y)=~S~%"
        (find-package "AUDIT-SIGMA-OLD") (find-package "AUDIT-SIGMA") (eq *y1* *y2*))

;; decode of stored datum
(defvar *decoded* (s1 decode-term (s1 expansion-request-source-form-datum *req*)))
(format t "decoded head = ~S  home=~S  (eq y1)=~S (eq y2)=~S~%"
        (car *decoded*) (symbol-package (car *decoded*))
        (eq (car *decoded*) *y1*) (eq (car *decoded*) *y2*))

;; Door 2
(multiple-value-bind (rc ex ref) (s1 try-perform-expansion *req*)
  (declare (ignore ex))
  (if rc
      (format t "DOOR2 RECEIPT MINTED~%")
      (format t "DOOR2 refusal code=~S upstream-code=~S~%"
              (s1 expansion-refusal-code ref)
              (s1 expansion-refusal-upstream-code ref))))
