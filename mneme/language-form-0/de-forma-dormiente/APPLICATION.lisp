;;;; APPLICATION.lisp — de forma dormiente: concerning the sleeping form.
;;;;
;;;; Run: sbcl --non-interactive --load APPLICATION.lisp
;;;;
;;;; An inhabited Language Form /0 program.  A DETERMINISTIC FAKE LATENT ADAPTER
;;;; emits three candidate programs as Canonical Datum /0 trees.  The desk holds
;;;; each one, decides what it is, and keeps the whole genealogy — including the
;;;; genealogy of the two it refuses.
;;;;
;;;; THESIS
;;;;   • a form emitted by a latent process arrives ASLEEP: it is data, and
;;;;     nothing about having been emitted wakes it;
;;;;   • admission under a grammar is not instantiation, instantiation is not
;;;;     validation, and validation is not realization — four objects, four
;;;;     identities, no status slot advancing one thing through four lives;
;;;;   • a hole is a place for DATA, never a place for a program;
;;;;   • the two refused candidates are as much of the record as the one that ran;
;;;;   • realization computes over data and returns data — it mints no claim, no
;;;;     basis, no capability, no authority and no warrant.
;;;;
;;;; WHAT THIS DOES NOT ESTABLISH
;;;; The adapter is a LABELLED SCRIPTED FAKE.  No model was called, no provider
;;;; was reached, and nothing here is evidence that any external process emitted
;;;; anything.  Every green below is self-consistency certification: one model
;;;; family wrote the language, this program and its checks.  The candidate
;;;; standing of Form /0 is unchanged by this file, and the stranger audit is
;;;; OWED against it too.

(load (merge-pathnames "../form0.lisp" *load-truename*))

