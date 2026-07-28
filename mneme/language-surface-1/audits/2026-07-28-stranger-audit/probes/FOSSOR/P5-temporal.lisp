(load "/tmp/claude-1000/-home-gauss-Desktop-Claude-Code-Lab/d214ea40-d602-4f0d-b684-e6f5fddf4447/scratchpad/surface1-audit/probes/FOSSOR/prelude.lisp")
(in-package #:fossor)
(banner "P5 — TEMPORAL BINDING OF PROCEDURE / POLICY VERSION TO A RECEIPT")
(line "the claim under test (surface1.lisp:792-793):")
(line "  \"Version-binding as constant functions, not slots: a receipt cannot")
(line "   disagree with the package that minted it.\"")
(format t "~%")
(defparameter *src*
  (list (find-symbol "DEFINE-JUDGMENT-SCHEMA" '#:lisp-plus-surface0)
        (intern "*FOSSOR-T*" '#:cl-user) :name :t :version 1 :conclusion 0
        :premises nil :locals nil :unique-locals nil))
(defparameter *r* (s1 perform-expansion (s1 request-expansion *src* :macroexpand-1 (tag "t1"))))
(line "MINTED at package procedure version ~D, policy version ~D"
      (s1 expansion-procedure-version) (s1 expansion-policy-version))
(line "receipt says procedure-version ~D · policy-version ~D"
      (s1 expansion-receipt-procedure-version *r*) (s1 expansion-receipt-policy-version *r*))
(defparameter *rid-before* (cd0 octets-to-hex (cd0 canonical-octets (s1 expansion-receipt-identity *r*))))
(defparameter *reqid-before* (cd0 octets-to-hex (cd0 canonical-octets (s1 expansion-receipt-request-identity *r*))))
(line "receipt identity (hex, first 24) ..... ~A" (subseq *rid-before* 0 24))

(banner "P5b — IS THERE A STORED VERSION AT ALL?  The struct's slots.")
(line "EXPANSION-RECEIPT slot names: ~S"
      (mapcar #'sb-mop:slot-definition-name
              (sb-mop:class-slots (find-class 'lisp-plus-surface1::expansion-receipt))))
(line "any slot named *VERSION*? ~A"
      (if (find-if (lambda (s) (search "VERSION" (string s)))
                   (mapcar #'sb-mop:slot-definition-name
                           (sb-mop:class-slots (find-class 'lisp-plus-surface1::expansion-receipt))))
          "YES" "NO — the receipt stores no version anywhere"))

(banner "P5c — THE :PROCEDURE-VERSION-MISMATCH TEST, READ AS CODE")
(line "in %MINT-RECEIPT:  (version (or *%fault-procedure-version* (expansion-procedure-version)))")
(line "                   (unless (eql version (expansion-procedure-version)) ... refuse)")
(line "with the fault hook NIL the test is  (eql (EPV) (EPV))  -> ~A, always"
      (eql (s1 expansion-procedure-version) (s1 expansion-procedure-version)))
(line "so in production the alarm compares the package to ITSELF: there is no")
(line "stored operand.  It is not merely internal-only; it is VACUOUS.")

(banner "P5d — SIMULATED IMAGE UPGRADE.  EXACTLY WHAT I DID:")
(line "  (defun lisp-plus-surface1::expansion-procedure-version () 4)")
(line "  — one minimal redefinition of the constant function, in-image, AFTER the")
(line "    receipt above was minted.  Nothing else is touched; the receipt object")
(line "    is the same object.  This is what loading a bumped surface1.lisp does.")
(eval '(defun lisp-plus-surface1::expansion-procedure-version () 4))
(format t "~%")
(line "package now reports procedure version ......... ~D" (s1 expansion-procedure-version))
(line "THE OLD RECEIPT now reports procedure version . ~D  <-- it MOVED"
      (s1 expansion-receipt-procedure-version *r*))
(line "the old receipt's IDENTITY is unchanged ....... ~A"
      (string= *rid-before* (cd0 octets-to-hex (cd0 canonical-octets (s1 expansion-receipt-identity *r*)))))
(line "the old receipt's REQUEST identity unchanged .. ~A"
      (string= *reqid-before* (cd0 octets-to-hex (cd0 canonical-octets (s1 expansion-receipt-request-identity *r*)))))
(let ((r2 (s1 perform-expansion (s1 request-expansion *src* :macroexpand-1 (tag "t1")))))
  (line "a NEW receipt for the SAME source now has a DIFFERENT identity ~A"
        (not (same (s1 expansion-receipt-identity *r*) (s1 expansion-receipt-identity r2))))
  (line "  (so identity-level binding HOLDS; accessor-level binding does NOT)"))

(banner "P5e — IS THERE ANY POST-MINT DETECTOR?")
(let (acc) (do-external-symbols (s '#:lisp-plus-surface1) (push (symbol-name s) acc))
     (line "exported symbols matching VERIFY/CHECK/AUDIT/RECHECK: ~S"
           (remove-if-not (lambda (n) (or (search "VERIF" n) (search "CHECK" n)
                                          (search "AUDIT" n) (search "VALID" n))) acc))
     (line "exported symbols matching VERSION: ~S"
           (sort (remove-if-not (lambda (n) (search "VERSION" n)) acc) #'string<)))
(line "the old receipt, re-read after the bump, signals nothing: ~A"
      (handler-case (progn (s1 expansion-receipt-procedure-version *r*) "no alarm")
        (error (c) (format nil "~S" (type-of c)))))
