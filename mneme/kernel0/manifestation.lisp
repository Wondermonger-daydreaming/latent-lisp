(in-package #:lisp-plus-kernel0)

(defun manifestation-status-p (value)
  (case value
    ((:present
      :present-empty
      :present-invalid
      :present-partial
      :absent
      :withheld
      :redacted)
     t)
    (otherwise nil)))

(defun absence-state-p (value)
  (case value
    ((:never-attempted
      :refused-pre-effect
      :absent-after-completion
      :withheld
      :redacted
      :not-applicable)
     t)
    (otherwise nil)))

(defun present-manifestation-status-p (value)
  (case value
    ((:present :present-empty :present-invalid :present-partial) t)
    (otherwise nil)))

(defstruct (manifestation
            (:constructor %make-manifestation
                (manifestation-id
                 attempt-id
                 kind
                 status
                 payload-id
                 absence-state
                 parser-id
                 source-boundary
                 visibility
                 emptiness-rule-id
                 ;; Errata 0.2 §5 producer/stream lineage (K0E-27..32): every
                 ;; slot below is :READ-ONLY, so a constructed manifestation can
                 ;; never have its producer identity or captured chunk lineage
                 ;; removed or overwritten (K0E-31 partial preservation).
                 adapter-identity
                 producer-identity
                 stream-relation))
            (:copier nil)
            (:conc-name %manifestation-))
  (manifestation-id nil :read-only t)
  (attempt-id nil :read-only t)
  (kind nil :read-only t)
  (status nil :read-only t)
  (payload-id nil :read-only t)
  (absence-state nil :read-only t)
  (parser-id nil :read-only t)
  (source-boundary nil :read-only t)
  (visibility nil :read-only t)
  (emptiness-rule-id nil :read-only t)
  (adapter-identity nil :read-only t)
  (producer-identity nil :read-only t)
  (stream-relation nil :read-only t))

(defun manifestation-manifestation-id (manifestation)
  (%manifestation-manifestation-id manifestation))

(defun manifestation-attempt-id (manifestation)
  (%manifestation-attempt-id manifestation))

(defun manifestation-kind (manifestation)
  (%snapshot-tree (%manifestation-kind manifestation)))

(defun manifestation-status (manifestation)
  (%manifestation-status manifestation))

(defun manifestation-payload-id (manifestation)
  (%manifestation-payload-id manifestation))

(defun manifestation-absence-state (manifestation)
  (%manifestation-absence-state manifestation))

(defun manifestation-parser-id (manifestation)
  (%manifestation-parser-id manifestation))

(defun manifestation-source-boundary (manifestation)
  (%snapshot-tree (%manifestation-source-boundary manifestation)))

(defun manifestation-visibility (manifestation)
  (%snapshot-tree (%manifestation-visibility manifestation)))

(defun manifestation-emptiness-rule-id (manifestation)
  (%manifestation-emptiness-rule-id manifestation))

;;; Errata 0.2 §5 (K0E-27..32): producer identity and stream lineage.
;;;
;;; K0E-31 PARTIAL-PRESERVATION ASSERTION.  The manifestation record surface is
;;; wholly read-only: every slot carries :READ-ONLY T, the (:COPIER NIL) option
;;; suppresses COPY-MANIFESTATION, and no function in this file defines a SETF
;;; accessor or a SET-* mutator for a payload identity, a producer identity, or
;;; a captured chunk lineage.  There is therefore NO code path here that can
;;; erase or overwrite a payload or chunk lineage once a manifestation is
;;; constructed; a captured partial survives absence, cancellation, parser
;;; failure, or missing finality by construction.  Wave 4's partial-erasure
;;; MUTANT (a deliberate eraser) must be killed by exactly this fact — see the
;;; PRESENT-PAYLOAD-ERASURE guard note in W2b-FLUMEN-notes.md.

;; The stream relation is itself an immutable sub-record.  It carries ONLY the
;; kernel-side lineage fields (K0E-28/29): stream identity, relation kind, an
;; ordered list of AP0 chunk-record identities reached BY REFERENCE, and an
;; optional projection receipt.  It does NOT restate the AP0 chunk schema
;; (sequence, predecessor, payload count, finality, persistence order) — those
;; remain owned and rendered by AP0.
(defstruct (stream-relation
            (:constructor %make-stream-relation
                (stream-id relation-kind chunk-record-ids projection-receipt-id))
            (:copier nil)
            (:conc-name %stream-relation-))
  (stream-id nil :read-only t)
  (relation-kind nil :read-only t)
  (chunk-record-ids nil :read-only t)
  (projection-receipt-id nil :read-only t))

(defun stream-relation-stream-id (relation)
  (%stream-relation-stream-id relation))

(defun stream-relation-relation-kind (relation)
  (%stream-relation-relation-kind relation))

(defun stream-relation-chunk-record-ids (relation)
  "Return a defensive copy of the ordered chunk-record identity list."
  (%snapshot-tree (%stream-relation-chunk-record-ids relation)))

(defun stream-relation-projection-receipt-id (relation)
  (%stream-relation-projection-receipt-id relation))

(defun manifestation-adapter-identity (manifestation)
  "Return the AP0 adapter identity for an AP0-produced manifestation, else NIL."
  (%manifestation-adapter-identity manifestation))

(defun manifestation-producer-identity (manifestation)
  "Return the producer identity for a non-AP0-produced manifestation, else NIL."
  (%manifestation-producer-identity manifestation))

(defun manifestation-stream-relation (manifestation)
  "Return the immutable STREAM-RELATION sub-record, or NIL for a non-streamed
manifestation.  Nil-safe entry point for the §21 inspection surface (K0E-28a)."
  (%manifestation-stream-relation manifestation))

(defun manifestation-chunk-record-ids (manifestation)
  "Return the ordered AP0 chunk-record identities of a streamed manifestation,
or NIL when the manifestation is not streamed (K0E-28a inspection surface)."
  (let ((relation (%manifestation-stream-relation manifestation)))
    (when relation
      (stream-relation-chunk-record-ids relation))))

(defun manifestation-projection-receipt-id (manifestation)
  "Return the projection receipt identity of a streamed manifestation, or NIL
when the manifestation is not streamed or carries no receipt (K0E-28a)."
  (let ((relation (%manifestation-stream-relation manifestation)))
    (when relation
      (stream-relation-projection-receipt-id relation))))

(defun %require-durable-identity
    (value failed-invariant requirement-id offending-field &optional attempt-id)
  "Refuse VALUE unless it is a durable identity, WITHOUT constraining its domain.
K0E-27/K0E-28/K0E-30: the kernel checks identity-ness only; AP0 owns the value
spaces of adapter, chunk, stream, and receipt identities (AP-G4-3)."
  (unless (durable-identity-p value)
    (signal-kernel0 'malformed-constructor-shape
                    :attempt-id attempt-id
                    :requirement-id requirement-id
                    :offending-field offending-field
                    :offending-value value
                    :failed-invariant failed-invariant))
  value)

(defun %check-manifestation-producer-branch (parsed attempt-id)
  "K0E-27: exactly one producer branch MUST be present and be a durable identity.
AP0-produced binds :ADAPTER-IDENTITY; non-AP0-produced binds :PRODUCER-IDENTITY.
Neither, or both, signals MALFORMED-CONSTRUCTOR-SHAPE.  Validation only; the
constructor snapshots the value it keeps via %MANIFESTATION-PRODUCER-VALUE."
  (let ((adapter (%constructor-argument parsed :adapter-identity))
        (producer (%constructor-argument parsed :producer-identity)))
    (let ((adapter-present (and adapter t))
          (producer-present (and producer t)))
      (when (and adapter-present producer-present)
        (signal-kernel0 'malformed-constructor-shape
                        :attempt-id attempt-id
                        :requirement-id "K0E-27"
                        :offending-field :adapter-identity
                        :offending-value adapter
                        :failed-invariant
                        "§8.1 and Appendix A.2 [K0E-27]: exactly one producer branch is lawful; :adapter-identity (AP0-produced) and :producer-identity (non-AP0) are mutually exclusive"))
      (unless (or adapter-present producer-present)
        (signal-kernel0 'malformed-constructor-shape
                        :attempt-id attempt-id
                        :requirement-id "K0E-27"
                        :offending-field :producer-identity
                        :offending-value nil
                        :failed-invariant
                        "§8.1 and Appendix A.2 [K0E-27]: a manifestation MUST bind exactly one producer branch — :adapter-identity when AP0-produced, else :producer-identity"))
      (when adapter-present
        (%require-durable-identity
         adapter
         "§8.1 and Appendix A.2 [K0E-27]: :adapter-identity MUST be a durable identity; the kernel checks identity-ness only and AP0 owns its value space (AP-G4-3)"
         "K0E-27" :adapter-identity attempt-id))
      (when producer-present
        (%require-durable-identity
         producer
         "§8.1 and Appendix A.2 [K0E-27]: :producer-identity MUST be a durable identity"
         "K0E-27" :producer-identity attempt-id))))
  (values))

(defun %manifestation-producer-value (parsed key)
  "Return the already-validated producer-branch value under KEY, snapshotted, or
NIL when that branch is absent.  Presence, exclusivity, and identity-ness were
enforced by %CHECK-MANIFESTATION-PRODUCER-BRANCH."
  (let ((value (%constructor-argument parsed key)))
    (and value (%snapshot-tree value))))

(defun %parse-manifestation-stream-relation (parsed attempt-id)
  "K0E-28/K0E-30/K0E-32: parse the optional :STREAM-RELATION sub-record.
Return a STREAM-RELATION struct when the manifestation is streamed, or NIL for a
non-stream manifestation (relation omitted).  A supplied husk (NIL/empty list)
is refused as an insufficient marker (K0E-32); a bare :STREAMED-P or any unknown
key was already refused by the outer strict-constructor parse.  The kernel
carries only the reference fields; AP0 owns the exact chunk value spaces."
  (multiple-value-bind (raw supplied-p)
      (%constructor-argument parsed :stream-relation)
    (cond
      ((not supplied-p) nil)
      ((null raw)
       (signal-kernel0 'malformed-constructor-shape
                       :attempt-id attempt-id
                       :requirement-id "K0E-32"
                       :offending-field :stream-relation
                       :offending-value raw
                       :failed-invariant
                       "§8.1 and Appendix A.2 [K0E-32]: a non-stream manifestation MUST omit :stream-relation entirely; an empty husk relation is an insufficient stream marker"))
      (t
       (let ((relation-args
               (%strict-constructor-arguments
                raw
                '(:stream-id
                  :relation-kind
                  :chunk-record-ids
                  :projection-receipt-id)
                'malformed-constructor-shape
                "§8.1 and Appendix A.2 [K0E-32]: a :stream-relation MUST be a proper plist over exactly :stream-id, :relation-kind, :chunk-record-ids, and :projection-receipt-id")))
         (let ((stream-id (%constructor-argument relation-args :stream-id))
               (relation-kind (%constructor-argument relation-args :relation-kind)))
           (multiple-value-bind (chunk-ids chunk-supplied-p)
               (%constructor-argument relation-args :chunk-record-ids)
             (multiple-value-bind (receipt receipt-supplied-p)
                 (%constructor-argument relation-args :projection-receipt-id)
               (%require-durable-identity
                stream-id
                "§8.1 and Appendix A.2 [K0E-32]: a :stream-relation MUST name a durable stream identity"
                "K0E-32" :stream-id attempt-id)
               (unless (member relation-kind
                               '(:direct-chunk :aggregate :projection)
                               :test #'eq)
                 (signal-kernel0 'malformed-constructor-shape
                                 :attempt-id attempt-id
                                 :requirement-id "K0E-32"
                                 :offending-field :relation-kind
                                 :offending-value relation-kind
                                 :failed-invariant
                                 "§8.1 and Appendix A.2 [K0E-32]: :relation-kind MUST be :direct-chunk, :aggregate, or :projection"))
               ;; K0E-28: non-empty proper ordered list of durable chunk-record
               ;; identities, reached by reference and duplicate-free.
               (unless (and chunk-supplied-p (%proper-list-p chunk-ids) chunk-ids)
                 (signal-kernel0 'malformed-constructor-shape
                                 :attempt-id attempt-id
                                 :requirement-id "K0E-28"
                                 :offending-field :chunk-record-ids
                                 :offending-value chunk-ids
                                 :failed-invariant
                                 "§8.1 and Appendix A.2 [K0E-28]: a streamed manifestation MUST carry a non-empty ordered list of AP0 chunk-record identities"))
               (dolist (id chunk-ids)
                 (%require-durable-identity
                  id
                  "§8.1 and Appendix A.2 [K0E-28]: each chunk-record reference MUST be a durable identity; a sequence count or host-only label is insufficient"
                  "K0E-28" :chunk-record-ids attempt-id))
               (unless (%duplicate-free-p chunk-ids)
                 (signal-kernel0 'malformed-constructor-shape
                                 :attempt-id attempt-id
                                 :requirement-id "K0E-28"
                                 :offending-field :chunk-record-ids
                                 :offending-value chunk-ids
                                 :failed-invariant
                                 "§8.1 and Appendix A.2 [K0E-28]: the chunk-record identity list MUST be duplicate-free"))
               (when (and receipt-supplied-p receipt)
                 (%require-durable-identity
                  receipt
                  "§8.1 and Appendix A.2 [K0E-30]: a :projection-receipt-id, when present, MUST be a durable identity"
                  "K0E-30" :projection-receipt-id attempt-id))
               ;; K0E-30: receipt required for any derived multi-chunk output;
               ;; omittable ONLY for :direct-chunk, which must then reference
               ;; exactly one captured chunk.
               (case relation-kind
                 (:direct-chunk
                  (unless (= 1 (length chunk-ids))
                    (signal-kernel0 'malformed-constructor-shape
                                    :attempt-id attempt-id
                                    :requirement-id "K0E-30"
                                    :offending-field :chunk-record-ids
                                    :offending-value chunk-ids
                                    :failed-invariant
                                    "§8.1 and Appendix A.2 [K0E-30]: :direct-chunk is direct identity with exactly ONE captured chunk-record")))
                 ((:aggregate :projection)
                  (unless (and receipt-supplied-p receipt)
                    (signal-kernel0 'malformed-constructor-shape
                                    :attempt-id attempt-id
                                    :requirement-id "K0E-30"
                                    :offending-field :projection-receipt-id
                                    :offending-value nil
                                    :failed-invariant
                                    "§8.1 and Appendix A.2 [K0E-30]: an :aggregate or :projection relation is derived multi-chunk output and MUST bind a projection-receipt-id"))))
               (%make-stream-relation
                (%snapshot-tree stream-id)
                relation-kind
                (%snapshot-tree chunk-ids)
                (and receipt-supplied-p receipt (%snapshot-tree receipt)))))))))))

(defun %chunk-record-field (record key)
  "Read KEY from a minimal AP0 chunk RECORD.
The documented minimal shape is a plist carrying :STREAM-ID, :ATTEMPT-ID,
:ADAPTER-IDENTITY, and :CHUNK-ID.  When a future AP0 layer ships a chunk struct,
a thin adapter converts it to this plist (or this accessor gains a struct
branch); the kernel-side coherence check depends only on these four fields,
never on AP0's internal chunk representation."
  (when (%proper-list-p record)
    (getf record key)))

(defun validate-stream-relation-coherence (manifestation chunk-records)
  "K0E-29 kernel-side coherence check, GIVEN chunk records as data.

Verify that every chunk id the streamed MANIFESTATION references resolves to a
record in CHUNK-RECORDS, and that every referenced chunk shares the
manifestation's stream-id, attempt-id, and adapter-identity.  Signal
IDENTITY-DRIFT (requirement K0E-29) on any missing reference or identity
mismatch; return the MANIFESTATION on success.

BOUNDARY (K0E-28/28a/29): this check does NOT duplicate the AP0 chunk schema.
It reaches the AP0-owned chunk records BY REFERENCE and reads only the four-field
minimal plist shape documented in %CHUNK-RECORD-FIELD; sequence number,
predecessor, finality evidence, persistence order, and every other chunk fact
remain owned and rendered by AP0 — this is the K0E-29 obligation discharged
kernel-side without smuggling an AP0 runtime.  Streaming is AP0 territory, so the
lawful streamed manifestation is AP0-produced and carries an :adapter-identity; a
manifestation without one is compared against NIL and will correctly drift,
because a chunk lineage that cannot be tied to an adapter is not coherent.

The adapter assumption is now CONSTRUCTOR-GUARANTEED (N2 chair disposition,
hostile review §10): MAKE-MANIFESTATION refuses a streamed manifestation on the
non-AP0 :producer-identity branch, so any manifestation that reaches this check
carrying a stream relation necessarily has an :adapter-identity.  The NIL-drift
fallback above is therefore defense in depth, not the primary guarantee."
  (unless (manifestation-p manifestation)
    (signal-kernel0 'identity-drift
                    :requirement-id "K0E-29"
                    :offending-field :manifestation
                    :offending-value manifestation
                    :failed-invariant
                    "§8.1 and Appendix A.2 [K0E-29]: stream coherence requires a manifestation record"))
  (let ((relation (manifestation-stream-relation manifestation))
        (attempt-id (manifestation-attempt-id manifestation))
        (adapter-identity (manifestation-adapter-identity manifestation)))
    (unless relation
      (signal-kernel0 'identity-drift
                      :attempt-id attempt-id
                      :requirement-id "K0E-29"
                      :offending-field :stream-relation
                      :offending-value nil
                      :failed-invariant
                      "§8.1 and Appendix A.2 [K0E-29]: a non-stream manifestation has no chunk lineage to validate"))
    (let ((stream-id (stream-relation-stream-id relation)))
      (dolist (chunk-id (stream-relation-chunk-record-ids relation) manifestation)
        (let ((record
                (find-if
                 (lambda (candidate)
                   (%kernel-name=
                    (%chunk-record-field candidate :chunk-id) chunk-id))
                 chunk-records)))
          (unless record
            (signal-kernel0 'identity-drift
                            :attempt-id attempt-id
                            :requirement-id "K0E-29"
                            :offending-field :chunk-record-ids
                            :offending-value chunk-id
                            :failed-invariant
                            "§8.1 and Appendix A.2 [K0E-28a/K0E-29]: every referenced chunk id MUST resolve to a supplied chunk record"))
          (unless (and (identity=
                        (%chunk-record-field record :stream-id) stream-id)
                       (identity=
                        (%chunk-record-field record :attempt-id) attempt-id)
                       (identity=
                        (%chunk-record-field record :adapter-identity)
                        adapter-identity))
            (signal-kernel0 'identity-drift
                            :attempt-id attempt-id
                            :requirement-id "K0E-29"
                            :offending-field :chunk-record-ids
                            :offending-value chunk-id
                            :failed-invariant
                            "§8.1 and Appendix A.2 [K0E-29]: every referenced chunk record MUST share the manifestation's stream-id, attempt-id, and adapter-identity")))))))

(defun %require-manifestation-list-field (value failed-invariant)
  (unless (%proper-list-p value)
    (signal-kernel0 'standing-inflation
                    :failed-invariant failed-invariant))
  (%snapshot-tree value))

(defun make-manifestation (&rest arguments)
  "Construct an immutable manifestation state, without a causal-diagnosis slot."
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:manifestation-id
             :attempt-id
             :kind
             :status
             :payload-id
             :absence-state
             :parser-id
             :source-boundary
             :visibility
             :emptiness-rule-id
             :adapter-identity
             :producer-identity
             :stream-relation)
           'malformed-constructor-shape
           "§8, §8.7, §8.9.1, and Appendix A.2 [K0E-33]: a manifestation constructor MUST use only the closed state schema (including exactly one producer branch and an optional stream relation) and MUST NOT attach cause to absence state; unknown or duplicate fields, and a bare :streamed-p, are refused")))
    (multiple-value-bind (manifestation-id manifestation-id-supplied-p)
        (%constructor-argument parsed :manifestation-id)
      (declare (ignore manifestation-id-supplied-p))
      (multiple-value-bind (attempt-id attempt-id-supplied-p)
          (%constructor-argument parsed :attempt-id)
        (declare (ignore attempt-id-supplied-p))
        (multiple-value-bind (kind kind-supplied-p)
            (%constructor-argument parsed :kind)
          (multiple-value-bind (status status-supplied-p)
              (%constructor-argument parsed :status)
            (multiple-value-bind (payload-id payload-id-supplied-p)
                (%constructor-argument parsed :payload-id)
              (declare (ignore payload-id-supplied-p))
              (multiple-value-bind (absence-state absence-state-supplied-p)
                  (%constructor-argument parsed :absence-state)
                (declare (ignore absence-state-supplied-p))
                (multiple-value-bind (parser-id parser-id-supplied-p)
                    (%constructor-argument parsed :parser-id)
                  (declare (ignore parser-id-supplied-p))
                  (multiple-value-bind (source-boundary
                                        source-boundary-supplied-p)
                      (%constructor-argument parsed :source-boundary)
                    (multiple-value-bind (visibility visibility-supplied-p)
                        (%constructor-argument parsed :visibility nil)
                      (declare (ignore visibility-supplied-p))
                      (multiple-value-bind (emptiness-rule-id
                                            emptiness-rule-id-supplied-p)
                          (%constructor-argument parsed :emptiness-rule-id)
                        (declare (ignore emptiness-rule-id-supplied-p))
                        (require-identity manifestation-id :manifestation)
                        (require-identity attempt-id :attempt)
                        ;; K0E-27 producer branch is a fundamental constructor
                        ;; shape gate: enforce exactly-one-present BEFORE the §8
                        ;; content laws, so a producerless manifestation is
                        ;; refused as malformed rather than reaching a payload
                        ;; or absence check.
                        (%check-manifestation-producer-branch parsed attempt-id)
                        ;; N2 (CHAIR DISPOSITION — hostile review §10): a
                        ;; streamed manifestation is AP0-produced BY LAW.  Its
                        ;; :stream-relation references AP0 chunk records
                        ;; (K0E-28), which presuppose an AP0 adapter boundary, so
                        ;; a stream is lawful ONLY on the :adapter-identity
                        ;; branch.  A streamed manifestation on the non-AP0
                        ;; :producer-identity branch is outside Kernel /0 scope
                        ;; and is refused here, BEFORE the stream relation is
                        ;; parsed, as a producer/stream shape fault.  This makes
                        ;; VALIDATE-STREAM-RELATION-COHERENCE's adapter
                        ;; assumption constructor-guaranteed rather than merely
                        ;; assumed.  (A husk :stream-relation NIL is not a stream
                        ;; and is refused separately as K0E-32 during parse.)
                        (multiple-value-bind (stream-relation-arg
                                              stream-relation-supplied-p)
                            (%constructor-argument parsed :stream-relation)
                          (when (and stream-relation-supplied-p
                                     stream-relation-arg)
                            (multiple-value-bind (producer producer-supplied-p)
                                (%constructor-argument
                                 parsed :producer-identity)
                              (when (and producer-supplied-p producer)
                                (signal-kernel0
                                 'malformed-constructor-shape
                                 :attempt-id attempt-id
                                 :requirement-id "K0E-28"
                                 :offending-field :producer-identity
                                 :offending-value producer
                                 :failed-invariant
                                 "§8.1 and Appendix A.2 [K0E-28]: a streamed manifestation is AP0-produced by law (K0E-28 chunk references are AP0 records); non-AP0 streaming is outside /0 scope")))))
                        (unless (and kind-supplied-p kind)
                          (signal-kernel0
                           'standing-inflation
                           :attempt-id attempt-id
                           :failed-invariant
                           "§8.1 and Appendix A.2: a manifestation MUST bind its kind"))
                        (unless (and status-supplied-p
                                     (manifestation-status-p status))
                          (signal-kernel0
                           'standing-inflation
                           :attempt-id attempt-id
                           :failed-invariant
                           "§8.2 [F: MAN-1]: manifestation status MUST be a member of the closed Kernel /0 status algebra"))
                        (unless (and source-boundary-supplied-p source-boundary)
                          (signal-kernel0
                           'standing-inflation
                           :attempt-id attempt-id
                           :failed-invariant
                           "§8.1 and Appendix A.2: a manifestation MUST bind its source boundary"))
                        (let ((visibility-copy
                                (%require-manifestation-list-field
                                 visibility
                                 "§8.1 and Appendix A.2: manifestation visibility MUST be represented as a list when applicable")))
                          (when (present-manifestation-status-p status)
                            (unless payload-id
                              (signal-kernel0
                               'manifestation-payload-missing
                               :attempt-id attempt-id
                               :failed-invariant
                               "§8.3 and §9.6: every :present* manifestation MUST preserve a payload identity"))
                            (%reference-identity
                             payload-id
                             "§8.3 and §9.6: every :present* manifestation MUST preserve a durable payload identity")
                            (when absence-state
                              (signal-kernel0
                               'standing-inflation
                               :attempt-id attempt-id
                               :failed-invariant
                               "§8.3 and §8.7: a :present* manifestation MUST carry payload identity rather than a no-visible-payload absence state")))
                          (when (and payload-id
                                     (not (present-manifestation-status-p status)))
                            (if (eq status :absent)
                                (signal-kernel0
                                 'standing-inflation
                                 :attempt-id attempt-id
                                 :failed-invariant
                                 "§8.7: status :absent forbids a payload identity")
                                (%reference-identity
                                 payload-id
                                 "§8.7: any restricted payload reference MUST remain a durable identity")))
                          (case status
                            (:absent
                             (unless (member
                                      absence-state
                                      '(:never-attempted
                                        :refused-pre-effect
                                        :absent-after-completion
                                        :not-applicable)
                                      :test #'eq)
                               (signal-kernel0
                                'standing-inflation
                                :attempt-id attempt-id
                                :failed-invariant
                                "§8.7 [F: MAN-3]: status :absent permits only its four normatively mapped absence states")))
                            (:withheld
                             (unless (eq absence-state :withheld)
                               (signal-kernel0
                                'standing-inflation
                                :attempt-id attempt-id
                                :failed-invariant
                                "§8.7 [F: MAN-3]: status :withheld requires absence state :withheld")))
                            (:redacted
                             (unless (eq absence-state :redacted)
                               (signal-kernel0
                                'standing-inflation
                                :attempt-id attempt-id
                                :failed-invariant
                                "§8.7 [F: MAN-3]: status :redacted requires absence state :redacted"))))
                          (when parser-id
                            (require-identity parser-id :parser))
                          (when (and (eq status :present-invalid)
                                     (null parser-id))
                            (signal-kernel0
                             'invalidity-parser-missing
                             :attempt-id attempt-id
                             :failed-invariant
                             "§8.5: :present-invalid MUST preserve parser or validator identity"))
                          (cond ((eq status :present-empty)
                                 (unless emptiness-rule-id
                                   (signal-kernel0
                                    'interpretation-procedure-missing
                                    :attempt-id attempt-id
                                    :failed-invariant
                                    "§8.4: :present-empty MUST name an identified emptiness rule appropriate to the manifestation kind"))
                                 (require-identity emptiness-rule-id :procedure))
                                (emptiness-rule-id
                                 (signal-kernel0
                                  'standing-inflation
                                  :attempt-id attempt-id
                                  :failed-invariant
                                  "§8.4: an emptiness-rule identity is lawful if and only if manifestation status is :present-empty")))
                          (%make-manifestation
                           manifestation-id
                           attempt-id
                           (%snapshot-tree kind)
                           status
                           payload-id
                           absence-state
                           parser-id
                           (%snapshot-tree source-boundary)
                           visibility-copy
                           emptiness-rule-id
                           (%manifestation-producer-value
                            parsed :adapter-identity)
                           (%manifestation-producer-value
                            parsed :producer-identity)
                           (%parse-manifestation-stream-relation
                            parsed attempt-id)))))))))))))))

