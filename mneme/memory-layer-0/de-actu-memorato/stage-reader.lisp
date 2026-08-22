;;;; stage-reader.lisp — THE LECTOR: a genuinely new process that was not there.
;;;;
;;;; Launched by run-specimen.lisp as a separate `sbcl --script` invocation.  It
;;;; may consult ONLY durable bytes plus the declared configuration in
;;;; specimen-common.lisp.  It inherits no object, no image, no registry, and no
;;;; standing from the scriptor or the moriturus.
;;;;
;;;; What it does, in order:
;;;;   D1  retrieves the memorable act's account and checks every clause of the
;;;;       commission's acceptance sentence against durable bytes;
;;;;   D2  reads the crown negative back and consolidates it, and NO PUBLIC
;;;;       READER ANSWERS OCCURRED at either point;
;;;;   D4  feeds the retrieved account toward the current-image continuation
;;;;       boundary through the lawful public route, RECORDS THE ACTUAL EARLIEST
;;;;       LAWFUL REFUSAL, and proves the invariant that outranks the predicted
;;;;       condition name;
;;;;   D3  writes the FIRST AND ONLY account of the moriturus's act, from the
;;;;       durable independent basis alone — `occurred`, issuance `unresolved`;
;;;;   D6  exercises the consolidation rows over accounts it retrieved rather
;;;;       than accounts it was handed.
;;;;
;;;; ⚠ THE READER IS NOT THE ACTOR.  Every account it retrieves keeps the
;;;; scriptor as its SUBJECT principal and this lane as its RECORDER principal,
;;;; and its retrieval origin is :RECONSTRUCTED.  Reading an old account does not
;;;; make the archive-reader the same being as the original actor or witness.
;;;;
;;;; — TABULARIUS (Claude Opus 5, subagent), 2026-08-20

