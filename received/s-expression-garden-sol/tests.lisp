;;;; tests.lisp --- Deterministic trials and randomized garden law

(in-package #:s-expression-garden)

(defun test-failure (control &rest arguments)
  (error (apply #'format nil control arguments)))

(defmacro is (condition &optional note)
  `(unless ,condition
     (test-failure "Assertion failed: ~S~@[ -- ~A~]" ',condition ,note)))

(defun is-equal (expected actual &optional note)
  (unless (equal expected actual)
    (test-failure "Expected ~S, received ~S~@[ -- ~A~]"
                  expected actual note))
  t)

(defun replay-matched-p (receipt)
  (getf (cdr (replay-receipt receipt)) :matched))

(defun decision-details (receipt)
  (getf (receipt-field receipt :decision) :details))

(defun assert-receipt (receipt status rule)
  (is-equal status (receipt-status receipt) "receipt status")
  (is-equal rule (receipt-rule receipt) "receipt rule")
  (is (null (check-receipt-invariants receipt))
      "receipt invariants")
  (is (replay-matched-p receipt) "receipt replay")
  t)

(defun test-lawful-graft ()
  (let* ((garden (make-specimen-garden :id :test-lawful))
         (donor (find-specimen garden :stone-six))
         (recipient (find-specimen garden :incrementer))
         (donor-before (deep-copy-sexp (specimen-form donor)))
         (recipient-before (deep-copy-sexp (specimen-form recipient)))
         (donor-hash-before (specimen-hash donor))
         (recipient-hash-before (specimen-hash recipient))
         (receipt (attempt-graft garden :stone-six '(2)
                                 :incrementer '(2 2)))
         (hashes (receipt-field receipt :hashes)))
    (assert-receipt receipt :accepted :all-rules-satisfied)
    (is-equal '(garden-mul 2 3)
              (receipt-field receipt :transplant)
              "exact donated subtree")
    (is-equal '(lambda (x) (garden-add x (garden-mul 2 3)))
              (specimen-form recipient)
              "committed recipient")
    (is-equal (specimen-form recipient)
              (receipt-field receipt :post-form)
              "post form is committed candidate")
    (is-equal donor-before (specimen-form donor) "donor is immutable")
    (is-equal donor-hash-before (specimen-hash donor) "donor hash")
    (is-equal recipient-hash-before (getf hashes :recipient-pre))
    (is-equal (stable-sexp-hash recipient-before)
              (getf hashes :recipient-pre))
    (is-equal (specimen-hash recipient) (getf hashes :recipient-post))
    (is (= 1 (specimen-revision recipient)))
    (is (= 1 (length (garden-receipts garden))))
    (is (null (check-garden-invariants garden)))
    t))

(defun test-malformed-paths ()
  (let* ((garden (make-specimen-garden :id :test-paths))
         (recipient (find-specimen garden :incrementer))
         (before (specimen-hash recipient))
         (negative (attempt-graft garden :stone-six '(2 -1)
                                  :incrementer '(2 2)))
         (outside (attempt-graft garden :stone-six '(2)
                                 :incrementer '(99)))
         (dotted-path (cons 2 7))
         (dotted (attempt-graft garden :stone-six dotted-path
                                :incrementer '(2 2)))
         (circular-path (list 2)))
    (setf (cdr circular-path) circular-path)
    (let ((circular (attempt-graft garden :stone-six circular-path
                                   :incrementer '(2 2))))
      (assert-receipt negative :refused :malformed-donor-path)
      (assert-receipt outside :refused :malformed-recipient-path)
      (assert-receipt dotted :refused :malformed-donor-path)
      (assert-receipt circular :refused :malformed-donor-path)
      (is (search "#1=" (receipt->string circular))
          "circular attempted path remains printable evidence"))
    (is-equal before (specimen-hash recipient)
              "bad cuts never mutate the recipient")
    (is (= 4 (length (garden-receipts garden))))
    (is (null (check-garden-invariants garden)))
    t))

(defun test-identity-jurisdiction ()
  (let ((garden (make-specimen-garden :id :test-identities)))
    (let ((unknown-donor
            (attempt-graft garden :missing-donor '(2)
                           :incrementer '(2 2)))
          (unknown-recipient
            (attempt-graft garden :stone-six '(2)
                           :missing-recipient '(2 2))))
      (assert-receipt unknown-donor :refused :unknown-donor)
      (assert-receipt unknown-recipient :refused :unknown-recipient)
      (is (= 2 (length (garden-receipts garden))))
      (is (null (check-garden-invariants garden)))
      t)))

(defun test-contract-shape-violation ()
  (let* ((garden (make-specimen-garden :id :test-contract-shape))
         (recipient (find-specimen garden :incrementer))
         (before (specimen-hash recipient)))
    (register-specimen garden :bare-stone 42 *data-contract*)
    (let ((receipt (attempt-graft garden :bare-stone nil
                                  :incrementer nil)))
      (assert-receipt receipt :refused :contract-shape-violation)
      (is-equal before (specimen-hash recipient))
      t)))

(defun test-new-unbound-symbol ()
  (let* ((garden (make-specimen-garden :id :test-new-free-symbol))
         (recipient (find-specimen garden :incrementer))
         (before (specimen-hash recipient)))
    (register-specimen
     garden :unlicensed-seed
     '(lambda () unlicensed-sun)
     *nullary-number-contract*)
    (let ((receipt (attempt-graft garden :unlicensed-seed '(2)
                                  :incrementer '(2 2))))
      (assert-receipt receipt :refused :new-unbound-symbol)
      (is (member 'unlicensed-sun
                  (getf (decision-details receipt) :new-free-symbols)
                  :test #'eq))
      (is-equal before (specimen-hash recipient))
      t)))

(defun test-arity-violation ()
  (let* ((garden (make-specimen-garden :id :test-arity))
         (recipient (find-specimen garden :incrementer))
         (before (specimen-hash recipient))
         (receipt (attempt-graft garden :bad-arity-briar '(2)
                                 :incrementer '(2 2)))
         (arity (getf (receipt-field receipt :consequences) :arity)))
    (assert-receipt receipt :refused :arity-violation)
    (is (getf arity :issues))
    (is-equal before (specimen-hash recipient))
    t))

(defun test-free-symbol-capture ()
  (let* ((garden (make-specimen-garden :id :test-capture))
         (recipient (find-specimen garden :doubler))
         (before (specimen-hash recipient))
         (receipt (attempt-graft garden :incrementer '(2)
                                 :doubler '(2 2)))
         (details (decision-details receipt)))
    (assert-receipt receipt :refused :free-symbol-capture)
    (is (member 'x (getf details :captured) :test #'eq))
    (is-equal before (specimen-hash recipient))
    t))

(defun test-operator-domain-mismatch ()
  (let* ((garden (make-specimen-garden :id :test-domain))
         (recipient (find-specimen garden :incrementer))
         (before (specimen-hash recipient))
         (receipt (attempt-graft garden :string-vine '(2)
                                 :incrementer '(2 2)))
         (domain (getf (receipt-field receipt :consequences) :domain)))
    (assert-receipt receipt :refused :operator-domain-mismatch)
    (is (find :argument-domain-mismatch (getf domain :issues)
              :key (lambda (issue) (getf issue :kind)) :test #'eq))
    (is-equal before (specimen-hash recipient))
    t))

(defun test-unknown-operator-domain ()
  (let* ((garden (make-specimen-garden :id :test-unknown-operator))
         (recipient (find-specimen garden :incrementer))
         (before (specimen-hash recipient)))
    (register-specimen
     garden :foreign-weed
     '(lambda () (foreign-photosynthesis 9))
     *nullary-number-contract*)
    (let ((receipt (attempt-graft garden :foreign-weed '(2)
                                  :incrementer '(2 2))))
      (assert-receipt receipt :refused :unknown-operator-domain)
      (is-equal before (specimen-hash recipient))
      t)))

(defun test-behavioral-catastrophe-error ()
  (let* ((garden (make-specimen-garden :id :test-catastrophe-error))
         (recipient (find-specimen garden :incrementer))
         (before (specimen-hash recipient))
         (receipt (attempt-graft garden :zero-divisor '(2)
                                 :incrementer '(2 2)))
         (behavior (getf (receipt-field receipt :consequences) :behavior))
         (after (first (getf behavior :after))))
    (assert-receipt receipt :refused :behavioral-catastrophe)
    (is-equal :error (getf after :outcome))
    (is-equal before (specimen-hash recipient))
    t))

(defun test-behavioral-catastrophe-budget ()
  (let* ((garden (make-specimen-garden :id :test-catastrophe-budget))
         (recipient (find-specimen garden :incrementer))
         (before (specimen-hash recipient))
         (receipt (attempt-graft garden :sleeping-loop '(2)
                                 :incrementer '(2 2)))
         (behavior (getf (receipt-field receipt :consequences) :behavior))
         (after (first (getf behavior :after))))
    (assert-receipt receipt :refused :behavioral-catastrophe)
    (is-equal :budget-exhausted (getf after :outcome))
    (is-equal before (specimen-hash recipient))
    t))

(defun test-circular-provenance ()
  (let* ((garden (make-specimen-garden :id :test-provenance))
         (first (attempt-graft garden :counter-a '(2 2)
                               :counter-b '(2 2)))
         (a (find-specimen garden :counter-a))
         (before-a (specimen-hash a))
         (second (attempt-graft garden :counter-b '(2 2)
                                :counter-a '(2 2))))
    (assert-receipt first :accepted :all-rules-satisfied)
    (assert-receipt second :refused :circular-provenance)
    (is-equal before-a (specimen-hash a))
    (is (null (provenance-graph-cycles garden)))
    (is (null (check-garden-invariants garden)))
    t))

(defun test-receipts-are-graftable ()
  (let* ((garden (make-specimen-garden :id :test-meta-graft))
         (first (attempt-graft garden :stone-six '(2)
                               :incrementer '(2 2)))
         (identity (plant-receipt garden first :identity :warrant))
         (meta (attempt-graft garden identity nil :ledger '(1)))
         (ledger (specimen-form (find-specimen garden :ledger))))
    (assert-receipt first :accepted :all-rules-satisfied)
    (assert-receipt meta :accepted :all-rules-satisfied)
    (is-equal first (receipt-field meta :transplant))
    (is-equal first (second ledger))
    (is (null (structural-issues ledger)))
    (is (null (check-garden-invariants garden)))
    t))

(defun test-receipt-round-trip ()
  (let* ((garden (make-specimen-garden :id :test-round-trip))
         (receipt (attempt-graft garden :zero-divisor '(2)
                                 :incrementer '(2 2)))
         (printed (receipt->string receipt))
         (read-back
           (with-input-from-string (stream printed)
             (read-receipt stream))))
    (is-equal receipt read-back "WRITE/READ preserves the evidence")
    (is (null (check-receipt-invariants read-back)))
    (is (replay-matched-p read-back))
    t))

(defun test-replay-detects-rulebook-drift ()
  (let* ((garden (make-specimen-garden :id :test-rulebook-drift))
         (receipt (attempt-graft garden :stone-six '(2)
                                 :incrementer '(2 2)))
         (tampered (deep-copy-sexp receipt))
         (provenance (receipt-field tampered :provenance)))
    (setf (getf provenance :rulebook)
          (cons '(:precedence 0
                  :jurisdiction :apocrypha
                  :rule :the-moon-has-veto
                  :when :always
                  :disposition :refuse)
                (getf provenance :rulebook)))
    (let* ((report (replay-receipt tampered))
           (checks (getf (cdr report) :checks))
           (rulebook-check (assoc :rulebook checks)))
      (is (not (getf (cdr report) :matched))
          "replay must notice a changed lawbook")
      (is rulebook-check)
      (is (null (second rulebook-check)))
      t)))

;;; ---------------------------------------------------------------------------
;;; A tiny deterministic PRNG: randomized tests should be reproducible in court.

(defstruct (garden-rng (:constructor make-garden-rng (state)))
  state)

(defun rng-next (rng)
  (setf (garden-rng-state rng)
        (mod (+ (* 1664525 (garden-rng-state rng)) 1013904223)
             #x100000000)))

(defun rng-integer (rng bound)
  (if (plusp bound)
      (mod (rng-next rng) bound)
      0))

(defun rng-choice (rng sequence)
  (elt sequence (rng-integer rng (length sequence))))

(defun random-number-expression (rng depth &key variable-p)
  (if (or (zerop depth) (< (rng-integer rng 100) 38))
      (if (and variable-p (zerop (rng-integer rng 4)))
          'x
          (- (rng-integer rng 19) 9))
      (list (rng-choice rng '(garden-add garden-sub garden-mul))
            (random-number-expression rng (1- depth)
                                      :variable-p variable-p)
            (random-number-expression rng (1- depth)
                                      :variable-p variable-p))))

(defun random-contract ()
  '(:kind :executable
    :parameters ((x :number))
    :result :number
    :behavior-mode :contract
    :step-budget 400
    :probes ((:args (-2) :expect (:type :number))
             (:args (0) :expect (:type :number))
             (:args (3) :expect (:type :number)))))

(defun property-pure-replacement (trials seed)
  (let ((rng (make-garden-rng seed)))
    (loop repeat trials
          do (let* ((tree (random-number-expression rng 4 :variable-p t))
                    (paths (all-paths tree))
                    (path (rng-choice rng paths))
                    (replacement
                      (random-number-expression rng 3 :variable-p t))
                    (before (deep-copy-sexp tree))
                    (before-hash (stable-sexp-hash tree))
                    (target (deep-copy-sexp (subtree-at tree path)))
                    (result (replace-subtree tree path replacement)))
               (is-equal before tree
                         "replacement is persistent, not destructive")
               (is-equal before-hash (stable-sexp-hash tree))
               (is-equal replacement (subtree-at result path))
               (is (= (tree-node-count result)
                      (+ (- (tree-node-count tree)
                            (tree-node-count target))
                         (tree-node-count replacement)))))
          finally (return t))))

(defun numeric-leaf-paths (tree)
  (remove-if-not (lambda (path) (numberp (subtree-at tree path)))
                 (all-paths tree)))

(defun property-random-lawful-grafts (trials seed)
  (let ((rng (make-garden-rng seed)))
    (dotimes (trial trials t)
      (let* ((garden (make-garden :id (list :random-lawful trial)))
             (donor-body (random-number-expression rng 3 :variable-p nil))
             ;; The closed right branch guarantees at least one numeric
             ;; leaf while the left branch still exercises lexical variables.
             (recipient-body
               (list 'garden-add
                     (random-number-expression rng 3 :variable-p t)
                     (random-number-expression rng 3 :variable-p nil)))
             (recipient-form (list 'lambda '(x) recipient-body))
             (paths (numeric-leaf-paths recipient-form))
             (recipient-path (rng-choice rng paths))
             (donor-form (list 'lambda nil donor-body))
             (donor-before (deep-copy-sexp donor-form))
             (recipient-before (deep-copy-sexp recipient-form)))
        (register-specimen
         garden :donor donor-form
         '(:kind :executable :parameters nil :result :number
           :behavior-mode :contract :step-budget 400
           :probes ((:args () :expect (:type :number)))))
        (register-specimen garden :recipient recipient-form (random-contract))
        (let* ((receipt (attempt-graft garden :donor '(2)
                                       :recipient recipient-path))
               (expected (replace-subtree recipient-before recipient-path
                                          donor-body)))
          (assert-receipt receipt :accepted :all-rules-satisfied)
          (is-equal donor-before
                    (specimen-form (find-specimen garden :donor)))
          (is-equal expected
                    (specimen-form (find-specimen garden :recipient)))
          (is (null (check-garden-invariants garden))))))))

(defun random-malformed-path (rng)
  (case (rng-integer rng 4)
    (0 (list 2 -1))
    (1 (list 2 :thistle))
    (2 (list 999 (rng-integer rng 20)))
    (otherwise (cons 2 (+ 1 (rng-integer rng 20))))))

(defun property-random-refusals-are-atomic (trials seed)
  (let ((rng (make-garden-rng seed))
        (garden (make-specimen-garden :id :random-refusals)))
    (loop repeat trials
          do (let* ((recipient (find-specimen garden :incrementer))
                    (hash-before (specimen-hash recipient))
                    (revision-before (specimen-revision recipient))
                    (receipt (attempt-graft garden :stone-six
                                            (random-malformed-path rng)
                                            :incrementer '(2 2))))
               (assert-receipt receipt :refused :malformed-donor-path)
               (is-equal hash-before (specimen-hash recipient))
               (is (= revision-before (specimen-revision recipient)))))
    (is (= trials (length (garden-receipts garden))))
    (is (null (check-garden-invariants garden)))
    t))

(defparameter *deterministic-garden-tests*
  (list
   (cons "lawful graft, immutable donor, replay" #'test-lawful-graft)
   (cons "malformed paths still receive receipts" #'test-malformed-paths)
   (cons "identity jurisdiction" #'test-identity-jurisdiction)
   (cons "contract shape jurisdiction" #'test-contract-shape-violation)
   (cons "new unbound symbols" #'test-new-unbound-symbol)
   (cons "arity jurisdiction" #'test-arity-violation)
   (cons "free-symbol capture" #'test-free-symbol-capture)
   (cons "operator-domain mismatch" #'test-operator-domain-mismatch)
   (cons "unknown operator domain" #'test-unknown-operator-domain)
   (cons "behavioral exception quarantine" #'test-behavioral-catastrophe-error)
   (cons "behavioral budget quarantine" #'test-behavioral-catastrophe-budget)
   (cons "acyclic provenance" #'test-circular-provenance)
   (cons "receipts can themselves be grafted" #'test-receipts-are-graftable)
   (cons "receipt readable round trip" #'test-receipt-round-trip)
   (cons "replay detects rulebook drift" #'test-replay-detects-rulebook-drift)))

(defun run-tests (&key (trials 100)
                       (seed #x51EED123)
                       (stream *standard-output*)
                       (signal-on-failure t))
  "Run deterministic cases plus reproducible randomized properties.
Returns an inspectable (:TEST-REPORT ...) S-expression."
  (let ((passed 0)
        (failed 0)
        (failures nil))
    (labels ((run-one (name thunk)
               (handler-case
                   (progn
                     (funcall thunk)
                     (incf passed)
                     (format stream "  [PASS] ~A~%" name))
                 (error (condition)
                   (incf failed)
                   (push (list :test name
                               :condition (condition-symbol condition)
                               :message (princ-to-string condition))
                         failures)
                   (format stream "  [FAIL] ~A -- ~A~%" name condition)))))
      (format stream "~&The S-Expression Garden: test assize~%")
      (dolist (entry *deterministic-garden-tests*)
        (run-one (car entry) (cdr entry)))
      (run-one (format nil "persistent tree surgery (~D trials)" trials)
               (lambda () (property-pure-replacement trials seed)))
      (run-one (format nil "lawful randomized graft/replay (~D trials)" trials)
               (lambda ()
                 (property-random-lawful-grafts
                  trials (logxor seed #xA5A5A5A5))))
      (run-one (format nil "random refusals are atomic (~D trials)" trials)
               (lambda ()
                 (property-random-refusals-are-atomic
                  trials (logxor seed #xDEADBEEF)))))
    (let ((report
            (list :test-report
                  :seed seed
                  :trials-per-property trials
                  :passed passed
                  :failed failed
                  :success (zerop failed)
                  :failures (nreverse failures))))
      (format stream "~&Verdict: ~D passed, ~D failed.~%" passed failed)
      (when (and signal-on-failure (plusp failed))
        (error "Garden test assize failed: ~S" report))
      report)))
