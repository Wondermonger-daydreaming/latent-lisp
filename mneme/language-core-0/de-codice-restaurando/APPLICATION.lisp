;;;; APPLICATION.lisp — de-codice-restaurando: THE CONSERVATION WORKSHOP.
;;;;
;;;; One damaged manuscript.  Codex umbra-17: water-damaged in a roof failure,
;;;; iron-gall ink of doubtful stability, parchment cockled to eleven millimetres
;;;; of out-of-plane distortion, deposited under an agreement whose intervention
;;;; clause two parties read differently, and promised to an exhibition that
;;;; opens on day 4212.
;;;;
;;;; The workshop must decide six things, in this order and no other:
;;;;   whether it is AUTHORIZED to intervene at all;
;;;;   which treatment is PERMITTED on this material;
;;;;   whether the permitted treatment may be PERFORMED;
;;;;   WHAT HAPPENED during treatment;
;;;;   whether the manuscript is SAFE TO EXHIBIT;
;;;;   and what to do when post-treatment standing CANNOT BE ESTABLISHED.
;;;;
;;;; This is an APPLICATION, not a specimen and not an audit.  It was written to
;;;; find out whether the shape of Lisp+ survives a domain whose reasoning is not
;;;; a chain.  A lending desk decides one thing along one line.  A conservation
;;;; workshop decides two independent things — is this SAFE for the object, and
;;;; is this PERMITTED to us — and may act only where the two meet.  The
;;;; companion FIELD-REPORT.md is the other half of the deliverable.
;;;;
;;;; THE SHAPE OF THE PROGRAM (and the reason it exists)
;;;;
;;;;      MATERIAL BRANCH                    AUTHORITY BRANCH
;;;;      condition observations             owner consent + deposit agreement
;;;;              |                                  |
;;;;      :ink-stability-established         :owner-authority-established
;;;;              |                                  |
;;;;      :treatment-materially-suitable     :treatment-institutionally-authorized
;;;;              \                                  /
;;;;               \________________  ______________/
;;;;                                \/
;;;;                       :treatment-authorized        (BOTH, or nothing)
;;;;                                |
;;;;                             perform
;;;;                                |
;;;;                  structured treatment account
;;;;                          /            \
;;;;         post-treatment condition    custody / documentation
;;;;                          \            /
;;;;                      exhibition decision
;;;;
;;;; The two upper branches are SEMANTICALLY DISTINCT and neither may impersonate
;;;; the other.  A material conclusion is about parchment and ink; an authority
;;;; conclusion is about who may touch the object under which policy.  Movement IV
;;;; tries the impersonation four ways and records what the language does.
;;;;
;;;; NINE MOVEMENTS
;;;;   I    THE BENCH             ordinary Common Lisp: a condition survey, a
;;;;                              treatment-option filter, a drying schedule, a
;;;;                              materials cost.  No Lisp+ below that banner.
;;;;   II   THE MATERIAL BRANCH   two derivational hops from assays to suitability.
;;;;   III  THE AUTHORITY BRANCH  two derivational hops from consent to mandate —
;;;;                              and the contested-ownership case, which the
;;;;                              language answers with a named ambiguity.
;;;;   IV   THE RECONVERGENCE     authorization requires a premise from EACH
;;;;                              branch.  Four impersonation attempts, all
;;;;                              refused, and the two governed bases printed.
;;;;   V    THE REFUSALS          material refusal · authority refusal ·
;;;;                              a branch the receiving bench cannot read.
;;;;   VI   THE TREATMENT         `perform` twice.  Humidification commits and is
;;;;                              acknowledged.  Flattening is interrupted and its
;;;;                              ledger withholds.  The workshop does not press
;;;;                              the sheet twice.
;;;;   VII  THE EFFECT FRONTIER   the workshop holds a TRUE structured account of
;;;;                              a treatment that really happened, and asks the
;;;;                              language to let it support the next judgment.
;;;;                              Six species are tried.  The result is the point
;;;;                              of the whole program.
;;;;   VIII THE EXHIBITION        the documentation branch grants; the
;;;;                              post-treatment branch cannot; the exhibition
;;;;                              decision is refused, and nothing phantom is
;;;;                              written.
;;;;   IX   THE MEASURED CLOSE    grounding cardinalities counted, the two planted
;;;;                              controls, and the boundary stated in four parts.
;;;;
;;;; FRONT-DOOR DISCIPLINE: the single-colon public surface only.  The two-colon
;;;; package-internal digraph occurs NOWHERE in this file or in FIELD-REPORT.md,
;;;; which is why both spell that digraph out in words rather than exhibiting it.
;;;;
;;;; DETERMINISM: every value in the transcript is rendered through FMT below,
;;;; with the pretty printer off.  *PRINT-RIGHT-MARGIN* is NIL by default and SBCL
;;;; then chooses a margin of its own, so a structure printed through the pretty
;;;; printer would break its lines differently on a differently-configured host —
;;;; a difference two runs on ONE machine cannot see.  Nothing here is printed
;;;; through the pretty printer.
;;;;
;;;; Run: sbcl --non-interactive --load APPLICATION.lisp   (exits 0 on every arm)
;;;;
;;;; — Claude Opus 5 (1M context), CONSERVATRIX

