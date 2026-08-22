;;;; act1-red-proof.lisp — One Act /1: THE CROWN TOOTH, SHOWN TO BLEED.
;;;;
;;;;   sbcl --script mneme/language-act-1/act1-red-proof.lisp
;;;;
;;;; Sentinel: oneact1-red-proof: cured PASS, uncured FAIL — the tooth bites
;;;;
;;;; A SUITE NEVER SEEN TO FAIL LICENSES NOTHING.  This file runs the crown
;;;; tooth — the predicate de-actu-resurgente's restart stage rests on — twice:
;;;; once against the lane as it ships (CURED) and once against a deliberately
;;;; uncured bridge whose dispatch does not consult the durable bytes
;;;; (:durable-guard :skip-store).  The uncured run must FAIL, visibly, in this
;;;; transcript.  It exits NONZERO if the uncured arm passes.
;;;;
;;;; THE GROUND IS THE DEATH SHAPE WITHOUT A DEATH: capability /2's
;;;; :request-lost seam leaves the frontier crossed with nothing after it and
;;;; the world untouched — the same DURABLE shape the specimen's dead process
;;;; leaves, reached in one process so the proof is small and re-runnable.
;;;;
;;;; ⚠ WHAT THIS PROOF DOES **NOT** SHOW, stated here rather than left for a
;;;; reader to discover: removing the language guard does NOT let the act
;;;; through.  capability /2's `authorize-effect-attempt` consults the same gate
;;;; at the runtime boundary, so the uncured act is STILL REFUSED and the world
;;;; is STILL byte-unchanged.  The refusal is OVER-DETERMINED.  What the tooth
;;;; detects is WHICH BOUNDARY ANSWERED — and that is worth detecting, because
;;;; the lane's claim is about the LANGUAGE door, not about the runtime's.  The
;;;; state where nothing refuses at all requires both defences down, and that
;;;; state is exhibited — with a real unauthorised write — by the specimen's
;;;; leak control.
;;;;
;;;; — PONTIFEX (Claude Opus 5, subagent), 2026-08-19

(require :sb-posix)

