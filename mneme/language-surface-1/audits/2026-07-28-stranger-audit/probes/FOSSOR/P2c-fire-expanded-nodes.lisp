(load "/tmp/claude-1000/-home-gauss-Desktop-Claude-Code-Lab/d214ea40-d602-4f0d-b684-e6f5fddf4447/scratchpad/surface1-audit/probes/FOSSOR/prelude.lisp")
(in-package #:fossor)
(banner "P2c — FIRING :EXPANDED-NODES-EXCEEDED THROUGH THE PUBLIC API ONLY")
(defun djs (n)
  (list (find-symbol "DEFINE-JUDGMENT-SCHEMA" '#:lisp-plus-surface0)
        (intern "*FOSSOR-J*" '#:cl-user)
        :name :fossor :version 1 :conclusion 0
        :premises (make-list n :initial-element 0)
        :locals nil :unique-locals nil))
(line "catalog says :EXPANDED-NODES-EXCEEDED reachability = ~S"
      (s1 refusal-catalog-entry-reachability (catalog-entry :expanded-nodes-exceeded)))
(dolist (n '(2400 2490 2500 2600 5000))
  (let* ((src (djs n))
         (req (s1 request-expansion src :macroexpand-1 (tag "amp" (format nil "~D" n))))
         (r (refusal-of (lambda () (s1 perform-expansion req)))))
    (line "N=~4D  src-nodes ~5D src-octets ~6D  exp-nodes ~5D  -> ~S (upstream ~S)"
          n (s1i %host-nodes src) (octets-of (s1 encode-term src))
          (s1i %host-nodes (macroexpand-1 src nil)) (rcode r) (rup r))))
(banner "P2c — the MINIMAL witness, checked against the catalogue")
(let ((req (s1 request-expansion (djs 2500) :macroexpand-1 (tag "minimal"))))
  (fires ":EXPANDED-NODES-EXCEEDED via DEFINE-JUDGMENT-SCHEMA with 2500 integer premises"
         :expanded-nodes-exceeded (lambda () (s1 perform-expansion req)))
  (line "refusal detail: ~A" (s1 expansion-refusal-detail
                               (refusal-of (lambda () (s1 perform-expansion req))))))
(banner "P2c — and the OCTET argument tested on its own terms")
(let* ((src (djs 2000)) (req (s1 request-expansion src :macroexpand-1 (tag "oct"))))
  (line "N=2000: expanded nodes ~D (<=20000), expanded octets ~D -> ~S"
        (s1i %host-nodes (macroexpand-1 src nil))
        (octets-of (s1 encode-term (macroexpand-1 src nil)))
        (rcode (refusal-of (lambda () (s1 perform-expansion req))))))
(format t "~%  MISMATCHES: ~D of ~D~%" *bad* *n*)
