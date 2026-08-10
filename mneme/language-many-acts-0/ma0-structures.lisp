;;;; ma0-structures.lisp — the lane's typed conditions, declared constants, and
;;;; the four immutable structures.
;;;;
;;;; CANDIDATE.  Nothing here is adopted, and nothing here is independent
;;;; verification (contract §0).
;;;;
;;;; EVERY SLOT IS READ-ONLY AND EVERY LIST-VALUED READER COPIES.  A read-only
;;;; slot stops `setf`; it does not stop a caller mutating the LIST the slot
;;;; holds.  Structure sharing is the hole in "immutable", so each list-valued
;;;; reader hands out a fresh copy and the original is never reachable
;;;; (W-IMMUTABLE).
;;;;
;;;; ⚠ R1/D1 — `copy-tree' WAS THE HOLE IN THE HOLE.  It copies cons structure
;;;; and SHARES every leaf, so a "defensive copy" handed a caller the very
;;;; STRINGS the validated program, the environment and the result retained.
;;;; Mutating an arm name inside a returned source copy changed the already-
;;;; validated executable program; mutating a returned store-id changed the
;;;; environment's own identifier.  Ownership is now taken by `%ma0-own' (§2c),
;;;; which copies the mutable leaves as well as the spine, at EVERY public
;;;; boundary in BOTH directions.  Witness: r1/D1-ownership.lisp; the red
;;;; transcript that made the case is r1/pre-repair/D1-red.txt.
;;;;
;;;; — FABER (Claude Opus 5, subagent), 2026-08-09
;;;; — R1 repairs: SUTOR (Claude Opus 5, subagent), 2026-08-10

(in-package #:lisp-plus-many-acts0)

;;; ===========================================================================
;;; §1 — the lane's typed conditions.
;;;
;;; Named by CONDITION TYPE + CODE, never by message text: SBCL's condition
;;; report text is not a stable interface (the discipline One Act /0 states at
;;; act0.lisp:43-50, adopted here).
;;; ===========================================================================

(define-condition ma0-refusal (error)
  ((code :initarg :code :initform nil :reader ma0-refusal-code)
   (detail :initarg :detail :initform "" :reader ma0-refusal-detail))
  (:report (lambda (c s)
             (format s "~a [~a]: ~a" (type-of c)
                     (or (ma0-refusal-code c) "-")
                     (ma0-refusal-detail c)))))

(macrolet ((families (base &rest names)
             `(progn ,@(loop for n in names
                             collect `(define-condition ,n (,base) ())))))
  (families ma0-refusal
            ma0-source-refused          ; V-SHAPE V-ATOMS V-READ V-DATA V-PKG
                                        ; V-ARM V-TERM V-RETRY
            ma0-environment-refused     ; contract §7
            ma0-authority-slot-unfilled ; W-AUTH-EXPLICIT
            ma0-binding-refused         ; V-BIND V-FIELD V-AUTH
            ma0-pattern-refused         ; V-PATTERN
            ma0-composition-divergence)); the public composition's own refusals