(defstruct (causal-claim
            (:constructor %make-causal-claim
                (subject predicate evidence origin validation))
            (:copier nil)
            (:conc-name %causal-claim-))
  (subject nil :read-only t)
  (predicate nil :read-only t)
  (evidence nil :read-only t)
  (origin nil :read-only t)
  (validation nil :read-only t))

(defun causal-claim-subject (claim)
  (%causal-claim-subject claim))

(defun causal-claim-predicate (claim)
  (%causal-claim-predicate claim))

(defun causal-claim-evidence (claim)
  (%snapshot-tree (%causal-claim-evidence claim)))

(defun causal-claim-origin (claim)
  (%causal-claim-origin claim))

(defun causal-claim-validation (claim)
  (%snapshot-tree (%causal-claim-validation claim)))

(defun %validated-causal-claim
    (subject predicate evidence origin validation)
  (require-identity subject :manifestation)
  (unless (keywordp predicate)
    (signal-kernel0
     'standing-inflation
     :failed-invariant
     "§8.9.1 [F: CAU-1]: a causal claim MUST bind a keyword predicate"))
  (let ((evidence-copy
          (%reference-list
           evidence
           "§8.9.1 [F: CAU-1]: a causal claim MUST bind a non-empty list of durable evidence references"
           :non-empty t)))
    (unless (member origin
                    '(:asserted :observed :derived :reconstructed)
                    :test #'eq)
      (signal-kernel0
       'reconstruction-origin-erasure
       :failed-invariant
       "§8.9.1 [F: CAU-1]: causal-claim origin MUST be :asserted, :observed, :derived, or :reconstructed"))
    (unless validation
      (signal-kernel0
       'bare-validation-scope
       :failed-invariant
       "§8.9.1 [F: CAU-1]: a causal claim MUST bind a validation facet"))
    (when (consp validation)
      (unless (%proper-list-p validation)
        (signal-kernel0
         'bare-validation-scope
         :failed-invariant
         "§8.9.1 [F: CAU-1]: a structured causal-claim validation facet MUST be a finite proper list")))
    (%make-causal-claim subject
                        predicate
                        evidence-copy
                        origin
                        (%snapshot-tree validation))))

(defun make-causal-claim (&rest arguments)
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:subject :predicate :evidence :origin :validation)
           'standing-inflation
           "§8.9.1 [F: CAU-1, CAU-2]: a causal claim MUST use exactly the five state-independent bindings; a cause slot on manifestation state is forbidden")))
    (multiple-value-bind (subject subject-supplied-p)
        (%constructor-argument parsed :subject)
      (declare (ignore subject-supplied-p))
      (multiple-value-bind (predicate predicate-supplied-p)
          (%constructor-argument parsed :predicate)
        (declare (ignore predicate-supplied-p))
        (multiple-value-bind (evidence evidence-supplied-p)
            (%constructor-argument parsed :evidence)
          (declare (ignore evidence-supplied-p))
          (multiple-value-bind (origin origin-supplied-p)
              (%constructor-argument parsed :origin)
            (declare (ignore origin-supplied-p))
            (multiple-value-bind (validation validation-supplied-p)
                (%constructor-argument parsed :validation)
              (declare (ignore validation-supplied-p))
              (%validated-causal-claim
               subject predicate evidence origin validation))))))))

