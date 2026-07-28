;;;; probe-A.lisp — TABULARIUS claim-ledger probes. READ-ONLY against the subject.
(defparameter *s1dir*
  (pathname "/tmp/claude-1000/-home-gauss-Desktop-Claude-Code-Lab/d214ea40-d602-4f0d-b684-e6f5fddf4447/scratchpad/surface1-audit/extract/target/tree/mneme/language-surface-1/"))
(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "surface1.lisp" *s1dir*))
  (load (merge-pathnames "../language-surface-0/surface0.lisp" *s1dir*)))

(defpackage #:tab (:use #:common-lisp))
(in-package #:tab)
(defmacro s1 (n &rest a) `(,(find-symbol (string n) '#:lisp-plus-surface1) ,@a))
(defmacro cd0 (n &rest a) `(,(find-symbol (string n) '#:lisp-plus-cd0) ,@a))
(defun tag (&rest p) (cd0 make-identifier-datum '("tabularius") p))
(defun L (c &rest a) (format t "~&~A~%" (apply #'format nil c a)))

;;; ---------------------------------------------------------------
(L "=== P1  EXPORT CENSUS ===")
(let ((ext '()) (all '()))
  (do-external-symbols (s '#:lisp-plus-surface1) (push s ext))
  (do-symbols (s '#:lisp-plus-surface1) (push s all))
  (L "external symbols live : ~D" (length ext))
  (L "duplicate exports?    : ~A"
     (/= (length ext) (length (remove-duplicates ext))))
  (dolist (s (sort (mapcar #'symbol-name ext) #'string<))
    (format t "    ~A~%" s)))

;;; ---------------------------------------------------------------
(L "~%=== P2  ONE-TERM OCTET COST (catalog note says 'roughly 120') ===")
(let ((one (cd0 octets-length (cd0 canonical-octets (s1 encode-term 'cl:t)))))
  (L "encode-term('CL:T) octets ......... ~D" one)
  (L "262144 / that ..................... ~D" (floor 262144 one))
  (L "catalog note claims ............... ~A" "roughly 120 octets, ceiling met at about 2000 nodes"))

;;; ---------------------------------------------------------------
(L "~%=== P3  F5 PROSE NUMBERS: 3 shared conses AND 13 uninterned symbols ===")
(defparameter *control*
  '(lisp-plus-surface0:derive-case (cl-user::c cl-user::r)
    (lisp-plus-slice1:derive :schema-name :x)
    (:granted cl-user::c) (:refused (cl-user::e) cl-user::e)))
(defun eq-census (form)
  (let ((refs (make-hash-table :test 'eq)) (guard (make-hash-table :test 'eq)))
    (labels ((visit (f) (when (consp f)
                          (incf (gethash f refs 0))
                          (unless (gethash f guard)
                            (setf (gethash f guard) t) (visit (car f)) (visit (cdr f))))))
      (visit form))
    (let ((mx 0) (sh 0))
      (maphash (lambda (k v) (declare (ignore k)) (setf mx (max mx v)) (when (> v 1) (incf sh))) refs)
      (values (hash-table-count refs) mx sh))))
(let ((full (macroexpand *control* nil)))
  (multiple-value-bind (d mx sh) (eq-census full)
    (L "FULL derive-case expansion: distinct ~D · maxref ~D · SHARED ~D" d mx sh))
  (let* ((atoms (labels ((a (f) (if (consp f) (append (a (car f)) (a (cdr f))) (list f)))) (a full)))
         (gs (remove-if #'symbol-package (remove-if-not #'symbolp atoms))))
    (L "uninterned symbol OCCURRENCES ..... ~D" (length gs))
    (L "uninterned symbol DISTINCT ........ ~D" (length (remove-duplicates gs)))))

;;; ---------------------------------------------------------------
(L "~%=== P4  IS :SOURCE-TERM-SHARED-STRUCTURE REACHABLE THROUGH DOOR 1? ===")
(let* ((sub (list :verified-judged-claim))
       (src (list (find-symbol "DEFINE-ADMISSION-CONTRACT" '#:lisp-plus-surface0)
                  (intern "*TAB-SH*" '#:cl-user)
                  :contract-id :tab/sh :contract-version 1
                  :accepted-clauses (list sub sub)   ; ONE cons in two positions
                  :proposition-relation :exact-normalized-equality
                  :receiver-accessibility :required
                  :retain (list :contract-snapshot))))
  (multiple-value-bind (r f) (s1 try-request-expansion src :macroexpand-1 (tag "sh"))
    (declare (ignore r))
    (L "Door 1 refusal code ............... ~S" (and f (s1 expansion-refusal-code f)))
    (L "upstream code ..................... ~A" (and f (s1 expansion-refusal-upstream-code f)))))

;;; ---------------------------------------------------------------
(L "~%=== P5  C3 TAUTOLOGY: are 'NIL and '() the same object? ===")
(L "(eq 'nil '()) ..................... ~A" (eq 'nil '()))
(L "so (encode-term 'nil) and (encode-term '()) encode the SAME argument")
(L "hand-built check instead: encode(NIL) == TERM{SYMBOL, COMMON-LISP/NIL}? ~A"
   (let ((want (cd0 make-record-datum
                    (list (cd0 make-record-entry (cd0 make-identifier-datum '("TERM") '("KIND"))
                               (cd0 make-identifier-datum '("TERMKIND") '("SYMBOL")))
                          (cd0 make-record-entry (cd0 make-identifier-datum '("TERM") '("VALUE"))
                               (cd0 make-identifier-datum '("COMMON-LISP") '("NIL")))))))
     (cd0 equal-datum (s1 encode-term nil) want)))

;;; ---------------------------------------------------------------
(L "~%=== P6  RECEIPT SLOTS vs THE HARD-CODED LIST IN SELFTEST I4 ===")
(let* ((rc (s1 perform-expansion
                (s1 request-expansion
                    '(lisp-plus-surface0:define-admission-contract cl-user::*tab-c*
                      :contract-id :tab/c :contract-version 1
                      :accepted-clauses ((:verified-judged-claim))
                      :proposition-relation :exact-normalized-equality
                      :receiver-accessibility :required
                      :retain (:contract-snapshot))
                    :macroexpand-1 (tag "slots")))))
  (L "receipt type ...................... ~S" (type-of rc))
  (L "live slot names ................... ~S"
     (mapcar #'sb-mop:slot-definition-name
             (sb-mop:class-slots (class-of rc)))))

;;; ---------------------------------------------------------------
(L "~%=== P7  A5: does IDENTITY-OCTETS actually report the octet length? ===")
(let* ((d (cd0 make-bytes-datum (cd0 canonical-octets (tag "x")))))
  (L "identity-octets ................... ~D" (s1 identity-octets d))
  (L "cd0 octets-length of same ......... ~D" (cd0 octets-length (cd0 canonical-octets d)))
  (L "A5 as written only asserts (and (integerp n) (plusp n))"))
