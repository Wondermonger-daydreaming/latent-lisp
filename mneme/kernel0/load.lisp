(let* ((kernel0-directory
         (make-pathname :name nil :type nil :defaults *load-truename*))
       ;; This is the explicit dependency order.  Later Kernel /0 modules append
       ;; their source path after BOUNDARY.LISP according to dependency order.
       (ordered-sources
         '("../../canonical-datum/common-lisp/package.lisp"
           "../../canonical-datum/common-lisp/cd0.lisp"
           "package.lisp"
           "conditions.lisp"
           "identity.lisp"
           "boundary.lisp"
           "determinacy.lisp"
           "manifestation.lisp"
           "uncertain-effect.lisp"
           "outcome.lisp"
           "procedure.lisp"
           "records.lisp"
           "folds.lisp")))
  (dolist (source ordered-sources)
    (load (merge-pathnames source kernel0-directory))))

(let* ((identity (lisp-plus-kernel0:make-identity :attempt "smoke-attempt"))
       (identity-datum (lisp-plus-kernel0:identity->datum identity))
       (restored (lisp-plus-kernel0:datum->identity identity-datum))
       (string-datum (lisp-plus-kernel0:require-canonical "smoke"))
       (identity-drift-signaled-p nil)
       (noncanonical-signaled-p nil))
  (handler-case
      (lisp-plus-kernel0:require-identity identity :seat)
    (lisp-plus-kernel0:identity-drift ()
      (setf identity-drift-signaled-p t)))
  (handler-case
      (lisp-plus-kernel0:require-canonical 1.5d0)
    (lisp-plus-kernel0:noncanonical-durable-value ()
      (setf noncanonical-signaled-p t)))
  (unless (and (lisp-plus-kernel0:identity= identity restored)
               (lisp-plus-cd0:string-datum-p string-datum)
               identity-drift-signaled-p
               noncanonical-signaled-p)
    (format *error-output* "kernel0 foundations smoke: FAIL~%")
    (sb-ext:exit :code 1))
  (format t "kernel0 foundations smoke: PASS~%"))

(let* ((process-id
         (lisp-plus-kernel0:make-identity :process "smoke-process"))
       (logical-operation-id
         (lisp-plus-kernel0:make-identity
          :logical-operation
          "smoke-operation"))
       (seat-id (lisp-plus-kernel0:make-identity :seat "smoke-seat"))
       (attempt-id
         (lisp-plus-kernel0:make-identity :attempt "smoke-attempt"))
       (effect-group
         (lisp-plus-kernel0:make-identity :effect "smoke-effect-group"))
       (determinate
         (lisp-plus-kernel0:make-determinacy
          :mode :determinate
          :evidence nil))
       (execution
         (lisp-plus-kernel0:make-execution-axis
          :value :not-attempted
          :determinacy determinate))
       (manifestation
         (lisp-plus-kernel0:make-manifestation-axis
          :value '(:absent :state :never-attempted)
          :determinacy determinate))
       (effects
         (lisp-plus-kernel0:make-effect-axis
          :value :not-entered
          :determinacy determinate
          :effect-group effect-group))
       (interpretation
         (lisp-plus-kernel0:make-interpretation-axis
          :value :not-attempted
          :determinacy determinate))
       (outcome
         (lisp-plus-kernel0:make-outcome
          :process-id process-id
          :logical-operation-id logical-operation-id
          :seat-id seat-id
          :attempt-id attempt-id
          :execution execution
          :manifestation manifestation
          :effects effects
          :interpretation interpretation))
       (unstructured-signaled-p nil)
       (payload-missing-signaled-p nil)
       (global-scalar-signaled-p nil)
       (refused-post-frontier-signaled-p nil))
  (handler-case
      (lisp-plus-kernel0:make-effect-axis
       :value :bounded
       :determinacy
       (lisp-plus-kernel0:make-determinacy
        :mode :bounded
        :alternatives '(:billed :not-billed)
        :evidence nil)
       :evidence nil
       :effect-group effect-group)
    (lisp-plus-kernel0:unstructured-uncertainty ()
      (setf unstructured-signaled-p t)))
  ;; K0E-27 (Errata 0.2 §5): every manifestation binds exactly one producer
  ;; branch.  This smoke probes the payload-missing law, so it supplies a lawful
  ;; :producer-identity (a non-AP0 producer branch) and STILL omits the payload
  ;; identity — the payload-missing refusal is what it must reach.  Without a
  ;; producer branch the K0E-27 shape gate would fire first and escape the
  ;; handler; the branch preserves exactly what this smoke check proves.
  (handler-case
      (lisp-plus-kernel0:make-manifestation
       :manifestation-id
       (lisp-plus-kernel0:make-identity
        :manifestation
        "smoke-manifestation")
       :attempt-id attempt-id
       :kind :subject-answer
       :status :present
       :producer-identity
       (lisp-plus-kernel0:make-identity :principal "smoke-producer")
       :source-boundary :smoke-adapter-boundary)
    (lisp-plus-kernel0:manifestation-payload-missing ()
      (setf payload-missing-signaled-p t)))
  (handler-case
      (lisp-plus-kernel0:make-outcome
       :process-id process-id
       :logical-operation-id logical-operation-id
       :seat-id seat-id
       :attempt-id attempt-id
       :execution execution
       :manifestation manifestation
       :effects effects
       :interpretation interpretation
       :confidence :forbidden)
    (lisp-plus-kernel0:kernel0-condition ()
      (setf global-scalar-signaled-p t)))
  (handler-case
      (lisp-plus-kernel0:make-execution-axis
       :value :refused
       :determinacy determinate
       :frontier-qualifier :post-frontier)
    (lisp-plus-kernel0:kernel0-condition ()
      (setf refused-post-frontier-signaled-p t)))
  (unless (and (lisp-plus-kernel0:outcome-p outcome)
               (lisp-plus-kernel0:axis-p
                (lisp-plus-kernel0:outcome-axis outcome :execution))
               unstructured-signaled-p
               payload-missing-signaled-p
               global-scalar-signaled-p
               refused-post-frontier-signaled-p)
    (format *error-output* "kernel0 algebra smoke: FAIL~%")
    (sb-ext:exit :code 1))
  (format t "kernel0 algebra smoke: PASS~%"))

