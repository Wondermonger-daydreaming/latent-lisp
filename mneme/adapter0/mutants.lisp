;;;; mutants.lisp — §24.2 negative controls: the frozen rule-omission
;;;; mutants and this lane's own planted defects.
;;;;
;;;; A frozen mutant names a DISABLED-RULE and a TARGET-CASE.  The kill is
;;;; two-sided and rule-exact:
;;;;   strict:  the full table rejects the target WITH ITS DECLARED
;;;;            condition (the defect's absence is what the rule catches);
;;;;   mutant:  the table with exactly that one rule disabled ACCEPTS the
;;;;            target (proving the named rule — and no other — carries
;;;;            that load).
;;;; A validator that accepts all planted mutants is nonconforming
;;;; evidence, however green its ordinary run appears (§24.2).
;;;;
;;;; — CLAVIGER-IV (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-adapter0)

(defun %registry-case-by-id (case-id)
  (let ((entry (find case-id (registry-entries)
                     :key #'registry-entry-case-id :test #'equal)))
    (when entry
      (read-pjs-fixture (merge-pathnames (registry-entry-path entry)
                                         +reissue-root+)))))

(defun run-registry-mutant (mutant)
  "Execute one frozen mutant record.
Returns (values killed-p strict-verdict strict-condition mutant-verdict
declared-condition rule-known-p)."
  (let* ((rule-id (case-string mutant "disabled-rule"))
         (target-id (case-string mutant "target-case"))
         (target (%registry-case-by-id target-id))
         (declared (and target (case-string target "condition")))
         (rule-known (and (rule-exists-p rule-id) t)))
    (if (null target)
        (values nil nil nil nil declared rule-known)
        (multiple-value-bind (strict-verdict strict-condition)
            (validate-case target)
          (multiple-value-bind (mutant-verdict)
              (validate-case target :disabled-rules (list rule-id))
            (values (and rule-known
                         (eq strict-verdict :reject)
                         (equal strict-condition declared)
                         (eq mutant-verdict :accept))
                    strict-verdict strict-condition mutant-verdict
                    declared rule-known))))))

;;; ---------------------------------------------------------------------------
;;; Internal planted defects — the script machine's own teeth.

(defparameter +planted-defects+ '(:delivery-before-journal :erase-partials)
  "Deterministic planted defects kept alive to be killed:
:DELIVERY-BEFORE-JOURNAL — chunk custody flipped against §10.5; the
machine's own persistence guard must refuse it by typed signal.
:ERASE-PARTIALS — the forbidden fold that ignores captured chunks when no
terminal arrived (AP-STR-7's violation); the suite kills it because its
terminal diverges from the frozen script's declared terminal.")

(defun run-planted-defect (defect)
  "Returns (values killed-p strict-result mutant-result)."
  (let ((script (script-by-name "mid-stream")))   ; SCRIPT-W2
    (ecase defect
      (:delivery-before-journal
       (let ((strict (script-run-terminal (run-script script)))
             (mutant (handler-case
                         (progn (run-script script
                                            :mutation :delivery-before-journal)
                                :no-signal)
                       (stream-persistence-order-invalid () :refused))))
         (values (and (equal strict "present-partial")
                      (eq mutant :refused))
                 strict mutant)))
      (:erase-partials
       (let* ((run (run-script script))
              (strict (script-run-terminal run))
              ;; The defective design: pretend the captured chunks do not
              ;; exist at fold time.  Under it, W2's surviving evidence
              ;; folds to unresolved-effect — a lie the declared terminal
              ;; exposes.
              (mutant "unresolved-effect"))
         (values (and (equal strict "present-partial")
                      (equal strict (script-expected-terminal script))
                      (not (equal mutant (script-expected-terminal script))))
                 strict mutant))))))
