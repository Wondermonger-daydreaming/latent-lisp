;;;; specimen-common.lisp — shared ground for de-actu-resurgente.
;;;;
;;;; "Concerning the act that rises again."  FOUR processes participate:
;;;;
;;;;   the ORCHESTRATOR (run-specimen.lisp) — supervises, digests survivors,
;;;;     copies state for the competence control, preserves artifacts, relays
;;;;     verdicts.  It never authorizes, dispatches, refuses, or reconciles
;;;;     anything itself: every verdict about an act in this capture was
;;;;     rendered by a stage child through the lane's own doors.
;;;;
;;;;   the PRIMA VITA (stage-life-1.lisp) — declares the act fixture row, is
;;;;     granted authority, mints its Office R capability, builds ONE bridge
;;;;     object for its act, and evaluates the originating form through
;;;;     `perform`.  The dispatch reaches the world, the world durably applies
;;;;     and ledgers the write, and the process DIES INSIDE THE ACKNOWLEDGMENT
;;;;     WINDOW.  Its Core /0 evidence — the in-image account of what it did —
;;;;     dies with it, BY DESIGN, and the transcript says so.
;;;;
;;;;   the REDIVIVA (stage-restart.lisp) — a genuinely new process that may
;;;;     consult ONLY durable bytes plus the declared configuration in this
;;;;     file.  It re-DERIVES the act identity (never inherits it), refuses the
;;;;     same act at the `perform` boundary from the bytes alone, refuses the
;;;;     same act wearing a fresh attempt name, structures and reconciles the
;;;;     uncertainty at the RUNTIME level with evidence carried to the
;;;;     surviving world, and only then performs a FRESH act on the freed seat.
;;;;
;;;;   the LEAK CONTROL (stage-control-leak.lisp) — runs against COPIES of the
;;;;     post-death state and drives a REFUSED act that writes the world anyway,
;;;;     so the world-scope absence instrument is SHOWN ABLE TO SEE a violation
;;;;     before any arm's absence claim is trusted.
;;;;
;;;; This file carries exactly what all four are ENTITLED to share: the DECLARED
;;;; configuration and the DECLARED charge.  It carries NO state derived from
;;;; the dead process.  A restart that reads this file learns what the act was
;;;; SUPPOSED to do — never what it managed to do.
;;;;
;;;; TWO JURISDICTIONS, kept visibly separate: the journal store (the process's
;;;; evidence; PJ0 bytes) and the world (the fake OUTSIDE; CELLS.txt +
;;;; REQUEST-LEDGER.txt).  The asymmetry between them after the death — the
;;;; world knows, the journal does not — is the state the language door has to
;;;; refuse from.
;;;;
;;;; CRASH MODEL, stated at the fixture: a PLANTED DETERMINISTIC env-var exit
;;;; inside capability /2's world adapter.  NO SIGKILL, no power loss, no
;;;; mid-instruction byte truncation is claimed — journal0/de-teste-occiso and
;;;; vertical0 own the real crash windows.
;;;;
;;;; — PONTIFEX (Claude Opus 5, subagent), 2026-08-19

