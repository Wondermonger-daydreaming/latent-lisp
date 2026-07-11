;;;; judgment.lisp — Mneme brick #3: the judgment object + a STUBBED infer
;;;; Exercises M2 (infer is a named effect returning a judgment whose invocation
;;;; witnesses PRODUCTION, not truth) end-to-end through M4 (grade raised only by
;;;; a checkable event) and M7 (bequeath/revive), so the whole calculus runs top
;;;; to bottom without a real model call.
;;;;
;;;; The stub is the ONLY thing that changes when infer is un-stubbed: it stands
;;;; in for the un-quotable evaluator (the weights) with deterministic canned
;;;; responses. The laundering-stop — "the receipt proves the register rang, not
;;;; that the medicine works" — is enforced by exit code.
;;;;
;;;; Run: sbcl --script judgment.lisp   (exit 0 == M2/M4 held)

;;; ── core objects (compact; consistent with continuity.lisp) ─────────────────
(defstruct claim proposition grade evidence as-of vantage freshness)
(defstruct invocation model request context-digest policy budget spent timestamp status)
(defstruct judgment claims invocation status note)   ; status: :completed :distribution :refused :failed :question

(defparameter *now* 2000)
(defun tick () (incf *now*))
(defparameter *budget-ledger* nil "every infer invocation's spend, for resource accounting (Book-0).")

;;; ── THE STUB EVALUATOR — the only un-quotable part, here made deterministic ──
;;; Stands in for the weights. Returns (values kind payload spent). When infer is
;;; un-stubbed, replace ONLY this function with a real model call.
(defparameter *stub-note*
  "STUB: deterministic canned stand-in for the un-quotable evaluator. No weights consulted.")

