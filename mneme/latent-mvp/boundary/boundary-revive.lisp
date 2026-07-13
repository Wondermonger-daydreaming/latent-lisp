;;;; boundary-revive.lisp — PROCESS B of the real-image-boundary conformance test.
;;;;
;;;; A FRESH `sbcl --script` image. It shares NOTHING with process A except the files A
;;;; wrote. It has no capability tokens, no mint registry, no procedure registry, no live
;;;; attestation — so every guarantee it reaches must be re-derived from bytes + its own
;;;; re-verification. This is the difference between the in-image conformance walk (which
;;;; can only SIMULATE the successor) and a real successor: here the predecessor is
;;;; genuinely dead.
;;;;
;;;; Exit 0 iff, across the process gap:
;;;;   (a) raw artifact bytes are ACCEPTED only through the explicitly untrusted decoder;
;;;;   (b) its serialized 'verified' grade is NOT honored — claim-authenticated-p NIL —
;;;;       until re-authenticated in THIS image (L6);
;;;;   (c) completed+verified work crosses as predecessor testimony while a mere promise
;;;;       crosses empty (L7); and
;;;;   (d) every planted forgery is refused by its own gate: the two GRADE forgeries by a
;;;;       typed schema-mismatch at decode, the CONTENT forgery by re-authentication
;;;;       (the honest ceiling — no crypto catches a structure-preserving content edit).
;;;;
;;;; Run (usually via run-boundary.sh):  sbcl --script boundary-revive.lisp <store-dir>

(load (merge-pathnames "../kernel-hardened.lisp" *load-truename*))