(load (merge-pathnames "load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-language-act1)

(defparameter *lane-directory*
  (make-pathname :name nil :type nil :defaults *load-truename*))
(defparameter *subject-root* (merge-pathnames "../../" *lane-directory*))

(defvar *cured-passed* nil)
(defvar *uncured-passed* nil)

;;; THE CROWN TOOTH, written ONCE and applied to both arms.  If the two arms had
;;; their own copies of the predicate, this file would prove nothing.
(defun crown-tooth (result)
  "The predicate de-actu-resurgente/stage-restart.lisp rests on: the language
door refused this act, pre-frontier, AND the reason names THIS LANE'S durable
guard with capability /2's CAP2-W1 provenance."
  (and (eq :refused (act1-result-disposition result))
       (eq :refused (lisp-plus-core0:outcome-kind (act1-result-outcome result)))
       (eq :|ACT1-DURABLE-GUARD/UNSAFE-RETRY/CAP2-W1| (act1-result-reason result))))

(defun ground (root)
  (setf *act1-run-root* root)
  (setf *act1-store* (build-act1-store root))
  (setf *act1-worlds* (build-act1-worlds root))
  (setf *act1-bootstrap*
        (declare-bootstrap-authority '("issuer" "oneact1")
                                     (journal-store-store-id *act1-store*)))
  (setf *act1-minting-context* (make-minting-context :label "oneact1-red-proof"))
  (let ((row (make-act1-fixture-row
              :arm "GROUND" :label "prima" :runtime-seat "prima"
              :attempt-name "a-prima" :cell-segments '("cella" "prima")
              :adapter-symbol 'red-proof/ground :world-key :apply
              :form (act1-request-form "cella:prima" "Epistula quae numquam venit.")
              :interruption :request-lost)))
    (setf *act1-fixture-table* (list row))
    (act1-opening-authority *act1-store* *act1-fixture-table*)
    (let ((result (run-act1 row :verbose nil)))
      (format t "~&GROUND: standing ~s · frames ~d · world ledger entries ~d ~
— the frontier is crossed, nothing follows it in the journal, and the world ~
was never touched: the durable shape a death leaves.~%~%"
              (act1-result-standing result)
              (nth-value 1 (act1-journal-kinds *act1-store*))
              (world-ledger-count (getf *act1-worlds* :apply))))))

(defun arm (label row)
  (let* ((before (take-world-scope (getf *act1-worlds* :apply)
                                   (getf *act1-world-directories* :apply)
                                   :request-key (external-request-key
                                                 (act1-fixture-attempt-name row))))
         (result (run-act1 row :verbose nil))
         (after (take-world-scope (getf *act1-worlds* :apply)
                                  (getf *act1-world-directories* :apply)
                                  :request-key (external-request-key
                                                (act1-fixture-attempt-name row))))
         (verdict (crown-tooth result)))
    (format t "~&---- ~a ----~%" (format nil label))
    (format t "  durable-guard column : ~s~%" (act1-fixture-durable-guard row))
    (format t "  disposition          : ~s~%" (act1-result-disposition result))
    (format t "  outcome-kind         : ~s~%"
            (lisp-plus-core0:outcome-kind (act1-result-outcome result)))
    (format t "  reason               : ~s~%" (act1-result-reason result))
    (format t "  world byte-unchanged : ~a~%"
            (if (world-scope-unchanged-p before after) "yes" "NO"))
    (format t "  CROWN TOOTH          : ~a~%~%" (if verdict "PASS" "FAIL"))
    (finish-output)
    verdict))

(format t "~&One Act /1 — RED PROOF of the crown tooth.  CANDIDATE; nothing ~
here is adopted.~%~%")

(unless (act1-env-preflight :signal nil)
  (format t "~&oneact1-red-proof: VOID — a process-ending switch is set.~%")
  (sb-ext:exit :code 4))
(terpri)

(let ((root (pathname (concatenate 'string
                                   (sb-posix:mkdtemp "/tmp/oneact1-red-XXXXXX")
                                   "/"))))
  (unless (null (search (namestring (truename *subject-root*)) (namestring root)))
    (format t "~&RUN ROOT IS INSIDE THE SUBJECT TREE — refusing to write.~%")
    (sb-ext:exit :code 3))
  (unwind-protect
       (progn
         (ground root)
         (setf *cured-passed*
               (arm "CURED — the lane as it ships (:durable-guard :consult-store)"
                    (make-act1-fixture-row
                     :arm "CURED" :label "prima" :runtime-seat "prima"
                     :attempt-name "a-prima-1" :cell-segments '("cella" "prima")
                     :adapter-symbol 'red-proof/cured :world-key :apply
                     :form (act1-request-form "cella:prima" "Cum custode."))))
         (setf *uncured-passed*
               (arm "UNCURED — the bridge does not consult the durable bytes ~
(:durable-guard :skip-store)"
                    (make-act1-fixture-row
                     :arm "UNCURED" :label "prima" :runtime-seat "prima"
                     :attempt-name "a-prima-2" :cell-segments '("cella" "prima")
                     :adapter-symbol 'red-proof/uncured :world-key :apply
                     :form (act1-request-form "cella:prima" "Sine custode.")
                     :durable-guard :skip-store))))
    (when (probe-file root) (sb-ext:delete-directory root :recursive t))))

(format t "~&READ THIS BEFORE BANKING THE PROOF: the uncured act was still ~
REFUSED and the world still byte-unchanged — capability /2 refuses at the ~
runtime boundary with a reason of its own.  The tooth kills the uncured bridge ~
on WHICH BOUNDARY ANSWERED, which is what the lane's claim is about.  A state ~
in which nothing refuses needs BOTH defences down; the specimen's leak control ~
builds exactly that state and catches the resulting write.~%~%")

(let ((green (and *cured-passed* (not *uncured-passed*))))
  (format t "~&oneact1-red-proof: cured ~a, uncured ~a — the tooth ~a~%"
          (if *cured-passed* "PASS" "FAIL")
          (if *uncured-passed* "PASS" "FAIL")
          (if green "bites" "DID NOT BITE"))
  (finish-output)
  (sb-ext:exit :code (if green 0 1)))
