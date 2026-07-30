;;;; mutants.lisp — planted defective recognitions + the kill harness.
;;;;
;;;; journal0 §28 / capability0 precedent: a gate that has never fired is
;;;; untested.  Each defect below is a live, selectable wrong implementation
;;;; of exactly the law it violates; RUN-MUTANT-KILL proves the strict path
;;;; DISAGREES with it over a scenario where the law bites.
;;;;
;;;;   :context-as-liveness-cache — violates "the context recognizes; the
;;;;       journal decides": presentation answers from recognition alone,
;;;;       never re-validating the journal.  Killed by a journal advance
;;;;       after minting: strict refuses STALE, the mutant still presents.
;;;;       (The advance is the control; the same defect would equally wave
;;;;       through a committed revocation, which rides in an advance.)
;;;;   :serializable-authority   — violates §11.2: recognition by PUBLIC
;;;;       IDENTITY equality, i.e. recognition a serialized description can
;;;;       satisfy.  Killed by a mimic whose public identity was parsed
;;;;       back out of the genuine object's PRINTED form: strict refuses
;;;;       (unrecognized), the mutant presents — the printed form got up
;;;;       and unlocked the door.
;;;;   :public-constructor       — violates the no-public-constructor
;;;;       design: recognition by TYPE, i.e. the world in which building
;;;;       the struct grants recognition.  Killed by a hand-built
;;;;       counterfeit (internal constructor reached deliberately, the
;;;;       hostile path named): strict refuses, the mutant presents.
;;;;
;;;; The defects live in present.lisp's %recognizedp / prefix-check branch,
;;;; guarded by explicit keyword checks; the strict path (DEFECT = NIL)
;;;; never enters them.
;;;;
;;;; — CLAVIGER-II (Claude Fable 5 subagent), 2026-07-29

(in-package #:lisp-plus-capability1)

(defvar +planted-defects+
  '(:context-as-liveness-cache
    :serializable-authority
    :public-constructor))

(defun %attempt-presentation (store bootstrap context object
                              &key subject action resource scope
                                   presentation-id defect)
  "One presentation attempt, outcome as a keyword: :PRESENTED, or the
refusing condition's type name."
  (handler-case
      (progn (present-live-capability store bootstrap context object
                                      :subject subject :action action
                                      :resource resource :scope scope
                                      :presentation-id presentation-id
                                      :defect defect)
             :presented)
    (cap1-unrecognized-object () :cap1-unrecognized-object)
    (cap1-stale-capability () :cap1-stale-capability)
    (cap1-term-mismatch () :cap1-term-mismatch)
    (error (condition) (intern (symbol-name (type-of condition)) :keyword))))

(defun run-mutant-kill (defect store bootstrap context object
                        &key subject action resource scope
                             (presentation-id '("cap1-present"
                                                "mutant-kill")))
  "Present OBJECT strictly and under DEFECT, over the same store, context,
and terms; return (values killed-p strict-outcome mutant-outcome).
KILLED-P is true exactly when the mutant ACCEPTS (:presented) an object the
strict path REFUSES — the disagreement that proves the strict discipline is
load-bearing, not decorative.  The caller prepares the scenario in which the
law bites (an advanced journal for :context-as-liveness-cache; a mimic for
:serializable-authority; a counterfeit for :public-constructor)."
  (let ((strict (%attempt-presentation store bootstrap context object
                                       :subject subject :action action
                                       :resource resource :scope scope
                                       :presentation-id presentation-id
                                       :defect nil))
        (mutant (%attempt-presentation store bootstrap context object
                                       :subject subject :action action
                                       :resource resource :scope scope
                                       :presentation-id presentation-id
                                       :defect defect)))
    (values (and (eq mutant :presented)
                 (not (eq strict :presented)))
            strict
            mutant)))
