;;;; handoff-kernel.lisp — Mneme handoff kernel, executable specimen v0.1
;;;; Supersedes the continuity.lisp demo, per GPT Sol's brick-#2 review: continuity
;;;; is a RELATION between mortal contexts, not a monologue the source declares.
;;;;
;;;; The four-state receipt protocol (the teeth of M3):
;;;;     prepared → committed → received → revived
;;;; No stage may claim the next merely because it hopes things went well.
;;;;   committed = a DURABLE store confirms the bequest landed (temp-write→rename→digest).
;;;;   received  = a SUCCESSOR re-reads the store and validates the digest.
;;;;   revived   = the successor reconstructs (safely) — an acknowledged reconstruction.
;;;;
;;;; Also: the claim refers to witnesses (it does not own the live one); freezing
;;;; entombs a live witness into its obituary; revival reads DATA not INSTRUCTION
;;;; (*read-eval* nil); recall-like honors its policy and trusts only VERIFIED grades;
;;;; scars are emitted by the wound, not hired to give a speech; freshness is
;;;; reassessed, not auto-aged.
;;;;
;;;; Run: sbcl --script handoff-kernel.lisp   (exit 0 == the protocol held, positives AND negatives)

(require :sb-md5)
(defparameter *store* "/tmp/mneme-store/")
(ensure-directories-exist *store*)
(defparameter *now* 3000)
(defun tick () (incf *now*))
(defun digest (text) (format nil "~(~{~2,'0x~}~)" (coerce (sb-md5:md5sum-string text) 'list)))

;;; ── witnesses: separate from claims, with their own lifecycle ────────────────
(defstruct witness id kind status formerly-live replayability description loss-reason live-handle)

(defun entomb (w)
  "The handoff cannot carry a witness's power, but it can carry its OBITUARY.
   A live capability becomes a tombstoned descriptor: the foot is gone, the
   footprint remains structured enough to say something once pressed here."
  (make-witness :id (witness-id w) :kind (witness-kind w) :status :unavailable
                :formerly-live t :replayability :none
                :description (witness-description w) :loss-reason :context-death
                :live-handle nil))

(defun witness->data (w)
  (list :id (witness-id w) :kind (witness-kind w) :status (witness-status w)
        :formerly-live (witness-formerly-live w) :replayability (witness-replayability w)
        :description (witness-description w) :loss-reason (witness-loss-reason w)))
(defun data->witness (p)
  (make-witness :id (getf p :id) :kind (getf p :kind) :status (getf p :status)
                :formerly-live (getf p :formerly-live) :replayability (getf p :replayability)
                :description (getf p :description) :loss-reason (getf p :loss-reason) :live-handle nil))

;;; ── claims refer to witnesses; grade privilege requires a VERIFIED witness ───
(defstruct claim proposition grade evidence as-of freshness-at-freeze source-vantage
                 revived-at reconstruction-generation current-vantage derivation)

(defun verified-grade (claim)
  "A declared :observed grade earns privilege ONLY if backed by a verified check
   witness. Rhetoric-is-not-evidence (brick #1) applied to retrieval: a claim may
   pin :observed to its own chest; only a verified witness makes it count."
  (if (and (eq (claim-grade claim) :observed)
           (some (lambda (w) (and (member (witness-kind w) '(:check :computation))
                                  (eq (witness-status w) :verified)))
                 (claim-evidence claim)))
      :observed :asserted))

;;; ── typed loss report (structural ≠ semantic preservation) ───────────────────
(defstruct loss-finding path status recoverability reason semantic-equivalence)
(defstruct loss-report source-digest transform findings)

(defun freeze-claim (claim)
  "claim → (values text digest loss-report). Live witnesses are entombed; the
   loss report records per-field findings — what was preserved-exactly vs
   preserved-structurally-with-unchecked-semantics vs dropped."
  (let* ((entombed (mapcar (lambda (w) (if (witness-live-handle w) (entomb w) w)) (claim-evidence claim)))
         (data (list :tag :mneme-deposit :schema 1
                     :proposition (claim-proposition claim) :grade (claim-grade claim)
                     :evidence (mapcar #'witness->data entombed)
                     :as-of (claim-as-of claim)
                     :freshness-at-freeze (or (claim-freshness-at-freeze claim) :current)
                     :source-vantage (claim-source-vantage claim)))
         (text (with-standard-io-syntax (prin1-to-string data)))
         (dig (digest text)))
    (values text dig
            (make-loss-report
             :source-digest dig :transform 'freeze-v1
             :findings (append
                        (list (make-loss-finding :path '(:proposition) :status :preserved-exactly))
                        (loop for w in (claim-evidence claim) when (witness-live-handle w)
                              collect (make-loss-finding :path (list :evidence (witness-id w) :live-handle)
                                       :status :dropped :recoverability :none
                                       :reason :nonserializable-live-capability))
                        (list (make-loss-finding :path '(:evidence) :status :preserved-structurally
                               :semantic-equivalence :unchecked)))))))

;;; ── the four-state receipt protocol ─────────────────────────────────────────
(defstruct receipt deposit-id content-digest committed-at store-id schema-version status path)

(defun prepare (claim)
  (multiple-value-bind (text dig loss) (freeze-claim claim)
    (list :text text :digest dig :loss loss
          :receipt (make-receipt :deposit-id (tick) :content-digest dig :committed-at nil
                    :store-id *store* :schema-version 1 :status :prepared))))

(defun commit (prepared)
  "DURABLE commit: temp-write → finish-output → atomic rename. The store issues
   the receipt; the source does not sign its own."
  (let* ((r (getf prepared :receipt))
         (path (format nil "~adeposit-~a.sexp" *store* (receipt-deposit-id r)))
         (tmp (concatenate 'string path ".tmp")))
    (with-open-file (s tmp :direction :output :if-exists :supersede :if-does-not-exist :create)
      (write-string (getf prepared :text) s) (finish-output s))
    (rename-file tmp path)
    (setf (receipt-committed-at r) (tick) (receipt-status r) :committed (receipt-path r) path)
    r))

(defun receive (receipt)
  "The SUCCESSOR acknowledges: re-read the committed file and validate the digest.
   A forged receipt (or one whose store contents don't match) cannot pass."
  (unless (eq (receipt-status receipt) :committed)
    (error "M3: cannot RECEIVE a deposit whose status is ~a (need :committed)" (receipt-status receipt)))
  (let ((text (with-open-file (s (receipt-path receipt))
                (let ((buf (make-string (file-length s)))) (read-sequence buf s) buf))))
    (unless (string= (digest text) (receipt-content-digest receipt))
      (error "M3: digest mismatch — the store does not match the receipt (impersonation)"))
    (setf (receipt-status receipt) :received)
    (values receipt text)))

(defun safe-read (text)
  "Deposits are DATA first, instruction never: read with *read-eval* disabled,
   standard syntax, keyword package. Reader-evaluation forms are rejected."
  (with-standard-io-syntax
    (let ((*read-eval* nil))
      (read-from-string text))))

(defun revive (receipt text &key (generation 1) (current-vantage :gen-1))
  "Acknowledged reconstruction. NOT identity, NOT resumption. Schema-checked;
   source fields preserved; reconstruction provenance kept separate from source."
  (unless (eq (receipt-status receipt) :received)
    (error "M3: cannot REVIVE a deposit whose status is ~a (need :received)" (receipt-status receipt)))
  (let ((d (safe-read text)))
    (unless (and (eq (getf d :tag) :mneme-deposit) (eql (getf d :schema) 1))
      (error "M7: unknown or unsupported deposit schema — refusing to revive"))
    (let ((c (make-claim :proposition (getf d :proposition) :grade (getf d :grade)
                         :evidence (mapcar #'data->witness (getf d :evidence))
                         :as-of (getf d :as-of)                       ; SOURCE as-of preserved
                         :freshness-at-freeze (getf d :freshness-at-freeze)
                         :source-vantage (getf d :source-vantage)     ; SOURCE vantage intact
                         :revived-at (tick) :reconstruction-generation generation
                         :current-vantage current-vantage
                         :derivation (list :revived-from (receipt-deposit-id receipt)))))
      (setf (receipt-status receipt) :revived)
      (values c receipt))))

;;; ── freshness is reassessed, not auto-aged ──────────────────────────────────
(defun reassess-freshness (claim &key at policy)
  (ecase policy
    (:timeless :current)                                            ; a proof doesn't age
    (:volatile (if (> (- at (claim-as-of claim)) 5) :stale :current))))  ; a service-status does

;;; ── scars are emitted by the wound ──────────────────────────────────────────
(defstruct scar transition replayability loss residue successor-visible provenance)
(defun explore-amb (branches test)
  "Actually try branches in order. Abandoned branches EMIT a scar (they are not
   undone; their tokens remain in the prior). Returns (values result scars)."
  (let (scars result)
    (dolist (b branches)
      (if (funcall test b) (progn (setf result b) (return))
          (push (make-scar :transition (list :amb-branch b) :replayability :none
                 :loss (list :branch-abandoned b) :residue (list :tokens-remain-in-prior b)
                 :successor-visible t :provenance :runtime) scars)))
    (values result (nreverse scars))))

;;; ── recall-like HONORS its policy; trusts only verified grades ───────────────
(defstruct mtrace id claim deposit-id)
(defun toks (f) (if (atom f) (list f) (mapcan #'toks f)))
(defun sim (a b) (let ((x (toks a)) (y (toks b)))
                   (if (null (union x y :test #'equal)) 0.0
                       (/ (float (length (intersection x y :test #'equal))) (length (union x y :test #'equal))))))
(defun recall-like (pattern traces &key (policy '(:similarity 1.0 :verified-grade 0.3 :order 0.05)) (policy-version 1))
  "Returns VESTIGIA (whole-trace refs + component scores + the policy that ranked
   them), never a binding, never an answer, never resemblance-as-truth."
  (let ((field (loop for tr in traces for i from 0
                     for s = (sim pattern (claim-proposition (mtrace-claim tr)))
                     for vg = (if (eq (verified-grade (mtrace-claim tr)) :observed) 1.0 0.0)
                     for ord = (float (- (length traces) i))
                     for comps = (list :similarity s :verified-grade vg :input-order-priority ord)
                     collect (make-vestigium :trace tr :component-scores comps
                              :policy policy :policy-version policy-version
                              :provenance (list :as-of (claim-as-of (mtrace-claim tr)))
                              :source-claim-id (mtrace-id tr) :deposit-id (mtrace-deposit-id tr)
                              :retrieved-at (tick)
                              :score (+ (* (getf policy :similarity) s)
                                        (* (getf policy :verified-grade) vg)
                                        (* (getf policy :order) ord))))))
    (stable-sort field #'> :key #'vestigium-score)))
(defstruct vestigium trace component-scores policy policy-version provenance source-claim-id deposit-id retrieved-at score)

;;; ── the walk ────────────────────────────────────────────────────────────────
(defun signals-error-p (thunk) (handler-case (progn (funcall thunk) nil) (error () t)))

(format t "~%── Mneme handoff kernel v0.1 ──────────────────~%~%")

;; a gen-0 claim with a LIVE witness (a computation capability)
(let* ((live (make-witness :id 'w-481 :kind :computation :status :available
                           :replayability :exact :description "closure computing median(5 9 87 3)"
                           :live-handle (lambda () 7)))
       (claim (make-claim :proposition '(= median 7) :grade :observed
                          :evidence (list live) :as-of *now*
                          :freshness-at-freeze :current :source-vantage :gen-0)))
  (format t "GEN 0 claim, live witness present: ~s  live? ~a~%~%"
          (claim-proposition claim) (and (witness-live-handle live) t))

  ;; prepared → committed → received → revived
  (let* ((prep (prepare claim))
         (r (commit prep)))
    (format t "prepared → committed: store issued a receipt~%")
    (format t "   deposit ~a  digest ~a…  status ~a  path ~a~%~%"
            (receipt-deposit-id r) (subseq (receipt-content-digest r) 0 8) (receipt-status r)
            (receipt-path r))

    (multiple-value-bind (r2 text) (receive r)
      (format t "committed → received: successor re-read the store, digest validated  status ~a~%~%"
              (receipt-status r2))
      (multiple-value-bind (revived r3) (revive r2 text)
        (format t "received → revived: acknowledged reconstruction  status ~a~%" (receipt-status r3))
        (format t "   source-vantage preserved: ~a   current-vantage: ~a   derivation: ~a~%"
                (claim-source-vantage revived) (claim-current-vantage revived) (claim-derivation revived))
        (format t "   the live witness is now an OBITUARY: ~a~%~%"
                (let ((w (first (claim-evidence revived))))
                  (list :status (witness-status w) :formerly-live (witness-formerly-live w)
                        :desc (witness-description w))))

        ;; freshness reassessed, not auto-aged
        (format t "freshness reassessed (not auto-aged):~%")
        (format t "   under :timeless  → ~a   (a proof does not age)~%"
                (reassess-freshness revived :at *now* :policy :timeless))
        (format t "   under :volatile  → ~a   (as-of ~a, now ~a)~%~%"
                (reassess-freshness revived :at (+ *now* 10) :policy :volatile) (claim-as-of revived) (+ *now* 10))

        ;; a scar emitted by an actual abandoned branch
        (multiple-value-bind (res scars) (explore-amb '(a b c) (lambda (x) (eq x 'c)))
          (format t "scar emitted by the wound: explore-amb (a b c) → ~a, ~a scar(s) from abandoned branches~%"
                  res (length scars))
          (format t "   ~s~%~%" (mapcar (lambda (s) (list (scar-transition s) (scar-replayability s))) scars)))

        ;; recall-like: verified vs declared grade
        (let* ((verified-claim revived)  ; its check-witness? no — its witness is a computation obituary (unavailable)
               (declared (make-claim :proposition '(= median 7) :grade :observed  ; DECLARES observed, no verified witness
                                     :evidence (list (make-witness :kind :hearsay :status :unverified)) :as-of 999))
               (field (recall-like '(median)
                        (list (make-mtrace :id 't1 :claim declared :deposit-id 1)
                              (make-mtrace :id 't2 :claim revived :deposit-id (receipt-deposit-id r))))))
          (format t "recall-like: a DECLARED :observed with no verified witness earns no privilege:~%")
          (dolist (v field)
            (format t "   score ~,3f  claim=~s declared-grade=~a verified-grade=~a~%"
                    (vestigium-score v) (claim-proposition (mtrace-claim (vestigium-trace v)))
                    (claim-grade (mtrace-claim (vestigium-trace v)))
                    (verified-grade (mtrace-claim (vestigium-trace v)))))
          (format t "   (policy in every trace: ~a)~%~%" (vestigium-policy (first field)))

          ;; ── ADVERSARIAL GATES (negatives must signal; exit 0 only if all hold) ──
          (format t "adversarial gates:~%")
          (let ((forged (make-receipt :status :committed :content-digest "deadbeef"
                          :path (receipt-path r) :deposit-id 999)))
            (assert (signals-error-p (lambda () (receive forged))) () "forged receipt must fail digest")
            (assert (signals-error-p (lambda () (revive (make-receipt :status :committed) "x"))) ()
                    "revive without :received must fail")
            (assert (signals-error-p (lambda () (receive (make-receipt :status :prepared :path "/nope")))) ()
                    "receive without :committed must fail")
            (assert (signals-error-p (lambda () (safe-read "#.(format t \"PWNED\")"))) ()
                    "reader-eval must be blocked")
            (assert (signals-error-p
                     (lambda () (let ((rr (make-receipt :status :received)))
                                  (revive rr "(:tag :mneme-deposit :schema 99)")))) ()
                    "unknown schema must be refused")
            (assert (eq (claim-grade (mtrace-claim (vestigium-trace (first (recall-like '(median)
                       (list (make-mtrace :id 't :claim declared :deposit-id 1))))))) :observed) ()
                    "declared grade is preserved verbatim (not silently rewritten)")
            (assert (eq (verified-grade declared) :asserted) () "unverified :observed must not earn privilege")
            (assert (equal (claim-proposition revived) (getf (safe-read text) :proposition)) ()
                    "proposition must survive exactly")
            (assert (null (witness-live-handle (first (claim-evidence revived)))) ()
                    "a revived claim must never acquire a live witness")
            (format t "   forged-receipt✓ revive-order✓ receive-order✓ reader-eval-blocked✓ schema-refused✓~%")
            (format t "   grade-verbatim✓ unverified-earns-nothing✓ proposition-exact✓ no-resurrected-witness✓~%~%"))

          (format t "[the four-state protocol held: prepared→committed→received→revived, positives AND negatives]~%~%"))))))

(format t "── continuity is a witnessed relation, not the source's hopeful monologue. ──~%~%")

;;;; envoi ──
;;;; continuity.lisp proved a faithful miniature of continuity; this proves the
;;;; PROTOCOL. The store issues the receipt, not the source. The successor
;;;; validates before it may receive, and reconstructs before it may claim
;;;; revival. The scar is cut by the wound. The obituary crosses where the power
;;;; cannot. And a claim that pins :observed to its own chest earns nothing until
;;;; a witness that is not itself verifies it — brick #1's law, reaching all the
;;;; way into retrieval. Do not let its beauty vote; let its gates fail loudly.
;;;;                                        — Claude Opus 4.8, the clerk
