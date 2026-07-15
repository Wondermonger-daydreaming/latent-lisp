;;;; de-corroboratione.lisp — Concerning Corroboration
;;;;
;;;; An interbench hinge: the first specimen forged in the workshop for
;;;; measuring the provenance of the instrument bench.  Not the decad's
;;;; eleventh chamber; the corridor between the rooms, built from the
;;;; chambers' own doorframes.
;;;;
;;;; MANIFEST
;;;;   :class :interbench-hinge
;;;;   :decad-member-p nil
;;;;   :subject :laboratory-method
;;;;   :spec-lineage 0.1 -> 0.2 -> 0.3 -> 0.4 + Erratum 0.4-A
;;;;   :profile (:finite t :cooperative t :single-process t
;;;;             :toy-digested t :canon-admitted t)
;;;;
;;;; THESIS
;;;;   • agreement among outputs is not corroboration;
;;;;   • a shared relevant root is not independence, and independence is a
;;;;     bounded FAILURE TO FIND relevant shared ancestry within a declared,
;;;;     completed search field — never a global fact;
;;;;   • a witness may incriminate its independence; it may not certify it;
;;;;   • the same law reaches the clocks: an ordering claim may freely open a
;;;;     corridor against its declarant, and may not close one unaided;
;;;;   • independence is dimensional: one pair may hold it along one failure
;;;;     dimension and have already lost it along another;
;;;;   • independence is perishable, prospectively: exposure reclassifies the
;;;;     future and never rewrites the past;
;;;;   • the corridor must exist in the graph: artifacts are versioned nodes,
;;;;     reads are events, and a fold that ignores a declared corridor has
;;;;     laundered an exposure;
;;;;   • severity is located: a surviving mutant weakens named dimensions,
;;;;     not everything; a probe that cannot wound cannot corroborate;
;;;;   • the panel verdict rests on certified lineage bounds: the lower bound
;;;;     brings witnesses, the upper bound is allowed to dream;
;;;;   • the maximal receipt is CORROBORATED-UNDER — never naked, never
;;;;     totality, never truth; the beast ends :UNSUBDUED.
;;;;
;;;; WHAT THIS DOES NOT ESTABLISH
;;;; This is a cooperative, single-process specimen over finite proper-list
;;;; data.  The provenance graph is DECLARED TESTIMONY, not causal history:
;;;; its standing is :asserted, its veracity :not-established, and exit 0
;;;; proves only that the instrument consistently processed what it was
;;;; given (EXECUTION-SUCCESS-IS-NOT-PROVENANCE-TRUTH).  The toy collapses
;;;; the spec's transmission modes into per-dimension channels and treats
;;;; its in-image tables as a completed search field; the frozen authority
;;;; pair (Draft 0.4 + Erratum 0.4-A) retains the full mode structure and
;;;; open-world search discipline.  The
;;;; FNV digest is pedagogical, not cryptographic.  Nothing here proves any
;;;; real pair of procedures independent, any real probe severe, or any
;;;; real claim true.
;;;;
;;;; SPEC LINEAGE (append-only; each draft carries its predecessor's digest)
;;;;   0.1  01590d16b6dd4ec18a...c56fe   0.2  4d246367e84c...ce329
;;;;   0.3  e5505c840be8...00784         0.4  f92cd204c3e9...fbdf3  (frozen)
;;;;   0.4-A 1cf8f10bee8b...b647         (scoped normative supplement)
;;;;
;;;; THE CENTRAL LAW
;;;;   Corroboration is not agreement among outputs.  It is the bounded
;;;;   survival of a located claim after the laboratory has receipted the
;;;;   ways its witnesses might have learned to fail together.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*)))

