;;;; context.lisp — the explicit minting context: a recognizer, never a
;;;; liveness cache.
;;;;
;;;; The minting context holds the lane's ONE piece of private, process-
;;;; local authority: an EQ table of exactly the objects it minted.  Two
;;;; disciplines, both load-bearing:
;;;;
;;;;   EXPLICIT — the context is created explicitly and passed explicitly
;;;;   to every mint and every presentation.  There is no ambient context,
;;;;   no package default, no context-of-last-resort (cap1-context-missing
;;;;   otherwise).  Creating an empty context grants nothing: a fresh
;;;;   context recognizes nothing, and recognition itself never decides
;;;;   liveness.
;;;;
;;;;   RECOGNIZER, NOT CACHE — the table answers exactly one question:
;;;;   "did I mint this very object?"  It stores NO liveness verdicts, NO
;;;;   prefix reports, NO fold results; nothing in it is updated by journal
;;;;   activity, and nothing in it is consulted to SKIP a journal
;;;;   validation.  Every presentation re-validates the journal fresh and
;;;;   checks the object's prefix binding against the CURRENT validated
;;;;   prefix: the context recognizes; the journal decides.  The planted
;;;;   defect :context-as-liveness-cache (mutants.lisp) is the design this
;;;;   file forbids, kept alive in one guarded branch of present.lisp
;;;;   precisely to be killed.
;;;;
;;;; Note on the EQ table and process death: EQ membership is unforgeable
;;;; from public bytes (no serializable value re-enters the table) and it
;;;; cannot survive the process — which is not a limitation but the lane's
;;;; thesis: the key dies with the process; only testimony remains.
;;;;
;;;; — CLAVIGER-II (Claude Fable 5 subagent), 2026-07-29

(in-package #:lisp-plus-capability1)

(defstruct (minting-context
            (:constructor %make-minting-context)
            (:copier nil)
            (:conc-name %minting-context-))
  label           ; string — diagnostic only, never authority
  recognitions    ; EQ hash-table: minted object -> occurrence-id datum
  serial)         ; integer — per-context mint counter (identity, not authority)

(defmethod print-object ((context minting-context) stream)
  (print-unreadable-object (context stream)
    (format stream "minting-context ~a (~a minted)"
            (%minting-context-label context)
            (hash-table-count (%minting-context-recognitions context)))))

(defun make-minting-context (&key (label "unlabeled"))
  "Create an explicit minting context.  LABEL is a diagnostic string carried
into refusals; it is never authority.  The fresh context recognizes nothing."
  (unless (stringp label)
    (error 'cap1-context-missing
           :requirement-id "CAP1-CTX-2"
           :detail "a minting-context label must be a string"))
  (%make-minting-context :label (copy-seq label)
                         :recognitions (make-hash-table :test #'eq)
                         :serial 0))

(defun %check-context (context)
  "The no-ambient-context gate: refuse anything that is not an explicit
minting context.  Called by every mint and every presentation."
  (unless (minting-context-p context)
    (error 'cap1-context-missing
           :requirement-id "CAP1-CTX-1"
           :detail "no explicit minting context was supplied; nothing is ~
                    recognized on ambient authority"))
  context)

(defun minting-context-label (context)
  "The context's diagnostic label, defensively copied."
  (%check-context context)
  (copy-seq (%minting-context-label context)))

(defun minting-context-minted-count (context)
  "How many objects this context has minted (and therefore recognizes)."
  (%check-context context)
  (hash-table-count (%minting-context-recognitions context)))

(defun context-recognizes-p (context object)
  "Did CONTEXT mint this very OBJECT (EQ membership)?  This answers
MINTED-BY-ME and nothing else — recognition is never liveness; a recognized
object can still be refused as stale by the journal at presentation."
  (%check-context context)
  (nth-value 1 (gethash object (%minting-context-recognitions context))))
