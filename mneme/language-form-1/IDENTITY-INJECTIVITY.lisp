;;;; IDENTITY-INJECTIVITY.lisp — Language Form /1, Candidate /0.
;;;;
;;;; Run:  sbcl --non-interactive --load IDENTITY-INJECTIVITY.lisp
;;;; Capture: IDENTITY-INJECTIVITY-RUN.txt
;;;;
;;;; ══════════════════════════════════════════════════════════════════════════
;;;; WHAT THIS INSTRUMENT ASKS, AND WHY IT IS NOT WHAT THE SUITE ALREADY ASKED.
;;;;
;;;; The existing evidence tests SENSITIVITY: change one named declared input,
;;;; watch the identity change.  Sensitivity is a ONE-AXIS-AT-A-TIME property
;;;; and it is easy to pass.  It does not settle the load-bearing question,
;;;; which is INJECTIVITY:
;;;;
;;;;     can TWO DIFFERENT declared genealogies ever collapse into ONE identity?
;;;;
;;;; A composition can be sensitive on every axis separately and still collide
;;;; under SIMULTANEOUS variation — that is the classic delimiter-ambiguity
;;;; failure, where a boundary moved between two adjacent fields leaves the
;;;; concatenation unchanged.  Nothing in the existing suite varies two axes at
;;;; once and asks whether the pair is distinguishable.  This file does.
;;;;
;;;; ══════════════════════════════════════════════════════════════════════════
;;;; THE CLAIM, STATED NARROWLY.
;;;;
;;;;     Form /1 identity values are injective over their declared CD/0 phase
;;;;     payloads, assuming Canonical Datum /0 exact encoding.
;;;;
;;;; WHAT IS NOT CLAIMED: injectivity over unrecorded live host facts.  Two
;;;; contexts with IDENTICAL declarations and DIFFERENT live anchors produce the
;;;; SAME identity BY DESIGN.  That is the declared residual — Form /1's own
;;;; NC-31B — and it is NOT a collision.  This census generates such pairs
;;;; deliberately, counts them separately, and says why they are not collisions.
;;;;
;;;; ══════════════════════════════════════════════════════════════════════════
;;;; NO HASH IS ADDED AND NONE IS WANTED.  CD/0 supplies no digest, and a Form /1
;;;; identity is a LOSSLESS CANONICAL ENCODING that CONTAINS its payload.  That
;;;; is exactly why PART A below is the proof and PART B is the search: for a
;;;; lossless encoding, ROUND TRIP IMPLIES INJECTIVITY over the round-tripped
;;;; population —
;;;;
;;;;     if encode(p1) = encode(p2) then p1 = decode(encode(p1))
;;;;                                    = decode(encode(p2)) = p2
;;;;
;;;; — so the honest structure of this evidence is:
;;;;
;;;;   PART A  proves the identity is a LOSSLESS encoding of a SPECIFIC TAGGED
;;;;           PAYLOAD, for all 12 phase identity species.  This is what makes
;;;;           the injectivity claim MEANINGFUL rather than vacuous.
;;;;   PART B  searches for the residual risk PART A cannot settle: whether two
;;;;           DIFFERENT DECLARED CONFIGURATIONS can reach the SAME PAYLOAD —
;;;;           i.e. whether a declared axis is dropped, or two axes are run
;;;;           together without a boundary.  A finite cross-product census plus
;;;;           a hand-built adversarial arm of designed near-collisions.
;;;;
;;;; ══════════════════════════════════════════════════════════════════════════
;;;; INDEPENDENCE OF THE EXPECTED PAYLOADS.  Every expected payload in PART A is
;;;; rebuilt HERE, in this file, from PUBLIC readers and PUBLIC CD/0
;;;; constructors.  The phase-tag / field-key / absence-marker naming
;;;; conventions are RE-EXPRESSED below (X-PHASE, X-FIELD, X-ABSENT) rather than
;;;; borrowed from the package internals, so a drift between the layer's naming
;;;; and its documented naming is a FAILURE here, not a silent agreement.
;;;;
;;;; This file modifies nothing.  It reads the layer through its public surface,
;;;; with exactly ONE labelled exception: the procedure-version axis, which has
;;;; no public setter and is varied by rebinding an internal FDEFINITION.  That
;;;; axis is LABELLED as shim-varied everywhere it is reported, because an axis
;;;; varied by shim is weaker evidence than one varied by a caller.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (handler-bind ((style-warning #'muffle-warning))
    (load (merge-pathnames "form1.lisp" *load-truename*))))

(defpackage #:form1-identity-injectivity
  (:use #:cl)
  (:local-nicknames (#:f1 #:lisp-plus-form1)
                    (#:cd0 #:lisp-plus-cd0)
                    (#:s0 #:lisp-plus-slice0)
                    (#:s1 #:lisp-plus-slice1)
                    (#:s2 #:lisp-plus-slice2)))

(in-package #:form1-identity-injectivity)

;;; ══════════════════════════════════════════════════════════════════════════
;;; Reporting.

(defparameter *checks* 0)
(defparameter *failures* 0)
(defparameter *collisions* 0)

(defun rule (&optional (char #\─))
  (format t "~A~%" (make-string 78 :initial-element char)))

(defun head (text)
  (format t "~%")
  (rule #\═)
  (format t "~A~%" text)
  (rule #\═))

(defun sub (text)
  (format t "~%~A~%" text)
  (rule))

(defun check (ok label &rest args)
  (incf *checks*)
  (unless ok (incf *failures*))
  (format t "  [~A] ~A~%" (if ok "PASS" "FAIL") (apply #'format nil label args))
  ok)

;;; ══════════════════════════════════════════════════════════════════════════
;;; CD/0 helpers, and the RE-EXPRESSED Form /1 naming conventions.
;;;
;;; These four functions duplicate, in this file, what the layer's internal
;;; %PHASE-TAG / %FIELD-KEY / %ABSENT / %REFERENCE produce.  Duplicating them is
;;; the point: a second expression of the convention turns silent drift into a
;;; loud failure.

(defun idd (namespace path) (cd0:make-identifier-datum namespace path))
(defun x-text (string) (cd0:make-string-datum string))
(defun x-count (integer) (cd0:make-integer-datum integer))
(defun x-seq (data) (cd0:make-sequence-datum data))
(defun x-phase (name) (idd '("lisp-plus-form1" "phase") (list name)))
(defun x-field (name) (idd '("lisp-plus-form1") (list "field" name)))
(defun x-absent () (idd '("lisp-plus-form1") '("absent")))
(defun x-name-text (keyword-or-nil)
  (if keyword-or-nil (x-text (symbol-name keyword-or-nil)) (x-absent)))
(defun x-path-datum (path)
  (x-seq (mapcar (lambda (step) (if (integerp step) (x-count step) (x-text (string step))))
                 path)))

(defun same (a b) (cd0:equal-datum a b))
(defun octets-of (datum) (cd0:canonical-octets datum))

(defun hexkey (datum)
  "An EXACT, injective key for a datum: the hex of its canonical octets, as a
BASE-STRING (one octet per character, so a large census stays small in memory).
Hex is used HERE as a TEST-SIDE HASH KEY ONLY.  It is never embedded into an
identity, never stored as one, and never handed back to the layer."
  (coerce (cd0:octets-to-hex (octets-of datum)) 'simple-base-string))

(defun decode-identity (identity)
  "THE ROUND TRIP, in one line.

An identity is (MAKE-BYTES-DATUM (CANONICAL-OCTETS payload)).  BYTES-DATUM-VALUE
therefore yields exactly the payload's canonical octets, and DECODE-EXACT of
those octets yields the payload.  No hash is inverted here because none exists:
the identity CONTAINS what it identifies."
  (cd0:decode-exact (cd0:bytes-datum-value identity)))

(defun seq-elt (datum index) (cd0:sequence-datum-ref datum index))
(defun seq-len (datum) (cd0:sequence-datum-length datum))

;;; ══════════════════════════════════════════════════════════════════════════
;;; PART A helper: decode an identity, compare against an independently built
;;; payload, and WALK the decoded sequence element by element.

(defun round-trip (species identity expected-payload element-names)
  "Decode IDENTITY, assert it equals EXPECTED-PAYLOAD, then walk the decoded
sequence and assert every expected element is present at its expected position.
ELEMENT-NAMES names the positions for the walk report."
  (let* ((decoded (decode-identity identity))
         (expected-len (seq-len expected-payload)))
    (format t "~%  ── ~A~%" species)
    (format t "     identity value: ~D octets~%" (f1:identity-octets identity))
    (check (cd0:sequence-datum-p decoded)
           "~A: decoded payload is a SEQUENCE datum" species)
    (check (= (seq-len decoded) expected-len)
           "~A: decoded arity ~D = expected arity ~D"
           species (seq-len decoded) expected-len)
    (check (same decoded expected-payload)
           "~A: decoded payload EQUAL-DATUM the independently built payload"
           species)
    (when (= (seq-len decoded) expected-len)
      (loop for index from 0 below expected-len
            for name in element-names
            do (check (same (seq-elt decoded index) (seq-elt expected-payload index))
                      "~A: element ~D (~A) present and exact" species index name)))
    decoded))

;;; ══════════════════════════════════════════════════════════════════════════
;;; The corpus.  One Slice /1 schema, registered; one Slice /2 attachment over
;;; the registered object; one Slice /2 attachment over an UNREGISTERED base
;;; (which is how DERIVE/2 is made to take the door-refusal path).

(defun prop (form) (s1:proposition form))
(defun patt (form) (s1:proposition-pattern form))

(s1:clear-schema-registry)

(defparameter *base-schema*
  (s1:judgment-schema
   :name :volume-recorded :version 1
   :conclusion (patt '(:predicate :recorded (:volume (:var :v))))
   :premises (list (patt '(:predicate :scanned (:volume (:var :v)))))))

(s1:register-schema *base-schema*)

(defun attach (base id)
  (s2:make-slice2-schema
   :schema-id id :base-schema base
   :premise-contracts
   (list (list 0 (s2:make-support-admission-contract
                  :contract-id :scan-admission
                  :accepted-clauses
                  '((:asserted-witness :mode :direct :kind :scan
                     :truth-ceiling :asserted)))))))

(defparameter *live-schema* (attach (s1:resolve-schema :volume-recorded 1) :volume-recorded/2))

(defparameter *unregistered-base*
  (s1:judgment-schema
   :name :never-registered :version 1
   :conclusion (patt '(:predicate :recorded (:volume (:var :v))))
   :premises (list (patt '(:predicate :scanned (:volume (:var :v)))))))

(defparameter *dead-schema* (attach *unregistered-base* :never-registered/2))

(defun witness-for (volume)
  (s0:witness :for (prop `(:predicate :scanned (:volume ,volume)))
              :mode :direct :kind :scan :source :clerk))

(defparameter *right-witness* (witness-for "P7"))
(defparameter *wrong-witness* (witness-for "MS-99"))
(defparameter *conclusion* (prop '(:predicate :recorded (:volume "P7"))))

(defun desk-for (witness)
  (s0:receiver-context :context-id :front-desk
                       :accessible-supports (list (s0:witness-id witness))))

;;; ── the three LIVE-ANCHOR families ────────────────────────────────────────
;;; Their DECLARATIONS are identical; only the live anchors differ.  That is
;;; what makes them the residual arm as well as the outcome-kind axis.

(defstruct (family (:constructor make-family (key schema witness)))
  key schema witness)

(defparameter *families*
  (list (make-family :grant  *live-schema* *right-witness*)
        (make-family :refuse *live-schema* *wrong-witness*)
        (make-family :door   *dead-schema* *right-witness*)))

;;; ══════════════════════════════════════════════════════════════════════════
;;; Building one census point through the PUBLIC surface, end to end.

(defstruct (subject-spec (:constructor make-subject-spec (label schema-key conclusion-key
                                                          support-keys receiver-key)))
  label schema-key conclusion-key support-keys receiver-key)

(defun petition-for (spec occurrence-tag)
  (multiple-value-bind (petition receipt)
      (f1:materialize-petition
       (f1:validate-petition
        (f1:propose-petition
         (f1:petition-datum
          :schema (f1:schema-reference (subject-spec-schema-key spec))
          :conclusion (f1:conclusion-reference (subject-spec-conclusion-key spec))
          :supports (mapcar #'f1:support-reference (subject-spec-support-keys spec))
          :receiver (f1:receiver-reference (subject-spec-receiver-key spec)))))
       occurrence-tag)
    (values petition receipt)))

(defun context-for (spec family denotations ctx-tag &key extra-supports (receiver-live t))
  "Build and seal a context binding exactly the references SPEC names, plus any
EXTRA-SUPPORTS (a list of (KEY ANCHOR DENOTATION)) the petition does NOT name —
an unreferenced binding is a real declaration difference that reaches no live
call, which makes it a pure declaration axis.

DENOTATIONS is a function of (ROLE KEY) returning the denotation datum."
  (let ((c (f1:make-derivation-resolution-context))
        (support-keys (subject-spec-support-keys spec)))
    (setf c (f1:bind-schema-reference
             c (f1:schema-reference (subject-spec-schema-key spec))
             (family-schema family)
             (funcall denotations :schema (subject-spec-schema-key spec))))
    (setf c (f1:bind-conclusion-reference
             c (f1:conclusion-reference (subject-spec-conclusion-key spec))
             *conclusion*
             (funcall denotations :conclusion (subject-spec-conclusion-key spec))))
    (loop for key in support-keys
          for index from 0
          ;; the FIRST support carries the live witness; any further support is
          ;; an inert host value, which DERIVE/2 records as residue at the
          ;; caller's index and which therefore does not disturb the outcome.
          do (setf c (f1:bind-support-reference
                      c (f1:support-reference key)
                      (if (zerop index) (family-witness family) "inert-host-value")
                      (funcall denotations :support key))))
    (dolist (extra extra-supports)
      (destructuring-bind (key anchor denotation) extra
        (setf c (f1:bind-support-reference c (f1:support-reference key) anchor denotation))))
    (setf c (if receiver-live
                (f1:bind-receiver-reference
                 c (f1:receiver-reference (subject-spec-receiver-key spec))
                 (desk-for (family-witness family))
                 (funcall denotations :receiver (subject-spec-receiver-key spec)))
                (f1:bind-receiver-reference
                 c (f1:receiver-reference (subject-spec-receiver-key spec))
                 nil (f1:receiver-absence-declaration))))
    (f1:seal-resolution-context c ctx-tag)))

(defun declarations-payload-fragment (context)
  "The declared mapping, read through the PUBLIC declarations reader and shaped
into a canonical key.  Its only requirement is injectivity over the declared
tuple; it is a CENSUS KEY, not a model of the layer's own payload."
  (x-seq (loop for d in (f1:derivation-resolution-context-declarations context)
               collect (x-seq (list (x-text (symbol-name (f1:context-binding-declaration-role d)))
                                    (f1:context-binding-declaration-reference d)
                                    (f1:context-binding-declaration-denotation d))))))

(defstruct point
  label kind d-occ d-receipt occ-hex receipt-hex
  ;; ── each INTERMEDIATE identity gets its OWN declared-scope key ──────────
  ;; THE KEY'S SCOPE MUST EQUAL THE IDENTITY'S DECLARED SCOPE, or the census
  ;; measures the wrong thing in BOTH directions: key too WIDE and correct
  ;; scoping is reported as a collision (a context identity is not supposed to
  ;; move when the act-id moves); key too NARROW and a real dropped axis hides
  ;; inside a residual group.  So a context identity is keyed on the context's
  ;; declared scope, a petition identity on the petition's, and only the
  ;; terminal identity on the whole configuration.
  d-petition petition-occurrence-hex
  d-context-mapping context-declaration-hex
  d-context context-occurrence-hex
  receipt-datum-present)

(defun run-point (&key label spec family occurrence-tag denotations ctx-tag
                       act-id by-id (procedure-version 1)
                       extra-supports (receiver-live t))
  "One complete declared configuration, submitted.  Returns a POINT holding the
DECLARED-CONFIGURATION key and the identities that key must not share."
  (let* ((petition (petition-for spec occurrence-tag))
         (context (context-for spec family denotations ctx-tag
                               :extra-supports extra-supports
                               :receiver-live receiver-live))
         (outcome (f1:submit-petition petition context
                                      :by :clerk :by-id by-id :act-id act-id))
         (receipt (f1:petition-submission-outcome-receipt outcome))
         (kind (f1:petition-submission-receipt-outcome-kind receipt))
         (slice2-datum (f1:petition-submission-receipt-slice2-receipt-identity-datum receipt))
         (condition-class (f1:petition-submission-receipt-slice2-condition-class receipt))
         ;; THE DECLARED CONFIGURATION.  Every element here was supplied by this
         ;; caller through the public surface (except PROCEDURE-VERSION — see the
         ;; axis-provenance table).  No live anchor appears in it, and that is
         ;; the whole point: the residual is a difference in anchors with this
         ;; key held equal.
         (subject-datum (decode-identity (f1:derivation-petition-subject-identity petition)))
         (mapping (declarations-payload-fragment context))
         (d-petition (x-seq (list (x-text "form1/declared-petition")
                                  subject-datum
                                  (f1:derivation-petition-occurrence-tag petition))))
         (d-context-mapping (x-seq (list (x-text "form1/declared-context-mapping")
                                         mapping)))
         (d-context (x-seq (list (x-text "form1/declared-context")
                                 mapping
                                 (f1:derivation-resolution-context-occurrence-tag context))))
         (d-occ (x-seq (list (x-text "form1/declared-configuration")
                             subject-datum
                             (f1:derivation-petition-occurrence-tag petition)
                             mapping
                             (f1:derivation-resolution-context-occurrence-tag context)
                             act-id
                             by-id
                             (x-count procedure-version))))
         (d-receipt (x-seq (list (x-text "form1/declared-outcome-record")
                                 d-occ
                                 (x-text (symbol-name kind))
                                 (or slice2-datum (x-absent))
                                 (if condition-class (x-text condition-class) (x-absent))))))
    (make-point
     :label label
     :kind kind
     :d-occ (hexkey d-occ)
     :d-receipt (hexkey d-receipt)
     :occ-hex (hexkey (f1:petition-submission-receipt-occurrence-identity receipt))
     :receipt-hex (hexkey (f1:petition-submission-receipt-identity receipt))
     :d-petition (hexkey d-petition)
     :petition-occurrence-hex (hexkey (f1:derivation-petition-occurrence-identity petition))
     :d-context-mapping (hexkey d-context-mapping)
     :context-declaration-hex (hexkey (f1:derivation-resolution-context-declaration-identity context))
     :d-context (hexkey d-context)
     :context-occurrence-hex (hexkey (f1:derivation-resolution-context-occurrence-identity context))
     :receipt-datum-present (and slice2-datum t))))

;;; ══════════════════════════════════════════════════════════════════════════
;;; Collision analysis over a set of points.

;;; COLLISION           distinct declared keys sharing ONE identity.  A defect.
;;; DECLARED RESIDUAL   one declared key, several points, one identity — expected
;;;                     wherever the points differ only in LIVE ANCHORS.
;;; SPLIT GROUP         one declared key producing TWO identities.  Not a
;;;                     collision, but it would mean an identity commits to
;;;                     something this census did not declare, so it is counted.

(defun analyse (points declared-reader identity-reader)
  "Returns a plist: :population :distinct-declared :distinct-identity
:collisions :collision-witnesses :residual-groups :residual-pairs."
  (let ((declared->identities (make-hash-table :test #'equal))
        (identity->declareds (make-hash-table :test #'equal))
        (declared->points (make-hash-table :test #'equal))
        (collision-witnesses '())
        (collisions 0)
        (residual-groups 0)
        (residual-pairs 0)
        (split-groups 0))
    (dolist (p points)
      (let ((d (funcall declared-reader p))
            (i (funcall identity-reader p)))
        (pushnew i (gethash d declared->identities) :test #'string=)
        (pushnew d (gethash i identity->declareds) :test #'string=)
        (push p (gethash d declared->points))))
    (maphash (lambda (i declareds)
               (when (> (length declareds) 1)
                 (incf collisions)
                 (push (list i declareds) collision-witnesses)))
             identity->declareds)
    (maphash (lambda (d identities)
               (let ((n (length (gethash d declared->points))))
                 (when (> n 1)
                   (incf residual-groups)
                   (incf residual-pairs (/ (* n (1- n)) 2)))
                 (when (> (length identities) 1) (incf split-groups))))
             declared->identities)
    (list :population (length points)
          :distinct-declared (hash-table-count declared->identities)
          :distinct-identity (hash-table-count identity->declareds)
          :collisions collisions
          :collision-witnesses collision-witnesses
          :residual-groups residual-groups
          :residual-pairs residual-pairs
          :split-groups split-groups
          :declared->points declared->points)))

(defun report-arm (name result &key (residual-note nil)
                                    (group-label "declared-residual groups"))
  (let ((collisions (getf result :collisions)))
    (format t "~%  ~A~%" name)
    (format t "    population size .................. ~D~%" (getf result :population))
    (format t "    distinct declared payloads ....... ~D~%" (getf result :distinct-declared))
    (format t "    distinct identity values ......... ~D~%" (getf result :distinct-identity))
    (format t "    COLLISIONS ....................... ~D~%" collisions)
    (when (plusp (getf result :residual-groups))
      (format t "    ~A~35T ~D  (~D pair(s))~%"
              group-label (getf result :residual-groups) (getf result :residual-pairs))
      (when residual-note (format t "      ~A~%" residual-note)))
    (check (zerop collisions) "~A: zero collisions" name)
    (check (zerop (getf result :split-groups))
           "~A: no declared payload produced two different identities" name)
    (incf *collisions* collisions)
    (when (plusp collisions)
      (format t "~%")
      (rule #\!)
      (format t "COLLISION WITNESSES — ~A~%" name)
      (rule #\!)
      (dolist (w (getf result :collision-witnesses))
        (destructuring-bind (identity-hex declared-keys) w
          (format t "~%  SHARED IDENTITY (hex of canonical octets):~%    ~A~%" identity-hex)
          (format t "  DISTINCT DECLARED PAYLOADS SHARING IT: ~D~%" (length declared-keys))
          (dolist (d declared-keys)
            (let ((pt (first (gethash d (getf result :declared->points)))))
              (format t "~%    ---- declared payload ----~%")
              (format t "    point label : ~A~%" (point-label pt))
              (format t "    outcome kind: ~S~%" (point-kind pt))
              (format t "    payload hex : ~A~%" d))))))
    result))

;;; ══════════════════════════════════════════════════════════════════════════
;;; ══════════════════════════════════════════════════════════════════════════

(format t "~%")
(rule #\█)
(format t "FORM /1 IDENTITY INJECTIVITY — the census the sensitivity suite never ran~%")
(rule #\█)
(format t "~%THE CLAIM~%")
(format t "  Form /1 identity values are injective over their declared CD/0 phase~%")
(format t "  payloads, assuming Canonical Datum /0 exact encoding.~%")
(format t "~%WHAT IS NOT CLAIMED~%")
(format t "  Injectivity over unrecorded live host facts.  Two contexts with identical~%")
(format t "  declarations and different live anchors produce the SAME identity by~%")
(format t "  design; that is the declared residual (NC-31B), not a collision.  This~%")
(format t "  census generates such pairs on purpose and counts them separately.~%")
(format t "~%NO HASH IS ADDED.  CD/0 supplies no digest.  An identity here is a LOSSLESS~%")
(format t "  CANONICAL ENCODING that contains its payload, which is why the round trip~%")
(format t "  in PART A is a proof of injectivity over the population it covers, and~%")
(format t "  why PART B searches the one thing the round trip cannot settle: whether~%")
(format t "  two DIFFERENT declared configurations can reach the SAME payload.~%")

;;; ══════════════════════════════════════════════════════════════════════════
;;; PART A — STRUCTURAL ROUND TRIP, ALL 12 PHASE IDENTITY SPECIES.

(head "PART A — STRUCTURAL ROUND TRIP (12 identity species)")

(format t "~%For each species: extract the identity's byte-string value, DECODE-EXACT it,~%")
(format t "compare the result against a payload built INDEPENDENTLY in this file from~%")
(format t "public readers and public CD/0 constructors, then WALK the decoded sequence~%")
(format t "asserting every phase tag and declared field is present at its position.~%")

(defparameter *a-spec* (make-subject-spec "A" "sch" "con" (list "sup-1") "rcv"))
(defparameter *a-denotations*
  (lambda (role key) (idd '("census") (list "denotes" (string-downcase (symbol-name role)) key))))
(defparameter *a-petition-tag* (idd '("census") '("petition-occurrence" "A")))
(defparameter *a-context-tag* (idd '("census") '("context-occurrence" "A")))
(defparameter *a-act-id* (idd '("census") '("act" "A")))
(defparameter *a-by-id* (idd '("census") '("principal" "clerk")))

;;; Build the chain by hand so every intermediate object is in view.
(defparameter *a-datum*
  (f1:petition-datum :schema (f1:schema-reference "sch")
                     :conclusion (f1:conclusion-reference "con")
                     :supports (list (f1:support-reference "sup-1"))
                     :receiver (f1:receiver-reference "rcv")))
(defparameter *a-proposed* (f1:propose-petition *a-datum*))
(defparameter *a-validated* (f1:validate-petition *a-proposed*))
(defparameter *a-petition* nil)
(defparameter *a-materialization* nil)
(multiple-value-setq (*a-petition* *a-materialization*)
  (f1:materialize-petition *a-validated* *a-petition-tag*))
(defparameter *a-context*
  (context-for *a-spec* (first *families*) *a-denotations* *a-context-tag*))
(defparameter *a-outcome*
  (f1:submit-petition *a-petition* *a-context*
                      :by :clerk :by-id *a-by-id* :act-id *a-act-id*))
(defparameter *a-receipt* (f1:petition-submission-outcome-receipt *a-outcome*))

;;; A door-refusal receipt, so the ABSENT branch of the submission-receipt
;;; payload is round-tripped too, not only the present one.
(defparameter *a-door-context*
  (context-for *a-spec* (third *families*) *a-denotations*
               (idd '("census") '("context-occurrence" "A-door"))))
(defparameter *a-door-outcome*
  (f1:submit-petition *a-petition* *a-door-context*
                      :by :clerk :by-id *a-by-id*
                      :act-id (idd '("census") '("act" "A-door"))))
(defparameter *a-door-receipt* (f1:petition-submission-outcome-receipt *a-door-outcome*))

;;; Two refusals through the public surface: one with a PATH and a REFERENCE,
;;; one with a HOST-TYPE and no path.
(defparameter *a-refusal-path*
  (nth-value 1 (f1:try-propose-petition
                (f1:petition-datum :schema (f1:conclusion-reference "wrong-role")
                                   :conclusion (f1:conclusion-reference "con")
                                   :supports (list (f1:support-reference "sup-1"))
                                   :receiver (f1:receiver-reference "rcv")))))
(defparameter *a-refusal-host*
  (nth-value 1 (f1:try-propose-petition "not a datum at all")))

(sub "A.1  subject identity")
(format t "  The SUBJECT payload is the canonical petition datum ITSELF — it carries no~%")
(format t "  phase tag, by design, because it is the thing the phases are about.  The~%")
(format t "  walk therefore checks the production head and the four declared fields.~%")
(let* ((identity (f1:proposed-petition-form-subject-identity *a-proposed*))
       (decoded (decode-identity identity)))
  (format t "~%     identity value: ~D octets~%" (f1:identity-octets identity))
  (check (same decoded *a-datum*)
         "subject: decoded payload EQUAL-DATUM the petition datum built independently")
  (check (and (cd0:sequence-datum-p decoded) (= 2 (seq-len decoded)))
         "subject: decoded payload is a 2-element sequence [head, body]")
  (check (same (seq-elt decoded 0) (f1:petition-head-identifier))
         "subject: element 0 is THE production head ~A"
         (cd0:render-diagnostic (f1:petition-head-identifier)))
  (let ((body (seq-elt decoded 1)))
    (check (cd0:record-datum-p body) "subject: element 1 is a record datum")
    (check (= 4 (cd0:record-datum-size body))
           "subject: body holds exactly 4 fields (found ~D)" (cd0:record-datum-size body))
    (loop for (name expected)
            in (list (list "schema" (f1:schema-reference "sch"))
                     (list "conclusion" (f1:conclusion-reference "con"))
                     (list "supports" (x-seq (list (f1:support-reference "sup-1"))))
                     (list "receiver" (f1:receiver-reference "rcv")))
          do (let ((position nil))
               (loop for i from 0 below (cd0:record-datum-size body)
                     when (same (cd0:record-datum-key-at body i) (x-field name))
                       do (setf position i))
               (check (and position (same (cd0:record-datum-value-at body position) expected))
                      "subject: field ~A present at canonical position ~A and exact"
                      name position)))))

(sub "A.2  proposed-petition-form identity")
(round-trip "proposed"
            (f1:proposed-petition-form-identity *a-proposed*)
            (x-seq (list (x-phase "proposed")
                         (f1:petition-grammar-identity)
                         (x-count (f1:petition-grammar-version))
                         (f1:proposed-petition-form-subject-identity *a-proposed*)))
            '("phase tag" "grammar identity" "grammar version" "subject identity"))

(sub "A.3  validated-petition-form identity")
(round-trip "validated"
            (f1:validated-petition-form-identity *a-validated*)
            (x-seq (list (x-phase "validated")
                         (f1:validated-petition-form-predecessor-identity *a-validated*)
                         (f1:petition-policy-identity)
                         (x-count (f1:petition-policy-version))
                         (x-text (f1:validated-petition-form-budget-id *a-validated*))))
            '("phase tag" "proposed identity" "policy identity" "policy version" "budget id"))

(sub "A.4  petition-validation-receipt identity")
(round-trip "validation-receipt"
            (f1:petition-validation-receipt-identity (f1:validated-petition-form-receipt *a-validated*))
            (x-seq (list (x-phase "validation-receipt")
                         (f1:validated-petition-form-identity *a-validated*)))
            '("phase tag" "validated identity"))

(sub "A.5  derivation-petition CONTENT identity")
(round-trip "petition-content"
            (f1:derivation-petition-content-identity *a-petition*)
            (x-seq (list (x-phase "petition-content")
                         (f1:derivation-petition-validated-identity *a-petition*)))
            '("phase tag" "validated identity"))
(format t "~%     NOTE — the validation-receipt payload and the petition-content payload~%")
(format t "     have the SAME predecessor and differ ONLY in the phase tag.  The tag is~%")
(format t "     therefore load-bearing, not decorative: strip it and A.4 and A.5 collide.~%")
(check (not (string= (hexkey (f1:petition-validation-receipt-identity
                              (f1:validated-petition-form-receipt *a-validated*)))
                     (hexkey (f1:derivation-petition-content-identity *a-petition*))))
       "phase tag separates two identities over one identical predecessor")

(sub "A.6  derivation-petition OCCURRENCE identity")
(round-trip "petition-occurrence"
            (f1:derivation-petition-occurrence-identity *a-petition*)
            (x-seq (list (x-phase "petition-occurrence")
                         (f1:derivation-petition-content-identity *a-petition*)
                         (f1:derivation-petition-occurrence-tag *a-petition*)))
            '("phase tag" "content identity" "occurrence tag"))

(sub "A.7  petition-materialization-receipt identity")
(round-trip "materialization-receipt"
            (f1:petition-materialization-receipt-identity *a-materialization*)
            (x-seq (list (x-phase "materialization-receipt")
                         (f1:derivation-petition-occurrence-identity *a-petition*)))
            '("phase tag" "petition occurrence identity"))

(sub "A.8  context DECLARATION identity  (NEW in policy v3)")
(round-trip "context-declaration"
            (f1:derivation-resolution-context-declaration-identity *a-context*)
            (x-seq (list (x-phase "context-declaration")
                         (declarations-payload-fragment *a-context*)))
            '("phase tag" "canonical role/reference/denotation mapping"))
(let ((decoded (decode-identity (f1:derivation-resolution-context-declaration-identity *a-context*))))
  (let ((mapping (seq-elt decoded 1))
        (declarations (f1:derivation-resolution-context-declarations *a-context*)))
    (check (= (seq-len mapping) (length declarations))
           "context-declaration: mapping holds ~D triples, one per public declaration"
           (seq-len mapping))
    (loop for d in declarations
          for index from 0
          do (let ((triple (seq-elt mapping index)))
               (check (and (= 3 (seq-len triple))
                           (same (seq-elt triple 0) (x-text (symbol-name (f1:context-binding-declaration-role d))))
                           (same (seq-elt triple 1) (f1:context-binding-declaration-reference d))
                           (same (seq-elt triple 2) (f1:context-binding-declaration-denotation d)))
                      "context-declaration: triple ~D = (~A, ~A, ~A) exact"
                      index (f1:context-binding-declaration-role d)
                      (cd0:render-diagnostic (f1:context-binding-declaration-reference d))
                      (cd0:render-diagnostic (f1:context-binding-declaration-denotation d)))))))

(sub "A.9  context OCCURRENCE identity  (NEW in policy v3)")
(round-trip "context-occurrence"
            (f1:derivation-resolution-context-occurrence-identity *a-context*)
            (x-seq (list (x-phase "context-occurrence")
                         (f1:derivation-resolution-context-occurrence-tag *a-context*)
                         (f1:derivation-resolution-context-declaration-identity *a-context*)
                         (f1:petition-policy-identity)
                         (x-count (f1:petition-policy-version))))
            '("phase tag" "context occurrence tag" "context declaration identity"
              "policy identity" "policy version"))

(sub "A.10  submission OCCURRENCE identity")
(round-trip "submission-occurrence"
            (f1:petition-submission-receipt-occurrence-identity *a-receipt*)
            (x-seq (list (x-phase "submission-occurrence")
                         (f1:petition-submission-receipt-petition-occurrence-identity *a-receipt*)
                         (f1:petition-submission-receipt-context-occurrence-identity *a-receipt*)
                         (f1:petition-submission-receipt-act-id *a-receipt*)
                         (f1:petition-submission-receipt-by-id *a-receipt*)
                         (f1:petition-submission-procedure-identity)
                         (x-count (f1:petition-submission-procedure-version))))
            '("phase tag" "petition occurrence identity" "context occurrence identity"
              "act id" "by id" "procedure identity" "procedure version"))

(sub "A.11  submission RECEIPT identity  (both branches)")
(round-trip "submission-receipt (slice2 receipt PRESENT)"
            (f1:petition-submission-receipt-identity *a-receipt*)
            (x-seq (list (x-phase "submission-receipt")
                         (f1:petition-submission-receipt-occurrence-identity *a-receipt*)
                         (x-text (symbol-name (f1:petition-submission-receipt-outcome-kind *a-receipt*)))
                         (or (f1:petition-submission-receipt-slice2-receipt-identity-datum *a-receipt*)
                             (x-absent))
                         (let ((cc (f1:petition-submission-receipt-slice2-condition-class *a-receipt*)))
                           (if cc (x-text cc) (x-absent)))))
            '("phase tag" "submission occurrence identity" "outcome kind"
              "slice2 receipt identity datum" "slice2 condition class"))
(check (f1:petition-submission-receipt-slice2-receipt-identity-datum *a-receipt*)
       "submission-receipt: the PRESENT branch really carried a Slice /2 receipt datum")

(round-trip "submission-receipt (slice2 receipt ABSENT — door refusal)"
            (f1:petition-submission-receipt-identity *a-door-receipt*)
            (x-seq (list (x-phase "submission-receipt")
                         (f1:petition-submission-receipt-occurrence-identity *a-door-receipt*)
                         (x-text (symbol-name (f1:petition-submission-receipt-outcome-kind *a-door-receipt*)))
                         (or (f1:petition-submission-receipt-slice2-receipt-identity-datum *a-door-receipt*)
                             (x-absent))
                         (let ((cc (f1:petition-submission-receipt-slice2-condition-class *a-door-receipt*)))
                           (if cc (x-text cc) (x-absent)))))
            '("phase tag" "submission occurrence identity" "outcome kind"
              "slice2 receipt identity datum (ABSENT marker)" "slice2 condition class"))
(check (null (f1:petition-submission-receipt-slice2-receipt-identity-datum *a-door-receipt*))
       "submission-receipt: the ABSENT branch really had no Slice /2 receipt (~S)"
       (f1:petition-submission-receipt-outcome-kind *a-door-receipt*))

(sub "A.12  petition-refusal identity  (both shapes)")
(round-trip "refusal (with path + reference)"
            (f1:petition-refusal-identity *a-refusal-path*)
            (x-seq (list (x-phase "refusal")
                         (x-name-text (f1:petition-refusal-phase *a-refusal-path*))
                         (x-name-text (f1:petition-refusal-category *a-refusal-path*))
                         (x-name-text (f1:petition-refusal-code *a-refusal-path*))
                         (x-path-datum (f1:petition-refusal-path *a-refusal-path*))
                         (or (f1:petition-refusal-offending *a-refusal-path*) (x-absent))
                         (or (f1:petition-refusal-reference *a-refusal-path*) (x-absent))
                         (x-name-text (f1:petition-refusal-expected-role *a-refusal-path*))
                         (let ((h (f1:petition-refusal-host-type *a-refusal-path*)))
                           (if h (x-text h) (x-absent)))))
            '("phase tag" "phase" "category" "code" "path" "offending"
              "reference" "expected role" "host type"))
(format t "     code=~S path=~S expected-role=~S~%"
        (f1:petition-refusal-code *a-refusal-path*)
        (f1:petition-refusal-path *a-refusal-path*)
        (f1:petition-refusal-expected-role *a-refusal-path*))

(round-trip "refusal (with host-type, no path)"
            (f1:petition-refusal-identity *a-refusal-host*)
            (x-seq (list (x-phase "refusal")
                         (x-name-text (f1:petition-refusal-phase *a-refusal-host*))
                         (x-name-text (f1:petition-refusal-category *a-refusal-host*))
                         (x-name-text (f1:petition-refusal-code *a-refusal-host*))
                         (x-path-datum (f1:petition-refusal-path *a-refusal-host*))
                         (or (f1:petition-refusal-offending *a-refusal-host*) (x-absent))
                         (or (f1:petition-refusal-reference *a-refusal-host*) (x-absent))
                         (x-name-text (f1:petition-refusal-expected-role *a-refusal-host*))
                         (let ((h (f1:petition-refusal-host-type *a-refusal-host*)))
                           (if h (x-text h) (x-absent)))))
            '("phase tag" "phase" "category" "code" "path" "offending"
              "reference" "expected role" "host type"))
(format t "     code=~S host-type=~S~%"
        (f1:petition-refusal-code *a-refusal-host*)
        (f1:petition-refusal-host-type *a-refusal-host*))

(format t "~%  SPECIES COVERAGE — 12 of 12 phase identity species round-tripped:~%")
(dolist (s '("subject" "proposed" "validated" "validation receipt"
             "petition content" "petition occurrence" "materialization receipt"
             "context declaration (v3)" "context occurrence (v3)"
             "submission occurrence" "submission receipt" "refusal"))
  (format t "    · ~A~%" s))

;;; ══════════════════════════════════════════════════════════════════════════
;;; PART B — FINITE COLLISION CENSUS.

(head "PART B — FINITE COLLISION CENSUS")

(format t "~%A finite cross-product over the declared axes, submitted end to end through~%")
(format t "the public surface.  For every pair of DISTINCT declared payloads the~%")
(format t "identity values MUST differ.~%")

(sub "B.0  AXIS PROVENANCE — how each axis was varied, and how strong that is")
(format t "  Axis                          varied by             strength~%")
(rule)
(format t "  petition subject (ref keys)   PUBLIC CALL           caller-varied~%")
(format t "  petition subject (supports)   PUBLIC CALL           caller-varied~%")
(format t "  petition occurrence tag       PUBLIC CALL           caller-varied~%")
(format t "  context DECLARATION           PUBLIC CALL           caller-varied~%")
(format t "  context occurrence tag        PUBLIC CALL           caller-varied~%")
(format t "  submission act id             PUBLIC CALL           caller-varied~%")
(format t "  by-id                         PUBLIC CALL           caller-varied~%")
(format t "  outcome kind                  PUBLIC CALL (anchors) caller-varied~%")
(format t "  Slice /2 receipt presence     PUBLIC CALL (anchors) caller-varied~%")
(format t "  PROCEDURE VERSION             INTERNAL SHIM         *** WEAKER ***~%")
(rule)
(format t "  *** PROCEDURE VERSION HAS NO PUBLIC SETTER.  It is a constant function.~%")
(format t "      It is varied here by rebinding (FDEFINITION~%")
(format t "      'LISP-PLUS-FORM1::PETITION-SUBMISSION-PROCEDURE-VERSION), which is a~%")
(format t "      legitimate way to reach the axis and a WEAKER form of evidence than a~%")
(format t "      caller-varied axis: it demonstrates the identity composition responds~%")
(format t "      to the field, not that any caller can move it.  The shim is installed~%")
(format t "      for one arm and restored immediately after, and the restoration is~%")
(format t "      asserted.~%")
(format t "~%  Every other axis above was moved by an ordinary public call with no shim,~%")
(format t "  no internal symbol and no rebinding of any kind.~%")

;;; ── the axis levels ───────────────────────────────────────────────────────

(defparameter *subject-levels*
  (list (make-subject-spec "S0/one-support"   "sch" "con" (list "sup-1") "rcv")
        (make-subject-spec "S1/two-supports"  "sch" "con" (list "sup-1" "sup-2") "rcv")
        (make-subject-spec "S2/other-key"     "sch" "con" (list "sup-Z") "rcv")
        (make-subject-spec "S3/other-refkeys" "sch2" "con2" (list "sup-1") "rcv2")))

(defparameter *petition-tag-levels*
  (list (cons "P0" (idd '("census") '("petition-occurrence" "1")))
        (cons "P1" (idd '("census") '("petition-occurrence" "2")))
        ;; a segment-boundary probe woven into the main cross-product
        (cons "P2" (idd '("census") '("petition-occurrence" "1" "1")))))

(defparameter *ctx-tag-levels*
  (list (cons "X0" (idd '("census") '("context-occurrence" "1")))
        (cons "X1" (idd '("census") '("context-occurrence" "2")))
        (cons "X2" (idd '("census") '("context-occurrence" "1" "1")))))

(defparameter *act-levels*
  (list (cons "A0" (idd '("census") '("act" "1")))
        (cons "A1" (idd '("census") '("act" "2")))
        (cons "A2" (idd '("census") '("act" "1" "1")))))

(defparameter *by-levels*
  (list (cons "B0" (idd '("census") '("principal" "1")))
        (cons "B1" (idd '("census") '("principal" "2")))
        (cons "B2" (idd '("census") '("principal" "1" "1")))))

(defun denotations-base (role key)
  (idd '("census") (list "denotes" (string-downcase (symbol-name role)) key)))
(defun denotations-support-changed (role key)
  (if (eq role :support)
      (idd '("census") (list "denotes-OTHER" "support" key))
      (denotations-base role key)))
(defun denotations-schema-changed (role key)
  (if (eq role :schema)
      (idd '("census") (list "denotes-OTHER" "schema" key))
      (denotations-base role key)))

(defparameter *declaration-levels*
  ;; (label denotation-fn extra-support-bindings)
  (list (list "D0/baseline"        #'denotations-base            '())
        (list "D1/support-denot"   #'denotations-support-changed '())
        (list "D2/schema-denot"    #'denotations-schema-changed  '())
        (list "D3/extra-binding"   #'denotations-base
              ;; an EXTRA support binding the petition does NOT name.  It never
              ;; reaches DERIVE/2, so the governed outcome is untouched, yet it
              ;; is a real difference in what the context DECLARES.
              (list (list "unreferenced-extra" "inert-host-value"
                          (idd '("census") '("denotes" "support" "unreferenced-extra")))))))

(defun census-arm (procedure-version)
  (let ((points '()))
    (dolist (spec *subject-levels*)
      (dolist (ptag *petition-tag-levels*)
        (dolist (decl *declaration-levels*)
          (dolist (xtag *ctx-tag-levels*)
            (dolist (act *act-levels*)
              (dolist (by *by-levels*)
                (dolist (family *families*)
                  (push (run-point
                         :label (format nil "~A|~A|~A|~A|~A|~A|~A|pv~D"
                                        (subject-spec-label spec) (car ptag)
                                        (first decl) (car xtag) (car act) (car by)
                                        (family-key family) procedure-version)
                         :spec spec :family family
                         :occurrence-tag (cdr ptag)
                         :denotations (second decl)
                         :extra-supports (third decl)
                         :ctx-tag (cdr xtag)
                         :act-id (cdr act) :by-id (cdr by)
                         :procedure-version procedure-version)
                        points))))))))
    (nreverse points)))

(sub "B.1  the cross-product, procedure version 1 (no shim anywhere)")
(format t "  axes: subject(~D) x petition-tag(~D) x declaration(~D) x context-tag(~D)~%"
        (length *subject-levels*) (length *petition-tag-levels*)
        (length *declaration-levels*) (length *ctx-tag-levels*))
(format t "        x act-id(~D) x by-id(~D) x live-anchor-family(~D)~%"
        (length *act-levels*) (length *by-levels*) (length *families*))

(defparameter *arm-1* (census-arm 1))
(format t "  submissions executed: ~D~%" (length *arm-1*))
(let ((kinds (make-hash-table)))
  (dolist (p *arm-1*) (incf (gethash (point-kind p) kinds 0)))
  (format t "  outcome kinds observed:")
  (maphash (lambda (k v) (format t "  ~S=~D" k v)) kinds)
  (format t "~%")
  (check (= 3 (hash-table-count kinds))
         "all three outcome kinds are present in the population"))

(sub "B.2  the shim arm — procedure version 2 (INTERNAL SHIM, labelled)")
(defparameter *saved-procedure-version*
  (fdefinition 'lisp-plus-form1::petition-submission-procedure-version))
(setf (fdefinition 'lisp-plus-form1::petition-submission-procedure-version) (lambda () 2))
(check (= 2 (f1:petition-submission-procedure-version))
       "SHIM INSTALLED: procedure version now reads ~D (varied by internal shim, NOT by a public call)"
       (f1:petition-submission-procedure-version))
(defparameter *arm-2* (census-arm 2))
(setf (fdefinition 'lisp-plus-form1::petition-submission-procedure-version)
      *saved-procedure-version*)
(check (= 1 (f1:petition-submission-procedure-version))
       "SHIM REMOVED: procedure version reads ~D again"
       (f1:petition-submission-procedure-version))
(format t "  submissions executed under shim: ~D~%" (length *arm-2*))

(defparameter *census* (append *arm-1* *arm-2*))

(sub "B.3  SUBMISSION OCCURRENCE IDENTITY — the load-bearing arm")
(format t "  The submission occurrence identity is fixed BEFORE DERIVE/2 is invoked and~%")
(format t "  contains NO image-local ordinal.  It is therefore the arm where a collision~%")
(format t "  would be a real defect rather than an artefact of Slice /2's counter.~%")
(format t "  It commits to: petition occurrence identity, context OCCURRENCE identity,~%")
(format t "  act id, by id, procedure identity and procedure version.  It does NOT~%")
(format t "  commit to the outcome, and MUST NOT: the act and its later account are~%")
(format t "  different facts.~%")
(defparameter *occ-result*
  (report-arm "submission occurrence identity — full census"
              (analyse *census* #'point-d-occ #'point-occ-hex)
              :residual-note
              "each group is one declared configuration submitted against 3 DIFFERENT
      LIVE-ANCHOR families.  Same declaration, different anchor, same identity —
      NOT a collision.  This is Form /1's own declared residual (NC-31B), and it
      is exhibited here rather than hidden."))

(let* ((expected-configs (* (length *subject-levels*) (length *petition-tag-levels*)
                            (length *declaration-levels*) (length *ctx-tag-levels*)
                            (length *act-levels*) (length *by-levels*) 2)))
  (check (= (getf *occ-result* :distinct-declared) expected-configs)
         "declared configuration count matches the cross-product arithmetic (~D)"
         expected-configs)
  (check (= (getf *occ-result* :distinct-identity) expected-configs)
         "distinct submission occurrence identities equals distinct declared configurations (~D)"
         expected-configs))

(sub "B.4  the DECLARED RESIDUAL, stated as a positive finding")
(format t "  ~D group(s) of points share ONE declared configuration and produce ONE~%"
        (getf *occ-result* :residual-groups))
(format t "  submission occurrence identity while producing DIFFERENT governed outcomes.~%")
(let ((exhibit nil))
  (maphash (lambda (declared points)
             (declare (ignore declared))
             (when (and (null exhibit)
                        (> (length points) 1)
                        (> (length (remove-duplicates (mapcar #'point-kind points))) 1))
               (setf exhibit (reverse points))))
           (getf *occ-result* :declared->points))
  (when exhibit
    (format t "~%  EXHIBIT — one declared configuration, ~D live-anchor variants:~%"
            (length exhibit))
    (dolist (p exhibit)
      (format t "    ~48A outcome=~18S occurrence-identity=~A...~%"
              (point-label p) (point-kind p) (subseq (point-occ-hex p) 0 24)))
    (format t "~%    All ~D share ONE submission occurrence identity.  THIS IS NOT A~%"
            (length exhibit))
    (format t "    COLLISION.  Their DECLARATIONS are identical — only the live anchors~%")
    (format t "    differ, and no live anchor enters any identity, by design and by the~%")
    (format t "    layer's own statement.  A census that counted this as a collision~%")
    (format t "    would be reporting the design as a defect.~%")
    (format t "~%    Note what DOES separate them: their submission RECEIPT identities,~%")
    (format t "    which commit to the outcome kind.  The act and its later account are~%")
    (format t "    different facts, and only the second one knows what happened:~%")
    (dolist (p exhibit)
      (format t "      ~18S receipt-identity=~A...~%"
              (point-kind p) (subseq (point-receipt-hex p) 0 24)))))
(check (plusp (getf *occ-result* :residual-groups))
       "the census DID generate declared-residual pairs (they are reported, not hidden)")

(sub "B.5  SUBMISSION RECEIPT IDENTITY — full census")
(format t "  CAVEAT, stated before the numbers: on the granted and governed-refusal~%")
(format t "  paths the receipt payload embeds the Slice /2 receipt identity, which is~%")
(format t "  an IMAGE-LOCAL ORDINAL and is therefore fresh at every act.  Distinctness~%")
(format t "  on those paths is partly carried by that counter and is WEAK evidence.~%")
(format t "  The door-refusal sub-census below has NO ordinal and is the honest arm.~%")
(report-arm "submission receipt identity — full census"
            (analyse *census* #'point-d-receipt #'point-receipt-hex))

(sub "B.6  SUBMISSION RECEIPT IDENTITY — door-refusal only (ORDINAL-FREE)")
(format t "  Every point here carries NO Slice /2 receipt: the payload's receipt slot~%")
(format t "  holds the sanctioned ABSENCE marker.  Any distinctness in this arm comes~%")
(format t "  from the declared configuration alone.~%")
(defparameter *door-points*
  (remove-if-not (lambda (p) (and (eq :door-refusal (point-kind p))
                                  (not (point-receipt-datum-present p))))
                 *census*))
(check (plusp (length *door-points*)) "door-refusal sub-census is non-empty (~D points)"
       (length *door-points*))
(report-arm "submission receipt identity — door-refusal only"
            (analyse *door-points* #'point-d-receipt #'point-receipt-hex))

(sub "B.7  INTERMEDIATE IDENTITIES, each keyed on ITS OWN declared scope")
(format t "  METHOD NOTE, and it is load-bearing: an intermediate identity must be~%")
(format t "  keyed on the scope it DECLARES it commits to, never on the whole~%")
(format t "  configuration.  Key too WIDE and correct scoping reads as a collision — a~%")
(format t "  context identity is not supposed to move when the act-id moves, and a~%")
(format t "  census that demanded it would be reporting the design as a defect.  Key~%")
(format t "  too NARROW and a genuinely dropped axis hides inside a residual group.~%")
(format t "  Each arm below therefore carries its own key.~%")

(format t "~%  B.7a  petition occurrence identity — declared scope: (subject datum,~%")
(format t "        petition occurrence tag).  Not the context, not the act.~%")
(report-arm "petition occurrence identity"
            (analyse *census* #'point-d-petition #'point-petition-occurrence-hex)
            :residual-note
            "groups are configurations sharing one petition and differing only in
      context, act or principal — the petition identity correctly does not move."
            :group-label "out-of-scope grouping")

(format t "~%  B.7b  context DECLARATION identity — declared scope: the role /~%")
(format t "        reference / denotation mapping alone.  Not the context tag.~%")
(format t "        This is the v3 repair's own question: can two DIFFERENT declared~%")
(format t "        mappings reach ONE declaration identity?~%")
(report-arm "context declaration identity"
            (analyse *census* #'point-d-context-mapping #'point-context-declaration-hex)
            :residual-note
            "groups are configurations sharing one declared mapping and differing
      elsewhere — including under a DIFFERENT context occurrence tag, which the
      declaration identity correctly ignores."
            :group-label "out-of-scope grouping")

(format t "~%  B.7c  context OCCURRENCE identity — declared scope: (mapping, context~%")
(format t "        occurrence tag).  Under policy v2 this position held the bare tag~%")
(format t "        alone, and NC-31 exhibited two submissions with identical~%")
(format t "        submission occurrence identities and OPPOSITE governed outcomes.~%")
(report-arm "context occurrence identity"
            (analyse *census* #'point-d-context #'point-context-occurrence-hex)
            :residual-note
            "groups are configurations sharing one declared context and differing in
      petition, act or principal — the context identity correctly does not move."
            :group-label "out-of-scope grouping")

(format t "~%  B.7d  the v2 defect, checked directly: does a shared context TAG still~%")
(format t "        collapse two different declared mappings?~%")
(let* ((tag (idd '("adv") '("shared-context-tag")))
       (spec (make-subject-spec "v2check" "sch" "con" (list "sup-1") "rcv"))
       (left (context-for spec (first *families*) #'denotations-base tag))
       (right (context-for spec (first *families*) #'denotations-support-changed tag)))
  (check (same (f1:derivation-resolution-context-occurrence-tag left)
               (f1:derivation-resolution-context-occurrence-tag right))
         "B.7d both contexts carry the IDENTICAL host-supplied occurrence tag")
  (check (not (same (f1:derivation-resolution-context-declaration-identity left)
                    (f1:derivation-resolution-context-declaration-identity right)))
         "B.7d their DECLARATION identities differ (the mappings differ)")
  (check (not (same (f1:derivation-resolution-context-occurrence-identity left)
                    (f1:derivation-resolution-context-occurrence-identity right)))
         "B.7d their OCCURRENCE identities differ despite the shared tag — the v2 collapse is gone"))

;;; ══════════════════════════════════════════════════════════════════════════
;;; B.8 — the adversarial arm.

(sub "B.8  ADVERSARIAL ARM — designed near-collisions")
(format t "  A cross-product varies axes independently and can miss the one failure mode~%")
(format t "  that actually threatens a concatenation-built identity: a BOUNDARY MOVED~%")
(format t "  BETWEEN TWO ADJACENT FIELDS, leaving the composition unchanged.  These~%")
(format t "  pairs are built by hand to collide IF such an ambiguity exists.  Each pair~%")
(format t "  is two DISTINCT declared configurations that a naive delimiter-free~%")
(format t "  encoding would run together.~%")

(defparameter *adversarial-failures* 0)

(defun adversarial-pair (name description point-a point-b &key (expect :differ))
  "EXPECT :DIFFER  — distinct declared configurations; identities MUST differ.
   EXPECT :EQUAL   — the SAME declaration expressed differently; identities MUST
                     be equal (a canonicalization claim, not an injectivity one)."
  (let* ((same-declared (string= (point-d-occ point-a) (point-d-occ point-b)))
         (same-identity (string= (point-occ-hex point-a) (point-occ-hex point-b)))
         (ok (ecase expect
               (:differ (and (not same-declared) (not same-identity)))
               (:equal (and same-declared same-identity)))))
    (format t "~%  ~A~%    ~A~%" name description)
    (format t "    declared payloads ~A ; identity values ~A ; expected ~A~%"
            (if same-declared "EQUAL  " "DIFFER ")
            (if same-identity "EQUAL  " "DIFFER ")
            (if (eq expect :differ) "DIFFER" "EQUAL"))
    (unless ok
      (incf *adversarial-failures*)
      (when (and (not same-declared) same-identity)
        (incf *collisions*)
        (format t "~%")
        (rule #\!)
        (format t "COLLISION WITNESS — adversarial pair ~A~%" name)
        (rule #\!)
        (format t "  point A label : ~A~%" (point-label point-a))
        (format t "  point A payload hex:~%    ~A~%" (point-d-occ point-a))
        (format t "  point B label : ~A~%" (point-label point-b))
        (format t "  point B payload hex:~%    ~A~%" (point-d-occ point-b))
        (format t "  SHARED IDENTITY hex:~%    ~A~%" (point-occ-hex point-a))))
    (check ok "adversarial ~A" name)
    ok))

(defparameter *adv-base-spec* (make-subject-spec "adv" "sch" "con" (list "sup-1") "rcv"))
(defparameter *adv-family* (first *families*))

(defun adv (&key (label "adv") (spec *adv-base-spec*) (ptag (idd '("adv") '("p")))
                 (denotations #'denotations-base) (xtag (idd '("adv") '("x")))
                 (act (idd '("adv") '("a"))) (by (idd '("adv") '("b")))
                 (extra '()) (receiver-live t))
  (run-point :label label :spec spec :family *adv-family*
             :occurrence-tag ptag :denotations denotations :ctx-tag xtag
             :act-id act :by-id by :extra-supports extra :receiver-live receiver-live))

;; 1 — petition occurrence tag: segment boundary inside the path
(adversarial-pair
 "ADV-1 petition tag segment boundary"
 "path (\"occ\" \"a\" \"b\") vs (\"occ\" \"ab\") — one path segment split in two"
 (adv :label "ADV-1a" :ptag (idd '("adv") '("occ" "a" "b")))
 (adv :label "ADV-1b" :ptag (idd '("adv") '("occ" "ab"))))

;; 2 — petition occurrence tag: namespace/path boundary
(adversarial-pair
 "ADV-2 tag namespace/path boundary"
 "ns (\"adv\" \"x\") path (\"occ\") vs ns (\"adv\") path (\"x\" \"occ\")"
 (adv :label "ADV-2a" :ptag (idd '("adv" "x") '("occ")))
 (adv :label "ADV-2b" :ptag (idd '("adv") '("x" "occ"))))

;; 3 — context occurrence tag: segment boundary
(adversarial-pair
 "ADV-3 context tag segment boundary"
 "ctx path (\"c\" \"a\" \"b\") vs (\"c\" \"ab\")"
 (adv :label "ADV-3a" :xtag (idd '("adv") '("c" "a" "b")))
 (adv :label "ADV-3b" :xtag (idd '("adv") '("c" "ab"))))

;; 4 — act-id / by-id: boundary moved ACROSS two adjacent identity fields
(adversarial-pair
 "ADV-4 act-id/by-id cross-field boundary"
 "act (\"x\") + by (\"y\" \"z\") vs act (\"x\" \"y\") + by (\"z\") — adjacent fields"
 (adv :label "ADV-4a" :act (idd '("adv") '("x")) :by (idd '("adv") '("y" "z")))
 (adv :label "ADV-4b" :act (idd '("adv") '("x" "y")) :by (idd '("adv") '("z"))))

;; 5 — act-id / by-id: exact content swap between two adjacent fields
(adversarial-pair
 "ADV-5 act-id/by-id content swap"
 "act (\"p\") + by (\"q\") vs act (\"q\") + by (\"p\") — same multiset, swapped positions"
 (adv :label "ADV-5a" :act (idd '("adv") '("p")) :by (idd '("adv") '("q")))
 (adv :label "ADV-5b" :act (idd '("adv") '("q")) :by (idd '("adv") '("p"))))

;; 6 — petition tag / context tag: content swap across two DIFFERENT identities
(adversarial-pair
 "ADV-6 petition-tag/context-tag content swap"
 "pet (\"m\") + ctx (\"n\") vs pet (\"n\") + ctx (\"m\")"
 (adv :label "ADV-6a" :ptag (idd '("adv") '("m")) :xtag (idd '("adv") '("n")))
 (adv :label "ADV-6b" :ptag (idd '("adv") '("n")) :xtag (idd '("adv") '("m"))))

;; 7 — reference key / denotation boundary inside ONE declaration triple.
;;     THE KEYS ARE CHOSEN SO A FLAT CONCATENATION COLLIDES:
;;         "a" || "bc"  =  "abc"  =  "ab" || "c"
;;     so this pair is a real trap and not decoration — and B.9 proves it is by
;;     PLANTING exactly that flattening and watching this pair collapse.
(defun adv-7-denotation (segment)
  (lambda (role key)
    (if (eq role :support) (idd '("adv7") (list segment)) (denotations-base role key))))
(defparameter *adv-7-spec-a* (make-subject-spec "adv7a" "sch" "con" (list "a") "rcv"))
(defparameter *adv-7-spec-b* (make-subject-spec "adv7b" "sch" "con" (list "ab") "rcv"))
(adversarial-pair
 "ADV-7 reference-key/denotation boundary"
 "support ref \"a\" declared (\"bc\") vs support ref \"ab\" declared (\"c\") — chosen so
    that key||denotation is \"abc\" on BOTH sides, i.e. a flat concatenation of the
    two adjacent fields could not tell them apart"
 (adv :label "ADV-7a" :spec *adv-7-spec-a* :denotations (adv-7-denotation "bc"))
 (adv :label "ADV-7b" :spec *adv-7-spec-b* :denotations (adv-7-denotation "c")))

;; 8 — support reference keys: one key split into two
(adversarial-pair
 "ADV-8 support key split"
 "supports (\"w\" \"1\") vs supports (\"w1\") — one key vs two adjacent keys"
 (adv :label "ADV-8a" :spec (make-subject-spec "adv8a" "sch" "con" (list "w" "1") "rcv"))
 (adv :label "ADV-8b" :spec (make-subject-spec "adv8b" "sch" "con" (list "w1") "rcv")))

;; 9 — support reference order in the PETITION (the context is canonically sorted)
(adversarial-pair
 "ADV-9 support order in the petition"
 "supports (\"s-1\" \"s-2\") vs (\"s-2\" \"s-1\") — the context declaration is
    canonically sorted and is EQUAL for both, so only the petition distinguishes them"
 (adv :label "ADV-9a" :spec (make-subject-spec "adv9a" "sch" "con" (list "s-1" "s-2") "rcv"))
 (adv :label "ADV-9b" :spec (make-subject-spec "adv9b" "sch" "con" (list "s-2" "s-1") "rcv")))

;; 10 — denotation content swapped between two roles
(adversarial-pair
 "ADV-10 denotation swap across roles"
 "conclusion declared D1 / support declared D2 vs conclusion D2 / support D1"
 (adv :label "ADV-10a"
      :denotations (lambda (role key)
                     (case role (:conclusion (idd '("adv") '("D1")))
                                (:support (idd '("adv") '("D2")))
                                (t (denotations-base role key)))))
 (adv :label "ADV-10b"
      :denotations (lambda (role key)
                     (case role (:conclusion (idd '("adv") '("D2")))
                                (:support (idd '("adv") '("D1")))
                                (t (denotations-base role key))))))

;; 11 — an extra UNREFERENCED binding: reaches no live call, changes the declaration
(adversarial-pair
 "ADV-11 unreferenced extra binding"
 "identical petition, identical outcome, one extra support binding the petition
    never names — a pure declaration difference with no governed consequence"
 (adv :label "ADV-11a")
 (adv :label "ADV-11b"
      :extra (list (list "ghost" "inert-host-value" (idd '("adv") '("ghost-denotation"))))))

;; 12 — live receiver vs the sanctioned absence declaration
(adversarial-pair
 "ADV-12 live receiver vs sanctioned absence"
 "receiver bound to a live receiver-context vs bound to NIL with the package-owned
    RECEIVER-ABSENCE-DECLARATION"
 (adv :label "ADV-12a")
 (adv :label "ADV-12b" :receiver-live nil))

;; 13 — CANONICALIZATION: same declaration, different insertion order.
;;      This one MUST be EQUAL.  It is not an injectivity claim; it is the
;;      canonical-order claim, and it belongs here because a census that only
;;      hunted for equality would call a correct canonicalization a collision.
(defun ctx-inserted-forward (spec family denotations ctx-tag)
  (context-for spec family denotations ctx-tag))
(defun ctx-inserted-backward (spec family denotations ctx-tag)
  "Bind the two supports in the OPPOSITE order.  Same declared mapping."
  (let ((c (f1:make-derivation-resolution-context)))
    (setf c (f1:bind-receiver-reference
             c (f1:receiver-reference (subject-spec-receiver-key spec))
             (desk-for (family-witness family))
             (funcall denotations :receiver (subject-spec-receiver-key spec))))
    (loop for key in (reverse (subject-spec-support-keys spec))
          do (setf c (f1:bind-support-reference
                      c (f1:support-reference key)
                      (if (string= key (first (subject-spec-support-keys spec)))
                          (family-witness family) "inert-host-value")
                      (funcall denotations :support key))))
    (setf c (f1:bind-conclusion-reference
             c (f1:conclusion-reference (subject-spec-conclusion-key spec))
             *conclusion* (funcall denotations :conclusion (subject-spec-conclusion-key spec))))
    (setf c (f1:bind-schema-reference
             c (f1:schema-reference (subject-spec-schema-key spec))
             (family-schema family)
             (funcall denotations :schema (subject-spec-schema-key spec))))
    (f1:seal-resolution-context c ctx-tag)))

(let* ((spec (make-subject-spec "adv13" "sch" "con" (list "s-1" "s-2") "rcv"))
       (tag (idd '("adv") '("canon")))
       (forward (ctx-inserted-forward spec *adv-family* #'denotations-base tag))
       (backward (ctx-inserted-backward spec *adv-family* #'denotations-base tag)))
  (format t "~%  ADV-13 canonical declaration order~%")
  (format t "    the SAME mapping, bindings inserted in OPPOSITE order.  This pair MUST~%")
  (format t "    be EQUAL: insertion order is not semantically consequential and the~%")
  (format t "    layer canonicalizes it away before minting.  A census that hunted only~%")
  (format t "    for equality would misread a correct canonicalization as a collision.~%")
  (check (same (f1:derivation-resolution-context-declaration-identity forward)
               (f1:derivation-resolution-context-declaration-identity backward))
         "ADV-13 declaration identity is insertion-order invariant")
  (check (same (f1:derivation-resolution-context-occurrence-identity forward)
               (f1:derivation-resolution-context-occurrence-identity backward))
         "ADV-13 context occurrence identity is insertion-order invariant")
  (check (equal (mapcar #'f1:context-binding-declaration-role
                        (f1:derivation-resolution-context-declarations forward))
                (mapcar #'f1:context-binding-declaration-role
                        (f1:derivation-resolution-context-declarations backward)))
         "ADV-13 the public declarations reader reports the same canonical order"))

(format t "~%  adversarial pairs run: 12 differ-pairs + 1 canonicalization pair~%")
(format t "  adversarial failures : ~D~%" *adversarial-failures*)

;;; ══════════════════════════════════════════════════════════════════════════
;;; B.9 — TEETH.

(sub "B.9  TEETH — the detector, checked against PLANTED faults")
(format t "  A GATE THAT HAS NEVER FIRED IS UNTESTED, NOT PASSING.  Everything above~%")
(format t "  reports zero collisions, and a reader is entitled to ask whether this~%")
(format t "  instrument could have found one at all.  So two faults of exactly the two~%")
(format t "  classes this file exists to catch are PLANTED into the layer, and the~%")
(format t "  detector is required to fire on both — with the witness printed — before~%")
(format t "  the clean result above is worth anything.~%")
(format t "~%  The plant point is LISP-PLUS-FORM1::%DECLARATION-PAYLOAD, rebound by~%")
(format t "  FDEFINITION.  This is an INTERNAL SHIM, labelled as such, and it is~%")
(format t "  restored after each plant with the restoration ASSERTED — the same~%")
(format t "  discipline the procedure-version axis carries.~%")

(defparameter *true-declaration-payload*
  (fdefinition 'lisp-plus-form1::%declaration-payload))

(defun faulty-payload-dropping-denotations (context)
  "PLANTED FAULT 1 — a DROPPED DECLARED AXIS.
Emit role and reference and omit the denotation.  This is the NC-31 defect
class re-planted: the context declares something the identity does not record."
  (lisp-plus-form1::%group
   (list (lisp-plus-form1::%phase-tag "context-declaration")
         (lisp-plus-form1::%group
          (loop for role in '(:schema :conclusion :support :receiver)
                append (loop for b in (lisp-plus-form1::%canonical-role-bindings context role)
                             collect (lisp-plus-form1::%group
                                      (list (lisp-plus-form1::%text (symbol-name role))
                                            (lisp-plus-form1::%binding-reference b)))))))))

(defun faulty-payload-flattening-fields (context)
  "PLANTED FAULT 2 — A MERGED FIELD BOUNDARY.
Concatenate role, reference key and denotation path into ONE string with no
separator.  Every field is still present; only the BOUNDARIES are gone.  This
is the delimiter-ambiguity class, and it is the one a sensitivity suite cannot
see: each axis alone still moves the identity."
  (lisp-plus-form1::%group
   (list (lisp-plus-form1::%phase-tag "context-declaration")
         (lisp-plus-form1::%group
          (loop for role in '(:schema :conclusion :support :receiver)
                append (loop for b in (lisp-plus-form1::%canonical-role-bindings context role)
                             collect
                             (let ((denotation (lisp-plus-form1::%binding-denotation b)))
                               (lisp-plus-form1::%text
                                (with-output-to-string (out)
                                  (write-string (symbol-name role) out)
                                  (write-string (lisp-plus-form1::%reference-key
                                                 (lisp-plus-form1::%binding-reference b))
                                                out)
                                  (loop for i from 0 below (cd0:identifier-datum-path-count denotation)
                                        do (write-string
                                            (cd0:identifier-datum-path-segment denotation i)
                                            out)))))))))))

(defun declaration-identity-of (spec denotations tag &key extra)
  (f1:derivation-resolution-context-declaration-identity
   (context-for spec (first *families*) denotations tag :extra-supports extra)))

(defun with-planted (fault thunk)
  "Install FAULT, run THUNK, restore, and ASSERT the restoration."
  (setf (fdefinition 'lisp-plus-form1::%declaration-payload) fault)
  (unwind-protect (funcall thunk)
    (setf (fdefinition 'lisp-plus-form1::%declaration-payload) *true-declaration-payload*)))

(defun teeth-plant (name description build-a build-b)
  "Assert the pair SEPARATES on the true layer, COLLAPSES under the plant, and
SEPARATES again once the plant is removed."
  (format t "~%  ── ~A~%     ~A~%" name description)
  (let ((clean-a (funcall build-a)) (clean-b (funcall build-b)))
    (check (not (same clean-a clean-b))
           "~A: BEFORE the plant, the two declarations carry DIFFERENT identities" name)
    (multiple-value-bind (planted-a planted-b)
        (with-planted (symbol-function (if (eq name :drop)
                                           'faulty-payload-dropping-denotations
                                           'faulty-payload-flattening-fields))
          (lambda () (values (funcall build-a) (funcall build-b))))
      (let ((collided (same planted-a planted-b)))
        (check collided
               "~A: UNDER the plant, the two declarations COLLAPSE into ONE identity" name)
        (when collided
          (format t "     PLANTED COLLISION WITNESS — two distinct declarations, one identity:~%")
          (format t "       shared identity (first 48 hex): ~A...~%"
                  (subseq (hexkey planted-a) 0 48))
          (format t "       identity value: ~D octets~%" (f1:identity-octets planted-a)))
        ;; and the DETECTOR, run over the planted pair exactly as the census runs
        (let* ((points (list (make-point :label "planted-A" :kind :granted
                                         :d-context-mapping "declared-A"
                                         :context-declaration-hex (hexkey planted-a))
                             (make-point :label "planted-B" :kind :granted
                                         :d-context-mapping "declared-B"
                                         :context-declaration-hex (hexkey planted-b))))
               (result (analyse points #'point-d-context-mapping #'point-context-declaration-hex)))
          (check (= 1 (getf result :collisions))
                 "~A: ANALYSE — the same function that reported 0 above — reports ~D collision(s) here"
                 name (getf result :collisions))
          (check (= 1 (getf result :distinct-identity))
                 "~A: 2 distinct declared payloads collapsed to ~D distinct identity value(s)"
                 name (getf result :distinct-identity)))))
    (let ((restored-a (funcall build-a)) (restored-b (funcall build-b)))
      (check (and (same restored-a clean-a) (same restored-b clean-b))
             "~A: PLANT REMOVED — both identities recompute to their pre-plant values" name)
      (check (not (same restored-a restored-b))
             "~A: PLANT REMOVED — the two declarations separate again" name))))

(teeth-plant
 :drop
 "PLANTED FAULT 1 — a DROPPED DECLARED AXIS (the NC-31 defect class, re-planted)"
 (lambda () (declaration-identity-of *adv-base-spec* #'denotations-base
                                     (idd '("teeth") '("drop"))))
 (lambda () (declaration-identity-of *adv-base-spec* #'denotations-support-changed
                                     (idd '("teeth") '("drop")))))

(teeth-plant
 :flatten
 "PLANTED FAULT 2 — a MERGED FIELD BOUNDARY, fired on the ADV-7 pair itself"
 (lambda () (declaration-identity-of *adv-7-spec-a* (adv-7-denotation "bc")
                                     (idd '("teeth") '("flatten"))))
 (lambda () (declaration-identity-of *adv-7-spec-b* (adv-7-denotation "c")
                                     (idd '("teeth") '("flatten")))))

(check (eq (fdefinition 'lisp-plus-form1::%declaration-payload) *true-declaration-payload*)
       "TEETH: every plant removed; the layer is back to its own implementation")
;;; ── the exhibit this whole file was built to produce ──────────────────────
;;;
;;; The sentence "a sensitivity suite would have passed PLANT 2 clean" is a
;;; CLAIM, and a claim of exactly the kind that is comfortable to assert and
;;; expensive to be wrong about.  So it is not asserted here.  It is run.

(format t "~%  ── B.9 EXHIBIT — why SENSITIVITY could not have caught PLANT 2~%")
(format t "     Under the merged-boundary plant, hold the plant installed and move~%")
(format t "     ONE axis at a time, exactly as a sensitivity test does.  Then move~%")
(format t "     BOTH.  Everything below is measured under the SAME planted layer.~%")

(with-planted
 #'faulty-payload-flattening-fields
 (lambda ()
   (let* ((tag (idd '("teeth") '("exhibit")))
          (base    (declaration-identity-of *adv-7-spec-a* (adv-7-denotation "bc") tag))
          (den-only(declaration-identity-of *adv-7-spec-a* (adv-7-denotation "zz") tag))
          (key-only(declaration-identity-of *adv-7-spec-b* (adv-7-denotation "bc") tag))
          (both    (declaration-identity-of *adv-7-spec-b* (adv-7-denotation "c")  tag)))
     (format t "~%       baseline            ref \"a\"  denotation (\"bc\")~%")
     (check (not (same base den-only))
            "B.9 EXHIBIT: move the DENOTATION alone (\"bc\"->\"zz\") — identity MOVES  [sensitivity: PASS]")
     (check (not (same base key-only))
            "B.9 EXHIBIT: move the REFERENCE KEY alone (\"a\"->\"ab\") — identity MOVES  [sensitivity: PASS]")
     (check (same base both)
            "B.9 EXHIBIT: move BOTH (\"a\"/\"bc\" -> \"ab\"/\"c\") — identity DOES NOT MOVE  [COLLISION]")
     (format t "~%       So under PLANT 2 every axis is individually sensitive and the~%")
     (format t "       layer still collides.  A one-axis-at-a-time suite reports a clean~%")
     (format t "       sheet on a broken layer.  That gap is not hypothetical — it is~%")
     (format t "       measured, three lines above, on this machine, in this run.~%"))))

(check (eq (fdefinition 'lisp-plus-form1::%declaration-payload) *true-declaration-payload*)
       "TEETH: plant removed after the exhibit as well")

(format t "~%  Both planted faults fired, and the detector caught both.  PLANT 2 is the~%")
(format t "  one that matters: under it every declared field was still PRESENT and~%")
(format t "  every axis was still individually SENSITIVE — only the BOUNDARIES between~%")
(format t "  adjacent fields were gone.  That is the defect class a sensitivity suite~%")
(format t "  structurally cannot see, and it is the reason this census varies axes~%")
(format t "  simultaneously rather than one at a time.~%")
(format t "~%  Planted collisions are NOT counted in the census totals: ~D real collision(s).~%"
        *collisions*)

;;; ══════════════════════════════════════════════════════════════════════════
;;; SUMMARY.

(head "SUMMARY")

(defparameter *all-adv-points* nil)

(format t "~%  PART A — structural round trip~%")
(format t "    identity species covered ......... 12 of 12~%")
(format t "    both branches covered where the payload branches:~%")
(format t "      submission receipt ............. Slice /2 receipt PRESENT and ABSENT~%")
(format t "      refusal ........................ with PATH+REFERENCE and with HOST-TYPE~%")
(format t "~%  PART B — finite collision census~%")
(format t "    population size .................. ~D submissions~%" (length *census*))
(format t "    distinct declared payloads ....... ~D~%" (getf *occ-result* :distinct-declared))
(format t "    distinct identity values ......... ~D  (submission occurrence identity)~%"
        (getf *occ-result* :distinct-identity))
(format t "    collision count .................. ~D~%" *collisions*)
(format t "    declared-residual groups ......... ~D  (NOT collisions — see B.4)~%"
        (getf *occ-result* :residual-groups))
(format t "    adversarial pairs ................ 12 designed near-collisions + 1 canonicalization~%")
(format t "    planted faults (teeth) ........... 2, BOTH FIRED and both caught by the~%")
(format t "                                       same ANALYSE that reports 0 above; both~%")
(format t "                                       plants removed and the removal asserted~%")
(format t "~%  AXES~%")
(format t "    varied by PUBLIC CALL ............ subject reference keys, support keys and~%")
(format t "                                       count, petition occurrence tag, context~%")
(format t "                                       denotation declarations, unreferenced~%")
(format t "                                       bindings, context occurrence tag, act id,~%")
(format t "                                       by-id, outcome kind, Slice /2 receipt~%")
(format t "                                       presence/absence~%")
(format t "    varied by INTERNAL SHIM .......... procedure version  *** WEAKER EVIDENCE ***~%")
(format t "                                       (no public setter exists; constant function)~%")
(format t "~%  CHECKS~%")
(format t "    checks run ....................... ~D~%" *checks*)
(format t "    failures ......................... ~D~%" *failures*)

(format t "~%  THE CLAIM, RESTATED AT ITS SIZE~%")
(format t "    Form /1 identity values are injective over their declared CD/0 phase~%")
(format t "    payloads, assuming Canonical Datum /0 exact encoding.~%")
(format t "~%    NOT CLAIMED: injectivity over unrecorded live host facts.  Two contexts~%")
(format t "    with identical declarations and different live anchors produce the same~%")
(format t "    identity by design; ~D group(s) of exactly that shape are in this~%"
        (getf *occ-result* :residual-groups))
(format t "    population and are reported as the declared residual, not as collisions.~%")
(format t "~%    NOT CLAIMED: that this finite census is a proof over all inputs.  It is a~%")
(format t "    finite search that found what it found.  The general argument is PART A's:~%")
(format t "    the identity is a LOSSLESS encoding, so round trip implies injectivity~%")
(format t "    over every payload that round-trips, and CD/0 exactness is the assumption~%")
(format t "    that carries it — an assumption this file states rather than proves.~%")

(format t "~%")
(cond
  ((plusp *collisions*)
   (rule #\!)
   (format t "BLOCKED — FORM /1 IDENTITY COLLISION~%")
   (rule #\!)
   (format t "~D collision(s).  Witnesses printed above, in full.~%" *collisions*)
   (finish-output)
   (sb-ext:exit :code 1))
  ((plusp *failures*)
   (rule #\!)
   (format t "BLOCKED — ~D CHECK FAILURE(S) (no collision found; something else is wrong)~%"
           *failures*)
   (rule #\!)
   (finish-output)
   (sb-ext:exit :code 2))
  (t
   (rule #\═)
   (format t "NO COLLISION FOUND — ~D checks, ~D submissions, 0 failures.~%"
           *checks* (length *census*))
   (format t "Injectivity holds over the declared payloads of this census, at the size~%")
   (format t "stated above and no larger.~%")
   (rule #\═)
   (finish-output)
   (sb-ext:exit :code 0)))
