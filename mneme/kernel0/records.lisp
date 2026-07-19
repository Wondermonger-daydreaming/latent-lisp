(in-package #:lisp-plus-kernel0)

;;; Immutable semantic records for Kernel /0.  These are data shapes, not
;;; journal records and not live authority objects.

(defun %require-record-fields
    (parsed keys condition-type failed-invariant)
  (dolist (key keys)
    (unless (assoc key parsed :test #'eq)
      (signal-kernel0 condition-type :failed-invariant failed-invariant))))

(defun %require-proper-record-list
    (value condition-type failed-invariant &key non-empty)
  (unless (and (%proper-list-p value)
               (or (not non-empty) value))
    (signal-kernel0 condition-type :failed-invariant failed-invariant))
  (%snapshot-tree value))

(defun %require-generic-identity (value failed-invariant)
  (%reference-identity value failed-invariant)
  value)

(defun %require-reference-record-list
    (value condition-type failed-invariant expected-domain &key non-empty)
  (%require-proper-record-list
   value condition-type failed-invariant :non-empty non-empty)
  (dolist (reference value)
    (if expected-domain
        (require-identity reference expected-domain)
        (%require-generic-identity reference failed-invariant)))
  (copy-list value))

;;; Seat occupancy is deliberately absent.  Under §6.2 [F: ATT-2], occupancy
;;; is derived from process evidence and MUST NOT be stored as a mutable flag.
(defstruct (seat
            (:constructor %make-seat
                (seat-id logical-operation-id occupancy-domain-id constraints))
            (:copier nil)
            (:conc-name %seat-))
  (seat-id nil :read-only t)
  (logical-operation-id nil :read-only t)
  (occupancy-domain-id nil :read-only t)
  (constraints nil :read-only t))

(defun seat-seat-id (seat)
  (%seat-seat-id seat))

(defun seat-logical-operation-id (seat)
  (%seat-logical-operation-id seat))

(defun seat-occupancy-domain-id (seat)
  (%seat-occupancy-domain-id seat))

(defun seat-constraints (seat)
  (%snapshot-tree (%seat-constraints seat)))

(defun make-seat (&rest arguments)
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:seat-id
             :logical-operation-id
             :occupancy-domain-id
             :constraints)
           'standing-inflation
           "§6.2 [F: ATT-2]: a seat constructor accepts only the stable seat shape and no occupancy flag")))
    (%require-record-fields
     parsed
     '(:seat-id :logical-operation-id :occupancy-domain-id)
     'unresolved-identity
     "§6.2: a seat MUST bind seat, logical-operation, and occupancy-domain identities")
    (let ((seat-id (%parsed-argument parsed :seat-id))
          (logical-operation-id
            (%parsed-argument parsed :logical-operation-id))
          (occupancy-domain-id
            (%parsed-argument parsed :occupancy-domain-id))
          (constraints (%parsed-argument parsed :constraints nil)))
      (require-identity seat-id :seat)
      (require-identity logical-operation-id :logical-operation)
      ;; The specification does not allocate a dedicated occupancy-domain
      ;; identity domain.  Preserve the caller's explicit durable domain.
      (%require-generic-identity
       occupancy-domain-id
       "§6.2: occupancy-domain-id MUST be a durable identity; Kernel /0 defines no narrower identity domain")
      (%make-seat seat-id
                  logical-operation-id
                  occupancy-domain-id
                  (%snapshot-tree constraints)))))

(defstruct (supersession
            (:constructor %make-supersession
                (receipt-id
                 seat-id
                 predecessor-attempt-id
                 superseding-attempt-id
                 authorized-by
                 reason
                 fresh-exposure-p
                 precedence-rule
                 cost-effect-treatment
                 residual-unknowns))
            (:copier nil)
            (:conc-name %supersession-))
  (receipt-id nil :read-only t)
  (seat-id nil :read-only t)
  (predecessor-attempt-id nil :read-only t)
  (superseding-attempt-id nil :read-only t)
  (authorized-by nil :read-only t)
  (reason nil :read-only t)
  (fresh-exposure-p nil :read-only t)
  (precedence-rule nil :read-only t)
  ;; Appendix A.7 is only a sketch; §14.3 normatively requires treatment of
  ;; both costs and effects, so the full record includes this field.
  (cost-effect-treatment nil :read-only t)
  (residual-unknowns nil :read-only t))

(defun supersession-receipt-id (record)
  (%supersession-receipt-id record))

(defun supersession-seat-id (record)
  (%supersession-seat-id record))

(defun supersession-predecessor-attempt-id (record)
  (%supersession-predecessor-attempt-id record))

(defun supersession-superseding-attempt-id (record)
  (%supersession-superseding-attempt-id record))

(defun supersession-authorized-by (record)
  (%supersession-authorized-by record))

(defun supersession-reason (record)
  (%snapshot-tree (%supersession-reason record)))

(defun supersession-fresh-exposure-p (record)
  (%supersession-fresh-exposure-p record))

(defun supersession-precedence-rule (record)
  (%snapshot-tree (%supersession-precedence-rule record)))

(defun supersession-cost-effect-treatment (record)
  (%snapshot-tree (%supersession-cost-effect-treatment record)))

(defun supersession-residual-unknowns (record)
  (%snapshot-tree (%supersession-residual-unknowns record)))

(defun make-supersession (&rest arguments)
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:receipt-id
             :seat-id
             :predecessor-attempt-id
             :superseding-attempt-id
             :authorized-by
             :reason
             :fresh-exposure-p
             :precedence-rule
             :cost-effect-treatment
             :residual-unknowns)
           'supersession-required
           "§14.3 [F: ATT-3] and Appendix A.7: supersession MUST use the complete semantic record shape")))
    (%require-record-fields
     parsed
     '(:receipt-id
       :seat-id
       :predecessor-attempt-id
       :superseding-attempt-id
       :authorized-by
       :reason
       :fresh-exposure-p
       :precedence-rule
       :cost-effect-treatment
       :residual-unknowns)
     'supersession-required
     "§14.3 [F: ATT-3]: supersession MUST name authorization, precedence, cost/effect treatment, and unresolved residue")
    (let ((receipt-id (%parsed-argument parsed :receipt-id))
          (seat-id (%parsed-argument parsed :seat-id))
          (predecessor (%parsed-argument parsed :predecessor-attempt-id))
          (superseding (%parsed-argument parsed :superseding-attempt-id))
          (authorized-by (%parsed-argument parsed :authorized-by))
          (reason (%parsed-argument parsed :reason))
          (fresh-exposure-p
            (%parsed-argument parsed :fresh-exposure-p))
          (precedence-rule (%parsed-argument parsed :precedence-rule))
          (cost-effect-treatment
            (%parsed-argument parsed :cost-effect-treatment))
          (residual-unknowns
            (%parsed-argument parsed :residual-unknowns)))
      (require-identity receipt-id :receipt)
      (require-identity seat-id :seat)
      (require-identity predecessor :attempt)
      (require-identity superseding :attempt)
      (when (identity= predecessor superseding)
        (signal-kernel0
         'duplicate-attempt-identity
         :attempt-id predecessor
         :seat-id seat-id
         :failed-invariant
         "§14.3 and §25.2 test 13: supersession requires a new attempt identity distinct from its predecessor"))
      (unless (and (durable-identity-p authorized-by)
                   (member (durable-identity-domain authorized-by)
                           '(:claim :capability)
                           :test #'eq))
        (signal-kernel0
         'supersession-unauthorized
         :attempt-id predecessor
         :seat-id seat-id
         :failed-invariant
         "§14.3 [F: ATT-3]: authorized-by MUST be a claim or capability identity"))
      (unless reason
        (signal-kernel0
         'supersession-required
         :attempt-id predecessor
         :seat-id seat-id
         :failed-invariant
         "§14.3 [F: ATT-3]: supersession MUST name a reason"))
      (unless (or (null fresh-exposure-p) (eq fresh-exposure-p t))
        (signal-kernel0
         'supersession-required
         :attempt-id predecessor
         :seat-id seat-id
         :failed-invariant
         "§14.3 [F: ATT-3]: fresh-exposure-p MUST be a boolean"))
      (unless (and precedence-rule cost-effect-treatment)
        (signal-kernel0
         'supersession-required
         :attempt-id predecessor
         :seat-id seat-id
         :failed-invariant
         "§14.3 [F: ATT-3]: precedence rule and treatment of costs and effects MUST both be bound"))
      (%require-proper-record-list
       residual-unknowns
       'supersession-required
       "§14.3 [F: ATT-3]: residual-unknowns MUST be a finite proper list")
      (%make-supersession
       receipt-id
       seat-id
       predecessor
       superseding
       authorized-by
       (%snapshot-tree reason)
       fresh-exposure-p
       (%snapshot-tree precedence-rule)
       (%snapshot-tree cost-effect-treatment)
       (%snapshot-tree residual-unknowns)))))