(defun revise-causal-claim (claim &rest arguments)
  "Return a new causal claim; never mutate the referenced manifestation.

CAU-2: because both records are immutable and the claim attaches only through
its manifestation identity, diagnosis revision cannot alter manifestation
state, a state-derived fold, or a census class."
  (unless (causal-claim-p claim)
    (signal-kernel0
     'standing-inflation
     :failed-invariant
     "§8.9.1 [F: CAU-2]: only a causal-claim record can undergo claim revision"))
  (let ((parsed
          (%strict-constructor-arguments
           arguments
           '(:predicate :evidence :validation)
           'standing-inflation
           "§8.9.1 [F: CAU-2]: causal revision may replace only predicate, evidence, or validation and MUST NOT alter manifestation state")))
    (multiple-value-bind (predicate predicate-supplied-p)
        (%constructor-argument parsed :predicate)
      (multiple-value-bind (evidence evidence-supplied-p)
          (%constructor-argument parsed :evidence)
        (multiple-value-bind (validation validation-supplied-p)
            (%constructor-argument parsed :validation)
          (%validated-causal-claim
           (%causal-claim-subject claim)
           (if predicate-supplied-p
               predicate
               (%causal-claim-predicate claim))
           (if evidence-supplied-p
               evidence
               (%causal-claim-evidence claim))
           (%causal-claim-origin claim)
           (if validation-supplied-p
               validation
               (%causal-claim-validation claim))))))))
