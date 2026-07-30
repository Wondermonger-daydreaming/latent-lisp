;;;; mint.lisp — the §11.3 minting bridge [CAP-2], subset executed.
;;;;
;;;; MINT-FROM-AUTHORIZATION turns a truthful /0 authorization receipt into
;;;; an opaque live capability — and NOTHING ELSE does.  The five CAP-2
;;;; steps, as executed here (divergences named in CAPABILITY-1-RETURN.md):
;;;;
;;;;   1. VALIDATE the authorizing claim identity and standing — the
;;;;      presented datum must BE a /0 authority receipt claiming
;;;;      authorization, and its standing is established by /0's own
;;;;      present-receipt discipline: stale binding refuses with /0's
;;;;      cap0-stale-receipt; a current binding is RE-DERIVED by a fresh
;;;;      fold, and the fresh decision — never the receipt's — is what
;;;;      counts.  A receipt whose description says :authorized over a
;;;;      prefix whose fold says no is refused
;;;;      (cap1-mint-refused :fresh-derivation-refused): the description
;;;;      cannot forge the key.
;;;;   2. DERIVE SCOPE under an identified procedure — the identified
;;;;      procedure is exact copy from the fresh authorization receipt's
;;;;      terms (scope-procedure cap1-scope:exact-from-authorization,
;;;;      version 0); no widening, no narrowing, no patterning.
;;;;   3. IDENTIFY MINTER — the caller-declared minter principal, recorded
;;;;      in the object and the minting receipt.  DELEGATES: NONE — this
;;;;      slice names no restoration delegates (named divergence).
;;;;   4. CREATE the live opaque capability — %make-live-capability
;;;;      (internal), bound to the EXACT validated prefix the fresh
;;;;      derivation examined, then registered in the minting context's EQ
;;;;      table.  Registration IS the grant of recognizability; nothing
;;;;      else confers it.
;;;;   5. EMIT a minting receipt — a public canonical CD/0 record: truthful
;;;;      testimony about what was minted, sufficient to explain and to
;;;;      audit, sufficient to recreate NOTHING (there is no secret
;;;;      material at all — recognition is EQ membership, so no
;;;;      serializable content can re-enter the table).
;;;;
;;;; Minting occurrences are NOT journaled (the /0 L9 adjudication, adopted:
;;;; a mint is a process-local occurrence over a validated prefix — derived
;;;; state; the journaled facts remain /0's grant/revocation events).
;;;;
;;;; Occurrence identity is DERIVED, deterministic, and process-local:
;;;; sha256 of the fresh authorization receipt's canonical bytes + this
;;;; context's mint serial.  Two lives that ask the same question at the
;;;; same prefix under the same query identity would derive the same name —
;;;; identity is a name, not authority; recognition never consults it (no
;;;; global-uniqueness claim; named in the RETURN).
;;;;
;;;; — CLAVIGER-II (Claude Fable 5 subagent), 2026-07-29

(in-package #:lisp-plus-capability1)

(defvar +mint-procedure-segments+ '("lisp-plus-capability1"
                                    "mint-from-authorization"))
(defvar +mint-procedure-version+ 0)
(defvar +scope-procedure-segments+ '("cap1-scope" "exact-from-authorization"))
(defvar +scope-procedure-version+ 0)

(defun %cap1-field (segments value)
  (lisp-plus-cd0:make-record-entry (identifier-from-segments segments) value))

(defun %fresh-receipt-string (receipt name)
  (lisp-plus-cd0:string-datum-value (record-field receipt "receipt" name)))

(defun %fresh-receipt-integer (receipt name)
  (lisp-plus-cd0:integer-datum-value (record-field receipt "receipt" name)))

(defun %make-minting-receipt (&key fresh minter occurrence-id public-id)
  "The public minting receipt: truthful testimony, canonical CD/0 record.
Carries the minting occurrence identity, the capability's PUBLIC identity,
the identified minter, the authorizing claim identity (the /0 query-id) with
its full prefix binding, the grant linkage, the exact terms, and the
identified procedures.  Carries NO reconstruction material — there is none
to carry."
  (let ((entries
          (list
           (%cap1-field '("receipt" "kind")
                        (identifier-from-segments '("cap1" "minting")))
           (%cap1-field '("receipt" "occurrence-id") occurrence-id)
           (%cap1-field '("receipt" "capability-public-id") public-id)
           (%cap1-field '("receipt" "minter") minter)
           (%cap1-field '("receipt" "authorizing-query-id")
                        (record-field fresh "receipt" "query-id"))
           (%cap1-field '("receipt" "capability-id")
                        (record-field fresh "receipt" "capability-id"))
           (%cap1-field '("receipt" "grant-event-id")
                        (record-field fresh "receipt" "grant-event-id"))
           (%cap1-field '("receipt" "subject")
                        (record-field fresh "receipt" "subject"))
           (%cap1-field '("receipt" "action")
                        (record-field fresh "receipt" "action"))
           (%cap1-field '("receipt" "resource")
                        (record-field fresh "receipt" "resource"))
           (%cap1-field '("receipt" "scope")
                        (record-field fresh "receipt" "scope"))
           (%cap1-field '("receipt" "store-id")
                        (lisp-plus-cd0:make-string-datum
                         (%fresh-receipt-string fresh "store-id")))
           (%cap1-field '("receipt" "terminal-ordinal")
                        (lisp-plus-cd0:make-integer-datum
                         (%fresh-receipt-integer fresh "terminal-ordinal")))
           (%cap1-field '("receipt" "valid-byte-count")
                        (lisp-plus-cd0:make-integer-datum
                         (%fresh-receipt-integer fresh "valid-byte-count")))
           (%cap1-field '("receipt" "terminal-digest")
                        (lisp-plus-cd0:make-string-datum
                         (%fresh-receipt-string fresh "terminal-digest")))
           (%cap1-field '("receipt" "scope-procedure")
                        (identifier-from-segments +scope-procedure-segments+))
           (%cap1-field '("receipt" "scope-procedure-version")
                        (lisp-plus-cd0:make-integer-datum
                         +scope-procedure-version+))
           (%cap1-field '("receipt" "procedure-id")
                        (identifier-from-segments +mint-procedure-segments+))
           (%cap1-field '("receipt" "procedure-version")
                        (lisp-plus-cd0:make-integer-datum
                         +mint-procedure-version+)))))
    ;; Law 9 honesty carried through: if the fresh derivation answered over
    ;; a torn-tail prefix, its receipt surfaces the excluded tail; the
    ;; minting receipt repeats that surfacing rather than hiding it.
    (let ((tail-offset (record-field fresh "receipt" "tail-offset"))
          (tail-sha (record-field fresh "receipt" "tail-sha256")))
      (when tail-offset
        (setf entries (append entries
                              (list (%cap1-field '("receipt" "tail-offset")
                                                 tail-offset)))))
      (when tail-sha
        (setf entries (append entries
                              (list (%cap1-field '("receipt" "tail-sha256")
                                                 tail-sha))))))
    (lisp-plus-cd0:make-record-datum entries)))

(defun mint-from-authorization (store bootstrap context authorization-receipt
                                &key minter)
  "The minting bridge: mint an opaque live capability from a truthful /0
authorization receipt.  Returns (values live-capability minting-receipt).

STORE and BOOTSTRAP are handed to /0's present-receipt discipline, whose own
refusals propagate (absent/mismatched bootstrap, interior corruption, STALE
authorization receipt — cap0-stale-receipt naming both prefixes).  CONTEXT
is the explicit minting context that will alone recognize the new object.
MINTER is the identified minter principal (identifier datum or segment
list).  Typed refusals of this bridge itself: cap1-context-missing,
cap1-mint-refused (:not-an-authority-receipt | :receipt-not-authorized |
:fresh-derivation-refused)."
  (%check-context context)
  (let ((minter (ensure-identifier minter :what "minter")))
    ;; CAP-2 step 1a — structural standing: the claim must BE a /0
    ;; authority receipt.
    (unless (and authorization-receipt
                 (lisp-plus-cd0:record-datum-p authorization-receipt)
                 (receipt-decision authorization-receipt))
      (error 'cap1-mint-refused
             :requirement-id "CAP1-MINT-1"
             :basis :not-an-authority-receipt
             :detail "the presented datum is not a Capability /0 authority ~
                      receipt; grant events, minting receipts, and ~
                      arbitrary records authorize nothing"))
    ;; CAP-2 step 1b — the claim must claim AUTHORIZATION.  A truthful
    ;; refusal receipt is testimony against minting, not for it.
    (unless (eq :authorized (receipt-decision authorization-receipt))
      (error 'cap1-mint-refused
             :requirement-id "CAP1-MINT-2"
             :basis :receipt-not-authorized
             :detail (format nil "the presented receipt is a /0 refusal ~
                                  (reason ~a); a refusal cannot authorize ~
                                  minting"
                             (receipt-reason authorization-receipt))))
    ;; CAP-2 step 1c — standing at the PRESENT prefix, by /0's own
    ;; discipline: stale binding signals cap0-stale-receipt; a current
    ;; binding is RE-DERIVED and the FRESH decision is the only one heard.
    (let ((fresh (present-receipt-as-present-authority store bootstrap
                                                       authorization-receipt)))
      (unless (eq :authorized (receipt-decision fresh))
        (error 'cap1-mint-refused
               :requirement-id "CAP1-MINT-3"
               :basis :fresh-derivation-refused
               :fresh-reason (receipt-reason fresh)
               :fresh-receipt fresh
               :detail "the receipt claimed authorization but the fresh /0 ~
                        derivation refused; a receipt's description cannot ~
                        forge a key"))
      ;; CAP-2 steps 2-4 — derive scope (exact copy, identified procedure),
      ;; identify minter (above; delegates: none in this slice), create and
      ;; register the opaque object.  The binding facets are taken from the
      ;; FRESH receipt: /0 guarantees they name exactly the validated
      ;; prefix the authorizing fold examined.
      (let* ((fresh-sha (sha256-hex (encode-pjs0 fresh)))
             (serial (incf (%minting-context-serial context)))
             (serial-string (format nil "~d" serial))
             (occurrence-id (identifier-from-segments
                             (list "cap1-mint" fresh-sha serial-string)))
             (public-id (identifier-from-segments
                         (list "cap1-key" fresh-sha serial-string)))
             (object (%make-live-capability
                      :public-id public-id
                      :occurrence-id occurrence-id
                      :subject (record-field fresh "receipt" "subject")
                      :action (record-field fresh "receipt" "action")
                      :resource (record-field fresh "receipt" "resource")
                      :scope (record-field fresh "receipt" "scope")
                      :minter minter
                      :store-id (%fresh-receipt-string fresh "store-id")
                      :terminal-ordinal (%fresh-receipt-integer
                                         fresh "terminal-ordinal")
                      :valid-byte-count (%fresh-receipt-integer
                                         fresh "valid-byte-count")
                      :terminal-digest (%fresh-receipt-string
                                        fresh "terminal-digest"))))
        (setf (gethash object (%minting-context-recognitions context))
              occurrence-id)
        ;; CAP-2 step 5 — the public minting receipt.
        (values object
                (%make-minting-receipt :fresh fresh
                                       :minter minter
                                       :occurrence-id occurrence-id
                                       :public-id public-id))))))
