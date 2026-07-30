;;;; surface2-erratum-binder-repro.lisp — Erratum 0.1 PRE-PATCH reproduction.
;;;;
;;;; Run:  sbcl --script mneme/language-surface-2/surface2-erratum-binder-repro.lisp
;;;; from the latent-lisp root, against the PUBLISHED (pre-erratum) surface2.
;;;; This script asserts the DEFECTS are present: it exits 0 when every
;;;; defect reproduces, exit 1 otherwise.  After the patch it is expected
;;;; to FAIL (the defects are gone) — it is a historical instrument, kept
;;;; with its pre-patch transcript as evidence of ordering, not a gate.
;;;;
;;;; — Claude Fable 5 (chair), 2026-07-30

(load (merge-pathnames "surface2.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-surface2)

(defvar *checks* 0)
(defvar *failures* 0)

(defun check (description thunk)
  (incf *checks*)
  (let ((description (format nil description)))
    (if (handler-case (funcall thunk) (error () nil))
        (format t "[R~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[R~3,'0d] FAIL ~a~%" *checks* description)))))

(defun expansion-accepted-p (form)
  "T iff macroexpand-1 completes with NO surface2 refusal and NO host error."
  (handler-case (progn (macroexpand-1 form) t)
    (error () nil)))

(defun host-error-not-refusal-p (form)
  "T iff macroexpand-1 signals an error that is NOT surface2-expansion-refused."
  (handler-case (progn (macroexpand-1 form) nil)
    (surface2-expansion-refused () nil)
    (error () t)))

(format t "surface2 erratum 0.1 — PRE-PATCH reproduction (defects expected PRESENT)~%~%")

(check "1 parent shadowing ACCEPTED: a facet binding reusing the parent ~
        variable expands without refusal (the defect)"
  (lambda ()
    (expansion-accepted-p
     '(match-outcome o
       ((:execution :settled) :facets ((o :manifestation)) o)
       (otherwise o)))))

(check "2 duplicate facet variables ACCEPTED: two bindings of one name in ~
        one clause expand without refusal (the defect)"
  (lambda ()
    (expansion-accepted-p
     '(match-outcome o
       ((:execution :settled) :facets ((m :manifestation) (m :effect)) m)
       (otherwise o)))))

(check "3 dangling :facets ACCEPTED: a :facets marker with no ~
        specification list is silently swallowed (the defect)"
  (lambda ()
    (expansion-accepted-p
     '(match-outcome o
       ((:execution :settled) :facets)
       (otherwise o)))))

(check "4a with-outcome NON-LIST binding escapes as a HOST error, not a ~
        retained surface2 refusal (the leak)"
  (lambda ()
    (host-error-not-refusal-p '(with-outcome o (list o)))))

(check "4b with-outcome ONE-ELEMENT binding escapes as a HOST error, not ~
        a retained surface2 refusal (the leak)"
  (lambda ()
    (host-error-not-refusal-p '(with-outcome (o) (list o)))))

(check "4c with-outcome THREE-ELEMENT binding escapes as a HOST error, ~
        not a retained surface2 refusal (the leak)"
  (lambda ()
    (host-error-not-refusal-p '(with-outcome (o (form) extra) (list o)))))

(format t "~%surface2-erratum-repro: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(if (zerop *failures*)
    (progn (format t "RESULT: DEFECTS-REPRODUCED~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
