;;;; APPLICATION.lisp — de vadimonio: concerning the undertaking to appear.
;;;;
;;;; AN APPLICATION-PRIVATE SPECIMEN.  Not Language Obligation /0, and it does
;;;; not open that name: LANGUAGE-FORM-1-WORK-ORDER.md:19 carries "Language
;;;; Obligation /0: NOT opened", and Form /1 §18 and Form /2 §16 both list it
;;;; among explicit non-goals.  Nothing here reverses those reservations.
;;;; Nothing here is exported from any governing package, nothing earns public
;;;; standing, and no governing layer is modified.
;;;;
;;;; THE SINGLE QUESTION:
;;;;
;;;;   Form /2's own law is that a rewritten successor INHERITS NOTHING and must
;;;;   re-enter the proposal pipeline "as though no predecessor existed".  The
;;;;   layers are deliberately amnesiac across that boundary.  Can an author's
;;;;   explicit undertaking — that this exact successor will be carried through
;;;;   Form /1 re-entry — remain identifiable and open across unrelated
;;;;   intervening work, be refused by merely similar witnesses, be discharged
;;;;   only by the exact one, and keep a truthful record of failed appearances
;;;;   that no later success rewrites — without a new language layer, without
;;;;   mutating any object from :OWED to :APPEARED, and without the substrate
;;;;   ever consulting it?
;;;;
;;;; WHAT THE SHAPE IS BORROWED FROM, AND AT WHAT REMOVE.  Kernel /0's
;;;; unresolved effect carries no resolved flag ("no record-local resolved flag
;;;; exists" — kernel0/uncertain-effect.lisp:52) and openness is derived by
;;;; FOLDING events; a reconciliation resolves only when the result is
;;;; determinate AND residue is NIL (kernel0/folds.lisp:421).  de-pignore
;;;; (language-slice-2/de-pignore/APPLICATION.lisp) reproduced that shape over a
;;;; non-effect subject; THIS specimen reproduces de-pignore's shape at second
;;;; remove, over a structurally different subject.  No Kernel /0 record type is
;;;; imported and no Kernel /0 office — attempt, seat, frontier, retry safety,
;;;; supersession, acknowledgment class, request identity, cancellation — is
;;;; touched.  The subject is not an effect and crosses no image boundary.
;;;;
;;;; WHAT IS BORROWED FROM WHERE, EXHAUSTIVELY:
;;;;
;;;;   * the FOLD SHAPE and the OCCURRENCE/CONTENT identity split, and the
;;;;     defensive-snapshot boundary, and the planted-receipt teeth discipline
;;;;     — from de-pignore, itself from Kernel /0 as cited above;
;;;;   * the LIVE FIXTURE WORLD (schema, admission contract, witnesses, sealed
;;;;     resolution context, the support-slot path datum, the submission call)
;;;;     — from ../de-forma-mutata/APPLICATION.lisp, lines 97–202 and 274–279,
;;;;     which took it in turn from de-forma-petente as executable precedent.
;;;;     Three support references are bound here where that file bound two.
;;;;
;;;; DECLARED SCOPE RESTRICTIONS.  Narrowed, deliberately, to:
;;;;   one Form /2 REPLACE-AT-PATH receipt as the opening subject ·
;;;;   one Form /1 grammar and one Form /1 policy, both as they stand in this
;;;;   image · recognition by EXACT identity plus retained expectations, with no
;;;;   second relation of any kind · no wall-clock, no term, no expiry ·
;;;;   every caller-supplied semantic input is a CD/0 DATUM, never a host value.
;;;;   That last restriction is STRICTER than de-pignore's, which accepted host
;;;;   lists as intent and scope; it is stated because it changes what the
;;;;   snapshot boundary is for (see §0).
;;;;
;;;; WHAT THIS SPECIMEN DOES NOT SHOW (declared before building; DESIGN-NOTE §10):
;;;;   * NO PERSISTENCE, REPLAY OR CROSS-IMAGE CLAIM.  The fold consumes a
;;;;     caller-supplied ordered list.  There is no store.  PJ0 is adopted as a
;;;;     spec; no journal store is wired into the in-memory core.
;;;;   * NO GLOBAL EXACTLY-ONCE.  :ALREADY-APPEARED is enforceable only relative
;;;;     to the supplied history; a caller who omits the receipt can obtain
;;;;     another.  DEMONSTRATED below, not solved with a registry.
;;;;   * NO AUTHORITY, TRUTH, STANDING OR MINTED BASIS.  Form /1 alone validated
;;;;     the successor.  An appearance receipt grants no claim, mints no basis,
;;;;     does not make the successor lawful and does not entitle submission.
;;;;   * NO ENFORCEMENT.  The substrate never consults a vadimonium; the gate
;;;;     lives in the author's program.  This is a feature, and it is proven by
;;;;     a control rather than excused.
;;;;   * NO WALL-CLOCK.  A vadimonium has no term, no expiry and no scheduler.
;;;;     The Roman DIES CERTUS is exactly the part not taken: nothing here is
;;;;     governed by time, only by succession.
;;;;   * NO SECOND RELATION.  Recognition is exact identity plus retained
;;;;     expectations.  No pattern language, no predicate parameter, no
;;;;     callback: a CD/0 datum cannot be a function, and no caller-supplied
;;;;     procedure reaches any surface in this file.
;;;;   * NO BINDING BETWEEN A DESERTION AND THE SUCCESSOR IT SPEAKS OF.
;;;;     RECORD-DESERTION type-checks that its evidence IS a Form /1 petition
;;;;     refusal.  It does NOT — and with Form /1's public reader surface
;;;;     cannot — check that the refusal is the one THIS vadimonium's successor
;;;;     met.  A refusal of an entirely different datum therefore records
;;;;     cleanly: CROSS-DESERTION.  This is DEMONSTRATED below rather than
;;;;     solved, and it is the third unenforceable in this file, beside replayed
;;;;     act identifiers and global exactly-once.  UNDERTAKE binds its successor
;;;;     to its receipt and PRESENT binds its witness to the awaited subject;
;;;;     DESERT binds nothing, and says so here rather than in a label.  The
;;;;     record is an account of what an author says happened.
;;;;   * NO PARTIAL RESIDUE.  Appearance is structurally all-or-nothing — a
;;;;     validated form either exhibits the exact subject identity or it does
;;;;     not.  No partial case was invented to populate the residue field.
;;;;   * NO EXTERNAL CORROBORATION.  Every green below is same-family
;;;;     self-consistency certification.  A stranger audit is OWED.
;;;;
;;;; Run: sbcl --non-interactive --load APPLICATION.lisp

(eval-when (:compile-toplevel :load-toplevel :execute)
  (let ((here (or *load-truename* *default-pathname-defaults*))
        (*error-output* (make-broadcast-stream)))
    (handler-bind ((style-warning #'muffle-warning))
      (load (merge-pathnames "../form2.lisp" here))
      (load (merge-pathnames "../../language-form-1/form1.lisp" here)))))

(defpackage #:de-vadimonio (:use #:common-lisp))
(in-package #:de-vadimonio)

;;; ==================================================================
;;; 0a.  THE EXTERNAL-SYMBOL GATE
;;;
;;; The abbreviation macros below resolve a name in a governing package.  INTERN
;;; would happily reach a PRIVATE symbol, which is double-colon access wearing a
;;; convenience.  So the gate is CODE, not a promise: a name that is not
;;; EXTERNAL in its package is a macroexpansion-time error, and this file cannot
;;; be loaded at all if it names one.  The gate also keeps a census, so the
;;; harness can report exactly how many governing names were used and assert
;;; every one of them was external.

(defvar *external-names* '())

(defun %external-symbol (name package-designator)
  (let ((package (or (find-package package-designator)
                     (error "package ~A is not loaded" package-designator))))
    (multiple-value-bind (symbol status) (find-symbol (string name) package)
      (unless symbol
        (error "~A names no symbol in ~A" name (package-name package)))
      (unless (eq status :external)
        (error "~A is not EXTERNAL in ~A; this file may use public exports only"
               name (package-name package)))
      (pushnew (cons (package-name package) (symbol-name symbol)) *external-names*
               :test #'equal)
      symbol)))

(defmacro f1 (name &rest args) `(,(%external-symbol name '#:lisp-plus-form1) ,@args))
(defmacro f2 (name &rest args) `(,(%external-symbol name '#:lisp-plus-form2) ,@args))
(defmacro cd0 (name &rest args) `(,(%external-symbol name '#:lisp-plus-cd0) ,@args))
(defmacro s0 (name &rest args) `(,(%external-symbol name '#:lisp-plus-slice0) ,@args))
(defmacro s1 (name &rest args) `(,(%external-symbol name '#:lisp-plus-slice1) ,@args))
(defmacro s2 (name &rest args) `(,(%external-symbol name '#:lisp-plus-slice2) ,@args))
(defmacro k0 (name &rest args) `(,(%external-symbol name '#:lisp-plus-kernel0) ,@args))

;;; ==================================================================
;;; 0b.  THE SNAPSHOT BOUNDARY
;;;
;;; Adopted from de-pignore §0 (which adopted it after a review found a
;;; PRIN1-TO-STRING / READ-FROM-STRING "canonical" form that leaked
;;; PRINT-NOT-READABLE, rejected CD/0 data, and failed to terminate on a
;;; circular cons).  There is no printer, no reader, no READ-EVAL path and no
;;; PRINT-OBJECT method anywhere in this file's identity or comparison paths.
;;;
;;; WHAT IT IS FOR HERE IS NARROWER THAN IN DE-PIGNORE.  Every caller-supplied
;;; SEMANTIC input to this file is a CD/0 datum, so this copier never meets
;;; caller garbage on a semantic path.  It exists to defend the HOST-SIDE
;;; AGGREGATES this file assembles for inspection — retained expectations,
;;; witness facts, refusal facts, offending descriptors — so that a caller
;;; holding only a reader cannot move a value the fold or a record depends on.
;;;
;;; Kernel /0 DURABLE-IDENTITY is deliberately NOT in the vocabulary: de-pignore
;;; admitted it because its subject carried one; no value reaching this copier
;;; is one, and a vocabulary entry with no inhabitant is a decision nobody made.
;;;
;;; The word "canonical" is reserved for actual Canonical Datum /0 values.  What
;;; this produces is a DEFENSIVE SNAPSHOT.

(define-condition unsupported-snapshot-value (error)
  ((value :initarg :value :reader unsupported-snapshot-value-value)
   (why   :initarg :why   :reader unsupported-snapshot-value-why))
  (:report (lambda (c s) (format s "unsupported value in snapshot: ~A"
                                 (unsupported-snapshot-value-why c)))))

(defparameter +snapshot-depth-limit+ 64)

(defun %snapshot (x &optional (depth 0) (seen nil))
  "Bounded defensive copy over a STRICT private vocabulary.
Accepted leaves: NIL, keyword, symbol, integer, ratio, character, string, and
any CD/0 DATUM (accepted opaquely and BY REFERENCE — a datum is already an
immutable identity-bearing value whose interior CD/0 copies on access).
Everything else, and any cycle, and any nesting past the depth limit, is a TYPED
refusal that ESCAPES."
  (when (> depth +snapshot-depth-limit+)
    (error 'unsupported-snapshot-value :value x
           :why "nesting deeper than the snapshot depth limit"))
  (cond
    ((null x) nil)
    ((keywordp x) x)
    ((symbolp x) x)
    ((integerp x) x)
    ((rationalp x) x)
    ((characterp x) x)
    ((stringp x) (copy-seq x))
    ((cd0 datum-p x) x)
    ((consp x)
     (when (member x seen :test #'eq)
       (error 'unsupported-snapshot-value :value x :why "circular structure"))
     (let ((seen (cons x seen)))
       (cons (%snapshot (car x) (1+ depth) seen)
             (%snapshot (cdr x) (1+ depth) seen))))
    (t (error 'unsupported-snapshot-value :value x
              :why "outside the snapshot vocabulary"))))

(defun %type-label (x)
  "A snapshot-safe descriptor of a host object's type.  Never a printed
rendering of the object: an arbitrary host object has no canonical content, and
pretending otherwise is the substitution defect with a printer attached."
  (let ((type (type-of x)))
    (if (symbolp type) type :unnamed-host-type)))

;;; ==================================================================
;;; 0c.  IDENTITY VALUES
;;;
;;; The %IDENTITY idiom, taken verbatim in shape from form1.lisp:189 and
;;; form2.lisp:63 — an immutable CD/0 BYTE-STRING datum holding the EXACT
;;; canonical octets of a payload datum.  It is not hexadecimal, not a printed
;;; rendering, not a digest and not a hash.  Identity equality is exact CD/0
;;; datum equality, EQUAL-DATUM, everywhere in this file.  Hex appears exactly
;;; once, in a DIAGNOSTIC printer that no comparison consults.

(defun %text (s) (cd0 make-string-datum s))
(defun %int (n) (cd0 make-integer-datum n))
(defun %seq (list) (cd0 make-sequence-datum list))
(defun %id (namespace path) (cd0 make-identifier-datum namespace path))
(defun %unit () (cd0 make-unit-datum))
(defun %octets (d) (cd0 canonical-octets d))
(defun %identity (payload) (cd0 make-bytes-datum (%octets payload)))
(defun %same (a b) (cd0 equal-datum a b))

(defun %hex (d)
  "DIAGNOSTIC ONLY.  No identity, comparison or fold path reads this."
  (cd0 octets-to-hex (%octets d)))

(defun %procedure-identity () (%id '("de-vadimonio") '("procedure" "vadimonium")))
(defparameter +procedure-version+ 1)

;;; ------------------------------------------------------------------
;;; The occurrence / content identity split, adopted from de-pignore as SEALED
;;; VOCABULARY and not renamed (DESIGN-NOTE §6, §11):
;;;
;;;   occurrence-identity = (:vadimonium-act-id ACT :content CONTENT-IDENTITY)
;;;   content-identity    = intent · transformation-receipt identity ·
;;;                         awaited subject identity · scope ·
;;;                         retained grammar id/version ·
;;;                         retained policy id/version
;;;
;;; DEVIATION FROM THE DESIGN NOTE'S ENUMERATION, declared: the content identity
;;; additionally carries a SPECIES TAG and this file's PROCEDURE IDENTITY and
;;; VERSION.  §6 enumerates the semantic components; de-pignore's sealed
;;; vocabulary carried the procedure too.
;;;
;;; WHAT THIS BUYS, CORRECTED AFTER CENSOR F-2.  The first round claimed this
;;; was "strictly stronger" than de-pignore's eight-conjunct fold.  That was
;;; two claims fused, and only one was true.  Embedding the procedure here is
;;; strictly stronger about VADIMONIUM IDENTITY: two vadimonia differing only in
;;; the procedure that made them cannot share a content identity, so a receipt
;;; computed under a foreign procedure cannot close.  It said NOTHING about
;;; RECEIPT ANATOMY, and there the first round was strictly WEAKER than
;;; de-pignore: a receipt that copied the correct identity bytes while DECLARING
;;; a foreign procedure in its own slots closed happily (CENSOR probe A1), as
;;; did one declaring :previous-commitment :never-owed (A2).  Those three
;;; receipt slots are now fold conjuncts too (§III), at de-pignore parity, and
;;; each is planted to bite.
;;;
;;; What remains unpoliced, and always will be: a receipt that copies EVERY
;;; field correctly closes.  The fold reads DECLARED anatomy, never provenance.
;;; That is the tree's own doctrine — a receipt is an ACCOUNT, not an
;;; AUTHENTICATION — and it is demonstrated below rather than left to a reader.

(defun %content-identity (&key intent receipt-identity awaited-subject-identity
                               scope grammar-identity grammar-version
                               policy-identity policy-version)
  (%identity
   (%seq (list (%text ":de-vadimonio/vadimonium-content")
               (%procedure-identity)
               (%int +procedure-version+)
               intent
               receipt-identity
               awaited-subject-identity
               scope
               grammar-identity (%int grammar-version)
               policy-identity (%int policy-version)))))

(defun %occurrence-identity (act-id content-identity)
  (%identity (%seq (list (%text ":de-vadimonio/vadimonium-occurrence")
                         act-id
                         content-identity))))

;;; ==================================================================
;;; I.  THE THREE APPLICATION-PRIVATE RECORDS, AND THE REFUSAL
;;;
;;; Absent by design, each for a stated reason:
;;;   OPEN-VADIMONIUM / DISCHARGED-VADIMONIUM — openness is FOLDED; the same
;;;     object stays in history after the appearance, so openness must not be in
;;;     the type name.
;;;   VADIMONIUM-STATUS — no mutable status field is permitted anywhere.
;;;   VADIMONIUM-REGISTRY — the fold takes its events as an argument.
;;;   APPEARANCE-ATTEMPT — the attempt IS the transition; its result is a
;;;     receipt or a refusal, and no fourth persistent object was needed.
;;;
;;; NAMING.  It is an APPEARANCE-RECEIPT, never a "discharge" receipt:
;;; "discharge" is Slice /1 premise vocabulary, and a name claiming discharge
;;; would let the label impersonate the event.
;;;
;;; Every slot is :READ-ONLY.  Every copier is NIL.  Every constructor is
;;; private.  No writer is defined anywhere in this file.

(defstruct (vadimonium (:constructor %make-vadimonium) (:copier nil)
                       (:conc-name %vadimonium-))
  (occurrence-identity        nil :read-only t)   ; WHICH undertaking act
  (content-identity           nil :read-only t)   ; WHAT was undertaken
  (act-id                     nil :read-only t)
  (intent                     nil :read-only t)
  (scope                      nil :read-only t)
  (transformation-receipt-identity nil :read-only t)
  (awaited-subject-identity   nil :read-only t)
  (retained-expectations      nil :read-only t)   ; host plist, snapshotted
  (procedure-identity         nil :read-only t)
  (procedure-version          nil :read-only t))

(defstruct (appearance-receipt (:constructor %make-appearance-receipt) (:copier nil)
                               (:conc-name %appearance-))
  (identity                   nil :read-only t)   ; its OWN identity
  (target-occurrence-identity nil :read-only t)
  (target-content-identity    nil :read-only t)
  (witness-facts              nil :read-only t)   ; host plist, snapshotted
  (previous-commitment        nil :read-only t)
  (resulting-commitment       nil :read-only t)
  (residue                    nil :read-only t)
  (procedure-identity         nil :read-only t)
  (procedure-version          nil :read-only t))

(defstruct (desertion-record (:constructor %make-desertion-record) (:copier nil)
                             (:conc-name %desertion-))
  (identity                   nil :read-only t)
  (target-occurrence-identity nil :read-only t)
  (target-content-identity    nil :read-only t)
  (act-id                     nil :read-only t)
  (refusal-facts              nil :read-only t)   ; host plist, snapshotted
  (previous-commitment        nil :read-only t)
  (resulting-commitment       nil :read-only t)
  (procedure-identity         nil :read-only t)
  (procedure-version          nil :read-only t))

(defstruct (vadimonium-refusal (:constructor %make-vadimonium-refusal) (:copier nil)
                               (:conc-name %refusal-))
  (phase                      nil :read-only t)   ; :UNDERTAKE :PRESENT :DESERT
  (target-occurrence-identity nil :read-only t)
  (reason                     nil :read-only t)
  (detail                     nil :read-only t)
  (offending                  nil :read-only t))  ; host plist, snapshotted

;;; ------------------------------------------------------------------
;;; APPLICATION-FACING READERS.
;;;
;;; :READ-ONLY slots prevent slot REPLACEMENT.  They do NOT make a mutable value
;;; reachable through a reader immutable — de-pignore's second review found all
;;; six of its aggregate readers aliasing, so that a caller holding only a
;;; reader could move BOTH SIDES of the fold's comparison at once.  Every
;;; AGGREGATE-valued reader below therefore returns a DEFENSIVE SNAPSHOT.
;;; Internal % accessors still hand exact objects to trusted implementation
;;; code, which is where structure sharing is correct.
;;;
;;; Identity-valued readers return the stored CD/0 datum by reference.  That is
;;; safe for a reason this file DOES NOT OWN: CD/0 copies on access
;;; (cd0.lisp:772-774).  The tooth for it says so.

(defun vadimonium-occurrence-identity (v) (%vadimonium-occurrence-identity v))
(defun vadimonium-content-identity (v) (%vadimonium-content-identity v))
(defun vadimonium-act-id (v) (%vadimonium-act-id v))
(defun vadimonium-intent (v) (%vadimonium-intent v))
(defun vadimonium-scope (v) (%vadimonium-scope v))
(defun vadimonium-transformation-receipt-identity (v)
  (%vadimonium-transformation-receipt-identity v))
(defun vadimonium-awaited-subject-identity (v) (%vadimonium-awaited-subject-identity v))
(defun vadimonium-retained-expectations (v)
  (%snapshot (%vadimonium-retained-expectations v)))

(defun appearance-receipt-identity (r) (%appearance-identity r))
(defun appearance-receipt-target-occurrence (r) (%appearance-target-occurrence-identity r))
(defun appearance-receipt-target-content (r) (%appearance-target-content-identity r))
(defun appearance-receipt-witness-facts (r) (%snapshot (%appearance-witness-facts r)))
(defun appearance-receipt-previous-commitment (r) (%appearance-previous-commitment r))
(defun appearance-receipt-resulting-commitment (r) (%appearance-resulting-commitment r))
(defun appearance-receipt-residue (r) (%snapshot (%appearance-residue r)))

(defun desertion-record-identity (d) (%desertion-identity d))
(defun desertion-record-target-occurrence (d) (%desertion-target-occurrence-identity d))
(defun desertion-record-target-content (d) (%desertion-target-content-identity d))
(defun desertion-record-act-id (d) (%desertion-act-id d))
(defun desertion-record-refusal-facts (d) (%snapshot (%desertion-refusal-facts d)))
(defun desertion-record-resulting-commitment (d) (%desertion-resulting-commitment d))

(defun vadimonium-refusal-phase (r) (%refusal-phase r))
(defun vadimonium-refusal-reason (r) (%refusal-reason r))
(defun vadimonium-refusal-detail (r) (%refusal-detail r))
(defun vadimonium-refusal-target-occurrence (r) (%refusal-target-occurrence-identity r))
(defun vadimonium-refusal-offending (r) (%snapshot (%refusal-offending r)))

;;; ------------------------------------------------------------------
;;; THE ADVERTISED REFUSAL VOCABULARY, and the census that keeps it honest.
;;;
;;; de-pignore's fourth review defect: a "menu of accepted reasons" let a
;;; PHANTOM survive inside it — a code no executable path emits.  Every reason
;;; below is recorded when emitted, and the last check of the run asserts the
;;; advertised set and the emitted set are EQUAL IN BOTH DIRECTIONS.

(defparameter +advertised-refusal-reasons+
  '(;; phase :UNDERTAKE
    :no-undertaking-act
    :no-elected-intent
    :no-scope-description
    :not-a-transformation-receipt
    :successor-not-a-datum
    :successor-identity-mismatch
    ;; phase :PRESENT
    :not-a-vadimonium
    :already-appeared
    :not-a-validated-form
    :subject-identity-mismatch
    :retained-grammar-mismatch
    :retained-policy-mismatch
    ;; phase :DESERT
    :no-desertion-act
    :not-a-petition-refusal))

(defvar *emitted-reasons* (make-hash-table :test #'eq))

(defun %refuse (phase target reason detail &optional offending-plist)
  "Every refusal is a PERSISTENT, INSPECTABLE object, never only a printed
message.  The census write is instrumentation and touches no semantics."
  (setf (gethash reason *emitted-reasons*) t)
  (%make-vadimonium-refusal
   :phase phase :target-occurrence-identity target
   :reason reason :detail detail
   :offending (%snapshot (or offending-plist (list :offending :none)))))

(define-condition vadimonium-refused (error)
  ((refusal :initarg :refusal :reader vadimonium-refused-refusal))
  (:report (lambda (c s)
             (let ((r (vadimonium-refused-refusal c)))
               (format s "vadimonium refused (~A): ~A — ~A"
                       (vadimonium-refusal-phase r)
                       (vadimonium-refusal-reason r)
                       (vadimonium-refusal-detail r))))))

;;; ==================================================================
;;; II.  UNDERTAKE-VADIMONIUM — the elected opening act (DESIGN-NOTE §5, §6)
;;;
;;; A successful rewrite is NOT automatically a vadimonium.  A rewrite receipt
;;; is a property of the WORLD; an undertaking is a property of an AUTHOR'S
;;; DECISION about the world.  Every Form /2 receipt would otherwise manufacture
;;; an obligation silently, forever, asserting someone owes something merely
;;; because something changed.  So an explicit intent datum, an explicit scope
;;; datum and an explicit act identifier are all REQUIRED, and the binding
;;; between the successor and the receipt is CHECKED, never trusted.
;;;
;;; NO CONDITION HANDLER EXISTS ON THIS PATH.  Every refusal here is computed
;;; from public predicates and public readers and RETURNED.  Anything that
;;; SIGNALS from a governing layer is an implementation failure and ESCAPES, so
;;; it can never be laundered into a semantic refusal wearing a protocol name.
;;; A tooth plants exactly such a condition and proves it escapes.

(defun try-undertake-vadimonium (&key transformation-receipt successor
                                      vadimonium-act-id intent scope-description)
  "The quiet form.  (values VADIMONIUM nil) or (values nil REFUSAL)."
  (macrolet ((refuse (reason detail &optional offending)
               `(return-from try-undertake-vadimonium
                  (values nil (%refuse :undertake nil ,reason ,detail ,offending)))))
    (unless (cd0 datum-p vadimonium-act-id)
      (refuse :no-undertaking-act
              "an undertaking requires an explicit CD/0 act identifier; intent content is not occurrence identity"
              (list :host-type (%type-label vadimonium-act-id))))
    (unless (cd0 datum-p intent)
      (refuse :no-elected-intent
              "a successful rewrite does not make an undertaking; an explicit canonical intent datum is required"
              (list :host-type (%type-label intent))))
    (unless (cd0 datum-p scope-description)
      (refuse :no-scope-description
              "an undertaking requires an explicit canonical scope datum"
              (list :host-type (%type-label scope-description))))
    (unless (f2 form-transformation-receipt-p transformation-receipt)
      (refuse :not-a-transformation-receipt
              "the opening subject must be the exact Form /2 transformation receipt"
              (list :host-type (%type-label transformation-receipt))))
    (unless (cd0 datum-p successor)
      (refuse :successor-not-a-datum
              "the successor must be supplied as the CD/0 datum the rewrite produced"
              (list :host-type (%type-label successor))))
    (let ((awaited (f2 form-transformation-receipt-output-datum-identity
                       transformation-receipt)))
      (unless (%same (%identity successor) awaited)
        (refuse :successor-identity-mismatch
                "the supplied datum is not the datum this receipt says the rewrite produced"
                (list :supplied-identity-hex (%hex (%identity successor))
                      :receipt-output-identity-hex (%hex awaited))))
      (let* ((grammar-identity (f1 petition-grammar-identity))
             (grammar-version (f1 petition-grammar-version))
             (policy-identity (f1 petition-policy-identity))
             (policy-version (f1 petition-policy-version))
             (expectations (list :grammar-identity grammar-identity
                                 :grammar-version grammar-version
                                 :policy-identity policy-identity
                                 :policy-version policy-version))
             (content (%content-identity
                       :intent intent
                       :receipt-identity (f2 form-transformation-receipt-identity
                                             transformation-receipt)
                       :awaited-subject-identity awaited
                       :scope scope-description
                       :grammar-identity grammar-identity
                       :grammar-version grammar-version
                       :policy-identity policy-identity
                       :policy-version policy-version))
             (occurrence (%occurrence-identity vadimonium-act-id content)))
        (values
         (%make-vadimonium
          :occurrence-identity occurrence
          :content-identity content
          :act-id vadimonium-act-id
          :intent intent
          :scope scope-description
          :transformation-receipt-identity (f2 form-transformation-receipt-identity
                                               transformation-receipt)
          :awaited-subject-identity awaited
          :retained-expectations (%snapshot expectations)
          :procedure-identity (%procedure-identity)
          :procedure-version +procedure-version+)
         nil)))))

(defun undertake-vadimonium (&rest args)
  "The loud wrapper.  Signals VADIMONIUM-REFUSED carrying the same persistent
refusal object TRY-UNDERTAKE-VADIMONIUM would have returned."
  (multiple-value-bind (v refusal) (apply #'try-undertake-vadimonium args)
    (if v v (error 'vadimonium-refused :refusal refusal))))

;;; ==================================================================
;;; III.  VADIMONIUM-OWED-P — openness DERIVED, with EXACT conjuncts
;;;
;;; An APPEARANCE-RECEIPT closes a vadimonium only when ALL SEVEN hold:
;;;   1. it targets the exact OCCURRENCE identity        (EQUAL-DATUM);
;;;   2. it targets the exact CONTENT identity           (EQUAL-DATUM);
;;;   3. its own procedure identity is this procedure's  (EQUAL-DATUM);
;;;   4. its own procedure version is this version       (EQL);
;;;   5. its previous commitment is :OWED;
;;;   6. its resulting commitment is :APPEARED;
;;;   7. its residue is NIL.
;;;
;;; CONJUNCTS 3, 4 AND 5 WERE ADDED AFTER CENSOR F-2, at de-pignore parity
;;; (de-pignore/APPLICATION.lisp:549-557).  The first round had four conjuncts
;;; and argued that the procedure "rides inside the content identity, so
;;; conjunct 2 carries them."  That is true of the identity, and false of the
;;; RECEIPT: CENSOR built a receipt declaring :procedure-identity
;;; "NOT-THIS-PROCEDURE-AT-ALL" and :procedure-version 99 while copying the
;;; correct occurrence and content bytes, and it CLOSED; so did one declaring
;;; :previous-commitment :never-owed.  Three slots the struct carried were read
;;; by no closing path.  They are read now, and each is planted to bite.
;;;
;;; THE CEILING THAT REMAINS, AND IS NOT A DEFECT.  These conjuncts police what
;;; a receipt DECLARES about itself, never where it came from.  A receipt that
;;; copies every field correctly closes — demonstrated, not argued, in section L.
;;; A fold cannot authenticate provenance from a record's own contents, and
;;; nothing in this file pretends otherwise: a receipt is an ACCOUNT, not an
;;; AUTHENTICATION.
;;;
;;; Nothing else in the history is consulted.  A DESERTION-RECORD never closes.
;;; A VADIMONIUM-REFUSAL never closes — refusals do not enter the closing set at
;;; all.  A foreign object (a Form /2 receipt, a Form /1 form, a bare datum)
;;; never closes.  Nothing is ever removed from history.
;;;
;;; No status slot is consulted, because none exists.  No global archive and no
;;; ambient state is consulted, because none exists.
;;;
;;; VADIMONIUM-OWED-P IS AN UNGUARDED, TRUSTED FOLD, and this is a deliberate
;;; split rather than an oversight: the TRY- surfaces are the guarded doors
;;; (each type-checks its arguments and returns a typed refusal), and the fold
;;; is what those doors call once their checks have passed.  So it does no
;;; argument validation of its own.  A non-list or dotted history ESCAPES as an
;;; ordinary host type error, and a garbage subject escapes as soon as the
;;; history contains a receipt — but returns OWED, vacuously, against an empty
;;; history.  Consistent with the escape doctrine (§II), and stated here because
;;; CENSOR mapped it (F-8) and it had been documented nowhere.

(defun %receipt-closes-p (vadimonium r)
  (and (%same (%appearance-target-occurrence-identity r)
              (%vadimonium-occurrence-identity vadimonium))
       (%same (%appearance-target-content-identity r)
              (%vadimonium-content-identity vadimonium))
       (%same (%appearance-procedure-identity r) (%procedure-identity))
       (eql (%appearance-procedure-version r) +procedure-version+)
       (eq :owed (%appearance-previous-commitment r))
       (eq :appeared (%appearance-resulting-commitment r))
       (null (%appearance-residue r))))

(defun vadimonium-owed-p (vadimonium history)
  "Derived from the immutable vadimonium plus the caller-supplied ordered
history.

LIMIT, stated and demonstrated rather than solved: exactness is relative to the
history supplied.  A caller who omits a prior appearance receipt can obtain
another.  This specimen has no store from which to know otherwise and claims NO
global exactly-once appearance."
  (let ((owed t))
    (dolist (event history owed)
      (when (and (appearance-receipt-p event)
                 (%receipt-closes-p vadimonium event))
        (setf owed nil)))))

;;; ==================================================================
;;; IV.  TRY-PRESENT-APPEARANCE — the discharge (DESIGN-NOTE §7, §8)
;;;
;;; An appearance is NOT validation, truth, authority or standing.  The witness
;;; IS the standing-bearer and the vadimonium confers nothing: Form /1 alone
;;; validated the successor.  The receipt records only that the thing an author
;;; undertook has been exhibited and recognized under the rule they retained.
;;;
;;; The conjunction, all five parts required:
;;;   1. the fold over the SUPPLIED history says the vadimonium is still owed;
;;;   2. the witness is a real Form /1 VALIDATED-PETITION-FORM;
;;;   3. witness subject identity EQUAL-DATUM the awaited subject identity;
;;;   4. witness grammar identity and version equal the retained expectations;
;;;   5. witness policy identity and version equal the retained expectations.
;;;
;;; NO SIMILARITY IS MEASURED ANYWHERE.  A near-match and a far-match fail
;;; identically and for the same reason; the fixtures below are near so that the
;;; refusal can be SEEN to be exact rather than approximate.

(defun try-present-appearance (&key vadimonium witness (history nil))
  (macrolet ((refuse (reason detail &optional offending)
               `(return-from try-present-appearance
                  (values nil (%refuse :present
                                       (and (vadimonium-p vadimonium)
                                            (%vadimonium-occurrence-identity vadimonium))
                                       ,reason ,detail ,offending)))))
    (unless (vadimonium-p vadimonium)
      (refuse :not-a-vadimonium "an appearance must be presented to a vadimonium"
              (list :host-type (%type-label vadimonium))))
    (unless (vadimonium-owed-p vadimonium history)
      (refuse :already-appeared
              "the supplied history already derives this vadimonium as not owed; no second appearance is minted"
              (list :history-length (length history))))
    (unless (f1 validated-petition-form-p witness)
      (refuse :not-a-validated-form
              "the witness must be a real Form /1 validated petition form"
              (list :host-type (%type-label witness))))
    (let ((subject (f1 validated-petition-form-subject-identity witness)))
      (unless (%same subject (%vadimonium-awaited-subject-identity vadimonium))
        (refuse :subject-identity-mismatch
                "this validated form exhibits a different subject; descent is not identity and similarity is not measured"
                (list :witness-subject-hex (%hex subject)
                      :awaited-subject-hex
                      (%hex (%vadimonium-awaited-subject-identity vadimonium)))))
      (let* ((expectations (%vadimonium-retained-expectations vadimonium))
             (grammar-identity (f1 validated-petition-form-grammar-identity witness))
             (grammar-version (f1 validated-petition-form-grammar-version witness))
             (policy-identity (f1 validated-petition-form-policy-identity witness))
             (policy-version (f1 validated-petition-form-policy-version witness)))
        (unless (and (%same grammar-identity (getf expectations :grammar-identity))
                     (eql grammar-version (getf expectations :grammar-version)))
          (refuse :retained-grammar-mismatch
                  "the witness was validated under a grammar other than the one retained at undertaking time"
                  (list :witness-grammar-version grammar-version
                        :retained-grammar-version (getf expectations :grammar-version))))
        (unless (and (%same policy-identity (getf expectations :policy-identity))
                     (eql policy-version (getf expectations :policy-version)))
          (refuse :retained-policy-mismatch
                  "the witness was validated under a policy other than the one retained at undertaking time"
                  (list :witness-policy-version policy-version
                        :retained-policy-version (getf expectations :policy-version))))
        (let* ((facts (list :witness-identity (f1 validated-petition-form-identity witness)
                            :subject-identity subject
                            :grammar-identity grammar-identity
                            :grammar-version grammar-version
                            :policy-identity policy-identity
                            :policy-version policy-version))
               (occurrence (%vadimonium-occurrence-identity vadimonium))
               (content (%vadimonium-content-identity vadimonium))
               (identity (%identity
                          (%seq (list (%text ":de-vadimonio/appearance")
                                      (%procedure-identity)
                                      (%int +procedure-version+)
                                      occurrence
                                      content
                                      (f1 validated-petition-form-identity witness)
                                      subject
                                      (%text ":owed")
                                      (%text ":appeared")
                                      (%unit))))))
          (values (%make-appearance-receipt
                   :identity identity
                   :target-occurrence-identity occurrence
                   :target-content-identity content
                   :witness-facts (%snapshot facts)
                   :previous-commitment :owed
                   :resulting-commitment :appeared
                   :residue nil
                   :procedure-identity (%procedure-identity)
                   :procedure-version +procedure-version+)
                  nil))))))

(defun present-appearance (&rest args)
  (multiple-value-bind (r refusal) (apply #'try-present-appearance args)
    (if r r (error 'vadimonium-refused :refusal refusal))))

;;; ==================================================================
;;; V.  RECORD-DESERTION — the truthful record of a failed appearance
;;;
;;; An appearance journey can fail at Form /1 itself: the author carries the
;;; successor to the doors and Form /1 refuses it IN ITS OWN VOICE.  A desertion
;;; record snapshots that refusal's facts through public Form /1 readers, enters
;;; history, and NEVER CLOSES: its resulting commitment is still :OWED.  A
;;; deserted vadimonium over a successor Form /1 will always refuse can never
;;; later be discharged, and this specimen leaves one honestly open forever.
;;;
;;; Recording a desertion requires the vadimonium still be owed: one cannot
;;; desert what one has already met.

(defun try-record-desertion (&key vadimonium petition-refusal desertion-act-id
                                  (history nil))
  (macrolet ((refuse (reason detail &optional offending)
               `(return-from try-record-desertion
                  (values nil (%refuse :desert
                                       (and (vadimonium-p vadimonium)
                                            (%vadimonium-occurrence-identity vadimonium))
                                       ,reason ,detail ,offending)))))
    (unless (vadimonium-p vadimonium)
      (refuse :not-a-vadimonium "a desertion is recorded against a vadimonium"
              (list :host-type (%type-label vadimonium))))
    (unless (cd0 datum-p desertion-act-id)
      (refuse :no-desertion-act
              "recording a desertion requires an explicit CD/0 act identifier"
              (list :host-type (%type-label desertion-act-id))))
    ;; SOFTENED AFTER CENSOR F-5.  This detail used to read "the EXACT Form /1
    ;; refusal THE SUCCESSOR met" — an overclaim, because nothing here checks
    ;; that relation and nothing here can.  The evidence is type-checked; the
    ;; linkage between the refusal and this vadimonium's successor is the
    ;; author's testimony.
    (unless (f1 petition-refusal-p petition-refusal)
      (refuse :not-a-petition-refusal
              "a desertion records a Form /1 petition refusal, in Form /1's own voice; that the refusal is the one THIS successor met is the author's testimony, which this record accounts for and does not authenticate"
              (list :host-type (%type-label petition-refusal))))
    (unless (vadimonium-owed-p vadimonium history)
      (refuse :already-appeared
              "the supplied history already derives this vadimonium as not owed; one cannot desert what one has met"
              (list :history-length (length history))))
    (let* ((offending (f1 petition-refusal-offending petition-refusal))
           (facts (list :phase (f1 petition-refusal-phase petition-refusal)
                        :category (f1 petition-refusal-category petition-refusal)
                        :code (f1 petition-refusal-code petition-refusal)
                        :path (f1 petition-refusal-path petition-refusal)
                        :detail (f1 petition-refusal-detail petition-refusal)
                        :expected-role (f1 petition-refusal-expected-role petition-refusal)
                        :host-type (f1 petition-refusal-host-type petition-refusal)
                        :refusal-identity (f1 petition-refusal-identity petition-refusal)
                        :offending (if (cd0 datum-p offending) offending :non-datum-offending)))
           (occurrence (%vadimonium-occurrence-identity vadimonium))
           (content (%vadimonium-content-identity vadimonium))
           (identity (%identity
                      (%seq (list (%text ":de-vadimonio/desertion")
                                  (%procedure-identity)
                                  (%int +procedure-version+)
                                  occurrence
                                  content
                                  desertion-act-id
                                  (or (f1 petition-refusal-identity petition-refusal) (%unit))
                                  (%text ":owed")
                                  (%text ":owed"))))))
      (values (%make-desertion-record
               :identity identity
               :target-occurrence-identity occurrence
               :target-content-identity content
               :act-id desertion-act-id
               :refusal-facts (%snapshot facts)
               :previous-commitment :owed
               :resulting-commitment :owed
               :procedure-identity (%procedure-identity)
               :procedure-version +procedure-version+)
              nil))))

(defun record-desertion (&rest args)
  (multiple-value-bind (d refusal) (apply #'try-record-desertion args)
    (if d d (error 'vadimonium-refused :refusal refusal))))

;;; ==================================================================
;;; VI.  PLANTED-FAULT CONSTRUCTORS — TEETH ONLY, NEVER A SURFACE
;;;
;;; These build receipt-shaped and vadimonium-shaped objects that the public
;;; path CANNOT build, so that each fold conjunct and each retained-expectation
;;; conjunct can be proven TO BITE.  A gate that has never fired is untested,
;;; not passing; and a suite in which everything refuses is indistinguishable
;;; from one that works, so a POSITIVE CONTROL rides beside the planted faults.
;;;
;;; Nothing below is reachable from any exported name, and nothing below is used
;;; by the narrative.

(defun %plant-appearance-receipt (v &key (occurrence :ok) (content :ok)
                                         (procedure :ok) (version :ok)
                                         (previous :owed)
                                         (resulting :appeared) (residue nil))
  "One planted receipt per fold conjunct.  The PROCEDURE, VERSION and PREVIOUS
dimensions were added after CENSOR F-2, together with the conjuncts that read
them; with the defaults left alone this builds the POSITIVE CONTROL — a
fully-copied forgery, which closes, and must, because the fold reads declared
anatomy and not provenance."
  (%make-appearance-receipt
   :identity (%identity (%text ":planted"))
   :target-occurrence-identity (if (eq occurrence :ok)
                                   (%vadimonium-occurrence-identity v)
                                   (%identity (%text ":wrong-occurrence")))
   :target-content-identity (if (eq content :ok)
                                (%vadimonium-content-identity v)
                                (%identity (%text ":wrong-content")))
   :witness-facts (list :planted t)
   :previous-commitment previous
   :resulting-commitment resulting
   :residue residue
   :procedure-identity (if (eq procedure :ok)
                           (%procedure-identity)
                           (%text "NOT-THIS-PROCEDURE-AT-ALL"))
   :procedure-version (if (eq version :ok) +procedure-version+ 99)))

(defun %plant-vadimonium-with-drifted-expectations (v &key grammar-version policy-version)
  "A vadimonium whose RETAINED EXPECTATIONS name a Form /1 grammar or policy
version this image does not run.  Only one Form /1 grammar and one Form /1
policy exist in this image, so real drift cannot be produced from the public
path; the conjunct would otherwise be a claim with no executable fixture."
  (let* ((old (%vadimonium-retained-expectations v))
         (grammar-identity (getf old :grammar-identity))
         (policy-identity (getf old :policy-identity))
         (g (or grammar-version (getf old :grammar-version)))
         (p (or policy-version (getf old :policy-version)))
         (expectations (list :grammar-identity grammar-identity :grammar-version g
                             :policy-identity policy-identity :policy-version p))
         (content (%content-identity
                   :intent (%vadimonium-intent v)
                   :receipt-identity (%vadimonium-transformation-receipt-identity v)
                   :awaited-subject-identity (%vadimonium-awaited-subject-identity v)
                   :scope (%vadimonium-scope v)
                   :grammar-identity grammar-identity :grammar-version g
                   :policy-identity policy-identity :policy-version p))
         (occurrence (%occurrence-identity (%vadimonium-act-id v) content)))
    (%make-vadimonium
     :occurrence-identity occurrence :content-identity content
     :act-id (%vadimonium-act-id v) :intent (%vadimonium-intent v)
     :scope (%vadimonium-scope v)
     :transformation-receipt-identity (%vadimonium-transformation-receipt-identity v)
     :awaited-subject-identity (%vadimonium-awaited-subject-identity v)
     :retained-expectations (%snapshot expectations)
     :procedure-identity (%procedure-identity)
     :procedure-version +procedure-version+)))

;;; ==================================================================
;;; VII.  THE LIVE FIXTURE WORLD
;;;
;;; BORROWED, with attribution, from ../de-forma-mutata/APPLICATION.lisp
;;; (lines 97–202, 274–279), which took it in turn from de-forma-petente as
;;; executable precedent.  Nothing here is a private approximation of admission:
;;; these are the real public Slice /0/1/2 objects, the real Form /1 sealed
;;; resolution context, and the real Form /2 path datum for a support slot.
;;;
;;; ONE CHANGE FROM THE PRECEDENT, and it is the whole narrative: THREE support
;;; references are bound in the sealed context, not two.  "clearance" and
;;; "clearance-alt" name two DISTINCT witnesses about the RIGHT subject;
;;; "wrong-subject" names a witness of the right species, mode and kind about
;;; the WRONG subject.  Two right-subject bindings are needed because the
;;; successor that discharges must be identity-DISTINCT from the original — a
;;; head-repair narrative would make it byte-identical, and then a stale witness
;;; would truly discharge and the specimen would prove nothing.

(defun np (form) (s1 proposition form))
(defun pp (form) (s1 proposition-pattern form))
(defun occ-tag (&rest path) (%id '("de-vadimonio") path))

(defun install-schema ()
  (s1 clear-schema-registry)
  (s1 register-schema
      (s1 judgment-schema
          :name :volume-may-be-issued :version 1
          :conclusion (pp '(:predicate :volume-may-be-issued (:volume (:var :volume))))
          :premises (list (pp '(:predicate :volume-cleared-by-conservator
                                (:volume (:var :volume))))))))

(defun clearance-contract ()
  ;; :RECEIVER-ACCESSIBILITY is chosen DELIBERATELY; the constructor's own
  ;; default is :REQUIRED, and a default silently inherited is a decision nobody
  ;; made.
  (s2 make-support-admission-contract
      :contract-id :clearance-receiver-required
      :receiver-accessibility :required
      :accepted-clauses '((:asserted-witness :mode :direct
                           :kind :conservator-inspection
                           :truth-ceiling :asserted))))

(defun schema-wrapper ()
  ;; Built over what RESOLVE-SCHEMA returns, never over a locally kept handle:
  ;; DERIVE/2 compares the registered schema with EQ.
  (s2 make-slice2-schema
      :schema-id :volume-may-be-issued/2
      :base-schema (s1 resolve-schema :volume-may-be-issued 1)
      :premise-contracts (list (list 0 (clearance-contract)))))

(defun clearance-witness (volume source)
  (s0 witness
      :for (np `(:predicate :volume-cleared-by-conservator (:volume ,volume)))
      :mode :direct :kind :conservator-inspection :source source))

(defun reading-room (witnesses)
  (s0 receiver-context
      :context-id :reading-room
      :accessible-supports (mapcar (lambda (w) (s0 witness-id w)) witnesses)))

(defun governed-declaration (identity) (k0 identity->datum identity))
(defun witness-declaration (w) (governed-declaration (s0 witness-id w)))
(defun schema-declaration (wrapper)
  (governed-declaration
   (s1 judgment-schema-identity (s2 slice2-schema-base-schema wrapper))))

(install-schema)

(defparameter *wrapper* (schema-wrapper))
(defparameter *conclusion* (np '(:predicate :volume-may-be-issued (:volume "PLUT-7"))))
(defparameter *w-clearance* (clearance-witness "PLUT-7" :conservator-alpha))
(defparameter *w-alt* (clearance-witness "PLUT-7" :conservator-beta))
(defparameter *w-wrong* (clearance-witness "PLUT-9" :conservator-alpha))

(defparameter *context*
  (let ((ctx (f1 bind-conclusion-reference
                 (f1 bind-schema-reference (f1 make-derivation-resolution-context)
                     (f1 schema-reference "s") *wrapper* (schema-declaration *wrapper*))
                 (f1 conclusion-reference "c") *conclusion*
                 (occ-tag "denotation" "conclusion" "volume-may-be-issued"))))
    (setf ctx (f1 bind-support-reference ctx (f1 support-reference "clearance")
                  *w-clearance* (witness-declaration *w-clearance*)))
    (setf ctx (f1 bind-support-reference ctx (f1 support-reference "clearance-alt")
                  *w-alt* (witness-declaration *w-alt*)))
    (setf ctx (f1 bind-support-reference ctx (f1 support-reference "wrong-subject")
                  *w-wrong* (witness-declaration *w-wrong*)))
    (setf ctx (f1 bind-receiver-reference ctx (f1 receiver-reference "r")
                  (reading-room (list *w-clearance* *w-alt* *w-wrong*))
                  (occ-tag "denotation" "receiver" "reading-room")))
    (f1 seal-resolution-context ctx (occ-tag "ctx" "desk"))))

(defun petition-of (&key (support "clearance") (schema "s") (receiver "r"))
  (f1 petition-datum
      :schema (f1 schema-reference schema)
      :conclusion (f1 conclusion-reference "c")
      :supports (list (f1 support-reference support))
      :receiver (f1 receiver-reference receiver)))

(defparameter *support-path*
  (f2 path-datum (f2 index-step 1)
      (f2 key-step (%id '("lisp-plus-form1") '("field" "supports")))
      (f2 index-step 0)))

(defparameter *receiver-path*
  (f2 path-datum (f2 index-step 1)
      (f2 key-step (%id '("lisp-plus-form1") '("field" "receiver")))))

(defun rewrite (&key input path expected replacement tag)
  "Drive Form /2 as a CLIENT.  (values SUCCESSOR RECEIPT REFUSAL)."
  (multiple-value-bind (proposal refusal)
      (f2 try-propose-replacement
          (f2 replacement-proposal-datum
              :input input :path path :expected-old expected
              :replacement replacement :occurrence-tag (%text tag)))
    (if refusal
        (values nil nil refusal)
        (f2 try-apply-replacement proposal))))

(defun walk-to-validated (datum)
  "Drive Form /1 as a CLIENT, up to a validated form.
(values VALIDATED PROPOSE-REFUSAL VALIDATE-REFUSAL PROPOSED)."
  (multiple-value-bind (proposed refusal) (f1 try-propose-petition datum)
    (if refusal
        (values nil refusal nil nil)
        (multiple-value-bind (validated refusal2) (f1 try-validate-petition proposed)
          (values validated nil refusal2 proposed)))))

(defun materialize-and-submit (validated tag)
  "The terminal dependent action: the real Form /1 doors and the real Slice /2
world.  Form /2 is not in this call at all, and neither is any vadimonium."
  (multiple-value-bind (petition receipt refusal)
      (f1 try-materialize-petition validated (occ-tag "occ" tag))
    (declare (ignore receipt))
    (if refusal
        (values nil refusal)
        (f1 try-submit-petition petition *context*
            :by :reading-room-clerk :by-id (occ-tag "by" "clerk")
            :act-id (occ-tag "act" tag)))))

;;; ==================================================================
;;; VIII.  ACT IDENTIFIERS AND INTENTS — all CD/0, all explicit.

(defparameter *act-1* (occ-tag "act" "undertaking" "1"))
(defparameter *act-2* (occ-tag "act" "undertaking" "2"))
(defparameter *act-2-bis* (occ-tag "act" "undertaking" "2-bis"))
(defparameter *desert-act* (occ-tag "act" "desertion" "1"))
(defparameter *intent* (%text "carry this exact successor through Form /1 re-entry"))
(defparameter *scope* (%text "one successor datum; Form /1 re-entry only"))

;;; ==================================================================
;;; IX.  HARNESS — the count is DERIVED from the verdicts actually rendered.

(defvar *verdicts* '())
(defun ck (label bool)
  (push (list (1+ (length *verdicts*)) label (and bool t)) *verdicts*)
  (format t "  [~3,'0D] ~:[FAIL~;ok  ~] ~A~%" (length *verdicts*) (and bool t) label)
  (and bool t))
(defun verdict-count () (length *verdicts*))
(defun failure-count () (count nil *verdicts* :key #'third))
(defun section (title) (format t "~%── ~A~%" title))
(defun desk (control &rest args) (format t "  ~A~%" (apply #'format nil control args)))

(format t "~&DE VADIMONIO — concerning the undertaking to appear~%")
(format t "application-private specimen · no persistence · no authority · no enforcement~%")
(format t "SBCL ~A · Form /2 policy v~D · Form /1 policy v~D · procedure v~D~%"
        (lisp-implementation-version)
        (f2 transformation-policy-version)
        (f1 petition-policy-version)
        +procedure-version+)

;;; ==================================================================
(section "A — THE ORIGINAL, AND THE SUBSTRATE-INDEPENDENCE CONTROL")
;;; ==================================================================
(desk "A petition validates and submits through the real Form /1 and Slice /2")
(desk "path with NO vadimonium anywhere in its history.  The substrate does not")
(desk "know this file exists, and this is the control that says so.")

(defparameter *o* (petition-of))
(defparameter *v-o* (nth-value 0 (walk-to-validated *o*)))
(ck "the original petition datum O proposes and validates under real Form /1"
    (f1 validated-petition-form-p *v-o*))

(defparameter *o-outcome* (nth-value 0 (materialize-and-submit *v-o* "o")))
(ck "CONTROL  O materializes and submits with NO vadimonium consulted anywhere; DERIVE/2 returns a governed outcome"
    (and *o-outcome*
         (member (f1 petition-submission-outcome-kind *o-outcome*)
                 '(:granted :governed-refusal))
         (f1 petition-submission-outcome-slice2-receipt *o-outcome*)))
(desk "O outcome ~A · Slice /2 decision ~A"
      (f1 petition-submission-outcome-kind *o-outcome*)
      (s2 slice2-receipt-decision
          (f1 petition-submission-outcome-slice2-receipt *o-outcome*)))

;;; ==================================================================
(section "B — REWRITE 1: THE SUCCESSOR THAT LOST ITS STANDING")
;;; ==================================================================
(desk "O's support reference is replaced with a lawful CD/0 datum that is NOT")
(desk "reference-shaped.  The rewrite SUCCEEDS — and because it succeeded, the")
(desk "successor is standing-less.  Form /2 says only that a value at a path")
(desk "changed; it does not know the successor is unvalidatable, and says so")
(desk "about nothing at all.")

(defparameter *broken-support* (%id '("not-form1") '("some" "other")))

(multiple-value-bind (successor receipt refusal)
    (rewrite :input *o* :path *support-path*
             :expected (f1 support-reference "clearance")
             :replacement *broken-support* :tag "s1")
  (defparameter *s1* successor)
  (defparameter *receipt-1* receipt)
  (ck "REWRITE 1 succeeds structurally and mints a Form /2 receipt"
      (and successor receipt (null refusal))))
(ck "REWRITE 1's receipt names the operation and claims nothing else"
    (eq :replaced-at-path (f2 form-transformation-receipt-disposition *receipt-1*)))
(ck "O and successor S1 are identity-DISTINCT" (not (%same *o* *s1*)))

;;; ==================================================================
(section "C — UNDERTAKING 1, AND WHAT REFUSES TO BE ONE")
;;; ==================================================================

(defparameter *vad-1*
  (nth-value 0 (try-undertake-vadimonium
                :transformation-receipt *receipt-1* :successor *s1*
                :vadimonium-act-id *act-1* :intent *intent*
                :scope-description *scope*)))
(ck "UNDERTAKE  an explicit act, intent and scope elect an immutable vadimonium over S1"
    (vadimonium-p *vad-1*))
(ck "the vadimonium's occurrence and content identities are CD/0 datum VALUES, not text and not a digest"
    (and (cd0 bytes-datum-p (vadimonium-occurrence-identity *vad-1*))
         (cd0 bytes-datum-p (vadimonium-content-identity *vad-1*))
         (not (%same (vadimonium-occurrence-identity *vad-1*)
                     (vadimonium-content-identity *vad-1*)))))
(ck "the awaited subject identity IS the receipt's output-datum identity, checked and not trusted"
    (%same (vadimonium-awaited-subject-identity *vad-1*)
           (f2 form-transformation-receipt-output-datum-identity *receipt-1*)))
(ck "the fold with an empty history derives OWED" (vadimonium-owed-p *vad-1* '()))

(desk "the negative controls: a rewrite receipt is a property of the WORLD; an")
(desk "undertaking is a property of an AUTHOR'S DECISION about the world.")

(ck "NC  no intent datum constructs nothing"
    (let ((r (nth-value 1 (try-undertake-vadimonium
                           :transformation-receipt *receipt-1* :successor *s1*
                           :vadimonium-act-id *act-1* :intent nil
                           :scope-description *scope*))))
      (and r (eq :no-elected-intent (vadimonium-refusal-reason r)))))
(ck "NC  no act identifier constructs nothing"
    (let ((r (nth-value 1 (try-undertake-vadimonium
                           :transformation-receipt *receipt-1* :successor *s1*
                           :vadimonium-act-id nil :intent *intent*
                           :scope-description *scope*))))
      (and r (eq :no-undertaking-act (vadimonium-refusal-reason r)))))
(ck "NC  no scope datum constructs nothing"
    (let ((r (nth-value 1 (try-undertake-vadimonium
                           :transformation-receipt *receipt-1* :successor *s1*
                           :vadimonium-act-id *act-1* :intent *intent*
                           :scope-description nil))))
      (and r (eq :no-scope-description (vadimonium-refusal-reason r)))))
(ck "NC  a host intent that is not a CD/0 datum is refused, so no host value ever enters an identity"
    (let ((r (nth-value 1 (try-undertake-vadimonium
                           :transformation-receipt *receipt-1* :successor *s1*
                           :vadimonium-act-id *act-1* :intent '(:undertake :by-hand)
                           :scope-description *scope*))))
      (and r (eq :no-elected-intent (vadimonium-refusal-reason r)))))
(ck "NC  something that is not a Form /2 transformation receipt is refused with the EXACT reason"
    (let ((r (nth-value 1 (try-undertake-vadimonium
                           :transformation-receipt (list :not :a :receipt) :successor *s1*
                           :vadimonium-act-id *act-1* :intent *intent*
                           :scope-description *scope*))))
      (and r (eq :not-a-transformation-receipt (vadimonium-refusal-reason r)))))
(ck "NC  a successor that is not a CD/0 datum is refused before any identity is computed"
    (let ((r (nth-value 1 (try-undertake-vadimonium
                           :transformation-receipt *receipt-1* :successor :not-a-datum
                           :vadimonium-act-id *act-1* :intent *intent*
                           :scope-description *scope*))))
      (and r (eq :successor-not-a-datum (vadimonium-refusal-reason r)))))
(ck "NC  the PREDECESSOR offered as the successor is refused :SUCCESSOR-IDENTITY-MISMATCH — the binding is checked, never trusted"
    (let ((r (nth-value 1 (try-undertake-vadimonium
                           :transformation-receipt *receipt-1* :successor *o*
                           :vadimonium-act-id *act-1* :intent *intent*
                           :scope-description *scope*))))
      (and r (eq :successor-identity-mismatch (vadimonium-refusal-reason r)))))
(ck "NC  the loud wrapper signals VADIMONIUM-REFUSED carrying the same persistent refusal object"
    (handler-case (progn (undertake-vadimonium
                          :transformation-receipt *receipt-1* :successor *s1*
                          :vadimonium-act-id *act-1* :intent nil
                          :scope-description *scope*)
                         nil)
      (vadimonium-refused (c)
        (let ((r (vadimonium-refused-refusal c)))
          (and (vadimonium-refusal-p r)
               (eq :undertake (vadimonium-refusal-phase r))
               (eq :no-elected-intent (vadimonium-refusal-reason r)))))))

(desk "distinct acts over identical content: both halves of the split, asserted")
(desk "separately, because a review found them conflated once already.")
(defparameter *vad-1-bis*
  (nth-value 0 (try-undertake-vadimonium
                :transformation-receipt *receipt-1* :successor *s1*
                :vadimonium-act-id (occ-tag "act" "undertaking" "1-bis") :intent *intent*
                :scope-description *scope*)))
(ck "IDENTITY SPLIT  two undertaking acts over identical content yield DISTINCT occurrence identities"
    (not (%same (vadimonium-occurrence-identity *vad-1*)
                (vadimonium-occurrence-identity *vad-1-bis*))))
(ck "IDENTITY SPLIT  and IDENTICAL content identities"
    (%same (vadimonium-content-identity *vad-1*)
           (vadimonium-content-identity *vad-1-bis*)))
(desk "replayed act identifiers are OUTSIDE the enforceable boundary: there is no")
(desk "registry here, so nothing detects a second use of one act id.  Stated, not")
(desk "silently decided.")

;;; ==================================================================
(section "D — THE DESERTION: FORM /1 REFUSES S1 IN ITS OWN VOICE")
;;; ==================================================================

(multiple-value-bind (validated propose-refusal validate-refusal) (walk-to-validated *s1*)
  (let ((refusal (or propose-refusal validate-refusal)))
    (defparameter *s1-refusal* refusal)
    (ck "the successor S1 is carried to the doors and Form /1 REFUSES it"
        (and (null validated) (f1 petition-refusal-p refusal)))))
(ck "and refuses it in ITS OWN voice, with its own code :MALFORMED-REFERENCE at :PROPOSE"
    (and (eq :malformed-reference (f1 petition-refusal-code *s1-refusal*))
         (eq :propose (f1 petition-refusal-phase *s1-refusal*))))

(defparameter *desertion*
  (nth-value 0 (try-record-desertion :vadimonium *vad-1*
                                     :petition-refusal *s1-refusal*
                                     :desertion-act-id *desert-act*
                                     :history '())))
(ck "RECORD-DESERTION mints a desertion record with its OWN identity"
    (and (desertion-record-p *desertion*)
         (cd0 bytes-datum-p (desertion-record-identity *desertion*))))
(ck "the desertion's resulting commitment is still :OWED — a desertion is a record, never a closing"
    (eq :owed (desertion-record-resulting-commitment *desertion*)))
(ck "the desertion carries Form /1's own refusal facts, snapshotted through PUBLIC readers"
    (let ((facts (desertion-record-refusal-facts *desertion*)))
      (and (eq :malformed-reference (getf facts :code))
           (eq :propose (getf facts :phase))
           (eq :grammar (getf facts :category))
           (equal '(1 :supports 0) (getf facts :path))
           (stringp (getf facts :detail))
           (cd0 datum-p (getf facts :refusal-identity)))))
(ck "FOLD  a desertion in the history leaves the vadimonium OWED"
    (vadimonium-owed-p *vad-1* (list *desertion*)))

;;; THE "BEFORE" CAPTURES FOR SECTION J, TAKEN HERE — at desertion time, long
;;; upstream of the appearance the section-J checks claim to bracket (CENSOR
;;; F-4).  COPY-TREE, so the captured value is independent of the record even if
;;; a reader were ever to regress to aliasing.
(defparameter *desertion-identity-before* (desertion-record-identity *desertion*))
(defparameter *desertion-facts-before* (copy-tree (desertion-record-refusal-facts *desertion*)))

(ck "NC  a desertion recorded against something that is not a vadimonium is refused"
    (let ((r (nth-value 1 (try-record-desertion :vadimonium :not-a-vadimonium
                                                :petition-refusal *s1-refusal*
                                                :desertion-act-id *desert-act*))))
      (and r (eq :not-a-vadimonium (vadimonium-refusal-reason r)))))
(ck "NC  a desertion with no act identifier is refused"
    (let ((r (nth-value 1 (try-record-desertion :vadimonium *vad-1*
                                                :petition-refusal *s1-refusal*
                                                :desertion-act-id nil))))
      (and r (eq :no-desertion-act (vadimonium-refusal-reason r)))))
(ck "NC  a desertion whose evidence is not a Form /1 petition refusal is refused"
    (let ((r (nth-value 1 (try-record-desertion :vadimonium *vad-1*
                                                :petition-refusal '(:it :refused :honest)
                                                :desertion-act-id *desert-act*))))
      (and r (eq :not-a-petition-refusal (vadimonium-refusal-reason r)))))

(desk "VADIMONIUM 1 WILL REMAIN OWED FOR THE REST OF THIS RUN.  Form /1")
(desk "validation is deterministic over a fixed datum, so a deserted vadimonium")
(desk "over an unvalidatable successor can never later be met by an appearance.  That is")
(desk "the truthful state, not a loose end.")

;;; ==================================================================
(section "E — REWRITE 2 AND THE SIBLING: TWO LAWFUL REPLACEMENTS")
;;; ==================================================================
(desk "S1's broken support is replaced with a lawful reference DIFFERENT from")
(desk "O's, so the chain O -> S1 -> S2 carries three distinct identities.  A")
(desk "head-repair narrative was rejected in design: it would make S2")
(desk "byte-identical to O, and then a stale witness would truly close it.")

(multiple-value-bind (successor receipt refusal)
    (rewrite :input *s1* :path *support-path*
             :expected *broken-support*
             :replacement (f1 support-reference "clearance-alt") :tag "s2")
  (defparameter *s2* successor)
  (defparameter *receipt-2* receipt)
  (ck "REWRITE 2 succeeds: S2 descends from S1" (and successor receipt (null refusal))))

(multiple-value-bind (successor receipt refusal)
    (rewrite :input *s1* :path *support-path*
             :expected *broken-support*
             :replacement (f1 support-reference "wrong-subject") :tag "s3")
  (defparameter *s3* successor)
  (defparameter *receipt-3* receipt)
  (ck "SIBLING REWRITE succeeds: S3 is another lawful replacement of the same slot"
      (and successor receipt (null refusal))))

(ck "the four data O, S1, S2, S3 carry SIX pairwise-distinct identities"
    (let ((all (list *o* *s1* *s2* *s3*)))
      (and (= 4 (length all))
           (loop for (a . rest) on all
                 always (loop for b in rest never (%same a b))))))
;;; THE ABBREVIATION IS ITSELF UNDER TEST — de-forma-mutata's discipline, and
;;; it earned its keep here TWICE.  A 32-character HEAD of these four identities
;;; is identical for all four.  A 24+24 HEAD-AND-TAIL, which discriminates every
;;; identity de-forma-mutata prints, ALSO collides here: S2 and S3 differ only in
;;; a support-reference name buried in the middle, and share head, tail and
;;; length.  Both abbreviations were written, printed, and caught by the
;;; discrimination check before this line was written.  So the FULL LOSSLESS
;;; identity is printed — long, unlovely, and unable to lie — and the check below
;;; certifies the thing actually printed rather than a prettier stand-in.
(defun printed-identity (d) (%hex d))
(desk "O  ~A" (printed-identity *o*))
(desk "S1 ~A" (printed-identity *s1*))
(desk "S2 ~A" (printed-identity *s2*))
(desk "S3 ~A" (printed-identity *s3*))
(ck "every identity PRINTED just above discriminates every other — two abbreviations were tried first and both collided, so nothing shorter is printed"
    (let ((printed (mapcar #'printed-identity (list *o* *s1* *s2* *s3*))))
      (= 4 (length (remove-duplicates printed :test #'string=)))))

(defparameter *vad-2*
  (nth-value 0 (try-undertake-vadimonium
                :transformation-receipt *receipt-2* :successor *s2*
                :vadimonium-act-id *act-2* :intent *intent*
                :scope-description *scope*)))
(ck "UNDERTAKING 2 elects a vadimonium over S2" (vadimonium-p *vad-2*))
(ck "vadimonium 1 and vadimonium 2 differ in BOTH occurrence and content identity"
    (and (not (%same (vadimonium-occurrence-identity *vad-1*)
                     (vadimonium-occurrence-identity *vad-2*)))
         (not (%same (vadimonium-content-identity *vad-1*)
                     (vadimonium-content-identity *vad-2*)))))

;;; ==================================================================
(section "F — IRRELEVANT INTERVENING WORK")
;;; ==================================================================
(desk "An unrelated rewrite and an unrelated validation happen.  Neither is")
(desk "about either vadimonium, and the fold does not move.")

(defparameter *unrelated-datum* (petition-of :support "clearance" :receiver "elsewhere"))
(defparameter *v-unrelated* (nth-value 0 (walk-to-validated *unrelated-datum*)))
(multiple-value-bind (successor receipt refusal)
    (rewrite :input *unrelated-datum* :path *receiver-path*
             :expected (f1 receiver-reference "elsewhere")
             :replacement (f1 receiver-reference "somewhere-else") :tag "u")
  (declare (ignore successor))
  (defparameter *unrelated-receipt* receipt)
  (ck "an unrelated Form /2 rewrite and an unrelated Form /1 validation both succeed"
      (and receipt (null refusal) (f1 validated-petition-form-p *v-unrelated*))))

(defparameter *history-2* (list *unrelated-receipt* *v-unrelated* *desertion*))
(ck "FOLD  a history of foreign objects — a Form /2 receipt, a Form /1 validated form, another vadimonium's desertion — leaves vadimonium 2 OWED"
    (vadimonium-owed-p *vad-2* *history-2*))

;;; ==================================================================
(section "G — NEAR-MATCHES, REFUSED EXACTLY")
;;; ==================================================================
(desk "No similarity is measured anywhere.  A near-match and a far-match fail")
(desk "identically and for the same reason.  The fixtures are NEAR so that the")
(desk "refusal can be seen to be exact rather than approximate.")

(defparameter *v-s2* (nth-value 0 (walk-to-validated *s2*)))
(defparameter *v-s3* (nth-value 0 (walk-to-validated *s3*)))
(ck "S2 and S3 both validate under real Form /1 — the near-matches are REAL objects, not props"
    (and (f1 validated-petition-form-p *v-s2*) (f1 validated-petition-form-p *v-s3*)))

(defparameter *near-1*
  (nth-value 1 (try-present-appearance :vadimonium *vad-2* :witness *v-o*
                                       :history *history-2*)))
(ck "NEAR  the ORIGINAL's own validated form — right shape, real object, STALE SUBJECT — refuses"
    (and *near-1* (eq :subject-identity-mismatch (vadimonium-refusal-reason *near-1*))))

(defparameter *near-2*
  (nth-value 1 (try-present-appearance :vadimonium *vad-2* :witness *v-s3*
                                       :history *history-2*)))
(ck "NEAR  the SIBLING successor's validated form — same predecessor, same slot, different replacement — refuses"
    (and *near-2* (eq :subject-identity-mismatch (vadimonium-refusal-reason *near-2*))))

(defparameter *cross-1*
  (nth-value 1 (try-present-appearance :vadimonium *vad-1* :witness *v-s2*
                                       :history (list *desertion*))))
(ck "CROSS  S2's validated form offered to VADIMONIUM 1 refuses — S2 descends from S1, and DESCENT IS NOT IDENTITY"
    (and *cross-1* (eq :subject-identity-mismatch (vadimonium-refusal-reason *cross-1*))))

;;; The third section-J "before" capture, taken at the moment this refusal is
;;; minted — the earliest point at which it exists, and still well upstream of
;;; the appearance (CENSOR F-4).  COPY-TREE, for the same reason as the two in
;;; section D.
(defparameter *near-refusal-before* (copy-tree (vadimonium-refusal-offending *cross-1*)))

(defparameter *far-1*
  (nth-value 1 (try-present-appearance :vadimonium *vad-2* :witness *v-unrelated*
                                       :history *history-2*)))
(ck "FAR  an entirely unrelated validated petition refuses with the SAME reason and by the SAME test — no similarity is measured"
    (and *far-1* (eq :subject-identity-mismatch (vadimonium-refusal-reason *far-1*))
         (eq (vadimonium-refusal-reason *far-1*) (vadimonium-refusal-reason *near-1*))))

(ck "NC  a witness that is not a validated petition form refuses :NOT-A-VALIDATED-FORM"
    (let ((r (nth-value 1 (try-present-appearance :vadimonium *vad-2* :witness *s2*
                                                  :history *history-2*))))
      (and r (eq :not-a-validated-form (vadimonium-refusal-reason r)))))
(ck "NC  presenting to something that is not a vadimonium refuses"
    (let ((r (nth-value 1 (try-present-appearance :vadimonium *v-s2* :witness *v-s2*))))
      (and r (eq :not-a-vadimonium (vadimonium-refusal-reason r)))))

(desk "the two retained-expectation conjuncts.  Only one Form /1 grammar and one")
(desk "Form /1 policy exist in this image, so real drift cannot be produced from")
(desk "the public path; a PLANTED vadimonium supplies the fixture, because a")
(desk "conjunct with no executable fixture is a claim, not a check.")
(ck "CONJUNCT  a vadimonium retaining a grammar VERSION this image does not run refuses the true witness :RETAINED-GRAMMAR-MISMATCH"
    (let* ((planted (%plant-vadimonium-with-drifted-expectations *vad-2* :grammar-version 99))
           (r (nth-value 1 (try-present-appearance :vadimonium planted :witness *v-s2*))))
      (and r (eq :retained-grammar-mismatch (vadimonium-refusal-reason r)))))
(ck "CONJUNCT  a vadimonium retaining a policy VERSION this image does not run refuses the true witness :RETAINED-POLICY-MISMATCH"
    (let* ((planted (%plant-vadimonium-with-drifted-expectations *vad-2* :policy-version 99))
           (r (nth-value 1 (try-present-appearance :vadimonium planted :witness *v-s2*))))
      (and r (eq :retained-policy-mismatch (vadimonium-refusal-reason r)))))

(defparameter *history-2-refused*
  (append *history-2* (list *near-1* *near-2* *far-1*)))
(ck "FOLD  refusals never enter the closing set: after three refusals the vadimonium is still OWED"
    (vadimonium-owed-p *vad-2* *history-2-refused*))

;;; ==================================================================
(section "H — THE AUTHOR'S WITHHOLDING, RECORDED AS A BRANCH ON THE FOLD")
;;; ==================================================================
(desk "The dependent action is NOT taken while the fold says owed.  Nothing in")
(desk "the substrate refused it: the author's own program declined to take it,")
(desk "and that is the whole of the enforcement story.")

(defvar *terminal-outcome* nil)
(defvar *withholding-recorded* nil)

(if (vadimonium-owed-p *vad-2* *history-2-refused*)
    (setf *withholding-recorded*
          (list :decision :withheld
                :because :vadimonium-still-owed
                :at (occ-tag "branch" "before-appearance")))
    (setf *terminal-outcome* :taken-too-early))
(ck "the author's program WITHHELD the dependent action, and no submission of S2 has happened"
    (and (eq :withheld (getf *withholding-recorded* :decision))
         (null *terminal-outcome*)))

;;; ==================================================================
(section "I — THE APPEARANCE")
;;; ==================================================================

(defparameter *appearance*
  (nth-value 0 (try-present-appearance :vadimonium *vad-2* :witness *v-s2*
                                       :history *history-2-refused*)))
(ck "the EXACT witness — S2's own validated form — is recognized and an appearance receipt is minted"
    (appearance-receipt-p *appearance*))
(ck "the receipt carries prior :OWED -> resulting :APPEARED with residue NIL"
    (and (eq :owed (appearance-receipt-previous-commitment *appearance*))
         (eq :appeared (appearance-receipt-resulting-commitment *appearance*))
         (null (appearance-receipt-residue *appearance*))))
(ck "the receipt has its OWN identity, distinct from the vadimonium's occurrence identity and from the Form /2 receipt's identity"
    (and (cd0 bytes-datum-p (appearance-receipt-identity *appearance*))
         (not (%same (appearance-receipt-identity *appearance*)
                     (vadimonium-occurrence-identity *vad-2*)))
         (not (%same (appearance-receipt-identity *appearance*)
                     (f2 form-transformation-receipt-identity *receipt-2*)))))
(ck "the receipt names the exact vadimonium it answers, in both halves of the identity split"
    (and (%same (appearance-receipt-target-occurrence *appearance*)
                (vadimonium-occurrence-identity *vad-2*))
         (%same (appearance-receipt-target-content *appearance*)
                (vadimonium-content-identity *vad-2*))))
(ck "the receipt's witness facts name the real Form /1 validated form and its subject identity"
    (let ((facts (appearance-receipt-witness-facts *appearance*)))
      (and (%same (getf facts :witness-identity)
                  (f1 validated-petition-form-identity *v-s2*))
           (%same (getf facts :subject-identity)
                  (f2 form-transformation-receipt-output-datum-identity *receipt-2*)))))

(defparameter *history-2-closed* (append *history-2-refused* (list *appearance*)))
(ck "FOLD  the vadimonium derives NOT OWED — and no status slot was written, because none exists"
    (not (vadimonium-owed-p *vad-2* *history-2-closed*)))
(ck "presenting again against the closed history refuses :ALREADY-APPEARED"
    (let ((r (nth-value 1 (try-present-appearance :vadimonium *vad-2* :witness *v-s2*
                                                  :history *history-2-closed*))))
      (and r (eq :already-appeared (vadimonium-refusal-reason r)))))
(ck "recording a desertion against the closed history refuses too — one cannot desert what one has met"
    (let ((r (nth-value 1 (try-record-desertion :vadimonium *vad-2*
                                                :petition-refusal *s1-refusal*
                                                :desertion-act-id *desert-act*
                                                :history *history-2-closed*))))
      (and r (eq :already-appeared (vadimonium-refusal-reason r)))))

;;; ==================================================================
(section "J — CROSS-CLOSURE REFUSED, AND HISTORY LEFT TRUTHFUL")
;;; ==================================================================

(ck "CROSS-CLOSURE  vadimonium 2's appearance receipt folded into vadimonium 1's history does NOT close it"
    (vadimonium-owed-p *vad-1* (list *desertion* *appearance*)))

;;; REPAIRED AFTER CENSOR F-4.  The first round took these "before" captures
;;; HERE — after section I had already minted the appearance — so the checks
;;; compared two reads taken after the event they claimed to bracket, and a
;;; probe that corrupted the desertion record's stored facts DURING the
;;; discharge left all four rendering `ok`.  The captures now live at the
;;; moments named beside them, upstream of the appearance; the values compared
;;; below are genuinely prior.  Each capture is COPY-TREE'd, so an aliasing
;;; regression in a reader cannot make the comparison a self-comparison.
(ck "HISTORY TRUTH  the desertion record's own identity is byte-identical after the kindred appearance (captured in section D, before the appearance existed)"
    (%same *desertion-identity-before* (desertion-record-identity *desertion*)))
(ck "HISTORY TRUTH  every reader of the desertion record returns exactly what it returned at desertion time"
    (and (equal *desertion-facts-before* (desertion-record-refusal-facts *desertion*))
         (%same (desertion-record-target-occurrence *desertion*)
                (vadimonium-occurrence-identity *vad-1*))
         (eq :owed (desertion-record-resulting-commitment *desertion*))))
(ck "HISTORY TRUTH  vadimonium 1's near-match refusal is unchanged after the kindred appearance (captured in section G, when the refusal was minted) — later success rewrites nothing"
    (and (equal *near-refusal-before* (vadimonium-refusal-offending *cross-1*))
         (eq :subject-identity-mismatch (vadimonium-refusal-reason *cross-1*))))
(ck "HISTORY TRUTH  vadimonium 1 folded again over its whole history is STILL OWED, and will be forever"
    (vadimonium-owed-p *vad-1* (list *desertion* *cross-1* *appearance*)))

;;; ==================================================================
(section "K — THE TERMINAL DEPENDENT ACTION")
;;; ==================================================================
(desk "Only now.  The author's program, not the machinery, gates on the fold.")

(if (vadimonium-owed-p *vad-2* *history-2-closed*)
    (setf *terminal-outcome* :not-taken)
    (setf *terminal-outcome*
          (nth-value 0 (materialize-and-submit *v-s2* "s2"))))

(ck "the fold said NOT OWED, so the author materialized S2 and submitted it through the real Slice /2 world"
    (and *terminal-outcome*
         (not (eq :not-taken *terminal-outcome*))
         (f1 petition-submission-outcome-p *terminal-outcome*)))
(ck "a real Slice /2 receipt came back, and Slice /2 alone decided it"
    (let ((s2r (f1 petition-submission-outcome-slice2-receipt *terminal-outcome*)))
      (and s2r (member (s2 slice2-receipt-decision s2r) '(:granted :refused)))))
(desk "S2 outcome ~A · Slice /2 decision ~A"
      (f1 petition-submission-outcome-kind *terminal-outcome*)
      (s2 slice2-receipt-decision
          (f1 petition-submission-outcome-slice2-receipt *terminal-outcome*)))
(ck "the Form /1 submission receipt names FORM /1's own procedure, not this file's — the substrate never consulted a vadimonium"
    (let ((sr (f1 petition-submission-outcome-receipt *terminal-outcome*)))
      (and sr
           (%same (f1 petition-submission-receipt-procedure-identity sr)
                  (f1 petition-submission-procedure-identity))
           (not (%same (f1 petition-submission-receipt-procedure-identity sr)
                       (%procedure-identity))))))
(ck "the appearance receipt granted nothing: the same outcome kind is reachable with NO vadimonium at all (the O control)"
    (eq (f1 petition-submission-outcome-kind *terminal-outcome*)
        (f1 petition-submission-outcome-kind *o-outcome*)))

;;; ==================================================================
(section "L — THE FOLD'S CONJUNCTS, EACH PROVEN TO BITE")
;;; ==================================================================
(desk "A gate that has never fired is untested, not passing.  And a suite in")
(desk "which everything refuses is indistinguishable from one that works, so the")
(desk "positive control rides beside the planted faults.")

(ck "FOLD CONJUNCT 1  a receipt targeting the wrong OCCURRENCE identity does not close"
    (vadimonium-owed-p *vad-2* (list (%plant-appearance-receipt *vad-2* :occurrence :wrong))))
(ck "FOLD CONJUNCT 2  a receipt targeting the wrong CONTENT identity does not close"
    (vadimonium-owed-p *vad-2* (list (%plant-appearance-receipt *vad-2* :content :wrong))))
(ck "FOLD CONJUNCT 3  (CENSOR F-2, probe A1) a receipt DECLARING a foreign procedure identity, while copying the correct occurrence and content bytes, does not close — in the first round it did"
    (vadimonium-owed-p *vad-2* (list (%plant-appearance-receipt *vad-2* :procedure :wrong))))
(ck "FOLD CONJUNCT 4  (CENSOR F-2) a receipt declaring a foreign procedure VERSION, identities correct, does not close"
    (vadimonium-owed-p *vad-2* (list (%plant-appearance-receipt *vad-2* :version :wrong))))
(ck "FOLD CONJUNCT 5  (CENSOR F-2, probe A2) a receipt declaring :PREVIOUS-COMMITMENT :NEVER-OWED does not close — in the first round it did"
    (vadimonium-owed-p *vad-2* (list (%plant-appearance-receipt *vad-2* :previous :never-owed))))
(ck "FOLD CONJUNCT 6  a receipt whose resulting commitment is not :APPEARED does not close"
    (vadimonium-owed-p *vad-2* (list (%plant-appearance-receipt *vad-2* :resulting :owed))))
(ck "FOLD CONJUNCT 7  a receipt carrying non-NIL residue does not close"
    (vadimonium-owed-p *vad-2* (list (%plant-appearance-receipt *vad-2* :residue '(:still-owed)))))
(ck "POSITIVE CONTROL  a receipt satisfying ALL SEVEN conjuncts DOES close — the conjunction is satisfiable, not merely restrictive"
    (not (vadimonium-owed-p *vad-2* (list (%plant-appearance-receipt *vad-2*)))))
(ck "CEILING  and that same positive control IS A FULLY-COPIED FORGERY: no transition minted it, it declares every field correctly, and it closes — the fold reads DECLARED ANATOMY, never provenance, because a receipt is an ACCOUNT and not an AUTHENTICATION"
    (let ((forgery (%plant-appearance-receipt *vad-2*)))
      (and (appearance-receipt-p forgery)
           (not (%same (appearance-receipt-identity forgery)
                       (appearance-receipt-identity *appearance*)))
           (not (vadimonium-owed-p *vad-2* (list forgery))))))
(ck "FOLD  a receipt built for vadimonium 2 does not close vadimonium 1, and the reverse also holds"
    (and (vadimonium-owed-p *vad-1* (list (%plant-appearance-receipt *vad-2*)))
         (vadimonium-owed-p *vad-2* (list (%plant-appearance-receipt *vad-1*)))))
(ck "FOLD  a desertion record, a refusal and a bare CD/0 datum in one history close nothing"
    (vadimonium-owed-p *vad-2* (list *desertion* *near-1* *s2* *receipt-2*)))
(ck "FOLD  the procedure also rides inside the CONTENT identity, so a content computed under a foreign procedure cannot close either — this is the identity direction, distinct from conjuncts 3 and 4, which police what the receipt DECLARES"
    (vadimonium-owed-p
     *vad-2*
     (list (%make-appearance-receipt
            :identity (%identity (%text ":planted"))
            :target-occurrence-identity (vadimonium-occurrence-identity *vad-2*)
            :target-content-identity (%content-identity
                                      :intent *intent*
                                      :receipt-identity (f2 form-transformation-receipt-identity *receipt-2*)
                                      :awaited-subject-identity (vadimonium-awaited-subject-identity *vad-2*)
                                      :scope *scope*
                                      :grammar-identity (f1 petition-grammar-identity)
                                      :grammar-version (f1 petition-grammar-version)
                                      :policy-identity (f1 petition-policy-identity)
                                      :policy-version 99)
            :witness-facts nil :previous-commitment :owed :resulting-commitment :appeared
            :residue nil :procedure-identity (%procedure-identity)
            :procedure-version +procedure-version+))))

;;; ==================================================================
(section "L2 — THE CONTENT IDENTITY'S COMPOSITION, PINNED COMPONENT BY COMPONENT")
;;; ==================================================================
(desk "ADDED AFTER CENSOR F-3, which was the builder's own flagged concern")
(desk "confirmed by execution: with BOTH intent and scope deleted from the")
(desk "%content-identity list, the whole hundred-check suite still ran green,")
(desk "because no fixture ever varied one §6 component while holding the rest.")
(desk "Two undertakings differing only in scope would then have collided in both")
(desk "identities, and one's receipt would have closed the other.")
(desk "")
(desk "Each check below varies EXACTLY ONE component and asserts the content")
(desk "identity MOVES.  Together they pin the composition: a component that")
(desk "silently left the list would turn its own check red.")

;;; TEETH, clearly marked: these call %CONTENT-IDENTITY directly, because the
;;; point is to vary one argument at a time — something no public surface
;;; permits, and rightly.
(defun %content-of (&key (intent (vadimonium-intent *vad-2*))
                         (receipt-identity (vadimonium-transformation-receipt-identity *vad-2*))
                         (awaited (vadimonium-awaited-subject-identity *vad-2*))
                         (scope (vadimonium-scope *vad-2*))
                         (grammar-identity (getf (vadimonium-retained-expectations *vad-2*)
                                                 :grammar-identity))
                         (grammar-version (getf (vadimonium-retained-expectations *vad-2*)
                                                :grammar-version))
                         (policy-identity (getf (vadimonium-retained-expectations *vad-2*)
                                                :policy-identity))
                         (policy-version (getf (vadimonium-retained-expectations *vad-2*)
                                               :policy-version)))
  (%content-identity :intent intent :receipt-identity receipt-identity
                     :awaited-subject-identity awaited :scope scope
                     :grammar-identity grammar-identity :grammar-version grammar-version
                     :policy-identity policy-identity :policy-version policy-version))

(ck "the harness's own recomposition of vadimonium 2's content identity REPRODUCES it exactly — without this, the eight checks below would vary components of a list nobody uses"
    (%same (%content-of) (vadimonium-content-identity *vad-2*)))

(macrolet ((moves (label &rest overrides)
             `(ck ,label (not (%same (%content-of ,@overrides)
                                     (vadimonium-content-identity *vad-2*))))))
  (moves "COMPOSITION 1/8  varying INTENT alone moves the content identity"
         :intent (%text "some entirely different undertaking"))
  (moves "COMPOSITION 2/8  varying the TRANSFORMATION-RECEIPT IDENTITY alone moves it"
         :receipt-identity (f2 form-transformation-receipt-identity *receipt-1*))
  (moves "COMPOSITION 3/8  varying the AWAITED SUBJECT IDENTITY alone moves it"
         :awaited (%identity *s3*))
  (moves "COMPOSITION 4/8  varying SCOPE alone moves it"
         :scope (%text "some entirely different scope"))
  (moves "COMPOSITION 5/8  varying the RETAINED GRAMMAR IDENTITY alone moves it"
         :grammar-identity (%id '("some-other-grammar") '("petition" "0")))
  (moves "COMPOSITION 6/8  varying the RETAINED GRAMMAR VERSION alone moves it"
         :grammar-version 99)
  (moves "COMPOSITION 7/8  varying the RETAINED POLICY IDENTITY alone moves it"
         :policy-identity (%id '("some-other-policy") '("candidate" "0")))
  (moves "COMPOSITION 8/8  varying the RETAINED POLICY VERSION alone moves it"
         :policy-version 99))

(ck "and the composition is ORDER-BEARING, not a set: swapping intent and scope with each other moves the identity, so two components cannot quietly trade places"
    (not (%same (%content-of :intent (vadimonium-scope *vad-2*)
                             :scope (vadimonium-intent *vad-2*))
                (vadimonium-content-identity *vad-2*))))

;;; ==================================================================
(section "M — THE READER BOUNDARY")
;;; ==================================================================
(desk "Read-only slots stop slot REPLACEMENT.  They do not make a mutable value")
(desk "reachable through a reader immutable.  Each tooth below mutates a value")
(desk "obtained THROUGH a public reader and asserts the stored object did not")
(desk "move.")

;;; REPAIRED AFTER CENSOR F-1.  The shape shipped in the first round could not
;;; fail for ANY consistent reader: it captured BEFORE by calling the reader, so
;;; under an ALIASING reader `before`, `view` and the third read were one object
;;; and the mutation moved all three together — a self-comparison rendering `ok`.
;;; CENSOR reintroduced the exact de-pignore D1 defect (three readers un-
;;; snapshotted) and all four teeth still went green, while a caller could
;;; genuinely move the retained rule out from under the fold.
;;;
;;; The repaired shape bites twice, independently:
;;;   (a) BEFORE is an INDEPENDENT COPY-TREE, taken before any mutation, so an
;;;       aliasing reader's third read differs from it;
;;;   (b) two successive reads must not be EQ, so a reader that hands back the
;;;       stored structure fails on freshness alone.
;;; VIEW-B is obtained BEFORE VIEW-A is tampered, so (b) tests the reader and
;;; not the tamper.
(macrolet ((no-alias (label reader object)
             `(ck ,label
                  (let* ((before (copy-tree (,reader ,object)))
                         (view-a (,reader ,object))
                         (view-b (,reader ,object)))
                    (when (consp view-a) (setf (car view-a) :tampered))
                    (and (consp before)
                         (not (eq view-a view-b))
                         (equal before (,reader ,object)))))))
  (no-alias "ALIASING 1  mutating a RETAINED-EXPECTATIONS view does not move the vadimonium's retained rule"
            vadimonium-retained-expectations *vad-2*)
  (no-alias "ALIASING 2  mutating a WITNESS-FACTS view does not retarget the appearance receipt"
            appearance-receipt-witness-facts *appearance*)
  (no-alias "ALIASING 3  mutating a REFUSAL-FACTS view does not rewrite the desertion record"
            desertion-record-refusal-facts *desertion*)
  (no-alias "ALIASING 4  mutating an OFFENDING view does not change the refusal"
            vadimonium-refusal-offending *near-1*))

(ck "ALIASING 5  after every caller-side view mutation above, the true appearance receipt STILL closes its vadimonium"
    (not (vadimonium-owed-p *vad-2* *history-2-closed*)))
(ck "IDENTITY READERS  hand out CD/0 datum VALUES whose interior CD/0 copies on access — mutating the octets a reader yields changes nothing (a CD/0 guarantee, not this file's)"
    (let* ((identity (vadimonium-occurrence-identity *vad-2*))
           (before (copy-seq (cd0 bytes-datum-value identity)))
           (octets (cd0 bytes-datum-value identity)))
      (setf (aref octets 0) (logxor 255 (aref octets 0)))
      (and (not (equalp before octets))                        ; the mutation really landed
           (equalp before (cd0 bytes-datum-value identity))    ; the datum did not move
           (%same identity (vadimonium-occurrence-identity *vad-2*)))))

;;; ==================================================================
(section "N — THE SNAPSHOT BOUNDARY, DIRECTLY")
;;; ==================================================================
(desk "The copier is toothed as a unit rather than through an advertised refusal")
(desk "reason, because every caller-supplied SEMANTIC input on this file's")
(desk "surfaces is a CD/0 datum: the copier never meets caller garbage there, and")
(desk "a refusal code with no executable path is a phantom.")

(ck "SNAPSHOT  a function object is a TYPED refusal, not a printer error"
    (handler-case (progn (%snapshot (list :intent #'car)) nil)
      (unsupported-snapshot-value () t)))
(ck "SNAPSHOT  a circular cons is a TYPED refusal, and it TERMINATES"
    (let ((c (list 1 2)))
      (setf (cdr (last c)) c)
      (handler-case (progn (%snapshot c) nil)
        (unsupported-snapshot-value () t))))
(ck "SNAPSHOT  nesting past the depth limit is a TYPED refusal"
    (let ((deep nil))
      (dotimes (i (* 4 +snapshot-depth-limit+)) (setf deep (list deep)))
      (handler-case (progn (%snapshot deep) nil)
        (unsupported-snapshot-value () t))))
(ck "SNAPSHOT  a CD/0 datum is ACCEPTED by reference — the boundary does not reject the system's own canonical species"
    (let ((d (%id '("probe") '("datum"))))
      (eq d (%snapshot d))))
(ck "SNAPSHOT  a string is COPIED, so a caller cannot mutate a stored one through the copy"
    (let* ((s (copy-seq "clearance"))
           (snap (%snapshot s)))
      (setf (aref s 0) #\X)
      (and (string= snap "clearance") (not (eq s snap)))))

;;; ==================================================================
(section "O — CONDITION CLASSIFICATION: PLANTED FAULTS MUST ESCAPE")
;;; ==================================================================
(desk "No condition handler exists on any transition path in this file.  A")
(desk "governing layer that SIGNALS is an implementation failure, and an")
(desk "implementation failure wearing a protocol outcome's name is the exact")
(desk "defect de-pignore's second review found.  Both plants below live in a")
(desk "controlled dynamic extent with UNWIND-PROTECT restoration; no file on")
(desk "disk is modified.")

;;; MEASURED LIMITATION, stated because it changed the fixture.  The first
;;; version of ESCAPE 1 planted on FORM-TRANSFORMATION-RECEIPT-OUTPUT-DATUM-
;;; IDENTITY and the plant never fired: that reader is a DEFSTRUCT accessor,
;;; which SBCL open-codes, so replacing its FDEFINITION cannot reach an existing
;;; call site.  The tooth would have passed vacuously had it not been written to
;;; distinguish "escaped" from "neither escaped nor laundered".  The plant is
;;; therefore set on CD/0's EQUAL-DATUM — an ordinary DEFUN, and the exact
;;; governing call UNDERTAKE makes to check the successor against the receipt.
(ck "ESCAPE 1  a planted unexpected condition inside the CD/0 comparison UNDERTAKE consults ESCAPES; it is not laundered into a semantic refusal"
    (let ((original (fdefinition 'lisp-plus-cd0:equal-datum))
          (escaped nil) (laundered nil))
      (unwind-protect
           (progn
             (setf (fdefinition 'lisp-plus-cd0:equal-datum)
                   (lambda (&rest ignored) (declare (ignore ignored))
                     (error "PLANTED UNEXPECTED CONDITION")))
             (handler-case
                 (multiple-value-bind (v refusal)
                     (try-undertake-vadimonium :transformation-receipt *receipt-2*
                                               :successor *s2* :vadimonium-act-id *act-2-bis*
                                               :intent *intent* :scope-description *scope*)
                   (declare (ignore v))
                   (setf laundered (and refusal (vadimonium-refusal-reason refusal))))
               (error () (setf escaped :implementation-failure))))
        (setf (fdefinition 'lisp-plus-cd0:equal-datum) original))
      (and (eq :implementation-failure escaped) (null laundered))))

(ck "ESCAPE 2  a planted unexpected condition inside the Form /1 reader PRESENT consults ESCAPES the same way"
    (let ((original (fdefinition 'lisp-plus-form1:validated-petition-form-subject-identity))
          (escaped nil) (laundered nil))
      (unwind-protect
           (progn
             (setf (fdefinition 'lisp-plus-form1:validated-petition-form-subject-identity)
                   (lambda (&rest ignored) (declare (ignore ignored))
                     (error "PLANTED UNEXPECTED CONDITION")))
             (handler-case
                 (multiple-value-bind (r refusal)
                     (try-present-appearance :vadimonium *vad-2* :witness *v-s2* :history '())
                   (declare (ignore r))
                   (setf laundered (and refusal (vadimonium-refusal-reason refusal))))
               (error () (setf escaped :implementation-failure))))
        (setf (fdefinition 'lisp-plus-form1:validated-petition-form-subject-identity) original))
      (and (eq :implementation-failure escaped) (null laundered))))

(ck "ESCAPE  the plants were RESTORED: the ordinary path works again and the fold is unchanged"
    (and (%same (f2 form-transformation-receipt-output-datum-identity *receipt-2*)
                (vadimonium-awaited-subject-identity *vad-2*))
         (%same (f1 validated-petition-form-subject-identity *v-s2*)
                (vadimonium-awaited-subject-identity *vad-2*))
         (not (vadimonium-owed-p *vad-2* *history-2-closed*))))

;;; ==================================================================
(section "P — THE DECLARED CEILINGS, EXHIBITED")
;;; ==================================================================
(desk "Demonstrated, not solved with a registry.  This is the honest ceiling of")
(desk "a fold over a caller-supplied list, and the specimen exhibits it rather")
(desk "than letting a reader supply a stronger claim for himself.")

(defparameter *second-appearance*
  (nth-value 0 (try-present-appearance :vadimonium *vad-2* :witness *v-s2* :history '())))
(ck "CEILING  a caller who OMITS the appearance receipt from the supplied history obtains a SECOND appearance receipt"
    (appearance-receipt-p *second-appearance*))
(ck "CEILING  the two receipts are byte-identical, so nothing distinguishes them and no registry exists to notice"
    (%same (appearance-receipt-identity *appearance*)
           (appearance-receipt-identity *second-appearance*)))
(ck "CEILING  and with the receipt PRESENT in the history, the second attempt is refused — exactness is relative to what the caller supplies"
    (let ((r (nth-value 1 (try-present-appearance :vadimonium *vad-2* :witness *v-s2*
                                                  :history (list *appearance*)))))
      (and r (eq :already-appeared (vadimonium-refusal-reason r)))))

(desk "")
(desk "The second ceiling, added after CENSOR F-5 and previously stated nowhere:")
(desk "RECORD-DESERTION binds its evidence to nothing.  UNDERTAKE binds the")
(desk "successor to the receipt; PRESENT binds the witness to the awaited")
(desk "subject; DESERT type-checks and stops.  Declared, not pseudo-bound — a")
(desk "half-binding would be a label stronger than the thing.")

(ck "CEILING  CROSS-DESERTION: Form /1's refusal of S1 — a datum vadimonium 2 never awaited, whose own successor S2 validates cleanly — records as a desertion of VADIMONIUM 2 without complaint"
    (let ((cross (nth-value 0 (try-record-desertion
                               :vadimonium *vad-2*
                               :petition-refusal *s1-refusal*
                               :desertion-act-id (occ-tag "act" "desertion" "cross")
                               :history '()))))
      (and (desertion-record-p cross)
           ;; it carries vadimonium 2's identities beside S1's refusal facts,
           ;; as if that had been vadimonium 2's own journey
           (%same (desertion-record-target-occurrence cross)
                  (vadimonium-occurrence-identity *vad-2*))
           (eq :malformed-reference (getf (desertion-record-refusal-facts cross) :code))
           (eq :owed (desertion-record-resulting-commitment cross)))))
(ck "CEILING  and the cross-desertion still never CLOSES anything — an unbound record is an untrue account, never a false closing; the fold's conjuncts are untouched by it"
    (and (vadimonium-owed-p *vad-2* (list (nth-value 0 (try-record-desertion
                                                        :vadimonium *vad-2*
                                                        :petition-refusal *s1-refusal*
                                                        :desertion-act-id (occ-tag "act" "desertion" "cross")
                                                        :history '()))))
         (vadimonium-owed-p *vad-1* (list *desertion*))))

;;; ==================================================================
(section "Q — THE FILE MEASURES ITSELF")
;;; ==================================================================
(desk "These teeth measure CODE, not prose: comment lines are stripped, the")
(desk "needles are assembled at runtime so a check's own label cannot match")
(desk "itself, and the transition-path teeth stop at the harness marker.")

(defparameter *source*
  (with-open-file (stream (merge-pathnames "APPLICATION.lisp" *load-truename*))
    (let ((raw (make-string (file-length stream))))
      (string-upcase (subseq raw 0 (read-sequence raw stream))))))

(defun %strip-comments (text)
  (with-output-to-string (out)
    (with-input-from-string (in text)
      (loop for line = (read-line in nil nil) while line
            for trimmed = (string-left-trim " " line)
            unless (and (plusp (length trimmed)) (char= #\; (char trimmed 0)))
              do (write-line line out)))))

(defparameter *code* (%strip-comments *source*))
(defparameter *transition-path*
  (%strip-comments (subseq *source* 0 (or (search "IX.  HARNESS" *source*)
                                          (length *source*)))))

(ck "no EVAL call form exists anywhere in this file"
    (null (search (concatenate 'string "(EV" "AL ") *code*)))
(ck "no READ-FROM-STRING and no PRIN1-TO-STRING call form exists anywhere in this file"
    (and (null (search (concatenate 'string "(READ-FROM-" "STRING") *code*))
         (null (search (concatenate 'string "(PRIN1-TO-" "STRING") *code*))))
(ck "no double-colon access into any package exists anywhere in this file — every governing name is reached through the external-symbol gate"
    (null (search (concatenate 'string ":" ":") *code*)))
(ck "no HANDLER-CASE, no IGNORE-ERRORS and no broad catch-all handler exists in the TRANSITION PATH"
    (and (null (search (concatenate 'string "HANDLER-" "CASE") *transition-path*))
         (null (search (concatenate 'string "IGNORE-" "ERRORS") *transition-path*))
         (null (search (concatenate 'string "(ERR" "OR () ") *transition-path*))))
(ck "the ONLY HANDLER-BIND in the transition path is the load preamble's style-warning muffler"
    (let ((needle (concatenate 'string "HANDLER-" "BIND")) (count 0) (start 0))
      (loop for hit = (search needle *transition-path* :start2 start)
            while hit do (incf count) (setf start (1+ hit)))
      (= 1 count)))
;;; REPAIRED AFTER CENSOR F-6.  The first round counted occurrences of the
;;; read-only declaration and compared the count to a hard-coded 33 — a fossil
;;; count, not a binding.  CENSOR added a THIRTY-FOURTH, MUTABLE slot and the
;;; check still rendered `ok`, because 33 declarations still existed.  The
;;; repaired version ENUMERATES: it walks each DEFSTRUCT form out of the
;;; comment-stripped source by paren balance, takes every slot specification
;;; after the name/options head, and requires each one to carry the declaration.
;;; A bare-atom slot — the cheapest way to smuggle in a mutable one — is
;;; collected separately and any occurrence fails the check.  No count constant
;;; appears anywhere below.

(defun %skip-to-eol (text i)
  (let ((n (length text)))
    (loop while (and (< i n) (char/= (char text i) #\Newline)) do (incf i))
    i))

(defun %balanced-end (text start)
  "START indexes an open paren.  Return the index just past its match.
Line comments are skipped; no DEFSTRUCT form in this file contains a string or
character literal, and this walker is used on nothing else."
  (let ((depth 0) (i start) (n (length text)))
    (loop while (< i n) do
      (let ((c (char text i)))
        (cond ((char= c #\;) (setf i (%skip-to-eol text i)))
              (t (when (char= c #\() (incf depth))
                 (when (char= c #\))
                   (decf depth)
                   (when (zerop depth) (return-from %balanced-end (1+ i))))
                 (incf i)))))
    n))

(defun %defstruct-slots (text)
  "(values SLOT-SPECIFICATION-STRINGS BARE-TOKEN-COUNT DEFSTRUCT-COUNT).
The first child group of a DEFSTRUCT is its name/options head; every later one
is a slot.  Anything at slot position that is NOT a parenthesized group is
counted as a bare token, because a bare-atom slot is mutable by default."
  (let ((slots '()) (bare 0) (structs 0) (start 0)
        (needle (concatenate 'string "(DEFS" "TRUCT ")))
    (loop for hit = (search needle text :start2 start)
          while hit do
            (incf structs)
            (let* ((end (%balanced-end text hit))
                   (i (+ hit (length needle)))
                   (children '()))
              (loop while (< i (1- end)) do
                (let ((c (char text i)))
                  (cond ((char= c #\;) (setf i (%skip-to-eol text i)))
                        ((member c '(#\Space #\Tab #\Newline #\Return)) (incf i))
                        ((char= c #\()
                         (let ((child-end (%balanced-end text i)))
                           (push (subseq text i child-end) children)
                           (setf i child-end)))
                        (t (incf bare)
                           (loop while (and (< i (1- end))
                                            (not (member (char text i)
                                                         '(#\Space #\Tab #\Newline #\Return
                                                           #\( #\) #\;))))
                                 do (incf i))))))
              (setf children (reverse children))
              ;; children[0] is the (name (:option ...) ...) head
              (setf slots (append slots (cdr children)))
              (setf start end)))
    (values slots bare structs)))

(multiple-value-bind (slots bare structs) (%defstruct-slots *code*)
  (desk "defstructs found ~D · slot specifications enumerated ~D · bare-atom slots ~D"
        structs (length slots) bare)
  (ck "EVERY slot of EVERY defstruct in this file is declared read-only — the slots are ENUMERATED from the source by paren balance, never counted against a constant, so a thirty-fourth mutable slot turns this red"
      (let ((needle (concatenate 'string ":READ-" "ONLY T")))
        (and (plusp structs) (plusp (length slots)) (zerop bare)
             (every (lambda (spec) (search needle (string-upcase spec))) slots))))
  (ck "and no SETF of any private accessor exists anywhere in this file"
      (null (search (concatenate 'string "(SE" "TF (%") *code*))))
(ck "no FUNCALL of any value appears in the transition path"
    (null (search (concatenate 'string "FUN" "CALL") *transition-path*)))
(ck "a function object offered as an intent, as a successor, or as a witness is REFUSED BY TYPE and never called"
    (let ((a (nth-value 1 (try-undertake-vadimonium
                           :transformation-receipt *receipt-2* :successor *s2*
                           :vadimonium-act-id *act-2* :intent (fdefinition 'car)
                           :scope-description *scope*)))
          (b (nth-value 1 (try-undertake-vadimonium
                           :transformation-receipt *receipt-2* :successor (fdefinition 'car)
                           :vadimonium-act-id *act-2* :intent *intent*
                           :scope-description *scope*)))
          (c (nth-value 1 (try-present-appearance :vadimonium *vad-2*
                                                  :witness (fdefinition 'car)))))
      (and (eq :no-elected-intent (vadimonium-refusal-reason a))
           (eq :successor-not-a-datum (vadimonium-refusal-reason b))
           (eq :not-a-validated-form (vadimonium-refusal-reason c)))))

;;; ==================================================================
(section "R — THE EXTERNAL-SYMBOL GATE AND THE REFUSAL CENSUS")
;;; ==================================================================

(ck "every governing name this file used was EXTERNAL in its package — the gate is code, and this file could not have loaded otherwise"
    (and (plusp (length *external-names*))
         (every (lambda (entry)
                  (eq :external (nth-value 1 (find-symbol (cdr entry) (car entry)))))
                *external-names*)))
(desk "governing names used: ~D, across ~D packages"
      (length *external-names*)
      (length (remove-duplicates (mapcar #'car *external-names*) :test #'string=)))

(defparameter *emitted*
  (let ((acc '())) (maphash (lambda (k v) (declare (ignore v)) (push k acc)) *emitted-reasons*) acc))
(ck "D4  every ADVERTISED refusal reason was produced by at least one executed fixture — no phantom codes"
    (null (set-difference +advertised-refusal-reasons+ *emitted*)))
(ck "D4  and every EMITTED refusal reason is advertised — no undocumented code escaped into a record"
    (null (set-difference *emitted* +advertised-refusal-reasons+)))
(desk "advertised ~D · emitted ~D"
      (length +advertised-refusal-reasons+) (length *emitted*))

;;; ==================================================================
(section "WHAT THIS SPECIMEN DOES NOT ESTABLISH")
;;; ==================================================================
(desk "Not that a vadimonium confers standing, truth, authority or any basis.")
(desk "Not that any layer consults one; the substrate does not know it exists.")
(desk "Not global exactly-once appearance; the ceiling is exhibited above.")
(desk "Not persistence, replay, or anything across an image boundary.")
(desk "Not that Language Obligation /0 is warranted; that is the return's")
(desk "question, and this specimen is evidence for it, not an answer to it.")
(desk "Every green above is SELF-CONSISTENCY CERTIFICATION by the author family.")
(desk "A stranger audit is OWED and is not pre-satisfied by any neighbour's.")

(format t "~%— a vadimonium is an author's memory that the stranger is kin~%")
(format t "— the layers refuse to hold it, correctly, and so it is held outside~%")
(format t "— and a deserted undertaking stays deserted, whatever succeeds later~%")

(format t "~%== de-vadimonio: ~D checks produced / ~D failed ==~%"
        (verdict-count) (failure-count))
(format t "   the count is DERIVED from the verdict list this run accumulated.~%")
(format t "   This runner reports only what it executed and asserts no project~%")
(format t "   adoption, freeze, warrant or audit standing.~%")
(when (plusp (failure-count))
  (format t "~%   FAILED:~%")
  (dolist (v (reverse *verdicts*))
    (unless (third v) (format t "     [~3,'0D] ~A~%" (first v) (second v)))))
(finish-output)
(sb-ext:exit :code (if (plusp (failure-count)) 1 0))
