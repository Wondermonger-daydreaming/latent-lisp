;;;; specimen-common.lisp — shared ground for de-actu-memorato.
;;;;
;;;; "Concerning the remembered act."  FIVE processes participate:
;;;;
;;;;   the ORCHESTRATOR (run-specimen.lisp) — supervises, digests survivors,
;;;;     copies state for the damage control, preserves artifacts, relays
;;;;     verdicts.  It never writes, retrieves, consolidates, or performs
;;;;     anything itself: every verdict about an account in this capture was
;;;;     rendered by a stage child through this lane's own doors.
;;;;
;;;;   the SCRIPTOR (stage-writer.lisp) — performs ONE bounded act through One
;;;;     Act /1's public seam, reads the occurrence basis out of the world's and
;;;;     the journal's own bytes, reads the issuance testimony out of Core /0's
;;;;     live predicate IN ITS OWN IMAGE, and writes the memory account.  It also
;;;;     writes the crown negative's issuance-only account, and exercises the
;;;;     cross-identity refusal against a store it then proves byte-unchanged.
;;;;     Then it exits, and everything in its image dies with it.
;;;;
;;;;   the MORITURUS (stage-death.lisp) — a SEPARATE store and world.  It crosses
;;;;     the frontier, the world durably applies and ledgers the write, and the
;;;;     process DIES INSIDE THE ACKNOWLEDGMENT WINDOW.  No account of that act
;;;;     is ever written by anyone who was there.
;;;;
;;;;   the LECTOR (stage-reader.lisp) — a genuinely new process that may consult
;;;;     ONLY durable bytes plus the declared configuration in this file.  It
;;;;     retrieves the scriptor's accounts, proves that reading performed
;;;;     nothing, proves that retrieval confers neither evidence nor authority,
;;;;     and WRITES the moriturus's account from the durable independent basis —
;;;;     `occurred`, with issuance `unresolved`, because a fresh process cannot
;;;;     tell never-issued from issued-and-died.
;;;;
;;;;   the VULNERATUS (stage-damage.lisp) — runs against COPIES of the account
;;;;     store, truncated and bit-flipped, so that damaged durable bytes are
;;;;     SHOWN to fail closed before any undamaged retrieval is trusted.
;;;;
;;;; This file carries exactly what all five are ENTITLED to share: the DECLARED
;;;; configuration and the DECLARED charge.  It carries NO state derived from any
;;;; other process.  A reader that reads this file learns what the act was
;;;; SUPPOSED to be — never what any process managed to do.
;;;;
;;;; THREE JURISDICTIONS, kept visibly separate:
;;;;   the ACT JOURNAL   — the runtime's own account (capability /2's PJ0 bytes);
;;;;   the WORLD         — the fake OUTSIDE (CELLS.txt + REQUEST-LEDGER.txt);
;;;;   the ACCOUNT STORE — the LANGUAGE's account of its act (this lane's PJ0
;;;;                       bytes, a different store in a different directory).
;;;; The third is the one that did not exist before this lane, and the whole
;;;; specimen is about what it may and may not say.
;;;;
;;;; CRASH MODEL, stated at the fixture: PLANTED DETERMINISTIC PROCESS DEATH ONLY
;;;; — an env-var exit inside capability /2's world adapter.  NO SIGKILL, no
;;;; power loss, no mid-instruction byte truncation is claimed; journal0's
;;;; de-teste-occiso and vertical0 own the real crash windows and are cited, never
;;;; annexed.
;;;;
;;;; — TABULARIUS (Claude Opus 5, subagent), 2026-08-20

(require :sb-posix)

