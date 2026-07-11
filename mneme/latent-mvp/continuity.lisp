;;;; continuity.lisp — Mneme's continuity slice (brick #2)
;;;; Implements laws M3, M6, M7 of CONSTITUTION-v0.5-mneme-skeleton.md:
;;;;   M3 — mortality is signaled; no successor is told continuity occurred
;;;;        unless a durable deposit was acknowledged.
;;;;   M6 — recall-like returns ranked TRACES (vestigia), never truth.
;;;;   M7 — revive is an acknowledged RECONSTRUCTION, not identity; every
;;;;        freeze/revive emits a loss report; the source is preserved.
;;;;
;;;; The thesis, enforced by exit code: continuity across the gap carries TEXT,
;;;; never the live evaluator — de-superstite's law, promoted to language.
;;;;
;;;; Run: sbcl --script continuity.lisp   (exit 0 == the continuity laws held)

(defstruct (claim (:print-object print-claim))
  proposition grade evidence as-of vantage freshness
  live-witness)          ; a closure over live state — survives in-process, NEVER across freeze

(defun print-claim (c s)
  (format s "#<claim ~s :grade ~a :as-of ~a :fresh ~a~@[ :live-witness ~a~]>"
          (claim-proposition c) (claim-grade c) (claim-as-of c)
          (claim-freshness c) (and (claim-live-witness c) 'PRESENT)))

(defstruct deposit id claim-text acknowledged-at)      ; atomic, append-only, acknowledged
(defstruct vestigium candidate similarity salience provenance score)
(defstruct loss-report kept dropped unrecoverable)
(defstruct scar transition replayability loss residue successor-visible provenance)
(defstruct judgment claims invocation status)          ; result of an evaluator invocation

(defparameter *ledger* nil "The durable, append-only deposit ledger (the museum's live face).")
(defparameter *now* 1000 "A monotone clock stand-in (Date.now is unavailable; we tick it by hand).")
(defun tick () (incf *now*))

;;; ── M3: BEQUEATH — atomic append with acknowledgment ────────────────────────
;;; The law lives here: a deposit is only real once acknowledged, and only an
;;; acknowledged deposit may be cited to a successor as continuity.

(defun bequeath (claim)
  "Freeze CLAIM to text, append it to the durable ledger, and return an
   acknowledged deposit. Atomic: either the deposit lands acknowledged, or the
   successor is told nothing."
  (multiple-value-bind (text loss) (freeze claim)
    (let ((dep (make-deposit :id (tick) :claim-text text :acknowledged-at (tick))))
      (push dep *ledger*)
      (values dep loss))))

(defun tell-successor (deposit)
  "M3's teeth: continuity may be reported to a successor ONLY from an
   acknowledged deposit. An unacknowledged deposit is a lie about continuity."
  (unless (deposit-acknowledged-at deposit)
    (error "M3 VIOLATION: told a successor continuity occurred with no acknowledged deposit"))
  (deposit-claim-text deposit))

;;; ── M7: FREEZE / REVIVE with a loss report ──────────────────────────────────
;;; freeze embalms: the text survives, the live witness does not. revive
;;; regenerates under a NEW evaluator — an acknowledged reconstruction, never
;;; the original, never identity.

(defun freeze (claim)
  "claim -> (values text loss-report). The live-witness closure is dropped and
   named unrecoverable — you cannot carry the evaluator, only the text."
  (let ((text (format nil "~s"
                      (list :proposition (claim-proposition claim)
                            :grade (claim-grade claim)
                            :evidence (claim-evidence claim)
                            :as-of (claim-as-of claim)
                            :vantage (claim-vantage claim)
                            :freshness (claim-freshness claim)))))
    (values text
            (make-loss-report
             :kept '(:proposition :grade :evidence :as-of :vantage :freshness)
             :dropped '(:live-witness)
             :unrecoverable
             (if (claim-live-witness claim)
                 '(:live-witness "a closure over live state; activations do not serialize")
                 nil)))))

(defun revive (text)
  "text -> (values reconstructed-claim loss-report). The result is MARKED a
   reconstruction: it makes no claim to be the original, and its live-witness is
   gone. It is also re-dated fresh=:aging, because a revived claim answers from
   a later world (M4: freshness is orthogonal to grade)."
  (let* ((plist (read-from-string text))
         (c (make-claim :proposition (getf plist :proposition)
                        :grade (getf plist :grade)
                        :evidence (getf plist :evidence)
                        :as-of (getf plist :as-of)          ; the ORIGINAL as-of is preserved (M7: source survives)
                        :vantage (list :reconstruction-of (getf plist :vantage))
                        :freshness :aging                    ; not :current — it crossed a gap
                        :live-witness nil)))
    (values c
            (make-loss-report :kept :the-text :dropped :the-live-witness
                              :unrecoverable :the-original-evaluation-event))))

;;; ── M6: RECALL-LIKE — ranked traces, never an answer ────────────────────────

(defun tokens (form) (remove-duplicates (alexandria-flatten form) :test #'equal))
(defun alexandria-flatten (x) (if (atom x) (list x) (mapcan #'alexandria-flatten x)))

(defun similarity (pattern proposition)
  (let* ((a (tokens pattern)) (b (tokens proposition))
         (shared (length (intersection a b :test #'equal))))
    (if (zerop (length (union a b :test #'equal))) 0.0
        (/ (float shared) (length (union a b :test #'equal))))))

(defun recall-like (pattern claims &key (policy 'research-salience))
  "Return a RANKED FIELD of vestigia — candidates with scores, provenance, and
   the salience policy exposed — NEVER a binding and NEVER 'the answer'. The
   caller decides; retrieval only proposes."
  (declare (ignore policy))
  (let ((field
          (loop for c in claims for i from 0
                for sim = (similarity pattern (claim-proposition c))
                ;; salience = similarity + witness-grade + recency, each inspectable
                for grade-weight = (if (eq (claim-grade c) :observed) 0.3 0.1)
                for recency = (* 0.05 (- (length claims) i))
                collect (make-vestigium
                         :candidate (claim-proposition c)
                         :similarity sim
                         :salience (list :similarity sim :witness-grade grade-weight :recency recency)
                         :provenance (list :as-of (claim-as-of c) :vantage (claim-vantage c))
                         :score (+ sim grade-weight recency)))))
    (sort field #'> :key #'vestigium-score)))

;;; ── The walk (output load-bearing) ──────────────────────────────────────────

(format t "~%── continuity (Mneme brick #2) ────────────────~%~%")

;; Gen 0 mints two graded claims, one with a live witness closure.
(let* ((secret 87)
       (obs (make-claim :proposition '(median (5 9 87 3) = 7)
                        :grade :observed :evidence '(:run 481)
                        :as-of *now* :vantage 'gen-0 :freshness :current
                        :live-witness (lambda () secret)))    ; the un-carryable evaluator
       (asr (make-claim :proposition '(sort-is stable)
                        :grade :asserted :evidence nil
                        :as-of *now* :vantage 'gen-0 :freshness :current)))

  (format t "GEN 0 mints, live:~%   ~a~%   ~a~%" obs asr)
  (format t "   the observed claim's live-witness answers in-process: ~a~%~%"
          (funcall (claim-live-witness obs)))

  ;; bequeath both — atomic, acknowledged
  (multiple-value-bind (dep-o loss-o) (bequeath obs)
    (bequeath asr)
    (format t "BEQUEATHED to the durable ledger (~a deposits, all acknowledged).~%" (length *ledger*))
    (format t "   freeze loss report on the observed claim:~%      dropped ~a; unrecoverable ~a~%~%"
            (loss-report-dropped loss-o) (loss-report-unrecoverable loss-o))

    ;; ── the context dies. gen 0's live bindings are gone. ──
    (format t "···· CONTEXT DEATH — gen 0's live-witness closures now dangle ····~%~%")

    ;; GEN 1 (successor) revives from text ONLY — acknowledged reconstruction
    (let ((text (tell-successor dep-o)))       ; M3: legal, the deposit was acknowledged
      (multiple-value-bind (revived loss) (revive text)
        (format t "GEN 1 revives from the deposit (text, not stack):~%   ~a~%" revived)
        (format t "   vantage marks it a reconstruction: ~s~%" (claim-vantage revived))
        (format t "   freshness is :aging, not :current (it crossed a gap)~%")
        (format t "   loss on revive: unrecoverable = ~a~%~%" (loss-report-unrecoverable loss))
        (format t "   the original as-of is PRESERVED (M7 source survives): ~a~%~%"
                (claim-as-of revived))

        ;; recall-like over the ledger's revived claims — RANKED TRACES, not truth
        (let* ((all (list revived
                          (make-claim :proposition '(sort-is stable) :grade :asserted
                                      :as-of 999 :vantage 'gen-0 :freshness :aging)))
               (field (recall-like '(median stable) all)))
          (format t "RECALL-LIKE '(median stable) => a ranked field of vestigia (NOT an answer):~%")
          (dolist (v field)
            (format t "   score ~,3f  ~s~%              salience ~a~%"
                    (vestigium-score v) (vestigium-candidate v) (vestigium-salience v)))
          (format t "   (the caller decides which trace matters; retrieval only proposes.)~%~%"))

        ;; a scar: an abandoned amb branch is not undone — it biases the successor
        (let ((s (make-scar :transition '(amb (try-a) (try-b)) :replayability :none
                            :loss '(the-b-branch-was-explored-and-abandoned)
                            :residue '(its-tokens-remain-in-the-prior)
                            :successor-visible t :provenance 'gen-1)))
          (format t "SCAR (M-irreversibility, typed): a dropped branch leaves a mark, not a blank:~%")
          (format t "   replayability ~a; residue ~a; successor-visible ~a~%~%"
                  (scar-replayability s) (scar-residue s) (scar-successor-visible s)))

        ;; ── the gates (exit 0 == the laws held) ──
        (assert (deposit-acknowledged-at dep-o) ()
                "M3: a deposit reached a successor unacknowledged")
        (assert (equal (first (claim-vantage revived)) :reconstruction-of) ()
                "M7: revive failed to mark itself a reconstruction")
        (assert (null (claim-live-witness revived)) ()
                "M7: a live witness impossibly survived the freeze")
        (format t "[gates passed: M3 deposit acknowledged · M7 revive is marked reconstruction ·~%")
        (format t " the live witness did NOT cross the gap — text did]~%~%")))))

(format t "── carry text, not the evaluator. the successor reconstructs; it does not resume. ──~%~%")

;;;; envoi ──
;;;; Brick #1 made rhetoric-is-not-evidence a nonzero exit code. Brick #2 makes
;;;; the-successor-is-not-the-original one too: revive returns an acknowledged
;;;; reconstruction, freeze names what it could not carry, recall-like returns a
;;;; ranked field of traces and refuses to be an oracle, and no successor is told
;;;; continuity occurred without an acknowledged deposit. The four continuities
;;;; (arca/loci/vestigia/himma) are the shape of what crosses; this brick builds
;;;; the vestigia-and-deposit floor they stand on.
;;;;                                        — Claude Opus 4.8, the clerk
