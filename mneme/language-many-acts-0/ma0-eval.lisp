;;;; ma0-eval.lisp — the evaluator (GRAMMAR §5).
;;;;
;;;; CANDIDATE.  Nothing here is adopted (contract §0).
;;;;
;;;; ⚠ THE EVALUATOR IS GENERIC OVER PROGRAMS (W-GENERIC).  Nothing below
;;;; mentions a program name, a source hash, a fixture identity beyond the
;;;; closed ARM vocabulary, or a domain payload.  If adding a genuinely new
;;;; program required editing this file, the hypothesis under test would have
;;;; failed — so the file is written to make that visible rather than arguable.
;;;;
;;;; ⚠ NO TRUTHINESS PARTICIPATES ANYWHERE IN SELECTION.  A pattern atom holds
;;;; by an exact value-and-standing test and by nothing else; there is no place
;;;; in this file where a facet value is consulted for its generalised boolean.
;;;;
;;;; — FABER (Claude Opus 5, subagent), 2026-08-09

(in-package #:lisp-plus-many-acts0)

;;; ===========================================================================
;;; §1 — the run state.  ONE FLAT NAMESPACE, exactly as the validator checked.
;;; ===========================================================================

(defstruct (%ma0-run (:copier nil))
  (program nil :read-only t)
  (environment nil :read-only t)
  (bindings (make-hash-table :test #'eq) :read-only t)  ; symbol -> (class . value)
  (summaries '()))                                      ; newest first

(defun %ma0-bind (run ident class value)
  (setf (gethash ident (%ma0-run-bindings run)) (cons class value))
  value)

(defun %ma0-lookup (run ident)
  (let ((row (gethash ident (%ma0-run-bindings run))))
    (unless row
      ;; Unreachable through `ma0-validate' (V-BIND is total); kept because an
      ;; evaluator that trusts a checker it cannot re-run is trusting prose.
      (ma0-refuse 'ma0-binding-refused "V-BIND"
                  "identifier ~a is unbound at evaluation"
                  (symbol-name ident)))
    row))

;;; ===========================================================================
;;; §2 — value expressions.
;;; ===========================================================================

(defun %ma0-outcome-axis-value (outcome axis)
  "The (value standing) pair of one closed outcome axis, through Surface /2's
PUBLIC readers and their uniform (values VALUE STANDING) protocol."
  (ecase axis
    (:execution (lisp-plus-surface2:seat-outcome-execution-standing outcome))
    (:provenance (lisp-plus-surface2:seat-outcome-provenance outcome))
    (:evidence-class (lisp-plus-surface2:seat-outcome-evidence-class outcome))))

(defun %ma0-outcome-axis-standing (outcome axis)
  (lisp-plus-surface2:seat-outcome-field-standing
   outcome
   (ecase axis
     (:execution :execution)
     (:provenance :provenance)
     (:evidence-class :evidence-class))))

(defun %ma0-eval-vexpr (run form)
  (cond
    ;; ⚠ R1/D1 — A LITERAL IS OWNED AS IT IS EVALUATED.  `form' here is a node
    ;; of the validated program's retained `:steps'.  Returning the string
    ;; itself would let a program's own value — and then its result payload —
    ;; alias the program text, so a caller mutating a returned payload would
    ;; edit the program that produced it.  Integers and keywords have no
    ;; mutable interior and are returned as they are.
    ((stringp form) (%ma0-own form))
    ((or (integerp form) (keywordp form)) form)
    ((consp form)
     (let ((head (%ma0-head-name form)))
       (cond
         ((equal head "REF") (cdr (%ma0-lookup run (second form))))
         ((equal head "FIELD")
          (let* ((row (%ma0-lookup run (second form)))
                 (outcome (cdr row))
                 (axis (third form))
                 (standing (%ma0-outcome-axis-standing outcome axis)))
            ;; The TYPED ABSENCE is carried, never filled in.  For the three
            ;; closed axes Surface /2 reports :present always (its
            ;; always-present facet list, surface2.lisp:990-991), so this
            ;; branch does not fire today; it exists so that a widened axis set
            ;; cannot silently start substituting NIL for an absence.
            (if (eq standing :present)
                (%ma0-outcome-axis-value outcome axis)
                standing)))
         ((equal head "LIST")
          (mapcar (lambda (sub) (%ma0-eval-vexpr run sub)) (rest form)))
         (t (ma0-refuse 'ma0-source-refused "V-RETRY"
                        "~s is not a lawful value expression" form)))))
    (t (ma0-refuse 'ma0-source-refused "V-DATA"
                   "~s is not a lawful value expression" form))))

;;; ===========================================================================
;;; §3 — the matching law (GRAMMAR §4), mirrored over PUBLIC readers.
;;; ===========================================================================

(defun %ma0-outcome-atom-holds-p (outcome atom)
  "A value-atom holds iff the facet's STANDING is :present AND the facet VALUE
is exactly the pattern value.  An absence-keyword atom holds iff the facet's
standing is exactly that keyword.  Nothing else holds — in particular, a facet
being non-NIL holds nothing."
  (let* ((axis (first atom))
         (pvalue (second atom))
         (standing (%ma0-outcome-axis-standing outcome axis)))
    (if (member pvalue +ma0-absence-keywords+)
        (eq standing pvalue)
        (and (eq standing :present)
             (equal pvalue (%ma0-outcome-axis-value outcome axis))))))

(defun %ma0-act-result-atom-holds-p (summary atom)
  "GRAMMAR §5.2's two axes over an act-result.  Both are present by
construction — this lane builds the summary — so an absence-keyword atom over
an act-result holds NEVER, and says so rather than erroring."
  (let ((axis (first atom)) (pvalue (second atom)))
    (if (member pvalue +ma0-absence-keywords+)
        nil
        (equal pvalue (ecase axis
                        (:disposition (%as-disposition summary))
                        (:class (%as-class summary)))))))

(defun %ma0-atom-holds-p (class value atom)
  (ecase class
    (:outcome (%ma0-outcome-atom-holds-p value atom))
    (:act-result (%ma0-act-result-atom-holds-p value atom))))

(defun %ma0-pattern-holds-p (class value pattern)
  "`:and' holds iff EVERY atom holds.  A single atom is its own conjunction."
  (let ((atoms (if (and (consp pattern) (eq :and (first pattern)))
                   (rest pattern)
                   (list pattern))))
    (every (lambda (atom) (%ma0-atom-holds-p class value atom)) atoms)))

;;; ===========================================================================
;;; §4 — the act step.
;;; ===========================================================================

(defun %ma0-run-act-step (run step)
  "One `act' step.  Returns the act-summary it binds.

W-AUTH-EXPLICIT: the slot's occupancy is retrieved FROM THE ENVIRONMENT, BY
SLOT NAME, HERE, at this step.  An unfilled slot refuses and NO ACT BEGINS —
there is no dynamic variable this function could read instead, and no default
branch that could quietly supply one."
  (let* ((environment (%ma0-run-environment run))
         (ident (second step))
         (arm (second (third step)))
         (slot (second (fourth step))))
    (unless (member arm (%env-arms environment) :test #'string=)
      (ma0-refuse 'ma0-environment-refused "MA0-ENV-ARMS"
                  "the program invokes arm ~s, which this environment does ~
not admit (its declared arms are ~s)" arm (%env-arms environment)))
    (unless (%ma0-slot-occupied-p environment (symbol-name slot) arm)
      (ma0-refuse 'ma0-authority-slot-unfilled "MA0-AUTH-1"
                  "authority slot ~a carries no journaled grant for arm ~s in ~
this environment; the act does not begin"
                  (symbol-name slot) arm))
    ;; ⚠ R1/D4 — THE LAST GATE BEFORE THE ONLY CONSEQUENTIAL STEP.  The run
    ;; entry checked this too; it is checked again HERE because this is the
    ;; line after which a write has happened, and a guard that sits only at the
    ;; door trusts every path between the door and the deed.
    (%ma0-check-environment-current environment "an act step")
    (let* ((fixture (%ma0-fixture-for-arm arm))
           (result (lisp-plus-language-act0:run-act fixture :verbose nil))
           (summary
             (if (eq :unpaired-f1 (getf result :class))
                 ;; ---- THE DECLARED UNPAIRED-F1 SHAPE (act0-gates.lisp:
                 ;; ---- 509-521).  The L3b mint refused BY NAME; F1 is already
                 ;; ---- durable and STANDS ALONE.  ⚠ NO COMPLETION IS
                 ;; ---- ATTEMPTED: there is no Outcome to map, and composing
                 ;; ---- F2..F5 here would forge the readback of an act that
                 ;; ---- never occurred.
                 ;; R1/D1: the summary owns its strings.  `arm' is a node of the
                 ;; program's retained steps and the hex and verdict come from
                 ;; below; a summary that shared them would hand a reader the
                 ;; program text and the composition's own strings.
                 (%make-ma0-act-summary
                  :arm (%ma0-own arm)
                  :act-id-hex (%ma0-own (%ma0-act-id-hex (getf result :record)))
                  :disposition (getf result :disposition)
                  :class (getf result :class)
                  :verdict nil)
                 (let ((done (ma0-complete-act result environment)))
                   (%make-ma0-act-summary
                    :arm (%ma0-own arm)
                    :act-id-hex (%ma0-own (getf done :act-id-hex))
                    :disposition (getf result :disposition)
                    :class (getf done :class)
                    :verdict (%ma0-own (getf done :verdict)))))))
      (push summary (%ma0-run-summaries run))
      (%ma0-bind run ident :act-result summary)
      summary)))

;;; ===========================================================================
;;; §5 — the derive step.  EFFECT-FREE BY CONSTRUCTION.
;;; ===========================================================================

(defun %ma0-run-derive-step (run step)
  "Surface /2 derivation over the store's validated prefix.  Both calls are
pure reads: `validated-store-events' validates and lists, `derive-seat-outcome'
folds.  Neither appends, mints, or writes — which is why W-DERIVE-NE-PERFORM
can be a prefix-length invariant rather than a hope."
  (let* ((environment (%ma0-run-environment run))
         (ident (second step))
         (seatd (second (third step)))
         (declared (if (stringp seatd)
                       seatd
                       (%ma0-eval-vexpr run seatd)))
         (seat (%ma0-resolve-seat environment declared))
         (store (%env-store environment))
         (events (lisp-plus-surface2:validated-store-events store))
         (outcome (lisp-plus-surface2:derive-seat-outcome store events seat)))
    (%ma0-bind run ident :outcome outcome)
    outcome))

;;; ===========================================================================
;;; §6 — steps, branches, terminals.
;;; ===========================================================================
;;;
;;; A terminal is carried out of the walk as a plist (:disposition … ); NIL
;;; means "the sequence did not terminate here".

(defun %ma0-run-steps (run steps)
  (let ((terminal nil))
    (dolist (step steps terminal)
      (setf terminal (%ma0-run-step run step))
      (when terminal (return terminal)))))

(defun %ma0-run-step (run step)
  (let ((head (%ma0-head-name step)))
    (cond
      ((equal head "BIND")
       (%ma0-bind run (second step) :value (%ma0-eval-vexpr run (third step)))
       nil)
      ((equal head "ACT") (%ma0-run-act-step run step) nil)
      ((equal head "DERIVE") (%ma0-run-derive-step run step) nil)
      ((equal head "BRANCH") (%ma0-run-branch run step))
      ((equal head "RESULT")
       (list :disposition :completed
             :value (%ma0-eval-vexpr run (second step))))
      ((equal head "REFUSE")
       (list :disposition :refused
             :code (second (second step))
             :detail (when (= 3 (length step))
                       (%ma0-eval-vexpr run (third step)))))
      (t (ma0-refuse 'ma0-source-refused "V-RETRY"
                     "~s is not a lawful step at evaluation" step)))))

(defun %ma0-run-branch (run step)
  "SELECTION LAW: clauses are tested in TEXTUAL ORDER; the FIRST holding clause
is selected; `otherwise' is selected iff no clause holds; and EXACTLY ONE arm's
steps are evaluated.  The `return-from' below is what makes the last clause a
law rather than an intention — no arm after the selected one is reachable."
  (let* ((row (%ma0-lookup run (second step)))
         (class (car row))
         (value (cdr row))
         (clauses (butlast (cddr step)))
         (other (car (last step))))
    (dolist (clause clauses)
      (when (%ma0-pattern-holds-p class value (first clause))
        (return-from %ma0-run-branch (%ma0-run-steps run (rest clause)))))
    (%ma0-run-steps run (rest other))))

;;; ===========================================================================
;;; §7 — the door.
;;; ===========================================================================

(defun ma0-run-program (program environment)
  "Evaluate a validated PROGRAM under ENVIRONMENT.  Returns an immutable
program-result.

⚠ A REFUSAL IS A LAWFUL OUTCOME; AN ERROR IS NOT AN OUTCOME AT ALL.  A `refuse'
terminal — including one a program branches into after an act-level refusal —
produces disposition `:refused', an orderly return, and an intact journal.
Everything else that interrupts this function from below (an environment
refusal, an adopted-lane condition the program did not branch on, a host fault)
PROPAGATES as a condition and is never converted into `:completed'.  There is
no handler in this function, and its absence is the mechanism."
  (unless (ma0-validated-program-p program)
    (ma0-refuse 'ma0-source-refused "MA0-RUN-1"
                "ma0-run-program takes a validated-program; got ~s"
                (type-of program)))
  (unless (ma0-environment-p environment)
    (ma0-refuse 'ma0-environment-refused "MA0-RUN-2"
                "ma0-run-program takes an ma0-environment; got ~s"
                (type-of environment)))
  ;; ⚠ R1/D4 — BEFORE ANYTHING AT ALL, including binding the inputs.  A stale
  ;; environment is refused at the door, so the zero-footprint claim is a
  ;; property of where this line sits rather than of what the steps happen to
  ;; do.
  (%ma0-check-environment-current environment "ma0-run-program")
  (let ((run (make-%ma0-run :program program :environment environment)))
    ;; ---- inputs: ordinary values, supplied by the environment, flowing
    ;; ---- beside outcomes and touching neither authority nor evidence.
    (dolist (input (%vp-inputs program))
      (%ma0-bind run input :value
                 (%ma0-input-value environment (symbol-name input))))
    (let ((terminal (%ma0-run-steps run (%vp-steps program))))
      (unless terminal
        ;; Unreachable through `ma0-validate' (V-TERM is total).
        (ma0-refuse 'ma0-source-refused "V-TERM"
                    "the program's steps ended without a terminal"))
      ;; R1/D1: the result owns its payload, its refusal detail, its name and
      ;; its store-id.  `ma0-program-name' and `ma0-environment-store-id' each
      ;; already hand back an owned copy, so what is retained here is the
      ;; result's own — not the program's and not the environment's.
      (%make-ma0-result
       :program-name (ma0-program-name program)
       :disposition (getf terminal :disposition)
       :value (%ma0-own (getf terminal :value))
       :refusal-code (getf terminal :code)
       :refusal-detail (%ma0-own (getf terminal :detail))
       :act-summaries (reverse (%ma0-run-summaries run))
       :store-id (ma0-environment-store-id environment)))))