(let* ((process-id
         (lisp-plus-kernel0:make-identity :process "fold-smoke-process"))
       (logical-operation-id
         (lisp-plus-kernel0:make-identity
          :logical-operation
          "fold-smoke-operation"))
       (seat-id
         (lisp-plus-kernel0:make-identity :seat "fold-smoke-seat"))
       (attempt-id
         (lisp-plus-kernel0:make-identity :attempt "fold-smoke-attempt-a"))
       (retry-attempt-id
         (lisp-plus-kernel0:make-identity :attempt "fold-smoke-attempt-b"))
       (effect-id
         (lisp-plus-kernel0:make-identity :effect "fold-smoke-effect"))
       (procedure-id
         (lisp-plus-kernel0:make-identity
          :procedure
          "fold-smoke-reconciliation"))
       (evidence-id
         (lisp-plus-kernel0:make-identity
          :receipt
          "fold-smoke-new-evidence"))
       (attempt
         (lisp-plus-kernel0:make-attempt
          :attempt-id attempt-id
          :logical-operation-id logical-operation-id
          :seat-id seat-id
          :process-id process-id
          :predecessor-attempts nil
          :machine-configuration-id nil
          :supersession-records nil))
       (retry-attempt
         (lisp-plus-kernel0:make-attempt
          :attempt-id retry-attempt-id
          :logical-operation-id logical-operation-id
          :seat-id seat-id
          :process-id process-id
          :predecessor-attempts (list attempt-id)
          :machine-configuration-id nil
          :supersession-records nil))
       (uncertain-effect
         (lisp-plus-kernel0:make-uncertain-effect
          :kind :provider-call
          :attempt attempt-id
          :external-request '(:unavailable :reason :smoke)
          :possible-effects '(:billed :not-billed)
          :known-facts nil
          :reconciliation-procedure procedure-id))
       (bounded-determinacy
         (lisp-plus-kernel0:make-determinacy
          :mode :bounded
          :alternatives '(:billed :not-billed)
          :evidence nil))
       (determinate
         (lisp-plus-kernel0:make-determinacy
          :mode :determinate
          :evidence (list evidence-id)))
       (bounded-axis
         (lisp-plus-kernel0:make-effect-axis
          :value :bounded
          :determinacy bounded-determinacy
          :uncertain-effect-ref uncertain-effect
          :effect-group effect-id))
       (settled-axis
         (lisp-plus-kernel0:make-effect-axis
          :value :settled
          :determinacy determinate
          :evidence (list evidence-id)
          :effect-group effect-id))
       (receipt
         (lisp-plus-kernel0:make-reconciliation-receipt
          :target-attempt-id attempt-id
          :procedure-id procedure-id
          :procedure-version 0
          :new-evidence (list evidence-id)
          :previous-axis-values+determinacy (list :effects bounded-axis)
          :resulting-axis-values+determinacy (list :effects settled-axis)
          :unresolved-residue nil))
       (base-events
         (list
          (lisp-plus-kernel0:make-kernel0-event
           :event-type :seat-reserved
           :process-id process-id
           :logical-operation-id logical-operation-id
           :seat-id seat-id)
          (lisp-plus-kernel0:make-kernel0-event
           :event-type :attempt-begun
           :process-id process-id
           :logical-operation-id logical-operation-id
           :seat-id seat-id
           :attempt-id attempt-id
           :payload (list :attempt attempt))
          (lisp-plus-kernel0:make-kernel0-event
           :event-type :effect-prepared
           :process-id process-id
           :seat-id seat-id
           :attempt-id attempt-id
           :effect-id effect-id)
          (lisp-plus-kernel0:make-kernel0-event
           :event-type :frontier-crossed
           :process-id process-id
           :seat-id seat-id
           :attempt-id attempt-id
           :effect-id effect-id)
          (lisp-plus-kernel0:make-kernel0-event
           :event-type :effect-bounded
           :process-id process-id
           :seat-id seat-id
           :attempt-id attempt-id
           :effect-id effect-id
           :payload
           (list :uncertain-effect uncertain-effect
                 :axis-values+determinacy (list :effects bounded-axis)))
          (lisp-plus-kernel0:make-kernel0-event
           :event-type :attempt-failed
           :process-id process-id
           :seat-id seat-id
           :attempt-id attempt-id)))
       (retry-event
         (lisp-plus-kernel0:make-kernel0-event
          :event-type :attempt-begun
          :process-id process-id
          :logical-operation-id logical-operation-id
          :seat-id seat-id
          :attempt-id retry-attempt-id
          :payload (list :attempt retry-attempt)))
       (reconciliation-event
         (lisp-plus-kernel0:make-kernel0-event
          :event-type :attempt-reconciled
          :process-id process-id
          :seat-id seat-id
          :attempt-id attempt-id
          :payload (list :reconciliation-receipt receipt)))
       (occupancy
         (lisp-plus-kernel0:fold-seat-occupancy base-events seat-id))
       (unsafe-retry-signaled-p nil)
       (standing-inflation-signaled-p nil)
       (merge-receipt-required-signaled-p nil))
  (handler-case
      (lisp-plus-kernel0:check-retry-safety
       (append base-events (list retry-event))
       seat-id)
    (lisp-plus-kernel0:unsafe-retry ()
      (setf unsafe-retry-signaled-p t)))
  (let* ((reconciled-events
           (append base-events
                   (list reconciliation-event retry-event)))
         (standing
           (lisp-plus-kernel0:fold-attempt-outcome
            reconciled-events
            attempt-id))
         (original-effects
           (getf
            (lisp-plus-kernel0:attempt-outcome-standing-original-axis-values+determinacy
             standing)
            :effects))
         (current-effects
           (getf
            (lisp-plus-kernel0:attempt-outcome-standing-current-axis-values+determinacy
             standing)
            :effects))
         (claim
           (lisp-plus-kernel0:make-claim
            :claim-id
            (lisp-plus-kernel0:make-identity :claim "fold-smoke-claim")
            :content-datum "fold smoke claim"
            :source-ids nil
            :origin :reconstructed
            :validation-records nil
            :integrity-records nil
            :visibility-records nil
            :determinacy determinate
            :bounded-unknowns nil)))
    (lisp-plus-kernel0:check-retry-safety reconciled-events seat-id)
    (handler-case
        (lisp-plus-kernel0:promote-origin claim :observed)
      (lisp-plus-kernel0:standing-inflation ()
        (setf standing-inflation-signaled-p t)))
    (handler-case
        (lisp-plus-kernel0:merge-event-sequences base-events base-events)
      (lisp-plus-kernel0:journal-merge-receipt-required ()
        (setf merge-receipt-required-signaled-p t)))
    (unless (and (consp occupancy)
                 (eq (first occupancy) :unresolved)
                 (lisp-plus-kernel0:identity=
                  (second occupancy)
                  attempt-id)
                 (eq (third occupancy) uncertain-effect)
                 unsafe-retry-signaled-p
                 (not
                  (lisp-plus-kernel0:attempt-outcome-standing-unresolved-effect-p
                   standing))
                 (eq (lisp-plus-kernel0:axis-value original-effects) :bounded)
                 (eq (lisp-plus-kernel0:axis-value current-effects) :settled)
                 standing-inflation-signaled-p
                 merge-receipt-required-signaled-p)
      (format *error-output* "kernel0 records+folds smoke: FAIL~%")
      (sb-ext:exit :code 1)))
  (format t "kernel0 records+folds smoke: PASS~%"))
