;;;; act1.lisp — One Act /1: the lane.
;;;;
;;;; ONE axis is added to One Act /0, and nothing else: PROCESS DEATH.  The
;;;; bridge discipline is inherited wholesale and re-stated here in this lane's
;;;; own words and its own code:
;;;;
;;;;   * identity systems are RELATED, never unified: the act-fixture row is an
;;;;     immutable relation between a language identity family (label, seat,
;;;;     process-context) and a runtime identity family (seat name, attempt
;;;;     name, cell, capability id).  No column is computed from another.
;;;;   * ONE bridge object per act, built through Core /0's PUBLIC constructor
;;;;     `make-adapter`, with ZERO Core /0 edits.  The bridge never LEARNS which
;;;;     act it serves: its act's identities are closed over at construction, in
;;;;     an immutable record, and there is no lookup, no table, and no key.
;;;;   * `EQ` is asserted between the registered bridge and the object
;;;;     `resolve-adapter` returns, BEFORE `perform` is called.
;;;;   * a recording that is never read back is not a binding; it is a hope with
;;;;     a field name.  "The append did not error" is not evidence the frame was
;;;;     written: this lane reads its frames back out of the VALIDATED PREFIX.
;;;;   * §19 reserved Kernel verbs are restated in package.lisp and UNCLAIMED.
;;;;
;;;; THE ONE NEW ORGAN is the DURABLE GUARD (`act1-durable-guard-verdict`): the
;;;; dispatch closure consults capability /2's `check-retry-safety-from-store`
;;;; — durable bytes alone, no image memory, the world not consulted — BEFORE
;;;; the frontier, and returns `:crossed nil` when the bytes forbid dispatch.
;;;; Core /0 then signals a typed pre-frontier `core0-refused` carrying the
;;;; evidence-so-far and a refused outcome.  That is the whole of the governing
;;;; sentence's first clause, executed rather than stated.
;;;;
;;;; ⚠ THE REFUSAL IS OVER-DETERMINED, AND THIS LANE SAYS SO IN ITS CODE AND
;;;; ITS RETURN.  capability /2's `authorize-effect-attempt` ALREADY consults
;;;; the same gate at the runtime boundary.  The lane guard is defence in depth
;;;; at the LANGUAGE boundary; the RED proof therefore kills the uncured bridge
;;;; by the REASON it carries, and the world-scope control (leak-write +
;;;; capability /2's own `:defect :auto-retry-on-uncertain`) is what exhibits an
;;;; actual unauthorised transition for the absence-instrument to catch.
;;;;
;;;; CANDIDATE.  Nothing here is adopted, and nothing here is independent
;;;; verification.
;;;;
;;;; — PONTIFEX (Claude Opus 5, subagent), 2026-08-19

(in-package #:lisp-plus-language-act1)

;;; ===========================================================================
;;; §0 — the check harness (shared by the suite, the controls and the mutants).
;;; ===========================================================================

(defvar *checks-passed* 0)
(defvar *checks-failed* 0)

;;; Declared early so every later form sees it as special.  The in-process
;;; suite binds it; the specimen stages build their rows through the public
;;; door and never touch it.
(defvar *act1-fixture-table* nil)

(defun act1-note (control &rest arguments)
  (format t "~&      | ~a~%" (apply #'format nil control arguments)))

(defun act1-check (name ok &optional (control "") &rest arguments)
  "NAME is folded through FORMAT with no arguments, so a source-wrapped label
(the ~<newline> continuation) prints as one line.  Labels therefore carry no
directive but the continuation."
  (if ok (incf *checks-passed*) (incf *checks-failed*))
  (format t "~&[~3,'0d] ~a ~a~@[ ~a~]~%"
          (+ *checks-passed* *checks-failed*)
          (if ok "ok  " "FAIL") (format nil name)
          (and (plusp (length control)) (apply #'format nil control arguments)))
  (finish-output)
  ok)

;;; ===========================================================================
;;; §1 — typed refusals.  Every refusal of this lane carries a requirement id;
;;; refusals are named by CONDITION TYPE + REQUIREMENT-ID, never by message
;;; text (SBCL's condition report text is not a stable interface).
;;; ===========================================================================

(define-condition act1-condition (error)
  ((detail :initarg :detail :initform nil :reader act1-condition-detail)
   (requirement-id :initarg :requirement-id :initform nil
                   :reader act1-condition-requirement-id))
  (:report (lambda (c s)
             (format s "~a [~a]: ~a" (type-of c)
                     (or (act1-condition-requirement-id c) "-")
                     (or (act1-condition-detail c) "")))))

(define-condition act1-fixture-table-invalid (act1-condition) ())
(define-condition act1-request-shape-refused (act1-condition) ())
(define-condition act1-request-lexis-refused (act1-condition) ())
(define-condition act1-authority-binding-refused (act1-condition) ())
(define-condition act1-dispatcher-binding-refused (act1-condition) ())
(define-condition act1-bridge-contract-violated (act1-condition) ())
(define-condition act1-readback-disagreement (act1-condition) ())
(define-condition act1-run-void (act1-condition) ())

(defun act1-refuse (type requirement-id control &rest arguments)
  (error type :requirement-id requirement-id
              :detail (apply #'format nil control arguments)))

;;; ===========================================================================
;;; §2 — CD/0 helpers (public constructors only).
;;; ===========================================================================

(defun idf (segments) (identifier-from-segments segments))
(defun s-datum (string) (lisp-plus-cd0:make-string-datum string))
(defun i-datum (integer) (lisp-plus-cd0:make-integer-datum integer))
(defun b-datum (octets) (lisp-plus-cd0:make-bytes-datum octets))
(defun entry (segments value)
  (lisp-plus-cd0:make-record-entry (idf segments) value))
(defun rec (&rest entries) (lisp-plus-cd0:make-record-datum entries))
(defun seq (elements) (lisp-plus-cd0:make-sequence-datum elements))
(defun oct (datum) (lisp-plus-cd0:canonical-octets datum))
(defun oct-len (o) (lisp-plus-cd0:octets-length o))
(defun oct-copy (o) (lisp-plus-cd0:octets-copy o))
(defun digest-of (datum) (sha256-hex (oct-copy (oct datum))))

;;; ===========================================================================
;;; §3 — the immutable act-fixture row.  THIS LANE'S OWN TABLE: One Act /0's
;;; frozen table is neither reused nor touched.
;;;
;;; ⚑ THERE IS NO `act-id` COLUMN, AND ITS ABSENCE IS THE POINT.  The act
;;; identity is DERIVED from this row's runtime seat and that act's canonical
;;; request, so it cannot be a column of a table validated before any request
;;; exists.  The derivation is over DECLARED inputs only, which is why a
;;; genuinely new process can re-derive the SAME act identity from the declared
;;; configuration alone — the demonstration the specimen exists to run.
;;; ===========================================================================

(defstruct (act1-fixture (:constructor %make-act1-fixture) (:copier nil))
  (arm             nil :read-only t)   ; the transcript's arm label
  (label           nil :read-only t)   ; LEGIBILITY ONLY: no identity role
  (language-label  nil :read-only t)   ; Core /0 process-context :label
  (runtime-seat    nil :read-only t)   ; ⚑ DERIVATION INPUT (ii)
  (attempt-name    nil :read-only t)   ; "a-<seat>" or "a-<seat>-<n>"
  (cell-segments   nil :read-only t)   ; the world cell identity's segments
  (adapter-symbol  nil :read-only t)   ; a lane-owned symbol, one per act
  (world-key       nil :read-only t)   ; :apply | :ambiguous
  (form            nil :read-only t)   ; the originating host request form
  (authority-mode  nil :read-only t)   ; :bound | :wrong-predicate | :ambient
  (revoke-after-mint nil :read-only t) ; the D1-refusal arm's declared property
  ;; ---- the /1 columns -----------------------------------------------------
  (durable-guard   :consult-store :read-only t)  ; :consult-store | :skip-store
  (interruption    nil :read-only t)   ; NIL | :request-lost (capability /2's seam)
  ;; PLANTED TEST SEAMS, production NIL, following capability /2's own `defect`
  ;; precedent (authorize.lisp:106, attempt.lisp:126):
  (runtime-defect  nil :read-only t)   ; passed to authorize-effect-attempt
  (project-defect  nil :read-only t)   ; :refusal-swallowed-to-success
  (host-fault-plant nil :read-only t)  ; :unexpected-error-before-frontier
  (leak-write      nil :read-only t))  ; a REFUSED path that writes anyway

(defun make-act1-fixture-row (&key arm label language-label runtime-seat
                                   attempt-name cell-segments adapter-symbol
                                   (world-key :apply) form
                                   (authority-mode :bound) revoke-after-mint
                                   (durable-guard :consult-store) interruption
                                   runtime-defect project-defect host-fault-plant
                                   leak-write)
  "THE LANE-LOCAL FIXTURE-CONSTRUCTION DOOR (work order §8(d)).  One Act /0 has
no such door — its rows are built by an internal constructor and its request
shape is hard-coded — so a memory layer could not drive it without editing it.
This door takes every column explicitly and validates the row on the spot; a
memory layer drives this lane by building rows here and calling `run-act1'."
  (let ((row (%make-act1-fixture
              :arm arm :label label
              :language-label (or language-label label)
              :runtime-seat runtime-seat :attempt-name attempt-name
              :cell-segments cell-segments :adapter-symbol adapter-symbol
              :world-key world-key :form form :authority-mode authority-mode
              :revoke-after-mint revoke-after-mint
              :durable-guard durable-guard :interruption interruption
              :runtime-defect runtime-defect :project-defect project-defect
              :host-fault-plant host-fault-plant :leak-write leak-write)))
    (validate-act1-fixture-table :table (list row) :cross-row nil)
    row))

(defun act1-request-form (cell text)
  "The originating host request form.  ⚠ THE SHAPE IS THE ROW'S, not the
lane's: a memory layer that wants another predicate passes another form; the
lane reads the predicate out of the canonical request and never assumes it."
  `(:predicate :inscribe (:cell ,cell) (:text ,text)))

;;; --- the lane's RENDERING alphabet, for FIXED LANE-OWNED TEXTUAL SEGMENTS
;;; --- ONLY.  It NEVER governs a request role value: :cell and :text carry the
;;; --- owner's wider grammars (§4 below).
(defun act1-segment-char-p (ch)
  (or (char<= #\a ch #\z) (char<= #\0 ch #\9) (char= ch #\-)))

(defun act1-segment-lawful-p (string)
  (and (stringp string) (plusp (length string)) (<= (length string) 64)
       (every #'act1-segment-char-p string)))

(defun hex64-p (string)
  "The digest segment is EXACTLY 64 lowercase hexadecimal characters —
asserted by LENGTH and by CHARACTER CLASS, never by eyeball."
  (and (stringp string) (= 64 (length string))
       (every (lambda (c) (find c "0123456789abcdef")) string)))

(defun act1-attempt-name-lawful-p (attempt-name seat)
  "⚑ BUILDER FORK F-2, DECLARED.  One Act /0's T4-LAW forces attempt-name to be
exactly \"a-<seat-id>\", because /0's seats feed Surface /2's
`derive-seat-outcome`, which computes that string.  ONE ACT /1 CANNOT OBEY IT:
its whole subject is a seat that carries MORE THAN ONE act — the dead act, and
the fresh act on the freed seat.  So this lane widens the rule to
\"a-<seat>\" | \"a-<seat>-<n>\" (n a nonempty digit string) and CLAIMS NOTHING
about Surface /2 compatibility: this lane has no Surface /2 edge, mints no
surface head, and no artifact of it may be read as progress toward one."
  (let ((base (format nil "a-~a" seat)))
    (and (stringp attempt-name)
         (or (string= attempt-name base)
             (let ((prefix (concatenate 'string base "-")))
               (and (> (length attempt-name) (length prefix))
                    (string= prefix (subseq attempt-name 0 (length prefix)))
                    (every #'digit-char-p (subseq attempt-name (length prefix)))))))))

(defun validate-act1-fixture-table (&key (table *act1-fixture-table*)
                                         (process-name +act1-runtime-process-name+)
                                         (cross-row t))
  "Row laws on every row; cross-row distinctness only when a whole table is
being validated (a single row built through the public door validates itself,
which is why CROSS-ROW is a parameter and not an assumption)."
  (dolist (f table)
    (unless (act1-segment-lawful-p (act1-fixture-label f))
      (act1-refuse 'act1-fixture-table-invalid "ACT1-FX-1"
                   "fixture label ~s is not lawful under the rendering alphabet"
                   (act1-fixture-label f)))
    (unless (act1-segment-lawful-p (act1-fixture-runtime-seat f))
      (act1-refuse 'act1-fixture-table-invalid "ACT1-FX-2"
                   "runtime seat-id ~s is not lawful under the rendering alphabet"
                   (act1-fixture-runtime-seat f)))
    (unless (act1-attempt-name-lawful-p (act1-fixture-attempt-name f)
                                        (act1-fixture-runtime-seat f))
      (act1-refuse 'act1-fixture-table-invalid "ACT1-FX-3"
                   "attempt-name ~s is not \"a-~a\" or \"a-~a-<n>\""
                   (act1-fixture-attempt-name f) (act1-fixture-runtime-seat f)
                   (act1-fixture-runtime-seat f)))
    (dolist (segment (act1-fixture-cell-segments f))
      (unless (act1-segment-lawful-p segment)
        (act1-refuse 'act1-fixture-table-invalid "ACT1-FX-4"
                     "cell segment ~s is not lawful under the rendering alphabet"
                     segment)))
    (unless (and (symbolp (act1-fixture-adapter-symbol f))
                 (act1-fixture-adapter-symbol f))
      (act1-refuse 'act1-fixture-table-invalid "ACT1-FX-5"
                   "the row's adapter designator is not a symbol: ~s"
                   (act1-fixture-adapter-symbol f)))
    (unless (member (act1-fixture-world-key f) '(:apply :ambiguous))
      (act1-refuse 'act1-fixture-table-invalid "ACT1-FX-6"
                   "world key ~s is outside {:apply :ambiguous}"
                   (act1-fixture-world-key f)))
    (unless (member (act1-fixture-authority-mode f)
                    '(:bound :wrong-predicate :ambient))
      (act1-refuse 'act1-fixture-table-invalid "ACT1-FX-7"
                   "authority mode ~s is outside the declared three"
                   (act1-fixture-authority-mode f)))
    (unless (member (act1-fixture-durable-guard f) '(:consult-store :skip-store))
      (act1-refuse 'act1-fixture-table-invalid "ACT1-FX-8"
                   "durable guard ~s is outside {:consult-store :skip-store}"
                   (act1-fixture-durable-guard f))))
  (when cross-row
    (flet ((distinct (key what requirement)
             (let ((seen '()))
               (dolist (f table)
                 (let ((value (funcall key f)))
                   (when (member value seen :test #'equal)
                     (act1-refuse 'act1-fixture-table-invalid requirement
                                  "two fixture rows share ~a ~s" what value))
                   (push value seen))))))
      ;; ⚑ SEATS ARE **NOT** DISTINCT IN THIS LANE, and that is the /1 subject:
      ;; the fresh act sits in the FREED SEAT of the dead one.  What must stay
      ;; distinct is the ATTEMPT identity, the bridge symbol, and the act
      ;; identity (derived, checked at mint time by the run-local set).
      (distinct #'act1-fixture-attempt-name  "attempt name"          "ACT1-FX-9")
      (distinct #'act1-fixture-adapter-symbol "bridge adapter symbol" "ACT1-FX-10")))
  (unless (act1-segment-lawful-p process-name)
    (act1-refuse 'act1-fixture-table-invalid "ACT1-FX-11"
                 "runtime process name ~s is not lawful under the rendering alphabet"
                 process-name))
  (dolist (f table)
    (when (or (string= process-name (act1-fixture-language-label f))
              (string= process-name (act1-fixture-runtime-seat f)))
      (act1-refuse 'act1-fixture-table-invalid "ACT1-FX-12"
                   "runtime process name ~s collides with a fixture seat/label"
                   process-name)))
  t)

;;; ===========================================================================
;;; §4 — the request lexis and shape.
;;;
;;; ⚑ BUILDER FORK F-6, DECLARED.  These four small checkers are One Act /0's
;;; owner-ruled grammars re-implemented lane-locally rather than imported from
;;; `#:lisp-plus-language-act0`.  The reason is load-graph containment: /0's
;;; lane pulls Surface /2 through its ASDF edge, and this lane must not acquire
;;; a Surface /2 edge for four predicates.  The GRAMMARS ARE THE SAME; the code
;;; is this lane's.  NO MAXIMUM LENGTH — length is not a lexis law here.
;;; ===========================================================================

(defun printable-ascii-no-space-p (ch) (<= #x21 (char-code ch) #x7E))
(defun printable-ascii-or-space-p (ch) (<= #x20 (char-code ch) #x7E))

(defun %lexis-refuse (role string index)
  "⚠ THE OFFENDING CHARACTER IS NEVER ECHOED LITERALLY — echoing it would put
the injection into the compared bytes.  The refusal names the role, the code
point IN HEX, and the ZERO-BASED index."
  (act1-refuse 'act1-request-lexis-refused "ACT1-LEX-1"
               "role ~a: code point 0x~2,'0X at zero-based index ~d"
               role (char-code (char string index)) index))

(defun check-act1-cell-lexis (cell-string &key resource-rendering)
  "Nonempty · printable ASCII U+0021..U+007E only · NO SPACE · STRING= to the
rendered Capability /0 resource term when one is supplied."
  (unless (stringp cell-string)
    (act1-refuse 'act1-request-shape-refused "ACT1-SHAPE-1"
                 ":cell role value is not a host string"))
  (when (zerop (length cell-string))
    (act1-refuse 'act1-request-lexis-refused "ACT1-LEX-1"
                 "role :cell: the empty string is refused pre-frontier"))
  (loop for i below (length cell-string)
        unless (printable-ascii-no-space-p (char cell-string i))
          do (%lexis-refuse :cell cell-string i))
  (when resource-rendering
    (unless (string= cell-string resource-rendering)
      (act1-refuse 'act1-authority-binding-refused "ACT1-BIND-1"
                   ":cell ~s is not STRING= to the rendered grant resource ~s"
                   cell-string resource-rendering)))
  t)

(defun check-act1-text-lexis (text-string)
  "Nonempty · printable ASCII U+0020..U+007E · no leading or trailing space,
checked BY CODE POINT on the first and last characters."
  (unless (stringp text-string)
    (act1-refuse 'act1-request-shape-refused "ACT1-SHAPE-1"
                 ":text role value is not a host string"))
  (let ((n (length text-string)))
    (when (zerop n)
      (act1-refuse 'act1-request-lexis-refused "ACT1-LEX-1"
                   "role :text: the empty string is refused pre-frontier"))
    (loop for i below n
          unless (printable-ascii-or-space-p (char text-string i))
            do (%lexis-refuse :text text-string i))
    (when (= #x20 (char-code (char text-string 0)))
      (%lexis-refuse :text text-string 0))
    (when (= #x20 (char-code (char text-string (1- n))))
      (%lexis-refuse :text text-string (1- n))))
  t)

(defun act1-request-roles (normal-form)
  "The normal form is (:predicate KW (ROLE VALUE)…)."
  (cddr normal-form))

(defun project-act1-request (normal-form)
  "cell-string := the :cell role's value; value-string := the :text role's
value.  A missing or non-string role, or any ADDITIONAL role, REFUSES."
  (let ((cell nil) (text nil) (extra '()))
    (dolist (pair (act1-request-roles normal-form))
      (case (first pair)
        (:cell (setf cell (second pair)))
        (:text (setf text (second pair)))
        (t (push (first pair) extra))))
    (when extra
      (act1-refuse 'act1-request-shape-refused "ACT1-SHAPE-1"
                   "request carries additional role(s) ~s" (reverse extra)))
    (unless (and cell text)
      (act1-refuse 'act1-request-shape-refused "ACT1-SHAPE-1"
                   "request is missing ~a" (if (null cell) ":cell" ":text")))
    (values cell text)))

(defun canonicalize-act1-request (form &key resource-rendering (lexis t))
  "Canonicalize through Slice /1, then run the lexis check.  Failure here is a
PRE-ACT MALFORMED INVOCATION: no act, no Outcome, and NO FABRICATED ATTEMPT
IDENTITY."
  (let ((nf (lisp-plus-slice1:proposition form)))
    (multiple-value-bind (cell text) (project-act1-request nf)
      (when lexis
        (check-act1-cell-lexis cell :resource-rendering resource-rendering)
        (check-act1-text-lexis text)))
    nf))

(defun act1-request-record (normal-form)
  "ONE rendering law serves BOTH the act identity and the request digest, so
the two can never disagree about what \"the canonical request\" is.  Roles ride
IN NORMAL-FORM ORDER, which Slice /1 has already sorted."
  (rec (entry '("request" "predicate")
              (s-datum (symbol-name (second normal-form))))
       (entry '("request" "roles")
              (seq (mapcar (lambda (pair)
                             (let ((value (second pair)))
                               (unless (stringp value)
                                 (act1-refuse 'act1-request-lexis-refused
                                              "ACT1-LEX-2"
                                              "role ~a value is not a host string"
                                              (first pair)))
                               (rec (entry '("role" "name")
                                           (s-datum (symbol-name (first pair))))
                                    (entry '("role" "value") (s-datum value)))))
                           (act1-request-roles normal-form))))
       (entry '("request" "rendering") (i-datum +act1-request-rendering-version+))))

(defun act1-request-octets (request-record) (oct request-record))

;;; ===========================================================================
;;; §5 — the derived act identity.
;;;
;;; ⚠ A SEQUENCE, NOT A RECORD: CD/0 record entries are SORTED BY KEY OCTETS at
;;; construction, so a record's encoding order is the KEY order, not the
;;; DECLARED order.  A CD/0 sequence datum is the construct whose order is the
;;; declared one.  EACH ELEMENT IS A TYPED, LENGTH-DELIMITED CD/0 DATUM: there
;;; is no string joining, no separator, no FORMAT, and no octet concatenation
;;; anywhere in the construction — two distinct input triples cannot produce one
;;; preimage encoding.
;;;
;;; ⚑ THE /1 CONSEQUENCE: every input is DECLARED CONFIGURATION.  A genuinely
;;; new process re-derives the SAME act identity from the same declared row —
;;; which is how the language identity survives a death that the in-image Core
;;; /0 evidence cannot: NOT as carried state, as a DERIVATION.
;;; ===========================================================================

(defvar *act1-minted-this-run* '()
  "The run-local set of minted act identities.  A convenience that fails FAST;
it is NOT a durability claim and says nothing about other processes.")

(defun act1-id-preimage (seat-id request-octets)
  (seq (list (s-datum +act1-id-domain+)                 ; (i)   the domain
             (idf (list "seat" seat-id))                ; (ii)  the runtime seat
             (b-datum (oct-copy request-octets)))))     ; (iii) the request

(defun mint-act1-identity (seat-id request-octets &key (register t) (verbose nil))
  "Returns (values act-id digest-hex preimage-octet-length)."
  (let* ((preimage (act1-id-preimage seat-id request-octets))
         (preimage-octets (oct preimage))
         (digest (sha256-hex (oct-copy preimage-octets))))
    (unless (hex64-p digest)
      (act1-refuse 'act1-fixture-table-invalid "ACT1-ID-1"
                   "the digest segment is not exactly 64 lowercase hex characters: ~s"
                   digest))
    (let ((act-id (idf (list +act1-lane-stem+ "act" digest))))
      (when verbose
        (act1-note "derivation: domain=~s" +act1-id-domain+)
        (act1-note "derivation: seat=~a" (identifier-segment-string
                                          (idf (list "seat" seat-id))))
        (act1-note "derivation: request=~d octets · preimage=~d octets"
                   (oct-len request-octets) (oct-len preimage-octets))
        (act1-note "derivation: act-id=~a" (identifier-segment-string act-id)))
      (when register
        (when (find act-id *act1-minted-this-run* :test #'datum=)
          (act1-refuse 'act1-fixture-table-invalid "ACT1-ID-2"
                       "act identity ~a was already minted in this process"
                       (identifier-segment-string act-id)))
        (push act-id *act1-minted-this-run*))
      (values act-id digest (oct-len preimage-octets)))))

(defstruct (act1-record (:constructor %make-act1-record) (:copier nil))
  "THE ONE IMMUTABLE ACT RECORD: the fixture row plus the identity derived from
it.  Read-only from that instant."
  (fixture     nil :read-only t)
  (act-id      nil :read-only t)
  (act-id-hex  nil :read-only t)
  (normal-form nil :read-only t)
  (request-rec nil :read-only t)
  (request-oct nil :read-only t))

(defun make-act1-record (fixture &key (lexis t) (register t))
  "REGISTER NIL is for PURE RE-DERIVATION ONLY — a cold read or a cross-life
identity comparison, which is not an act and must not consume an identity in
the run-local set."
  (let* ((resource (identifier-segment-string
                    (getf (act1-grant-terms-for fixture) :resource)))
         (nf (canonicalize-act1-request (act1-fixture-form fixture)
                                        :resource-rendering resource
                                        :lexis lexis))
         (request (act1-request-record nf))
         (octets (act1-request-octets request)))
    (multiple-value-bind (act-id digest)
        (mint-act1-identity (act1-fixture-runtime-seat fixture) octets
                            :register register)
      (%make-act1-record :fixture fixture :act-id act-id :act-id-hex digest
                         :normal-form nf :request-rec request
                         :request-oct octets))))

;;; ===========================================================================
;;; §6 — the declared authority terms and Office L.
;;; ===========================================================================

(defparameter +act1-subject+ '("subject" "scriba"))
(defparameter +act1-action+  '("action"  "inscribere"))
(defparameter +act1-scope+   '("scope"   "semel"))
(defparameter +act1-issuer+  '("issuer"  "oneact1"))

(defun act1-grant-terms-for (fixture)
  "The four terms of the Capability /0 GRANT this act's Office R capability is
minted from.  THE PER-SEAT RESOURCE IS THE SEAT'S EFFECT-CELL IDENTITY."
  (list :subject (idf +act1-subject+)
        :action (idf +act1-action+)
        :resource (idf (act1-fixture-cell-segments fixture))
        :scope (idf +act1-scope+)))

(defun act1-capability-id-for (fixture)
  (list "cap" (act1-fixture-runtime-seat fixture)))

(defun act1-bind-offices (adapter-name normal-form)
  "A CONSTRUCTION OF A TEST FIXTURE from the canonical request, never an
authority operation: it mints nothing any Kernel §11 verb would recognise.
One act, one predicate, one cell — the ruling's predicate list is length 1."
  (lisp-plus-core0:mint-capability
   :ruling (lisp-plus-core0:fixture-sealed-ruling
            :adapter-name adapter-name
            :predicates (list (second normal-form))
            :minter +act1-bind-offices-minter+)))

(defun act1-office-l-capability (fixture normal-form)
  "⚠ The two control modes are minted through THE CONTROL DOOR, which bypasses
the binding checks.  They exist precisely so that `perform`'s own authority law
is EXERCISED and not merely present."
  (ecase (act1-fixture-authority-mode fixture)
    (:bound (act1-bind-offices (act1-fixture-adapter-symbol fixture) normal-form))
    (:wrong-predicate
     (lisp-plus-core0:mint-capability
      :ruling (lisp-plus-core0:fixture-sealed-ruling
               :adapter-name (act1-fixture-adapter-symbol fixture)
               :predicates '(:delere)
               :minter +act1-bind-offices-minter+)))
    (:ambient nil)))                   ; :authority NIL => ambient-authority-forbidden

(defun act1-bind-checks (fixture normal-form office-l cell-string)
  "The binding checks that can run before the bridge object exists.  Returns
the Office L mint-receipt capability-id string, read through Core /0's public
`capability-mint-receipt-of`."
  (let ((terms (act1-grant-terms-for fixture)))
    ;; BIND-1 — a STRING comparison against the PUBLIC RENDERING of the grant's
    ;; resource term.  No parsing, no re-segmentation, no assumption about the
    ;; separator.
    (unless (string= cell-string (identifier-segment-string (getf terms :resource)))
      (act1-refuse 'act1-authority-binding-refused "ACT1-BIND-1"
                   ":cell ~s is not STRING= to the rendered grant resource ~s"
                   cell-string (identifier-segment-string (getf terms :resource))))
    (when office-l
      (let ((predicates (getf (lisp-plus-core0:capability-scope office-l) :predicates)))
        ;; NARROWNESS — every arm, no exception: one act, one predicate.
        (unless (= 1 (length predicates))
          (act1-refuse 'act1-authority-binding-refused "ACT1-BIND-3N"
                       "the fixture ruling's predicate list is not length 1: ~s"
                       predicates))
        ;; IDENTITY — strict-path arms only; the control arm's escape from it is
        ;; exactly what `perform`'s frontier check must catch.
        (when (eq :bound (act1-fixture-authority-mode fixture))
          (unless (equal predicates (list (second normal-form)))
            (act1-refuse 'act1-authority-binding-refused "ACT1-BIND-3I"
                         "the fixture ruling authorises ~s, not the request's ~s"
                         predicates (list (second normal-form)))))
        ;; The fixture ruling's adapter-name is EQ to the SYMBOL under which
        ;; this act's bridge object will be registered.
        (unless (eq (getf (lisp-plus-core0:capability-scope office-l) :adapter)
                    (act1-fixture-adapter-symbol fixture))
          (act1-refuse 'act1-authority-binding-refused "ACT1-BIND-2A"
                       "the fixture ruling names adapter ~s, not ~s"
                       (getf (lisp-plus-core0:capability-scope office-l) :adapter)
                       (act1-fixture-adapter-symbol fixture)))))
    ;; The :adapter argument passed to `perform` is THAT SYMBOL, never a
    ;; core0-adapter object: `resolve-adapter` passes a supplied OBJECT straight
    ;; through and the frontier check then compares only the NAME, so the
    ;; object-argument channel is removed here.
    (unless (symbolp (act1-fixture-adapter-symbol fixture))
      (act1-refuse 'act1-authority-binding-refused "ACT1-BIND-2C"
                   "the form's :adapter is not a symbol"))
    (if office-l
        (durable-identity-name
         (lisp-plus-kernel0:capability-mint-receipt-capability-id
          (lisp-plus-core0:capability-mint-receipt-of office-l)))
        "none:ambient-authority-control")))

;;; ===========================================================================
;;; §7 — the per-act dispatch context, the verdict slot, and the bridge.
;;;
;;; ONE BRIDGE IMPLEMENTATION, ONE BRIDGE OBJECT PER ACT.  The bridge therefore
;;; NEVER "LEARNS" WHICH ACT IT SERVES.  It cannot be wrong about it, because it
;;; has no way to be about any other act: the act's identities are closed over
;;; at construction, in an immutable record, and there is no lookup, no table,
;;; and no key.  Forbidden and absent: a request-keyed shared table · a mutable
;;; "current act" cell · ambient dynamic selection · a global registry entry
;;; shared by all arms · a construction-time capture of a capability that does
;;; not yet exist.
;;; ===========================================================================

(defstruct (act1-dispatch-context (:constructor %make-act1-dispatch-context)
                                  (:copier nil))
  "Constructed ONCE, fully, and READ-ONLY thereafter.  No field is assigned into
it after construction."
  (act-id nil :read-only t) (normal-form nil :read-only t)
  (process nil :read-only t) (seat-name nil :read-only t)
  (attempt-name nil :read-only t) (cell-segments nil :read-only t)
  (capability nil :read-only t)          ; the Office R live capability
  (store nil :read-only t) (world nil :read-only t)
  (bootstrap nil :read-only t) (minting-context nil :read-only t)
  (grant-terms nil :read-only t) (capability-id nil :read-only t)
  (process-name nil :read-only t)
  (durable-guard nil :read-only t) (interruption nil :read-only t)
  (runtime-defect nil :read-only t) (project-defect nil :read-only t)
  (host-fault-plant nil :read-only t) (leak-write nil :read-only t))

(defstruct (act1-verdict (:constructor %make-act1-verdict) (:copier nil))
  "A PER-ACT DIAGNOSTIC SINK, and nothing else.  Core /0's `perform` does not
return the adapter report's :reason, and the reason must not be recovered by
parsing a condition's report text (message text is not a stable interface).  So
each act carries one write-once slot that the bridge WRITES and NEVER READS.
Nothing dispatches on it; it selects nothing; it is created per act, not
shared.  Writing it twice is a lane fault, signalled, not overwritten."
  (reason nil) (guard nil) (written 0))

(defun set-act1-verdict (verdict &key reason guard)
  (when (plusp (act1-verdict-written verdict))
    (act1-refuse 'act1-bridge-contract-violated "ACT1-VERDICT-1"
                 "the per-act verdict slot was written twice (first ~s, now ~s)"
                 (act1-verdict-reason verdict) reason))
  (setf (act1-verdict-reason verdict) reason
        (act1-verdict-guard verdict) guard
        (act1-verdict-written verdict) 1)
  verdict)

(defun act1-condition-requirement (c)
  "Refusals are named by CONDITION TYPE + REQUIREMENT-ID, never by message
text."
  (typecase c
    (act1-condition (act1-condition-requirement-id c))
    (lisp-plus-capability2:cap2-condition
     (lisp-plus-capability2:cap2-condition-requirement-id c))
    (lisp-plus-capability1:cap1-condition
     (lisp-plus-capability1:cap1-condition-requirement-id c))
    (lisp-plus-capability0:cap0-condition
     (lisp-plus-capability0:cap0-condition-requirement-id c))
    (lisp-plus-journal0:pj0-condition
     (lisp-plus-journal0:pj0-condition-requirement-id c))
    (lisp-plus-kernel0:kernel0-condition
     (lisp-plus-kernel0:kernel0-condition-requirement-id c))
    ;; ⚠ THE FALLTHROUGH IS NOW UNREACHABLE FROM THE DISPATCH HANDLER, and that
    ;; is the repair's point.  Before 2026-08-20 an unadmitted condition (a
    ;; TYPE-ERROR) landed here and got "-", producing a reason keyword
    ;; SHAPE-IDENTICAL to a legitimate one whose family genuinely carries no
    ;; requirement id (ACT1-DURABLE-GUARD/UNSAFE-RETRY/-).  That collision is
    ;; how the defect hid.  The branch stays because this reader is also called
    ;; on post-frontier diagnostics, where an honest "-" is still the truth.
    (t "-")))

(defun act1-class-b-reason (condition-type requirement-id)
  "A STABLE keyword naming the condition type AND its requirement id."
  (intern (format nil "~a/~a" condition-type (or requirement-id "-")) :keyword))

(defun act1-guard-reason (condition)
  "⚑ THE GUARD'S REASON IS DISTINGUISHABLE FROM THE RUNTIME BOUNDARY'S BY
CONSTRUCTION.  Both refusals are pre-frontier and both are lawful; the lane
must be able to say WHICH ONE FIRED, because that difference — and only that
difference — is what the uncured-bridge RED proof turns on."
  (intern (format nil "ACT1-DURABLE-GUARD/~a/~a"
                  (type-of condition) (or (act1-condition-requirement condition) "-"))
          :keyword))

(defun act1-durable-guard-verdict (store &key seat-name candidate-attempt-name)
  "THE LANGUAGE DOOR'S DURABLE REFUSAL, in one function.

Provenance, stated exactly: the ONLY input is STORE — capability /2 folds its
VALIDATED PREFIX (durable PJ0 bytes), rehydrates kernel /0 records from those
bytes, and runs kernel /0's adopted `check-retry-safety`.  No image memory, no
process self-report, no clock, and NOT THE WORLD participate.  In a resurgent
image there is nothing else to consult, which is the point.

Returns (values :lawful nil) or (values :refuse REASON-KEYWORD CONDITION)."
  (handler-case
      (progn (check-retry-safety-from-store
              store :seat-name seat-name
              :candidate-attempt-name candidate-attempt-name)
             (values :lawful nil nil))
    (lisp-plus-kernel0:unsafe-retry (c)
      (values :refuse (act1-guard-reason c) c))))

(defun external-request-key (attempt-name)
  "The world-ledger key capability /2 computes for an attempt
(attempt.lisp:212-213), rendered publicly."
  (identifier-segment-string
   (idf (list "external-request" "cap2" attempt-name))))

(defun make-act1-bridge (adapter-symbol context verdict)
  "ONE bridge implementation, constructed through Core /0's PUBLIC constructor
`make-adapter`, with ZERO Core /0 edits, over THIS ACT'S OWN immutable context
and registered under THIS ACT'S OWN symbol."
  (lisp-plus-core0:make-adapter
   :name adapter-symbol
   :identity (lisp-plus-kernel0:make-identity
              :principal (format nil "oneact1/bridge/~a"
                                 (act1-dispatch-context-seat-name context)))
   :version 0
   :dispatch (lambda (adapter request attempt-id)
               (declare (ignore adapter attempt-id))
               (act1-dispatch context verdict request))
   :ledger-query (lambda (adapter attempt-id request)
                   (declare (ignore adapter attempt-id request))
                   (act1-ledger-query context))))

(defun %act1-planted-implementation-fault (context)
  "⚠ PLANTED HOST FAULT, CONTROLS ONLY (production NIL).

Not `(error 'type-error ...)` — a DECLARED signal of an undeclared type is
still a declaration, and would not test what an unexpected error does.  This is
the lane genuinely misusing one of its own values: the process name is a STRING,
and CAR of a string is a TYPE-ERROR raised by the implementation, exactly as an
ordinary slip in this dispatch would raise one."
  (let ((process-name (act1-dispatch-context-process-name context)))
    (car process-name)))

(defun %act1-refusal-plist (reason)
  (list :crossed nil :committed nil :acknowledged nil
        :local-record-lands nil :ledger-token nil
        :manifestation-status :declared-none
        :reason reason))

(defun act1-dispatch (context verdict normal-form)
  "Inside ONE call: G the durable guard · D0 project+lexis · D1 authorize ·
D2 the frontier · D3 classify · D4 project.

THE NO-APPEND LAW: BETWEEN D1 AND D2 THE LANE APPENDS NOTHING.  Placing them
inside one closure with nothing between them satisfies it by construction.

G IS NEW IN /1 AND SITS ABOVE EVERYTHING: before the request is even projected,
the durable bytes are asked whether dispatch into this seat is lawful at all."
  (let* ((store (act1-dispatch-context-store context))
         (attempt-name (act1-dispatch-context-attempt-name context))
         (seat-name (act1-dispatch-context-seat-name context))
         (guard-verdict :not-consulted)
         (guard-reason nil))
    ;; ---- G.  The durable guard.
    (when (eq :consult-store (act1-dispatch-context-durable-guard context))
      (multiple-value-bind (decision reason)
          (act1-durable-guard-verdict store :seat-name seat-name
                                            :candidate-attempt-name attempt-name)
        (setf guard-verdict decision guard-reason reason)
        (when (and (eq decision :refuse)
                   (not (act1-dispatch-context-leak-write context)))
          ;; ⚠ PLANTED MUTANT SEAM (mutants only; production NIL).  The guard
          ;; refused and the bridge reports SUCCESS anyway — the exact
          ;; :refusal-swallowed-to-success defect, wired into the real path so
          ;; the kill is a kill of the shipped code, not of a fake.
          ;; ⚑ THE FORGED TOKEN IS PART OF THE MUTANT, and it is what makes the
          ;; mutant WORTH killing: with `:ledger-token nil` Core /0 kills the
          ;; defect by itself (its manifestation constructor refuses a nameless
          ;; identity), so the lane's own class table would never be exercised.
          ;; The forged token carries the defect PAST Core /0 and into the
          ;; lane's classifier, which is the predicate under test.
          (when (eq :refusal-swallowed-to-success
                    (act1-dispatch-context-project-defect context))
            (set-act1-verdict verdict :reason reason :guard :refused-and-swallowed)
            (return-from act1-dispatch
              (list :crossed t :committed t :acknowledged t :local-record-lands t
                    :ledger-token "forged-token-in-no-ledger"
                    :manifestation-status :declared-present
                    :reason nil)))
          (set-act1-verdict verdict :reason reason :guard :refused)
          (return-from act1-dispatch (%act1-refusal-plist reason)))))
    ;; ---- D0.  A request-shape or lexis failure inside DISPATCH must NOT
    ;; ---- escape as an unclassified foreign condition; it is PROJECTED into
    ;; ---- the declared refusal plist and returned normally, so `perform`
    ;; ---- reaches its own refusal path and produces the refused Outcome the
    ;; ---- governing sentence promises — one form, one act, one Outcome, in
    ;; ---- the failure mode too.
    (multiple-value-bind (cell text)
        (handler-case (project-act1-request normal-form)
          (act1-request-shape-refused (c)
            (let ((reason (act1-class-b-reason 'act1-request-shape-refused
                                               (act1-condition-requirement-id c))))
              (set-act1-verdict verdict :reason reason :guard guard-verdict)
              (return-from act1-dispatch (%act1-refusal-plist reason)))))
      (handler-case (progn (check-act1-cell-lexis cell) (check-act1-text-lexis text))
        (act1-request-lexis-refused (c)
          (let ((reason (act1-class-b-reason 'act1-request-lexis-refused
                                             (act1-condition-requirement-id c))))
            (set-act1-verdict verdict :reason reason :guard guard-verdict)
            (return-from act1-dispatch (%act1-refusal-plist reason)))))
      (let ((terms (act1-dispatch-context-grant-terms context)))
        (handler-case
            (let ((authorization
                    ;; ⚠ PLANTED HOST FAULT (controls only; production NIL).
                    ;; A GENUINE implementation error — the lane misusing one of
                    ;; its own values, the way an ordinary bug does — raised
                    ;; INSIDE this protected form, BEFORE D1, and therefore
                    ;; before any attempt frame can land.  It is here and not in
                    ;; a test file because the defect it proves is a property of
                    ;; THIS handler-case; planting it anywhere else would prove
                    ;; nothing about the shipped path.
                    (progn
                      (when (eq :unexpected-error-before-frontier
                                (act1-dispatch-context-host-fault-plant context))
                        (%act1-planted-implementation-fault context))
                      ;; D1 — the runtime boundary.
                    (authorize-effect-attempt
                     store (act1-dispatch-context-bootstrap context)
                     (act1-dispatch-context-minting-context context)
                     (act1-dispatch-context-capability context)
                     :capability-id (act1-dispatch-context-capability-id context)
                     :query-name (format nil "q-~a-auth" attempt-name)
                     :subject (getf terms :subject) :action (getf terms :action)
                     :resource (getf terms :resource) :scope (getf terms :scope)
                     :cell (act1-dispatch-context-cell-segments context)
                     :value text
                     :attempt-name attempt-name :seat-name seat-name
                     :defect (act1-dispatch-context-runtime-defect context)))))
              ;; D2 — the frontier.  NOTHING BETWEEN D1 AND D2.
              (multiple-value-bind (status detail)
                  (attempt-protected-effect
                   store (act1-dispatch-context-bootstrap context)
                   (act1-dispatch-context-minting-context context)
                   (act1-dispatch-context-capability context)
                   authorization (act1-dispatch-context-world context)
                   :process-name (act1-dispatch-context-process-name context)
                   :interruption (act1-dispatch-context-interruption context))
                ;; ⚠ THE PLANTED LEAK SEAM (controls only; production NIL).
                ;; The guard said REFUSE and the effect was applied anyway; the
                ;; lane now returns the refusal it always meant to return.  The
                ;; world-scope instrument must catch this, or it is not an
                ;; instrument.
                (when (and (act1-dispatch-context-leak-write context)
                           (eq guard-verdict :refuse))
                  (set-act1-verdict verdict :reason guard-reason :guard :refused-and-leaked)
                  (return-from act1-dispatch (%act1-refusal-plist guard-reason)))
                (set-act1-verdict verdict :reason nil :guard guard-verdict)
                (act1-project-report context status detail)))
          ;; ================================================================
          ;; THE ADMITTED FAMILIES, ENUMERATED — repaired 2026-08-20 on Sol's
          ;; cold-parcel blocking finding.
          ;;
          ;; ⚠ THIS HANDLER USED TO CATCH `(error (c))` — the whole Common Lisp
          ;; error hierarchy — behind prose that said "every typed condition
          ;; from D1 or D2".  An unexpected implementation error raised before
          ;; any attempt frame lands leaves the derived standing :absent, so the
          ;; handler converted it into an ordinary pre-frontier refusal, and the
          ;; lane manufactured a refused Outcome AND a fresh Core /0 evidence
          ;; account for a TYPE-ERROR.  A HOST FAULT MAY NOT WEAR A CAPABILITY
          ;; REFUSAL'S CLOTHES.  (RED-PROOF-HOST-FAULT-BEFORE.txt.)
          ;;
          ;; What D1 and D2 can LAWFULLY signal, admitted BY FAMILY and by
          ;; nothing wider — each root read out of that lane's own package.lisp,
          ;; not remembered:
          ;;   · lisp-plus-capability2:cap2-condition   authorize/attempt's own
          ;;   · lisp-plus-capability1:cap1-condition   presentation, staleness
          ;;   · lisp-plus-capability0:cap0-condition   the /0 fold
          ;;   · lisp-plus-journal0:pj0-condition       the store beneath both
          ;;   · lisp-plus-kernel0:kernel0-condition    unsafe-retry, duplicate
          ;;                                            identity, unstructured
          ;;                                            uncertainty, §14.x
          ;;
          ;; DELIBERATELY NOT ADMITTED, and each absence is a decision:
          ;;   · lisp-plus-core0:core0-condition — nothing in this protected
          ;;     form calls back into Core /0; Core /0 is our CALLER.  One
          ;;     appearing here would mean the lane's own control flow is wrong.
          ;;   · act1-condition — the lane's own contract violations (including
          ;;     `act1-project-report`'s, which is called inside this form) are
          ;;     ALREADY host faults and must propagate unchanged rather than be
          ;;     reclassified into the refusal they are complaining about.
          ;;
          ;; D3 then reads the JOURNAL to decide pre- or post-frontier.  THE
          ;; CONSERVATIVE FRONTIER RULE: only :absent counts as pre-frontier,
          ;; because capability /2 places the frontier line ABOVE its
          ;; attempt:prepared append.
          ;; ================================================================
          (act1-condition (c) (error c))
          ((or lisp-plus-capability2:cap2-condition
               lisp-plus-capability1:cap1-condition
               lisp-plus-capability0:cap0-condition
               lisp-plus-journal0:pj0-condition
               lisp-plus-kernel0:kernel0-condition)
            (c)
            (let ((standing (derive-effect-standing store attempt-name)))
              (if (eq standing :absent)
                  (let ((reason (act1-class-b-reason (type-of c)
                                                     (act1-condition-requirement c))))
                    (set-act1-verdict verdict :reason reason :guard guard-verdict)
                    (%act1-refusal-plist reason))
                  ;; A POST-frontier condition: the bridge SIGNALS; it does not
                  ;; produce a plist, does not manufacture a core0-refused, and
                  ;; does not rewrite anything below the frontier line as a
                  ;; refusal.
                  (act1-refuse 'act1-bridge-contract-violated "ACT1-BRIDGE-1"
                               "post-frontier condition ~a [~a] at standing ~s: ~
this is a HOST FAULT, not an Outcome"
                               (type-of c) (act1-condition-requirement c)
                               standing))))
          ;; EVERYTHING ELSE IS A HOST FAULT, at any standing.  No plist, no
          ;; Outcome, no evidence, no reason keyword that could be mistaken for
          ;; a capability's answer — and the verdict slot is left UNWRITTEN, so
          ;; even the diagnostic sink cannot be read as a refusal.
          (error (c)
            (act1-refuse 'act1-bridge-contract-violated "ACT1-BRIDGE-2"
                         "unadmitted condition ~a at standing ~s: this is a ~
HOST FAULT of the lane's own implementation, not a capability refusal and not ~
an Outcome.  Admitted families are cap0/cap1/cap2/pj0/kernel0; everything else ~
arrives here by definition"
                         (type-of c)
                         (derive-effect-standing store attempt-name))))))))

(defun act1-project-report (context status detail)
  "D4 — the TOTAL projection.
`:committed` may be set T ONLY on the settled status.  Setting it T on the
uncertain status would carry an acknowledgment across the bridge as if it
settled — THE FORBIDDEN PROMOTION, LAUNDERED THROUGH AN ADAPTER.  The uncertain
branch reaches Core /0's uncertain path via (and committed local-lands) being
false, which is the honest route."
  (let ((store (act1-dispatch-context-store context))
        (attempt-name (act1-dispatch-context-attempt-name context)))
    (case status
      (:settled
       (let ((standing (derive-effect-standing store attempt-name)))
         (unless (eq standing :settled)
           (act1-refuse 'act1-bridge-contract-violated "ACT1-BRIDGE-1"
                        ":settled returned but the derived standing is ~s" standing))
         (list :crossed t :committed t :acknowledged t :local-record-lands t
               :ledger-token (act1-ledger-token-string context)
               :manifestation-status :declared-present
               :reason nil)))
      (:uncertain
       (list :crossed t :committed nil :acknowledged t :local-record-lands nil
             :ledger-token nil :manifestation-status :declared-none
             :reason :acknowledgment-without-evidence))
      (:interrupted
       (list :crossed t :committed nil :acknowledged nil
             :local-record-lands nil :ledger-token nil
             :manifestation-status :declared-none
             :reason (if (eq detail :request-lost) :request-lost detail)))
      (t (act1-refuse 'act1-bridge-contract-violated "ACT1-BRIDGE-1"
                      "status keyword ~s is outside {:settled :uncertain :interrupted}"
                      status)))))

(defun act1-ledger-token-string (context)
  (multiple-value-bind (found line line-sha)
      (world-ledger-lookup (act1-dispatch-context-world context)
                           (external-request-key
                            (act1-dispatch-context-attempt-name context)))
    (declare (ignore line))
    (and found line-sha)))

(defun act1-ledger-query (context)
  "LEDGER-QUERY — a witness of LIMITED JURISDICTION.
(:answered :committed TOKEN) | (:answered :not-committed) | (:withheld)."
  (multiple-value-bind (found line line-sha)
      (world-ledger-lookup (act1-dispatch-context-world context)
                           (external-request-key
                            (act1-dispatch-context-attempt-name context)))
    (declare (ignore line))
    (if found (list :answered :committed line-sha) (list :answered :not-committed))))

;;; ===========================================================================
;;; §8 — THE WORLD-SCOPE ABSENCE INSTRUMENT.
;;;
;;; The inherited finding this pays (work order §8(a)): One Act /0's denied arms
;;; asserted "no unauthorised transition" from the capability /2 journal
;;; standing alone — THE LOOK NEVER REACHED THE WORLD.  A derived `:frontier`
;;; field is not an independent witness and is never counted as one.
;;;
;;; SCOPE WARRANT.  The universe of the look is the WHOLE WORLD this lane can
;;; reach, and the instrument states it in its own printed output: capability
;;; /2's world fixture is EXACTLY TWO FILES (world.lisp:85-88), and the
;;; instrument LISTS THE DIRECTORY to show that no third file exists rather than
;;; assuming it.  Compared: the entire cell store's bytes (sha256 + octet
;;; count), the entire request ledger's bytes (sha256 + octet count), the total
;;; entry count, and the entry count under this arm's own request key.
;;;
;;; COMPETENCE WARRANT.  The instrument is shown able to see a violation before
;;; it is trusted to report absence: the leak-write control drives a REFUSED arm
;;; that writes the world anyway, and this instrument must catch it.  An
;;; instrument never seen to fire is untested, not passing.
;;; ===========================================================================

(defstruct (world-scope-snapshot (:constructor %make-world-scope-snapshot)
                                 (:copier nil))
  (cells-sha nil :read-only t) (ledger-sha nil :read-only t)
  (cells-octets nil :read-only t) (ledger-octets nil :read-only t)
  (ledger-count nil :read-only t) (key nil :read-only t)
  (key-count nil :read-only t) (files nil :read-only t))

(defun %file-octet-count (pathname)
  (with-open-file (stream pathname :direction :input
                                   :element-type '(unsigned-byte 8)
                                   :if-does-not-exist nil)
    (if stream (file-length stream) :could-not-look)))

(defun take-world-scope (world directory &key request-key)
  "DIRECTORY is the world's declared directory (capability /2 exports no
directory accessor; the caller declares it, as every caller of `make-world`
already must).  ⚠ :COULD-NOT-LOOK IS A DISTINCT VALUE from an absent byte: a
missing file yields :could-not-look, never 0, so a comparison can never read a
failed look as an unchanged world."
  (%make-world-scope-snapshot
   :cells-sha (world-cells-sha256 world)
   :ledger-sha (world-ledger-sha256 world)
   :cells-octets (%file-octet-count (merge-pathnames "CELLS.txt" directory))
   :ledger-octets (%file-octet-count (merge-pathnames "REQUEST-LEDGER.txt" directory))
   :ledger-count (world-ledger-count world)
   :key request-key
   :key-count (and request-key (world-ledger-count world request-key))
   :files (sort (mapcar (lambda (p) (file-namestring p))
                        (directory (merge-pathnames "*.*" directory)))
                #'string<)))

(defun world-scope-unchanged-p (before after)
  "TRUE only when every compared quantity is EQUAL and no look failed.  A
:could-not-look on either side makes this NIL — absent and could-not-look are
different answers and this instrument never conflates them."
  (and (not (member :could-not-look
                    (list (world-scope-snapshot-cells-octets before)
                          (world-scope-snapshot-ledger-octets before)
                          (world-scope-snapshot-cells-octets after)
                          (world-scope-snapshot-ledger-octets after))))
       (equal (world-scope-snapshot-cells-sha before)
              (world-scope-snapshot-cells-sha after))
       (equal (world-scope-snapshot-ledger-sha before)
              (world-scope-snapshot-ledger-sha after))
       (eql (world-scope-snapshot-cells-octets before)
            (world-scope-snapshot-cells-octets after))
       (eql (world-scope-snapshot-ledger-octets before)
            (world-scope-snapshot-ledger-octets after))
       (eql (world-scope-snapshot-ledger-count before)
            (world-scope-snapshot-ledger-count after))
       (equal (world-scope-snapshot-files before)
              (world-scope-snapshot-files after))
       t))

(defun print-world-scope-universe (label before after)
  "The universe of the look, printed in the tooth's OWN output — never left to
a reader to reconstruct from prose elsewhere."
  (act1-note "WORLD-SCOPE ~a — universe of the look: the ENTIRE world fixture, ~
which is the file set {~{~a~^, ~}} in the declared world directory (listed by ~
this instrument, not assumed)"
             label (world-scope-snapshot-files after))
  (act1-note "  cell store  : ~a octets sha ~a  ->  ~a octets sha ~a"
             (world-scope-snapshot-cells-octets before)
             (subseq (world-scope-snapshot-cells-sha before) 0 16)
             (world-scope-snapshot-cells-octets after)
             (subseq (world-scope-snapshot-cells-sha after) 0 16))
  (act1-note "  request ledger: ~a octets sha ~a (~a entr~:@p)  ->  ~a octets sha ~a (~a entr~:@p)"
             (world-scope-snapshot-ledger-octets before)
             (subseq (world-scope-snapshot-ledger-sha before) 0 16)
             (world-scope-snapshot-ledger-count before)
             (world-scope-snapshot-ledger-octets after)
             (subseq (world-scope-snapshot-ledger-sha after) 0 16)
             (world-scope-snapshot-ledger-count after))
  (when (world-scope-snapshot-key after)
    (act1-note "  entries under this arm's request key ~a: ~a  ->  ~a"
               (world-scope-snapshot-key after)
               (world-scope-snapshot-key-count before)
               (world-scope-snapshot-key-count after))))

;;; ===========================================================================
;;; §9 — the in-process run harness.
;;; ===========================================================================

(defvar *act1-run-root* nil)
(defvar *act1-store* nil)
(defvar *act1-worlds* nil)              ; plist :apply WORLD :ambiguous WORLD
(defvar *act1-world-directories* nil)   ; plist :apply DIR   :ambiguous DIR
(defvar *act1-bootstrap* nil)
(defvar *act1-minting-context* nil)

(defun act1-env-preflight (&key (signal t))
  "Runs BEFORE the store is created and BEFORE the first act.  Prints one
stable check-line per variable.  ANY ONE SET VOIDS THE RUN: the run stops,
reports the variable and its value, and CREATES NO JOURNAL STORE.  ⚠ A VOID IS
NOT A FAILURE OF THE SUITE and is never reported as a pass."
  (let ((set-vars '()))
    (dolist (name (append +act1-env-class-i+ +act1-env-class-ii+))
      (let ((value (sb-ext:posix-getenv name)))
        (if value
            (progn (push (cons name value) set-vars)
                   (format t "~&  W-ENV ~a SET=~s~%" name value))
            (format t "~&  W-ENV ~a unset~%" name))))
    (format t "~&  W-ENV enumerated ~d variables (~d Class I + ~d Class II); ~
~d Class III declared out of stack, named and NOT asserted~%"
            (+ (length +act1-env-class-i+) (length +act1-env-class-ii+))
            (length +act1-env-class-i+) (length +act1-env-class-ii+)
            (length +act1-env-class-iii-declared-out-of-stack+))
    (when set-vars
      (format t "~&  W-ENV VOID: ~d variable(s) set; NO JOURNAL STORE IS CREATED~%"
              (length set-vars))
      (when signal
        (act1-refuse 'act1-run-void "ACT1-ENV-1"
                     "environment variable ~a is set to ~s; this suite declares ~
one process life and that switch can end the process"
                     (car (first set-vars)) (cdr (first set-vars)))))
    (null set-vars)))

(defun build-act1-store (root)
  "The nonce is EXACTLY sixteen octets, asserted BY LENGTH, not by counting the
source line."
  (assert (= 16 (length +act1-store-nonce+)) ()
          "the store nonce must be exactly sixteen octets, not ~d"
          (length +act1-store-nonce+))
  (create-journal (merge-pathnames "store/" root)
                  :nonce-octets +act1-store-nonce+))

(defun build-act1-worlds (root)
  "The two worlds are constructed in DECLARED FIXED relative directories under
the run root.  No PID, no clock, no (random), no temp-dir name inside any
compared byte."
  (let ((apply-directory (merge-pathnames "world-apply/" root))
        (ambiguous-directory (merge-pathnames "world-ambiguous/" root)))
    (setf *act1-world-directories*
          (list :apply apply-directory :ambiguous ambiguous-directory))
    (list :apply (make-world apply-directory +act1-apply-cells+ :script :apply)
          :ambiguous (make-world ambiguous-directory +act1-ambiguous-cells+
                                 :script :ambiguous))))

(defun act1-opening-authority (store table &key (issuer (idf +act1-issuer+)))
  "The Capability /0 grants, appended in setup, BEFORE the first act.
⚠ THE MINT IS NOT IN SETUP: each act mints its own Office R capability at the
prefix its own D1 will present against.  One grant per DISTINCT seat: this lane
has seats carrying more than one act, and a second grant under the same
capability id would be a second authority where the lane declares one."
  (let ((granted '()))
    (dolist (f table)
      (let* ((seat (act1-fixture-runtime-seat f))
             (terms (act1-grant-terms-for f)))
        (unless (member seat granted :test #'string=)
          (push seat granted)
          (append-event store
                        (make-grant-event
                         :event-id (list "cap0-event" (format nil "g-~a" seat))
                         :capability-id (act1-capability-id-for f)
                         :subject (getf terms :subject) :action (getf terms :action)
                         :resource (getf terms :resource) :scope (getf terms :scope)
                         :issuer issuer)))))
    (reverse granted)))

;;; ===========================================================================
;;; §10 — run-act1: ONE act, end to end.
;;; ===========================================================================

(defstruct (act1-result (:constructor %make-act1-result) (:copier nil))
  (record nil :read-only t) (class nil :read-only t)
  (standing nil :read-only t) (disposition nil :read-only t)
  (outcome nil :read-only t) (evidence nil :read-only t)
  (reason nil :read-only t) (guard nil :read-only t)
  (refusal-type nil :read-only t) (refusal-requirement nil :read-only t)
  (context nil :read-only t) (bridge nil :read-only t))

(defun act1-derive-class (store attempt-name disposition &key frames-before)
  "The classification is computed BY READING THE JOURNAL, never by reading a
condition's type name.  THE CONSERVATIVE FRONTIER RULE: only :absent counts as
pre-frontier, because capability /2 places the frontier line ABOVE its
attempt:prepared append.

⚑ THE /1 ROW, AND WHY IT IS NOT A HOLE IN THAT RULE.  Across a death, the
standing derived under an attempt name can describe the DEAD attempt rather
than this one: a resurgent image that re-attempts the same act reads
:crossed-unsettled under its own attempt name before it has done anything at
all.  One Act /0 could never see this — it had one process life — and reading
it as a post-frontier host fault would be false.

The distinction is CHECKED, not argued: this row fires only when the journal's
FRAME COUNT IS UNCHANGED across the whole act, which is exactly the claim that
this act appended nothing.  If a frame moved, the row does not fire and the
result is :unclassifiable — a host fault, as before."
  (let ((standing (derive-effect-standing store attempt-name))
        (frames-now (nth-value 1 (act1-journal-kinds store))))
    (values
     (cond ((and (eq standing :settled) (eq disposition :returned)) :settled)
           ((and (eq standing :absent) (eq disposition :refused)) :refused)
           ((and (eq standing :crossed-unsettled) (eq disposition :refused)
                 frames-before (eql frames-before frames-now))
            :refused-across-death)
           ((and (eq standing :uncertain-unresolved) (eq disposition :interrupted))
            :uncertain)
           ((and (eq standing :crossed-unsettled) (eq disposition :interrupted))
            :crossed-unsettled)
           ((and (eq standing :crossed-unsettled) (eq disposition :host-fault)) :host-fault)
           ;; ⚑ THE PRE-FRONTIER HOST FAULT (added 2026-08-20 with the
           ;; unadmitted-condition repair).  An implementation fault raised
           ;; before D1 leaves the standing :absent — the SAME standing a lawful
           ;; refusal leaves — so the class table must separate them by
           ;; DISPOSITION, which is exactly what it does: a host fault never
           ;; arrives here as :refused, because the narrowed handler no longer
           ;; converts one into the other.  Gated on frame invariance like its
           ;; sibling row, so "this fault appended nothing" is checked.
           ((and (eq standing :absent) (eq disposition :host-fault)
                 frames-before (eql frames-before frames-now))
            :host-fault-pre-frontier)
           (t :unclassifiable))
     standing)))

(defun run-act1 (fixture &key (store *act1-store*) world
                              (bootstrap *act1-bootstrap*)
                              (minting-context *act1-minting-context*)
                              (process-name +act1-runtime-process-name+)
                              (register t) (verbose t))
  "ONE act, from the fixture row to the Outcome.  ⚠ IT NEVER ADJUSTS AN INPUT
TO MAKE AN OUTPUT COME OUT: every refusal propagates as its own typed
condition, and the lane records what happened rather than what was wanted."
  (let* ((seat (act1-fixture-runtime-seat fixture))
         (attempt (act1-fixture-attempt-name fixture))
         (record (make-act1-record fixture :register register))
         (terms (act1-grant-terms-for fixture))
         (process (lisp-plus-core0:process-context
                   :label (act1-fixture-language-label fixture)))
         (world (or world (getf *act1-worlds* (act1-fixture-world-key fixture))))
         (nf (act1-record-normal-form record))
         (office-l (act1-office-l-capability fixture nf))
         (cell-string (second (assoc :cell (act1-request-roles nf)))))
    (when verbose
      (format t "~&~%---- ARM ~a (fixture label ~s — LEGIBILITY ONLY) ----~%"
              (act1-fixture-arm fixture) (act1-fixture-label fixture))
      (act1-note "act-id ~a" (identifier-segment-string (act1-record-act-id record)))
      (act1-note "seat ~a · attempt ~a · cell ~a"
                 seat attempt (identifier-segment-string (getf terms :resource))))
    (act1-bind-checks fixture nf office-l cell-string)
    ;; ---- Office R is minted HERE, at the prefix this act's D1 will present
    ;; ---- against, and never in setup.
    (let ((office-r
            (mint-from-authorization
             store bootstrap minting-context
             (query-live-authority store bootstrap
                                   :query-id (list "cap0-query"
                                                   (format nil "q-~a-mint" attempt))
                                   :capability-id (act1-capability-id-for fixture)
                                   :subject (getf terms :subject)
                                   :action (getf terms :action)
                                   :resource (getf terms :resource)
                                   :scope (getf terms :scope))
             :minter (list "oneact1-minter" process-name))))
      ;; The declared D1-refusal arm: a Capability /0 REVOCATION is committed
      ;; AFTER the mint and BEFORE the act.  A real shape — the grant is
      ;; withdrawn while the act is in flight — and the one shape that makes
      ;; capability /2's OWN authorization refuse at the runtime boundary.
      (when (act1-fixture-revoke-after-mint fixture)
        (append-event store
                      (make-revocation-event
                       :event-id (list "cap0-event" (format nil "r-~a" attempt))
                       :capability-id (act1-capability-id-for fixture)
                       :issuer (idf +act1-issuer+)))
        (when verbose
          (act1-note "declared arm property: the /0 grant was REVOKED after the ~
mint and before the act")))
      (let* ((context (%make-act1-dispatch-context
                       :act-id (act1-record-act-id record)
                       :normal-form nf :process process :seat-name seat
                       :attempt-name attempt
                       :cell-segments (act1-fixture-cell-segments fixture)
                       :capability office-r :store store :world world
                       :bootstrap bootstrap :minting-context minting-context
                       :grant-terms terms
                       :capability-id (act1-capability-id-for fixture)
                       :process-name process-name
                       :durable-guard (act1-fixture-durable-guard fixture)
                       :interruption (act1-fixture-interruption fixture)
                       :runtime-defect (act1-fixture-runtime-defect fixture)
                       :project-defect (act1-fixture-project-defect fixture)
                       :host-fault-plant (act1-fixture-host-fault-plant fixture)
                       :leak-write (act1-fixture-leak-write fixture)))
             (verdict (%make-act1-verdict))
             (bridge (make-act1-bridge (act1-fixture-adapter-symbol fixture)
                                       context verdict)))
        (lisp-plus-core0:register-adapter bridge)
        ;; PRE-1 and PRE-2, asserted AND PRINTED, BEFORE perform.
        (let ((resolved (lisp-plus-core0:resolve-adapter
                         (act1-fixture-adapter-symbol fixture))))
          (unless (eq resolved bridge)
            (act1-refuse 'act1-dispatcher-binding-refused "ACT1-PRE-1"
                         "resolve-adapter returned ~s, not this act's bridge ~s"
                         resolved bridge))
          (when verbose (act1-note "PRE-1 (eq resolved bridge) => T"))
          (unless (and (eq (lisp-plus-core0:core0-adapter-name resolved)
                           (act1-fixture-adapter-symbol fixture))
                       (eql (lisp-plus-core0:core0-adapter-version resolved) 0))
            (act1-refuse 'act1-dispatcher-binding-refused "ACT1-PRE-2"
                         "the resolved object's name/version do not equal the ~
fields Office L bound"))
          (when verbose (act1-note "PRE-2 name/version => equal")))
        ;; ---- THE ORIGINATING FORM IS EVALUATED, ONCE.  The frame count is
        ;; ---- taken from the VALIDATED PREFIX immediately before it, so the
        ;; ---- classification below can CHECK "this act appended nothing"
        ;; ---- instead of assuming it.
        (let ((frames-before (nth-value 1 (act1-journal-kinds store))))
        (multiple-value-bind (outcome evidence disposition refusal-type)
            (handler-case
                (multiple-value-bind (o e)
                    (lisp-plus-core0:perform
                     :adapter (act1-fixture-adapter-symbol fixture)
                     :request nf :authority office-l :process process)
                  (values o e :returned nil))
              (lisp-plus-core0:core0-interrupted (c)
                (values (lisp-plus-core0:core0-condition-outcome c)
                        (lisp-plus-core0:core0-condition-evidence c)
                        :interrupted (type-of c)))
              (lisp-plus-core0:core0-refused (c)
                (values (lisp-plus-core0:core0-condition-outcome c)
                        (lisp-plus-core0:core0-condition-evidence c)
                        :refused (type-of c)))
              (act1-bridge-contract-violated (c)
                (declare (ignore c))
                ;; NO Outcome, NO evidence.  The lane MUST NOT manufacture either.
                (values nil nil :host-fault 'act1-bridge-contract-violated)))
          (multiple-value-bind (class standing)
              (act1-derive-class store attempt disposition
                                 :frames-before frames-before)
            (when (eq class :unclassifiable)
              (act1-refuse 'act1-bridge-contract-violated "ACT1-BRIDGE-1"
                           "standing ~s with disposition ~s is not a lawful class"
                           standing disposition))
            (when verbose
              (act1-note "class ~a · standing ~s · disposition ~s · reason ~s"
                         class standing disposition (act1-verdict-reason verdict)))
            (%make-act1-result
             :record record :class class :standing standing
             :disposition disposition :outcome outcome :evidence evidence
             :reason (act1-verdict-reason verdict)
             :guard (act1-verdict-guard verdict)
             :refusal-type refusal-type
             :refusal-requirement nil
             :context context :bridge bridge))))))))

;;; ===========================================================================
;;; §10b — THE LANE'S READING OF A RUNTIME RECONCILIATION.
;;;
;;; The runtime resolves; the LANGUAGE decides whether that resolution frees the
;;; seat for a fresh act.  It may not decide that from the resolution KEYWORD
;;; alone: `:not-applied` is a perfectly successful reconciliation — it resolves
;;; the uncertainty in the OTHER direction — and a lane that read "reconciled,
;;; therefore proceed" would proceed on an effect that never happened, with no
;;; evidence that it did.
;;;
;;; So the door requires three durable facts together: the resolution is
;;; :applied · the SURVIVING WORLD holds the entry under the journaled
;;; external-request identity · the journal now carries attempt:reconciled.
;;; ===========================================================================

(defun act1-reconciliation-closes-seat-p (store world attempt-name resolution
                                          &key defect)
  "DEFECT :ACCEPT-ANY-RESOLUTION is the planted mutant
(:reconciliation-without-evidence), kept alive to be killed: it closes the seat
on any resolution keyword, consulting neither the world nor the journal."
  (when (eq defect :accept-any-resolution)
    (return-from act1-reconciliation-closes-seat-p (and resolution t)))
  (and (eq :applied resolution)
       (multiple-value-bind (found line line-sha)
           (world-ledger-lookup world (external-request-key attempt-name))
         (declare (ignore line))
         (and found line-sha t))
       (eq :reconciled (derive-effect-standing store attempt-name))
       (member "attempt:reconciled" (act1-journal-kinds store) :test #'equal)
       t))

;;; ===========================================================================
;;; §11 — readback: the frames this act left in the VALIDATED PREFIX.
;;;
;;; ⚠ A RECORDING THAT IS NEVER READ BACK IS NOT A BINDING; IT IS A HOPE WITH A
;;; FIELD NAME.  "The append did not error" is not evidence the frame was
;;; written — these readers go through `validate-journal`, which re-reads the
;;; bytes from disk and stops at the first frame that does not verify.
;;; ===========================================================================

(defun %act1-event-kind (event)
  (let ((kind (record-field event "event" "kind")))
    (and kind (lisp-plus-cd0:identifier-datum-p kind)
         (identifier-segment-string kind))))

(defun act1-journal-kinds (store)
  "The kind strings of the validated prefix's frames, in order, read back from
the store's bytes.  Returns (values KINDS FRAME-COUNT STATUS TAIL-SHA)."
  (let* ((report (validate-journal store))
         (events (prefix-report-events report)))
    (values (loop for index below (fill-pointer events)
                  collect (%act1-event-kind (aref events index)))
            (prefix-report-frame-count report)
            (prefix-report-status report)
            (prefix-report-tail-sha256 report))))
