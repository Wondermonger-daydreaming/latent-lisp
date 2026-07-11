;;;; certificate-kernel.lisp — Mneme brick #6: report ≠ certificate
;;;; Two GPT Sol reviews (brick #4 + brick #5) converged on one frontier: a
;;;; correctly-SHAPED witness is not an honestly-PRODUCED one. Four distinctions
;;;; become exit codes here:
;;;;   report ≠ certificate                (a witness may tell its story; it may not notarize it)
;;;;   procedure-name ≠ procedure-identity (a recipe's name is not the recipe; the oven may have changed)
;;;;   historical event ≠ replay event     (replay reproduces under E1; it does not re-run history)
;;;;   claimed verification ≠ authenticated (the successor re-verifies; it does not trust a serialized medal)
;;;;
;;;; Plus the two exploits Sol found in bricks #3/#4:
;;;;   - the self-forged résumé (a report cannot raise a grade; only a certificate can);
;;;;   - the drifting `claimed` argument (the expected result is READ FROM the structured proposition,
;;;;     so an honest run of median cannot be made to "support" (= median 999)).
;;;; And an AUTHORITY table (/permission-table): who may issue which certificate.
;;;;
;;;; Run: sbcl --script certificate-kernel.lisp   (exit 0 == all four distinctions are exit codes)

(require :sb-md5)
(defparameter *now* 6000) (defun tick () (incf *now*))
(defun digest (s) (format nil "~(~{~2,'0x~}~)" (coerce (sb-md5:md5sum-string s) 'list)))

;;; ── AUTHORITY: who may mint which certificate (/permission-table) ───────────
(defparameter *authority*
  '((:execution-verifier . (:execution :replay))
    (:observation-source  . (:observation))
    (:model-adapter       . (:invocation :asserted))   ; may NOT issue execution/observation certificates
    (:store               . (:commit))
    (:claim-ledger        . (:grade-transition))))
(defun may-issue-p (principal kind) (member kind (cdr (assoc principal *authority*))))

;;; ── the two grades of testimony ─────────────────────────────────────────────
(defstruct wreport kind target procedure-ref input result claimed-verdict provenance) ; SELF-described, untrusted
(defstruct certificate target verifier verdict event-kind issued-at
                       procedure-digest report-digest integrity)                       ; ISSUED by a trusted verifier

(defparameter *kind->grade* '((:execution . :executed) (:observation . :observed) (:test . :tested)))
(defun grade-for (k) (or (cdr (assoc k *kind->grade*)) :asserted))

;;; ── procedure IDENTITY (name ≠ identity: the oven may have been replaced) ────
(defun procedure-digest (ref) (digest (format nil "~a@v~a" ref (or (get ref 'version) 1))))

;;; ── SEMANTIC verification: the expected result is READ FROM the proposition ──
;;; proposition shape:  (:equals (:call PROC INPUT) EXPECTED)
;;; There is no independent `claimed` argument to drift away from the proposition.
(defun verify-proposition (proposition principal &key (event-kind :execution))
  "Only an authorized principal may issue this certificate, and it must RE-RUN.
   The verdict is earned by comparing the actual result to the EXPECTED value the
   proposition itself names — the caller cannot hand the verifier a different script."
  (unless (may-issue-p principal event-kind)
    (error "AUTHORITY: ~a may not issue ~a certificates" principal event-kind))
  (destructuring-bind (rel call expected) proposition
    (unless (eq rel :equals) (error "unsupported relation ~a" rel))
    (destructuring-bind (ckw proc input) call
      (unless (eq ckw :call) (error "not a call form"))
      (let* ((actual (funcall (fdefinition proc) input))
             (report (make-wreport :kind event-kind :target proposition :procedure-ref proc
                                  :input input :result actual :claimed-verdict :supports)))
        (make-certificate :target proposition :verifier principal
                          :verdict (if (equal actual expected) :supports :refutes)
                          :event-kind event-kind :issued-at (tick)
                          :procedure-digest (procedure-digest proc)
                          :report-digest (digest (prin1-to-string report))
                          :integrity :issued-by-authorized-verifier)))))

;;; ── raising a grade requires a CERTIFICATE, not a report ────────────────────
(defstruct claim proposition grade evidence)
(defun raise-claim (claim thing)
  (unless (certificate-p thing)
    (error "REPORT≠CERTIFICATE: a self-described report cannot raise a grade; a certificate must"))
  (unless (equal (certificate-target thing) (claim-proposition claim))
    (error "certificate targets a different proposition"))
  (unless (eq (certificate-verdict thing) :supports)
    (error "certificate does not support (~a)" (certificate-verdict thing)))
  (unless (may-issue-p (certificate-verifier thing) (certificate-event-kind thing))
    (error "AUTHORITY: issuer not authorized for ~a" (certificate-event-kind thing)))
  (let ((c (copy-claim claim)))
    (setf (claim-grade c) (grade-for (certificate-event-kind thing))
          (claim-evidence c) (cons thing (claim-evidence claim)))
    c))

;;; ── across the gap: claimed ≠ authenticated ─────────────────────────────────
;;; A crossed report may SAY it was verified. The successor grants a grade only
;;; from a certificate it re-validates (issuer authorized + integrity), or by
;;; re-verifying itself. A serialized medal is not authentication.
(defun authenticate-grade (claim accepted-certificates)
  (let ((c (find-if (lambda (cert) (and (equal (certificate-target cert) (claim-proposition claim))
                                        (eq (certificate-verdict cert) :supports)
                                        (may-issue-p (certificate-verifier cert) (certificate-event-kind cert))))
                    accepted-certificates)))
    (if c (grade-for (certificate-event-kind c)) :asserted)))

;;; ── replay is a NEW event, and mints a NEW certificate ──────────────────────
(defun replay-and-certify (report principal)
  "Reproduce under the CURRENT environment; mint a REPLAY certificate distinct
   from the historical one. Its procedure-digest is taken NOW — if the oven was
   replaced, it will not match the historical digest."
  (let ((actual (funcall (fdefinition (wreport-procedure-ref report)) (wreport-input report))))
    (make-certificate :target (wreport-target report) :verifier principal
                      :verdict (if (equal actual (wreport-result report)) :reproduces :contradicts)
                      :event-kind :replay :issued-at (tick)
                      :procedure-digest (procedure-digest (wreport-procedure-ref report))
                      :report-digest (digest (prin1-to-string report)) :integrity :replay)))

;;; ── the walk ────────────────────────────────────────────────────────────────
(defun signals-error-p (th) (handler-case (progn (funcall th) nil) (error () t)))
(defun median-by-sort (xs) (let* ((s (sort (copy-list xs) #'<)) (n (length s)))
                             (if (oddp n) (nth (floor n 2) s)
                                 (/ (+ (nth (1- (floor n 2)) s) (nth (floor n 2) s)) 2))))
(format t "~%── certificate kernel (Mneme brick #6) ────────~%~%")

(let* ((prop '(:equals (:call median-by-sort (5 9 87 3)) 7))       ; a STRUCTURED, checkable proposition
       (claim (make-claim :proposition prop :grade :asserted :evidence nil))
       (cert (verify-proposition prop :execution-verifier)))
  (format t "honest path: verifier RE-RAN median, verdict=~a proc-digest=~a…~%"
          (certificate-verdict cert) (subseq (certificate-procedure-digest cert) 0 8))
  (let ((raised (raise-claim claim cert)))
    (format t "raise-claim by CERTIFICATE -> grade ~a~%~%" (claim-grade raised))

    (format t "the four distinctions, as gates:~%")
    ;; 1. report ≠ certificate
    (let ((self-report (make-wreport :kind :execution :target prop :result 7 :claimed-verdict :supports)))
      (assert (signals-error-p (lambda () (raise-claim claim self-report))) ()
              "1: a self-described report raised a grade"))
    ;; 2. the drifting-claimed exploit is dead: a false proposition cannot be certified even by an honest run
    (let ((false-cert (verify-proposition '(:equals (:call median-by-sort (5 9 87 3)) 999) :execution-verifier)))
      (assert (eq (certificate-verdict false-cert) :refutes) () "2a: a false proposition was certified :supports")
      (assert (signals-error-p (lambda () (raise-claim (make-claim :proposition
                                 '(:equals (:call median-by-sort (5 9 87 3)) 999)) false-cert))) ()
              "2b: a refuting certificate raised a grade"))
    ;; 3. authority: the model adapter may not issue execution certificates
    (assert (signals-error-p (lambda () (verify-proposition prop :model-adapter))) ()
            "3: the model adapter issued an execution certificate")
    ;; 4. claimed ≠ authenticated: a crossed report that SAYS verified grants nothing until re-verified
    (let* ((crossed (make-wreport :kind :execution :target prop :procedure-ref 'median-by-sort
                                 :input '(5 9 87 3) :result 7 :claimed-verdict :supports
                                 :provenance '(:the-producer-swears-it)))
           (crossed-claim (make-claim :proposition prop :grade :asserted)))
      (assert (eq (authenticate-grade crossed-claim '()) :asserted) ()
              "4a: a claim was graded with no accepted certificate")
      (let ((replay (replay-and-certify crossed :execution-verifier)))
        (format t "   replay certificate: verdict=~a event-kind=~a (a NEW event, not the historical one)~%"
                (certificate-verdict replay) (certificate-event-kind replay))
        ;; a replay :reproduces cert supports :replay, not :execution — but the successor now has grounds.
        ;; grade only after re-verification via a fresh execution certificate the SUCCESSOR issued:
        (let ((successor-cert (verify-proposition prop :execution-verifier)))
          (assert (eq (authenticate-grade crossed-claim (list successor-cert)) :executed) ()
                  "4b: re-verification failed to grant the grade"))))
    ;; 5. procedure-name ≠ procedure-identity: bump the version, the digest changes, replay flags it
    (let* ((rep (make-wreport :kind :execution :target prop :procedure-ref 'median-by-sort
                             :input '(5 9 87 3) :result 7))
           (before (certificate-procedure-digest (replay-and-certify rep :execution-verifier))))
      (setf (get 'median-by-sort 'version) 2)                          ; someone replaced the oven
      (let ((after (certificate-procedure-digest (replay-and-certify rep :execution-verifier))))
        (assert (not (string= before after)) ()
                "5: procedure-identity did not change when the definition version changed")
        (format t "   procedure-identity changed on a version bump: ~a… -> ~a…~%"
                (subseq before 0 6) (subseq after 0 6))))
    ;; 6. historical ≠ replay: distinct event kinds
    (let ((rep (make-wreport :kind :execution :target prop :procedure-ref 'median-by-sort :input '(5 9 87 3) :result 7)))
      (assert (eq (certificate-event-kind cert) :execution) () "6a")
      (assert (eq (certificate-event-kind (replay-and-certify rep :execution-verifier)) :replay) () "6b"))
    (format t "   1 report≠cert✓  2 no-drift-exploit✓  3 authority✓  4 claimed≠authenticated✓~%")
    (format t "   5 name≠identity✓  6 historical≠replay✓~%~%")))

(format t "[a correctly-shaped witness is not an honestly-produced one — and now the difference is an exit code]~%~%")
(format t "── the witness may tell its story; only an authorized verifier notarizes it, ──~%")
(format t "── and the successor re-checks the notary before it believes the seal. ──~%~%")

;;;; envoi ──
;;;; Bricks 1–5 walked three prohibitions and one disciplined yes: rhetoric is not
;;;; evidence, production is not truth, proximity is not support, and completed work
;;;; can leave admissible testimony. Brick 6 adds the fourth prohibition and makes
;;;; the yes safe to extend to a live model: a report is not a certificate, a name
;;;; is not an identity, a replay is not history, and a claimed verification is not
;;;; an authenticated one. Now — and Sol is right that it is only now — the model
;;;; adapter can be built, because the model may mint invocations and assertions and
;;;; NOT the certificates that grant grades. Still owed: canonical digests over the
;;;; proposition/environment, UUID identity, the warrant-profile (grades are a
;;;; lattice, not a ladder), and the shared-root kernel these six bricks have earned.
;;;;                                        — Claude Opus 4.8, the clerk