(defstruct (attempt
            (:constructor %make-attempt
                (attempt-id
                 logical-operation-id
                 seat-id
                 process-id
                 predecessor-attempts
                 exposure-id
                 machine-configuration-id
                 external-request-id
                 supersession-records))
            (:copier nil)
            (:conc-name %attempt-))
  (attempt-id nil :read-only t)
  (logical-operation-id nil :read-only t)
  (seat-id nil :read-only t)
  (process-id nil :read-only t)
  (predecessor-attempts nil :read-only t)
  ;; §6.5: NIL means that no exposure is recorded.  Fresh attempts do not
  ;; inherit an earlier exposure identity.
  (exposure-id nil :read-only t)
  ;; §6.3 lists this slot unconditionally.  Its key is required at
  ;; construction, but NIL is lawful because applicability is spec-dependent.
  (machine-configuration-id nil :read-only t)
  ;; §6.4 requires absence to be representable until the provider identity is
  ;; known, so this optional slot is explicitly nillable.
  (external-request-id nil :read-only t)
  (supersession-records nil :read-only t))

(defun attempt-attempt-id (attempt)
  (%attempt-attempt-id attempt))

(defun attempt-logical-operation-id (attempt)
  (%attempt-logical-operation-id attempt))

(defun attempt-seat-id (attempt)
  (%attempt-seat-id attempt))

(defun attempt-process-id (attempt)
  (%attempt-process-id attempt))

(defun attempt-predecessor-attempts (attempt)
  (copy-list (%attempt-predecessor-attempts attempt)))

(defun attempt-exposure-id (attempt)
  (%attempt-exposure-id attempt))

(defun attempt-machine-configuration-id (attempt)
  (%attempt-machine-configuration-id attempt))

(defun attempt-external-request-id (attempt)
  (%attempt-external-request-id attempt))

(defun attempt-supersession-records (attempt)
  (copy-list (%attempt-supersession-records attempt)))

(defun make-attempt (&rest arguments)
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:attempt-id
             :logical-operation-id
             :seat-id
             :process-id
             :predecessor-attempts
             :exposure-id
             :machine-configuration-id
             :external-request-id
             :supersession-records)
           'standing-inflation
           "§6.3: an attempt constructor MUST accept only the specified attempt record shape")))
    (%require-record-fields
     parsed
     '(:attempt-id
       :logical-operation-id
       :seat-id
       :process-id
       :predecessor-attempts
       :machine-configuration-id
       :supersession-records)
     'unresolved-identity
     "§6.3: an attempt MUST bind its core identities, predecessor list, machine-configuration slot, and supersession list")
    (let ((attempt-id (%parsed-argument parsed :attempt-id))
          (logical-operation-id
            (%parsed-argument parsed :logical-operation-id))
          (seat-id (%parsed-argument parsed :seat-id))
          (process-id (%parsed-argument parsed :process-id))
          (predecessors
            (%parsed-argument parsed :predecessor-attempts))
          (exposure-id (%parsed-argument parsed :exposure-id nil))
          (machine-configuration-id
            (%parsed-argument parsed :machine-configuration-id))
          (external-request-id
            (%parsed-argument parsed :external-request-id nil))
          (supersession-records
            (%parsed-argument parsed :supersession-records)))
      (require-identity attempt-id :attempt)
      (require-identity logical-operation-id :logical-operation)
      (require-identity seat-id :seat)
      (require-identity process-id :process)
      (%require-reference-record-list
       predecessors
       'standing-inflation
       "§6.3: predecessor-attempts MUST be a list of attempt identities"
       :attempt)
      (when exposure-id
        (require-identity exposure-id :exposure))
      (when machine-configuration-id
        (require-identity machine-configuration-id :machine-configuration))
      (when external-request-id
        (require-identity external-request-id :external-request))
      (%require-proper-record-list
       supersession-records
       'standing-inflation
       "§6.3: supersession-records MUST be a finite proper list")
      (unless (every #'supersession-p supersession-records)
        (signal-kernel0
         'standing-inflation
         :attempt-id attempt-id
         :seat-id seat-id
         :operation-id logical-operation-id
         :failed-invariant
         "§6.3 and §14.3: supersession-records MUST contain only immutable supersession records"))
      (%make-attempt attempt-id
                     logical-operation-id
                     seat-id
                     process-id
                     (copy-list predecessors)
                     exposure-id
                     machine-configuration-id
                     external-request-id
                     (copy-list supersession-records)))))

(defun %axis-values+determinacy-plist-p (value)
  (and (%proper-list-p value)
       value
       (evenp (length value))
       (loop with seen = nil
             for (key axis) on value by #'cddr
             always (and (member key
                                 '(:execution
                                   :manifestation
                                   :effects
                                   :interpretation)
                                 :test #'eq)
                         (not (member key seen :test #'eq))
                         (progn (push key seen) t)
                         (axis-p axis)
                         (eq (%axis-axis-name axis) key)))))

(defstruct (reconciliation-receipt
            (:constructor %make-reconciliation-receipt
                (target-attempt-id
                 procedure-id
                 procedure-version
                 new-evidence
                 previous-axis-values+determinacy
                 resulting-axis-values+determinacy
                 unresolved-residue))
            (:copier nil)
            (:conc-name %reconciliation-receipt-))
  (target-attempt-id nil :read-only t)
  (procedure-id nil :read-only t)
  (procedure-version nil :read-only t)
  (new-evidence nil :read-only t)
  (previous-axis-values+determinacy nil :read-only t)
  (resulting-axis-values+determinacy nil :read-only t)
  (unresolved-residue nil :read-only t))

(defun reconciliation-receipt-target-attempt-id (receipt)
  (%reconciliation-receipt-target-attempt-id receipt))

(defun reconciliation-receipt-procedure-id (receipt)
  (%reconciliation-receipt-procedure-id receipt))

(defun reconciliation-receipt-procedure-version (receipt)
  (%snapshot-tree (%reconciliation-receipt-procedure-version receipt)))

(defun reconciliation-receipt-new-evidence (receipt)
  (%snapshot-tree (%reconciliation-receipt-new-evidence receipt)))

(defun reconciliation-receipt-previous-axis-values+determinacy (receipt)
  (%snapshot-tree
   (%reconciliation-receipt-previous-axis-values+determinacy receipt)))

(defun reconciliation-receipt-resulting-axis-values+determinacy (receipt)
  (%snapshot-tree
   (%reconciliation-receipt-resulting-axis-values+determinacy receipt)))

(defun reconciliation-receipt-unresolved-residue (receipt)
  (%snapshot-tree (%reconciliation-receipt-unresolved-residue receipt)))

(defun make-reconciliation-receipt (&rest arguments)
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:target-attempt-id
             :procedure-id
             :procedure-version
             :new-evidence
             :previous-axis-values+determinacy
             :resulting-axis-values+determinacy
             :unresolved-residue)
           'reconciliation-insufficient
           "§14.2 [F: UNC-2]: a reconciliation receipt MUST use the complete append-only refinement shape")))
    (%require-record-fields
     parsed
     '(:target-attempt-id
       :procedure-id
       :procedure-version
       :new-evidence
       :previous-axis-values+determinacy
       :resulting-axis-values+determinacy
       :unresolved-residue)
     'reconciliation-insufficient
     "§14.2 [F: UNC-2]: every reconciliation receipt field MUST be explicitly bound")
    (let ((target-attempt-id
            (%parsed-argument parsed :target-attempt-id))
          (procedure-id (%parsed-argument parsed :procedure-id))
          (procedure-version
            (%parsed-argument parsed :procedure-version))
          (new-evidence (%parsed-argument parsed :new-evidence))
          (previous
            (%parsed-argument
             parsed :previous-axis-values+determinacy))
          (resulting
            (%parsed-argument
             parsed :resulting-axis-values+determinacy))
          (unresolved-residue
            (%parsed-argument parsed :unresolved-residue)))
      (require-identity target-attempt-id :attempt)
      (require-identity procedure-id :procedure)
      (unless procedure-version
        (signal-kernel0
         'reconciliation-insufficient
         :attempt-id target-attempt-id
         :failed-invariant
         "§14.2 [F: UNC-2]: reconciliation procedure version MUST be non-NIL"))
      (%require-proper-record-list
       new-evidence
       'reconciliation-insufficient
       "§14.2 [F: UNC-2]: reconciliation new-evidence MUST be a non-empty finite list"
       :non-empty t)
      (unless (and (%axis-values+determinacy-plist-p previous)
                   (%axis-values+determinacy-plist-p resulting))
        (signal-kernel0
         'reconciliation-insufficient
         :attempt-id target-attempt-id
         :failed-invariant
         "§14.2 [F: UNC-2]: previous and resulting values+determinacy MUST be non-empty plists of complete Kernel /0 axes"))
      (%require-proper-record-list
       unresolved-residue
       'reconciliation-insufficient
       "§14.2 [F: UNC-2]: unresolved-residue is the only nillable field and otherwise MUST be a finite proper list")
      (%make-reconciliation-receipt
       target-attempt-id
       procedure-id
       (%snapshot-tree procedure-version)
       (%snapshot-tree new-evidence)
       (%snapshot-tree previous)
       (%snapshot-tree resulting)
       (%snapshot-tree unresolved-residue)))))

