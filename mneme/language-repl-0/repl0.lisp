;;;; repl0.lisp — REPL /0's SESSION ENGINE (CANDIDATE). UI-independent.
;;;;
;;;; A SESSION is one PROGRAM /0 program frame that outlives a single submission.
;;;; A SUBMISSION is a piece of source text. SUBMIT reads it with PROGRAM /0's reader
;;;; and, when the text is complete, evaluates it with PROGRAM /0's `run-source' in
;;;; the session's frame. Nothing else evaluates anything.
;;;;
;;;; WHAT A SESSION MEANS — the one semantic decision, stated as the language's own:
;;;;   All submissions of a session are evaluated in ONE frame, the program frame that
;;;;   `make-global-environment' returns (the frame a file program runs in). Each
;;;;   submission's successfully read, complete top-level forms are evaluated in order in
;;;;   that same frame by `run-source' — the same `define', closures, lexical scope,
;;;;   shadowing of prelude names, and E-REDEFINE when a name is defined twice in the
;;;;   frame. NO REPL-ONLY SEMANTICS WERE ADDED. This is NOT "the same as one file of
;;;;   the concatenated text" (r3, Astra's AMEND narrowed the r0–r2 claim), because of
;;;;   the submission BOUNDARY and the recovery policy:
;;;;     • each submission is read on its own, before its forms run: a malformed LATER
;;;;       submission leaves EARLIER definitions in place — submit `(define kept 7)',
;;;;       then `)': `kept' stays 7 — whereas run-source on the concatenated text reads
;;;;       all forms first and refuses before evaluating the definition (both witnessed
;;;;       in the selftest). Raw concatenation can also merge tokens or extend a `;'
;;;;       comment unless the submissions are separated;
;;;;     • the step budget and depth limit are per SUBMISSION (run-source binds them per
;;;;       call), so a session is not killed by its accumulated history;
;;;;     • a failed submission does not end the session (a file stops at its error).
;;;;   Persistence therefore needed NO language change. What it does NOT give — and
;;;;   REPL /0 does not invent — is REDEFINITION: `(define x 1)' in one submission and
;;;;   `(define x 2)' in a later one is E-REDEFINE, as it is in a file. A REPL-only
;;;;   rebinding rule (a fresh child frame per submission; or overwrite-in-place) would
;;;;   be a language change: the first makes a closure defined earlier keep seeing the
;;;;   OLD binding and breaks forward reference between submissions; the second breaks
;;;;   "a name is bound once per frame". Named here, not built. `,reset' (CLI) and the
;;;;   Reset button (browser) start a new session explicitly.
;;;;
;;;; WHAT HAPPENS TO STATE WHEN A SUBMISSION FAILS (no rollback is implemented):
;;;;   • reader refusal (malformed text): NOTHING of the submission was evaluated —
;;;;     run-source reads every form before evaluating any. The session is unchanged.
;;;;   • language error during evaluation: every form of the submission BEFORE the
;;;;     failing one took effect and stays (its definitions stay bound); the failing
;;;;     form's own effects up to the failure stay too (e.g. a `define' inside a
;;;;     top-level `begin' that ran before the error); forms after it did not run.
;;;;   • host fault: the same, and the fault is reported as an implementation defect.
;;;;   The session remains usable in every case; the selftest witnesses each.
;;;;
;;;; INCOMPLETE vs MALFORMED is the READER's verdict, not a second parser's: PROGRAM /0's
;;;; reader signals `program0-incomplete-source' (an E-READ subclass, REPL /0 candidate
;;;; change) when the text ends inside a form. Strings, `|…|' escapes, `;' and `#|…|#'
;;;; comments are therefore handled exactly as the reader handles them.
;;;;
;;;; READ-ONLY USE OF FOUR PROGRAM /0 INTERNALS (named so a reviewer can find them):
;;;; `env-table' (to list the names a session bound), `program0-error-source' (the
;;;; source name an error cites), `render-abbrev' (the error
;;;; renderer's own abbreviation, for the "in:"/"within:" fields) and `+error-codes+'
;;;; (the code's one-line explanation). Nothing here writes to any of them.
;;;;
;;;; — Claude Opus 5.5, desktop chair, 2026-09-25

(in-package #:lisp-plus-repl0)

(defparameter +repl0-version+ 0)

(defparameter *max-submission-bytes* 65536
  "The browser server refuses a larger body (413). The engine itself sets no bound on
text length; PROGRAM /0's own source-node bound and budgets apply to what it reads.")

;;; ---------------------------------------------------------------------------
;;; the session
;;; ---------------------------------------------------------------------------

(defstruct (session (:constructor %make-session) (:copier nil))
  (id          "" :read-only t)   ; 8 hex digits, fresh per session
  (generation  1  :read-only t)   ; 1, 2, … within one process (a reset increments it)
  (started     "" :read-only t)   ; local ISO-8601 time the session began
  (env         nil)               ; the PROGRAM /0 program frame — THE state
  (submissions 0))                ; evaluated-or-refused submissions (incomplete excluded)

(defun random-hex (n-bytes)
  "Hex digits from /dev/urandom — never from the Lisp RNG, whose state is predictable."
  (with-open-file (in "/dev/urandom" :element-type '(unsigned-byte 8))
    (with-output-to-string (s)
      (dotimes (i n-bytes) (format s "~(~2,'0x~)" (read-byte in))))))

(defun iso-now ()
  (multiple-value-bind (sec min hour day mon year dow dst-p tz) (get-decoded-time)
    (declare (ignore dow))
    ;; CL's TZ is hours WEST of Greenwich, excluding DST.
    (let* ((offset-hours (- (if dst-p (1- tz) tz)))
           (sign (if (minusp offset-hours) #\- #\+))
           (abs-min (round (* 60 (abs offset-hours)))))
      (format nil "~4,'0d-~2,'0d-~2,'0dT~2,'0d:~2,'0d:~2,'0d~c~2,'0d:~2,'0d"
              year mon day hour min sec sign (floor abs-min 60) (mod abs-min 60)))))

(defun make-session (&key (generation 1))
  (%make-session :id (random-hex 4) :generation generation :started (iso-now)
                 :env (make-global-environment)))

(defun session-names (session)
  "The names the user bound in this session's frame, as the program writes them, sorted.
Prelude and primitive names live in the parent frame and are not listed."
  (let ((names '()))
    (maphash (lambda (sym value) (declare (ignore value))
               (push (string-downcase (symbol-name sym)) names))
             (lisp-plus-program0::env-table (session-env session)))
    (sort names #'string<)))

;;; ---------------------------------------------------------------------------
;;; the result record — one per call to SUBMIT
;;; ---------------------------------------------------------------------------

(defstruct (result (:copier nil))
  (index nil)        ; submission number, or NIL (empty / incomplete)
  (source-name nil)  ; "in[<index>]" — what error locations cite
  (status nil)       ; :value :defined :empty :incomplete :language-error :host-fault :interrupted
  (forms nil)        ; top-level forms read, or NIL
  (value nil)        ; rendered value (for :defined, the rendered name)
  (kind nil)         ; see VALUE-KIND
  (output "")        ; what `print' wrote during this submission
  (error nil)        ; a plist for :language-error (see ERROR-RECORD)
  (fault nil)        ; a plist for :host-fault / :interrupted
  (note nil)         ; a plain sentence for :empty / :incomplete
  (state-note nil)   ; what happened to the session state, on failure
  (elapsed-ms nil))

(defun value-kind (v)
  (cond ((or (eq v :true) (eq v :false)) "boolean")
        ((null v) "empty-list")
        ((realp v) "number")
        ((stringp v) "string")
        ((keywordp v) "keyword")
        ((symbolp v) "symbol")
        ((consp v) "list")
        ((closure-p v) "function")
        ((primitive-p v) "primitive")
        ((refusal-p v) "refusal")
        ((host-value-p v) "host-value")
        (t "host-object")))

(defun error-record (c)
  (let ((loc (program0-error-location c))
        (path (program0-error-path c)))
    (list :code (program0-error-code c)
          :message (program0-error-message c)
          :location (and loc (list :source (lisp-plus-program0::program0-error-source c)
                                   :line (car loc) :column (cdr loc)))
          :in (and path (lisp-plus-program0::render-abbrev (first path)))
          :within (mapcar #'lisp-plus-program0::render-abbrev (rest path))
          :frames (mapcar (lambda (s) (string-downcase (symbol-name s))) (program0-error-frames c))
          :explanation (cdr (assoc (program0-error-code c) lisp-plus-program0::+error-codes+ :test #'string=))
          :text (render-program0-error c))))

(defparameter +state-note-read+
  "Nothing was evaluated: the reader refused the text before any form ran. The session is unchanged.")
(defparameter +state-note-eval+
  "session continues: what ran before the failure stays (nothing is rolled back); what came after it did not run.")

;;; ---------------------------------------------------------------------------
;;; TEXT-STATUS — the reader's verdict on a text, with no evaluation and no counting
;;; ---------------------------------------------------------------------------

(defun text-status (text)
  "→ :incomplete (the text ends inside a form), :empty, :complete or :malformed —
PROGRAM /0's reader's own verdict. Evaluates nothing and changes no session. (Like
every read, it may intern: see the README's limits.)"
  (handler-case (if (read-source-forms text :source-name "<status>") :complete :empty)
    (program0-incomplete-source () :incomplete)
    (error () :malformed)))

;;; ---------------------------------------------------------------------------
;;; SUBMIT — the whole engine
;;; ---------------------------------------------------------------------------

(defun elapsed-ms-since (start)
  (round (* 1000 (- (get-internal-real-time) start)) internal-time-units-per-second))

(defun submit (session text)
  "Read TEXT with PROGRAM /0's reader; if it is complete, evaluate it with PROGRAM /0's
run-source in SESSION's frame. → a RESULT. Every outcome the engine anticipates (a value,
a definition, empty or incomplete text, a language error, an interruption, a host
condition during reading or evaluation) is returned as a record; this is not a promise
that no condition can ever escape (r3: Astra, 'avoid unconditional promises')."
  (let* ((tentative (1+ (session-submissions session)))
         (name (format nil "in[~d]" tentative))
         (start (get-internal-real-time)))
    ;; 1 — the reader's verdict, before anything is evaluated.
    (let ((forms
            (handler-case (read-source-forms text :source-name name)
              (program0-incomplete-source ()
                (return-from submit
                  (make-result :status :incomplete
                               :note "incomplete: the text ends inside a form (an unclosed parenthesis, string, |…| escape or # dispatch); nothing was evaluated")))
              (program0-error (c)
                (setf (session-submissions session) tentative)
                (return-from submit
                  (make-result :index tentative :source-name name :status :language-error
                               :error (error-record c) :state-note +state-note-read+
                               :elapsed-ms (elapsed-ms-since start))))
              (error (c)
                (setf (session-submissions session) tentative)
                (return-from submit
                  (make-result :index tentative :source-name name :status :host-fault
                               :fault (list :type (prin1-to-string (type-of c)) :message (princ-to-string c))
                               :state-note +state-note-read+
                               :elapsed-ms (elapsed-ms-since start)))))))
      (when (null forms)
        (return-from submit
          (make-result :status :empty :forms 0 :note "nothing to evaluate: the text holds only whitespace and comments")))
      ;; 2 — evaluation, in THIS session's frame, through the one evaluator.
      (setf (session-submissions session) tentative)
      (let ((out (make-string-output-stream))
            (result (make-result :index tentative :source-name name :forms (length forms))))
        (handler-case
            (multiple-value-bind (value definedp)
                (let ((*standard-output* out))
                  (run-source text (session-env session) :source-name name))
              (if definedp
                  (setf (result-status result) :defined
                        (result-value result) (render value))
                  (setf (result-status result) :value
                        (result-value result) (render value)
                        (result-kind result) (value-kind value))))
          (program0-error (c)
            (setf (result-status result) :language-error
                  (result-error result) (error-record c)
                  (result-state-note result) +state-note-eval+))
          (sb-sys:interactive-interrupt ()
            (setf (result-status result) :interrupted
                  (result-fault result) (list :type "INTERRUPTED" :message "evaluation interrupted by the user (Ctrl-C)")
                  (result-state-note result) +state-note-eval+))
          (serious-condition (c)
            (setf (result-status result) :host-fault
                  (result-fault result) (list :type (prin1-to-string (type-of c)) :message (princ-to-string c))
                  (result-state-note result) +state-note-eval+)))
        (setf (result-output result) (get-output-stream-string out)
              (result-elapsed-ms result) (elapsed-ms-since start))
        result))))
