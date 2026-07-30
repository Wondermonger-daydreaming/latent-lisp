;;;; surface2.lisp — Language Surface /2, Candidate: outcomes keep their axes.
;;;;
;;;;   Lisp+ may make the honest path shorter, but never by shortening the
;;;;   evidence carried home.
;;;;
;;;; Governing contract: mneme/language-surface-2/SURFACE-2-CONTRACT.md
;;;; (committed BEFORE this file existed).  Authorized by
;;;; mneme/RULING-vertical0-closure-language-surface-2-2026-07-30.md §5.
;;;;
;;;; WHAT THIS LAYER IS.  Two macro forms — WITH-OUTCOME and MATCH-OUTCOME —
;;;; over a reified, complete, read-only SEAT-OUTCOME object, plus this
;;;; lane's OWN expansion-receipt discipline, S1-SHAPED under the owner's
;;;; adjudication: Surface /1's construct table is deliberately closed, so
;;;; this lane mirrors its shape (closed construct table, request/perform
;;;; doors, retained receipt and refusal objects, versions) with ZERO
;;;; Surface /1 edits.  Surface /1 itself, asked to expand this lane's
;;;; heads, honestly refuses :NOT-A-KNOWN-SURFACE-CONSTRUCT — proven live
;;;; in surface2-controls.lisp.
;;;;
;;;; WHAT A RECEIPT HERE CLAIMS: WHICH BYTES expanded to WHICH BYTES under
;;;; WHICH procedure.  Never meaning, never hygiene, never semantic
;;;; preservation.  The Form /2 + Surface /1 FORBIDDEN VOCABULARY is
;;;; inherited in full and enforced LEXICALLY at load over every string
;;;; this discipline declares (dispositions, refusal codes, catalog notes,
;;;; construct names, identity segments):
;;;;
;;;;   repair · repaired · preserved · preserving · equivalent ·
;;;;   equivalence · normalized · normalization · corrected · correct ·
;;;;   improved · valid · hygienic · hygiene · capture-free ·
;;;;   same-meaning · behaviour-preserving · semantically-equivalent ·
;;;;   faithful · portable · verified · sound
;;;;
;;;; None may appear in any disposition, receipt field, refusal code, or
;;;; fixture title.  The layer may say what form became what other form.
;;;; It may never say better, same, or right.
;;;;
;;;; THE OUTCOME OBJECT.  The empirical ground (LEXICON survey, contract
;;;; §1): no composite outcome object exists in the vertical stack; four
;;;; axes are derived from four unrelated sources, joined by format-string
;;;; identity conventions, read through erasure-prone helpers —
;;;; BODY-STRING's NIL means absent OR wrong-type OR empty; the
;;;; (or live recovery) projection erases provenance; MULTIPLE-VALUE-BIND
;;;; drops the evidence plist.  SEAT-OUTCOME reifies all axes at once:
;;;; absence is TYPED, never NIL-punned — every facet reader returns
;;;; (values VALUE STANDING), STANDING one of :PRESENT /
;;;; :ABSENT-FROM-EVIDENCE / :MALFORMED-IN-EVIDENCE.  Provenance is a
;;;; SLOT.  The execution-evidence plist is RETAINED.  The events
;;;; consulted are RETAINED.
;;;;
;;;; FORBIDDEN INFERENCES (contract §3) — the pattern grammar has no
;;;; vocabulary that can express them: execution from manifestation ·
;;;; truth from parseability · settlement from acknowledgment · safe
;;;; retry from failure · zero cost from missing cost.  There is no
;;;; :success axis, no :truth axis, no :retry-safe axis, no :cost axis;
;;;; an attempt to write one refuses :PATTERN-NOT-IN-GRAMMAR at
;;;; expansion.
;;;;
;;;; VERTICAL /0, SURFACE /1 AND EVERY OTHER PREDECESSOR ARE READ-ONLY TO
;;;; THIS LANE, and are consumed strictly through public package exports:
;;;; lisp-plus-capability2:DERIVE-EFFECT-STANDING for the execution axis;
;;;; lisp-plus-journal0 (VALIDATE-JOURNAL, RECORD-FIELD, identifier
;;;; helpers) and lisp-plus-cd0 for event reading.  The vertical0 event
;;;; readers (BODY-STRING and kin) are NOT exported by their package —
;;;; surveyed against program/package.lisp — so this file carries its own
;;;; readers over the public predecessor APIs; that is also what the
;;;; three-state facet law requires, since BODY-STRING's one-NIL cannot
;;;; carry three standings.
;;;;
;;;; STANDING.  Candidate.  Not audited.  Not adopted.  Not frozen.  On
;;;; no governing floor.
;;;;
;;;; Run: (load "surface2.lisp") — self-loads Capability /2's chain
;;;; (which brings CD/0 via the journal chain, Kernel /0, Capability /0
;;;; and /1) when absent, and NOTHING else.  Vertical /0 is never loaded
;;;; from here.
;;;;
;;;; — GLOSSATOR (Claude Fable 5 subagent), 2026-07-30

