;;;; form0.lisp — Language Form /0, Candidate /0.
;;;;
;;;; Run: (load "form0.lisp")  — it loads Canonical Datum /0 and nothing else.
;;;;
;;;; READ package.lisp FIRST.  The primary law and the boundary live there.
;;;;
;;;; ONE HABIT WORTH NAMING BEFORE THE CODE.  A hole is a DATA position, never a
;;;; code position.  Filling hole X with a value splices that value in wrapped as
;;;; a literal, so a bound value that happens to look like a program is inert by
;;;; construction rather than by a scanning discipline someone has to remember.
;;;; The single-substitution rule is therefore structural: literal nodes are
;;;; leaves, and the descent never enters one.

;;; ── BOOTSTRAP ─────────────────────────────────────────────────────────────
;;; The only file-system access in this layer, to a fixed relative path, reached
;;; once at load time and never from any operation below.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (unless (find-package :lisp-plus-cd0)
    (handler-bind ((style-warning #'muffle-warning))
      (load (merge-pathnames "../../canonical-datum/common-lisp/package.lisp"
                             *load-truename*))
      (load (merge-pathnames "../../canonical-datum/common-lisp/cd0.lisp"
                             *load-truename*))))
  (unless (find-package :lisp-plus-form0)
    (handler-bind ((style-warning #'muffle-warning))
      (load (merge-pathnames "package.lisp" *load-truename*)))))

(in-package #:lisp-plus-form0)

;;; ==== BOOTSTRAP ENDS HERE ====
;;; Everything below this marker is scanned by T-NO-HOST-ESCAPE, which requires
;;; that no host escape hatch appears in the operative layer.

;;; ------------------------------------------------------------------
;;; Segmented identifiers.  Every durable name in this layer is a CD/0
;;; identifier datum.  No host symbol is ever a durable operator or hole name,
;;; and nothing here interns, looks up, or resolves a host symbol by name.

(defun %id (namespace path)
  (lisp-plus-cd0:make-identifier-datum namespace path))

(defun grammar-identity ()
  "The identity of the Form /0 closed grammar."
  (%id '("lisp-plus-form0" "grammar") '("core" "0")))

(defun grammar-version () 1)

(defun %lit-head () (%id '("lisp-plus-form0" "grammar") '("lit")))
(defun %hole-head () (%id '("lisp-plus-form0" "grammar") '("hole")))

(defun hole-identifier (name)
  "The durable identifier of a declared hole named NAME (a string)."
  (%id '("lisp-plus-form0" "hole") (list name)))

(defun operator-identifier (name)
  "The durable identifier of an operator named NAME (a string)."
  (%id '("lisp-plus-form0" "op") (list name)))

(defun %same (left right)
  (lisp-plus-cd0:equal-datum left right))

;;; ------------------------------------------------------------------
;;; Content-derived identity and independent snapshots.
;;;
;;; A snapshot is a full canonical round trip, so the stored tree shares no
;;; structure whatever with anything the caller retains.  CD/0 datums are already
;;; immutable; the round trip makes that independence demonstrable rather than
;;; merely documented.

(defun %hex (datum)
  (lisp-plus-cd0:octets-to-hex (lisp-plus-cd0:canonical-octets datum)))

(defun %snapshot (datum)
  (lisp-plus-cd0:decode-exact (lisp-plus-cd0:canonical-octets datum)))

(defun %budget-policy ()
  (lisp-plus-cd0:budget-id (lisp-plus-cd0:default-resource-budget)))

;;; ------------------------------------------------------------------
;;; THE DUAL IDENTITY MODEL.
;;;
;;; Two different questions need two different answers, and conflating them is
;;; how a durable receipt ends up saying "this syntax was realized" without
;;; being able to say WHICH validation authorized it.
;;;
;;;   SUBJECT-FORM IDENTITY  — the identity of the canonical syntax being
;;;   carried through the pipeline.  Deliberately STABLE: the same syntax has
;;;   the same subject identity in every phase and under every environment.
;;;
;;;   PHASE-OBJECT IDENTITY  — the identity of THIS proposal, THIS
;;;   instantiation, THIS validation or THIS realization record, under its
;;;   exact phase context.  Deliberately DISTINCT: it commits to a phase tag
;;;   and to every phase-consequential input, so no two phases of one syntax
;;;   share an identity and no validation is portable to another context.
;;;
;;; Object non-EQ is not evidence of either.  These are content-derived.

(defun %phase-tag (name)
  (%id '("lisp-plus-form0" "phase") (list name)))

(defun %text (string) (lisp-plus-cd0:make-string-datum string))
(defun %count (integer) (lisp-plus-cd0:make-integer-datum integer))
(defun %group (data) (lisp-plus-cd0:make-sequence-datum data))

(defun %phase-identity (phase-name components)
  "Content-derived identity in the durable domain named by PHASE-NAME."
  (%hex (%group (cons (%phase-tag phase-name) components))))

;;; ------------------------------------------------------------------
;;; Retained refusals.
;;;
;;; A refusal is an object with an identity, not a printed condition.  Every
;;; operation has a signalling name and a TRY- twin; the twin returns the very
;;; same object the condition carries, so a refusal can be filed, counted,
;;; compared and re-read long after the call that produced it.

(defparameter +form-refusal-codes+
  '(;; boundary
    :not-a-datum :environment-not-sealed :environment-unusable
    ;; grammar
    :unknown-production :malformed-node :empty-node :head-not-identifier
    :literal-arity :hole-arity :hole-name-not-identifier
    ;; holes
    :undeclared-hole :unfilled-hole :extra-binding :duplicate-binding
    :wrong-species :binding-not-a-datum :hole-survived-instantiation
    ;; environment / validation
    :unknown-operator :operator-arity :duplicate-operator :duplicate-hole
    :operator-not-built-in
    ;; realization
    :not-validated :grammar-identity-drift :grammar-version-drift
    :environment-identity-drift :environment-version-drift
    :environment-content-drift :budget-policy-drift :operator-identity-drift)
  "The stable refusal codes.  A reader may branch on these; they are not prose.")

(defun form-refusal-codes () (copy-list +form-refusal-codes+))

(defstruct (form-refusal (:constructor %make-form-refusal) (:copier nil)
                         (:conc-name %form-refusal-))
  (category nil :read-only t)
  (code nil :read-only t)
  (path nil :read-only t)
  (offending nil :read-only t)
  (detail "" :read-only t)
  (identity "" :read-only t))

(defun form-refusal-category (refusal) (%form-refusal-category refusal))
(defun form-refusal-code (refusal) (%form-refusal-code refusal))
(defun form-refusal-path (refusal) (copy-list (%form-refusal-path refusal)))
(defun form-refusal-offending (refusal) (%form-refusal-offending refusal))
(defun form-refusal-detail (refusal) (copy-seq (%form-refusal-detail refusal)))
(defun form-refusal-identity (refusal) (copy-seq (%form-refusal-identity refusal)))

(define-condition form-refused (error)
  ((refusal :initarg :refusal :reader form-refused-refusal))
  (:report (lambda (condition stream)
             (let ((refusal (form-refused-refusal condition)))
               (format stream "form refused (~S/~S)~@[ at path ~S~]: ~A"
                       (form-refusal-category refusal)
                       (form-refusal-code refusal)
                       (form-refusal-path refusal)
                       (form-refusal-detail refusal))))))

(defun %refusal-identity (category code detail)
  (%hex (lisp-plus-cd0:make-sequence-datum
         (list (lisp-plus-cd0:make-string-datum (string category))
               (lisp-plus-cd0:make-string-datum (string code))
               (lisp-plus-cd0:make-string-datum detail)))))

(defun %refuse (category code path offending control &rest arguments)
  (let* ((detail (apply #'format nil control arguments))
         (refusal (%make-form-refusal
                   :category category
                   :code code
                   :path (copy-list path)
                   :offending (when (lisp-plus-cd0:datum-p offending)
                                (%snapshot offending))
                   :detail detail
                   :identity (%refusal-identity category code detail))))
    (error 'form-refused :refusal refusal)))

;;; ------------------------------------------------------------------
;;; Species.  A declared hole names the CD/0 family it will accept.

(defun %species-match-p (species datum)
  (ecase species
    (:any (lisp-plus-cd0:datum-p datum))
    (:unit (lisp-plus-cd0:unit-datum-p datum))
    (:boolean (lisp-plus-cd0:boolean-datum-p datum))
    (:integer (lisp-plus-cd0:integer-datum-p datum))
    (:rational (lisp-plus-cd0:rational-datum-p datum))
    (:string (lisp-plus-cd0:string-datum-p datum))
    (:bytes (lisp-plus-cd0:bytes-datum-p datum))
    (:identifier (lisp-plus-cd0:identifier-datum-p datum))
    (:sequence (lisp-plus-cd0:sequence-datum-p datum))
    (:record (lisp-plus-cd0:record-datum-p datum))))

;;; ------------------------------------------------------------------
;;; Declared holes and installed operator descriptors.

(defstruct (form-hole (:constructor %make-form-hole) (:copier nil)
                      (:conc-name %form-hole-))
  (identity nil :read-only t)
  (expected-species :any :read-only t))

(defun form-hole-identity (hole) (%form-hole-identity hole))
(defun form-hole-expected-species (hole) (%form-hole-expected-species hole))

(defun make-form-hole (name expected-species)
  "Declare a hole named NAME (a string) accepting EXPECTED-SPECIES."
  (unless (and (stringp name) (plusp (length name)))
    (%refuse :environment :environment-unusable nil nil
             "a hole name must be a non-empty string, got ~S" name))
  (unless (member expected-species
                  '(:any :unit :boolean :integer :rational :string
                    :bytes :identifier :sequence :record))
    (%refuse :environment :environment-unusable nil nil
             "unknown expected species ~S" expected-species))
  (%make-form-hole :identity (hole-identifier name)
                   :expected-species expected-species))

(defstruct (operator-descriptor (:constructor %make-operator-descriptor)
                                (:copier nil)
                                (:conc-name %operator-descriptor-))
  (identity nil :read-only t)
  (arity 0 :read-only t)
  (result-species :any :read-only t)
  (handler nil :read-only t))

(defun operator-descriptor-identity (descriptor)
  (%operator-descriptor-identity descriptor))
(defun operator-descriptor-arity (descriptor)
  (%operator-descriptor-arity descriptor))
(defun operator-descriptor-result-species (descriptor)
  (%operator-descriptor-result-species descriptor))

;;; ------------------------------------------------------------------
;;; THE PACKAGE-OWNED OPERATOR SET.  (Owner ruling, chair review 1, option C.)
;;;
;;; There is NO public way to associate caller-supplied behaviour with an
;;; operator identifier.  The four operators are defined here, in this file, as
;;; ordinary package-internal functions, and the only constructor that can put a
;;; function into a descriptor is internal.
;;;
;;; No mutable registry exists.  `%BUILTIN-HANDLER' is a CLOSED DISPATCHER over
;;; literal names — behaviour lives in code, not in a table that something could
;;; remap — and `%BUILTIN-DESCRIPTOR' constructs a fresh immutable descriptor on
;;; each call, so there is no shared descriptor object to mutate either.
;;;
;;; WHAT THIS IS AND IS NOT.  This is a PUBLIC-API ENFORCEMENT BOUNDARY.  It is
;;; not process isolation and not a sandbox: hostile Common Lisp already running
;;; in this image can reach package internals, redefine these very functions, or
;;; ignore Form /0 entirely and call whatever it likes.  See the threat model in
;;; LANGUAGE-FORM-0-WORK-ORDER.md §0.

(defun %op/equal-datum (arguments)
  (lisp-plus-cd0:make-boolean-datum
   (lisp-plus-cd0:equal-datum (first arguments) (second arguments))))

(defun %op/canonical-hex (arguments)
  (lisp-plus-cd0:make-string-datum
   (lisp-plus-cd0:octets-to-hex
    (lisp-plus-cd0:canonical-octets (first arguments)))))

(defun %op/sequence-length (arguments)
  (lisp-plus-cd0:make-integer-datum
   (lisp-plus-cd0:sequence-datum-length (first arguments))))

(defun %op/render-diagnostic (arguments)
  (lisp-plus-cd0:make-string-datum
   (lisp-plus-cd0:render-diagnostic (first arguments))))

(defun operator-names ()
  "The complete installable operator set of Candidate /0.  There is no public
operation that can extend it."
  (list "equal-datum" "canonical-hex" "sequence-length" "render-diagnostic"))

(defun %builtin-spec (name)
  "A closed dispatcher: arity, result species and handler for a built-in name,
or NIL.  A name outside this set has no handler anywhere in the layer."
  (cond ((string= name "equal-datum")       (list 2 :boolean #'%op/equal-datum))
        ((string= name "canonical-hex")     (list 1 :string #'%op/canonical-hex))
        ((string= name "sequence-length")   (list 1 :integer #'%op/sequence-length))
        ((string= name "render-diagnostic") (list 1 :string #'%op/render-diagnostic))
        (t nil)))

(defun %make-builtin-descriptor (name)
  "INTERNAL.  The only constructor in the layer that puts a function into a
descriptor, and it can only reach package-owned functions."
  (let ((spec (%builtin-spec name)))
    (unless spec
      (%refuse :environment :operator-not-built-in nil (operator-identifier name)
               "~A is not one of the built-in operators ~{~A~^, ~}"
               name (operator-names)))
    (%make-operator-descriptor :identity (operator-identifier name)
                               :arity (first spec)
                               :result-species (second spec)
                               :handler (third spec))))

(defun operator-descriptor (name)
  "Return the immutable package-owned descriptor for a built-in operator, so a
program can read its arity and result species.  The handler it carries has no
public accessor."
  (unless (and (stringp name) (plusp (length name)))
    (%refuse :environment :environment-unusable nil nil
             "an operator name must be a non-empty string, got ~S" name))
  (%make-builtin-descriptor name))

;;; ------------------------------------------------------------------
;;; The sealed, local form environment.
;;;
;;; There is no global registry, no special variable holding one, and no
;;; defparameter table of operators anywhere in this file.  An environment is a
;;; value the program constructs, seals, and passes explicitly.  Resolving a name
;;; in it yields a handler and nothing else: no evidence, no standing, no claim,
;;; no basis, no capability and no authority is produced by resolution.

(defstruct (form-environment (:constructor %make-form-environment) (:copier nil)
                             (:conc-name %form-environment-))
  (identity nil :read-only t)
  (version 0 :read-only t)
  (grammar-identity nil :read-only t)
  (grammar-version 0 :read-only t)
  (operators '() :read-only t)
  (holes '() :read-only t)
  (budget-id nil :read-only t)
  (content-digest "" :read-only t)
  (sealed-p nil :read-only t))

;;; THE CONTENT DIGEST, and exactly what it is worth.
;;;
;;; An environment's IDENTITY is derived from its name, so two environments that
;;; declare themselves the same are the same to any name-comparing gate.  The
;;; content digest commits, in addition, to the whole DECLARED SURFACE: version,
;;; grammar, resource policy, and every operator's identity/arity/result-species
;;; and every hole's identity/species.
;;;
;;; What it closes: a validation cannot be reused under an environment whose
;;; declared surface differs in any respect.
;;;
;;; What it does NOT close, stated plainly rather than left for a reader to
;;; discover: it CANNOT commit to the handler functions themselves, because a
;;; host closure has no canonical content.  Two environments with an identical
;;; declared surface and different handler behaviour produce the same digest.
;;; That residual is exhibited by an executable tooth, not hidden.

(defun %environment-content-digest (identity version grammar-identity
                                    grammar-version operators holes budget-id)
  (%phase-identity
   "environment-content"
   (list identity
         (%count version)
         grammar-identity
         (%count grammar-version)
         (%text budget-id)
         (%group (mapcar (lambda (descriptor)
                           (%group (list (operator-descriptor-identity descriptor)
                                         (%count (operator-descriptor-arity descriptor))
                                         (%text (string (operator-descriptor-result-species
                                                         descriptor))))))
                         operators))
         (%group (mapcar (lambda (hole)
                           (%group (list (form-hole-identity hole)
                                         (%text (string (form-hole-expected-species hole))))))
                         holes)))))

(defun form-environment-identity (environment)
  (%form-environment-identity environment))
(defun form-environment-version (environment)
  (%form-environment-version environment))
(defun form-environment-grammar-identity (environment)
  (%form-environment-grammar-identity environment))
(defun form-environment-grammar-version (environment)
  (%form-environment-grammar-version environment))
(defun form-environment-sealed-p (environment)
  (%form-environment-sealed-p environment))
(defun form-environment-budget-id (environment)
  (%form-environment-budget-id environment))
(defun form-environment-content-digest (environment)
  (copy-seq (%form-environment-content-digest environment)))
(defun form-environment-operator-identities (environment)
  (mapcar #'operator-descriptor-identity
          (%form-environment-operators environment)))
(defun form-environment-hole-identities (environment)
  (mapcar #'form-hole-identity (%form-environment-holes environment)))

(defun make-form-environment (&key name version operators holes)
  "Build an UNSEALED environment.  An unsealed environment cannot admit,
instantiate, validate or realize anything.

OPERATORS is a list of built-in operator NAMES (strings) — a SELECTION from
`OPERATOR-NAMES', never a list of caller-built descriptors.  There is no public
way to supply a handler, so two environments that select the same operators
necessarily have the same behaviour."
  (unless (and (stringp name) (plusp (length name)))
    (%refuse :environment :environment-unusable nil nil
             "an environment name must be a non-empty string, got ~S" name))
  (unless (and (integerp version) (plusp version))
    (%refuse :environment :environment-unusable nil nil
             "an environment version must be a positive integer, got ~S" version))
  (dolist (selection operators)
    (unless (stringp selection)
      (%refuse :environment :environment-unusable nil nil
               "an operator selection must be a built-in operator NAME (a string); got ~S~
~@[ — a descriptor cannot be supplied by a caller~]"
               selection (operator-descriptor-p selection))))
  ;; Resolution happens HERE, against the closed dispatcher.  A name outside the
  ;; built-in set is refused; it cannot be taught.
  (setf operators (mapcar #'%make-builtin-descriptor operators))
  (dolist (hole holes)
    (unless (form-hole-p hole)
      (%refuse :environment :environment-unusable nil nil
               "~S is not a declared hole" hole)))
  (loop for rest on operators
        do (dolist (other (rest rest))
             (when (%same (operator-descriptor-identity (first rest))
                          (operator-descriptor-identity other))
               (%refuse :environment :duplicate-operator nil
                        (operator-descriptor-identity other)
                        "operator ~A is installed twice"
                        (lisp-plus-cd0:render-diagnostic
                         (operator-descriptor-identity other))))))
  (loop for rest on holes
        do (dolist (other (rest rest))
             (when (%same (form-hole-identity (first rest))
                          (form-hole-identity other))
               (%refuse :environment :duplicate-hole nil
                        (form-hole-identity other)
                        "hole ~A is declared twice"
                        (lisp-plus-cd0:render-diagnostic
                         (form-hole-identity other))))))
  (let ((identity (%id '("lisp-plus-form0" "environment") (list name)))
        (budget-id (%budget-policy)))
    (%make-form-environment
     :identity identity
     :version version
     :grammar-identity (grammar-identity)
     :grammar-version (grammar-version)
     :operators (copy-list operators)
     :holes (copy-list holes)
     :budget-id budget-id
     :content-digest (%environment-content-digest
                      identity version (grammar-identity) (grammar-version)
                      operators holes budget-id)
     :sealed-p nil)))

(defun seal-form-environment (environment)
  "Return a NEW sealed environment.  Sealing never mutates its argument."
  (unless (form-environment-p environment)
    (%refuse :environment :environment-unusable nil nil
             "~S is not a form environment" environment))
  (%make-form-environment
   :identity (%form-environment-identity environment)
   :version (%form-environment-version environment)
   :grammar-identity (%form-environment-grammar-identity environment)
   :grammar-version (%form-environment-grammar-version environment)
   :operators (copy-list (%form-environment-operators environment))
   :holes (copy-list (%form-environment-holes environment))
   :budget-id (%form-environment-budget-id environment)
   ;; Recomputed rather than copied: sealing must not be able to carry forward a
   ;; digest that no longer describes the surface it is sealing.
   :content-digest (%environment-content-digest
                    (%form-environment-identity environment)
                    (%form-environment-version environment)
                    (%form-environment-grammar-identity environment)
                    (%form-environment-grammar-version environment)
                    (%form-environment-operators environment)
                    (%form-environment-holes environment)
                    (%form-environment-budget-id environment))
   :sealed-p t))

(defun %require-sealed (environment)
  (unless (form-environment-p environment)
    (%refuse :environment :environment-unusable nil nil
             "~S is not a form environment" environment))
  (unless (%form-environment-sealed-p environment)
    (%refuse :environment :environment-not-sealed nil nil
             "the environment is not sealed; seal it before use"))
  environment)

(defun %find-operator (environment identifier)
  (find identifier (%form-environment-operators environment)
        :key #'operator-descriptor-identity :test #'%same))

(defun %find-hole (environment identifier)
  (find identifier (%form-environment-holes environment)
        :key #'form-hole-identity :test #'%same))

;;; ------------------------------------------------------------------
;;; Grammar constructors, so a program (or a fake adapter) can write a candidate
;;; by hand without hand-assembling identifier data at every node.

(defun literal-node (datum)
  (lisp-plus-cd0:make-sequence-datum (list (%lit-head) datum)))

(defun hole-node (name)
  (lisp-plus-cd0:make-sequence-datum
   (list (%hole-head) (hole-identifier name))))

(defun operator-node (name &rest argument-nodes)
  (lisp-plus-cd0:make-sequence-datum
   (cons (operator-identifier name) argument-nodes)))

;;; ------------------------------------------------------------------
;;; PHASE 1 — PROPOSE.  Grammar admission only.
;;;
;;; This checks the three productions and records which holes and which operator
;;; names the candidate mentions.  It does NOT resolve operators and does NOT
;;; check hole declarations: a candidate is admitted under the GRAMMAR, and it is
;;; validated under the ENVIRONMENT.  Keeping those separate is what makes the
;;; phases four objects instead of one object with a status.

(defstruct (proposed-form (:constructor %make-proposed-form) (:copier nil)
                          (:conc-name %proposed-form-))
  (datum nil :read-only t)
  (subject-identity "" :read-only t)   ; the syntax — stable across phases
  (identity "" :read-only t)           ; THIS proposal — distinct by phase
  (hole-identities '() :read-only t)
  (operator-identities '() :read-only t)
  (grammar-identity nil :read-only t)
  (grammar-version 0 :read-only t))

(defun proposed-form-datum (form) (%proposed-form-datum form))
(defun proposed-form-subject-identity (form)
  (copy-seq (%proposed-form-subject-identity form)))
(defun proposed-form-identity (form) (copy-seq (%proposed-form-identity form)))
(defun proposed-form-hole-identities (form)
  (copy-list (%proposed-form-hole-identities form)))
(defun proposed-form-operator-identities (form)
  (copy-list (%proposed-form-operator-identities form)))
(defun proposed-form-grammar-identity (form)
  (%proposed-form-grammar-identity form))
(defun proposed-form-grammar-version (form)
  (%proposed-form-grammar-version form))

(defun %head-kind (head)
  "Classify a node head into exactly one of the three productions, or NIL."
  (cond ((not (lisp-plus-cd0:identifier-datum-p head)) nil)
        ((%same head (%lit-head)) :literal)
        ((%same head (%hole-head)) :hole)
        ((and (= 2 (lisp-plus-cd0:identifier-datum-namespace-count head))
              (string= "lisp-plus-form0"
                       (lisp-plus-cd0:identifier-datum-namespace-segment head 0))
              (string= "op"
                       (lisp-plus-cd0:identifier-datum-namespace-segment head 1))
              (= 1 (lisp-plus-cd0:identifier-datum-path-count head)))
         :operator)
        (t nil)))

(defun %admit (node path holes operators)
  "Walk NODE against the closed grammar.  Returns (values holes operators),
each in first-appearance order.  Literal payloads are leaves and are never
descended into: a literal is data, whatever it happens to look like."
  (unless (lisp-plus-cd0:sequence-datum-p node)
    (%refuse :grammar :unknown-production path node
             "a form node must be a sequence; found a ~(~A~) datum"
             (lisp-plus-cd0:datum-family node)))
  (let ((size (lisp-plus-cd0:sequence-datum-length node)))
    (when (zerop size)
      (%refuse :grammar :empty-node path node "an empty sequence is not a node"))
    (let* ((head (lisp-plus-cd0:sequence-datum-ref node 0))
           (kind (%head-kind head)))
      (case kind
        (:literal
         (unless (= size 2)
           (%refuse :grammar :literal-arity path node
                    "a literal node takes exactly one payload; found ~D" (1- size))))
        (:hole
         (unless (= size 2)
           (%refuse :grammar :hole-arity path node
                    "a hole node takes exactly one name; found ~D" (1- size)))
         (let ((name (lisp-plus-cd0:sequence-datum-ref node 1)))
           (unless (lisp-plus-cd0:identifier-datum-p name)
             (%refuse :grammar :hole-name-not-identifier (append path '(1)) name
                      "a hole name must be an identifier datum"))
           (unless (find name holes :test #'%same)
             (setf holes (append holes (list (%snapshot name)))))))
        (:operator
         (unless (find head operators :test #'%same)
           (setf operators (append operators (list (%snapshot head)))))
         (loop for index from 1 below size
               do (multiple-value-setq (holes operators)
                    (%admit (lisp-plus-cd0:sequence-datum-ref node index)
                            (append path (list index))
                            holes operators))))
        (t
         (if (lisp-plus-cd0:identifier-datum-p head)
             (%refuse :grammar :unknown-production path head
                      "~A heads no production of the Form /0 grammar"
                      (lisp-plus-cd0:render-diagnostic head))
             (%refuse :grammar :head-not-identifier path head
                      "a node head must be an identifier datum; found a ~(~A~) datum"
                      (lisp-plus-cd0:datum-family head)))))))
  (values holes operators))

(defun propose-form (candidate environment)
  "Admit CANDIDATE, an already-decoded CD/0 datum, as a proposed program.

This is an ADMISSION, not a decoding and not a parse.  Nothing is run, nothing
is resolved, and the result is inert."
  (%require-sealed environment)
  (unless (lisp-plus-cd0:datum-p candidate)
    (%refuse :boundary :not-a-datum nil nil
             "the durable input boundary is a CD/0 datum; received ~S of host type ~A"
             candidate (type-of candidate)))
  (let ((snapshot (%snapshot candidate)))
    (multiple-value-bind (holes operators) (%admit snapshot '() '() '())
      (let ((subject (%hex snapshot)))
        (%make-proposed-form
         :datum snapshot
         :subject-identity subject
         :identity (%phase-identity
                    "proposed"
                    (list (%text subject)
                          (%form-environment-grammar-identity environment)
                          (%count (%form-environment-grammar-version environment))))
         :hole-identities holes
         :operator-identities operators
         :grammar-identity (%form-environment-grammar-identity environment)
         :grammar-version (%form-environment-grammar-version environment))))))

;;; ------------------------------------------------------------------
;;; PHASE 2 — INSTANTIATE.  Explicit holes, explicit bindings, one pass.
;;;
;;; A bound value is spliced in WRAPPED AS A LITERAL.  Two consequences, both
;;; wanted: a value that looks like a program stays data, and the substitution is
;;; provably single-pass because the descent never enters a literal.

(defstruct (instantiated-form (:constructor %make-instantiated-form)
                              (:copier nil) (:conc-name %instantiated-form-))
  (datum nil :read-only t)
  ;; THE TWO SIDES OF THE TEMPLATE → CLOSED-FORM TRANSITION.
  ;;
  ;; Instantiation is the one phase that CHANGES the subject: it consumes a
  ;; hole-bearing template and produces a closed form. So the subject identity is
  ;; NOT stable across every phase, and this object must record both sides or the
  ;; genealogy loses the step where the syntax actually moved.
  (template-subject-identity "" :read-only t) ; what the proposal carried
  (subject-identity "" :read-only t)          ; the closed form produced here
  (identity "" :read-only t)                  ; THIS instantiation
  (predecessor-identity "" :read-only t)      ; the proposal's PHASE identity
  (binding-identity "" :read-only t)          ; the exact binding environment used
  (binding-identities '() :read-only t))

(defun instantiated-form-datum (form) (%instantiated-form-datum form))
(defun instantiated-form-template-subject-identity (form)
  (copy-seq (%instantiated-form-template-subject-identity form)))
(defun instantiated-form-subject-identity (form)
  (copy-seq (%instantiated-form-subject-identity form)))
(defun instantiated-form-identity (form)
  (copy-seq (%instantiated-form-identity form)))
(defun instantiated-form-predecessor-identity (form)
  (copy-seq (%instantiated-form-predecessor-identity form)))
(defun instantiated-form-binding-identity (form)
  (copy-seq (%instantiated-form-binding-identity form)))
(defun instantiated-form-binding-identities (form)
  (copy-list (%instantiated-form-binding-identities form)))

(defun %binding-environment-identity (pairs)
  "The identity of the exact bindings used, in the order they were supplied."
  (%phase-identity
   "binding-environment"
   (list (%group (mapcar (lambda (pair) (%group (list (car pair) (cdr pair))))
                         pairs)))))

(defun %substitute (node bindings)
  "Descend NODE once.  Literal payloads are leaves."
  (let* ((head (lisp-plus-cd0:sequence-datum-ref node 0))
         (kind (%head-kind head)))
    (case kind
      (:literal node)
      (:hole
       (let* ((name (lisp-plus-cd0:sequence-datum-ref node 1))
              (pair (assoc name bindings :test #'%same)))
         (literal-node (cdr pair))))
      (t
       (lisp-plus-cd0:make-sequence-datum
        (cons head
              (loop for index from 1
                      below (lisp-plus-cd0:sequence-datum-length node)
                    collect (%substitute
                             (lisp-plus-cd0:sequence-datum-ref node index)
                             bindings))))))))

(defun instantiate-form (form bindings environment)
  "Fill every declared hole of FORM from BINDINGS, an explicit list of
(HOLE-NAME-STRING . DATUM) pairs.  Nothing is taken from the surrounding lexical
context: there is no ambient environment to capture, because the substrate is
data and the only source of a value is this argument."
  (%require-sealed environment)
  (unless (proposed-form-p form)
    (%refuse :holes :unfilled-hole nil nil
             "~S is not a proposed form" form))
  (let ((pairs '()))
    ;; Each supplied binding must name a declared hole, exactly once, with a
    ;; value of the declared species.
    (dolist (binding bindings)
      (let* ((name (car binding))
             (value (cdr binding))
             (identifier (hole-identifier name))
             (hole (%find-hole environment identifier)))
        (unless hole
          (%refuse :holes :undeclared-hole nil identifier
                   "binding ~S names a hole the environment does not declare" name))
        (unless (find identifier (%proposed-form-hole-identities form)
                      :test #'%same)
          (%refuse :holes :extra-binding nil identifier
                   "binding ~S names a hole the form does not mention" name))
        (when (assoc identifier pairs :test #'%same)
          (%refuse :holes :duplicate-binding nil identifier
                   "hole ~S is bound more than once" name))
        (unless (lisp-plus-cd0:datum-p value)
          (%refuse :holes :binding-not-a-datum nil nil
                   "hole ~S was bound to ~S, which is not a CD/0 datum" name value))
        (unless (%species-match-p (form-hole-expected-species hole) value)
          (%refuse :holes :wrong-species nil value
                   "hole ~S expects ~S; received a ~(~A~) datum"
                   name (form-hole-expected-species hole)
                   (lisp-plus-cd0:datum-family value)))
        (setf pairs (append pairs (list (cons identifier (%snapshot value)))))))
    ;; Every hole the form mentions must be declared, and must be filled.
    (dolist (identifier (%proposed-form-hole-identities form))
      (unless (%find-hole environment identifier)
        (%refuse :holes :undeclared-hole nil identifier
                 "the form mentions ~A, which the environment does not declare"
                 (lisp-plus-cd0:render-diagnostic identifier)))
      (unless (assoc identifier pairs :test #'%same)
        (%refuse :holes :unfilled-hole nil identifier
                 "the form mentions ~A and no binding supplies it"
                 (lisp-plus-cd0:render-diagnostic identifier))))
    (let* ((filled (%snapshot (%substitute (%proposed-form-datum form) pairs)))
           (subject (%hex filled))
           (binding-identity (%binding-environment-identity pairs)))
      (%make-instantiated-form
       :datum filled
       :template-subject-identity (%proposed-form-subject-identity form)
       :subject-identity subject
       ;; Commits to BOTH sides of the transition, so the phase identity moves if
       ;; either the template or the produced closed form differs.
       :identity (%phase-identity
                  "instantiated"
                  (list (%text (%proposed-form-identity form))
                        (%text (%proposed-form-subject-identity form))
                        (%text binding-identity)
                        (%text subject)))
       :predecessor-identity (%proposed-form-identity form)
       :binding-identity binding-identity
       :binding-identities (mapcar #'car pairs)))))

;;; ------------------------------------------------------------------
;;; PHASE 3 — VALIDATE.  Bind the exact executable meaning.
;;;
;;; Validation resolves every operator to the descriptor actually installed and
;;; records THAT descriptor's identity — not the name as written.  It binds the
;;; instantiated-form identity, the grammar identity and version, the environment
;;; identity and version, and the resource policy.

(defstruct (form-validation-receipt (:constructor %make-form-validation-receipt)
                                    (:copier nil)
                                    (:conc-name %form-validation-receipt-))
  (identity "" :read-only t)
  (subject-identity "" :read-only t)
  (instantiated-identity "" :read-only t)   ; the instantiation's PHASE identity
  (grammar-identity nil :read-only t)
  (grammar-version 0 :read-only t)
  (environment-identity nil :read-only t)
  (environment-version 0 :read-only t)
  (environment-content-digest "" :read-only t)
  (operator-identities '() :read-only t)
  (budget-id nil :read-only t))

(defun form-validation-receipt-identity (receipt)
  (copy-seq (%form-validation-receipt-identity receipt)))
(defun form-validation-receipt-subject-identity (receipt)
  (copy-seq (%form-validation-receipt-subject-identity receipt)))
(defun form-validation-receipt-environment-content-digest (receipt)
  (copy-seq (%form-validation-receipt-environment-content-digest receipt)))
(defun form-validation-receipt-instantiated-identity (receipt)
  (copy-seq (%form-validation-receipt-instantiated-identity receipt)))
(defun form-validation-receipt-grammar-identity (receipt)
  (%form-validation-receipt-grammar-identity receipt))
(defun form-validation-receipt-grammar-version (receipt)
  (%form-validation-receipt-grammar-version receipt))
(defun form-validation-receipt-environment-identity (receipt)
  (%form-validation-receipt-environment-identity receipt))
(defun form-validation-receipt-environment-version (receipt)
  (%form-validation-receipt-environment-version receipt))
(defun form-validation-receipt-operator-identities (receipt)
  (copy-list (%form-validation-receipt-operator-identities receipt)))
(defun form-validation-receipt-budget-id (receipt)
  (%form-validation-receipt-budget-id receipt))

(defstruct (validated-form (:constructor %make-validated-form) (:copier nil)
                           (:conc-name %validated-form-))
  (datum nil :read-only t)
  (subject-identity "" :read-only t)
  (identity "" :read-only t)              ; THIS validation
  (predecessor-identity "" :read-only t)  ; the instantiation's PHASE identity
  (receipt nil :read-only t))

(defun validated-form-receipt (form) (%validated-form-receipt form))
(defun validated-form-identity (form) (copy-seq (%validated-form-identity form)))
(defun validated-form-subject-identity (form)
  (copy-seq (%validated-form-subject-identity form)))
(defun validated-form-predecessor-identity (form)
  (copy-seq (%validated-form-predecessor-identity form)))
(defun validated-form-environment-content-digest (form)
  (form-validation-receipt-environment-content-digest (%validated-form-receipt form)))
(defun validated-form-instantiated-identity (form)
  (form-validation-receipt-instantiated-identity (%validated-form-receipt form)))
(defun validated-form-grammar-identity (form)
  (form-validation-receipt-grammar-identity (%validated-form-receipt form)))
(defun validated-form-grammar-version (form)
  (form-validation-receipt-grammar-version (%validated-form-receipt form)))
(defun validated-form-environment-identity (form)
  (form-validation-receipt-environment-identity (%validated-form-receipt form)))
(defun validated-form-environment-version (form)
  (form-validation-receipt-environment-version (%validated-form-receipt form)))
(defun validated-form-operator-identities (form)
  (form-validation-receipt-operator-identities (%validated-form-receipt form)))
(defun validated-form-budget-id (form)
  (form-validation-receipt-budget-id (%validated-form-receipt form)))

(defun %resolve-operators (node path environment resolved)
  "Collect the identity of the DESCRIPTOR resolved at each operator position, in
descent order.  Literal payloads are leaves."
  (let* ((head (lisp-plus-cd0:sequence-datum-ref node 0))
         (kind (%head-kind head))
         (size (lisp-plus-cd0:sequence-datum-length node)))
    (case kind
      (:literal resolved)
      (:hole
       (%refuse :holes :hole-survived-instantiation path node
                "an unfilled hole reached validation"))
      (t
       (let ((descriptor (%find-operator environment head)))
         (unless descriptor
           (%refuse :validation :unknown-operator path head
                    "~A is not installed in this environment"
                    (lisp-plus-cd0:render-diagnostic head)))
         (unless (= (operator-descriptor-arity descriptor) (1- size))
           (%refuse :validation :operator-arity path node
                    "~A takes ~D argument~:P; the form supplies ~D"
                    (lisp-plus-cd0:render-diagnostic head)
                    (operator-descriptor-arity descriptor) (1- size)))
         (setf resolved
               (append resolved
                       (list (%snapshot
                              (operator-descriptor-identity descriptor)))))
         (loop for index from 1 below size
               do (setf resolved
                        (%resolve-operators
                         (lisp-plus-cd0:sequence-datum-ref node index)
                         (append path (list index))
                         environment resolved)))
         resolved)))))

(defun validate-form (form environment)
  "Bind FORM's exact executable meaning under ENVIRONMENT."
  (%require-sealed environment)
  (unless (instantiated-form-p form)
    (%refuse :validation :not-validated nil nil
             "~S is not an instantiated form" form))
  (let* ((resolved (%resolve-operators (%instantiated-form-datum form)
                                       '() environment '()))
         ;; Every phase-consequential input, in one commitment.  Changing any of
         ;; them changes the validated phase identity.
         (components
           (list (%text (%instantiated-form-identity form))
                 (%form-environment-grammar-identity environment)
                 (%count (%form-environment-grammar-version environment))
                 (%form-environment-identity environment)
                 (%count (%form-environment-version environment))
                 (%text (%form-environment-content-digest environment))
                 (%group resolved)
                 (%text (%form-environment-budget-id environment))
                 (%text (%instantiated-form-subject-identity form))))
         (receipt
           (%make-form-validation-receipt
            ;; A distinct phase tag: the RECORD of a validation is not the same
            ;; object as the validated form, and must not share its identity.
            :identity (%phase-identity "validation-receipt" components)
            :subject-identity (%instantiated-form-subject-identity form)
            :instantiated-identity (%instantiated-form-identity form)
            :grammar-identity (%form-environment-grammar-identity environment)
            :grammar-version (%form-environment-grammar-version environment)
            :environment-identity (%form-environment-identity environment)
            :environment-version (%form-environment-version environment)
            :environment-content-digest (%form-environment-content-digest environment)
            :operator-identities resolved
            :budget-id (%form-environment-budget-id environment))))
    (%make-validated-form
     :datum (%instantiated-form-datum form)
     :subject-identity (%instantiated-form-subject-identity form)
     :identity (%phase-identity "validated" components)
     :predecessor-identity (%instantiated-form-identity form)
     :receipt receipt)))

;;; ------------------------------------------------------------------
;;; PHASE 4 — REALIZE.  The one loud boundary.
;;;
;;; This is the only operation in the layer that produces a result rather than
;;; another inert object.  It re-checks all five bound components before doing
;;; anything, and it reaches the underlying operations ONLY through descriptors
;;; the program installed.  A candidate form supplies names; the environment
;;; supplies handlers; the two meet only here.

(defstruct (form-realization-receipt
            (:constructor %make-form-realization-receipt) (:copier nil)
            (:conc-name %form-realization-receipt-))
  (identity "" :read-only t)
  (validated-identity "" :read-only t)      ; the validation's PHASE identity
  (subject-identity "" :read-only t)        ; the exact syntax realized
  (instantiated-identity "" :read-only t)   ; the instantiation's PHASE identity
  (environment-identity nil :read-only t)
  (environment-version 0 :read-only t)
  (environment-content-digest "" :read-only t)
  (grammar-identity nil :read-only t)
  (grammar-version 0 :read-only t)
  (operator-identities '() :read-only t)
  (result-identity "" :read-only t))

(defun form-realization-receipt-identity (receipt)
  (copy-seq (%form-realization-receipt-identity receipt)))
(defun form-realization-receipt-subject-identity (receipt)
  (copy-seq (%form-realization-receipt-subject-identity receipt)))
(defun form-realization-receipt-environment-content-digest (receipt)
  (copy-seq (%form-realization-receipt-environment-content-digest receipt)))
(defun form-realization-receipt-validated-identity (receipt)
  (copy-seq (%form-realization-receipt-validated-identity receipt)))
(defun form-realization-receipt-instantiated-identity (receipt)
  (copy-seq (%form-realization-receipt-instantiated-identity receipt)))
(defun form-realization-receipt-environment-identity (receipt)
  (%form-realization-receipt-environment-identity receipt))
(defun form-realization-receipt-environment-version (receipt)
  (%form-realization-receipt-environment-version receipt))
(defun form-realization-receipt-grammar-identity (receipt)
  (%form-realization-receipt-grammar-identity receipt))
(defun form-realization-receipt-grammar-version (receipt)
  (%form-realization-receipt-grammar-version receipt))
(defun form-realization-receipt-operator-identities (receipt)
  (copy-list (%form-realization-receipt-operator-identities receipt)))
(defun form-realization-receipt-result-identity (receipt)
  (copy-seq (%form-realization-receipt-result-identity receipt)))

(defun %reduce-node (node environment)
  "Reduce one validated node to a datum.  A literal yields its payload; an
operator node yields its installed handler's result over reduced arguments."
  (let* ((head (lisp-plus-cd0:sequence-datum-ref node 0))
         (kind (%head-kind head))
         (size (lisp-plus-cd0:sequence-datum-length node)))
    (if (eq kind :literal)
        (lisp-plus-cd0:sequence-datum-ref node 1)
        (let ((descriptor (%find-operator environment head))
              (arguments '()))
          (loop for index from 1 below size
                do (setf arguments
                         (append arguments
                                 (list (%reduce-node
                                        (lisp-plus-cd0:sequence-datum-ref
                                         node index)
                                        environment)))))
          ;; The single dispatch site of this layer.  The handler came from the
          ;; program at environment-construction time; it never came from NODE.
          (funcall (%operator-descriptor-handler descriptor) arguments)))))

(defun realize-form (form environment)
  "The realization boundary.  Returns (values RESULT-DATUM RECEIPT).

Refuses unless every component bound at validation is still exactly what it was:
the grammar identity and version, the environment identity and version, the
resource policy, and the resolved operator descriptor identities."
  (%require-sealed environment)
  (unless (validated-form-p form)
    (%refuse :realization :not-validated nil nil
             "~S is not a validated form; only a validated form may be realized"
             form))
  (let ((receipt (%validated-form-receipt form)))
    (unless (%same (form-validation-receipt-grammar-identity receipt)
                   (%form-environment-grammar-identity environment))
      (%refuse :realization :grammar-identity-drift nil nil
               "the form was validated under a different grammar"))
    (unless (= (form-validation-receipt-grammar-version receipt)
               (%form-environment-grammar-version environment))
      (%refuse :realization :grammar-version-drift nil nil
               "the form was validated under grammar version ~D; this environment declares ~D"
               (form-validation-receipt-grammar-version receipt)
               (%form-environment-grammar-version environment)))
    (unless (%same (form-validation-receipt-environment-identity receipt)
                   (%form-environment-identity environment))
      (%refuse :realization :environment-identity-drift nil
               (%form-environment-identity environment)
               "the form was validated under environment ~A, not ~A"
               (lisp-plus-cd0:render-diagnostic
                (form-validation-receipt-environment-identity receipt))
               (lisp-plus-cd0:render-diagnostic
                (%form-environment-identity environment))))
    (unless (= (form-validation-receipt-environment-version receipt)
               (%form-environment-version environment))
      (%refuse :realization :environment-version-drift nil nil
               "the form was validated under environment version ~D; this environment declares ~D"
               (form-validation-receipt-environment-version receipt)
               (%form-environment-version environment)))
    (unless (equal (form-validation-receipt-budget-id receipt)
                   (%form-environment-budget-id environment))
      (%refuse :realization :budget-policy-drift nil nil
               "the resource policy changed after validation"))
    ;; The DECLARED SURFACE, not merely the name.  An environment that agrees
    ;; about its identity and version but declares a different operator set,
    ;; arity, result species, hole set or hole species is a different
    ;; environment, and a validation does not travel to it.
    (unless (equal (form-validation-receipt-environment-content-digest receipt)
                   (%form-environment-content-digest environment))
      (%refuse :realization :environment-content-drift nil nil
               "the environment's declared surface changed after validation"))
    ;; The identities are re-resolved against THIS environment and must match the
    ;; descriptors bound at validation, position for position.
    (let ((current (%resolve-operators (%validated-form-datum form) '()
                                       environment '()))
          (bound (form-validation-receipt-operator-identities receipt)))
      (unless (and (= (length current) (length bound))
                   (every #'%same current bound))
        (%refuse :realization :operator-identity-drift nil nil
                 "the operators resolved now are not the operators bound at validation")))
    (let* ((result (%reduce-node (%validated-form-datum form) environment))
           (result-identity (%hex result)))
      (values
       result
       (%make-form-realization-receipt
        ;; Binds BOTH: which validation authorized this, and which exact syntax
        ;; was realized.  A receipt that named only the syntax could not say
        ;; which validation event licensed it.
        :identity (%phase-identity
                   "realization-receipt"
                   (list (%text (%validated-form-identity form))
                         (%text (%validated-form-subject-identity form))
                         (%group (form-validation-receipt-operator-identities receipt))
                         (%text result-identity)))
        :validated-identity (%validated-form-identity form)
        :subject-identity (%validated-form-subject-identity form)
        :instantiated-identity
        (form-validation-receipt-instantiated-identity receipt)
        :environment-identity (%form-environment-identity environment)
        :environment-version (%form-environment-version environment)
        :environment-content-digest (%form-environment-content-digest environment)
        :grammar-identity (%form-environment-grammar-identity environment)
        :grammar-version (%form-environment-grammar-version environment)
        :operator-identities
        (form-validation-receipt-operator-identities receipt)
        :result-identity result-identity)))))

;;; ------------------------------------------------------------------
;;; The non-signalling twins.  Each returns (values RESULT NIL) or (values NIL
;;; REFUSAL), so a refusal becomes a retained object in the caller's hands
;;; without a handler ceremony at every call site.

(defmacro %try (&body body)
  `(handler-case (values (progn ,@body) nil)
     (form-refused (condition) (values nil (form-refused-refusal condition)))))

(defun try-propose-form (candidate environment)
  (%try (propose-form candidate environment)))

(defun try-instantiate-form (form bindings environment)
  (%try (instantiate-form form bindings environment)))

(defun try-validate-form (form environment)
  (%try (validate-form form environment)))

(defun try-realize-form (form environment)
  (handler-case
      (multiple-value-bind (result receipt) (realize-form form environment)
        (values result receipt nil))
    (form-refused (condition)
      (values nil nil (form-refused-refusal condition)))))
