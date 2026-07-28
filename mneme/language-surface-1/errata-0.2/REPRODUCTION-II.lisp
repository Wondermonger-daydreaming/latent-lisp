;;;; REPRODUCTION-II.lisp — the Errata 0.1 FOLLOW-UP defect report.
;;;;
;;;; THIS INSTRUMENT IS SUBJECT-NEUTRAL.  argv[1] is the candidate directory,
;;;; argv[2] an optional subject label.  It reports the grammar and procedure
;;;; versions it actually found and never asserts which tree it is looking at.
;;;;
;;;; Three findings, each CONFIRMED with executed evidence or REFUTED:
;;;;   A  an INHERITED symbol substituted for the one the datum names
;;;;   B  the round trip asserted by a test but not enforced at runtime
;;;;   C  an IMPORTED symbol — the same hole, second shape, which a status-only
;;;;      guard would not catch

;;; WHERE THIS INSTRUMENT LIVES, as distinct from WHAT IT MEASURES: the measuring
;;; apparatus travels from the instrument's own tree, the subject arrives as argv[1].
(defparameter *repro-here* (or *load-truename* *default-pathname-defaults*))

(defparameter *s1dir*
  (pathname (or (second sb-ext:*posix-argv*)
                "/home/gauss/Desktop/Claude-Code-Lab/experiments/latent-lisp/mneme/language-surface-1/")))
(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "surface1.lisp" *s1dir*))
  (load (merge-pathnames "../language-surface-0/surface0.lisp" *s1dir*)))
(load (merge-pathnames "../errata-0.3/EVIDENCE.lisp" *repro-here*))

;;; THE DECLARED COUNT, at the top: a run truncated anywhere below cannot satisfy it.
(defparameter *expected-verdicts* 4)