(defpackage #:process-b (:use #:cl))   ; sees CL + qualified mneme.client / mneme.operator only
(in-package #:process-b)

(defun as-dir (s) (if (and (plusp (length s)) (char= (char s (1- (length s))) #\/))
                      s (concatenate 'string s "/")))
(defparameter *store* (as-dir (or (second sb-ext:*posix-argv*) "/tmp/mneme-boundary-store/")))

(defvar *pass* 0) (defvar *fail* 0)
(defun ok  (name) (incf *pass*) (format t "  ✓ ~a~%" name))
(defun bad (name why) (incf *fail*) (format t "  ✗ ~a — ~a~%" name why))

(defmacro expect-ok (name &body body)
  `(handler-case (progn ,@body (ok ,name))
     (error (e) (bad ,name (format nil "unexpected error: ~a" e)))))

(defmacro expect-condition (name condition-type &body body)
  "PASS iff BODY signals exactly CONDITION-TYPE — the RIGHT constitutional organ objected."
  `(handler-case (progn ,@body (bad ,name "NO ERROR — forgery honored"))
     (,condition-type () (ok ,name))
     (mneme.client:mneme-error (e) (bad ,name (format nil "wrong Mneme condition: ~a" (type-of e))))
     (error (e) (bad ,name (format nil "non-Mneme failure: ~a" (type-of e))))))

(defun slurp (path)
  (with-open-file (s path)
    (let ((b (make-string (file-length s)))) (read-sequence b s) b)))

;;; the manifest is a plain path index A wrote (NOT attested payload; read inertly).
(defparameter *manifest*
  (with-standard-io-syntax
    (let ((*read-eval* nil)) (read-from-string (slurp (merge-pathnames "manifest.sexp" (pathname *store*)))))))
(defun m (k) (getf *manifest* k))

(format t "~&=== PROCESS B (decoder, pid ~a) — FRESH image, predecessor is dead ===~%~%" (sb-unix:unix-getpid))
(format t "LAWFUL RECONSTRUCTION across the process boundary:~%")

;;; ── (a)+(b)+(c-positive): decode the COMPLETED work from A's raw bytes ────────
(defparameter *decoded-completed* nil)
(expect-ok "B1 completed work decodes as an explicitly untrusted reconstruction"
  (let ((c (mneme.client:decode-artifact (slurp (m :completed)))))
    (setf *decoded-completed* c)
    (unless (equal (mneme.client:claim-proposition c) (m :true-prop))
      (error "decoded proposition does not match the frozen one"))
    (unless (and (getf (mneme.client:claim-provenance c) :decoded-untrusted)
                 (not (getf (mneme.client:claim-provenance c) :revived)))
      (error "raw artifact was confused with receipt-backed revival"))))

(expect-ok "B2 the serialized 'verified' grade is NOT honored — authenticated-p NIL (L6)"
  (when (mneme.client:claim-authenticated-p *decoded-completed*)
    (error "a serialized grade was honored without re-authentication")))

(expect-ok "B3 completed+verified work crosses as PREDECESSOR TESTIMONY (L7 positive)"
  (unless (mneme.client:claim-predecessor-warrants *decoded-completed*)
    (error "the dead author's completed testimony did not survive the gap")))

;;; ── (c-negative): the MERE PROMISE crosses carrying nothing ────────────────────
(expect-ok "B4 a mere promise decodes but carries NO testimony — it died (L7 negative)"
  (let ((p (mneme.client:decode-artifact (slurp (m :promise)))))
    (when (mneme.client:claim-authenticated-p p) (error "a promise arrived authenticated"))
    (when (mneme.client:claim-predecessor-warrants p) (error "a never-verified promise carried testimony"))))

;;; ── (b) completion: standing is RE-EARNED only by re-verifying in THIS image ────
(format t "~%RE-AUTHENTICATION in the successor image (L6 — the only way to restore standing):~%")
(mneme.operator:register-procedure :double (lambda (x) (* 2 x)) :version 1)  ; B's own registry
(expect-ok "B5 replay-and-attest re-earns authentication with B's OWN capability"
  (let* ((cap (mneme.operator:grant-authority :execution-verifier '(:execution) '(:double)))
         (re  (mneme.client:replay-and-attest *decoded-completed* cap :event-kind :execution)))
    (unless (mneme.client:claim-authenticated-p re)
      (error "successor could not re-earn authentication by re-checking"))))

;;; ── (d) THE TEETH: every planted forgery refused by its own gate ───────────────
(format t "~%PLANTED FORGERIES (each MUST be refused; a gate that never fires is untested):~%")

;; F1 — a serialized LIVE ATTESTATION (forged grade) is refused at decode, typed.
(expect-condition "B6 forged live-attestation (#S grade injection) refused" mneme.client:schema-mismatch
  (mneme.client:decode-artifact (slurp (m :forged-live))))

;; F2 — a #. read-eval (forged grade via code execution) is refused at decode, typed.
(expect-condition "B7 forged read-eval (#. code injection) refused" mneme.client:schema-mismatch
  (mneme.client:decode-artifact (slurp (m :forged-read-eval))))

;; F3 — a structure-preserving CONTENT forgery: the decoder CANNOT catch it (honest
;; ceiling), so it must be caught downstream by RE-AUTHENTICATION (the lie refutes).
(expect-ok "B8 content forgery passes the decoder but arrives UNauthenticated (honest ceiling)"
  (let ((c (mneme.client:decode-artifact (slurp (m :forged-content)))))
    (when (mneme.client:claim-authenticated-p c) (error "content forgery arrived authenticated"))))

(expect-condition "B9 content forgery is caught by RE-AUTHENTICATION (the lie refutes)" mneme.client:invalid-attestation
  (let ((c   (mneme.client:decode-artifact (slurp (m :forged-content))))
        (cap (mneme.operator:grant-authority :execution-verifier '(:execution) '(:double))))
    (mneme.client:replay-and-attest c cap :event-kind :execution)))  ; double 21 ≠ 99 → :refutes → refused

(format t "~%=== ~a passed, ~a failed ===~%" *pass* *fail*)
(when (plusp *fail*)
  (format t "BOUNDARY LAW BROKEN — a reconstruction was mishonored or a forgery survived.~%")
  (sb-ext:exit :code 1))
(format t "All boundary gates passed across a REAL process image gap.~%")
(format t "Ceiling (honest): API-level discipline across images — a serialized 'verified'~%")
(format t "grants nothing un-re-checked, and forged GRADES are refused by a typed condition;~%")
(format t "this is NOT cryptographic tamper-evidence — a structure-preserving CONTENT edit~%")
(format t "passes the decoder and is caught only by re-authentication. Crypto is a later milestone.~%")
