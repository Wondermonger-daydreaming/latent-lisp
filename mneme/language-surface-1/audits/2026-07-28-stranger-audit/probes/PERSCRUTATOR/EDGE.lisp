(load "preamble.lisp")
(in-package #:probe)
(defun tag (&rest p) (cd0 make-identifier-datum '("audit") (or p '("edge"))))
(defparameter *spec*
  '(lisp-plus-surface0:define-admission-contract cl-user::*s1-contract*
    :contract-id :surface1/selftest :contract-version 1
    :accepted-clauses ((:verified-judged-claim))
    :proposition-relation :exact-normalized-equality
    :receiver-accessibility :required
    :retain (:contract-snapshot :support-identity :support-basis :source-basis)))

;; --- FALSE-EDGE governing check: receipt's account == expansion performed ---
(defvar *req* (s1 request-expansion *spec* :macroexpand-1 (tag "e1")))
(multiple-value-bind (rc ex occ) (s1 perform-expansion *req*)
  (declare (ignore occ))
  ;; independent recomputation of the expansion from the receipt's stored source datum
  (let* ((stored-src (s1 expansion-receipt-source-form-datum rc))
         (indep-form (s1 decode-term stored-src))
         (indep-exp  (macroexpand-1 indep-form nil))
         (indep-exp-datum (s1 encode-term indep-exp))
         (stored-exp (s1 expansion-receipt-expanded-form-datum rc)))
    (format t "~&EDGE source round-trips: ~A~%"
            (cd0 equal-datum stored-src (s1 encode-term indep-form)))
    (format t "EDGE receipt-expanded == independent macroexpand of receipt-source: ~A~%"
            (cd0 equal-datum stored-exp indep-exp-datum))
    (format t "EDGE actual-returned-expansion encodes == receipt-expanded: ~A~%"
            (cd0 equal-datum stored-exp (s1 encode-term ex)))))

;; --- Surface/0 grammar refusal escapes unwrapped, nothing minted ---
;; A malformed derive-case (surface0 owns the refusal). Try a bad admission form.
(format t "~%-- surface0 refusal escape --~%")
(let ((bad '(lisp-plus-surface0:define-admission-contract)))  ; missing everything
  (handler-case
      (let ((rq (s1 request-expansion bad :macroexpand-1 (tag "e2"))))
        (handler-case (progn (s1 perform-expansion rq) (format t "EDGE: minted something (unexpected)~%"))
          (lisp-plus-surface1:expansion-refused (c)
            (format t "EDGE: surface1 refusal ~S (did NOT escape to surface0)~%"
                    (s1 expansion-refusal-code (s1 expansion-condition-refusal c))))
          (error (e) (format t "EDGE: escaped condition type=~S pkg=~S~%"
                             (type-of e) (package-name (symbol-package (type-of e)))))))
    (lisp-plus-surface1:expansion-refused (c)
      (format t "EDGE: refused at DOOR1 ~S~%" (s1 expansion-refusal-code (s1 expansion-condition-refusal c))))))

;; --- tag/datum immutability: mutate a source string after Door 1 ---
(format t "~%-- source string mutation after Door 1 --~%")
(let* ((mstr (make-string 3 :initial-element #\a))
       (form (list 'cl-user::foo mstr))
       (rq (s1 request-expansion form :macroexpand-1 (tag "e3")))
       (before (cd0 octets-to-hex (cd0 canonical-octets (s1 expansion-request-source-form-datum rq)))))
  (setf (char mstr 0) #\Z)  ; mutate caller's string
  (let ((after (cd0 octets-to-hex (cd0 canonical-octets (s1 expansion-request-source-form-datum rq)))))
    (format t "EDGE stored source datum unchanged by caller mutation: ~A~%" (string= before after))))
