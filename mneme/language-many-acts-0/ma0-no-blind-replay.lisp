;;;; ma0-no-blind-replay.lisp — W-NO-BLIND-REPLAY, driven hostilely.
;;;; (FAILURE MATRIX §2: "no construct re-fires an act; a hostile second
;;;; invocation of a consumed arm (driver-level) is refused by the ADOPTED lane
;;;; (identity/seat law) — witnessed firing, attributed to One Act not MA0".)
;;;;
;;;;   sbcl --script mneme/language-many-acts-0/ma0-no-blind-replay.lisp
;;;;
;;;; CANDIDATE.  Executing a candidate is not adopting it (contract §0, §8), and
;;;; nothing this file prints is independent verification (AP0 adoption Rider 2).
;;;;
;;;; ---------------------------------------------------------------------------
;;;; WHOSE LAW THIS IS
;;;; ---------------------------------------------------------------------------
;;;;
;;;; ⚠ THE REFUSAL WITNESSED HERE IS ONE ACT /0'S, AND EVERY CHECK NAME SAYS SO.
;;;; MANY ACTS /0 refuses a repeated arm STATICALLY, in its validator, so a
;;;; PROGRAM can never reach this state — which is exactly why the witness is
;;;; driven from OUTSIDE the program surface: a law that only ever fires behind
;;;; a validator that already refused is a law nobody has seen fire.  This file
;;;; therefore skips MA0's own guard on purpose, completes one act through the
;;;; lane's composition, and then re-invokes the SAME arm in the SAME store by
;;;; hand.  What refuses is the adopted lane's identity/seat law.  MA0 neither
;;;; invented it nor could have, and the transcript records which requirement
;;;; fired, verbatim, rather than describing it.
;;;;
;;;; THE CONTROL COMES FIRST.  A run whose only evidence is a refusal has shown
;;;; that something refuses, not that a consumed arm is what refuses.  So the
;;;; first invocation must COMPLETE and be shown to have completed, and the
;;;; store must be shown intact after the refused second one — a refusal that
;;;; damaged the prefix would be a different failure wearing this one's name.
;;;;
;;;; Sentinel, printed on the green path and no other:
;;;;   ma0-no-blind-replay: <N> checks, 0 failures
;;;;
;;;; — DENS (Claude Opus 5, subagent), 2026-08-09

(require :asdf)
(require :sb-posix)

(unless (string= (lisp-implementation-version) "2.4.6")
  (format *error-output*
          "~&!! FAIL CLOSED: authorized for SBCL 2.4.6 only.  Observed ~a.~%"
          (lisp-implementation-version))
  (finish-output *error-output*)
  (sb-ext:exit :code 1))

(defparameter cl-user::*dens-here*
  (make-pathname :name nil :type nil :defaults *load-truename*))

(defparameter cl-user::*dens-tree*
  (truename (merge-pathnames "../../" cl-user::*dens-here*)))

(defparameter cl-user::*dens-root*
  (let* ((tmp (or (sb-ext:posix-getenv "TMPDIR") "/tmp"))
         (dir (sb-posix:mkdtemp
               (concatenate 'string (string-right-trim "/" tmp)
                            "/ma0-replay.XXXXXX"))))
    (truename (concatenate 'string dir "/"))))

(let ((tree (namestring cl-user::*dens-tree*))
      (root (namestring cl-user::*dens-root*)))
  (when (and (>= (length root) (length tree))
             (string= tree (subseq root 0 (length tree))))
    (format *error-output* "~&!! FAIL CLOSED: run root ~a is INSIDE ~a~%" root tree)
    (ignore-errors (uiop:delete-directory-tree cl-user::*dens-root* :validate t))
    (finish-output *error-output*)
    (sb-ext:exit :code 1)))

(format *error-output* "~&== ma0-no-blind-replay — SBCL ~a ==~%   run root: ~a~%"
        (lisp-implementation-version) cl-user::*dens-root*)
(finish-output *error-output*)

(asdf:initialize-source-registry
 `(:source-registry (:directory ,(namestring cl-user::*dens-tree*))
   :inherit-configuration))

(let ((*standard-output* (make-broadcast-stream)))
  (asdf:load-system "lisp-plus/many-acts-0"))

(in-package #:cl-user)

(defvar *passed* 0)
(defvar *failed* 0)

(defun dens-check (name ok &optional (fmt "") &rest args)
  (if ok (incf *passed*) (incf *failed*))
  (format t "~&  [~a] ~a~@[  ~a~]~%" (if ok "PASS" "FAIL") name
          (let ((s (apply #'format nil fmt args))) (if (string= s "") nil s)))
  (force-output)
  (and ok t))

(defun dens-store () lisp-plus-language-act0:*store*)

(defun dens-prefix-frames ()
  (lisp-plus-journal0:prefix-report-frame-count
   (lisp-plus-journal0:validate-journal (dens-store))))

(defun dens-prefix-status ()
  (lisp-plus-journal0:prefix-report-status
   (lisp-plus-journal0:validate-journal (dens-store))))

(defun dens-fixture (arm)
  (find arm lisp-plus-language-act0:*act-fixture-table*
        :key #'lisp-plus-language-act0:act-fixture-arm :test #'string=))

(defun dens-run ()
  (format t "~&== W-NO-BLIND-REPLAY — a consumed arm, re-invoked by hand ==~%")
  (let* ((environment (lisp-plus-many-acts0:make-ma0-environment
                       :root cl-user::*dens-root*
                       :arms '("A")
                       :grants '((:slot "g" :arm "A"))
                       :revocations '()
                       :seat-map '()
                       :inputs '()))
         (fixture (dens-fixture "A"))
         (attempt (lisp-plus-language-act0:act-fixture-attempt-name fixture)))

    ;; ---- THE CONTROL ARM.  One complete act, through this lane's composition.
    (let* ((first-result (lisp-plus-language-act0:run-act fixture :verbose nil))
           (done (lisp-plus-many-acts0:ma0-complete-act first-result environment)))
      (dens-check "CONTROL the first invocation completes"
                  (equal "agree" (getf done :verdict))
                  "class=~s verdict=~s" (getf done :class) (getf done :verdict))
      (dens-check "CONTROL its F1 is durable for this attempt"
                  (and (lisp-plus-journal0:find-event
                        (dens-store)
                        (lisp-plus-language-act0:frame-event-id :f1 attempt))
                       t)))

    (let ((frames-before (dens-prefix-frames)))
      (format t "~&    prefix frames after the completed act: ~d~%" frames-before)

      ;; ---- THE HOSTILE REPLAY.  Same arm, same store, no MA0 guard in the way.
      (let ((fired nil) (kind nil) (requirement nil) (ma0-typed nil))
        (handler-case
            (progn (lisp-plus-language-act0:run-act fixture :verbose nil)
                   (format t "~&    !! THE REPLAY RETURNED — nothing refused it~%"))
          (lisp-plus-language-act0:act0-condition (c)
            (setf fired t
                  kind (type-of c)
                  requirement
                  (lisp-plus-language-act0:act0-condition-requirement-id c)
                  ma0-typed (typep c 'lisp-plus-many-acts0:ma0-refusal))))

        (dens-check "W-NO-BLIND-REPLAY the ADOPTED lane (One Act /0) refuses the replay"
                    fired "type=~s requirement=~s" kind requirement)
        (dens-check "W-NO-BLIND-REPLAY the refusal carries One Act /0's own requirement-id"
                    (and requirement (stringp requirement) (plusp (length requirement)))
                    "requirement-id=~s" requirement)
        (dens-check "W-NO-BLIND-REPLAY the refusal is NOT an MA0 condition — the law is One Act /0's"
                    (and fired (null ma0-typed))
                    "typep ma0-refusal => ~s" ma0-typed)
        (format t "~&DENS-REPLAY refusal-type=~a~%" kind)
        (format t "~&DENS-REPLAY refusal-requirement-id=~a~%" requirement)

        ;; ---- the refused replay left nothing behind.
        (dens-check "W-NO-BLIND-REPLAY the refused replay appended nothing"
                    (eql frames-before (dens-prefix-frames))
                    "before=~d after=~d" frames-before (dens-prefix-frames))
        (dens-check "W-NO-BLIND-REPLAY the prefix still reads back whole"
                    (eq :valid (dens-prefix-status))
                    "status=~s" (dens-prefix-status))))))

(let ((suite-error nil))
  (unwind-protect
       (handler-case (dens-run)
         (error (c)
           (setf suite-error c)
           (format t "~&!! THE WITNESS SIGNALLED: ~a~%" (type-of c))
           (format *error-output* "~&!! ~a~%" c)))
    (ignore-errors (uiop:delete-directory-tree cl-user::*dens-root* :validate t))
    (format *error-output* "   run root removed (exists: ~a)~%"
            (and (probe-file cl-user::*dens-root*) t))
    (finish-output *error-output*))
  (let* ((total (+ *passed* *failed*))
         (green (and (null suite-error) (zerop *failed*) (plusp total))))
    (format t "~&~%== TALLY: ~d passed, ~d failed ==~%" *passed* *failed*)
    (if green
        (format t "~&ma0-no-blind-replay: ~d checks, 0 failures~%" total)
        (format t "~&ma0-no-blind-replay: RUN REFUSED — ~d check(s), ~d failure(s).~
~@[  the witness signalled: ~a~]  The success sentinel is WITHHELD.~%"
                total *failed* (and suite-error (type-of suite-error))))
    (finish-output)
    (sb-ext:exit :code (if green 0 1))))