(defstruct (role-assignment
            (:constructor %make-role-assignment
                (scope principal-id role source effective-interval))
            (:copier nil)
            (:conc-name %role-assignment-))
  (scope nil :read-only t)
  (principal-id nil :read-only t)
  (role nil :read-only t)
  (source nil :read-only t)
  (effective-interval nil :read-only t))

(defun role-assignment-scope (assignment)
  (%snapshot-tree (%role-assignment-scope assignment)))

(defun role-assignment-principal-id (assignment)
  (%role-assignment-principal-id assignment))

(defun role-assignment-role (assignment)
  (%role-assignment-role assignment))

(defun role-assignment-source (assignment)
  (%snapshot-tree (%role-assignment-source assignment)))

(defun role-assignment-effective-interval (assignment)
  (%snapshot-tree (%role-assignment-effective-interval assignment)))

(defun make-role-assignment (&rest arguments)
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:scope :principal-id :role :source :effective-interval)
           'standing-inflation
           "§5.3: role assignment MUST use scope, principal, open keyword role, source, and optional interval")))
    (%require-record-fields
     parsed
     '(:scope :principal-id :role :source)
     'standing-inflation
     "§5.3: role assignment MUST bind scope, principal identity, role, and source")
    (let ((scope (%parsed-argument parsed :scope))
          (principal-id (%parsed-argument parsed :principal-id))
          (role (%parsed-argument parsed :role))
          (source (%parsed-argument parsed :source))
          (effective-interval
            (%parsed-argument parsed :effective-interval nil)))
      (require-identity principal-id :principal)
      (unless (and scope source (keywordp role))
        (signal-kernel0
         'standing-inflation
         :failed-invariant
         "§5.2–§5.3: scope and source MUST be bound and role MUST be a keyword; libraries MAY add keyword roles"))
      (%make-role-assignment (%snapshot-tree scope)
                             principal-id
                             role
                             (%snapshot-tree source)
                             (%snapshot-tree effective-interval)))))

(defstruct (exposure-record
            (:constructor %make-exposure-record
                (protected-object-id
                 exposing-action
                 receiving-principals
                 scope
                 mode
                 evidence
                 induced-restrictions))
            (:copier nil)
            (:conc-name %exposure-record-))
  (protected-object-id nil :read-only t)
  (exposing-action nil :read-only t)
  (receiving-principals nil :read-only t)
  (scope nil :read-only t)
  (mode nil :read-only t)
  (evidence nil :read-only t)
  (induced-restrictions nil :read-only t))

(defun exposure-record-protected-object-id (record)
  (%exposure-record-protected-object-id record))

(defun exposure-record-exposing-action (record)
  (%snapshot-tree (%exposure-record-exposing-action record)))

(defun exposure-record-receiving-principals (record)
  (copy-list (%exposure-record-receiving-principals record)))

(defun exposure-record-scope (record)
  (%snapshot-tree (%exposure-record-scope record)))

(defun exposure-record-mode (record)
  (%exposure-record-mode record))

(defun exposure-record-evidence (record)
  (%snapshot-tree (%exposure-record-evidence record)))

(defun exposure-record-induced-restrictions (record)
  (%snapshot-tree (%exposure-record-induced-restrictions record)))

(defun make-exposure-record (&rest arguments)
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:protected-object-id
             :exposing-action
             :receiving-principals
             :scope
             :mode
             :evidence
             :induced-restrictions)
           'standing-inflation
           "§10.7 [F: PRN-2]: an exposure record MUST name the complete epistemic-effect shape")))
    (%require-record-fields
     parsed
     '(:receiving-principals)
     'exposed-principal-missing
     "§10.7 [F: PRN-2]: an exposure record MUST explicitly bind receiving-principals")
    (%require-record-fields
     parsed
     '(:protected-object-id
       :exposing-action
       :scope
       :mode
       :evidence
       :induced-restrictions)
     'standing-inflation
     "§10.7 [F: PRN-2]: an exposure record MUST name protected object, action, principals, scope, mode, evidence, and restrictions")
    (let ((protected-object-id
            (%parsed-argument parsed :protected-object-id))
          (exposing-action
            (%parsed-argument parsed :exposing-action))
          (receiving-principals
            (%parsed-argument parsed :receiving-principals))
          (scope (%parsed-argument parsed :scope))
          (mode (%parsed-argument parsed :mode))
          (evidence (%parsed-argument parsed :evidence))
          (induced-restrictions
            (%parsed-argument parsed :induced-restrictions)))
      (%require-generic-identity
       protected-object-id
       "§10.7 [F: PRN-2]: protected-object-id MUST be a durable identity")
      (unless (and (%proper-list-p receiving-principals)
                   receiving-principals)
        (signal-kernel0
         'exposed-principal-missing
         :failed-invariant
         "§10.7 [F: PRN-2] and §25.4 test 32: ‘someone now knows’ without at least one named receiving principal is nonconforming"))
      (dolist (principal receiving-principals)
        (require-identity principal :principal))
      (unless (and exposing-action
                   scope
                   (member mode '(:direct :relayed :inferred) :test #'eq))
        (signal-kernel0
         'standing-inflation
         :failed-invariant
         "§10.7 [F: PRN-2]: exposing action and scope MUST be bound and mode MUST be :direct, :relayed, or :inferred"))
      (%make-exposure-record
       protected-object-id
       (%snapshot-tree exposing-action)
       (copy-list receiving-principals)
       (%snapshot-tree scope)
       mode
       (%snapshot-tree evidence)
       (%snapshot-tree induced-restrictions)))))

;;; These two receipt shapes are historical pure data.  They do not mint,
;;; restore, validate, revoke, narrow, or otherwise grant live authority.
(defstruct (capability-mint-receipt
            (:constructor %make-capability-mint-receipt
                (receipt-id
                 capability-id
                 minted-by
                 authorizing-claim-id
                 derived-scope
                 delegates
                 revocation-registry
                 expiry))
            (:copier nil)
            (:conc-name %capability-mint-receipt-))
  (receipt-id nil :read-only t)
  (capability-id nil :read-only t)
  (minted-by nil :read-only t)
  (authorizing-claim-id nil :read-only t)
  (derived-scope nil :read-only t)
  (delegates nil :read-only t)
  (revocation-registry nil :read-only t)
  (expiry nil :read-only t))

(defun capability-mint-receipt-receipt-id (receipt)
  (%snapshot-tree (%capability-mint-receipt-receipt-id receipt)))

(defun capability-mint-receipt-capability-id (receipt)
  (%snapshot-tree (%capability-mint-receipt-capability-id receipt)))

(defun capability-mint-receipt-minted-by (receipt)
  (%snapshot-tree (%capability-mint-receipt-minted-by receipt)))

(defun capability-mint-receipt-authorizing-claim-id (receipt)
  (%snapshot-tree
   (%capability-mint-receipt-authorizing-claim-id receipt)))

(defun capability-mint-receipt-derived-scope (receipt)
  (%snapshot-tree (%capability-mint-receipt-derived-scope receipt)))

(defun capability-mint-receipt-delegates (receipt)
  (%snapshot-tree (%capability-mint-receipt-delegates receipt)))

(defun capability-mint-receipt-revocation-registry (receipt)
  (%snapshot-tree (%capability-mint-receipt-revocation-registry receipt)))

(defun capability-mint-receipt-expiry (receipt)
  (%snapshot-tree (%capability-mint-receipt-expiry receipt)))

(defun make-capability-mint-receipt (&rest arguments)
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:receipt-id
             :capability-id
             :minted-by
             :authorizing-claim-id
             :derived-scope
             :delegates
             :revocation-registry
             :expiry)
           'minting-authority-invalid
           "Appendix A.5: the capability minting receipt is a presence-validated pure-data shape")))
    (%require-record-fields
     parsed
     '(:receipt-id
       :capability-id
       :minted-by
       :authorizing-claim-id
       :derived-scope
       :delegates
       :revocation-registry
       :expiry)
     'minting-authority-invalid
     "Appendix A.5: every capability minting receipt field MUST be explicitly present")
    (%make-capability-mint-receipt
     (%snapshot-tree (%parsed-argument parsed :receipt-id))
     (%snapshot-tree (%parsed-argument parsed :capability-id))
     (%snapshot-tree (%parsed-argument parsed :minted-by))
     (%snapshot-tree (%parsed-argument parsed :authorizing-claim-id))
     (%snapshot-tree (%parsed-argument parsed :derived-scope))
     (%snapshot-tree (%parsed-argument parsed :delegates))
     (%snapshot-tree (%parsed-argument parsed :revocation-registry))
     (%snapshot-tree (%parsed-argument parsed :expiry)))))

