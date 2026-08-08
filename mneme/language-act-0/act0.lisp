;;;; act0.lisp — One Act /0: the lane.
;;;;
;;;; The numbered trace of contract §4 (L0..L22), the act identity of §2A, the
;;;; journal projection of §3.2, the agreement gate of §6.3, and the refusal law
;;;; of §2.6a.  Nothing speculative, no convenience layer, no new surface form or
;;;; macro head: the act's form is the existing `perform` door (contract S-1..S-4).
;;;;
;;;; CANDIDATE.  Nothing here is adopted, and nothing here is independent
;;;; verification (contract §0.3, AP0 adoption Rider 2).
;;;;
;;;; — FABER-I (Claude Opus 5, subagent), 2026-08-07

(in-package #:lisp-plus-language-act0)

;;; ===========================================================================
;;; §0 — transcript primitives.  Every assertion PRINTS.  An assertion whose
;;; result is not exhibited is not an assertion (contract M-3c).
;;; ===========================================================================

(defvar *checks-passed* 0)
(defvar *checks-failed* 0)
(defvar *check-log* '())

(defun note (fmt &rest args)
  (format t "~&    ~a~%" (apply #'format nil fmt args))
  (force-output))

(defun check (name ok &optional (fmt "") &rest args)
  "Print one stable check-line and record its verdict.  NEVER adjusts an input
to make an output come out."
  (if ok (incf *checks-passed*) (incf *checks-failed*))
  (push (list name (and ok t)) *check-log*)
  (format t "~&  [~a] ~a~@[  ~a~]~%"
          (if ok "PASS" "FAIL") name
          (let ((s (apply #'format nil fmt args))) (if (string= s "") nil s)))
  (force-output)
  (and ok t))

(defun check-eq (name actual expected &optional (test #'equal))
  (check name (funcall test actual expected)
         "actual=~s expected=~s" actual expected))

;;; ===========================================================================
;;; §1 — the lane's typed conditions.
;;;
;;; Every refusal of this lane is TYPED and carries a requirement-id.  Refusals
;;; are named by CONDITION TYPE + REQUIREMENT-ID, never by message text: SBCL's
;;; condition report text is not a stable interface and Journal /0 renders host
;;; condition text into :detail with princ-to-string (contract V-7).
;;; ===========================================================================

(define-condition act0-condition (error)
  ((detail :initarg :detail :initform "" :reader act0-condition-detail)
   (requirement-id :initarg :requirement-id :initform nil
                   :reader act0-condition-requirement-id))
  (:report (lambda (c s)
             (format s "~a [~a]: ~a" (type-of c)
                     (or (act0-condition-requirement-id c) "-")
                     (act0-condition-detail c)))))

(macrolet ((families (base &rest names)
             `(progn ,@(loop for n in names
                             collect `(define-condition ,n (,base) ())))))
  (families act0-condition
            act-fixture-table-invalid       ; ACT-9, ACT-9a-1, H-CELL-1
            act-request-lexis-refused       ; M-13a-4
            act-request-shape-refused       ; M-13, ACT-SHAPE-1
            act-identity-taken              ; ACT-8 / ACT-9b / ACT-L5
            act-identity-branch             ; ACT-12 BRANCH / J-4c
            act-authority-binding-refused   ; A-5
            act-dispatcher-binding-refused  ; M-3c PRE-1 / PRE-2
            act-binding-consumed            ; K-7a-1 Shape 2
            act-frame-ordering-violated     ; J-4d / ACT-ORDER-1
            act-office-r-term-divergence    ; J-4b
            act-process-identity-divergence ; BIND-6
            act-bridge-contract-violated    ; M-9 (Class D)
            act-readback-disagreement))     ; O-8

(define-condition act-run-void (act0-condition) ()
  (:documentation "W-ENV: a run VOID is not a failure of the specimen and is
never reported as a pass (contract WE-04)."))

(defun act-refuse (type requirement-id fmt &rest args)
  (error type :requirement-id requirement-id
              :detail (apply #'format nil fmt args)))

;;; ===========================================================================
;;; §2 — CD/0 helpers.  Public constructors only; the lane reaches into no
;;; predecessor's internals.
;;; ===========================================================================

(defun idf (segments) (identifier-from-segments segments))
(defun s-datum (string) (lisp-plus-cd0:make-string-datum string))
(defun i-datum (integer) (lisp-plus-cd0:make-integer-datum integer))
(defun b-datum (octets) (lisp-plus-cd0:make-bytes-datum octets))
(defun entry (segments value)
  (lisp-plus-cd0:make-record-entry (idf segments) value))
(defun rec (&rest entries)
  (lisp-plus-cd0:make-record-datum (remove nil entries)))
(defun seq (elements) (lisp-plus-cd0:make-sequence-datum elements))
(defun oct (datum) (lisp-plus-cd0:canonical-octets datum))
(defun oct-len (o) (lisp-plus-cd0:octets-length o))
(defun oct-copy (o) (lisp-plus-cd0:octets-copy o))
(defun oct-hex (o) (lisp-plus-cd0:octets-to-hex o))
(defun digest-of (datum) (sha256-hex (oct-copy (oct datum))))

;;; ===========================================================================
;;; §3 — the immutable act-fixture table (contract §2A ACT-9).
;;;
;;; ⚑ THERE IS NO `act-id` COLUMN, AND ITS ABSENCE IS THE REPAIR.  The act
;;; identity is DERIVED at L1c from this row's runtime seat and that act's
;;; canonical request, so it cannot be a column of a table validated at L0 —
;;; the canonical request does not exist at L0.
;;;
;;; `fixture-label` is a DEMOTED act-token: LEGIBILITY ONLY, with no semantic,
;;; identity, or uniqueness role (owner ruling R0.1 §1, contract §2A.0).  It is
;;; read for exactly one purpose — printing a legible transcript line.
;;; ===========================================================================

(defstruct (act-fixture (:constructor %make-act-fixture) (:copier nil))
  (arm             nil :read-only t)   ; "A" … — the transcript's arm label
  (label           nil :read-only t)   ; fixture-label: LEGIBILITY ONLY
  (language-label  nil :read-only t)   ; Core /0 process-context :label
  (runtime-seat    nil :read-only t)   ; ⚑ DERIVATION INPUT (ii)
  (attempt-name    nil :read-only t)   ; "a-<seat-id>" — FORCED by T4-LAW
  (cell-segments   nil :read-only t)   ; the world cell identity's segments
  (adapter-symbol  nil :read-only t)   ; a lane-owned symbol
  (world-key       nil :read-only t)   ; :apply | :ambiguous
  (form            nil :read-only t)   ; the originating host request form
  (authority-mode  nil :read-only t)   ; :bound | :wrong-predicate | :ambient
  (interruption    nil :read-only t)   ; NIL | :request-lost
  ;; ⚑ R2.1 ERRATUM.  The arm's DECLARED shape.  :act = the act is expected to
  ;; reach perform; :unpaired-f1 = the arm DECLARES that its Office R mint
  ;; refuses by name, so F1 stands alone and that is the result (specimen
  ;; BR-11).  ⚠ The declaration is what separates an EXPECTED unpaired F1 from
  ;; a fault: on any arm NOT declaring it, an unpaired F1 STOPS THE ROUND
  ;; exactly as contract J-2c says.
  (declared-shape  :act :read-only t))

(defstruct (act-record (:constructor %make-act-record) (:copier nil))
  "The ONE IMMUTABLE ACT RECORD (contract ACT-L6): the fixture row plus the
identity minted at L1c.  Read-only from that instant.  Every frame constructor
reads the identity from HERE and no constructor accepts an act-id argument from
a call site (ACT-13)."
  (fixture      nil :read-only t)
  (act-id       nil :read-only t)   ; the CD/0 identifier datum — THE identity
  (act-id-hex   nil :read-only t)   ; the 64-char digest segment, for transcripts
  (normal-form  nil :read-only t)   ; the L1b canonical request
  (request-rec  nil :read-only t)   ; the V-REQ-2 record
  (request-oct  nil :read-only t))  ; its canonical octets (derivation input iii)

(defun request-form (cell text)
  `(:predicate :inscribe (:cell ,cell) (:text ,text)))

(defparameter *act-fixture-table*
  (list
   (%make-act-fixture
    :arm "A" :label "prima" :language-label "prima" :runtime-seat "prima"
    :attempt-name "a-prima" :cell-segments '("cella" "prima")
    :adapter-symbol 'one-act-0-bridge/prima :world-key :apply
    :form (request-form "cella:prima" "Unus actus, una ratio.")
    :authority-mode :bound :interruption nil)
   (%make-act-fixture
    :arm "C-i" :label "ambigua" :language-label "ambigua" :runtime-seat "ambigua"
    :attempt-name "a-ambigua" :cell-segments '("cella" "ambigua")
    :adapter-symbol 'one-act-0-bridge/ambigua :world-key :ambiguous
    :form (request-form "cella:ambigua" "Nuntius sine teste.")
    :authority-mode :bound :interruption nil)
   (%make-act-fixture
    :arm "C-ii" :label "amissa" :language-label "amissa" :runtime-seat "amissa"
    :attempt-name "a-amissa" :cell-segments '("cella" "amissa")
    :adapter-symbol 'one-act-0-bridge/amissa :world-key :apply
    :form (request-form "cella:amissa" "Epistula quae numquam venit.")
    :authority-mode :bound :interruption :request-lost)
   (%make-act-fixture
    :arm "B-R" :label "revocata" :language-label "revocata" :runtime-seat "revocata"
    :attempt-name "a-revocata" :cell-segments '("cella" "revocata")
    :adapter-symbol 'one-act-0-bridge/revocata :world-key :apply
    :form (request-form "cella:revocata" "Manus mortua.")
    :authority-mode :bound :interruption nil
    ;; ⚑ THE UNPAIRED-F1 ARM (R2.1 erratum, chair ruling 1).  Its Capability /0
    ;; grant is revoked in setup, so query-live-authority returns a REFUSAL
    ;; receipt and mint-from-authorization refuses CAP1-MINT-2 — "a refusal
    ;; cannot authorize minting" (capability1/mint.lisp:158-166).  D1 is never
    ;; reached and perform is never called.  ⚠ THE FIXTURE IS UNTOUCHED, which
    ;; is why ZERO frozen vectors move.
    :declared-shape :unpaired-f1)
   (%make-act-fixture
    :arm "D" :label "fracta" :language-label "fracta" :runtime-seat "fracta"
    :attempt-name "a-fracta" :cell-segments '("cella" "fracta")
    :adapter-symbol 'one-act-0-bridge/fracta :world-key :apply
    :form (request-form "cella:fracta" "Cella quae non est.")
    :authority-mode :bound :interruption nil)
   (%make-act-fixture
    :arm "B-L1" :label "vetita-scope" :language-label "vetita-scope"
    :runtime-seat "vetita-scope" :attempt-name "a-vetita-scope"
    :cell-segments '("cella" "vetita-scope")
    :adapter-symbol 'one-act-0-bridge/vetita-scope :world-key :apply
    :form (request-form "cella:vetita-scope" "Manus quae non licet.")
    :authority-mode :wrong-predicate :interruption nil)
   (%make-act-fixture
    :arm "B-L2" :label "vetita-ambient" :language-label "vetita-ambient"
    :runtime-seat "vetita-ambient" :attempt-name "a-vetita-ambient"
    :cell-segments '("cella" "vetita-ambient")
    :adapter-symbol 'one-act-0-bridge/vetita-ambient :world-key :apply
    :form (request-form "cella:vetita-ambient" "Nemo iubet.")
    :authority-mode :ambient :interruption nil))
  "Seven rows.  ⚑ Every column a distinct typed identity; the ROW is the
relation, and no column is computed from another (contract L-3) — except where
ACT-3 says so, and that one is not a column.")

;;; --- ACT-4: the lane's RENDERING alphabet, for FIXED LANE-OWNED TEXTUAL
;;; --- SEGMENTS ONLY.  It NEVER governs a request role value: :cell and :text
;;; --- are M-13a-1 / M-13a-2, whose alphabets are the OWNER's (R0.1 §3) and are
;;; --- WIDER than this one.
(defun act4-segment-char-p (ch)
  (or (char<= #\a ch #\z) (char<= #\0 ch #\9) (char= ch #\-)))

(defun act4-lawful-p (string)
  (and (stringp string) (plusp (length string)) (<= (length string) 64)
       (every #'act4-segment-char-p string)))

(defun hex64-p (string)
  "⚑ The digest segment is EXACTLY 64 lowercase hexadecimal characters —
asserted by LENGTH and by CHARACTER CLASS, never by eyeball (ACT-4)."
  (and (stringp string) (= 64 (length string))
       (every (lambda (c) (find c "0123456789abcdef")) string)))

;;; ===========================================================================
;;; L0 — the act-fixture table is declared and validated (contract §4 L0).
;;;
;;; ⚠ THE ACT IDENTITY DOES NOT EXIST AS OF THIS STEP, and L0 no longer checks
;;; act-token distinctness or act-id distinctness.  What carries the
;;; anti-collapse weight here is the SEAT distinctness check (ACT-9b).
;;; ===========================================================================

(defun validate-act-fixture-table (&key (table *act-fixture-table*)
                                        (process-name +runtime-process-name+))
  (dolist (f table)
    ;; FX-01 — legibility only, NOT an identity check.
    (unless (act4-lawful-p (act-fixture-label f))
      (act-refuse 'act-fixture-table-invalid "ACT-9"
                  "fixture label ~s is not lawful under ACT-4's rendering alphabet"
                  (act-fixture-label f)))
    (unless (act4-lawful-p (act-fixture-runtime-seat f))
      (act-refuse 'act-fixture-table-invalid "N-6a"
                  "runtime seat-id ~s is not lawful under ACT-4's rendering alphabet"
                  (act-fixture-runtime-seat f)))
    ;; T4-LAW: the cap2 attempt-name MUST be exactly "a-<seat-id>", because
    ;; derive-seat-outcome computes it that way (surface2.lisp:1124) and
    ;; Surface /2 is CLOSED at Erratum 0.2 — permanently.
    (unless (string= (act-fixture-attempt-name f)
                     (format nil "a-~a" (act-fixture-runtime-seat f)))
      (act-refuse 'act-fixture-table-invalid "T4-LAW"
                  "attempt-name ~s is not \"a-~a\""
                  (act-fixture-attempt-name f) (act-fixture-runtime-seat f)))
    ;; H-CELL-2: every declared cell segment obeys ACT-4, so
    ;; identifier-segment-string is injective over the fixture table.
    (dolist (seg (act-fixture-cell-segments f))
      (unless (act4-lawful-p seg)
        (act-refuse 'act-fixture-table-invalid "H-CELL-2"
                    "cell segment ~s is not lawful under ACT-4" seg))))
  ;; BIND-6(ii) — uniqueness runs over the WHOLE table BEFORE the first act,
  ;; not per act.  ⚑ Under the derived basis the RUNTIME seat check is
  ;; load-bearing in a way it was not: the runtime seat is derivation input
  ;; (ii), so seat distinctness is what makes the act identities distinct at
  ;; all (ACT-9b, ACT-12 COLLAPSE).
  (flet ((distinct (key what requirement)
           (let ((seen '()))
             (dolist (f table)
               (let ((v (funcall key f)))
                 (when (member v seen :test #'equal)
                   (act-refuse 'act-fixture-table-invalid requirement
                               "two fixture rows share ~a ~s" what v))
                 (push v seen))))))
    (distinct #'act-fixture-language-label "language seat" "BIND-6-II")
    (distinct #'act-fixture-runtime-seat   "runtime seat"  "BIND-6-II")
    (distinct #'act-fixture-adapter-symbol "bridge adapter symbol" "M-3")
    ;; H-CELL-1 — by datum= over the declared cell identifiers, not by string.
    (let ((cells '()))
      (dolist (f table)
        (let ((id (idf (act-fixture-cell-segments f))))
          (when (find id cells :test #'datum=)
            (act-refuse 'act-fixture-table-invalid "H-CELL-1"
                        "two fixture rows share world cell ~s"
                        (identifier-segment-string id)))
          (push id cells)))))
  ;; ACT-9a — ONE runtime process name for the whole run, validated with the
  ;; table.  ⚑ FX-10: lawful under ACT-4; DISTINCT from every language process
  ;; label and from every seat name of either family; NOT derived from any of
  ;; them, nor from the host PID, the directory, or the clock.
  (unless (act4-lawful-p process-name)
    (act-refuse 'act-fixture-table-invalid "ACT-9a-2"
                "runtime process name ~s is not lawful under ACT-4" process-name))
  (dolist (f table)
    (when (or (string= process-name (act-fixture-language-label f))
              (string= process-name (act-fixture-runtime-seat f)))
      (act-refuse 'act-fixture-table-invalid "ACT-9a-4"
                  "runtime process name ~s collides with a fixture seat/label"
                  process-name)))
  t)

;;; ===========================================================================
;;; L1b — canonicalization and the M-13a lexis check (contract §4 L1b, §3.4a).
;;; ===========================================================================
;;;
;;; The owner's grammars (ruling R0.1 §3), adopted exactly.  ⚠ NO MAXIMUM
;;; LENGTH — length is not a lexis law of this lane; an oversize input is
;;; refused, if at all, by CD/0 BUDGET law, which is a categorically different
;;; refusal.  No lane checker may impose a length bound of its own, and an
;;; implementation that re-narrows or re-widens either alphabet is in breach
;;; (M-13a-3a).

(defun printable-ascii-no-space-p (ch)
  (<= #x21 (char-code ch) #x7E))

(defun printable-ascii-or-space-p (ch)
  (<= #x20 (char-code ch) #x7E))

(defun %lexis-refuse (role string index)
  "⚠ THE OFFENDING CHARACTER IS NEVER ECHOED LITERALLY — echoing it would put
the injection into the compared bytes (M-46g's discipline applied to lane data).
The refusal names the role, the code point IN HEX, and the ZERO-BASED index."
  (act-refuse 'act-request-lexis-refused "M-13A-4"
              "role ~a: code point 0x~2,'0X at zero-based index ~d"
              role (char-code (char string index)) index))

(defun check-cell-lexis (cell-string &key resource-rendering)
  "M-13a-1: nonempty · printable ASCII U+0021..U+007E only · NO SPACE ·
STRING= to the rendered Capability /0 resource term (conjunct (c) = BIND-1)."
  (unless (stringp cell-string)
    (act-refuse 'act-request-shape-refused "ACT-SHAPE-1"
                ":cell role value is not a host string"))
  (when (zerop (length cell-string))            ; M-13a-1(a)
    (act-refuse 'act-request-lexis-refused "M-13A-4"
                "role :cell: the empty string is refused pre-frontier"))
  (loop for i below (length cell-string)        ; M-13a-1(b)
        unless (printable-ascii-no-space-p (char cell-string i))
          do (%lexis-refuse :cell cell-string i))
  (when resource-rendering                      ; M-13a-1(c)
    (unless (string= cell-string resource-rendering)
      (act-refuse 'act-authority-binding-refused "BIND-1"
                  ":cell ~s is not STRING= to the rendered grant resource ~s"
                  cell-string resource-rendering)))
  t)

(defun check-text-lexis (text-string)
  "M-13a-2: nonempty · printable ASCII U+0021..U+007E plus INTERNAL U+0020 ·
U+0020 forbidden at the beginning or end, asserted on the FIRST and LAST
characters BY CODE POINT, not by TRIM · repeated internal spaces are LAWFUL and
no check may treat a doubled space as malformed (M-13a-2(d))."
  (unless (stringp text-string)
    (act-refuse 'act-request-shape-refused "ACT-SHAPE-1"
                ":text role value is not a host string"))
  (let ((n (length text-string)))
    (when (zerop n)                             ; M-13a-2(a)
      (act-refuse 'act-request-lexis-refused "M-13A-4"
                  "role :text: the empty string is refused pre-frontier"))
    (loop for i below n                         ; M-13a-2(b)
          unless (printable-ascii-or-space-p (char text-string i))
            do (%lexis-refuse :text text-string i))
    ;; M-13a-2(c) — by code point, on the first and last characters.
    (when (= #x20 (char-code (char text-string 0)))
      (%lexis-refuse :text text-string 0))
    (when (= #x20 (char-code (char text-string (1- n))))
      (%lexis-refuse :text text-string (1- n))))
  t)

(defun request-roles (normal-form)
  "The normal form is (:predicate KW (ROLE VALUE)…) (slice1.lisp:369-378)."
  (cddr normal-form))

(defun project-request (normal-form)
  "M-13: cell-string := the :cell role's value; value-string := the :text
role's value.  A missing or non-string role, or any ADDITIONAL role, REFUSES."
  (let ((cell nil) (text nil) (extra '()))
    (dolist (pair (request-roles normal-form))
      (case (first pair)
        (:cell (setf cell (second pair)))
        (:text (setf text (second pair)))
        (t (push (first pair) extra))))
    (when extra
      (act-refuse 'act-request-shape-refused "ACT-SHAPE-1"
                  "request carries additional role(s) ~s" (reverse extra)))
    (unless (and cell text)
      (act-refuse 'act-request-shape-refused "ACT-SHAPE-1"
                  "request is missing ~a"
                  (cond ((null cell) ":cell") (t ":text"))))
    (values cell text)))

(defun canonicalize-request (form &key resource-rendering (lexis t))
  "L1b.  Canonicalize, then run the M-13a lexis check BEFORE bind-offices and
therefore BEFORE F1.  Failure is a PRE-ACT MALFORMED INVOCATION (M-13c-2): no
act, no Outcome, no frame, and NO FABRICATED ATTEMPT IDENTITY.
LEXIS NIL is the planted seam of H-INJECT layer 2 / M-13c-3 only."
  (let ((nf (lisp-plus-slice1:proposition form)))
    (multiple-value-bind (cell text) (project-request nf)
      (when lexis
        (check-cell-lexis cell :resource-rendering resource-rendering)
        (check-text-lexis text)))
    nf))

;;; --- V-REQ (contract §5.1a).  ONE rendering law serves BOTH the act identity
;;; --- and request-sha256, so the two can never disagree about what "the
;;; --- canonical request" is.

(defun request-record (normal-form)
  "V-REQ-2: one CD/0 record with EXACTLY THREE entries.  Roles ride IN
NORMAL-FORM ORDER — which slice1 has already sorted by (symbol-name role)
(slice1.lisp:313-316), so the order is the request's, not the renderer's."
  (rec (entry '("request" "predicate") (s-datum (symbol-name (second normal-form))))
       (entry '("request" "roles")
              (seq (mapcar (lambda (pair)
                             (let ((v (second pair)))
                               (unless (stringp v)
                                 ;; V-REQ-4: the renderer is TOTAL over what it
                                 ;; accepts and refuses everything else; it never
                                 ;; coerces.
                                 (act-refuse 'act-request-lexis-refused "M-13A-4"
                                             "role ~a value is not a host string"
                                             (first pair)))
                               (rec (entry '("role" "name")
                                           (s-datum (symbol-name (first pair))))
                                    (entry '("role" "value") (s-datum v)))))
                           (request-roles normal-form))))
       (entry '("request" "rendering") (i-datum +request-rendering-version+))))

(defun request-sha256-octets (request-rec)
  "V-REQ-3.  The value stored in F1 is the RAW 32 OCTETS as a bytes datum
(J-9-1), never the hex string; and the digest is never taken over a PJ-S/0
rendering (J-7e names the two orders and this is the first: CD/0 §14.3)."
  (lisp-plus-cd0:hex-to-octets (digest-of request-rec)))

;;; ===========================================================================
;;; L1c — THE MINT (contract §2A ACT-5, four steps, exactly as ruled).
;;;
;;; ⚠ A SEQUENCE, NOT A RECORD: CD/0 record entries are SORTED BY KEY OCTETS at
;;; construction, so a record's encoding order is the KEY order, not the
;;; DECLARED order.  The ruling says "ordered preimage"; a CD/0 sequence datum
;;; is the construct whose order is the declared one.
;;;
;;; ⚠ EACH ELEMENT IS A TYPED, LENGTH-DELIMITED CD/0 DATUM.  There is no string
;;; joining, no separator, no FORMAT, and no octet concatenation anywhere in the
;;; construction — which is exactly what ACT-2's ambiguous-concatenation
;;; prohibition requires.  Two distinct input triples cannot produce one
;;; preimage encoding.  (The forbidden construction is planted as
;;; H-ACT-PREIMAGE; without it ACT-2 has no detector at all.)
;;; ===========================================================================

(defvar *minted-this-run* '()
  "ACT-9b's RUN-LOCAL set.  A convenience that fails FAST; ACT-8's prefix scan
is the law.  Neither substitutes for the other.")

(defun act-id-preimage (seat-id request-octets)
  "STEP 1 — the ordered preimage: exactly THREE elements, in this order,
through the public constructor and by no other route."
  (seq (list (s-datum +act-id-domain+)                       ; (i)
             (idf (list "seat" seat-id))                     ; (ii)
             (b-datum (oct-copy request-octets)))))          ; (iii)

(defun mint-act-identity (seat-id request-octets &key (register t) (verbose nil))
  "L1c.  Runs EXACTLY ONCE PER ACT and BEFORE F1.  Returns (values act-id
digest-hex preimage-octet-length).  The lane never re-derives it 'because the
derivation is pure' — a second derivation is a second chance to differ
(ACT-5a).  A COLD READER may recompute freely (ACT-L3); the prohibition is on
the LANE re-deriving mid-act."
  (let* ((preimage (act-id-preimage seat-id request-octets))
         (poct (oct preimage))
         (digest (sha256-hex (oct-copy poct))))          ; STEPS 2 and 3
    (unless (hex64-p digest)
      (act-refuse 'act-fixture-table-invalid "ACT-4"
                  "the digest segment is not exactly 64 lowercase hex characters: ~s"
                  digest))
    (let ((act-id (idf (list +lane-stem+ "act" digest))))  ; STEP 4
      (when verbose
        (note "derivation: domain=~s" +act-id-domain+)
        (note "derivation: seat=~a (~d octets)"
              (identifier-segment-string (idf (list "seat" seat-id)))
              (oct-len (oct (idf (list "seat" seat-id)))))
        (note "derivation: request-octets=~d  preimage=~d octets"
              (oct-len request-octets) (oct-len poct))
        (note "derivation: digest=~a" digest)
        (note "derivation: act-id=~a" (identifier-segment-string act-id)))
      ;; ACT-9b, at L1c, per act: absent from the run-local set, then added.
      (when register
        (when (find act-id *minted-this-run* :test #'datum=)
          (act-refuse 'act-identity-taken "ACT-9b"
                      "act identity ~a was already minted in this run"
                      (identifier-segment-string act-id)))
        (push act-id *minted-this-run*))
      (values act-id digest (oct-len poct)))))

;;; ===========================================================================
;;; L2 — bind-offices (contract §2.4).
;;;
;;; A CONSTRUCTION OF A TEST FIXTURE FROM DECLARED TERMS AND A CANONICAL
;;; REQUEST, never an authority operation (§2.5).  It mints nothing any Kernel
;;; §11 verb would recognize, and under the repaired signature it does not even
;;; HOLD an Office R capability object: it reads the GRANT's terms, which is
;;; strictly less than holding the authority.
;;; ===========================================================================

(defun bind-offices (grant-receipt-terms adapter-name normal-form)
  "bind-offices : (grant-receipt-terms, adapter-name, normal-form)
                    -> fixture-sealed-ruling
GRANT-RECEIPT-TERMS is the plist (:subject :action :resource :scope) as the
terms stand in the Capability /0 GRANT this act's Office R capability will be
minted from.  ⚠ NOT a live capability: at L2 no Office R live capability
exists, because its mint is L3b (after F1)."
  (declare (ignore grant-receipt-terms))
  (let ((predicate (second normal-form)))
    ;; BIND-3 — length 1, no wildcard, no additional predicate (A-6, the
    ;; narrowness clause: one act, one predicate, one cell).
    (lisp-plus-core0:mint-capability
     :ruling (lisp-plus-core0:fixture-sealed-ruling
              :adapter-name adapter-name
              :predicates (list predicate)
              :minter +bind-offices-minter+))))

;;; ===========================================================================
;;; §4 — the lane-local envelope (contract J-7) and the five frame bodies (J-9).
;;;
;;; The lane MUST reimplement the envelope: Capability /2's builder
;;; %event-envelope is INTERNAL and hard-codes its own namespace "cap2-event"
;;; (capability2/events.lisp:79).
;;;
;;; ⚑ J-7a — FOUR CONSTANTS DIFFER FROM CAPABILITY /2'S, DELIBERATELY.  This
;;; lane's five frames are ITS OWN ACCOUNT OF ITS OWN STEPS, appended by the lane
;;; itself: not kernel-mediated, not observed by a third party, not recorded by
;;; the store.  Copying cap2's constants would put a CAPTURE-PROVENANCE CLAIM
;;; into durable bytes that the lane cannot support (the L-5 / K-10 defect in
;;; field form).  Nothing in Journal /0 constrains these values, so the choice is
;;; the lane's — and being free, it must be honest.
;;; ===========================================================================

(defparameter +frame-letters+
  '((:f1 . "o") (:f2 . "b") (:f3 . "f") (:f4 . "c") (:f5 . "r")))

(defparameter +frame-kinds+
  '((:f1 . "binding-declared")
    (:f2 . "language-attempt-bound")
    (:f3 . "language-reconciliation-frozen")
    (:f4 . "reconciliation-correspondence")
    (:f5 . "readback")))

(defparameter +frame-ordinals+
  '((:f1 . 1) (:f2 . 2) (:f3 . 3) (:f4 . 4) (:f5 . 5)))

(defun frame-event-id (frame attempt-name)
  (idf (list +lane-event-namespace+
             (format nil "~a-~a" (cdr (assoc frame +frame-letters+)) attempt-name))))

(defun frame-kind (frame)
  (idf (list "act" (cdr (assoc frame +frame-kinds+)))))

(defun lane-envelope (&key frame attempt-name body)
  "EXACTLY TEN FIELDS AND NO OTHERS.  ⚠ Field order in source is not canonical
order and no law rests on it: the two orders that govern are J-7e's — CD/0
§14.3 in memory / for canonical-octets, PJ-S/0 record-key order (PJ0 Erratum
0.1) in the durable text.  Both are total functions of the key SET."
  (rec (entry '("event" "attempt") (idf (list "attempt" attempt-name)))
       (entry '("event" "body") body)
       (entry '("event" "capture-boundary") (idf '("boundary" "lane-accounting")))
       (entry '("event" "capture-mechanism") (idf '("witness" "lane-self-report")))
       (entry '("event" "event-id") (frame-event-id frame attempt-name))
       (entry '("event" "kind") (frame-kind frame))
       (entry '("event" "origin") (idf '("origin" "self-reported")))
       (entry '("event" "process-id") (idf (list "process" +runtime-process-name+)))
       (entry '("event" "recorder-principal") (idf (list "principal" +lane-stem+)))
       (entry '("event" "subject-principal")
              (idf (list "principal" +runtime-process-name+)))))

;;; --- J-9-0: every body key is a TWO-SEGMENT identifier ("act" "<field>").
;;; --- A body field is NEVER a boolean and NEVER absent: an unknown value is a
;;; --- refusal, not a NIL.  A Kernel /0 identity name is recorded as a STRING,
;;; --- VERBATIM, and is NEVER split on "/" or ":" into a CD/0 identifier
;;; --- (M-13-NO-PARSE's discipline applied to the language side; NC-27 is why).

(defun bfield (name value) (entry (list "act" name) value))

(defun build-f1 (record &key grant-terms office-l-capability-id
                             language-process language-seat logical-operation)
  "F1 act:binding-declared — SIXTEEN entries, exactly the §3.2 F1 row.
⚑ F1 IS A DURABLE DECLARATION OF A PROPOSED BINDING.  It is not an act, not an
attempt, not an Outcome, and not a refusal (J-2a).  The subject of F1 is the
LANE, and its verb is DECLARED.
FORBIDDEN IN F1 BY LAW, not by omission: the Office R public-id and
occurrence-id (they do not exist yet — J-4a family 2) and the dispatcher-binding
verdict (J-4a family 3)."
  (let ((f (act-record-fixture record)))
    (lane-envelope
     :frame :f1 :attempt-name (act-fixture-attempt-name f)
     :body
     (rec (bfield "act-id" (act-record-act-id record))
          (bfield "attempt-name" (idf (list "attempt" (act-fixture-attempt-name f))))
          (bfield "seat-name" (idf (list "seat" (act-fixture-runtime-seat f))))
          (bfield "language-process" (s-datum language-process))
          (bfield "language-seat" (s-datum language-seat))
          (bfield "logical-operation" (s-datum logical-operation))
          (bfield "request-sha256"
                  (b-datum (request-sha256-octets (act-record-request-rec record))))
          (bfield "request-predicate"
                  (s-datum (symbol-name (second (act-record-normal-form record)))))
          (bfield "grant-subject" (getf grant-terms :subject))
          (bfield "grant-action" (getf grant-terms :action))
          (bfield "grant-resource" (getf grant-terms :resource))
          (bfield "grant-scope" (getf grant-terms :scope))
          (bfield "office-l-capability-id" (s-datum office-l-capability-id))
          (bfield "bind-offices-version" (i-datum +bind-offices-version+))
          ;; A-5a: the field takes EXACTLY ONE VALUE, "pass".  A FAILING BINDING
          ;; IS NEVER DURABLY RECORDED — BIND-1, BIND-2(a), BIND-2(c) and
          ;; BIND-3..BIND-6 are checked at L2 and F1 is appended at L3.
          ;; ⚠ BIND-2(b) IS NOT AMONG THEM: it is PRE-1, and its verdict is a
          ;; required field of F2.
          (bfield "bind-verdict" (s-datum "pass"))
          (bfield "lexis-verdict" (s-datum "pass"))))))

(defun build-f2 (record &key act-id-from-store language-attempt-id
                             language-process-observed language-seat-observed
                             frontier office-r-public-id office-r-occurrence-id
                             outcome-view effect-axis-value effect-axis-determinacy)
  "F2 act:language-attempt-bound — THIRTEEN entries.  POST-DISPOSITION (J-4-OR3):
after perform RETURNS OR SIGNALS and after its §3.3 class is known — never
'post-frontier' as a positioning law, because on Class B no frontier is crossed.
⚑ act-id is READ BACK FROM THIS ACT'S F1 IN THE STORE, never from a host
variable (J-4c)."
  (let ((f (act-record-fixture record)))
    (lane-envelope
     :frame :f2 :attempt-name (act-fixture-attempt-name f)
     :body
     (rec (bfield "act-id" act-id-from-store)
          (bfield "language-attempt-id" (s-datum language-attempt-id))
          (bfield "language-process-observed" (s-datum language-process-observed))
          (bfield "language-seat-observed" (s-datum language-seat-observed))
          (bfield "bind6-verdict" (s-datum "pass"))
          (bfield "dispatcher-binding-verdict" (s-datum "pass"))
          ;; J-4-OR3: EXPLICIT, REQUIRED, never absent, never NIL-punned.
          (bfield "frontier" (s-datum frontier))
          (bfield "office-r-public-id" office-r-public-id)
          (bfield "office-r-occurrence-id" office-r-occurrence-id)
          (bfield "office-r-term-verdict" (s-datum "pass"))
          (bfield "outcome-view" (s-datum outcome-view))
          (bfield "effect-axis-value" (s-datum effect-axis-value))
          (bfield "effect-axis-determinacy" (s-datum effect-axis-determinacy))))))

(defun build-f3 (record &key act-id-from-store continuation-disposition
                             required-action ledger-answer)
  "F3 act:language-reconciliation-frozen — FIVE entries.  Appended BEFORE
reconcile-uncertain-effect, and never after it (J-4)."
  (let ((f (act-record-fixture record)))
    (lane-envelope
     :frame :f3 :attempt-name (act-fixture-attempt-name f)
     :body
     (rec (bfield "act-id" act-id-from-store)
          (bfield "attempt-name" (idf (list "attempt" (act-fixture-attempt-name f))))
          (bfield "continuation-disposition" (s-datum continuation-disposition))
          (bfield "required-action" (s-datum required-action))
          (bfield "ledger-answer" (s-datum ledger-answer))))))

(defun build-f4 (record &key act-id-from-store runtime-resolution
                             correspondence-row correspondence-verdict)
  "F4 act:reconciliation-correspondence — FOUR entries.  ⚠ row 2 may NEVER read
\"agree\" (R-4a, R-5, OR-2).  The verdict is THREE-VALUED here, and it is a
DIFFERENT verdict from §6.3's two-valued agreement gate."
  (let ((f (act-record-fixture record)))
    (lane-envelope
     :frame :f4 :attempt-name (act-fixture-attempt-name f)
     :body
     (rec (bfield "act-id" act-id-from-store)
          (bfield "runtime-resolution" (s-datum runtime-resolution))
          (bfield "correspondence-row" (s-datum correspondence-row))
          (bfield "correspondence-verdict" (s-datum correspondence-verdict))))))

(defparameter +o5-facets+
  '(:manifestation :no-payload-state :provenance
    :chunks-preserved :refusal :interpretation-class)
  "O-5's list, in the contract's own order.  The record's key set IS this list
and a MISSING FACET IS A REFUSAL — all six, always.")

(defun build-f5 (record &key act-id-from-store execution-standing evidence-class
                             mapping-row agreement-verdict absent-facets)
  "F5 act:readback — EIGHT entries.  ⚑ the namespace-absence verdict is
recorded, not merely asserted: an absence that is asserted and then not recorded
is an absence no cold reader can check (N-6a)."
  (let ((f (act-record-fixture record)))
    (lane-envelope
     :frame :f5 :attempt-name (act-fixture-attempt-name f)
     :body
     (rec (bfield "act-id" act-id-from-store)
          (bfield "attempt-name" (idf (list "attempt" (act-fixture-attempt-name f))))
          (bfield "execution-standing" (s-datum execution-standing))
          (bfield "evidence-class" (s-datum evidence-class))
          (bfield "mapping-row" (s-datum mapping-row))
          (bfield "agreement-verdict" (s-datum agreement-verdict))
          (bfield "absent-facets"
                  (apply #'rec
                         (mapcar (lambda (facet)
                                   (let ((v (getf absent-facets facet)))
                                     (unless v
                                       (act-refuse 'act-readback-disagreement "O-5"
                                                   "facet ~a is missing from the ~
absent-facet record; a missing facet is a refusal" facet))
                                     (entry (list "facet" (string-downcase (symbol-name facet)))
                                            (s-datum v))))
                                 +o5-facets+)))
          (bfield "namespace-absence-verdict" (s-datum "pass"))))))

;;; ===========================================================================
;;; §5 — the append discipline (ACT-8, ACT-8a, J-4, J-4c).
;;; ===========================================================================

(defvar *appended-frames* (make-hash-table :test #'equal)
  "act-id-hex -> the list of frames appended for that act, newest first.
The lane's ordering guard reads it; J-4c's constancy check reads the STORE.")

(defun lane-frame-events (store)
  "Every frame of the LANE'S OWN FIVE KINDS in the validated prefix."
  (let ((report (validate-journal store))
        (out '()))
    (let ((events (prefix-report-events report)))
      (loop for i below (fill-pointer events)
            for ev = (aref events i)
            for kind = (let ((k (record-field ev "event" "kind")))
                         (and k (lisp-plus-cd0:identifier-datum-p k)
                              (identifier-segment-string k)))
            when (and kind (>= (length kind) 4) (string= "act:" (subseq kind 0 4)))
              do (push (cons (1+ i) ev) out)))
    (nreverse out)))

(defun frame-act-id (event)
  (let ((body (record-field event "event" "body")))
    (and body (record-field body "act" "act-id"))))

(defun frame-seat-name (event)
  (let ((body (record-field event "event" "body")))
    (and body (record-field body "act" "seat-name"))))

(defun act-8-prefix-scan (store act-id)
  "ACT-8 / ACT-L5.  A PURE READ THAT APPENDS NOTHING.  Refuses BEFORE the
append if the identity already appears in the validated prefix, naming the
ordinal of the prior frame.  ⚠ THE ACT-ID IS NOT AN EVENT-ID: nothing in
Journal /0 checks it (ACT-7(b), U-3), so this is the LANE'S OWN OBLIGATION and
may never be attributed to Journal /0."
  (loop for (ordinal . ev) in (lane-frame-events store)
        for other = (frame-act-id ev)
        when (and other (datum= other act-id))
          do (act-refuse 'act-identity-taken "ACT-8"
                         "act identity ~a is already present in the validated ~
prefix at ordinal ~d" (identifier-segment-string act-id) ordinal))
  t)

(defun seat-consumption-scan (store seat-name)
  "K-7a-1 SHAPE 2 — the arm ACT-8 CANNOT SEE.  Any prior F1 in this store
recording this runtime seat CONSUMES it, even when the canonical request
differs and the derived identity is therefore new.  ⚠ NOT redundant with
ACT-8; it is the ONLY guard on this shape."
  (let ((target (idf (list "seat" seat-name))))
    (loop for (ordinal . ev) in (lane-frame-events store)
          for kind = (identifier-segment-string (record-field ev "event" "kind"))
          for seat = (frame-seat-name ev)
          when (and (string= kind "act:binding-declared") seat (datum= seat target))
            do (act-refuse 'act-binding-consumed "K-7a"
                           "runtime seat ~s was consumed by the F1 at ordinal ~d"
                           seat-name ordinal)))
  t)

(defun read-act-id-from-store (store record)
  "J-4c: read this act's act-id BACK FROM ITS ALREADY-APPENDED F1 — via
find-event on F1's own event-id, then decode the frame — never from a host
variable, so that a mutated in-image value cannot pass."
  (let ((eid (frame-event-id :f1 (act-fixture-attempt-name (act-record-fixture record)))))
    (multiple-value-bind (ordinal digest payload) (find-event store eid)
      (declare (ignore digest))
      (unless ordinal
        (act-refuse 'act-frame-ordering-violated "ACT-ORDER-1"
                    "no F1 is present for act ~a"
                    (identifier-segment-string (act-record-act-id record))))
      (frame-act-id (decode-pjs0 payload)))))

(defun append-lane-frame (store frame record datum &key (constancy t))
  "The ordering guard (J-4), the identity-constancy guard (J-4c) and ACT-8a,
all BEFORE the append, so the prefix never carries a violation."
  (let* ((key (act-record-act-id-hex record))
         (already (gethash key *appended-frames*))
         (ordinal (cdr (assoc frame +frame-ordinals+))))
    ;; J-4 / ACT-ORDER-1 — enforced IN CODE, not in prose: a documented
    ;; ordering that a caller can violate is not an ordering.
    (let ((last (first already)))
      (when (and last (<= ordinal (cdr (assoc last +frame-ordinals+))))
        (act-refuse 'act-frame-ordering-violated "ACT-ORDER-1"
                    "frame kind ~a (intended ordinal ~d) would follow ~a ~
(ordinal ~d) for act ~a"
                    (identifier-segment-string (frame-kind frame)) ordinal
                    (identifier-segment-string (frame-kind last))
                    (cdr (assoc last +frame-ordinals+))
                    (identifier-segment-string (act-record-act-id record))))
      (when (and (not (eq frame :f1)) (null already))
        (act-refuse 'act-frame-ordering-violated "ACT-ORDER-1"
                    "frame kind ~a (intended ordinal ~d) has no F1 to follow for act ~a"
                    (identifier-segment-string (frame-kind frame)) ordinal
                    (identifier-segment-string (act-record-act-id record)))))
    ;; J-4c — at each of F2..F5, the act-id about to be written is datum= to
    ;; the act-id READ BACK FROM THE STORE.
    (when (and constancy (not (eq frame :f1)))
      (let ((from-store (read-act-id-from-store store record))
            (about-to-write (frame-act-id datum)))
        (unless (and from-store about-to-write (datum= from-store about-to-write))
          (act-refuse 'act-identity-branch "ACT-12"
                      "act identity branch: F1 in store carries ~a; this ~a would ~
carry ~a"
                      (and from-store (identifier-segment-string from-store))
                      (identifier-segment-string (frame-kind frame))
                      (and about-to-write (identifier-segment-string about-to-write))))))
    (let ((receipt (append-event store datum)))
      ;; ACT-8a / U-2 — "THE APPEND DID NOT ERROR" IS NOT EVIDENCE THAT THE
      ;; FRAME WAS WRITTEN.  A duplicate append with a byte-identical payload
      ;; does NOT signal: it returns :already-committed-identical and appends
      ;; nothing (journal0/writer.lisp:303-322).
      (unless (eq :newly-committed (append-receipt-disposition receipt))
        (act-refuse 'act-frame-ordering-violated "ACT-8a"
                    "append of ~a returned disposition ~s, not :newly-committed"
                    (identifier-segment-string (frame-kind frame))
                    (append-receipt-disposition receipt)))
      (push frame (gethash key *appended-frames*))
      receipt)))

;;; ===========================================================================
;;; §6 — J-6, the cold-readback rule: the TOTAL table of act-frame shapes.
;;; Any shape not in the table is ACT-SHAPE-UNKNOWN and STOPS the round.
;;; ===========================================================================

(defun classify-act-frames (frames)
  "FRAMES is the set of frame keywords present for one act-id."
  (let ((has (lambda (k) (member k frames))))
    (cond ((and (funcall has :f1) (= 1 (count :f1 frames))
                (not (funcall has :f2)) (not (funcall has :f3))
                (not (funcall has :f4)) (not (funcall has :f5)))
           :binding-declared-unpaired)
          ((> (count :f1 frames) 1) :act-identity-collapse)
          ((and (funcall has :f1) (funcall has :f2) (funcall has :f5)
                (funcall has :f3) (funcall has :f4))
           :act-reported-with-reconciliation)
          ((and (funcall has :f1) (funcall has :f2) (funcall has :f5)
                (not (funcall has :f3)) (not (funcall has :f4)))
           :act-reported)
          ((and (funcall has :f1) (funcall has :f2) (not (funcall has :f5))
                (not (funcall has :f3)) (not (funcall has :f4)))
           :readback-missing)
          (t :act-shape-unknown))))

;;; ===========================================================================
;;; §7 — the immutable per-act dispatch context and the act's own bridge object.
;;;
;;; M-3: ONE BRIDGE IMPLEMENTATION, ONE BRIDGE OBJECT PER ACT.  The bridge
;;; therefore NEVER "LEARNS" WHICH ACT IT SERVES.  It cannot be wrong about it,
;;; because it has no way to be about any other act: the act's identities are
;;; closed over at construction, in an immutable record, and there is no lookup,
;;; no table, and no key.  MR-4's resolution question is DISSOLVED, not answered.
;;;
;;; M-3b — forbidden and absent: a request-keyed shared table · a mutable
;;; "current act" cell · ambient dynamic selection · a global registry entry
;;; shared by all arms · a construction-time capture of a capability that does
;;; not yet exist.
;;; ===========================================================================

(defstruct (dispatch-context (:constructor %make-dispatch-context) (:copier nil))
  "L3c-i.  Constructed ONCE, fully, and READ-ONLY thereafter.  No field is
assigned into it after construction (M-3a)."
  (act-id nil :read-only t) (normal-form nil :read-only t)
  (process nil :read-only t) (seat-name nil :read-only t)
  (attempt-name nil :read-only t) (cell-segments nil :read-only t)
  (capability nil :read-only t)          ; the L3b Office R live capability
  (store nil :read-only t) (world nil :read-only t)
  (bootstrap nil :read-only t) (minting-context nil :read-only t)
  (grant-terms nil :read-only t) (capability-id nil :read-only t)
  (interruption nil :read-only t)
  (lexis-at-d0 t :read-only t))          ; the M-13c-3 planted seam only

(defun class-b-reason (condition-type requirement-id)
  "§3.4 row B: a STABLE keyword naming the condition type AND its requirement
id.  Never a message: SBCL's condition report text is not a stable interface
(V-7)."
  (intern (format nil "~a/~a" condition-type (or requirement-id "-")) :keyword))

(defun condition-requirement-id (c)
  "Refusals are named by CONDITION TYPE + REQUIREMENT-ID, never by message
text (V-7)."
  (typecase c
    (act0-condition (act0-condition-requirement-id c))
    (lisp-plus-capability2:cap2-condition
     (lisp-plus-capability2:cap2-condition-requirement-id c))
    (lisp-plus-capability1:cap1-condition
     (lisp-plus-capability1:cap1-condition-requirement-id c))
    (lisp-plus-kernel0:kernel0-condition
     (lisp-plus-kernel0:kernel0-condition-requirement-id c))
    (t "-")))

(defun derive-lane-class (store attempt-name disposition)
  "M-7 / §3.3.  The classification is computed BY READING THE JOURNAL, never by
reading a condition's type name.  M-8, the conservative frontier rule: ONLY
:absent counts as pre-frontier — :prepared-only and every later standing are
post-frontier, because capability2/attempt.lisp:193-194 places the frontier line
ABOVE the attempt:prepared append."
  (let ((standing (derive-effect-standing store attempt-name)))
    (values
     (cond ((and (eq standing :settled) (eq disposition :returned)) :a)
           ((and (eq standing :absent) (eq disposition :refused)) :b)
           ((and (eq standing :uncertain-unresolved) (eq disposition :interrupted)) :c-i)
           ((and (eq standing :crossed-unsettled) (eq disposition :interrupted)) :c-ii)
           ((and (eq standing :crossed-unsettled) (eq disposition :host-fault)) :d)
           (t :unclassifiable))
     standing)))

(defun make-lane-bridge (adapter-symbol context)
  "L3c-ii.  ONE bridge implementation, constructed through Core /0's PUBLIC
constructor make-adapter (core0.lisp:396-413), with ZERO Core /0 edits, over
THIS ACT'S OWN immutable context and registered under THIS ACT'S OWN symbol.
The bridge does not LEARN which act it serves; it CANNOT serve another."
  (lisp-plus-core0:make-adapter
   :name adapter-symbol
   :identity (lisp-plus-kernel0:make-identity
              :principal (format nil "oneact0/bridge/~a"
                                 (dispatch-context-seat-name context)))
   :version 0
   :dispatch (lambda (adapter request attempt-id)
               (declare (ignore adapter attempt-id))
               (lane-dispatch context request))
   :ledger-query (lambda (adapter attempt-id request)
                   (declare (ignore adapter attempt-id request))
                   (lane-ledger-query context))))

(defun lane-dispatch (context normal-form)
  "M-4: inside ONE call — D0 project+lexis · D1 authorize · D2 attempt ·
D3 classify · D4 project.
M-5, THE NO-APPEND LAW: BETWEEN D1 AND D2 THE LANE APPENDS NOTHING.  Placing
them inside one closure with nothing between them satisfies it by construction."
  (let* ((store (dispatch-context-store context))
         (attempt-name (dispatch-context-attempt-name context))
         (seat-name (dispatch-context-seat-name context)))
    ;; ---- D0.  M-13c-1: a request-shape failure inside DISPATCH must NOT
    ;; ---- escape as an unclassified foreign condition; it is PROJECTED into
    ;; ---- the declared Class-B plist and returned normally, so perform reaches
    ;; ---- its own refusal path and PRODUCES THE REFUSED OUTCOME THE GOVERNING
    ;; ---- SENTENCE PROMISES — one form, one act, one Outcome, in the failure
    ;; ---- mode too.
    (multiple-value-bind (cell text)
        (handler-case (project-request normal-form)
          (act-request-shape-refused (c)
            (return-from lane-dispatch
              (list :crossed nil :committed nil :acknowledged nil
                    :local-record-lands nil :ledger-token nil
                    :manifestation-status :declared-none
                    :reason (class-b-reason 'act-request-shape-refused
                                            (act0-condition-requirement-id c))))))
      (when (dispatch-context-lexis-at-d0 context)
        (handler-case (progn (check-cell-lexis cell) (check-text-lexis text))
          (act-request-lexis-refused (c)
            (return-from lane-dispatch
              (list :crossed nil :committed nil :acknowledged nil
                    :local-record-lands nil :ledger-token nil
                    :manifestation-status :declared-none
                    :reason (class-b-reason 'act-request-lexis-refused
                                            (act0-condition-requirement-id c)))))))
      (let ((terms (dispatch-context-grant-terms context)))
        (handler-case
            (let* ((authorization
                     ;; D1 — Office R.
                     (authorize-effect-attempt
                      store (dispatch-context-bootstrap context)
                      (dispatch-context-minting-context context)
                      (dispatch-context-capability context)
                      :capability-id (dispatch-context-capability-id context)
                      :query-name (format nil "q-~a-auth" seat-name)
                      :subject (getf terms :subject) :action (getf terms :action)
                      :resource (getf terms :resource) :scope (getf terms :scope)
                      :cell (dispatch-context-cell-segments context)
                      :value text
                      :attempt-name attempt-name :seat-name seat-name)))
              ;; D2 — the frontier.  NOTHING BETWEEN D1 AND D2 (M-5).
              (multiple-value-bind (status detail)
                  (attempt-protected-effect
                   store (dispatch-context-bootstrap context)
                   (dispatch-context-minting-context context)
                   (dispatch-context-capability context)
                   authorization (dispatch-context-world context)
                   :process-name +runtime-process-name+
                   :interruption (dispatch-context-interruption context))
                (lane-project-report context status detail)))
          ;; Every typed condition from D1 or D2.  D3 reads the JOURNAL to
          ;; decide whether this was pre-frontier or not.
          (error (c)
            (let ((standing (derive-effect-standing store attempt-name)))
              (if (eq standing :absent)
                  ;; CLASS B — refused before any frontier; cap2 journaled
                  ;; nothing.
                  (list :crossed nil :committed nil :acknowledged nil
                        :local-record-lands nil :ledger-token nil
                        :manifestation-status :declared-none
                        :reason (class-b-reason (type-of c)
                                                (condition-requirement-id c)))
                  ;; CLASS D — a POST-frontier condition.  M-9: the bridge
                  ;; signals; it does NOT produce a plist, does NOT manufacture
                  ;; a core0-refused, and does NOT rewrite anything below the
                  ;; frontier line as a refusal (M-8).
                  (act-refuse 'act-bridge-contract-violated "ACT-BRIDGE-1"
                              "post-frontier condition ~a [~a] at standing ~s: ~
Class D is a HOST FAULT, not an Outcome"
                              (type-of c) (condition-requirement-id c)
                              standing)))))))))

(defun lane-project-report (context status detail)
  "D4 — the TOTAL projection of §3.4.
M-11, THE AP-ACK-4 CLAUSE: `:committed` may be set T ONLY on Class A.  Setting
it T on C-i would carry an acknowledgment across the bridge as if it settled —
THE FORBIDDEN PROMOTION, LAUNDERED THROUGH AN ADAPTER.  Both C branches reach
Core /0's uncertain branch via (and committed local-lands) being false, which is
the honest route."
  (let ((store (dispatch-context-store context))
        (attempt-name (dispatch-context-attempt-name context)))
    (case status
      (:settled
       (let ((standing (derive-effect-standing store attempt-name)))
         (unless (eq standing :settled)
           (act-refuse 'act-bridge-contract-violated "ACT-BRIDGE-1"
                       ":settled returned but the derived standing is ~s" standing))
         (list :crossed t :committed t :acknowledged t :local-record-lands t
               :ledger-token (ledger-token-string context)
               :manifestation-status :declared-present
               :reason nil)))
      (:uncertain                             ; C-i
       (list :crossed t :committed nil :acknowledged t :local-record-lands nil
             :ledger-token nil :manifestation-status :declared-none
             :reason :acknowledgment-without-evidence))
      (:interrupted                           ; C-ii
       (if (eq detail :request-lost)
           (list :crossed t :committed nil :acknowledged nil
                 :local-record-lands nil :ledger-token nil
                 :manifestation-status :declared-none
                 :reason :request-lost)
           (act-refuse 'act-bridge-contract-violated "ACT-BRIDGE-1"
                       "unknown interruption point ~s" detail)))
      (t (act-refuse 'act-bridge-contract-violated "ACT-BRIDGE-1"
                     "status keyword ~s is outside {:settled :uncertain :interrupted}"
                     status)))))

(defun ledger-token-string (context)
  "Class A's :ledger-token — the settled event's ledger-entry evidence
identifier, as a string."
  (let ((rid (identifier-segment-string
              (idf (list "external-request" "cap2"
                         (dispatch-context-attempt-name context))))))
    (multiple-value-bind (found line line-sha)
        (world-ledger-lookup* (dispatch-context-world context) rid)
      (declare (ignore line))
      (and found line-sha))))

(defun world-ledger-lookup* (world rid)
  (lisp-plus-capability2:world-ledger-lookup world rid))

(defun lane-ledger-query (context)
  "LEDGER-QUERY — a witness of LIMITED JURISDICTION.
(:answered :committed TOKEN) | (:answered :not-committed) | (:withheld)."
  (let ((rid (identifier-segment-string
              (idf (list "external-request" "cap2"
                         (dispatch-context-attempt-name context))))))
    (multiple-value-bind (found line line-sha)
        (world-ledger-lookup* (dispatch-context-world context) rid)
      (declare (ignore line))
      (if found (list :answered :committed line-sha) (list :answered :not-committed)))))

;;; ===========================================================================
;;; §8 — the agreement gate (contract §6.3, O-4..O-8).
;;;
;;; ⚠ TWO-VALUED: "agree" or the disagreement word.  The THREE-VALUED verdict
;;; (AGREE / JURISDICTIONAL-DIVERGENCE / DISAGREE) belongs to the §9.3 / F4
;;; correspondence and is a DIFFERENT instrument; admitting
;;; `jurisdictional-divergence` as an F5 agreement verdict would breach the
;;; field laws at §3.2 and J-9.
;;; ===========================================================================

(defparameter +agreement-table+
  ;; (row-label class-view effect-axis expected-standing expected-evidence-class)
  ;; ⚠ THE VIEW AND AXIS COLUMNS ARE SYMBOL-NAMES, WHICH CARRY NO LEADING
  ;; COLON.  Contract §6.3 writes its cells as keywords (:committed, :settled);
  ;; the lane compares (symbol-name …), so the table holds "COMMITTED" and
  ;; "SETTLED".  The first draft of this table transcribed the colons and every
  ;; row disagreed — a defect in the TRANSCRIPTION, repaired here, never in the
  ;; contract's rows, which are unchanged in substance.
  '(("A"            "COMMITTED"     "SETTLED"     :settled              :none)
    ("B"            "REFUSED"       "NOT-ENTERED" :absent               :none)
    ("C-i"          "INDETERMINATE" "BOUNDED"     :uncertain-unresolved :uncertain)
    ("C-ii-pre"     "INDETERMINATE" "BOUNDED"     :crossed-unsettled    :none)
    ("C-ii-post"    "INDETERMINATE" "BOUNDED"     :uncertain-unresolved :uncertain)
    ("C-reconciled" "INDETERMINATE" "BOUNDED"     :reconciled           :reconciled)
    ("D-pre"        "no-outcome-host-fault" "no-outcome-host-fault"
                                                  :crossed-unsettled    :none)
    ("D-post"       "no-outcome-host-fault" "no-outcome-host-fault"
                                                  :uncertain-unresolved :uncertain))
  "The TOTAL table of O-4.  A pairing absent from it is a DISAGREEMENT.
⚠ O-4a: the two D rows enumerate EVERY admissible D pairing and no others.  The
previous draft's \":crossed-unsettled or later / as derived\" accepted every
value and therefore made the mandatory D arm a row that structurally could not
fail.")

(defun agreement-gate (row-label outcome-view effect-axis standing evidence-class)
  "Returns (values verdict row).  O-7: THE GATE MUST BE SHOWN ABLE TO FAIL
before a clean pass is reported."
  (let ((row (find row-label +agreement-table+ :key #'first :test #'string=)))
    (if (and row
             (string= outcome-view (second row))
             (string= effect-axis (third row))
             (eq standing (fourth row))
             (eq evidence-class (fifth row)))
        (values "agree" row)
        (values "disagree" row))))

;;; ===========================================================================
;;; §9 — the §9.3 correspondence verdict (THREE-VALUED, R-4a).
;;; ===========================================================================

(defun correspondence-verdict (language-disposition runtime-resolution)
  "⚠ ROW 2 MAY NEVER READ \"agree\" (R-5, OR-2).  The asymmetry is the point of
the table: the language layer froze a disposition from a ledger it could see;
the runtime resolved from the world it could see.  Where the two reach different
standings for one act, THE DIFFERENCE IS REPORTED, NEVER RECONCILED BY FIAT."
  (cond ((and (string= language-disposition "ANSWERED-COMMITTED")
              (eq runtime-resolution :applied))
         (values "agree" "row-1"))
        ((and (string= language-disposition "ANSWERED-NOT-COMMITTED")
              (eq runtime-resolution :not-applied))
         ;; ROW 2 — the declared asymmetry.  The language layer read a ledger
         ;; that answered "not committed" and the runtime confirmed
         ;; :not-applied; the two agree on the FACT and differ in JURISDICTION,
         ;; and the honest word for that is not "agree".
         (values "jurisdictional-divergence" "row-2"))
        (t (values "disagree" "row-3"))))

;;; ===========================================================================
;;; §10 — L1: the run's construction (the world, the store, the /0 bootstrap
;;; authority and grant, the /1 minting context, the process-contexts, and the
;;; bridge IMPLEMENTATION — the code, not an object).
;;;
;;; ⚠ NO BRIDGE OBJECT IS CONSTRUCTED HERE AND NONE IS REGISTERED (L1, repaired
;;; in R1.1).  Construction and registration are L3c-ii, and not one step
;;; earlier: at L1 the act holds only its lane-owned adapter SYMBOL.  A bridge
;;; object built here could hold no Office R capability — it does not exist until
;;; L3b — so building one here is the construction-time capture M-3b forbids.
;;; ⚠ THE OFFICE R LIVE CAPABILITY IS NOT MINTED HERE.  Its mint is L3b.
;;; ===========================================================================

(defvar *run-root* nil)
(defvar *store* nil)
(defvar *worlds* nil)          ; plist :apply WORLD :ambiguous WORLD
(defvar *bootstrap* nil)
(defvar *minting-context* nil)

(defparameter +act-subject+  '("subject" "scriba"))
(defparameter +act-action+   '("action"  "inscribere"))
(defparameter +act-scope+    '("scope"   "semel"))
(defparameter +act-issuer+   '("issuer"  "oneact0"))

(defun grant-terms-for (fixture)
  "The four terms of the Capability /0 GRANT this act's Office R capability
will be minted from.  Following Vertical Specimen /0 correction C1: THE
PER-SEAT RESOURCE IS THE SEAT'S EFFECT-CELL IDENTITY."
  (list :subject (idf +act-subject+)
        :action (idf +act-action+)
        :resource (idf (act-fixture-cell-segments fixture))
        :scope (idf +act-scope+)))

(defun capability-id-for (fixture)
  (list "cap" (act-fixture-runtime-seat fixture)))

(defun w-env-preflight (&key (signal t))
  "W-ENV (contract §14.2, V-8..V-10).  Runs BEFORE the store is created and
BEFORE the first act.  Prints one stable check-line per variable.  ANY ONE SET
VOIDS THE RUN: the run stops, reports the variable and its value, and CREATES
NO JOURNAL STORE.  ⚠ A VOID IS NOT A FAILURE OF THE SPECIMEN and is never
reported as a pass (WE-04)."
  (let ((set-vars '()))
    (dolist (name (append +w-env-class-i+ +w-env-class-ii+))
      (let ((value (sb-posix:getenv name)))
        (if value
            (progn (push (cons name value) set-vars)
                   (format t "~&  W-ENV ~a SET=~s~%" name value))
            (format t "~&  W-ENV ~a unset~%" name))))
    (format t "~&  W-ENV enumerated ~d variables (~d Class I + ~d Class II)~%"
            (+ (length +w-env-class-i+) (length +w-env-class-ii+))
            (length +w-env-class-i+) (length +w-env-class-ii+))
    (when set-vars
      (format t "~&  W-ENV VOID: ~d variable(s) set; NO JOURNAL STORE IS CREATED~%"
              (length set-vars))
      (when signal
        (act-refuse 'act-run-void "V-8"
                    "environment variable ~a is set to ~s; §7.1 declares one ~
process life and this switch can end the process"
                    (car (first set-vars)) (cdr (first set-vars)))))
    (null set-vars)))

(defun build-store (root)
  "F-STORE.  The nonce is EXACTLY sixteen octets, asserted BY LENGTH, not by
counting the source line (FS-01)."
  (assert (= 16 (length +act-store-nonce+)) ()
          "FS-01: the store nonce must be exactly sixteen octets, not ~d"
          (length +act-store-nonce+))
  (create-journal (merge-pathnames "store/" root)
                  :nonce-octets +act-store-nonce+))

(defun build-fixture-worlds (root)
  "WF-03: the two worlds are constructed in DECLARED FIXED relative directories
under the run root.  No PID, no clock, no (random), no temp-dir name anywhere
in either path (contract V-7)."
  (list :apply (make-world (merge-pathnames "world-apply/" root)
                           +world-apply-cells+ :script :apply)
        :ambiguous (make-world (merge-pathnames "world-ambiguous/" root)
                               +world-ambiguous-cells+ :script :ambiguous)))

(defun journal-opening-authority (&key (table *act-fixture-table*))
  "F-GRANT / F-REVOKE — appended in setup, BEFORE F1 (act:binding-declared).
⚠ THE MINT IS NOT IN SETUP: it is contract step L3b, AFTER F1."
  (dolist (f table)
    (let ((seat (act-fixture-runtime-seat f))
          (terms (grant-terms-for f)))
      (append-event *store*
                    (make-grant-event
                     :event-id (list "cap0-event" (format nil "g-~a" seat))
                     :capability-id (capability-id-for f)
                     :subject (getf terms :subject) :action (getf terms :action)
                     :resource (getf terms :resource) :scope (getf terms :scope)
                     :issuer (idf +act-issuer+)))
      ;; arm B-R only: a Capability /0 revocation, after its grant and before F1.
      (when (string= (act-fixture-arm f) "B-R")
        (append-event *store*
                      (make-revocation-event
                       :event-id (list "cap0-event" (format nil "r-~a" seat))
                       :capability-id (capability-id-for f)
                       :issuer (idf +act-issuer+)))))))

;;; ===========================================================================
;;; §11 — run-act: L0..L22 for ONE arm.
;;; ===========================================================================

(defun office-l-capability (fixture normal-form)
  "L2.  Office L's capability is minted here and ONLY here.
⚠ The two control arms are minted through THE CONTROL DOOR, which BYPASSES
bind-offices: the strict path cannot reach their state, because BIND-3 forbids
it.  The controls exist precisely so that perform's own authority law is
EXERCISED and not merely present (specimen §2.4 F-FORM-BL1/BL2)."
  (ecase (act-fixture-authority-mode fixture)
    (:bound (bind-offices (grant-terms-for fixture)
                          (act-fixture-adapter-symbol fixture)
                          normal-form))
    (:wrong-predicate
     ;; the control door: a one-predicate ruling naming a predicate the request
     ;; does not carry.  ⚠ BIND-3's NARROWNESS conjunct (A-6, length 1, no
     ;; wildcard) HOLDS here; its IDENTITY conjunct is deliberately violated,
     ;; and that violation is what L9 must catch.
     (lisp-plus-core0:mint-capability
      :ruling (lisp-plus-core0:fixture-sealed-ruling
               :adapter-name (act-fixture-adapter-symbol fixture)
               :predicates '(:delere)
               :minter +bind-offices-minter+)))
    (:ambient nil)))                 ; :authority NIL => ambient-authority-forbidden

(defun bind-checks (fixture normal-form office-l cell-string)
  "BIND-1, BIND-2(a), BIND-2(c), BIND-3, BIND-5, BIND-6(i) — checked at L2.
⚠ BIND-2(b) IS NOT CHECKED HERE AND CANNOT BE: it reads the registry entry this
act's bridge object does not have until L3c-ii.  It is PRE-1, asserted at
L3c-iii, and recorded in F2 (A-5a, J-4a family 3).
Returns the Office L mint-receipt capability-id string for F1 (BIND-5)."
  (let ((terms (grant-terms-for fixture)))
    ;; BIND-1 — a STRING comparison against the PUBLIC RENDERING of the grant's
    ;; resource term.  No parsing, no re-segmentation, no assumption about the
    ;; separator (M-13-NO-PARSE).
    (unless (string= cell-string (identifier-segment-string (getf terms :resource)))
      (act-refuse 'act-authority-binding-refused "BIND-1"
                  ":cell ~s is not STRING= to the rendered grant resource ~s"
                  cell-string (identifier-segment-string (getf terms :resource))))
    ;; ⚑ BIND-3 IS TWO CONJUNCTS (R2.1 erratum, chair ruling 2 — adopted as
    ;; law at contract §2.4).  BIND-3n runs on EVERY arm; BIND-3i runs only
    ;; where the strict path runs, and the control arms' escape from it is
    ;; exactly what perform's L9 must catch.  A-5a's coverage enumeration is
    ;; amended to match, so the recorded "pass" covers exactly what ran.
    (when office-l
      (let ((predicates (getf (lisp-plus-core0:capability-scope office-l) :predicates)))
        ;; BIND-3n — THE NARROWNESS CONJUNCT.  Every arm, no exception.
        ;; A-6: one act, one predicate, one cell.
        (unless (= 1 (length predicates))
          (act-refuse 'act-authority-binding-refused "BIND-3n"
                      "the fixture ruling's predicate list is not length 1: ~s"
                      predicates))
        ;; BIND-3i — THE IDENTITY CONJUNCT.  Strict-path arms only.
        (when (eq :bound (act-fixture-authority-mode fixture))
          (unless (equal predicates (list (second normal-form)))
            (act-refuse 'act-authority-binding-refused "BIND-3i"
                        "the fixture ruling authorises ~s, not the request's ~s"
                        predicates (list (second normal-form)))))
        ;; BIND-2(a) — the fixture ruling's adapter-name is EQ to the SYMBOL
        ;; under which this act's bridge object will be registered.
        (unless (eq (getf (lisp-plus-core0:capability-scope office-l) :adapter)
                    (act-fixture-adapter-symbol fixture))
          (act-refuse 'act-authority-binding-refused "BIND-2a"
                      "the fixture ruling names adapter ~s, not ~s"
                      (getf (lisp-plus-core0:capability-scope office-l) :adapter)
                      (act-fixture-adapter-symbol fixture)))))
    ;; BIND-2(c) — the :adapter argument passed to perform is THAT SYMBOL,
    ;; never a core0-adapter object.  resolve-adapter passes a supplied OBJECT
    ;; straight through (core0.lisp:442-443) and the frontier check then
    ;; compares only the NAME (core0.lisp:345-350), so the object-argument
    ;; channel must be removed here.
    (unless (and (symbolp (act-fixture-adapter-symbol fixture))
                 (act-fixture-adapter-symbol fixture))
      (act-refuse 'act-authority-binding-refused "BIND-2c"
                  "the form's :adapter is not a symbol"))
    ;; BIND-5 — the Office L mint-receipt capability-id, read through the public
    ;; capability-mint-receipt-of (core0.lisp:292-295).
    (if office-l
        (durable-identity-name
         (lisp-plus-kernel0:capability-mint-receipt-capability-id
          (lisp-plus-core0:capability-mint-receipt-of office-l)))
        "none:ambient-authority-control")))

(defun make-act-record (fixture &key (lexis t) (register t))
  "L1b + L1c, together: canonicalize, render V-REQ, mint, and seal the ONE
IMMUTABLE ACT RECORD.
REGISTER NIL is for PURE RECOMPUTATION ONLY — a vector check or a cold read,
which is not an act and must not consume an identity in ACT-9b's run-local set.
An ACT always registers (that is the point of the set)."
  (let* ((resource (identifier-segment-string (getf (grant-terms-for fixture) :resource)))
         (nf (canonicalize-request (act-fixture-form fixture)
                                   :resource-rendering resource :lexis lexis))
         (req (request-record nf))
         (roct (oct req)))
    (multiple-value-bind (act-id digest) (mint-act-identity
                                          (act-fixture-runtime-seat fixture) roct
                                          :register register)
      (%make-act-record :fixture fixture :act-id act-id :act-id-hex digest
                        :normal-form nf :request-rec req :request-oct roct))))

(defun run-act (fixture &key (verbose t))
  "L0 is already discharged for the whole table; this is L1b..L22 for ONE arm.
Returns a plist describing what happened.  ⚠ IT NEVER ADJUSTS AN INPUT TO MAKE
AN OUTPUT COME OUT: every refusal propagates as its own typed condition."
  (let* ((f fixture)
         (seat (act-fixture-runtime-seat f))
         (attempt (act-fixture-attempt-name f))
         (record (make-act-record f))
         (terms (grant-terms-for f))
         (process (lisp-plus-core0:process-context
                   :label (act-fixture-language-label f)))
         (world (getf *worlds* (act-fixture-world-key f))))
    (when verbose
      (format t "~&~%---- ARM ~a (fixture label ~s — LEGIBILITY ONLY) ----~%"
              (act-fixture-arm f) (act-fixture-label f))
      (note "act-id ~a" (identifier-segment-string (act-record-act-id record))))
    ;; ---- L2: bind-offices, and the binding checks it covers.
    (let* ((nf (act-record-normal-form record))
           (office-l (office-l-capability f nf))
           (cell-string (second (assoc :cell (request-roles nf))))
           (cap-id (bind-checks f nf office-l cell-string)))
      ;; K-7a-1 SHAPE 2 — the seat scan, before F1.
      (seat-consumption-scan *store* seat)
      ;; ---- L3: ACT-8's prefix scan, then F1.
      (act-8-prefix-scan *store* (act-record-act-id record))
      (let ((f1 (build-f1 record
                          :grant-terms terms
                          :office-l-capability-id cap-id
                          :language-process (durable-identity-name
                                             (lisp-plus-core0:process-context-process-id process))
                          :language-seat (durable-identity-name
                                          (lisp-plus-core0:process-context-seat-id process))
                          :logical-operation (durable-identity-name
                                              (lisp-plus-core0:process-context-logical-operation-id process)))))
        (append-lane-frame *store* :f1 record f1)
        ;; BIND-4 / BIND-5, NON-VACUOUS: read F1 BACK out of the validated
        ;; prefix and compare.  ⚠ A RECORDING THAT IS NEVER READ BACK IS NOT A
        ;; BINDING; IT IS A HOPE WITH A FIELD NAME.
        (multiple-value-bind (ordinal digest payload)
            (find-event *store* (frame-event-id :f1 attempt))
          (declare (ignore digest))
          (unless ordinal
            (act-refuse 'act-frame-ordering-violated "BIND-4"
                        "F1 is not readable back out of the validated prefix"))
          (let* ((back (decode-pjs0 payload))
                 (body (record-field back "event" "body")))
            (dolist (pair '(("grant-subject" . :subject) ("grant-action" . :action)
                            ("grant-resource" . :resource) ("grant-scope" . :scope)))
              (unless (datum= (record-field body "act" (car pair))
                              (getf terms (cdr pair)))
                (act-refuse 'act-authority-binding-refused "BIND-4"
                            "F1's recorded ~a is not datum= to the declared term"
                            (car pair))))
            (unless (string= (lisp-plus-cd0:string-datum-value
                              (record-field body "act" "office-l-capability-id"))
                             cap-id)
              (act-refuse 'act-authority-binding-refused "BIND-5"
                          "F1's recorded office-l-capability-id is not the id read ~
from the LIVE Office L capability's mint receipt"))
            (when verbose (note "BIND-4/BIND-5 readback: pass (F1 at ordinal ~d)" ordinal))))
        ;; ---- L3b: THE PREFIX BINDING.  The Office R live capability is minted
        ;; ---- NOW, AFTER F1, so its four prefix facets are taken over the
        ;; ---- prefix D1 will present against (T2b-LAW, §4.1).
        ;;
        ;; ⚑ R2.1 ERRATUM — THE MINT CAN REFUSE BY NAME, AND THAT LEAVES AN
        ;; UNPAIRED F1 (contract J-2c).  Arm B-R DECLARES this shape; on any
        ;; arm that does NOT declare it the shape is a fault and STOPS THE
        ;; ROUND, which is the distinction specimen BR-11 exists to draw.
        (handler-case
        (let ((office-r
                (mint-from-authorization
                 *store* *bootstrap* *minting-context*
                 (query-live-authority *store* *bootstrap*
                                       :query-id (list "cap0-query"
                                                       (format nil "q-~a-mint" seat))
                                       :capability-id (capability-id-for f)
                                       :subject (getf terms :subject)
                                       :action (getf terms :action)
                                       :resource (getf terms :resource)
                                       :scope (getf terms :scope))
                 :minter (list "oneact0-minter" +runtime-process-name+))))
          ;; ---- L3c-i: the IMMUTABLE dispatch context.
          (let* ((context (%make-dispatch-context
                           :act-id (act-record-act-id record)
                           :normal-form nf :process process :seat-name seat
                           :attempt-name attempt
                           :cell-segments (act-fixture-cell-segments f)
                           :capability office-r :store *store* :world world
                           :bootstrap *bootstrap* :minting-context *minting-context*
                           :grant-terms terms :capability-id (capability-id-for f)
                           :interruption (act-fixture-interruption f)))
                 ;; ---- L3c-ii: the act's own bridge object, under its own symbol.
                 (bridge (make-lane-bridge (act-fixture-adapter-symbol f) context)))
            (lisp-plus-core0:register-adapter bridge)
            ;; ---- L3c-iii: PRE-1 and PRE-2, asserted AND PRINTED (M-3c).
            (let ((resolved (lisp-plus-core0:resolve-adapter
                             (act-fixture-adapter-symbol f))))
              (unless (eq resolved bridge)
                (act-refuse 'act-dispatcher-binding-refused "PRE-1"
                            "resolve-adapter returned ~s, not this act's bridge ~s"
                            resolved bridge))
              (when verbose (note "PRE-1 (eq resolved bridge) => T"))
              (unless (and (eq (lisp-plus-core0:core0-adapter-name resolved)
                               (act-fixture-adapter-symbol f))
                           (eql (lisp-plus-core0:core0-adapter-version resolved) 0))
                (act-refuse 'act-dispatcher-binding-refused "PRE-2"
                            "the resolved object's name/version do not equal the ~
fields Office L bound"))
              (when verbose (note "PRE-2 name/identity/version => equal")))
            ;; ---- L4..L17: THE ORIGINATING FORM IS EVALUATED, ONCE.
            (multiple-value-bind (outcome evidence disposition)
                (handler-case
                    (multiple-value-bind (o e)
                        (lisp-plus-core0:perform
                         :adapter (act-fixture-adapter-symbol f)
                         :request nf :authority office-l :process process)
                      (values o e :returned))
                  (lisp-plus-core0:core0-interrupted (c)
                    (values (lisp-plus-core0:core0-condition-outcome c)
                            (lisp-plus-core0:core0-condition-evidence c) :interrupted))
                  (lisp-plus-core0:core0-refused (c)
                    (values (lisp-plus-core0:core0-condition-outcome c)
                            (lisp-plus-core0:core0-condition-evidence c) :refused))
                  (act-bridge-contract-violated (c)
                    (declare (ignore c))
                    ;; M-9: NO Outcome, NO evidence.  The lane MUST NOT
                    ;; manufacture either.
                    (values nil nil :host-fault)))
              (multiple-value-bind (class standing)
                  (derive-lane-class *store* attempt disposition)
                (when (eq class :unclassifiable)
                  (act-refuse 'act-bridge-contract-violated "ACT-BRIDGE-1"
                              "standing ~s with disposition ~s is not a lawful ~
§3.3 class" standing disposition))
                (when verbose
                  (note "class ~a  standing ~s  disposition ~s" class standing disposition))
                (list :record record :class class :standing standing
                      :disposition disposition :outcome outcome :evidence evidence
                      :office-r office-r :context context :process process)))))
          ;; ---- the L3b mint refusing BY NAME.  F1 is already durable.
          (lisp-plus-capability1:cap1-condition (c)
            (unless (eq :unpaired-f1 (act-fixture-declared-shape f))
              ;; UNDECLARED on this arm ⇒ this is a fault, and contract J-2c's
              ;; sentence governs: the run STOPS and reports.  Re-signalled
              ;; unchanged, because the lane must not convert a fault into a
              ;; shape by catching it.
              (error c))
            (when verbose
              (note "L3b mint REFUSED: ~a [~a]" (type-of c) (condition-requirement-id c))
              (note "F1 stands alone — BINDING-DECLARED-UNPAIRED (J-2c, J-6)"))
            ;; ⚠ NOTHING IS APPENDED HERE.  No F2 with a fabricated attempt
            ;; identity, no synthesised F5, no manufactured Outcome.  A pre-act
            ;; failure needs no attempt identity (ACT-11, owner ruling OR-7),
            ;; and a lane that invents one has forged the very join the frames
            ;; exist to provide.
            (list :record record :class :unpaired-f1 :standing :absent
                  :disposition :mint-refused :outcome nil :evidence nil
                  :office-r nil :context nil :process process
                  :refusal-type (type-of c)
                  :refusal-requirement-id (condition-requirement-id c))))))))

;;; ===========================================================================
;;; §12 — L18..L22: the post-disposition frame, the reconciliation pair, the
;;; readback, and the agreement gate.
;;; ===========================================================================

(defun harvested (evidence reader)
  "Harvest from the evidence account, or the TYPED ABSENCE on Class D.
⚠ M-9: on a host fault NO Outcome and NO evidence exist, and the lane MUST NOT
manufacture either — so the absence is RECORDED, never filled in."
  (if evidence (durable-identity-name (funcall reader evidence)) "no-outcome-host-fault"))

(defun outcome-fields (outcome)
  "(values view effect-value effect-determinacy), each a STRING.  On an arm
where Core /0 produces no Outcome the three carry the typed absence."
  (if (null outcome)
      (values "no-outcome-host-fault" "no-outcome-host-fault" "no-outcome-host-fault")
      (let ((eff (lisp-plus-kernel0:outcome-axis outcome :effects)))
        (values (symbol-name (lisp-plus-core0:outcome-kind outcome))
                (symbol-name (lisp-plus-kernel0:axis-value eff))
                (symbol-name (lisp-plus-kernel0:determinacy-mode
                              (lisp-plus-kernel0:axis-determinacy eff)))))))

(defun namespace-absence-check (store seat)
  "N-6a, PER ARM and not once at setup.  derive-seat-outcome probes the
\"ap0-event\" namespace UNCONDITIONALLY in addition to its :namespace argument
(surface2.lisp:1127); a hit sets provenance :live and evidence-class
:projection, SILENTLY RECLASSIFYING EVERY FACET and invalidating each of O-5's
asserted absences.  Returns T, or refuses naming the colliding event id."
  (let ((report (validate-journal store)))
    (let ((ids (prefix-report-event-ids report)))
      (loop for i below (fill-pointer ids)
            for rendered = (identifier-segment-string (aref ids i))
            do (dolist (ns '("ap0-event" "vertical-event"))
                 (let ((prefix (format nil "~a:e-~a-" ns seat)))
                   (when (and (>= (length rendered) (length prefix))
                              (string= prefix (subseq rendered 0 (length prefix))))
                     (act-refuse 'act-readback-disagreement "N-6a"
                                 "a ~a frame for seat ~a is in the validated ~
prefix: ~a" ns seat rendered)))))))
  t)

(defparameter +o5-expected+
  '((:manifestation      . "absent-or-absent-from-evidence")
    (:no-payload-state   . "absent-from-evidence")
    (:provenance         . "none")
    (:chunks-preserved   . "not-applicable-or-present")
    (:refusal            . "absent-from-evidence")
    (:interpretation-class . "not-interpreted-or-present"))
  "O-5's six facets.  ⚠ THESE ARE ASSERTED, NEVER IGNORED: they are absent BY
CONSTRUCTION, because this lane journals no vertical-event-family frames.  If a
successor lane starts minting them the gate must BREAK LOUDLY rather than drift
silently.  A GATE THAT IGNORES WHAT IT EXPECTS TO BE ABSENT IS NOT A GATE.")

(defparameter +o5-standing-key+
  '((:manifestation . :manifestation) (:no-payload-state . :no-payload-state)
    (:provenance . :provenance) (:chunks-preserved . :chunks-preserved)
    (:refusal . :refusal) (:interpretation-class . :interpretation))
  "⚠ O-5 NAMES ITS FACETS AS THE CONTRACT DOES; Surface /2's field-standings
plist keys them slightly differently — its key for the interpretation facet is
`:interpretation`, not `:interpretation-class` (surface2.lisp:1228-1230), and
`:provenance` is one of its ALWAYS-PRESENT facets (surface2.lisp:990-991).  The
mapping is declared here rather than discovered at the call site, because a
facet the reader cannot name is a facet the gate cannot assert.")

(defun assert-o5-facets (outcome)
  "Returns the plist F5 records: facet -> the asserted string."
  (let ((out '()))
    (dolist (facet +o5-facets+ (nreverse out))
      (let* ((standing (lisp-plus-surface2:seat-outcome-field-standing
                        outcome (cdr (assoc facet +o5-standing-key+))))
             (value (ecase facet
                      (:manifestation (lisp-plus-surface2:seat-outcome-manifestation outcome))
                      (:no-payload-state (lisp-plus-surface2:seat-outcome-no-payload-state outcome))
                      (:provenance (lisp-plus-surface2:seat-outcome-provenance outcome))
                      (:chunks-preserved (lisp-plus-surface2:seat-outcome-chunks-preserved outcome))
                      (:refusal (lisp-plus-surface2:seat-outcome-refusal outcome))
                      (:interpretation-class
                       (lisp-plus-surface2:seat-outcome-interpretation-class outcome)))))
        (setf out (list* (format nil "~a/~a"
                                 (if (stringp value) value
                                     (string-downcase (princ-to-string value)))
                                 (string-downcase (symbol-name standing)))
                         facet out))))))

(defun agreement-row-for (class phase)
  (ecase class
    (:a "A") (:b "B") (:c-i (ecase phase (:pre "C-i") (:post "C-reconciled")))
    (:c-ii (ecase phase (:pre "C-ii-pre") (:declared "C-ii-post") (:post "C-reconciled")))
    (:d "D-pre")))

(defun finish-act (result &key (verbose t))
  "L18..L22 for an arm that reached `perform`.  Appends F2, then F3/F4 on the
Class-C arms, then the readback and F5."
  (let* ((record (getf result :record))
         (f (act-record-fixture record))
         (seat (act-fixture-runtime-seat f))
         (attempt (act-fixture-attempt-name f))
         (class (getf result :class))
         (evidence (getf result :evidence))
         (outcome (getf result :outcome))
         (office-r (getf result :office-r))
         (act-id (read-act-id-from-store *store* record)))
    ;; ---- BIND-6's observed-vs-declared check, before F2's append.
    (when evidence
      (let ((observed-seat (durable-identity-name
                            (lisp-plus-core0:core0-evidence-seat-id evidence)))
            (declared-seat (durable-identity-name
                            (lisp-plus-core0:process-context-seat-id
                             (getf result :process)))))
        (unless (string= observed-seat declared-seat)
          (act-refuse 'act-process-identity-divergence "BIND-6"
                      "observed language seat ~s diverges from F1's declared ~s"
                      observed-seat declared-seat))))
    ;; ---- J-4b: the four terms of the capability presented at D1 must be
    ;; ---- datum= to the four terms F1 recorded.  THE JOIN THAT MAKES F1 AND
    ;; ---- F2 ONE BINDING RECORD RATHER THAN TWO UNRELATED FRAMES.
    (when office-r
      (let ((terms (grant-terms-for f)))
        (dolist (pair '((:subject . live-capability-subject)
                        (:action . live-capability-action)
                        (:resource . live-capability-resource)
                        (:scope . live-capability-scope)))
          (unless (datum= (funcall (find-symbol (symbol-name (cdr pair))
                                                :lisp-plus-capability1)
                                   office-r)
                          (getf terms (car pair)))
            (act-refuse 'act-office-r-term-divergence "J-4b"
                        "the presented capability's ~a is not datum= to F1's ~
recorded grant term" (car pair))))))
    ;; ---- L18: F2.
    (multiple-value-bind (view eff-value eff-det) (outcome-fields outcome)
      (append-lane-frame
       *store* :f2 record
       (build-f2 record
                 :act-id-from-store act-id
                 :language-attempt-id (harvested evidence #'lisp-plus-core0:core0-evidence-attempt-id)
                 :language-process-observed
                 (if evidence (durable-identity-name
                               (lisp-plus-core0:process-context-process-id
                                (lisp-plus-core0:core0-evidence-process evidence)))
                     "no-outcome-host-fault")
                 :language-seat-observed
                 (harvested evidence #'lisp-plus-core0:core0-evidence-seat-id)
                 ;; J-4-OR3: EXPLICIT, REQUIRED, never absent, never NIL-punned.
                 :frontier (if (eq class :b) "NOT-CROSSED" "CROSSED")
                 :office-r-public-id (if office-r (live-capability-public-id office-r)
                                         (idf '("none" "no-outcome-host-fault")))
                 :office-r-occurrence-id (if office-r (live-capability-occurrence-id office-r)
                                             (idf '("none" "no-outcome-host-fault")))
                 :outcome-view view :effect-axis-value eff-value
                 :effect-axis-determinacy eff-det))
      (when verbose (note "F2 appended (frontier ~a, view ~a)"
                          (if (eq class :b) "NOT-CROSSED" "CROSSED") view)))
    ;; ---- L19/L20: the Class-C reconciliation pair.
    (let ((phase :pre) (corr-verdict nil) (corr-row nil))
      (when (member class '(:c-i :c-ii))
        ;; C-ii: structure the uncertainty FIRST (its standing is
        ;; :crossed-unsettled; cap2 already journaled C-i's).
        (when (eq class :c-ii)
          (declare-uncertain-effect *store* attempt :process-name +runtime-process-name+)
          (setf phase :declared)
          (when verbose (note "declare-uncertain-effect ran (C-ii)")))
        ;; THE LANGUAGE-SIDE READ IS FROZEN FIRST (contract R-6, J-4).
        (let* ((answer (lane-ledger-query (getf result :context)))
               (ledger-answer (if (eq (second answer) :committed)
                                  "ANSWERED-COMMITTED" "ANSWERED-NOT-COMMITTED")))
          (append-lane-frame
           *store* :f3 record
           (build-f3 record :act-id-from-store act-id
                            :continuation-disposition "INDETERMINATE"
                            :required-action "RECONCILE-BEFORE-ANY-RETRY"
                            :ledger-answer ledger-answer))
          (when verbose (note "F3 frozen BEFORE the runtime reconciliation (~a)" ledger-answer))
          ;; L20: the runtime reconciliation, then F4.
          (let ((resolution (nth-value 0 (reconcile-uncertain-effect
                                          *store* (getf *worlds* (act-fixture-world-key f))
                                          attempt :process-name +runtime-process-name+))))
            (multiple-value-setq (corr-verdict corr-row)
              (correspondence-verdict ledger-answer resolution))
            (append-lane-frame
             *store* :f4 record
             (build-f4 record :act-id-from-store act-id
                              :runtime-resolution (symbol-name resolution)
                              :correspondence-row corr-row
                              :correspondence-verdict corr-verdict))
            (setf phase :post)
            (when verbose
              (note "F4: runtime ~s · row ~a · verdict ~a" resolution corr-row corr-verdict)))))
      ;; ---- L21: the readback, the agreement gate, F5.
      (namespace-absence-check *store* seat)
      (let* ((events (lisp-plus-surface2:validated-store-events *store*))
             (so (lisp-plus-surface2:derive-seat-outcome *store* events seat))
             (standing (lisp-plus-surface2:seat-outcome-execution-standing so))
             (eclass (lisp-plus-surface2:seat-outcome-evidence-class so))
             (row (agreement-row-for class phase)))
        (multiple-value-bind (view eff-value) (outcome-fields outcome)
          (multiple-value-bind (verdict) (agreement-gate row view eff-value standing eclass)
            (when verbose
              (note "readback: standing ~s evidence-class ~s · row ~a · verdict ~a"
                    standing eclass row verdict))
            (append-lane-frame
             *store* :f5 record
             (build-f5 record :act-id-from-store act-id
                              :execution-standing (symbol-name standing)
                              :evidence-class (symbol-name eclass)
                              :mapping-row row :agreement-verdict verdict
                              :absent-facets (assert-o5-facets so)))
            ;; O-8: a DISAGREE verdict is a FINDING, not an error to be repaired
            ;; by adjusting the table.  Neither standing is promoted, demoted,
            ;; corrected, or averaged.
            (unless (string= verdict "agree")
              (act-refuse 'act-readback-disagreement "O-8"
                          "arm ~a row ~a: ~a/~a vs ~s/~s"
                          (act-fixture-arm f) row view eff-value standing eclass))
            (list :class class :row row :verdict verdict :standing standing
                  :evidence-class eclass :correspondence corr-verdict)))))))
