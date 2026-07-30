;;;; adapter0-erratum-cost.lisp — Erratum 0.1 executable controls: the
;;;; ketiv/qere cost discipline (AP-COST-1 resolved against frozen CST-01).
;;;;
;;;; Run:  sbcl --script mneme/adapter0/adapter0-erratum-cost.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; Authorized by the owner ruling (Part II) recorded at
;;;; mneme/RULING-adapter0-closure-ap-cost-1-vertical0-2026-07-30.md and
;;;; specified by mneme/adapter0/ERRATUM-0.1-AP-COST-1.md, which was
;;;; committed BEFORE this gate or its production patch existed.
;;;;
;;;; DETERMINISM: nothing time-, pid-, or path-dependent is printed.
;;;; Gate teeth: ADAPTER0_ERRATUM_PLANT_FAULT=1 exits 1 with a planted
;;;; FAIL; ADAPTER0_ERRATUM_DIE=1 exits 3 mid-run with no RESULT sentinel.
;;;;
;;;; — Claude Fable 5 (chair), 2026-07-30

(load (merge-pathnames "load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-adapter0)

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

(defun refuses-with (thunk condition-class)
  "T iff THUNK signals exactly the named ap0 condition class."
  (handler-case (progn (funcall thunk) nil)
    (error (condition) (typep condition condition-class))))

(defun %amount-value (datum)
  "Host rational of a canonical CD/0 number datum — integer or reduced
rational.  Arithmetic consumes ONLY this; lexemes are never re-parsed."
  (cond ((integer-datum-p datum) (integer-datum-value datum))
        ((rational-datum-p datum) (/ (rational-datum-numerator datum)
                                     (rational-datum-denominator datum)))
        (t (error "not a canonical number datum"))))

(note "adapter0-erratum-cost — the ketiv/qere discipline, proven live")

;;; ---------------------------------------------------------------------------
(note "~%== canonicalization: one durable value per mathematical value ==")

(check "1 the CST-01 ketiv: \"1932912/1000000\" parses to the qere ~
        120807/62500 — an actual CD/0 REDUCED rational datum, not a string"
  (lambda ()
    (let ((amount (parse-cost-lexeme "1932912/1000000")))
      (and (rational-datum-p amount)
           (not (string-datum-p amount))
           (= 120807 (rational-datum-numerator amount))
           (= 62500 (rational-datum-denominator amount))))))

(check "2 \"100/1000000\" → 1/10000"
  (lambda ()
    (let ((amount (parse-cost-lexeme "100/1000000")))
      (and (rational-datum-p amount)
           (= 1 (rational-datum-numerator amount))
           (= 10000 (rational-datum-denominator amount))))))

(check "3 equivalent spellings collapse: \"2/4\" and \"1/2\" produce the ~
        SAME canonical durable value"
  (lambda ()
    (let ((left (parse-cost-lexeme "2/4"))
          (right (parse-cost-lexeme "1/2")))
      (and (rational-datum-p left) (rational-datum-p right)
           (= (rational-datum-numerator left)
              (rational-datum-numerator right))
           (= (rational-datum-denominator left)
              (rational-datum-denominator right))
           (= 1/2 (%amount-value left) (%amount-value right))))))

(check "4 the integer/rational seam is canonical: \"4/2\" and \"2\" ~
        produce ONE canonical value — an INTEGER datum (n/1 collapses; ~
        no rational-with-denominator-1 twin survives)"
  (lambda ()
    (let ((quotient (parse-cost-lexeme "4/2"))
          (plain (parse-cost-lexeme "2")))
      (and (integer-datum-p quotient)
           (integer-datum-p plain)
           (not (rational-datum-p quotient))
           (= 2 (integer-datum-value quotient) (integer-datum-value plain))))))

(check "5 sign is lawful in the grammar and canonicalizes: \"-2/4\" → ~
        reduced -1/2"
  (lambda ()
    (let ((amount (parse-cost-lexeme "-2/4")))
      (and (rational-datum-p amount)
           (= -1/2 (%amount-value amount))))))

;;; ---------------------------------------------------------------------------
(note "~%== refusals: the grammar is narrow, never the CL reader ==")

(check "6 binary floating-point syntax refuses cost-float-noncanonical ~
        (AP-COST-1): \"1.932912\""
  (lambda ()
    (refuses-with (lambda () (parse-cost-lexeme "1.932912"))
                  'cost-float-noncanonical)))

(check "7 exponent syntax refuses cost-float-noncanonical: \"1932912e-6\""
  (lambda ()
    (refuses-with (lambda () (parse-cost-lexeme "1932912e-6"))
                  'cost-float-noncanonical)))

(check "8 malformed rational syntax refuses cost-lexeme-noncanonical: ~
        empty denominator \"1932912/\""
  (lambda ()
    (refuses-with (lambda () (parse-cost-lexeme "1932912/"))
                  'cost-lexeme-noncanonical)))

(check "9 malformed: empty numerator \"/5\", junk \"abc\", embedded junk ~
        \"12a/3\", empty string, whitespace \"1 /2\" — each refuses ~
        cost-lexeme-noncanonical"
  (lambda ()
    (every (lambda (lexeme)
             (refuses-with (lambda () (parse-cost-lexeme lexeme))
                           'cost-lexeme-noncanonical))
           '("/5" "abc" "12a/3" "" "1 /2"))))

(check "10 zero denominator refuses cost-lexeme-noncanonical: \"5/0\" ~
        (the refusal is the parser's, not a leaked host division error)"
  (lambda ()
    (refuses-with (lambda () (parse-cost-lexeme "5/0"))
                  'cost-lexeme-noncanonical)))

(check "11 the CL reader is not the grammar: read-eval \"#.(+ 1 1)\", ~
        complex \"#C(1 2)\", package syntax \"cl:pi\" — each refuses ~
        typed, none evaluates"
  (lambda ()
    (every (lambda (lexeme)
             (refuses-with (lambda () (parse-cost-lexeme lexeme))
                           'ap0-condition))
           '("#.(+ 1 1)" "#C(1 2)" "cl:pi"))))

;;; ---------------------------------------------------------------------------
(note "~%== the live production path: ketiv retained, qere enacted ==")

(defvar *live* (bind-live-adapter (descriptor-by-identity "fake-reference-0")
                                  :instance-label "erratum-live"))

(defun %fresh-handle (label)
  (let ((prepared (prepare-invocation
                   *live* (make-invocation-spec
                           :logical-operation-id (format nil "op-~a" label)
                           :attempt-id (format nil "a-~a" label)
                           :run-label label))))
    (let ((handle (dispatch prepared :live-adapter *live*)))
      (await-terminal handle)
      handle)))

(check "12 missing cost remains missing: extract-cost without a price ~
        schedule returns the typed marker — not a record, NOT ZERO, not ~
        a number, and it carries its reason (AP-COST-4)"
  (lambda ()
    (let ((missing (extract-cost *live* (%fresh-handle "e12")
                                 "fake-cost-procedure-1")))
      (and (missing-cost-marker-p missing)
           (not (record-datum-p missing))
           (not (numberp missing))
           (stringp (missing-cost-marker-reason missing))))))

(check "13 the produced cost record carries BOTH fields: source-lexeme ~
        retained byte-exact as testimony AND canonical-amount as an ~
        actual CD/0 reduced rational; the old string-amount field is gone"
  (lambda ()
    (let ((cost (extract-cost *live* (%fresh-handle "e13")
                              "fake-cost-procedure-1"
                              :price-schedule-id "fake-prices-v0")))
      (and (record-datum-p cost)
           (equal "100/1000000" (case-string cost "source-lexeme"))
           (let ((amount (cost-canonical-amount cost)))
             (and (rational-datum-p amount)
                  (= 1/10000 (%amount-value amount))))
           (not (case-field-present-p cost "amount"))))))

(check "14 estimated remains distinct from billed: the record's standing ~
        is estimated; the erratum changed the amount REPRESENTATION, ~
        never the standing vocabulary (AP-COST-2/3)"
  (lambda ()
    (let ((cost (extract-cost *live* (%fresh-handle "e14")
                              "fake-cost-procedure-1"
                              :price-schedule-id "fake-prices-v0")))
      (and (equal "estimated" (case-string cost "standing"))
           (not (equal "billed" (case-string cost "standing")))))))

(check "15 arithmetic uses only the canonical amount: summing the CST-01 ~
        qere and the live record's qere over CD/0 accessor values gives ~
        483253/250000 exactly — no lexeme is re-parsed at use time"
  (lambda ()
    (let ((fixture-amount (parse-cost-lexeme "1932912/1000000"))
          (live-cost (extract-cost *live* (%fresh-handle "e15")
                                   "fake-cost-procedure-1"
                                   :price-schedule-id "fake-prices-v0")))
      (= 483253/250000
         (+ (%amount-value fixture-amount)
            (%amount-value (cost-canonical-amount live-cost)))))))

(check "16 the frozen CST-01 fixture is untouched fixture-language: its ~
        amount field is still the string \"1932912/1000000\" on disk, ~
        and the fixture VALIDATOR still accepts the case (the erratum ~
        patched the production path, not the frozen bytes)"
  (lambda ()
    (let ((fixture (read-pjs-fixture
                    (merge-pathnames "vectors/positive/CST-01.pjs"
                                     +reissue-root+))))
      (and (equal "1932912/1000000" (case-string fixture "amount"))
           (multiple-value-bind (verdict condition) (validate-case fixture)
             (declare (ignorable condition))
             (eq verdict :accept))))))

;;; ---------------------------------------------------------------------------
(note "~%== gate teeth ==")

(when (equal (sb-ext:posix-getenv "ADAPTER0_ERRATUM_PLANT_FAULT") "1")
  (check "PLANTED FAULT — this check must FAIL and the suite must exit 1"
    (lambda () nil)))

(when (equal (sb-ext:posix-getenv "ADAPTER0_ERRATUM_DIE") "1")
  (note "ADAPTER0_ERRATUM_DIE=1 — dying mid-run WITHOUT a RESULT ~
         sentinel (planted truncation)")
  (sb-ext:exit :code 3))

(unless (equal (sb-ext:posix-getenv "ADAPTER0_ERRATUM_PLANT_FAULT") "1")
  (check "17 the planted-fault gate FIRES: a child with ~
          ADAPTER0_ERRATUM_PLANT_FAULT=1 exits 1 carrying FAIL PLANTED ~
          FAULT"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       (list "--script"
                             "mneme/adapter0/adapter0-erratum-cost.lisp")
                       :search t
                       :output output :error output
                       :environment (cons "ADAPTER0_ERRATUM_PLANT_FAULT=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 1 (sb-ext:process-exit-code process))
             (search "FAIL PLANTED FAULT" text)))))

  (check "18 runner truncation before canonical result: a child with ~
          ADAPTER0_ERRATUM_DIE=1 exits 3 with NO RESULT sentinel — ~
          truncation is detectable as exactly that pair"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       (list "--script"
                             "mneme/adapter0/adapter0-erratum-cost.lisp")
                       :search t
                       :output output :error output
                       :environment (cons "ADAPTER0_ERRATUM_DIE=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 3 (sb-ext:process-exit-code process))
             (not (search "RESULT:" text)))))))

;;; ---------------------------------------------------------------------------

(format t "~%adapter0-erratum-cost: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