;;; ⚠ R1/D4 — THE STALE-ENVIRONMENT REFUSAL, carrying the stale environment's
;;; OWN identifier.  It is a separate condition rather than a code on an
;;; existing one because the caller must be able to catch exactly this and
;;; nothing else, and because the TRUE story needs a slot: the store-id named
;;; here is the store the refused environment owns, never the store that would
;;; have been written.
(define-condition ma0-environment-stale (ma0-refusal)
  ((store-id :initarg :store-id :initform nil
             :reader ma0-environment-stale-store-id))
  (:documentation
   "Signalled when an `ma0-environment' is presented for a run after a LATER
environment took over the One Act /0 run-state specials.  ZERO journal entries,
effects, or writes occur in either store: the refusal precedes the first
consequential act."))

(defun ma0-refuse (type code fmt &rest args)
  (error type :code code :detail (apply #'format nil fmt args)))

;;; ===========================================================================
;;; §2 — declared constants.
;;;
;;; Nothing here is generated, derived from a name, or read from the clock, the
;;; PID, or the filesystem.
;;; ===========================================================================

(defparameter +ma0-grammar-version+ 0
  "Grammar version 0.  A later lane that changes ANY rule of the source
grammar changes this number, so one program text can never silently mean two
things.")

(defparameter +ma0-arms+
  '("A" "B-L1" "B-L2" "B-R" "C-i" "C-ii" "D")
  "THE CLOSED CONSTITUENT-ACT INVENTORY (contract §8 cap 1).  The seven sealed
One Act /0 arms and no others: this lane mints no fixture and has no fixture
door.  Domain variation at /0 is PROGRAM-level, never act-level.")

(defparameter +ma0-outcome-axes+
  '((:execution . (:absent :prepared-only :crossed-unsettled
                   :uncertain-unresolved :settled :reconciled))
    (:provenance . (:live :derived-recovery :none))
    (:evidence-class . (:refusal :closure :projection :control-outcome
                        :uncertain :reconciled :none)))
  "GRAMMAR §4.  Surface /2's published axis-value sets, transcribed.  There is
deliberately NO :success, :truth, :retry-safe, or :cost axis.")

(defparameter +ma0-absence-keywords+
  '(:absent-from-evidence :malformed-in-evidence)
  "Matchable on any axis as a STANDING atom (GRAMMAR §4; the same two keywords
Surface /2 publishes at surface2.lisp:1280).")

(defparameter +ma0-act-result-axes+
  '((:disposition . (:returned :refused :interrupted :host-fault :mint-refused))
    (:class . (:a :b :c-i :c-ii :d :unclassifiable :unpaired-f1)))
  "GRAMMAR §5.2.  The two axes P2 forces over an act-result, and nothing more.
An act-result is DATA: not a capability, not evidence.")

(defparameter +ma0-axes+
  '((:outcome :execution :provenance :evidence-class)
    (:act-result :disposition :class))
  "The closed axis vocabulary, by branch-head binding class.")

(defparameter +ma0-max-source-depth+ 32
  "V-SHAPE's declared depth bound.  Finite and declared, never discovered by
running out of stack.")

(defparameter +ma0-max-source-nodes+ 4096
  "V-SHAPE's declared node bound.")

;;; ===========================================================================
;;; §2b — NAME KEYS.
;;;
;;; A source IDENT is a SYMBOL and the host reader upcases it; an environment
;;; plan names the same slot or input with a STRING an author typed in the case
;;; they preferred.  One normalisation, applied at BOTH ends, is what keeps
;;; `editor-grant' in a source and "editor-grant" in a plan the same name —
;;; and keeps the equality total rather than accidental.
;;; ===========================================================================

(defun %ma0-name-key (designator)
  (string-upcase (string designator)))

;;; ===========================================================================
;;; §2c — OWNERSHIP.  The one primitive every public boundary crosses.
;;;
;;; ⚠ R1/D1.  `copy-tree' copies CONS STRUCTURE and shares every leaf.  For a
;;; language whose atoms include STRINGS — which are mutable arrays — that is
;;; not a defensive copy at all: the "copy" and the original are the same
;;; strings, and `(setf (char s 0) …)' through either one is visible through the
;;; other.  `%ma0-own' copies the leaves too.
;;;
;;; WHAT IS COPIED, AND WHY EXACTLY THIS SET.  The candidate datum vocabulary is
;;; the closed one V-DATA admits — STRING · INTEGER · KEYWORD · lawful symbol —
;;; plus, defensively, the mutable vector types a future widening might admit
;;; (byte vectors and general vectors).  STRINGS and VECTORS are copied because
;;; they are mutable.  SYMBOLS, CHARACTERS and NUMBERS are SHARED because they
;;; are immutable objects in this implementation, and copying them would buy
;;; nothing while breaking `eq' identity that the validator's binding table
;;; depends on.
;;;
;;; ⚠ IT IS TOTAL.  A source that reached an ownership boundary has already
;;; passed V-SHAPE's tree walk, so it is finite and unshared; the node budget
;;; below therefore never fires in lawful operation.  It exists so that
;;; `%ma0-own' cannot itself become the unbounded walk this round was convened
;;; to remove — a copier that can hang is the same defect wearing a different
;;; coat.
;;; ===========================================================================

(defparameter +ma0-max-owned-nodes+ 65536
  "The ownership walk's declared termination budget.  Sixteen times
`+ma0-max-source-nodes+', so lawful data never approaches it; it is a guard
against an unbounded copy, not a policy bound on program size.")

(defun %ma0-own (datum)
  "A DEEP COPY that owns its mutable leaves.  Conses, strings and vectors are
copied; symbols, characters and numbers are shared.

⚠ THE SPINE IS COPIED ITERATIVELY, AND THE FIRST DRAFT WAS NOT.  Copying a cons
as `(cons (own (car …)) (own (cdr …)))' is the obvious shape and it makes stack
depth equal LIST LENGTH — so a long flat list exhausted the control stack before
the budget below could refuse anything, which is the same defect-class this
round was convened to remove.  Its own budget tooth is what found it.  Recursion
now descends only into CARs, so depth tracks NESTING, which V-SHAPE already
bounds at `+ma0-max-source-depth+'."
  (let ((budget 0))
    (labels ((tick ()
               (when (> (incf budget) +ma0-max-owned-nodes+)
                 (ma0-refuse 'ma0-source-refused "MA0-OWN-BOUND"
                             "taking ownership of a datum exceeded the declared ~
walk budget ~d" +ma0-max-owned-nodes+)))
             (own-atom (node)
               ;; The caller has already ticked for NODE.
               (cond
                 ((stringp node) (copy-seq node))
                 ((and (vectorp node) (not (stringp node)))
                  (let ((fresh (make-array (length node)
                                           :element-type (array-element-type node))))
                    (dotimes (i (length node) fresh)
                      (setf (aref fresh i) (own (aref node i))))))
                 (t node)))
             (own (node)
               (if (consp node)
                   (let* ((head (cons nil nil))
                          (tail head))
                     (loop for cell = node then (cdr cell)
                           do (cond
                                ((consp cell)
                                 (tick)
                                 (setf (cdr tail) (cons (own (car cell)) nil)
                                       tail (cdr tail)))
                                ((null cell) (return))
                                ;; An improper tail.  V-SHAPE refuses dotted
                                ;; pairs in SOURCES, but this primitive also
                                ;; owns environment declarations, so it carries
                                ;; the case rather than assuming it away.
                                (t (tick)
                                   (setf (cdr tail) (own-atom cell))
                                   (return))))
                     (cdr head))
                   (progn (tick) (own-atom node)))))
      (own datum))))

;;; ===========================================================================
;;; §3 — the four structures.
;;; ===========================================================================

(defstruct (ma0-validated-program (:constructor %make-ma0-validated-program)
                                  (:copier nil)
                                  (:predicate ma0-validated-program-p)
                                  (:conc-name %vp-))
  "A source form that passed the WHOLE closed validator.  Constructed by
`ma0-validate' and by no other route: there is no exported constructor, so a
hand-built object cannot present itself to the evaluator as accepted."
  (name nil :read-only t)               ; STRING
  (source nil :read-only t)             ; the read form, the lane's own copy
  (inputs nil :read-only t)             ; list of IDENT symbols
  (authority-slots nil :read-only t)    ; list of IDENT symbols
  (steps nil :read-only t)              ; list of STEP forms
  (arms nil :read-only t))              ; list of arm STRINGs, textual order

(defun ma0-program-name (program)
  "The program's declared name, OWNED — a fresh string per call."
  (%ma0-own (%vp-name program)))

(defun ma0-program-source (program)
  "An OWNED COPY of the accepted source form — fresh spine AND fresh leaves.  A
caller that mutates what this returns mutates its own copy, down to the last
character of the last string (W-IMMUTABLE, R1/D1)."
  (%ma0-own (%vp-source program)))

(defstruct (ma0-environment (:constructor %make-ma0-environment) (:copier nil)
                            (:predicate ma0-environment-p)
                            (:print-object %ma0-print-environment)
                            (:conc-name %env-))
  "THE ONLY DOOR THROUGH WHICH LIVE STATE ENTERS A RUN (contract §7).  Built by
`make-ma0-environment' from DECLARATIONS — plans as data — which it turns into
live objects itself through public predecessors.  It never accepts a live
capability from a caller."
  (root nil :read-only t)
  (store nil :read-only t)
  (store-id nil :read-only t)
  (worlds nil :read-only t)             ; plist :apply WORLD :ambiguous WORLD
  (bootstrap nil :read-only t)
  (minting-context nil :read-only t)
  (arms nil :read-only t)               ; declared arm STRINGs
  (occupancy nil :read-only t)          ; alist (slot-name-string . arm-strings)
  (seat-map nil :read-only t)           ; alist (declared-name . runtime-seat)
  (inputs nil :read-only t)             ; alist (input-name-string . value)
  ;; ⚠ R1/D4 — WHICH ENVIRONMENT OWNS THE RUN-STATE SPECIALS.  Stamped at
  ;; construction from `*ma0-environment-generation*'.  An environment whose
  ;; generation is not the installed one is STALE: the specials now point at a
  ;; later environment's store and worlds, so a consequential act run through
  ;; this object would journal into a store this object does not own.
  (generation nil :read-only t))

(defun %ma0-print-environment (environment stream)
  "⚠ R1/D5 — AN ENVIRONMENT DOES NOT PRINT ITS INTERIOR.  The default structure
printer emitted every slot, which exposed the private GENERATION and — worse —
the LIVE journal store, bootstrap authority and minting context, to any `~s'
anywhere: a debugger, a log line, a refusal message that interpolated the
object.

What is printed instead is the store identity and nothing else, inside
`print-unreadable-object' so that no printed environment can be read back into
one.  The store-id is already public (`ma0-environment-store-id'), so this adds
no reader and removes several."
  (print-unreadable-object (environment stream :type t)
    (format stream "~a" (%env-store-id environment))))

(defvar *ma0-environment-generation* 0
  "THE MONOTONIC ENVIRONMENT COUNTER, package-internal and never exported.
Advanced at the exact moment `make-ma0-environment' reassigns the five exported
One Act /0 run-state specials — not at entry, because a construction REFUSED
during plan checking redirects nothing and must not make a live environment
stale (the res-not-auth witnesses build two such refused environments beside a
live one).")

(defun ma0-environment-store-id (environment)
  "The journal store's derived identity string, OWNED — a fresh string per call.

⚠ A JOURNAL STORE'S IDENTIFIER IS DERIVED FROM ITS CONTENT.  Two environments
built from the same declarations therefore carry the SAME identifier, and this
string can never be used to tell two stores apart (observed while capturing
r1/pre-repair/D4-red.txt).  It names a store's content, not a store's identity."
  (%ma0-own (%env-store-id environment)))

(defstruct (ma0-act-summary (:constructor %make-ma0-act-summary) (:copier nil)
                            (:predicate ma0-act-summary-p)
                            (:conc-name %as-))
  "What one `act' step bound: an IMMUTABLE SUMMARY, and DATA.  It carries no
capability interface and no evidence; evidence is derived from the store by a
`derive' step (GRAMMAR §5.2)."
  (arm nil :read-only t)                ; STRING
  (act-id-hex nil :read-only t)         ; the 64-char digest segment, or NIL
  (disposition nil :read-only t)        ; KEYWORD, +ma0-act-result-axes+
  (class nil :read-only t)              ; KEYWORD, +ma0-act-result-axes+
  (verdict nil :read-only t))           ; STRING agreement verdict, or NIL

;;; The three STRING-valued readers own; the two KEYWORD-valued ones share,
;;; because a keyword has no mutable interior to hand away.
(defun ma0-act-summary-arm (summary) (%ma0-own (%as-arm summary)))
(defun ma0-act-summary-act-id-hex (summary) (%ma0-own (%as-act-id-hex summary)))
(defun ma0-act-summary-disposition (summary) (%as-disposition summary))
(defun ma0-act-summary-class (summary) (%as-class summary))
(defun ma0-act-summary-verdict (summary) (%ma0-own (%as-verdict summary)))

(defstruct (ma0-result (:constructor %make-ma0-result) (:copier nil)
                       (:predicate ma0-result-p)
                       (:conc-name %res-))
  "The immutable program result (GRAMMAR §5.3).  DISPOSITION is `:completed' or
`:refused' and is never laundered: a `refuse' terminal produces `:refused' and
an orderly exit, and no path converts a refusal into a completion."
  (program-name nil :read-only t)
  (disposition nil :read-only t)        ; :completed | :refused
  (value nil :read-only t)              ; the `result' payload, or NIL
  (refusal-code nil :read-only t)       ; KEYWORD, or NIL
  (refusal-detail nil :read-only t)     ; the `refuse' payload, or NIL
  (act-summaries nil :read-only t)      ; ordered list, oldest act first
  (store-id nil :read-only t))

(defun ma0-result-program-name (result) (%ma0-own (%res-program-name result)))
(defun ma0-result-disposition (result) (%res-disposition result))

(defun ma0-result-value (result)
  "An OWNED COPY of the terminal payload — fresh spine AND fresh leaves."
  (%ma0-own (%res-value result)))

(defun ma0-result-refusal-code (result) (%res-refusal-code result))

(defun ma0-result-refusal-detail (result)
  "An OWNED COPY of the refusal payload — fresh spine AND fresh leaves."
  (%ma0-own (%res-refusal-detail result)))

(defun ma0-result-act-summaries (result)
  "A FRESH LIST of the act summaries, oldest act first.  The summaries
themselves are read-only structures whose own readers own what they hand out,
so the list is the only thing that needs copying here."
  (copy-list (%res-act-summaries result)))

(defun ma0-result-store-id (result) (%ma0-own (%res-store-id result)))
