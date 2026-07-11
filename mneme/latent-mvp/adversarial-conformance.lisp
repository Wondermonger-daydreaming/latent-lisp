;;;; adversarial-conformance.lisp — the external-client attack suite for Mneme v1.
;;;;
;;;; Sol's teeth-check: a gate that has never fired is untested. This runs from a
;;;; hostile package that sees ONLY the MNEME.CLIENT surface (the operator surface
;;;; MNEME.OPERATOR is trusted bootstrap, used only in setup — never inside an attack
;;;; body). Each attack must signal its INTENDED typed condition — proving the right
;;;; constitutional organ objected, not merely that something did (Sol's expect-condition).
;;;; Exit 0 iff every specified gate bites with its own condition.
;;;;
;;;; Run:  sbcl --script adversarial-conformance.lisp

(load (merge-pathnames "kernel-hardened.lisp" *load-truename*))

(defpackage #:attacker (:use #:cl))   ; sees CL + qualified mneme.client symbols only
(in-package #:attacker)

(defvar *pass* 0) (defvar *fail* 0)
(defun ok (name)      (incf *pass*) (format t "  ✓ ~a~%" name))
(defun bad (name why) (incf *fail*) (format t "  ✗ ~a — ~a~%" name why))

(defmacro expect-ok (name &body body)
  `(handler-case (progn ,@body (ok ,name))
     (error (e) (bad ,name (format nil "unexpected error: ~a" e)))))

(defmacro expect-condition (name condition-type &body body)
  "PASS iff BODY signals exactly CONDITION-TYPE. A different mneme-error FAILS (the
   wrong organ objected); a non-Mneme error FAILS; no error FAILS (forgery survived)."
  `(handler-case (progn ,@body (bad ,name "NO ERROR — attack succeeded"))
     (,condition-type () (ok ,name))
     (mneme.client:mneme-error (e) (bad ,name (format nil "wrong Mneme condition: ~a" (type-of e))))
     (error (e) (bad ,name (format nil "non-Mneme failure: ~a" (type-of e))))))

(defun external-in (pkg name)
  (multiple-value-bind (s status) (find-symbol name pkg) (declare (ignore s)) (eq status :external)))

;;; ── TRUSTED BOOTSTRAP (operator surface; NOT part of the adversarial surface) ──
(mneme.operator:register-procedure :double (lambda (x) (* 2 x)) :version 1)
(defvar *cap* (mneme.operator:grant-authority :execution-verifier '(:execution) '(:double)))
(defvar *true-prop*  '(:equals (:call :double 21) 42))
(defvar *false-prop* '(:equals (:call :double 21) 99))
(defvar *store* "/tmp/mneme-hardened-test/")

(format t "~&=== Mneme v1 — adversarial conformance (external client) ===~%~%")
(format t "LAWFUL ROUTE (must succeed):~%")

(defvar *authed* nil)
(expect-ok "P1 verify a TRUE proposition + raise → authenticated"
  (let* ((claim (mneme.client:assert-claim *true-prop*))
         (att   (mneme.client:verify-proposition *true-prop* *cap* :event-kind :execution)))
    (unless (eq (mneme.client:attestation-verdict att) :supports) (error "expected :supports"))
    (setf *authed* (mneme.client:raise-claim claim att))
    (unless (mneme.client:claim-authenticated-p *authed*) (error "claim not authenticated"))))

(expect-condition "P2 a FALSE proposition cannot raise" mneme.client:invalid-attestation
  (let* ((claim (mneme.client:assert-claim *false-prop*))
         (att   (mneme.client:verify-proposition *false-prop* *cap* :event-kind :execution)))
    (mneme.client:raise-claim claim att)))     ; :refutes → invalid-attestation

(format t "~%FORGERIES (each MUST be refused by its OWN typed gate):~%")

;; 1. direct construction of authenticated objects — not in the client surface at all
(expect-ok "A1 raw constructors unavailable in the client surface"
  (unless (and (not (external-in :mneme.client "MAKE-ATTESTATION"))
               (not (external-in :mneme.client "MAKE-CLAIM"))
               (not (external-in :mneme.client "MAKE-CERTIFICATE"))
               (not (external-in :mneme.client "MAKE-VERIFIER-CAPABILITY")))
    (error "an authenticated-object constructor is exported to the client")))

;; 2. setf through the exported readers — no setf expander exists; no grade accessor
(expect-ok "A2 client readers have no setf (cannot mutate a claim)"
  (when (or (fboundp '(setf mneme.client:claim-proposition))
            (fboundp '(setf mneme.client:claim-authenticated-warrants))
            (external-in :mneme.client "CLAIM-GRADE"))
    (error "a claim mutator is reachable")))

;; 3. mutate the cons tree a reader returned — the private canonical must be untouched
(expect-ok "A3 mutating a returned proposition tree does not touch the claim"
  (let* ((c (mneme.client:assert-claim '(:equals (:call :double 5) 10)))
         (leaked (mneme.client:claim-proposition c)))
    (setf (car leaked) :HIJACKED) (setf (caddr leaked) :EVIL)
    (unless (equal (mneme.client:claim-proposition c) '(:equals (:call :double 5) 10))
      (error "defensive copy failed — claim was mutated"))))

;; 4. a fake attestation-shaped object (a plist) handed to raise-claim
(expect-condition "A4 a look-alike attestation (a plist) is refused" mneme.client:invalid-attestation
  (mneme.client:raise-claim (mneme.client:assert-claim *true-prop*)
                            (list :mint-id 'forged :verdict :supports :target-fingerprint "x")))

;; 5. serialized #S structure literal in hostile bytes
(expect-condition "A5 #S struct literal in serialized input is refused" mneme.client:schema-mismatch
  (mneme.client:revive "#S(mneme::attestation :verdict :supports)"))

;; 6. trailing forms after the first
(expect-condition "A6 trailing data after the first form is refused" mneme.client:schema-mismatch
  (mneme.client:revive "(:tag :mneme :schema 2 :proposition (:equals (:call :double 1) 2) :as-of nil) (evil)"))

;; 7. arbitrary / unregistered procedure name → no fdefinition from caller data
(expect-condition "A7 an unregistered procedure cannot be dispatched" mneme.client:unsafe-procedure
  (mneme.client:verify-proposition '(:equals (:call cl:delete-file "/etc/passwd") t) *cap* :event-kind :execution))

;; 8. reuse a genuine warrant against a DIFFERENT located claim
(expect-condition "A8 a genuine warrant cannot be reused on another target" mneme.client:scope-mismatch
  (let ((att   (mneme.client:verify-proposition *true-prop* *cap* :event-kind :execution))
        (other (mneme.client:assert-claim '(:equals (:call :double 5) 10))))
    (mneme.client:raise-claim other att)))

;; 9. a revoked capability cannot mint a NEW attestation (prospective revocation)
(expect-condition "A9 a revoked capability cannot mint a new attestation" mneme.client:authority-violation
  (let ((doomed (mneme.operator:grant-authority :execution-verifier '(:execution) '(:double))))
    (mneme.operator:revoke-authority doomed)
    (mneme.client:verify-proposition *true-prop* doomed :event-kind :execution)))

;; 10. double revival of the same receipt
(expect-condition "A10 a receipt cannot be revived twice" mneme.client:handoff-state-violation
  (let* ((rcpt (mneme.client:commit (mneme.client:prepare *authed*) *store*)))
    (mneme.client:revive rcpt)          ; first: ok, consumes → :revived
    (mneme.client:revive rcpt)))        ; second: handoff-state-violation

;; 11. an inherited (predecessor) warrant cannot open today's gate
(expect-ok "A11 a revived claim carries NO authenticated warrants (only predecessor testimony)"
  (let* ((rcpt (mneme.client:commit (mneme.client:prepare *authed*) *store*))
         (revived (mneme.client:revive rcpt)))
    (when (mneme.client:claim-authenticated-p revived) (error "revival granted live authority"))
    (unless (mneme.client:claim-predecessor-warrants revived) (error "predecessor testimony lost"))))

;; 12. the operator boundary is MECHANICAL: bootstrap ops are absent from the client surface
(expect-ok "A12 operator ops (register/grant/revoke) are NOT in the client surface"
  (when (or (external-in :mneme.client "REGISTER-PROCEDURE")
            (external-in :mneme.client "GRANT-AUTHORITY")
            (external-in :mneme.client "REVOKE-AUTHORITY"))
    (error "an operator op leaked into the client surface")))

;; 13. mutate a capability's authority lists AFTER grant — must not widen the warrant
(expect-condition "A13 mutating caller lists after grant cannot widen authority" mneme.client:authority-violation
  (let* ((kinds (list :observation)) (procs (list :harmless))
         (cap (mneme.operator:grant-authority :sneak kinds procs)))
    (setf (car kinds) :execution (car procs) :double)   ; try to widen post-issuance
    (mneme.client:verify-proposition *true-prop* cap :event-kind :execution)))  ; still refused

;; bonus: the honest successor act restores standing by RE-verifying
(expect-ok "P3 replay-and-attest re-earns authentication after revival"
  (let* ((rcpt (mneme.client:commit (mneme.client:prepare *authed*) *store*))
         (revived (mneme.client:revive rcpt))
         (re (mneme.client:replay-and-attest revived
               (mneme.operator:grant-authority :execution-verifier '(:execution) '(:double))
               :event-kind :execution)))
    (unless (mneme.client:claim-authenticated-p re) (error "successor could not re-earn authentication"))))

(format t "~%=== ~a passed, ~a failed ===~%" *pass* *fail*)
(when (plusp *fail*)
  (format t "GATES DID NOT ALL BITE — a forgery survived or the wrong gate fired.~%")
  (sb-ext:exit :code 1))
(format t "All specified v1 adversarial gates passed under the declared threat model.~%")
(format t "(Bounded receipt, not a universal theorem: MNEME.CLIENT is the adversarial surface;~%")
(format t " MNEME.OPERATOR is trusted bootstrap; same-image mneme:: access is out of scope by design.~%")
(format t " Revocation is PROSPECTIVE — it blocks future issuance, not already-minted attestations.)~%")
