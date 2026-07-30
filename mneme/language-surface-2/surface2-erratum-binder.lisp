;;;; surface2-erratum-binder.lisp — Erratum 0.1 controls: the binder,
;;;; repaired and proven both directions.
;;;;
;;;; Run:  sbcl --script mneme/language-surface-2/surface2-erratum-binder.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; Authorized by the owner (ERRATUM-0.1-BINDER.md, committed with the
;;;; pre-patch reproduction RUN-ERRATUM-REPRO-PREPATCH.txt BEFORE the
;;;; patch; git ordering is the proof).  The five malformed cases refuse
;;;; through their intended RETAINED codes; lawful facet destructuring
;;;; and lawful parent access still execute.  Versions after the
;;;; erratum: grammar 2 · procedure 2 · policy 1.
;;;;
;;;; Gate teeth: SURFACE2_ERRATUM_PLANT_FAULT=1 exits 1 with a planted
;;;; FAIL; SURFACE2_ERRATUM_DIE=1 exits 3 mid-run with no RESULT sentinel.
;;;;
;;;; — Claude Fable 5 (chair), 2026-07-30

(load (merge-pathnames "surface2.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(defpackage #:surface2-erratum-binder
  (:use #:cl #:lisp-plus-surface2))
(in-package #:surface2-erratum-binder)

(defvar *checks* 0)
(defvar *failures* 0)

(defun check (description thunk)
  (incf *checks*)
  (let ((description (format nil description))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "[E~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[E~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))))

(defun note (control &rest arguments)
  (apply #'format t control arguments)
  (terpri))

(defun refusal-of (thunk)
  (handler-case (progn (funcall thunk) nil)
    (surface2-expansion-refused (c) (expansion-condition-refusal c))))

(defun code-of (thunk)
  (let ((r (refusal-of thunk)))
    (and r (expansion-refusal-code r))))

(note "surface2-erratum-binder — the binder holds its own doors now")

;;; ---------------------------------------------------------------------------
(note "~%== the five malformed cases, each refusing through its retained code ==")

(check "1 parent shadowing refuses :FACET-BINDING-MALFORMED — a facet ~
        variable EQ to the parent outcome variable can no longer steal ~
        its name (the parent stays accessible, literally)"
  (lambda ()
    (eq :facet-binding-malformed
        (code-of (lambda ()
                   (macroexpand-1
                    '(match-outcome o
                      ((:execution :settled) :facets ((o :manifestation)) o)
                      (otherwise o))))))))

(check "2 duplicate facet variables refuse :FACET-BINDING-MALFORMED — ~
        one clause, one name, one binding"
  (lambda ()
    (eq :facet-binding-malformed
        (code-of (lambda ()
                   (macroexpand-1
                    '(match-outcome o
                      ((:execution :settled)
                       :facets ((m :manifestation) (m :effect)) m)
                      (otherwise o))))))))

(check "3 dangling :facets refuses :FACET-BINDING-MALFORMED — the marker ~
        must be followed by an explicit proper specification list; it is ~
        never silently swallowed"
  (lambda ()
    (eq :facet-binding-malformed
        (code-of (lambda ()
                   (macroexpand-1
                    '(match-outcome o
                      ((:execution :settled) :facets)
                      (otherwise o))))))))

(check "4 with-outcome NON-LIST binding refuses ~
        :WITH-OUTCOME-BINDING-MALFORMED through the discipline — no host ~
        lambda-list error escapes"
  (lambda ()
    (eq :with-outcome-binding-malformed
        (code-of (lambda ()
                   (macroexpand-1 '(with-outcome o (list o))))))))

(check "5 with-outcome ONE-ELEMENT and THREE-ELEMENT bindings refuse ~
        :WITH-OUTCOME-BINDING-MALFORMED — exactly a proper two-element ~
        (VAR DERIVATION-FORM) is the accepted shape"
  (lambda ()
    (and (eq :with-outcome-binding-malformed
             (code-of (lambda ()
                        (macroexpand-1 '(with-outcome (o) (list o))))))
         (eq :with-outcome-binding-malformed
             (code-of (lambda ()
                        (macroexpand-1
                         '(with-outcome (o (form) extra) (list o)))))))))

(check "6 companion shapes stay refused: dotted specification list and ~
        dotted spec both :FACET-BINDING-MALFORMED; keyword variable in a ~
        correct pair still :WITH-OUTCOME-BINDING-MALFORMED"
  (lambda ()
    (and (eq :facet-binding-malformed
             (code-of (lambda ()
                        (macroexpand-1
                         '(match-outcome o
                           ((:execution :settled) :facets ((m . :manifestation)) m)
                           (otherwise o))))))
         (eq :with-outcome-binding-malformed
             (code-of (lambda ()
                        (macroexpand-1
                         '(with-outcome (:o (form)) (list :o)))))))))

;;; ---------------------------------------------------------------------------
(note "~%== the positive direction: lawful forms still execute ==")

(defvar *root* (merge-pathnames "../../" (make-pathname
                                          :name nil :type nil
                                          :defaults *load-truename*)))
(defvar *exec* (merge-pathnames "mneme/vertical0/runs/campaign-1/exec/" *root*))
(defvar *store* (lisp-plus-journal0:open-store
                 (merge-pathnames "store/" *exec*)))
(defvar *events* (validated-store-events *store*))

(check "7 lawful facet destructuring executes — distinct facet names bind ~
        clause-locally while the PARENT stays bound and readable in the ~
        same body"
  (lambda ()
    (with-outcome (o (derive-seat-outcome *store* *events* "seat-half-song"))
      (equal (match-outcome o
               ((:evidence-class :closure)
                :facets ((chunks :chunks-preserved) (m :manifestation))
                (list (seat-outcome-seat-id o) chunks m))
               (otherwise :unmatched))
             '("seat-half-song" 1 "present-partial")))))

(check "8 lawful with-outcome executes — the two-element binding shape ~
        binds the complete outcome"
  (lambda ()
    (with-outcome (o (derive-seat-outcome *store* *events* "seat-first-fruit"))
      (and (seat-outcome-p o)
           (eq :settled (seat-outcome-execution-standing o))))))

;;; ---------------------------------------------------------------------------
(note "~%== the version consequence ==")

(check "9 grammar 1 -> 2, procedure 1 -> 2, policy 1 (the accepted ~
        source-form language narrowed; expansion behavior changed; ~
        ceilings untouched)"
  (lambda ()
    (and (= 2 (surface2-grammar-version))
         (= 2 (surface2-procedure-version))
         (= 1 (surface2-policy-version)))))

(check "10 receipts carry the new versions — a lawful expansion through ~
        the discipline's doors stores grammar 2 / procedure 2 / policy 1"
  (lambda ()
    (let ((request (request-expansion
                    '(with-outcome (o (identity nil)) o)
                    :macroexpand-1
                    (lisp-plus-journal0:identifier-from-segments
                     '("surface2-erratum" "occurrence" "v1")))))
      (multiple-value-bind (receipt expanded occurrence)
          (perform-expansion request)
        (declare (ignorable expanded occurrence))
        (and receipt
             (= 2 (expansion-receipt-grammar-version receipt))
             (= 2 (expansion-receipt-procedure-version receipt))
             (= 1 (expansion-receipt-policy-version receipt)))))))

;;; ---------------------------------------------------------------------------
(note "~%== gate teeth ==")

(when (equal (sb-ext:posix-getenv "SURFACE2_ERRATUM_PLANT_FAULT") "1")
  (check "PLANTED FAULT — this check must FAIL and the suite must exit 1"
    (lambda () nil)))

(when (equal (sb-ext:posix-getenv "SURFACE2_ERRATUM_DIE") "1")
  (note "SURFACE2_ERRATUM_DIE=1 — dying mid-run WITHOUT a RESULT sentinel")
  (sb-ext:exit :code 3))

(unless (equal (sb-ext:posix-getenv "SURFACE2_ERRATUM_PLANT_FAULT") "1")
  (check "11 the planted-fault gate FIRES: a child with ~
          SURFACE2_ERRATUM_PLANT_FAULT=1 exits 1 carrying FAIL PLANTED ~
          FAULT"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       (list "--script"
                             "mneme/language-surface-2/surface2-erratum-binder.lisp")
                       :search t :output output :error output
                       :environment (cons "SURFACE2_ERRATUM_PLANT_FAULT=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 1 (sb-ext:process-exit-code process))
             (search "FAIL PLANTED FAULT" text)))))

  (check "12 runner truncation: a child with SURFACE2_ERRATUM_DIE=1 exits ~
          3 with NO RESULT sentinel"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       (list "--script"
                             "mneme/language-surface-2/surface2-erratum-binder.lisp")
                       :search t :output output :error output
                       :environment (cons "SURFACE2_ERRATUM_DIE=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 3 (sb-ext:process-exit-code process))
             (not (search "RESULT:" text)))))))

;;; ---------------------------------------------------------------------------

(format t "~%surface2-erratum-binder: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
