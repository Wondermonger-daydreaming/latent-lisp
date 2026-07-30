;;;; object.lisp — the opaque live capability.
;;;;
;;;; §11.2 executed at this slice's scope: the object's authority lives in
;;;; EQ membership of the minting context that created it — a process-local
;;;; fact that no serialized public field carries.  There is no secret
;;;; material anywhere in the object: every slot below is PUBLIC testimony
;;;; (the minting receipt records the same facts), which is exactly why
;;;; copying all of them forges nothing — recognition is membership, not
;;;; description.
;;;;
;;;;   NO PUBLIC CONSTRUCTOR — the constructor %MAKE-LIVE-CAPABILITY is
;;;;   deliberately unexported and the defstruct copier is suppressed.  The
;;;;   mechanism is CL package discipline; its honest limit (named in
;;;;   CAPABILITY-1-RETURN.md): a hostile same-process caller can reach the
;;;;   internal symbol with :: syntax.  The design does not rest there —
;;;;   even an object built through the REAL constructor refuses at
;;;;   presentation, because the context never minted it (the controls
;;;;   exhibit exactly this).  Package discipline stops honest misuse;
;;;;   EQ-recognition stops description-forgery; nothing here claims to
;;;;   stop a hostile same-process attacker with introspection.
;;;;
;;;;   PRINTS AS PUBLIC IDENTITY ONLY — print-object renders an unreadable
;;;;   #<live-capability ...public-id...> form: deterministic, legible,
;;;;   reader-rejected, and containing nothing beyond the public identity
;;;;   (which the minting receipt publishes anyway).
;;;;
;;;;   DEFENSIVE READERS (§11.5) — every exported reader returns a value
;;;;   whose mutation cannot touch live authority: datum slots are re-read
;;;;   through the canonical codec (encode then decode = a fresh isomorphic
;;;;   datum), strings are copied, integers are immutable.  The raw slot
;;;;   readers (%live-capability-*) are internal.
;;;;
;;;;   BOUND TO THE EXACT VALIDATED PREFIX — all four facets (store-id ·
;;;;   terminal ordinal · valid byte count · terminal digest) of the prefix
;;;;   whose fresh /0 derivation authorized the mint.
;;;;
;;;; — CLAVIGER-II (Claude Fable 5 subagent), 2026-07-29

(in-package #:lisp-plus-capability1)

(defstruct (live-capability
            (:constructor %make-live-capability)
            (:copier nil)
            (:conc-name %live-capability-))
  public-id          ; identifier datum — public capability identity
  occurrence-id      ; identifier datum — minting occurrence identity
  subject            ; identifier datum
  action             ; identifier datum
  resource           ; identifier datum
  scope              ; identifier datum
  minter             ; identifier datum — the identified minter principal
  store-id           ; string  — validated-prefix binding, facet 1
  terminal-ordinal   ; integer — facet 2
  valid-byte-count   ; integer — facet 3
  terminal-digest)   ; string  — facet 4

(defmethod print-object ((object live-capability) stream)
  ;; Public identity only; unreadable; no addresses, no binding facets, no
  ;; terms.  The printed form is testimony about WHICH key — never the key.
  (print-unreadable-object (object stream)
    (format stream "live-capability ~a"
            (identifier-segment-string (%live-capability-public-id object)))))

(defun %copy-datum (datum)
  "A defensive copy of a CD/0 datum: re-read through the canonical codec.
The copy is canonically equal (datum=) and structurally fresh; nothing done
to it can reach the original."
  (values (decode-pjs0 (encode-pjs0 datum))))

(macrolet ((define-datum-reader (name slot-reader doc)
             `(defun ,name (object)
                ,doc
                (%copy-datum (,slot-reader object)))))
  (define-datum-reader live-capability-public-id %live-capability-public-id
    "The capability's PUBLIC identity (identifier datum, defensive copy).
Identity is a name, not authority: recognition never consults it.")
  (define-datum-reader live-capability-occurrence-id
      %live-capability-occurrence-id
    "The minting occurrence identity (identifier datum, defensive copy).")
  (define-datum-reader live-capability-subject %live-capability-subject
    "The exact minted subject (identifier datum, defensive copy; §11.5).")
  (define-datum-reader live-capability-action %live-capability-action
    "The exact minted action (identifier datum, defensive copy; §11.5).")
  (define-datum-reader live-capability-resource %live-capability-resource
    "The exact minted resource (identifier datum, defensive copy; §11.5).")
  (define-datum-reader live-capability-scope %live-capability-scope
    "The exact minted scope (identifier datum, defensive copy; §11.5).")
  (define-datum-reader live-capability-minter %live-capability-minter
    "The identified minter principal (identifier datum, defensive copy)."))

(defun live-capability-store-id (object)
  "Binding facet 1: the store identity string (defensive copy)."
  (copy-seq (%live-capability-store-id object)))

(defun live-capability-terminal-ordinal (object)
  "Binding facet 2: the validated terminal ordinal (integer, immutable)."
  (%live-capability-terminal-ordinal object))

(defun live-capability-valid-byte-count (object)
  "Binding facet 3: the validated byte count (integer, immutable)."
  (%live-capability-valid-byte-count object))

(defun live-capability-terminal-digest (object)
  "Binding facet 4: the terminal digest string (defensive copy)."
  (copy-seq (%live-capability-terminal-digest object)))
