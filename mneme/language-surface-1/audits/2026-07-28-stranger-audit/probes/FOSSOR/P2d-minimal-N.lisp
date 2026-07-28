(load "/tmp/claude-1000/-home-gauss-Desktop-Claude-Code-Lab/d214ea40-d602-4f0d-b684-e6f5fddf4447/scratchpad/surface1-audit/probes/FOSSOR/prelude.lisp")
(in-package #:fossor)
(defun djs (n) (list (find-symbol "DEFINE-JUDGMENT-SCHEMA" '#:lisp-plus-surface0)
                     (intern "*FOSSOR-J*" '#:cl-user) :name :f :version 1 :conclusion 0
                     :premises (make-list n :initial-element 0) :locals nil :unique-locals nil))
(banner "P2d — the MINIMAL premise count that reaches :EXPANDED-NODES-EXCEEDED")
(dolist (n '(2491 2492 2493 2494))
  (let* ((src (djs n))
         (r (refusal-of (lambda () (s1 perform-expansion (s1 request-expansion src :macroexpand-1 (tag "m")))))))
    (line "N=~D  src-nodes ~D  src-octets ~D  exp-nodes ~D -> ~S"
          n (s1i %host-nodes src) (octets-of (s1 encode-term src))
          (s1i %host-nodes (macroexpand-1 src nil)) (rcode r))))
