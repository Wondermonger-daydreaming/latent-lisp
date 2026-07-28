;;;; probe-E.lisp — is DECODE-TERM injective on the data it accepts?
;;;; Errata 0.2 §2 / catalogue note: "with the home-package guard in place, decode
;;;; is injective for every admissible datum, so NO PUBLIC INPUT CAN REACH the
;;;; round-trip mismatch — the earlier, more precise guard always fires first."
(defparameter *s1dir*
  (pathname "/tmp/claude-1000/-home-gauss-Desktop-Claude-Code-Lab/d214ea40-d602-4f0d-b684-e6f5fddf4447/scratchpad/surface1-audit/extract/target/tree/mneme/language-surface-1/"))
(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "surface1.lisp" *s1dir*)))
(defpackage #:tabe (:use #:common-lisp)) (in-package #:tabe)
(defmacro s1 (n &rest a) `(,(find-symbol (string n) '#:lisp-plus-surface1) ,@a))
(defmacro cd0 (n &rest a) `(,(find-symbol (string n) '#:lisp-plus-cd0) ,@a))
(defun L (c &rest a) (format t "~&~A~%" (apply #'format nil c a)))
(defun symterm (ns path)
  (cd0 make-record-datum
       (list (cd0 make-record-entry (cd0 make-identifier-datum '("TERM") '("KIND"))
                  (cd0 make-identifier-datum '("TERMKIND") '("SYMBOL")))
             (cd0 make-record-entry (cd0 make-identifier-datum '("TERM") '("VALUE"))
                  (cd0 make-identifier-datum ns path)))))
(defun try-decode (d) (handler-case (s1 decode-term d) (error (e) (list :refused (type-of e)))))

(defpackage #:tabe-real (:use) (:nicknames #:tabe-nick))
(intern "W" '#:tabe-real)

(L "=== CASE 1 — a datum naming the package by NICKNAME ===")
(let* ((d-nick (symterm '("TABE-NICK") '("W")))
       (sym (try-decode d-nick)))
  (L "decode(TABE-NICK/W) .............. ~S" sym)
  (when (symbolp sym)
    (L "home package of result ........... ~A" (package-name (symbol-package sym)))
    (L "re-encode == the datum decoded? .. ~A"
       (cd0 equal-datum (s1 encode-term sym) d-nick))
    (L "re-encode == primary-name datum? . ~A"
       (cd0 equal-datum (s1 encode-term sym) (symterm '("TABE-REAL") '("W"))))))

(L "~%=== CASE 2 — two DISTINCT data that decode to the SAME symbol ===")
(let* ((a (symterm '("TABE-REAL") '("W")))
       (b (symterm '("TABE-REAL" "IGNORED-SECOND-SEGMENT") '("W" "IGNORED")))
       (sa (try-decode a)) (sb (try-decode b)))
  (L "datum A and datum B are equal? ... ~A" (cd0 equal-datum a b))
  (L "decode(A) ........................ ~S" sa)
  (L "decode(B) ........................ ~S" sb)
  (L "decode(A) EQ decode(B)? .......... ~A" (eq sa sb))
  (L "=> DECODE-TERM is NOT injective on the data it accepts: ~A"
     (and (not (cd0 equal-datum a b)) (eq sa sb))))

(L "~%=== CASE 3 — does such a datum round-trip? ===")
(let ((b (symterm '("TABE-REAL" "IGNORED-SECOND-SEGMENT") '("W" "IGNORED"))))
  (let ((sym (try-decode b)))
    (when (symbolp sym)
      (L "encode(decode(B)) == B? .......... ~A"
         (cd0 equal-datum (s1 encode-term sym) b))
      (L "so for THIS datum the symbol guard does NOT fire and only the")
      (L "ROUND-TRIP gate would catch it — it is not pure defence in depth."))))

(L "~%=== CASE 4 — can such a datum reach DOOR 2 through the public API? ===")
(L "Door 1 stores only ENCODE-TERM output, and ENCODE-TERM writes exactly one")
(L "namespace segment (the home package's primary name), so no REQUEST can")
(L "carry one.  The unreachability conclusion holds; the stated REASON does not.")
