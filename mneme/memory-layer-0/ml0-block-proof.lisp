;;;; ml0-block-proof.lisp — THE TWO BLOCKERS, SHOWN TO BLEED AND SHOWN TO CLOSE.
;;;;
;;;;   sbcl --script mneme/memory-layer-0/ml0-block-proof.lisp
;;;;
;;;; Sentinel: ml0-block-proof: N probes, N closed, 0 open
;;;;
;;;; ⚑ THIS FILE WAS WRITTEN BEFORE THE REPAIR, AND ITS FIRST RUN FAILED ON
;;;; PURPOSE.  The chair's disposition of 2026-08-20 BLOCKED candidate
;;;; `a492a05f…` on two findings, and the first duty of a repair is to make the
;;;; findings REPRODUCIBLE against the unrepaired code — not to describe them.
;;;; `RED-BLOCK-BEFORE.txt` is that run, captured against the blocked build, exit
;;;; walked.  `RED-BLOCK-AFTER.txt` is the same file against the repair.
;;;;
;;;; THE THREE PROBES, one sentence each:
;;;;
;;;;   B1a  A PUBLIC caller forges a `:world-bytes` source row over an act that
;;;;        lawfully REFUSED before the frontier — correct act identity, :looked
;;;;        scope, positive attestation, arbitrary coordinate, arbitrary 64-hex
;;;;        digest, nonempty provenance — and asks for an account.  The blocked
;;;;        build answers :OCCURRED for an act three independent instruments say
;;;;        never happened.
;;;;
;;;;   B1b  A bundle CLAIMS `:issued-in-writing-image` with no evidence object
;;;;        anywhere in the process and no current-image predicate ever consulted.
;;;;        The blocked build copies the caller's keyword into the durable bytes.
;;;;
;;;;   B2   Two source rows equal in species, payload digest and producer
;;;;        principal, but differing in coordinate, recorder, scope, interval,
;;;;        frontier relation and attestation, are consolidated.  The blocked
;;;;        build's deduplicator collapses them to one — and the shipped comment
;;;;        beside it calls its own three-field test "THE SAME READING OF THE SAME
;;;;        BYTES BY THE SAME MECHANISM", which it is not.
;;;;
;;;; ⚠ AND A POSITIVE CONTROL, so the repair cannot be a wall: a LAWFUL
;;;; production observation door over a genuinely occurred act must still reach
;;;; :OCCURRED.  A build that refused everything would close all three probes and
;;;; be useless; probe P is what tells those two apart.
;;;;
;;;; ═══════════════════════════════════════════════════════════════════════════
;;;; R4 — THE CODEX ADVERSARIAL AUDIT'S FIVE FINDINGS (2026-08-20)
;;;; ═══════════════════════════════════════════════════════════════════════════
;;;;
;;;; Eight more arms, and the same discipline: written and RUN AGAINST THE
;;;; UNREPAIRED R3 BUILD FIRST (`RED-CODEX-BEFORE.txt`, 19 probes, 8 OPEN, exit 1,
;;;; captured at commit e3c3fb5c before any repair code existed), then repaired
;;;; (`RED-CODEX-AFTER.txt`, exit 0).
;;;;
;;;;   F1   NO EXTERNAL FUNCTION of this lane carries a `defect` parameter —
;;;;        walked over every external fbound symbol's COMPILED LAMBDA LIST via
;;;;        `sb-introspect`, in an image loaded through the canonical `load.lisp`.
;;;;        The R3 build had TEN.
;;;;   F1b  and the crown predicate no longer flips: the keyword route is GONE,
;;;;        not merely unused.
;;;;   F2   a RAW decode of a caller-held frame may not read `:occurred` off the
;;;;        bytes; the standing is re-derived from rows that warrant nothing.
;;;;   F2b  a frame whose event-id is not this lane's shape is REFUSED — RB-11 no
;;;;        longer SKIPS when it has nothing to compare.
;;;;   F3   a caller may not assert a record-coverage finding about this lane's
;;;;        own store; F3b, a production DOOR actually scans it.
;;;;   F4   `ml0-write` does not claim whole-store non-mutation on failure, and
;;;;        DOES name its verified-after-append semantics.  ⚑ THE PROSE IS CHECKED
;;;;        BY CODE, because prose is exactly what was wrong.
;;;;   F5   an effect observation is marked CALLER-ASSERTED in the type AND in the
;;;;        durable bytes.
;;;;   F1c  ⚠ AND THE DISEASE CONTROL FOR F1, WHICH RUNS LAST: the overlay is
;;;;        loaded after every other probe and the SAME collapse still fires.  A
;;;;        repair that disarmed the teeth to remove the seam would have traded one
;;;;        hole for a worse one; this is what proves the removal was a
;;;;        RELOCATION.
;;;;
;;;; CANDIDATE.  Nothing here is adopted, and nothing here is independent
;;;; verification.
;;;;
;;;; — TABULARIUS (Claude Opus 5, subagent), 2026-08-20
;;;; — R4 arms by OBTURATOR (Claude Opus 5, subagent), 2026-08-20

(require :sb-posix)
;; ⚑ THE F1 PROBE ASKS THE IMAGE WHAT IT COMPILED, not the source file what it
;; says.  `sb-introspect:function-lambda-list` is the only honest instrument for
;; `is this parameter reachable?`, because a grep reads the text and an arglist
;; reads the function.
(require :sb-introspect)

