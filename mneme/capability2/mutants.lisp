;;;; mutants.lisp — planted defective disciplines + the kill harness.
;;;;
;;;; journal0 §28 / capability0 / capability1 precedent: a gate that has
;;;; never fired is untested.  Each defect below is a live, selectable
;;;; wrong implementation of exactly the law it violates; RUN-MUTANT-KILL
;;;; proves the strict path DISAGREES with it over a scenario where the law
;;;; bites.
;;;;
;;;;   :ack-promotes-to-settled — violates law 3 / AP-ACK-4 ("an
;;;;       acknowledgment class has no settling force by itself"): the
;;;;       settlement branch treats ANY acknowledgment as settlement,
;;;;       skipping the evidence verification against the surviving world.
;;;;       Killed over the scripted :acknowledgment-ambiguous world: strict
;;;;       journals the §10.8 record (:uncertain), the mutant journals
;;;;       effect:settled from the class alone.
;;;;   :auto-retry-on-uncertain — violates §14.1 [UNC-1] (the crown law):
;;;;       the authorization gate swallows UNSAFE-RETRY and licenses the
;;;;       dispatch anyway.  Killed over a seat holding an unresolved
;;;;       uncertain effect: strict refuses; the mutant authorizes,
;;;;       dispatches, and the world's ledger then holds a SECOND applied
;;;;       entry — the double-apply counterfactual, exhibited in bytes.
;;;;   :stored-resolved-flag — violates PJ0 §16 / AP-CRASH-1 / law 9
;;;;       (resolvedness is fold-derived): the retry gate consults a
;;;;       mutable sidecar flag file and skips the fold when it says so.
;;;;       Killed by planting the flag WITHOUT any reconciliation event
;;;;       (the "timeout resolved it" world): strict still refuses from the
;;;;       bytes; the mutant waves the dispatch through.  The strict lane
;;;;       never writes such a flag anywhere (grep the lane for
;;;;       RESOLVED.flag: one reader in the guarded defect branch, one
;;;;       planter in this harness, no writer on any strict path).
;;;;
;;;; — CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-capability2)

(defvar +planted-defects+
  '(:ack-promotes-to-settled
    :auto-retry-on-uncertain
    :stored-resolved-flag))

