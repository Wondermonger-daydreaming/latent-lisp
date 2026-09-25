;;;; main.lisp — REPL /0's entry point (CANDIDATE). Run it through the one command:
;;;;
;;;;   bash mneme/language-repl-0/lisp-plus-repl.sh                 the command-line REPL
;;;;   bash mneme/language-repl-0/lisp-plus-repl.sh --web [--port N] the browser workbench
;;;;
;;;; Loads exactly what the file runner (language-program-0/run.lisp) loads — Kernel /0
;;;; and PROGRAM /0 — plus this lane. NOT loaded: core0, act0, act1, many-acts0, the lanes
;;;; that perform. Load chatter goes to standard error. Exit codes: 0 normal end ·
;;;; 1 host fault at startup (toolchain, missing file, port in use) · 3 usage.

(unless (string= (lisp-implementation-version) "2.4.6")
  (format *error-output* "~&lisp-plus-repl: declared for SBCL 2.4.6 only; observed ~a. No portability is claimed.~%"
          (lisp-implementation-version))
  (finish-output *error-output*)
  (sb-ext:exit :code 1))

(require :sb-bsd-sockets)

(defparameter cl-user::*repl0-here*
  (make-pathname :name nil :type nil :defaults *load-truename*))

(let ((*standard-output* *error-output*))
  (load (merge-pathnames "../kernel0/load.lisp" cl-user::*repl0-here*))
  (load (merge-pathnames "../language-program-0/package.lisp" cl-user::*repl0-here*))
  (load (merge-pathnames "../language-program-0/program0.lisp" cl-user::*repl0-here*))
  (load (merge-pathnames "package.lisp" cl-user::*repl0-here*))
  (load (merge-pathnames "repl0.lisp" cl-user::*repl0-here*))
  (load (merge-pathnames "repl0-cli.lisp" cl-user::*repl0-here*))
  (load (merge-pathnames "repl0-web.lisp" cl-user::*repl0-here*)))

(defun cl-user::repl0-usage (code)
  (format *error-output* "usage: bash mneme/language-repl-0/lisp-plus-repl.sh [--web [--port N]]~%")
  (finish-output *error-output*)
  (sb-ext:exit :code code))

(defun cl-user::repl0-main ()
  (let ((args (rest sb-ext:*posix-argv*)))
    (cond
      ((null args)
       (sb-ext:exit :code (lisp-plus-repl0::run-cli)))
      ((string= (first args) "--web")
       (let ((port 4917) (rest (rest args)))
         (loop while rest
               do (cond ((and (string= (first rest) "--port") (second rest)
                              (every #'digit-char-p (second rest))
                              (<= 1024 (parse-integer (second rest)) 65535))
                         (setf port (parse-integer (second rest)) rest (cddr rest)))
                        (t (cl-user::repl0-usage 3))))
         (sb-ext:exit :code (lisp-plus-repl0::run-web :port port) :abort nil)))
      ((member (first args) '("-h" "--help") :test #'string=) (cl-user::repl0-usage 0))
      (t (cl-user::repl0-usage 3)))))

(cl-user::repl0-main)
