;;;; specimen-common.lisp — shared ground for de-clave-mortua.
;;;;
;;;; "Concerning the dead key."  Three processes participate: the
;;;; ORCHESTRATOR (run-specimen.lisp — supervises, preserves artifacts,
;;;; relays verdicts; it never mints or presents anything itself), the
;;;; PRIMA VITA (stage-first-life.lisp — is granted authority, mints a live
;;;; key, uses it, preserves every PUBLIC record of it, then EXITS: the key
;;;; dies with the process), and the REDIVIVUS (stage-restart.lisp — a
;;;; genuinely new process that may consult ONLY durable bytes plus the
;;;; declared configuration in this file, and which must prove the dead key
;;;; CANNOT be re-obtained from what survived, only re-minted fresh).
;;;;
;;;; This file carries exactly what all three are ENTITLED to share: the
;;;; DECLARED configuration (store nonce, durability, bootstrap issuer,
;;;; minter principal, the expected store identity DERIVED from that
;;;; configuration and not from any live store) and the DECLARED charge
;;;; (which grant the store is supposed to contain; which query identity
;;;; each life uses).  It carries no state derived from the dead process.
;;;; A restart that reads this file learns what the operation was SUPPOSED
;;;; to be — never what it managed to do, and never the key.
;;;;
;;;; All journal and capability operations go through the exported public
;;;; surfaces of #:lisp-plus-capability1 and (through it)
;;;; #:lisp-plus-capability0 / #:lisp-plus-journal0 — with ONE deliberate,
;;;; labelled exception: the REDIVIVUS builds a counterfeit through the
;;;; internal constructor (:: path) to prove that even the real constructor
;;;; cannot resurrect the dead key from its public records.  Raw octet I/O
;;;; below is the specimen's own; it is used only to inspect and copy
;;;; artifact BYTES, never to write a frame.
;;;;
;;;; — CLAVIGER-II (Claude Fable 5 subagent), 2026-07-29

(load (merge-pathnames "../load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-capability1)

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

;;; PJ-META-1 DEVIATION, declared exactly as journal0's de-teste-occiso and
;;; capability0's de-potestate-revocata declared it: a real store MUST carry
;;; >= 128 UNPREDICTABLE nonce bits.  This specimen fixes the nonce so that
;;; the store identity — and therefore every digest printed in the capture —
;;; is deterministic across runs.  The store is a test fixture and is never
;;; a production identity.
(defvar *specimen-nonce* (sp-ascii "de-clave-mortua!"))   ; exactly 16 octets

(defvar *specimen-durability* "synced")

;;; The declared bootstrap issuer — the one root authority of this world —
;;; and the declared minter principal.
(defvar *specimen-issuer* '("cap1-issuer" "radix"))
(defvar *specimen-minter* '("cap1-minter" "claviger"))

;;; The EXPECTED store identity, derived from the DECLARED configuration
;;; alone (metadata rebuilt from the fixed nonce + durability, through
;;; journal0's public metadata surface) — NOT read from any live store.
(defun expected-store-id ()
  (lisp-plus-journal0:store-id-string
   (lisp-plus-journal0:validate-metadata-octets
    (lisp-plus-journal0:render-metadata-octets
     (lisp-plus-journal0:build-metadata-record
      :declared-durability *specimen-durability*
      :nonce-octets *specimen-nonce*)))))

(defun specimen-bootstrap ()
  "The explicit bootstrap authority every derivation in this specimen is
handed: declared issuer + declared (derived-from-config) store binding."
  (declare-bootstrap-authority *specimen-issuer* (expected-store-id)))

;;; ---------------------------------------------------------------------------
;;; The declared charge.

(defvar *capability-segments* '("cap" "clavis-mortua"))
(defvar *subject-segments* '("subj" "ianitor"))
(defvar *action-segments* '("act" "aperire"))
(defvar *resource-segments* '("res" "ianua-prima"))
(defvar *scope-segments* '("scope" "exact"))

;;; Each life asks under its OWN declared query identity.  This is charge,
;;; not accident: the minting occurrence identity derives from the fresh
;;; authorization receipt's bytes, so distinct query identities per life
;;; make the cross-life identity difference deterministic and honest.
(defvar *first-life-query* "q-vita-1")
(defvar *restart-query* "q-vita-2")

(defun charged-grant ()
  (make-grant-event :event-id '("cap0-event" "g-001")
                    :capability-id *capability-segments*
                    :subject *subject-segments*
                    :action *action-segments*
                    :resource *resource-segments*
                    :scope *scope-segments*
                    :issuer *specimen-issuer*))

(defun charged-query (store bootstrap query-name &rest overrides)
  (apply #'query-live-authority store bootstrap
         :query-id (list "cap0-query" query-name)
         (append overrides
                 (list :capability-id *capability-segments*
                       :subject *subject-segments*
                       :action *action-segments*
                       :resource *resource-segments*
                       :scope *scope-segments*))))

(defun charged-presentation (store bootstrap context object name)
  (present-live-capability store bootstrap context object
                           :subject *subject-segments*
                           :action *action-segments*
                           :resource *resource-segments*
                           :scope *scope-segments*
                           :presentation-id (list "cap1-present" name)))

;;; ---------------------------------------------------------------------------
;;; Paths (root-relative; every process is executed from the latent-lisp
;;; root).  Stage children receive their paths in argv and never print them.

(defvar *specimen-root* #p"mneme/capability1/de-clave-mortua/")
(defvar *scratch-store* (merge-pathnames "scratch-store/" *specimen-root*))
(defvar *scratch-run* (merge-pathnames "scratch-run/" *specimen-root*))

;;; The preserved public record of the dead key.  The PRIMA VITA writes
;;; these; the ORCHESTRATOR digests them before and after the restart; the
;;; REDIVIVUS reads them back as durable bytes and proves none of them is,
;;; or can become, the key.
(defun auth-receipt-path (run-directory)
  (merge-pathnames "AUTH-RECEIPT.pjs" run-directory))
(defun mint-receipt-path (run-directory)
  (merge-pathnames "MINT-RECEIPT.pjs" run-directory))
(defun dead-key-print-path (run-directory)
  (merge-pathnames "DEAD-KEY-PRINT.txt" run-directory))
(defun mint-receipt-2-path (run-directory)
  (merge-pathnames "MINT-RECEIPT-2.pjs" run-directory))