(load (merge-pathnames "specimen-common.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-memory-layer0)

(defvar *arguments* (rest sb-ext:*posix-argv*))
(defvar *store-directory* (pathname (first *arguments*)))
(defvar *world-directory* (pathname (second *arguments*)))
(defvar *account-directory* (pathname (third *arguments*)))
(defvar *run-directory* (pathname (fourth *arguments*)))
(defvar *death-store-directory* (pathname (fifth *arguments*)))
(defvar *death-world-directory* (pathname (sixth *arguments*)))
(defvar *probe-store-directory* (pathname (seventh *arguments*)))
(defvar *probe-world-directory* (pathname (nth 7 *arguments*)))

(vnote "lector: a genuinely new process.  Nothing but durable bytes and the ~
declared configuration.")

;;; ⚠ THE FIRST FACT, AND IT IS THE ONE THAT MAKES EVERY LATER `unresolved`
;;; HONEST: this image's Core /0 issuance registry is EMPTY, so
;;; `core0-evidence-current-image-issued-p` answers FALSE for every possible
;;; input here.  A predicate false universally is not an absence warrant, and no
;;; scope repairs that — which is why the issuance axis of this lane has no
;;; negative member at all.
(vcheck "the reader's Core /0 issuance registry is empty: the live predicate ~
answers false for a plain string, for NIL, and for a symbol alike — an ~
instrument with no power to detect presence cannot warrant absence"
        (lambda ()
          (notany #'lisp-plus-core0:core0-evidence-current-image-issued-p
                  (list "not evidence" nil :neither 42))))

(memorato-account-ground *account-directory* :create nil)
(memorato-act-ground *store-directory* *world-directory* :create nil)

(defvar *index* (memorato-read-accounts *run-directory*))
(defvar *memorable-row* (the-memorable-row))
(defvar *refused-row* (the-refused-row))
(defvar *memorable-id* (nth-value 0 (ml0-rederive-act-identity *memorable-row*)))
(defvar *refused-id* (nth-value 0 (ml0-rederive-act-identity *refused-row*)))

;;; ===========================================================================
;;; D1 — witnessed occurrence survives the process, not by replay.
;;; ===========================================================================

(defvar *store-before* (ml0-take-store-scope *account-directory*))
(defvar *act-store-before* (ml0-take-store-scope *store-directory*))
(defvar *world-before* (lisp-plus-language-act1:take-world-scope
                        (ml0-world) (ml0-world-directory)))
(defvar *frames-before* (nth-value 1 (act1-journal-kinds *ml0-act-store*)))

(defvar *memorable-account*
  (ml0-retrieve *ml0-account-store*
                :account-hex (memorato-account-of *index* "memorable")))

(vcheck "D1(a) — ACT IDENTITY IS BYTE-EQUAL UNDER RE-DERIVATION.  This process ~
re-derives the act identity from (domain · runtime seat · canonical request), ~
touching nothing the scriptor left in memory, and it equals the identity the ~
retrieved account carries"
        (lambda () (same-datum-p (ml0-account-act-id *memorable-account*)
                                 *memorable-id*)))

(vcheck "D1(b) — OCCURRENCE IS WARRANTED BY THE INDEPENDENT BASIS, and the rule ~
re-run over the retrieved sources says so on its own: the warranting source is a ~
species that reads facts a mint cannot make true"
        (lambda ()
          (and (ml0-account-occurred-p *memorable-account*)
               (multiple-value-bind (ok source)
                   (ml0-occurrence-warranted-p
                    *memorable-id* (ml0-account-sources *memorable-account*))
                 (and ok (member (ml0-source-species source)
                                 +ml0-occurrence-species+))))))

(vcheck "D1(c) — ISSUANCE IS REPORTED SEPARATELY and is named for its own ~
boundary: :ISSUED-IN-WRITING-IMAGE, which this process cannot and does not ~
re-verify.  It reads it as the scriptor's testimony, not as its own finding"
        (lambda ()
          (and (eq :issued-in-writing-image
                   (ml0-account-issuance-standing *memorable-account*))
               (not (eq (ml0-account-issuance-standing *memorable-account*)
                        (ml0-account-occurrence-standing *memorable-account*))))))

(vcheck "D1(d) — THE READER IS NOT THE ACTOR: the account's subject principal is ~
the scriptor's, its recorder principal is this lane's, and its retrieval origin ~
is :RECONSTRUCTED"
        (lambda ()
          (and (search *scriptor-process*
                       (ml0-account-subject-principal *memorable-account*))
               (search +ml0-lane-stem+
                       (ml0-account-recorder-principal *memorable-account*))
               (eq :reconstructed
                   (ml0-account-retrieval-origin *memorable-account*)))))

;;; three more retrievals, then the byte comparison over all three jurisdictions
(dotimes (i 3)
  (ml0-retrieve *ml0-account-store*
                :account-hex (memorato-account-of *index* "memorable"))
  (ml0-retrieve *ml0-account-store*
                :account-hex (memorato-account-of *index* "crown")))

(vcheck "D1(e) — RETRIEVAL DID NOT RE-PERFORM, MEASURED ACROSS ALL THREE ~
JURISDICTIONS: after four retrievals the ACCOUNT STORE, the ACT JOURNAL and the ~
WORLD are each byte-unchanged, and the journal's frame count has not moved"
        (lambda ()
          (and (ml0-store-scope-unchanged-p
                *store-before* (ml0-take-store-scope *account-directory*))
               (ml0-store-scope-unchanged-p
                *act-store-before* (ml0-take-store-scope *store-directory*))
               (lisp-plus-language-act1:world-scope-unchanged-p
                *world-before* (lisp-plus-language-act1:take-world-scope
                                (ml0-world) (ml0-world-directory)))
               (eql *frames-before*
                    (nth-value 1 (act1-journal-kinds *ml0-act-store*))))))

(vcheck "D1(f) — NO CORE /0 EVIDENCE WAS MINTED and none is carried: the ~
retrieved account is not a core0-evidence, nothing reachable from its public ~
surface is one, and nothing reachable from it is registered as issued here"
        (lambda ()
          (and (not (lisp-plus-core0:core0-evidence-p *memorable-account*))
               (ml0-account-carries-no-current-image-evidence-p *memorable-account*))))

;;; ===========================================================================
;;; D2 — the crown negative, after a fresh-process retrieval AND after
;;; consolidation.
;;; ===========================================================================

(defvar *crown-account*
  (ml0-retrieve *ml0-account-store*
                :account-hex (memorato-account-of *index* "crown")))

(vcheck "D2 arm (a), read half — retrieved in a genuinely new process, the ~
crown negative's account still reads occurrence :UNRESOLVED and issuance-only, ~
and no public reader answers occurred"
        (lambda ()
          (and (not (ml0-account-occurred-p *crown-account*))
               (eq :unresolved (ml0-account-occurrence-standing *crown-account*))
               (ml0-account-issuance-only-p *crown-account*)
               (eq :issued-in-writing-image
                   (ml0-account-issuance-standing *crown-account*)))))

(vcheck "D2 arm (a), consolidation half — consolidating the crown negative with ~
a SECOND issuance-only reading of the same act still yields :UNRESOLVED.  Two ~
records are not a warrant, however numerous or durable"
        (lambda ()
          (let ((second (ml0-write *ml0-account-store*
                                   (make-ml0-bundle
                                    :fixture-row *refused-row*
                                    :claimed-act-id *refused-id*
                                    :subject-principal *scriptor-process*
                                    ;; ⚑ THE SAME TESTIMONY ROW, RE-READ OUT OF
                                    ;; THE DURABLE BYTES.  This process holds no
                                    ;; Core /0 evidence object and cannot build a
                                    ;; fresh issuance row; what it CAN do is carry
                                    ;; forward the row the scriptor wrote, which
                                    ;; is exactly what a memory layer is for.
                                    :sources (list (first (ml0-account-sources
                                                           *crown-account*))
                                                   (ml0-self-report-source
                                                    *refused-id* "a second reading")))
                                   :recording-process *lector-process*)))
            (declare (ignorable second))
            ;; R4.1: consolidation returns one ML0-CONSOLIDATION carrier.
            (eq :unresolved
                (ml0-consolidation-occurrence-standing
                 (ml0-consolidate (list *crown-account* second)))))))

(vcheck "D2, the rule's own answer on the retrieved bundle: the refusal names ~
leg SPECIES [ML0-PROMOTE-1], with every other leg satisfied — so the row is ~
passing for the reason it was built to test and not for some other"
        (lambda ()
          (let* ((source (first (ml0-account-sources *crown-account*)))
                 (conjuncts (ml0-occurrence-conjuncts *refused-id* source)))
            (multiple-value-bind (leg requirement) (ml0-failing-leg conjuncts)
              (and (eq :core0-issuance-testimony (ml0-source-species source))
                   (eq :species leg)
                   (equal "ML0-PROMOTE-1" requirement)
                   (= 7 (count-if #'cdr conjuncts)))))))

;;; ===========================================================================
;;; D4 — retrieval confers neither evidence nor authority.
;;;
;;; ⚠ THE INVARIANT OUTRANKS THE PREDICTED SUBTYPE (work order AMENDMENT 1.4).
;;; Core /0 runs its issuance check AFTER basic type checking, so an earlier
;;; lawful rejection of the wrong semantic species is lawful — and sharper.  What
;;; must be proved is the INVARIANT: no continuation result, no ledger
;;; consultation, no receipt, no evidence mint, no authority acquisition.  What
;;; must be RECORDED is the actual earliest lawful refusal.  Nothing is wrapped,
;;; counterfeited or exported to force a condition name.
;;; ===========================================================================

(defvar *d4-condition* nil)
(defvar *d4-result* nil)
(defvar *d4-world-before* (lisp-plus-language-act1:take-world-scope
                           (ml0-world) (ml0-world-directory)))
(defvar *d4-frames-before* (nth-value 1 (act1-journal-kinds *ml0-act-store*)))

(setf *d4-result*
      (handler-case (list :returned (lisp-plus-core0:continue-from *memorable-account*))
        (lisp-plus-core0:core0-condition (c)
          (setf *d4-condition* (type-of c))
          ;; ⚑ THE LIST CARRIES NO SECOND ELEMENT ON THE REFUSAL PATH, ON
          ;; PURPOSE: the check below asks whether ANY continuation result came
          ;; back, and a condition type stored in that slot would answer `yes` to
          ;; a question about a returned value.  The condition's name lives in
          ;; *D4-CONDITION*, where it is REPORTED rather than tested.
          (list :refused))
        (error (c) (setf *d4-condition* (type-of c)) (list :other (type-of c)))))

(vnote "D4 — the ACTUAL EARLIEST LAWFUL REFUSAL, recorded rather than predicted: ~
continue-from on a retrieved memory account signals ~a.  Core /0's issuance check ~
(unissued-evidence) sits BELOW its basic type check, so this refusal is EARLIER ~
than the work order's prediction — which is lawful, and sharper: the account is ~
rejected for not being evidence at all, before any question of whose evidence it ~
is can arise." *d4-condition*)

(vcheck "D4(a) — the retrieved account is REJECTED at the current-image ~
continuation boundary, through the lawful public route, with NO continuation ~
result returned"
        (lambda () (and (eq :refused (first *d4-result*))
                        (null (rest *d4-result*))
                        (not (eq :returned (first *d4-result*))))))

(vcheck "D4(b) — THE INVARIANT: no receipt, no evidence mint, no authority ~
acquired, and no ledger consultation — the world and the act journal are ~
byte-unchanged across the attempt, and this image still holds NO issued evidence ~
of any kind"
        (lambda ()
          (and (lisp-plus-language-act1:world-scope-unchanged-p
                *d4-world-before* (lisp-plus-language-act1:take-world-scope
                                   (ml0-world) (ml0-world-directory)))
               (eql *d4-frames-before*
                    (nth-value 1 (act1-journal-kinds *ml0-act-store*)))
               (not (lisp-plus-core0:core0-evidence-current-image-issued-p
                     *memorable-account*))
               (ml0-account-carries-no-current-image-evidence-p *memorable-account*)
               (null (ml0-account-may-continue-p *memorable-account*)))))

;;; THE COMPETENCE HALF: the boundary is shown to be reachable and the
;;; instrument shown able to answer YES, so the refusal above is a discrimination
;;; and not a wall.  The probe runs on the reader's OWN scratch store and world —
;;; never on the scriptor's, whose bytes this stage has just proved unchanged.
(defvar *probe-issued* nil)
(defvar *probe-continue* nil)
(defvar *probe-world* nil)

;; ⚑ ALL FIVE GLOBALS ARE SAVED, not the three that happen to matter later.
;; `memorato-act-ground` also rebinds the bootstrap and the minting context, and
;; restoring only what this stage goes on to use would leave a trap for whoever
;; adds a line below.
(let ((saved-store *ml0-act-store*) (saved-worlds *ml0-worlds*)
      (saved-dirs *ml0-world-directories*)
      (saved-bootstrap lisp-plus-language-act1:*act1-bootstrap*)
      (saved-minting lisp-plus-language-act1:*act1-minting-context*))
  (memorato-act-ground *probe-store-directory* *probe-world-directory*)
  (let ((row (ml0-settled-row :seat "probatio" :attempt "a-probatio"
                              :text "Actus probationis."
                              :symbol 'de-actu-memorato/bridge-probatio)))
    (setf lisp-plus-language-act1:*act1-fixture-table* (list row))
    (ml0-open-authority (list row))
    (setf *probe-world* (ml0-world))
    (let* ((result (lisp-plus-language-act1:run-act1 row :verbose nil))
           (evidence (lisp-plus-language-act1:act1-result-evidence result)))
      (setf *probe-issued*
            (lisp-plus-core0:core0-evidence-current-image-issued-p evidence))
      (setf *probe-continue*
            (handler-case (progn (lisp-plus-core0:continue-from evidence) :returned)
              (lisp-plus-core0:core0-condition (c) (type-of c))))))
  (setf *ml0-act-store* saved-store
        lisp-plus-language-act1:*act1-store* saved-store
        *ml0-worlds* saved-worlds
        lisp-plus-language-act1:*act1-worlds* saved-worlds
        *ml0-world-directories* saved-dirs
        lisp-plus-language-act1:*act1-world-directories* saved-dirs
        lisp-plus-language-act1:*act1-bootstrap* saved-bootstrap
        lisp-plus-language-act1:*act1-minting-context* saved-minting))

(vnote "D4 competence — on the reader's OWN scratch ground, a genuinely issued ~
Core /0 account answers the issuance predicate ~a and reaches continue-from's ~
LATER rungs, signalling ~a.  So the boundary is reachable, the instrument can say ~
yes, and the memory account's refusal above is a DISCRIMINATION rather than a ~
wall that refuses everything."
       (if *probe-issued* "TRUE" "false") *probe-continue*)

(vcheck "D4(c) — the competence half holds: a real current-image evidence account ~
answers the issuance predicate TRUE and gets PAST the type check that stopped the ~
memory account, landing on a DIFFERENT and later lawful refusal"
        (lambda ()
          (and *probe-issued*
               (not (eq *probe-continue* *d4-condition*))
               (not (eq :returned *probe-continue*)))))

;;; ===========================================================================
;;; D3 — the other direction: occurred, evidence not issued.
;;; ===========================================================================

(defvar *death-store* nil)
(defvar *death-world* nil)
(defvar *dying-id* nil)
(defvar *dying-account* nil)

;; ⚑ ALL FIVE GLOBALS ARE SAVED, not the three that happen to matter later.
;; `memorato-act-ground` also rebinds the bootstrap and the minting context, and
;; restoring only what this stage goes on to use would leave a trap for whoever
;; adds a line below.
(let ((saved-store *ml0-act-store*) (saved-worlds *ml0-worlds*)
      (saved-dirs *ml0-world-directories*)
      (saved-bootstrap lisp-plus-language-act1:*act1-bootstrap*)
      (saved-minting lisp-plus-language-act1:*act1-minting-context*))
  (memorato-act-ground *death-store-directory* *death-world-directory* :create nil)
  (setf *death-store* *ml0-act-store*)
  (setf *death-world* (ml0-world))
  (setf *dying-id* (nth-value 0 (ml0-rederive-act-identity (the-dying-row))))

  (vcheck "D3(a) — THE ASYMMETRY THE MORITURUS LEFT, in bytes: its journal ~
validates :VALID with exactly three frames ending at attempt:frontier-crossed — ~
nothing after the frontier — while its WORLD holds the written cell and exactly ~
ONE ledger row under the act's derived external-request identity.  The effect ~
HAPPENED; only the record of its happening died"
          (lambda ()
            (multiple-value-bind (kinds count status tail)
                (act1-journal-kinds *death-store*)
              (and (eq :valid status) (= 3 count) (null tail)
                   (equal kinds '("capability0:granted" "attempt:prepared"
                                  "attempt:frontier-crossed"))
                   (equal *dying-text* (world-cell-value *death-world* *cell-name*))
                   (= 1 (world-ledger-count
                         *death-world*
                         (lisp-plus-language-act1:external-request-key
                          *dying-attempt*)))))))

  ;; THE FIRST AND ONLY ACCOUNT OF THAT ACT, written by a process that was not
  ;; there, from the durable independent basis alone.
  (setf *dying-account*
        (ml0-write *ml0-account-store*
                   (make-ml0-bundle
                    :fixture-row (the-dying-row)
                    :claimed-act-id *dying-id*
                    :subject-principal *moriturus-process*
                    ;; ⚑ R3: the doors take ONE SUBJECT, derived from the one
                    ;; declared row — the act identity and the substrate keys can
                    ;; no longer be paired by hand, and `:observations` is the only
                    ;; channel that carries a warrant into a bundle.
                    :observations
                    (let ((subject (ml0-subject-from-fixture-row (the-dying-row))))
                      (list (ml0-observe-world subject *death-world*
                                               :route :reconstructed)
                            (ml0-observe-journal subject *death-store*
                                                 :route :reconstructed)))
                    ;; ⚠ :UNRESOLVED, AND NEVER ANYTHING NEGATIVE.  The moriturus
                    ;; very likely DID mint evidence — it reached the frontier —
                    ;; and Core /0's registry left no durable footprint, so this
                    ;; process cannot distinguish never-issued from
                    ;; issued-and-died.  There is no lawful word for that but
                    ;; `unresolved`, and this lane's issuance axis deliberately
                    ;; offers no other.
                    ;; what THIS store holds is a different question, on its own
                    ;; field, and this process IS competent over it.
                    ;;
                    ;; ⚑ R4: AND THAT ANSWER IS NOW READ, NOT ASSERTED.  Until
                    ;; 2026-08-20 this stage NAMED the finding and handed over a
                    ;; scope it wrote itself, and nothing in the lane ever opened
                    ;; the store — the reader claimed competence over the one
                    ;; universe it is actually competent over, without looking at
                    ;; it.  `ml0-observe-record-coverage` scans the store's whole
                    ;; validated prefix and the finding below is whatever it
                    ;; found.
                    :record-coverage-observation
                    (ml0-observe-record-coverage
                     *ml0-account-store*
                     (ml0-subject-from-fixture-row (the-dying-row)))
                    :effect-observation (ml0-effect-observation-of
                                         *dying-attempt* :store *death-store*
                                         :world *death-world*))
                   :recording-process *lector-process*))

  (setf *ml0-act-store* saved-store
        lisp-plus-language-act1:*act1-store* saved-store
        *ml0-worlds* saved-worlds
        lisp-plus-language-act1:*act1-worlds* saved-worlds
        *ml0-world-directories* saved-dirs
        lisp-plus-language-act1:*act1-world-directories* saved-dirs
        lisp-plus-language-act1:*act1-bootstrap* saved-bootstrap
        lisp-plus-language-act1:*act1-minting-context* saved-minting))

(vcheck "D3(b) — THE ABSENCE ONE ACT /1 NAMED IS ANSWERED: a process that was ~
not there writes the first and only durable, language-level account of that act, ~
and it reads OCCURRED with issuance UNRESOLVED — never `not issued`, because the ~
instrument that would have to say so answers false for every input in this image"
        (lambda ()
          (and (ml0-account-occurred-p *dying-account*)
               (eq :unresolved (ml0-account-issuance-standing *dying-account*))
               (eq :no-issuance-record-in-account-store
                   (ml0-account-record-coverage *dying-account*)))))

(vcheck "D3(c) — and its provenance says HOW it was come by: every source's ~
acquisition route is :RECONSTRUCTED, the ratchet's lower rung, because nobody ~
live-queried anything — the bytes were read after the fact"
        (lambda ()
          (every (lambda (s) (eq :reconstructed (ml0-source-acquisition-route s)))
                 (ml0-account-sources *dying-account*))))

(vcheck "D3(d) — the account survives its own round trip: retrieved from durable ~
bytes in this same process it is byte-identical in identity and carries the same ~
two standings"
        (lambda ()
          (let ((again (ml0-retrieve *ml0-account-store*
                                     :account-hex (ml0-account-id-hex *dying-account*))))
            (and (string= (ml0-account-id-hex again)
                          (ml0-account-id-hex *dying-account*))
                 (ml0-account-occurred-p again)
                 (eq :unresolved (ml0-account-issuance-standing again))))))

;;; ===========================================================================
;;; D6 — consolidation cannot manufacture certainty.
;;; ===========================================================================
;;;
;;; ⚑ R4.1 FORK F2 — THE LECTOR'S SUBJECT PRINCIPAL WAS WRONG, AND ML0-CON-4
;;; FOUND IT.  Every D6 write below used to pass `:subject-principal
;;; *lector-process*` for accounts ABOUT acts the SCRIPTOR performed, so
;;; consolidating a lector account with a retrieved scriptor account offered the
;;; derived account two subjects.  `subject-principal` is THE ACTOR — "whose act
;;; it is ABOUT" (SPEC §(the account body), the five provenance constants) — and
;;; the lector's own identity is carried by `recording-process` (and by the row's
;;; `recorder-principal`), which every one of these writes already passes.  The
;;; specimen already knew this elsewhere: the D2 second reading passes
;;; `*scriptor-process*`, and the moriturus's first account passes
;;; `*moriturus-process*`.  D6 was the deviation.  ML0-CON-4 is NOT relaxed.

(defvar *d6-negative*
  (ml0-write *ml0-account-store*
             (make-ml0-bundle
              :fixture-row *refused-row*
              :claimed-act-id *refused-id*
              ;; R4.1 fork F2: the actor, not the recorder — see the note above.
              :subject-principal *scriptor-process*
              :observations (list (ml0-observe-absence
                                   (ml0-subject-from-fixture-row *refused-row*)
                                   (ml0-world) :route :reconstructed)))
             :recording-process *lector-process*))

(vcheck "D6(a) — UNRESOLVED + A SCOPED NEGATIVE OBSERVATION becomes ~
:NONOCCURRED, because the four-part warrant is met: the ledger is the complete ~
authoritative domain, the identity is named, the lookup is a distinct inspectable ~
witness, and the source row binds mechanism / procedure / origin / validation"
        (lambda ()
          (and (eq :nonoccurred (ml0-account-occurrence-standing *d6-negative*))
               (eq :nonoccurred
                   (ml0-consolidation-occurrence-standing
                    (ml0-consolidate (list *crown-account* *d6-negative*)))))))

(vcheck "D6(b) — ISSUANCE-ONLY + A QUALIFYING BASIS becomes :OCCURRED, and only ~
BECAUSE the qualifying basis is present in the union and named"
        (lambda ()
          (let ((with-basis
                  (ml0-write *ml0-account-store*
                             (make-ml0-bundle
                              :fixture-row *memorable-row*
                              :claimed-act-id *memorable-id*
                              ;; R4.1 fork F2: the actor, not the recorder.
                              :subject-principal *scriptor-process*
                              :observations
                              (list (ml0-observe-world
                                     (ml0-subject-from-fixture-row *memorable-row*)
                                     (ml0-world) :route :reconstructed)))
                             :recording-process *lector-process*)))
            (let ((c (ml0-consolidate (list *memorable-account* with-basis))))
              (and (eq :occurred (ml0-consolidation-occurrence-standing c))
                   (eq :issued-in-writing-image
                       (ml0-consolidation-issuance-standing c))
                   (some (lambda (s)
                           (and (ml0-species-may-warrant-occurrence-p
                                 (ml0-source-species s))
                                (eq :frontier-crossed-for-this-identity
                                    (ml0-source-attests s))))
                         (ml0-consolidation-sources c)))))))

(vcheck "D6(c) — ⚠ DOWNGRADED IN THE REPAIR ROUND, AND THE DOWNGRADE IS THE ~
FINDING.  :CONTRADICTED is now UNREACHABLE from warranting rows: a row warrants ~
only if a DOOR validated it, and two correct doors reading one universe over one ~
interval AGREE — so no commensurable clash between warrants can arise.  What is ~
checked here is what remains true: the commensurability PREDICATE still ~
discriminates, and a MODELLED clash (testimony, which is all that can disagree at ~
that resolution) warrants nothing and is preserved unpicked rather than resolved"
        (lambda ()
          (multiple-value-bind (positive negative)
              (ml0-commensurable-clash-pair *memorable-id* *memorable-attempt*)
            (let ((a (ml0-write *ml0-account-store*
                                (make-ml0-bundle :fixture-row *memorable-row*
                                                 :claimed-act-id *memorable-id*
                                                 ;; R4.1 fork F2: the actor.
                                                 :subject-principal *scriptor-process*
                                                 :sources (list positive))
                                :recording-process *lector-process*))
                  (b (ml0-write *ml0-account-store*
                                (make-ml0-bundle :fixture-row *memorable-row*
                                                 :claimed-act-id *memorable-id*
                                                 ;; R4.1 fork F2: the actor.
                                                 :subject-principal *scriptor-process*
                                                 :sources (list negative))
                                :recording-process *lector-process*)))
              (let* ((c (ml0-consolidate (list a b)))
                     (occurrence (ml0-consolidation-occurrence-standing c))
                     (sources (ml0-consolidation-sources c)))
                (and (ml0-warrants-commensurable-p positive negative)
                     ;; neither modelled row is a warrant
                     (not (ml0-source-warranting-validation-p positive))
                     (not (ml0-source-warranting-validation-p negative))
                     ;; so the reading is :UNRESOLVED, not a picked side
                     (eq :unresolved occurrence)
                     ;; and BOTH rows survive, unpicked
                     (= 2 (length sources))))))))

(vcheck "D6(d) — INCOMMENSURABLE observations are NOT a contradiction: the same ~
positive warrant against a negative look at a DIFFERENT declared universe leaves ~
both warrants preserved and the reading :OCCURRED — a disagreement about two ~
questions was never a disagreement about one"
        (lambda ()
          (let* ((positive (nth-value 0 (ml0-commensurable-clash-pair
                                         *memorable-id* *memorable-attempt*)))
                 ;; ⚠ THE `ELSEWHERE` LOOK IS AT THE PROBE WORLD, NOT THE
                 ;; MORITURUS'S — the moriturus's own act carries the SAME
                 ;; attempt name in ITS world, so a look there would honestly FIND
                 ;; a row and the pair would agree instead of disagreeing.  The
                 ;; near-miss is worth naming: an incommensurability test built on
                 ;; a world that happens to answer the same way proves nothing.
                 (elsewhere-obs (ml0-observe-absence
                                 (ml0-subject-from-fixture-row *memorable-row*)
                                 *probe-world* :route :reconstructed))
                 (elsewhere (ml0-observation-source elsewhere-obs))
                 (a (ml0-write *ml0-account-store*
                               (make-ml0-bundle :fixture-row *memorable-row*
                                                :claimed-act-id *memorable-id*
                                                ;; R4.1 fork F2: the actor.
                                                :subject-principal *scriptor-process*
                                                :sources (list positive
                                                                (ml0-self-report-source
                                                                 *memorable-id* "d6d-a")))
                               :recording-process *lector-process*))
                 (b (ml0-write *ml0-account-store*
                               (make-ml0-bundle :fixture-row *memorable-row*
                                                :claimed-act-id *memorable-id*
                                                ;; R4.1 fork F2: the actor.
                                                :subject-principal *scriptor-process*
                                                :observations (list elsewhere-obs))
                               :recording-process *lector-process*)))
            (and (not (ml0-warrants-commensurable-p positive elsewhere))
                 (eq :nonoccurred (ml0-account-occurrence-standing b))
                 (not (eq :contradicted
                          (ml0-consolidation-occurrence-standing
                           (ml0-consolidate (list a b)))))
                 (= 2 (length (ml0-consolidation-inputs
                               (ml0-consolidate (list a b)))))))))

(vcheck "D6(e) — the SAME PROJECTED CLAIM with DISTINCT PROVENANCE stays TWO ~
records: two accounts of the SAME act that both project :OCCURRED, differing only ~
in which sources they carry, keep their distinct content-derived identities and ~
are never collapsed — while the SAME account twice is one record"
        (lambda ()
          (let ((second-reading
                  (ml0-write *ml0-account-store*
                             (make-ml0-bundle
                              :fixture-row *memorable-row*
                              :claimed-act-id *memorable-id*
                              ;; R4.1 fork F2: the actor, not the recorder.
                              :subject-principal *scriptor-process*
                              :observations
                              (list (ml0-observe-journal
                                     (ml0-subject-from-fixture-row *memorable-row*)
                                     *ml0-act-store* :route :reconstructed)))
                             :recording-process *lector-process*)))
            (and (not (string= (ml0-account-id-hex second-reading)
                               (ml0-account-id-hex *memorable-account*)))
                 (ml0-account-occurred-p second-reading)
                 (ml0-account-occurred-p *memorable-account*)
                 (= 2 (length (ml0-consolidation-inputs
                               (ml0-consolidate
                                (list *memorable-account* second-reading)))))
                 (= 1 (length (ml0-consolidation-inputs
                               (ml0-consolidate
                                (list *memorable-account*
                                      *memorable-account*)))))))))

(vcheck "D6(f) — CROSS-ACT consolidation is refused BEFORE any output is produced: ~
the memorable act's account and the crown negative's are about different acts, and ~
nothing is returned at all"
        (lambda ()
          (handler-case (progn (ml0-consolidate (list *memorable-account*
                                                      *crown-account*))
                               nil)
            (ml0-consolidation-refused (c)
              (equal "ML0-CON-2" (ml0-condition-requirement-id c))))))

(vnote "the reader is finished.  It performed no act on any store it was asked to ~
read, minted no evidence, acquired no authority, and became nobody's successor.")

(format t "RESULT: ~a checks, ~a failures~%" *v-checks* *v-failures*)
(finish-output)
(sb-ext:exit :code (if (zerop *v-failures*) 0 1))
