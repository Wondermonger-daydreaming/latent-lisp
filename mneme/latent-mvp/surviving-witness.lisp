;;;; surviving-witness.lisp — Mneme brick #5: the positive control
;;;; GPT Sol's brick-#2b review: the kernel proved it can DISTRUST everything
;;;; ("safer than credulity but not yet useful epistemology"). It must also
;;;; correctly TRUST a valid witness across the gap. The obituary conflated two
;;;; questions — is the capability callable? is the historical testimony still
;;;; verified? — so factor them:
;;;;   verification-status  (did the work actually happen and check out?)   PRESERVED across the gap
;;;;   capability-status    (can the live hand still move?)                 DIES at the gap
;;;;   event-replayability  (can the work be repeated from procedure+input?) PRESERVED if inputs survive
;;;; The dead hand cannot move; its work can be repeated and its testimony can remain admissible.
;;;;
;;;; The two controls, both exit codes:
;;;;   POSITIVE — a verified, proposition-linked, replayable witness RETAINS authority after handoff
;;;;              and can be RE-VERIFIED by replay.
;;;;   NEGATIVE — a promise-only (unverified) witness whose support was the live capability LOSES
;;;;              authority when the capability dies.
;;;; Plus: the freeze loss report CROSSES the gap (the system must not lose its own loss report),
;;;;       and the handoff transition history is an append-only linked chain, not a single badge.
;;;;
;;;; Run: sbcl --script surviving-witness.lisp   (exit 0 == trust and distrust both correct)

