;;;; repl0-selftest.lisp — REPL /0's focused checks (CANDIDATE).
;;;;
;;;;   bash mneme/language-repl-0/run-selftest.sh     (exit 0 iff every check passed)
;;;;
;;;; One line per check, then "repl0 selftest: N passed, M failed". The commission's
;;;; named behaviours are tested by name: persistence, closure capture across
;;;; submissions, multiline input, error recovery, EOF — and the check that would
;;;; expose an accidental reset of the environment between submissions, run once on
;;;; the real engine (must PASS) and once on a planted resetting engine (must FAIL).
;;;; Every check prints itself; the harness counts what it printed, and the final
;;;; line is cross-checked against that count.

(require :sb-bsd-sockets)
(defparameter cl-user::*repl0-here* (make-pathname :name nil :type nil :defaults *load-truename*))
(let ((*standard-output* *error-output*))
  (load (merge-pathnames "../kernel0/load.lisp" cl-user::*repl0-here*))
  (load (merge-pathnames "../language-program-0/package.lisp" cl-user::*repl0-here*))
  (load (merge-pathnames "../language-program-0/program0.lisp" cl-user::*repl0-here*))
  (load (merge-pathnames "package.lisp" cl-user::*repl0-here*))
  (load (merge-pathnames "repl0.lisp" cl-user::*repl0-here*))
  (load (merge-pathnames "repl0-cli.lisp" cl-user::*repl0-here*))
  (load (merge-pathnames "repl0-web.lisp" cl-user::*repl0-here*)))

