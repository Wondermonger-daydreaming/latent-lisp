;;;; APPLICATION.lisp — de forma petente: concerning the petitioning form.
;;;;
;;;; Run: sbcl --non-interactive --load APPLICATION.lisp
;;;;
;;;; An inhabited Language Form /1, Candidate /0 program, under POLICY v2.  A
;;;; reading-room desk writes four petitions by hand, walks each as far as the
;;;; law allows, and keeps the whole genealogy — including the genealogy of the
;;;; ones that never reach the governed operation, and the one that reaches it
;;;; and is told no.
;;;;
;;;; WHAT THIS PROGRAM DOES NOT SHOW.  Read this first, because it is the part a
;;;; reader is most likely to supply for himself if nobody says it.
;;;;
;;;;   • This is a SCRIPTED FIXTURE.  No model is called.  No provider is
;;;;     reached.  Every datum below was written by hand, in this file, by the
;;;;     same model family that wrote the layer and its checks.  Nothing here is
;;;;     evidence that any external process emitted a petition, or could.
;;;;   • A PETITION IS NOT A CLAIM.  It is not a basis, not a capability, not an
;;;;     authority, not a granted derivation, not an executable closure.  It is a
;;;;     well-formed question.  Four numbered candidates are asked here and
;;;;     several more arms after them; every yes came from the governed
;;;;     operation and from nowhere else, and the tally is COUNTED at the foot of
;;;;     this program rather than asserted here.
;;;;   • Every green line below is SELF-CONSISTENCY CERTIFICATION.  It says the
;;;;     layer does what the layer says it does.  It says nothing about whether
;;;;     the layer should exist.  Form /1 remains a candidate; `specification-
;;;;     frozen: no`, `adopted: no`, and the stranger audit is OWED and is not
;;;;     pre-satisfied by Form /0's.
;;;;
;;;; WHAT IT DOES SHOW.
;;;;
;;;;   • Two doors, each refusing the other's traffic, neither carrying a copy of
;;;;     the other's grammar: Form /1 refuses a Form /0-shaped call, and FORM /0
;;;;     ITSELF — loaded separately, speaking in its own refusal objects —
;;;;     refuses both that call and a lawful Form /1 petition.
;;;;   • The line between a Form /1 REFUSAL and a GOVERNED REFUSAL.  When the
;;;;     references do not resolve, Form /1 says no and DERIVE/2 is never
;;;;     invoked and no submission receipt exists.  When they do resolve, Form /1
;;;;     stands aside: the governed operation decides, and if it decides no, that
;;;;     is a full record with a receipt and nothing minted.
;;;;   • That the machinery running is not the same event as something being
;;;;     produced.  Candidate C is the centre of the specimen for exactly that
;;;;     reason.
;;;;   • Two honest limitations, exhibited rather than papered over: a context
;;;;     occurrence id and a submission act id are HOST-SUPPLIED NAMES, and two
;;;;     different acts given one name collide in the record with no complaint.
;;;;
;;;; ON AUTHORITY BETWEEN THE DOCUMENTS.  Where LANGUAGE-FORM-1-WORK-ORDER.md and
;;;; form1.lisp disagree, FORM1.LISP GOVERNS, and this program is written against
;;;; the implementation.  Two live disagreements were found while writing it:
;;;;   (1) the work order's §11 refusal catalogue lists a validate-phase
;;;;       `:identity-length-exceeded`; the implementation has no such code and
;;;;       refuses with `:identity-octets-exceeded` (policy v2 measures OCTETS of
;;;;       the identity value, never display characters);
;;;;   (2) the work order's EG-4 speaks of a terminal ceiling in CHARACTERS
;;;;       (131,072); the implementation's envelope is 65,536 OCTETS, adjudicated
;;;;       by measurement in EG4-IDENTITY-VALUE-MEASUREMENT.lisp after the
;;;;       representation existed.
;;;; Neither disagreement is exercised below; both are noted so a later reader
;;;; does not take the older text for the law.

;;; ── LOADING ───────────────────────────────────────────────────────────────
;;; Form /1 first: it brings Slice /2, Slice /1, Slice /0, Core /0, Kernel /0 and
;;; Canonical Datum /0 with it.  Form /0 is loaded SEPARATELY and afterwards, and
;;; for exactly one purpose: so that the neighbour can refuse in its own voice
;;; instead of Form /1 impersonating it.  Nothing in form1.lisp names Form /0;
;;; this file does, and it is not form1.lisp.

