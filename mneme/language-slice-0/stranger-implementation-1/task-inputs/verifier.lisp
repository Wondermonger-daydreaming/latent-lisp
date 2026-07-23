;;;; verifier.lisp — the SUPPLY-LAB local capabilities (ordinary Common Lisp).
;;;;
;;;; This is plain CL, not Lisp+. It defines package :supply-lab and exports
;;;; three functions. `make-signature-verifier` returns a CLOSURE whose signing
;;;; key material lives in local lexical state (there is no data form of it) —
;;;; that closure is your natural "local capability that cannot travel directly."
;;;; `compute-digest` and `read-artifact` return pure canonical data. Use them
;;;; as plain CL.
;;;;
;;;; The toy digest is a deterministic FNV-1a over the canonical printed form of
;;;; its argument. Cryptographic strength is irrelevant here: the fixture only
;;;; needs to be reproducible, so an admissibility decision can be made from it.

(defpackage :supply-lab
  (:use :cl)
  (:export #:read-artifact #:compute-digest #:make-signature-verifier))

(in-package :supply-lab)

(defun read-artifact (path)
  "Read the whole downloaded artifact file as one s-expression (its forms)."
  (with-open-file (s path :direction :input)
    (read s)))

(defun compute-digest (object)
  "Deterministic toy content digest: 32-bit FNV-1a over the canonical printed
form of OBJECT. Returns a nonnegative integer. Determinism is the only property
that matters here — this is not a cryptographic hash."
  (let ((s (let ((*print-pretty* nil)
                 (*print-case* :upcase)
                 (*print-readably* nil)
                 (*print-circle* nil))
             (prin1-to-string object)))
        (hash 2166136261))                    ; FNV offset basis (32-bit)
    (loop for ch across s
          for b = (logand (char-code ch) #xff)
          do (setf hash (logand (* (logxor hash b) 16777619) ; FNV prime
                                #xffffffff)))
    hash))

(defun make-signature-verifier ()
  "Return a one-argument closure that verifies a detached signature against toy
signer key material held in local lexical state. The key material is NOT
extractable as data — exercising the closure is the only way to use it.

The closure takes a request plist (:artifact-digest INT :claimed-signature INT)
and returns a canonical result plist:
  (:signature :valid   :over-digest INT)   ; claimed signature matches
  (:signature :invalid :over-digest INT)   ; it does not
A valid detached signature is the digest of (:sig KEY-MATERIAL ARTIFACT-DIGEST)."
  (let ((key-material "vendor-signing-key-2026/priv/9f3c7a"))
    (lambda (request)
      (let* ((digest   (getf request :artifact-digest))
             (claimed  (getf request :claimed-signature))
             (expected (compute-digest (list :sig key-material digest))))
        (if (and (integerp digest) (integerp claimed) (= claimed expected))
            (list :signature :valid   :over-digest digest)
            (list :signature :invalid :over-digest digest))))))
