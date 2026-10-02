;;;; program0-selftest.lisp — focused implementation tests for PROGRAM /0.
;;;;
;;;;   cd mneme/language-program-0 && sbcl --non-interactive --load program0-selftest.lisp
;;;;   (or: bash run-selftest.sh — same thing with the stack the runner uses)
;;;;
;;;; Prints one line per check, then "program0 selftest: N passed, M failed",
;;;; and exits 0 iff M = 0. The behaviour the commission named is tested by name:
;;;; lexical shadowing and capture, higher-order application, empty collections,
;;;; wrong arity, unknown names, the effect boundary — plus the reader law, the
;;;; budget, redefinition, the Kernel /0 bridge, and the four programs' actual
;;;; outputs (each spawned through the ONE command and compared byte-for-byte
;;;; with programs/<name>.expected).
;;;;
;;;; Every negative check asserts the CODE and that a location was recorded;
;;;; a test that only asserted "some error" would pass on a defect.

(require :sb-posix)

(defparameter *here* (make-pathname :name nil :type nil :defaults *load-truename*))

(let ((*standard-output* *error-output*))
  (load (merge-pathnames "../kernel0/load.lisp" *here*))
  (load (merge-pathnames "package.lisp" *here*))
  (load (merge-pathnames "program0.lisp" *here*)))

