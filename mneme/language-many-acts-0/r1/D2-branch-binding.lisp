;;;; D2-branch-binding.lisp — the BRANCH-BINDING witness (defect D2).
;;;;
;;;; Fresh image.  PUBLIC EXPORTS ONLY.
;;;;
;;;; WHAT IT TESTS WHETHER HOLDS.  (Post-R1 wording, adoption Rider 6,
;;;; 2026-08-10: this header read "WHAT IT PROVES", and the preserved red
;;;; transcript quotes it with that word.  A fixture TESTS WHETHER a defect
;;;; is present; it proves nothing about the repaired state, whose account
;;;; is the GREEN capture beside the red one.)  The hypothesis under test:
;;;;
;;;; The validator walks a branch's clauses SEQUENTIALLY against
;;;; ONE mutable binding table (`%vctx-bindings', pushed to and never restored).
;;;; A name defined inside the FIRST alternative therefore stays in the table
;;;; while the SECOND alternative is checked, so a later alternative may
;;;; reference a name that exists only on a path it is not on.  The source is
;;;; ACCEPTED; the run then fails from below when the later alternative is the
;;;; one selected.
;;;;
;;;;   D2-1  static: the sibling-leak source is ACCEPTED by `ma0-validate'.
;;;;         (Accepted = defect present.  A typed refusal = repaired.)
;;;;   D2-2  runtime: with the second alternative selected, the run dies on the
;;;;         name that was never bound — the failure the validator let through.
;;;;   D2-3  control, legal: a binding made BEFORE the branch and referenced
;;;;         inside an alternative is lawful and must stay accepted.  This probe
;;;;         is GREEN both before and after the repair; it exists so the repair
;;;;         cannot be "refuse every branch".
;;;;   D2-4  control, sealed no-shadowing: the same local name defined in two
;;;;         separate alternatives is refused by the SEALED V-BIND law
;;;;         (one definition per whole program text, GRAMMAR §3).  GREEN both
;;;;         before and after; the repair may not disturb it.
;;;;
;;;; BEFORE the repair D2-1 and D2-2 print DEFECT-PRESENT and the script exits 1.
;;;; AFTER the repair all four print CLOSED and the script exits 0.

(require :asdf)
(let ((here (uiop:pathname-directory-pathname *load-pathname*)))
  (uiop:chdir (uiop:pathname-parent-directory-pathname
               (uiop:pathname-parent-directory-pathname
                (uiop:pathname-parent-directory-pathname here))))
  (asdf:initialize-source-registry
   `(:source-registry (:directory ,(uiop:getcwd)) :ignore-inherited-configuration)))
(asdf:load-system "lisp-plus/many-acts-0")

(defpackage #:ma0-d2 (:use #:cl))
(in-package #:ma0-d2)

(defvar *closed* 0)
(defvar *defects* 0)

(defun probe (label closed-p detail)
  (if closed-p (incf *closed*) (incf *defects*))
  (format t "  [~a] ~a~@[  ~a~]~%"
          (if closed-p "CLOSED" "DEFECT-PRESENT") label
          (if (and detail (string/= detail "")) detail nil))
  (force-output))

(defun write-source (root basename text)
  (let ((path (merge-pathnames basename root)))
    (with-open-file (out path :direction :output :if-exists :supersede
                              :external-format :utf-8)
      (write-string text out))
    path))

;;; The sibling leak.  `leaked' is defined ONLY inside the first alternative;
;;; the second alternative references it.  A fresh store makes :execution
;;; :absent, so the SECOND clause is the one selected and the first never runs.
(defparameter +leak-text+ "
(ma0-program
 (:name \"d2-sibling-leak\")
 (:input ())
 (:authority-slots (g1))
 (:steps
  (derive d (:seat \"s\"))
  (branch d
    ((:execution :settled) (bind leaked \"never-runs\") (result (ref leaked)))
    ((:execution :absent)  (result (ref leaked)))
    (otherwise (refuse (:code :neither))))))
")

;;; Control: bound BEFORE the branch, referenced inside alternatives.  Lawful.
(defparameter +pre-branch-text+ "
(ma0-program
 (:name \"d2-pre-branch\")
 (:input ())
 (:authority-slots (g1))
 (:steps
  (bind carried \"bound-before-the-branch\")
  (derive d (:seat \"s\"))
  (branch d
    ((:execution :settled) (result (ref carried)))
    ((:execution :absent)  (result (ref carried)))
    (otherwise (refuse (:code :neither) (ref carried))))))
")

;;; Control: the sealed no-shadowing law.  One definition per whole text.
(defparameter +same-name-twice-text+ "
(ma0-program
 (:name \"d2-same-name-two-alternatives\")
 (:input ())
 (:authority-slots (g1))
 (:steps
  (derive d (:seat \"s\"))
  (branch d
    ((:execution :settled) (bind v \"first\")  (result (ref v)))
    ((:execution :absent)  (bind v \"second\") (result (ref v)))
    (otherwise (refuse (:code :neither))))))
")

(let ((root (uiop:ensure-directory-pathname
             (format nil "~a/ma0-d2-~d/" (or (uiop:getenv "TMPDIR") "/tmp")
                     (random 1000000 (make-random-state t))))))
  (ensure-directories-exist root)
  (unwind-protect
       (let ((leak-path (write-source root "leak.lisp" +leak-text+))
             (pre-path (write-source root "pre-branch.lisp" +pre-branch-text+))
             (twice-path (write-source root "twice.lisp" +same-name-twice-text+))
             (leak-program nil))

         ;; ---- D2-1 -----------------------------------------------------------
         (handler-case
             (let ((p (lisp-plus-many-acts0:ma0-validate leak-path)))
               (setf leak-program p)
               (probe "D2-1 a sibling-alternative reference is refused at validation"
                      nil
                      "the source was ACCEPTED; `leaked' is defined only inside the FIRST alternative"))
           (lisp-plus-many-acts0:ma0-refusal (c)
             (probe "D2-1 a sibling-alternative reference is refused at validation"
                    t
                    (format nil "refused ~a [~a]" (type-of c)
                            (lisp-plus-many-acts0:ma0-refusal-code c)))))

         ;; ---- D2-2 -----------------------------------------------------------
         (if (null leak-program)
             (probe "D2-2 no run can reach the unbound name (nothing was accepted)"
                    t "the validator refused; there is no accepted program to run")
             (let ((environment
                     (lisp-plus-many-acts0:make-ma0-environment
                      :root root :arms '("A")
                      :grants '((:slot "g1" :arm "A"))
                      :revocations '()
                      :seat-map (list (cons "s"
                                            (lisp-plus-language-act0:act-fixture-runtime-seat
                                             (find "A" lisp-plus-language-act0:*act-fixture-table*
                                                   :key #'lisp-plus-language-act0:act-fixture-arm
                                                   :test #'string=))))
                      :inputs '())))
               (handler-case
                   (let ((r (lisp-plus-many-acts0:ma0-run-program leak-program environment)))
                     (probe "D2-2 the accepted program does not die at runtime on the leaked name"
                            nil
                            (format nil "the run completed with disposition ~s — unexpected"
                                    (lisp-plus-many-acts0:ma0-result-disposition r))))
                 (lisp-plus-many-acts0:ma0-refusal (c)
                   (probe "D2-2 the accepted program does not die at runtime on the leaked name"
                          nil
                          (format nil "RUNTIME FAILURE ~a [~a]: ~a — accepted at validation, dead at run"
                                  (type-of c)
                                  (lisp-plus-many-acts0:ma0-refusal-code c)
                                  (lisp-plus-many-acts0:ma0-refusal-detail c)))))))

         ;; ---- D2-3 -----------------------------------------------------------
         (handler-case
             (let ((p (lisp-plus-many-acts0:ma0-validate pre-path)))
               (probe "D2-3 a pre-branch binding referenced inside alternatives stays lawful"
                      (lisp-plus-many-acts0:ma0-validated-program-p p)
                      "accepted"))
           (lisp-plus-many-acts0:ma0-refusal (c)
             (probe "D2-3 a pre-branch binding referenced inside alternatives stays lawful"
                    nil
                    (format nil "WRONGLY REFUSED ~a [~a]" (type-of c)
                            (lisp-plus-many-acts0:ma0-refusal-code c)))))

         ;; ---- D2-4 -----------------------------------------------------------
         (handler-case
             (progn (lisp-plus-many-acts0:ma0-validate twice-path)
                    (probe "D2-4 the sealed no-shadowing law refuses one name defined in two alternatives"
                           nil "the source was ACCEPTED; V-BIND should have refused it"))
           (lisp-plus-many-acts0:ma0-refusal (c)
             (probe "D2-4 the sealed no-shadowing law refuses one name defined in two alternatives"
                    (equal "V-BIND" (lisp-plus-many-acts0:ma0-refusal-code c))
                    (format nil "refused ~a [~a]" (type-of c)
                            (lisp-plus-many-acts0:ma0-refusal-code c))))))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore))

  (format t "~%ma0-D2-branch-binding: ~d closed, ~d defect(s) present~%"
          *closed* *defects*)
  (uiop:quit (if (zerop *defects*) 0 1)))
