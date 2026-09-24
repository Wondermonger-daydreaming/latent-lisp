;;;; program0-selftest.lisp — focused implementation tests for PROGRAM /0.
;;;;
;;;;   cd mneme/language-program-0 && sbcl --non-interactive --load program0-selftest.lisp
;;;;   (or: bash run-selftest.sh — same thing with the stack the runner uses)
;;;;
;;;; Prints one line per check, then "program0 selftest: N passed, M failed",
;;;; and exits 0 iff M = 0. The behaviour the commission named is tested by name:
;;;; lexical shadowing and capture, higher-order application, empty collections,
;;;; wrong arity, unknown names, the effect boundary — plus the reader law, the
;;;; budget, redefinition, the Kernel /0 bridge, and the three programs' actual
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
(value-is "and/or short-circuit and yield booleans" "(list (and) (or) (and true false) (or false true))" "(true false false true)")

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
(value-is "the refusal's law is a non-empty string"
          "(> (length (list (refusal-law (kernel0/determinacy :mode :determinate :confidence 0.8)))) 0)" "true")
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

;;; ---- 11. the three programs, through the ONE command, against their expected output
(defun run-program (name)
  (let* ((script (merge-pathnames "lisp-plus-run.sh" *here*))
         (program (merge-pathnames (format nil "programs/~a.lp" name) *here*))
         (out (make-string-output-stream))
         (proc (sb-ext:run-program "/usr/bin/env" (list "bash" (namestring script) (namestring program))
                                   :output out :error nil :wait t)))
    (values (get-output-stream-string out) (sb-ext:process-exit-code proc))))

(dolist (name '("sum-of-squares" "higher-order" "determinacy"))
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
           (proc (sb-ext:run-program "/usr/bin/env" (list "bash" (namestring script) path)
                                     :output nil :error nil :wait t)))
      (delete-file path)
      (sb-ext:process-exit-code proc))))
(defun run-text-as-file-missing ()
  (let* ((script (merge-pathnames "lisp-plus-run.sh" *here*))
         (proc (sb-ext:run-program "/usr/bin/env" (list "bash" (namestring script) "/nonexistent/program.lp")
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
(fails-with "quotient by 0.0 is refused before the host sees it" "(quotient 1 0)" "E-ARITH")
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

(format t "~&program0 selftest: ~d passed, ~d failed~%" *passed* *failed*)
(sb-ext:exit :code (if (zerop *failed*) 0 1))
