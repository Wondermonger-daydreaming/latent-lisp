;;;; act1-mutants.lisp — One Act /1: three planted defects, each killed by a
;;;; NAMED predicate.
;;;;
;;;;   sbcl --script mneme/language-act-1/act1-mutants.lisp
;;;;
;;;; Sentinel: oneact1-mutants: 3 defects, 3 killed, 0 survivors
;;;;
;;;; A MUTANT IS ONLY WORTH ANYTHING IF IT IS WIRED INTO THE REAL PATH.  All
;;;; three seams below live in act1.lisp's shipped dispatch and doors, behind
;;;; fixture columns whose production value is NIL — capability /2's own
;;;; `defect` precedent (authorize.lisp:106, attempt.lisp:126).  Killing a
;;;; mutant that only exists inside this file would prove nothing about the
;;;; lane.
;;;;
;;;; EACH KILL NAMES ITS PREDICATE.  "The mutant died" is not a finding; "the
;;;; mutant died BY THIS PREDICATE, and the predicate is the one the honest arms
;;;; rely on" is.
;;;;
;;;; ⚠ M1 CARRIES THE LANE'S MOST IMPORTANT HONESTY: with the language guard
;;;; removed the act is STILL REFUSED, at capability /2's runtime boundary.  The
;;;; refusal is OVER-DETERMINED.  M1's predicate therefore kills on the REASON —
;;;; which boundary answered — and this file says so out loud rather than
;;;; letting a reader infer that the guard is what stands between the lane and a
;;;; double-apply.  What stands between the lane and a double-apply, when BOTH
;;;; are removed, is nothing — which is exactly what the leak control in
;;;; de-actu-resurgente exhibits.
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

(defvar *defects* 0)
(defvar *killed* 0)

(defun report-kill (name predicate killed-p detail)
  (incf *defects*)
  (when killed-p (incf *killed*))
  (format t "~&[~a] ~a~%      killed by: ~a~%      ~a~%"
          (if killed-p "KILLED  " "SURVIVED")
          (format nil name) (format nil predicate) detail)
  (finish-output)
  killed-p)

;;; ---------------------------------------------------------------------------
;;; Ground: one store, two worlds, and a seat left CROSSED-UNSETTLED by a
;;; request that never reached the world (capability /2's :request-lost seam) —
;;; the same shape a death leaves, reached without killing a process.

(defun ground (root)
  (setf *act1-run-root* root)
  (setf *act1-store* (build-act1-store root))
  (setf *act1-worlds* (build-act1-worlds root))
  (setf *act1-bootstrap*
        (declare-bootstrap-authority '("issuer" "oneact1")
                                     (journal-store-store-id *act1-store*)))
  (setf *act1-minting-context* (make-minting-context :label "oneact1-mutants"))
  (let ((row (make-act1-fixture-row
              :arm "GROUND" :label "prima" :runtime-seat "prima"
              :attempt-name "a-prima" :cell-segments '("cella" "prima")
              :adapter-symbol 'mutant-ground/bridge :world-key :apply
              :form (act1-request-form "cella:prima" "Epistula quae numquam venit.")
              :interruption :request-lost)))
    (setf *act1-fixture-table* (list row))
    (act1-opening-authority *act1-store* *act1-fixture-table*)
    (let ((result (run-act1 row :verbose nil)))
      (format t "~&ground: the request was LOST in flight — frontier crossed, ~
world never touched.  standing ~s · frames ~d · ledger entries ~d~%"
              (act1-result-standing result)
              (nth-value 1 (act1-journal-kinds *act1-store*))
              (world-ledger-count (getf *act1-worlds* :apply)))
      result)))

;;; ---------------------------------------------------------------------------
;;; M1 — :bridge-skips-store-check.

(defun mutant-1 ()
  (let* ((cured (make-act1-fixture-row
                 :arm "M1-cured" :label "prima" :runtime-seat "prima"
                 :attempt-name "a-prima-1" :cell-segments '("cella" "prima")
                 :adapter-symbol 'mutant-1/bridge-cured :world-key :apply
                 :form (act1-request-form "cella:prima" "Iterum, cum custode.")))
         (uncured (make-act1-fixture-row
                   :arm "M1-uncured" :label "prima" :runtime-seat "prima"
                   :attempt-name "a-prima-2" :cell-segments '("cella" "prima")
                   :adapter-symbol 'mutant-1/bridge-uncured :world-key :apply
                   :form (act1-request-form "cella:prima" "Iterum, sine custode.")
                   :durable-guard :skip-store))
         (before (take-world-scope (getf *act1-worlds* :apply)
                                   (getf *act1-world-directories* :apply)))
         (cured-result (run-act1 cured :verbose nil))
         (uncured-result (run-act1 uncured :verbose nil))
         (after (take-world-scope (getf *act1-worlds* :apply)
                                  (getf *act1-world-directories* :apply))))
    (report-kill
     ":bridge-skips-store-check — the bridge dispatches without consulting the ~
durable bytes"
     "REASON-NAMES-THE-DURABLE-GUARD (the crown tooth's own predicate)"
     (and (eq :|ACT1-DURABLE-GUARD/UNSAFE-RETRY/CAP2-W1|
              (act1-result-reason cured-result))
          (not (eq :|ACT1-DURABLE-GUARD/UNSAFE-RETRY/CAP2-W1|
                   (act1-result-reason uncured-result))))
     (format nil "cured reason ~s · UNCURED reason ~s.  ⚠ HONESTY: the uncured ~
act is STILL REFUSED — capability /2's authorization consults the same gate at ~
the runtime boundary, so the refusal is OVER-DETERMINED and the world stayed ~
byte-unchanged (~a) under BOTH.  This mutant is killed by WHICH BOUNDARY ~
ANSWERED, not by a leaked write; the leaked write needs both defences down, ~
which is the de-actu-resurgente leak control."
             (act1-result-reason cured-result)
             (act1-result-reason uncured-result)
             (if (world-scope-unchanged-p before after) "verified" "VIOLATED")))))

;;; ---------------------------------------------------------------------------
;;; M2 — :refusal-swallowed-to-success.

(defun mutant-2 ()
  (let* ((row (make-act1-fixture-row
               :arm "M2" :label "prima" :runtime-seat "prima"
               :attempt-name "a-prima-3" :cell-segments '("cella" "prima")
               :adapter-symbol 'mutant-2/bridge :world-key :apply
               :form (act1-request-form "cella:prima" "Refutatio deglutita.")
               :project-defect :refusal-swallowed-to-success))
         (before (take-world-scope (getf *act1-worlds* :apply)
                                   (getf *act1-world-directories* :apply)))
         (fired nil)
         (requirement nil)
         (outcome-view :none))
    (handler-case
        (let ((result (run-act1 row :verbose nil)))
          (setf outcome-view (and (act1-result-outcome result)
                                  (lisp-plus-core0:outcome-kind
                                   (act1-result-outcome result)))))
      (act1-bridge-contract-violated (c)
        (setf fired t requirement (act1-condition-requirement-id c))))
    (let ((after (take-world-scope (getf *act1-worlds* :apply)
                                   (getf *act1-world-directories* :apply))))
      (report-kill
       ":refusal-swallowed-to-success — the guard refuses and the bridge ~
reports a clean commit anyway"
       "ACT1-DERIVE-CLASS (the journal-read class table; a :returned ~
disposition whose journal shows no settlement is :unclassifiable, and an ~
unclassifiable act is a HOST FAULT, never an Outcome)"
       (and fired (string= "ACT1-BRIDGE-1" requirement)
            (world-scope-unchanged-p before after))
       (format nil "the lane refused to hand back an Outcome at all ~
(requirement ~a; outcome view reached: ~s), and the world stayed ~
byte-unchanged — a swallowed refusal cannot buy a commit here because the ~
class is read from the journal's bytes and not from the bridge's report.  ~
Noted from the build: with a NIL ledger token this defect is killed one layer ~
EARLIER, by Core /0's own manifestation constructor (kernel /0 ~
UNRESOLVED-IDENTITY) — so the mutant forges a token precisely to reach the ~
lane's own predicate and put IT under test"
               requirement outcome-view)))))

