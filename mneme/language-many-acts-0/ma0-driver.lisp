;;;; ma0-driver.lisp — ONE PROGRAM PER IMAGE.
;;;;
;;;;   sbcl --script mneme/language-many-acts-0/ma0-driver.lisp <scenario>
;;;;
;;;; CANDIDATE.  Executing a candidate is not adopting it (contract §0, §8).
;;;;
;;;; ---------------------------------------------------------------------------
;;;; WHY A SEPARATE DRIVER EXISTS
;;;; ---------------------------------------------------------------------------
;;;;
;;;; The runner law is ONE PROGRAM PER IMAGE (contract §5).  `make-ma0-environment'
;;;; SETFs One Act /0's five exported run-state specials, and each of the seven
;;;; constituent arms consumes its runtime seat once per store, so two programs
;;;; in one image would either collide or silently share a store.  A selftest
;;;; that ran its scenarios in its own image would be testing something the
;;;; contract forbids.  So the selftest SPAWNS this file, once per scenario, and
;;;; reads what it prints.
;;;;
;;;; ⚠ THE RUN ROOT IS CREATED OUTSIDE THE SUBJECT TREE, PROVED OUTSIDE BEFORE A
;;;; BYTE IS WRITTEN, AND REMOVED ON SUCCESS **AND** ON FAILURE.  The pattern is
;;;; act0-selftest.lisp:102-133, adopted.
;;;;
;;;; ⚠ STDOUT IS THE DETERMINISTIC TRANSCRIPT.  Everything that cannot be stable
;;;; across runs — the mkdtemp'd root, the toolchain banner, the predecessor
;;;; lanes' own load chatter — goes to stderr or is suppressed, so two runs of
;;;; one scenario print identical stdout.
;;;;
;;;; EXIT CODE: 0 when the scenario reached its declared end (INCLUDING a lawful
;;;; program refusal — a refusal is an outcome, not a failure).  1 when a
;;;; condition propagated out of the evaluation, or the scenario is unknown.
;;;;
;;;; — FABER (Claude Opus 5, subagent), 2026-08-09

(require :asdf)
(require :sb-posix)

;;; --------------------------------------------------------------------------
;;; Toolchain gate — before anything else.
;;; --------------------------------------------------------------------------

(unless (string= (lisp-implementation-version) "2.4.6")
  (format *error-output*
          "~&!! FAIL CLOSED: this driver is authorized for SBCL 2.4.6 only.~%~
             Observed ~a.  No portability is claimed and none may be inferred.~%"
          (lisp-implementation-version))
  (finish-output *error-output*)
  (sb-ext:exit :code 1))

(defparameter cl-user::*ma0-here*
  (make-pathname :name nil :type nil :defaults *load-truename*))

(defparameter cl-user::*ma0-tree*
  (truename (merge-pathnames "../../" cl-user::*ma0-here*))
  "experiments/latent-lisp — the subject tree root.")

(defparameter cl-user::*ma0-scenario*
  (or (second sb-ext:*posix-argv*)
      (progn (format *error-output* "~&!! no scenario named~%")
             (sb-ext:exit :code 1))))

(format *error-output* "~&== ma0-driver — SBCL ~a — scenario ~a ==~%"
        (lisp-implementation-version) cl-user::*ma0-scenario*)

;;; --------------------------------------------------------------------------
;;; THE RUN ROOT — outside the subject tree, and PROVED outside.
;;; --------------------------------------------------------------------------

(defparameter cl-user::*ma0-root*
  (let* ((tmp (or (sb-ext:posix-getenv "TMPDIR") "/tmp"))
         (dir (sb-posix:mkdtemp
               (concatenate 'string (string-right-trim "/" tmp)
                            "/manyacts0-run.XXXXXX"))))
    (truename (concatenate 'string dir "/"))))

(let ((tree (namestring cl-user::*ma0-tree*))
      (root (namestring cl-user::*ma0-root*)))
  (when (and (>= (length root) (length tree))
             (string= tree (subseq root 0 (length tree))))
    (format *error-output*
            "~&!! FAIL CLOSED: the run root ~a is INSIDE the subject tree ~a.~%"
            root tree)
    (ignore-errors (uiop:delete-directory-tree cl-user::*ma0-root* :validate t))
    (finish-output *error-output*)
    (sb-ext:exit :code 1)))

(format *error-output* "   run root: ~a  (outside the tree; removed on success AND failure)~%"
        cl-user::*ma0-root*)
(finish-output *error-output*)

;;; --------------------------------------------------------------------------
;;; Enter the lane THROUGH ASDF.  The predecessors' load chatter goes to the
;;; bit bucket so stdout stays the scenario's own transcript.
;;; --------------------------------------------------------------------------

(asdf:initialize-source-registry
 `(:source-registry (:directory ,(namestring cl-user::*ma0-tree*))
   :inherit-configuration))

