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
  (check (member (code (sub s "(cl:eval 1)")) '("E-SYNTAX" "E-READ") :test #'equal) "a cl: symbol is refused")
  (check (string= (code (sub s "#.(sb-ext:quit)")) "E-READ") "#. is dead at the reader (and this test process is still alive)")
  (check (member (code (sub s "(sb-ext:quit)")) '("E-SYNTAX" "E-READ") :test #'equal) "a host symbol by package prefix is refused")
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

(format *report* "~&repl0 selftest: ~d passed, ~d failed~%" *passed* *failed*)
(unless (= *lines* (+ *passed* *failed*))
  (format *report* "COUNT MISMATCH: ~d lines printed for ~d checks~%" *lines* (+ *passed* *failed*))
  (incf *failed*))
(sb-ext:exit :code (if (zerop *failed*) 0 1))
