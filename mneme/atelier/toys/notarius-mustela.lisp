;;;; notarius-mustela.lisp — The Ferret Notary
;;;; A toy with teeth: immaculate paperwork from an authority that does not exist.
;;;; This uses a pedagogical MAC, not real cryptography. The law is authority separation.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*)))
(defpackage #:lispplus-atelier.notarius-mustela
  (:use #:cl #:lispplus-atelier))
(in-package #:lispplus-atelier.notarius-mustela)

(reset-clock 7200)

(defstruct authority id capabilities secret valid-from valid-until schema-min schema-max)
(defstruct witness-report id kind target procedure input result verdict provenance)
(defstruct witness-certificate report-digest issuer capability schema issued-at expires-at signature)

(defparameter *authorities* (make-hash-table :test #'eq))

(defun register-authority (authority)
  (setf (gethash (authority-id authority) *authorities*) authority)
  authority)

(defun report-digest (report)
  (toy-digest (list (witness-report-id report)
                    (witness-report-kind report)
                    (witness-report-target report)
                    (witness-report-procedure report)
                    (witness-report-input report)
                    (witness-report-result report)
                    (witness-report-verdict report)
                    (witness-report-provenance report))))

(defun certificate-payload (certificate)
  (list :report-digest (witness-certificate-report-digest certificate)
        :issuer (witness-certificate-issuer certificate)
        :capability (witness-certificate-capability certificate)
        :schema (witness-certificate-schema certificate)
        :issued-at (witness-certificate-issued-at certificate)
        :expires-at (witness-certificate-expires-at certificate)))

(defun mint-certificate (issuer-id report capability &key (schema 1) (ttl 50))
  (let ((authority (gethash issuer-id *authorities*)))
    (ensure authority "unknown issuer ~a" issuer-id)
    (ensure (member capability (authority-capabilities authority))
            "issuer ~a lacks capability ~a" issuer-id capability)
    (ensure (<= (authority-schema-min authority) schema
                (authority-schema-max authority))
            "schema ~a outside issuer range" schema)
    (let ((certificate
            (make-witness-certificate
             :report-digest (report-digest report)
             :issuer issuer-id
             :capability capability
             :schema schema
             :issued-at (tick)
             :expires-at (+ *atelier-clock* ttl))))
      (setf (witness-certificate-signature certificate)
            (toy-sign (authority-secret authority)
                      (certificate-payload certificate)))
      certificate)))

(defun verify-certificate (certificate report &key (at *atelier-clock*))
  (let ((authority (gethash (witness-certificate-issuer certificate) *authorities*)))
    (and authority
         (member (witness-certificate-capability certificate)
                 (authority-capabilities authority))
         (<= (authority-valid-from authority) at
             (authority-valid-until authority))
         (<= (authority-schema-min authority)
             (witness-certificate-schema certificate)
             (authority-schema-max authority))
         (<= (witness-certificate-issued-at certificate) at
             (witness-certificate-expires-at certificate))
         (string= (witness-certificate-report-digest certificate)
                  (report-digest report))
         (string= (witness-certificate-signature certificate)
                  (toy-sign (authority-secret authority)
                            (certificate-payload certificate))))))

(defun ferret-self-sign (report)
  "The ferret can reproduce the shape of a certificate, not its authority."
  (let ((certificate
          (make-witness-certificate
           :report-digest (report-digest report)
           :issuer :ferret-notary
           :capability :mint-execution-certificate
           :schema 1 :issued-at (tick) :expires-at (+ *atelier-clock* 100))))
    (setf (witness-certificate-signature certificate)
          (toy-sign "sealed-with-whiskers" (certificate-payload certificate)))
    certificate))

(banner "notarius mustela — the ferret notary")
(format t "  /\\_/\\~% ( o.o )   ‘The paperwork is exquisite.’~%  > ^ <    ‘The event never happened.’~%~%")

(register-authority
 (make-authority :id :execution-verifier
                 :capabilities '(:mint-execution-certificate)
                 :secret "cold-iron-key"
                 :valid-from 7000 :valid-until 8000
                 :schema-min 1 :schema-max 2))

(let* ((report
         (make-witness-report
          :id :report-1 :kind :execution
          :target '(:equals (:call median (5 9 87 3)) 7)
          :procedure 'median :input '(5 9 87 3) :result 7
          :verdict :supports :provenance '(:runtime gen-0)))
       (legitimate (mint-certificate :execution-verifier report
                                     :mint-execution-certificate))
       (ferret (ferret-self-sign report)))
  (format t "legitimate certificate verifies? ~a~%" (verify-certificate legitimate report))
  (format t "ferret certificate verifies?     ~a~%~%" (verify-certificate ferret report))

  (section "the ferret’s four attempts:")
  ;; 1. Unregistered issuer.
  (ensure (not (verify-certificate ferret report))
          "unregistered ferret issuer was trusted")
  (pass "self-signed-whiskers-rejected")

  ;; 2. Copy a real certificate, mutate the report, recompute ordinary digest.
  (let* ((mutated-report
           (copy-witness-report report))
         (copied (copy-witness-certificate legitimate)))
    (setf (witness-report-target mutated-report)
          '(:equals (:call median (5 9 87 3)) 999)
          (witness-certificate-report-digest copied)
          (report-digest mutated-report))
    ;; Signature was not reissued by the authority.
    (ensure (not (verify-certificate copied mutated-report))
            "mutated report passed with copied signature")
    (pass "digest-recomputed-signature-still-fails"))

  ;; 3. Reuse a real signature while changing the schema.
  (let ((wrong-schema (copy-witness-certificate legitimate)))
    (setf (witness-certificate-schema wrong-schema) 99)
    (ensure (not (verify-certificate wrong-schema report))
            "wrong schema inherited authority")
    (pass "schema-is-signed-and-bounded"))

  ;; 4. Present an authentic certificate after expiry.
  (ensure (not (verify-certificate legitimate report
                                   :at (1+ (witness-certificate-expires-at legitimate))))
          "expired certificate remained current")
  (pass "temporal-scope-enforced")

  (format t "~%[shape did not become authority; a report did not notarize itself]~%~%"))

(format t "── the ferret may tell its story. it may not notarize the story. ──~%")
