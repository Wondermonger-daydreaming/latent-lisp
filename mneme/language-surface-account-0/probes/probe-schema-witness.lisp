;;;; probe-schema-witness.lisp
;;;;
;;;; ==========================================================================
;;;; NON-PRODUCTION FEASIBILITY PROBE — Surface Account /0 opening round —
;;;; not a package, not an API, not loadable as part of any system.
;;;; ==========================================================================
;;;;
;;;; THE CD/0 INSPECTION-RECORD SCHEMA WITNESS — section SCHEMA-WITNESS.
;;;;
;;;; Built from CD0-INSPECTION-RECORD-SCHEMA.md alone (the R2 adjudication's
;;;; section A).  It CONSTRUCTS one instance of every one of the five branches
;;;; through the accepted PUBLIC CD/0 API and proves, per §8 of that file:
;;;;
;;;;     datum-p · encode/decode round trip · canonical re-encoding equality ·
;;;;     the exact key set · the exact value-datum species ·
;;;;     the inspector's output is NOT re-admitted
;;;;
;;;; THE BOUNDARY, unchanged from every other file here.  No package is
;;;; defined.  No Account /0 object is minted — an inspection record is an
;;;; INERT CD/0 RECORD DATUM, which is exactly why it can be built with public
;;;; constructors and nothing else.  The two providers are touched only through
;;;; QUALIFIED EXTERNAL SYMBOLS, and only because §§4 and §6 require NATIVE
;;;; DATUM SAMPLES: a receipt branch whose native pass-through values were
;;;; invented would prove nothing about pass-through.  Nothing is evaluated,
;;;; compiled or executed beyond the providers' own public doors.
;;;;
;;;; THE DOC/MEASUREMENT AGREEMENT, AND THE TOOTH THAT KEEPS IT.
;;;; The R2 witness first measured twelve keys whose native value is a CD/0
;;;; **BYTES** datum where §§4–5 said "identifier datum" — the five identity
;;;; keys of each receipt branch and the refusal-identity of each refusal
;;;; branch.  The schema file's erratum has since recorded all twelve as bytes
;;;; datums (occurrence-tag and construct-identity were NOT in that set: they
;;;; are measured as identifier datums and the file always said so).  The two
;;;; columns therefore now AGREE, and the expected deviation count is ZERO.
;;;;
;;;; THE DETECTOR IS KEPT, AND IT IS A STANDING TOOTH, NOT A HISTORICAL NOTE.
;;;; It compares, key by key, what this probe MEASURES against what the schema
;;;; file DECLARES, and the check asserts the count is exactly zero — so the
;;;; day either column moves without the other, the gate fires.  A zero from a
;;;; detector that has never fired would be worth nothing, so a PLANTED arm
;;;; feeds it a deliberately mis-declared spec in the same image and shows it
;;;; reporting the disagreement.
;;;;
;;;; §6's substantive law is independent of all this and is what the
;;;; pass-through checks test: whatever family the native datum has, the record
;;;; carries THAT VERY DATUM, byte-equal under canonical-octets.
;;;;
;;;; WHAT R3-A CHANGED HERE, and each item is a defect the R2 witness carried:
;;;;
;;;;   1. THE PREDICATE COMPARED NAME FRAGMENTS.  It read one path segment out
;;;;      of each key and compared strings, so a key in a neighbouring
;;;;      namespace, a key with the path head "kee", and a key with a surplus
;;;;      third path segment were all ACCEPTED.  ACCOUNT-INSPECTION-RECORD-P is
;;;;      now the full-exactness comparison of schema file section 7, and each
;;;;      of those three deviations has its own tooth.
;;;;   2. NO ENUM VALUE WAS EVER CHECKED.  Only datum FAMILIES were compared,
;;;;      so an unknown standing, an unknown code, a wrong schema version, a
;;;;      wrong species and a code paired with the wrong phase all passed.  The
;;;;      closed sets are now transcribed from the schema file and enforced.
;;;;   3. THE COMPOSITE CODE WAS THE WRONG WORD.  The witness spelled Door 1's
;;;;      code "not-a-manifest-head"; the ruled spelling is
;;;;      "head-not-in-manifest", and the withdrawn R2 spelling is now planted
;;;;      as a tooth and shown FAILING rather than quietly replaced.  (R3 ALSO
;;;;      consolidated Door 1 into that one code.  THAT PART IS REJECTED — see
;;;;      the R3.1 list below — and the sentence that stood here saying so is
;;;;      corrected rather than deleted, because the consolidation was carried
;;;;      in this file for a whole round.)
;;;;   4. TWO NATIVE CLASSES COULD NOT BE ENCODED AT ALL.  An S2
;;;;      :protocol-refusal/:expansion object and an S2 :integrity-alarm object
;;;;      had no branch.  Both are now minted through S2's OWN PUBLIC DOORS and
;;;;      encoded as lawful s2-refusal records — positive teeth, not refusals.
;;;;   5. DERIVED STANDING WAS A CONSTANT.  Both refusal bodies wrote
;;;;      "pre-invocation" literally.  It is now looked up PER CODE in the
;;;;      total table, and a code with no row is an error rather than a
;;;;      default — with a tooth for a standing that contradicts its row.
;;;;   6. THE ENUMERATIONS ARE CHECKED AGAINST THE PROVIDERS THEMSELVES.  A
;;;;      hand-transcribed "total" set is a claim about a document; both
;;;;      providers publish their catalogues, so the two are compared and the
;;;;      difference must be empty in both directions.
;;;;
;;;; WHAT R3.1 CHANGED HERE, and each item is a defect THIS file carried:
;;;;
;;;;   1. DOOR-1 OWNERSHIP IS RESTORED.  R3's consolidation of every Door-1
;;;;      failure into head-not-in-manifest was uncommissioned and is rejected.
;;;;      The retainable composite set is FIVE codes — four Account-owned Door-1
;;;;      codes at phase request, plus Door 2's wrong-request-species at phase
;;;;      perform — and all five are shown RECOGNIZED, each only with its ruled
;;;;      phase, with every crossed pairing refused.
;;;;   2. THE S1 DISPOSITION VOCABULARY CARRIED AN INVENTED NAME.  R3's table
;;;;      listed MACROEXPANDED-TO-FIXPOINT, which is in NEITHER provider
;;;;      (surface1.lisp:884-885 declares exactly two).  It is deleted, and the
;;;;      name it used to admit is planted as a tooth.  The operation/disposition
;;;;      PAIRINGS are now enforced on both providers: a conformant operation and
;;;;      a conformant disposition are not jointly conformant.
;;;;   3. THE UPSTREAM UNION ADMITTED EVERY STANDING.  Its test was
;;;;      STANDING-VALUE-P — the whole closed nine-name set — where the schema
;;;;      declares a THREE-MEMBER union whose only standing is measured-nil.
;;;;      Eight unlawful standings are now planted and refused.
;;;;   4. NO DETAIL VALUE WAS EVER VALIDATED, and the R3 law promised a record
;;;;      for every admitted object — one stage too strong.  The two-stage total
;;;;      decision law is implemented here: species admission, then either one
;;;;      exact record or one of three typed Account codes, with NO raw host or
;;;;      CD/0 condition escaping.
;;;;   5. THE MANIFEST VERSION WAS ONLY "AN INTEGER DATUM", so version 2 passed.
;;;;      It is now exactly 1.
;;;;   6. THE TWO LOCKED S1 STOP CELLS WERE NEVER ENCODED, so the string-valued
;;;;      member of the upstream union was declared and never built.  Both are
;;;;      now DRIVEN through the native S1 machine under :MACROEXPAND and their
;;;;      real retained refusals projected, carrying their three measured
;;;;      string-valued upstream fields.

