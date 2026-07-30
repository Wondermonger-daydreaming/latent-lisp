;;;; mutants.lisp — planted defective derivations + the kill harness.
;;;;
;;;; journal0 §28 precedent (PJ-MUT-1/2): a gate that has never fired is
;;;; untested.  Each defect below is a live, selectable wrong implementation
;;;; of exactly the law it violates; RUN-MUTANT-KILL proves the strict path
;;;; DISAGREES with it over a store where the law bites.  A suite that
;;;; certifies both the strict derivation and the matching defective one is
;;;; decorative furniture.
;;;;
;;;;   :cached-status            — violates law 3: answers a later query
;;;;       from an earlier fold's cached ledger (the mutable status slot the
;;;;       design forbids).  Killed by a revocation committed after the
;;;;       cache warmed: strict refuses, mutant still authorizes.
;;;;   :ignore-revocation        — violates law 5/§11.6: folds grants but
;;;;       never revocations.  Killed the same way, without any cache.
;;;;   :receipt-unbound-to-prefix — violates law 4: issues receipts bound to
;;;;       the empty (genesis) prefix instead of the examined one.  Killed
;;;;       by the binding comparison: the strict receipt matches the fresh
;;;;       prefix-report exactly, the mutant's does not.
;;;;
;;;; — CLAVIGER (Claude Fable 5 subagent), 2026-07-29

(in-package #:lisp-plus-capability0)

(defvar +planted-defects+
  '(:cached-status
    :ignore-revocation
    :receipt-unbound-to-prefix))

(defun run-mutant-kill (defect store bootstrap
                        &key capability-id subject action resource scope
                             (query-id '("cap0-query" "mutant-kill"))
                             warm-cache-thunk)
  "Run the strict derivation and the DEFECT derivation over the same store
and question; return (values killed-p strict-summary mutant-summary).
KILLED-P is true exactly when the mutant DISAGREES with the strict result —
in decision, or in validated-prefix binding.

For :cached-status the caller supplies WARM-CACHE-THUNK, which is invoked
between (a) a first mutant query that warms the cache and (b) the store
change the cached answer will be wrong about; the final comparison then
asks both paths the SAME question over the CHANGED store."
  (setf *mutant-ledger-cache* nil)
  (let ((question (list :capability-id capability-id
                        :subject subject :action action
                        :resource resource :scope scope
                        :query-id query-id)))
    (when (eq defect :cached-status)
      ;; Warm the mutant's cache at the pre-change prefix...
      (apply #'query-live-authority store bootstrap :defect defect question)
      ;; ...then change the world underneath it.
      (when warm-cache-thunk (funcall warm-cache-thunk)))
    (let* ((strict (apply #'query-live-authority store bootstrap
                          :defect nil question))
           (mutant (apply #'query-live-authority store bootstrap
                          :defect defect question))
           (fresh-report (validate-journal store))
           (store-id (journal-store-store-id store))
           (strict-current (receipt-current-p strict fresh-report
                                              :store-id store-id))
           (mutant-current (receipt-current-p mutant fresh-report
                                              :store-id store-id))
           (killed (not (and (eq (receipt-decision strict)
                                 (receipt-decision mutant))
                             (eq strict-current mutant-current)))))
      (setf *mutant-ledger-cache* nil)
      (values killed
              (list :decision (receipt-decision strict)
                    :binding-current strict-current)
              (list :decision (receipt-decision mutant)
                    :binding-current mutant-current)))))