(defstruct (capability-restoration-receipt
            (:constructor %make-capability-restoration-receipt
                (receipt-id
                 predecessor-capability-id
                 new-capability-id
                 restored-by
                 authority-basis
                 revocation-check
                 unresolved-effect-check
                 old-scope
                 new-scope))
            (:copier nil)
            (:conc-name %capability-restoration-receipt-))
  (receipt-id nil :read-only t)
  (predecessor-capability-id nil :read-only t)
  (new-capability-id nil :read-only t)
  (restored-by nil :read-only t)
  (authority-basis nil :read-only t)
  (revocation-check nil :read-only t)
  (unresolved-effect-check nil :read-only t)
  (old-scope nil :read-only t)
  (new-scope nil :read-only t))

(defun capability-restoration-receipt-receipt-id (receipt)
  (%snapshot-tree (%capability-restoration-receipt-receipt-id receipt)))

(defun capability-restoration-receipt-predecessor-capability-id (receipt)
  (%snapshot-tree
   (%capability-restoration-receipt-predecessor-capability-id receipt)))

(defun capability-restoration-receipt-new-capability-id (receipt)
  (%snapshot-tree
   (%capability-restoration-receipt-new-capability-id receipt)))

(defun capability-restoration-receipt-restored-by (receipt)
  (%snapshot-tree (%capability-restoration-receipt-restored-by receipt)))

(defun capability-restoration-receipt-authority-basis (receipt)
  (%snapshot-tree (%capability-restoration-receipt-authority-basis receipt)))

(defun capability-restoration-receipt-revocation-check (receipt)
  (%snapshot-tree (%capability-restoration-receipt-revocation-check receipt)))

(defun capability-restoration-receipt-unresolved-effect-check (receipt)
  (%snapshot-tree
   (%capability-restoration-receipt-unresolved-effect-check receipt)))

(defun capability-restoration-receipt-old-scope (receipt)
  (%snapshot-tree (%capability-restoration-receipt-old-scope receipt)))

(defun capability-restoration-receipt-new-scope (receipt)
  (%snapshot-tree (%capability-restoration-receipt-new-scope receipt)))

(defun make-capability-restoration-receipt (&rest arguments)
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:receipt-id
             :predecessor-capability-id
             :new-capability-id
             :restored-by
             :authority-basis
             :revocation-check
             :unresolved-effect-check
             :old-scope
             :new-scope)
           'capability-restoration-denied
           "Appendix A.6: the restoration receipt is a presence-validated pure-data shape")))
    (%require-record-fields
     parsed
     '(:receipt-id
       :predecessor-capability-id
       :new-capability-id
       :restored-by
       :authority-basis
       :revocation-check
       :unresolved-effect-check
       :old-scope
       :new-scope)
     'capability-restoration-denied
     "Appendix A.6: every capability restoration receipt field MUST be explicitly present")
    (let ((predecessor
            (%parsed-argument parsed :predecessor-capability-id))
          (new (%parsed-argument parsed :new-capability-id)))
      (when (%kernel-name= predecessor new)
        (signal-kernel0
         'capability-restoration-denied
         :failed-invariant
         "§11.7 rule 1: restoration MUST create a new capability identity distinct from its predecessor"))
      (%make-capability-restoration-receipt
       (%snapshot-tree (%parsed-argument parsed :receipt-id))
       (%snapshot-tree predecessor)
       (%snapshot-tree new)
       (%snapshot-tree (%parsed-argument parsed :restored-by))
       (%snapshot-tree (%parsed-argument parsed :authority-basis))
       (%snapshot-tree (%parsed-argument parsed :revocation-check))
       (%snapshot-tree (%parsed-argument parsed :unresolved-effect-check))
       (%snapshot-tree (%parsed-argument parsed :old-scope))
       (%snapshot-tree (%parsed-argument parsed :new-scope))))))

;;; ---------------------------------------------------------------------------
;;; Claim-standing records (Errata 0.2 §3, K0E-18..22).
;;;
;;; These are immutable pure-data shapes.  A sealed integrity record, a verified
;;; validation record, and a published visibility record establish ONLY their
;;; own named relation; none constructs, upgrades, or stands in for another
;;; (K0E-21 orthogonality).  Standing never rides an opaque list — every claim
;;; standing entry is one of these constructed records or the claim refuses it.

(defun %require-standing-fields
    (field-plist condition-type requirement-id failed-invariant)
  "Signal CONDITION-TYPE naming the first standing field whose value is NIL.
FIELD-PLIST is a list of (FIELD-KEYWORD . VALUE) pairs.  A field counts as
bound only when non-NIL, so an empty list or NIL fails a strong-standing
requirement."
  (loop for (field . value) in field-plist
        when (null value)
          do (signal-kernel0 condition-type
                             :requirement-id requirement-id
                             :offending-field field
                             :failed-invariant failed-invariant)))

(defun %require-typed-record-list
    (value predicate requirement-id failed-invariant)
  "Require VALUE to be a finite proper list whose every element satisfies
PREDICATE (a constructed record of the correct type).  An opaque or wrong-type
entry is a schema failure, not a standing refusal → MALFORMED-CONSTRUCTOR-SHAPE."
  (unless (%proper-list-p value)
    (signal-kernel0 'malformed-constructor-shape
                    :requirement-id requirement-id
                    :offending-value value
                    :failed-invariant failed-invariant))
  (dolist (entry value)
    (unless (funcall predicate entry)
      (signal-kernel0 'malformed-constructor-shape
                      :requirement-id requirement-id
                      :offending-value entry
                      :failed-invariant failed-invariant)))
  value)

(defun %require-record-subject
    (record-subject-id claim-id requirement-id failed-invariant)
  "Refuse a standing record whose :SUBJECT-ID is not THIS claim's identity.
A correctly typed validation / integrity / visibility record about ANOTHER
claim is standing laundered through a valid passport (hostile review §3): the
single named equality is IDENTITY= (§4.1), and a foreign or non-identity
subject is a STANDING-INFLATION keyed to the record kind's requirement id
\(K0E-18 validation, K0E-19 integrity, K0E-20 visibility)."
  (unless (identity= record-subject-id claim-id)
    (signal-kernel0 'standing-inflation
                    :requirement-id requirement-id
                    :offending-field :subject-id
                    :offending-value record-subject-id
                    :evidence-ids (list claim-id)
                    :failed-invariant failed-invariant)))

(defun %require-record-representation
    (record-representation-id canonical-content claim-id requirement-id
     failed-invariant)
  "Refuse a standing record whose canonical :REPRESENTATION-ID is not THIS
claim's canonical content datum.  The comparison is the SINGLE CD/0 value
equality LISP-PLUS-CD0:EQUAL-DATUM — the exact mechanism the K0E-21 integrity
path uses — so a record sealing (K0E-19/21) or publishing (K0E-20) another
representation of the same claim identity confers no standing here (hostile
review §5 redaction collapse).  Both arguments are already canonical: the
record's representation was canonicalized at construction (REQUIRE-CANONICAL)
and CANONICAL-CONTENT is the claim's canonical content datum.  A mismatch is a
STANDING-INFLATION keyed to the caller's requirement id (K0E-21 for integrity,
K0E-20 for visibility), naming :REPRESENTATION-ID and the foreign
representation."
  (unless (lisp-plus-cd0:equal-datum record-representation-id canonical-content)
    (signal-kernel0 'standing-inflation
                    :requirement-id requirement-id
                    :offending-field :representation-id
                    :offending-value record-representation-id
                    :evidence-ids (list claim-id)
                    :failed-invariant failed-invariant)))

;;; §3.1 [K0E-18] Validation record.
(defstruct (validation-record
            (:constructor %make-validation-record
                (status
                 subject-id
                 validator-principal-id
                 procedure-id
                 procedure-version
                 scope
                 evidence
                 bounded-unknowns))
            (:copier nil)
            (:conc-name %validation-record-))
  (status nil :read-only t)
  (subject-id nil :read-only t)
  (validator-principal-id nil :read-only t)
  (procedure-id nil :read-only t)
  (procedure-version nil :read-only t)
  (scope nil :read-only t)
  (evidence nil :read-only t)
  (bounded-unknowns nil :read-only t))

(defun validation-record-status (record)
  (%validation-record-status record))

