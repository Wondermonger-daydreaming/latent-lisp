;;;; ml0-selftest.lisp — Memory Layer /0: the lane's own checks.
;;;;
;;;;   sbcl --script mneme/memory-layer-0/ml0-selftest.lisp
;;;;
;;;; Sentinel: ml0-selftest: N checks, 0 failures
;;;;
;;;; ONE PROCESS LIFE, declared and CHECKED (the W-ENV pre-flight).  The
;;;; cross-process demonstrations belong to de-actu-memorato and are not
;;;; simulated here: a suite that pretended to cross a process boundary in one
;;;; image would be exactly the counterfeit this lane exists to refuse.
;;;;
;;;; CANDIDATE.  Nothing here is adopted, and nothing here is independent
;;;; verification.
;;;;
;;;; — TABULARIUS (Claude Opus 5, subagent), 2026-08-20

(require :sb-posix)
(require :sb-introspect)

(load (merge-pathnames "ml0-suite-ground.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))
;; ⚑ R4: ONE check below needs the mutant rule to show that a refusal is THE
;; RULE'S DOING and not the fixture's.  It used to pass a public `:defect`
;; keyword; the seam is gone from the lane and the collapse now comes from an
;; overlay `load.lisp` never loads.
(load (merge-pathnames "ml0-mutant-overlay.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-memory-layer0)

(defparameter *lane-directory*
  (make-pathname :name nil :type nil :defaults *load-truename*))
(defparameter *subject-root* (merge-pathnames "../../" *lane-directory*))

(format t "~&Memory Layer /0 — SELFTEST.  CANDIDATE; nothing here is adopted, and ~
nothing here is independent verification.~%~%")

(unless (ml0-env-preflight :signal nil)
  (format t "~&ml0-selftest: VOID — a process-ending switch is set.~%")
  (sb-ext:exit :code 4))
(terpri)

(defvar *root* (ml0-fresh-run-root "ml0-selftest" *subject-root*))

;;; ⚠ THE RUN'S VARIABLES ARE DECLARED AT TOP LEVEL AND ASSIGNED BELOW.
;;; `defparameter` INSIDE the unwind-protect would be one top-level form,
;;; so every later reference in that form compiles against an undefined
;;; variable and SBCL warns — and a gate whose own transcript is full of
;;; compiler noise is a gate nobody reads.
(defvar *settled* nil)
(defvar *refused* nil)
(defvar *settled-result* nil)
(defvar *settled-act-id* nil)
(defvar *world-src* nil)
(defvar *journal-src* nil)
(defvar *self-src* nil)
(defvar *settled-bundle* nil)
(defvar *account* nil)
(defvar *refused-frames-before* nil)
(defvar *refused-world-before* nil)
(defvar *refused-result* nil)
(defvar *refused-world-after* nil)
(defvar *refused-evidence* nil)
(defvar *refused-act-id* nil)
(defvar *issuance-src* nil)
(defvar *issuance-only-account* nil)
(defvar *retrieved* nil)
(defvar *issuance-only-2* nil)

(unwind-protect
     (progn
       (ml0-ground *root* :verbose t)

       ;;; ==================================================================
       ;;; §A — the closed vocabularies.  A vocabulary that is not checked is a
       ;;; comment.
       ;;; ==================================================================
       (format t "~&~%---- §A the closed vocabularies ----~%")

       (ml0-check "the source-species set has exactly SEVEN members, counted"
                  (= 7 (length +ml0-source-species+)) "~s" +ml0-source-species+)
       (ml0-check "exactly THREE species may warrant occurrence, and they are ~
the three that read facts a mint cannot make true"
                  (equal +ml0-occurrence-species+
                         '(:kernel-mediated-journal :world-bytes
                           :reconciliation-conjunction)))
       (ml0-check "the occurrence species are a SUBSET of the closed species set"
                  (every (lambda (s) (member s +ml0-source-species+))
                         +ml0-occurrence-species+))
       (ml0-check "core0 issuance testimony is NOT an occurrence species — the ~
whole commission, in one MEMBER test"
                  (not (member :core0-issuance-testimony +ml0-occurrence-species+)))
       (ml0-check "a lane self-report is NOT an occurrence species either: the ~
species this lane's own accounts belong to may never be their own warrant"
                  (not (member :lane-self-report +ml0-occurrence-species+)))
       (ml0-check "the acquisition ratchet is exactly {:live-query :reconstructed}"
                  (equal +ml0-acquisition-routes+ '(:live-query :reconstructed)))
       (ml0-check "the issuance vocabulary is exactly TWO — ~
:issued-in-writing-image | :unresolved — and NOTHING named `not-issued` is on ~
it, scoped or otherwise (work order AMENDMENT 1.1: a scope narrows a claim a ~
looker was competent to make; it cannot manufacture the competence)"
                  (and (equal +ml0-issuance-standings+
                              '(:issued-in-writing-image :unresolved))
                       (notany (lambda (k) (search "NOT-ISSUED" (symbol-name k)))
                               +ml0-issuance-standings+)))
       (ml0-check "record coverage is a SEPARATE vocabulary on a SEPARATE field, ~
and it is where `no issuance record in THIS store` lawfully lives"
                  (and (= 3 (length +ml0-record-coverages+))
                       (member :no-issuance-record-in-account-store
                               +ml0-record-coverages+)
                       (notany (lambda (k) (member k +ml0-issuance-standings+))
                               +ml0-record-coverages+)))
       (ml0-check "the :OCCURRED proposition is PINNED as a declared constant, and ~
it names a PROTECTED EFFECT rather than an invocation"
                  (and (search "protected effect" +ml0-occurred-proposition+)
                       (search "derived external-request identity"
                               +ml0-occurred-proposition+)
                       (not (search "perform was invoked" +ml0-occurred-proposition+))))
       (ml0-check "the promotion rule has NINE legs, each with its own requirement ~
id, and the FIRST is :VALIDATION [ML0-PROMOTE-0] — the leg added in the repair ~
round, which asks whether anyone looked.  The other eight ask what a caller wrote"
                  (and (= 9 (length +ml0-promotion-legs+))
                       (eq :validation (car (first +ml0-promotion-legs+)))
                       (equal "ML0-PROMOTE-0" (cdr (first +ml0-promotion-legs+)))
                       (every (lambda (pair) (search "ML0-PROMOTE-" (cdr pair)))
                              +ml0-promotion-legs+)))
       (ml0-check "record coverage is a SEPARATE vocabulary on a SEPARATE field, ~
and it is where `no issuance record in THIS store` lawfully lives"
                  (and (= 3 (length +ml0-record-coverages+))
                       (member :no-issuance-record-in-account-store
                               +ml0-record-coverages+)
                       (notany (lambda (k) (member k +ml0-issuance-standings+))
                               +ml0-record-coverages+)))
       (ml0-check "the :OCCURRED proposition is PINNED as a declared constant, and ~
it names a PROTECTED EFFECT rather than an invocation"
                  (and (search "protected effect" +ml0-occurred-proposition+)
                       (search "derived external-request identity"
                               +ml0-occurred-proposition+)
                       (not (search "perform was invoked" +ml0-occurred-proposition+))))
       (ml0-check "the occurrence vocabulary is exactly four, with :unresolved ~
present as the lawful default"
                  (and (= 4 (length +ml0-occurrence-standings+))
                       (member :unresolved +ml0-occurrence-standings+)))
       (ml0-check "the effect determinacies are Architecture 0.1 §6.8's three, ~
verbatim and not re-spelled"
                  (equal +ml0-effect-determinacies+
                         '(:determinate :bounded :indeterminate)))

       ;;; ==================================================================
       ;;; §B — the ORIGIN GATE and the ratchet, in code.
       ;;; ==================================================================
       (format t "~&~%---- §B the origin gate and the ratchet ----~%")

       (ml0-check "origin/observed is UNMINTABLE by this lane: the identifier ~
constructor itself refuses it"
                  (handler-case (progn (idf '("origin" "observed")) nil)
                    (ml0-provenance-incomplete (c)
                      (string= "ML0-ORIGIN-1" (ml0-condition-requirement-id c)))))
       (ml0-check "origin/self-reported IS mintable — the gate is narrow, not a ~
blanket refusal of every origin"
                  (lisp-plus-cd0:identifier-datum-p (idf '("origin" "self-reported"))))
       (ml0-check "the ratchet renders both lawful routes"
                  (and (lisp-plus-cd0:identifier-datum-p
                        (ml0-acquisition-route-identifier :live-query))
                       (lisp-plus-cd0:identifier-datum-p
                        (ml0-acquisition-route-identifier :reconstructed))))
       (ml0-check "the ratchet REFUSES :observed as a caller error, in code — a ~
fold-derived answer can never be an observation"
                  (handler-case (progn (ml0-acquisition-route-identifier :observed) nil)
                    (type-error () t)
                    (error () t)))

       ;;; ==================================================================
       ;;; §C — the act, performed once through One Act /1's public seam.
       ;;; ==================================================================
       (format t "~&~%---- §C the act (One Act /1's public seam) ----~%")

       (setf *settled* (ml0-settled-row))
       (setf *refused* (ml0-refused-row))
       (setf lisp-plus-language-act1:*act1-fixture-table*
             (list *settled* *refused*))
       (ml0-open-authority (list *settled* *refused*))

       (setf *settled-result*
         (lisp-plus-language-act1:run-act1 *settled* :verbose nil))
       (setf *settled-act-id*
         (nth-value 0 (ml0-rederive-act-identity *settled*)))

       (ml0-check "the settled act SETTLED, and the identity this lane ~
RE-DERIVES from the declared row alone is byte-equal to the one the act carried"
                  (and (eq :settled (lisp-plus-language-act1:act1-result-class
                                     *settled-result*))
                       (same-datum-p
                        *settled-act-id*
                        (lisp-plus-language-act1:act1-record-act-id
                         (lisp-plus-language-act1:act1-result-record
                          *settled-result*)))))
       (ml0-check "re-derivation PERFORMED NOTHING: the journal's frame count and ~
the world's ledger count are the same before and after a second re-derivation"
                  (let ((frames (nth-value 1 (act1-journal-kinds *ml0-act-store*)))
                        (rows (world-ledger-count (ml0-world))))
                    (ml0-rederive-act-identity *settled*)
                    (ml0-rederive-act-identity *settled*)
                    (and (eql frames (nth-value 1 (act1-journal-kinds *ml0-act-store*)))
                         (eql rows (world-ledger-count (ml0-world))))))

       ;;; ==================================================================
       ;;; §D — the promotion rule.
       ;;; ==================================================================
       (format t "~&~%---- §D the promotion rule ----~%")

       (setf *world-src* (ml0-world-source *settled-act-id* "a-prima"))
       (setf *journal-src* (ml0-journal-source *settled-act-id* "a-prima"))
       (setf *self-src*
         (ml0-self-report-source *settled-act-id* "the lane says the act settled"))

       (ml0-check "the FOUR VALIDATION STANDINGS are closed, and only a DOOR (or a ~
VALIDATED RETRIEVE) can mint a warranting one: the public testimony door REFUSES ~
to be handed a validation standing at all"
                  (and (equal +ml0-source-validations+
                              '(:validated-by-door :asserted-testimony :stored-assertion
                                :inherited-from-validated-record))
                       (= 5 (length +ml0-observation-doors+))
                       (handler-case
                           (progn (make-ml0-source
                                   :species :world-bytes :acquisition-route :live-query
                                   :producer-principal "p" :recorder-principal "r"
                                   :coordinate (rec (entry '("coordinate" "kind")
                                                           (s-datum "x")))
                                   :observation-scope
                                   (make-ml0-scope :universe "u" :status :looked
                                                   :detail "d")
                                   :origin-as-read "observed"
                                   :subject-act-id *settled-act-id*
                                   :payload-digest (make-string 64 :initial-element #\a)
                                   :frontier-relation "f"
                                   :observation-interval "i"
                                   :attests :frontier-crossed-for-this-identity
                                   :validation-standing :validated-by-door)
                                  nil)
                         (ml0-condition (c)
                           (equal "ML0-SRC-11" (ml0-condition-requirement-id c))))))
       (ml0-check "and a row from the PUBLIC TESTIMONY DOOR cannot warrant ~
occurrence however perfect its other fields — leg 0 alone refuses it, and the ~
other eight all hold"
                  (let* ((forged (make-ml0-source
                                  :species :world-bytes
                                  :acquisition-route :live-query
                                  :producer-principal "principal:cap2-world-adapter"
                                  :recorder-principal "principal:memorylayer0"
                                  :coordinate (rec (entry '("coordinate" "kind")
                                                          (s-datum "cap2-world-ledger")))
                                  :observation-scope
                                  (make-ml0-scope :universe "asserted, not looked at"
                                                  :status :looked :detail "asserted")
                                  :origin-as-read "observed"
                                  :subject-act-id *settled-act-id*
                                  :payload-digest (make-string 64 :initial-element #\c)
                                  :frontier-relation "asserted"
                                  :observation-interval "asserted"
                                  :attests :frontier-crossed-for-this-identity))
                         (conjuncts (ml0-occurrence-conjuncts *settled-act-id* forged)))
                    (multiple-value-bind (leg requirement) (ml0-failing-leg conjuncts)
                      (and (eq :validation leg)
                           (equal "ML0-PROMOTE-0" requirement)
                           (= 8 (count-if #'cdr conjuncts))
                           (not (ml0-occurrence-warranted-p *settled-act-id*
                                                            (list forged)))))))
       (ml0-check "a WORLD-BYTES source warrants occurrence: the ledger row under ~
this act's derived external-request identity is a fact a mint cannot make true"
                  (ml0-occurrence-warranted-p *settled-act-id* (list *world-src*)))
       (ml0-check "a KERNEL-MEDIATED-JOURNAL source warrants occurrence"
                  (ml0-occurrence-warranted-p *settled-act-id* (list *journal-src*)))
       (ml0-check "a LANE-SELF-REPORT source does NOT warrant occurrence, alone or ~
in any number: asserted testimony stays asserted"
                  (not (ml0-occurrence-warranted-p
                        *settled-act-id*
                        (list *self-src* *self-src* *self-src*))))
       (ml0-check "the rule NAMES the source that warranted, so a reader never has ~
to guess which leg carried the weight"
                  (multiple-value-bind (ok source reason)
                      (ml0-occurrence-warranted-p *settled-act-id*
                                                  (list *self-src* *world-src*))
                    (and ok (eq :world-bytes (ml0-source-species source))
                         (plusp (length reason)))))
       (ml0-check "the rule refuses a source whose SUBJECT IDENTITY is another ~
act's, even when its species is admitted"
                  (let ((other (nth-value 0 (ml0-rederive-act-identity *refused*))))
                    (not (ml0-occurrence-warranted-p other (list *world-src*)))))
       (ml0-check "the rule refuses an admitted species whose scope status is ~
:COULD-NOT-LOOK — a failed look is not a weaker look, it is not a look"
                  (not (ml0-occurrence-warranted-p
                        *settled-act-id*
                        (list (make-ml0-source
                               :species :world-bytes :acquisition-route :live-query
                               :producer-principal "principal:cap2-world-adapter"
                               :recorder-principal "principal:memorylayer0"
                               :coordinate (rec (entry '("coordinate" "kind")
                                                       (s-datum "blind")))
                               :observation-scope
                               (make-ml0-scope :universe "the world ledger"
                                               :status :could-not-look
                                               :detail "the file could not be opened")
                               :observation-interval "blind/no-interval"
                               :attests :frontier-crossed-for-this-identity
                               :origin-as-read "observed"
                               :subject-act-id *settled-act-id*
                               :payload-digest (digest-of (s-datum "blind"))
                               :frontier-relation "unknown")))))
       (ml0-check "an EMPTY source list warrants nothing, and says so without ~
signalling: :unresolved is a lawful answer, never an error"
                  (and (not (ml0-occurrence-warranted-p *settled-act-id* '()))
                       (eq :unresolved
                           (ml0-derive-occurrence-standing *settled-act-id* '()))))

       ;;; ==================================================================
       ;;; §E — WRITE.
       ;;; ==================================================================
       (format t "~&~%---- §E write ----~%")

       (setf *settled-bundle*
         (make-ml0-bundle
          :fixture-row *settled*
          :claimed-act-id *settled-act-id*
          :subject-principal *suite-actor*
          ;; ⚑ THE LAWFUL SHAPE AFTER THE REPAIR: what a door read goes in
          ;; :OBSERVATIONS, what this lane merely says goes in :SOURCES.  The
          ;; promotion rule reads the stamp either way — the two keywords are for
          ;; the reader of this code, not for the rule.
          :observations (list (ml0-world-observation *settled-act-id* "a-prima")
                              (ml0-journal-observation *settled-act-id* "a-prima"))
          :sources (list *self-src*)
          :issuance-observation (ml0-issuance-observation-for *settled-act-id*
                                                      *settled-result*)
          :effect-observation (ml0-effect-observation-of "a-prima")))

       (setf *account* (ml0-write *ml0-account-store* *settled-bundle*))
       (ml0-render-account *account*)

       (ml0-check "WRITE produced an account whose occurrence standing is ~
:OCCURRED, computed by the rule and not asserted by the caller"
                  (and (ml0-account-p *account*)
                       (eq :occurred (ml0-account-occurrence-standing *account*))
                       (ml0-account-occurred-p *account*)))
       (ml0-check "the account's ISSUANCE standing is :ISSUED and sits in its OWN ~
field — the two axes are separately readable"
                  (and (eq :issued-in-writing-image (ml0-account-issuance-standing *account*))
                       (not (eq (ml0-account-issuance-standing *account*)
                                (ml0-account-occurrence-standing *account*)))))
       (ml0-check "the account's act identity is the RE-DERIVED one, byte-equal"
                  (same-datum-p (ml0-account-act-id *account*) *settled-act-id*))
       (ml0-check "the account identity is 64 hex and lives in kernel domain ~
:CLAIM — an account is a CLAIM ABOUT an act, never the act"
                  (and (hex64-p (ml0-account-id-hex *account*))
                       (eq :claim (lisp-plus-kernel0:durable-identity-domain
                                   (ml0-account-id *account*)))))
       (ml0-check "recorder and subject principals are DIFFERENT and both present"
                  (and (search "memorylayer0" (ml0-account-recorder-principal *account*))
                       (search *suite-actor* (ml0-account-subject-principal *account*))
                       (not (string= (ml0-account-recorder-principal *account*)
                                     (ml0-account-subject-principal *account*)))))
       (ml0-check "the account carries all four sources, with their species intact ~
— the ISSUANCE DOOR'S OWN ROW is durable too now, because the reading is recorded ~
whatever it said and the STANDING is derived from it rather than asserted beside it"
                  (equal (mapcar #'ml0-source-species (ml0-account-sources *account*))
                         '(:world-bytes :kernel-mediated-journal
                           :core0-issuance-testimony :lane-self-report)))
       (ml0-check "and the three occurrence-capable rows carry a DOOR stamp while ~
the self-report carries testimony — the difference is in the durable bytes.  ⚑ R3: ~
`ml0-write` returns a VALIDATED RETRIEVE, so the door rows come back as ~
:INHERITED-FROM-VALIDATED-RECORD (the frame chain verified, the warrant carried) ~
while the self-report comes back as :STORED-ASSERTION and warrants nothing"
                  (let ((rows (ml0-account-sources *account*)))
                    (and (every (lambda (r) (eq :inherited-from-validated-record
                                                (ml0-source-validation-standing r)))
                                (subseq rows 0 3))
                         (eq :stored-assertion
                             (ml0-source-validation-standing (fourth rows)))
                         (not (ml0-source-warranting-validation-p (fourth rows)))
                         (eq :validated-by-door
                             (ml0-source-recorded-validation (first rows)))
                         (eq :world-door (ml0-source-door (first rows)))
                         (eq :asserted-testimony
                             (ml0-source-recorded-validation (fourth rows))))))
       (ml0-check "the effect observation is a SCOPED OBSERVATION of the adopted ~
external-effect axis, with its determinacy from the adopted three"
                  (let ((obs (ml0-account-effect-observation *account*)))
                    (and (string= "settled"
                                  (ml0-effect-observation-standing-as-read obs))
                         (member (ml0-effect-observation-determinacy obs)
                                 +ml0-effect-determinacies+)
                         (eq :looked (ml0-scope-status
                                      (ml0-effect-observation-scope obs))))))
       (ml0-check "the durable frame's envelope carries origin:self-reported and ~
witness:lane-self-report — this lane never claims to have witnessed"
                  (let* ((report (validate-journal *ml0-account-store*))
                         (event (aref (prefix-report-events report) 0)))
                    (and (string= "origin:self-reported"
                                  (identifier-segment-string
                                   (record-field event "event" "origin")))
                         (string= "witness:lane-self-report"
                                  (identifier-segment-string
                                   (record-field event "event" "capture-mechanism")))
                         (string= "boundary:memory-accounting"
                                  (identifier-segment-string
                                   (record-field event "event" "capture-boundary"))))))
       (ml0-check "the durable frame's recorder principal is memorylayer0 and its ~
subject principal is the ACTOR — recorder is never subject"
                  (let* ((report (validate-journal *ml0-account-store*))
                         (event (aref (prefix-report-events report) 0)))
                    (and (string= "principal:memorylayer0"
                                  (identifier-segment-string
                                   (record-field event "event" "recorder-principal")))
                         (string= (format nil "principal:~a" *suite-actor*)
                                  (identifier-segment-string
                                   (record-field event "event" "subject-principal"))))))

       ;;; ==================================================================
       ;;; §F — the crown negative, in one image.  (The cross-process legs are
       ;;; de-actu-memorato's.)
       ;;; ==================================================================
       (format t "~&~%---- §F the crown negative: issued evidence, no occurred act ----~%")

       (setf *refused-frames-before*
         (nth-value 1 (act1-journal-kinds *ml0-act-store*)))
       (setf *refused-world-before*
         (lisp-plus-language-act1:take-world-scope
          (ml0-world) (ml0-world-directory)
          :request-key (lisp-plus-language-act1:external-request-key "a-secunda")))
       (setf *refused-result*
         (lisp-plus-language-act1:run-act1 *refused* :verbose nil))
       (setf *refused-world-after*
         (lisp-plus-language-act1:take-world-scope
          (ml0-world) (ml0-world-directory)
          :request-key (lisp-plus-language-act1:external-request-key "a-secunda")))
       (setf *refused-evidence*
         (lisp-plus-language-act1:act1-result-evidence *refused-result*))
       (setf *refused-act-id*
         (nth-value 0 (ml0-rederive-act-identity *refused*)))

       (ml0-check "THE DANGEROUS ARTIFACT EXISTS, LAWFULLY: a pre-frontier ~
refusal issued a GENUINE Core /0 evidence account, bound to THIS act's canonical ~
request (issuance site 1 of 4, core0.lisp:1059-1082)"
                  (and (lisp-plus-core0:core0-evidence-p *refused-evidence*)
                       (lisp-plus-core0:core0-evidence-current-image-issued-p
                        *refused-evidence*)
                       (lisp-plus-core0:core0-evidence-current-image-issued-for-request-p
                        *refused-evidence*
                        (lisp-plus-language-act1:act1-record-normal-form
                         (lisp-plus-language-act1:act1-result-record
                          *refused-result*)))))
       (ml0-check "AND THE ACT DID NOT HAPPEN, measured by three independent ~
instruments: the journal's frame count is unmoved, the derived standing is ~
:ABSENT, and the world is byte-unchanged across the whole declared universe"
                  (and (eql *refused-frames-before*
                            (nth-value 1 (act1-journal-kinds *ml0-act-store*)))
                       (eq :absent (derive-effect-standing *ml0-act-store* "a-secunda"))
                       (lisp-plus-language-act1:world-scope-unchanged-p
                        *refused-world-before* *refused-world-after*)))
       (lisp-plus-language-act1:print-world-scope-universe
        "the refused act" *refused-world-before* *refused-world-after*)

       (setf *issuance-src*
         (ml0-issuance-source *refused-act-id* *refused-evidence*))
       (setf *issuance-only-account*
         (ml0-write *ml0-account-store*
                    (make-ml0-bundle
                     :fixture-row *refused*
                     :claimed-act-id *refused-act-id*
                     :subject-principal *suite-actor*
                     :sources (list *issuance-src*)
                     :issuance-observation (ml0-issuance-observation-for *refused-act-id*
                                                         *refused-result*)
                     :effect-observation (ml0-effect-observation-of "a-secunda"))))
       (ml0-render-account *issuance-only-account*)

       (ml0-check "PRESENTED TO WRITE AS THOUGH IT WARRANTED OCCURRENCE, the ~
genuinely-issued account is stored as ISSUANCE-ONLY with occurrence :UNRESOLVED ~
— and NO PUBLIC READER ANSWERS OCCURRED"
                  (and (eq :unresolved
                           (ml0-account-occurrence-standing *issuance-only-account*))
                       (not (ml0-account-occurred-p *issuance-only-account*))
                       (ml0-account-issuance-only-p *issuance-only-account*)
                       (eq :issued-in-writing-image
                           (ml0-account-issuance-standing *issuance-only-account*))))
       (ml0-check "the SAME identity is on both sides of the refusal — the crown ~
negative turns on the SPECIES leg, not on an identity mismatch that could mask it"
                  (and (same-datum-p (ml0-source-subject-act-id *issuance-src*)
                                     *refused-act-id*)
                       (same-datum-p (ml0-account-act-id *issuance-only-account*)
                                     *refused-act-id*)))
       (ml0-check "the issuance coordinate now records THE DOOR'S OWN READING — the ~
live predicate's answer and whether it was conjoined with the caller-held request ~
— and still carries the projection, which declares itself a CALLER-SUPPLIED ~
PROJECTION and never pretends to be the evidence account's canonical content digest"
                  (let ((coordinate (ml0-source-coordinate *issuance-src*)))
                    (and (string= "core0-issuance-reading"
                                  (lisp-plus-cd0:string-datum-value
                                   (record-field coordinate "coordinate" "kind")))
                         (member (lisp-plus-cd0:string-datum-value
                                  (record-field coordinate "coordinate" "predicate-answer"))
                                 '("true" "false") :test #'string=)
                         (string= "caller-supplied-projection"
                                  (lisp-plus-cd0:string-datum-value
                                   (record-field
                                    (record-field coordinate "coordinate" "projection")
                                    "projection" "basis"))))))
       (ml0-check "and with the MUTANT rule, the very same sources DO promote — so ~
the refusal above is THE RULE'S DOING and not the fixture's.  A negative that ~
would hold under a diseased rule too proves nothing"
                  (with-ml0-mutant (:issuance-implies-occurrence)
                    (ml0-occurrence-warranted-p *refused-act-id*
                                                (list *issuance-src*))))
       (ml0-check "the issuance source attests :INCONCLUSIVE, honestly — a mint is ~
not a finding about a frontier — so the cured rule refuses it on leg (1) AND on ~
leg (8), independently"
                  (and (eq :inconclusive (ml0-source-attests *issuance-src*))
                       (not (ml0-species-may-warrant-occurrence-p
                             :core0-issuance-testimony))))

       ;;; ==================================================================
       ;;; §G — RETRIEVE (evidence replay).
       ;;; ==================================================================
       (format t "~&~%---- §G retrieve: evidence replay ----~%")

       (setf *retrieved*
         (ml0-retrieve *ml0-account-store*
                       :account-hex (ml0-account-id-hex *account*)))

       (ml0-check "the retrieved account is byte-identical in identity to the one ~
written, and every standing survived the round trip"
                  (and (string= (ml0-account-id-hex *retrieved*)
                                (ml0-account-id-hex *account*))
                       (eq (ml0-account-occurrence-standing *retrieved*)
                           (ml0-account-occurrence-standing *account*))
                       (eq (ml0-account-issuance-standing *retrieved*)
                           (ml0-account-issuance-standing *account*))))
       (ml0-check "provenance survived intact: same species, same routes, same ~
payload digests, same scopes"
                  (and (equal (mapcar #'ml0-source-species
                                      (ml0-account-sources *retrieved*))
                              (mapcar #'ml0-source-species
                                      (ml0-account-sources *account*)))
                       (equal (mapcar #'ml0-source-payload-digest
                                      (ml0-account-sources *retrieved*))
                              (mapcar #'ml0-source-payload-digest
                                      (ml0-account-sources *account*)))
                       (equal (mapcar (lambda (s) (ml0-scope-universe
                                                   (ml0-source-observation-scope s)))
                                      (ml0-account-sources *retrieved*))
                              (mapcar (lambda (s) (ml0-scope-universe
                                                   (ml0-source-observation-scope s)))
                                      (ml0-account-sources *account*)))))
       (ml0-check "RETRIEVAL RETURNS AN ACCOUNT AND NOTHING ELSE: it is not a ~
core0-evidence, it carries none, and it confers no continuation"
                  (and (ml0-account-p *retrieved*)
                       (not (lisp-plus-core0:core0-evidence-p *retrieved*))
                       (ml0-account-carries-no-current-image-evidence-p *retrieved*)
                       (null (ml0-account-may-continue-p *retrieved*))))
       (ml0-check "THE ORIGIN RATCHET HELD: the retrieval's own origin is ~
:RECONSTRUCTED, and validation success turned no source's route"
                  (and (eq :reconstructed (ml0-account-retrieval-origin *retrieved*))
                       (equal (mapcar #'ml0-source-acquisition-route
                                      (ml0-account-sources *retrieved*))
                              (mapcar #'ml0-source-acquisition-route
                                      (ml0-account-sources *account*)))))
       (ml0-check "reading changed nothing: the account store, the act journal and ~
the world are all byte-unchanged across three retrievals"
                  (let ((store-before (ml0-take-store-scope *ml0-account-root*))
                        (frames-before (nth-value 1 (act1-journal-kinds *ml0-act-store*)))
                        (world-before (lisp-plus-language-act1:take-world-scope
                                       (ml0-world) (ml0-world-directory))))
                    (dotimes (i 3)
                      (ml0-retrieve *ml0-account-store*
                                    :account-hex (ml0-account-id-hex *account*)))
                    (and (ml0-store-scope-unchanged-p
                          store-before (ml0-take-store-scope *ml0-account-root*))
                         (eql frames-before
                              (nth-value 1 (act1-journal-kinds *ml0-act-store*)))
                         (lisp-plus-language-act1:world-scope-unchanged-p
                          world-before (lisp-plus-language-act1:take-world-scope
                                        (ml0-world) (ml0-world-directory))))))
       (ml0-check "the store lists exactly the two accounts written so far, in ~
frame order, over a :VALID prefix with no tail"
                  (multiple-value-bind (hexes count status tail)
                      (ml0-list-account-ids *ml0-account-store*)
                    (and (= 2 (length hexes)) (= 2 count) (eq :valid status)
                         (null tail)
                         (string= (first hexes) (ml0-account-id-hex *account*)))))
       (ml0-check "a retrieval for an identity that is not in the store REFUSES ~
typed, and returns no plausible partial account"
                  (handler-case
                      (progn (ml0-retrieve *ml0-account-store*
                                           :account-hex (make-string 64 :initial-element #\a))
                             nil)
                    (ml0-account-readback-refused (c)
                      (string= "ML0-RB-2" (ml0-condition-requirement-id c)))))

       ;;; ==================================================================
       ;;; §H — CONSOLIDATE.
       ;;; ==================================================================
       (format t "~&~%---- §H consolidate ----~%")

       (setf *issuance-only-2*
         (ml0-write *ml0-account-store*
                    (make-ml0-bundle
                     :fixture-row *refused*
                     :claimed-act-id *refused-act-id*
                     :subject-principal *suite-actor*
                     :sources (list *issuance-src*
                                    (ml0-self-report-source
                                     *refused-act-id*
                                     "a second reading, same act, different note"))
                     :issuance-observation (ml0-issuance-observation-for *refused-act-id*
                                                                         *refused-result*))))

       (ml0-check "ISSUANCE-ONLY + ISSUANCE-ONLY consolidates to :UNRESOLVED — two ~
records are not a warrant, however numerous or durable"
                  ;; R4.1: the result is one ML0-CONSOLIDATION carrier; the two
                  ;; standings this check has always been about are read off it.
                  (let ((c (ml0-consolidate (list *issuance-only-account*
                                                  *issuance-only-2*))))
                    (and (ml0-consolidation-p c)
                         (eq :unresolved (ml0-consolidation-occurrence-standing c))
                         (eq :issued-in-writing-image
                             (ml0-consolidation-issuance-standing c)))))
       (ml0-check "consolidation ORDERS BY CONTENT-DERIVED IDENTITY, not by ~
argument order: both orderings give the same result and the same first input"
                  ;; R4.1: `(nth-value 4 ...)` is now `ml0-consolidation-inputs`.
                  ;; ⚠ under the old API this check compared NIL with NIL after the
                  ;; contract change — it passed vacuously.  The reader restores the
                  ;; comparison it was written to make.
                  (let ((a (ml0-consolidation-inputs
                            (ml0-consolidate
                             (list *issuance-only-account* *issuance-only-2*))))
                        (b (ml0-consolidation-inputs
                            (ml0-consolidate
                             (list *issuance-only-2* *issuance-only-account*)))))
                    (and a b
                         (equal (mapcar #'ml0-account-id-hex a)
                                (mapcar #'ml0-account-id-hex b)))))
       (ml0-check "the SAME account twice is ONE record — an exact duplicate is an ~
exact duplicate"
                  (= 1 (length (ml0-consolidation-inputs
                                (ml0-consolidate
                                 (list *issuance-only-account*
                                       *issuance-only-account*))))))
       (ml0-check "two accounts with DISTINCT PROVENANCE are never collapsed, ~
because distinct provenance gives a distinct content-derived identity"
                  (and (not (string= (ml0-account-id-hex *issuance-only-account*)
                                     (ml0-account-id-hex *issuance-only-2*)))
                       (= 2 (length (ml0-consolidation-inputs
                                     (ml0-consolidate
                                      (list *issuance-only-account*
                                            *issuance-only-2*)))))))
       (ml0-check "CROSS-ACT consolidation is refused BEFORE any output is produced"
                  (handler-case
                      (progn (ml0-consolidate (list *account* *issuance-only-account*))
                             nil)
                    (ml0-consolidation-refused (c)
                      (string= "ML0-CON-2" (ml0-condition-requirement-id c)))))
       (ml0-check "consolidation is EFFECT-FREE: the account store is byte-unchanged ~
across four consolidations"
                  (let ((before (ml0-take-store-scope *ml0-account-root*)))
                    (dotimes (i 4)
                      (ml0-consolidate (list *issuance-only-account* *issuance-only-2*)))
                    (ml0-store-scope-unchanged-p
                     before (ml0-take-store-scope *ml0-account-root*))))
       (ml0-check "a KERNEL-MEDIATED-JOURNAL source over the REFUSED act attests ~
:NO-RECORD-FOR-THIS-IDENTITY, so issuance-only + that source is STILL ~
:UNRESOLVED — an admitted species that found nothing warrants nothing"
                  (let* ((absent-src (ml0-journal-source *refused-act-id* "a-secunda"))
                         (with-absent
                           (ml0-write *ml0-account-store*
                                      (make-ml0-bundle
                                       :fixture-row *refused*
                                       :claimed-act-id *refused-act-id*
                                       :subject-principal *suite-actor*
                                       :sources (list absent-src)))))
                    (and (eq :no-record-for-this-identity (ml0-source-attests absent-src))
                         (eq :unresolved
                             (ml0-consolidation-occurrence-standing
                              (ml0-consolidate
                               (list *issuance-only-account* with-absent)))))))
       (ml0-check "a SCOPED NEGATIVE OBSERVATION over the refused act's complete, ~
authoritative ledger warrants :NONOCCURRED — the four-part warrant, met"
                  (let ((neg (ml0-negative-source *refused-act-id* "a-secunda")))
                    (and (eq :no-record-for-this-identity (ml0-source-attests neg))
                         (ml0-nonoccurrence-warranted-p *refused-act-id* (list neg))
                         (eq :nonoccurred
                             (ml0-derive-occurrence-standing *refused-act-id*
                                                             (list neg))))))
       (ml0-check "the SAME scoped negative with status :COULD-NOT-LOOK warrants ~
NOTHING — looked-and-absent and could-not-look are different answers"
                  (let ((blind (ml0-negative-source *refused-act-id* "a-secunda"
                                                    :status :could-not-look)))
                    (and (not (ml0-nonoccurrence-warranted-p *refused-act-id*
                                                             (list blind)))
                         (eq :unresolved
                             (ml0-derive-occurrence-standing *refused-act-id*
                                                             (list blind))))))
       (ml0-check "ISSUANCE-ONLY + A QUALIFYING BASIS becomes :OCCURRED — and only ~
BECAUSE the qualifying basis is present in the union and named"
                  (let* ((issuance-only-settled
                           (ml0-write *ml0-account-store*
                                      (make-ml0-bundle
                                       :fixture-row *settled*
                                       :claimed-act-id *settled-act-id*
                                       :subject-principal *suite-actor*
                                       :sources (list (ml0-issuance-source
                                                       *settled-act-id*
                                                       (lisp-plus-language-act1:act1-result-evidence
                                                        *settled-result*)))
                                       :issuance-observation (ml0-issuance-observation-for *settled-act-id*
                                                                           *settled-result*))))
                         (with-basis
                           (ml0-write *ml0-account-store*
                                      (make-ml0-bundle
                                       :fixture-row *settled*
                                       :claimed-act-id *settled-act-id*
                                       :subject-principal *suite-actor*
                                       :observations
                                       (list (ml0-world-observation
                                              *settled-act-id* "a-prima"))))))
                    (and (eq :unresolved (ml0-account-occurrence-standing
                                          issuance-only-settled))
                         (let ((c (ml0-consolidate
                                   (list issuance-only-settled with-basis))))
                           (and (eq :occurred
                                    (ml0-consolidation-occurrence-standing c))
                                (eq :issued-in-writing-image
                                    (ml0-consolidation-issuance-standing c))
                                (some (lambda (s)
                                        (and (ml0-species-may-warrant-occurrence-p
                                              (ml0-source-species s))
                                             (eq :frontier-crossed-for-this-identity
                                                 (ml0-source-attests s))))
                                      (ml0-consolidation-sources c)))))))

       ;;; ==================================================================
       ;;; §I — the store-scope instrument's own competence.
       ;;; ==================================================================
       (format t "~&~%---- §I the store-scope instrument ----~%")

       (ml0-check "the instrument LISTS the account store's file set rather than ~
assuming it, and finds the three PJ0 files"
                  (let ((scope (ml0-take-store-scope *ml0-account-root*)))
                    (and (>= (length (ml0-store-scope-files scope)) 3)
                         (member "EVENTS.pj0" (ml0-store-scope-files scope)
                                 :test #'string=)
                         (member "JOURNAL-META.pjs" (ml0-store-scope-files scope)
                                 :test #'string=))))
       (ml0-check "COMPETENCE: the instrument SEES a lawful write between two ~
snapshots — an instrument never seen to fire is untested, not passing"
                  (let* ((before (ml0-take-store-scope *ml0-account-root*))
                         (ignored (ml0-write *ml0-account-store*
                                             (make-ml0-bundle
                                              :fixture-row *settled*
                                              :claimed-act-id *settled-act-id*
                                              :subject-principal *suite-actor*
                                              :sources (list (ml0-self-report-source
                                                              *settled-act-id*
                                                              "competence probe")))))
                         (after (ml0-take-store-scope *ml0-account-root*)))
                    (declare (ignore ignored))
                    (not (ml0-store-scope-unchanged-p before after))))
       ;; ⚠ THE ML0-WR-6 SELF-CONTRADICTION GUARD IS NOW UNREACHABLE, AND THE
       ;; CHECKS BELOW SAY SO RATHER THAN PRETENDING OTHERWISE.  The guard fires
       ;; only on a COMMENSURABLE clash between two WARRANTING rows — and after
       ;; the repair round a row warrants only if a door validated it.  Two
       ;; correct doors reading one universe over one interval agree; a
       ;; disagreement at that resolution means one of them is wrong, and a door
       ;; cannot be made to be wrong on purpose.  So the guard stays in the code
       ;; as defence in depth against a future door that could disagree, and what
       ;; is tested here is the PREDICATE it rests on, exercised directly.
       (ml0-check "the COMMENSURABILITY PREDICATE still discriminates, exercised ~
directly: two rows over the same declared universe and interval ARE commensurable, ~
and the same positive against a different universe is NOT"
                  (multiple-value-bind (positive negative)
                      (ml0-commensurable-clash-pair *settled-act-id* "a-prima")
                    (and (ml0-warrants-commensurable-p positive negative)
                         (not (ml0-warrants-commensurable-p
                               positive
                               (ml0-negative-source *settled-act-id* "a-prima"
                                                    :world (getf *ml0-worlds*
                                                                 :ambiguous)))))))
       (ml0-check "a bundle carrying an INCOMMENSURABLE pair of modelled readings ~
is written, not refused — different declared universes are ordinary bookkeeping"
                  (let* ((positive (nth-value 0 (ml0-commensurable-clash-pair
                                                 *settled-act-id* "a-prima")))
                         (elsewhere-obs (ml0-negative-observation
                                         *settled-act-id* "a-prima"
                                         :world (getf *ml0-worlds* :ambiguous)))
                         (elsewhere (ml0-observation-source elsewhere-obs))
                         (account (ml0-write *ml0-account-store*
                                             (make-ml0-bundle
                                              :fixture-row *settled*
                                              :claimed-act-id *settled-act-id*
                                              :subject-principal *suite-actor*
                                              ;; ⚑ R3: THE WARRANT-BEARING ROW GOES
                                              ;; THROUGH `:OBSERVATIONS`, WHICH IS NOW
                                              ;; THE ONLY CHANNEL THAT CARRIES ONE.
                                              ;; The modelled positive stays in
                                              ;; `:sources`, where it is normalized to
                                              ;; testimony — which is what it always was.
                                              :observations (list elsewhere-obs)
                                              :sources (list positive)))))
                    (and (not (ml0-warrants-commensurable-p positive elsewhere))
                         (ml0-warrants-commensurable-p positive positive)
                         ;; ⚑ AND THE STANDING IS THE SHARPEST PART.  The MODELLED
                         ;; positive is testimony and warrants nothing; the
                         ;; `elsewhere` row came from the ABSENCE DOOR over the
                         ;; ambiguous world and genuinely found no row — so the
                         ;; account reads :NONOCCURRED, on the only warrant in the
                         ;; bundle that anybody actually earned.  Before the repair
                         ;; this same pair produced :OCCURRED, on the modelled row.
                         (eq :validated-by-door
                             (ml0-source-validation-standing elsewhere))
                         (eq :asserted-testimony
                             (ml0-source-validation-standing positive))
                         (eq :nonoccurred
                             (ml0-account-occurrence-standing account)))))
       ;; ⚠ THE TWO FOLDS ARE EXERCISED HERE BECAUSE AN EXPORTED FUNCTION NO GATE
       ;; CALLS IS AN UNTESTED FUNCTION, and this lane's own doctrine about
       ;; instruments applies to its own interface.
       (ml0-check "the ISSUANCE fold: one :ISSUED-IN-WRITING-IMAGE among any ~
number of :UNRESOLVED survives, and all-unresolved stays :UNRESOLVED.  There is ~
no negative member to fold, and its absence is the correction, not an oversight"
                  ;; ⚑ THE TWO STANDINGS ARE NOW EARNED, NOT CHOSEN.  `issued`
                  ;; carries a real issuance-door observation over the settled
                  ;; act's real evidence; `unres` carries none.  The fold is the
                  ;; same; what changed is that neither input's standing was
                  ;; picked by this suite.
                  (let* ((mk (lambda (observation note)
                               (ml0-write *ml0-account-store*
                                          (make-ml0-bundle
                                           :fixture-row *settled*
                                           :claimed-act-id *settled-act-id*
                                           :subject-principal *suite-actor*
                                           :issuance-observation observation
                                           :sources (list (ml0-self-report-source
                                                           *settled-act-id* note))))))
                         (issued (funcall mk (ml0-issuance-observation-for
                                              *settled-act-id* *settled-result*)
                                          "fold probe issued"))
                         (unres (funcall mk nil "fold probe unresolved")))
                    (and (eq :issued-in-writing-image
                             (ml0-fold-issuance (list unres issued unres)))
                         (eq :unresolved (ml0-fold-issuance (list unres unres)))
                         (eq :issued-in-writing-image
                             (ml0-fold-issuance (list issued))))))
       (ml0-check "the RECORD-COVERAGE fold is a SEPARATE function on a SEPARATE ~
field: PRESENT beats ABSENT, unanimous ABSENT survives, and any disagreement ~
below that collapses to :NOT-EXAMINED rather than picking a side"
                  ;; ⚑ R4: THE THREE COVERAGES ARE NO LONGER CHOSEN, THEY ARE
                  ;; READ.  A caller can no longer name a finding (ML0-BND-10), so
                  ;; this check drives the DOOR over a store it can actually
                  ;; change: a fresh, empty account store, scanned before and
                  ;; after an issuance-bearing account is written into it.  That
                  ;; makes it two checks in one — the fold's arithmetic, and BOTH
                  ;; BRANCHES OF THE DOOR SEEN TO FIRE, which is what stops
                  ;; `the door always says absent` from passing as a repair.
                  (let* ((probe-store (build-ml0-account-store
                                       (merge-pathnames "coverage-probe/" *root*)))
                         (subject (ml0-subject-from-fixture-row *settled*))
                         (mk (lambda (observation note)
                               (ml0-write probe-store
                                          (make-ml0-bundle
                                           :fixture-row *settled*
                                           :claimed-act-id *settled-act-id*
                                           :subject-principal *suite-actor*
                                           :sources (list (ml0-self-report-source
                                                           *settled-act-id* note))
                                           :record-coverage-observation observation))))
                         (absent-reading (ml0-observe-record-coverage probe-store
                                                                      subject))
                         (absent (funcall mk absent-reading "coverage probe absent"))
                         (unknown (funcall mk nil "coverage probe unknown"))
                         ;; put a real issuance record INTO the store the door
                         ;; scans, so the second reading has something to find
                         (ignore (ml0-write probe-store
                                            (make-ml0-bundle
                                             :fixture-row *settled*
                                             :claimed-act-id *settled-act-id*
                                             :subject-principal *suite-actor*
                                             :sources (list (ml0-self-report-source
                                                             *settled-act-id*
                                                             "the record the door will find"))
                                             :issuance-observation
                                             (ml0-issuance-observation-for
                                              *settled-act-id* *settled-result*))))
                         (present-reading (ml0-observe-record-coverage probe-store
                                                                       subject))
                         (present (funcall mk present-reading "coverage probe present")))
                    (declare (ignore ignore))
                    (and (eq :no-issuance-record-in-account-store
                             (ml0-record-coverage-observation-finding absent-reading))
                         (eq :issuance-record-present-in-account-store
                             (ml0-record-coverage-observation-finding present-reading))
                         ;; the door's scope is its own, and it says :LOOKED
                         ;; because it did
                         (eq :looked (ml0-scope-status
                                      (ml0-record-coverage-observation-scope
                                       present-reading)))
                         (eq :issuance-record-present-in-account-store
                             (ml0-fold-record-coverage (list absent present)))
                         (eq :no-issuance-record-in-account-store
                             (ml0-fold-record-coverage (list absent absent)))
                         (eq :not-examined
                             (ml0-fold-record-coverage (list absent unknown)))
                         ;; and the two vocabularies share no member, so neither
                         ;; fold can ever answer with the other's word
                         (notany (lambda (k) (member k +ml0-issuance-standings+))
                                 +ml0-record-coverages+))))
       (ml0-check "the store-scope instrument's DECLARED UNIVERSE is the real one: ~
the file set it lists is EXACTLY the three files a PJ0 store holds, compared ~
against an independent listing of the same directory"
                  (let ((instrument (ml0-store-scope-files
                                     (ml0-take-store-scope *ml0-account-root*)))
                        (independent (sort (mapcar #'file-namestring
                                                   (directory
                                                    (merge-pathnames
                                                     "*.*" *ml0-account-root*)))
                                           #'string<)))
                    (and (equal instrument independent)
                         (equal instrument '("EVENTS.pj0" "JOURNAL-META.pjs"
                                             "JOURNAL-META.pjs.sha256")))))
       (ml0-check "a :COULD-NOT-LOOK on either side makes the comparison NIL — the ~
instrument never reads a failed look as an unchanged store"
                  (let ((real (ml0-take-store-scope *ml0-account-root*))
                        (blind (ml0-take-store-scope
                                (merge-pathnames "no-such-directory/" *root*))))
                    (and (not (ml0-store-scope-unchanged-p real blind))
                         (not (ml0-store-scope-unchanged-p blind real)))))

       ;;; ==================================================================
       ;;; §J — THE R3 REPAIR'S OWN SEAMS.  Five checks over the two migrated
       ;;; truth-minting paths the chair's second disposition found.  The block
       ;;; proof exercises them end-to-end; these exercise the mechanisms
       ;;; DIRECTLY, so a refusal that happened for a neighbouring reason cannot
       ;;; pass for the repair.
       ;;; ==================================================================
       (format t "~&~%---- §J the R3 repair's seams ----~%")

       (ml0-check "THE PUBLIC DECODER IS INERT: a record whose OWN validation ~
field says `validated-by-door` decodes to :STORED-ASSERTION and warrants NOTHING ~
— the recorded claim is preserved and is not authority"
                  (let* ((row (ml0-observation-source
                               (ml0-world-observation *settled-act-id* "a-prima")))
                         (decoded (ml0-source-from-record (ml0-source-record row))))
                    (and (eq :validated-by-door
                             (ml0-source-validation-standing row))
                         (ml0-source-warranting-validation-p row)
                         (eq :stored-assertion
                             (ml0-source-validation-standing decoded))
                         (eq :validated-by-door
                             (ml0-source-recorded-validation decoded))
                         (not (ml0-source-warranting-validation-p decoded))
                         (eq :unresolved
                             (ml0-derive-occurrence-standing *settled-act-id*
                                                             (list decoded))))))

       (ml0-check "A DECODED ROW RE-SERIALIZES AS TESTIMONY, so a round trip ~
through the public decoder cannot deposit a door stamp back into durable bytes ~
— the laundering path that survived R2 BECAUSE the round trip was faithful"
                  (let* ((row (ml0-observation-source
                               (ml0-world-observation *settled-act-id* "a-prima")))
                         (decoded (ml0-source-from-record (ml0-source-record row))))
                    (and (string= "validated-by-door"
                                  (lisp-plus-cd0:string-datum-value
                                   (record-field (ml0-source-record row)
                                                 "source" "validation-standing")))
                         (string= "asserted-testimony"
                                  (lisp-plus-cd0:string-datum-value
                                   (record-field (ml0-source-record decoded)
                                                 "source" "validation-standing"))))))

       (ml0-check "RAW DECODE vs VALIDATED RETRIEVE, on the SAME frame: ~
`ml0-account-from-event` yields an account whose every row warrants nothing, ~
while `ml0-retrieve` over the same store inherits the warrant its bytes record ~
— the authority is the frame chain, never the record's own field"
                  (let* ((report (validate-journal *ml0-account-store*))
                         (events (prefix-report-events report))
                         (frame (loop for i below (fill-pointer events)
                                      for e = (aref events i)
                                      when (ml0-account-hex-of-event e) return e))
                         (raw (ml0-account-from-event frame))
                         (validated (ml0-retrieve *ml0-account-store*
                                                  :account-hex
                                                  (ml0-account-hex-of-event frame))))
                    (and (notany #'ml0-source-warranting-validation-p
                                 (ml0-account-sources raw))
                         (some #'ml0-source-warranting-validation-p
                               (ml0-account-sources validated))
                         (string= (ml0-account-id-hex raw)
                                  (ml0-account-id-hex validated)))))

       (ml0-check "THE TESTIMONY CHANNELS NORMALIZE: a door-validated row handed ~
to `:sources` arrives in the account as :STORED-ASSERTION and cannot promote, ~
while the SAME row through `:observations` still reaches :OCCURRED — the ~
discrimination, not a wall"
                  (let* ((observation (ml0-world-observation *settled-act-id*
                                                             "a-prima"))
                         (through-sources
                           (ml0-write *ml0-account-store*
                                      (make-ml0-bundle
                                       :fixture-row *settled*
                                       :claimed-act-id *settled-act-id*
                                       :subject-principal *suite-actor*
                                       :sources (list (ml0-observation-source
                                                       observation)))))
                         (through-observations
                           (ml0-write *ml0-account-store*
                                      (make-ml0-bundle
                                       :fixture-row *settled*
                                       :claimed-act-id *settled-act-id*
                                       :subject-principal *suite-actor*
                                       :observations (list observation)))))
                    (and (eq :unresolved (ml0-account-occurrence-standing
                                          through-sources))
                         (ml0-account-occurred-p through-observations))))

       (ml0-check "THE SUBJECT CARRIER DERIVES ALL FIVE FACTS FROM ONE ROW, and ~
the suite adapter REFUSES to pair one act's identity with another act's attempt ~
— the shape R2-BLOCK 2 was made of"
                  (let ((subject (ml0-subject-from-fixture-row *settled*)))
                    (and (same-datum-p (ml0-subject-act-id subject) *settled-act-id*)
                         (string= "a-prima" (ml0-subject-attempt subject))
                         (string= (lisp-plus-language-act1:external-request-key
                                   "a-prima")
                                  (ml0-subject-external-request-key subject))
                         (ml0-subject-canonical-request subject)
                         (handler-case
                             (progn (ml0-subject-for *refused-act-id* "a-prima") nil)
                           (ml0-condition (c)
                             (equal "ML0-SG-2"
                                    (ml0-condition-requirement-id c)))))))

       ;;; ==================================================================
       ;;; §K — THE R4 REPAIR'S OWN SEAMS.  Five checks over the Codex audit's
       ;;; five findings, exercising the MECHANISMS DIRECTLY, so a refusal that
       ;;; happened for a neighbouring reason cannot pass for the repair.
       ;;; ==================================================================
       (format t "~&~%---- §K the R4 repair's seams ----~%")

       (ml0-check "F1 · NO EXTERNAL FUNCTION of this lane carries a `defect` or ~
`defect-payload` parameter, read out of the COMPILED LAMBDA LISTS rather than out ~
of the source text.  ⚠ THIS PROCESS HAS THE MUTANT OVERLAY LOADED, and the answer ~
is still none — the overlay redefines whole functions and widens no arglist"
                  (let ((offenders '()))
                    (do-external-symbols (symbol (find-package
                                                  '#:lisp-plus-memory-layer0))
                      (when (fboundp symbol)
                        (when (some (lambda (item)
                                      (and (symbolp item)
                                           (member (symbol-name item)
                                                   '("DEFECT" "DEFECT-PAYLOAD")
                                                   :test #'string=)))
                                    (handler-case
                                        (sb-introspect:function-lambda-list symbol)
                                      (error () nil)))
                          (push symbol offenders))))
                    (null offenders)))

       (ml0-check "F2 · the RAW decode declares its own authority and RE-DERIVES: ~
`ml0-account-from-event` over the very frame `ml0-retrieve` reads yields ~
:RAW-DECODE authority and a standing computed from rows that warrant nothing, ~
while the SAME bytes through the validated route keep the standing a verified ~
frame chain put there — and the bytes\' own claim is preserved either way"
                  (let* ((report (validate-journal *ml0-account-store*))
                         (events (prefix-report-events report))
                         (hex (ml0-account-id-hex *account*))
                         (event (loop for i below (fill-pointer events)
                                      for e = (aref events i)
                                      when (equal hex (ml0-account-hex-of-event e))
                                        return e))
                         (validated (ml0-retrieve *ml0-account-store*
                                                  :account-hex hex))
                         (raw (ml0-account-from-event event)))
                    (and (eq :validated-retrieval
                             (ml0-account-standing-authority validated))
                         (eq :raw-decode (ml0-account-standing-authority raw))
                         (ml0-account-occurred-p validated)
                         (not (ml0-account-occurred-p raw))
                         (eq :unresolved (ml0-account-occurrence-standing raw))
                         ;; nothing is erased: both carry what the bytes said
                         (eq :occurred (getf (ml0-account-carried-standings raw)
                                             :occurrence-standing))
                         (equal (ml0-account-carried-standings validated)
                                (ml0-account-carried-standings raw))
                         ;; and the identity check is not SKIPPED for an
                         ;; unrecognized frame — it refuses
                         (handler-case
                             (progn (ml0-account-from-event
                                     (rec (entry '("event" "body")
                                                 (ml0-account-body-record raw))
                                          (entry '("event" "event-id")
                                                 (idf '("foreign" "shape")))))
                                    nil)
                           (ml0-condition (c)
                             (equal "ML0-RB-11"
                                    (ml0-condition-requirement-id c)))))))

       (ml0-check "F3 · record coverage is DOOR-ONLY: a caller supplying either ~
the finding or its scope is REFUSED at ML0-BND-10 — not silently dropped — and ~
the door\'s own reading carries the scope THE SCAN wrote"
                  (let ((mk (lambda (&rest arguments)
                              (handler-case
                                  (progn (apply #'make-ml0-bundle
                                                :fixture-row *settled*
                                                :claimed-act-id *settled-act-id*
                                                :subject-principal *suite-actor*
                                                :sources (list (ml0-self-report-source
                                                                *settled-act-id* "k3"))
                                                arguments)
                                         nil)
                                (ml0-condition (c)
                                  (ml0-condition-requirement-id c))))))
                    (and (equal "ML0-BND-10"
                                (funcall mk :record-coverage
                                         :issuance-record-present-in-account-store))
                         (equal "ML0-BND-10"
                                (funcall mk :record-coverage :not-examined))
                         (equal "ML0-BND-10"
                                (funcall mk :record-coverage-scope
                                         (make-ml0-scope :universe "u" :status :looked
                                                         :detail "d")))
                         (equal "ML0-BND-11"
                                (funcall mk :record-coverage-observation :not-an-observation))
                         ;; and a bundle with NO observation is :not-examined with
                         ;; no scope at all — the honest default
                         (eq :not-examined
                             (ml0-bundle-record-coverage
                              (make-ml0-bundle
                               :fixture-row *settled*
                               :claimed-act-id *settled-act-id*
                               :subject-principal *suite-actor*
                               :sources (list (ml0-self-report-source
                                               *settled-act-id* "k3b"))))))))

       (ml0-check "F4 · `ml0-write` no longer claims whole-store non-mutation on ~
failure, and DOES name its verified-after-append semantics in its own docstring — ~
the prose is checked by code, because prose is exactly what was wrong.  ⚠ READ ~
OFF THE SAVED PRODUCTION FUNCTION, because this process has the overlay loaded ~
and the overlay's wrapper carries no docstring — the same check runs against an ~
overlay-free image as ml0-block-proof probe F4"
                  (let ((doc (or (documentation (%ml0-prod :write) t) "")))
                    (and (null (search "non-mutating over" doc))
                         (search "VERIFIED AFTER THE APPEND" doc)
                         t)))

       (ml0-check "F5 · the effect axis is marked CALLER-ASSERTED in the type AND ~
in the durable bytes, the mark is not a parameter a caller can set, and bytes ~
claiming any other provenance are REFUSED rather than best-effort decoded"
                  (let* ((observation (make-ml0-effect-observation
                                       :standing-as-read "caller invented standing"
                                       :determinacy :determinate
                                       :world-digest (make-string 64 :initial-element #\a)
                                       :scope (make-ml0-scope :universe "the world"
                                                              :status :looked
                                                              :detail "asserted")))
                         (record (ml0-effect-observation-record observation))
                         (forged (rec (entry '("effect" "provenance") (s-datum "door-read"))
                                      (entry '("effect" "standing-as-read")
                                             (record-field record "effect" "standing-as-read"))
                                      (entry '("effect" "determinacy")
                                             (record-field record "effect" "determinacy"))
                                      (entry '("effect" "world-digest")
                                             (record-field record "effect" "world-digest"))
                                      (entry '("effect" "scope")
                                             (record-field record "effect" "scope")))))
                    (and (eq :caller-asserted
                             (ml0-effect-observation-provenance observation))
                         (string= "caller-asserted"
                                  (lisp-plus-cd0:string-datum-value
                                   (record-field record "effect" "provenance")))
                         (eq :caller-asserted
                             (ml0-effect-observation-provenance
                              (ml0-effect-observation-from-record record)))
                         (handler-case
                             (progn (ml0-effect-observation-from-record forged) nil)
                           (ml0-condition (c)
                             (equal "ML0-RB-5" (ml0-condition-requirement-id c)))))))

       (format t "~&~%"))
  (when (probe-file *root*) (sb-ext:delete-directory *root* :recursive t)))

(format t "~&ml0-selftest: ~d checks, ~d failures~%"
        (+ *ml0-checks-passed* *ml0-checks-failed*) *ml0-checks-failed*)
(finish-output)
(sb-ext:exit :code (if (zerop *ml0-checks-failed*) 0 1))
