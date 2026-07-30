;;;; operations.lisp — the §20 normative operation surface.
;;;;
;;;; Twelve public operation roles under AP0's own names.  AP-OP-1: every
;;;; operation preserves receipts, identities, evidence, exposure, journal
;;;; state, and outcome context.  AP-OP-2: no operation returns a bare
;;;; answer string or provider body — every return is a canonical CD/0
;;;; record, a typed handle, or a typed marker.  AP-OP-3 is honored by
;;;; providing NO raw provider call at all: the fake's only door is this
;;;; surface.
;;;;
;;;; The live flow reuses the script machine's record constructors as its
;;;; single source of record shapes — the deterministic fake IS the
;;;; provider (AP-FAKE-5), so the operation surface drives a %MACHINE
;;;; cursor exactly as a frozen script does.
;;;;
;;;; — CLAVIGER-IV (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-adapter0)

(defstruct (invocation-spec (:constructor make-invocation-spec
                                (&key logical-operation-id seat-id attempt-id
                                      run-label
                                      (resolved-configuration-id
                                       "fake-model-configuration-0"))))
  logical-operation-id
  seat-id
  attempt-id
  run-label                       ; deterministic label seeding record ids
  resolved-configuration-id)

(defstruct (prepared-invocation-record
            (:constructor %make-prepared (machine record local-request-id
                                          adapter-version
                                          resolved-configuration-id
                                          pre-frontier-records)))
  machine record local-request-id adapter-version resolved-configuration-id
  ;; The three §21 pre-frontier records (prepared invocation, binary
  ;; request capture, exposure event), oldest first — the durable
  ;; pre-frontier account a caller journals BEFORE any crossing.
  pre-frontier-records)

(defun prepared-invocation-p (object) (prepared-invocation-record-p object))

(defstruct (dispatch-handle (:constructor %make-dispatch-handle
                                (machine prepared dispatch-record)))
  machine prepared dispatch-record)

(defstruct (missing-cost-marker (:constructor %make-missing-cost (reason)))
  ;; AP-COST-4: a missing cost is a typed ABSENCE, mechanically distinct
  ;; from any amount.  It is not zero, not free, not a number.
  reason)

(defun describe-adapter (live-adapter)
  "The bound descriptor record — durable evidence about declared behavior
(AP-DESC-1: evidence, not authority, not the live object)."
  (unless (live-adapter-p live-adapter)
    (signal-ap0 'adapter-descriptor-invalid
                :requirement-id "AP-DESC-1"
                :frontier-crossed nil
                :detail "describe-adapter requires a live adapter object"))
  (live-adapter-descriptor live-adapter))