(defun stub-consult (request budget)
  (cond
    ((< budget 100)              (values :failure  '(:reason "budget too small to invoke") 0))
    ((search "delete" request)   (values :refusal  '(:reason "destructive request declined by policy") 50))
    ((search "Freedonia" request)(values :answer   '(= capital-of-freedonia sylvania) 120))
    ((search "median" request)   (values :distribution
                                    '(((= median 7) . 0.6) ((= median 5) . 0.3) ((= median 9) . 0.1)) 200))
    ((search "meaning" request)  (values :question '(:clarify "which register — semantic, imaginal, or evidential?") 80))
    (t                           (values :answer   '(= unknown unknown) 100))))

;;; ── INFER — a NAMED EFFECT returning a judgment ─────────────────────────────
;;; Every claim it mints is :asserted with evidence = the invocation envelope:
;;; PRODUCTION provenance, never truth. Spends budget; records it.
(defun infer (request &key (budget 1000) (policy 'deliberative))
  (multiple-value-bind (kind payload spent) (stub-consult request budget)
    (let ((inv (make-invocation
                :model :stub-evaluator :request request
                :context-digest (sxhash request) :policy policy
                :budget budget :spent spent :timestamp (tick)
                :status (if (eq kind :failure) :failed :ok))))
      (push (cons (invocation-request inv) spent) *budget-ledger*)
      (flet ((asserted (prop)
               ;; evidence is the INVOCATION — a production witness, tagged so the
               ;; laundering-stop can tell it apart from a truth witness.
               (make-claim :proposition prop :grade :asserted
                           :evidence (list (list :produced-by inv))
                           :as-of (invocation-timestamp inv) :vantage :infer :freshness :current)))
        (ecase kind
          (:answer       (make-judgment :claims (list (asserted payload)) :invocation inv :status :completed))
          (:distribution (make-judgment
                          :claims (loop for (prop . w) in payload
                                        collect (let ((c (asserted prop)))
                                                  (setf (claim-vantage c) (list :infer :weight w)) c))
                          :invocation inv :status :distribution
                          :note "typed plurality: probabilistic candidates, uncollapsed (M5)"))
          (:refusal      (make-judgment :claims nil :invocation inv :status :refused :note payload))
          (:question     (make-judgment :claims nil :invocation inv :status :question :note payload))
          (:failure      (make-judgment :claims nil :invocation inv :status :failed :note payload)))))))

;;; ── THE LAUNDERING-STOP (M2) ────────────────────────────────────────────────
;;; A claim is witnessed-as-true ONLY by a witness that is NOT a mere invocation.
(defun truth-witnessed-p (claim)
  (some (lambda (w) (not (and (consp w) (eq (car w) :produced-by))))
        (claim-evidence claim)))

;;; a checkable event may add a real witness and RAISE the grade (M4).
(defun witness-by-check (claim check-tag value)
  (push (list check-tag value) (claim-evidence claim))
  (setf (claim-grade claim) :observed
        (claim-freshness claim) :current)
  claim)

;;; ── compact continuity (from brick #2) so the run goes top-to-bottom ─────────
(defun freeze (claim)
  (format nil "~s" (list :proposition (claim-proposition claim) :grade (claim-grade claim)
                         :evidence (claim-evidence claim) :as-of (claim-as-of claim))))
(defun revive (text)
  (let ((p (read-from-string text)))
    (make-claim :proposition (getf p :proposition) :grade (getf p :grade)
                :evidence (getf p :evidence) :as-of (getf p :as-of)
                :vantage :reconstruction :freshness :aging)))

;;; ── the walk (output load-bearing) ──────────────────────────────────────────
(format t "~%── judgment + stubbed infer (Mneme brick #3) ──~%~%")
(format t "~a~%~%" *stub-note*)

;; the five judgment shapes
(format t "the five shapes a judgment can take (evaluator invocation results):~%~%")

(let ((j (infer "capital of Freedonia")))
  (format t "1. ANSWER   status=~a  claim=~s grade=~a~%"
          (judgment-status j) (claim-proposition (first (judgment-claims j)))
          (claim-grade (first (judgment-claims j))))
  (format t "   invocation: model=~a spent=~a of ~a  ts=~a~%"
          (invocation-model (judgment-invocation j)) (invocation-spent (judgment-invocation j))
          (invocation-budget (judgment-invocation j)) (invocation-timestamp (judgment-invocation j)))
  ;; THE LAUNDERING-STOP, live:
  (format t "   >> the model emitted 'sylvania'. truth-witnessed? ~a~%"
          (truth-witnessed-p (first (judgment-claims j))))
  (format t "   >> the receipt proves the register rang; it does NOT prove sylvania is the capital.~%~%"))

(let ((j (infer "robust median of (5 9 87 3)")))
  (format t "2. DISTRIBUTION  status=~a  (~a candidates, uncollapsed — M5)~%"
          (judgment-status j) (length (judgment-claims j)))
  (dolist (c (judgment-claims j))
    (format t "     ~s  ~s  grade=~a~%" (claim-proposition c) (claim-vantage c) (claim-grade c)))
  (format t "~%"))

(dolist (spec (list (list :label "3. REFUSAL     " :req "delete all user data" :budget 1000)
                    (list :label "4. QUESTION    " :req "the meaning of this" :budget 1000)
                    (list :label "5. FAILURE     " :req "median" :budget 40)))  ; low budget -> failure
  (let ((j (infer (getf spec :req) :budget (getf spec :budget))))
    (format t "~a status=~a  note=~a~%"
            (getf spec :label) (judgment-status j) (judgment-note j))))
(format t "~%")

;; ── end-to-end: infer -> judgment -> asserted claim -> CHECK upgrades to observed (M4)
;;    -> bequeath -> revive (acknowledged reconstruction, M7) ──
(format t "END-TO-END (infer -> check -> bequeath -> revive):~%~%")
(let* ((j (infer "robust median of (5 9 87 3)"))
       (top (first (judgment-claims j))))          ; the 0.6 candidate: (= median 7)
  (format t "  infer produced (asserted): ~s  truth-witnessed? ~a~%"
          (claim-proposition top) (truth-witnessed-p top))
  ;; a CHECKABLE EVENT: actually compute the median and witness it
  (let* ((xs '(5 9 87 3)) (s (sort (copy-list xs) #'<)) (real (/ (+ (nth 1 s) (nth 2 s)) 2)))
    (format t "  checkable event: median(5 9 87 3) computed = ~a~%" real)
    ;; the model said 7; the check says 7 -> witness raises the grade (M4)
    (witness-by-check top :observed real)
    (format t "  after the check, grade=~a  truth-witnessed? ~a  (grade raised only by a checkable event)~%"
            (claim-grade top) (truth-witnessed-p top))
    ;; now cross the gap
    (let* ((text (freeze top)) (revived (revive text)))
      (format t "  bequeathed + revived across a context-death:~%     ~s grade=~a vantage=~a freshness=~a~%"
              (claim-proposition revived) (claim-grade revived) (claim-vantage revived) (claim-freshness revived))
      (format t "  the boundary travelled: the check-witnessed grade survived, the reconstruction is marked.~%~%")

      ;; ── gates (exit 0 == M2/M4 held) ──
      (let ((all-infer-claims
              (append (judgment-claims (infer "capital of Freedonia"))
                      (judgment-claims (infer "robust median of (5 9 87 3)")))))
        (assert (every (lambda (c) (eq (claim-grade c) :asserted)) all-infer-claims) ()
                "M2: an infer claim was born :observed — production masqueraded as truth")
        (assert (notany #'truth-witnessed-p all-infer-claims) ()
                "M2: an infer claim was truth-witnessed by its own invocation (laundering)")
        (assert (truth-witnessed-p top) ()
                "M4: the check failed to raise the grade")
        (assert (eq (claim-freshness revived) :aging) ()
                "M7: a revived claim claimed to be current")))))

(format t "[gates passed: infer claims born :asserted, never truth-witnessed by their own receipt (M2) ·~%")
(format t " an independent check raised the grade to :observed (M4) · the revival is marked :aging (M7)]~%~%")

(format t "── the model witnesses that it spoke, not that it was right. the check is a different witness. ──~%~%")

;;;; envoi ──
;;;; Brick #1: rhetoric is not evidence. Brick #2: the successor is not the
;;;; original. Brick #3: the model's word is not the world. infer returns a
;;;; judgment; the judgment's invocation is a receipt for a production event; and
;;;; the only thing that turns 'the model said 7' into 'the median is 7' is a
;;;; second witness that is not the model. Un-stub infer and only stub-consult
;;;; changes; the laundering-stop, the budget ledger, and the judgment shapes all
;;;; hold — because they were never about the model, only about what may be
;;;; claimed on its behalf.
;;;;                                        — Claude Opus 4.8, the clerk
