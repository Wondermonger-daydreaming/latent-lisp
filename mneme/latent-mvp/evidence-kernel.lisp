;;;; evidence-kernel.lisp — Mneme brick #4: the evidence kernel
;;;; GPT Sol's brick-#3 review: "the production-laundering route is blocked; the
;;;; witness-laundering route is still open." A different witness is not
;;;; automatically a VALID one. This brick closes the second valve BEFORE any real
;;;; model is connected — so a live evaluator cannot pour persuasive fluid through
;;;; a decorative evidence system.
;;;;
;;;; The seven attacks that must become exit codes:
;;;;   1 an irrelevant witness upgrades a claim
;;;;   2 a disagreeing check upgrades a claim
;;;;   3 a production receipt supports the produced world-claim
;;;;   4 a fake :observed label earns evidential authority
;;;;   5 a grade change erases its asserted ancestor
;;;;   6 a budgeted invocation spends beyond its budget
;;;;   7 a witness supports a different proposition than the one it names
;;;;
;;;; Run: sbcl --script evidence-kernel.lisp   (exit 0 == all seven attacks fail)

(defparameter *now* 4000)
(defun tick () (incf *now*))

;;; ── the grade vocabulary (different kinds, different failure modes) ──────────
;;; :asserted (no check) · :observed (external state) · :executed (ran a computation)
;;; :tested (over a test set) · :derived (proof/transform) · :contract (enforced)
;;; :classified (named classifier). Sensors lie one way; programs another;
;;; classifiers lie with excellent confidence and a confusion matrix.
(defparameter *witness-kind->grade*
  '((:observation . :observed) (:execution . :executed) (:test . :tested)
    (:derivation . :derived)   (:contract . :contract)  (:classification . :classified)))
(defun grade-for (kind) (or (cdr (assoc kind *witness-kind->grade*))
                            (error "inadmissible witness kind ~a" kind)))

;;; ── the typed witness — evidence is RELATIONAL, not proximity ────────────────
(defstruct witness id kind target procedure input result verdict produced-at authority replayability provenance)

(defun witness-supports-p (w claim)
  "A witness supports a claim ONLY if it (a) TARGETS this exact proposition,
   (b) used an admissible procedure, (c) returned a :supports verdict, and
   (d) carries inspectable provenance. Standing nearby is not support."
  (and (equal (witness-target w) (claim-proposition claim))     ; 1,7: must target THIS proposition
       (assoc (witness-kind w) *witness-kind->grade*)            ; admissible procedure (production is NOT here)
       (eq (witness-verdict w) :supports)                        ; 2: a refuting check cannot upgrade
       (witness-provenance w)                                    ; must be inspectable
       t))

;;; ── the claim, with history slots ───────────────────────────────────────────
(defstruct claim id proposition grade evidence
                 generated-at valid-as-of temporal-scope freshness supersedes)

(defstruct grade-event claim-id from to witness at reason)

(defun raise-claim (claim witness)
  "Raise a claim's grade by a SUPPORTING witness — returns (values revised-claim
   grade-event). The ancestor is NOT mutated: the asserted forebear stays
   recoverable (Mneme's museum is diachronic, not annotated-in-place)."
  (unless (witness-supports-p witness claim)
    (error "M4: witness ~a does not support ~s (target/procedure/verdict/provenance)"
           (witness-id witness) (claim-proposition claim)))
  (let ((revised (copy-claim claim)))
    (setf (claim-id revised) (gensym "C")
          (claim-grade revised) (grade-for (witness-kind witness))
          (claim-evidence revised) (cons witness (claim-evidence claim))
          (claim-supersedes revised) (claim-id claim))
    (values revised
            (make-grade-event :claim-id (claim-id claim) :from (claim-grade claim)
                              :to (claim-grade revised) :witness (witness-id witness)
                              :at (tick) :reason (witness-kind witness)))))