(load (merge-pathnames "ml0-suite-ground.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-memory-layer0)

(defparameter *lane-directory*
  (make-pathname :name nil :type nil :defaults *load-truename*))
(defparameter *subject-root* (merge-pathnames "../../" *lane-directory*))

(defvar *probes* 0)
(defvar *closed* 0)
(defvar *open-holes* 0)

(defun probe (label closed-p &optional (note ""))
  "CLOSED-P is TRUE when the blocker is SHUT.  Against the blocked build these
answer NIL and this file exits nonzero; that run is the RED evidence."
  (incf *probes*)
  (if closed-p (incf *closed*) (incf *open-holes*))
  (format t "~&[~d] ~a  ~a~@[~%      ~a~]~%"
          *probes* (if closed-p "CLOSED" "OPEN  ") (format nil label)
          (and (plusp (length note)) (format nil note)))
  (finish-output)
  closed-p)

(defparameter +source-record-fields+
  '("species" "acquisition-route" "producer-principal" "recorder-principal"
    "coordinate" "observation-scope" "origin-as-read" "subject-act-id"
    "payload-digest" "frontier-relation" "attests" "observation-interval"
    "validation-standing" "door")
  "The fourteen fields of a canonical source record, in serialization order —
used ONLY to rebuild a record with exactly one field changed, so `the only
changed field` is a fact this file can show rather than a claim it makes.")

(defun flip-coordinate-field (coordinate name new-value)
  "A copy of a door's COORDINATE record with exactly one field replaced — used
only to synthesise disease controls that no public path can build any more."
  (let ((names '("kind" "projection-digest" "predicate-answer" "request-conjoined"
                 "projection" "subject-binding")))
    (apply #'rec
           (loop for field in names
                 for value = (if (string= field name)
                                 new-value
                                 (record-field coordinate "coordinate" field))
                 when value collect (entry (list "coordinate" field) value)))))

(defun flip-source-record-field (record name new-value)
  "A byte-for-byte copy of RECORD with exactly one field replaced."
  (apply #'rec
         (mapcar (lambda (field)
                   (entry (list "source" field)
                          (if (string= field name)
                              new-value
                              (record-field record "source" field))))
                 +source-record-fields+)))

(defun misbound-row (observation act-id)
  "⚠ THE DISEASE CONTROL FOR `ML0-WR-7`, and it has to be built through the
INTERNAL constructor because after the repair no public path can produce it.

It is the exact row the chair described: a genuine door reading of one act's
substrate, carrying that act's binding in its coordinate, STAMPED WITH ANOTHER
ACT'S IDENTITY.  In R2 a caller made one of these simply by passing two arguments;
in R3 the door has one argument and cannot.  So the row is synthesised here — a
future door bug, or a tampered carrier — and `ml0-write` must still refuse it, or
the cure is a signature change rather than a defence.

⚑ A PROBE THAT ONLY SHOWED `you can no longer call it that way` WOULD PROVE
NOTHING.  This one shows the check FIRE."
  (let ((source (ml0-observation-source observation)))
    (%ml0-build-source
     :species (ml0-source-species source)
     :acquisition-route (ml0-source-acquisition-route source)
     :producer-principal (ml0-source-producer-principal source)
     :recorder-principal (ml0-source-recorder-principal source)
     :coordinate (ml0-source-coordinate source)
     :observation-scope (ml0-source-observation-scope source)
     :origin-as-read (ml0-source-origin-as-read source)
     :subject-act-id act-id                       ; <== THE ONLY CHANGE
     :payload-digest (ml0-source-payload-digest source)
     :frontier-relation (ml0-source-frontier-relation source)
     :attests (ml0-source-attests source)
     :observation-interval (ml0-source-observation-interval source)
     :validation-standing :validated-by-door
     :door (ml0-source-door source))))

(defun misbound-observation (observation act-id)
  "The same misbinding, wrapped back into an OBSERVATION so it can be handed to
`:observations` / `:issuance-observation` exactly as a door's own would be."
  (%make-ml0-observation
   :door (ml0-observation-door observation)
   :read-summary (ml0-observation-read-summary observation)
   :source (misbound-row observation act-id)))

(format t "~&Memory Layer /0 — BLOCK PROOF.  The chair's two blockers, probed ~
against the code as it stands.  CANDIDATE; nothing here is adopted.~%~%")

(unless (ml0-env-preflight :signal nil)
  (format t "~&ml0-block-proof: VOID — a process-ending switch is set.~%")
  (sb-ext:exit :code 4))
(terpri)

(defvar *root* nil)
(defvar *settled* nil)
(defvar *refused* nil)
(defvar *settled-id* nil)
(defvar *refused-id* nil)
(defvar *refused-result* nil)
(defvar *settled-result* nil)

(setf *root* (ml0-fresh-run-root "ml0-block" *subject-root*))

(unwind-protect
     (progn
       (ml0-ground *root*)
       (setf *settled* (ml0-settled-row))
       (setf *refused* (ml0-refused-row))
       (setf lisp-plus-language-act1:*act1-fixture-table* (list *settled* *refused*))
       (ml0-open-authority (list *settled* *refused*))
       (setf *settled-result*
             (lisp-plus-language-act1:run-act1 *settled* :verbose nil))
       (setf *refused-result*
             (lisp-plus-language-act1:run-act1 *refused* :verbose nil))
       (setf *settled-id* (nth-value 0 (ml0-rederive-act-identity *settled*)))
       (setf *refused-id* (nth-value 0 (ml0-rederive-act-identity *refused*)))

       ;;; ==================================================================
       ;;; THE GROUND TRUTH, established by the substrates themselves BEFORE
       ;;; any forgery — so the forgery is measured against a fact, not a hope.
       ;;; ==================================================================
       (format t "~&---- ground truth: the refused act genuinely did not happen ----~%")
       (ml0-note "derived effect standing for ~a : ~s"
                 "a-secunda" (derive-effect-standing *ml0-act-store* "a-secunda"))
       (ml0-note "world ledger rows under its derived external-request key: ~d"
                 (world-ledger-count
                  (ml0-world)
                  (lisp-plus-language-act1:external-request-key "a-secunda")))
       (ml0-note "and Core /0 DID issue evidence for it: ~a"
                 (lisp-plus-core0:core0-evidence-current-image-issued-p
                  (lisp-plus-language-act1:act1-result-evidence *refused-result*)))

       ;;; ==================================================================
       ;;; B1a — a forged PUBLIC :world-bytes row over a refused, absent act.
       ;;; ==================================================================
       (format t "~&~%---- B1a: a forged public :world-bytes row ----~%")
       (let* ((forged
                (make-ml0-source
                 :species :world-bytes                      ; an occurrence species
                 :acquisition-route :live-query
                 :producer-principal "principal:cap2-world-adapter"
                 :recorder-principal "principal:memorylayer0"
                 ;; an ARBITRARY coordinate: nothing reads it, nothing checks it
                 :coordinate (rec (entry '("coordinate" "kind")
                                         (s-datum "cap2-world-ledger"))
                                  (entry '("coordinate" "ledger-key")
                                         (s-datum "whatever-i-like"))
                                  (entry '("coordinate" "row-found")
                                         (s-datum "yes")))
                 :observation-scope
                 (make-ml0-scope :universe "a universe I simply assert I looked at"
                                 :status :looked
                                 :detail "no look was made; this string is free")
                 :origin-as-read "observed"
                 :subject-act-id *refused-id*               ; the REAL act identity
                 ;; an ARBITRARY 64-hex digest of nothing
                 :payload-digest (make-string 64 :initial-element #\b)
                 :frontier-relation "I assert the frontier was crossed"
                 :observation-interval "an interval I invented"
                 :attests :frontier-crossed-for-this-identity))
              (account
                (handler-case
                    (ml0-write *ml0-account-store*
                               (make-ml0-bundle
                                :fixture-row *refused*
                                :claimed-act-id *refused-id*
                                :subject-principal "an ordinary caller"
                                ;; ⚑ THE SAME CALL THE BLOCKED BUILD ACCEPTED.
                                ;; `:sources` still exists and still takes this
                                ;; row; what has changed is that the row is
                                ;; TESTIMONY and cannot warrant.
                                :sources (list forged)))
                  (ml0-condition (c) (list :refused (type-of c)
                                           (ml0-condition-requirement-id c))))))
         (if (consp account)
             (progn (ml0-note "ml0-write REFUSED the forged row: ~a [~a]"
                              (second account) (third account))
                    (probe "B1a · a forged public :world-bytes row over a ~
lawfully-refused, absent act CANNOT mint :occurred"
                           t "the write refused before any account existed"))
             (progn
               (ml0-render-account account)
               (ml0-print-conjuncts "the forged public row" *refused-id* forged)
               (probe "B1a · a forged public :world-bytes row over a ~
lawfully-refused, absent act CANNOT mint :occurred"
                      (not (ml0-account-occurred-p account))
                      (if (ml0-account-occurred-p account)
                          "⚠ THE ACCOUNT DURABLY READS :OCCURRED.  The act refused before the frontier, the journal never moved, and the world holds no row — and an ordinary public caller has just written it into the language's memory as having happened."
                          "the account reads a standing other than :occurred")))))

       ;;; ==================================================================
       ;;; B1b — a claimed issuance standing with no observation behind it.
       ;;; ==================================================================
       (format t "~&~%---- B1b: an unwarranted :issued-in-writing-image claim ----~%")
       (let ((account
               (handler-case
                   (ml0-write *ml0-account-store*
                              (make-ml0-bundle
                               :fixture-row *settled*
                               :claimed-act-id *settled-id*
                               :subject-principal "an ordinary caller"
                               :sources (list (ml0-self-report-source
                                               *settled-id* "no evidence was consulted"))
                               ;; a bare caller keyword; no evidence object exists
                               ;; anywhere in this bundle and the live predicate is
                               ;; never invoked
                               :issuance-standing :issued-in-writing-image))
                 (ml0-condition (c) (list :refused (type-of c)
                                          (ml0-condition-requirement-id c))))))
         (if (consp account)
             (probe "B1b · a bundle claiming :issued-in-writing-image without a ~
validated current-image issuance observation cannot carry that standing"
                    t "the write refused the unwarranted claim")
             (probe "B1b · a bundle claiming :issued-in-writing-image without a ~
validated current-image issuance observation cannot carry that standing"
                    (not (eq :issued-in-writing-image
                             (ml0-account-issuance-standing account)))
                    (if (eq :issued-in-writing-image
                            (ml0-account-issuance-standing account))
                        "⚠ THE CALLER'S KEYWORD IS NOW IN THE DURABLE BYTES.  No evidence object was involved and no predicate was consulted; the account testifies to an issuance nobody observed."
                        "the account carries a standing other than the claim"))))

       ;;; ==================================================================
       ;;; B2 — the deduplicator collapses distinct provenance.
       ;;; ==================================================================
       (format t "~&~%---- B2: consolidation and distinct provenance ----~%")
       (let* ((digest (digest-of (s-datum "one payload, two readings")))
              (row-a (make-ml0-source
                      :species :lane-self-report
                      :acquisition-route :live-query
                      :producer-principal "principal:memorylayer0"
                      :recorder-principal "principal:recorder-alpha"
                      :coordinate (rec (entry '("coordinate" "kind")
                                              (s-datum "reading-alpha")))
                      :observation-scope
                      (make-ml0-scope :universe "universe ALPHA" :status :looked
                                      :detail "read by mechanism alpha")
                      :origin-as-read "self-reported"
                      :subject-act-id *settled-id*
                      :payload-digest digest
                      :frontier-relation "alpha's relation"
                      :observation-interval "interval-ALPHA"
                      :attests :inconclusive))
              (row-b (make-ml0-source
                      :species :lane-self-report          ; SAME species
                      :acquisition-route :reconstructed   ; different
                      :producer-principal "principal:memorylayer0"  ; SAME producer
                      :recorder-principal "principal:recorder-beta" ; different
                      :coordinate (rec (entry '("coordinate" "kind")
                                              (s-datum "reading-beta")))   ; different
                      :observation-scope
                      (make-ml0-scope :universe "universe BETA" :status :looked
                                      :detail "read by mechanism beta")     ; different
                      :origin-as-read "self-reported"
                      :subject-act-id *settled-id*
                      :payload-digest digest              ; SAME digest
                      :frontier-relation "beta's relation"                  ; different
                      :observation-interval "interval-BETA"                 ; different
                      :attests :no-record-for-this-identity))               ; different
              ;; ⚑ R4.1: BOTH ACCOUNTS NOW NAME ONE SUBJECT PRINCIPAL.  Until
              ;; 2026-08-21 these read "alpha" and "beta", which ML0-CON-4 now
              ;; refuses — a derived account has ONE subject.  The subject
              ;; principal was never what this probe is about: the DISTINCT
              ;; PROVENANCE under test lives in the two SOURCE ROWS (coordinate,
              ;; recorder, route, scope, frontier relation, interval,
              ;; attestation), and it is untouched.  The two accounts still carry
              ;; distinct content-derived identities, which the note below
              ;; MEASURES rather than assumes.
              (account-a (ml0-write *ml0-account-store*
                                    (make-ml0-bundle :fixture-row *settled*
                                                     :claimed-act-id *settled-id*
                                                     :subject-principal "an ordinary caller"
                                                     :sources (list row-a))))
              (account-b (ml0-write *ml0-account-store*
                                    (make-ml0-bundle :fixture-row *settled*
                                                     :claimed-act-id *settled-id*
                                                     :subject-principal "an ordinary caller"
                                                     :sources (list row-b))))
              (union (ml0-consolidation-sources
                      (ml0-consolidate (list account-a account-b)))))
         (ml0-note "the two rows agree ONLY in species, payload digest and ~
producer principal; they differ in coordinate, recorder, route, scope, frontier ~
relation, interval and attestation")
         (ml0-note "canonical record bytes identical? ~a"
                   (if (equal (digest-of (ml0-source-record row-a))
                              (digest-of (ml0-source-record row-b)))
                       "yes" "NO — they are different rows"))
         (ml0-note "the two accounts' identities: ~a / ~a — ~a"
                   (ml0-account-id-hex account-a) (ml0-account-id-hex account-b)
                   (if (string= (ml0-account-id-hex account-a)
                                (ml0-account-id-hex account-b))
                       "⚠ COLLAPSED AT THE ACCOUNT LEVEL — this probe would then be measuring nothing"
                       "distinct, so the union below is a union of two records"))
         (ml0-note "source rows surviving consolidation: ~d" (length union))
         (probe "B2 · two source rows with DISTINCT provenance but equal ~
species/digest/producer both survive the consolidation union"
                (= 2 (length union))
                (if (= 2 (length union))
                    "both readings survive"
                    "⚠ ONE READING WAS DELETED.  The rows differ in coordinate, recorder, route, scope, frontier relation, interval and attestation, and the deduplicator ignored all of them — while the comment beside it calls its own test `THE SAME READING OF THE SAME BYTES BY THE SAME MECHANISM`.")))

       ;;; ==================================================================
       ;;; R2B1 — THE PUBLIC DECODER LAUNDERS ITS OWN VALIDATION CLAIM.
       ;;;
       ;;; The chair's R2 disposition: `ml0-source-from-record` is public, reads
       ;;; the record's OWN "validation-standing" field, and preserves a
       ;;; caller-written :validated-by-door as RECORDED-VALIDATION — which
       ;;; `ml0-source-warranting-validation-p` then treats as warranting.  So
       ;;; the R1 forgery works again with ONE EXTRA ROUND TRIP and ONE CHANGED
       ;;; FIELD.  The front desk stopped issuing witness badges; the public
       ;;; photocopier now authenticates the copy.
       ;;; ==================================================================
       (format t "~&~%---- R2B1: the public decoder launders its own claim ----~%")
       (let* ((forged
                (make-ml0-source
                 :species :world-bytes
                 :acquisition-route :live-query
                 :producer-principal "principal:cap2-world-adapter"
                 :recorder-principal "principal:memorylayer0"
                 :coordinate (rec (entry '("coordinate" "kind")
                                         (s-datum "cap2-world-ledger"))
                                  (entry '("coordinate" "ledger-key")
                                         (s-datum "external-request:cap2:a-secunda"))
                                  (entry '("coordinate" "ledger-sha")
                                         (s-datum (make-string 64 :initial-element #\a))))
                 :observation-scope
                 (make-ml0-scope
                  :universe "the ENTIRE capability /2 world fixture"
                  :status :looked
                  :detail "DECLARED, never performed — no byte was read")
                 :origin-as-read "observed"
                 :subject-act-id *refused-id*
                 :payload-digest (make-string 64 :initial-element #\b)
                 :frontier-relation "the ledger holds a row under this act's derived external-request identity"
                 :observation-interval "cap2-world-ledger/at-forgery"
                 :attests :frontier-crossed-for-this-identity))
              (record (ml0-source-record forged))
              (flipped (flip-source-record-field record "validation-standing"
                                                 (s-datum "validated-by-door")))
              (decoded (handler-case (ml0-source-from-record flipped)
                         (ml0-condition (c) (list :refused (type-of c)
                                                  (ml0-condition-requirement-id c))))))
         (ml0-note "the two records differ in EXACTLY ONE FIELD: ~
validation-standing ~s -> ~s"
                   (lisp-plus-cd0:string-datum-value
                    (record-field record "source" "validation-standing"))
                   (lisp-plus-cd0:string-datum-value
                    (record-field flipped "source" "validation-standing")))
         (ml0-note "records byte-identical? ~a"
                   (if (equal (digest-of record) (digest-of flipped)) "yes" "no"))
         (if (consp decoded)
             (probe "R2B1 · a freely callable record decoder cannot produce a ~
promotion-capable source"
                    t (format nil "the decoder REFUSED the flipped record: ~a [~a]"
                              (second decoded) (third decoded)))
             (let ((account
                     (handler-case
                         (ml0-write *ml0-account-store*
                                    (make-ml0-bundle
                                     :fixture-row *refused*
                                     :claimed-act-id *refused-id*
                                     :subject-principal "an ordinary caller"
                                     :sources (list decoded)))
                       (ml0-condition (c) (list :refused (type-of c)
                                                (ml0-condition-requirement-id c))))))
               (ml0-note "the decoded row's validation standing: ~s (recorded: ~s); ~
warranting? ~a"
                         (ml0-source-validation-standing decoded)
                         (ml0-source-recorded-validation decoded)
                         (if (ml0-source-warranting-validation-p decoded) "YES" "no"))
               (if (consp account)
                   (probe "R2B1 · a freely callable record decoder cannot produce a ~
promotion-capable source"
                          t (format nil "the write REFUSED it: ~a [~a]"
                                    (second account) (third account)))
                   (probe "R2B1 · a freely callable record decoder cannot produce a ~
promotion-capable source"
                          (not (ml0-account-occurred-p account))
                          (if (ml0-account-occurred-p account)
                              "⚠ ONE FLIPPED FIELD AND THE ACCOUNT READS :OCCURRED.  No substrate was read; a public decoder authenticated a caller's own copy of its own assertion."
                              "the account reads a standing other than :occurred"))))))

       ;;; ==================================================================
       ;;; R2B2a/b — THE DOORS READ ONE ACT AND NAME ANOTHER (world, journal).
       ;;;
       ;;; Every door accepts ACT-ID and ATTEMPT independently.  The substrate is
       ;;; inspected under the ATTEMPT; the row is stamped with the ACT-ID.  So a
       ;;; caller executes settled act B, reads B's substrate, and stamps the row
       ;;; toward refused act A — and `ml0-write` checks only that the stamped
       ;;; subject equals the bundle's rederived identity, which it does.
       ;;; ==================================================================
       (format t "~&~%---- R2B2a: world observation of B stamped toward A ----~%")
       (let* ((subject-b (ml0-subject-from-fixture-row *settled*))
              (honest (ml0-observe-world subject-b (ml0-world)))
              (misbound (misbound-observation honest *refused-id*))
              (account
                (handler-case
                    (ml0-write *ml0-account-store*
                               (make-ml0-bundle
                                :fixture-row *refused*
                                :claimed-act-id *refused-id*
                                :subject-principal "an ordinary caller"
                                :observations (list misbound)))
                  (ml0-condition (c) (list :refused (type-of c)
                                           (ml0-condition-requirement-id c))))))
         (ml0-note "the door took ONE subject: its ledger key ~a and its stamped ~
identity come from the same row, so the pairing cannot be made"
                   (ml0-subject-external-request-key subject-b))
         (ml0-note "the DISEASE ROW was synthesised through the internal ~
constructor: act B's reading, act B's binding, act A's name")
         (probe "R2B2a · a world door cannot read one act's substrate and ~
name another act"
                (and (consp account) (equal "ML0-WR-7" (third account)))
                (if (consp account)
                    (format nil "refused pre-mutation: ~a [~a]"
                            (second account) (third account))
                    "⚠ THE MISBOUND ROW WAS WRITTEN.  The binding check did not fire.")))

       (format t "~&~%---- R2B2b: journal observation of B stamped toward A ----~%")
       (let* ((honest (ml0-observe-journal (ml0-subject-from-fixture-row *settled*)
                                           *ml0-act-store*))
              (misbound (misbound-observation honest *refused-id*))
              (account
                (handler-case
                    (ml0-write *ml0-account-store*
                               (make-ml0-bundle
                                :fixture-row *refused*
                                :claimed-act-id *refused-id*
                                :subject-principal "an ordinary caller"
                                :observations (list misbound)))
                  (ml0-condition (c) (list :refused (type-of c)
                                           (ml0-condition-requirement-id c))))))
         (probe "R2B2b · a journal door cannot fold one act's attempt and ~
name another act"
                (and (consp account) (equal "ML0-WR-7" (third account)))
                (if (consp account)
                    (format nil "refused pre-mutation: ~a [~a]"
                            (second account) (third account))
                    "⚠ THE MISBOUND ROW WAS WRITTEN.")))

       ;;; ==================================================================
       ;;; R2B2c — the ABSENCE of B stamped as the NONOCCURRENCE of A.
       ;;; The mirror of the positive substitution, and the worse one: it writes
       ;;; `it did not happen` about an act that DID.
       ;;; ==================================================================
       (format t "~&~%---- R2B2c: absence of B stamped as nonoccurrence of A ----~%")
       (let* ((honest (ml0-observe-absence (ml0-subject-from-fixture-row *refused*)
                                           (ml0-world)))
              (misbound (misbound-observation honest *settled-id*))
              (account
                (handler-case
                    (ml0-write *ml0-account-store*
                               (make-ml0-bundle
                                :fixture-row *settled*
                                :claimed-act-id *settled-id*
                                :subject-principal "an ordinary caller"
                                :observations (list misbound)))
                  (ml0-condition (c) (list :refused (type-of c)
                                           (ml0-condition-requirement-id c))))))
         (ml0-note "the honest absence row attests ~s over key ~a — a TRUE reading ~
about the refused act, and it is the NAME that is being falsified"
                   (ml0-source-attests (ml0-observation-source honest))
                   (ml0-subject-external-request-key
                    (ml0-subject-from-fixture-row *refused*)))
         (probe "R2B2c · an absence door cannot look under one act's key and ~
report the nonoccurrence of another"
                (and (consp account) (equal "ML0-WR-7" (third account)))
                (if (consp account)
                    (format nil "refused pre-mutation: ~a [~a]"
                            (second account) (third account))
                    "⚠ AN ACT THAT SETTLED WAS DURABLY RECORDED AS :NONOCCURRED.")))

       ;;; ==================================================================
       ;;; R2B2d — evidence AND canonical request for B, stamped as the issuance
       ;;; of A.  The conjoined predicate answers TRUE about B; the row names A.
       ;;; ==================================================================
       (format t "~&~%---- R2B2d: B's issuance stamped as A's ----~%")
       (let* ((honest (ml0-observe-issuance
                       (ml0-subject-from-fixture-row *settled*)
                       (lisp-plus-language-act1:act1-result-evidence
                        *settled-result*)))
              (misbound (misbound-observation honest *refused-id*))
              (account
                (handler-case
                    (ml0-write *ml0-account-store*
                               (make-ml0-bundle
                                :fixture-row *refused*
                                :claimed-act-id *refused-id*
                                :subject-principal "an ordinary caller"
                                :sources (list (ml0-self-report-source
                                                *refused-id* "issuance only"))
                                :issuance-observation misbound))
                  (ml0-condition (c) (list :refused (type-of c)
                                           (ml0-condition-requirement-id c))))))
         (ml0-note "the issuance door now derives the canonical request FROM THE ~
SUBJECT, so act A's subject against act B's evidence answers ~a"
                   (let ((a-reading
                           (ml0-observe-issuance
                            (ml0-subject-from-fixture-row *refused*)
                            (lisp-plus-language-act1:act1-result-evidence
                             *settled-result*))))
                     (if (ml0-observation-issued-p a-reading) "TRUE" "false")))
         (probe "R2B2d · an issuance door cannot confirm one act's evidence ~
and name another act"
                (and (consp account) (equal "ML0-WR-7" (third account)))
                (if (consp account)
                    (format nil "refused pre-mutation: ~a [~a]"
                            (second account) (third account))
                    "⚠ THE PREDICATE ANSWERED ABOUT ACT B AND THE ACCOUNT IS ACT A's.")))

       ;;; ==================================================================
       ;;; R2B2e — issued evidence with a NIL canonical request.
       ;;; `ml0-observation-issued-p` reads only "predicate-answer"; the
       ;;; unconjoined predicate says an account was minted HERE but not WHICH
       ;;; act it belongs to.  That is not a binding.
       ;;; ==================================================================
       (format t "~&~%---- R2B2e: issuance with NO request binding ----~%")
       (let* ((honest (ml0-observe-issuance
                       (ml0-subject-from-fixture-row *settled*)
                       (lisp-plus-language-act1:act1-result-evidence
                        *settled-result*)))
              (source (ml0-observation-source honest))
              ;; ⚠ THE DISEASE CONTROL: an issuance reading whose predicate
              ;; answered TRUE but which was never conjoined with a request.  It
              ;; cannot be produced through the door any more — the request comes
              ;; from the subject — so it is synthesised from the honest row with
              ;; "request-conjoined" set to "no" and nothing else touched.
              (unconjoined
                (%make-ml0-observation
                 :door :issuance-door
                 :read-summary "SYNTHESISED: predicate true, no request binding"
                 :source
                 (%ml0-build-source
                  :species (ml0-source-species source)
                  :acquisition-route (ml0-source-acquisition-route source)
                  :producer-principal (ml0-source-producer-principal source)
                  :recorder-principal (ml0-source-recorder-principal source)
                  :coordinate (flip-coordinate-field
                               (ml0-source-coordinate source)
                               "request-conjoined" (s-datum "no"))
                  :observation-scope (ml0-source-observation-scope source)
                  :origin-as-read (ml0-source-origin-as-read source)
                  :subject-act-id (ml0-source-subject-act-id source)
                  :payload-digest (ml0-source-payload-digest source)
                  :frontier-relation (ml0-source-frontier-relation source)
                  :attests (ml0-source-attests source)
                  :observation-interval (ml0-source-observation-interval source)
                  :validation-standing :validated-by-door
                  :door :issuance-door)))
              (account
                (handler-case
                    (ml0-write *ml0-account-store*
                               (make-ml0-bundle
                                :fixture-row *settled*
                                :claimed-act-id *settled-id*
                                :subject-principal "an ordinary caller"
                                :sources (list (ml0-self-report-source
                                                *settled-id* "issuance only"))
                                :issuance-observation unconjoined))
                  (ml0-condition (c) (list :refused (type-of c)
                                           (ml0-condition-requirement-id c))))))
         (ml0-note "the honest reading is conjoined (~a) and issued-p answers ~a; ~
the synthesised unconjoined reading answers ~a"
                   (lisp-plus-cd0:string-datum-value
                    (record-field (ml0-source-coordinate source)
                                  "coordinate" "request-conjoined"))
                   (if (ml0-observation-issued-p honest) "TRUE" "false")
                   (if (ml0-observation-issued-p unconjoined) "TRUE" "false"))
         (if (consp account)
             (probe "R2B2e · an unconjoined issuance reading (no request binding) ~
cannot establish :issued-in-writing-image"
                    t (format nil "refused: ~a [~a]"
                              (second account) (third account)))
             (probe "R2B2e · an unconjoined issuance reading (no request binding) ~
cannot establish :issued-in-writing-image"
                    (and (not (ml0-observation-issued-p unconjoined))
                         (eq :unresolved (ml0-account-issuance-standing account)))
                    (if (eq :issued-in-writing-image
                            (ml0-account-issuance-standing account))
                        "⚠ NO REQUEST WAS BOUND and the account claims an issuance for THIS act."
                        "the standing is :unresolved — the reading is recorded, the claim is not made"))))

       ;;; ==================================================================
       ;;; P — THE POSITIVE CONTROL.  A lawful reading of a genuinely occurred
       ;;; act must still reach :OCCURRED, or the repair is a wall.
       ;;; ==================================================================
       (format t "~&~%---- P: the positive control ----~%")
       (let ((account
               (handler-case
                   (ml0-write *ml0-account-store*
                              (make-ml0-bundle
                               :fixture-row *settled*
                               :claimed-act-id *settled-id*
                               :subject-principal "the actor"
                               ;; ⚑ THE LAWFUL PATH: production observation doors
                               ;; that READ.  In the blocked build this used the
                               ;; suite-ground builders, which the canonical loader
                               ;; excludes; these live in the lane.
                               :observations
                               (let ((subject (ml0-subject-from-fixture-row
                                               *settled*)))
                                 (list (ml0-observe-world subject (ml0-world))
                                       (ml0-observe-journal subject
                                                            *ml0-act-store*)))))
                 (ml0-condition (c) (list :refused (type-of c)
                                          (ml0-condition-requirement-id c))))))
         (if (consp account)
             (probe "P · a LAWFUL reading of a genuinely occurred act still ~
reaches :OCCURRED — the repair is a discrimination, not a wall"
                    nil (format nil "⚠ the lawful path was REFUSED: ~a [~a]"
                                (second account) (third account)))
             (probe "P · a LAWFUL reading of a genuinely occurred act still ~
reaches :OCCURRED — the repair is a discrimination, not a wall"
                    (ml0-account-occurred-p account)
                    (if (ml0-account-occurred-p account)
                        "the lawful path is open"
                        "⚠ the lawful path no longer reaches :occurred"))))

       ;;; ==================================================================
       ;;; P2 — THE SECOND POSITIVE CONTROL.  A lawful CONJOINED issuance
       ;;; observation of the act's OWN evidence and the act's OWN canonical
       ;;; request must still reach :ISSUED-IN-WRITING-IMAGE.  Without this, the
       ;;; issuance repairs above could be passing because the axis is dead.
       ;;; ==================================================================
       (format t "~&~%---- P2: the issuance positive control ----~%")
       (let ((account
               (handler-case
                   (ml0-write *ml0-account-store*
                              (make-ml0-bundle
                               :fixture-row *settled*
                               :claimed-act-id *settled-id*
                               :subject-principal "the actor"
                               :sources (list (ml0-self-report-source
                                               *settled-id* "issuance only"))
                               :issuance-observation
                               (ml0-observe-issuance
                                (ml0-subject-from-fixture-row *settled*)
                                (lisp-plus-language-act1:act1-result-evidence
                                 *settled-result*))))
                 (ml0-condition (c) (list :refused (type-of c)
                                          (ml0-condition-requirement-id c))))))
         (if (consp account)
             (probe "P2 · a LAWFUL conjoined issuance observation still reaches ~
:ISSUED-IN-WRITING-IMAGE — the issuance repair is a discrimination, not a wall"
                    nil (format nil "⚠ the lawful path was REFUSED: ~a [~a]"
                                (second account) (third account)))
             (probe "P2 · a LAWFUL conjoined issuance observation still reaches ~
:ISSUED-IN-WRITING-IMAGE — the issuance repair is a discrimination, not a wall"
                    (eq :issued-in-writing-image
                        (ml0-account-issuance-standing account))
                    (if (eq :issued-in-writing-image
                            (ml0-account-issuance-standing account))
                        "the lawful issuance path is open"
                        "⚠ the lawful issuance path no longer reaches :issued-in-writing-image"))))

       ;;; ==================================================================
       ;;; R4 — THE CODEX ADVERSARIAL AUDIT'S FIVE FINDINGS.
       ;;;
       ;;; Source: notes/2026-08-20-ml0-codex-adversarial-audit.md, a
       ;;; CROSS-FAMILY (GPT/Codex) read of this lane.  Three Claude rounds and
       ;;; two chair dispositions did not find F1.  Every arm below was written
       ;;; and RUN AGAINST THE UNREPAIRED R3 BUILD FIRST — that run is
       ;;; RED-CODEX-BEFORE.txt, exit walked — and only then repaired.
       ;;; ==================================================================

       ;;; ---- F1 — TRUTH-MINTING: the `defect` mutant seam is a public runtime
       ;;; ---- parameter on the exported production surface.
       ;;;
       ;;; ⚑ THIS PROBE ASKS THE IMAGE, NOT THE SOURCE.  It walks every EXTERNAL
       ;;; symbol of the lane's package in an image loaded through the canonical
       ;;; `load.lisp` and reads the arglist SBCL actually compiled.  A grep can
       ;;; be fooled by a macro; `function-lambda-list` cannot.
       (format t "~&~%---- F1: no mutant seam on the public arglists ----~%")
       (let* ((package (find-package '#:lisp-plus-memory-layer0))
              (offenders '()))
         (do-external-symbols (symbol package)
           (when (fboundp symbol)
             (let ((arglist (handler-case (sb-introspect:function-lambda-list symbol)
                              (error () nil))))
               (when (some (lambda (item)
                             (and (symbolp item)
                                  (member (symbol-name item)
                                          '("DEFECT" "DEFECT-PAYLOAD")
                                          :test #'string=)))
                           arglist)
                 (push (symbol-name symbol) offenders)))))
         (probe "F1 · NO EXTERNAL FUNCTION OF THIS LANE CARRIES A `DEFECT` ~
PARAMETER — the mutant seam is not a public runtime lever"
                (null offenders)
                (if offenders
                    (format nil "⚠ ~d exported function(s) still take it: ~{~a~^, ~}"
                            (length offenders) (sort offenders #'string<))
                    "walked every external fbound symbol's compiled lambda list")))

       ;;; ---- F1b — AND THE PREDICATE ITSELF NO LONGER FLIPS.  The audit's own
       ;;; ---- confirmed probe, run here: normal NIL, and the keyword route must
       ;;; ---- be GONE rather than merely unused.
       (let* ((normal (ml0-species-may-warrant-occurrence-p :core0-issuance-testimony))
              ;; ⚠ APPLIED THROUGH `symbol-function` AND A RUNTIME-BUILT LIST,
              ;; deliberately: a literal call with the old keyword is a
              ;; COMPILE-TIME warning now, and a gate transcript full of compiler
              ;; noise is a gate nobody reads.  The question is what the FUNCTION
              ;; does at run time, and this asks it that way.
              (arguments (list* :core0-issuance-testimony
                                (list :defect :issuance-implies-occurrence)))
              (flipped (handler-case
                           (list :answered
                                 (apply (symbol-function
                                         'ml0-species-may-warrant-occurrence-p)
                                        arguments))
                         (error () :signalled))))
         (probe "F1b · the crown predicate answers NIL for issuance testimony AND ~
the `:defect :issuance-implies-occurrence` route no longer exists"
                (and (null normal) (eq :signalled flipped))
                (format nil "normal => ~s · with the mutant keyword => ~s"
                        normal flipped)))

       ;;; ---- F2 — TRUTH-MINTING on the raw decode: the carried standing.
       ;;; ---- A self-consistent caller-held frame whose sources warrant NOTHING
       ;;; ---- but whose body SAYS `occurred`.
       (format t "~&~%---- F2: the raw decode may not carry a standing ----~%")
       (multiple-value-bind (act-id act-hex seat attempt)
           (ml0-rederive-act-identity *refused*)
         (let* ((row (ml0-self-report-source act-id "F2: a row that warrants nothing"))
                (body (ml0-account-body
                       :act-id act-id :act-id-hex act-hex
                       :subject-seat seat :subject-attempt attempt
                       :occurrence-standing :occurred :occurrence-scope nil
                       :issuance-standing :issued-in-writing-image :issuance-scope nil
                       :record-coverage :not-examined :record-coverage-scope nil
                       :effect-observation nil
                       :sources (list row) :derivation :direct-write
                       :predecessors nil
                       :recorder-principal +ml0-lane-stem+
                       :subject-principal "the actor")))
           (multiple-value-bind (id hex) (ml0-mint-account-identity body)
             (declare (ignore id))
             (let* ((event (ml0-account-envelope
                            :account-hex hex :subject-attempt attempt
                            :subject-principal "the actor"
                            :recording-process +ml0-runtime-process-name+
                            :body body :derivation :direct-write))
                    (decoded (handler-case (ml0-account-from-event event)
                               (ml0-condition (c)
                                 (list :refused (ml0-condition-requirement-id c))))))
               (probe "F2 · a RAW decode of a caller-held frame may not read ~
:OCCURRED off the bytes — the standing is re-derived from the rows, which ~
warrant nothing"
                      (or (consp decoded)
                          (and (not (ml0-account-occurred-p decoded))
                               (not (eq :issued-in-writing-image
                                        (ml0-account-issuance-standing decoded)))))
                      (if (consp decoded)
                          (format nil "the raw decode REFUSED [~a]" (second decoded))
                          (format nil "occurred-p => ~s · occurrence ~s · issuance ~s"
                                  (ml0-account-occurred-p decoded)
                                  (ml0-account-occurrence-standing decoded)
                                  (ml0-account-issuance-standing decoded))))
               ;; ---- F2b — RB-11 must not be SKIPPED for a frame this lane does
               ;; ---- not recognize.  Same body, foreign event-id.
               (let* ((foreign
                        (rec (entry '("event" "attempt") (idf (list "attempt" attempt)))
                             (entry '("event" "body") body)
                             (entry '("event" "capture-boundary")
                                    (idf '("boundary" "memory-accounting")))
                             (entry '("event" "capture-mechanism")
                                    (idf '("witness" "lane-self-report")))
                             (entry '("event" "event-id") (idf '("foreign" "shape")))
                             (entry '("event" "kind") (idf '("ml0" "account")))
                             (entry '("event" "origin") (idf '("origin" "self-reported")))
                             (entry '("event" "process-id")
                                    (idf (list "process" +ml0-runtime-process-name+)))
                             (entry '("event" "recorder-principal")
                                    (idf (list "principal" +ml0-lane-stem+)))
                             (entry '("event" "subject-principal")
                                    (idf '("principal" "the actor")))))
                      (answer (handler-case (progn (ml0-account-from-event foreign)
                                                   :decoded)
                                (ml0-condition (c)
                                  (list :refused (ml0-condition-requirement-id c))))))
                 (probe "F2b · a frame whose event-id is not this lane's shape is ~
REFUSED, never decoded with the identity check silently skipped"
                        (consp answer)
                        (if (consp answer)
                            (format nil "refused [~a]" (second answer))
                            "⚠ decoded — RB-11 had nothing to compare and let it through")))))))

       ;;; ---- F3 — LAUNDERING: a caller-asserted record-coverage finding about
       ;;; ---- THIS LANE'S OWN STORE, with a fabricated `:looked` scope.
       (format t "~&~%---- F3: record coverage must come from a door ----~%")
       (let ((answer
               (handler-case
                   (ml0-bundle-record-coverage
                    (make-ml0-bundle
                     :fixture-row *settled* :claimed-act-id *settled-id*
                     :subject-principal "the actor"
                     :sources (list (ml0-self-report-source *settled-id* "F3"))
                     :record-coverage :issuance-record-present-in-account-store
                     :record-coverage-scope
                     (make-ml0-scope
                      :universe "the memory layer's own account store"
                      :status :looked
                      :detail "I did not open it; I am simply saying I did")))
                 (ml0-condition (c) (list :refused (ml0-condition-requirement-id c))))))
         (probe "F3 · a CALLER may not assert a record-coverage finding about this ~
lane's own store — the assertion is refused, or normalized to :NOT-EXAMINED"
                (or (consp answer) (eq :not-examined answer))
                (if (consp answer)
                    (format nil "refused [~a]" (second answer))
                    (format nil "the bundle's coverage reads ~s" answer))))
       ;;; ---- F3b — AND THE DOOR EXISTS AND ACTUALLY SCANS.  A finding nobody
       ;;; ---- can produce is not a repair, it is an amputation.
       (let ((door (find-symbol "ML0-OBSERVE-RECORD-COVERAGE"
                                '#:lisp-plus-memory-layer0)))
         (if (not (and door (fboundp door)))
             (probe "F3b · a PRODUCTION DOOR reads this lane's own store and ~
reports coverage on what it found there"
                    nil "⚠ no ml0-observe-record-coverage exists: nothing ever scans the store")
             (let* ((observation (funcall door *ml0-account-store*
                                          (ml0-subject-from-fixture-row *settled*)))
                    (finding (ml0-record-coverage-observation-finding observation)))
               (probe "F3b · a PRODUCTION DOOR reads this lane's own store and ~
reports coverage on what it found there"
                      (and (member finding +ml0-record-coverages+)
                           (eq :looked (ml0-scope-status
                                        (ml0-record-coverage-observation-scope
                                         observation)))
                           t)
                      (format nil "the door scanned and reports ~s" finding)))))

       ;;; ---- F4 — INTEGRITY: the docstring's atomicity claim vs the code.
       ;;; ---- Two paths refuse AFTER `append-event`, so the whole-store claim is
       ;;; ---- false.  A false docstring is a guarantee the code does not make.
       (format t "~&~%---- F4: ml0-write's own account of itself ----~%")
       (let ((doc (or (documentation 'ml0-write 'function) "")))
         (probe "F4 · `ml0-write` does NOT claim a failed write is non-mutating ~
over the WHOLE store, and DOES name its verified-after-append semantics"
                (and (null (search "non-mutating over" doc))
                     (search "VERIFIED AFTER THE APPEND" doc)
                     t)
                (format nil "the false universal claim is ~a; the true semantics is ~a"
                        (if (search "non-mutating over" doc) "STILL PRESENT" "gone")
                        (if (search "VERIFIED AFTER THE APPEND" doc) "named" "ABSENT"))))

       ;;; ---- F5 — HYGIENE: a caller-asserted world/effect reading is stored
       ;;; ---- verbatim beside door-read provenance, with nothing marking it.
       (format t "~&~%---- F5: the effect axis says whose word it is ----~%")
       (let* ((reader (find-symbol "ML0-EFFECT-OBSERVATION-PROVENANCE"
                                   '#:lisp-plus-memory-layer0))
              (observation (make-ml0-effect-observation
                            :standing-as-read "caller invented standing"
                            :determinacy :determinate
                            :world-digest (make-string 64 :initial-element #\a)
                            :scope (make-ml0-scope :universe "the world"
                                                   :status :looked
                                                   :detail "asserted")))
              (record (ml0-effect-observation-record observation))
              (field (record-field record "effect" "provenance")))
         (probe "F5 · an effect observation is marked CALLER-ASSERTED in the type ~
AND in the durable bytes — a reader can tell testimony from a door's reading"
                (and reader (fboundp reader)
                     (eq :caller-asserted (funcall reader observation))
                     field
                     (string= "caller-asserted"
                              (lisp-plus-cd0:string-datum-value field))
                     t)
                (format nil "type reader ~a · durable field ~a"
                        (if (and reader (fboundp reader)) "present" "ABSENT")
                        (if field
                            (lisp-plus-cd0:string-datum-value field)
                            "ABSENT"))))

       (format t "~&~%"))
  (when (probe-file *root*) (sb-ext:delete-directory *root* :recursive t)))

;;; ===========================================================================
;;; F1c — THE DISEASE CONTROL FOR F1, AND IT RUNS LAST FOR A REASON.
;;;
;;; ⚠ A REPAIR THAT DISARMED THE TEETH TO REMOVE THE SEAM WOULD HAVE TRADED ONE
;;; HOLE FOR A WORSE ONE.  F1 above proves the mutant is not reachable from the
;;; canonical load.  It does NOT prove the mutant still exists — and "we deleted
;;; the defect" is exactly how a lane loses the instrument that made its promotion
;;; rule checkable.  So this probe loads `ml0-mutant-overlay.lisp` — the file
;;; `load.lisp` never loads — and shows THE SAME COLLAPSE STILL FIRING on the same
;;; predicate.  Removal is proved to be a RELOCATION.
;;;
;;; ⚑ ORDER IS LOAD-BEARING AND IS STATED RATHER THAN ASSUMED: every probe above
;;; ran in an image that had NOT loaded the overlay.  The load happens here, after
;;; the last of them, and nothing after it reads a production answer.
;;;
;;; The full six-defect kill is `ml0-mutants.lisp`, which is a separate gate in a
;;; separate process; this is the one-line witness that F1's cure did not amputate.
;;; ===========================================================================

(format t "~&---- F1c: the seam was RELOCATED, not deleted ----~%")
(load (merge-pathnames "ml0-mutant-overlay.lisp" *lane-directory*))

(let* ((cured (ml0-species-may-warrant-occurrence-p :core0-issuance-testimony))
       (diseased (with-ml0-mutant (:issuance-implies-occurrence)
                   (ml0-species-may-warrant-occurrence-p :core0-issuance-testimony)))
       (restored (ml0-species-may-warrant-occurrence-p :core0-issuance-testimony)))
  (probe "F1c · with the OVERLAY loaded, the crown collapse still fires — the ~
mutant was moved out of production, not deleted, and the teeth are intact"
         (and (null cured) (eq t diseased) (null restored))
         (format nil "overlay loaded: cured => ~s · under the mutant => ~s · ~
after the dynamic extent => ~s" cured diseased restored)))

(format t "~&ml0-block-proof: ~d probes, ~d closed, ~d open~%"
        *probes* *closed* *open-holes*)
(finish-output)
(sb-ext:exit :code (if (zerop *open-holes*) 0 1))