(defpackage #:repro2 (:use #:common-lisp))
(in-package #:repro2)
;;; ERRATA 0.3 / D8 F-16.  These used FIND-SYMBOL WITHOUT demanding :EXTERNAL, so a
;;; private name resolved silently — the same defect class as bare INTERN, one step
;;; short (`FOSSOR.md` §6, F7).  Absence was worse than silent: FIND-SYMBOL returning
;;; NIL produced the form `(NIL …)`, an error naming nothing.
(defmacro s1 (n &rest a)
  (multiple-value-bind (sym status) (find-symbol (string n) '#:lisp-plus-surface1)
    (unless (eq status :external)
      (error "S1: ~A is ~:[absent~;~:*~A~] in LISP-PLUS-SURFACE1, not :EXTERNAL"
             (string n) status))
    `(,sym ,@a)))
(defmacro cd0 (n &rest a)
  (multiple-value-bind (sym status) (find-symbol (string n) '#:lisp-plus-cd0)
    (unless (eq status :external)
      (error "CD0: ~A is ~:[absent~;~:*~A~] in LISP-PLUS-CD0, not :EXTERNAL"
             (string n) status))
    `(,sym ,@a)))
(defun banner (s) (format t "~%  ~A~%  ~A~%" s (make-string (length s) :initial-element #\-)))
(defun line (c &rest a)
  (let ((x (apply #'format nil c a))) (if (string= x "") (format t "~%") (format t "    ~A~%" x))))
(defun same (a b) (cd0 equal-datum a b))
(defun tag (&rest p) (cd0 make-identifier-datum '("repro2") p))

(defparameter *subject-label* (or (third sb-ext:*posix-argv*) "<unlabelled subject>"))
(defparameter *verdicts* '())
(defun verdict (id state text)
  (push (list id state) *verdicts*)
  (format t "    ~A  ~A — ~A~%" (if (eq state :confirmed) "CONFIRMED" "REFUTED  ") id text))

;;; ERRATA 0.3 / D6.  The ABSOLUTE path used to be printed here — a property of the
;;; machine, not of the subject, and the reason this transcript could not reproduce
;;; byte-for-byte from the writable scratch copy the runner itself tells an auditor
;;; to work in.  WHICH BYTES is answered by the digest; WHERE they sat is not evidence.
(defun subject-place (dir)
  (let ((tail (last (pathname-directory (truename dir)) 2)))
    (format nil ".../~{~A/~}" tail)))

(format t "~&REPRODUCTION II — Surface /1 Errata 0.1 follow-up (3 findings)~%")
(surface1-evidence:print-evidence-header
 cl-user::*s1dir*
 :label *subject-label*
 :tools-home (merge-pathnames "../" cl-user::*repro-here*))
(format t "place       ~A  (path-stable by design; see above)~%"
        (subject-place cl-user::*s1dir*))
(format t "SBCL ~A · grammar v~D · procedure v~D · policy v~D~%"
        (lisp-implementation-version)
        (s1 expansion-grammar-version) (s1 expansion-procedure-version)
        (s1 expansion-policy-version))

;;; ==================================================================
(banner "FINDING A — INHERITED-SYMBOL RECONSTRUCTION SUBSTITUTION")

;;; Q exports X.  P uses Q but SHADOWS X with its own P-owned symbol.
(defpackage #:probe-q (:use) (:export #:x))
(defpackage #:probe-p (:use #:probe-q) (:shadow #:x))

(defparameter *p-x* (find-symbol "X" '#:probe-p))
(defparameter *q-x* (find-symbol "X" '#:probe-q))

(line "P::X home package ......... ~A" (package-name (symbol-package *p-x*)))
(line "Q:X  home package ......... ~A" (package-name (symbol-package *q-x*)))
(line "they are DISTINCT symbols . ~A" (not (eq *p-x* *q-x*)))
(multiple-value-bind (s st) (find-symbol "X" '#:probe-p)
  (line "(find-symbol \"X\" P) before . ~A / status ~S" (symbol-package s) st))

;;; A representable Surface /0 specimen whose BOUND VARIABLE is the P-owned
;;; symbol.  Every other field is literal syntax, as the specimen demands.
(defparameter *source*
  (list (find-symbol "DEFINE-ADMISSION-CONTRACT" '#:lisp-plus-surface0)
        *p-x*
        :contract-id :repro2/c
        :contract-version 1
        :accepted-clauses (list (list :verified-judged-claim))
        :proposition-relation :exact-normalized-equality
        :receiver-accessibility :required
        :retain (list :contract-snapshot)))

(defparameter *req* (s1 request-expansion *source* :macroexpand-1 (tag "a")))
(defparameter *stored* (s1 expansion-request-source-form-datum *req*))
(line "")
(line "Door 1 accepted.  stored datum names the P-owned symbol.")

;;; THE MUTATION OF THE IMAGE: unintern P's own X, so Q's X becomes accessible
;;; in P BY INHERITANCE.
(unintern *p-x* (find-package '#:probe-p))
(multiple-value-bind (s st) (find-symbol "X" '#:probe-p)
  (line "(find-symbol \"X\" P) after .. ~A / status ~S"
        (and s (package-name (symbol-package s))) st)
  (defparameter *now-resolves-to* s)
  (defparameter *now-status* st))

(line "the resolved symbol is now Q's ... ~A" (eq *now-resolves-to* *q-x*))

;;; What does DECODE-TERM do?
(defparameter *rebuilt*
  (handler-case (s1 decode-term *stored*)
    (error (e) (format nil "REFUSED ~A" (type-of e)))))

(if (stringp *rebuilt*)
    (line "DECODE-TERM ................ ~A" *rebuilt*)
    (progn
      (line "DECODE-TERM reconstructed a form whose bound variable is:")
      (line "  symbol ~S · home package ~A"
            (second *rebuilt*)
            (package-name (symbol-package (second *rebuilt*))))
      (line "  is it Q's symbol? ~A" (eq (second *rebuilt*) *q-x*))
      (defparameter *re-encoded* (s1 encode-term *rebuilt*))
      (line "")
      (line "encode-term(decode-term(stored)) == stored ... ~A"
            (same *re-encoded* *stored*))))

(defparameter *finding-a*
  (and (not (stringp *rebuilt*))
       (eq (second *rebuilt*) *q-x*)
       (not (same (s1 encode-term *rebuilt*) *stored*))))

(line "")
(if *finding-a*
    (verdict "A" :confirmed
             "the decoder resolved ACCESSIBILITY IN P where the grammar records HOME-PACKAGE IDENTITY P — stored datum names P/X, reconstruction is Q:X")
    (verdict "A" :refuted
             "an inherited symbol does not substitute for the one the datum names"))

;;; Whatever the decoder did, DOOR 2 must not mint an account of a form other
;;; than the one the stored datum names.
(multiple-value-bind (rc ex rf) (s1 try-perform-expansion *req*)
  (declare (ignore ex))
  (if rc
      (verdict "A2" :confirmed
               "a RECEIPT WAS MINTED for a reconstruction that does not re-encode to the stored source datum")
      (verdict "A2" :refuted
               (format nil "Door 2 refused: ~S / ~A"
                       (s1 expansion-refusal-code rf)
                       (s1 expansion-refusal-upstream-code rf)))))

;;; ==================================================================
(banner "FINDING B — IS THE ROUND-TRIP INVARIANT ENFORCED AT RUNTIME?")
(line "N5 asserts encode(decode(d)) == d for ordinary specimens.")
(line "The question is whether %RECONSTRUCT-SOURCE ENFORCES it before expanding.")
(line "")
;;; ERRATA 0.3 / D3.  WITHDRAWN, and the withdrawn words are kept here so a reader
;;; can see what was claimed: "WITH THE HOME-PACKAGE GUARD IN PLACE, decode is
;;; injective for every admissible datum, so NO PUBLIC INPUT REACHES the round-trip
;;; mismatch — the earlier, more precise guard always fires first."  The 2026-07-28
;;; stranger audit reached ROUND-TRIP-MISMATCH from the public operation, by two
;;; independent mechanisms.  Injectivity was never established; it was assumed.
(line "ERRATA 0.3 — the injectivity claim that used to stand here is WITHDRAWN.")
(line "ROUND-TRIP-MISMATCH IS publicly reachable (audit D3).  What the gate does")
(line "is still exactly what it did: it refuses BEFORE macroexpansion, nothing is")
(line "minted, and no false edge is written.  The gate was vindicated; the note")
(line "about it was false.  This probe still plants a defective decoder, not")
(line "because the public path cannot get there, but because a PLANTED fault is")
(line "the smallest way to show THIS gate — and only this gate — doing the work.")
(line "")
(let* ((hook (find-symbol "*%FAULT-DECODE-SUBSTITUTION*" '#:lisp-plus-surface1))
       (clean-req (s1 request-expansion
                      (list (find-symbol "DEFINE-ADMISSION-CONTRACT" '#:lisp-plus-surface0)
                            (intern "*REPRO2-B*" '#:cl-user)
                            :contract-id :repro2/b :contract-version 1
                            :accepted-clauses (list (list :verified-judged-claim))
                            :proposition-relation :exact-normalized-equality
                            :receiver-accessibility :required
                            :retain (list :contract-snapshot))
                      :macroexpand-1 (tag "b"))))
  ;; with no fault bound the same request performs cleanly — the gate is not stuck on
  (let ((clean (multiple-value-bind (rc ex rf) (s1 try-perform-expansion clean-req)
                 (declare (ignore ex rf)) (and rc t))))
    (line "with NO fault bound, the request performs cleanly ... ~A" clean)
    (if (and hook (boundp hook))
        (let ((fired
                (progv (list hook)
                    (list (lambda (form)
                            ;; a decoder that returns a DIFFERENT form: swap one literal
                            (let ((copy (copy-tree form)))
                              (setf (getf (cddr copy) :contract-version) 424242)
                              copy)))
                  (multiple-value-bind (rc ex rf) (s1 try-perform-expansion clean-req)
                    (declare (ignore ex))
                    (and (null rc) rf
                         (string= "ROUND-TRIP-MISMATCH"
                                  (or (s1 expansion-refusal-upstream-code rf) "")))))))
          (line "with a DEFECTIVE decoder planted, the gate fires ... ~A" fired)
          (if (and clean fired)
              (verdict "B" :refuted
                       "the round trip IS enforced at runtime: a reconstruction that does not re-encode to the stored datum refuses with ROUND-TRIP-MISMATCH before any expansion, and the gate is not stuck on")
              (verdict "B" :confirmed
                       "the round trip is asserted by a test and NOT enforced at runtime")))
        (verdict "B" :confirmed
                 "the round trip is asserted by a test and NOT enforced at runtime — no gate and no fault hook exist"))))

;;; ==================================================================
(banner "FINDING C — IMPORTED SYMBOL, THE SECOND SHAPE OF THE SAME HOLE")
;;; A symbol may be :INTERNAL in P and yet be home in Q, via IMPORT.  A status
;;; check alone would pass it; only the home-package EQ test catches it.
(defpackage #:probe-q2 (:use) (:export #:y))
(defpackage #:probe-p2 (:use))
(import (find-symbol "Y" '#:probe-q2) (find-package '#:probe-p2))
(multiple-value-bind (s st) (find-symbol "Y" '#:probe-p2)
  (line "(find-symbol \"Y\" P2) ....... ~A / status ~S"
        (package-name (symbol-package s)) st)
  (line "status is :INTERNAL yet home package is Q2 ... ~A"
        (and (eq st :internal) (not (eq (symbol-package s) (find-package '#:probe-p2))))))
(line "=> a status-only guard would NOT catch this; the home-package EQ test does.")

(line "")
(line "THE ENCODER ALREADY WRITES THE HOME PACKAGE — measured — so an imported")
(line "symbol has no hole on the ENCODE side.  The reachable question is a DATUM")
(line "whose namespace names a package where the symbol is only ACCESSIBLE.  That")
(line "datum is built by hand here, because no encode path produces it.")
(let* ((ns (cd0 make-identifier-datum '("TERM") '("KIND")))
       (vk (cd0 make-identifier-datum '("TERM") '("VALUE")))
       (hand (cd0 make-record-datum
                  (list (cd0 make-record-entry ns
                             (cd0 make-identifier-datum '("TERMKIND") '("SYMBOL")))
                        (cd0 make-record-entry vk
                             ;; namespace PROBE-P2, path Y — Y is accessible in
                             ;; P2 by IMPORT, and its home package is PROBE-Q2
                             (cd0 make-identifier-datum '("PROBE-P2") '("Y")))))))
  (line "hand-built datum names PROBE-P2/Y; Y's home package is ~A"
        (package-name (symbol-package (find-symbol "Y" '#:probe-p2))))
  (multiple-value-bind (sym status) (find-symbol "Y" '#:probe-p2)
    (line "(find-symbol \"Y\" P2) = ~A / status ~S — a STATUS-ONLY guard would PASS it"
          (package-name (symbol-package sym)) status))
  (let ((rebuilt (handler-case (s1 decode-term hand) (error () :refused))))
    (line "DECODE-TERM on that datum ... ~A" (if (eq rebuilt :refused) "REFUSED" rebuilt))
    (if (eq rebuilt :refused)
        (verdict "C" :refuted
                 "a datum whose namespace names a package where the symbol is merely ACCESSIBLE is REFUSED — the home-package conjunct does the work the status test cannot")
        (verdict "C" :confirmed
                 "an accessible-but-not-home symbol reconstructs, so the encoded namespace does not pin the symbol"))))

(format t "~%  SUMMARY~%  -------~%")
(dolist (v (reverse *verdicts*))
  (format t "    ~9@A  ~A~%" (if (eq (second v) :confirmed) "CONFIRMED" "REFUTED") (first v)))
;;; ERRATA 0.3 / D6 — the canonical line carries the CONTENT-DERIVED subject digest.
;;; ERRATA 0.3 / D4 — the wrapper requires this exact shape, and the instrument exits
;;; nonzero if its live verdict count misses the count declared at the top.
(format t "~%REPRODUCTION-RESULT verdicts=~D expected=~D confirmed=~D subject=~A~%"
        (length *verdicts*) cl-user::*expected-verdicts*
        (count :confirmed *verdicts* :key #'second)
        (surface1-evidence:subject-short
         cl-user::*s1dir* (merge-pathnames "../" cl-user::*repro-here*)))
(when (/= (length *verdicts*) cl-user::*expected-verdicts*)
  (sb-ext:exit :code 1))
