;;;; load.lisp — Many Acts /0: the lane's declared load order.
;;;;
;;;; CANDIDATE.  Loading is not adoption (contract §0, §8).
;;;;
;;;; Seven sources, in this order and no other.  Each resolves relative to THIS
;;;; file's own directory, so the lane loads the same way under `sbcl --script'
;;;; and under ASDF.
;;;;
;;;; — FABER (Claude Opus 5, subagent), 2026-08-09

(in-package #:cl-user)

;;; The suite reaches `sb-posix:mkdtemp'; the symbol must exist when the file
;;; is READ, not merely when it runs.  One `require', before the loads.
(require :sb-posix)

(let ((here (make-pathname :name nil :type nil :defaults *load-truename*)))
  (dolist (file '("package.lisp"
                  "ma0-structures.lisp"
                  "ma0-validate.lisp"
                  "ma0-environment.lisp"
                  "ma0-compose.lisp"
                  "ma0-eval.lisp"
                  "ma0-selftest-suite.lisp"))
    (load (merge-pathnames file here))))
