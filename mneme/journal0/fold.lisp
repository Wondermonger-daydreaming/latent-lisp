;;;; fold.lisp — §16/§17 fold integration, §12 step 16 (the Kernel semantic
;;;; fold), reconstruction (§19 + K0E-9/K0E-11/PJ-RCN-3), and §20 merge.
;;;;
;;;; §17.1: the Kernel fold consumes abstract events decoded from the longest
;;;; structurally valid prefix; a torn tail contributes tail evidence, no
;;;; event.  §17.2: the store NEVER manufactures a smaller lawful prefix by
;;;; skipping an event.  K0E-26: the joint report carries TWO verdicts,
;;;; structural and semantic — a single green counter is nonconforming.

(in-package #:lisp-plus-journal0)

;;; ---------------------------------------------------------------------------
;;; Fold source (§17.1).

(defun fold-source-events (store)
  "The longest-prefix fold source: (values events-vector report).  Identical
prefix regardless of the tail's classification."
  (let ((report (validate-journal store)))
    (values (prefix-report-events report) report)))

;;; ---------------------------------------------------------------------------
;;; Projection: stored CD/0 event records -> in-memory Kernel /0 events.
;;;
;;; Procedure descriptor (K0E-23): procedure-id
;;; (id "lisp-plus-journal0" "kernel-event-projection") version 0, judgment
;;; class :semantic-input-adapter.  The projection recognizes a stored kind
;;; identifier (id NS.. NAME) as the Kernel §13.3 keyword whose name is the
;;; segments joined with "-" IFF that keyword is in Kernel /0's closed
;;; vocabulary; every other kind projects as an explicit extension event
;;; (Kernel §13.3: extension events MUST NOT alter kernel event semantics).
;;; No interning of attacker text: the keyword is selected from the FIXED
;;; +kernel0-event-types+ list by string comparison, never constructed.

(defun %kind-keyword (kind-identifier)
  "The Kernel /0 event-type keyword matching KIND-IDENTIFIER, or NIL."
  (let ((name (identifier-segment-string kind-identifier :separator "-")))
    (find name lisp-plus-kernel0:+kernel0-event-types+
          :test (lambda (name keyword) (string-equal name
                                                     (symbol-name keyword))))))

(defun %projected-identity (identifier domain)
  "A Kernel durable identity for a stored CD/0 identifier: DOMAIN keyword +
the identifier's segments joined with \":\" as the stable name."
  (lisp-plus-kernel0:make-identity
   domain (identifier-segment-string identifier)))

(defun project-kernel-events (events)
  "Project a vector/list of stored CD/0 event records into Kernel /0
in-memory events for the semantic fold.  Returns (values kernel-events
extension-count unprojected), where UNPROJECTED names stored fields the
projection could not carry (named gaps, never silently dropped)."
  (let ((kernel-events '())
        (extension-count 0)
        (unprojected '()))
    (map nil
         (lambda (event)
           (let* ((kind (record-field event "event" "kind"))
                  (keyword (and kind (%kind-keyword kind)))
                  (process-id (record-field event "event" "process-id"))
                  (seat-id (record-field event "event" "seat-id"))
                  (attempt (record-field event "event" "attempt"))
                  (event-id (record-field event "event" "event-id"))
                  (body (record-field event "event" "body"))
                  ;; The demo vocabulary stores seat/attempt identities inside
                  ;; the body for some kinds; carry what is present.
                  (body-seat (and body (lisp-plus-cd0:record-datum-p body)
                                  (or (record-field body "seat" "seat-id")
                                      (record-field body "attempt" "seat-id"))))
                  (body-attempt (and body (lisp-plus-cd0:record-datum-p body)
                                     (record-field body "attempt"
                                                   "attempt-id"))))
             (declare (ignorable event-id))
             (let ((attempt-identifier
                     (or (and attempt
                              (lisp-plus-cd0:identifier-datum-p attempt)
                              attempt)
                         (and body-attempt
                              (lisp-plus-cd0:identifier-datum-p body-attempt)
                              body-attempt)))
                   (seat-identifier
                     (or (and seat-id
                              (lisp-plus-cd0:identifier-datum-p seat-id)
                              seat-id)
                         (and body-seat
                              (lisp-plus-cd0:identifier-datum-p body-seat)
                              body-seat))))
               (unless keyword (incf extension-count))
               (push
                (lisp-plus-kernel0:make-kernel0-event
                 :event-type (or keyword :journal0-extension-event)
                 :extension-p (if keyword nil t)
                 :process-id (and process-id
                                  (lisp-plus-cd0:identifier-datum-p process-id)
                                  (%projected-identity process-id :process))
                 :seat-id (and seat-identifier
                               (%projected-identity seat-identifier :seat))
                 :attempt-id (and attempt-identifier
                                  (%projected-identity attempt-identifier
                                                       :attempt)))
                kernel-events)
               ;; Named gap: stored body payloads are CD/0 datums; Kernel /0's
               ;; in-memory payload convention is a keyword plist of live
               ;; records (kernel0 folds.lisp).  This projection does not
               ;; fabricate live records it cannot derive; the gap is named.
               (when (and body keyword)
                 (push (list :event-kind keyword
                             :gap "body datum not projected to kernel ~
                                   payload records (K0E-9 by-reference rule)")
                       unprojected)))))
         events)
    (values (reverse kernel-events) extension-count (reverse unprojected))))

;;; ---------------------------------------------------------------------------
;;; K0E-26 joint structural+semantic report — §12 step 16.

(defun joint-structural-semantic-report (store)
  "TWO verdicts, never one green counter.  Structural: this store's §12/§13
validator.  Semantic: Kernel /0's adopted VALIDATE-EVENT-SEQUENCE over the
projected recognized events.  Structural PASS with semantic FAIL is lawful
and is reported exactly so (K0E-26)."
  (multiple-value-bind (events report) (fold-source-events store)
    (multiple-value-bind (kernel-events extension-count unprojected)
        (project-kernel-events events)
      (let ((structural-pass (eq (prefix-report-status report) :valid))
            (semantic-value :pass)
            (semantic-conditions '()))
        (handler-case
            (lisp-plus-kernel0:validate-event-sequence kernel-events)
          (lisp-plus-kernel0:kernel0-condition (condition)
            (setf semantic-value :fail)
            (push (type-of condition) semantic-conditions)))
        (list
         :structural-verdict
         (list :value (if structural-pass :pass :fail)
               :procedure-id "lisp-plus-journal0:validate-event-octets/0"
               :condition-ids (if structural-pass
                                  '()
                                  (list (prefix-report-condition-type report)))
               :requirement-ids (remove nil
                                        (list (prefix-report-condition-requirement
                                               report))))
         :semantic-verdict
         (list :value semantic-value
               :procedure-id "lisp-plus-kernel0:validate-event-sequence/0"
               :condition-ids semantic-conditions
               :requirement-ids '("K0E-25"))
         :frame-count (prefix-report-frame-count report)
         :extension-event-count extension-count
         :named-projection-gaps (length unprojected)
         :tail-evidence (when (prefix-report-tail-sha256 report)
                          (list :offset (prefix-report-tail-offset report)
                                :octets (length (prefix-report-tail-octets
                                                 report))
                                :sha256 (prefix-report-tail-sha256 report)))
         ;; K0E-15 composition: a torn tail that could contain a
         ;; consequential settlement record yields bounded standing in the
         ;; Kernel fold; the tail evidence above is the journal's half.
         :tail-could-hide-settlement-p
         (eq (prefix-report-status report) :torn-tail))))))

;;; ---------------------------------------------------------------------------
;;; §17.3 / PJ-FOLD-4 — unsupported reconstruction.

(defun derive-seat-resolution (store seat-segments)
  "Derive current occupancy for the seat named by SEAT-SEGMENTS from the
fold source.  Multiple non-superseded unresolved attempts with no lawful
relation MUST stop with UNSUPPORTED-RECONSTRUCTION (PJ-FOLD-4): the fold
never selects the newest, highest-ordinal, or most complete attempt."
  (let* ((events (fold-source-events store))
         (target (identifier-segment-string
                  (identifier-from-segments seat-segments)))
         (open-attempts '()))
    (map nil
         (lambda (event)
           (let* ((kind (record-field event "event" "kind"))
                  (kind-string (and kind (identifier-segment-string kind)))
                  (attempt (record-field event "event" "attempt"))
                  (body (record-field event "event" "body"))
                  (seat (or (record-field event "event" "seat-id")
                            (and body (lisp-plus-cd0:record-datum-p body)
                                 (or (record-field body "attempt" "seat-id")
                                     (record-field body "seat" "seat-id"))))))
             (when (and seat (string= (identifier-segment-string seat) target))
               (cond
                 ((and kind-string
                       (member kind-string '("attempt:begun" "attempt:prepared")
                               :test #'string=)
                       attempt (lisp-plus-cd0:identifier-datum-p attempt))
                  (pushnew (identifier-segment-string attempt) open-attempts
                           :test #'string=))
                 ((and kind-string
                       (member kind-string
                               '("attempt:completed" "attempt:failed"
                                 "attempt:refused" "attempt:cancelled"
                                 "attempt:superseded" "attempt:reconciled")
                               :test #'string=)
                       attempt (lisp-plus-cd0:identifier-datum-p attempt))
                  (setf open-attempts
                        (remove (identifier-segment-string attempt)
                                open-attempts :test #'string=)))))))
         events)
    (cond
      ((null open-attempts) (values :vacant nil))
      ((null (rest open-attempts)) (values :occupied (first open-attempts)))
      (t (with-pj0-restarts (:abandon t)
           (signal-pj0 'unsupported-reconstruction
                       :store-id (journal-store-store-id store)
                       :requirement-id "PJ-FOLD-4"
                       :evidence open-attempts
                       :detail (format nil "~a non-superseded unresolved ~
                                            attempts occupy seat ~a with no ~
                                            lawful precedence relation"
                                       (length open-attempts) target)))))))

;;; ---------------------------------------------------------------------------
;;; Reconstruction (§19; K0E-11: fresh replay from byte zero; PJ-RCN-3 /
;;; Errata §8 control 12: derived artifacts are DELETED before replay and
;;; the deletion is attested in the receipt).

(defun %derived-artifact-paths (store)
  "Every derived artifact under the store's derived/ area (PJ-FS-2:
deletable without deleting primary history)."
  (let ((derived-directory (merge-pathnames "derived/"
                                            (journal-store-directory store))))
    (when (probe-file derived-directory)
      (directory (merge-pathnames "*.*" derived-directory)))))

(defun reconstruct (store fold-segments &key requested-terminal-ordinal)
  "Re-derive a fold view from primary records alone.  Deletes every derived
artifact FIRST and attests the deletion (PJ-RCN-3, K0E-9).  A request to
reconstruct beyond the validated prefix is REFUSED — reconstruction never
skips or reaches past corruption (K0E-11, Errata §8 control 11).
Returns (values view receipt-record)."
  (let* ((deleted (mapcar #'namestring (%derived-artifact-paths store)))
         (report (progn (mapc #'delete-file (%derived-artifact-paths store))
                        (validate-journal store))))
    (when (and requested-terminal-ordinal
               (> requested-terminal-ordinal
                  (prefix-report-frame-count report)))
      (with-pj0-restarts (:abandon t)
        (signal-pj0 'unsupported-reconstruction
                    :store-id (journal-store-store-id store)
                    :requirement-id "K0E-11"
                    :detail (format nil "ordinal ~a is beyond the validated ~
                                         prefix (~a frames); reconstruction ~
                                         never scans past damage"
                                    requested-terminal-ordinal
                                    (prefix-report-frame-count report)))))
    (let* ((events (prefix-report-events report))
           ;; The /0 reference fold view: event count + event-id sequence +
           ;; terminal coordinate.  Deterministic; replayable byte-for-byte.
           (view
             (lisp-plus-cd0:make-record-datum
              (list
               (lisp-plus-cd0:make-record-entry
                (identifier-from-segments '("view" "event-count"))
                (lisp-plus-cd0:make-integer-datum
                 (prefix-report-frame-count report)))
               (lisp-plus-cd0:make-record-entry
                (identifier-from-segments '("view" "event-ids"))
                (lisp-plus-cd0:make-sequence-datum
                 (loop for index below (fill-pointer
                                        (prefix-report-event-ids report))
                       collect (aref (prefix-report-event-ids report) index))))
               (lisp-plus-cd0:make-record-entry
                (identifier-from-segments '("view" "terminal-digest"))
                (lisp-plus-cd0:make-bytes-datum
                 (hex->octets (prefix-report-terminal-digest report))))))))
      (declare (ignorable events))
      (flet ((field (key value)
               (lisp-plus-cd0:make-record-entry
                (identifier-from-segments key) value)))
        (values
         view
         (lisp-plus-cd0:make-record-datum
          (list
           (field '("reconstruction" "source-store-id")
                  (record-field (journal-store-metadata store)
                                "pj0" "store-id"))
           (field '("reconstruction" "terminal-ordinal")
                  (lisp-plus-cd0:make-integer-datum
                   (prefix-report-frame-count report)))
           (field '("reconstruction" "terminal-digest")
                  (lisp-plus-cd0:make-bytes-datum
                   (hex->octets (prefix-report-terminal-digest report))))
           (field '("reconstruction" "fold-id")
                  (identifier-from-segments fold-segments))
           (field '("reconstruction" "derived-artifacts-deleted")
                  (lisp-plus-cd0:make-sequence-datum
                   (mapcar #'lisp-plus-cd0:make-string-datum deleted)))
           (field '("reconstruction" "output-digest")
                  (lisp-plus-cd0:make-bytes-datum
                   (sha256-octets (encode-pjs0 view))))
           ;; L10 / PJ-RCN-1: origin is and remains :reconstructed.
           (field '("reconstruction" "origin")
                  (identifier-from-segments '("origin" "reconstructed"))))))))))

;;; ---------------------------------------------------------------------------
;;; §20 cross-journal merge — explicit precedence, never timestamps.

(defun merge-journals (source-directories precedence destination-directory
                       authority &key causal-predecessors)
  "Merge the stores at SOURCE-DIRECTORIES into a NEW store.  PRECEDENCE must
be the explicit list of source position indices (0-based) in precedence
order covering every source — the §20.2 rule (explicit precedence, then
source ordinal).  A missing/partial precedence is refused
(PJ-MRG-1/pj0-merge-receipt-required: timestamps never order a merge).
CAUSAL-PREDECESSORS is a list of (EARLIER-EVENT-ID-STRING
LATER-EVENT-ID-STRING) pairs validated against the merged order
(§20.4).  Duplicate identical events coalesce with an equivalence entry;
conflicting payloads under one identity refuse (§20.3).
Returns (values destination-store merge-receipt-record)."
  (unless (and precedence
               (= (length precedence) (length source-directories))
               (every (lambda (index)
                        (and (integerp index) (< -1 index
                                                 (length source-directories))))
                      precedence)
               (= (length (remove-duplicates precedence))
                  (length precedence)))
    (with-pj0-restarts (:abandon t)
      (signal-pj0 'pj0-merge-receipt-required
                  :requirement-id "PJ-MRG-1"
                  :detail "merge requires an explicit total source ~
                           precedence; timestamp or implicit ordering is ~
                           prohibited")))
  (let* ((sources (mapcar #'open-store source-directories))
         (reports (mapcar (lambda (store) (validate-journal store)) sources))
         (merged '())            ; (id-string payload-octets datum source)
         (coalesced '())
         (destination (create-journal destination-directory)))
    (dolist (position precedence)
      (let ((report (nth position reports)))
        (loop for index below (fill-pointer (prefix-report-events report))
              for datum = (aref (prefix-report-events report) index)
              for event-id = (aref (prefix-report-event-ids report) index)
              for id-string = (identifier-segment-string event-id)
              for payload = (encode-pjs0 datum)
              for existing = (assoc id-string merged :test #'string=)
              do (cond
                   ((null existing)
                    (push (list id-string payload datum position) merged))
                   ((%octets-equal-p (second existing) payload)
                    ;; §20.3: identical — coalesce with equivalence record.
                    (push (list id-string (fourth existing) position)
                          coalesced))
                   (t
                    (with-pj0-restarts (:abandon t)
                      (signal-pj0 'pj0-event-identity-collision
                                  :requirement-id "PJ0-§20.3"
                                  :detail (format nil "conflicting payloads ~
                                                       for ~a across sources"
                                                  id-string))))))))
    (let ((ordered (reverse merged)))
      ;; §20.4 explicit causal validation.
      (dolist (pair causal-predecessors)
        (destructuring-bind (earlier later) pair
          (let ((earlier-position (position earlier ordered
                                            :key #'first :test #'string=))
                (later-position (position later ordered
                                          :key #'first :test #'string=)))
            (when (and earlier-position later-position
                       (> earlier-position later-position))
              (with-pj0-restarts (:abandon t)
                (signal-pj0 'pj0-merge-causal-conflict
                            :requirement-id "PJ0-§20.4"
                            :detail (format nil "declared precedence places ~
                                                 ~a before its causal ~
                                                 predecessor ~a"
                                            later earlier)))))))
      (dolist (entry ordered)
        (append-event destination (third entry)))
      (flet ((field (key value)
               (lisp-plus-cd0:make-record-entry
                (identifier-from-segments key) value)))
        (values
         destination
         (lisp-plus-cd0:make-record-datum
          (list
           (field '("merge" "source-store-ids")
                  (lisp-plus-cd0:make-sequence-datum
                   (mapcar (lambda (store)
                             (record-field (journal-store-metadata store)
                                           "pj0" "store-id"))
                           sources)))
           (field '("merge" "precedence")
                  (lisp-plus-cd0:make-sequence-datum
                   (mapcar #'lisp-plus-cd0:make-integer-datum precedence)))
           (field '("merge" "coalesced-duplicates")
                  (lisp-plus-cd0:make-sequence-datum
                   (mapcar (lambda (entry)
                             (lisp-plus-cd0:make-string-datum (first entry)))
                           coalesced)))
           (field '("merge" "destination-store-id")
                  (record-field (journal-store-metadata destination)
                                "pj0" "store-id"))
           (field '("merge" "operator-authority")
                  (identifier-from-segments authority))
           ;; §20.5: the output journal's origin is derived/reconstructed.
           (field '("merge" "output-origin")
                  (identifier-from-segments '("origin" "reconstructed"))))))))))
