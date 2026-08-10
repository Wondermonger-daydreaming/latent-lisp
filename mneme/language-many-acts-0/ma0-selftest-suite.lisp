;;;; ma0-selftest-suite.lisp — the lane's own suite.
;;;;
;;;; CANDIDATE.  Running a candidate is not adopting it (contract §0, §8).
;;;;
;;;; ---------------------------------------------------------------------------
;;;; WHAT THIS SUITE COVERS, AND WHAT IT DOES NOT
;;;; ---------------------------------------------------------------------------
;;;;
;;;; COVERED: the validator laws (all W-V-*), the runtime laws this hand can
;;;; reach (W-AUTH-EXPLICIT · W-BRANCH-ONE · W-BRANCH-EXACT · W-UNCERTAIN-HALT ·
;;;; W-NO-ERASE · W-DERIVE-NE-PERFORM · W-IMMUTABLE · W-ORDER-STORE ·
;;;; W-RESULT-STRUCT · W-REFUSE-LAWFUL · W-ERROR-PROPAGATES), the W-GENERIC
;;;; grep, and the no-internals grep.
;;;;
;;;; ⚠ NOT COVERED, AND THE ABSENCE IS DECLARED RATHER THAN LEFT TO BE NOTICED:
;;;; the CONCORDANCE teeth (W-CONCORD-*, the re-composition risk the contract
;;;; calls this lane's most serious possible defect), the PLANTED DISEASES
;;;; (D-BOTH-ARMS · D-AMBIENT · D-AUTO-RETRY · D-SKIP-VALIDATE ·
;;;; D-SPECIAL-CASE), W-VF-UNCHANGED, W-ONEACT-GREEN, W-FLOOR-UNTOUCHED,
;;;; W-NO-BLIND-REPLAY, W-RES-NOT-AUTH's hostile-driver half, and W-P3-HOLDOUT.
;;;; A GREEN RUN OF THIS SUITE THEREFORE SAYS NOTHING ABOUT WHETHER THIS LANE'S
;;;; COMPOSITION AGREES WITH THE CANONICAL ONE.  It says the laws below hold.
;;;;
;;;; ⚠ THE COUNT IS OBSERVED, NOT AUTHORIZED.  One Act /0 asserts 173 and fails
;;;; closed off it, which is right for a suite whose count has been accepted.
;;;; This one has never been accepted by anybody, so an "authorized" count here
;;;; would be a number this hand invented wearing a floor's clothes.  The suite
;;;; prints what it counted; a later hand may freeze it.
;;;;
;;;; ⚠ THE TOOTH: MA0_SELFTEST_PLANT_FAULT=1 infects one check.  A harness that
;;;; has never failed is untested, not passing — and the two GREP gates get the
;;;; same treatment: each is run against a planted violation and must FIRE
;;;; before its clean pass over the real sources is reported.
;;;;
;;;; — FABER (Claude Opus 5, subagent), 2026-08-09

(in-package #:lisp-plus-many-acts0)

;;; ===========================================================================
;;; §0 — transcript primitives.  Every assertion PRINTS.
;;; ===========================================================================

(defvar *ma0-passed* 0)
(defvar *ma0-failed* 0)

(defun ma0-note (fmt &rest args)
  (format t "~&    ~a~%" (apply #'format nil fmt args))
  (force-output))

(defun ma0-check (name ok &optional (fmt "") &rest args)
  "Print one stable check-line and record its verdict.  NEVER adjusts an input
to make an output come out."
  (if ok (incf *ma0-passed*) (incf *ma0-failed*))
  (format t "~&  [~a] ~a~@[  ~a~]~%"
          (if ok "PASS" "FAIL") name
          (let ((s (apply #'format nil fmt args))) (if (string= s "") nil s)))
  (force-output)
  (and ok t))

(defparameter *ma0-lane-directory*
  (make-pathname :name nil :type nil :defaults (or *load-truename*
                                                   *compile-file-truename*))
  "This lane's own directory, taken from THIS file's location — checkout- and
cwd-independent.")

;;; ===========================================================================
;;; §1 — the validator witnesses.  Sources are written to a scratch directory
;;; and read through the lane's OWN reader, so V-READ is exercised for real.
;;; ===========================================================================

(defun %ma0-scratch-write (directory basename text)
  (let ((path (merge-pathnames basename directory)))
    (with-open-file (out path :direction :output :if-exists :supersede
                              :external-format :utf-8)
      (write-string text out))
    path))

(defun %ma0-scratch-basename (name)
  "NAME as a safe file basename.  ⚠ THIS FUNCTION EXISTS BECAUSE THE CHECK NAME
IS THE FILENAME.  A fixture label containing a `/' produced a path with a
directory component that did not exist, and the suite died with a
SIMPLE-FILE-ERROR mid-section — reporting `0 checks, 0 failures' and withholding
its sentinel, which is the right behaviour for an error but tells the author
nothing about the cause.  Found by an R1 fixture labelled `R1/D2 …'."
  (substitute #\- #\\ (substitute #\- #\/ name)))

(defun %ma0-expect-refusal (directory name text type code)
  "Assert that TEXT is refused with condition TYPE and refusal code CODE."
  (let ((path (%ma0-scratch-write
               directory
               (format nil "~a.lisp" (%ma0-scratch-basename name)) text)))
    (handler-case
        (progn (ma0-validate path)
               (ma0-check name nil "the source was ACCEPTED; expected ~a [~a]"
                          type code))
      (ma0-refusal (c)
        (ma0-check name
                   (and (typep c type) (equal code (ma0-refusal-code c)))
                   "type=~a code=~s (expected ~a ~s)"
                   (type-of c) (ma0-refusal-code c) type code))
      (error (c)
        (ma0-check name nil "an UNTYPED condition escaped the validator: ~a"
                   (type-of c))))))

(defparameter +ma0-lawful-skeleton+ "
(ma0-program
 (:name \"skeleton\")
 (:input (label))
 (:authority-slots (g))
 (:steps
  (derive pre (:seat \"s\"))
  (branch pre
    ((:execution :absent) (result (ref label)))
    (otherwise (refuse (:code :occupied))))))
")

(defun %ma0-validator-witnesses (directory)
  (format t "~&~%== VALIDATOR WITNESSES (all refusals typed, pre-act, footprint-free) ==~%")

  ;; ---- the lawful skeleton is ACCEPTED.  A refuser that refuses everything
  ;; ---- is not a validator, and every red witness below would be vacuous
  ;; ---- without this one green.
  (let ((path (%ma0-scratch-write directory "skeleton.lisp"
                                  +ma0-lawful-skeleton+)))
    (handler-case
        (let ((p (ma0-validate path)))
          (ma0-check "W-V-BASELINE the lawful skeleton is accepted"
                     (ma0-validated-program-p p))
          (ma0-check "W-V-BASELINE name reads back"
                     (equal "skeleton" (ma0-program-name p))))
      (error (c)
        (ma0-check "W-V-BASELINE the lawful skeleton is accepted" nil
                   "refused with ~a" (type-of c))
        (ma0-check "W-V-BASELINE name reads back" nil "not reached"))))

  ;; ---- W-V-SHAPE ---------------------------------------------------------
  (%ma0-expect-refusal directory "W-V-SHAPE unknown program head"
                       "(ma0-programme (:name \"x\") (:input ()) (:authority-slots (g)) (:steps (result 1)))"
                       'ma0-source-refused "V-SHAPE")
  (%ma0-expect-refusal directory "W-V-SHAPE dotted pair"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g)) (:steps (result . 1)))"
                       'ma0-source-refused "V-SHAPE")
  (%ma0-expect-refusal directory "W-V-SHAPE missing clause"
                       "(ma0-program (:name \"x\") (:input ()) (:steps (result 1)))"
                       'ma0-source-refused "V-SHAPE")
  (%ma0-expect-refusal directory "W-V-SHAPE two forms in one file"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g)) (:steps (result 1))) (result 2)"
                       'ma0-source-refused "V-SHAPE")
  (%ma0-expect-refusal directory "W-V-SHAPE bare ident as a value"
                       "(ma0-program (:name \"x\") (:input (a)) (:authority-slots (g)) (:steps (result a)))"
                       'ma0-source-refused "V-SHAPE")

  ;; ---- W-V-READ ----------------------------------------------------------
  (%ma0-expect-refusal directory "W-V-READ reader-eval cannot reach the validator"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g)) (:steps (result #.(+ 1 2))))"
                       'ma0-source-refused "V-READ")

  ;; ---- W-V-DATA ----------------------------------------------------------
  (%ma0-expect-refusal directory "W-V-DATA a vector is not admitted"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g)) (:steps (result #(1 2 3))))"
                       'ma0-source-refused "V-DATA")
  (%ma0-expect-refusal directory "W-V-DATA a character is not admitted"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g)) (:steps (result #\\a)))"
                       'ma0-source-refused "V-DATA")
  (%ma0-expect-refusal directory "W-V-DATA a float is not admitted"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g)) (:steps (result 1.5)))"
                       'ma0-source-refused "V-DATA")
  (%ma0-expect-refusal directory "W-V-DATA a pathname is not admitted"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g)) (:steps (result #p\"/etc/passwd\")))"
                       'ma0-source-refused "V-DATA")

  ;; ---- W-V-PKG -----------------------------------------------------------
  (%ma0-expect-refusal directory "W-V-PKG a host-package symbol is refused"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g)) (:steps (cl:list 1)))"
                       'ma0-source-refused "V-PKG")
  (%ma0-expect-refusal directory "W-V-PKG an uninterned symbol is refused"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g)) (:steps (result #:sneaky)))"
                       'ma0-source-refused "V-PKG")

  ;; ---- W-V-BIND ----------------------------------------------------------
  (%ma0-expect-refusal directory "W-V-BIND use before define"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g)) (:steps (result (ref nowhere))))"
                       'ma0-binding-refused "V-BIND")
  (%ma0-expect-refusal directory "W-V-BIND duplicate definition"
                       "(ma0-program (:name \"x\") (:input (a)) (:authority-slots (g)) (:steps (bind a 1) (result (ref a))))"
                       'ma0-binding-refused "V-BIND")
  (%ma0-expect-refusal directory "W-V-BIND no shadowing across branch arms"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (derive d (:seat \"s\"))
         (branch d ((:execution :absent) (bind v 1) (result (ref v)))
                   (otherwise (bind v 2) (result (ref v))))))"
                       'ma0-binding-refused "V-BIND")

  ;; ---- W-V-FIELD ---------------------------------------------------------
  (%ma0-expect-refusal directory "W-V-FIELD field over an act-result"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (act a (:arm \"A\") (:authority-slot g)) (result (field a :execution))))"
                       'ma0-binding-refused "V-FIELD")
  (%ma0-expect-refusal directory "W-V-FIELD field over an ordinary value"
                       "(ma0-program (:name \"x\") (:input (a)) (:authority-slots (g)) (:steps (result (field a :execution))))"
                       'ma0-binding-refused "V-FIELD")
  (%ma0-expect-refusal directory "W-V-FIELD ref over a derived outcome"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (derive d (:seat \"s\")) (result (ref d))))"
                       'ma0-binding-refused "V-FIELD")
  (%ma0-expect-refusal directory "W-V-FIELD branch head is an ordinary value"
                       "(ma0-program (:name \"x\") (:input (a)) (:authority-slots (g))
 (:steps (branch a ((:execution :absent) (result 1)) (otherwise (result 2)))))"
                       'ma0-binding-refused "V-FIELD")

  ;; ---- W-V-AUTH ----------------------------------------------------------
  (%ma0-expect-refusal directory "W-V-AUTH a string in authority position"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (act a (:arm \"A\") (:authority-slot \"g\")) (result 1)))"
                       'ma0-binding-refused "V-RES-AUTH")
  (%ma0-expect-refusal directory "W-V-AUTH an undeclared slot"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (act a (:arm \"A\") (:authority-slot other)) (result 1)))"
                       'ma0-binding-refused "V-AUTH")
  (%ma0-expect-refusal directory "W-V-AUTH an act-result in authority position"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (act first-act (:arm \"A\") (:authority-slot g))
         (act second-act (:arm \"C-i\") (:authority-slot first-act))
         (result 1)))"
                       'ma0-binding-refused "V-AUTH")
  (%ma0-expect-refusal directory "W-V-AUTH a slot is not a value"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g)) (:steps (result (ref g))))"
                       'ma0-binding-refused "V-BIND")

  ;; ---- W-V-ARM -----------------------------------------------------------
  (%ma0-expect-refusal directory "W-V-ARM an unknown arm"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (act a (:arm \"Z\") (:authority-slot g)) (result 1)))"
                       'ma0-source-refused "V-ARM")
  (%ma0-expect-refusal directory "W-V-ARM the same arm twice, STATICALLY"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (act a (:arm \"A\") (:authority-slot g))
         (act b (:arm \"A\") (:authority-slot g))
         (result 1)))"
                       'ma0-source-refused "V-ARM")

  ;; ---- W-V-PATTERN -------------------------------------------------------
  (%ma0-expect-refusal directory "W-V-PATTERN an unknown axis"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (derive d (:seat \"s\"))
         (branch d ((:success :yes) (result 1)) (otherwise (result 2)))))"
                       'ma0-pattern-refused "V-PATTERN")
  (%ma0-expect-refusal directory "W-V-PATTERN an unknown axis value"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (derive d (:seat \"s\"))
         (branch d ((:execution :probably) (result 1)) (otherwise (result 2)))))"
                       'ma0-pattern-refused "V-PATTERN")
  (%ma0-expect-refusal directory "W-V-PATTERN a missing otherwise"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (derive d (:seat \"s\"))
         (branch d ((:execution :absent) (result 1)) ((:execution :settled) (result 2)))))"
                       'ma0-pattern-refused "V-PATTERN")
  (%ma0-expect-refusal directory "W-V-PATTERN a duplicate clause pattern"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (derive d (:seat \"s\"))
         (branch d ((:and (:execution :absent) (:provenance :none)) (result 1))
                   ((:and (:provenance :none) (:execution :absent)) (result 2))
                   (otherwise (result 3)))))"
                       'ma0-pattern-refused "V-PATTERN")
  (%ma0-expect-refusal directory "W-V-PATTERN one axis named twice in a conjunction"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (derive d (:seat \"s\"))
         (branch d ((:and (:execution :absent) (:execution :settled)) (result 1))
                   (otherwise (result 2)))))"
                       'ma0-pattern-refused "V-PATTERN")
  (%ma0-expect-refusal directory "W-V-PATTERN an outcome axis over an act-result"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (act a (:arm \"A\") (:authority-slot g))
         (branch a ((:execution :settled) (result 1)) (otherwise (result 2)))))"
                       'ma0-pattern-refused "V-PATTERN")

  ;; ---- W-V-TERM ----------------------------------------------------------
  (%ma0-expect-refusal directory "W-V-TERM a missing terminal"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (derive d (:seat \"s\"))))"
                       'ma0-source-refused "V-TERM")
  (%ma0-expect-refusal directory "W-V-TERM a step after a terminal"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (result 1) (derive d (:seat \"s\"))))"
                       'ma0-source-refused "V-TERM")
  (%ma0-expect-refusal directory "W-V-TERM a branch arm that does not terminate"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (derive d (:seat \"s\"))
         (branch d ((:execution :absent) (bind v 1)) (otherwise (result 2)))))"
                       'ma0-source-refused "V-TERM")

  ;; ---- W-V-RETRY ---------------------------------------------------------
  (%ma0-expect-refusal directory "W-V-RETRY there is no retry step"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (retry a (:arm \"A\")) (result 1)))"
                       'ma0-source-refused "V-RETRY")
  (%ma0-expect-refusal directory "W-V-RETRY there is no reconcile step"
                       "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (reconcile a) (result 1)))"
                       'ma0-source-refused "V-RETRY")
  (%ma0-expect-refusal directory "W-V-RETRY value computation is not admitted"
                       "(ma0-program (:name \"x\") (:input (a)) (:authority-slots (g))
 (:steps (bind v (concatenate (ref a) \"!\")) (result (ref v))))"
                       'ma0-source-refused "V-RETRY")
  t)

;;; ===========================================================================
;;; §2 — W-V-FOOTPRINT and W-IMMUTABLE, in this image.
;;; ===========================================================================

(defun %ma0-directory-entries (directory)
  (append (directory (merge-pathnames "*.*" directory))
          (directory (merge-pathnames "*/" directory))))

(defun %ma0-footprint-witness (directory)
  (format t "~&~%== W-V-FOOTPRINT ==~%")
  (let* ((entries (%ma0-directory-entries directory))
         (names (mapcar #'file-namestring entries))
         (subdirs (remove-if-not (lambda (p) (null (pathname-name p))) entries)))
    (ma0-note "scratch directory holds ~d entries" (length entries))
    ;; Every refused source above ran through the validator.  If ANY of them
    ;; had reached the environment, a `store/', `world-apply/' or
    ;; `world-ambiguous/' directory would stand here.
    (ma0-check "W-V-FOOTPRINT no store or world directory exists"
               (null subdirs)
               "subdirectories: ~s" (mapcar #'namestring subdirs))
    (ma0-check "W-V-FOOTPRINT every entry is a source file this suite wrote"
               (every (lambda (n) (and n (search ".lisp" n))) names)
               "entries: ~s" names)))

(defun %ma0-immutability-witness (directory)
  (format t "~&~%== W-IMMUTABLE ==~%")
  (let* ((path (%ma0-scratch-write directory "immutable.lisp"
                                   +ma0-lawful-skeleton+))
         (program (ma0-validate path))
         (first-copy (ma0-program-source program))
         (second-copy (ma0-program-source program)))
    (ma0-check "W-IMMUTABLE ma0-program-source hands out a fresh copy"
               (not (eq first-copy second-copy)))
    (ma0-check "W-IMMUTABLE the two copies are equal"
               (equal first-copy second-copy))
    (setf (second first-copy) (list :name "vandalised"))
    (ma0-check "W-IMMUTABLE mutating a returned copy leaves the original unchanged"
               (equal "skeleton" (ma0-program-name program)))
    (ma0-check "W-IMMUTABLE a later copy is unchanged by the mutation"
               (equal second-copy (ma0-program-source program)))
    (dolist (reader '(ma0-program-name ma0-program-source
                      ma0-result-disposition ma0-result-value
                      ma0-result-act-summaries ma0-act-summary-class
                      ma0-environment-store-id))
      (ma0-check (format nil "W-IMMUTABLE no (setf ~a) exists" reader)
                 (not (fboundp (list 'setf reader)))))))

;;; ===========================================================================
;;; §2b — THE R1 REGRESSION FLOOR.  One check per repaired defect-behaviour,
;;; added so that a future hand who reintroduces one of these does not have to
;;; read a transcript to find out.
;;;
;;; ⚠ WHAT LIVES HERE AND WHAT DOES NOT.  These are the IN-IMAGE laws: the
;;; ownership primitive, the validator's binding discipline, the tree walk.
;;; The two repairs whose witnesses need MORE THAN ONE IMAGE OR A REAL STORE —
;;; the environment-side ownership boundary and the zero-footprint stale-
;;; environment refusal — stay in `r1/D1-ownership.lisp' and
;;; `r1/D4-env-crosswire.lisp', which the teeth run.  That is the split this
;;; lane already uses (suite = laws reachable in one image; teeth = everything
;;; that needs its own store), and D4 in particular CANNOT be witnessed here:
;;; it requires building a second environment, which would take the run-state
;;; specials away from anything the suite did afterwards.
;;; ===========================================================================

(defun %ma0-r1-own-witnesses ()
  (format t "~&~%== R1/D1 — OWNERSHIP (both directions, MUTABLE LEAVES) ==~%")

  ;; ---- THE CONTRAST THAT MAKES THE REPAIR LEGIBLE.  `copy-tree' is not a
  ;; ---- defensive copy for a language whose atoms include strings.  Asserted
  ;; ---- rather than described, so the reason `%ma0-own' exists is a check.
  (let* ((original (list (copy-seq "leaf")))
         (cloned (copy-tree original)))
    (setf (char (first cloned) 0) #\X)
    (ma0-check "R1/D1 CONTRAST copy-tree shares mutable leaves (why %ma0-own exists)"
               (char= #\X (char (first original) 0))
               "original now ~s" (first original)))

  (let* ((original (list (copy-seq "alpha") (list (copy-seq "beta")) 'sym 7 :kw))
         (owned (%ma0-own original)))
    (ma0-check "R1/D1 %ma0-own returns an EQUAL structure"
               (equal original owned))
    (ma0-check "R1/D1 %ma0-own copies the spine"
               (not (eq original owned)))
    (ma0-check "R1/D1 %ma0-own copies a TOP-LEVEL string leaf"
               (not (eq (first original) (first owned))))
    (ma0-check "R1/D1 %ma0-own copies a NESTED string leaf"
               (not (eq (first (second original)) (first (second owned)))))
    (ma0-check "R1/D1 %ma0-own SHARES symbols (the binding table depends on EQ)"
               (eq (third original) (third owned)))

    ;; DIRECTION i — the caller mutates what it handed over.
    (setf (char (first original) 0) #\Z)
    (ma0-check "R1/D1 direction i: mutating the ORIGINAL leaves the owned copy alone"
               (equal "alpha" (first owned))
               "owned=~s" (first owned))
    ;; DIRECTION ii — the caller mutates what it was handed back.
    (setf (char (first (second owned)) 0) #\Z)
    (ma0-check "R1/D1 direction ii: mutating the OWNED copy leaves the original alone"
               (equal "beta" (first (second original)))
               "original=~s" (first (second original))))

  (let* ((bytes (make-array 3 :element-type '(unsigned-byte 8)
                              :initial-contents '(1 2 3)))
         (owned (%ma0-own bytes)))
    (setf (aref owned 0) 99)
    (ma0-check "R1/D1 %ma0-own copies an admitted mutable BYTE VECTOR"
               (and (= 1 (aref bytes 0)) (= 99 (aref owned 0)))
               "original[0]=~d owned[0]=~d" (aref bytes 0) (aref owned 0)))

  ;; ---- TOOTH.  The walk budget is a termination guard; a guard that has
  ;; ---- never fired is untested, not passing.
  (handler-case
      (progn (%ma0-own (make-list (+ +ma0-max-owned-nodes+ 16)))
             (ma0-check "R1/D1 TOOTH the ownership budget REFUSES an oversized datum"
                        nil "no refusal was signalled"))
    (ma0-refusal (c)
      (ma0-check "R1/D1 TOOTH the ownership budget REFUSES an oversized datum"
                 (equal "MA0-OWN-BOUND" (ma0-refusal-code c))
                 "code=~s" (ma0-refusal-code c)))))

(defun %ma0-r1-source-ownership (directory)
  (format t "~&~%== R1/D1 — THE SOURCE BOUNDARY, both directions ==~%")
  (let* ((path (%ma0-scratch-write directory "r1-own.lisp" +ma0-lawful-skeleton+))
         (program (ma0-validate path))
         (copy (ma0-program-source program)))
    ;; DIRECTION ii — mutate a reader's output; the retained source must not move.
    (let ((seat (find-if #'stringp (fourth (fifth copy)))))
      (declare (ignorable seat)))
    (labels ((first-string (tree)
               (cond ((stringp tree) tree)
                     ((consp tree) (or (first-string (car tree))
                                       (first-string (cdr tree))))
                     (t nil))))
      (let ((s (first-string copy)))
        (ma0-check "R1/D1 the source readback contains a string to mutate"
                   (stringp s) "found ~s" s)
        (when (stringp s)
          (let ((before (copy-seq s)))
            (setf (char s 0) #\Z)
            (let ((fresh (first-string (ma0-program-source program))))
              (ma0-check "R1/D1 mutating a returned SOURCE string leaves the retained source alone"
                         (equal before fresh)
                         "was ~s; fresh readback ~s" before fresh))))))
    ;; The name reader hands out a fresh string every call.
    (let ((n1 (ma0-program-name program))
          (n2 (ma0-program-name program)))
      (ma0-check "R1/D1 ma0-program-name hands out a FRESH string each call"
                 (and (equal n1 n2) (not (eq n1 n2))))
      (setf (char n1 0) #\Z)
      (ma0-check "R1/D1 mutating a returned name leaves the program's name alone"
                 (equal "skeleton" (ma0-program-name program))
                 "now ~s" (ma0-program-name program)))))

(defun %ma0-r1-branch-fixtures (directory)
  (format t "~&~%== R1/D2 — PATH-SENSITIVE BRANCH BINDING ==~%")

  ;; The defect itself: a name bound ONLY in an earlier alternative, referenced
  ;; by a later one.  Accepted before the repair; refused now.
  (%ma0-expect-refusal
   directory "R1/D2 a later alternative may not see an earlier one's binding"
   "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (derive d (:seat \"s\"))
         (branch d ((:execution :settled) (bind leaked 1) (result (ref leaked)))
                   ((:execution :absent) (result (ref leaked)))
                   (otherwise (refuse (:code :neither))))))"
   'ma0-binding-refused "V-BIND")

  ;; The same leak reaching the `otherwise' clause.
  (%ma0-expect-refusal
   directory "R1/D2 the otherwise clause may not see an alternative's binding"
   "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (derive d (:seat \"s\"))
         (branch d ((:execution :settled) (bind leaked 1) (result (ref leaked)))
                   (otherwise (result (ref leaked))))))"
   'ma0-binding-refused "V-BIND")

  ;; GREEN CONTROL — the repair must not be "refuse every branch".  A binding
  ;; made BEFORE the branch is bound on every path that reaches it, and stays
  ;; visible inside every alternative (GRAMMAR §3).
  (let ((path (%ma0-scratch-write
               directory "r1-pre-branch.lisp"
               "(ma0-program (:name \"pre-branch\") (:input ()) (:authority-slots (g))
 (:steps (bind carried \"before\")
         (derive d (:seat \"s\"))
         (branch d ((:execution :settled) (result (ref carried)))
                   ((:execution :absent) (result (ref carried)))
                   (otherwise (refuse (:code :neither) (ref carried))))))")))
    (handler-case
        (ma0-check "R1/D2 CONTROL a pre-branch binding stays visible in every alternative"
                   (ma0-validated-program-p (ma0-validate path)))
      (error (c)
        (ma0-check "R1/D2 CONTROL a pre-branch binding stays visible in every alternative"
                   nil "WRONGLY REFUSED with ~a" (type-of c)))))

  ;; THE SEALED NO-SHADOWING LAW IS UNTOUCHED.  `defined' is cumulative, so one
  ;; name defined in two alternatives is still refused — the same law the
  ;; suite's own "W-V-BIND no shadowing across branch arms" fixture asserts.
  (%ma0-expect-refusal
   directory "R1/D2 the sealed define-once law still spans sibling alternatives"
   "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (derive d (:seat \"s\"))
         (branch d ((:execution :settled) (bind v 1) (result (ref v)))
                   ((:execution :absent) (bind v 2) (result (ref v)))
                   (otherwise (refuse (:code :neither))))))"
   'ma0-binding-refused "V-BIND")

  ;; AND SO IS V-ARM.  `arms' is deliberately not restored between
  ;; alternatives: one arm may not appear twice in the text however the branch
  ;; happens to fall, because its runtime seat is consumed once per store.
  (%ma0-expect-refusal
   directory "R1/D2 V-ARM still spans sibling alternatives (arms are not restored)"
   "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (derive d (:seat \"s\"))
         (branch d ((:execution :settled) (act p (:arm \"A\") (:authority-slot g))
                                          (result 1))
                   (otherwise (act q (:arm \"A\") (:authority-slot g))
                              (result 2)))))"
   'ma0-source-refused "V-ARM")

  ;; ⚠ THE VACUITY WITNESS.  The post-branch definite-boundness question cannot
  ;; arise, because no step may follow a branch.  This is the fixture that
  ;; makes that a fact rather than a reading of GRAMMAR §3.
  (%ma0-expect-refusal
   directory "R1/D2 THE VACUITY WITNESS no step may follow a branch (V-TERM)"
   "(ma0-program (:name \"x\") (:input ()) (:authority-slots (g))
 (:steps (derive d (:seat \"s\"))
         (branch d ((:execution :absent) (result 1)) (otherwise (result 2)))
         (result 3)))"
   'ma0-source-refused "V-TERM"))

(defun %ma0-r1-tree-fixtures ()
  (format t "~&~%== R1/D3 — A LAWFUL SOURCE IS A TREE (bounded, terminating) ==~%")
  (labels ((sym (name) (intern name (find-package '#:lisp-plus-many-acts0.program)))
           (program-form (steps)
             (list (sym "MA0-PROGRAM") (list :name "r1-tree")
                   (list :input '()) (list :authority-slots (list (sym "G")))
                   (cons :steps steps)))
           (circular ()
             (let ((c (list 1 2 3))) (setf (cdr (last c)) c) c))
           (expect (label form must-say)
             (handler-case
                 (progn (ma0-validate form)
                        (ma0-check label nil "the source was ACCEPTED"))
               (ma0-refusal (c)
                 (ma0-check label
                            (and (equal "V-SHAPE" (ma0-refusal-code c))
                                 (search must-say (ma0-refusal-detail c)))
                            "code=~s detail~:[ DOES NOT NAME~; names~] ~s"
                            (ma0-refusal-code c)
                            (search must-say (ma0-refusal-detail c)) must-say))))
           (expect-ok (label form)
             (handler-case
                 (ma0-check label (ma0-validated-program-p (ma0-validate form)))
               (error (c)
                 (ma0-check label nil "WRONGLY REFUSED with ~a" (type-of c))))))

    (expect "R1/D3 a self-referential list is refused, and TERMINATES"
            (program-form (list (circular)))
            "a lawful source is a TREE")

    (expect "R1/D3 a cycle nested in an otherwise-lawful program is refused"
            (program-form (list (list (sym "BIND") (sym "V") 1)
                                (list (sym "RESULT")
                                      (list (sym "LIST") 1 (circular)))))
            "a lawful source is a TREE")

    ;; The DECLARED POLICY, exercised: acyclic sharing is refused too.
    (let ((shared (list 1 2 3)))
      (expect "R1/D3 acyclic SHARED substructure is refused by the same law"
              (program-form (list (list (sym "RESULT")
                                        (list (sym "LIST") shared shared))))
              "a lawful source is a TREE"))

    (expect-ok "R1/D3 CONTROL a long FINITE source inside the node bound is accepted"
               (program-form (append (loop for i from 1 to 300
                                           collect (list (sym "BIND")
                                                         (sym (format nil "V~d" i))
                                                         "s"))
                                     (list (list (sym "RESULT") 1)))))

    (expect "R1/D3 a source beyond the declared node bound is refused BY THE BOUND"
            (program-form (append (loop for i from 1 to 3000
                                        collect (list (sym "BIND")
                                                      (sym (format nil "W~d" i))
                                                      "s"))
                                  (list (list (sym "RESULT") 1))))
            "node count exceeds the declared bound")

    (expect-ok "R1/D3 CONTROL an ordinary lawful source is still accepted"
               (program-form (list (list (sym "BIND") (sym "V") "ordinary")
                                   (list (sym "RESULT")
                                         (list (sym "REF") (sym "V"))))))))

;;; ---------------------------------------------------------------------------
;;; R1/D5 — THE GENERATION COUNTER ITSELF.
;;;
;;; ⚠ THIS LIVES IN THE SUITE, NOT IN r1/D5-generation-seam.lisp, AND THAT IS
;;; THE POINT.  The counter is package-internal and exposed by nothing — which
;;; is exactly what the no-exposure proof requires — so a public-only witness
;;; can see only its SHADOW (which environments went stale).  The suite is
;;; in-package and can read the integer.  The two halves are complementary:
;;; the witness proves the behaviour a caller can observe, this proves the
;;; invariant a caller cannot.
;;; ---------------------------------------------------------------------------

(defun %ma0-lines (text)
  (let ((lines '()) (start 0))
    (dotimes (i (length text))
      (when (char= #\Newline (char text i))
        (push (subseq text start i) lines)
        (setf start (1+ i))))
    (push (subseq text start) lines)
    (nreverse lines)))

(defun %ma0-generation-mutations (line)
  "Every FORBIDDEN mutation of the generation counter visible in LINE.  A
lawful `incf' is not one; a decrement, a rebinding, an unbinding, or a direct
`setf' is."
  (let ((out '()))
    (when (search "*ma0-environment-generation*" line :test #'char-equal)
      (dolist (bad '("decf" "makunbound" "(setf *ma0-environment-generation*"
                     "(let ((*ma0-environment-generation*"
                     "(let* ((*ma0-environment-generation*"))
        (when (search bad line :test #'char-equal) (push bad out))))
    (nreverse out)))

(defun %ma0-r1-generation-witnesses ()
  (format t "~&~%== R1/D5 — THE GENERATION: monotonic, never reset, never reused ==~%")

  ;; ---- TOOTH FIRST.  A detector that has never fired is untested.
  (let ((planted "  (decf *ma0-environment-generation*)"))
    (ma0-check "R1/D5 TOOTH the mutation detector FIRES on a planted decrement"
               (equal '("decf") (%ma0-generation-mutations planted))
               "~s" (%ma0-generation-mutations planted)))
  (let ((planted "  (setf *ma0-environment-generation* 0)"))
    (ma0-check "R1/D5 TOOTH the mutation detector FIRES on a planted reset"
               (member "(setf *ma0-environment-generation*"
                       (%ma0-generation-mutations planted) :test #'equal)
               "~s" (%ma0-generation-mutations planted)))
  (ma0-check "R1/D5 TOOTH the detector does NOT fire on the lawful increment"
             (null (%ma0-generation-mutations
                    "  (incf *ma0-environment-generation*)")))

  ;; ---- the gate, over the implementation sources.
  (let ((increments 0) (mentions 0) (mutations '()))
    (dolist (basename '("ma0-structures.lisp" "ma0-environment.lisp"
                        "ma0-validate.lisp" "ma0-compose.lisp" "ma0-eval.lisp"))
      (let ((path (merge-pathnames basename *ma0-lane-directory*)))
        (dolist (line (%ma0-lines (%ma0-read-file path)))
          (when (search "*ma0-environment-generation*" line :test #'char-equal)
            (incf mentions)
            (when (search "(incf *ma0-environment-generation*)" line
                          :test #'char-equal)
              (incf increments))
            (let ((bad (%ma0-generation-mutations line)))
              (when bad (push (list basename bad) mutations)))))))
    (ma0-check "R1/D5 the gate is not vacuous — it saw the counter" (plusp mentions)
               "~d mention(s)" mentions)
    (ma0-check "R1/D5 the counter has EXACTLY ONE increment site"
               (= 1 increments) "found ~d" increments)
    (ma0-check "R1/D5 nothing decrements, resets, rebinds, or unbinds the counter"
               (null mutations) "~s" mutations))

  ;; ---- and the runtime invariant: strictly increasing, by exactly one, with
  ;; ---- every earlier environment left stale rather than resurrected.
  (let* ((tmp (or (sb-ext:posix-getenv "TMPDIR") "/tmp"))
         (dir (truename
               (concatenate 'string
                            (sb-posix:mkdtemp
                             (concatenate 'string (string-right-trim "/" tmp)
                                          "/ma0-generation.XXXXXX"))
                            "/"))))
    (unwind-protect
         (let ((gens '()) (envs '()))
           (dolist (n '(1 2 3))
             (let ((root (merge-pathnames (format nil "e~d/" n) dir)))
               (ensure-directories-exist root)
               (push (make-ma0-environment
                      :root root :arms '("A")
                      :grants '((:slot "g1" :arm "A"))
                      :revocations '() :seat-map '() :inputs '())
                     envs)
               (push *ma0-environment-generation* gens)))
           (setf gens (nreverse gens) envs (nreverse envs))
           (ma0-check "R1/D5 successive constructions get STRICTLY INCREASING generations"
                      (and (= 3 (length gens)) (apply #'< gens)) "~s" gens)
           (ma0-check "R1/D5 each construction advances the counter by exactly one"
                      (equal gens (list (first gens) (1+ (first gens))
                                        (+ 2 (first gens))))
                      "~s" gens)
           ;; No older generation is ever reachable again: the first two
           ;; environments stay stale and only the last is current.
           (ma0-check "R1/D5 only the LAST environment is current; no older one revives"
                      (and (not (eql (%env-generation (first envs))
                                     *ma0-environment-generation*))
                           (not (eql (%env-generation (second envs))
                                     *ma0-environment-generation*))
                           (eql (%env-generation (third envs))
                                *ma0-environment-generation*))
                      "generations ~s, installed ~s"
                      (mapcar #'%env-generation envs)
                      *ma0-environment-generation*))
      (ignore-errors (uiop:delete-directory-tree dir :validate t)))))

;;; ===========================================================================
;;; §3 — the two GREP gates, each shown able to FIRE before it is trusted.
;;; ===========================================================================

(defparameter +ma0-predecessor-packages+
  '("lisp-plus-language-act0" "lisp-plus-journal0" "lisp-plus-capability0"
    "lisp-plus-capability1" "lisp-plus-capability2" "lisp-plus-core0"
    "lisp-plus-kernel0" "lisp-plus-cd0" "lisp-plus-surface2"
    "lisp-plus-surface1" "lisp-plus-surface0" "lisp-plus-slice1"
    "lisp-plus-system")
  "Every package this lane can see through its one ASDF edge.  A `::' against
any of them is a reference to an unexported symbol — contract §3's mechanical
prohibition.")

(defun %ma0-internal-hits (text)
  "Every `<predecessor>::' occurrence in TEXT, as a list of package names."
  (let ((hits '()))
    (dolist (package +ma0-predecessor-packages+ (nreverse hits))
      (let ((needle (concatenate 'string package "::"))
            (start 0))
        (loop for at = (search needle text :start2 start :test #'char-equal)
              while at
              do (push package hits) (setf start (+ at (length needle))))))))

(defun %ma0-read-file (path)
  (with-open-file (in path :direction :input :external-format :utf-8)
    (let ((text (make-string (file-length in))))
      (subseq text 0 (read-sequence text in)))))

(defparameter +ma0-lane-sources+
  '("package.lisp" "ma0-structures.lisp" "ma0-validate.lisp"
    "ma0-environment.lisp" "ma0-compose.lisp" "ma0-eval.lisp"
    "ma0-selftest-suite.lisp" "load.lisp" "ma0-driver.lisp"
    "ma0-selftest.lisp"
    ;; R1 (2026-08-10).  The repair round's own sources join the gate, because
    ;; the enumeration's whole point is that a new file cannot escape it by not
    ;; being listed — and a repair round is exactly when new files appear.
    "r1/D1-ownership.lisp" "r1/D2-branch-binding.lisp"
    "r1/D3-circular-source.lisp" "r1/D4-env-crosswire.lisp"
    "r1/D5-generation-seam.lisp" "r1/run-r1-program.lisp")
  "Every .lisp file this lane owns.  Enumerated, so a new source cannot join
the lane and escape the greps by not being on a list.")

(defun %ma0-grep-gates ()
  (format t "~&~%== GREP GATES (each shown able to FIRE before its clean pass is reported) ==~%")

  ;; ---- THE TOOTH for the no-internals gate.
  ;; ⚠ THE PLANTED STRING IS ASSEMBLED, NOT WRITTEN.  Spelling the violation
  ;; literally here would put it in a file the gate itself greps, and the gate
  ;; would then fail on its own tooth — a tooth that breaks the jaw is not a
  ;; tooth.
  (let ((planted (concatenate 'string "(lisp-plus-journal0" ":" ":"
                              "%internal-thing store)")))
    (ma0-check "TOOTH the no-internals grep FIRES on a planted violation"
               (equal '("lisp-plus-journal0") (%ma0-internal-hits planted))
               "hits=~s" (%ma0-internal-hits planted)))
  (ma0-check "TOOTH the no-internals grep does NOT fire on a lawful single colon"
             (null (%ma0-internal-hits "(lisp-plus-journal0:append-event s d)")))

  ;; ---- the gate itself, over this lane's own sources.
  (dolist (basename +ma0-lane-sources+)
    (let* ((path (merge-pathnames basename *ma0-lane-directory*))
           (text (and (probe-file path) (%ma0-read-file path)))
           (hits (and text (%ma0-internal-hits text))))
      (ma0-check (format nil "NO-INTERNALS ~a" basename)
                 (and text (null hits))
                 "~@[file absent~*~]~@[hits=~s~]" (null text) hits)))

  ;; ---- THE TOOTH for the W-GENERIC gate.
  (let ((planted "(when (string= name \"editio\") (short-circuit))"))
    (ma0-check "TOOTH the W-GENERIC grep FIRES on a planted program name"
               (search "editio" planted :test #'char-equal)))

  ;; ---- W-GENERIC: the evaluator, the validator and the composition name no
  ;; ---- program, no source hash, and no domain payload.  The environment file
  ;; ---- is EXCLUDED and the exclusion is named: it carries the arm->world-key
  ;; ---- column, which is the closed ARM vocabulary W-GENERIC admits.
  (dolist (basename '("ma0-eval.lisp" "ma0-validate.lisp" "ma0-compose.lisp"
                      "ma0-structures.lisp"))
    (let* ((path (merge-pathnames basename *ma0-lane-directory*))
           (text (%ma0-read-file path))
           (found (remove-if-not
                   (lambda (needle) (search needle text :test #'char-equal))
                   '("editio" "custodia" "manuscript" "custodian" "scriba"
                     "prima" "ambigua" "revocata" "amissa" "fracta"
                     "vetita" "p1-" "p2-"))))
      (ma0-check (format nil "W-GENERIC ~a names no program and no fixture identity"
                         basename)
                 (null found) "found=~s" found)))
  t)

;;; ===========================================================================
;;; §4 — the sub-image scenarios.
;;; ===========================================================================

(defun %ma0-run-scenario (scenario)
  "Spawn ONE image for ONE scenario (contract §5) and return
(values exit-code stdout-lines)."
  (let* ((driver (namestring (merge-pathnames "ma0-driver.lisp"
                                              *ma0-lane-directory*)))
         (out (make-string-output-stream))
         (process (sb-ext:run-program
                   (namestring sb-ext:*runtime-pathname*)
                   (list "--script" driver scenario)
                   :output out :error nil :search nil :wait t))
         (code (sb-ext:process-exit-code process))
         (lines '()))
    (with-input-from-string (in (get-output-stream-string out))
      (loop for line = (read-line in nil nil)
            while line
            do (when (and (>= (length line) 4) (string= "MA0 " (subseq line 0 4)))
                 (push (subseq line 4) lines))))
    (values code (nreverse lines))))

(defun %ma0-line (lines prefix)
  "The FIRST line beginning with PREFIX, or NIL."
  (find-if (lambda (l) (and (>= (length l) (length prefix))
                            (string= prefix (subseq l 0 (length prefix)))))
           lines))

(defun %ma0-has (lines text)
  (and (member text lines :test #'equal) t))

(defun %ma0-scenario-checks (scenario expectations
                             &key (expected-exit 0) (show nil))
  "Run SCENARIO in a fresh image; assert its exit code and each expected line."
  (format t "~&~%== SCENARIO ~a ==~%" scenario)
  (multiple-value-bind (code lines) (%ma0-run-scenario scenario)
    (when show (dolist (l lines) (ma0-note "~a" l)))
    (ma0-check (format nil "~a exit code" scenario) (eql expected-exit code)
               "exit=~s expected=~s" code expected-exit)
    (ma0-check (format nil "~a reached its declared end" scenario)
               (%ma0-line lines (format nil "DRIVER-END ~a" scenario))
               "end line=~s" (%ma0-line lines "DRIVER-END"))
    (dolist (expected expectations)
      (ma0-check (format nil "~a: ~a" scenario expected)
                 (%ma0-has lines expected)
                 "~@[nearest=~s~]"
                 (let ((key (subseq expected 0 (or (position #\= expected)
                                                   (length expected)))))
                   (%ma0-line lines key))))
    lines))

;;; ===========================================================================
;;; §5 — the suite.
;;; ===========================================================================

(defun %ma0-suite ()
  ;; ---- P1: W-RESULT-STRUCT, the announcement gate, the act's frame shape.
  (%ma0-scenario-checks
   "p1"
   '("program-name=\"editio\""
     "disposition=:COMPLETED"
     "value=(:ANNOUNCED \"codex-sangallensis\" :SETTLED)"
     "refusal-code=NIL"
     "summary-count=1"
     "summary 0 arm=\"A\" class=:A disposition=:RETURNED verdict=\"agree\" hexlen=64"
     "prefix-status=:VALID"
     ;; the substrate's own answer, printed — this is where the brief's
     ;; `:closure' placeholder is contradicted by a run.
     "derived prima execution=:SETTLED evidence-class=:NONE provenance=:NONE"
     "frame prima F1 present=T"
     "frame prima F2 present=T"
     "frame prima F3 present=NIL"
     "frame prima F4 present=NIL"
     "frame prima F5 present=T"
     "classification=:ACT-REPORTED"
     "store-id-length=74"))

  ;; ---- P2 run α: W-UNCERTAIN-HALT, W-REFUSE-LAWFUL.
  (%ma0-scenario-checks
   "p2-alpha"
   '("program-name=\"custodia\""
     "disposition=:REFUSED"
     "refusal-code=:UNCERTAINTY-HALTS-CHAIN"
     "refusal-detail=\"marcus\""
     "summary-count=2"
     "summary 0 arm=\"A\" class=:A disposition=:RETURNED verdict=\"agree\" hexlen=64"
     "summary 1 arm=\"C-i\" class=:C-I disposition=:INTERRUPTED verdict=\"agree\" hexlen=64"
     ;; THE DEPENDENT ACT NEVER RAN — asserted by event-id, not by silence.
     "frame revocata :F1 present=NIL"
     "prefix-status=:VALID"))

  ;; ---- P2 run β: the revocation path, the unpaired shape, no erasure.
  (%ma0-scenario-checks
   "p2-beta"
   '("program-name=\"custodia\""
     "disposition=:REFUSED"
     "refusal-code=:AUTHORITY-REVOKED-BEFORE-DUTY-3"
     "summary-count=3"
     "summary 2 arm=\"B-R\" class=:UNPAIRED-F1 disposition=:MINT-REFUSED verdict=NIL hexlen=64"
     "frame revocata F1 present=T"
     "frame revocata F2 present=NIL"
     "frame revocata F3 present=NIL"
     "frame revocata F4 present=NIL"
     "frame revocata F5 present=NIL"
     "classification revocata=:BINDING-DECLARED-UNPAIRED"
     "prefix-status=:VALID"))

  ;; ---- W-BRANCH-ONE.
  (%ma0-scenario-checks
   "w-branch-one"
   '("value=:TOOK-THE-QUIET-ARM"
     "summary-count=0"
     "prefix-frames-before=1"
     "prefix-frames-after=1"
     "frame amissa :F1 present=NIL"))

  ;; ---- W-BRANCH-EXACT.
  (%ma0-scenario-checks
   "w-branch-exact"
   '("value=:EXACT-MATCHING-HELD"
     "probe execution=:ABSENT provenance=:NONE evidence-class=:NONE"
     "probe execution-standing-of-facet=:PRESENT"))

  ;; ---- W-DERIVE-NE-PERFORM.
  (%ma0-scenario-checks
   "w-derive-ne-perform"
   '("prefix-frames-before=1"
     "prefix-frames-after=1"
     "value=:THREE-DERIVES-AND-NO-ACT"))

  ;; ---- W-AUTH-EXPLICIT.
  (%ma0-scenario-checks
   "w-auth-unfilled"
   '("refused type=LISP-PLUS-MANY-ACTS0:MA0-AUTHORITY-SLOT-UNFILLED code=\"MA0-AUTH-1\""
     "frame prima :F1 present=NIL"
     "prefix-frames=0"))

  ;; ---- W-ORDER-STORE.
  (%ma0-scenario-checks
   "w-order-store"
   '("first-completion verdict=\"agree\" class=:A"
     "prefix-frames=8"
     "refused type=LISP-PLUS-MANY-ACTS0:MA0-COMPOSITION-DIVERGENCE code=\"ACT-ORDER-1\""
     "prefix-frames-after=8"
     "prefix-status=:VALID"))

  ;; ---- W-NO-ERASE.
  (%ma0-scenario-checks
   "w-no-erase"
   '("composed arm=\"A\" verdict=\"agree\""
     "composed arm=\"C-i\" verdict=\"agree\""
     "before prefix-frames=21"
     "revoked-duty class=:UNPAIRED-F1 disposition=:MINT-REFUSED"
     "after prefix-frames=22"
     "earlier-frames-unchanged=T"
     "earlier-frame-rows=10"
     "prefix-status=:VALID"))

  ;; ---- W-ERROR-PROPAGATES, both halves.
  (%ma0-scenario-checks
   "w-error-propagates"
   '("first disposition=:COMPLETED"
     "propagated type=LISP-PLUS-LANGUAGE-ACT0:ACT-IDENTITY-TAKEN requirement=\"ACT-9b\""
     "converted-to-completed=NIL"))
  (%ma0-scenario-checks
   "w-error-uncaught"
   '("first disposition=:COMPLETED"
     "PROPAGATED LISP-PLUS-LANGUAGE-ACT0:ACT-IDENTITY-TAKEN")
   :expected-exit 1)
  t)

;;; ===========================================================================
;;; §6 — the entry point.
;;; ===========================================================================

(defun ma0-selftest ()
  "Run the whole suite.  Returns (values total-checks failures)."
  (setf *ma0-passed* 0 *ma0-failed* 0)
  (format t "~&== MANY ACTS /0 — SELFTEST (candidate; adopts nothing) ==~%")
  (let* ((tmp (or (sb-ext:posix-getenv "TMPDIR") "/tmp"))
         (scratch (truename
                   (concatenate
                    'string
                    (sb-posix:mkdtemp
                     (concatenate 'string (string-right-trim "/" tmp)
                                  "/manyacts0-selftest.XXXXXX"))
                    "/"))))
    (unwind-protect
         (progn
           (%ma0-validator-witnesses scratch)
           (%ma0-footprint-witness scratch)
           (%ma0-immutability-witness scratch)
           ;; ⚠ THE R1 SECTIONS RUN AFTER `%ma0-footprint-witness', and the
           ;; order is load-bearing: that witness asserts the scratch directory
           ;; holds no store or world directory, so anything below which built
           ;; one would turn it red.  Nothing here builds an environment — but
           ;; the next hand to add a check in this block should know why the
           ;; position was chosen rather than rediscover it.
           (%ma0-r1-own-witnesses)
           (%ma0-r1-source-ownership scratch)
           (%ma0-r1-branch-fixtures scratch)
           (%ma0-r1-tree-fixtures)
           (%ma0-r1-generation-witnesses)
           (%ma0-grep-gates)
           (%ma0-suite))
      (ignore-errors (uiop:delete-directory-tree scratch :validate t))))
  (when (equal (sb-ext:posix-getenv "MA0_SELFTEST_PLANT_FAULT") "1")
    (ma0-check "PLANTED FAULT (MA0_SELFTEST_PLANT_FAULT=1): this check must FAIL"
               nil))
  (values (+ *ma0-passed* *ma0-failed*) *ma0-failed*))
