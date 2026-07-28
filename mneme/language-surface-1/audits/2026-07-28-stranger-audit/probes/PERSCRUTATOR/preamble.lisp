;;; Common preamble — load Surface /1 (CD/0 only) then Surface /0 as a client.
(defparameter *tgt* "/tmp/claude-1000/-home-gauss-Desktop-Claude-Code-Lab/d214ea40-d602-4f0d-b684-e6f5fddf4447/scratchpad/surface1-audit/extract/target/tree/mneme/language-surface-1/")
(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "surface1.lisp" *tgt*))
  (load (merge-pathnames "../language-surface-0/surface0.lisp" *tgt*)))
(defpackage #:probe (:use #:common-lisp))
(in-package #:probe)
(defmacro s1 (name &rest args) `(,(find-symbol (string name) '#:lisp-plus-surface1) ,@args))
(defmacro cd0 (name &rest args) `(,(find-symbol (string name) '#:lisp-plus-cd0) ,@args))
(format t "~&PREAMBLE-OK surface0-absent-after-s1-load=~A~%"
        (not (find-package '#:lisp-plus-surface0)))