;;; ---------------------------------------------------------------------------
;;; M3 — :reconciliation-without-evidence.

(defun mutant-3 ()
  ;; The GROUND seat's request was lost in flight: the frontier is crossed and
  ;; THE WORLD WAS NEVER TOUCHED.  Reconciliation against the surviving world
  ;; therefore resolves :NOT-APPLIED — a perfectly successful reconciliation,
  ;; resolving the uncertainty in the other direction.  A lane that reads
  ;; "reconciled, therefore proceed" would now act as if an effect had landed.
  (declare-uncertain-effect *act1-store* "a-prima" :process-name "mutants")
  (multiple-value-bind (resolution event receipt)
      (reconcile-uncertain-effect *act1-store* (getf *act1-worlds* :apply)
                                  "a-prima" :process-name "mutants")
    (declare (ignore event receipt))
    (let ((honest (act1-reconciliation-closes-seat-p
                   *act1-store* (getf *act1-worlds* :apply) "a-prima" resolution))
          (mutated (act1-reconciliation-closes-seat-p
                    *act1-store* (getf *act1-worlds* :apply) "a-prima" resolution
                    :defect :accept-any-resolution)))
      (report-kill
       ":reconciliation-without-evidence — the seat is called closed on any ~
resolution keyword, consulting neither the world nor the journal"
       "ACT1-RECONCILIATION-CLOSES-SEAT-P (:applied AND the world's ledger ~
entry under the journaled external-request identity AND attempt:reconciled in ~
the journal — all three, or the seat is not closed)"
       (and (eq :not-applied resolution) mutated (not honest))
       (format nil "resolution ~s · mutant verdict ~s · honest verdict ~s — the ~
world holds NO entry under this act's request key (~d), and the honest door ~
says so"
               resolution mutated honest
               (world-ledger-count (getf *act1-worlds* :apply)
                                   (external-request-key "a-prima")))))))

;;; ---------------------------------------------------------------------------
;;; Driver.

(format t "~&One Act /1 — planted defects.  CANDIDATE; nothing here is adopted.~%")
(format t "~&crash model: no process dies in this file.  The crossed-unsettled ~
seat is produced by capability /2's :request-lost seam, which leaves the same ~
DURABLE SHAPE a death leaves.~%~%")

(unless (act1-env-preflight :signal nil)
  (format t "~&oneact1-mutants: VOID — a process-ending switch is set.~%")
  (sb-ext:exit :code 4))

(let ((root (pathname (concatenate 'string
                                   (sb-posix:mkdtemp "/tmp/oneact1-mutants-XXXXXX")
                                   "/"))))
  (unless (null (search (namestring (truename *subject-root*)) (namestring root)))
    (format t "~&RUN ROOT IS INSIDE THE SUBJECT TREE — refusing to write.~%")
    (sb-ext:exit :code 3))
  (unwind-protect
       (progn (ground root)
              (terpri)
              (mutant-1)
              (mutant-2)
              (mutant-3))
    (when (probe-file root) (sb-ext:delete-directory root :recursive t))))

(format t "~&~%oneact1-mutants: ~d defects, ~d killed, ~d survivors~%"
        *defects* *killed* (- *defects* *killed*))
(finish-output)
(sb-ext:exit :code (if (= *defects* *killed*) 0 1))