(load (merge-pathnames "../load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-language-act1)

;;; ---------------------------------------------------------------------------
;;; Own octet I/O (specimen-side; deliberately not the store's internals).

(defun sp-read-octets (pathname)
  (with-open-file (stream pathname :direction :input
                                   :element-type '(unsigned-byte 8)
                                   :if-does-not-exist nil)
    (when stream
      (let ((octets (make-array (file-length stream)
                                :element-type '(unsigned-byte 8))))
        (read-sequence octets stream)
        octets))))

(defun sp-write-octets (pathname octets)
  (ensure-directories-exist pathname)
  (with-open-file (stream pathname :direction :output
                                   :element-type '(unsigned-byte 8)
                                   :if-exists :supersede
                                   :if-does-not-exist :create)
    (write-sequence octets stream)
    (finish-output stream))
  pathname)

(defun sp-ascii (string)
  (map '(simple-array (unsigned-byte 8) (*)) #'char-code string))

(defun sp-octets-string (octets) (map 'string #'code-char octets))

;;; ---------------------------------------------------------------------------
;;; The stage output protocol (parsed and renumbered by the orchestrator).
;;;   CHECK ok|FAIL <label> · NOTE <text> · RESULT: <n> checks, <f> failures

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
                       (when (consp outcome) (second outcome)))))
    (finish-output)
    (eq outcome :ok)))

(defun vnote (control &rest arguments)
  (format t "NOTE ~a~%" (apply #'format nil control arguments))
  (finish-output))

;;; ---------------------------------------------------------------------------
;;; DECLARED CONFIGURATION — identical in every process of this specimen.

;;; PJ-META-1 DEVIATION, declared exactly as capability /2's de-effectu-incerto
;;; declared it (specimen-common.lisp:81-87): a real store MUST carry >= 128
;;; UNPREDICTABLE nonce bits.  This specimen FIXES the nonce so the store
;;; identity — and every digest in the capture — is byte-stable across runs.
;;; The store is a test fixture and never a production identity.
(defvar *specimen-nonce* (sp-ascii "de-actu-resurgen"))   ; exactly 16 octets

(defvar *specimen-durability* "synced")
(defvar *specimen-issuer* '("issuer" "oneact1"))

(defun expected-store-id ()
  "The EXPECTED store identity, derived from the DECLARED configuration alone —
never read off a live store.  The restart compares the store it opened against
this, so 'the right store' is a derivation and not an assumption."
  (store-id-string
   (validate-metadata-octets
    (render-metadata-octets
     (build-metadata-record :declared-durability *specimen-durability*
                            :nonce-octets *specimen-nonce*)))))

(defun specimen-bootstrap () (declare-bootstrap-authority *specimen-issuer*
                                                          (expected-store-id)))

;;; ---------------------------------------------------------------------------
;;; THE DECLARED CHARGE — the act, as configuration.

(defvar *seat* "prima")
(defvar *cell-segments* '("cella" "prima"))
(defvar *cell-name* "cella:prima")
(defvar *initial-cell-value* "VACUA")
(defvar *first-text* "Actus redivivus.")
(defvar *second-text* "Actus alter.")

(defvar *first-attempt* "a-prima")      ; the act that dies
(defvar *retry-attempt* "a-prima-3")    ; the same act, disguised
(defvar *fresh-attempt* "a-prima-2")    ; the FRESH act on the freed seat
(defvar *leak-attempt* "a-prima-4")     ; the competence control only

(defun declared-cells ()
  (list (cons *cell-name* *initial-cell-value*)
        (cons "cella:octava" *initial-cell-value*)))

;;; ⚑ EVERY ROW BELOW IS BUILT FROM DECLARED CONFIGURATION, BY A FUNCTION, so a
;;; genuinely new process builds a row IDENTICAL to the dead process's row
;;; without inheriting anything from it.  That is what makes the act identity
;;; re-derivable across the death: the derivation's inputs are the domain, the
;;; runtime seat, and the canonical request — all declared, none carried.

(defun the-act-row ()
  "THE ACT.  The same row in life 1 and in life 2 — the second time, refused."
  (make-act1-fixture-row
   :arm "L1" :label "prima" :runtime-seat *seat* :attempt-name *first-attempt*
   :cell-segments *cell-segments*
   :adapter-symbol 'de-actu-resurgente/bridge-prima :world-key :apply
   :form (act1-request-form *cell-name* *first-text*)))

(defun the-disguised-retry-row ()
  "THE SAME ACT WEARING A FRESH ATTEMPT NAME.  Same seat, same request — so the
DERIVED ACT IDENTITY IS THE SAME, which is the point: a new attempt name does
not make a new act, and the lane's derivation says so before the guard does."
  (make-act1-fixture-row
   :arm "L2-retry" :label "prima" :runtime-seat *seat*
   :attempt-name *retry-attempt* :cell-segments *cell-segments*
   :adapter-symbol 'de-actu-resurgente/bridge-prima-retry :world-key :apply
   :form (act1-request-form *cell-name* *first-text*)))

(defun the-fresh-act-row ()
  "A GENUINELY NEW ACT on the freed seat: same seat, DIFFERENT request, and
therefore a different derived act identity."
  (make-act1-fixture-row
   :arm "L2-fresh" :label "prima" :runtime-seat *seat*
   :attempt-name *fresh-attempt* :cell-segments *cell-segments*
   :adapter-symbol 'de-actu-resurgente/bridge-prima-fresh :world-key :apply
   :form (act1-request-form *cell-name* *second-text*)))

(defun the-leak-control-row ()
  "⚠ PLANTED FAULT, CONTROL ONLY.  The durable guard REFUSES this act and the
row's `leak-write` seam applies the effect anyway, with capability /2's own
public `:defect :auto-retry-on-uncertain` defeating the runtime gate too.  BOTH
defences are deliberately down, so a refused act really does write the world —
which is exactly the violation the world-scope instrument must be able to see."
  (make-act1-fixture-row
   :arm "LEAK" :label "prima" :runtime-seat *seat* :attempt-name *leak-attempt*
   :cell-segments *cell-segments*
   :adapter-symbol 'de-actu-resurgente/bridge-prima-leak :world-key :apply
   :form (act1-request-form *cell-name* "Manus furtiva.")
   :runtime-defect :auto-retry-on-uncertain :leak-write t))

;;; ---------------------------------------------------------------------------
;;; Paths.  Stage children receive their directories in argv and never print
;;; them (an absolute path in a compared byte would break byte-stability).

(defvar *specimen-root* #p"mneme/language-act-1/de-actu-resurgente/")
(defvar *scratch-store* (merge-pathnames "scratch-store/" *specimen-root*))
(defvar *scratch-world* (merge-pathnames "scratch-world/" *specimen-root*))
(defvar *scratch-run* (merge-pathnames "scratch-run/" *specimen-root*))
(defvar *scratch-control-store* (merge-pathnames "scratch-control-store/"
                                                 *specimen-root*))
(defvar *scratch-control-world* (merge-pathnames "scratch-control-world/"
                                                 *specimen-root*))

(defun act-identity-path (run-directory)
  "The preserved language-side identity: what the dying process DERIVED before
it acted.  The restart re-derives from configuration and compares — the
comparison is the demonstration, and the file is the only thing that makes it
falsifiable."
  (merge-pathnames "ACT-IDENTITY.txt" run-directory))

(defun world-directory-of (stage-world-directory) stage-world-directory)
