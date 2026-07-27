;;;; form1.lisp — Language Form /1, Candidate /0.
;;;;
;;;; Run: (load "form1.lisp")  — it loads Language Slice /2, which loads Core /0,
;;;; Slice /1, Slice /0, Kernel /0 and Canonical Datum /0.  It does NOT load
;;;; Language Form /0 and does not name it.
;;;;
;;;; READ package.lisp FIRST.  The primary law and the boundary live there.
;;;;
;;;; POLICY v2 (2026-07-27, owner ruling RESOLVE EG-4).  Identities are
;;;; IMMUTABLE CD/0 BYTE-STRING DATA, never Common Lisp strings and never
;;;; hexadecimal text.  Hex is produced ONLY by RENDER-IDENTITY-HEX, which is
;;;; diagnostic and is never embedded into a later identity.  Policy v1 —
;;;; hex-text-recursive identities — failed EG-4 and was never merged; its
;;;; evidence is preserved beside this file unchanged.
;;;;
;;;; ONE HABIT WORTH NAMING BEFORE THE CODE.  The governed operation is carried
;;;; by the PRODUCTION HEAD, not by a field and not by a table.  There is no
;;;; dispatch anywhere in this file from a datum to an operation: the head either
;;;; EQUAL-DATUMs the single petition head or the datum is not a petition.  A
;;;; table is how a second governed operation gets in by accident, so there is
;;;; no table.