(defpackage #:repl0-selftest (:use #:cl #:lisp-plus-repl0))
(in-package #:repl0-selftest)

(defvar *passed* 0)
(defvar *failed* 0)
(defvar *lines* 0)
(defvar *report* *standard-output*)   ; checks write HERE, never to a rebound *standard-output*

(defun check (ok name &optional detail)
  (if ok (incf *passed*) (incf *failed*))
  (incf *lines*)
  (format *report* "~:[FAIL~;ok  ~] ~a~@[  — ~a~]~%" ok name (unless ok detail))
  (finish-output *report*)
  ok)

(defun sub (s text) (submit s text))
(defun st (r) (result-status r))
(defun val (r) (result-value r))
(defun code (r) (getf (result-error r) :code))
(defun bound-p (s name) (and (member name (session-names s) :test #'string=) t))

(format *report* "~&== REPL /0 selftest (SBCL ~a) ==~%" (lisp-implementation-version))

;;; ---- 1. persistence across submissions ---------------------------------------
(let ((s (make-session)))
  (check (eq (st (sub s "(define x 41)")) :defined) "a top-level define is a :defined result")
  (sub s "(+ 1 1)")
  (let ((r (sub s "(+ x 1)")))
    (check (and (eq (st r) :value) (string= (val r) "42")) "a binding made two submissions ago is visible" (val r)))
  (check (equal (session-names s) '("x")) "the session lists exactly the user's names" (session-names s))
  (check (= (session-submissions s) 3) "three submissions counted" (session-submissions s)))

;;; ---- 2. closure capture across submissions ------------------------------------
(let ((s (make-session)))
  (sub s "(define (make-adder n) (lambda (k) (+ k n)))")
  (sub s "(define add5 (make-adder 5))")
  (sub s "(define add10 (make-adder 10))")
  (let ((r (sub s "(list (add5 1) (add10 1))")))
    (check (string= (val r) "(6 11)") "closures made in one submission, called in a later one, keep their own n" (val r)))
  (sub s "(define base 100)")
  (sub s "(define (from-base k) (+ base k))")
  (let ((r (sub s "(map from-base (list 1 2))")))
    (check (string= (val r) "(101 102)") "a function captures a binding from an earlier submission" (val r)))
  (sub s "(define counter-start (let ((seed 7)) (lambda () seed)))")
  (check (string= (val (sub s "(counter-start)")) "7") "a closure over a let-bound value survives into a later submission")
  ;; forward reference between submissions — the same frame makes it work, as in a file
  (sub s "(define (uses-later) (later-helper 3))")
  (sub s "(define (later-helper z) (* z z))")
  (check (string= (val (sub s "(uses-later)")) "9")
         "a function may call a name defined in a LATER submission (one frame, as in a file)"))

;;; ---- 3. multiline input and several forms per submission ----------------------
(let ((s (make-session)))
  (let ((r (sub s (format nil "(define (fact n)~%  (if (= n 0)~%      1~%      (* n (fact (- n 1)))))"))))
    (check (eq (st r) :defined) "a multi-line definition is one submission"))
  (check (string= (val (sub s "(fact 10)")) "3628800") "and it works")
  (let ((r (sub s "(define a 1) (define b 2) (+ a b)")))
    (check (and (string= (val r) "3") (eql (result-forms r) 3)) "several forms in one submission: 3 read, the last one's value" (val r)))
  (let ((r (sub s (format nil "; a comment line~%(+ 1 ; inline~%   2)"))))
    (check (string= (val r) "3") "comments are the reader's: ; lines and inline ; inside a multi-line form"))
  (let ((r (sub s "(string-append \"(\" \";\" \"|\")")))
    (check (string= (val r) "\"(;|\"") "a string holding ( ; | is complete, not incomplete" (val r))))

;;; ---- 4. incomplete vs malformed — the reader's own verdict --------------------
(let ((s (make-session)))
  (let ((r (sub s "(define d")))
    (check (eq (st r) :incomplete) "an unclosed form is :incomplete")
    (check (= (session-submissions s) 0) "an incomplete text is not a submission"))
  (check (eq (st (sub s "(print \"abc")) :incomplete) "an unclosed string is :incomplete")
  (check (eq (st (sub s "(list a|b")) :incomplete) "an unclosed |…| escape is :incomplete")
  (check (eq (st (sub s "(+ 1 2) #| still open")) :incomplete) "an unclosed #| comment is :incomplete")
  (check (eq (st (sub s (format nil "(define d~%  4)"))) :defined) "the same text completed on a second line is evaluated")
  (let ((r (sub s "(+ 1 2))")))
    (check (and (eq (st r) :language-error) (string= (code r) "E-READ")) "a stray ) is malformed: E-READ, not incomplete"))
  (check (eq (st (sub s "   ")) :empty) "blank text is :empty, nothing evaluated")
  (check (eq (st (sub s "; only a comment")) :empty) "a comment-only text is :empty"))

;;; ---- 5. error recovery and what happens to state ------------------------------
(let ((s (make-session)))
  (sub s "(define keep 1)")
  (let ((r (sub s "(car 5)")))
    (check (and (eq (st r) :language-error) (string= (code r) "E-TYPE")) "an evaluator error is a language error with its code")
    (check (equal (getf (getf (result-error r) :location) :source) "in[2]") "its location cites the submission, in[2]"
           (getf (result-error r) :location)))
  (check (string= (val (sub s "(+ keep 1)")) "2") "the next submission succeeds in the same session")
  ;; forms before the failing one stay; forms after it do not run
  (sub s "(define before 1) (car 5) (define after 2)")
  (check (and (bound-p s "before") (not (bound-p s "after")))
         "forms before the failing one keep their effects; forms after it did not run" (session-names s))
  ;; the failing form's own effects up to the failure stay (a define inside a top-level begin)
  (sub s "(begin (define inside 1) (car 5))")
  (check (bound-p s "inside") "a failing top-level begin keeps the define it made before failing (no rollback)")
  ;; a reader refusal evaluates nothing
  (sub s "(define never 3) (1 . )")
  (check (not (bound-p s "never")) "a reader refusal evaluates NOTHING of the submission")
  ;; E-REDEFINE: the language's rule, unchanged
  (let ((r (sub s "(define keep 99)")))
    (check (string= (code r) "E-REDEFINE") "redefining a session name is E-REDEFINE, as in a file (no REPL-only rebinding)"))
  (check (string= (val (sub s "keep")) "1") "and the old binding is untouched")
  ;; per-submission budget
  (sub s "(define (spin n) (spin (+ n 1)))")
  (let ((r (sub s "(spin 0)")))
    (check (string= (code r) "E-BUDGET") "a runaway recursion is E-BUDGET, not a host crash"))
  (check (string= (val (sub s "(+ keep 2)")) "3") "the session is usable after a budget refusal")
  (let ((r (sub s "(print \"partial\") (car 5)")))
    (check (and (search "partial" (result-output r)) (eq (st r) :language-error))
           "output printed before an error is kept and reported with it")))

;;; ---- 6. the language boundary --------------------------------------------------
(let ((s (make-session)))
  (check (string= (code (sub s "(eval 1)")) "E-UNBOUND") "`eval' is an ordinary unbound name, not the host's")
  ;; 2026-09-30 (RALLY, Astra's dossier-r0 disposition): these two checks accepted E-SYNTAX OR E-READ.
  ;; PROGRAM /0 spec §1 "Foreign symbols" / "Host packages are not written by reading": an EXISTING
  ;; foreign symbol is read and refused at source validation, E-SYNTAX; only a name the host LACKS is
  ;; E-READ. So each check first confirms the symbol exists (external), then asserts the exact code.
  (let ((exists (eq (nth-value 1 (find-symbol "EVAL" "COMMON-LISP")) :external))
        (c (code (sub s "(cl:eval 1)"))))
    (check (and exists (equal c "E-SYNTAX"))
           "an existing cl: symbol (cl:eval) is refused E-SYNTAX at source validation (spec §1), not E-READ" (list exists c)))
  (check (string= (code (sub s "#.(sb-ext:quit)")) "E-READ") "#. is dead at the reader (and this test process is still alive)")
  (let ((exists (eq (nth-value 1 (find-symbol "QUIT" "SB-EXT")) :external))
        (c (code (sub s "(sb-ext:quit)"))))
    (check (and exists (equal c "E-SYNTAX"))
           "an existing host symbol by package prefix (sb-ext:quit) is refused E-SYNTAX (spec §1), not E-READ" (list exists c)))
  (check (string= (code (sub s "(perform 1)")) "E-UNBOUND") "effect operators are absent (nothing that performs is loaded)")
  (check (null (find-package "LISP-PLUS-CORE0")) "no effect lane is in the image"))

;;; ---- 7. output and values are distinct -----------------------------------------
(let ((s (make-session)))
  (let ((r (sub s "(print \"hello\" 1) 2")))
    (check (and (string= (result-output r) (format nil "hello 1~%")) (string= (val r) "2"))
           "print's text is output; the value is separate" (list (result-output r) (val r)))))

;;; ---- 8. host faults are distinguishable from program errors ------------------
(let ((s (make-session)))
  (let ((good-env (session-env s)))
    (setf (session-env s) :not-an-environment)      ; a PLANTED implementation defect
    (let ((r (sub s "(+ 1 2)")))
      (check (eq (st r) :host-fault) "a defect of the implementation is :host-fault, not :language-error" (st r)))
    (setf (session-env s) good-env)
    (check (string= (val (sub s "(+ 1 2)")) "3") "and the session continues once the defect is removed")))

;;; ---- 9. THE RESET DETECTOR, with teeth -----------------------------------------
;;; A sentinel with an unguessable value is defined in submission 1; five ordinary
;;; submissions follow; then (a) the sentinel must read back its value and (b) redefining
;;; it must be E-REDEFINE — (b) distinguishes "same frame" from "a fresh frame that
;;; happens to hold a copy". Run on the real engine (PASS) and on a planted engine that
;;; resets the environment before each submission (must FAIL).
(defun reset-detector (submit-fn session)
  (let ((token (lisp-plus-repl0::random-hex 6)))
    (funcall submit-fn session (format nil "(define sentinel ~s)" token))
    (dotimes (i 5) (funcall submit-fn session (format nil "(+ ~d 1)" i)))
    (let ((back (funcall submit-fn session "sentinel"))
          (again (funcall submit-fn session "(define sentinel 0)")))
      (and (eq (result-status back) :value)
           (string= (result-value back) (format nil "~s" token))
           (equal (getf (result-error again) :code) "E-REDEFINE")))))

(check (reset-detector #'submit (make-session)) "RESET DETECTOR on the real engine: state kept across 7 submissions")
(let ((planted (lambda (session text)
                 (setf (session-env session) (lisp-plus-program0:make-global-environment)) ; the accidental reset
                 (submit session text))))
  (check (not (reset-detector planted (make-session)))
         "RESET DETECTOR on a planted resetting engine: FAILS, as it must (the check has teeth)"))

;;; ---- 10. one account: complete forms, in order, in one frame (r3: NOT "= the concatenated file") ----
(let* ((texts '("(define (sq x) (* x x))" "(define xs (range 1 6))" "(define total (fold + 0 (map sq xs)))" "(list total (length xs))"))
       (s (make-session))
       (last-r nil))
  (dolist (tx texts) (setf last-r (sub s tx)))
  (let ((file-value (lisp-plus-program0:render
                     (lisp-plus-program0:run-source (format nil "~{~a~%~}" texts) (lisp-plus-program0:make-global-environment)))))
    (check (string= (val last-r) file-value) "four well-formed submissions give what the same four forms give as one file"
           (list (val last-r) file-value))))
;; r3, Astra's parsing-boundary example: the equivalence is NOT unconditional.
(let ((s (make-session)))
  (sub s "(define kept 7)")
  (let ((r (sub s ")")))
    (check (string= (code r) "E-READ") "boundary: a later malformed submission is E-READ"))
  (check (string= (val (sub s "kept")) "7") "boundary: …and the EARLIER definition stays (the session reads per submission)"))
(let ((env (lisp-plus-program0:make-global-environment)))
  (let ((c (handler-case (progn (lisp-plus-program0:run-source (format nil "(define kept 7)~%)") env) nil)
             (lisp-plus-program0:program0-error (e) e))))
    (check (and c (string= (lisp-plus-program0:program0-error-code c) "E-READ")) "boundary: the concatenated FILE is refused at read")
    (check (handler-case (progn (lisp-plus-program0:run-source "kept" env) nil)
             (lisp-plus-program0:program0-error (e) (string= (lisp-plus-program0:program0-error-code e) "E-UNBOUND")))
           "boundary: …and the file evaluated nothing (kept is unbound there) — the two differ, as the README now says")))

;;; ---- 11. the command-line client: multiline, controls, EOF --------------------
(defun cli (input)
  (with-output-to-string (out)
    (with-input-from-string (in input)
      (lisp-plus-repl0::run-cli :in in :out out :echo t))))

(let ((o (cli (format nil "(define (twice f)~%  (lambda (x) (f (f x))))~%((twice (lambda (n) (* n 3))) 2)~%"))))
  (check (search "   ..> " o) "CLI: a multi-line form gets the continuation prompt")
  (check (search "=> 18" o) "CLI: and evaluates when complete" o))
(let ((o (cli (format nil "(define kept 5)~%(car 5)~%(+ kept 1)~%"))))
  (check (and (search "E-TYPE at in[2]:1:0" o) (search "=> 6" o)) "CLI: an error, then the next form works in the same session" o))
(let ((o (cli (format nil "(define half 1)~%(print 4242~%"))))
  (check (search "discarded, NOT evaluated" o) "CLI: EOF inside an unfinished form reports the discard")
  (check (not (search (format nil "~%4242") o)) "CLI: and the unfinished form did NOT run" o)
  (check (search "; bye" o) "CLI: EOF exits cleanly"))
(let ((o (cli (format nil "(define r 1)~%,names~%,reset~%r~%"))))
  (check (search "bound in session" o) "CLI: ,names lists the session's names")
  (check (search "RESET: session" o) "CLI: ,reset announces the new session")
  (check (search "E-UNBOUND" o) "CLI: after ,reset the old binding is gone (the reset is explicit and real)" o))
(let ((o (cli (format nil "(list 1~%,cancel~%(+ 2 2)~%"))))
  (check (and (search "unfinished text discarded" o) (search "=> 4" o)) "CLI: ,cancel discards an unfinished form mid-input" o))
(let ((o (cli (format nil ",frobnicate~%(+ 1 1)~%"))))
  (check (and (search "unknown control" o) (search "=> 2" o)) "CLI: an unknown control is refused and never reaches Lisp+" o))
(let ((o (cli (format nil ",quit~%(+ 1 1)~%"))))
  (check (and (search "; bye" o) (not (search "=> 2" o))) "CLI: ,quit leaves at once" o))

;;; ---- 11b. r1: a control never shadows a program (CALIPER's suspicion, reproduced) ----
(let ((o (cli (format nil "(print \"a~%,cancel~%b\")~%"))))
  (check (and (search (format nil "a~%,cancel~%b~%") o) (not (search "unfinished text discarded" o)))
         "CLI r1: a ,cancel line INSIDE a multi-line string is the program's text, as in a file" o))
(let ((o (cli (format nil "(list 1~%,cancel~%(+ 2 2)~%"))))
  (check (and (search "unfinished text discarded" o) (search "=> 4" o)) "CLI r1: mid-FORM (comma would be code) ,cancel still discards" o))
(let ((o (cli (format nil "(list |a~%,cancel~%b|)~%"))))
  (check (not (search "unfinished text discarded" o)) "CLI r1: inside an open |…| escape ,cancel is text" o))
(check (equal (mapcar #'lisp-plus-repl0::text-status '("(a" "(a)" "" ")" "\"x")) '(:incomplete :complete :empty :malformed :incomplete))
       "text-status: the reader's verdict, with no evaluation")
(let ((s (make-session)))
  (lisp-plus-repl0::text-status "(define never-counted 1)")
  (check (and (= (session-submissions s) 0) (not (bound-p s "never-counted"))) "text-status evaluates nothing and counts nothing"))

;;; ---- 12. the JSON encoder the browser depends on -------------------------------
(check (string= (lisp-plus-repl0::to-json (list :obj "s" (format nil "a\"b\\c~%d~c" (code-char 1)) "n" 3 "z" :null))
                "{\"s\":\"a\\\"b\\\\c\\nd\\u0001\",\"n\":3,\"z\":null}")
       "JSON: quotes, backslashes, newlines and control characters are escaped")
(check (string= (lisp-plus-repl0::to-json (string (code-char #x1F600))) "\"\\ud83d\\ude00\"")
       "JSON: a character outside the BMP becomes a surrogate pair")

;;; ---- 13. the reader seam through the REPL engine (2026-09-29) --------------------
;;; PROGRAM /0's reader now locks every host package for the extent of each read, so a
;;; package-qualified NEW name is refused (E-READ) before it is interned. The engine path is
;;; where the mutation used to accumulate for the life of the process. (Claude Opus 5.5)
(defun present-in-cl-user-p (name)
  (and (member (nth-value 1 (find-symbol name "CL-USER")) '(:internal :external)) t))
(defun cl-user-count ()
  (let ((n 0)) (do-symbols (s "CL-USER") (when (eq (symbol-package s) (find-package "CL-USER")) (incf n))) n))
(let* ((s (make-session)) (before (cl-user-count))
       (codes (loop for i below 50
                    collect (let ((r (sub s (format nil "(cl-user::zzq-repl-seam-~d ~d)" i i))))
                              (list (st r) (code r))))))
  (check (and (every (lambda (c) (equal c '(:language-error "E-READ"))) codes)
              (= before (cl-user-count))
              (string= (val (sub s "(+ 1 2)")) "3"))
         "seam: fifty distinct refused submissions are E-READ, add no symbol to CL-USER, and the session goes on"
         (list (remove-duplicates codes :test #'equal) before (cl-user-count))))
(let ((s (make-session)))
  (let ((r (sub s "(list cl-user::zzq-repl-seam-unfinished")))
    (check (and (eq (st r) :language-error) (string= (code r) "E-READ") (= (session-submissions s) 1)
                (not (present-in-cl-user-p "ZZQ-REPL-SEAM-UNFINISHED")))
           "seam (disclosed change 3): unfinished text naming a NEW host symbol is refused E-READ on that line, counted, not interned"
           (list (st r) (code r) (session-submissions s))))
  (check (eq (st (sub s "(list cl-user::*repl0-here*")) :incomplete)
         "seam: unfinished text naming an EXISTING host symbol is still :incomplete"))
(check (and (eq (lisp-plus-repl0::text-status "(list cl-user::zzq-repl-seam-status") :malformed)
            (not (present-in-cl-user-p "ZZQ-REPL-SEAM-STATUS")))
       "seam: text-status (the CLI's ,cancel test) interns nothing either")
(let ((o (cli (format nil "(list 1~%  cl-user::zzq-repl-seam-cli~%(+ 1 2)~%"))))
  (check (and (search "E-READ at in[1]:1:0" o) (search "=> 3" o) (not (search "discarded" o)))
         "seam, CLI: the refusal comes on the line that names the new host symbol, and the next form runs" o))

;;; ---- 14. #S through the REPL engine (2026-09-29) ------------------------------------
;;; An active #S is refused by PROGRAM /0's reader before any host constructor runs. The
;;; witness counts constructions through a slot initform. (Claude Opus 5.5)
(defvar *repl-sharp-s-constructed* 0)
(defstruct repl-sharp-s-witness (seen (incf *repl-sharp-s-constructed*)))
(let ((s (make-session)))
  (sub s "(define kept 7)")
  (let* ((before *repl-sharp-s-constructed*)
         (r (sub s "#s(repl0-selftest::repl-sharp-s-witness)"))
         (constructed (- *repl-sharp-s-constructed* before)))
    (check (and (eq (st r) :language-error) (string= (code r) "E-READ")
                (search "structure syntax is not part of this language" (getf (result-error r) :message))
                (= constructed 0))
           "#S through submit: refused E-READ and the constructor witness stays 0"
           (format nil "~s ~s; constructor witness ran ~d time~:p" (st r) (code r) constructed)))
  (let ((r1 (sub s "kept")) (r2 (sub s "(define later (+ kept 1))")) (r3 (sub s "later")))
    (check (and (string= (val r1) "7") (eq (st r2) :defined) (string= (val r3) "8"))
           "#S: the submissions after the refusal work, and the earlier binding is intact"
           (list (val r1) (st r2) (val r3)))))
(let* ((before *repl-sharp-s-constructed*)
       (o (cli (format nil "(list 1~%  #s(repl0-selftest::repl-sharp-s-witness)~%(+ 1 2)~%")))
       (constructed (- *repl-sharp-s-constructed* before)))
  (check (and (search "E-READ at in[1]:1:0" o) (search "=> 3" o) (= constructed 0))
         "#S, CLI: refused on the line that holds it (no longer incomplete), nothing constructed, and the next form runs"
         (format nil "constructed ~d; ~a" constructed o)))

;;; ===========================================================================================
;;; §15–§20 (2026-09-30): the REPL /0 gap checks asked for by Astra's disposition of promotion
;;; dossier r0 (Q1 (b): checks in the lane suites; production bytes unchanged). Written by RALLY
;;; (Claude Opus 5.5, subagent of the laptop chair). Where the README / WEB-API-0.md is silent,
;;; nothing below takes the implementation's output as the expectation.
;;; ===========================================================================================

;;; ---- helpers for §15–§20 --------------------------------------------------------------------

(defmacro with-planted ((fname wrapper) &body body)
  "FAULT INJECTION, test-only and in this process: for the extent of BODY, FNAME's global
definition becomes (apply WRAPPER original args); the original function object is restored
afterwards, whatever happens. No file is changed."
  (let ((orig (gensym "ORIGINAL")) (w (gensym "WRAPPER")))
    `(let ((,orig (fdefinition ',fname)) (,w ,wrapper))
       (unwind-protect
            (progn (setf (fdefinition ',fname) (lambda (&rest args) (apply ,w ,orig args)))
                   ,@body)
         (setf (fdefinition ',fname) ,orig)))))

(defun planted-lookup (trigger action)
  "A wrapper for PROGRAM /0's env-lookup: looking up the one name TRIGGER runs ACTION (the planted
defect); every other lookup is the original's. So a planted fault fires in the middle of an
evaluation, after the forms before it have run, and nowhere else."
  (lambda (original env sym)
    (if (and (symbolp sym) (string= (symbol-name sym) trigger))
        (funcall action)
        (funcall original env sym))))
(defun plant-host-error () (error "a PLANTED implementation defect (repl0-selftest fault injection)"))
(defun plant-interrupt () (error 'sb-sys:interactive-interrupt))
(defun plant-server-defect (original &rest args)
  (declare (ignore original args))
  (error "a PLANTED server defect (repl0-selftest fault injection)"))

(defun json-read (text)
  "A small JSON reader for this file's assertions only: objects → (:obj (key . value) …), arrays →
(:arr …), true/false/null → :true/:false/:null, integers, and strings with the escapes the server
writes. Anything else is an error, so a malformed answer FAILS its check instead of passing it."
  (let ((i 0) (n (length text)))
    (labels ((peek () (if (< i n) (char text i) nil))
             (next () (if (< i n) (prog1 (char text i) (incf i)) (error "json-read: unexpected end")))
             (ws () (loop while (and (< i n) (member (char text i) '(#\Space #\Tab #\Newline #\Return))) do (incf i)))
             (expect (c) (ws) (unless (eql (peek) c) (error "json-read: expected ~c at ~d" c i)) (incf i))
             (word (w v)
               (unless (and (<= (+ i (length w)) n) (string= w text :start2 i :end2 (+ i (length w))))
                 (error "json-read: bad literal at ~d" i))
               (incf i (length w)) v)
             (str ()
               (expect #\")
               (with-output-to-string (o)
                 (loop (let ((c (next)))
                         (cond ((char= c #\") (return))
                               ((char= c #\\)
                                (let ((e (next)))
                                  (case e
                                    (#\n (write-char #\Newline o)) (#\r (write-char #\Return o)) (#\t (write-char #\Tab o))
                                    (#\u (write-char (code-char (parse-integer text :start i :end (+ i 4) :radix 16)) o)
                                     (incf i 4))
                                    (t (write-char e o)))))
                               (t (write-char c o)))))))
             (num ()
               (let ((start i))
                 (when (eql (peek) #\-) (incf i))
                 (loop while (and (< i n) (digit-char-p (char text i))) do (incf i))
                 (parse-integer text :start start :end i)))
             (val ()
               (ws)
               (case (peek)
                 (#\{ (incf i) (ws)
                  (if (eql (peek) #\}) (progn (incf i) (list :obj))
                      (let ((pairs '()))
                        (loop (ws)
                              (let ((k (str))) (expect #\:) (push (cons k (val)) pairs))
                              (ws)
                              (case (next)
                                (#\, nil)
                                (#\} (return (cons :obj (nreverse pairs))))
                                (t (error "json-read: bad object at ~d" i)))))))
                 (#\[ (incf i) (ws)
                  (if (eql (peek) #\]) (progn (incf i) (list :arr))
                      (let ((items '()))
                        (loop (push (val) items)
                              (ws)
                              (case (next)
                                (#\, nil)
                                (#\] (return (cons :arr (nreverse items))))
                                (t (error "json-read: bad array at ~d" i)))))))
                 (#\" (str))
                 (#\t (word "true" :true))
                 (#\f (word "false" :false))
                 (#\n (word "null" :null))
                 (t (num)))))
      (prog1 (val) (ws) (unless (= i n) (error "json-read: trailing text at ~d" i))))))
(defun json-or-nil (text) (ignore-errors (json-read text)))
(defun jget (obj &rest keys)
  "Follow KEYS through nested JSON objects. → (values value present-p)."
  (let ((v obj))
    (dolist (k keys (values v t))
      (let ((pair (and (consp v) (eq (car v) :obj) (assoc k (cdr v) :test #'equal))))
        (unless pair (return (values nil nil)))
        (setf v (cdr pair))))))
(defun jstr-p (x) (and (stringp x) (plusp (length x))))

;;; ---- 15. G-A: recovery for EACH of the nine error codes ---------------------------------------
;;; Astra (disposition of dossier r0, Q2): for each code, "REPL recovery with the exact code, a later
;;; successful submission, and an earlier binding still answering in the same session". One session,
;;; three earlier definitions; each row submits a text that raises its code (the exact string, never a
;;; member of a set), then the probe (one-arg anchor) must answer 42: a successful submission that
;;; reads two EARLIER bindings. E-SYNTAX has two rows: raised by the evaluator (a special form as a
;;; name) and at source validation (an existing foreign symbol, spec §1), because the engine catches
;;; the two in different clauses (repl0.lisp:191 and :221). The table runs on the real engine (every
;;; row must pass) and on a planted engine that replaces the frame after any language error (every
;;; row must FAIL: the probe cannot answer). The four codes R:102–127 and R:189–193 already covered
;;; are run here again so that all nine stand in one session.
(defparameter *recovery-setup*
  '("(define anchor 41)" "(define (one-arg x) (+ x 1))" "(define (spin n) (spin (+ n 1)))"))
(defparameter *recovery-rows*
  '(("E-READ"     ")")                                      ; a stray ) is malformed (README "Input")
    ("E-SYNTAX"   "(define if 1)")                          ; a special form may not be a name
    ("E-SYNTAX"   "(cl:eval 1)")                            ; an existing foreign symbol (spec §1)
    ("E-UNBOUND"  "nosuch-name")
    ("E-REDEFINE" "(define anchor 0)")                      ; …and anchor must still be 41 after it
    ("E-ARITY"    "(one-arg 1 2)")
    ("E-TYPE"     "(car anchor)")
    ("E-ARITH"    "(/ anchor 0)")
    ("E-BUDGET"   "(spin 0)")
    ("E-BOUNDARY" "(kernel0/determinacy :mode one-arg)")))  ; a function value at the Kernel /0 bridge (spec §7.2)

(defun recovery-run (submit-fn)
  "→ one (code text ok detail) per row of *RECOVERY-ROWS*, all in ONE session."
  (let ((s (make-session)))
    (dolist (tx *recovery-setup*) (funcall submit-fn s tx))
    (loop for (want text) in *recovery-rows*
          collect (let* ((r (funcall submit-fn s text))
                         (p (funcall submit-fn s "(one-arg anchor)")))
                    (list want text
                          (and (eq (result-status r) :language-error)
                               (equal (getf (result-error r) :code) want)
                               (eq (result-status p) :value)
                               (equal (result-value p) "42"))
                          (list (result-status r) (getf (result-error r) :code) '-> (result-status p) (result-value p)))))))

(dolist (row (recovery-run #'submit))
  (destructuring-bind (want text ok detail) row
    (check ok (format nil "recovery ~a: ~a gives exactly ~a, then (one-arg anchor) => 42 in the same session" want text want)
           detail)))
(let* ((planted (lambda (session text)
                  (let ((r (submit session text)))
                    (when (eq (result-status r) :language-error)
                      (setf (session-env session) (lisp-plus-program0:make-global-environment))) ; the planted defect
                    r)))
       (rows (recovery-run planted)))
  (check (notany #'third rows)
         "recovery table on a planted engine that replaces the frame after an error: every row FAILS, as it must (teeth)"
         (mapcar #'second (remove-if-not #'third rows))))

;;; ---- 16. RE4: the step budget and the depth limit apply PER SUBMISSION -------------------------
;;; README "A session": "The step budget and depth limit apply per submission." The step check
;;; SELF-CALIBRATES at a small *step-budget* B: n* is the largest n for which S = (down n*) passes as
;;; the first submission after the definition, each probe in a FRESH session (so the calibration does
;;; not depend on the property under test). Then, in one session: S passes; S passes AGAIN as a
;;; separate submission; and S twice in ONE submission is E-BUDGET. The last shows that two runs of
;;; S cost at least B, so a step count carried over between submissions would have refused the second
;;; separate S. (The depth limit cannot be what refuses S S: the two calls are sequential, not
;;; nested.) The budget is bound only around submissions, never around make-session, whose prelude
;;; also runs under *step-budget*.
(defparameter *re4-budget* 5000)
(defparameter *re4-down* "(define (down n) (if (= n 0) 0 (down (- n 1))))")
(defun at-budget (s text) (let ((lisp-plus-program0:*step-budget* *re4-budget*)) (sub s text)))
(defun re4-passes-fresh-p (n)
  (let ((c (make-session)))
    (sub c *re4-down*)
    (eq (st (at-budget c (format nil "(down ~d)" n))) :value)))
(let* ((n* (let ((lo 0) (hi *re4-budget*))              ; invariant: (down lo) passes, (down hi) does not
             (loop while (> (- hi lo) 1)
                   do (let ((mid (floor (+ lo hi) 2)))
                        (if (re4-passes-fresh-p mid) (setf lo mid) (setf hi mid))))
             lo))
       (s (make-session))
       (one (format nil "(down ~d)" n*)))
  (sub s *re4-down*)
  (let* ((r1 (at-budget s one))
         (r2 (at-budget s one))
         (r3 (at-budget s (format nil "~a ~a" one one))))
    (check (and (> n* 0) (eq (st r1) :value) (equal (val r1) "0"))
           (format nil "RE4 steps: S = (down ~d) passes alone at *step-budget* ~d (n calibrated: the largest that passes)"
                   n* *re4-budget*)
           (list n* (st r1) (code r1)))
    (check (and (eq (st r3) :language-error) (equal (code r3) "E-BUDGET"))
           "RE4 steps: S twice in ONE submission is E-BUDGET, so two runs of S cost at least the budget"
           (list (st r3) (code r3)))
    (check (and (eq (st r2) :value) (equal (val r2) "0"))
           "RE4 steps: S in a SECOND, separate submission passes too: the step count starts afresh per submission"
           (list (st r2) (code r2)))))
;;; The depth limit: a count that leaked past a refusal (say, set instead of bound) would refuse the
;;; next shallow call. The margins (40 and 120 against 60) leave the counting convention untested
;;; here on purpose.
(let ((s (make-session)))
  (sub s "(define (deep n) (if (= n 0) 0 (+ 1 (deep (- n 1)))))")
  (let ((lisp-plus-program0:*depth-limit* 60))
    (let* ((a (sub s "(deep 40)")) (b (sub s "(deep 120)")) (c (sub s "(deep 40)")))
      (check (and (equal (val a) "40") (equal (code b) "E-BUDGET") (equal (val c) "40"))
             "RE4 depth: at *depth-limit* 60, (deep 40) passes, (deep 120) is E-BUDGET, and (deep 40) passes again after it"
             (list (val a) (code b) (val c))))))

;;; ---- 17. RE12: a HOST FAULT through the command-line client (planted defect, in-process) -------
;;; README "Errors and what happens to state": a host fault is "the same [as a language error: what
;;; ran before stays], reported as `HOST FAULT … a defect of the implementation, not of your program`
;;; — never confused with a language error", and the session continues. The ellipsis is an
;;; abbreviation, so the two fragments and their order are asserted, not the text between them.
(with-planted (lisp-plus-program0::env-lookup (planted-lookup "PLANTED-HOST-FAULT" #'plant-host-error))
  (let* ((o (cli (format nil "(define kept 5)~%(define before-fault 1) (planted-host-fault)~%(+ kept before-fault)~%")))
         (hf (search "HOST FAULT" o))
         (why (and hf (search "a defect of the implementation, not of your program" o :start2 hf)))
         (next (and why (search "(+ kept before-fault)" o :start2 why))))   ; the echo of the next submission
    (check (and hf why next (not (search "lisp-plus: E-" o :end2 next)))
           "RE12 CLI (planted defect): prints HOST FAULT … a defect of the implementation, not of your program, and no language-error code"
           o)
    (check (and why (search "=> 6" o :start2 why))
           "RE12 CLI (planted defect): the session continues; the next submission reads kept and the define made before the fault (=> 6)"
           o)))

;;; ---- 18. RE14 ,help · RE15 the host's load and quit, and the absent lanes ---------------------
(let* ((o (cli (format nil ",help~%(car 5)~%")))
       (start (search (format nil "> ,help~%") o))
       (end (and start (search "(car 5)" o :start2 start)))
       (help (and end (subseq o start end))))
  (check (and help (every (lambda (c) (search c help)) '(",names" ",reset" ",cancel" ",quit"))
              (not (search "lisp-plus:" help)))
         "RE14 CLI: ,help lists the controls (,names ,reset ,cancel ,quit) and prints no diagnostic" o)
  (check (search "E-TYPE at in[1]:1:0" o)
         "RE14 CLI: ,help evaluated and counted nothing; the next form is still in[1]" o))
(let* ((s (make-session)) (rl (sub s "(load 1)")) (rq (sub s "(quit)")))
  (check (and (equal (code rl) "E-UNBOUND") (equal (code rq) "E-UNBOUND"))
         "RE15: load and quit are ordinary unbound names (E-UNBOUND; neither form names anything else)"
         (list (code rl) (code rq))))
;;; The package names are the lanes' own, at candidate 12379a8cf: language-act-0/package.lisp:40,
;;; language-act-1/package.lisp:41 and load.lisp:39, language-many-acts-0/package.lisp:28 and :48,
;;; language-core-0/core0.lisp:38. This image loads the same seven files as main.lisp (lines 15–22
;;; here, main.lisp:22–29); test-cli.sh inventories the image main.lisp itself builds.
(defparameter *absent-lane-packages*
  '("LISP-PLUS-LANGUAGE-ACT0" "LISP-PLUS-LANGUAGE-ACT1" "LISP-PLUS-LANGUAGE-ACT1-LOADER"
    "LISP-PLUS-MANY-ACTS0" "LISP-PLUS-MANY-ACTS0.PROGRAM" "LISP-PLUS-CORE0"))
(check (and (find-package "LISP-PLUS-PROGRAM0") (find-package "LISP-PLUS-KERNEL0")
            (notany #'find-package *absent-lane-packages*))
       "RE15: no act0, act1, many-acts0 or core0 package is in this image (PROGRAM /0 and Kernel /0 are)"
       (remove-if-not #'find-package *absent-lane-packages*))

;;; ---- 19. RE17: legitimate empty renderings ----------------------------------------------------
;;; README (r4): "(quote ||) renders as "", and so does (define || 5)'s name." Read with WEB-API-0.md
;;; ("value is its rendering"; defined: "value is the name defined (kind null)") and the README's own
;;; subject, "legitimate EMPTY values": the rendering is the empty text, which JSON writes "". It is
;;; not the two-character text "" (that would be the rendering of the empty STRING). Asserted on the
;;; engine's record and on the JSON the server would send for it.
(let ((s (make-session)))
  (let* ((r (sub s "(quote ||)")) (j (json-or-nil (lisp-plus-repl0::to-json (lisp-plus-repl0::result-json r)))))
    (check (and (eq (st r) :value) (equal (val r) "") (equal (result-kind r) "symbol")
                (equal (jget j "status") "value") (equal (jget j "value") ""))
           "RE17: (quote ||) renders as the empty text: value \"\" in the record and in the JSON, kind symbol"
           (list (st r) (val r) (result-kind r) j)))
  (let* ((r (sub s "(define || 5)")) (j (json-or-nil (lisp-plus-repl0::to-json (lisp-plus-repl0::result-json r)))))
    (check (and (eq (st r) :defined) (equal (val r) "")
                (equal (jget j "status") "defined") (equal (jget j "value") "") (eq (jget j "kind") :null))
           "RE17: (define || 5)'s name renders as the empty text too: status defined, value \"\", kind null"
           (list (st r) (val r) j))))

;;; ---- 20. G-H by FAULT INJECTION: the server's answers for host-fault, interrupted and 500 -------
;;; WEB-API-0.md (as of r1b; r2 scopes it to answers the server constructs): submit is "always 200 for anything the language said (… host fault, interruption)";
;;; a host-fault Result carries fault {type, message} and state_note; an interrupted one's "fault
;;; carries the message; what ran before stays"; protocol refusals, 500 among them, are {error,
;;; before_mutation}, and "false means the mutation had begun"; every response carries the CSP,
;;; nosniff, no-referrer and no-store headers. A correct implementation produces none of these
;;; events by itself, so each is PLANTED. These checks CALL lisp-plus-repl0::serve-one in this process
;;; on one accepted loopback connection (a port the OS chooses); run-web is never started. They test
;;; the handler's routing and serialization under an injected defect. They are NOT an HTTP run of the
;;; server (test-web.sh is), and NOT a naturally occurring host fault, interrupt or server defect.
(defparameter +webapi-csp+   ; WEB-API-0.md, "Origin and fence", verbatim
  "default-src 'none'; script-src 'self'; style-src 'self'; connect-src 'self'; img-src 'self'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'")
(defun fence-headers-p (head)
  (and (search (format nil "Content-Security-Policy: ~a" +webapi-csp+) head)
       (search "X-Content-Type-Options: nosniff" head)
       (search "Referrer-Policy: no-referrer" head)
       (search "Cache-Control: no-store" head)
       t))
(defun http-request-text (method path port token &key session body)
  (with-output-to-string (h)
    (flet ((line (fmt &rest args) (apply #'format h fmt args) (write-char #\Return h) (write-char #\Newline h)))
      (line "~a ~a HTTP/1.1" method path)
      (line "Host: 127.0.0.1:~d" port)
      (line "X-Lisp-Plus-Token: ~a" token)
      (when session (line "X-Lisp-Plus-Session: ~a" session))
      (when body
        (line "Content-Type: text/plain;charset=utf-8")
        (line "Content-Length: ~d" (length (sb-ext:string-to-octets body :external-format :utf-8))))
      (line "")
      (when body (write-string body h)))))
(defun serve-one-in-process (server request-fn)
  "FAULT-INJECTION HARNESS, not a run of the server: one loopback connection on a port the OS chooses;
the request, (REQUEST-FN port), is written first; then lisp-plus-repl0::serve-one is CALLED in this
process on the accepted socket. → (values status header-text body-json-or-nil body-text)."
  (let ((listener (make-instance 'sb-bsd-sockets:inet-socket :type :stream :protocol :tcp))
        (client (make-instance 'sb-bsd-sockets:inet-socket :type :stream :protocol :tcp))
        (*error-output* (make-string-output-stream)))   ; serve-one logs a server defect there; not asserted
    (unwind-protect
         (handler-case
             (progn
               (sb-bsd-sockets:socket-bind listener #(127 0 0 1) 0)
               (sb-bsd-sockets:socket-listen listener 1)
               (let ((port (nth-value 1 (sb-bsd-sockets:socket-name listener))))
                 (setf (lisp-plus-repl0::server-port server) port)
                 (sb-bsd-sockets:socket-connect client #(127 0 0 1) port)
                 (let ((cs (sb-bsd-sockets:socket-make-stream client :input t :output t :element-type '(unsigned-byte 8)
                                                                     :buffering :full :timeout 5)))
                   (write-sequence (sb-ext:string-to-octets (funcall request-fn port) :external-format :utf-8) cs)
                   (finish-output cs)
                   (lisp-plus-repl0::serve-one server (sb-bsd-sockets:socket-accept listener))
                   (let* ((bytes (coerce (loop for b = (read-byte cs nil nil) while b collect b) '(vector (unsigned-byte 8))))
                          (text (sb-ext:octets-to-string bytes :external-format :utf-8))
                          (sep (search (format nil "~c~c~c~c" #\Return #\Newline #\Return #\Newline) text))
                          (head (if sep (subseq text 0 sep) text))
                          (body (if sep (subseq text (+ sep 4)) "")))
                     (values (ignore-errors (parse-integer head :start 9 :end 12)) head (json-or-nil body) body)))))
           (error (e) (values nil (format nil "harness error: ~a" e) nil "")))
      (ignore-errors (sb-bsd-sockets:socket-close client))
      (ignore-errors (sb-bsd-sockets:socket-close listener)))))

(let* ((token (lisp-plus-repl0::random-hex 32))
       (server (lisp-plus-repl0::make-server :port 0 :token token :session (make-session) :static '())))
  (labels ((current () (lisp-plus-repl0::server-session server))
           (post (text)
             (serve-one-in-process server (lambda (port) (http-request-text "POST" "/api/submit" port token
                                                                            :session (session-id (current)) :body text))))
           (get-session ()
             (serve-one-in-process server (lambda (port) (http-request-text "GET" "/api/session" port token)))))
    (post "(define kept 5)")                                           ; submission 1: an earlier binding
    (with-planted (lisp-plus-program0::env-lookup (planted-lookup "PLANTED-HOST-FAULT" #'plant-host-error))
      (multiple-value-bind (status head j) (post "(define before-fault 1) (planted-host-fault)")   ; submission 2
        (declare (ignore head))
        (let ((r (jget j "result")))
          (check (and (eql status 200) (equal (jget r "status") "host-fault")
                      (jstr-p (jget r "fault" "type")) (jstr-p (jget r "fault" "message"))
                      (jstr-p (jget r "state_note")) (eql (jget r "index") 2))
                 "G-H (fault injection) submit, host fault: 200, status \"host-fault\", fault {type, message}, state_note, index 2"
                 (list status j))
          (check (and (eql status 200) (member "before-fault" (cdr (jget j "session" "names")) :test #'equal))
                 "G-H (fault injection) host fault: the define before the fault stays, and the answer's session lists it"
                 (list status (jget j "session"))))))
    (with-planted (lisp-plus-program0::env-lookup (planted-lookup "PLANTED-INTERRUPT" #'plant-interrupt))
      (multiple-value-bind (status head j) (post "(define before-int 1) (planted-interrupt)")      ; submission 3
        (declare (ignore head))
        (let ((r (jget j "result")))
          (check (and (eql status 200) (equal (jget r "status") "interrupted") (jstr-p (jget r "fault" "message"))
                      (eql (jget r "index") 3) (member "before-int" (cdr (jget j "session" "names")) :test #'equal))
                 "G-H (fault injection) submit, interrupted: 200, status \"interrupted\", fault carries the message, index 3; what ran before stays"
                 (list status j)))))
    (multiple-value-bind (status head j) (post "(+ kept before-fault before-int)")               ; submission 4
      (declare (ignore head))
      (check (and (eql status 200) (equal (jget j "result" "status") "value") (equal (jget j "result" "value") "7"))
             "G-H (fault injection) with the plants removed, the next submission answers 7 from the three earlier bindings"
             (list status j)))
    (with-planted (lisp-plus-repl0::runtime-json #'plant-server-defect)
      (multiple-value-bind (status head j) (get-session)
        (check (and (eql status 500) (jstr-p (jget j "error")) (eq (jget j "before_mutation") :true) (fence-headers-p head))
               "G-H (fault injection) a server defect answering GET /api/session: 500 {error, before_mutation: true} with the four fence headers"
               (list status head j))))
    (let ((before (session-submissions (current))))
      (with-planted (lisp-plus-repl0::result-json #'plant-server-defect)
        (multiple-value-bind (status head j) (post "(define via-500 1)")                            ; submission 5
          (check (and (eql status 500) (jstr-p (jget j "error")) (eq (jget j "before_mutation") :false) (fence-headers-p head)
                      (= (session-submissions (current)) (1+ before))
                      (member "via-500" (session-names (current)) :test #'equal))
                 "G-H (fault injection) a server defect after submit ran: 500 with before_mutation false, and the mutation had indeed happened"
                 (list status head j (session-submissions (current)) before)))))
    (multiple-value-bind (status head j) (get-session)
      (declare (ignore head))
      (check (and (eql status 200) (member "via-500" (cdr (jget j "session" "names")) :test #'equal)
                  (equal (jget j "runtime" "language") "Lisp+ PROGRAM /0"))
             "G-H (fault injection) after both 500s the next request is answered 200, with the session as it now is"
             (list status j)))))

;;; ---- 21. per-row teeth for the §15 recovery table (2026-09-30, RALLY, bounded repair) -----------
;;; ASSAYER's catch, the chair agreeing: §15's tooth ("every row FAILS" on the planted resetting
;;; engine) is ONE mutant for ten paths. The planted reset fires at row 1, so rows 2–10 fail by
;;; inheritance. Here each row runs ALONE, in its own fresh session, twice: on the real engine it
;;; must pass (its exact code, then the probe answers 42); on the planted engine that replaces the
;;; frame after a language error it must raise the same exact code AND its probe must then fail. So
;;; each row's own error is what removes the earlier binding its probe needs, and each row's probe is
;;; seen to discriminate both ways. Appended after §20 so no earlier line moves.
(defun planted-reset-submit (session text)
  "The planted defect of §15, as a named function: any language error replaces the session's frame."
  (let ((r (submit session text)))
    (when (eq (result-status r) :language-error)
      (setf (session-env session) (lisp-plus-program0:make-global-environment)))
    r))
(defun recovery-row-alone (submit-fn want text)
  "One §15 row, alone, in a fresh session. → (values code-ok probe-ok detail)."
  (let ((s (make-session)))
    (dolist (tx *recovery-setup*) (funcall submit-fn s tx))
    (let* ((r (funcall submit-fn s text))
           (p (funcall submit-fn s "(one-arg anchor)")))
      (values (and (eq (result-status r) :language-error) (equal (getf (result-error r) :code) want))
              (and (eq (result-status p) :value) (equal (result-value p) "42"))
              (list (result-status r) (getf (result-error r) :code) '-> (result-status p) (result-value p)
                    (getf (result-error p) :code))))))
(dolist (row *recovery-rows*)
  (destructuring-bind (want text) row
    (multiple-value-bind (real-code real-probe real-detail) (recovery-row-alone #'submit want text)
      (multiple-value-bind (planted-code planted-probe planted-detail) (recovery-row-alone #'planted-reset-submit want text)
        (check (and real-code real-probe planted-code (not planted-probe))
               (format nil "recovery tooth ~a: ~a alone passes on the real engine; on the planted resetting engine it raises ~a and its own probe then fails"
                       want text want)
               (list :real real-detail :planted planted-detail))))))

;;; ---- 22. r2 (TELLTALE, Claude Opus 5.5, subagent of the laptop chair; R2-WORK-ORDER items 14 and 10) ---
;;; Appended after §21 so no earlier line moves. Expected values from the texts quoted here, never from
;;; what the engine printed.
;;;
;;; RE6, the literal pair as TWO separate submissions. REPL README, "A session": "`(define x 1)` then
;;; `(define x 2)` is E-REDEFINE, as in a file." The dossier row RE6 (2-README-EXAMPLES.md) was
;;; RUN-EQUIVALENT: the literal pair had run only as one file. Here the two texts are the README's, each
;;; its own submission, in one fresh session. After the refusal x still answers 1: PROGRAM /0 spec §3.4,
;;; "There is no assignment. No form changes an existing binding." The first answer's value is the name
;;; (WEB-API-0.md: defined, "value is the name defined").
(let* ((s (make-session))
       (r1 (sub s "(define x 1)"))
       (r2 (sub s "(define x 2)"))
       (r3 (sub s "x")))
  (check (and (eq (st r1) :defined) (equal (val r1) "x")
              (eq (st r2) :language-error) (equal (code r2) "E-REDEFINE")
              (eq (st r3) :value) (equal (val r3) "1")
              (equal (session-names s) '("x")))
         "RE6: (define x 1), then (define x 2) as a SEPARATE submission, is exactly E-REDEFINE; x still answers 1 (spec §3.4)"
         (list (st r1) (val r1) (st r2) (code r2) (st r3) (val r3) (session-names s))))

;;; Item 10, the README state table's phase witness. Astra's r1 disposition: "Source validation can
;;; produce E-SYNTAX before evaluation begins; earlier forms of that submission have not run." PROGRAM /0
;;; spec §1: each top-level form is validated "right after [it] is read", and a foreign symbol other than
;;; common-lisp:quote is "E-SYNTAX at source validation". So in `(define a1 1) (cl:eval 1)` the second
;;; form is refused while the submission is still being read, and the first never ran: a1 is not bound,
;;; and a later `a1` is E-UNBOUND. The refused submission is counted (index 1; WEB-API-0.md: "evaluated
;;; or refused"). The CODE alone does not tell the phases apart: an evaluator that met cl:eval only at
;;; evaluation would also say E-SYNTAX (spec §4.1, "Any other symbol is E-SYNTAX"), after binding a1.
;;; The evaluation-stage contrast (forms before the failing one stay) is §5, R:109–112.
(let* ((s (make-session))
       (r (sub s "(define a1 1) (cl:eval 1)"))
       (bound-after (bound-p s "a1"))
       (probe (sub s "a1")))
  (check (and (eq (st r) :language-error) (equal (code r) "E-SYNTAX") (eql (result-index r) 1)
              (not bound-after)
              (eq (st probe) :language-error) (equal (code probe) "E-UNBOUND"))
         "item 10 (phase): (define a1 1) (cl:eval 1) is E-SYNTAX at source validation, before evaluation began; a1 was never bound (a later a1 is E-UNBOUND)"
         (list (st r) (code r) (result-index r) :a1-bound bound-after '-> (st probe) (code probe))))

(format *report* "~&repl0 selftest: ~d passed, ~d failed~%" *passed* *failed*)
(unless (= *lines* (+ *passed* *failed*))
  (format *report* "COUNT MISMATCH: ~d lines printed for ~d checks~%" *lines* (+ *passed* *failed*))
  (incf *failed*))
(sb-ext:exit :code (if (zerop *failed*) 0 1))
