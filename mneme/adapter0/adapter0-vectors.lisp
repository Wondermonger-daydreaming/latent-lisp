;;;; adapter0-vectors.lisp — the registry-driven conformance gate.
;;;;
;;;; Run:  sbcl --script mneme/adapter0/adapter0-vectors.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; ONE canonical record arbitrates this gate: AP0-FIXTURE-REGISTRY.sexp.
;;;; Counts are derived by folding its entries live; the final tallies are
;;;; printed from LIVE COUNTERS after every intended case has executed.
;;;; For every REJECT vector the gate demands the DECLARED condition, not
;;;; merely a rejection — the right law must fire, not just any law.
;;;; Every frozen mutant must be killed BY ITS INTENDED RULE (§24.2).
;;;;
;;;; DETERMINISM: no pid, timestamp, absolute path, or random identity is
;;;; printed; this gate writes nothing.
;;;;
;;;; Gate teeth: ADAPTER0_VECTORS_PLANT_FAULT=1 plants a failing check
;;;; (exit 1); ADAPTER0_VECTORS_DIE=1 exits 3 mid-run with no RESULT
;;;; sentinel — truncation is detectable as exactly that pair.
;;;;
;;;; — CLAVIGER-IV (Claude Fable 5 subagent), 2026-07-30

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
        (format t "[V~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[V~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))))

(defun note (control &rest arguments)
  (apply #'format t control arguments)
  (terpri))

(note "adapter0-vectors — the frozen AP0 vector set under the ~
       independently seeded validator")
(note "registry: ONE canonical record; all counts derived live from its ~
       entries fold.~%")

;;; ---------------------------------------------------------------------------
(note "== registry arbitration ==")

(multiple-value-bind (positive adversarial total) (derive-registry-counts)
  (check (format nil "derived counts equal the registry's own scalars: ~
                      positive ~a · adversarial ~a · entries ~a · ~
                      mutants-on-disk ~a · vector-count ~a"
                 positive adversarial total
                 (length (enumerate-mutants))
                 (registry-scalar "vector-count"))
    (lambda ()
      (and (= positive (registry-scalar "positive-count"))
           (= adversarial (registry-scalar "adversarial-count"))
           (= (length (enumerate-mutants)) (registry-scalar "mutant-count"))
           (= (registry-scalar "vector-count")
              (+ total (registry-scalar "mutant-count")))))))

(check "the positive/ and adversarial/ directories hold exactly the ~
        files the registry names — nothing missing, nothing unregistered"
  (lambda ()
    (let ((registered (sort (mapcar #'registry-entry-path (registry-entries))
                            #'string<))
          (on-disk (sort (append
                          (mapcar (lambda (path)
                                    (format nil "vectors/positive/~a.pjs"
                                            (pathname-name path)))
                                  (directory (merge-pathnames
                                              "vectors/positive/*.pjs"
                                              +reissue-root+)))
                          (mapcar (lambda (path)
                                    (format nil "vectors/adversarial/~a.pjs"
                                            (pathname-name path)))
                                  (directory (merge-pathnames
                                              "vectors/adversarial/*.pjs"
                                              +reissue-root+))))
                         #'string<)))
      (equal registered on-disk))))

;;; ---------------------------------------------------------------------------
(note "~%== the eighty-one registered cases ==")

(defvar *accepted* 0)
(defvar *rejected* 0)

(dolist (entry (registry-entries))
  (let* ((case-id (registry-entry-case-id entry))
         (expected (registry-entry-verdict entry))
         (case-record (read-pjs-fixture
                       (merge-pathnames (registry-entry-path entry)
                                        +reissue-root+)))
         (declared (case-string case-record "condition")))
    (multiple-value-bind (verdict condition rule)
        (validate-case case-record)
      (cond
        ((equal expected "accept")
         (check (format nil "~a [~a] accepts" case-id
                        (registry-entry-family entry))
           (lambda ()
             (when (eq verdict :accept) (incf *accepted*) t))))
        (t
         (check (format nil "~a [~a] rejects with its declared condition ~
                             (~a; rule ~a)"
                        case-id (registry-entry-family entry)
                        declared rule)
           (lambda ()
             (when (and (eq verdict :reject) (equal condition declared))
               (incf *rejected*) t))))))))

(check (format nil "LIVE COUNTERS after all registered cases executed: ~
                    ~a accepted = positive-count, ~a rejected with ~
                    declared conditions = adversarial-count"
               *accepted* *rejected*)
  (lambda ()
    (and (= *accepted* (registry-scalar "positive-count"))
         (= *rejected* (registry-scalar "adversarial-count")))))

;;; ---------------------------------------------------------------------------
(note "~%== the twenty rule-omission mutants (§24.2) ==")

(defvar *killed* 0)

(dolist (mutant (enumerate-mutants))
  (multiple-value-bind (killed strict-verdict strict-condition mutant-verdict
                        declared)
      (run-registry-mutant mutant)
    (declare (ignore strict-verdict mutant-verdict))
    (check (format nil "~a kills BY ITS INTENDED RULE: full table rejects ~
                        ~a with ~a; table minus ~a accepts it"
                   (case-string mutant "mutant-id")
                   (case-string mutant "target-case")
                   (or declared strict-condition)
                   (case-string mutant "disabled-rule"))
      (lambda () (when killed (incf *killed*) t)))))

(check (format nil "LIVE COUNTER: ~a of ~a mutants killed — a validator ~
                    accepting any planted mutant is nonconforming ~
                    evidence"
               *killed* (registry-scalar "mutant-count"))
  (lambda () (= *killed* (registry-scalar "mutant-count"))))

;;; ---------------------------------------------------------------------------
(note "~%== gate teeth ==")

(when (equal (sb-ext:posix-getenv "ADAPTER0_VECTORS_PLANT_FAULT") "1")
  (check "PLANTED FAULT — this check must FAIL and the suite must exit 1"
    (lambda () nil)))

(when (equal (sb-ext:posix-getenv "ADAPTER0_VECTORS_DIE") "1")
  (note "ADAPTER0_VECTORS_DIE=1 — dying mid-run WITHOUT a RESULT sentinel ~
         (planted truncation)")
  (sb-ext:exit :code 3))

(unless (or (equal (sb-ext:posix-getenv "ADAPTER0_VECTORS_PLANT_FAULT") "1"))
  (check "the planted-fault gate FIRES: a child with ~
          ADAPTER0_VECTORS_PLANT_FAULT=1 exits 1 carrying FAIL PLANTED ~
          FAULT"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       (list "--script"
                             "mneme/adapter0/adapter0-vectors.lisp")
                       :search t
                       :output output :error output
                       :environment (cons "ADAPTER0_VECTORS_PLANT_FAULT=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 1 (sb-ext:process-exit-code process))
             (search "FAIL PLANTED FAULT" text)))))

  (check "the truncation tooth FIRES: a child with ADAPTER0_VECTORS_DIE=1 ~
          exits 3 with NO RESULT sentinel"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       (list "--script"
                             "mneme/adapter0/adapter0-vectors.lisp")
                       :search t
                       :output output :error output
                       :environment (cons "ADAPTER0_VECTORS_DIE=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 3 (sb-ext:process-exit-code process))
             (not (search "RESULT:" text)))))))

;;; ---------------------------------------------------------------------------

(format t "~%adapter0-vectors: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