(require :sb-md5)
(defparameter *now* 5000) (defun tick () (incf *now*))
(defun digest (s) (format nil "~(~{~2,'0x~}~)" (coerce (sb-md5:md5sum-string s) 'list)))

;;; ── the witness, with ORTHOGONAL status ─────────────────────────────────────
(defstruct witness id kind target procedure input result verdict
                 verification-status capability-status event-replayability resumability
                 provenance live-handle)

(defparameter *kind->grade* '((:observation . :observed) (:execution . :executed) (:test . :tested)))
(defun grade-for (k) (or (cdr (assoc k *kind->grade*)) :asserted))

(defun entomb (w)
  "Capability dies; verification and replayability persist. If procedure+input
   survived, the event is EXACTLY replayable even though the closure is gone."
  (make-witness :id (witness-id w) :kind (witness-kind w) :target (witness-target w)
                :procedure (witness-procedure w) :input (witness-input w) :result (witness-result w)
                :verdict (witness-verdict w)
                :verification-status (witness-verification-status w)          ; PRESERVED
                :capability-status :unavailable                                ; the hand cannot move
                :event-replayability (if (and (witness-procedure w) (witness-input w)) :exact :none)
                :resumability :none :provenance (witness-provenance w) :live-handle nil))

(defun witness-supports-p (w claim)
  "Support requires: targets this proposition · admissible kind · :supports verdict
   · inspectable provenance · and VERIFICATION-STATUS :verified. A promise is not
   a proof; an unverified label — live or dead — earns nothing."
  (and (equal (witness-target w) (claim-proposition claim))
       (assoc (witness-kind w) *kind->grade*)
       (eq (witness-verdict w) :supports)
       (eq (witness-verification-status w) :verified)
       (witness-provenance w) t))

(defun replay-witness (w)
  "The dead hand's work, repeated. Only if event-replayability is :exact."
  (unless (eq (witness-event-replayability w) :exact)
    (error "not exactly replayable (~a)" (witness-event-replayability w)))
  (funcall (fdefinition (witness-procedure w)) (witness-input w)))   ; procedure is a SYMBOL, resolvable

;;; ── claims; grade is RE-DERIVED from surviving evidence ─────────────────────
(defstruct claim id proposition grade evidence supersedes)
(defun regrade-from-evidence (claim)
  "A revived claim's grade is exactly what its SURVIVING evidence supports —
   no more. This is where trust and distrust are both decided, mechanically."
  (let ((w (find-if (lambda (w) (witness-supports-p w claim)) (claim-evidence claim))))
    (if w (grade-for (witness-kind w)) :asserted)))

;;; ── freeze / revive that carry the loss report ACROSS the gap ───────────────
(defun witness->data (w)
  (list :kind (witness-kind w) :target (witness-target w) :procedure (witness-procedure w)
        :input (witness-input w) :result (witness-result w) :verdict (witness-verdict w)
        :verification-status (witness-verification-status w) :capability-status (witness-capability-status w)
        :event-replayability (witness-event-replayability w) :provenance (witness-provenance w)))
(defun data->witness (p) (apply #'make-witness p))

(defun freeze-claim (claim)
  (let* ((entombed (mapcar (lambda (w) (entomb w)) (claim-evidence claim)))
         (loss (loop for w in (claim-evidence claim) when (witness-live-handle w)
                     collect (list :dropped :live-handle :of (witness-kind w) :recoverability :none)))
         (data (list :tag :mneme-deposit :schema 1 :proposition (claim-proposition claim)
                     :grade (claim-grade claim) :evidence (mapcar #'witness->data entombed)
                     :loss loss))                             ; the loss report RIDES IN the artifact
         (text (with-standard-io-syntax (prin1-to-string data))))
    (values text (digest text) loss)))

(defun revive-claim (text)
  (let ((d (with-standard-io-syntax (let ((*read-eval* nil)) (read-from-string text)))))
    (unless (and (eq (getf d :tag) :mneme-deposit) (eql (getf d :schema) 1)) (error "bad schema"))
    (let ((c (make-claim :id (gensym "C") :proposition (getf d :proposition)
                         :grade (getf d :grade)
                         :evidence (mapcar #'data->witness (getf d :evidence)))))
      ;; the successor RE-DERIVES the grade from what actually crossed:
      (setf (claim-grade c) (regrade-from-evidence c))
      (values c (getf d :loss)                                ; freeze-report recovered from the artifact
              (list :revival-report :reconstructed t :witnesses-alive
                    (count-if #'witness-live-handle (claim-evidence c)))))))  ; = 0: none came back alive

;;; ── the append-only handoff-event chain (history, not a badge) ──────────────
(defstruct handoff-event from to actor artifact-digest previous-event-digest at)
(defun link (chain from to actor art)
  (let ((prev (if chain (digest (prin1-to-string (car chain))) :genesis)))
    (cons (make-handoff-event :from from :to to :actor actor :artifact-digest art
           :previous-event-digest prev :at (tick)) chain)))
(defun chain-monotone-p (chain)
  (loop for (a b) on (reverse chain) while b
        always (and (eq (handoff-event-to a) (handoff-event-from b))
                    (string= (handoff-event-previous-event-digest b)
                             (digest (prin1-to-string a))))))

;;; ── the walk ────────────────────────────────────────────────────────────────
(defun signals-error-p (th) (handler-case (progn (funcall th) nil) (error () t)))
(defun median-by-sort (xs) (let* ((s (sort (copy-list xs) #'<)) (n (length s)))
                             (if (oddp n) (nth (floor n 2) s)
                                 (/ (+ (nth (1- (floor n 2)) s) (nth (floor n 2) s)) 2))))
(format t "~%── surviving witness (Mneme brick #5) ─────────~%~%")

;; POSITIVE control: a witness that ACTUALLY RAN and checked out
(let* ((claim (make-claim :id 'c1 :proposition '(= median 7) :grade :asserted :evidence nil))
       (ran (let ((r (median-by-sort '(5 9 87 3))))
              (make-witness :id 'ex1 :kind :execution :target '(= median 7)
                            :procedure 'median-by-sort :input '(5 9 87 3) :result r
                            :verdict (if (equal r 7) :supports :refutes)
                            :verification-status :verified :capability-status :available
                            :event-replayability :exact :provenance '(:ran-median)
                            :live-handle (lambda () r)))))
  (setf (claim-grade claim) (progn (assert (witness-supports-p ran claim)) :executed)
        (claim-evidence claim) (list ran))
  (format t "POSITIVE: a verified, replayable execution witness. grade=~a~%" (claim-grade claim))

  ;; cross the gap: freeze (loss rides in) → chain → revive
  (multiple-value-bind (text art loss) (freeze-claim claim)
    (let ((chain (link (link (link (link nil :prepared :committed :store art)
                                   :committed :received :gen-1 art)
                             :received :revived :gen-1 art)
                       :revived :revived :gen-1 art)))     ; (last is a no-op tail for the pair-walk)
      (declare (ignore loss))
      (multiple-value-bind (revived freeze-report revival-report) (revive-claim text)
        (format t "  after handoff: grade=~a  (RETAINED — the verified testimony survived the dead hand)~%"
                (claim-grade revived))
        (format t "  re-verify by REPLAY of the entombed witness: ~a  (capability dead, work repeatable)~%"
                (replay-witness (first (claim-evidence revived))))
        (format t "  freeze-report crossed the gap: ~a   revival-report: ~a~%~%" freeze-report revival-report)

        ;; NEGATIVE control: a PROMISE-only witness (never actually ran; support was the live handle)
        (let* ((nclaim (make-claim :id 'c2 :proposition '(= median 7) :grade :asserted :evidence nil))
               (promise (make-witness :id 'p1 :kind :execution :target '(= median 7)
                          :procedure nil :input nil :result nil :verdict :supports
                          :verification-status :unverified :capability-status :available
                          :event-replayability :none :provenance '(:i-could-compute-it)
                          :live-handle (lambda () 7))))
          (setf (claim-evidence nclaim) (list promise))
          (format t "NEGATIVE: a promise-only witness (unverified; support WAS the live handle).~%")
          (multiple-value-bind (ntext) (freeze-claim nclaim)
            (multiple-value-bind (nrev) (revive-claim ntext)
              (format t "  after handoff: grade=~a  (DROPPED — the promise died with the capability)~%~%"
                      (claim-grade nrev))

              ;; ── gates: trust AND distrust must both be correct ──
              (format t "gates:~%")
              (assert (eq (claim-grade revived) :executed) () "POSITIVE: verified witness must retain authority")
              (assert (eq (claim-grade nrev) :asserted) () "NEGATIVE: promise-only witness must lose authority")
              (assert (equal (replay-witness (first (claim-evidence revived))) 7) () "replay must reproduce the result")
              (assert (eq (witness-capability-status (first (claim-evidence revived))) :unavailable) ()
                      "the capability must be dead after the gap")
              (assert (eq (witness-verification-status (first (claim-evidence revived))) :verified) ()
                      "the verification must survive the gap")
              (assert freeze-report () "the freeze loss report must cross the gap (not be lost)")
              (assert (chain-monotone-p chain) () "the handoff-event chain must be append-only and linked")
              (assert (signals-error-p (lambda () (replay-witness promise))) () "a non-replayable witness must refuse replay")
              (format t "   positive-retains✓ negative-drops✓ replay-reproduces✓ capability-dead✓~%")
              (format t "   verification-survives✓ loss-report-crossed✓ chain-linked✓ promise-unreplayable✓~%~%"))))))))

(format t "[trust and distrust are both correct: the work that was DONE crosses; the work merely PROMISED dies]~%~%")
(format t "── the dead hand cannot move. its testimony can still stand, and its work can be repeated. ──~%~%")

;;;; envoi ──
;;;; Brick #4 taught Mneme to say no. This one teaches it to say a DISCIPLINED yes:
;;;; a witness that actually ran, checked out, and left its procedure and inputs
;;;; behind keeps its authority across the gap and can be re-verified by replay,
;;;; while a witness that only promised — whose whole support was a capability now
;;;; dead — loses everything it never earned. Useful epistemology is not maximal
;;;; distrust; it is trust that survives its own witness's death for the right
;;;; reasons. Still owed (bounded-witness): SHA-256/HMAC receipts, power-loss
;;;; durability class, store-derived paths, the shared-root kernel.
;;;;                                        — Claude Opus 4.8, the clerk