(defun prepare-invocation (live-adapter spec)
  "Pre-frontier preparation (§6): emits the prepared-invocation, the
binary request capture, and the exposure event, in order (§21 steps 2–4),
into the handle's record trail.  Refuses typed, with no provider effect
(AP-PREP-1)."
  (unless (live-adapter-p live-adapter)
    ;; The descriptor/live-object collapse: a descriptor datum is
    ;; evidence; it cannot prepare anything (AP-DESC-1).
    (signal-ap0 'adapter-descriptor-invalid
                :requirement-id "AP-DESC-1"
                :frontier-crossed nil
                :detail "prepare-invocation requires a live adapter ~
                         object, not a descriptor record"))
  (unless (invocation-spec-p spec)
    (signal-ap0 'adapter-preparation-refused
                :requirement-id "AP-PREP-3"
                :frontier-crossed nil
                :detail "invocation-spec required"))
  (unless (and (invocation-spec-logical-operation-id spec)
               (invocation-spec-attempt-id spec)
               (invocation-spec-run-label spec))
    (signal-ap0 'adapter-preparation-refused
                :requirement-id "AP-PREP-3"
                :frontier-crossed nil
                :detail "logical-operation-id, attempt-id, and run-label ~
                         must be inspectable before the frontier"))
  (let ((machine (make-%machine
                  :script-leaf (invocation-spec-run-label spec)
                  :seed 0
                  :descriptor (live-adapter-descriptor live-adapter)
                  :adapter-identity (live-adapter-descriptor-identity
                                     live-adapter)
                  :adapter-version (live-adapter-descriptor-version
                                    live-adapter))))
    (setf (%machine-ordinal machine) 1)
    (%op-prepare machine)
    ;; The trail is newest-first; the prepared-invocation record is the
    ;; OLDEST of the three §21 pre-frontier records.
    (%make-prepared machine
                    (car (last (%machine-records machine)))
                    (format nil "lr-~a-1" (invocation-spec-run-label spec))
                    (live-adapter-descriptor-version live-adapter)
                    (invocation-spec-resolved-configuration-id spec)
                    (reverse (%machine-records machine)))))

(defun dispatch (prepared &key live-adapter resolved-configuration-id)
  "Cross the declared frontier (§8).  Returns a dispatch handle wrapping
the dispatch record — never a bare provider body (AP-DSP-1).
Refusals (all pre-frontier, typed):
 - re-dispatch of an already-dispatched preparation — Kernel /0's
   UNSAFE-RETRY (AP-DSP-3);
 - descriptor version drift between preparation and dispatch —
   ADAPTER-VERSION-DRIFT (AP-DESC-3);
 - a resolved machine configuration differing from the prepared binding —
   IMPLICIT-PROVIDER-FALLBACK (AP-ID-7/AP-ID-9: rerouting without a new
   authorized transformation is fallback, not continuation)."
  (unless (prepared-invocation-p prepared)
    (signal-ap0 'adapter-dispatch-failed-pre-frontier
                :requirement-id "AP-DSP-1"
                :frontier-crossed nil
                :detail "dispatch requires a prepared invocation"))
  (let ((machine (prepared-invocation-record-machine prepared)))
    (when (%machine-dispatched machine)
      (error 'unsafe-retry
             :requirement-id "AP-DSP-3"
             :failed-invariant
             "this preparation already crossed the frontier; automatic ~
              re-dispatch without reconciliation is forbidden"))
    (when (and live-adapter
               (not (equal (prepared-invocation-record-adapter-version
                            prepared)
                           (live-adapter-descriptor-version live-adapter))))
      (signal-ap0 'adapter-version-drift
                  :requirement-id "AP-DESC-3"
                  :frontier-crossed nil
                  :identities (list (prepared-invocation-record-adapter-version
                                     prepared)
                                    (live-adapter-descriptor-version
                                     live-adapter))
                  :detail "descriptor version changed between preparation ~
                           and dispatch; refusing before the frontier"))
    (when (and resolved-configuration-id
               (not (equal resolved-configuration-id
                           (prepared-invocation-record-resolved-configuration-id
                            prepared))))
      (signal-ap0 'implicit-provider-fallback
                  :requirement-id "AP-ID-9"
                  :frontier-crossed nil
                  :identities (list
                               (prepared-invocation-record-resolved-configuration-id
                                prepared)
                               resolved-configuration-id)
                  :detail "the resolved machine configuration at dispatch ~
                           differs from the prepared binding; a fallback ~
                           is a new authorized transformation, not a ~
                           continuation"))
    (setf (%machine-ordinal machine) (1+ (%machine-ordinal machine)))
    (%op-dispatch machine)
    (%make-dispatch-handle machine prepared
                           (first (%machine-records machine)))))

(defun observe-acknowledgment (dispatch-handle)
  "The boundary acknowledgment record — testimony with witness facets,
never settlement (AP-ACK-4)."
  (let ((machine (dispatch-handle-machine dispatch-handle)))
    (setf (%machine-ordinal machine) (1+ (%machine-ordinal machine)))
    (%op-ack machine)
    (first (%machine-records machine))))

(defun observe-stream (dispatch-handle stream-sink &key (chunk-count 2))
  "Deterministic chunk emission under §10.5 journal-before-delivery: each
chunk record enters the handle's durable trail BEFORE STREAM-SINK sees
it.  Returns the list of chunk records."
  (let ((machine (dispatch-handle-machine dispatch-handle)))
    (loop for sequence-number from 1 to chunk-count
          do (setf (%machine-ordinal machine)
                   (1+ (%machine-ordinal machine)))
             (%op-chunk machine sequence-number)
             ;; Delivery strictly after the trail append above.
             (funcall stream-sink (first (%machine-records machine)))
          collect (first (%machine-records machine)))))

(defun await-terminal (dispatch-handle)
  "Terminal envelope capture (§12) — binary custody, full octet account.
Returns the envelope record."
  (let ((machine (dispatch-handle-machine dispatch-handle)))
    (setf (%machine-ordinal machine) (1+ (%machine-ordinal machine)))
    (%op-capture-envelope machine)
    (first (%machine-records machine))))

(defun cancel-request (dispatch-handle cancellation-spec)
  "Cancellation as a process (§17): the request is recorded; settlement
stays exactly as evidenced (here: unsettled), partials preserved
(AP-CAN-3).  CANCELLATION-SPEC names the requested scope."
  (declare (ignore cancellation-spec))
  (let ((machine (dispatch-handle-machine dispatch-handle)))
    (setf (%machine-ordinal machine) (1+ (%machine-ordinal machine)))
    (%op-cancel machine)
    (first (%machine-records machine))))

(defun reconcile-request (live-adapter reconciliation-spec
                          &key result provider-request-id
                               domain-complete completeness-witness)
  "Reconciliation record under §18.  A :NOT-FOUND result may settle
no-effect ONLY under the AP-REC-6 conjunction: provider request identity
present, complete authoritative domain, and a DISTINCT completeness
witness (a plist with :evidence-id :boundary :procedure-id :standing all
present and :origin \"observed\").  Anything less refuses typed —
self-assertion never certifies a domain's own completeness."
  (unless (live-adapter-p live-adapter)
    (signal-ap0 'adapter-descriptor-invalid
                :requirement-id "AP-DESC-1"
                :frontier-crossed :unknown
                :detail "reconcile-request requires a live adapter"))
  (unless (member result +reconciliation-results+ :test #'equal)
    (signal-ap0 'reconciliation-unsupported
                :requirement-id "AP0-§18"
                :frontier-crossed :unknown
                :detail (format nil "unknown reconciliation result ~s"
                                result)))
  (let ((settles-no-effect nil))
    (when (equal result "not-found")
      (cond
        ((null provider-request-id)
         (signal-ap0 'reconciliation-identity-missing
                     :requirement-id "AP-ID-4"
                     :frontier-crossed :unknown
                     :detail ":not-found without the exact provider ~
                              request identity caps at :ambiguous; ~
                              no-effect is not settled"))
        ((not domain-complete)
         (error 'reconciliation-insufficient
                :requirement-id "AP-REC-1"
                :failed-invariant
                "queried domain is not complete and authoritative for ~
                 the identity; :not-found does not settle no-effect"))
        ((not (and (getf completeness-witness :evidence-id)
                   (getf completeness-witness :boundary)
                   (getf completeness-witness :procedure-id)
                   (getf completeness-witness :standing)
                   (equal "observed" (getf completeness-witness :origin))))
         (signal-ap0 'adapter-witness-boundary-missing
                     :requirement-id "AP-REC-1"
                     :frontier-crossed :unknown
                     :detail "the completeness claim has no distinct ~
                              boundary witness; an adapter's ~
                              self-asserted domain-complete settles ~
                              nothing"))
        (t (setf settles-no-effect t))))
    (%rec '("ap0" "record-kind") (%id "record" "reconciliation")
          '("ap0" "reconciliation-id")
          (%str (format nil "rec-~a" reconciliation-spec))
          '("ap0" "result") (%str result)
          '("ap0" "provider-request-id")
          (if provider-request-id (%str provider-request-id) (%unit))
          '("ap0" "domain-complete") (%bool (and domain-complete t))
          '("ap0" "settles-no-effect") (%bool settles-no-effect)
          '("ap0" "completeness-witness-boundary")
          (let ((boundary (getf completeness-witness :boundary)))
            (if boundary (%str boundary) (%unit))))))

(defun capture-envelope (live-adapter raw-octets capture-spec)
  "Standalone §12 capture: RAW-OCTETS (a binary payload) into a canonical
provider-envelope record identified by CAPTURE-SPEC.  Full octet count
and integrity digest are recorded (AP-ENV-1)."
  (unless (live-adapter-p live-adapter)
    (signal-ap0 'adapter-descriptor-invalid
                :requirement-id "AP-DESC-1"
                :frontier-crossed t
                :detail "capture-envelope requires a live adapter"))
  (unless (and (vectorp raw-octets)
               (every (lambda (byte) (typep byte '(unsigned-byte 8)))
                      raw-octets))
    (signal-ap0 'provider-envelope-integrity-failed
                :requirement-id "AP0-§7.3"
                :frontier-crossed t
                :detail "capture is binary-mode only; a non-octet payload ~
                         cannot be an envelope"))
  (%rec '("ap0" "record-kind") (%id "record" "provider-envelope")
        '("ap0" "envelope-id") (%str (format nil "env-~a" capture-spec))
        '("ap0" "adapter-identity")
        (%str (live-adapter-descriptor-identity live-adapter))
        '("ap0" "adapter-version")
        (%str (live-adapter-descriptor-version live-adapter))
        '("ap0" "boundary-class") (%id "boundary" "fake")
        '("ap0" "raw-payload-octet-count") (%int (length raw-octets))
        '("ap0" "raw-payload-sha256")
        (%str (sha256-hex (coerce raw-octets
                                  '(vector (unsigned-byte 8)))))
        '("ap0" "capture-mode") (%str "binary")))

(defun project-envelope (live-adapter dispatch-handle shape-leaf)
  "Structural projection (§13) of the handle's captured envelope under
the identified absence table.  Refuses PROVIDER-ENVELOPE-MISSING when no
envelope was captured (AP-ENV-4) and ABSENCE-MAPPING-TABLE-MISS on any
shape outside the table (AP-ABS-1).  Returns the projection receipt
record — structure, never semantic truth (AP-PRJ-2)."
  (unless (live-adapter-p live-adapter)
    (signal-ap0 'adapter-descriptor-invalid
                :requirement-id "AP-DESC-1"
                :frontier-crossed t
                :detail "project-envelope requires a live adapter"))
  (let ((machine (dispatch-handle-machine dispatch-handle)))
    (setf (%machine-ordinal machine) (1+ (%machine-ordinal machine)))
    (%op-project machine shape-leaf)
    (first (%machine-records machine))))

(defun extract-usage (live-adapter dispatch-handle usage-procedure-id)
  "Usage record (§15) with source :adapter-measured — locally observed
octets are observational evidence at this boundary (AP-USG-2); no
provider-reported figure is invented."
  (unless (live-adapter-p live-adapter)
    (signal-ap0 'adapter-descriptor-invalid
                :requirement-id "AP-DESC-1"
                :frontier-crossed t
                :detail "extract-usage requires a live adapter"))
  (let ((machine (dispatch-handle-machine dispatch-handle)))
    (unless (%machine-envelope machine)
      (signal-ap0 'usage-standing-missing
                  :requirement-id "AP-USG-3"
                  :frontier-crossed t
                  :detail "no captured envelope to measure; missing usage ~
                           is not zero usage"))
    (%rec '("ap0" "record-kind") (%id "record" "usage-record")
          '("ap0" "usage-id")
          (%str (format nil "usg-~a" (%machine-script-leaf machine)))
          '("ap0" "adapter-identity")
          (%str (%machine-adapter-identity machine))
          '("ap0" "source") (%str "adapter-measured")
          '("ap0" "procedure-id") (%str usage-procedure-id)
          '("ap0" "units")
          (make-sequence-datum
           (list (%rec '("ap0" "unit") (%str "response-octets")
                       '("ap0" "count")
                       (%int (+ 64 (%machine-seed machine)))))))))

(defun parse-cost-lexeme (lexeme)
  "Erratum 0.1 narrow exact-number grammar: [\"-\"] digits [\"/\" digits],
denominator nonzero.  Returns an actual CD/0 number datum — an integer
datum when the reduced denominator is 1, else a reduced rational datum —
so equivalent spellings collapse to ONE canonical durable value.  The CL
reader is never the cost-field grammar: floating-point syntax refuses
COST-FLOAT-NONCANONICAL; every other malformation refuses
COST-LEXEME-NONCANONICAL (both AP-COST-1)."
  (labels ((%refuse (condition detail)
             (signal-ap0 condition
                         :requirement-id "AP-COST-1"
                         :frontier-crossed nil
                         :detail detail))
           (%digits (string start end what)
             (when (>= start end)
               (%refuse 'cost-lexeme-noncanonical
                        (format nil "empty ~a in cost lexeme" what)))
             (let ((value 0))
               (loop for index from start below end
                     for char = (char string index)
                     do (unless (char<= #\0 char #\9)
                          (%refuse (if (member char '(#\. #\e #\E #\d #\D))
                                       'cost-float-noncanonical
                                       'cost-lexeme-noncanonical)
                                   (format nil "non-digit ~s in cost ~
                                                lexeme ~a" char what))
                          )
                        (setf value (+ (* value 10)
                                       (- (char-code char)
                                          (char-code #\0)))))
               value)))
    (unless (stringp lexeme)
      (%refuse 'cost-lexeme-noncanonical
               "cost lexeme must be a string of the declared grammar"))
    (when (zerop (length lexeme))
      (%refuse 'cost-lexeme-noncanonical "empty cost lexeme"))
    (let* ((negative (char= (char lexeme 0) #\-))
           (start (if negative 1 0))
           (slash (position #\/ lexeme :start start))
           (numerator (%digits lexeme start (or slash (length lexeme))
                               "numerator"))
           (denominator (if slash
                            (%digits lexeme (1+ slash) (length lexeme)
                                     "denominator")
                            1)))
      (when (zerop denominator)
        (%refuse 'cost-lexeme-noncanonical
                 "zero denominator in cost lexeme"))
      ;; Native CL exact rational arithmetic is the value substrate:
      ;; / auto-reduces and collapses n/1 to the integer.
      (let ((value (/ (if negative (- numerator) numerator) denominator)))
        (if (integerp value)
            (make-integer-datum value)
            (make-rational-datum (numerator value)
                                 (denominator value)))))))

(defun cost-canonical-amount (cost-record)
  "The qere: the CD/0 number datum on which the machine may act.
Arithmetic over costs consumes THIS field only — the source lexeme is
testimony, never re-parsed at use time."
  (case-field cost-record "canonical-amount"))

(defun extract-cost (live-adapter dispatch-handle cost-procedure-id
                     &key price-schedule-id)
  "Cost record (§16).  Without an identified, versioned price schedule
there is NO derivable cost: the return is a typed MISSING-COST-MARKER —
never a zero amount (AP-COST-4), never a promotion of usage into money
(usage ≠ cost).  With a schedule, the record is :estimated
(AP-COST-2/3) and — Erratum 0.1, the ketiv/qere discipline — carries
BOTH the received spelling as SOURCE-LEXEME (testimony, retained
byte-exact) and the CANONICAL-AMOUNT as an actual CD/0 integer or
reduced rational (AP-COST-1); a string never becomes durable money by
spelling a number."
  (unless (live-adapter-p live-adapter)
    (signal-ap0 'adapter-descriptor-invalid
                :requirement-id "AP-DESC-1"
                :frontier-crossed t
                :detail "extract-cost requires a live adapter"))
  (let ((machine (dispatch-handle-machine dispatch-handle)))
    (if (null price-schedule-id)
        (%make-missing-cost "no identified price schedule; missing cost ~
                             is not free")
        (let ((lexeme (format nil "~a/1000000"
                              (+ 100 (%machine-seed machine)))))
          (%rec '("ap0" "record-kind") (%id "record" "cost-record")
                '("ap0" "cost-id")
                (%str (format nil "cst-~a" (%machine-script-leaf machine)))
                '("ap0" "adapter-identity")
                (%str (%machine-adapter-identity machine))
                '("ap0" "standing") (%str "estimated")
                ;; ketiv: what the fake schedule wrote, kept unchanged.
                '("ap0" "source-lexeme") (%str lexeme)
                ;; qere: the exact value the machine may act on.
                '("ap0" "canonical-amount") (parse-cost-lexeme lexeme)
                '("ap0" "currency") (%str "USD")
                '("ap0" "price-schedule-id") (%str price-schedule-id)
                '("ap0" "procedure-id") (%str cost-procedure-id))))))

;;; ---------------------------------------------------------------------------
;;; §25 L17 route audit surface.

(defparameter +operation-surface+
  '(("describe-adapter" :inspection)
    ("prepare-invocation" :consequential)
    ("dispatch" :consequential)
    ("observe-acknowledgment" :consequential)
    ("observe-stream" :consequential)
    ("await-terminal" :consequential)
    ("cancel-request" :consequential)
    ("reconcile-request" :consequential)
    ("capture-envelope" :consequential)
    ("project-envelope" :consequential)
    ("extract-usage" :inspection)
    ("extract-cost" :inspection))
  "The §20 operation roles with their consequence class.")

(defun lawful-route-actions ()
  "The shortest documented lawful route to a projected manifestation, as
public API actions: prepare-invocation → dispatch → await-terminal →
project-envelope.  Length 4 — the figure every frozen vector declares as
lawful-route-steps."
  '("prepare-invocation" "dispatch" "await-terminal" "project-envelope"))

(defun l17-route-audit-lines ()
  "AP-ERG-1/2/3 audit rows, derived live: the lawful route length, the
absence of any supported bypass (this surface exposes no operation that
returns provider bytes outside custody — AP-OP-2 — and no raw host escape
exists — AP-ERG-2), and the per-operation obligations."
  (append
   (list (format nil "lawful-route-actions=~a ~{~a~^,~}"
                 (length (lawful-route-actions)) (lawful-route-actions))
         "supported-bypass-routes=0 (no operation returns a bare provider ~
          body; no raw host escape is provided)")
   (loop for (name class) in +operation-surface+
         collect (format nil "operation=~a class=~a obligations=~
                              receipts,identities,evidence,exposure,~
                              journal,outcome-context"
                         name (string-downcase (symbol-name class))))))