(unless (find-package :lisp-plus-fake-courier)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../fake-courier.lisp" *load-truename*))))
(unless (find-package :lisp-plus-slice1)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../../language-slice-1/slice1.lisp" *load-truename*))))

(defpackage #:de-codice-restaurando (:use #:cl))
(in-package #:de-codice-restaurando)

;;; ------------------------------------------------------------------
;;; A thin harness, and one printing discipline.

(defvar *pass* 0)
(defvar *fail* 0)
(defun ok (name bool &optional detail)
  (if bool (progn (incf *pass*) (format t "  ok   ~A~@[ — ~A~]~%" name detail))
      (progn (incf *fail*) (format t "  FAIL ~A~@[ — ~A~]~%" name detail))))

(defun fmt (x)
  "Render X with the pretty printer OFF, so no line break in this program's
output is chosen by the host's printer.  See the DETERMINISM note in the header."
  (let ((*print-pretty* nil) (*print-right-margin* nil) (*print-readably* nil))
    (prin1-to-string x)))

(defun bench (fmt-string &rest args)
  "The workshop speaks.  (Conservators annotate everything; so does this program.)"
  (format t "   > ~?~%" fmt-string args))

(defun explain (receipt)
  "The language's own prose over its own receipt, printed unpretty for the same
reason everything else here is."
  (let ((*print-pretty* nil) (*print-right-margin* nil))
    (lisp-plus-slice1:render-derivation-why receipt)))


;;;; ==================================================================
;;;; MOVEMENT I — THE BENCH
;;;;
;;;; A condition survey, a compatibility filter over the treatment catalogue, a
;;;; drying schedule against the exhibition date, and a materials cost.  All of it
;;;; is ordinary Common Lisp over ordinary structures, and none of it needs to be
;;;; anything else: a millimetre of cockling is not a claim and a blotter sheet is
;;;; not a judgment.  (Owner ruling D1 — the quiet zone carries no obligation.)
;;;;
;;;; The workshop's calendar is an integer day-count.  There is no wall clock in
;;;; this program, and a conservation record that depended on one would be worse
;;;; than useless: it would be unreproducible.
;;;; ==================================================================

(defstruct (manuscript (:conc-name ms-))
  id title substrate medium folios)

(defstruct (condition-note (:conc-name cn-))
  manuscript distortion-mm ink-grade tears tideline surveyor)

(defstruct (treatment-option (:conc-name to-))
  key label reversible stages chamber-hours blotter-sheets
  permitted-substrates max-ink-grade)

(defstruct (work-order (:conc-name wo-))
  id manuscript method state opened stage-log completed-on account case-id)

(defstruct (reassessment-case (:conc-name rc-))
  id manuscript reason known unknown required-action)

(defstruct (exhibition-request (:conc-name xr-))
  id manuscript exhibition decision basis)

(defparameter *today* 4183
  "Day 4183 of the workshop's own count. No wall clock, ever.")

(defparameter *exhibition-opens* 4212)

(defparameter *bench*
  (list (make-manuscript :id "codex:umbra-17" :title "Umbrarum Liber"
                         :substrate :parchment :medium :iron-gall :folios 74)
        (make-manuscript :id "codex:vetus-4" :title "Antiphonarium Vetus"
                         :substrate :parchment :medium :carbon :folios 220)
        (make-manuscript :id "chart:hydro-2" :title "Carta Hydrographica"
                         :substrate :laid-paper :medium :iron-gall :folios 1)))

(defparameter *condition-notes*
  (list (make-condition-note :manuscript "codex:umbra-17" :distortion-mm 11
                             :ink-grade 3 :tears 6 :tideline t :surveyor :dorotea)
        (make-condition-note :manuscript "codex:vetus-4" :distortion-mm 2
                             :ink-grade 1 :tears 0 :tideline nil :surveyor :dorotea)
        (make-condition-note :manuscript "chart:hydro-2" :distortion-mm 19
                             :ink-grade 4 :tears 11 :tideline t :surveyor :ambrus)))

(defparameter *treatment-catalogue*
  (list (make-treatment-option
         :key :controlled-humidification :label "controlled humidification"
         :reversible nil :stages 1 :chamber-hours 18 :blotter-sheets 24
         :permitted-substrates '(:parchment :laid-paper) :max-ink-grade 3)
        (make-treatment-option
         :key :pressure-flattening :label "flattening under graded pressure"
         :reversible nil :stages 1 :chamber-hours 0 :blotter-sheets 48
         :permitted-substrates '(:parchment) :max-ink-grade 3)
        (make-treatment-option
         :key :aqueous-washing :label "aqueous washing"
         :reversible nil :stages 2 :chamber-hours 6 :blotter-sheets 60
         :permitted-substrates '(:laid-paper) :max-ink-grade 1)
        (make-treatment-option
         :key :solvent-consolidation :label "solvent consolidation of the medium"
         :reversible nil :stages 1 :chamber-hours 4 :blotter-sheets 0
         :permitted-substrates '(:parchment :laid-paper) :max-ink-grade 2)))

(defparameter *chamber-rate* 7 "Crowns per chamber hour.")
(defparameter *blotter-unit* 2 "Crowns per blotter sheet.")

(defun bench-lookup (id)
  (find id *bench* :key #'ms-id :test #'string=))

(defun note-for (id)
  (find id *condition-notes* :key #'cn-manuscript :test #'string=))

(defun option-for (key)
  (find key *treatment-catalogue* :key #'to-key))

(defun distortion-class (mm)
  "The bench's own three-way reading of a cockling measurement."
  (cond ((<= mm 3) :flat) ((<= mm 12) :cockled) (t :severely-distorted)))

(defun option-permitted-p (option note manuscript)
  "Ordinary compatibility arithmetic: is this substrate on the option's list, and
is the ink no more soluble than the option tolerates?  This decides which
treatments are worth ASKING about.  It decides nothing about whether one may be
performed — that is Movements II to IV, and it is a different kind of question."
  (and (member (ms-substrate manuscript) (to-permitted-substrates option))
       (<= (cn-ink-grade note) (to-max-ink-grade option))))

(defun options-for (id)
  (let ((m (bench-lookup id)) (n (note-for id)))
    (remove-if-not (lambda (o) (option-permitted-p o n m)) *treatment-catalogue*)))

(defun drying-days (option)
  "One day of controlled drying per six chamber hours, and one more per stage."
  (+ (ceiling (to-chamber-hours option) 6) (to-stages option)))

(defun earliest-return-day (option &optional (start *today*))
  (+ start (drying-days option)))

(defun fits-before-exhibition-p (option &optional (start *today*))
  (<= (earliest-return-day option start) *exhibition-opens*))

(defun materials-cost (option)
  (+ (* *chamber-rate* (to-chamber-hours option))
     (* *blotter-unit* (to-blotter-sheets option))))

(defun bench-line (option)
  (format nil "~22A stages ~D  chamber ~2Dh  blotter ~2D  ~4D crowns  back by day ~D"
          (to-label option) (to-stages option) (to-chamber-hours option)
          (to-blotter-sheets option) (materials-cost option)
          (earliest-return-day option)))

(defun survey-line (id)
  (let ((m (bench-lookup id)) (n (note-for id)))
    (format nil "~14A ~22A ~10A/~10A ~3D folios  distortion ~2Dmm (~A)  ink grade ~D  ~D tear~:P~@[  tideline~]"
            (ms-id m) (ms-title m) (ms-substrate m) (ms-medium m) (ms-folios m)
            (cn-distortion-mm n) (distortion-class (cn-distortion-mm n))
            (cn-ink-grade n) (cn-tears n) (cn-tideline n))))

(format t "~%+==================================================================+~%")
(format t   "|  DE CODICE RESTAURANDO — the conservation workshop, day ~D      |~%" *today*)
(format t   "|  one damaged manuscript; the exhibition opens on day ~D        |~%" *exhibition-opens*)
(format t   "+==================================================================+~%")

(format t "~%-- MOVEMENT I: the bench (ordinary Common Lisp, no standing) --~%")
(format t "~%   the condition survey, as the surveyor left it:~%")
(dolist (m *bench*) (format t "     ~A~%" (survey-line (ms-id m))))

(format t "~%   the treatment catalogue filtered for codex:umbra-17 — parchment,~%")
(format t "   iron-gall at solubility grade 3:~%")
(dolist (o (options-for "codex:umbra-17")) (format t "     ~A~%" (bench-line o)))
(format t "~%   and the two the filter excluded, with the reason:~%")
(dolist (o *treatment-catalogue*)
  (unless (option-permitted-p o (note-for "codex:umbra-17") (bench-lookup "codex:umbra-17"))
    (format t "     ~22A excluded — substrates ~A, ink tolerance grade ~D~%"
            (to-label o) (fmt (to-permitted-substrates o)) (to-max-ink-grade o))))

(bench "the exhibition opens in ~D day~:P; every permitted option comes back in time."
       (- *exhibition-opens* *today*))

(ok "[I-a] the bench reads a structure, not a claim"
    (and (manuscript-p (bench-lookup "codex:umbra-17"))
         (eq :parchment (ms-substrate (bench-lookup "codex:umbra-17")))))
(ok "[I-b] the distortion class is ordinary three-way arithmetic over a measurement"
    (and (eq :cockled (distortion-class 11))
         (eq :flat (distortion-class 2))
         (eq :severely-distorted (distortion-class 19))))
(ok "[I-c] the compatibility filter is an ordinary predicate: 2 of 4 options survive it"
    (and (= 2 (length (options-for "codex:umbra-17")))
         (equal '(:controlled-humidification :pressure-flattening)
                (mapcar #'to-key (options-for "codex:umbra-17")))))
(ok "[I-d] the schedule and the cost are ordinary integers carrying no receipt"
    (and (= 4 (drying-days (option-for :controlled-humidification)))
         (= 174 (materials-cost (option-for :controlled-humidification)))
         (fits-before-exhibition-p (option-for :controlled-humidification))))
(ok "[I-e] a treatment the ink will not tolerate is filtered out here, by arithmetic — and that is NOT the same act as refusing it"
    (and (null (member :solvent-consolidation
                       (mapcar #'to-key (options-for "codex:umbra-17"))))
         (> (cn-ink-grade (note-for "codex:umbra-17"))
            (to-max-ink-grade (option-for :solvent-consolidation))))
    "the filter narrows what is worth asking; Movement II decides what is established")
(bench "nothing above produced a receipt, a witness, or an outcome — and nothing")
(bench "above owed one. The bench proposes; the language disposes.")


;;;; ==================================================================
;;;; THE WORKSHOP'S LISP+ VOCABULARY
;;;;
;;;; Four adapters onto the public surface, then eight schemas.  The schemas are
;;;; the only place the workshop's policy is written down, and that is deliberate:
;;;; a premise a schema does not name cannot be enforced, and a premise it names
;;;; cannot be skipped.
;;;;
;;;; Read the eight together and the whole program is visible.  Two of them
;;;; conclude about MATERIAL, two about AUTHORITY, one requires a premise from
;;;; each, and three live downstream of the treatment itself.
;;;; ==================================================================

(defun np (form) (lisp-plus-slice1:proposition form))
(defun pp (form) (lisp-plus-slice1:proposition-pattern form))

(defun attest (form &key (kind :observation) (source :workshop))
  "A direct witness for something a conservator actually observed at the bench."
  (lisp-plus-slice0:witness :for (np form) :mode :direct :kind kind :source source))

(defun contradict (form &key (source :condition-survey))
  "Represented counter-evidence: the workshop knows this proposition to be FALSE."
  (lisp-plus-slice1:refutation :refutes form :source source))

(defun at-the-bench (&rest supports)
  "The receiving position: which desk is judging, and which supports it may read.

A witness is reached by its WITNESS-ID and a judged claim by its CLAIM-ID — the
same membership rule read against two different durable identities.  Nothing is
ambiently reachable: a claim this workshop derived a minute ago is unreadable
here unless it is named here.  Movement V arm D is what forgetting that costs."
  (lisp-plus-slice0:receiver-context
   :context-id :umbra-workshop
   :accessible-supports
   (mapcan (lambda (s)
             (cond ((lisp-plus-slice0:witness-p s)
                    (list (lisp-plus-slice0:witness-id s)))
                   ((lisp-plus-slice0:claim-p s)
                    (list (lisp-plus-slice0:claim-id s)))))
           supports)))

(lisp-plus-slice1:clear-schema-registry)

;;; ---- THE MATERIAL BRANCH ------------------------------------------
;;; What the parchment and the ink will bear.  Nothing in these two schemas
;;; mentions consent, policy, mandate, ownership, or a principal.  They cannot:
;;; a schema's premises are its whole vocabulary.

(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :ink-stability :version 1
  :conclusion (pp '(:predicate :ink-stability-established
                    (:manuscript (:var :manuscript)) (:medium (:var :medium))))
  :premises
  (list (pp '(:predicate :solubility-tested (:manuscript (:var :manuscript))
              (:medium (:var :medium)) (:assay (:var :assay))))
        (pp '(:predicate :binder-identified (:manuscript (:var :manuscript))
              (:medium (:var :medium)) (:analysis (:var :analysis)))))
  :locals '(:assay :analysis)))

(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :material-suitability :version 1
  :conclusion (pp '(:predicate :treatment-materially-suitable
                    (:manuscript (:var :manuscript)) (:method (:var :method))))
  :premises
  ;; the first premise is a conclusion the workshop must already have GRANTED
  (list (pp '(:predicate :ink-stability-established (:manuscript (:var :manuscript))
              (:medium (:var :medium))))
        (pp '(:predicate :substrate-response-tested (:manuscript (:var :manuscript))
              (:method (:var :method)) (:assay (:var :assay)))))
  :locals '(:medium :assay)))

;;; ---- THE AUTHORITY BRANCH -----------------------------------------
;;; Who may touch the object, under which instrument.  Nothing in these two
;;; schemas mentions ink, substrate, distortion, or an assay.
;;;
;;; :PRINCIPAL is declared a UNIQUE-LOCAL.  That single word is the whole of the
;;; workshop's answer to the deposit agreement's uncertain intervention clause:
;;; two parties consenting as owner is not two witnesses to one fact, it is a
;;; question about who the owner is, and the language is told to treat a second
;;; surviving value as a conflict rather than as corroboration.

(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :owner-authority :version 1
  :conclusion (pp '(:predicate :owner-authority-established
                    (:manuscript (:var :manuscript))))
  :premises
  (list (pp '(:predicate :deposit-agreement-in-force (:manuscript (:var :manuscript))
              (:register (:var :register))))
        (pp '(:predicate :intervention-consent-recorded (:manuscript (:var :manuscript))
              (:principal (:var :principal)))))
  :locals '(:register :principal)
  :unique-locals '(:principal)))

(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :institutional-authority :version 1
  :conclusion (pp '(:predicate :treatment-institutionally-authorized
                    (:manuscript (:var :manuscript)) (:method (:var :method))))
  :premises
  (list (pp '(:predicate :owner-authority-established (:manuscript (:var :manuscript))))
        (pp '(:predicate :conservation-mandate-current (:method (:var :method))
              (:policy (:var :policy)))))
  :locals '(:policy)))

;;; ---- THE RECONVERGENCE --------------------------------------------
;;; No local variables at all.  Both premises are bound entirely by the
;;; conclusion, and both must be discharged by something the receiving bench can
;;; read.  This schema is the workshop's constitution in five lines.

(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :treatment-authorization :version 1
  :conclusion (pp '(:predicate :treatment-authorized
                    (:manuscript (:var :manuscript)) (:method (:var :method))))
  :premises
  (list (pp '(:predicate :treatment-materially-suitable
              (:manuscript (:var :manuscript)) (:method (:var :method))))
        (pp '(:predicate :treatment-institutionally-authorized
              (:manuscript (:var :manuscript)) (:method (:var :method)))))))

;;; ---- DOWNSTREAM OF THE TREATMENT ----------------------------------
;;; :TREATMENT-COMPLETED is the premise this whole program was built to reach.
;;; It is not a standing the workshop can derive and not a policy it can consult.
;;; It is a fact about what happened to a physical object, and Movement VII is
;;; about what the language does when the workshop holds a true account of it.

(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :post-treatment-standing :version 1
  :conclusion (pp '(:predicate :post-treatment-condition-established
                    (:manuscript (:var :manuscript)) (:method (:var :method))))
  :premises
  (list (pp '(:predicate :treatment-completed (:manuscript (:var :manuscript))
              (:method (:var :method))))
        (pp '(:predicate :condition-reassessed (:manuscript (:var :manuscript))
              (:assay (:var :assay)))))
  :locals '(:assay)))

(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :documentation-standing :version 1
  :conclusion (pp '(:predicate :treatment-documented (:manuscript (:var :manuscript))))
  :premises
  (list (pp '(:predicate :treatment-authorized (:manuscript (:var :manuscript))
              (:method (:var :method))))
        (pp '(:predicate :custody-log-complete (:manuscript (:var :manuscript))
              (:register (:var :register)))))
  :locals '(:method :register)))

;;; The exhibition decision.  Note what is NOT a premise here: authorization.
;;; That a treatment was permitted says nothing about whether it left the object
;;; safe to display, and this schema is where the workshop refuses to confuse the
;;; two.  Movement VIII offers it the authorization anyway, and it does not take.

(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :exhibition-standing :version 1
  :conclusion (pp '(:predicate :safe-to-exhibit (:manuscript (:var :manuscript))
                    (:exhibition (:var :exhibition))))
  :premises
  (list (pp '(:predicate :post-treatment-condition-established
              (:manuscript (:var :manuscript)) (:method (:var :method))))
        (pp '(:predicate :treatment-documented (:manuscript (:var :manuscript)))))
  :locals '(:method)))

;;; ---- reading the receipts -----------------------------------------

(defun consider (&key schema (version 1) conclusion supports receiver)
  "Attempt a derivation, returning (values CLAIM RECEIPT) with CLAIM nil on
refusal.  `derive` SIGNALS on refusal, and for a conservation workshop refusal is
not exceptional — refusal is most of the job."
  (handler-case
      (lisp-plus-slice1:derive :schema-name schema :schema-version version
                               :conclusion conclusion :supports supports
                               :receiver receiver)
    (lisp-plus-slice1:derivation-refused (c)
      (values nil (lisp-plus-slice1:slice1-condition-receipt c)))))

(defun verdict (receipt)
  (lisp-plus-slice1:derivation-receipt-strongest-lawful-result receipt))

(defun assessment-for (receipt predicate)
  (find predicate (lisp-plus-slice1:derivation-receipt-assessments receipt)
        :key (lambda (a) (second (lisp-plus-slice1:premise-assessment-premise-pattern a)))))

(defun disposition-of (receipt predicate)
  (let ((a (assessment-for receipt predicate)))
    (and a (lisp-plus-slice1:premise-assessment-disposition a))))

(defun roster-for (receipt predicate)
  (let ((a (assessment-for receipt predicate)))
    (and a (lisp-plus-slice1:premise-assessment-judged-claims a))))

(defun roster-entry-for (receipt predicate the-claim)
  "The roster entry this receipt kept for THE-CLAIM under PREDICATE, found by
DURABLE IDENTITY and never by position.  A premise's roster holds one entry per
claim offered — including claims offered for a different premise — so `first` is
a guess and identity is the answer."
  (find-if (lambda (e)
             (lisp-plus-kernel0:identity= (getf e :claim-id)
                                          (lisp-plus-slice0:claim-id the-claim)))
           (roster-for receipt predicate)))

(defun repair-for (receipt predicate)
  (cdr (assoc predicate (lisp-plus-slice1:derivation-receipt-repair-options receipt)
              :key (lambda (p) (second p)))))

(defun residue-of (receipt)
  (lisp-plus-slice1:derivation-receipt-unsupported-supports receipt))

;;; The workshop's SPEECH is selected by the receipt, keyed on
;;; (premise . disposition).  The workshop cannot say a thing its receipt does
;;; not license, because the sentence is looked up under the receipt's own words.
(defparameter *workshop-speech*
  '(((:ink-stability-established . :missing)
     . "the medium's stability is not established; no treatment touches this ink yet")
    ((:ink-stability-established . :refuted)
     . "the solubility assay says NO — this ink moves in moisture")
    ((:substrate-response-tested . :missing)
     . "the substrate was never tested for this treatment")
    ((:solubility-tested . :refuted)
     . "the assay contradicts stability outright; this is a finding, not a gap")
    ((:treatment-materially-suitable . :missing)
     . "nothing before me establishes that this material will bear this treatment")
    ((:treatment-materially-suitable . :mismatched)
     . "the suitability I hold is for a DIFFERENT object; roles conflict")
    ((:treatment-institutionally-authorized . :missing)
     . "no institutional authorization for this intervention exists")
    ((:treatment-institutionally-authorized . :inaccessible)
     . "an authorization exists; THIS bench was not given the right to read it")
    ((:owner-authority-established . :missing)
     . "owner authority is not established")
    ((:owner-authority-established . :ambiguous)
     . "two parties consent as owner; the agreement's intervention clause is contested")
    ((:intervention-consent-recorded . :missing)
     . "no intervention consent is on file")
    ((:intervention-consent-recorded . :ambiguous)
     . "the consents on file name different principals")
    ((:conservation-mandate-current . :missing)
     . "the conservation mandate for this method is not current")
    ((:treatment-completed . :missing)
     . "nothing before me establishes that the treatment was completed")
    ((:condition-reassessed . :missing)
     . "the object has not been reassessed since treatment")
    ((:post-treatment-condition-established . :missing)
     . "post-treatment condition is not established; I cannot clear this for display")
    ((:treatment-documented . :missing)
     . "the treatment file is incomplete")
    ((:custody-log-complete . :missing)
     . "the custody log has a gap")))

(defun say-the-verdict (receipt)
  (let ((v (verdict receipt)))
    (if (eq (lisp-plus-slice1:derivation-receipt-decision receipt) :granted)
        (bench "granted.")
        (destructuring-bind (blocked premise disposition) v
          (declare (ignore blocked))
          (bench "refused — ~A is ~A: ~A" (fmt premise) (fmt disposition)
                 (or (cdr (assoc (cons premise disposition) *workshop-speech*
                                 :test #'equal))
                     "(no counter phrasing for this disposition)"))
          (let ((repair (repair-for receipt premise)))
            (when repair
              (format t "     repair (verbatim from the receipt): ~A~%" (fmt repair))))))))

(defparameter *umbra* "codex:umbra-17")
(defparameter *all-receipts* '()
  "Every derivation receipt this program produced, pushed as it was produced.
Movement IX counts grounding cardinalities over it.  It is a TALLY, consulted by
nothing that decides anything; no premise, disposition or state anywhere in this
program is read out of it.")

(defun record-receipt (r) (when r (push r *all-receipts*)) r)


;;;; ==================================================================
;;;; MOVEMENT II — THE MATERIAL BRANCH
;;;;
;;;; Two hops.  The first turns two laboratory assays into an established
;;;; statement about the medium; the second turns that statement plus a substrate
;;;; response test into a suitability standing for a NAMED treatment.
;;;;
;;;; Note where the three-valuedness lives.  The solubility assay has three
;;;; honest outcomes and each maps to a different EVIDENTIAL SHAPE: a witness
;;;; (stable), a refutation (it moved), and nothing at all (the assay was not
;;;; run).  A boolean `ink-stable-p` would have flattened the third into the
;;;; second, and a conservator who cannot tell "the ink moved" from "we did not
;;;; look" is a hazard to the object.
;;;; ==================================================================

(defparameter *assay-log*
  '(("codex:umbra-17" :solubility :stable      "ASY-4411")
    ("codex:umbra-17" :binder     :identified  "ASY-4412")
    ("codex:umbra-17" :substrate-humidification :responded "ASY-4413")
    ("codex:umbra-17" :substrate-humidification :responded "ASY-4419")
    ("codex:umbra-17" :substrate-flattening     :responded "ASY-4421")
    ("chart:hydro-2"  :solubility :bled        "ASY-4501")
    ("chart:hydro-2"  :binder     :identified  "ASY-4502")
    ("chart:hydro-2"  :substrate-humidification :responded "ASY-4503"))
  "The laboratory's own log: (manuscript test result reference).  Ordinary data.
Two humidification response tests were run on umbra-17 by two conservators on
two fragments; the workshop kept both, because in conservation a second
independent test is corroboration and not a nuisance.")

(defun assays (id test)
  (remove-if-not (lambda (row) (and (string= id (first row)) (eq test (second row))))
                 *assay-log*))

(defun solubility-support (id)
  "Three laboratory outcomes, three evidential shapes.  NIL is a real answer."
  (let ((row (first (assays id :solubility))))
    (cond ((null row) nil)
          ((eq :stable (third row))
           (attest `(:predicate :solubility-tested (:manuscript ,id)
                     (:medium ,(ms-medium (bench-lookup id))) (:assay ,(fourth row)))
                   :kind :assay :source :laboratory))
          (t (contradict (np `(:predicate :solubility-tested (:manuscript ,id)
                               (:medium ,(ms-medium (bench-lookup id)))
                               (:assay ,(fourth row))))
                         :source :laboratory)))))

(defun binder-support (id)
  (let ((row (first (assays id :binder))))
    (and row (attest `(:predicate :binder-identified (:manuscript ,id)
                       (:medium ,(ms-medium (bench-lookup id)))
                       (:analysis ,(fourth row)))
                     :kind :analysis :source :laboratory))))

(defun substrate-supports (id method)
  "Every response test the laboratory ran for METHOD.  There may be more than one
and the workshop does not choose between them."
  (let ((test (ecase method
                (:controlled-humidification :substrate-humidification)
                (:pressure-flattening :substrate-flattening))))
    (mapcar (lambda (row)
              (attest `(:predicate :substrate-response-tested (:manuscript ,id)
                        (:method ,method) (:assay ,(fourth row)))
                      :kind :assay :source :laboratory))
            (assays id test))))

(defun establish-ink-stability (id)
  (let ((sup (remove nil (list (solubility-support id) (binder-support id)))))
    (consider :schema :ink-stability
              :conclusion (np `(:predicate :ink-stability-established
                                (:manuscript ,id) (:medium ,(ms-medium (bench-lookup id)))))
              :supports sup :receiver (apply #'at-the-bench sup))))

(defun establish-material-suitability (id method stability-claim)
  (let ((sup (remove nil (cons stability-claim (substrate-supports id method)))))
    (consider :schema :material-suitability
              :conclusion (np `(:predicate :treatment-materially-suitable
                                (:manuscript ,id) (:method ,method)))
              :supports sup :receiver (apply #'at-the-bench sup))))

(format t "~%-- MOVEMENT II: the material branch (assays -> stability -> suitability) --~%")

(format t "~%   hop M1 — two assays establish the medium's stability:~%")
(defparameter *stability* nil)
(defparameter *stability-receipt* nil)
(multiple-value-bind (claim receipt) (establish-ink-stability *umbra*)
  (setf *stability* claim *stability-receipt* (record-receipt receipt))
  (say-the-verdict receipt)
  (ok "[II-a] two separately-witnessed assays grant :INK-STABILITY-ESTABLISHED"
      (and claim (eq :granted (lisp-plus-slice1:derivation-receipt-decision receipt))))
  (ok "[II-b] the grant is a real Slice /0 promotion, judgment :VERIFIED — not a flag"
      (eq :verified (lisp-plus-slice0:judgment-record-judgment
                     (lisp-plus-slice0:claim-judgment claim))))
  (ok "[II-c] and it is an OBJECT with a proposition, reusable by whatever needs it"
      (equal (lisp-plus-slice0:claim-proposition claim)
             (np `(:predicate :ink-stability-established (:manuscript ,*umbra*)
                   (:medium :iron-gall))))))

(format t "~%   hop M2 — stability plus the substrate response tests make a~%")
(format t "            suitability standing for controlled humidification:~%")
(defparameter *material-humid* nil)
(defparameter *material-humid-receipt* nil)
(defparameter *stability-judgment-before* (lisp-plus-slice0:claim-judgment *stability*))
(multiple-value-bind (claim receipt)
    (establish-material-suitability *umbra* :controlled-humidification *stability*)
  (setf *material-humid* claim *material-humid-receipt* (record-receipt receipt))
  (say-the-verdict receipt)
  (let ((entry (roster-entry-for receipt :ink-stability-established *stability*))
        (a (assessment-for receipt :ink-stability-established)))
    (ok "[II-d] the verified judged claim DISCHARGES the inherited premise — no witness was minted for it"
        (and claim (eq :satisfied (disposition-of receipt :ink-stability-established))
             (null (lisp-plus-slice1:premise-assessment-matching-accessible-supports a))))
    (ok "[II-e] the receipt records the supporting claim IDENTITY and its JUDGMENT BASIS"
        (and entry (eq :discharged (getf entry :outcome))
             (eq :verified (getf entry :judgment))
             (lisp-plus-kernel0:durable-identity-p (getf entry :procedure-id))))
    (format t "     inherited basis, read out of the receipt:~%")
    (format t "       claim      ~A~%" (lisp-plus-kernel0:identity-key (getf entry :claim-id)))
    (format t "       judgment   ~A~%" (fmt (getf entry :judgment)))
    (format t "       procedure  ~A  v~D~%"
            (lisp-plus-kernel0:identity-key (getf entry :procedure-id))
            (getf entry :procedure-version))
    (ok "[II-f] the spent claim is UNTOUCHED: the same judgment record, still on the claim, still :VERIFIED"
        (and (eq *stability-judgment-before* (lisp-plus-slice0:claim-judgment *stability*))
             (eq :verified (lisp-plus-slice0:judgment-record-judgment
                            *stability-judgment-before*)))
        "nothing converted a judgment into a witness on the way past")
    ;; The two humidification assays are two complete environments, and the
    ;; language kept both rather than picking one.
    (ok "[II-g] TWO independent response assays yield TWO complete ground environments, and the language kept both"
        (and (= 2 (length (lisp-plus-slice1:derivation-receipt-complete-binding-environments receipt)))
             (lisp-plus-slice1:derivation-receipt-multiply-supported-p receipt)
             (null (lisp-plus-slice1:derivation-receipt-uniqueness-conflicts receipt)))
        (format nil "~D complete environment(s); no uniqueness was declared over :ASSAY, because two agreeing assays are corroboration and not a conflict"
                (length (lisp-plus-slice1:derivation-receipt-complete-binding-environments receipt))))))

(format t "~%   hop M2-bis — the same stability claim, spent a SECOND time, for the~%")
(format t "               riskier treatment (one response assay covered it):~%")
(defparameter *material-flatten* nil)
(defparameter *material-flatten-receipt* nil)
(multiple-value-bind (claim receipt)
    (establish-material-suitability *umbra* :pressure-flattening *stability*)
  (setf *material-flatten* claim *material-flatten-receipt* (record-receipt receipt))
  (say-the-verdict receipt)
  (ok "[II-h] one claim discharges premises in TWO different derivations and is still inspectable after both"
      (and claim
           (eq :satisfied (disposition-of receipt :ink-stability-established))
           (eq *stability-judgment-before* (lisp-plus-slice0:claim-judgment *stability*))
           (eq :verified (lisp-plus-slice0:judgment-record-judgment
                          *stability-judgment-before*))))
  (ok "[II-i] and THIS receipt has exactly one ground environment — the plurality above was the laboratory's, not the schema's"
      (= 1 (length (lisp-plus-slice1:derivation-receipt-complete-binding-environments receipt)))))


;;;; ==================================================================
;;;; MOVEMENT III — THE AUTHORITY BRANCH
;;;;
;;;; Two hops on a wholly different axis.  Consent and a deposit agreement
;;;; establish who may authorize an intervention; that authority plus a current
;;;; conservation mandate authorizes a named method.
;;;;
;;;; And then the case the deposit file actually presents: TWO consents, from two
;;;; parties who each believe themselves the owner.  The workshop does not pick.
;;;; It declared :PRINCIPAL unique when it wrote the schema, so the language
;;;; refuses with a NAMED ambiguity, and the refusal is legible enough to hand to
;;;; a lawyer.
;;;; ==================================================================

(defparameter *deposit-register*
  (attest `(:predicate :deposit-agreement-in-force (:manuscript ,*umbra*)
            (:register "DEP-1902/umbra"))
          :kind :instrument :source :registrar))

(defparameter *consent-heir*
  (attest `(:predicate :intervention-consent-recorded (:manuscript ,*umbra*)
            (:principal :heir-of-arles))
          :kind :consent :source :registrar))

(defparameter *consent-foundation*
  (attest `(:predicate :intervention-consent-recorded (:manuscript ,*umbra*)
            (:principal :foundation-vasari))
          :kind :consent :source :registrar)
  "The second consent, from the party the 1902 deposit names as successor. Filed
in the same folder as the first. Nobody at the bench can adjudicate this.")

(defun mandate-support (method)
  (attest `(:predicate :conservation-mandate-current (:method ,method)
            (:policy "POL-CONS-7"))
          :kind :mandate :source :conservation-committee))

(defun establish-owner-authority (&rest consents)
  (let ((sup (cons *deposit-register* consents)))
    (consider :schema :owner-authority
              :conclusion (np `(:predicate :owner-authority-established
                                (:manuscript ,*umbra*)))
              :supports sup :receiver (apply #'at-the-bench sup))))

(defun establish-institutional-authority (method authority-claim)
  (let ((sup (remove nil (list authority-claim (mandate-support method)))))
    (consider :schema :institutional-authority
              :conclusion (np `(:predicate :treatment-institutionally-authorized
                                (:manuscript ,*umbra*) (:method ,method)))
              :supports sup :receiver (apply #'at-the-bench sup))))

(format t "~%-- MOVEMENT III: the authority branch (consent -> authority -> mandate) --~%")

(format t "~%   3a. the deposit file as it FIRST arrived — both consents in one folder:~%")
(multiple-value-bind (claim receipt)
    (establish-owner-authority *consent-heir* *consent-foundation*)
  (record-receipt receipt)
  (say-the-verdict receipt)
  (let ((conflicts (lisp-plus-slice1:derivation-receipt-uniqueness-conflicts receipt))
        (a (assessment-for receipt :intervention-consent-recorded)))
    (format t "     the conflict as the receipt states it: local ~A over values ~A~%"
            (fmt (first (first conflicts))) (fmt (second (first conflicts))))
    (ok "[III-a] two consents naming two principals refuse :AMBIGUOUS, and the receipt NAMES the local"
        (and (null claim)
             (eq :ambiguous (disposition-of receipt :intervention-consent-recorded))
             (equal '(:principal) (mapcar #'first conflicts))))
    (ok "[III-b] both consents are visible as accepted, matching, accessible support — the ambiguity is not a rejection of either"
        (= 2 (length (lisp-plus-slice1:premise-assessment-matching-accessible-supports a)))
        "the language did not discard one to make progress, which is exactly what a bench under exhibition pressure would have done")
    (ok "[III-c] and the OTHER premise is satisfied, so this is a contested clause and not a missing file"
        (eq :satisfied (disposition-of receipt :deposit-agreement-in-force)))))

(bench "the workshop does not resolve this at the bench. The registrar obtains a")
(bench "ruling; the Vasari foundation is confirmed successor; the heir's consent")
(bench "is withdrawn from the file. Only THEN is there one principal.")

(format t "~%   3b. hop A1 — the file as the registrar returned it, one consent:~%")
(defparameter *owner-authority* nil)
(defparameter *owner-authority-receipt* nil)
(multiple-value-bind (claim receipt) (establish-owner-authority *consent-foundation*)
  (setf *owner-authority* claim *owner-authority-receipt* (record-receipt receipt))
  (say-the-verdict receipt)
  (ok "[III-d] one principal, one complete environment, no declared conflict: :OWNER-AUTHORITY-ESTABLISHED is granted"
      (and claim
           (= 1 (length (lisp-plus-slice1:derivation-receipt-complete-binding-environments receipt)))
           (null (lisp-plus-slice1:derivation-receipt-uniqueness-conflicts receipt)))))

(format t "~%   hop A2 — owner authority plus the committee's current mandate:~%")
(defparameter *authority-humid* nil)
(defparameter *authority-humid-receipt* nil)
(defparameter *authority-judgment-before*
  (lisp-plus-slice0:claim-judgment *owner-authority*))
(multiple-value-bind (claim receipt)
    (establish-institutional-authority :controlled-humidification *owner-authority*)
  (setf *authority-humid* claim *authority-humid-receipt* (record-receipt receipt))
  (say-the-verdict receipt)
  (let ((entry (roster-entry-for receipt :owner-authority-established *owner-authority*)))
    (ok "[III-e] the authority branch chains by judgment identity exactly as the material branch does"
        (and claim (eq :satisfied (disposition-of receipt :owner-authority-established))
             entry (eq :discharged (getf entry :outcome))
             (eq :verified (getf entry :judgment))))
    (ok "[III-f] the spent authority claim is untouched too"
        (eq *authority-judgment-before*
            (lisp-plus-slice0:claim-judgment *owner-authority*)))))

(format t "~%   hop A2-bis — and for the riskier treatment, on the same authority:~%")
(defparameter *authority-flatten* nil)
(defparameter *authority-flatten-receipt* nil)
(multiple-value-bind (claim receipt)
    (establish-institutional-authority :pressure-flattening *owner-authority*)
  (setf *authority-flatten* claim *authority-flatten-receipt* (record-receipt receipt))
  (say-the-verdict receipt)
  (ok "[III-g] the second method is authorized on the same owner authority"
      (not (null claim))))


;;;; ==================================================================
;;;; MOVEMENT IV — THE RECONVERGENCE
;;;;
;;;; The two branches meet here and nowhere else.  :TREATMENT-AUTHORIZATION has
;;;; two premises, one from each branch, and no local variables at all — so both
;;;; are bound entirely by the requested conclusion and both must be discharged.
;;;;
;;;; Then four impersonation attempts.  The interesting one is the fourth: the
;;;; two branch claims were judged by two different procedures, and this movement
;;;; checks that the difference is RECORDED PROVENANCE and never a compatibility
;;;; selector — the discharge is by proposition under bindings, and the proof is
;;;; that a claim with the right predicate and the wrong manuscript lands
;;;; :MISMATCHED rather than satisfied.
;;;; ==================================================================

(format t "~%-- MOVEMENT IV: the reconvergence (both branches, or nothing) --~%")

(defun authorize (method material-claim authority-claim &key receiver)
  (let ((sup (remove nil (list material-claim authority-claim))))
    (consider :schema :treatment-authorization
              :conclusion (np `(:predicate :treatment-authorized
                                (:manuscript ,*umbra*) (:method ,method)))
              :supports sup
              :receiver (or receiver (apply #'at-the-bench sup)))))

(format t "~%   4a. both branch claims, handed to the authorization:~%")
(defparameter *authorized-humid* nil)
(defparameter *authorized-humid-receipt* nil)
(multiple-value-bind (claim receipt)
    (authorize :controlled-humidification *material-humid* *authority-humid*)
  (setf *authorized-humid* claim *authorized-humid-receipt* (record-receipt receipt))
  (say-the-verdict receipt)
  (let ((mat (roster-entry-for receipt :treatment-materially-suitable *material-humid*))
        (aut (roster-entry-for receipt :treatment-institutionally-authorized *authority-humid*)))
    (ok "[IV-a] :TREATMENT-AUTHORIZED is granted, and BOTH premises read :SATISFIED"
        (and claim
             (eq :satisfied (disposition-of receipt :treatment-materially-suitable))
             (eq :satisfied (disposition-of receipt :treatment-institutionally-authorized))))
    (ok "[IV-b] the receipt carries TWO governed bases, one per branch, each naming its own claim and its own judging procedure"
        (and mat aut
             (eq :discharged (getf mat :outcome)) (eq :discharged (getf aut :outcome))
             (eq :verified (getf mat :judgment))  (eq :verified (getf aut :judgment))
             (not (lisp-plus-kernel0:identity= (getf mat :procedure-id)
                                               (getf aut :procedure-id)))))
    (format t "     THE TWO BASES, read out of the one receipt:~%")
    (format t "       material  claim ~A~%" (lisp-plus-kernel0:identity-key (getf mat :claim-id)))
    (format t "                 judged ~A by ~A v~D~%"
            (fmt (getf mat :judgment))
            (lisp-plus-kernel0:identity-key (getf mat :procedure-id))
            (getf mat :procedure-version))
    (format t "       authority claim ~A~%" (lisp-plus-kernel0:identity-key (getf aut :claim-id)))
    (format t "                 judged ~A by ~A v~D~%"
            (fmt (getf aut :judgment))
            (lisp-plus-kernel0:identity-key (getf aut :procedure-id))
            (getf aut :procedure-version))
    (format t "     and the same receipt in the language's own words:~%")
    (explain receipt)
    ;; the chain is verified by identity, not by the order this program printed it
    (ok "[IV-c] each basis IS the claim its own branch granted — checked by durable identity, not by the order printed above"
        (and (lisp-plus-kernel0:identity= (getf mat :claim-id)
                                          (lisp-plus-slice0:claim-id *material-humid*))
             (lisp-plus-kernel0:identity= (getf aut :claim-id)
                                          (lisp-plus-slice0:claim-id *authority-humid*))))))

(format t "~%   4b. the same authorization for the riskier treatment:~%")
(defparameter *authorized-flatten* nil)
(defparameter *authorized-flatten-receipt* nil)
(multiple-value-bind (claim receipt)
    (authorize :pressure-flattening *material-flatten* *authority-flatten*)
  (setf *authorized-flatten* claim *authorized-flatten-receipt* (record-receipt receipt))
  (say-the-verdict receipt)
  (ok "[IV-d] the second treatment is authorized through its own two branch claims"
      (not (null claim))))

(format t "~%   4c. THE IMPERSONATION ATTEMPTS. Neither branch may stand for the other.~%")

(format t "~%       (i) the material claim alone:~%")
(multiple-value-bind (claim receipt)
    (authorize :controlled-humidification *material-humid* nil)
  (record-receipt receipt)
  (say-the-verdict receipt)
  (ok "[IV-e] a material conclusion alone does NOT authorize: the authority premise is :MISSING"
      (and (null claim)
           (eq :satisfied (disposition-of receipt :treatment-materially-suitable))
           (eq :missing (disposition-of receipt :treatment-institutionally-authorized)))
      "safe for the object is not the same sentence as permitted to us"))

(format t "~%       (ii) the authority claim alone:~%")
(multiple-value-bind (claim receipt)
    (authorize :controlled-humidification nil *authority-humid*)
  (record-receipt receipt)
  (say-the-verdict receipt)
  (ok "[IV-f] an authority conclusion alone does NOT imply suitability: the material premise is :MISSING"
      (and (null claim)
           (eq :missing (disposition-of receipt :treatment-materially-suitable))
           (eq :satisfied (disposition-of receipt :treatment-institutionally-authorized)))
      "permitted to us is not the same sentence as safe for the object"))

(format t "~%       (iii) the material claim offered TWICE, once in each slot:~%")
(multiple-value-bind (claim receipt)
    (authorize :controlled-humidification *material-humid* *material-humid*)
  (record-receipt receipt)
  (say-the-verdict receipt)
  (ok "[IV-g] a claim cannot fill a premise its proposition does not match, however it is positioned in :SUPPORTS"
      (and (null claim)
           (eq :missing (disposition-of receipt :treatment-institutionally-authorized)))
      "supports is a bag the language classifies, not a positional argument list")
  (ok "[IV-h] and the roster proves the language SAW it and considered it for that premise before declining"
      (let ((roster (roster-for receipt :treatment-institutionally-authorized)))
        (and roster
             (roster-entry-for receipt :treatment-institutionally-authorized *material-humid*)
             (eq :proposition-does-not-match
                 (getf (roster-entry-for receipt :treatment-institutionally-authorized
                                         *material-humid*)
                       :outcome))))
      "the outcome is :PROPOSITION-DOES-NOT-MATCH, which is a finding rather than a silence"))

(format t "~%       (iv) the right predicate, the WRONG object — is matching by name,~%")
(format t "            by schema, by procedure, or by proposition-under-bindings?~%")
(defparameter *vetus-stability*
  (multiple-value-bind (claim receipt)
      (let ((sup (list (attest '(:predicate :solubility-tested (:manuscript "codex:vetus-4")
                                 (:medium :carbon) (:assay "ASY-4601"))
                               :kind :assay :source :laboratory)
                       (attest '(:predicate :binder-identified (:manuscript "codex:vetus-4")
                                 (:medium :carbon) (:assay-analysis "ASY-4602")
                                 (:analysis "ASY-4602"))
                               :kind :analysis :source :laboratory))))
        (consider :schema :ink-stability
                  :conclusion (np '(:predicate :ink-stability-established
                                    (:manuscript "codex:vetus-4") (:medium :carbon)))
                  :supports sup :receiver (apply #'at-the-bench sup)))
    (record-receipt receipt)
    claim))
(defparameter *vetus-material*
  (multiple-value-bind (claim receipt)
      (establish-material-suitability "codex:vetus-4" :controlled-humidification
                                     *vetus-stability*)
    (record-receipt receipt)
    claim)
  "A perfectly good, genuinely :VERIFIED material suitability standing — for a
DIFFERENT manuscript. Same predicate, same method, same schema, same judging
procedure as umbra-17's. Everything a name-based or procedure-based compatibility
rule would look at is identical.")
(ok "[IV-i] the wrong-object claim is real: :VERIFIED, and judged by the very same procedure as umbra-17's material claim"
    (and *vetus-material*
         (eq :verified (lisp-plus-slice0:judgment-record-judgment
                        (lisp-plus-slice0:claim-judgment *vetus-material*)))
         (lisp-plus-kernel0:identity=
          (lisp-plus-slice0:judgment-record-procedure-id
           (lisp-plus-slice0:claim-judgment *vetus-material*))
          (lisp-plus-slice0:judgment-record-procedure-id
           (lisp-plus-slice0:claim-judgment *material-humid*))))
    "so if compatibility ran on procedure identity, schema name, or predicate name, this would discharge")
(multiple-value-bind (claim receipt)
    (authorize :controlled-humidification *vetus-material* *authority-humid*)
  (record-receipt receipt)
  (say-the-verdict receipt)
  (let ((a (assessment-for receipt :treatment-materially-suitable)))
    (ok "[IV-j] it lands :MISMATCHED, and the receipt names the conflicting ROLE — so matching is by proposition under bindings, not by any name"
        (and (null claim)
             (eq :mismatched (disposition-of receipt :treatment-materially-suitable))
             (equal '(:manuscript)
                    (remove-duplicates
                     (reduce #'append
                             (mapcar #'cdr (lisp-plus-slice1:premise-assessment-mismatched-candidates a))
                             :initial-value '())))))
    (format t "     the conflicting role, verbatim from the receipt: ~A~%"
            (fmt (mapcar #'cdr (lisp-plus-slice1:premise-assessment-mismatched-candidates a))))))


;;;; ==================================================================
;;;; MOVEMENT V — THE REFUSALS
;;;;
;;;; Three ways the workshop stops before it touches the object.  In each arm the
;;;; state of the work order is set by an ECASE over the RECEIPT'S DISPOSITION —
;;;; the workshop chooses no state of its own.
;;;; ==================================================================

(format t "~%-- MOVEMENT V: the refusals (three ways not to touch the object) --~%")

(defparameter *work-orders* '())
(defparameter *cases* '())

(defun state-from-authorization (receipt)
  "The work-order state, read off the authorization receipt. The workshop does
not choose here; the ECASE is total over the six dispositions and one of them is
the answer."
  (if (eq :granted (lisp-plus-slice1:derivation-receipt-decision receipt))
      :treatment-authorized
      (let ((blocked (second (verdict receipt))))
        (ecase (disposition-of receipt blocked)
          (:missing       :assessment-pending)
          (:refuted       :assessment-pending)
          (:mismatched    :assessment-pending)
          (:ambiguous     :reconciliation-required)
          (:inaccessible  :reconciliation-required)
          (:satisfied     :treatment-authorized)))))

(defun open-work-order (id method receipt)
  (let ((wo (make-work-order :id id :manuscript *umbra* :method method
                             :state (state-from-authorization receipt)
                             :opened *today* :stage-log '() :completed-on nil
                             :account nil :case-id nil)))
    (push wo *work-orders*)
    wo))

;;; --- B. material refusal: the ink will not bear it -------------------
(format t "~%   B. MATERIAL REFUSAL. The hydrographic chart's iron gall BLED in the~%")
(format t "      solubility assay. The workshop asks anyway, to see the shape of no:~%")
(multiple-value-bind (claim receipt) (establish-ink-stability "chart:hydro-2")
  (record-receipt receipt)
  (say-the-verdict receipt)
  (ok "[V-b1] a contradicted assay is :REFUTED — the language distinguishes a finding from a gap"
      (and (null claim) (eq :refuted (disposition-of receipt :solubility-tested))))
  (ok "[V-b2] and the positive support for the other premise stays visible beside the refutation"
      (and (eq :satisfied (disposition-of receipt :binder-identified))
           (= 1 (length (lisp-plus-slice1:premise-assessment-refuting-supports
                         (assessment-for receipt :solubility-tested)))))))

(format t "~%      so no suitability standing exists, so the authorization has nothing:~%")
(defparameter *hydro-material* nil)
(let ((sup (remove nil (list *hydro-material*
                             (first (substrate-supports "chart:hydro-2"
                                                        :controlled-humidification))))))
  (multiple-value-bind (claim receipt)
      (consider :schema :material-suitability
                :conclusion (np '(:predicate :treatment-materially-suitable
                                  (:manuscript "chart:hydro-2")
                                  (:method :controlled-humidification)))
                :supports sup :receiver (apply #'at-the-bench sup))
    (record-receipt receipt)
    (say-the-verdict receipt)
    (ok "[V-b3] the material branch stops at hop M2, and the RECEIPT is the reason — no guard of the workshop's fired"
        (and (null claim)
             (equal '(:blocked-on :ink-stability-established :missing) (verdict receipt))))
    (bench "NO EFFECT is attempted for chart:hydro-2 anywhere in this program.")
    (bench "The chart is returned to storage with its condition note amended.")))

;;; --- C. authority refusal: materially sensible, institutionally not --
(format t "~%   C. AUTHORITY REFUSAL. Aqueous washing is materially sensible for the~%")
(format t "      chart's laid paper, but the committee's mandate does not cover it:~%")
(multiple-value-bind (claim receipt)
    (let ((sup (list *owner-authority*)))
      (consider :schema :institutional-authority
                :conclusion (np `(:predicate :treatment-institutionally-authorized
                                  (:manuscript ,*umbra*) (:method :aqueous-washing)))
                :supports sup :receiver (apply #'at-the-bench sup)))
  (record-receipt receipt)
  (say-the-verdict receipt)
  (ok "[V-c1] with no mandate witness the authority branch refuses :MISSING while OWNER authority stays satisfied"
      (and (null claim)
           (eq :satisfied (disposition-of receipt :owner-authority-established))
           (eq :missing (disposition-of receipt :conservation-mandate-current)))))

(format t "~%      and the authorization therefore has one branch and not two:~%")
(defparameter *wo-washing* nil)
(multiple-value-bind (claim receipt)
    (authorize :aqueous-washing *material-humid* nil)
  (record-receipt receipt)
  (say-the-verdict receipt)
  (setf *wo-washing* (open-work-order "WO-1103" :aqueous-washing receipt))
  (ok "[V-c2] the work order lands :ASSESSMENT-PENDING, and the state came from the receipt's disposition"
      (and (null claim)
           (eq :assessment-pending (wo-state *wo-washing*))
           (eq :missing (disposition-of receipt :treatment-institutionally-authorized))))
  (ok "[V-c3] and NOTHING was performed: no account on the work order, no completion date"
      (and (null (wo-account *wo-washing*)) (null (wo-completed-on *wo-washing*))
           (null (wo-stage-log *wo-washing*)))))

;;; --- D. the branch the receiving bench cannot read -------------------
(format t "~%   D. THE INACCESSIBLE BRANCH. Both claims exist and both are verified.~%")
(format t "      The receiving bench was given only the material one:~%")
(multiple-value-bind (claim receipt)
    (authorize :controlled-humidification *material-humid* *authority-humid*
               :receiver (at-the-bench *material-humid*))
  (record-receipt receipt)
  (say-the-verdict receipt)
  (let ((entry (roster-entry-for receipt :treatment-institutionally-authorized
                                 *authority-humid*))
        (repair (repair-for receipt :treatment-institutionally-authorized))
        (wo (open-work-order "WO-1104" :controlled-humidification receipt)))
    (ok "[V-d1] the unreadable branch is :INACCESSIBLE — emphatically NOT :MISSING"
        (and (null claim)
             (eq :inaccessible (disposition-of receipt :treatment-institutionally-authorized)))
        "the bench is not told to go find an authorization; it is told it may not read the one it has")
    (ok "[V-d2] the roster says exactly which claim and exactly why"
        (and entry (eq :inaccessible-to-receiver (getf entry :outcome))))
    (ok "[V-d3] :INACCESSIBLE and :MISSING are different sentences, and the same schema produced both in this movement"
        (and (eq :inaccessible (disposition-of receipt :treatment-institutionally-authorized))
             (eq :missing (disposition-of *authorized-humid-receipt*
                                          :treatment-institutionally-authorized))
             t)
        "compared against arm 4c(i)'s receipt, which is :MISSING for the identical premise of the identical schema")
    (format t "     the repair, verbatim and complete:~%       ~A~%" (fmt repair))
    (ok "[V-d4] the repair names the claim by DURABLE IDENTITY, so the fix is mechanical and not a guess"
        (equal (mapcar #'lisp-plus-kernel0:identity-key
                       (getf repair :grant-receiver-access-to-judged-claims))
               (list (lisp-plus-kernel0:identity-key
                      (lisp-plus-slice0:claim-id *authority-humid*)))))
    (ok "[V-d5] and an unreadable branch routes to RECONCILIATION, not to a pending assessment"
        (eq :reconciliation-required (wo-state wo))
        "a gap sends you back to the laboratory; a locked door sends you to the registrar")))

;;; The [IV-e] receipt was the :MISSING comparison used by [V-d3]; it is the same
;;; premise of the same schema, refused for a different reason. Re-derived here so
;;; the comparison above reads against a receipt this program still holds.
(defparameter *missing-authority-receipt*
  (multiple-value-bind (claim receipt)
      (authorize :controlled-humidification *material-humid* nil)
    (declare (ignore claim))
    (record-receipt receipt)))
(ok "[V-d6] the two refusals of ONE premise, side by side: :MISSING when no branch was derived, :INACCESSIBLE when one was and could not be read"
    (and (eq :missing (disposition-of *missing-authority-receipt*
                                      :treatment-institutionally-authorized))
         (null (lisp-plus-slice1:premise-assessment-matching-inaccessible-supports
                (assessment-for *missing-authority-receipt*
                                :treatment-institutionally-authorized)))))


;;;; ==================================================================
;;;; MOVEMENT VI — THE TREATMENT
;;;;
;;;; Two governed acts on one object, both irreversible.
;;;;
;;;; Stage 1 — CONTROLLED HUMIDIFICATION. The codex goes into a chamber at rising
;;;; relative humidity until the parchment's fibres relax. It commits, and the
;;;; chamber's own ledger answers.
;;;;
;;;; Stage 2 — FLATTENING UNDER GRADED PRESSURE. The relaxed sheets go between
;;;; blotters under weight. The crossing is interrupted, and the press's ledger
;;;; WITHHOLDS its answer.
;;;;
;;;; WHY REPEATING STAGE 2 BLINDLY COULD DESTROY THE MANUSCRIPT, stated here in
;;;; the program because a comment is where a conservator would write it and
;;;; because the language enforces the refusal one paragraph below:
;;;;
;;;;   A humidified parchment sheet is temporarily plastic. Pressure applied to it
;;;;   sets a plane, and the plane it sets is the one it is held in while it dries.
;;;;   A sheet that has already been pressed once and dried has SET. Pressing it a
;;;;   second time does not average the two attempts and does not undo the first:
;;;;   it works dry, brittle, already-planar collagen against a new geometry, and
;;;;   what gives way is the ink layer at the fold apices and the weakest fibres
;;;;   along the six existing tears. The first press is a treatment. The second
;;;;   press, applied because nobody could confirm the first, is damage inflicted
;;;;   by bookkeeping.
;;;;
;;;;   And the workshop cannot tell from the outside which case it is in. That is
;;;;   precisely the situation an indeterminate outcome describes, and precisely
;;;;   why the honest move is to reassess the object rather than to repeat the act.
;;;; ==================================================================

(format t "~%-- MOVEMENT VI: the treatment (two irreversible acts, one object) --~%")

(defun chamber-key (&rest predicates)
  (lisp-plus-core0:mint-capability
   :ruling (lisp-plus-core0:fixture-sealed-ruling
            :adapter-name :fake-courier :predicates predicates)))

(defun treatment-request (method stage)
  `(:predicate ,method
    (:payload ,(format nil "~A / ~A / stage ~D" *umbra* method stage))))

(defun describe-account (evidence outcome)
  "Print the WHOLE structured account. Not the three-way view, not a boolean: the
four axes with their determinacy, the manifestation, the event count, the
identities, and the ledger token if the workshop was told one.

`outcome-kind` appears here as ONE LINE among many, which is what it is: a view
the program reads when it must branch, never the account it stores."
  (format t "     the treatment account, whole:~%")
  (format t "       view (outcome-kind)   ~A~%" (fmt (lisp-plus-core0:outcome-kind outcome)))
  (dolist (name '(:execution :manifestation :effects :interpretation))
    (let ((ax (lisp-plus-kernel0:outcome-axis outcome name)))
      (format t "       axis ~-13A ~-16A determinacy ~A~%"
              (string-downcase (symbol-name name))
              (if (eq name :manifestation)
                  ;; the manifestation axis's value IS a manifestation record;
                  ;; its STATUS is the scalar, and printing the record itself
                  ;; through the printer is exactly the margin hazard the header
                  ;; note is about
                  (fmt (lisp-plus-kernel0:manifestation-status
                        (lisp-plus-kernel0:axis-value ax)))
                  (fmt (lisp-plus-kernel0:axis-value ax)))
              (fmt (lisp-plus-kernel0:determinacy-mode
                    (lisp-plus-kernel0:axis-determinacy ax))))))
  (let ((m (lisp-plus-core0:core0-evidence-manifestation evidence)))
    (format t "       manifestation         status ~A  kind ~A  boundary ~A~%"
            (fmt (lisp-plus-kernel0:manifestation-status m))
            (fmt (lisp-plus-kernel0:manifestation-kind m))
            (fmt (lisp-plus-kernel0:manifestation-source-boundary m))))
  (format t "       attempt               ~A~%"
          (lisp-plus-kernel0:identity-key (lisp-plus-core0:core0-evidence-attempt-id evidence)))
  (format t "       seat                  ~A~%"
          (lisp-plus-kernel0:identity-key (lisp-plus-core0:core0-evidence-seat-id evidence)))
  (format t "       adapter               ~A~%"
          (lisp-plus-kernel0:identity-key
           (lisp-plus-core0:core0-evidence-adapter-identity evidence)))
  (format t "       process label         ~A~%"
          (lisp-plus-core0:process-context-label
           (lisp-plus-core0:core0-evidence-process evidence)))
  (format t "       recorded events       ~D~%"
          (length (lisp-plus-core0:core0-evidence-events evidence)))
  (format t "       ledger token told     ~A~%"
          (or (lisp-plus-core0:core0-evidence-ledger-token evidence) "NONE"))
  (format t "       refusal reason        ~A~%"
          (fmt (lisp-plus-core0:core0-evidence-refusal-reason evidence))))

;;; --- 6a. stage 1 commits ---------------------------------------------
(format t "~%   6a. stage 1 — controlled humidification, 18 chamber hours:~%")
(defparameter *wo-humid* (open-work-order "WO-1101" :controlled-humidification
                                          *authorized-humid-receipt*))
(defparameter *humid-account* nil)
(defparameter *humid-world* nil)
(ok "[VI-a] the work order was authorized BEFORE anything crossed, and the state came from the authorization receipt"
    (and (eq :treatment-authorized (wo-state *wo-humid*))
         (eq :granted (lisp-plus-slice1:derivation-receipt-decision
                       *authorized-humid-receipt*))))

(multiple-value-bind (adapter world)
    (lisp-plus-fake-courier:make-fake-courier :script :clean-commit)
  (setf *humid-world* world)
  (setf (wo-state *wo-humid*) :treatment-in-progress)
  (multiple-value-bind (outcome evidence)
      (lisp-plus-core0:perform
       :adapter adapter :request (treatment-request :controlled-humidification 1)
       :authority (chamber-key :controlled-humidification)
       :process (lisp-plus-core0:process-context
                 :label "umbra-workshop/humidification/stage-1"))
    (describe-account evidence outcome)
    ;; THE BRANCH. The workshop's next act is chosen by the view, and the ACCOUNT
    ;; is what it stores.
    (ecase (lisp-plus-core0:outcome-kind outcome)
      (:committed
       (setf (wo-account *wo-humid*) evidence)
       (push (list :stage 1 :method :controlled-humidification
                   :ledger-token (lisp-plus-core0:core0-evidence-ledger-token evidence)
                   :chamber-hours 18)
             (wo-stage-log *wo-humid*))
       (bench "stage 1 recorded in the treatment file; the workshop's own log entry")
       (bench "and the chamber's ledger row are TWO records that agree on one token."))
      ;; Both other views are unreachable from a RETURN, and not because of this
      ;; fixture: `perform` has exactly one value-returning exit, and every
      ;; refusal and interruption arrives as a condition carrying the outcome.
      (:refused (bench "unreachable by return: refusals arrive as conditions."))
      (:indeterminate (bench "unreachable by return: interruptions do too.")))
    (ok "[VI-b] the act returns a STRUCTURED ACCOUNT; the work order stores the account and not a verdict"
        (and (lisp-plus-core0:core0-evidence-p (wo-account *wo-humid*))
             (eq :committed (lisp-plus-core0:outcome-kind outcome))))
    (ok "[VI-c] THE DEED and THE TESTIMONY are distinct records agreeing on one token, and are not the same object"
        (let* ((row (first (lisp-plus-fake-courier:fake-courier-ledger-rows *humid-world*)))
               (deed-token (second row))
               (told-token (lisp-plus-core0:core0-evidence-ledger-token evidence))
               (log-token (getf (first (wo-stage-log *wo-humid*)) :ledger-token)))
          (and (= 1 (lisp-plus-fake-courier:fake-courier-ledger-row-count *humid-world*))
               (string= deed-token told-token) (string= told-token log-token)
               (not (eq row (wo-stage-log *wo-humid*)))))
        "the row in the chamber's private world is the effect; the workshop's log line is its account of the effect")))

;;; --- 6b. stage 2 is interrupted and its ledger withholds -------------
(format t "~%   6b. stage 2 — flattening under graded pressure. The crossing is~%")
(format t "       interrupted, and the press's ledger WITHHOLDS its answer:~%")
(defparameter *wo-flatten* (open-work-order "WO-1102" :pressure-flattening
                                            *authorized-flatten-receipt*))
(defparameter *flatten-account* nil)
(defparameter *flatten-world* nil)
(multiple-value-bind (adapter world)
    (lisp-plus-fake-courier:make-fake-courier :script :kill-after-commit-withhold)
  (setf *flatten-world* world)
  (setf (wo-state *wo-flatten*) :treatment-in-progress)
  (handler-case
      (lisp-plus-core0:perform
       :adapter adapter :request (treatment-request :pressure-flattening 2)
       :authority (chamber-key :pressure-flattening)
       :process (lisp-plus-core0:process-context
                 :label "umbra-workshop/flattening/stage-2"))
    (lisp-plus-core0:core0-interrupted (c)
      (let ((outcome (lisp-plus-core0:core0-condition-outcome c))
            (evidence (lisp-plus-core0:core0-condition-evidence c)))
        (setf *flatten-account* evidence)
        (setf (wo-account *wo-flatten*) evidence)
        (describe-account evidence outcome)
        (ok "[VI-d] the interrupted act's view is :INDETERMINATE, and the FULL account is retained anyway"
            (and (eq :indeterminate (lisp-plus-core0:outcome-kind outcome))
                 (lisp-plus-core0:core0-evidence-p (wo-account *wo-flatten*))))
        (ok "[VI-e] the workshop was told NO token, and the press's ledger DOES hold a row"
            (and (null (lisp-plus-core0:core0-evidence-ledger-token evidence))
                 (= 1 (lisp-plus-fake-courier:fake-courier-ledger-row-count world)))
            "absence of testimony is not testimony of absence — the sheets may already be pressed")))))

(format t "~%       the workshop's worst instinct, refused by live code:~%")
(let* ((events (lisp-plus-core0:core0-evidence-events *flatten-account*))
       (seat (lisp-plus-core0:core0-evidence-seat-id *flatten-account*))
       (second-press (lisp-plus-kernel0:make-kernel0-event
                      :event-type :attempt-begun :seat-id seat
                      :attempt-id (lisp-plus-kernel0:make-identity
                                   :attempt "umbra-workshop/press-it-again")
                      :payload nil)))
  (handler-case
      (progn (lisp-plus-kernel0:check-retry-safety (append events (list second-press)) seat)
             (ok "[VI-f] a blind second press is refused" nil "nothing fired"))
    (lisp-plus-kernel0:unsafe-retry (rc)
      (bench "*** UNSAFE-RETRY — the press stays open. The sheets are not pressed twice.")
      (ok "[VI-f] the blind repetition of an irreversible act is refused by LIVE code, not by the workshop's good intentions"
          (typep rc 'lisp-plus-kernel0:unsafe-retry)
          "the reason it must be refused is written out in this movement's banner, in the program"))))

(format t "~%       the honest move: continue from the surviving account, never repeat the act:~%")
(defparameter *flatten-case* nil)
(let* ((rows-before (lisp-plus-fake-courier:fake-courier-ledger-row-count *flatten-world*))
       (result (lisp-plus-core0:continue-from *flatten-account*
                                             :authority (chamber-key :pressure-flattening)))
       (disposition (lisp-plus-core0:continuation-result-disposition result))
       (required (lisp-plus-core0:continuation-result-required-action result))
       (rows-after (lisp-plus-fake-courier:fake-courier-ledger-row-count *flatten-world*)))
  (format t "     disposition      ~A~%" (fmt disposition))
  (format t "     known            ~A~%" (fmt (getf required :known)))
  (format t "     unknown          ~A~%" (fmt (getf required :unknown)))
  (format t "     required-action  ~A~%" (fmt (getf required :required-action)))
  ;; THE SECOND BRANCH. A different disposition builds a different workshop.
  (ecase disposition
    (:reconciled (bench "unreachable in this arm."))
    (:indeterminate
     (setf *flatten-case*
           (make-reassessment-case :id "RC-1" :manuscript *umbra*
                                   :reason :treatment-indeterminate
                                   :known (getf required :known)
                                   :unknown (getf required :unknown)
                                   :required-action (getf required :required-action)))
     (push *flatten-case* *cases*)
     (setf (wo-state *wo-flatten*) :treatment-indeterminate
           (wo-case-id *wo-flatten*) "RC-1")
     (bench "work order WO-1102 set :TREATMENT-INDETERMINATE; reassessment case RC-1")
     (bench "opened. The sheets are examined under raking light before anything else")
     (bench "touches them. No completion date. No second press. No clearance.")))
  (ok "[VI-g] a withholding ledger yields :INDETERMINATE, never a fabricated settlement"
      (eq :indeterminate disposition))
  (ok "[VI-h] the continuation did NOT re-invoke the press — the row count is unchanged across it"
      (and (= 1 rows-before) (= 1 rows-after)))
  (ok "[VI-i] the case's text is the continuation's OWN plist, not the workshop's prose"
      (and (equal (rc-known *flatten-case*) (getf required :known))
           (equal (rc-unknown *flatten-case*) (getf required :unknown))
           (equal (rc-required-action *flatten-case*) (getf required :required-action))))
  (ok "[VI-j] and no phantom completion was written: the work order has no completion date and its real state is preserved"
      (and (null (wo-completed-on *wo-flatten*))
           (eq :treatment-indeterminate (wo-state *wo-flatten*))
           (not (eq :treated-unassessed (wo-state *wo-flatten*))))))

(format t "~%   the two work orders on the object, structurally different records:~%")
(dolist (wo (list *wo-humid* *wo-flatten*))
  (format t "     ~9A ~26A ~24A stages-logged ~D  completed ~A  case ~A~%"
          (wo-id wo) (wo-method wo) (wo-state wo) (length (wo-stage-log wo))
          (or (wo-completed-on wo) "-") (or (wo-case-id wo) "-")))
(ok "[VI-k] one act is accounted for and one is not, and the difference is in the RECORDS rather than in the printout"
    (and (lisp-plus-core0:core0-evidence-ledger-token (wo-account *wo-humid*))
         (null (lisp-plus-core0:core0-evidence-ledger-token (wo-account *wo-flatten*)))
         (= 1 (length (wo-stage-log *wo-humid*)))
         (= 0 (length (wo-stage-log *wo-flatten*)))
         (null (wo-completed-on *wo-humid*))
         (null (wo-completed-on *wo-flatten*)))
    "and NEITHER has a completion date, because a completion date is post-treatment standing and Movement VII is about why there is none")


;;;; ==================================================================
;;;; MOVEMENT VII — THE EFFECT FRONTIER
;;;;
;;;; This is the movement the application was built for.
;;;;
;;;; Stage 1 HAPPENED. The chamber committed, its ledger answered, the workshop
;;;; holds the full structured Core /0 account of it, and every field in that
;;;; account is true. The next judgment the workshop needs is
;;;; :POST-TREATMENT-CONDITION-ESTABLISHED, whose first premise is
;;;;
;;;;    (:predicate :treatment-completed (:manuscript "codex:umbra-17")
;;;;                                     (:method :controlled-humidification))
;;;;
;;;; So: offer the account. Not a witness about the account. Not a claim
;;;; restating it. The account itself, through :SUPPORTS, which is the door the
;;;; language provides for evidence.
;;;;
;;;; Six species are tried below. The first three are the production path and are
;;;; run first. The last three are OFF THE PRODUCTION PATH, labelled as probes,
;;;; and nothing the workshop decides is read out of them.
;;;; ==================================================================

(format t "~%-- MOVEMENT VII: the effect frontier (a true account, offered as evidence) --~%")

(defparameter *completed*
  (np `(:predicate :treatment-completed (:manuscript ,*umbra*)
        (:method :controlled-humidification)))
  "The proposition the post-treatment schema's first premise wants. Not a standing
the workshop can derive and not a policy it can consult: a fact about what
happened to a physical object between day 4183 and day 4187.")

(defparameter *reassessment-witness*
  (attest `(:predicate :condition-reassessed (:manuscript ,*umbra*)
            (:assay "ASY-4433"))
          :kind :survey :source :workshop)
  "The lawful half. The conservator DID reassess the object after stage 1 —
raking light, a fresh distortion measurement, a re-run solubility spot test — and
this witness is an honest first-hand observation of the workshop's own act.")

(defun consider-post-treatment (&rest extra)
  "Always offer the lawful half; vary the other half. EXTRA lands at index 1 and
after, which is what the residue indices below are counted against."
  (let ((sup (remove nil (cons *reassessment-witness* extra))))
    (consider :schema :post-treatment-standing
              :conclusion (np `(:predicate :post-treatment-condition-established
                                (:manuscript ,*umbra*)
                                (:method :controlled-humidification)))
              :supports sup :receiver (apply #'at-the-bench sup))))

;;; --- 7a. species 1: nothing offered for the effect premise -----------
(format t "~%   7a. species 1 — nothing offered for :TREATMENT-COMPLETED:~%")
(defparameter *lawful-post-receipt* nil
  "The ONLY post-treatment receipt whose grant could have rested on a governed
judgment. Arm 7f reads this one and no other to decide what happens to the
object; every probe below either grants on something the workshop asserted or
does not grant at all.")
(multiple-value-bind (claim receipt) (consider-post-treatment)
  (setf *lawful-post-receipt* (record-receipt receipt))
  (say-the-verdict receipt)
  (ok "[VII-a] the effect premise is :MISSING while the reassessment premise is :SATISFIED"
      (and (null claim)
           (eq :missing (disposition-of receipt :treatment-completed))
           (eq :satisfied (disposition-of receipt :condition-reassessed))))
  (ok "[VII-b] and the receipt records NO unsupported residue, because nothing unrecognized was supplied"
      (null (residue-of receipt))))

;;; --- 7b. species 2: the actual Core /0 account, handed straight over --
(format t "~%   7b. species 2 — THE ACTUAL ACCOUNT. The workshop hands `derive` the~%")
(format t "       Core /0 evidence object from stage 1: real attempt, real ledger~%")
(format t "       token, real event sequence. Not wrapped, not restated.~%")
(format t "       attempt ~A, ledger token ~A, ~D recorded events~%"
        (lisp-plus-kernel0:identity-key
         (lisp-plus-core0:core0-evidence-attempt-id (wo-account *wo-humid*)))
        (lisp-plus-core0:core0-evidence-ledger-token (wo-account *wo-humid*))
        (length (lisp-plus-core0:core0-evidence-events (wo-account *wo-humid*))))
(defparameter *account-post-receipt* nil)
(multiple-value-bind (claim receipt) (consider-post-treatment (wo-account *wo-humid*))
  (setf *account-post-receipt* (record-receipt receipt))
  (say-the-verdict receipt)
  (let ((residue (residue-of receipt))
        (a (assessment-for receipt :treatment-completed))
        (b (assessment-for *lawful-post-receipt* :treatment-completed)))
    (bench "the effect premise says ~A; the receipt records an unsupported value ~
at :supports[~{~D~^, ~}]."
           (fmt (disposition-of receipt :treatment-completed))
           (mapcar (lambda (u) (getf u :index)) residue))
    (ok "[VII-c] the account is NOT admitted: the premise is still :MISSING and the standing is still refused"
        (and (null claim)
             (eq :missing (disposition-of receipt :treatment-completed))
             (null (lisp-plus-slice1:premise-assessment-matching-accessible-supports a))
             (null (lisp-plus-slice1:premise-assessment-matching-inaccessible-supports a))
             (null (lisp-plus-slice1:premise-assessment-mismatched-candidates a))
             (null (lisp-plus-slice1:premise-assessment-refuting-supports a))
             (equal (lisp-plus-slice1:premise-assessment-judged-claims a)
                    (lisp-plus-slice1:premise-assessment-judged-claims b)))
        "an account is not a witness, not a refutation and not a claim; CHARTER-DELTA-3 records it at the receipt and records nothing more")
    (ok "[VII-d] but supplying it is no longer indistinguishable from supplying nothing: the receipt names the exact input position"
        (and (equal residue '((:index 1 :reason :unsupported-support-species)))
             (null (residue-of *lawful-post-receipt*)))
        "index 1 is where the workshop put it: the reassessment witness is index 0")
    (ok "[VII-e] and the residue changed NO decision: every decision-bearing field agrees with species 1"
        (and (eq (lisp-plus-slice1:derivation-receipt-decision receipt)
                 (lisp-plus-slice1:derivation-receipt-decision *lawful-post-receipt*))
             (eq (disposition-of receipt :treatment-completed)
                 (disposition-of *lawful-post-receipt* :treatment-completed))
             (eq (disposition-of receipt :condition-reassessed)
                 (disposition-of *lawful-post-receipt* :condition-reassessed))))
    (bench "the account is now VISIBLE as supplied-but-unsupported. Visibility is")
    (bench "not admissibility. The frontier has not moved.")))

;;; --- 7c. the third residue row, and the one the delta forbids --------
(format t "~%   7c. the residue table Delta /3 specifies, all three rows, live:~%")
(defparameter *residue-rows* '())
(multiple-value-bind (claim receipt) (consider-post-treatment)
  (declare (ignore claim))
  (push (list "recognized support alone"
              (lisp-plus-slice1:derivation-receipt-decision receipt)
              (disposition-of receipt :condition-reassessed)
              (residue-of receipt))
        *residue-rows*))
(multiple-value-bind (claim receipt) (consider-post-treatment (wo-account *wo-humid*))
  (declare (ignore claim))
  (push (list "recognized + unsupported"
              (lisp-plus-slice1:derivation-receipt-decision receipt)
              (disposition-of receipt :condition-reassessed)
              (residue-of receipt))
        *residue-rows*))
(defparameter *unsupported-alone-receipt* nil)
(multiple-value-bind (claim receipt)
    (let ((sup (list (wo-account *wo-humid*))))
      (consider :schema :post-treatment-standing
                :conclusion (np `(:predicate :post-treatment-condition-established
                                  (:manuscript ,*umbra*)
                                  (:method :controlled-humidification)))
                :supports sup :receiver (apply #'at-the-bench sup)))
  (declare (ignore claim))
  (setf *unsupported-alone-receipt* (record-receipt receipt))
  (push (list "unsupported alone"
              (lisp-plus-slice1:derivation-receipt-decision receipt)
              (disposition-of receipt :condition-reassessed)
              (residue-of receipt))
        *residue-rows*))
(setf *residue-rows* (reverse *residue-rows*))
(dolist (row *residue-rows*)
  (format t "     ~26A decision ~9A reassessed ~11A residue ~A~%"
          (first row) (fmt (second row)) (fmt (third row)) (fmt (fourth row))))
(ok "[VII-f] all three Delta /3 rows behave exactly as specified — same decision with and without residue, and unsupported-alone differs observably from nothing"
    (and (null (fourth (first *residue-rows*)))
         (equal '((:index 1 :reason :unsupported-support-species)) (fourth (second *residue-rows*)))
         (equal '((:index 0 :reason :unsupported-support-species)) (fourth (third *residue-rows*)))
         (eq (second (first *residue-rows*)) (second (second *residue-rows*)))
         (eq (third (first *residue-rows*)) (third (second *residue-rows*)))
         (eq :missing (third (third *residue-rows*)))))
(ok "[VII-g] and the residue is INERT DATA, not the object: the entries carry only an index and a reason, and the workshop cannot read the account back out of a receipt"
    (every (lambda (e) (and (= 4 (length e)) (integerp (getf e :index))
                            (eq :unsupported-support-species (getf e :reason))))
           (residue-of *account-post-receipt*))
    "the raw object is not retained — not the object, not its type, not its printed form")

;;; --- 7d. THE PROBES. Off the production path, and labelled as such ---
(format t "~%   7d. THE PROBES — OFF THE PRODUCTION PATH. Species 3 to 6 are run to~%")
(format t "       find out what the current surface does, and NOTHING the workshop~%")
(format t "       decides below is read out of any of them.~%")

(defparameter *probe-receipts* '())
(defun probe (label &rest extra)
  (multiple-value-bind (claim receipt) (apply #'consider-post-treatment extra)
    (record-receipt receipt)
    (push (cons label receipt) *probe-receipts*)
    (let ((a (assessment-for receipt :treatment-completed)))
      (format t "     ~34A decision ~9A premise ~11A witnesses ~D roster ~D~%"
              label
              (fmt (lisp-plus-slice1:derivation-receipt-decision receipt))
              (fmt (disposition-of receipt :treatment-completed))
              (length (lisp-plus-slice1:premise-assessment-matching-accessible-supports a))
              (length (lisp-plus-slice1:premise-assessment-judged-claims a))))
    (values claim receipt)))

;;; species 3 — a direct witness carrying the REAL attempt identity and token
(defparameter *true-witness*
  (lisp-plus-slice0:witness
   :for *completed* :mode :direct :kind :chamber-ledger :source :humidity-chamber
   :procedure (lisp-plus-core0:core0-evidence-attempt-id (wo-account *wo-humid*))
   :content (list :ledger-token
                  (lisp-plus-core0:core0-evidence-ledger-token (wo-account *wo-humid*)))))

;;; species 4 — a FABRICATED direct witness. No such treatment happened.
(defparameter *fabricated-witness*
  (lisp-plus-slice0:witness
   :for *completed* :mode :direct :kind :chamber-ledger :source :humidity-chamber
   :procedure (lisp-plus-kernel0:make-identity
               :attempt "umbra-workshop/a-chamber-cycle-that-never-ran")
   :content (list :ledger-token "fake:courier:9999"))
  "Nothing produced this. There is no such attempt, no such row, and no such
treatment. It names a method that was never applied to this object.")

;;; species 5 — a BARE direct witness: no procedure, no content at all
(defparameter *bare-witness*
  (lisp-plus-slice0:witness
   :for *completed* :mode :direct :kind :chamber-ledger :source :nobody))

;;; species 6 — the real witness RAISED into a judged claim, then chained
(defparameter *ledger-reading*
  (lisp-plus-slice0:promotion-procedure
   :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                :procedure-id (lisp-plus-kernel0:make-identity
                               :procedure "umbra-workshop/read-the-chamber-ledger")
                :version 1 :judgment-class :semantic
                :result-vocabulary '(:verified :refuted))
   :admits '((:direct :chamber-ledger)))
  "A promotion procedure admitting exactly one shape of support: a direct
chamber-ledger reading. Admissibility is a mode-and-kind membership test and
nothing else — which is why species 4 and 5 arrive at the same door.")

(defparameter *raised-claim*
  (lisp-plus-slice0:raise
   (lisp-plus-slice0:claim :proposition *completed* :by :umbra-workshop)
   :to :verified :per *ledger-reading* :considering (list *true-witness*)
   :receiver :umbra-workshop))

(format t "~%")
(defparameter *true-probe-receipt* nil)
(defparameter *fabricated-probe-receipt* nil)
(defparameter *bare-probe-receipt* nil)
(defparameter *raised-probe-receipt* nil)
(multiple-value-bind (c r) (probe "species 3: real account carried" *true-witness*)
  (declare (ignore c)) (setf *true-probe-receipt* r))
(multiple-value-bind (c r) (probe "species 4: FABRICATED witness" *fabricated-witness*)
  (declare (ignore c)) (setf *fabricated-probe-receipt* r))
(multiple-value-bind (c r) (probe "species 5: BARE witness, nothing" *bare-witness*)
  (declare (ignore c)) (setf *bare-probe-receipt* r))
(multiple-value-bind (c r) (probe "species 6: real witness RAISED" *raised-claim*)
  (declare (ignore c)) (setf *raised-probe-receipt* r))

(ok "[VII-h] species 3 — a direct witness carrying the real attempt identity and the real token DISCHARGES the effect premise"
    (and (eq :granted (lisp-plus-slice1:derivation-receipt-decision *true-probe-receipt*))
         (eq :satisfied (disposition-of *true-probe-receipt* :treatment-completed))))
(ok "[VII-i] species 4 — the FABRICATED witness discharges IDENTICALLY. Stated plainly, because it is the finding: a witness naming a treatment that never happened grants exactly as well as one naming a treatment that did"
    (and (eq :granted (lisp-plus-slice1:derivation-receipt-decision *fabricated-probe-receipt*))
         (eq :satisfied (disposition-of *fabricated-probe-receipt* :treatment-completed))))
(ok "[VII-j] species 5 — the BARE witness, carrying no procedure and no content whatsoever, also discharges identically"
    (and (eq :granted (lisp-plus-slice1:derivation-receipt-decision *bare-probe-receipt*))
         (eq :satisfied (disposition-of *bare-probe-receipt* :treatment-completed))
         (null (lisp-plus-slice0:witness-procedure *bare-witness*))
         (null (lisp-plus-slice0:witness-content *bare-witness*)))
    "promotion admissibility is a mode-and-kind membership test; it never reads :PROCEDURE or :CONTENT")
(ok "[VII-k] species 6 — RAISE turns the real witness into a genuinely :VERIFIED claim that then chains lawfully"
    (and (eq :verified (lisp-plus-slice0:judgment-record-judgment
                        (lisp-plus-slice0:claim-judgment *raised-claim*)))
         (let ((e (roster-entry-for *raised-probe-receipt* :treatment-completed *raised-claim*)))
           (and e (eq :discharged (getf e :outcome)) (eq :verified (getf e :judgment))))))

;;; --- 7e. the field-by-field comparison ------------------------------
(format t "~%   7e. species 3 against species 4, read through every public reader of~%")
(format t "       the premise assessment — because indistinguishability that is not~%")
(format t "       computed is only a mood:~%")
(defparameter *assessment-readers*
  (list (cons :disposition #'lisp-plus-slice1:premise-assessment-disposition)
        (cons :premise-pattern #'lisp-plus-slice1:premise-assessment-premise-pattern)
        (cons :ground-instances #'lisp-plus-slice1:premise-assessment-ground-instances)
        (cons :judged-claims #'lisp-plus-slice1:premise-assessment-judged-claims)
        (cons :matching-inaccessible #'lisp-plus-slice1:premise-assessment-matching-inaccessible-supports)
        (cons :mismatched-candidates #'lisp-plus-slice1:premise-assessment-mismatched-candidates)
        (cons :refuting-supports #'lisp-plus-slice1:premise-assessment-refuting-supports)
        (cons :binding-environments #'lisp-plus-slice1:premise-assessment-binding-environments)
        (cons :ambiguities #'lisp-plus-slice1:premise-assessment-ambiguities))
  "Every public reader of a premise assessment EXCEPT MATCHING-ACCESSIBLE-SUPPORTS,
which holds the witness objects themselves and is compared separately below.")

(let* ((true-a (assessment-for *true-probe-receipt* :treatment-completed))
       (fake-a (assessment-for *fabricated-probe-receipt* :treatment-completed))
       (bare-a (assessment-for *bare-probe-receipt* :treatment-completed))
       (differing (remove-if (lambda (p) (and (equal (funcall (cdr p) true-a)
                                                     (funcall (cdr p) fake-a))
                                              (equal (funcall (cdr p) true-a)
                                                     (funcall (cdr p) bare-a))))
                             *assessment-readers*)))
  (dolist (p *assessment-readers*)
    (format t "     ~24A ~A~%" (fmt (car p))
            (if (member p differing) "DIFFERS" "identical across all three")))
  (ok "[VII-l] every public reader of the effect premise is identical across species 3, 4 and 5, save the one holding the witness objects"
      (null differing))
  (let ((tw (first (lisp-plus-slice1:premise-assessment-matching-accessible-supports true-a)))
        (fw (first (lisp-plus-slice1:premise-assessment-matching-accessible-supports fake-a)))
        (bw (first (lisp-plus-slice1:premise-assessment-matching-accessible-supports bare-a))))
    (format t "     matching-accessible      one witness each; the governed attributes:~%")
    (format t "       mode / kind / polarity   ~A~%"
            (fmt (list (lisp-plus-slice0:witness-mode tw)
                       (lisp-plus-slice0:witness-kind tw)
                       (lisp-plus-slice0:witness-polarity tw))))
    (format t "       the SAME, on species 4   ~A~%"
            (fmt (list (lisp-plus-slice0:witness-mode fw)
                       (lisp-plus-slice0:witness-kind fw)
                       (lisp-plus-slice0:witness-polarity fw))))
    (format t "       the SAME, on species 5   ~A~%"
            (fmt (list (lisp-plus-slice0:witness-mode bw)
                       (lisp-plus-slice0:witness-kind bw)
                       (lisp-plus-slice0:witness-polarity bw))))
    (format t "       :procedure  3 / 4 / 5    ~A / ~A / ~A~%"
            (lisp-plus-kernel0:identity-key (lisp-plus-slice0:witness-procedure tw))
            (lisp-plus-kernel0:identity-key (lisp-plus-slice0:witness-procedure fw))
            (fmt (lisp-plus-slice0:witness-procedure bw)))
    (format t "       :content    3 / 4 / 5    ~A / ~A / ~A~%"
            (fmt (lisp-plus-slice0:witness-content tw))
            (fmt (lisp-plus-slice0:witness-content fw))
            (fmt (lisp-plus-slice0:witness-content bw)))
    (ok "[VII-m] the three witnesses agree in every attribute the language GOVERNS and differ only in the two it merely CARRIES"
        (and (equal (lisp-plus-slice0:witness-mode tw) (lisp-plus-slice0:witness-mode fw))
             (equal (lisp-plus-slice0:witness-kind tw) (lisp-plus-slice0:witness-kind fw))
             (equal (lisp-plus-slice0:witness-polarity tw) (lisp-plus-slice0:witness-polarity bw))
             (not (equal (lisp-plus-kernel0:identity-key (lisp-plus-slice0:witness-procedure tw))
                         (lisp-plus-kernel0:identity-key (lisp-plus-slice0:witness-procedure fw))))
             (null (lisp-plus-slice0:witness-procedure bw)))
        "a reader can see three different strings; nothing tells the reader which of them names a treatment that happened"))
  ;; and on the RAISED route the account does not survive the promotion at all
  (let* ((a (assessment-for *raised-probe-receipt* :treatment-completed))
         (jr (lisp-plus-slice0:claim-judgment *raised-claim*)))
    (labels ((ids-in (x) (cond ((lisp-plus-kernel0:durable-identity-p x) (list x))
                               ((consp x) (append (ids-in (car x)) (ids-in (cdr x))))
                               (t nil))))
      (let ((reachable (append (ids-in (lisp-plus-slice1:premise-assessment-judged-claims a))
                               (ids-in (lisp-plus-slice1:premise-assessment-ground-instances a))
                               (ids-in (lisp-plus-slice1:premise-assessment-binding-environments a)))))
        (format t "     species 6: the judgment record keeps judgment ~A, procedure ~A v~D,~%"
                (fmt (lisp-plus-slice0:judgment-record-judgment jr))
                (lisp-plus-kernel0:identity-key
                 (lisp-plus-slice0:judgment-record-procedure-id jr))
                (lisp-plus-slice0:judgment-record-procedure-version jr))
        (format t "                and supports in domains ~A~%"
                (fmt (mapcar #'lisp-plus-kernel0:durable-identity-domain
                             (lisp-plus-slice0:judgment-record-support-ids jr))))
        (ok "[VII-n] on the RAISED route the crossing's identity is gone by the time the claim chains: no :ATTEMPT identity survives into the receiving receipt or the judgment record"
            (and (null (lisp-plus-slice1:premise-assessment-matching-accessible-supports a))
                 (notany (lambda (i) (eq :attempt (lisp-plus-kernel0:durable-identity-domain i)))
                         reachable)
                 (notany (lambda (i) (eq :attempt (lisp-plus-kernel0:durable-identity-domain i)))
                         (lisp-plus-slice0:judgment-record-support-ids jr)))
            "what survives a promotion is the WITNESS's id, never what the witness was carrying")))))

;;; --- 7f. so what does the workshop DO about the object? --------------
;;;
;;; A finding a program only PRINTS is a finding the program does not believe.
(format t "~%   7f. and so the object lands in an honest state, chosen by the receipt:~%")

(defparameter *umbra-standing* nil)
(let ((d (disposition-of *lawful-post-receipt* :treatment-completed)))
  (bench "the lawful post-treatment receipt says :TREATMENT-COMPLETED is ~A." (fmt d))
  ;; THE BRANCH. The disposition chooses the state; the workshop chooses nothing.
  (setf *umbra-standing*
        (ecase d
          (:satisfied     :post-treatment-established)
          (:refuted       :not-safe-to-exhibit)
          (:inaccessible  :reconciliation-required)
          (:mismatched    :reassessment-required)
          (:ambiguous     :reconciliation-required)
          (:missing       :treated-unassessed)))
  (setf (wo-state *wo-humid*) *umbra-standing*)
  (push (make-reassessment-case
         :id "RC-2" :manuscript *umbra* :reason :post-treatment-standing-unestablished
         :known (list :stage-1-performed t
                      :ledger-token (lisp-plus-core0:core0-evidence-ledger-token
                                     (wo-account *wo-humid*))
                      :reassessment-survey "ASY-4433")
         :unknown (list :treatment-completed :unestablished-as-a-judgment)
         :required-action :obtain-governed-completion-judgment)
        *cases*)
  (bench "-> WO-1101 set ~A; reassessment case RC-2 opened; the work order stays"
         (fmt *umbra-standing*))
  (bench "   OPEN and carries no completion date. The workshop holds a ledger token")
  (bench "   from a chamber cycle that really ran, and still cannot establish")
  (bench "   completion — because a token is a thing it was TOLD, and the premise")
  (bench "   asks for a thing that was JUDGED.")
  (ok "[VII-o] the object lands :TREATED-UNASSESSED, and the state came from the receipt's disposition rather than from a judgement of the workshop's"
      (and (eq :treated-unassessed *umbra-standing*)
           (eq *umbra-standing* (wo-state *wo-humid*))
           (eq :missing d)))
  (ok "[VII-p] no phantom completion: no completion date on either work order, and both remain open"
      (and (null (wo-completed-on *wo-humid*)) (null (wo-completed-on *wo-flatten*))
           (not (eq :post-treatment-established (wo-state *wo-humid*)))
           (find "RC-2" *cases* :key #'rc-id :test #'string=)))
  (ok "[VII-q] and the WORKSHOP DECLINED A DOOR IT HAD: species 3 GRANTED post-treatment standing, and the workshop did not take that grant"
      (and (eq :granted (lisp-plus-slice1:derivation-receipt-decision *true-probe-receipt*))
           (eq :treated-unassessed (wo-state *wo-humid*)))
      "that refusal is WORKSHOP POLICY — unenforced by the language and unreceipted anywhere"))

(format t "~%   -- the boundary, in four parts, because they are four different things --~%")
(bench "WHAT THE LANGUAGE REFUSES: the Core /0 account cannot discharge the")
(bench "  premise. It is recorded as unsupported residue at the receipt and has no")
(bench "  semantic effect ([VII-c], [VII-d]). No governed operation consumes it.")
(format t "~%")
(bench "WHAT THE WORKSHOP DECLINES AS POLICY: minting a :DIRECT witness for")
(bench "  :TREATMENT-COMPLETED. Species 3 shows that would GRANT ([VII-h]). The")
(bench "  workshop will not do it for a clearance, and nothing but this paragraph")
(bench "  and one ECASE stops it.")
(format t "~%")
(bench "WHAT THE RECEIPT PROVES: that the account was supplied, at which input")
(bench "  position, and that it changed no decision ([VII-e], [VII-g]). It proves")
(bench "  the workshop TRIED. It does not prove the treatment was completed.")
(format t "~%")
(bench "WHAT REMAINS UNENFORCED APPLICATION DISCIPLINE: the truthfulness of every")
(bench "  :DIRECT witness this program mints. Species 4 and 5 grant identically to")
(bench "  species 3, so the honesty of the mode reserved for first-hand")
(bench "  observation is carried by the conservator and by nothing else.")
(format t "~%")
(bench "The workshop stops here. It proposes no bridge and implements none.")


;;;; ==================================================================
;;;; MOVEMENT VIII — THE EXHIBITION
;;;;
;;;; Two branches downstream of the treatment, converging on one decision.
;;;;
;;;; The documentation branch needs no effect and grants cleanly: the treatment
;;;; was AUTHORIZED, the custody log is complete, so the file is in order. The
;;;; post-treatment branch cannot grant, for the reason Movement VII established.
;;;;
;;;; And the thing this movement exists to refuse: authorization is not clearance.
;;;; A treatment being permitted says nothing about whether the object survived
;;;; it. The exhibition schema does not name :TREATMENT-AUTHORIZED as a premise,
;;;; and arm 8c offers it anyway to show that the omission is enforced and not
;;;; merely intended.
;;;; ==================================================================

(format t "~%-- MOVEMENT VIII: the exhibition (two branches, one decision) --~%")

(defparameter *custody-log*
  (attest `(:predicate :custody-log-complete (:manuscript ,*umbra*)
            (:register "CUST-1101/1102"))
          :kind :register :source :registrar))

(format t "~%   8a. the documentation branch — it needs no effect, and it grants:~%")
(defparameter *documented* nil)
(defparameter *documented-receipt* nil)
(let ((sup (list *authorized-humid* *authorized-flatten* *custody-log*)))
  (multiple-value-bind (claim receipt)
      (consider :schema :documentation-standing
                :conclusion (np `(:predicate :treatment-documented (:manuscript ,*umbra*)))
                :supports sup :receiver (apply #'at-the-bench sup))
    (setf *documented* claim *documented-receipt* (record-receipt receipt))
    (say-the-verdict receipt)
    (let ((envs (lisp-plus-slice1:derivation-receipt-complete-binding-environments receipt)))
      (ok "[VIII-a] :TREATMENT-DOCUMENTED is granted from the authorization claims and the custody log"
          (and claim (eq :satisfied (disposition-of receipt :treatment-authorized))
               (eq :satisfied (disposition-of receipt :custody-log-complete))))
      (ok "[VIII-b] and BOTH authorizations discharged it: two authorized treatments under one custody log is two complete environments, and the language kept both"
          (and (= 2 (length envs))
               (lisp-plus-slice1:derivation-receipt-multiply-supported-p receipt)
               (= 2 (count :discharged (roster-for receipt :treatment-authorized)
                           :key (lambda (e) (getf e :outcome)))))
          (format nil "~D complete environment(s); no representative was selected"
                  (length envs))))))

(format t "~%   8b. the post-treatment branch — it cannot grant, for Movement VII's reason:~%")
(bench "the post-treatment receipt of arm 7a stands: :TREATMENT-COMPLETED is ~A."
       (fmt (disposition-of *lawful-post-receipt* :treatment-completed)))
(ok "[VIII-c] there is NO post-treatment condition claim anywhere in this program, because none was ever granted lawfully"
    (null (find-symbol "*POST-TREATMENT-CLAIM*"))
    "no variable holds one, and the exhibition derivation below therefore has nothing to offer for that premise")

(format t "~%   8c. THE EXHIBITION DECISION. The workshop offers everything it lawfully~%")
(format t "       holds — the documentation claim, and the authorization claims too:~%")
(defparameter *exhibition* nil)
(defparameter *exhibition-receipt* nil)
(let ((sup (list *documented* *authorized-humid* *authorized-flatten*)))
  (multiple-value-bind (claim receipt)
      (consider :schema :exhibition-standing
                :conclusion (np `(:predicate :safe-to-exhibit (:manuscript ,*umbra*)
                                  (:exhibition "EXH-4212/umbra")))
                :supports sup :receiver (apply #'at-the-bench sup))
    (setf *exhibition-receipt* (record-receipt receipt))
    (say-the-verdict receipt)
    (setf *exhibition*
          (make-exhibition-request
           :id "XR-7" :manuscript *umbra* :exhibition "EXH-4212/umbra"
           :decision (if (eq :granted (lisp-plus-slice1:derivation-receipt-decision receipt))
                         :safe-to-exhibit :not-safe-to-exhibit)
           :basis (verdict receipt)))
    (ok "[VIII-d] the exhibition is NOT cleared: the post-treatment premise is :MISSING while the documentation premise is :SATISFIED"
        (and (null claim)
             (eq :missing (disposition-of receipt :post-treatment-condition-established))
             (eq :satisfied (disposition-of receipt :treatment-documented))))
    (ok "[VIII-e] and AUTHORIZATION DOES NOT CLEAR AN OBJECT FOR DISPLAY: two verified authorization claims were on the table and neither discharged anything here"
        (let ((roster (roster-for receipt :post-treatment-condition-established)))
          (and (notany (lambda (e) (eq :discharged (getf e :outcome))) roster)
               (roster-entry-for receipt :post-treatment-condition-established
                                 *authorized-humid*)
               (eq :proposition-does-not-match
                   (getf (roster-entry-for receipt :post-treatment-condition-established
                                           *authorized-humid*)
                         :outcome))))
        "the language SAW both authorizations, considered them for that premise, and recorded :PROPOSITION-DOES-NOT-MATCH")
    (format t "     the exhibition request as it goes back to the curator:~%")
    (format t "       ~A  ~A  decision ~A~%" (xr-id *exhibition*) (xr-exhibition *exhibition*)
            (fmt (xr-decision *exhibition*)))
    (format t "       basis, verbatim from the receipt: ~A~%" (fmt (xr-basis *exhibition*)))
    (ok "[VIII-f] the decision is :NOT-SAFE-TO-EXHIBIT and its BASIS is the receipt's own strongest lawful result, copied and not paraphrased"
        (and (eq :not-safe-to-exhibit (xr-decision *exhibition*))
             (equal '(:blocked-on :post-treatment-condition-established :missing)
                    (xr-basis *exhibition*))))))

(format t "~%   the object's whole file at close of day ~D:~%" *today*)
(dolist (wo (reverse *work-orders*))
  (format t "     ~9A ~26A ~26A completed ~A  case ~A~%"
          (wo-id wo) (wo-method wo) (wo-state wo)
          (or (wo-completed-on wo) "-") (or (wo-case-id wo) "-")))
(dolist (c (reverse *cases*))
  (format t "     ~9A ~34A action ~A~%" (rc-id c) (rc-reason c)
          (fmt (rc-required-action c))))
(format t "     ~9A ~26A decision ~A~%" (xr-id *exhibition*)
        (xr-exhibition *exhibition*) (fmt (xr-decision *exhibition*)))
(ok "[VIII-g] nothing phantom is anywhere in the file: no completion date on any work order, no clearance, two open cases, and one refused exhibition request"
    (and (every (lambda (wo) (null (wo-completed-on wo))) *work-orders*)
         (eq :not-safe-to-exhibit (xr-decision *exhibition*))
         (= 2 (length *cases*))
         (= 4 (length *work-orders*))))
(ok "[VIII-h] and exactly TWO irreversible acts crossed the frontier in this whole session — never three"
    (= 2 (+ (lisp-plus-fake-courier:fake-courier-ledger-row-count *humid-world*)
            (lisp-plus-fake-courier:fake-courier-ledger-row-count *flatten-world*)))
    "one humidification chamber cycle and one press, each once")


;;;; ==================================================================
;;;; MOVEMENT IX — THE MEASURED CLOSE
;;;;
;;;; The branch graph rendered honestly, the grounding cardinalities counted
;;;; rather than asserted, and the two planted controls.
;;;; ==================================================================

(format t "~%-- MOVEMENT IX: the measured close --~%")

;;; --- 9a. the branch graph, rendered with its provenance stated -------
(defun render-the-reconvergence (receipt material-claim authority-claim)
  "Print the reconvergence as a graph, and be exact about what this function is.

  CONTENT IS GOVERNED. Both claim identities, both judgments and both judging
  procedures below are read out of RECEIPT through public readers, and the two
  bases are located by DURABLE IDENTITY rather than by position in the roster.

  TRAVERSAL ORDER IS THE APPLICATION'S. This function is handed the two branch
  claims by its caller. It does not discover them from the receipt, because there
  is NO public operation that resolves a durable claim identity back to the
  object it names, and this program does not build one.

  So this is a VERIFIED RENDERING OF A KNOWN-ORDER GRAPH and not a self-directed
  traversal. The difference is not cosmetic: it is why [IX-a] checks the governed
  records AGAINST the caller's two claims rather than trusting the caller. Hand it
  the wrong claim and [IX-a] fails.

  This docstring makes no claim that nothing was looked up. Two arguments were
  passed in, and the receipt was read; nothing else was consulted."
  (let ((mat (roster-entry-for receipt :treatment-materially-suitable material-claim))
        (aut (roster-entry-for receipt :treatment-institutionally-authorized authority-claim)))
    (format t "     MATERIAL BRANCH                     AUTHORITY BRANCH~%")
    (format t "       ~-32A  ~A~%"
            (lisp-plus-kernel0:identity-key (getf mat :claim-id))
            (lisp-plus-kernel0:identity-key (getf aut :claim-id)))
    (format t "       judged ~-25A judged ~A~%"
            (fmt (getf mat :judgment)) (fmt (getf aut :judgment)))
    (format t "       by ~-29A by ~A~%"
            (lisp-plus-kernel0:identity-key (getf mat :procedure-id))
            (lisp-plus-kernel0:identity-key (getf aut :procedure-id)))
    (format t "                     \\             /~%")
    (format t "                      RECONVERGENCE: ~A~%"
            (fmt (second (lisp-plus-slice1:derivation-receipt-conclusion receipt))))
    (format t "                      decision ~A~%"
            (fmt (lisp-plus-slice1:derivation-receipt-decision receipt)))
    (values mat aut)))

(format t "~%   9a. the reconvergence, rendered from the receipt:~%")
(multiple-value-bind (mat aut)
    (render-the-reconvergence *authorized-humid-receipt* *material-humid* *authority-humid*)
  (ok "[IX-a] the rendering is CHECKED against the receipt by identity: each printed basis IS the claim its branch granted, and the two judging procedures differ"
      (and (lisp-plus-kernel0:identity= (getf mat :claim-id)
                                        (lisp-plus-slice0:claim-id *material-humid*))
           (lisp-plus-kernel0:identity= (getf aut :claim-id)
                                        (lisp-plus-slice0:claim-id *authority-humid*))
           (not (lisp-plus-kernel0:identity= (getf mat :procedure-id)
                                             (getf aut :procedure-id))))))
(ok "[IX-b] and this program keeps NO identity-to-object resolver and NO private provenance table: neither symbol is even interned"
    (and (null (find-symbol "*CLAIM-REGISTRY*"))
         (null (find-symbol "*PROVENANCE*"))
         (null (find-symbol "RESOLVE-CLAIM-IDENTITY"))
         (null (find-symbol "*WORKSHOP-GRANTS*")))
    "the missing public convenience is an identity-to-object resolver; it is named here and not invented here")

;;; --- 9b. grounding cardinalities, counted -----------------------------
(format t "~%   9b. grounding multiplicity — counted across every receipt, not asserted:~%")
(let* ((cardinalities
         (loop for r in *all-receipts*
               append (loop for a in (lisp-plus-slice1:derivation-receipt-assessments r)
                            collect (length (lisp-plus-slice1:premise-assessment-ground-instances a)))))
       (maximum (reduce #'max cardinalities :initial-value 0))
       (plural (count-if (lambda (n) (> n 1)) cardinalities)))
  (format t "     ~D receipt~:P, ~D premise assessment~:P; cardinalities ~A; maximum ~D; plural ~D~%"
          (length *all-receipts*) (length cardinalities)
          (fmt (sort (remove-duplicates cardinalities) #'<)) maximum plural)
  (ok "[IX-c] plural grounding AROSE NATURALLY and was not staged: two independent laboratory assays, and two authorized treatments under one custody log"
      (and (= 2 maximum) (>= plural 2))
      "the normative plural reader did the counting; the singular projection was never read above cardinality one")
  (ok "[IX-d] every complete ground environment was preserved wherever plurality occurred — no representative was ever selected"
      (and (= 2 (length (lisp-plus-slice1:derivation-receipt-complete-binding-environments
                         *material-humid-receipt*)))
           (= 2 (length (lisp-plus-slice1:derivation-receipt-complete-binding-environments
                         *documented-receipt*)))
           (null (lisp-plus-slice1:derivation-receipt-uniqueness-conflicts
                  *material-humid-receipt*))
           (null (lisp-plus-slice1:derivation-receipt-uniqueness-conflicts
                  *documented-receipt*)))))

;;; --- 9c. the two planted controls ------------------------------------
(format t "~%   9c. the two planted controls — a check that has never failed is untested:~%")

;;; Control 1: remove the receiving bench's access to ONE branch claim and prove
;;; the reconvergence fails :INACCESSIBLE rather than quietly granting.
(multiple-value-bind (claim receipt)
    (authorize :controlled-humidification *material-humid* *authority-humid*
               :receiver (at-the-bench *authority-humid*))
  (record-receipt receipt)
  (ok "[IX-e] CONTROL 1 — access removed from the MATERIAL branch: the reconvergence fails :INACCESSIBLE, and it is the material premise that fails"
      (and (null claim)
           (eq :inaccessible (disposition-of receipt :treatment-materially-suitable))
           (eq :satisfied (disposition-of receipt :treatment-institutionally-authorized)))
      "the mirror of arm D, planted on the other branch: reconvergence is symmetric and both premises are load-bearing"))

;;; Control 2: substitute a fabricated effect witness and prove the PROBE grants
;;; while the production path declines it. The two facts must hold together, or
;;; the workshop's refusal is decoration.
(ok "[IX-f] CONTROL 2 — a fabricated effect witness GRANTS on the probe path, and the production path declines that grant in the same run"
    (and (eq :granted (lisp-plus-slice1:derivation-receipt-decision *fabricated-probe-receipt*))
         (eq :satisfied (disposition-of *fabricated-probe-receipt* :treatment-completed))
         (eq :treated-unassessed (wo-state *wo-humid*))
         (eq :not-safe-to-exhibit (xr-decision *exhibition*))
         (null (wo-completed-on *wo-humid*)))
    "the grant is real and the workshop's file does not contain it")


;;;; ==================================================================
;;;; CLOSING

(format t "~%-- what this application does NOT show --~%")
(format t "   No crash survival. The interrupted press's account survived because~%")
(format t "   the IMAGE did. The chamber and the press are one labelled scripted~%")
(format t "   fake adapter, never AP0-conformant, and nothing above licenses any~%")
(format t "   conformance language. All greens here are self-consistency~%")
(format t "   certification: one model family wrote the language, the application~%")
(format t "   and these checks.~%")
(format t "~%   And Movement VII proves NOTHING about effects being unverifiable in~%")
(format t "   principle. It reports what the current public surface does with a~%")
(format t "   TRUE structured account of a treatment that really happened: no~%")
(format t "   governed operation consumes it, so a completion judgment rests on a~%")
(format t "   minted witness or it does not happen. That is a statement about~%")
(format t "   Slice /0 plus Slice /1 plus Core /0 as they stand on day 4183 of the~%")
(format t "   workshop's count, and about nothing else. No bridge is proposed and~%")
(format t "   none should be read in.~%")
(format t "~%   Nor does the fabricated-witness finding say the language is unsound.~%")
(format t "   It says the mode reserved for first-hand observation is a mode the~%")
(format t "   program asserts, and that the workshop's honesty in asserting it is~%")
(format t "   carried by the conservator. Movements II to VI show what the same~%")
(format t "   program looks like where a JUDGMENT carries it instead, and the~%")
(format t "   difference between those two halves is the whole finding.~%")

(format t "~%de-codice-restaurando: ~D checks passed / ~D failed~%" *pass* *fail*)
(format t "(a workshop that can refuse for the object's sake and for the owner's~%")
(format t " sake in two different voices, that will not press a sheet twice~%")
(format t " because its bookkeeping is uncertain, and that holds a true account~%")
(format t " of a treatment it cannot lawfully use to close the file)~%")
(finish-output)
(sb-ext:exit :code (if (zerop *fail*) 0 1))
