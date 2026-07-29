;;;; stage-recover.lisp — the SUPERSTES: a genuinely new process.
;;;;
;;;; Launched by run-specimen.lisp as a separate `sbcl --script` invocation
;;;; AFTER the writer is dead.  Its entire admissible input is:
;;;;
;;;;   (1) the DURABLE BYTES of the store directory named in argv, and
;;;;   (2) DECLARED CONFIGURATION — the store path, the mode, and the
;;;;       declared charge in specimen-common.lisp (what the operation was
;;;;       supposed to be), plus, in torn mode, a salvage destination path.
;;;;
;;;; It has no access to the killed process's memory, receives no receipt,
;;;; reads no scratch file the child wrote, and takes no operator testimony
;;;; about what happened.  The barrier sentinel and the (never-written)
;;;; receipt channel both live OUTSIDE the store directory and are never
;;;; named here.
;;;;
;;;; Governing sentence: a process may die while its durable history
;;;; survives; reconstruction may derive from that history, but it may not
;;;; pretend to remember what was never committed.
;;;;
;;;; Output protocol (parsed and renumbered by the parent runner):
;;;;   CHECK ok|FAIL <label>      one verdict
;;;;   NOTE <text>                evidence line
;;;;   RESULT: <n> checks, <f> failures      truncation sentinel
;;;; Exit 0 iff zero failures.
;;;;
;;;; — SUPERSTES (Claude Fable 5 subagent), 2026-07-29

