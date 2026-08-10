;;;; D5-generation-seam.lisp — THE CONSTRUCTION-FAILURE SEMANTICS of the R1/D4
;;;; environment generation (owner's pre-freeze gate, verbatim at
;;;; r1/R1-GENERATION-SEAM-FINAL-CHECK.md).
;;;;
;;;; Fresh image.  PUBLIC EXPORTS ONLY, plus the filesystem.
;;;;
;;;; THE QUESTION.  `make-ma0-environment' advances a private generation counter
;;;; and installs five One Act /0 run-state specials.  What happens if the
;;;; construction SIGNALS after that advancement but before the function
;;;; returns?  The owner requires one of three lawful properties:
;;;;
;;;;   1. everything after the advancement is proved non-failing under validated
;;;;      inputs; or
;;;;   2. the advancement is committed only after every fallible step succeeds;
;;;;      or
;;;;   3. failure leaves the image explicitly without a current usable
;;;;      environment, with no previous environment accidentally appearing
;;;;      current and no half-installed environment usable.
;;;;
;;;; ⚠ THE WINDOW IS REACHABLE FROM THE PUBLIC API.  Property 1 does not hold,
;;;; and the fixture that shows it is D5-1-POST: a declaration large enough to
;;;; exceed the ownership walk budget passes every plan check, so the refusal
;;;; lands AFTER the counter moved.  Before the repair this killed a working
;;;; environment: the generation advanced, the previously-good environment A
;;;; went stale, the grants were journaled into B's store, and the five specials
;;;; were left pointing at a store no object owned.
;;;;
;;;; THE PROPERTY THIS LANE NOW CLAIMS IS **2**: the counter and the specials
;;;; move together, at a commit point AFTER every fallible construction step.
;;;;
;;;; PROOFS
;;;;   D5-1  construction failure — six ways, one of them post-increment-
;;;;         reachable — leaves A CURRENT, A's store byte-unchanged, the
;;;;         specials pointing at A, and the mint counter unmoved; then A runs,
;;;;         and a later environment C constructs and runs.
;;;;   D5-3  no exposure: no exported symbol names the generation, and neither
;;;;         an environment nor a result reveals it when printed.
;;;;   D5-4  BOTH `ma0-run-program' AND `ma0-complete-act' refuse a stale
;;;;         environment before any act construction, capability activity,
;;;;         journal mutation, or world mutation — witnessed by a byte-exact
;;;;         snapshot of BOTH roots and the mint counter across each refusal.
;;;;
;;;; D5-2 (strict monotonicity / no reset / no reuse) lives in the SUITE, which
;;;; is in-package and can read the counter itself.  A public-only witness can
;;;; only see the counter's shadow; the suite can see the counter.