(defpackage #:program0-selftest (:use #:cl #:lisp-plus-program0))
(in-package #:program0-selftest)

(defparameter *here* cl-user::*here*)

;;; Section 14 compares every package's lock state with the state BEFORE this file's first
;;; read, so the snapshot is taken here, before section 1 reads anything. A snapshot taken
;;; later would come after earlier reads, and a guard that never unlocks would pass it.
(defparameter *lock-state-before-any-read*
  (sort (mapcar (lambda (p) (cons (package-name p) (sb-ext:package-locked-p p))) (list-all-packages))
        #'string< :key #'car))
;;; Section 16 checks that no read replaces or edits the global readtable, so those
;;; snapshots are taken before any read as well.
(defparameter *global-readtable-before-any-read* *readtable*)
(defparameter *global-sharp-s-before-any-read* (get-dispatch-macro-character #\# #\S *readtable*))

(defvar *passed* 0)
(defvar *failed* 0)

(defun report (ok name detail)
  (if ok (incf *passed*) (incf *failed*))
  (format t "~:[FAIL~;ok  ~] ~a~@[  — ~a~]~%" ok name (unless ok detail))
  ok)

(defun run (text)
  "Evaluate TEXT in a fresh program frame. → (values rendered-value error-or-nil)."
  (handler-case
      (values (render (run-source text (make-global-environment) :source-name "test.lp")) nil)
    (program0-error (c) (values nil c))))

(defun value-is (name text expected)
  (multiple-value-bind (v e) (run text)
    (report (and (null e) (string= v expected)) name
            (if e (render-program0-error e) (format nil "got ~a, expected ~a" v expected)))))

(defun fails-with (name text code &key (location t) message-part)
  (multiple-value-bind (v e) (run text)
    (report (and e
                 (string= (program0-error-code e) code)
                 (or (not location) (program0-error-location e))
                 (or (null message-part)
                     (search message-part (program0-error-message e))))
            name
            (cond ((null e) (format nil "no error; value ~a" v))
                  ((string/= (program0-error-code e) code)
                   (format nil "wrong code ~a: ~a" (program0-error-code e) (program0-error-message e)))
                  ((and location (not (program0-error-location e))) "no location recorded")
                  (t (format nil "message lacks ~s: ~a" message-part (program0-error-message e)))))))

(format t "~&== PROGRAM /0 selftest (SBCL ~a) ==~%" (lisp-implementation-version))

;;; ---- 1. ordinary computation -------------------------------------------------
(value-is "arithmetic" "(+ 1 (* 2 3) (- 10 4) (/ 9 3))" "16")
(value-is "rational division stays exact" "(/ 1 3)" "1/3")
(value-is "comparison yields a boolean value" "(< 1 2)" "true")
(value-is "chained comparison" "(< 1 2 3)" "true")
(value-is "quotient and mod" "(list (quotient 17 5) (mod 17 5))" "(3 2)")
(let ((*standard-output* (make-broadcast-stream)))
  (value-is "strings and print return their last value" "(print \"hello\" 1)" "1"))
(value-is "quote gives a symbol, printed lowercase" "(quote Alpha)" "alpha")
(value-is "keywords self-evaluate" ":mode" ":mode")
(value-is "empty list literal" "()" "()")

;;; ---- 2. definitions, lexical scope, shadowing, capture ------------------------
(value-is "define and call" "(define (sq x) (* x x)) (sq 12)" "144")
(value-is "sum of squares 1..10" "(sum (map square (range 1 11)))" "385")
(value-is "shadowing: parameter hides global inside the frame only"
          "(define x 1) (define (f x) (+ x 1)) (list (f 10) x)" "(11 1)")
(value-is "let shadows and restores"
          "(define x 1) (list (let ((x 2)) (let ((x 3)) x)) x)" "(3 1)")
(value-is "let inits are evaluated in the OUTER frame (parallel let)"
          "(define x 1) (let ((x 2) (y x)) y)" "1")
(value-is "closure captures its defining frame after it returns"
          "(define (make-adder n) (lambda (x) (+ x n))) (define add5 (make-adder 5)) (add5 10)" "15")
(value-is "capture is lexical, not dynamic"
          "(define (make-scaler k) (lambda (x) (* k x)))
           (define (call-with-k f) (let ((k 1000)) (f 2)))
           (call-with-k (make-scaler 3))" "6")
(value-is "two closures from one maker keep separate captures"
          "(define (make-adder n) (lambda (x) (+ x n))) (map (lambda (f) (f 1)) (list (make-adder 5) (make-adder 10)))" "(6 11)")
(value-is "internal define makes a local recursive helper"
          "(define (fact n) (define (go n acc) (if (= n 0) acc (go (- n 1) (* acc n)))) (go n 1)) (fact 10)" "3628800")
(value-is "internal define is not visible outside its body"
          "(define (f) (define inner 1) inner) (f) (function? f)" "true")
(fails-with "internal name does not leak to the top level"
            "(define (f) (define inner 1) inner) (f) inner" "E-UNBOUND" :message-part "inner")

;;; ---- 3. higher-order application and collections ----------------------------
(value-is "map with a lambda" "(map (lambda (x) (* x x)) (list 1 2 3))" "(1 4 9)")
(value-is "filter with a prelude predicate" "(filter even? (range 1 11))" "(2 4 6 8 10)")
(value-is "fold with a primitive as a value" "(fold + 0 (range 1 101))" "5050")
(value-is "fold-right preserves order" "(fold-right cons () (list 1 2 3))" "(1 2 3)")
(value-is "compose returns a function value" "(function? (compose square square))" "true")
(value-is "a primitive is a first-class value" "((lambda (op) (op 2 3)) *)" "6")
(value-is "functions in a list, applied" "(map (lambda (f) (f 9)) (list square (lambda (x) (- x))))" "(81 -9)")

;;; ---- 4. empty collections ------------------------------------------------------
(value-is "map over ()" "(map square ())" "()")
(value-is "filter over ()" "(filter even? ())" "()")
(value-is "fold over () returns the seed" "(fold + 0 ())" "0")
(value-is "sum of () is 0, product of () is 1" "(list (sum ()) (product ()))" "(0 1)")
(value-is "any?/all? on ()" "(list (any? even? ()) (all? even? ()))" "(false true)")
(value-is "length and reverse of ()" "(list (length ()) (reverse ()))" "(0 ())")
(fails-with "car of () is a type error, not a silent ()" "(car ())" "E-TYPE" :message-part "car")
(fails-with "nth past the end is a type error" "(nth 3 (list 1 2))" "E-TYPE")

;;; ---- 5. wrong arity ------------------------------------------------------------
(fails-with "user function, too few" "(define (f a b) a) (f 1)" "E-ARITY" :message-part "`f` takes 2")
(fails-with "user function, too many" "(define (f a) a) (f 1 2 3)" "E-ARITY" :message-part "got 3")
(fails-with "anonymous function arity" "((lambda (a) a))" "E-ARITY" :message-part "anonymous")
(fails-with "primitive fixed arity" "(car (list 1) (list 2))" "E-ARITY" :message-part "`car` takes 1")
(fails-with "primitive minimum arity" "(-)" "E-ARITY" :message-part "at least 1")
(fails-with "special form shape: if needs an else" "(if true 1)" "E-SYNTAX" :message-part "takes 3")

;;; ---- 6. unknown names ----------------------------------------------------------
(fails-with "unknown variable, located" "(+ 1 nosuch)" "E-UNBOUND" :message-part "nosuch")
(fails-with "unknown function in operator position" "(nosuch 1 2)" "E-UNBOUND" :message-part "nosuch")
(fails-with "nil is not a name here" "nil" "E-UNBOUND" :message-part "nil")
(fails-with "t is not a name here" "t" "E-UNBOUND")
(multiple-value-bind (v e) (run (format nil "(define (f x) x)~%~%   (f nosuch)"))
  (declare (ignore v))
  (report (and e (equal (program0-error-location e) '(3 . 3))) "location is line 3, column 3 of the offending top-level form"
          (and e (format nil "location ~a" (program0-error-location e)))))
(multiple-value-bind (v e) (run "(define (outer x) (inner x)) (define (inner y) (+ y nosuch)) (outer 1)")
  (declare (ignore v))
  (report (and e (equal (mapcar #'symbol-name (program0-error-frames e)) '("INNER" "OUTER")))
          "frames name the user functions, innermost first"
          (and e (format nil "frames ~a" (program0-error-frames e)))))

;;; ---- 7. the reader law and the host boundary ---------------------------------
(fails-with "read-time eval is dead at the reader" "#.(+ 1 2)" "E-READ" :location t)
(fails-with "unbalanced form is a read error with a location" "(define (f x) (+ x 1)" "E-READ")
(fails-with "package-qualified host symbol is not a name (Astra's qualification)" "(cl:eval 1)" "E-SYNTAX" :message-part "not a name")
(fails-with "the implementation package is not reachable either" "lisp-plus-program0::fail" "E-SYNTAX")
(fails-with "an unknown package prefix dies at the reader" "(foo:bar 1)" "E-READ")
(fails-with "cannot bind a special-form name" "(define if 1)" "E-SYNTAX" :message-part "special form")
(fails-with "cannot use a special-form name as a parameter" "(define (f lambda) lambda)" "E-SYNTAX")
(fails-with "cannot rebind true" "(define true 0)" "E-SYNTAX" :message-part "reserved")
(fails-with "redefinition in the same frame" "(define x 1) (define x 2)" "E-REDEFINE" :message-part "x")
(value-is "a program may shadow a prelude name at top level (the program frame is a child of the root)" "(define (map f xs) xs) (map square (list 1 2))" "(1 2)")
(value-is "...and in an inner frame" "(define (g map) (map 2)) (g square)" "4")
(fails-with "but not define it twice in its own frame" "(define (map f xs) xs) (define map 1)" "E-REDEFINE")

;;; ---- 8. no truthiness ------------------------------------------------------------
(fails-with "if on a number" "(if 1 2 3)" "E-TYPE" :message-part "true or false")
(fails-with "if on ()" "(if () 2 3)" "E-TYPE")
(fails-with "cond with no clause holding and no else" "(cond ((= 1 2) 1))" "E-TYPE" :message-part "fell through")
(fails-with "and on a non-boolean" "(and true 1)" "E-TYPE")
(fails-with "not on a list" "(not ())" "E-TYPE")
;; Corrected 2026-09-30 (dossier r0 G-B; Astra's disposition): this check used to assert only
;; the four values, so an EAGER and/or passed it. `(car ())' is E-TYPE, so the two last items
;; fail unless the argument after the deciding one is never evaluated. (KEEL, Claude Opus 5.5)
(value-is "and/or short-circuit and yield booleans (the argument after the deciding one, (car ()), is never evaluated)"
          "(list (and) (or) (and true false) (or false true) (and false (car ())) (or true (car ())))"
          "(true false false true false true)")

;;; ---- 9. the budget (termination policy of this lane) ------------------------
(fails-with "unbounded recursion is refused by depth, with a location"
            "(define (f n) (f (+ n 1))) (f 0)" "E-BUDGET" :message-part "depth")
(let ((*step-budget* 2000))
  (fails-with "step budget refuses a long computation under a small ceiling"
              "(sum (range 1 1000))" "E-BUDGET" :message-part "step budget"))
(value-is "the same computation passes under the default ceiling" "(sum (range 1 1000))" "499500")
(fails-with "map over a list longer than the depth ceiling refuses (named limitation)"
            "(length (map square (range 0 5000)))" "E-BUDGET")
(fails-with "division by zero is an arithmetic refusal" "(/ 1 0)" "E-ARITH")

;;; ---- 10. the effect boundary and the Kernel /0 bridge -------------------------
(report (null (find-package '#:lisp-plus-core0)) "no effect lane (core0) is loaded in the runner image" "lisp-plus-core0 present")
(report (null (find-package '#:lisp-plus-many-acts0)) "no Many Acts /0 package is loaded in the runner image" "present")
(report (null (find-package '#:lisp-plus-language-act0)) "no One Act /0 package is loaded in the runner image" "present")
(fails-with "perform is not a name" "(perform 1)" "E-UNBOUND" :message-part "perform")
(fails-with "act is not a name" "(act (quote x))" "E-UNBOUND")
(fails-with "derive is not a name" "(derive (quote x))" "E-UNBOUND")
(value-is "kernel0/determinacy: the kernel refuses a global confidence scalar, as a VALUE"
          "(refused? (kernel0/determinacy :mode :determinate :confidence 0.8))" "true")
(value-is "the refusal carries the kernel's requirement id"
          "(refusal-requirement (kernel0/determinacy :mode :determinate :confidence 0.8))" "\"K0E-33\"")
;; Corrected 2026-09-30 (dossier r0 G-B): this check used to assert that a ONE-ELEMENT LIST has
;; a positive length, which is true whatever refusal-law returns. It now reads the host value
;; itself: a non-empty string that begins with the text README.md:146 documents (the README's
;; "..." is an abbreviation, so only the text before it is compared). (KEEL, Claude Opus 5.5)
(let ((law (handler-case (run-source "(refusal-law (kernel0/determinacy :mode :determinate :confidence 0.8))"
                                     (make-global-environment) :source-name "test.lp")
             (program0-error (c) c)))
      (documented "§7.5 and Errata 0.2 §6: determinacy MUST NOT carry a global confidence"))
  (report (and (stringp law) (plusp (length law)) (eql 0 (search documented law)))
          "the refusal's law is a non-empty string beginning with README.md:146's text \"§7.5 and Errata 0.2 §6: determinacy MUST NOT carry a global confidence\""
          (if (typep law 'condition) (render-program0-error law) (format nil "got ~s" law))))
(value-is "kernel0/determinacy: a lawful record is a host value"
          "(host-value? (kernel0/determinacy :mode :determinate))" "true")
(value-is "the host value answers the kernel's own accessor"
          "(kernel0/determinacy-mode (kernel0/determinacy :mode :indeterminate))" ":indeterminate")
(value-is "an unknown mode is refused under its own requirement, not a host error"
          "(refusal-requirement (kernel0/determinacy :mode :fairly-sure))" "\"K0E-2\"")
(fails-with "a closure may not cross into a Kernel /0 record"
            "(kernel0/determinacy :mode (lambda (x) x))" "E-BOUNDARY" :message-part "may not cross")
(fails-with "a primitive may not cross either" "(kernel0/determinacy :mode car)" "E-BOUNDARY")
(fails-with "a host value cannot be taken apart by the wrong accessor"
            "(car (kernel0/determinacy :mode :determinate))" "E-TYPE")
(value-is "host values and refusals print as descriptions, not data"
          "(list (kernel0/determinacy :mode :determinate) (kernel0/determinacy :mode :determinate :confidence 1))"
          "(#<kernel0 determinacy> #<refused global-uncertainty-scalar-rejected requirement K0E-33>)")

;;; ---- 11. the four programs, through the ONE command, against their expected output
(defun run-program (name)
  (let* ((script (merge-pathnames "lisp-plus-run.sh" *here*))
         (program (merge-pathnames (format nil "programs/~a.lp" name) *here*))
         (out (make-string-output-stream))
         (proc (sb-ext:run-program "/usr/bin/env" (list "bash" (sb-ext:native-namestring script) (sb-ext:native-namestring program))
                                   :output out :error nil :wait t)))
    (values (get-output-stream-string out) (sb-ext:process-exit-code proc))))

(dolist (name '("sum-of-squares" "higher-order" "determinacy" "tally"))
  (let ((expected-path (merge-pathnames (format nil "programs/~a.expected" name) *here*)))
    (multiple-value-bind (out code) (run-program name)
      (let ((expected (and (probe-file expected-path)
                           (with-open-file (in expected-path :external-format :utf-8)
                             (let ((s (make-string (file-length in))))
                               (subseq s 0 (read-sequence s in)))))))
        (report (and (eql code 0) expected (string= out expected))
                (format nil "program ~a: exit 0 and output equals programs/~a.expected" name name)
                (cond ((not (eql code 0)) (format nil "exit ~a" code))
                      ((null expected) "no .expected file")
                      (t (format nil "output differs:~%--- got~%~a--- expected~%~a" out expected))))))))

;;; ---- 12. the runner's exit codes, through the ONE command ----------------------
(defun run-text-as-file (text)
  (let* ((path (format nil "/tmp/program0-selftest-~d.lp" (sb-posix:getpid))))
    (with-open-file (o path :direction :output :if-exists :supersede :external-format :utf-8)
      (write-string text o))
    (let* ((script (merge-pathnames "lisp-plus-run.sh" *here*))
           (proc (sb-ext:run-program "/usr/bin/env" (list "bash" (sb-ext:native-namestring script) path)
                                     :output nil :error nil :wait t)))
      (delete-file path)
      (sb-ext:process-exit-code proc))))
(defun run-text-as-file-missing ()
  (let* ((script (merge-pathnames "lisp-plus-run.sh" *here*))
         (proc (sb-ext:run-program "/usr/bin/env" (list "bash" (sb-ext:native-namestring script) "/nonexistent/program.lp")
                                   :output nil :error nil :wait t)))
    (sb-ext:process-exit-code proc)))
(report (eql 0 (run-text-as-file "(+ 1 2)")) "runner exits 0 on a value" "")
(report (eql 2 (run-text-as-file "(+ 1 nosuch)")) "runner exits 2 on a language error" "")
(report (eql 2 (run-text-as-file "(define (f n) (f n)) (f 1)")) "runner exits 2 (not a host crash) on runaway recursion" "")
(report (eql 0 (run-text-as-file "")) "an empty program is the value () and exits 0" "")
(report (eql 3 (run-text-as-file-missing)) "runner exits 3 when the file does not exist" "")

;;; ---- 13. Astra's review of 2026-09-24: arithmetic conditions and source validation --
(fails-with "float division by zero is E-ARITH, not a host fault" "(/ 1 0.0)" "E-ARITH" :message-part "division by zero")
(fails-with "integer division by float zero" "(/ 1 0.0d0)" "E-ARITH")
(fails-with "floating-point overflow is E-ARITH" "(* 1.0d308 1.0d308)" "E-ARITH" :message-part "overflow")
(fails-with "quotient by the integer 0 is E-ARITH, refused before the host sees it (label corrected in r2: it said 0.0, but the check has always tested (quotient 1 0))" "(quotient 1 0)" "E-ARITH")
(value-is "ordinary float arithmetic still works" "(* 2.5 4)" "10.0")
(fails-with "a quoted dotted pair is refused at the source" "'(1 . 2)" "E-READ" :message-part "dotted pair")
(fails-with "a dotted tail deep in a quoted list" "(quote (1 (2 . 3)))" "E-READ" :message-part "dotted pair")
(fails-with "a quoted vector is an unsupported datum" "'#(1 2)" "E-READ" :message-part "unsupported datum")
(fails-with "a character literal is an unsupported datum" "#\\a" "E-READ" :message-part "unsupported datum")
(fails-with "a quoted foreign symbol is refused" "'cl:eval" "E-SYNTAX" :message-part "not a name")
(fails-with "a quoted circular list is refused, cycle-safe, in bounded time" "'#1=(1 . #1#)" "E-READ" :message-part "circular")
(fails-with "a circular car is refused too" "'#1=(#1# 2)" "E-READ" :message-part "circular")
(fails-with "cl:if is not a special form (heads live in the source namespace)" "(cl:if true 1 2)" "E-SYNTAX" :message-part "common-lisp:if")
(fails-with "cl:let is not a let" "(cl:let ((x 1)) x)" "E-SYNTAX" :message-part "common-lisp:let")
(fails-with "a prefix naming a symbol CL does not have is a reader error" "(cl:define x 1)" "E-READ")
(value-is "the reader's own quote (cl:quote via ') is the one admitted foreign symbol" "'(1 (2 3) \"s\" :k sym)" "(1 (2 3) \"s\" :k sym)")
(value-is "a source-namespace quote works the same" "(quote sym)" "sym")
(fails-with "backquote reads as a foreign symbol and is refused" "`x" "E-SYNTAX")
(fails-with "#'car reads as cl:function and is refused" "#'car" "E-SYNTAX" :message-part "common-lisp:function")
(value-is "acyclic SHARING is admitted (#1= reused, not self-referring) — Astra's edge case" "'(#1=(1 2) #1#)" "((1 2) (1 2))")
(value-is "shared tail is admitted too" "'(#1=(1 2) . #1#)" "((1 2) 1 2)")
(fails-with "a self-referring cdr is still a cycle" "'#1=(1 . #1#)" "E-READ" :message-part "circular")
(fails-with "a self-referring car is still a cycle" "'#1=(#1#)" "E-READ" :message-part "circular")
(fails-with "cl:quote as a DATUM is refused — Astra's edge case" "'cl:quote" "E-SYNTAX" :message-part "only as the head")
(fails-with "cl:quote in argument position is refused" "(list 'cl:quote 1)" "E-SYNTAX" :message-part "only as the head")
(value-is "a quoted quote form is fine (the inner quote is a head)" "''x" "(quote x)")
(fails-with "cl:quote SHARED into a non-head position is refused (met as a head first) — Astra's r4 case" "'(#1=(cl:quote x) (tag . #1#))" "E-SYNTAX" :message-part "only as the head")
(fails-with "the same structure unshared is refused alike" "'((cl:quote x) (tag cl:quote x))" "E-SYNTAX" :message-part "only as the head")
(fails-with "the same sharing met as a tail first is refused alike" "'((tag . #1=(cl:quote x)) #1#)" "E-SYNTAX" :message-part "only as the head")
(value-is "a quote form shared into two HEAD positions is admitted (sharing does not over-refuse)" "'(#1=(cl:quote x) #1#)" "((quote x) (quote x))")
(let ((*max-source-nodes* 50))
  (fails-with "a form over the source node bound is refused (small bound for the test)"
              "(list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52)" "E-READ" :message-part "conses"))

;;; ---- REPL /0 candidate (2026-09-25): the end of the text, as the reader sees it ----
;;; An interactive reader must tell UNFINISHED input from MALFORMED input by the reader's
;;; own verdict. Unfinished = the reader hit end-of-text inside a form: still E-READ, same
;;; rendering, but of class program0-incomplete-source. And a source that ends in a #|…|#
;;; comment is no longer refused as if a form were unfinished (the one behaviour change).
(value-is "a source ending in a #|…|# comment runs (was E-READ before 2026-09-25)" "(+ 1 2) #| tail |#" "3")
(value-is "a source that is only a #|…|# comment and a form after it" "#| head |# (* 6 7)" "42")
(flet ((kind-of (text)
         (multiple-value-bind (v e) (run text)
           (declare (ignore v))
           (cond ((null e) :no-error)
                 ((not (string= (program0-error-code e) "E-READ")) :other-code)
                 ((typep e 'program0-incomplete-source) :incomplete)
                 (t :malformed)))))
  (dolist (case '(("an unclosed paren is INCOMPLETE" "(define (f x) (+ x 1)" :incomplete)
                  ("an unclosed string is INCOMPLETE" "(print \"abc" :incomplete)
                  ("an unclosed |…| escape is INCOMPLETE" "(list a|b)" :incomplete)
                  ("an unclosed #| comment is INCOMPLETE" "(+ 1 2) #| never closed" :incomplete)
                  ("a lone quote at the end is INCOMPLETE" "(+ 1 2) '" :incomplete)
                  ("a stray close paren is MALFORMED, not incomplete" "(+ 1 2))" :malformed)
                  ("#. is MALFORMED, not incomplete" "#.(+ 1 2)" :malformed)
                  ("a bad dot is MALFORMED, not incomplete" "(1 . )" :malformed)
                  ("a complete form followed by an unfinished one is INCOMPLETE" "(+ 1 2) (list 1" :incomplete)))
    (destructuring-bind (name text expected) case
      (let ((got (kind-of text)))
        (report (eq got expected) name (format nil "got ~a, expected ~a" got expected))))))

;;; ---- 14. reading writes no host package (the reader seam, 2026-09-29) --------------
;;; Until 2026-09-29, CL `read` interned a package-qualified NEW name into an unlocked host
;;; package (CL-USER, or this implementation's own packages) BEFORE the language refused it.
;;; Unfinished text and admitted #+/#- feature expressions did the same, and distinct names
;;; accumulated. Every read now runs with the host packages locked
;;; (%call-with-host-packages-locked). A HOST package is every package except the source
;;; namespace and KEYWORD. The R checks guard against the mutation; the C checks guard
;;; what must not change. (Claude Opus 5.5)
(defvar *seam-n* 0)
(defun seam-fresh (tag) (format nil "ZZQ-SEAM-~a-~d" tag (incf *seam-n*)))
(defun seam-present-p (package name)
  "Is NAME present (internal or external, not merely inherited) in PACKAGE?"
  (and (find-package package)
       (member (nth-value 1 (find-symbol name package)) '(:internal :external))
       t))
(defun seam-host-packages ()
  (let ((own (list (find-package '#:lisp-plus-program0.source) (find-package "KEYWORD"))))
    (remove-if (lambda (p) (member p own)) (list-all-packages))))
(defun seam-present-count (package)
  (let ((seen (make-hash-table :test #'eq)))
    (do-symbols (s package)
      (multiple-value-bind (found status) (find-symbol (symbol-name s) package)
        (when (and (eq found s) (member status '(:internal :external)))
          (setf (gethash s seen) t))))
    (hash-table-count seen)))
(defun seam-census ()
  (sort (mapcar (lambda (p) (cons (package-name p) (seam-present-count p))) (seam-host-packages))
        #'string< :key #'car))
(defun seam-lock-state ()
  (sort (mapcar (lambda (p) (cons (package-name p) (sb-ext:package-locked-p p))) (list-all-packages))
        #'string< :key #'car))
(defun seam-code (text)
  "READ TEXT only, with no evaluation. → :admitted, :incomplete, or the refusal's code."
  (handler-case (progn (read-source-forms text :source-name "seam.lp") :admitted)
    (program0-incomplete-source () :incomplete)
    (program0-error (c) (program0-error-code c))))
(defun run-text-as-file-capturing (text)
  "Through the ONE command. → (values exit-code stderr-text)."
  (let ((path (format nil "/tmp/program0-selftest-seam-~d.lp" (sb-posix:getpid)))
        (err (make-string-output-stream)))
    (with-open-file (o path :direction :output :if-exists :supersede :external-format :utf-8)
      (write-string text o))
    (let* ((script (merge-pathnames "lisp-plus-run.sh" *here*))
           (proc (sb-ext:run-program "/usr/bin/env" (list "bash" (sb-ext:native-namestring script) path)
                                     :output nil :error err :wait t)))
      (delete-file path)
      (values (sb-ext:process-exit-code proc) (get-output-stream-string err)))))

;;; R — the mutation
(let ((n (seam-fresh "R1")))
  (multiple-value-bind (v e) (run (format nil "(cl-user::~a 1)" n))
    (declare (ignore v))
    (report (and e (string= (program0-error-code e) "E-READ") (program0-error-location e)
                 (not (seam-present-p "CL-USER" n)))
            "R1 seam: a NEW name qualified into CL-USER is refused E-READ, located, and never interned"
            (format nil "code ~a; interned ~a" (and e (program0-error-code e)) (seam-present-p "CL-USER" n)))))
(let ((n (seam-fresh "R2")))
  (report (and (equal (seam-code (format nil "(lisp-plus-program0::~a 1)" n)) "E-READ")
              (not (seam-present-p "LISP-PLUS-PROGRAM0" n)))
          "R2 seam: a NEW name qualified into the implementation's OWN package is refused and never interned"
          (seam-present-p "LISP-PLUS-PROGRAM0" n)))
(let* ((census (seam-census))
       (locks (seam-lock-state))
       (texts (append
               (loop for p in (seam-host-packages)                       ; one fresh name into every host package
                     collect (format nil "(|~a|::|~a| 1)" (package-name p) (seam-fresh "CENSUS")))
               (list (format nil "'cl-user::~a" (seam-fresh "QUOTED"))
                     (format nil "(|CL-USER|::|~a x| 1)" (seam-fresh "ESCAPED"))
                     (format nil "(list cl-user::(~a ~a))" (seam-fresh "PF") (seam-fresh "PF")) ; pkg::( … )
                     (format nil "#+cl-user::~a 1" (seam-fresh "FEAT"))                         ; was admitted: ()
                     (format nil "#-cl-user::~a 42" (seam-fresh "FEAT"))                        ; was admitted: 42
                     (format nil "#s(cl-user::~a)" (seam-fresh "S"))
                     (format nil "(list cl-user::~a #.1)" (seam-fresh "THEN"))                  ; then a reader error
                     (format nil "(list cl-user::~a" (seam-fresh "UNFINISHED"))                 ; then end of text
                     (format nil "(list :~a cl-user::~a)" (seam-fresh "KW") (seam-fresh "WITHKW")))))
       (outcomes (mapcar #'seam-code texts)))
  (report (equal census (seam-census))
          (format nil "R3 seam: the host census is unchanged across ~d refused or unfinished reads (every package but the source namespace and KEYWORD)" (length texts))
          (let ((after (seam-census)))
            (loop for (name . before) in census
                  for now = (cdr (assoc name after :test #'string=))
                  unless (eql before now) collect (list name before now))))
  (report (notany (lambda (o) (eq o :admitted)) outcomes)
          "R4 seam: none of them is admitted; a #+/#- feature expression naming a new host symbol is refused (disclosed change 2)"
          (loop for o in outcomes for tx in texts when (eq o :admitted) collect tx))
  (report (and (equal locks (seam-lock-state)) (equal *lock-state-before-any-read* (seam-lock-state)))
          "R5 seam: every package's lock state is as it was before the reads AND before this file's first read"
          (set-difference (seam-lock-state) *lock-state-before-any-read* :test #'equal)))
(let ((n (seam-fresh "R6")))
  (report (and (sb-ext:without-package-locks (equal (seam-code (format nil "(cl-user::~a)" n)) "E-READ"))
               (not (seam-present-p "CL-USER" n)))
          "R6 seam: the guard holds even inside a caller's WITHOUT-PACKAGE-LOCKS"
          (seam-present-p "CL-USER" n)))
(let ((before (seam-present-count "CL-USER")))
  (dotimes (i 50) (run (format nil "(cl-user::~a ~d)" (seam-fresh "ACC") i)))
  (report (= before (seam-present-count "CL-USER"))
          "R7 seam: fifty distinct refused programs add no symbol to CL-USER (no accumulation)"
          (list before (seam-present-count "CL-USER"))))
(multiple-value-bind (code err) (run-text-as-file-capturing (format nil "(cl-user::~a 1)~%" (seam-fresh "CMD")))
  (report (and (eql code 2) (search "E-READ" err) (search "Lock on package COMMON-LISP-USER" err)
               (not (search "E-SYNTAX" err)))
          "R8 seam, through the ONE command: a new CL-USER name exits 2 with E-READ from the package lock, not E-SYNTAX after interning"
          (format nil "exit ~a; stderr ~s" code err)))

;;; C — what must not change
(report (equal (mapcar #'seam-code '("(cl:eval 1)" "'cl:eval" "(cl-user::*here* 1)" "`x" "#'car" "'cl:quote"))
               '("E-SYNTAX" "E-SYNTAX" "E-SYNTAX" "E-SYNTAX" "E-SYNTAX" "E-SYNTAX"))
        "C1 seam: an EXISTING foreign symbol is still E-SYNTAX (cl:eval, 'cl:eval, cl-user::*here*, `x, #'car, 'cl:quote)"
        (mapcar #'seam-code '("(cl:eval 1)" "'cl:eval" "(cl-user::*here* 1)" "`x" "#'car" "'cl:quote")))
(report (equal (mapcar #'run '("(cl:quote x)" "(lisp-plus-program0::quote x)" "'x" "''x" "(quote Alpha)"))
               '("x" "x" "x" "(quote x)" "alpha"))
        "C2 seam: quote is unchanged, including the one admitted foreign head however it is spelled"
        (mapcar #'run '("(cl:quote x)" "(lisp-plus-program0::quote x)" "'x" "''x" "(quote Alpha)")))
(let ((k (seam-fresh "KEYWORD")))
  (report (and (equal (run (format nil ":~a" k)) (format nil ":~(~a~)" k))
               (seam-present-p "KEYWORD" k)
               (equal (run "(list :true :false)") "(true false)"))
          "C3 seam: a NEW keyword is still a value (KEYWORD stays open); :true and :false are unchanged"
          (list (run (format nil ":~a" k)) (seam-present-p "KEYWORD" k))))
(report (equal (mapcar #'run (list "\"cl-user::x\"" (format nil "; cl-user::x~%(+ 1 2)") "#| cl-user::x |# (+ 1 2)"
                                   "'|a:b|" "'a\\:b"))
               '("\"cl-user::x\"" "3" "3" "a:b" "a:b"))
        "C4 seam: package markers inside strings, comments, |…| and \\-escapes stay harmless"
        (mapcar #'run (list "\"cl-user::x\"" "'|a:b|" "'a\\:b")))
(report (equal (mapcar #'run '("1/2" "1.5" "(+ 1/2 1/3)" "#x1F")) '("1/2" "1.5" "5/6" "31"))
        "C5 seam: numbers read as before" (mapcar #'run '("1/2" "1.5" "(+ 1/2 1/3)" "#x1F")))
(fails-with "C6 seam: E-REDEFINE is untouched" "(define x 1) (define x 2)" "E-REDEFINE")
(report (equal (mapcar #'seam-code '("(define (f x) (+ x 1)" "(list cl-user::*here*" "(list :zzq-seam-kw" "(+ 1 2))"))
               '(:incomplete :incomplete :incomplete "E-READ"))
        "C7 seam: incomplete vs malformed is unchanged for text that names no NEW host symbol"
        (mapcar #'seam-code '("(define (f x) (+ x 1)" "(list cl-user::*here*" "(list :zzq-seam-kw" "(+ 1 2))")))
(let ((n (seam-fresh "C7B")))
  (report (and (equal (seam-code (format nil "(list cl-user::~a" n)) "E-READ")
               (not (seam-present-p "CL-USER" n)))
          "C7b seam: unfinished text naming a NEW host symbol is now MALFORMED (E-READ), not incomplete (disclosed change 3)"
          (seam-code (format nil "(list cl-user::~a" (seam-fresh "C7B")))))
(report (equal (mapcar #'run '("#+sbcl 1" "#-sbcl 1 2" "#+(or) (cl-user::zzq-seam-suppressed) 3"))
               '("1" "2" "3"))
        "C8 seam: feature expressions over existing names, and suppressed forms, read as before"
        (mapcar #'run '("#+sbcl 1" "#-sbcl 1 2" "#+(or) (cl-user::zzq-seam-suppressed) 3")))
(report (notany #'sb-ext:package-locked-p
                (list (find-package '#:lisp-plus-program0.source) (find-package "KEYWORD")
                      (find-package "CL-USER") (find-package '#:lisp-plus-program0)))
        "C9 seam: after every read the source namespace, KEYWORD, CL-USER and the implementation package are unlocked, as shipped"
        "")

;;; ---- 15. an uninterned symbol is a language error, not a host fault (2026-09-29) ----
;;; `#:x' reads as a symbol of NO package. The refusal message asked for that package's
;;; name, and the runner reported a HOST FAULT, exit 1. It is now E-SYNTAX: a symbol that
;;; is not a name of this language. (Claude Opus 5.5)
(multiple-value-bind (code err) (run-text-as-file-capturing (format nil "(list #:zzq-uninterned)~%"))
  (report (and (eql code 2) (search "E-SYNTAX" err) (search "uninterned" err) (not (search "HOST FAULT" err)))
          "#:x through the ONE command: exit 2 with E-SYNTAX (an uninterned symbol is not a name), not a host fault (exit 1)"
          (format nil "exit ~a; stderr ~s" code err)))

;;; ---- 16. #S is refused before anything is constructed (2026-09-29) -----------------
;;; `#S(name …)' made the CL reader call a host structure's constructor, and its slot
;;; initforms, DURING the read; the language refused the object only afterwards. The
;;; source is now read with *source-readtable*: the standard readtable except that active
;;; #S (and #s) is refused E-READ at the dispatch. Reader-suppressed #S behaves as before.
;;; The witness below counts every construction through a slot initform. (Astra's review
;;; vote of 2026-09-29; Claude Opus 5.5)
(defvar *sharp-s-constructed* 0)
(defstruct sharp-s-witness tag (seen (incf *sharp-s-constructed*)))
(defparameter +sharp-s-refusal+ "structure syntax is not part of this language")
(defun sharp-s-refused-p (text)
  "Through run-source: E-READ, located, with the #S refusal message."
  (multiple-value-bind (v e) (run text)
    (declare (ignore v))
    (and e (string= (program0-error-code e) "E-READ") (program0-error-location e)
         (not (typep e 'program0-incomplete-source))
         (search +sharp-s-refusal+ (program0-error-message e))
         t)))

(let* ((before *sharp-s-constructed*)
       (texts '("#s(program0-selftest::sharp-s-witness)" "#S(program0-selftest::sharp-s-witness)"
                "(list 1 #s(program0-selftest::sharp-s-witness :tag 5))"))
       (refused (mapcar #'sharp-s-refused-p texts))
       (constructed (- *sharp-s-constructed* before)))
  (report (and (every #'identity refused) (= constructed 0))
          "S1 #S: active #S/#s through run-source is refused E-READ, located, and the constructor witness stays 0"
          (format nil "refused ~s; constructor witness ran ~d time~:p" refused constructed)))
(multiple-value-bind (code err) (run-text-as-file-capturing (format nil "#s(lisp-plus-program0::refusal :kind :zzq)~%"))
  (report (and (eql code 2) (search "E-READ" err) (search +sharp-s-refusal+ err) (not (search "unsupported datum" err)))
          "S2 #S through the ONE command: exit 2, the #S refusal, and no built object in the message (it used to print the REFUSAL it had constructed)"
          (format nil "exit ~a; stderr ~s" code err)))
(let* ((before *sharp-s-constructed*)
       (seen (mapcar #'run '("#+(or) #s(x)" "#-sbcl #S(zzq)" "#+sbcl 1 #-sbcl #s(zzq)"
                               "(list 1 #+(or) #s(program0-selftest::sharp-s-witness) 3)"
                               "#+(or) #s(cl-user::zzq-sharp-s-suppressed) 4")))
       (constructed (- *sharp-s-constructed* before)))
  (report (and (equal seen '("()" "()" "1" "(1 3)" "4")) (= constructed 0))
          "S3 #S: reader-suppressed #S reads exactly as before (skipped, nothing constructed)"
          (format nil "values ~s; constructor witness ran ~d time~:p" seen constructed)))
(report (and (every #'sharp-s-refused-p '("#s(zzq-sharp-s-unread)" "#s()" "#s 1"))
             (not (find-symbol "ZZQ-SHARP-S-UNREAD" '#:lisp-plus-program0.source)))
        "S4 #S: refused at the dispatch, before the form after it is read (its name is never even interned)"
        (find-symbol "ZZQ-SHARP-S-UNREAD" '#:lisp-plus-program0.source))
(report (every #'sharp-s-refused-p '("(list #s(program0-selftest::sharp-s-witness" "(list #s(" "#s"))
        "S5 #S: unfinished active #S is MALFORMED (E-READ), no longer incomplete (disclosed change)"
        (mapcar (lambda (tx) (nth-value 1 (run tx))) '("(list #s(" "#s")))
(let ((standard-sharp-s (get-dispatch-macro-character #\# #\S (copy-readtable nil))))
  ;; compared with a FRESH standard readtable, not only with the snapshot: the snapshot is
  ;; taken after program0.lisp is loaded, so an edit made at load time would be in it too
  (report (and (eq *readtable* *global-readtable-before-any-read*)
               (eq *global-sharp-s-before-any-read* standard-sharp-s)
               (eq (get-dispatch-macro-character #\# #\S *readtable*) standard-sharp-s)
               (eq (get-dispatch-macro-character #\# #\s *readtable*) standard-sharp-s))
          "S6 #S: the host's global *readtable* is the same object as before any read, and its #S is still SBCL's standard one"
          (list (eq *readtable* *global-readtable-before-any-read*)
                (get-dispatch-macro-character #\# #\S *readtable*))))
(let* ((src lisp-plus-program0::*source-readtable*) (std (copy-readtable nil)) (diffs '()))
  (dotimes (i 256)
    (let ((c (code-char i)))
      (unless (char= c #\#)                     ; its function is a per-readtable dispatch closure
        (unless (equal (multiple-value-list (get-macro-character c src))
                       (multiple-value-list (get-macro-character c std)))
          (push (list :macro c) diffs)))
      (unless (or (char-equal c #\S)
                  (eq (ignore-errors (get-dispatch-macro-character #\# c src))
                      (ignore-errors (get-dispatch-macro-character #\# c std))))
        (push (list :dispatch c) diffs))))
  (unless (and (eq (readtable-case src) (readtable-case std))
               (eq (sb-ext:readtable-normalization src) (sb-ext:readtable-normalization std))
               (eq (sb-ext:readtable-base-char-preference src) (sb-ext:readtable-base-char-preference std)))
    (push :settings diffs))
  (report (null diffs)
          "S7 #S: the source readtable is the standard one except #S/#s (every other macro character, # sub-character, case and normalization)"
          diffs))
(report (equal (mapcar #'run (list "#x1F" "'(#1=(1 2) #1#)" "\"#s(x)\"" (format nil "; #s(x)~%(+ 1 2)") "#| #s(x) |# 7"))
               '("31" "((1 2) (1 2))" "\"#s(x)\"" "3" "7"))
        "S8 #S: other syntax, and #s inside strings and comments, read as before"
        (mapcar #'run (list "#x1F" "'(#1=(1 2) #1#)" "\"#s(x)\"")))

;;; ==== 2026-09-30: the promotion dossier's coverage gaps (sections 17–27) ======================
;;; Astra's disposition of dossier r0 (Q1(b)): the gap checks go into this suite, against the
;;; accepted implementation's unchanged bytes. The bracketed ids are the rows of
;;; _staging/2026-09-30-promotion-dossier/1-COVERAGE-PROGRAM-SPEC.md, and PEn are the rows of
;;; 2-README-EXAMPLES.md part A. Every expected value comes from PROGRAM-0-GRAMMAR-AND-SEMANTICS.md,
;;; README.md, or prelude.lp (which spec §5.2 names as the prelude's definition), never from a run
;;; of the implementation. Where those are silent, no check is written; the dossier lists the
;;; ambiguity instead. Checks that spawn a child process write only into a fresh mkdtemp directory,
;;; which is removed at the end. (KEEL, Claude Opus 5.5)

(defparameter *scratch* (sb-posix:mkdtemp (format nil "/tmp/program0-selftest-~d-XXXXXX" (sb-posix:getpid))))
(defun scratch-write (name text)
  (let ((path (format nil "~a/~a" *scratch* name)))
    (with-open-file (o path :direction :output :if-exists :supersede :external-format :utf-8)
      (write-string text o))
    path))
(defun spawn (program &rest args)
  "Run PROGRAM with ARGS as a child process. → (values exit-code stdout stderr)."
  (let* ((out (make-string-output-stream)) (err (make-string-output-stream))
         (proc (sb-ext:run-program "/usr/bin/env" (cons program args) :output out :error err :wait t)))
    (values (sb-ext:process-exit-code proc) (get-output-stream-string out) (get-output-stream-string err))))
(defun run-command (name text)
  "Write TEXT to <scratch>/NAME; run it through the ONE command. → (values exit-code stdout stderr)."
  (spawn "bash" (sb-ext:native-namestring (merge-pathnames "lisp-plus-run.sh" *here*)) (scratch-write name text)))
(defun error-header (stderr)
  "The first stderr line that begins `lisp-plus:'. Spec §9 sends load chatter to stderr, and it
precedes the error block, so the error block is found by its own first line."
  (with-input-from-string (s stderr)
    (loop for line = (read-line s nil) while line
          when (eql 0 (search "lisp-plus:" line)) return line)))
(defun run-in (env text)
  "RUN in a given environment: for checks that bind a small ceiling AFTER the prelude has loaded."
  (handler-case (values (render (run-source text env :source-name "test.lp")) nil)
    (program0-error (c) (values nil c))))
(defun run-capturing-output (text)
  "RUN, and also → what the program printed. *standard-output* is rebound only around the
evaluation, never around REPORT, so the check's own ok line is not swallowed."
  (let ((out (make-string-output-stream)))
    (multiple-value-bind (v e) (let ((*standard-output* out)) (run text))
      (values v e (get-output-stream-string out)))))
(defun read-kind (text)
  (multiple-value-bind (v e) (run text)
    (declare (ignore v))
    (cond ((null e) :no-error)
          ((not (string= (program0-error-code e) "E-READ")) :other-code)
          ((typep e 'program0-incomplete-source) :incomplete)
          (t :malformed))))

;;; ---- 17. the boolean aliases, on these bytes [2.6] (owner's decision 2026-09-30: kept) ------
(value-is "[2.6] :true IS true and :false IS false under eq?, and true and false are not eq?"
          "(list (eq? :true true) (eq? :false false) (eq? true false))" "(true true false)")
(value-is "[2.6] boolean? answers true for true, false, :true and :false"
          "(list (boolean? true) (boolean? false) (boolean? :true) (boolean? :false))" "(true true true true)")
(value-is "[2.6] keyword? answers true for true, false, :true and :false"
          "(list (keyword? true) (keyword? false) (keyword? :true) (keyword? :false))" "(true true true true)")
(value-is "[2.6] no other keyword is a boolean: (boolean? :maybe) is false" "(boolean? :maybe)" "false")
(value-is "[2.6] (if :true 1 2) selects the then-branch" "(if :true 1 2)" "1")
(value-is "[2.6] (if :false 1 2) selects the else-branch" "(if :false 1 2)" "2")
(fails-with "[2.6] (if :maybe 1 2) is E-TYPE" "(if :maybe 1 2)" "E-TYPE")
(value-is "[2.6] (equal? :false false) is true" "(equal? :false false)" "true")

;;; ---- 18. reading [1.2 1.3 1.6 1.8 1.10 1.12 1.13 1.21 1.24] -----------------------------------
(let* ((source (find-package '#:lisp-plus-program0.source))
       (symbols (car (first (read-source-forms "(car nil zzq-home-probe)" :source-name "home.lp")))))
  (report (and (null (package-use-list source))
               (= (length symbols) 3)
               (every (lambda (s) (and (symbolp s) (eq (symbol-package s) source))) symbols)
               (not (eq (first symbols) 'car)) (not (eq (second symbols) nil)))
          "[1.2] the source namespace uses no package; bare symbols a program writes (car, nil, a new name) are homed there, not in COMMON-LISP"
          (list (package-use-list source) (mapcar (lambda (s) (and (symbolp s) (package-name (symbol-package s)))) symbols))))
(value-is "[1.3] a float literal reads as a double-float: (= 0.1 0.1d0)" "(= 0.1 0.1d0)" "true")
(value-is "[1.3] 1.0e300 reads as a number (a single-float default refuses it at the reader)" "(number? 1.0e300)" "true")
(multiple-value-bind (v e) (run (format nil "(+ 1 2)~%  (1 . )"))
  (declare (ignore v))
  (report (and e (string= (program0-error-code e) "E-READ") (equal (program0-error-location e) '(2 . 2)))
          "[1.6] an E-READ in a LATER form is located at that form (line 2, column 2), not at the first form"
          (and e (list (program0-error-code e) (program0-error-location e)))))
(report (equal (mapcar #'read-kind '("(list #(1 2" "(list 1 #\\")) '(:incomplete :incomplete))
        "[1.8] text ending inside a # dispatch other than #| (an unfinished #( vector, a bare #\\) is INCOMPLETE"
        (mapcar #'read-kind '("(list #(1 2" "(list 1 #\\")))
(multiple-value-bind (code1 out1 err1) (run-command "unfinished.lp" (format nil "(+ 1 2)~%(list 1"))
  (multiple-value-bind (code2 out2 err2) (run-command "malformed.lp" (format nil "(+ 1 2)~%(1 . )"))
    (report (and (eql code1 2) (eql code2 2) (string= out1 "") (string= out2 "")
                 (equal (error-header err1) "lisp-plus: E-READ at unfinished.lp:2:0")
                 (equal (error-header err2) "lisp-plus: E-READ at malformed.lp:2:0"))
            "[1.10] through the ONE command an UNFINISHED file exits 2 with E-READ at its form, exactly as a MALFORMED one does"
            (list code1 (error-header err1) code2 (error-header err2)))))
(multiple-value-bind (code out) (run-command "empty.lp" "")
  (report (and (equal (run "") "()") (eql code 0) (string= out (format nil "()~%")))
          "[1.12] an empty source has the value (): run-source gives (), the ONE command prints () and exits 0"
          (list (run "") code out)))
(dolist (tx '("#c(1 2)" "'#c(1 2)" "(list #c(1 2))" "'#p\"x\"" "'#*101"))
  (fails-with (format nil "[1.13] ~a is refused at the source: E-READ (a complex number or other host object)" tx) tx "E-READ"))
(dolist (case '(("[1.21] pkg::( … ) naming a NEW host name is exactly E-READ (not E-SYNTAX, not incomplete), located, never interned" "(list cl-user::(~a 1))")
                ("[1.24] #+cl-user::<new> 1 is exactly E-READ, located, never interned" "#+cl-user::~a 1")
                ("[1.24] #-cl-user::<new> 42 is exactly E-READ, located, never interned" "#-cl-user::~a 42")))
  (destructuring-bind (name template) case
    (let ((fresh (seam-fresh "EXACT")))
      (multiple-value-bind (v e) (run (format nil template fresh))
        (report (and e (string= (program0-error-code e) "E-READ") (program0-error-location e)
                     (not (typep e 'program0-incomplete-source))
                     (not (seam-present-p "CL-USER" fresh)))
                name
                (list v (and e (program0-error-code e)) (and e (type-of e)) (seam-present-p "CL-USER" fresh)))))))

;;; ---- 19. values [2.1 2.2 2.8 2.9 2.11] ----------------------------------------------------------
(value-is "[2.1] a bignum stays exact: (10^20 - 1)^2" "(* 99999999999999999999 99999999999999999999)"
          "9999999999999999999800000000000000000001")
(value-is "[2.2] string? answers true for strings only" "(list (string? \"a\") (string? 1) (string? (quote a)) (string? :a))"
          "(true false false false)")
(value-is "[2.2] number->string gives a number's written form as a string"
          "(list (number->string 42) (number->string -7) (number->string 1/3) (string? (number->string 2.5)))"
          "(\"42\" \"-7\" \"1/3\" true)")
(fails-with "[2.2] number->string of a non-number is E-TYPE" "(number->string \"x\")" "E-TYPE")
(fails-with "[2.8] (cons 1 2) is E-TYPE: cons refuses a non-list second argument" "(cons 1 2)" "E-TYPE")
(value-is "[2.9] a named closure renders as #<function f>" "(define (f x) x) f" "#<function f>")
(value-is "[2.9] primitives render as #<primitive +> and #<primitive car>" "(list + car)" "(#<primitive +> #<primitive car>)")
(let* ((sources '("(define (f x) x) f" "+" "(kernel0/determinacy :mode :determinate)"
                  "(kernel0/determinacy :mode :determinate :confidence 1)"))
       (renderings (mapcar #'run sources))
       (codes (mapcar (lambda (r) (and r (let ((e (nth-value 1 (run r)))) (and e (program0-error-code e))))) renderings)))
  (report (and (every #'stringp renderings) (every (lambda (c) (equal c "E-READ")) codes))
          "[2.11] each printed #<…> (function, primitive, host value, refusal) fed back as source is E-READ"
          (mapcar #'list renderings codes)))

;;; ---- 20. names that may not be bound [3.1] --------------------------------------------------------
(let ((names '("define" "lambda" "let" "if" "cond" "quote" "begin" "and" "or" "true" "false" "else")))
  (dolist (position '(("a defined variable name" "(define ~a 1)")
                      ("a defined function name" "(define (~a) 1)")
                      ("a define parameter" "(define (f ~a) 1)")
                      ("a lambda parameter" "(lambda (~a) 1)")
                      ("a let-bound name" "(let ((~a 1)) 2)")))
    (destructuring-bind (what template) position
      (let ((wrong (loop for n in names
                         for e = (nth-value 1 (run (format nil template n)))
                         unless (and e (string= (program0-error-code e) "E-SYNTAX"))
                           collect (list n (and e (program0-error-code e))))))
        (report (null wrong) (format nil "[3.1] none of the 12 reserved names is admitted as ~a (each is E-SYNTAX)" what) wrong)))))

;;; ---- 21. forms [4.10 4.12 4.15 4.16 4.17] ---------------------------------------------------------
(value-is "[4.10] begin's value is its LAST form's" "(list (begin 1 2 3) (begin (quote a)))" "(3 a)")
(value-is "[4.10] begin evaluates in order: a define, then a use of it, whose value is begin's" "(begin (define z 5) (+ z 1))" "6")
(dolist (tx '("(quote a b)" "(quote)" "(define x)" "(define x 1 2)" "(define 1 2)" "(lambda x x)"
              "(let ((x)) x)" "(let (x) x)" "(let x 1)" "(cond 1)" "(if true 1 2 3)"))
  (fails-with (format nil "[4.12] ~a is the wrong shape: E-SYNTAX" tx) tx "E-SYNTAX"))
(multiple-value-bind (v e out) (run-capturing-output "(list (print 1) (print 2) (print 3))")
  (report (and (null e) (equal v "(1 2 3)") (equal out (format nil "1~%2~%3~%")))
          "[4.15] arguments are evaluated left to right (they print 1, 2, 3 in that order)" (list v out)))
(multiple-value-bind (v e out) (run-capturing-output "((begin (print 0) list) (print 1) (print 2))")
  (report (and (null e) (equal v "(1 2)") (equal out (format nil "0~%1~%2~%")))
          "[4.15] the operator is evaluated before the arguments (it prints 0 before 1 and 2)" (list v out)))
(fails-with "[4.16] a number in operator position is E-TYPE" "(1 2)" "E-TYPE")
(fails-with "[4.16] a list value in operator position is E-TYPE" "((list 1) 2)" "E-TYPE")
(fails-with "[4.16] a string in operator position is E-TYPE" "(\"s\" 1)" "E-TYPE")
(fails-with "[4.17] a non-boolean cond test is E-TYPE, even with an else clause" "(cond (1 2) (else 3))" "E-TYPE")
(fails-with "[4.17] or with a non-boolean after false is E-TYPE" "(or false 1)" "E-TYPE")
(fails-with "[4.17] or with a non-boolean first is E-TYPE" "(or 1 true)" "E-TYPE")

;;; ---- 22. primitives and the prelude [5.1a–g, 5.2] ---------------------------------------------------
;; max/min get several arguments here. Their arity is Card 1 (spec §5.1, the owner's word 2026-10-01): one
;; or more numbers, zero is E-ARITY; one and zero arguments are asserted in §36. (Corrected 2026-10-01.)
(value-is "[5.1a] abs, max and min on numbers" "(list (abs -5) (abs 5) (abs -5/2) (max 1 7 3) (min 4 -2 9))"
          "(5 5 5/2 7 -2)")
(dolist (case '(("abs of a string" "(abs \"x\")") ("max with a string" "(max 1 \"x\")") ("min of a keyword" "(min :a)")
                ("+ with a string" "(+ 1 \"x\")") ("* with a keyword" "(* :k 2)") ("- of a symbol" "(- (quote a))")
                ("/ by a boolean" "(/ 1 true)") ("< with a string" "(< 1 \"x\")") ("= on keywords" "(= :a :a)")))
  (destructuring-bind (what tx) case
    (fails-with (format nil "[5.1a/b] ~a is E-TYPE (numbers only): ~a" what tx) tx "E-TYPE")))
(fails-with "[5.1a] mod by 0 is E-ARITH" "(mod 5 0)" "E-ARITH")
(fails-with "[5.1a] quotient of a float is E-TYPE (integers only)" "(quotient 7.0 2)" "E-TYPE")
(fails-with "[5.1a] quotient of a ratio is E-TYPE (integers only)" "(quotient 1/2 1)" "E-TYPE")
(fails-with "[5.1a] mod by a ratio is E-TYPE (integers only)" "(mod 7 5/2)" "E-TYPE")
(value-is "[5.1b] <= and >= directly, variadic and chained over every adjacent pair"
          "(list (<= 1 1 2) (<= 1 3 2) (>= 3 3 1) (>= 3 1 2))" "(true false true false)")
(value-is "[5.1b] equal? is structural on nested lists (and on strings)"
          "(list (equal? (list 1 (list 2 3)) (list 1 (list 2 3))) (equal? (list 1 (list 2 3)) (list 1 (list 2 4))) (equal? (list 1 2) (list 1 2 3)) (equal? \"ab\" \"ab\"))"
          "(true false false true)")
(value-is "[5.1b] eq? on symbols and keywords: the same name is the same value, another name is not"
          "(list (eq? (quote a) (quote a)) (eq? (quote a) (quote b)) (eq? :k :k) (eq? :k :j))" "(true false true false)")
(value-is "[5.1c] not on the two booleans" "(list (not true) (not false))" "(false true)")
;; two lists here; Card 1 (spec §5.1): append takes zero or more lists; zero, one and several are in §36
(value-is "[5.1d] append joins two proper lists in order (an empty one included)"
          "(list (append (list 1 2) (list 3)) (append () (list 3)) (append (list 1) ()))" "((1 2 3) (3) (1))")
(fails-with "[5.1d] append of a non-list is E-TYPE" "(append (list 1) 2)" "E-TYPE")
(value-is "[5.1d] pair? and list? on non-empty lists and atoms"
          "(list (pair? (list 1)) (pair? 1) (pair? \"s\") (list? (list 1 2)) (list? 1) (list? \"s\"))"
          "(true false false true false false)")
(value-is "[5.1d] reverse of a non-empty list" "(reverse (list 1 2 3))" "(3 2 1)")
(fails-with "[5.1d] cdr of () is E-TYPE, never a silent ()" "(cdr ())" "E-TYPE")
(value-is "[5.1e] number? and integer?"
          "(list (number? 1) (number? 1/2) (number? 2.5) (number? \"1\") (number? :k) (integer? 3) (integer? 3/2) (integer? \"3\"))"
          "(true true true false false true false false)")
(value-is "[5.1e] symbol? is true of a quoted symbol only (not a keyword, a string, a boolean or ())"
          "(list (symbol? (quote a)) (symbol? :a) (symbol? \"a\") (symbol? true) (symbol? ()))" "(true false false false false)")
(value-is "[5.1g] refusal-kind: one request refused twice has one kind; K0E-33 and K0E-2 refusals have different kinds"
          "(define a (kernel0/determinacy :mode :determinate :confidence 0.8))
           (define a2 (kernel0/determinacy :mode :determinate :confidence 0.8))
           (define b (kernel0/determinacy :mode :fairly-sure))
           (list (equal? (refusal-kind a) (refusal-kind a2)) (equal? (refusal-kind a) (refusal-kind b)))"
          "(true false)")
(fails-with "[5.1g] refusal-kind of a non-refusal is E-TYPE" "(refusal-kind 1)" "E-TYPE")
(let ((kind (run "(refusal-kind (kernel0/determinacy :mode :determinate :confidence 0.8))")) (shown (run "(kernel0/determinacy :mode :determinate :confidence 0.8)")))
  (report (and (stringp kind) (stringp shown) (search (format nil "#<refused ~a requirement " (string-trim "\"" kind)) shown) t)
          "[5.1g] the Lisp+ PRIMITIVE refusal-kind (run as a program, its value rendered, quotes stripped) is the kind the same refusal's rendering shows (corrected 09-30, see §28)"
          (list kind shown)))
(value-is "[5.2] iota: (iota 4) is (range 0 4)" "(iota 4)" "(0 1 2 3)")
(value-is "[5.2] identity and constantly" "(list (identity 7) ((constantly 5) 99) (map (constantly 0) (list 1 2 3)))" "(7 5 (0 0 0))")
(value-is "[5.2] odd? zero? positive? negative?"
          "(list (odd? 3) (odd? 4) (zero? 0) (zero? 1) (positive? 2) (positive? -2) (negative? -1) (negative? 1))"
          "(true false true false true false true false)")
(value-is "[5.2] drop, last and zip" "(list (drop 2 (list 1 2 3 4)) (last (list 1 2 3)) (zip (list 1 2 3) (list :a :b :c)))"
          "((3 4) 3 ((1 :a) (2 :b) (3 :c)))")
(value-is "[5.2] product of a non-empty list" "(product (list 1 2 3 4))" "24")

;;; ---- 23. the defaults, pinned, and the ceilings at small limits [1.14 6.1 6.2] ------------------
(report (eql *max-source-nodes* 100000) "[1.14] *max-source-nodes* defaults to 100,000 conses" *max-source-nodes*)
(report (eql *step-budget* 1000000) "[6.1] *step-budget* defaults to 1,000,000 steps" *step-budget*)
(report (eql *depth-limit* 4000) "[6.2] *depth-limit* defaults to 4,000 nested user-function applications" *depth-limit*)
;; The call-depth convention, counted at *depth-limit* 3: THREE nested applications admitted, the
;; fourth refused. This is the spec's reading ("nested user-function applications admitted").
(let ((*depth-limit* 3))
  (value-is "[6.2] at *depth-limit* 3, three nested user applications (a, b, c) are admitted"
            "(define (a) (b)) (define (b) (c)) (define (c) 7) (a)" "7")
  (fails-with "[6.2] at *depth-limit* 3, a fourth nested application (a, b, c, d) is E-BUDGET naming depth"
              "(define (a) (b)) (define (b) (c)) (define (c) (d)) (define (d) 7) (a)" "E-BUDGET" :message-part "depth")
  (value-is "[6.2] depth counts NESTED user applications only: a primitive inside and calls made one after another do not add up"
            "(define (c) (+ 1 2)) (define (b) (c)) (define (a) (b)) (list (a) (a) (a) (a) (c) (c))" "(3 3 3 3 3 3)"))
;; Every evaluated form is one step; (+ 1 2) is four (the application, +, 1, 2). A budget of 3 is
;; below it under either counting convention (N admitted, or N-1), and 5 is above it under both.
(let ((env3 (make-global-environment)) (env5 (make-global-environment)))
  (multiple-value-bind (v3 e3) (let ((*step-budget* 3)) (run-in env3 "(+ 1 2)"))
    (multiple-value-bind (v5 e5) (let ((*step-budget* 5)) (run-in env5 "(+ 1 2)"))
      (report (and (null v3) e3 (string= (program0-error-code e3) "E-BUDGET")
                   (search "step budget" (program0-error-message e3))
                   (null e5) (equal v5 "3"))
              "[6.1] every evaluated form is one step: (+ 1 2), four forms, is E-BUDGET under *step-budget* 3 and admitted under 5"
              (list v3 (and e3 (program0-error-code e3)) v5 (and e5 (render-program0-error e5)))))))

;;; ---- 24. the Kernel /0 bridge and the durable-data boundary [7.1 7.2] ---------------------------
;;; The refusal's offending field and value are not reachable from a program, so they are read
;;; from the host object and compared with the kernel's own condition for the same arguments.
(dolist (case '(("(kernel0/determinacy :mode :determinate :confidence 0.8)" (:mode :determinate :confidence 0.8d0) :confidence 0.8d0)
                ("(kernel0/determinacy :mode :fairly-sure)" (:mode :fairly-sure) :mode :fairly-sure)))
  (destructuring-bind (text kernel-args field value) case
    (let ((r (handler-case (run-source text (make-global-environment)) (program0-error (c) c)))
          (k (handler-case (progn (apply #'lisp-plus-kernel0::make-determinacy kernel-args) nil) (error (c) c))))
      (report (and (refusal-p r) k
                   (eq (lisp-plus-program0::refusal-field r) field)
                   (eql (lisp-plus-program0::refusal-value r) value)
                   (eq (lisp-plus-program0::refusal-field r) (lisp-plus-kernel0::kernel0-condition-offending-field k))
                   (eql (lisp-plus-program0::refusal-value r) (lisp-plus-kernel0::kernel0-condition-offending-value k)))
              (format nil "[7.1] the refusal VALUE for ~a carries the kernel's offending field ~s and value ~s" text field value)
              (list (and (refusal-p r) (list (lisp-plus-program0::refusal-field r) (lisp-plus-program0::refusal-value r)))
                    (and k (list (lisp-plus-kernel0::kernel0-condition-offending-field k)
                                 (lisp-plus-kernel0::kernel0-condition-offending-value k))))))))
(fails-with "[7.2] a refusal may not cross into a Kernel /0 constructor: E-BOUNDARY"
            "(define r (kernel0/determinacy :mode :determinate :confidence 0.8)) (kernel0/determinacy :mode r)" "E-BOUNDARY")
(fails-with "[7.2] a host value may not cross either: E-BOUNDARY"
            "(define h (kernel0/determinacy :mode :determinate)) (kernel0/determinacy :mode h)" "E-BOUNDARY")
(fails-with "[7.2] a quoted symbol may not cross: E-BOUNDARY" "(kernel0/determinacy :mode (quote determinate))" "E-BOUNDARY")
(fails-with "[7.2] a list holding a symbol may not cross: E-BOUNDARY" "(kernel0/determinacy :mode (list 1 (quote a)))" "E-BOUNDARY")
(value-is "[7.2] a proper list of admissible values DOES cross: the kernel answers with a value (refusal or record), not E-BOUNDARY"
          "(define r (kernel0/determinacy :mode (list :determinate 1 \"a\" (list 2)))) (or (refused? r) (host-value? r))" "true")

;;; ---- 25. the error condition [8.1 8.2] --------------------------------------------------------------
(let ((codes (mapcar #'car lisp-plus-program0::+error-codes+))
      (spec-codes '("E-READ" "E-SYNTAX" "E-UNBOUND" "E-REDEFINE" "E-ARITY" "E-TYPE" "E-ARITH" "E-BUDGET" "E-BOUNDARY"))
      (tenth (handler-case (progn (lisp-plus-program0::fail "E-NOT-A-CODE" "x") :no-error)
               (program0-error () :signalled-as-a-language-error)
               (error () :refused))))
  (report (and (= (length codes) 9) (null (set-exclusive-or codes spec-codes :test #'string=)) (eq tenth :refused))
          "[8.1] the code vocabulary is exactly spec §8's nine codes, and a tenth code cannot be signalled"
          (list codes tenth)))
(multiple-value-bind (v e) (run "(define (f x) (+ x (car (list nosuch)))) (list 1 (f 10))")
  (declare (ignore v))
  (let ((path (and e (mapcar #'render (program0-error-path e)))))
    (report (equal path '("nosuch" "(list nosuch)" "(car (list nosuch))"))
            "[8.2] the error carries the innermost forms under evaluation: three at most, innermost first"
            path)))

;;; ---- 26. the runner [8.3 9.2 9.3 9.6, exit 1] ----------------------------------------------------
;;; Astra: "establish PROGRAM runner status and located diagnostic" for each of the nine codes.
;;; The failing form is never at line 1, column 0. Stderr begins with the Kernel /0 load chatter
;;; (spec §9 sends it there), so the check reads the first line that begins `lisp-plus:'.
(dolist (case '(("E-READ"     "e-read.lp"     "(+ 1 2)~%  (1 . )~%"                           "2:2")
                ("E-SYNTAX"   "e-syntax.lp"   "(+ 1 2) (if true 1)~%"                          "1:8")
                ("E-UNBOUND"  "e-unbound.lp"  "(+ 1 2)~%~%   nosuch~%"                          "3:3")
                ("E-REDEFINE" "e-redefine.lp" "(define x 1)~% (define x 2)~%"                  "2:1")
                ("E-ARITY"    "e-arity.lp"    "(define (f a) a)~%    (f 1 2)~%"                "2:4")
                ("E-TYPE"     "e-type.lp"     "1~%2~%  (car ())~%"                             "3:2")
                ("E-ARITH"    "e-arith.lp"    "(define z 0)~%~%~% (/ 1 z)~%"                    "4:1")
                ("E-BUDGET"   "e-budget.lp"   "(define (f) (f))~%  (f)~%"                      "2:2")
                ("E-BOUNDARY" "e-boundary.lp" "(+ 1 2)~%     (kernel0/determinacy :mode car)~%" "2:5")))
  (destructuring-bind (code file template where) case
    (multiple-value-bind (exit out err) (run-command file (format nil template))
      (let ((want (format nil "lisp-plus: ~a at ~a:~a" code file where)))
        (report (and (eql exit 2) (string= out "") (equal (error-header err) want) (not (search "HOST FAULT" err)))
                (format nil "[8.3] ~a through the ONE command: exit 2, nothing on stdout, stderr's error line ~s" code want)
                (format nil "exit ~a; stdout ~s; error line ~s" exit out (error-header err)))))))
(multiple-value-bind (code1 out1) (run-command "final-define-fn.lp" (format nil "(define (sq x) (* x x))~%"))
  (multiple-value-bind (code2 out2) (run-command "final-define-var.lp" (format nil "(+ 1 2)~%(define y 5)~%"))
    (report (and (eql code1 0) (string= out1 (format nil "; defined sq~%")) (eql code2 0) (string= out2 (format nil "; defined y~%")))
            "[9.2] a program whose last form is a define prints `; defined <name>` and exits 0 (a function and a variable)"
            (list code1 out1 code2 out2))))
(multiple-value-bind (code1 out1 err1) (spawn "bash" (sb-ext:native-namestring (merge-pathnames "lisp-plus-run.sh" *here*)))
  (multiple-value-bind (code2 out2 err2) (spawn "sbcl" "--script" (sb-ext:native-namestring (merge-pathnames "run.lisp" *here*)))
    (report (and (eql code1 3) (string= out1 "") (search "usage" err1) (eql code2 3) (string= out2 "") (search "usage" err2))
            "[9.3] no file argument: exit 3 and a usage line on stderr, through the ONE command and through run.lisp directly"
            (list code1 err1 code2 (error-header err2)))))
;;; FAULT INJECTION (labelled as such). Each child loads the SHIPPED run.lisp through a small
;;; wrapper written into the scratch directory; no shipped file changes. This is synthetic branch
;;; evidence: it does not establish portability or a naturally occurring host fault. Each has a
;;; control: the same wrapper without the fault runs the program normally.
(let* ((run-lisp (namestring (merge-pathnames "run.lisp" *here*)))
       (program (scratch-write "fault-ok.lp" (format nil "(+ 1 2)~%")))
       (injected (scratch-write "inject-version.lisp"
                                (format nil "(sb-ext:without-package-locks~%  (setf (fdefinition 'lisp-implementation-version) (lambda () \"9.9.9-test\")))~%(load ~s)~%" run-lisp)))
       (control (scratch-write "inject-version-control.lisp" (format nil "(load ~s)~%" run-lisp))))
  (multiple-value-bind (code1 out1 err1) (spawn "sbcl" "--script" injected program)
    (multiple-value-bind (code2 out2) (spawn "sbcl" "--control-stack-size" "64MB" "--script" control program)
      ;; The spec says the runner REFUSES another version; it names no exit code for that, so
      ;; the check asserts a refusal (not 0, not a language error) and the message, not the code.
      (report (and (not (member code1 '(0 2))) (string= out1 "")
                   (search "2.4.6" err1) (search "9.9.9-test" err1)
                   (eql code2 0) (string= out2 (format nil "3~%")))
              "[9.6] (fault injection) a child whose lisp-implementation-version answers 9.9.9-test is refused, naming 2.4.6 and 9.9.9-test; without the override the same wrapper runs"
              (list code1 out1 err1 code2 out2)))))
(defparameter +host-fault-injection+
  "(defparameter cl-user::*zzq-real-load* (fdefinition 'load))
(sb-ext:without-package-locks
  (setf (fdefinition 'load)
        (lambda (file &rest args)
          (multiple-value-prog1 (apply cl-user::*zzq-real-load* file args)
            (when (equal (pathname-name (pathname file)) ~s)
              (setf (fdefinition (find-symbol \"READ-FILE-TEXT\" \"LISP-PLUS-PROGRAM0\"))
                    (lambda (p) (declare (ignore p)) (error \"zzq injected host fault\"))))))))
(funcall cl-user::*zzq-real-load* ~s)
"
  "A wrapper that loads run.lisp and, right after program0.lisp has loaded, replaces its file
reader with one that signals a plain CL ERROR. ~s = the file name the hook fires on, ~s = run.lisp.")
(let* ((run-lisp (namestring (merge-pathnames "run.lisp" *here*)))
       (program (scratch-write "fault-ok.lp" (format nil "(+ 1 2)~%")))
       (injected (scratch-write "inject-host-fault.lisp" (format nil +host-fault-injection+ "program0" run-lisp)))
       (control (scratch-write "inject-host-fault-control.lisp" (format nil +host-fault-injection+ "zzq-no-such-file" run-lisp))))
  (multiple-value-bind (code1 out1 err1) (spawn "sbcl" "--control-stack-size" "64MB" "--script" injected program)
    (multiple-value-bind (code2 out2) (spawn "sbcl" "--control-stack-size" "64MB" "--script" control program)
      ;; "not rendered as a language error" = no `lisp-plus: E-…' line. (First run 2026-09-30: this
      ;; asked for NO `lisp-plus:' line at all, but the host-fault line begins `lisp-plus: HOST
      ;; FAULT', so the check was wrong, not the runner. Corrected before the second run.)
      (report (and (eql code1 1) (string= out1 "") (search "zzq injected host fault" err1) (search "defect" err1)
                   (not (search "lisp-plus: E-" err1))
                   (eql code2 0) (string= out2 (format nil "3~%")))
              "[9.3] (fault injection) a host condition that is none of §8 exits 1, labelled a defect, not rendered as a language error; the control exits 0"
              (list code1 out1 err1 code2 out2)))))

;;; ---- 27. the PROGRAM README's own examples, literally [G-G] ---------------------------------------
;;; Each check first finds its literal text in README.md (so a README edit that changes the example
;;; fails here), then runs it with the setup the README states and compares the advertised result.
(defparameter *readme-text*
  (with-open-file (in (merge-pathnames "README.md" *here*) :external-format :utf-8)
    (let ((s (make-string (file-length in)))) (subseq s 0 (read-sequence s in)))))
(defun readme-has (text) (and (search text *readme-text*) t))
(defun readme-example (name literal expected &key setup after)
  "Run SETUP, LITERAL and AFTER as one program; its value must render as EXPECTED. SETUP and LITERAL
must both be in README.md verbatim."
  (multiple-value-bind (v e) (run (format nil "~@[~a~%~]~a~@[~%~a~]" setup literal after))
    (report (and (readme-has literal) (or (null setup) (readme-has setup)) (null e) (equal v expected))
            name
            (cond ((not (readme-has literal)) "the literal text is not in README.md")
                  ((and setup (not (readme-has setup))) "the setup text is not in README.md")
                  (e (render-program0-error e))
                  (t (format nil "got ~a, expected ~a" v expected))))))

(let ((hello "(define (greet name)
  (string-append \"hello, \" name))

(greet \"world\")"))
  (multiple-value-bind (code out) (run-command "hello.lp" (format nil "~a~%" hello))
    (report (and (readme-has hello) (readme-has "hello.lp` → `\"hello, world\"`")
                 (eql code 0) (string= out (format nil "\"hello, world\"~%")))
            "[PE2 README:30-38] hello.lp through the ONE command prints \"hello, world\" (quoted, as a value) and exits 0"
            (list code out))))
(readme-example "[PE4 README:56-59] the nested let is 3, after (define x 1) (README:46)"
                "(let ((x 2))
  (let ((x 3)) x))         ; → 3, and the outer x is still 1" "3" :setup "(define x 1)")
(readme-example "[PE4 README:56-59] ...and the outer x is still 1 after it"
                "(let ((x 2))
  (let ((x 3)) x))         ; → 3, and the outer x is still 1" "1" :setup "(define x 1)" :after "x")
(readme-example "[PE8 README:90-95] factorial with an internal go helper is 3628800"
                "(define (factorial n)
  (define (go n acc) (if (= n 0) acc (go (- n 1) (* acc n))))
  (go n 1))
(factorial 10)             ; → 3628800" "3628800")
(readme-example "[PE14 README:111-112] pipeline over (range 1 11) is 220"
                "(define (pipeline xs) (sum (map square (filter even? xs))))
(pipeline (range 1 11))                   ; → 220" "220")
(readme-example "[PE15 README:114] ((compose square square) 3) is 81"
                "((compose square square) 3)               ; → 81" "81")
(readme-example "[PE17 README:126] (if (< 1 2) (quote yes) (quote no)) is yes"
                "(if (< 1 2) (quote yes) (quote no))       ; → yes" "yes")
(readme-example "[PE19 README:128] the cond falls to else: b"
                "(cond ((= 1 2) (quote a)) (else (quote b))) ; → b" "b")
(readme-example "[PE20 README:129] (and (< 1 2) (< 2 3)) is true"
                "(and (< 1 2) (< 2 3))                     ; → true" "true")
(defparameter +readme-kernel-setup+ "(define plain     (kernel0/determinacy :mode :determinate))
(define confident (kernel0/determinacy :mode :determinate :confidence 0.8))")
(readme-example "[PE22 README:139-143] (kernel0/determinacy-mode plain) is :determinate"
                "(kernel0/determinacy-mode plain)           ; → :determinate" ":determinate" :setup +readme-kernel-setup+)
(let* ((literal "(refusal-law confident)                    ; → \"§7.5 and Errata 0.2 §6: determinacy MUST NOT carry a global confidence, ...\"")
       (documented "§7.5 and Errata 0.2 §6: determinacy MUST NOT carry a global confidence")
       (law (handler-case (run-source (format nil "~a~%~a" +readme-kernel-setup+ literal) (make-global-environment))
              (program0-error (c) c))))
  (report (and (readme-has literal) (readme-has +readme-kernel-setup+)
               (stringp law) (eql 0 (search documented law)))
          "[PE25 README:139-146] (refusal-law confident) is a string beginning with the README's text (its \"...\" an abbreviation)"
          (if (typep law 'condition) (render-program0-error law) law)))
(let ((program "(define (f x)
  (+ x nosuch))

(f 10)")
      (block "lisp-plus: E-UNBOUND at err.lp:4:0
  unknown name `nosuch`
  in: nosuch
  within: (+ x nosuch) · (f 10)
  frames: f
  (a name has no binding)"))
  (multiple-value-bind (code out err) (run-command "err.lp" (format nil "~a~%" program))
    (let ((from-error-line (let ((p (search "lisp-plus:" err))) (and p (subseq err p)))))
      (report (and (readme-has program) (readme-has block) (eql code 2) (string= out "")
                   (equal from-error-line (format nil "~a~%" block)))
              "[PE28 README:167-182] err.lp through the ONE command exits 2; stderr from its lisp-plus: line on is the README's six-line block, byte for byte (the file prints as err.lp; nothing normalized)"
              (list code from-error-line)))))
(multiple-value-bind (v e) (run "(define (f) (f)) (f)")
  (declare (ignore v))
  (report (and (readme-has "`(define (f) (f)) (f)` is refused") e (string= (program0-error-code e) "E-BUDGET"))
          "[PE30 README:195] (define (f) (f)) (f) is refused: E-BUDGET"
          (and e (program0-error-code e))))
(multiple-value-bind (v e) (run "(sum (range 1 1000))")
  (report (and (readme-has "`(sum (range 1 1000))` runs") (null e) (equal v "499500"))
          "[PE31 README:197] (sum (range 1 1000)) runs, literally: 499500 (1 + … + 999)"
          (if e (render-program0-error e) v)))
(multiple-value-bind (v e) (run "(map square (range 0 5000))")
  (declare (ignore v))
  (report (and (readme-has "`(map square (range 0 5000))` is `E-BUDGET`") e (string= (program0-error-code e) "E-BUDGET"))
          "[PE31 README:197] (map square (range 0 5000)) is E-BUDGET, literally"
          (and e (program0-error-code e))))
(value-is "[PE32 README:199] number->string makes a string that string-append accepts"
          "(string-append \"n = \" (number->string 42))" "\"n = 42\"")

;;; the scratch directory goes, with everything the checks above wrote into it
(dolist (f (directory (merge-pathnames (make-pathname :name :wild :type :wild) (format nil "~a/" *scratch*))))
  (delete-file f))
(sb-posix:rmdir *scratch*)

;;; ---- 28. repair round, 2026-09-30 (outside reader ASSAYER; the chair "Nearby Is Not Covered") ------
;;; (a) L770–773, corrected IN PLACE with the same line count: the old check called the HOST
;;;     accessor `refusal-kind' (exported by lisp-plus-program0) and compared it with RENDER,
;;;     which prints the kind with that same accessor, so it could not fail. It now runs the
;;;     Lisp+ PRIMITIVE through a program and compares that value with the rendering.
;;; (b) The kind predicates were checked mostly where they answer true. Each below must also
;;;     answer false on non-members, so an always-true (or always-false) predicate fails.
;;; (c) Argument refusals for primitives that had none. Each case uses a value whose kind is
;;;     outside the primitive's domain in spec §5.1 (numbers, lists, strings) or §7.1 (a
;;;     determinacy host value, a refusal), and never a function, refusal or host value where
;;;     E-BOUNDARY ("may not cross into the host") could be argued instead. (KEEL, Claude Opus 5.5)
(value-is "[5.1e] function? is true of a primitive and a closure, false of a number, string, symbol, () and keyword"
          "(list (function? car) (function? (lambda (x) x)) (function? 1) (function? \"s\") (function? (quote a)) (function? ()) (function? :k))"
          "(true true false false false false false)")
(value-is "[5.1e] keyword? is true of :k, false of a symbol, a string, a number and ()"
          "(list (keyword? :k) (keyword? (quote a)) (keyword? \"k\") (keyword? 1) (keyword? ()))"
          "(true false false false false)")
(value-is "[5.1e] host-value? is true of a kernel record, false of a number, a REFUSAL, a primitive and ()"
          "(list (host-value? (kernel0/determinacy :mode :determinate)) (host-value? 1) (host-value? (kernel0/determinacy :mode :determinate :confidence 0.8)) (host-value? car) (host-value? ()))"
          "(true false false false false)")
(value-is "[5.1e] refused? is true of a refusal, false of a number, a HOST VALUE, a requirement-id string and ()"
          "(list (refused? (kernel0/determinacy :mode :determinate :confidence 0.8)) (refused? 1) (refused? (kernel0/determinacy :mode :determinate)) (refused? \"K0E-33\") (refused? ()))"
          "(true false false false false)")
(dolist (case '(("> with a string" "(> 1 \"x\")") ("<= with a keyword" "(<= 1 :a)") (">= with a symbol" "(>= (quote a) 1)")
                ("length of a number" "(length 5)") ("length of a keyword" "(length :k)")
                ("reverse of a number" "(reverse 5)") ("reverse of a keyword" "(reverse :k)")
                ("string-append with a number" "(string-append \"a\" 1)") ("string-append of a keyword" "(string-append :a)")
                ("kernel0/determinacy-mode of a number" "(kernel0/determinacy-mode 1)")
                ("kernel0/determinacy-mode of a keyword" "(kernel0/determinacy-mode :determinate)")
                ("refusal-requirement of a number" "(refusal-requirement 1)")
                ("refusal-requirement of a string" "(refusal-requirement \"K0E-33\")")
                ("refusal-law of a number" "(refusal-law 1)") ("refusal-law of a keyword" "(refusal-law :law)")))
  (destructuring-bind (what tx) case
    (fails-with (format nil "[5.1] ~a is E-TYPE, located: ~a" what tx) tx "E-TYPE")))

;;; ==== r2, 2026-09-30: the bounded repair's regressions and remaining evidence (sections 29–34) ===============
;;; Governing texts: Astra's r1 disposition (corpus/voices/received/originals/2026-09-30-164616-astra-program-repl-0-
;;; dossier-r1-disposition/01-DISPOSITION.md); the r2 work order (_staging/2026-09-30-promotion-dossier/R2-WORK-ORDER.md,
;;; "WO n" below is its item n); the owner's word on F-2 and F-3 (corpus/voices/received/2026-09-30-164743-owner-word-
;;; PROGRAM-0-INPUT-POLICY-F2-F3-VERBATIM.md); the chair's pinned contracts (r2/briefs/00-COMMON.md); the spec; README.md.
;;; Written BEFORE the fixes, by a hand that does not write them. On the r1b production bytes the F-1, F-2 and F-3
;;; checks below are RED by design; that log is the known-failure fixture (r2/old-red/), kept outside the passing count.
;;; Expected values come from those texts, never from a run. Children write only into a fresh mkdtemp directory,
;;; removed at the end.
;;; WO 16 (the test-path wildcard): `namestring' escapes `?', `*' and `[' in a Lisp namestring, so a lane under such a
;;; path broke 27 runner checks with exit 127. The argv strings handed to child processes in §11, §12, §14's
;;; run-text-as-file-capturing, run-command (before §17) and §26's [9.3] now use sb-ext:native-namestring. The two
;;; fault-injection wrappers in §26 keep `namestring': their path is read back by LOAD, which parses a Lisp namestring.
;;; (LEADSMAN, Claude Opus 5.5)

(setf *scratch* (sb-posix:mkdtemp (format nil "/tmp/program0-selftest-r2-~d-XXXXXX" (sb-posix:getpid))))
(defparameter *r2-one-command* (sb-ext:native-namestring (merge-pathnames "lisp-plus-run.sh" *here*)))
(defparameter *r2-run-lisp* (sb-ext:native-namestring (merge-pathnames "run.lisp" *here*)))
(defun scratch-write-octets (name &rest parts)
  "Write PARTS to <scratch>/NAME as raw octets: a string part is encoded as UTF-8, an integer part is one octet.
The only way this suite makes a file that is not valid UTF-8; no binary file is kept in the tree."
  (let ((path (format nil "~a/~a" *scratch* name)))
    (with-open-file (o path :direction :output :if-exists :supersede :element-type '(unsigned-byte 8))
      (dolist (p parts)
        (if (integerp p)
            (write-byte p o)
            (write-sequence (sb-ext:string-to-octets p :external-format :utf-8) o))))
    path))
(defun from-error-line (stderr)
  "STDERR from its first `lisp-plus:' on (the load chatter before it is §9's, not the diagnostic's)."
  (subseq stderr (or (search "lisp-plus:" stderr) 0)))
(defun names-a-form-location-p (stderr name)
  "Does STDERR carry NAME:LINE:COL anywhere, the top-level-form location of spec §8?"
  (flet ((digits-end (j)
           (let ((k j))
             (loop while (and (< k (length stderr)) (digit-char-p (char stderr k))) do (incf k))
             (and (> k j) k))))
    (loop for start = (search name stderr) then (search name stderr :start2 (1+ start))
          while start
          thereis (let* ((i (+ start (length name)))
                         (k (and (< i (length stderr)) (char= (char stderr i) #\:) (digits-end (1+ i)))))
                    (and k (< k (length stderr)) (char= (char stderr k) #\:) (digits-end (1+ k)))))))
(defun carries-form-context-p (stderr)
  "Does STDERR carry an `in:', `within:' or `frames:' line, spec §8's forms under evaluation and frames?"
  (with-input-from-string (s stderr)
    (loop for line = (read-line s nil) while line
          thereis (let ((l (string-left-trim " " line)))
                    (some (lambda (p) (eql 0 (search p l))) '("in:" "within:" "frames:"))))))

;;; ---- 29. F-1: the step budget admits N [WO 1] --------------------------------------------------------------------
;;; Spec §6: `*step-budget*' is the "evaluation steps admitted to one run (default 1,000,000; every evaluated form is
;;; one step)". Astra: "repair the off-by-one; do not redefine N as N−1". `1' is one evaluated form; `(+ 1 2)' is four
;;; (the application, +, 1 and 2). The state is the real entry path's: run.lisp → run-file, whose default ENV argument
;;; (make-global-environment) runs the prelude under the default budget FIRST; then the program's own run-source binds
;;; *steps* to 0 and ticks against *step-budget*. So the environment is built first, and only the budget around the
;;; program's run-source (RUN-IN) is small. §23's check (3 refuses, 5 admits) stays; it does not pin the boundary.
(flet ((under-budget (n text)
         (let ((env (make-global-environment)))
           (let ((*step-budget* n)) (run-in env text)))))
  (multiple-value-bind (v e) (under-budget 1 "1")
    (report (and (null e) (equal v "1"))
            "[F-1 · WO 1 · spec §6 \"steps admitted … every evaluated form is one step\"] *step-budget* 1 admits `1`, one evaluated form: its value 1"
            (if e (render-program0-error e) v)))
  (multiple-value-bind (v e) (under-budget 4 "(+ 1 2)")
    (report (and (null e) (equal v "3"))
            "[F-1 · WO 1 · spec §6] *step-budget* 4 admits `(+ 1 2)`, four evaluated forms: its value 3"
            (if e (render-program0-error e) v)))
  (multiple-value-bind (v e) (under-budget 3 "(+ 1 2)")
    (report (and (null v) e (string= (program0-error-code e) "E-BUDGET") (program0-error-location e)
                 (search "step budget" (program0-error-message e)))
            "[F-1 · WO 1 · spec §6] *step-budget* 3 refuses `(+ 1 2)`, one evaluation too many: E-BUDGET, located, naming the step budget"
            (if e (render-program0-error e) v))))

;;; ---- 30. F-2: a directory is a usage error, exit 3 [WO 3] --------------------------------------------------------
;;; The owner's word: "Usage error, exit 3 (Recommended)". Spec §9 at r1b: "`3` usage (no file / no such file)"; r2 adds "a directory". The pinned
;;; contract: through lisp-plus-run.sh AND run.lisp directly (as §26's [9.3] runs it), the directory spelled with and
;;; without a trailing slash: exit 3; nothing on stdout; stderr names the given path and contains the word `directory';
;;; no HOST FAULT; refused before any read is attempted. The directory is named like a program, so only its being a
;;; directory can refuse it. "Names the given path" is checked as the path without its trailing slash, which both
;;; spellings share.
(defparameter *r2-directory* (format nil "~a/looks-like-a-program.lp" *scratch*))
(sb-posix:mkdir *r2-directory* #o755)
(dolist (spelling (list *r2-directory* (format nil "~a/" *r2-directory*)))
  (dolist (route (list (list "lisp-plus-run.sh" "bash" *r2-one-command*) (list "run.lisp" "sbcl" "--script" *r2-run-lisp*)))
    (multiple-value-bind (code out err) (apply #'spawn (append (rest route) (list spelling)))
      (report (and (eql code 3) (string= out "") (search *r2-directory* err) (search "directory" err)
                   (not (search "HOST FAULT" err)))
              (format nil "[F-2 · WO 3 · owner's word \"Usage error, exit 3\" · spec §9 \"3 usage\"] a DIRECTORY given to ~a, ~:[without~;with~] a trailing slash: exit 3, nothing on stdout, stderr names the path and says `directory', no HOST FAULT"
                      (first route) (char= #\/ (char spelling (1- (length spelling)))))
              (format nil "exit ~a; stdout ~s; stderr ~s" code out (from-error-line err))))))
;;; "Refused before any read is attempted" (WO 3: "refuse a directory before reading it"). WITNESS WRAPPER, labelled:
;;; a child loads the SHIPPED run.lisp through a wrapper in the scratch directory that replaces CL:OPEN with one that,
;;; asked to open a DIRECTORY for anything but :probe, writes a marker to stderr and ends the child at once (exit 97,
;;; :abort t), so no handler in the runner can swallow the witness; no shipped file changes. A runner that tries to
;;; read the directory is caught at its open. The control: the same wrapper runs an ordinary file normally.
(defparameter +open-witness-wrapper+
  "(defparameter cl-user::*zzq-real-open* (fdefinition 'open))
(sb-ext:without-package-locks
  (setf (fdefinition 'open)
        (lambda (file &rest args &key (direction :input) &allow-other-keys)
          (let ((p (and (not (eq direction :probe)) (ignore-errors (probe-file file)))))
            (when (and p (null (pathname-name p)) (null (pathname-type p)))
              (format *error-output* \"zzq-open-witness: an open of the directory ~~a was attempted~~%\" p)
              (finish-output *error-output*)
              (sb-ext:exit :code 97 :abort t)))
          (apply cl-user::*zzq-real-open* file args))))
(load ~s)
"
  "A wrapper that loads run.lisp (~s, a Lisp namestring, since LOAD parses it) with CL:OPEN refusing directories.")
(let* ((wrapper (scratch-write "open-witness.lisp"
                               (format nil +open-witness-wrapper+ (namestring (merge-pathnames "run.lisp" *here*)))))
       (program (scratch-write "open-witness-control.lp" (format nil "(+ 1 2)~%"))))
  (multiple-value-bind (code0 out0) (spawn "sbcl" "--control-stack-size" "64MB" "--script" wrapper program)
    (dolist (spelling (list *r2-directory* (format nil "~a/" *r2-directory*)))
      (multiple-value-bind (code out err) (spawn "sbcl" "--script" wrapper spelling)
        (report (and (eql code 3) (string= out "") (not (search "zzq-open-witness" err))
                     (eql code0 0) (string= out0 (format nil "3~%")))
                (format nil "[F-2 · WO 3 \"refuse a directory before reading it\"] (witness wrapper) run.lisp given the directory ~:[without~;with~] a trailing slash exits 3 without opening it; the same wrapper runs an ordinary file (exit 0, 3)"
                        (char= #\/ (char spelling (1- (length spelling)))))
                (format nil "exit ~a; stdout ~s; stderr ~s; control exit ~a stdout ~s" code out (from-error-line err) code0 out0))))))

;;; ---- 31. F-3: a source that is not UTF-8 is E-READ, exit 2 [WO 4] ------------------------------------------------
;;; The owner's word: "E-READ, exit 2 (Recommended)". Spec §1: "A source is a UTF-8 text … A reader failure is E-READ".
;;; Astra: "Identify the file and any reliably available decoding position; do not invent a top-level-form location for
;;; text that never decoded." The pinned contract: exit 2; nothing on stdout; the diagnostic carries E-READ and names
;;; the file (at least its file-namestring); no HOST FAULT; no top-level-form location. An ordinary reader error renders
;;; `lisp-plus: E-READ at NAME:LINE:COL' (render-program0-error; §18's [1.10], §26's [8.3]), with in:/within:/frames:
;;; lines beneath it when the error has forms or frames, so both are asserted ABSENT. A byte offset MAY appear; it is not
;;; asserted. Each file's bad octets come after a complete first form, so a runner that located them at a form would
;;; have a form to name.
(dolist (case (list (list "a stray #xFF between two forms" "not-utf8-stray-ff.lp"
                          (list (format nil "(+ 1 2)~%") #xFF (format nil "~%(+ 3 4)~%")))
                    (list "a lone continuation octet #x80 inside a string literal" "not-utf8-lone-continuation.lp"
                          (list (format nil "(+ 1 2)~%(list \"a") #x80 (format nil "b\")~%")))
                    (list "a multibyte sequence truncated at the end of the file (#xE2 #x98, two of U+2603's three octets)"
                          "not-utf8-truncated-at-eof.lp"
                          (list (format nil "(+ 1 2)~%(list 1)~%") #xE2 #x98))))
  (destructuring-bind (what name parts) case
    (multiple-value-bind (code out err) (spawn "bash" *r2-one-command* (apply #'scratch-write-octets name parts))
      (report (and (eql code 2) (string= out "") (search "E-READ" err) (search name err) (not (search "HOST FAULT" err))
                   (not (names-a-form-location-p err name)) (not (carries-form-context-p err)))
              (format nil "[F-3 · WO 4 · owner's word \"E-READ, exit 2\" · spec §1 \"a source is a UTF-8 text\"] ~a, through the ONE command: exit 2, nothing on stdout, E-READ naming ~a, no HOST FAULT, no form location (no ~a:LINE:COL, no in:/within:/frames:)"
                      what name name)
              (format nil "exit ~a; stdout ~s; stderr ~s" code out (from-error-line err))))))
;;; The control (WO 4: "valid non-ASCII UTF-8 is the control"). Expected output from the spec: `print' writes a string
;;; unquoted and a newline (§5.1), and the last form's value is printed rendered (§9), a string quoted (§2, README's
;;; hello.lp → "hello, world").
(multiple-value-bind (code out err) (run-command "utf8-non-ascii.lp" (format nil "(print (string-append \"ação \" \"☃\"))~%"))
  (report (and (eql code 0) (string= out (format nil "ação ☃~%\"ação ☃\"~%")))
          "[F-3 control · WO 4 · spec §1, §5.1, §9] a valid non-ASCII UTF-8 program (ação ☃) exits 0: print writes ação ☃, and the value prints \"ação ☃\""
          (format nil "exit ~a; stdout ~s; stderr ~s" code out (from-error-line err))))
;;; Narrowness (WO 4: "do not turn every I/O or internal error into E-READ; real host defects stay on exit 1"): an
;;; unreadable file is not a decoding failure. The contract says only that it is NOT E-READ; its exit code is printed
;;; as an observation, not asserted. The check is armed only if this user really cannot open the file (not root).
(let ((path (scratch-write "unreadable-mode-000.lp" (format nil "(+ 1 2)~%"))))
  (sb-posix:chmod path 0)
  (let ((armed (handler-case (progn (close (open path)) nil) (file-error () t))))
    (multiple-value-bind (code out err) (spawn "bash" *r2-one-command* path)
      (declare (ignore out))
      (report (and armed (not (search "E-READ" err)))
              "[F-3 narrowness · WO 4 \"do not turn every I/O … into E-READ\"] an unreadable (mode-000) file is NOT reported as E-READ"
              (format nil "armed (unreadable to this user) ~a; exit ~a; stderr ~s" armed code (from-error-line err)))
      (format t "     observation, not a check: that mode-000 file exits ~a through the ONE command~%" code))))

;;; ---- 32. PE21, PE23, PE24 literally, with the README's plain/confident setup [WO 14] ----------------------------
;;; r1 ran these three with the constructor inline (P:200–203, P:215–216), RUN-EQUIVALENT. Astra: "Run PE21/23/24
;;; literally with the README's plain/confident setup." Each literal line (comment included) and the setup
;;; (README:139–140, §27's +readme-kernel-setup+) must be in README.md verbatim; the value must be the README's.
(readme-example "[PE21 README:142 · WO 14] (host-value? plain) is true, literally, after the README's setup (README:139-140)"
                "(host-value? plain)                        ; → true  — a record the kernel built" "true"
                :setup +readme-kernel-setup+)
(readme-example "[PE23 README:144 · WO 14] (refused? confident) is true, literally, after the README's setup (README:139-140)"
                "(refused? confident)                       ; → true  — the kernel said no" "true"
                :setup +readme-kernel-setup+)
(readme-example "[PE24 README:145 · WO 14] (refusal-requirement confident) is \"K0E-33\", literally, after the README's setup (README:139-140)"
                "(refusal-requirement confident)            ; → \"K0E-33\"" "\"K0E-33\""
                :setup +readme-kernel-setup+)

;;; ---- 33. F-6: the runner's argument is a plain file path; no character in it is special ---------------------------
;;; The owner's word (2026-09-30, verbatim): "Fix it in r2 as F-6 (Recommended)", for a real program file whose path
;;; contains ?, * or [ (corpus/voices/received/2026-09-30-202427-owner-word-*-F6-*). Spec §9 (r2): the runner prints to
;;; stdout "the rendered value of the last form" and exits "`0` value · … · `3` usage (no file / no such file / a
;;; directory) · `1` host fault"; "a path containing `?`, `*` or `[` names the file it spells, and is run, refused as
;;; usage or refused as a directory like any other." Each case runs through lisp-plus-run.sh AND run.lisp directly, and
;;; asserts no HOST FAULT and no backtrace text (`backtrace' or `unhandled', any case). Every file here is made and
;;; removed through NATIVE paths (sb-ext:parse-native-namestring, sb-posix), never a Lisp namestring, so the harness
;;; itself cannot read these names as wildcards. The nonexistent `nosuch-*.lp' sits beside a REAL `nosuch-real.lp'
;;; whose value, 101, no case expects: a runner that expanded the pattern would be caught running it. Each real file has
;;; its own value, so a runner that ran the wrong file is caught too. (LEADSMAN, Claude Opus 5.5)
(defun scratch-write-native (path text)
  "Write TEXT as UTF-8 to PATH, a NATIVE path string in which no character is special. → PATH."
  (with-open-file (o (sb-ext:parse-native-namestring path) :direction :output :if-exists :supersede :external-format :utf-8)
    (write-string text o))
  path)
(defun shows-a-backtrace-p (stderr)
  "Does STDERR carry a host backtrace or an unhandled-condition report?"
  (or (search "backtrace" stderr :test #'char-equal) (search "unhandled" stderr :test #'char-equal)))
(let* ((qdir (format nil "~a/wild?dir" *scratch*))
       (in-qdir (format nil "~a/prog.lp" qdir))
       (bracket (format nil "~a/q[1].lp" *scratch*))
       (star (format nil "~a/star*.lp" *scratch*))
       (decoy (format nil "~a/nosuch-real.lp" *scratch*))
       (missing (format nil "~a/nosuch-*.lp" *scratch*)))
  (sb-posix:mkdir qdir #o755)
  (scratch-write-native in-qdir (format nil "(+ 1 2)~%"))
  (scratch-write-native bracket (format nil "(* 6 7)~%"))
  (scratch-write-native star (format nil "(- 10 3)~%"))
  (scratch-write-native decoy (format nil "(+ 100 1)~%"))
  (dolist (route (list (list "lisp-plus-run.sh" "bash" *r2-one-command*) (list "run.lisp" "sbcl" "--script" *r2-run-lisp*)))
    (flet ((run-arg (arg) (apply #'spawn (append (rest route) (list arg))))
           (clean-p (err) (and (not (search "HOST FAULT" err)) (not (shows-a-backtrace-p err)))))
      (dolist (case (list (list "in a directory whose name contains ?" in-qdir (format nil "3~%"))
                          (list "whose name contains [ and ]" bracket (format nil "42~%"))
                          (list "whose name contains *" star (format nil "7~%"))))
        (destructuring-bind (what path want) case
          (multiple-value-bind (code out err) (run-arg path)
            (report (and (eql code 0) (string= out want) (clean-p err))
                    (format nil "[F-6 · owner's word \"Fix it in r2 as F-6\" · spec §9 \"0 value\"] a real program file ~a, given to ~a: exit 0, stdout `~a' and a newline, no HOST FAULT, no backtrace"
                            what (first route) (string-right-trim '(#\Newline) want))
                    (format nil "exit ~a; stdout ~s; stderr ~s" code out (from-error-line err))))))
      (multiple-value-bind (code out err) (run-arg missing)
        (report (and (eql code 3) (string= out "") (search "no such file" err) (clean-p err))
                (format nil "[F-6 · spec §9 \"3 usage (… no such file …)\"] a NONEXISTENT path containing *, beside a real file the pattern would match, given to ~a: exit 3, no such file, nothing on stdout, no HOST FAULT, no backtrace"
                        (first route))
                (format nil "exit ~a; stdout ~s; stderr ~s" code out (from-error-line err))))
      (multiple-value-bind (code out err) (run-arg qdir)
        (report (and (eql code 3) (string= out "") (search qdir err) (search "directory" err) (clean-p err))
                (format nil "[F-6 · F-2 · spec §9 \"3 usage (… a directory)\"] a DIRECTORY whose name contains ?, given to ~a: exit 3, nothing on stdout, stderr names it and says `directory', no HOST FAULT, no backtrace"
                        (first route))
                (format nil "exit ~a; stdout ~s; stderr ~s" code out (from-error-line err))))))
  (dolist (p (list in-qdir bracket star decoy)) (sb-posix:unlink p))
  (sb-posix:rmdir qdir))

;;; ---- 34. F-6, extended: the right file runs, and a diagnostic names the file as its path spells it ------------------
;;; The owner's word (2026-09-30, verbatim): "Fix it too, within F-6 (Recommended)" (corpus/voices/received/2026-09-30-
;;; 204715-owner-word-*-F6-DIAGNOSTIC-FILE-NAMES-*), extending "Fix it in r2 as F-6". Spec §9 (r2): "a path containing
;;; `?`, `*` or `[` names the file it spells"; §8: an error carries "the location `file:line:column` of the top-level
;;; form". (1) A backslash is a character of the name, not an escape: `back\slash.lp' (value 4) sits beside
;;; `backslash.lp' (value 2), and the backslash-named file's OWN value must come out. (2) A diagnostic spells the file's
;;; name as the path does: the E-UNBOUND location for `q[1].lp' and `star*.lp' is exactly `q[1].lp:1:0' / `star*.lp:1:0'
;;; (one whitespace-delimited word of the error line), and F-3's file-level E-READ for `bad[1].lp' names `bad[1].lp';
;;; no `\[' or `\*' appears. Nothing else of a message's wording is asserted: it is unspecified. Both routes; native
;;; paths only, in their own subdirectory of the scratch, as in §33. (LEADSMAN, Claude Opus 5.5)
(defun words-of (line)
  "LINE split at single spaces."
  (loop with start = 0
        for sp = (position #\Space line :start start)
        collect (subseq line start (or sp (length line)))
        while sp do (setf start (1+ sp))))
(let* ((dir (format nil "~a/f6b" *scratch*))
       (back (format nil "~a/back\\slash.lp" dir))
       (plain (format nil "~a/backslash.lp" dir))
       (bracket (format nil "~a/q[1].lp" dir))
       (star (format nil "~a/star*.lp" dir))
       (bad (format nil "~a/bad[1].lp" dir)))
  (sb-posix:mkdir dir #o755)
  (scratch-write-native back (format nil "(+ 2 2)~%"))
  (scratch-write-native plain (format nil "(+ 1 1)~%"))
  (scratch-write-native bracket (format nil "undefined-thing~%"))
  (scratch-write-native star (format nil "undefined-thing~%"))
  (with-open-file (o (sb-ext:parse-native-namestring bad) :direction :output :if-exists :supersede :element-type '(unsigned-byte 8))
    (write-sequence (sb-ext:string-to-octets (format nil "(+ 1 2)~%") :external-format :utf-8) o)
    (write-byte #xFF o))
  (dolist (route (list (list "lisp-plus-run.sh" "bash" *r2-one-command*) (list "run.lisp" "sbcl" "--script" *r2-run-lisp*)))
    (flet ((run-arg (arg) (apply #'spawn (append (rest route) (list arg)))))
      (multiple-value-bind (code out err) (run-arg back)
        (report (and (eql code 0) (string= out (format nil "4~%")) (not (search "HOST FAULT" err)))
                (format nil "[F-6 · owner's word · spec §9 \"names the file it spells\"] a file named back\\slash.lp (value 4) beside backslash.lp (value 2), given to ~a: its OWN value 4, exit 0, no HOST FAULT"
                        (first route))
                (format nil "exit ~a; stdout ~s; stderr ~s" code out (from-error-line err))))
      (dolist (case (list (list "q[1].lp" bracket "q[1].lp:1:0" "\\[") (list "star*.lp" star "star*.lp:1:0" "\\*")))
        (destructuring-bind (name path location escaped) case
          (multiple-value-bind (code out err) (run-arg path)
            (declare (ignore out))
            (let ((line (error-header err)))
              (report (and (eql code 2) line (member location (words-of line) :test #'string=)
                           (not (search escaped err)) (not (search "HOST FAULT" err)))
                      (format nil "[F-6 · owner's word \"Fix it too, within F-6\" · spec §8 \"file:line:column\"] E-UNBOUND in a file named ~a, given to ~a: exit 2, the error line's location is exactly ~a, no ~a in stderr, no HOST FAULT"
                              name (first route) location escaped)
                      (format nil "exit ~a; error line ~s; stderr ~s" code line (from-error-line err)))))))
      (multiple-value-bind (code out err) (run-arg bad)
        (declare (ignore out))
        (report (and (eql code 2) (search "E-READ" err) (search "bad[1].lp" err) (not (search "\\[" err))
                     (not (search "HOST FAULT" err)))
                (format nil "[F-6 · F-3 · owner's word \"Fix it too, within F-6\"] a non-UTF-8 file named bad[1].lp, given to ~a: exit 2, the file-level E-READ names bad[1].lp as spelled, no \\[ in stderr, no HOST FAULT"
                        (first route))
                (format nil "exit ~a; stderr ~s" code (from-error-line err))))))
  (dolist (p (list back plain bracket star bad)) (sb-posix:unlink p))
  (sb-posix:rmdir dir))

;;; ---- 35. r2: checks for sentences r2's clarifications added (TIDEWAITER's recount found them unchecked) ---------
;;; Written by the chair (Claude Opus 5.5), not by any hand that wrote a fix: these sentences changed no behaviour, so
;;; they have no old-red; each was seen to fail on a planted mutant (r2/chair-repro/). Expected values are the spec's.
;;; Spec §1 (r2): a file that is not UTF-8 is refused whole, "nothing is evaluated, nothing is written to stdout". A
;;; form that PRINTS stands before the bad octets, so a runner that evaluated the decodable prefix would be seen.
(multiple-value-bind (code out err)
    (spawn "bash" *r2-one-command*
           (scratch-write-octets "not-utf8-after-a-print.lp" (format nil "(print \"early\")~%") #xFF (format nil "~%(+ 1 2)~%")))
  (report (and (eql code 2) (string= out "") (search "E-READ" err) (not (search "HOST FAULT" err)))
          "[spec §1 r2 \"nothing is evaluated\"] a file whose bad octet follows a (print \"early\") form: exit 2, E-READ, and nothing on stdout (the print never ran)"
          (format nil "exit ~a; stdout ~s; stderr ~s" code out (from-error-line err))))
;;; Spec §5.1 (r2): "`quotient`/`mod` take integers only, checked before the zero: a float zero there is E-TYPE
;;; (`(mod 5 0.0)`), an integer zero E-ARITH (`(mod 5 0)`)."
(fails-with "[spec §5.1 r2] (mod 5 0.0): integers only, checked before the zero, so a float zero is E-TYPE" "(mod 5 0.0)" "E-TYPE")
(fails-with "[spec §5.1 r2] (quotient 5 0.0): a float zero is E-TYPE" "(quotient 5 0.0)" "E-TYPE")
(fails-with "[spec §5.1 r2] (mod 5 0): an integer zero is E-ARITH" "(mod 5 0)" "E-ARITH")
;;; Spec §5.1 (r2): "These are list operations: a string is not a list (`(length \"abc\")` is E-TYPE)."
(fails-with "[spec §5.1 r2] (length \"abc\"): a string is not a list" "(length \"abc\")" "E-TYPE")
(fails-with "[spec §5.1 r2] (reverse \"abc\"): a string is not a list" "(reverse \"abc\")" "E-TYPE")
;;; Spec §7.1 (r2): "Any other operand, a function included, is **E-TYPE**, not E-BOUNDARY."
(fails-with "[spec §7.1 r2] (kernel0/determinacy-mode car): a function is not a determinacy value, E-TYPE" "(kernel0/determinacy-mode car)" "E-TYPE")
(fails-with "[spec §7.1 r2] (refusal-law car): a function is not a refusal, E-TYPE" "(refusal-law car)" "E-TYPE")

;;; ---- 36. the six-point clarification card (owner's word 2026-10-01) -----------------------------------------------
;;; The owner accepted Astra's six rules as she recommended (corpus/voices/received/2026-10-01-134243-owner-word-PROGRAM-0-
;;; CLARIFICATION-CARD-and-CLOSING-EVIDENCE-RULE-VERBATIM.md; her table is 02-OWNER-DECISION.md in corpus/voices/received/
;;; originals/2026-09-30-220019-astra-program-repl-0-dossier-r2-disposition/). Each obligation the rules state was first
;;; mapped to an existing assertion, read as an assertion and not as a label; only the obligations with no discriminating
;;; witness get a check here. Already witnessed, and not repeated: (integer? 3) true at [5.1e]; pair?/list? on non-empty
;;; lists and atoms at [5.1d]; eq? on symbols and keywords at [5.1b] and on booleans at [2.6]; equal? on proper lists,
;;; recursively, at [5.1b]; equal? on strings by their characters at [5.1b] ("ab" and "ab", two objects) and [5.1g] (two
;;; different kind strings). No check asserts eq? identity for numbers, strings, nonempty lists, functions, refusals or
;;; host values: rule 6 leaves it unspecified. Expected values are the rules', never a run's; production is r2's,
;;; unchanged. Each check was seen to fail on its own planted mutant (_staging/2026-10-01-program-repl-0-closing/
;;; ASSESSOR-report.md). (ASSESSOR, Claude Opus 5.5)
;;; Rule 1: "`max` and `min` take one or more numbers, so zero arguments is E-ARITY. `append` takes zero or more lists, so
;;; zero returns `()`."
(value-is "[rule 1 · owner's word 2026-10-01] max takes one or more numbers: one argument is admitted, (max 5) is 5" "(max 5)" "5")
(value-is "[rule 1 · owner's word 2026-10-01] min takes one or more numbers: one argument is admitted, (min 5) is 5" "(min 5)" "5")
(fails-with "[rule 1 · owner's word 2026-10-01] (max) with zero arguments is E-ARITY" "(max)" "E-ARITY")
(fails-with "[rule 1 · owner's word 2026-10-01] (min) with zero arguments is E-ARITY" "(min)" "E-ARITY")
(value-is "[rule 1 · owner's word 2026-10-01] append takes zero or more lists: (append) is ()" "(append)" "()")
(value-is "[rule 1 · owner's word 2026-10-01] append of ONE list is that list: (append (list 1 2)) is (1 2)" "(append (list 1 2))" "(1 2)")
(value-is "[rule 1 · owner's word 2026-10-01] append of SEVERAL lists (four, an empty one among them) joins them in order"
          "(append (list 1) (list 2 3) () (list 4))" "(1 2 3 4)")
;;; Rule 2: "`begin`, `lambda`, `let` and each `cond` clause require a body form, and `cond` requires a clause. The named
;;; omissions (`(begin)`, `(cond)`, `(cond (true))`, `(lambda (x))`, `(let ((x 1)))`) are E-SYNTAX." `(lambda (x))' is
;;; refused when the lambda form is evaluated; the program never applies it.
(dolist (tx '("(begin)" "(cond)" "(cond (true))" "(lambda (x))" "(let ((x 1)))"))
  (fails-with (format nil "[rule 2 · owner's word 2026-10-01] ~a, a named omission, is E-SYNTAX" tx) tx "E-SYNTAX"))
;;; Rule 3: "`(define (f x x) x)` and `(lambda (x x) x)` are E-SYNTAX when evaluated, before any call." Neither program
;;; calls the function it would make, so a refusal made only at a call leaves these two programs without an error.
(fails-with "[rule 3 · owner's word 2026-10-01] (define (f x x) x) is E-SYNTAX when evaluated, before any call (the program never calls f)"
            "(define (f x x) x)" "E-SYNTAX")
(fails-with "[rule 3 · owner's word 2026-10-01] (lambda (x x) x) is E-SYNTAX when evaluated, before any call (the function is never applied)"
            "(lambda (x x) x)" "E-SYNTAX")
;;; Rule 4: "`(pair? ())` is false, and `(list? ())` is true."
(value-is "[rule 4 · owner's word 2026-10-01] (pair? ()) is false" "(pair? ())" "false")
(value-is "[rule 4 · owner's word 2026-10-01] (list? ()) is true" "(list? ())" "true")
;;; Rule 5: "`integer?` recognizes integer representation: 3 is true, and 3.0 is false." (3 is at [5.1e].)
(value-is "[rule 5 · owner's word 2026-10-01] integer? recognizes integer representation: (integer? 3.0) is false" "(integer? 3.0)" "false")
;;; Rule 6: "`eq?` identity is guaranteed for symbols, keywords, booleans and the empty list, so `(eq? () ())` is true."
;;; "`(equal? 1 1.0)` is true and `(equal? 1 2.0)` is false." The empty list is checked as a literal and as the empty
;;; list a computation returns.
(value-is "[rule 6 · owner's word 2026-10-01] eq? identity holds for the empty list: (eq? () ()) and (eq? () (cdr (list 1))) are true"
          "(list (eq? () ()) (eq? () (cdr (list 1))))" "(true true)")
(value-is "[rule 6 · owner's word 2026-10-01] equal? compares numbers numerically across representations: (equal? 1 1.0) is true"
          "(equal? 1 1.0)" "true")
(value-is "[rule 6 · owner's word 2026-10-01] equal? across representations is still numeric: (equal? 1 2.0) is false"
          "(equal? 1 2.0)" "false")

;;; ---- 37. Card 2 for EVERY immediate cond clause (Astra's B), and Card 3's phase ------------------------------------
;;; Astra's closing disposition rules B (corpus/voices/received/originals/2026-10-01-154600-astra-program-repl-0-closing-
;;; disposition/01-DISPOSITION.md): when an evaluated `cond' is entered, the outer shape of every immediate clause is
;;; checked before any test or body runs; then selection stays ordered, boolean-strict and lazy. The owner's word
;;; 2026-10-01 authorized it (corpus/voices/received/2026-10-01-160310-owner-word-PROGRAM-0-COND-B-CORRECTION-and-CODEX-
;;; SUCCESSOR-VERBATIM.md). The cases and expected values are her repair card's (02-BOUNDED-REPAIR.md, same directory).
;;; Written before the correction, by a hand that does not write it: on r2's production the first three checks are RED
;;; by design, and that old-red log is kept with the successor record. (ASSESSOR, Claude Opus 5.5)
;;; Missed clauses: a clause AFTER the selected one is malformed. "No final value": the run is an error, not 1.
(dolist (tx '("(cond (true 1) (false))" "(cond (true 1) ())"))
  (fails-with (format nil "[Card 2 · B · owner's word 2026-10-01] ~a: a malformed clause after the selected one is E-SYNTAX, located, with no final value" tx)
              tx "E-SYNTAX"))
;;; Before tests and bodies, through the ONE command: neither print may run; the cond is the top-level form at 1:0.
(multiple-value-bind (code out err)
    (run-command "cond-shape-before-tests.lp"
                 (format nil "(cond ((begin (print \"test\") true) (print \"body\") 1) (false))~%"))
  (report (and (eql code 2) (string= out "")
               (equal (error-header err) "lisp-plus: E-SYNTAX at cond-shape-before-tests.lp:1:0")
               (not (search "HOST FAULT" err)))
          "[Card 2 · B] every clause's shape is checked before any test or body: (cond ((begin (print \"test\") true) (print \"body\") 1) (false)) through the ONE command exits 2, E-SYNTAX at 1:0, and prints nothing (no test, no body)"
          (format nil "exit ~a; stdout ~s; error line ~s" code out (error-header err))))
;;; Lazy evaluation is kept: every clause is well-shaped; the unselected test and the else body would each be E-ARITH.
(value-is "[Card 2 · B] selection stays lazy: (cond (true 1) ((/ 1 0) 2) (else (/ 1 0))) is 1, with no E-ARITH"
          "(cond (true 1) ((/ 1 0) 2) (else (/ 1 0)))" "1")
;;; Validation stays local: only the immediate clauses of an ENTERED cond; nothing deeper, nothing never entered.
(value-is "[Card 2 · B] the check is not recursive: (cond (true 1) (false (if true))) is 1 (the malformed if in an unselected body is never evaluated)"
          "(cond (true 1) (false (if true)))" "1")
(value-is "[Card 2 · B] the check is not a whole-source sweep: (if true 7 (cond (false))) is 7 (the malformed cond is never entered)"
          "(if true 7 (cond (false)))" "7")
;;; Card 3's phase: the refusal comes when the form is EVALUATED, after the forms before it have run, not when the source
;;; is read or validated. Separate lines; the code, the second form's location (2:0) and the earlier output are asserted.
(dolist (case '(("define" "card3-define-phase.lp" "(define (f x x) x)")
                ("lambda" "card3-lambda-phase.lp" "(lambda (x x) x)")))
  (destructuring-bind (what file form) case
    (multiple-value-bind (code out err) (run-command file (format nil "(print \"early\")~%~a~%" form))
      (let ((want (format nil "lisp-plus: E-SYNTAX at ~a:2:0" file)))
        (report (and (eql code 2) (string= out (format nil "early~%")) (equal (error-header err) want)
                     (not (search "HOST FAULT" err)))
                (format nil "[Card 3 · phase, ~a] (print \"early\") on line 1, ~a on line 2, nothing called: exit 2, stdout exactly `early', then ~s"
                        what form want)
                (format nil "exit ~a; stdout ~s; error line ~s" code out (error-header err)))))))

;;; the r2 scratch directory goes, with everything written into it
(sb-posix:rmdir *r2-directory*)
(dolist (f (directory (merge-pathnames (make-pathname :name :wild :type :wild) (format nil "~a/" *scratch*))))
  (delete-file f))
(sb-posix:rmdir *scratch*)

(format t "~&program0 selftest: ~d passed, ~d failed~%" *passed* *failed*)
(sb-ext:exit :code (if (zerop *failed*) 0 1))
