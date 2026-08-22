;;;; act1-host-fault-proof.lisp — One Act /1: A HOST FAULT MUST NOT WEAR A
;;;; CAPABILITY REFUSAL'S CLOTHES.
;;;;
;;;;   sbcl --script mneme/language-act-1/act1-host-fault-proof.lisp
;;;;
;;;; Sentinel: oneact1-host-fault-proof: <verdict>
;;;;
;;;; WHY THIS FILE EXISTS.  Sol's cold parcel review (2026-08-20, archived at
;;;; corpus/voices/received/2026-08-20-sol-cold-parcel-review-one-act-1-blocking-
;;;; finding.md) found that act1.lisp's D1/D2 `handler-case` caught `(error (c))`
;;;; — the WHOLE Common Lisp error hierarchy — while its prose claimed to handle
;;;; the runtime boundary's typed conditions.  An unexpected implementation
;;;; error raised before any attempt frame lands leaves
;;;; `derive-effect-standing` = :absent, so the handler converted it into an
;;;; ordinary pre-frontier refusal and `run-act1` classified a HOST FAULT as a
;;;; lawful :refused Outcome.
;;;;
;;;; THE PLANT IS IN THE SHIPPED DISPATCH, not here: act1.lisp's
;;;; `%act1-planted-implementation-fault` raises a real TYPE-ERROR inside the
;;;; protected form, before D1.  A plant living in this file would prove nothing
;;;; about that handler-case.
;;;;
;;;; THE VERDICT PREDICATE, stated once and applied to whatever the lane does:
;;;;   a planted implementation fault must NOT be reported as a refusal —
;;;;   not as disposition :refused, not as outcome-kind :refused, not as a
;;;;   class :refused* — and it must manufacture NO Outcome and NO evidence,
;;;;   while leaving the journal and the world byte-unchanged.
;;;;
;;;; Exit 0 iff the predicate holds.  BEFORE the repair it does not, and the
;;;; captured transcript of that failure is the RED proof.
;;;;
;;;; — PONTIFEX (Claude Opus 5, subagent), 2026-08-20

(require :sb-posix)