(unless (find-package :lisp-plus-form1)
  (handler-bind ((style-warning #'muffle-warning))
    (load (merge-pathnames "../form1.lisp" *load-truename*))))

(unless (find-package :lisp-plus-form0)
  (handler-bind ((style-warning #'muffle-warning))
    (load (merge-pathnames "../../language-form-0/form0.lisp" *load-truename*))))

(defpackage #:de-forma-petente (:use #:cl #:lisp-plus-form1))
(in-package #:de-forma-petente)

(defmacro cd0 (name &rest arguments)
  `(,(intern (string name) :lisp-plus-cd0) ,@arguments))

;;; ══════════════════════════════════════════════════════════════════
;;; The desk's instruments.

(defparameter *checks* 0)
(defparameter *failed* 0)

(defun desk (control &rest arguments)
  (format t "  ~A~%" (apply #'format nil control arguments)))

(defun section (title)
  (format t "~%── ~A~%" title))

(defun check (condition label)
  (incf *checks*)
  (if condition
      (format t "  [~2,'0D] ok   ~A~%" *checks* label)
      (progn (incf *failed*)
             (format t "  [~2,'0D] FAIL ~A~%" *checks* label))))

;;; ── The length-bearing short form ─────────────────────────────────
;;;
;;; POLICY v2 IDENTITIES ARE CD/0 BYTE-STRING DATA, not host strings and not
;;; hexadecimal.  They are compared with LISP-PLUS-CD0:EQUAL-DATUM and NOWHERE
;;; ELSE in this file.  RENDER-IDENTITY-HEX is DIAGNOSTIC: it exists so a human
;;; can tell two of them apart on a page, and its output never re-enters an
;;; identity.
;;;
;;; The abbreviation is not a digest and must never be called one — CD/0 supplies
;;; no hash, and an identity here CONTAINS what it identifies rather than
;;; fingerprinting it.  It is two truncation windows and a length, and nothing
;;; is computed over the characters in between.
;;;
;;; WHY IT IS SHAPED THE WAY IT IS, AND WHY IT IS THIS WIDE.  Four facts, each
;;; MEASURED on this program's own data by watching the final check fail, never
;;; assumed:
;;;
;;;   (1) A SHORT PREFIX IS NEARLY A CONSTANT.  Every CD/0 canonical encoding
;;;       opens with the same magic and framing.  The Form /0 stranger audit
;;;       measured naive sixteen-character prefixes colliding on live data; here
;;;       the first ten characters are identical across the whole census.
;;;   (2) BUT THE PHASE TAG IS JUST BEHIND IT.  Every identity payload in this
;;;       layer opens with a phase-tag identifier — "proposed", "validated",
;;;       "petition-content", "submission-receipt" and so on.  That is the most
;;;       informative thing an abbreviation can carry, and it lies inside the
;;;       first ninety-six characters.  A twelve-character head missed it, and a
;;;       validation receipt collided with a petition-content identity of the
;;;       same length.
;;;   (3) A SHORT SUFFIX IS ALSO NEARLY A CONSTANT — the trap that fired first.
;;;       A submission identity ends with the principal id, the procedure
;;;       identity and the procedure version, and those are the SAME for every
;;;       act in this program.  A ten-character tail collapsed five distinct
;;;       identities into three; the varying fields — the context occurrence id
;;;       and the act id — sit just INSIDE that constant suffix, ending about
;;;       139 hexadecimal characters from the end.
;;;   (4) THE CHAIN IS APPEND-STRUCTURED.  Each phase identity wraps its
;;;       predecessor whole and adds its new fields after it, so the newest and
;;;       most discriminating content is always near the end.  A tail window is
;;;       the right shape — it just has to reach PAST the constant field-suffix.
;;;
;;; Hence a ninety-six-character head, a hundred-and-sixty-character tail, and
;;; the length.  It is wide on the page and that is the correct trade: the work
;;; order asks for exact identities and NO AMBIGUOUS TRUNCATION, and a tidy
;;; abbreviation that silently merges two records is worse than a wide one that
;;; does not.  And because an abbreviation nobody has tested is a diagnostic that
;;; can lie, the last check in this program asserts — over every identity it
;;; actually printed, not a curated subset — that the abbreviations discriminate
;;; exactly as the full identities do.  If a later edit introduces identities
;;; that differ only further from the end, that check fails loudly rather than
;;; misinforming a reader.  It has already failed twice, and both windows above
;;; are what it bought.

(defparameter +short-head+ 96)
;; REVIEW 1 MEASUREMENT: 160 -> 512.  Under policy v3 a submission identity
;; embeds the context OCCURRENCE identity, which embeds the context DECLARATION
;; identity — so the octets that distinguish two acts moved INTO THE MIDDLE of
;; the encoding, out of reach of a 160-char tail.  Three of this corpus's 53
;; distinct identities collided in the short form at 160.  The value below is
;; the minimum found by the ascending search printed under "the abbreviations,
;; tested"; it is a measurement, not a guess, and the search runs every time so
;; the constant cannot go quietly stale as the corpus grows.
(defparameter +short-tail+ 512)

(defun short (identity)
  (let* ((hex (render-identity-hex identity))
         (n (length hex)))
    (if (<= n (+ +short-head+ +short-tail+))
        (format nil "~A/~D" hex n)
        (format nil "~A…~A/~D"
                (subseq hex 0 +short-head+)
                (subseq hex (- n +short-tail+))
                n))))

(defparameter *census* '()
  "Every identity this program PRINTS, labelled.  The final check is taken over
exactly this list — not over a curated selection of well-behaved ones.")

(defun id! (label identity)
  "Register IDENTITY in the census and return its printable short form."
  (push (cons label identity) *census*)
  (short identity))

(defun same-id (left right)
  (cd0 equal-datum left right))

;;; ── Reading a Slice /2 receipt's image-local ordinal ───────────────
;;; Used ONLY by the candidate-B probe below.  A Slice /2 receipt identity is an
;;; image-local ordinal NAME — that is a property of Slice /2's naming, not a
;;; durability claim by anyone, and it is read here as an instrument, never
;;; recorded as though it were durable.

(defun slice2-ordinal (receipt)
  (let ((name (lisp-plus-kernel0:durable-identity-name
               (lisp-plus-slice2:slice2-receipt-identity receipt))))
    (parse-integer name :start (1+ (position #\- name :from-end t)))))

;;; ══════════════════════════════════════════════════════════════════
;;; THE FIXTURE — a reading-room desk with one governed question.
;;;
;;; One premise, discharged by an asserted witness of an exact mode and kind, so
;;; that candidate C can supply a witness of the RIGHT species, mode and kind
;;; concerning the WRONG subject.  A fixture that got the species wrong would
;;; test the classifier and not the premise, and the premise is the point.

(defun np (form) (lisp-plus-slice1:proposition form))
(defun pp (form) (lisp-plus-slice1:proposition-pattern form))

(defun install-schema ()
  (lisp-plus-slice1:clear-schema-registry)
  (lisp-plus-slice1:register-schema
   (lisp-plus-slice1:judgment-schema
    :name :volume-may-be-issued :version 1
    :conclusion (pp '(:predicate :volume-may-be-issued (:volume (:var :volume))))
    :premises (list (pp '(:predicate :volume-cleared-by-conservator
                          (:volume (:var :volume))))))))

(defun clearance-contract (accessibility contract-id)
  ":RECEIVER-ACCESSIBILITY is chosen DELIBERATELY at every construction (§7.5-1);
the constructor's own default is :REQUIRED, and a default silently inherited is
a decision nobody made."
  (lisp-plus-slice2:make-support-admission-contract
   :contract-id contract-id
   :receiver-accessibility accessibility
   :accepted-clauses '((:asserted-witness :mode :direct
                        :kind :conservator-inspection
                        :truth-ceiling :asserted))))

(defun wrapper (accessibility contract-id)
  "Built over what RESOLVE-SCHEMA returns, never over a locally kept handle
(§7.5-2): DERIVE/2 compares the registered schema with EQ, and a wrapper built
over a handle that is no longer the registered object refuses at its own door."
  (lisp-plus-slice2:make-slice2-schema
   :schema-id :volume-may-be-issued/2
   :base-schema (lisp-plus-slice1:resolve-schema :volume-may-be-issued 1)
   :premise-contracts (list (list 0 (clearance-contract accessibility contract-id)))))

(defun clearance-witness (volume)
  (lisp-plus-slice0:witness
   :for (np `(:predicate :volume-cleared-by-conservator (:volume ,volume)))
   :mode :direct :kind :conservator-inspection :source :conservator))

(defun reading-room (witnesses)
  (lisp-plus-slice0:receiver-context
   :context-id :reading-room
   :accessible-supports (mapcar #'lisp-plus-slice0:witness-id witnesses)))

(defun tag (&rest path)
  (cd0 make-identifier-datum '("de-forma-petente") path))

(install-schema)

(defparameter *conclusion*
  (np '(:predicate :volume-may-be-issued (:volume "PLUT-7"))))

(defparameter *required-wrapper* (wrapper :required :clearance-receiver-required))
(defparameter *optional-wrapper* (wrapper :optional :clearance-receiver-optional))

;;; ══════════════════════════════════════════════════════════════════
;;; Writing a petition by hand, and walking it.

(defun petition-datum-of (&key (schema-key "s") (conclusion-key "c")
                               (support-keys '("clearance")) (receiver-key "r"))
  (petition-datum :schema (schema-reference schema-key)
                  :conclusion (conclusion-reference conclusion-key)
                  :supports (mapcar #'support-reference support-keys)
                  :receiver (receiver-reference receiver-key)))

(defstruct genealogy
  name datum
  (proposed nil) (propose-refusal nil)
  (validated nil) (validate-refusal nil)
  (petition nil) (materialization nil) (materialize-refusal nil)
  (outcome nil) (submit-refusal nil))

(defun hold (name datum occurrence-tag)
  "Walk DATUM through the three phases and materialization, retaining every
refusal as an object.  Nothing is resolved here and nothing is submitted:
MATERIALIZE-PETITION takes no resolution context and is therefore structurally
incapable of reaching DERIVE/2."
  (let ((row (make-genealogy :name name :datum datum)))
    (multiple-value-bind (proposed refusal) (try-propose-petition datum)
      (setf (genealogy-proposed row) proposed
            (genealogy-propose-refusal row) refusal)
      (when proposed
        (multiple-value-bind (validated refusal) (try-validate-petition proposed)
          (setf (genealogy-validated row) validated
                (genealogy-validate-refusal row) refusal)
          (when validated
            (multiple-value-bind (petition receipt refusal)
                (try-materialize-petition validated occurrence-tag)
              (setf (genealogy-petition row) petition
                    (genealogy-materialization row) receipt
                    (genealogy-materialize-refusal row) refusal))))))
    row))

;;; Tallies, so the closing paragraph can COUNT rather than estimate.  Every
;;; submission this program performs passes through here, including the four
;;; control derivations used by the candidate-B probe.

(defparameter *granted* 0)
(defparameter *governed-refusals* 0)
(defparameter *form1-refusals* 0)
(defparameter *submission-log* '()
  "One (OUTCOME . REFUSAL) cell per submission this program performed.")

(defun submit-into (row context &key act by-id (by :reading-room-clerk))
  (multiple-value-bind (outcome refusal)
      (try-submit-petition (genealogy-petition row) context
                           :by by :by-id by-id :act-id act)
    (setf (genealogy-outcome row) outcome
          (genealogy-submit-refusal row) refusal)
    (push (cons outcome refusal) *submission-log*)
    (cond (refusal (incf *form1-refusals*))
          ((eq :granted (petition-submission-outcome-kind outcome)) (incf *granted*))
          (t (incf *governed-refusals*)))
    row))

(defun print-refusal (label refusal)
  (format t "    ~18A REFUSED  ~A / ~A / ~A~%" label
          (petition-refusal-phase refusal)
          (petition-refusal-category refusal)
          (petition-refusal-code refusal))
  (format t "    ~18A          ~A~%" "" (petition-refusal-detail refusal))
  (format t "    ~18A          refusal identity ~A~%" ""
          (id! (list label :refusal) (petition-refusal-identity refusal))))

(defun print-genealogy (row)
  (format t "  candidate ~S~%" (genealogy-name row))
  (let ((proposed (genealogy-proposed row))
        (validated (genealogy-validated row))
        (petition (genealogy-petition row))
        (materialization (genealogy-materialization row))
        (outcome (genealogy-outcome row))
        (name (genealogy-name row)))
    (if (genealogy-propose-refusal row)
        (print-refusal "proposed" (genealogy-propose-refusal row))
        (progn
          (format t "    ~18A ~A~%" "subject"
                  (id! (list name :subject)
                       (proposed-petition-form-subject-identity proposed)))
          (format t "    ~18A ~A~%" "proposed"
                  (id! (list name :proposed)
                       (proposed-petition-form-identity proposed)))))
    (when validated
      (format t "    ~18A ~A~%" "validated"
              (id! (list name :validated) (validated-petition-form-identity validated)))
      (format t "    ~18A ~A~%" "validation receipt"
              (id! (list name :validation-receipt)
                   (petition-validation-receipt-identity
                    (validated-petition-form-receipt validated)))))
    (when petition
      (format t "    ~18A ~A~%" "petition content"
              (id! (list name :content) (derivation-petition-content-identity petition)))
      (format t "    ~18A ~A~%" "petition occurrence"
              (id! (list name :occurrence)
                   (derivation-petition-occurrence-identity petition)))
      (format t "    ~18A ~A~%" "materialization"
              (id! (list name :materialization)
                   (petition-materialization-receipt-identity materialization))))
    (cond
      ((genealogy-submit-refusal row)
       (print-refusal "submission" (genealogy-submit-refusal row)))
      (outcome
       (let ((receipt (petition-submission-outcome-receipt outcome)))
         (format t "    ~18A ~A~%" "submission occ."
                 (id! (list name :submission-occurrence)
                      (petition-submission-receipt-occurrence-identity receipt)))
         (format t "    ~18A ~A~%" "submission receipt"
                 (id! (list name :submission-receipt)
                      (petition-submission-receipt-identity receipt)))
         (format t "    ~18A ~A~%" "outcome kind"
                 (petition-submission-outcome-kind outcome))))
      (t (format t "    ~18A not reached~%" "submission")))))

;;; ══════════════════════════════════════════════════════════════════

(format t "~%════════════════════════════════════════════════════════════════~%")
(format t "  de forma petente — an inhabited Language Form /1 program~%")
(format t "════════════════════════════════════════════════════════════════~%")
(desk "A scripted fixture.  No model was called; no provider was reached.")
(desk "A petition is a well-formed question, never a granted answer.")

(section "the layer's own declared ceilings, read from the implementation")
(desk "grammar   ~A v~D"
      (cd0 render-diagnostic (petition-grammar-identity)) (petition-grammar-version))
(desk "policy    ~A v~D"
      (cd0 render-diagnostic (petition-policy-identity)) (petition-policy-version))
(desk "procedure ~A v~D"
      (cd0 render-diagnostic (petition-submission-procedure-identity))
      (petition-submission-procedure-version))
(desk "head      ~A" (cd0 render-diagnostic (petition-head-identifier)))
(desk "ceilings  ~D support refs · ~D petition octets · ~D identity octets · ~D reserved tail"
      (petition-policy-max-support-references)
      (petition-policy-max-canonical-octets)
      (petition-policy-max-identity-octets)
      (petition-policy-outcome-tail-reserve-octets))
(check (= 3 (petition-policy-version))
       "the implementation is POLICY v3 — identity value OCTETS (v2), and every context binding carries a DENOTATION DECLARATION the context identity commits to (v3)")

;;; ══════════════════════════════════════════════════════════════════
;;; CANDIDATE A — a datum that is not a petition.

(section "candidate A — a datum that is not a petition")
(desk "A is the LAWFUL petition body under a FOREIGN HEAD.  One element differs")
(desk "between A and candidate D: the head.  So the refusal is about the head")
(desk "and nothing else, and the node has TWO elements — it reaches the head")
(desk "check rather than failing on arity first.")

(defparameter *lawful-datum* (petition-datum-of))

(defparameter *foreign-head*
  ;; Built with FORM /0's OWN constructor, so the shape is the neighbour's fact
  ;; and not a Form /1 guess about the neighbour.
  (lisp-plus-form0:operator-identifier "derive/2"))

(defparameter *candidate-a-datum*
  (cd0 make-sequence-datum
       (list *foreign-head* (cd0 sequence-datum-ref *lawful-datum* 1))))

(defparameter *a* (hold :a *candidate-a-datum* (tag "occ" "a")))
(print-genealogy *a*)

(check (null (genealogy-proposed *a*))
       "A never became a proposed petition")
(check (and (genealogy-propose-refusal *a*)
            (eq :not-a-derivation-petition
                (petition-refusal-code (genealogy-propose-refusal *a*)))
            (eq :propose (petition-refusal-phase (genealogy-propose-refusal *a*)))
            (eq :grammar (petition-refusal-category (genealogy-propose-refusal *a*))))
       "Form /1 refused A at :PROPOSE / :GRAMMAR / :NOT-A-DERIVATION-PETITION")
(check (equal '(0) (petition-refusal-path (genealogy-propose-refusal *a*)))
       "the refusal path names element 0 — the head, not the arity and not the body")
(check (same-id (petition-refusal-offending (genealogy-propose-refusal *a*))
                *foreign-head*)
       "the offending datum retained inside the refusal IS the foreign head")
(check (= 2 (cd0 sequence-datum-length *candidate-a-datum*))
       "A is a two-element node, so the head check is what fired")
(check (same-id (cd0 sequence-datum-ref *candidate-a-datum* 1)
                (cd0 sequence-datum-ref *lawful-datum* 1))
       "A and the lawful petition share their body datum exactly")
(check (same-id *foreign-head*
                (cd0 make-identifier-datum '("lisp-plus-form0" "op") '("derive/2")))
       "the foreign head is namespace (lisp-plus-form0 op), path (derive/2)")

;;; ── The neighbour, in its own voice ───────────────────────────────
(section "the same datum, handed to FORM /0 — the neighbour refuses in its own voice")
(desk "Form /1 does not own a copy of Form /0's grammar and does not say")
(desk "\"that is a Form /0 head\".  The desk asks Form /0 instead.  Form /0 needs")
(desk "a sealed environment before it will admit anything, so the desk builds one:")
(desk "its own name and version, the four built-in operator names, no holes.")

(defparameter *neighbour-desk*
  (lisp-plus-form0:seal-form-environment
   (lisp-plus-form0:make-form-environment
    :name "de-forma-petente-neighbour" :version 1
    :operators (lisp-plus-form0:operator-names)
    :holes '())))

(check (lisp-plus-form0:form-environment-sealed-p *neighbour-desk*)
       "the neighbour's environment is sealed before either datum arrives")

(defun ask-form0 (label datum)
  (multiple-value-bind (proposal refusal)
      (lisp-plus-form0:try-propose-form datum *neighbour-desk*)
    (cond
      (refusal
       (format t "    ~26A REFUSED  ~A / ~A  at path ~S~%" label
               (lisp-plus-form0:form-refusal-category refusal)
               (lisp-plus-form0:form-refusal-code refusal)
               (lisp-plus-form0:form-refusal-path refusal))
       (format t "    ~26A          ~A~%" ""
               (lisp-plus-form0:form-refusal-detail refusal))
       refusal)
      (t (format t "    ~26A ADMITTED (~S)~%" label proposal) nil))))

(defparameter *f0-on-a* (ask-form0 "candidate A's datum" *candidate-a-datum*))
(defparameter *f0-on-petition* (ask-form0 "a LAWFUL Form /1 petition" *lawful-datum*))

(check (and *f0-on-a*
            (member (lisp-plus-form0:form-refusal-code *f0-on-a*)
                    (lisp-plus-form0:form-refusal-codes)))
       "Form /0 refused candidate A's datum, with a code from its OWN catalogue")
(check (and *f0-on-petition*
            (eq :unknown-production
                (lisp-plus-form0:form-refusal-code *f0-on-petition*)))
       "Form /0 refuses a lawful Form /1 petition as :UNKNOWN-PRODUCTION")
(check (and *f0-on-a* *f0-on-petition*
            (eq (lisp-plus-form0:form-refusal-code *f0-on-a*)
                (lisp-plus-form0:form-refusal-code *f0-on-petition*))
            (not (equal (lisp-plus-form0:form-refusal-path *f0-on-a*)
                        (lisp-plus-form0:form-refusal-path *f0-on-petition*))))
       "one Form /0 CODE covers two structurally different failures — only the paths differ")
(desk "That last line is the reason form1.lisp declines to inherit the neighbour's")
(desk "code vocabulary: a reader holding only :UNKNOWN-PRODUCTION cannot tell")
(desk "\"this head heads no production\" from \"a record datum heads nothing here\".")
(desk "Form /1 spends one code per distinct condition instead.")

;;; ── The same Form /1 code at two different doors ──────────────────
(section "one Form /1 code, two doors — the phase and the category discriminate")

(defparameter *submit-species-refusal*
  (multiple-value-bind (outcome refusal)
      (try-submit-petition :not-a-petition-at-all
                           (seal-resolution-context
                            (make-derivation-resolution-context) (tag "ctx" "species"))
                           :by :reading-room-clerk
                           :by-id (tag "by" "clerk") :act-id (tag "act" "species"))
    (declare (ignore outcome))
    refusal))

(print-refusal "submit species" *submit-species-refusal*)
(check (and (eq :not-a-derivation-petition
               (petition-refusal-code *submit-species-refusal*))
            (eq :submit (petition-refusal-phase *submit-species-refusal*))
            (eq :species (petition-refusal-category *submit-species-refusal*)))
       "the code :NOT-A-DERIVATION-PETITION also fires at :SUBMIT / :SPECIES")
(check (not (eq (petition-refusal-phase (genealogy-propose-refusal *a*))
                (petition-refusal-phase *submit-species-refusal*)))
       "the CODE alone does not discriminate; the (phase category code) triple does")

;;; ══════════════════════════════════════════════════════════════════
;;; CANDIDATE B — a lawful petition with an unresolved support reference.

(section "candidate B — lawful petition, unresolved support reference")
(desk "Two support references are written; one is bound.  Proposal, validation")
(desk "and materialization all succeed: the petition is a perfectly well-formed")
(desk "question.  It is the SUBMISSION that refuses, and it refuses BEFORE the")
(desk "governed operation is invoked at all.")

(defparameter *b*
  (hold :b (petition-datum-of :support-keys '("clearance" "second-opinion"))
        (tag "occ" "b")))

;;; ── DENOTATION DECLARATIONS (policy v3) ───────────────────────────
;;;
;;; Every binding carries two distinct facts: a DENOTATION DECLARATION — an
;;; immutable CD/0 datum the host supplies, naming what the reference is
;;; INTENDED to denote — and a LIVE ANCHOR, the exact image-local object handed
;;; to DERIVE/2.  The declaration is durable and enters identity; the anchor is
;;; neither, and no declaration is ever derived from an anchor.
;;;
;;; THIS APPLICATION DEMONSTRATES BOTH LAWFUL SHAPES, because the ruling permits
;;; both and a real host will meet both:
;;;
;;;   WHERE A GOVERNED IDENTITY EXISTS, USE IT.  A Slice /0 witness carries a
;;;   kernel0 durable identity; a Slice /1 judgment schema carries one.  Their
;;;   exact IDENTITY->DATUM values are the strongest declarations available,
;;;   because they are the governed layer's own names for those objects.
;;;
;;;   WHERE NONE EXISTS, DECLARE ANYWAY.  A ground proposition and a Slice /0
;;;   receiver context carry no kernel0 identity, so the host declares them with
;;;   its own durable identifiers.  Form /1 does not require every host object
;;;   to possess a governed identity; it requires an explicit, durable
;;;   declaration.  A host with nothing better than a name must still supply the
;;;   name — and the name is then exactly as good as the host is.
;;;
;;; AND THE HONESTY CLAUSE, which no shape escapes:
;;;   the declaration records what the trusted host asserts about the live
;;;   anchor; Form /1 does not independently certify that assertion.

(defun governed-declaration (identity)
  "The exact governed identity, as CD/0 data — the strongest declaration a host
can make, because it is the governed layer's own name for the object."
  (lisp-plus-kernel0:identity->datum identity))

(defun witness-declaration (witness)
  (governed-declaration (lisp-plus-slice0:witness-id witness)))

(defun schema-declaration (wrapper)
  (governed-declaration
   (lisp-plus-slice1:judgment-schema-identity
    (lisp-plus-slice2:slice2-schema-base-schema wrapper))))

(defun granted-context (occurrence-tag &key (wrapper *required-wrapper*)
                                            (volume "PLUT-7")
                                            (support-keys '("clearance"))
                                            (receiver :bound)
                                            (bind-receiver t)
                                            support-declaration)
  "Build and seal a resolution context for the one-support fixture.

SUPPORT-DECLARATION, when supplied, OVERRIDES the witness's own governed
identity with a host-chosen declaration — which is how a host commits IDENTIFIER
REUSE: the same declaration over two different live anchors.  It exists so the
residual can be exhibited deliberately rather than reached by accident."
  (let* ((witnesses (mapcar (lambda (key) (declare (ignore key))
                              (clearance-witness volume))
                            support-keys))
         (context (bind-conclusion-reference
                   (bind-schema-reference (make-derivation-resolution-context)
                                          (schema-reference "s") wrapper
                                          ;; governed identity — Slice /1's own
                                          (schema-declaration wrapper))
                   (conclusion-reference "c") *conclusion*
                   ;; no governed identity exists for a ground proposition, so
                   ;; the host declares it with its own durable identifier.
                   ;;
                   ;; NOTE, AND IT IS A REAL SCAR: this declaration must NOT
                   ;; mention VOLUME.  *CONCLUSION* is a fixed object; VOLUME
                   ;; varies the WITNESS, not the conclusion.  A first draft
                   ;; folded VOLUME in here, which declared a volume-specific
                   ;; denotation for a volume-independent anchor — a FALSE
                   ;; DECLARATION, written by the author of the honesty clause,
                   ;; within an hour of writing it.  It was caught by the B
                   ;; fixture below going red, which is what the split is for.
                   (tag "denotation" "conclusion" "volume-may-be-issued"))))
    (loop for key in support-keys
          for witness in witnesses
          do (setf context (bind-support-reference
                            context (support-reference key) witness
                            ;; governed identity — Slice /0's own witness id —
                            ;; unless the caller is deliberately reusing one
                            (or support-declaration (witness-declaration witness)))))
    (when bind-receiver
      (let ((value (ecase receiver
                     (:bound (reading-room witnesses))
                     (:explicit-nil nil))))
        (setf context (bind-receiver-reference
                       context (receiver-reference "r") value
                       ;; EXPLICIT RECEIVER ABSENCE is not the host's to name:
                       ;; NIL takes the package-owned sanctioned declaration,
                       ;; and only NIL may take it.
                       (if (null value)
                           (receiver-absence-declaration)
                           (tag "denotation" "receiver" "reading-room"))))))
    (seal-resolution-context context occurrence-tag)))

;;; A control derivation: a complete granted submission, used only to read where
;;; Slice /2's image-local ordinal currently stands.
(defun control-derivation (label)
  (let* ((row (hold (list :control label) (petition-datum-of)
                    (tag "occ" "control" (string label))))
         (context (granted-context (tag "ctx" "control" (string label)))))
    (submit-into row context :act (tag "act" "control" (string label))
                             :by-id (tag "by" "clerk"))
    (slice2-ordinal
     (petition-submission-outcome-slice2-receipt (genealogy-outcome row)))))

(defparameter *ord-1* (control-derivation :one))
(defparameter *ord-2* (control-derivation :two))
(defparameter *baseline-step* (- *ord-2* *ord-1*))

(defparameter *ord-3* (control-derivation :three))
(submit-into *b* (granted-context (tag "ctx" "b")) :act (tag "act" "b")
                                                   :by-id (tag "by" "clerk"))
(defparameter *ord-4* (control-derivation :four))
(defparameter *probe-step* (- *ord-4* *ord-3*))

(print-genealogy *b*)

(check (and (genealogy-proposed *b*) (genealogy-validated *b*)
            (genealogy-petition *b*))
       "B proposed, validated and materialized — the question is well formed")
(check (null (genealogy-outcome *b*))
       "B produced NO submission outcome object")
(check (and (genealogy-submit-refusal *b*)
            (eq :unresolved-support-reference
                (petition-refusal-code (genealogy-submit-refusal *b*)))
            (eq :submit (petition-refusal-phase (genealogy-submit-refusal *b*)))
            (eq :context (petition-refusal-category (genealogy-submit-refusal *b*))))
       "B was refused at :SUBMIT / :CONTEXT / :UNRESOLVED-SUPPORT-REFERENCE")
(check (same-id (petition-refusal-reference (genealogy-submit-refusal *b*))
                (support-reference "second-opinion"))
       "the refusal names the EXACT unbound reference, not a description of it")
(check (eq :support (petition-refusal-expected-role (genealogy-submit-refusal *b*)))
       "and it names the role that reference was required to bear")

(desk "")
(desk "NO SUBMISSION RECEIPT EXISTS FOR B.  Said exactly: TRY-SUBMIT-PETITION")
(desk "returned (values NIL REFUSAL).  There is no outcome object, and the only")
(desk "route to a submission receipt in this layer is through one.  The refusal")
(desk "is the whole of what this act produced.")
(check (null (genealogy-outcome *b*))
       "no outcome ⇒ no submission receipt is reachable for B, by construction")

(desk "")
(desk "AND DERIVE/2 WAS NOT INVOKED — shown, not asserted.  A Slice /2 receipt")
(desk "identity carries an image-local ordinal.  Two adjacent control derivations")
(desk "advance it by ~D.  Two more, with B's refused submission between them," *baseline-step*)
(desk "advance it by ~D.  Same step, so nothing derived in between." *probe-step*)
(check (= *baseline-step* *probe-step*)
       "the Slice /2 ordinal advanced identically across the refused submission")

;;; ══════════════════════════════════════════════════════════════════
;;; CANDIDATE C — the centre of the specimen.

(section "candidate C — right species, right mode, right kind, WRONG SUBJECT")
(desk "The support is a conservator's direct inspection — exactly the clause the")
(desk "contract accepts — of a DIFFERENT VOLUME.  Nothing about it is malformed.")
(desk "Every reference resolves.  DERIVE/2 is invoked.  And the premise is not")
(desk "satisfied, because the witness is about MS-99 and the conclusion is about")
(desk "PLUT-7.")

(defparameter *c* (hold :c (petition-datum-of) (tag "occ" "c")))

(defparameter *c-content-before*
  (derivation-petition-content-identity (genealogy-petition *c*)))
(defparameter *c-occurrence-before*
  (derivation-petition-occurrence-identity (genealogy-petition *c*)))
(defparameter *c-refs-before*
  (derivation-petition-support-references (genealogy-petition *c*)))

(defparameter *c-context* (granted-context (tag "ctx" "c") :volume "MS-99"))
(submit-into *c* *c-context* :act (tag "act" "c") :by-id (tag "by" "clerk"))
(print-genealogy *c*)

(defparameter *c-outcome* (genealogy-outcome *c*))
(defparameter *c-receipt* (petition-submission-outcome-receipt *c-outcome*))
(defparameter *c-slice2* (petition-submission-outcome-slice2-receipt *c-outcome*))

(desk "")
(desk "Slice /2 decision      ~S" (lisp-plus-slice2:slice2-receipt-decision *c-slice2*))
(desk "strongest lawful       ~S"
      (lisp-plus-slice2:slice2-receipt-strongest-lawful-result *c-slice2*))
(desk "premise dispositions   ~S"
      (mapcar #'lisp-plus-slice2:premise-admission-disposition
              (lisp-plus-slice2:slice2-receipt-admissions *c-slice2*)))
(desk "Slice /2 receipt name  ~A (image-local ordinal — NOT durable)"
      (lisp-plus-kernel0:durable-identity-name
       (lisp-plus-slice2:slice2-receipt-identity *c-slice2*)))
(desk "receipt binds it as    ~A"
      (cd0 render-diagnostic
           (petition-submission-receipt-slice2-receipt-identity-datum *c-receipt*)))
(desk "condition class        ~A"
      (petition-submission-receipt-slice2-condition-class *c-receipt*))

(check (eq :governed-refusal (petition-submission-outcome-kind *c-outcome*))
       "C's outcome kind is :GOVERNED-REFUSAL — a Slice /2 decision, not a Form /1 refusal")
(check (null (genealogy-submit-refusal *c*))
       "Form /1 did NOT refuse C — it resolved the references and stood aside")
(check (null (petition-submission-outcome-claim *c-outcome*))
       "C's claim is NIL — nothing was minted")
(check (null (petition-submission-outcome-derivation-basis *c-outcome*))
       "C's derivation basis is NIL — nothing was minted there either")
(check (petition-submission-receipt-p *c-receipt*)
       "a submission receipt DOES exist for C — the act happened and is accounted for")
(check (lisp-plus-slice2:slice2-receipt-p *c-slice2*)
       "a Slice /2 receipt exists on the outcome — DERIVE/2 ran and produced a record")
(check (eq :refused (lisp-plus-slice2:slice2-receipt-decision *c-slice2*))
       "the Slice /2 decision is :REFUSED, and the receipt says which premise blocked")
(check (petition-submission-receipt-slice2-receipt-identity-datum *c-receipt*)
       "the submission receipt binds the Slice /2 receipt identity as CD/0 data")
(check (and (same-id *c-content-before*
                     (derivation-petition-content-identity (genealogy-petition *c*)))
            (same-id *c-occurrence-before*
                     (derivation-petition-occurrence-identity (genealogy-petition *c*))))
       "the petition object is UNCHANGED by submission — both identities recompute equal")
(check (and (= (length *c-refs-before*)
               (length (derivation-petition-support-references (genealogy-petition *c*))))
            (every #'same-id *c-refs-before*
                   (derivation-petition-support-references (genealogy-petition *c*))))
       "its support references are unchanged, and are handed out as a fresh list each time")

(desk "")
(desk "THIS IS THE LINE THE LAYER EXISTS TO PRODUCE.  Everything worked.  The")
(desk "grammar admitted, the policy allowed, the context resolved, the governed")
(desk "operation was invoked and reached a decision — and NOTHING WAS MINTED.")
(desk "No claim, no basis, no warrant.  A full record of a question answered no.")
(desk "A layer that could not produce this line would be a layer that could only")
(desk "say yes, and a form that can only be answered yes is not petitioning.")

;;; ══════════════════════════════════════════════════════════════════
;;; CANDIDATE D — the exact case.

(section "candidate D — the exact case")

(defparameter *d* (hold :d (petition-datum-of) (tag "occ" "d")))
(defparameter *d-context* (granted-context (tag "ctx" "d")))
(submit-into *d* *d-context* :act (tag "act" "d") :by-id (tag "by" "clerk"))
(print-genealogy *d*)

(defparameter *d-outcome* (genealogy-outcome *d*))
(defparameter *d-receipt* (petition-submission-outcome-receipt *d-outcome*))
(defparameter *d-slice2* (petition-submission-outcome-slice2-receipt *d-outcome*))
(defparameter *d-claim* (petition-submission-outcome-claim *d-outcome*))
(defparameter *d-basis* (petition-submission-outcome-derivation-basis *d-outcome*))

(desk "")
(desk "claim proposition      ~S" (lisp-plus-slice0:claim-proposition *d-claim*))
(desk "claim identity         ~A:~A"
      (lisp-plus-kernel0:durable-identity-domain (lisp-plus-slice0:claim-id *d-claim*))
      (lisp-plus-kernel0:durable-identity-name (lisp-plus-slice0:claim-id *d-claim*)))
(desk "claim commitment       ~S / asserted by ~S"
      (lisp-plus-slice0:claim-commitment *d-claim*)
      (lisp-plus-slice0:claim-asserted-by *d-claim*))
(desk "Slice /2 receipt       ~A · decision ~S · schema ~S v~S"
      (lisp-plus-kernel0:durable-identity-name
       (lisp-plus-slice2:slice2-receipt-identity *d-slice2*))
      (lisp-plus-slice2:slice2-receipt-decision *d-slice2*)
      (lisp-plus-slice2:slice2-receipt-schema-id *d-slice2*)
      (lisp-plus-slice2:slice2-receipt-schema-version *d-slice2*))
(desk "derivation basis       species ~S · ceiling ~S · established-here ~S"
      (lisp-plus-slice2:derivation-basis-species *d-basis*)
      (lisp-plus-slice2:derivation-basis-truth-ceiling *d-basis*)
      (lisp-plus-slice2:derivation-basis-established-in-current-image-p *d-basis*))
(desk "basis proposition      ~S" (lisp-plus-slice2:derivation-basis-proposition *d-basis*))
(desk "submission receipt     act ~A · by ~A"
      (cd0 render-diagnostic (petition-submission-receipt-act-id *d-receipt*))
      (cd0 render-diagnostic (petition-submission-receipt-by-id *d-receipt*)))
(desk "  procedure            ~A v~D"
      (cd0 render-diagnostic (petition-submission-receipt-procedure-identity *d-receipt*))
      (petition-submission-receipt-procedure-version *d-receipt*))
(desk "  names Slice /2 as    ~A"
      (cd0 render-diagnostic
           (petition-submission-receipt-slice2-receipt-identity-datum *d-receipt*)))
(desk "  petition occurrence  ~A"
      (id! '(:d :receipt-names-petition)
           (petition-submission-receipt-petition-occurrence-identity *d-receipt*)))
(desk "  context tag          ~A   (the host's NAME — not an identity)"
      (cd0 render-diagnostic
           (petition-submission-receipt-context-occurrence-tag *d-receipt*)))
(desk "  context declaration  ~A"
      (id! '(:d :receipt-names-context-declaration)
           (petition-submission-receipt-context-declaration-identity *d-receipt*)))
(desk "  context occurrence   ~A"
      (id! '(:d :receipt-names-context-occurrence)
           (petition-submission-receipt-context-occurrence-identity *d-receipt*)))

(check (eq :granted (petition-submission-outcome-kind *d-outcome*))
       "D's outcome kind is :GRANTED")
(check (lisp-plus-slice0:claim-p *d-claim*)
       "D carries the exact granted claim object")
(check (equal *conclusion* (lisp-plus-slice0:claim-proposition *d-claim*))
       "the granted claim is about exactly the conclusion the petition referenced")
(check (eq :granted (lisp-plus-slice2:slice2-receipt-decision *d-slice2*))
       "the Slice /2 receipt records the grant")
(check (lisp-plus-slice2:derivation-basis-p *d-basis*)
       "the derivation basis — Slice /2's third, additive return value — is preserved")
(check (eq *d-claim* (lisp-plus-slice2:derivation-basis-claim *d-basis*))
       "the basis binds the EXACT claim object, not a copy of it")
(check (same-id (petition-submission-receipt-petition-occurrence-identity *d-receipt*)
                (derivation-petition-occurrence-identity (genealogy-petition *d*)))
       "the submission receipt names the exact petition occurrence it was raised from")
(check (not (same-id (petition-submission-receipt-occurrence-identity *d-receipt*)
                     (petition-submission-receipt-identity *d-receipt*)))
       "the submission OCCURRENCE and the submission RECEIPT are two identities, not one")
(check (cd0 identifier-datum-p
            (petition-submission-receipt-slice2-receipt-identity-datum *d-receipt*))
       "the receipt holds the Slice /2 receipt's NAME as data — never the receipt object")

(desk "")
(desk "THE SUBMISSION RECEIPT LINKS, AND INHERITS NO STANDING.  It names the")
(desk "Slice /2 receipt — domain and name, as CD/0 data — and that is all it")
(desk "takes from it.  It is not a claim, not a basis, not a warrant, and it")
(desk "confers nothing on the petition it came from.  The standing that exists")
(desk "here belongs to the Slice /2 grant and stays there; the receipt is the")
(desk "LATER ACCOUNT of an earlier ACT, and an account of a thing is not the")
(desk "thing.  Note too what the name is: an IMAGE-LOCAL ORDINAL.  It is not")
(desk "durable, this file does not treat it as durable, and the field that")
(desk "carries it says so in its own name.")

;;; ══════════════════════════════════════════════════════════════════
;;; THE RECEIVER — three different facts that a careless layer would confuse.

(section "receiver bound to NIL under :RECEIVER-ACCESSIBILITY :OPTIONAL")
(desk "A bound NIL is EXPLICIT RECEIVER ABSENCE: the host looked, and there is")
(desk "no receiver.  Under a contract that permits it, the premise still holds.")

(defparameter *e-optional* (hold :e-optional (petition-datum-of) (tag "occ" "e-opt")))
(submit-into *e-optional*
             (granted-context (tag "ctx" "e-opt") :wrapper *optional-wrapper*
                                                  :receiver :explicit-nil)
             :act (tag "act" "e-opt") :by-id (tag "by" "clerk"))
(print-genealogy *e-optional*)

(check (eq :granted (petition-submission-outcome-kind
                     (genealogy-outcome *e-optional*)))
       "an explicitly NIL receiver under an :OPTIONAL contract is GRANTED")
(defparameter *e-optional-context*
  (petition-submission-receipt-context
   (petition-submission-outcome-receipt (genealogy-outcome *e-optional*))))

(check (member (receiver-reference "r")
               (derivation-resolution-context-declarations *e-optional-context*)
               :key #'context-binding-declaration-reference :test #'same-id)
       "the receiver reference IS declared in the sealed context")

;; SURFACE B answers what SURFACE A cannot, and the two answers are different
;; KINDS of fact — which is the whole point of splitting them.
(check (multiple-value-bind (anchor found)
           (derivation-resolution-context-live-anchor
            *e-optional-context* :receiver (receiver-reference "r"))
         (and found (null anchor)))
       "…and its LIVE ANCHOR is (values NIL T) — a bound NIL is FOUND, not absent")

(check (same-id (receiver-absence-declaration)
                (context-binding-declaration-denotation
                 (find (receiver-reference "r")
                       (derivation-resolution-context-declarations *e-optional-context*)
                       :key #'context-binding-declaration-reference :test #'same-id)))
       "…and its DECLARATION is the package-owned RECEIVER-ABSENCE-DECLARATION — explicit absence is a declared fact, and no arbitrary host identifier may describe it")

(section "the same petition, receiver reference NOT bound at all")
(desk "The distinction the layer must not lose: bound-to-NIL is a fact about the")
(desk "world; unbound is a fact about the context.  They are different refusals")
(desk "and different outcomes.")

(defparameter *e-unbound* (hold :e-unbound (petition-datum-of) (tag "occ" "e-unb")))
(submit-into *e-unbound*
             (granted-context (tag "ctx" "e-unb") :wrapper *optional-wrapper*
                                                  :bind-receiver nil)
             :act (tag "act" "e-unb") :by-id (tag "by" "clerk"))
(print-genealogy *e-unbound*)

(check (null (genealogy-outcome *e-unbound*))
       "an UNBOUND receiver reference produces no outcome at all")
(check (and (genealogy-submit-refusal *e-unbound*)
            (eq :unresolved-receiver-reference
                (petition-refusal-code (genealogy-submit-refusal *e-unbound*))))
       "it is a Form /1 refusal — :UNRESOLVED-RECEIVER-REFERENCE — not a governed outcome")
(check (and (petition-submission-outcome-p (genealogy-outcome *e-optional*))
            (null (genealogy-submit-refusal *e-optional*))
            (null (genealogy-outcome *e-unbound*))
            (genealogy-submit-refusal *e-unbound*))
       "bound-to-NIL and unbound are DISTINCT: one yielded a governed outcome, the other a Form /1 refusal")

(section "receiver bound to NIL under a :RECEIVER-ACCESSIBILITY :REQUIRED contract")
(desk "Here Form /1 must NOT step in.  The reference resolves; the contract's")
(desk "requirement is the governed operation's business, and the answer must come")
(desk "back as a Slice /2 outcome.")

(defparameter *e-required* (hold :e-required (petition-datum-of) (tag "occ" "e-req")))
(submit-into *e-required*
             (granted-context (tag "ctx" "e-req") :wrapper *required-wrapper*
                                                  :receiver :explicit-nil)
             :act (tag "act" "e-req") :by-id (tag "by" "clerk"))
(print-genealogy *e-required*)

(defparameter *e-required-reasons*
  (loop for admission in (lisp-plus-slice2:slice2-receipt-admissions
                          (petition-submission-outcome-slice2-receipt
                           (genealogy-outcome *e-required*)))
        append (lisp-plus-slice2:premise-admission-reasons admission)))
(desk "admission reasons      ~S" *e-required-reasons*)

(check (null (genealogy-submit-refusal *e-required*))
       "Form /1 raised no refusal — the reference resolved, so it stood aside")
(check (eq :governed-refusal (petition-submission-outcome-kind
                              (genealogy-outcome *e-required*)))
       "the answer is a GOVERNED Slice /2 outcome, not a Form /1 refusal")
(check (find :receiver-context-required *e-required-reasons*
             :key (lambda (reason) (and (consp reason) (first reason))))
       "and Slice /2's own reason names :RECEIVER-CONTEXT-REQUIRED")

;;; ══════════════════════════════════════════════════════════════════
;;; ROLE CONFUSION — the role is in the identifier, not in a convention.

(section "role confusion — a support binding cannot satisfy a receiver reference")
(desk "Both references below carry the host key \"shared\".  They are not the")
(desk "same identifier, and the difference is structural, not a naming habit.")

(desk "support ref            ~A" (cd0 render-diagnostic (support-reference "shared")))
(desk "receiver ref           ~A" (cd0 render-diagnostic (receiver-reference "shared")))

(check (not (same-id (support-reference "shared") (receiver-reference "shared")))
       "the two references bearing one host key are DIFFERENT identifiers")
(check (and (eq :support (reference-role (support-reference "shared")))
            (eq :receiver (reference-role (receiver-reference "shared"))))
       "and each carries its role where a reader can see it")

(defparameter *role-petition*
  (hold :role-confused
        (petition-datum-of :support-keys '("shared") :receiver-key "shared")
        (tag "occ" "role")))

(defparameter *role-context*
  (let* ((witness (clearance-witness "PLUT-7"))
         (context (bind-support-reference
                   (bind-conclusion-reference
                    (bind-schema-reference (make-derivation-resolution-context)
                                           (schema-reference "s") *required-wrapper*
                                           (schema-declaration *required-wrapper*))
                    (conclusion-reference "c") *conclusion*
                    (tag "denotation" "conclusion" "volume-may-be-issued"))
                   ;; The receiver context is bound HERE, through the SUPPORT
                   ;; binder, under the same host key the receiver reference uses.
                   (support-reference "shared") witness
                   (witness-declaration witness))))
    (seal-resolution-context context (tag "ctx" "role"))))

(submit-into *role-petition* *role-context* :act (tag "act" "role")
                                            :by-id (tag "by" "clerk"))
(print-genealogy *role-petition*)

(check (and (genealogy-submit-refusal *role-petition*)
            (eq :unresolved-receiver-reference
                (petition-refusal-code (genealogy-submit-refusal *role-petition*))))
       "the support-bound value did NOT satisfy the receiver reference")
(check (null (genealogy-outcome *role-petition*))
       "so nothing was submitted to DERIVE/2 under a confused role")

(defparameter *role-binder-refusal*
  (handler-case
      (progn (bind-receiver-reference (make-derivation-resolution-context)
                                      (support-reference "shared")
                                      nil
                                      (receiver-absence-declaration))
             nil)
    (petition-refused (condition) (petition-refused-refusal condition))))

(print-refusal "receiver binder" *role-binder-refusal*)
(check (and *role-binder-refusal*
            (eq :binding-role-mismatch (petition-refusal-code *role-binder-refusal*))
            (eq :receiver (petition-refusal-expected-role *role-binder-refusal*)))
       "and the receiver BINDER refuses a support-role reference outright")

;;; ══════════════════════════════════════════════════════════════════
;;; TWO LIMITATIONS, PRESERVED RATHER THAN PAPERED OVER.

(section "one context occurrence TAG, two different sets of live bindings")
(desk "This section used to state ONE limitation.  Under policy v3 it states TWO")
(desk "DIFFERENT THINGS, and the difference is the whole of Review 1.")
(desk "")
(desk "SEAL-RESOLUTION-CONTEXT takes a host TAG.  Under policy v2 the tag WAS the")
(desk "context's whole identity, so two contexts declaring genuinely different")
(desk "things shared one submission occurrence identity and the layer recorded")
(desk "nothing that could tell them apart.  That was not an edge case and not a")
(desk "host's fault: the layer never asked what the references were declared to")
(desk "denote, so it could not record it.  IT WAS A DEFECT OF THIS LAYER.")
(desk "")
(desk "Under v3 the tag is a tag.  The context's IDENTITY is content-derived from")
(desk "its declarations.  Below, both halves are shown separately, because the")
(desk "residual never licensed the defect and the repair does not erase the")
(desk "residual.")

(defparameter *collide-id* (tag "ctx" "one-name-two-worlds"))

;;; ---- A. DIFFERENT DECLARATIONS — repaired ------------------------
(desk "")
(desk "A.  SAME TAG, DIFFERENT DECLARATIONS.  Two contexts over two different")
(desk "    witnesses.  Each support is declared with the witness's OWN governed")
(desk "    Slice /0 identity, so the declarations differ because the declared")
(desk "    objects differ.")

(defparameter *collide-wrong* (hold :collide-wrong (petition-datum-of) (tag "occ" "coll")))
(submit-into *collide-wrong* (granted-context *collide-id* :volume "MS-99")
             :act (tag "act" "coll") :by-id (tag "by" "clerk"))

(defparameter *collide-right* (hold :collide-right (petition-datum-of) (tag "occ" "coll")))
(submit-into *collide-right* (granted-context *collide-id* :volume "PLUT-7")
             :act (tag "act" "coll") :by-id (tag "by" "clerk"))

(defparameter *collide-wrong-receipt*
  (petition-submission-outcome-receipt (genealogy-outcome *collide-wrong*)))
(defparameter *collide-right-receipt*
  (petition-submission-outcome-receipt (genealogy-outcome *collide-right*)))

(desk "")
(desk "wrong-subject outcome  ~S · occurrence ~A"
      (petition-submission-outcome-kind (genealogy-outcome *collide-wrong*))
      (id! :collide-wrong-occurrence
           (petition-submission-receipt-occurrence-identity *collide-wrong-receipt*)))
(desk "right-subject outcome  ~S · occurrence ~A"
      (petition-submission-outcome-kind (genealogy-outcome *collide-right*))
      (id! :collide-right-occurrence
           (petition-submission-receipt-occurrence-identity *collide-right-receipt*)))
(desk "context tags           IDENTICAL — ~A"
      (cd0 render-diagnostic *collide-id*))
(desk "context declarations   ~A"
      (id! :collide-wrong-declaration
           (petition-submission-receipt-context-declaration-identity *collide-wrong-receipt*)))
(desk "                       ~A"
      (id! :collide-right-declaration
           (petition-submission-receipt-context-declaration-identity *collide-right-receipt*)))

(check (not (eq (petition-submission-outcome-kind (genealogy-outcome *collide-wrong*))
                (petition-submission-outcome-kind (genealogy-outcome *collide-right*))))
       "A: the two acts reached DIFFERENT governed outcomes")
(check (same-id (petition-submission-receipt-context-occurrence-tag *collide-wrong-receipt*)
                (petition-submission-receipt-context-occurrence-tag *collide-right-receipt*))
       "A: their host-supplied context TAGS are identical — the tag is held fixed on purpose")
(check (not (same-id
             (petition-submission-receipt-context-declaration-identity *collide-wrong-receipt*)
             (petition-submission-receipt-context-declaration-identity *collide-right-receipt*)))
       "A: their context DECLARATION identities DIFFER — the layer now records what the references were declared to denote")
(check (not (same-id (petition-submission-receipt-occurrence-identity *collide-wrong-receipt*)
                     (petition-submission-receipt-occurrence-identity *collide-right-receipt*)))
       "A: and therefore their submission OCCURRENCE identities DIFFER — the v2 defect is repaired, in the same fixture that used to exhibit it")

;;; ---- B. SAME DECLARATION, DIFFERENT ANCHOR — the residual --------
(desk "")
(desk "B.  SAME TAG, SAME DECLARATION, DIFFERENT LIVE ANCHOR.  Here the host")
(desk "    REUSES one identifier across two genuinely different witnesses.  It")
(desk "    is declaring the same thing about two objects; at most one of those")
(desk "    assertions is true, and Form /1 cannot tell which — a declaration is")
(desk "    not certification of its anchor.  NOTHING IN-IMAGE CAN CLOSE THIS.")

(defparameter *reused-declaration* (tag "denotation" "support" "the-clearance"))

(defparameter *false-wrong* (hold :false-wrong (petition-datum-of) (tag "occ" "false")))
(submit-into *false-wrong* (granted-context *collide-id* :volume "MS-99"
                                            :support-declaration *reused-declaration*)
             :act (tag "act" "false") :by-id (tag "by" "clerk"))

(defparameter *false-right* (hold :false-right (petition-datum-of) (tag "occ" "false")))
(submit-into *false-right* (granted-context *collide-id* :volume "PLUT-7"
                                            :support-declaration *reused-declaration*)
             :act (tag "act" "false") :by-id (tag "by" "clerk"))

(defparameter *false-wrong-receipt*
  (petition-submission-outcome-receipt (genealogy-outcome *false-wrong*)))
(defparameter *false-right-receipt*
  (petition-submission-outcome-receipt (genealogy-outcome *false-right*)))

(desk "")
(desk "wrong-subject outcome  ~S" (petition-submission-outcome-kind (genealogy-outcome *false-wrong*)))
(desk "right-subject outcome  ~S" (petition-submission-outcome-kind (genealogy-outcome *false-right*)))
(desk "context declarations   ~A"
      (id! :false-wrong-declaration
           (petition-submission-receipt-context-declaration-identity *false-wrong-receipt*)))
(desk "                       ~A"
      (id! :false-right-declaration
           (petition-submission-receipt-context-declaration-identity *false-right-receipt*)))

(check (not (eq (petition-submission-outcome-kind (genealogy-outcome *false-wrong*))
                (petition-submission-outcome-kind (genealogy-outcome *false-right*))))
       "B: the two acts reached DIFFERENT governed outcomes")
(check (same-id
        (petition-submission-receipt-context-declaration-identity *false-wrong-receipt*)
        (petition-submission-receipt-context-declaration-identity *false-right-receipt*))
       "B: their context DECLARATION identities are IDENTICAL — they declare the same thing, and the layer records declarations, not truths")
(check (same-id (petition-submission-receipt-occurrence-identity *false-wrong-receipt*)
                (petition-submission-receipt-occurrence-identity *false-right-receipt*))
       "B: and their submission OCCURRENCE identities are IDENTICAL — the DECLARED RESIDUAL, not the repaired defect")

;; …and what DOES survive, stated exactly, because it is so much less than
;; certification: an in-image reader holding both receipts can still see the
;; divergence, through the exact anchors and the exact Slice /2 receipts.
(check (not (eq (derivation-resolution-context-live-anchor
                 (petition-submission-receipt-context *false-wrong-receipt*)
                 :support (support-reference "clearance"))
                (derivation-resolution-context-live-anchor
                 (petition-submission-receipt-context *false-right-receipt*)
                 :support (support-reference "clearance"))))
       "B: the exact CONTEXT ANCHORS reached through the two receipts are different objects — observable in-image, recorded durably nowhere")
(check (not (same-id
             (petition-submission-receipt-slice2-receipt-identity-datum *false-wrong-receipt*)
             (petition-submission-receipt-slice2-receipt-identity-datum *false-right-receipt*)))
       "B: and the exact SLICE /2 RECEIPT identities differ — the governed layer minted two, and Form /1 recorded both exactly")

(desk "")
(desk "B IS CLASSIFIED PRECISELY, and the classification is the honest part:")
(desk "  trusted-host false declaration or identifier reuse;")
(desk "  not detected by Form /1;")
(desk "  not claimed to be detected;")
(desk "  no cross-image certification earned.")
(desk "")
(desk "THE EXISTENCE OF B DOES NOT EXCUSE A.  A was a defect of this layer — the")
(desk "declared content of a context was never recorded at all — and it is fixed.")
(desk "B is a boundary of what any in-image record can do, and it stays.  Calling")
(desk "them both `an undetected host error' was one sentence covering a repair")
(desk "that had not happened and a limit that could not be lifted.")

(section "one submission act id, reused for two genuinely distinct acts")
(desk "The same honesty rule, one rung along.  :ACT-ID names this submission")
(desk "act.  Two acts given one name collide in the record, and again nothing")
(desk "in this layer complains.")

(defparameter *reuse-id* (tag "act" "one-act-two-times"))
(defparameter *reuse-context* (granted-context (tag "ctx" "reuse")))
(defparameter *reuse* (hold :reuse (petition-datum-of) (tag "occ" "reuse")))

(defparameter *reuse-first*
  (petition-submission-outcome-receipt
   (genealogy-outcome (submit-into *reuse* *reuse-context*
                                   :act *reuse-id* :by-id (tag "by" "clerk")))))
(defparameter *reuse-second*
  (petition-submission-outcome-receipt
   (genealogy-outcome (submit-into *reuse* *reuse-context*
                                   :act *reuse-id* :by-id (tag "by" "clerk")))))

(desk "")
(desk "first act occurrence   ~A"
      (id! :reuse-first-occurrence
           (petition-submission-receipt-occurrence-identity *reuse-first*)))
(desk "second act occurrence  ~A"
      (id! :reuse-second-occurrence
           (petition-submission-receipt-occurrence-identity *reuse-second*)))
(desk "first act receipt      ~A"
      (id! :reuse-first-receipt (petition-submission-receipt-identity *reuse-first*)))
(desk "second act receipt     ~A"
      (id! :reuse-second-receipt (petition-submission-receipt-identity *reuse-second*)))
(desk "first names Slice /2   ~A"
      (cd0 render-diagnostic
           (petition-submission-receipt-slice2-receipt-identity-datum *reuse-first*)))
(desk "second names Slice /2  ~A"
      (cd0 render-diagnostic
           (petition-submission-receipt-slice2-receipt-identity-datum *reuse-second*)))

(check (same-id (petition-submission-receipt-occurrence-identity *reuse-first*)
                (petition-submission-receipt-occurrence-identity *reuse-second*))
       "two distinct governed acts, one reused :ACT-ID, ONE submission occurrence identity")
(check (not (same-id (petition-submission-receipt-identity *reuse-first*)
                     (petition-submission-receipt-identity *reuse-second*)))
       "the receipt identities differ — but ONLY because Slice /2's ordinal moved")
(desk "That difference is an accident of Slice /2's naming, not a Form /1")
(desk "guarantee, and it would not have been there if the two acts had been")
(desk "refused at the same door.  The honest statement is the one above the")
(desk "line: the occurrence identity collided, and nothing noticed.")

;;; ══════════════════════════════════════════════════════════════════
;;; THE DISPLAY IS ITSELF UNDER TEST.

(section "the abbreviations, tested")

;; PROBE (Review 1): search the MINIMAL head/tail window that discriminates this
;; corpus, printed so the constants below are a MEASUREMENT and not a guess.
(let ((identities (remove-duplicates (mapcar #'cdr *census*) :test #'same-id)))
  (labels ((short-with (identity head tail)
             (let* ((hex (render-identity-hex identity)) (n (length hex)))
               (if (<= n (+ head tail))
                   (format nil "~A/~D" hex n)
                   (format nil "~A~A/~D" (subseq hex 0 head) (subseq hex (- n tail)) n))))
           (distinct-p (head tail)
             (= (length identities)
                (length (remove-duplicates
                         (mapcar (lambda (i) (short-with i head tail)) identities)
                         :test #'string=)))))
    (let ((found nil))
      (loop for head in '(96 128 160 192 224 256 320 384 448 512)
            until found
            do (loop for tail in '(160 192 224 256 320 384 448 512)
                     when (distinct-p head tail)
                       do (setf found (list head tail)) (return)))
      (desk "MINIMAL DISCRIMINATING WINDOW over ~D distinct identities: head ~A tail ~A"
            (length identities) (first found) (second found))
      (desk "  (searched ascending; the constants above are set to this measurement)"))))


(let* ((identities (mapcar #'cdr *census*))
       (distinct-full (remove-duplicates identities :test #'same-id))
       (distinct-short (remove-duplicates (mapcar #'short identities) :test #'string=)))
  (desk "identities printed     ~D" (length identities))
  (desk "distinct full          ~D" (length distinct-full))
  (desk "distinct short         ~D" (length distinct-short))
  (check (= (length distinct-full) (length distinct-short))
         (format nil "every distinct full identity has a distinct short form (~D = ~D)"
                 (length distinct-full) (length distinct-short))))

;;; ══════════════════════════════════════════════════════════════════

(section "the tally, counted")
(desk "submissions granted        ~D  (each minted by DERIVE/2, none by Form /1)" *granted*)
(desk "governed refusals          ~D  (DERIVE/2 invoked, decided no, nothing minted)"
      *governed-refusals*)
(desk "Form /1 refusals at submit ~D  (DERIVE/2 never invoked, no receipt exists)"
      *form1-refusals*)
(desk "submissions in all         ~D" (length *submission-log*))
(check (and (plusp (length *submission-log*))
            (every (lambda (cell)
                     (if (car cell) (null (cdr cell)) (not (null (cdr cell)))))
                   *submission-log*))
       (format nil "every one of the ~D submissions returned EITHER an outcome OR a refusal — never both, never neither"
               (length *submission-log*)))

(section "what this program does NOT establish")
(format t "  It is a scripted fixture.  No model was called and no provider was~%")
(format t "  reached; nothing here is evidence that any external process emitted a~%")
(format t "  petition or could.  A petition is not a claim: every claim counted~%")
(format t "  above was minted by the governed operation, on its own terms, which~%")
(format t "  both granted and refused, in the proportions tallied above.  Every~%")
(format t "  green line is self-consistency certification: one model family wrote~%")
(format t "  the layer, this program, and these checks.  Form /1 remains a~%")
(format t "  candidate; the stranger audit is OWED and Form /0's does not cover it.~%")

(format t "~%── A valid petition is a well-formed question, not a granted answer. ──~%")
(format t "── The machinery running is not the same event as something produced. ──~%")
(format t "── An account of an act is not the act, and inherits nothing from it. ──~%")

(format t "~%== de-forma-petente: ~D checks passed / ~D failed ==~%"
        (- *checks* *failed*) *failed*)

(when (plusp *failed*)
  (sb-ext:exit :code 1))
