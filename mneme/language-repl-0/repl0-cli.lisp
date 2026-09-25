;;;; repl0-cli.lisp — REPL /0's command-line client (CANDIDATE).
;;;;
;;;; A terminal loop over the session engine: read a line, append it to the pending
;;;; text, ask the engine. If the READER says the text ends inside a form, prompt for
;;;; more; otherwise print the result and start a fresh submission.
;;;;
;;;; SESSION CONTROLS begin with a comma, because a comma outside a backquote is never
;;;; valid Lisp+ (the reader refuses it), so a control can never shadow a program:
;;;;   ,help    list the controls            ,names   the names bound in this session
;;;;   ,reset   start a NEW session (all bindings cleared; the new id is printed)
;;;;   ,cancel  discard the unfinished text you are typing (works mid-form too)
;;;;   ,quit    leave                        Ctrl-D (end of input) also leaves
;;;; A control is recognised only as a WHOLE line (surrounding blanks ignored), and —
;;;; except `,cancel' — only at a fresh prompt. MID-FORM, `,cancel' is a control only
;;;; where the READER would read that comma as code (where a lone comma is always an
;;;; error): inside an open string, `|…|' escape or `#|…|#' comment the line is the
;;;; program's text and is kept. (r1, 2026-09-25: r0 discarded a `,cancel' line inside a
;;;; multi-line string — a control shadowed a program; suspected by CALIPER's code read,
;;;; reproduced by the chair.) At end of input an unfinished form is DISCARDED and
;;;; reported, never evaluated.
;;;;
;;;; Everything goes to standard output, in order (the program's `print' output, then
;;;; the value or the diagnostic), so a transcript reads top to bottom. When standard
;;;; input is not a terminal, each input line is echoed after its prompt, so a piped
;;;; session's transcript shows what was typed.

(in-package #:lisp-plus-repl0)

(defparameter +cli-help+
  "controls (a whole line starting with a comma; never Lisp+):
  ,help    this list
  ,names   the names bound in this session
  ,reset   start a NEW session — every binding is cleared; the new session id is printed
  ,cancel  discard the unfinished text you are typing (inside an open string or
           comment it is text; close the string first, or press Ctrl-D)
  ,quit    leave (Ctrl-D does too)
input: type Lisp+ forms; a form may span lines — the prompt changes to ..> until the
reader has a complete form. Several forms on one line are one submission; its value is
the last form's, as in a file. Errors never end the session.")

(defun stdin-is-terminal-p ()
  (handler-case (eql 1 (sb-unix:unix-isatty 0))
    (error () nil)))

(defun trim (s) (string-trim '(#\Space #\Tab #\Return) s))

(defun print-result (r stream)
  (let ((out (result-output r)))
    (when (plusp (length out))
      (write-string out stream)
      (unless (char= (char out (1- (length out))) #\Newline) (terpri stream))))
  (ecase (result-status r)
    (:value (format stream "=> ~a~%" (result-value r)))
    (:defined (format stream "; defined ~a~%" (result-value r)))
    (:empty nil)
    (:incomplete nil)
    (:language-error
     (format stream "~a~%; ~a~%" (getf (result-error r) :text) (result-state-note r)))
    (:host-fault
     (format stream "lisp-plus: HOST FAULT (a defect of the implementation, not of your program): ~a: ~a~%; ~a~%"
             (getf (result-fault r) :type) (getf (result-fault r) :message) (result-state-note r)))
    (:interrupted
     (format stream "; ~a~%; ~a~%" (getf (result-fault r) :message) (result-state-note r))))
  (finish-output stream))

(defun banner (session stream)
  (format stream "Lisp+ REPL /0 (candidate) — PROGRAM /0 on SBCL ~a · session ~a (generation ~d)~%~
                  Type Lisp+ forms. ,help for controls; Ctrl-D or ,quit to leave.~%"
          (lisp-implementation-version) (session-id session) (session-generation session))
  (finish-output stream))

(defun run-cli (&key (in *standard-input*) (out *standard-output*) (echo (not (stdin-is-terminal-p))))
  "The loop. → exit code 0 (the session ended by the user or by end of input)."
  (let* ((session (make-session))
         (pending '()))              ; lines of the unfinished submission, newest first
    (banner session out)
    (flet ((prompt ()
             (if pending
                 (format out "   ..> ")
                 (format out "in[~d]> " (1+ (session-submissions session))))
             (finish-output out))
           (pending-text () (format nil "~{~a~^~%~}" (reverse pending))))
      (loop
        (prompt)
        (let ((line (handler-case (read-line in nil nil)
                      (sb-sys:interactive-interrupt ()
                        (format out "~&; interrupted — the unfinished text was discarded~%")
                        (setf pending '())
                        :interrupted))))
          (cond
            ((eq line :interrupted))
            ((null line)                                   ; end of input
             (when pending
               (format out "~&; end of input inside an unfinished form — ~d line~:p discarded, NOT evaluated~%"
                       (length pending)))
             (format out "~&; bye (session ~a, ~d submission~:p)~%" (session-id session) (session-submissions session))
             (finish-output out)
             (return 0))
            (t
             (when echo (write-line line out))
             (let ((control (trim line)))
               (cond
                 ;; ,cancel works mid-form — but only where the reader would read the
                 ;; comma as CODE; inside an open string/escape/comment it is text
                 ((and (string= control ",cancel")
                       (or (null pending)
                           (not (eq (text-status (format nil "~a~%~a" (pending-text) line)) :incomplete))))
                  (format out "; ~:[nothing to cancel~;unfinished text discarded~]~%" pending)
                  (setf pending '()))
                 ((and (null pending) (plusp (length control)) (char= (char control 0) #\,))
                  (cond ((string= control ",quit")
                         (format out "; bye (session ~a, ~d submission~:p)~%" (session-id session) (session-submissions session))
                         (finish-output out)
                         (return 0))
                        ((string= control ",help") (format out "~a~%" +cli-help+))
                        ((string= control ",names")
                         (format out "; bound in session ~a: ~:[(none)~;~:*~{~a~^ ~}~]~%"
                                 (session-id session) (session-names session)))
                        ((string= control ",reset")
                         (let ((old (session-id session)))
                           (setf session (make-session :generation (1+ (session-generation session))))
                           (format out "; RESET: session ~a ended; new session ~a (generation ~d) — every binding is cleared~%"
                                   old (session-id session) (session-generation session))))
                        (t (format out "; unknown control ~a — ,help lists them (a line starting with a comma is never Lisp+)~%" control))))
                 (t
                  (push line pending)
                  (let ((r (submit session (pending-text))))
                    (unless (eq (result-status r) :incomplete)
                      (setf pending '())
                      (print-result r out))))))))
          (finish-output out))))))
