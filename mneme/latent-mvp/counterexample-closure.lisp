;;;; counterexample-closure.lisp — permanent v1 exported-client regression fixtures.
;;;;
;;;; These are the counterexamples documented by LANGUAGE-BOUNDARY.md against
;;;; revision 9e9c031a720cd40559297c9d8bb07bf8137adb54.  They deliberately use
;;;; only MNEME.CLIENT, except for trusted bootstrap in the setup.  Each fixture
;;;; failed before its corresponding v1 closure repair was implemented.
;;;;
;;;; Run: sbcl --script counterexample-closure.lisp

(load (merge-pathnames "kernel-hardened.lisp" *load-truename*))

(defpackage #:counterexample-client (:use #:cl))
(in-package #:counterexample-client)

(defvar *pass* 0)
(defvar *fail* 0)

(defun ok (name)
  (incf *pass*)
  (format t "  ✓ ~a~%" name))

(defun bad (name why)
  (incf *fail*)
  (format t "  ✗ ~a — ~a~%" name why))

(defmacro expect-ok (name &body body)
  `(handler-case
       (progn ,@body (ok ,name))
     (error (e) (bad ,name (format nil "unexpected error: ~a" e)))))

(defmacro expect-transition (name source destination &body body)
  "Pass only when BODY reports a typed handoff failure with structured endpoints."
  `(handler-case
       (progn ,@body (bad ,name "NO ERROR — illegal transition succeeded"))
     (mneme.client:handoff-state-violation (e)
       (let ((source-reader (find-symbol "HANDOFF-SOURCE-STATE" :mneme.client))
             (destination-reader (find-symbol "HANDOFF-DESTINATION-STATE" :mneme.client)))
         (cond
           ((not (and source-reader destination-reader
                      (fboundp source-reader) (fboundp destination-reader)))
            (bad ,name "condition omitted structured source/destination states"))
           ((and (eq (funcall source-reader e) ,source)
                 (eq (funcall destination-reader e) ,destination))
            (ok ,name))
           (t
            (bad ,name
                 (format nil "reported ~s → ~s, expected ~s → ~s"
                         (funcall source-reader e) (funcall destination-reader e)
                         ,source ,destination))))))
     (mneme.client:mneme-error (e)
       (bad ,name (format nil "wrong Mneme condition: ~a" (type-of e))))
     (error (e)
       (bad ,name (format nil "non-Mneme failure: ~a" (type-of e))))))

(defun client-function (name)
  (multiple-value-bind (symbol status) (find-symbol name :mneme.client)
    (unless (and (eq status :external) (fboundp symbol))
      (error "MNEME.CLIENT does not export ~a" name))
    (symbol-function symbol)))

(defun string-input (proposition)
  (third (second proposition)))

;;; Trusted bootstrap is not part of the adversarial surface.
(mneme.operator:register-procedure
 :string-is-a
 (lambda (x) (and (stringp x) (string= x "A")))
 :version 1)
(defvar *cap*
  (mneme.operator:grant-authority :closure-verifier '(:execution) '(:string-is-a)))
(defvar *store* "/tmp/mneme-v1-counterexample-closure/")

(format t "~&=== Mneme v1 — counterexample closure (exported client) ===~%~%")

;;; CE1: COPY-TREE must not share a mutable string at claim ingress.
(expect-ok "CE1 mutable input string cannot alter a stored claim"
  (let* ((leaf (copy-seq "A"))
         (proposition (list :equals (list :call :string-is-a leaf) t))
         (claim (mneme.client:assert-claim proposition)))
    (setf (char leaf 0) #\B)
    (unless (string= (string-input (mneme.client:claim-proposition claim)) "A")
      (error "claim retained the caller's mutable string leaf"))))

;;; CE2: the exported reader must return a complete defensive datum copy.
(expect-ok "CE2 mutable string from claim-proposition cannot alter the claim"
  (let* ((claim (mneme.client:assert-claim
                 (list :equals (list :call :string-is-a (copy-seq "A")) t)))
         (leaked (mneme.client:claim-proposition claim)))
    (setf (char (string-input leaked) 0) #\B)
    (unless (string= (string-input (mneme.client:claim-proposition claim)) "A")
      (error "claim-proposition leaked its private string leaf"))))

;;; CE3: a datum mutation must never leave the old fingerprint attached to new data.
(expect-ok "CE3 mutation cannot produce a stale-fingerprint authenticated claim"
  (let* ((leaf (copy-seq "A"))
         (proposition (list :equals (list :call :string-is-a leaf) t))
         (claim (mneme.client:assert-claim proposition))
         (attestation (mneme.client:verify-proposition proposition *cap*)))
    (setf (char leaf 0) #\B)
    (let ((raised (mneme.client:raise-claim claim attestation)))
      (unless (and (mneme.client:claim-authenticated-p raised)
                   (string= (string-input (mneme.client:claim-proposition raised)) "A"))
        (error "old fingerprint raised a claim whose proposition had changed")))))

;;; CE4: scope is immutable canonical data and equality is structural, not EQ.
(expect-ok "CE4 scope mutation cannot retarget a warrant and equivalent scope raises"
  (let* ((leaf (copy-seq "alpha"))
         (scope (list :corpus leaf))
         (proposition '(:equals (:call :string-is-a "A") t))
         (claim (mneme.client:assert-claim proposition))
         (attestation (mneme.client:verify-proposition proposition *cap* :scope scope)))
    (setf (char leaf 0) #\X)
    (unless (equal (mneme.client:attestation-scope attestation) '(:corpus "alpha"))
      (error "attestation retained the caller's mutable scope"))
    (mneme.client:raise-claim claim attestation :scope (list :corpus (copy-seq "alpha")))))

;;; CE5: the scope reader itself must not expose the internal scope representation.
(expect-ok "CE5 mutable scope returned by attestation-scope is defensive"
  (let* ((proposition '(:equals (:call :string-is-a "A") t))
         (attestation
           (mneme.client:verify-proposition proposition *cap*
                                             :scope (list :corpus (copy-seq "alpha"))))
         (leaked (mneme.client:attestation-scope attestation)))
    (setf (char (second leaked) 0) #\X)
    (unless (equal (mneme.client:attestation-scope attestation) '(:corpus "alpha"))
      (error "attestation-scope leaked its private datum"))))

;;; CE6: recommit must not rewind :REVIVED to :COMMITTED.
(expect-transition "CE6 recommit after revival is refused with endpoints" :revived :committed
  (let* ((claim (mneme.client:assert-claim '(:equals (:call :string-is-a "A") t)))
         (prepared (mneme.client:prepare claim))
         (receipt (mneme.client:commit prepared *store*)))
    (mneme.client:revive receipt)
    (mneme.client:commit prepared *store*)))

;;; CE7: a refused receipt transition carries its attempted endpoints.
(expect-transition "CE7 receive-before-commit reports :PREPARED to :RECEIVED" :prepared :received
  (let* ((claim (mneme.client:assert-claim '(:equals (:call :string-is-a "A") t)))
         (prepared (mneme.client:prepare claim)))
    (mneme.client:receive (getf prepared :receipt))))

;;; CE8: receipt revival cannot be invoked on unauthenticated raw text.
(expect-transition "CE8 raw text cannot impersonate receipt revival" :raw-data :revived
  (let* ((claim (mneme.client:assert-claim '(:equals (:call :string-is-a "A") t)))
         (text (nth-value 0 (mneme.client:freeze claim))))
    (mneme.client:revive text)))

;;; CE9: raw bytes have a separately named decoder and explicitly untrusted provenance.
(expect-ok "CE9 raw decoding is explicit and does not claim receipt continuity"
  (let* ((claim (mneme.client:assert-claim '(:equals (:call :string-is-a "A") t)))
         (text (nth-value 0 (mneme.client:freeze claim)))
         (decoded (funcall (client-function "DECODE-ARTIFACT") text))
         (provenance (mneme.client:claim-provenance decoded)))
    (unless (and (getf provenance :decoded-untrusted)
                 (not (getf provenance :revived)))
      (error "raw decode claimed or obscured receipt-based revival"))))

;;; CE10: inherited predecessor testimony survives another freeze/revival hop.
(expect-ok "CE10 predecessor testimony survives a second handoff"
  (let* ((proposition '(:equals (:call :string-is-a "A") t))
         (claim (mneme.client:assert-claim proposition))
         (attestation (mneme.client:verify-proposition proposition *cap*))
         (authenticated (mneme.client:raise-claim claim attestation))
         (first-receipt
           (mneme.client:commit (mneme.client:prepare authenticated) *store*))
         (first-successor (mneme.client:revive first-receipt))
         (first-testimony (mneme.client:claim-predecessor-warrants first-successor))
         (second-receipt
           (mneme.client:commit (mneme.client:prepare first-successor) *store*))
         (second-successor (mneme.client:revive second-receipt)))
    (unless (and first-testimony
                 (equal first-testimony
                        (mneme.client:claim-predecessor-warrants second-successor)))
      (error "the second handoff erased or changed predecessor testimony"))))

(format t "~%=== ~a passed, ~a failed ===~%" *pass* *fail*)
(when (plusp *fail*)
  (format t "EXPORTED-CLIENT COUNTEREXAMPLES REMAIN OPEN.~%")
  (sb-ext:exit :code 1))
(format t "All specified v1 counterexamples are closed within the exported-client threat model.~%")
(format t "This is finite P3 evidence, not evaluator/module isolation or language closure.~%")