(eval-when (:compile-toplevel :load-toplevel :execute)
  (unless (find-package '#:lisp-plus-capability2)
    (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
      (load (merge-pathnames "../capability2/load.lisp"
                             (or *compile-file-truename* *load-truename*))))))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (unless (find-package '#:lisp-plus-surface2)
    (defpackage #:lisp-plus-surface2
      (:use #:cl)
      (:import-from #:lisp-plus-journal0
                    #:validate-journal
                    #:prefix-report-status
                    #:prefix-report-events
                    #:identifier-from-segments
                    #:identifier-segments
                    #:identifier-segment-string
                    #:record-field)
      (:import-from #:lisp-plus-capability2
                    #:derive-effect-standing)
      (:export
       ;; ---- layer identity: THIS layer's, never a predecessor's ----
       #:surface2-grammar-identity
       #:surface2-grammar-version
       #:surface2-procedure-identity
       #:surface2-procedure-version
       #:surface2-policy-identity
       #:surface2-policy-version
       ;; ---- the closed construct table (two rows) ----
       #:known-surface2-constructs
       #:surface2-construct-identity-for
       ;; ---- the declared operations ----
       #:surface2-expansion-operations
       ;; ---- the forbidden vocabulary, enforced not recited ----
       #:surface2-forbidden-vocabulary
       #:surface2-vocabulary-guard
       ;; ---- DOOR 1: describe ----
       #:request-expansion
       #:try-request-expansion
       #:expansion-request-p
       #:expansion-request-identity
       #:expansion-request-source-form-datum
       #:expansion-request-source-form-identity
       #:expansion-request-operation
       #:expansion-request-construct-identity
       #:expansion-request-occurrence-tag
       #:expansion-request-grammar-version
       #:expansion-request-procedure-version
       #:expansion-request-policy-version
       ;; ---- DOOR 2: perform ----
       #:perform-expansion
       #:try-perform-expansion
       ;; ---- the occurrence ----
       #:expansion-occurrence-p
       #:expansion-occurrence-identity
       #:expansion-occurrence-request-identity
       #:expansion-occurrence-expanded-form-datum
       #:expansion-occurrence-expanded-form-identity
       #:expansion-occurrence-disposition
       #:expansion-occurrence-occurrence-tag
       ;; ---- the receipt ----
       #:expansion-receipt-p
       #:expansion-receipt-identity
       #:expansion-receipt-request-identity
       #:expansion-receipt-occurrence
       #:expansion-receipt-occurrence-identity
       #:expansion-receipt-source-form-datum
       #:expansion-receipt-source-form-identity
       #:expansion-receipt-expanded-form-datum
       #:expansion-receipt-expanded-form-identity
       #:expansion-receipt-operation
       #:expansion-receipt-construct-identity
       #:expansion-receipt-expansion-context
       #:expansion-receipt-disposition
       #:expansion-receipt-grammar-version
       #:expansion-receipt-procedure-version
       #:expansion-receipt-policy-version
       #:expansion-receipt-procedure-identity
       #:expansion-receipt-policy-identity
       #:verify-receipt
       ;; ---- refusal: retained objects, never printed conditions ----
       #:surface2-expansion-refused
       #:surface2-not-an-outcome
       #:expansion-condition-refusal
       #:expansion-refusal-p
       #:expansion-refusal-identity
       #:expansion-refusal-phase
       #:expansion-refusal-category
       #:expansion-refusal-code
       #:expansion-refusal-detail
       #:expansion-refusal-occurrence-tag
       ;; ---- the refusal catalogue, split and never flattened ----
       #:surface2-refusal-code-catalog
       #:surface2-protocol-refusal-codes
       #:surface2-integrity-alarm-codes
       #:refusal-catalog-entry-code
       #:refusal-catalog-entry-class
       #:refusal-catalog-entry-phase
       #:refusal-catalog-entry-reachability
       #:refusal-catalog-entry-note
       ;; ---- the term grammar, public so a reader can check it ----
       #:encode-term2
       #:decode-term2
       #:term2-kinds
       #:identity-octets
       #:render-identity-hex
       ;; ---- the outcome object ----
       #:seat-outcome
       #:seat-outcome-p
       #:derive-seat-outcome
       #:validated-store-events
       #:seat-outcome-seat-id
       #:seat-outcome-attempt-name
       #:seat-outcome-execution-standing
       #:seat-outcome-execution-evidence
       #:seat-outcome-manifestation
       #:seat-outcome-no-payload-state
       #:seat-outcome-provenance
       #:seat-outcome-effect
       #:seat-outcome-chunks-preserved
       #:seat-outcome-refusal
       #:seat-outcome-interpretation-class
       #:seat-outcome-evidence-class
       #:seat-outcome-source-events
       #:seat-outcome-field-standing
       #:refusal-description-p
       #:refusal-description-condition-name
       #:refusal-description-explanation
       ;; ---- the census guards as typed refusals (contract §3/§5) ----
       #:signal-match-guard
       ;; ---- the two forms ----
       #:with-outcome
       #:match-outcome))))

(in-package #:lisp-plus-surface2)

;;; ==================================================================
;;; CD/0 SHORTHAND.
;;; ==================================================================

(defun %octets (datum) (lisp-plus-cd0:canonical-octets datum))
(defun %octet-count (datum) (lisp-plus-cd0:octets-length (%octets datum)))
(defun %text (s) (lisp-plus-cd0:make-string-datum s))
(defun %int (n) (lisp-plus-cd0:make-integer-datum n))
(defun %seq (list) (lisp-plus-cd0:make-sequence-datum list))
(defun %id (namespace path) (lisp-plus-cd0:make-identifier-datum namespace path))
(defun %entry (key value) (lisp-plus-cd0:make-record-entry key value))
(defun %rec (entries) (lisp-plus-cd0:make-record-datum entries))

;;; Identity VALUES are lossless OCTETS, never hex, never a digest — the
;;; Form /1 lesson carried forward: hex composition doubles per link.
(defun %identity (payload) (lisp-plus-cd0:make-bytes-datum (%octets payload)))

(defun identity-octets (identity) (%octet-count identity))

(defun render-identity-hex (identity)
  "DIAGNOSTIC ONLY.  Never embedded into a later identity, never compared,
never a content address."
  (lisp-plus-cd0:octets-to-hex (%octets identity)))

;;; ==================================================================
;;; LAYER IDENTITY.  Versions all start at 1 (contract §4).
;;; ==================================================================

(defun surface2-grammar-identity ()
  (%id '("lisp-plus-surface2" "grammar") '("term2" "0")))
;; Erratum 0.1: the accepted source-form language narrowed (binder
;; shapes; facet uniqueness; parent-shadow refusal) => grammar 1 -> 2.
(defun surface2-grammar-version () 2)

(defun surface2-procedure-identity ()
  (%id '("lisp-plus-surface2" "procedure") '("macroexpand" "0")))
;; Erratum 0.1: expansion behavior changed => procedure 1 -> 2.
(defun surface2-procedure-version () 2)

(defun surface2-policy-identity ()
  (%id '("lisp-plus-surface2" "policy") '("ceilings" "0")))
(defun surface2-policy-version () 1)

;;; Policy ceilings (this lane's own numbers; enforced in code below).
(defparameter +max-source-depth+ 48)
(defparameter +max-source-nodes+ 20000)
(defparameter +max-term-octets+ 262144)

(defparameter +operations+ '(:macroexpand-1 :macroexpand))
(defun surface2-expansion-operations () (copy-list +operations+))

(defun %operation-disposition (operation)
  (ecase operation
    (:macroexpand-1 "expanded-once")
    (:macroexpand "expanded-to-fixpoint")))

;;; ==================================================================
;;; THE CLOSED CONSTRUCT TABLE — TWO ROWS, this lane's own namespace.
;;; ==================================================================
;;;
;;; Closed and exhaustive: no registration point, no extension hook, no
;;; caller-supplied procedure.  A head outside these two rows refuses
;;; :NOT-A-KNOWN-SURFACE2-CONSTRUCT at Door 2.

(defparameter +construct-table+
  '(("LISP-PLUS-SURFACE2" "WITH-OUTCOME")
    ("LISP-PLUS-SURFACE2" "MATCH-OUTCOME")))

(defun known-surface2-constructs () (copy-tree +construct-table+))

(defun %lookup-construct (package-name symbol-name)
  (find-if (lambda (row)
             (and (string= (first row) package-name)
                  (string= (second row) symbol-name)))
           +construct-table+))

(defun surface2-construct-identity-for (package-name symbol-name)
  "The construct identity for a known table row; NIL for any other head."
  (let ((row (%lookup-construct package-name symbol-name)))
    (and row
         (%id '("lisp-plus-surface2" "construct")
              (list (second row) "1")))))

;;; ==================================================================
;;; THE FORBIDDEN VOCABULARY — enforced lexically, at load, over every
;;; string this discipline declares.  A gate that has never fired is
;;; untested: surface2-controls.lisp plants a dirty string and fires it.
;;; ==================================================================

(defparameter +forbidden-vocabulary+
  '("repair" "repaired" "preserved" "preserving" "equivalent" "equivalence"
    "normalized" "normalization" "corrected" "correct" "improved" "valid"
    "hygienic" "hygiene" "capture-free" "same-meaning" "behaviour-preserving"
    "semantically-equivalent" "faithful" "portable" "verified" "sound"))

(defun surface2-forbidden-vocabulary () (copy-list +forbidden-vocabulary+))

(defun %tokens (string)
  "Maximal runs of alphanumerics-and-hyphens, lowercased.  Token match,
not substring match: the banned word inside a longer word is a different
word and must not fire the guard."
  (let ((tokens nil) (start nil) (s (string-downcase string)))
    (loop for i below (length s)
          for c = (char s i)
          do (if (or (alphanumericp c) (char= c #\-))
                 (unless start (setf start i))
                 (when start
                   (push (subseq s start i) tokens)
                   (setf start nil)))
          finally (when start (push (subseq s start) tokens)))
    (nreverse tokens)))

(defun surface2-vocabulary-guard (strings &key (context "declared surface"))
  "Refuse (plain ERROR — this guard protects the discipline itself and
runs before the refusal discipline can be trusted) if any STRING carries
a forbidden token.  Hyphenated banned forms are matched both as whole
tokens and as hyphen-joined sub-token runs."
  (dolist (string strings)
    (let ((tokens (%tokens string)))
      (dolist (token tokens)
        (when (member token +forbidden-vocabulary+ :test #'string=)
          (error "surface2 vocabulary guard: forbidden token ~s in ~s (~a)"
                 token string context))
        ;; a hyphenated token also exposes its hyphen-split parts:
        ;; "well-repaired" carries "repaired".
        (let ((parts (%tokens (substitute #\Space #\- token))))
          (dolist (part parts)
            (when (member part +forbidden-vocabulary+ :test #'string=)
              (error "surface2 vocabulary guard: forbidden token ~s inside ~
                      ~s in ~s (~a)" part token string context)))))))
  t)

;;; ==================================================================
;;; THE REFUSAL CATALOGUE.  Entries are (code class phase reachability
;;; note).  Split protocol-refusal vs integrity-alarm, never flattened.
;;; Every code below is FIRED in surface2-selftest / surface2-controls;
;;; a code no caller can reach is a false affordance and was not written.
;;; (Surface /1's :CONSTRUCT-NOT-A-MACRO has no analogue here on purpose:
;;; both table rows name macros defined in THIS file, so the state "in
;;; the table but not a macro" is not constructible from outside.)
;;; ==================================================================

(defparameter +refusal-catalog+
  '((:source-form-not-a-call        :protocol-refusal :request :public-api
     "the source form is not a cons, so it names no construct at all")
    (:source-form-head-not-a-symbol :protocol-refusal :request :public-api
     "the head of the source form is not a symbol")
    (:operation-not-declared        :protocol-refusal :request :public-api
     "the operation is not one of the declared expansion operations")
    (:occurrence-tag-not-identifier :protocol-refusal :request :public-api
     "the occurrence tag is not a CD/0 identifier datum; there is no default")
    (:source-term-unrepresentable   :protocol-refusal :request :public-api
     "the source form carries a term the term2 grammar does not represent")
    (:source-term-shared-structure  :protocol-refusal :request :public-api
     "a cons in the source form is reachable by more than one path")
    (:source-depth-exceeded         :protocol-refusal :request :public-api
     "the source form is nested deeper than the declared depth ceiling")
    (:source-nodes-exceeded         :protocol-refusal :request :public-api
     "the source form has more nodes than the declared node ceiling")
    (:source-term-octets-exceeded   :protocol-refusal :request :public-api
     "the encoded source term exceeds the declared term-octet ceiling")
    (:not-a-known-surface2-construct :protocol-refusal :perform :public-api
     "the head names no row of this lane's closed two-row construct table")
    (:source-not-reconstructible    :protocol-refusal :perform :public-api
     "the stored canonical source datum could not be rebuilt into a host
form in THIS image, or its rebuild does not re-encode to the stored datum;
rebuild resolves symbols with FIND-SYMBOL and never INTERN")
    (:expanded-term-unrepresentable :protocol-refusal :perform :public-api
     "the EXPANDED form carries a term the term2 grammar does not represent")
    (:expanded-term-shared-structure :protocol-refusal :perform :public-api
     "a cons in the EXPANDED form is reachable by more than one path")
    (:expanded-depth-exceeded       :protocol-refusal :perform :public-api
     "the expanded form is nested deeper than the declared depth ceiling")
    (:expanded-nodes-exceeded       :protocol-refusal :perform :public-api
     "the expanded form has more nodes than the declared node ceiling")
    (:expanded-term-octets-exceeded :protocol-refusal :perform :public-api
     "the encoded expanded term exceeds the declared term-octet ceiling")
    ;; ---- the STRUCTURAL expansion-time refusals (contract §3) ----
    (:non-exhaustive-match          :protocol-refusal :expansion :public-api
     "a MATCH-OUTCOME without an explicit OTHERWISE clause refuses AT
EXPANSION; the unmatched remainder of the outcome space must be owned by
a clause that receives the whole outcome, never dropped")
    (:duplicate-pattern             :protocol-refusal :expansion :public-api
     "two clauses carry the same canonicalized pattern; the second could
never express a different decision")
    (:unreachable-pattern           :protocol-refusal :expansion :public-api
     "a clause is shadowed by an earlier equal-or-wider pattern (the
earlier conjunct set is a subset of the later one), or follows OTHERWISE")
    (:pattern-not-in-grammar        :protocol-refusal :expansion :public-api
     "a clause pattern is outside the closed pattern grammar — unknown
axis, unlawful value for its axis, or vocabulary that would express a
forbidden inference (there is no :success, :truth, :retry-safe or :cost
axis, deliberately)")
    (:match-var-not-a-symbol        :protocol-refusal :expansion :public-api
     "the outcome variable position of MATCH-OUTCOME requires a symbol")
    (:with-outcome-binding-malformed :protocol-refusal :expansion :public-api
     "WITH-OUTCOME requires (var derivation-form) with var a non-keyword
symbol")
    (:facet-binding-malformed       :protocol-refusal :expansion :public-api
     "a :facets clause option requires ((name axis)...) with name a symbol
and axis a known facet axis")
    ;; ---- the runtime typed refusal (contract §3) ----
    (:not-a-seat-outcome            :protocol-refusal :runtime :public-api
     "the value bound at WITH-OUTCOME / consulted by MATCH-OUTCOME is not
a SEAT-OUTCOME; signalled as SURFACE2-NOT-AN-OUTCOME with the refusal
retained")
    ;; ---- integrity alarms ----
    (:receipt-not-minted            :integrity-alarm :receipt
     :internal-planted-fault-only
     "a gate expansion found no receipt where its discipline requires one;
reachable only through the planted fault hook, and the controls fire it")
    (:source-identity-projection-mismatch :integrity-alarm :receipt
     :internal-planted-fault-only
     "the stored source-form identity does not equal the identity
recomputed from the stored source-form datum")
    (:expanded-identity-projection-mismatch :integrity-alarm :receipt
     :internal-planted-fault-only
     "the stored expanded-form identity does not equal the identity
recomputed from the stored expanded-form datum")
    ;; ---- the census guards, become structure (contract §3/§5) ----
    (:projection-without-settled-execution :integrity-alarm :match
     :public-api
     "the cross-axis guard: a seat holds a projection while its execution
standing is not :SETTLED; the census refuses this seat and so does the
rewritten passage — as a clause, not a hand-written check")
    (:no-evidence-class             :integrity-alarm :match :public-api
     "the totality guard: a seat derives through no evidence class; a
founded census is founded or it is not asserted — the OTHERWISE clause
owns this refusal"))
  "The stable refusal codes.  A reader may branch on these; they are not
prose.")

(defun surface2-refusal-code-catalog () (copy-tree +refusal-catalog+))
(defun refusal-catalog-entry-code (e) (first e))
(defun refusal-catalog-entry-class (e) (second e))
(defun refusal-catalog-entry-phase (e) (third e))
(defun refusal-catalog-entry-reachability (e) (fourth e))
(defun refusal-catalog-entry-note (e) (fifth e))

(defun surface2-protocol-refusal-codes ()
  (mapcar #'first (remove-if-not (lambda (e) (eq :protocol-refusal (second e)))
                                 +refusal-catalog+)))
(defun surface2-integrity-alarm-codes ()
  (mapcar #'first (remove-if-not (lambda (e) (eq :integrity-alarm (second e)))
                                 +refusal-catalog+)))

;;; The load-time vocabulary sweep over everything the discipline declares.
(surface2-vocabulary-guard
 (append (mapcar (lambda (e) (string (refusal-catalog-entry-code e)))
                 +refusal-catalog+)
         (mapcar #'refusal-catalog-entry-note +refusal-catalog+)
         (mapcar #'second +construct-table+)
         (mapcar #'%operation-disposition +operations+)
         (list (identifier-segment-string (surface2-grammar-identity))
               (identifier-segment-string (surface2-procedure-identity))
               (identifier-segment-string (surface2-policy-identity))))
 :context "surface2 load-time declaration sweep")

;;; ==================================================================
;;; REFUSAL OBJECTS — retained and inspectable, never printed conditions.
;;; ==================================================================

(defstruct (expansion-refusal (:constructor %make-refusal) (:copier nil)
                              (:predicate expansion-refusal-p))
  (identity nil :read-only t)
  (phase nil :read-only t)
  (category nil :read-only t)
  (code nil :read-only t)
  (detail nil :read-only t)
  (occurrence-tag nil :read-only t))

(define-condition surface2-expansion-refused (error)
  ((refusal :initarg :refusal :reader expansion-condition-refusal))
  (:report (lambda (c s)
             (let ((r (expansion-condition-refusal c)))
               (format s "surface2 expansion refused (~S) in ~S: ~A"
                       (expansion-refusal-code r)
                       (expansion-refusal-phase r)
                       (or (expansion-refusal-detail r) ""))))))

(define-condition surface2-not-an-outcome (surface2-expansion-refused) ()
  (:documentation
   "The typed runtime refusal of both forms: the value in the outcome
position is not a SEAT-OUTCOME.  A subtype so a handler for the general
condition still catches it; its retained refusal carries code
:NOT-A-SEAT-OUTCOME."))

(defun %refusal-class (code)
  (let ((e (assoc code +refusal-catalog+)))
    (unless e (error "internal: undeclared refusal code ~S" code))
    (second e)))

(defun %refuse (phase code &key detail occurrence-tag
                                (condition 'surface2-expansion-refused))
  (let* ((class (%refusal-class code))
         (id (%identity
              (%seq (list (%text ":surface2-refusal")
                          (%text (string code))
                          (%text (string phase))
                          (%text (string class))
                          (or occurrence-tag (%id '("lisp-plus-surface2" "tag")
                                                  '("no-tag")))
                          (surface2-procedure-identity)
                          (%int (surface2-procedure-version))))))
         (r (%make-refusal :identity id :phase phase :category class
                           :code code :detail detail
                           :occurrence-tag occurrence-tag)))
    (error condition :refusal r)))

;;; ==================================================================
;;; THE TERM2 GRAMMAR — SYMBOL / INTEGER / STRING / LIST, nothing else.
;;; Shared structure refused globally; ceilings checked BEFORE recursion
;;; can hurt.  Decode resolves with FIND-SYMBOL, never INTERN.
;;; ==================================================================

(defparameter +term2-kinds+ '("SYMBOL" "INTEGER" "STRING" "LIST"))
(defun term2-kinds () (copy-list +term2-kinds+))

(defun %term2 (kind value)
  (%rec (list (%entry (%id '("TERM2") '("KIND")) (%id '("TERM2KIND") (list kind)))
              (%entry (%id '("TERM2") '("VALUE")) value))))

(define-condition %term2-trouble (error)
  ((code :initarg :code :reader %t2-code)
   (shown :initarg :shown :reader %t2-shown)))

(defun %t2-refuse (code shown)
  (error '%term2-trouble :code code :shown shown))

(defun %describe-host-object (object)
  "A SHORT, BOUNDED type description for a refusal detail.  Deliberately
NOT the object's printed representation: it reaches a human, never a
datum.  TYPE-OF may answer a compound specifier; only its head is kept."
  (let ((type (type-of object)))
    (string-downcase (symbol-name (if (consp type) (first type) type)))))

(defun %walk-guard (form)
  "Depth, node and sharing sweep BEFORE encoding.  Returns node count."
  (let ((visited (make-hash-table :test #'eq))
        (nodes 0))
    (labels ((walk (x depth)
               (when (> depth +max-source-depth+)
                 (%t2-refuse :depth-exceeded "nesting"))
               (incf nodes)
               (when (> nodes +max-source-nodes+)
                 (%t2-refuse :nodes-exceeded "node count"))
               (when (consp x)
                 (when (gethash x visited)
                   (%t2-refuse :shared-structure "a cons reachable twice"))
                 (setf (gethash x visited) t)
                 (walk (car x) (1+ depth))
                 (walk (cdr x) depth))))
      (walk form 0))
    nodes))

(defun %encode-term2-node (form)
  (cond ((symbolp form)
         (let ((pkg (symbol-package form)))
           (unless pkg
             (%t2-refuse :unrepresentable "an uninterned symbol"))
           (%term2 "SYMBOL" (%id (list (package-name pkg))
                                 (list (symbol-name form))))))
        ((integerp form) (%term2 "INTEGER" (%int form)))
        ((stringp form) (%term2 "STRING" (%text form)))
        ((consp form)
         (let ((elements nil) (tail form))
           (loop while (consp tail)
                 do (push (%encode-term2-node (car tail)) elements)
                    (setf tail (cdr tail)))
           (unless (null tail)
             (%t2-refuse :unrepresentable "a dotted list"))
           (%term2 "LIST" (%seq (nreverse elements)))))
        (t (%t2-refuse :unrepresentable (%describe-host-object form)))))

(defun encode-term2 (form)
  "Host form -> canonical CD/0 term2 datum.  Signals %TERM2-TROUBLE with a
code among :UNREPRESENTABLE :SHARED-STRUCTURE :DEPTH-EXCEEDED
:NODES-EXCEEDED :OCTETS-EXCEEDED; the doors map these to catalogued
refusal codes per side."
  (%walk-guard form)
  (let ((datum (%encode-term2-node form)))
    (when (> (%octet-count datum) +max-term-octets+)
      (%t2-refuse :octets-exceeded "encoded size"))
    datum))

(defun %term2-field (datum leaf)
  (record-field datum "TERM2" leaf))

(defun decode-term2 (datum)
  "Canonical term2 datum -> a FRESH host form.  FIND-SYMBOL only; a
namespace naming no package here, or a name absent from it, refuses —
this image simply does not carry that form."
  (let ((kind (%term2-field datum "KIND"))
        (value (%term2-field datum "VALUE")))
    (unless (and kind (lisp-plus-cd0:identifier-datum-p kind))
      (%t2-refuse :undecodable "a term without a kind"))
    (let ((kind-string (lisp-plus-cd0:identifier-datum-path-segment kind 0)))
      (cond
        ((string= kind-string "SYMBOL")
         (unless (lisp-plus-cd0:identifier-datum-p value)
           (%t2-refuse :undecodable "a symbol term without an identifier"))
         (let* ((pkg-name (lisp-plus-cd0:identifier-datum-namespace-segment
                           value 0))
                (sym-name (lisp-plus-cd0:identifier-datum-path-segment
                           value 0))
                (pkg (find-package pkg-name)))
           (unless pkg (%t2-refuse :package-absent-in-image pkg-name))
           (multiple-value-bind (sym status) (find-symbol sym-name pkg)
             (unless status (%t2-refuse :symbol-absent-in-image sym-name))
             sym)))
        ((string= kind-string "INTEGER")
         (unless (lisp-plus-cd0:integer-datum-p value)
           (%t2-refuse :undecodable "an integer term without an integer"))
         (lisp-plus-cd0:integer-datum-value value))
        ((string= kind-string "STRING")
         (unless (lisp-plus-cd0:string-datum-p value)
           (%t2-refuse :undecodable "a string term without a string"))
         (lisp-plus-cd0:string-datum-value value))
        ((string= kind-string "LIST")
         (unless (lisp-plus-cd0:sequence-datum-p value)
           (%t2-refuse :undecodable "a list term without a sequence"))
         (loop for i below (lisp-plus-cd0:sequence-datum-length value)
               collect (decode-term2
                        (lisp-plus-cd0:sequence-datum-ref value i))))
        (t (%t2-refuse :undecodable kind-string))))))

(defun %encode-checked (form phase tag unrepresentable-code shared-code
                        depth-code nodes-code octets-code)
  (handler-case (encode-term2 form)
    (%term2-trouble (c)
      (%refuse phase
               (ecase (%t2-code c)
                 (:unrepresentable unrepresentable-code)
                 (:shared-structure shared-code)
                 (:depth-exceeded depth-code)
                 (:nodes-exceeded nodes-code)
                 (:octets-exceeded octets-code))
               :occurrence-tag tag
               :detail (%t2-shown c)))))

;;; ==================================================================
;;; PLANTED-FAULT HOOKS.  Reachable only from inside this package; a
;;; gate that has never fired is untested, not passing.
;;; ==================================================================

(defparameter *%fault-source-identity* nil)
(defparameter *%fault-expanded-identity* nil)
(defparameter *%fault-skip-receipt* nil
  "When true, PERFORM-EXPANSION returns NIL in the receipt position —
the mutant the receipt-checking discipline exists to catch.")
(defparameter *%fault-project-payload-or-nil* nil
  "When true, MATCH-OUTCOME's expansion REPLACES every clause body with a
single-facet projection — the payload-or-NIL mutant, the planted defect
of contract §6.  The controls fire it and show it caught.")

;;; ==================================================================
;;; DOOR 1 — REQUEST.  Describes; does not expand.
;;; ==================================================================

(defstruct (expansion-request (:constructor %make-request) (:copier nil)
                              (:predicate expansion-request-p))
  (identity nil :read-only t)
  (source-form-datum nil :read-only t)
  (source-form-identity nil :read-only t)
  (operation nil :read-only t)
  (construct-identity nil :read-only t)
  (occurrence-tag nil :read-only t)
  (grammar-version nil :read-only t)
  (procedure-version nil :read-only t)
  (policy-version nil :read-only t))

(defun request-expansion (source-form operation occurrence-tag)
  "DOOR 1.  Mint an immutable expansion request.  DOES NOT EXPAND, does
not require the head to name a known construct (an unknown head refuses
at Door 2, in its own phase, with its own code).  The caller's tree is
read exactly once, here, and never consulted again."
  (unless (lisp-plus-cd0:identifier-datum-p occurrence-tag)
    (%refuse :request :occurrence-tag-not-identifier
             :detail "the occurrence tag must be a CD/0 identifier datum"))
  (unless (member operation +operations+ :test #'eq)
    (%refuse :request :operation-not-declared :occurrence-tag occurrence-tag
             :detail (format nil "~S is not one of ~S" operation +operations+)))
  (unless (consp source-form)
    (%refuse :request :source-form-not-a-call :occurrence-tag occurrence-tag
             :detail "the source form is not a cons"))
  (unless (symbolp (car source-form))
    (%refuse :request :source-form-head-not-a-symbol
             :occurrence-tag occurrence-tag
             :detail "the head of the source form is not a symbol"))
  (let* ((datum (%encode-checked source-form :request occurrence-tag
                                 :source-term-unrepresentable
                                 :source-term-shared-structure
                                 :source-depth-exceeded
                                 :source-nodes-exceeded
                                 :source-term-octets-exceeded))
         (source-id (%identity datum))
         (head (car source-form))
         (pkg (symbol-package head))
         (construct-id (and pkg (surface2-construct-identity-for
                                 (package-name pkg) (symbol-name head))))
         (request-id
           (%identity
            (%seq (list (%text ":surface2-request")
                        source-id
                        (%id '("OPERATION") (list (string operation)))
                        (or construct-id
                            (%id '("lisp-plus-surface2" "construct")
                                 '("unknown")))
                        occurrence-tag
                        (surface2-grammar-identity)
                        (%int (surface2-grammar-version))
                        (surface2-procedure-identity)
                        (%int (surface2-procedure-version))
                        (surface2-policy-identity)
                        (%int (surface2-policy-version)))))))
    (%make-request :identity request-id
                   :source-form-datum datum
                   :source-form-identity source-id
                   :operation operation
                   :construct-identity construct-id
                   :occurrence-tag occurrence-tag
                   :grammar-version (surface2-grammar-version)
                   :procedure-version (surface2-procedure-version)
                   :policy-version (surface2-policy-version))))

(defun try-request-expansion (source-form operation occurrence-tag)
  "The non-signalling twin: (values REQUEST-or-NIL REFUSAL-or-NIL)."
  (handler-case (values (request-expansion source-form operation occurrence-tag)
                        nil)
    (surface2-expansion-refused (c)
      (values nil (expansion-condition-refusal c)))))

;;; ==================================================================
;;; THE OCCURRENCE — minted ONLY on a completed expansion.
;;; ==================================================================

(defstruct (expansion-occurrence (:constructor %make-occurrence) (:copier nil)
                                 (:predicate expansion-occurrence-p))
  (identity nil :read-only t)
  (request-identity nil :read-only t)
  (expanded-form-datum nil :read-only t)
  (expanded-form-identity nil :read-only t)
  (disposition nil :read-only t)
  (occurrence-tag nil :read-only t))

;;; ==================================================================
;;; THE RECEIPT — an ACCOUNT, not an AUTHENTICATION.
;;; ==================================================================

(defstruct (expansion-receipt (:constructor %make-receipt) (:copier nil)
                              (:predicate expansion-receipt-p))
  (identity nil :read-only t)
  (request-identity nil :read-only t)
  (occurrence nil :read-only t)
  (occurrence-identity nil :read-only t)
  (source-form-datum nil :read-only t)
  (source-form-identity nil :read-only t)
  (expanded-form-datum nil :read-only t)
  (expanded-form-identity nil :read-only t)
  (operation nil :read-only t)
  (construct-identity nil :read-only t)
  (expansion-context nil :read-only t)
  (disposition nil :read-only t)
  (grammar-version nil :read-only t)
  (procedure-version nil :read-only t)
  (policy-version nil :read-only t))

(defun expansion-receipt-procedure-identity (r)
  (declare (ignore r)) (surface2-procedure-identity))
(defun expansion-receipt-policy-identity (r)
  (declare (ignore r)) (surface2-policy-identity))

(defun %expansion-context ()
  (%rec (list (%entry (%id '("CONTEXT") '("SUPPLIED-LEXICAL-ENVIRONMENT"))
                      (%id '("lisp-plus-surface2" "environment") '("null")))
              (%entry (%id '("CONTEXT") '("ENVIRONMENT-OBJECT-CAPTURED"))
                      (lisp-plus-cd0:make-boolean-datum nil))
              (%entry (%id '("CONTEXT") '("READ-PERFORMED"))
                      (lisp-plus-cd0:make-boolean-datum nil)))))

(defun %mint-receipt (request occurrence tag)
  "THE ONLY PATH BY WHICH A RECEIPT COMES INTO BEING.  The two identity
fields are DERIVED PROJECTIONS, recomputed here from the stored data and
compared, so a receipt cannot carry an identity that does not belong to
the datum beside it.  This checks the account's internal consistency; it
does not, and cannot, check that the account is true of the world."
  (let ((stored-source-id (or *%fault-source-identity*
                              (expansion-request-source-form-identity request)))
        (stored-expanded-id
          (or *%fault-expanded-identity*
              (expansion-occurrence-expanded-form-identity occurrence))))
    (unless (lisp-plus-cd0:equal-datum
             stored-source-id
             (%identity (expansion-request-source-form-datum request)))
      (%refuse :receipt :source-identity-projection-mismatch
               :occurrence-tag tag
               :detail "stored source identity does not match the stored source datum"))
    (unless (lisp-plus-cd0:equal-datum
             stored-expanded-id
             (%identity (expansion-occurrence-expanded-form-datum occurrence)))
      (%refuse :receipt :expanded-identity-projection-mismatch
               :occurrence-tag tag
               :detail "stored expanded identity does not match the stored expanded datum"))
    (%make-receipt
     :identity (%identity (%seq (list (%text ":surface2-receipt")
                                      (expansion-occurrence-identity occurrence)
                                      (surface2-procedure-identity)
                                      (%int (surface2-procedure-version))
                                      (surface2-policy-identity)
                                      (%int (surface2-policy-version)))))
     :request-identity (expansion-request-identity request)
     :occurrence occurrence
     :occurrence-identity (expansion-occurrence-identity occurrence)
     :source-form-datum (expansion-request-source-form-datum request)
     :source-form-identity stored-source-id
     :expanded-form-datum (expansion-occurrence-expanded-form-datum occurrence)
     :expanded-form-identity stored-expanded-id
     :operation (expansion-request-operation request)
     :construct-identity (expansion-request-construct-identity request)
     :expansion-context (%expansion-context)
     :disposition (expansion-occurrence-disposition occurrence)
     :grammar-version (surface2-grammar-version)
     :procedure-version (surface2-procedure-version)
     :policy-version (surface2-policy-version))))

(defun verify-receipt (receipt)
  "The gate-side receipt discipline: the receipt EXISTS and its digest
identities re-derive from the stored data.  Refuses typed; returns T.
Every gate expansion in this lane's scripts calls this."
  (unless (expansion-receipt-p receipt)
    (%refuse :receipt :receipt-not-minted
             :detail "no receipt where the discipline requires one"))
  (unless (lisp-plus-cd0:equal-datum
           (expansion-receipt-source-form-identity receipt)
           (%identity (expansion-receipt-source-form-datum receipt)))
    (%refuse :receipt :source-identity-projection-mismatch
             :detail "receipt source identity does not re-derive"))
  (unless (lisp-plus-cd0:equal-datum
           (expansion-receipt-expanded-form-identity receipt)
           (%identity (expansion-receipt-expanded-form-datum receipt)))
    (%refuse :receipt :expanded-identity-projection-mismatch
             :detail "receipt expanded identity does not re-derive"))
  t)

;;; ==================================================================
;;; DOOR 2 — PERFORM.  Meets the actual image.
;;; ==================================================================

(defun %reconstruct-source (request tag)
  "A FRESH private host form built from the request's immutable source
datum, re-encoded and required to equal the stored datum exactly BEFORE
anything is handed to the macroexpander."
  (let* ((stored (expansion-request-source-form-datum request))
         (form (handler-case (decode-term2 stored)
                 (%term2-trouble (c)
                   (%refuse :perform :source-not-reconstructible
                            :occurrence-tag tag
                            :detail (format nil "~a: ~a"
                                            (string (%t2-code c))
                                            (%t2-shown c))))))
         (round-trip (handler-case (encode-term2 form)
                       (%term2-trouble (c)
                         (%refuse :perform :source-not-reconstructible
                                  :occurrence-tag tag
                                  :detail (%t2-shown c))))))
    (unless (lisp-plus-cd0:equal-datum round-trip stored)
      (%refuse :perform :source-not-reconstructible :occurrence-tag tag
               :detail "re-encoding the rebuild does not reproduce the stored source datum"))
    form))

(defun %resolve-construct (form tag)
  (let* ((head (car form))
         (pkg (and (symbolp head) (symbol-package head))))
    (unless (and pkg (%lookup-construct (package-name pkg) (symbol-name head)))
      (%refuse :perform :not-a-known-surface2-construct :occurrence-tag tag
               :detail "the head names no row of the closed two-row table"))
    head))

(defun perform-expansion (request)
  "DOOR 2.  Perform the requested host macroexpansion and account for it.
Returns (values RECEIPT EXPANDED-HOST-FORM OCCURRENCE).

THIS LAYER'S OWN MACRO FUNCTIONS SIGNAL THIS LAYER'S TYPED REFUSALS: a
structurally defective MATCH-OUTCOME refuses AT EXPANSION with a retained
code (:NON-EXHAUSTIVE-MATCH and kin), and that condition escapes to the
caller as itself — nothing is minted for a refused expansion."
  (unless (expansion-request-p request)
    (error "PERFORM-EXPANSION requires an expansion request object."))
  (let* ((tag (expansion-request-occurrence-tag request))
         (form (%reconstruct-source request tag)))
    (%resolve-construct form tag)
    (let* ((expanded (ecase (expansion-request-operation request)
                       (:macroexpand-1 (macroexpand-1 form nil))
                       (:macroexpand (macroexpand form nil))))
           (expanded-datum (%encode-checked expanded :perform tag
                                            :expanded-term-unrepresentable
                                            :expanded-term-shared-structure
                                            :expanded-depth-exceeded
                                            :expanded-nodes-exceeded
                                            :expanded-term-octets-exceeded))
           (expanded-id (%identity expanded-datum))
           (disposition (%operation-disposition
                         (expansion-request-operation request)))
           (occurrence-id
             (%identity (%seq (list (%text ":surface2-occurrence")
                                    (expansion-request-identity request)
                                    expanded-id
                                    (%id '("DISPOSITION")
                                         (list (string disposition)))))))
           (occurrence
             (%make-occurrence :identity occurrence-id
                               :request-identity (expansion-request-identity
                                                  request)
                               :expanded-form-datum expanded-datum
                               :expanded-form-identity expanded-id
                               :disposition disposition
                               :occurrence-tag tag)))
      (values (if *%fault-skip-receipt*
                  nil
                  (%mint-receipt request occurrence tag))
              expanded occurrence))))

(defun try-perform-expansion (request)
  "Three values on both branches, so a caller destructuring the result
cannot read a refusal as a completion:
  completed -> (values RECEIPT EXPANDED-FORM NIL)
  refused   -> (values NIL     NIL           REFUSAL)"
  (handler-case
      (multiple-value-bind (receipt expanded occurrence) (perform-expansion
                                                          request)
        (declare (ignore occurrence))
        (values receipt expanded nil))
    (surface2-expansion-refused (c)
      (values nil nil (expansion-condition-refusal c)))))

;;; ==================================================================
;;; THE SEAT-OUTCOME OBJECT (contract §2).
;;; ==================================================================
;;;
;;; Constructed ONLY by DERIVE-SEAT-OUTCOME.  No public constructor, no
;;; copier, read-only slots.  Every facet reader returns
;;; (values VALUE STANDING); the standing plist is a slot of its own, so
;;; the three meanings BODY-STRING folds into one NIL are three
;;; distinguishable answers here — structurally, not by convention.

(defstruct (refusal-description (:constructor %make-refusal-description)
                                (:copier nil)
                                (:predicate refusal-description-p))
  "A RETAINED refusal description: the journaled condition name and the
journaled explanation, kept distinct — type is not explanation."
  (condition-name nil :read-only t)
  (explanation nil :read-only t))

(defstruct (seat-outcome (:constructor %make-seat-outcome) (:copier nil)
                         (:predicate seat-outcome-p)
                         (:conc-name %so-))
  (seat-id nil :read-only t)
  (attempt-name nil :read-only t)
  (execution-standing nil :read-only t)
  (execution-evidence nil :read-only t)
  (manifestation-status nil :read-only t)
  (no-payload-state nil :read-only t)
  (manifestation-provenance nil :read-only t)
  (effect-standing nil :read-only t)
  (chunks-preserved nil :read-only t)
  (refusal nil :read-only t)
  (interpretation-class nil :read-only t)
  (evidence-class nil :read-only t)
  (field-standings nil :read-only t)
  (source-events nil :read-only t))

(defparameter +always-present-facets+
  '(:seat :attempt :execution :provenance :evidence-class))

(defun seat-outcome-field-standing (outcome facet)
  "The three-state standing of FACET on OUTCOME.  Facets whose value is
derived rather than read from a body field are always :PRESENT."
  (if (member facet +always-present-facets+)
      :present
      (let ((standing (getf (%so-field-standings outcome) facet :missing)))
        (when (eq standing :missing)
          (error "seat-outcome-field-standing: unknown facet ~S" facet))
        standing)))

;;; Facet readers — (values VALUE STANDING), uniformly.
(defun seat-outcome-seat-id (o) (values (%so-seat-id o) :present))
(defun seat-outcome-attempt-name (o) (values (%so-attempt-name o) :present))
(defun seat-outcome-execution-standing (o)
  (values (%so-execution-standing o) :present))
(defun seat-outcome-execution-evidence (o)
  (values (%so-execution-evidence o) :present))
(defun seat-outcome-manifestation (o)
  (values (%so-manifestation-status o)
          (seat-outcome-field-standing o :manifestation)))
(defun seat-outcome-no-payload-state (o)
  (values (%so-no-payload-state o)
          (seat-outcome-field-standing o :no-payload-state)))
(defun seat-outcome-provenance (o)
  (values (%so-manifestation-provenance o) :present))
(defun seat-outcome-effect (o)
  (values (%so-effect-standing o) (seat-outcome-field-standing o :effect)))
(defun seat-outcome-chunks-preserved (o)
  (values (%so-chunks-preserved o)
          (seat-outcome-field-standing o :chunks-preserved)))
(defun seat-outcome-refusal (o)
  (values (%so-refusal o) (seat-outcome-field-standing o :refusal)))
(defun seat-outcome-interpretation-class (o)
  (values (%so-interpretation-class o)
          (seat-outcome-field-standing o :interpretation)))
(defun seat-outcome-evidence-class (o)
  (values (%so-evidence-class o) :present))
(defun seat-outcome-source-events (o) (values (%so-source-events o) :present))

;;; ------------------------------------------------------------------
;;; Event reading over PUBLIC predecessor APIs, with typed absence.

(defun validated-store-events (store)
  "The validated prefix's events as a list, oldest first; refuses unless
the store validates :VALID."
  (let* ((report (validate-journal store))
         (events (prefix-report-events report)))
    (unless (eq :valid (prefix-report-status report))
      (error "validated-store-events: store did not validate :valid (~a)"
             (prefix-report-status report)))
    (loop for index below (fill-pointer events)
          collect (aref events index))))

(defun %event-id-string (event)
  (let ((id (record-field event "event" "event-id")))
    (and id (lisp-plus-cd0:identifier-datum-p id)
         (identifier-segment-string id))))

(defun %event-body (event) (record-field event "event" "body"))

(defun %seat-event2 (events namespace seat-id suffix)
  (let ((target (format nil "~a:e-~a-~a" namespace seat-id suffix)))
    (find-if (lambda (event) (equal target (%event-id-string event)))
             events)))

(defun %facet-string (body namespace name)
  "(values VALUE STANDING) — the meanings BODY-STRING folds into one NIL,
split apart.  Measured against the campaign-1 evidence: a field can be a
string (a value), a CD/0 UNIT datum (the writer DECLARED none — value
:DECLARED-NONE, standing :PRESENT), missing altogether
(:ABSENT-FROM-EVIDENCE), or of a type outside the field's grammar
(:MALFORMED-IN-EVIDENCE).  BODY-STRING answers NIL to the last three
alike; this reader does not."
  (if (null body)
      (values nil :absent-from-evidence)
      (let ((field (record-field body namespace name)))
        (cond ((null field) (values nil :absent-from-evidence))
              ((lisp-plus-cd0:string-datum-p field)
               (values (lisp-plus-cd0:string-datum-value field) :present))
              ((lisp-plus-cd0:identifier-datum-p field)
               (values (identifier-segment-string field) :present))
              ((lisp-plus-cd0:unit-datum-p field)
               (values :declared-none :present))
              (t (values nil :malformed-in-evidence))))))

(defun %facet-integer (body namespace name)
  (if (null body)
      (values nil :absent-from-evidence)
      (let ((field (record-field body namespace name)))
        (cond ((null field) (values nil :absent-from-evidence))
              ((lisp-plus-cd0:integer-datum-p field)
               (values (lisp-plus-cd0:integer-datum-value field) :present))
              (t (values nil :malformed-in-evidence))))))

;;; ------------------------------------------------------------------
;;; DERIVE-SEAT-OUTCOME — the same evidence classes, the same precedence
;;; as vertical-census-0 (%DERIVE-SEAT-OUTCOME, census.lisp:49-108), with
;;; nothing dropped: provenance is a slot, the cap2 details plist is
;;; retained, absence is typed, and the object is TOTAL — the census's
;;; two hand-written guards are NOT errors here, because the facts they
;;; police stay visible on the object and the guards become MATCH-OUTCOME
;;; clauses (contract §3/§5).

(defun %reconciled-resolution-facet (details)
  "(values effect-string standing) for a :RECONCILED attempt, mirroring
%RECONCILED-RESOLUTION's mapping without its hard error: an unreadable
resolution is :MALFORMED-IN-EVIDENCE, an absent one
:ABSENT-FROM-EVIDENCE."
  (let ((event (getf details :reconciled)))
    (if (null event)
        (values nil :absent-from-evidence)
        (multiple-value-bind (resolution standing)
            (%facet-string (%event-body event) "reconciliation" "resolution")
          (case standing
            (:present
             (cond ((equal resolution "resolution:applied")
                    (values "reconciled-applied" :present))
                   ((equal resolution "resolution:not-applied")
                    (values "reconciled-not-applied" :present))
                   (t (values nil :malformed-in-evidence))))
            (t (values nil standing)))))))

(defun derive-seat-outcome (store events seat-id &key (namespace "vertical-event"))
  "One seat's COMPLETE outcome object, derived over the public
predecessor APIs the census uses: DERIVE-EFFECT-STANDING for the
execution axis (details RETAINED), the journaled seat events for the
manifestation / effect / refusal axes (readings TYPED).  NAMESPACE is the
event-id namespace of the vertical event family (the live projection
family is always \"ap0-event\", as in the census).  Never signals on
lawful stores: underivable facets are typed absences, and the census
guards live in the match layer."
  (let* ((attempt (format nil "a-~a" seat-id))
         (refusal-ev (%seat-event2 events namespace seat-id "refusal"))
         (closure-ev (%seat-event2 events namespace seat-id "stream-closure"))
         (live-ev (%seat-event2 events "ap0-event" seat-id "projection"))
         (recovery-ev (%seat-event2 events namespace seat-id "projection"))
         (control-ev (%seat-event2 events namespace seat-id "control-outcome"))
         (interp-ev (%seat-event2 events namespace seat-id "interpretation")))
    (multiple-value-bind (standing details) (derive-effect-standing store attempt)
      (let* ((provenance (cond (live-ev :live)
                               (recovery-ev :derived-recovery)
                               (t :none)))
             (projection-ev (case provenance
                              (:live live-ev)
                              (:derived-recovery recovery-ev)
                              (t nil)))
             (projection-ns (case provenance
                              (:live "ap0")
                              (:derived-recovery "vertical")
                              (t nil)))
             (evidence-class (cond (refusal-ev :refusal)
                                   (closure-ev :closure)
                                   (projection-ev :projection)
                                   (control-ev :control-outcome)
                                   ((eq standing :uncertain-unresolved)
                                    :uncertain)
                                   ((eq standing :reconciled) :reconciled)
                                   (t :none)))
             (standings nil)
             manifestation no-payload effect chunks refusal interpretation)
        (flet ((put (facet standing) (setf standings
                                           (list* facet standing standings))))
          ;; manifestation axis
          (ecase evidence-class
            (:refusal (setf manifestation "absent") (put :manifestation :present))
            (:closure (setf manifestation "present-partial")
                      (put :manifestation :present))
            (:projection
             (multiple-value-bind (v s)
                 (%facet-string (%event-body projection-ev) projection-ns
                                "kernel-manifestation-status")
               (setf manifestation v) (put :manifestation s)))
            ((:control-outcome :uncertain :reconciled)
             (setf manifestation "absent") (put :manifestation :present))
            (:none (setf manifestation nil)
                   (put :manifestation :absent-from-evidence)))
          ;; no-payload-state axis (a projection body field, nothing else)
          (if (eq evidence-class :projection)
              (multiple-value-bind (v s)
                  (%facet-string (%event-body projection-ev) projection-ns
                                 "no-payload-state")
                (setf no-payload v) (put :no-payload-state s))
              (progn (setf no-payload nil)
                     (put :no-payload-state :absent-from-evidence)))
          ;; effect axis
          (ecase evidence-class
            (:refusal (setf effect nil) (put :effect :absent-from-evidence))
            (:closure (setf effect "crossed-unsettled-partial-closed")
                      (put :effect :present))
            (:projection
             (if (eq standing :settled)
                 (progn (setf effect "settled") (put :effect :present))
                 ;; The cross-axis fact stays VISIBLE: provenance says a
                 ;; projection exists, execution-standing says not
                 ;; :settled; no effect is derivable and none is invented.
                 (progn (setf effect nil)
                        (put :effect :absent-from-evidence))))
            (:control-outcome
             (multiple-value-bind (v s)
                 (%facet-string (%event-body control-ev) "vertical" "standing")
               (setf effect v) (put :effect s)))
            (:uncertain (setf effect "uncertain-unresolved")
                        (put :effect :present))
            (:reconciled
             (multiple-value-bind (v s) (%reconciled-resolution-facet details)
               (setf effect v) (put :effect s)))
            (:none (setf effect nil) (put :effect :absent-from-evidence)))
          ;; chunks axis
          (if (eq evidence-class :closure)
              (multiple-value-bind (v s)
                  (%facet-integer (%event-body closure-ev) "vertical"
                                  "chunks-preserved")
                (setf chunks v) (put :chunks-preserved s))
              (progn (setf chunks :not-applicable)
                     (put :chunks-preserved :present)))
          ;; refusal axis — condition name and explanation kept distinct
          (if refusal-ev
              (multiple-value-bind (name name-standing)
                  (%facet-string (%event-body refusal-ev) "vertical" "refusal")
                (if (eq name-standing :present)
                    (progn
                      (setf refusal
                            (%make-refusal-description
                             :condition-name name
                             :explanation (%facet-string
                                           (%event-body refusal-ev)
                                           "vertical" "explanation")))
                      (put :refusal :present))
                    (progn (setf refusal nil) (put :refusal name-standing))))
              (progn (setf refusal nil) (put :refusal :absent-from-evidence)))
          ;; interpretation axis
          (if interp-ev
              (multiple-value-bind (v s)
                  (%facet-string (%event-body interp-ev) "vertical"
                                 "structural-class")
                (setf interpretation v) (put :interpretation s))
              (progn (setf interpretation :not-interpreted)
                     (put :interpretation :present))))
        (%make-seat-outcome
         :seat-id seat-id
         :attempt-name attempt
         :execution-standing standing
         :execution-evidence details
         :manifestation-status manifestation
         :no-payload-state no-payload
         :manifestation-provenance provenance
         :effect-standing effect
         :chunks-preserved chunks
         :refusal refusal
         :interpretation-class interpretation
         :evidence-class evidence-class
         :field-standings standings
         :source-events
         (loop for (label event) in (list (list :refusal refusal-ev)
                                          (list :stream-closure closure-ev)
                                          (list :live-projection live-ev)
                                          (list :recovery-projection recovery-ev)
                                          (list :control-outcome control-ev)
                                          (list :interpretation interp-ev))
               when event collect (cons label event)))))))

;;; ==================================================================
;;; THE PATTERN GRAMMAR (closed) AND ITS RUNTIME INTERPRETER.
;;; ==================================================================
;;;
;;; atom := (:execution KW) | (:provenance KW) | (:evidence-class KW)
;;;       | (:seat STRING)
;;;       | (:manifestation STRING | :absent-from-evidence
;;;                                | :malformed-in-evidence)
;;;       | (:no-payload-state ...same...) | (:effect ...same...)
;;;       | (:interpretation STRING | :not-interpreted | ...standings...)
;;;       | (:chunks-preserved INTEGER | :not-applicable | ...standings...)
;;;       | (:refusal :none | :retained | NAME)
;;; pattern := atom | (:and atom+)
;;;
;;; No axis reads one fact and asserts another; the closed set is the
;;; whole vocabulary, so the contract's forbidden inferences are not
;;; expressible.  No caller-supplied procedure enters: patterns are DATA
;;; interpreted by this package's own matcher.

(defparameter +execution-standings+
  '(:absent :prepared-only :crossed-unsettled :uncertain-unresolved
    :settled :reconciled))
(defparameter +provenances+ '(:live :derived-recovery :none))
(defparameter +evidence-classes+
  '(:refusal :closure :projection :control-outcome :uncertain :reconciled
    :none))
(defparameter +standing-keywords+ '(:absent-from-evidence :malformed-in-evidence))

(defun %atom-lawful-p (atom)
  (and (consp atom) (consp (cdr atom)) (null (cddr atom))
       (let ((axis (first atom)) (value (second atom)))
         (case axis
           (:execution (member value +execution-standings+))
           (:provenance (member value +provenances+))
           (:evidence-class (member value +evidence-classes+))
           (:seat (stringp value))
           ((:manifestation :no-payload-state :effect)
            (or (stringp value) (eq value :declared-none)
                (member value +standing-keywords+)))
           (:interpretation
            (or (stringp value) (eq value :not-interpreted)
                (member value +standing-keywords+)))
           (:chunks-preserved
            (or (and (integerp value) (>= value 0))
                (eq value :not-applicable)
                (member value +standing-keywords+)))
           (:refusal
            (or (member value '(:none :retained))
                (stringp value)
                (and (symbolp value) (not (keywordp value)))))
           (t nil)))))

(defun %canonical-atom (atom)
  "Canonical (AXIS VALUE) as a PROPER two-list — the expansion embeds
these under QUOTE, and this lane's own term2 grammar must be able to
account for its own expansions (a dotted pair would refuse).  Refusal
names are lowercased to their journaled string spelling so
BUDGET-CEILING-EXCEEDED and \"budget-ceiling-exceeded\" are one pattern,
not two."
  (let ((axis (first atom)) (value (second atom)))
    (list axis
          (if (and (eq axis :refusal) (symbolp value)
                   (not (member value '(:none :retained))))
              (string-downcase (symbol-name value))
              value))))

(defun %atom-key (canonical-atom)
  (format nil "~a=~s" (first canonical-atom) (second canonical-atom)))

(defun %canonicalize-pattern (pattern)
  "Pattern -> sorted list of canonical atoms.  Refuses
:PATTERN-NOT-IN-GRAMMAR when the pattern leaves the closed grammar."
  (let ((atoms (cond ((and (consp pattern) (eq (first pattern) :and))
                      (let ((conjuncts (rest pattern)))
                        (unless conjuncts
                          (%refuse :expansion :pattern-not-in-grammar
                                   :detail "(:and) with no conjuncts"))
                        conjuncts))
                     (t (list pattern)))))
    (dolist (atom atoms)
      (unless (%atom-lawful-p atom)
        (%refuse :expansion :pattern-not-in-grammar
                 :detail (format nil "~s is outside the closed pattern grammar"
                                 atom))))
    (sort (mapcar #'%canonical-atom atoms) #'string< :key #'%atom-key)))

(defun %atom-holds-p (outcome atom)
  (let ((axis (first atom)) (value (second atom)))
    (ecase axis
      (:execution (eq value (%so-execution-standing outcome)))
      (:provenance (eq value (%so-manifestation-provenance outcome)))
      (:evidence-class (eq value (%so-evidence-class outcome)))
      (:seat (equal value (%so-seat-id outcome)))
      ((:manifestation :no-payload-state :effect)
       (multiple-value-bind (v s)
           (ecase axis
             (:manifestation (seat-outcome-manifestation outcome))
             (:no-payload-state (seat-outcome-no-payload-state outcome))
             (:effect (seat-outcome-effect outcome)))
         (cond ((member value +standing-keywords+) (eq s value))
               ((eq value :declared-none)
                (and (eq s :present) (eq v :declared-none)))
               (t (and (eq s :present) (equal v value))))))
      (:interpretation
       (multiple-value-bind (v s) (seat-outcome-interpretation-class outcome)
         (cond ((member value +standing-keywords+) (eq s value))
               ((eq value :not-interpreted)
                (and (eq s :present) (eq v :not-interpreted)))
               (t (and (eq s :present) (equal v value))))))
      (:chunks-preserved
       (multiple-value-bind (v s) (seat-outcome-chunks-preserved outcome)
         (cond ((member value +standing-keywords+) (eq s value))
               ((eq value :not-applicable)
                (and (eq s :present) (eq v :not-applicable)))
               (t (and (eq s :present) (eql v value))))))
      (:refusal
       (multiple-value-bind (desc s) (seat-outcome-refusal outcome)
         (case value
           (:none (eq s :absent-from-evidence))
           (:retained (and (eq s :present) (refusal-description-p desc)))
           (t (and (eq s :present) (refusal-description-p desc)
                   (equal value (refusal-description-condition-name desc))))))))))

(defun %pattern-holds-p (outcome canonical-atoms)
  (every (lambda (atom) (%atom-holds-p outcome atom)) canonical-atoms))

(defun %facet-value (outcome axis)
  "Clause-local facet destructuring: the VALUE half of the facet reader.
The PARENT OUTCOME stays bound beside it; this is a convenience binding,
never a projection that replaces the object."
  (ecase axis
    (:seat (%so-seat-id outcome))
    (:attempt (%so-attempt-name outcome))
    (:execution (%so-execution-standing outcome))
    (:execution-evidence (%so-execution-evidence outcome))
    (:manifestation (nth-value 0 (seat-outcome-manifestation outcome)))
    (:no-payload-state (nth-value 0 (seat-outcome-no-payload-state outcome)))
    (:provenance (%so-manifestation-provenance outcome))
    (:effect (nth-value 0 (seat-outcome-effect outcome)))
    (:chunks-preserved (nth-value 0 (seat-outcome-chunks-preserved outcome)))
    (:refusal (nth-value 0 (seat-outcome-refusal outcome)))
    (:interpretation (nth-value 0 (seat-outcome-interpretation-class outcome)))
    (:evidence-class (%so-evidence-class outcome))))

(defparameter +facet-axes+
  '(:seat :attempt :execution :execution-evidence :manifestation
    :no-payload-state :provenance :effect :chunks-preserved :refusal
    :interpretation :evidence-class))

(defun signal-match-guard (code &key detail)
  "The public voice of the two census guards become structure: a
MATCH-OUTCOME clause that owns a guard calls this and the refusal is
typed, catalogued and retained.  Only the two :MATCH-phase codes are
speakable here."
  (unless (member code '(:projection-without-settled-execution
                         :no-evidence-class))
    (error "SIGNAL-MATCH-GUARD speaks only the two match-phase guard codes; ~
            got ~S" code))
  (%refuse :match code :detail detail))

(defun %require-seat-outcome (value form-name)
  (unless (seat-outcome-p value)
    (%refuse :runtime :not-a-seat-outcome
             :detail (format nil "~a requires a SEAT-OUTCOME; got ~a"
                             form-name (%describe-host-object value))
             :condition 'surface2-not-an-outcome))
  value)

;;; ==================================================================
;;; THE TWO FORMS (contract §3).
;;; ==================================================================

(defun %proper-list-p (object)
  "T iff OBJECT is a proper (finite, nil-terminated) list."
  (loop for tail = object then (cdr tail)
        while (consp tail)
        finally (return (null tail))))

(defmacro with-outcome (binding &body body)
  "Evaluate the binding's derivation form; refuse (typed,
SURFACE2-NOT-AN-OUTCOME) unless the value is a SEAT-OUTCOME; bind the
binding's variable for BODY.  The complete object stays bound; nothing
is projected away.  Erratum 0.1: BINDING is validated here — exactly a
proper two-element list (VAR DERIVATION-FORM) with VAR a bindable
symbol — so a malformed shape refuses :WITH-OUTCOME-BINDING-MALFORMED
through the discipline instead of escaping as a host lambda-list error."
  (unless (and (%proper-list-p binding) (= 2 (length binding)))
    (%refuse :expansion :with-outcome-binding-malformed
             :detail (format nil "~s is not a proper (VAR DERIVATION-FORM) ~
                                  two-element binding" binding)))
  (let ((var (first binding))
        (derivation-form (second binding)))
    (unless (and var (symbolp var) (not (keywordp var)))
      (%refuse :expansion :with-outcome-binding-malformed
               :detail (format nil "~s is not a bindable variable" var)))
    `(let ((,var ,derivation-form))
       (%require-seat-outcome ,var 'with-outcome)
       ,@body)))

(defun %parse-clause (clause var)
  "Clause -> (values canonical-atoms body otherwise-p).  Clause syntax:
  (PATTERN [:facets ((NAME AXIS)...)] BODY...)
  (otherwise [:facets ...] BODY...)"
  (unless (consp clause)
    (%refuse :expansion :pattern-not-in-grammar
             :detail (format nil "~s is not a clause" clause)))
  (let* ((head (first clause))
         (otherwise-p (eq head 'otherwise))
         (atoms (if otherwise-p nil (%canonicalize-pattern head)))
         (rest (rest clause))
         (bindings nil))
    (when (eq (first rest) :facets)
      ;; Erratum 0.1: the marker must be FOLLOWED by an explicit proper
      ;; specification list — a dangling :facets no longer vanishes.
      (unless (consp (cdr rest))
        (%refuse :expansion :facet-binding-malformed
                 :detail ":facets marker with no specification list"))
      (let ((specs (second rest)))
        (unless (and (%proper-list-p specs)
                     (every (lambda (spec)
                              (and (%proper-list-p spec)
                                   (consp spec) (symbolp (first spec))
                                   (not (keywordp (first spec)))
                                   (member (second spec) +facet-axes+)
                                   (null (cddr spec))))
                            specs))
          (%refuse :expansion :facet-binding-malformed
                   :detail (format nil "~s" specs)))
        ;; Erratum 0.1: facet variables unique within the clause, and
        ;; never the parent outcome variable — the parent stays
        ;; accessible under its bound name in every branch, literally.
        (let ((names (mapcar #'first specs)))
          (when (member var names)
            (%refuse :expansion :facet-binding-malformed
                     :detail (format nil "facet variable ~s would shadow ~
                                          the parent outcome variable" var)))
          (unless (= (length names)
                     (length (remove-duplicates names)))
            (%refuse :expansion :facet-binding-malformed
                     :detail (format nil "duplicate facet variables in ~s"
                                     names))))
        (setf bindings specs
              rest (cddr rest))))
    (let ((body (if bindings
                    `((let ,(mapcar (lambda (spec)
                                      `(,(first spec)
                                        (%facet-value ,var ,(second spec))))
                                    bindings)
                        ,@rest))
                    rest)))
      (values atoms body otherwise-p))))

(defmacro match-outcome (var &body clauses)
  "Dispatch on the facets of the SEAT-OUTCOME bound to VAR.  The
structural laws, checked AT EXPANSION with retained typed refusals:
an explicit OTHERWISE clause is REQUIRED (:NON-EXHAUSTIVE-MATCH);
duplicate patterns refuse (:DUPLICATE-PATTERN); a pattern shadowed by an
earlier equal-or-wider one refuses (:UNREACHABLE-PATTERN); patterns
outside the closed grammar refuse (:PATTERN-NOT-IN-GRAMMAR).  The parent
outcome remains bound in EVERY clause body, including OTHERWISE, which
receives the whole outcome — no expansion path reduces the outcome to
payload-or-NIL, a completion boolean, manifestation alone, or
condition-or-value."
  (unless (and var (symbolp var) (not (keywordp var)))
    (%refuse :expansion :match-var-not-a-symbol
             :detail (format nil "~s" var)))
  (unless clauses
    (%refuse :expansion :non-exhaustive-match
             :detail "MATCH-OUTCOME with no clauses matches nothing and owns nothing"))
  (let ((parsed nil) (otherwise-body nil) (otherwise-seen nil))
    (dolist (clause clauses)
      (multiple-value-bind (atoms body otherwise-p) (%parse-clause clause var)
        (cond
          (otherwise-p
           (when otherwise-seen
             (%refuse :expansion :duplicate-pattern
                      :detail "two OTHERWISE clauses"))
           (setf otherwise-seen t otherwise-body body))
          (otherwise-seen
           (%refuse :expansion :unreachable-pattern
                    :detail (format nil "~s follows OTHERWISE" (first clause))))
          (t
           (let ((keys (mapcar #'%atom-key atoms)))
             (dolist (prior parsed)
               (let ((prior-keys (second prior)))
                 (cond ((and (subsetp prior-keys keys :test #'string=)
                             (subsetp keys prior-keys :test #'string=))
                        (%refuse :expansion :duplicate-pattern
                                 :detail (format nil "~s" (first clause))))
                       ((subsetp prior-keys keys :test #'string=)
                        (%refuse :expansion :unreachable-pattern
                                 :detail (format nil
                                                 "~s is shadowed by an earlier equal-or-wider pattern"
                                                 (first clause)))))))
             (push (list atoms keys body) parsed))))))
    (unless otherwise-seen
      (%refuse :expansion :non-exhaustive-match
               :detail "MATCH-OUTCOME requires an explicit OTHERWISE clause"))
    (let ((clause-forms
            (mapcar (lambda (entry)
                      (let ((atoms (first entry)) (body (third entry)))
                        `((%pattern-holds-p ,var ',atoms)
                          ,@(if *%fault-project-payload-or-nil*
                                `((%facet-value ,var :manifestation))
                                body))))
                    (reverse parsed))))
      `(progn
         (%require-seat-outcome ,var 'match-outcome)
         (cond ,@clause-forms
               (t ,@(if *%fault-project-payload-or-nil*
                        `((%facet-value ,var :manifestation))
                        otherwise-body)))))))
