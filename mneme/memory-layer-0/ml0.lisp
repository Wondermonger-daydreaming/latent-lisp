;;;; ml0.lisp — Memory Layer /0: the lane.
;;;;
;;;; ONE object is added to the language, and nothing else: a DURABLE ACCOUNT OF
;;;; ONE ACT that can be written by one process and reconstructed by another,
;;;; and that says exactly what it is entitled to say.
;;;;
;;;; THE DISCIPLINE, inherited wholesale and re-stated here in this lane's own
;;;; code:
;;;;
;;;;   * the promotion rule is computed BY READING DURABLE BYTES, never by
;;;;     reading a condition's type name, a claim's own text, or the fact that a
;;;;     serialization succeeded.  (act1-derive-class's governing sentence,
;;;;     act1.lisp:1139-1140, applied to a different question.)
;;;;   * a recording that is never read back is not a binding; it is a hope with
;;;;     a field name.  Every account this lane writes is read back through
;;;;     `validate-journal`, which re-reads the bytes from disk.
;;;;   * absence is MEASURED, not narrated: every scope carries its declared
;;;;     universe and a :LOOKED / :COULD-NOT-LOOK status, and no comparison in
;;;;     this lane conflates the two.
;;;;   * an unadmitted host fault may not wear a semantic refusal's clothes.
;;;;     The admitted condition families are enumerated BY ROOT, each root read
;;;;     out of that lane's own package.lisp; everything else is a typed
;;;;     `ml0-bridge-contract-violated` with no account, no standing, and no
;;;;     discriminant written.
;;;;
;;;; ⚠ WHAT THIS LANE NEVER DOES, by construction and not by intention: it never
;;;; performs an act, never mints or promotes a Core /0 evidence account, never
;;;; authorizes a capability, never calls `continue-from`, never writes the
;;;; world, and never appends to any store but its own.
;;;;
;;;; ⚑ DEFINITION ORDER IS LOAD ORDER.  Retrieve is defined before Write because
;;;; Write READS BACK what it wrote through Retrieve; the narrative order of the
;;;; commission (write / retrieve / consolidate) is the SPEC's order, and the
;;;; spec says so.  No forward reference is left in this file.
;;;;
;;;; CANDIDATE.  Nothing here is adopted, and nothing here is independent
;;;; verification.
;;;;
;;;; — TABULARIUS (Claude Opus 5, subagent), 2026-08-20

