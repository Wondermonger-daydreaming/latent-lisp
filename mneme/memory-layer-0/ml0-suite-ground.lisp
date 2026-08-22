;;;; ml0-suite-ground.lisp — the SHARED GROUND for Memory Layer /0's in-process
;;;; suites (selftest, controls, mutants, red proof, host-fault proof).
;;;;
;;;; ⚠ THIS FILE IS NOT ONE OF THE LANE'S FOUR SOURCES and is deliberately not in
;;;; `+ml0-lane-sources+`.  It is test infrastructure: a consumer loading
;;;; `load.lisp` gets the lane and none of this.  The specimen has its own
;;;; `de-actu-memorato/specimen-common.lisp` for the same reason.
;;;;
;;;; WHAT IT PROVIDES, and why each thing is here rather than in the lane:
;;;;
;;;;   * ONE ground: an act store + two fixture worlds + an account store, all
;;;;     under a caller-supplied run root that must be OUTSIDE the subject tree.
;;;;   * THE SIX SOURCE BUILDERS.  These are the LAWFUL USE of `make-ml0-source`
;;;;     — one builder per species, each reading real bytes through the public
;;;;     doors of the lane that owns them.  They are the worked examples the
;;;;     guide describes, kept executable so they cannot drift from the code.
;;;;
;;;; ⚑ THE BUILDERS READ; THEY DO NOT ASSERT.  Every digest here is taken from a
;;;; public reader over bytes on disk, and every scope names the universe the
;;;; look actually covered.  A builder that filled a field from its argument list
;;;; would make the whole suite a tautology.
;;;;
;;;; — TABULARIUS (Claude Opus 5, subagent), 2026-08-20

