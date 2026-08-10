;;;; D3-circular-source.lisp — the CIRCULAR-SOURCE witness (defect D3).
;;;;
;;;; Fresh image.  PUBLIC EXPORTS ONLY.  `ma0-validate' accepts an already-read
;;;; source FORM (its own docstring says so), which is the door used here.
;;;;
;;;; WHAT IT PROVES.  The validator's total walk has no visited set.  Its very
;;;; first act on a cons node is `%ma0-proper-list-p', which chases `cdr' until
;;;; it finds NIL or a non-cons — on a circular cdr chain it finds neither and
;;;; never returns.  The declared node bound (+ma0-max-source-nodes+) cannot
;;;; save it: the counter is incremented once per node ENTERED, and the walk
;;;; never leaves the first circular node to enter a second.  Nothing in this
;;;; lane stops it; only an EXTERNAL watchdog does.
;;;;
;;;; HOW THE RED IS READ.  This script prints its progress markers and then
;;;; calls the validator.  Before the repair the last line printed is
;;;; "D3-1 entering the validator" and the process is killed by `timeout' —
;;;; exit 124, no further output.  THE TIMEOUT IS THE RED.  After the repair the
;;;; validator returns a typed refusal within the declared bound and the script
;;;; runs to its own end and exits 0.
;;;;
;;;; The four fixtures, in order:
;;;;   D3-1  a self-referential list, alone in the :steps position
;;;;   D3-2  a cycle nested inside an otherwise-lawful program
;;;;   D3-3  a long FINITE source just inside the declared node bound (accepted)
;;;;   D3-4  a source BEYOND the declared node bound (refused by the bound)
;;;;   D3-5  an ordinary lawful source (accepted)
;;;;
;;;; D3-3..D3-5 are controls: they are reachable only if D3-1 and D3-2 return at
;;;; all, which before the repair they do not.

(require :asdf)
(let ((here (uiop:pathname-directory-pathname *load-pathname*)))
  (uiop:chdir (uiop:pathname-parent-directory-pathname
               (uiop:pathname-parent-directory-pathname
                (uiop:pathname-parent-directory-pathname here))))
  (asdf:initialize-source-registry
   `(:source-registry (:directory ,(uiop:getcwd)) :ignore-inherited-configuration)))
(asdf:load-system "lisp-plus/many-acts-0")

