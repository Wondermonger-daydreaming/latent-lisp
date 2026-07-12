;;;; boundary-freeze.lisp — PROCESS A of the real-image-boundary conformance test.
;;;;
;;;; This is the FIRST of two separate `sbcl --script` invocations. Its whole point is
;;;; that it EXITS before process B ever starts: no capability token, no mint registry,
;;;; no procedure registry, no live attestation object survives the exit. Everything B
;;;; receives, it receives as BYTES ON DISK — the true test of L5/L6/L7 that the
;;;; in-image conformance walk can only simulate.
;;;;
;;;; WHAT THIS PROVES (with boundary-revive.lisp):
;;;;   L5  continuity is a RELATION across a real process gap — revival is reconstruction
;;;;       from serialized data in a fresh image, never identity.
;;;;   L6  a serialized 'verified' grade grants NOTHING in the successor image until it is
;;;;       re-authenticated there — the completed work crosses AUTHENTICATED-P NIL.
;;;;   L7  completed+verified work crosses as PREDECESSOR TESTIMONY (inert history that
;;;;       survives its author's death); a MERE PROMISE (asserted, never verified) crosses
;;;;       carrying no testimony at all — it dies with the capability that was never spent.
;;;;
;;;; WHAT THIS DOES NOT PROVE (the honest ceiling — stated once, here, and again in B):
;;;;   This is API-level discipline across images, NOT cryptographic tamper-evidence.
;;;;   The freezer's digest lives in an in-image RECEIPT that does not cross the gap, so
;;;;   process B has only the file text and must trust the STRUCTURAL decoder. That decoder
;;;;   refuses a forged GRADE (a serialized live attestation / a #. read-eval) with a typed
;;;;   condition, but a hand-edit that only forges CONTENT (a structurally-valid file with a
;;;;   flipped proposition) passes the decoder — it is caught not by tamper-evidence but by
;;;;   RE-AUTHENTICATION in B (the lie refutes). Real crypto (canonical bytes + HMAC) is a
;;;;   later milestone; this test is built precisely so that later milestone has teeth to
;;;;   sink into.
;;;;
;;;; Run (usually via run-boundary.sh):  sbcl --script boundary-freeze.lisp <store-dir>

(load (merge-pathnames "../kernel-hardened.lisp" *load-truename*))

(defpackage #:process-a (:use #:cl))
(in-package #:process-a)

(defparameter *store*
  (or (second sb-ext:*posix-argv*) "/tmp/mneme-boundary-store/")
  "Directory both processes share ONLY through files. Passed by run-boundary.sh.")

(defun sreplace (old new s)
  "Structure-preserving hand-edit: replace the first OLD with NEW inside string S.
   Signals if OLD is absent (a forgery we cannot plant is a forgery we must not claim)."
  (let ((i (search old s)))
    (unless i (error "planted-forgery precondition failed: ~s not found in genuine bytes" old))
    (concatenate 'string (subseq s 0 i) new (subseq s (+ i (length old))))))

(defun write-file (path text)
  (with-open-file (out path :direction :output :if-exists :supersede :if-does-not-exist :create)
    (write-string text out))
  path)

(format t "~&=== PROCESS A (freezer, pid ~a) — image opens ===~%" (sb-posix:getpid))

;;; ── operator bootstrap (trusted; happens ONLY in this image, dies at exit) ──────
(mneme.operator:register-procedure :double (lambda (x) (* 2 x)) :version 1)
(defparameter *cap* (mneme.operator:grant-authority :execution-verifier '(:execution) '(:double)))
(defparameter *true-prop*  '(:equals (:call :double 21) 42))   ; genuinely true: double 21 = 42

;;; ── COMPLETED WORK: assert → verify → raise → AUTHENTICATED (verified in-image) ──
(defparameter *authed*
  (let* ((claim (mneme.client:assert-claim *true-prop*))
         (att   (mneme.client:verify-proposition *true-prop* *cap* :event-kind :execution)))
    (assert (eq (mneme.client:attestation-verdict att) :supports))
    (mneme.client:raise-claim claim att)))
(assert (mneme.client:claim-authenticated-p *authed*))
(format t "  completed work: authenticated IN-IMAGE = ~a  (this is the state we will freeze)~%"
        (mneme.client:claim-authenticated-p *authed*))

;;; ── MERE PROMISE: asserted, NEVER verified — carries no warrant ────────────────
(defparameter *promise*
  (mneme.client:assert-claim '(:equals (:call :double 500) 1000)))  ; "trust me" — never spent a capability
(assert (not (mneme.client:claim-authenticated-p *promise*)))
(format t "  mere promise:   authenticated IN-IMAGE = ~a  (a claim that never faced a verifier)~%"
        (mneme.client:claim-authenticated-p *promise*))

;;; ── freeze BOTH to disk via the lawful prepare→commit route ────────────────────
(defparameter *completed-path*
  (mneme.client:receipt-path (mneme.client:commit (mneme.client:prepare *authed*) *store*)))
(defparameter *promise-path*
  (mneme.client:receipt-path (mneme.client:commit (mneme.client:prepare *promise*) *store*)))
(format t "  committed completed → ~a~%" *completed-path*)
(format t "  committed promise   → ~a~%" *promise-path*)

;;; ── the genuine completed bytes, for deriving structure-preserving forgeries ────
(defparameter *genuine* (nth-value 0 (mneme.client:freeze *authed*)))
(format t "~%  genuine frozen bytes (completed work):~%    ~a~%" *genuine*)

;;; ── PLANT THREE FORGERIES (red first; process B must refuse / fail to honor each) ──
;;; F1: forge a GRADE — inject a live attestation struct literal where inert data belongs.
(defparameter *forged-live-path*
  (write-file (merge-pathnames "forged-live-attestation.sexp" (pathname *store*))
              (sreplace ":PREDECESSOR-WARRANTS"
                        ":PREDECESSOR-WARRANTS (#S(MNEME::ATTESTATION :VERDICT :SUPPORTS :VALIDITY :VALID)) :IGNORED"
                        *genuine*)))
;; ^ the real list still follows under :IGNORED; the #S fires at READ before anything else.

;;; F2: forge a GRADE via code execution — a #. read-eval that would run in a naive loader.
(defparameter *forged-readeval-path*
  (write-file (merge-pathnames "forged-read-eval.sexp" (pathname *store*))
              (sreplace "(:CALL :DOUBLE 21) 42)"
                        "(:CALL :DOUBLE 21) #.(sb-ext:exit :code 99))"
                        *genuine*)))

;;; F3: forge CONTENT only — flip the proposition to a FALSE claim, keep structure valid.
;;;     The decoder CANNOT catch this (no crypto); only re-authentication in B can.
(defparameter *forged-content-path*
  (write-file (merge-pathnames "forged-content.sexp" (pathname *store*))
              (sreplace "(:CALL :DOUBLE 21) 42)" "(:CALL :DOUBLE 21) 99)" *genuine*)))

(format t "~%  planted forgeries:~%    F1 live-attestation → ~a~%    F2 read-eval        → ~a~%    F3 content-tamper   → ~a~%"
        *forged-live-path* *forged-readeval-path* *forged-content-path*)

;;; ── manifest: a plain INDEX of paths (NOT part of the trust boundary — like `ls`) ──
(write-file (merge-pathnames "manifest.sexp" (pathname *store*))
            (with-standard-io-syntax
              (prin1-to-string
               (list :completed (namestring *completed-path*)
                     :promise   (namestring *promise-path*)
                     :forged-live      (namestring *forged-live-path*)
                     :forged-read-eval (namestring *forged-readeval-path*)
                     :forged-content   (namestring *forged-content-path*)
                     :true-prop *true-prop*))))

(format t "~%=== PROCESS A — image CLOSES (all live capabilities, mints, registries die here) ===~%")
;; exit 0 implicitly; nothing of A's runtime state can reach B.