(defun validation-record-subject-id (record)
  (%validation-record-subject-id record))

(defun validation-record-validator-principal-id (record)
  (%validation-record-validator-principal-id record))

(defun validation-record-procedure-id (record)
  (%validation-record-procedure-id record))

(defun validation-record-procedure-version (record)
  (%snapshot-tree (%validation-record-procedure-version record)))

(defun validation-record-scope (record)
  (%snapshot-tree (%validation-record-scope record)))

(defun validation-record-evidence (record)
  (%snapshot-tree (%validation-record-evidence record)))

(defun validation-record-bounded-unknowns (record)
  (%snapshot-tree (%validation-record-bounded-unknowns record)))

(defun make-validation-record (&rest arguments)
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:status
             :subject-id
             :validator-principal-id
             :procedure-id
             :procedure-version
             :scope
             :evidence
             :bounded-unknowns)
           'malformed-constructor-shape
           "§3.1 [K0E-18]: a validation record accepts only the specified validation-standing shape")))
    (let ((status (%parsed-argument parsed :status nil))
          (subject-id (%parsed-argument parsed :subject-id nil))
          (validator-principal-id
            (%parsed-argument parsed :validator-principal-id nil))
          (procedure-id (%parsed-argument parsed :procedure-id nil))
          (procedure-version
            (%parsed-argument parsed :procedure-version nil))
          (scope (%parsed-argument parsed :scope nil))
          (evidence (%parsed-argument parsed :evidence nil))
          (bounded-unknowns
            (%parsed-argument parsed :bounded-unknowns nil)))
      (unless (member status
                      '(:unchecked :checked :verified :refuted)
                      :test #'eq)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-18"
         :offending-field :status
         :offending-value status
         :failed-invariant
         "§3.1 [K0E-18]: validation status MUST be :unchecked, :checked, :verified, or :refuted"))
      ;; Type-check the identity-bearing fields that are present.  Their domain
      ;; drift is an identity fault (§4.2), distinct from a bare-standing fault.
      (when subject-id
        (%require-generic-identity
         subject-id
         "§3.1 [K0E-18]: validation subject-id MUST be a durable identity"))
      (when validator-principal-id
        (require-identity validator-principal-id :principal))
      (when procedure-id
        (require-identity procedure-id :procedure))
      (%require-proper-record-list
       evidence 'malformed-constructor-shape
       "§3.1 [K0E-18]: validation evidence MUST be a finite proper list")
      (%require-proper-record-list
       bounded-unknowns 'malformed-constructor-shape
       "§3.1 [K0E-18]: validation bounded-unknowns MUST be a finite proper list")
      ;; Standing requirements, keyed by status (K0E-18).
      (ecase status
        ((:verified :refuted)
         (%require-standing-fields
          (list (cons :subject-id subject-id)
                (cons :validator-principal-id validator-principal-id)
                (cons :procedure-id procedure-id)
                (cons :procedure-version procedure-version)
                (cons :scope scope))
          'bare-validation-scope "K0E-18"
          "§3.1 [K0E-18]: a :verified or :refuted validation record MUST bind subject, validator, procedure, version, and scope")
         (unless evidence
           (signal-kernel0
            'bare-validation-scope
            :requirement-id "K0E-18"
            :offending-field :evidence
            :failed-invariant
            "§3.1 [K0E-18]: :verified and :refuted require non-empty evidence")))
        (:checked
         ;; K0E-18: an empty evidence list is lawful ONLY when the named
         ;; procedure defines an inspectable negative check over preserved
         ;; inputs.  That proviso is procedure-relative and NOT structurally
         ;; checkable here, so empty evidence is accepted for :checked and the
         ;; obligation is documented (judgment call flagged in the notes).  No
         ;; new field is invented for it.
         (%require-standing-fields
          (list (cons :subject-id subject-id)
                (cons :validator-principal-id validator-principal-id)
                (cons :procedure-id procedure-id)
                (cons :procedure-version procedure-version)
                (cons :scope scope))
          'bare-validation-scope "K0E-18"
          "§3.1 [K0E-18]: a :checked validation record MUST bind subject, validator, procedure, version, and scope"))
        (:unchecked
         (%require-standing-fields
          (list (cons :subject-id subject-id)
                (cons :scope scope))
          'bare-validation-scope "K0E-18"
          "§3.1 [K0E-18]: an :unchecked validation record MUST still name subject and scope")))
      (%make-validation-record
       status
       subject-id
       validator-principal-id
       procedure-id
       (%snapshot-tree procedure-version)
       (%snapshot-tree scope)
       (%snapshot-tree evidence)
       (%snapshot-tree bounded-unknowns)))))

;;; §3.2 [K0E-19] Integrity record.
(defstruct (integrity-record
            (:constructor %make-integrity-record
                (status
                 subject-id
                 representation-id
                 method-id
                 method-version
                 sealing-principal-id
                 evidence
                 bounded-unknowns))
            (:copier nil)
            (:conc-name %integrity-record-))
  (status nil :read-only t)
  (subject-id nil :read-only t)
  ;; The EXACT representation sealed, canonicalized at a durable boundary so the
  ;; copies-cannot-inherit-seals guard (K0E-21) can compare it by CD/0 value.
  (representation-id nil :read-only t)
  (method-id nil :read-only t)
  (method-version nil :read-only t)
  (sealing-principal-id nil :read-only t)
  (evidence nil :read-only t)
  (bounded-unknowns nil :read-only t))

(defun integrity-record-status (record)
  (%integrity-record-status record))

(defun integrity-record-subject-id (record)
  (%integrity-record-subject-id record))

(defun integrity-record-representation-id (record)
  (%integrity-record-representation-id record))

(defun integrity-record-method-id (record)
  (%integrity-record-method-id record))

(defun integrity-record-method-version (record)
  (%snapshot-tree (%integrity-record-method-version record)))

(defun integrity-record-sealing-principal-id (record)
  (%integrity-record-sealing-principal-id record))

(defun integrity-record-evidence (record)
  (%snapshot-tree (%integrity-record-evidence record)))

(defun integrity-record-bounded-unknowns (record)
  (%snapshot-tree (%integrity-record-bounded-unknowns record)))

(defun make-integrity-record (&rest arguments)
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:status
             :subject-id
             :representation-id
             :method-id
             :method-version
             :sealing-principal-id
             :evidence
             :bounded-unknowns)
           'malformed-constructor-shape
           "§3.2 [K0E-19]: an integrity record accepts only the specified integrity shape")))
    (let ((status (%parsed-argument parsed :status nil))
          (subject-id (%parsed-argument parsed :subject-id nil))
          (representation-id
            (%parsed-argument parsed :representation-id nil))
          (method-id (%parsed-argument parsed :method-id nil))
          (method-version (%parsed-argument parsed :method-version nil))
          (sealing-principal-id
            (%parsed-argument parsed :sealing-principal-id nil))
          (evidence (%parsed-argument parsed :evidence nil))
          (bounded-unknowns
            (%parsed-argument parsed :bounded-unknowns nil)))
      (unless (member status '(:open :sealed) :test #'eq)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-19"
         :offending-field :status
         :offending-value status
         :failed-invariant
         "§3.2 [K0E-19]: integrity status MUST be :open or :sealed"))
      ;; A structurally incomplete integrity record is a schema failure, NOT a
      ;; standing refusal: integrity is not validation, so neither
      ;; BARE-VALIDATION-SCOPE nor STANDING-INFLATION applies.  Missing or
      ;; wrong-shaped structure → MALFORMED-CONSTRUCTOR-SHAPE (judgment call
      ;; flagged in the notes; decided by the law in §6/K0E-33's schema family).
      (%require-standing-fields
       (list (cons :subject-id subject-id)
             (cons :representation-id representation-id))
       'malformed-constructor-shape "K0E-19"
       "§3.2 [K0E-19]: an integrity record MUST bind its subject and the exact representation")
      (%require-generic-identity
       subject-id
       "§3.2 [K0E-19]: integrity subject-id MUST be a durable identity")
      (when method-id
        (%require-generic-identity
         method-id
         "§3.2 [K0E-19]: integrity method-id MUST be a durable identity"))
      (when sealing-principal-id
        (require-identity sealing-principal-id :principal))
      (%require-proper-record-list
       evidence 'malformed-constructor-shape
       "§3.2 [K0E-19]: integrity evidence MUST be a finite proper list")
      (%require-proper-record-list
       bounded-unknowns 'malformed-constructor-shape
       "§3.2 [K0E-19]: integrity bounded-unknowns MUST be a finite proper list")
      (when (eq status :sealed)
        (%require-standing-fields
         (list (cons :subject-id subject-id)
               (cons :representation-id representation-id)
               (cons :method-id method-id)
               (cons :method-version method-version)
               (cons :sealing-principal-id sealing-principal-id))
         'malformed-constructor-shape "K0E-19"
         "§3.2 [K0E-19]: a :sealed integrity record MUST bind subject, representation, method, version, and sealing principal")
        (unless evidence
          (signal-kernel0
           'malformed-constructor-shape
           :requirement-id "K0E-19"
           :offending-field :evidence
           :failed-invariant
           "§3.2 [K0E-19]: a :sealed integrity record MUST carry non-empty evidence")))
      (%make-integrity-record
       status
       subject-id
       (require-canonical representation-id)
       method-id
       (%snapshot-tree method-version)
       sealing-principal-id
       (%snapshot-tree evidence)
       (%snapshot-tree bounded-unknowns)))))