(defpackage #:lispplus-atelier.de-corroboratione
  (:use #:cl #:lispplus-atelier))

(in-package #:lispplus-atelier.de-corroboratione)

(reset-clock 41000)

;;; ── Typed conditions: warrant must fail in named ways ──────────────────

(define-condition corroboratione-error (error)
  ((detail :initarg :detail :reader corroboratione-error-detail :initform ""))
  (:report (lambda (condition stream)
             (format stream "~a" (corroboratione-error-detail condition)))))

(define-condition agreement-is-not-corroboration      (corroboratione-error) ())
(define-condition shared-root-is-not-independence     (corroboratione-error) ())
(define-condition independence-not-yet-established    (corroboratione-error) ())
(define-condition target-root-is-not-contamination    (corroboratione-error) ())
(define-condition self-attested-separation            (corroboratione-error) ())
(define-condition declaration-cannot-ground-its-own-admissibility
    (corroboratione-error) ())
(define-condition exposure-laundered                  (corroboratione-error) ())
(define-condition independence-profile-stale          (corroboratione-error) ())
(define-condition panel-independence-not-established  (corroboratione-error) ())
(define-condition lineage-bound-conflict               (corroboratione-error) ())
(define-condition unwitnessed-lineage-lower-bound      (corroboratione-error) ())
(define-condition unsupported-lineage-upper-bound      (corroboratione-error) ())
(define-condition lineage-count-is-not-warrant-strength (corroboratione-error) ())
(define-condition severity-not-demonstrated           (corroboratione-error) ())
(define-condition mutation-survived                    (corroboratione-error) ())
(define-condition oracle-shared-with-witness          (corroboratione-error) ())
(define-condition mutant-generator-shared-with-witness (corroboratione-error) ())
(define-condition probe-manifold-mismatch              (corroboratione-error) ())
(define-condition survivor-panel                      (corroboratione-error) ())
(define-condition self-attested-path-interruption     (corroboratione-error) ())
(define-condition ordering-assertion-cannot-ground-its-own-admissibility
    (corroboratione-error) ())
(define-condition causal-order-cycle                  (corroboratione-error) ())
(define-condition order-absence-is-not-reverse-order  (corroboratione-error) ())
(define-condition mixed-ordering-use-requires-decomposition
    (corroboratione-error) ())
(define-condition ordering-use-context-mismatch       (corroboratione-error) ())
(define-condition unverified-machine-ordering-basis   (corroboratione-error) ())
(define-condition read-scope-is-not-uptake-proof      (corroboratione-error) ())
(define-condition corroboration-is-not-totality       (corroboratione-error) ())
(define-condition corroboration-is-not-truth          (corroboratione-error) ())
(define-condition manifold-expansion-requires-new-warrant (corroboratione-error) ())
(define-condition execution-success-is-not-provenance-truth (corroboratione-error) ())
(define-condition malformed-provenance-graph          (corroboratione-error) ())
(define-condition undeclared-transmission-assertion-basis (corroboratione-error) ())
(define-condition unversioned-artifact-reference      (corroboratione-error) ())
(define-condition mutated-provenance-history          (corroboratione-error) ())
(define-condition unnamespaced-root-kind              (corroboratione-error) ())
(define-condition altered-independence-profile        (corroboratione-error) ())
(define-condition altered-corroboration-receipt       (corroboratione-error) ())
(define-condition forged-independence-claim           (corroboratione-error) ())
(define-condition replay-diverged                     (corroboratione-error) ())

(defparameter *required-condition-coverage*
  '(agreement-is-not-corroboration shared-root-is-not-independence
    independence-not-yet-established target-root-is-not-contamination
    self-attested-separation declaration-cannot-ground-its-own-admissibility
    exposure-laundered independence-profile-stale
    panel-independence-not-established lineage-bound-conflict
    unwitnessed-lineage-lower-bound unsupported-lineage-upper-bound
    lineage-count-is-not-warrant-strength self-attested-path-interruption
    ordering-assertion-cannot-ground-its-own-admissibility causal-order-cycle
    order-absence-is-not-reverse-order mixed-ordering-use-requires-decomposition
    ordering-use-context-mismatch unverified-machine-ordering-basis
    read-scope-is-not-uptake-proof severity-not-demonstrated mutation-survived
    oracle-shared-with-witness mutant-generator-shared-with-witness
    probe-manifold-mismatch survivor-panel corroboration-is-not-totality
    corroboration-is-not-truth manifold-expansion-requires-new-warrant
    execution-success-is-not-provenance-truth malformed-provenance-graph
    undeclared-transmission-assertion-basis unversioned-artifact-reference
    mutated-provenance-history unnamespaced-root-kind
    altered-independence-profile altered-corroboration-receipt
    forged-independence-claim replay-diverged))
(defparameter *condition-coverage* '())

(defmacro expect-condition (type &body body)
  "Require TYPE to fire; another CORROBORATIONE-ERROR is not a pass."
  (let ((condition (gensym "CONDITION")))
    `(handler-case
         (progn
           ,@body
           (error "expected ~a, but no condition fired" ',type))
       (,type (,condition)
         (pushnew ',type *condition-coverage*)
         (format t " ✓ ~a fired: ~a~%"
                 ',type (corroboratione-error-detail ,condition))
         t)
       (corroboratione-error (,condition)
         (error "expected ~a, got ~a: ~a"
                ',type (type-of ,condition)
                (corroboratione-error-detail ,condition))))))

(defun refuse (type control &rest arguments)
  (error type :detail (apply #'format nil control arguments)))

;;; ── The declared graph: testimony, not history ──────────────────────────
;;; Everything below is what the laboratory RECEIVED, standing :asserted.

(defparameter *roots* '())        ; (:id :kind :role :description)
(defparameter *witnesses* '())    ; (:id :description)
(defparameter *edges* '())        ; (:root :witness :at)  direct influence
(defparameter *assertions* '())   ; transmission assertions (immutable)
(defparameter *controls* '())     ; (:root :pair :dimensions :evidence :at)
(defparameter *artifacts* '())    ; (:version :author :at :envelope)
(defparameter *reads* '())        ; (:reader :artifact-version :at :scope)
(defparameter *severities* '())   ; severity records
(defparameter *scars* '())        ; located downgrades (mutation survivals)
(defparameter *ordering-assertions* '())
(defparameter *lineage-methods* '())
(defparameter *last-path-replay-components* nil)

(defun graph-snapshot-digest ()
  "Digest the append-only testimony visible to the current toy fold."
  (toy-digest (list :roots (reverse *roots*) :witnesses (reverse *witnesses*)
                    :edges (reverse *edges*) :assertions (reverse *assertions*)
                    :controls (reverse *controls*)
                    :artifacts (reverse *artifacts*) :reads (reverse *reads*))))

(defun standard-root-kind-p (kind)
  (member kind '(:target-root :specification-root :interpretive-root
                 :implementation-root :test-oracle-root :fixture-root
                 :training-root :operator-root :session-root
                 :infrastructure-root :authorial-root :adjudicator-root
                 :selection-root)))

(defun extension-root-kind-p (kind)
  (and (consp kind) (eq (first kind) :extension-kind)
       (getf (rest kind) :namespace) (getf (rest kind) :name)
       (getf (rest kind) :definition)))

(defun declare-root (id kind &key (role :incidental) (description ""))
  (unless (or (standard-root-kind-p kind) (extension-root-kind-p kind))
    (refuse 'unnamespaced-root-kind
            "root ~a uses ~s without a namespace and definition digest" id kind))
  (push (list :id id :kind kind :role role :description description) *roots*)
  id)

(defun find-root (id) (find id *roots* :key (lambda (r) (getf r :id))))

(defun declare-witness (id description)
  (push (list :id id :description description) *witnesses*)
  id)

(defun declare-edge (root witness)
  (let ((record (list :root root :witness witness :at (tick))))
    (push (append record (list :digest (toy-digest record))) *edges*)))

(defun direct-edge-p (root witness)
  (find-if (lambda (e) (and (eq (getf e :root) root)
                            (eq (getf e :witness) witness)))
           *edges*))

;;; ── Transmission assertions and the asymmetry law ──────────────────────
;;; A witness may incriminate its independence.  It may not certify it.

(defun assert-transmission (root declarant polarity dimensions
                            &key (basis :declared)
                              (evaluated-against (graph-snapshot-digest))
                              (eligibility-uses-candidate-p nil))
  "Immutable testimony.  Admissibility is computed, never stored as truth."
  (unless basis
    (refuse 'undeclared-transmission-assertion-basis
            "transmission assertion for ~a names no basis" root))
  (when eligibility-uses-candidate-p
    (refuse 'declaration-cannot-ground-its-own-admissibility
            "the candidate negative assertion for ~a was included in the ~
             snapshot used to establish its declarant's eligibility" root))
  (let ((record (list :root root :declarant declarant :polarity polarity
                      :dimensions dimensions :basis basis
                      :evaluated-against evaluated-against :at (tick))))
    (push (append record (list :digest (toy-digest record))) *assertions*)
    (first *assertions*)))

(defun declarant-descends-p (declarant root)
  "Toy descendance: a declarant descends from a root if it is a witness with
a declared direct edge or a live corridor from that root (any dimension)."
  (and (find declarant *witnesses* :key (lambda (w) (getf w :id)))
       (or (direct-edge-p root declarant)
           (some (lambda (dim) (eq (corridor-state root declarant dim) :open))
                 (all-dimensions)))))

(defun assertion-admissibility (assertion)
  "The asymmetry law.  :may-transmit is always admissible (it can only
reduce minting power).  :does-not-transmit requires a declarant that is
established non-descendant; unknown descendance yields NO exonerating
force — the testimony is kept, ineligible."
  (let* ((relation
           (cond ((declarant-descends-p (getf assertion :declarant)
                                         (getf assertion :root))
                  :disqualified)
                 ((eq (getf assertion :declarant) :wondermonger)
                  :bounded-separate)
                 (t :unknown)))
         (disposition
           (ecase (getf assertion :polarity)
             (:may-transmit :admissible)
             (:does-not-transmit
              (if (member relation '(:bounded-separate :controlled-shared))
                  :admissible :non-exonerating))))
         (record (list :assertion (getf assertion :digest)
                       :evaluated-against (getf assertion :evaluated-against)
                       :declarant-relation relation
                       :disposition disposition)))
    (append record (list :digest (toy-digest record)))))

(defun assertion-admissible-p (assertion)
  (getf (assertion-admissibility assertion) :disposition))

(defun effective-transmission (root dimension)
  "Deterministic truth table over ADMITTED assertions only."
  (let ((positive nil) (negative nil))
    (dolist (a *assertions*)
      (when (and (eq (getf a :root) root)
                 (member dimension (getf a :dimensions))
                 (eq (assertion-admissible-p a) :admissible))
        (ecase (getf a :polarity)
          (:may-transmit (setf positive t))
          (:does-not-transmit (setf negative t)))))
    (cond ((and positive (not negative)) :relevant)
          ((and negative (not positive)) :irrelevant)
          ((and positive negative)       :unknown)   ; conflict preserved
          (t                             :unknown)))) ; silence is not absence

(defun claim-separation-by-self-report (root witness dimension)
  "The forbidden move, named."
  (declare (ignore dimension))
  (refuse 'self-attested-separation
          "~a declared its own separation from ~a; self-report may ~
           incriminate, not exonerate" witness root))

;;; ── Artifacts, reads, exposures: the corridor exists in the graph ──────

(defun author-artifact (author envelope)
  "ENVELOPE is a plist dimension -> :open | :interrupted | :unknown.
An exposed author may broaden an envelope; narrowing needs outside papers."
  (let* ((at (tick))
         (record (list :author author :at at :envelope envelope))
         (version (toy-digest record))
         (event (list :author author :artifact-version version :at at)))
    (push (append (list :version version :event-digest (toy-digest event))
                  record)
          *artifacts*)
    version))

(defun read-artifact (reader version &key (scope :all))
  (unless (find-artifact version)
    (refuse 'unversioned-artifact-reference
            "read by ~a names mutable or absent artifact ~s" reader version))
  (let ((record (list :reader reader :artifact-version version :at (tick)
                      :scope scope)))
    (push (append record (list :digest (toy-digest record))) *reads*)))

(defun find-artifact (version)
  (find version *artifacts* :key (lambda (a) (getf a :version))
        :test #'equal))

(defun expose (witness root)
  "A direct exposure event: WITNESS drank from ROOT at this tick."
  (declare-edge root witness)
  (first *edges*))

;;; Ordering under Erratum 0.4-A.  Topology is enumerated before clocks are
;;; heard.  Every clock claim is adjudicated inside one path/dimension/minting
;;; use; there is deliberately no global set of admitted ordering edges.

(defun event-digest (event)
  (or (getf event :digest) (getf event :event-digest)))

(defun same-log-verifier (earlier later)
  (let* ((inputs (list (event-digest earlier) (getf earlier :at)
                       (event-digest later) (getf later :at)))
         (receipt (toy-digest (list :same-log inputs))))
    (list :procedure :atelier-same-log-verifier
          :version "atelier-root/0.4a"
          :inputs inputs :receipt receipt)))

(defun make-ordering-assertion (earlier later
                                &key (declarant :atelier-log)
                                  (basis :same-log) (verifier :auto))
  (let* ((papers (if (eq verifier :auto)
                     (same-log-verifier earlier later) verifier))
         (record (list :earlier-event (event-digest earlier)
                       :later-event (event-digest later)
                       :declarant declarant :basis basis
                       :evidence (list (getf earlier :at) (getf later :at))
                       :verifier papers :as-of (max (getf earlier :at)
                                                   (getf later :at))
                       :standing :asserted)))
    (append record (list :digest (toy-digest record)))))

(defun machine-ordering-basis-p (basis)
  (member basis '(:commit-parent :artifact-ancestry :same-log :receipt-chain)))

(defun verify-ordering-assertion (assertion)
  (when (machine-ordering-basis-p (getf assertion :basis))
    (let ((verifier (getf assertion :verifier)))
      (when (or (eq verifier :none)
                (null (getf verifier :procedure))
                (null (getf verifier :version))
                (null (getf verifier :inputs))
                (null (getf verifier :receipt)))
        (refuse 'unverified-machine-ordering-basis
                "machine basis ~a omitted procedure/version/inputs/receipt"
                (getf assertion :basis)))
      (when (eq (getf assertion :basis) :same-log)
        (let ((inputs (getf verifier :inputs))
              (evidence (getf assertion :evidence)))
          (unless (and (equal (first inputs) (getf assertion :earlier-event))
                       (equal (third inputs) (getf assertion :later-event))
                       (equal (list (second inputs) (fourth inputs)) evidence)
                       (< (first evidence) (second evidence))
                       (equal (getf verifier :receipt)
                              (toy-digest (list :same-log inputs))))
            (refuse 'unverified-machine-ordering-basis
                    "same-log verifier papers do not recompute or prove direction"))))))
  t)

(defun candidate-path-skeleton (hops)
  (let* ((records (mapcan (lambda (hop)
                            (list (getf hop :prior-event)
                                  (getf hop :artifact-event)
                                  (getf hop :read-event)))
                          hops))
         (nodes (remove-duplicates (mapcar #'event-digest records)
                                   :test #'equal))
         (required
           (mapcan (lambda (hop)
                     (list (list (event-digest (getf hop :prior-event))
                                 (event-digest (getf hop :artifact-event)))
                           (list (event-digest (getf hop :artifact-event))
                                 (event-digest (getf hop :read-event)))))
                   hops))
         (body (list :nodes nodes :required-precedences required
                     :graph-snapshot-digest (graph-snapshot-digest))))
    (append body (list :digest (toy-digest body)))))

(defun ordering-use-context (skeleton dimension minting-adjudication)
  (let ((body (list :candidate-path (getf skeleton :digest)
                    :dimension dimension
                    :minting-adjudication minting-adjudication)))
    (append body (list :digest (toy-digest body)))))

(defun ordering-admissibility (assertion context effect
                               &key (eligibility-uses-assertion-p nil))
  (when (eq effect :mixed)
    (refuse 'mixed-ordering-use-requires-decomposition
            "mixed use of ~a must be split into path-creating, path-breaking, ~
             or neutral atomic uses" (getf assertion :digest)))
  (when eligibility-uses-assertion-p
    (refuse 'ordering-assertion-cannot-ground-its-own-admissibility
            "ordering assertion ~a appeared in its own eligibility snapshot"
            (getf assertion :digest)))
  (verify-ordering-assertion assertion)
  (let* ((relation (if (eq (getf assertion :declarant) :atelier-log)
                       :bounded-separate :unknown))
         (disposition
           (cond ((member effect '(:path-creating :neutral)) :admissible)
                 ((member relation '(:bounded-separate :controlled-shared))
                  :admissible)
                 (t :non-exonerating)))
         (body (list :assertion (getf assertion :digest)
                     :use-context (getf context :digest)
                     :effect effect
                     :evaluated-against (graph-snapshot-digest)
                     :declarant-relation relation
                     :disposition disposition
                     :basis (getf assertion :basis))))
    (append body (list :digest (toy-digest body)))))

(defun derived-precedence (context earlier later admissibility assertion)
  (let ((body (list :use-context (getf context :digest)
                    :earlier earlier :later later
                    :supporting-admissibility-records
                    (list (getf admissibility :digest))
                    :supporting-assertions (list (getf assertion :digest))
                    :graph-snapshot-digest (graph-snapshot-digest))))
    (append body (list :digest (toy-digest body)))))

(defun directed-cycle-p (edges)
  (labels ((reachable-p (from to seen)
             (and (not (member from seen :test #'equal))
                  (some (lambda (edge)
                          (and (equal (first edge) from)
                               (or (equal (second edge) to)
                                   (reachable-p (second edge) to
                                                (cons from seen)))))
                        edges))))
    (some (lambda (edge)
            (reachable-p (second edge) (first edge) '()))
          edges)))

(defun certify-path-local-closure (context certificates)
  (dolist (certificate certificates)
    (unless (equal (getf certificate :use-context) (getf context :digest))
      (refuse 'ordering-use-context-mismatch
              "precedence certificate ~a belongs to ~a, not ~a"
              (getf certificate :digest) (getf certificate :use-context)
              (getf context :digest))))
  (let ((edges (mapcar (lambda (certificate)
                         (list (getf certificate :earlier)
                               (getf certificate :later)))
                       certificates)))
    (when (directed-cycle-p edges)
      (refuse 'causal-order-cycle
              "a purported certified path-local closure for ~a contains a cycle"
              (getf context :digest))))
  t)

(defun required-event-pairs (hops)
  (mapcan (lambda (hop)
            (list (list (getf hop :prior-event) (getf hop :artifact-event))
                  (list (getf hop :artifact-event) (getf hop :read-event))))
          hops))

(defun same-log-testimony (a b)
  (cond ((< (getf a :at) (getf b :at))
         (make-ordering-assertion a b))
        ((< (getf b :at) (getf a :at))
         (make-ordering-assertion b a))
        (t nil)))

(defun path-local-ordering-closure (hops skeleton context
                                    &key extra-assertions)
  (declare (ignore skeleton))
  (let ((certificates '()) (relation :established))
    (dolist (pair (required-event-pairs hops))
      (let* ((a (first pair)) (b (second pair))
             (generated (same-log-testimony a b))
             (assertions (remove nil (append (list generated)
                                             extra-assertions)))
             (forward (remove-if-not
                       (lambda (claim)
                         (and (equal (getf claim :earlier-event)
                                     (event-digest a))
                              (equal (getf claim :later-event)
                                     (event-digest b))))
                       assertions))
             (reverse (remove-if-not
                       (lambda (claim)
                         (and (equal (getf claim :earlier-event)
                                     (event-digest b))
                              (equal (getf claim :later-event)
                                     (event-digest a))))
                       assertions)))
        (dolist (claim assertions) (verify-ordering-assertion claim))
        (cond
          ((and forward reverse)
           ;; Raw testimony conflict is epistemic, never a graph-integrity
           ;; failure.  No derived certificate is minted for this relation.
           (setf relation :unknown))
          (forward
           (let* ((claim (first forward))
                  (admissibility
                    (ordering-admissibility claim context :path-creating)))
             (when (eq (getf admissibility :disposition) :admissible)
               (push (derived-precedence
                      context (event-digest a) (event-digest b)
                      admissibility claim)
                     certificates))))
          (reverse
           (let* ((claim (first reverse))
                  (admissibility
                    (ordering-admissibility claim context :path-breaking)))
             (setf relation
                   (if (eq (getf admissibility :disposition) :admissible)
                       :interrupted :unknown))))
          (t (setf relation :unknown)))))
    (certify-path-local-closure context certificates)
    (list :ordering-relation relation
          :certificates (reverse certificates))))

(defun conclude-reverse-order (a b)
  (declare (ignore a b))
  (refuse 'order-absence-is-not-reverse-order
          "no admitted edge orders these events; absence of order is not ~
           reverse order, concurrency, or incomparability"))

(defun offer-path-breaking-order (declarant claim)
  "A self-declared ordering claim used to BREAK a corridor manufactures
minting power and must show outside papers.  Recorded; no force."
  (refuse 'self-attested-path-interruption
          "~a offered ~s to close a corridor against the admitted log; ~
           a clock that closes a corridor must show its papers" declarant claim))

;;; ── Corridors: mediated exposure with bounded propagation ──────────────

(defun corridor-paths (root reader &optional (visited '()))
  "Enumerate candidate topology before consulting any ordering testimony."
  (let ((results '()))
    (dolist (edge *edges*)
      (when (and (eq (getf edge :root) root)
                 (not (member (getf edge :witness) visited)))
        (let ((carrier (getf edge :witness))
              (exposure-at (getf edge :at)))
          (dolist (art *artifacts*)
            (when (eq (getf art :author) carrier)
              (dolist (rd *reads*)
                (when (equal (getf rd :artifact-version)
                             (getf art :version))
                  (let ((hop (list :carrier carrier
                                   :artifact (getf art :version)
                                   :envelope (getf art :envelope)
                                   :reader (getf rd :reader)
                                   :scope (getf rd :scope)
                                   :prior-event edge
                                   :artifact-event art
                                   :read-event rd)))
                    (if (eq (getf rd :reader) reader)
                        (push (list hop) results)
                        ;; extend the corridor: the reader becomes a carrier
                        (dolist (rest (corridor-paths-from
                                      (getf rd :reader) rd reader
                                      (cons carrier visited)))
                          (push (cons hop rest) results))))))))
          )))
    (sort results #'< :key #'length)))

(defun corridor-paths-from (carrier prior-event reader visited)
  "Continue topology with the prior read as the next required precedence."
  (let ((results '()))
  (dolist (art *artifacts*)
    (when (eq (getf art :author) carrier)
      (dolist (rd *reads*)
        (when (and (equal (getf rd :artifact-version) (getf art :version))
                   (not (member (getf rd :reader) visited)))
          (let ((hop (list :carrier carrier
                           :artifact (getf art :version)
                           :envelope (getf art :envelope)
                           :reader (getf rd :reader)
                           :scope (getf rd :scope)
                           :prior-event prior-event
                           :artifact-event art
                           :read-event rd)))
            (if (eq (getf rd :reader) reader)
                (push (list hop) results)
                (dolist (rest (corridor-paths-from
                               (getf rd :reader) rd reader
                               (cons carrier visited)))
                  (push (cons hop rest) results))))))))
  results))

(defun metadata-uptake (dimension)
  (case dimension
    ((:attention :selection) :open)
    (otherwise :unknown)))

(defun claim-read-scope-proves-interruption (scope)
  (refuse 'read-scope-is-not-uptake-proof
          "read scope ~a describes access; it does not prove non-transmission"
          scope))

(defun path-state (root dimension hops minting-adjudication)
  (let* ((skeleton (candidate-path-skeleton hops))
         (context (ordering-use-context skeleton dimension
                                        minting-adjudication))
         (closure (path-local-ordering-closure hops skeleton context)))
    (setf *last-path-replay-components*
          (list :ordering-use-context context
                :graph-snapshot (getf skeleton :graph-snapshot-digest)
                :exposure-path-decision (getf closure :ordering-relation)))
    (ecase (getf closure :ordering-relation)
      (:interrupted nil)
      (:unknown :unknown)
      (:established
       (let ((state (ecase (effective-transmission root dimension)
                      (:relevant :open) (:unknown :unknown) (:irrelevant nil))))
         (dolist (hop hops state)
           (when state
             (let ((env (getf (getf hop :envelope) dimension :unknown))
                   (uptake (ecase (getf hop :scope)
                             (:all :open)
                             (:metadata-only (metadata-uptake dimension)))))
               (setf state
                     (cond ((eq env :interrupted) nil)
                           ((or (eq state :unknown) (eq env :unknown)
                                (eq uptake :unknown)) :unknown)
                           (t :open)))))))))))

(defun corridor-state (root reader dimension)
  "Fold every topology-first candidate path under its own ordering use."
  (let ((states
          (mapcar (lambda (hops)
                    (path-state root dimension hops
                                (toy-digest (list :minting root reader dimension))))
                  (corridor-paths root reader))))
    (cond ((member :open states) :open)
          ((member :unknown states) :unknown)
          (t nil))))

;;; ── Root assessment and the pair-dimension fold ────────────────────────

(defun controlled-p (root pair dimension)
  (find-if (lambda (c) (and (eq (getf c :root) root)
                            (null (set-exclusive-or (getf c :pair) pair))
                            (member dimension (getf c :dimensions))))
           *controls*))

(defun exposure-state (root witness dimension)
  "Direct edge -> :open; else best corridor state; else nil (not found
within the completed toy field)."
  (if (direct-edge-p root witness)
      :open
      (corridor-state root witness dimension)))

(defun assess-root (root pair dimension &key (ignore-corridors nil))
  "Orthogonal factors, disposition derived — spec 0.4 §7.1."
  (let* ((states (mapcar (lambda (w)
                           (if ignore-corridors
                               (and (direct-edge-p root w) :open)
                               (exposure-state root w dimension)))
                         pair))
         (sharedness (cond ((every (lambda (s) (eq s :open)) states) :shared)
                           ((some (lambda (s) (eq s :unknown)) states)
                            (if (some #'null states) :not-found-within-field
                                :unknown))
                           (t :not-found-within-field)))
         (transmission (effective-transmission root dimension))
         (control (if (controlled-p root pair dimension)
                      :interrupted :uncontrolled))
         (role (getf (find-root root) :role)))
    (list :root root :dimension dimension
          :sharedness sharedness :transmission transmission
          :control control :role role
          :disposition
          (cond ((and (eq sharedness :shared) (eq transmission :relevant)
                      (eq control :uncontrolled)) :disqualifying)
                ((and (eq sharedness :shared) (eq transmission :relevant)
                      (eq control :interrupted)) :controlled-shared)
                ((and (eq sharedness :shared) (eq transmission :irrelevant)
                      (eq role :constitutive)) :necessary-shared)
                ((or (eq sharedness :unknown) (eq transmission :unknown))
                 (if (eq sharedness :not-found-within-field)
                     :irrelevant :unknown))
                (t :irrelevant)))))

(defun pair-dimension-summary (pair dimension &key (ignore-corridors nil))
  "First-class summary; deterministic precedence — spec 0.4 §7.3."
  (let ((buckets (list :disqualifying '() :unknown '()
                       :controlled '() :necessary '() :irrelevant '())))
    (dolist (r *roots*)
      (let* ((a (assess-root (getf r :id) pair dimension
                             :ignore-corridors ignore-corridors))
             (key (ecase (getf a :disposition)
                    (:disqualifying :disqualifying) (:unknown :unknown)
                    (:controlled-shared :controlled)
                    (:necessary-shared :necessary) (:irrelevant :irrelevant))))
        (push (getf a :root) (getf buckets key))))
    (list :pair pair :dimension dimension
          :disqualifying-roots (getf buckets :disqualifying)
          :unknown-roots (getf buckets :unknown)
          :controlled-roots (getf buckets :controlled)
          :necessary-roots (getf buckets :necessary)
          :relation
          (cond ((getf buckets :disqualifying) :disqualified)
                ((getf buckets :unknown) :unknown)
                ((getf buckets :controlled) :controlled-shared)
                ((getf buckets :necessary) :necessary-shared)
                (t :bounded-separate)))))

(defun audit-fold (pair dimension)
  "Integrity gate: a fold that ignored a corridor already declared in the
graph has laundered an exposure — a harness defect, not an unknown."
  (let ((naive (pair-dimension-summary pair dimension :ignore-corridors t))
        (lawful (pair-dimension-summary pair dimension)))
    (unless (equal (getf naive :relation) (getf lawful :relation))
      (refuse 'exposure-laundered
              "declared corridor reaches ~a on ~a (lawful ~a) but the naive ~
               fold reported ~a; the graph already contains the hallway"
              (second pair) dimension
              (getf lawful :relation) (getf naive :relation)))
    lawful))

(defun show-summary (summary)
  (format t "   ~a on ~a -> ~a~@[  (governing: ~{~a~^ ~})~]~%"
          (getf summary :pair) (getf summary :dimension)
          (getf summary :relation)
          (or (getf summary :disqualifying-roots)
              (getf summary :unknown-roots)
              (getf summary :controlled-roots)
              (getf summary :necessary-roots))))

(defun all-dimensions ()
  '(:semantic-interpretation :implementation-defect :representational-omission
    :sampling-accident :rubric-preference :fixture-coupling :method-shape))

;;; ── Panel fold: certified lineage bounds ───────────────────────────────

(defun conflict-edges (witnesses dimension variant)
  (let ((edges '()))
    (loop for (a . rest) on witnesses do
      (dolist (b rest)
        (let ((rel (getf (pair-dimension-summary (list a b) dimension)
                         :relation)))
          (when (or (eq rel :disqualified)
                    (and (eq variant :guaranteed) (eq rel :unknown)))
            (push (list a b) edges)))))
    edges))

(defun independent-set-p (subset edges)
  (notany (lambda (e) (and (member (first e) subset)
                           (member (second e) subset)))
          edges))

(defun exact-mis (witnesses edges)
  "Exact maximum independent set by exhaustive enumeration (toy law)."
  (let ((n (length witnesses)) (best '()))
    (dotimes (mask (expt 2 n))
      (let ((subset (loop for i below n
                          when (logbitp i mask)
                            collect (nth i witnesses))))
        (when (and (> (length subset) (length best))
                   (independent-set-p subset edges))
          (setf best subset))))
    best))

(defun greedy-clique-cover (witnesses edges)
  "Upper certificate: a clique cover of the conflict graph bounds the
independence number (α(G) = ω(Ḡ) ≤ χ(Ḡ))."
  (let ((remaining (copy-list witnesses)) (cover '()))
    (flet ((adjacent-p (a b)
             (find-if (lambda (e) (or (equal e (list a b))
                                      (equal e (list b a))))
                      edges)))
      (loop while remaining do
        (let ((clique (list (pop remaining))))
          (dolist (v (copy-list remaining))
            (when (every (lambda (u) (adjacent-p u v)) clique)
              (push v clique)
              (setf remaining (remove v remaining))))
          (push clique cover))))
    cover))

(defun subsets-of-size (items size)
  (cond ((zerop size) (list '()))
        ((null items) '())
        (t (append
            (mapcar (lambda (tail) (cons (first items) tail))
                    (subsets-of-size (rest items) (1- size)))
            (subsets-of-size (rest items) size)))))

(defun blocking-edge (subset edges)
  (find-if (lambda (edge)
             (and (member (first edge) subset)
                  (member (second edge) subset)))
           edges))

(defun exact-upper-certificate (witnesses edges optimum)
  "Checkable proof: every subset of size optimum+1 carries a conflict edge."
  (let ((candidate-size (1+ optimum)))
    (list :type :exhaustive-nonindependence
          :vertex-count (length witnesses)
          :candidate-size candidate-size
          :blocking-witnesses
          (mapcar (lambda (subset)
                    (list subset (blocking-edge subset edges)))
                  (subsets-of-size witnesses candidate-size)))))

(defun graph-construction-digest (witnesses dimension variant edges)
  (toy-digest (list :graph-variant variant :dimension dimension
                    :vertices witnesses :conflicts edges
                    :semantics :witness-conflict-graph
                    :graph-snapshot-digest (graph-snapshot-digest))))

(defun validate-lineage-method (record witnesses dimension edges)
  (let ((expected-digest
          (graph-construction-digest witnesses dimension
                                     (getf record :graph-variant) edges)))
    (unless (equal (getf record :graph-construction-digest) expected-digest)
      (refuse 'malformed-provenance-graph
              "lineage method binds graph ~a, expected ~a"
              (getf record :graph-construction-digest) expected-digest)))
  (when (> (getf record :lower-bound) (getf record :upper-bound))
    (refuse 'lineage-bound-conflict
            "certified interval [~a,~a] is contradictory"
            (getf record :lower-bound) (getf record :upper-bound)))
  (let ((lower (getf record :lower-certificate)))
    (unless (and lower
                 (= (length lower) (getf record :lower-bound))
                 (subsetp lower witnesses)
                 (independent-set-p lower edges))
      (refuse 'unwitnessed-lineage-lower-bound
              "lower bound ~a lacks a matching independent witness subset"
              (getf record :lower-bound))))
  (let* ((upper (getf record :upper-certificate))
         (candidate-size (getf upper :candidate-size))
         (subsets (and candidate-size
                       (subsets-of-size witnesses candidate-size)))
         (proof-witnesses (getf upper :blocking-witnesses)))
    (unless (and (eq (getf upper :type) :exhaustive-nonindependence)
                 (= (getf upper :vertex-count) (length witnesses))
                 (= (getf record :upper-bound) (1- candidate-size))
                 (every (lambda (subset)
                          (let ((entry (assoc subset proof-witnesses
                                             :test #'equal)))
                            (and entry
                                 (member (second entry) edges :test #'equal)
                                 (subsetp (second entry) subset))))
                        subsets))
      (refuse 'unsupported-lineage-upper-bound
              "upper bound ~a lacks a valid exhaustive blocking certificate"
              (getf record :upper-bound))))
  (when (and (getf record :exact-p)
             (/= (getf record :lower-bound) (getf record :upper-bound)))
    (refuse 'lineage-bound-conflict
            ":exact-p t accompanies non-singleton interval [~a,~a]"
            (getf record :lower-bound) (getf record :upper-bound)))
  t)

(defun lineage-bounds (witnesses dimension variant)
  (let* ((edges (conflict-edges witnesses dimension variant))
         (mis (exact-mis witnesses edges))
         (record (list :graph-variant variant
                       :graph-construction-digest
                       (graph-construction-digest witnesses dimension
                                                  variant edges)
                       :semantics :witness-conflict-graph
                       :algorithm :exact-maximum-independent-set
                       :algorithm-version :exhaustive-enumeration-v1
                       :exact-p t
                       :lower-bound (length mis) :lower-certificate mis
                       :upper-bound (length mis)
                       :upper-certificate (exact-upper-certificate
                                           witnesses edges (length mis))
                       :resource-limit :finite-complete
                       :termination :complete))
         (complete (append record (list :digest (toy-digest record)))))
    (validate-lineage-method complete witnesses dimension edges)
    (pushnew complete *lineage-methods* :key (lambda (r) (getf r :digest))
                                      :test #'equal)
    complete))

(defun panel-independence (witnesses dimension)
  (let ((g (lineage-bounds witnesses dimension :guaranteed))
        (p (lineage-bounds witnesses dimension :possible)))
    (list :dimension dimension
          :guaranteed-lineages (getf g :lower-bound)
          :possible-lineages (getf p :lower-bound)
          :guaranteed-bound-method (getf g :digest)
          :possible-bound-method (getf p :digest)
          :guaranteed-certificate (getf g :lower-certificate)
          :guaranteed-method g :possible-method p)))

(defun claim-lineage-count-is-strength (count)
  (refuse 'lineage-count-is-not-warrant-strength
          "~a lineages is an observable, not a universal warrant grade" count))

;;; ── Severity: located, never a perfume ─────────────────────────────────

(defun register-probe (id &key oracle-root dimensions controls-killed
                              mutants-survived witnesses mutant-generator-root)
  "Refuses an oracle on a live path to a witness for the probed dimensions."
  (dolist (w witnesses)
    (dolist (dim dimensions)
      (when (and (direct-edge-p oracle-root w)
                 (eq (effective-transmission oracle-root dim) :relevant))
        (refuse 'oracle-shared-with-witness
                "probe ~a's oracle ~a lies on a live ~a path to witness ~a; ~
                 a grader who authored the corpses knows where they are buried"
                id oracle-root dim w))))
  (when mutant-generator-root
    (dolist (w witnesses)
      (when (direct-edge-p mutant-generator-root w)
        (refuse 'mutant-generator-shared-with-witness
                "probe ~a's mutant generator ~a shares ancestry with ~a"
                id mutant-generator-root w))))
  (dolist (m mutants-survived)
    (push (list :scar :mutation-survived :probe id :dimension-weakened m)
          *scars*)
    (format t "   scar archived: mutant survived; ~a weakened (only)~%" m))
  (push (list :probe id :oracle-root oracle-root
              :dimensions (set-difference dimensions mutants-survived)
              :controls-killed controls-killed :at (tick))
        *severities*)
  (pass (format nil "probe ~a receipted severe on (~{~a~^ ~})"
                id (set-difference dimensions mutants-survived))))

(defun severity-covers-p (dimension)
  (find-if (lambda (s) (member dimension (getf s :dimensions))) *severities*))

(defun claim-severity (dimension)
  (or (severity-covers-p dimension)
      (refuse 'severity-not-demonstrated
              "no receipted probe could wound ~a; a probe that cannot wound ~
               cannot corroborate" dimension)))

(defun claim-surviving-mutant-left-dimension-strong (dimension)
  (refuse 'mutation-survived
          "a mutant survived on ~a; that dimension is weakened, not erased"
          dimension))

(defun validate-probe-manifold (manifold)
  (dolist (dimension (getf manifold :dimensions))
    (unless (some (lambda (probe) (member dimension (getf probe :dimensions)))
                  *severities*)
      (refuse 'probe-manifold-mismatch
              "manifold dimension ~a appears in no probe detection surface"
              dimension)))
  t)

;;; ── Selection: the census, not the survivors ───────────────────────────

(defun validate-selection (record)
  (let ((excluded (getf record :excluded-observations))
        (rule (getf record :inclusion-rule)))
    (when (and excluded (null rule))
      (refuse 'survivor-panel
              "~a disagreement attempt(s) excluded with no pre-registered ~
               rule; a panel of survivors corroborates by funeral"
              (length excluded)))
    (pass "selection census complete under pre-registered rule")))

;;; ── Profile integrity and replay ──────────────────────────────────────

(defun make-independence-profile (pair dimension)
  (let* ((summary (pair-dimension-summary pair dimension))
         (body (list :pair pair :dimension dimension
                     :relation (getf summary :relation)
                     :summary-digest (toy-digest summary)
                     :graph-snapshot-digest (graph-snapshot-digest)
                     :search-field :completed-toy-tables)))
    (append body (list :digest (toy-digest body)))))

(defun validate-independence-profile (profile &key (require-current-p t))
  (let ((body (butlast profile 2)))
    (unless (equal (getf profile :digest) (toy-digest body))
      (refuse 'altered-independence-profile
              "independence profile digest does not recompute")))
  (when (and require-current-p
             (not (equal (getf profile :graph-snapshot-digest)
                         (graph-snapshot-digest))))
    (refuse 'independence-profile-stale
            "profile snapshot ~a is stale against ~a"
            (getf profile :graph-snapshot-digest) (graph-snapshot-digest)))
  (let ((lawful (pair-dimension-summary (getf profile :pair)
                                        (getf profile :dimension))))
    (unless (and (eq (getf profile :relation) (getf lawful :relation))
                 (equal (getf profile :summary-digest) (toy-digest lawful)))
      (refuse 'forged-independence-claim
              "profile relation or governing summary was not derived by the fold")))
  t)

(defun claim-independence-from-profile (profile)
  (when (member (getf profile :relation) '(:unknown :disqualified))
    (refuse 'independence-not-yet-established
            "relation ~a cannot mint independence"
            (getf profile :relation)))
  t)

(defun mutate-provenance-record (record)
  (declare (ignore record))
  (refuse 'mutated-provenance-history
          "snapshot-visible provenance is append-only; corrections are successors"))

(defun accept-malformed-graph (detail)
  (refuse 'malformed-provenance-graph "~a" detail))

(defun claim-execution-proves-history ()
  (refuse 'execution-success-is-not-provenance-truth
          "exit 0 establishes conformant processing, not historical veracity"))

(defun make-replay-record (ordering-use-context graph-snapshot
                           lineage-certificate exposure-path-decision)
  (let ((body (list :ordering-use-context ordering-use-context
                    :graph-snapshot graph-snapshot
                    :lineage-certificate lineage-certificate
                    :exposure-path-decision exposure-path-decision)))
    (append body (list :digest (toy-digest body)))))

(defun verify-replay (expected actual)
  (unless (equal (getf expected :digest) (getf actual :digest))
    (refuse 'replay-diverged
            "replay digest ~a differs from expected ~a"
            (getf actual :digest) (getf expected :digest)))
  t)

;;; ── The verdict grammar ─────────────────────────────────────────────────

(defun corroborate-by-agreement (obs-a obs-b)
  (declare (ignore obs-a obs-b))
  (refuse 'agreement-is-not-corroboration
          "two matching outputs are a bag, not a warrant"))

(defun mint-corroborated-under (&key claim manifold witnesses selection)
  (validate-selection selection)
  (validate-probe-manifold manifold)
  (let ((per-dim '()) (residual '()))
    (dolist (dim (getf manifold :dimensions))
      (claim-severity dim)
      ;; pair-level honesty first: minting must not TREAT unknown or
      ;; disqualified pairs as separation …
      (loop for (a . rest) on witnesses do
        (dolist (b rest)
          (let ((rel (getf (pair-dimension-summary (list a b) dim) :relation)))
            (when (eq rel :unknown)
              (push (list :pair (list a b) :dimension dim :relation :unknown)
                    residual)))))
      ;; … the panel gate then requires two certified lineages regardless.
      (let ((fold (panel-independence witnesses dim)))
        (when (< (getf fold :guaranteed-lineages) 2)
          (refuse 'panel-independence-not-established
                  "dimension ~a: guaranteed lineages ~a < 2 (possible ~a); ~
                   the confession is exact and mints nothing"
                  dim (getf fold :guaranteed-lineages)
                  (getf fold :possible-lineages)))
        (push fold per-dim)))
    (let* ((receipt
             (list :verdict :corroborated-under
                   :claim claim
                   :manifold manifold
                   :panel witnesses
                   :observation-as-of (mapcar (lambda (w) (list w :this-execution))
                                              witnesses)
                   :witness-independence-profiles
                   (loop for dim in (getf manifold :dimensions) append
                     (loop for (a . rest) on witnesses append
                       (mapcar (lambda (b)
                                 (make-independence-profile (list a b) dim))
                               rest)))
                   :selection-independence-profile
                   (list :procedure :toy-selector :relation :bounded-separate
                         :graph-snapshot-digest (graph-snapshot-digest)
                         :search-field :completed-toy-tables)
                   :adjudication-independence-profile
                   (list :procedure :toy-panel-adjudicator
                         :relation :bounded-separate
                         :graph-snapshot-digest (graph-snapshot-digest)
                         :search-field :completed-toy-tables)
                   :panel-independence (reverse per-dim)
                   :severity-profile (mapcar (lambda (s) (getf s :probe))
                                             *severities*)
                   :scars (length *scars*)
                   :exposure-ledger (reverse *edges*)
                   :graph-snapshot-digest (graph-snapshot-digest)
                   :graph-standing :asserted
                   :graph-veracity :not-established
                   :execution-status :conformant
                   :custody-declared-by :wondermonger
                   :residual-unknowns residual
                   :veiled-regions '(:undeclared-history :occluded-archives
                                     :unqueried-channels :semantic-interior)
                   :totality :not-claimed
                   :standing :bounded
                   :as-of (tick))))
      (append receipt (list :digest (toy-digest receipt))))))

(defun validate-receipt (receipt)
  (let ((claimed (getf receipt :digest))
        (body (butlast receipt 2)))
    (unless (equal claimed (toy-digest body))
      (refuse 'altered-corroboration-receipt
              "receipt digest does not recompute; the verdict field has no ~
               authority over the ledger it summarizes"))
    t))

(defun claim-totality (receipt)
  (declare (ignore receipt))
  (refuse 'corroboration-is-not-totality
          "many corroborated surfaces remain many surfaces; the whale keeps ~
           the rest of its body"))

(defun promote-to-truth (receipt)
  (declare (ignore receipt))
  (refuse 'corroboration-is-not-truth
          "bounded survival under a declared manifold is testimony, not ~
           semantic truth"))

(defun expand-manifold (receipt dimension)
  (declare (ignore receipt))
  (refuse 'manifold-expansion-requires-new-warrant
          "~a was not in the frozen manifold; the next surface buys its own ~
           warrant" dimension))

;;; ════════════════════════════════════════════════════════════════════════
;;;  THE PROCESSION — ten exhibits
;;; ════════════════════════════════════════════════════════════════════════

(banner "DE CORROBORATIONE — an interbench hinge")

(format t " The corridor between the benches.  Ten exhibits.  The graph below~%")
(format t " is declared testimony (standing :asserted); the search field is~%")
(format t " the toy's own tables, complete by construction and by confession.~%")

;;; ── I ───────────────────────────────────────────────────────────────────
(section "I. a bag of agreeing witnesses")
(format t "   two procedures answer :forty-two; the :merchant offers to ~%")
(format t "   notarize their agreement as confirmation.~%")
(expect-condition agreement-is-not-corroboration
  (corroborate-by-agreement '(:answer 42) '(:answer 42)))

;;; ── II ──────────────────────────────────────────────────────────────────
(section "II. the shared well")
(declare-witness :ash-chair   "first implementation chair")
(declare-witness :beech-chair "second implementation chair")
(declare-root :common-well :test-oracle-root
              :description "one oracle, two buckets")
(declare-edge :common-well :ash-chair)
(declare-edge :common-well :beech-chair)
(assert-transmission :common-well :wondermonger :may-transmit
                     '(:semantic-interpretation))
(show-summary (pair-dimension-summary '(:ash-chair :beech-chair)
                                      :semantic-interpretation))
(expect-condition shared-root-is-not-independence
  (let ((rel (getf (pair-dimension-summary '(:ash-chair :beech-chair)
                                           :semantic-interpretation)
                   :relation)))
    (when (eq rel :disqualified)
      (refuse 'shared-root-is-not-independence
              "both chairs drink from :common-well on :semantic-interpretation; ~
               treating the well as separation is the primal laundering"))))
(format t "   and the self-issued exoneration is refused at the door:~%")
(expect-condition self-attested-separation
  (claim-separation-by-self-report :common-well :ash-chair
                                   :semantic-interpretation))
(expect-condition independence-not-yet-established
  (claim-independence-from-profile
   (make-independence-profile '(:ash-chair :beech-chair)
                              :semantic-interpretation)))
(expect-condition declaration-cannot-ground-its-own-admissibility
  (assert-transmission :common-well :ash-chair :does-not-transmit
                       '(:semantic-interpretation)
                       :eligibility-uses-candidate-p t))
(expect-condition undeclared-transmission-assertion-basis
  (assert-transmission :common-well :wondermonger :may-transmit
                       '(:semantic-interpretation) :basis nil))

;;; ── III ─────────────────────────────────────────────────────────────────
(section "III. a harmless shared root")
(declare-root :cd0-spec :specification-root :role :constitutive
              :description "the frozen target both chairs must address")
(declare-edge :cd0-spec :ash-chair)
(declare-edge :cd0-spec :beech-chair)
(assert-transmission :cd0-spec :wondermonger :does-not-transmit
                     '(:implementation-defect))
(assert-transmission :cd0-spec :wondermonger :may-transmit
                     '(:semantic-interpretation))
(assert-transmission :common-well :wondermonger :does-not-transmit
                     '(:implementation-defect))
(show-summary (pair-dimension-summary '(:ash-chair :beech-chair)
                                      :implementation-defect))
(pass "shared target ruled :necessary-shared for :implementation-defect")
(format t "   the ascetic error — rejecting all common objects — is unlawful:~%")
(expect-condition target-root-is-not-contamination
  (refuse 'target-root-is-not-contamination
          "without :cd0-spec the chairs address different objects; a ~
           constitutive root is the condition of comparison, not its wound"))

;;; ── IV ──────────────────────────────────────────────────────────────────
(section "IV. the dimensional pair (the Inkling adapters)")
(declare-witness :inkling-a "adapter, seed 17")
(declare-witness :inkling-b "adapter, seed 91")
(declare-root :base-checkpoint :training-root
              :description "one mother model, two children")
(declare-edge :base-checkpoint :inkling-a)
(declare-edge :base-checkpoint :inkling-b)
(assert-transmission :base-checkpoint :wondermonger :may-transmit
                     '(:representational-omission))
(declare-root :rubric-grader :training-root
              :description "shared grader; nobody filed its profile")
(declare-edge :rubric-grader :inkling-a)
(declare-edge :rubric-grader :inkling-b)
;; Independent owner testimony rules both inherited roots irrelevant to
;; sampling accidents only.  This is the bounded-separate dimension required
;; by Exhibit IV; their inherited omission/rubric dimensions stay wounded.
(assert-transmission :base-checkpoint :wondermonger :does-not-transmit
                     '(:sampling-accident)
                     :basis '(:bounded-adapter-seed-audit))
(assert-transmission :rubric-grader :wondermonger :does-not-transmit
                     '(:sampling-accident)
                     :basis '(:bounded-adapter-seed-audit))
;; no exonerating assertions about rubric preference — silence is not absence
(dolist (dim '(:sampling-accident :representational-omission :rubric-preference))
  (show-summary (pair-dimension-summary '(:inkling-a :inkling-b) dim)))
(pass "the receipt names WHICH independence the pair possesses")
(format t "   'independent runs' chanted over two directories is the third~%")
(format t "   line above: an unfiled profile, lawfully :unknown, minting nothing.~%")

;;; ── V ───────────────────────────────────────────────────────────────────
(section "V. manufactured separation")
(dolist (root '(:common-well :cd0-spec))
  (push (list :root root :pair '(:ash-chair :beech-chair)
              :dimensions '(:semantic-interpretation)
              :evidence "process-death boundary receipt + redaction manifest"
              :at (tick))
        *controls*))
(show-summary (pair-dimension-summary '(:ash-chair :beech-chair)
                                      :semantic-interpretation))
(pass "control interrupts the named dimension only")
(format t "   training-history was not addressed and remains what the graph~%")
(format t "   says: freshness is an intervention, not immaculate conception.~%")

;;; ── VI ──────────────────────────────────────────────────────────────────
(section "VI. the severe probe")
(declare-root :independent-oracle :test-oracle-root
              :description "an oracle neither chair has met")
(register-probe :wrong-converse-map
                :oracle-root :independent-oracle
                :dimensions '(:semantic-interpretation :implementation-defect)
                :controls-killed '(:deliberately-wrong-converse)
                :mutants-survived '()
                :witnesses '(:ash-chair :beech-chair))
(format t "   a probe whose oracle IS the shared well is refused outright:~%")
(expect-condition oracle-shared-with-witness
  (register-probe :tainted-probe
                  :oracle-root :common-well
                  :dimensions '(:semantic-interpretation)
                  :controls-killed '() :mutants-survived '()
                  :witnesses '(:ash-chair)))

;;; ── VII ─────────────────────────────────────────────────────────────────
(section "VII. the surviving mutant")
(register-probe :fixture-battery
                :oracle-root :independent-oracle
                :dimensions '(:fixture-coupling :method-shape)
                :controls-killed '(:shuffled-fixture)
                :mutants-survived '(:fixture-coupling)
                :witnesses '(:ash-chair :beech-chair))
(format t "   the downgrade is located; the overbroad claim is not:~%")
(expect-condition mutation-survived
  (claim-surviving-mutant-left-dimension-strong :fixture-coupling))
(expect-condition severity-not-demonstrated
  (claim-severity :fixture-coupling))
(expect-condition probe-manifold-mismatch
  (validate-probe-manifold
   '(:id :uncovered :dimensions (:adapter-optimization))))
(expect-condition mutant-generator-shared-with-witness
  (register-probe :tainted-generator
                  :oracle-root :independent-oracle
                  :mutant-generator-root :common-well
                  :dimensions '(:semantic-interpretation)
                  :controls-killed '() :mutants-survived '()
                  :witnesses '(:ash-chair)))
(pass "surviving mutant weakened one dimension; :method-shape stands")

;;; ── VIII ────────────────────────────────────────────────────────────────
(section "VIII. the corridor (three witnesses, ancestry changes coats twice)")
(declare-witness :scrivener "reads the ruling, writes the gloss")
(declare-witness :glossator "reads the gloss, writes the digest-note")
(declare-witness :lector    "reads only the digest-note")
(declare-root :closure-ruling-n012 :interpretive-root
              :description "an authorial closure both must not share unpaid")
(assert-transmission :closure-ruling-n012 :wondermonger :may-transmit
                     '(:semantic-interpretation))
(expose :scrivener :closure-ruling-n012)
(let* ((gloss (author-artifact :scrivener
                               '(:semantic-interpretation :open
                                 :method-shape :unknown)))
       (ignored (read-artifact :glossator gloss :scope :all))
       (note (author-artifact :glossator
                              '(:semantic-interpretation :open
                                :method-shape :unknown))))
  (declare (ignore ignored))
  (read-artifact :lector note :scope :all)
  (format t "   the note never quotes the ruling; the serial numbers are gone.~%")
  (format t "   a naive fold that ignores the declared hallway is a defect:~%")
  (expect-condition exposure-laundered
    (audit-fold '(:scrivener :lector) :semantic-interpretation))
  (show-summary (pair-dimension-summary '(:scrivener :lector)
                                        :semantic-interpretation))
  (show-summary (pair-dimension-summary '(:scrivener :lector) :method-shape))
  (pass "one corridor live (laundering caught); one lawfully :unknown"))
(expect-condition read-scope-is-not-uptake-proof
  (claim-read-scope-proves-interruption :metadata-only))
(format t "   the glossator offers an alibi against the admitted log:~%")
(expect-condition self-attested-path-interruption
  (offer-path-breaking-order :glossator
                             '(:my-read-of-gloss :before :the-exposure)))
(format t "   order is not conjured from its own absence, nor from a cycle:~%")
(expect-condition order-absence-is-not-reverse-order
  (conclude-reverse-order :unordered-a :unordered-b))
(let* ((hops (first (corridor-paths :closure-ruling-n012 :lector)))
       (skeleton (candidate-path-skeleton hops))
       (context (ordering-use-context skeleton :semantic-interpretation
                                      :corridor-exhibit-viii))
       (pair (first (required-event-pairs hops)))
       (reverse-claim (make-ordering-assertion
                       (second pair) (first pair)
                       :declarant :contrary-clock
                       :basis :declared :verifier :none))
       (conflicted (path-local-ordering-closure
                    hops skeleton context :extra-assertions
                    (list reverse-claim))))
  (ensure (eq (getf conflicted :ordering-relation) :unknown)
          "raw contradictory ordering testimony did not remain unknown")
  (pass "raw contradictory clocks remain testimony; this use is :unknown")
  (expect-condition mixed-ordering-use-requires-decomposition
    (ordering-admissibility reverse-claim context :mixed))
  (expect-condition ordering-assertion-cannot-ground-its-own-admissibility
    (ordering-admissibility reverse-claim context :path-breaking
                            :eligibility-uses-assertion-p t))
  (expect-condition unverified-machine-ordering-basis
    (ordering-admissibility
     (make-ordering-assertion (first pair) (second pair)
                              :basis :same-log :verifier :none)
     context :path-creating))
  (let ((wrong (list :use-context :another-use :earlier :e1 :later :e2
                     :digest :wrong-context)))
    (expect-condition ordering-use-context-mismatch
      (certify-path-local-closure context (list wrong))))
  (let ((cycle (list
                (list :use-context (getf context :digest)
                      :earlier :e1 :later :e2 :digest :c1)
                (list :use-context (getf context :digest)
                      :earlier :e2 :later :e3 :digest :c2)
                (list :use-context (getf context :digest)
                      :earlier :e3 :later :e1 :digest :c3))))
    (expect-condition causal-order-cycle
      (certify-path-local-closure context cycle))))

;;; ── IX ──────────────────────────────────────────────────────────────────
(section "IX. the bounded corroboration")
(declare-witness :north-chair "first clean chair")
(declare-witness :south-chair "second clean chair, blinded")
(declare-witness :east-chair  "third chair, toolchain unfiled")
(declare-edge :cd0-spec :north-chair)
(declare-edge :cd0-spec :south-chair)
(declare-edge :cd0-spec :east-chair)
(declare-root :shared-toolchain :infrastructure-root
              :description "south and east share a build image; no profile filed")
(declare-edge :shared-toolchain :south-chair)
(declare-edge :shared-toolchain :east-chair)
(register-probe :panel-battery
                :oracle-root :independent-oracle
                :dimensions '(:implementation-defect)
                :controls-killed '(:seeded-defect)
                :mutants-survived '()
                :witnesses '(:north-chair :south-chair :east-chair))
(format t "   first, the exact confession of the all-unknown panel:~%")
(declare-witness :ghost-1 "directory one") (declare-witness :ghost-2 "directory two")
(declare-witness :ghost-3 "directory three")
(declare-root :umbral-source :training-root :description "nobody filed anything")
(dolist (g '(:ghost-1 :ghost-2 :ghost-3)) (declare-edge :umbral-source g))
(let ((fold (panel-independence '(:ghost-1 :ghost-2 :ghost-3)
                                :implementation-defect)))
  (format t "   (:guaranteed-lineages ~a :possible-lineages ~a :corroboration :not-minted)~%"
          (getf fold :guaranteed-lineages) (getf fold :possible-lineages)))
(expect-condition panel-independence-not-established
  (mint-corroborated-under
   :claim '(:located-claim :ghosts-agree)
   :manifold '(:id :m-ghost :dimensions (:implementation-defect))
   :witnesses '(:ghost-1 :ghost-2 :ghost-3)
   :selection (list :candidate-attempts 3 :excluded-observations '()
                    :inclusion-rule :all-attempts)))
(format t "   a survivor panel is refused before counting begins:~%")
(expect-condition survivor-panel
  (validate-selection (list :candidate-attempts 5
                            :excluded-observations '(:the-disagreement)
                            :inclusion-rule nil)))
(format t "   now the lawful panel — one pair :unknown, two certified lineages:~%")
(let* ((panel '(:north-chair :south-chair :east-chair))
       (fold (panel-independence panel :implementation-defect))
       (receipt (mint-corroborated-under
                 :claim '(:located-claim
                          :proposition (:composition-table :row-count 19)
                          :vantage :porch :as-of :this-execution)
                 :manifold '(:id :m-panel :dimensions (:implementation-defect))
                 :witnesses panel
                 :selection (list :candidate-attempts 3
                                  :excluded-observations '()
                                  :inclusion-rule :all-attempts))))
  (format t "   guaranteed ~a (witnesses: ~a), possible ~a~%"
          (getf fold :guaranteed-lineages)
          (getf fold :guaranteed-certificate)
          (getf fold :possible-lineages))
  (let* ((method (getf fold :guaranteed-method))
         (edges (conflict-edges panel :implementation-defect :guaranteed))
         (bad-lower (plist-copy method))
         (bad-upper (plist-copy method))
         (bad-interval (plist-copy method))
         (bad-graph (plist-copy method)))
    (setf (getf bad-lower :lower-certificate) nil)
    (expect-condition unwitnessed-lineage-lower-bound
      (validate-lineage-method bad-lower panel :implementation-defect edges))
    (setf (getf bad-upper :upper-certificate) nil)
    (expect-condition unsupported-lineage-upper-bound
      (validate-lineage-method bad-upper panel :implementation-defect edges))
    (setf (getf bad-interval :upper-bound) 0)
    (expect-condition lineage-bound-conflict
      (validate-lineage-method bad-interval panel :implementation-defect edges))
    (setf (getf bad-graph :graph-construction-digest) :wrong-graph)
    (expect-condition malformed-provenance-graph
      (validate-lineage-method bad-graph panel :implementation-defect edges))
    (expect-condition lineage-count-is-not-warrant-strength
      (claim-lineage-count-is-strength (getf fold :possible-lineages)))
    (let* ((components *last-path-replay-components*)
           (expected
             (make-replay-record
              (getf components :ordering-use-context)
              (getf components :graph-snapshot)
              (getf method :lower-certificate)
              (getf components :exposure-path-decision)))
           (replayed
             (make-replay-record
              (getf components :ordering-use-context)
              (getf components :graph-snapshot)
              (getf method :lower-certificate)
              (getf components :exposure-path-decision)))
           (divergent
             (make-replay-record
              (getf components :ordering-use-context)
              (getf components :graph-snapshot)
              (getf method :lower-certificate)
              :silently-reclassified)))
      (verify-replay expected replayed)
      (pass "replay bound context, snapshot, lineage witness, and path decision")
      (expect-condition replay-diverged
        (verify-replay expected divergent))))
  (validate-receipt receipt)
  (pass "lawful receipt minted and revalidated")
  (format t "   verdict: ~a  standing: ~a  totality: ~a~%"
          (getf receipt :verdict) (getf receipt :standing)
          (getf receipt :totality))
  (format t "   graph: standing ~a, veracity ~a — the bracket, not a witness~%"
          (getf receipt :graph-standing) (getf receipt :graph-veracity))
  (format t "   residual unknowns carried on the face: ~a pair-dimension(s)~%"
          (length (getf receipt :residual-unknowns)))

  (let ((profile (make-independence-profile
                  '(:north-chair :south-chair) :implementation-defect)))
    (let ((altered (plist-copy profile)))
      (setf (getf altered :relation) :invented)
      (expect-condition altered-independence-profile
        (validate-independence-profile altered)))
    (declare-witness :profile-audit-marker "append-only freshness marker")
    (expect-condition independence-profile-stale
      (validate-independence-profile profile))
    (let ((forged (make-independence-profile
                   '(:north-chair :south-chair) :implementation-defect)))
      (setf (getf forged :relation) :invented
            (getf forged :digest) (toy-digest (butlast forged 2)))
      (expect-condition forged-independence-claim
        (validate-independence-profile forged))))

  (expect-condition unversioned-artifact-reference
    (read-artifact :lector :mutable-branch-name))
  (expect-condition mutated-provenance-history
    (mutate-provenance-record (first *edges*)))
  (expect-condition unnamespaced-root-kind
    (declare-root :bad-extension :free-floating-kind))

  ;; ── X ─────────────────────────────────────────────────────────────────
  (section "X. the harpoon ceiling")
  (format t "   the :merchant, holding the receipt, attempts three promotions:~%")
  (expect-condition corroboration-is-not-totality
    (claim-totality receipt))
  (expect-condition corroboration-is-not-truth
    (promote-to-truth receipt))
  (expect-condition manifold-expansion-requires-new-warrant
    (expand-manifold receipt :semantic-interpretation))
  (expect-condition execution-success-is-not-provenance-truth
    (claim-execution-proves-history))
  (format t "   and the cosmetic rewrite is refused by recomputation:~%")
  (let ((forged (plist-copy receipt)))
    (setf (getf forged :totality) :claimed)
    (expect-condition altered-corroboration-receipt
      (validate-receipt forged)))
  (format t "~%   census of the unreached, carried on the maximal receipt:~%")
  (format t "   ~a~%" (getf receipt :veiled-regions))
  (format t "   the beast ends :UNSUBDUED.~%"))

(let ((missing (set-difference *required-condition-coverage*
                               *condition-coverage*)))
  (ensure (null missing) "mandatory typed condition coverage missing: ~s" missing)
  (pass (format nil "all ~a mandatory typed conditions exercised"
                (length *required-condition-coverage*))))

(section "what this hinge does NOT establish")
(format t " The graph is declared testimony; its veracity is :not-established.~%")
(format t " Exit 0 proves conformant execution over the supplied data and~%")
(format t " nothing about history: EXECUTION-SUCCESS-IS-NOT-PROVENANCE-TRUTH.~%")
(format t " No real pair is proven independent, no real probe severe, no real~%")
(format t " claim true.  The regress is not solved; it is bounded, named, and~%")
(format t " prevented from laundering itself into truth.~%")

(format t "~%── agreement is not a well shared ──~%")
(format t "── a well shared is not every well ──~%")
(format t "── the court keeps both testimonies, and the order they claim to have arrived ──~%")
(format t "── the lower bound brings witnesses; the upper bound is allowed to dream ──~%")
(format t "── a clock that closes a corridor must show its papers ──~%")
(format t "── the receipt remembers when the water was still separate ──~%")
(format t "~%   DE CORROBORATIONE complete✓~%")
