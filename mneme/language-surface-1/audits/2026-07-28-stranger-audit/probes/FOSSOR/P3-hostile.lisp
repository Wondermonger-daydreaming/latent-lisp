(load "/tmp/claude-1000/-home-gauss-Desktop-Claude-Code-Lab/d214ea40-d602-4f0d-b684-e6f5fddf4447/scratchpad/surface1-audit/probes/FOSSOR/prelude.lisp")
(in-package #:fossor)
(banner "P3 — HOSTILE STRUCTURE SURVIVAL, through the PUBLIC API")
;;; OUTCOME is one of: REFUSAL <code>/<upstream> | RECEIPT (bad) | ERROR <type> (bad) | HANG
(defun probe (label builder &key (op :macroexpand-1))
  (let ((t0 (get-internal-real-time)) (outcome nil))
    (handler-case
        (sb-ext:with-timeout 20
          (let ((form (funcall builder)))
            (handler-case
                (progn (s1 perform-expansion (s1 request-expansion form op (tag "h")))
                       (setf outcome "RECEIPT MINTED  <-- NOT A REFUSAL"))
              (lisp-plus-surface1:expansion-refused (c)
                (let ((r (lisp-plus-surface1:expansion-condition-refusal c)))
                  (setf outcome (format nil "REFUSAL ~S / upstream ~S / phase ~S"
                                        (rcode r) (rup r) (rphase r))))))))
      (sb-ext:timeout () (setf outcome "HANG (>20s)  <-- HOST ACCIDENT"))
      (storage-condition (c) (setf outcome (format nil "STORAGE-CONDITION ~A  <-- HOST ACCIDENT" (type-of c))))
      (error (c) (setf outcome (format nil "NON-REFUSAL ERROR ~S  <-- HOST ACCIDENT" (type-of c)))))
    (format t "  ~44A ~A   [~,3Fs]~%" label outcome
            (/ (- (get-internal-real-time) t0) internal-time-units-per-second))))

(probe "spine cycle  (a b c . <back to head>)"
       (lambda () (let ((x (list 'cl:quote 1 2 3))) (setf (cdr (last x)) (cdr x)) x)))
(probe "CAR cycle    (quote X) where (car X) = X"
       (lambda () (let ((x (list 0))) (setf (car x) x) (list 'cl:quote x))))
(probe "cons whose CAR is itself, directly under head"
       (lambda () (let ((x (cons nil nil))) (setf (car x) x) (list 'cl:quote x))))
(probe "dotted list  (quote (1 . 2))"
       (lambda () (list 'cl:quote (cons 1 2))))
(probe "dotted TAIL on the source form itself"
       (lambda () (list* 'cl:quote 1 2)))
(probe "shared subtree, two paths"
       (lambda () (let ((s (list 1 2))) (list 'cl:quote s s))))
(probe "deep CAR chain, 500 levels"
       (lambda () (let ((f 0)) (dotimes (i 500) (setf f (list f))) (list 'cl:quote f))))
(probe "deep CAR chain, 50 levels (just over ceiling 48)"
       (lambda () (let ((f 0)) (dotimes (i 50) (setf f (list f))) (list 'cl:quote f))))
(probe "MIXED: spine cycle whose CAR is also a cycle"
       (lambda () (let* ((c (list 0)) (x (list 'cl:quote c)))
                    (setf (car c) c) (setf (cdr (last x)) (cdr x)) x)))
(probe "long proper list, 100000 elements (not hostile, just long)"
       (lambda () (list 'cl:quote (make-list 100000 :initial-element 0))))
(probe "cycle in the OPERATION position is impossible; cycle in the TAG?"
       (lambda () (list 'cl:quote 1)))

(banner "P3b — THE SAME STRUCTURES HANDED TO THE PUBLIC ENCODE-TERM DIRECTLY")
(defun eprobe (label builder)
  (let ((t0 (get-internal-real-time)) (outcome nil))
    (handler-case
        (sb-ext:with-timeout 20 (s1 encode-term (funcall builder))
                             (setf outcome "ENCODED  <-- NOT A REFUSAL"))
      (sb-ext:timeout () (setf outcome "HANG  <-- HOST ACCIDENT"))
      (storage-condition () (setf outcome "CONTROL STACK EXHAUSTED  <-- HOST ACCIDENT"))
      (error (c) (setf outcome (format nil "~S~@[ / ~A~]" (type-of c)
                                       (and (typep c (find-symbol "%TERM-UNREPRESENTABLE" '#:lisp-plus-surface1))
                                            (funcall (find-symbol "%TU-REASON" '#:lisp-plus-surface1) c))))))
    (format t "  ~44A ~A   [~,3Fs]~%" label outcome
            (/ (- (get-internal-real-time) t0) internal-time-units-per-second))))
(eprobe "CAR cycle" (lambda () (let ((x (list 0))) (setf (car x) x) x)))
(eprobe "spine cycle" (lambda () (let ((x (list 1 2 3))) (setf (cdr (last x)) x) x)))
(eprobe "self-CAR cons" (lambda () (let ((x (cons nil nil))) (setf (car x) x) x)))
(eprobe "dotted" (lambda () (cons 1 2)))
(eprobe "500-deep CAR chain" (lambda () (let ((f 0)) (dotimes (i 500) (setf f (list f))) f)))
(eprobe "200000-deep CAR chain" (lambda () (let ((f 0)) (dotimes (i 200000) (setf f (list f))) f)))

(banner "P3c — WHICH CODE DOES A CAR-POSITION CYCLE LAND UNDER, AND WHY")
(let ((x (list 0)))
  (setf (car x) x)
  (let ((form (list 'cl:quote x)))
    (line "%host-depth of the CAR-cycle form ..... ~D  (ceiling ~D)"
          (s1i %host-depth form) (s1 expansion-policy-max-source-depth))
    (line "%host-nodes of the CAR-cycle form ..... ~D" (s1i %host-nodes form))
    (line "%shared-cons-count of it .............. ~D" (s1i %shared-cons-count form))
    (line "the code it actually lands under ...... ~S"
          (rcode (refusal-of (lambda () (s1 request-expansion form :macroexpand-1 (tag "c"))))))
    (line "the code ENCODE-TERM alone would give . ~S"
          (handler-case (progn (s1 encode-term form) :none)
            (error (c) (funcall (find-symbol "%TU-REASON" '#:lisp-plus-surface1) c))))))

(banner "P3d — THE MEASURED DEPTH EDGE: 63 encodes+decodes, 64 refuses?")
(defun nest (d) (let ((f 'cl:t)) (dotimes (i d) (setf f (list f))) f))
(defun survives (d)
  (handler-case (progn (cd0 decode-exact (cd0 canonical-octets (s1 encode-term (nest d)))) t)
    (error () nil)))
(let ((edge nil))
  (loop for d from 55 to 75 do (when (and (survives d) (not (survives (1+ d)))) (setf edge d)))
  (line "largest host depth that ENCODES *and* DECODES ... ~D" edge)
  (line "d=~D survives ~A · d=~D survives ~A" edge (survives edge) (1+ edge) (survives (1+ edge))))
(line "policy ceiling ~D · headroom in host levels ...... ~D"
      (s1 expansion-policy-max-source-depth)
      (- 63 (s1 expansion-policy-max-source-depth)))
(line "a form at EXACTLY the ceiling (48) mints a receipt? ~A"
      (handler-case
          (and (s1 expansion-receipt-p
                   (s1 perform-expansion
                       (s1 request-expansion
                           (list (find-symbol "DEFINE-JUDGMENT-SCHEMA" '#:lisp-plus-surface0)
                                 (intern "*FOSSOR-D*" '#:cl-user) :name :d :version 1
                                 :conclusion 0 :premises nil :locals nil :unique-locals nil)
                           :macroexpand-1 (tag "d48")))) t)
        (error (c) (format nil "~S" (type-of c)))))
(let ((f (list 'cl:quote (nest 46))))
  (line "host form at depth ~D through DOOR 1: ~S"
        (s1i %host-depth f)
        (or (rcode (refusal-of (lambda () (s1 request-expansion f :macroexpand-1 (tag "d")))))
            :accepted)))