;;; §3.3 [K0E-20] Visibility record.
(defstruct (visibility-record
            (:constructor %make-visibility-record
                (status
                 subject-id
                 representation-id
                 scope-id
                 authorizing-basis
                 redaction-receipt-id
                 evidence
                 bounded-unknowns))
            (:copier nil)
            (:conc-name %visibility-record-))
  (status nil :read-only t)
  (subject-id nil :read-only t)
  (representation-id nil :read-only t)
  (scope-id nil :read-only t)
  ;; A REFERENCE THAT GRANTS NOTHING: it names the capability fingerprint or
  ;; claim identity under which the visibility act was authorized, and confers
  ;; no authority itself.  It is never treated as authority.
  (authorizing-basis nil :read-only t)
  (redaction-receipt-id nil :read-only t)
  (evidence nil :read-only t)
  (bounded-unknowns nil :read-only t))

(defun visibility-record-status (record)
  (%visibility-record-status record))

(defun visibility-record-subject-id (record)
  (%visibility-record-subject-id record))

(defun visibility-record-representation-id (record)
  (%visibility-record-representation-id record))

(defun visibility-record-scope-id (record)
  (%snapshot-tree (%visibility-record-scope-id record)))

(defun visibility-record-authorizing-basis (record)
  "Return the authorizing basis: a REFERENCE THAT GRANTS NOTHING.  It names the
basis under which the visibility act was authorized and confers no authority."
  (%snapshot-tree (%visibility-record-authorizing-basis record)))

(defun visibility-record-redaction-receipt-id (record)
  (%visibility-record-redaction-receipt-id record))

(defun visibility-record-evidence (record)
  (%snapshot-tree (%visibility-record-evidence record)))

(defun visibility-record-bounded-unknowns (record)
  (%snapshot-tree (%visibility-record-bounded-unknowns record)))