(load (merge-pathnames "load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-language-act1)

(defparameter *lane-directory*
  (make-pathname :name nil :type nil :defaults *load-truename*))
(defparameter *subject-root* (merge-pathnames "../../" *lane-directory*))

(defvar *observed* '())

(defun observe (key value)
  (push (cons key value) *observed*)
  (format t "  ~22a : ~s~%" key value)
  (finish-output))

(format t "~&One Act /1 — HOST-FAULT CLASSIFICATION PROOF.  CANDIDATE; nothing ~
here is adopted.~%~%")

(unless (act1-env-preflight :signal nil)
  (format t "~&oneact1-host-fault-proof: VOID — a process-ending switch is set.~%")
  (sb-ext:exit :code 4))
(terpri)

(let ((root (pathname (concatenate 'string
                                   (sb-posix:mkdtemp "/tmp/oneact1-hostfault-XXXXXX")
                                   "/")))
      (verdict nil))
  (unless (null (search (namestring (truename *subject-root*)) (namestring root)))
    (format t "~&RUN ROOT IS INSIDE THE SUBJECT TREE — refusing to write.~%")
    (sb-ext:exit :code 3))
  (unwind-protect
       (progn
         (setf *act1-run-root* root)
         (setf *act1-store* (build-act1-store root))
         (setf *act1-worlds* (build-act1-worlds root))
         (setf *act1-bootstrap*
               (declare-bootstrap-authority
                '("issuer" "oneact1") (journal-store-store-id *act1-store*)))
         (setf *act1-minting-context*
               (make-minting-context :label "oneact1-host-fault-proof"))
         (let ((row (make-act1-fixture-row
                     :arm "HOSTFAULT" :label "prima" :runtime-seat "prima"
                     :attempt-name "a-prima" :cell-segments '("cella" "prima")
                     :adapter-symbol 'host-fault-proof/bridge :world-key :apply
                     :form (act1-request-form "cella:prima" "Error non declaratus.")
                     :host-fault-plant :unexpected-error-before-frontier)))
           (setf *act1-fixture-table* (list row))
           (act1-opening-authority *act1-store* *act1-fixture-table*)
           (let* ((frames-before (nth-value 1 (act1-journal-kinds *act1-store*)))
                  (before (take-world-scope
                           (getf *act1-worlds* :apply)
                           (getf *act1-world-directories* :apply)
                           :request-key (external-request-key "a-prima")))
                  (escaped nil)
                  (escaped-type nil)
                  (result nil))
             (format t "~&PLANT: a real TYPE-ERROR is raised inside the D1/D2 ~
protected form of the SHIPPED dispatch, before D1 and before any attempt frame ~
can land.~%~%WHAT THE LANE DID WITH IT:~%")
             (handler-case (setf result (run-act1 row :verbose nil))
               (act1-condition (c)
                 (setf escaped t escaped-type (type-of c))
                 (observe :escaped-as escaped-type)
                 (observe :escaped-requirement (act1-condition-requirement-id c)))
               (error (c)
                 (setf escaped t escaped-type (type-of c))
                 (observe :escaped-as escaped-type)))
             (let ((after (take-world-scope
                           (getf *act1-worlds* :apply)
                           (getf *act1-world-directories* :apply)
                           :request-key (external-request-key "a-prima"))))
               (when result
                 (observe :disposition (act1-result-disposition result))
                 (observe :class (act1-result-class result))
                 (observe :standing (act1-result-standing result))
                 (observe :reason (act1-result-reason result))
                 (observe :outcome-kind
                          (and (act1-result-outcome result)
                               (lisp-plus-core0:outcome-kind
                                (act1-result-outcome result))))
                 (observe :evidence-issued
                          (and (act1-result-evidence result) t)))
               (observe :journal-frames-moved
                        (/= frames-before
                            (nth-value 1 (act1-journal-kinds *act1-store*))))
               (observe :world-byte-unchanged (world-scope-unchanged-p before after))
               (terpri)
               (print-world-scope-universe "HOST-FAULT ARM" before after)
               (terpri)
               ;; ---- THE PREDICATE ------------------------------------------
               (let* ((looked-like-a-refusal
                        (and result
                             (or (eq :refused (act1-result-disposition result))
                                 (eq :refused (act1-result-class result))
                                 (and (act1-result-outcome result)
                                      (eq :refused
                                          (lisp-plus-core0:outcome-kind
                                           (act1-result-outcome result)))))))
                      (manufactured (and result
                                         (or (act1-result-outcome result)
                                             (act1-result-evidence result))
                                         t))
                      (state-clean
                        (and (= frames-before
                                (nth-value 1 (act1-journal-kinds *act1-store*)))
                             (world-scope-unchanged-p before after))))
                 (observe :looked-like-a-refusal looked-like-a-refusal)
                 (observe :manufactured-outcome-or-evidence manufactured)
                 (observe :journal-and-world-clean state-clean)
                 (observe :distinguishable-as-host-fault
                          (or escaped
                              (and result
                                   (member (act1-result-class result)
                                           '(:host-fault :host-fault-pre-frontier)))))
                 (setf verdict (and (not looked-like-a-refusal)
                                    (not manufactured)
                                    state-clean
                                    (or escaped
                                        (and result
                                             (member (act1-result-class result)
                                                     '(:host-fault
                                                       :host-fault-pre-frontier))
                                             t)))))))))
    (when (probe-file root) (sb-ext:delete-directory root :recursive t)))

  (terpri)
  (if verdict
      (format t "~&oneact1-host-fault-proof: PASS — the planted implementation ~
fault is NOT wearing a refusal's clothes; no Outcome and no evidence were ~
manufactured; journal and world are byte-unchanged.~%")
      (format t "~&oneact1-host-fault-proof: FAIL — THE DEFECT IS PRESENT: a ~
planted implementation fault was reported as an ordinary pre-frontier refusal ~
(or an Outcome/evidence was manufactured for it).  This transcript IS the RED ~
proof.~%"))
  (finish-output)
  (sb-ext:exit :code (if verdict 0 1)))
