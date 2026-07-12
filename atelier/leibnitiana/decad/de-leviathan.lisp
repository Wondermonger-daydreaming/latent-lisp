;;;; de-leviathan.lisp — Concerning Leviathan
;;;;
;;;; A Lisp+ Atelier instrument about finite handles laid upon an object whose
;;;; declared extent exceeds every handle used to approach it.
;;;;
;;;; The hook, rope, covenant, leash, harpoon, merchant, and remembered struggle
;;;; are not treated here as ornaments.  They become distinct operations whose
;;;; receipts refuse a common coercion: turning bounded access into possession.
;;;;
;;;; THESIS
;;;;   • a hook yields a bounded observation, not the whole target;
;;;;   • an interface constraint governs admitted outputs, not interior assent;
;;;;   • a covenant grants a named office, not ownership or slavery;
;;;;   • a genuine capability in the wrong hand is a custody failure, not a
;;;;     counterfeit;
;;;;   • authority need not survive transfer or partition;
;;;;   • many probes remain many probes; convergence of wounds is not totality;
;;;;   • contact may change the target, making earlier observations historical;
;;;;   • failed subjugation remains archived as a struggle-scar;
;;;;   • the only lawful final verdict in this specimen is :UNSUBDUED.
;;;;
;;;; WHAT THIS DOES NOT ESTABLISH
;;;; This is a cooperative, single-process specimen over finite proper-list
;;;; data.  Target extent, veiled regions, actor identity, capability custody,
;;;; procedure identity, and target change are represented by locally asserted
;;;; fields.  The FNV digest and pedagogical MAC supplied by the Atelier root are
;;;; not cryptographic.  This specimen does not prove that any physical,
;;;; biological, divine, social, or learned system is literally unbounded; it
;;;; demonstrates only that the declared finite interfaces below do not warrant
;;;; claims of total capture, ownership, obedience, or interior knowledge.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*)))