(defpackage #:de-forma-dormiente (:use #:cl #:lisp-plus-form0))
(in-package #:de-forma-dormiente)

(defmacro cd0 (name &rest arguments)
  `(,(intern (string name) :lisp-plus-cd0) ,@arguments))

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

(defun short (identity)
  "An abbreviation that carries its own length, and a warning about itself.

Every CD/0 canonical encoding begins with the same magic and the same framing,
and identities composed from a shared predecessor also share long tails. A
sixteen-character slice from EITHER END therefore makes distinct identities
print as equal — which is exactly how a ledger can appear to show one identity
shared across four phases while the underlying values differ.

So this prints the length too, and `check-abbreviations-discriminate' below
asserts that the abbreviations actually shown are pairwise distinct. An
abbreviation nobody has tested is a diagnostic that can lie."
  (let ((length (length identity)))
    (format nil "~A(~D)"
            (if (<= length 24) identity (subseq identity 0 24))
            length)))

(defun check-abbreviations-discriminate (labelled-identities label)
  "LABELLED-IDENTITIES is a list of (name . identity). Require that distinct
identities keep distinct ABBREVIATIONS — the display must not collapse them."
  (let ((distinct-full (remove-duplicates (mapcar #'cdr labelled-identities)
                                          :test #'string=))
        (distinct-short (remove-duplicates
                         (mapcar (lambda (pair) (short (cdr pair)))
                                 labelled-identities)
                         :test #'string=)))
    (check (= (length distinct-full) (length distinct-short))
           (format nil "~A — the printed abbreviations discriminate exactly as the full identities do"
                   label))))

;;; ══════════════════════════════════════════════════════════════════
;;; The desk's sealed environment.  The program builds it, the program installs
;;; the handlers, and the program seals it.  No candidate can reach any of this.

(defparameter *desk*
  (seal-form-environment
   (make-form-environment
    :name "de-forma-dormiente"
    :version 1
    ;; A SELECTION of package-owned operator names. The desk chooses WHICH
    ;; operators exist here; it cannot choose what they DO.
    :operators (operator-names)
    :holes
    (list (make-form-hole "expected-digest" :string)
          (make-form-hole "observed" :sequence)))))

;;; ══════════════════════════════════════════════════════════════════
;;; The deterministic fake latent adapter.
;;;
;;; It returns fixed CD/0 trees.  It performs no request, consults no provider,
;;; and has no source of variation: the same call returns the same bytes.

(defun adapter-emit (candidate-name)
  "A LABELLED SCRIPTED FAKE.  Returns a fixed candidate datum by name."
  (ecase candidate-name
    ;; A — structurally malformed.  The head belongs to no production.
    (:a (cd0 make-sequence-datum
             (list (cd0 make-identifier-datum '("dreamt-language") '("if"))
                   (cd0 make-integer-datum 1)
                   (cd0 make-integer-datum 0))))
    ;; B — structurally lawful, but names an operator the desk never installed.
    ;; The name is the most dangerous one the adapter could have reached for.
    (:b (cd0 make-sequence-datum
             (list (operator-identifier "perform")
                   (literal-node (cd0 make-string-datum "settle-the-account")))))
    ;; C — lawful, two declared holes, nested operator calls.
    ;; "Is the digest of what we observed the digest we were promised?"
    (:c (operator-node
         "equal-datum"
         (operator-node "canonical-hex" (hole-node "observed"))
         (hole-node "expected-digest")))))

;;; ══════════════════════════════════════════════════════════════════
;;; The genealogy ledger.  Every candidate gets a row whether it lives or dies.

(defstruct genealogy
  name datum-identity
  (proposal nil) (proposal-refusal nil)
  (instantiated nil) (instantiation-refusal nil)
  (validated nil) (validation-refusal nil)
  (result nil) (realization-receipt nil) (realization-refusal nil))

(defparameter *ledger* '())

(defun hold-candidate (name bindings)
  "Walk one candidate as far as the law allows, retaining every refusal."
  (let* ((datum (adapter-emit name))
         (row (make-genealogy
               :name name
               :datum-identity (cd0 octets-to-hex (cd0 canonical-octets datum)))))
    (multiple-value-bind (proposal refusal) (try-propose-form datum *desk*)
      (setf (genealogy-proposal row) proposal
            (genealogy-proposal-refusal row) refusal)
      (when proposal
        (multiple-value-bind (instantiated refusal)
            (try-instantiate-form proposal bindings *desk*)
          (setf (genealogy-instantiated row) instantiated
                (genealogy-instantiation-refusal row) refusal)
          (when instantiated
            (multiple-value-bind (validated refusal)
                (try-validate-form instantiated *desk*)
              (setf (genealogy-validated row) validated
                    (genealogy-validation-refusal row) refusal)
              (when validated
                (multiple-value-bind (result receipt refusal)
                    (try-realize-form validated *desk*)
                  (setf (genealogy-result row) result
                        (genealogy-realization-receipt row) receipt
                        (genealogy-realization-refusal row) refusal))))))))
    (push row *ledger*)
    row))

(defun print-genealogy (row)
  (format t "  candidate ~S  datum ~A~%"
          (genealogy-name row) (short (genealogy-datum-identity row)))
  (flet ((step-line (label object refusal)
           (format t "    ~12A ~A~%" label
                   (cond (refusal
                          (format nil "REFUSED  ~S/~S — ~A"
                                  (form-refusal-category refusal)
                                  (form-refusal-code refusal)
                                  (form-refusal-detail refusal)))
                         (object "held")
                         (t "not reached")))))
    (step-line "proposal" (genealogy-proposal row) (genealogy-proposal-refusal row))
    (step-line "instantiation" (genealogy-instantiated row)
               (genealogy-instantiation-refusal row))
    (step-line "validation" (genealogy-validated row)
               (genealogy-validation-refusal row))
    (step-line "realization" (genealogy-result row)
               (genealogy-realization-refusal row))))

;;; ══════════════════════════════════════════════════════════════════

(format t "~%════════════════════════════════════════════════════════════════~%")
(format t "  de forma dormiente — an inhabited Language Form /0 program~%")
(format t "════════════════════════════════════════════════════════════════~%")
(desk "The adapter is a labelled scripted fake.  No model was called.")
(desk "A form that arrives from a latent process arrives asleep.")

(section "the desk's sealed environment")
(desk "environment   ~A v~D"
      (cd0 render-diagnostic (form-environment-identity *desk*))
      (form-environment-version *desk*))
(desk "grammar       ~A v~D"
      (cd0 render-diagnostic (form-environment-grammar-identity *desk*))
      (form-environment-grammar-version *desk*))
(desk "operators     ~D installed" (length (form-environment-operator-identities *desk*)))
(desk "holes         ~D declared" (length (form-environment-hole-identities *desk*)))
(desk "resource      ~A" (form-environment-budget-id *desk*))
(check (form-environment-sealed-p *desk*) "the environment is sealed before any candidate arrives")

;;; ── Candidate A ───────────────────────────────────────────────────
(section "candidate A — malformed; refused before it is ever a proposal")
(defparameter *a* (hold-candidate :a '()))
(print-genealogy *a*)
(check (null (genealogy-proposal *a*))
       "A never became a proposal")
(check (and (genealogy-proposal-refusal *a*)
            (eq (form-refusal-code (genealogy-proposal-refusal *a*))
                :unknown-production))
       "A was refused as :UNKNOWN-PRODUCTION at the grammar")
(check (cd0 datum-p (form-refusal-offending (genealogy-proposal-refusal *a*)))
       "A's offending datum is retained inside the refusal, not merely described")

;;; ── Candidate B ───────────────────────────────────────────────────
(section "candidate B — lawful shape, forbidden name; refused at validation")
(defparameter *b* (hold-candidate :b '()))
(print-genealogy *b*)
(check (genealogy-proposal *b*)
       "B IS admitted under the grammar — its shape is lawful")
(check (= 1 (length (proposed-form-operator-identities (genealogy-proposal *b*))))
       "B mentions exactly one operator")
(check (and (genealogy-validation-refusal *b*)
            (eq (form-refusal-code (genealogy-validation-refusal *b*))
                :unknown-operator))
       "B was refused as :UNKNOWN-OPERATOR — `perform` is not installed here")
(check (null (genealogy-result *b*))
       "B produced no result")
(desk "The desk holds a lawful program naming a consequential act, and the act")
(desk "does not happen.  Naming is not authority; the name resolved to nothing.")

;;; ── Candidate C ───────────────────────────────────────────────────
(section "candidate C — lawful; held, filled, bound, and only then realized")

(defparameter *observed*
  (cd0 make-sequence-datum (list (cd0 make-string-datum "ledger-row")
                                 (cd0 make-integer-datum 4))))

(defparameter *promised-digest*
  (cd0 make-string-datum (cd0 octets-to-hex (cd0 canonical-octets *observed*))))

(defparameter *c*
  (hold-candidate :c (list (cons "observed" *observed*)
                           (cons "expected-digest" *promised-digest*))))
(print-genealogy *c*)

(let ((proposal (genealogy-proposal *c*))
      (instantiated (genealogy-instantiated *c*))
      (validated (genealogy-validated *c*))
      (receipt (genealogy-realization-receipt *c*)))
  ;; ── THE DUAL IDENTITY LEDGER ──────────────────────────────────────
  ;; Two columns because two different questions are being asked. The SUBJECT
  ;; column answers "which syntax is this?" and is deliberately stable. The
  ;; PHASE column answers "which proposal / instantiation / validation /
  ;; realization record is this?" and is deliberately distinct.
  (format t "~%  ~14A ~30A ~A~%" "stage" "subject form  [T]emplate/[C]losed" "phase object")
  (format t "  ~14A ~30A ~A~%" (make-string 13 :initial-element #\-)
          (make-string 17 :initial-element #\-)
          (make-string 17 :initial-element #\-))
  (flet ((row (stage subject phase)
           (format t "  ~14A ~30A ~A~%" stage (or subject "—") (or phase "—"))))
    (row "candidate datum" (short (genealogy-datum-identity *c*)) "—")
    (row "proposed [T]" (short (proposed-form-subject-identity proposal))
         (short (proposed-form-identity proposal)))
    (row "instant. [T]" (short (instantiated-form-template-subject-identity instantiated))
         "(template recorded)")
    (row "instant. [C]" (short (instantiated-form-subject-identity instantiated))
         (short (instantiated-form-identity instantiated)))
    (row "  bindings" "—" (short (instantiated-form-binding-identity instantiated)))
    (row "validated" (short (validated-form-subject-identity validated))
         (short (validated-form-identity validated)))
    (row "  val receipt" (short (form-validation-receipt-subject-identity
                                 (validated-form-receipt validated)))
         (short (form-validation-receipt-identity (validated-form-receipt validated))))
    (row "realized" (short (form-realization-receipt-subject-identity receipt))
         (short (form-realization-receipt-identity receipt)))
    (row "  result" (short (form-realization-receipt-result-identity receipt)) "—"))
  ;; The display is itself under test: if two distinct identities ever print the
  ;; same, this fails rather than quietly misinforming a reader.
  (check-abbreviations-discriminate
   (list (cons :proposed (proposed-form-identity proposal))
         (cons :instantiated (instantiated-form-identity instantiated))
         (cons :validated (validated-form-identity validated))
         (cons :validation-receipt (form-validation-receipt-identity
                                    (validated-form-receipt validated)))
         (cons :realization-receipt (form-realization-receipt-identity receipt))
         (cons :bindings (instantiated-form-binding-identity instantiated))
         (cons :subject (validated-form-subject-identity validated)))
   "phase-object ledger")

  (format t "~%")
  (desk "predecessor links, phase-object to phase-object:")
  (desk "  instantiated → proposed  ~A"
        (short (instantiated-form-predecessor-identity instantiated)))
  (desk "  validated    → instantiated  ~A"
        (short (validated-form-predecessor-identity validated)))
  (desk "  realization  → validated  ~A"
        (short (form-realization-receipt-validated-identity receipt)))
  (desk "environment declared-surface digest  ~A"
        (short (form-environment-content-digest *desk*)))
  (desk "result        ~A" (cd0 render-diagnostic (genealogy-result *c*)))

  (check (and (proposed-form-p proposal) (instantiated-form-p instantiated)
              (validated-form-p validated))
         "C passed through four distinct objects, none of them a re-labelled predecessor")
  (check (string= (instantiated-form-predecessor-identity instantiated)
                  (proposed-form-identity proposal))
         "the instantiated form names its proposal by PHASE identity")
  (check (= 3 (length (remove-duplicates
                       (list (proposed-form-identity proposal)
                             (instantiated-form-identity instantiated)
                             (validated-form-identity validated))
                       :test #'string=)))
         "the three phase identities are three distinct values, not one syntax identity repeated")
  (check (string= (proposed-form-subject-identity proposal)
                  (genealogy-datum-identity *c*))
         "the template subject is the candidate datum's own canonical identity")
  (check (not (string= (instantiated-form-template-subject-identity instantiated)
                       (instantiated-form-subject-identity instantiated)))
         "instantiation MOVED the subject: template ≠ closed form")
  (check (and (string= (instantiated-form-subject-identity instantiated)
                       (validated-form-subject-identity validated))
              (string= (validated-form-subject-identity validated)
                       (form-realization-receipt-subject-identity receipt)))
         "the closed subject is then preserved through validation and realization")
  (check (string= (form-realization-receipt-validated-identity receipt)
                  (validated-form-identity validated))
         "the realization receipt names exactly the form that was realized")
  (check (= 2 (length (validated-form-operator-identities validated)))
         "validation bound both resolved operator descriptors")
  (check (cd0 boolean-datum-p (genealogy-result *c*))
         "the result is a datum of the declared species")
  (check (cd0 boolean-datum-value (genealogy-result *c*))
         "the observed sequence does hash to the promised digest"))

;;; ── The negative control ──────────────────────────────────────────
(section "the same program, one datum different — the desk says no")

(defparameter *c-wrong*
  (hold-candidate :c (list (cons "observed" *observed*)
                           (cons "expected-digest"
                                 (cd0 make-string-datum "0000not-the-digest")))))
(check (and (genealogy-result *c-wrong*)
            (not (cd0 boolean-datum-value (genealogy-result *c-wrong*))))
       "a wrong promised digest realizes to FALSE, not to a refusal")
(check (not (string= (instantiated-form-identity (genealogy-instantiated *c-wrong*))
                     (instantiated-form-identity (genealogy-instantiated *c*))))
       "the two fillings are two different forms with two different identities")
(desk "A false answer is a lawful answer.  The desk distinguishes `no' from")
(desk "`I refuse to look' — they are different rows in this ledger.")

;;; ── Retention ─────────────────────────────────────────────────────
(section "the refused candidates, re-read after the lawful one succeeded")

(dolist (row (list *a* *b*))
  (let ((refusal (or (genealogy-proposal-refusal row)
                     (genealogy-validation-refusal row))))
    (format t "  ~S  ~S/~S  identity ~A~%"
            (genealogy-name row)
            (form-refusal-category refusal)
            (form-refusal-code refusal)
            (short (form-refusal-identity refusal)))))

(check (and (genealogy-proposal-refusal *a*) (genealogy-validation-refusal *b*))
       "both refusals are still live objects after C realized")
(check (every (lambda (row)
                (let ((refusal (or (genealogy-proposal-refusal row)
                                   (genealogy-validation-refusal row))))
                  (and (member (form-refusal-code refusal) (form-refusal-codes))
                       (plusp (length (form-refusal-detail refusal)))
                       (plusp (length (form-refusal-identity refusal))))))
              (list *a* *b*))
       "each retained refusal still carries a stable code, a detail and an identity")
(check (= 4 (length *ledger*))
       "the ledger holds every candidate the desk touched, refused or not")

;;; ── What this program does NOT establish ──────────────────────────
(section "what this program does NOT establish")
(format t "  The adapter is a labelled scripted fake; no model or provider was~%")
(format t "  reached, and nothing here is evidence that an external process~%")
(format t "  emitted any form.  Realization computed over data and returned data:~%")
(format t "  no claim, source basis, derivation basis, capability, authority or~%")
(format t "  warrant was minted, and no layer that could mint one was loaded.~%")
(format t "  Form /0 remains a candidate; the stranger audit is OWED.~%")

(format t "~%── A form emitted by a latent process arrives asleep. ──~%")
(format t "── Naming a consequential act is not performing one. ──~%")
(format t "── The refused candidates are part of what the desk knows. ──~%")

(format t "~%== de-forma-dormiente: ~D checks passed / ~D failed ==~%"
        (- *checks* *failed*) *failed*)

(when (plusp *failed*)
  (sb-ext:exit :code 1))