(defun make-visibility-record (&rest arguments)
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:status
             :subject-id
             :representation-id
             :scope-id
             :authorizing-basis
             :redaction-receipt-id
             :evidence
             :bounded-unknowns)
           'malformed-constructor-shape
           "§3.3 [K0E-20]: a visibility record accepts only the specified visibility shape")))
    (let ((status (%parsed-argument parsed :status nil))
          (subject-id (%parsed-argument parsed :subject-id nil))
          (representation-id
            (%parsed-argument parsed :representation-id nil))
          (scope-id (%parsed-argument parsed :scope-id nil))
          (authorizing-basis
            (%parsed-argument parsed :authorizing-basis nil))
          (redaction-receipt-id
            (%parsed-argument parsed :redaction-receipt-id nil))
          (evidence (%parsed-argument parsed :evidence nil))
          (bounded-unknowns
            (%parsed-argument parsed :bounded-unknowns nil)))
      (unless (member status
                      '(:published :withheld :redacted)
                      :test #'eq)
        (signal-kernel0
         'malformed-constructor-shape
         :requirement-id "K0E-20"
         :offending-field :status
         :offending-value status
         :failed-invariant
         "§3.3 [K0E-20]: visibility status MUST be :published, :withheld, or :redacted"))
      ;; Structural core: a visibility record is about a subject's representation.
      (%require-standing-fields
       (list (cons :subject-id subject-id)
             (cons :representation-id representation-id))
       'malformed-constructor-shape "K0E-20"
       "§3.3 [K0E-20]: a visibility record MUST bind its subject and representation")
      (%require-generic-identity
       subject-id
       "§3.3 [K0E-20]: visibility subject-id MUST be a durable identity")
      ;; N1/R1 (K0E-20 — hostile review §9 and §6): :authorizing-basis is a
      ;; REFERENCE THAT GRANTS NOTHING, but it is still a reference, and the
      ;; schema names it as a claim identity or a capability fingerprint identity
      ;; specifically.  When present it MUST therefore be a durable identity AND
      ;; inhabit the :CLAIM or :CAPABILITY domain; any other identity domain
      ;; (:store, :effect, :process, :attempt, :manifestation, :parser, …), an
      ;; arbitrary string, or a plist is a schema fault.  The domain restriction
      ;; is the R1 repair: DURABLE-IDENTITY-P alone accepted every Kernel identity
      ;; domain, a schema divergence.  Nothing here resolves the basis or grants
      ;; any authority from it — the field remains inert (the accessor still
      ;; states "grants nothing").  (Required-ness of the basis for
      ;; :withheld/:redacted is enforced separately below as
      ;; BARE-VISIBILITY-SCOPE; this only types a basis that IS present.  The
      ;; DURABLE-IDENTITY-P guard is evaluated first, so DURABLE-IDENTITY-DOMAIN
      ;; is never called on a non-identity.)
      (when authorizing-basis
        (unless (and (durable-identity-p authorizing-basis)
                     (member (durable-identity-domain authorizing-basis)
                             '(:claim :capability)
                             :test #'eq))
          (signal-kernel0
           'malformed-constructor-shape
           :requirement-id "K0E-20"
           :offending-field :authorizing-basis
           :offending-value authorizing-basis
           :failed-invariant
           "§3.3 [K0E-20]: authorizing-basis is a reference that grants nothing but MUST be a durable identity in the :claim or :capability domain (a claim identity or a capability fingerprint identity), not another identity domain, an arbitrary string, or a plist")))
      ;; :redaction-receipt-id is REQUIRED iff :redacted and FORBIDDEN otherwise.
      ;; A field-presence violation is a schema fault → MALFORMED-CONSTRUCTOR-SHAPE.
      (if (eq status :redacted)
          (progn
            (unless redaction-receipt-id
              (signal-kernel0
               'malformed-constructor-shape
               :requirement-id "K0E-20"
               :offending-field :redaction-receipt-id
               :failed-invariant
               "§3.3 [K0E-20]: a :redacted visibility record MUST bind a redaction transformation receipt"))
            (require-identity redaction-receipt-id :receipt))
          (when redaction-receipt-id
            (signal-kernel0
             'malformed-constructor-shape
             :requirement-id "K0E-20"
             :offending-field :redaction-receipt-id
             :offending-value redaction-receipt-id
             :failed-invariant
             "§3.3 [K0E-20]: a redaction-receipt-id is forbidden unless the status is :redacted")))
      (%require-proper-record-list
       evidence 'malformed-constructor-shape
       "§3.3 [K0E-20]: visibility evidence MUST be a finite proper list")
      (%require-proper-record-list
       bounded-unknowns 'malformed-constructor-shape
       "§3.3 [K0E-20]: visibility bounded-unknowns MUST be a finite proper list")
      ;; Scope / basis standing requirements (K0E-20).  Bare publication and a
      ;; scopeless withhold/redaction signal BARE-VISIBILITY-SCOPE.
      (ecase status
        (:published
         (%require-standing-fields
          (list (cons :scope-id scope-id))
          'bare-visibility-scope "K0E-20"
          "§3.3 [K0E-20]: a :published visibility record MUST bind a non-empty relational scope"))
        ((:withheld :redacted)
         (%require-standing-fields
          (list (cons :scope-id scope-id)
                (cons :authorizing-basis authorizing-basis))
          'bare-visibility-scope "K0E-20"
          "§3.3 [K0E-20]: a :withheld or :redacted visibility record MUST bind scope and authorizing basis")))
      (%make-visibility-record
       status
       subject-id
       (require-canonical representation-id)
       (%snapshot-tree scope-id)
       (%snapshot-tree authorizing-basis)
       redaction-receipt-id
       (%snapshot-tree evidence)
       (%snapshot-tree bounded-unknowns)))))

(defstruct (claim
            (:constructor %make-claim
                (claim-id
                 content-datum
                 source-ids
                 origin
                 validation-records
                 integrity-records
                 visibility-records
                 determinacy
                 bounded-unknowns))
            (:copier nil)
            (:conc-name %claim-))
  (claim-id nil :read-only t)
  (content-datum nil :read-only t)
  (source-ids nil :read-only t)
  ;; §15.2: origin is historical.  There is deliberately no writer.
  (origin nil :read-only t)
  (validation-records nil :read-only t)
  (integrity-records nil :read-only t)
  (visibility-records nil :read-only t)
  (determinacy nil :read-only t)
  (bounded-unknowns nil :read-only t))

(defun claim-claim-id (claim)
  (%claim-claim-id claim))

(defun claim-content-datum (claim)
  (%claim-content-datum claim))

(defun claim-source-ids (claim)
  (copy-list (%claim-source-ids claim)))

(defun claim-origin (claim)
  (%claim-origin claim))

(defun claim-validation-records (claim)
  (%snapshot-tree (%claim-validation-records claim)))

(defun claim-integrity-records (claim)
  (%snapshot-tree (%claim-integrity-records claim)))

(defun claim-visibility-records (claim)
  (%snapshot-tree (%claim-visibility-records claim)))

(defun claim-determinacy (claim)
  (%claim-determinacy claim))

(defun claim-bounded-unknowns (claim)
  (%snapshot-tree (%claim-bounded-unknowns claim)))

(defun %validated-claim
    (claim-id
     content-datum
     source-ids
     origin
     validation-records
     integrity-records
     visibility-records
     determinacy
     bounded-unknowns)
  (require-identity claim-id :claim)
  (let ((canonical-content
          (require-canonical content-datum :context claim-id)))
    (%require-reference-record-list
     source-ids
     'standing-inflation
     "§15.1: claim source-ids MUST be a finite list of durable identities"
     nil)
    (unless (member origin
                    '(:asserted :observed :derived :reconstructed)
                    :test #'eq)
      (signal-kernel0
       'standing-inflation
       :failed-invariant
       "§15.2: claim origin MUST be :asserted, :observed, :derived, or :reconstructed"))
    ;; K0E-18/19/20: standing no longer rides an opaque list.  Every validation,
    ;; integrity, and visibility entry MUST be a constructed record of the
    ;; correct type; an opaque or wrong-type entry is a schema failure keyed to
    ;; the slot's requirement id.  (Enforced here so REVALIDATE-CLAIM and
    ;; DERIVE-CLAIM — which route through this same validator — cannot smuggle
    ;; an untyped standing record past the claim invariant.)
    (%require-typed-record-list
     validation-records #'validation-record-p "K0E-18"
     "§15.1 [K0E-18]: every claim validation entry MUST be a constructed validation record")
    (%require-typed-record-list
     integrity-records #'integrity-record-p "K0E-19"
     "§15.1 [K0E-19]: every claim integrity entry MUST be a constructed integrity record")
    (%require-typed-record-list
     visibility-records #'visibility-record-p "K0E-20"
     "§15.1 [K0E-20]: every claim visibility entry MUST be a constructed visibility record")
    ;; B1 (K0E-18/19/20 subject binding — hostile review §3): a typed record is
    ;; not enough; each standing record MUST name THIS claim as its :subject-id.
    ;; A valid :verified/:published/:sealed record built for claim A, attached to
    ;; claim B, is standing laundering — a typed passport with no photograph.
    ;; (Enforced here so REVALIDATE-CLAIM and DERIVE-CLAIM, which route through
    ;; this same validator, cannot carry a foreign-subject record onto a claim.)
    (dolist (record validation-records)
      (%require-record-subject
       (%validation-record-subject-id record) claim-id "K0E-18"
       "§3.1 [K0E-18]: a validation record MUST name its containing claim as :subject-id; a record whose subject is another claim confers no validation standing here"))
    (dolist (record visibility-records)
      ;; B1 (K0E-20 subject binding) is checked BEFORE the B3 representation
      ;; invariant, mirroring the integrity loop: a foreign-subject visibility
      ;; record is refused as K0E-20 even when the representation it names
      ;; happens to equal THIS claim's content (the same-representation
      ;; laundering path the representation check alone cannot catch).
      (%require-record-subject
       (%visibility-record-subject-id record) claim-id "K0E-20"
       "§3.3 [K0E-20]: a visibility record MUST name its containing claim as :subject-id; a record whose subject is another claim confers no publication standing here")
      ;; B3 (K0E-20 representation binding — hostile review §5): visibility
      ;; standing is bound to a subject AND an exact representation (K0E-20), and
      ;; does not transfer to a transformed output (K0E-21).  A visibility record
      ;; naming another representation of this claim identity confers no standing
      ;; here — this is the integrity path's representation invariant applied to
      ;; visibility, using the SAME LISP-PLUS-CD0:EQUAL-DATUM comparison.  It
      ;; kills redaction collapse: a record over a redacted/public representation
      ;; R attached to a claim whose canonical content is the full, private
      ;; representation S.
      ;;
      ;; SINGLE-REPRESENTATION RULING: in Kernel /0 a claim object carries ONE
      ;; canonical content representation (its canonical content datum), so this
      ;; exact-equality check is complete and the CLAIM-PUBLISHED-TO-P query
      ;; surface — which collapses (claim scope) without a representation
      ;; argument — is safe.  A claim identity owning MULTIPLE representations is
      ;; a future-lane question (the review's own alternative); were it admitted,
      ;; the query would have to become representation-specific instead.  The
      ;; current surface is safe ONLY under this single-representation ruling.
      (%require-record-representation
       (%visibility-record-representation-id record) canonical-content claim-id
       "K0E-20"
       "§3.3 [K0E-20]: a visibility record binds one exact representation; a claim MUST NOT carry a visibility record over another representation (visibility does not transfer to a transformed output, K0E-21)"))
    (%require-proper-record-list
     bounded-unknowns
     'standing-inflation
     "§15.1: claim bounded-unknowns MUST be a finite proper list")
    ;; K0E-21 (copies cannot inherit seals): an integrity record may ride a
    ;; claim only when the representation it sealed is THIS claim's own
    ;; representation.  The claim's representation identity is its canonical
    ;; content datum; a seal naming another representation is refused as a
    ;; standing promotion.
    (dolist (record integrity-records)
      ;; B1 (K0E-19 subject binding) is checked BEFORE the K0E-21 representation
      ;; invariant, so a foreign-subject seal is refused as K0E-19 even when the
      ;; representation it sealed happens to equal THIS claim's content — the
      ;; same-representation seal-inheritance path the representation check alone
      ;; cannot catch (hostile review §3, consequence 3).
      (%require-record-subject
       (%integrity-record-subject-id record) claim-id "K0E-19"
       "§3.2 [K0E-19]: an integrity record MUST name its containing claim as :subject-id; a seal whose subject is another claim confers no integrity standing here, even over equal bytes")
      (%require-record-representation
       (%integrity-record-representation-id record) canonical-content claim-id
       "K0E-21"
       "§3.4 [K0E-21]: an integrity seal binds one exact representation; a claim MUST NOT carry a seal over another representation (a copy cannot inherit a seal)"))
    (unless (determinacy-p determinacy)
      (signal-kernel0
       'standing-inflation
       :failed-invariant
       "§15.1 and §7.1: a claim MUST carry proposition-specific determinacy"))
    (%make-claim claim-id
                 canonical-content
                 (copy-list source-ids)
                 origin
                 (%snapshot-tree validation-records)
                 (%snapshot-tree integrity-records)
                 (%snapshot-tree visibility-records)
                 determinacy
                 (%snapshot-tree bounded-unknowns))))

(defun make-claim (&rest arguments)
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:claim-id
             :content-datum
             :source-ids
             :origin
             :validation-records
             :integrity-records
             :visibility-records
             :determinacy
             :bounded-unknowns)
           'standing-inflation
           "§15.1–§15.2: a claim constructor MUST use the complete claim protocol shape")))
    (%require-record-fields
     parsed
     '(:claim-id
       :content-datum
       :source-ids
       :origin
       :validation-records
       :integrity-records
       :visibility-records
       :determinacy
       :bounded-unknowns)
     'standing-inflation
     "§15.1–§15.2: every claim protocol field MUST be explicitly bound")
    (%validated-claim
     (%parsed-argument parsed :claim-id)
     (%parsed-argument parsed :content-datum)
     (%parsed-argument parsed :source-ids)
     (%parsed-argument parsed :origin)
     (%parsed-argument parsed :validation-records)
     (%parsed-argument parsed :integrity-records)
     (%parsed-argument parsed :visibility-records)
     (%parsed-argument parsed :determinacy)
     (%parsed-argument parsed :bounded-unknowns))))

(defun revalidate-claim (claim new-validation-record)
  "Return a new claim with appended validation and exactly the same origin.

Under §15.7 [F: JRN-6], verification strengthens validation only: in
particular, a :RECONSTRUCTED claim remains :RECONSTRUCTED."
  (unless (claim-p claim)
    (signal-kernel0
     'standing-inflation
     :failed-invariant
     "§15.7 [F: JRN-6]: only an immutable claim may be revalidated"))
  (unless new-validation-record
    (signal-kernel0
     'bare-validation-scope
     :failed-invariant
     "§15.7 [F: JRN-6]: revalidation MUST append a non-NIL validation record"))
  (%validated-claim
   (%claim-claim-id claim)
   (%claim-content-datum claim)
   (%claim-source-ids claim)
   (%claim-origin claim)
   (append (%claim-validation-records claim)
           (list (%snapshot-tree new-validation-record)))
   (%claim-integrity-records claim)
   (%claim-visibility-records claim)
   (%claim-determinacy claim)
   (%claim-bounded-unknowns claim)))

