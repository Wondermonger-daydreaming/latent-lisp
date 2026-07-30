;;;; authorize.lisp — authorization to attempt: the §11.4 NAMED SUBSET.
;;;;
;;;; AUTHORIZE-EFFECT-ATTEMPT answers exactly one question: "may THIS
;;;; recognized, current capability justify attempting THIS one exact
;;;; protected effect, into THIS seat, under THIS attempt identity — at the
;;;; present validated prefix?"  It produces an authorization-to-attempt
;;;; receipt — truthful, prefix-bound testimony that licenses ONE attempt
;;;; identity and proves nothing about any effect (law 2: the receipt
;;;; exists before any dispatch; nothing is acknowledged, nothing written).
;;;;
;;;; THE §11.4 SUBSET, named bullet by bullet (the reserved verb
;;;; check-capability is NOT claimed, because claiming it would imply the
;;;; full check):
;;;;   IMPLEMENTED:
;;;;     • capability is live ..... fresh presentation (recognition + exact
;;;;       terms + FRESH journal validation + four-facet prefix binding),
;;;;       through capability1's exported PRESENT-LIVE-CAPABILITY;
;;;;     • capability is unrevoked ..... a FRESH /0 fold at the current
;;;;       prefix (QUERY-LIVE-AUTHORITY); a refusal names the fold's
;;;;       reason and evidence (e.g. the revoking event) —
;;;;       CAP2-ATTEMPT-AUTHORIZATION-REFUSED;
;;;;     • requested effect is authorized ..... the requested cell must BE
;;;;       the capability's resource, exact canonical equality
;;;;       (CAP2-EFFECT-NOT-AUTHORIZED otherwise);
;;;;     • requested scope is within capability scope ..... exact equality
;;;;       of the presented terms (presentation's own discipline; no scope
;;;;       predicate language exists in this slice — named divergence);
;;;;     • unresolved-effect restrictions are satisfied ..... the journal
;;;;       is folded for open uncertain effects on the seat
;;;;       (CHECK-RETRY-SAFETY-FROM-STORE -> kernel /0's UNSAFE-RETRY), and
;;;;       the attempt identity is checked against the prefix
;;;;       (DUPLICATE-ATTEMPT-IDENTITY).
;;;;   NOT IMPLEMENTED (named divergence; refusing to fake them is the
;;;;   honesty): expiry, budget and count limits, principal roles.
;;;;
;;;; ORDER (§10.4 R-SYN-3, adjudicated): 1. resolve identities; 2.
;;;; revocation standing FIRST (the fresh /0 fold — so a committed
;;;; revocation is refused BY NAME), then object liveness (presentation —
;;;; so a mere advance refuses as staleness); 3. effect authorization
;;;; against resolved terms; 4. attempt legality and unresolved predecessor
;;;; effects.  Every refusal is typed, pre-frontier, external-effect
;;;; :NOT-ENTERED; no refusal journals or writes anything.
;;;;
;;;; The receipt is NEVER journaled (house adjudication, /0 L9 and /1 §2.10
;;;; carried forward: receipts are derived state over a validated prefix).
;;;;
;;;; — CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-capability2)

(defvar +authorize-procedure-segments+ '("lisp-plus-capability2"
                                         "authorize-effect-attempt"))
(defvar +authorize-procedure-version+ 0)

