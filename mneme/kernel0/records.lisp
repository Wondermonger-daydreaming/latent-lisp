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
    (dolist (field (list validation-records
                         integrity-records
                         visibility-records
                         bounded-unknowns))
      (%require-proper-record-list
       field
       'standing-inflation
       "§15.1: claim validation, integrity, visibility, and bounded-unknown fields MUST be finite proper lists"))
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