(defun promote-origin (claim new-origin)
  "Refusal surface for every attempted origin promotion; it never mutates CLAIM."
  (declare (ignore new-origin))
  (signal-kernel0
   'standing-inflation
   :evidence-ids (if (claim-p claim)
                     (list (%claim-claim-id claim))
                     nil)
   :failed-invariant
   "§15.6 and §15.7 [F: JRN-6]: asserted→observed and reconstructed→observed standing promotion is refused; validation MUST NOT rewrite historical origin"))

(defun derive-claim
    (source-claim new-claim-id new-content-datum transformation-receipt-id
     new-determinacy &key validation-transfer-license (bounded-unknowns nil))
  "Return a genuinely NEW claim produced from SOURCE-CLAIM by a receipted
transformation, per §3.4 [K0E-21].

The output:

- receives a NEW caller-supplied identity (NEW-CLAIM-ID);
- has origin :DERIVED;
- preserves the source's origin in provenance by SOURCE-IDS linkage — the
  source claim identity and the transformation receipt are its source ids, so
  the historical source origin is reachable by reference and never copied into
  (or rewritten on) the derived claim;
- carries NO integrity standing (a seal binds one representation; it does not
  travel);
- carries NO visibility standing (visibility is granted only by a fresh scoped
  record);
- carries NO validation standing.  VALIDATION-TRANSFER-LICENSE is RETIRED from
  lawful use in this pure core: any non-NIL value is REFUSED (K0E-21) as a
  NAMED EXCLUSION, not a temporary approximation.  Lawful validation transfer
  requires a typed per-record transfer protocol binding source claim,
  destination claim, transformation receipt, record identity, procedure
  identity/version, original scope, and output scope — a protocol outside this
  sitting.  The default (NIL) transfers none.

A byte-identical alias to the same claim identity is NOT a transformation and
is deliberately NOT modeled: DERIVE-CLAIM requires a new identity, so it never
produces an alias.  TRANSFORMATION-RECEIPT-ID is the required receipt reference
that witnesses the transformation (the kernel names it by reference; the
field-rich §15.5 transformation-receipt object is a library protocol, so there
is no make-transformation-receipt constructor to reuse in the pure core)."
  (unless (claim-p source-claim)
    (signal-kernel0
     'standing-inflation
     :failed-invariant
     "§3.4 [K0E-21]: only an immutable claim may be transformed by DERIVE-CLAIM"))
  (require-identity new-claim-id :claim)
  (require-identity transformation-receipt-id :receipt)
  (when (identity= new-claim-id (%claim-claim-id source-claim))
    (signal-kernel0
     'standing-inflation
     :requirement-id "K0E-21"
     :evidence-ids (list (%claim-claim-id source-claim))
     :failed-invariant
     "§3.4 [K0E-21]: a byte-identical alias to the same claim identity is not a transformation; DERIVE-CLAIM requires a new identity"))
  ;; B2 / K0E-21 (hostile review §4): the pure-core sitting does NOT implement a
  ;; typed per-record validation-transfer protocol, so the earlier wholesale copy
  ;; of every source validation record under one bare procedure identity — which
  ;; would carry validations under UNNAMED procedures across the transformation —
  ;; is refused refusal-first.  A bare procedure identity is insufficient to
  ;; authorize transfer; any non-NIL license is a NAMED EXCLUSION.
  (when validation-transfer-license
    (signal-kernel0
     'standing-inflation
     :requirement-id "K0E-21"
     :evidence-ids (list (%claim-claim-id source-claim))
     :failed-invariant
     "§3.4 [K0E-21]: validation transfer requires a typed per-record transfer protocol binding source claim, destination claim, transformation receipt, record identity, procedure identity/version, original scope, and output scope — outside this pure-core sitting; transfer is a NAMED EXCLUSION pending that protocol"))
  (%validated-claim
   new-claim-id
   new-content-datum
   ;; Provenance linkage: the source claim identity and the transformation
   ;; receipt.  Both are durable identities, so %VALIDATED-CLAIM's source-id
   ;; discipline accepts them and the derivation stays auditable.
   (list (%claim-claim-id source-claim) transformation-receipt-id)
   :derived
   nil    ; NO validation standing of any facet transfers (refusal-first).
   nil
   nil
   new-determinacy
   bounded-unknowns))

(defun claim-validated-under-p (claim procedure-id scope)
  "K0E-22: a procedure/scope-bound validation query.

True exactly when CLAIM carries a :VERIFIED validation record whose procedure
and scope match PROCEDURE-ID and SCOPE under the single named Kernel equality.
No :CHECKED, :REFUTED, or :UNCHECKED record counts as validated-under, and a
sealed integrity record grants no validation standing at all — integrity and
validation are orthogonal (K0E-21).

Kernel /0 MUST NOT expose any context-free VERIFIED-P: standing is meaningless
without the procedure and scope it holds under, so none is defined here."
  (unless (claim-p claim)
    (signal-kernel0
     'standing-inflation
     :failed-invariant
     "§3.5 [K0E-22]: claim-validated-under-p requires an immutable claim"))
  (and (some (lambda (record)
               (and (validation-record-p record)
                    ;; B1 defense in depth (hostile review §3): though
                    ;; %VALIDATED-CLAIM now binds subject at construction, the
                    ;; query INDEPENDENTLY refuses to count a record whose
                    ;; subject is not THIS claim.  A record that does not name
                    ;; the claim as its subject contributes nothing, even if a
                    ;; constructor bug should ever let one through.
                    (identity= (%validation-record-subject-id record)
                               (%claim-claim-id claim))
                    (eq (%validation-record-status record) :verified)
                    (%kernel-name=
                     (%validation-record-procedure-id record) procedure-id)
                    (%kernel-name=
                     (%validation-record-scope record) scope)))
             (%claim-validation-records claim))
       t))

(defun claim-published-to-p (claim scope-id)
  "K0E-22: a scope-bound publication query.

True exactly when CLAIM carries a :PUBLISHED visibility record whose scope
matches SCOPE-ID under the named Kernel equality AND whose exact representation
is THIS claim's canonical content datum (K0E-20 representation binding).

REDACTION-COLLAPSE (hostile review §5): visibility standing binds a subject and
an EXACT representation, not a bare subject.  Suppose representation R is
redacted/public while the full representation S is private; a visibility record
naming subject C and representation R attached to a claim object C whose content
is S must NOT report the claim as published for C/S.  The representation recheck
below defeats that collapse at query time, mirroring the B1 subject recheck: a
record whose canonical representation is not this claim's canonical content
contributes no publication standing, even if a constructor bug should ever
attach one.  This is defense in depth — %VALIDATED-CLAIM already binds the
representation at construction.

SINGLE-REPRESENTATION RULING (K0E-20): the (CLAIM SCOPE-ID) surface safely
collapses representations because a Kernel /0 claim carries ONE canonical
content representation.  A multi-representation claim identity is a future-lane
question; under it this query would have to become representation-specific.

Kernel /0 MUST NOT expose any context-free PUBLISHED-P: publication has no
meaning apart from the scope it reaches, so none is defined here."
  (unless (claim-p claim)
    (signal-kernel0
     'standing-inflation
     :failed-invariant
     "§3.5 [K0E-22]: claim-published-to-p requires an immutable claim"))
  (and (some (lambda (record)
               (and (visibility-record-p record)
                    ;; B1 defense in depth (hostile review §3): the query
                    ;; independently rechecks that the record names THIS claim
                    ;; as its subject; a published record about another claim
                    ;; contributes no publication standing here.
                    (identity= (%visibility-record-subject-id record)
                               (%claim-claim-id claim))
                    ;; B3 defense in depth (hostile review §5): the query
                    ;; independently rechecks that the record's exact
                    ;; representation is THIS claim's canonical content; a record
                    ;; over another representation of the claim identity (the
                    ;; redaction-collapse case) contributes no publication
                    ;; standing here.  The claim's stored content datum is
                    ;; already canonical, as is the record's representation-id.
                    (lisp-plus-cd0:equal-datum
                     (%visibility-record-representation-id record)
                     (%claim-content-datum claim))
                    (eq (%visibility-record-status record) :published)
                    (%kernel-name=
                     (%visibility-record-scope-id record) scope-id)))
             (%claim-visibility-records claim))
       t))
