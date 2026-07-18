(in-package #:lisp-plus-kernel0)

(defstruct (uncertain-effect
            (:constructor %make-uncertain-effect
                (kind
                 attempt
                 external-request
                 possible-effects
                 known-facts
                 reconciliation-procedure
                 retry-policy))
            (:copier nil)
            (:conc-name %uncertain-effect-))
  (kind nil :read-only t)
  (attempt nil :read-only t)
  (external-request nil :read-only t)
  (possible-effects nil :read-only t)
  (known-facts nil :read-only t)
  (reconciliation-procedure nil :read-only t)
  (retry-policy nil :read-only t))

(defun uncertain-effect-kind (uncertain-effect)
  (%uncertain-effect-kind uncertain-effect))

(defun uncertain-effect-attempt (uncertain-effect)
  (%uncertain-effect-attempt uncertain-effect))

(defun uncertain-effect-external-request (uncertain-effect)
  (%snapshot-tree (%uncertain-effect-external-request uncertain-effect)))

(defun uncertain-effect-possible-effects (uncertain-effect)
  (%snapshot-tree (%uncertain-effect-possible-effects uncertain-effect)))

(defun uncertain-effect-known-facts (uncertain-effect)
  (%snapshot-tree (%uncertain-effect-known-facts uncertain-effect)))

(defun uncertain-effect-reconciliation-procedure (uncertain-effect)
  (%uncertain-effect-reconciliation-procedure uncertain-effect))

(defun uncertain-effect-retry-policy (uncertain-effect)
  (%uncertain-effect-retry-policy uncertain-effect))

(defun %unavailable-external-request-p (value)
  (and (%proper-list-p value)
       (= 3 (length value))
       (eq (first value) :unavailable)
       (eq (second value) :reason)
       (or (keywordp (third value))
           (stringp (third value)))))

(defun make-uncertain-effect (&rest arguments)
  "Construct the structured §10.8 primitive; no record-local resolved flag exists."
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:kind
             :attempt
             :external-request
             :possible-effects
             :known-facts
             :reconciliation-procedure
             :retry-policy)
           'unstructured-uncertainty
           "§10.8 [F: UNC-1, UNC-2]: an uncertain-effect record MUST carry exactly the structured uncertainty fields and MUST NOT invent record-local resolution")))
    (multiple-value-bind (kind kind-supplied-p)
        (%constructor-argument parsed :kind)
      (multiple-value-bind (attempt attempt-supplied-p)
          (%constructor-argument parsed :attempt)
        (declare (ignore attempt-supplied-p))
        (multiple-value-bind (external-request external-request-supplied-p)
            (%constructor-argument parsed :external-request)
          (multiple-value-bind (possible-effects possible-effects-supplied-p)
              (%constructor-argument parsed :possible-effects)
            (multiple-value-bind (known-facts known-facts-supplied-p)
                (%constructor-argument parsed :known-facts)
              (multiple-value-bind (reconciliation-procedure
                                    reconciliation-procedure-supplied-p)
                  (%constructor-argument parsed :reconciliation-procedure)
                (multiple-value-bind (retry-policy retry-policy-supplied-p)
                    (%constructor-argument
                     parsed
                     :retry-policy
                     :forbidden-without-reconciliation)
                  (declare (ignore retry-policy-supplied-p))
                  (unless (and kind-supplied-p (keywordp kind))
                    (signal-kernel0
                     'unstructured-uncertainty
                     :failed-invariant
                     "§10.8 [F: UNC-1]: uncertain-effect kind MUST be a bound keyword"))
                  (require-identity attempt :attempt)
                  (unless external-request-supplied-p
                    (signal-kernel0
                     'unresolved-identity
                     :attempt-id attempt
                     :failed-invariant
                     "§10.8 [F: UNC-1]: uncertain-effect MUST bind an external-request identity or the exact (:unavailable :reason ...) form"))
                  (cond ((durable-identity-p external-request)
                         (require-identity external-request :external-request))
                        ((not (%unavailable-external-request-p
                               external-request))
                         (signal-kernel0
                          'unresolved-identity
                          :attempt-id attempt
                          :failed-invariant
                          "§10.8 [F: UNC-1]: external-request MUST be an :external-request identity or (:unavailable :reason <keyword-or-string>)")))
                  (unless (and possible-effects-supplied-p
                               (%proper-list-p possible-effects)
                               possible-effects
                               (%duplicate-free-p possible-effects))
                    (signal-kernel0
                     'unstructured-uncertainty
                     :attempt-id attempt
                     :failed-invariant
                     "§10.8 [F: UNC-1]: possible-effects MUST be a named, finite, non-empty, duplicate-free alternatives list"))
                  (unless known-facts-supplied-p
                    (signal-kernel0
                     'unstructured-uncertainty
                     :attempt-id attempt
                     :failed-invariant
                     "§10.8 [F: UNC-1]: known-facts is a MUST-carry evidence-reference list, even when empty"))
                  (let ((known-facts-copy
                          (%reference-list
                           known-facts
                           "§10.8 [F: UNC-1]: known-facts MUST be a list of durable evidence references")))
                    (unless reconciliation-procedure-supplied-p
                      (signal-kernel0
                       'reconciliation-unsupported
                       :attempt-id attempt
                       :failed-invariant
                       "§10.8 [F: UNC-1]: uncertain-effect MUST bind an identified reconciliation procedure"))
                    ;; The field is a procedure reference.  :RECONCILIATION is
                    ;; also an identity domain, but §10.8 names a procedure;
                    ;; this implementation therefore requires :PROCEDURE.
                    (require-identity reconciliation-procedure :procedure)
                    (unless (keywordp retry-policy)
                      (signal-kernel0
                       'unsafe-retry
                       :attempt-id attempt
                       :failed-invariant
                       "§10.8 [F: UNC-1]: retry-policy MUST be a named policy; its default is :forbidden-without-reconciliation"))
                    (%make-uncertain-effect
                     kind
                     attempt
                     (%snapshot-tree external-request)
                     (%snapshot-tree possible-effects)
                     known-facts-copy
                     reconciliation-procedure
                     retry-policy)))))))))))
