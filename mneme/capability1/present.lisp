;;;; present.lisp — presentation of a live capability.
;;;;
;;;; PRESENT-LIVE-CAPABILITY answers exactly one question: "is this very
;;;; object a key this context minted, presented under its exact terms,
;;;; against the validated prefix it was minted from — TODAY?"  Three moves,
;;;; in order, each with its own typed refusal:
;;;;
;;;;   1. RECOGNITION — is this very object (EQ) one this context minted?
;;;;      Counterfeits with identical public fields, decoded receipts,
;;;;      printed-form mimics, and sibling contexts' genuine keys all
;;;;      refuse HERE (cap1-unrecognized-object).
;;;;   2. TERM DISCIPLINE — the caller states the exact terms it presents
;;;;      the key FOR; all four must match the minted terms by exact
;;;;      canonical equality; an omitted term is a mismatch
;;;;      (cap1-term-mismatch).  Adjudication: presentation carries the
;;;;      object's own terms AND the caller's requested terms must match
;;;;      exactly — the stricter of the two readings the owner's charge
;;;;      offered, because a presentation that names no terms is a key
;;;;      waved at the building rather than put into a lock.
;;;;   3. FRESH PREFIX CHECK — a FRESH validate-journal, every time; the
;;;;      object's four binding facets against the CURRENT validated
;;;;      prefix; any mismatch refuses with cap1-stale-capability naming
;;;;      BOTH prefixes; a :corruption prefix refuses with kernel0's
;;;;      journal-prefix-invalid (the /0 fold's adjudication, adopted).
;;;;      The context recognizes; the journal decides.
;;;;
;;;; Success returns a PRESENTATION RECEIPT (public, truthful, prefix-bound
;;;; canonical CD/0 record).  Refusals are TYPED SIGNALS ONLY — no refusal
;;;; presentation receipts exist in this lane.  Adjudication (mirrors /0's
;;;; answerability split, one step further): a presentation refusal is not
;;;; a truth about the validated prefix alone — recognition is a process-
;;;; local fact no reader could re-derive from bytes — so issuing a durable
;;;; refusal record would manufacture testimony that history cannot check.
;;;;
;;;; HONEST SUBSUMPTION, adjudicated and inherited by every caller: under
;;;; exact prefix binding, ANY journal advance — including the advance that
;;;; contains this capability's own matching revocation — makes presentation
;;;; refuse as STALE.  Revocation therefore distinctly governs MINTING: a
;;;; fresh mint after revocation refuses because the fresh /0 derivation
;;;; refuses, naming the revoking event (mint.lisp; controls).
;;;;
;;;; NO EFFECT EXECUTION — presentation reads; it never writes, unlocks, or
;;;; executes.  There is no effect machinery anywhere in this slice.
;;;;
;;;; — CLAVIGER-II (Claude Fable 5 subagent), 2026-07-29

(in-package #:lisp-plus-capability1)

(defvar +present-procedure-segments+ '("lisp-plus-capability1"
                                       "present-live-capability"))
(defvar +present-procedure-version+ 0)

(defun %check-presentation-bootstrap (store bootstrap)
  "Presentation's explicit-bootstrap gate.  The MEANING is identical to
/0's derivation-entry gate, so /0's exported conditions are signaled (reuse
where honest, never both); only the requirement-ids are this lane's."
  (unless (bootstrap-authority-p bootstrap)
    (error 'cap0-bootstrap-missing
           :requirement-id "CAP1-BOOT-1"
           :detail "no explicit bootstrap authority was supplied to ~
                    presentation; nothing is checked on ambient identity"))
  (let ((declared (bootstrap-authority-store-id bootstrap))
        (actual (journal-store-store-id store)))
    (unless (and (stringp declared) (string= declared actual))
      (error 'cap0-bootstrap-store-mismatch
             :requirement-id "CAP1-BOOT-2"
             :expected declared
             :actual actual
             :detail "the declared bootstrap binds a different store ~
                      identity")))
  bootstrap)

(defun %presented-public-id-string (object)
  "The PRESENTED object's claimed public identity, when one is legible.
A claim for the refusal report — never a credential."
  (cond ((live-capability-p object)
         (identifier-segment-string (%live-capability-public-id object)))
        ((and object
              (lisp-plus-cd0:record-datum-p object)
              (record-field object "receipt" "capability-public-id"))
         (identifier-segment-string
          (record-field object "receipt" "capability-public-id")))
        (t nil)))

(defun %recognizedp (context object defect)
  "Strict recognition is EQ membership.  The two non-strict branches are
PLANTED DEFECTS (mutants.lisp), selectable only by explicit DEFECT keyword,
kept alive here precisely to be killed:
  :serializable-authority — recognition by PUBLIC-IDENTITY equality, i.e.
      recognition a printed/serialized description can satisfy;
  :public-constructor    — recognition by TYPE, i.e. what the world would
      be if constructing the struct granted recognition."
  (ecase (if (member defect '(:serializable-authority :public-constructor))
             defect
             :strict)
    (:strict
     (nth-value 1 (gethash object (%minting-context-recognitions context))))
    (:serializable-authority
     (and (live-capability-p object)
          (loop for minted being the hash-keys
                  of (%minting-context-recognitions context)
                  thereis (datum= (%live-capability-public-id minted)
                                  (%live-capability-public-id object)))))
    (:public-constructor
     (live-capability-p object))))

(defun %presentation-receipt (object presentation-id
                              &key store-id terminal-ordinal valid-byte-count
                                   terminal-digest tail-offset tail-sha256)
  (let ((entries
          (list
           (%cap1-field '("receipt" "kind")
                        (identifier-from-segments '("cap1" "presentation")))
           (%cap1-field '("receipt" "decision")
                        (identifier-from-segments '("cap1" "presented")))
           (%cap1-field '("receipt" "capability-public-id")
                        (%live-capability-public-id object))
           (%cap1-field '("receipt" "occurrence-id")
                        (%live-capability-occurrence-id object))
           (%cap1-field '("receipt" "subject")
                        (%live-capability-subject object))
           (%cap1-field '("receipt" "action")
                        (%live-capability-action object))
           (%cap1-field '("receipt" "resource")
                        (%live-capability-resource object))
           (%cap1-field '("receipt" "scope")
                        (%live-capability-scope object))
           (%cap1-field '("receipt" "store-id")
                        (lisp-plus-cd0:make-string-datum store-id))
           (%cap1-field '("receipt" "terminal-ordinal")
                        (lisp-plus-cd0:make-integer-datum terminal-ordinal))
           (%cap1-field '("receipt" "valid-byte-count")
                        (lisp-plus-cd0:make-integer-datum valid-byte-count))
           (%cap1-field '("receipt" "terminal-digest")
                        (lisp-plus-cd0:make-string-datum terminal-digest))
           (%cap1-field '("receipt" "presentation-id") presentation-id)
           (%cap1-field '("receipt" "procedure-id")
                        (identifier-from-segments
                         +present-procedure-segments+))
           (%cap1-field '("receipt" "procedure-version")
                        (lisp-plus-cd0:make-integer-datum
                         +present-procedure-version+)))))
    ;; Law 9: a torn tail under the current prefix is surfaced, never hidden.
    (when tail-offset
      (setf entries
            (append entries
                    (list (%cap1-field '("receipt" "tail-offset")
                                       (lisp-plus-cd0:make-integer-datum
                                        tail-offset))
                          (%cap1-field '("receipt" "tail-sha256")
                                       (lisp-plus-cd0:make-string-datum
                                        tail-sha256))))))
    (lisp-plus-cd0:make-record-datum entries)))

(defun present-live-capability (store bootstrap context object
                                &key subject action resource scope
                                     presentation-id defect)
  "Present OBJECT as live authority for the EXACT terms
SUBJECT/ACTION/RESOURCE/SCOPE.  Returns a presentation receipt on success;
signals a typed condition on every refusal (see file header).
PRESENTATION-ID is the caller-declared identity of this presentation
occurrence (identifier datum or segment list; required).  DEFECT selects a
planted mutant (mutants.lisp); the strict path is DEFECT = NIL."
  (%check-context context)
  (%check-presentation-bootstrap store bootstrap)
  (let ((presentation-id (ensure-identifier presentation-id
                                            :what "presentation-id"))
        (subject (and subject (ensure-identifier subject :what "subject")))
        (action (and action (ensure-identifier action :what "action")))
        (resource (and resource (ensure-identifier resource
                                                   :what "resource")))
        (scope (and scope (ensure-identifier scope :what "scope"))))
    ;; 1. RECOGNITION.
    (unless (%recognizedp context object defect)
      (error 'cap1-unrecognized-object
             :requirement-id "CAP1-REC-1"
             :presented-type (type-of object)
             :presented-public-id (%presented-public-id-string object)
             :context-label (%minting-context-label context)
             :detail "this minting context did not mint the presented ~
                      object; no public field can make it have done so"))
    ;; 2. TERM DISCIPLINE (exact canonical equality; omission = mismatch).
    (let ((mismatches
            (loop for (name requested held)
                    in (list (list "subject" subject
                                   (%live-capability-subject object))
                             (list "action" action
                                   (%live-capability-action object))
                             (list "resource" resource
                                   (%live-capability-resource object))
                             (list "scope" scope
                                   (%live-capability-scope object)))
                  unless (and requested (datum= requested held))
                    collect name)))
      (when mismatches
        (error 'cap1-term-mismatch
               :requirement-id "CAP1-TERM-1"
               :capability-public-id (identifier-segment-string
                                      (%live-capability-public-id object))
               :mismatched-terms mismatches
               :detail "requested terms must equal the minted terms ~
                        exactly; an omitted term is a mismatch")))
    ;; 3. FRESH PREFIX CHECK — except under the PLANTED liveness-cache
    ;; defect, which answers from recognition alone and never consults the
    ;; journal: the exact decay this lane forbids, kept alive to be killed.
    (if (eq defect :context-as-liveness-cache)
        (%presentation-receipt
         object presentation-id
         :store-id (%live-capability-store-id object)
         :terminal-ordinal (%live-capability-terminal-ordinal object)
         :valid-byte-count (%live-capability-valid-byte-count object)
         :terminal-digest (%live-capability-terminal-digest object))
        (let ((report (validate-journal store)))
          (when (eq :corruption (prefix-report-status report))
            (lisp-plus-kernel0:signal-kernel0
             'lisp-plus-kernel0:journal-prefix-invalid
             :failed-invariant
             (format nil "the present prefix is invalid (~a); no ~
                          capability can be checked against it"
                     (prefix-report-condition-type report))
             :requirement-id "CAP1-PRES-2"
             :evidence-ids (list (prefix-report-condition-type report))))
          (let ((current-store-id (journal-store-store-id store))
                (current-ordinal (prefix-report-frame-count report))
                (current-bytes (prefix-report-valid-byte-count report))
                (current-digest (prefix-report-terminal-digest report)))
            (unless (and (string= (%live-capability-store-id object)
                                  current-store-id)
                         (= (%live-capability-terminal-ordinal object)
                            current-ordinal)
                         (= (%live-capability-valid-byte-count object)
                            current-bytes)
                         (string= (%live-capability-terminal-digest object)
                                  current-digest))
              (error 'cap1-stale-capability
                     :requirement-id "CAP1-STALE-1"
                     :capability-store-id (%live-capability-store-id object)
                     :capability-terminal-ordinal
                     (%live-capability-terminal-ordinal object)
                     :capability-valid-byte-count
                     (%live-capability-valid-byte-count object)
                     :capability-terminal-digest
                     (%live-capability-terminal-digest object)
                     :present-store-id current-store-id
                     :present-terminal-ordinal current-ordinal
                     :present-valid-byte-count current-bytes
                     :present-terminal-digest current-digest
                     :detail "the journal decided; the context only ~
                              recognized"))
            (%presentation-receipt
             object presentation-id
             :store-id current-store-id
             :terminal-ordinal current-ordinal
             :valid-byte-count current-bytes
             :terminal-digest current-digest
             :tail-offset (and (eq :torn-tail (prefix-report-status report))
                               (prefix-report-tail-offset report))
             :tail-sha256 (and (eq :torn-tail (prefix-report-status report))
                               (prefix-report-tail-sha256 report))))))))
