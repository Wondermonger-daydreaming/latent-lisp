;;;; ma0-validate.lisp — the closed validator (GRAMMAR §2), and the source
;;;; reader that is its only lawful mouth.
;;;;
;;;; CANDIDATE.  Nothing here is adopted (contract §0).
;;;;
;;;; ⚠ VALIDATION IS TOTAL BEFORE ANY ENVIRONMENT CONTACT.  Not one function in
;;;; this file touches a store, a world, a capability, or a special variable of
;;;; any predecessor.  An unaccepted source therefore mints nothing, journals
;;;; nothing, and leaves no footprint (W-V-FOOTPRINT) — which is a property of
;;;; the CALL GRAPH here, not a promise in a docstring.
;;;;
;;;; — FABER (Claude Opus 5, subagent), 2026-08-09

(in-package #:lisp-plus-many-acts0)

;;; ===========================================================================
;;; §1 — the closed head vocabulary, recognised BY NAME with the home package
;;; confirmed in the same breath (see the program-package docstring).
;;; ===========================================================================

(defparameter +ma0-heads+
  '("MA0-PROGRAM" "BIND" "ACT" "DERIVE" "BRANCH" "OTHERWISE"
    "RESULT" "REFUSE" "REF" "FIELD" "LIST")
  "V-RETRY's closed world.  There is no retry, resume, loop, recursion, assert,
reconcile, or value-computation head, and an unknown head is refused BY THIS
LIST rather than by falling through to a default.")

(defun %ma0-home-lawful-p (symbol)
  "V-PKG.  A non-keyword symbol's home package must be the program namespace or
this lane's own package.  A symbol homed anywhere else — including a host
package, an uninterned gensym (home NIL), or a predecessor's internals — is
refused."
  (let ((home (symbol-package symbol)))
    (and home
         (or (eq home (find-package '#:lisp-plus-many-acts0.program))
             (eq home (find-package '#:lisp-plus-many-acts0))))))

(defun %ma0-head-p (form name)
  (and (consp form) (symbolp (first form)) (not (keywordp (first form)))
       (%ma0-home-lawful-p (first form))
       (string= name (symbol-name (first form)))))

(defun %ma0-head-name (form)
  (and (consp form) (symbolp (first form)) (not (keywordp (first form)))
       (%ma0-home-lawful-p (first form))
       (symbol-name (first form))))

(defun %ma0-ident-p (object)
  "An IDENT: a non-keyword symbol homed in a lawful package whose name is NOT a
grammar head.  The last conjunct matters — without it `(bind list 1)' would
define a binding whose name shadows a construct in the reader's eye, and a
grammar whose names can be re-used as data names is not closed."
  (and (symbolp object) (not (keywordp object)) (not (null object))
       (not (eq object t))
       (%ma0-home-lawful-p object)
       (not (member (symbol-name object) +ma0-heads+ :test #'string=))))

;;; ===========================================================================
;;; §2 — V-READ.  Reader-eval cannot reach the validator.
;;; ===========================================================================

(defun %ma0-read-source (pathname)
  "Read exactly one source form from PATHNAME with `*read-eval*' bound to NIL
and `*package*' bound to the program namespace.

⚠ THE BINDINGS ARE THE LAW, NOT A CONVENTION.  With `*read-eval*' NIL a `#.'
never survives to the validator: it dies at the READER (V-READ), which is one
layer below anything the validator could inspect.  With `*package*' bound to
the program namespace, a bare symbol is homed THERE, so V-PKG has something
mechanical to test instead of a habit to trust."
  (handler-case
      (with-open-file (in pathname :direction :input
                                   :external-format :utf-8
                                   :element-type 'character)
        (let ((*read-eval* nil)
              (*package* (find-package '#:lisp-plus-many-acts0.program))
              (*read-default-float-format* 'double-float))
          (let* ((eof '#:eof)
                 (form (read in nil eof))
                 (extra (read in nil eof)))
            (when (eq form eof)
              (ma0-refuse 'ma0-source-refused "V-SHAPE"
                          "the source file ~a is empty" pathname))
            (unless (eq extra eof)
              (ma0-refuse 'ma0-source-refused "V-SHAPE"
                          "the source file ~a holds more than one form; a ~
program is ONE form" pathname))
            form)))
    (ma0-refusal (c) (error c))
    (error (c)
      (ma0-refuse 'ma0-source-refused "V-READ"
                  "the reader refused ~a: ~a [~a]" pathname (type-of c) c))))

;;; ===========================================================================
;;; §3 — V-SHAPE / V-ATOMS / V-DATA / V-PKG: the total atom and shape scan.
;;; ===========================================================================

(defun %ma0-proper-list-p (object)
  "⚠ NOT CYCLE-SAFE, AND IT DOES NOT NEED TO BE.  Every caller below runs
strictly AFTER `%ma0-scan-atoms' has proved the whole form is a finite TREE
(R1/D3), so no cycle can reach this loop.  Called before that proof, it would
not return — which is exactly the defect r1/pre-repair/D3-red.txt records."
  (and (listp object)
       (loop for tail = object then (cdr tail)
             do (cond ((null tail) (return t))
                      ((not (consp tail)) (return nil))))))

;;; ---------------------------------------------------------------------------
;;; ⚠ R1/D3 — A LAWFUL SOURCE IS A TREE.  THE POLICY, STATED RATHER THAN LEFT
;;; TO BE INFERRED:
;;;
;;;   A cons cell reached a SECOND time during the scan is refused — whether the
;;;   second reach is a CYCLE (the cell is its own ancestor) or merely SHARED
;;;   acyclic substructure (a DAG).  Both are refused; the source must be a
;;;   tree.
;;;
;;; WHY THE STRICTER OF THE TWO OPTIONS, ON THE MERITS.  Three reasons, and the
;;; third is decisive:
;;;
;;;   1. IT COSTS NOTHING LAWFUL.  The lane's own mouth is `%ma0-read-source',
;;;      and a reader with `*read-circle*' at its default builds a tree — it
;;;      cannot produce sharing at all.  Shared structure can only arrive
;;;      through the already-read FORM door, which is the hostile path.
;;;   2. IT IS ONE SENTENCE.  "A lawful source is a tree" is statable, and a
;;;      rule an author can hold is worth more than a rule that is merely sound.
;;;   3. IT KEEPS THE DECLARED NODE BOUND HONEST — and stops this round's OWN
;;;      repair from opening a hole.  Under a visited-table that ACCEPTS DAG
;;;      sharing, the node bound counts VISITS, but `%ma0-own' (R1/D1) copies
;;;      the EXPANSION: a source of sixty shared conses can expand to 2^30 on
;;;      the way to becoming the lane's own copy.  Accepting sharing would have
;;;      converted a fixed bound into an exponential one, in the same round that
;;;      added the copier.  Refusing sharing makes the bound count what a copy
;;;      will actually allocate.
;;;
;;; The refusal is V-SHAPE — an EXISTING law ("proper lists throughout … depth
;;; and length finite and bounded"), not a new one.  No code is minted.
;;; ---------------------------------------------------------------------------

(defun %ma0-scan-atoms (form)
  "V-DATA / V-ATOMS / V-PKG / V-SHAPE, in ONE total walk, with the declared
depth and node bounds enforced as it goes, and with an EQ-visited table that
makes the walk TOTAL on any input whatsoever (R1/D3).

⚠ THE ADMITTED ATOM TYPES ARE LISTED, NOT EXCLUDED.  A closed world is a
whitelist; a blacklist of `functionp' and `vectorp' would admit the next type
nobody thought of.  STRING · INTEGER · KEYWORD · lawful symbol, and that is
all: a closure, a function, a structure, a vector, a pathname, a character, a
float, a ratio, a complex, a hash table, or a package is refused HERE.

⚠ THE SPINE IS WALKED CONS BY CONS, not by `%ma0-proper-list-p' followed by a
`dolist'.  That is the whole of the D3 repair: the old shape asked a separate,
unguarded loop to chase the `cdr' chain first, and on a circular chain that loop
never returned — so the visited table had to move INTO the spine walk, where the
cycle actually lives, rather than sit outside it."
  (let ((nodes 0)
        (seen (make-hash-table :test #'eq)))
    (labels ((tick ()
               (when (> (incf nodes) +ma0-max-source-nodes+)
                 (ma0-refuse 'ma0-source-refused "V-SHAPE"
                             "source node count exceeds the declared bound ~d"
                             +ma0-max-source-nodes+)))
             (atom-check (node)
               (cond
                 ((null node))          ; the empty list
                 ((keywordp node))      ; lawful literal / grammar keyword
                 ((symbolp node)
                  (unless (%ma0-home-lawful-p node)
                    (ma0-refuse 'ma0-source-refused "V-PKG"
                                "symbol ~a is homed in ~a; only the program ~
namespace and this lane's package are admitted"
                                (symbol-name node)
                                (if (symbol-package node)
                                    (package-name (symbol-package node))
                                    "no package (uninterned)"))))
                 ((stringp node))
                 ((integerp node))
                 (t
                  (ma0-refuse 'ma0-source-refused "V-DATA"
                              "an atom of type ~a is not admitted; the closed ~
atom vocabulary is STRING, INTEGER, KEYWORD, and lawful symbols"
                              (type-of node)))))
             (walk (node depth)
               (when (> depth +ma0-max-source-depth+)
                 (ma0-refuse 'ma0-source-refused "V-SHAPE"
                             "source depth exceeds the declared bound ~d"
                             +ma0-max-source-depth+))
               (if (consp node)
                   ;; The spine, one cons at a time, each one marked BEFORE its
                   ;; successor is examined.  A circular `cdr' chain meets its
                   ;; own mark on the second lap and dies there.
                   (loop for tail = node then (cdr tail)
                         do (cond
                              ((null tail) (return))
                              ((not (consp tail))
                               (ma0-refuse 'ma0-source-refused "V-SHAPE"
                                           "a dotted pair is not a lawful ~
source node"))
                              ((gethash tail seen)
                               (ma0-refuse 'ma0-source-refused "V-SHAPE"
                                           "a cons cell is reached a second ~
time; a lawful source is a TREE, so circular structure and shared acyclic ~
substructure are both refused — the declared node bound ~d counts what a copy ~
of this source would allocate"
                                           +ma0-max-source-nodes+))
                              (t (setf (gethash tail seen) t)
                                 (tick)
                                 (walk (car tail) (1+ depth)))))
                   (progn (tick) (atom-check node)))))
      (walk form 0))
    nodes))

;;; ===========================================================================
;;; §4 — the binding table.  ONE FLAT PROGRAM NAMESPACE (GRAMMAR §3).
;;; ===========================================================================
;;;
;;; Classes: :value (input / bind) · :act-result (act) · :outcome (derive).
;;; A name is DEFINED once, anywhere in the text, and NO SHADOWING EXISTS.
;;;
;;; ⚠ R1/D2 — TWO TABLES, BECAUSE THE SEALED GRAMMAR ASKS TWO DIFFERENT
;;; QUESTIONS AND ONE TABLE CANNOT ANSWER BOTH.
;;;
;;;   DEFINED (cumulative, never restored) answers V-BIND's *textual* question:
;;;   "has this name been defined ANYWHERE in this program text?"  GRAMMAR §3's
;;;   no-shadowing law is textual — "duplicate definition anywhere (including
;;;   across branch arms vs outer scope) is refused" — so this table must span
;;;   every alternative of every branch.
;;;
;;;   VISIBLE (per-path, saved and restored around each branch alternative)
;;;   answers the *control-flow* question: "is this name bound on the path we
;;;   are on?"  It must NOT span sibling alternatives, because at most one
;;;   alternative is ever evaluated (GRAMMAR §4's selection law).
;;;
;;; BEFORE THE REPAIR THERE WAS ONE TABLE, PLAYING BOTH PARTS AND LOSING THE
;;; SECOND.  A name bound inside the first alternative stayed visible while the
;;; second was checked, so the second could reference a binding that exists only
;;; on a path it is not on: ACCEPTED here, dead at evaluation.  Witness:
;;; r1/pre-repair/D2-red.txt.
;;;
;;; ⚠ AND THE POST-BRANCH QUESTION IS VACUOUS, WHICH IS WHY NO ALL-PATHS
;;; ANALYSIS APPEARS BELOW.  GRAMMAR §3 says a name is visible "from its
;;; definition to the end of the program text (including inside subsequently
;;; selected branch arms)" — which reads as though a name bound inside one
;;; alternative might have to be definitely-bound after the branch.  It never
;;; can be, because THERE IS NO AFTER: V-TERM requires every branch arm to end
;;; in a terminal, `%ma0-check-steps' refuses any sequence that does not, and it
;;; then refuses any step following one that closed.  A branch therefore always
;;; closes its sequence and no step can follow it (GRAMMAR §1's single-shape
;;; law, stated there as "fall-through across a branch is refused").  The
;;; §3 sentence governs names defined BEFORE a branch being visible INSIDE its
;;; arms — which is sound, since such a name is bound on every path that reaches
;;; the branch.  The vacuity is not assumed: it is witnessed by the
;;; "a step after a branch" fixture, which must refuse with V-TERM.

(defstruct (%vctx (:copier nil))
  (bindings '())                        ; VISIBLE: alist (symbol . class), per path
  (defined '())                         ; DEFINED: alist (symbol . class), cumulative
  (slots '())                           ; list of slot IDENT symbols
  (arms '()))                           ; list of arm STRINGs, newest first

(defun %ma0-define (ctx ident class)
  (when (assoc ident (%vctx-defined ctx))
    (ma0-refuse 'ma0-binding-refused "V-BIND"
                "identifier ~a is defined more than once; this language has ~
ONE flat namespace and no shadowing — a name defined inside one branch ~
alternative is defined for the WHOLE program text, so a second definition in a ~
sibling alternative is refused too" (symbol-name ident)))
  (when (member ident (%vctx-slots ctx))
    (ma0-refuse 'ma0-binding-refused "V-AUTH"
                "identifier ~a is an authority slot and may not also name a ~
binding; a slot is not a value" (symbol-name ident)))
  (push (cons ident class) (%vctx-defined ctx))
  (push (cons ident class) (%vctx-bindings ctx))
  ident)

(defun %ma0-class-of (ctx ident)
  (let ((row (assoc ident (%vctx-bindings ctx))))
    (unless row
      ;; The two refusals are the same law (V-BIND) and deliberately different
      ;; sentences: a name that was never written at all is an author's typo,
      ;; while a name written in a SIBLING alternative is the D2 trap, and an
      ;; author who is told which one they hit does not have to guess.
      (if (assoc ident (%vctx-defined ctx))
          (ma0-refuse 'ma0-binding-refused "V-BIND"
                      "identifier ~a is defined only inside a branch ~
alternative that this one is not on; at most one alternative is ever ~
evaluated, so the name is not bound on this path" (symbol-name ident))
          (ma0-refuse 'ma0-binding-refused "V-BIND"
                      "identifier ~a is used before it is defined (or is never ~
defined)" (symbol-name ident))))
    (cdr row)))

;;; ===========================================================================
;;; §5 — VEXPR.
;;; ===========================================================================

(defun %ma0-check-vexpr (ctx form)
  "VEXPR := LITERAL | (ref IDENT) | (field IDENT AXIS) | (list VEXPR+)."
  (cond
    ((or (stringp form) (integerp form) (keywordp form)) t)
    ((consp form)
     (let ((head (%ma0-head-name form)))
       (cond
         ((equal head "REF")
          (unless (and (= 2 (length form)) (%ma0-ident-p (second form)))
            (ma0-refuse 'ma0-source-refused "V-SHAPE"
                        "(ref IDENT) takes exactly one identifier: ~s" form))
          (let ((class (%ma0-class-of ctx (second form))))
            (unless (eq class :value)
              (ma0-refuse 'ma0-binding-refused "V-FIELD"
                          "(ref ~a) names a ~a binding; `ref' takes ordinary ~
values only" (symbol-name (second form)) class))))
         ((equal head "FIELD")
          (unless (and (= 3 (length form)) (%ma0-ident-p (second form))
                       (keywordp (third form)))
            (ma0-refuse 'ma0-source-refused "V-SHAPE"
                        "(field IDENT AXIS) takes an identifier and an axis ~
keyword: ~s" form))
          (let ((class (%ma0-class-of ctx (second form))))
            (unless (eq class :outcome)
              (ma0-refuse 'ma0-binding-refused "V-FIELD"
                          "(field ~a ~s) names a ~a binding; `field' reads ~
DERIVED outcomes only — an act-result's shape is inspected by `branch', never ~
projected by field access" (symbol-name (second form)) (third form) class)))
          (unless (assoc (third form) +ma0-outcome-axes+)
            (ma0-refuse 'ma0-pattern-refused "V-FIELD"
                        "~s is not one of the closed outcome axes ~s"
                        (third form) (mapcar #'car +ma0-outcome-axes+))))
         ((equal head "LIST")
          (unless (>= (length form) 2)
            (ma0-refuse 'ma0-source-refused "V-SHAPE"
                        "(list VEXPR+) takes at least one element: ~s" form))
          (dolist (sub (rest form)) (%ma0-check-vexpr ctx sub)))
         (t
          (ma0-refuse 'ma0-source-refused "V-RETRY"
                      "~s is not a lawful value expression; the closed VEXPR ~
world is LITERAL | (ref IDENT) | (field IDENT AXIS) | (list VEXPR+)" form)))))
    ((%ma0-ident-p form)
     (ma0-refuse 'ma0-source-refused "V-SHAPE"
                 "a bare identifier ~a is not a value expression; write ~
(ref ~a)" (symbol-name form) (symbol-name form)))
    (t (ma0-refuse 'ma0-source-refused "V-DATA"
                   "~s is not a lawful value expression" form)))
  t)

;;; ===========================================================================
;;; §6 — V-PATTERN.
;;; ===========================================================================

(defun %ma0-axis-table (head-class)
  (ecase head-class
    (:outcome +ma0-outcome-axes+)
    (:act-result +ma0-act-result-axes+)))

(defun %ma0-check-atom (atom head-class)
  "ATOMP := (AXIS PVALUE).  PVALUE is a closed axis value or one of the two
absence keywords (GRAMMAR §4)."
  (unless (and (%ma0-proper-list-p atom) (= 2 (length atom))
               (keywordp (first atom)) (keywordp (second atom)))
    (ma0-refuse 'ma0-pattern-refused "V-PATTERN"
                "~s is not a pattern atom (AXIS PVALUE), both keywords" atom))
  (let* ((table (%ma0-axis-table head-class))
         (row (assoc (first atom) table)))
    (unless row
      (ma0-refuse 'ma0-pattern-refused "V-PATTERN"
                  "~s is not one of the closed axes ~s for a ~a branch head"
                  (first atom) (mapcar #'car table) head-class))
    (unless (or (member (second atom) (cdr row))
                (member (second atom) +ma0-absence-keywords+))
      (ma0-refuse 'ma0-pattern-refused "V-PATTERN"
                  "~s is not a closed value of axis ~s (values ~s, plus the ~
absence keywords ~s)"
                  (second atom) (first atom) (cdr row) +ma0-absence-keywords+)))
  t)

(defun %ma0-canonical-pattern (pattern head-class)
  "Refuse an unlawful pattern; return its canonical form — the atom list sorted
by axis name — so V-PATTERN's duplicate check compares patterns and not
transcriptions."
  (let ((atoms (cond ((and (%ma0-proper-list-p pattern)
                           (eq :and (first pattern)))
                      (unless (>= (length pattern) 3)
                        (ma0-refuse 'ma0-pattern-refused "V-PATTERN"
                                    "(:and …) takes at least TWO atoms: ~s"
                                    pattern))
                      (rest pattern))
                     (t (list pattern)))))
    (dolist (atom atoms) (%ma0-check-atom atom head-class))
    (let ((axes (mapcar #'first atoms)))
      (unless (= (length axes) (length (remove-duplicates axes)))
        (ma0-refuse 'ma0-pattern-refused "V-PATTERN"
                    "a conjunction names one axis twice: ~s" pattern)))
    (sort (copy-tree atoms) #'string< :key (lambda (a) (symbol-name (first a))))))

;;; ===========================================================================
;;; §7 — steps, terminals, and V-TERM's closure law.
;;; ===========================================================================
;;;
;;; A step SEQUENCE is CLOSED when its last step is a TERMINAL, or is a BRANCH
;;; every arm of which is closed.  That is the exact reading GRAMMAR §5.3 and
;;; the P1 brief force together: P1's `:steps' holds ONE step — a branch — and
;;; ends there, so "the final step is a TERMINAL" cannot mean "is literally a
;;; result/refuse form" without refusing the brief's own program.

(defun %ma0-terminal-p (form)
  (let ((head (%ma0-head-name form)))
    (and head (or (equal head "RESULT") (equal head "REFUSE")))))

(defun %ma0-branch-p (form)
  (equal "BRANCH" (%ma0-head-name form)))

(defun %ma0-check-terminal (ctx form)
  (let ((head (%ma0-head-name form)))
    (cond
      ((equal head "RESULT")
       (unless (= 2 (length form))
         (ma0-refuse 'ma0-source-refused "V-SHAPE"
                     "(result VEXPR) takes exactly one value expression: ~s"
                     form))
       (%ma0-check-vexpr ctx (second form)))
      ((equal head "REFUSE")
       (unless (and (<= 2 (length form) 3)
                    (%ma0-proper-list-p (second form))
                    (= 2 (length (second form)))
                    (eq :code (first (second form)))
                    (keywordp (second (second form))))
         (ma0-refuse 'ma0-source-refused "V-SHAPE"
                     "(refuse (:code KEYWORD) VEXPR?) is the only refusal ~
shape: ~s" form))
       (when (= 3 (length form))
         (%ma0-check-vexpr ctx (third form)))))
    t))

(defun %ma0-check-steps (ctx steps where)
  "Walk STEPS in textual order.  Returns T when the sequence is CLOSED."
  (unless (and (%ma0-proper-list-p steps) (plusp (length steps)))
    (ma0-refuse 'ma0-source-refused "V-TERM"
                "~a holds no steps" where))
  (let ((closed nil))
    (loop for (step . rest) on steps
          do (when closed
               (ma0-refuse 'ma0-source-refused "V-TERM"
                           "~a holds a step after a terminal one; ~
unreachable code is refused" where))
             (setf closed (%ma0-check-step ctx step))
             (when (and (null rest) (not closed))
               (ma0-refuse 'ma0-source-refused "V-TERM"
                           "~a does not end in a terminal" where)))
    closed))

(defun %ma0-check-step (ctx step)
  "Returns T when STEP closes its sequence."
  (unless (and (%ma0-proper-list-p step) (consp step))
    (ma0-refuse 'ma0-source-refused "V-SHAPE" "~s is not a step form" step))
  (let ((head (%ma0-head-name step)))
    (unless head
      (ma0-refuse 'ma0-source-refused "V-RETRY"
                  "~s has no lawful head symbol; the closed head world is ~s"
                  step +ma0-heads+))
    (cond
      ;; ---- (bind IDENT VEXPR) --------------------------------------------
      ((equal head "BIND")
       (unless (and (= 3 (length step)) (%ma0-ident-p (second step)))
         (ma0-refuse 'ma0-source-refused "V-SHAPE"
                     "(bind IDENT VEXPR): ~s" step))
       (%ma0-check-vexpr ctx (third step))
       (%ma0-define ctx (second step) :value)
       nil)
      ;; ---- (act IDENT (:arm ARM) (:authority-slot IDENT)) -----------------
      ((equal head "ACT")
       (unless (and (= 4 (length step)) (%ma0-ident-p (second step)))
         (ma0-refuse 'ma0-source-refused "V-SHAPE"
                     "(act IDENT (:arm ARM) (:authority-slot IDENT)): ~s" step))
       (let ((arm-clause (third step)) (auth-clause (fourth step)))
         (unless (and (%ma0-proper-list-p arm-clause) (= 2 (length arm-clause))
                      (eq :arm (first arm-clause)))
           (ma0-refuse 'ma0-source-refused "V-SHAPE"
                       "the second clause of `act' must be (:arm ARM): ~s" step))
         (unless (and (stringp (second arm-clause))
                      (member (second arm-clause) +ma0-arms+ :test #'string=))
           (ma0-refuse 'ma0-source-refused "V-ARM"
                       "~s is not one of the seven sealed arms ~s"
                       (second arm-clause) +ma0-arms+))
         (when (member (second arm-clause) (%vctx-arms ctx) :test #'string=)
           (ma0-refuse 'ma0-source-refused "V-ARM"
                       "arm ~s appears more than once in this program text; a ~
constituent act's runtime seat is consumed once per store, so a second ~
invocation is refused STATICALLY and therefore has no footprint"
                       (second arm-clause)))
         (push (second arm-clause) (%vctx-arms ctx))
         (unless (and (%ma0-proper-list-p auth-clause) (= 2 (length auth-clause))
                      (eq :authority-slot (first auth-clause)))
           (ma0-refuse 'ma0-source-refused "V-SHAPE"
                       "the third clause of `act' must be (:authority-slot ~
IDENT): ~s" step))
         (let ((slot (second auth-clause)))
           (unless (%ma0-ident-p slot)
             (ma0-refuse 'ma0-binding-refused "V-RES-AUTH"
                         "~s stands in authority position; only a declared ~
slot identifier may — never a string, a literal, an outcome, or an act-result"
                         slot))
           (unless (member slot (%vctx-slots ctx))
             (ma0-refuse 'ma0-binding-refused "V-AUTH"
                         "authority slot ~a is not declared in ~
:authority-slots" (symbol-name slot)))))
       (%ma0-define ctx (second step) :act-result)
       nil)
      ;; ---- (derive IDENT (:seat SEATD)) ------------------------------------
      ((equal head "DERIVE")
       (unless (and (= 3 (length step)) (%ma0-ident-p (second step))
                    (%ma0-proper-list-p (third step))
                    (= 2 (length (third step)))
                    (eq :seat (first (third step))))
         (ma0-refuse 'ma0-source-refused "V-SHAPE"
                     "(derive IDENT (:seat SEATD)): ~s" step))
       (let ((seatd (second (third step))))
         (cond ((stringp seatd))
               ((and (consp seatd) (equal "REF" (%ma0-head-name seatd)))
                (%ma0-check-vexpr ctx seatd))
               (t (ma0-refuse 'ma0-source-refused "V-SHAPE"
                              "SEATD is a STRING or (ref IDENT): ~s" seatd))))
       (%ma0-define ctx (second step) :outcome)
       nil)
      ;; ---- (branch IDENT CLAUSE+ OTHER) ------------------------------------
      ((equal head "BRANCH")
       (unless (and (>= (length step) 4) (%ma0-ident-p (second step)))
         (ma0-refuse 'ma0-source-refused "V-SHAPE"
                     "(branch IDENT CLAUSE+ (otherwise STEP+)) needs a head ~
identifier, at least one clause, and a trailing otherwise: ~s" step))
       (let* ((head-ident (second step))
              (head-class (%ma0-class-of ctx head-ident))
              (clauses (butlast (cddr step)))
              (other (car (last step))))
         (unless (member head-class '(:outcome :act-result))
           (ma0-refuse 'ma0-binding-refused "V-FIELD"
                       "branch head ~a is an ordinary value; a branch reads a ~
DERIVED outcome or an act-result" (symbol-name head-ident)))
         (unless (equal "OTHERWISE" (%ma0-head-name other))
           (ma0-refuse 'ma0-pattern-refused "V-PATTERN"
                       "a branch's last clause must be (otherwise STEP+): ~s"
                       other))
         (unless (plusp (length clauses))
           (ma0-refuse 'ma0-pattern-refused "V-PATTERN"
                       "a branch needs at least one pattern clause besides ~
`otherwise'"))
         ;; ⚠ R1/D2 — EACH ALTERNATIVE IS CHECKED FROM AN INDEPENDENT COPY OF
         ;; THE INCOMING VISIBILITY TABLE.  `%ma0-define' PUSHES onto the
         ;; `bindings' slot, so the incoming table is restored simply by putting
         ;; the saved head back: the alternative's own definitions fall away
         ;; with it, and what a sibling bound is not in scope here.
         ;;
         ;; THREE THINGS ARE DELIBERATELY *NOT* RESTORED, and each would be a
         ;; distinct defect if it were:
         ;;   `defined' — V-BIND's textual no-shadowing law spans the whole
         ;;               program text, siblings included (GRAMMAR §3).
         ;;   `arms'    — V-ARM's "at most once in the whole program text" is
         ;;               textual too: one arm may not appear in two
         ;;               alternatives, because its runtime seat is consumed
         ;;               once per store however the branch happens to fall.
         ;;   `slots'   — declared once in the header; nothing here changes it.
         (let ((seen '()) (all-closed t)
               (incoming (%vctx-bindings ctx)))
           (flet ((check-alternative (steps where)
                    (setf (%vctx-bindings ctx) incoming)
                    (prog1 (%ma0-check-steps ctx steps where)
                      (setf (%vctx-bindings ctx) incoming))))
             (dolist (clause clauses)
               (unless (and (%ma0-proper-list-p clause) (>= (length clause) 2))
                 (ma0-refuse 'ma0-source-refused "V-SHAPE"
                             "a branch clause is (PATTERN STEP+): ~s" clause))
               (let ((canon (%ma0-canonical-pattern (first clause) head-class)))
                 (when (member canon seen :test #'equal)
                   (ma0-refuse 'ma0-pattern-refused "V-PATTERN"
                               "clause pattern ~s repeats an earlier clause and ~
could never be selected" (first clause)))
                 (push canon seen))
               (unless (check-alternative (rest clause)
                                          (format nil "branch clause ~s"
                                                  (first clause)))
                 (setf all-closed nil)))
             (unless (check-alternative (rest other) "the otherwise clause")
               (setf all-closed nil)))
           ;; No name enters the post-branch visibility table, because there is
           ;; no post-branch position: `all-closed' is T here for every source
           ;; `%ma0-check-steps' does not refuse, and V-TERM then refuses any
           ;; step that would follow.  See the §4 note.
           all-closed)))
      ;; ---- terminals -------------------------------------------------------
      ((or (equal head "RESULT") (equal head "REFUSE"))
       (%ma0-check-terminal ctx step)
       t)
      ;; ---- everything else -------------------------------------------------
      (t (ma0-refuse 'ma0-source-refused "V-RETRY"
                     "~a is not a step head; the closed step world is bind · ~
act · derive · branch · result · refuse.  There is no retry, resume, loop, ~
recursion, assert, or reconcile step in this language, and the absence is a ~
law rather than an omission" head)))))

;;; ===========================================================================
;;; §8 — the door.
;;; ===========================================================================

(defun ma0-validate (source)
  "SOURCE is a PATHNAME (read through the lane's own reader) or an already-read
source FORM.  Returns a validated-program, or signals a typed refusal.

⚠ TOTAL BEFORE ANY ENVIRONMENT CONTACT.  Nothing below reaches a store, a
world, a capability, or a run-state special."
  (let ((form (if (pathnamep source) (%ma0-read-source source) source)))
    (%ma0-scan-atoms form)
    (unless (%ma0-head-p form "MA0-PROGRAM")
      (ma0-refuse 'ma0-source-refused "V-SHAPE"
                  "a program's head must be `ma0-program'"))
    (unless (= 5 (length form))
      (ma0-refuse 'ma0-source-refused "V-SHAPE"
                  "(ma0-program (:name STRING) (:input (IDENT*)) ~
(:authority-slots (IDENT+)) (:steps STEP+)) — four clauses, exactly"))
    (destructuring-bind (name-clause input-clause slots-clause steps-clause)
        (rest form)
      ;; ---- (:name STRING) ------------------------------------------------
      (unless (and (%ma0-proper-list-p name-clause) (= 2 (length name-clause))
                   (eq :name (first name-clause))
                   (stringp (second name-clause))
                   (plusp (length (second name-clause))))
        (ma0-refuse 'ma0-source-refused "V-SHAPE"
                    "(:name STRING) with a non-empty string: ~s" name-clause))
      ;; ---- (:input (IDENT*)) ----------------------------------------------
      (unless (and (%ma0-proper-list-p input-clause) (= 2 (length input-clause))
                   (eq :input (first input-clause))
                   (%ma0-proper-list-p (second input-clause)))
        (ma0-refuse 'ma0-source-refused "V-SHAPE"
                    "(:input (IDENT*)): ~s" input-clause))
      ;; ---- (:authority-slots (IDENT+)) -------------------------------------
      (unless (and (%ma0-proper-list-p slots-clause) (= 2 (length slots-clause))
                   (eq :authority-slots (first slots-clause))
                   (%ma0-proper-list-p (second slots-clause))
                   (plusp (length (second slots-clause))))
        (ma0-refuse 'ma0-source-refused "V-SHAPE"
                    "(:authority-slots (IDENT+)) with at least one slot: ~s"
                    slots-clause))
      ;; ---- (:steps STEP+) ---------------------------------------------------
      (unless (and (%ma0-proper-list-p steps-clause)
                   (>= (length steps-clause) 2)
                   (eq :steps (first steps-clause)))
        (ma0-refuse 'ma0-source-refused "V-SHAPE"
                    "(:steps STEP+): ~s" steps-clause))
      (let ((ctx (make-%vctx))
            (inputs (second input-clause))
            (slots (second slots-clause)))
        (dolist (slot slots)
          (unless (%ma0-ident-p slot)
            (ma0-refuse 'ma0-source-refused "V-AUTH"
                        "~s is not a lawful authority-slot identifier" slot))
          (when (member slot (%vctx-slots ctx))
            (ma0-refuse 'ma0-source-refused "V-AUTH"
                        "authority slot ~a is declared twice"
                        (symbol-name slot)))
          (push slot (%vctx-slots ctx)))
        (dolist (in inputs)
          (unless (%ma0-ident-p in)
            (ma0-refuse 'ma0-source-refused "V-SHAPE"
                        "~s is not a lawful input identifier" in))
          (%ma0-define ctx in :value))
        (%ma0-check-steps ctx (rest steps-clause) "the program's :steps")
        ;; ⚠ R1/D1 — THE LANE TAKES OWNERSHIP HERE, AND EACH SLOT TAKES ITS OWN.
        ;; `%ma0-own' is called SEPARATELY per slot rather than once over the
        ;; whole form, so `:source' (what readers hand out) and `:steps' (what
        ;; the evaluator runs) share NOTHING — not a cons, not a string.  Under
        ;; the old `copy-tree' they shared every leaf with each other and with
        ;; the caller's form, which is why mutating an arm name in a returned
        ;; source copy changed the program that then executed
        ;; (r1/pre-repair/D1-red.txt, probes D1-1 and D1-2).
        (%make-ma0-validated-program
         :name (%ma0-own (second name-clause))
         :source (%ma0-own form)
         :inputs (%ma0-own inputs)
         :authority-slots (%ma0-own (reverse (%vctx-slots ctx)))
         :steps (%ma0-own (rest steps-clause))
         :arms (%ma0-own (reverse (%vctx-arms ctx))))))))
