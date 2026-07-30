;;;; specimen-common.lisp — shared ground for de-effectu-incerto.
;;;;
;;;; "Concerning the uncertain effect."  Three processes participate: the
;;;; ORCHESTRATOR (run-specimen.lisp — supervises, digests survivors,
;;;; preserves artifacts, relays verdicts; it never authorizes, dispatches,
;;;; or reconciles anything itself), the PRIMA VITA (stage-first-life.lisp
;;;; — is granted authority, mints a key, is authorized to attempt ONE
;;;; exact protected effect, dispatches it, and DIES inside the
;;;; acknowledgment window: the dispatch landed in the world, the
;;;; acknowledgment never came home, and the process's memory — including
;;;; everything it might have "known" about what happened — dies with it),
;;;; and the REDIVIVA (stage-restart.lisp — a genuinely new process that
;;;; may consult ONLY durable bytes plus the declared configuration in
;;;; this file, and which must refuse blind retry FROM THE BYTES ALONE,
;;;; structure the uncertainty as the §10.8 record, and resolve it by the
;;;; declared evidence-carrying procedure against the surviving world).
;;;;
;;;; This file carries exactly what all three are ENTITLED to share: the
;;;; DECLARED configuration (store nonce, durability, bootstrap issuer,
;;;; minter, the capability's exact terms, the world's declared cells, the
;;;; expected store identity DERIVED from configuration and not read off
;;;; any live store) and the DECLARED charge (grant, query identities per
;;;; life, attempt and seat names, the one exact effect: cella:septima :=
;;;; "VII").  It carries no state derived from the dead process.  A
;;;; restart that reads this file learns what the operation was SUPPOSED
;;;; to do — never what it managed to do.
;;;;
;;;; TWO JURISDICTIONS, kept visibly separate throughout: the journal
;;;; store (the process's evidence; PJ0 bytes) and the world (the fake
;;;; OUTSIDE; the adapter's CELLS.txt + REQUEST-LEDGER.txt).  The
;;;; asymmetry between them after the death — the world knows, the journal
;;;; does not — IS the uncertainty this specimen exists to inhabit.
;;;;
;;;; All journal/capability/effect operations go through the exported
;;;; public surfaces of #:lisp-plus-capability2 and (through it)
;;;; #:lisp-plus-capability1 / #:lisp-plus-capability0 /
;;;; #:lisp-plus-journal0.  Raw octet I/O below is the specimen's own; it
;;;; only inspects and copies artifact BYTES, never writes a frame or a
;;;; world byte.
;;;;
;;;; — CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30

(load (merge-pathnames "../load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-capability2)

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

(defun sp-octets-string (octets)
  (map 'string #'code-char octets))

;;; ---------------------------------------------------------------------------
;;; Declared configuration (the same for every process in the specimen).

;;; PJ-META-1 DEVIATION, declared exactly as journal0's de-teste-occiso,
;;; capability0's de-potestate-revocata, and capability1's de-clave-mortua
;;; declared it: a real store MUST carry >= 128 UNPREDICTABLE nonce bits.
;;; This specimen fixes the nonce so the store identity — and every digest
;;; printed in the capture — is deterministic across runs.  The store is a
;;; test fixture and never a production identity.
(defvar *specimen-nonce* (sp-ascii "de-effectu-incer"))   ; exactly 16 octets

(defvar *specimen-durability* "synced")

(defvar *specimen-issuer* '("cap2-issuer" "radix"))
(defvar *specimen-minter* '("cap2-minter" "claviger"))

;;; The EXPECTED store identity, derived from the DECLARED configuration
;;; alone — never read off a live store.
(defun expected-store-id ()
  (store-id-string
   (validate-metadata-octets
    (render-metadata-octets
     (build-metadata-record
      :declared-durability *specimen-durability*
      :nonce-octets *specimen-nonce*)))))

(defun specimen-bootstrap ()
  (declare-bootstrap-authority *specimen-issuer* (expected-store-id)))

;;; ---------------------------------------------------------------------------
;;; The declared charge.

(defvar *capability-segments* '("cap" "clavis-effectus"))
(defvar *subject-segments* '("subj" "custos"))
(defvar *action-segments* '("act" "scribere"))
(defvar *cell-segments* '("cella" "septima"))
(defvar *scope-segments* '("scope" "exact"))
(defvar *declared-value* "VII")
(defvar *seat-name* "sedes-prima")
(defvar *first-attempt* "a-001")
(defvar *second-attempt* "a-002")

;;; The world's declared cells (the bounded resource).
(defun declared-cells ()
  (list (cons (identifier-segment-string
               (identifier-from-segments *cell-segments*))
              "VACUA")
        (cons "cella:octava" "VACUA")))

;;; Each life asks under its OWN declared query identities (charge, not
;;; accident: the minting occurrence identity derives from the fresh
;;; authorization receipt's bytes, so distinct query identities per life
;;; make cross-life identity difference deterministic and honest).
(defvar *first-life-query* "q-vita-1")
(defvar *first-life-auth-query* "q-vita-1-auth")
(defvar *restart-query* "q-vita-2")
(defvar *restart-query-post-declare* "q-vita-2-post-declare")
(defvar *restart-query-post-reconcile* "q-vita-2-post-reconcile")
(defvar *restart-auth-query* "q-vita-2-auth")
(defvar *restart-auth-query-2* "q-vita-2-auth-2")

(defun charged-grant ()
  (make-grant-event :event-id '("cap0-event" "g-001")
                    :capability-id *capability-segments*
                    :subject *subject-segments*
                    :action *action-segments*
                    :resource *cell-segments*
                    :scope *scope-segments*
                    :issuer *specimen-issuer*))

(defun charged-mint (store bootstrap context query-name)
  (mint-from-authorization
   store bootstrap context
   (query-live-authority store bootstrap
                         :query-id (list "cap0-query" query-name)
                         :capability-id *capability-segments*
                         :subject *subject-segments*
                         :action *action-segments*
                         :resource *cell-segments*
                         :scope *scope-segments*)
   :minter *specimen-minter*))

(defun charged-authorize (store bootstrap context key query-name attempt-name
                          &key defect)
  (authorize-effect-attempt store bootstrap context key
                            :capability-id *capability-segments*
                            :query-name query-name
                            :subject *subject-segments*
                            :action *action-segments*
                            :resource *cell-segments*
                            :scope *scope-segments*
                            :cell *cell-segments*
                            :value *declared-value*
                            :attempt-name attempt-name
                            :seat-name *seat-name*
                            :defect defect))

;;; ---------------------------------------------------------------------------
;;; Paths (root-relative; every process is executed from the latent-lisp
;;; root).  Stage children receive their paths in argv and never print them.

(defvar *specimen-root* #p"mneme/capability2/de-effectu-incerto/")
(defvar *scratch-store* (merge-pathnames "scratch-store/" *specimen-root*))
(defvar *scratch-world* (merge-pathnames "scratch-world/" *specimen-root*))
(defvar *scratch-run* (merge-pathnames "scratch-run/" *specimen-root*))

;;; The preserved public record: the authorization-to-attempt receipt the
;;; PRIMA VITA held when it died — testimony that licensed the attempt and
;;; proves nothing about the effect (law 6's exhibit).
(defun auth-attempt-receipt-path (run-directory)
  (merge-pathnames "AUTH-ATTEMPT-RECEIPT.pjs" run-directory))
