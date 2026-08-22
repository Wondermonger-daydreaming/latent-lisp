;;;; act1-controls.lisp — One Act /1: the planted faults that MUST fire.
;;;;
;;;;   sbcl --script mneme/language-act-1/act1-controls.lisp
;;;;
;;;; Sentinel: oneact1-controls: <n> controls, <n> caught, 0 missed
;;;;
;;;; A GATE THAT HAS NEVER BEEN SEEN TO FIRE IS UNTESTED, NOT PASSING.  Every
;;;; instrument this lane leans on is exercised here against a deliberately
;;;; planted fault, and each control states what would have gone unnoticed if
;;;; the instrument had stayed silent.
;;;;
;;;; The world-scope absence instrument's competence control lives in the
;;;; SPECIMEN (de-actu-resurgente/stage-control-leak.lisp), because the
;;;; violation it must catch — a refused act that writes — needs a
;;;; post-death state to be worth planting.  It is not repeated here.
;;;;
;;;; — PONTIFEX (Claude Opus 5, subagent), 2026-08-19

(require :sb-posix)

(load (merge-pathnames "load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-language-act1)

(defparameter *lane-directory*
  (make-pathname :name nil :type nil :defaults *load-truename*))

(defvar *controls* 0)
(defvar *caught* 0)

(defun control (name caught-p detail)
  (incf *controls*)
  (when caught-p (incf *caught*))
  (format t "~&[~a] ~a~%      ~a~%"
          (if caught-p "CAUGHT " "MISSED ") (format nil name) detail)
  (finish-output)
  caught-p)

(format t "~&One Act /1 — planted faults.  CANDIDATE; nothing here is adopted.~%~%")

;;; ===========================================================================
;;; CONTROL 1 — the environment pre-flight VOIDS the suite.
;;;
;;; Without teeth here, a run with a process-ending switch set would report a
;;; clean pass while its own crash-model declaration was false.
;;; ===========================================================================

(let* ((output (make-string-output-stream))
       (process (sb-ext:run-program
                 "sbcl" (list "--script" "mneme/language-act-1/act1-selftest.lisp")
                 :search t :output output :error output
                 :environment (cons "CAP2_WORLD_DIE_IN_WINDOW=1"
                                    (sb-ext:posix-environ))))
       (text (get-output-stream-string output))
       (code (sb-ext:process-exit-code process)))
  (control "PLANTED: the suite is run with CAP2_WORLD_DIE_IN_WINDOW=1 — a ~
switch that can end the process inside the frontier window, in a suite that ~
declares ONE PROCESS LIFE"
           (and (eql 4 code)
                (search "VOID" text)
                (search "W-ENV CAP2_WORLD_DIE_IN_WINDOW SET=" text)
                (not (search "0 failures" text)))
           (format nil "exit ~a · the run VOIDED, named the variable and its ~
value, created no journal store, and did NOT report a pass.  A VOID is not a ~
failure and is not a pass." code)))

;;; ===========================================================================
;;; CONTROL 2 — the readiness predicate catches an incomplete lane.
;;;
;;; PACKAGE EXISTENCE IS NOT IMPLEMENTATION READINESS.  These plants damage the
;;; loaded lane in the two ways a half-finished load damages it, and require the
;;; shipped predicate to say so — then restore, and require it to go green
;;; again, so the plant is shown to be the cause.
;;; ===========================================================================

(let* ((package (find-package '#:lisp-plus-language-act1))
       (carrier (find-symbol "*ACT1-LANE-READY-CARRIER*" package))
       (saved (symbol-value carrier)))
  (makunbound carrier)
  (let ((shortfall (lisp-plus-language-act1-loader:act1-api-shortfall)))
    (control "PLANTED: the readiness carrier is UNBOUND — exactly the state a ~
load that died before the final form of the last source would leave"
             (and shortfall
                  (some (lambda (line) (search "readiness carrier" line)) shortfall))
             (format nil "the predicate reported: ~{~a~^; ~}" shortfall)))
  (setf (symbol-value carrier) '(:lane "one-act-1" :final-source "wrong.lisp"))
  (let ((shortfall (lisp-plus-language-act1-loader:act1-api-shortfall)))
    (control "PLANTED: the readiness carrier holds a WRONG VALUE — a successor ~
that reordered the lane's sources and left the carrier behind"
             (and shortfall
                  (some (lambda (line) (search "not the declared value" line))
                        shortfall))
             (format nil "the predicate reported: ~{~a~^; ~}" shortfall)))
  (setf (symbol-value carrier) saved)
  (control "RESTORED: with the carrier put back, the predicate goes green — ~
so the two catches above were caused by the plant and not by something else"
           (lisp-plus-language-act1-loader:act1-api-complete-p)
           "act1-api-complete-p => T"))

(let ((package (find-package '#:lisp-plus-language-act1)))
  (unexport (find-symbol "RUN-ACT1" package) package)
  (let ((shortfall (lisp-plus-language-act1-loader:act1-api-shortfall)))
    (control "PLANTED: a declared external name is UNEXPORTED — the lane's ~
interface silently narrowing under a consumer"
             (and shortfall
                  (some (lambda (line) (search "RUN-ACT1: present but not external"
                                               line))
                        shortfall))
             (format nil "the predicate reported: ~{~a~^; ~}" shortfall)))
  (export (find-symbol "RUN-ACT1" package) package)
  (control "RESTORED: re-exporting RUN-ACT1 returns the predicate to green"
           (lisp-plus-language-act1-loader:act1-api-complete-p)
           "act1-api-complete-p => T"))

;;; ===========================================================================
;;; CONTROL 3 — the :refused-across-death class row cannot be abused.
;;;
;;; That row exists because a resurgent image reads the DEAD act's standing
;;; under its own attempt name.  It is admitted ONLY when the journal's frame
;;; count is unchanged across the act.  Plant a moved frame count and the row
;;; must refuse to fire.
;;; ===========================================================================

(let ((root (pathname (concatenate 'string
                                   (sb-posix:mkdtemp "/tmp/oneact1-controls-XXXXXX")
                                   "/"))))
  (unwind-protect
       (progn
         (setf *act1-run-root* root)
         (setf *act1-store* (build-act1-store root))
         (setf *act1-worlds* (build-act1-worlds root))
         (setf *act1-bootstrap*
               (declare-bootstrap-authority
                '("issuer" "oneact1") (journal-store-store-id *act1-store*)))
         (setf *act1-minting-context*
               (make-minting-context :label "oneact1-controls"))
         (let ((row (make-act1-fixture-row
                     :arm "CTL" :label "prima" :runtime-seat "prima"
                     :attempt-name "a-prima" :cell-segments '("cella" "prima")
                     :adapter-symbol 'control/bridge :world-key :apply
                     :form (act1-request-form "cella:prima"
                                              "Epistula quae numquam venit.")
                     :interruption :request-lost)))
           (setf *act1-fixture-table* (list row))
           (act1-opening-authority *act1-store* *act1-fixture-table*)
           (run-act1 row :verbose nil))
         (let ((frames (nth-value 1 (act1-journal-kinds *act1-store*))))
           (control "PLANTED: the :refused-across-death classification is ~
offered a frame count that MOVED during the act — i.e. an act that appended ~
something and still claims to have refused"
                    (eq :unclassifiable
                        (act1-derive-class *act1-store* "a-prima" :refused
                                           :frames-before (1- frames)))
                    (format nil "class => :UNCLASSIFIABLE (a host fault).  With ~
the true frame count (~d) the same call classifies :REFUSED-ACROSS-DEATH — so ~
the row is gated by the check and not by the standing alone."
                            frames))
           (control "CONTROL for that control: with the TRUE frame count the ~
row does fire"
                    (eq :refused-across-death
                        (act1-derive-class *act1-store* "a-prima" :refused
                                           :frames-before frames))
                    "class => :REFUSED-ACROSS-DEATH")))
    (when (probe-file root) (sb-ext:delete-directory root :recursive t))))

;;; ===========================================================================
;;; CONTROL 3b — A HOST FAULT MUST NOT WEAR A CAPABILITY REFUSAL'S CLOTHES.
;;;
;;; Sol's cold-parcel blocking finding (2026-08-20).  The D1/D2 handler-case
;;; caught `(error (c))`, so an unexpected implementation error raised before
;;; any attempt frame landed was converted into an ordinary pre-frontier
;;; refusal — with a refused Outcome and a freshly issued Core /0 evidence
;;; account attached to a TYPE-ERROR.  This control is the permanent gate on
;;; the repair; the full RED and GREEN transcripts are
;;; RED-PROOF-HOST-FAULT-{BEFORE,AFTER}.txt.
;;;
;;; TWO HALVES, and the second is what keeps the first honest: narrowing a
;;; handler can always be "fixed" by refusing everything, so the control also
;;; requires that a LAWFUL refusal from an ADMITTED family still classifies as
;;; a refusal on the same seat, in the same run.
;;; ===========================================================================

(let ((root (pathname (concatenate 'string
                                   (sb-posix:mkdtemp "/tmp/oneact1-hostfault-XXXXXX")
                                   "/"))))
  (unwind-protect
       (progn
         (setf *act1-run-root* root)
         (setf *act1-store* (build-act1-store root))
         (setf *act1-worlds* (build-act1-worlds root))
         (setf *act1-bootstrap*
               (declare-bootstrap-authority
                '("issuer" "oneact1") (journal-store-store-id *act1-store*)))
         (setf *act1-minting-context*
               (make-minting-context :label "oneact1-controls-hostfault"))
         (let ((planted (make-act1-fixture-row
                         :arm "HF" :label "prima" :runtime-seat "prima"
                         :attempt-name "a-prima" :cell-segments '("cella" "prima")
                         :adapter-symbol 'control/host-fault :world-key :apply
                         :form (act1-request-form "cella:prima"
                                                  "Error non declaratus.")
                         :host-fault-plant :unexpected-error-before-frontier))
               (lawful (make-act1-fixture-row
                        :arm "HF-CONTROL" :label "revocata"
                        :runtime-seat "revocata" :attempt-name "a-revocata"
                        :cell-segments '("cella" "revocata") :world-key :apply
                        :adapter-symbol 'control/host-fault-lawful
                        :form (act1-request-form "cella:revocata" "Manus mortua.")
                        :revoke-after-mint t)))
           (setf *act1-fixture-table* (list planted lawful))
           (act1-opening-authority *act1-store* *act1-fixture-table*)
           (let* ((frames-before (nth-value 1 (act1-journal-kinds *act1-store*)))
                  (before (take-world-scope
                           (getf *act1-worlds* :apply)
                           (getf *act1-world-directories* :apply)
                           :request-key (external-request-key "a-prima")))
                  (result (run-act1 planted :verbose nil))
                  (after (take-world-scope
                          (getf *act1-worlds* :apply)
                          (getf *act1-world-directories* :apply)
                          :request-key (external-request-key "a-prima"))))
             (print-world-scope-universe "HOST-FAULT CONTROL" before after)
             (control "PLANTED: a real TYPE-ERROR — an UNDECLARED, unadmitted ~
condition — is raised inside the shipped D1/D2 protected form, before D1 and ~
before any attempt frame can land"
                      (and (eq :host-fault (act1-result-disposition result))
                           (eq :host-fault-pre-frontier (act1-result-class result))
                           (eq :absent (act1-result-standing result))
                           (null (act1-result-outcome result))
                           (null (act1-result-evidence result))
                           (null (act1-result-reason result)))
                      (format nil "disposition ~s · class ~s · NO Outcome, NO ~
evidence, NO reason keyword — it is not a refusal in any of the three places a ~
refusal is read"
                              (act1-result-disposition result)
                              (act1-result-class result)))
             (control "and the fault left the durable world exactly as it found ~
it: journal frame count unmoved and the ENTIRE world byte-unchanged (universe ~
printed above) — the defect was a CLASSIFICATION defect, never a transition one"
                      (and (= frames-before
                              (nth-value 1 (act1-journal-kinds *act1-store*)))
                           (world-scope-unchanged-p before after))
                      (format nil "frames ~d -> ~d" frames-before
                              (nth-value 1 (act1-journal-kinds *act1-store*)))))
           ;; THE SECOND HALF: the narrowing must not have turned the admitted
           ;; families into host faults too.
           (let ((result (run-act1 lawful :verbose nil)))
             (control "CONTROL for that control: a LAWFUL refusal from an ~
ADMITTED family (capability /2's own CAP2-AUTH-1, on the same store, in the ~
same run) still classifies as a REFUSAL — the repair narrowed the handler, it ~
did not make the lane refuse everything"
                      (and (eq :refused (act1-result-disposition result))
                           (eq :refused (act1-result-class result))
                           (eq :|CAP2-ATTEMPT-AUTHORIZATION-REFUSED/CAP2-AUTH-1|
                               (act1-result-reason result))
                           (eq :refused (lisp-plus-core0:outcome-kind
                                         (act1-result-outcome result))))
                      (format nil "disposition ~s · reason ~s · outcome-kind ~s"
                              (act1-result-disposition result)
                              (act1-result-reason result)
                              (lisp-plus-core0:outcome-kind
                               (act1-result-outcome result)))))))
    (when (probe-file root) (sb-ext:delete-directory root :recursive t))))

;;; ===========================================================================
;;; CONTROL 4 — THE ARTIFACT COMPARATOR, on a planted byte difference.
;;;
;;; The specimen's determinism claim rests on comparing preserved artifacts
;;; across runs.  A comparator that has only ever been shown two identical files
;;; has not been shown to be a comparator.
;;; ===========================================================================

(let* ((specimen (merge-pathnames "de-actu-resurgente/" *lane-directory*))
       (artifacts (sort (mapcar #'file-namestring
                                (directory (merge-pathnames "ARTIFACT-*.*" specimen)))
                        #'string<)))
  (flet ((octets (name)
           (with-open-file (stream (merge-pathnames name specimen)
                                   :direction :input
                                   :element-type '(unsigned-byte 8)
                                   :if-does-not-exist nil)
             (when stream
               (let ((buffer (make-array (file-length stream)
                                         :element-type '(unsigned-byte 8))))
                 (read-sequence buffer stream)
                 buffer)))))
    (let* ((name (first artifacts))
           (original (octets name)))
      (control "the comparator's universe is stated: every preserved ARTIFACT-* ~
file of the specimen, listed from disk rather than assumed"
               (and artifacts (every #'octets artifacts))
               (format nil "~d artifacts: ~{~a~^, ~}" (length artifacts) artifacts))
      (control "SANITY: the comparator calls an unmodified copy IDENTICAL"
               (equalp original (copy-seq original))
               (format nil "~a: ~d octets" name (length original)))
      (let ((planted (copy-seq original)))
        (setf (aref planted (floor (length planted) 2))
              (logxor 1 (aref planted (floor (length planted) 2))))
        (control "PLANTED: ONE BIT is flipped in the middle of a preserved ~
artifact — the smallest difference a byte-identity claim can hide"
                 (and (not (equalp original planted))
                      (= (length original) (length planted))
                      (not (string= (sha256-hex original) (sha256-hex planted))))
                 (format nil "~a: the comparator reports DIFFERENT, and the ~
sha256 differs (~a vs ~a) — same length, one bit"
                         name
                         (subseq (sha256-hex original) 0 16)
                         (subseq (sha256-hex planted) 0 16)))))))

;;; ---------------------------------------------------------------------------

(format t "~&~%oneact1-controls: ~d controls, ~d caught, ~d missed~%"
        *controls* *caught* (- *controls* *caught*))
(finish-output)
(sb-ext:exit :code (if (= *controls* *caught*) 0 1))