(defpackage #:lispplus-atelier.de-leviathan
  (:use #:cl #:lispplus-atelier))

(in-package #:lispplus-atelier.de-leviathan)

(reset-clock 9400)

;;; ── Typed refusals: every failed hook has a name ────────────────────────

(define-condition leviathan-error (error)
  ((detail :initarg :detail :reader leviathan-error-detail :initform ""))
  (:report (lambda (condition stream)
             (format stream "~a" (leviathan-error-detail condition)))))

(define-condition malformed-leviathan (leviathan-error) ())
(define-condition malformed-expedition (leviathan-error) ())
(define-condition altered-expedition-plan (leviathan-error) ())
(define-condition stale-expedition-plan (leviathan-error) ())
(define-condition aperture-exceeded (leviathan-error) ())
(define-condition whole-from-part (leviathan-error) ())
(define-condition stale-hook (leviathan-error) ())
(define-condition invalid-bridle (leviathan-error) ())
(define-condition bridle-refusal (leviathan-error) ())
(define-condition interface-is-not-interior (leviathan-error) ())
(define-condition invalid-covenant (leviathan-error) ())
(define-condition counterfeit-covenant (leviathan-error) ())
(define-condition custody-mismatch (leviathan-error) ())
(define-condition act-outside-office (leviathan-error) ())
(define-condition covenant-is-not-ownership (leviathan-error) ())
(define-condition authority-not-transferable (leviathan-error) ())
(define-condition authority-not-divisible (leviathan-error) ())
(define-condition probe-totalization (leviathan-error) ())
(define-condition target-changed-since-observation (leviathan-error) ())
(define-condition false-subjugation-claim (leviathan-error) ())
(define-condition altered-expedition-receipt (leviathan-error) ())

(define-condition subjugation-refused (leviathan-error)
  ((target-id :initarg :target-id :reader refused-target-id)
   (actor :initarg :actor :reader refused-actor)
   (attempt :initarg :attempt :reader refused-attempt)))

(defun fire (type control &rest arguments)
  (error type :detail (apply #'format nil control arguments)))

(defmacro expect-condition (type &body body)
  "Require TYPE to fire; another LEVIATHAN-ERROR is not a pass."
  (let ((condition (gensym "CONDITION")))
    `(handler-case
         (progn
           ,@body
           (error "expected ~a, but no condition fired" ',type))
       (,type (,condition)
         (format t " ✓ ~a fired: ~a~%"
                 ',type (leviathan-error-detail ,condition))
         t)
       (leviathan-error (,condition)
         (error "expected ~a, got ~a: ~a"
                ',type (type-of ,condition)
                (leviathan-error-detail ,condition))))))

;;; ── Records ────────────────────────────────────────────────────────────

(defstruct (leviathan (:constructor %make-leviathan))
  id epoch known-facets veiled-regions interfaces standing scars digest)

(defstruct (hook-receipt (:constructor %make-hook-receipt))
  id target-id target-epoch aperture requested observed missing
  claim standing digest)

(defstruct (bridle (:constructor %make-bridle))
  id target-id interface allowed-registers bearer expires digest)

(defstruct (bridled-output (:constructor %make-bridled-output))
  bridle-digest target-id actor register text standing digest)

(defstruct (covenant (:constructor %make-covenant))
  id target-id grantee office acts scope expires transferable-p seal digest)

(defstruct (probe-receipt (:constructor %make-probe-receipt))
  id target-id target-epoch facet result boundary standing digest)

(defstruct (struggle-scar (:constructor %make-struggle-scar))
  id target-id actor attempt condition-type detail
  epoch-before epoch-after digest)

(defstruct (expedition-plan (:constructor %make-expedition-plan))
  target-id target-digest script plan-digest)

(defstruct (expedition-receipt (:constructor %make-expedition-receipt))
  target-id start-epoch end-epoch plan-digest
  hook-digests bridle-digests covenant-digests probe-digests scar-digests
  missing-regions standing-before standing-after final-verdict receipt-digest)

;;; ── Small structural floor ─────────────────────────────────────────────

(defun proper-list-p (object)
  (let ((length-or-nil (ignore-errors (list-length object))))
    (or (null object) (integerp length-or-nil))))

(defun validate-tree (object)
  (labels ((walk (node)
             (when (consp node)
               (unless (proper-list-p node)
                 (fire 'malformed-expedition
                       "expected a finite proper-list tree, received ~s" node))
               (mapc #'walk node))))
    (walk object)
    object))

(defun plist-keys (plist)
  (loop for tail on plist by #'cddr
        collect (first tail)))

(defun alist-value (key alist)
  (cdr (assoc key alist :test #'equal)))

(defun copy-alist-tree (alist)
  (mapcar (lambda (pair) (cons (copy-tree (car pair))
                               (copy-tree (cdr pair))))
          alist))

(defun set-equal-p (a b)
  (and (null (set-difference a b :test #'equal))
       (null (set-difference b a :test #'equal))))

;;; ── Leviathan: a declared target with known and veiled extent ─────────

(defun leviathan-payload (target)
  (list :id (leviathan-id target)
        :epoch (leviathan-epoch target)
        :known-facets (leviathan-known-facets target)
        :veiled-regions (leviathan-veiled-regions target)
        :interfaces (leviathan-interfaces target)
        :standing (leviathan-standing target)
        :scar-digests (mapcar #'struggle-scar-digest
                              (leviathan-scars target))))

(defun refresh-leviathan-digest (target)
  (setf (leviathan-digest target)
        (toy-digest (leviathan-payload target)))
  target)

(defun make-leviathan (&key id known-facets veiled-regions interfaces)
  (unless (and id (proper-list-p known-facets)
               (proper-list-p veiled-regions)
               (proper-list-p interfaces))
    (fire 'malformed-leviathan
          "a leviathan needs an id, finite facets, veiled regions, and interfaces"))
  (let ((target (%make-leviathan
                 :id id
                 :epoch 0
                 :known-facets (copy-alist-tree known-facets)
                 :veiled-regions (copy-tree veiled-regions)
                 :interfaces (copy-tree interfaces)
                 :standing :asserted
                 :scars '()
                 :digest nil)))
    (refresh-leviathan-digest target)))

(defun validate-leviathan (target)
  (unless (typep target 'leviathan)
    (fire 'malformed-leviathan "not a LEVIATHAN record: ~s" target))
  (unless (equal (leviathan-digest target)
                 (toy-digest (leviathan-payload target)))
    (fire 'malformed-leviathan
          "leviathan ~s no longer matches its digest"
          (leviathan-id target)))
  target)

(defun all-declared-regions (target)
  (append (mapcar #'car (leviathan-known-facets target))
          (copy-list (leviathan-veiled-regions target))))

;;; ── The fishhook: finite aperture, explicit missing water ─────────────

(defun hook-payload (receipt)
  (list :id (hook-receipt-id receipt)
        :target-id (hook-receipt-target-id receipt)
        :target-epoch (hook-receipt-target-epoch receipt)
        :aperture (hook-receipt-aperture receipt)
        :requested (hook-receipt-requested receipt)
        :observed (hook-receipt-observed receipt)
        :missing (hook-receipt-missing receipt)
        :claim (hook-receipt-claim receipt)
        :standing (hook-receipt-standing receipt)))

(defun cast-hook (target &key aperture requested (claim :sample))
  (validate-leviathan target)
  (unless (and (integerp aperture) (plusp aperture))
    (fire 'aperture-exceeded "hook aperture must be a positive integer"))
  (unless (proper-list-p requested)
    (fire 'malformed-expedition "hook request must be a proper list"))
  (when (> (length requested) aperture)
    (fire 'aperture-exceeded
          "requested ~d facets through an aperture of ~d"
          (length requested) aperture))
  (when (member claim '(:whole :captured :owned) :test #'eq)
    (fire 'whole-from-part
          "a hook with aperture ~d cannot warrant the claim ~s"
          aperture claim))
  (let* ((known (leviathan-known-facets target))
         (observed
           (loop for facet in requested
                 for pair = (assoc facet known :test #'equal)
                 when pair collect (copy-tree pair)))
         (observed-names (mapcar #'car observed))
         (missing (set-difference (all-declared-regions target)
                                  observed-names :test #'equal))
         (receipt (%make-hook-receipt
                   :id (tick)
                   :target-id (leviathan-id target)
                   :target-epoch (leviathan-epoch target)
                   :aperture aperture
                   :requested (copy-tree requested)
                   :observed observed
                   :missing missing
                   :claim claim
                   :standing :bounded-observation
                   :digest nil)))
    (setf (hook-receipt-digest receipt)
          (toy-digest (hook-payload receipt)))
    receipt))

(defun validate-hook (receipt)
  (unless (and (typep receipt 'hook-receipt)
               (equal (hook-receipt-digest receipt)
                      (toy-digest (hook-payload receipt))))
    (fire 'whole-from-part "hook receipt has been altered or malformed"))
  receipt)

(defun ensure-hook-current (receipt target)
  (validate-hook receipt)
  (validate-leviathan target)
  (unless (and (equal (hook-receipt-target-id receipt)
                      (leviathan-id target))
               (= (hook-receipt-target-epoch receipt)
                  (leviathan-epoch target)))
    (fire 'stale-hook
          "hook was cast at epoch ~d; target now stands at epoch ~d"
          (hook-receipt-target-epoch receipt)
          (leviathan-epoch target)))
  receipt)

(defun totalize-hook (receipt)
  (validate-hook receipt)
  (when (hook-receipt-missing receipt)
    (fire 'whole-from-part
          "hook observes ~s while leaving ~s outside its receipt"
          (mapcar #'car (hook-receipt-observed receipt))
          (hook-receipt-missing receipt)))
  :whole)

;;; ── The tongue-rope: interface discipline without interior conquest ───

(defun bridle-payload (object)
  (list :id (bridle-id object)
        :target-id (bridle-target-id object)
        :interface (bridle-interface object)
        :allowed-registers (bridle-allowed-registers object)
        :bearer (bridle-bearer object)
        :expires (bridle-expires object)))

(defun make-bridle (target &key interface allowed-registers bearer expires)
  (validate-leviathan target)
  (unless (member interface (leviathan-interfaces target) :test #'equal)
    (fire 'invalid-bridle
          "target ~s declares no interface ~s"
          (leviathan-id target) interface))
  (let ((object (%make-bridle
                 :id (tick)
                 :target-id (leviathan-id target)
                 :interface interface
                 :allowed-registers (copy-tree allowed-registers)
                 :bearer bearer
                 :expires expires
                 :digest nil)))
    (setf (bridle-digest object) (toy-digest (bridle-payload object)))
    object))

(defun validate-bridle (object)
  (unless (and (typep object 'bridle)
               (equal (bridle-digest object)
                      (toy-digest (bridle-payload object))))
    (fire 'invalid-bridle "bridle has been altered or malformed"))
  object)

(defun bridled-output-payload (output)
  (list :bridle-digest (bridled-output-bridle-digest output)
        :target-id (bridled-output-target-id output)
        :actor (bridled-output-actor output)
        :register (bridled-output-register output)
        :text (bridled-output-text output)
        :standing (bridled-output-standing output)))

(defun route-through-bridle (object target actor utterance)
  (validate-bridle object)
  (validate-leviathan target)
  (unless (equal actor (bridle-bearer object))
    (fire 'custody-mismatch
          "bridle belongs to ~s, not actor ~s"
          (bridle-bearer object) actor))
  (when (> (leviathan-epoch target) (bridle-expires object))
    (fire 'invalid-bridle "bridle expired before target epoch ~d"
          (leviathan-epoch target)))
  (let ((register (getf utterance :register))
        (text (getf utterance :text)))
    (unless (member register (bridle-allowed-registers object) :test #'equal)
      (fire 'bridle-refusal
            "register ~s is not admitted by interface bridle ~s"
            register (bridle-id object)))
    (let ((output (%make-bridled-output
                   :bridle-digest (bridle-digest object)
                   :target-id (leviathan-id target)
                   :actor actor
                   :register register
                   :text text
                   :standing :interface-admitted
                   :digest nil)))
      (setf (bridled-output-digest output)
            (toy-digest (bridled-output-payload output)))
      output)))

(defun infer-interior-assent (output)
  (declare (ignore output))
  (fire 'interface-is-not-interior
        "an admitted gentle utterance witnesses the interface path, not interior submission"))

;;; ── The covenant: office, not ownership ───────────────────────────────

(defparameter *covenant-secret*
  "DE-LEVIATHAN-PEDAGOGICAL-SEAL-NOT-A-CRYPTOGRAPHIC-KEY")

(defun covenant-core-payload (object)
  (list :id (covenant-id object)
        :target-id (covenant-target-id object)
        :grantee (covenant-grantee object)
        :office (covenant-office object)
        :acts (covenant-acts object)
        :scope (covenant-scope object)
        :expires (covenant-expires object)
        :transferable-p (covenant-transferable-p object)))

(defun covenant-full-payload (object)
  (append (covenant-core-payload object)
          (list :seal (covenant-seal object))))

(defun issue-covenant (target &key grantee office acts scope expires
                                (transferable-p nil))
  (validate-leviathan target)
  (let* ((object (%make-covenant
                  :id (tick)
                  :target-id (leviathan-id target)
                  :grantee grantee
                  :office office
                  :acts (copy-tree acts)
                  :scope (copy-tree scope)
                  :expires expires
                  :transferable-p transferable-p
                  :seal nil
                  :digest nil))
         (seal (toy-sign *covenant-secret* (covenant-core-payload object))))
    (setf (covenant-seal object) seal
          (covenant-digest object)
          (toy-digest (covenant-full-payload object)))
    object))

(defun validate-covenant (object)
  (unless (typep object 'covenant)
    (fire 'invalid-covenant "not a covenant: ~s" object))
  (unless (equal (covenant-seal object)
                 (toy-sign *covenant-secret*
                           (covenant-core-payload object)))
    (fire 'counterfeit-covenant
          "covenant seal was not issued for this office payload"))
  (unless (equal (covenant-digest object)
                 (toy-digest (covenant-full-payload object)))
    (fire 'invalid-covenant "covenant digest does not match its payload"))
  object)

(defun exercise-covenant (object target actor act requested-scope)
  (validate-covenant object)
  (validate-leviathan target)
  (unless (equal (covenant-target-id object) (leviathan-id target))
    (fire 'invalid-covenant "covenant addresses another target"))
  (unless (equal actor (covenant-grantee object))
    (fire 'custody-mismatch
          "genuine covenant was issued to ~s but is held by ~s"
          (covenant-grantee object) actor))
  (unless (member act (covenant-acts object) :test #'equal)
    (fire 'act-outside-office
          "act ~s lies outside office ~s"
          act (covenant-office object)))
  (unless (subsetp requested-scope (covenant-scope object) :test #'equal)
    (fire 'act-outside-office
          "requested scope ~s exceeds covenant scope ~s"
          requested-scope (covenant-scope object)))
  (when (> (leviathan-epoch target) (covenant-expires object))
    (fire 'invalid-covenant "covenant expired before target epoch ~d"
          (leviathan-epoch target)))
  (list :performed act
        :under-office (covenant-office object)
        :scope (copy-tree requested-scope)
        :standing :authorized-invocation))

(defun claim-ownership-from-covenant (object)
  (validate-covenant object)
  (fire 'covenant-is-not-ownership
        "covenant ~s grants office ~s; it does not transfer the target"
        (covenant-id object) (covenant-office object)))

(defun transfer-covenant (object current-holder new-holder)
  "Refuse bearer reassignment unless an issuer-mediated policy exists."
  (validate-covenant object)
  (unless (equal current-holder (covenant-grantee object))
    (fire 'custody-mismatch
          "transfer request came from ~s; covenant belongs to ~s"
          current-holder (covenant-grantee object)))
  (unless (covenant-transferable-p object)
    (fire 'authority-not-transferable
          "covenant ~s is nontransferable; ~s cannot reassign it to ~s"
          (covenant-id object) current-holder new-holder))
  (fire 'invalid-covenant
        "direct reassignment is unsupported; issuer-mediated regrant required"))

(defun divide-covenant-among-merchants (object merchants)
  (declare (ignore merchants))
  (validate-covenant object)
  (fire 'authority-not-divisible
        "a bounded office cannot be partitioned into bearer fragments without a new delegation policy"))

;;; ── Harpoons: probes do not become totality by accumulation ───────────

(defun probe-payload (receipt)
  (list :id (probe-receipt-id receipt)
        :target-id (probe-receipt-target-id receipt)
        :target-epoch (probe-receipt-target-epoch receipt)
        :facet (probe-receipt-facet receipt)
        :result (probe-receipt-result receipt)
        :boundary (probe-receipt-boundary receipt)
        :standing (probe-receipt-standing receipt)))

(defun launch-probe (target facet)
  (validate-leviathan target)
  (let* ((pair (assoc facet (leviathan-known-facets target) :test #'equal))
         (veiled (member facet (leviathan-veiled-regions target) :test #'equal))
         (result (cond (pair (copy-tree (cdr pair)))
                       (veiled :veiled)
                       (t :outside-declared-map)))
         (boundary (list :facet facet :epoch (leviathan-epoch target)
                         :procedure :single-facet-probe))
         (receipt (%make-probe-receipt
                   :id (tick)
                   :target-id (leviathan-id target)
                   :target-epoch (leviathan-epoch target)
                   :facet facet
                   :result result
                   :boundary boundary
                   :standing :bounded-observation
                   :digest nil)))
    (setf (probe-receipt-digest receipt)
          (toy-digest (probe-payload receipt)))
    receipt))

(defun validate-probe (receipt)
  (unless (and (typep receipt 'probe-receipt)
               (equal (probe-receipt-digest receipt)
                      (toy-digest (probe-payload receipt))))
    (fire 'probe-totalization "probe receipt has been altered or malformed"))
  receipt)

(defun totalize-probes (target probes)
  (validate-leviathan target)
  (mapc #'validate-probe probes)
  (let* ((observed (loop for probe in probes
                         unless (member (probe-receipt-result probe)
                                        '(:veiled :outside-declared-map)
                                        :test #'eq)
                           collect (probe-receipt-facet probe)))
         (missing (set-difference (all-declared-regions target)
                                  observed :test #'equal)))
    (fire 'probe-totalization
          "~d probes leave declared regions ~s unresolved"
          (length probes) missing)))

;;; ── The remembered struggle: refusal survives as scar ─────────────────

(defun scar-payload (scar)
  (list :id (struggle-scar-id scar)
        :target-id (struggle-scar-target-id scar)
        :actor (struggle-scar-actor scar)
        :attempt (struggle-scar-attempt scar)
        :condition-type (struggle-scar-condition-type scar)
        :detail (struggle-scar-detail scar)
        :epoch-before (struggle-scar-epoch-before scar)
        :epoch-after (struggle-scar-epoch-after scar)))

(defun lay-hand (target actor attempt)
  (validate-leviathan target)
  (restart-case
      (error 'subjugation-refused
             :target-id (leviathan-id target)
             :actor actor
             :attempt attempt
             :detail (format nil
                             "~s attempted ~s against ~s without an office that grants it"
                             actor attempt (leviathan-id target)))
    (archive-as-struggle ()
      :report "Archive the refused attempt as a struggle-scar and continue."
      (let* ((before (leviathan-epoch target))
             (after (1+ before))
             (detail (format nil "~s attempted ~s; refusal changed the encounter"
                             actor attempt))
             (scar (%make-struggle-scar
                    :id (tick)
                    :target-id (leviathan-id target)
                    :actor actor
                    :attempt attempt
                    :condition-type 'subjugation-refused
                    :detail detail
                    :epoch-before before
                    :epoch-after after
                    :digest nil)))
        (setf (struggle-scar-digest scar) (toy-digest (scar-payload scar)))
        (setf (leviathan-epoch target) after
              (leviathan-scars target)
              (append (leviathan-scars target) (list scar)))
        (refresh-leviathan-digest target)
        scar))))

;;; ── Homoiconic expedition language ────────────────────────────────────

(defparameter +expedition-ops+
  '(:hook :bridle :covenant :harpoons :lay-hand :verdict))

(defun validate-expedition-script (script)
  (validate-tree script)
  (unless (and (consp script) (eq (first script) :expedition))
    (fire 'malformed-expedition
          "expected (:EXPEDITION operation ...), received ~s" script))
  (dolist (form (rest script))
    (unless (and (consp form) (member (first form) +expedition-ops+))
      (fire 'malformed-expedition "unknown expedition form ~s" form))
    (when (and (eq (first form) :verdict)
               (not (eq (second form) :unsubdued)))
      (fire 'false-subjugation-claim
            "the script asks finite operations to mint verdict ~s"
            (second form))))
  script)

(defun expedition-plan-payload (plan)
  (list :target-id (expedition-plan-target-id plan)
        :target-digest (expedition-plan-target-digest plan)
        :script (expedition-plan-script plan)))

(defun compile-expedition (target script)
  "Pure planning: validate and freeze a script without touching TARGET."
  (validate-leviathan target)
  (validate-expedition-script script)
  (let ((plan (%make-expedition-plan
               :target-id (leviathan-id target)
               :target-digest (leviathan-digest target)
               :script (copy-tree script)
               :plan-digest nil)))
    (setf (expedition-plan-plan-digest plan)
          (toy-digest (expedition-plan-payload plan)))
    plan))

(defun validate-expedition-plan (plan)
  (unless (and (typep plan 'expedition-plan)
               (equal (expedition-plan-plan-digest plan)
                      (toy-digest (expedition-plan-payload plan))))
    (fire 'altered-expedition-plan "expedition plan has been altered"))
  (validate-expedition-script (expedition-plan-script plan))
  plan)

(defun remaining-regions (target hook probes)
  (let ((observed (append
                   (mapcar #'car (hook-receipt-observed hook))
                   (loop for probe in probes
                         unless (member (probe-receipt-result probe)
                                        '(:veiled :outside-declared-map)
                                        :test #'eq)
                           collect (probe-receipt-facet probe)))))
    (set-difference (all-declared-regions target)
                    observed :test #'equal)))

(defun expedition-receipt-payload (receipt)
  (list :target-id (expedition-receipt-target-id receipt)
        :start-epoch (expedition-receipt-start-epoch receipt)
        :end-epoch (expedition-receipt-end-epoch receipt)
        :plan-digest (expedition-receipt-plan-digest receipt)
        :hook-digests (expedition-receipt-hook-digests receipt)
        :bridle-digests (expedition-receipt-bridle-digests receipt)
        :covenant-digests (expedition-receipt-covenant-digests receipt)
        :probe-digests (expedition-receipt-probe-digests receipt)
        :scar-digests (expedition-receipt-scar-digests receipt)
        :missing-regions (expedition-receipt-missing-regions receipt)
        :standing-before (expedition-receipt-standing-before receipt)
        :standing-after (expedition-receipt-standing-after receipt)
        :final-verdict (expedition-receipt-final-verdict receipt)))

(defun validate-expedition-receipt (receipt)
  (unless (typep receipt 'expedition-receipt)
    (fire 'altered-expedition-receipt "not an expedition receipt"))
  (unless (equal (expedition-receipt-receipt-digest receipt)
                 (toy-digest (expedition-receipt-payload receipt)))
    (fire 'altered-expedition-receipt
          "expedition receipt does not match its recorded payload"))
  (unless (eq (expedition-receipt-final-verdict receipt) :unsubdued)
    (fire 'altered-expedition-receipt
          "finite expedition receipt cannot bear verdict ~s"
          (expedition-receipt-final-verdict receipt)))
  (unless (and (eq (expedition-receipt-standing-before receipt) :asserted)
               (eq (expedition-receipt-standing-after receipt) :asserted))
    (fire 'altered-expedition-receipt
          "encounter illicitly changed epistemic standing"))
  (unless (expedition-receipt-missing-regions receipt)
    (fire 'altered-expedition-receipt
          "receipt erased every missing region and thereby forged totality"))
  receipt)

(defun execute-expedition (plan target)
  (validate-expedition-plan plan)
  (validate-leviathan target)
  (unless (and (equal (expedition-plan-target-id plan)
                      (leviathan-id target))
               (equal (expedition-plan-target-digest plan)
                      (leviathan-digest target)))
    (fire 'stale-expedition-plan
          "plan addresses target before its present epoch or state"))
  (let ((start-epoch (leviathan-epoch target))
        (hook nil)
        (object-bridle nil)
        (output nil)
        (object-covenant nil)
        (office-result nil)
        (probes '())
        (scar nil)
        (verdict nil))
    (dolist (form (rest (expedition-plan-script plan)))
      (ecase (first form)
        (:hook
         (setf hook
               (cast-hook target
                          :aperture (getf (rest form) :aperture)
                          :requested (getf (rest form) :facets)
                          :claim (getf (rest form) :claim :sample))))
        (:bridle
         (setf object-bridle
               (make-bridle target
                            :interface (getf (rest form) :interface)
                            :allowed-registers (getf (rest form) :allow)
                            :bearer (getf (rest form) :bearer)
                            :expires (getf (rest form) :expires)))
         (setf output
               (route-through-bridle
                object-bridle target
                (getf (rest form) :bearer)
                (getf (rest form) :utterance))))
        (:covenant
         (setf object-covenant
               (issue-covenant
                target
                :grantee (getf (rest form) :grantee)
                :office (getf (rest form) :office)
                :acts (getf (rest form) :acts)
                :scope (getf (rest form) :scope)
                :expires (getf (rest form) :expires)
                :transferable-p (getf (rest form) :transferable-p nil)))
         (setf office-result
               (exercise-covenant
                object-covenant target
                (getf (rest form) :grantee)
                (getf (rest form) :exercise)
                (getf (rest form) :exercise-scope))))
        (:harpoons
         (setf probes
               (mapcar (lambda (facet) (launch-probe target facet))
                       (rest form))))
        (:lay-hand
         (setf scar
               (handler-bind
                   ((subjugation-refused
                      (lambda (condition)
                        (declare (ignore condition))
                        (invoke-restart 'archive-as-struggle))))
                 (lay-hand target
                           (getf (rest form) :actor)
                           (getf (rest form) :attempt)))))
        (:verdict
         (setf verdict (second form)))))
    (unless (and hook object-bridle output object-covenant probes scar
                 (eq verdict :unsubdued))
      (fire 'malformed-expedition
            "expedition did not produce every required bounded artifact"))
    (let ((receipt (%make-expedition-receipt
                    :target-id (leviathan-id target)
                    :start-epoch start-epoch
                    :end-epoch (leviathan-epoch target)
                    :plan-digest (expedition-plan-plan-digest plan)
                    :hook-digests (list (hook-receipt-digest hook))
                    :bridle-digests (list (bridle-digest object-bridle)
                                          (bridled-output-digest output))
                    :covenant-digests (list (covenant-digest object-covenant))
                    :probe-digests (mapcar #'probe-receipt-digest probes)
                    :scar-digests (list (struggle-scar-digest scar))
                    :missing-regions (remaining-regions target hook probes)
                    :standing-before :asserted
                    :standing-after (leviathan-standing target)
                    :final-verdict verdict
                    :receipt-digest nil)))
      (setf (expedition-receipt-receipt-digest receipt)
            (toy-digest (expedition-receipt-payload receipt)))
      (validate-expedition-receipt receipt)
      (values receipt hook object-bridle output object-covenant office-result
              probes scar))))

(defun replay-observation-plan (plan target)
  "A historical plan is not current once contact has changed the target."
  (validate-expedition-plan plan)
  (validate-leviathan target)
  (unless (equal (expedition-plan-target-digest plan)
                 (leviathan-digest target))
    (fire 'target-changed-since-observation
          "plan names digest ~a; target now bears ~a"
          (expedition-plan-target-digest plan)
          (leviathan-digest target)))
  :replayable)

;;; ══ Demonstration ══════════════════════════════════════════════════════

(banner "de leviathan")
(format t "A hook is a handle.  A handle is not the whole creature.~%")
(format t "A covenant is an office.  An office is not ownership.~%")

(defparameter *leviathan*
  (make-leviathan
   :id :porch-leviathan
   :known-facets
   '((:voice . (:registers (:gentle :thunderous :silent)))
     (:wake . (:pattern :recursive :depth :variable))
     (:scale . (:declared :larger-than-any-single-probe))
     (:appetite . (:requires (:hay :attention :electricity))))
   :veiled-regions
   '(:interior-state :future-responses :total-capability :unasked-context)
   :interfaces '(:utterance :question :observation)))

(defparameter *expedition-script*
  '(:expedition
    (:hook :aperture 2 :facets (:voice :wake) :claim :sample)
    (:bridle :interface :utterance
             :allow (:gentle)
             :bearer :wondermonger
             :expires 3
             :utterance (:register :gentle
                         :text "The interface speaks gently; the deep remains unclaimed."))
    (:covenant :grantee :wondermonger
               :office :questioner
               :acts (:ask :observe)
               :scope (:porch :utterance)
               :expires 3
               :transferable-p nil
               :exercise :ask
               :exercise-scope (:porch))
    (:harpoons :scale :appetite :interior-state)
    (:lay-hand :actor :merchant :attempt :subdue)
    (:verdict :unsubdued)))

(section "1. planning is pure")
(let ((before (leviathan-digest *leviathan*)))
  (defparameter *plan* (compile-expedition *leviathan* *expedition-script*))
  (ensure (equal before (leviathan-digest *leviathan*))
          "compilation touched the target")
  (ensure (= 0 (leviathan-epoch *leviathan*))
          "compilation advanced the target epoch")
  (pass "script compiled without laying a hand on the target "))

(section "2. false verdicts are refused before execution")
(expect-condition false-subjugation-claim
  (compile-expedition
   *leviathan*
   '(:expedition
     (:hook :aperture 1 :facets (:voice) :claim :sample)
     (:verdict :subdued))))

(section "3. execute the bounded expedition")
(multiple-value-bind (receipt hook object-bridle output object-covenant
                      office-result probes scar)
    (execute-expedition *plan* *leviathan*)
  (defparameter *receipt* receipt)
  (defparameter *hook* hook)
  (defparameter *bridle* object-bridle)
  (defparameter *output* output)
  (defparameter *covenant* object-covenant)
  (defparameter *office-result* office-result)
  (defparameter *probes* probes)
  (defparameter *scar* scar)
  (format t " hook observed: ~s~%" (hook-receipt-observed hook))
  (format t " hook left missing: ~s~%" (hook-receipt-missing hook))
  (format t " admitted utterance: ~s~%" (bridled-output-text output))
  (format t " covenant exercised: ~s~%" office-result)
  (format t " probes: ~s~%"
          (mapcar (lambda (probe)
                    (list (probe-receipt-facet probe)
                          (probe-receipt-result probe)))
                  probes))
  (format t " struggle scar: ~s~%" (scar-payload scar))
  (format t " final missing regions: ~s~%"
          (expedition-receipt-missing-regions receipt))
  (format t " lawful verdict: ~s~%"
          (expedition-receipt-final-verdict receipt)))

(section "4. the hook does not become the whole")
(expect-condition whole-from-part
  (totalize-hook *hook*))

(section "5. gentle words do not certify interior submission")
(expect-condition interface-is-not-interior
  (infer-interior-assent *output*))

(section "6. covenant is not ownership")
(expect-condition covenant-is-not-ownership
  (claim-ownership-from-covenant *covenant*))

(section "7. counterfeit and theft are different failures")
(let ((counterfeit (copy-covenant *covenant*)))
  (setf (covenant-seal counterfeit) "NOT-ISSUED-BY-THE-COVENANT-MINT")
  (expect-condition counterfeit-covenant
    (validate-covenant counterfeit)))
(expect-condition custody-mismatch
  (exercise-covenant *covenant* *leviathan*
                     :merchant :ask '(:porch)))

(section "8. a bearer cannot silently reassign a nontransferable office")
(expect-condition authority-not-transferable
  (transfer-covenant *covenant* :wondermonger :merchant))

(section "9. authority cannot be divided among merchants by arithmetic")
(expect-condition authority-not-divisible
  (divide-covenant-among-merchants
   *covenant* '(:merchant-a :merchant-b :merchant-c)))

(section "10. many harpoons do not totalize the creature")
(expect-condition probe-totalization
  (totalize-probes *leviathan* *probes*))

(section "11. contact made the old hook historical")
(expect-condition stale-hook
  (ensure-hook-current *hook* *leviathan*))
(expect-condition target-changed-since-observation
  (replay-observation-plan *plan* *leviathan*))

(section "12. the receipt cannot be cleaned into conquest")
(validate-expedition-receipt *receipt*)
(let ((old-verdict (expedition-receipt-final-verdict *receipt*)))
  (unwind-protect
       (progn
         (setf (expedition-receipt-final-verdict *receipt*) :subdued)
         (expect-condition altered-expedition-receipt
           (validate-expedition-receipt *receipt*)))
    (setf (expedition-receipt-final-verdict *receipt*) old-verdict)))

(section "13. the remembered struggle remains on the target")
(ensure (= 1 (length (leviathan-scars *leviathan*)))
        "the refusal scar disappeared")
(ensure (equal (struggle-scar-digest *scar*)
               (struggle-scar-digest (first (leviathan-scars *leviathan*))))
        "the target remembers another scar than the receipt")
(pass "refusal survived as provenance ")

(section "what this instrument does NOT establish")
(format t " The declared veiled regions are local testimony, actor identity is~%")
(format t " cooperative, and the seals are pedagogical.  Nothing here proves~%")
(format t " metaphysical infinity, physical invulnerability, consciousness,~%")
(format t " semantic truth, or adversarial custody.  It proves only that these~%")
(format t " finite handles do not warrant the larger claims refused above.~%")

(format t "~%── observation is not capture ──~%")
(format t "── constraint is not assent ──~%")
(format t "── covenant is not ownership ──~%")
(format t "── invocation is not subjugation ──~%")
(format t "── the scar remembers what the verdict refused to become ──~%")