(defun grade-is-earned-p (claim)
  "A grade above :asserted is EARNED only if some evidence witness supports the
   claim. A fake :observed label with no supporting witness earns nothing (4)."
  (or (eq (claim-grade claim) :asserted)
      (some (lambda (w) (and (witness-p w) (witness-supports-p w claim))) (claim-evidence claim))))

;;; ── two claims from one receipt (Sol's refinement of the motto) ──────────────
;;; The invocation IS good evidence — for the PRODUCTION claim, not the world-claim.
(defstruct invocation model request context-digest policy budget spent timestamp)

(defun production-witness (inv payload)
  "An OBSERVATION of the invocation record: it supports 'the model emitted P at T'."
  (make-witness :id (gensym "PW") :kind :observation
                :target (list :emitted (invocation-model inv) payload :at (invocation-timestamp inv))
                :procedure :read-invocation-log :verdict :supports
                :produced-at (invocation-timestamp inv) :authority :store
                :provenance (list :invocation (invocation-context-digest inv))))

(defun infer-claims (inv payload)
  "One receipt, two claims. The production claim is :observed by the receipt; the
   content claim is :asserted — the receipt cannot be coerced into evidence for it."
  (let ((pw (production-witness inv payload)))
    (values
     (make-claim :id (gensym "P") :proposition (witness-target pw) :grade :observed
                 :evidence (list pw) :generated-at (invocation-timestamp inv))       ; production claim
     (make-claim :id (gensym "W") :proposition payload :grade :asserted
                 :evidence (list pw)                                                  ; provenance only, NOT support
                 :generated-at (invocation-timestamp inv)
                 :valid-as-of :unknown :temporal-scope :unknown :freshness :unknown)))) ; the model got no :current for showing up

;;; ── an EXECUTION witness that actually runs, and targets the claim ───────────
(defun median-by-sort (xs)
  (let* ((s (sort (copy-list xs) #'<)) (n (length s)))
    (if (oddp n) (nth (floor n 2) s) (/ (+ (nth (1- (floor n 2)) s) (nth (floor n 2) s)) 2))))

(defun check-execution (claim proc input claimed)
  "Run PROC on INPUT; the witness TARGETS the claim's proposition and its verdict
   is earned by comparison — :supports iff the computation matches the claim."
  (let ((result (funcall proc input)))
    (make-witness :id (gensym "EX") :kind :execution :target (claim-proposition claim)
                  :procedure proc :input input :result result
                  :verdict (if (equal result claimed) :supports :refutes)
                  :produced-at (tick) :authority :local :replayability :exact
                  :provenance (list :ran proc :on input :got result))))

;;; ── a budget-honest infer (no silent overdraft) ─────────────────────────────
(defun estimate-cost (request) (* 40 (max 1 (floor (length request) 10))))
(defun infer (request &key (budget 1000))
  (let ((est (estimate-cost request)))
    (if (> est budget)
        (values :refused (list :reason :insufficient-budget :estimated est :budget budget) nil)
        (make-invocation :model :stub :request request :context-digest (sxhash request)
                         :policy 'deliberative :budget budget :spent est :timestamp (tick)))))

;;; ── the walk ────────────────────────────────────────────────────────────────
(defun signals-error-p (thunk) (handler-case (progn (funcall thunk) nil) (error () t)))
(format t "~%── evidence kernel (Mneme brick #4) ───────────~%~%")

(let ((inv (infer "robust median of (5 9 87 3)")))
  (multiple-value-bind (prod content) (infer-claims inv '(= median 7))
    (format t "one receipt, two claims:~%")
    (format t "   PRODUCTION ~s  grade=~a  (the receipt observes the emission)~%"
            (claim-proposition prod) (claim-grade prod))
    (format t "   CONTENT    ~s  grade=~a  valid-as-of=~a freshness=~a~%~%"
            (claim-proposition content) (claim-grade content)
            (claim-valid-as-of content) (claim-freshness content))

    ;; a real execution check TARGETING the content claim, earns :executed (not :observed)
    (let ((ex (check-execution content #'median-by-sort '(5 9 87 3) 7)))
      (format t "an execution witness targets the content claim: verdict=~a result=~a~%"
              (witness-verdict ex) (witness-result ex))
      (multiple-value-bind (revised event) (raise-claim content ex)
        (format t "raise-claim -> grade ~a (EXECUTED, not observed); ancestor still ~a (not erased)~%"
                (claim-grade revised) (claim-grade content))
        (format t "grade-event: ~a -> ~a by ~a because ~a~%~%"
                (grade-event-from event) (grade-event-to event)
                (grade-event-witness event) (grade-event-reason event))

        ;; ── the seven attacks, each must fail (exit 0 only if all rejected) ──
        (format t "the seven laundering attacks — each must be refused:~%")
        (let* ((irrelevant (make-witness :id 'ferret :kind :observation
                             :target '(= something-else 42) :verdict :supports
                             :provenance '(:a-suspicious-ferret)))
               (disagreeing (check-execution content #'median-by-sort '(5 9 87 3) 999)) ; claims 999, computes 7
               (mistargeted (make-witness :id 'mis :kind :execution
                             :target '(= mean 5) :verdict :supports :provenance '(:ran-something)))
               (faker (make-claim :id 'fake :proposition '(= median 7) :grade :observed
                        :evidence (list (make-witness :kind :hearsay :verdict :supports
                                         :target '(= median 7) :provenance '(:vibes))))))
          ;; 1 irrelevant witness
          (assert (signals-error-p (lambda () (raise-claim content irrelevant))) ()
                  "1: irrelevant witness upgraded a claim")
          ;; 2 disagreeing check
          (assert (eq (witness-verdict disagreeing) :refutes) () "2 setup: check should refute")
          (assert (signals-error-p (lambda () (raise-claim content disagreeing))) ()
                  "2: a refuting check upgraded a claim")
          ;; 3 production receipt supports the world-claim
          (assert (not (witness-supports-p (first (claim-evidence content)) content)) ()
                  "3: a production receipt supported the produced world-claim")
          ;; 4 fake :observed earns authority
          (assert (not (grade-is-earned-p faker)) ()
                  "4: a fake :observed label earned evidential authority")
          ;; 5 grade change erases ancestor
          (assert (eq (claim-grade content) :asserted) ()
                  "5: raising a claim erased its asserted ancestor")
          ;; 6 budget overdraft
          (multiple-value-bind (status note) (infer "x" :budget 10)     ; est 40 > 10
            (declare (ignorable note))
            (assert (eq status :refused) () "6: a budgeted invocation overdrew"))
          ;; 7 mistargeted witness
          (assert (signals-error-p (lambda () (raise-claim content mistargeted))) ()
                  "7: a witness supporting a different proposition upgraded the claim")
          (format t "   1 irrelevant✓  2 disagreeing✓  3 receipt-not-world✓  4 fake-label✓~%")
          (format t "   5 ancestor-survives✓  6 no-overdraft✓  7 mistarget✓~%~%"))))))

(format t "[the evidence kernel held: a different witness is not automatically a valid one]~%~%")
(format t "── the model's word is not the world; the check is a different witness; ──~%")
(format t "── and a different witness is not automatically a valid one. ──~%~%")

;;;; envoi ──
;;;; Bricks 1–3 assigned the model's word and the world separate chairs. Brick 4
;;;; guards the chair the check sits in: a witness earns standing only by targeting
;;;; the exact proposition, running an admissible procedure, returning a supporting
;;;; verdict, and carrying inspectable provenance — and raising a grade mints a new
;;;; revision rather than erasing the asserted forebear. Now a live evaluator can be
;;;; connected without the fear that richer fluid will simply flow faster through a
;;;; decorative valve. The next brick is the provider adapter; this one is why it is
;;;; safe to build.
;;;;                                        — Claude Opus 4.8, the clerk