(load (merge-pathnames "load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-memory-layer0)

;;; ---------------------------------------------------------------------------
;;; The declared charge of the in-process suites.

(defparameter *suite-actor* "actus-memoratus"
  "The DECLARED subject principal of the suites' acts — the principal whose act
an account is ABOUT.  Never the recorder, which is always principal:memorylayer0.")

(defvar *ml0-act-store* nil)
(defvar *ml0-worlds* nil)
(defvar *ml0-world-directories* nil)
(defvar *ml0-account-root* nil)

(defun ml0-ground (root &key (verbose nil))
  "Build the whole ground under ROOT: One Act /1's store and worlds, and THIS
LANE'S OWN separate account store.  Returns ROOT.

⚑ TWO STORES, ON PURPOSE.  The act lane's journal and the memory lane's account
store are different directories and different files, so `the source journal is
byte-unchanged across a retrieval` compares genuinely different bytes and D7's
damage reaches only this lane's own record."
  (setf lisp-plus-language-act1:*act1-run-root* root)
  (setf *ml0-act-store* (lisp-plus-language-act1:build-act1-store root))
  (setf lisp-plus-language-act1:*act1-store* *ml0-act-store*)
  (setf *ml0-worlds* (lisp-plus-language-act1:build-act1-worlds root))
  (setf lisp-plus-language-act1:*act1-worlds* *ml0-worlds*)
  (setf *ml0-world-directories* lisp-plus-language-act1:*act1-world-directories*)
  (setf lisp-plus-language-act1:*act1-bootstrap*
        (lisp-plus-capability0:declare-bootstrap-authority
         '("issuer" "oneact1") (journal-store-store-id *ml0-act-store*)))
  (setf lisp-plus-language-act1:*act1-minting-context*
        (lisp-plus-capability1:make-minting-context :label "ml0-suite"))
  (setf *ml0-run-root* root)
  (setf *ml0-account-store* (build-ml0-account-store root))
  (setf *ml0-account-root* (merge-pathnames "account-store/" root))
  (when verbose
    (ml0-note "act store   : ~a" (journal-store-store-id *ml0-act-store*))
    (ml0-note "account store: ~a (durability ~s)"
              (journal-store-store-id *ml0-account-store*)
              (journal-store-durability *ml0-account-store*)))
  root)

(defun ml0-world () (getf *ml0-worlds* :apply))
(defun ml0-world-directory () (getf *ml0-world-directories* :apply))

;;; ---------------------------------------------------------------------------
;;; The rows the suites drive.

(defun ml0-settled-row (&key (seat "prima") (attempt "a-prima")
                             (cell '("cella" "prima")) (cell-name "cella:prima")
                             (text "Actus memorandus.") (symbol 'ml0-suite/settled))
  "A LAWFUL ACT that settles: it crosses the frontier, the world durably applies
and ledgers the write, and the journal carries the whole sequence.  This is the
act whose occurrence a memory account may lawfully warrant."
  (lisp-plus-language-act1:make-act1-fixture-row
   :arm "SETTLED" :label seat :runtime-seat seat :attempt-name attempt
   :cell-segments cell :adapter-symbol symbol :world-key :apply
   :form (lisp-plus-language-act1:act1-request-form cell-name text)))

(defun ml0-refused-row (&key (seat "secunda") (attempt "a-secunda")
                             (cell '("cella" "vetita-scope"))
                             (cell-name "cella:vetita-scope")
                             (text "Actus qui non fuit.")
                             (symbol 'ml0-suite/refused))
  "⚑ THE CROWN NEGATIVE'S GROUND, AND IT IS A LAWFUL ACT, NOT A PLANTED BUG.

`:authority-mode :ambient` makes Core /0 refuse this act at its OWN authority
check — step 2 of `perform`, BEFORE the adapter is ever invoked.  That refusal
runs through `%refuse-pre-frontier` (core0.lisp:1059-1082), whose own comment
reads: `ISSUANCE SITE 1 of 4 — a pre-frontier refusal genuinely issues a Core /0
account (it rides out inside the typed condition), so it is registered before it
escapes (R-ISSUANCE-0.8)`.

So this row produces, LAWFULLY and through the public seam:

    a GENUINELY ISSUED Core /0 evidence account, bound to THIS act's canonical
    request, for an act that did not happen — with the journal's frame count
    unmoved, `derive-effect-standing` :ABSENT, and the world byte-unchanged.

That is the dangerous shape D2 arm (a) must present to Write, obtained without
reintroducing One Act /1's repaired production bug and without any public
evidence constructor.  The independence of issuance from every occurrence
instrument is MEASURED here, in this lane's own transcript."
  (lisp-plus-language-act1:make-act1-fixture-row
   :arm "REFUSED" :label seat :runtime-seat seat :attempt-name attempt
   :cell-segments cell :adapter-symbol symbol :world-key :apply
   :form (lisp-plus-language-act1:act1-request-form cell-name text)
   :authority-mode :ambient))

(defun ml0-open-authority (rows)
  (lisp-plus-language-act1:act1-opening-authority *ml0-act-store* rows))

;;; ---------------------------------------------------------------------------
;;; THE SIX SOURCE BUILDERS — NOW THIN DELEGATIONS TO THE LANE'S DOORS.
;;;
;;; ⚑ REWRITTEN 2026-08-20, IN THE REPAIR ROUND, AND THE REWRITE IS THE POINT.
;;; These functions used to BE the substrate readers — and they lived here, in
;;; test infrastructure the canonical loader deliberately excludes.  So the honest
;;; readers were the ones a consumer could not reach, and the reachable one
;;; (`make-ml0-source`) validated shape and nothing else.  That asymmetry is what
;;; the chair's disposition blocked.
;;;
;;; The reading now happens in `ml0.lisp` §4b, inside `load.lisp`'s reach, where a
;;; consumer gets it by default.  What is left here is argument-shuffling: these
;;; keep their old names and old call signatures so every existing suite keeps
;;; working, and each returns THE DOOR'S OWN ROW — door-validated, because a door
;;; built it.
;;;
;;; ⚠ CORRECTED IN R3, AND THE OLD PARAGRAPH WAS WRONG BY THE TIME IT WAS WRITTEN.
;;; It read: `the safety property is carried by the ROW'S STAMP, not by which
;;; argument it arrives in — a bundle's :sources may hold rows of any validation
;;; standing.`  The chair's second disposition required the opposite, and it was
;;; right: `:sources` and `:testimony` now NORMALIZE every row to non-warranting
;;; testimony, so THE CHANNEL IS PART OF THE SAFETY PROPERTY.  `:observations`
;;; (and `:issuance-observation`) are the only warrant-bearing way in, and they
;;; admit only door-built `ml0-observation` objects.  A `*-source` wrapper below is
;;; therefore for rows you want CARRIED; a `*-observation` wrapper is for rows you
;;; want to be able to WARRANT.

;;; ---------------------------------------------------------------------------
;;; ⚑ R3: THE SUITE ADAPTER THAT MAKES THE SUBJECT CARRIER REACHABLE FROM THE OLD
;;; CALL SHAPE — AND CHECKS IT.
;;;
;;; The lane's doors no longer accept an act identity and an attempt name as two
;;; independently pairable arguments (R2-BLOCK 2).  The suites' call shape
;;; `(act-id attempt ...)` survives here as a CHECKED ADAPTER: it finds the
;;; declared fixture row that owns the attempt, derives the whole canonical subject
;;; from it, and REFUSES if the act identity the caller named is not the one that
;;; row derives to.  So a suite that tries the substitution the chair found gets a
;;; refusal AT THE SUITE BOUNDARY, and every call that survives it reaches the
;;; production door through the production carrier.

(defun ml0-subject-for (act-id attempt)
  "The canonical subject for ATTEMPT, verified to be the subject ACT-ID names."
  (let ((row (find attempt lisp-plus-language-act1:*act1-fixture-table*
                   :key #'lisp-plus-language-act1:act1-fixture-attempt-name
                   :test #'string=)))
    (unless row
      (ml0-refuse 'ml0-provenance-incomplete "ML0-SG-1"
                  "no declared fixture row owns attempt ~s — a subject cannot be ~
derived from an attempt nobody declared" attempt))
    (let ((subject (ml0-subject-from-fixture-row row)))
      (unless (same-datum-p (ml0-subject-act-id subject) act-id)
        (ml0-refuse 'ml0-subject-identity-mismatch "ML0-SG-2"
                    "attempt ~s belongs to act ~a, not to act ~a — this adapter ~
will not pair one act's identity with another act's attempt" attempt
                    (identifier-segment-string (ml0-subject-act-id subject))
                    (identifier-segment-string act-id)))
      subject)))

(defun ml0-subject-for-act-id (act-id)
  "The canonical subject of the declared fixture row that derives to ACT-ID."
  (or (find-if (lambda (subject) (same-datum-p (ml0-subject-act-id subject) act-id))
               (mapcar #'ml0-subject-from-fixture-row
                       lisp-plus-language-act1:*act1-fixture-table*))
      (ml0-refuse 'ml0-subject-identity-mismatch "ML0-SG-3"
                  "no declared fixture row derives to act ~a"
                  (identifier-segment-string act-id))))

(defun ml0-journal-source (act-id attempt &key (store *ml0-act-store*)
                                               (route :live-query))
  "Delegates to `ml0-observe-journal` (lane §4b) and returns its row."
  (ml0-observation-source
   (ml0-observe-journal (ml0-subject-for act-id attempt) store :route route)))

(defun ml0-journal-observation (act-id attempt &key (store *ml0-act-store*)
                                                    (route :live-query))
  (ml0-observe-journal (ml0-subject-for act-id attempt) store :route route))

(defun ml0-world-source (act-id attempt &key (world (ml0-world)) (route :live-query))
  "Delegates to `ml0-observe-world` (lane §4b) and returns its row."
  (ml0-observation-source
   (ml0-observe-world (ml0-subject-for act-id attempt) world :route route)))

(defun ml0-world-observation (act-id attempt &key (world (ml0-world))
                                                  (route :live-query))
  (ml0-observe-world (ml0-subject-for act-id attempt) world :route route))

(defun ml0-conjunction-source (act-id attempt resolution
                               &key (store *ml0-act-store*) (world (ml0-world))
                                    (route :live-query))
  "Delegates to `ml0-observe-reconciliation` (lane §4b)."
  (ml0-observation-source
   (ml0-observe-reconciliation (ml0-subject-for act-id attempt) store world
                               resolution :route route)))

(defun ml0-conjunction-observation (act-id attempt resolution
                                    &key (store *ml0-act-store*) (world (ml0-world))
                                         (route :live-query))
  (ml0-observe-reconciliation (ml0-subject-for act-id attempt) store world
                              resolution :route route))

(defun ml0-issuance-source (act-id evidence &key (route :live-query))
  "Delegates to `ml0-observe-issuance` (lane §4b), which asks Core /0's LIVE
CONJOINED predicate against THE SUBJECT'S OWN canonical request.  ⚠ R3: the
:CANONICAL-REQUEST argument is GONE — the door derives it from the subject, which
is what stopped one act's evidence from being stamped as another act's issuance."
  (ml0-observation-source
   (ml0-observe-issuance (ml0-subject-for-act-id act-id) evidence :route route)))

(defun ml0-issuance-observation (act-id evidence &key (route :live-query))
  (ml0-observe-issuance (ml0-subject-for-act-id act-id) evidence :route route))

(defun ml0-self-report-source (act-id note &key (route :live-query)
                                                (attests :inconclusive)
                                                (observation-interval
                                                 "lane-narrative/no-interval-claimed"))
  "SPECIES :LANE-SELF-REPORT, through the PUBLIC TESTIMONY DOOR — which is exactly
where a self-report belongs.  It is durable, it is carried, it corroborates, and
it can never warrant occurrence: under AP-JRN-1's clause a self-written narrative
remains asserted testimony, and now the code says so with a stamp instead of only
with a species."
  (make-ml0-source
   :species :lane-self-report
   :acquisition-route route
   :producer-principal (format nil "principal:~a" +ml0-lane-stem+)
   :recorder-principal (format nil "principal:~a" +ml0-lane-stem+)
   :coordinate (rec (entry '("coordinate" "kind") (s-datum "lane-narrative"))
                    (entry '("coordinate" "note") (s-datum note)))
   :observation-scope
   (make-ml0-scope :universe "this lane's own account of its own reading"
                   :status :looked
                   :detail "written by this lane, about this lane; asserted testimony under L15")
   :origin-as-read "self-reported"
   :subject-act-id act-id
   :payload-digest (digest-of (s-datum note))
   :frontier-relation "no frontier claim is made by a self-report"
   :observation-interval observation-interval
   :attests attests))

(defun ml0-negative-source (act-id attempt &key (world (ml0-world))
                                                (status :looked)
                                                (route :live-query)
                                                (attests nil)
                                                (universe nil))
  "Delegates to `ml0-observe-absence` (lane §4b) for the honest case.

⚠ THE :STATUS :COULD-NOT-LOOK AND :ATTESTS OVERRIDES ARE MODELLING TOOLS AND THEY
NOW GO THROUGH THE PUBLIC TESTIMONY DOOR, unstamped.  A failed look and a mistaken
look are things a caller can DESCRIBE; they are not things a door can OBSERVE, and
routing them through the testimony door is what makes that distinction visible in
the bytes rather than only in a comment."
  (if (and (eq status :looked) (null attests) (null universe))
      (ml0-observation-source (ml0-observe-absence (ml0-subject-for act-id attempt)
                                                   world :route route))
      (let ((key (lisp-plus-language-act1:external-request-key attempt)))
        (multiple-value-bind (found line line-sha) (world-ledger-lookup world key)
          (declare (ignore line))
          (make-ml0-source
           :species :scoped-negative-observation
           :acquisition-route route
           :producer-principal "principal:cap2-world-adapter"
           :recorder-principal (format nil "principal:~a" +ml0-lane-stem+)
           :coordinate (rec (entry '("coordinate" "kind")
                                   (s-datum "cap2-world-ledger-absence"))
                            (entry '("coordinate" "ledger-key") (s-datum key))
                            (entry '("coordinate" "row-found")
                                   (s-datum (if found "yes" "no")))
                            (entry '("coordinate" "row-sha")
                                   (s-datum (or line-sha "none")))
                            (entry '("coordinate" "ledger-sha")
                                   (s-datum (world-ledger-sha256 world)))
                            (entry '("coordinate" "witness-mechanism")
                                   (s-datum "cap2 world-ledger-lookup over the world's own files"))
                            (entry '("coordinate" "procedure-identity")
                                   (s-datum "ml0-negative-source/modelled/v2"))
                            (entry '("coordinate" "validation-standing")
                                   (s-datum "MODELLED, not observed: this row is asserted testimony")))
           :observation-scope
           (make-ml0-scope
            :universe (or universe
                          (format nil "the ENTIRE capability /2 request ledger (~d entr~:@p), which is complete and authoritative for external-request identities"
                                  (world-ledger-count world)))
            :status status
            :detail "a MODELLED look: this row is asserted testimony describing a look, not a door's observation of one")
           :origin-as-read "observed"
           :subject-act-id act-id
           :payload-digest (digest-of (rec (entry '("absence" "key") (s-datum key))
                                           (entry '("absence" "found")
                                                  (s-datum (if found "yes" "no")))
                                           (entry '("absence" "ledger-sha")
                                                  (s-datum (world-ledger-sha256 world)))))
           :frontier-relation
           (if found
               (format nil "a row DOES exist under ~a; this look found the act, not its absence" key)
               (format nil "no row exists under ~a across the declared universe; the frontier was never crossed for this identity" key))
           :observation-interval (format nil "cap2-world-ledger/at-~a"
                                         (world-ledger-sha256 world))
           :attests (or attests
                        (if found
                            :frontier-crossed-for-this-identity
                            :no-record-for-this-identity)))))))

(defun ml0-negative-observation-source (act-id attempt &key (world (ml0-world))
                                                            (route :live-query)
                                                            directory)
  "The absence DOOR'S ROW.  With :DIRECTORY the door makes its own adequacy check
and a world whose request ledger cannot be opened yields a DOOR-VALIDATED row whose
scope status is :COULD-NOT-LOOK — validated, and still blind."
  (ml0-observation-source
   (ml0-observe-absence (ml0-subject-for act-id attempt) world
                        :route route :directory directory)))

(defun ml0-negative-observation (act-id attempt &key (world (ml0-world))
                                                     (route :live-query)
                                                     directory)
  "The absence DOOR.  Pass :DIRECTORY to give the door its own adequacy check —
with it, a world whose request ledger cannot be opened yields a door-validated row
whose scope status is :COULD-NOT-LOOK.  That row is the one the scope tooth needs:
validated (so it clears leg 0) and blind (so it must still warrant nothing)."
  (ml0-observe-absence (ml0-subject-for act-id attempt) world
                       :route route :directory directory))

(defun ml0-single-delta-pair (act-id attempt evidence &key (world (ml0-world)))
  "⚑ THE SINGLE-DELTA NEAR-NEIGHBOUR PAIR.  Returns (values LAWFUL-OCCURRENCE-ROW
ISSUANCE-ROW), both about the SAME act, sharing acquisition route, subject
identity and a 64-hex payload digest, and DIFFERING IN SPECIES.

⚠ REBUILT 2026-08-20.  In the blocked build the issuance row was made to
over-claim its scope, interval and attestation so that ONLY the species leg
refused it.  It now comes from the real issuance DOOR, which reads Core /0's live
predicate and reports honestly — so the pair differs in species AND in
attestation, and the RED proof's table shows two legs answering rather than one.
That is a LOSS OF SHARPNESS and it is recorded as one: the door cannot be made to
lie in order to make a demonstration prettier.  The single-delta property is
preserved instead where it can be had honestly — in ml0-block-proof.lisp's B1a,
where a forged TESTIMONY row satisfies all eight fillable legs and fails on leg 0
alone."
  (values (ml0-observation-source
           (ml0-observe-world (ml0-subject-for act-id attempt) world))
          (ml0-observation-source
           (ml0-observe-issuance (ml0-subject-for act-id attempt) evidence))))

(defun ml0-commensurable-clash-pair (act-id attempt &key (world (ml0-world)))
  "⚑ A COMMENSURABLE CONTRADICTION, CONSTRUCTED HONESTLY AND LABELLED AS
CONSTRUCTED.  Returns (values POSITIVE-ROW NEGATIVE-ROW), both declaring the SAME
universe and the SAME observation interval, so they are commensurable and their
disagreement is a real contradiction about one proposition.

⚠ AND THE DISAGREEMENT IS MANUFACTURED.  Two CORRECT looks at one universe over
one interval agree by construction; a clash at that resolution means one of them
is WRONG.  Both rows here therefore come through the PUBLIC TESTIMONY DOOR, not
through a door — they MODEL a mistaken or tampered observation, which is exactly
the case :CONTRADICTED exists for.

⚠ CONSEQUENCE, RECORDED RATHER THAN HIDDEN: because they are testimony, neither
row can WARRANT, so a consolidation over them can no longer reach :CONTRADICTED.
The repair round traded that demonstration away for the cure, and the RETURN says
so.  What survives is the commensurability PREDICATE, which is still exercised
directly."
  (let ((universe (format nil "the capability /2 world fixture at ledger digest ~a, declared identically by both rows so the two warrants are COMMENSURABLE"
                          (world-ledger-sha256 world)))
        (interval (format nil "cap2-world-ledger/at-~a" (world-ledger-sha256 world))))
    (values (make-ml0-source
             :species :world-bytes
             :acquisition-route :live-query
             :producer-principal "principal:cap2-world-adapter"
             :recorder-principal (format nil "principal:~a" +ml0-lane-stem+)
             :coordinate (rec (entry '("coordinate" "kind")
                                     (s-datum "cap2-world-ledger"))
                              (entry '("coordinate" "ledger-key")
                                     (s-datum (lisp-plus-language-act1:external-request-key
                                               attempt)))
                              (entry '("coordinate" "ledger-sha")
                                     (s-datum (world-ledger-sha256 world))))
             :observation-scope (make-ml0-scope
                                 :universe universe :status :looked
                                 :detail "MODELLED positive reading (testimony)")
             :origin-as-read "observed"
             :subject-act-id act-id
             :payload-digest (digest-of (s-datum (world-ledger-sha256 world)))
             :frontier-relation "the ledger holds a row under this act's derived external-request identity"
             :observation-interval interval
             :attests :frontier-crossed-for-this-identity)
            (make-ml0-source
             :species :scoped-negative-observation
             :acquisition-route :live-query
             :producer-principal "principal:cap2-world-adapter"
             :recorder-principal (format nil "principal:~a" +ml0-lane-stem+)
             :coordinate (rec (entry '("coordinate" "kind")
                                     (s-datum "cap2-world-ledger-absence"))
                              (entry '("coordinate" "ledger-key")
                                     (s-datum (lisp-plus-language-act1:external-request-key
                                               attempt)))
                              (entry '("coordinate" "witness-mechanism")
                                     (s-datum "MODELLED"))
                              (entry '("coordinate" "procedure-identity")
                                     (s-datum "ml0-commensurable-clash-pair/v2"))
                              (entry '("coordinate" "validation-standing")
                                     (s-datum "MODELLED, not observed")))
             :observation-scope (make-ml0-scope
                                 :universe universe :status :looked
                                 :detail "MODELLED negative reading (testimony)")
             :origin-as-read "observed"
             :subject-act-id act-id
             :payload-digest (digest-of (s-datum (world-ledger-sha256 world)))
             :frontier-relation "no row exists under this act's derived external-request identity"
             :observation-interval interval
             :attests :no-record-for-this-identity))))

(defun ml0-issuance-observation-for (act-id result)
  "THE ISSUANCE DOOR, driven from an act1-result: it hands the door the evidence
the act actually produced AND the act's canonical request, so the door can use
Core /0's CONJOINED predicate — issuance conjoined with the request binding, which
Core /0's own docstring calls the whole operation.

⚠ THIS REPLACES EVERY `:issuance-standing :issued-in-writing-image` IN THE SUITES.
Those were caller-picked keywords; this is a reading.  Where the reading comes back
false, the standing is :unresolved and the suites say so — which is the difference
the repair exists to make."
  (ml0-observe-issuance
   (ml0-subject-for-act-id act-id)
   (lisp-plus-language-act1:act1-result-evidence result)))

(defun ml0-effect-observation-of (attempt &key (store *ml0-act-store*)
                                               (world (ml0-world)))
  "The SCOPED OBSERVATION of the adopted external-effect axis: capability /2's
fold-derived standing AS READ, the adopted determinacy vocabulary, and the
world's own digest.  ⚠ IT CARRIES AN OBSERVATION, NEVER THE STANDING ITSELF."
  (let ((standing (derive-effect-standing store attempt)))
    (make-ml0-effect-observation
     :standing-as-read (string-downcase (symbol-name standing))
     :determinacy (case standing
                    ((:settled :reconciled :absent) :determinate)
                    ((:uncertain-unresolved) :bounded)
                    (t :indeterminate))
     :world-digest (world-cells-sha256 world)
     :scope (make-ml0-scope
             :universe "capability /2's fold over the journal's validated prefix, plus the world's cell store"
             :status :looked
             :detail "derive-effect-standing over durable bytes; world-cells-sha256 over the world's own file"))))

;;; ---------------------------------------------------------------------------
;;; A run-root guard shared by every suite.

(defun ml0-fresh-run-root (stem subject-root)
  "A run root in /tmp, REFUSED if it falls inside the subject tree.  A suite that
writes into the checkout cannot claim the checkout is unchanged afterwards."
  (let ((root (pathname (concatenate 'string
                                     (sb-posix:mkdtemp
                                      (concatenate 'string "/tmp/" stem "-XXXXXX"))
                                     "/"))))
    (unless (null (search (namestring (truename subject-root)) (namestring root)))
      (format t "~&RUN ROOT IS INSIDE THE SUBJECT TREE — refusing to write.~%")
      (sb-ext:exit :code 3))
    root))
