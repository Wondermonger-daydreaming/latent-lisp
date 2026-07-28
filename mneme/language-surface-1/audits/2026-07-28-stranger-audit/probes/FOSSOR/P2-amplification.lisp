(load "/tmp/claude-1000/-home-gauss-Desktop-Claude-Code-Lab/d214ea40-d602-4f0d-b684-e6f5fddf4447/scratchpad/surface1-audit/probes/FOSSOR/prelude.lisp")
(in-package #:fossor)
(banner "P2 — CAN AN ADMISSIBLE SOURCE EXPAND TO >20000 NODES?")

(defun djs (n)
  "A DEFINE-JUDGMENT-SCHEMA source with N integer premises.  Every field literal."
  (list (find-symbol "DEFINE-JUDGMENT-SCHEMA" '#:lisp-plus-surface0)
        (intern "*FOSSOR-J*" '#:cl-user)
        :name :fossor :version 1
        :conclusion 0
        :premises (make-list n :initial-element 0)
        :locals nil :unique-locals nil))

(format t "~&      N   src-nodes   src-octets   exp-nodes   exp-octets   ratio~%")
(dolist (n '(100 1000 2000 2500 3000 4000 5000))
  (let* ((src (djs n))
         (sn (s1i %host-nodes src))
         (so (handler-case (octets-of (s1 encode-term src)) (error () -1)))
         (exp (macroexpand-1 src nil))
         (en (s1i %host-nodes exp))
         (eo (handler-case (octets-of (s1 encode-term exp)) (error () -1))))
    (format t "  ~5D   ~9D   ~10D   ~9D   ~10D   ~,2F~%" n sn so en eo (/ en sn))))

(banner "P2b — THE PUBLIC-API DRIVE: largest N that passes DOOR 1")
(defun door1 (n) (refusal-of (lambda () (s1 request-expansion (djs n) :macroexpand-1 (tag "amp")))))
(let ((lo 1) (hi 20000))
  (loop while (< (1+ lo) hi)
        do (let ((mid (floor (+ lo hi) 2)))
             (if (door1 mid) (setf hi mid) (setf lo mid))))
  (line "largest N passing DOOR 1 ............. ~D" lo)
  (line "N=~D refuses at door 1 with .......... ~S" hi (rcode (door1 hi)))
  (let* ((src (djs lo)) (exp (macroexpand-1 src nil)))
    (line "at N=~D  source octets ~D · expanded host nodes ~D" lo
          (octets-of (s1 encode-term src)) (s1i %host-nodes exp))))
