;;;; form2.lisp — Language Form /2, Candidate /0.  "The form may be rewritten."
;;;;
;;;; Run: (load "form2.lisp")  — it loads Canonical Datum /0 and NOTHING ELSE.
;;;; It does not load, :use, or name Form /0, Form /1, Slice /0/1/2, Kernel /0
;;;; or Surface /0.  There is no `lisp-plus-form0::` and no `lisp-plus-form1::`
;;;; anywhere in this file, and there must never be.
;;;;
;;;;   A rewrite remembers what changed.
;;;;   It does not decide what the change means.
;;;;
;;;; THE SUBSTRATE MAKES ONE GUARANTEE TRUE BY CONSTRUCTION.  CD/0 exports
;;;; readers and constructors and NO MUTATOR of any kind — no replace, no
;;;; splice, no set.  So "the output is constructed without mutating the input"
;;;; is not a discipline this file keeps; it is a thing this file COULD NOT
;;;; VIOLATE if it tried.  The rebuild below descends with readers and
;;;; reconstructs the ancestor spine with constructors, because there is no
;;;; other way to do it.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (let ((here (or *load-truename* *default-pathname-defaults*)))
    (unless (find-package '#:lisp-plus-cd0)
      (load (merge-pathnames "../../canonical-datum/common-lisp/package.lisp" here))
      (load (merge-pathnames "../../canonical-datum/common-lisp/cd0.lisp" here)))
    (unless (find-package '#:lisp-plus-form2)
      (load (merge-pathnames "package.lisp" here)))))

(in-package #:lisp-plus-form2)

;;; ------------------------------------------------------------------
;;; CD/0 shorthands.  Every one is a plain call into the public surface.
;;; ------------------------------------------------------------------

(defun %datum-p (x) (lisp-plus-cd0:datum-p x))
(defun %equal (a b) (lisp-plus-cd0:equal-datum a b))
(defun %octets (d) (lisp-plus-cd0:canonical-octets d))
(defun %octet-count (d) (lisp-plus-cd0:octets-length (%octets d)))
(defun %text (s) (lisp-plus-cd0:make-string-datum s))
(defun %int (n) (lisp-plus-cd0:make-integer-datum n))
(defun %seq (list) (lisp-plus-cd0:make-sequence-datum list))
(defun %id (namespace path) (lisp-plus-cd0:make-identifier-datum namespace path))

(defun %snapshot (datum)
  "A full round trip, so the stored tree shares no structure whatever with
anything the caller retains.  CD/0 already copies on access; this makes the
independence total and is the same idiom Form /0 and Form /1 use."
  (lisp-plus-cd0:decode-exact (%octets datum)))

;;; ------------------------------------------------------------------
;;; Identity VALUES — lossless data, never text, never a digest.
;;; ------------------------------------------------------------------
;;;
;;; An identity is an immutable CD/0 BYTE-STRING datum holding the exact
;;; canonical octets of its payload.  Equality is exact CD/0 datum equality.
;;;
;;; THE REPRESENTATION IS NOT A STYLE CHOICE.  Form /0 composes identities as
;;; HEX TEXT; Form /1 repaired that to OCTETS because each link embedding a hex
;;; rendering of its predecessor DOUBLES per link, while embedding the octets
;;; costs one constant header.  Form /2 inherits Form /1's repair, and the
;;; entire resource analysis in the work order assumes it.  Reaching for
;;; OCTETS-TO-HEX anywhere in a composition path silently invalidates that
;;; analysis (work order EG-9).

(defun %identity (payload)
  (lisp-plus-cd0:make-bytes-datum (%octets payload)))

(defun identity-octets (identity)
  "The canonical encoded octet length of an identity VALUE — the unit every
ceiling in this layer is denominated in."
  (%octet-count identity))

(defun render-identity-hex (identity)
  "DIAGNOSTIC ONLY.  Never embedded into a later identity, never compared, and
never a content address."
  (lisp-plus-cd0:octets-to-hex (%octets identity)))

;;; ------------------------------------------------------------------
;;; Grammar, procedure and policy identity
;;; ------------------------------------------------------------------

(defun transformation-grammar-identity ()
  (%id '("lisp-plus-form2" "grammar") '("candidate" "0")))
(defun transformation-grammar-version () 1)

(defun transformation-procedure-identity ()
  (%id '("lisp-plus-form2" "procedure") '("replace" "at-path")))
(defun transformation-procedure-version () 1)

(defun transformation-policy-identity ()
  (%id '("lisp-plus-form2" "policy") '("candidate" "0")))
(defun transformation-policy-version () 1)

;;; Candidate /0 EXPERIMENTAL ceilings, not universal Lisp+ limits.
;;;
;;; The two non-datum ceilings exist because without them the envelope relation
;;; is UNFALSIFIABLE: an unbounded occurrence tag or encoded path can consume
;;; any margin, so "slack" would be a hope rather than a number.
(defun transformation-policy-max-input-octets () 16384)
(defun transformation-policy-max-output-octets () 16384)
(defun transformation-policy-max-path-depth () 32)
(defun transformation-policy-max-path-octets () 4096)
(defun transformation-policy-max-occurrence-tag-octets () 1024)
(defun transformation-policy-max-identity-octets () 65536)
(defun transformation-policy-identity-tail-reserve-octets () 4096)

(defun %identity-ceiling ()
  "The envelope minus the reserve.  Every identity this layer mints must fit
here, so that the terminal receipt identity is provably constructible."
  (- (transformation-policy-max-identity-octets)
     (transformation-policy-identity-tail-reserve-octets)))

;;; ------------------------------------------------------------------
;;; The refusal-code catalogue — ONE table, two DERIVED lists
;;; ------------------------------------------------------------------
;;;
;;; Entries are (code class reachability note).
;;;
;;; class         :protocol-refusal | :integrity-alarm
;;; reachability  :public-api | :internal-planted-fault-only
;;;
;;; Two codes an earlier draft advertised are ABSENT and must stay absent:
;;; :INPUT-NOT-A-DATUM and :REPLACEMENT-NOT-A-DATUM.  Both fields live INSIDE a
;;; CD/0 record, and every value inside a CD/0 record is necessarily CD/0 data
;;; (MAKE-RECORD-ENTRY calls %ENSURE-DATUM).  A caller cannot put a non-datum
;;; there, so the codes had no reachable fixture — false affordances, which is a
;;; defect this lane already owns a documented counterexample for.  Only the
;;; OUTERMOST argument can fail to be a datum: :PROPOSAL-NOT-A-DATUM.

(defstruct (transformation-refusal-code-entry
            (:constructor %make-code-entry (code class reachability %note))
            (:copier nil)
            (:predicate transformation-refusal-code-entry-p))
  (code nil :read-only t)
  (class nil :read-only t)
  (reachability nil :read-only t)
  (%note "" :read-only t))

(defun transformation-refusal-code-entry-note (entry)
  ;; Fresh copy: Common Lisp strings are MUTABLE, and a reader that hands out
  ;; the stored one lets a caller edit the catalogue after the fact.
  (copy-seq (transformation-refusal-code-entry-%note entry)))

(defparameter +transformation-refusal-code-catalog+
  (list
   ;; ---- DOOR 1, propose: grammar and policy.  All publicly reachable. ----
   (%make-code-entry :proposal-not-a-datum :protocol-refusal :public-api
                     "the outermost argument to door 1 was not a CD/0 datum")
   (%make-code-entry :proposal-node-not-a-sequence :protocol-refusal :public-api
                     "the proposal node is not a CD/0 sequence")
   (%make-code-entry :proposal-node-arity :protocol-refusal :public-api
                     "the proposal node is not exactly [head, body]")
   (%make-code-entry :head-not-identifier :protocol-refusal :public-api
                     "the production head is not an identifier datum")
   (%make-code-entry :not-a-replacement-proposal :protocol-refusal :public-api
                     "the head names no production of the Form /2 grammar")
   (%make-code-entry :proposal-body-not-a-record :protocol-refusal :public-api
                     "the proposal body is not a CD/0 record")
   (%make-code-entry :proposal-field-missing :protocol-refusal :public-api
                     "a required proposal field is absent; includes the tag")
   (%make-code-entry :proposal-field-unknown :protocol-refusal :public-api
                     "the proposal body carries a field the grammar does not name")
   (%make-code-entry :path-not-a-sequence :protocol-refusal :public-api
                     "the path field is not a CD/0 sequence")
   (%make-code-entry :path-step-not-a-sequence :protocol-refusal :public-api
                     "a path step is not a CD/0 sequence")
   (%make-code-entry :path-step-arity :protocol-refusal :public-api
                     "a path step is not exactly [kind-tag, operand]")
   (%make-code-entry :path-step-kind-unknown :protocol-refusal :public-api
                     "a path step tag is neither the index tag nor the key tag")
   (%make-code-entry :path-index-not-a-nonnegative-integer :protocol-refusal :public-api
                     "an index step operand is not an integer >= 0")
   (%make-code-entry :path-step-key-not-an-identifier :protocol-refusal :public-api
                     "a key step operand is not an identifier datum")
   (%make-code-entry :path-depth-exceeded :protocol-refusal :public-api
                     "the path is deeper than the policy depth ceiling")
   (%make-code-entry :path-octets-exceeded :protocol-refusal :public-api
                     "the encoded path exceeds the policy path ceiling")
   (%make-code-entry :occurrence-tag-octets-exceeded :protocol-refusal :public-api
                     "the proposal occurrence tag exceeds the policy tag ceiling")
   (%make-code-entry :input-octets-exceeded :protocol-refusal :public-api
                     "the input datum exceeds the policy input ceiling")
   ;; ---- DOOR 2, apply ----
   (%make-code-entry :not-a-replacement-proposal-object :protocol-refusal :public-api
                     "door 2 was handed something other than a door-1 proposal object")
   (%make-code-entry :path-step-family-mismatch :protocol-refusal :public-api
                     "an index step met a record, or a key step met a sequence")
   (%make-code-entry :path-index-out-of-range :protocol-refusal :public-api
                     "an index step names a position the sequence does not have")
   (%make-code-entry :path-key-absent :protocol-refusal :public-api
                     "a key step names a field the record does not carry")
   (%make-code-entry :expected-old-mismatch :protocol-refusal :public-api
                     "the observed subtree is not the declared expected-old")
   (%make-code-entry :replacement-equals-observed-old :protocol-refusal :public-api
                     "the replacement equals what is actually there; no event to record")
   (%make-code-entry :output-octets-exceeded :protocol-refusal :public-api
                     "the staged successor exceeds the policy output ceiling")
   (%make-code-entry :identity-octets-exceeded :protocol-refusal :public-api
                     "an identity this layer would mint exceeds envelope minus reserve")
   ;; NOT :PUBLIC-API, and the reason is a measured fact rather than a taste.
   ;; CD/0's default MAX-TOTAL-RECORD-KEY-OCTETS is 1,048,576.  Candidate /0's
   ;; input ceiling is 16,384.  No ADMITTED input can therefore carry enough
   ;; record-key work to reach this budget, so no public call can provoke this
   ;; code — it is a FALSE AFFORDANCE with respect to the public API and is
   ;; classified as one rather than advertised as reachable.
   ;;
   ;; It is nonetheless kept, with a planted-fault fixture, because the handler
   ;; it belongs to is real and load-bearing: the two ceilings are POLICY, a
   ;; future candidate may raise the input ceiling or a host may tighten CD/0's
   ;; budget, and on that day the reclassification path must already work and
   ;; already be tested.  A handler with no fixture is the thing this lane
   ;; refuses; a fixture that has to plant its own fault is the honest way to
   ;; test a path the current ceilings make unreachable.
   (%make-code-entry :rebuild-record-key-work-exceeded :protocol-refusal
                     :internal-planted-fault-only
                     "CD/0 refused the spine rebuild on its record-key work budget; UNREACHABLE from the public API while the input ceiling (16384) sits far below CD/0's record-key budget (1048576)")
   ;; ---- INTEGRITY ALARMS: package-internal, planted-fault-reachable ONLY ----
   ;; These exist because the receipt constructor VERIFIES its own derived
   ;; projections, and a verification with no failure path is not a
   ;; verification.  A gate that has never fired is untested, not passing.
   (%make-code-entry :observed-old-projection-mismatch :integrity-alarm
                     :internal-planted-fault-only
                     "receipt construction found stored observed-old != expected-old")
   (%make-code-entry :output-identity-projection-mismatch :integrity-alarm
                     :internal-planted-fault-only
                     "receipt construction found stored output identity != recomputed")
   (%make-code-entry :procedure-version-mismatch :integrity-alarm
                     :internal-planted-fault-only
                     "the acting procedure version is not the package's own"))
  "The ONE catalogue.  Both public lists below are derived from it, never
maintained beside it, so their union is the complete code set by construction.")

(defun transformation-refusal-code-catalog ()
  (copy-list +transformation-refusal-code-catalog+))

(defun %codes-of-class (class)
  (mapcar #'transformation-refusal-code-entry-code
          (remove-if-not (lambda (e)
                           (eq class (transformation-refusal-code-entry-class e)))
                         +transformation-refusal-code-catalog+)))

(defun transformation-protocol-refusal-codes () (%codes-of-class :protocol-refusal))
(defun transformation-integrity-alarm-codes () (%codes-of-class :integrity-alarm))

;;; ------------------------------------------------------------------
;;; Retained refusals — objects with identities, never printed conditions
;;; ------------------------------------------------------------------

(defstruct (form-transformation-refusal
            (:constructor %make-refusal)
            (:copier nil)
            (:predicate form-transformation-refusal-p))
  (phase nil :read-only t)
  (category nil :read-only t)
  (code nil :read-only t)
  (path nil :read-only t)
  (offending nil :read-only t)
  (%detail "" :read-only t)
  (identity nil :read-only t)
  ;; CD/0 passthrough.  NIL unless an upstream CD/0 failure was reclassified.
  (upstream-category nil :read-only t)
  (upstream-code nil :read-only t)
  (upstream-stage nil :read-only t)
  (%upstream-detail nil :read-only t)
  (%upstream-budget-id nil :read-only t))

(defun form-transformation-refusal-detail (refusal)
  (copy-seq (form-transformation-refusal-%detail refusal)))
(defun form-transformation-refusal-upstream-detail (refusal)
  (let ((d (form-transformation-refusal-%upstream-detail refusal)))
    (if (stringp d) (copy-seq d) d)))
(defun form-transformation-refusal-upstream-budget-id (refusal)
  (let ((b (form-transformation-refusal-%upstream-budget-id refusal)))
    (and b (copy-seq b))))

(define-condition form-transformation-refused (error)
  ((refusal :initarg :refusal :reader form-transformation-refused-refusal))
  (:report (lambda (c s)
             (let ((r (form-transformation-refused-refusal c)))
               (format s "Form /2 ~A refusal (~A . ~A): ~A"
                       (form-transformation-refusal-phase r)
                       (form-transformation-refusal-category r)
                       (form-transformation-refusal-code r)
                       (form-transformation-refusal-detail r))))))

(defun %key-datum (name) (%text (string-downcase (symbol-name name))))

(defun %refuse (phase category code &key path offending (detail "") tag
                                         upstream-category upstream-code
                                         upstream-stage upstream-detail
                                         upstream-budget-id)
  "Build a retained refusal.  Every advertised code must reach here from a
fixture, or it does not ship."
  (%make-refusal
   :phase phase :category category :code code
   :path path
   :offending (and offending (%datum-p offending) (%snapshot offending))
   :%detail detail
   :upstream-category upstream-category
   :upstream-code upstream-code
   :upstream-stage upstream-stage
   :%upstream-detail upstream-detail
   :%upstream-budget-id upstream-budget-id
   :identity (%identity
              (%seq (list (%text ":refusal")
                          (if tag (%snapshot tag) (%text ":no-tag"))
                          (%key-datum phase)
                          (%key-datum category)
                          (%key-datum code)
                          (if path (%snapshot path) (%text ":no-path"))
                          (transformation-procedure-identity)
                          (%int (transformation-procedure-version)))))))

;;; ------------------------------------------------------------------
;;; The path grammar (work order §4.1)
;;; ------------------------------------------------------------------
;;;
;;; A record step carries an IDENTIFIER datum, never an arbitrary datum and
;;; never an integer index.  Two reasons, both read at the source:
;;;
;;;   MAKE-RECORD-ENTRY refuses any non-identifier key (cd0.lisp:732), so a key
;;;   step of any other family is unsatisfiable by construction; and
;;;
;;;   a record may NOT be addressed positionally, because CD/0 derives canonical
;;;   field order from the encoded key bytes.  A record's integer position is
;;;   not stable under key edits: the same index can name a different field
;;;   after an unrelated change.  An index into a record would be an address
;;;   that silently re-points.
;;;
;;; STEPS ARE TAGGED.  Without tags a step's meaning would have to be inferred
;;; from the family of the node it lands on — so the same path would mean
;;; different things applied to different data, and a path could not be checked
;;; for well-formedness without a datum in hand.  Tagged steps make the path
;;; independently well-formed and make a kind mismatch a REFUSAL rather than a
;;; silent reinterpretation.

(defun %index-tag () (%id '("lisp-plus-form2") '("step" "index")))
(defun %key-tag () (%id '("lisp-plus-form2") '("step" "key")))

(defun index-step (n)
  (check-type n (integer 0))
  (%seq (list (%index-tag) (%int n))))

(defun key-step (identifier-datum)
  (%seq (list (%key-tag) identifier-datum)))

(defun path-datum (&rest steps) (%seq steps))

(defun %parse-path (path-datum)
  "PATH-DATUM -> (values parsed-steps refusal).  Parsed steps are an internal
list of (:index . n) / (:key . identifier-datum); the list never escapes."
  (unless (lisp-plus-cd0:sequence-datum-p path-datum)
    (return-from %parse-path
      (values nil (%refuse :propose :grammar :path-not-a-sequence
                           :offending path-datum
                           :detail "the path field must be a CD/0 sequence"))))
  (let ((depth (lisp-plus-cd0:sequence-datum-length path-datum)))
    (when (> depth (transformation-policy-max-path-depth))
      (return-from %parse-path
        (values nil (%refuse :propose :policy :path-depth-exceeded
                             :path path-datum
                             :detail (format nil "path depth ~D exceeds ~D"
                                             depth (transformation-policy-max-path-depth))))))
    (let ((steps '()))
      (dotimes (i depth (values (nreverse steps) nil))
        (let ((step (lisp-plus-cd0:sequence-datum-ref path-datum i)))
          (unless (lisp-plus-cd0:sequence-datum-p step)
            (return-from %parse-path
              (values nil (%refuse :propose :grammar :path-step-not-a-sequence
                                   :path path-datum :offending step
                                   :detail (format nil "step ~D is not a sequence" i)))))
          (unless (= 2 (lisp-plus-cd0:sequence-datum-length step))
            (return-from %parse-path
              (values nil (%refuse :propose :grammar :path-step-arity
                                   :path path-datum :offending step
                                   :detail (format nil "step ~D is not [kind, operand]" i)))))
          (let ((kind (lisp-plus-cd0:sequence-datum-ref step 0))
                (operand (lisp-plus-cd0:sequence-datum-ref step 1)))
            (cond
              ((%equal kind (%index-tag))
               (unless (and (lisp-plus-cd0:integer-datum-p operand)
                            (>= (lisp-plus-cd0:integer-datum-value operand) 0))
                 (return-from %parse-path
                   (values nil (%refuse :propose :grammar
                                        :path-index-not-a-nonnegative-integer
                                        :path path-datum :offending operand
                                        :detail (format nil "step ~D index operand" i)))))
               (push (cons :index (lisp-plus-cd0:integer-datum-value operand)) steps))
              ((%equal kind (%key-tag))
               (unless (lisp-plus-cd0:identifier-datum-p operand)
                 (return-from %parse-path
                   (values nil (%refuse :propose :grammar
                                        :path-step-key-not-an-identifier
                                        :path path-datum :offending operand
                                        :detail (format nil "step ~D key operand" i)))))
               (push (cons :key operand) steps))
              (t
               (return-from %parse-path
                 (values nil (%refuse :propose :grammar :path-step-kind-unknown
                                      :path path-datum :offending kind
                                      :detail (format nil "step ~D kind tag" i))))))))))))

;;; ------------------------------------------------------------------
;;; The proposal production (work order §4.2)
;;; ------------------------------------------------------------------
;;;
;;;   proposal ::= [ id(["lisp-plus-form2"], ["replace","at-path"]) , <record> ]
;;;
;;; THE HEAD CARRIES THE OPERATION.  There is no `operation` field, no handler
;;; table, and no :UNKNOWN-TRANSFORMATION-OPERATION code.  A second edit
;;; operation would be a second production head, refused at that boundary with
;;; one honest code.

(defun %production-head () (%id '("lisp-plus-form2") '("replace" "at-path")))

(defun %field (name) (%id '("lisp-plus-form2") (list "field" name)))
(defun %field-input () (%field "input"))
(defun %field-path () (%field "path"))
(defun %field-expected-old () (%field "expected-old"))
(defun %field-replacement () (%field "replacement"))
(defun %field-tag () (%field "occurrence-tag"))

(defun %known-fields ()
  (list (%field-input) (%field-path) (%field-expected-old)
        (%field-replacement) (%field-tag)))

(defun replacement-proposal-datum (&key input path expected-old replacement
                                        occurrence-tag)
  "Assemble the inert CD/0 proposal datum.  MINTS NOTHING: door 1 may still
refuse what this returns.  A caller may build the identical datum with raw CD/0
constructors; this is ergonomics, never authority."
  (%seq (list (%production-head)
              (lisp-plus-cd0:make-record-datum
               (list (lisp-plus-cd0:make-record-entry (%field-input) input)
                     (lisp-plus-cd0:make-record-entry (%field-path) path)
                     (lisp-plus-cd0:make-record-entry (%field-expected-old) expected-old)
                     (lisp-plus-cd0:make-record-entry (%field-replacement) replacement)
                     (lisp-plus-cd0:make-record-entry (%field-tag) occurrence-tag))))))

;;; ------------------------------------------------------------------
;;; The proposal object — immutable, snapshotted, minted only by door 1
;;; ------------------------------------------------------------------

(defstruct (replacement-proposal
            (:constructor %make-proposal)
            (:copier nil)
            (:predicate replacement-proposal-p))
  (%input nil :read-only t)
  (input-datum-identity nil :read-only t)
  (%path nil :read-only t)
  (%parsed-path nil :read-only t)
  (%expected-old nil :read-only t)
  (%replacement nil :read-only t)
  (%occurrence-tag nil :read-only t)
  (identity nil :read-only t))

;; Readers return the stored IMMUTABLE CD/0 data.  CD/0 data cannot be mutated
;; through any public surface, so handing back the stored object aliases nothing
;; a caller can change (work order NC-17).
(defun replacement-proposal-path (p) (replacement-proposal-%path p))
(defun replacement-proposal-expected-old (p) (replacement-proposal-%expected-old p))
(defun replacement-proposal-replacement (p) (replacement-proposal-%replacement p))
(defun replacement-proposal-occurrence-tag (p) (replacement-proposal-%occurrence-tag p))
(defun replacement-proposal-procedure-identity (p)
  (declare (ignore p)) (transformation-procedure-identity))
(defun replacement-proposal-procedure-version (p)
  (declare (ignore p)) (transformation-procedure-version))
(defun replacement-proposal-policy-identity (p)
  (declare (ignore p)) (transformation-policy-identity))
(defun replacement-proposal-policy-version (p)
  (declare (ignore p)) (transformation-policy-version))

;;; ------------------------------------------------------------------
;;; DOOR 1 — PROPOSE.  Grammar only.  The input's interior is NEVER touched.
;;; ------------------------------------------------------------------

(defun try-propose-replacement (proposal-datum)
  "(values PROPOSAL nil) | (values nil REFUSAL).

Door 1 validates the exact Candidate /0 grammar, snapshots every retained
datum, mints an immutable proposal object and a proposal identity, and performs
NO structural replacement.  It does not resolve the path and does not compare
anything to EXPECTED-OLD — a proposal that can never apply is still a lawful
proposal.  The proposal is a description a caller wrote; the application is an
encounter with a real datum."
  (unless (%datum-p proposal-datum)
    (return-from try-propose-replacement
      (values nil (%refuse :propose :boundary :proposal-not-a-datum
                           :detail "door 1 requires a CD/0 datum"))))
  (unless (lisp-plus-cd0:sequence-datum-p proposal-datum)
    (return-from try-propose-replacement
      (values nil (%refuse :propose :grammar :proposal-node-not-a-sequence
                           :offending proposal-datum
                           :detail "the proposal node must be a CD/0 sequence"))))
  (unless (= 2 (lisp-plus-cd0:sequence-datum-length proposal-datum))
    (return-from try-propose-replacement
      (values nil (%refuse :propose :grammar :proposal-node-arity
                           :offending proposal-datum
                           :detail "the proposal node must be exactly [head, body]"))))
  (let ((head (lisp-plus-cd0:sequence-datum-ref proposal-datum 0))
        (body (lisp-plus-cd0:sequence-datum-ref proposal-datum 1)))
    (unless (lisp-plus-cd0:identifier-datum-p head)
      (return-from try-propose-replacement
        (values nil (%refuse :propose :grammar :head-not-identifier
                             :offending head
                             :detail "the production head must be an identifier"))))
    (unless (%equal head (%production-head))
      (return-from try-propose-replacement
        (values nil (%refuse :propose :grammar :not-a-replacement-proposal
                             :offending head
                             :detail "this head names no production of the Form /2 grammar"))))
    (unless (lisp-plus-cd0:record-datum-p body)
      (return-from try-propose-replacement
        (values nil (%refuse :propose :grammar :proposal-body-not-a-record
                             :offending body
                             :detail "the proposal body must be a CD/0 record"))))
    ;; Unknown fields refuse before missing ones are reported, so a caller who
    ;; misspelled a field name is told THAT, not that the right one is absent.
    (dotimes (i (lisp-plus-cd0:record-datum-size body))
      (let ((k (lisp-plus-cd0:record-datum-key-at body i)))
        (unless (member k (%known-fields) :test #'%equal)
          (return-from try-propose-replacement
            (values nil (%refuse :propose :grammar :proposal-field-unknown
                                 :offending k
                                 :detail "the grammar names no such field"))))))
    (let (input path expected-old replacement tag)
      (dolist (spec (list (list (%field-input) 'input)
                          (list (%field-path) 'path)
                          (list (%field-expected-old) 'expected-old)
                          (list (%field-replacement) 'replacement)
                          (list (%field-tag) 'tag)))
        (multiple-value-bind (value found)
            (lisp-plus-cd0:record-datum-ref body (first spec))
          (unless found
            (return-from try-propose-replacement
              (values nil (%refuse :propose :grammar :proposal-field-missing
                                   :offending (first spec)
                                   :detail (format nil "required field ~(~A~) absent"
                                                   (second spec))))))
          (ecase (second spec)
            (input (setf input value))
            (path (setf path value))
            (expected-old (setf expected-old value))
            (replacement (setf replacement value))
            (tag (setf tag value)))))
      ;; Every value above came out of a CD/0 record and is therefore
      ;; necessarily CD/0 data.  That is exactly why :INPUT-NOT-A-DATUM and
      ;; :REPLACEMENT-NOT-A-DATUM are absent from the catalogue.
      (multiple-value-bind (parsed refusal) (%parse-path path)
        (when refusal (return-from try-propose-replacement (values nil refusal)))
        ;; POLICY BEFORE IDENTITY.
        (let ((path-octets (%octet-count path))
              (tag-octets (%octet-count tag))
              (input-octets (%octet-count input)))
          (when (> path-octets (transformation-policy-max-path-octets))
            (return-from try-propose-replacement
              (values nil (%refuse :propose :policy :path-octets-exceeded
                                   :path path :tag tag
                                   :detail (format nil "encoded path ~D octets exceeds ~D"
                                                   path-octets
                                                   (transformation-policy-max-path-octets))))))
          (when (> tag-octets (transformation-policy-max-occurrence-tag-octets))
            (return-from try-propose-replacement
              (values nil (%refuse :propose :policy :occurrence-tag-octets-exceeded
                                   :path path :offending tag
                                   :detail (format nil "occurrence tag ~D octets exceeds ~D"
                                                   tag-octets
                                                   (transformation-policy-max-occurrence-tag-octets))))))
          (when (> input-octets (transformation-policy-max-input-octets))
            (return-from try-propose-replacement
              (values nil (%refuse :propose :policy :input-octets-exceeded
                                   :path path :tag tag
                                   :detail (format nil "input ~D octets exceeds ~D"
                                                   input-octets
                                                   (transformation-policy-max-input-octets)))))))
        (let* ((input* (%snapshot input))
               (path* (%snapshot path))
               (expected* (%snapshot expected-old))
               (replacement* (%snapshot replacement))
               (tag* (%snapshot tag))
               (input-id (%identity input*))
               (proposal-id
                 (%identity (%seq (list (%text ":proposal")
                                        input-id
                                        path*
                                        expected*
                                        replacement*
                                        (transformation-procedure-identity)
                                        (%int (transformation-procedure-version))
                                        tag*
                                        (transformation-policy-identity)
                                        (%int (transformation-policy-version)))))))
          (when (> (identity-octets proposal-id) (%identity-ceiling))
            (return-from try-propose-replacement
              (values nil (%refuse :propose :policy :identity-octets-exceeded
                                   :path path :tag tag
                                   :detail (format nil "proposal identity ~D octets exceeds ~D"
                                                   (identity-octets proposal-id)
                                                   (%identity-ceiling))))))
          (values (%make-proposal :%input input*
                                  :input-datum-identity input-id
                                  :%path path*
                                  :%parsed-path parsed
                                  :%expected-old expected*
                                  :%replacement replacement*
                                  :%occurrence-tag tag*
                                  :identity proposal-id)
                  nil))))))

(defun propose-replacement (proposal-datum)
  "The loud twin of TRY-PROPOSE-REPLACEMENT.  Signals the same refusal object."
  (multiple-value-bind (proposal refusal) (try-propose-replacement proposal-datum)
    (if refusal (error 'form-transformation-refused :refusal refusal) proposal)))

;;; ------------------------------------------------------------------
;;; Path resolution and the pure rebuild (both INTERNAL)
;;; ------------------------------------------------------------------
;;;
;;; Neither is exported.  A public resolver would make Form /2 the de-facto
;;; owner of CD/0 addressing — a capability grab wearing a convenience.

(defun %resolve (node steps path-datum)
  "(values SUBTREE nil) | (values nil REFUSAL).  Read-only descent."
  (if (null steps)
      (values node nil)
      (let* ((step (first steps))
             (kind (car step))
             (operand (cdr step)))
        (ecase kind
          (:index
           (unless (lisp-plus-cd0:sequence-datum-p node)
             (return-from %resolve
               (values nil (%refuse :apply :path :path-step-family-mismatch
                                    :path path-datum :offending node
                                    :detail "an index step met a node that is not a sequence"))))
           (unless (< operand (lisp-plus-cd0:sequence-datum-length node))
             (return-from %resolve
               (values nil (%refuse :apply :path :path-index-out-of-range
                                    :path path-datum
                                    :detail (format nil "index ~D of a ~D-element sequence"
                                                    operand
                                                    (lisp-plus-cd0:sequence-datum-length node))))))
           (%resolve (lisp-plus-cd0:sequence-datum-ref node operand) (rest steps) path-datum))
          (:key
           (unless (lisp-plus-cd0:record-datum-p node)
             (return-from %resolve
               (values nil (%refuse :apply :path :path-step-family-mismatch
                                    :path path-datum :offending node
                                    :detail "a key step met a node that is not a record"))))
           (multiple-value-bind (value found) (lisp-plus-cd0:record-datum-ref node operand)
             (unless found
               (return-from %resolve
                 (values nil (%refuse :apply :path :path-key-absent
                                      :path path-datum :offending operand
                                      :detail "the record carries no such key"))))
             (%resolve value (rest steps) path-datum)))))))

;;; PLANTED-FAULT HOOKS — internal, unexported, NIL in every ordinary run.
;;; They exist so the three integrity alarms have reachable fixtures.  A gate
;;; that has never fired is untested, not passing.
;;;
;;; POSITION IS LOAD-BEARING (Lexical Source Erratum 0.1, 2026-08-02): this
;;; block sits ABOVE %REBUILD because %REBUILD reads
;;; *%FAULT-REBUILD-CD0-FAILURE* in its first form.  While the block sat below
;;; the receipt section, a fresh source load compiled that read before any
;;; declaration existed and SBCL reported "undefined variable" — a real
;;; non-style WARNING that the selftest's *ERROR-OUTPUT* sink then swallowed.
;;; The block was MOVED, not rewritten: same names, same NIL defaults, same
;;; docstring, same unexported status, same fixture behaviour.  Keep new fault
;;; hooks here, above their first reader.
(defvar *%fault-rebuild-cd0-failure* nil
  "When non-NIL, %REBUILD signals the exact CD/0 record-key budget failure, so
the reclassification path of §10.4 has a fixture.  See the catalogue note: the
code is unreachable from the public API while the input ceiling sits far below
CD/0's record-key budget, and a handler with no fixture is what this lane
refuses.")
(defvar *%fault-observed-old* nil)
(defvar *%fault-output-identity* nil)
(defvar *%fault-procedure-version* nil)

(defun %rebuild (node steps replacement)
  "A PURE REBUILD.  Descend with readers, reconstruct the ancestor spine with
constructors.  CD/0 exposes no mutator, so this is the only possible shape and
the input cannot be touched.  Preconditions are already checked by %RESOLVE;
this function may still signal CD0-FAILURE on a resource budget, which door 2
catches and reclassifies."
  (when *%fault-rebuild-cd0-failure*
    (error 'lisp-plus-cd0:cd0-failure
           :category "ResourceRefusal" :code "RecordKeyWorkBudgetExceeded"
           :stage "host-import" :detail 1234567
           :budget-id (lisp-plus-cd0:budget-id (lisp-plus-cd0:default-resource-budget))))
  (if (null steps)
      replacement
      (let* ((step (first steps))
             (kind (car step))
             (operand (cdr step)))
        (ecase kind
          (:index
           (let ((n (lisp-plus-cd0:sequence-datum-length node))
                 (elements '()))
             (dotimes (i n)
               (push (if (= i operand)
                         (%rebuild (lisp-plus-cd0:sequence-datum-ref node i)
                                   (rest steps) replacement)
                         (lisp-plus-cd0:sequence-datum-ref node i))
                     elements))
             (%seq (nreverse elements))))
          (:key
           (let ((n (lisp-plus-cd0:record-datum-size node))
                 (entries '()))
             (dotimes (i n)
               (let ((k (lisp-plus-cd0:record-datum-key-at node i))
                     (v (lisp-plus-cd0:record-datum-value-at node i)))
                 (push (lisp-plus-cd0:make-record-entry
                        k
                        (if (%equal k operand)
                            (%rebuild v (rest steps) replacement)
                            v))
                       entries)))
             (lisp-plus-cd0:make-record-datum (nreverse entries))))))))

;;; ------------------------------------------------------------------
;;; The receipt — and the two DERIVED PROJECTIONS it verifies
;;; ------------------------------------------------------------------

(defstruct (form-transformation-receipt
            (:constructor %make-receipt)
            (:copier nil)
            (:predicate form-transformation-receipt-p))
  (identity nil :read-only t)
  (occurrence-identity nil :read-only t)
  (proposal-identity nil :read-only t)
  (input-datum-identity nil :read-only t)
  (output-datum-identity nil :read-only t)
  (path nil :read-only t)
  (expected-old nil :read-only t)
  (observed-old nil :read-only t)
  (replacement nil :read-only t)
  (disposition nil :read-only t))

(defun form-transformation-receipt-procedure-identity (r)
  (declare (ignore r)) (transformation-procedure-identity))
(defun form-transformation-receipt-procedure-version (r)
  (declare (ignore r)) (transformation-procedure-version))
(defun form-transformation-receipt-policy-identity (r)
  (declare (ignore r)) (transformation-policy-identity))
(defun form-transformation-receipt-policy-version (r)
  (declare (ignore r)) (transformation-policy-version))

(defconstant +disposition-replaced+ :replaced-at-path
  "Names the OPERATION THAT RAN, not an adverb about its character.  The layer
may say where and what; it may never say better, same, or right.")

(defun %build-receipt (proposal observed-old successor output-identity path-datum)
  "(values RECEIPT nil) | (values nil REFUSAL).

THE NARROW THEOREM this rests on.  Over SUCCESSFUL TRANSITIONS PRODUCED BY THE
FIXED PACKAGE PROCEDURE UNDER THE STATED PRECONDITIONS, exact CD/0 encoding
makes OBSERVED-OLD and OUTPUT-DATUM-IDENTITY derivable from the committed
proposal payload.  Omitting them from the identity therefore loses no
discrimination AMONG SUCH TRANSITIONS.

\"Lawful\" was the earlier word and it was too broad: it reads as a claim about
every transition the world might call lawful, when the guarantee holds only for
transitions THIS procedure produced, at THIS version, with the preconditions
actually checked.

WHAT THAT DOES NOT ESTABLISH: resilience to a misversioned procedure;
nondeterministic implementation behaviour; internal object corruption; forged
package-internal receipts; persistence-time integrity.

Because the two fields are DERIVABLE they are not trusted stored values — they
are projections this constructor RECOMPUTES AND CHECKS.  There is no public
receipt constructor, so this is the only path by which a receipt exists."
  (let ((acting-version (or *%fault-procedure-version*
                            (transformation-procedure-version))))
    (unless (eql acting-version (transformation-procedure-version))
      (return-from %build-receipt
        (values nil (%refuse :receipt :integrity :procedure-version-mismatch
                             :path path-datum
                             :tag (replacement-proposal-occurrence-tag proposal)
                             :detail (format nil "acting procedure version ~A is not ~A"
                                             acting-version
                                             (transformation-procedure-version))))))
    (let ((stored-observed (or *%fault-observed-old* observed-old))
          (stored-output-id (or *%fault-output-identity* output-identity)))
      ;; PROJECTION 1 — observed-old must be the declared expected-old.
      (unless (%equal stored-observed (replacement-proposal-expected-old proposal))
        (return-from %build-receipt
          (values nil (%refuse :receipt :integrity :observed-old-projection-mismatch
                               :path path-datum
                               :tag (replacement-proposal-occurrence-tag proposal)
                               :detail "stored observed-old is not the declared expected-old"))))
      ;; PROJECTION 2 — the output identity must be the identity of the datum
      ;; the procedure actually produced, recomputed here and compared.
      (unless (%equal stored-output-id (%identity successor))
        (return-from %build-receipt
          (values nil (%refuse :receipt :integrity :output-identity-projection-mismatch
                               :path path-datum
                               :tag (replacement-proposal-occurrence-tag proposal)
                               :detail "stored output identity is not the recomputed identity"))))
      (let* ((occurrence-id
               (%identity (%seq (list (%text ":occurrence")
                                      (replacement-proposal-identity proposal)
                                      (%key-datum +disposition-replaced+)))))
             (receipt-id
               (%identity (%seq (list (%text ":receipt")
                                      occurrence-id
                                      (transformation-policy-identity)
                                      (%int (transformation-policy-version)))))))
        (dolist (pair (list (cons occurrence-id "occurrence")
                            (cons receipt-id "receipt")))
          (when (> (identity-octets (car pair)) (%identity-ceiling))
            (return-from %build-receipt
              (values nil (%refuse :apply :policy :identity-octets-exceeded
                                   :path path-datum
                                   :tag (replacement-proposal-occurrence-tag proposal)
                                   :detail (format nil "~A identity ~D octets exceeds ~D"
                                                   (cdr pair)
                                                   (identity-octets (car pair))
                                                   (%identity-ceiling)))))))
        (values (%make-receipt
                 :identity receipt-id
                 :occurrence-identity occurrence-id
                 :proposal-identity (replacement-proposal-identity proposal)
                 :input-datum-identity (replacement-proposal-input-datum-identity proposal)
                 :output-datum-identity stored-output-id
                 :path (replacement-proposal-path proposal)
                 :expected-old (replacement-proposal-expected-old proposal)
                 :observed-old stored-observed
                 :replacement (replacement-proposal-replacement proposal)
                 :disposition +disposition-replaced+)
                nil)))))

;;; ------------------------------------------------------------------
;;; DOOR 2 — APPLY.  The encounter with the actual datum.
;;; ------------------------------------------------------------------

(defun try-apply-replacement (proposal)
  "(values SUCCESSOR RECEIPT nil) | (values nil nil REFUSAL).

THREE VALUES ON BOTH BRANCHES, so a caller destructuring the result cannot read
a refusal as a successor.

THE STAGING LAW is OBSERVABILITY, not pre-allocation prediction: no successor
and no receipt becomes observable to the caller until every path, precondition,
resource, identity and consistency check has passed.  Form /2 performs a pure
immutable rebuild, not an external governed act — an unreturned candidate datum
is garbage, not a side effect — so predicting exact nested CD/0 output size
before allocating anything would require a second hand-written copy of CD/0's
encoding arithmetic that could disagree with the encoder."
  (unless (replacement-proposal-p proposal)
    (return-from try-apply-replacement
      (values nil nil (%refuse :apply :species :not-a-replacement-proposal-object
                               :detail "door 2 requires a proposal object minted by door 1"))))
  (let* ((path-datum (replacement-proposal-path proposal))
         (steps (replacement-proposal-%parsed-path proposal))
         (input (replacement-proposal-%input proposal))
         (tag (replacement-proposal-occurrence-tag proposal)))
    ;; A2/A3 — resolve, and obtain what is ACTUALLY there.
    (multiple-value-bind (observed refusal) (%resolve input steps path-datum)
      (when refusal (return-from try-apply-replacement (values nil nil refusal)))
      ;; A4 — the precondition, BEFORE the no-op test.  A stale proposal whose
      ;; declared expected value happens to equal its replacement is FIRST a
      ;; precondition mismatch, not an established no-op: refusing it as a no-op
      ;; would report a fact about a datum the layer never looked at.
      (unless (%equal observed (replacement-proposal-expected-old proposal))
        (return-from try-apply-replacement
          (values nil nil (%refuse :apply :precondition :expected-old-mismatch
                                   :path path-datum :offending observed :tag tag
                                   :detail "the observed subtree is not the declared expected-old"))))
      ;; A5 — the no-op, named for what was OBSERVED.  A receipt whose
      ;; disposition reads "replaced" while nothing was replaced is one record
      ;; for zero events.
      (when (%equal (replacement-proposal-replacement proposal) observed)
        (return-from try-apply-replacement
          (values nil nil (%refuse :apply :precondition :replacement-equals-observed-old
                                   :path path-datum :offending observed :tag tag
                                   :detail "the replacement equals what is actually there"))))
      ;; A6 — stage the successor.  CD/0 may refuse the rebuild on its own
      ;; record-key work budget; catch EXACTLY that class and reclassify for the
      ;; caller while preserving what CD/0 said.  Anything else ESCAPES.
      (let ((successor
              (handler-case (%rebuild input steps (replacement-proposal-replacement proposal))
                (lisp-plus-cd0:cd0-failure (c)
                  (if (and (equal (lisp-plus-cd0:failure-category c) "ResourceRefusal")
                           (equal (lisp-plus-cd0:failure-code c) "RecordKeyWorkBudgetExceeded"))
                      (return-from try-apply-replacement
                        (values nil nil
                                (%refuse :apply :resource :rebuild-record-key-work-exceeded
                                         :path path-datum :tag tag
                                         :detail "CD/0 refused the spine rebuild on its record-key work budget"
                                         :upstream-category (lisp-plus-cd0:failure-category c)
                                         :upstream-code (lisp-plus-cd0:failure-code c)
                                         :upstream-stage (lisp-plus-cd0:failure-stage c)
                                         :upstream-detail (lisp-plus-cd0:failure-detail c)
                                         :upstream-budget-id (lisp-plus-cd0:failure-budget-id c))))
                      ;; Not our documented class.  Let it escape: an unexpected
                      ;; implementation condition must not become a refusal.
                      (error c))))))
        (let ((output-octets (%octet-count successor)))
          (when (> output-octets (transformation-policy-max-output-octets))
            (return-from try-apply-replacement
              (values nil nil (%refuse :apply :policy :output-octets-exceeded
                                       :path path-datum :tag tag
                                       :detail (format nil "successor ~D octets exceeds ~D"
                                                       output-octets
                                                       (transformation-policy-max-output-octets)))))))
        ;; A7/A8 — identities and the derived-projection verification.
        (multiple-value-bind (receipt refusal)
            (%build-receipt proposal observed successor (%identity successor) path-datum)
          (when refusal (return-from try-apply-replacement (values nil nil refusal)))
          (values successor receipt nil))))))

(defun apply-replacement (proposal)
  "The loud twin of TRY-APPLY-REPLACEMENT.  Returns (values SUCCESSOR RECEIPT).
There is deliberately no wrapper returning the successor alone: a receipt a
caller can decline to take is a receipt this layer does not really produce."
  (multiple-value-bind (successor receipt refusal) (try-apply-replacement proposal)
    (if refusal
        (error 'form-transformation-refused :refusal refusal)
        (values successor receipt))))
