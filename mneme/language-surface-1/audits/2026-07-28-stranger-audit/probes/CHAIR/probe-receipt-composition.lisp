;;;; probe-receipt-composition.lisp — CHAIR probe E: mint ONE successful receipt
;;;; and verify, from the READER'S side with public API only:
;;;;   E1  the source/expanded identity fields recompute from the stored datums
;;;;       (identity = bytes-datum of the payload's canonical octets — lossless
;;;;       octets, never hex)
;;;;   E2  the receipt/request/occurrence identity chain is internally coherent
;;;;       (request-identity threads through; occurrence-identity reachable both
;;;;       ways)
;;;;   E3  the expanded HOST form returned beside the receipt re-encodes to the
;;;;       stored expanded datum (the account matches the artifact handed back)
;;;;   E4  the context record says: null env supplied, no env captured, no read
;;;;   E5  temporal-binding surface: the version accessors answer from ambient
;;;;       package state (constant functions), exhibited not asserted

(defparameter *here* (or *load-truename* *default-pathname-defaults*))
(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "../../extract/target/tree/mneme/language-surface-1/surface1.lisp" *here*))
  (load (merge-pathnames "../../extract/target/tree/mneme/language-surface-0/surface0.lisp" *here*)))

(defpackage #:chair-receipt (:use #:cl #:lisp-plus-surface1))
(in-package #:chair-receipt)

(defvar *ok* 0) (defvar *bad* 0)
(defun say (fmt &rest args) (format t "~&~?~%" fmt args) (finish-output))
(defun chk (pass label)
  (if pass (incf *ok*) (incf *bad*))
  (say "  [~a] ~a" (if pass "ok" "FAIL") label))

(defun tag (n) (lisp-plus-cd0:make-identifier-datum '("chair-audit") (list n)))
(defun recompute-identity (payload-datum)
  ;; the reader's own reconstruction of the identity law, via CD/0 public API:
  ;; identity value = bytes datum holding the payload's canonical octets
  (lisp-plus-cd0:make-bytes-datum (lisp-plus-cd0:canonical-octets payload-datum)))

;; a real, well-formed source form for a real construct (specimen shape taken
;; from de-expansione-testata/APPLICATION.lisp)
(defparameter *src*
  '(lisp-plus-surface0:define-judgment-schema cl-user::*chair-schema*
    :name :chair-j :version 0
    :conclusion (:predicate :z (:v (:var :v)))
    :premises () :locals () :unique-locals ()))

(let ((req (request-expansion *src* :macroexpand-1 (tag "E"))))
  (multiple-value-bind (receipt expanded occurrence) (perform-expansion req)
    (say "minted: receipt-p=~a occurrence-p=~a"
         (expansion-receipt-p receipt) (expansion-occurrence-p occurrence))

    ;; E1 — identity fields recompute from stored datums
    (chk (lisp-plus-cd0:equal-datum
          (expansion-receipt-source-form-identity receipt)
          (recompute-identity (expansion-receipt-source-form-datum receipt)))
         "E1a source identity == recomputed bytes(canonical-octets(source datum))")
    (chk (lisp-plus-cd0:equal-datum
          (expansion-receipt-expanded-form-identity receipt)
          (recompute-identity (expansion-receipt-expanded-form-datum receipt)))
         "E1b expanded identity == recomputed from stored expanded datum")

    ;; E2 — the chain threads
    (chk (lisp-plus-cd0:equal-datum (expansion-receipt-request-identity receipt)
                                    (expansion-request-identity req))
         "E2a receipt.request-identity == request.identity")
    (chk (lisp-plus-cd0:equal-datum (expansion-receipt-occurrence-identity receipt)
                                    (expansion-occurrence-identity occurrence))
         "E2b receipt.occurrence-identity == occurrence.identity")
    (chk (lisp-plus-cd0:equal-datum (expansion-occurrence-request-identity occurrence)
                                    (expansion-request-identity req))
         "E2c occurrence.request-identity == request.identity")
    (chk (eq (expansion-receipt-occurrence receipt) occurrence)
         "E2d receipt carries THE occurrence object")

    ;; E3 — the artifact handed back matches the account
    (chk (lisp-plus-cd0:equal-datum
          (encode-term expanded)
          (expansion-receipt-expanded-form-datum receipt))
         "E3 encode-term(returned expanded host form) == stored expanded datum")

    ;; E4 — context record truthfulness (shape-level)
    (let ((ctx (expansion-receipt-expansion-context receipt)))
      (chk (lisp-plus-cd0:record-datum-p ctx) "E4a context is a record")
      (multiple-value-bind (v ok)
          (lisp-plus-cd0:record-datum-ref
           ctx (lisp-plus-cd0:make-identifier-datum '("CONTEXT")
                                                    '("ENVIRONMENT-OBJECT-CAPTURED")))
        (chk (and ok (not (lisp-plus-cd0:boolean-datum-value v)))
             "E4b ENVIRONMENT-OBJECT-CAPTURED = false")))

    ;; E5 — version accessors are ambient, exhibited
    (chk (= (expansion-receipt-procedure-version receipt) (expansion-procedure-version))
         "E5a receipt procedure version == package's CURRENT version (ambient)")
    (say "  E5 note: accessors are constant functions over ambient package state;")
    (say "  the receipt STORES no version; identity hashes bound versions at mint.")

    ;; identity size sanity: octets, not hex — an identity's payload octet count
    (say "  identity octet counts: source=~d expanded=~d receipt=~d"
         (identity-octets (expansion-receipt-source-form-identity receipt))
         (identity-octets (expansion-receipt-expanded-form-identity receipt))
         (identity-octets (expansion-receipt-identity receipt)))))

(say "CHAIR-RECEIPT-RESULT ok=~d fail=~d" *ok* *bad*)
(sb-ext:exit :code (if (zerop *bad*) 0 1))