(defpackage #:ma0-d3 (:use #:cl))
(in-package #:ma0-d3)

(defvar *closed* 0)
(defvar *defects* 0)

(defun probe (label closed-p detail)
  (if closed-p (incf *closed*) (incf *defects*))
  (format t "  [~a] ~a~@[  ~a~]~%"
          (if closed-p "CLOSED" "DEFECT-PRESENT") label
          (if (and detail (string/= detail "")) detail nil))
  (force-output))

(defun marker (fmt &rest args)
  (format t "  -- ~a~%" (apply #'format nil fmt args))
  (force-output))

(defun sym (name)
  "A symbol homed in the program namespace — exactly what the lane's own reader
would produce.  `intern' against a package the lane exports the NAME of; no
unexported symbol is referenced."
  (intern name (find-package '#:lisp-plus-many-acts0.program)))

(defun program-form (steps)
  (list (sym "MA0-PROGRAM")
        (list :name "d3-subject")
        (list :input '())
        (list :authority-slots (list (sym "G1")))
        (cons :steps steps)))

(defun circular-list ()
  "A proper-looking list whose last cdr points back at its head."
  (let ((c (list 1 2 3)))
    (setf (cdr (last c)) c)
    c))

(defun expect-refusal (label form must-say)
  "Refused with code V-SHAPE, and the DETAIL must name the sub-law that fired.
A probe that accepts any refusal cannot tell the tree law from the node bound,
and those are the two things these fixtures are here to separate."
  (handler-case
      (progn (lisp-plus-many-acts0:ma0-validate form)
             (probe label nil "the source was ACCEPTED"))
    (lisp-plus-many-acts0:ma0-refusal (c)
      (let ((code (lisp-plus-many-acts0:ma0-refusal-code c))
            (detail (lisp-plus-many-acts0:ma0-refusal-detail c)))
        (probe label
               (and (equal "V-SHAPE" code) (search must-say detail))
               (format nil "refused ~a [~a]; detail ~a ~s"
                       (type-of c) code
                       (if (search must-say detail) "names" "DOES NOT NAME")
                       must-say))))
    (error (c)
      (probe label nil (format nil "an UNTYPED condition escaped: ~a" (type-of c))))))

(defun expect-acceptance (label form)
  (handler-case
      (let ((p (lisp-plus-many-acts0:ma0-validate form)))
        (probe label (lisp-plus-many-acts0:ma0-validated-program-p p) "accepted"))
    (error (c)
      (probe label nil (format nil "WRONGLY REFUSED: ~a" (type-of c))))))

(defparameter +tree-law+ "a lawful source is a TREE")
(defparameter +bound-law+ "node count exceeds the declared bound")

;;; ---- D3-1 -------------------------------------------------------------------
(marker "D3-1 building a self-referential list")
(let ((form (program-form (list (circular-list)))))
  (marker "D3-1 entering the validator (in the PRE-REPAIR transcript this is the LAST LINE)")
  (expect-refusal "D3-1 a self-referential list terminates in a typed refusal"
                  form +tree-law+))

;;; ---- D3-2 -------------------------------------------------------------------
(marker "D3-2 building a cycle nested in an otherwise-lawful program")
(let* ((cycle (circular-list))
       (form (program-form
              (list (list (sym "BIND") (sym "V") 1)
                    (list (sym "RESULT") (list (sym "LIST") 1 cycle))))))
  (marker "D3-2 entering the validator")
  (expect-refusal "D3-2 a nested cycle terminates in a typed refusal"
                  form +tree-law+))

;;; ---- D3-2b — THE DECLARED POLICY, TESTED RATHER THAN MERELY STATED ----------
;;; ACYCLIC shared substructure is refused too.  This lane's chosen rule is not
;;; "no cycles" but "a source is a TREE", and a rule nothing exercises is a
;;; sentence, not a rule.  The structure below terminates under any walk; it is
;;; refused because ONE cons is reached twice.
(marker "D3-2b building an ACYCLIC shared substructure (a DAG, not a cycle)")
(let* ((shared (list 1 2 3))
       (form (program-form
              (list (list (sym "RESULT")
                          (list (sym "LIST") shared shared))))))
  (expect-refusal "D3-2b acyclic SHARED substructure is refused by the same tree law"
                  form +tree-law+))

;;; ---- D3-3 -------------------------------------------------------------------
;;; A long FINITE source, deliberately under the declared node bound.  Each
;;; extra `(bind vN "s")' step is 4 nodes; 300 steps is ~1200 nodes, safely
;;; inside 4096, and the tail is a lawful terminal.
(marker "D3-3 building a long finite source (300 bind steps)")
(let* ((steps (append (loop for i from 1 to 300
                            collect (list (sym "BIND")
                                          (sym (format nil "V~d" i))
                                          "s"))
                      (list (list (sym "RESULT") 1))))
       (form (program-form steps)))
  (expect-acceptance "D3-3 a long finite source just inside the node bound is accepted"
                     form))

;;; ---- D3-4 -------------------------------------------------------------------
(marker "D3-4 building a source beyond the declared node bound (3000 bind steps)")
(let* ((steps (append (loop for i from 1 to 3000
                            collect (list (sym "BIND")
                                          (sym (format nil "W~d" i))
                                          "s"))
                      (list (list (sym "RESULT") 1))))
       (form (program-form steps)))
  (expect-refusal "D3-4 a source beyond the declared node bound is refused by the bound"
                  form +bound-law+))

;;; ---- D3-5 -------------------------------------------------------------------
(marker "D3-5 an ordinary lawful source")
(expect-acceptance "D3-5 an ordinary lawful source is still accepted"
                   (program-form (list (list (sym "BIND") (sym "V") "ordinary")
                                       (list (sym "RESULT") (list (sym "REF") (sym "V"))))))

(format t "~%ma0-D3-circular-source: ~d closed, ~d defect(s) present~%"
        *closed* *defects*)
(uiop:quit (if (zerop *defects*) 0 1))