(in-package #:cl-user)

;;; ==========================================================================
;;; §1 — the identifier conventions, verbatim from the schema file.
;;; ==========================================================================

(defparameter *account-namespace* '("lisp-plus-surface-account"))

(defun a-key      (name) (lisp-plus-cd0:make-identifier-datum *account-namespace* (list "key" name)))
(defun a-schema   ()     (lisp-plus-cd0:make-identifier-datum *account-namespace* '("schema" "account-inspection-record")))
(defun a-species  (name) (lisp-plus-cd0:make-identifier-datum *account-namespace* (list "species" name)))
(defun a-standing (name) (lisp-plus-cd0:make-identifier-datum *account-namespace* (list "standing" name)))
(defun a-keyword  (kw)   (lisp-plus-cd0:make-identifier-datum *account-namespace* (list "keyword" (symbol-name kw))))
(defun a-code     (name) (lisp-plus-cd0:make-identifier-datum *account-namespace* (list "code" name)))
(defun a-phase    (name) (lisp-plus-cd0:make-identifier-datum *account-namespace* (list "phase" name)))
(defun a-manifest ()     (lisp-plus-cd0:make-identifier-datum *account-namespace* '("manifest")))

;;; §2 — the detail-string ceiling.  1024 canonical payload octets, and above
;;; it an Account-owned CONSTRUCTOR-VALIDATION REFUSAL — never truncation.
(defparameter *detail-ceiling-octets* 1024)

;;; --------------------------------------------------------------------------
;;; R3.1 — THE TWO-STAGE TOTAL DECISION LAW, on the one field that carries it.
;;;
;;; R3 said "every admitted object unconditionally yields a record", which was
;;; one stage too strong: the provider predicates admit refusal objects whose
;;; DETAIL the Account cannot necessarily encode, and a law that promises a
;;; record for every one of them promises something the encoder cannot keep.
;;; The owner disposition replaces it with:
;;;
;;;   1. SPECIES ADMISSION uses the five exact public predicates;
;;;   2. PROJECTION returns EITHER one exact successful record OR one typed
;;;      Account protocol refusal from Account field validation.
;;;
;;; and NO RAW HOST OR CD/0 CONDITION MAY ESCAPE.  That last clause is why the
;;; construction below happens inside a HANDLER-CASE over CONDITION: the honest
;;; way to ask "can CD/0 represent this as a scalar string datum" is to ASK CD/0,
;;; and the honest way to keep its answer from escaping as a raw condition is to
;;; catch it here and return a typed Account code instead.
;;;
;;; THE THREE CODES, and the ORDER, which is itself a claim:
;;;   NIL                        -> NOT a failure; encodes as standing/measured-nil
;;;   a non-NIL, non-string      -> :native-detail-not-string
;;;   a string CD/0 refuses      -> :native-detail-not-cd0-scalar-string
;;;   a representable string >1024 payload octets -> :detail-string-exceeds-ceiling
;;;
;;; HONEST LIMIT OF THE THIRD/SECOND ORDERING, stated rather than hidden: the
;;; representability question is answered by attempting the construction, so a
;;; string that CD/0 refuses for a reason OTHER than a non-scalar code point —
;;; a string beyond CD/0's own single-string budget, for instance — would also
;;; be reported as :native-detail-not-cd0-scalar-string.  At this ceiling (1024)
;;; and with the default budget the two cases do not overlap, and the teeth
;;; exercise each mechanism separately: a surrogate code point for the second
;;; code and a 1025-octet ASCII string for the third.
;;; --------------------------------------------------------------------------

(defun string-datum-payload-octets (d)
  "The payload octet count of a CD/0 string datum, measured through the public
accessor.  The datum's value is a valid scalar string by construction, so the
host encoder cannot fail on it."
  (length (sb-ext:string-to-octets (lisp-plus-cd0:string-datum-value d)
                                   :external-format :utf-8)))

(defun a-detail (value)
  "Stage 2 of the total decision law, on the detail field.  Returns
(values datum nil) for an admitted value and (values nil code) for each of the
three Account-owned validation codes.  Above the ceiling NO DATUM AT ALL is
produced: a truncated detail would be a lossy datum, and this schema
manufactures no lossy datum."
  (cond
    ((null value) (values (a-standing "measured-nil") nil))
    ((not (stringp value)) (values nil :native-detail-not-string))
    (t
     (let ((datum (handler-case (lisp-plus-cd0:make-string-datum value)
                    (condition () nil))))
       (cond ((null datum) (values nil :native-detail-not-cd0-scalar-string))
             ((> (string-datum-payload-octets datum) *detail-ceiling-octets*)
              (values nil :detail-string-exceeds-ceiling))
             (t (values datum nil)))))))

;;; ==========================================================================
;;; §3 — the common envelope: exactly four keys, no optional key anywhere.
;;; ==========================================================================

(defparameter *envelope-keys* '("body" "schema-identity" "schema-version" "species"))
(defparameter *schema-version* 1)

(defun build-envelope (species body)
  (lisp-plus-cd0:make-record-datum
   (list (lisp-plus-cd0:make-record-entry (a-key "schema-identity") (a-schema))
         (lisp-plus-cd0:make-record-entry (a-key "schema-version")  (lisp-plus-cd0:make-integer-datum *schema-version*))
         (lisp-plus-cd0:make-record-entry (a-key "species")         (a-species species))
         (lisp-plus-cd0:make-record-entry (a-key "body")            body))))

(defun build-body (pairs)
  "PAIRS is an ordered alist of (key-name . value-datum).  CD/0's canonical key
sorting is authoritative: the order here is the order of the SPEC, never a
claim about physical position."
  (lisp-plus-cd0:make-record-datum
   (mapcar (lambda (p) (lisp-plus-cd0:make-record-entry (a-key (car p)) (cdr p))) pairs)))

(defun body-replacing (body replacements)
  "A copy of BODY whose key set is IDENTICAL and in which exactly the named keys
carry new values.  REPLACEMENTS is an alist of (key-name . value-datum).  Every
adversarial tooth below is built this way so that the deviation is exactly one
VALUE and no key, count or family moves with it."
  (build-body
   (loop for i from 0 below (lisp-plus-cd0:record-datum-size body)
         for k = (lisp-plus-cd0:record-datum-key-at body i)
         for name = (lisp-plus-cd0:identifier-datum-path-segment k 1)
         for hit = (assoc name replacements :test #'string=)
         collect (cons name (if hit (cdr hit) (lisp-plus-cd0:record-datum-value-at body i))))))

;;; --------------------------------------------------------------------------
;;; Reading a built record back through the public accessors only.
;;; --------------------------------------------------------------------------

(defun record-key-names (record)
  (sort (loop for i from 0 below (lisp-plus-cd0:record-datum-size record)
              collect (let ((k (lisp-plus-cd0:record-datum-key-at record i)))
                        (lisp-plus-cd0:identifier-datum-path-segment k 1)))
        #'string<))

(defun record-value-named (record name)
  (loop for i from 0 below (lisp-plus-cd0:record-datum-size record)
        for k = (lisp-plus-cd0:record-datum-key-at record i)
        when (string= name (lisp-plus-cd0:identifier-datum-path-segment k 1))
          do (return (lisp-plus-cd0:record-datum-value-at record i))))

(defun family-of (datum)
  (if (lisp-plus-cd0:datum-p datum) (lisp-plus-cd0:datum-family datum) :NOT-A-DATUM))

(defun same-key-set-p (record names)
  (equal (record-key-names record) (sort (copy-list names) #'string<)))

;;; ==========================================================================
;;; THE BRANCH SPECIFICATIONS.
;;;
;;; Each row is (KEY-NAME MEASURED-FAMILY DOC-FAMILY NATIVE-PASS-THROUGH-P).
;;; MEASURED-FAMILY is what this probe asserts.  DOC-FAMILY is what
;;; CD0-INSPECTION-RECORD-SCHEMA.md §§4–5 states.  Where they disagree the
;;; disagreement is PRINTED and COUNTED; it is never quietly reconciled.
;;; ==========================================================================

(defparameter *s1-receipt-spec*
  '(("receipt-identity"             :bytes      :bytes      t)
    ("request-identity"             :bytes      :bytes      t)
    ("occurrence-identity"          :bytes      :bytes      t)
    ("occurrence-tag"               :identifier :identifier t)
    ("source-datum"                 :record     :record     t)
    ("source-identity"              :bytes      :bytes      t)
    ("expanded-datum"               :record     :record     t)
    ("expanded-identity"            :bytes      :bytes      t)
    ("construct-identity"           :identifier :identifier t)
    ("expansion-context"            :record     :record     t)
    ("operation"                    :identifier :identifier nil)
    ("disposition"                  :identifier :identifier nil)
    ("stored-grammar-version"       :integer    :integer    nil)
    ("stored-procedure-version"     :integer    :integer    nil)
    ("stored-policy-version"        :integer    :integer    nil)
    ("grammar-identity-standing"    :identifier :identifier nil)
    ("verifier-availability"        :identifier :identifier nil)
    ("temporal-uniqueness-standing" :identifier :identifier nil)))

;;; §4.2: as §4.1 with exactly three differences, one of which is a SPECIES
;;; difference — S2's disposition is a STRING datum, S1's is a keyword
;;; identifier.  The key set is identical.
(defparameter *s2-receipt-spec*
  (mapcar (lambda (row)
            (if (string= (first row) "disposition")
                (list "disposition" :string :string nil)
                row))
          *s1-receipt-spec*))

;;; R3.1 NOTE ON THE :UNION ROWS.  Two keys have a DECLARED UNION shape, and a
;;; single-family cell cannot state it.  The R3 table wrote :identifier for the
;;; three upstream keys and :string for detail because those were the ONE
;;; variant that witness happened to build — the measured NIL, and a native
;;; detail string.  That is a description of a sample, not of the schema: the
;;; upstream keys are section 5.1's closed three-member union (measured-nil, a
;;; native keyword, a scalar string) and detail is R3.1's closed two-member
;;; union (a scalar string at or below the ceiling, or measured-nil).  Both
;;; columns now say :union, VALUE-SPECIES-OK-P tests the union rather than a
;;; family, and the STOP-cell records below actually exercise the string-valued
;;; upstream variant.
(defparameter *s1-refusal-spec*
  '(("refusal-identity"   :bytes      :bytes      t)
    ("category"           :identifier :identifier nil)
    ("code"               :identifier :identifier nil)
    ("phase"              :identifier :identifier nil)
    ("detail"             :union      :union      nil)
    ("upstream-category"  :union      :union      nil)
    ("upstream-code"      :union      :union      nil)
    ("upstream-stage"     :union      :union      nil)
    ("derived-standing"   :identifier :identifier nil)))

(defparameter *s2-refusal-spec*
  '(("refusal-identity"   :bytes      :bytes      t)
    ("category"           :identifier :identifier nil)
    ("code"               :identifier :identifier nil)
    ("phase"              :identifier :identifier nil)
    ("detail"             :union      :union      nil)
    ("derived-standing"   :identifier :identifier nil)))

(defparameter *composite-refusal-spec*
  '(("refusal-code"       :identifier :identifier nil)
    ("phase"              :identifier :identifier nil)
    ("detail"             :string     :string     nil)
    ("manifest-identity"  :identifier :identifier nil)
    ("manifest-version"   :integer    :integer    nil)
    ("derived-standing"   :identifier :identifier nil)))

(defparameter *doc-deviations* nil
  "Printed before it is counted (the canary must be printed): a discarded read
can be optimized away and the tooth would then silently never fire.")

(defun deviations-in (branch spec)
  "THE DETECTOR, pure: every row whose MEASURED species disagrees with the
species CD0-INSPECTION-RECORD-SCHEMA.md DECLARES.  Returns a list and touches no
global, so the planted arm can exercise it without contaminating the real count."
  (let ((found nil))
    (dolist (row spec (nreverse found))
      (destructuring-bind (name measured doc &optional native) row
        (declare (ignore native))
        (unless (eq measured doc)
          (push (list branch name doc measured) found))))))

(defun report-doc-deviations (branch spec)
  (dolist (d (deviations-in branch spec))
    (push d *doc-deviations*)
    (p "  SCHEMA-DOC-DEVIATION ~A ~A doc=~A measured=~A"
       (first d) (second d) (third d) (fourth d))))

;;; ==========================================================================
;;; §7 — THE FULL-EXACTNESS COMPARISON LAW (R3-A).
;;;
;;; WHAT WAS WRONG WITH THE R2 PREDICATE, said plainly because it is why this
;;; block was rewritten.  R2 compared KEY NAMES — it read
;;; identifier-datum-path-segment 1 out of each key and compared the resulting
;;; strings.  A key whose namespace was ("lisp-plus-surface-account-x"), or
;;; whose path head was "kee" instead of "key", or which carried a THIRD path
;;; segment, produced the same name fragment and was accepted.  It also never
;;; looked at any ENUM VALUE at all: an unknown standing, an unknown native
;;; code, a composite code paired with the wrong phase, a wrong schema version
;;; or a wrong species value all passed, because only datum FAMILIES were
;;; checked.  R3-A rules the comparison exact in six respects, and this is it.
;;;
;;; ACCOUNT-INSPECTION-RECORD-P is written here, not imported, because no
;;; Account package exists to import it from — and its separable obligations
;;; are kept as separate predicates so that each can be shown REFUSING.
;;; ==========================================================================

;;; ---- §2's closed standing set -------------------------------------------
(defparameter *standing-names*
  '("not-claimed" "pre-invocation" "invoked-no-completion-account" "measured-nil"
    "unavailable-no-public-accessor" "no-public-verifier"
    "public-verifier-exists-output-not-carried" "absent-no-public-antecedent"
    "not-applicable"))

;;; ---- §3's closed species set --------------------------------------------
(defparameter *species-names*
  '("s1-receipt" "s1-refusal" "s2-receipt" "s2-refusal" "composite-refusal"))

;;; ---- §5.3's closed FIVE-code set, WITH its per-code phase pairing --------
;;; R3.1 OWNER DISPOSITION — DOOR-1 OWNERSHIP RESTORED.  R3 consolidated every
;;; Door-1 failure into head-not-in-manifest; that consolidation was
;;; uncommissioned and is REJECTED.  Door 1 validates FORM SHAPE, OPERATION
;;; MEMBERSHIP and EXACT EQ MANIFEST MEMBERSHIP, all Account-owned, so its four
;;; codes come back — with the corrected spelling head-not-in-manifest kept.
;;; Only OCCURRENCE-TAG validation moves to the selected native delegate, which
;;; returns its own provider-owned refusal unchanged and therefore never appears
;;; in this key.  Door 2 contributes wrong-request-species, phase perform.
;;;
;;; A code is not conformant on its own: it must appear with its ruled phase, so
;;; the pairing is the datum here, not two separate lists.
(defparameter *composite-code-phases*
  '(("source-form-not-a-call"        . "request")
    ("source-form-head-not-a-symbol" . "request")
    ("head-not-in-manifest"          . "request")
    ("operation-not-declared"        . "request")
    ("wrong-request-species"         . "perform")))

;;; ---- the /0 manifest version, exactly (R3.1-A clause 6) ------------------
(defparameter *manifest-version* 1)

;;; ---- §4's declared operations -------------------------------------------
(defparameter *operation-names* '("MACROEXPAND-1" "MACROEXPAND"))

;;; ---- §4's EXACT operation/disposition pairings (R3.1-A clause 10) --------
;;; MEASURED, not transcribed from prose: S1's vocabulary is
;;; %OPERATION-DISPOSITION at surface1.lisp:884-885 and S2's at
;;; surface2.lisp:272-273, both read this round.  R3's table carried a THIRD S1
;;; name, MACROEXPANDED-TO-FIXPOINT, which appears in NEITHER provider — it was
;;; invented, R3.1-A deletes it from the S1 vocabulary, and it is planted below
;;; as an invented-disposition tooth rather than quietly dropped.  A conformant
;;; operation and a conformant disposition are NOT jointly conformant: the pair
;;; is the unit.
(defparameter *s1-op-dispositions*
  '(("MACROEXPAND-1" . "MACROEXPANDED-ONE-STEP")
    ("MACROEXPAND"   . "MACROEXPANDED-REPEATEDLY")))

(defparameter *s2-op-dispositions*
  '(("MACROEXPAND-1" . "expanded-once")
    ("MACROEXPAND"   . "expanded-to-fixpoint")))

;;; ---- §4.1's S1 disposition vocabulary (keyword domain) — EXACTLY TWO -----
(defparameter *s1-disposition-names* (mapcar #'cdr *s1-op-dispositions*))

;;; ---- §4.2's S2 disposition vocabulary (string domain) — EXACTLY TWO ------
(defparameter *s2-disposition-names* (mapcar #'cdr *s2-op-dispositions*))

;;; ==========================================================================
;;; §5.1-T / §5.2-T — THE TOTAL ADMITTED NATIVE VALUE ENUMERATIONS.
;;;
;;; Each row is (CODE-NAME CATEGORY PHASE DERIVED-STANDING), transcribed from
;;; CD0-INSPECTION-RECORD-SCHEMA.md's two tables.  DERIVED-STANDING is TOTAL
;;; and PER CODE — never inferred from phase, which is exactly the inference
;;; R3-A forbids: two PROTOCOL-REFUSAL/PERFORM groups sit in these tables with
;;; DIFFERENT standings.
;;; ==========================================================================

(defparameter *s1-refusal-catalog*
  '(("SOURCE-FORM-NOT-A-CALL"                "PROTOCOL-REFUSAL" "REQUEST" "pre-invocation")
    ("SOURCE-FORM-HEAD-NOT-A-SYMBOL"         "PROTOCOL-REFUSAL" "REQUEST" "pre-invocation")
    ("OPERATION-NOT-DECLARED"                "PROTOCOL-REFUSAL" "REQUEST" "pre-invocation")
    ("OCCURRENCE-TAG-NOT-IDENTIFIER"         "PROTOCOL-REFUSAL" "REQUEST" "pre-invocation")
    ("SOURCE-TERM-UNREPRESENTABLE"           "PROTOCOL-REFUSAL" "REQUEST" "pre-invocation")
    ("SOURCE-TERM-SHARED-STRUCTURE"          "PROTOCOL-REFUSAL" "REQUEST" "pre-invocation")
    ("SOURCE-DEPTH-EXCEEDED"                 "PROTOCOL-REFUSAL" "REQUEST" "pre-invocation")
    ("SOURCE-NODES-EXCEEDED"                 "PROTOCOL-REFUSAL" "REQUEST" "pre-invocation")
    ("SOURCE-TERM-OCTETS-EXCEEDED"           "PROTOCOL-REFUSAL" "REQUEST" "pre-invocation")
    ("NOT-A-KNOWN-SURFACE-CONSTRUCT"         "PROTOCOL-REFUSAL" "PERFORM" "pre-invocation")
    ("CONSTRUCT-NOT-A-MACRO"                 "PROTOCOL-REFUSAL" "PERFORM" "pre-invocation")
    ("SOURCE-NOT-RECONSTRUCTIBLE"            "PROTOCOL-REFUSAL" "PERFORM" "pre-invocation")
    ("EXPANDED-TERM-UNREPRESENTABLE"         "PROTOCOL-REFUSAL" "PERFORM" "invoked-no-completion-account")
    ("EXPANDED-TERM-SHARED-STRUCTURE"        "PROTOCOL-REFUSAL" "PERFORM" "invoked-no-completion-account")
    ("EXPANDED-DEPTH-EXCEEDED"               "PROTOCOL-REFUSAL" "PERFORM" "invoked-no-completion-account")
    ("EXPANDED-NODES-EXCEEDED"               "PROTOCOL-REFUSAL" "PERFORM" "invoked-no-completion-account")
    ("EXPANDED-TERM-OCTETS-EXCEEDED"         "PROTOCOL-REFUSAL" "PERFORM" "invoked-no-completion-account")
    ("SOURCE-IDENTITY-PROJECTION-MISMATCH"   "INTEGRITY-ALARM"  "RECEIPT" "not-applicable")
    ("EXPANDED-IDENTITY-PROJECTION-MISMATCH" "INTEGRITY-ALARM"  "RECEIPT" "not-applicable")
    ("PROCEDURE-VERSION-MISMATCH"            "INTEGRITY-ALARM"  "RECEIPT" "not-applicable")))

(defparameter *s2-refusal-catalog*
  '(("SOURCE-FORM-NOT-A-CALL"                "PROTOCOL-REFUSAL" "REQUEST"   "pre-invocation")
    ("SOURCE-FORM-HEAD-NOT-A-SYMBOL"         "PROTOCOL-REFUSAL" "REQUEST"   "pre-invocation")
    ("OPERATION-NOT-DECLARED"                "PROTOCOL-REFUSAL" "REQUEST"   "pre-invocation")
    ("OCCURRENCE-TAG-NOT-IDENTIFIER"         "PROTOCOL-REFUSAL" "REQUEST"   "pre-invocation")
    ("SOURCE-TERM-UNREPRESENTABLE"           "PROTOCOL-REFUSAL" "REQUEST"   "pre-invocation")
    ("SOURCE-TERM-SHARED-STRUCTURE"          "PROTOCOL-REFUSAL" "REQUEST"   "pre-invocation")
    ("SOURCE-DEPTH-EXCEEDED"                 "PROTOCOL-REFUSAL" "REQUEST"   "pre-invocation")
    ("SOURCE-NODES-EXCEEDED"                 "PROTOCOL-REFUSAL" "REQUEST"   "pre-invocation")
    ("SOURCE-TERM-OCTETS-EXCEEDED"           "PROTOCOL-REFUSAL" "REQUEST"   "pre-invocation")
    ("NOT-A-KNOWN-SURFACE2-CONSTRUCT"        "PROTOCOL-REFUSAL" "PERFORM"   "pre-invocation")
    ("SOURCE-NOT-RECONSTRUCTIBLE"            "PROTOCOL-REFUSAL" "PERFORM"   "pre-invocation")
    ("EXPANDED-TERM-UNREPRESENTABLE"         "PROTOCOL-REFUSAL" "PERFORM"   "invoked-no-completion-account")
    ("EXPANDED-TERM-SHARED-STRUCTURE"        "PROTOCOL-REFUSAL" "PERFORM"   "invoked-no-completion-account")
    ("EXPANDED-DEPTH-EXCEEDED"               "PROTOCOL-REFUSAL" "PERFORM"   "invoked-no-completion-account")
    ("EXPANDED-NODES-EXCEEDED"               "PROTOCOL-REFUSAL" "PERFORM"   "invoked-no-completion-account")
    ("EXPANDED-TERM-OCTETS-EXCEEDED"         "PROTOCOL-REFUSAL" "PERFORM"   "invoked-no-completion-account")
    ("NON-EXHAUSTIVE-MATCH"                  "PROTOCOL-REFUSAL" "EXPANSION" "not-applicable")
    ("DUPLICATE-PATTERN"                     "PROTOCOL-REFUSAL" "EXPANSION" "not-applicable")
    ("UNREACHABLE-PATTERN"                   "PROTOCOL-REFUSAL" "EXPANSION" "not-applicable")
    ("PATTERN-NOT-IN-GRAMMAR"                "PROTOCOL-REFUSAL" "EXPANSION" "not-applicable")
    ("MATCH-VAR-NOT-A-SYMBOL"                "PROTOCOL-REFUSAL" "EXPANSION" "not-applicable")
    ("WITH-OUTCOME-BINDING-MALFORMED"        "PROTOCOL-REFUSAL" "EXPANSION" "not-applicable")
    ("FACET-BINDING-MALFORMED"               "PROTOCOL-REFUSAL" "EXPANSION" "not-applicable")
    ("NOT-A-SEAT-OUTCOME"                    "PROTOCOL-REFUSAL" "RUNTIME"   "not-applicable")
    ("RECEIPT-NOT-MINTED"                    "INTEGRITY-ALARM"  "RECEIPT"   "not-applicable")
    ("SOURCE-IDENTITY-PROJECTION-MISMATCH"   "INTEGRITY-ALARM"  "RECEIPT"   "not-applicable")
    ("EXPANDED-IDENTITY-PROJECTION-MISMATCH" "INTEGRITY-ALARM"  "RECEIPT"   "not-applicable")
    ("PROJECTION-WITHOUT-SETTLED-EXECUTION"  "INTEGRITY-ALARM"  "MATCH"     "not-applicable")
    ("NO-EVIDENCE-CLASS"                     "INTEGRITY-ALARM"  "MATCH"     "not-applicable")))

(defun catalog-row (catalog code-name) (assoc code-name catalog :test #'string=))

(defun derived-standing-for (catalog code-name)
  "THE TOTAL, PER-CODE derived standing.  NIL when the code is not admitted —
which is a refusal, never a default."
  (fourth (catalog-row catalog code-name)))

;;; ==========================================================================
;;; CATALOGUE COMPARISON IS BY COMPLETE (CODE, CATEGORY, PHASE) TRIPLES.
;;; [R3.1-A: "Compare provider catalogues as complete (code, category, phase)
;;; triples, not code-name sets."]
;;;
;;; A CODE-NAME SET COMPARISON ANSWERS A SMALLER QUESTION than the one the
;;; enumeration claims to settle.  It asks "are the same NAMES declared on both
;;; sides?" and is silent about the two other columns the §7 record law rules
;;; on.  A provider whose CATEGORY or PHASE drifted while its code name held
;;; would pass such a comparison untouched, and the doc tables' category and
;;; phase columns would never have been measured against a provider at all —
;;; they would remain a claim about a document.
;;;
;;; So both sides are rendered as complete triples, from the SAME three
;;; columns, and compared as triples in BOTH directions.  The provider side is
;;; read through the provider's OWN exported accessors — surface1.lisp:301-303
;;; and surface2.lisp:452-454 — never through this file's transcription.
;;; ==========================================================================

(defun catalog-triple (code category phase)
  "The printed form of ONE complete catalogue triple.  The separator is a
character that appears in no code, category or phase name, so two distinct
triples can never render to one string."
  (format nil "~A | ~A | ~A" code category phase))

(defun doc-catalog-triples (catalog)
  "The doc-derived expectation table as complete triples, sorted."
  (sort (mapcar (lambda (row) (catalog-triple (first row) (second row) (third row)))
                catalog)
        #'string<))

(defun live-catalog-triples (entries code-of class-of phase-of)
  "A PROVIDER'S OWN live catalogue as complete triples, sorted.  ENTRIES is
whatever the provider's public catalogue accessor returned; the three readers
are that provider's own exported column accessors."
  (sort (mapcar (lambda (e)
                  (catalog-triple (symbol-name (funcall code-of e))
                                  (symbol-name (funcall class-of e))
                                  (symbol-name (funcall phase-of e))))
                entries)
        #'string<))

(defun catalog-code-names (entries code-of)
  "The CODE-NAME set alone — retained ONLY so the teeth below can show that the
comparison R3.1-A replaced would still have agreed on a drifted catalogue."
  (sort (mapcar (lambda (e) (symbol-name (funcall code-of e))) entries) #'string<))

(defun triples-agree-p (a b)
  "Equal lengths and an EMPTY difference in BOTH directions."
  (and (= (length a) (length b))
       (null (set-difference a b :test #'string=))
       (null (set-difference b a :test #'string=))))

(defun catalog-with-drift (catalog code-name column new-value)
  "A COPY of CATALOG in which exactly one row's CATEGORY (column 1) or PHASE
(column 2) carries NEW-VALUE.  THE CODE NAME IS UNTOUCHED — that is the whole
point of the teeth this builds."
  (mapcar (lambda (row)
            (if (string= (first row) code-name)
                (let ((r (copy-list row)))
                  (setf (nth column r) new-value)
                  r)
                row))
          catalog))

;;; ==========================================================================
;;; The exactness primitives.  Every one of them compares the COMPLETE
;;; IDENTIFIER DATUM — namespace segments, path head, path length, path
;;; segments — never a name fragment.
;;; ==========================================================================

(defun exact-identifier-p (d path)
  "D is an identifier datum whose namespace is EXACTLY the one-segment Account
namespace and whose path is EXACTLY PATH, segment for segment and length for
length."
  (and (lisp-plus-cd0:identifier-datum-p d)
       (= 1 (lisp-plus-cd0:identifier-datum-namespace-count d))
       (string= "lisp-plus-surface-account"
                (lisp-plus-cd0:identifier-datum-namespace-segment d 0))
       (= (length path) (lisp-plus-cd0:identifier-datum-path-count d))
       (loop for seg in path
             for i from 0
             always (string= seg (lisp-plus-cd0:identifier-datum-path-segment d i)))))

(defun exact-key-p (k name) (exact-identifier-p k (list "key" name)))

(defun standing-value-p (d)
  (and (lisp-plus-cd0:identifier-datum-p d)
       (= 2 (lisp-plus-cd0:identifier-datum-path-count d))
       (some (lambda (n) (exact-identifier-p d (list "standing" n))) *standing-names*)))

(defun keyword-value-p (d name)
  (exact-identifier-p d (list "keyword" name)))

(defun any-keyword-value-p (d)
  (and (lisp-plus-cd0:identifier-datum-p d)
       (= 2 (lisp-plus-cd0:identifier-datum-path-count d))
       (= 1 (lisp-plus-cd0:identifier-datum-namespace-count d))
       (string= "lisp-plus-surface-account"
                (lisp-plus-cd0:identifier-datum-namespace-segment d 0))
       (string= "keyword" (lisp-plus-cd0:identifier-datum-path-segment d 0))))

(defun keyword-name-of (d) (lisp-plus-cd0:identifier-datum-path-segment d 1))

;;; ---- the exact key set, compared as COMPLETE KEY DATUMS ------------------
(defun exact-key-set-p (record names)
  "Every key of RECORD is a COMPLETE, EXACT Account key identifier, and the set
of their field names is exactly NAMES.  R2 compared only the field names, so a
wrong namespace, a wrong path head and a surplus path segment all survived."
  (and (lisp-plus-cd0:record-datum-p record)
       (= (length names) (lisp-plus-cd0:record-datum-size record))
       (loop for i from 0 below (lisp-plus-cd0:record-datum-size record)
             always (let ((k (lisp-plus-cd0:record-datum-key-at record i)))
                      (some (lambda (n) (exact-key-p k n)) names)))
       (equal (sort (loop for i from 0 below (lisp-plus-cd0:record-datum-size record)
                          collect (lisp-plus-cd0:identifier-datum-path-segment
                                   (lisp-plus-cd0:record-datum-key-at record i) 1))
                    #'string<)
              (sort (copy-list names) #'string<))))

(defun envelope-key-set-ok-p (record)
  (and (lisp-plus-cd0:record-datum-p record)
       (= 4 (lisp-plus-cd0:record-datum-size record))
       (exact-key-set-p record *envelope-keys*)))

(defun body-key-set-ok-p (body spec)
  (and (lisp-plus-cd0:record-datum-p body)
       (= (length spec) (lisp-plus-cd0:record-datum-size body))
       (exact-key-set-p body (mapcar #'first spec))))

;;; ---- R3.1: THE DETAIL KEY IS A CLOSED UNION, so its conformance is a union
;;; test rather than a single-family test.  Two shapes, and the second is
;;; lawful only where a NATIVE detail was measured NIL — an Account-built
;;; composite detail is a string the Account itself wrote, so measured-nil has
;;; no meaning there and is not admitted.
(defun detail-union-ok-p (d &key (allow-measured-nil t))
  (or (and allow-measured-nil (exact-identifier-p d '("standing" "measured-nil")))
      (and (lisp-plus-cd0:string-datum-p d)
           (<= (string-datum-payload-octets d) *detail-ceiling-octets*))))

(defun upstream-union-ok-p (d)
  "§5.1's closed THREE-MEMBER union, repaired per R3.1-A: standing/measured-nil,
a native keyword identifier, or a scalar string datum — AND NO OTHER STANDING.
R3 admitted ANY standing here (STANDING-VALUE-P is the whole closed §2 set), so
an upstream field could carry not-applicable, unavailable-no-public-accessor or
any of the other seven names and pass.  The union is now the three members the
ruling names, and every other §2 standing is planted below as a tooth."
  (or (exact-identifier-p d '("standing" "measured-nil"))
      (any-keyword-value-p d)
      (lisp-plus-cd0:string-datum-p d)))

(defun upstream-key-p (name)
  (member name '("upstream-category" "upstream-code" "upstream-stage") :test #'string=))

(defun value-species-ok-p (body spec &optional species)
  "Every key's value datum is of its declared species — except the TWO KEYS
WHOSE DECLARED SHAPE IS A UNION, which no single-family test can express:

  DETAIL      the R3.1 closed union — a scalar string datum at or below the
              1024-octet ceiling, or standing/measured-nil where a NATIVE
              detail was measured NIL.  1024 passes and 1025 fails HERE, in the
              recognizer, and not only in the constructor.
  UPSTREAM-*  section 5.1's closed three-member union — standing/measured-nil,
              a native keyword identifier, or a scalar string datum.  The R3
              witness only ever built the measured-nil variant, so the spec
              table's :identifier column recorded the ONE variant it happened
              to exercise rather than the declared shape; the two STOP-cell
              records carry the STRING-valued variant and are equally lawful."
  (every (lambda (row)
           (let ((v (record-value-named body (first row))))
             (cond
               ((string= (first row) "detail")
                (detail-union-ok-p
                 v :allow-measured-nil (not (equal species "composite-refusal"))))
               ((upstream-key-p (first row)) (upstream-union-ok-p v))
               (t (eq (family-of v) (second row))))))
         spec))

;;; ==========================================================================
;;; §7.5 — THE ENUM-VALUE LAW.  Every enum-valued entry against its closed set;
;;; an unknown enum or code FAILS CONFORMANCE.  There is no pass-anything cell.
;;; ==========================================================================

(defun receipt-enums-ok-p (body catalog-kind)
  (declare (ignore catalog-kind))
  (let ((op (record-value-named body "operation")))
    (and (any-keyword-value-p op)
         (member (keyword-name-of op) *operation-names* :test #'string=)
         (standing-value-p (record-value-named body "grammar-identity-standing"))
         (standing-value-p (record-value-named body "verifier-availability"))
         (standing-value-p (record-value-named body "temporal-uniqueness-standing"))
         (exact-identifier-p (record-value-named body "grammar-identity-standing")
                             '("standing" "unavailable-no-public-accessor"))
         (exact-identifier-p (record-value-named body "temporal-uniqueness-standing")
                             '("standing" "not-claimed"))
         t)))

(defun s1-receipt-enums-ok-p (body)
  (let ((op   (record-value-named body "operation"))
        (disp (record-value-named body "disposition")))
    (and (receipt-enums-ok-p body :s1)
         (any-keyword-value-p disp)
         (member (keyword-name-of disp) *s1-disposition-names* :test #'string=)
         ;; R3.1-A clause 10: the PAIR is the unit.
         (let ((ruled (cdr (assoc (keyword-name-of op) *s1-op-dispositions* :test #'string=))))
           (and ruled (string= ruled (keyword-name-of disp))))
         (exact-identifier-p (record-value-named body "verifier-availability")
                             '("standing" "no-public-verifier")))))

(defun s2-receipt-enums-ok-p (body)
  (let ((op   (record-value-named body "operation"))
        (disp (record-value-named body "disposition")))
    (and (receipt-enums-ok-p body :s2)
         ;; §4.2: S2's disposition is a STRING datum — its own measured domain,
         ;; carried verbatim.  R3.1-A closes that domain too: it is exactly the
         ;; two strings surface2.lisp:272-273 declares, paired with their
         ;; operations.
         (lisp-plus-cd0:string-datum-p disp)
         (member (lisp-plus-cd0:string-datum-value disp) *s2-disposition-names* :test #'string=)
         (let ((ruled (cdr (assoc (keyword-name-of op) *s2-op-dispositions* :test #'string=))))
           (and ruled (string= ruled (lisp-plus-cd0:string-datum-value disp))))
         (exact-identifier-p (record-value-named body "verifier-availability")
                             '("standing" "public-verifier-exists-output-not-carried")))))

(defun native-refusal-enums-ok-p (body catalog)
  "category / code / phase against the enumerated admitted vocabulary, and the
derived standing against the TOTAL PER-CODE table — never inferred from phase."
  (let ((cat  (record-value-named body "category"))
        (code (record-value-named body "code"))
        (ph   (record-value-named body "phase"))
        (ds   (record-value-named body "derived-standing")))
    (and (any-keyword-value-p cat) (any-keyword-value-p code) (any-keyword-value-p ph)
         (standing-value-p ds)
         (let ((row (catalog-row catalog (keyword-name-of code))))
           (and row
                (string= (second row) (keyword-name-of cat))
                (string= (third row)  (keyword-name-of ph))
                (exact-identifier-p ds (list "standing" (fourth row))))))))

(defun composite-enums-ok-p (body)
  (let* ((code (record-value-named body "refusal-code"))
         (ph   (record-value-named body "phase"))
         (ds   (record-value-named body "derived-standing"))
         (mv   (record-value-named body "manifest-version"))
         (pair (find-if (lambda (cp) (exact-identifier-p code (list "code" (car cp))))
                        *composite-code-phases*)))
    (and pair
         (exact-identifier-p ph (list "phase" (cdr pair)))
         (exact-identifier-p ds '("standing" "pre-invocation"))
         (exact-identifier-p (record-value-named body "manifest-identity") '("manifest"))
         (lisp-plus-cd0:integer-datum-p mv)
         ;; R3.1-A clause 6: the /0 manifest version is EXACTLY 1.  R3 checked
         ;; only that it was an integer datum, so version 2 passed.
         (= *manifest-version* (lisp-plus-cd0:integer-datum-value mv)))))

(defun body-enums-ok-p (species body)
  (cond ((string= species "s1-receipt")        (s1-receipt-enums-ok-p body))
        ((string= species "s2-receipt")        (s2-receipt-enums-ok-p body))
        ((string= species "s1-refusal")
         (and (native-refusal-enums-ok-p body *s1-refusal-catalog*)
              (upstream-union-ok-p (record-value-named body "upstream-category"))
              (upstream-union-ok-p (record-value-named body "upstream-code"))
              (upstream-union-ok-p (record-value-named body "upstream-stage"))))
        ((string= species "s2-refusal")        (native-refusal-enums-ok-p body *s2-refusal-catalog*))
        ((string= species "composite-refusal") (composite-enums-ok-p body))
        (t nil)))

;;; ==========================================================================
;;; ACCOUNT-INSPECTION-RECORD-P — §7's six respects, in one predicate.
;;; ==========================================================================

(defun spec-for-species (species)
  (cond ((string= species "s1-receipt")        *s1-receipt-spec*)
        ((string= species "s2-receipt")        *s2-receipt-spec*)
        ((string= species "s1-refusal")        *s1-refusal-spec*)
        ((string= species "s2-refusal")        *s2-refusal-spec*)
        ((string= species "composite-refusal") *composite-refusal-spec*)))

(defun account-inspection-record-p (record)
  "§7, exactly: the complete key identifier datum; exact namespace; exact path
head, length and segments; exact schema identity and version; exact branch
species; exact enum, standing, category, phase, disposition and code values.
It recognizes NO wrapper species — there is none to recognize."
  (and (lisp-plus-cd0:record-datum-p record)
       (envelope-key-set-ok-p record)
       (let ((si (record-value-named record "schema-identity"))
             (sv (record-value-named record "schema-version"))
             (sp (record-value-named record "species"))
             (body (record-value-named record "body")))
         (and (exact-identifier-p si '("schema" "account-inspection-record"))
              (lisp-plus-cd0:integer-datum-p sv)
              (= *schema-version* (lisp-plus-cd0:integer-datum-value sv))
              (lisp-plus-cd0:identifier-datum-p sp)
              (let ((name (and (= 2 (lisp-plus-cd0:identifier-datum-path-count sp))
                               (lisp-plus-cd0:identifier-datum-path-segment sp 1))))
                (and name
                     (member name *species-names* :test #'string=)
                     (exact-identifier-p sp (list "species" name))
                     (let ((spec (spec-for-species name)))
                       (and spec
                            (body-key-set-ok-p body spec)
                            (value-species-ok-p body spec name)
                            (body-enums-ok-p name body)))))))))

;;; ==========================================================================
;;; The provider samples.  Public doors only.
;;; ==========================================================================

;;; Fixture provenance: the S1 form is probe-controls.lisp's *DERIVE-CASE-TEXT*
;;; and the S2 form its *MATCH-OUTCOME-TEXT* — both taken from a predecessor's
;;; own fixture/test file, per the standing rule that this probe invents no
;;; admitted form.
(defparameter *s1-witness-text*
  "(lisp-plus-surface0:derive-case (cl-user::c cl-user::r)
     (lisp-plus-slice1:derive :schema-name :x)
     (:granted cl-user::c) (:refused (cl-user::e) cl-user::e))")

(defparameter *s2-witness-text*
  "(lisp-plus-surface2:match-outcome cl-user::o
     ((:execution :settled) (lisp-plus-surface2:seat-outcome-seat-id cl-user::o))
     (otherwise cl-user::o))")

(defparameter *unknown-head-text* "(cl:when cl-user::x cl-user::y)")

;;; ---- THE TWO LOCKED S1 STOP CELLS (R3.1-A §8-P) -------------------------
;;; Locked Ruling 2 names exactly two lawful S1 full-expansion STOP cells:
;;; DERIVE-CASE and DERIVE/2-CASE under :MACROEXPAND.  R3's witness never
;;; encoded either, so the ONLY upstream variant it ever exercised was the
;;; measured NIL — the string-valued members of the three-way union were
;;; declared and never built.  These two are DRIVEN, not described: the native
;;; S1 machine is asked to fully expand each admitted source and the RETAINED
;;; refusal it produces is projected, whatever it says.  Its three upstream
;;; fields are the measured ones, not invented ones.
;;;
;;; The DERIVE-CASE source is *s1-witness-text* above (the same fixture, at the
;;; other operation); the DERIVE/2-CASE source is probe-matrix.lisp's fixture,
;;; itself taken verbatim from surface0-selftest.lisp SC5/SC6.
(defparameter *s1-stop-derive/2-case-text*
  "(lisp-plus-surface0:derive/2-case (cl-user::c cl-user::r cl-user::b)
     (lisp-plus-slice2:derive/2 :schema nil)
     (:granted nil) (:refused (cl-user::e) nil))")

(defvar *s1-stop-derive-case* nil)
(defvar *s1-stop-derive/2-case* nil)

(defvar *s1-receipt* nil) (defvar *s2-receipt* nil)
(defvar *s1-refusal* nil) (defvar *s2-refusal* nil)

;;; THE TWO FORMERLY UNENCODABLE NATIVE CLASSES (R3-A).  The R2 tables could
;;; not encode an S2 :protocol-refusal/:expansion object or an S2
;;; :integrity-alarm object, so §5.2-T now enumerates both and these are REAL
;;; ones, minted through PUBLIC S2 DOORS — not hand-built stand-ins, because a
;;; totality claim tested against invented objects tests nothing.
(defvar *s2-expansion-refusal* nil)
(defvar *s2-integrity-refusal* nil)

;;; A MATCH-OUTCOME with the same canonicalized pattern twice.  S2 refuses this
;;; AT EXPANSION, so the refusal surfaces from the public TRY- perform door with
;;; category :PROTOCOL-REFUSAL and phase :EXPANSION.
(defparameter *s2-duplicate-pattern-text*
  "(lisp-plus-surface2:match-outcome cl-user::o
     ((:execution :settled) cl-user::o)
     ((:execution :settled) cl-user::o)
     (otherwise cl-user::o))")

(defun mint-samples ()
  (setf *s1-receipt*
        (lisp-plus-surface1:perform-expansion
         (lisp-plus-surface1:request-expansion (read-fixture *s1-witness-text*)
                                               :macroexpand-1 (tag-for "schema-witness-s1"))))
  (setf *s2-receipt*
        (lisp-plus-surface2:perform-expansion
         (lisp-plus-surface2:request-expansion (read-fixture *s2-witness-text*)
                                               :macroexpand-1 (tag-for "schema-witness-s2"))))
  ;; Both providers ADMIT an unknown head at Door 1 and refuse it at Door 2;
  ;; the refusal object is therefore taken from the TRY- perform door.
  (multiple-value-bind (r e ref)
      (lisp-plus-surface1:try-perform-expansion
       (lisp-plus-surface1:request-expansion (read-fixture *unknown-head-text*)
                                             :macroexpand-1 (tag-for "schema-witness-s1-refusal")))
    (declare (ignore r e))
    (setf *s1-refusal* ref))
  (multiple-value-bind (r e ref)
      (lisp-plus-surface2:try-perform-expansion
       (lisp-plus-surface2:request-expansion (read-fixture *unknown-head-text*)
                                             :macroexpand-1 (tag-for "schema-witness-s2-refusal")))
    (declare (ignore r e))
    (setf *s2-refusal* ref))
  ;; ---- the two locked S1 STOP cells, DRIVEN under :MACROEXPAND ------------
  (multiple-value-bind (r e ref)
      (lisp-plus-surface1:try-perform-expansion
       (lisp-plus-surface1:request-expansion (read-fixture *s1-witness-text*)
                                             :macroexpand (tag-for "schema-witness-s1-stop-derive-case")))
    (declare (ignore r e))
    (setf *s1-stop-derive-case* ref))
  (multiple-value-bind (r e ref)
      (lisp-plus-surface1:try-perform-expansion
       (lisp-plus-surface1:request-expansion (read-fixture *s1-stop-derive/2-case-text*)
                                             :macroexpand (tag-for "schema-witness-s1-stop-derive-2-case")))
    (declare (ignore r e))
    (setf *s1-stop-derive/2-case* ref))
  ;; ---- the S2 :protocol-refusal / :expansion object -----------------------
  (multiple-value-bind (r e ref)
      (lisp-plus-surface2:try-perform-expansion
       (lisp-plus-surface2:request-expansion (read-fixture *s2-duplicate-pattern-text*)
                                             :macroexpand-1 (tag-for "schema-witness-s2-expansion")))
    (declare (ignore r e))
    (setf *s2-expansion-refusal* ref))
  ;; ---- the S2 :integrity-alarm object ------------------------------------
  ;; SIGNAL-MATCH-GUARD is S2's own exported entry point for the two
  ;; :MATCH-phase guard codes; the refusal it raises is typed, catalogued and
  ;; retained by S2 itself.  Nothing is constructed here.
  (handler-case
      (lisp-plus-surface2:signal-match-guard
       :no-evidence-class
       :detail "schema witness: an S2 integrity-alarm object, minted through S2's own public guard door")
    (lisp-plus-surface2:surface2-expansion-refused (c)
      (setf *s2-integrity-refusal* (lisp-plus-surface2:expansion-condition-refusal c)))))

;;; --------------------------------------------------------------------------
;;; The five branch bodies.
;;; --------------------------------------------------------------------------

(defun s1-receipt-body ()
  (let* ((r *s1-receipt*)
         (occ (lisp-plus-surface1:expansion-receipt-occurrence r)))
    (build-body
     (list (cons "receipt-identity"    (lisp-plus-surface1:expansion-receipt-identity r))
           (cons "request-identity"    (lisp-plus-surface1:expansion-receipt-request-identity r))
           (cons "occurrence-identity" (lisp-plus-surface1:expansion-receipt-occurrence-identity r))
           (cons "occurrence-tag"      (lisp-plus-surface1:expansion-occurrence-occurrence-tag occ))
           (cons "source-datum"        (lisp-plus-surface1:expansion-receipt-source-form-datum r))
           (cons "source-identity"     (lisp-plus-surface1:expansion-receipt-source-form-identity r))
           (cons "expanded-datum"      (lisp-plus-surface1:expansion-receipt-expanded-form-datum r))
           (cons "expanded-identity"   (lisp-plus-surface1:expansion-receipt-expanded-form-identity r))
           (cons "construct-identity"  (lisp-plus-surface1:expansion-receipt-construct-identity r))
           (cons "expansion-context"   (lisp-plus-surface1:expansion-receipt-expansion-context r))
           (cons "operation"           (a-keyword (lisp-plus-surface1:expansion-receipt-operation r)))
           (cons "disposition"         (a-keyword (lisp-plus-surface1:expansion-receipt-disposition r)))
           (cons "stored-grammar-version"   (lisp-plus-cd0:make-integer-datum (lisp-plus-surface1:expansion-receipt-grammar-version r)))
           (cons "stored-procedure-version" (lisp-plus-cd0:make-integer-datum (lisp-plus-surface1:expansion-receipt-procedure-version r)))
           (cons "stored-policy-version"    (lisp-plus-cd0:make-integer-datum (lisp-plus-surface1:expansion-receipt-policy-version r)))
           (cons "grammar-identity-standing"    (a-standing "unavailable-no-public-accessor"))
           (cons "verifier-availability"        (a-standing "no-public-verifier"))
           (cons "temporal-uniqueness-standing" (a-standing "not-claimed"))))))

(defun s2-receipt-body ()
  (let* ((r *s2-receipt*)
         (occ (lisp-plus-surface2:expansion-receipt-occurrence r)))
    (build-body
     (list (cons "receipt-identity"    (lisp-plus-surface2:expansion-receipt-identity r))
           (cons "request-identity"    (lisp-plus-surface2:expansion-receipt-request-identity r))
           (cons "occurrence-identity" (lisp-plus-surface2:expansion-receipt-occurrence-identity r))
           (cons "occurrence-tag"      (lisp-plus-surface2:expansion-occurrence-occurrence-tag occ))
           (cons "source-datum"        (lisp-plus-surface2:expansion-receipt-source-form-datum r))
           (cons "source-identity"     (lisp-plus-surface2:expansion-receipt-source-form-identity r))
           (cons "expanded-datum"      (lisp-plus-surface2:expansion-receipt-expanded-form-datum r))
           (cons "expanded-identity"   (lisp-plus-surface2:expansion-receipt-expanded-form-identity r))
           (cons "construct-identity"  (lisp-plus-surface2:expansion-receipt-construct-identity r))
           (cons "expansion-context"   (lisp-plus-surface2:expansion-receipt-expansion-context r))
           (cons "operation"           (a-keyword (lisp-plus-surface2:expansion-receipt-operation r)))
           ;; S2's disposition is a measured STRING domain, carried verbatim.
           (cons "disposition"         (lisp-plus-cd0:make-string-datum (lisp-plus-surface2:expansion-receipt-disposition r)))
           (cons "stored-grammar-version"   (lisp-plus-cd0:make-integer-datum (lisp-plus-surface2:expansion-receipt-grammar-version r)))
           (cons "stored-procedure-version" (lisp-plus-cd0:make-integer-datum (lisp-plus-surface2:expansion-receipt-procedure-version r)))
           (cons "stored-policy-version"    (lisp-plus-cd0:make-integer-datum (lisp-plus-surface2:expansion-receipt-policy-version r)))
           (cons "grammar-identity-standing"    (a-standing "unavailable-no-public-accessor"))
           (cons "verifier-availability"        (a-standing "public-verifier-exists-output-not-carried"))
           (cons "temporal-uniqueness-standing" (a-standing "not-claimed"))))))

(defun upstream-value (v)
  "§5.1's closed three-species union.  The value-exercised variant this round is
the measured NIL, encoded as the mandatory ABSENCE STANDING — never a missing
key, never host NIL."
  (cond ((null v)      (a-standing "measured-nil"))
        ((stringp v)   (lisp-plus-cd0:make-string-datum v))
        ((symbolp v)   (a-keyword v))
        (t             (a-standing "measured-nil"))))

(defun s1-refusal-body (&optional (r *s1-refusal*))
  (let ((r r))
    (multiple-value-bind (detail code) (a-detail (lisp-plus-surface1:expansion-refusal-detail r))
      (when code (error "the S1 sample detail exceeded the ceiling: ~A" code))
      (build-body
       (list (cons "refusal-identity"  (lisp-plus-surface1:expansion-refusal-identity r))
             (cons "category"          (a-keyword (lisp-plus-surface1:expansion-refusal-category r)))
             (cons "code"              (a-keyword (lisp-plus-surface1:expansion-refusal-code r)))
             (cons "phase"             (a-keyword (lisp-plus-surface1:expansion-refusal-phase r)))
             (cons "detail"            detail)
             (cons "upstream-category" (upstream-value (lisp-plus-surface1:expansion-refusal-upstream-category r)))
             (cons "upstream-code"     (upstream-value (lisp-plus-surface1:expansion-refusal-upstream-code r)))
             (cons "upstream-stage"    (upstream-value (lisp-plus-surface1:expansion-refusal-upstream-stage r)))
             ;; §5.1-T, PER CODE and NOT inferred from phase.  The standing is
             ;; looked up in the total table by the code the provider actually
             ;; returned; a code with no row yields NIL and the constructor
             ;; below refuses rather than defaulting.
             (cons "derived-standing"
                   (a-standing (or (derived-standing-for *s1-refusal-catalog*
                                                         (symbol-name (lisp-plus-surface1:expansion-refusal-code r)))
                                   (error "S1 code ~A is not in the total admitted enumeration"
                                          (lisp-plus-surface1:expansion-refusal-code r))))))))))

(defun s2-refusal-body (&optional (r *s2-refusal*))
  "One builder for EVERY admitted S2 refusal object, whatever its category and
phase — which is what the totality law means in code: the branch does not have
a special case for the classes R2 could not encode."
  (let ((r r))
    (multiple-value-bind (detail code) (a-detail (lisp-plus-surface2:expansion-refusal-detail r))
      (when code (error "the S2 sample detail exceeded the ceiling: ~A" code))
      (build-body
       (list (cons "refusal-identity" (lisp-plus-surface2:expansion-refusal-identity r))
             (cons "category"         (a-keyword (lisp-plus-surface2:expansion-refusal-category r)))
             (cons "code"             (a-keyword (lisp-plus-surface2:expansion-refusal-code r)))
             (cons "phase"            (a-keyword (lisp-plus-surface2:expansion-refusal-phase r)))
             (cons "detail"           detail)
             (cons "derived-standing"
                   (a-standing (or (derived-standing-for *s2-refusal-catalog*
                                                         (symbol-name (lisp-plus-surface2:expansion-refusal-code r)))
                                   (error "S2 code ~A is not in the total admitted enumeration"
                                          (lisp-plus-surface2:expansion-refusal-code r))))))))))

(defun composite-refusal-body ()
  ;; No provider is touched: a composite refusal is Account-owned throughout.
  (multiple-value-bind (detail code)
      (a-detail "the request names no head in the /0 manifest")
    (when code (error "the composite sample detail exceeded the ceiling: ~A" code))
    (build-body
     (list (cons "refusal-code"      (a-code "head-not-in-manifest"))
           (cons "phase"             (a-phase "request"))
           (cons "detail"            detail)
           (cons "manifest-identity" (a-manifest))
           (cons "manifest-version"  (lisp-plus-cd0:make-integer-datum 1))
           (cons "derived-standing"  (a-standing "pre-invocation"))))))

;;; ==========================================================================
;;; §8 — the six proofs, per branch.
;;; ==========================================================================

(defun native-pass-through-ok-p (body natives)
  "§6: the record carries THE VERY DATUM the native accessor returned — proved
by canonical-octet equality AND equal-datum against the native original."
  (every (lambda (pair)
           (let ((carried (record-value-named body (car pair)))
                 (native  (cdr pair)))
             (and carried native
                  (lisp-plus-cd0:equal-datum carried native)
                  (equalp (lisp-plus-cd0:octets-to-hex (lisp-plus-cd0:canonical-octets carried))
                          (lisp-plus-cd0:octets-to-hex (lisp-plus-cd0:canonical-octets native))))))
         natives))

(defun not-re-admitted-p (thing)
  "The inspector's output is a CD/0 record datum.  It is offered to all four
native admission predicates; every one must refuse it."
  (and (not (lisp-plus-surface1:expansion-receipt-p thing))
       (not (lisp-plus-surface1:expansion-refusal-p thing))
       (not (lisp-plus-surface2:expansion-receipt-p thing))
       (not (lisp-plus-surface2:expansion-refusal-p thing))))

(defun witness-branch (label spec body natives &optional (species label))
  "LABEL names the transcript block; SPECIES is the value that goes into the
record's \"species\" key.  They differ only for the two positive teeth, which
are additional lawful instances of the SAME \"s2-refusal\" species."
  (p "SCHEMA-BRANCH ~A" label)
  (let* ((record (build-envelope species body))
         (octets (lisp-plus-cd0:encode-exact record))
         (decoded (lisp-plus-cd0:decode-exact octets))
         (tag (string-upcase (substitute #\- #\Space label))))
    (kv "record species" species)
    (kv "envelope keys" (format nil "~{~A~^ ~}" (record-key-names record)))
    (kv "body keys" (lisp-plus-cd0:record-datum-size body))
    (kv "canonical octets" (lisp-plus-cd0:octets-length (lisp-plus-cd0:canonical-octets record)))
    (dolist (row spec)
      (kv (format nil "  ~A" (first row)) (family-of (record-value-named body (first row)))))
    (report-doc-deviations label spec)

    (probe-check (format nil "SCHEMA-~A-DATUM-P" tag)
                 (format nil "schema witness ~A: the whole record is a CD/0 datum (datum-p)" label)
                 (and (lisp-plus-cd0:datum-p record) (lisp-plus-cd0:record-datum-p record)))
    (probe-check (format nil "SCHEMA-~A-ENVELOPE-KEY-SET" tag)
                 (format nil "schema witness ~A: the envelope carries EXACTLY the four declared keys, each a COMPLETE and EXACT Account key identifier" label)
                 (envelope-key-set-ok-p record))
    (probe-check (format nil "SCHEMA-~A-BODY-KEY-SET" tag)
                 (format nil "schema witness ~A: the body carries EXACTLY its ~D declared keys, no more and no fewer" label (length spec))
                 (body-key-set-ok-p body spec))
    (probe-check (format nil "SCHEMA-~A-VALUE-SPECIES" tag)
                 (format nil "schema witness ~A: every key's value datum is of the exact measured species (and the detail key satisfies the R3.1 closed union and its 1024-octet ceiling)" label)
                 (value-species-ok-p body spec species))
    (probe-check (format nil "SCHEMA-~A-ROUND-TRIP" tag)
                 (format nil "schema witness ~A: encode-exact -> decode-exact round-trips to an EQUAL-DATUM record" label)
                 (lisp-plus-cd0:equal-datum record decoded))
    (probe-check (format nil "SCHEMA-~A-CANONICAL-REENCODING" tag)
                 (format nil "schema witness ~A: the decoded record re-encodes to byte-identical canonical octets" label)
                 (equalp (lisp-plus-cd0:octets-to-hex (lisp-plus-cd0:canonical-octets decoded))
                         (lisp-plus-cd0:octets-to-hex (lisp-plus-cd0:canonical-octets record))))
    (when natives
      (probe-check (format nil "SCHEMA-~A-NATIVE-PASSTHROUGH" tag)
                   (format nil "schema witness ~A: every native value is carried UNCHANGED (equal-datum and byte-identical canonical octets)" label)
                   (native-pass-through-ok-p body natives)))
    (probe-check (format nil "SCHEMA-~A-NOT-RE-ADMITTED" tag)
                 (format nil "schema witness ~A: the record is refused by ALL FOUR native admission predicates" label)
                 (and (not-re-admitted-p record) (not-re-admitted-p decoded)))
    (probe-check (format nil "SCHEMA-~A-FULL-EXACTNESS" tag)
                 (format nil "schema witness ~A [R3-A §7]: the record is recognized by the FULL-EXACTNESS comparison — complete key identifier datums, exact namespace, exact path head/length/segments, exact schema identity and version, exact species, and every enum/standing/category/phase/disposition/code value against its closed set" label)
                 (and (account-inspection-record-p record)
                      (account-inspection-record-p decoded)))
    (p "END-SCHEMA-BRANCH ~A" label)
    record))

;;; ==========================================================================
;;; THE SECTION.
;;; ==========================================================================

(probe-header "CD/0 INSPECTION-RECORD SCHEMA WITNESS — five branches, built through the public CD/0 API")

(p "SCOPE, PRINTED BEFORE ANY PROOF:")
(p "  This witness CONSTRUCTS inert CD/0 record datums to the exact tables of")
(p "  CD0-INSPECTION-RECORD-SCHEMA.md.  It defines no package, exports nothing,")
(p "  mints no Account /0 object, and implements no inspector.  The providers are")
(p "  touched ONLY to obtain the native datum samples §§4 and §6 require: a")
(p "  pass-through law tested against invented values would test nothing.")
(p "  It is a witness that the SCHEMA IS CONSTRUCTIBLE AND EXACT, not a claim")
(p "  that any inspector exists.")
(rule)

(mint-samples)
(kv "S1 sample receipt" (if (lisp-plus-surface1:expansion-receipt-p *s1-receipt*) "MINTED" "ABSENT"))
(kv "S2 sample receipt" (if (lisp-plus-surface2:expansion-receipt-p *s2-receipt*) "MINTED" "ABSENT"))
(kv "S1 sample refusal" (if (lisp-plus-surface1:expansion-refusal-p *s1-refusal*) "RETAINED" "ABSENT"))
(kv "S2 sample refusal" (if (lisp-plus-surface2:expansion-refusal-p *s2-refusal*) "RETAINED" "ABSENT"))
(kv "S2 expansion refusal" (if (lisp-plus-surface2:expansion-refusal-p *s2-expansion-refusal*) "RETAINED" "ABSENT"))
(kv "S2 expansion category/phase/code"
    (format nil "~A / ~A / ~A"
            (lisp-plus-surface2:expansion-refusal-category *s2-expansion-refusal*)
            (lisp-plus-surface2:expansion-refusal-phase *s2-expansion-refusal*)
            (lisp-plus-surface2:expansion-refusal-code *s2-expansion-refusal*)))
(kv "S2 integrity refusal" (if (lisp-plus-surface2:expansion-refusal-p *s2-integrity-refusal*) "RETAINED" "ABSENT"))
(kv "S2 integrity category/phase/code"
    (format nil "~A / ~A / ~A"
            (lisp-plus-surface2:expansion-refusal-category *s2-integrity-refusal*)
            (lisp-plus-surface2:expansion-refusal-phase *s2-integrity-refusal*)
            (lisp-plus-surface2:expansion-refusal-code *s2-integrity-refusal*)))

;;; ---- the control arm, and it runs FIRST -----------------------------------
;;; Four predicates refusing a record would prove nothing if they refused
;;; everything.  So they are first shown ACCEPTING their own genuine objects.
(rule)
(arm "CLEAN" "the four native admission predicates accept their OWN genuine objects")
(probe-check "SCHEMA-ADMISSION-PREDICATES-DISCRIMINATE"
             "schema witness control arm: each native admission predicate ACCEPTS its own genuine object — so its NIL on an inspection record is a measurement, not a habit"
             (and (lisp-plus-surface1:expansion-receipt-p *s1-receipt*)
                  (lisp-plus-surface1:expansion-refusal-p *s1-refusal*)
                  (lisp-plus-surface2:expansion-receipt-p *s2-receipt*)
                  (lisp-plus-surface2:expansion-refusal-p *s2-refusal*)))

(rule)
(let* ((s1r (s1-receipt-body))
       (s2r (s2-receipt-body))
       (s1f (s1-refusal-body))
       (s2f (s2-refusal-body))
       (cf  (composite-refusal-body))
       (s2x (s2-refusal-body *s2-expansion-refusal*))
       (s2i (s2-refusal-body *s2-integrity-refusal*))
       (s1occ (lisp-plus-surface1:expansion-receipt-occurrence *s1-receipt*))
       (s2occ (lisp-plus-surface2:expansion-receipt-occurrence *s2-receipt*))
       (built nil))
  (push (witness-branch "s1-receipt" *s1-receipt-spec* s1r
                        (list (cons "receipt-identity"    (lisp-plus-surface1:expansion-receipt-identity *s1-receipt*))
                              (cons "request-identity"    (lisp-plus-surface1:expansion-receipt-request-identity *s1-receipt*))
                              (cons "occurrence-identity" (lisp-plus-surface1:expansion-receipt-occurrence-identity *s1-receipt*))
                              (cons "occurrence-tag"      (lisp-plus-surface1:expansion-occurrence-occurrence-tag s1occ))
                              (cons "source-datum"        (lisp-plus-surface1:expansion-receipt-source-form-datum *s1-receipt*))
                              (cons "source-identity"     (lisp-plus-surface1:expansion-receipt-source-form-identity *s1-receipt*))
                              (cons "expanded-datum"      (lisp-plus-surface1:expansion-receipt-expanded-form-datum *s1-receipt*))
                              (cons "expanded-identity"   (lisp-plus-surface1:expansion-receipt-expanded-form-identity *s1-receipt*))
                              (cons "construct-identity"  (lisp-plus-surface1:expansion-receipt-construct-identity *s1-receipt*))
                              (cons "expansion-context"   (lisp-plus-surface1:expansion-receipt-expansion-context *s1-receipt*))))
        built)
  (rule)
  (push (witness-branch "s2-receipt" *s2-receipt-spec* s2r
                        (list (cons "receipt-identity"    (lisp-plus-surface2:expansion-receipt-identity *s2-receipt*))
                              (cons "request-identity"    (lisp-plus-surface2:expansion-receipt-request-identity *s2-receipt*))
                              (cons "occurrence-identity" (lisp-plus-surface2:expansion-receipt-occurrence-identity *s2-receipt*))
                              (cons "occurrence-tag"      (lisp-plus-surface2:expansion-occurrence-occurrence-tag s2occ))
                              (cons "source-datum"        (lisp-plus-surface2:expansion-receipt-source-form-datum *s2-receipt*))
                              (cons "source-identity"     (lisp-plus-surface2:expansion-receipt-source-form-identity *s2-receipt*))
                              (cons "expanded-datum"      (lisp-plus-surface2:expansion-receipt-expanded-form-datum *s2-receipt*))
                              (cons "expanded-identity"   (lisp-plus-surface2:expansion-receipt-expanded-form-identity *s2-receipt*))
                              (cons "construct-identity"  (lisp-plus-surface2:expansion-receipt-construct-identity *s2-receipt*))
                              (cons "expansion-context"   (lisp-plus-surface2:expansion-receipt-expansion-context *s2-receipt*))))
        built)
  (rule)
  (push (witness-branch "s1-refusal" *s1-refusal-spec* s1f
                        (list (cons "refusal-identity" (lisp-plus-surface1:expansion-refusal-identity *s1-refusal*))))
        built)
  (rule)
  (push (witness-branch "s2-refusal" *s2-refusal-spec* s2f
                        (list (cons "refusal-identity" (lisp-plus-surface2:expansion-refusal-identity *s2-refusal*))))
        built)
  (rule)
  (push (witness-branch "composite-refusal" *composite-refusal-spec* cf nil) built)

  ;; ---- §8-T'S TWO POSITIVE TEETH ----------------------------------------
  ;; These are NOT refusal teeth.  They are the two native classes the R2
  ;; tables could not encode at all, now required to ENCODE CLEANLY and pass
  ;; proofs 1-5 as lawful "s2-refusal" instances.  Both objects were minted by
  ;; S2's own public doors, so what is proved is that the totalized schema
  ;; admits what the provider actually produces — not what this file imagines.
  (rule)
  (push (witness-branch "s2-refusal-protocol-expansion" *s2-refusal-spec* s2x
                        (list (cons "refusal-identity" (lisp-plus-surface2:expansion-refusal-identity *s2-expansion-refusal*)))
                        "s2-refusal")
        built)
  (rule)
  (push (witness-branch "s2-refusal-integrity-alarm" *s2-refusal-spec* s2i
                        (list (cons "refusal-identity" (lisp-plus-surface2:expansion-refusal-identity *s2-integrity-refusal*)))
                        "s2-refusal")
        built)
  (probe-check "SCHEMA-FORMERLY-UNENCODABLE-CLASSES-ENCODE"
               "schema witness [R3-A]: the two classes the R2 tables left UNENCODABLE — an S2 :protocol-refusal/:expansion object and an S2 :integrity-alarm object, both minted through S2's own public doors — now encode as lawful s2-refusal records, each carrying derived-standing (standing not-applicable) exactly as the total table rules"
               (and (lisp-plus-surface2:expansion-refusal-p *s2-expansion-refusal*)
                    (lisp-plus-surface2:expansion-refusal-p *s2-integrity-refusal*)
                    (eq :expansion (lisp-plus-surface2:expansion-refusal-phase *s2-expansion-refusal*))
                    (eq :integrity-alarm (lisp-plus-surface2:expansion-refusal-category *s2-integrity-refusal*))
                    (exact-identifier-p (record-value-named s2x "derived-standing") '("standing" "not-applicable"))
                    (exact-identifier-p (record-value-named s2i "derived-standing") '("standing" "not-applicable"))))

  ;; ---- §8-P: THE TWO LOCKED S1 STOP CELLS AS POSITIVE RECORDS (R3.1-A) ---
  ;; R3's witness exercised exactly one upstream variant — the measured NIL —
  ;; so the string-valued member of the three-way union was declared and never
  ;; built.  These two records are made from the refusals the native S1 machine
  ;; actually returned when asked to FULLY EXPAND the two locked STOP-cell
  ;; sources, and their upstream fields are whatever it put there.
  (rule)
  (let ((stop1 (s1-refusal-body *s1-stop-derive-case*))
        (stop2 (s1-refusal-body *s1-stop-derive/2-case*)))
    (push (witness-branch "s1-refusal-stop-derive-case" *s1-refusal-spec* stop1
                          (list (cons "refusal-identity"
                                      (lisp-plus-surface1:expansion-refusal-identity *s1-stop-derive-case*)))
                          "s1-refusal")
          built)
    (rule)
    (push (witness-branch "s1-refusal-stop-derive-2-case" *s1-refusal-spec* stop2
                          (list (cons "refusal-identity"
                                      (lisp-plus-surface1:expansion-refusal-identity *s1-stop-derive/2-case*)))
                          "s1-refusal")
          built)
    (dolist (pair (list (cons "derive-case" stop1) (cons "derive/2-case" stop2)))
      (dolist (k '("upstream-category" "upstream-code" "upstream-stage"))
        (kv (format nil "STOP ~A ~A" (car pair) k)
            (let ((v (record-value-named (cdr pair) k)))
              (format nil "~A = ~A" (family-of v)
                      (if (lisp-plus-cd0:string-datum-p v)
                          (lisp-plus-cd0:string-datum-value v)
                          "(not a string datum)"))))))
    (probe-check "SCHEMA-S1-STOP-CELLS-STRING-VALUED-UPSTREAM"
                 "schema witness [R3.1-A §8-P]: BOTH locked S1 STOP cells — DERIVE-CASE and DERIVE/2-CASE under :MACROEXPAND, driven through the native S1 machine, not described — project to lawful s1-refusal records whose THREE upstream fields are the STRING-valued member of the closed three-way union, exercising the variant the R3 witness declared and never built"
                 (and (lisp-plus-surface1:expansion-refusal-p *s1-stop-derive-case*)
                      (lisp-plus-surface1:expansion-refusal-p *s1-stop-derive/2-case*)
                      (every (lambda (b)
                               (every (lambda (k) (lisp-plus-cd0:string-datum-p (record-value-named b k)))
                                      '("upstream-category" "upstream-code" "upstream-stage")))
                             (list stop1 stop2))))
    (probe-check "SCHEMA-S1-STOP-CELLS-RECOGNIZED"
                 "schema witness [R3.1-A §8-P]: and both STOP-cell records satisfy ACCOUNT-INSPECTION-RECORD-P — the §7 comparison law admits the string-valued upstream union member exactly as it admits the measured-nil one"
                 (and (account-inspection-record-p (build-envelope "s1-refusal" stop1))
                      (account-inspection-record-p (build-envelope "s1-refusal" stop2)))))

  ;; ---- THE SCHEMA PREDICATES' OWN TEETH ----------------------------------
  ;; Three predicates that have never refused anything are three predicates
  ;; nobody has tested.  Each is now shown REFUSING a record that differs from
  ;; a good one in exactly one way.
  (rule)
  (arm "PLANTED" "an envelope with a FIFTH key")
  (let ((fat (lisp-plus-cd0:make-record-datum
              (list (lisp-plus-cd0:make-record-entry (a-key "schema-identity") (a-schema))
                    (lisp-plus-cd0:make-record-entry (a-key "schema-version") (lisp-plus-cd0:make-integer-datum *schema-version*))
                    (lisp-plus-cd0:make-record-entry (a-key "species") (a-species "s2-refusal"))
                    (lisp-plus-cd0:make-record-entry (a-key "body") s2f)
                    (lisp-plus-cd0:make-record-entry (a-key "note") (lisp-plus-cd0:make-string-datum "an optional field"))))))
    (kv "planted envelope size" (lisp-plus-cd0:record-datum-size fat))
    (probe-check "SCHEMA-TOOTH-EXTRA-ENVELOPE-KEY-REFUSED"
                 "schema tooth: an envelope with a fifth key is REFUSED — no optional key exists anywhere in this schema"
                 (not (envelope-key-set-ok-p fat))))

  (arm "PLANTED" "a body with one declared key REMOVED")
  (let ((thin (build-body (list (cons "refusal-code"      (a-code "head-not-in-manifest"))
                                (cons "phase"             (a-phase "request"))
                                (cons "detail"            (lisp-plus-cd0:make-string-datum "x"))
                                (cons "manifest-identity" (a-manifest))
                                (cons "manifest-version"  (lisp-plus-cd0:make-integer-datum 1))))))
    (kv "planted body size" (lisp-plus-cd0:record-datum-size thin))
    (probe-check "SCHEMA-TOOTH-MISSING-BODY-KEY-REFUSED"
                 "schema tooth: a body missing one declared key is REFUSED — a branch key set is exact, and absence is carried by a standing, never by omission"
                 (not (body-key-set-ok-p thin *composite-refusal-spec*))))

  (arm "PLANTED" "a body whose manifest-version is a STRING datum instead of an integer datum")
  (let ((wrong (build-body (list (cons "refusal-code"      (a-code "head-not-in-manifest"))
                                 (cons "phase"             (a-phase "request"))
                                 (cons "detail"            (lisp-plus-cd0:make-string-datum "x"))
                                 (cons "manifest-identity" (a-manifest))
                                 (cons "manifest-version"  (lisp-plus-cd0:make-string-datum "1"))
                                 (cons "derived-standing"  (a-standing "pre-invocation"))))))
    (kv "planted manifest-version family" (family-of (record-value-named wrong "manifest-version")))
    (probe-check "SCHEMA-TOOTH-WRONG-VALUE-SPECIES-REFUSED"
                 "schema tooth: the exact key set holds but ONE value datum is of the wrong species — REFUSED"
                 (and (body-key-set-ok-p wrong *composite-refusal-spec*)
                      (not (value-species-ok-p wrong *composite-refusal-spec*)))))

  ;; ---- §8-T'S R3 CONFORMANCE TEETH --------------------------------------
  ;; Each constructs a near-record deviating in EXACTLY ONE respect and proves
  ;; §7's comparison law refuses it.  Every one of these was ACCEPTED by the R2
  ;; predicate, which compared key NAMES and no enum values at all.
  (rule)
  (let* ((good-body (composite-refusal-body))
         (good (build-envelope "composite-refusal" good-body)))
    (kv "teeth baseline recognized" (if (account-inspection-record-p good) "YES" "NO"))
    (probe-check "SCHEMA-TOOTH-BASELINE-RECOGNIZED"
                 "schema teeth control arm: the UNDEVIATED record is RECOGNIZED — so every refusal below is a discrimination, not a predicate that refuses everything"
                 (account-inspection-record-p good))

    (flet ((body-with (pairs)
             (lisp-plus-cd0:make-record-datum
              (mapcar (lambda (pr) (lisp-plus-cd0:make-record-entry (car pr) (cdr pr))) pairs)))
           (good-pairs ()
             (list (cons (a-key "refusal-code")      (a-code "head-not-in-manifest"))
                   (cons (a-key "phase")             (a-phase "request"))
                   (cons (a-key "detail")            (lisp-plus-cd0:make-string-datum "x"))
                   (cons (a-key "manifest-identity") (a-manifest))
                   (cons (a-key "manifest-version")  (lisp-plus-cd0:make-integer-datum 1))
                   (cons (a-key "derived-standing")  (a-standing "pre-invocation")))))
      (macrolet ((tooth (id label form)
                   `(probe-check ,id ,label (not (account-inspection-record-p ,form)))))

        (arm "PLANTED" "a key whose NAMESPACE is (lisp-plus-surface-account-x)")
        (let* ((pairs (good-pairs))
               (bad (progn (setf (car (nth 2 pairs))
                                 (lisp-plus-cd0:make-identifier-datum
                                  '("lisp-plus-surface-account-x") '("key" "detail")))
                           (build-envelope "composite-refusal" (body-with pairs)))))
          (kv "planted namespace" "lisp-plus-surface-account-x")
          (tooth "SCHEMA-TOOTH-WRONG-NAMESPACE-REFUSED"
                 "schema tooth [R3-A]: a key in a NEIGHBOURING namespace is REFUSED — R2 compared only the name fragment and accepted it"
                 bad))

        (arm "PLANTED" "a key whose PATH HEAD is \"kee\" instead of \"key\"")
        (let* ((pairs (good-pairs))
               (bad (progn (setf (car (nth 2 pairs))
                                 (lisp-plus-cd0:make-identifier-datum
                                  *account-namespace* '("kee" "detail")))
                           (build-envelope "composite-refusal" (body-with pairs)))))
          (kv "planted path head" "kee")
          (tooth "SCHEMA-TOOTH-WRONG-PATH-HEAD-REFUSED"
                 "schema tooth [R3-A]: a key with the wrong PATH HEAD is REFUSED"
                 bad))

        (arm "PLANTED" "a key carrying an EXTRA path segment (\"key\" \"detail\" \"surplus\")")
        (let* ((pairs (good-pairs))
               (bad (progn (setf (car (nth 2 pairs))
                                 (lisp-plus-cd0:make-identifier-datum
                                  *account-namespace* '("key" "detail" "surplus")))
                           (build-envelope "composite-refusal" (body-with pairs)))))
          (kv "planted path length" 3)
          (tooth "SCHEMA-TOOTH-EXTRA-PATH-SEGMENT-REFUSED"
                 "schema tooth [R3-A]: a key with a SURPLUS path segment is REFUSED — exact path LENGTH is part of the comparison"
                 bad))

        (arm "PLANTED" "a wrong SCHEMA IDENTITY")
        (tooth "SCHEMA-TOOTH-WRONG-SCHEMA-IDENTITY-REFUSED"
               "schema tooth [R3-A]: a record naming a different schema identity is REFUSED"
               (lisp-plus-cd0:make-record-datum
                (list (lisp-plus-cd0:make-record-entry (a-key "schema-identity")
                                                       (lisp-plus-cd0:make-identifier-datum
                                                        *account-namespace* '("schema" "some-other-record")))
                      (lisp-plus-cd0:make-record-entry (a-key "schema-version") (lisp-plus-cd0:make-integer-datum *schema-version*))
                      (lisp-plus-cd0:make-record-entry (a-key "species") (a-species "composite-refusal"))
                      (lisp-plus-cd0:make-record-entry (a-key "body") good-body))))

        (arm "PLANTED" "a wrong SCHEMA VERSION")
        (tooth "SCHEMA-TOOTH-WRONG-SCHEMA-VERSION-REFUSED"
               "schema tooth [R3-A]: a record at a different schema version is REFUSED"
               (lisp-plus-cd0:make-record-datum
                (list (lisp-plus-cd0:make-record-entry (a-key "schema-identity") (a-schema))
                      (lisp-plus-cd0:make-record-entry (a-key "schema-version") (lisp-plus-cd0:make-integer-datum 2))
                      (lisp-plus-cd0:make-record-entry (a-key "species") (a-species "composite-refusal"))
                      (lisp-plus-cd0:make-record-entry (a-key "body") good-body))))

        (arm "PLANTED" "a SPECIES outside the closed set of five")
        (tooth "SCHEMA-TOOTH-WRONG-SPECIES-REFUSED"
               "schema tooth [R3-A]: a species outside the closed set of five is REFUSED — and so is a WRAPPER species, of which there is none to recognize"
               (build-envelope "account-wrapper" good-body))

        (arm "PLANTED" "an UNKNOWN STANDING, outside §2's closed set")
        (let ((pairs (good-pairs)))
          (setf (cdr (nth 5 pairs)) (a-standing "provisionally-fine"))
          (kv "planted standing" "provisionally-fine")
          (tooth "SCHEMA-TOOTH-UNKNOWN-ENUM-REFUSED"
                 "schema tooth [R3-A]: a standing outside the closed set is REFUSED — the R2 predicate checked datum FAMILIES only and accepted any identifier at all"
                 (build-envelope "composite-refusal" (body-with pairs))))

        (arm "PLANTED" "an UNKNOWN COMPOSITE CODE, outside §5.3's five-code set")
        (let ((pairs (good-pairs)))
          (setf (cdr (nth 0 pairs)) (a-code "not-a-manifest-head"))
          (kv "planted code" "not-a-manifest-head (the WITHDRAWN R2 spelling)")
          (tooth "SCHEMA-TOOTH-UNKNOWN-CODE-REFUSED"
                 "schema tooth [R3-A]: a composite code outside the ruled FIVE-code set is REFUSED — and the code planted here is precisely the R2 witness's own withdrawn spelling, so the superseded name is shown FAILING, not merely replaced"
                 (build-envelope "composite-refusal" (body-with pairs))))

        (arm "PLANTED" "the ruled code paired with the WRONG PHASE")
        (let ((pairs (good-pairs)))
          (setf (cdr (nth 1 pairs)) (a-phase "perform"))
          (kv "planted pairing" "head-not-in-manifest / perform")
          (tooth "SCHEMA-TOOTH-WRONG-CODE-PHASE-PAIRING-REFUSED"
                 "schema tooth [R3-A]: head-not-in-manifest carried with phase (phase perform) is REFUSED — the pairing is ruled per code, so a conformant code and a conformant phase are not jointly conformant"
                 (build-envelope "composite-refusal" (body-with pairs))))

        (arm "PLANTED" "a native refusal whose DERIVED STANDING contradicts its code's total-table row")
        (let* ((body (build-body
                      (list (cons "refusal-identity" (lisp-plus-surface2:expansion-refusal-identity *s2-expansion-refusal*))
                            (cons "category"         (a-keyword (lisp-plus-surface2:expansion-refusal-category *s2-expansion-refusal*)))
                            (cons "code"             (a-keyword (lisp-plus-surface2:expansion-refusal-code *s2-expansion-refusal*)))
                            (cons "phase"            (a-keyword (lisp-plus-surface2:expansion-refusal-phase *s2-expansion-refusal*)))
                            (cons "detail"           (lisp-plus-cd0:make-string-datum "x"))
                            ;; the row rules "not-applicable"; this claims the
                            ;; standing the PHASE would have suggested
                            (cons "derived-standing" (a-standing "pre-invocation"))))))
          (kv "planted derived standing" "pre-invocation (the table rules not-applicable)")
          (tooth "SCHEMA-TOOTH-WRONG-DERIVED-STANDING-REFUSED"
                 "schema tooth [R3-A]: a derived standing that contradicts its code's row in the TOTAL table is REFUSED — the standing is per code and is never inferred from the phase"
                 (build-envelope "s2-refusal" body)))

        ;; ================================================================
        ;; THE R3.1-A ADVERSARIAL TEETH, in the ruling's own order.  Every
        ;; near-record below is BODY-REPLACING applied to a record this image
        ;; already proved lawful, so exactly one VALUE deviates and nothing
        ;; else — no key, no count, no family — moves with it.
        ;; ================================================================
        (rule)
        (arm "CLEAN" "the four RESTORED Door-1 composite codes, each with its ruled phase")
        (let ((all-five
                (loop for (code . phase) in *composite-code-phases*
                      collect (let ((pairs (good-pairs)))
                                (setf (cdr (nth 0 pairs)) (a-code code))
                                (setf (cdr (nth 1 pairs)) (a-phase phase))
                                (cons code (account-inspection-record-p
                                            (build-envelope "composite-refusal" (body-with pairs))))))))
          (dolist (r all-five)
            (kv (format nil "composite code ~A" (car r)) (if (cdr r) "RECOGNIZED" "REFUSED")))
          (probe-check "SCHEMA-DOOR-1-CODES-RESTORED"
                       "schema witness [R3.1 owner disposition — Door-1 ownership RESTORED]: all FIVE retainable composite codes are RECOGNIZED, each only with its ruled phase — the four Account-owned Door-1 codes (source-form-not-a-call, source-form-head-not-a-symbol, head-not-in-manifest, operation-not-declared, phase request) and Door 2's wrong-request-species (phase perform).  R3's consolidation of every Door-1 failure into head-not-in-manifest is withdrawn; only occurrence-tag validation reaches the selected native delegate, which returns its own refusal unchanged and therefore never appears in this key"
                       (and (= 5 (length all-five)) (every #'cdr all-five))))

        (arm "PLANTED" "each of the five composite codes carried with the OTHER phase")
        (let ((crossed
                (loop for (code . phase) in *composite-code-phases*
                      collect (let ((pairs (good-pairs))
                                    (wrong (if (string= phase "request") "perform" "request")))
                                (setf (cdr (nth 0 pairs)) (a-code code))
                                (setf (cdr (nth 1 pairs)) (a-phase wrong))
                                (account-inspection-record-p
                                 (build-envelope "composite-refusal" (body-with pairs)))))))
          (kv "crossed pairings recognized" (count t crossed))
          (probe-check "SCHEMA-TOOTH-ALL-CODE-PHASE-PAIRINGS-REFUSED"
                       "schema tooth [R3.1]: EVERY one of the five composite codes carried with the other phase is REFUSED — the pairing is ruled per code across the whole restored set, not only for the one code R3 kept"
                       (notany #'identity crossed)))

        (arm "PLANTED" "a composite record whose /0 manifest-version is 2")
        (let ((pairs (good-pairs)))
          (setf (cdr (nth 4 pairs)) (lisp-plus-cd0:make-integer-datum 2))
          (kv "planted manifest version" 2)
          (tooth "SCHEMA-TOOTH-MANIFEST-VERSION-2-REFUSED"
                 "schema tooth [R3.1-A clause 6]: /0 manifest version 2 is REFUSED — R3 checked only that the value was an integer datum, so every version passed"
                 (build-envelope "composite-refusal" (body-with pairs))))

        (arm "PLANTED" "a composite detail of 1025 payload octets, built AROUND the validator")
        (let ((pairs (good-pairs)))
          (setf (cdr (nth 2 pairs))
                (lisp-plus-cd0:make-string-datum
                 (make-string (1+ *detail-ceiling-octets*) :initial-element #\a)))
          (kv "planted detail octets" (1+ *detail-ceiling-octets*))
          (tooth "SCHEMA-TOOTH-OVERLONG-COMPOSITE-DETAIL-REFUSED"
                 "schema tooth [R3.1-A clause 7]: an overlong COMPOSITE detail — one octet above the ceiling, constructed directly so as to bypass the validator — is REFUSED BY THE RECOGNIZER too; the ceiling is part of the schema, not only of the builder"
                 (build-envelope "composite-refusal" (body-with pairs))))

        (arm "PLANTED" "a composite detail carrying standing/measured-nil")
        (let ((pairs (good-pairs)))
          (setf (cdr (nth 2 pairs)) (a-standing "measured-nil"))
          (kv "planted composite detail" "standing/measured-nil")
          (tooth "SCHEMA-TOOTH-COMPOSITE-DETAIL-MEASURED-NIL-REFUSED"
                 "schema tooth [R3.1]: measured-nil in a COMPOSITE detail is REFUSED — that standing records that a NATIVE detail was measured NIL, and an Account-built composite detail is a string the Account itself wrote, so the union member has no meaning there"
                 (build-envelope "composite-refusal" (body-with pairs))))

        ;; ---- invented dispositions and crossed operation pairings --------
        (arm "PLANTED" "the invented S1 disposition MACROEXPANDED-TO-FIXPOINT")
        (kv "planted S1 disposition" "MACROEXPANDED-TO-FIXPOINT (declared by NEITHER provider)")
        (tooth "SCHEMA-TOOTH-INVENTED-S1-DISPOSITION-REFUSED"
               "schema tooth [R3.1-A clause 5]: MACROEXPANDED-TO-FIXPOINT is REFUSED — surface1.lisp:884-885 declares exactly two S1 dispositions and this is not one of them; R3.1-A deletes the invented third name from the S1 vocabulary, so the R3 table's own entry is shown FAILING rather than quietly dropped"
               (build-envelope "s1-receipt"
                               (body-replacing s1r (list (cons "disposition" (a-keyword :macroexpanded-to-fixpoint))))))

        (arm "PLANTED" "an invented S2 disposition string")
        (kv "planted S2 disposition" "expanded-somewhat")
        (tooth "SCHEMA-TOOTH-INVENTED-S2-DISPOSITION-REFUSED"
               "schema tooth [R3.1-A clause 5]: an S2 disposition outside surface2.lisp:272-273's two measured strings is REFUSED — R3 required only that the value be a string datum, so any string at all passed"
               (build-envelope "s2-receipt"
                               (body-replacing s2r (list (cons "disposition" (lisp-plus-cd0:make-string-datum "expanded-somewhat"))))))

        (arm "PLANTED" "S1 MACROEXPAND-1 paired with MACROEXPANDED-REPEATEDLY")
        (kv "planted S1 pairing" "MACROEXPAND-1 / MACROEXPANDED-REPEATEDLY")
        (tooth "SCHEMA-TOOTH-S1-CROSSED-PAIRING-REFUSED"
               "schema tooth [R3.1-A clause 10]: a CONFORMANT S1 operation and a CONFORMANT S1 disposition that do not belong together are REFUSED — the pair is the unit"
               (build-envelope "s1-receipt"
                               (body-replacing s1r (list (cons "disposition" (a-keyword :macroexpanded-repeatedly))))))

        (arm "PLANTED" "S2 MACROEXPAND paired with \"expanded-once\"")
        (kv "planted S2 pairing" "MACROEXPAND / expanded-once")
        (tooth "SCHEMA-TOOTH-S2-CROSSED-PAIRING-REFUSED"
               "schema tooth [R3.1-A clause 10]: the mirror-image crossed S2 pairing is REFUSED for the same reason"
               (build-envelope "s2-receipt"
                               (body-replacing s2r (list (cons "operation"   (a-keyword :macroexpand))
                                                         (cons "disposition" (lisp-plus-cd0:make-string-datum "expanded-once"))))))

        ;; ---- every unlawful upstream standing ----------------------------
        (arm "PLANTED" "every §2 standing other than measured-nil, in an upstream key")
        (let* ((unlawful (remove "measured-nil" *standing-names* :test #'string=))
               (results (loop for name in unlawful
                              collect (cons name
                                            (account-inspection-record-p
                                             (build-envelope "s1-refusal"
                                                             (body-replacing s1f (list (cons "upstream-code" (a-standing name))))))))))
          (dolist (r results)
            (kv (format nil "upstream standing ~A" (car r)) (if (cdr r) "RECOGNIZED" "REFUSED")))
          (kv "unlawful upstream standings planted" (length unlawful))
          (probe-check "SCHEMA-TOOTH-UNLAWFUL-UPSTREAM-STANDINGS-REFUSED"
                       "schema tooth [R3.1-A]: EVERY §2 standing name other than measured-nil, placed in an upstream key, is REFUSED — R3's union test admitted the whole closed standing set, so not-applicable, unavailable-no-public-accessor and six others all passed there"
                       (and (= 8 (length unlawful)) (notany #'cdr results))))

        ;; ---- provider category / phase drift, code name unchanged --------
        (arm "PLANTED" "a known native code name under a DRIFTED category, then a drifted phase")
        (kv "planted category drift" "INTEGRITY-ALARM (the row rules PROTOCOL-REFUSAL)")
        (kv "planted phase drift" "RECEIPT (the row rules PERFORM)")
        (tooth "SCHEMA-TOOTH-CATEGORY-DRIFT-REFUSED"
               "schema tooth [R3.1-A clause 8]: a known code name under a DRIFTED CATEGORY is REFUSED — catalogue comparison is by complete (code, category, phase) TRIPLES, never by code-name sets"
               (build-envelope "s1-refusal"
                               (body-replacing s1f (list (cons "category" (a-keyword :integrity-alarm))))))
        (tooth "SCHEMA-TOOTH-PHASE-DRIFT-REFUSED"
               "schema tooth [R3.1-A clause 8]: and the same code name under a DRIFTED PHASE is REFUSED, for the same reason"
               (build-envelope "s1-refusal"
                               (body-replacing s1f (list (cons "phase" (a-keyword :receipt)))))))))

  ;; ---- THE ENUMERATIONS ARE CHECKED AGAINST THE PROVIDERS' OWN CATALOGS ---
  ;; A "total" enumeration transcribed by hand from a document is a claim about
  ;; the document, not about what the providers admit.  Both providers publish
  ;; their refusal catalogues, so the two are compared here — and [R3.1-A] the
  ;; comparison is by COMPLETE (code, category, phase) TRIPLES, never by
  ;; code-name sets, so that category or phase drift under an UNCHANGED code
  ;; name is caught HERE and not only by the record-level teeth above.  Every
  ;; triple is printed, both sides, so a reader can check the comparison
  ;; against the providers without trusting this file's summary of it.
  (rule)
  (arm "CLEAN" "the transcribed total enumerations against the providers' PUBLIC catalogues, as COMPLETE (code, category, phase) TRIPLES")
  (let* ((s1-entries (lisp-plus-surface1:expansion-refusal-code-catalog))
         (s2-entries (lisp-plus-surface2:surface2-refusal-code-catalog))
         (s1-live (live-catalog-triples s1-entries
                                        #'lisp-plus-surface1:refusal-catalog-entry-code
                                        #'lisp-plus-surface1:refusal-catalog-entry-class
                                        #'lisp-plus-surface1:refusal-catalog-entry-phase))
         (s2-live (live-catalog-triples s2-entries
                                        #'lisp-plus-surface2:refusal-catalog-entry-code
                                        #'lisp-plus-surface2:refusal-catalog-entry-class
                                        #'lisp-plus-surface2:refusal-catalog-entry-phase))
         (s1-doc (doc-catalog-triples *s1-refusal-catalog*))
         (s2-doc (doc-catalog-triples *s2-refusal-catalog*)))
    (kv "S1 triples: doc / provider" (format nil "~D / ~D" (length s1-doc) (length s1-live)))
    (kv "S2 triples: doc / provider" (format nil "~D / ~D" (length s2-doc) (length s2-live)))

    ;; PER-TRIPLE EVIDENCE.  One line per doc-side triple naming whether the
    ;; provider declares that EXACT triple, then one line per provider-side
    ;; triple the doc side does not carry.  A drifted column shows up as a
    ;; matched pair of lines — one ABSENT-FROM-PROVIDER and one PROVIDER-ONLY —
    ;; under one code name.
    (dolist (tr s1-doc)
      (kv "S1 doc triple" (format nil "~A  [~A]" tr
                                  (if (member tr s1-live :test #'string=)
                                      "DECLARED BY THE PROVIDER" "ABSENT FROM THE PROVIDER"))))
    (dolist (tr s1-live)
      (unless (member tr s1-doc :test #'string=)
        (kv "S1 provider-only triple" tr)))
    (dolist (tr s2-doc)
      (kv "S2 doc triple" (format nil "~A  [~A]" tr
                                  (if (member tr s2-live :test #'string=)
                                      "DECLARED BY THE PROVIDER" "ABSENT FROM THE PROVIDER"))))
    (dolist (tr s2-live)
      (unless (member tr s2-doc :test #'string=)
        (kv "S2 provider-only triple" tr)))

    (kv "S1 in doc not in provider" (format nil "~{~A~^ ; ~}" (set-difference s1-doc s1-live :test #'string=)))
    (kv "S1 in provider not in doc" (format nil "~{~A~^ ; ~}" (set-difference s1-live s1-doc :test #'string=)))
    (kv "S2 in doc not in provider" (format nil "~{~A~^ ; ~}" (set-difference s2-doc s2-live :test #'string=)))
    (kv "S2 in provider not in doc" (format nil "~{~A~^ ; ~}" (set-difference s2-live s2-doc :test #'string=)))
    (probe-check "SCHEMA-S1-ENUMERATION-TOTAL"
                 "schema witness [R3-A totality; R3.1-A triples]: the transcribed S1 enumeration is EXACTLY the set of COMPLETE (code, category, phase) TRIPLES S1's own PUBLIC catalogue declares, difference empty in both directions — so 'total over everything the predicate admits' is a measurement against the provider on all three columns, not a claim about a document and not a comparison of names"
                 (triples-agree-p s1-doc s1-live))
    (probe-check "SCHEMA-S2-ENUMERATION-TOTAL"
                 "schema witness [R3-A totality; R3.1-A triples]: and the transcribed S2 enumeration is EXACTLY S2's own PUBLIC catalogue, triple for triple — including the two classes the R2 tables could not encode"
                 (triples-agree-p s2-doc s2-live))

    ;; ---- THE TRIPLE COMPARATOR'S OWN TEETH -------------------------------
    ;; A comparator that has never been shown to fire is untested, not passing.
    ;; Each tooth drifts ONE column of ONE row of the doc table, leaves the code
    ;; name alone, and then measures BOTH comparisons: the code-name sets still
    ;; agree — so the comparison R3.1-A replaced would have accepted the drifted
    ;; table — and the triple comparison does NOT.  The teeth are the difference
    ;; between the two clauses, exhibited rather than asserted.
    (arm "PLANTED" "a doc catalogue whose CATEGORY drifted under an UNCHANGED code name, then one whose PHASE drifted")
    (let* ((drifted-code "OPERATION-NOT-DECLARED")
           (cat-table   (catalog-with-drift *s1-refusal-catalog* drifted-code 1 "INTEGRITY-ALARM"))
           (phase-table (catalog-with-drift *s1-refusal-catalog* drifted-code 2 "RECEIPT"))
           (live-codes  (catalog-code-names s1-entries #'lisp-plus-surface1:refusal-catalog-entry-code))
           (cat-codes   (sort (mapcar #'first cat-table) #'string<))
           (phase-codes (sort (mapcar #'first phase-table) #'string<))
           (cat-triples   (doc-catalog-triples cat-table))
           (phase-triples (doc-catalog-triples phase-table)))
      (kv "drifted row" drifted-code)
      (kv "planted category drift" "PROTOCOL-REFUSAL -> INTEGRITY-ALARM (code name unchanged)")
      (kv "planted phase drift" "REQUEST -> RECEIPT (code name unchanged)")
      (kv "category drift: code names" (if (equal live-codes cat-codes) "AGREE (the replaced comparison would have PASSED)" "DIFFER"))
      (kv "category drift: triples" (if (triples-agree-p cat-triples s1-live) "AGREE" "DIFFER (CAUGHT)"))
      (kv "phase drift: code names" (if (equal live-codes phase-codes) "AGREE (the replaced comparison would have PASSED)" "DIFFER"))
      (kv "phase drift: triples" (if (triples-agree-p phase-triples s1-live) "AGREE" "DIFFER (CAUGHT)"))
      (probe-check "SCHEMA-TOOTH-CATALOGUE-CATEGORY-DRIFT-CAUGHT"
                   "schema tooth [R3.1-A]: a doc catalogue whose CATEGORY drifted under an unchanged code name is CAUGHT by the catalogue comparison — and the code-name sets are shown STILL AGREEING, so this is the exact drift the replaced code-name-set comparison admitted"
                   (and (equal live-codes cat-codes)
                        (not (triples-agree-p cat-triples s1-live))))
      (probe-check "SCHEMA-TOOTH-CATALOGUE-PHASE-DRIFT-CAUGHT"
                   "schema tooth [R3.1-A]: and a drifted PHASE under an unchanged code name is CAUGHT the same way, code-name sets again agreeing — the two columns the catalogue comparison was silent about are now both measured against the provider"
                   (and (equal live-codes phase-codes)
                        (not (triples-agree-p phase-triples s1-live))))))

  ;; ---- §2's detail ceiling: refuses, never truncates ---------------------
  (rule)
  (p "SCHEMA-DETAIL-CEILING")
  (let* ((at    (make-string *detail-ceiling-octets* :initial-element #\a))
         (over  (make-string (1+ *detail-ceiling-octets*) :initial-element #\a)))
    (multiple-value-bind (d1 c1) (a-detail at)
      (multiple-value-bind (d2 c2) (a-detail over)
        (kv "at the ceiling: octets" *detail-ceiling-octets*)
        (kv "at the ceiling: datum" (family-of d1))
        (kv "above the ceiling: datum" (if d2 (family-of d2) "NONE — REFUSED"))
        (kv "above the ceiling: code" (or c2 "NONE"))
        (probe-check "SCHEMA-DETAIL-CEILING-ACCEPTS-AT-1024"
                     "schema witness: a detail string of exactly 1024 payload octets is ACCEPTED as a string datum"
                     (and (null c1) (eq :string (family-of d1))))
        (probe-check "SCHEMA-DETAIL-CEILING-REFUSES-ABOVE"
                     "schema witness: one octet above the ceiling is an Account-owned constructor-validation REFUSAL, code :detail-string-exceeds-ceiling"
                     (eq c2 :detail-string-exceeds-ceiling))
        (probe-check "SCHEMA-DETAIL-CEILING-NO-TRUNCATION"
                     "schema witness: and NO datum at all is produced above the ceiling — a truncated detail would be a lossy datum, and none is manufactured"
                     (null d2)))))

  ;; ---- R3.1 DETAIL TOTALITY: the two-stage law, arm by arm ----------------
  ;; Stage 1 (species admission) is the four native predicates, exercised in the
  ;; control arm above.  These are STAGE 2: every admitted object reaches either
  ;; one exact record or one typed Account code, and NO RAW HOST OR CD/0
  ;; CONDITION ESCAPES.  The detail values are the ones the ruling names, put
  ;; through the validator that a production inspector would use.
  (rule)
  (arm "CLEAN" "the two-stage total decision law, on the detail field")
  (let* ((surrogate (string (code-char #xd800)))
         (at-1024   (make-string *detail-ceiling-octets* :initial-element #\a))
         (at-1025   (make-string (1+ *detail-ceiling-octets*) :initial-element #\a)))
    (macrolet ((detail-arm (id label value expected-code expected-datum-p)
                 `(multiple-value-bind (d c) (a-detail ,value)
                    (kv (format nil "detail arm ~A" ,id)
                        (format nil "datum=~A code=~A"
                                (if d (family-of d) "NONE") (or c "NONE")))
                    (probe-check ,id ,label
                                 (and (eq c ,expected-code)
                                      (if ,expected-datum-p (and d t) (null d)))))))

      ;; S2 public detail NIL — a POSITIVE, not a failure.
      (detail-arm "SCHEMA-DETAIL-NIL-ENCODES-MEASURED-NIL"
                  "schema tooth [R3.1 DETAIL TOTALITY]: a native detail measured NIL is NOT a validation failure — it encodes as the mandatory absence standing measured-nil, and a record is produced"
                  nil nil t)
      ;; and the datum it produced is exactly that standing
      (multiple-value-bind (d c) (a-detail nil)
        (declare (ignore c))
        (probe-check "SCHEMA-DETAIL-NIL-IS-THE-STANDING"
                     "schema tooth [R3.1]: and the datum it produced is EXACTLY the identifier (standing measured-nil) — never a missing key, never host NIL"
                     (exact-identifier-p d '("standing" "measured-nil"))))

      (detail-arm "SCHEMA-DETAIL-INTEGER-42-REFUSED"
                  "schema tooth [R3.1]: the public detail integer 42 draws :native-detail-not-string and produces NO record — the code that excludes every non-NIL non-string value"
                  42 :native-detail-not-string nil)

      (detail-arm "SCHEMA-DETAIL-1024-ACCEPTED"
                  "schema tooth [R3.1]: a detail of exactly 1024 payload octets is ADMITTED — the ceiling is inclusive"
                  at-1024 nil t)

      (detail-arm "SCHEMA-DETAIL-1025-REFUSED"
                  "schema tooth [R3.1]: 1025 payload octets draws :detail-string-exceeds-ceiling — never truncation, and no datum at all"
                  at-1025 :detail-string-exceeds-ceiling nil)

      (detail-arm "SCHEMA-DETAIL-NON-CD0-SCALAR-REFUSED"
                  "schema tooth [R3.1]: a host string carrying a NON-CD/0 SCALAR — a lone surrogate code point, which CD/0's own host-import law rejects as InvalidHostUnicode — draws :native-detail-not-cd0-scalar-string, and the CD/0 condition does NOT escape as a raw host condition: it is caught and returned as a typed Account code"
                  surrogate :native-detail-not-cd0-scalar-string nil))

    ;; The no-raw-escape clause, stated as its own measurement rather than
    ;; inferred from the arms above: the validator is handed each unlawful value
    ;; inside a handler that would CATCH any escaping condition, and none fires.
    (let ((escaped nil))
      (dolist (v (list 42 surrogate at-1025 (list :not-a-string)))
        (handler-case (a-detail v)
          (condition (c) (push (format nil "~A" (type-of c)) escaped))))
      (kv "raw conditions escaping the validator" (if escaped (format nil "~{~A~^ ~}" escaped) "NONE"))
      (probe-check "SCHEMA-DETAIL-NO-RAW-HOST-ESCAPE"
                   "schema tooth [R3.1 two-stage law]: NO raw host or CD/0 condition escapes Account field validation — four unlawful detail values, including one CD/0 refuses outright and one that is not a string at all, each returned a typed Account code and signalled nothing"
                   (null escaped))))

  ;; ---- R3.2: THE TWO DETAIL MEMBERS AS *COMPLETE RECOGNIZED RECORDS* ------
  ;;
  ;; WHAT THE R3.1 RETURN SAID, and it was right: "NIL/1024 witnesses validate a
  ;; DATUM, not a complete recognized record."  Every arm above measures
  ;; A-DETAIL — the field validator — and a field validator's verdict is not a
  ;; record's standing.  A schema whose detail cell is a two-member union is
  ;; only shown TOTAL when a COMPLETE record carrying EACH member is built and
  ;; then RECOGNIZED by the §7 predicate, encoded, decoded and re-encoded.
  ;;
  ;; THE BRANCH IS A NATIVE-REFUSAL ONE, and that is not a convenience.  §5.3
  ;; states the per-branch exactness: branch 5's detail is the scalar-string
  ;; member ONLY, because a composite detail is a string the Account itself
  ;; wrote and there is no measured native NIL to encode there — the standing
  ;; member is unreachable in that branch and is planted and refused above
  ;; (SCHEMA-TOOTH-COMPOSITE-DETAIL-MEASURED-NIL-REFUSED).  So the union's two
  ;; members are exhibited where the law puts them: on s2-refusal (§5.2), whose
  ;; detail cell inherits §5.1's union exactly.
  ;;
  ;; EXACTLY ONE VALUE MOVES.  Both records are BODY-REPLACING applied to the
  ;; s2-refusal body this image already proved lawful, so no key, count, family
  ;; or enum shifts beside the detail — the difference measured is the union
  ;; member and nothing else.
  (rule)
  (p "SCHEMA-DETAIL-FULL-RECORD")
  (arm "CLEAN" "each detail union member carried in a COMPLETE record on a NATIVE-refusal branch, recognized and round-tripped")
  (let* ((nil-detail (a-detail nil))
         (str-1024   (a-detail (make-string *detail-ceiling-octets* :initial-element #\a)))
         (rec-nil    (build-envelope "s2-refusal"
                                     (body-replacing s2f (list (cons "detail" nil-detail)))))
         (rec-1024   (build-envelope "s2-refusal"
                                     (body-replacing s2f (list (cons "detail" str-1024)))))
         (dec-nil    (lisp-plus-cd0:decode-exact (lisp-plus-cd0:encode-exact rec-nil)))
         (dec-1024   (lisp-plus-cd0:decode-exact (lisp-plus-cd0:encode-exact rec-1024))))
    (kv "member 1 detail datum" (family-of (record-value-named
                                            (record-value-named rec-nil "body") "detail")))
    (kv "member 2 detail octets" (string-datum-payload-octets
                                  (record-value-named
                                   (record-value-named rec-1024 "body") "detail")))
    (kv "member 1 record keys" (format nil "~{~A~^ ~}" (record-key-names rec-nil)))
    (kv "member 2 record keys" (format nil "~{~A~^ ~}" (record-key-names rec-1024)))
    (kv "member 1 recognized" (if (account-inspection-record-p rec-nil) "YES" "NO"))
    (kv "member 2 recognized" (if (account-inspection-record-p rec-1024) "YES" "NO"))

    (probe-check "SCHEMA-DETAIL-FULL-RECORD-MEASURED-NIL"
                 "schema witness [R3.2 return — detail totality]: a COMPLETE fixed-schema s2-refusal record whose detail is the union's ABSENCE member, the identifier (standing measured-nil), is RECOGNIZED by ACCOUNT-INSPECTION-RECORD-P — not merely a datum the field validator admitted, but a whole record the §7 comparison law accepts, its six body keys and every enum unchanged beside it"
                 (and (exact-identifier-p (record-value-named
                                           (record-value-named rec-nil "body") "detail")
                                          '("standing" "measured-nil"))
                      (account-inspection-record-p rec-nil)))
    (probe-check "SCHEMA-DETAIL-FULL-RECORD-MEASURED-NIL-ROUND-TRIP"
                 "schema witness [R3.2]: and that whole record survives encode-exact -> decode-exact as an EQUAL-DATUM record which is ITSELF recognized — the absence member travels through the wire form, and is not a shape that only the builder can hold"
                 (and (lisp-plus-cd0:equal-datum rec-nil dec-nil)
                      (account-inspection-record-p dec-nil)))
    (probe-check "SCHEMA-DETAIL-FULL-RECORD-MEASURED-NIL-CANONICAL"
                 "schema witness [R3.2]: and the decoded record RE-ENCODES to byte-identical canonical octets — the absence member has exactly one canonical spelling"
                 (equalp (lisp-plus-cd0:octets-to-hex (lisp-plus-cd0:canonical-octets dec-nil))
                         (lisp-plus-cd0:octets-to-hex (lisp-plus-cd0:canonical-octets rec-nil))))

    (probe-check "SCHEMA-DETAIL-FULL-RECORD-1024"
                 "schema witness [R3.2 return — detail totality]: a COMPLETE s2-refusal record whose detail is the union's STRING member at EXACTLY the 1024-octet ceiling is RECOGNIZED by ACCOUNT-INSPECTION-RECORD-P — the inclusive ceiling is now proved at record level, where R3.1 proved it only at datum level"
                 (and (= *detail-ceiling-octets*
                         (string-datum-payload-octets
                          (record-value-named (record-value-named rec-1024 "body") "detail")))
                      (account-inspection-record-p rec-1024)))
    (probe-check "SCHEMA-DETAIL-FULL-RECORD-1024-ROUND-TRIP"
                 "schema witness [R3.2]: and that record round-trips to an EQUAL-DATUM record which is itself recognized — a 1024-octet detail is carried by the wire form without truncation or re-shaping"
                 (and (lisp-plus-cd0:equal-datum rec-1024 dec-1024)
                      (account-inspection-record-p dec-1024)))
    (probe-check "SCHEMA-DETAIL-FULL-RECORD-1024-CANONICAL"
                 "schema witness [R3.2]: and it re-encodes to byte-identical canonical octets"
                 (equalp (lisp-plus-cd0:octets-to-hex (lisp-plus-cd0:canonical-octets dec-1024))
                         (lisp-plus-cd0:octets-to-hex (lisp-plus-cd0:canonical-octets rec-1024))))

    ;; THE BOUNDARY, BOTH SIDES.  The constructor first: at 1025 the validator
    ;; yields NO DATUM, so no complete record can be built THROUGH it at all.
    (multiple-value-bind (d1025 c1025)
        (a-detail (make-string (1+ *detail-ceiling-octets*) :initial-element #\a))
      (kv "at 1025: datum" (if d1025 (family-of d1025) "NONE"))
      (kv "at 1025: code" (or c1025 "NONE"))
      (probe-check "SCHEMA-DETAIL-FULL-RECORD-1025-NO-RECORD"
                   "schema witness [R3.2]: at 1025 payload octets the validator yields NO DATUM AT ALL and the code :detail-string-exceeds-ceiling, so no complete record carrying that detail can be built through the constructor — the 1024/1025 boundary is exact on the building side"
                   (and (null d1025) (eq c1025 :detail-string-exceeds-ceiling))))

    ;; And the recognizer: a record forged AROUND the validator must still be
    ;; refused, or the ceiling would be a property of the builder alone.
    (arm "PLANTED" "a NATIVE-refusal record whose detail is 1025 payload octets, built AROUND the validator")
    (let* ((over (lisp-plus-cd0:make-string-datum
                  (make-string (1+ *detail-ceiling-octets*) :initial-element #\a)))
           (forged (build-envelope "s2-refusal"
                                   (body-replacing s2f (list (cons "detail" over))))))
      (kv "forged detail octets" (string-datum-payload-octets over))
      (kv "forged record recognized" (if (account-inspection-record-p forged) "YES" "NO"))
      (probe-check "SCHEMA-DETAIL-FULL-RECORD-1025-REFUSED"
                   "schema tooth [R3.2]: the same complete record with ONE octet more of detail — constructed directly so as to bypass the validator — is REFUSED by ACCOUNT-INSPECTION-RECORD-P, while the 1024 record one line above was recognized; so the two acceptances are a measurement of the boundary and not a habit of the predicate"
                   (and (not (account-inspection-record-p forged))
                        (account-inspection-record-p rec-1024)))))

  ;; ---- what this witness CANNOT exercise, said plainly -------------------
  (rule)
  (p "DEFERRED TO THE PRODUCTION GATE — NOT PASSED, AND NOT VOID EITHER.")
  (p "  The R3 adjudication's OWNER DISPOSITION OF THE R2 VOID rules exactly this:")
  (p "  the actual ACCOUNT-REFUSAL-P behaviour and the typed")
  (p "  :not-an-admitted-account-object condition CANNOT BE EXECUTED before the")
  (p "  prohibited production package exists, so the four native-predicate")
  (p "  non-admission measurements are ACCEPTED for this contract round and the")
  (p "  ACCOUNT-SIDE PREDICATE AND TYPED-CONDITION TOOTH IS MOVED INTO THE")
  (p "  MANDATORY PRODUCTION GATE (R4-SURVIVAL-PLAN.md, section 4(h5)).")
  (p "  NO CLAIM IS MADE HERE THAT THE ACCOUNT-SIDE TOOTH ALREADY PASSED.  What")
  (p "  is discharged is the half that can be: the record is refused by all four")
  (p "  NATIVE admission predicates, and those predicates are shown accepting")
  (p "  their own genuine objects in the same image.  ACCOUNT-INSPECTION-RECORD-P")
  (p "  above is this probe's non-production transcription of the schema file's")
  (p "  section 7 comparison law; it is not the production predicate and does not")
  (p "  stand in for it.")

  ;; ---- the deviation count, printed then checked -------------------------
  (rule)
  ;; ---- THE DETECTOR'S OWN TOOTH ----------------------------------------
  ;; A zero from a detector that has never fired is worth nothing.  The same
  ;; function is handed a deliberately MIS-DECLARED spec — one row whose doc
  ;; column claims :identifier where the measurement says :bytes, which is
  ;; exactly the disagreement the erratum closed — and must report it.  It
  ;; writes to no global, so the real count below is untouched.
  (arm "PLANTED" "the doc/measurement detector is handed a deliberately mis-declared spec row")
  (let ((caught (deviations-in "planted-branch"
                               '(("refusal-identity" :bytes      :identifier t)
                                 ("category"         :identifier :identifier nil)))))
    (dolist (d caught)
      (kv "planted deviation caught"
          (format nil "~A ~A doc=~A measured=~A" (first d) (second d) (third d) (fourth d))))
    (kv "planted deviations found" (length caught))
    (probe-check "SCHEMA-DOC-DEVIATION-DETECTOR-BITES"
                 "schema tooth: handed one deliberately mis-declared row the doc/measurement detector REPORTS it, and passes the agreeing row — so the zero it reports for the real specs is a measurement, not a habit"
                 (and (= 1 (length caught))
                      (equal (second (first caught)) "refusal-identity")
                      (eq (third (first caught)) :identifier)
                      (eq (fourth (first caught)) :bytes))))

  (kv "doc-deviation count" (length *doc-deviations*))
  (dolist (d (reverse *doc-deviations*))
    (kv "  deviation" (format nil "~A ~A doc=~A measured=~A" (first d) (second d) (third d) (fourth d))))
  (probe-check "SCHEMA-DOC-DEVIATIONS-ENUMERATED"
               "schema witness: ZERO keys disagree — every branch's MEASURED datum species matches what CD0-INSPECTION-RECORD-SCHEMA.md declares, and the detector is shown biting one line above, so this zero is a measurement"
               (zerop (length *doc-deviations*)))

  (probe-check "SCHEMA-WITNESS-ALL-FIVE-BRANCHES"
               "schema witness: one genuinely lawful instance of every one of the five current branches was constructed and proved under the TOTALIZED schema, plus the two formerly-unencodable S2 classes and BOTH locked S1 STOP cells as further lawful instances — nine records in all"
               (= 9 (length built))))

(when (plant-failure-requested-p)
  (probe-check "SCHEMA-WITNESS-PLANTED-FAULT" "PLANTED FAULT: this check is designed to fail" nil))

(probe-footer "SCHEMA-WITNESS")
(probe-exit)