(defun %make-authorization-receipt (&key presentation capability attempt-name
                                         seat-name cell value)
  "The authorization-to-attempt receipt: canonical CD/0 record binding the
capability's public identity, the exact effect declaration (§10.1/§10.2:
kind, class, cell, value), the licensed attempt/seat/idempotency
identities, the validated prefix (all four facets, from the FRESH
presentation receipt), and the identified procedure."
  (%cap2-record
   (%cap2-field '("receipt" "kind")
                (identifier-from-segments
                 '("cap2" "authorization-to-attempt")))
   (%cap2-field '("receipt" "capability-public-id")
                (live-capability-public-id capability))
   (%cap2-field '("receipt" "occurrence-id")
                (live-capability-occurrence-id capability))
   (%cap2-field '("receipt" "subject") (live-capability-subject capability))
   (%cap2-field '("receipt" "action") (live-capability-action capability))
   (%cap2-field '("receipt" "resource")
                (live-capability-resource capability))
   (%cap2-field '("receipt" "scope") (live-capability-scope capability))
   (%cap2-field '("receipt" "effect-kind")
                (identifier-from-segments +effect-kind-segments+))
   (%cap2-field '("receipt" "effect-class")
                (identifier-from-segments +effect-class-segments+))
   (%cap2-field '("receipt" "cell") cell)
   (%cap2-field '("receipt" "value")
                (lisp-plus-cd0:make-string-datum value))
   (%cap2-field '("receipt" "attempt-id")
                (%attempt-identifier attempt-name))
   (%cap2-field '("receipt" "seat-id") (%seat-identifier seat-name))
   (%cap2-field '("receipt" "idempotency-id")
                (identifier-from-segments
                 (list "idempotency" "cap2" attempt-name)))
   (%cap2-field '("receipt" "store-id")
                (record-field presentation "receipt" "store-id"))
   (%cap2-field '("receipt" "terminal-ordinal")
                (record-field presentation "receipt" "terminal-ordinal"))
   (%cap2-field '("receipt" "valid-byte-count")
                (record-field presentation "receipt" "valid-byte-count"))
   (%cap2-field '("receipt" "terminal-digest")
                (record-field presentation "receipt" "terminal-digest"))
   (%cap2-field '("receipt" "procedure-id")
                (identifier-from-segments +authorize-procedure-segments+))
   (%cap2-field '("receipt" "procedure-version")
                (lisp-plus-cd0:make-integer-datum
                 +authorize-procedure-version+))))

(defun authorize-effect-attempt (store bootstrap context capability
                                 &key capability-id query-name
                                      subject action resource scope
                                      cell value attempt-name seat-name
                                      defect)
  "Authorize ONE exact effect attempt.  Returns the authorization-to-attempt
receipt (canonical CD/0 record; never journaled).  CAPABILITY-ID and
QUERY-NAME parameterize the fresh /0 fold; SUBJECT/ACTION/RESOURCE/SCOPE
are the exact presentation terms; CELL (identifier datum or segments) and
VALUE (string) declare the one exact protected effect; ATTEMPT-NAME and
SEAT-NAME are the declared attempt and seat identities this authorization
licenses.  Typed refusals only; every refusal is pre-frontier
(:NOT-ENTERED) and leaves journal, world, and receipt space untouched."
  (let ((cell (ensure-identifier cell :what "cell"))
        (subject (ensure-identifier subject :what "subject"))
        (action (ensure-identifier action :what "action"))
        (resource (ensure-identifier resource :what "resource"))
        (scope (ensure-identifier scope :what "scope")))
    (unless (stringp value)
      (error 'cap2-authorization-missing
             :requirement-id "CAP2-AUTH-0"
             :presented-type (type-of value)
             :detail "the declared effect value must be a string; an ~
                      effect that cannot be stated exactly cannot be ~
                      authorized exactly"))
    ;; §11.4 "unrevoked" — the FRESH /0 fold at the current prefix, first,
    ;; so a committed revocation refuses BY NAME (fold reason + evidence).
    (let ((fresh (query-live-authority store bootstrap
                                       :query-id (list "cap0-query"
                                                       query-name)
                                       :capability-id capability-id
                                       :subject subject
                                       :action action
                                       :resource resource
                                       :scope scope)))
      (unless (eq :authorized (receipt-decision fresh))
        (error 'cap2-attempt-authorization-refused
               :requirement-id "CAP2-AUTH-1"
               :basis :fresh-derivation-refused
               :fresh-reason (receipt-reason fresh)
               :fresh-receipt fresh
               :detail "the fresh /0 derivation at the current validated ~
                        prefix refused the capability's terms; no attempt ~
                        may be authorized over a refused fold")))
    ;; §11.4 "live" — fresh presentation: recognition, exact terms, FRESH
    ;; journal validation, four-facet prefix binding.  cap1's refusals
    ;; propagate unwrapped (cap1-unrecognized-object, cap1-term-mismatch,
    ;; cap1-stale-capability, kernel0:journal-prefix-invalid).
    (let ((presentation
            (present-live-capability store bootstrap context capability
                                     :subject subject :action action
                                     :resource resource :scope scope
                                     :presentation-id
                                     (list "cap2-present"
                                           (format nil "authorize-~a"
                                                   attempt-name)))))
      ;; §11.4 "requested effect is authorized" — the requested cell must
      ;; BE the capability's resource, exact canonical equality.
      (unless (datum= cell (live-capability-resource capability))
        (error 'cap2-effect-not-authorized
               :requirement-id "CAP2-AUTH-2"
               :requested-cell (identifier-segment-string cell)
               :authorized-cell (identifier-segment-string
                                 (live-capability-resource capability))
               :detail "the requested effect targets a cell the ~
                        capability's exact terms do not authorize"))
      ;; §11.4 "unresolved-effect restrictions" — attempt legality first
      ;; (:408 duplicate identity, pre-frontier), then the seat fold
      ;; (kernel /0's UNSAFE-RETRY through the rehydration).
      (when (%attempt-identity-taken-p store attempt-name)
        (signal-kernel0
         'duplicate-attempt-identity
         :attempt-id (make-identity :attempt (format nil "attempt:~a"
                                                     attempt-name))
         :requirement-id "CAP2-AUTH-3"
         :failed-invariant
         "§6.6 and :408: the validated prefix already binds this attempt ~
          identity; a duplicate attempt identity refuses BEFORE any ~
          frontier"))
      ;; DEFECT is a planted test seam (mutants.lisp), production NIL:
      ;; :AUTO-RETRY-ON-UNCERTAIN swallows the gate's refusal and
      ;; authorizes anyway — the exact §14.1 violation, kept to be killed;
      ;; :STORED-RESOLVED-FLAG is answered inside the gate itself.
      (if (eq defect :auto-retry-on-uncertain)
          (handler-case
              (check-retry-safety-from-store
               store :seat-name seat-name
               :candidate-attempt-name attempt-name)
            (lisp-plus-kernel0:unsafe-retry () t))
          (check-retry-safety-from-store
           store :seat-name seat-name
           :candidate-attempt-name attempt-name
           :defect defect))
      (%make-authorization-receipt :presentation presentation
                                   :capability capability
                                   :attempt-name attempt-name
                                   :seat-name seat-name
                                   :cell cell
                                   :value value))))