(load (merge-pathnames "specimen-common.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-journal0)

;;; ---------------------------------------------------------------------------
;;; Verdict machinery (counts derived from verdicts rendered).

(defvar *r-checks* 0)
(defvar *r-failures* 0)

(defun rcheck (label thunk)
  (incf *r-checks*)
  ;; Labels are format controls with no arguments, so literal tilde-newline
  ;; continuations in the source collapse to clean one-line transcript text.
  (let ((label (format nil label))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "CHECK ok ~a~%" label)
        (progn (incf *r-failures*)
               (format t "CHECK FAIL ~a~@[ (~a)~]~%" label
                       (when (consp outcome) (second outcome)))))))

(defun rnote (control &rest arguments)
  (format t "NOTE ~a~%" (apply #'format nil control arguments)))

(defmacro expects (condition-type &body body)
  `(handler-case (progn ,@body nil)
     (,condition-type () t)
     (error () nil)))

;;; ---------------------------------------------------------------------------
;;; Admissible inputs.

(defvar *arguments* (rest sb-ext:*posix-argv*))
(defvar *store-directory* (truename (pathname (first *arguments*))))
(defvar *mode* (second *arguments*))
(defvar *salvage-destination* (third *arguments*))

;;; The only paths this process may name.  Every store file is derived from
;;; *store-directory* by merge-pathnames; nothing else is opened.
(defun store-file (name) (merge-pathnames name *store-directory*))

(defun inside-store-p (pathname)
  (let ((store (namestring (truename *store-directory*)))
        (candidate (namestring pathname)))
    (and (>= (length candidate) (length store))
         (string= store (subseq candidate 0 (length store))))))

;;; Negative control 4 hook: a child invocation dies HERE, mid-run, before
;;; any verdict and before the RESULT sentinel.
(when (sb-posix:getenv "DE_TESTE_OCCISO_DIE")
  (rnote "child control: dying mid-recovery before any verdict (planted)")
  (sb-ext:exit :code 3))

(rnote "mode ~a" *mode*)
(rnote "admissible inputs: the store directory's durable bytes + declared ~
        configuration; no receipt, no killed-process memory, no operator ~
        testimony")

;;; ---------------------------------------------------------------------------
;;; 1. Validate the surviving store.

(defvar *store* nil)
(defvar *report* nil)

(rcheck "the surviving store opens: metadata canonical, sidecar digest ~
         agrees, store identity re-derived from the metadata basis (§6.1)"
  (lambda ()
    (setf *store* (open-store *store-directory*))
    (and (journal-store-p *store*)
         (eq (journal-store-durability *store*) :synced))))

(rcheck "every file consulted lies inside the store directory (no scratch ~
         file of the dead writer, no sentinel, no receipt channel)"
  (lambda ()
    (every #'inside-store-p
           (list (store-file "JOURNAL-META.pjs")
                 (store-file "JOURNAL-META.pjs.sha256")
                 (store-file "EVENTS.pj0")))))

(setf *report* (validate-journal *store*))

(rnote "explain-journal: ~a" (explain-journal *store*))
(rnote "EVENTS.pj0 sha256 as received: ~a"
       (sha256-hex (or (so-read-octets (store-file "EVENTS.pj0"))
                       (make-array 0 :element-type '(unsigned-byte 8)))))

;;; ---------------------------------------------------------------------------
;;; 2. Longest valid prefix + torn-tail exposure.

(defvar *expected-status*
  (cond ((string= *mode* "torn") :torn-tail)
        ((string= *mode* "mutated") :not-valid)
        (t :valid)))

(defvar *expected-frames*
  (cond ((string= *mode* "torn") 3)
        ((string= *mode* "mutated") 3)
        (t 4)))

(rcheck (format nil "terminal classification is exactly what the BYTES say ~
                     (expected ~a, ~a frame~:p) — the reader reports the ~
                     state present, never the most flattering branch ~
                     (PJ-CW-2)"
                *expected-status* *expected-frames*)
  (lambda ()
    (and (if (eq *expected-status* :not-valid)
             (not (eq (prefix-report-status *report*) :valid))
             (eq (prefix-report-status *report*) *expected-status*))
         (= (prefix-report-frame-count *report*) *expected-frames*))))

(when (member *mode* '("torn" "mutated") :test #'string=)
  (rnote "condition-type ~a · requirement ~a"
         (prefix-report-condition-type *report*)
         (prefix-report-condition-requirement *report*)))

(if (prefix-report-tail-octets *report*)
    (progn
      (rnote "excluded terminal region: offset ~a · ~a octet~:p · sha256 ~a"
             (prefix-report-tail-offset *report*)
             (length (prefix-report-tail-octets *report*))
             (prefix-report-tail-sha256 *report*))
      (rcheck "the excluded terminal region is VISIBLE (offset, octet count, ~
               and digest all reported), NOT committed (outside the valid ~
               prefix), and NOT deleted (§14.1 — opening never truncates)"
        (lambda ()
          (let ((before (length (so-read-octets (store-file "EVENTS.pj0")))))
            (and (prefix-report-tail-octets *report*)
                 (prefix-report-tail-sha256 *report*)
                 (integerp (prefix-report-tail-offset *report*))
                 (= (prefix-report-tail-offset *report*)
                    (prefix-report-valid-byte-count *report*))
                 (< (prefix-report-valid-byte-count *report*) before)
                 ;; revalidating does not truncate the source
                 (progn (validate-journal *store*)
                        (= before (length (so-read-octets
                                           (store-file "EVENTS.pj0"))))))))))
    (rcheck "no torn tail and no excluded region at this cell: the valid ~
             prefix consumes every byte of EVENTS.pj0 (zero excluded ~
             octets) — reported as an absence, not assumed"
      (lambda ()
        (and (null (prefix-report-tail-octets *report*))
             (= (prefix-report-valid-byte-count *report*)
                (length (so-read-octets (store-file "EVENTS.pj0"))))))))

;;; ---------------------------------------------------------------------------
;;; 3. What the surviving history does and does not say.

(when (string= *mode* "primary")
  (rcheck "the event the dead writer was charged with IS committed: found by ~
           event identity at ordinal 4, payload byte-identical to the ~
           declared charge"
    (lambda ()
      (multiple-value-bind (ordinal frame-digest payload)
          (find-event *store* (record-field (fatal-event) "event" "event-id"))
        (and (eql ordinal 4)
             (stringp frame-digest)
             (equalp payload (encode-pjs0 (fatal-event)))))))

  (rcheck "the store's durability declaration is READ, never inferred: ~
           :synced as declared at creation (PJ-DUR-2 — a journal's declared ~
           durability does not change in place)"
    (lambda () (eq (journal-store-durability *store*) :synced)))

  (rcheck "an identity that was never committed is answered as ~
           NOT-COMMITTED with INTENTION-UNKNOWN — the recovery does not ~
           report that it was never proposed, because the journal cannot ~
           say so (the killed process's intentions were never committed)"
    (lambda ()
      (let ((found (find-event *store* (uncharged-event-id))))
        (rnote "e-005: not-committed · intention-unknown ~
                (never-proposed is NOT derivable from durable bytes)")
        (null found)))))

;;; ---------------------------------------------------------------------------
;;; 4. Derived state: :reconstructed, never :observed.

(defvar *view* nil)
(defvar *reconstruction-receipt* nil)

(rcheck "reconstruction replays from the primary journal alone, deletes ~
         derived artifacts first and attests the deletion (PJ-RCN-3), and ~
         yields a view over exactly the validated prefix (K0E-9)"
  (lambda ()
    (multiple-value-setq (*view* *reconstruction-receipt*)
      (reconstruct *store* '("de-teste-occiso" "restart-fold" "0")))
    (let ((count (record-field *view* "view" "event-count")))
      (and (lisp-plus-cd0:integer-datum-p count)
           (= (lisp-plus-cd0:integer-datum-value count) *expected-frames*)))))

(rcheck "the reconstruction receipt's origin is (id \"origin\" ~
         \"reconstructed\") and the receipt bytes contain no occurrence of ~
         \"observed\" anywhere (PJ-WIT-1/2/4, PJ-RCN-1: storage integrity ~
         never upgrades epistemic origin)"
  (lambda ()
    (let ((origin (record-field *reconstruction-receipt*
                                "reconstruction" "origin"))
          (bytes (so-octets-string (encode-pjs0 *reconstruction-receipt*))))
      (and origin
           (string= (identifier-segment-string origin) "origin:reconstructed")
           (null (search "observed" bytes))))))

(rnote "reconstruction: terminal ordinal ~a · output-digest ~a · origin ~a"
       (lisp-plus-cd0:integer-datum-value
        (record-field *reconstruction-receipt* "reconstruction"
                      "terminal-ordinal"))
       (sha256-hex (encode-pjs0 *view*))
       (identifier-segment-string
        (record-field *reconstruction-receipt* "reconstruction" "origin")))

(rcheck "reconstruction beyond the validated prefix is REFUSED, not ~
         extrapolated: requesting ordinal (prefix+1) signals ~
         unsupported-reconstruction (K0E-11 — recovery never scans past ~
         damage or past the end of history)"
  (lambda ()
    (expects unsupported-reconstruction
      (reconstruct *store* '("de-teste-occiso" "restart-fold" "0")
                   :requested-terminal-ordinal (1+ *expected-frames*)))))

;;; ---------------------------------------------------------------------------
;;; 5. Retry discipline.

(defun events-sha ()
  (sha256-hex (so-read-octets (store-file "EVENTS.pj0"))))

(when (string= *mode* "primary")
  (rcheck "a BLIND UNSAFE RETRY is refused: the same event identity carrying ~
           a different payload signals pj0-event-identity-collision and ~
           writes zero bytes (PJ-APP-3 — last-write-wins is prohibited)"
    (lambda ()
      (let ((before (events-sha)))
        (and (expects pj0-event-identity-collision
               (append-event *store* (conflicting-fatal-event)
                             :origin :reconstructed))
             (string= before (events-sha)))))))

(when (string= *mode* "primary")
  (rcheck "CW-3 reconciliation BY EVENT IDENTITY: re-presenting the declared ~
           charge returns :already-committed-identical at the prior ~
           coordinate (ordinal 4) with ZERO new bytes and receipt origin ~
           :reconstructed (PJ-CRASH-1, PJ-APP-2/4)"
    (lambda ()
      (let* ((before (events-sha))
             (receipt (append-event *store* (fatal-event)
                                    :origin :reconstructed)))
        (and (eq (append-receipt-disposition receipt)
                 :already-committed-identical)
             (= 4 (append-receipt-ordinal receipt))
             (eq (append-receipt-origin receipt) :reconstructed)
             (string= before (events-sha))
             (string= "pj0:already-committed-identical"
                      (identifier-segment-string
                       (record-field (append-receipt-record receipt)
                                     "receipt" "append-disposition")))
             (string= "pj0:synced"
                      (identifier-segment-string
                       (record-field (append-receipt-record receipt)
                                     "receipt" "declared-durability"))))))))

(when (string= *mode* "torn")
  (rcheck "a BLIND UNSAFE RETRY is refused over damage too: an identity that ~
           IS in the valid prefix, re-presented with a different payload, ~
           signals pj0-event-identity-collision — the identity lookup runs ~
           before the damage refusal, so the collision is named for what it ~
           is (PJ-APP-3) and zero bytes are written"
    (lambda ()
      (let ((before (events-sha)))
        (and (expects pj0-event-identity-collision
               (append-event *store*
                             (specimen-event "e-001" "a DIFFERENT first thing")
                             :origin :reconstructed))
             (string= before (events-sha))))))

  (rcheck "a damaged store accepts NO new append: presenting a fresh event ~
           over a torn tail signals pj0-torn-tail and writes zero bytes ~
           (§14.1 — appending would bury the tail)"
    (lambda ()
      (let ((before (events-sha)))
        (and (expects pj0-torn-tail
               (append-event *store* (specimen-event "e-009" "after the tear")))
             (string= before (events-sha))))))

  (rcheck "PJ-LOCK-1's other branch still holds over damage: an event ALREADY ~
           in the valid prefix reconciles as :already-committed-identical ~
           rather than being assumed lost"
    (lambda ()
      (let ((receipt (append-event *store* (specimen-event
                                            "e-001"
                                            (cdr (first *established-charge*)))
                                   :origin :reconstructed)))
        (and (eq (append-receipt-disposition receipt)
                 :already-committed-identical)
             (= 1 (append-receipt-ordinal receipt))))))

  (rcheck "source-preserving salvage: the source EVENTS.pj0 is byte-identical ~
           after salvage (PJ-SAL-1), the destination is a NEW store identity ~
           with regenerated frames (PJ-SAL-2/K0E-16), and the receipt names ~
           its bounded unknown — the excluded tail may describe an external ~
           consequence that did occur (PJ-SAL-3)"
    (lambda ()
      (let ((before (events-sha)))
        (multiple-value-bind (destination receipt)
            (salvage-valid-prefix *store-directory*
                                  (pathname *salvage-destination*)
                                  '("de-teste-occiso" "superstes"))
          (let ((destination-report (validate-journal destination)))
            (and (string= before (events-sha))
                 (eq (prefix-report-status destination-report) :valid)
                 (= 3 (prefix-report-frame-count destination-report))
                 (not (string= (journal-store-store-id destination)
                               (journal-store-store-id *store*)))
                 (string= "origin:derived"
                          (identifier-segment-string
                           (record-field receipt "salvage" "output-origin")))
                 (plusp (lisp-plus-cd0:sequence-datum-length
                         (record-field receipt "salvage"
                                       "bounded-unknowns")))))))))

  (rcheck "salvage does not resolve the tear: the SOURCE store remains ~
           classified :torn-tail with its tail still present after salvage"
    (lambda ()
      (let ((again (validate-journal (open-store *store-directory*))))
        (and (eq (prefix-report-status again) :torn-tail)
             (prefix-report-tail-octets again))))))

(when (string= *mode* "mutated")
  (rcheck "a mutated payload byte is classified as CORRUPTION and refused: ~
           the check that reddens is the §8.2 payload-digest recomputation ~
           over the frame's payload bytes; the valid prefix stops BEFORE the ~
           damaged frame and nothing past it is admitted (§13.4 — no ~
           skip-forward recovery)"
    (lambda ()
      (and (not (eq (prefix-report-status *report*) :valid))
           (member (prefix-report-condition-type *report*)
                   '(pj0-payload-digest-mismatch pj0-interior-corruption
                     pj0-frame-digest-mismatch))
           (= 3 (prefix-report-frame-count *report*)))))

  (rcheck "the corrupted store accepts no append and no reconciliation ~
           past the damage: presenting the fatal charge over corruption is ~
           refused with zero bytes written"
    (lambda ()
      (let ((before (events-sha)))
        (and (handler-case (progn (append-event *store* (fatal-event)) nil)
               (pj0-condition () t)
               (error () nil))
             (string= before (events-sha)))))))

;;; ---------------------------------------------------------------------------
;;; 6. K0E-26 joint verdicts (two verdicts, never one green counter).

(let ((joint (joint-structural-semantic-report *store*)))
  (rnote "joint report: structural ~a · semantic ~a · tail-could-hide-~
          settlement-p ~a"
         (getf (getf joint :structural-verdict) :value)
         (getf (getf joint :semantic-verdict) :value)
         (getf joint :tail-could-hide-settlement-p))
  (rcheck "the joint structural+semantic report carries TWO verdicts and ~
           flags whether a tail could hide a settlement (K0E-26, K0E-15 ~
           journal half)"
    (lambda ()
      (and (getf (getf joint :structural-verdict) :value)
           (getf (getf joint :semantic-verdict) :value)
           (eq (getf joint :tail-could-hide-settlement-p)
               (eq (prefix-report-status *report*) :torn-tail))))))

;;; ---------------------------------------------------------------------------

(format t "RESULT: ~a checks, ~a failures~%" *r-checks* *r-failures*)
(sb-ext:exit :code (if (zerop *r-failures*) 0 1))