(require :asdf)
(let ((here (uiop:pathname-directory-pathname *load-pathname*)))
  (uiop:chdir (uiop:pathname-parent-directory-pathname
               (uiop:pathname-parent-directory-pathname
                (uiop:pathname-parent-directory-pathname here))))
  (asdf:initialize-source-registry
   `(:source-registry (:directory ,(uiop:getcwd)) :ignore-inherited-configuration)))
(asdf:load-system "lisp-plus/many-acts-0")

(defpackage #:ma0-d5 (:use #:cl))
(in-package #:ma0-d5)

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

;;; --------------------------------------------------------------------------
;;; Instruments.
;;; --------------------------------------------------------------------------

(defun snapshot (root)
  "Every file under ROOT, path -> full CONTENT.  Byte-exact: this catches an
APPEND, which a file count and a file list both miss."
  (when (probe-file root)
    (sort (mapcar (lambda (p)
                    (cons (enough-namestring p root)
                          (with-open-file (s p :element-type '(unsigned-byte 8))
                            (let ((buf (make-array (file-length s)
                                                   :element-type '(unsigned-byte 8))))
                              (read-sequence buf s)
                              buf))))
                  (remove-if-not #'pathname-name
                                 (directory (merge-pathnames "**/*.*" root))))
          #'string< :key #'car)))

(defun mint-count ()
  "The live minting context's counter, through Capability /1's exported reader.
`capability activity' in the owner's list is measured here."
  (let ((ctx lisp-plus-language-act0:*minting-context*))
    (and ctx (lisp-plus-capability1:minting-context-minted-count ctx))))

(defun installed-root ()
  (and lisp-plus-language-act0:*run-root*
       (namestring lisp-plus-language-act0:*run-root*)))

(defun currentp (environment)
  "Is ENVIRONMENT the one the specials belong to?  Asked through the PUBLIC
staleness seam, with a plist that would certainly crash if the seam did not
fire first — so a `:current' answer also proves the check ran BEFORE any use of
the result argument.  Nothing is written on either branch."
  (handler-case (progn (lisp-plus-many-acts0:ma0-complete-act '() environment)
                       :returned-impossibly)
    (lisp-plus-many-acts0:ma0-environment-stale () :stale)
    (error () :current)))

;;; ⚠ THE ARM BUDGET, AND WHY THIS FIXTURE HAS ONE.  A One Act identity is
;;; minted PER IMAGE, not per store: running the same arm twice in one image
;;; raises ACT-IDENTITY-TAKEN [ACT-9b] however many separate environments and
;;; stores are involved.  That is the adopted lane's no-blind-replay law doing
;;; its job, and it constrains this fixture — so each of the three places that
;;; must prove "an environment RUNS" spends a DIFFERENT arm, once.
;;;
;;;   arm A     — a good environment still runs after every failed construction
;;;   arm B-L1  — a later environment C constructs and runs
;;;   arm C-i   — the installed environment is still usable after a stale refusal

(defun program-text (arm)
  (format nil "
(ma0-program
 (:name \"d5-subject\")
 (:input ())
 (:authority-slots (g1))
 (:steps
  (act a1 (:arm ~s) (:authority-slot g1))
  (branch a1
    ((:disposition :returned) (result \"ran\"))
    ((:disposition :refused)  (result \"ran\"))
    ((:disposition :host-fault) (result \"ran\"))
    (otherwise (result \"ran\")))))
" arm))

(defun write-program (dir arm)
  (let ((path (merge-pathnames (format nil "d5-~a.lisp" arm) dir)))
    (with-open-file (out path :direction :output :if-exists :supersede
                              :external-format :utf-8)
      (write-string (program-text arm) out))
    path))

(defun good-env (root &optional (arm "A"))
  (lisp-plus-many-acts0:make-ma0-environment
   :root root :arms (list arm)
   :grants (list (list :slot "g1" :arm arm))
   :revocations '() :seat-map '() :inputs '()))

(let* ((stem (or (uiop:getenv "TMPDIR") "/tmp"))
       (tag (random 1000000 (make-random-state t)))
       (roots '())
       (dir (lambda (name)
              (let ((p (uiop:ensure-directory-pathname
                        (format nil "~a/ma0-d5-~a-~d/" stem name tag))))
                (ensure-directories-exist p)
                (push p roots)
                p)))
       (root-s (funcall dir "src")))
  (unwind-protect
       (let ((prog-a (lisp-plus-many-acts0:ma0-validate (write-program root-s "A")))
             (prog-bl1 (lisp-plus-many-acts0:ma0-validate (write-program root-s "B-L1")))
             (prog-ci (lisp-plus-many-acts0:ma0-validate (write-program root-s "C-i")))
             (attempts
               (list
                ;; ⚠ THE POST-INCREMENT-REACHABLE ONE.  Every plan check passes
                ;; (each row is (STRING . INTEGER)); the refusal comes from the
                ;; ownership walk budget, which under the pre-repair ordering ran
                ;; AFTER the counter had already moved.
                (cons "oversized declaration (post-increment window)"
                      (lambda (root)
                        (lisp-plus-many-acts0:make-ma0-environment
                         :root root :arms '("A")
                         :grants '((:slot "g1" :arm "A"))
                         :revocations '() :seat-map '()
                         :inputs (loop for i below 70000
                                       collect (cons (format nil "in~d" i) i)))))
                (cons "an arm outside the sealed seven"
                      (lambda (root)
                        (lisp-plus-many-acts0:make-ma0-environment
                         :root root :arms '("Z") :grants '()
                         :revocations '() :seat-map '() :inputs '())))
                (cons "a grant naming an undeclared arm"
                      (lambda (root)
                        (lisp-plus-many-acts0:make-ma0-environment
                         :root root :arms '("A")
                         :grants '((:slot "g1" :arm "C-i"))
                         :revocations '() :seat-map '() :inputs '())))
                (cons "a seat map naming a seat no fixture carries"
                      (lambda (root)
                        (lisp-plus-many-acts0:make-ma0-environment
                         :root root :arms '("A")
                         :grants '((:slot "g1" :arm "A"))
                         :revocations '()
                         :seat-map '(("s" . "no-such-seat")) :inputs '())))
                (cons "an input value that is not an admitted atom"
                      (lambda (root)
                        (lisp-plus-many-acts0:make-ma0-environment
                         :root root :arms '("A")
                         :grants '((:slot "g1" :arm "A"))
                         :revocations '() :seat-map '()
                         :inputs (list (cons "bad" (list 1 2 3))))))
                (cons "a revocation for an undeclared arm"
                      (lambda (root)
                        (lisp-plus-many-acts0:make-ma0-environment
                         :root root :arms '("A")
                         :grants '((:slot "g1" :arm "A"))
                         :revocations '((:arm "D"))
                         :seat-map '() :inputs '())))))
             (last-a nil))

         ;; ================================================================
         ;; D5-1 — CONSTRUCTION FAILURE SEMANTICS
         ;; ================================================================
         (format t "~&~%== D5-1 — construction failure leaves the live environment ALIVE ==~%")
         (marker "each attempt gets its OWN fresh environment A, so the attempts")
         (marker "are independent evidence rather than a queue behind the first.")

         (loop for (label . thunk) in attempts
               for n from 1
               do (let* ((root-a (funcall dir (format nil "A~d" n)))
                         (root-b (funcall dir (format nil "B~d" n)))
                         (env-a (good-env root-a))
                         (before-a (snapshot root-a))
                         (before-mint (mint-count))
                         (before-installed (installed-root))
                         (outcome nil))
                    (setf last-a (cons env-a prog-a))
                    (probe (format nil "D5-1.~d setup: a fresh A is current" n)
                           (eq :current (currentp env-a)) "")
                    (handler-case (progn (funcall thunk root-b)
                                         (setf outcome "CONSTRUCTED (expected a refusal)"))
                      (lisp-plus-many-acts0:ma0-refusal (c)
                        (setf outcome (format nil "~a [~a]" (type-of c)
                                              (lisp-plus-many-acts0:ma0-refusal-code c))))
                      (error (c) (setf outcome (format nil "~a" (type-of c)))))
                    (marker "attempt ~d — ~a => ~a" n label outcome)
                    (probe (format nil "D5-1.~d A is STILL CURRENT after: ~a" n label)
                           (eq :current (currentp env-a))
                           (format nil "A reads ~s" (currentp env-a)))
                    (probe (format nil "D5-1.~d A's own root is byte-unchanged" n)
                           (equalp before-a (snapshot root-a)) "")
                    (probe (format nil "D5-1.~d the specials still point at A" n)
                           (equal before-installed (installed-root))
                           (format nil "was ~a now ~a" before-installed (installed-root)))
                    (probe (format nil "D5-1.~d the mint counter is unmoved" n)
                           (eql before-mint (mint-count))
                           (format nil "~s -> ~s" before-mint (mint-count)))))

         ;; A SURVIVED — proved by USE, not by a predicate.  Arm A, spent once.
         (let ((outcome (handler-case
                            (format nil "~s"
                                    (lisp-plus-many-acts0:ma0-result-disposition
                                     (lisp-plus-many-acts0:ma0-run-program
                                      (cdr last-a) (car last-a))))
                          (error (c) (format nil "DIED: ~a" (type-of c))))))
           (probe "D5-1 the surviving A still RUNS a program (arm A)"
                  (equal ":COMPLETED" outcome) outcome))

         ;; A later environment still constructs and runs.  Arm B-L1, spent once.
         (let* ((root-c (funcall dir "C"))
                (env-c (good-env root-c "B-L1"))
                ;; ⚠ THE RESULT IS KEPT, NOT RE-EARNED.  Arm B-L1 is spent here
                ;; and cannot be run again in this image (ACT-9b), so the D5-3
                ;; print probe below reuses THIS object rather than calling
                ;; `ma0-run-program' a second time.
                (result-c nil)
                (outcome (handler-case
                             (progn (setf result-c
                                          (lisp-plus-many-acts0:ma0-run-program
                                           prog-bl1 env-c))
                                    (format nil "~s"
                                            (lisp-plus-many-acts0:ma0-result-disposition
                                             result-c)))
                           (error (c) (format nil "DIED: ~a" (type-of c))))))
           (probe "D5-1 a later environment C constructs and runs (arm B-L1)"
                  (equal ":COMPLETED" outcome) outcome)
           (probe "D5-1 and the earlier A is now STALE, because C legitimately took over"
                  (eq :stale (currentp (car last-a)))
                  (format nil "A reads ~s" (currentp (car last-a))))

           ;; ================================================================
           ;; D5-3 — NO EXPOSURE
           ;; ================================================================
           (format t "~&~%== D5-3 — the generation is not exposed or accepted ==~%")
           (let ((named '()))
             (do-external-symbols (s (find-package '#:lisp-plus-many-acts0))
               (when (search "GENERATION" (symbol-name s) :test #'char-equal)
                 (push (symbol-name s) named)))
             (probe "D5-3 no EXPORTED symbol names the generation"
                    (null named) (format nil "~s" named)))
           (let ((printed (format nil "~s ~a" env-c env-c)))
             (probe "D5-3 printing an ENVIRONMENT reveals no generation"
                    (not (search "GENERATION" printed :test #'char-equal))
                    (format nil "~a" (substitute #\Space #\Newline
                                                 (subseq printed 0 (min 200 (length printed)))))))
           (let ((printed (format nil "~s ~a" result-c result-c)))
             (probe "D5-3 printing a RESULT reveals no generation"
                    (not (search "GENERATION" printed :test #'char-equal))
                    (format nil "~a" (substitute #\Space #\Newline
                                                 (subseq printed 0 (min 200 (length printed))))))))

         ;; ================================================================
         ;; D5-4 — ENTRY-POINT ORDERING, both doors, full state
         ;; ================================================================
         (format t "~&~%== D5-4 — both doors refuse a stale environment BEFORE any work ==~%")
         (let* ((root-x (funcall dir "X"))
                (root-y (funcall dir "Y"))
                (env-x (good-env root-x "C-i"))
                (env-y (good-env root-y "C-i"))   ; X is now stale
                (bx (snapshot root-x)) (by (snapshot root-y))
                (bm (mint-count))
                (run-outcome nil) (complete-outcome nil))

           (handler-case (lisp-plus-many-acts0:ma0-run-program prog-ci env-x)
             (lisp-plus-many-acts0:ma0-environment-stale (c)
               (setf run-outcome (list :stale (lisp-plus-many-acts0:ma0-refusal-code c)
                                       (lisp-plus-many-acts0:ma0-environment-stale-store-id c))))
             (error (c) (setf run-outcome (list :other (type-of c)))))
           (probe "D5-4 ma0-run-program refuses the stale environment, typed"
                  (eq :stale (first run-outcome)) (format nil "~s" run-outcome))
           (probe "D5-4 the refusal carries the STALE environment's own store-id"
                  (equal (third run-outcome)
                         (lisp-plus-many-acts0:ma0-environment-store-id env-x))
                  (format nil "~s" (third run-outcome)))

           ;; ⚠ A PLIST THAT WOULD CERTAINLY CRASH IF THE SEAM DID NOT FIRE
           ;; FIRST.  Getting MA0-ENVIRONMENT-STALE rather than a type error is
           ;; what proves the check precedes every use of the result argument —
           ;; i.e. before any constituent-act construction at all.
           (handler-case (lisp-plus-many-acts0:ma0-complete-act '() env-x)
             (lisp-plus-many-acts0:ma0-environment-stale (c)
               (setf complete-outcome (list :stale (lisp-plus-many-acts0:ma0-refusal-code c))))
             (error (c) (setf complete-outcome (list :other (type-of c)))))
           (probe "D5-4 ma0-complete-act refuses BEFORE it touches the act result"
                  (eq :stale (first complete-outcome)) (format nil "~s" complete-outcome))

           (probe "D5-4 the stale environment's own store is byte-unchanged"
                  (equalp bx (snapshot root-x)) "")
           (probe "D5-4 the INSTALLED environment's store is byte-unchanged"
                  (equalp by (snapshot root-y)) "")
           (probe "D5-4 no capability activity: the mint counter is unmoved"
                  (eql bm (mint-count)) (format nil "~s -> ~s" bm (mint-count)))
           (let ((outcome (handler-case
                              (format nil "~s"
                                      (lisp-plus-many-acts0:ma0-result-disposition
                                       (lisp-plus-many-acts0:ma0-run-program prog-ci env-y)))
                            (error (c) (format nil "DIED: ~a" (type-of c))))))
             (probe "D5-4 the installed environment is still usable (arm C-i)"
                    (equal ":COMPLETED" outcome) outcome))))
    (dolist (r roots)
      (ignore-errors
       (uiop:delete-directory-tree r :validate t :if-does-not-exist :ignore))))

  (format t "~%ma0-D5-generation-seam: ~d closed, ~d defect(s) present~%"
          *closed* *defects*)
  (uiop:quit (if (zerop *defects*) 0 1)))