(let ((*standard-output* (make-broadcast-stream)))
  (asdf:load-system "lisp-plus/many-acts-0"))

(in-package #:cl-user)

;;; --------------------------------------------------------------------------
;;; Transcript primitives.  Every reported fact PRINTS.
;;; --------------------------------------------------------------------------

(defun ma0-say (fmt &rest args)
  (format t "~&MA0 ~a~%" (apply #'format nil fmt args))
  (force-output))

(defun ma0-store () lisp-plus-language-act0:*store*)

(defun ma0-frame-present-p (seat frame)
  "Is FRAME durable for the attempt of SEAT?  Read by EVENT-ID out of the
store, never by silence (the discipline of act0-gates.lisp:538-540)."
  (and (lisp-plus-journal0:find-event
        (ma0-store)
        (lisp-plus-language-act0:frame-event-id
         frame (format nil "a-~a" seat)))
       t))

(defun ma0-frame-digest (seat frame)
  (multiple-value-bind (ordinal digest payload)
      (lisp-plus-journal0:find-event
       (ma0-store)
       (lisp-plus-language-act0:frame-event-id frame (format nil "a-~a" seat)))
    (declare (ignore payload))
    (and ordinal digest)))

(defun ma0-frame-ordinal (seat frame)
  (nth-value 0 (lisp-plus-journal0:find-event
                (ma0-store)
                (lisp-plus-language-act0:frame-event-id
                 frame (format nil "a-~a" seat)))))

(defun ma0-prefix-frame-count ()
  (lisp-plus-journal0:prefix-report-frame-count
   (lisp-plus-journal0:validate-journal (ma0-store))))

(defun ma0-prefix-status ()
  (lisp-plus-journal0:prefix-report-status
   (lisp-plus-journal0:validate-journal (ma0-store))))

(defun ma0-report-result (result)
  (ma0-say "program-name=~s" (lisp-plus-many-acts0:ma0-result-program-name result))
  (ma0-say "disposition=~s" (lisp-plus-many-acts0:ma0-result-disposition result))
  (ma0-say "value=~s" (lisp-plus-many-acts0:ma0-result-value result))
  (ma0-say "refusal-code=~s" (lisp-plus-many-acts0:ma0-result-refusal-code result))
  (ma0-say "refusal-detail=~s"
           (lisp-plus-many-acts0:ma0-result-refusal-detail result))
  (let ((summaries (lisp-plus-many-acts0:ma0-result-act-summaries result)))
    (ma0-say "summary-count=~d" (length summaries))
    (loop for s in summaries
          for i from 0
          do (ma0-say "summary ~d arm=~s class=~s disposition=~s verdict=~s hexlen=~d"
                      i
                      (lisp-plus-many-acts0:ma0-act-summary-arm s)
                      (lisp-plus-many-acts0:ma0-act-summary-class s)
                      (lisp-plus-many-acts0:ma0-act-summary-disposition s)
                      (lisp-plus-many-acts0:ma0-act-summary-verdict s)
                      (length (lisp-plus-many-acts0:ma0-act-summary-act-id-hex s))))))

(defun ma0-program-path (name)
  (merge-pathnames (format nil "programs/~a" name) cl-user::*ma0-here*))

(defun ma0-write-witness (basename text)
  "Write a witness program source under the RUN ROOT — outside the subject
tree — and return its pathname.  Witness sources are DATA the driver authors;
they go where every other byte of this run goes, and vanish with it."
  (let ((path (merge-pathnames basename cl-user::*ma0-root*)))
    (with-open-file (out path :direction :output :if-exists :supersede
                              :external-format :utf-8)
      (write-string text out))
    path))

(defun ma0-fixture (arm)
  (find arm lisp-plus-language-act0:*act-fixture-table*
        :key #'lisp-plus-language-act0:act-fixture-arm :test #'string=))

;;; --------------------------------------------------------------------------
;;; Witness program sources (DATA the driver authors, never host code).
;;; --------------------------------------------------------------------------

(defparameter *w-branch-one-source* "
(ma0-program
 (:name \"w-branch-one\")
 (:input ())
 (:authority-slots (g))
 (:steps
  (derive probe (:seat \"s-probe\"))
  (branch probe
    ((:execution :settled)
     (act never (:arm \"C-ii\") (:authority-slot g))
     (result :took-the-act-arm))
    (otherwise
     (result :took-the-quiet-arm)))))
")

(defparameter *w-branch-exact-source* "
(ma0-program
 (:name \"w-branch-exact\")
 (:input ())
 (:authority-slots (g))
 (:steps
  (derive probe (:seat \"s-probe\"))
  (branch probe
    ((:provenance :live) (result :truthiness-fired))
    ((:evidence-class :uncertain) (result :wrong-value-fired))
    ((:execution :absent-from-evidence) (result :absence-keyword-fired))
    (otherwise (result :exact-matching-held)))))
")

(defparameter *w-derive-only-source* "
(ma0-program
 (:name \"w-derive-only\")
 (:input ())
 (:authority-slots (g))
 (:steps
  (derive one (:seat \"s-probe\"))
  (derive two (:seat \"s-probe\"))
  (derive three (:seat \"s-probe\"))
  (branch three
    ((:execution :absent) (result :three-derives-and-no-act))
    (otherwise (result :unexpected)))))
")

(defparameter *w-second-a-source* "
(ma0-program
 (:name \"w-second-a\")
 (:input ())
 (:authority-slots (editor-grant))
 (:steps
  (act again (:arm \"A\") (:authority-slot editor-grant))
  (result :should-never-be-reached)))
")

;;; --------------------------------------------------------------------------
;;; Environments.  Every one of these is DATA; none holds a live object.
;;; --------------------------------------------------------------------------

(defun ma0-env-p1 (&key (grants '((:slot "editor-grant" :arm "A"))))
  (lisp-plus-many-acts0:make-ma0-environment
   :root cl-user::*ma0-root*
   :arms '("A")
   :grants grants
   :revocations '()
   :seat-map '(("s-entry" . "prima"))
   :inputs '(("manuscript-label" . "codex-sangallensis"))))

(defun ma0-env-p2 (&key seat revocations)
  (lisp-plus-many-acts0:make-ma0-environment
   :root cl-user::*ma0-root*
   :arms '("A" "C-i" "B-R")
   :grants '((:slot "custody-grant" :arm "A")
             (:slot "custody-grant" :arm "C-i")
             (:slot "custody-grant" :arm "B-R"))
   :revocations revocations
   :seat-map (list (cons "s-duty-2" seat))
   :inputs '(("custodian" . "marcus")
             ("evidence-seat" . "s-duty-2"))))

(defun ma0-env-probe (&key (arms '("C-ii")) (grants '((:slot "g" :arm "C-ii"))))
  (lisp-plus-many-acts0:make-ma0-environment
   :root cl-user::*ma0-root*
   :arms arms :grants grants :revocations '()
   :seat-map '(("s-probe" . "prima"))
   :inputs '()))

;;; --------------------------------------------------------------------------
;;; THE SCENARIOS.
;;; --------------------------------------------------------------------------

(defun ma0-run-scenario (scenario)
  (cond

    ;; ---- P1 -------------------------------------------------------------
    ((string= scenario "p1")
     (let* ((program (lisp-plus-many-acts0:ma0-validate
                      (ma0-program-path "p1-editio.lisp")))
            (environment (ma0-env-p1))
            (before (ma0-prefix-frame-count))
            (result (lisp-plus-many-acts0:ma0-run-program program environment)))
       (ma0-say "prefix-frames-before=~d" before)
       (ma0-say "prefix-frames-after=~d" (ma0-prefix-frame-count))
       (ma0-say "prefix-status=~s" (ma0-prefix-status))
       (ma0-report-result result)
       (ma0-say "store-id-length=~d"
                (length (lisp-plus-many-acts0:ma0-result-store-id result)))
       ;; the announcement gate's own inputs, PRINTED rather than assumed —
       ;; this is where the brief's `:closure` placeholder is contradicted.
       (let* ((events (lisp-plus-surface2:validated-store-events (ma0-store)))
              (so (lisp-plus-surface2:derive-seat-outcome
                   (ma0-store) events "prima")))
         (ma0-say "derived prima execution=~s evidence-class=~s provenance=~s"
                  (lisp-plus-surface2:seat-outcome-execution-standing so)
                  (lisp-plus-surface2:seat-outcome-evidence-class so)
                  (lisp-plus-surface2:seat-outcome-provenance so)))
       (dolist (frame '(:f1 :f2 :f3 :f4 :f5))
         (ma0-say "frame prima ~a present=~s" frame
                  (ma0-frame-present-p "prima" frame)))
       (ma0-say "classification=~s"
                (lisp-plus-language-act0:classify-act-frames
                 (loop for frame in '(:f1 :f2 :f3 :f4 :f5)
                       when (ma0-frame-present-p "prima" frame) collect frame)))))

    ;; ---- P2, run α: the uncertainty path ---------------------------------
    ((string= scenario "p2-alpha")
     (let* ((program (lisp-plus-many-acts0:ma0-validate
                      (ma0-program-path "p2-custodia.lisp")))
            (environment (ma0-env-p2 :seat "ambigua" :revocations '()))
            (result (lisp-plus-many-acts0:ma0-run-program program environment)))
       (ma0-report-result result)
       (ma0-say "prefix-status=~s" (ma0-prefix-status))
       ;; W-UNCERTAIN-HALT: the dependent act NEVER RAN.  Asserted BY EVENT-ID.
       (ma0-say "frame revocata :F1 present=~s" (ma0-frame-present-p "revocata" :f1))
       (dolist (seat '("prima" "ambigua"))
         (dolist (frame '(:f1 :f2 :f3 :f4 :f5))
           (ma0-say "digest ~a ~a ~a" seat frame (ma0-frame-digest seat frame))))))

    ;; ---- P2, run β: the revocation path ----------------------------------
    ((string= scenario "p2-beta")
     (let* ((program (lisp-plus-many-acts0:ma0-validate
                      (ma0-program-path "p2-custodia.lisp")))
            (environment (ma0-env-p2 :seat "prima"
                                     :revocations '((:arm "B-R"))))
            (result (lisp-plus-many-acts0:ma0-run-program program environment)))
       (ma0-report-result result)
       (ma0-say "prefix-status=~s" (ma0-prefix-status))
       ;; the unpaired shape, by event-id: F1 alone for the revoked duty.
       (dolist (frame '(:f1 :f2 :f3 :f4 :f5))
         (ma0-say "frame revocata ~a present=~s" frame
                  (ma0-frame-present-p "revocata" frame)))
       (ma0-say "classification revocata=~s"
                (lisp-plus-language-act0:classify-act-frames
                 (loop for frame in '(:f1 :f2 :f3 :f4 :f5)
                       when (ma0-frame-present-p "revocata" frame) collect frame)))
       ;; W-NO-ERASE, ordinal half: every earlier frame stands BEFORE the
       ;; refused duty's F1 and none moved.
       (ma0-say "ordinal revocata :F1 = ~d" (ma0-frame-ordinal "revocata" :f1))
       (dolist (seat '("prima" "ambigua"))
         (dolist (frame '(:f1 :f2 :f3 :f4 :f5))
           (ma0-say "digest ~a ~a ~a" seat frame (ma0-frame-digest seat frame))
           (ma0-say "ordinal ~a ~a = ~d" seat frame
                    (ma0-frame-ordinal seat frame))))))

    ;; ---- W-BRANCH-ONE ----------------------------------------------------
    ((string= scenario "w-branch-one")
     (let* ((path (ma0-write-witness "w-branch-one.lisp" *w-branch-one-source*))
            (program (lisp-plus-many-acts0:ma0-validate path))
            (environment (ma0-env-probe))
            (before (ma0-prefix-frame-count))
            (result (lisp-plus-many-acts0:ma0-run-program program environment)))
       (ma0-report-result result)
       (ma0-say "prefix-frames-before=~d" before)
       (ma0-say "prefix-frames-after=~d" (ma0-prefix-frame-count))
       (ma0-say "frame amissa :F1 present=~s" (ma0-frame-present-p "amissa" :f1))))

    ;; ---- W-BRANCH-EXACT ---------------------------------------------------
    ((string= scenario "w-branch-exact")
     (let* ((path (ma0-write-witness "w-branch-exact.lisp"
                                     *w-branch-exact-source*))
            (program (lisp-plus-many-acts0:ma0-validate path))
            (environment (ma0-env-probe))
            (result (lisp-plus-many-acts0:ma0-run-program program environment)))
       (ma0-report-result result)
       (let* ((events (lisp-plus-surface2:validated-store-events (ma0-store)))
              (so (lisp-plus-surface2:derive-seat-outcome
                   (ma0-store) events "prima")))
         (ma0-say "probe execution=~s provenance=~s evidence-class=~s"
                  (lisp-plus-surface2:seat-outcome-execution-standing so)
                  (lisp-plus-surface2:seat-outcome-provenance so)
                  (lisp-plus-surface2:seat-outcome-evidence-class so))
         (ma0-say "probe execution-standing-of-facet=~s"
                  (lisp-plus-surface2:seat-outcome-field-standing so :execution)))))

    ;; ---- W-DERIVE-NE-PERFORM ---------------------------------------------
    ((string= scenario "w-derive-ne-perform")
     (let* ((path (ma0-write-witness "w-derive-only.lisp"
                                     *w-derive-only-source*))
            (program (lisp-plus-many-acts0:ma0-validate path))
            (environment (ma0-env-probe))
            (before (ma0-prefix-frame-count))
            (result (lisp-plus-many-acts0:ma0-run-program program environment)))
       (ma0-say "prefix-frames-before=~d" before)
       (ma0-say "prefix-frames-after=~d" (ma0-prefix-frame-count))
       (ma0-report-result result)))

    ;; ---- W-AUTH-EXPLICIT: the unfilled slot ------------------------------
    ((string= scenario "w-auth-unfilled")
     (let* ((program (lisp-plus-many-acts0:ma0-validate
                      (ma0-program-path "p1-editio.lisp")))
            (environment (ma0-env-p1 :grants '())))
       (handler-case
           (let ((result (lisp-plus-many-acts0:ma0-run-program program environment)))
             (ma0-say "UNEXPECTED-COMPLETION disposition=~s"
                      (lisp-plus-many-acts0:ma0-result-disposition result)))
         (lisp-plus-many-acts0:ma0-authority-slot-unfilled (c)
           (ma0-say "refused type=~s code=~s" (type-of c)
                    (lisp-plus-many-acts0:ma0-refusal-code c))
           ;; NO ACT BEGAN: asserted by event-id, not by silence.
           (ma0-say "frame prima :F1 present=~s" (ma0-frame-present-p "prima" :f1))
           (ma0-say "prefix-frames=~d" (ma0-prefix-frame-count))))))

    ;; ---- W-ORDER-STORE: the store-derived ordering guard -----------------
    ((string= scenario "w-order-store")
     (let* ((environment (ma0-env-p1))
            (fixture (ma0-fixture "A"))
            (result (lisp-plus-language-act0:run-act fixture :verbose nil))
            (done (lisp-plus-many-acts0:ma0-complete-act result environment)))
       (ma0-say "first-completion verdict=~s class=~s"
                (getf done :verdict) (getf done :class))
       (ma0-say "prefix-frames=~d" (ma0-prefix-frame-count))
       ;; A SECOND completion of the SAME act would append F2 behind a durable
       ;; F5.  The guard reads that state out of the STORE and refuses BEFORE
       ;; the append — no host table is consulted and none exists here.
       (handler-case
           (progn (lisp-plus-many-acts0:ma0-complete-act result environment)
                  (ma0-say "UNEXPECTED-SECOND-COMPLETION"))
         (lisp-plus-many-acts0:ma0-composition-divergence (c)
           (ma0-say "refused type=~s code=~s" (type-of c)
                    (lisp-plus-many-acts0:ma0-refusal-code c))))
       (ma0-say "prefix-frames-after=~d" (ma0-prefix-frame-count))
       (ma0-say "prefix-status=~s" (ma0-prefix-status))))

    ;; ---- W-ERROR-PROPAGATES ----------------------------------------------
    ((string= scenario "w-error-propagates")
     (let* ((p1 (lisp-plus-many-acts0:ma0-validate
                 (ma0-program-path "p1-editio.lisp")))
            (environment (ma0-env-p1))
            (first-result (lisp-plus-many-acts0:ma0-run-program p1 environment)))
       (ma0-say "first disposition=~s"
                (lisp-plus-many-acts0:ma0-result-disposition first-result))
       ;; A SECOND program, in the SAME image, invoking an arm whose runtime
       ;; seat this store already consumed.  The ADOPTED lane refuses it
       ;; (K-7a-1 Shape 2), the evaluator has no handler, and the condition
       ;; reaches the runner UNCONVERTED.  ⚠ The refusal is ONE ACT /0'S, and
       ;; is reported as such: MA0 neither invented it nor could have.
       (let* ((path (ma0-write-witness "w-second-a.lisp" *w-second-a-source*))
              (second-program (lisp-plus-many-acts0:ma0-validate path)))
         (handler-case
             (let ((r (lisp-plus-many-acts0:ma0-run-program
                       second-program environment)))
               (ma0-say "UNEXPECTED-COMPLETION disposition=~s"
                        (lisp-plus-many-acts0:ma0-result-disposition r)))
           (lisp-plus-language-act0:act0-condition (c)
             (ma0-say "propagated type=~s requirement=~s" (type-of c)
                      (lisp-plus-language-act0:act0-condition-requirement-id c))
             (ma0-say "converted-to-completed=~s" nil))))))

    ;; ---- W-ERROR-PROPAGATES, the runner half: UNCAUGHT ---------------------
    ;; Same shape as `w-error-propagates', with NO handler anywhere between
    ;; the evaluator and the runner.  The condition therefore reaches the
    ;; outermost unwind-protect, the run root is still removed, and the
    ;; process exits NONZERO.  Two scenarios rather than one because the two
    ;; halves of the law are different facts: WHAT propagated (typed, named)
    ;; and THAT the runner refused the run over it (exit code).
    ((string= scenario "w-error-uncaught")
     (let* ((p1 (lisp-plus-many-acts0:ma0-validate
                 (ma0-program-path "p1-editio.lisp")))
            (environment (ma0-env-p1))
            (first-result (lisp-plus-many-acts0:ma0-run-program p1 environment)))
       (ma0-say "first disposition=~s"
                (lisp-plus-many-acts0:ma0-result-disposition first-result))
       (let* ((path (ma0-write-witness "w-second-a.lisp" *w-second-a-source*))
              (second-program (lisp-plus-many-acts0:ma0-validate path)))
         (lisp-plus-many-acts0:ma0-run-program second-program environment)
         (ma0-say "UNEXPECTED-COMPLETION"))))

    ;; ---- W-NO-ERASE --------------------------------------------------------
    ;; ⚠ DRIVEN THROUGH THE EXPORTED COMPOSITION, NOT THROUGH A PROGRAM, AND
    ;; THE REASON IS STATED.  The law wants prefix digests BEFORE and AFTER the
    ;; later act's refusal.  A program run is one call with no seam in the
    ;; middle, and this lane has no evaluator hook — inventing one to make a
    ;; witness observable would be building the instrument the finding is
    ;; supposed to survive.  So the two earlier duties are composed here
    ;; directly (contract §6: `ma0-complete-act' is exported "so teeth can
    ;; drive it directly"), the snapshot is taken, the revoked duty is
    ;; attempted, and the snapshot is taken again.
    ;;
    ;; ⚠ Journal /0's per-event digest is PREFIX-CHAINED, not a content
    ;; address: the same frame bytes in two different stores digest
    ;; differently (observed — P2 α and β disagree on every frame digest for
    ;; the same acts).  So this comparison is only meaningful WITHIN one store,
    ;; which is exactly where it is made, and no cross-store digest equality is
    ;; claimed anywhere in this lane.
    ((string= scenario "w-no-erase")
     (let* ((environment (ma0-env-p2 :seat "prima"
                                     :revocations '((:arm "B-R"))))
            (seats '("prima" "ambigua"))
            (frames '(:f1 :f2 :f3 :f4 :f5)))
       (dolist (arm '("A" "C-i"))
         (let* ((fixture (ma0-fixture arm))
                (r (lisp-plus-language-act0:run-act fixture :verbose nil))
                (done (lisp-plus-many-acts0:ma0-complete-act r environment)))
           (ma0-say "composed arm=~s verdict=~s" arm (getf done :verdict))))
       (let ((before (loop for seat in seats
                           append (loop for frame in frames
                                        collect (list seat frame
                                                      (ma0-frame-digest seat frame)
                                                      (ma0-frame-ordinal seat frame)))))
             (frames-before (ma0-prefix-frame-count)))
         (ma0-say "before prefix-frames=~d" frames-before)
         ;; ---- the revoked duty.  Its L3b mint refuses BY NAME.
         (let ((r (lisp-plus-language-act0:run-act (ma0-fixture "B-R")
                                                   :verbose nil)))
           (ma0-say "revoked-duty class=~s disposition=~s"
                    (getf r :class) (getf r :disposition)))
         (let ((after (loop for seat in seats
                            append (loop for frame in frames
                                         collect (list seat frame
                                                       (ma0-frame-digest seat frame)
                                                       (ma0-frame-ordinal seat frame))))))
           (ma0-say "after prefix-frames=~d" (ma0-prefix-frame-count))
           (ma0-say "prefix-status=~s" (ma0-prefix-status))
           (ma0-say "earlier-frames-unchanged=~s" (equal before after))
           (ma0-say "earlier-frame-rows=~d" (length before))
           (loop for row in before
                 do (ma0-say "before ~a ~a digest=~a ordinal=~a"
                             (first row) (second row) (third row) (fourth row)))
           (loop for row in after
                 do (ma0-say "after ~a ~a digest=~a ordinal=~a"
                             (first row) (second row) (third row) (fourth row)))))))

    (t (ma0-say "UNKNOWN-SCENARIO ~a" scenario)
       (error "unknown scenario ~a" scenario))))

;;; --------------------------------------------------------------------------
;;; THE RUN.  One unwind-protect over everything, so the run root is removed on
;;; the green path, the red path, and the exceptional path alike.
;;; --------------------------------------------------------------------------

(let ((propagated nil))
  (unwind-protect
       (handler-case (ma0-run-scenario cl-user::*ma0-scenario*)
         (error (c)
           (setf propagated c)
           (ma0-say "PROPAGATED ~s" (type-of c))
           (format *error-output* "~&!! ~a~%" c)))
    (ignore-errors (uiop:delete-directory-tree cl-user::*ma0-root* :validate t))
    (format *error-output* "   run root removed: ~a (exists: ~a)~%"
            cl-user::*ma0-root*
            (and (probe-file cl-user::*ma0-root*) t))
    (finish-output *error-output*))
  (ma0-say "DRIVER-END ~a ~a" cl-user::*ma0-scenario*
           (if propagated "propagated" "reached-end"))
  (finish-output)
  (sb-ext:exit :code (if propagated 1 0)))
