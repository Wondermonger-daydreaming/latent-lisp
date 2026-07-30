;;;; stage-first-life.lisp — the PRIMA VITA: the process that crosses the
;;;; frontier and dies before the acknowledgment comes home.
;;;;
;;;; Launched by run-specimen.lisp as a separate `sbcl --script` invocation
;;;; WITH CAP2_WORLD_DIE_IN_WINDOW=1 in its environment.  It: creates the
;;;; declared store and world · commits the bootstrap-grounded grant ·
;;;; mints the opaque live key · is AUTHORIZED to attempt the one exact
;;;; protected effect (the receipt preserved to disk as testimony) ·
;;;; invokes the effect — attempt:prepared and attempt:frontier-crossed
;;;; are journaled, the adapter durably applies the cell write and ledgers
;;;; it, and then the planted interruption fires: THE PROCESS EXITS INSIDE
;;;; THE ACKNOWLEDGMENT WINDOW (board interruption point 2; AP0 W1
;;;; analog).  No acknowledgment is journaled; no settlement; no §10.8
;;;; record — the process died before it could say anything about what
;;;; happened.  Its memory dies with it.  What survives is exactly: the
;;;; journal (grant · prepared · frontier-crossed), the world (cell
;;;; written, ledger entry), and the authorization receipt's bytes.
;;;;
;;;; Interruption mechanism, stated honestly: a planted deterministic
;;;; env-var early exit in the adapter's return path (world.lisp), the
;;;; capability1 planted-death precedent.  No SIGKILL and no
;;;; mid-instruction byte truncation is claimed — de-teste-occiso owns
;;;; real crash-window truncation.
;;;;
;;;; Output protocol (parsed and renumbered by the parent runner):
;;;;   CHECK ok|FAIL <label> · NOTE <text> · RESULT: <n> checks, <f> failures
;;;; THIS STAGE MUST NOT RENDER A RESULT SENTINEL: it is supposed to die.
;;;; The parent verifies exit code 7 and the ABSENCE of RESULT:.
;;;;
;;;; — CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30

(load (merge-pathnames "specimen-common.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-capability2)

(defvar *v-checks* 0)
(defvar *v-failures* 0)

(defun vcheck (label thunk)
  (incf *v-checks*)
  (let ((label (format nil label))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "CHECK ok ~a~%" label)
        (progn (incf *v-failures*)
               (format t "CHECK FAIL ~a~@[ (~a)~]~%" label
                       (when (consp outcome) (second outcome)))))))

(defun vnote (control &rest arguments)
  (format t "NOTE ~a~%" (apply #'format nil control arguments)))

;;; ---------------------------------------------------------------------------
;;; Admissible inputs: argv paths + the declared configuration.

(defvar *arguments* (rest sb-ext:*posix-argv*))
(defvar *store-directory* (pathname (first *arguments*)))
(defvar *world-directory* (pathname (second *arguments*)))
(defvar *run-directory* (pathname (third *arguments*)))

(vnote "prima vita: store · world · grant · mint · authorize · dispatch — ~
        and death in the acknowledgment window")

(defvar *store* (create-journal *store-directory*
                                :declared-durability *specimen-durability*
                                :nonce-octets *specimen-nonce*))
(defvar *world* (make-world *world-directory* (declared-cells)))
(defvar *bootstrap* (specimen-bootstrap))
(defvar *context* (make-minting-context :label "prima-vita"))

(vcheck "the created store's derived identity EQUALS the identity derived ~
         from the declared configuration alone"
  (lambda () (string= (journal-store-store-id *store*)
                      (expected-store-id))))

(append-event *store* (charged-grant))

(vcheck "the grant commits at ordinal 1; the declared world holds ~
         cella:septima = VACUA with an empty request ledger"
  (lambda ()
    (and (= 1 (prefix-report-frame-count (validate-journal *store*)))
         (equal "VACUA" (world-cell-value *world* "cella:septima"))
         (= 0 (world-ledger-count *world*)))))

(defvar *key* (charged-mint *store* *bootstrap* *context*
                            *first-life-query*))

(vcheck "the opaque live key is minted from the fresh /0 authorization ~
         (LAW 1 half one: minting wrote no journal frame beyond the ~
         grant and no world byte)"
  (lambda ()
    (and (live-capability-p *key*)
         (= 1 (prefix-report-frame-count (validate-journal *store*)))
         (= 0 (world-ledger-count *world*)))))

(defvar *auth* (charged-authorize *store* *bootstrap* *context* *key*
                                  *first-life-auth-query* *first-attempt*))

(sp-write-octets (auth-attempt-receipt-path *run-directory*)
                 (encode-pjs0 *auth*))

(vcheck "authorization to attempt granted and its receipt preserved to ~
         disk byte-identically (LAW 2: the receipt exists and still ~
         nothing is acknowledged — no world byte, no ledger entry, no ~
         journal frame beyond the grant)"
  (lambda ()
    (and (%authorization-receipt-p *auth*)
         (equalp (sp-read-octets (auth-attempt-receipt-path *run-directory*))
                 (encode-pjs0 *auth*))
         (= 1 (prefix-report-frame-count (validate-journal *store*)))
         (equal "VACUA" (world-cell-value *world* "cella:septima"))
         (= 0 (world-ledger-count *world*)))))

(vnote "invoking the protected effect; the planted interruption will fire ~
        inside the adapter's acknowledgment window — this process ends ~
        here, mid-attempt, and MUST NOT render a RESULT sentinel")

;;; THE DEATH.  attempt-protected-effect journals prepared +
;;; frontier-crossed, dispatches, the world durably applies and ledgers
;;; the write — and the adapter exits the process (code 7) before any
;;; acknowledgment returns.  Nothing below this call runs.
(attempt-protected-effect *store* *bootstrap* *context* *key* *auth* *world*
                          :process-name "vita-prima")

;;; Unreachable on the specimen path.  If the interruption failed to fire,
;;; the sentinel below renders and the parent FAILS the phase (it demands
;;; exit 7 with no sentinel).
(format t "RESULT: ~a checks, ~a failures~%" *v-checks* *v-failures*)
(sb-ext:exit :code (if (zerop *v-failures*) 0 1))