;;; ── BOOTSTRAP ─────────────────────────────────────────────────────────────
;;; The only file-system access in this layer, to fixed relative paths, reached
;;; once at load time and never from any operation below.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (unless (find-package :lisp-plus-slice2)
    (handler-bind ((style-warning #'muffle-warning))
      (load (merge-pathnames "../language-slice-2/slice2.lisp" *load-truename*))))
  (unless (find-package :lisp-plus-form1)
    (handler-bind ((style-warning #'muffle-warning))
      (load (merge-pathnames "package.lisp" *load-truename*)))))

(in-package #:lisp-plus-form1)

;;; ==== BOOTSTRAP ENDS HERE ====
;;; Everything below this marker is scanned by T-NO-HOST-ESCAPE and
;;; T-NO-BROAD-HANDLER in the suite.  No EVAL, COMPILE, LOAD, PERFORM, INTERN,
;;; FIND-SYMBOL, READ or blanket (ERROR () ...) handler may appear below it.

;;; ------------------------------------------------------------------
;;; Segmented identifiers.  Every durable name in this layer is a CD/0
;;; identifier datum.  No host symbol is ever a durable name, and nothing here
;;; interns, looks up, or resolves a host symbol by name.

(defun %id (namespace path)
  (lisp-plus-cd0:make-identifier-datum namespace path))

(defun %same (left right)
  (lisp-plus-cd0:equal-datum left right))

(defun %text (string) (lisp-plus-cd0:make-string-datum string))
(defun %count (integer) (lisp-plus-cd0:make-integer-datum integer))
(defun %group (data) (lisp-plus-cd0:make-sequence-datum data))

(defun petition-grammar-identity ()
  "The identity of the Form /1 closed petition grammar."
  (%id '("lisp-plus-form1" "grammar") '("petition" "0")))

(defun petition-grammar-version () 1)

(defun petition-policy-identity ()
  "The identity of the Candidate /0 resource policy."
  (%id '("lisp-plus-form1" "policy") '("candidate" "0")))

;;; POLICY VERSION 3.  v1 used hex-text-recursive identities and a terminal
;;; CHARACTER ceiling that could only fail AFTER the governed act; it failed
;;; EG-4 and was never merged.  v2 used immutable identity data, enforced every
;;; resource refusal BEFORE invocation, and constructed the classified receipt
;;; TOTALLY once DERIVE/2 had returned or signalled — and it is that repair
;;; which stands.
;;;
;;; v3 (Review 1, owner ruling LANGUAGE FORM /1 REVIEW 1) repairs a SEMANTIC
;;; RECORDING defect that survived v2 untouched:
;;;
;;;   under v2 the context occurrence identity committed ONLY to a host-supplied
;;;   NAME.  The context's public declaration omitted its bound values.  The
;;;   submission occurrence identity therefore did not commit to what the
;;;   petition's references were declared to denote — and NC-31 exhibited two
;;;   submissions with IDENTICAL submission occurrence identities and OPPOSITE
;;;   governed outcomes.
;;;
;;; v3 requires every binding to carry a DENOTATION DECLARATION — an immutable
;;; CD/0 datum, supplied explicitly by the host — and derives a CONTEXT
;;; DECLARATION IDENTITY from the complete role/reference/declaration mapping.
;;; The context occurrence identity now commits to that declaration identity,
;;; and the submission occurrence identity commits to the context OCCURRENCE
;;; IDENTITY rather than to the bare host tag.
;;;
;;; THE PETITION DATUM GRAMMAR IS UNCHANGED.  Grammar version stays 1.
(defun petition-policy-version () 3)

;;; The three Candidate /0 ceilings.  EXPERIMENTAL, narrow, and not universal
;;; Lisp+ limits.  They exist because FIXED PHASE DEPTH DOES NOT BOUND IDENTITY
;;; SIZE: CD/0 supplies no hash, so an identity here is a LOSSLESS CANONICAL
;;; ENCODING that contains its predecessor rather than fingerprinting it.
(defun petition-policy-max-support-references () 16)
(defun petition-policy-max-canonical-octets () 16384)

;;; THE IDENTITY ENVELOPE, in OCTETS of the identity VALUE — not display
;;; characters.  Adjudicated by measurement after the representation existed
;;; (EG4-IDENTITY-VALUE-MEASUREMENT.lisp), never by guess.
(defun petition-policy-max-identity-octets () 65536)

;;; The proven bound on what the CLASSIFIED OUTCOME adds to the submission
;;; occurrence identity when the receipt identity is built.  Reserved BEFORE
;;; invocation so the terminal receipt is provably constructible; the selftest
;;; asserts the real tail never exceeds it, for all three outcome kinds.
(defun petition-policy-outcome-tail-reserve-octets () 4096)

(defun petition-submission-procedure-identity ()
  (%id '("lisp-plus-form1" "procedure") '("submit" "0")))

(defun petition-submission-procedure-version () 1)

(defun petition-head-identifier ()
  "THE production head — and it carries the governed operation.  There is
exactly one, and an unsupported governed operation is an unsupported head."
  (%id '("lisp-plus-form1") '("petition" "derive" "2")))

(defun %field-key (name)
  (%id '("lisp-plus-form1") (list "field" name)))

(defun %absent ()
  "The sanctioned legal absence marker.  A required field with nothing true in
it is a confabulation generator; this is the alternative."
  (%id '("lisp-plus-form1") '("absent")))

(defun receiver-absence-declaration ()
  "THE PACKAGE-OWNED SANCTIONED DECLARATION FOR AN EXPLICITLY ABSENT RECEIVER.

A receiver bound to NIL is a real fact — explicit receiver absence — and it
needs a denotation declaration like every other binding.  It may NOT be
described by an arbitrary host identifier: `absence' is not the host's to name,
because two hosts would name it differently and the declaration identity would
then distinguish contexts that declare the same thing.

So this exact datum is required for NIL, and is refused for a live receiver.
That check is legitimate for the same reason the species checks are: it
quantifies over exactly its own arguments and decides nothing about the world."
  (%id '("lisp-plus-form1") '("denotation" "receiver-absence")))

;;; ------------------------------------------------------------------
;;; Role-tagged references.
;;;
;;; THE ROLE IS IN THE IDENTIFIER, not in a naming convention.  A support
;;; reference and a receiver reference bearing the same host key are DIFFERENT
;;; IDENTIFIERS and do not EQUAL-DATUM, so a value bound through the support
;;; binder cannot satisfy a receiver reference "because the text is the same."
;;; The text is not the same.

(defun %reference (role-name key)
  (%id '("lisp-plus-form1") (list "ref" role-name key)))

(defun schema-reference (key)     (%reference "schema" key))
(defun conclusion-reference (key) (%reference "conclusion" key))
(defun support-reference (key)    (%reference "support" key))
(defun receiver-reference (key)   (%reference "receiver" key))

(defun reference-role (datum)
  "The role keyword of a Form /1 reference datum, or NIL when DATUM is not one.
Pure shape.  It resolves nothing and admits nothing."
  (and (lisp-plus-cd0:datum-p datum)
       (lisp-plus-cd0:identifier-datum-p datum)
       (= 1 (lisp-plus-cd0:identifier-datum-namespace-count datum))
       (string= "lisp-plus-form1"
                (lisp-plus-cd0:identifier-datum-namespace-segment datum 0))
       (= 3 (lisp-plus-cd0:identifier-datum-path-count datum))
       (string= "ref" (lisp-plus-cd0:identifier-datum-path-segment datum 0))
       (let ((role (lisp-plus-cd0:identifier-datum-path-segment datum 1)))
         (cond ((string= role "schema")     :schema)
               ((string= role "conclusion") :conclusion)
               ((string= role "support")    :support)
               ((string= role "receiver")   :receiver)
               (t nil)))))

;;; ------------------------------------------------------------------
;;; Content-derived identity and independent snapshots.
;;;
;;; A snapshot is a full canonical round trip, so the stored tree shares no
;;; structure whatever with anything the caller retains.
;;;
;;; THESE ARE NOT DIGESTS.  CD/0 supplies no hash.  An identity is a CD/0
;;; BYTE-STRING datum holding the LOSSLESS canonical octets of its payload — it
;;; CONTAINS what it identifies.  Nothing in this layer, its receipts or its
;;; documentation may call one a digest, and hex never enters an identity.

(defun %identity (payload)
  "THE IDENTITY VALUE.  An immutable CD/0 BYTE-STRING datum holding the exact
canonical octets of PAYLOAD.

It is not hexadecimal, not a printed rendering, not a digest and not a hash.
Identity equality is exact CD/0 datum equality.  Because each link embeds its
predecessor's OCTETS rather than a hex TEXT of them, composition costs one
constant header per link instead of doubling — which is the whole repair."
  (lisp-plus-cd0:make-bytes-datum (lisp-plus-cd0:canonical-octets payload)))

(defun identity-octets (identity)
  "The canonical encoded octet length of an identity VALUE.  The unit the
Candidate /0 envelope is measured in."
  (lisp-plus-cd0:octets-length (lisp-plus-cd0:canonical-octets identity)))

(defun render-identity-hex (identity)
  "DIAGNOSTIC RENDERING ONLY.  Never embedded into another identity, never
stored as an identity, never an admission credential."
  (lisp-plus-cd0:octets-to-hex (lisp-plus-cd0:canonical-octets identity)))

(defun %snapshot (datum)
  (lisp-plus-cd0:decode-exact (lisp-plus-cd0:canonical-octets datum)))

(defun %octet-count (datum)
  (lisp-plus-cd0:octets-length (lisp-plus-cd0:canonical-octets datum)))

(defun %budget-id ()
  (lisp-plus-cd0:budget-id (lisp-plus-cd0:default-resource-budget)))

(defun %phase-tag (name)
  (%id '("lisp-plus-form1" "phase") (list name)))

(defun %host-type-descriptor (object)
  "A BOUNDED host type descriptor.  Deliberately not PRIN1-TO-STRING, not
PRINT-OBJECT output and not SXHASH: an arbitrary host object has no canonical
content, and pretending otherwise is the substitution defect with a printer
attached."
  (let ((type (type-of object)))
    (if (symbolp type)
        (let ((home (symbol-package type)))
          (concatenate 'string
                       (if home (package-name home) "#")
                       ":" (symbol-name type)))
        "COMPOUND-HOST-TYPE")))

;;; ------------------------------------------------------------------
;;; Retained refusals.
;;;
;;; A refusal is an object with an identity, not a printed condition.  Every
;;; operation has a signalling name and a TRY- twin; the twin returns the very
;;; same object the condition carries.
;;;
;;; ONE CODE PER DISTINCT CONDITION.  Form /0's :UNKNOWN-PRODUCTION fires for
;;; two structurally different failures, so a reader holding only the code
;;; cannot tell which happened.  That is representation collapse, and Form /1
;;; declines to inherit it.

;;; ------------------------------------------------------------------
;;; THE REFUSAL-CODE CATALOGUE, SPLIT BY EVIDENTIARY CLASS.
;;;
;;; A FLAT COUNT FLATTENS TWO DIFFERENT KINDS OF EVIDENCE.  Under policy v2 the
;;; layer published one list of 36 codes and the suite reported `36/36'.  Three
;;; of those codes are NOT reachable through the intended public surface at all
;;; — CD/0 copies on every access, so no public caller holding a phase object
;;; can mutate the datum that object recomputes from.  Their fixtures produce
;;; them by shimming an internal function.  A count that includes them alongside
;;; codes produced by exercising the layer is a count standing in for a
;;; demonstration, and a host author writing a handler for one of them today is
;;; WRITING DEAD CODE WITH NO WAY TO TELL.
;;;
;;; So the classification lives in the CATALOGUE THE HOST READS, not only in the
;;; suite that tests it, and there is exactly ONE source of truth below.  The
;;; two published lists are DERIVED from it, so their union equals the complete
;;; implementation code set BY CONSTRUCTION rather than by maintenance.
;;;
;;;   :PROTOCOL-REFUSAL / :PUBLIC-API
;;;       a public caller can provoke this by using the documented surface.
;;;   :INTEGRITY-ALARM / :INTERNAL-PLANTED-FAULT-ONLY
;;;       a package-internal guard against a host or a future representation
;;;       that does not hold CD/0's copy-on-access line.  It is a real guard.
;;;       It is not reachable from outside, and this catalogue says so.
;;;
;;; ONE CODE PER DISTINCT CONDITION.  Form /0's :UNKNOWN-PRODUCTION fires for
;;; two structurally different failures, so a reader holding only the code
;;; cannot tell which happened.  That is representation collapse, and Form /1
;;; declines to inherit it.

(defparameter +petition-refusal-code-catalog+
  '(;; ---- boundary ----
    (:not-a-datum :protocol-refusal :public-api
     "the durable input boundary is a CD/0 datum")
    ;; ---- grammar — propose ----
    (:petition-node-not-a-sequence :protocol-refusal :public-api
     "a petition node must be a sequence datum")
    (:petition-node-arity :protocol-refusal :public-api
     "a petition node is exactly [head, body]")
    (:head-not-identifier :protocol-refusal :public-api
     "a petition node head must be an identifier datum")
    (:not-a-derivation-petition :protocol-refusal :public-api
     "the head names no Form /1 production, or the submitted object is not a petition")
    (:petition-body-not-a-record :protocol-refusal :public-api
     "a petition body must be a record datum")
    (:petition-field-missing :protocol-refusal :public-api
     "one of the four petition fields is absent and none has a default")
    (:petition-field-unknown :protocol-refusal :public-api
     "the body carries a key that is not one of the four petition fields")
    (:supports-not-a-sequence :protocol-refusal :public-api
     "the supports field must be a sequence of support-role references")
    (:malformed-reference :protocol-refusal :public-api
     "a reference position does not hold a Form /1 role-tagged reference")
    (:reference-role-mismatch :protocol-refusal :public-api
     "the reference bears a role this position does not accept")
    ;; ---- policy ----
    (:support-count-exceeded :protocol-refusal :public-api
     "more support references than the Candidate /0 ceiling admits")
    (:petition-octets-exceeded :protocol-refusal :public-api
     "the petition datum encodes to more octets than the Candidate /0 ceiling")
    (:identity-octets-exceeded :protocol-refusal :public-api
     "a constructed identity value exceeds the Candidate /0 envelope")
    (:submission-envelope-exceeded :protocol-refusal :public-api
     "the submission occurrence identity plus the reserved outcome tail exceeds the envelope")
    ;; ---- species ----
    (:not-a-proposed-petition-form :protocol-refusal :public-api
     "VALIDATE-PETITION takes a PROPOSED-PETITION-FORM")
    (:not-a-validated-petition-form :protocol-refusal :public-api
     "MATERIALIZE-PETITION takes a VALIDATED-PETITION-FORM")
    (:not-a-resolution-context :protocol-refusal :public-api
     "a context operation takes a DERIVATION-RESOLUTION-CONTEXT")
    ;; ---- identity drift — THE THREE INTEGRITY ALARMS ----
    (:proposed-identity-drift :integrity-alarm :internal-planted-fault-only
     "the proposed form no longer recomputes; unreachable publicly because CD/0 copies on access")
    (:validated-identity-drift :integrity-alarm :internal-planted-fault-only
     "the validated form no longer recomputes; unreachable publicly because CD/0 copies on access")
    (:petition-identity-drift :integrity-alarm :internal-planted-fault-only
     "the petition no longer recomputes; unreachable publicly because CD/0 copies on access")
    ;; ---- arguments ----
    (:occurrence-tag-required :protocol-refusal :public-api
     "MATERIALIZE-PETITION requires a CD/0 identifier occurrence tag; no default")
    (:by-required :protocol-refusal :public-api
     "an asserting principal is required; DERIVE/2's NIL default is not inherited")
    (:by-id-required :protocol-refusal :public-api
     ":BY-ID is required and must be a CD/0 identifier datum")
    (:act-id-required :protocol-refusal :public-api
     ":ACT-ID is required and must be a CD/0 identifier datum")
    ;; ---- context protocol ----
    (:binding-role-mismatch :protocol-refusal :public-api
     "this binder binds a different role than the reference bears")
    (:duplicate-binding :protocol-refusal :public-api
     "this reference is already bound in this role")
    (:binding-after-seal :protocol-refusal :public-api
     "a sealed context is immutable in its mapping")
    (:context-occurrence-tag-required :protocol-refusal :public-api
     "SEAL-RESOLUTION-CONTEXT requires a CD/0 identifier occurrence tag; no default")
    (:wrong-schema-species :protocol-refusal :public-api
     "the value bound in the schema role is not a Slice /2 schema")
    (:wrong-receiver-species :protocol-refusal :public-api
     "the value bound in the receiver role is neither a Slice /0 receiver context nor NIL")
    (:context-not-sealed :protocol-refusal :public-api
     "an unsealed context cannot be submitted with")
    ;; ---- denotation declaration (Review 1, policy v3) ----
    (:denotation-declaration-required :protocol-refusal :public-api
     "every binding requires an explicit immutable CD/0 denotation declaration; no default")
    (:receiver-absence-declaration-required :protocol-refusal :public-api
     "a receiver bound to NIL requires the package-owned RECEIVER-ABSENCE-DECLARATION")
    (:receiver-absence-declaration-misapplied :protocol-refusal :public-api
     "the receiver-absence declaration was supplied for a LIVE receiver")
    (:unknown-binding-role :protocol-refusal :public-api
     "the role argument names none of the four binding roles")
    ;; ---- resolution ----
    (:unresolved-schema-reference :protocol-refusal :public-api
     "no schema is bound to this reference in this sealed context")
    (:unresolved-conclusion-reference :protocol-refusal :public-api
     "no conclusion is bound to this reference in this sealed context")
    (:unresolved-support-reference :protocol-refusal :public-api
     "no support is bound to this reference in this sealed context")
    (:unresolved-receiver-reference :protocol-refusal :public-api
     "no receiver is bound to this reference in this sealed context")))

(defstruct (petition-refusal-code-entry
            (:constructor %make-code-entry)
            (:conc-name %code-entry-)
            (:copier nil)
            (:predicate petition-refusal-code-entry-p))
  code class reachability note)

(defun petition-refusal-code-entry-code (entry) (%code-entry-code entry))
(defun petition-refusal-code-entry-class (entry) (%code-entry-class entry))
(defun petition-refusal-code-entry-reachability (entry) (%code-entry-reachability entry))
(defun petition-refusal-code-entry-note (entry)
  "A FRESH string."
  (copy-seq (%code-entry-note entry)))

(defun petition-refusal-code-catalog ()
  "THE COMPLETE CATALOGUE, one FRESH entry per code, each stating its class and
its REACHABILITY.  This is the surface a host author should read before writing
a handler: three of these codes cannot be provoked from outside this package,
and the catalogue says which."
  (loop for (code class reachability note) in +petition-refusal-code-catalog+
        collect (%make-code-entry :code code :class class
                                  :reachability reachability :note note)))

(defun petition-protocol-refusal-codes ()
  "A FRESH list of the codes a PUBLIC CALLER can provoke through the documented
surface.  DERIVED from the catalogue, never maintained beside it."
  (loop for entry in +petition-refusal-code-catalog+
        when (eq :protocol-refusal (second entry)) collect (first entry)))

(defun petition-integrity-alarm-codes ()
  "A FRESH list of the package-internal integrity guards.  They are REAL guards
against a host or a future representation that does not hold CD/0's
copy-on-access line — and they are NOT reachable through the intended public
surface, which is why they are published separately rather than counted in.

DERIVED from the catalogue, never maintained beside it."
  (loop for entry in +petition-refusal-code-catalog+
        when (eq :integrity-alarm (second entry)) collect (first entry)))

(defstruct (petition-refusal
            (:constructor %make-petition-refusal)
            (:conc-name %petition-refusal-)
            (:copier nil)
            (:predicate petition-refusal-p))
  phase category code path offending reference expected-role host-type detail
  identity)

(defun petition-refusal-phase (refusal)        (%petition-refusal-phase refusal))
(defun petition-refusal-category (refusal)     (%petition-refusal-category refusal))
(defun petition-refusal-code (refusal)         (%petition-refusal-code refusal))
(defun petition-refusal-offending (refusal)    (%petition-refusal-offending refusal))
(defun petition-refusal-reference (refusal)    (%petition-refusal-reference refusal))
(defun petition-refusal-expected-role (refusal)(%petition-refusal-expected-role refusal))
(defun petition-refusal-host-type (refusal)
  "A FRESH string.  Common Lisp strings are MUTABLE; a reader that hands out the
stored one lets a caller edit the refusal after the fact."
  (let ((value (%petition-refusal-host-type refusal)))
    (and value (copy-seq value))))
(defun petition-refusal-detail (refusal)
  "A FRESH string, for the same reason."
  (let ((value (%petition-refusal-detail refusal)))
    (and value (copy-seq value))))
(defun petition-refusal-identity (refusal)     (%petition-refusal-identity refusal))

(defun petition-refusal-path (refusal)
  "A FRESH list.  An aggregate reader may not hand out the stored value."
  (copy-list (%petition-refusal-path refusal)))

(define-condition petition-refused (error)
  ((refusal :initarg :refusal :reader petition-refused-refusal))
  (:report
   (lambda (condition stream)
     (let ((refusal (petition-refused-refusal condition)))
       (format stream "Form /1 refusal at ~A: (~A . ~A)~@[ — ~A~]"
               (petition-refusal-phase refusal)
               (petition-refusal-category refusal)
               (petition-refusal-code refusal)
               (petition-refusal-detail refusal))))))

(defun %path-datum (path)
  (%group (mapcar (lambda (step)
                    (if (integerp step) (%count step) (%text (string step))))
                  path)))

(defun %name-text (keyword-or-nil)
  (if keyword-or-nil (%text (symbol-name keyword-or-nil)) (%absent)))

(defun %build-refusal (phase category code
                       &key path offending reference expected-role host-type detail)
  ;; DATUM-STAGE refusals retain the exact immutable CD/0 datum.
  ;; HOST-OBJECT-STAGE refusals retain a BOUNDED type descriptor and no claim of
  ;; durable content identity — see %HOST-TYPE-DESCRIPTOR.
  (let* ((snapshot (when offending (%snapshot offending)))
         (identity
           (%identity (%group (list (%phase-tag "refusal")
                               (%name-text phase)
                               (%name-text category)
                               (%name-text code)
                               (%path-datum path)
                               (if snapshot snapshot (%absent))
                               (if reference reference (%absent))
                               (%name-text expected-role)
                               (if host-type (%text host-type) (%absent)))))))
    (%make-petition-refusal :phase phase :category category :code code
                            :path (copy-list path)
                            :offending snapshot
                            :reference reference
                            :expected-role expected-role
                            :host-type host-type
                            :detail detail
                            :identity identity)))

(defmacro %refuse (phase category code &rest keys)
  `(error 'petition-refused
          :refusal (%build-refusal ,phase ,category ,code ,@keys)))

(defmacro %retain-1 (&body body)
  "For operations returning ONE success value.
  success: (values RESULT nil)   refusal: (values nil REFUSAL)

ONLY PETITION-REFUSED is caught.  Any other condition ESCAPES as an
implementation failure — converting one into a semantic refusal is the defect
this layer's own precedent paid for."
  `(handler-case (values (progn ,@body) nil)
     (petition-refused (condition)
       (values nil (petition-refused-refusal condition)))))

(defmacro %retain-2 (&body body)
  "For operations returning TWO success values.
  success: (values A B nil)      refusal: (values nil nil REFUSAL)

A SINGLE UNARY WRAPPER IS WRONG FOR AN OPERATION OF ARITY TWO: it silently
discards the second value.  MATERIALIZE-PETITION returns a petition AND its
materialization receipt, and a TRY- twin that dropped the receipt would hand
back a petition whose materialization had no retrievable account."
  `(handler-case (multiple-value-bind (first second) (progn ,@body)
                   (values first second nil))
     (petition-refused (condition)
       (values nil nil (petition-refused-refusal condition)))))

(defun %gated-identity (phase payload)
  "Build an identity VALUE and enforce the octet envelope.

EVERY CALL SITE IS BEFORE PUBLIC DERIVE/2 IS INVOKED.  There is deliberately no
such gate after invocation: once the governed act has happened, receipt
construction is TOTAL, and a policy refusal that erased an already-observed
governed act is exactly the defect policy v1 shipped."
  (let ((identity (%identity payload)))
    (when (> (identity-octets identity) (petition-policy-max-identity-octets))
      (%refuse phase :policy :identity-octets-exceeded
               :detail (format nil "identity value is ~D octets; the Candidate /0 ~
envelope is ~D octets"
                               (identity-octets identity)
                               (petition-policy-max-identity-octets))))
    identity))

;;; ------------------------------------------------------------------
;;; Grammar constructors.  A program writes a petition by hand.
;;;
;;; PETITION-DATUM RETURNS A CD/0 DATUM.  A datum is not a proposal, is not a
;;; petition, and acquires nothing by being well-shaped.

(defun petition-datum (&key schema conclusion supports receiver)
  (%group
   (list (petition-head-identifier)
         (lisp-plus-cd0:make-record-datum
          (list (lisp-plus-cd0:make-record-entry (%field-key "schema") schema)
                (lisp-plus-cd0:make-record-entry (%field-key "conclusion") conclusion)
                (lisp-plus-cd0:make-record-entry (%field-key "supports")
                                                 (%group supports))
                (lisp-plus-cd0:make-record-entry (%field-key "receiver") receiver))))))

;;; ------------------------------------------------------------------
;;; PHASE 1 — PROPOSE.  Grammar admission, and an exact snapshot.

(defstruct (proposed-petition-form
            (:constructor %make-proposed)
            (:conc-name %proposed-)
            (:copier nil)
            (:predicate proposed-petition-form-p))
  datum subject-identity identity
  schema-ref conclusion-ref support-refs receiver-ref)

(defun proposed-petition-form-datum (form) (%proposed-datum form))
(defun proposed-petition-form-subject-identity (form) (%proposed-subject-identity form))
(defun proposed-petition-form-identity (form) (%proposed-identity form))
(defun proposed-petition-form-grammar-identity (form)
  (declare (ignore form)) (petition-grammar-identity))
(defun proposed-petition-form-grammar-version (form)
  (declare (ignore form)) (petition-grammar-version))

(defun %record-lookup (record key)
  "Values: VALUE, FOUND-P.  Key comparison is EQUAL-DATUM — never INTERN, never
FIND-SYMBOL, never a host string table."
  (loop for index from 0 below (lisp-plus-cd0:record-datum-size record)
        when (%same key (lisp-plus-cd0:record-datum-key-at record index))
          do (return (values (lisp-plus-cd0:record-datum-value-at record index) t))
        finally (return (values nil nil))))

(defun %require-reference (value role path)
  (let ((actual (reference-role value)))
    (unless actual
      (%refuse :propose :grammar :malformed-reference
               :path path :offending value
               :detail "a reference position must hold a Form /1 role-tagged reference"))
    (unless (eq actual role)
      (%refuse :propose :grammar :reference-role-mismatch
               :path path :offending value :reference value :expected-role role
               :detail (format nil "this position requires a ~A-role reference; ~
the datum bears role ~A" role actual)))
    value))

(defun propose-petition (candidate)
  "Admit CANDIDATE, an already-decoded CD/0 datum, as a proposed petition.

This is an ADMISSION, not a decoding and not a parse.  Nothing is run, nothing
is resolved, nothing is looked up, and the result is inert."
  (unless (lisp-plus-cd0:datum-p candidate)
    (%refuse :propose :boundary :not-a-datum
             :host-type (%host-type-descriptor candidate)
             :detail "the durable input boundary is a CD/0 datum"))
  (unless (lisp-plus-cd0:sequence-datum-p candidate)
    (%refuse :propose :grammar :petition-node-not-a-sequence
             :offending candidate
             :detail (format nil "a petition node must be a sequence; found a ~(~A~) datum"
                             (lisp-plus-cd0:datum-family candidate))))
  (unless (= 2 (lisp-plus-cd0:sequence-datum-length candidate))
    (%refuse :propose :grammar :petition-node-arity
             :offending candidate
             :detail (format nil "a petition node is exactly [head, body]; found ~D element(s)"
                             (lisp-plus-cd0:sequence-datum-length candidate))))
  (let ((head (lisp-plus-cd0:sequence-datum-ref candidate 0))
        (body (lisp-plus-cd0:sequence-datum-ref candidate 1)))
    (unless (lisp-plus-cd0:identifier-datum-p head)
      (%refuse :propose :grammar :head-not-identifier
               :path '(0) :offending head
               :detail "a petition node head must be an identifier datum"))
    ;; ONE HONEST CODE.  Form /1 does not reproduce Form /0's production-head
    ;; vocabulary in order to say "that is a Form /0 head" — a second
    ;; representation of another layer's grammar, maintained here, free to
    ;; drift.  The application shows Form /0's refusal by asking FORM /0.
    (unless (%same head (petition-head-identifier))
      (%refuse :propose :grammar :not-a-derivation-petition
               :path '(0) :offending head
               :detail (format nil "~A heads no Form /1 production; the sole ~
petition head names DERIVE/2"
                               (lisp-plus-cd0:render-diagnostic head))))
    (unless (lisp-plus-cd0:record-datum-p body)
      (%refuse :propose :grammar :petition-body-not-a-record
               :path '(1) :offending body
               :detail (format nil "a petition body must be a record datum; found a ~(~A~) datum"
                               (lisp-plus-cd0:datum-family body))))
    (let* ((known (list (%field-key "schema") (%field-key "conclusion")
                        (%field-key "supports") (%field-key "receiver"))))
      ;; unknown fields — a `by`-shaped field lands here, and deliberately so:
      ;; there is no separate forbidden-name list, because a second vocabulary
      ;; is a second thing that can drift from the first.
      (loop for index from 0 below (lisp-plus-cd0:record-datum-size body)
            for key = (lisp-plus-cd0:record-datum-key-at body index)
            unless (find key known :test #'%same)
              do (%refuse :propose :grammar :petition-field-unknown
                          :path (list 1 index) :offending key
                          :detail (format nil "~A is not one of the four petition fields"
                                          (lisp-plus-cd0:render-diagnostic key))))
      (loop for key in known
            for name in '("schema" "conclusion" "supports" "receiver")
            do (multiple-value-bind (value found) (%record-lookup body key)
                 (declare (ignore value))
                 (unless found
                   (%refuse :propose :grammar :petition-field-missing
                            :path (list 1) :offending key
                            :detail (format nil "the ~A field is required and has no default"
                                            name))))))
    (let* ((schema-ref (%require-reference (%record-lookup body (%field-key "schema"))
                                           :schema '(1 :schema)))
           (conclusion-ref (%require-reference (%record-lookup body (%field-key "conclusion"))
                                               :conclusion '(1 :conclusion)))
           (receiver-ref (%require-reference (%record-lookup body (%field-key "receiver"))
                                             :receiver '(1 :receiver)))
           (supports (%record-lookup body (%field-key "supports"))))
      (unless (lisp-plus-cd0:sequence-datum-p supports)
        (%refuse :propose :grammar :supports-not-a-sequence
                 :path '(1 :supports) :offending supports
                 :detail "the supports field must be a sequence of support-role references"))
      (let ((count (lisp-plus-cd0:sequence-datum-length supports)))
        ;; POLICY BEFORE IDENTITY.  Both ceilings are enforced before any
        ;; recursively embedded phase identity is constructed.
        (when (> count (petition-policy-max-support-references))
          (%refuse :propose :policy :support-count-exceeded
                   :path '(1 :supports) :offending supports
                   :detail (format nil "~D support references exceeds the Candidate /0 ceiling ~D"
                                   count (petition-policy-max-support-references))))
        (let ((support-refs
                (loop for index from 0 below count
                      collect (%require-reference
                               (lisp-plus-cd0:sequence-datum-ref supports index)
                               :support (list 1 :supports index)))))
          (let ((octets (%octet-count candidate)))
            (when (> octets (petition-policy-max-canonical-octets))
              (%refuse :propose :policy :petition-octets-exceeded
                       :offending nil
                       :detail (format nil "petition encodes to ~D octets; the Candidate /0 ~
ceiling is ~D" octets (petition-policy-max-canonical-octets)))))
          (let* ((snapshot (%snapshot candidate))
                 ;; SUBJECT IDENTITY — the canonical petition datum itself.
                 (subject (%gated-identity :propose snapshot))
                 ;; PROPOSED IDENTITY — phase tag + grammar + the SUBJECT
                 ;; IDENTITY.  Transitive and non-redundant: the predecessor
                 ;; identity already commits to the datum, so the datum is not
                 ;; restated here.
                 (identity
                   (%gated-identity
                    :propose
                    (%group (list (%phase-tag "proposed")
                                  (petition-grammar-identity)
                                  (%count (petition-grammar-version))
                                  subject)))))
            (%make-proposed :datum snapshot
                            :subject-identity subject
                            :identity identity
                            :schema-ref (%snapshot schema-ref)
                            :conclusion-ref (%snapshot conclusion-ref)
                            :support-refs (mapcar #'%snapshot support-refs)
                            :receiver-ref (%snapshot receiver-ref))))))))

(defun try-propose-petition (candidate)
  "THE AUTHORITATIVE CLASSIFIER.
  success: (values PROPOSED nil)   refusal: (values nil REFUSAL)

No boolean twin is exported: a predicate that could disagree with this is a
second representation of the same question."
  (%retain-1 (propose-petition candidate)))

;;; ------------------------------------------------------------------
;;; PHASE 2 — VALIDATE.  Bind the exact proposed object to grammar and policy.
;;; This is NOT a mutable status change: it returns a new immutable object, and
;;; there is no status setter anywhere in this package.

(defstruct (petition-validation-receipt
            (:constructor %make-validation-receipt)
            (:conc-name %validation-receipt-)
            (:copier nil)
            (:predicate petition-validation-receipt-p))
  identity subject-identity proposed-identity
  grammar-identity grammar-version policy-identity policy-version budget-id)

(defun petition-validation-receipt-identity (r) (%validation-receipt-identity r))
(defun petition-validation-receipt-subject-identity (r) (%validation-receipt-subject-identity r))
(defun petition-validation-receipt-proposed-identity (r) (%validation-receipt-proposed-identity r))
(defun petition-validation-receipt-grammar-identity (r) (%validation-receipt-grammar-identity r))
(defun petition-validation-receipt-grammar-version (r) (%validation-receipt-grammar-version r))
(defun petition-validation-receipt-policy-identity (r) (%validation-receipt-policy-identity r))
(defun petition-validation-receipt-policy-version (r) (%validation-receipt-policy-version r))
(defun petition-validation-receipt-budget-id (r)
  "A FRESH string."
  (copy-seq (string (%validation-receipt-budget-id r))))

(defstruct (validated-petition-form
            (:constructor %make-validated)
            (:conc-name %validated-)
            (:copier nil)
            (:predicate validated-petition-form-p))
  proposed subject-identity identity predecessor-identity receipt)

(defun validated-petition-form-subject-identity (f) (%validated-subject-identity f))
(defun validated-petition-form-identity (f) (%validated-identity f))
(defun validated-petition-form-predecessor-identity (f) (%validated-predecessor-identity f))
(defun validated-petition-form-receipt (f) (%validated-receipt f))
(defun validated-petition-form-grammar-identity (f)
  (declare (ignore f)) (petition-grammar-identity))
(defun validated-petition-form-grammar-version (f)
  (declare (ignore f)) (petition-grammar-version))
(defun validated-petition-form-policy-identity (f)
  (declare (ignore f)) (petition-policy-identity))
(defun validated-petition-form-policy-version (f)
  (declare (ignore f)) (petition-policy-version))
(defun validated-petition-form-budget-id (f)
  "A FRESH string."
  (declare (ignore f)) (copy-seq (string (%budget-id))))

(defun validate-petition (proposed)
  "Bind PROPOSED to the exact grammar identity/version, the Candidate /0
resource policy identity/version, the budget id and the exact subject identity."
  (unless (proposed-petition-form-p proposed)
    (%refuse :validate :species :not-a-proposed-petition-form
             :host-type (%host-type-descriptor proposed)
             :detail "VALIDATE-PETITION takes a PROPOSED-PETITION-FORM"))
  (let ((recomputed (%identity (%proposed-datum proposed))))
    (unless (%same recomputed (%proposed-subject-identity proposed))
      (%refuse :validate :identity :proposed-identity-drift
               :detail "the proposed form no longer recomputes to its recorded subject identity")))
  (let* ((subject (%proposed-subject-identity proposed))
         (predecessor (%proposed-identity proposed))
         ;; VALIDATED IDENTITY — phase tag + PROPOSED IDENTITY + policy +
         ;; budget.  Grammar and subject are NOT restated: the proposed
         ;; identity already commits to both.
         (identity
           (%gated-identity
            :validate
            (%group (list (%phase-tag "validated")
                          predecessor
                          (petition-policy-identity)
                          (%count (petition-policy-version))
                          ;; CD/0's BUDGET-ID is a HOST string, not a datum.
                          (%text (string (%budget-id)))))))
         (receipt
           (%make-validation-receipt
            :identity (%gated-identity
                       :validate
                       (%group (list (%phase-tag "validation-receipt")
                                     identity)))
            :subject-identity subject
            :proposed-identity predecessor
            :grammar-identity (petition-grammar-identity)
            :grammar-version (petition-grammar-version)
            :policy-identity (petition-policy-identity)
            :policy-version (petition-policy-version)
            :budget-id (%budget-id))))
    (%make-validated :proposed proposed
                     :subject-identity subject
                     :identity identity
                     :predecessor-identity predecessor
                     :receipt receipt)))

(defun try-validate-petition (proposed)
  "success: (values VALIDATED nil)   refusal: (values nil REFUSAL)"
  (%retain-1 (validate-petition proposed)))

;;; ------------------------------------------------------------------
;;; DOOR 1 — MATERIALIZE.
;;;
;;; MATERIALIZE-PETITION TAKES NO RESOLUTION CONTEXT.  It is structurally
;;; incapable of submitting, not merely disinclined to.  Remove the socket; do
;;; not guard it.

(defstruct (derivation-petition
            (:constructor %make-petition)
            (:conc-name %petition-)
            (:copier nil)
            (:predicate derivation-petition-p))
  validated-identity subject-identity content-identity occurrence-identity
  occurrence-tag schema-ref conclusion-ref support-refs receiver-ref)

(defun derivation-petition-validated-identity (p) (%petition-validated-identity p))
(defun derivation-petition-subject-identity (p) (%petition-subject-identity p))
(defun derivation-petition-content-identity (p) (%petition-content-identity p))
(defun derivation-petition-occurrence-identity (p) (%petition-occurrence-identity p))
(defun derivation-petition-occurrence-tag (p) (%petition-occurrence-tag p))
(defun derivation-petition-schema-reference (p) (%petition-schema-ref p))
(defun derivation-petition-conclusion-reference (p) (%petition-conclusion-ref p))
(defun derivation-petition-receiver-reference (p) (%petition-receiver-ref p))
(defun derivation-petition-policy-identity (p)
  (declare (ignore p)) (petition-policy-identity))
(defun derivation-petition-policy-version (p)
  (declare (ignore p)) (petition-policy-version))

(defun derivation-petition-support-references (petition)
  "A FRESH list.  The stored list is never handed out — the de-pignore Review 2
lesson: a read-only SLOT is not an immutable VALUE."
  (copy-list (%petition-support-refs petition)))

(defstruct (petition-materialization-receipt
            (:constructor %make-materialization-receipt)
            (:conc-name %materialization-receipt-)
            (:copier nil)
            (:predicate petition-materialization-receipt-p))
  identity validated-identity content-identity occurrence-identity)

(defun petition-materialization-receipt-identity (r) (%materialization-receipt-identity r))
(defun petition-materialization-receipt-validated-identity (r)
  (%materialization-receipt-validated-identity r))
(defun petition-materialization-receipt-content-identity (r)
  (%materialization-receipt-content-identity r))
(defun petition-materialization-receipt-occurrence-identity (r)
  (%materialization-receipt-occurrence-identity r))
(defun petition-materialization-receipt-policy-identity (r)
  (declare (ignore r)) (petition-policy-identity))
(defun petition-materialization-receipt-policy-version (r)
  (declare (ignore r)) (petition-policy-version))

(defun materialize-petition (validated occurrence-tag)
  "Produce the inert DERIVATION-PETITION and its materialization receipt.

PERFORMS NO DERIVATION.  RESOLVES NOTHING.  TOUCHES NO LIVE OBJECT.  It cannot
reach DERIVE/2 because it holds no context that could name one.

OCCURRENCE-TAG is required and has no default.  Form /1 does not and cannot
guarantee that two supplied tags differ; it guarantees only that the tag is
bound into the identity.  NO GLOBAL EXACTLY-ONCE CLAIM IS MADE."
  (unless (validated-petition-form-p validated)
    (%refuse :materialize :species :not-a-validated-petition-form
             :host-type (%host-type-descriptor validated)
             :detail "MATERIALIZE-PETITION takes a VALIDATED-PETITION-FORM"))
  (unless (and (lisp-plus-cd0:datum-p occurrence-tag)
               (lisp-plus-cd0:identifier-datum-p occurrence-tag))
    (%refuse :materialize :argument :occurrence-tag-required
             :host-type (%host-type-descriptor occurrence-tag)
             :detail "an occurrence tag is required and must be a CD/0 identifier datum"))
  (let* ((proposed (%validated-proposed validated))
         (recomputed (%identity (%proposed-datum proposed))))
    (unless (%same recomputed (%validated-subject-identity validated))
      (%refuse :materialize :identity :validated-identity-drift
               :detail "the validated form no longer recomputes to its recorded subject identity"))
    (let* (;; PETITION CONTENT IDENTITY — phase tag + VALIDATED IDENTITY.
           ;; The four reference fields are NOT restated: the validated
           ;; identity already commits to the exact petition datum that
           ;; contains them.  The object retains them as direct fields for
           ;; inspection and execution; the identity chain does not duplicate
           ;; what its predecessor already binds.
           (content
             (%gated-identity
              :materialize
              (%group (list (%phase-tag "petition-content")
                            (%validated-identity validated)))))
           ;; PETITION OCCURRENCE IDENTITY — content + the occurrence tag.
           (occurrence
             (%gated-identity
              :materialize
              (%group (list (%phase-tag "petition-occurrence")
                            content
                            (%snapshot occurrence-tag)))))
           (petition
             (%make-petition :validated-identity (%validated-identity validated)
                             :subject-identity (%validated-subject-identity validated)
                             :content-identity content
                             :occurrence-identity occurrence
                             :occurrence-tag (%snapshot occurrence-tag)
                             :schema-ref (%proposed-schema-ref proposed)
                             :conclusion-ref (%proposed-conclusion-ref proposed)
                             :support-refs (copy-list (%proposed-support-refs proposed))
                             :receiver-ref (%proposed-receiver-ref proposed)))
           (receipt
             (%make-materialization-receipt
              :identity (%gated-identity
                         :materialize
                         (%group (list (%phase-tag "materialization-receipt")
                                       occurrence)))
              :validated-identity (%validated-identity validated)
              :content-identity content
              :occurrence-identity occurrence)))
      (values petition receipt))))

(defun try-materialize-petition (validated occurrence-tag)
  "success: (values PETITION MATERIALIZATION-RECEIPT nil)
   refusal: (values nil nil REFUSAL)

THREE values, not two.  The loud operation returns two on success, so its twin
returns the EXACT SAME two plus the refusal slot."
  (%retain-2 (materialize-petition validated occurrence-tag)))

;;; ------------------------------------------------------------------
;;; THE SEALED, LOCAL RESOLUTION CONTEXT.
;;;
;;;     REFERENCE RESOLUTION IS NOT EVIDENCE ADMISSION.
;;;
;;; Resolving a reference yields the bound object and nothing else: no evidence,
;;; standing, claim, basis, capability or authority is produced by resolution.
;;;
;;; Bindings are held ROLE-SEPARATED, in four independent tables.  There is no
;;; generic public binder.  A support-bound value cannot satisfy a receiver
;;; reference, because it is not in the receiver table and because the two
;;; references are not the same identifier.
;;;
;;; TWO IMMUTABILITIES, AND ONLY ONE IS CLAIMED.
;;;   CONTEXT MAPPING IMMUTABILITY   — claimed: after seal the key->object
;;;                                    associations cannot be altered.
;;;   TRANSITIVE TARGET IMMUTABILITY — NOT claimed: the referenced live host
;;;                                    objects keep their own semantics.
;;;
;;; ── POLICY v3: EVERY BINDING CARRIES TWO DISTINCT FACTS ──────────────────
;;;
;;;   DENOTATION DECLARATION
;;;       an immutable CD/0 datum supplied by the host, naming or describing
;;;       what the reference is INTENDED to denote.  Durable.  It enters the
;;;       context declaration identity.
;;;
;;;   LIVE ANCHOR
;;;       the exact image-local Common Lisp object handed to DERIVE/2.  It is
;;;       NOT durable, NOT canonically encodable, and NEVER enters an identity.
;;;
;;; NO ARBITRARY LIVE HOST OBJECT IS CANONICALLY ENCODED HERE, and the
;;; declaration is never DERIVED from the anchor: not from TYPE-OF, not from a
;;; printed rendering, not from a hash, not from an address.  An arbitrary host
;;; object has no canonical content, and manufacturing one from its accidents is
;;; the substitution defect with a printer attached.  The host DECLARES; the
;;; layer RECORDS the declaration.
;;;
;;;     THE DECLARATION RECORDS WHAT THE TRUSTED HOST ASSERTS ABOUT THE LIVE
;;;     ANCHOR.  FORM /1 DOES NOT INDEPENDENTLY CERTIFY THAT ASSERTION.
;;;
;;; Where an existing governed identity is publicly available the host MAY use
;;; its exact IDENTITY->DATUM value, and the application does.  Form /1 does not
;;; require every host object to possess such an identity; it requires the host
;;; to make an explicit, durable declaration.

(defstruct (%binding
            (:constructor %make-binding)
            (:conc-name %binding-)
            (:copier nil))
  reference denotation anchor)

(defstruct (context-binding-declaration
            (:constructor %make-declaration)
            (:conc-name %declaration-)
            (:copier nil)
            (:predicate context-binding-declaration-p))
  role reference denotation)

(defun context-binding-declaration-role (declaration) (%declaration-role declaration))
(defun context-binding-declaration-reference (declaration) (%declaration-reference declaration))
(defun context-binding-declaration-denotation (declaration) (%declaration-denotation declaration))

(defstruct (derivation-resolution-context
            (:constructor %make-context)
            (:conc-name %context-)
            (:copier nil)
            (:predicate derivation-resolution-context-p))
  schema conclusion support receiver sealed-p
  occurrence-tag declaration-identity occurrence-identity)

(defun derivation-resolution-context-sealed-p (context)
  (and (%context-sealed-p context) t))

(defun derivation-resolution-context-occurrence-tag (context)
  "The exact datum the host supplied at seal.  IT IS A TAG, NOT AN IDENTITY:
two hosts may supply the same tag for different declarations, which is precisely
why the tag alone is no longer what the submission commits to."
  (%context-occurrence-tag context))

(defun derivation-resolution-context-declaration-identity (context)
  "CONTENT-DERIVED from the complete role / reference / denotation-declaration
mapping, in a canonical order.  NIL until the context is sealed.

IT COMMITS TO EVERY BINDING'S ROLE, EXACT REFERENCE AND EXACT DENOTATION
DECLARATION.  IT DOES NOT COMMIT TO THE LIVE HOST OBJECT — nothing here can."
  (%context-declaration-identity context))

(defun derivation-resolution-context-occurrence-identity (context)
  "CONTENT-DERIVED from the phase tag, the host-supplied occurrence tag, the
context declaration identity and the context policy identity/version.  NIL until
the context is sealed.

Two contexts with the same occurrence tag and DIFFERENT denotation declarations
have DIFFERENT context occurrence identities."
  (%context-occurrence-identity context))

(defun make-derivation-resolution-context ()
  "An UNSEALED, local context.  There is no global registry, no special
variable and no ambient table anywhere in this layer."
  (%make-context :schema nil :conclusion nil :support nil :receiver nil
                 :sealed-p nil :occurrence-tag nil
                 :declaration-identity nil :occurrence-identity nil))

(defun %context-table (context role)
  (ecase role
    (:schema (%context-schema context))
    (:conclusion (%context-conclusion context))
    (:support (%context-support context))
    (:receiver (%context-receiver context))))

(defun %rebuild-context (context role table)
  (%make-context
   :schema (if (eq role :schema) table (%context-schema context))
   :conclusion (if (eq role :conclusion) table (%context-conclusion context))
   :support (if (eq role :support) table (%context-support context))
   :receiver (if (eq role :receiver) table (%context-receiver context))
   :sealed-p nil
   :occurrence-tag nil
   :declaration-identity nil
   :occurrence-identity nil))

(defun %find-binding (table reference)
  (find reference table :key #'%binding-reference :test #'%same))

(defun %bind (context reference value denotation role checker expected-species-code)
  (unless (derivation-resolution-context-p context)
    (%refuse :context :species :not-a-resolution-context
             :host-type (%host-type-descriptor context)
             :detail "a binder takes a DERIVATION-RESOLUTION-CONTEXT"))
  (when (%context-sealed-p context)
    (%refuse :context :context :binding-after-seal
             :reference (when (reference-role reference) reference)
             :expected-role role
             :detail "a sealed context is immutable in its mapping"))
  (let ((actual (reference-role reference)))
    (unless actual
      (%refuse :context :grammar :malformed-reference
               :offending (when (lisp-plus-cd0:datum-p reference) reference)
               :host-type (unless (lisp-plus-cd0:datum-p reference)
                            (%host-type-descriptor reference))
               :expected-role role
               :detail "a binder takes a Form /1 role-tagged reference"))
    (unless (eq actual role)
      (%refuse :context :context :binding-role-mismatch
               :reference reference :expected-role role
               :detail (format nil "this binder binds ~A-role references; the ~
reference bears role ~A" role actual))))
  ;; THE DENOTATION DECLARATION IS REQUIRED AND HAS NO DEFAULT.  A binder that
  ;; defaulted it would let a context be built whose declaration identity was
  ;; the layer's invention rather than the host's assertion.
  (unless (lisp-plus-cd0:datum-p denotation)
    (%refuse :context :argument :denotation-declaration-required
             :reference reference :expected-role role
             :host-type (%host-type-descriptor denotation)
             :detail "a denotation declaration is required and must be an immutable CD/0 datum"))
  (let ((table (%context-table context role)))
    (when (%find-binding table reference)
      (%refuse :context :context :duplicate-binding
               :reference reference :expected-role role
               :detail "this reference is already bound in this role"))
    (when checker
      (unless (funcall checker value)
        (%refuse :context :context expected-species-code
                 :reference reference :expected-role role
                 :host-type (%host-type-descriptor value)
                 :detail "the bound value is not of the species this role requires")))
    (%rebuild-context context role
                      (append table
                              (list (%make-binding :reference (%snapshot reference)
                                                   :denotation (%snapshot denotation)
                                                   :anchor value))))))

(defun bind-schema-reference (context reference live-schema denotation-id)
  "Bind a schema-role reference to an EXACT live Slice /2 schema value and to
the host's DENOTATION-ID for it.

The species check is legitimate because it quantifies over exactly its own
argument.  It decides nothing about liveness or admissibility — DERIVE/2 owns
both, and checks the registry itself.  DENOTATION-ID must be an immutable CD/0
datum; the schema's own governed identity, via IDENTITY->DATUM, is the natural
choice where the host has one."
  (%bind context reference live-schema denotation-id :schema
         #'lisp-plus-slice2:slice2-schema-p :wrong-schema-species))

(defun bind-conclusion-reference (context reference live-conclusion denotation-id)
  "Bind a conclusion-role reference and its DENOTATION-ID.  ROLE-TYPED AND
VALUE-UNCHECKED, verified deliberately: %REQUIRE-GROUND refuses exactly
PROPOSITION-PATTERN-P, but groundness is discharged by TWO gates — the second is
(PROPOSITION x), which signals independently — and the public NORMAL-FORM-P
tests a strictly stronger property that would refuse conclusions Slice /1
accepts.  A check here would be A GATE THAT LOOKS COMPLETE AND IS NOT.  The
Slice /1 escape conditions stay visible instead."
  (%bind context reference live-conclusion denotation-id :conclusion nil nil))

(defun bind-support-reference (context reference live-support denotation-id)
  "Bind a support-role reference and its DENOTATION-ID.  VALUE-UNTYPED
DELIBERATELY.  DERIVE/2 classifies supports into five species and records
unrecognized ones as inert residue at the caller's index; a Form /1 filter would
reproduce, two layers up, the exact defect CHARTER-DELTA-3 paid to fix one layer
down."
  (%bind context reference live-support denotation-id :support nil nil))

(defun bind-receiver-reference (context reference live-receiver denotation-id)
  "Bind a receiver-role reference to an EXACT live Slice /0 receiver context, or
to NIL as EXPLICIT RECEIVER ABSENCE, together with its DENOTATION-ID.

A bound NIL is a different fact from an unresolved receiver reference and
produces a different outcome — so it needs a declaration like any other binding,
and it may not be described by an arbitrary host identifier.  For NIL the
DENOTATION-ID must be exactly (RECEIVER-ABSENCE-DECLARATION), and that
declaration may not be supplied for a live receiver.  Both directions are
checked: the sanctioned marker means one thing or it means nothing."
  (let ((context (%bind context reference live-receiver denotation-id :receiver
                        (lambda (value) (or (null value)
                                            (lisp-plus-slice0:receiver-context-p value)))
                        :wrong-receiver-species)))
    (cond ((and (null live-receiver)
                (not (%same denotation-id (receiver-absence-declaration))))
           (%refuse :context :argument :receiver-absence-declaration-required
                    :reference reference :expected-role :receiver
                    :offending denotation-id
                    :detail "a receiver bound to NIL must carry exactly the package-owned ~
RECEIVER-ABSENCE-DECLARATION; absence is not the host's to name"))
          ((and live-receiver
                (%same denotation-id (receiver-absence-declaration)))
           (%refuse :context :argument :receiver-absence-declaration-misapplied
                    :reference reference :expected-role :receiver
                    :offending denotation-id
                    :detail "the receiver-absence declaration describes NIL and was ~
supplied for a live receiver")))
    context))

;;; ---- canonical declaration ordering --------------------------------------
;;;
;;; CONTEXT MAPPING ORDER IS NOT SEMANTICALLY CONSEQUENTIAL.  Two contexts
;;; holding the same declarations inserted in different orders declare the same
;;; thing, so they must carry the same declaration identity.  The insertion
;;; order is therefore CANONICALIZED AWAY before the identity is constructed.
;;;
;;; The order is: the four roles in their fixed sequence, and within a role the
;;; reference KEY ascending.  It is TOTAL: %BIND refuses a duplicate reference
;;; within a role, so no two bindings in one role share a key.

(defun %reference-key (reference)
  (lisp-plus-cd0:identifier-datum-path-segment reference 2))

(defun %canonical-role-bindings (context role)
  (sort (copy-list (%context-table context role))
        #'string<
        :key (lambda (binding) (%reference-key (%binding-reference binding)))))

(defun %declaration-payload (context)
  (%group
   (list (%phase-tag "context-declaration")
         (%group
          (loop for role in '(:schema :conclusion :support :receiver)
                append (loop for binding in (%canonical-role-bindings context role)
                             collect (%group (list (%text (symbol-name role))
                                                   (%binding-reference binding)
                                                   (%binding-denotation binding)))))))))

(defun seal-resolution-context (context occurrence-tag)
  "Seal the mapping and mint the context's two identities.  OCCURRENCE-TAG is
required and has no default.

WHAT EACH IDENTITY IS FOR.

  CONTEXT DECLARATION IDENTITY — content-derived from every binding's role,
  exact reference and exact denotation declaration, in canonical order.  Two
  contexts declaring the same thing carry the same declaration identity however
  their bindings were inserted.

  CONTEXT OCCURRENCE IDENTITY — the phase tag, the host-supplied occurrence tag,
  the declaration identity, and the context policy identity/version.  THE TAG
  ALONE IS NOT THE CONTEXT IDENTITY: two contexts with the same tag and
  different declarations have different occurrence identities.

WHAT NEITHER IDENTITY DOES.  Neither certifies the live objects bound inside
the context.  A host that supplies a TRUE reference, a TRUE declaration and a
DIFFERENT live anchor produces the same declaration identity and the same
occurrence identity, and Form /1 does not detect it and does not claim to.
That residual is exhibited, classified and named — see NC-31B."
  (unless (derivation-resolution-context-p context)
    (%refuse :context :species :not-a-resolution-context
             :host-type (%host-type-descriptor context)
             :detail "SEAL-RESOLUTION-CONTEXT takes a DERIVATION-RESOLUTION-CONTEXT"))
  (unless (and (lisp-plus-cd0:datum-p occurrence-tag)
               (lisp-plus-cd0:identifier-datum-p occurrence-tag))
    (%refuse :context :context :context-occurrence-tag-required
             :host-type (%host-type-descriptor occurrence-tag)
             :detail "a context occurrence tag is required and must be a CD/0 identifier datum"))
  (let* ((tag (%snapshot occurrence-tag))
         (declaration-identity (%gated-identity :context (%declaration-payload context)))
         (occurrence-identity
           (%gated-identity
            :context
            (%group (list (%phase-tag "context-occurrence")
                          tag
                          declaration-identity
                          (petition-policy-identity)
                          (%count (petition-policy-version)))))))
    (%make-context :schema (copy-list (%context-schema context))
                   :conclusion (copy-list (%context-conclusion context))
                   :support (copy-list (%context-support context))
                   :receiver (copy-list (%context-receiver context))
                   :sealed-p t
                   :occurrence-tag tag
                   :declaration-identity declaration-identity
                   :occurrence-identity occurrence-identity)))

(defun %resolve (context role reference)
  "Values: LIVE ANCHOR, FOUND-P.  A bound NIL is FOUND."
  (let ((binding (%find-binding (%context-table context role) reference)))
    (if binding (values (%binding-anchor binding) t) (values nil nil))))

;;; ------------------------------------------------------------------
;;; The submission receipt and the submission outcome.

(defstruct (petition-submission-receipt
            (:constructor %make-submission-receipt)
            (:conc-name %submission-receipt-)
            (:copier nil)
            (:predicate petition-submission-receipt-p))
  identity occurrence-identity petition-occurrence-identity
  context-occurrence-identity context-declaration-identity context-occurrence-tag
  context act-id by-id by
  outcome-kind slice2-receipt-identity-datum slice2-condition-class)

(defun petition-submission-receipt-identity (r) (%submission-receipt-identity r))
(defun petition-submission-receipt-occurrence-identity (r)
  (%submission-receipt-occurrence-identity r))
(defun petition-submission-receipt-petition-occurrence-identity (r)
  (%submission-receipt-petition-occurrence-identity r))
(defun petition-submission-receipt-context-occurrence-identity (r)
  "The CONTENT-DERIVED context occurrence identity — what the submission
occurrence identity actually commits to under policy v3."
  (%submission-receipt-context-occurrence-identity r))
(defun petition-submission-receipt-context-declaration-identity (r)
  "The context's DECLARATION identity, recorded separately so a reader can see
whether two submissions declared the same thing without recomputing it."
  (%submission-receipt-context-declaration-identity r))
(defun petition-submission-receipt-context-occurrence-tag (r)
  "The bare host-supplied tag, retained for diagnosis.  IT IS NOT AN IDENTITY."
  (%submission-receipt-context-occurrence-tag r))
(defun petition-submission-receipt-context (r)
  "The EXACT sealed context object — an IMAGE-LOCAL ANCHOR.  It is safe to hand
out because no public writer exists."
  (%submission-receipt-context r))
(defun petition-submission-receipt-act-id (r) (%submission-receipt-act-id r))
(defun petition-submission-receipt-by-id (r) (%submission-receipt-by-id r))
(defun petition-submission-receipt-by (r)
  "The EXACT live :BY value — an IMAGE-LOCAL ANCHOR.  BY-ID names the principal
the host supplied; it does not independently certify this value."
  (%submission-receipt-by r))
(defun petition-submission-receipt-outcome-kind (r) (%submission-receipt-outcome-kind r))
(defun petition-submission-receipt-slice2-receipt-identity-datum (r)
  "The COMPLETE Slice /2 receipt identity as immutable CD/0 data — domain and
name both — not a diagnostic key string.  NIL on the door-refusal path, where
no Slice /2 receipt exists at all.

Ceiling, stated rather than implied: this binds the exact identity Slice /2
minted.  That identity is an image-local ordinal name, which is a property of
Slice /2's naming and not a durability claim by Form /1."
  (%submission-receipt-slice2-receipt-identity-datum r))
(defun petition-submission-receipt-slice2-condition-class (r)
  "A FRESH string.  Mutable storage never leaves through a public reader."
  (let ((value (%submission-receipt-slice2-condition-class r)))
    (and value (copy-seq value))))
(defun petition-submission-receipt-procedure-identity (r)
  (declare (ignore r)) (petition-submission-procedure-identity))
(defun petition-submission-receipt-procedure-version (r)
  (declare (ignore r)) (petition-submission-procedure-version))

(defstruct (petition-submission-outcome
            (:constructor %make-outcome)
            (:conc-name %outcome-)
            (:copier nil)
            (:predicate petition-submission-outcome-p))
  kind claim slice2-receipt derivation-basis condition receipt)

(defun petition-submission-outcome-kind (o) (%outcome-kind o))
(defun petition-submission-outcome-claim (o) (%outcome-claim o))
(defun petition-submission-outcome-slice2-receipt (o) (%outcome-slice2-receipt o))
(defun petition-submission-outcome-derivation-basis (o) (%outcome-derivation-basis o))
(defun petition-submission-outcome-condition (o) (%outcome-condition o))
(defun petition-submission-outcome-receipt (o) (%outcome-receipt o))

;;; ------------------------------------------------------------------
;;; DOOR 2 — SUBMIT.

(defun %slice2-receipt-identity-datum (receipt)
  "The COMPLETE Slice /2 receipt identity, as CD/0 data.

LISP-PLUS-KERNEL0:IDENTITY->DATUM yields an identifier datum whose namespace is
(\"lisp-plus-kernel0\" \"identity\") and whose path is (DOMAIN-NAME
IDENTITY-NAME) — the exact identity, domain included, not a diagnostic key
string.  Two distinct Slice /2 receipt identities therefore yield two distinct
datums and cannot collide observationally.

The identity Slice /2 mints is itself an image-local ordinal name; that is a
fact about SLICE /2's naming, not about this binding, and it is stated rather
than folded into a claim about what Form /1 commits to."
  (when receipt
    (lisp-plus-kernel0:identity->datum
     (lisp-plus-slice2:slice2-receipt-identity receipt))))

(defun %finish-submission (occurrence petition context act-id by-id by
                           kind slice2-receipt condition claim basis)
  ;; TOTAL BY CONSTRUCTION.  This function runs only after DERIVE/2 has returned
  ;; or signalled a classified terminal outcome, and it contains NO gate, NO
  ;; ceiling and NO refusal path.  The envelope was reserved before invocation
  ;; (see SUBMIT-PETITION) precisely so that this construction cannot fail.
  (let* ((receipt-datum (%slice2-receipt-identity-datum slice2-receipt))
         (condition-class (when condition (%host-type-descriptor condition)))
         (receipt
           (%make-submission-receipt
            :identity
            (%identity
             (%group (list (%phase-tag "submission-receipt")
                           occurrence
                           (%text (symbol-name kind))
                           (or receipt-datum (%absent))
                           (if condition-class (%text condition-class) (%absent)))))
            :occurrence-identity occurrence
            :petition-occurrence-identity (%petition-occurrence-identity petition)
            :context-occurrence-identity (%context-occurrence-identity context)
            :context-declaration-identity (%context-declaration-identity context)
            :context-occurrence-tag (%context-occurrence-tag context)
            :context context
            :act-id act-id
            :by-id by-id
            :by by
            :outcome-kind kind
            :slice2-receipt-identity-datum receipt-datum
            :slice2-condition-class condition-class)))
    (%make-outcome :kind kind :claim claim :slice2-receipt slice2-receipt
                   :derivation-basis basis :condition condition :receipt receipt)))

(defun submit-petition (petition context &key by by-id act-id)
  "Submit PETITION under the sealed CONTEXT.  The host calls this explicitly;
there is no path from Door 1 to here.

:BY is the exact live value handed to public DERIVE/2.  :BY-ID names that
principal in the Form /1 record.  :ACT-ID names this submission act.  ALL THREE
ARE REQUIRED AND NONE HAS A DEFAULT — DERIVE/2's own NIL -> :DERIVER default is
deliberately NOT inherited, because a form that could leave the asserting
principal unstated would let a question quietly answer in nobody's name.

ONLY the two exact Slice /2 classes are caught.  Everything else ESCAPES."
  (unless (derivation-petition-p petition)
    (%refuse :submit :species :not-a-derivation-petition
             :host-type (%host-type-descriptor petition)
             :detail "SUBMIT-PETITION takes a DERIVATION-PETITION"))
  (unless (derivation-resolution-context-p context)
    (%refuse :submit :species :not-a-resolution-context
             :host-type (%host-type-descriptor context)
             :detail "SUBMIT-PETITION takes a DERIVATION-RESOLUTION-CONTEXT"))
  (unless (%context-sealed-p context)
    (%refuse :submit :context :context-not-sealed
             :detail "an unsealed context cannot be submitted with"))
  (unless by
    (%refuse :submit :argument :by-required
             :detail "an asserting principal is required; no default is inherited"))
  (unless (and (lisp-plus-cd0:datum-p by-id)
               (lisp-plus-cd0:identifier-datum-p by-id))
    (%refuse :submit :argument :by-id-required
             :host-type (%host-type-descriptor by-id)
             :detail ":BY-ID is required and must be a CD/0 identifier datum"))
  (unless (and (lisp-plus-cd0:datum-p act-id)
               (lisp-plus-cd0:identifier-datum-p act-id))
    (%refuse :submit :argument :act-id-required
             :host-type (%host-type-descriptor act-id)
             :detail ":ACT-ID is required and must be a CD/0 identifier datum"))
  ;; The petition must still recompute.  Caller mutation after materialization
  ;; is inert; a petition that does not recompute is not this petition.
  (let ((recomputed
          (%identity (%group (list (%phase-tag "petition-occurrence")
                                   (%petition-content-identity petition)
                                   (%petition-occurrence-tag petition))))))
    (unless (%same recomputed (%petition-occurrence-identity petition))
      (%refuse :submit :identity :petition-identity-drift
               :detail "the petition no longer recomputes to its recorded occurrence identity")))
  ;; THE SUBMISSION OCCURRENCE IDENTITY IS FIXED HERE — BEFORE ANY INVOCATION.
  ;; It commits to the ACT and to nothing the act produces.  The act and its
  ;; later account are different facts.
  ;;
  ;; POLICY v3: it commits to the CONTEXT OCCURRENCE IDENTITY, not to the bare
  ;; host-supplied context tag.  That identity commits transitively to the
  ;; context DECLARATION identity, which commits to every binding's role, exact
  ;; reference and exact denotation declaration.  Under v2 this position held
  ;; the tag alone, and two submissions declaring different things could carry
  ;; the same submission occurrence identity.
  (let ((occurrence
          (%gated-identity
           :submit
           (%group (list (%phase-tag "submission-occurrence")
                         (%petition-occurrence-identity petition)
                         (%context-occurrence-identity context)
                         (%snapshot act-id)
                         (%snapshot by-id)
                         (petition-submission-procedure-identity)
                         (%count (petition-submission-procedure-version)))))))
    ;; THE TERMINAL ENVELOPE IS A BUILD GATE, NOT A POST-ACT REFUSAL.
    ;; The receipt identity adds a bounded tail to this occurrence identity.
    ;; Reserving that tail HERE — before any invocation — is what makes the
    ;; classified receipt provably constructible afterwards.  Policy v1 checked
    ;; the terminal size after the governed act and could therefore erase it.
    (when (> (+ (identity-octets occurrence)
                (petition-policy-outcome-tail-reserve-octets))
             (petition-policy-max-identity-octets))
      (%refuse :submit :policy :submission-envelope-exceeded
               :detail (format nil "submission occurrence identity is ~D octets ~
and the reserved outcome tail is ~D; together they exceed the Candidate /0 ~
envelope of ~D octets. DERIVE/2 is NOT invoked."
                               (identity-octets occurrence)
                               (petition-policy-outcome-tail-reserve-octets)
                               (petition-policy-max-identity-octets))))
    ;; Resolution.  Names to objects, and nothing else.
    (multiple-value-bind (schema found) (%resolve context :schema
                                                  (%petition-schema-ref petition))
      (unless found
        (%refuse :submit :context :unresolved-schema-reference
                 :reference (%petition-schema-ref petition) :expected-role :schema
                 :detail "no schema is bound to this reference in this sealed context"))
      (multiple-value-bind (conclusion c-found)
          (%resolve context :conclusion (%petition-conclusion-ref petition))
        (unless c-found
          (%refuse :submit :context :unresolved-conclusion-reference
                   :reference (%petition-conclusion-ref petition) :expected-role :conclusion
                   :detail "no conclusion is bound to this reference in this sealed context"))
        (let ((supports
                (loop for reference in (%petition-support-refs petition)
                      collect (multiple-value-bind (value s-found)
                                  (%resolve context :support reference)
                                (unless s-found
                                  (%refuse :submit :context :unresolved-support-reference
                                           :reference reference :expected-role :support
                                           :detail "no support is bound to this reference in this sealed context"))
                                value))))
          (multiple-value-bind (receiver r-found)
              (%resolve context :receiver (%petition-receiver-ref petition))
            (unless r-found
              (%refuse :submit :context :unresolved-receiver-reference
                       :reference (%petition-receiver-ref petition) :expected-role :receiver
                       :detail "no receiver is bound to this reference in this sealed context"))
            ;; INVOCATION.  Public DERIVE/2, resolved objects in their exact
            ;; argument positions, nothing filtered, nothing pre-classified.
            (handler-case
                (multiple-value-bind (claim slice2-receipt basis)
                    (lisp-plus-slice2:derive/2 :schema schema
                                               :conclusion conclusion
                                               :supports supports
                                               :receiver receiver
                                               :by by)
                  (%finish-submission occurrence petition context act-id by-id by
                                      :granted slice2-receipt nil claim basis))
              (lisp-plus-slice2:slice2-derivation-refused (condition)
                (%finish-submission occurrence petition context act-id by-id by
                                    :governed-refusal
                                    (lisp-plus-slice2:slice2-condition-receipt condition)
                                    condition nil nil))
              (lisp-plus-slice2:slice2-schema-error (condition)
                (%finish-submission occurrence petition context act-id by-id by
                                    :door-refusal
                                    (lisp-plus-slice2:slice2-condition-receipt condition)
                                    condition nil nil)))))))))

(defun try-submit-petition (petition context &key by by-id act-id)
  "(values OUTCOME nil) for a classified Slice /2 terminal outcome;
(values nil REFUSAL) for a Form /1 protocol refusal BEFORE invocation.
An unexpected condition ESCAPES, and leaves no semantic object behind."
  (%retain-1
    (submit-petition petition context :by by :by-id by-id :act-id act-id)))

;;; ------------------------------------------------------------------
;;; THE TWO INSPECTION SURFACES, defined last so their contracts are unmissable.
;;;
;;;     REFERENCE RESOLUTION IS NOT EVIDENCE ADMISSION.
;;;     A DENOTATION DECLARATION IS NOT CERTIFICATION OF ITS LIVE ANCHOR.
;;;
;;; The v2 reader returned role and reference and DROPPED the bound value, so a
;;; sealed context's contents were unauditable: you could enumerate WHICH
;;; references were bound, never TO WHAT.  Dropping the value was right — the
;;; live object must not be aliased out of an aggregate — but the answer to
;;; "right to drop" is not "record nothing", it is RECORD THE DECLARATION.
;;;
;;; So there are now two surfaces, and they are different in kind:
;;;
;;;   A. DURABLE BINDING DECLARATIONS — fresh immutable records over immutable
;;;      CD/0 data.  Safe as an aggregate.  This is what identity commits to.
;;;   B. IMAGE-LOCAL BOUND ANCHORS — the exact live object, reachable ONLY by an
;;;      exact role/reference lookup, one at a time.  No internal alist and no
;;;      mutable table ever leaves this package.
;;;
;;; NEITHER SURFACE mints standing, admits evidence, installs an operator,
;;; performs ambient lookup, or changes the mapping.  Inspection is inspection.

(defun %require-context (context)
  (unless (derivation-resolution-context-p context)
    (%refuse :context :species :not-a-resolution-context
             :host-type (%host-type-descriptor context)
             :detail "not a DERIVATION-RESOLUTION-CONTEXT"))
  context)

(defun derivation-resolution-context-declarations (context)
  "SURFACE A — the DURABLE binding declarations.

A FRESH list of FRESH immutable CONTEXT-BINDING-DECLARATION records, in the
canonical declaration order, each holding role, exact reference and exact
denotation declaration.  All three are immutable CD/0 data or a keyword; no
live host object is reachable through this reader.

THIS IS WHAT THE CONTEXT DECLARATION IDENTITY COMMITS TO.  A reader can
recompute nothing from it about the live anchors, and is not meant to."
  (%require-context context)
  (loop for role in '(:schema :conclusion :support :receiver)
        append (loop for binding in (%canonical-role-bindings context role)
                     collect (%make-declaration
                              :role role
                              :reference (%binding-reference binding)
                              :denotation (%binding-denotation binding)))))

(defun derivation-resolution-context-live-anchor (context role reference)
  "SURFACE B — the IMAGE-LOCAL BOUND ANCHOR.
  Values: ANCHOR, FOUND-P.  A bound NIL is FOUND, and is not `absent'.

IT RETURNS THE EXACT LIVE OBJECT, and that object is an ANCHOR: image-local,
not durable, not immutable, and NOT certified by its declaration.  The host
asserted what this denotes; Form /1 recorded the assertion and resolved the
name.  Nothing here checks that the assertion is true.

AN EXACT ROLE AND REFERENCE ARE REQUIRED.  There is no aggregate form of this
reader, because an aggregate would hand a caller a container holding every live
object at once — which is how a mutable table escapes a sealed context."
  (%require-context context)
  (unless (member role '(:schema :conclusion :support :receiver))
    (%refuse :context :argument :unknown-binding-role
             :expected-role role
             :detail "role must be one of :SCHEMA :CONCLUSION :SUPPORT :RECEIVER"))
  (let ((actual (reference-role reference)))
    (unless actual
      (%refuse :context :grammar :malformed-reference
               :offending (when (lisp-plus-cd0:datum-p reference) reference)
               :host-type (unless (lisp-plus-cd0:datum-p reference)
                            (%host-type-descriptor reference))
               :expected-role role
               :detail "this reader takes a Form /1 role-tagged reference"))
    (unless (eq actual role)
      (%refuse :context :context :binding-role-mismatch
               :reference reference :expected-role role
               :detail (format nil "this lookup names role ~A; the reference bears role ~A"
                               role actual))))
  (%resolve context role reference))
