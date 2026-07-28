;;;; surface1.lisp — Language Surface /1, Candidate /0.
;;;;
;;;;   The expansion leaves a receipt.
;;;;   An expansion receipt says what form became what other form.
;;;;   It is silent about whether the transformation preserves meaning.
;;;;
;;;; READ package.lisp FIRST.  The boundary law lives there, including the full
;;;; list of what a receipt does NOT establish.
;;;;
;;;; Run: (load "surface1.lisp")   — it loads CD/0 AND NOTHING ELSE.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (unless (find-package '#:lisp-plus-cd0)
    (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
      ;; CD/0's package definition first: cd0.lisp opens with IN-PACKAGE.
      (load (merge-pathnames "../../canonical-datum/common-lisp/package.lisp"
                             (or *compile-file-truename* *load-truename*)))
      (load (merge-pathnames "../../canonical-datum/common-lisp/cd0.lisp"
                             (or *compile-file-truename* *load-truename*)))))
  (unless (find-package '#:lisp-plus-surface1)
    (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
      (load (merge-pathnames "package.lisp"
                             (or *compile-file-truename* *load-truename*))))))

(in-package #:lisp-plus-surface1)

;;; ==================================================================
;;; CD/0 SHORTHAND.  The only foreign package named in this file.
;;; ==================================================================

(defun %octets (datum) (lisp-plus-cd0:canonical-octets datum))
(defun %octet-count (datum) (lisp-plus-cd0:octets-length (%octets datum)))
(defun %text (s) (lisp-plus-cd0:make-string-datum s))
(defun %int (n) (lisp-plus-cd0:make-integer-datum n))
(defun %seq (list) (lisp-plus-cd0:make-sequence-datum list))
(defun %id (namespace path) (lisp-plus-cd0:make-identifier-datum namespace path))
(defun %entry (key value) (lisp-plus-cd0:make-record-entry key value))
(defun %rec (entries) (lisp-plus-cd0:make-record-datum entries))

(defun %snapshot (datum)
  "A full round trip, so the stored tree shares no structure with anything the
caller retains.  It is also the only honest proof that what we minted can be
READ BACK: CD/0 enforces max-depth on decode, not at construction."
  (lisp-plus-cd0:decode-exact (%octets datum)))

;;; Identity VALUES are lossless OCTETS, never hex, never a digest.
;;; Form /1 repaired Form /0's hex composition because each link embedding a hex
;;; rendering of its predecessor DOUBLES per link.  Reaching for OCTETS-TO-HEX in
;;; a composition path silently invalidates every size analysis in this layer.
(defun %identity (payload) (lisp-plus-cd0:make-bytes-datum (%octets payload)))

(defun identity-octets (identity) (%octet-count identity))

(defun render-identity-hex (identity)
  "DIAGNOSTIC ONLY.  Never embedded into a later identity, never compared, and
never a content address."
  (lisp-plus-cd0:octets-to-hex (%octets identity)))

;;; ==================================================================
;;; LAYER IDENTITY — this layer's own, never a predecessor's.
;;; ==================================================================
;;;
;;; SURFACE /0 DECLARES NO VERSION.  Its package exports exactly ten symbols and
;;; contains no identity or version construct, and the repository already
;;; recorded the finding against itself: its five macros "mint no object, carry
;;; no identity or version of their own, record no before/after, and leave no
;;; artifact behind."  Minting a version FOR Surface /0 from here would be this
;;; layer legislating for a layer it does not own.  So there is NO
;;; surface-0-version field anywhere below, and its absence is deliberate.
;;;
;;; What this layer may lawfully declare is ITS OWN procedure and policy, in the
;;; idiom every Form layer already uses.

(defun expansion-grammar-identity ()
  (%id '("lisp-plus-surface1" "grammar") '("term" "0")))
;;; ERRATA 0.1 — grammar version 1 -> 2.  Shared and circular structure are now
;;; refused GLOBALLY rather than per-spine, so the set of admissible terms is
;;; strictly smaller than Candidate /0's.  A grammar whose admissible set moved
;;; must move its version, or two different grammars answer to one number.
(defun expansion-grammar-version () 2)

(defun expansion-procedure-identity ()
  (%id '("lisp-plus-surface1" "procedure") '("macroexpand" "0")))
;;; ERRATA 0.1 — procedure version 1 -> 2.  Door 2 no longer expands a
;;; caller-owned alias; it reconstructs a fresh private host form from the
;;; stored canonical datum on every performance.  EVERY IDENTITY THIS LAYER
;;; MINTS THEREFORE DIFFERS FROM CANDIDATE /0'S, and that is correct: they are
;;; accounts of a different procedure.
(defun expansion-procedure-version () 2)

(defun expansion-policy-identity ()
  (%id '("lisp-plus-surface1" "policy") '("candidate" "0")))
(defun expansion-policy-version () 1)

;;; ------------------------------------------------------------------
;;; Candidate /0 EXPERIMENTAL ceilings — not universal Lisp+ limits.
;;;
;;; MAX-SOURCE-DEPTH IS MEASURED, NOT COPIED.  CD/0's max-depth is 128 and is
;;; enforced on DECODE only; this grammar costs ~2.03 CD/0 depth units per host
;;; list level, so the largest host form that both encodes and decodes is 63
;;; levels deep, bisected and confirmed by exhibiting the refusal at 64.  The
;;; ceiling here is 48 — inside the measured edge with room for the enclosing
;;; identity payloads, which add their own levels.  A layer that minted a receipt
;;; above the decode edge would be issuing an account whose own octets cannot be
;;; read back.
(defun expansion-policy-max-source-depth () 48)
(defun expansion-policy-max-source-nodes () 20000)
(defun expansion-policy-max-term-octets () 262144)

;;; ==================================================================
;;; THE REFUSAL CATALOGUE — ONE table, two DERIVED lists.
;;; ==================================================================
;;;
;;; Entries are (code class phase note).  There is deliberately NO flat list of
;;; all codes: a single list publishes a count that travels without the
;;; distinction it flattens.

;;; Entries are (code class phase reachability note).
;;;
;;; TWO CODES AN EARLIER DRAFT ADVERTISED ARE ABSENT AND MUST STAY ABSENT.
;;; `:CONSTRUCT-PACKAGE-ABSENT` and `:CONSTRUCT-SYMBOL-ABSENT` were written, then
;;; deleted on inspection as FALSE AFFORDANCES.  Door 2 reaches the package
;;; lookup only after `%LOOKUP-CONSTRUCT` matched on `(package-name
;;; (symbol-package head))` — so the package provably exists, and the symbol
;;; provably exists in it, because the head symbol IS one of its symbols.  No
;;; caller can reach either branch.  A code no caller can reach is a false
;;; affordance, and this lane already owns a documented counterexample for that
;;; defect class.
;;;
;;; reachability
;;;   :public-api                  a fixture in the selftest reaches it
;;;   :public-api-in-a-stub-image  reachable only where the construct package
;;;                                exists WITHOUT its macros — proved in a
;;;                                separate process by STUB-IMAGE-FIXTURE.lisp,
;;;                                because manufacturing that state in this image
;;;                                would mean altering Surface /0, which is
;;;                                forbidden
;;;   :unreachable-under-this-policy  the guard is real and stays, but under THIS
;;;                                policy's numbers another ceiling always fires
;;;                                first.  Measured, not assumed — see the note.
;;;   :internal-planted-fault-only reachable only from inside this package

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
     "the source form contains a term the grammar does not represent")
    (:source-term-shared-structure  :protocol-refusal :request :public-api
     "a cons in the source form is reachable by more than one path — sharing or
a cycle.  ERRATA 0.1: Candidate /0 checked only each list's spine, so sharing
was silently UNFOLDED and a CAR-position cycle exhausted the control stack.")
    (:source-depth-exceeded         :protocol-refusal :request :public-api
     "the source form is nested deeper than the declared source-depth ceiling")
    (:source-nodes-exceeded         :protocol-refusal :request :public-api
     "the source form has more nodes than the declared node ceiling")
    (:source-term-octets-exceeded   :protocol-refusal :request :public-api
     "the encoded source term exceeds the declared term-octet ceiling")
    (:not-a-known-surface-construct :protocol-refusal :perform :public-api
     "the head names no entry in the closed construct table")
    (:construct-not-a-macro         :protocol-refusal :perform
     :public-api-in-a-stub-image
     "the resolved symbol has no macro function in this image")
    (:expanded-term-unrepresentable :protocol-refusal :perform :public-api
     "the EXPANDED form contains a term the grammar does not represent — this is
the code an implementation-generated name lands under")
    (:expanded-term-shared-structure :protocol-refusal :perform :public-api
     "a cons in the EXPANDED form is reachable by more than one path")
    (:source-not-reconstructible    :protocol-refusal :perform :public-api
     "the stored canonical source datum could not be reconstructed into a host
form in THIS image — a package or a symbol it names is gone.  ERRATA 0.1: this
code exists because reconstruction resolves symbols with FIND-SYMBOL and never
INTERN; a reconstruction that interned would change the image it claims to read.")
    (:expanded-depth-exceeded       :protocol-refusal :perform :public-api
     "the expanded form is nested deeper than the declared source-depth ceiling")
    (:expanded-nodes-exceeded       :protocol-refusal :perform
     :unreachable-under-this-policy
     "the expanded form has more nodes than the declared node ceiling.  MEASURED
UNREACHABLE UNDER THIS POLICY: the checks run depth -> nodes -> encode -> octets,
and each term costs roughly 120 octets, so an expansion meets the 262144-octet
ceiling at about 2000 nodes and can never approach 20000.  The guard is real and
STAYS — a future policy with a larger octet ceiling would reach it.  The ceiling
was NOT raised to make it theatrically reachable, and the handler was NOT deleted
to make a coverage table look complete.  Its source-side twin is genuinely
reachable, because the node check runs BEFORE encoding.")
    (:expanded-term-octets-exceeded :protocol-refusal :perform :public-api
     "the encoded expanded term exceeds the declared term-octet ceiling")
    (:source-identity-projection-mismatch :integrity-alarm :receipt
     :internal-planted-fault-only
     "the stored source-form identity does not equal the identity recomputed from
the stored source-form datum")
    (:expanded-identity-projection-mismatch :integrity-alarm :receipt
     :internal-planted-fault-only
     "the stored expanded-form identity does not equal the identity recomputed
from the stored expanded-form datum")
    (:procedure-version-mismatch    :integrity-alarm :receipt
     :internal-planted-fault-only
     "the receipt's procedure version does not equal the package's"))
  "The stable refusal codes.  A reader may branch on these; they are not prose.")

(defun expansion-refusal-code-catalog () (copy-tree +refusal-catalog+))
(defun refusal-catalog-entry-code (e) (first e))
(defun refusal-catalog-entry-class (e) (second e))
(defun refusal-catalog-entry-phase (e) (third e))
(defun refusal-catalog-entry-reachability (e) (fourth e))
(defun refusal-catalog-entry-note (e) (fifth e))

(defun expansion-protocol-refusal-codes ()
  (mapcar #'first (remove-if-not (lambda (e) (eq :protocol-refusal (second e)))
                                 +refusal-catalog+)))
(defun expansion-integrity-alarm-codes ()
  (mapcar #'first (remove-if-not (lambda (e) (eq :integrity-alarm (second e)))
                                 +refusal-catalog+)))

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
  (occurrence-tag nil :read-only t)
  ;; UPSTREAM PRESERVATION: when this layer reclassifies a CD/0 refusal, the
  ;; reclassification is an ADDED READING, never an overwrite.
  (upstream-category nil :read-only t)
  (upstream-code nil :read-only t)
  (upstream-stage nil :read-only t))

(define-condition expansion-refused (error)
  ((refusal :initarg :refusal :reader expansion-condition-refusal))
  (:report (lambda (c s)
             (let ((r (expansion-condition-refusal c)))
               (format s "expansion refused (~S) in ~S: ~A"
                       (expansion-refusal-code r)
                       (expansion-refusal-phase r)
                       (or (expansion-refusal-detail r) ""))))))

(defun %refusal-class (code)
  (let ((e (assoc code +refusal-catalog+)))
    (unless e (error "internal: undeclared refusal code ~S" code))
    (second e)))

(defun %refuse (phase code &key detail occurrence-tag
                             upstream-category upstream-code upstream-stage)
  (let* ((class (%refusal-class code))
         (id (%identity
              (%seq (list (%text ":refusal")
                          (%text (string code))
                          (%text (string phase))
                          (%text (string class))
                          (or occurrence-tag (%id '("lisp-plus-surface1" "tag")
                                                  '("no-tag")))
                          (expansion-procedure-identity)
                          (%int (expansion-procedure-version))))))
         (r (%make-refusal :identity id :phase phase :category class :code code
                           :detail detail :occurrence-tag occurrence-tag
                           :upstream-category upstream-category
                           :upstream-code upstream-code
                           :upstream-stage upstream-stage)))
    (error 'expansion-refused :refusal r)))

;;; ==================================================================
;;; THE TERM GRAMMAR.
;;; ==================================================================
;;;
;;; Every term is a CD/0 record of exactly two fields.  Nothing is implicit and
;;; nothing is inferred from position.
;;;
;;; NOTE ON RECORD ORDER: CD/0 sorts record entries by key bytes at
;;; construction, so a record can never carry an ordered mapping.  That is why
;;; a LIST's elements are a SEQUENCE and not a record — and why the two fields
;;; here are looked up by key and never by index.

(defparameter +term-kinds+ '("SYMBOL" "INTEGER" "STRING" "LIST")
  "The complete term inventory.  A host object outside it is REFUSED, never
rendered, never printed into a string, and never stored as an opaque blob.")

(defun term-kinds () (copy-list +term-kinds+))

(defun %term-key (name) (%id '("TERM") (list name)))
(defun %kind-datum (kind) (%id '("TERMKIND") (list kind)))

(defun %term (kind value)
  (%rec (list (%entry (%term-key "KIND") (%kind-datum kind))
              (%entry (%term-key "VALUE") value))))

(define-condition %term-unrepresentable (error)
  ((reason :initarg :reason :reader %tu-reason)
   (shown :initarg :shown :reader %tu-shown)))

(defun %describe-host-object (object)
  "A SHORT, BOUNDED type description for a refusal DETAIL.  It is deliberately
NOT the object's printed representation and never enters a datum: a rendering of
an object is not the object, and a receipt that stored one would be accounting
for a rendering.  This string reaches a human in a refusal, and nowhere else."
  (let ((tn (string (type-of object))))
    (subseq tn 0 (min 40 (length tn)))))

;;; ------------------------------------------------------------------
;;; THE GLOBAL SHARING / CYCLE CHECK.        [ERRATA 0.1 — finding 2]
;;; ------------------------------------------------------------------
;;;
;;; Candidate /0 checked only the SPINE of each list, with a fresh table per
;;; call.  That check could not see a subtree reachable by two different paths,
;;; so a shared subtree and two distinct equal copies encoded IDENTICALLY —
;;; while package.lisp claimed shared structure was refused.  The claim was
;;; false and the check was the wrong shape.
;;;
;;; This is a GLOBAL traversal counting REFERENCES to each cons.  A cons
;;; reachable by more than one path has a reference count above one, and that
;;; single measurement covers BOTH sharing and cycles — a cycle is just a
;;; reference that returns.  It is guarded, so it terminates on cyclic input,
;;; and it iterates on the spine and recurses only into CARs, so a long list
;;; does not exhaust the stack.

(defun %shared-cons-count (form)
  "Number of conses reachable from FORM by more than one path.  Zero for a pure
tree; positive for any sharing or any cycle."
  (let ((refs (make-hash-table :test 'eq))
        (guard (make-hash-table :test 'eq))
        (shared 0))
    (labels ((visit (f)
               (loop while (consp f)
                     do (incf (gethash f refs 0))
                        (when (gethash f guard) (return))
                        (setf (gethash f guard) t)
                        (visit (car f))
                        (setf f (cdr f)))))
      (visit form))
    (maphash (lambda (k v) (declare (ignore k)) (when (> v 1) (incf shared))) refs)
    shared))

(defun encode-term (form)
  "Encode a host FORM under the declared term grammar, or signal
%TERM-UNREPRESENTABLE.  Public because a reader must be able to check the
grammar without taking this file's word for it.

THE GLOBAL SHARING CHECK RUNS FIRST, once, before any recursion.  Doing it here
rather than in the caller is what makes this PUBLIC function safe: in Candidate
/0 a CAR-position cycle handed straight to ENCODE-TERM exhausted the control
stack instead of refusing."
  (let ((shared (%shared-cons-count form)))
    (when (plusp shared)
      (error '%term-unrepresentable
             :reason :shared-or-circular-structure
             :shown (format nil "~D cons(es) reachable by more than one path; the grammar has no DAG and no cycle" shared))))
  (%encode-term-1 form))

(defun %encode-term-1 (form)
  "The recursive body.  Assumes the global sharing check has already passed, so
it never re-walks and never revisits — encoding stays linear."
  (cond
    ;; SYMBOL — including NIL and T, which ARE symbols in Common Lisp.  The
    ;; empty list and the symbol NIL are one object in this host and the grammar
    ;; does not pretend to separate them.
    ((symbolp form)
     (let ((pkg (symbol-package form)))
       (unless pkg
         (error '%term-unrepresentable :reason :uninterned-symbol
                                       :shown "an uninterned symbol has no package, so it has no namespace"))
       (when (zerop (length (symbol-name form)))
         (error '%term-unrepresentable :reason :empty-symbol-name
                                       :shown "a zero-length name cannot be an identifier segment"))
       (%term "SYMBOL" (%id (list (package-name pkg)) (list (symbol-name form))))))
    ((integerp form) (%term "INTEGER" (%int form)))
    ((stringp form)  (%term "STRING"  (%text form)))
    ((consp form)
     ;; Sharing and cycles are already excluded by ENCODE-TERM's global check,
     ;; so this only has to name the one remaining shape the grammar lacks.
     (let ((walk form))
       (loop while (consp walk) do (setf walk (cdr walk)))
       (unless (null walk)
         (error '%term-unrepresentable :reason :improper-list
                                       :shown "a dotted tail is a term the grammar does not name")))
     (%term "LIST" (%seq (mapcar #'%encode-term-1 form))))
    (t (error '%term-unrepresentable :reason :no-term-kind
                                     :shown (%describe-host-object form)))))

;;; ==================================================================
;;; DECODE-TERM — THE INVERSE.                [ERRATA 0.1 — finding 1]
;;; ==================================================================
;;;
;;; Candidate /0 retained the CALLER'S OWN CONS TREE and handed that to the
;;; macroexpander at Door 2.  A caller who mutated the tree after Door 1 got a
;;; receipt whose stored source datum was the PRE-mutation form and whose
;;; expanded datum was computed from the POST-mutation form — a FALSE EDGE, and
;;; a truthfulness defect rather than missing coverage.  Reproduced at
;;; `errata-0.1/REPRODUCTION.lisp`, findings 1a/1b/1c.
;;;
;;; The repair makes the IMMUTABLE CANONICAL SOURCE DATUM THE SINGLE AUTHORITY.
;;; Door 2 reconstructs a FRESH PRIVATE HOST FORM from that datum on EVERY
;;; performance, and expands that.  The caller's tree is read exactly once, at
;;; Door 1, and never consulted again.
;;;
;;; SYMBOLS ARE RESOLVED WITH FIND-SYMBOL AND NEVER INTERN.  A reconstruction
;;; that interned would CHANGE the image it claims to be reading, and would
;;; manufacture a symbol that the caller never wrote.  If a package or a symbol
;;; has gone from the image between the doors, that is a refusal with its own
;;; code, not a silent re-creation.
;;;
;;; STRINGS ARE COPIED.  CD/0's reader already returns a fresh string; the
;;; explicit COPY-SEQ makes the isolation a property of THIS file rather than an
;;; inherited one, so a future CD/0 that stopped copying could not silently
;;; re-open finding 1b.

(define-condition %term-irreconstructible (error)
  ((reason :initarg :reason :reader %ti-reason)
   (shown :initarg :shown :reader %ti-shown)))

(defun %seg (segments index)
  (if (< index (length segments)) (aref segments index) nil))

(defun decode-term (datum)
  "Reconstruct a FRESH host form from a term DATUM.  Public, because the claim
that the stored datum IS what the macroexpander received is only checkable if a
reader can perform the reconstruction independently."
  (unless (lisp-plus-cd0:record-datum-p datum)
    (error '%term-irreconstructible :reason :not-a-term-record
                                    :shown "a term is a record of KIND and VALUE"))
  (multiple-value-bind (kind-d kind-ok)
      (lisp-plus-cd0:record-datum-ref datum (%term-key "KIND"))
    (multiple-value-bind (value-d value-ok)
        (lisp-plus-cd0:record-datum-ref datum (%term-key "VALUE"))
      (unless (and kind-ok value-ok)
        (error '%term-irreconstructible :reason :term-fields-absent
                                        :shown "a term needs both KIND and VALUE"))
      (unless (lisp-plus-cd0:identifier-datum-p kind-d)
        (error '%term-irreconstructible :reason :term-kind-not-an-identifier :shown ""))
      (let ((kind (%seg (lisp-plus-cd0:identifier-datum-path kind-d) 0)))
        (cond
          ((string= kind "SYMBOL")
           (unless (lisp-plus-cd0:identifier-datum-p value-d)
             (error '%term-irreconstructible :reason :symbol-value-not-an-identifier :shown ""))
           (let* ((package-name (%seg (lisp-plus-cd0:identifier-datum-namespace value-d) 0))
                  (symbol-name (%seg (lisp-plus-cd0:identifier-datum-path value-d) 0))
                  (package (and package-name (find-package package-name))))
             (unless package
               (error '%term-irreconstructible :reason :package-absent-in-image
                                               :shown (or package-name "<no namespace>")))
             (multiple-value-bind (symbol status) (find-symbol symbol-name package)
               (unless status
                 (error '%term-irreconstructible :reason :symbol-absent-in-image
                                                 :shown symbol-name))
               symbol)))
          ((string= kind "INTEGER") (lisp-plus-cd0:integer-datum-value value-d))
          ((string= kind "STRING")  (copy-seq (lisp-plus-cd0:string-datum-value value-d)))
          ((string= kind "LIST")
           (loop for i from 0 below (lisp-plus-cd0:sequence-datum-length value-d)
                 collect (decode-term (lisp-plus-cd0:sequence-datum-ref value-d i))))
          (t (error '%term-irreconstructible :reason :unknown-term-kind
                                             :shown (or kind "<none>"))))))))

;;; THE MEASUREMENTS MUST SURVIVE HOSTILE STRUCTURE.
;;;
;;; They run BEFORE the encoder, so they meet improper lists, spine cycles and
;;; CAR cycles first and must not die or hang on any of them — a measurement
;;; that crashes on a dotted tail turns a designed refusal into a host accident.
;;; Both walk the spine ITERATIVELY (a long list is ordinary) and recurse only
;;; into CARs, under a budget so a circular CAR chain saturates instead of
;;; hanging.  Saturation always lands ABOVE the ceiling, so it always refuses.

(defun %host-depth (form &optional (budget (+ 2 (expansion-policy-max-source-depth))))
  (cond ((not (consp form)) 0)
        ((<= budget 0) 1)
        (t (let ((best 0) (walk form) (spine (make-hash-table :test 'eq)))
             (loop while (consp walk)
                   do (when (gethash walk spine) (return))
                      (setf (gethash walk spine) t)
                      (setf best (max best (1+ (%host-depth (car walk) (1- budget)))))
                      (setf walk (cdr walk)))
             ;; a dotted tail is an element too, and is not silently dropped
             (when (and walk (not (consp walk))) (setf best (max best 1)))
             best))))

(defun %host-nodes (form &optional (budget (+ 2 (expansion-policy-max-source-depth))))
  (cond ((not (consp form)) 1)
        ((<= budget 0) 1)
        (t (let ((total 0) (walk form) (spine (make-hash-table :test 'eq)))
             (loop while (consp walk)
                   do (when (gethash walk spine) (return))
                      (setf (gethash walk spine) t)
                      (incf total (1+ (%host-nodes (car walk) (1- budget))))
                      (setf walk (cdr walk)))
             (when (and walk (not (consp walk))) (incf total 1))
             total))))

(defun %encode-checked (form phase tag depth-code nodes-code term-code
                        octets-code shared-code)
  "Encode FORM, enforcing this layer's declared ceilings BEFORE and AFTER, and
reclassifying a term failure into a typed Surface /1 refusal with the upstream
reason preserved."
  (when (> (%host-depth form) (expansion-policy-max-source-depth))
    (%refuse phase depth-code :occurrence-tag tag
             :detail (format nil "host depth ~D exceeds ceiling ~D"
                             (%host-depth form) (expansion-policy-max-source-depth))))
  (when (> (%host-nodes form) (expansion-policy-max-source-nodes))
    (%refuse phase nodes-code :occurrence-tag tag
             :detail (format nil "host nodes ~D exceeds ceiling ~D"
                             (%host-nodes form) (expansion-policy-max-source-nodes))))
  (let ((datum
          (handler-case (encode-term form)
            (%term-unrepresentable (c)
              (%refuse phase
                       (if (eq :shared-or-circular-structure (%tu-reason c))
                           shared-code
                           term-code)
                       :occurrence-tag tag
                       :detail (%tu-shown c)
                       :upstream-category "TermGrammar"
                       :upstream-code (string (%tu-reason c))
                       :upstream-stage "term-encode")))))
    (when (> (%octet-count datum) (expansion-policy-max-term-octets))
      (%refuse phase octets-code :occurrence-tag tag
               :detail (format nil "encoded term ~D octets exceeds ceiling ~D"
                               (%octet-count datum) (expansion-policy-max-term-octets))))
    ;; The snapshot is also the proof that the term can be READ BACK, not merely
    ;; built.  If this ever signals, the depth ceiling above is wrong.
    (%snapshot datum)))

;;; ==================================================================
;;; THE CLOSED CONSTRUCT TABLE.
;;; ==================================================================
;;;
;;; NEW LAW, DECLARED HERE.  Form /2 could say "the API takes DATA only, and a
;;; CD/0 datum cannot be a function."  This layer cannot say that: it invokes a
;;; macro function.  The gate that replaces the impossibility is this table —
;;; CLOSED, EXHAUSTIVE, and written as STRINGS so that no host symbol is a
;;; durable name and this file names no foreign package at load time.
;;;
;;; An unknown head is ONE honest code.  This layer does NOT reproduce Surface
;;; /0's grammar in order to say "that is a Surface /0 form" — a second
;;; representation of another layer's vocabulary, maintained here, free to drift.

(defparameter +constructs+
  '(("LISP-PLUS-SURFACE0" "DEFINE-JUDGMENT-SCHEMA"    "define-judgment-schema")
    ("LISP-PLUS-SURFACE0" "DEFINE-ADMISSION-CONTRACT" "define-admission-contract")
    ("LISP-PLUS-SURFACE0" "DEFINE-SLICE2-SCHEMA"      "define-slice2-schema")
    ("LISP-PLUS-SURFACE0" "DERIVE-CASE"               "derive-case")
    ("LISP-PLUS-SURFACE0" "DERIVE/2-CASE"             "derive/2-case")))

(defun known-surface-constructs () (copy-tree +constructs+))
(defun surface-construct-entry-namespace (e) (first e))
(defun surface-construct-entry-name (e) (second e))
(defun surface-construct-entry-identity (e)
  (%id '("lisp-plus-surface1" "construct") (list (third e))))

(defun %lookup-construct (package-name symbol-name)
  (find-if (lambda (e) (and (string= package-name (first e))
                            (string= symbol-name (second e))))
           +constructs+))

(defun construct-identity-for (package-name symbol-name)
  "The durable identity of a known construct, or NIL.  The identity lives in
THIS layer's namespace: it identifies what this layer was asked about, and says
nothing about the other layer's implementation, which there is nothing lawful
to say about."
  (let ((e (%lookup-construct package-name symbol-name)))
    (and e (surface-construct-entry-identity e))))

;;; ==================================================================
;;; THE DECLARED OPERATIONS.
;;; ==================================================================
;;;
;;; Exactly the two the host itself provides, and no third.
;;;
;;;   :MACROEXPAND-1  one step.  The form is expanded once, or not at all.
;;;   :MACROEXPAND    repeated expansion OF THE TOP-LEVEL FORM ONLY, until its
;;;                   head is no longer a macro.  It does NOT descend into
;;;                   subforms, and this layer offers nothing that does.
;;;
;;; There is NO :MACROEXPAND-ALL and there must not be one in this candidate: a
;;; full code walker is a compiler's job, and building one here would be a
;;; second language wearing this layer's coat.

(defparameter +operations+ '(:macroexpand-1 :macroexpand))
(defun expansion-operations () (copy-list +operations+))

(defun %operation-disposition (operation)
  "Names the OPERATION THAT RAN, never an adverb about its character."
  (ecase operation
    (:macroexpand-1 :macroexpanded-one-step)
    (:macroexpand   :macroexpanded-repeatedly)))

;;; ==================================================================
;;; THE EXPANSION CONTEXT.
;;; ==================================================================
;;;
;;; WHAT CAN TRUTHFULLY BE RECORDED, AND NOTHING MORE.
;;;
;;; None of the five known constructs accepts an &ENVIRONMENT parameter, so this
;;; layer supplies the NULL LEXICAL ENVIRONMENT and records that it did.
;;;
;;; THAT IS A FACT ABOUT THE CALL, NOT ABOUT THE CONSTRUCT.  This field does NOT
;;; establish that the construct ignored the environment, that no
;;; environment-dependent behaviour occurred, or that any environment was
;;; captured.  NO ENVIRONMENT OBJECT IS EVER CAPTURED, ENCODED OR REPRESENTED
;;; BY THIS LAYER.  A CL macro environment is an opaque implementation object;
;;; there is no portable reader for it, and a serialization of one would be
;;; folklore wearing a language guarantee.

(defun %expansion-context ()
  (%rec (list (%entry (%id '("CONTEXT") '("SUPPLIED-LEXICAL-ENVIRONMENT"))
                      (%id '("lisp-plus-surface1" "environment") '("null")))
              (%entry (%id '("CONTEXT") '("ENVIRONMENT-OBJECT-CAPTURED"))
                      (lisp-plus-cd0:make-boolean-datum nil))
              (%entry (%id '("CONTEXT") '("READ-PERFORMED"))
                      (lisp-plus-cd0:make-boolean-datum nil)))))


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
  (occurrence-tag nil :read-only t))

;;; ERRATA 0.1 — THE `%HOST-FORM` SLOT IS GONE, AND ITS ABSENCE IS THE REPAIR.
;;;
;;; Candidate /0 retained the caller's own cons tree here and handed it to the
;;; macroexpander at Door 2.  There is now NO PATH by which a caller-owned
;;; object reaches Door 2: the request holds an immutable CD/0 datum and
;;; nothing else, and the host form is reconstructed from that datum on every
;;; performance.  This is structural incapacity rather than a guarded
;;; capability — the socket is removed, not watched.

(defun request-expansion (source-form operation occurrence-tag)
  "DOOR 1.  Mint an immutable expansion request.

DOES NOT EXPAND.  Does not resolve the construct, does not require its package
to be loaded, and does not require the head to name a known construct at all —
a request that can never be performed is still a lawful request, and it refuses
at DOOR 2, in its own phase, with its own code.

THE CALLER'S TREE IS READ EXACTLY ONCE, HERE, AND NEVER CONSULTED AGAIN."
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
    (%refuse :request :source-form-head-not-a-symbol :occurrence-tag occurrence-tag
             :detail "the head of the source form is not a symbol"))
  (let* ((datum (%encode-checked source-form :request occurrence-tag
                                 :source-depth-exceeded :source-nodes-exceeded
                                 :source-term-unrepresentable
                                 :source-term-octets-exceeded
                                 :source-term-shared-structure))
         (source-id (%identity datum))
         (head (car source-form))
         (pkg (symbol-package head))
         ;; The construct identity is recorded when the head is KNOWN, and is
         ;; deliberately absent otherwise.  Door 1 does not refuse an unknown
         ;; head; it simply has no durable name to record for it.
         (construct-id (and pkg (construct-identity-for (package-name pkg)
                                                        (symbol-name head))))
         (request-id
           (%identity
            (%seq (list (%text ":request")
                        source-id
                        (%id '("OPERATION") (list (string operation)))
                        (or construct-id
                            (%id '("lisp-plus-surface1" "construct") '("unknown")))
                        occurrence-tag
                        (expansion-grammar-identity)
                        (%int (expansion-grammar-version))
                        (expansion-procedure-identity)
                        (%int (expansion-procedure-version))
                        (expansion-policy-identity)
                        (%int (expansion-policy-version)))))))
    (%make-request :identity request-id
                   :source-form-datum datum
                   :source-form-identity source-id
                   :operation operation
                   :construct-identity construct-id
                   :occurrence-tag occurrence-tag)))

(defun try-request-expansion (source-form operation occurrence-tag)
  "The non-signalling twin.  Returns (values REQUEST-or-NIL REFUSAL-or-NIL).
The signalling form is authoritative; no boolean predicate that could disagree
with it is exported."
  (handler-case (values (request-expansion source-form operation occurrence-tag) nil)
    (expansion-refused (c) (values nil (expansion-condition-refusal c)))))

;;; ==================================================================
;;; THE OCCURRENCE.                          [ERRATA 0.1 — finding 3]
;;; ==================================================================
;;;
;;; Candidate /0 returned an occurrence IDENTITY and defined no occurrence
;;; OBJECT, while the governing brief required one occurrence type.  That was a
;;; requirement variance, recorded as such in the errata, and this is the
;;; repair rather than a ruling that identity-only representation was intended.
;;; The two designs are NOT equated: an identity is a value that says an
;;; occurrence happened; an occurrence is the thing that happened, and it can
;;; be handed around, asked questions, and refused a constructor.
;;;
;;; MINTED ONLY ON A COMPLETED EXPANSION.  For a refusal the object does not
;;; come into existence — not null, not absent-marked.

(defstruct (expansion-occurrence (:constructor %make-occurrence) (:copier nil)
                                 (:predicate expansion-occurrence-p))
  (identity nil :read-only t)
  (request-identity nil :read-only t)
  (expanded-form-datum nil :read-only t)
  (expanded-form-identity nil :read-only t)
  (disposition nil :read-only t)
  (occurrence-tag nil :read-only t))

;;; ==================================================================
;;; THE RECEIPT.
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
  (disposition nil :read-only t))

;;; Version-binding as constant functions, not slots: a receipt cannot disagree
;;; with the package that minted it.
(defun expansion-receipt-procedure-identity (r)
  (declare (ignore r)) (expansion-procedure-identity))
(defun expansion-receipt-procedure-version (r)
  (declare (ignore r)) (expansion-procedure-version))
(defun expansion-receipt-policy-identity (r)
  (declare (ignore r)) (expansion-policy-identity))
(defun expansion-receipt-policy-version (r)
  (declare (ignore r)) (expansion-policy-version))

;;; ------------------------------------------------------------------
;;; PLANTED-FAULT HOOKS.  Reachable only from inside this package.
;;; A gate that has never fired is untested, not passing.
(defparameter *%fault-source-identity* nil)
(defparameter *%fault-expanded-identity* nil)
(defparameter *%fault-procedure-version* nil)

(defun %mint-receipt (request occurrence tag)
  "THE ONLY PATH BY WHICH A RECEIPT COMES INTO BEING.  There is no public
receipt constructor.

The two identity fields are DERIVED PROJECTIONS: they are recomputed here from
the stored data and compared, so a receipt cannot carry an identity that does
not belong to the datum beside it.  This checks the ACCOUNT'S INTERNAL
CONSISTENCY.  It does not, and cannot, check that the account is true of the
world — a receipt is an ACCOUNT, not an AUTHENTICATION."
  (let ((stored-source-id (or *%fault-source-identity*
                              (expansion-request-source-form-identity request)))
        (stored-expanded-id (or *%fault-expanded-identity*
                                (expansion-occurrence-expanded-form-identity occurrence)))
        (version (or *%fault-procedure-version* (expansion-procedure-version))))
    (unless (lisp-plus-cd0:equal-datum
             stored-source-id
             (%identity (expansion-request-source-form-datum request)))
      (%refuse :receipt :source-identity-projection-mismatch :occurrence-tag tag
               :detail "stored source identity does not match the stored source datum"))
    (unless (lisp-plus-cd0:equal-datum
             stored-expanded-id
             (%identity (expansion-occurrence-expanded-form-datum occurrence)))
      (%refuse :receipt :expanded-identity-projection-mismatch :occurrence-tag tag
               :detail "stored expanded identity does not match the stored expanded datum"))
    (unless (eql version (expansion-procedure-version))
      (%refuse :receipt :procedure-version-mismatch :occurrence-tag tag
               :detail "receipt procedure version does not equal the package's"))
    (%make-receipt
     :identity (%identity (%seq (list (%text ":receipt")
                                      (expansion-occurrence-identity occurrence)
                                      (expansion-policy-identity)
                                      (%int (expansion-policy-version)))))
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
     :disposition (expansion-occurrence-disposition occurrence))))

;;; ==================================================================
;;; DOOR 2 — PERFORM.  Meets the actual image.
;;; ==================================================================

(defun %reconstruct-source (request tag)
  "ERRATA 0.1 — the stored canonical datum is the SINGLE AUTHORITY.

Returns a FRESH PRIVATE host form built from the request's immutable source
datum.  A new one is built on EVERY performance, so nothing a caller does to
its own tree, and nothing a macroexpander does to a form it was handed, can
reach a later performance of the same request."
  (handler-case (decode-term (expansion-request-source-form-datum request))
    (%term-irreconstructible (c)
      (%refuse :perform :source-not-reconstructible :occurrence-tag tag
               :detail (%ti-shown c)
               :upstream-category "TermGrammar"
               :upstream-code (string (%ti-reason c))
               :upstream-stage "term-decode"))))

(defun %resolve-macro (form tag)
  "Resolve the construct named by the RECONSTRUCTED form's head, in this image,
through the CLOSED table.  Every failure is its own code — 'not in the table',
'not a macro' — because those are different facts about the world."
  (let* ((head (car form))
         (pkg (and (symbolp head) (symbol-package head))))
    (unless (and pkg (%lookup-construct (package-name pkg) (symbol-name head)))
      (%refuse :perform :not-a-known-surface-construct :occurrence-tag tag
               :detail "the head names no entry in the closed construct table"))
    (let* ((entry (%lookup-construct (package-name pkg) (symbol-name head)))
           (target-pkg (find-package (first entry)))
           (sym (and target-pkg (find-symbol (second entry) target-pkg))))
      (unless (and sym (macro-function sym))
        (%refuse :perform :construct-not-a-macro :occurrence-tag tag
                 :detail (format nil "~A has no macro function in this image"
                                 (second entry))))
      sym)))

(defun perform-expansion (request)
  "DOOR 2.  Perform the requested host macroexpansion and account for it.

Returns (values RECEIPT EXPANDED-HOST-FORM OCCURRENCE).

ERRATA 0.1 — THE THIRD VALUE IS NOW AN OCCURRENCE OBJECT, not a bare identity.
Its identity remains reachable through EXPANSION-OCCURRENCE-IDENTITY.

THIS LAYER CATCHES NOTHING FROM THE MACRO FUNCTION.  If the construct's own
grammar refuses the form, ITS condition escapes to the caller unwrapped, and
NOTHING is minted here — no occurrence, no receipt, not even a refusal object.
That refusal belongs to the layer that owns the grammar, and converting it would
make its verdict a fact this layer reported."
  (unless (expansion-request-p request)
    (error "PERFORM-EXPANSION requires an expansion request object."))
  (let* ((tag (expansion-request-occurrence-tag request))
         ;; A FRESH private form, every time.  No caller-owned object is read.
         (form (%reconstruct-source request tag)))
    (%resolve-macro form tag)
    ;; The expansion itself.  The NULL lexical environment is supplied
    ;; explicitly so that what the context field records is what actually
    ;; happened, rather than whatever the host would have defaulted to.
    (let* ((expanded (ecase (expansion-request-operation request)
                       (:macroexpand-1 (macroexpand-1 form nil))
                       (:macroexpand   (macroexpand form nil))))
           (expanded-datum (%encode-checked expanded :perform tag
                                            :expanded-depth-exceeded
                                            :expanded-nodes-exceeded
                                            :expanded-term-unrepresentable
                                            :expanded-term-octets-exceeded
                                            :expanded-term-shared-structure))
           (expanded-id (%identity expanded-datum))
           (disposition (%operation-disposition (expansion-request-operation request)))
           ;; THE EXPANDED-FORM IDENTITY IS COMMITTED, NEVER OMITTED.  Unlike a
           ;; declared substitution, an expansion is not derivable from the
           ;; request: the construct computed it.  There is no derivability
           ;; theorem here and there cannot be one.
           (occurrence-id
             (%identity (%seq (list (%text ":occurrence")
                                    (expansion-request-identity request)
                                    expanded-id
                                    (%id '("DISPOSITION") (list (string disposition)))))))
           (occurrence
             (%make-occurrence :identity occurrence-id
                               :request-identity (expansion-request-identity request)
                               :expanded-form-datum expanded-datum
                               :expanded-form-identity expanded-id
                               :disposition disposition
                               :occurrence-tag tag)))
      (values (%mint-receipt request occurrence tag) expanded occurrence))))

(defun try-perform-expansion (request)
  "The non-signalling twin.  THREE VALUES ON BOTH BRANCHES, so a caller
destructuring the result cannot read a refusal as a success:
  success -> (values RECEIPT EXPANDED-FORM NIL)
  refusal -> (values NIL      NIL           REFUSAL)"
  (handler-case
      (multiple-value-bind (receipt expanded occurrence) (perform-expansion request)
        (declare (ignore occurrence))
        (values receipt expanded nil))
    (expansion-refused (c) (values nil nil (expansion-condition-refusal c)))))