(in-package #:lisp-plus-memory-layer0)

;;; ===========================================================================
;;; §0 — the check harness (shared by the suites, the controls and the mutants).
;;; ===========================================================================

(defvar *ml0-checks-passed* 0)
(defvar *ml0-checks-failed* 0)

(defun ml0-note (control &rest arguments)
  (format t "~&      | ~a~%" (apply #'format nil control arguments)))

(defun ml0-check (name ok &optional (control "") &rest arguments)
  "NAME is folded through FORMAT with no arguments, so a source-wrapped label
prints as one line."
  (if ok (incf *ml0-checks-passed*) (incf *ml0-checks-failed*))
  (format t "~&[~3,'0d] ~a ~a~@[ ~a~]~%"
          (+ *ml0-checks-passed* *ml0-checks-failed*)
          (if ok "ok  " "FAIL") (format nil name)
          (and (plusp (length control)) (apply #'format nil control arguments)))
  (finish-output)
  ok)

;;; ===========================================================================
;;; §1 — typed refusals.  Every refusal of this lane carries a requirement id;
;;; refusals are named by CONDITION TYPE + REQUIREMENT-ID, never by message text
;;; (SBCL's condition report text is not a stable interface).
;;; ===========================================================================

(define-condition ml0-condition (error)
  ((detail :initarg :detail :initform nil :reader ml0-condition-detail)
   (requirement-id :initarg :requirement-id :initform nil
                   :reader ml0-condition-requirement-id))
  (:report (lambda (c s)
             (format s "~a [~a]: ~a" (type-of c)
                     (or (ml0-condition-requirement-id c) "-")
                     (or (ml0-condition-detail c) "")))))

(define-condition ml0-source-species-refused (ml0-condition) ())
(define-condition ml0-subject-identity-mismatch (ml0-condition) ())
(define-condition ml0-provenance-incomplete (ml0-condition) ())
(define-condition ml0-scope-undeclared (ml0-condition) ())
(define-condition ml0-standing-vocabulary-refused (ml0-condition) ())
(define-condition ml0-account-encoding-refused (ml0-condition) ())
(define-condition ml0-account-readback-refused (ml0-condition) ())
(define-condition ml0-consolidation-refused (ml0-condition) ())
(define-condition ml0-bridge-contract-violated (ml0-condition) ())
(define-condition ml0-run-void (ml0-condition) ())

(defun ml0-refuse (type requirement-id control &rest arguments)
  (error type :requirement-id requirement-id
              :detail (apply #'format nil control arguments)))

;;; ===========================================================================
;;; §2 — CD/0 helpers (public constructors only) and the ORIGIN GATE.
;;; ===========================================================================

(defun idf (segments)
  "⚑ THE ORIGIN GATE SITS ON THE ONLY IDENTIFIER CONSTRUCTOR THIS LANE USES.
One Act /0's own prohibition (act0-gates.lisp:114-119) is this lane's law too: a
lane may not write a capture-provenance claim into durable bytes that it cannot
support.  Memory Layer /0 does not witness a kernel transition — it READS THE
BYTES OF A LANE THAT DID — so `origin/observed` is unmintable HERE, in code, and
not merely undertaken in prose."
  (when (and (consp segments)
             (equal (mapcar (lambda (s)
                              (and (stringp s) (string-downcase s)))
                            segments)
                    '("origin" "observed")))
    (ml0-refuse 'ml0-provenance-incomplete "ML0-ORIGIN-1"
                "origin/observed is UNMINTABLE by this lane: this lane reads the ~
bytes of a lane that witnessed, and a reader's account of what it read is never ~
an observation (L15; One Act /0's act0-gates.lisp:114-119)"))
  (identifier-from-segments segments))

(defun s-datum (string) (lisp-plus-cd0:make-string-datum string))
(defun i-datum (integer) (lisp-plus-cd0:make-integer-datum integer))
(defun entry (segments value)
  (lisp-plus-cd0:make-record-entry (idf segments) value))
(defun rec (&rest entries) (lisp-plus-cd0:make-record-datum entries))
(defun seq (elements) (lisp-plus-cd0:make-sequence-datum elements))
(defun oct (datum) (lisp-plus-cd0:canonical-octets datum))
(defun oct-copy (o) (lisp-plus-cd0:octets-copy o))
(defun digest-of (datum) (sha256-hex (oct-copy (oct datum))))
(defun same-datum-p (a b) (lisp-plus-cd0:equal-datum a b))

(defun hex64-p (string)
  "EXACTLY 64 lowercase hexadecimal characters — asserted by LENGTH and by
CHARACTER CLASS, never by eyeball."
  (and (stringp string) (= 64 (length string))
       (every (lambda (c) (find c "0123456789abcdef")) string)))

(defun ml0-acquisition-route-identifier (route)
  "THE ORIGIN RATCHET, taken verbatim in shape from capability /0
(receipts.lisp:25-33).  Only :LIVE-QUERY and :RECONSTRUCTED exist.  :OBSERVED is
not a member of this ECASE ON PURPOSE: a reader's fold-derived answer can never
be an observation (laws L10, L15) — passing it is a caller error, refused here in
code rather than documented and hoped for."
  (ecase route
    (:live-query    (idf '("route" "live-query")))
    (:reconstructed (idf '("route" "reconstructed")))))

(defun ml0-route-from-string (name)
  (cond ((string= name "live-query") :live-query)
        ((string= name "reconstructed") :reconstructed)
        (t (ml0-refuse 'ml0-account-readback-refused "ML0-RB-6"
                       "acquisition route ~s read from durable bytes is outside ~
the closed ratchet set {live-query, reconstructed}" name))))

;;; ===========================================================================
;;; §3 — the DECLARED OBSERVATION SCOPE.
;;;
;;; SCOPE IS PART OF THE FACT.  A scope names the universe the look covered and
;;; whether the look succeeded.  :COULD-NOT-LOOK is a distinct value from an
;;; absent byte, inherited — WITH ITS CANDIDATE STANDING TRAVELLING — from One
;;; Act /1's world-scope instrument, the tree's only executable form of the lab's
;;; absence-warrant discipline.
;;; ===========================================================================

(defstruct (ml0-scope (:constructor %make-ml0-scope (&key universe status detail)) (:copier nil))
  (universe nil :read-only t)   ; a STRING naming what the look covered
  (status nil :read-only t)     ; :looked | :could-not-look
  (detail nil :read-only t))    ; a STRING: how the look was made

(defun make-ml0-scope (&key universe status detail)
  "THE PUBLIC SCOPE DOOR.  A scope with an empty universe is REFUSED: an
undeclared universe is not a scope, it is a mood."
  (unless (and (stringp universe) (plusp (length universe)))
    (ml0-refuse 'ml0-scope-undeclared "ML0-SCOPE-1"
                "a scope MUST declare its universe as a non-empty string; got ~s"
                universe))
  (unless (member status +ml0-scope-statuses+)
    (ml0-refuse 'ml0-scope-undeclared "ML0-SCOPE-2"
                "scope status ~s is outside the declared two ~s"
                status +ml0-scope-statuses+))
  (unless (and (stringp detail) (plusp (length detail)))
    (ml0-refuse 'ml0-scope-undeclared "ML0-SCOPE-3"
                "a scope MUST declare HOW the look was made; got ~s" detail))
  (%make-ml0-scope :universe universe :status status :detail detail))

(defun ml0-scope-record (scope)
  (rec (entry '("scope" "universe") (s-datum (ml0-scope-universe scope)))
       (entry '("scope" "status")
              (s-datum (string-downcase (symbol-name (ml0-scope-status scope)))))
       (entry '("scope" "detail") (s-datum (ml0-scope-detail scope)))))

(defun ml0-scope-from-record (record)
  (let ((universe (record-field record "scope" "universe"))
        (status (record-field record "scope" "status"))
        (detail (record-field record "scope" "detail")))
    (unless (and universe status detail)
      (ml0-refuse 'ml0-account-readback-refused "ML0-RB-3"
                  "a scope record read from durable bytes is missing a field"))
    (let ((status-string (lisp-plus-cd0:string-datum-value status)))
      (make-ml0-scope
       :universe (lisp-plus-cd0:string-datum-value universe)
       :status (cond ((string= status-string "looked") :looked)
                     ((string= status-string "could-not-look") :could-not-look)
                     (t (ml0-refuse 'ml0-account-readback-refused "ML0-RB-3"
                                    "scope status ~s is outside the declared two"
                                    status-string)))
       :detail (lisp-plus-cd0:string-datum-value detail)))))

;;; ===========================================================================
;;; §4 — THE TYPED SOURCE.  "Why may the account say this?", in one immutable
;;; row, with every field the commission asks for and no field it does not.
;;;
;;; ⚑ RECORDER ≠ SUBJECT, and both are carried.  One Act /0 already warns they
;;; are not interchangeable (act0-gates.lisp:125).  Here the PRODUCER principal
;;; is the principal whose mechanism made the bytes; the RECORDER principal is
;;; the principal that put this row into an account.  For a capability /2 journal
;;; frame the producer is the kernel store and the recorder is this lane.
;;;
;;; ⚠ ORIGIN-AS-READ IS A CD/0 **STRING**, NEVER AN IDENTIFIER.  "The bytes I
;;; read carried origin/observed" is a report ABOUT a field, not a claim OF that
;;; field, and the two must not be confusable in the durable record.  A string
;;; cannot be mistaken for the identifier `origin:observed` — and §2's gate makes
;;; that identifier unmintable in this lane anyway, so the discipline is doubled
;;; rather than trusted once.
;;; ===========================================================================

(defstruct (ml0-source (:constructor %make-ml0-source (&key species acquisition-route producer-principal recorder-principal coordinate observation-scope origin-as-read subject-act-id payload-digest frontier-relation attests observation-interval validation-standing door recorded-validation)) (:copier nil))
  (species nil :read-only t)              ; a member of +ml0-source-species+
  (acquisition-route nil :read-only t)    ; :live-query | :reconstructed
  (producer-principal nil :read-only t)   ; STRING
  (recorder-principal nil :read-only t)   ; STRING
  (coordinate nil :read-only t)           ; a CD/0 record datum
  (observation-scope nil :read-only t)    ; ml0-scope
  (origin-as-read nil :read-only t)       ; STRING, verbatim from the source
  (subject-act-id nil :read-only t)       ; CD/0 identifier — WHICH act
  (payload-digest nil :read-only t)       ; STRING, 64 hex
  (frontier-relation nil :read-only t)    ; STRING: the sequence/frontier fact
  (attests nil :read-only t)              ; a member of +ml0-attestations+
  (observation-interval nil :read-only t) ; STRING: the interval the look covers
  ;; ---- the BLOCK 1 cure (2026-08-20 repair round) -------------------------
  (validation-standing nil :read-only t)  ; a member of +ml0-source-validations+
  (door nil :read-only t)                 ; the door that validated it, or :none
  (recorded-validation nil :read-only t)) ; what the BYTES said, on readback

(defun %ml0-build-source (&key species acquisition-route producer-principal
                               recorder-principal coordinate observation-scope
                               origin-as-read subject-act-id payload-digest
                               frontier-relation (attests :inconclusive)
                               observation-interval
                               (validation-standing :asserted-testimony)
                               (door :none) recorded-validation)
  "⚠ INTERNAL.  The constructor that stamps :VALIDATED-BY-DOOR; it is not exported,
and (R4.1b) the `#S` default-constructor route is refused because the struct is
BOA.  PRECISE BOUNDARY (R4.1c wording): the stamp is not exposed through the
exported, supported API — and Common Lisp package privacy is not a capability
boundary, so this is defense in depth, not the soundness boundary.  The mechanical
content of BLOCK 1's cure stands at that size: the difference between testimony
and an observation is not a field the supported API lets a caller fill in.

Shape validation lives here and is shared by both callers.  ⚠ SHAPE VALIDATION IS
NOT OBSERVATION — that conflation is what was blocked.  Every field being present,
non-empty and drawn from a closed vocabulary says nothing whatever about whether
anyone looked at anything."
  (unless (member species +ml0-source-species+)
    (ml0-refuse 'ml0-source-species-refused "ML0-SRC-1"
                "source species ~s is outside the CLOSED set ~s — an unknown ~
species is an unknown warrant and is refused, never demoted to corroboration"
                species +ml0-source-species+))
  (unless (member acquisition-route +ml0-acquisition-routes+)
    (ml0-refuse 'ml0-provenance-incomplete "ML0-SRC-2"
                "acquisition route ~s is outside the closed ratchet set ~s"
                acquisition-route +ml0-acquisition-routes+))
  ;; the ratchet is CONSULTED, not merely declared: this call refuses :observed.
  (ml0-acquisition-route-identifier acquisition-route)
  (dolist (pair (list (cons :producer-principal producer-principal)
                      (cons :recorder-principal recorder-principal)
                      (cons :origin-as-read origin-as-read)
                      (cons :frontier-relation frontier-relation)))
    (unless (and (stringp (cdr pair)) (plusp (length (cdr pair))))
      (ml0-refuse 'ml0-provenance-incomplete "ML0-SRC-3"
                  "source field ~a MUST be a non-empty string; got ~s"
                  (car pair) (cdr pair))))
  (unless (lisp-plus-cd0:record-datum-p coordinate)
    (ml0-refuse 'ml0-provenance-incomplete "ML0-SRC-4"
                "a source MUST carry a canonical coordinate as a CD/0 record; got ~s"
                coordinate))
  (unless (ml0-scope-p observation-scope)
    (ml0-refuse 'ml0-scope-undeclared "ML0-SRC-5"
                "a source MUST carry a declared observation scope"))
  (unless (and subject-act-id (lisp-plus-cd0:identifier-datum-p subject-act-id))
    (ml0-refuse 'ml0-subject-identity-mismatch "ML0-SRC-6"
                "a source MUST name the act it is about, as a CD/0 identifier"))
  (unless (hex64-p payload-digest)
    (ml0-refuse 'ml0-provenance-incomplete "ML0-SRC-7"
                "a source's canonical payload digest MUST be exactly 64 lowercase ~
hex characters; got ~s" payload-digest))
  (unless (and (stringp observation-interval) (plusp (length observation-interval)))
    (ml0-refuse 'ml0-provenance-incomplete "ML0-SRC-9"
                "a source MUST declare the OBSERVATION INTERVAL its look covers, ~
as a non-empty string.  ⚑ It is machine-readable on purpose (work order ~
AMENDMENT 1.5): two warrants are COMMENSURABLE only when they address the same ~
proposition over compatible declared scope AND a compatible frontier/sequence ~
interval, and `compatible` has to be something a program can test.  Got ~s"
                observation-interval))
  (unless (member attests +ml0-attestations+)
    (ml0-refuse 'ml0-standing-vocabulary-refused "ML0-SRC-8"
                "attestation ~s is outside the closed set ~s — what a source FOUND ~
is machine-readable or it is not a warrant" attests +ml0-attestations+))
  (unless (member validation-standing +ml0-source-validations+)
    (ml0-refuse 'ml0-standing-vocabulary-refused "ML0-SRC-10"
                "validation standing ~s is outside ~s"
                validation-standing +ml0-source-validations+))
  (%make-ml0-source :species species :acquisition-route acquisition-route
                    :producer-principal producer-principal
                    :recorder-principal recorder-principal
                    :coordinate coordinate :observation-scope observation-scope
                    :origin-as-read origin-as-read
                    :subject-act-id subject-act-id
                    :payload-digest payload-digest
                    :frontier-relation frontier-relation
                    :attests attests
                    :observation-interval observation-interval
                    :validation-standing validation-standing
                    :door door
                    :recorded-validation recorded-validation))

(defun %ml0-strip-validation-keywords (arguments)
  "⚠ A CALLER MAY NOT SMUGGLE A VALIDATION STANDING THROUGH THE TESTIMONY DOOR.
Passing :validation-standing or :door to `make-ml0-source` is REFUSED rather than
silently dropped: a silent drop would let a caller believe it had minted a warrant
and be wrong about it, which is a worse failure than a refusal."
  (loop for (key value) on arguments by #'cddr
        do (when (member key '(:validation-standing :door :recorded-validation))
             (ml0-refuse 'ml0-provenance-incomplete "ML0-SRC-11"
                         "~s may not be supplied to the public testimony door: a ~
validation standing is earned at an observation door, never passed as an argument"
                         key))
        append (list key value)))

(defun make-ml0-source (&rest arguments
                        &key species acquisition-route producer-principal
                             recorder-principal coordinate observation-scope
                             origin-as-read subject-act-id payload-digest
                             frontier-relation attests observation-interval
                        &allow-other-keys)
  "THE PUBLIC TESTIMONY DOOR.  It builds a durable, well-shaped, fully-provenanced
source row — AND STAMPS IT :ASSERTED-TESTIMONY, ALWAYS.

⚠ READ THIS BEFORE USING IT.  A row from this door CAN NEVER WARRANT OCCURRENCE,
however perfect its fields.  That is not a limitation to be worked around; it is
what the door is for.  Nothing here reads a journal frame or a world byte, so
nothing here has any standing to say what happened — and a constructor that
validated only SHAPE while the promotion rule read its fields as though they were
findings is precisely what the chair's disposition of 2026-08-20 blocked.

To warrant occurrence, use a PRODUCTION OBSERVATION DOOR (§7b): `ml0-observe-world`,
`ml0-observe-journal`, `ml0-observe-reconciliation`, `ml0-observe-absence`,
`ml0-observe-issuance`.  Those read their substrates and derive every field from
what they read; this one writes down what you tell it."
  ;; ⚠ &ALLOW-OTHER-KEYS IS DELIBERATE AND IS NOT LAXITY.  Without it, Common
  ;; Lisp's own unknown-keyword error fires before this lane can speak, and a
  ;; caller smuggling :validation-standing would get a host error instead of the
  ;; lane's typed refusal saying WHY.  The strip below turns every such attempt
  ;; into ML0-SRC-11.  Nothing else is admitted: any other unknown keyword falls
  ;; through to %ml0-build-source's own keyword checking.
  (declare (ignore species acquisition-route producer-principal recorder-principal
                   coordinate observation-scope origin-as-read subject-act-id
                   payload-digest frontier-relation attests observation-interval))
  (apply #'%ml0-build-source
         (append (%ml0-strip-validation-keywords arguments)
                 (list :validation-standing :asserted-testimony :door :none))))

(defun ml0-source-record (source)
  (rec (entry '("source" "species")
              (s-datum (string-downcase (symbol-name (ml0-source-species source)))))
       (entry '("source" "acquisition-route")
              (s-datum (string-downcase
                        (symbol-name (ml0-source-acquisition-route source)))))
       (entry '("source" "producer-principal")
              (s-datum (ml0-source-producer-principal source)))
       (entry '("source" "recorder-principal")
              (s-datum (ml0-source-recorder-principal source)))
       (entry '("source" "coordinate") (ml0-source-coordinate source))
       (entry '("source" "observation-scope")
              (ml0-scope-record (ml0-source-observation-scope source)))
       ;; ⚠ A STRING, DELIBERATELY.  See the §4 header.
       (entry '("source" "origin-as-read")
              (s-datum (ml0-source-origin-as-read source)))
       (entry '("source" "subject-act-id") (ml0-source-subject-act-id source))
       (entry '("source" "payload-digest")
              (s-datum (ml0-source-payload-digest source)))
       (entry '("source" "frontier-relation")
              (s-datum (ml0-source-frontier-relation source)))
       (entry '("source" "attests")
              (s-datum (string-downcase (symbol-name (ml0-source-attests source)))))
       (entry '("source" "observation-interval")
              (s-datum (ml0-source-observation-interval source)))
       ;; ⚑ THE VALIDATION STANDING IS DURABLE, and it is written from the ROW'S
       ;; OWN STAMP — never from anything a caller said.  A stored
       ;; :validated-by-door can therefore only exist because a door in this lane
       ;; actually read a substrate in the writing process, or because a
       ;; VALIDATED RETRIEVE inherited that fact from a store frame whose digest
       ;; chain verified.
       ;;
       ;; ⚠ REPAIRED IN R3, AND THE OLD LINE WAS A LAUNDERING PATH.  It read: a
       ;; :stored-assertion re-serializes as WHAT THE BYTES SAID, so that a round
       ;; trip would not erase the writer's validation.  But `ml0-source-from-
       ;; record` is PUBLIC: a caller could hand it a record whose
       ;; "validation-standing" field it had written itself, get back a
       ;; :stored-assertion carrying RECORDED-VALIDATION :validated-by-door, and
       ;; have this serializer write that claim back out as a door's stamp.  The
       ;; laundering survived the round trip precisely because the round trip was
       ;; made faithful.  Now:
       ;;
       ;;   :VALIDATED-BY-DOOR                  -> "validated-by-door"  (a door looked HERE)
       ;;   :INHERITED-FROM-VALIDATED-RECORD    -> "validated-by-door"  (a validated
       ;;                                          retrieve carried the chain forward)
       ;;   :STORED-ASSERTION                   -> "asserted-testimony" (a bare decode
       ;;                                          re-earns NOTHING, whatever it read)
       ;;   :ASSERTED-TESTIMONY                 -> "asserted-testimony"
       (entry '("source" "validation-standing")
              (s-datum (string-downcase
                        (symbol-name
                         (case (ml0-source-validation-standing source)
                           (:validated-by-door :validated-by-door)
                           (:inherited-from-validated-record :validated-by-door)
                           (t :asserted-testimony))))))
       (entry '("source" "door")
              (s-datum (string-downcase (symbol-name (ml0-source-door source)))))))

(defun %species-from-string (name)
  (or (find-if (lambda (k) (string= name (string-downcase (symbol-name k))))
               +ml0-source-species+)
      (ml0-refuse 'ml0-account-readback-refused "ML0-RB-4"
                  "source species ~s read from durable bytes is outside the ~
closed set" name)))

(defun ml0-source-from-record (record)
  (flet ((field (name)
           (or (record-field record "source" name)
               (ml0-refuse 'ml0-account-readback-refused "ML0-RB-4"
                           "a source record read from durable bytes is missing ~
field ~a — there is no plausible partial source" name))))
    (%ml0-build-source
     :species (%species-from-string
               (lisp-plus-cd0:string-datum-value (field "species")))
     :acquisition-route (ml0-route-from-string
                         (lisp-plus-cd0:string-datum-value
                          (field "acquisition-route")))
     :producer-principal (lisp-plus-cd0:string-datum-value
                          (field "producer-principal"))
     :recorder-principal (lisp-plus-cd0:string-datum-value
                          (field "recorder-principal"))
     :coordinate (field "coordinate")
     :observation-scope (ml0-scope-from-record (field "observation-scope"))
     :origin-as-read (lisp-plus-cd0:string-datum-value (field "origin-as-read"))
     :subject-act-id (field "subject-act-id")
     :payload-digest (lisp-plus-cd0:string-datum-value (field "payload-digest"))
     :frontier-relation (lisp-plus-cd0:string-datum-value
                         (field "frontier-relation"))
     :observation-interval (lisp-plus-cd0:string-datum-value
                            (field "observation-interval"))
     ;; ⚠ READBACK ALWAYS YIELDS :STORED-ASSERTION, WHATEVER THE BYTES SAY.  The
     ;; bytes' own claim is preserved separately as RECORDED-VALIDATION.  A row
     ;; read out of a file is testimony about somebody else's look; it is never a
     ;; fresh look, and this is the one place where saying so costs something.
     :validation-standing :stored-assertion
     :recorded-validation
     (let ((name (lisp-plus-cd0:string-datum-value (field "validation-standing"))))
       (or (find-if (lambda (k) (string= name (string-downcase (symbol-name k))))
                    '(:validated-by-door :asserted-testimony))
           (ml0-refuse 'ml0-account-readback-refused "ML0-RB-12"
                       "validation standing ~s read from durable bytes is outside ~
{validated-by-door, asserted-testimony}" name)))
     :door (let ((name (lisp-plus-cd0:string-datum-value (field "door"))))
             (or (find-if (lambda (k) (string= name (string-downcase (symbol-name k))))
                          (cons :none +ml0-observation-doors+))
                 (ml0-refuse 'ml0-account-readback-refused "ML0-RB-12"
                             "door ~s read from durable bytes is outside the closed set"
                             name)))
     :attests (let ((name (lisp-plus-cd0:string-datum-value (field "attests"))))
                (or (find-if (lambda (k) (string= name (string-downcase
                                                        (symbol-name k))))
                             +ml0-attestations+)
                    (ml0-refuse 'ml0-account-readback-refused "ML0-RB-4"
                                "attestation ~s read from durable bytes is outside ~
the closed set" name))))))

;;; ===========================================================================
;;; §4a-bis — THE CANONICAL SUBJECT CARRIER.  R2-BLOCK 2's cure.
;;;
;;; ⚑ WHAT WAS WRONG.  Every door took the act identity and the substrate key as
;;; SEPARATE arguments: `(ml0-observe-world act-id attempt world)` looked the
;;; ledger up under ATTEMPT and stamped the row with ACT-ID.  Nothing anywhere
;;; required the two to belong to each other.  So an ordinary caller could execute
;;; settled act B, read B's world row, stamp the reading toward refused act A, and
;;; write an account for A saying :OCCURRED — with a genuine door validation on a
;;; genuine reading of a real substrate.  Not a forged row: a TRUE reading,
;;; MISADDRESSED.  The same substitution ran through journal, reconciliation,
;;; absence and issuance.  (Reproduced: `RED-R2-BEFORE.txt`, probes R2B2a–e.)
;;;
;;; ⚑ THE CURE, in one sentence: A DOOR TAKES ONE SUBJECT AND DERIVES EVERYTHING
;;; FROM IT.  There is no longer any pair of arguments to make disagree, because
;;; there is no longer any pair.  The act identity, the attempt name, the derived
;;; external-request key and the canonical request all come out of ONE fixture row
;;; through One Act /1's public NON-PERFORMING seam — the same seam `ml0-write`
;;; uses to re-derive the identity it checks against.  Two derivations, one source,
;;; and `ml0-write` compares them (`ML0-WR-7`).
;;;
;;; ⚠ WHAT THIS DOES NOT DO.  It does not authenticate the fixture row.  A caller
;;; who declares a row declares a subject; this lane reads the substrates that row
;;; names and reports what it finds there.  Capability-DISCIPLINED, never
;;; capability-SECURE — unchanged, and the R3 repair does not touch it.
;;; ===========================================================================

(defstruct (ml0-subject (:constructor %make-ml0-subject (&key fixture-row act-id act-id-hex seat attempt external-request-key canonical-request)) (:copier nil))
  "THE ONE CANONICAL SUBJECT CARRIER a door is given.  Every field is DERIVED
together from the one declared fixture row; none is accepted separately."
  (fixture-row nil :read-only t)
  (act-id nil :read-only t)
  (act-id-hex nil :read-only t)
  (seat nil :read-only t)
  (attempt nil :read-only t)
  (external-request-key nil :read-only t)
  (canonical-request nil :read-only t))

(defun ml0-subject-from-fixture-row (fixture-row)
  "Derive the WHOLE subject from ONE declared row, through One Act /1's public
non-performing seam (`make-act1-record :register nil`).  Nothing is performed,
nothing is registered, and no run-local identity is consumed.

⚑ THE FIVE FACTS COME OUT TOGETHER OR NOT AT ALL: the act identity, its hex, the
runtime seat, the attempt name, the external-request key capability /2 computes
from that attempt, and the canonical request Core /0's conjoined issuance
predicate compares against.  A caller cannot pair one act's identity with another
act's attempt because it never supplies either."
  (ml0-through
   "One Act /1 subject derivation (non-performing)"
   (lambda ()
     (let* ((record (make-act1-record fixture-row :register nil))
            (attempt (act1-fixture-attempt-name fixture-row)))
       (%make-ml0-subject
        :fixture-row fixture-row
        :act-id (act1-record-act-id record)
        :act-id-hex (act1-record-act-id-hex record)
        :seat (act1-fixture-runtime-seat fixture-row)
        :attempt attempt
        :external-request-key (external-request-key attempt)
        :canonical-request (act1-record-normal-form record))))))

(defun %ml0-subject-binding (subject)
  "THE BINDING SUB-RECORD every door writes into its coordinate: the three facts
`ml0-write` will independently re-derive and compare.  It is written from the
SUBJECT, so a row's binding is a statement about which subject the door was
actually given, checkable against the bundle's own declared row."
  (rec (entry '("binding" "act-id-hex") (s-datum (ml0-subject-act-id-hex subject)))
       (entry '("binding" "attempt") (s-datum (ml0-subject-attempt subject)))
       (entry '("binding" "external-request-key")
              (s-datum (ml0-subject-external-request-key subject)))
       (entry '("binding" "seat") (s-datum (ml0-subject-seat subject)))))

;;; ===========================================================================
;;; §4b — THE PRODUCTION OBSERVATION DOORS.
;;;
;;; ⚑ THIS SECTION IS BLOCK 1'S CURE, and it exists because of what the blocked
;;; build did NOT have: doors that read.  The real substrate-reading builders
;;; lived in `ml0-suite-ground.lisp` — test infrastructure the canonical loader
;;; deliberately excludes — so a consumer loading `load.lisp` got the forgeable
;;; testimony door and nothing else.  These live in the LANE.
;;;
;;; EVERY DOOR OBEYS THE SAME FOUR RULES:
;;;
;;;   1. IT READS.  Each door calls the PUBLIC readers of the lane that owns the
;;;      fact — capability /2's world readers and fold, journal /0's validating
;;;      reader through One Act /1's `act1-journal-kinds`, One Act /1's
;;;      reconciliation conjunction, Core /0's live issuance predicate.
;;;   2. IT DERIVES, NEVER ACCEPTS.  The coordinate, the payload digest, the scope,
;;;      the interval and the attestation are computed FROM WHAT IT READ.  A door
;;;      that took its finding from its argument list would be the blocked build
;;;      wearing a longer name.
;;;   3. IT BINDS THE ACT.  The caller supplies the act identity and the door
;;;      writes it into the row, so a row is always about a named act; and
;;;      `ml0-write` independently re-derives that identity from declared
;;;      configuration and refuses any row that does not match.
;;;   4. IT STAMPS.  Only these doors reach `%ml0-build-source` with
;;;      :VALIDATED-BY-DOOR.  That constructor is internal and unexported.
;;;
;;; ⚠ WHAT A DOOR DOES **NOT** ESTABLISH.  A door reads the substrate IT IS GIVEN.
;;; If you hand it a world, it tells you the truth about THAT world, and the row
;;; records which world by its digests.  A door is not an authentication of the
;;; substrate's provenance and this lane makes no such claim: capability-
;;; DISCIPLINED, never capability-SECURE.
;;; ===========================================================================

(defstruct (ml0-observation (:constructor %make-ml0-observation (&key source door read-summary)) (:copier nil))
  "A VALIDATED OBSERVATION: one source row that a door built from bytes it read,
plus the door's own name.  The constructor is not exported and the struct is BOA,
so an observation is not a thing the exported, supported API lets a caller assert
— which is the whole point; package privacy itself is not a capability boundary
(R4.1c wording)."
  (source nil :read-only t)
  (door nil :read-only t)
  (read-summary nil :read-only t))        ; STRING: what the door actually saw

(defun ml0-observation-species (observation)
  (ml0-source-species (ml0-observation-source observation)))

(defun %ml0-door-row (door &rest arguments)
  (apply #'%ml0-build-source
         (append arguments (list :validation-standing :validated-by-door
                                 :door door))))

(defun ml0-observe-journal (subject store &key (route :live-query))
  "DOOR :JOURNAL-DOOR — species :KERNEL-MEDIATED-JOURNAL.

TAKES ONE SUBJECT (`ml0-subject-from-fixture-row`) and derives the act identity
AND the attempt from it together.  ⚠ R3: the old `(act-id attempt store)` signature
is GONE, and its absence is the repair — it let a caller fold one act's attempt and
stamp the answer toward another act.

READS: `act1-journal-kinds`, which goes through journal /0's `validate-journal`
and therefore re-reads the store's bytes from disk and stops at the first frame
that does not verify; and capability /2's `derive-effect-standing`, which folds
that same validated prefix.  The attestation is the FOLD'S answer, under the
conservative frontier rule inherited from One Act /1: only :ABSENT counts as
pre-frontier, and :PREPARED-ONLY settles nothing."
  (let ((act-id (ml0-subject-act-id subject))
        (attempt (ml0-subject-attempt subject)))
   (multiple-value-bind (kinds frame-count status tail) (act1-journal-kinds store)
    (let* ((standing (derive-effect-standing store attempt))
           (store-id (journal-store-store-id store))
           (attests (case standing
                      ((:settled :reconciled :crossed-unsettled :uncertain-unresolved)
                       :frontier-crossed-for-this-identity)
                      ((:absent) :no-record-for-this-identity)
                      (t :inconclusive))))
      (%make-ml0-observation
       :door :journal-door
       :read-summary (format nil "validated prefix ~s, ~d frame~:p, standing ~s"
                             status frame-count standing)
       :source
       (%ml0-door-row
        :journal-door
        :species :kernel-mediated-journal
        :acquisition-route route
        :producer-principal "principal:kernel-store"
        :recorder-principal (format nil "principal:~a" +ml0-lane-stem+)
        :coordinate (rec (entry '("coordinate" "kind")
                                (s-datum "pj0-validated-prefix"))
                         (entry '("coordinate" "store-id") (s-datum store-id))
                         (entry '("coordinate" "frame-count") (i-datum frame-count))
                         (entry '("coordinate" "status")
                                (s-datum (string-downcase (symbol-name status))))
                         (entry '("coordinate" "tail-sha") (s-datum (or tail "none")))
                         (entry '("coordinate" "attempt") (s-datum attempt))
                         (entry '("coordinate" "derived-standing")
                                (s-datum (string-downcase (symbol-name standing))))
                         (entry '("coordinate" "subject-binding")
                                (%ml0-subject-binding subject)))
        :observation-scope
        (make-ml0-scope
         :universe (format nil "the whole VALIDATED PREFIX of PJ0 store ~a (~d frame~:p)"
                           store-id frame-count)
         :status (if (eq :valid status) :looked :could-not-look)
         :detail "read by this door through act1-journal-kinds, which goes through journal0's validate-journal and re-reads the bytes from disk")
        :origin-as-read "observed"
        :subject-act-id act-id
        :payload-digest (digest-of (seq (mapcar #'s-datum kinds)))
        :frontier-relation
        (format nil "capability /2's fold over these bytes derives standing ~s for attempt ~a"
                standing attempt)
        :observation-interval
        (format nil "pj0-validated-prefix/~a/at-frame-~d" store-id frame-count)
        :attests attests))))))

(defun ml0-observe-world (subject world &key (route :live-query))
  "DOOR :WORLD-DOOR — species :WORLD-BYTES.

TAKES ONE SUBJECT and derives the act identity AND the ledger key from it
together.  ⚠ R3: the old `(act-id attempt world)` signature is GONE — it let a
caller look up one act's external-request key and stamp the row with another act's
identity.

READS: capability /2's public `world-ledger-lookup` for this act's DERIVED
external-request key, plus `world-cells-sha256`, `world-ledger-sha256` and
`world-ledger-count` over the world's own files.  The attestation is THE
LOOKUP'S OWN ANSWER — found or not found — and the coordinate carries the row's
digest so a later reader can see which bytes were seen."
  (let ((act-id (ml0-subject-act-id subject))
        (key (ml0-subject-external-request-key subject)))
    (multiple-value-bind (found line line-sha) (world-ledger-lookup world key)
      (declare (ignore line))
      (let ((ledger-sha (world-ledger-sha256 world))
            (cells-sha (world-cells-sha256 world))
            (total (world-ledger-count world)))
        (%make-ml0-observation
         :door :world-door
         :read-summary (format nil "ledger key ~a ~a; ~d entr~:@p in the ledger"
                               key (if found "FOUND" "not found") total)
         :source
         (%ml0-door-row
          :world-door
          :species :world-bytes
          :acquisition-route route
          :producer-principal "principal:cap2-world-adapter"
          :recorder-principal (format nil "principal:~a" +ml0-lane-stem+)
          :coordinate (rec (entry '("coordinate" "kind") (s-datum "cap2-world-ledger"))
                           (entry '("coordinate" "ledger-key") (s-datum key))
                           (entry '("coordinate" "row-found")
                                  (s-datum (if found "yes" "no")))
                           (entry '("coordinate" "row-sha") (s-datum (or line-sha "none")))
                           (entry '("coordinate" "cells-sha") (s-datum cells-sha))
                           (entry '("coordinate" "ledger-sha") (s-datum ledger-sha))
                           (entry '("coordinate" "subject-binding")
                                  (%ml0-subject-binding subject)))
          :observation-scope
          (make-ml0-scope
           :universe (format nil "the ENTIRE capability /2 world fixture — the cell store and the request ledger, ~d ledger entr~:@p in total"
                             total)
           :status :looked
           :detail "read by this door through the public world readers world-ledger-lookup / world-cells-sha256 / world-ledger-sha256 over the world's own files")
          :origin-as-read "observed"
          :subject-act-id act-id
          :payload-digest (digest-of (rec (entry '("world" "cells") (s-datum cells-sha))
                                          (entry '("world" "ledger") (s-datum ledger-sha))
                                          (entry '("world" "row")
                                                 (s-datum (or line-sha "none")))))
          :frontier-relation
          (if found
              (format nil "the world's request ledger holds a row under this act's derived external-request identity ~a — a POST-frontier fact" key)
              (format nil "the world's request ledger holds NO row under ~a" key))
          :observation-interval (format nil "cap2-world-ledger/at-~a" ledger-sha)
          :attests (if found
                       :frontier-crossed-for-this-identity
                       :no-record-for-this-identity)))))))

(defun ml0-observe-reconciliation (subject store world resolution
                                   &key (route :live-query))
  "DOOR :RECONCILIATION-DOOR — species :RECONCILIATION-CONJUNCTION.

TAKES ONE SUBJECT and derives the act identity AND the attempt from it together.
⚠ R3: the old `(act-id attempt store world resolution)` signature is GONE.

READS: One Act /1's `act1-reconciliation-closes-seat-p`, itself a four-way
conjunction over the world's ledger AND the journal's validated prefix.  The
attestation is the conjunction's own answer; an unmet conjunction is
:INCONCLUSIVE and never a negative finding."
  (let* ((act-id (ml0-subject-act-id subject))
         (attempt (ml0-subject-attempt subject))
         (closes (act1-reconciliation-closes-seat-p store world attempt resolution))
         (standing (derive-effect-standing store attempt))
         (ledger-sha (world-ledger-sha256 world)))
    (%make-ml0-observation
     :door :reconciliation-door
     :read-summary (format nil "conjunction ~a for attempt ~a at resolution ~s"
                           (if closes "HOLDS" "does not hold") attempt resolution)
     :source
     (%ml0-door-row
      :reconciliation-door
      :species :reconciliation-conjunction
      :acquisition-route route
      :producer-principal "principal:oneact1-reconciliation"
      :recorder-principal (format nil "principal:~a" +ml0-lane-stem+)
      :coordinate (rec (entry '("coordinate" "kind")
                              (s-datum "act1-reconciliation-conjunction"))
                       (entry '("coordinate" "attempt") (s-datum attempt))
                       (entry '("coordinate" "resolution")
                              (s-datum (string-downcase (symbol-name resolution))))
                       (entry '("coordinate" "closes-seat")
                              (s-datum (if closes "yes" "no")))
                       (entry '("coordinate" "derived-standing")
                              (s-datum (string-downcase (symbol-name standing))))
                       (entry '("coordinate" "ledger-sha") (s-datum ledger-sha))
                       (entry '("coordinate" "subject-binding")
                              (%ml0-subject-binding subject)))
      :observation-scope
      (make-ml0-scope
       :universe "the journal's validated prefix AND the surviving world, jointly"
       :status :looked
       :detail "act1-reconciliation-closes-seat-p: resolution :applied AND a world ledger row with a digest AND derived standing :reconciled AND attempt:reconciled among the journal kinds")
      :origin-as-read "observed"
      :subject-act-id act-id
      :payload-digest (digest-of (rec (entry '("conj" "closes")
                                             (s-datum (if closes "yes" "no")))
                                      (entry '("conj" "standing")
                                             (s-datum (string-downcase
                                                       (symbol-name standing))))))
      :frontier-relation (format nil "the four-way conjunction answers ~a for attempt ~a"
                                 (if closes "TRUE" "FALSE") attempt)
      :observation-interval (format nil "act1-reconciliation/~a/at-~a" attempt ledger-sha)
      :attests (if closes :frontier-crossed-for-this-identity :inconclusive)))))

(defun %ml0-file-readable-p (pathname)
  "Can this file be opened at all?  ⚠ THE DISTINCTION IS THE POINT: a file that
cannot be opened is NOT an empty file, and a door that could not look must be able
to say so.  Same discipline as One Act /1's `%file-octet-count`, which yields
:COULD-NOT-LOOK rather than 0."
  (with-open-file (stream pathname :direction :input
                                   :element-type '(unsigned-byte 8)
                                   :if-does-not-exist nil)
    (and stream t)))

(defun ml0-observe-absence (subject world &key (route :live-query) universe
                                               directory)
  "DOOR :ABSENCE-DOOR — species :SCOPED-NEGATIVE-OBSERVATION, the four-part warrant.

TAKES ONE SUBJECT and derives the act identity AND the ledger key from it
together.  ⚠ R3: the old `(act-id attempt world)` signature is GONE, and this door
is where the substitution was WORST — a look under act B's key, stamped toward act
A, wrote `it did not happen` about an act that did.

READS: the same public world readers, and the coordinate binds all four parts —
witness mechanism, procedure identity, evidence identity (the ledger key) and
validation standing — so a later reader can check the warrant rather than take it.

⚠ THE ATTESTATION IS THE LOOKUP'S ANSWER, NOT THE CALLER'S HOPE.  If the row IS
there, this door says so, and the negative rule then refuses to warrant a negative
reading from it.  A door that could only ever report absence would be an
instrument that had never been seen to fire."
  (let ((act-id (ml0-subject-act-id subject))
        (key (ml0-subject-external-request-key subject))
        ;; ⚑ AN ADEQUACY CHECK THE DOOR MAKES FOR ITSELF.  When the caller declares
        ;; the world's directory, the door verifies it can actually OPEN the
        ;; request ledger before it reports an absence across it.  A negative
        ;; reading taken through an unreadable file is the absence-without-an-
        ;; adequacy-warrant defect at its purest, and this is the one door whose
        ;; whole output is an absence.
        (looked (or (null directory)
                    (%ml0-file-readable-p
                     (merge-pathnames "REQUEST-LEDGER.txt" directory)))))
    (multiple-value-bind (found line line-sha) (world-ledger-lookup world key)
      (declare (ignore line))
      (let ((ledger-sha (world-ledger-sha256 world))
            (total (world-ledger-count world)))
        (%make-ml0-observation
         :door :absence-door
         :read-summary (format nil "ledger key ~a ~a across ~d entr~:@p (~a)"
                               key (if found "FOUND" "ABSENT") total
                               (if looked "the ledger was readable"
                                   "THE LEDGER COULD NOT BE OPENED"))
         :source
         (%ml0-door-row
          :absence-door
          :species :scoped-negative-observation
          :acquisition-route route
          :producer-principal "principal:cap2-world-adapter"
          :recorder-principal (format nil "principal:~a" +ml0-lane-stem+)
          :coordinate (rec (entry '("coordinate" "kind")
                                  (s-datum "cap2-world-ledger-absence"))
                           (entry '("coordinate" "ledger-key") (s-datum key))
                           (entry '("coordinate" "row-found")
                                  (s-datum (if found "yes" "no")))
                           (entry '("coordinate" "row-sha")
                                  (s-datum (or line-sha "none")))
                           (entry '("coordinate" "ledger-sha") (s-datum ledger-sha))
                           (entry '("coordinate" "witness-mechanism")
                                  (s-datum "cap2 world-ledger-lookup over the world's own files"))
                           (entry '("coordinate" "procedure-identity")
                                  (s-datum "ml0-observe-absence/v1"))
                           (entry '("coordinate" "validation-standing")
                                  (s-datum "the world's ledger is complete and authoritative for external-request identities it issues"))
                           (entry '("coordinate" "subject-binding")
                                  (%ml0-subject-binding subject)))
          :observation-scope
          (make-ml0-scope
           :universe (or universe
                         (format nil "the ENTIRE capability /2 request ledger (~d entr~:@p), which is complete and authoritative for external-request identities"
                                 total))
           :status (if looked :looked :could-not-look)
           :detail (if looked
                       "a look by this door for this act's derived external-request identity across the whole ledger; the ledger is the domain and the lookup is the distinct inspectable witness"
                       "THE DECLARED REQUEST LEDGER COULD NOT BE OPENED: this row records a FAILED LOOK, which is a different answer from an absence and warrants nothing"))
          :origin-as-read "observed"
          :subject-act-id act-id
          :payload-digest (digest-of (rec (entry '("absence" "key") (s-datum key))
                                          (entry '("absence" "found")
                                                 (s-datum (if found "yes" "no")))
                                          (entry '("absence" "ledger-sha")
                                                 (s-datum ledger-sha))))
          :frontier-relation
          (if found
              (format nil "a row DOES exist under ~a; this look found the act, not its absence" key)
              (format nil "no row exists under ~a across the declared universe; the frontier was never crossed for this identity" key))
          :observation-interval (format nil "cap2-world-ledger/at-~a" ledger-sha)
          :attests (cond ((not looked) :inconclusive)
                         (found :frontier-crossed-for-this-identity)
                         (t :no-record-for-this-identity))))))))

(defun ml0-observe-issuance (subject evidence &key (route :live-query))
  "DOOR :ISSUANCE-DOOR — species :CORE0-ISSUANCE-TESTIMONY.

TAKES ONE SUBJECT and derives the act identity AND the canonical request from it
together.  ⚠ R3: TWO ARGUMENTS ARE GONE AND BOTH WERE HOLES.

  · The old `act-id` was independently pairable with someone else's evidence: a
    caller could confirm act B's evidence against act B's request and stamp the
    reading toward act A.  The predicate answered truly — about the wrong act.
  · The old `canonical-request` could be NIL, which dropped the door to the
    UNCONJOINED predicate — and `ml0-observation-issued-p` read only
    `\"predicate-answer\"`, so any current-image evidence object established
    :ISSUED-IN-WRITING-IMAGE for an unrelated act with no request binding at all.

The request is now the SUBJECT'S OWN canonical request, so the conjunction is
structural rather than optional.  The NIL branch survives ONLY as defence in depth
(a subject that somehow carried no request yields an unconjoined reading, which
`ml0-observation-issued-p` now refuses to call issued) — see the DISEASE CONTROL
in `ml0-block-proof` probe R2B2e.

READS: Core /0's LIVE current-image predicate, in its CONJOINED form —
`core0-evidence-current-image-issued-for-request-p`, whose own docstring calls the
conjunction the whole operation: issuance without the request binding says an
account was minted here but not WHICH act it belongs to.

⚠ AND THE DOOR RETURNS AN OBSERVATION EITHER WAY.  If the predicate answers
FALSE, that is a real reading and the row records it; what the caller does NOT get
is an issuance STANDING, because `ml0-write` derives that from the reading rather
than from anything anyone says.  Refusing to build a row on a false answer would
hide the reading; deriving a standing from a caller's keyword is what was blocked.

⚠ THE CEILING TRAVELS IN THE ROW.  A true answer establishes AT MOST that this
exact canonical account content was minted by the Core /0 runtime IN THIS IMAGE.
It establishes nothing about the world, and in any other image the predicate
answers false for every input — which is why this lane's issuance axis has no
negative member."
  (unless (ml0-subject-p subject)
    (ml0-refuse 'ml0-provenance-incomplete "ML0-DOOR-2"
                "the issuance door requires an ml0-subject from ~
`ml0-subject-from-fixture-row`; got ~s" subject))
  (unless (lisp-plus-core0:core0-evidence-p evidence)
    (ml0-refuse 'ml0-provenance-incomplete "ML0-DOOR-1"
                "the issuance door requires a core0-evidence to read; got ~s" evidence))
  (let* ((act-id (ml0-subject-act-id subject))
         (canonical-request (ml0-subject-canonical-request subject))
         (issued (ml0-through
                  "Core /0's live current-image issuance predicate"
                  (lambda ()
                    (if canonical-request
                        (lisp-plus-core0:core0-evidence-current-image-issued-for-request-p
                         evidence canonical-request)
                        (lisp-plus-core0:core0-evidence-current-image-issued-p evidence)))))
         (conjoined (and canonical-request t)))
    (multiple-value-bind (hex projection) (ml0-evidence-projection-digest evidence)
      (%make-ml0-observation
       :door :issuance-door
       :read-summary (format nil "live predicate answered ~a (~a)"
                             (if issued "TRUE" "false")
                             (if conjoined "conjoined with the caller-held canonical request"
                                 "issuance only, no request binding available"))
       :source
       (%ml0-door-row
        :issuance-door
        :species :core0-issuance-testimony
        :acquisition-route route
        :producer-principal "principal:core0-runtime"
        :recorder-principal (format nil "principal:~a" +ml0-lane-stem+)
        :coordinate (rec (entry '("coordinate" "kind") (s-datum "core0-issuance-reading"))
                         (entry '("coordinate" "projection-digest") (s-datum hex))
                         (entry '("coordinate" "predicate-answer")
                                (s-datum (if issued "true" "false")))
                         (entry '("coordinate" "request-conjoined")
                                (s-datum (if conjoined "yes" "no")))
                         (entry '("coordinate" "projection") projection)
                         (entry '("coordinate" "subject-binding")
                                (%ml0-subject-binding subject)))
        :observation-scope
        (make-ml0-scope
         :universe "the Core /0 issuance registry OF THIS IMAGE ONLY — an in-image hash table with no durable footprint (core0.lisp:830-836)"
         :status :looked
         :detail (if conjoined
                     "core0-evidence-current-image-issued-for-request-p, conjoined with the caller-held canonical request, in the issuing image at write time"
                     "core0-evidence-current-image-issued-p, in the issuing image at write time"))
        :origin-as-read "self-reported"
        :subject-act-id act-id
        :payload-digest hex
        :frontier-relation "an evidence account was read for; minting touches no journal frame and no world byte, so this row says nothing about the frontier"
        :observation-interval (format nil "core0-issuance-registry/this-image/~a" hex)
        ;; ⚑ ALWAYS :INCONCLUSIVE, and it is not a policy — a mint is not a
        ;; finding about a frontier.  Even were it otherwise, the SPECIES leg
        ;; would still refuse; the two legs are independent on purpose.
        :attests :inconclusive)
       ))))

(defun ml0-observation-issued-p (observation)
  "TRUE only for an :ISSUANCE-DOOR observation whose LIVE predicate answered true
AND whose reading was CONJOINED WITH A REQUEST BINDING.  Both facts are read out of
the row's own coordinate — the bytes the door wrote — rather than from a flag
carried beside them.

⚠ R3: THE SECOND CONJUNCT IS NEW AND IT IS THE REPAIR.  The unconjoined predicate
says an account was minted in this image; it does not say WHICH ACT it belongs to,
and Core /0's own docstring calls the conjunction the whole operation.  Reading a
bare `predicate-answer = true` as an issuance for THIS act let any current-image
evidence object establish :ISSUED-IN-WRITING-IMAGE for an unrelated one."
  (and (ml0-observation-p observation)
       (eq :issuance-door (ml0-observation-door observation))
       (let* ((coordinate (ml0-source-coordinate (ml0-observation-source observation)))
              (answer (record-field coordinate "coordinate" "predicate-answer"))
              (conjoined (record-field coordinate "coordinate" "request-conjoined")))
         (and answer conjoined
              (string= "true" (lisp-plus-cd0:string-datum-value answer))
              (string= "yes" (lisp-plus-cd0:string-datum-value conjoined))))))

;;; ===========================================================================
;;; §5 — THE SCOPED OBSERVATION OF THE EXTERNAL-EFFECT AXIS.
;;;
;;; Architecture 0.1 §6.8's fourth axis, REUSED VERBATIM and never re-spelled.
;;; What is carried is a SCOPED OBSERVATION OF capability /2's fold-derived
;;; standing — never the standing itself, and never collapsed into the act's
;;; outcome.  Observation<State> ≠ State, in the lab's own adopted words: L15.
;;; ===========================================================================

(defstruct (ml0-effect-observation (:constructor %make-ml0-effect-observation (&key standing-as-read determinacy world-digest scope (provenance :caller-asserted)))
                                   (:copier nil))
  (standing-as-read nil :read-only t)   ; STRING: cap2's keyword, as read
  (determinacy nil :read-only t)        ; :determinate | :bounded | :indeterminate
  (world-digest nil :read-only t)       ; STRING: 64 hex, or "could-not-look"
  (scope nil :read-only t)              ; ml0-scope
  ;; ⚑ R4 (Codex finding F5).  WHOSE WORD THIS IS.  :CALLER-ASSERTED, always, in
  ;; this slice — there is no world-reading door on the effect axis, so every
  ;; value above arrives from the caller's argument list and NOTHING here read a
  ;; world.  The SPEC lists world/effect as one of the six commission questions,
  ;; and an account answering a commission question out of caller testimony, with
  ;; nothing marking it as testimony, sits beside door-read provenance looking
  ;; exactly like it.  This field is the mark, and it is in the durable bytes too.
  (provenance :caller-asserted :read-only t))

(defun make-ml0-effect-observation (&key standing-as-read determinacy
                                         world-digest scope)
  (unless (and (stringp standing-as-read) (plusp (length standing-as-read)))
    (ml0-refuse 'ml0-provenance-incomplete "ML0-EFF-1"
                "the effect standing AS READ MUST be a non-empty string"))
  (unless (member determinacy +ml0-effect-determinacies+)
    (ml0-refuse 'ml0-standing-vocabulary-refused "ML0-EFF-2"
                "determinacy ~s is outside Architecture 0.1 §6.8's three ~s"
                determinacy +ml0-effect-determinacies+))
  (unless (or (hex64-p world-digest) (equal world-digest "could-not-look"))
    (ml0-refuse 'ml0-provenance-incomplete "ML0-EFF-3"
                "the world digest MUST be 64 hex characters or the literal ~
\"could-not-look\" — a failed look is never rendered as a zero or a blank"))
  (unless (ml0-scope-p scope)
    (ml0-refuse 'ml0-scope-undeclared "ML0-EFF-4"
                "an effect observation MUST carry a declared scope"))
  ;; ⚠ THE PROVENANCE IS NOT A PARAMETER.  A caller that could pass
  ;; `:provenance :door-read` would have exactly the field-filling power this
  ;; whole lane's repairs exist to remove.  When a world-reading door for this
  ;; axis is built, it will stamp its own value through an internal constructor,
  ;; the way the observation doors do — not by widening this arglist.
  (%make-ml0-effect-observation :standing-as-read standing-as-read
                                :determinacy determinacy
                                :world-digest world-digest :scope scope
                                :provenance :caller-asserted))

(defun ml0-effect-observation-record (observation)
  (rec (entry '("effect" "provenance")
              (s-datum (string-downcase
                        (symbol-name
                         (ml0-effect-observation-provenance observation)))))
       (entry '("effect" "standing-as-read")
              (s-datum (ml0-effect-observation-standing-as-read observation)))
       (entry '("effect" "determinacy")
              (s-datum (string-downcase
                        (symbol-name
                         (ml0-effect-observation-determinacy observation)))))
       (entry '("effect" "world-digest")
              (s-datum (ml0-effect-observation-world-digest observation)))
       (entry '("effect" "scope")
              (ml0-scope-record (ml0-effect-observation-scope observation)))))

(defun ml0-effect-observation-from-record (record)
  (flet ((field (name)
           (or (record-field record "effect" name)
               (ml0-refuse 'ml0-account-readback-refused "ML0-RB-5"
                           "the effect observation read from durable bytes is ~
missing field ~a" name))))
    (let ((determinacy-string (lisp-plus-cd0:string-datum-value
                               (field "determinacy")))
          (provenance-string (lisp-plus-cd0:string-datum-value
                              (field "provenance"))))
      (unless (string= "caller-asserted" provenance-string)
        (ml0-refuse 'ml0-account-readback-refused "ML0-RB-5"
                    "the effect observation's provenance reads ~s; this slice ~
mints exactly one value, \"caller-asserted\", because it has no world-reading ~
door on this axis — bytes claiming another provenance were not written by this ~
lane" provenance-string))
      (make-ml0-effect-observation
       :standing-as-read (lisp-plus-cd0:string-datum-value
                          (field "standing-as-read"))
       :determinacy (or (find-if (lambda (k)
                                   (string= determinacy-string
                                            (string-downcase (symbol-name k))))
                                 +ml0-effect-determinacies+)
                        (ml0-refuse 'ml0-account-readback-refused "ML0-RB-5"
                                    "determinacy ~s is outside the adopted three"
                                    determinacy-string))
       :world-digest (lisp-plus-cd0:string-datum-value (field "world-digest"))
       :scope (ml0-scope-from-record (field "scope"))))))

;;; ⚠ AND THE DECODER REFUSES BYTES THAT DO NOT CARRY THE MARK.  `field` above
;;; signals ML0-RB-5 for a missing "provenance" entry, so an account written by a
;;; build that did not know about this axis's provenance cannot be read back as
;;; though it had declared one.  That is a DELIBERATE BREAK with pre-R4 durable
;;; bytes, and it is the right way round: an unmarked effect reading read back as
;;; caller-asserted-by-default would be the default doing the asserting.

;;; ===========================================================================
;;; §6 — THE SOURCE BUNDLE Write accepts.
;;;
;;; ⚑ THE BUNDLE CARRIES A FIXTURE ROW AND A CLAIMED IDENTITY, NOT A DERIVED
;;; RECORD.  Write re-derives the act identity from the row — declared
;;; configuration only, through One Act /1's public NON-PERFORMING seam — and
;;; compares it BYTE-FOR-BYTE against the claim.  A caller that hands over a
;;; derived record hands over its own arithmetic; a caller that hands over a row
;;; hands over the INPUTS, and the layer does the arithmetic itself.
;;; ===========================================================================

(defstruct (ml0-bundle (:constructor %make-ml0-bundle (&key fixture-row claimed-act-id subject-principal observations testimony sources issuance-observation issuance-standing issuance-scope record-coverage record-coverage-scope record-coverage-observation effect-observation)) (:copier nil))
  (fixture-row nil :read-only t)
  (claimed-act-id nil :read-only t)
  (subject-principal nil :read-only t)
  (observations nil :read-only t)        ; list of ml0-observation (door-validated)
  (testimony nil :read-only t)           ; list of ml0-source (asserted)
  (sources nil :read-only t)             ; the union, in that order
  (issuance-observation nil :read-only t); an :issuance-door observation, or NIL
  (issuance-standing nil :read-only t)   ; DERIVED here, never accepted
  (issuance-scope nil :read-only t)
  (record-coverage nil :read-only t)
  (record-coverage-scope nil :read-only t)
  ;; the door's own reading, kept so a caller can inspect WHAT WAS SCANNED
  (record-coverage-observation nil :read-only t)
  (effect-observation nil :read-only t))

(defun %ml0-normalize-as-testimony (source)
  "⚠ INTERNAL.  A row arriving through the bundle's TESTIMONY channels
(`:testimony`, `:sources`) is normalized to :STORED-ASSERTION — which warrants
nothing — WHATEVER it arrived as.  What the row claimed is preserved in
RECORDED-VALIDATION and its door name is kept, so nothing is erased and nothing is
laundered: the account still records that these bytes once carried a door's stamp,
and the promotion rule still declines to promote on it.

A row that is already non-warranting is returned unchanged, so the ordinary case
allocates nothing."
  (if (ml0-source-warranting-validation-p source)
      (%make-ml0-source
       :species (ml0-source-species source)
       :acquisition-route (ml0-source-acquisition-route source)
       :producer-principal (ml0-source-producer-principal source)
       :recorder-principal (ml0-source-recorder-principal source)
       :coordinate (ml0-source-coordinate source)
       :observation-scope (ml0-source-observation-scope source)
       :origin-as-read (ml0-source-origin-as-read source)
       :subject-act-id (ml0-source-subject-act-id source)
       :payload-digest (ml0-source-payload-digest source)
       :frontier-relation (ml0-source-frontier-relation source)
       :attests (ml0-source-attests source)
       :observation-interval (ml0-source-observation-interval source)
       :validation-standing :stored-assertion
       :door (ml0-source-door source)
       :recorded-validation (or (ml0-source-recorded-validation source)
                                :validated-by-door))
      source))

(defun make-ml0-bundle (&key fixture-row claimed-act-id subject-principal
                             observations testimony sources
                             issuance-observation
                             (issuance-standing nil issuance-standing-supplied)
                             issuance-scope
                             record-coverage-observation
                             (record-coverage nil record-coverage-supplied)
                             (record-coverage-scope nil record-coverage-scope-supplied)
                             effect-observation)
  ;; ⚠ :ISSUANCE-STANDING IS NO LONGER ACCEPTED, AND PASSING IT IS REFUSED RATHER
  ;; THAN IGNORED.  In the blocked build a caller wrote the keyword and
  ;; `ml0-write` copied it into the durable bytes with no predicate ever
  ;; consulted.  Silently dropping it now would leave that caller believing it had
  ;; recorded an issuance; the refusal tells it otherwise.
  (when issuance-standing-supplied
    (ml0-refuse 'ml0-standing-vocabulary-refused "ML0-BND-6"
                "issuance standing may not be supplied (~s): it is DERIVED from a ~
validated issuance observation, or it is :unresolved.  Pass :issuance-observation ~
from `ml0-observe-issuance` instead" issuance-standing))
  ;; ⚠ AND NEITHER IS :RECORD-COVERAGE (R4, Codex finding F3), for exactly the
  ;; same reason and with exactly the same shape of refusal.  A caller used to
  ;; write `an issuance record is present in the account store` — a claim about
  ;; THIS LANE'S OWN STORE, the one universe this lane is competent over — and
  ;; hand over a `:looked` scope it built itself, and nothing ever opened the
  ;; store.  Silently dropping the value would leave that caller believing it had
  ;; recorded a coverage finding; the refusal tells it otherwise, and names the
  ;; door that can actually produce one.
  (when (or record-coverage-supplied record-coverage-scope-supplied)
    (ml0-refuse 'ml0-standing-vocabulary-refused "ML0-BND-10"
                "record coverage may not be supplied (~s / ~s): it is DERIVED from ~
a reading taken by `ml0-observe-record-coverage`, which SCANS this lane's account ~
store, or it is :not-examined.  Pass :record-coverage-observation instead"
                record-coverage record-coverage-scope))
  (when record-coverage-observation
    (unless (ml0-record-coverage-observation-p record-coverage-observation)
      (ml0-refuse 'ml0-provenance-incomplete "ML0-BND-11"
                  "the record-coverage observation must come from ~
`ml0-observe-record-coverage`; got ~s" record-coverage-observation)))
  (unless (and (stringp subject-principal) (plusp (length subject-principal)))
    (ml0-refuse 'ml0-provenance-incomplete "ML0-BND-1"
                "a bundle MUST name the SUBJECT principal — the principal whose ~
act this account is about — as a non-empty string"))
  (unless (every #'ml0-observation-p observations)
    (ml0-refuse 'ml0-provenance-incomplete "ML0-BND-7"
                "every :observations entry must be an ml0-observation from a ~
production door; a source row is not an observation and may not be passed as one"))
  (unless (and (every #'ml0-source-p testimony) (every #'ml0-source-p sources))
    (ml0-refuse 'ml0-provenance-incomplete "ML0-BND-8"
                "every :testimony / :sources entry must be an ml0-source"))
  (when issuance-observation
    (unless (and (ml0-observation-p issuance-observation)
                 (eq :issuance-door (ml0-observation-door issuance-observation)))
      (ml0-refuse 'ml0-provenance-incomplete "ML0-BND-9"
                  "the issuance observation must come from ml0-observe-issuance")))
  ;; ⚑ `:SOURCES` SURVIVES AS A TESTIMONY-ONLY ALIAS, and that is deliberate: every
  ;; caller written against the blocked build keeps working, and every such
  ;; caller's rows become what they always were — assertions that cannot warrant.
  ;; A rename would have broken them loudly; this makes them SAFE quietly and
  ;; refuses them loudly only where they tried to promote.
  ;;
  ;; ⚠ R3: AND NOW THE ALIAS IS ENFORCED RATHER THAN NAMED.  In R2 the channel was
  ;; called testimony-only and did not make it so: a row arriving here kept
  ;; whatever standing it had, and the chair's disposition required that
  ;; `:sources` and `:testimony` `refuse or normalize every non-observation source
  ;; to non-warranting testimony`.  Every row through these two keywords is now
  ;; NORMALIZED, whatever it arrived as.  The consequence is a property worth
  ;; stating in one sentence:
  ;;
  ;;    ⚑ THE ONLY WARRANT-BEARING CHANNEL INTO A BUNDLE IS `:OBSERVATIONS`
  ;;      (AND `:ISSUANCE-OBSERVATION`), AND THEY ADMIT ONLY DOOR-BUILT
  ;;      `ML0-OBSERVATION` OBJECTS.
  ;;
  ;; This also closes a path nothing else did: a caller could pull the rows out of
  ;; a RETRIEVED account (`ml0-account-sources`), which after R3 carry inherited
  ;; warrants, and re-assert them into a FRESH bundle — turning `a door read this
  ;; in some past process` into a new `:direct-write` account claiming to be a
  ;; present reading.  Consolidation is the lawful route for a past account, and it
  ;; is now the only one.
  (let ((testimony (mapcar #'%ml0-normalize-as-testimony (append testimony sources))))
   (unless (or observations testimony issuance-observation)
    (ml0-refuse 'ml0-provenance-incomplete "ML0-BND-2"
                "a bundle MUST carry at least one observation or one typed source; ~
an account with no provenance is not a weaker account, it is not an account"))
  ;; ⚠ ML0-BND-3 IS GONE, and its absence is the repair rather than an omission.
  ;; It validated a CALLER-SUPPLIED issuance standing against the closed set —
  ;; which is exactly the wrong question, because the defect was never that the
  ;; caller might pick a word outside the vocabulary; it was that the caller got
  ;; to pick at all.  The standing is now DERIVED at the foot of this function
  ;; from a door's live reading, and is valid by construction.  Supplying it is
  ;; refused above (ML0-BND-6).
  ;; ⚠ ML0-BND-4 AND ML0-BND-5 ARE GONE, AND THEIR ABSENCE IS THE REPAIR RATHER
  ;; THAN AN OMISSION — the same move ML0-BND-3 made on the issuance axis.  BND-4
  ;; validated a caller-supplied finding against the closed vocabulary and BND-5
  ;; demanded a scope beside it; both asked the wrong question, because the defect
  ;; was never that a caller might pick a word outside the three or forget a
  ;; scope.  It was that the caller got to pick at all, and that the scope it was
  ;; forced to supply was one it wrote itself.  The finding is now DERIVED below
  ;; from a door's live scan and is valid by construction; supplying it is refused
  ;; above (ML0-BND-10).
  (%make-ml0-bundle
   :fixture-row fixture-row :claimed-act-id claimed-act-id
   :subject-principal subject-principal
   :observations observations :testimony testimony
   ;; the issuance observation's own row is durable like any other: the reading
   ;; is recorded whatever it said, and the STANDING is derived from it below.
   :sources (append (mapcar #'ml0-observation-source observations)
                    (when issuance-observation
                      (list (ml0-observation-source issuance-observation)))
                    testimony)
   :issuance-observation issuance-observation
   ;; ⚑ DERIVED, NOT ACCEPTED.  :ISSUED-IN-WRITING-IMAGE is reachable only when a
   ;; door actually asked Core /0's live predicate and it answered true.
   ;; Everything else — no observation, or an observation whose predicate answered
   ;; false — is :UNRESOLVED, because this lane's issuance axis has no negative
   ;; member and a false answer from an image-local predicate is not an absence.
   :issuance-standing (if (ml0-observation-issued-p issuance-observation)
                          :issued-in-writing-image
                          :unresolved)
   :issuance-scope (or issuance-scope
                       (and issuance-observation
                            (ml0-source-observation-scope
                             (ml0-observation-source issuance-observation))))
   ;; ⚑ DERIVED, NOT ACCEPTED.  A finding other than :NOT-EXAMINED is reachable
   ;; only when `ml0-observe-record-coverage` actually opened this lane's store,
   ;; and the scope travelling with it is the one THAT SCAN wrote — including the
   ;; :COULD-NOT-LOOK scope it writes when the store's prefix is not valid.
   :record-coverage (if record-coverage-observation
                        (ml0-record-coverage-observation-finding
                         record-coverage-observation)
                        :not-examined)
   :record-coverage-scope (and record-coverage-observation
                               (ml0-record-coverage-observation-scope
                                record-coverage-observation))
   :record-coverage-observation record-coverage-observation
   :effect-observation effect-observation)))

;;; ===========================================================================
;;; §7 — THE SEMANTIC OBJECT: one canonical, language-level, durable account of
;;; ONE act.
;;;
;;; The six questions of the commission, INDEPENDENTLY ANSWERABLE:
;;;   1. which act?           -> act-id / act-id-hex / subject-seat / attempt
;;;   2. occurrence standing? -> occurrence-standing + occurrence-scope
;;;   3. issuance standing?   -> issuance-standing + issuance-scope  (A SEPARATE
;;;                              FIELD, never folded into 2)
;;;   4. world/effect?        -> effect-observation (a SCOPED OBSERVATION of the
;;;                              adopted external-effect axis)
;;;   5. why may it say this? -> sources (typed provenance, one row each)
;;;   6. how was it derived?  -> derivation + predecessors
;;; ===========================================================================

(defstruct (ml0-account (:constructor %make-ml0-account (&key id id-hex act-id act-id-hex subject-seat subject-attempt occurrence-standing occurrence-scope issuance-standing issuance-scope record-coverage record-coverage-scope effect-observation sources derivation predecessors recorder-principal subject-principal retrieval-origin standing-authority carried-standings body-record)) (:copier nil))
  (id nil :read-only t)                    ; kernel0 durable-identity, :claim
  (id-hex nil :read-only t)                ; STRING, 64 hex, content-derived
  (act-id nil :read-only t)                ; CD/0 identifier
  (act-id-hex nil :read-only t)            ; STRING
  (subject-seat nil :read-only t)          ; STRING
  (subject-attempt nil :read-only t)       ; STRING
  (occurrence-standing nil :read-only t)
  (occurrence-scope nil :read-only t)
  (issuance-standing nil :read-only t)
  (issuance-scope nil :read-only t)
  (record-coverage nil :read-only t)
  (record-coverage-scope nil :read-only t)
  (effect-observation nil :read-only t)
  (sources nil :read-only t)
  (derivation nil :read-only t)
  (predecessors nil :read-only t)          ; list of CD/0 identifiers
  (recorder-principal nil :read-only t)
  (subject-principal nil :read-only t)
  (retrieval-origin nil :read-only t)      ; :reconstructed, always, by law
  ;; ⚑ R4 (Codex finding F2).  WHICH ROUTE PRODUCED THE STANDINGS ABOVE.
  ;; :VALIDATED-RETRIEVAL — the enclosing PJ0 frame chain was verified by
  ;;                        `validate-journal` before anything was decoded.
  ;; :RAW-DECODE          — a caller handed over a frame and nothing verified
  ;;                        that it came out of any store.  On this route the
  ;;                        standings above are RE-DERIVED from the rows (which,
  ;;                        being :stored-assertion to a row, warrant nothing),
  ;;                        never read off the bytes.
  (standing-authority nil :read-only t)
  ;; What the BYTES claimed, preserved verbatim so nothing is erased: a plist
  ;; (:occurrence-standing … :issuance-standing … :record-coverage …).  On the
  ;; validated route it equals the installed standings; on the raw route it is
  ;; the caller's claim beside the lane's own answer.
  (carried-standings nil :read-only t)
  (body-record nil :read-only t))          ; the exact durable body

(defun ml0-account-id-datum (account)
  "The account identity as a CD/0 identifier, for use as a PREDECESSOR entry in
a derived account's durable body."
  (idf (list +ml0-lane-stem+ "account" (ml0-account-id-hex account))))

(defun ml0-species-may-warrant-occurrence-p (species)
  "⚠ THE R4 REPAIR IS THE ARGLIST.  Until 2026-08-20 this function took a public
`&key defect`, and one keyword — `:issuance-implies-occurrence` — made Core /0
issuance testimony an admitted occurrence species, i.e. evidence-present read as
occurrence-present, the exact RED disease this lane exists to refuse.  The seam
was documented `production NIL, controls only` and defended by NOTHING BUT THAT
DOCSTRING; a cross-family adversarial audit flipped it through the front door.

THERE IS NOW NO PARAMETER TO PASS.  The mutants that need the collapse live in
`ml0-mutant-overlay.lisp`, which the canonical `load.lisp` never loads, and they
reach it by REDEFINING this function rather than by a lever it carries."
  (and (member species +ml0-occurrence-species+) t))

(defun ml0-account-occurred-p (account)
  "THE PUBLIC READER THE CROWN NEGATIVE INTERROGATES.  It answers from ONE field,
and that field was computed by the promotion rule from durable bytes.  There is
no second route to a positive occurrence reading anywhere in this lane's public
surface."
  (eq :occurred (ml0-account-occurrence-standing account)))

(defun ml0-account-issuance-only-p (account)
  "TRUE when the account's positive provenance is issuance testimony ALONE: at
least one issuance source, and NO source of a species that may warrant
occurrence.  This is the public, typed discriminant under which an issuance-only
bundle is lawfully stored — relay §5.A's second branch, chosen and tested."
  (and (some (lambda (s) (eq :core0-issuance-testimony (ml0-source-species s)))
             (ml0-account-sources account))
       (notany (lambda (s) (ml0-species-may-warrant-occurrence-p
                            (ml0-source-species s)))
               (ml0-account-sources account))
       t))

(defun ml0-account-carries-no-current-image-evidence-p (account)
  "⚠ THE INSTRUMENT IS SHOWN ABLE TO FIRE BEFORE IT IS TRUSTED (ml0-controls,
CONTROL 7b): a mutant account that retains a live Core /0 evidence object turns
this NIL.  An instrument never seen to fire is untested, not passing.

It walks every value reachable from the account's public surface and asserts that
none is a `core0-evidence` and none is registered as issued in this image.
Retrieval mints nothing and promotes nothing; this is the MEASUREMENT of that
sentence rather than its narration."
  (labels ((clean (value depth)
             (cond
               ;; ⚠ FAIL CLOSED AT THE BUDGET, NEVER OPEN.  This predicate's TRUE
               ;; means `I looked and found none`; a budget that returned TRUE on
               ;; exhaustion would make it mean `I stopped looking`, which is the
               ;; absence-without-an-adequacy-warrant defect INSIDE the very
               ;; instrument that exists to warrant an absence.
               ((> depth 32) nil)
               ((lisp-plus-core0:core0-evidence-p value) nil)
               ((lisp-plus-core0:core0-evidence-current-image-issued-p value) nil)
               ((ml0-source-p value)
                (and (clean (ml0-source-coordinate value) (1+ depth))
                     (clean (ml0-source-subject-act-id value) (1+ depth))))
               ((consp value)
                ;; ⚠ A LIST IS WALKED ITERATIVELY, NOT BY RECURSING ON ITS CDR.
                ;; Counting each cdr as a level of depth would turn the budget
                ;; into a LENGTH LIMIT: an account with more sources than the
                ;; budget would have its TAIL UNEXAMINED, and — under the old
                ;; fail-open budget — the instrument would have reported CLEAN
                ;; because it stopped looking.  Found by adversarial re-reading
                ;; after every gate was already green; the depth budget now
                ;; bounds NESTING only, and the walk covers the whole list.
                (let ((cell value))
                  (loop while (consp cell)
                        do (unless (clean (car cell) (1+ depth))
                             (return-from clean nil))
                           (setf cell (cdr cell)))
                  (if (null cell) t (clean cell (1+ depth)))))
               (t t))))
    (and (clean (ml0-account-sources account) 0)
         (clean (ml0-account-body-record account) 0)
         (clean (ml0-account-effect-observation account) 0)
         (clean (ml0-account-predecessors account) 0)
         t)))

(defun ml0-account-may-continue-p (account)
  "ALWAYS NIL, and it is a LAW rather than an implementation detail.  A memory
account is not current-image Core /0 evidence and is not a capability; retrieval
confers neither.  The function exists so that a caller asking the question gets
an answer from this lane instead of inventing one — and so the answer is
TESTABLE (D4)."
  (declare (ignore account))
  nil)

;;; ===========================================================================
;;; §8 — THE PROMOTION RULE.  ONE public function, an explicit conjunction over
;;; independent instruments.
;;;
;;; Model: `act1-reconciliation-closes-seat-p` (act1.lisp:1327-1341) — a
;;; conjunction over multiple independent instruments with a planted mutant kept
;;; alive to be killed — and `act1-derive-class`'s discipline: computed BY
;;; READING DURABLE BYTES, never by reading a condition's type name or a claim's
;;; own text.
;;;
;;; ⚑ THE INDEPENDENCE TEST, in one sentence: the rule inspects only facts that
;;; WOULD NOT BECOME TRUE MERELY BECAUSE AN EVIDENCE OBJECT WAS MINTED.
;;; ===========================================================================

(defun ml0-source-warranting-validation-p (source)
  "MAY THIS ROW'S VALIDATION STANDING SUPPORT A WARRANT AT ALL?  TRUE in exactly
two cases, and both of them are stamps not exposed through the exported, supported
API (package privacy is not a capability boundary — R4.1c wording):

  · :VALIDATED-BY-DOOR — a door of this lane read the substrate in THIS process.
  · :INHERITED-FROM-VALIDATED-RECORD — a warrant carried forward by
    `ml0-retrieve` AFTER `validate-journal` verified the enclosing PJ0 frame chain
    and the account's own identity re-digested to the identity its frame names.
    The authority is the STORE'S frame-digest chain, never the record's own field.

⚠ REPAIRED IN R3, AND THE OLD SECOND CLAUSE WAS THE BLOCKER.  It read:
`:STORED-ASSERTION whose RECORDED validation is :validated-by-door` also warrants.
But `ml0-source-from-record` is PUBLIC and reads that recorded claim out of the
record's own `\"validation-standing\"` field — so a caller could write the field,
call the decoder, and receive a promotion-capable row without any substrate ever
being read.  ONE FLIPPED FIELD, reproduced at `RED-R2-BEFORE.txt` probe R2B1,
exit 1.  The front desk had stopped issuing witness badges and the public
photocopier had started authenticating the copy.

:ASSERTED-TESTIMONY never supports a warrant, however complete its fields.
:STORED-ASSERTION — what the public decoder produces, ALWAYS — never supports one
either, whatever its bytes record.  A round trip through a file has never made
anything more true, and a round trip through a file a caller wrote makes it less."
  (member (ml0-source-validation-standing source)
          '(:validated-by-door :inherited-from-validated-record)))

(defparameter +ml0-promotion-legs+
  '((:validation           . "ML0-PROMOTE-0")
    (:species              . "ML0-PROMOTE-1")
    (:attestation          . "ML0-PROMOTE-2")
    (:subject-identity     . "ML0-PROMOTE-3")
    (:acquisition-route    . "ML0-PROMOTE-4")
    (:declared-scope       . "ML0-PROMOTE-5")
    (:frontier-relation    . "ML0-PROMOTE-6")
    (:canonical-payload    . "ML0-PROMOTE-7")
    (:provenance           . "ML0-PROMOTE-8"))
  "THE NINE LEGS OF THE CONJUNCTION, IN ORDER, EACH WITH ITS OWN REQUIREMENT ID.
(EIGHT before the 2026-08-20 repair round; leg 0, `:validation`, is BLOCK 1's cure.)

⚑ WHY THE IDS EXIST (work order AMENDMENT 1.2): a refusal to promote must NAME
WHICH CONJUNCT ANSWERED.  Without that, a crown-negative row could be passing for
the wrong reason — a malformed bundle, a missing scope, an identity mismatch —
while the disease it was built to catch walked past underneath.  The ids make the
answer a fact a transcript can carry rather than an inference a reader has to
make.")

(defun ml0-occurrence-conjuncts (act-id source)
  "The nine legs, evaluated against ONE source, as an ordered alist
((LEG . BOOLEAN) ...).  This is the whole content of the promotion rule; the
predicate below is its conjunction, and both the transcripts and the tests read
this so they can say WHICH LEG ANSWERED."
  (list
   ;; ⚑ LEG 0, ADDED IN THE 2026-08-20 REPAIR ROUND, AND IT IS CHECKED FIRST.
   ;; Every other leg reads a field.  This one asks whether ANYONE LOOKED — and
   ;; the blocked build had no way to ask, which is why a caller could fill the
   ;; other seven perfectly and be believed.
   (cons :validation (ml0-source-warranting-validation-p source))
   (cons :species (and (ml0-species-may-warrant-occurrence-p
                        (ml0-source-species source)) t))
   (cons :attestation (eq :frontier-crossed-for-this-identity
                          (ml0-source-attests source)))
   (cons :subject-identity (and (same-datum-p (ml0-source-subject-act-id source)
                                              act-id) t))
   (cons :acquisition-route (and (member (ml0-source-acquisition-route source)
                                         +ml0-acquisition-routes+) t))
   (cons :declared-scope (and (ml0-scope-p (ml0-source-observation-scope source))
                              (eq :looked (ml0-scope-status
                                           (ml0-source-observation-scope source)))
                              (plusp (length (ml0-scope-universe
                                              (ml0-source-observation-scope source))))
                              (plusp (length (ml0-source-observation-interval source)))
                              t))
   (cons :frontier-relation (and (plusp (length (ml0-source-frontier-relation source)))
                                 t))
   (cons :canonical-payload (and (hex64-p (ml0-source-payload-digest source)) t))
   (cons :provenance (and (plusp (length (ml0-source-producer-principal source)))
                          (plusp (length (ml0-source-recorder-principal source)))
                          (plusp (length (ml0-source-origin-as-read source)))
                          t))))

(defun ml0-failing-leg (conjuncts)
  "The FIRST leg that answered false, and its requirement id, as
(values LEG REQUIREMENT).  NIL NIL when every leg held."
  (dolist (pair +ml0-promotion-legs+ (values nil nil))
    (let ((answer (assoc (car pair) conjuncts)))
      (when (and answer (not (cdr answer)))
        (return (values (car pair) (cdr pair)))))))

(defun ml0-print-conjuncts (label act-id source &key (stream *standard-output*))
  "The conjunct table, printed in the tooth's OWN output — never left to a reader
to reconstruct from prose elsewhere."
  (let ((conjuncts (ml0-occurrence-conjuncts act-id source)))
    (format stream "~&  CONJUNCTS · ~a  (species ~a, attests ~a)~%"
            (format nil label)
            (string-downcase (symbol-name (ml0-source-species source)))
            (string-downcase (symbol-name (ml0-source-attests source))))
    (dolist (pair +ml0-promotion-legs+)
      (format stream "    ~12a [~a] : ~a~%"
              (string-downcase (symbol-name (car pair))) (cdr pair)
              (if (cdr (assoc (car pair) conjuncts)) "yes" "NO  <== this leg answered")))
    (finish-output stream)
    conjuncts))

(defun ml0-occurrence-warranted-p (act-id sources)
  "THE PROMOTION RULE.  Returns (values WARRANTED-P SOURCE REASON CONJUNCTS).

⚑ THE PROPOSITION IT WARRANTS IS PINNED, and is +ML0-OCCURRED-PROPOSITION+
verbatim: *the governed protected effect associated with canonical act identity A
crossed/applied and is present in the declared journal/world universe under its
derived external-request identity.*  It does NOT mean `perform was invoked`: a
lawful refusal is itself an execution event whose protected deed did not occur.

`:occurred` requires ALL NINE LEGS of +ML0-PROMOTION-LEGS+, together, OF ONE
SOURCE.  NOT ONE OF THEM IS A FACT ABOUT AN EVIDENCE OBJECT: a `core0-evidence`
account, its digest, its receipt, or a report describing it fails leg (1) even
when a caller has filled every other field perfectly — which is precisely the
single-delta shape the crown negative presents.

⚠ THE RULE READS SOURCES, NEVER STANDINGS.  It is never handed an
`occurrence-standing` and asked to agree with it; no supported public call asserts
a standing to it — it reads rows, whose stamps are not exposed through the
exported, supported API (package privacy is not a capability boundary; an internal
constructor remains callable through package-internal access; BOA closes the
supported `#S` route, not every possible call — R4.1e wording).

⚠ AND THE MUTANT SEAM IS GONE FROM THIS FUNCTION (R4).  Until 2026-08-20 the
body opened with a `(when (eq defect :issuance-implies-occurrence) …)` block that
returned T for any validated issuance row — the forbidden admission `Core
evidence ⇒ occurrence basis` — and `defect` was a PUBLIC keyword on this exported
function.  The mutant still exists and still kills, but it now lives in
`ml0-mutant-overlay.lisp` and installs itself by REDEFINING this function, so the
loaded production image has no branch to reach."
  (let ((best nil) (best-conjuncts nil) (best-score -1))
    (dolist (source sources)
      (let* ((conjuncts (ml0-occurrence-conjuncts act-id source))
             (score (count-if #'cdr conjuncts)))
        (when (every #'cdr conjuncts)
          (return-from ml0-occurrence-warranted-p
            (values t source
                    (format nil "all nine legs held: species ~a, attests ~a, route ~a"
                            (ml0-source-species source)
                            (ml0-source-attests source)
                            (ml0-source-acquisition-route source))
                    conjuncts)))
        (when (> score best-score)
          (setf best source best-conjuncts conjuncts best-score score))))
    (if best
        (multiple-value-bind (leg requirement) (ml0-failing-leg best-conjuncts)
          (values nil nil
                  (format nil "no source satisfied the conjunction; the closest ~
candidate (species ~a) failed first at leg ~a [~a]"
                          (ml0-source-species best) leg requirement)
                  best-conjuncts))
        (values nil nil "no sources were presented" nil))))

(defun ml0-nonoccurrence-warranted-p (act-id sources)
  "THE NEGATIVE READING'S RULE.  Returns (values WARRANTED-P SOURCE).

A scoped negative observation warrants `:nonoccurred` ONLY under the four-part
warrant carried across from AP-REC-1: DOMAIN COMPLETENESS (the scope declares the
universe it covered), AUTHORITY OVER THE IDENTITY (the source names the act by a
byte-equal identity), A DISTINCT INSPECTABLE WITNESS (the species is a scoped
negative observation whose detail names the mechanism), and A RECORD BINDING
witness-mechanism / evidence-identity / procedure-identity / origin / validation
standing (the source row itself).

⚠ AND THE SCOPE'S STATUS MUST BE :LOOKED.  DEFECT :DROP-SCOPE is the planted
mutant kept alive to be killed: it lets a :COULD-NOT-LOOK masquerade as
looked-and-absent.  Absence of an occurrence warrant is not proof of
nonoccurrence — and a FAILED LOOK is not even an absence."
  (dolist (source sources (values nil nil))
    (when (and (member (ml0-source-species source) +ml0-nonoccurrence-species+)
               ;; ⚠ A NEGATIVE READING NEEDS A LOOK TOO.  AP-REC-1's warrant
               ;; requires a DISTINCT INSPECTABLE WITNESS; an asserted row is not
               ;; one, and a scoped absence nobody looked for is the purest form
               ;; of the absence-without-an-adequacy-warrant defect.
               (ml0-source-warranting-validation-p source)
               (eq :no-record-for-this-identity (ml0-source-attests source))
               (same-datum-p (ml0-source-subject-act-id source) act-id)
               (eq :looked (ml0-scope-status
                            (ml0-source-observation-scope source)))
               (plusp (length (ml0-scope-universe
                               (ml0-source-observation-scope source))))
               (plusp (length (ml0-scope-detail
                               (ml0-source-observation-scope source))))
               (plusp (length (ml0-source-frontier-relation source))))
      (return (values t source)))))

(defun ml0-derive-occurrence-standing (act-id sources)
  "The standing a DIRECT WRITE may carry.  :CONTRADICTED is NOT reachable here —
it may be emitted by consolidation only, because a contradiction is a relation
BETWEEN accounts, not a property of one bundle."
  (multiple-value-bind (occurred source)
      (ml0-occurrence-warranted-p act-id sources)
    (if occurred
        (values :occurred (ml0-source-observation-scope source))
        (multiple-value-bind (nonoccurred negative-source)
            (ml0-nonoccurrence-warranted-p act-id sources)
          (if nonoccurred
              (values :nonoccurred (ml0-source-observation-scope negative-source))
              (values :unresolved nil))))))

;;; ===========================================================================
;;; §9 — THE DURABLE RENDERING: the account body, the ten-field envelope, and the
;;; content-derived account identity.
;;;
;;; The envelope is the ADOPTED ten-field standard event envelope (One Act /0,
;;; act0.lisp:556-571; capability /2, events.lisp:66-88), filled with HONEST
;;; values.  Four constants differ from capability /2's, deliberately and for the
;;; same reason One Act /0's differ.
;;; ===========================================================================

(defun %ml0-null-scope (universe detail)
  (make-ml0-scope :universe universe :status :could-not-look :detail detail))

(defun ml0-account-body (&key act-id act-id-hex subject-seat subject-attempt
                              occurrence-standing occurrence-scope
                              issuance-standing issuance-scope
                              record-coverage record-coverage-scope
                              effect-observation sources derivation
                              predecessors recorder-principal subject-principal)
  "THE ACCOUNT BODY — EIGHTEEN ENTRIES, EXACTLY, AND NO OTHERS.  Every field is
present on every account: a MISSING FIELD IS A REFUSAL, never a NIL and never an
absent key a reader would have to guess about (One Act /0's J-9-0 discipline,
applied here)."
  (rec (entry '("account" "act-id") act-id)
       (entry '("account" "act-id-hex") (s-datum act-id-hex))
       (entry '("account" "subject-seat") (s-datum subject-seat))
       (entry '("account" "subject-attempt") (s-datum subject-attempt))
       (entry '("account" "occurrence-standing")
              (s-datum (string-downcase (symbol-name occurrence-standing))))
       (entry '("account" "occurrence-scope")
              (ml0-scope-record
               (or occurrence-scope
                   (%ml0-null-scope
                    "no scoped observation warrants this standing"
                    "the standing is :unresolved or :contradicted; no single scope is its warrant"))))
       (entry '("account" "issuance-standing")
              (s-datum (string-downcase (symbol-name issuance-standing))))
       (entry '("account" "issuance-scope")
              (ml0-scope-record
               (or issuance-scope
                   (%ml0-null-scope
                    "no scope declared for issuance"
                    "the issuance axis carries only :issued-in-writing-image or :unresolved; a scope on it narrows testimony, it never confers competence"))))
       ;; ⚑ RECORD COVERAGE IS A SEPARATE FIELD WITH A SEPARATE VOCABULARY, and
       ;; the separation is the whole of AMENDMENT 1.1.  What THIS STORE holds is
       ;; a thing this lane is competent to state; what Core /0's image-local
       ;; registry holds is not, and no scope can make it so.
       (entry '("account" "record-coverage")
              (s-datum (string-downcase (symbol-name record-coverage))))
       (entry '("account" "record-coverage-scope")
              (ml0-scope-record
               (or record-coverage-scope
                   (%ml0-null-scope
                    "the account store was not examined for issuance records"
                    "record coverage is :not-examined on this account"))))
       (entry '("account" "effect-observation")
              (ml0-effect-observation-record
               (or effect-observation
                   (make-ml0-effect-observation
                    :standing-as-read "not-read"
                    :determinacy :indeterminate
                    :world-digest "could-not-look"
                    :scope (%ml0-null-scope
                            "the world was not looked at for this account"
                            "no world look was made by this write")))))
       (entry '("account" "sources") (seq (mapcar #'ml0-source-record sources)))
       (entry '("account" "source-count") (i-datum (length sources)))
       (entry '("account" "derivation")
              (s-datum (string-downcase (symbol-name derivation))))
       (entry '("account" "predecessors") (seq predecessors))
       (entry '("account" "recorder-principal")
              (idf (list "principal" recorder-principal)))
       (entry '("account" "subject-principal")
              (idf (list "principal" subject-principal)))
       (entry '("account" "rendering") (i-datum +ml0-rendering-version+))))

(defun ml0-mint-account-identity (body)
  "THE ACCOUNT IDENTITY: content-derived, in an EXISTING kernel /0 domain.

Domain :CLAIM — a member of the kernel's closed 19-domain set, unused by the act
lanes, and the honest one: an account is a CLAIM ABOUT an act; it is not the act
and not a receipt of one.  `make-identity`'s own law forbids a host-derived name
(identity.lisp:84-89: it never derives a name from host object identity), and
this name is a digest of the account's own canonical body — so two accounts with
DISTINCT PROVENANCE HAVE DISTINCT IDENTITIES BY CONSTRUCTION, which is what makes
consolidation's `never deduplicate distinct provenance` a fact about the
identities rather than a promise about the code.

Returns (values IDENTITY HEX)."
  (let* ((preimage (seq (list (s-datum +ml0-id-domain+) body)))
         (hex (sha256-hex (oct-copy (oct preimage)))))
    (unless (hex64-p hex)
      (ml0-refuse 'ml0-account-encoding-refused "ML0-ID-1"
                  "the account digest is not exactly 64 lowercase hex characters: ~s"
                  hex))
    (values (lisp-plus-kernel0:make-identity
             :claim (format nil "~a/account/~a" +ml0-lane-stem+ hex))
            hex)))

(defun ml0-account-envelope (&key account-hex subject-attempt subject-principal
                                  recording-process body derivation)
  "EXACTLY TEN FIELDS AND NO OTHERS.

⚑ THE FIVE PROVENANCE CONSTANTS, and why each is what it is:
  capture-boundary   boundary:memory-accounting — made at the MEMORY LAYER's own
                     boundary, never at a kernel transition.
  capture-mechanism  witness:lane-self-report   — this lane witnessed nothing; it
                     read bytes and wrote down what it read.
  origin             origin:self-reported       — and `origin:observed` is
                     UNMINTABLE here, in code (§2's gate), not merely unused.
  recorder-principal principal:memorylayer0     — who wrote this row.
  subject-principal  principal:<the actor>      — whose act it is ABOUT.

Nothing in Journal /0 constrains these values, so the choice is free — and being
free, it has to be honest.  These are the bytes of that honesty."
  (rec (entry '("event" "attempt") (idf (list "attempt" subject-attempt)))
       (entry '("event" "body") body)
       (entry '("event" "capture-boundary") (idf '("boundary" "memory-accounting")))
       (entry '("event" "capture-mechanism") (idf '("witness" "lane-self-report")))
       (entry '("event" "event-id")
              (idf (list "ml0-event"
                         (format nil "~a-~a"
                                 (ecase derivation
                                   (:direct-write "w")
                                   (:consolidation "c"))
                                 account-hex))))
       (entry '("event" "kind")
              (idf (list "ml0" (ecase derivation
                                 (:direct-write "account")
                                 (:consolidation "consolidated-account")))))
       (entry '("event" "origin") (idf '("origin" "self-reported")))
       (entry '("event" "process-id") (idf (list "process" recording-process)))
       (entry '("event" "recorder-principal")
              (idf (list "principal" +ml0-lane-stem+)))
       (entry '("event" "subject-principal")
              (idf (list "principal" subject-principal)))))

;;; ===========================================================================
;;; §10 — THE STORE-SCOPE ABSENCE INSTRUMENT.
;;;
;;; The inherited discipline this pays: a "the failed write left nothing behind"
;;; claim whose look never reached the whole store is not a claim, it is a hope.
;;;
;;; SCOPE WARRANT.  The universe of the look is the WHOLE DECLARED ACCOUNT-STORE
;;; DIRECTORY, and the instrument LISTS THE DIRECTORY in its own printed output to
;;; show which files exist rather than assuming a file set.  Compared: the sorted
;;; file-name list and every file's sha256.
;;;
;;; COMPETENCE WARRANT.  The instrument is shown able to see a change before it is
;;; trusted to report absence: ml0-controls drives a LAWFUL write between two
;;; snapshots and this instrument must catch it.  An instrument never seen to fire
;;; is untested, not passing.
;;; ===========================================================================

(defstruct (ml0-store-scope (:constructor %make-ml0-store-scope (&key directory files digests)) (:copier nil))
  (directory nil :read-only t)
  (files nil :read-only t)      ; sorted list of file namestrings
  (digests nil :read-only t))   ; alist (namestring . sha256-hex | :could-not-look)

(defun %ml0-file-sha (pathname)
  (with-open-file (stream pathname :direction :input
                                   :element-type '(unsigned-byte 8)
                                   :if-does-not-exist nil)
    (if stream
        (let ((octets (make-array (file-length stream)
                                  :element-type '(unsigned-byte 8))))
          (read-sequence octets stream)
          (sha256-hex octets))
        :could-not-look)))

(defun ml0-take-store-scope (directory)
  "⚠ :COULD-NOT-LOOK IS A DISTINCT VALUE from an empty file: a file that cannot be
opened yields :could-not-look, never the digest of zero octets, so a comparison
can never read a failed look as an unchanged store."
  (let ((files (sort (mapcar #'file-namestring
                             (directory (merge-pathnames "*.*" directory)))
                     #'string<)))
    (%make-ml0-store-scope
     :directory (namestring directory)
     :files files
     :digests (mapcar (lambda (name)
                        (cons name (%ml0-file-sha
                                    (merge-pathnames name directory))))
                      files))))

(defun ml0-store-scope-unchanged-p (before after)
  "TRUE only when the file SET is equal, every file's digest is equal, and NO LOOK
FAILED on either side.  A :could-not-look on either side makes this NIL."
  (and (equal (ml0-store-scope-files before) (ml0-store-scope-files after))
       (notany (lambda (pair) (eq :could-not-look (cdr pair)))
               (append (ml0-store-scope-digests before)
                       (ml0-store-scope-digests after)))
       (equal (ml0-store-scope-digests before) (ml0-store-scope-digests after))
       t))

(defun ml0-print-store-universe (label before after)
  "The universe of the look, printed in the tooth's OWN output — never left to a
reader to reconstruct from prose elsewhere."
  (ml0-note "STORE-SCOPE ~a — universe of the look: the ENTIRE declared account ~
store directory, whose file set is {~{~a~^, ~}} (LISTED by this instrument, not ~
assumed)" label (ml0-store-scope-files after))
  (dolist (pair (ml0-store-scope-digests after))
    (let ((prior (assoc (car pair) (ml0-store-scope-digests before) :test #'string=)))
      (ml0-note "  ~a: ~a -> ~a" (car pair)
                (if prior
                    (let ((v (cdr prior))) (if (stringp v) (subseq v 0 16) v))
                    "(absent)")
                (let ((v (cdr pair))) (if (stringp v) (subseq v 0 16) v))))))

;;; ===========================================================================
;;; §11 — THE HOST-FAULT DISCIPLINE.  One Act /1's repair is the pattern, and it
;;; is not relearned here.
;;;
;;; ⚠ A HOST FAULT MAY NOT WEAR A SEMANTIC REFUSAL'S CLOTHES.  Every call this
;;; lane makes INTO a consumed lane goes through this function.  The admitted
;;; families are enumerated BY ROOT, each root read out of that lane's own
;;; package.lisp rather than remembered:
;;;
;;;   · lisp-plus-journal0:pj0-condition        the account store beneath all
;;;   · lisp-plus-kernel0:kernel0-condition     identity, folds, §14.x
;;;   · lisp-plus-cd0:cd0-failure               the durable value boundary
;;;   · lisp-plus-language-act1:act1-condition  the act lane's own refusals
;;;   · lisp-plus-capability2:cap2-condition    the world / effect boundary
;;;
;;; DELIBERATELY NOT ADMITTED, and each absence is a decision:
;;;   · lisp-plus-core0:core0-condition — this lane never calls INTO Core /0 for
;;;     anything that can refuse; it calls two side-effect-free public predicates
;;;     and a handful of readers.  A core0-condition arriving here would mean this
;;;     lane's own control flow is wrong.
;;;   · ml0-condition — this lane's own contract violations are ALREADY the right
;;;     answer and must propagate unchanged rather than be reclassified into the
;;;     refusal they are complaining about.
;;;
;;; ⚑ AN ADMITTED FAMILY IS RE-SIGNALLED UNCHANGED, NOT ABSORBED.  This function
;;; never converts a lawful refusal into an account, a standing, or a
;;; discriminant; it only decides whether a condition is ADMITTED AT ALL.  The
;;; two-halved control (ml0-controls CONTROL 9a/9b) checks both halves.
;;; ===========================================================================

(defun ml0-through (what thunk)
  "Call THUNK, admitting only the enumerated families.  WHAT is a short string
naming the reach, carried into the refusal so a reader learns WHERE the
unadmitted fault arrived without parsing a report."
  (handler-case (funcall thunk)
    (ml0-condition (c) (error c))
    ((or lisp-plus-journal0:pj0-condition
         lisp-plus-kernel0:kernel0-condition
         lisp-plus-cd0:cd0-failure
         lisp-plus-language-act1:act1-condition
         lisp-plus-capability2:cap2-condition)
      (c)
      (error c))
    (error (c)
      (ml0-refuse 'ml0-bridge-contract-violated "ML0-BRIDGE-2"
                  "unadmitted condition ~a while reaching ~a: this is a HOST FAULT ~
of the lane's own implementation, not a semantic refusal and not an account.  ~
Admitted families are pj0/kernel0/cd0/act1/cap2; everything else arrives here by ~
definition" (type-of c) what))))

;;; ===========================================================================
;;; §12 — RETRIEVE.  EVIDENCE REPLAY, in Architecture 0.1's adopted D6
;;; vocabulary — never execution replay, never output reproduction.
;;;
;;; ⚠ READING PERFORMS NOTHING.  This function opens a store, validates it, folds
;;; the validated prefix, and decodes one frame.  It calls no act-lane door that
;;; acts, touches no world, and appends nothing anywhere.  The specimen MEASURES
;;; that — source journal, world, and account store all byte-unchanged across a
;;; retrieval — rather than narrating it.
;;;
;;; ⚠ READING AN OLD ACCOUNT DOES NOT MAKE THE READER THE ORIGINAL ACTOR.  The
;;; returned account's SUBJECT principal is the actor's, its RECORDER principal is
;;; this lane's, and its RETRIEVAL ORIGIN is :RECONSTRUCTED — the ratchet, which
;;; validation success never turns.
;;; ===========================================================================

(defun ml0-account-hex-of-event (event)
  "The account identity carried by this frame's event-id, read out of the DURABLE
BYTES rather than recomputed from a caller's memory.  NIL for a frame that is not
one of this lane's account frames."
  (let ((event-id (record-field event "event" "event-id")))
    (when (and event-id (lisp-plus-cd0:identifier-datum-p event-id))
      (let* ((rendered (identifier-segment-string event-id))
             (colon (position #\: rendered :from-end t)))
        (when colon
          (let ((tail (subseq rendered (1+ colon))))
            (when (and (> (length tail) 2)
                       (or (string= "w-" (subseq tail 0 2))
                           (string= "c-" (subseq tail 0 2)))
                       (hex64-p (subseq tail 2)))
              (subseq tail 2))))))))

(defun %ml0-inherit-source-warrant (source)
  "⚠ INTERNAL, AND REACHABLE FROM EXACTLY ONE PLACE: the validated decode inside
`ml0-retrieve`.  Promotes a decoded row from :STORED-ASSERTION (which warrants
nothing) to :INHERITED-FROM-VALIDATED-RECORD (which may) — and ONLY when the
durable bytes recorded a door's validation.  A row whose bytes recorded mere
testimony stays testimony forever, and no amount of validating the FRAME can make
a testimony row into an observation."
  (if (eq :validated-by-door (ml0-source-recorded-validation source))
      (%make-ml0-source
       :species (ml0-source-species source)
       :acquisition-route (ml0-source-acquisition-route source)
       :producer-principal (ml0-source-producer-principal source)
       :recorder-principal (ml0-source-recorder-principal source)
       :coordinate (ml0-source-coordinate source)
       :observation-scope (ml0-source-observation-scope source)
       :origin-as-read (ml0-source-origin-as-read source)
       :subject-act-id (ml0-source-subject-act-id source)
       :payload-digest (ml0-source-payload-digest source)
       :frontier-relation (ml0-source-frontier-relation source)
       :attests (ml0-source-attests source)
       :observation-interval (ml0-source-observation-interval source)
       :validation-standing :inherited-from-validated-record
       :door (ml0-source-door source)
       :recorded-validation (ml0-source-recorded-validation source))
      source))

(defun ml0-account-from-event (event)
  "⚠ RAW DECODE — EXPLICITLY INERT, AND THE INERTNESS IS THE R3 REPAIR.

Decode ONE CALLER-HELD frame into an ML0-ACCOUNT without any journal validation
whatever.  The caller brought the event; nothing here has verified that it came
out of a store, that its frame chain digests, or that any frame before it exists.

THEREFORE EVERY SOURCE ROW IT PRODUCES IS :STORED-ASSERTION AND WARRANTS NOTHING.
`ml0-source-warranting-validation-p` answers NIL for every row of a raw decode, so
a re-derivation over these rows can only reach :UNRESOLVED.  That is not a
degradation of the reader; it is the reader saying what it actually knows.

⚠ AND IN R3 THAT PARAGRAPH WAS PROSE, WHICH IS WHY IT WAS FALSE (Codex finding
F2).  The rows were inert; the STANDINGS were not.  The decoder read
`occurrence-standing` out of the caller's own bytes, checked it only against the
four-word vocabulary, and installed it — so `ml0-account-occurred-p` answered T
for a frame whose rows warranted nothing, and the two internal checks that looked
like defences (RB-10's act identity, RB-11's body digest) are INTERNAL-CONSISTENCY
checks: they prove the frame agrees with itself, never that `:occurred` follows
from anything.

R4 MAKES THE PARAGRAPH TRUE IN CODE.  On this route the occurrence standing is
RE-DERIVED by `ml0-derive-occurrence-standing` over the decoded rows, the issuance
standing is :UNRESOLVED (issuance is established by a live door reading, and there
is no door here), and record coverage is :NOT-EXAMINED (this lane scans its own
store through a door, and this route opened no store).  What the bytes CLAIMED is
not erased — it is preserved verbatim in `ml0-account-carried-standings`, beside
`ml0-account-standing-authority`, which reads :RAW-DECODE.  A caller that wants
the bytes' own word can still have it; what it cannot have is that word wearing
the authoritative reader's clothes.

⚑ WHY THE SPLIT EXISTS.  The chair's R2 disposition named this function as the
same disease as the decoder: `it parses an arbitrary caller-held event directly,
outside validate-journal, into the authoritative account type`.  The authoritative
path is `ml0-retrieve`, which validates the enclosing PJ0 frame chain FIRST and
only then inherits warrants (`%ml0-inherit-source-warrant`).  Both paths return
the same TYPE — an account is an account — and they differ in exactly the thing
that matters, which is whether anything in it can support a warrant.

⚑ IT IS STILL EXPORTED.  A future chair may prefer to withdraw it; that remains a
fork rather than a defect, and it is named in the RETURN so the choice is visible."
  (%ml0-decode-account-event event :inherit-warrants nil))

(defun %ml0-decode-account-event (event &key inherit-warrants)
  "⚠ INTERNAL.  The shared decoder.  INHERIT-WARRANTS is passed TRUE by exactly one
caller — `ml0-retrieve`, after `validate-journal` has verified the frame chain.
It is the SAME FLAG that decides two things, and that is deliberate: the rows may
inherit their recorded warrant, and the standings may be taken from the bytes,
under exactly one condition — that a validated frame chain put them there.

⚠ THE `:ORIGIN-UPGRADE-ON-READBACK` MUTANT SEAM IS GONE FROM THIS FUNCTION (R4).
It rewrote every decoded row's acquisition route to :LIVE-QUERY and declared the
retrieval a live query, i.e. treated successful validation as an upgrade of the
source's epistemic origin.  The ratchet exists to make that impossible and the
tooth exists to prove the ratchet is load-bearing — but the seam was a PUBLIC
`&key defect` on `ml0-retrieve` and on `ml0-account-from-event`.  The mutant now
lives in `ml0-mutant-overlay.lisp`, outside the canonical load."
  (let ((body (record-field event "event" "body")))
    (unless (and body (lisp-plus-cd0:record-datum-p body))
      (ml0-refuse 'ml0-account-readback-refused "ML0-RB-2"
                  "the frame carries no account body"))
    (flet ((field (name)
             (or (record-field body "account" name)
                 (ml0-refuse 'ml0-account-readback-refused "ML0-RB-2"
                             "the account body is missing field ~a — a missing ~
field is a refusal, never a NIL" name))))
      (let ((rendering (lisp-plus-cd0:integer-datum-value (field "rendering"))))
        (unless (eql rendering +ml0-rendering-version+)
          (ml0-refuse 'ml0-account-readback-refused "ML0-RB-7"
                      "account rendering version ~d is not this lane's ~d — an ~
account whose rendering rules this reader does not know is REFUSED, never ~
best-effort decoded" rendering +ml0-rendering-version+)))
      (let* ((sources-seq (field "sources"))
             (declared-count (lisp-plus-cd0:integer-datum-value
                              (field "source-count")))
             (raw-sources
               (let ((decoded
                       (loop for index below (lisp-plus-cd0:sequence-datum-length
                                              sources-seq)
                             collect (ml0-source-from-record
                                      (lisp-plus-cd0:sequence-datum-ref
                                       sources-seq index)))))
                 ;; ⚑ THE ONE PLACE A WARRANT MAY CROSS A PROCESS BOUNDARY, and it
                 ;; is gated on the CALLER, not on the bytes: only `ml0-retrieve`
                 ;; passes INHERIT-WARRANTS, and only after `validate-journal`.
                 (if inherit-warrants
                     (mapcar #'%ml0-inherit-source-warrant decoded)
                     decoded)))
             (sources raw-sources)
             (predecessors-seq (field "predecessors"))
             (predecessors
               (loop for index below (lisp-plus-cd0:sequence-datum-length
                                      predecessors-seq)
                     collect (lisp-plus-cd0:sequence-datum-ref predecessors-seq index)))
             (standing-string (lisp-plus-cd0:string-datum-value
                               (field "occurrence-standing")))
             (issuance-string (lisp-plus-cd0:string-datum-value
                               (field "issuance-standing")))
             (derivation-string (lisp-plus-cd0:string-datum-value
                                 (field "derivation")))
             (occurrence-standing
               (or (find-if (lambda (k) (string= standing-string
                                                 (string-downcase (symbol-name k))))
                            +ml0-occurrence-standings+)
                   (ml0-refuse 'ml0-account-readback-refused "ML0-RB-8"
                               "occurrence standing ~s read from durable bytes is ~
outside the declared four" standing-string)))
             (issuance-standing
               (or (find-if (lambda (k) (string= issuance-string
                                                 (string-downcase (symbol-name k))))
                            +ml0-issuance-standings+)
                   (ml0-refuse 'ml0-account-readback-refused "ML0-RB-8"
                               "issuance standing ~s read from durable bytes is ~
outside the declared two" issuance-string)))
             (record-coverage
               (let ((name (lisp-plus-cd0:string-datum-value
                            (field "record-coverage"))))
                 (or (find-if (lambda (k) (string= name (string-downcase
                                                         (symbol-name k))))
                              +ml0-record-coverages+)
                     (ml0-refuse 'ml0-account-readback-refused "ML0-RB-8"
                                 "record coverage ~s read from durable bytes is ~
outside the declared three" name))))
             (derivation
               (or (find-if (lambda (k) (string= derivation-string
                                                 (string-downcase (symbol-name k))))
                            +ml0-derivations+)
                   (ml0-refuse 'ml0-account-readback-refused "ML0-RB-8"
                               "derivation ~s is outside the declared two"
                               derivation-string))))
        (unless (eql declared-count (length sources))
          (ml0-refuse 'ml0-account-readback-refused "ML0-RB-9"
                      "the account declares ~d source(s) and carries ~d — a count ~
that disagrees with its own sequence is an identity inconsistency"
                      declared-count (length sources)))
        (let ((act-id (field "act-id"))
              (act-id-hex (lisp-plus-cd0:string-datum-value (field "act-id-hex"))))
          ;; ⚠ EVERY SOURCE IS RE-CHECKED AGAINST THE ACCOUNT'S OWN ACT IDENTITY ON
          ;; READBACK.  A store whose bytes were edited to cross provenance between
          ;; acts is refused here, not trusted because it parsed.
          (dolist (source sources)
            (unless (same-datum-p (ml0-source-subject-act-id source) act-id)
              (ml0-refuse 'ml0-account-readback-refused "ML0-RB-10"
                          "a ~a source in the durable bytes names act ~a while the ~
account names ~a" (ml0-source-species source)
                          (identifier-segment-string (ml0-source-subject-act-id source))
                          (identifier-segment-string act-id))))
          (multiple-value-bind (account-id account-hex) (ml0-mint-account-identity body)
            ;; ⚠ RB-11 NO LONGER SKIPS (R4, Codex finding F2).  Until 2026-08-20
            ;; the identity check ran only `(when carried …)`, so a frame whose
            ;; event-id is not one of this lane's `w-`/`c-` account shapes reached
            ;; the authoritative type with the check silently not made — an
            ;; absence-without-an-adequacy-warrant at the readback boundary: `no
            ;; disagreement found` where the truth was `nothing was compared`.  A
            ;; frame this lane does not recognize is now REFUSED outright.
            (let ((carried (ml0-account-hex-of-event event)))
              (unless carried
                (ml0-refuse 'ml0-account-readback-refused "ML0-RB-11"
                            "the frame carries no account event-id of this lane's ~
shape, so its body digest ~a can be compared against NOTHING — a frame whose ~
shape this reader does not know is refused, never decoded with the identity ~
check unmade" account-hex))
              (unless (string= carried account-hex)
                (ml0-refuse 'ml0-account-readback-refused "ML0-RB-11"
                            "the frame's event-id names account ~a but the body ~
digests to ~a — the identity and the content disagree" carried account-hex)))
            ;; ⚑ THE R4 SPLIT (Codex finding F2).  On the VALIDATED route the
            ;; standings come from the bytes a verified frame chain put there.  On
            ;; the RAW route they are RE-DERIVED here from the decoded rows, which
            ;; are :stored-assertion to a row and warrant nothing — so the raw
            ;; occurrence standing can only be :UNRESOLVED, and it is that because
            ;; the rule said so, not because a constant was written in.  The bytes'
            ;; own claim is preserved beside it rather than dropped.
            (multiple-value-bind (route-occurrence route-scope)
                (if inherit-warrants
                    (values occurrence-standing
                            (ml0-scope-from-record (field "occurrence-scope")))
                    (ml0-derive-occurrence-standing act-id sources))
            (%make-ml0-account
             :id account-id :id-hex account-hex
             :act-id act-id :act-id-hex act-id-hex
             :subject-seat (lisp-plus-cd0:string-datum-value (field "subject-seat"))
             :subject-attempt (lisp-plus-cd0:string-datum-value
                               (field "subject-attempt"))
             :occurrence-standing route-occurrence
             :occurrence-scope (or route-scope
                                   (%ml0-null-scope
                                    "no scoped observation warrants this standing"
                                    "re-derived on a raw decode; no row warranted anything"))
             :issuance-standing (if inherit-warrants issuance-standing :unresolved)
             :issuance-scope (ml0-scope-from-record (field "issuance-scope"))
             :record-coverage (if inherit-warrants record-coverage :not-examined)
             :record-coverage-scope (ml0-scope-from-record
                                     (field "record-coverage-scope"))
             :effect-observation (ml0-effect-observation-from-record
                                  (field "effect-observation"))
             :sources sources
             :derivation derivation
             :predecessors predecessors
             :recorder-principal (identifier-segment-string (field "recorder-principal"))
             :subject-principal (identifier-segment-string (field "subject-principal"))
             :retrieval-origin :reconstructed
             :standing-authority (if inherit-warrants
                                     :validated-retrieval
                                     :raw-decode)
             :carried-standings (list :occurrence-standing occurrence-standing
                                      :issuance-standing issuance-standing
                                      :record-coverage record-coverage)
             :body-record body))))))))

(defun ml0-retrieve (store &key account-hex)
  "RETRIEVE — deterministic validate + fold + decode of ONE durable account.

Returns an ML0-ACCOUNT and NOTHING ELSE: never a Core /0 evidence account, never
a capability, never a current-image witness, never world state, and never a
continuation token.

REFUSALS ARE TYPED AND TOTAL.  A torn tail, an interior corruption, an
unsupported rendering version, a missing field, or an identity inconsistency
produces a typed refusal AND NO ACCOUNT — there is no plausible partial account,
because a plausible partial account is exactly the shape a reader would trust."
  (let* ((report (ml0-through "validate-journal over the account store"
                              (lambda () (validate-journal store))))
         (status (prefix-report-status report))
         (events (prefix-report-events report))
         (found nil))
    ;; ⚠ THE STATUS IS CHECKED BEFORE THE SEARCH, so a torn journal can never be
    ;; answered out of its surviving prefix as though it were whole.
    (unless (eq :valid status)
      (ml0-refuse 'ml0-account-readback-refused "ML0-RB-1"
                  "the account store's validated prefix is ~s (condition ~a [~a]) — ~
a damaged journal yields NO account: the surviving prefix is evidence, never a ~
partial answer" status (prefix-report-condition-type report)
                  (prefix-report-condition-requirement report)))
    (loop for index below (fill-pointer events)
          for event = (aref events index)
          do (let ((hex (ml0-account-hex-of-event event)))
               (when (and hex (or (null account-hex) (string= hex account-hex)))
                 (setf found event)
                 (return))))
    (unless found
      (ml0-refuse 'ml0-account-readback-refused "ML0-RB-2"
                  "no account frame ~@[for identity ~a ~]exists in the store's ~
validated prefix of ~d frame(s)" account-hex (prefix-report-frame-count report)))
    ;; ⚑ THE VALIDATED PATH, AND THE ONLY ONE.  `validate-journal` has verified the
    ;; enclosing PJ0 frame chain above and the decoder re-digests the body against
    ;; the identity its own frame names; ONLY here may a decoded row inherit the
    ;; warrant its bytes record.  The raw public decoder gets no such flag.
    (%ml0-decode-account-event found :inherit-warrants t)))

(defun ml0-list-account-ids (store)
  "The account identities in the store's VALIDATED PREFIX, in frame order.
Returns (values HEXES FRAME-COUNT STATUS TAIL-SHA) — the tail is surfaced so a
caller can never mistake a torn journal for a complete one."
  (let* ((report (ml0-through "validate-journal over the account store"
                              (lambda () (validate-journal store))))
         (events (prefix-report-events report))
         (hexes '()))
    (loop for index below (fill-pointer events)
          for event = (aref events index)
          do (let ((hex (ml0-account-hex-of-event event)))
               (when hex (push hex hexes))))
    (values (nreverse hexes)
            (prefix-report-frame-count report)
            (prefix-report-status report)
            (prefix-report-tail-sha256 report))))


;;; ===========================================================================
;;; §12b — THE RECORD-COVERAGE DOOR (R4, Codex finding F3).
;;;
;;; ⚠ WHY THIS EXISTS AT ALL.  `record-coverage` is the one axis on which this
;;; lane declares itself COMPETENT — BND-5's `competent over its own store and
;;; over nothing else`.  And until 2026-08-20 the finding was a CALLER KEYWORD
;;; carrying a CALLER-BUILT `:looked` scope, and NO CODE ANYWHERE EVER SCANNED
;;; THE ACCOUNT STORE.  A caller wrote `an issuance record is present in the
;;; account store`, handed over a scope whose detail said whatever it liked, and
;;; the value went into the durable bytes and folded as authoritative.
;;;
;;; The lane's own cure for K1/K2 is the cure here: the difference between an
;;; assertion and an observation is not a field a caller fills in, it is a door the
;;; exported, supported API gives no way to impersonate (package privacy is not a
;;; capability boundary — R4.1c wording).  This is that door.  It is the supported
;;; producer of a record-coverage finding, and `make-ml0-bundle` refuses the keyword.
;;; ===========================================================================

(defstruct (ml0-record-coverage-observation
            (:constructor %make-ml0-record-coverage-observation (&key finding scope read-summary account-hexes)) (:copier nil))
  "A COVERAGE READING THIS LANE ACTUALLY TOOK.  The constructor is not exported and
the struct is BOA, for the same reason `ml0-observation`'s is: a reading is not a
thing the exported, supported API lets a caller assert (R4.1c wording)."
  (finding nil :read-only t)        ; a member of +ml0-record-coverages+
  (scope nil :read-only t)          ; ml0-scope — :looked, or :could-not-look
  (read-summary nil :read-only t)   ; STRING: what the door actually saw
  (account-hexes nil :read-only t)) ; the identities it opened, in frame order

(defun ml0-observe-record-coverage (store subject)
  "DOOR :RECORD-COVERAGE-DOOR — the supported producer of a record-coverage finding.

SCANS THE VALIDATED PREFIX of THIS LANE'S OWN account store, opens every account
frame in it through `ml0-retrieve`, and answers whether any of them names SUBJECT's
act identity AND carries `:issued-in-writing-image`.

⚠ THE UNIVERSE IS THE STORE, AND THE ADEQUACY WARRANT IS CARRIED.  If the store's
validated prefix is not `:valid` the door reports `:NOT-EXAMINED` under a
`:COULD-NOT-LOOK` scope — never `no issuance record`, which is the
absence-without-an-adequacy-warrant defect this lane exists to refuse.  `I could
not look` and `I looked and it is not there` are different sentences and this door
never says the second when it means the first.

⚠ THE FINDING IS THE SCAN'S ANSWER, NOT THE CALLER'S HOPE — the same discipline as
`ml0-observe-absence`.  A door that could only ever report absence, or only ever
presence, would be an instrument that had never been seen to fire; both branches
are exercised by the selftest."
  (unless (ml0-subject-p subject)
    (ml0-refuse 'ml0-provenance-incomplete "ML0-RC-1"
                "ml0-observe-record-coverage takes the canonical subject carrier ~
from `ml0-subject-from-fixture-row`; got ~s" subject))
  (multiple-value-bind (hexes frame-count status tail-sha) (ml0-list-account-ids store)
    (if (not (eq :valid status))
        (%make-ml0-record-coverage-observation
         :finding :not-examined
         :scope (make-ml0-scope
                 :universe (format nil "this lane's account store (~d frame(s), ~
prefix ~s)" frame-count status)
                 :status :could-not-look
                 :detail (format nil "the store's validated prefix is ~s, so no ~
statement about what it holds is available: a torn journal is not an empty one"
                                 status))
         :read-summary (format nil "the account store could not be examined: ~
validated prefix ~s at tail ~a" status tail-sha)
         :account-hexes nil)
        (let* ((act-id (ml0-subject-act-id subject))
               (matches
                 (loop for hex in hexes
                       for account = (ml0-retrieve store :account-hex hex)
                       when (and (same-datum-p (ml0-account-act-id account) act-id)
                                 (eq :issued-in-writing-image
                                     (ml0-account-issuance-standing account)))
                         collect hex))
               (finding (if matches
                            :issuance-record-present-in-account-store
                            :no-issuance-record-in-account-store)))
          (%make-ml0-record-coverage-observation
           :finding finding
           :scope (make-ml0-scope
                   :universe (format nil "the WHOLE validated prefix of this ~
lane's account store: ~d frame(s), ~d account identit~:@p, tail ~a"
                                     frame-count (length hexes) tail-sha)
                   :status :looked
                   :detail "ml0-observe-record-coverage/v1: every account frame in the validated prefix was opened through ml0-retrieve and its act identity compared byte-for-byte against the subject, and its issuance-standing read")
           :read-summary (format nil "~d of ~d account(s) name act ~a and carry ~
:issued-in-writing-image~@[ (~{~a~^, ~})~]"
                                 (length matches) (length hexes)
                                 (ml0-subject-act-id-hex subject) matches)
           :account-hexes hexes)))))

;;; ===========================================================================
;;; §13 — WRITE.  A typed source bundle becomes ONE durable account.
;;; ===========================================================================

(defun ml0-rederive-act-identity (fixture-row)
  "Re-derive the act identity from DECLARED CONFIGURATION ALONE, through One Act
/1's public NON-PERFORMING seam (`make-act1-record :register nil`).  Nothing is
performed, nothing is registered, and no run-local identity is consumed.

Returns (values ACT-ID ACT-ID-HEX SEAT ATTEMPT).

⚠ R3: this now delegates to `ml0-subject-from-fixture-row` so that the identity
`ml0-write` checks and the identity the DOORS stamp come from ONE derivation
function over ONE row.  Two derivations that could drift were the shape of
R2-BLOCK 2."
  (let ((subject (ml0-subject-from-fixture-row fixture-row)))
    (values (ml0-subject-act-id subject)
            (ml0-subject-act-id-hex subject)
            (ml0-subject-seat subject)
            (ml0-subject-attempt subject))))

(defun ml0-write (store bundle &key (recording-process +ml0-runtime-process-name+))
  "WRITE — the provenance-bearing DIRECT account.  Returns an ML0-ACCOUNT.

⚑ R4.1: `:DERIVATION` AND `:PREDECESSORS` ARE GONE FROM THIS ARGLIST.  Until
2026-08-21 a caller could pass `:derivation :consolidation` and any list of
predecessors as ORDINARY KEYWORD ARGUMENTS, so lineage was caller-selected and the
standing that rode with it was whatever the direct-write rule made of a bundle
whose rows the testimony channel had (correctly) downgraded — RED-CONSOLIDATION-
BEFORE.txt shows a computed :OCCURRED written back as :UNRESOLVED.  A derived
account is now written ONLY by `ml0-materialize-consolidation`, which treats the
carrier it is handed as an UNTRUSTED REQUEST (it re-retrieves the carrier's input
identities from the target store and writes the recomputed body); this function
writes `:direct-write` with no predecessors, always.

ORDER IS LOAD-BEARING AND IS NOT AN ACCIDENT OF READABILITY.  Every VALIDATION of
the caller's bundle — the subject re-derivation, the self-contradiction check, the
promotion rule, the body and identity construction — runs BEFORE the append, so a
write refused on any of those paths leaves the declared store byte-unchanged, a
fact a caller may check with `ml0-take-store-scope` on both sides of the call, and
which the controls check on EVERY such refusal path.

⚠ AND THE APPEND IS VERIFIED AFTER THE APPEND, WHICH IS NOT THE SAME PROMISE
(R4, Codex finding F4).  Until 2026-08-20 this docstring claimed, of a FAILED
write, that the WHOLE declared store was observably unchanged — flatly, with no
qualification.  That was FALSE, and the falsehood was structural rather than a
slip: step (6) reads the
frame back through `validate-journal`, and step (7) compares the identity — both
AFTER `append-event`, both able to refuse, and an append-only store has no
rollback.  So the honest semantics, which the caller is entitled to have in the
same breath as the guarantee:

  * A refusal from steps (1)–(5) is NON-MUTATING over the whole store.
  * A refusal from the READBACK (RB-1, RB-2, any decoder refusal) or from WR-5
    happens with the frame ALREADY APPENDED.  The frame is RETAINED AS EVIDENCE —
    it is what was actually written, and deleting it would destroy the record of
    the failure — and NO ML0-ACCOUNT is returned, so nothing downstream may read
    a standing off it.  A caller comparing store scopes across such a call WILL
    see the store change.  `ml0-retrieve` over a store in that state answers on
    its own terms: the frame is either valid (and is an ordinary account whose
    write call refused) or it is not (and RB-1 refuses the whole store).
  * The distinction is measured, not narrated: `ml0-controls` CONTROL 11 forces a
    post-append refusal and prints the store scope on both sides.

Structuring the operation so nothing can refuse after the append was considered
and NOT taken; the fork and its reason are in the RETURN's R4 section.

WHAT WRITE NEVER DOES: it never performs the act, never issues or promotes Core
/0 evidence, never authorizes a capability, and NEVER INFERS OCCURRENCE FROM A
SUCCESSFUL SERIALIZATION — the occurrence standing is computed before any byte is
written and is not touched afterwards.

⚑ AN ISSUANCE-ONLY BUNDLE IS STORED, NOT REFUSED, and that is the chosen branch
of relay §5.A: it is stored under the explicit, public, typed discriminant
`ml0-account-issuance-only-p`, with occurrence standing :UNRESOLVED, because a
lane that refused to remember `evidence was issued for this act` would lose a
true fact in order to avoid a false one.  The false one is prevented by the
promotion rule, which is where it belongs.

⚠ THE `DEFECT` / `DEFECT-PAYLOAD` PARAMETERS ARE GONE (R4, Codex finding F1).
This function used to take both, and forwarded `defect` into the promotion rule —
so `:issuance-implies-occurrence` on one public keyword wrote a durable account
reading `:occurred` for an act that lawfully refused.  The mutants that need those
collapses live in `ml0-mutant-overlay.lisp`, which the canonical `load.lisp` never
loads."
  (unless (ml0-bundle-p bundle)
    (ml0-refuse 'ml0-provenance-incomplete "ML0-WR-1"
                "ml0-write requires an ml0-bundle; got ~s" bundle))
  ;; ⚠ ML0-WR-2 (a caller-supplied derivation outside the vocabulary) IS GONE
  ;; WITH THE ARGUMENT: the derivation is now fixed by the entry point, and a
  ;; requirement that validates a word the caller can no longer say is not a
  ;; requirement.
  ;; ---- (1) THE SUBJECT IDENTITY, RE-DERIVED AND COMPARED, BEFORE ANYTHING.
  (let* ((subject (ml0-subject-from-fixture-row (ml0-bundle-fixture-row bundle)))
         (act-id (ml0-subject-act-id subject))
         (act-id-hex (ml0-subject-act-id-hex subject))
         (seat (ml0-subject-seat subject))
         (attempt (ml0-subject-attempt subject)))
    (declare (ignorable attempt))
    (let ((claimed (ml0-bundle-claimed-act-id bundle)))
      (when (and claimed (not (same-datum-p claimed act-id)))
        (ml0-refuse 'ml0-subject-identity-mismatch "ML0-WR-3"
                    "the bundle claims act identity ~a but the identity RE-DERIVED ~
from the declared row is ~a — refused BEFORE any durable mutation"
                    (identifier-segment-string claimed)
                    (identifier-segment-string act-id))))
    ;; ---- (2) EVERY SOURCE MUST BE ABOUT THIS ACT.  A source about another act is
    ;; ---- refused here, pre-mutation, WHATEVER ITS SPECIES.
    (dolist (source (ml0-bundle-sources bundle))
      (unless (same-datum-p (ml0-source-subject-act-id source) act-id)
        (ml0-refuse 'ml0-subject-identity-mismatch "ML0-WR-4"
                    "a ~a source names act ~a, but this account is about act ~a — ~
crossing provenance between acts is refused BEFORE any durable mutation"
                    (ml0-source-species source)
                    (identifier-segment-string (ml0-source-subject-act-id source))
                    (identifier-segment-string act-id))))
    ;; ---- (2a) THE DOOR BINDING, VERIFIED INDEPENDENTLY.  R2-BLOCK 2's second half.
    ;;
    ;; ⚑ WHY THE STAMPED SUBJECT-ACT-ID WAS NOT ENOUGH.  Check (2) above compares
    ;; the identity the door WROTE against the identity Write re-derives — and in
    ;; the blocked build a door would happily write the identity it was handed
    ;; while reading a substrate keyed to a different act.  Both numbers then
    ;; agreed, and the account was still about the wrong reading.
    ;;
    ;; So Write now re-derives the SUBSTRATE KEYS too — the attempt name, the
    ;; external-request key and the seat — from the bundle's own declared fixture
    ;; row, and compares them against the binding the door recorded in its
    ;; coordinate.  A door row that read one act and named another disagrees here
    ;; even though it agreed at (2).
    ;;
    ;; ⚠ SCOPE, STATED: this checks rows that CARRY A DOOR NAME.  Testimony rows
    ;; have no binding to check and cannot warrant anything; requiring a binding of
    ;; them would refuse honest assertions for a property they never claimed.
    (let ((expected (%ml0-subject-binding subject)))
      (dolist (source (ml0-bundle-sources bundle))
        (unless (eq :none (ml0-source-door source))
          (let ((carried (record-field (ml0-source-coordinate source)
                                       "coordinate" "subject-binding")))
            (unless carried
              (ml0-refuse 'ml0-subject-identity-mismatch "ML0-WR-7"
                          "a ~a row stamped by the ~a carries NO subject binding — ~
a door row without a binding cannot be checked against this bundle's declared ~
subject, and an uncheckable warrant is refused BEFORE any durable mutation"
                          (ml0-source-species source) (ml0-source-door source)))
            (unless (same-datum-p carried expected)
              (ml0-refuse 'ml0-subject-identity-mismatch "ML0-WR-7"
                          "a ~a row stamped by the ~a was taken over subject ~
binding ~a, but this bundle's declared row re-derives to ~a — the door read one ~
act and named another.  Refused BEFORE any durable mutation"
                          (ml0-source-species source) (ml0-source-door source)
                          (digest-of carried) (digest-of expected)))))))
    ;; ---- (2b) A BUNDLE MAY NOT CONTRADICT ITSELF.
    ;;
    ;; ⚑ FOUND BY ADVERSARIAL RE-READING, LATE, AND WORTH THE REPAIR.  If one
    ;; bundle carried BOTH a qualifying positive warrant AND a COMMENSURABLE
    ;; scoped negative, the promotion rule would answer :OCCURRED (occurrence is
    ;; checked first) — and consolidating that very account with itself would
    ;; then answer :CONTRADICTED, from the same source rows.  One source set, two
    ;; answers, depending on which door it went through.
    ;;
    ;; The work order reserves :CONTRADICTED to consolidation, so a write cannot
    ;; simply say it.  The honest alternative is not a quieter standing but a
    ;; REFUSAL: a caller holding two warrants that contradict each other over one
    ;; universe and one interval is not holding one account, it is holding two —
    ;; and this lane already provides the lawful path for that, which is to write
    ;; them separately and consolidate.  That path is also the ONLY one that
    ;; produces :CONTRADICTED, so nothing is lost and the asymmetry is closed.
    ;;
    ;; ⚠ INCOMMENSURABLE disagreement is NOT refused: looks at different declared
    ;; universes or different intervals are ordinary bookkeeping, and a bundle may
    ;; carry them.  The selftest checks both directions, so this is not a blanket.
    (let ((positives (remove-if-not
                      (lambda (src)
                        (every #'cdr (ml0-occurrence-conjuncts act-id src)))
                      (ml0-bundle-sources bundle)))
          (negatives (remove-if-not
                      (lambda (src)
                        (and (member (ml0-source-species src)
                                     +ml0-nonoccurrence-species+)
                             (eq :no-record-for-this-identity
                                 (ml0-source-attests src))
                             (eq :looked (ml0-scope-status
                                          (ml0-source-observation-scope src)))))
                      (ml0-bundle-sources bundle))))
      (dolist (p positives)
        (dolist (n negatives)
          (when (ml0-warrants-commensurable-p p n)
            (ml0-refuse 'ml0-provenance-incomplete "ML0-WR-6"
                        "this bundle contradicts itself: a qualifying ~a warrant ~
and a commensurable scoped negative address the same act over the same declared ~
universe and the same observation interval.  One account cannot hold both — ~
write them separately and consolidate, which is the only lawful route to ~
:contradicted.  Refused BEFORE any durable mutation"
                        (ml0-source-species p))))))
    ;; ---- (3) THE PROMOTION RULE.  Computed from the sources, never asserted.
    (multiple-value-bind (occurrence-standing occurrence-scope)
        (ml0-derive-occurrence-standing act-id (ml0-bundle-sources bundle))
      ;; ---- (4) THE BODY, THE IDENTITY, THE ENVELOPE.
      (let* ((body (ml0-through
                    "CD/0 account body construction"
                    (lambda ()
                      (ml0-account-body
                       :act-id act-id :act-id-hex act-id-hex
                       :subject-seat seat :subject-attempt attempt
                       :occurrence-standing occurrence-standing
                       :occurrence-scope occurrence-scope
                       :issuance-standing (ml0-bundle-issuance-standing bundle)
                       :issuance-scope (ml0-bundle-issuance-scope bundle)
                       :record-coverage (ml0-bundle-record-coverage bundle)
                       :record-coverage-scope (ml0-bundle-record-coverage-scope bundle)
                       :effect-observation (ml0-bundle-effect-observation bundle)
                       :sources (ml0-bundle-sources bundle)
                       :derivation :direct-write
                       :predecessors nil
                       :recorder-principal +ml0-lane-stem+
                       :subject-principal (ml0-bundle-subject-principal bundle))))))
        ;; ---- (5)-(7) THE APPEND AND ITS READBACK, shared with the derived route.
        (%ml0-append-body-and-read-back store body
                                        :subject-attempt attempt
                                        :subject-principal (ml0-bundle-subject-principal bundle)
                                        :recording-process recording-process
                                        :derivation :direct-write)))))

(defun %ml0-dry-decode (envelope account-hex)
  "⚠ INTERNAL (R5).  The pre-append dry decode required by §5.A as amended.
ENVELOPE is the exact event datum `append-event` will be handed; ACCOUNT-HEX the
identity just minted from its body.  Encodes with `encode-pjs0`, decodes with
`decode-pjs0` (requiring :canonical — the same bytes the store would hold), runs
`%ml0-decode-account-event` with inherited warrants (the route `ml0-retrieve`
takes), and requires the decoded account's identity to equal ACCOUNT-HEX.  Any
failure refuses as ML0-WR-8, BEFORE any durable mutation.  Returns T.

The decoder's own refusals (ML0-RB-*) are re-signalled under WR-8 with their
requirement id named, so a caller sees both WHICH check failed and THAT it failed
pre-append.  Touches no store."
  (let ((octets (ml0-through "dry decode: canonical encoding"
                             (lambda () (lisp-plus-journal0:encode-pjs0 envelope)))))
    (multiple-value-bind (datum status detail) (lisp-plus-journal0:decode-pjs0 octets)
      (unless (eq :canonical status)
        (ml0-refuse 'ml0-account-encoding-refused "ML0-WR-8"
                    "dry decode: the exact event does not round-trip canonically ~
(~s ~a) — refused BEFORE any durable mutation" status detail))
      (let ((account (handler-case (%ml0-decode-account-event datum :inherit-warrants t)
                       (ml0-condition (c)
                         (ml0-refuse 'ml0-account-encoding-refused "ML0-WR-8"
                                     "dry decode: the exact account decoder refuses ~
this frame (~a [~a]) — refused BEFORE any durable mutation"
                                     (type-of c) (ml0-condition-requirement-id c))))))
        (unless (string= (ml0-account-id-hex account) account-hex)
          (ml0-refuse 'ml0-account-encoding-refused "ML0-WR-8"
                      "dry decode: the decoded identity ~a is not the minted ~a — ~
refused BEFORE any durable mutation"
                      (ml0-account-id-hex account) account-hex))
        t))))

(defun %ml0-append-body-and-read-back (store body &key subject-attempt subject-principal
                                                       recording-process derivation)
  "⚠ INTERNAL.  Steps (4b)–(7) of a durable write, shared by the DIRECT route
(`ml0-write`) and the DERIVED route (`ml0-materialize-consolidation`) so the two
cannot drift: mint the content-derived identity, DRY-DECODE the exact canonical
event BEFORE the append (R5), append ONCE, read the frame back through
`validate-journal`, and compare identities (ML0-WR-5).

⚑ §5.A AS AMENDED (Sol, disposition B, WORK-ORDER AMENDMENT 2, 2026-08-21) — the
semantics of THIS function, for both routes:

  Every refusal raised before `append-event` is observably non-mutating over the
  whole declared store.  Once `append-event` succeeds, a subsequent readback or
  identity refusal returns no account and neither retracts nor rewrites durable
  bytes.  Any surviving bytes acquire no standing merely by surviving: they are
  judged only through Journal /0 validation and Memory Layer /0 retrieval.  Append
  success, serialization success, and evidence or certificate issuance are never
  evidence that the represented act occurred.

⚑ (4b) THE DRY DECODE (R5).  Before the append, the exact canonical event is
ENCODED (`encode-pjs0`, the same canonicalization `append-event` performs), DECODED
back (`decode-pjs0`, required :canonical), and run through THE EXACT ACCOUNT
DECODER (`%ml0-decode-account-event`, inherited-warrant route, as `ml0-retrieve`
would run it), and the identity it yields is compared to the identity just minted.
A decoder refusal, a non-canonical encoding, or an identity disagreement therefore
REFUSES BEFORE MUTATION (ML0-WR-8) — every refusal this lane itself can raise about
its own frame now fires pre-append.  The designed post-append refusal residue is
HOST FAULT ONLY: the bytes changing under us between append and readback.  No
rollback, truncation, tombstone or supersession exists or is wanted."
  (multiple-value-bind (account-id account-hex) (ml0-mint-account-identity body)
    (declare (ignore account-id))
    (let ((envelope (ml0-account-envelope
                     :account-hex account-hex
                     :subject-attempt subject-attempt
                     :subject-principal subject-principal
                     :recording-process recording-process
                     :body body :derivation derivation)))
      ;; ---- (4b) THE DRY DECODE — pre-mutation, on the exact canonical bytes.
      (%ml0-dry-decode envelope account-hex)
      ;; ---- (5) THE APPEND.  The FIRST durable mutation of this call, and the
      ;; ---- only one.
      (ml0-through "the account store append"
                   (lambda () (append-event store envelope)))
      ;; ---- (6) READ IT BACK.  "The append did not error" is not evidence the
      ;; ---- frame was written; this goes through `validate-journal`, which
      ;; ---- re-reads the bytes from disk and stops at the first frame that does
      ;; ---- not verify.
      (let ((account (ml0-retrieve store :account-hex account-hex)))
        ;; ---- (7) THE IDENTITY, COMPARED.
        (unless (string= (ml0-account-id-hex account) account-hex)
          (ml0-refuse 'ml0-account-readback-refused "ML0-WR-5"
                      "the account read back from the store carries identity ~
~a, not the ~a just written" (ml0-account-id-hex account) account-hex))
        account))))

;;; ===========================================================================
;;; §14 — CONSOLIDATE.  Deterministic and EFFECT-FREE over validated accounts.
;;;
;;; Architecture 0.1 D4, used as the governing law rather than paraphrased:
;;; "cross-journal merges are receipt-bearing transformations, never timestamp
;;; sorts."  So:
;;;
;;;   ORDERING          lexicographic by the account's CONTENT-DERIVED identity
;;;                     hex.  No clock, no arrival order, no caller order.
;;;   EXACT DUPLICATES  two inputs with the SAME account identity are the same
;;;                     record and are kept once.  Because that identity is a
;;;                     digest of the WHOLE body, DISTINCT PROVENANCE PRODUCES A
;;;                     DISTINCT IDENTITY BY CONSTRUCTION — so "never deduplicate
;;;                     records with distinct provenance merely because their
;;;                     projected claims match" is a fact about the identities,
;;;                     not a promise about this code.
;;;   /0 NEVER FORGETS  no compaction, no tombstone, no GC, no provenance erasure.
;;;                     The inputs' durable records are untouched; consolidate
;;;                     appends nothing and opens no store.
;;; ===========================================================================

(defun ml0-fold-issuance (accounts)
  "THE ISSUANCE AXIS FOLDS SEPARATELY AND NEVER MEETS THE OCCURRENCE AXIS.

:ISSUED-IN-WRITING-IMAGE survives from any input: testimony that an account WAS
minted in SOME writing image is a positive fact, and nothing in this lane can
defeat it — because nothing in this lane can observe Core /0's registry at all.
Everything else is :UNRESOLVED.  There is no negative member to fold, and its
absence is AMENDMENT 1.1's correction rather than an oversight.

⚠ ISSUANCE-ONLY IS NEVER UPGRADED TO OCCURRED by this function or any other: the
two axes share no code path, and this function cannot even SEE an occurrence
standing."
  (let ((standings (mapcar #'ml0-account-issuance-standing accounts)))
    (if (member :issued-in-writing-image standings)
        :issued-in-writing-image
        :unresolved)))

(defun ml0-fold-record-coverage (accounts)
  "Record coverage folds on its OWN field, never onto issuance.  A PRESENT finding
beats an ABSENT finding (a record found somewhere is a record); disagreement below
that collapses to :NOT-EXAMINED rather than picking a side."
  (let ((coverages (mapcar #'ml0-account-record-coverage accounts)))
    (cond ((member :issuance-record-present-in-account-store coverages)
           :issuance-record-present-in-account-store)
          ((every (lambda (c) (eq :no-issuance-record-in-account-store c)) coverages)
           :no-issuance-record-in-account-store)
          (t :not-examined))))

(defun ml0-warrants-commensurable-p (a b)
  "⚑ THE COMMENSURABILITY TEST (work order AMENDMENT 1.5).  Two qualified warrants
may CONTRADICT each other only when they address the SAME PROPOSITION over a
COMPATIBLE DECLARED SCOPE and a COMPATIBLE FRONTIER/SEQUENCE INTERVAL.

Same act identity plus opposite keywords is NOT enough, and the reason is not
pedantry: two honest looks at DIFFERENT universes, or at different points in a
sequence, are expected to differ, and calling their difference a contradiction
would manufacture a conflict out of ordinary bookkeeping.  What such a pair
deserves is preservation and :UNRESOLVED — never last-write-wins, and never a
contradiction that was never there.

Compatible is tested, not assumed: the declared scope UNIVERSE strings must match,
the declared OBSERVATION INTERVALS must match, and BOTH SCOPES MUST HAVE STATUS
:LOOKED.  All are required fields of a source, so none can be silently absent.

⚑ THE CHAIR'S QUESTION, ANSWERED EXPLICITLY (disposition of 2026-08-20): IS
`observation-interval` THE SOLE MACHINE-READABLE FRONTIER/SEQUENCE RELATION?  NO.
A source carries THREE frontier/sequence facts, and they are three different kinds
of thing:

  · `observation-interval`  the INTERVAL the look covers — machine-readable, a
                            declared string compared with STRING=.
  · `attests`               the FINDING — machine-readable, a closed keyword from
                            +ML0-ATTESTATIONS+.
  · `frontier-relation`     the NARRATION of the finding — a declared string, not
                            a closed vocabulary.

Commensurability compares the INTERVAL and the SCOPE. It deliberately does NOT
compare the finding or its narration, AND THAT IS NOT AN OVERSIGHT BUT THE
DEFINITION: two commensurable warrants that AGREE on the finding are corroboration;
two that DISAGREE on the finding over the same scope and interval are precisely
what `:contradicted` means. Requiring `frontier-relation` to match would make
`:contradicted` unreachable by construction, because a positive reading and a
negative reading never narrate the same sentence.

⚠ THIS IS A DISCLOSED DEVIATION from the letter of the disposition's fourth
BLOCK-2 bullet, which directs that `ml0-warrants-commensurable-p` `must also
compare the relevant frontier relation` if the interval is not the sole one. The
RELEVANT relation for commensurability is the interval, and it is compared; the
other two are the finding and its narration, and comparing them would collapse the
concept. The chair can overrule this in one line and the change is one line; it is
flagged here and in the RETURN rather than made quietly either way."
  (and (same-datum-p (ml0-source-subject-act-id a) (ml0-source-subject-act-id b))
       (string= (ml0-scope-universe (ml0-source-observation-scope a))
                (ml0-scope-universe (ml0-source-observation-scope b)))
       (eq :looked (ml0-scope-status (ml0-source-observation-scope a)))
       (eq :looked (ml0-scope-status (ml0-source-observation-scope b)))
       (string= (ml0-source-observation-interval a)
                (ml0-source-observation-interval b))
       t))

;;; ⚑ R4.1 — THE CONSOLIDATION RESULT IS A TYPED CARRIER, CONSTRUCTED HERE ONLY.
;;;
;;; Until 2026-08-21 `ml0-consolidate` returned five bare values and pointed the
;;; caller at `ml0-write` with `:derivation :consolidation` — a route that could
;;; not carry the result: `make-ml0-bundle :sources` is the public TESTIMONY
;;; channel and (correctly) normalizes every inherited row to testimony, so a
;;; computed :OCCURRED was written back as :UNRESOLVED, and a lawful :CONTRADICTED
;;; was refused at ML0-WR-6.  RED-CONSOLIDATION-BEFORE.txt measures this.
;;;
;;; CONSTRUCTION PRIVACY IS DEFENSE IN DEPTH, NOT THE SOUNDNESS BOUNDARY (R4.1c
;;; wording, after the cross-family reviews).  The narrower facts: no constructor
;;; is exported; the supported SBCL `#S` default-constructor route is refused
;;; because every one of the lane's ten structures uses a BOA constructor; and
;;; Common Lisp package privacy is not a capability boundary, so none of that is
;;; what keeps durable bytes honest.  What does: `ml0-materialize-consolidation`
;;; treats a presented carrier as an UNTRUSTED REQUEST — no presented body field
;;; selects durable standing or lineage; the carrier's INPUT IDENTITIES select
;;; what the target store is asked to retrieve, and the body written is recomputed
;;; from those retrievals and checked against the presented one by canonical-body
;;; SHA-256 digest (ML0-MAT-2 on mismatch).
;;;
;;; ⚠ WHAT THE CARRIER IS NOT: it is not an account (it has no identity and no
;;; frame), and holding one proves nothing durable — only materialization does.

(defstruct (ml0-consolidation (:constructor %make-ml0-consolidation (&key act-id act-id-hex subject-seat subject-attempt subject-principal occurrence-standing occurrence-scope issuance-standing issuance-scope record-coverage record-coverage-scope sources predecessors inputs clash)) (:copier nil))
  (act-id nil :read-only t)               ; CD/0 identifier, shared by every input
  (act-id-hex nil :read-only t)
  (subject-seat nil :read-only t)
  (subject-attempt nil :read-only t)
  (subject-principal nil :read-only t)
  (occurrence-standing nil :read-only t)  ; RE-DERIVED over the union; may be :contradicted
  (occurrence-scope nil :read-only t)     ; the warranting row's scope, or the clash's
  (issuance-standing nil :read-only t)    ; folded on its OWN axis
  (issuance-scope nil :read-only t)
  (record-coverage nil :read-only t)
  (record-coverage-scope nil :read-only t)
  (sources nil :read-only t)              ; the EXACT union, deterministic order
  (predecessors nil :read-only t)         ; CD/0 identifiers, in ordered-input order
  (inputs nil :read-only t)               ; the deduped, content-ordered accounts
  (clash nil :read-only t))               ; (positive . negative) when :contradicted

(defun ml0-consolidate (accounts)
  "CONSOLIDATE — a derived reading over VALIDATED accounts.  EFFECT-FREE: it
appends nothing, opens nothing, and touches no store.  Returns an
ML0-CONSOLIDATION carrier; `ml0-materialize-consolidation` is the ONLY path from
that carrier to a durable derived account, and the derived account's provenance
names every input.

ADMITTED INPUTS: accounts whose `ml0-account-standing-authority` is
:VALIDATED-RETRIEVAL — i.e. obtained from `ml0-retrieve` (or returned by a
write, which reads its own frame back through `ml0-retrieve`).  A :RAW-DECODE
account is refused (ML0-CON-3): its standings were re-derived from rows that
warrant nothing, and folding it would let a caller-held frame vote.

⚠ THE `DEFECT` PARAMETER IS GONE (R4, Codex finding F1).  `:last-write-wins` —
take the last ordered input's standing and erase the contradiction — used to be a
public keyword on this exported function.  It is still a planted mutant and it is
still killed; it now lives in `ml0-mutant-overlay.lisp`, outside the canonical
load."
  (unless (and accounts (every #'ml0-account-p accounts))
    (ml0-refuse 'ml0-consolidation-refused "ML0-CON-1"
                "consolidation requires at least one validated ml0-account"))
  ;; ---- (0) EVERY INPUT MUST HAVE COME THROUGH A VALIDATED RETRIEVAL.  Checked
  ;; ---- before the act-identity check, because an unvalidated account's act
  ;; ---- identity is itself only a claim.
  (dolist (account accounts)
    (unless (eq :validated-retrieval (ml0-account-standing-authority account))
      (ml0-refuse 'ml0-consolidation-refused "ML0-CON-3"
                  "consolidation admits only accounts obtained through a VALIDATED ~
retrieval; account ~a carries standing authority ~s — a raw decode's standings ~
were re-derived from rows that warrant nothing, and they may not vote"
                  (ml0-account-id-hex account)
                  (ml0-account-standing-authority account))))
  (let ((act-id (ml0-account-act-id (first accounts)))
        (seat (ml0-account-subject-seat (first accounts)))
        (attempt (ml0-account-subject-attempt (first accounts)))
        (principal (ml0-account-subject-principal (first accounts))))
    (declare (ignorable principal))
    ;; ---- CROSS-ACT IS REFUSED BEFORE ANY OUTPUT IS PRODUCED.
    (dolist (account (rest accounts))
      (unless (same-datum-p (ml0-account-act-id account) act-id)
        (ml0-refuse 'ml0-consolidation-refused "ML0-CON-2"
                    "cross-act consolidation is refused BEFORE producing an output: ~
~a and ~a are different acts"
                    (ml0-account-act-id-hex (first accounts))
                    (ml0-account-act-id-hex account)))
      ;; ---- ONE SUBJECT CARRIER FOR THE DERIVED ACCOUNT.  Same act implies same
      ;; ---- seat and attempt (both are inputs to the identity); the subject
      ;; ---- principal is not, so it is checked rather than taken from whichever
      ;; ---- input sorted first.
      (unless (and (string= seat (ml0-account-subject-seat account))
                   (string= attempt (ml0-account-subject-attempt account))
                   (string= principal (ml0-account-subject-principal account)))
        (ml0-refuse 'ml0-consolidation-refused "ML0-CON-4"
                    "the inputs share an act but not a subject carrier (seat/attempt/~
principal ~s ~s ~s vs ~s ~s ~s) — a derived account has ONE subject, and this ~
lane will not pick one"
                    seat attempt principal
                    (ml0-account-subject-seat account)
                    (ml0-account-subject-attempt account)
                    (ml0-account-subject-principal account))))
    (let* ((ordered (sort (copy-list accounts) #'string< :key #'ml0-account-id-hex))
           (deduped (let ((seen '()) (out '()))
                      (dolist (account ordered (nreverse out))
                        (unless (member (ml0-account-id-hex account) seen
                                        :test #'string=)
                          (push (ml0-account-id-hex account) seen)
                          (push account out)))))
           ;; ⚑ THE UNION KEEPS EVERY DISTINCT SOURCE ROW — REPAIRED 2026-08-20.
           ;;
           ;; ⚠ THE BLOCKED BUILD COMPARED SPECIES, PAYLOAD DIGEST AND PRODUCER
           ;; PRINCIPAL, AND THE COMMENT BESIDE IT CALLED THAT `THE SAME READING OF
           ;; THE SAME BYTES BY THE SAME MECHANISM`.  It was not.  Coordinate,
           ;; recorder, acquisition route, scope, origin, subject identity,
           ;; frontier relation, attestation, observation interval, validation
           ;; standing and door were ALL ignored — so two genuinely different
           ;; readings could agree on three fields and one of them would silently
           ;; disappear from an account whose entire purpose is provenance.  A
           ;; comment that overclaims its own test is worse than no comment: it
           ;; tells the next reader not to look.
           ;;
           ;; THE TEST IS NOW THE COMPLETE CANONICAL `ml0-source-record` BYTES, by
           ;; digest.  Two rows collapse when they ARE the same row and never
           ;; otherwise — which is what the old comment claimed and now describes.
           (sources (remove-duplicates
                     (loop for account in deduped
                           append (ml0-account-sources account))
                     :test (lambda (a b)
                             (string= (digest-of (ml0-source-record a))
                                      (digest-of (ml0-source-record b))))
                     :from-end t))
           (predecessors (mapcar #'ml0-account-id-datum deduped))
           ;; ⚑ THE COMMENSURABILITY SEARCH (AMENDMENT 1.5).  A contradiction is
           ;; a relation between TWO QUALIFIED WARRANTS, not between two
           ;; keywords, so it is looked for among the SOURCES rather than read
           ;; off the inputs' standings.
           (positives (remove-if-not
                       (lambda (src)
                         (every #'cdr (ml0-occurrence-conjuncts act-id src)))
                       sources))
           (negatives (remove-if-not
                       (lambda (src)
                         (and (member (ml0-source-species src)
                                      +ml0-nonoccurrence-species+)
                              (eq :no-record-for-this-identity
                                  (ml0-source-attests src))
                              (eq :looked (ml0-scope-status
                                           (ml0-source-observation-scope src)))))
                       sources))
           (commensurable-clash
             (loop for p in positives
                   thereis (loop for n in negatives
                                 thereis (and (ml0-warrants-commensurable-p p n)
                                              (list p n))))))
      (multiple-value-bind (occurrence occurrence-scope)
              (cond
                ;; ⚑ A COMMENSURABLE CONTRADICTION IS PRESERVED, EXPLICITLY.  No
                ;; last-write-wins truth, no majority vote: two QUALIFIED and
                ;; COMPARABLE observations that disagree leave the account
                ;; :CONTRADICTED with BOTH warrants standing in the union of
                ;; sources.
                (commensurable-clash
                 (values :contradicted
                         (let ((scope (ml0-source-observation-scope
                                       (first commensurable-clash))))
                           (make-ml0-scope
                            :universe (ml0-scope-universe scope)
                            :status :looked
                            :detail "CONTRADICTED: two commensurable warrants disagree over this universe and one observation interval; both stand in the sources"))))
                ;; ⚠ AND AN INCOMMENSURABLE PAIR IS NOT A CONTRADICTION.  Inputs
                ;; whose standings differ but whose warrants address different
                ;; universes or different intervals fall through to the rule
                ;; below: both warrants are preserved in `sources`, nothing is
                ;; overwritten, and the combined reading is whatever the rule
                ;; makes of the union — which is honest, because the disagreement
                ;; was never about one question.
                ;; ⚠ THE INHERITED-STANDING SHORTCUT IS GONE (repaired 2026-08-20).
                ;; The blocked build read `(member :contradicted standings)` and
                ;; adopted an input's KEYWORD — inheriting a conclusion instead of
                ;; re-deriving it from surviving warrants, in the one function
                ;; whose whole discipline is that standings are computed from
                ;; sources and never inherited.  An input marked :contradicted
                ;; whose warrants did not survive validation now contributes
                ;; exactly what its surviving warrants contribute, and no more.
                ;; If two commensurable warrants still disagree, the clash search
                ;; above finds them and says so on its own evidence.
                ;; ⚑ :OCCURRED ONLY BECAUSE A QUALIFYING BASIS SURVIVES VALIDATION
                ;; AND IS NAMED — never because two records were numerous or
                ;; durable.  The rule is RE-RUN over the union of surviving
                ;; sources; it is not inherited from the inputs' standings.
                (t (ml0-derive-occurrence-standing act-id sources)))
        (let* ((issuance (ml0-fold-issuance deduped))
               (coverage (ml0-fold-record-coverage deduped))
               ;; the scope of the FIRST ordered input that carries the folded
               ;; standing — deterministic, because the order is
               (issuance-scope (let ((a (find issuance deduped
                                             :key #'ml0-account-issuance-standing)))
                                 (and a (ml0-account-issuance-scope a))))
               (coverage-scope (let ((a (find coverage deduped
                                             :key #'ml0-account-record-coverage)))
                                 (and a (ml0-account-record-coverage-scope a)))))
          (%make-ml0-consolidation
           :act-id act-id
           :act-id-hex (ml0-account-act-id-hex (first deduped))
           :subject-seat seat :subject-attempt attempt :subject-principal principal
           :occurrence-standing occurrence :occurrence-scope occurrence-scope
           :issuance-standing issuance :issuance-scope issuance-scope
           :record-coverage coverage :record-coverage-scope coverage-scope
           :sources sources :predecessors predecessors :inputs deduped
           :clash (and commensurable-clash
                       (cons (first commensurable-clash) (second commensurable-clash)))))))))

(defun ml0-materialize-consolidation (store consolidation
                                      &key (recording-process +ml0-runtime-process-name+))
  "MATERIALIZE — write ONE derived account from an ML0-CONSOLIDATION carrier and
return the account READ BACK from the store.  This is the lane's route from a
consolidation to durable bytes; the carrier is handled as an untrusted request.

WHAT IT TAKES FROM THE CARRIER (R4.1b): ONLY THE IDENTITIES OF ITS INPUTS.
Everything else is RECOMPUTED from the target store — each input re-retrieved
through `ml0-retrieve`, the fold re-run by `ml0-consolidate` — and the presented
carrier is compared to that recomputation by canonical body digest; a difference
is refused (ML0-MAT-2).  What is written is the recomputed body: the folded
standings and scopes, the exact source union (inherited observation rows stay
:inherited-from-validated-record and serialize as a door's stamp, exactly as a
validated retrieve would re-inherit them), the predecessor identities, and the
derivation `:consolidation`.  The exact claim: NO PRESENTED BODY FIELD SELECTS
DURABLE STANDING OR LINEAGE — the carrier's input identities select what the store
is asked to retrieve, and the resulting body is recomputed from those retrievals
and checked against the presented carrier by canonical-body SHA-256 digest.
(Until 2026-08-21 this docstring said the carrier's fields were taken UNCHANGED
and that nothing here recomputes — true of the R4.1 code, false after the R4.1b
repair; SCRUTATOR-II caught the stale sentence.)

WHAT IT DOES NOT DO: it does not re-run the direct-write promotion rule (a
derived standing was computed by consolidation over the union and is written AS
COMPUTED, including :CONTRADICTED); it does not apply ML0-WR-6's
self-contradiction refusal (that refusal belongs to a single bundle; a
contradiction BETWEEN accounts is the thing consolidation exists to record); it
reads no world and no act journal (the effect observation is the null
`not-read`); it performs nothing, issues nothing, and authorizes nothing.

WHAT IT SHARES WITH `ml0-write`: the append-and-readback tail, so the failed-write
semantics are identical on both routes."
  (unless (ml0-consolidation-p consolidation)
    (ml0-refuse 'ml0-consolidation-refused "ML0-MAT-1"
                "materialization requires an ml0-consolidation carrier produced by ~
ml0-consolidate; got ~s" consolidation))
  ;; ⚑ R4.1b (SCRUTATOR, cross-family review): THE CARRIER IS NOT TRUSTED — THE
  ;; STORE IS RE-READ.  A carrier is a data object a caller holds, and a data
  ;; object can be copied, and its list cells can be rewritten through the very
  ;; readers that make it inspectable (`rplaca` on `ml0-consolidation-sources`
  ;; swapped the occurrence basis while the computed :occurred stood — executed,
  ;; RED-CARRIER-BEFORE.txt).  So materialization takes from the presented carrier
  ;; ONLY the identities of its inputs, re-retrieves each of them from the TARGET
  ;; store through `ml0-retrieve` (validated chain, inherited warrants), re-runs
  ;; the fold over what the store actually holds, and writes THAT.  The presented
  ;; carrier is then compared to the recomputed one by the canonical bytes of the
  ;; body each would produce: a difference is a REFUSAL (ML0-MAT-2), never a
  ;; silent correction — a caller holding a carrier that disagrees with the store
  ;; is holding a stale or tampered object, and the honest answer is to say so.
  ;;
  ;; Consequence, stated: every predecessor must be RETRIEVABLE FROM THE TARGET
  ;; STORE.  A carrier computed over accounts of store A cannot be materialized
  ;; into store B (ML0-MAT-3) — a derived account whose predecessors the reading
  ;; store cannot produce would be a lineage claim the store cannot check.  This
  ;; narrows the cross-journal case to future work, deliberately (fork R4.1-F3).
  (let* ((hexes (mapcar (lambda (input)
                          (unless (ml0-account-p input)
                            (ml0-refuse 'ml0-consolidation-refused "ML0-MAT-1"
                                        "a carrier input is not an account: ~s" input))
                          (ml0-account-id-hex input))
                        (ml0-consolidation-inputs consolidation)))
         (retrieved (mapcar (lambda (hex)
                              (handler-case (ml0-retrieve store :account-hex hex)
                                (ml0-account-readback-refused (c)
                                  (ml0-refuse 'ml0-consolidation-refused "ML0-MAT-3"
                                              "predecessor ~a is not retrievable from ~
the target store (~a [~a]) — a derived account's lineage must be checkable by the ~
store that holds it" hex (type-of c) (ml0-condition-requirement-id c)))))
                            hexes))
         (recomputed (ml0-consolidate retrieved))
         (presented-body (%ml0-consolidation-body consolidation))
         (recomputed-body (%ml0-consolidation-body recomputed)))
    (unless (string= (digest-of presented-body) (digest-of recomputed-body))
      (ml0-refuse 'ml0-consolidation-refused "ML0-MAT-2"
                  "the presented carrier does not agree with the store: re-reading ~
its ~d input(s) from the target store and re-folding yields a different derived ~
account (presented ~a, recomputed ~a).  A stale or altered carrier is refused, ~
never corrected"
                  (length hexes)
                  (subseq (digest-of presented-body) 0 12)
                  (subseq (digest-of recomputed-body) 0 12)))
    (%ml0-append-body-and-read-back
     store recomputed-body
     :subject-attempt (ml0-consolidation-subject-attempt recomputed)
     :subject-principal (%ml0-bare-principal
                         (ml0-consolidation-subject-principal recomputed))
     :recording-process recording-process
     :derivation :consolidation)))

(defun %ml0-bare-principal (rendered)
  "⚠ INTERNAL.  A validated account renders its subject principal as the
identifier string `principal:<name>`; `ml0-account-body` wraps a BARE name in
`(idf (list \"principal\" name))`.  Feeding the rendered form back in produced
`principal:principal:<name>` on every materialization (SCRUTATOR's DEFECT 3:
a derived account could never be re-consolidated with its own input, ML0-CON-4).
This strips exactly one lane-written prefix and refuses anything else."
  (let ((prefix "principal:"))
    (unless (and (stringp rendered)
                 (> (length rendered) (length prefix))
                 (string= prefix rendered :end2 (length prefix)))
      (ml0-refuse 'ml0-consolidation-refused "ML0-MAT-4"
                  "a consolidated subject principal must read principal:<name>; got ~s"
                  rendered))
    (subseq rendered (length prefix))))

(defun %ml0-consolidation-body (consolidation)
  "⚠ INTERNAL.  The durable body a carrier WOULD produce — used both to write the
recomputed carrier and to compare a presented carrier against it by canonical-body
SHA-256 digest (`digest-of`), which is the comparison the implementation makes."
  (ml0-through
   "CD/0 derived account body construction"
   (lambda ()
     (ml0-account-body
      :act-id (ml0-consolidation-act-id consolidation)
      :act-id-hex (ml0-consolidation-act-id-hex consolidation)
      :subject-seat (ml0-consolidation-subject-seat consolidation)
      :subject-attempt (ml0-consolidation-subject-attempt consolidation)
      :occurrence-standing (ml0-consolidation-occurrence-standing consolidation)
      :occurrence-scope (ml0-consolidation-occurrence-scope consolidation)
      :issuance-standing (ml0-consolidation-issuance-standing consolidation)
      :issuance-scope (ml0-consolidation-issuance-scope consolidation)
      :record-coverage (ml0-consolidation-record-coverage consolidation)
      :record-coverage-scope (ml0-consolidation-record-coverage-scope consolidation)
      :effect-observation nil
      :sources (ml0-consolidation-sources consolidation)
      :derivation :consolidation
      :predecessors (ml0-consolidation-predecessors consolidation)
      :recorder-principal +ml0-lane-stem+
      :subject-principal (%ml0-bare-principal
                          (ml0-consolidation-subject-principal consolidation))))))

;;; ===========================================================================
;;; §15 — the public projection digest for issuance testimony.
;;;
;;; ⚠ ROUTED AROUND A GENUINE HOLE, AND THE ROUTE IS DECLARED.  Core /0 exports NO
;;; canonical-content digest for an evidence account (`%core0-issuance-content` is
;;; internal, core0.lisp:811-820), and exporting one would trip this commission's
;;; second stop condition.  So an issuance source's coordinate is a CALLER-SIDE
;;; PROJECTION built from PUBLIC readers only, and the record says so IN ITS OWN
;;; BYTES: the field `basis` reads "caller-supplied-projection".
;;;
;;; ⚑ WHAT THIS DIGEST IS NOT: it is NOT the evidence account's canonical content
;;; digest, it is NOT an evidence identity, and two evidence accounts with the
;;; same projection are NOT thereby the same account.  It is a coordinate for a
;;; TESTIMONY row, and testimony is the only thing it can ever support.
;;; ===========================================================================

(defun ml0-evidence-projection-digest (evidence)
  "A digest over a CD/0 projection of PUBLIC Core /0 readers.  Returns
(values HEX PROJECTION-RECORD)."
  (unless (lisp-plus-core0:core0-evidence-p evidence)
    (ml0-refuse 'ml0-provenance-incomplete "ML0-PRJ-1"
                "a projection digest requires a core0-evidence; got ~s" evidence))
  (let ((projection
          (ml0-through
           "Core /0 public evidence readers"
           (lambda ()
             (rec (entry '("projection" "basis")
                         (s-datum "caller-supplied-projection"))
                  (entry '("projection" "attempt-id")
                         (s-datum (lisp-plus-kernel0:durable-identity-name
                                   (lisp-plus-core0:core0-evidence-attempt-id evidence))))
                  (entry '("projection" "seat-id")
                         (s-datum (lisp-plus-kernel0:durable-identity-name
                                   (lisp-plus-core0:core0-evidence-seat-id evidence))))
                  (entry '("projection" "adapter-identity")
                         (s-datum (lisp-plus-kernel0:durable-identity-name
                                   (lisp-plus-core0:core0-evidence-adapter-identity
                                    evidence))))
                  (entry '("projection" "refusal-reason")
                         (s-datum (or (lisp-plus-core0:core0-evidence-refusal-reason
                                       evidence)
                                      "none")))
                  (entry '("projection" "ledger-token")
                         (s-datum (or (lisp-plus-core0:core0-evidence-ledger-token
                                       evidence)
                                      "none")))
                  (entry '("projection" "rendering")
                         (i-datum +ml0-rendering-version+)))))))
    (values (digest-of projection) projection)))

;;; ===========================================================================
;;; §16 — the public rendering of an account (DIAGNOSTIC ONLY, never an identity
;;; representation).
;;; ===========================================================================

(defun ml0-render-account (account &optional (stream *standard-output*))
  "It prints the two standings on SEPARATE LINES on purpose: a reader scanning
this transcript must not be able to mistake one axis for the other."
  (format stream "~&  account            : ~a~%" (ml0-account-id-hex account))
  (format stream "  act                : ~a~%" (ml0-account-act-id-hex account))
  (format stream "  seat / attempt     : ~a / ~a~%"
          (ml0-account-subject-seat account) (ml0-account-subject-attempt account))
  (format stream "  OCCURRENCE standing: ~s~%"
          (ml0-account-occurrence-standing account))
  (format stream "  ISSUANCE standing  : ~s   (a SEPARATE axis; never folded)~%"
          (ml0-account-issuance-standing account))
  (format stream "  effect (observed)  : ~a / ~s~%"
          (ml0-effect-observation-standing-as-read
           (ml0-account-effect-observation account))
          (ml0-effect-observation-determinacy
           (ml0-account-effect-observation account)))
  (format stream "  derivation         : ~s  (~d predecessor~:p)~%"
          (ml0-account-derivation account)
          (length (ml0-account-predecessors account)))
  (format stream "  retrieval origin   : ~s~%" (ml0-account-retrieval-origin account))
  (format stream "  sources            : ~{~a~^, ~}~%"
          (mapcar (lambda (s) (string-downcase (symbol-name (ml0-source-species s))))
                  (ml0-account-sources account)))
  (finish-output stream)
  account)

;;; ===========================================================================
;;; §17 — the in-process harness.
;;; ===========================================================================

(defvar *ml0-run-root* nil)
(defvar *ml0-account-store* nil)

(defun ml0-env-preflight (&key (signal t))
  "Runs BEFORE any store is created.  Prints one stable check-line per variable.
ANY ONE SET VOIDS THE RUN: the run stops, reports the variable and its value, and
CREATES NO ACCOUNT STORE.  ⚠ A VOID IS NOT A FAILURE OF THE SUITE and is never
reported as a pass."
  (let ((set-vars '()))
    (dolist (name (append +ml0-env-class-i+ +ml0-env-class-ii+))
      (let ((value (sb-ext:posix-getenv name)))
        (if value
            (progn (push (cons name value) set-vars)
                   (format t "~&  W-ENV ~a SET=~s~%" name value))
            (format t "~&  W-ENV ~a unset~%" name))))
    (format t "~&  W-ENV enumerated ~d variables (~d Class I + ~d Class II); ~d ~
Class III declared out of stack, named and NOT asserted~%"
            (+ (length +ml0-env-class-i+) (length +ml0-env-class-ii+))
            (length +ml0-env-class-i+) (length +ml0-env-class-ii+)
            (length +ml0-env-class-iii-declared-out-of-stack+))
    (when set-vars
      (format t "~&  W-ENV VOID: ~d variable(s) set; NO ACCOUNT STORE IS CREATED~%"
              (length set-vars))
      (when signal
        (ml0-refuse 'ml0-run-void "ML0-ENV-1"
                    "environment variable ~a is set to ~s; this suite declares one ~
process life and that switch can end the process"
                    (car (first set-vars)) (cdr (first set-vars)))))
    (null set-vars)))

(defun build-ml0-account-store (root)
  "THE LANE'S OWN ACCOUNT STORE — one `create-journal`, its own directory, its own
declared durability.  It is SEPARATE from any act lane's store on purpose: D7 then
damages only this lane's record, and D1's `the source journal is byte-unchanged`
compares genuinely different files.

The nonce is EXACTLY sixteen octets, asserted BY LENGTH, not by counting the
source line."
  (assert (= 16 (length +ml0-store-nonce+)) ()
          "the store nonce must be exactly sixteen octets, not ~d"
          (length +ml0-store-nonce+))
  (create-journal (merge-pathnames "account-store/" root)
                  :declared-durability "synced"
                  :nonce-octets +ml0-store-nonce+))
