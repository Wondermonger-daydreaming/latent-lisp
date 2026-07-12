(in-package #:leibnitiana)

;;;; -------------------------------------------------------------------------
;;;; Receipt lineage: append-only shape, chained integrity, bounded custody
;;;; -------------------------------------------------------------------------

(defconstant +receipt-genesis-hash+ "0000000000000000")

(defun %canonical-prin1 (object)
  "Return a deterministic textual representation for the specimen's data.

This is adequate for the constrained plist/list payloads used in this chamber.
It is not a universal canonical serialization format. A production interchange
layer must specify character encoding, package treatment, numeric forms,
cycles, normalization, and reader safety much more strictly."
  (with-standard-io-syntax
    (let ((*print-pretty* nil)
          (*print-circle* t)
          (*print-readably* t)
          (*print-case* :upcase))
      (prin1-to-string object))))

(defun %fnv1a-64 (string)
  "Return a fixed-width FNV-1a digest for STRING.

FNV-1a is used here only to make the chain executable without dependencies.
It is NOT collision-resistant cryptography. The architecture demonstrated by
this file requires a production digest such as SHA-256 or BLAKE3, and usually a
signature or independently witnessed checkpoint, before adversarial standing
is claimed."
  (let ((hash #xcbf29ce484222325))
    (loop for character across string
          do (setf hash (logxor hash (char-code character))
                   hash (ldb (byte 64 0)
                             (* hash #x100000001b3))))
    (format nil "~16,'0X" hash)))

(defun receipt-digest (object)
  "Digest OBJECT under the chamber's dependency-free demonstration algorithm."
  (%fnv1a-64 (%canonical-prin1 object)))

(defstruct (receipt-log
            (:constructor %make-receipt-log
                (&key events head-hash algorithm)))
  (events '())
  (head-hash +receipt-genesis-hash+)
  (algorithm :fnv1a64-demonstration-only))

(defun make-receipt-log ()
  (%make-receipt-log :events '()
                     :head-hash +receipt-genesis-hash+
                     :algorithm :fnv1a64-demonstration-only))

(defun %receipt-event-material (sequence kind actor payload prior-hash)
  (list :sequence sequence
        :kind kind
        :actor actor
        :payload payload
        :prior-hash prior-hash))

(defun append-receipt-event (log kind actor payload)
  "Append one event to LOG and return the complete stored event.

The event hash binds sequence, kind, actor, payload, and prior hash. Mutation of
an earlier event therefore invalidates every later hash unless the chain is
recomputed. Recomputing can fool an internal verifier; custody checkpoints are
what make rewritten history externally contestable."
  (let* ((sequence (1+ (length (receipt-log-events log))))
         (prior-hash (receipt-log-head-hash log))
         (material (%receipt-event-material sequence kind actor payload
                                            prior-hash))
         (event-hash (receipt-digest material))
         (event (append material (list :event-hash event-hash))))
    (setf (receipt-log-events log)
          (append (receipt-log-events log) (list event))
          (receipt-log-head-hash log) event-hash)
    event))

(defun verify-receipt-log (log)
  "Verify LOG's internal sequence and hash chain.

A valid result establishes only internal self-consistency under the declared
algorithm. It does not establish that the events are truthful, complete,
unaltered before first hashing, cryptographically collision-resistant, or held
outside the curator's control."
  (let ((expected-sequence 1)
        (expected-prior +receipt-genesis-hash+)
        (failures '()))
    (dolist (event (receipt-log-events log))
      (let* ((sequence (getf event :sequence))
             (kind (getf event :kind))
             (actor (getf event :actor))
             (payload (getf event :payload))
             (prior-hash (getf event :prior-hash))
             (stored-hash (getf event :event-hash))
             (material (%receipt-event-material sequence kind actor payload
                                                prior-hash))
             (computed-hash (receipt-digest material)))
        (unless (= sequence expected-sequence)
          (push (list :sequence sequence
                      :failure :unexpected-sequence
                      :expected expected-sequence)
                failures))
        (unless (equal prior-hash expected-prior)
          (push (list :sequence sequence
                      :failure :prior-hash-mismatch
                      :expected expected-prior
                      :actual prior-hash)
                failures))
        (unless (equal stored-hash computed-hash)
          (push (list :sequence sequence
                      :failure :event-hash-mismatch
                      :expected computed-hash
                      :actual stored-hash)
                failures))
        (setf expected-prior stored-hash)
        (incf expected-sequence)))
    (unless (equal (receipt-log-head-hash log) expected-prior)
      (push (list :failure :head-hash-mismatch
                  :expected expected-prior
                  :actual (receipt-log-head-hash log))
            failures))
    (list :internally-valid (null failures)
          :event-count (length (receipt-log-events log))
          :head-hash (receipt-log-head-hash log)
          :algorithm (receipt-log-algorithm log)
          :failures (nreverse failures)
          :standing :internal-self-consistency-only)))

(defun receipt-prefix-hash (log event-count)
  "Return the stored hash at EVENT-COUNT, or genesis for zero."
  (cond
    ((zerop event-count) +receipt-genesis-hash+)
    ((or (minusp event-count)
         (> event-count (length (receipt-log-events log))))
     (error "Checkpoint count ~D is outside log length ~D."
            event-count (length (receipt-log-events log))))
    (t
     (getf (nth (1- event-count) (receipt-log-events log)) :event-hash))))

(defstruct (custody-checkpoint
            (:constructor make-custody-checkpoint
                (&key custodian event-count head-hash algorithm
                      declared-relation scope notes)))
  custodian
  event-count
  head-hash
  algorithm
  declared-relation
  scope
  notes)

(defun witness-receipt (log custodian
                        &key
                          (declared-relation :unspecified)
                          (scope :prefix-head-only)
                          notes)
  "Create a checkpoint from LOG's current prefix.

DECLARED-RELATION is testimony, not enforced identity or independence. A caller
may say :EXTERNAL-TO-CURATOR; this constructor cannot prove the statement."
  (make-custody-checkpoint
   :custodian custodian
   :event-count (length (receipt-log-events log))
   :head-hash (receipt-log-head-hash log)
   :algorithm (receipt-log-algorithm log)
   :declared-relation declared-relation
   :scope scope
   :notes notes))

(defun verify-custody-checkpoint (log checkpoint)
  "Compare LOG's checkpointed prefix with CHECKPOINT."
  (let* ((count (custody-checkpoint-event-count checkpoint))
         (available (<= count (length (receipt-log-events log))))
         (actual (when available (receipt-prefix-hash log count)))
         (expected (custody-checkpoint-head-hash checkpoint))
         (match (and available (equal actual expected))))
    (list :checkpoint-match match
          :checkpoint-event-count count
          :log-event-count (length (receipt-log-events log))
          :expected-head expected
          :actual-head actual
          :custodian (custody-checkpoint-custodian checkpoint)
          :declared-relation
          (custody-checkpoint-declared-relation checkpoint)
          :algorithm (custody-checkpoint-algorithm checkpoint)
          :standing
          (cond
            ((not available) :log-shorter-than-witnessed-prefix)
            (match :prefix-consistent-with-checkpoint)
            (t :witnessed-prefix-diverges))
          :boundary
          :checkpoint-compares-history-but-does-not-authenticate-custodian)))

(defun rebuild-receipt-log (bare-events)
  "Build a fresh chained log from BARE-EVENTS.

Each bare event is a plist containing :KIND, :ACTOR, and :PAYLOAD. This helper is
useful both for legitimate import and for demonstrating that a curator can
rewrite events and recompute a perfectly valid internal chain."
  (let ((log (make-receipt-log)))
    (dolist (event bare-events log)
      (append-receipt-event log
                            (getf event :kind)
                            (getf event :actor)
                            (getf event :payload)))))