(load (merge-pathnames "../ml0-suite-ground.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-memory-layer0)

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
;;;
;;; PJ-META-1 DEVIATION, declared exactly as One Act /1's de-actu-resurgente and
;;; capability /2's de-effectu-incerto declared it: a real store MUST carry >= 128
;;; UNPREDICTABLE nonce bits.  This specimen FIXES both nonces so every identity
;;; and every digest in the capture is byte-stable across runs.  These stores are
;;; test fixtures and never production identities.

(defvar *act-nonce* (sp-ascii "de-actu-memorat"))       ; 15 + one below
(defvar *account-nonce* (sp-ascii "de-memoria-fixa1"))  ; exactly 16 octets
(defvar *specimen-durability* "synced")
(defvar *specimen-issuer* '("issuer" "oneact1"))

;;; ⚠ ASSERTED BY LENGTH, not by counting the source line.
(defvar *act-nonce-16* (concatenate '(vector (unsigned-byte 8)) *act-nonce* #(#x31)))

(defun expected-store-id (nonce)
  "The EXPECTED store identity, derived from the DECLARED configuration alone —
never read off a live store.  Each stage compares the store it opened against
this, so `the right store` is a derivation and not an assumption."
  (store-id-string
   (validate-metadata-octets
    (render-metadata-octets
     (build-metadata-record :declared-durability *specimen-durability*
                            :nonce-octets nonce)))))

;;; ---------------------------------------------------------------------------
;;; THE DECLARED CHARGE — the acts, as configuration.

(defvar *seat* "prima")
(defvar *cell-segments* '("cella" "prima"))
(defvar *cell-name* "cella:prima")
(defvar *initial-cell-value* "VACUA")
(defvar *memorable-text* "Actus memorandus.")
(defvar *refused-text* "Actus qui non fuit.")
(defvar *dying-text* "Actus sine teste.")

(defvar *memorable-attempt* "a-prima")     ; the act that occurs and is remembered
(defvar *refused-seat* "secunda")
(defvar *refused-attempt* "a-secunda")     ; the act that is refused, with issued evidence
(defvar *other-seat* "tertia")
(defvar *other-attempt* "a-tertia")        ; a DIFFERENT act, for the cross-identity refusal
(defvar *dying-attempt* "a-prima")         ; in the moriturus's OWN store and world

(defvar *scriptor-process* "scriptor")
(defvar *moriturus-process* "moriturus")
(defvar *lector-process* "lector")

(defun declared-cells ()
  (list (cons *cell-name* *initial-cell-value*)
        (cons "cella:vetita-scope" *initial-cell-value*)
        (cons "cella:revocata" *initial-cell-value*)))

;;; ⚑ EVERY ROW BELOW IS BUILT FROM DECLARED CONFIGURATION, BY A FUNCTION, so a
;;; genuinely new process builds a row IDENTICAL to the writing process's row
;;; without inheriting anything from it.  That is what makes the act identity
;;; re-derivable across the process boundary: the derivation's inputs are the
;;; domain, the runtime seat, and the canonical request — all declared, none
;;; carried.

(defun the-memorable-row ()
  "THE ACT WORTH REMEMBERING.  It settles: the frontier is crossed, the world
durably applies and ledgers the write, the journal carries the whole sequence."
  (ml0-settled-row :seat *seat* :attempt *memorable-attempt*
                   :cell *cell-segments* :cell-name *cell-name*
                   :text *memorable-text* :symbol 'de-actu-memorato/bridge-memorabilis))

(defun the-refused-row ()
  "THE ACT THAT DID NOT HAPPEN, and for which Core /0 nevertheless GENUINELY
ISSUED an evidence account.  The crown negative's subject."
  (ml0-refused-row :seat *refused-seat* :attempt *refused-attempt*
                   :cell '("cella" "vetita-scope") :cell-name "cella:vetita-scope"
                   :text *refused-text* :symbol 'de-actu-memorato/bridge-vetitus))

(defun the-other-row ()
  "A GENUINELY DIFFERENT ACT, whose provenance the cross-identity refusal tries
to smuggle into the memorable act's bundle."
  (ml0-settled-row :seat *other-seat* :attempt *other-attempt*
                   :cell '("cella" "revocata") :cell-name "cella:revocata"
                   :text "Actus alienus." :symbol 'de-actu-memorato/bridge-alienus))

(defun the-dying-row ()
  "THE ACT NOBODY LIVED TO ACCOUNT FOR.  In the moriturus's OWN store and world:
the world applies and ledgers the write, and the process exits inside the
acknowledgment window before any evidence can survive."
  (ml0-settled-row :seat *seat* :attempt *dying-attempt*
                   :cell *cell-segments* :cell-name *cell-name*
                   :text *dying-text* :symbol 'de-actu-memorato/bridge-moriturus))

;;; ---------------------------------------------------------------------------
;;; The per-stage ground.  Directories arrive in argv and are NEVER printed (an
;;; absolute path in a compared byte would break byte-stability).

(defun memorato-act-ground (store-directory world-directory &key (create t))
  "Build or open the ACT jurisdiction: One Act /1's store and one world."
  (setf *ml0-act-store*
        (if create
            (create-journal store-directory
                            :declared-durability *specimen-durability*
                            :nonce-octets *act-nonce-16*)
            (open-store store-directory)))
  (setf lisp-plus-language-act1:*act1-store* *ml0-act-store*)
  (setf *ml0-worlds*
        (list :apply (if create
                         (lisp-plus-capability2:make-world world-directory
                                                           (declared-cells)
                                                           :script :apply)
                         (lisp-plus-capability2:open-world world-directory
                                                           :script :apply))))
  (setf lisp-plus-language-act1:*act1-worlds* *ml0-worlds*)
  (setf *ml0-world-directories* (list :apply world-directory))
  (setf lisp-plus-language-act1:*act1-world-directories* *ml0-world-directories*)
  (setf lisp-plus-language-act1:*act1-bootstrap*
        (lisp-plus-capability0:declare-bootstrap-authority
         *specimen-issuer* (journal-store-store-id *ml0-act-store*)))
  (setf lisp-plus-language-act1:*act1-minting-context*
        (lisp-plus-capability1:make-minting-context :label "de-actu-memorato"))
  *ml0-act-store*)

(defun memorato-account-ground (account-directory &key (create t))
  "Build or open the ACCOUNT jurisdiction — THIS LANE'S OWN STORE, a different
directory and a different file set from the act journal."
  (setf *ml0-account-root* account-directory)
  (setf *ml0-account-store*
        (if create
            (create-journal account-directory
                            :declared-durability *specimen-durability*
                            :nonce-octets *account-nonce*)
            (open-store account-directory)))
  *ml0-account-store*)

(defun memorato-record-accounts (run-directory alist)
  "The writing process leaves the ACCOUNT IDENTITIES it wrote where the reader can
find them.  ⚠ THIS FILE IS NOT AN ACCOUNT AND CARRIES NO STANDING: it is an index,
exactly as the act specimen's ACT-IDENTITY.txt is a comparison target.  The reader
uses it to ASK for an account and then checks everything it gets back against the
durable bytes and against its own re-derivation."
  (sp-write-octets (merge-pathnames "ACCOUNT-INDEX.txt" run-directory)
                   (sp-ascii (format nil "~{~a~%~}"
                                     (mapcar (lambda (pair)
                                               (format nil "~a ~a" (car pair) (cdr pair)))
                                             alist)))))

(defun memorato-read-accounts (run-directory)
  (let ((text (sp-octets-string
               (or (sp-read-octets (merge-pathnames "ACCOUNT-INDEX.txt" run-directory))
                   (sp-ascii "")))))
    (let ((out '()) (start 0))
      (loop for newline = (position #\Newline text :start start)
            while newline
            do (let* ((line (subseq text start newline))
                      (space (position #\Space line)))
                 (when space
                   (push (cons (subseq line 0 space) (subseq line (1+ space))) out))
                 (setf start (1+ newline))))
      (nreverse out))))

(defun memorato-account-of (index key)
  (cdr (assoc key index :test #'string=)))
