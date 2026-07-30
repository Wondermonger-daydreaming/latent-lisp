;;;; forms-loader.lisp — load a script's DEFINITIONS without running its
;;;; trailing entry form.
;;;;
;;;; WHY THIS EXISTS (and why it is not a fork of anything).  Three of this
;;;; lane's artifacts are *scripts*: program/campaign.lisp, harness/
;;;; harness.lisp, harness/witness.lisp.  Each ends with exactly one
;;;; toplevel (HANDLER-CASE ...) that reads argv, runs, and EXITS.  The
;;;; mutation gate and the integration controls need those files' actual
;;;; definitions — the real composition, not a re-implementation — without
;;;; the exit.
;;;;
;;;; So this loader reproduces CL:LOAD exactly (same reader, same *PACKAGE*
;;;; discipline, same *LOAD-TRUENAME* / *LOAD-PATHNAME* bindings, same form
;;;; order, EVAL per form) and skips ONLY toplevel forms whose CAR is
;;;; HANDLER-CASE.  It returns the number of forms evaluated and the number
;;;; skipped, and every caller asserts the skip count it expects — a loader
;;;; that silently skipped two forms would be a loader that changed the
;;;; program.
;;;;
;;;; FIDELITY IS PROVEN, NOT ASSERTED: the mutation gate runs one mini
;;;; campaign through the real `campaign.lisp` and one through
;;;; `mutants/mutant-child.lisp` with NO defect installed, and requires the
;;;; two journals to be byte-identical.  If this loader were unfaithful,
;;;; that check would fail.
;;;;
;;;; NOTHING in the existing tree is modified by this file or by anything
;;;; that loads it.
;;;;
;;;; — DENTIST (Claude Fable 5 subagent), 2026-07-30

(in-package #:cl-user)

(defun load-forms-except-trailing (pathname &key (package *package*))
  "EVAL every toplevel form of PATHNAME except those whose CAR is
HANDLER-CASE.  Returns (values evaluated-count skipped-count).
*PACKAGE* is bound (so IN-PACKAGE inside the file behaves exactly as under
CL:LOAD and does not leak); *LOAD-TRUENAME* / *LOAD-PATHNAME* are bound to
PATHNAME so relative (LOAD (MERGE-PATHNAMES ... *LOAD-TRUENAME*)) forms
inside the file resolve exactly as they do under CL:LOAD."
  (let ((truename (truename pathname))
        (evaluated 0)
        (skipped 0))
    (with-open-file (stream truename :direction :input)
      (let ((*package* package)
            (*load-truename* truename)
            (*load-pathname* (pathname pathname))
            (*readtable* *readtable*))
        (loop for form = (read stream nil :end-of-forms)
              until (eq form :end-of-forms)
              do (if (and (consp form) (eq (first form) 'handler-case))
                     (incf skipped)
                     (progn (eval form) (incf evaluated))))))
    (values evaluated skipped)))

(defun load-definitions (pathname &key (package *package*)
                                       (expected-skipped 1))
  "LOAD-FORMS-EXCEPT-TRAILING with an asserted skip count."
  (multiple-value-bind (evaluated skipped)
      (load-forms-except-trailing pathname :package package)
    (unless (eql skipped expected-skipped)
      (error "forms-loader: ~a — expected exactly ~a skipped toplevel ~
              HANDLER-CASE form~:p, saw ~a (the file changed shape; refuse ~
              rather than load a program that is not the program)"
             pathname expected-skipped skipped))
    (values evaluated skipped)))