;;; Declared kill-scenario configuration (deterministic; PJ-META-1
;;; deviation declared exactly as the suites declare theirs: fixed nonce,
;;; test fixture only).
(defvar +kill-nonce-string+ "cap2-mutant-kill")   ; exactly 16 octets
(defvar +kill-issuer+ '("cap2-issuer" "radix"))
(defvar +kill-minter+ '("cap2-minter" "claviger"))
(defvar +kill-capability+ '("cap" "clavis-effectus"))
(defvar +kill-subject+ '("subj" "custos"))
(defvar +kill-action+ '("act" "scribere"))
(defvar +kill-cell+ '("cella" "septima"))
(defvar +kill-scope+ '("scope" "exact"))

(defun %kill-scenario (root name &key (script :apply))
  "A fresh, self-contained scenario under ROOT/NAME/: store with the
declared grant committed, world with the declared cell, minted live key.
Returns (values store world bootstrap context key)."
  (let* ((base (merge-pathnames (format nil "~a/" name) root))
         (store-directory (merge-pathnames "store/" base))
         (world-directory (merge-pathnames "world/" base)))
    (dolist (directory (list store-directory world-directory))
      (when (probe-file directory)
        (sb-ext:delete-directory directory :recursive t)))
    (let* ((store (create-journal store-directory
                                  :declared-durability "synced"
                                  :nonce-octets
                                  (map '(simple-array (unsigned-byte 8) (*))
                                       #'char-code +kill-nonce-string+)))
           (world (make-world world-directory
                              (list (cons (identifier-segment-string
                                           (identifier-from-segments
                                            +kill-cell+))
                                          "VACUA"))
                              :script script))
           (bootstrap (declare-bootstrap-authority
                       +kill-issuer+ (journal-store-store-id store)))
           (context (make-minting-context :label (format nil "kill-~a"
                                                         name))))
      (append-event store (make-grant-event :event-id '("cap0-event" "g-001")
                                            :capability-id +kill-capability+
                                            :subject +kill-subject+
                                            :action +kill-action+
                                            :resource +kill-cell+
                                            :scope +kill-scope+
                                            :issuer +kill-issuer+))
      (let* ((fresh (query-live-authority store bootstrap
                                          :query-id (list "cap0-query"
                                                          (format nil "q-~a"
                                                                  name))
                                          :capability-id +kill-capability+
                                          :subject +kill-subject+
                                          :action +kill-action+
                                          :resource +kill-cell+
                                          :scope +kill-scope+))
             (key (mint-from-authorization store bootstrap context fresh
                                           :minter +kill-minter+)))
        (values store world bootstrap context key)))))

(defun %kill-authorize (store bootstrap context key attempt-name
                        &key defect)
  (authorize-effect-attempt store bootstrap context key
                            :capability-id +kill-capability+
                            :query-name (format nil "q-auth-~a" attempt-name)
                            :subject +kill-subject+
                            :action +kill-action+
                            :resource +kill-cell+
                            :scope +kill-scope+
                            :cell +kill-cell+
                            :value "VII"
                            :attempt-name attempt-name
                            :seat-name "sedes-1"
                            :defect defect))

(defun %kill-remint (store bootstrap context name)
  "Re-mint a FRESH key at the CURRENT validated prefix (the /1 doctrine:
a key minted against a prefix that has moved must be re-derived and
re-minted, never carried forward).  The kill scenarios use this after the
journal advances, so that the retry gate — not mere key staleness — is the
discipline under test: even a fully current key cannot license dispatch
into a seat with an unresolved predecessor."
  (mint-from-authorization
   store bootstrap context
   (query-live-authority store bootstrap
                         :query-id (list "cap0-query"
                                         (format nil "q-remint-~a" name))
                         :capability-id +kill-capability+
                         :subject +kill-subject+
                         :action +kill-action+
                         :resource +kill-cell+
                         :scope +kill-scope+)
   :minter +kill-minter+))

(defun %kill-uncertain-state (store world bootstrap context key attempt-name)
  "Drive the scenario into a seat holding an unresolved uncertain effect
(the scripted ambiguous acknowledgment), returning the attempt status."
  (let ((authorization (%kill-authorize store bootstrap context key
                                        attempt-name)))
    (attempt-protected-effect store bootstrap context key
                              authorization world
                              :process-name "kill-harness")))

(defun run-mutant-kill (defect scratch-root)
  "Exercise DEFECT against the strict discipline over a fresh scenario in
which its law bites; return (values killed-p strict-outcome mutant-outcome).
KILLED-P is true exactly when the mutant PERMITS what the strict path
REFUSES (or asserts what the strict path leaves uncertain) — the
disagreement that proves the discipline is load-bearing, not decorative."
  (ecase defect
    (:ack-promotes-to-settled
     ;; Strict and mutant each get an untouched ambiguous world.
     (multiple-value-bind (store world bootstrap context key)
         (%kill-scenario scratch-root "ack-strict" :script :ambiguous)
       (let ((strict (%kill-uncertain-state store world bootstrap context
                                            key "a-k1")))
         (multiple-value-bind (store-2 world-2 bootstrap-2 context-2 key-2)
             (%kill-scenario scratch-root "ack-mutant" :script :ambiguous)
           (let* ((authorization (%kill-authorize store-2 bootstrap-2
                                                  context-2 key-2 "a-k1"))
                  (mutant (attempt-protected-effect
                           store-2 bootstrap-2 context-2 key-2
                           authorization world-2
                           :process-name "kill-harness"
                           :defect :ack-promotes-to-settled)))
             (values (and (eq strict :uncertain) (eq mutant :settled))
                     strict mutant))))))
    (:auto-retry-on-uncertain
     (multiple-value-bind (store world bootstrap context key)
         (%kill-scenario scratch-root "retry" :script :ambiguous)
       (%kill-uncertain-state store world bootstrap context key "a-k1")
       ;; A FRESH key at the moved prefix: staleness is out of the way, so
       ;; the refusal below is the retry law's own, not the key's.
       (let* ((fresh-key (%kill-remint store bootstrap context "retry"))
              (strict (handler-case
                          (progn (%kill-authorize store bootstrap context
                                                  fresh-key "a-k2")
                                 :authorized)
                        (lisp-plus-kernel0:unsafe-retry () :unsafe-retry)))
              (mutant
                (let ((authorization
                        (%kill-authorize store bootstrap context fresh-key
                                         "a-k3"
                                         :defect :auto-retry-on-uncertain)))
                  (attempt-protected-effect store bootstrap context
                                            fresh-key
                                            authorization world
                                            :process-name "kill-harness"))))
         (values (and (eq strict :unsafe-retry)
                      (member mutant '(:settled :uncertain))
                      ;; The double-apply counterfactual, in bytes: the
                      ;; ledger now holds TWO applied entries.
                      (= 2 (world-ledger-count world)))
                 strict mutant))))
    (:stored-resolved-flag
     (multiple-value-bind (store world bootstrap context key)
         (%kill-scenario scratch-root "flag" :script :ambiguous)
       (%kill-uncertain-state store world bootstrap context key "a-k1")
       ;; Plant the flag a resolved-flag design would trust: no
       ;; reconciliation event exists; only this mutable byte claims
       ;; resolution.
       (with-open-file (stream (merge-pathnames
                                "RESOLVED.flag"
                                (lisp-plus-journal0:journal-store-directory
                                 store))
                               :direction :output
                               :if-exists :supersede
                               :if-does-not-exist :create)
         (write-string "resolved" stream))
       (let* ((fresh-key (%kill-remint store bootstrap context "flag"))
              (strict (handler-case
                          (progn (%kill-authorize store bootstrap context
                                                  fresh-key "a-k2")
                                 :authorized)
                        (lisp-plus-kernel0:unsafe-retry () :unsafe-retry)))
              (mutant (handler-case
                          (progn (%kill-authorize store bootstrap context
                                                  fresh-key "a-k3"
                                                  :defect
                                                  :stored-resolved-flag)
                                 :authorized)
                        (lisp-plus-kernel0:unsafe-retry ()
                          :unsafe-retry))))
         (values (and (eq strict :unsafe-retry) (eq mutant :authorized))
                 strict mutant))))))
